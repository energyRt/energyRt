
.new_object <- function(class_name, name, ..., exclude = NULL, exclude_class = NULL, 
                          update = !is.character(name)) {
  # !!! newObject
  if(update) {
    if (attr(class(name),"package") != "energyRt") stop("Unknown type of the object")
    if (class(name) != class_name) stop("name should be a character of class ", class_name)
    obj <- name
    name <- obj@name
  } else {
    stopifnot(is.character(class_name))
    obj <- new(class_name)
  }
  slt <- getSlots(class_name)
  arg <- list(...)
  if (!is.null(exclude)) arg <- arg[!(names(arg) %in% exclude)]
  if (!is.null(exclude_class)) arg <- arg[!(sapply(arg, class) %in% exclude_class)]
  if (class_name != 'sysInfo') obj@name <- name
  if (length(arg) != 0) {
    if (any(names(arg) == 'name')) stop('Duplicated parameter "name"')
    if (is.null(names(arg)) || any(names(arg) == '') ||
       anyDuplicated(names(arg)) != 0) stop('Duplicated parameters')
    #if (any(sapply(arg, is.null))) stop('There is NULL argument')
    arg <- arg[!sapply(arg, is.null)]
    if (any(!(names(arg) %in% names(slt)))) stop('Unknown slot name: "', 
       paste(names(arg)[!(names(arg) %in% names(slt))], collapse = '", "'), '"')
    # Add aditional argument
    for(w in names(arg)) {
      ww <- arg[[w]]
      # List argument
      if (slt[w] == 'list') {
        slot(obj, w) <- ww
        # data.frame argument
      } else if (slt[w] == 'data.frame') {
        if (is.data.frame(ww)) {
          # Check: There is no additional column
          if (any(!(colnames(ww) %in% colnames(slot(obj, w))))) {
            stop(paste('Unknown column "', w, '"in the slot: "', 
               paste(colnames(ww)[!(colnames(ww) %in% colnames(slot(obj, w)))], 
                 collapse = '", "'), '"\n', sep = ''))
          }
          slot(obj, w) <- slot(obj, w)[0,, drop = FALSE]
          if (nrow(ww) != 0) {
            nn <- 1:nrow(ww)
            slot(obj, w)[nn, ] <- NA
            for(i in names(ww)) {
              if (is.factor(slot(obj, w)[, i, drop = FALSE]) || is.factor(ww[, i])) {
                slot(obj, w)[nn, i] <- as.character(ww[, i])
              } else {
                slot(obj, w)[nn, i] <- ww[, i]
              }
            }
          }
        } else if (is.list(ww)) {
         gg <- sapply(ww, length)
          slot(obj, w) <- slot(obj, w)[0,, drop = FALSE]
          # Check: Equal length
          if (any(gg[1] != gg)) stop('Check argument ', w)
          # Check: All column has correct name
          if (is.null(names(ww)) || any(names(ww) == '') ||
             anyDuplicated(names(ww)) != 0) stop('Duplicated parameter ', w)
          # Check: There is no additional column
          if (any(!(names(ww) %in% colnames(slot(obj, w))))) stop('Check argument ', w)
          if (gg[1] != 0) {
             nn <- 1:gg[1]
             slot(obj, w)[nn, ] <- NA
             for(i in names(ww)) {
              slot(obj, w)[nn, i] <- ww[[i]]
            }
          }
        } else if (any(colnames(slot(obj, w)) == w) && length(ww) == 1) { 
        # for use start = 2000 rather than start = list(start = 2000)
             slot(obj, w)[1, ] <- NA
             slot(obj, w)[1, w] <- ww
        } else stop('Check argument ', w)
      # Other argument
      } else if (slt[w] == 'factor') {
        slot(obj, w) <- slot(obj, w)[0]
        if (length(ww) != 0) slot(obj, w)[seq(along = ww)] <- ww
      } else if (slt[w] == 'character') {
        slot(obj, w) <- as.character(ww)
      } else {
        slot(obj, w) <- ww
      } 
    }
  }
  obj
}

