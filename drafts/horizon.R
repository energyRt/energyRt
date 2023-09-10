check <- function(...) UseMethod("check")

#' An S4 class to represent model/scenario horizon and intervals (steps)
#'
#' @slot horizon integer, a full (without gaps), arranged sequence of modeled years.
#' @slot intervals data.table,
#'
#' @family horizon
#'
#' @return
#' @export
#'
#' @examples
setClass("horizon",
  representation(
    horizon = "integer",
    intervals = "data.table"
  ),
  prototype(
    horizon = integer(),
    intervals = data.table(
      start = integer(),
      mid = integer(),
      end = integer()
    )
  )
)


# Functions and methods to define and set model horizon

#' Create a new object of class 'horizon'
#'
#' @param horizon (optional) integer vector with a range or a sequence of years; will be arranged, gaps will be filled. If missing
#' @param intervals (optional) data.frame or integer vector. The data.frame must have `start`, `mid`, and `end` columns with modeled interval. The vector will be considered as lengths of each modeled period in years.
#' @param start (optional) integer vector with start of each interval.
#' @param mid (optional) integer vector with middle year of each interval.
#' @param end (optional) integer vector with end of each interval.
#' @param ... ignored
#'
#' @family horizon
#'
#' @return
#' @export
#'
#' @examples
#' newHorizon(2020:2050)
newHorizon <- function(horizon = NULL, intervals = NULL,
                       start = NULL, mid = NULL, end = NULL, ...) {
  # browser()
  # checks
  if (!is.null(intervals)) {
    if (any(!is.null(start), !is.null(mid), !is.null(end))) {
      stop("Either `intervals` or `start` & `mid` & `end` can be defined")
    }
    .check_intervals(intervals)
    intervals <- as.data.table(intervals)
    intervals <- intervals[order(start)]
  } else if (any(!is.null(start), !is.null(mid), !is.null(end))) {
    .check_integer(start, ": start")
    .check_integer(mid, ": mid")
    .check_integer(end, ": end")
    if (any(length(start) != length(mid), length(start) != length(end))) {
      stop("The length of `start`, `mid`, and `end` integer vectors must be identical")
    }
    # check for duplicates
    if (any(anyDuplicated(start), anyDuplicated(mid), anyDuplicated(end))) {
      stop("Duplicated values in `start`, `mid`, or `end` parameters")
    }
    if (mid[1] != start[1] | end[1] != start[1]) {
      warning("The base-year interval (the first) must be the one year interval.",
              "\nMaking an attempt to split the first interval into two.")
      start <- c(start[1], start); start[2] <- start[1] + 1L
      mid <- c(start[1], mid); mid[2] <- mid[1] + 1L
      end <- c(start[1], end) # end[2] <- end[1] + 1L
      start <- unique(start) %>% sort() %>% as.integer()
      mid <- unique(mid) %>% sort() %>% as.integer()
      end <- unique(end) %>% sort() %>% as.integer()
    }
    intervals <- data.table(
      start = as.integer(start),
      mid = as.integer(mid),
      end = as.integer(end)
    )
    intervals <- intervals[order(start)]
  } else if (is.null(horizon)) {
    # no data
    return(new("horizon")) # empty
  }

  if (!is.null(horizon)) {
    .check_integer(horizon, ": horizon")
    horizon <- min(horizon):max(horizon) %>% as.integer()
    if (!is.null(intervals)) {
      int_range <- as.matrix(intervals) %>% as.vector() %>% as.integer()
      # cross_join horizon & intervals
      horizon <- seq(max(min(int_range), min(horizon)),
                     min(max(int_range), max(horizon)),
                     by = 1L) %>% as.integer()
      intervals <- intervals[start >= min(horizon) & end <= max(horizon), ]
    } else { # intervals == NULL
      intervals <- data.table(
        start = as.integer(horizon),
        mid = as.integer(horizon),
        end = as.integer(horizon)
      )
    }
  } else { # horizon == NULL
    horizon <- min(horizon):max(horizon) %>% as.integer()
  }

  h <- new("horizon") # !!! update .data2slots for this class
  h@horizon <- horizon
  h@intervals <- intervals
  # h <- .data2slots("horizon", x = "", horizon = horizon, intervals = intervals)

  return(h)
}

