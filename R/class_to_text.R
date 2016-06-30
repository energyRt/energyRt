
class_to_text <- function(obj, alias = NULL) {
  cls <- class(obj)
  slts <- getSlots(cls)
  prt <- new(cls)
  if (is.null(alias)) {
    if (any(names(slts) == 'name')) nm <- obj@name else nm <- 'alias'
  } else nm <- alias
  txt <- paste(nm, ' <- new("', class(obj), '");', sep = '')
  for(sl in names(slts)) {
    a1 <- slot(obj, sl)
    a2 <- slot(prt, sl)
#    if (is.factor(a1) && class(levels(a1)) == 'character') a1 <- as.character(a1)
#    if (is.factor(a1) && class(levels(a1)) == 'numeric') a1 <- as.numeric(as.character(a1))
#    if (is.factor(a2) && class(levels(a2)) == 'character') a2 <- as.character(a2)
#    if (is.factor(a2) && class(levels(a2)) == 'numeric') a2 <- as.numeric(as.character(a2))
#    if ((slts[sl] == 'character' || (slts[sl] == 'factor' && class(a1) == 'character')) 
#       && (length(a1) != length(a2) || any(a1 != a2))) {
    if (slts[sl] == 'character' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste(nm, '@', sl, ' <- "', a1, '";', sep = ''))
      } else if (length(a1) == 0) {
        txt <- c(txt, paste(nm, '@', sl, ' <- c();', sep = ''))
      } else {
         txt <- c(txt, paste(nm, '@', sl, ' <- c("', paste(a1, collapse = '", "'), '");', sep = ''))
      }
    } else
    if (slts[sl] == 'numeric' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste(nm, '@', sl, ' <- ', a1, ';', sep = ''))
      } else {
         txt <- c(txt, paste(nm, '@', sl, ' <- c(', paste(a1, collapse = ', '), ');', sep = ''))
      }
    } else if (slts[sl] == 'factor' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste(nm, '@', sl, ' <- factor("', a1, '", levels = levels(', nm, '@', sl, '));', sep = ''))
      } else if (length(a1) == 0) {
        txt <- c(txt, paste(nm, '@', sl, ' <- factor(c(), levels = levels(', nm, '@', sl, '));', sep = ''))
      } else {
         txt <- c(txt, paste(nm, '@', sl, ' <- factor(c("', paste(a1, collapse = '", "'), 
             '"), levels = levels(', nm, '@', sl, '));', sep = ''))
      }
    } else if (slts[sl] == 'data.frame') {
      if (any(sapply(a1, class) == 'factor')) {
        for(i in (1:ncol(a1))[sapply(a1, class) == 'factor'])
          if (class(levels(a1[, i])) == 'character') a1[, i] <- as.character(a1[, i])
          if (class(levels(a1[, i])) == 'numeric') a1[, i] <- as.numeric(as.character(a1[, i]))
      }
      if (any(sapply(a2, class) == 'factor')) {
        for(i in (1:ncol(a2))[sapply(a2, class) == 'factor'])
          if (class(levels(a2[, i])) == 'character') a2[, i] <- as.character(a2[, i])
          if (class(levels(a2[, i])) == 'numeric') a2[, i] <- as.numeric(as.character(a2[, i]))
      }

  ## data.frame
      if (ncol(a1) != ncol(a2) || any(colnames(a1) != colnames(a2))) stop('Wrong data frame ', sl)
      if (nrow(a1) != nrow(a2) || sapply(1:ncol(a1), function(x) {
        any(is.na(a1[, x]) != is.na(a2[,x])) & any(a1[!is.na(a1[, x]), x] != a2[!is.na(a1[, x]), x])
      })) {
         if (nrow(a2) != 0) txt <- c(txt, paste(nm, '@', sl, ' <- ', nm, '@', sl, '[0,, drop = FALSE];', sep = ''))
         if (nrow(a1) != 0) {
            txt <- c(txt, paste(nm, '@', sl, '[1:', nrow(a1), ', ] <- NA;', sep = ''))
            ## Character
            fl <- sapply(a1, class) == 'character'
            if (any(fl) && any(!is.na(a1[, fl]))) {
                aa <- a1[, fl, drop = FALSE]
                for(j in seq(along = aa[, 1])[apply(!is.na(aa), 1, any)])
                  if (sum(!is.na(aa[j, ])) == 1) {
                    txt <- c(txt, paste(nm, '@', sl, '[', j, ', "',
                       colnames(aa)[!is.na(aa[j, ])], '"] <- "', aa[j, !is.na(aa[j, ])],
                         '";', sep = ''))
                  } else {   
                    txt <- c(txt, paste(nm, '@', sl, '[', j, ', c("',
                       paste(colnames(aa)[!is.na(aa[j, ])], collapse = '", "'), '")] <- c("', 
                         paste(aa[j, !is.na(aa[j, ])], collapse = '", "'), '");', sep = ''))
                  }
            }
            ## Not character
            fl <- sapply(a1, class) != 'character'
            if (any(fl) && any(!is.na(a1[, fl]))) {
                aa <- a1[, fl, drop = FALSE]
                for(j in seq(along = aa[, 1])[apply(!is.na(aa), 1, any)])
                  if (sum(!is.na(aa[j, ])) == 1) {
                    txt <- c(txt, paste(nm, '@', sl, '[', j, ', "',
                       colnames(aa)[!is.na(aa[j, ])], '"] <- ', aa[j, !is.na(aa[j, ])],
                         ';', sep = ''))
                  } else {   
                    txt <- c(txt, paste(nm, '@', sl, '[', j, ', c("',
                       paste(colnames(aa)[!is.na(aa[j, ])], collapse = '", "'), '")] <- c(', 
                         paste(aa[j, !is.na(aa[j, ])], collapse = ', '), ');', sep = ''))
                  }
            }
         }
      }
    }
  }
  txt
}


