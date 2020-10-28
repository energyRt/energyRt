##################################################################################################################################    
# GLPK & CBC part
##################################################################################################################################    
.write_model_GLPK_CBC <- function(arg, scen) { 
  run_code <- scen@source[["GLPK"]]
  dir.create(paste(arg$tmp.dir, '/output', sep = ''), showWarnings = FALSE)
  file_w <- c()
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      file_w <- c(file_w, energyRt:::.sm_to_glpk(scen@modInp@parameters[[i]]))
    }
  }
    # For downsize
  fdownsize <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)]
  for (nn in fdownsize) {
    rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
    if (scen@modInp@parameters[[nn]]@type == 'multi') {
      uuu <- paste0(nn, c('Lo', 'Up'))
    } else uuu <- nn
    for (yy in uuu) {
      templ <- paste0('(^|[^[:alnum:]])', yy, '[[]')
      templ2 <- paste0('(^|[^[:alnum:]])', yy, '[{]')
      if (any(grep('^pCns', nn))) {
        for (www in seq_along(scen@modInp@gams.equation)) {
          mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
          if (any(mmm)) {
            scen@modInp@gams.equation[[www]]$equation[mmm] <- sapply(strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], yy), .rem_col_sq, yy, rmm)
          }
        }
      } else {
        mmm <- grep(templ, run_code)
        if (any(mmm)) run_code[mmm] <- sapply(strsplit(run_code[mmm], yy), .rem_col_sq, yy, rmm)
        mmm <- grep(templ2, run_code)
        if (any(mmm)) run_code[mmm] <- sapply(strsplit(run_code[mmm], yy), .rem_col_fg, yy, rmm)
      }
    }
  }
  
  # Add constraint
  if (length(scen@modInp@gams.equation) > 0) {
    add_eq <- sapply(scen@modInp@gams.equation, function(x) .equation.from.gams.to.glpk(x$equation)) 
    # Add additional maps
    mps_name <- grep('^[m]Cns', names(scen@modInp@parameters), value = TRUE)
    mps_name_def <- paste0('set ', mps_name, ' dimen ', sapply(scen@modInp@parameters[mps_name], function(x) length(x@dimSetNames)), ';')
    pps_name <- grep('^[p]Cns', names(scen@modInp@parameters), value = TRUE)
    pps_name_def <- paste0('param ', pps_name, ' {', sapply(scen@modInp@parameters[pps_name], function(x) paste0(x@dimSetNames, collapse = ', ')), '};')
    if (length(pps_name) == 0) pps_name_def <- character()
  }
  
  ### FUNC GLPK 
  zz <- file(paste(arg$tmp.dir, '/energyRt.mod', sep = ''), 'w')
  if (length(grep('^minimize', run_code)) != 1) stop('Errors in GLPK model')
  
  cat(run_code[1:(grep('22b584bd-a17a-4fa0-9cd9-f603ab684e47', run_code) - 1)], sep = '\n', file = zz)
  if (length(scen@modInp@gams.equation) > 0) {
    cat(mps_name_def, sep = '\n', file = zz)
    cat(pps_name_def, sep = '\n', file = zz)
    cat(add_eq, sep = '\n', file = zz)
  }
  cat(run_code[grep('22b584bd-a17a-4fa0-9cd9-f603ab684e47', run_code):(grep('^minimize', run_code) - 1)], sep = '\n', file = zz)
  cat(run_code[grep('^minimize', run_code):(grep('^end[;]', run_code) - 1)], 
      sep = '\n', file = zz)
  cat(run_code[grep('^end[;]', run_code):length(run_code)], sep = '\n', file = zz)
  close(zz)
  zz <- file(paste(arg$tmp.dir, '/energyRt.dat', sep = ''), 'w') 
  cat('set FORIF := FORIFSET;\n', sep = '\n', file = zz)
  cat(file_w, sep = '\n', file = zz) 
  cat('end;', '', sep = '\n', file = zz) 
  close(zz)
  .add_five_includes(arg, scen, NULL)
  
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == ''){
    if (toupper(scen@solver$lang) == 'GLPK') {
      scen@solver$cmdline <- 'glpsol -m energyRt.mod -d energyRt.dat'
    } else {
      scen@solver$cmdline <- 'cbc energyRt.mod%energyRt.dat -solve'
    }
  }
  scen@solver$code <- c('energyRt.mod')
  scen
}
