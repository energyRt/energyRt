#---------------------------------------------------------------------------------------------------------
# Model : get_repository_name()
#---------------------------------------------------------------------------------------------------------
get_model_repository_name <- function(x, type = NULL) {
  if (class(x) != 'model') stop('Wrong class')
  if (is.null(type)) {
    sapply(x@data, function(x) x@name)
  } else {
    sapply(x@data, function(x) x@name)[sapply(x@data, function(x) class(x)) == type]
  }
}