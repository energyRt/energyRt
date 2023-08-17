#---------------------------------------------------------------------------------------------------------
# Repository : technology
#---------------------------------------------------------------------------------------------------------
setClass("repository",
      representation(
          name          = "character",
          description   = "character",       # Details
          data          = "list",
          # GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          misc = "list"
      ),
      prototype(
          name          = "default_repository",
          description   = "",       # Details
          data          = list(),
      # GIS           = NULL,
      #! Misc
      misc = list()),
      S3methods = TRUE
);
setMethod("initialize", "repository", function(.Object, ...) {
  .Object
})
                                              

#' @export
setMethod("[[", c("repository", "ANY"),
          function(x, name) x@data[[name]])
setMethod("$", "repository", function(x, name) x@data[[name]])

setReplaceMethod("$", c("repository", "ANY"),
                 function(x, name, value) {
                   nm <- names(x@data)
                   ii <- which(nm == value@name)
                   if (length(ii) > 0) {
                     #replace name
                     nm[ii] <- value@name
                     x@data[[name]] = value
                     names(x@data) <- nm
                   } else {
                     x@data[[name]] = value
                   }
                   x
                 }
)

# 
# setReplaceMethod("[[", c("repository", "ANY", "ANY"),
#                  function(x, name, value) {
#                    x@data[[name]] = value 
#                    x 
#                  }
# )

setMethod("names", "repository", function(x) names(x@data))

setMethod("print", "repository", function(x) {
  data.frame(
    name =  sapply(x@data, function(x) x@name),
    class =  sapply(x@data, class)
  )
})

setMethod("show", "repository", function(object) print(object))

setMethod("length", "repository", function(x) length(x@data))

summary.repository <- function(object) {
  x <- sapply(object@data, class) 
  x <- as.factor(x)
  return(summary(x))
}

