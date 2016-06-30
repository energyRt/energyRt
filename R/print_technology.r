#---------------------------------------------------------------------------------------------------------
#! print.technology < -function(x,...) : print technology
#---------------------------------------------------------------------------------------------------------
print.technology <- function(x,...) {
# print technology
    if_print_data_frame <- function(x, sl) {
      if(nrow(slot(x,sl)) != 0) {
        cat('\n', sl, '\n')
        print(slot(x, sl))
        cat('\n')
      }
    }
    cat('Name: ', x@name, '\n')
    if (x@type!='') cat('type: ', x@type, '\n')
    if (x@description!='') cat('description: ', x@description, '\n')
    if (x@cap2act!='') cat('cap2act: ',x@cap2act, '\n')
    #if (any(x@region!='')) cat('region: ',x@region, '\n')
    #if(!is.null(x@reporting_years)) cat('reporting years: ', x@reporting_years, '\n')
    for(i in technology_data_frame()) if_print_data_frame(x, i)
}