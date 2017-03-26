getInpuData <- function(..., parameter = NULL, name = NULL, object.class = NULL, 
                        slots = NULL, column = NULL, use.dplyr = FALSE, merge = FALSE) {
  # Get condiotion of work
  arg <- list(...)
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
               'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns', 'src', 'dst')
  if (is.null(names(arg))) names(arg) <- rep('', length(arg))
  if (any(names(arg) == 'parameters')) parameter <- arg$parameters
  arg <- arg[!(names(arg) %in% c('parameters'))]
  set <- arg[names(arg) %in% c(psb_set, paste(psb_set, '_', sep = ''))]      
  arg <- arg[!(names(arg) %in% names(set))]
  if (any(names(arg) == 'regex')) {
    regex <- arg$regex
    arg <- arg[names(arg) != 'regex']
    if (any(grep('_$', names(set)))) {
      ff <- grep('_$', names(set), value = TRUE)
      f2 <- gsub('_$', '', ff); names(f2) <- ff
      warning(paste('Duplicated arguments: "', paste(ff, collapse = '", "'), 
                    '", and: "',f2, '"', sep = ''))
      for(i in ff) {
        set[[f2[i]]] <- c(set[[f2[i]]] , set[[i]])
      }
    }
    if (regex) {
      names(set) <- paste(names(set), '_', sep = '')
    }
  } 
  alias_set <- lapply(psb_set, function(x) c(x, paste(x, '_', sep = '')))
  names(alias_set) <- alias_set
  alias_set$comm = c('comm', 'acomm', 'comme', 'commp')
  alias_set$region = c('region', 'regionp', 'src', 'dst')
  if (any(names(set) %in% c('src', 'dst'))) {
    alias_set$region <- c('region', 'regionp')
  } 
  alias_set$year = c('year', 'yearp', 'yeare')
  alias_set <- alias_set[gsub('_$', '', names(set))]  
  # Merge parse objecte
  psb_cls <- c('commodity', 'demand', 'supply', 'export', 'import', 'constrain', 'technology', 'trade')
  obj <- list()
  if (any(sapply(arg, class) == 'list')) {
    j <- seq(along = arg)[sapply(arg, class) == 'list']
    for(k in j)
      for(i in seq(along = arg[[k]]))
        arg[[length(arg) + 1]] <- arg[[k]][[i]]
    arg <- arg[-j]
  }
  for(i in seq(along = arg)) {
    if (class(arg[[i]]) == 'scenario') {
      for(j in seq(along = arg[[i]]@model@data))
        for(k in seq(along = arg[[i]]@model@data[[j]]@data))
          obj[[length(obj) + 1]] <- arg[[i]]@model@data[[j]]@data[[k]]
    } else if (class(arg[[i]]) == 'model') {
      for(j in seq(along = arg[[i]]@data))
        for(k in seq(along = arg[[i]]@data[[j]]@data))
          obj[[length(obj) + 1]] <- arg[[i]]@data[[j]]@data[[k]]
    } else if (class(arg[[i]]) == 'repository') {
      for(j in seq(along = arg[[i]]@data))
          obj[[length(obj) + 1]] <- arg[[i]]@data[[j]]
    } else if (class(arg[[i]]) %in% psb_cls) {
      for(j in seq(along = arg[[i]]))
          obj[[length(obj) + 1]] <- arg[[i]]@data[[k]]
    } else stop('There argument with unknown class: ', class(arg[[i]]))
  }
  if (!is.null(object.class)) obj <- obj[sapply(obj, class) %in% object.class]
  if (!is.null(name))  obj <- obj[sapply(obj, function(x) x@name) %in% name]
  if (anyDuplicated(sapply(obj, function(x) x@name))) {
    ff <- sapply(obj, function(x) x@name); ff <- unique(ff[duplicated(ff)])
    stop(paste('There are objects with duplicated name: "', 
               paste(ff, collapse = '", "'), '"', sep = ''))
  }
  # Prepare paramters list for search
  gh <- new('modInp')@parameters
  gh <- gh[sapply(gh, function(x) !is.null(x@misc$class))]
  psb_set <- data.frame(name = sapply(gh, function(x) x@name), type = sapply(gh, function(x) x@type), 
    class = sapply(gh, function(x) x@misc$class), column = sapply(gh, function(x) gsub('[.].*', '', x@colName[1])), 
    use = rep(TRUE, length(gh)), stringsAsFactors = FALSE)
  psb_set$slot <- NA
  ff <- unique(psb_set$class); 
  cl <- lapply(ff, function(x) new(x)); names(cl) <- ff
  sl <- lapply(ff, function(x) getSlots(x)); names(sl) <- ff
  psb_set <- psb_set[psb_set$type %in% c('simple', 'multi'),, drop = FALSE]
  result <- list()
  for(i in 1:nrow(psb_set)) {
    if (!is.null(gh[[psb_set[i, 'name']]]@misc$slot)) {
      psb_set[i, 'slot'] <- gh[[psb_set[i, 'name']]]@misc$slot 
    } else if (any(psb_set[i, 'column'] == c('tax', 'subs', 'rhs'))) {
      psb_set[i, 'slot'] <- 'rhs'
    } else {
      cc <- psb_set[i, 'class']
      hh <- names(sl[[cc]])[sl[[cc]] == 'data.frame']
      hh <- hh[!(hh %in% c('interpolation', 'defVal', 'units'))]
      if (psb_set[i, 'type'] == 'simple')  mm <- psb_set[i, 'column'] else mm <- paste(psb_set[i, 'column'], '.lo', sep = '')
      psb_set[i, 'slot'] <- hh[sapply(hh, function(x) any(colnames(slot(cl[[cc]], x)) == mm))]
    }
    if (sl[[psb_set[i, 'class']]][psb_set[i, 'slot']] != 'data.frame' && length(set) != 0)
      psb_set[i, 'use'] <- FALSE
    if (psb_set[i, 'use'] && !is.null(slots)) {
      psb_set[i, 'use'] <- slots %in% psb_set[i, 'slot']
    }
    if (psb_set[i, 'use'] && !is.null(column) && psb_set[i, 'type'] == 'simple') {
      psb_set[i, 'use'] <- column %in% psb_set[i, 'column']
    }
    if (psb_set[i, 'use']) {
      if (any(any(psb_set[i, 'column'] == c('tax', 'subs', 'rhs')))) {
        #
      } else if (sl[[psb_set[i, 'class']]][psb_set[i, 'slot']] != 'data.frame') {
        #parameter, object, class, slot, column, (set), 
        rs1 <- sapply(obj[sapply(obj, class) == psb_set[i, 'class']], function(x) slot(x, psb_set[i, 'slot']))
        rs2 <- sapply(obj[sapply(obj, class) == psb_set[i, 'class']], function(x) x@name)
        rs <- data.frame(parameter = rep(psb_set[i, 'name'], length(rs1)), 
                         object = rs2, class = rep(psb_set[i, 'class'], length(rs1)), 
                         slot = rep(psb_set[i, 'slot'], length(rs1)), 
                         column = rep(NA, length(rs1)), value = rs1, stringsAsFactors = FALSE)
        if (nrow(rs) != 0) result[[psb_set[i, 'name']]] <- rs
      } else {
        obj2 <- obj[sapply(obj, class) == psb_set[i, 'class']]
        if (length(obj2) != 0) 
          obj2 <- obj2[sapply(obj2, function(x) nrow(slot(x, psb_set[i, 'slot'])) != 0)]
        rs <- lapply(obj2, function(x) {
          slt <- gh[[psb_set[i, 'name']]]@dimSetNames; 
          if (length(slt) > 1 && slt[1] == substr(slt[2], 1, nchar(slt[2]) - 1)) 
            slt0 <- slt[-2] else slt0 <- slt[-1]
          if (psb_set[i, 'type'] == 'multi') {
            yy <- slot(x, psb_set[i, 'slot'])
            xx <- yy[, slt0]
            xlo <- cbind(rbind(xx, xx), value = c(yy[, paste(psb_set[i, 'column'], '.lo', sep = '')], 
                                                  yy[, paste(psb_set[i, 'column'], '.fx', sep = '')]))
            colnames(xlo) <- slt
            colnames(xlo)[ncol(xlo)] <- 'value'
            xlo <- cbind(parameter = rep(paste(psb_set[i, 'name'], 'Lo', sep = ''), nrow(xlo)), 
                         object = rep(x@name, nrow(xlo)), class = rep(psb_set[i, 'class'], nrow(xlo)), 
                         slot = rep(psb_set[i, 'slot'], nrow(xlo)), 
                         column = rep(psb_set[i, 'column'], nrow(xlo)), 
                         xlo, stringsAsFactors = FALSE)
            xup <- cbind(rbind(xx, xx), value = c(yy[, paste(psb_set[i, 'column'], '.up', sep = '')], 
                                                  yy[, paste(psb_set[i, 'column'], '.fx', sep = '')]))
            colnames(xup) <- slt
            colnames(xup)[ncol(xup)] <- 'value'
            xup <- cbind(parameter = rep(paste(psb_set[i, 'name'], 'Up', sep = ''), nrow(xup)), 
                         object = rep(x@name, nrow(xup)), class = rep(psb_set[i, 'class'], nrow(xup)), 
                         slot = rep(psb_set[i, 'slot'], nrow(xup)), 
                         column = rep(psb_set[i, 'column'], nrow(xup)), 
                         xup, stringsAsFactors = FALSE)
            xx <- rbind(xlo, xup)
            xx <- xx[!is.na(xx$value),, drop = FALSE]
            if (!is.null(column)) xx <- xx[xx$column %in% column,, drop = FALSE]
            if (!is.null(parameter)) xx <- xx[xx$parameter %in% parameter,, drop = FALSE]
            xx
          } else {
            xx <- slot(x, psb_set[i, 'slot'])[, c(slt0, psb_set[i, 'column'])]
            xx <- xx[!is.na(xx[, psb_set[i, 'column']]),, drop = FALSE]
            xx <- cbind(rep(x@name, nrow(xx)), xx, stringsAsFactors = FALSE)
            colnames(xx) <- slt
            colnames(xx)[ncol(xx)] <- 'value'
            xx <- cbind(parameter = rep(psb_set[i, 'name'], nrow(xx)), 
                        object = rep(x@name, nrow(xx)), class = rep(psb_set[i, 'class'], nrow(xx)), 
                        slot = rep(psb_set[i, 'slot'], nrow(xx)), 
                        column = rep(psb_set[i, 'column'], nrow(xx)), 
                        xx, stringsAsFactors = FALSE)
            if (!is.null(parameter)) xx <- xx[xx$parameter %in% parameter,, drop = FALSE]
            xx
          }
        })
        rs <- rs[sapply(rs, nrow) != 0]
        if (length(rs) > 1) {
            res <- rs[[1]][0,, drop = FALSE]
            res[1:sum(sapply(rs, nrow)), ] <- NA
            k <- 0
            for(j in seq(along = rs)) {
              res[k + 1:nrow(rs[[j]]), ] <- rs[[j]]
              k <- k + nrow(rs[[j]])
            }
        } else if (length(rs) == 1) res <- rs[[1]] else res <- NULL
        if (!is.null(res) && length(alias_set) != 0 &&
            !any(sapply(alias_set, function(x) any(colnames(res) %in% x)))) {
          res <- NULL
        }
        if (!is.null(res) && length(alias_set) != 0 && any(!sapply(set, is.null))) {
          for(k in seq(along = set)) if (!is.null(set[[k]]) && nrow(res) != 0) {
            ff <- colnames(res)[colnames(res) %in% alias_set[[gsub('_$', '', names(set)[k])]]]
            fl <- is.na(res[, ff[1]])
            RT <- any(grep('_$', names(set)[k]))
            for(l in ff) {
              fl <-  fl | is.na(res[, l])
              if (RT) {
                for(y in set[[k]]) fl[grep(y, res[, l])] <- TRUE
              } else {
                fl[res[, l] %in% set[[k]]] <- TRUE
              }
            }
            res <- res[fl,, drop = FALSE]
          }
        }
        if (!is.null(res)) result[[psb_set[i, 'name']]] <- res
      }
    }
  }
  if (merge) {
    if (length(result) > 1) {
      if (use.dplyr) {
        result <- Reduce(function(x, y) {dplyr::full_join(x, y)}, result)
      } else {
        result <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, result)
      }
      result <- cbind(result[, colnames(result) != 'value', drop = FALSE], value = result$value, stringsAsFactors = FALSE)
    } else result <- result[[1]]
  }
  psb_set <<- psb_set
  result
}