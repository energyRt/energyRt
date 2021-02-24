#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("modOut", #        @modOut
      representation(
          sets         = "list", # @sets     
          data          = "list", # Should be remove
          variables     = "list",
          stage = 'character',
          solutionLogs    = 'data.table',
          misc = "list"
      ),
      prototype(
          sets          = list(),      
          data          = list(),
          variables     = list(),
          stage = character(),
          solutionLogs    = data.table(parameter = character(), value  = character(), time  = character()),
          #! Misc
        misc = list(
        )),
      S3methods = TRUE
)
setMethod("initialize", "modOut", function(.Object, ...) {
  .Object
})
                                              

