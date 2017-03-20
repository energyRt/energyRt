# Generate gams code to define parameter from table
data_frame_to_gams_parameter <- function(dtf, defVal, prefix) {

  if (is.null(dtf) || nrow(dtf) == 0 || all(dtf$value[1] == dtf$value)) {
    if (!is.null(dtf)) defVal <- dtf$value[1]
    list(ext_code = paste('(', defVal, ')', sep = ''), clearCode = NULL)
  } else {
    fl <- rep(TRUE, ncol(dtf))
    for(i in (2:ncol(dtf) - 1)) {
      if (all(dtf[1, i] == dtf[, i])) fl[i] <- FALSE
    }
    if (any(!fl)) dtf <- dtf[, fl, drop = FALSE]
    zz <- dtf[, 1]
    if (ncol(dtf) > 2) {
        for(i in (3:ncol(dtf) - 1))
            zz <- paste(zz, '.', dtf[, i], sep = '')
    }
    zz <- paste(zz, dtf[, ncol(dtf)])
    list(clearCode = c('parameter',
          paste(prefix, '(', paste(colnames(dtf)[-ncol(dtf)], collapse = ', '), ') /', sep = ''),
          zz, '/;'),
         ext_code = paste(prefix, '(', paste(colnames(dtf)[-ncol(dtf)], collapse = ', '), ')', sep = '')
    )
  }
}


## defVal <- .15
## prefix = 'test_par'
## dtf <- data.frame(n1 = c('c1', 'c1', 'c2'), n2 = rep('c3', 3), value = rep(1, 3))
## data_frame_to_gams_parameter(dtf, defVal, prefix)
##
## dtf <- data.frame(n1 = c('c1', 'c1', 'c2'), n2 = rep('c3', 3), value = 1:3)
## data_frame_to_gams_parameter(dtf, defVal, prefix)
##