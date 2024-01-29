[moded to classess]
# ToDo: rewrite 'new***' methods to functions, move them to relevant classes

# .data2slots('technology')
# print(newTechnology('technology', 'd3', description = 'jk', cap2act = 4,
#  units = data.frame(capacity = 'MV', fixom = 'j', stringsAsFactors = FALSE)))

# setGeneric("newTechnology", function(name, ...) standardGeneric("newTechnology"))
# Create new technology object
#
# @name newTechnology
#
# setMethod("newTechnology", signature(name = "character"), function(name, ...) {
#   .data2slots("technology", name, ...)
# })


# newTechnology()

# setGeneric("update", function(obj, ...) standardGeneric("update"))
#' Update an object
#'
# setMethod('update', signature(obj = 'technology'), function(obj, ...)
# update.technology <- function(obj, ...) .data2slots("technology", obj, ...)

# setGeneric("newCommodity", function(name, ...) standardGeneric("newCommodity"))
#' Create new commodity object
#'
# @name newCommodity
#'
# setMethod("newCommodity", signature(name = "character"), function(name, ...) {
#   .data2slots("commodity", name, ...)
# })

# setMethod('update', signature(obj = 'commodity'), function(obj, ...)
# update.commodity <- function(obj, ...) .data2slots("commodity", obj, ...)

# setGeneric("newDemand", function(name, ...) standardGeneric("newDemand"))
#' Create new demand object
#'
# @name newDemand
#'
# setMethod("newDemand", signature(name = "character"), function(name, ...) {
#   .data2slots("demand", name, ...)
# })
#
# # setMethod('update', signature(obj = 'demand'), function(obj, ...)
# update.demand <- function(obj, ...) {
#   .data2slots("demand", obj, ...)
# }

#' setGeneric("newSupply", function(name, ...) standardGeneric("newSupply"))
#' #' Create new supply object
#' #'
#' #' @name newSupply
#' #'
#' setMethod("newSupply", signature(name = "character"), function(name, ...) {
#'   .data2slots("supply", name, ...)
#' })

# # setMethod('update', signature(obj = 'supply'), function(obj, ...)
# update.supply <- function(obj, ...) {
#   .data2slots("supply", obj, ...)
# }

#' setGeneric("newExport", function(name, ...) standardGeneric("newExport"))
#' #' Create new export object
#' #'
#' #' @name newExport
#' #'
#' setMethod("newExport", signature(name = "character"), function(name, ...) {
#'   .data2slots("export", name, ...)
#' })

# # setMethod('update', signature(obj = 'export'), function(obj, ...)
# update.export <- function(obj, ...) {
#   .data2slots("export", obj, ...)
# }

#' setGeneric("newImport", function(name, ...) standardGeneric("newImport"))
#' #' Create new import object
#' #'
#' #' @name newImport
#' #'
#' setMethod("newImport", signature(name = "character"), function(name, ...) {
#'   .data2slots("import", name, ...)
#' })

# # setMethod('update', signature(obj = 'import'), function(obj, ...)
# update.import <- function(obj, ...) {
#   .data2slots("import", obj, ...)
# }

#' setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#' #' Create new repository object
#' #'
#' #' @name newRepository
#' #'
#' setMethod("newRepository", signature(name = "character"), function(name, ...) {
#'   in_rep <- c("commodity", "technology", "supply", "demand", "trade", "import", "export", "trade", "storage")
#'   rps <- .data2slots("repository", name, drop_class = in_rep, ...)
#'   arg <- list(...)
#'   arg <- arg[sapply(arg, class) %in% in_rep]
#'   if (length(arg) > 0) rps <- add(rps, arg)
#'   rps
#' })

#' setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' #' Create new model object
#' #'
#' #' @name newModel
#' #'
#'
#' setMethod("newModel", signature(name = "character"), function(name, ...) {
#'   sysInfVec <- names(getSlots("sysInfo"))
#'   sysInfVec <- sysInfVec[sysInfVec != ".S3Class"]
#'   #    mlst_vec <- c('start', 'interval')
#'   args <- list(...)
#'   # browser()
#'   mdl <- .data2slots("model", name, drop_args = c(sysInfVec), drop_class = "repository", ...)
#'   #    mdl <- .data2slots('model', name, drop_args = c(mlst_vec, sysInfVec), drop_class = 'repository', ...)
#'   if (any(sapply(args, class) == "repository")) {
#'     fl <- seq(along = args)[sapply(args, class) == "repository"]
#'     for (j in fl) mdl <- add(mdl, args[[j]])
#'   }
#'   sysInfVec <- sysInfVec[sysInfVec %in% names(args)]
#'   mdl@sysInfo <- .data2slots("sysInfo", "",
#'     drop_class = "repository",
#'     #      drop_args = c(names(args)[!(names(args) %in% sysInfVec)], mlst_vec), ...)
#'     drop_args = c("slice", names(args)[!(names(args) %in% sysInfVec)]), ...
#'   )
#'   if (any(names(args) == "slice")) {
#'     mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = args$slice)
#'   } else {
#'     mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = "ANNUAL")
#'   }
#'   #    args <- list(...)
#'   #    if (any(names(args) %in% mlst_vec)) {
#'   #      if (sum(names(args) %in% mlst_vec) != 2) stop('Undefined all need parameters for setMileStoneYears')
#'   #      mdl <- setMileStoneYears(mdl, start = args$start, interval = args$interval)
#'   #    }
#'   mdl
#' })


# setGeneric("newTrade", function(name, ...) standardGeneric("newTrade"))
# setMethod("newTrade", signature(name = "character"), function(name, ..., source = NULL, destination = NULL, avaUpDef = Inf) {
#   trd <- .data2slots("trade", name, ...)
#   if (avaUpDef != Inf) {
#     trd@trade[nrow(trd@trade) + 1, ] <- NA
#     trd@trade[nrow(trd@trade), "ava.up"] <- avaUpDef
#   }
#   if (is.null(source) != is.null(destination)) {
#     stop('Inconsistency of source/destination data "', trd@name, '"')
#   }
#   if (!is.null(source) && !is.null(list(...)$routes)) {
#     stop('Inconsistency of source/destination with routes data "', trd@name, '"')
#   }
#   if (!is.null(source)) {
#     trd@routes <- merge(
#       data.frame(src = source, stringsAsFactors = FALSE),
#       data.frame(dst = destination, stringsAsFactors = FALSE)
#     )
#     trd@routes <- trd@routes[trd@routes$src != trd@routes$dst, , drop = FALSE]
#   }
#   trd
# })


#' setGeneric("newStorage", function(name, ...) standardGeneric("newStorage"))
#' #' Create new import object
#' #'
#' #' @name newStorage
#' #'
#' setMethod("newStorage", signature(name = "character"), function(name, ...) {
#'   .data2slots("storage", name, ...)
#' })
#'
#' # setMethod('update', signature(obj = 'storage'), function(obj, ...)
#' update.storage <- function(obj, ...) {
#'   .data2slots("storage", obj, ...)
#' }


#' setGeneric("newWeather", function(name, ...) standardGeneric("newWeather"))
#' #' Create new weather object
#' #'
#' #' @name newWeather
#' #'
#' setMethod("newWeather", signature(name = "character"), function(name, ...) {
#'   .data2slots("weather", name, ...)
#' })
#'
#' # setMethod('update', signature(obj = 'weather'), function(obj, ...)
#' update.weather <- function(obj, ...) {
#'   .data2slots("weather", obj, ...)
#' }

# setGeneric("newTax", function(name, ...) standardGeneric("newTax"))
# setMethod("newTax", signature(name = "character"), function(name, ...) {
#   .data2slots("tax", name = name, ...)
# })
# setGeneric("newSub", function(name, ...) standardGeneric("newSub"))
#
# setMethod("newSub", signature(name = "character"), function(name, ..., value = NULL) {
#   .data2slots("sub", name = name, ...)
# })
