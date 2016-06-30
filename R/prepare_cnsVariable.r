# Prepare cnsVariable for compilation
prepare.cnsVariable <- function(vrb, level = NULL, prefix = '') {
  clearCode <- list()
  sum_set <- rep(NA, length(vrb@ext_set))
  rename_col <- vrb@set_name
  rename_col[] <- NA
  names(rename_col) <- vrb@set_name
  ext_code <- '\n + '
  if (length(vrb@set) > 0) {
    for(i in 1:length(vrb@set)) {
        zz <- prepare(vrb@set[[i]], level, prefix)
        sum_set[i] <- zz$set$gams_alias
        clearCode[[i]] <- zz$clearCode
        vrb@set[[i]] <- zz$set
        rename_col[zz$set$name] <- zz$set$gams_alias
    }
    ext_code <- paste(ext_code, 'sum((', paste(rename_col[!is.na(rename_col)], collapse = ', '), '), ', sep = '')
  }
  # External set must be prepared from prepare.constrain
  if (length(vrb@ext_set) > 0) {
    for(i in 1:length(vrb@ext_set)) {
      if (is.null(vrb@ext_set[[i]]$gams_alias)) stop('External set do not progress')
        rename_col[vrb@ext_set[[i]]$name] <- vrb@ext_set[[i]]$gams_alias
    }
  }
  ext_code <- paste(ext_code, vrb@parameter, sep = '')
  if (length(rename_col) != 0) ext_code <- paste(ext_code, '(', paste(rename_col, collapse = ', '), ')', sep = '')
  if (!is.null(vrb@value) && ncol(vrb@value) != 1) {
    cln <- colnames(vrb@value)[-ncol(vrb@value)]
    cln <- c(rename_col[cln], 'value')
    colnames(vrb@value) <- cln
  }
  zz <- data_frame_to_gams_parameter(vrb@value, vrb@default, paste(prefix, 'pr', sep = ''))
  clearCode[[length(clearCode) + 1]] <- zz$clearCode
  ext_code <- paste(ext_code, '*', zz$ext_code)
  if (length(vrb@set) != 0) ext_code <- paste(ext_code, ')', sep = '')
  list(ext_code = ext_code, clearCode = clearCode)
}
