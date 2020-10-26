#---------------------------------------------------------------------------------------------------------
#! print.region < -function(x) : print region
#---------------------------------------------------------------------------------------------------------
print.region <- function(x) {
    cat('Name: ', x@name, '\n')
    if (x@type != '') cat('type: ', x@type, '\n')
    if (x@description != '') cat('description: ', x@description, '\n')
    if (!is.null(x@misc$color)) cat('color: ', x@misc$color, '\n')
}

