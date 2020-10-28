# Internal functions/methods
setGeneric('.add_data', function(obj, data) standardGeneric(".add_data"))

setGeneric('addMultipleSet', function(obj, dimSetNames) standardGeneric("addMultipleSet"))
#setGeneric('solve', function(obj, ...) standardGeneric("solve"))
setGeneric('levcost', function(obj, ...) standardGeneric("levcost"))
# setGeneric('.interpolation', function(obj, parameter, defVal, ...) standardGeneric("interpolation"))
setGeneric(".add0", function(obj, app, approxim) standardGeneric(".add0"))
setGeneric(".add_set_element", function(obj, app, approxim) standardGeneric(".add_set_element"))

add <- function (...) UseMethod("add")
# report <- function (...) UseMethod("report")
getData <- function (...) UseMethod("getData")
# solve <- function(...) UseMethod("solve")
read <- function(...) UseMethod("read")
# write <- function(...) UseMethod("write")
# write <- function(...) nextMethod("write")



setGeneric("milestoneYears", function(start, interval) standardGeneric("milestoneYears"))
setGeneric("setMilestoneYears", function(obj, start, interval) standardGeneric("setMilestoneYears"))
setGeneric("getMilestone", function(obj) standardGeneric("getMilestone"))
setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))

