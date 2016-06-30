# Prepare constrain for compilation
prepare.constrain <- function(cns, level) {
  clearCode <- list()
  if (gsub('[[:alpha:]][[:alnum:]_]*', '', cns@name) != '' || cns@name == '')
    stop('Incorect constrain names: "', cns@name, '"')
  set_name <- sapply(cns@set, function(x) x$name)
  set_alias <- sapply(cns@set, function(x) x$alias)
  names(cns@set) <- set_name
  eq_declare <- paste('eq', cns@name, sep = '')
  eq_code    <- ''
  rename_col <- rep(NA, length(set_name))
  names(rename_col) <- set_name
  if (length(cns@set) > 0) {
    for(i in 1:length(cns@set)) {
        zz <- prepare(cns@set[[i]], level, paste('al', cns@name, sep = ''))
        clearCode[[i]] <- zz$clearCode
        cns@set[[i]] <- zz$set
        rename_col[zz$set$name] <- zz$set$gams_alias
    }
    eq_declare <- paste(eq_declare, '(', paste(rename_col, collapse = ', '), ')', sep = '')
  }
  # Variable create
  if (length(cns@variable) == 0) stop('Constrain have not any variables')
  for(i in 1:length(cns@variable)) {
    gg <- cns@variable[[i]]
    # Define external (for variables set)
    if (length(gg@ext_set) != 0) {
      for(j in 1:length(gg@ext_set)) {
        if (all(gg@ext_set[[j]]$alias != set_alias)) stop('Unknown external set: "', gg@ext_set[[j]]$alias, '"')
        gg@ext_set[[j]]$gams_alias <- cns@set[set_alias == gg@ext_set[[j]]$alias][[1]]$gams_alias
      }
    }
    zz <- prepare(gg, level, paste('al', cns@name, i, sep = ''))
    clearCode[[length(clearCode) + 1]] <- zz$clearCode
    eq_code <- paste(eq_code, zz$ext_code)
  }
  # Parameter define
  if (!is.null(cns@value) && ncol(cns@value) != 1) {
    cln <- colnames(cns@value)[-ncol(cns@value)]
    cln <- c(rename_col[cln], 'value')
    colnames(cns@value) <- cln
  }
  zz <- data_frame_to_gams_parameter(cns@value, cns@default, paste('alPr', cns@name, sep = ''))
  clearCode[[length(clearCode) + 1]] <- zz$clearCode
  eq_code <- paste(eq_declare, '..\n', zz$ext_code, eq_code, sep = '')
  limtype <- c('=e=', '=l=', '=b=')[as.numeric(cns@type)]
  eq_code <- paste(eq_code, limtype, ' 0;', sep = '')
  list(eq_code = eq_code, eq_declare = eq_declare, clearCode = clearCode)
}