#################################################################################################################################
# Julia JuMP part
#################################################################################################################################
.write_model_JuMP <- function(arg, scen) {
  run_code <- scen@source[["JuMP"]]
  run_codeout <- scen@source[["JuMPOutput"]]
  dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
  zz_data_julia <- file(paste(arg$dir.result, '/data.jl', sep = ''), 'w')
  zz_data_constr <- file(paste(arg$dir.result, '/inc_constraints.jl', sep = ''), 'w')

  .write_inc_solver(scen, arg, "using Cbc\nset_optimizer(model, Cbc.Optimizer)\n", '.jl', 'Cbc')
  dat <- list()
  for (i in names(scen@modInp@parameters)) {
    tmp <- getParameterData(scen@modInp@parameters[[i]])
    colnames(tmp) <- gsub('[.]1', 'p', colnames(tmp))
    # if (!is.null(scen@modInp@parameters[[i]]@data$year)) {
    #   scen@modInp@parameters[[i]]@data$year <- 
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$year))
    # }
    # if (!is.null(scen@modInp@parameters[[i]]@data$yearp)) {
    #   scen@modInp@parameters[[i]]@data$yearp <- 
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$yearp))
    # }
    if (scen@modInp@parameters[[i]]@type != 'multi') {
      dat[[i]] <- tmp
    } else {
      tmp <- getParameterData(scen@modInp@parameters[[i]])
      dat[[paste0(i, 'Up')]] <- tmp[tmp$type == 'up', colnames(tmp) != 'type']
      dat[[paste0(i, 'Lo')]] <- tmp[tmp$type == 'lo', colnames(tmp) != 'type']
    }
  }
  
  save('dat', file = paste0(arg$dir.result, "data.RData"))

  cat('using RData\nusing DataFrames\ndt = load("data.RData")["dat"]\n', sep = '\n', file = zz_data_julia)
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

# ##################################################################################################################################    
# # Julia JuMP part - with function in julia
# ##################################################################################################################################    
# .write_model_JuMP <- function(arg, scen) {
#   run_code <- scen@source[["JuMP"]]
#   run_codeout <- scen@source[["JuMPOutput"]]
#   dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
#   zz_data_julia <- file(paste(arg$dir.result, '/data.jl', sep = ''), 'w')
#   zz_data_constr <- file(paste(arg$dir.result, '/inc_constraints.jl', sep = ''), 'w')
# 
#   .write_inc_solver(scen, arg, "using Cbc\nset_optimizer(model, Cbc.Optimizer)\n", '.jl', 'Cbc')
# 
#   .write_julia_functions(zz_data_julia)
#   dat <- list()
#   for (i in names(scen@modInp@parameters)) {
#     tmp <- getParameterData(scen@modInp@parameters[[i]])
#     colnames(tmp) <- gsub('[.]1', 'p', colnames(tmp))
#     if (scen@modInp@parameters[[i]]@type != 'multi') {
#       dat[[i]] <- tmp
#     } else {
#       tmp <- getParameterData(scen@modInp@parameters[[i]])
#       dat[[paste0(i, 'Up')]] <- tmp[tmp$type == 'up', colnames(tmp) != 'type']
#       dat[[paste0(i, 'Lo')]] <- tmp[tmp$type == 'lo', colnames(tmp) != 'type']
#     }
#   }
#   save(dat, file = paste0(arg$dir.result, "data.RData"))
# 
#   cat('using RData\nusing DataFrames\ndt = load("data.RData")["dat"]\n', sep = '\n', file = zz_data_julia)
#   for (j in c('set', 'map', 'simple', 'multi')) {
#     for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
#       cat(energyRt:::.toJuliaHead(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_julia)
#       # cat(toJuliaHead(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_julia)
#       # cat(paste0('println("', i, '... done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_julia)
#     }
#   }
#   close(zz_data_julia)
#   # Add constraint
#   zz_mod <- file(paste(arg$dir.result, '/energyRt.jl', sep = ''), 'w')
#   nobj <- grep('^[@]objective', run_code)[1] - 1
#   cat(run_code[1:nobj], sep = '\n', file = zz_mod)
#   if (length(scen@modInp@gams.equation) > 0) {
#     for (i in seq_along(scen@modInp@gams.equation)) {
#       eqt <- scen@modInp@gams.equation[[i]]
#       cat(energyRt:::.equation.from.gams.to.julia(eqt$equation), sep = '\n', file = zz_data_constr)
#       cat(paste0('println("', eqt$equationDeclaration2Model, '... done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_constr)
#     }
#   }
#   close(zz_data_constr)
#   cat(run_code[-(1:nobj)], sep = '\n', file = zz_mod)
#   close(zz_mod)
#   zz_modout <- file(paste(arg$dir.result, '/output.jl', sep = ''), 'w')
#   cat(run_codeout, sep = '\n', file = zz_modout)
#   close(zz_modout)
#   .add_five_includes(arg, scen, ".jl")
#   if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
#     scen@solver$cmdline <- 'julia energyRt.jl'
#   scen@solver$code <- c('energyRt.jl', 'output.jl', 'inc_constraints.jl', 'inc_solver.jl')
# 
#   scen
# }
# 
# .write_julia_functions <- function(f) {
#   cat("function df2dict(x)\n", file = f)
#   # cat("# df - data frame\n", file = f)
#   cat("# the function reads df line by line and creates a dictionary or a tuple\n", file = f)
#   cat("   print(x)\n", file = f)
#   cat("   df = dt[x]\n", file = f)
#   cat("   nrows, ncols = size(df)\n", file = f)
#   cat("   if nrows == 0\n", file = f)
#   cat("      return Dict()\n", file = f)
#   cat("   end\n", file = f)
#   cat("   if any(names(df) .== :year)\n", file = f)
#   cat("      if isa(df.year[1], Number)\n", file = f)
#   cat("         df.year = string.(convert.(Int64, df.year))\n", file = f)
#   cat("      end\n", file = f)
#   cat("   end\n", file = f)
#   cat("   if any(names(df) .== :yearp)\n", file = f)
#   cat("      if isa(df.yearp[1], Number)\n", file = f)
#   cat("         df.yearp = string.(convert.(Int64, df.yearp))\n", file = f)
#   cat("      end\n", file = f)
#   cat("   end\n", file = f)
#   cat("   if ncols == 1\n", file = f)
#   cat("      return(Set(Symbol.(df[:,1])))\n", file = f)
#   cat("   end\n", file = f)
#   cat("   for row in 1:nrows\n", file = f)
#   cat("      t = () # empty tuple\n", file = f)
#   cat("      for col in 1:ncols\n", file = f)
#   cat("         if isa(df[row,col], String)\n", file = f)
#   cat("            t = (t..., Symbol(df[row,col])) # replaces the tuple with longer one\n", file = f)
#   cat("         elseif col == ncols\n", file = f)
#   cat("            t = Dict([(t, df[row,col])])\n", file = f)
#   cat("         else\n", file = f)
#   cat('            error("Multiple numeric columns")\n', file = f)
#   cat("         end\n", file = f)
#   cat("      end\n", file = f)
#   cat("      if row == 1\n", file = f)
#   cat("         global obj = [deepcopy(t)]\n", file = f)
#   cat("      else\n", file = f)
#   cat("         push!(obj, t)\n", file = f)
#   cat("      end\n", file = f)
#   cat("   end\n", file = f)
#   cat("   return(obj)\n", file = f)
#   cat("end\n", file = f)
# }
