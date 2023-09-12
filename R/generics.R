# S3 methods from R base (and to avoid conflicts with other libraries)
summary <- function(...) UseMethod("summary")
solve <- function(...) UseMethod("solve")
# add <- function(...) UseMethod("add")
# convert <- function(x, ...) UseMethod("convert")
# draw <- function(...) UseMethod("draw")

# S4 methods from R base (and to avoid conflicts with other libraries)
setGeneric("add", function(...) UseMethod("add"))
setGeneric("convert", function(x, ...) UseMethod("convert"))
setGeneric("read", function(...) UseMethod("read"))
setGeneric("draw", function(...) UseMethod("draw"))
# setGeneric("update")
# setGeneric("update", function(...) NextMethod("update"))
setGeneric("write", function(obj, ...) UseMethod("write"))
# setGeneric("solve", function(obj, ...) UseMethod("solve"))
# setGeneric("summary", function(...) UseMethod("summary"))

# energyRt methods (exported)
setGeneric("setHorizon", function(obj, horizon, intervals) standardGeneric("setHorizon"))
setGeneric("getHorizon", function(obj) standardGeneric("getHorizon"))


# energyRt internal methods
setGeneric(".add2set", function(obj, app, approxim) standardGeneric(".add2set"))
setGeneric('.dat2par', function(obj, data) standardGeneric(".dat2par"))
setGeneric(".obj2modInp", function(obj, app, approxim) standardGeneric(".obj2modInp"))

