#---------------------------------------------------------------------------------------------------------
#! reduce_model(x, repository = NULL) : reduce model by repository
#---------------------------------------------------------------------------------------------------------
reduce_model <- function(x, repository = NULL) {
  if (class(x) != 'model') stop('Wrong class')
  if (length(repository) == 0)  return(x)
  if (class(repository) != "character") stop('Wrong repository name')
  if (any(!(repository %in% get_model_repository_name(x)))) stop('Unknow repository')
  x@data <- x@data[repository %in% get_repository_name(x)]
  x
}

