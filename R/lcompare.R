#' Comparison of two objects.
#'
#' @param x object to compare
#' @param y object to compare
#' @param depth   starting level of depth of the object
#' @param showDiff ligical, if TRUE will return only different parts of the object
#'
#' @return Returns either TRUE if the objects are identical, or a bested list with the objects (x) structure and differences with object y.
#' 
lcompare <- function(x, y, depth = 0, showDiff = TRUE) {
  # similar to base::all.equal(), testthat::compare(), but returns list with differences.
  if (class(x) != class(y)) {
    return(list(x = x, y = y))
  }
  if (identical(x, y)) { # use all.equal() with tolerance
    if (depth == 0) {val <- TRUE} else {val <- NULL}
    return(val)
  }
  
  if (isS4(x)) { # S4
    slx <- slotNames(x)
    val <- lapply(slx, function(z) {
      lcompare(slot(x, z), slot(y, z), depth = depth + 1, showDiff = showDiff)})
    names(val) <- slx
    if (showDiff) {ii <- sapply(val, is.null); val <- val[!ii]}
    return(val)
  } else { # not S4
    # depth <- function(x) ifelse(is.list(x), 1L + max(sapply(x, depth)), 0L)
    # credits: https://stackoverflow.com/questions/13432863/determine-level-of-nesting-in-r
    fDepth <- function(ob, obj_depth = 0){
      if(!is.list(ob)){
        return(obj_depth)
      }else{
        return(max(sapply(ob, fDepth, obj_depth = obj_depth + 1)))
      }
    }
    dpx <- fDepth(x); dpy <- fDepth(y)
    if (dpx > 0 & dpy > 0) {
      nmx <- names(x); nmy <- names(y)
      nm <- unique(c(nmx, nmy))
      ii <- nm %in% nmx
      nm <- c(nmx, nm[!ii])
      val <- lapply(nm, function(z) {
        lcompare(x[[z]], y[[z]], depth = depth + 1, showDiff = showDiff)
      })
      names(val) <- nm
      if (showDiff) {ii <- sapply(val, is.null); val <- val[!ii]}
      return(val)
    } else {
      return(list(x = x, y = y))
    }
  }
}

comp <- lcompare

if (F) {
  COA <- newCommodity("COA")
  ELC <- newCommodity("ELC")
  lcompare(COA, ELC)
  cc <- lcompare(rps1, rps2)
  str(cc)
  lcompare(1,1)
  lcompare(1,TRUE)
  lcompare(1,2)
  str(lcompare(list(a=2),2))
  cc <- lcompare(rps1, rps2, showDiff = F)
  str(cc)
  ii <- sapply(cc, is.null)
  str(cc[!ii])
  
}

 