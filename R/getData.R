getData.scenario <- function(obj, tech = NA, dem = NA, sup = NA,  
     comm = NA, group = NA, region = NA, year = NA, slice = NA, 
     stg = NA, expp = NA, imp = NA, trade = NA, variable = NULL, 
     remove_zero_dim = TRUE, drop = TRUE) {
  if (is.null(tech) || is.null(dem) || is.null(sup) || is.null(comm)
    || is.null(group)|| is.null(region) || is.null(year) || is.null(slice)
    || is.null(stg) || is.null(expp) || is.null(imp) || is.null(trade)) return(NULL);
   #  , type = 'array'
#  act_set <- c('tech', 'dem', 'sup', 'acomm', 'comm', 'group', 
#    'region', 'year', 'slice', 'stg', 'expp', 'imp', 'trade')
  dtt <- obj@result@data
  is.na2 <- function(x) (length(x) == 1 && is.na(x))
  if (!is.null(variable)) {
    if (any(!(variable %in% names(dtt)))) 
      stop(paste('getData: unknown argument: "', paste(variable[!(variable %in% names(dtt))], 
        collapse = '", "'), '"', sep = ''))
    dtt <- dtt[variable]
  }
  set <- list()
  if (!is.na2(tech)) set[['tech']] <- tech;
  if (!is.na2(dem)) set[['dem']] <- dem;
  if (!is.na2(sup)) set[['sup']] <- sup;
  if (!is.na2(comm)) set[['comm']] <- comm;
  if (!is.na2(group)) set[['group']] <- group;
  if (!is.na2(region)) set[['region']] <- region;
  if (!is.na2(year)) set[['year']] <- year;
  if (!is.na2(slice)) set[['slice']] <- slice;
  if (!is.na2(stg)) set[['stg']] <- stg;
  if (!is.na2(expp)) set[['expp']] <- expp;
  if (!is.na2(imp)) set[['imp']] <- imp;
  if (!is.na2(trade)) set[['trade']] <- trade;
  if (length(set) != 0) {
    for(i in names(set)) {
      rmv <- rep(TRUE, length(dtt))
      names(rmv) <- names(dtt)
      for(j in names(dtt)) {
        vv <- grep(paste('^', i, '[[:alpha:]]*', sep = ''), names(dimnames(dtt[[j]])), value = TRUE) 
        if (i == 'comm' && any(names(dimnames(dtt[[j]])) == 'acomm'))  vv <- c(vv, 'acomm')
        if (length(vv) > 0 && 
          any(c(dimnames(dtt[[j]])[vv], recursive = TRUE) %in% set[[i]])) {
          for(k in vv) if (any(dimnames(dtt[[j]])[[k]] %in% set[[i]])) {
            gg <- rep('', length(dim(dtt[[j]])))
            gg[k == names(dimnames(dtt[[j]]))] <- 'dimnames(dtt[[j]])[[k]] %in% set[[i]]'
            ttt <- paste('dtt[[j]] <- dtt[[j]][', paste(gg, collapse = ','), ', drop = ', FALSE, ']', sep = '')
            eval(parse(text = ttt))
            if (length(dtt[[j]]) == 0) rmv[j] <- FALSE
          }
        } else rmv[j] <- FALSE; 
      }
      dtt <- dtt[rmv]  
    }
  }
  if (drop) {
    for(j in names(dtt)) if (length(dim(dtt[[j]])) > 1) {
      ttt <- paste('dtt[[j]] <- dtt[[j]][', paste(rep(',', length.out = length(dim(dtt[[j]])) - 1), 
       collapse = ''), ', drop = ', drop, ']', sep = '')
      eval(parse(text = ttt))
    }
  }
  if (remove_zero_dim) {
    rmv <- rep(TRUE, length(dtt))
    names(rmv) <- names(dtt)
    for(j in names(dtt)) {
      if (class(dtt[[j]]) %in% c('matrix', 'array')) {
        gg <- paste('apply(dtt[[j]] != 0, ', 1:length(dim(dtt[[j]])), ', any)', sep = '')
        ttt <- paste('dtt[[j]] <- dtt[[j]][', paste(gg, collapse = ','), ', drop = ', drop, ']', sep = '')
        eval(parse(text = ttt))
      } else {
        dtt[[j]] <- dtt[[j]][dtt[[j]] != 0]
      }
      if (length(dtt[[j]]) == 0) rmv[j] <- FALSE
    }
    dtt <- dtt[rmv]  
  }
#  if (type == 'data.frame') {
#    dff <- list()
#    for(i in names(dtt)) if (length(dtt[[i]]) != 0) {
#      dff[[i]] <- as.data.frame.table(dtt[[i]], responseName = 'value', stringsAsFactors = FALSE)
#    }
#    if (length(dff) != 0) {
#      nr <- sum(sapply(dff, nrow))
#      ncl <- unique(c(lapply(dff, colnames), recursive = TRUE))
#      dtt <- data.frame(var = character(), stringsAsFactors = FALSE)
#      for(i in ncl[ncl != 'value']) dtt[[i]] <- character()
#      dtt[['value']] <- numeric()
#      dtt[1:nr, ] <- NA
#      k <- 0
#      for(i in names(dff)) {
#        dtt[k + 1:nrow(dff[[i]]), 'var'] <- i
#        dtt[k + 1:nrow(dff[[i]]), colnames(dff[[i]])] <- dff[[i]]
#        k <- k + nrow(dff[[i]])
#      }
#    } else dtt <- data.frame()
#  }
  dtt
}
getDataOut <- function(obj, comm) {
  gg <- getData(obj, comm = comm, variable = c("vTechOut", 'vImport', 'vSupOut'), 
    drop = FALSE, type = 'data.frame')
  gg$var[gg$var == 'vTechOut'] <- 'tech.'
  gg$var[gg$var == 'vSupOut'] <- 'sup.'
  gg$var[gg$var == 'vImport'] <- 'import'
  if (all(colnames(gg) != 'tech')) gg[, 'tech'] <- NA
  if (all(colnames(gg) != 'sup')) gg[, 'sup'] <- NA
  gg$tech[is.na(gg$tech)] <- ''
  gg[['src']] <- paste(gg$var, gg$tech, gg$sup, sep = '')
  tapply(gg$value, gg[, c('year', 'src')], sum)
}

