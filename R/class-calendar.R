#' An S4 class to represent sub-annual time resolution structure (time slices).
#'
#' @details
#' Sub-annual time resolution is represented by nested, named fractions of a year ("slices").
#'
#' @slot structure a named list of nested sub-annual levels with vectors of individual elements.
#' @slot table data.frame with levels of slices in the named columns, and number of rows equal to the total number of time-slices on the lowest level.
#' @slot share two column data.frame with slices from all levels with their individual share in a year.
#' @slot family data.frame mapping "parent" to "child" slices in the nested hierarchy.
#' @slot ancestry data.frame mapping all "(grand-)parent" to all "(grand-)children".
#' @slot defLevel character, the name of the default level of the time-slices used in the model.
#' @slot misc list with additional data and calculated mappings.
#'
#' @return
#' @export
#'
#' @examples
setClass("timeslices", # alt: timestructure, timescales, timescheme, timeframe, schedule, calendar
  representation(
    structure = "list", # renamed `slice_map` // alt.names: hierarchy, nest, ..
    table = "data.frame", # renames `levels`
    # full_set = "character", # renamed `all_slice`
    share = "data.frame", # !!! rename to fraction?
    family = "data.frame", # renamed `parent_child`
    ancestry = "data.frame", # renamed `all_parent_child`
    defLevel = "character", # renamed `default_slice_level`
    depth = "integer", # renamed `misc$deep`
    nSlices = "integer", # renamed `misc$nlevel`
    next_in_nest = "data.frame", # renamed `misc$next_slice`
    next_in_year = "data.frame", # renamed `misc$fyear_next_slice`
    misc = "list"
  ),
  prototype(
    structure = list(), # Slices set by level
    table = data.frame(stringsAsFactors = FALSE),
    share = data.frame(
      # year = numeric(),
      slice = character(), # == time interval
      share = numeric(), # fraction of a year // rename?
      stringsAsFactors = FALSE
    ),
    family = data.frame(
      # year = numeric(),
      parent = character(),
      child = character(),
      stringsAsFactors = FALSE
    ),
    ancestry = data.frame(
      # year = numeric(),
      parent = character(),
      child = character(),
      stringsAsFactors = FALSE
    ),
    defLevel = character(), # Default slice map
    # all_slice = character(),
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "timeslices", function(.Object, ...) {
  .Object
})


#' Create table of time-slices from given structure as a list
#'
#' @param struct named list of timeslices levels with sets and optional shares of levels
#' @param warn logical, if TRUE, warning will be issued if `ANNUAL` level does not exists in the given structure. The level will be auto-created to complete the time-structure.
#'
#' @return
#' @export
#'
#' @examples
#' make_timeslices_table()
#' make_timeslices_table(list("SEASON" = c("WINTER", "SUMMER")))
#' make_timeslices_table(list("SEASON" = c("WINTER" = .6, "SUMMER" = .4)))
#' make_timeslices_table(list(
#'   "SEASON" = list(
#'     "WINTER" = list(.3, DAY = c("MORNING", "EVENING")),
#'     "SUMMER" = list(.7, DAY = c("MORNING", "EVENING"))
#'   )
#' ))
#'
#' make_timeslices_table(list(
#'   "SEASON" = list("WINTER" = .3, "SUMMER" = .7),
#'   "DAY" = c("MORNING", "EVENING")
#' ))
#'
make_timeslices_table <- function(struct = list(ANNUAL = "ANNUAL"), warn = FALSE) {
  # an old version, adjusted for data.table
  # class and content check
  if (inherits(struct, "list")) {
    # check/add ANNUAL
    if (is.null(struct$ANNUAL)) {
      if (warn) warning("Adding `ANNUAL` level to timeslices structure")
      struct <- c(ANNUAL = "ANNUAL", struct)
    }
    # arg <- unlist(struct)
  } else {
    stop("`struct` should be a named list with time-slices structure (see examples)")
  }
  # check for duplicates
  nms <- names(struct)
  if (anyDuplicated(nms)) {
    stop(paste('duplicated slice levels: "',
      paste(unique(nms[duplicated(nms)]), collapse = '", "'),
      '"',
      sep = ""
    ))
  }
  # create table
  dtf <- data.table(share = numeric(), stringsAsFactors = FALSE)
  if (length(struct) == 1 && is.character(struct[[1]]) && length(struct[[1]]) == 1) {
    dtf <- data.table(share = 1, ANNUAL = struct[[1]], stringsAsFactors = FALSE)
    if (!is.null(names(struct))) colnames(dtf)[2] <- names(struct)[1]
  } else {
    dtf <- .slice_constructor(dtf, struct)
  }
  # dtf <- dtf[, c(2:ncol(dtf), 1), drop = FALSE] # arrange columns
  setcolorder(dtf, c(2:ncol(dtf)))
  if (abs(sum(dtf$share) - 1) < 1e-10) dtf$share <- (dtf$share / sum(dtf$share))

  x <- select(dtf, if_else(ncol(dtf) > 2, 2, 1):share, -share) %>% unite(slice)
  dtf <- mutate(dtf, slice = x$slice, .before = "share")
  # browser()
  .check_timeslices_table(dtf) # check validity
  return(dtf)
}


if (F) {
  # tests ####
  make_timeslices_table()
  make_timeslices_table(list("SEASON" = c("WINTER", "SUMMER")))
  make_timeslices_table(list("SEASON" = c("WINTER" = .6, "SUMMER" = .4)))
  make_timeslices_table(list(
    "SEASON" = list(
      "WINTER" = list(.3, DAY = c("MORNING", "EVENING")),
      "SUMMER" = list(.7, DAY = c("MORNING", "EVENING"))
    )
  ))

  make_timeslices_table(list(
    "SEASON" = list("WINTER" = .3, "SUMMER" = .7),
    "DAY" = c("MORNING", "EVENING")
  ))

  # from UTOPIA
  make_timeslices_table(timeslices)
  make_timeslices_table(timeslices1)
  make_timeslices_table(timeslices2)
  make_timeslices_table(timeslices3)

  dtf <- make_timeslices_table(timeslices2)
  # obj <- new("timeslices")
  # obj@table <- dtf
}

# validation of names of individual time-slices
.check_slice_name <- function(nm) {
  # check / optimize script
  if (any(grep("^[A-z]", nm, invert = TRUE)) ||
    any(gsub("[[:alnum:]]*", "", nm) != "") ||
    anyDuplicated(nm)) {
    n1 <- unique(c(
      grep("^[A-z]", nm, invert = TRUE, value = TRUE),
      nm[(gsub("[[:alnum:]]*", "", nm) != "")]
    ))
    ms1 <- NULL
    ms2 <- NULL
    if (length(n1) != 0) {
      ms1 <- paste('Check slice names "',
        paste(n1, collapse = '", "'), '". ',
        sep = ""
      )
    }
    n2 <- unique(nm[duplicated(nm)])
    if (length(n2) != 0) {
      ms2 <- paste('Check slice names "',
        paste(n2, collapse = '", "'), '"',
        sep = ""
      )
    }
    ms <- paste(ms1, ms2, sep = "")
    stop(ms)
  }
}

# validation of timeslices@table
.check_timeslices_table <- function(dtf) {
  # adjusted for data.table & dtplyr
  # browser()
  sl <- select(dtf, slice)
  dtf <- select(dtf, -any_of("slice")) # to fit "old" check algo
  # check / optimize the script
  if (ncol(dtf) < 2) {
    stop("time-slices data.table must have more than one columns")
  }
  if (colnames(dtf)[ncol(dtf)] != "share") {
    stop("The time-slices data.table must have `share` column")
  }
  # rcs <- colnames(dtf)[-ncol(dtf)]
  rcs <- select(dtf, -share) %>% colnames()
  if (anyDuplicated(rcs)) {
    stop(paste('duplicated slice levels: "',
      paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"',
      sep = ""
    ))
  }

  # check length
  fl <- apply(
    # dtf[, -c(1, ncol(dtf)), drop = FALSE],
    select(dtf, -1, -share),
    2, function(x) length(unique(x)) == 1
  )

  if (any(fl)) {
    stop(paste('all slice levels except "ANNUAL", ',
      'should have more than one elements, check: "',
      paste(colnames(dtf)[c(FALSE, fl, FALSE)], collapse = '", "'), '"',
      sep = ""
    ))
  }
  if (length(unique(dtf[[1]])) != 1) {
    stop("first slice should have only one 'ANNUAL' element")
  }
  rcs <- c(
    apply(select(dtf, -share), 2, function(x) unique(x)),
    recursive = TRUE)
  if (anyDuplicated(rcs)) {
    stop(paste('duplicated slice names in levels: "',
      paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"',
      sep = ""
    ))
  }
  # Check sum == 1
  if (round(sum(dtf$share), 5) != 1) {
    stop(
      "Sum of slice shares should be equal to one, check: ",
      sum(dtf$share)
    )
  }
  # full year
  ll <- apply(select(dtf, -share), 1, paste, collapse = ".")
  if (anyDuplicated(ll)) {
    stop(paste('duplicated sets in time-slices. ("',
      paste(ll[duplicated(ll)], collapse = '", "'), '").',
      sep = ""
    ))
  }
  # check length
  if (length(ll) != prod(sapply(select(dtf, -share),
                                function(x) length(unique(x))))) {
    # error - investigate
    dtf2 <- unique(dtf[[1]])
    for (i in seq(length = ncol(dtf) - 2) + 1) {
      ln <- length(unique(dtf[[i]]))
      dtf2 <- paste(c(t(matrix(dtf2, length(dtf2), ln))), ".",
                    unique(dtf[[i]]), sep = "")
    }
    stop(paste('(empty?) time-slices. ("',
      paste(dtf2[!(dtf2 %in% ll)], collapse = '", "'), '").',
      sep = ""))
  }
}

# internal function to create timeslices table from a given list with structure
# !!! ToDo: optimize/rewrite for data.table
.slice_constructor <- function(dtf, arg) {
  # browser()
  dtf <- as.data.frame(dtf) # doesn't work with data.table - debug/rewrite
  # check / optimize script
  if (is.null(names(arg)) || any(names(arg) == "")) {
    stop(paste("Unnamed arguments: ",
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
      dtf[, "share"] <- dtf0[, "share"] * c(t(matrix(
        val_sh,
        length(val_sh),
        nrow(dtf0)
      )))
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
      .check_slice_name(val_nm)
      if (any(val_sh <= 0) || round(sum(val_sh), 10) != 1) { # avoiding precision issues on some systems (Mac/M2-Si)
        stop(paste(paste('Check time-slice data for level "', lv, '"\n',
          sep = ""
        ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
      }
      arg <- arg[-1]
      dtf <- add_val(dtf, val_sh, val_nm)
    } else if (is.list(arg[[1]])) {
      arg2 <- arg[[1]] # arg <- arg[-1]
      if (is.null(names(arg2)) || any(names(arg2) == "")) {
        stop(paste(paste('Check time-slice data for level "', lv, '"\n',
          sep = ""
        ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
      }
      if (is.numeric(arg2[[1]])) {
        if (!all(sapply(arg2, is.numeric))) {
          stop(paste(paste('Check time-slice data for level "', lv, '"\n',
            sep = ""
          ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
        }
        dtf <- add_val(dtf, c(arg2, recursive = TRUE), names(arg2))
        arg <- arg[-1]
      } else {
        if (!all(sapply(arg2, is.list))) {
          stop(paste(paste('Check time-slice data for level "', lv, '"\n',
            sep = ""
          ), paste(capture.output(print(arg[[1]])), collapse = "\n"), sep = "\n"))
        }
        dtf0 <- dtf
        dtf <- NULL
        arg2 <- arg[[1]]
        for (i in seq(length.out = length(arg2))) {
          dtf1 <- .slice_constructor(add_val(dtf0, arg2[[i]][[1]], names(arg2)[i]), arg2[[i]][-1])
          if (i == 1) {
            dtf <- dtf1
          } else {
            if (ncol(dtf) != ncol(dtf1) || any(colnames(dtf) != colnames(dtf1))) {
              stop(paste("Set of slice have to be the same for all ",
                "(check list slice arguments).",
                sep = ""
              ))
            }
            dtf <- rbind(dtf, dtf1)
          }
        }
        arg <- arg[-1]
      }
    } else {
      stop(paste('Unknown type of argument for slice level "', lv, '"', sep = ""))
    }
  }
  as.data.table(dtf)
}

# internal function to populate all slots of `timeslices` from given timeslices@table
.complete_timeslices <- function(obj) {
  # browser()
  if (nrow(obj@table) == 0) {
    warning('no slices info, using default: "ANNUAL"')
    obj@table <- make_timeslices_table()
  }
  # validate the timeslices table
  .check_timeslices_table(obj@table)
  # obj@misc <- list()
  dtf <- obj@table %>% select(-any_of("slice"))

  # depth of levels
  d <- select(dtf, -any_of(c("share", "year", "slice")))
  obj@depth <- 1:ncol(d)
  names(obj@depth) <- colnames(d)

  # number of slices on every level
  obj@nSlices <- sapply(d, function(x) length(unique(x)))

  # share of every slice in a year
  obj@share <- data.table(
    slice = rep(as.character(NA), sum(cumprod(obj@nSlices))),
    share = as.numeric(NA)
  )
  obj@share[1, "slice"] <- dtf[1, 1]
  obj@share[1, "share"] <- 1
  k <- 1
  if (ncol(dtf) > 2) {
    for (i in 2:(ncol(dtf) - 1)) {
      # tmp <- apply(dtf[, 2:i, drop = FALSE], 1, paste, collapse = "_")
      tmp <- apply(select(dtf, 2:i), 1, paste, collapse = "_")
      # tmp <- tapply(dtf[, ncol(dtf)], tmp, sum)
      tmp <- tapply(dtf[, share], tmp, sum)
      obj@share$slice[k + seq(along = tmp)] <- names(tmp)
      obj@share$share[k + seq(along = tmp)] <- tmp
      k <- (k + length(tmp))
    }
  }

  # @structure
  tmp <- nchar(obj@share$slice) - nchar(gsub("[_]", "", obj@share$slice)) + 2
  names(tmp) <- obj@share$slice
  tmp[obj@table[[1]][1]] <- 1
  obj@structure <- lapply(1:(ncol(obj@table) - 2),
                          function(x) names(tmp)[tmp == x])
  names(obj@structure) <- colnames(d)

  obj@defLevel <- colnames(d)[ncol(d)]

  # @all_slice
  # obj@all_slice <- obj@share$slice

  # @family
  # browser()
  if (nrow(obj@table) == 1) {
    obj@family <- obj@family[0, , drop = FALSE]
    obj@ancestry <- obj@ancestry[0, , drop = FALSE]
  } else {
    obj@family <- obj@family[0, ] %>% as.data.frame()
    # obj@family$lev <- numeric()
    obj@family[1:(nrow(obj@share) - 1), ] <- NA
    i <- 1
    k <- 0
    z <- 1
    while (i != ncol(dtf) - 1) {
      l <- obj@nSlices[i + 1]
      for (j in 1:obj@nSlices[i]) {
        obj@family$parent[k + 1:l] <- obj@share$slice[z]
        obj@family$child[k + 1:l] <- obj@share$slice[1 + k + 1:l]
        # obj@family[k + 1:l, 'lev'] <- i + 1
        k <- k + l
        z <- z + 1
      }
      i <- i + 1
    }
    # @ancestry
    tmp <- obj@family
    tmp$nlev <- NA
    for (i in seq_along(obj@structure)) {
      tmp$nlev[tmp$parent %in% obj@structure[[i]]] <- i
    }
    ll <- tmp[tmp$nlev + 1 == length(obj@structure), -3]
    for (i in rev(seq_along(obj@structure))[-(1:2)]) {
      gg <- tmp[tmp$nlev == i, -3]
      g3 <- gg
      colnames(gg)[2] <- "sht"
      l2 <- ll
      colnames(l2)[1] <- "sht"
      g2 <- merge(gg, l2)
      g2$sht <- NULL
      ll <- rbind(ll, g2, g3)
    }
    obj@ancestry <- ll
  }

  # next slice in the same nest & in a year
  # obj@next_in_nest <- NULL
  if (nrow(obj@table) != 1) {
    tmp <- obj@family
    tmp$next_slice <- NA
    j <- 1
    for (i in 1:(nrow(tmp) - 1)) {
      if (tmp$parent[i] == tmp$parent[i + 1]) {
        tmp$next_slice[i] <- tmp$child[i + 1]
      } else {
        tmp$next_slice[i] <- tmp$child[j]
        j <- i + 1
      }
      # if (tmp[i, "parent"] == tmp[i + 1, "parent"]) {
      #   tmp[i, "next_slice"] <- tmp[i + 1, "child"]
      # } else {
      #   tmp[i, "next_slice"] <- tmp[j, "child"]
      #   j <- i + 1
      # }
    }
    tmp$next_slice[i + 1] <- tmp$child[j]
    obj@next_in_nest <- data.table(
      slice = tmp$child, slicep = tmp$next_slice,
      stringsAsFactors = FALSE
    )
    n1 <- c(lapply(obj@structure[-1], function(x) x), recursive = TRUE)
    names(n1) <- NULL
    n2 <- c(lapply(obj@structure[-1], function(x) c(x[-1], x[1])), recursive = TRUE)
    names(n2) <- NULL
    obj@next_in_year <- data.table(
      slice = n1, slicep = n2,
      stringsAsFactors = FALSE
    )
  }
  obj@family <- as.data.table(obj@family)
  obj@ancestry <- as.data.table(obj@ancestry)
  obj
}

# initialize timeslices object from given list ("struct") or "table"
.init_timeslices <- function(struct = NULL, table = NULL) {
  # browser()
  tsl <- new("timeslices")
  if (is.null(table)) {
    if (is.null(struct)) {
      tsl@table <- make_timeslices_table()
    } else {
      tsl@table <- make_timeslices_table(struct)
    }
  } else if (!is.null(struct)) {
    stop("Only one parameter `struct` or `table` can be specified")
  } else {
    tsl@table <- table
  }
  .complete_timeslices(tsl)
}

if (F) {
  # tests ####
  .init_timeslices()
  .init_timeslices(struct = timeslices2)
  .init_timeslices(struct = timeslices3)
  make_timeslices_table(timeslices2)
  make_timeslices_table(timeslices3)
  .init_timeslices(table = make_timeslices_table(timeslices2))
  .init_timeslices(table = make_timeslices_table(timeslices3))
  # .init_timeslices(table = tsl@table)
}
