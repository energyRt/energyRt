[moved to write_jump.R]
# Translate GAMS constraints to Julia/JuMP
# Generate convinient vecrtor .alias_set (from gams to alias) and set_alias

#set_alias <- .set_al0
#names(set_alias) <- .alias_set


## Function
.get_julia_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == '(')
    set_cond <- sub('^[(]', '', sub('[)]$', '', set_cond))
  set_loop <- sub('^[(]', '', sub('[)]$', '', set_loop))
  xx <- .generate_loop_julia(set_loop, set_cond)
  rs <- xx$first
  if (!is.null(xx$end) || !is.null(add_cond))
    rs <- paste0(rs, ' ', paste0(xx$end, add_cond, collapse = ' && '))
  rs <- paste0(rs, '')
  rs
}
# .set_al <- c("stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
# .alias_set <- c("st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
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
.generate_loop_julia <- function(set_num, set_loop) {
  # browser()
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

  if (length(cnd_slice) != 0) {
    fl <- names(cnd_slice)[sapply(cnd_slice, length) == 1]
    if (length(fl) != 0) {
      for (i in fl) {
        names(set_num2)[names(set_num2) == names(cnd_slice[[i]])] <- i
      }
      cnd_slice <- cnd_slice[!(names(cnd_slice) %in% fl)]
    }
    hh <- NULL
    for (i in names(set_num2)) {
      if (i %in% fl) hh <- c(hh, i) else hh <- c(hh, .removeEndSet(i))
    }
    rs <- paste0('for ', set_num2, ' in ', hh, collapse = ' ')
  } else rs <- paste0('for ', set_num2, ' in ', .removeEndSet(names(set_num2)), collapse = ' ')

  # rs <- paste0('(', paste0(set_num2, collapse =', '), ') in (', paste0(.removeEndSet(names(set_num2)), collapse = ', '), ')')

  if (length(cnd_slice) != 0) {
    rs <- paste0(rs, ' if ', paste0(paste0('(', c(lapply(cnd_slice, paste0, collapse = ', '),
        recursive = TRUE), ') in ', names(cnd_slice)), collapse = ' && '))
    # rs <- paste0(rs, ' if ', paste0(paste0('(', c(lapply(cnd_slice, paste0, collapse = ', '),
    #   recursive = TRUE), ') in ', names(cnd_slice)), collapse = ' && '))
  }
  list(first = NULL, end = rs)
}

.get_julia_loop_fast2 <- function(xxx) {
  if (any(grep('[$]', xxx))) {
    beg <- gsub('[$].*', '', xxx)
    end <- substr(xxx, nchar(beg) + 2, nchar(xxx))
  } else {
    beg <- xxx
    end <- NULL
  }
  .get_julia_loop_fast(beg, end)
}

.get.bracket.julia <- function(tmp) {
  brk0 <- gsub('[^)(]', '', tmp)
  brk <- cumsum(c('(' = 1, ')' = -1)[strsplit(brk0, '')[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0('^', paste0(paste0('[', names(brk)[1:(k-1)], ']'), rep('[^)(]*', k - 1), collapse = ''), names(brk)[k]), '', tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}

.handle.sum.julia <- function(tmp) {
  hh <- .get.bracket.julia(tmp)
  a1 <- sub('^[(]', '', sub('[)]$', '', hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ',') {
    a2 <- gsub('^([[:alnum:]]|[+]|[-]|[*]|[$])*', '', a2)
    if (substr(a2, 1, 1) == '(')
      a2 <- .get.bracket.julia(a2)$end
  }
  # paste0('(', .eqt.to.julia(substr(a2, 2, nchar(a2))), ' for ', .get_julia_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ')',
  #        .eqt.to.julia(hh$end))
  paste0('(', .eqt.to.julia(substr(a2, 2, nchar(a2))), .get_julia_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ')',
         .eqt.to.julia(hh$end))
}
.eqt.to.julia <- function(tmp) {
  rs <- ''
  while (nchar(tmp) != 0) {
    tmp <- gsub('^[ ]*', '', tmp)
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, 'sum', .handle.sum.julia(substr(tmp, 4, nchar(tmp))))
      tmp <- ''
    } else if (any(grep('^([.[:digit:]]|[+]|[-]|[ ]|[*])', tmp))) {
      a3 <- gsub('^([.[:digit:]_]|[+]|[-]|[ ]|[*])*', '', tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c('m', 'v', 'p')) {
      a1 <- sub('^[[:alnum:]_]*', '', tmp)
      vrb <- substr(tmp, 1, nchar(tmp) - nchar(a1))
      a2 <- .get.bracket.julia(a1)
      arg <- paste0('(', paste0(.aliasName(strsplit(gsub('[() ]', '', a2$beg), ',')[[1]]), collapse = ', '), ')')
      if (nchar(arg) == 0) {
        vrb2 <- paste0(vrb)
      } else {
        vrb2 <- paste0(vrb, '[', arg, ']')
        if (substr(tmp, 1, 1) == 'p') {
          if (arg == '()') vrb2 <- vrb else vrb2 <- paste0('(if haskey(', vrb, ',', arg, '); ', vrb2, '; else ', vrb, 'Def; end)')
        }
      }
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == '$') {
        # There are condition
        rs <- paste0(rs, '(if ', arg, ' in ', gsub('([$]|[(].*)', '', a2$end), '; ', vrb2, '; else 0;end)',
          .eqt.to.julia(gsub('^[^)]*[)]', '', a2$end)))
        tmp <- ''
      } else {
        rs <- paste0(rs, vrb2, .eqt.to.julia(a2$end))
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

# equation declaration
.equation.from.gams.to.julia <- function(eqt) {
  declaration <- gsub('[.][.].*', '', eqt)
  rs <- '@constraint(model, '
  if (nchar(declaration) != nchar(gsub('[($].*', '', declaration))) {
    rs <- paste0(rs, paste0('[(', paste0(.aliasName(strsplit(gsub('(.*[(]|[)]|[[:blank:]]*)', '', declaration), ',')[[1]]), collapse = ', '),
      ') in ', gsub('[(].*', '', gsub('.*[$]', '', declaration)), '], '))
  }
  rs <- paste0(rs, .eqt.to.julia(gsub('.*[.][.][ ]*', '', eqt)))
  rs
}
