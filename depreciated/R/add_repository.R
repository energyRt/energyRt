[moved to class_repository.R]

#-------------------------------------------------------------------------------
# ! add_to_repository <- function(x, add) : Add to repository
#-------------------------------------------------------------------------------
# if (!isClassUnion('repository')) setClassUnion("repository")
# Add to repository

add.repository <- function(obj, app, ..., overwrite = FALSE) {
  if (length(list(...)) != 0) {
    obj <- add(obj, app, overwrite = overwrite)
    arg <- list(...)
    for (i in seq(along = arg)) {
      obj <- add(obj, arg[[i]], overwrite = overwrite)
    }
  } else if (class(app) == "repository") {
    for (i in seq(along = app@data)) {
      obj <- add(obj, app@data[[i]], overwrite = overwrite)
    }
  } else if (class(app) == "list") {
    for (i in seq(along = app)) {
      obj <- add(obj, app[[i]], overwrite = overwrite)
    }
  } else {
    # if (class(add) != tolower(sub('^.', '', class(x)))) stop('Error type to repository')
    if (all(class(app) != c(
      "technology", "commodity", "region", "commodity", "constraint", "costs",
      "stock", "supply", "weather", "demand", "reserve", "trade",
      "export", "import", "storage", "tax", "sub"
    ))) {
      stop("Error type to repository ", class(app))
    }
    if (app@name == "" ||
        any(sapply(obj@data, function(z) app@name == z@name & class(app) == class(z)))) {
      if (app@name == "" || !overwrite) stop("Check name of the object")
      obj@data <-
        obj@data[!sapply(obj@data, function(z) app@name == z@name & class(app) == class(z))]
    }
    if (sub("[[:alpha:]][[:alnum:]_]*", "", app@name) != "")
      stop("Check name of the object")
    # mx <- c(names(x@data), add@name)
    obj@data[[app@name]] <- app
  }
  obj
}
