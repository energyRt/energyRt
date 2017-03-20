print.constrain <- function(x) {
  cat('Name: "', x@name, '", equation type: "', as.character(x@type), '", default value: ', x@defVal, 
    ', bound by: ', as.character(x@eq), ', rule: ', x@rule, '"\n', sep = '')
  if (nrow(x@rhs) != 0) {
    cat('rhs:\n')
    print(x@rhs)
  } else cat("Use default rhs\n")
  if (length(x@for.sum) != 0) {
    fl <- sapply(x@for.sum, is.null)
    if (any(fl)) 
      cat('all sum set values set: "', 
        paste(names(x@for.sum)[fl], collapse = '", "'), '"\n', sep = '')
    if (any(!fl)) {
      cat('Sum set:\n')
      for(i in names(x@for.sum)[!fl]) 
        cat(i, ': "', paste(x@for.sum[[i]], collapse = '", "'), '"\n', sep = '')
    }
  } #else cat("There isn't set\n")
  if (length(x@for.each) != 0) {
    fl <- sapply(x@for.each, is.null)
    if (any(fl)) 
      cat('all loop set values set: "', 
        paste(names(x@for.each)[fl], collapse = '", "'), '"\n', sep = '')
    if (any(!fl)) {
      cat('Loop set:\n')
      for(i in names(x@for.each)[!fl]) 
        cat(i, ': "', paste(x@for.each[[i]], collapse = '", "'), '"\n', sep = '')
    }
  } 
}
