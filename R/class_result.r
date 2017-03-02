#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("result",
      representation(
          data          = "list",
          set           = "list",      
          solution_report      = "list",
          misc = "list"
      ),
      prototype(
          data          = list(),
          set           = list(),      
          solution_report  = list(),
        #! Misc
        misc = list(
          GUID = "41e5b5f2-4865-4b1b-957a-b32f7896df43"
        )),
      S3methods = TRUE
);


