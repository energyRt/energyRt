
compare.technology <- function(a,b,...) {
# compare technology
    if_print_one <- function(a,b,sl) if(slot(a,sl) != slot(b,sl)) cat(sl,':',slot(a,sl),',',slot(b,sl),'\n')
    if_print_vector <- function(a,b,sl) {
      a1 <- slot(a,sl)
      b1 <- slot(b,sl)
      if ((is.null(a1) && !is.null(b1)) || (!is.null(a1) && is.null(b1)) ||
                  (!is.null(a1) && (length(a1) != length(b1) || any(sort(a1) != sort(b1))))) {
        if(is.null(a1)) cat(sl,a@name,' is NULL\n') else {
          cat(sl,a@name,':\n');
          print(a1);
        }
        if(is.null(b1)) cat(sl,v@name,' is NULL\n') else {
          cat(sl,b@name,':\n');
          print(b1);
        }
      }
    }
    if_print_data_frame <- function(a,b,sl) {
      aa <- as.character(c(slot(a,sl),recursive=TRUE))
      bb <- as.character(c(slot(b,sl),recursive=TRUE))
      if (nrow(slot(a,sl)) != nrow(slot(b,sl)) || ( nrow(slot(a,sl)) != 0
                && !all(all(is.na(aa) & is.na(bb)) || all(aa[!is.na(aa)] == bb[!is.na(bb)]))
            )) {
          a1 <- slot(a,sl); b1 <- slot(b,sl);
          for(i in 1:ncol(a1)) if(all(levels(a1[,i])!='')) levels(a1[,i]) <- c(levels(a1[,i]),'')
          for(i in 1:ncol(b1)) if(all(levels(b1[,i])!='')) levels(b1[,i]) <- c(levels(b1[,i]),'')
          if (nrow(a1) < nrow(b1)) a1[(nrow(a1) + 1):nrow(b1),]<-''
          if (nrow(a1) > nrow(b1)) b1[(nrow(b1) + 1):nrow(a1),]<-''
          gg <- cbind(a1,b1)
          colnames(gg)<-paste(c(rep(a@name,ncol(a1)),rep(b@name,ncol(a1))),rep('.',ncol(a1)*2),rep(colnames(slot(a,sl))),sep='')
          cat(sl,':\n')
          print(gg)
      }
    }
    cat('Name: ',a@name,', ',b@name,'\n')
    if_print_one(a,b,'type')
    #if_print_one(a,b,'description')
    if_print_one(a,b,'cap2act')
    #if_print_vector(a,b,'region')
    for(i in technology_data_frame()) if_print_data_frame(a,b,i)
}

