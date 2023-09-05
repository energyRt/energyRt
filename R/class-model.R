#' S4 class to represent model
#'
#' @slot name character.
#' @slot description character.
#' @slot data list.
#' @slot sysInfo sysInfo.
#' @slot LECdata list.
#' @slot earlyRetirement logical.
#' @slot misc list.
#'
#' @include class-sysInfo.R class-repository.R
#' @return
#' @export
#'
#' @examples
setClass("model",
  representation(
    name = "character",
    description = "character", # Details
    data = "list",
    sysInfo = "sysInfo",
    LECdata = "list",
    # earlyRetirement = "logical",
    misc = "list"
  ),
  prototype(
    name = "",
    description = "", # Details
    data = list(),
    sysInfo = new("sysInfo"),
    LECdata = list(),
    # earlyRetirement = FALSE,
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "model", function(.Object, ...) {
  .Object
})

add <- function(...) UseMethod("add")

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
#'
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

summary.model <- function(mod) {

}

setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' Create new model object
#'
#' @name newModel
#'

setMethod("newModel", signature(name = "character"), function(name, ...) {
  sysInfVec <- names(getSlots("sysInfo"))
  sysInfVec <- sysInfVec[sysInfVec != ".S3Class"]
  #    mlst_vec <- c('start', 'interval')
  args <- list(...)
  # browser()
  mdl <- .data2slots("model", name, drop_args = c(sysInfVec), drop_class = "repository", ...)
  #    mdl <- .data2slots('model', name, drop_args = c(mlst_vec, sysInfVec), drop_class = 'repository', ...)
  if (any(sapply(args, class) == "repository")) {
    fl <- seq(along = args)[sapply(args, class) == "repository"]
    for (j in fl) mdl <- add(mdl, args[[j]])
  }
  sysInfVec <- sysInfVec[sysInfVec %in% names(args)]
  mdl@sysInfo <- .data2slots("sysInfo", "",
                             drop_class = "repository",
                             #      drop_args = c(names(args)[!(names(args) %in% sysInfVec)], mlst_vec), ...)
                             drop_args = c("slice", names(args)[!(names(args) %in% sysInfVec)]), ...
  )
  if (any(names(args) == "slice")) {
    mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = args$slice)
  } else {
    mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = "ANNUAL")
  }
  #    args <- list(...)
  #    if (any(names(args) %in% mlst_vec)) {
  #      if (sum(names(args) %in% mlst_vec) != 2) stop('Undefined all need parameters for setMileStoneYears')
  #      mdl <- setMileStoneYears(mdl, start = args$start, interval = args$interval)
  #    }
  mdl
})

setMethod("setTimeSlices", signature(obj = "model"), function(obj, ...) {
  obj@sysInfo@slice <- .setTimeSlices(...)
  obj
})

setMethod(
  "setMilestoneYears", signature(obj = "model", start = "numeric", interval = "numeric"),
  function(obj, start, interval) {
    obj@sysInfo <- setMilestoneYears(obj@sysInfo, start, interval)
    obj
  }
)

setMethod("getMilestoneYears", signature(obj = "model"), function(obj) {
  getMilestoneYears(obj@sysInfo)
})

