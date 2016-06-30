stayOnlyVariable <- function(obj, lst, coln) {
  ss <- getSlots(class(obj))
  ss <- names(ss)[ss == 'data.frame']
  ss <- ss[sapply(ss, function(x) (any(colnames(slot(obj, x)) == coln) && nrow(slot(obj, x)) != 0))]
  for(sl in ss) {
    slot(obj, sl) <- slot(obj, sl)[is.na(slot(obj, sl)[, coln]) | slot(obj, sl)[, coln] %in% lst, , drop = FALSE]
  }
  obj
}

