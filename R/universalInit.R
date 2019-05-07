
universalInit <- function(class_name, name, exclude = NULL, exclude_class = NULL, ...) {
  # !!! newObject
  obj <- new(class_name)
  slt <- getSlots(class_name)
  arg <- list(...)
  if (!is.null(exclude)) arg <- arg[!(names(arg) %in% exclude)]
  if (!is.null(exclude_class)) arg <- arg[!(sapply(arg, class) %in% exclude_class)]
  if (class_name != 'sysInfo') obj@name <- name
  if (length(arg) != 0) {
    if (any(names(arg) == 'name')) stop('Duplicate parameter name')
    if (is.null(names(arg)) || any(names(arg) == '') ||
       anyDuplicated(names(arg)) != 0) stop('Wrong arguments name')
    #if (any(sapply(arg, is.null))) stop('There is NULL argument')
    arg <- arg[!sapply(arg, is.null)]
    if (any(!(names(arg) %in% names(slt)))) stop('There is argument that not consist in class: "', 
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
            stop(paste('Wrong argument "', w, '", undefined  slot: "', 
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
          if (any(gg[1] != gg)) stop('Wrong argument ', w)
          # Check: All column has correct name
          if (is.null(names(ww)) || any(names(ww) == '') ||
             anyDuplicated(names(ww)) != 0) stop('Wrong argument ', w)
          # Check: There is no additional column
          if (any(!(names(ww) %in% colnames(slot(obj, w))))) stop('Wrong argument ', w)
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
        } else stop('Wrong argument ', w)
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

#universalInit('technology')
#print(newTechnology('technology', 'd3', description = 'jk', cap2act = 4, 
#  units = data.frame(capacity = 'MV', fixom = 'j', stringsAsFactors = FALSE)))

setGeneric("newTechnology", function(name, ...) standardGeneric("newTechnology"))
#' Create new technology object
#' 
#' @name newTechnology
#' 
setMethod('newTechnology', signature(name = 'character'), function(name, ...) 
  universalInit('technology', name, ...))

setGeneric("newCommodity", function(name, ...) standardGeneric("newCommodity"))
#' Create new commodity object
#' 
#' @name newCommodity
#' 
setMethod('newCommodity', signature(name = 'character'), function(name, ...) 
  universalInit('commodity', name, ...))

setGeneric("newDemand", function(name, ...) standardGeneric("newDemand"))
#' Create new demand object
#' 
#' @name newDemand
#' 
setMethod('newDemand', signature(name = 'character'), function(name, ...) 
  universalInit('demand', name, ...))

setGeneric("newSupply", function(name, ...) standardGeneric("newSupply"))
#' Create new supply object
#' 
#' @name newSupply
#' 
setMethod('newSupply', signature(name = 'character'), function(name, ...) 
  universalInit('supply', name, ...))

setGeneric("newExport", function(name, ...) standardGeneric("newExport"))
#' Create new export object
#' 
#' @name newExport
#' 
setMethod('newExport', signature(name = 'character'), function(name, ...) 
  universalInit('export', name, ...))

setGeneric("newImport", function(name, ...) standardGeneric("newImport"))
#' Create new import object
#' 
#' @name newImport
#' 
setMethod('newImport', signature(name = 'character'), function(name, ...) 
  universalInit('import', name, ...))


setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' Create new model object
#' 
#' @name newModel
#' 

setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#' Create new repository object
#' 
#' @name newRepository
#' 
setMethod('newRepository', signature(name = 'character'), function(name, ...) 
  universalInit('repository', name, ...))

setGeneric("newModel", function(name, ...) standardGeneric("newModel"))

setMethod('newModel', signature(name = 'character'), function(name, ...) {
    sysInfVec <- names(getSlots('sysInfo'))
    sysInfVec <- sysInfVec[sysInfVec != ".S3Class"]        
#    mlst_vec <- c('start', 'interval')
    args <- list(...)
    mdl <- universalInit('model', name, exclude = c(sysInfVec), exclude_class = 'repository', ...)
#    mdl <- universalInit('model', name, exclude = c(mlst_vec, sysInfVec), exclude_class = 'repository', ...)
    if (any(sapply(args, class) == 'repository'))  {
      fl <- seq(along = args)[sapply(args, class) == 'repository']
      for(j in fl) mdl <- add(mdl, args[[j]])
    }
    sysInfVec <- sysInfVec[sysInfVec %in% names(args)]
    mdl@sysInfo <- universalInit('sysInfo', '', exclude_class = 'repository',
#      exclude = c(names(args)[!(names(args) %in% sysInfVec)], mlst_vec), ...)
      exclude = c('slice', names(args)[!(names(args) %in% sysInfVec)]), ...)
    if (any(names(args) == 'slice')) {
      mdl@sysInfo <- setSlice(mdl@sysInfo, slice = args$slice)
    } else mdl@sysInfo <- setSlice(mdl@sysInfo, slice = 'ANNUAL')
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
setMethod('newTrade', signature(name = 'character'), function(name, ...) 
  universalInit('trade', name, ...))
  

setGeneric("newStorage", function(name, ...) standardGeneric("newStorage"))
#' Create new import object
#' 
#' @name newStorage
#' 
setMethod('newStorage', signature(name = 'character'), function(name, ...) 
  universalInit('storage', name, ...))

  
setGeneric("newWeather", function(name, ...) standardGeneric("newWeather"))
#' Create new weather object
#' 
#' @name newWeather
#' 
setMethod('newWeather', signature(name = 'character'), function(name, ...) 
  universalInit('weather', name, ...))


