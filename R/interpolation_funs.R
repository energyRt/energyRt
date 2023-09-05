#' Internal function to interpolate parameter (column) in the given data.frame
#'
#' @param dtf data.frame, normally a slot of an object with parameters and sets.
#' @param parameter character, name of parameter to interpolate.
#' @param defVal numeric, default value of a parameter.
#' @param arg list with interpolation settings.
#'
#' @return
#'
#' @examples
.interpolation0 <- function(dtf, parameter, defVal, arg) {
  # browser()
  # dtf <- interpolation_message$interpolation0_arg$dtf;
  # parameter <- interpolation_message$interpolation0_arg$parameter;
  # defVal <- interpolation_message$interpolation0_arg$defVal;
  # arg <- interpolation_message$interpolation0_arg$arg;
  # Remove not used approxim
  # print()
  if (length(defVal) != 1) stop("defVal value is not defined")
  if (arg$approxim$fullsets && defVal != 0 && defVal != Inf) arg$all <- TRUE

  # Get slice
  prior <- c(
    "stg", "trade", "tech", "sup", "group", "acomm", "comm", "commp", "region",
    "regionp", "src", "dst", "slice", "year"
  )
  true_prior <- c(
    "stg", "trade", "tech", "sup", "group", "acomm", "comm", "commp", "region",
    "regionp", "src", "dst", "year", "slice"
  )
  rule <- arg$rule
  approxim <- arg$approxim
  if (is.null(approxim)) {
    approxim <- list()
    for (i in names(arg)[!(names(arg) %in% c("rule", "approxim", "year_range"))]) {
      approxim[[i]] <- arg[[i]]
    }
  }
  approxim <- approxim[names(approxim) %in% prior]
  there.are.year <- any(colnames(dtf) == "year")
  if (there.are.year && any(names(arg) == "year_range") &&
    all(names(approxim) != "year")) {
    approxim$year <- arg$year_range
  }
  prior <- prior[prior %in% names(approxim)]
  prior <- prior[prior %in% colnames(dtf)[-ncol(dtf)]]
  true_prior <- true_prior[true_prior %in% prior]
  approxim <- approxim[names(approxim) %in% prior]
  # Remove excess column
  dtf <- dtf[, colnames(dtf) %in% c(prior, parameter), drop = FALSE]
  # Sort column
  dtf <- dtf[, c(
    prior[prior %in% colnames(dtf)],
    colnames(dtf)[ncol(dtf)]
  ), drop = FALSE]
  dtf <- dtf[!is.na(dtf[, parameter]), , drop = FALSE]
  if (anyDuplicated(dtf[, -ncol(dtf)])) {
    jjj <- sys.status()
    kkk <- sapply(jjj$sys.calls, function(x) any(grep(".obj2modInp", x[1])))
    if (sum(kkk) == 0) {
      warning("Duplicated values found and dropped. Use findDuplicates()",
              " function for the identification.")
    } else {
      tst_env <- jjj$sys.frames[[max(seq_along(kkk)[kkk])]]
      tst_exm <- get("app", tst_env)
      warning(paste0(
        '"Duplicated values found (class "', class(tst_exm), '", name "',
        tst_exm@name, '", parameter: "', parameter, '") and dropped.'
      ))
    }
    dtf <- dtf[!duplicated(dtf[, -ncol(dtf)], fromLast = TRUE), ]
  }
  if (nrow(dtf) == 0 && (is.null(arg$all) || !arg$all)) {
    return(NULL)
  }
  if (ncol(dtf) == 1) {
    if (nrow(dtf) == 0) dtf[1, 1] <- defVal
    return(dtf)
  }
  # Check if interpolation is needed
  approxim2 <- approxim
  if (!is.null(dtf$year)) {
    approxim2$year <- arg$approxim$mileStoneYears
    if (is.null(approxim2$year)) {
      approxim2$year <- arg$approxim$year
    }
  }
  tmp_nona <- (!is.na(dtf[, -ncol(dtf), drop = FALSE]))
  if (all(tmp_nona)) { # There is not NA column
    possible_comb <- prod(sapply(approxim2, length))
    if (nrow(dtf) >= possible_comb) {
      obj3 <- dtf
      for (i in names(approxim2)) {
        obj3 <- obj3[obj3[[i]] %in% approxim2[[i]], , drop = FALSE]
      }
      if (nrow(obj3) == possible_comb) {
        return(obj3)
      }
    }
  } else { # There are only NA and not NA column
    f1 <- apply(tmp_nona, 2, any)
    f2 <- apply(tmp_nona, 2, all)
    if (all(f1 == f2)) { # Could be small appr
      obj2 <- dtf[, c(f1, TRUE), drop = FALSE]
      for (i in colnames(obj2)[-ncol(obj2)]) {
        obj2 <- obj2[obj2[[i]] %in% approxim2[[i]], , drop = FALSE]
      }
      if (ncol(obj2) == 1 || nrow(obj2) == prod(
        sapply(approxim2[names(obj2)[-ncol(obj2)]], length)
      )) { # Simple approximation is applicable
        for (i in names(dtf)[c(!f1, FALSE)]) {
          obj2 <- merge0(obj2, approxim2[i])
        }
        return(obj2[, colnames(dtf)])
      }
    }
  }
  # Real interpolation
  if (there.are.year) {
    year_range <- arg$year_range
    yy <- range(c(
      year_range[1], year_range[2],
      dtf$year
    ), na.rm = TRUE)
    approxim$year <- yy[1]:yy[2]
    apr <- approxim[c("year", true_prior[true_prior != "year"])]
    if (any(sapply(apr, length) == 0)) {
      return(NULL)
    }
    dd <- as.data.frame.table(array(NA,
      dim = sapply(apr, length),
      dimnames = apr
    ), stringsAsFactors = FALSE, responseName = parameter)
    dd <- dd[, c(prior, parameter), drop = FALSE]
  } else {
    dd <- as.data.frame.table(array(NA,
      dim = sapply(approxim, length),
      dimnames = approxim
    ), stringsAsFactors = FALSE, responseName = parameter)
  }
  if (nrow(dtf) != 0) {
    ii <- 2^(seq(length.out = ncol(dtf) - 1) - 1)
    KK <- colSums(ii * t(is.na(dtf[, true_prior[true_prior %in% prior],
                                   drop = FALSE])))
    dobj <- as.matrix(dtf[, -ncol(dtf), drop = FALSE])
    ddd <- t(as.matrix(dd[, -ncol(dd), drop = FALSE]))
    dff <- dd[, -ncol(dd), drop = FALSE]
    dtf <- dtf[, c(colnames(dff), parameter), drop = FALSE]
    for (i in 1:ncol(dff)) dff[, i] <- as.factor(as.character(dff[, i]))
    for (i in 1:ncol(dff)) dtf[, i] <- factor(as.character(dtf[[i]]),
                                              levels = levels(dff[, i]))
    for (i in 1:ncol(dff)) dtf[, i] <- as.numeric(dtf[[i]])
    for (i in 1:ncol(dff)) dff[, i] <- as.numeric(dff[, i])
    hh <- sapply(dff, max)
    hh <- c(1, cumprod(hh[-length(hh)]))
    dff <- as.matrix(dff)
    dtf <- as.matrix(dtf)
    for (i in 1:ncol(dff)) {
      dff[, i] <- hh[i] * (dff[, i] - 1)
      dtf[, i] <- hh[i] * (dtf[, i] - 1)
    }
    # check all(sort(rowSums(dff)) == 0:max(rowSums(dff)))
    for (i in rev(sort(unique(KK)))) {
      fl <- seq(along = KK)[KK == i]
      # dff <- dd[fl, -ncol(dd), drop = FALSE]
      mx <- !is.na(dtf[fl[1], -ncol(dtf)])
      # gg <- rowSums(dtf[fl, -ncol(dtf), drop = FALSE])
      r1 <- rowSums(dff[, mx, drop = FALSE])
      r2 <- rowSums(dtf[fl, c(mx, FALSE), drop = FALSE])
      ll <- dtf[fl, ncol(dtf)]
      names(ll) <- r2
      nn <- (r1 %in% r2)
      dd[nn, ncol(dd)] <- ll[as.character(r1[nn])]
    }
  }
  # Interpolation
  if (!there.are.year) {
    dd[is.na(dd[, parameter]), parameter] <- defVal
  } else {
    if (all(is.na(dd[, parameter]))) {
      dd[is.na(dd[, parameter]), parameter] <- defVal
    } else if (any(is.na(dd[, parameter]))) {
      mx <- matrix(dd[, parameter], length(approxim$year))
      f1 <- apply(!is.na(mx), 2, all)
      if (any(!f1)) {
        gg <- seq(along = f1)[!f1][apply(is.na(mx[, !f1, drop = FALSE]), 2, all)]
        mx[, gg] <- defVal
        f1[gg] <- TRUE
      }
      if (any(!f1)) {
        nr <- nrow(mx)
        back <- any(grep("back", rule))
        forth <- any(grep("forth", rule))
        inter <- any(grep("inter", rule))
        ## Group by similiarity
        for (ee in seq(along = f1)[!f1]) {
          ll <- ee
          # Approximate
          hh <- mx[, ee[1]]
          # Back
          if (is.na(hh[1])) {
            hm <- (1:nr)[!is.na(hh)][1]
            if (back) hh[1:(hm - 1)] <- hh[hm] else hh[1:(hm - 1)] <- defVal
          }
          # Forth
          if (is.na(hh[nr])) {
            hm <- max((1:nr)[!is.na(hh)])
            if (forth) hh[(hm + 1):nr] <- hh[hm] else hh[(hm + 1):nr] <- defVal
          }
          # Inter
          if (any(is.na(hh))) {
            if (!inter) {
              hh[is.na(hh)] <- defVal
            } else {
              hm <- is.na(hh)
              bg <- (1:(nr - 1))[hm[-1] & !hm[-nr]]
              en <- (2:nr)[!hm[-1] & hm[-nr]]
              for (i in seq(along = bg)) {
                hh[bg[i]:en[i]] <- seq(hh[bg[i]], hh[en[i]],
                  length.out = en[i] - bg[i] + 1
                )
              }
            }
          }
          # Assign
          mx[, ll] <- hh
          f1[ll] <- TRUE
        }
      }
      dd[, parameter] <- c(mx)
    }
    if (any(colnames(dtf)[-ncol(dtf)] == "slice")) {
      dd <- dd[, c(true_prior, parameter), drop = FALSE]
    }
    if (length(approxim$year) != year_range[2] - year_range[1] + 1) {
      dd <- dd[rep(
        year_range[1] <= approxim$year & approxim$year <= year_range[2],
        nrow(dd) / length(approxim$year)
      ), , drop = FALSE]
    }
  }
  return(dd)
}