if (F) {
  newHorizon()
  newHorizon(2020:2030)
  newHorizon(horizon = 2020:2040,
             intervals = data.frame(
               start = c(2030, 2031, 2034),
               mid =   c(2030, 2032, 2037),
               end =   c(2030, 2033, 2040)))

  newHorizon(horizon = 2020:2040,
             start = c(2030, 2031, 2034),
             mid =   c(2030, 2032, 2037),
             end =   c(2030, 2033, 2040))

  # fixable errors in data
  newHorizon(horizon = 2020:2040,
             intervals = data.frame(
               start = c(2030, 2032, 2035),
               mid =   c(2031, 2033, 2037),
               end =   c(2032, 2034, 2040)))

  newHorizon(horizon = 2020:2040,
             start = c(2030, 2032, 2035),
             mid =   c(2031, 2033, 2037),
             end =   c(2032, 2034, 2040))

  # non-fixable errors in data
  newHorizon(horizon = 2020:2040,
             mid =   c(2031, 2033, 2037),
             end =   c(2032, 2034, 2040))

  newHorizon(horizon = 2035:2040,
             start = c(2030, 2032, 2035),
             mid =   c(2031, 2033, 2037),
             end =   c(2032, 2034, 2040))



}

.check_integer <- function(x, msg_end = NULL, skip_null = TRUE) {
  if (is.null(x) & skip_null) return(invisible(NULL))
  if (!is.numeric(x)) stop("Expecting integer values", msg_end)
  y <- x - as.integer(x)
  if (!all(y == 0))
    stop("Non-integer values with fractions aassigned to integer parameter",
         msg_end)
  return(invisible(NULL))
}

.check_intervals <- function(x, ...) {
  # class
  if (!is.data.frame(x)) stop("Expecting `data.frame`")
  # columns
  if (any(sapply(c("start", "mid", "end"), function(i) is.null(x[[i]])))) {
    stop('The `intervals` table must have "start", "mid", and "end" columns')
  }
  # columns' class
  for (i in c("start", "mid", "end")) {
    .check_integer(x[[i]], paste0(": intefvals$", i))
  }
  # NAs
  if (any(is.na(x))) stop("NA values are not allowed in `intervals` table")
  # consistency of the data
  if (any(x$mid - x$start < 0)) stop("intervals$mid must be >= intervals$start")
  if (any(x$end - x$mid < 0)) stop("intervals$end must be >= intervals$mid")
  if (any(diff(x$start <= 0), diff(x$mid <= 0), diff(x$end <= 0))) {
    stop("Data in `intervals` table mult be stricly ascending")
  }
  return(invisible(NULL))
}

.trim_intervals_to_horizon <- function(intervals, horizon = NULL) {
  # check if the first (BY) and the last intervals are one year-steps
  # cross_merge with horizon (take the )
  #
  h <- horizon
  x <- intervals
  if (nrow(x) > 0 && (x$mid[1] != x$start[1] || x$end[1] != x$start[1]) ||
      (nrow(x) > 1 && diff(x$mid[1:2] > 1))) {
    warning("The base-year interval (the first) must be the one year interval.",
            "\nMaking an attempt to split the first interval into two.")
    int_BY <- x[1, ]
    int_BY[1,] <- int_BY$start[1]
    x <- rbind(int_BY, x)
    x$start[2] <- x$end[1] + 1L
    x$mid[2] <- x$start[1] + 1L
    x <- data.table(
      start = as.integer(x$start),
      mid = as.integer(x$mid),
      end = as.integer(x$end)
    )
    x <- x[order(start)]
    .check_intervals(x) # double-check
  }

}



