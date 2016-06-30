compare <- function(obj1, obj2, just_name = FALSE) {
  if (class(obj1) == 'constrain' && class(obj1@comm) == 'NULL') {
    obj1@comm <- '-'
  }
  if (class(obj2) == 'constrain' && class(obj2@comm) == 'NULL') {
    obj2@comm <- '-'
  }
  FL <- TRUE
  if (class(obj1) != class(obj2)) {
    cat('Different class for objects: "', class(obj1), '", "', class(obj2), '"\n', sep = '')
    #structure(list(obj1 = obj1, obj2 = obj2, difference = 'Different class')
    FL <- FALSE
  } else { 
    sl <- getSlots(class(obj1))
    obj <- new(class(obj1)) 
    if (just_name) {
      RT <- rep(FALSE, length(sl))
      names(RT) <- names(sl) 
    }        
    # Check
    for(nm in names(sl)) {
      CLS <- class(slot(obj1, nm)); if (CLS == 'integer') CLS <- 'numeric'
      if (CLS != sl[nm]) {
        stop('Wrong slot "', nm, '" class in object 1\n')
      }
      CLS <- class(slot(obj1, nm)); if (CLS == 'integer') CLS <- 'numeric'
      if (CLS != sl[nm]) {
        stop('Wrong slot "', nm, '" class in object 2\n')
      }
      if (class(obj) != 'constrain' || nm != 'rhs') {
        if (class(slot(obj, nm)) == 'data.frame') {
          if (ncol(slot(obj1, nm)) != ncol(slot(obj, nm)) ||
            any(colnames(slot(obj1, nm)) != colnames(slot(obj, nm))) ||
            any(sapply(slot(obj1, nm), class) != sapply(slot(obj, nm), class)))
                                  stop('Wrong slot "', nm, '" class in object 1\n')
        }
        if (class(slot(obj, nm)) == 'data.frame') {
          if (ncol(slot(obj2, nm)) != ncol(slot(obj, nm)) ||
            any(colnames(slot(obj2, nm)) != colnames(slot(obj, nm))) ||
            any(sapply(slot(obj2, nm), class) != sapply(slot(obj, nm), class)))
                                  stop('Wrong slot "', nm, '" class in object 2\n')
        }
      }
      if (class(slot(obj, nm)) == 'factor') {
        if (length(levels(slot(obj1, nm))) != length(levels(slot(obj, nm))) ||
          any(levels(slot(obj1, nm)) != levels(slot(obj, nm))))
                                stop('Wrong slot "', nm, '" class in object 1\n')
      }
      if (class(slot(obj, nm)) == 'factor') {
        if (length(levels(slot(obj2, nm))) != length(levels(slot(obj, nm))) ||
          any(levels(slot(obj2, nm)) != levels(slot(obj, nm))))
                                stop('Wrong slot "', nm, '" class in object 2\n')
      }
    }               
    chk <- function(a, b) all(is.na(a) == is.na(b) & 
      (is.na(a) | (!is.na(a) & as.character(a) == as.character(b))))
    # Compare
    #fl <- rep(TRUE, length(sl)); names(fl) <- names(sl)
    for(nm in names(sl)[sl %in% c('factor', 'numeric', 'logical', 'character')]) {
      s1 <- slot(obj1, nm)
      s2 <- slot(obj2, nm)
      if (length(s1) == 1 && length(s2) == 1) {
        if (!all(chk(s1, s2))) {
          FL <- FALSE
          if (just_name) RT[nm] <- TRUE else {
            if (sl[nm] == 'character') {
              cat('Differences slot "', nm, '": "', as.character(s1), '",\t"', 
                 as.character(s2), '"\n', sep = '')
            } else {
              cat('Differences slot "', nm, '": ', as.character(s1), ',\t', 
                 as.character(s2), '\n', sep = '')
            }
          }
        }
      } else {
        if (length(s1) != length(s2) || !chk(s1, s2))
        cat('Differences slot "', nm, '":\n', sep = '')
        if (length(s1) < length(s2)) s1[(length(s1) + 1):length(s2)] <- NA
        if (length(s2) < length(s1)) s2[(length(s2) + 1):length(s1)] <- NA
        print(cbind(obj1 = s1, obj2 = s2))
      } #stop('Need realise')
    }
    for(nm in names(sl)[sl %in% 'data.frame']) {
      s1 <- slot(obj1, nm)
      s2 <- slot(obj2, nm)
      # Exception for constrain
      if (nm == 'rhs' && class(obj2) == 'constrain' && ncol(obj2@rhs) != 0) {
            if (just_name) RT[nm] <- TRUE else {
              cat('Differences slot "', nm, '":\n', sep = '')
              print(obj2@rhs)
            }
      } else {
        if (nrow(s1) != nrow(s2) || any(!sapply(1:ncol(s1), 
          function(x) chk(s1[, x], s2[, x])))) {
            if (just_name) RT[nm] <- TRUE else {
              cat('Differences slot "', nm, '":\n', sep = '')
              colnames(s1) <- paste('obj1.', colnames(s1), sep = '')
              colnames(s2) <- paste('obj2.', colnames(s2), sep = '')
              FL <- FALSE
              if (nrow(s1) < nrow(s2)) s1[(nrow(s1) + 1):nrow(s2), ] <- NA
              if (nrow(s2) < nrow(s1)) s2[(nrow(s2) + 1):nrow(s1), ] <- NA
              print(cbind(s1, s2))
            }
        }
      }
    }
    if (FL) cat('There is not differences\n')
  }
  if (just_name) names(RT)[RT] else FL
}

