# Create cnsVariable
create_cnsVariable <- function(parameter, ext_set = list(), set = list(), default = 1, create_value = TRUE) {
  # Calculate set that must be used
  must_set <- get_parameter_set_name(parameter)
  if (length(ext_set) > 0) {
    ext_set_nm <- sapply(ext_set, function(x) x$name)
    names(ext_set) <- ext_set_nm
    ext_set_nm <- ext_set_nm[ext_set_nm %in% must_set]
    ext_set <- ext_set[ext_set_nm]
  } else ext_set_nm <- c()
  msnot <- must_set[!(must_set %in% ext_set_nm)]
  set_nm <- sapply(set, function(x) x$name)
  names(set) <- set_nm
  if (any(set_nm %in% ext_set_nm))
      stop('Set external/internal conflict, repeat set: "',
          paste(set_nm[set_nm %in% ext_set_nm], collapse = '", "'), '"')
  if (any(!(set_nm %in% msnot)))
      stop('Excessive set: "',paste(set_nm[!(set_nm %in% msnot)], collapse = '", "'), '"')
  msnot <- msnot[!(msnot %in% set_nm)]
  for(i in msnot) set[[i]] <- create_set(i)
  vrb <- new('cnsVariable')
  vrb@parameter <- parameter
  vrb@ext_set   <- ext_set
  vrb@set       <- set
  vrb@default   <- default
  if (create_value) vrb <- create_data_frame(vrb)
  vrb@set_name <- must_set
  vrb
}

