# setSlice(level1= 'MON', TH', ..., level2= '1H', 2H', ...)
# setSlice(level1= list(name 'WEEKDAY', 'MON' = 1/12, 'TH' = 1/13), ..., level2= '1H', 2H', ...)setSlice(level1= list('MON' = list(1/12, c('1H' = 1/13)), ...)

require(energyRt)
mdl <- new('model')
# set Slice name vectors
#.setSlice <- function(mdl, arg, dtf = data.frame(stringsAsFactors = FALSE)) {
 #  arg <- list(...)
  check_colnames <- function(dtf, nm) {
    if (any(colnames(dtf) == nm) || any(grep('^[!A-z]', nm)) || any(gsub('[[:alnum:]]*', nm)))
      stop(paste('Wrong slice level names "', nm, '"', sep = ''))
  }
  check_slice <- function(nm) {
    if (any(grep('^[!A-z]', nm)) || any(gsub('[[:alnum:]]*', nm)) || anyDuplicated(nm)) {
      n1 <- unique(c(grep('^[!A-z]', nm, value = TRUE), grep('[[:alnum:]]*', nm, value = TRUE)))
      ms1 <- NULL; ms2 <- NULL; 
      if (length(n1) != 0) 
        ms1 <- paste('Wrong slice names "', paste(n1, collapse = '", "'), '". ', sep = '')
      n2 <- unique(nm[duplicated(nm)])
      if (length(n2) != 0) 
        ms2 <- paste('Wrong slice names "', paste(n1, collapse = '", "'), '"', sep = '')
      ms <- paste(ms1, ms2, sep = '')
      stop(ms)
    }
  }
  for (i in seq(along = arg)) {
    check_colnames(dtf, arg[[1]])
    if ()
    dtf <- .setSlice
  }
  
#}