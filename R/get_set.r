#===============================================================================
get_set <- function(x, att) {
  # Finds and returns full set of parameter 'att' in slots of technology 'x'
  #
  rr <- c()
  g <- getClass('technology')
  for(z in names(g@slots)) {
    if (g@slots[[z]] == 'data.frame' & any(colnames(slot(x, z)) == att))
      rr <- unique(c(slot(x,z)[,att],rr))
  }
  rr <- rr[!is.na(rr)]
  return(rr)
}
