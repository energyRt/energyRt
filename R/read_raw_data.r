#---------------------------------------------------------------------------------------------------------
#! read_raw_data < -function(rs, raw_data) : fill data to result class (argument  compile_model(mdl))
#---------------------------------------------------------------------------------------------------------
read_raw_data <- function(rs, raw_data) {
  rs@raw_data <- rs@raw_data[0,]
  for(i in colnames(rs@raw_data)[-ncol(rs@raw_data)]) {
    rs@raw_data[, i] <- factor(levels = raw_data$set[raw_data$set$name == i, 'value'])
  }
  data_parameter <- get_result_data_parameter()
  rs@raw_data[,'parameter'] <- factor(levels = rownames(data_parameter))
  for(i in colnames(raw_data$par)[-ncol(raw_data$par)]) {
    gg <- as.character(raw_data$par[, i])
    gg[gg == '-'] <- NA
    rs@raw_data[1:nrow(raw_data$par), i] <- gg
  }
  rs@raw_data[, 'value'] <- raw_data$par[, 'value']
  array_par <- sapply(2:8, function(x) nlevels(rs@raw_data[, x]))
  names(array_par) <- colnames(data_parameter)
  array_name <- lapply(2:8, function(x) levels(rs@raw_data[, x]))
  names(array_name) <- colnames(data_parameter)
  dta <- list()
  for(i in rownames(data_parameter)) {
      dtf <- rs@raw_data[rs@raw_data$parameter == i, c(FALSE, data_parameter[i, ], TRUE), drop = FALSE]
      if (sum(data_parameter[i, ]) == 0) {
        ary <- NA
        if (nrow(dtf) == 1) ary <- dtf[1, 'value']
      } else {
        ary <- array(0, dim = array_par[data_parameter[i, ]], dimnames = array_name[data_parameter[i, ]])
        if (nrow(dtf) > 0) {
            if (length(dim(ary)) == 1) {
                for(j in 1:nrow(dtf)) {
                  ary[dtf[j, 1]] <- dtf[j, 'value']
                }
            } else if (length(dim(ary)) == 2) {
                for(j in 1:nrow(dtf)) {
                  ary[dtf[j, 1], dtf[j, 2]] <- dtf[j, 'value']
                }
            } else if (length(dim(ary)) == 3) {
                for(j in 1:nrow(dtf)) {
                  ary[dtf[j, 1], dtf[j, 2], dtf[j, 3]] <- dtf[j, 'value']
                }
            } else if (length(dim(ary)) == 4) {
                for(j in 1:nrow(dtf)) {
                  ary[dtf[j, 1], dtf[j, 2], dtf[j, 3], dtf[j, 4]] <- dtf[j, 'value']
                }
            } else if (length(dim(ary)) == 5) {
                for(j in 1:nrow(dtf)) {
                  ary[dtf[j, 1], dtf[j, 2], dtf[j, 3], dtf[j, 4], dtf[j, 5]] <- dtf[j, 'value']
                }
            } else stop('Internal error')
        }
      }
      dta[[i]] <- ary
   }
   rs@data <- dta
   rs
}
