[moved to write_pyomo.R]

.generate.pyomo.par <- function(param) {
  decl <- NULL
  # Generate set declaration
  for (tmp in param[sapply(param, function(x) x@type == 'set')]) {
    decl <- c(decl, paste0('model.', tmp@name, ' = Set();'))
  }
  # Generate map declaration
  for (tmp in param[sapply(param, function(x) x@type == 'map')]) {
    decl <- c(decl, paste0('model.', tmp@name, ' = Set(within = ', paste0('model.', energyRt:::.removeEndSet(tmp@dimSets), collapse = '*'),
      ');'))
  }
  value_or_zero <- function(x) {
    if (x == Inf || x == -Inf) return(0)
    return(x)
  }
  # Generate single parameter declaration
  for (tmp in param[sapply(param, function(x) x@type == 'simple')]) {
    decl <- c(decl,
      paste0('model.', tmp@name, ' = Param(', paste0('model.', energyRt:::.removeEndSet(tmp@dimSets), collapse = '*'),
             ', default = ', value_or_zero(tmp@defVal), ');'))
  }
  # Generate multi parameter declaration
  for (tmp in param[sapply(param, function(x) x@type == 'multi')]) {
    decl <- c(decl,
      paste0('model.', tmp@name, 'Lo = Param(', paste0('model.', energyRt:::.removeEndSet(tmp@dimSets), collapse = '*'), ', default = ',
             value_or_zero(tmp@defVal[1]), ');'),
      paste0('model.', tmp@name, 'Up = Param(', paste0('model.', energyRt:::.removeEndSet(tmp@dimSets), collapse = '*'), ', default = ',
             value_or_zero(tmp@defVal[2]), ');'))
  }
  decl <- gsub('[(]model.,', '(', decl)
  decl
}
