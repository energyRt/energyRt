#---------------------------------------------------------------------------------------------------------
#! print.region < -function(x) : print region
#---------------------------------------------------------------------------------------------------------
print.region <- function(x) {
    cat('Name: ', x@name, '\n')
    if (x@type != '') cat('type: ', x@type, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    if (x@color != '') cat('color: ', x@color, '\n')
}

