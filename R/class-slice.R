# !!! rename? slice_share -> share
# all_slice -> ???
# all_parent_child -> ???
# levels -> table?
#
setClass("slice",
  representation(
    levels = "data.frame",
    slice_share = "data.frame", # ANNUAL, WINTER, WINTER_DAY, ...,  with share
    parent_child = "data.frame", # parent-child mapping
    all_parent_child = "data.frame", # All levels of parents and children
    slice_map = "list", # Slices set by level
    default_slice_level = "character", # Default slice map
    all_slice = "character",
    misc = "list"
  ),
  prototype(
    levels = data.frame(stringsAsFactors = FALSE),
    slice_share = data.frame(
      slice = character(),
      share = numeric(),
      stringsAsFactors = FALSE
    ),
    parent_child = data.frame(
      parent = character(),
      child = character(),
      stringsAsFactors = FALSE
    ),
    all_parent_child = data.frame(
      parent = character(),
      child = character(),
      stringsAsFactors = FALSE
    ),
    slice_map = list(), # Slices set by level
    default_slice_level = character(), # Default slice map
    all_slice = character(),
    misc = list()
  ),
  S3methods = TRUE
)

.init_slice <- function(sl) {
  # browser()
  if (nrow(sl@levels) == 0) {
    warning('no slices info, using default: "ANNUAL"')
    sl@levels <- .setSlice(ANNUAL = "ANNUAL")
  }
  # Check for correctness of data frame
  .slice_check_data(sl@levels)
  sl@misc <- list()
  # Calculate other data
  dtf <- sl@levels
  # deep level slice
  sl@misc$deep <- (2:ncol(dtf) - 1)
  names(sl@misc$deep) <- colnames(dtf)[-ncol(dtf)]
  # count level slice
  sl@misc$nlevel <- sapply(dtf[, -ncol(dtf), drop = FALSE],
                           function(x) length(unique(x)))
  names(sl@misc$nlevel) <- colnames(dtf)[-ncol(dtf)]

  sl@slice_share[1:sum(sapply(seq(along = sl@misc$nlevel),
                              function(x) prod(sl@misc$nlevel[1:x]))), ] <- NA
  #
  sl@slice_share[1, "slice"] <- dtf[1, 1]
  sl@slice_share[1, "share"] <- 1
  k <- 1
  if (ncol(dtf) > 2) {
    for (i in 2:(ncol(dtf) - 1)) {
      tmp <- apply(dtf[, 2:i, drop = FALSE], 1, paste, collapse = "_")
      tmp <- tapply(dtf[, ncol(dtf)], tmp, sum)
      sl@slice_share[k + seq(along = tmp), "slice"] <- names(tmp)
      sl@slice_share[k + seq(along = tmp), "share"] <- tmp
      k <- (k + length(tmp))
    }
  }
  # slice_map & all_slice
  tmp <- nchar(sl@slice_share$slice) - nchar(gsub("[_]", "", sl@slice_share$slice)) + 2
  names(tmp) <- sl@slice_share$slice
  tmp[sl@levels[1, 1]] <- 1
  sl@slice_map <- lapply(1:(ncol(sl@levels) - 1), function(x) names(tmp)[tmp == x])
  names(sl@slice_map) <- colnames(sl@levels)[-ncol(sl@levels)]
  sl@default_slice_level <- colnames(sl@levels)[ncol(sl@levels) - 1]
  sl@all_slice <- sl@slice_share$slice


  # parent_child
  if (nrow(sl@levels) == 1) {
    sl@parent_child <- sl@parent_child[0, , drop = FALSE]
    sl@all_parent_child <- sl@all_parent_child[0, , drop = FALSE]
  } else {
    sl@parent_child <- sl@parent_child[0, ]
    # sl@parent_child$lev <- numeric()
    sl@parent_child[1:(nrow(sl@slice_share) - 1), ] <- NA
    i <- 1
    k <- 0
    z <- 1
    while (i != ncol(dtf) - 1) {
      l <- sl@misc$nlevel[i + 1]
      for (j in 1:sl@misc$nlevel[i]) {
        sl@parent_child[k + 1:l, "parent"] <- sl@slice_share[z, "slice"]
        sl@parent_child[k + 1:l, "child"] <- sl@slice_share[1 + k + 1:l, "slice"]
        # sl@parent_child[k + 1:l, 'lev'] <- i + 1
        k <- k + l
        z <- z + 1
      }
      i <- i + 1
    }
    # all parent child realtion fill
    tmp <- sl@parent_child
    tmp$nlev <- NA
    for (i in seq_along(sl@slice_map)) {
      tmp[tmp$parent %in% sl@slice_map[[i]], "nlev"] <- i
    }
    ll <- tmp[tmp$nlev + 1 == length(sl@slice_map), -3]
    for (i in rev(seq_along(sl@slice_map))[-(1:2)]) {
      gg <- tmp[tmp$nlev == i, -3]
      g3 <- gg
      colnames(gg)[2] <- "sht"
      l2 <- ll
      colnames(l2)[1] <- "sht"
      g2 <- merge(gg, l2)
      g2$sht <- NULL
      ll <- rbind(ll, g2, g3)
    }
    sl@all_parent_child <- ll
  }

  # next_slice <- list()
  sl@misc$next_slice <- NULL
  if (nrow(sl@levels) != 1) {
    tmp <- sl@parent_child
    tmp$next_slice <- NA
    j <- 1
    for (i in 1:(nrow(tmp) - 1)) {
      if (tmp[i, "parent"] == tmp[i + 1, "parent"]) {
        tmp[i, "next_slice"] <- tmp[i + 1, "child"]
      } else {
        tmp[i, "next_slice"] <- tmp[j, "child"]
        j <- i + 1
      }
    }
    tmp[i + 1, "next_slice"] <- tmp[j, "child"]
    sl@misc$next_slice <- data.frame(slice = tmp$child, slicep = tmp$next_slice,
                                     stringsAsFactors = FALSE)
    n1 <- c(lapply(sl@slice_map[-1], function(x) x), recursive = TRUE)
    names(n1) <- NULL
    n2 <- c(lapply(sl@slice_map[-1], function(x) c(x[-1], x[1])), recursive = TRUE)
    names(n2) <- NULL
    sl@misc$fyear_next_slice <- data.frame(slice = n1, slicep = n2,
                                           stringsAsFactors = FALSE)
  }
  sl
}

