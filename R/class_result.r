#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("modOut", #        @modOut
      representation(
          sets         = "list", # @sets     
          data          = "list", # Should be remove
          variables     = "list",
          compilationStatus = 'characterOrNULL',
          solutionStatus    = 'characterOrNULL',
          misc = "list"
      ),
      prototype(
          sets          = list(),      
          data          = list(),
          variables     = list(),
          compilationStatus = NULL,
          solutionStatus    = NULL,
          #! Misc
        misc = list(
          GUID = "41e5b5f2-4865-4b1b-957a-b32f7896df43"
        )),
      S3methods = TRUE
)


