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
size <- function(x, level1 = FALSE, units = "auto", sort = TRUE, decreasing = FALSE, byteTol = 0, asNumeric = FALSE) {
  # browser()
  if (!level1) {
    format(object.size(x), units = units)
  } else {
    if (isS4(x)) { # S4
      slx <- slotNames(x)
      val <- lapply(slx, function(z) {
        object.size(slot(x, z))})
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
      val <- lapply(val, function(z) {format(z, units = units)})
    }
    # browser()
    ii <- vv >= byteTol
    val[ii]
  }
}

if (F) {
  size(scen, 1, "Mb", byteTol = 1024)
  size(scen@modInp, 1, "Mb", byteTol = 1024)
  size(scen@modInp@parameters, 1, "Mb", byteTol = 1024*1000)
  size(scen@modInp@parameters$pTradeIrEff, 1, "Mb", byteTol = 1024*1000)
  size(scen@modInp@parameters$pTradeIrEff@data, 1, "Mb", byteTol = 0, asNumeric = T)
  head(scen@modInp@parameters$pTradeIrEff@data)
}
