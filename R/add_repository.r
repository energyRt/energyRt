#---------------------------------------------------------------------------------------------------------
#! add_to_repository <- function(x, add) : Add to repository
#---------------------------------------------------------------------------------------------------------
# if (!isClassUnion('repository')) setClassUnion("repository")
# Add in repository


add.repository <- function(obj, app, ..., overwrite = FALSE) {
  if (length(list(...)) != 0)  {
    obj <- add(obj, app, overwrite = overwrite)
    arg <- list(...)
    for(i in seq(along = arg))
      obj <- add(obj, arg[[i]], overwrite = overwrite)
  } else if (class(app) == 'repository') {
    for(i in seq(along = app@data))
      obj <- add(obj, app@data[[i]], overwrite = overwrite)
  } else if (class(app) == 'list') {
    for(i in seq(along = app))
      obj <- add(obj, app[[i]], overwrite = overwrite)
  } else {
    #if (class(add) != tolower(sub('^.', '', class(x)))) stop('Error type to repository')
    if (all(class(app) != c('technology', 'commodity', 'region', 'commodity', 'constrain', 
    'stock', 'supply', 'weather', 'demand', 'reserve', 'trade', 'export', 'import', 'storage', 'statement'))) 
      stop('Error type to repository ', class(app))
    if (app@name == '' || any(sapply(obj@data, function(z) app@name == z@name & class(app) == class(z)))) { 
      if (app@name == '' || !overwrite) stop('Wrong name')
      obj@data <- obj@data[!sapply(obj@data, function(z) app@name == z@name & class(app) == class(z))]
    }
    if (sub('[[:alpha:]][[:alnum:]_]*', '', app@name) != '') stop('Wrong name')
    #zz <- c(names(x@data), add@name)
    obj@data[[app@name]] <- app
  }
  obj
}
