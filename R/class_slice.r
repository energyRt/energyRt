#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels         = "data.frame",
          misc           = "list"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE)
        misc = list()
      )),                           
      S3methods = TRUE
)
             
.init_slice <- function(sl) {
  if ()
}