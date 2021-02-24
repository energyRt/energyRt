# S3 methods ############################################
add <- function (...) UseMethod("add")
getData <- function (...) UseMethod("getData")
read <- function(...) UseMethod("read")
write <- function(...) UseMethod("write")
# report <- function (...) UseMethod("report")

add_set <- function(x, ...) UseMethod("add_set")
# create_data_frame <- function(x, ...) UseMethod("create_data_frame")
prepare <- function(x, ...) UseMethod("prepare")
#compare <- function (a,b, ...) UseMethod("compare")

# gui <- function (x, ...)  UseMethod("gui")


# S4 methods ############################################
setGeneric("milestoneYears", function(start, interval) standardGeneric("milestoneYears"))
setGeneric("setMilestoneYears", function(obj, start, interval) standardGeneric("setMilestoneYears"))
setGeneric("getMilestone", function(obj) standardGeneric("getMilestone"))
setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))
setGeneric('addMultipleSet', function(obj, dimSetNames) standardGeneric("addMultipleSet"))
setGeneric('levcost', function(obj, ...) standardGeneric("levcost"))

# Internal S4 methods ####
setGeneric('.add_data', function(obj, data) standardGeneric(".add_data"))
setGeneric(".add0", function(obj, app, approxim) standardGeneric(".add0"))
setGeneric(".add_set_element", function(obj, app, approxim) standardGeneric(".add_set_element"))
# setGeneric('.interpolation', function(obj, parameter, defVal, ...) standardGeneric("interpolation"))
