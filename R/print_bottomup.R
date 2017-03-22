.is_additional_information <- function(obj) {
    sl <- getSlots(class(obj))
    EX <- new(class(obj))                            
    for(i in names(sl)[sl %in% 'character'])
      if (is.null(slot(EX, i))) slot(EX, i) <- '-'
    RT <- compare(EX, obj, TRUE)
    length(RT) > 1
}

.print_bottomup <- function(obj, print.all = FALSE) {
    sl <- getSlots(class(obj))
    if (!print.all) {
      EX <- new(class(obj))                            
      for(i in names(sl)[sl %in% c('character', 'characterOrNULL')])
        if (is.null(slot(EX, i))) slot(EX, i) <- '-'
      RT <- compare(EX, obj, TRUE)
      sl <- sl[RT]
    }
    # Compare
    for(nm in names(sl)[sl %in% c('factor', 'numeric',
      'logical', 'character', 'characterOrNULL')]) {
      if ('.S3Class' != nm) {
        s1 <- slot(obj, nm)
        if (length(s1) == 1) {
            if (sl[nm] %in% c('character', 'characterOrNULL')) {
              cat(nm, ': "', as.character(s1), '"\n', sep = '')
            } else {
              cat(nm, ': ', as.character(s1), '\n', sep = '')
            }
        } else {
              cat(nm, ':\n', sep = '')
              print(s1)
        }
      }
    }
    for(nm in names(sl)[sl %in% 'data.frame']) {
      s1 <- slot(obj, nm)
      cat(nm, ':\n', sep = '')
      print(s1)
    }
}

print.demand <- energyRt:::.print_bottomup
print.technology <- energyRt:::.print_bottomup
print.supply <- energyRt:::.print_bottomup
print.commodity <- energyRt:::.print_bottomup
print.region <- energyRt:::.print_bottomup
print.constrain <- energyRt:::.print_bottomup
print.sysInfo <- energyRt:::.print_bottomup
print.reserve <- energyRt:::.print_bottomup
print.export <- energyRt:::.print_bottomup
print.import <- energyRt:::.print_bottomup

.cat_bottomup_data_frame <- function(s1, nm, zz, maxcol = 10) {
  if (ncol(s1) < maxcol) {
    energyRt:::.cat_bottomup_data_frame2(s1, nm, zz)
  } else {
  fl <- !sapply(s1, function(x) all(is.na(x)))
  if (any(fl)) {
    s1 <- s1[,fl, drop = FALSE]
    if (ncol(s1) <= maxcol) {
      energyRt:::.cat_bottomup_data_frame2(s1, nm, zz)
    } else {
      #hh <- round(seq(1, ncol(s1), length.out = ncol(s1) %/% maxcol + 2))
      #hh <- hh[-length(hh)]
      #uu <- c(hh[-1] + 1, ncol(s1))
      hh <- seq.int(1, ncol(s1), maxcol)
      hh[hh == ncol(s1)] <- ncol(s1) - 1
      uu <- c(hh[-1] - 1, ncol(s1))
      for(i in 1:length(hh)) {
        energyRt:::.cat_bottomup_data_frame2(s1[, hh[i]:uu[i]], 
           paste(nm, ', part ', i, sep = ''), zz)
        }
      }
    }
  }
}
.cat_bottomup_data_frame2 <- function(s1, nm, zz) {
      cat('\\captionof{table}{', nm, '.}\n', sep = '', file = zz)
      cat('\\begin{longtable}{ | ', 
         paste(rep('c', ncol(s1) + 1), collapse = ' | '), ' |}\n', sep = '', file = zz)
      cat('\\hline\n', sep = '', file = zz)
      cat(' & ', paste(paste('\\textbf{', gsub('_', '\\\\_', colnames(s1)), '}', sep = ''), 
         collapse = ' & '), ' \\\\\n', sep = '', file = zz)
      cat('\\endhead\n', sep = '', file = zz)
      cat('\\hline\n', sep = '', file = zz)
      if (nrow(s1) > 0) {
        for (i in colnames(s1)[sapply(s1, class) == 'factor']) 
          s1[, i] <- as.character(s1[, i])
        s1[is.na(s1)] <- '-'
        for(i in 1:nrow(s1)) {
          cat('\\textbf{', rownames(s1)[[i]], '} & ', paste(gsub('_', '\\\\_', as.character(s1[i,])), 
           collapse = ' & '), ' \\\\\n', sep = '', file = zz)
          cat('\\hline\n', sep = '', file = zz)
        }
      } else {
        cat('\\multicolumn{', 1 + ncol(s1), '}{|c|}{\\textless 0 row \\textgreater} ', 
        '\\\\\n\\hline\n', sep = '', file = zz)
      }
      cat('\\end{longtable}\n\n', sep = '', file = zz)
}

