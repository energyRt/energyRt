##################################################################################################################################    
# GLPK & CBC part
##################################################################################################################################    
.solver_run_GLPK_CBC <- function(arg, scen) { 
  run_code <- scen@source[["GLPK"]]
  dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
  file_w <- c()
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      file_w <- c(file_w, energyRt:::.sm_to_glpk(scen@modInp@parameters[[i]]))
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
  }
  
  ### FUNC GLPK 
  zz <- file(paste(arg$dir.result, '/energyRt.mod', sep = ''), 'w')
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
  zz <- file(paste(arg$dir.result, '/energyRt.dat', sep = ''), 'w') 
  cat('set FORIF := FORIFSET;\n', sep = '\n', file = zz)
  cat(file_w, sep = '\n', file = zz) 
  cat('end;', '', sep = '\n', file = zz) 
  close(zz)
  .add_five_includes(arg, scen, NULL)
  
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == ''){
    if (scen@solver$lang == 'GLPK') {
      scen@solver$cmdline <- 'glpsol.exe -m energyRt.mod -d energyRt.dat'
    } else {
      scen@solver$cmdline <- 'cbc energyRt.mod%energyRt.dat -solve'
    }
  }
  scen
}