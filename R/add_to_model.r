#---------------------------------------------------------------------------------------------------------
#! add_to_model <- function(x, y) : Add to model
#---------------------------------------------------------------------------------------------------------
add_to_model <- function(obj, ...) {
  if (class(obj) != "model") stop('Wrong argument')
  app <- list(...)
  if (length(app) == 1 && class(app[[1]]) != "list") {
    app <- app[[1]]
    if (class(app) != "repository") {
      reps <- new('repository', name = app@name)
      reps <- add(reps, app)
      app <- reps
    }
    #if (all(obj@.S3Class != "repository")) stop('Wrong argument')
    if (app@name == "" || any(sapply(obj@data, function(z) z@name) == app@name)) stop('Wrong repository name')
    obj@data[[app@name]] <- app
  } else {
    if (sapply(app, class) == 'repository') {
      for(i in seq(along = app)) {
        obj <- add(obj, app[[i]])
      }
    } else {
      rr <- new('repository')
      for(i in seq(along = app)) {
        rr <- add(rr, app[[i]])
      }
      obj <- add(obj, rr)
    }
  }
  obj
}

add.model <- add_to_model


