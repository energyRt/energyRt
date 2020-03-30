##################################################################################################################################    
# PYOMO part
##################################################################################################################################    
.solver_run_PYOMO <- function(arg, scen) {
  AbstractModel <- any(grep('abstract', scen@solver$lang, ignore.case = TRUE))
  if (AbstractModel) {
    run_code <- scen@source[["PYOMOAbstract"]]
  } else {
    run_code <- scen@source[["PYOMOConcrete"]]
  }
  dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = FALSE)
  # Add constraint
  zz_mod <- file(paste(arg$dir.result, '/energyRt.py', sep = ''), 'w')
  npar <- grep('^##### decl par #####', run_code)[1]
  cat(run_code[1:npar], sep = '\n', file = zz_mod)
  if (AbstractModel) 
    cat(.generate.pyomo.par(scen@modInp@parameters), sep = '\n', file = zz_mod)
  if (AbstractModel)
    zz_data_pyomo <- file(paste(arg$dir.result, 'data.dat', sep = ''), 'w')
  file_w <- c()
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      if (AbstractModel) {
        cat(energyRt:::.toPyomoAbstractModel(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_pyomo)
      } else {
        cat(energyRt:::.toPyomo(scen@modInp@parameters[[i]]), sep = '\n', file = zz_mod)
      }
    }
  }
  if (AbstractModel) close(zz_data_pyomo)    
  npar2 <- (grep('^model[.]obj ', run_code)[1] - 1)
  cat(run_code[npar:npar2], sep = '\n', file = zz_mod)
  if (length(scen@modInp@gams.equation) > 0) {
    cat('\n', file = zz_mod)
    cat('model.fornontriv = Var(domain = pyo.NonNegativeReals)\n', file = zz_mod)
    cat('model.eqnontriv = Constraint(rule = lambda model: model.fornontriv == 0)\n', file = zz_mod)
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      if (AbstractModel) {
        cat(energyRt:::.equation.from.gams.to.pyomo.AbstractModel(eqt$equation), sep = '\n', file = zz_mod)
      } else {
        cat(energyRt:::.equation.from.gams.to.pyomo(eqt$equation), sep = '\n', file = zz_mod)
      }
    }
  }
  cat(run_code[-(1:npar2)], sep = '\n', file = zz_mod)
  if (AbstractModel) {
    cat('f = open("output/raw_data_set.csv","w");\n', file = zz_mod)
    cat("f.write('set,value\\n')\n", file = zz_mod)
    for (tmp in scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')]) 
      cat("for i in instance.", tmp@name, ":\n    f.write('", tmp@name, ",' + str(i) + '\\n')\n", sep = '', file = zz_mod)
    cat('f.close()\n', file = zz_mod)
  }
  close(zz_mod)
  .add_five_includes(arg, scen, ".py")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'python energyRt.py'
  scen
}