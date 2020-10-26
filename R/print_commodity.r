#---------------------------------------------------------------------------------------------------------
#! print.commodity < -function(x) : print commodity
#---------------------------------------------------------------------------------------------------------
print.commodity <- function(x) {
    # print commodity
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    cat('Name: ', x@name, '\n')
    if (x@type != '') cat('type: ', x@type, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    if (x@origin != '') cat('Region of origin: ',x@origin, '\n')
    if (!is.null(x@misc$color)) cat('color: ', x@misc$color, '\n')
    if (length(x@source) != 0) {
      cat('source:\n')
      print(x@source)
    }
    if (length(x@other) != 0) {
      cat('other:\n')
      print(x@other)
    }
    g <- getClass("commodity")
    zz <- names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == 
        "data.frame")]
    for(i in zz) if_print_data_frame(x, i)
}

