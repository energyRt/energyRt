# class repository ####
#' An S4 class to store the model objects.
#'
#' @slot name character. Name of the repository.
#' @slot desc character, short desc of the purpose or content of the repository.
#' @slot data list of repositories with objects of permitted classes. All names of objects (`object@name`) must be unique.
#' @slot permit character vector with names of classes permitted to store in the repository.
#' @slot misc list, any additional data or information to store in the object.
#'
#' @export
#' @family repository
#' @include generics.R
#'
setClass("repository",
  representation(
    name = "character",
    desc = "character", # Details
    data = "list",
    permit = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "", # Details
    data = list(),
    permit = character(),
    misc = list()
  ),
  S3methods = FALSE
)

# initialize ####
setMethod("initialize", "repository", function(.Object, ...) {
  .Object@permit <- c(
    "commodity", "demand", "supply",
    "technology", "storage",
    "trade", "export", "import", "weather",
    "tax", "sub", "constraint", "costs"
  )
  .Object
})

# newRepository ####
#' Create new repository object
#' @param name character,
#'
#' @name newRepository
#' @export
#' @family repository
newRepository <- function(name = "default_repository", ...) {
  # browser()
  obj <- new("repository")
  obj@name <- name
  arg <- list(...)
  if (is_empty(arg)) return(obj)
  slots <- slotNames(obj); slots <- slots[slots != ".S3Class"]
  for (s in slots) {
    if (!is.null(arg[[s]])) {slot(obj, s) <- arg[[s]]; arg[[s]] <- NULL}
  }
  if (is_empty(arg)) return(obj)
  # obj <- do.call("add", c(obj = obj, unlist(add)))
  obj <- add(obj, arg)
  return(obj)
}

if (F) {
  newRepository() #%>% print()
  newRepository("repo", ELC, GAS) #%>% print()
  newRepository("repo", ELC, GAS, ECOA) %>% print()
  newRepository("repo", ELC, GAS, ECOA, TRBD_ELC) %>% print()

}
  # nn <- rep(FALSE, length(arg)) # imported args
  # for (i in seq_along(arg)) {
  #   if (class(arg[[i]])[1] %in% obj@permit) {
  #     obj <- add(obj, arg[[i]]); nn[[i]] <- TRUE
  #   }
  # }
  # arg <- arg[!nn]
  # N <- length(arg)
  # if (!is_empty(arg)) warning("Ignored ", N, "objects: ",
  #                             paste(head(names(arg), 100), sep = ", "),
  #                             ifelse(N > 100, "...", "."))
  # obj <- do.call(add, list(obj = obj, unlist(arg)))
  # return(obj)
  # old script
  # in_rep <- c("commodity", "technology", "supply", "demand", "trade",
  #             "import", "export", "trade", "storage")
  # rps <- .data2slots("repository", name, ignore_classes = in_rep, ...)
  # arg <- list(...)
  # arg <- arg[sapply(arg, class) %in% in_rep]
  # if (length(arg) > 0) rps <- add(rps, arg)
  # rps
# }


# Methods ####
## [[ ####
#' @export
setMethod("[[", c("repository", "ANY"),
  function(x, name) x@data[[name]]
)

## $ ####
#' @export
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

## names ####
#' @export
#' @family repository
setMethod("names", "repository", function(x) names(x@data))

## print ####
#' @export
#' @family repository
setMethod("print", "repository", function(x) {
  cat("repository '", x@name, "': ", length(x@data), " objects.",
      if_else(is_empty(x@desc) || x@desc == "", "\n",
             paste("\n", x@desc, "\n")), sep = "")
  # print(
    data.table::data.table(
      name = sapply(x@data, function(x) x@name),
      class = sapply(x@data, class)
    )
  # )
})

## show ####
#' @method show repository
#' @export
#' @family repository
setMethod("show", "repository", function(object) print(object))

## length ####
#' @method length repository
#' @export
#' @family repository
setMethod("length", "repository", function(x) length(x@data))

