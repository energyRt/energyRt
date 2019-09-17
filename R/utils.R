# Some commonly used functions
#' Size of an object
#'
#' @param x - any R object
#'
#' @return
#' @export
#'
#' @examples
#' size(1)
#' size(rep(1, 1e3))
#' size(rep(1L, 1e3))
size <- function(x) {
  format(object.size(x), units = "auto")}