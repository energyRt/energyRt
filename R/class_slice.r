#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels         = "data.frame"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE)
      )),                           
      S3methods = TRUE
)
             
