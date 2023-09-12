# check <- function(...) UseMethod("check")

#' An S4 class to represent model/scenario horizon with intervals (year-steps)
#'
#' @slot info character, a comment or a short description.
#' @slot years integer, an arranged, full sequence (without gaps) of modeled years.
#' @slot intervals data.table,
#'
#' @family horizon
#'
#' @include generics.R
#' @return
#' @export
#'
#' @examples
setClass(
  "horizon",
  representation(
    info = "character",
    years = "integer",
    intervals = "data.table"
  ),
  prototype(
    info = character(),
    years = integer(),
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
#' @param years (optional) integer vector with a range or a sequence of years; will be arranged, gaps will be filled. If missing
#' @param intervals (optional) data.frame or integer vector. The data.frame must have `start`, `mid`, and `end` columns with modeled interval. The vector will be considered as lengths of each modeled period in years.
#' @param ... ignored
#' @param info character, a comment or description.
#' @param force_BY_interval_to_1_year logical, if TRUE (default), the base-year (first) interval will be forced to one year.
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
#' newHorizon(years = 2020:2050,
#'            intervals = data.frame(
#'              start = c(2030, 2031, 2034),
#'              mid =   c(2030, 2032, 2037),
#'              end =   c(2030, 2033, 2040)),
#'              info = "The years will be trimmed to the scope of intervals")
#'
#' newHorizon(2020:2050, c(3, 2, 5, 10),
#'            info = "Pay attention to the length of the first interval")
#'
#' newHorizon(years = 2020:2040,
#'            intervals = data.frame(
#'              start = c(2030, 2032, 2035),
#'              mid =   c(2031, 2033, 2037),
#'              end =   c(2032, 2034, 2040)))
newHorizon <- function(years = NULL, intervals = NULL, info = NULL,
                       force_BY_interval_to_1_year = T, ...) {
  # browser()
  h <- new("horizon") # !!! update .data2slots for this class
  if (!is.null(info)) {
    stopifnot(is.character(info))
    h@info <- as.character(info)
  }

  if (!is.null(years)) {
    .check_integer(years, ": years")
    years <- min(years):max(years) %>% as.integer()
  }

  if (!is.null(intervals)) {
    if (is.data.frame(intervals)) {
      .check_intervals(intervals)
      intervals <- as.data.table(intervals)
      intervals <- intervals[order(start)]
      int_range <- as.list(intervals) %>%
        unlist() %>%
        range() %>%
        as.integer()
      # next step: merge the data.frame with `years`
    } else if (is.numeric(intervals)) {
      if (is.null(years)) {
        stop(
          "When `intervals` is an integer vector with length of intervals, ",
          "`years` must be a vector (or range) of modeled years."
        )
      }
      .check_integer(intervals, ": intervals")
      intervals <- as.integer(intervals)
      if (force_BY_interval_to_1_year && intervals[1] != 1) {
        # adjusting BY length to 1
        intervals <- c(1L, intervals)
        if (length(intervals) > 1 && intervals[2] > 1) {
          intervals[2] <- intervals[2] - 1L
        }
      }
      intervals <- data.table(
        start = years[1] + cumsum(c(0, intervals[-length(intervals)])),
        mid = as.integer(rep(NA, length(intervals))),
        end = years[1] + cumsum(intervals) - 1
      )
      intervals$mid <- trunc(.5 * (intervals[, "start"] + intervals[, "end"]))

      intervals <- intervals[start >= years[1] & start <= max(years), ]
      nr <- nrow(intervals)
      if (intervals$end[nr] > max(years)) {
        intervals$end[nr] <- max(years)
        intervals$mid[nr] <- round(mean(intervals$start[nr], intervals$end[nr]))
      }
      int_range <- intervals %>%
        as.list() %>%
        unlist() %>%
        as.vector() %>%
        range() %>%
        as.integer()
      years <- years[years >= min(int_range) & years <= max(int_range)]
      h@years <- years
      h@intervals <- intervals
      return(h)
    }
  } else if (!is.null(years)) { # intervals == NULL
    intervals <- data.table(
      start = as.integer(years),
      mid = as.integer(years),
      end = as.integer(years)
    )
    h@years <- years
    h@intervals <- intervals
    return(h) # one year steps
  } else if (is.null(years)) { # no data
    return(h) # empty
  }

  if (is.null(years)) {
    years <- min(int_range):max(int_range) %>% as.integer()
  } else { # merge `years` vector with `intervals` data.table
    years <- seq(max(min(int_range), min(years)),
      min(max(int_range), max(years)),
      by = 1L
    ) %>% as.integer()
    intervals <- intervals[start >= min(years) & end <= max(years), ]
  }

  # Check & fix BY interval
  if (force_BY_interval_to_1_year && nrow(intervals) > 0 &&
    (intervals$mid[1] != intervals$start[1] ||
      intervals$end[1] != intervals$start[1]) ||
    (nrow(intervals) > 1 && diff(intervals$mid[1:2] > 1))) {
    # warning("Adjusting base-year interval to be one-year.")
    int_BY <- intervals[1, ]
    int_BY[1, ] <- int_BY$start[1]
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
  h@years <- years
  h@intervals <- intervals
  # h <- .data2slots("years", x = "", years = years, intervals = intervals)
  return(h)
}

.check_integer <- function(x, msg_end = NULL, skip_null = TRUE) {
  if (is.null(x) & skip_null) {
    return(invisible(NULL))
  }
  if (!is.numeric(x)) stop("Expecting integer values", msg_end)
  y <- x - as.integer(x)
  if (!all(y == 0)) {
    stop(
      "Non-integer values with fractions aassigned to integer parameter",
      msg_end
    )
  }
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

if (F) { # tests ####
  newHorizon()
  newHorizon(2020:2030)
  newHorizon(2020:2030, c(1, 2, 5, 10))
  newHorizon(2020:2035, c(1, 2, 5, 5, 5))
  newHorizon(2020:2050, c(1, 2, 5, 7, 1))

  newHorizon(
    intervals = data.frame(
      start = c(2030, 2031, 2034),
      mid =   c(2030, 2032, 2037),
      end =   c(2030, 2033, 2040)
    )
  )

  newHorizon(
    years = 2020:2050,
    intervals = data.frame(
      start = c(2030, 2031, 2034),
      mid =   c(2030, 2032, 2037),
      end =   c(2030, 2033, 2040)
    )
  )

  newHorizon(2020:2050, c(3, 2, 5, 10), info = "")

  newHorizon(
    years = 2020:2040,
    intervals = data.frame(
      start = c(2030, 2032, 2035),
      mid =   c(2031, 2033, 2037),
      end =   c(2032, 2034, 2040)
    )
  )
}