#.new_object('technology')
#print(newTechnology('technology', 'd3', description = 'jk', cap2act = 4, 
#  units = data.frame(capacity = 'MV', fixom = 'j', stringsAsFactors = FALSE)))

setGeneric("newTechnology", function(name, ...) standardGeneric("newTechnology"))
#' Create new technology object
#' 
#' @name newTechnology
#' 
setMethod('newTechnology', signature(name = 'character'), function(name, ...) 
  .new_object('technology', name, ...))

# setGeneric("update", function(obj, ...) standardGeneric("update"))
#' Update an object
#'
# setMethod('update', signature(obj = 'technology'), function(obj, ...) 
update.technology <- function(obj, ...) .new_object('technology', name = obj, ...)

setGeneric("newCommodity", function(name, ...) standardGeneric("newCommodity"))
#' Create new commodity object
#' 
#' @name newCommodity
#' 
setMethod('newCommodity', signature(name = 'character'), function(name, ...) 
  .new_object('commodity', name, ...))

# setMethod('update', signature(obj = 'commodity'), function(obj, ...) 
update.commodity <- function(obj, ...) .new_object('commodity', name = obj, ...)

setGeneric("newDemand", function(name, ...) standardGeneric("newDemand"))
#' Create new demand object
#' 
#' @name newDemand
#' 
setMethod('newDemand', signature(name = 'character'), function(name, ...) 
  .new_object('demand', name, ...))

# setMethod('update', signature(obj = 'demand'), function(obj, ...) 
update.demand <- function(obj, ...) 
  .new_object('demand', name = obj, ...)

setGeneric("newSupply", function(name, ...) standardGeneric("newSupply"))
#' Create new supply object
#' 
#' @name newSupply
#' 
setMethod('newSupply', signature(name = 'character'), function(name, ...) 
  .new_object('supply', name, ...))

# setMethod('update', signature(obj = 'supply'), function(obj, ...) 
update.supply <- function(obj, ...) 
    .new_object('supply', name = obj, ...)

setGeneric("newExport", function(name, ...) standardGeneric("newExport"))
#' Create new export object
#' 
#' @name newExport
#' 
setMethod('newExport', signature(name = 'character'), function(name, ...) 
  .new_object('export', name, ...))

# setMethod('update', signature(obj = 'export'), function(obj, ...) 
update.export <- function(obj, ...) 
  .new_object('export', name = obj, ...)

setGeneric("newImport", function(name, ...) standardGeneric("newImport"))
#' Create new import object
#' 
#' @name newImport
#' 
setMethod('newImport', signature(name = 'character'), function(name, ...) 
  .new_object('import', name, ...))

# setMethod('update', signature(obj = 'import'), function(obj, ...) 
update.import <- function(obj, ...) 
  .new_object('import', name = obj, ...)

setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#' Create new repository object
#' 
#' @name newRepository
#' 
setMethod('newRepository', signature(name = 'character'), function(name, ...) {
	in_rep <- c('commodity', 'technology', 'supply', 'demand', 'trade', 'import', 'export', 'trade', 'storage')
  rps <- .new_object('repository', name, exclude_class = in_rep, ...)
  arg <- list(...)
  arg <- arg[sapply(arg, class) %in% in_rep]
  if (length(arg) > 0) rps <- add(rps, arg)
  rps
})

setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' Create new model object
#' 
#' @name newModel
#' 

