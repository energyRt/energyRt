#---------------------------------------------------------------------------------------------------------
#! add_to_model <- function(x, y) : Add to model
#---------------------------------------------------------------------------------------------------------
add.model <- function(obj, ..., overwrite = FALSE, repos.name = NULL) {
  cls <- c('technology', 'commodity', 'region', 'commodity', 'constraint', 'cost', 
           'stock', 'supply', 'weather', 'demand', 'reserve', 'trade', 'export', 'import', 'storage', 'tax', 'sub')
  if (class(obj) != "model") stop('Wrong argument')
  app <- list(...)
  while (any(sapply(app, class) == 'list')) {
    fl <- seq_along(app)[sapply(app, class) == 'list']
    for (i in fl) {
      for (j in seq_along(app[[i]])) {
        app[[length(app) + 1]] <- app[[i]][[j]]
      }
    }
    app <- app[-fl]
  }
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
        warning('"repos.name" is not specified, adding objects to "', repos.name, '" repository')
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
    for (i in seq(along = app)) {
      obj@data[[fl]] <- add(obj@data[[fl]], app[[i]], overwrite = overwrite)
    }
  }
  app <- list(...)
  if (any(sapply(app, class) == 'repository')) {
    #    if (any(sapply(app, class) != 'repository'))
    #      stop('You can not mix class repository and other for command add')
    app <- app[sapply(app, class) == 'repository']
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    for (i in seq(along = app)) {
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

 


