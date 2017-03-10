get.listing.file <- function(mdl, ...) {
  if (class(mdl) == 'scenario') mdl <- mdl@model
  if (class(mdl) != 'model') stop('Unexpected class for get.listing.file')
  jj <- solve(mdl, name = 'LISTING', only.listing = TRUE, ...) 
  eqt_lst <- grep('^----[[:space:]]*[[:digit:]][[:digit:]]*[[:space:]]*Equation', jj) 
  eqt_lst <- gsub('[[:space:]][[:space:]]*.*', '', 
    gsub('^----[[:space:]]*[[:digit:]][[:digit:]]*[[:space:]]*Equation[[:space:]]*', 
    '', jj[eqt_lst]))
  kk <- jj[grep(paste('---- ', eqt_lst[1], sep = ''), jj):grep(paste(
    '^----[[:space:]]*[[:digit:]][[:digit:]]*[[:space:]]*Equation[[:space:]]*', 
      eqt_lst[length(eqt_lst)], sep = ''), jj)]
  kk <- grep('^[[:space:]]*$', kk, invert = TRUE, value = TRUE)
  kk <- grep('(^---|[[:space:]]*NONE$)', kk, invert = TRUE, value = TRUE)
  kk <- grep('(^Equation Listing|GAMS|G e n e r a l   A l g e b r a i c)', kk, invert = TRUE, value = TRUE)
  feqt <- data.frame(bg = grep('[.][.]', kk), en = grep('[;]', kk))
  feqt <- apply(feqt, 1, function(x) gsub('[[:space:]]*', '', gsub('[;].*', '', 
    paste(kk[x[1]:x[2]], collapse = ''))))
  vb_map <- getVariablesDim()
  eq_map <- getEquationsDim()
  splt.by.variable <- function(eq)  {
    arg <- gsub('[.][.].*', '', eq)
    if (any(grep('[(]', arg))) {
      rs <- list(name = gsub('[(].*', '', arg), loop = strsplit(gsub('.*[(]', '', gsub('[)].*', '', arg)), ',')[[1]])
      names(rs$loop) <- eq_map[[rs$name]]
    } else rs <- list(name = arg, loop = NULL)  
    eq <- gsub('.*[.][.]', '', eq)
    eq <- gsub('^[[:digit:].*-+]*', '', eq)
    eq <- gsub('[=].*', '', eq)
    while (nchar(eq) != 0) {
      nn <- nchar(eq) - nchar(gsub('^[[:alnum:]_]*', '', eq)) + 1
      if (substr(eq, nn, nn) == '(') {
        rs[[length(rs) + 1]] <- list(name = substr(eq, 1, nn - 1),
          arg = strsplit(sub('[)].*', '', substr(eq, nn + 1, nchar(eq))), ',')[[1]])
          names(rs[[length(rs)]]$arg) <- vb_map[[rs[[length(rs)]]$name]]
        eq <- sub('^[[:alnum:](,_]*[)]', '', eq)
      } else {
        rs[[length(rs) + 1]] <- list(name = substr(eq, 1, nn - 1))
        eq <- substr(eq, nn, nchar(eq))
      }
      eq <- gsub('^[-*+.[:digit:])]*', '', eq)
    }
    rs
  }
  list(cond = lapply(feqt, splt.by.variable), src = feqt)
}

parseListing <- function(mdl, ...) {
  eq_map <- getEquations()
  vr_map <- getVariables()
  ss <- c(colnames(eq_map)[-(1:2)], rownames(eq_map), 'variables', 'equations')
  gg <- get.listing.file(mdl, ..., exclude = ss)
  arg <- list(...)
  arg <- arg[names(arg) %in% ss]
  fl <- rep(TRUE, length(gg$cond))
  # Check by equations name
  if (any(names(arg) == 'equations')) {
    fl <- fl & (sapply(gg$cond, function(x) x[[1]]) %in% arg$equations)
  }
  # Check by variables name
  if (any(names(arg) == 'variables')) {
    for(j in seq(along = fl)) if (fl[j]) {
      for(i in arg$variables) {
        if (all(!sapply(gg$cond[[j]][-(1:2)], function(x) x$name == i))) fl[j] <- FALSE
      }
    }  
  }
  # Check by set name
  sets <- colnames(vr_map)[2 + 1:(ncol(vr_map) - nrow(eq_map) - 2)]
  s0 <- names(arg)[names(arg) %in% sets]
  if (length(s0) > 0) {
    for(j in seq(along = fl)) if (fl[j]) {
      for(i in s0) if (fl[j]) {
        ff <- sapply(gg$cond[[j]][-(1:2)], function(x) any(names(x$arg) == i))
        if (all(!ff)) fl[j] <- FALSE else {
          if (!any(sapply(gg$cond[[j]][-(1:2)][ff], function(x) 
            x$arg[i] %in% arg[[i]]))) fl[j] <- FALSE
        }
      }
    }  
  }
  # Check by variables condition
  s1 <- names(arg)[names(arg) %in% rownames(vr_map)]
  if (length(s1) != 0) {
    for(j in seq(along = fl)) if (fl[j]) {
      for(i in s1) {
        ff <- sapply(gg$cond[[j]][-(1:2)], function(x) x$name == i)
        if (all(!ff)) fl[j] <- FALSE else {
          HH <- FALSE
          for(k in seq(along = ff)[ff]) {
            HH <- HH || all(sapply(names(arg[[s1]]), function(x) 
              any(gg$cond[[j]][[2 + k]]$arg[x] %in% arg[[s1]][[x]])))
          }
          fl[j] <- HH
        }
      }
    }
  }
  gg$src[fl]
}
  


