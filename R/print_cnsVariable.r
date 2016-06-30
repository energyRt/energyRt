print.cnsVariable <- function(x) {
  cat('Parameter: "', x@parameter, '", default value: "', x@default, '"\n', sep = '')
  if (!is.null(x@value)) {
    cat('Value:\n')
    print(x@value)
  } else cat('Value isn\'t definite\n')
  if (length(x@set) != 0) {
    cat('Internal set:\n')
    for(i in 1:length(x@set)) print(x@set[[i]])
  } else cat('There isn\'t internal set\n')
  if (length(x@ext_set) != 0) {
    cat('External set:\n')
    for(i in 1:length(x@ext_set)) print(x@ext_set[[i]])
  } else cat('There isn\'t exernal set\n')
}
