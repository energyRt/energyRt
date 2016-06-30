#---------------------------------------------------------------------------------------------------------
#! print.sysInfo < -function(x) : print model
#---------------------------------------------------------------------------------------------------------
print.sysInfo <- function(x) {
    # print model
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    if (is.null(x@region)) {
      cat('There is no region')
    } else {
      cat('region:\n')
      print(x@region)
    }
    if (is.null(x@year)) {
      cat('There is no year')
    } else {
      cat('year:\n')
      print(x@year)
    }
    if (is.null(x@region)) {
      cat('There is no slice')
    } else {
      cat('slice:\n')
      print(x@slice)
    }
    if_print_data_frame(x, 'DummyImport')
    if_print_data_frame(x, 'discount')
    #if_print_data_frame(x, 'tax')   
    if_print_data_frame(x, 'default')
    if_print_data_frame(x, 'interpolation')
}

