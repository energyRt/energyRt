# setSlice(level1= 'MON', TH', ..., level2= '1H', 2H', ...)
# setSlice(level1= list(name 'WEEKDAY', 'MON' = 1/12, 'TH' = 1/13), ..., level2= '1H', 2H', ...)setSlice(level1= list('MON' = list(1/12, c('1H' = 1/13)), ...)

require(energyRt)
mdl <- new('model')
# set Slice name vectors
#setSlice_name_vector <- function(mdl, ...) {
  arg <- list(...)
  dtf <-data.frame(stringsAsFactors = FALSE)
  for (i in seq(along = arg)) {
    if (class(arg[[i]]) == 'list') {
    } else {
      
    }
  }
  
#}