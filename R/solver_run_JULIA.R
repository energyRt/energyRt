##################################################################################################################################    
# Julia part
##################################################################################################################################    
.solver_run_JULIA <- function(arg, scen) {
  run_code <- scen@source[["JULIA"]]
  dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
  zz_data_julia <- file(paste(arg$dir.result, '/data.jl', sep = ''), 'w')
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      cat(energyRt:::.toJulia(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_julia)
      cat(paste0('println("', i, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_julia)
      cat(paste0('println(f, "', i, ' done ", Dates.format(now(), "HH:MM:SS"))\n\n'), file = zz_data_julia)
    }
  }
  close(zz_data_julia)   
  # Add constraint
  zz_mod <- file(paste(arg$dir.result, '/energyRt.jl', sep = ''), 'w')
  nobj <- grep('^[@]objective', run_code)[1] - 1
  cat(run_code[1:nobj], sep = '\n', file = zz_mod)
  if (length(scen@modInp@gams.equation) > 0) {
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      cat(energyRt:::.equation.from.gams.to.julia(eqt$equation), sep = '\n', file = zz_mod)
      cat(paste0('println("', eqt$equationDeclaration2Model, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_mod)
      cat(paste0('println(f, "', eqt$equationDeclaration2Mode, ' done ", Dates.format(now(), "HH:MM:SS"))\n\n'), file = zz_mod)
    }
  }
  cat(run_code[-(1:nobj)], sep = '\n', file = zz_mod)
  close(zz_mod)
  if (arg$echo) {
    cat('', round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
    flush.console()
  }
  .add_five_includes(arg, scen, ".jl")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'julia energyRt.jl'
}
