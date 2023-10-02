# class model ####
# setTimeSlices <- .setTimeSlices

#' S4 class to represent model
#'
#' @slot name character.
#' @slot desc character.
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
    desc = "character", # Details
    data = "list",
    config = "config",
    # LECdata = "list",
    # early.retirement = "logical",
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "", # Details
    data = list(),
    config = new("config"),
    # LECdata = list(),
    # early.retirement = FALSE,
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "model", function(.Object, ...) {
  .Object
})

# add <- function(...) UseMethod("add")


add.model <- function(obj, ..., overwrite = FALSE, repo_name = NULL) {
  # browser()
  # cls <- c('technology', 'commodity', 'region', 'commodity',
  #          'constraint', 'costs',
  #          'stock', 'reserve',
  #          'supply', 'weather', 'demand',
  #          'trade', 'export', 'import', 'storage', 'tax', 'sub')
  cls <- newRepository()@permit
  # if (class(obj) != "model") stop('Applying add.model to class ', class(obj))
  arg <- list(...)
  while (any(sapply(arg, function(x) class(x)[1] == 'list'))) {
    # fl <- seq_along(arg)[sapply(arg, class) == 'list']
    # for (i in fl) {
    #   for (j in seq_along(arg[[i]])) {
    #     arg[[length(arg) + 1]] <- arg[[i]][[j]]
    #   }
    # }
    # arg <- arg[-fl]
    arg <- list_flatten(arg, name_spec = "{inner}")
  }
  if (any(!(sapply(arg, class) %in% c(cls, 'repository')))) {
    stop(paste('Unknown class "', paste(unique(sapply(arg, class)[
      !(sapply(arg, class) %in% c(cls, 'repository'))]), collapse = '", "'),
      '"', sep = ''))
  }
  # cc <- sapply(arg, function(x) class(x)[1])
  ii <- sapply(arg, function(x) inherits(x, cls))
  if (any(ii)) {
    # arg <- arg[cc != 'repository']
    # Generate name
    if (is.null(repo_name)) {
      # if (length(obj@data) >= 1) {
      #   # repo_name <- obj@data[[length(obj@data)]]@name
      #   repo_name <- names(obj@data)[length(obj@data)]
      #   warning('"repo_name" is not specified, adding objects to "',
      #           repo_name, '" repository')
      # } else {
        # if (length(obj@data) == 0) {
      add_repo <- new('repository', repo_name)
      repo_name <- add_repo@name
      # repo_name <- "default_repository"
      if (is.null(obj@data[[repo_name]])) {
        obj@data[[repo_name]] <- add_repo
      }
        # repo_name <- obj@data[[1]]@name # default name
      # }
    } else {
      ff <- c(sapply(obj@data, function(x) x@name), recursive = TRUE)
      if (all(ff != repo_name)) {
        obj@data[[repo_name]] <- new('repository', name = repo_name)
      }
    }
    ff <- c(sapply(obj@data, function(x) x@name), recursive = TRUE)
    fl <- seq(alon = ff)[ff == repo_name]
    for (i in seq(along = arg[ii])) {
      obj@data[[fl]] <- add(obj@data[[fl]], arg[ii][[i]], overwrite = overwrite)
    }
  }
  arg <- arg[!ii]
  if (is_empty(arg)) return(obj)
  # cc <- sapply(arg, function(x) class(x)[1])
  ii <- sapply(arg, function(x) inherits(x, "repository"))
  if (any(ii)) {
    #    if (any(sapply(arg, class) != 'repository'))
    #      stop('You can not mix class repository and other for command add')
    # arg <- arg[sapply(arg, class) == 'repository']
    ff <- c(sapply(obj@data, function(x) x@name), recursive = TRUE)
    for (i in seq(along = arg[ii])) {
      nm <- arg[ii][[i]]@name # new repository name
      if (nm == "") stop('Empty repository name is not allowed.')
      if (any(ff == nm)) {
        # add data to existing repository
        obj@data[[nm]] <- add(obj@data[[nm]], arg[ii][[i]])
      } else {
        # !!! add name-check with other repositories
        obj@data[[nm]] <- arg[ii][[i]]
      }
    }
    arg <- arg[!ii]
  }
  # check duplicated names in class
  hh <- c(
    sapply(obj@data, function(x) {
      sapply(x@data, function(y) paste(class(y), ' - ', y@name, sep = ''))
      }), recursive = TRUE)
  if (anyDuplicated(hh)) {
    hh <- unique(hh[duplicated(hh)])
    stop('Duplicated objects in "class - name"\n',
         paste(hh, sep = "\n"))
  }
  ## check duplicated names in all objects
  ff <- c(lapply(obj@data, function(x) sapply(x@data, function(y) y@name)),
          recursive = TRUE)
  if (anyDuplicated(ff)) {
    stop(paste('Duplicated objects "',
               paste(unique(ff[duplicated(ff)]), collapse = '", "'),
               '"', sep = ''))
  }
  if (length(arg) > 0) {
    warning("Ignored objects: ", paste(names(arg), ", "))
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
#' @rdname newModel
#' @return
#' @export
#'
#' @examples
newModel <- function(name = "", desc = "", ...) {
  # browser()
  # mdl <- .data2slots("model", name,
  #                    ignore_args = unique(c(config_slots, horizon_slots)),
  #                    ignore_classes = "repository", ...)
  obj <- new("model")
  obj@name <- name
  obj@desc <- desc
  arg <- list(...)
  if (is_empty(arg)) return(obj)
  #
  ## named slots ####
  repo <- newRepository("default")
  ### @misc ####
  if (!is.null(arg$misc)) {
    if (!inherits(arg$misc, "list")) stop('"misc" must be a named list')
    if (is_empty(obj@misc)) {
      obj@misc <- arg$misc
    } else {
      obj@misc <- c(obj@misc, arg$misc)
    }
    arg$misc <- NULL}
  ### @data | @repository ####
  if (!is.null(arg$data) | !is.null(arg$repository)) {
    if (is.null(arg$data)) {
      arg$data <- arg$repository; arg$repository <- NULL
    } else {
      if (!is.null(arg$repository))
        stop("Only one of 'data' or 'repository' arguments can be assigned.")
    }
    if (inherits(arg$data, c("repository"))) {
      repo <- arg$data
    } else if (!inherits(arg$data, "list")) {
      repo <- do.call("add", c(object = repo, arg$data))
    } else {
      stop('"data" ("repository") must be a "repository" or "list" object')
    }
    # obj@data <- repo@data
    obj <- add(obj, arg$data)
    arg$data <- NULL
  }
  ### @config ####
  if (!is.null(arg$config)) {
    if (!inherits(arg$config, "config")) {
      stop('"config" argument must be an object of class "cofig"')
    }
    obj@config <- arg$config
    arg$config <- NULL
  }
  ### @horizon ####
  if (!is.null(arg$horizon)) {
    if (!inherits(arg$horizon, "horizon")) {
      stop('"horizon" argument must be an object of class "horizon"')
    }
    obj@config@horizon <- arg$horizon
    arg$horizon <- NULL
  }
  ### @horizon ####
  if (!is.null(arg$calendar)) {
    if (!inherits(arg$calendar, "calendar")) {
      stop('"calendar" argument must be an object of class "calendar"')
    }
    obj@config@calendar <- arg$calendar
    arg$calendar <- NULL
  }
  if (is_empty(arg)) return(obj)
  #
  ## unnamed args, process by class ####
  ### repository objects ####
  ii <- sapply(arg, function(x) inherits(x, c("repository")))
  if (any(ii)) {
    for (ob in arg[ii]) {obj <- add(obj, ob)}
  }
  arg <- arg[!ii]
  ### @config obj ####
  ii <- sapply(arg, function(x) inherits(x, c("config")))
  if (any(ii)) {
    if (sum(ii) > 1) stop('Two or more "config" objects found.')
    obj@config <- arg[ii]
    arg[ii] <- NULL
  }
  ### @horizon obj ####
  ii <- sapply(arg, function(x) inherits(x, c("horizon")))
  if (any(ii)) {
    if (sum(ii) > 1) stop('Two or more "horizon" objects found.')
    obj@config@horizon <- arg[ii]
    arg[ii] <- NULL
  }
  if (is_empty(arg)) return(obj)
  #
  ## named other slots ####
  ex_slots <- c(".S3Class", "name", "desc")
  ### @config slots ####
  config_slots <- names(getSlots("config"))
  config_slots <- config_slots[!(config_slots %in% ex_slots)]
  ii <- names(arg) %in% config_slots
  if (any(ii)) {
    obj@config <- do.call("update", c(object = obj@config, arg[ii]))
    arg[ii] <- NULL
  }
  if (is_empty(arg)) return(obj)
  ### @horizon slots #### !!! write update(config) with config & horizon slots
  horizon_slots <- names(getSlots("horizon"))
  horizon_slots <- horizon_slots[!(horizon_slots %in% ex_slots)]
  ii <- names(arg) %in% horizon_slots
  if (any(ii)) {
    obj@config@horizon <- .data2slots("horizon", obj@config@horizon, arg[ii])
    obj@config@horizon <- do.call("update",
                                  c(object = obj@config@horizon, arg[ii]))
    arg[ii] <- NULL
  }
  if (is_empty(arg)) return(obj)
  ii <- sapply(arg, inherits, what = newRepository()@permit)
  if (any(ii)) obj <- add(obj, arg[ii])
  arg <- arg[!ii]
  if (is_empty(arg)) return(obj)
  warning("Ignoring ", length(arg), " arguments.\n",
          "names: ", paste(names(arg), collapse = ", "), "\nclasses: ",
          paste(sapply(arg, class), collapse = ", "))
  obj
#
#   config_slots <- config_slots[config_slots %in% names(args)]
#   mdl@config <- .data2slots(
#     "config", "", ignore_classes = "repository",
#     ignore_args = c("slice", names(args)[!(names(args) %in% config_slots)]),
#     ...)
#   # ignore_args = c(names(args)[!(names(args) %in% config_slots)], mlst_vec), ...)
#
#   if (any(names(args) == "slice")) {
#     mdl@config <- setTimeSlices(mdl@config, slice = args$slice)
#   } else {
#     mdl@config <- setTimeSlices(mdl@config, slice = "ANNUAL")
#   }
#
#   #    args <- list(...)
#   #    if (any(names(args) %in% mlst_vec)) {
#   #      if (sum(names(args) %in% mlst_vec) != 2) stop('Undefined all need parameters for setMileStoneYears')
#   #      mdl <- setMileStoneYears(mdl, start = args$start, interval = args$interval)
#   #    }
#   mdl
}

# @export
# setMethod("setTimeSlices", signature(obj = "model"), function(obj, ...) {
#   obj@config@slice <- .setTimeSlices(...)
#   obj
# })

#' @rdname newModel
#' @export
setMethod("setHorizon", signature(obj = "model"),
  # signature(obj = "model", horizon = "numeric", intervals = "ANY"),
  function(obj, horizon, intervals) {
    obj@config <- setHorizon(obj@config, horizon, intervals)
    obj
  }
)

#' @rdname newModel
#' @export
setMethod("getHorizon", signature(obj = "model"), function(obj) {
  getHorizon(obj@config)
})

