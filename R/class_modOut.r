#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("modOut", #        @modOut
      representation(
          sets         = "list", # @sets     
          data          = "list", # Should be remove
          variables     = "list",
          stage = 'character',
          solutionLogs    = 'data.frame',
          misc = "list"
      ),
      prototype(
          sets          = list(),      
          data          = list(),
          variables     = list(),
          stage = character(),
          solutionLogs    = data.frame(parameter = character(), value  = character(), time  = character()),
          #! Misc
        misc = list(
        )),
      S3methods = TRUE
)
setMethod("initialize", "modOut", function(.Object, ...) {
  .Object
})
                                              

