#' An S4 class to store the model objects.
#'
#' @slot name character. Name of the repository.
#' @slot description character, short description of the purpose or content of the repository.
#' @slot data list with the model classes, including other repositories, excluding model and scenario classes.
#' @slot misc list, any additional data or information to store in the object.
#'
#' @include class-costs.R
#'
#' @export
#'
setClass("repository",
  representation(
    name = "character",
    description = "character", # Details
    data = "list",
    misc = "list"
  ),
  prototype(
    name = "default_repository",
    description = "", # Details
    data = list(),
    misc = list()
  ),
  S3methods = TRUE
)
setMethod("initialize", "repository", function(.Object, ...) {
  .Object
})


#' @export
setMethod("[[", c("repository", "ANY"),
  function(x, name) x@data[[name]]
)
setMethod("$", "repository", function(x, name) x@data[[name]])

setReplaceMethod("$", c("repository", "ANY"),
  function(x, name, value) {
    nm <- names(x@data)
    ii <- which(nm == value@name)
    if (length(ii) > 0) {
      # replace name
      nm[ii] <- value@name
      x@data[[name]] <- value
      names(x@data) <- nm
    } else {
      x@data[[name]] <- value
    }
    x
  }
)

#
# setReplaceMethod("[[", c("repository", "ANY", "ANY"),
#                  function(x, name, value) {
#                    x@data[[name]] = value
#                    x
#                  }
# )

setMethod("names", "repository", function(x) names(x@data))

setMethod("print", "repository", function(x) {
  data.frame(
    name = sapply(x@data, function(x) x@name),
    class = sapply(x@data, class)
  )
})

setMethod("show", "repository", function(object) print(object))

setMethod("length", "repository", function(x) length(x@data))

summary.repository <- function(object) {
  x <- sapply(object@data, class)
  x <- as.factor(x)
  return(summary(x))
}

#-------------------------------------------------------------------------------
# ! add_to_repository <- function(x, add) : Add to repository
#-------------------------------------------------------------------------------
# if (!isClassUnion('repository')) setClassUnion("repository")
# Add to repository

add <- function(...) UseMethod("add")

#' @method add repository
#' @export
#'
#' @rdname add
#'
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
    if (sub("[[:alpha:]][[:alnum:]_]*", "", app@name) != "") {
      stop("Check name of the object")
    }
    # mx <- c(names(x@data), add@name)
    obj@data[[app@name]] <- app
  }
  obj
}

setMethod("add", "repository", add.repository)


setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#' Create new repository object
#'
#' @name newRepository
#'
setMethod("newRepository", signature(name = "character"), function(name, ...) {
  in_rep <- c("commodity", "technology", "supply", "demand", "trade", "import", "export", "trade", "storage")
  rps <- .data2slots("repository", name, ignore_classes = in_rep, ...)
  arg <- list(...)
  arg <- arg[sapply(arg, class) %in% in_rep]
  if (length(arg) > 0) rps <- add(rps, arg)
  rps
})