.slice_check_data <- function(dtf) {
  if (ncol(dtf) < 2) {
    stop(".setTimeSlices: time-slices data.frame should have more than two columns")
  }
  if (colnames(dtf)[ncol(dtf)] != "share") {
    stop(
      ".setTimeSlices: the name of the last column of time-slices data.frame",
      " should be 'share'"
    )
  }
  rcs <- colnames(dtf)[-ncol(dtf)]
  if (anyDuplicated(rcs)) {
    stop(paste('.setTimeSlices: duplicated slice levels: "',
      paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"',
      sep = ""
    ))
  }
  fl <- apply(dtf[, -c(1, ncol(dtf)), drop = FALSE], 2, function(x) length(unique(x)) == 1)
  if (any(fl)) {
    stop(paste('.setTimeSlices: all slice levels except "ANNUAL", should have more than one elements, check: "',
      paste(colnames(dtf)[c(FALSE, fl, FALSE)], collapse = '", "'), '"',
      sep = ""
    ))
  }
  if (length(unique(dtf[, 1])) != 1) {
    stop(".setTimeSlices: first slice should have only one 'ANNUAL' element")
  }
  rcs <- c(apply(dtf[, -ncol(dtf), drop = FALSE], 2, function(x) unique(x)), recursive = TRUE)
  if (anyDuplicated(rcs)) {
    stop(paste('.setTimeSlices: duplicated slice names in levels: "',
      paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"',
      sep = ""
    ))
  }
  # Check
  if (round(sum(dtf$share), 5) != 1) {
    stop(".setTimeSlices: Sum of slice shares should be equal to one, check: ", sum(dtf$share))
  }
  ll <- apply(dtf[, -ncol(dtf), drop = FALSE], 1, paste, collapse = ".")
  if (anyDuplicated(ll)) {
    stop(paste('.setTimeSlices: duplicated sets in time-slices. ("',
      paste(ll[duplicated(ll)], collapse = '", "'), '").',
      sep = ""
    ))
  }
  if (length(ll) != prod(sapply(dtf[, -ncol(dtf), drop = FALSE], function(x) length(unique(x))))) {
    dtf2 <- unique(dtf[, 1])
    for (i in seq(length = ncol(dtf) - 2) + 1) {
      ln <- length(unique(dtf[, i]))
      dtf2 <- paste(c(t(matrix(dtf2, length(dtf2), ln))), ".", unique(dtf[, i]),
        sep = ""
      )
    }
    stop(paste('.setTimeSlices: (empty?) time-slices. ("',
      paste(dtf2[!(dtf2 %in% ll)], collapse = '", "'), '").',
      sep = ""
    ))
  }
}

