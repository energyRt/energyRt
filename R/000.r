# Internal functions/methods
setGeneric('.add_data', function(obj, data) standardGeneric(".add_data"))
# setGeneric('clear', function(obj) standardGeneric("clear")) -> .reset
# setGeneric('getSet', function(obj, dimSetNames) standardGeneric("getSet"))
# setGeneric('.get_parameter_data', function(obj, set) standardGeneric(".get_parameter_data"))

# setGeneric('.drop_set_value', function(obj, dimSetNames, value) standardGeneric(".drop_set_value"))
# setGeneric('.check_duplicates_in_parameter', function(obj) standardGeneric(".check_duplicates_in_parameter"))
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