setMethod('newModel', signature(name = 'character'), function(name, ...) {
    sysInfVec <- names(getSlots('sysInfo'))
    sysInfVec <- sysInfVec[sysInfVec != ".S3Class"]        
#    mlst_vec <- c('start', 'interval')
    args <- list(...)
    mdl <- .new_object('model', name, exclude = c(sysInfVec), exclude_class = 'repository', ...)
#    mdl <- .new_object('model', name, exclude = c(mlst_vec, sysInfVec), exclude_class = 'repository', ...)
    if (any(sapply(args, class) == 'repository'))  {
      fl <- seq(along = args)[sapply(args, class) == 'repository']
      for(j in fl) mdl <- add(mdl, args[[j]])
    }
    sysInfVec <- sysInfVec[sysInfVec %in% names(args)]
    mdl@sysInfo <- .new_object('sysInfo', '', exclude_class = 'repository',
#      exclude = c(names(args)[!(names(args) %in% sysInfVec)], mlst_vec), ...)
      exclude = c('slice', names(args)[!(names(args) %in% sysInfVec)]), ...)
    if (any(names(args) == 'slice')) {
      mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = args$slice)
    } else mdl@sysInfo <- setTimeSlices(mdl@sysInfo, slice = 'ANNUAL')
#    args <- list(...)
#    if (any(names(args) %in% mlst_vec)) {
#      if (sum(names(args) %in% mlst_vec) != 2) stop('Undefined all need parameters for setMileStoneYears')
#      mdl <- setMileStoneYears(mdl, start = args$start, interval = args$interval)
#    }
    mdl
  })

#' Create new model object
#' 
#' @name newModel
#' 

setGeneric("newTrade", function(name, ...) standardGeneric("newTrade"))
setMethod('newTrade', signature(name = 'character'), function(name, ..., source = NULL, destination = NULL, avaUpDef = Inf) {
  trd <-  .new_object('trade', name, ...)
	if (avaUpDef != Inf) {
		trd@trade[nrow(trd@trade) + 1, ] <- NA
		trd@trade[nrow(trd@trade), 'ava.up'] <- avaUpDef
	}
  if (is.null(source) != is.null(destination))
    stop('Inconsistency of source/destination data "', trd@name, '"')
  if (!is.null(source) && !is.null(list(...)$routes))
    stop('Inconsistency of source/destination with routes data "', trd@name, '"')
  if (!is.null(source)) {
    trd@routes <- merge(data.frame(src = source, stringsAsFactors = FALSE), 
                        data.frame(dst = destination, stringsAsFactors = FALSE))
    trd@routes <- trd@routes[trd@routes$src != trd@routes$dst,, drop = FALSE]
  }
  trd
})
  

setGeneric("newStorage", function(name, ...) standardGeneric("newStorage"))
#' Create new import object
#' 
#' @name newStorage
#' 
setMethod('newStorage', signature(name = 'character'), function(name, ...) 
  .new_object('storage', name, ...))

# setMethod('update', signature(obj = 'storage'), function(obj, ...) 
update.storage <- function(obj, ...) 
  .new_object('storage', name = obj, ...)

  
setGeneric("newWeather", function(name, ...) standardGeneric("newWeather"))
#' Create new weather object
#' 
#' @name newWeather
#' 
setMethod('newWeather', signature(name = 'character'), function(name, ...) 
  .new_object('weather', name, ...))

# setMethod('update', signature(obj = 'weather'), function(obj, ...) 
update.weather <- function(obj, ...) 
  .new_object('weather', name = obj, ...)

setGeneric("newTax", function(name, ...) standardGeneric("newTax"))
setMethod('newTax', signature(name = 'character'), function(name, ..., value = NULL) {
  if (is.numeric(value)) {
    defVal <- value
    value <- NULL
  } else defVal <- NULL
  tt <- .new_object('tax', name, ..., defVal = defVal)
  if (!is.null(value)) {
  	if (!is.data.frame(value) && is.list(value)) 
  		value <- as.data.frame(value)
  	for (i in c('region', 'year', 'slice')) 
  		if (all(colnames(value) != i))
  			value[, i] <- rep(NA, nrow(value))
  	value <- value[, c('region', 'year', 'slice', 'value')]
  	tt@value <- value
  }
  tt	
})
setGeneric("newSub", function(name, ...) standardGeneric("newSub"))

setMethod('newSub', signature(name = 'character'), function(name, ..., value = NULL) {
  if (is.numeric(value)) {
    defVal <- value
    value <- NULL
  } else defVal <- NULL
  .new_object('sub', name, ..., value = value, defVal = defVal)
})
