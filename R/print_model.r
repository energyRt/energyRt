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
    #cat('Default dummy import value: ', x@defaultDummyImport, '\n')
    print(x@sysInfo)
    #if_print_data_frame(x, 'DummyImport')
    #if_print_data_frame(x, 'discount')
    #if_print_data_frame(x, 'default')
    #if_print_data_frame(x, 'interpolation')
    #if (!is.null(x@precompiledData)) cat('There is precompiled data\n') else cat('There isn\'t precompiled data\n')
    if (length(x@data) != 0) {
      for(i in 1:length(x@data)) {
        cat('Repository ', i, '(', class(x@data[[i]]), '):\n', sep = '')
        print(x@data[[i]])
      }
    }
}

