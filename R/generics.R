# S3 methods from R base (and to avoid conflicts with other libraries)
# write <- function(x, ...) UseMethod("write")

# S4 methods from R base (and to avoid conflicts with other libraries)
setGeneric("add", function(...) UseMethod("add"))
setGeneric("convert", function(x, ...) UseMethod("convert"))
setGeneric("read", function(...) UseMethod("read"))
setGeneric("draw", function(...) UseMethod("draw"))
setGeneric("write", function(x, ...) UseMethod("write"))

# energyRt methods (exported)
setGeneric("setHorizon", function(obj, horizon, intervals) standardGeneric("setHorizon"))
setGeneric("getHorizon", function(obj) standardGeneric("getHorizon"))


# energyRt internal methods
setGeneric(".add2set", function(obj, app, approxim) standardGeneric(".add2set"))
setGeneric('.dat2par', function(obj, data) standardGeneric(".dat2par"))
setGeneric(".obj2modInp", function(obj, app, approxim) standardGeneric(".obj2modInp"))

