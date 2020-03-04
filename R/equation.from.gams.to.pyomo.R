
# GAMS constraints to pyomo
# Generate convinient vecrtor .alias_set (from gams to alias) and set_alias

#set_alias <- .set_al0
#names(set_alias) <- .alias_set


## Function 
.get_pyomo_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == '(')
    set_cond <- sub('^[(]', '', sub('[)]$', '', set_cond))
  set_loop <- sub('^[(]', '', sub('[)]$', '', set_loop))
  xx <- .generate_loop_pyomo(set_loop, set_cond)
  rs <- xx$first
  if (!is.null(xx$end) || !is.null(add_cond))
    rs <- paste0(rs, ' ', paste0(xx$end, add_cond, collapse = ' and '))
  rs <- paste0(rs, '')
  rs
}
.set_al <- c("stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
.alias_set <- c("st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
names(.alias_set) <- .set_al
.aliasName <- function(x) {
  if (!all(x %in% .set_al)) {
    cat('Unknown .set_al\n')
    browser()
    stop('Unknown set')
  }
  .alias_set[x]
}

.fremset <-   c("comm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "region", "region")
names(.fremset) <-   c("acomm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")

.removeEndSet <- function(x) {
  .fremset[x]
}
.generate_loop_pyomo <- function(set_num, set_loop) {
  # if (any(grep('mCnsuseElc2018Coa1_3', c(set_loop, set_num)))) browser()
  
  # Consdition split and divet by subset
  while (!is.null(set_loop) && substr(set_loop, 1, 1) == '(' && substr(set_loop, nchar(set_loop), nchar(set_loop)) == ')')
    set_loop <- substr(set_loop, 2, nchar(set_loop) - 1)
  while (!is.null(set_num) && substr(set_num, 1, 1) == '(' && substr(set_num, nchar(set_num), nchar(set_num)) == ')')
    set_num <- substr(set_num, 2, nchar(set_num) - 1)
  cnd <- gsub(' ', '', strsplit(set_loop, 'and ')[[1]])
  cnd_slice <- strsplit(gsub('(.*[(]|[)]| )', '', strsplit(set_loop, 'and ')[[1]]), ',')
  cnd_slice <- lapply(cnd_slice, .aliasName)
  names(cnd_slice) <- gsub('[(].*', '', cnd)
  cnd0 <- gsub('[(].*', '', cnd)
  
  set_num1 <- strsplit(gsub('[[:blank:]]', '', set_num), ',')[[1]]
  set_num2 <- .aliasName(set_num1)
  names(set_num2) <- set_num1
  rs <- paste0('(', paste0(set_num2, collapse =', '), ') in ', 'itertools.product'[length(set_num2) > 1], 
    '(', paste0('', .removeEndSet(names(set_num2)), collapse = '*'), ')')
  if (length(cnd_slice) != 0) {
    fl <- (sapply(cnd_slice, length) == 1)
    if (any(fl)) {
      ff <- c(cnd_slice[fl], recursive = TRUE); ff <- ff[!duplicated(ff)]; names(ff) <- gsub('[.].*', '', names(ff))
      kk <- seq_along(set_num2); names(kk) <- set_num2
      names(set_num2) <- .removeEndSet(names(set_num2))
      names(set_num2)[kk[ff]] <- names(ff)
      rs <- paste0('(', paste0(set_num2, collapse =', '), ') in ', 'itertools.product'[length(set_num2) > 1], 
        '(', paste0('', names(set_num2), collapse = ','), ')')
      cnd_slice <- cnd_slice[!(names(cnd_slice) %in% names(ff))]
      if (length(cnd_slice) != 0) {
        iii <- c(lapply(cnd_slice, paste0, collapse = ', '), recursive = TRUE)
        iii[grep(',', iii)] <- paste0('(', iii[grep(',', iii)], ')')
        rs <- paste0(rs, ' if ', paste0(paste0(iii, ' in ', names(cnd_slice)), collapse = ' and '))
      }
    } else {
      iii <- c(lapply(cnd_slice, paste0, collapse = ', '), recursive = TRUE)
      iii[grep(',', iii)] <- paste0('(', iii[grep(',', iii)], ')')
      rs <- paste0(rs, ' if ', paste0(paste0(iii, ' in ', names(cnd_slice)), collapse = ' and '))  
    }
  }
  list(first = NULL, end = rs)
}

.get_pyomo_loop_fast2 <- function(xxx) {
  if (any(grep('[$]', xxx))) {
    beg <- gsub('[$].*', '', xxx)
    end <- substr(xxx, nchar(beg) + 2, nchar(xxx))
  } else {
    beg <- xxx
    end <- NULL
  }
  .get_pyomo_loop_fast(beg, end)
}

.get.bracket.pyomo <- function(tmp) {
  brk0 <- gsub('[^)(]', '', tmp)
  brk <- cumsum(c('(' = 1, ')' = -1)[strsplit(brk0, '')[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0('^', paste0(paste0('[', names(brk)[1:(k-1)], ']'), rep('[^)(]*', k - 1), collapse = ''), names(brk)[k]), '', tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}

.handle.sum.pyomo <- function(tmp) {
  hh <- .get.bracket.pyomo(tmp)
  a1 <- sub('^[(]', '', sub('[)]$', '', hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ',') {
    a2 <- gsub('^([[:alnum:]]|[+]|[-]|[*]|[$])*', '', a2)
    if (substr(a2, 1, 1) == '(') 
      a2 <- .get.bracket.pyomo(a2)$end
  }
  paste0('(', .eqt.to.pyomo(substr(a2, 2, nchar(a2))), ' for ', .get_pyomo_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ')', 
    .eqt.to.pyomo(hh$end)) 
}
.eqt.to.pyomo <- function(tmp) {
  rs <- ''
  while (nchar(tmp) != 0) {
    tmp <- gsub('^[ ]*', '', tmp) 
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, 'sum', .handle.sum.pyomo(substr(tmp, 4, nchar(tmp))))
      tmp <- ''
    } else if (any(grep('^([.[:digit:]]|[+]|[-]|[ ]|[*])', tmp))) {
      a3 <- gsub('^([.[:digit:]_]|[+]|[-]|[ ]|[*])*', '', tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c('m', 'v', 'p')) {
      a1 <- sub('^[[:alnum:]_]*', '', tmp)
      # if (substr(tmp, 1, 1) == 'p') {
      #   vrb <- paste0('model.', substr(tmp, 1, nchar(tmp) - nchar(a1)))
      #   browser()
      # }
        vrb <- paste0('model.', substr(tmp, 1, nchar(tmp) - nchar(a1)))
      a2 <- .get.bracket.pyomo(a1)
      arg <- paste0('', paste0(.aliasName(strsplit(gsub('[() ]', '', a2$beg), ',')[[1]]), collapse = ', '), '')
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == '$') {
        # There are condition
        arg2 <- arg
        if (any(grep(',', arg2))) arg2 <- paste0('(', arg2, ')')
        rs <- paste0(rs, '(', vrb, '[', arg, '] ', 'if ', arg2, ' in model.', gsub('([$]|[(].*)', '', a2$end), 
                     ' else 0)', .eqt.to.pyomo(gsub('^[^)]*[)]', '', a2$end)))
        tmp <- ''
      } else {
        rs <- paste0(rs, vrb, '[', arg, ']',
                     .eqt.to.pyomo(a2$end))
        tmp <- ''
      }
    } else if (substr(tmp, 1, 1) == '=') {
      rs <- paste0(rs, c('g' = '>=', 'e' = '==', 'l' = '<=')[substr(tmp, 2, 2)])
      tmp <- substr(tmp, 4, nchar(tmp))
    } else if (substr(tmp, 1, 1) == ';') {
      rs <- paste0(rs, ');')
      tmp <- substr(tmp, 2, nchar(tmp))
    } else {
      browser()
    }
  }
  rs
}

# Begin equation declaration
.equation.from.gams.to.pyomo <- function(eqt) {
  declaration <- gsub('[.][.].*', '', eqt)
  rs <- paste0('model.', gsub('[$.(].*', '', eqt), ' = Constraint(')
  
  if (nchar(declaration) != nchar(gsub('[($].*', '', declaration))) {
    rs <- paste0(rs, '', gsub('[(].*', '', gsub('.*[$]', '', declaration)), ', rule = lambda model, ',
                 paste0(.aliasName(strsplit(gsub('(.*[(]|[)]|[[:blank:]]*)', '', declaration), ',')[[1]]), 
                        collapse = ', '), ' : ')
  } else {
    rs <- paste0(rs, 'rule = lambda model : ')
  }
  rs <- paste0(rs, 'model.fornontriv + ', .eqt.to.pyomo(gsub('.*[.][.][ ]*', '', eqt)))
  # Change parameter notation
  spl <- strsplit(rs, 'model[.]p')[[1]]
  if (length(spl) > 1) {
    cnd <- grep('^[[:alnum:]_]*[[]', spl[-1]) + 1
    rst <- sub('[^]]*[]]', '', spl[cnd])
    frs <- substr(spl[cnd], 1, nchar(spl[cnd]) - nchar(rst))
    spl[cnd] <- paste0(gsub('[]]', '))', gsub('[[]', '.get((', frs)), rst)
    rs <- paste0(spl, collapse = 'p')
  }
  spl <- strsplit(rs, 'model[.]m')[[1]]
  if (length(spl) > 1) {
    cnd <- grep('^[[:alnum:]_]*[[]', spl[-1]) + 1
    rst <- sub('[^]]*[]]', '', spl[cnd])
    frs <- substr(spl[cnd], 1, nchar(spl[cnd]) - nchar(rst))
    spl[cnd] <- paste0(gsub('[]]', ')]', gsub('[[]', '[(', frs)), rst)
    rs <- paste0(spl, collapse = 'm')
  }
  rs
}
