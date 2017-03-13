#---------------------------------------------------------------------------------------------------------
#! add_to_model <- function(x, y) : Add to model
#---------------------------------------------------------------------------------------------------------
add_to_model <- function(obj, ..., repos.name = NULL) {
  cls <- c('commodity', 'demand', 'supply', 'export', 'import', 'constrain', 'technology', 'trade')
  if (class(obj) != "model") stop('Wrong argument')
  app <- list(...)
  if (any(!(sapply(app, class) %in% c(cls, 'repository')))) {
    stop(paste('Unknown class "', paste(unique(sapply(app, class)[
      !(sapply(app, class) %in% c(cls, 'repository'))]), collapse = '", "'), '"', sep = ''))
  }
  if (any(sapply(app, class) %in% cls)) {
    app <- app[sapply(app, class) != 'repository']
    # Generate name
    if (is.null(repos.name)) {
      if (length(obj@data) > 1) {
        repos.name <- obj@data[[length(obj@data)]]@name
        warning('"repos.name" is not specified. Adding to "', repos.name, '" repository')
      } else {
        if (length(obj@data) == 0) obj@data[['Default_repository']] <- new('repository', name = 'Default_repository')
        repos.name <- obj@data[[1]]@name
      }
    } else {
      ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
      if (all(ff != repos.name)) obj@data[[repos.name]] <- new('repository', name = repos.name)
    }
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    fl <- seq(alon = ff)[ff ==  repos.name]
    for(i in seq(along = app)) {
      obj@data[[fl]] <- add(obj@data[[fl]], app[[i]])
    }
  }
  app <- list(...)
  if (any(sapply(app, class) == 'repository')) {
    #    if (any(sapply(app, class) != 'repository'))
    #      stop('You can not mix class repository and other for command add')
    app <- app[sapply(app, class) == 'repository']
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    for(i in seq(along = app)) {
      if (app[[i]]@name == "" || any(ff == app[[i]]@name)) stop('Wrong repository name')
      obj@data[[app[[i]]@name]] <- app[[i]]
    }
  }
  ff <- c(lapply(obj@data, function(x) sapply(x@data, function(z) z@name)), recursive = TRUE)
  if (anyDuplicated(ff)) {
    stop(paste('There are duplicated objects "', 
      paste(unique(ff[duplicated(ff)]), collapse = '", "'), '"', sep = ''))
  }
  hh <- c(sapply(obj@data, function(x) sapply(x@data, function(y) paste(class(y), ' - ', y@name, sep = ''))), 
          recursive = TRUE)
  if (anyDuplicated(hh)) {
    hh <- unique(hh[duplicated(hh)])
    cat('There are duplicated pair "class - name"\n')
    print(hh)
    stop('See previous messages')
  }
  obj
}

add.model <- add_to_model


