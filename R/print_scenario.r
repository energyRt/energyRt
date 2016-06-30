#---------------------------------------------------------------------------------------------------------
#! print.scenario < -function(x,...) : print scenario
#---------------------------------------------------------------------------------------------------------
print.scenario <- function(x) {
    cat('Name: ', x@name, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    if (!is.null(x@model)) {
      cat('Model:\n')
      print(x@model)
    }
#    if (!is.null(x@discount)) cat('Discount: ', x@discount, '\n')
#    if (!is.null(x@year)) {
#      cat('Year:\n')
#      print(x@year)
#    }
#    if (!is.null(x@slice)) {
#      cat('Slice:\n')
#      print(x@slice)
#    }
#    if (!is.null(x@repository)) {
#      cat('Repository:\n')
#      print(x@repository)
#    }
#    if (!is.null(x@result)) {
#      cat('result:\n')
#      print(x@result)
#    }
}

