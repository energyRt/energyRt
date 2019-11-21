# Convert to new veresion
.export_to_r_code0 <- function(tmp) {
  nms <- slotNames(tmp)
  nms <- nms[!(nms %in% c("misc", ".S3Class"))]
  vector_to_string <- function(x) {
    if (any(class(x) == c('character', 'factors'))) {
      rs <- as.character(x)
      rs[is.na(x)] <- NA
      rs[!is.na(x)] <- paste0('"', rs[!is.na(x)], '"')
    } else {
      rs <- x
    }
    paste0('c('[length(rs) > 1], paste0(rs, collapse = ', '), ')'[length(rs) > 1])
  }
  out_buf <- NULL
  for (i in nms) {
    if (any(class(slot(tmp, i)) == 'data.frame')) {
      if (nrow(slot(tmp, i)) > 0 && any(!is.na(slot(tmp, i)))) {
        slt <- slot(tmp, i)[apply(!is.na(slot(tmp, i)), 1, any), apply(!is.na(slot(tmp, i)), 2, any), drop = FALSE]
        out_buf2 <- NULL
        for (j in colnames(slt)) {
          out_buf2 <- c(out_buf2, paste0(j, ' = ', vector_to_string(slt[[j]])))
        }
        out_buf <- c(out_buf, paste0('  ', i, ' = list('), 
                     paste0(paste0('    ', out_buf2), collapse = ',\n'), '  )')
        }
      } else if (any(class(slot(tmp, i)) == c('character', 'integer', 'numeric', 'logical', 'factor')) && length(slot(tmp, i)) > 0 && 
                 (length(slot(tmp, i)) != 1 || slot(tmp, i) != "")) {
        out_buf <- c(out_buf, paste0('  ', i, ' = ', vector_to_string(slot(tmp, i))))
      }
  }
  out_buf <- paste0(tmp@name, ' = new', toupper(substr(class(tmp)[1], 1, 1)), 
         substr(class(tmp)[1], 2, nchar(class(tmp)[1])), '(\n',
         paste0(out_buf, collapse = ',\n'), '\n);\n')
  #cat(out_buf,  sep = '\n')
  out_buf
}

.export_to_r_code <- function(tmp) {
    
}
  
