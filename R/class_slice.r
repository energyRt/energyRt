#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels         = "data.frame",
          misc           = "list"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE),
        misc = list()
      ),                           
      S3methods = TRUE
);
             
.init_slice <- function(sl) {
  if (nrow(sl@levels) == 0) { 
    warning('There is not slice, add "ANNUAL"')
    sl@levels <- .setSlice(year = 'ANNUAL')
  }
  # Check for correctness of data frame
  .slice_check_data(sl@levels)
  # Fill misc list for compilation 
  
}


sl <- new('slice')
sl <- .init_slice(sl)

