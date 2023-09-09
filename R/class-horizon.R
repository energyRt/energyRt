# check <- function(...) UseMethod("check")

#' An S4 class to represent model/scenario horizon with intervals (year-steps)
#'
#' @slot info character, a comment or a short description.
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
    info = "character",
    horizon = "integer",
    intervals = "data.table"
  ),
  prototype(
    info = character(),
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
#' @param ... ignored
#' @param info character, a comment or description.
#' @param BY_int_1 logical, if TRUE (default), the first (base-year) interval will be forced to one year.
#'
#' @family horizon
#'
#' @return
#' @export
#'
#' @examples
#' newHorizon(2020:2050)
#' newHorizon(2020:2030, info = "One-year intervals")
#' newHorizon(2020:2030, c(1, 2, 5, 10), info = "Different length intervals")
#' newHorizon(2020:2035, c(1, 2, 5, 5, 5))
#' newHorizon(2020:2050, c(1, 2, 5, 7, 1))

#' newHorizon(intervals = data.frame(
#'   start = c(2030, 2031, 2034),
#'   mid =   c(2030, 2032, 2037),
#'   end =   c(2030, 2033, 2040)),
#'   info = "Explicit assignment of intervals via data.frame"
#'   )
#'
#' newHorizon(horizon = 2020:2050,
#'            intervals = data.frame(
#'              start = c(2030, 2031, 2034),
#'              mid =   c(2030, 2032, 2037),
#'              end =   c(2030, 2033, 2040)),
#'              info = "The horizon will be trimmed to the scope of intervals")
#'
#' newHorizon(2020:2050, c(3, 2, 5, 10),
#'            info = "Pay attention to the length of the first interval")
#'
#' newHorizon(horizon = 2020:2040,
#'            intervals = data.frame(
#'              start = c(2030, 2032, 2035),
#'              mid =   c(2031, 2033, 2037),
#'              end =   c(2032, 2034, 2040)))
newHorizon <- function(horizon = NULL, intervals = NULL, info = NULL,
                       BY_int_1 = T, ...) {
  # browser()
  h <- new("horizon") # !!! update .data2slots for this class
  if (!is.null(info)) {
    stopifnot(is.character(info))
    h@info <- as.character(info)
  }

  if (!is.null(horizon)) {
    .check_integer(horizon, ": horizon")
    horizon <- min(horizon):max(horizon) %>% as.integer()
  }

  if (!is.null(intervals)) {
    if (is.data.frame(intervals)) {
      .check_intervals(intervals)
      intervals <- as.data.table(intervals)
      intervals <- intervals[order(start)]
      int_range <- as.list(intervals) %>% unlist() %>% range() %>% as.integer()
      # next step: merge the data.frame with `horizon`
    } else if (is.numeric(intervals)) {
      if (is.null(horizon)) {
        stop("When `intervals` is an integer vector with length of intervals, ",
             "`horizon` must be a vector (or range) of modeled years.")
      }
      .check_integer(intervals, ": intervals")
      intervals <- as.integer(intervals)
      if (BY_int_1 && intervals[1] != 1) {
        # adjusting BY length to 1
        intervals <- c(1L, intervals)
        if (length(intervals) > 1 && intervals[2] > 1) {
          intervals[2] <- intervals[2] - 1L
        }
      }
      intervals <- data.table(
        start = horizon[1] + cumsum(c(0, intervals[-length(intervals)])),
        mid = as.integer(rep(NA, length(intervals))),
        end = horizon[1] + cumsum(intervals) - 1
      )
      intervals$mid <- trunc(.5 * (intervals[, "start"] + intervals[, "end"]))

      intervals <- intervals[start >= horizon[1] & start <= max(horizon),]
      nr <- nrow(intervals)
      if (intervals$end[nr] > max(horizon)) {
        intervals$end[nr] <- max(horizon)
        intervals$mid[nr] <- round(mean(intervals$start[nr], intervals$end[nr]))
      }
      int_range <- intervals %>% as.list() %>% unlist() %>% as.vector() %>%
        range() %>% as.integer()
      horizon <- horizon[horizon >= min(int_range) & horizon <= max(int_range)]
      h@horizon <- horizon
      h@intervals <- intervals
      return(h)
    }
  } else if (!is.null(horizon)) { # intervals == NULL
    intervals <- data.table(
      start = as.integer(horizon),
      mid = as.integer(horizon),
      end = as.integer(horizon)
    )
    h@horizon <- horizon
    h@intervals <- intervals
    return(h) # one year steps
  } else if (is.null(horizon)) { # no data
    return(h) # empty
  }

  if (is.null(horizon)) {
    horizon <- min(int_range):max(int_range) %>% as.integer()
  } else { # merge `horizon` vector with `intervals` data.table
    horizon <- seq(max(min(int_range), min(horizon)),
                     min(max(int_range), max(horizon)),
                     by = 1L) %>% as.integer()
    intervals <- intervals[start >= min(horizon) & end <= max(horizon), ]
  }

  # Check & fix BY interval
  if (BY_int_1 && nrow(intervals) > 0 &&
      (intervals$mid[1] != intervals$start[1] ||
       intervals$end[1] != intervals$start[1]) ||
      (nrow(intervals) > 1 && diff(intervals$mid[1:2] > 1))) {
    # warning("Adjusting base-year interval to be one-year.")
    int_BY <- intervals[1, ]
    int_BY[1,] <- int_BY$start[1]
    intervals <- rbind(int_BY, intervals)
    intervals$start[2] <- intervals$end[1] + 1L
    intervals$mid[2] <- intervals$start[1] + 1L
    intervals <- data.table(
      start = as.integer(intervals$start),
      mid = as.integer(intervals$mid),
      end = as.integer(intervals$end)
    )
    intervals <- intervals[order(start)]
    .check_intervals(intervals) # double-check
  }
  h@horizon <- horizon
  h@intervals <- intervals
  # h <- .data2slots("horizon", x = "", horizon = horizon, intervals = intervals)
  return(h)
}

if (F) {
  newHorizon()
  newHorizon(2020:2030)
  newHorizon(2020:2030, c(1, 2, 5, 10))
  newHorizon(2020:2035, c(1, 2, 5, 5, 5))
  newHorizon(2020:2050, c(1, 2, 5, 7, 1))

  newHorizon(intervals = data.frame(
               start = c(2030, 2031, 2034),
               mid =   c(2030, 2032, 2037),
               end =   c(2030, 2033, 2040)))

  newHorizon(horizon = 2020:2050,
             intervals = data.frame(
               start = c(2030, 2031, 2034),
               mid =   c(2030, 2032, 2037),
               end =   c(2030, 2033, 2040)))

  newHorizon(2020:2050, c(3, 2, 5, 10), info = "")

  newHorizon(horizon = 2020:2040,
             intervals = data.frame(
               start = c(2030, 2032, 2035),
               mid =   c(2031, 2033, 2037),
               end =   c(2032, 2034, 2040)))

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




