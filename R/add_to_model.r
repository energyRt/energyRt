#---------------------------------------------------------------------------------------------------------
#! add_to_model <- function(x, y) : Add to model
#---------------------------------------------------------------------------------------------------------
add_to_model <- function(obj, ...) {
  if (class(obj) != "model") stop('Wrong argument')
  app <- list(...)
  if (length(app) == 1) {
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
    for(i in seq(along = app)) {
      obj <- add_to_model(obj, app[[i]])
    }
  }
  obj
}

add.model <- add_to_model


