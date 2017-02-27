#---------------------------------------------------------------------------------------------------------
#! print.model < -function(x) : print model
#---------------------------------------------------------------------------------------------------------
print.model <- function(x) {
    # print model
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    cat('Name: ', x@name, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    print(x@sysInfo)
    if (length(x@data) != 0) {
      for(i in 1:length(x@data)) {
        cat('Repository ', i, '(', class(x@data[[i]]), '):\n', sep = '')
        print(x@data[[i]])
      }
    }
}