.cat_bottomup <- function(obj, print.all = FALSE, file = '', includename = TRUE) {
    zz <- file
    sl <- getSlots(class(obj))
    if (!print.all) {
      EX <- new(class(obj))                            
      for(i in names(sl)[sl %in% c('character', 'characterOrNULL')])
        if (is.null(slot(EX, i))) slot(EX, i) <- '-'
      RT <- compare(EX, obj, TRUE)
      sl <- sl[RT]
    }
    # Compare
    for(nm in names(sl)[sl %in% c('factor', 'numeric',
      'logical', 'character', 'characterOrNULL')]) {
      if ('.S3Class' != nm && (includename || nm != 'name')) {
        s1 <- slot(obj, nm)
        if (length(s1) == 1) {
            if (sl[nm] %in% c('factor', 'character', 'characterOrNULL')) {
              cat(nm, ': "', gsub('_', '\\\\_', as.character(s1)), '"\n\n', sep = '', file = zz)
            } else {
              cat(nm, ': ', as.character(s1), '\n\n', sep = '', file = zz)
            }
        } else {
              cat(nm, ': ', sep = '', file = zz)
            if (sl[nm] %in% c('factor', 'character', 'characterOrNULL')) {
              cat(paste(gsub('_', '\\\\_', as.character(s1)), collapse = ', '), '\n\n', sep = '', file = zz) 
            } else {
              cat('"', paste(s1, collapse = '", "'), '"\n\n', sep = '', file = zz) 
            }
        }
      }
    }
    for(nm in names(sl)[sl %in% 'data.frame']) {
      s1 <- slot(obj, nm)
      energyRt:::.cat_bottomup_data_frame(s1, nm, zz)
#      cat('\\captionof{table}{', nm, '.}\n', sep = '', file = zz)
#      cat('\\begin{tabularx}{\\textwidth}{ | ', 
#         paste(rep('X', ncol(s1) + 1), collapse = ' | '), ' |}\n', sep = '', file = zz)
#      cat('\\hline\n', sep = '', file = zz)
#      cat('\\textbf{row} & ', paste(paste('\\textbf{', colnames(s1), '}', sep = ''), 
#         collapse = ' & '), ' \\\\\n', sep = '', file = zz)
#      cat('\\hline\n', sep = '', file = zz)
#      if (nrow(s1) > 0) {
#        s1[is.na(s1)] <- '-'
#        for(i in 1:nrow(s1)) {
#          cat('\\textbf{', rownames(s1)[[i]], '} & ', paste(as.character(s1[i,]), 
#           collapse = ' & '), ' \\\\\n', sep = '', file = zz)
#          cat('\\hline\n', sep = '', file = zz)
#        }
#      } else {
#        cat('\\multicolumn{', 1 + ncol(s1), '}{|c|}{\\textless 0 row \\textgreater} ', 
#        '\\\\\n\\hline\n', sep = '', file = zz)
#      }
#      cat('\\end{tabularx}\n\n', sep = '', file = zz) 
    }
    if (class(obj) == 'constrain') {
      for(nm in names(obj@for.each)) {
        if (is.null(obj@for.each[[nm]])) {
          cat('\\textbf{For each: ', nm, '}: *.\n', sep = '', file = zz)
        } else {
          cat('\\textbf{For each: ', nm, '}: ', paste(gsub('_', '\\\\_', 
             as.character(obj@for.each[[nm]])), collapse = ', '), '.\n', sep = '', file = zz)
        }
      }
      for(nm in names(obj@for.sum)) {
        if (is.null(obj@for.sum[[nm]])) {
          cat('\\textbf{For sum: ', nm, '}: *.\n', sep = '', file = zz)
        } else {
          cat('\\textbf{For sum: ', nm, '}: ', paste(gsub('_', '\\\\_', 
             as.character(obj@for.sum[[nm]])), collapse = ', '), '.\n', sep = '', file = zz)
        }
      }
    }
}




