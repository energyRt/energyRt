
newConstraintS <- function(name, type, eq = '==', rhs = 0, for.sum = list(), 
                         for.each = list(), defVal = 0, rule = NULL, comm = NULL,
                         cout = TRUE, cinp = TRUE, aout = TRUE, ainp = TRUE, emis = TRUE) {
  stop.newconstr <- function(x) 
    stop(paste0('Constraint "', name, '" error: ', x))
  
  
  if (type == 'tax') stop.newconstr('Tax have to do')
  if (type == 'subs') stop.newconstr('Subs have to do')
  #if (any(grep('(share|growth)', type))) stop.newconstr(paste(type, 'have to do'))
  # For wich kind of variables (capacity, newcapacity, input or output)
  if (any(grep('inp', type))) {
    inpout <- 'Inp'
  } else if (any(grep('out', type))) {
    inpout <- 'Out'
  } else if (type == 'capacity') {
    inpout <- 'Cap'
  } else if (type == 'newcapacity') {
    inpout <- 'NewCap'
  }else if ('balance' == type) {
    inpout <- 'Balance'
  } else {
    stop.newconstr(paste0('Unknown type: ', type))
  }
  #   
  set.vec <- c(names(for.each), names(for.sum))
  psb.vec <- c('sup', 'stg', 'tech', 'imp', 'expp')
  psb.vec.tp <- c(sup = 'Sup', stg = 'Storage', tech = 'Tech', imp = 'Import', expp = 'Export')
  names(psb.vec) <- psb.vec
  is.set <- psb.vec[psb.vec %in% set.vec]
  if (length(is.set) > 1)
      stop.newconstr(paste0('There are more than one subsets'))
  vec.tp <- psb.vec.tp[is.set]
  if (length(is.set) == 0) {
    if (all(inpout != c('Inp', 'Out', 'Balance')))
      stop.newconstr(paste0('For ', type, ' have to define some subsets'))
    vrb <- paste0('v', inpout,'Tot'[inpout != 'Balance'])
  } else {
    if (is.set == 'tech' && inpout == 'Inp') {
      vrb <- paste0('vTech', c('', 'A')[c(cinp, ainp)], 'Inp')
    } else if (is.set == 'tech' && inpout == 'Out') {
      vrb <- paste0('vTech', c('Out', 'AOut', 'EmsFuel')[c(cout, aout, emis)])
    } else if (any(type == c('newcapacity', 'capacity'))) {
      if (all(is.set != c('stg', 'tech')))
        stop.newconstr(paste0('For ', type, ' could be define only for tech and storage'))
      vrb <- paste0('v', vec.tp, c(capacity = 'Cap', newcapacity = 'NewCap')[type])
    } else {
      vrb <- paste0('v', vec.tp, inpout)
    }
  }
  term = list(for.sum = for.sum, variable = vrb[1])
  arg <- list(term)
  for (i in vrb[-1]) {
    term$variable <- i
    arg[[length(arg) + 1]] <- term
  }
  # To share 
  if (any(grep('share', type))) {
    if (length(c(rhs, recursive = TRUE)) == 0) {
      rhs <- defVal
    } else {
      rhs$value <- (rhs$rhs)
      rhs$rhs <- NULL
    }
    for (i in seq_along(arg)) {
      arg[[i]]$mult <- rhs
    }
    term = list(for.sum = for.sum[!(names(for.sum) %in% psb.vec)], variable =paste0('v', inpout,'Tot'), mult = -1)
    rhs <- 0
    defVal <- 0
    arg[[length(arg) + 1]] <- term
  }
  # To growth 
  if (any(grep('growth', type))) {
    if (length(c(rhs, recursive = TRUE)) == 0) {
      rhs <- (1/defVal)
    } else {
      if (is.numeric(rhs)) {
        rhs <- (1/rhs)
      } else {
        rhs$value <- (1/rhs$rhs)
        rhs$rhs <- NULL
      }
    }
    nn <- seq_along(arg)
    nk <- length(arg)
    for (i in nn) {
      arg[[i + nk]] <- arg[[i]]
      arg[[i + nk]]$mult <- rhs
      arg[[i + nk]]$for.sum['lead.year'] <- list(NULL)
      arg[[i + nk]]$for.sum$year <- NULL
      arg[[i]]$mult <- (-1)
    }
    rhs <- 0
    defVal <- 0
  }
  newConstraint(name, eq = eq, for.each = for.each, defVal = defVal, rhs = rhs, arg = arg)
}
 

