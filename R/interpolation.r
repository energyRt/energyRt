.interpolation0 <- function(obj, parameter, defVal, arg) { 
  # obj <- interpolation_message$interpolation0_arg$obj;
  # parameter <- interpolation_message$interpolation0_arg$parameter;
  # defVal <- interpolation_message$interpolation0_arg$defVal;
  # arg <- interpolation_message$interpolation0_arg$arg;
  # Remove not used approxim
  if (length(defVal) != 1) stop('defVal value not define')
  if (arg$approxim$fullsets && defVal != 0 && defVal != Inf) arg$all <- TRUE
  
  # Get slice
  prior <- c('stg', 'trade', 'tech', 'sup', 'group', 'acomm', 'comm', 'commp', 'region', 
    'regionp', 'src', 'dst', 'slice', 'year')
  true_prior <- c('stg', 'trade', 'tech', 'sup', 'group', 'acomm', 'comm', 'commp', 'region', 
    'regionp', 'src', 'dst', 'year', 'slice')
  rule <- arg$rule
  approxim <- arg$approxim
  if (is.null(approxim)) {
    approxim <- list()
    for(i in names(arg)[!(names(arg) %in% c('rule', 'approxim', 'year_range'))])
      approxim[[i]] <- arg[[i]]
  }
  approxim <- approxim[names(approxim) %in% prior]
  if (any(colnames(obj) == 'year') && any(names(arg) == 'year_range') && 
      all(names(approxim) != 'year')) approxim$year <- arg$year_range
  prior <- prior[prior %in% names(approxim)]
  prior <- prior[prior %in% colnames(obj)[-ncol(obj)]]
  true_prior <- true_prior[true_prior %in% prior]
  approxim <- approxim[names(approxim) %in% prior]
  # Remove excess column
  obj <- obj[,colnames(obj) %in% c(prior, parameter), drop = FALSE]
  # Sort column
  obj <- obj[,c(prior[prior %in% colnames(obj)], 
    colnames(obj)[ncol(obj)]), drop = FALSE]
  obj <- obj[!is.na(obj[, parameter]), , drop = FALSE]
  if (anyDuplicated(obj[, -ncol(obj)])) {
     warning("Duplicated values found and dropped. Use findDuplicates() function for the identification.")
    obj <- obj[!duplicated(obj[, -ncol(obj)], fromLast = TRUE), ]
  }
  if (nrow(obj) == 0 && (is.null(arg$all) || !arg$all)) return(NULL)
  # Check do need realy approximation 
  approxim2 <- approxim
  if (!is.null(obj$year)) {
    approxim2$year <- arg$approxim$mileStoneYears
    if (is.null(approxim2$year))
      approxim2$year <- arg$approxim$year
  }
  tmp_nona <- (!is.na(obj[, -ncol(obj), drop = FALSE]))
  if (all(tmp_nona)) { # There is not NA column
    possible_comb <- prod(sapply(approxim2, length))
    if (nrow(obj) >= possible_comb) {
      for (i in names(approxim2))
        obj <- obj[obj[[i]] %in% approxim2[[i]],, drop = FALSE]
      if (nrow(obj) == possible_comb)
        return(obj)
    }
  } else { # There are only NA and not NA column
    f1 <- apply(tmp_nona, 2, any)
    f2 <- apply(tmp_nona, 2, all)
    if (all(f1 == f2)) { # Could be small appr
      obj2 <- obj[, c(f1, TRUE), drop = FALSE]
      for (i in colnames(obj2)[-ncol(obj2)])
        obj2 <- obj2[obj2[[i]] %in% approxim2[[i]],, drop = FALSE]
      if (ncol(obj2) == 1 || nrow(obj2) == prod(sapply(approxim2[names(obj2)[-ncol(obj2)]], length))) { # Simple approximation is possible
        for (i in names(obj)[c(!f1, FALSE)]) {
          obj2 <- merge(obj2, approxim2[i])
        }
        return(obj2[, colnames(obj)])
      }
    }
  }
  
  
  if (any(colnames(obj)[-ncol(obj)] == 'year')) {
    year_range <- arg$year_range
    yy <- range(c(year_range[1], year_range[2], 
      obj$year), na.rm = TRUE) 
    approxim$year <- yy[1]:yy[2]
    apr <- approxim[c('year', true_prior[true_prior != 'year'])]
    if (any(sapply(apr, length) == 0)) return(NULL)
    dd <- as.data.frame.table(array(NA, dim = sapply(apr, length), 
      dimnames = apr), stringsAsFactors = FALSE, responseName = parameter)
    dd <- dd[, c(prior, parameter), drop = FALSE]
  } else {
    dd <- as.data.frame.table(array(NA, dim = sapply(approxim, length), 
      dimnames = approxim), stringsAsFactors = FALSE, responseName = parameter)
  }
  if (nrow(obj) != 0) {  
    ii <- 2 ^ (seq(length.out = ncol(obj) - 1) - 1)
    KK <- colSums(ii * t(is.na(obj[, true_prior[true_prior %in% prior], drop = FALSE])))
    dobj <- as.matrix(obj[, -ncol(obj), drop = FALSE])
    ddd <- t(as.matrix(dd[, -ncol(dd), drop = FALSE]))
    dff <- dd[, -ncol(dd), drop = FALSE]
    for(i in 1:ncol(dff)) dff[, i] <- as.factor(as.character(dff[, i]))
    for(i in 1:ncol(dff)) obj[, i] <- factor(as.character(obj[[i]]), levels = levels(dff[, i]))
    for(i in 1:ncol(dff)) obj[, i] <- as.numeric(obj[[i]])
    for(i in 1:ncol(dff)) dff[, i] <- as.numeric(dff[, i])
    hh <- sapply(dff, max)
    #kk <- t(c(1, cumprod(hh[-length(hh)])) * t(dff))
    hh <- c(1, cumprod(hh[-length(hh)]))
    dff <- as.matrix(dff)
    obj <- as.matrix(obj)
    for(i in 1:ncol(dff)) {
      dff[, i] <- hh[i] * (dff[, i] - 1)
      obj[, i] <- hh[i] * (obj[, i] - 1)
    }
    # check all(sort(rowSums(dff)) == 0:max(rowSums(dff)))
    for(i in rev(sort(unique(KK)))) {
      fl <- seq(along = KK)[KK == i]
      #dff <- dd[fl, -ncol(dd), drop = FALSE]
      zz <- !is.na(obj[fl[1], -ncol(obj)])
      # gg <- rowSums(obj[fl, -ncol(obj), drop = FALSE])
      r1 <- rowSums(dff[, zz, drop = FALSE])
      r2 <- rowSums(obj[fl, c(zz, FALSE), drop = FALSE])
      ll <- obj[fl, ncol(obj)]
      names(ll) <- r2
      nn <- (r1 %in% r2)
      dd[nn, ncol(dd)] <- ll[as.character(r1[nn])]
    }
  }  
  # Interpolation
  if (all(colnames(obj)[-ncol(obj)] != 'year')) {
    dd[is.na(dd[, parameter]), parameter] <- defVal
  } else {
    if (all(is.na(dd[, parameter]))) {
      dd[is.na(dd[, parameter]), parameter] <- defVal
    } else if (any(is.na(dd[, parameter]))) {
      zz <- matrix(dd[, parameter], length(approxim$year))
      f1 <- apply(zz, 2, function(x) all(!is.na(x)))
      if (any(!f1)) {
        gg <- seq(along =f1)[!f1][apply(is.na(zz[, !f1, drop = FALSE]), 2, all)]
        zz[, gg] <- defVal
        f1[gg] <- TRUE
      }
      if (any(!f1)) {
        FF <- is.na(zz)
        nr <- nrow(zz)   
        back <- any(grep('back', rule))
        forth <- any(grep('forth', rule))
        inter <- any(grep('inter', rule))
        while(any(!f1)) {
          ee <- seq(along = f1)[!f1]
          if (length(ee) == 1) ll <- ee else {
            ll <- ee[apply(is.na(zz[, ee[1]]) == is.na(zz[, ee]) & 
                (is.na(zz[, ee[1]]) | zz[, ee[1]] == zz[, ee]), 2, all)]
          }
          # Approximate
          hh <- zz[, ee[1]]
          # Back
          if (is.na(hh[1])) {  
            hm <- (1:nr)[!is.na(hh)][1]   
            if (back) hh[1:(hm - 1)] <- hh[hm] else hh[1:(hm - 1)] <- defVal
          }
          # Forth
          if (is.na(hh[nr])) {
            hm <- max((1:nr)[!is.na(hh)])  
            if (forth) hh[(hm + 1):nr] <- hh[hm] else hh[(hm + 1):nr] <- defVal
          }
          # Inter
          if (any(is.na(hh))) {
            if (!inter) hh[is.na(hh)] <- defVal else {
              hm <- is.na(hh)
              bg <- (1:(nr - 1))[hm[-1] & !hm[-nr]]
              en <- (2:nr)[!hm[-1] & hm[-nr]]
              for(i in seq(along = bg)) {
                hh[bg[i]:en[i]] <- seq(hh[bg[i]], hh[en[i]], 
                  length.out = en[i] - bg[i] + 1)
              }
            }
          }
          # Assign
          zz[, ll] <- hh
          f1[ll] <- TRUE
        }
      } 
      dd[, parameter] <- c(zz)  
    }
    if (any(colnames(obj)[-ncol(obj)] == 'slice')) {
      dd <- dd[, c(true_prior, parameter), drop = FALSE]
    }
    if (length(approxim$year) != year_range[2] - year_range[1] + 1) {
      dd <- dd[rep(year_range[1] <= approxim$year & approxim$year <= year_range[2], 
        nrow(dd) / length(approxim$year)), , drop = FALSE]
    }
  }
  return(dd)
}
setMethod("interpolation", signature(obj = 'data.frame', parameter = 'character',
  defVal = 'numeric'), function(obj, parameter, defVal, ...) {
    arg <- list(...)
    tryCatch({
      .interpolation0(obj, parameter, defVal, arg)
    }, error = function(cond) {
      assign('interpolation_message', list(tracedata = sys.calls(), 
        interpolation0_arg = list(obj = obj, parameter = parameter, defVal = defVal, arg = arg)), globalenv())
      message('\nInterpolation error, more information in "interpolation_message" object\n')
      stop(cond)
    })
})