#' Internal function to interpolate parameter in given data.frame
#'
#' @param dtf data.frame, normally a slot of an object with parameters and sets.
#' @param parameter character, name of parameter to interpolate.
#' @param defVal numeric, default value of a parameter.
#' @param ... interpolation parameters.
#'
#' @param
#'
#' @return
#'
#' @examples
.interpolation <- function(dtf, parameter, defVal, ...) {
  arg <- list(...)
  tryCatch(
    {
      .interpolation0(dtf, parameter, defVal, arg)
    },
    error = function(cond) {
      assign("interpolation_message", list(
        tracedata = sys.calls(),
        interpolation0_arg = list(
          dtf = dtf, parameter = parameter,
          defVal = defVal, arg = arg
        )
      ), globalenv())
      message(
        "\nInterpolation error, more information in",
        ' "interpolation_message" object\n'
      )
      stop(cond)
    }
  )
}

# setMethod(".interpolation_bound", signature(dtf = 'data.frame',
#   parameter = 'character', defVal = 'numeric', rule = 'character'),

#' Internal function to interpolate bounds in a given data.frame
#'
#' @param dtf data.frame, normally a slot of an object with parameters and sets.
#' @param parameter character, name of parameter to interpolate.
#' @param defVal numeric, default value of a parameter.
#' @param rule character, interpolation rule.
#' @param ... list of additional interpolation settings.
#'
#' @return
#' @export
#'
#' @examples
.interpolation_bound <- function(dtf, parameter, defVal, rule, ...) {
  gg <- paste(parameter, c(".lo", ".fx", ".up"), sep = "")
  aa <- dtf[, !(colnames(dtf) %in% gg), drop = FALSE]
  aa[, parameter] <- rep(NA, nrow(aa))
  a1 <- aa
  a1[, parameter] <- dtf[, gg[1]]
  a2 <- aa
  a2[, parameter] <- dtf[, gg[2]]
  a3 <- aa
  a3[, parameter] <- dtf[, gg[3]]
  d1 <- .interpolation(rbind(a1, a2), parameter,
    defVal = defVal[1], rule = rule[1], ...
  )
  if (!is.null(d1)) {
    dd <- d1[, -ncol(d1), drop = FALSE]
    dd[, "type"] <- "lo"
    dd[, parameter] <- d1[, parameter]
  }
  d2 <- .interpolation(rbind(a3, a2), parameter,
    defVal = defVal[2], rule = rule[2], ...
  )
  if (!is.null(d2)) {
    mx <- d2[, -ncol(d2), drop = FALSE]
    mx[, "type"] <- "up"
    mx[, parameter] <- d2[, parameter]
  }
  if (!is.null(d1) && !is.null(d2)) {
    return(rbind(dd, mx))
  } else if (!is.null(d1)) {
    return(dd)
  } else if (!is.null(d2)) {
    return(mx)
  } else {
    return(NULL)
  }
}

