
#===============================================================================
get_slot <- function(x, att) {
# Finds and returns name of slot where 'att' is storred
#
  rr <- c()
  g <- getClass('technology')
  for(z in names(g@slots)) {
    if (g@slots[[z]] == 'data.frame' && any(colnames(slot(x, z)) == att)) {   # '&&' Due to error for array (after g@slots[[z]] == 'data.frame'  calculation will be stop if use &&)
          rr <- c(rr, z)
    }
  }
  rr <- rr[rr != 'interpolation']
  rr <- rr[rr != 'default_value']
  rr <- rr[rr != 'commodity_type']
  rr <- rr[rr != 'units']
  return(rr)
}

