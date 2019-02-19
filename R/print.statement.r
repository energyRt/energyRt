#---------------------------------------------------------------------------------------------------------
#! print.equation < -function(x) : print equation
#---------------------------------------------------------------------------------------------------------
print.equation <- function(x) {
  # print equation
  if_print_data_frame <- function(x, sl) {
    if(nrow(slot(x,sl)) != 0) {
      cat('\n', sl, '\n')
      print(slot(x, sl))
      cat('\n')
    }
  }
  cat('Name: ', x@name, ', eq: ', as.character(x@eq), ', defVal: ', x@defVal, '\n', sep = '')
  if (x@description != '') cat('description: ', x@description, '\n')
  g <- getClass("equation")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == 
                                "data.frame")]
  for(i in zz) if_print_data_frame(x, i)
  for (i in seq_along(x@lhs)) {
    cat('Term ', i, ':\n', sep = '')
    print(x@lhs[[i]])
  }
}

print.summand <- function(x) {
  # print equation
  if_print_data_frame <- function(x, sl) {
    if(nrow(slot(x,sl)) != 0) {
      cat('\n', sl, '\n')
      print(slot(x, sl))
      cat('\n')
    }
  }
  cat('variable: ', x@variable, ', defVal: ', x@defVal, '\n', sep = '')
  g <- getClass("summand")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == 
                                "data.frame")]
  for(i in zz) if_print_data_frame(x, i)
  if (length(x@for.sum) != 0) {
    cat('for.sum set:\n')
    print(x@for.sum)
  }
}