class_to_text2 <- function(obj, alias = NULL) {
  cls <- class(obj)
  slts <- getSlots(cls)
  prt <- new(cls)
  if (is.null(alias)) {
    if (any(names(slts) == 'name')) nm <- obj@name else nm <- 'alias'
  } else nm <- alias
  #txt <- paste(nm, ' <- new("', class(obj), '");', sep = '')
  txt <- paste(nm, ' <- new', toupper(substr(cls, 1, 1)), substr(cls, 2, nchar(cls)), '(', sep = '') 
    #'(name = "', nm, '", \n'
  for(sl in names(slts)) {
   # if (sl == names(slts)[length(slts)]) isend <- '\n);\n' else isend <- ','
    a1 <- slot(obj, sl)
    a2 <- slot(prt, sl)
#    if (is.factor(a1) && class(levels(a1)) == 'character') a1 <- as.character(a1)
#    if (is.factor(a1) && class(levels(a1)) == 'numeric') a1 <- as.numeric(as.character(a1))
#    if (is.factor(a2) && class(levels(a2)) == 'character') a2 <- as.character(a2)
#    if (is.factor(a2) && class(levels(a2)) == 'numeric') a2 <- as.numeric(as.character(a2))
#    if ((slts[sl] == 'character' || (slts[sl] == 'factor' && class(a1) == 'character')) 
#       && (length(a1) != length(a2) || any(a1 != a2))) {
    if (slts[sl] == 'character' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste('    ', sl, ' = "', a1, '",', sep = ''))
      } else if (length(a1) == 0) {
         txt <- c(txt, paste('    ', sl, ' = c(),', sep = ''))
      } else {
         txt <- c(txt, paste('    ', sl, ' = c("', paste(a1, collapse = '", "'), '"),', sep = ''))
      }
    } else
    if (slts[sl] == 'numeric' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste('    ', sl, ' = ', a1, ',', sep = ''))
      } else {
         txt <- c(txt, paste('    ', sl, ' = c(', paste(a1, collapse = ', '), '),', sep = ''))
      }
    } else if (slts[sl] == 'factor' && (length(a1) != length(a2) || any(a1 != a2))) {
      if (length(a1) == 1) {
         txt <- c(txt, paste('    ', sl, ' = factor("', a1, '", levels = c("', 
           paste(levels(slot(obj, sl)), collapse = '", "'), '")),', sep = ''))
      } else if (length(a1) == 0) {
        txt <- c(txt, paste('    ', sl, ' = factor(c(), levels = c("', 
           paste(levels(slot(obj, sl)), collapse = '", "'), '")),', sep = ''))
      } else {
         txt <- c(txt, paste('    ', sl, ' = factor(c("', paste(a1, collapse = '", "'), 
             '"), levels = c("', paste(levels(slot(obj, sl)), collapse = '", "'), '")),', sep = ''))
      }
    } else if (slts[sl] == 'data.frame' && nrow(slot(obj, sl)) != 0 && any(!is.na(slot(obj, sl)))) {
      if (any(sapply(a1, class) == 'factor')) {
        for(i in (1:ncol(a1))[sapply(a1, class) == 'factor'])
          if (class(levels(a1[, i])) == 'character') a1[, i] <- as.character(a1[, i])
          if (class(levels(a1[, i])) == 'numeric') a1[, i] <- as.numeric(as.character(a1[, i]))
      }
      if (any(sapply(a2, class) == 'factor')) {
        for(i in (1:ncol(a2))[sapply(a2, class) == 'factor'])
          if (class(levels(a2[, i])) == 'character') a2[, i] <- as.character(a2[, i])
          if (class(levels(a2[, i])) == 'numeric') a2[, i] <- as.numeric(as.character(a2[, i]))
      }
  ## data.frame
      if (ncol(a1) != ncol(a2) || any(colnames(a1) != colnames(a2))) stop('Wrong data frame ', sl)
      if (nrow(a1) != nrow(a2) || sapply(1:ncol(a1), function(x) {
        any(is.na(a1[, x]) != is.na(a2[,x])) & any(a1[!is.na(a1[, x]), x] != a2[!is.na(a1[, x]), x])
      })) {
         #if (nrow(a2) != 0) txt <- c(txt, paste(nm, '@', sl, ' <- ', nm, '@', sl, '[0,, drop = FALSE];', sep = ''))
         if (nrow(a1) != 0) {
            txt <- c(txt, paste('    ', sl, ' = data.frame(', sep = ''))
            ## Character
            kk <- names(a1)[apply(!is.na(a1), 2, any)]
            kend <- kk[length(kk)]
            for(qq in kk) {
              if (kend == qq) isend2 <- '\n    ),' else isend2 <- ','
              #fl <- sapply(a1, class) == 'character'
              if (class(a1[, qq]) == 'character') {
                  aa <- a1[, qq]
                  aa[!is.na(aa)] <- paste('"', aa[!is.na(aa)], '"', sep = '')
                    if (length(aa) == 1) {
                      txt <- c(txt, paste('        ', qq, ' = ', aa, isend2, '', sep = ''))
                    } else {   
                      txt <- c(txt, paste('        ', qq, ' = c(', 
                         paste(aa, collapse = ', '), ')', isend2, '', sep = ''))
                    }
              } else {
                  aa <- a1[, qq]
                    if (length(aa) == 1) {
                      txt <- c(txt, paste('        ', qq, ' = ', aa, '', isend2, '', sep = ''))
                    } else {   
                      txt <- c(txt, paste('        ', qq, ' = c(', 
                         paste(aa, collapse = ', '), ')', isend2, '', sep = ''))
                    }
              } 
           }
           if (length(kk) == 1) { #txt <- c(txt[length(txt) - (0:2)], paste())
             txt <- c(txt[1:(length(txt) - 2)], paste(txt[length(txt) - 1], 
                gsub('\n[ ]*', '', gsub('^[ ]*', '', txt[length(txt)])), sep = ''))
           }
         }
        # txt <- paste(txt, isend)
      }
    }
  }
  txt[length(txt)] <- sub(',$', '', txt[length(txt)])
  txt <- c(txt, ');\n')
  txt
}



