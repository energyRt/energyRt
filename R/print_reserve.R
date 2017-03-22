#---------------------------------------------------------------------------------------------------------
#! print.reserve < -function(x,...) : print reserve
#---------------------------------------------------------------------------------------------------------
print.reserve <- function(x,...) {
  reserve_data_frame <- function ()  {
      g <- getClass("reserve")
      names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == 
          "data.frame")]
  }
  # print reserve
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    cat('Name: ', x@name, ', commodity: "', x@commodity, '"\n')
    if (x@commodity == "") cat('Unexceptable commodity\n')
    if (x@description!='') cat('description: ', x@description, '\n')
    for(i in reserve_data_frame()) if_print_data_frame(x, i)
}