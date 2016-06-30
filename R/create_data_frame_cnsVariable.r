# Create table for set parameter
create_data_frame.cnsVariable <- function(vrb) {
  #data_parameter <- get_result_data_parameter()
  #queque <- colnames(data_parameter)[data_parameter[vrb@parameter, ]]
  sst <- vrb@set
  for(i in names(vrb@ext_set)) sst[[i]] <- vrb@ext_set[[i]]
  fl <- (1:length(sst))[sapply(sst, function(x) !is.null(x$set))]
  if (any(fl)) {
    ary <- array(vrb@default, dim      = sapply(sst[fl], function(x) length(x$set)),
                              dimnames = lapply(sst[fl], function(x) x$set))
    dtf <- as.data.frame.table(ary)
    colnames(dtf) <- c(sapply(sst[fl], function(x) x$alias), 'value')
  } else {
    dtf <- data.frame(value = vrb@default)
  }
  vrb@value <- dtf
  vrb
}
