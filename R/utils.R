# Some commonly used functions

#' Size of an object
#'
#' @param x - any R object
#' @param level1
#' @param units
#' @param sort
#' @param decreasing
#' @param byteTol
#' @param asNumeric
#'
#' @return
#' @export
#'
#' @examples
#' size(1)
#' size(rep(1, 1e3))
#' size(rep(1L, 1e3))
size <- function(x, level1 = FALSE, units = "auto", sort = TRUE,
                 decreasing = FALSE, byteTol = 0, asNumeric = FALSE) {
  # browser()
  if (!level1) {
    format(object.size(x), units = units)
  } else {
    if (isS4(x)) { # S4
      slx <- slotNames(x)
      val <- lapply(slx, function(z) {
        object.size(slot(x, z))
      })
      names(val) <- slx
      # return(val)
    } else if (is.list(x)) {
      val <- lapply(x, function(z) {
        object.size(z)
      })
    } else {
      format(object.size(x), units = units)
    }
    vv <- lapply(val, as.numeric) # in bytes
    if (sort) {
      ii <- order(unlist(vv), decreasing = decreasing)
      val <- val[ii]
      vv <- vv[ii]
    }
    if (asNumeric) {
      val <- vv
    } else {
      val <- lapply(val, function(z) {
        format(z, units = units)
      })
    }
    # browser()
    ii <- vv >= byteTol
    val[ii]
  }
}

if (F) { # Check
  size(scen, 1, "Mb", byteTol = 1024)
  size(scen@modInp, 1, "Mb", byteTol = 1024)
  size(scen@modInp@parameters, 1, "Mb", byteTol = 1024 * 1000)
  size(scen@modInp@parameters$pTradeIrEff, 1, "Mb", byteTol = 1024 * 1000)
  size(scen@modInp@parameters$pTradeIrEff@data, 1, "Mb", byteTol = 0, asNumeric = T)
  head(scen@modInp@parameters$pTradeIrEff@data)
}


.fix_path <- function(x) {
  gsub("[\\/]+", "/", paste0(x, "/"))
}


#' Check validity of object names
#'
#' @param x character, name of an object of `energyRt`
#'
#' @return logical, TRUE if the name is valid.
#' @export
#'
#' @examples
check_name <- function(x) {
  (length(x) != 1 || !is.character(x) ||
    sub("^[[:alpha:]][[:alnum:]_]*$", "", x) == "")
}

#' Function to find duplicated values in interpolated scenario.
#'
#' @param x scenario or data.frame with data to check.
#'
#' @return
#' @export
#'
#' @examples
findDuplicates <- function(x) {
  if (class(x) == 'scenario') {
    rs <- NULL
    for (pr in names(x@modInp@parameters))
      if (x@modInp@parameters[[pr]]@type %in% c('single', 'bounds')) {
        tmp <- x@modInp@parameters[[pr]]@data
        tmp <- tmp[, -ncol(tmp), drop = FALSE]
        fl <- duplicated(tmp)
        if (any(fl)) {
          tmp <- tmp[fl,, drop = FALSE]
          tmp$parameter <- pr
          tmp <- tmp[, c(ncol(tmp), 1:(ncol(tmp) - 1)), drop = FALSE]
          rs <- rbind(rs, tmp)
        }
      }
    if (!is.null(rs)) {
      cat(paste0("Found ", length(unique(rs$parameter)),
                 " tables with duplicates, ", nrow(rs),
                 " duplicated rows in total\n"))
      return(invisible(rs))
    }
  }
  findDuplicates0 <- function(x) {
    check_by_slots <- function(x, slt_name) {
      rs <- NULL
      for (i in slt_name) {
        slt <- slot(x, i)
        set_slot <- colnames(slt)[
          colnames(slt) %in% c('acomm',
                               energyRt:::.set_al[
                                 !(energyRt:::.set_al %in% c('dem'))
                               ])]
        value_slot <- colnames(slt)[!(colnames(slt) %in% set_slot)]
        fl <- !is.na(slt[, value_slot, drop = FALSE])
        if (any(fl)) {
          for (j in value_slot[apply(fl, 2, any)]) {
            f2 <- duplicated(slt[fl[, j], set_slot, drop = FALSE])
            if (any(f2)) {
              rs <- rbind(rs, data.frame(slot = i, parameter = j,
                                         value = sum(f2),
                                         stringsAsFactors = FALSE))
            }
          }
        }
      }
      return(rs)
    }
    res <- data.frame(repository = character(), object = character(),
                      slot = character(), parameter = character(),
                      stringsAsFactors = FALSE)
    if (class(x) == 'model') {
      rs <- NULL
      for (i in seq_along(x@data)) {
        tmp <- findDuplicates0(x@data[[i]])
        if (!is.null(tmp)) {
          tmp$repository <- x@data[[i]]@name
          rs <- rbind(rs, tmp)
        }
      }
      tmp <- findDuplicates0(x@sysInfo)
      if (!is.null(tmp)) {
        tmp$repository <- '-'
        tmp$object <- 'sysInfo'
        rs <- rbind(rs, tmp[, c(ncol(tmp), 2:ncol(tmp) - 1)])
      }
      if (is.null(rs)) return(NULL)
      return(rs[, c(ncol(rs), 1:(ncol(rs) - 1))])
    } else
      if (class(x) == 'repository') {
        rs <- NULL
        for (i in seq_along(x@data)) {
          tmp <- findDuplicates0(x@data[[i]])
          if (!is.null(tmp)) {
            tmp$object <- x@data[[i]]@name
            rs <- rbind(rs, tmp)
          }
        }
        if (is.null(rs)) return(NULL)
        return(rs[, c(ncol(rs), 1:(ncol(rs) - 1))])
      } else
        if (class(x) %in% c('tax', 'sub', 'weather', 'supply',
                            'import', 'export', 'trade', 'technology',
                            'demand', 'storage')) {
          slt_name <- getSlots(class(x))
          slt_name <- names(slt_name)[
            slt_name == 'data.frame' &
              !(names(slt_name) %in% c('input', 'output', 'aux'))]
          return(check_by_slots(x, slt_name))
        } else if (class(x) %in% c('constraint')) {
          tmp <- check_by_slots(x, c('rhs', 'for.each'))
          for (y in seq_along(x@lhs)) {
            nn <- check_by_slots(x@lhs[[y]], 'mult')
            if (!is.null(nn)) {
              nn$slot <- paste('lhs', y, nn$slot)
              tmp <- rbind(tmp, nn)
            }
          }
          return(tmp)
        } else if (class(x) %in% c('costs')) {
          tmp <- check_by_slots(x, c('for.sum', 'for.each', 'mult'))
          return(tmp)
        } else if (class(x) %in% c('slice', 'commodity')) {
        } else if (class(x) %in% c('sysInfo')) {
          return(check_by_slots(x, c('debug', 'discount')))
        } else warning(paste0('Unknown class "', class(x), '"'))
    NULL
  }
  rs <- findDuplicates0(x)
  if (!is.null(rs)) {
    # cat(paste0("There are ", nrow(rs), " duplicates, sum of values: ", sum(rs$value), "\n"))
    cat(paste0("Found ", nrow(rs), " tables with duplicates,",
               sum(rs$value), "duplicated rows in total\n"))
    return(invisible(rs))
  }

}

fact2char <- function(df, asTibble = TRUE) {
  stopifnot(is.data.frame(df))
  jj <- sapply(df, is.factor)
  for (j in names(df)[jj]) {
    df[[j]] <- as.character(df[[j]])
  }
  if (asTibble) {df <- as_tibble(df)}
  df
}