#
#compare.technology <- function(a,b,...) {
## compare technology
#    if_print_one <- function(a,b,sl) if(slot(a,sl) != slot(b,sl)) cat(sl,':',slot(a,sl),',',slot(b,sl),'\n')
#    if_print_vector <- function(a,b,sl) {
#      a1 <- slot(a,sl)
#      b1 <- slot(b,sl)
#      if ((is.null(a1) && !is.null(b1)) || (!is.null(a1) && is.null(b1)) ||
#                  (!is.null(a1) && (length(a1) != length(b1) || any(sort(a1) != sort(b1))))) {
#        if(is.null(a1)) cat(sl,a@name,' is NULL\n') else {
#          cat(sl,a@name,':\n');
#          print(a1);
#        }
#        if(is.null(b1)) cat(sl,v@name,' is NULL\n') else {
#          cat(sl,b@name,':\n');
#          print(b1);
#        }
#      }
#    }
#    if_print_data_frame <- function(a,b,sl) {
#      aa <- as.character(c(slot(a,sl),recursive=TRUE))
#      bb <- as.character(c(slot(b,sl),recursive=TRUE))
#      if (nrow(slot(a,sl)) != nrow(slot(b,sl)) || ( nrow(slot(a,sl)) != 0
#                && !all(all(is.na(aa) & is.na(bb)) || all(aa[!is.na(aa)] == bb[!is.na(bb)]))
#            )) {
#          a1 <- slot(a,sl); b1 <- slot(b,sl);
#          for(i in 1:ncol(a1)) if(all(levels(a1[,i])!='')) levels(a1[,i]) <- c(levels(a1[,i]),'')
#          for(i in 1:ncol(b1)) if(all(levels(b1[,i])!='')) levels(b1[,i]) <- c(levels(b1[,i]),'')
#          if (nrow(a1) < nrow(b1)) a1[(nrow(a1) + 1):nrow(b1),]<-''
#          if (nrow(a1) > nrow(b1)) b1[(nrow(b1) + 1):nrow(a1),]<-''
#          gg <- cbind(a1,b1)
#          colnames(gg)<-paste(c(rep(a@name,ncol(a1)),rep(b@name,ncol(a1))),rep('.',ncol(a1)*2),rep(colnames(slot(a,sl))),sep='')
#          cat(sl,':\n')
#          print(gg)
#      }
#    }
#    cat('Name: ',a@name,', ',b@name,'\n')
#    if_print_one(a,b,'type')
#    #if_print_one(a,b,'description')
#    if_print_one(a,b,'cap2act')
#    #if_print_vector(a,b,'region')
#    for(i in technology_data_frame()) if_print_data_frame(a,b,i)
#}
#
