##################################################################################################################################    
# GAMS part
##################################################################################################################################    
.write_model_GAMS <- function(arg, scen, trim = FALSE) {
  if (trim) scen <- fold(scen)
  .write_inc_solver(scen, arg, 'option lp = cplex;', '.gms', 'cplex')
  if (is.null(scen@status$fullsets)) stop('scen@status$fullsets not found')
  if (!scen@status$fullsets) {
    .toGams <- function(x) .toGams0(x, TRUE)
  } else .toGams <- function(x) .toGams0(x, FALSE)
  run_code <- scen@source[["GAMS"]]
  

  # For downsize
  fdownsize <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)]
  for (nn in fdownsize) {
    rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
    if (scen@modInp@parameters[[nn]]@type == 'multi') {
      uuu <- paste0(nn, c('Lo', 'Up'))
    } else uuu <- nn
    for (yy in uuu) {
      templ <- paste0('(^|[^[:alnum:]])', yy, '[(]')
      if (any(grep('^pCns', nn))) {
        for (www in seq_along(scen@modInp@gams.equation)) {
          mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
          if (any(mmm)) {
            scen@modInp@gams.equation[[www]]$equation[mmm] <- sapply(strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], yy), .rem_col, yy, rmm)
          }
        }
      } else if (any(grep('^pCosts', nn))) {
        for (www in seq_along(scen@modInp@costs.equation)) {
          mmm <- grep(templ, scen@modInp@costs.equation[www])
          if (any(mmm)) {
            scen@modInp@costs.equation[www][mmm] <- sapply(strsplit(scen@modInp@costs.equation[www][mmm], yy), .rem_col, yy, rmm)
          }
        }
      } else {
        mmm <- grep(templ, run_code)
        if (any(mmm)) run_code[mmm] <- sapply(strsplit(run_code[mmm], yy), .rem_col, yy, rmm)
      }
    }
  }
  
  if (is.null(scen@solver$export_format))
    scen@solver$export_format <- 'gms'
  if (is.null(scen@solver$import_format)) {
    scen@solver$import_format <- 'gms'
  } else {
    scen@solver$import_format <- 'gdx'
    scen@source[['GAMS_output']] <- 'execute_unload "output/output.gdx"'
  }
  dir.create(paste(arg$tmp.dir, '/input', sep = ''), showWarnings = FALSE)
  dir.create(paste(arg$tmp.dir, '/output', sep = ''), showWarnings = FALSE)
  zz_output <- file(paste(arg$tmp.dir, '/output.gms', sep = ''), 'w')
  cat(scen@source[['GAMS_output']], sep = '\n', file = zz_output)
  close(zz_output)  
  zz_data_gms <- file(paste(arg$tmp.dir, '/data.gms', sep = ''), 'w')
  if (scen@solver$export_format == 'gdx') {
    if (!scen@status$fullsets)
      stop('for export_format = "gdx", interpolation parameter fullsets must be TRUE')
    # Generate gdx
    .write_gdx_list(dat = .get_scen_data(scen), 
                    gdxName = paste0(arg$tmp.dir, 'input/data.gdx'))
    
    # Add gdx import
    cat('$gdxin input/data.gdx\n', file = zz_data_gms)
    for (j in c('set', 'map', 'simple', 'multi')) {
      for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j && 
      		(is.null(scen@modInp@parameters[[i]]@misc$weather) || !scen@modInp@parameters[[i]]@misc$weather)) {
        if (scen@modInp@parameters[[i]]@type != 'multi') {
          cat(paste0('$loadm ', i, '\n'), file = zz_data_gms)
        } else {
          cat(paste0('$loadm ', i, 'Lo\n'), file = zz_data_gms)
          cat(paste0('$loadm ', i, 'Up\n'), file = zz_data_gms)
        }
      }
    }
    cat('$gdxin\n', file = zz_data_gms)
  } else if (arg$n.threads == 1) {
    for (j in c('set', 'map', 'simple', 'multi')) {
      for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
        zz_data_tmp <- file(paste(arg$tmp.dir, '/input/', i, '.gms', sep = ''), 'w')
        cat(.toGams(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_tmp)
        close(zz_data_tmp)
        cat(paste0('$include input/', i, '.gms\n'), file = zz_data_gms)
      }
    }
  } else {
    for (j in c('set', 'map', 'simple', 'multi')) {
      for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
        cat(paste0('$include input/', i, '.gms\n'), file = zz_data_gms)
      }
    }    
    .write_multi_threads(arg, scen, func = .toGams, type = 'gms')
  }
  close(zz_data_gms)    
  ### Model code to text
  .generate_gpr_gams_file(arg$tmp.dir)
  zz <- file(paste(arg$tmp.dir, '/energyRt.gms', sep = ''), 'w')
  zz_constrains <- file(paste(arg$tmp.dir, '/inc_constraints.gms', sep = ''), 'w')
  cat(run_code[1:grep('[$]include[[:space:]]*data.gms', run_code)], sep = '\n', file = zz)
  # Add parameter constraint declaration
  if (length(scen@modInp@gams.equation) > 0) {
    mps_name <- grep('^[m]Cns', names(scen@modInp@parameters), value = TRUE)
    mps_name_def <- c('set ', paste0(mps_name, '(', sapply(scen@modInp@parameters[mps_name], 
                                                           function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
    pps_name <- grep('^[p]Cns', names(scen@modInp@parameters), value = TRUE)
    pps_name_def <- c('parameter ', paste0(pps_name, '(', sapply(scen@modInp@parameters[pps_name], 
                                                                 function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
    pps_name_def <- gsub('[(][)]', '', pps_name_def)
    if (length(mps_name) != 0) {
      cat(mps_name_def, sep = '\n', file = zz_constrains)
      cat('\n', sep = '\n', file = zz_constrains)
    }
    if (length(pps_name) != 0) {
      cat(pps_name_def, sep = '\n', file = zz_constrains)
      cat('\n', sep = '\n', file = zz_constrains)
    }
  }
  
  # Add parameter costs declaration
  {
    zz_costs <- file(paste(arg$tmp.dir, '/inc_costs.gms', sep = ''), 'w')
    mps_name <- grep('^[m]Costs', names(scen@modInp@parameters), value = TRUE)
    mps_name_def <- c('set ', paste0(mps_name, '(', sapply(scen@modInp@parameters[mps_name], 
                         function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
    pps_name <- grep('^[p]Costs', names(scen@modInp@parameters), value = TRUE)
    pps_name_def <- c('parameter ', paste0(pps_name, '(', sapply(scen@modInp@parameters[pps_name], 
                      function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
    pps_name_def <- gsub('[(][)]', '', pps_name_def)
    if (length(mps_name) != 0) {
      cat(mps_name_def, sep = '\n', file = zz_costs)
      cat('\n', sep = '\n', file = zz_costs)
    }
    if (length(pps_name) != 0) {
      cat(pps_name_def, sep = '\n', file = zz_costs)
      cat('\n', sep = '\n', file = zz_costs)
    }
    cat(c('Equation\neqTotalUserCosts(region, year)\n;\n', scen@modInp@costs.equation), file = zz_costs)
  }
  
  # Add constraint equation 
  if (length(scen@modInp@gams.equation) > 0) {
    # Declaration
    cat('equation', sapply(scen@modInp@gams.equation, function(x) x$equationDeclaration), ';', '', sep = '\n', file = zz_constrains) 
    # Body equation
    cat(sapply(scen@modInp@gams.equation, function(x) x$equation), '', sep = '\n', file = zz_constrains) 
  }
  if (!is.null(scen@model@misc$additionalEquationGAMS)) {
    cat(scen@model@misc$additionalEquationGAMS$code, sep = '\n', file = zz_constrains)
  }
  cat(run_code[(grep('[$]include[[:space:]]*data.gms', run_code) + 1):length(run_code)], sep = '\n', file = zz)
  
  # Add constraint equation to model declaration
  if (!is.null(scen@model@misc$additionalEquationGAMS)) {
    cat(scen@model@misc$additionalEquationGAMS$code, sep = '\n', file = zz_constrains)
  }
  close(zz)
  close(zz_constrains)
  close(zz_costs)
  .write_inc_files(arg, scen, ".gms")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'gams energyRt.gms'
  scen@solver$code <- c('energyRt.gms', 'output.gms', 'inc_constraints.gms', 'inc_solver.gms')
  scen
}

.check_miss_rem_col <- function(x, nn) {
  kll <- rev(grep('[[:alnum:]]$', x))
  kll <- kll[kll != length(x)]
  if (length(kll) != 0) {
    for (i in kll)
      x[i] <- paste0(x[i], nn, x[i + 1])
    x <- x[-(kll + 1)]
  }
  x
}
.rem_col <- function(x, nn, rmm) {
  x <- .check_miss_rem_col(x, nn)
  for (i in 2:length(x)) {
    tt <- gsub('(^.|[)].*)', '', x[i])  
    til <- substr(x[i], nchar(tt) + 3, nchar(x[i]))   
    mm <- strsplit(tt, '[,]')[[1]][-rmm]
    if (length(mm) == 0) x[i] <- paste0(nn, til) else {
      x[i] <- paste0(nn, '(', paste0(mm, collapse = ', '), ')', til)
    }
  }
  return(paste0(x, collapse = ''))
}



.rem_col_sq <- function(x, nn, rmm) {
  x <- .check_miss_rem_col(x, nn)
  for (i in 2:length(x)) {
    tt <- gsub('(^.|[]].*)', '', x[i])  
    til <- substr(x[i], nchar(tt) + 3, nchar(x[i]))   
    mm <- strsplit(tt, '[,]')[[1]][-rmm]
    if (length(mm) == 0) x[i] <- paste0(nn, til) else {
      x[i] <- paste0(nn, '[', paste0(mm, collapse = ', '), ']', til)
    }
  }
  return(paste0(x, collapse = ''))
}

.rem_col_fg <- function(x, nn, rmm) {
  x <- .check_miss_rem_col(x, nn)
  for (i in 2:length(x)) {
    tt <- gsub('(^.|[}].*)', '', x[i])  
    til <- substr(x[i], nchar(tt) + 3, nchar(x[i]))   
    mm <- strsplit(tt, '[,]')[[1]][-rmm]
    if (length(mm) == 0) x[i] <- paste0(nn, til) else {
      x[i] <- paste0(nn, '{', paste0(mm, collapse = ', '), '}', til)
    }
  }
  return(paste0(x, collapse = ''))
}

