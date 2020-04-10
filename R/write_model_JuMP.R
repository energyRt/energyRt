##################################################################################################################################    
# Julia JuMP part
##################################################################################################################################    
.write_model_JuMP <- function(arg, scen) {
  run_code <- scen@source[["JuMP"]]
  run_codeout <- scen@source[["JuMPOutput"]]
  dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
  zz_data_julia <- file(paste(arg$dir.result, '/data.jl', sep = ''), 'w')
  zz_data_constr <- file(paste(arg$dir.result, '/inc_constraints.jl', sep = ''), 'w')
  
  .write_inc_solver(scen, arg, "using Cbc\nset_optimizer(model, Cbc.Optimizer)\n", '.jl', 'Cbc')
  datas <- list()
  for (i in names(scen@modInp@parameters)) {
    tmp <- getParameterData(scen@modInp@parameters[[i]])
    colnames(tmp) <- gsub('[.]1', 'p', colnames(tmp))
    if (scen@modInp@parameters[[i]]@type != 'multi') {
      datas[[i]] <- tmp
    } else {
      tmp <- getParameterData(scen@modInp@parameters[[i]])
      datas[[paste0(i, 'Up')]] <- tmp[tmp$type == 'up', colnames(tmp) != 'type']
      datas[[paste0(i, 'Lo')]] <- tmp[tmp$type == 'lo', colnames(tmp) != 'type']
    }
  }
  save('datas', file = paste0(arg$dir.result, "data.RData"))
  
  cat('using RData\nusing DataFrames\ndatas = load("data.RData")\n', sep = '\n', file = zz_data_julia)
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      cat(energyRt:::.toJuliaHead(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_julia)
      cat(paste0('println("', i, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_julia)
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
      cat(energyRt:::.equation.from.gams.to.julia(eqt$equation), sep = '\n', file = zz_data_constr)
      cat(paste0('println("', eqt$equationDeclaration2Model, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_constr)
    }
  }
  close(zz_data_constr)
  cat(run_code[-(1:nobj)], sep = '\n', file = zz_mod)
  close(zz_mod)
  zz_modout <- file(paste(arg$dir.result, '/output.jl', sep = ''), 'w')
  cat(run_codeout, sep = '\n', file = zz_modout)
  close(zz_modout)
  .add_five_includes(arg, scen, ".jl")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'julia energyRt.jl'
  scen@solver$code <- c('energyRt.jl', 'output.jl', 'inc_constraints.jl', 'inc_solver.jl')
  
  scen
}
