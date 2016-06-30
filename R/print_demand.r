#---------------------------------------------------------------------------------------------------------
#! print.demand < -function(x) : print demand
#---------------------------------------------------------------------------------------------------------
print.demand <- function(x) {
    # print demand
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    cat('Name: ', x@name, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    cat('Commodity: ', x@commodity, '\n')
    g <- getClass("demand")
    zz <- names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == 
        "data.frame")]
    for(i in zz) if_print_data_frame(x, i)
}