## summary ####
#' @export
#' @method summary repository
#' @family repository
setMethod("summary", signature(object = "repository"), function(object, ...) {
  x <- sapply(object@data, class)
  x <- as.factor(x)
  return(summary(x))
})

## add ####
#' @method add repository
#' @rdname add
#' @family repository
#' @export
setMethod("add", signature("repository"), function(obj, ..., overwrite = FALSE) {
  # browser()
  arg = list(...) %>% unlist()
  if (is_empty(arg)) return(obj)
  arg <- sapply(arg, function(x) {
    if (class(x)[1] == "repository") return(x@data)
    x
  }) %>% list_flatten()
  ii <- sapply(arg, function(x) class(x)[1] %in% obj@permit)
  for (ob in arg[ii]) {
    if (!is.null(obj@data[[ob@name]]) && !overwrite) {
      stop("Object ", ob@name, " already exists in the repository.\n",
           "Use overwrite = TRUE to replace.")
    }
    obj@data[[ob@name]] <- ob
  }
  arg[ii] <- NULL
  N <- length(arg)
  if (N > 0) {
    warning("Ignored ", N, "objects: ",
            paste(head(names(arg), 10), sep = ", "),
            ifelse(N > 10, "...", "."))
  }
  return(obj)
})

#
# setReplaceMethod("[[", c("repository", "ANY", "ANY"),
#                  function(x, name, value) {
#                    x@data[[name]] = value
#                    x
#                  }
# )

# setMethod("add", "repository", add.repository)
# setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#
# setMethod("newRepository", signature(name = "character"), function(name, ...) {
#   in_rep <- c("commodity", "technology", "supply", "demand", "trade", "import", "export", "trade", "storage")
#   rps <- .data2slots("repository", name, ignore_classes = in_rep, ...)
#   arg <- list(...)
#   arg <- arg[sapply(arg, class) %in% in_rep]
#   if (length(arg) > 0) rps <- add(rps, arg)
#   rps
# })

# setMethod("add", signature("repository", "commodity"), function())

#------------------------------------------------------------------------------#
# ! add_to_repository <- function(x, add) : Add to repository
#------------------------------------------------------------------------------#
# if (!isClassUnion('repository')) setClassUnion("repository")
# Add to repository

# add <- function(...) UseMethod("add")

# @rdname add
#
# @export
# @family repository
# add.repository <- function(obj, app, ..., overwrite = FALSE) {
#   if (length(list(...)) != 0) {
#     obj <- add(obj, app, overwrite = overwrite)
#     arg <- list(...)
#     for (i in seq(along = arg)) {
#       obj <- add(obj, arg[[i]], overwrite = overwrite)
#     }
#   } else if (class(app) == "repository") {
#     for (i in seq(along = app@data)) {
#       obj <- add(obj, app@data[[i]], overwrite = overwrite)
#     }
#   } else if (class(app) == "list") {
#     for (i in seq(along = app)) {
#       obj <- add(obj, app[[i]], overwrite = overwrite)
#     }
#   } else {
#     # if (class(add) != tolower(sub('^.', '', class(x)))) stop('Error type to repository')
#     if (all(class(app) != c(
#       # "region", "commodity", "stock", "reserve",
#       "commodity", "demand", "supply", "technology", "storage",
#       "trade", "export", "import", "weather",
#       "tax", "sub", "constraint", "costs"
#     ))) {
#       stop("Error type to repository ", class(app))
#     }
#     if (app@name == "" ||
#       any(sapply(obj@data, function(z) app@name == z@name & class(app) == class(z)))) {
#       if (app@name == "" || !overwrite) stop("Check name of the object")
#       obj@data <-
#         obj@data[!sapply(obj@data, function(z) app@name == z@name & class(app) == class(z))]
#     }
#     if (sub("[[:alpha:]][[:alnum:]_]*", "", app@name) != "") {
#       stop("Check name of the object")
#     }
#     # mx <- c(names(x@data), add@name)
#     obj@data[[app@name]] <- app
#   }
#   obj
# }
