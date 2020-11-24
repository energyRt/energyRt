##################################################################################################################################    
# PYOMO part
##################################################################################################################################    
.write_model_PYOMO <- function(arg, scen) {
  AbstractModel <- any(grep('abstract', scen@solver$lang, ignore.case = TRUE))
  if (AbstractModel) {
    run_code <- scen@source[["PYOMOAbstract"]]
    run_codeout <- scen@source[["PYOMOAbstractOutput"]]
    
    # For downsize
    fdownsize <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)]
    for (nn in fdownsize) {
      rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
      if (scen@modInp@parameters[[nn]]@type == 'multi') {
        uuu <- paste0(nn, c('Lo', 'Up'))
      } else uuu <- nn
      for (yy in uuu) {
        templ <- paste0('(^|[^[:alnum:]])', yy, '[[]')
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
        }
      }
    }
      
  } else {
    run_code <- scen@source[["PYOMOConcrete"]]
    run_codeout <- scen@source[["PYOMOConcreteOutput"]]
      # For downsize
      fdownsize <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)]
      for (nn in fdownsize) {
        rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
        if (scen@modInp@parameters[[nn]]@type == 'multi') {
          uuu <- paste0(nn, c('Lo', 'Up'))
        } else uuu <- nn
        for (yy in uuu) {
          templ <- paste0('(^|[^[:alnum:]])', yy, '[.]get[(][(]')
          if (any(grep('^pCns', nn))) {
            for (www in seq_along(scen@modInp@gams.equation)) {
              mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
              if (any(mmm)) {
                scen@modInp@gams.equation[[www]]$equation[mmm] <- 
                  sapply(strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], paste0(yy, '[.]get[(][(]')), 
                .rem_col_pyomo_concrete, yy, rmm)
              }
            }
          } else {
            mmm <- grep(templ, run_code)
            if (any(mmm)) run_code[mmm] <- sapply(strsplit(run_code[mmm], paste0(yy, '[.]get[(][(]')), 
                                                  .rem_col_pyomo_concrete, yy, rmm)
          }
        }
      }
    
  }
  dir.create(paste(arg$tmp.dir, '/input', sep = ''), showWarnings = FALSE)
  dir.create(paste(arg$tmp.dir, '/output', sep = ''), showWarnings = FALSE)
  # if (!is.null(scen@solver$SQLite) && scen@solver$SQLite) {
  if (is.null(scen@solver$export_format)) {
    SQLite <- FALSE
  } else {
    SQLite <- tolower(scen@solver$export_format) == 'sqlite'
  }
  if (is.null(SQLite)) SQLite <- FALSE
  if (SQLite) {
    ### Generate SQLite file
    .write_sqlite_list(dat = .get_scen_data(scen), 
                    sqlFile = paste0(arg$tmp.dir, 'input/data.db'))
  }
  .write_inc_solver(scen, arg, "opt = SolverFactory('cplex');", '.py', 'cplex')
  # Add constraint
  zz_mod <- file(paste(arg$tmp.dir, '/energyRt.py', sep = ''), 'w')
  zz_constr <- file(paste(arg$tmp.dir, '/inc_constraints.py', sep = ''), 'w')
  npar <- grep('^##### decl par #####', run_code)[1]
  cat(run_code[1:npar], sep = '\n', file = zz_mod)
  if (!AbstractModel) {
    cat('exec(open("data.py").read())\n', file = zz_mod)
    zz_inp_file <- file(paste0(arg$tmp.dir, 'data.py'), 'w')
  }
  if (AbstractModel) {
    f1 <- grep('^mCns', names(scen@modInp@parameters), invert = TRUE)
    f2 <- grep('^mCns', names(scen@modInp@parameters))
    cat(.generate.pyomo.par(scen@modInp@parameters[f1]), sep = '\n', file = zz_mod)
    if (length(f2) > 0) 
      cat(.generate.pyomo.par(scen@modInp@parameters[f2]), sep = '\n', file = zz_constr)
  }
  if (AbstractModel)
    zz_data_pyomo <- file(paste(arg$tmp.dir, 'data.dat', sep = ''), 'w')
  file_w <- c()
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      if (AbstractModel) {
        cat(energyRt:::.toPyomoAbstractModel(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_pyomo)
      } else {
        if (any(grep('^.Cns', i))) {
          # if (!is.null(scen@solver$SQLite) && scen@solver$SQLite) {
          if (SQLite) {
              cat(.toPyomSQLite(scen@modInp@parameters[[i]]), sep = '\n', file = zz_constr)
            ## SQLite import
          } else cat(energyRt:::.toPyomo(scen@modInp@parameters[[i]]), sep = '\n', file = zz_constr)
        } else {
          if (SQLite) {
            cat(.toPyomSQLite(scen@modInp@parameters[[i]]), sep = '\n', file = zz_inp_file)
            ## SQLite import
          } else {
            tfl <- paste0('input/', scen@modInp@parameters[[i]]@name, '.py')
            cat(paste0('exec(open("', tfl, '").read())\n'), file = zz_inp_file)
            zz_tfl <- file(paste0(arg$tmp.dir, tfl), 'w')
            cat(energyRt:::.toPyomo(scen@modInp@parameters[[i]]), sep = '\n', file = zz_tfl)
            close(zz_tfl)
          }
        }
      }
    }
  }
  if (AbstractModel) close(zz_data_pyomo)    
  if (!AbstractModel && !SQLite) close(zz_inp_file)
  npar2 <- (grep('^model[.]obj ', run_code)[1] - 1)
  cat(run_code[npar:npar2], sep = '\n', file = zz_mod)
  if (length(scen@modInp@gams.equation) > 0) {
    cat('\n', file = zz_constr)
    cat('model.fornontriv = Var(domain = pyo.NonNegativeReals)\n', file = zz_constr)
    cat('model.eqnontriv = Constraint(rule = lambda model: model.fornontriv == 0)\n', file = zz_constr)
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      if (AbstractModel) {
        cat(energyRt:::.equation.from.gams.to.pyomo.AbstractModel(eqt$equation), sep = '\n', file = zz_constr)
      } else {
        cat(energyRt:::.equation.from.gams.to.pyomo(eqt$equation), sep = '\n', file = zz_constr)
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
  close(zz_constr)
  zz_modout <- file(paste(arg$tmp.dir, '/output.py', sep = ''), 'w')
  cat(run_codeout, sep = '\n', file = zz_modout)
  close(zz_modout)
  .write_inc_files(arg, scen, ".py")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'python energyRt.py'
  scen@solver$code <- c('energyRt.py', 'output.py', 'inc_constraints.py', 'inc_solver.py')
  scen
}


.rem_col_pyomo_concrete <- function(x, nn, rmm) {
  for (i in 2:length(x)) {
    tt <- gsub('[)][)].*', '', x[i])  
    til <- substr(x[i], nchar(tt) + 3, nchar(x[i]))   
    mm <- strsplit(tt, '[,]')[[1]][-rmm]
    if (length(mm) == 0) x[i] <- paste0(nn, til) else {
      x[i] <- paste0(nn, '.get((', paste0(mm, collapse = ', '), '))', til)
    }
  }
  return(paste0(x, collapse = ''))
}