#' Internal function to interpolate 'simple' parameter
#'
#' @param dtf data.frame, a slot with the data for interpolation.
#' @param parameter character, name of the column in the `dtf` to interpolate.
#' @param mtp class `parameter` to add interpolated data (in `modInp`).
#' @param approxim list with interpolation rules
#' @param add_set_name character, name of set to add element
#' @param add_set_value character, the element to add to the set
#' @param remove_duplicate
#' @param all.val
#'
#' @return
#' @export
#'
#' @examples
simpleInterpolation <- function(
    dtf, parameter, mtp, approxim,
    add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL,
    # removeDefault = TRUE, # not used
    # remValue = NULL, # not used
    all.val = FALSE) {
  has_year_col <- any(colnames(dtf) == "year")
  if (approxim$fullsets && mtp@defVal != 0 && mtp@defVal != Inf) all.val <- TRUE
  if (!all.val && nrow(dtf) == 0) {
    return(NULL)
  }

  if (!is.null(mtp@misc$not_need_interpolate)) {
    # approxim <- approxim[!(names(approxim) %in% mtp@misc$not_need_interpolate)]
    dtf <- dtf[, !(colnames(dtf) %in% mtp@misc$not_need_interpolate), drop = FALSE]
    if (any(mtp@misc$not_need_interpolate == "year")) has_year_col <- FALSE
    fl <- add_set_name %in% mtp@misc$not_need_interpolate
    if (any(fl)) {
      add_set_name <- add_set_name[!fl]
      add_set_value <- add_set_value[!fl]
    }
    dtf <- dtf[!duplicated(dtf), , drop = FALSE]
  }

  dd <- .interpolation(dtf, parameter,
                       rule = mtp@interpolation,
                       defVal = mtp@defVal,
                       year_range = range(approxim$year),
                       approxim = approxim, all = all.val
  )

  if (is.null(dd)) {
    return(NULL)
  }
  if (!all.val) {
    dd <- dd[dd[[ncol(dd)]] != 0, , drop = FALSE]
    if (nrow(dd) == 0) {
      return(NULL)
    }
  }
  # Must fixed in the future
  colnames(dd)[[ncol(dd)]] <- "value"
  for (i in colnames(dd)[-ncol(dd)]) {
    dd[[i]] <- as.character(dd[[i]])
  }
  if (has_year_col) dd[["year"]] <- as.numeric(dd[["year"]])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSets, "value"), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for (i in 1:length(add_set_value)) {
      d3[1:nrow(dd), i] <- rep(add_set_value[i])
    }
    colnames(d3) <- add_set_name
    stnd <- mtp@dimSets[-(1:length(d3))]
    # It was added for trading routes
    if (sum(stnd %in% c("src", "dst")) == 2) {
      stnd <- c(stnd[stnd != "src" & stnd != "dst"], "region")
    }
    stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]
    if (any(ls(globalenv()) == "KKK")) browser()
    dd <- cbind(d3, dd[, c(stnd, "value"), drop = FALSE])
  }
  if (!is.null(remove_duplicate) && nrow(dd) != 0) {
    fl <- rep(TRUE, nrow(dd))
    for (i in seq_along(remove_duplicate)) {
      fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
    }
    dd <- dd[fl, , drop = FALSE]
  }
  if (has_year_col && !is.null(approxim$mileStoneYears)) {
    dd <- dd[dd$year %in% approxim$mileStoneYears, , drop = FALSE]
  }
  if (nrow(dd) == 0) {
    return(NULL)
  }

  dd
}

