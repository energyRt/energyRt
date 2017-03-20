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
    for(i in c('region', 'year', 'milestone', 'slice')) {
      if (is.null(slot(x, i))) {
        cat('There is no ', i, '\n', sep = '')
      } else {
        cat(i, ':\n', sep = '')
        print(slot(x, i))
      }
    }
    if_print_data_frame(x, 'debug')
    if_print_data_frame(x, 'discount')
    #if_print_data_frame(x, 'tax')   
    if_print_data_frame(x, 'defVal')
    if_print_data_frame(x, 'interpolation')
}

