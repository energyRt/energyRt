# Add variable to constrain
.add_variable <- function(x, parameter, ext_set = NULL, ...) {
  if (is.null(ext_set)) ext_set <- x@set
  x@variable[[length(x@variable) + 1]] <- create_cnsVariable(parameter, ext_set = ext_set, ...)
  x
}
