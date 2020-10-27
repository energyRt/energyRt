# setGeneric(".find_commodity", function(obj, name) standardGeneric(".find_commodity"))
# setGeneric(".find_storage", function(obj, name) standardGeneric(".find_storage"))
# setGeneric(".find_demand", function(obj, name) standardGeneric(".find_demand"))
# setGeneric(".find_supply", function(obj, name) standardGeneric(".find_supply"))
# setGeneric(".find_export", function(obj, name) standardGeneric(".find_export"))
# setGeneric(".find_import", function(obj, name) standardGeneric(".find_import"))
# setGeneric(".find_technology", function(obj, name) standardGeneric(".find_technology"))
# setGeneric(".find_constraint", function(obj, name) standardGeneric(".find_constraint"))
# setGeneric(".find_trade", function(obj, name) standardGeneric(".find_trade"))


# Internal functions/methods
# setGeneric(".drop_commodity", function(obj, name) standardGeneric(".drop_commodity"))
# setGeneric(".drop_storage", function(obj, name) standardGeneric(".drop_storage"))
# setGeneric(".drop_demand", function(obj, name) standardGeneric(".drop_demand"))
# setGeneric(".drop_supply", function(obj, name) standardGeneric(".drop_supply"))
# setGeneric(".drop_export", function(obj, name) standardGeneric(".drop_export"))
# setGeneric(".drop_import", function(obj, name) standardGeneric(".drop_import"))
# setGeneric(".drop_technology", function(obj, name) standardGeneric(".drop_technology"))
# setGeneric(".drop_sysinfo_param", function(obj) standardGeneric(".drop_sysinfo_param"))
# setGeneric(".drop_trade", function(obj, name) standardGeneric(".drop_trade"))
# setGeneric(".drop_weather", function(obj, name) standardGeneric(".drop_weather"))
# setGeneric(".find_weather", function(obj, name) standardGeneric(".find_weather"))


setGeneric('addData', function(obj, data) standardGeneric("addData"))

# setGeneric('clear', function(obj) standardGeneric("clear")) -> .reset
# setGeneric('getSet', function(obj, dimSetNames) standardGeneric("getSet"))
setGeneric('getParameterData', function(obj, set) standardGeneric("getParameterData"))

# setGeneric('.drop_set_value', function(obj, dimSetNames, value) standardGeneric(".drop_set_value"))
setGeneric('checkDuplicatedRow', function(obj) standardGeneric("checkDuplicatedRow"))
# setGeneric('addSet', function(obj, dimSetNames) standardGeneric("addSet"))
setGeneric('addMultipleSet', function(obj, dimSetNames) standardGeneric("addMultipleSet"))
#setGeneric('solve', function(obj, ...) standardGeneric("solve"))
setGeneric('levcost', function(obj, ...) standardGeneric("levcost"))
# setGeneric('.interpolation', function(obj, parameter, defVal, ...) standardGeneric("interpolation"))
setGeneric(".add0", function(obj, app, approxim) standardGeneric(".add0"))
setGeneric(".add_set_element", function(obj, app, approxim) standardGeneric(".add_set_element"))

#setGeneric("add", function(obj, app, ...) standardGeneric("add"))
#setGeneric("add", function(obj, app) standardGeneric("add"))
#setGeneric("add", function(obj, app, ...) standardGeneric("add"))
# setGeneric('.interpolation_bound', function(obj, parameter, defVal, rule, ...)
  # standardGeneric(".interpolation_bound"))
# setGeneric("addLEC", function(obj, app, price, discount,
#     region, start_year, slice, use_comm, use_out_price)
#         standardGeneric("addLEC"))
#setGeneric("glpkCompile", function(obj) standardGeneric("glpkCompile"))
add <- function (...) UseMethod("add")
# report <- function (...) UseMethod("report")
getData <- function (...) UseMethod("getData")
solve <- function(...) UseMethod("solve")
read <- function(...) UseMethod("read")
write <- function(...) UseMethod("write")

setGeneric("milestoneYears", function(start, interval) standardGeneric("milestoneYears"))
setGeneric("setMilestoneYears", function(obj, start, interval) standardGeneric("setMilestoneYears"))
setGeneric("getMilestone", function(obj) standardGeneric("getMilestone"))
setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))

# setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))

