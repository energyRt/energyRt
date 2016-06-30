#---------------------------------------------------------------------------------------------------------
# result
#---------------------------------------------------------------------------------------------------------
setClass("result",
      representation(
          data          = "list",
          set           = "list",      
          solution_report      = "list"
      ),
      prototype(
          data          = list(),
          set           = list(),      
          solution_report  = list()
      ),
      S3methods = TRUE
);


