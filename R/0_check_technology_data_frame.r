#---------------------------------------------------------------------------------------------------------
#! check_technology_data_frame <- function(x) : Check structure technology class (only data.frame)
#---------------------------------------------------------------------------------------------------------
check_technology_data_frame <- function(object) {
# check technology data.frame
  g <- getClass('technology')
  tec <- new('technology')
  fl <- FALSE
  for(z in names(g@slots)) {
    if (g@slots[[z]] == 'data.frame') {
      u <- slot(tec, z)
      b <- slot(object, z)
      if (ncol(u) != ncol(b) || any(colnames(u) != colnames(b))) {
        cat(z,'\n')
        fl <- TRUE
      }
    }
  }
  if (fl) stop('Invalid technology object: Wrong data.frame')
  return(NULL)
}

