[moved to interpolation.R]

#' #' Internal function to interpolate 'simple' parameter
#' #'
#' #' @param dtf data.frame, a slot with the data for interpolation.
#' #' @param parameter character, name of the column in the `dtf` to interpolate.
#' #' @param mtp class `parameter` to add interpolated data (in `modInp`).
#' #' @param approxim list with interpolation rules
#' #' @param add_set_name character, name of set to add element
#' #' @param add_set_value character, the element to add to the set
#' #' @param remove_duplicate
#' #' @param all.val
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' simpleInterpolation <- function(
#'     dtf, parameter, mtp, approxim,
#'     add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL,
#'     # removeDefault = TRUE, # not used
#'     # remValue = NULL, # not used
#'     all.val = FALSE) {
#'   has_year_col <- any(colnames(dtf) == "year")
#'   if (approxim$fullsets && mtp@defVal != 0 && mtp@defVal != Inf) all.val <- TRUE
#'   if (!all.val && nrow(dtf) == 0) {
#'     return(NULL)
#'   }
#'
#'   if (!is.null(mtp@misc$not_need_interpolate)) {
#'     # approxim <- approxim[!(names(approxim) %in% mtp@misc$not_need_interpolate)]
#'     dtf <- dtf[, !(colnames(dtf) %in% mtp@misc$not_need_interpolate), drop = FALSE]
#'     if (any(mtp@misc$not_need_interpolate == "year")) has_year_col <- FALSE
#'     fl <- add_set_name %in% mtp@misc$not_need_interpolate
#'     if (any(fl)) {
#'       add_set_name <- add_set_name[!fl]
#'       add_set_value <- add_set_value[!fl]
#'     }
#'     dtf <- dtf[!duplicated(dtf), , drop = FALSE]
#'   }
#'
#'   dd <- .interpolation(dtf, parameter,
#'     rule = mtp@interpolation,
#'     defVal = mtp@defVal,
#'     year_range = range(approxim$year),
#'     approxim = approxim, all = all.val
#'   )
#'
#'   if (is.null(dd)) {
#'     return(NULL)
#'   }
#'   if (!all.val) {
#'     dd <- dd[dd[[ncol(dd)]] != 0, , drop = FALSE]
#'     if (nrow(dd) == 0) {
#'       return(NULL)
#'     }
#'   }
#'   # Must fixed in the future
#'   colnames(dd)[[ncol(dd)]] <- "value"
#'   for (i in colnames(dd)[-ncol(dd)]) {
#'     dd[[i]] <- as.character(dd[[i]])
#'   }
#'   if (has_year_col) dd[["year"]] <- as.numeric(dd[["year"]])
#'   if (is.null(add_set_name)) {
#'     dd <- dd[, c(mtp@dimSets, "value"), drop = FALSE]
#'   } else {
#'     d3 <- data.frame(stringsAsFactors = FALSE)
#'     for (i in 1:length(add_set_value)) {
#'       d3[1:nrow(dd), i] <- rep(add_set_value[i])
#'     }
#'     colnames(d3) <- add_set_name
#'     stnd <- mtp@dimSets[-(1:length(d3))]
#'     # It was added for trading routes
#'     if (sum(stnd %in% c("src", "dst")) == 2) {
#'       stnd <- c(stnd[stnd != "src" & stnd != "dst"], "region")
#'     }
#'     stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]
#'     if (any(ls(globalenv()) == "KKK")) browser()
#'     dd <- cbind(d3, dd[, c(stnd, "value"), drop = FALSE])
#'   }
#'   if (!is.null(remove_duplicate) && nrow(dd) != 0) {
#'     fl <- rep(TRUE, nrow(dd))
#'     for (i in seq_along(remove_duplicate)) {
#'       fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
#'     }
#'     dd <- dd[fl, , drop = FALSE]
#'   }
#'   if (has_year_col && !is.null(approxim$mileStoneYears)) {
#'     dd <- dd[dd$year %in% approxim$mileStoneYears, , drop = FALSE]
#'   }
#'   if (nrow(dd) == 0) {
#'     return(NULL)
#'   }
#'
#'   dd
#' }
#'
#' #' Internal funtion to interpolate 'multi' parameter
#' #'
#' #' @param dtf
#' #' @param parameter
#' #' @param mtp
#' #' @param approxim
#' #' @param add_set_name
#' #' @param add_set_value
#' #' @param remove_duplicate
#' #' @param remValueUp
#' #' @param remValueLo
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' multiInterpolation <- function(
#'     dtf, parameter, mtp, approxim,
#'     add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL,
#'     remValueUp = NULL, remValueLo = NULL) {
#'   has_year_col <- any(colnames(dtf) == "year")
#'   if (!is.null(mtp@misc$not_need_interpolate)) {
#'     dtf <- dtf[, !(colnames(dtf) %in% mtp@misc$not_need_interpolate), drop = FALSE]
#'     if (any(mtp@misc$not_need_interpolate == "year")) has_year_col <- FALSE
#'     fl <- add_set_name %in% mtp@misc$not_need_interpolate
#'     if (any(fl)) {
#'       add_set_name <- add_set_name[!fl]
#'       add_set_value <- add_set_value[!fl]
#'     }
#'     dtf <- dtf[!duplicated(dtf), , drop = FALSE]
#'   }
#'
#'   dd <- .interpolation_bound(dtf, parameter,
#'     defVal = mtp@defVal,
#'     rule = mtp@interpolation,
#'     year_range = range(approxim$year),
#'     approxim = approxim
#'   )
#'   if (is.null(dd)) {
#'     return(NULL)
#'   }
#'   dd <- dd[dd[[ncol(dd)]] != 0 | dd$type == "up", , drop = FALSE]
#'   if (nrow(dd) == 0) {
#'     return(NULL)
#'   }
#'
#'   colnames(dd)[[ncol(dd)]] <- "value"
#'   for (i in colnames(dd)[-ncol(dd)]) {
#'     dd[[i]] <- as.character(dd[[i]])
#'   }
#'   if (has_year_col) dd[["year"]] <- as.numeric(dd[["year"]])
#'   if (is.null(add_set_name)) {
#'     dd <- dd[, c(mtp@dimSets, "type", "value"), drop = FALSE]
#'   } else {
#'     d3 <- data.frame(stringsAsFactors = FALSE)
#'     for (i in 1:length(add_set_value)) {
#'       d3[1:nrow(dd), i] <- rep(add_set_value[i])
#'     }
#'     colnames(d3) <- add_set_name
#'     stnd <- mtp@dimSets[-(1:length(d3))]
#'     # It was added for trading routes
#'     if (sum(stnd %in% c("src", "dst")) == 2) {
#'       stnd <- c(stnd[stnd != "src" & stnd != "dst"], "region")
#'     }
#'     stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]
#'
#'     dd <- cbind(d3, dd[, c(stnd, "type", "value"), drop = FALSE])
#'   }
#'   dd <- dd[(dd$type == "lo") | (dd$type == "up"), , drop = FALSE]
#'   if (!is.null(remove_duplicate) && nrow(dd) != 0) {
#'     fl <- rep(TRUE, nrow(dd))
#'     for (i in seq_along(remove_duplicate)) {
#'       fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
#'     }
#'     dd <- dd[fl, , drop = FALSE]
#'   }
#'   if (has_year_col && !is.null(approxim$mileStoneYears)) {
#'     dd <- dd[dd$year %in% approxim$mileStoneYears, , drop = FALSE]
#'   }
#'   if (nrow(dd) == 0) {
#'     return(NULL)
#'   }
#'   dd
#' }
