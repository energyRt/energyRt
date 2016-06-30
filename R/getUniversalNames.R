getUniversalNames <- function(obj, cls, condition) {
  if (any(class(obj) == 'scenario')) obj <- obj@model
  if (any(class(obj) == 'model')) {
    rs <- list()
    for(i in seq(along = obj@data))
      rs[[i]] <- getUniversalNames(obj@data[[i]], cls, condition)
    rs <- c(rs, recursive = TRUE)
    if (anyDuplicated(rs) != 0)
        stop('There are duplicated ', cls, ' name, first duplicated name: "', rs[anyDuplicated(rs)], '"')
    return(rs)
  } else {
     names(obj@data)[sapply(obj@data, function(x) (any(class(x) == cls) && condition(x)))]
  }
}

getUniversalName <- function(obj, cls, name = NULL, description = NULL, ...) {
  rs <- c()
  if (!is.null(name) && !is.null(description)) {
    return(getUniversalNames(obj, cls, function(x)
      any(grep(description, x@description, ...)) && any(grep(name, x@name, ...))))
  } else if (is.null(name) && !is.null(description)) {
    return(getUniversalNames(obj, cls, function(x) any(grep(description, x@description, ...))))
  } else if (!is.null(name) && is.null(description)) {
    return(getUniversalNames(obj, cls, function(x) any(grep(name, x@name, ...))))
  } else stop('There is not conditions')
}

getTechnologyName <- function(obj, name = NULL, description = NULL, ...) getUniversalName(obj, "technology", name, description, ...)
getCommodityName <- function(obj, name = NULL, description = NULL, ...) getUniversalName(obj, "commodity", name, description, ...)
getSupplyName <- function(obj, name = NULL, description = NULL, ...) getUniversalName(obj, "supply", name, description, ...)
getDemandName <- function(obj, name = NULL, description = NULL, ...) getUniversalName(obj, "demand", name, description, ...)

#sapply(c('technology', 'commodity', 'supply', 'demand'), function(x)
#  cat('get', toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)),
#    'Name <- function(obj, name = NULL, description = NULL, ...) getUniversalName(obj, "',
#     x, '", name, description, ...)\n', sep = '')
#)

