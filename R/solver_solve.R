write_model <- function(..., tmp.dir = NULL) {
  solver_solve(..., run = FALSE, tmp.dir = tmp.dir, write = TRUE)
}

solve_model <- function(tmp.dir, wait = TRUE, invisible = wait, ...) {
  solver_solve(scen = NULL, tmp.dir = tmp.dir, wait = wait, write = FALSE, invisible = invisible, ...)
}

solver_solve <- function(scen, ..., interpolate = FALSE, readresult = FALSE, 
                         write = TRUE, wait = TRUE, invisible = wait) { # - solves scen, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # solver = 'GAMS' use solver for model
  # tmp.dir - solver working directore
  # gamsCompileParameter, glpkCompileParameter, cbcCompileParameter - parameter for compiler (to cmd/sh)
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder before the run
  # show.output.on.console = FALSE & invisible = FALSE arg for command system
  # only.listing = FALSE (!depreciated?) generate only listing file (works for gams only)
  # readresult = TRUE read result
  # tmp.del delete results
  
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) arg$solver <- 'GAMS'
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  # if (is.null(arg$invisible)) arg$invisible <- FALSE
  arg$invisible <- invisible
  if (is.null(arg$only.listing)) arg$only.listing <- FALSE
  if (is.null(arg$tmp.del)) arg$tmp.del <- FALSE
  if (is.null(arg$readresult)) arg$readresult <- TRUE
  arg$write <- write
  arg$wait < wait
  if (is.null(arg$write)) arg$write <- TRUE
  if (is.null(arg$run)) arg$run <- TRUE
  # if (is.null(arg$onefile)) arg$onefile <- FALSE
  if (!is.null(arg$dir.result)) {
    warning("solve_model: parameter `dir.result` is depreciated, use `tmp.dir` instead")
    if (is.null(arg$tmp.dir)) {
      arg$tmp.dir <- arg$dir.result
    } else {
      stop("check `dir.result` and `tmp.dir` - only one should be used")
    }
  } else {
    # temporary - will be depreciated
    arg$dir.result <- arg$tmp.dir
  }
  
  if (is.null(scen)) {
    # browser()
    if (interpolate | arg$write) {
      stop("scenario object is not provided")
    }
  } else {
    scen@misc$dir.result <- arg$dir.result
    tmp_name <- scen@name
  }
  
  if (is.null(arg$tmp.dir)) {
    arg$tmp.dir <- file.path(file.path(getwd(), "solwork"), paste(arg$solver, tmp_name, #scen@name, 
          format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()), sep = "_"))
  }
  arg$dir.result <- arg$tmp.dir
  
  # interpolate 
  if (interpolate) scen <- energyRt::interpolate(scen, ...)
  
  # Misc
  solver_solver_time <- proc.time()[3]
  BEGINDR <- getwd()
  
  # Important miscs
  dir.create(arg$dir.result, recursive = TRUE, showWarnings = FALSE)
  if (arg$open.folder) shell.exec(arg$dir.result)
  # Check if gams (if it use) is available
  if (arg$solver == 'GAMS' && arg$run) {
    rs <- try(system('gams'))
    if (rs != 0) stop('GAMS is not found')
  }
  
  # Generate code for GAMS
  if (arg$write) {
    run_code <- scen@source[[arg$solver]] # energyRt::.modelCode[[arg$solver]]
  }
    if (arg$solver == 'GAMS') {
    ##################################################################################################################################    
    # GAMS part
    ##################################################################################################################################    
      if (arg$write) {  
      if (arg$echo) cat('Writing files: ')
      dir.create(paste(arg$dir.result, '/input', sep = ''), showWarnings = F)
      dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = F)
      zz_output <- file(paste(arg$dir.result, '/output.gms', sep = ''), 'w')
      cat(scen@source[['GAMS_output']], sep = '\n', file = zz_output)
      close(zz_output)  
      zz_data_gms <- file(paste(arg$dir.result, '/data.gms', sep = ''), 'w')
      file_w <- c()
      for (j in c('set', 'map', 'simple', 'multi')) {
        for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
          zz_data_tmp <- file(paste(arg$dir.result, '/input/', i, '.gms', sep = ''), 'w')
          cat(energyRt:::.toGams(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_tmp)
          close(zz_data_tmp) 
          cat(paste0('$include input/', i, '.gms\n'), file = zz_data_gms)
        }
      }
      close(zz_data_gms)    
      ### Model code to text
      .generate_gpr_gams_file(arg$dir.result)
      zz <- file(paste(arg$dir.result, '/energyRt.gms', sep = ''), 'w')
      cat(run_code[1:(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) - 1)], sep = '\n', file = zz)
      # Add parameter constraint declaration
      if (length(scen@modInp@gams.equation) > 0) {
      	mps_name <- grep('^[m]Cns', names(scen@modInp@parameters), value = TRUE)
      	mps_name_def <- c('set ', paste0(mps_name, '(', sapply(scen@modInp@parameters[mps_name], 
      		function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
      	pps_name <- grep('^[p]Cns', names(scen@modInp@parameters), value = TRUE)
      	pps_name_def <- c('parameter ', paste0(pps_name, '(', sapply(scen@modInp@parameters[pps_name], 
      		function(x) paste0(x@dimSetNames, collapse= ', ')), ')'), ';')
    	  if (length(mps_name) != 0) cat(mps_name_def, sep = '\n', file = zz)
      	if (length(pps_name) != 0) cat(pps_name_def, sep = '\n', file = zz)
      }
      cat(file_w, sep = '\n', file = zz)
      # Add constraint equation 
      if (length(scen@modInp@gams.equation) > 0) {
        # Declaration
        cat('equation', sapply(scen@modInp@gams.equation, function(x) x$equationDeclaration), ';', '', sep = '\n', file = zz) 
        # Body equation
        cat(sapply(scen@modInp@gams.equation, function(x) x$equation), '', sep = '\n', file = zz) 
      }
      if (!is.null(scen@model@misc$additionalEquationGAMS)) {
      	cat(scen@model@misc$additionalEquationGAMS$code, sep = '\n', file = zz)
      }
      cat(run_code[(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) + 1):
                     (grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) - 1)], sep = '\n', file = zz)
      
      # Add constraint equation to model declaration
      if (length(scen@modInp@gams.equation) > 0) {
      	cat(sapply(scen@modInp@gams.equation, function(x) x$equationDeclaration2Model), sep = '\n', file = zz) 
      }
      
      if (!is.null(scen@model@misc$additionalEquationGAMS)) 
        cat(scen@model@misc$additionalEquationGAMS$declaration, sep = '\n', file = zz)
      
      cat(run_code[(grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) + 1):
                     (grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) - 1)], sep = '\n', file = zz)
      cat(run_code[(grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) + 1):
                     (grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) - 1)], sep = '\n', file = zz)
      
      if (arg$only.listing) {
        cat('OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;\n',
            'OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;\n',
            'option iterlim = 0;\n', 
            'Solve energyRt minimizing vObjective using LP;\n$EXIT\n', file = zz, sep = '')
      }
      cat(scen@model@misc$includeBeforeSolve, sep = '\n', file = zz)
      cat(run_code[(grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) + 1):(
        grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) - 1)], sep = '\n', file = zz)
      cat(scen@model@misc$includeAfterSolve, sep = '\n', file = zz)
      cat(run_code[(min(c(grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) + 1, length(run_code)))):length(run_code)], sep = '\n', file = zz)
      close(zz)
      if (arg$echo) { 
        cat('', round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
        flush.console()
      }
    }

    ## Run model
    if (arg$run) {
      if(arg$echo) cat('GAMS time: ')
      gams_run_time <- proc.time()[3]
      tryCatch({
        setwd(arg$dir.result)
        if (.Platform$OS.type == "windows") {
          if (invisible) {cmd <- ""} else {cmd <- "cmd /k"}
          rs <- shell(paste(cmd, 'gams energyRt.gms', arg$gamsCompileParameter), 
                       invisible = arg$invisible, wait = wait
                       # show.output.on.console = arg$show.output.on.console
                      )
        } else {
          rs <- system(paste('gams energyRt.gms', arg$gamsCompileParameter), 
                       invisible = arg$invisible, wait = wait
                       # show.output.on.console = arg$show.output.on.console
                       )
        }
        setwd(BEGINDR)  
      }, interrupt = function(x) {
        if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
        setwd(BEGINDR)
        stop('Solver has been interrupted')
      }, error = function(x) {
        if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
        setwd(BEGINDR)
        stop(x)
      })    
      if (rs != 0) stop(paste('Solution error code', rs))
      if (arg$only.listing) {
        return(readLines(paste(arg$dir.result, '/energyRt.lst', sep = '')))
      }
      if(arg$echo) cat('', round(proc.time()[3] - gams_run_time, 2), 's\n', sep = '')
    }
  } else if (arg$solver == 'GLPK' || arg$solver == 'CBC') {  
    ##################################################################################################################################    
    # GLPK & CBC part
    ##################################################################################################################################    
    if (arg$write) {
      if (arg$echo) cat('Writing files: ')
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
    #cat(run_code[1:(grep('^minimize', run_code) - 1)], sep = '\n', file = zz)
    cat(run_code[grep('^minimize', run_code):(grep('^end[;]', run_code) - 1)], 
        sep = '\n', file = zz)
    cat(run_code[grep('^end[;]', run_code):length(run_code)], sep = '\n', file = zz)
    close(zz)
    zz <- file(paste(arg$dir.result, '/energyRt.dat', sep = ''), 'w') 
    cat('set FORIF := FORIFSET;\n', sep = '\n', file = zz)
    cat(file_w, sep = '\n', file = zz) 
    cat('end;', '', sep = '\n', file = zz) 
    close(zz)
    
    if (arg$echo) { 
      cat('', round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
      flush.console()
    }
    }
    if (arg$run) {
      if(arg$echo) cat('GLPK/MathProg time: ')
      tryCatch({
        setwd(arg$dir.result)
        if (.Platform$OS.type == "windows") {
          if (invisible) {cmd <- ""} else {cmd <- "cmd /k"}
          if (arg$solver  == 'GLPK') {
            rs <- system(paste(cmd, 'glpsol.exe -m energyRt.mod -d energyRt.dat --log output/log.csv', arg$glpkCompileParameter), 
                         invisible = arg$invisible, wait = wait,
                         show.output.on.console = arg$show.output.on.console)
          } else {
            rs <- system(paste(cmd, "cbc energyRt.mod%energyRt.dat -solve", arg$cbcCompileParameter, 
                               invisible = arg$invisible, wait = wait,
                               show.output.on.console = arg$show.output.on.console))
          }
        } else {
          if (arg$solver  == 'GLPK') {
            rs <- system(paste('glpsol -m energyRt.mod -d energyRt.dat --log output/log.csv', 
                               invisible = arg$invisible, wait = wait,
                               arg$glpkCompileParameter)) #, mustWork = TRUE)
          } else {
            rs <- system(paste("cbc energyRt.mod%energyRt.dat -solve", arg$cbcCompileParameter),
                         invisible = arg$invisible, wait = wait,
                         show.output.on.console = arg$show.output.on.console)
          }
        }
        setwd(BEGINDR)  
        if (rs != 0) stop(paste('Error in compilation with code', rs))
      }, interrupt = function(x) {
        if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
        setwd(BEGINDR)
        stop('Solver have been interrupted')
      }, error = function(x) {
        if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
        setwd(BEGINDR)
        stop(x)
      })
      
      
      if(arg$echo) cat('', round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
      if (any(grep('OPTIMAL.*SOLUTION FOUND', readLines(paste(arg$dir.result, '/output/log.csv', sep = ''))))) {
        z3 <- file(paste(arg$dir.result, '/output/pStat.csv', sep = ''), 'w')
        cat('value\n1.00\n', file = z3)
        close(z3)
      } else {
        z3 <- file(paste(arg$dir.result, '/output/pStat.csv', sep = ''), 'w')
        cat('value\n2.00\n', file = z3)
        close(z3)
      }
    }
  } else if (arg$solver == 'PYOMO') {
    ##################################################################################################################################    
    # PYOMO part
    ##################################################################################################################################    
    if (arg$write) {
      if (arg$echo) cat('Writing files: ')
      #dir.create(paste(arg$dir.result, '/input', sep = ''), showWarnings = F)
      #dir.create(paste(arg$dir.result, '/output', sep = ''), showWarnings = F)
      #zz_output <- file(paste(arg$dir.result, '/output.gms', sep = ''), 'w')
      #cat(scen@source[['GAMS_output']], sep = '\n', file = zz_output)
      #close(zz_output)  
      zz_data_pyomo <- file(paste(arg$dir.result, 'data.dat', sep = ''), 'w')
      file_w <- c()
      for (j in c('set', 'map', 'simple', 'multi')) {
        for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
          cat(energyRt:::.toPyomo(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_pyomo)
        }
      }
      close(zz_data_pyomo)    
    }
  } else if (arg$solver == 'JULIA') {
      ##################################################################################################################################    
      # Julia part
      ##################################################################################################################################    
      if (arg$write) {
        if (arg$echo) cat('Writing files: ')
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
      }
  } else stop('Unknown solver ', arg$solver) 
  if (readresult && arg$run) scen <- read_solution(scen)

  invisible(scen)
}
