#---------------------------------------------------------------------------------------------------------
#! add_to_model <- function(x, y) : Add to model
#---------------------------------------------------------------------------------------------------------
add_to_model <- function(obj, ...) {
  if (class(obj) != "model") stop('Wrong argument')
  app <- list(...)
  if (any(sapply(app, class) == 'repository')) {
    if (any(sapply(app, class) != 'repository'))
      stop('You can not mix class repository and other for command add')
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    for(i in seq(along = app)) {
      if (app[[i]]@name == "" || any(ff == app[[i]]@name)) stop('Wrong repository name')
      obj@data[[app[[i]]@name]] <- app[[i]]
    }
  } else {
    # Generate name
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    ll <- grep('^Default repository($|[ ][[:digit:]][[:digit:]]*$)', ff, value = TRUE)
    if (length(ll) == 0 || any(grep('^Default repository$', ll))) ss <- 'Default repository' else {
      ll <- gsub('^Default repository[ ]', '', ll); ll <- ll[ll != '']
      ss <- paste('Default repository ', max(as.numeric(ll)) + 1, sep = '')
    }
    reps <- new('repository', name = ss)
    for(i in seq(along = app)) {
      reps <- add(reps, app[[i]])
    }
    obj@data[[ss]] <- reps
  }
  ff <- c(lapply(obj@data, function(x) sapply(x@data, function(z) z@name)), recursive = TRUE)
  if (anyDuplicated(ff)) {
    stop(paste('There are duplicated objects "', 
      paste(unique(ff[duplicated(ff)]), collapse = '", "'), '"', sep = ''))
  }
  obj
}

add.model <- add_to_model