# 


setMethod("interpolation_bound", signature(obj = 'data.frame', 
  parameter = 'character', defVal = 'numeric', rule = 'character'), 
      function(obj, parameter, defVal, rule, ...) {
  gg <- paste(parameter, c('.lo', '.fx', '.up'), sep = '')
  aa <- obj[, !(colnames(obj) %in% gg), drop = FALSE]; aa[, parameter] <- rep(NA, nrow(aa))
  a1 <- aa; a1[, parameter] <- obj[, gg[1]]
  a2 <- aa; a2[, parameter] <- obj[, gg[2]]
  a3 <- aa; a3[, parameter] <- obj[, gg[3]]
  d1 <- interpolation(rbind(a1, a2), parameter, 
      defVal = defVal[1], rule = rule[1], ...)
  if (!is.null(d1)) {
    dd <- d1[, -ncol(d1), drop = FALSE]
    dd[, 'type'] <- 'lo'
    dd[, parameter] <- d1[, parameter]
    }
  d2 <- interpolation(rbind(a3, a2), parameter, 
    defVal = defVal[2], rule = rule[2], ...)
  if (!is.null(d2)) {
    zz <- d2[, -ncol(d2), drop = FALSE]
    zz[, 'type'] <- 'up'
    zz[, parameter] <- d2[, parameter]
  }
  if (!is.null(d1) && !is.null(d2)) {
    return(rbind(dd, zz))
  } else if (!is.null(d1)) {
    return(dd)
  } else if (!is.null(d2)) {
    return(zz)
  } else return(NULL)
})

