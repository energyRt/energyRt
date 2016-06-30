#---------------------------------------------------------------------------------------------------------
#! technology_data_frame <- function() : get technology slot data.frame names
#---------------------------------------------------------------------------------------------------------
technology_data_frame <- function() {
# get technology slot data.frame names
  g <- getClass('technology')
  names(g@slots)[sapply(names(g@slots),function(z) g@slots[[z]] == 'data.frame')]
}
