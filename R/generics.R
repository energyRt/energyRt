# S3 methods from R base (and to avoid conflicts with other libraries)
# write <- function(x, ...) UseMethod("write") # conflicts with base::write

# S4 methods from R base (and to avoid conflicts with other libraries)
setGeneric("add", function(obj, ...) UseMethod("add"))
setGeneric("convert", function(x, ...) UseMethod("convert"))
setGeneric("draw", function(...) UseMethod("draw"))
# setGeneric("write.sc", function(x, ...) UseMethod("write.sc")) # use function instead
setGeneric("read", function(...) UseMethod("read")) #
setGeneric("interpolate", function(object, ...) UseMethod("interpolate"))

# energyRt methods (exported)
setGeneric("setHorizon", function(obj, ...) standardGeneric("setHorizon"))
setGeneric("getHorizon", function(obj) standardGeneric("getHorizon"))
setGeneric("setCalendar", function(obj, ...) standardGeneric("setCalendar"))
setGeneric("getCalendar", function(obj) standardGeneric("getCalendar"))


# energyRt internal methods
setGeneric(".add2set", function(obj, app, approxim) standardGeneric(".add2set"))
setGeneric('.dat2par', function(obj, data) standardGeneric(".dat2par"))
setGeneric(".obj2modInp", function(obj, app, approxim) standardGeneric(".obj2modInp"))

