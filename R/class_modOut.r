#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("modOut", #        @modOut
      representation(
          sets         = "list", # @sets     
          data          = "list", # Should be remove
          variables     = "list",
          compilationStatus = 'character',
          solutionStatus    = 'character',
          misc = "list"
      ),
      prototype(
          sets          = list(),      
          data          = list(),
          variables     = list(),
          compilationStatus = character(),
          solutionStatus    = character(),
          #! Misc
        misc = list(
        )),
      S3methods = TRUE
)
setMethod("initialize", "modOut", function(.Object, ...) {
  .Object
})
                                              

