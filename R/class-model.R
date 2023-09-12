#' S4 class to represent model
#'
#' @slot name character.
#' @slot description character.
#' @slot data list.
#' @slot config config.
#' @slot misc list.
#'
#' @include class-config.R class-repository.R
#' @return
#' @export
#'
#' @examples
setClass("model",
  representation(
    name = "character",
    description = "character", # Details
    data = "list",
    config = "config",
    # LECdata = "list",
    # early.retirement = "logical",
    misc = "list"
  ),
  prototype(
    name = "",
    description = "", # Details
    data = list(),
    config = new("config"),
    # LECdata = list(),
    # early.retirement = FALSE,
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "model", function(.Object, ...) {
  .Object
})

# add <- function(...) UseMethod("add")


add.model <- function(obj, ..., overwrite = FALSE, repo_name = NULL) {
  cls <- c('technology', 'commodity', 'region', 'commodity',
           'constraint', 'costs',
           'stock', 'reserve',
           'supply', 'weather', 'demand',
           'trade', 'export', 'import', 'storage', 'tax', 'sub')
  if (class(obj) != "model") stop('Applying add.model to class ', class(obj))
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
      !(sapply(app, class) %in% c(cls, 'repository'))]), collapse = '", "'),
      '"', sep = ''))
  }
  if (any(sapply(app, class) %in% cls)) {
    app <- app[sapply(app, class) != 'repository']
    # Generate name
    if (is.null(repo_name)) {
      if (length(obj@data) > 1) {
        repo_name <- obj@data[[length(obj@data)]]@name
        warning('"repo_name" is not specified, adding objects to "',
                repo_name, '" repository')
      } else {
        if (length(obj@data) == 0) {
          obj@data[['Default_repository']] <- new('repository',
                                                  name = 'Default_repository')
        }
        repo_name <- obj@data[[1]]@name
      }
    } else {
      ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
      if (all(ff != repo_name)) obj@data[[repo_name]] <- new('repository',
                                                               name = repo_name)
    }
    ff <- c(sapply(obj@data, function(z) z@name), recursive = TRUE)
    fl <- seq(alon = ff)[ff ==  repo_name]
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

#' Add an object to the model's repository
#'
#' @param obj model objuect
#' @param ... model elements, allowed classess: ...
#' @param overwrite logical, if TRUE, objects with the same name will be overwritten, error will be reported if FALSE
#' @param repo_name character, optional name of a (sub-)repository to add the object.
#'
#' @method add model
#' @rdname add
#'
#' @return
#' @export
setMethod("add", "model", add.model)

# summary.model <- function(mod) {
#
# }
# setMethod("summary", "model", summary.model)

#' Create new model object
#'
#' @param name name of the model
#' @param ... configuration parameters (see class config) and model elements (classes commodity, technology, etc.)
#'
#' @return
#' @export
#'
#' @examples
newModel <- function(name = "", description = "", ...) {
  args <- list(...)
  config_slots <- names(getSlots("config"))
  config_slots <- config_slots[config_slots != ".S3Class"]
  #    mlst_vec <- c('start', 'interval')
  # browser()
  mdl <- .data2slots("model", name, ignore_args = c(config_slots),
                     ignore_classes = "repository", ...)
  #    mdl <- .data2slots('model', name, ignore_args = c(mlst_vec, config_slots),
  #                       ignore_classes = 'repository', ...)
  if (any(sapply(args, class) == "repository")) {
    fl <- seq(along = args)[sapply(args, class) == "repository"]
    for (j in fl) mdl <- add(mdl, args[[j]])
  }
  config_slots <- config_slots[config_slots %in% names(args)]
  mdl@config <- .data2slots(
    "config", "", ignore_classes = "repository",
    ignore_args = c("slice", names(args)[!(names(args) %in% config_slots)]),
    ...)
  # ignore_args = c(names(args)[!(names(args) %in% config_slots)], mlst_vec), ...)

  if (any(names(args) == "slice")) {
    mdl@config <- setTimeSlices(mdl@config, slice = args$slice)
  } else {
    mdl@config <- setTimeSlices(mdl@config, slice = "ANNUAL")
  }

  #    args <- list(...)
  #    if (any(names(args) %in% mlst_vec)) {
  #      if (sum(names(args) %in% mlst_vec) != 2) stop('Undefined all need parameters for setMileStoneYears')
  #      mdl <- setMileStoneYears(mdl, start = args$start, interval = args$interval)
  #    }
  mdl
}

#' @export
setMethod("setTimeSlices", signature(obj = "model"), function(obj, ...) {
  obj@config@slice <- .setTimeSlices(...)
  obj
})

#' @export
setMethod("setHorizon",
  signature(obj = "model", horizon = "numeric", intervals = "ANY"),
  function(obj, horizon, intervals) {
    obj@config <- setHorizon(obj@config, horizon, intervals)
    obj
  }
)

#' @export
setMethod("getHorizon", signature(obj = "model"), function(obj) {
  getHorizon(obj@config)
})

