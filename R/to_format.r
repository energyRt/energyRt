#---------------------------------------------------------------------------------------------------------
#! to_format <- function(x, def = 1) : numeric to convinient format (no more then 5 symbols)
#---------------------------------------------------------------------------------------------------------
to_format <- function(x, def = 1) {
# numeric to convinient format (no more then 5 symbols)
  if(is.na(x)) 'NA' else if((.01 < x && x < 999) || x == 0) {
    format(x, digits = 2)
  } else {
    format(x, digits = 2, scientific = TRUE)
  }
}
