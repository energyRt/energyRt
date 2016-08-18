getData.scenario <- function(obj, tech = NULL, dem = NULL, sup = NULL,  
     comm = NULL, group = NULL, region = NULL, year = NULL, slice = NULL, 
     stg = NULL, expp = NULL, imp = NULL, trade = NULL, variable = NULL, 
     remove_zero_dim = TRUE, drop = TRUE) {
   #  , type = 'array'
#  act_set <- c('tech', 'dem', 'sup', 'acomm', 'comm', 'group', 
#    'region', 'year', 'slice', 'stg', 'expp', 'imp', 'trade')
  dtt <- obj@result@data
  if (!is.null(variable)) {
    if (any(!(variable %in% names(dtt)))) 
      stop(paste('getData: unknown argument: "', paste(variable[!(variable %in% names(dtt))], 
        collapse = '", "'), '"', sep = ''))
    dtt <- dtt[variable]
  }
  set <- list()
  if (!is.null(tech)) set[['tech']] <- tech;
  if (!is.null(dem)) set[['dem']] <- dem;
  if (!is.null(sup)) set[['sup']] <- sup;
  if (!is.null(comm)) set[['comm']] <- comm;
  if (!is.null(group)) set[['group']] <- group;
  if (!is.null(region)) set[['region']] <- region;
  if (!is.null(year)) set[['year']] <- year;
  if (!is.null(slice)) set[['slice']] <- slice;
  if (!is.null(stg)) set[['stg']] <- stg;
  if (!is.null(expp)) set[['expp']] <- expp;
  if (!is.null(imp)) set[['imp']] <- imp;
  if (!is.null(trade)) set[['trade']] <- trade;
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
    for(j in names(dtt)) {
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

