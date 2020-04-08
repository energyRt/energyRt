
# GAMS constrein to GLPK
# Generate convinient vecrtor .alias_set (from gams to alias) and set_alias

#set_alias <- .set_al0
#names(set_alias) <- .alias_set


## Function 
.get_glpk_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == '(')
    set_cond <- sub('^[(]', '', sub('[)]$', '', set_cond))
  set_loop <- sub('^[(]', '', sub('[)]$', '', set_loop))
  xx <- .generate_loop_glpk(set_loop, set_cond)
  rs <- paste0('{', xx$first)
  if (!is.null(xx$end) || !is.null(add_cond))
    rs <- paste0(rs, ' : ', paste0(xx$end, add_cond, collapse = ' and '))
  rs <- paste0(rs, '}')
  rs
}
.set_al <- c("acomm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
.alias_set <- c("ca", "st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
names(.alias_set) <- .set_al
.aliasName <- function(x) {
  if (!all(x %in% .set_al)) {
    cat('Unknown .set_al\n')
    browser()
    stop('Unknown set')
  }
  .alias_set[x]
}

.generate_loop_glpk <- function(set_num, set_loop) {
  # Consdition split and divet by subset
  while (!is.null(set_loop) && substr(set_loop, 1, 1) == '(' && substr(set_loop, nchar(set_loop), nchar(set_loop)) == ')')
    set_loop <- substr(set_loop, 2, nchar(set_loop) - 1)
  while (!is.null(set_num) && substr(set_num, 1, 1) == '(' && substr(set_num, nchar(set_num), nchar(set_num)) == ')')
    set_num <- substr(set_num, 2, nchar(set_num) - 1)
  cnd <- gsub(' ', '', strsplit(set_loop, 'and ')[[1]])
  cnd_slice <- strsplit(gsub('(.*[(]|[)]| )', '', strsplit(set_loop, 'and ')[[1]]), ',')
  cnd_slice <- lapply(cnd_slice, .aliasName)
  cnd0 <- gsub('[(].*', '', cnd)
  
  to_merge_slice <- sapply(cnd_slice, paste0, collapse = '#')
  rs <- NULL
  for (i in unique(to_merge_slice)) {
    fl <- (to_merge_slice == i)
    fl1 <- seq_along(fl)[fl][1]
    rs <- c(rs, paste0('('[length(cnd_slice[[fl1]]) > 1], paste0(cnd_slice[[fl1]], collapse = ', '), ')'[length(cnd_slice[[fl1]]) > 1], 
                       ' in ', '('[sum(fl) > 1], paste0(cnd0[fl], collapse = ' inter '), ')'[sum(fl) > 1]) )
  }
  # Check if subset on set (glpk is not allowed situation like "(t, g, c) in mTechGroupComm (t, g) in mTechInpGroup", mTechInpGroup - not allowed) 
  
  not_use <- rep(FALSE, length(rs))
  sss <- unique(to_merge_slice)
  for (tt in seq_along(sss)) {
    jj <- strsplit(sss[tt], '#')[[1]]
    if (any(sapply(cnd_slice, function(x) all(jj %in% x) && length(x) > length(jj)))) {
      not_use[tt] <- TRUE
    }
  }
  
  in_slc <- .aliasName(gsub(' ', '', strsplit(set_num, ',')[[1]]))
  not_use[sapply(strsplit(sss, '#'), function(x) length(x) == 1 && all(x != in_slc))] <- TRUE
  
  if (any(not_use)) {
    tend <- paste0(rs[not_use], collapse = ' and ')
  } else tend <- NULL
  rs <- paste0(rs[!not_use], collapse = ', ')
  # Rest slice without mapping
  slice <- gsub(' ', '', strsplit(set_num, ',')[[1]])
  #slice2 <- .aliasName(slice)
  rest_slice <- slice[!(.aliasName(slice) %in% c(cnd_slice, recursive = TRUE))]
  if (length(rest_slice) > 0) {
    if (rs == '') rs <- NULL
    rs <- paste0(c(rs, paste0(.aliasName(rest_slice), ' in ', rest_slice)), collapse = ', ')
  }
  if (any(grep('^[,]', rs)))
    browser()
  list(first = rs, end = tend)
}
.get_glpk_loop_fast2 <- function(xxx) {
  if (any(grep('[$]', xxx))) {
    beg <- gsub('[$].*', '', xxx)
    end <- substr(xxx, nchar(beg) + 2, nchar(xxx))
  } else {
    beg <- xxx
    end <- NULL
  }
  .get_glpk_loop_fast(beg, end)
}

.get.bracket.glpk <- function(tmp) {
  brk0 <- gsub('[^)(]', '', tmp)
  brk <- cumsum(c('(' = 1, ')' = -1)[strsplit(brk0, '')[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0('^', paste0(paste0('[', names(brk)[1:(k-1)], ']'), rep('[^)(]*', k - 1), collapse = ''), names(brk)[k]), '', tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}


# "s.t. eqCnsMINGASgrow2{y in (mMidMilestone inter mMilestoneHasNext)}: sum{y in mMidMilestone, (c, s) in mCommSlice, r in region : c in (mCnsMINGASgrow2_1 inter mCnsMINGASgrow2_1)}(-1 * vOutTot[c, r, y, s]+ sum{(y, yp) in mMilestoneNext, (c, s) in mCommSlice, r in region : c in (mCnsMINGASgrow2_1 inter mCnsMINGASgrow2_1) and yp in mMidMilestone}(pCnsMultMINGASgrow2_2[y]* vOutTot[c, r, yp, s]>=0;"

# tmp = '((comm, region, slice)$(mCnsMINGASgrow2_1(comm) and mMidMilestone(year) and mCommSlice(comm, slice) and mCnsMINGASgrow2_1(comm)), -1 * vOutTot(comm, region, year, slice))'
.handle.sum.glpk <- function(tmp) {
  hh <- .get.bracket.glpk(tmp)
  a1 <- sub('^[(]', '', sub('[)]$', '', hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ',') {
    a2 <- gsub('^([[:alnum:]]|[+]|[-]|[*]|[$])*', '', a2)
    if (substr(a2, 1, 1) == '(') 
      a2 <- .get.bracket.glpk(a2)$end
  }
  paste0(.get_glpk_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), '(', .eqt.to.glpk(substr(a2, 2, nchar(a2))), ')', .eqt.to.glpk(hh$end)) 
}
.eqt.to.glpk <- function(tmp) {
  #ITER = get('ITER', globalenv()) + 1
  #cat(ITER, tmp, '\n')
  #assign('ITER', ITER, globalenv())
  #if (ITER > 20) stop('ITER', ITER)
  rs <- ''
  while (nchar(tmp) != 0) {
    tmp <- gsub('^[ ]*', '', tmp) 
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, 'sum', .handle.sum.glpk(substr(tmp, 4, nchar(tmp))))
      tmp <- ''
    } else if (any(grep('^([.[:digit:]]|[+]|[-]|[ ]|[*])', tmp))) {
      a3 <- gsub('^([.[:digit:]_]|[+]|[-]|[ ]|[*])*', '', tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c('m', 'v', 'p')) {
      a1 <- sub('^[[:alnum:]_]*', '', tmp)
      vrb <- substr(tmp, 1, nchar(tmp) - nchar(a1))
      a2 <- .get.bracket.glpk(a1)
      arg <- paste0(.aliasName(strsplit(gsub('[() ]', '', a2$beg), ',')[[1]]), collapse = ', ')
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == '$') {
        rs <- paste0(rs, 'sum{FORIF: (', arg, ') in ', gsub('([$]|[(].*)', '', a2$end), '} (', vrb, '[', arg, '])',
            .eqt.to.glpk(gsub('^[^)]*[)]', '', a2$end)))
        tmp <- ''
      } else {
        rs <- paste0(rs, vrb, '[', arg, ']', .eqt.to.glpk(a2$end))
        tmp <- ''
      }
    } else if (substr(tmp, 1, 1) == '=') {
      rs <- paste0(rs, c('g' = '>=', 'e' = '=', 'l' = '<=')[substr(tmp, 2, 2)])
      tmp <- substr(tmp, 4, nchar(tmp))
    } else if (substr(tmp, 1, 1) == ';') {
      rs <- paste0(rs, ';')
      tmp <- substr(tmp, 2, nchar(tmp))
    } else {
      browser()
    }
  }
  rs
}

# Begin equation declaration
.equation.from.gams.to.glpk <- function(eqt) {
  declaration <- gsub('[.][.].*', '', eqt)
  rs <- paste0('s.t. ', gsub('[($].*', '', declaration))
  if (nchar(declaration) != nchar(gsub('[($].*', '', declaration))) {
    rs <- paste0(rs, .get_glpk_loop_fast2(gsub('^[[:alnum:]]*', '', declaration)))
  }
  rs <- paste0(rs, ': ', .eqt.to.glpk(gsub('.*[.][.][ ]*', '', eqt)))
  rs
}