# set Slice name vectors
.setTimeSlices <- function(slice = NULL, ...) {
  # browser()
  if (!is.null(slice) && length(list(...))) {
    stop('setTimeSlices: only one argument could be used: "slice" or "..."')
  }
  if (!is.null(slice)) {
    arg <- slice
  } else {
    arg <- list(...)
  }
  rcs <- names(arg)
  if (anyDuplicated(rcs)) {
    stop(paste('.setTimeSlices: duplicated slice levels: "',
      paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"',
      sep = ""
    ))
  }
  # check_colnames <- function(dtf, nm) {
  #   if (any(colnames(dtf) == nm) ||
  #       any(grep("^[!A-z]", nm)) ||
  #       any(gsub("[[:alnum:]]*", nm))) {
  #     stop(paste('Unexpected slice level names "', nm, '"', sep = ""))
  #   }
  # }
  check_slice <- function(nm) {
    if (any(grep("^[A-z]", nm, invert = TRUE)) ||
        any(gsub("[[:alnum:]]*", "", nm) != "") ||
        anyDuplicated(nm)) {
      n1 <- unique(c(grep("^[A-z]", nm, invert = TRUE, value = TRUE),
                     nm[(gsub("[[:alnum:]]*", "", nm) != "")]))
      ms1 <- NULL
      ms2 <- NULL
      if (length(n1) != 0) {
        ms1 <- paste('Check slice names "',
                     paste(n1, collapse = '", "'), '". ',
                     sep = "")
      }
      n2 <- unique(nm[duplicated(nm)])
      if (length(n2) != 0) {
        ms2 <- paste('Check slice names "',
                     paste(n2, collapse = '", "'), '"',
                     sep = "")
      }
      ms <- paste(ms1, ms2, sep = "")
      stop(ms)
    }
  }
  # Check full of slice sample
  # check_full_slice <- function(dtf) {
  #   stop("check_full_slice")
  # }
  slice_def <- function(dtf, arg) {
    # browser()
    if (is.null(names(arg)) || any(names(arg) == "")) {
      stop(paste(".setTimeSlices: Unnamed arguments: ",
        paste(capture.output(print(arg)), collapse = "\n"),
        sep = "\n"
      ))
    }
    add_val <- function(dtf, val_sh, val_nm) {
      dtf0 <- dtf
      dtf <- dtf[0, , drop = FALSE]
      dtf[, lv] <- character()
      if (nrow(dtf0) != 0) {
        dtf[1:(nrow(dtf0) * length(val_sh)), ] <- NA
        for (i in 2:ncol(dtf0)) dtf[, i] <- dtf0[, i]
        dtf[, lv] <- c(t(matrix(val_nm, length(val_sh), nrow(dtf0))))
        dtf[, "share"] <- dtf0[, "share"] * c(t(matrix(val_sh,
                                                       length(val_sh),
                                                       nrow(dtf0))))
      } else {
        dtf[1:length(val_sh), ] <- NA
        dtf[, lv] <- val_nm
        dtf[, "share"] <- val_sh
      }
      dtf
    }
    while (length(arg) != 0) {
      lv <- names(arg)[1]
      dtf[, lv] <- rep(character(), nrow(dtf))
      if (is.character(arg[[1]]) ||
          (!is.null(names(arg[[1]])) &&
           is.numeric(arg[[1]]))) {
        if (is.character(arg[[1]])) {
          val_sh <- rep(1 / length(arg[[1]]), length(arg[[1]]))
          val_nm <- arg[[1]]
        } else {
          val_sh <- arg[[1]]
          val_nm <- names(arg[[1]])
        }
        check_slice(val_nm)
        if (any(val_sh <= 0) || round(sum(val_sh), 10) != 1) { # avoiding precision issues on some systems (Mac/M2-Si)
          stop(paste(paste('.setTimeSlices: Check time-slice data for level "', lv, '"\n',
            sep = ""
          ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
        }
        arg <- arg[-1]
        dtf <- add_val(dtf, val_sh, val_nm)
      } else if (is.list(arg[[1]])) {
        arg2 <- arg[[1]] # arg <- arg[-1]
        if (is.null(names(arg2)) || any(names(arg2) == "")) {
          stop(paste(paste('.setTimeSlices: Check time-slice data for level "', lv, '"\n',
            sep = ""
          ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
        }
        if (is.numeric(arg2[[1]])) {
          if (!all(sapply(arg2, is.numeric))) {
            stop(paste(paste('.setTimeSlices: Check time-slice data for level "', lv, '"\n',
              sep = ""
            ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
          }
          dtf <- add_val(dtf, c(arg2, recursive = TRUE), names(arg2))
          arg <- arg[-1]
        } else {
          if (!all(sapply(arg2, is.list))) {
            stop(paste(paste('.setTimeSlices: Check time-slice data for level "', lv, '"\n',
              sep = ""
            ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
          }
          dtf0 <- dtf
          dtf <- NULL
          arg2 <- arg[[1]]
          for (i in seq(length.out = length(arg2))) {
            dtf1 <- slice_def(add_val(dtf0, arg2[[i]][[1]], names(arg2)[i]), arg2[[i]][-1])
            if (i == 1) {
              dtf <- dtf1
            } else {
              if (ncol(dtf) != ncol(dtf1) || any(colnames(dtf) != colnames(dtf1))) {
                stop(paste(".setTimeSlices: Set of slice have to be the same for all (check list slice arguments).", sep = ""))
              }
              dtf <- rbind(dtf, dtf1)
            }
          }
          arg <- arg[-1]
        }
      } else {
        stop(paste('.setTimeSlices: Unknown type of argument for slice level "', lv, '"', sep = ""))
      }
    }
    dtf
  }
  dtf <- data.frame(share = numeric(), stringsAsFactors = FALSE)
  if (length(arg) == 1 && is.character(arg[[1]]) && length(arg[[1]]) == 1) {
    dtf <- data.frame(share = 1, ANNUAL = arg[[1]], stringsAsFactors = FALSE)
    if (!is.null(names(arg))) colnames(dtf)[2] <- names(arg)[1]
  } else {
    dtf <- slice_def(dtf, arg)
  }
  dtf <- dtf[, c(2:ncol(dtf), 1), drop = FALSE]
  if (length(unique(dtf[, 1])) != 1) {
    warning('.setTimeSlices: the first level should have only one element, add "ANNUAL"?')
    if (any(colnames(dtf) == "ANNUAL") || any(c(dtf == "ANNUAL", recursive = TRUE))) {
      stop('.setTimeSlices: cannot add level "ANNUAL" slice, with level "ANNUAL"')
    }
    dtf$ANNUAL <- rep("ANNUAL", nrow(dtf))
    dtf <- dtf[, c(ncol(dtf), 2:ncol(dtf) - 1), drop = FALSE]
  }
  if (abs(sum(dtf$share) - 1) < 1e-10) dtf$share <- (dtf$share / sum(dtf$share))
  .slice_check_data(dtf)
  sl <- new("slice")
  sl@levels <- dtf
  sl <- .init_slice(sl)
  sl
}

# setMethod("setTimeSlices", signature(obj = "model"), function(obj, ...) {
#   obj@sysInfo@slice <- .setTimeSlices(...)
#   obj
# })

# setMethod("setTimeSlices", signature(obj = "scenario"), function(obj, ...) {
#   obj@model@sysInfo@slice <- .setTimeSlices(...)
#   obj
# })

# setMethod("setTimeSlices", signature(obj = "sysInfo"), function(obj, ...) {
#   obj@slice <- .setTimeSlices(...)
#   obj
# })

timeSlices <- function(x, asTibble = T, stringsAsFactors = FALSE) {
  # invisible(newModel("dummymod", slice = xx)@sysInfo@slice)
  mm <- newModel("dummymod", slice = x)
  slev <- mm@sysInfo@slice@levels
  nlev <- length(mm@sysInfo@slice@slice_map)
  if (nlev == 1) {
    slev$slice <- slev$ANNUAL
  } else {
    slev$slice <- apply(slev[, 2:nlev, drop = FALSE], 1, paste0, collapse = "_")
  }
  if (!stringsAsFactors) slev <- fact2char(slev)
  if (asTibble) slev <- tibble::as_tibble(slev)
  slev
}

#==============================================================================#
# Check if slice level exist ####
#==============================================================================#
.checkSliceLevel <- function(app, approxim) {
  if (length(app@slice) != 0 && all(app@slice != colnames(approxim$slice@levels)[-ncol(approxim$slice@levels)]))
    stop(paste0('Unknown slice level "', app@slice, '" for ', class(app), ': "', app@name, '"'))
}
#==============================================================================#
# Disaggregate slice ####
# e.g. from WINTER to WINTER_DAY and WINTER_NIGHT
#==============================================================================#
.disaggregateSliceLevel <- function(app, approxim) {
  slt <- getSlots(class(app))
  slt <- names(slt)[slt == 'data.frame']
  if (class(app) == 'technology') slt <- slt[slt != 'afs']
  for (ss in slt) if (any(colnames(slot(app, ss)) == 'slice')) {
    tmp <- slot(app, ss)
    fl <- (!is.na(tmp$slice) & !(tmp$slice %in% approxim$slice))
    if (any(fl)) {
      mark_col <- (sapply(tmp, is.character) | colnames(tmp) == 'year')
      mark_coli <- colnames(tmp)[mark_col]
      t1 <- tmp[fl,, drop = FALSE]
      t2 <- tmp[!fl,, drop = FALSE]
      # Sort from lowest level to largest
      ff <- approxim$parent_child$parent[!duplicated(approxim$parent_child$parent)]
      f1 <- seq_along(ff)
      names(f1) <- ff
      if (!all(t1$slice %in% ff))
        stop(paste0('Unknown slice or slice is not parrent slice, for "', app@name, '" (class ', class(app), '), slot: "',
                    ss, '", slice: "', paste0(t1$slice[!(t1$slice %in% ff)], collapse = '", "'), '"'))
      t1 <- t1[sort(f1[t1$slice], index.return = TRUE, decreasing = TRUE)$ix,, drop = FALSE]
      # Add child desaggregation
      for (i in seq_len(nrow(t1))) {
        ll <- approxim$parent_child[approxim$parent_child$parent == t1[i, 'slice'], 'child']
        t0 <- t1[rep(i, length(ll)),, drop = FALSE]
        t0$slice <- ll
        tes <- t0[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z1 <- apply(tes, 1, paste0, collapse = '##')
        tes <- t2[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z2 <- apply(tes, 1, paste0, collapse = '##')
        # If there are the same row, after splititng
        if (any(z1 %in% z2)) {
          merge_col <- merge(t0, t2, by = mark_coli)
          colnames(merge_col)[seq_len(ncol(t0))] <- colnames(t0)
          for (j in colnames(tmp)[!mark_col])
            merge_col[!is.na(merge_col[, paste0(j, '.y')]), j] <- NA
          t0 <- rbind(t0[!((z1 %in% z2)), ], merge_col[, 1:ncol(t0)])
        }
        t2 <- rbind(t2, t0)
      }
      slot(app, ss) <- t2
    }
  }
  app
}
