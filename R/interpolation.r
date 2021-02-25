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
  there.are.year <- any(colnames(obj) == 'year')
  if (there.are.year && any(names(arg) == 'year_range') && 
      all(names(approxim) != 'year')) approxim$year <- arg$year_range
  prior <- prior[prior %in% names(approxim)]
  prior <- prior[prior %in% colnames(obj)[-ncol(obj)]]
  true_prior <- true_prior[true_prior %in% prior]
  approxim <- approxim[names(approxim) %in% prior]
  # Remove excess column
  obj <- obj[,colnames(obj) %in% c(prior, parameter), with = FALSE]
  # Sort column
  obj <- obj[,c(prior[prior %in% colnames(obj)], 
    colnames(obj)[ncol(obj)]), with = FALSE]
  obj <- obj[!is.na(obj[[parameter]]),]
  if (anyDuplicated(obj[, -ncol(obj)])) {
    jjj <- sys.status()
    kkk <- sapply(jjj$sys.calls, function(x) any(grep('.add0', x[1])))
    if (sum(kkk) == 0) {
      warning("Duplicated values found and dropped. Use findDuplicates() function for the identification.")
    } else {
      tst_env <- jjj$sys.frames[[max(seq_along(kkk)[kkk])]]
      tst_exm <- get('app', tst_env)
      warning(paste0('"Duplicated values found (class "', class(tst_exm), '", name "', tst_exm@name, 
                     '", parameter: "', parameter, '") and dropped.'))
    }
    obj <- obj[!duplicated(obj[, -ncol(obj)], fromLast = TRUE), ]
  }
  if (nrow(obj) == 0 && (is.null(arg$all) || !arg$all)) return(NULL)
  if (ncol(obj) == 1) {
    if (nrow(obj) == 0) obj[1, 1] <- defVal
    return(obj)
  }
  # Check do need realy approximation 
  approxim2 <- approxim
  if (!is.null(obj$year)) {
    approxim2$year <- arg$approxim$mileStoneYears
    if (is.null(approxim2$year))
      approxim2$year <- arg$approxim$year
  }
  tmp_nona <- (!is.na(obj[, -ncol(obj)]))
  if (all(tmp_nona)) { # There is not NA column
    possible_comb <- prod(sapply(approxim2, length))
    if (nrow(obj) >= possible_comb) {
     obj3 <- obj
     for (i in names(approxim2))
        obj3 <- obj3[obj3[[i]] %in% approxim2[[i]],]
      if (nrow(obj3) == possible_comb)
        return(obj3)
    }
  } else { # There are only NA and not NA column
    f1 <- apply(tmp_nona, 2, any)
    f2 <- apply(tmp_nona, 2, all)
    if (all(f1 == f2)) { # Could be small appr
      obj2 <- obj[, c(f1, TRUE), drop = FALSE]
      for (i in colnames(obj2)[-ncol(obj2)])
        obj2 <- obj2[obj2[[i]] %in% approxim2[[i]],]
      if (ncol(obj2) == 1 || nrow(obj2) == prod(sapply(approxim2[names(obj2)[-ncol(obj2)]], length))) { # Simple approximation is possible
        for (i in names(obj)[c(!f1, FALSE)]) {
          obj2 <- merge(obj2, approxim2[i])
        }
        return(obj2[[colnames(obj)]])
      }
    }
  }
  # Real interpolation
  if (there.are.year) {
    year_range <- arg$year_range
    yy <- range(c(year_range[1], year_range[2], 
      obj$year), na.rm = TRUE) 
    approxim$year <- yy[1]:yy[2]
    apr <- approxim[c('year', true_prior[true_prior != 'year'])]
    if (any(sapply(apr, length) == 0)) return(NULL)
    dd <- as.data.table(as.data.frame.table(array(numeric(), dim = sapply(apr, length), 
      dimnames = apr), stringsAsFactors = FALSE, responseName = parameter))
    dd <- dd[, c(prior, parameter), with = FALSE]
  } else {
    dd <- as.data.table(as.data.frame.table(array(numeric(), dim = sapply(approxim, length), 
      dimnames = approxim), stringsAsFactors = FALSE, responseName = parameter))
  }
  if (nrow(obj) != 0) {
      ii <- 2 ^ (seq(length.out = ncol(obj) - 1) - 1)
      KK <- colSums(ii * t(is.na(obj[, true_prior[true_prior %in% prior], with = FALSE])))
      dobj <- as.matrix(obj[, -ncol(obj)])
      ddd <- t(as.matrix(dd[, -ncol(dd)]))
      dff <- dd[, -ncol(dd)]
      obj <- obj[, c(colnames(dff), parameter), with = FALSE]
      for(i in 1:ncol(dff)) dff[[i]] <- as.factor(as.character(dff[[i]]))
      for(i in 1:ncol(dff)) obj[[i]] <- factor(as.character(obj[[i]]), levels = levels(dff[[i]]))
      for(i in 1:ncol(dff)) obj[[i]] <- as.numeric(obj[[i]])
      for(i in 1:ncol(dff)) dff[[i]] <- as.numeric(dff[[i]])
      hh <- sapply(dff, max)
      hh <- c(1, cumprod(hh[-length(hh)]))
      dff <- as.matrix(dff)
      obj <- as.matrix(obj)
      for (i in 1:ncol(dff)) {
        dff[[i]] <- hh[i] * (dff[[i]] - 1)
        obj[[i]] <- hh[i] * (obj[[i]] - 1)
      }
      # check all(sort(rowSums(dff)) == 0:max(rowSums(dff)))
      for(i in rev(sort(unique(KK)))) {
        fl <- seq(along = KK)[KK == i]
        #dff <- dd[fl, -ncol(dd), drop = FALSE]
        zz <- !is.na(obj[fl[1], -ncol(obj)])
        # gg <- rowSums(obj[fl, -ncol(obj), drop = FALSE])
        r1 <- rowSums(dff[, zz, with = FALSE])
        r2 <- rowSums(obj[fl, c(zz, FALSE), with = FALSE])
        ll <- obj[[ncol(obj)]][fl]
        names(ll) <- r2
        nn <- (r1 %in% r2)
        dd[[ncol(dd)]][nn] <- ll[as.character(r1[nn])]
      }
  } 
  # Interpolation
  if (!there.are.year) {
    dd[is.na(dd[[parameter]]), parameter] <- defVal
  } else {
    if (all(is.na(dd[[parameter]]))) {
      dd[is.na(dd[[parameter]]), parameter] <- defVal
    } else if (any(is.na(dd[, parameter]))) {
      zz <- matrix(dd[[parameter]], length(approxim$year))
      f1 <- apply(!is.na(zz), 2, all)
      if (any(!f1)) {
        gg <- seq(along = f1)[!f1][apply(is.na(zz[, !f1, drop = FALSE]), 2, all)]
        zz[, gg] <- defVal
        f1[gg] <- TRUE
      }
      if (any(!f1)) {
        nr <- nrow(zz)   
        back <- any(grep('back', rule))
        forth <- any(grep('forth', rule))
        inter <- any(grep('inter', rule))
        ## Group by similiarity
        for (ee in seq(along = f1)[!f1]) {
          ll <- ee
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
      dd <- dd[, c(true_prior, parameter), with = FALSE]
    }
    if (length(approxim$year) != year_range[2] - year_range[1] + 1) {
      dd <- dd[rep(year_range[1] <= approxim$year & approxim$year <= year_range[2], 
        nrow(dd) / length(approxim$year)),]
    }
  }
  return(dd)
}


# setMethod(".interpolation", signature(obj = 'data.table', parameter = 'character',
#   defVal = 'numeric'), 
.interpolation <- function(obj, parameter, defVal, ...) {
    arg <- list(...)
    tryCatch({
      .interpolation0(obj, parameter, defVal, arg)
    }, error = function(cond) {
      assign('interpolation_message', list(tracedata = sys.calls(), 
        interpolation0_arg = list(obj = obj, parameter = parameter, defVal = defVal, arg = arg)), globalenv())
      message('\nInterpolation error, more information in "interpolation_message" object\n')
      stop(cond)
    })
}

# 


# setMethod(".interpolation_bound", signature(obj = 'data.table', 
#   parameter = 'character', defVal = 'numeric', rule = 'character'), 
.interpolation_bound <-  function(obj, parameter, defVal, rule, ...) {
  gg <- paste(parameter, c('.lo', '.fx', '.up'), sep = '')
  aa <- obj[, !(colnames(obj) %in% gg), with = FALSE]; 
  aa[, parameter, with = FALSE] <- rep(NA, nrow(aa))
  a1 <- aa; a1[, parameter, with = FALSE] <- obj[, gg[1], with = FALSE]
  a2 <- aa; a2[, parameter, with = FALSE] <- obj[, gg[2], with = FALSE]
  a3 <- aa; a3[, parameter, with = FALSE] <- obj[, gg[3], with = FALSE]
  d1 <- .interpolation(rbind(a1, a2), parameter, 
      defVal = defVal[1], rule = rule[1], ...)
  if (!is.null(d1)) {
    dd <- d1[, -ncol(d1), with = FALSE]
    dd[, 'type', with = FALSE] <- 'lo'
    dd[, parameter, with = FALSE] <- d1[, parameter, with = FALSE]
    }
  d2 <- .interpolation(rbind(a3, a2), parameter, 
    defVal = defVal[2], rule = rule[2], ...)
  if (!is.null(d2)) {
    zz <- d2[, -ncol(d2), with = FALSE]
    zz[, 'type', with = FALSE] <- 'up'
    zz[, parameter, with = FALSE] <- d2[, parameter, with = FALSE]
  }
  if (!is.null(d1) && !is.null(d2)) {
    return(rbind(dd, zz))
  } else if (!is.null(d1)) {
    return(dd)
  } else if (!is.null(d2)) {
    return(zz)
  } else return(NULL)
}