#' Internal funtion to interpolate 'multi' parameter
#'
#' @param dtf
#' @param parameter
#' @param mtp
#' @param approxim
#' @param add_set_name
#' @param add_set_value
#' @param remove_duplicate
#' @param remValueUp
#' @param remValueLo
#'
#' @return
#' @export
#'
#' @examples
multiInterpolation <- function(
    dtf, parameter, mtp, approxim,
    add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL,
    remValueUp = NULL, remValueLo = NULL) {
  has_year_col <- any(colnames(dtf) == "year")
  if (!is.null(mtp@misc$not_need_interpolate)) {
    dtf <- dtf[, !(colnames(dtf) %in% mtp@misc$not_need_interpolate), drop = FALSE]
    if (any(mtp@misc$not_need_interpolate == "year")) has_year_col <- FALSE
    fl <- add_set_name %in% mtp@misc$not_need_interpolate
    if (any(fl)) {
      add_set_name <- add_set_name[!fl]
      add_set_value <- add_set_value[!fl]
    }
    dtf <- dtf[!duplicated(dtf), , drop = FALSE]
  }

  dd <- .interpolation_bound(dtf, parameter,
                             defVal = mtp@defVal,
                             rule = mtp@interpolation,
                             year_range = range(approxim$year),
                             approxim = approxim
  )
  if (is.null(dd)) {
    return(NULL)
  }
  dd <- dd[dd[[ncol(dd)]] != 0 | dd$type == "up", , drop = FALSE]
  if (nrow(dd) == 0) {
    return(NULL)
  }

  colnames(dd)[[ncol(dd)]] <- "value"
  for (i in colnames(dd)[-ncol(dd)]) {
    dd[[i]] <- as.character(dd[[i]])
  }
  if (has_year_col) dd[["year"]] <- as.numeric(dd[["year"]])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSets, "type", "value"), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for (i in 1:length(add_set_value)) {
      d3[1:nrow(dd), i] <- rep(add_set_value[i])
    }
    colnames(d3) <- add_set_name
    stnd <- mtp@dimSets[-(1:length(d3))]
    # It was added for trading routes
    if (sum(stnd %in% c("src", "dst")) == 2) {
      stnd <- c(stnd[stnd != "src" & stnd != "dst"], "region")
    }
    stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]

    dd <- cbind(d3, dd[, c(stnd, "type", "value"), drop = FALSE])
  }
  dd <- dd[(dd$type == "lo") | (dd$type == "up"), , drop = FALSE]
  if (!is.null(remove_duplicate) && nrow(dd) != 0) {
    fl <- rep(TRUE, nrow(dd))
    for (i in seq_along(remove_duplicate)) {
      fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
    }
    dd <- dd[fl, , drop = FALSE]
  }
  if (has_year_col && !is.null(approxim$mileStoneYears)) {
    dd <- dd[dd$year %in% approxim$mileStoneYears, , drop = FALSE]
  }
  if (nrow(dd) == 0) {
    return(NULL)
  }
  dd
}


