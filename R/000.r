setClassUnion("characterOrNULL", members=c("character", "NULL"))
setGeneric("isCommodity", function(obj, name) standardGeneric("isCommodity"))
setGeneric("removePreviousCommodity", function(obj, name) standardGeneric("removePreviousCommodity"))
setGeneric("isStorage", function(obj, name) standardGeneric("isStorage"))
setGeneric("removePreviousStorage", function(obj, name) standardGeneric("removePreviousStorage"))
setGeneric("removePreviousDemand", function(obj, name) standardGeneric("removePreviousDemand"))
setGeneric("isDemand", function(obj, name) standardGeneric("isDemand"))
setGeneric("removePreviousSupply", function(obj, name) standardGeneric("removePreviousSupply"))
setGeneric("isSupply", function(obj, name) standardGeneric("isSupply"))
setGeneric("removePreviousExport", function(obj, name) standardGeneric("removePreviousExport"))
setGeneric("isExport", function(obj, name) standardGeneric("isExport"))
setGeneric("removePreviousImport", function(obj, name) standardGeneric("removePreviousImport"))
setGeneric("isImport", function(obj, name) standardGeneric("isImport"))
setGeneric("removePreviousTechnology", function(obj, name) standardGeneric("removePreviousTechnology"))
setGeneric("isTechnology", function(obj, name) standardGeneric("isTechnology"))
setGeneric("isConstrain", function(obj, name) standardGeneric("isConstrain"))
setGeneric("removePreviousSysInfo", function(obj) standardGeneric("removePreviousSysInfo"))
setGeneric("removePreviousTrade", function(obj, name) standardGeneric("removePreviousTrade"))
setGeneric("isTrade", function(obj, name) standardGeneric("isTrade"))
setGeneric('addData', function(obj, data) standardGeneric("addData"))

setGeneric('clear', function(obj) standardGeneric("clear"))
setGeneric('getSet', function(obj, dimSetNames) standardGeneric("getSet"))
setGeneric('getParameterData', function(obj, set) standardGeneric("getParameterData"))
setGeneric('removeBySet', function(obj, dimSetNames, value) standardGeneric("removeBySet"))
setGeneric('checkDuplicatedRow', function(obj) standardGeneric("checkDuplicatedRow"))
setGeneric('addSet', function(obj, dimSetNames) standardGeneric("addSet"))
setGeneric('addMultipleSet', function(obj, dimSetNames) standardGeneric("addMultipleSet"))
#setGeneric('solve', function(obj, ...) standardGeneric("solve"))
setGeneric('levcost', function(obj, ...) standardGeneric("levcost"))
setGeneric('interpolation', function(obj, parameter, defVal, ...) standardGeneric("interpolation"))
setGeneric("add0", function(obj, app, approxim) standardGeneric("add0"))
setGeneric("add_name", function(obj, app, approxim) standardGeneric("add_name"))
setGeneric("removePreviousWeather", function(obj, name) standardGeneric("removePreviousWeather"))
setGeneric("isWeather", function(obj, name) standardGeneric("isWeather"))

#setGeneric("add", function(obj, app, ...) standardGeneric("add"))
#setGeneric("add", function(obj, app) standardGeneric("add"))
#setGeneric("add", function(obj, app, ...) standardGeneric("add"))
setGeneric('interpolation_bound', function(obj, parameter, defVal, rule, ...)
  standardGeneric("interpolation_bound"))
setGeneric("addLEC", function(obj, app, price, discount,
    region, start_year, slice, use_comm, use_out_price)
        standardGeneric("addLEC"))
#setGeneric("glpkCompile", function(obj) standardGeneric("glpkCompile"))
add <- function (...) UseMethod("add")
report <- function (...) UseMethod("report")
getData <- function (...) UseMethod("getData")

setGeneric("milestoneYears", function(start, interval) standardGeneric("milestoneYears"))
setGeneric("setMilestoneYears", function(obj, start, interval) standardGeneric("setMilestoneYears"))
setGeneric("getMilestone", function(obj) standardGeneric("getMilestone"))
setGeneric("setSlice", function(obj, ...) standardGeneric("setSlice"))

setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))

