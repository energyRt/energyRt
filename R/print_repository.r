#---------------------------------------------------------------------------------------------------------
#! 
#---------------------------------------------------------------------------------------------------------
print.repository <- function(x) {
    cat('Name: ', x@name, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
      for(i in seq(along = x@data)) {
        cat(class(x@data[[i]]), ' ', i, ':\n', sep = '')
        print(x@data[[i]])
      }
}
