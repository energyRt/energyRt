#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("result", #        @modOut
      representation(
          set           = "list", # @sets     
          data          = "list", # @variables
          solution_report      = "list", # @compilation_status @solution_status
          misc = "list"
      ),
      prototype(
          set           = list(),      
          data          = list(),
          solution_report  = list(), # 
        #! Misc
        misc = list(
          GUID = "41e5b5f2-4865-4b1b-957a-b32f7896df43"
        )),
      S3methods = TRUE
)


