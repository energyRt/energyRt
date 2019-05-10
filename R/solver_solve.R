solver_solve <- function(scenario, ..., interpolate = FALSE, readresult = FALSE) { # - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # solver = 'GAMS' use solver for model
  # dir.result - dir for solver work
  # gamsCompileParameter, glpkCompileParameter, cbcCompileParameter - parameter for compiler (to cmd/sh)
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder befor run
  # show.output.on.console = FALSE & invisible = FALSE arg for command system
  # only.listing = FALSE generate only listing file (work only for gams)
  # readresult = TRUE read result
  # tmp.del need delete result in case of emergency
  
  
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) arg$solver <- 'GAMS'
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  if (is.null(arg$invisible)) arg$invisible <- FALSE
  if (is.null(arg$only.listing)) arg$only.listing <- FALSE
  if (is.null(arg$tmp.del)) arg$tmp.del <- FALSE
  if (is.null(arg$readresult)) arg$readresult <- TRUE
  if (is.null(arg$dir.result)) {
    arg$dir.result <- file.path(file.path(getwd(), "solwork"), paste(arg$solver, scenario@name, 
          format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()), sep = "_"))
  }
  
  # interpolate if need  
  if (interpolate) scenario <- energyRt::interpolate(scenario, ...)
  scenario@misc$dir.result <- arg$dir.result
  
  # Misc
  solver_solver_time <- proc.time()[3]
  
  # Important miscs
  dir.create(arg$dir.result, recursive = TRUE)
  if (arg$open.folder) shell.exec(arg$dir.result)
  # Check if gams (if it use) is available
  if (arg$solver == 'GAMS') {
    rs <- try(system('gams'))
    if (rs != 0) stop('There is no gams')
  }
  
  # Generate code for GAMS
  run_code <- energyRt::modelCode[[arg$solver]][[1]]
  if (arg$solver == 'GAMS') {
    ##################################################################################################################################    
    # GAMS part
    ##################################################################################################################################    
    file_w <- c()
    for (j in c('set', 'map', 'simple', 'multi')) {
      for(i in names(scenario@modInp@parameters)) if (scenario@modInp@parameters[[i]]@type == j) {
        file_w <- c(file_w, energyRt:::.toGams(scenario@modInp@parameters[[i]]))
      }
    }
    
    ### Model code to text
    .generate_gpr_gams_file(arg$dir.result)
    zz <- file(paste(arg$dir.result, '/mdl.gms', sep = ''), 'w')
    cat(run_code[1:(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) - 1)], sep = '\n', file = zz)
    cat(file_w, sep = '\n', file = zz)
    # Add constraint equation 
    if (length(scenario@modInp@gams.equation) > 0) {
      # Declaration
      cat('equation', sapply(scenario@modInp@gams.equation, function(x) x$equationDeclaration), ';', '', sep = '\n', file = zz) 
      # Body equation
      cat(sapply(scenario@modInp@gams.equation, function(x) x$equation), '', sep = '\n', file = zz) 
    }
    if (!is.null(scenario@model@misc$additionalEquationGAMS)) 
      cat(scenario@model@misc$additionalEquationGAMS$code, sep = '\n', file = zz)

    cat(run_code[(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) + 1):
                   (grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) - 1)], sep = '\n', file = zz)
    
    # Add constraint equation to model declaration
    if (length(scenario@modInp@gams.equation) > 0) {
      cat(sapply(scenario@modInp@gams.equation, function(x) x$equationDeclaration2Model), sep = '\n', file = zz) 
    }
    
    if (!is.null(scenario@model@misc$additionalEquationGAMS)) 
      cat(scenario@model@misc$additionalEquationGAMS$declaration, sep = '\n', file = zz)
    
    cat(run_code[(grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) + 1):
                   (grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) - 1)], sep = '\n', file = zz)
    cat(run_code[(grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) + 1):
                   (grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) - 1)], sep = '\n', file = zz)
    
    if (arg$only.listing) {
      cat('OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;\n',
          'OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;\n',
          'option iterlim = 0;\n', 
          'Solve st_model minimizing vObjective using LP;\n$EXIT\n', file = zz, sep = '')
    }
    cat(scenario@model@misc$additionalCode, sep = '\n', file = zz)
    cat(run_code[(grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) + 1):(
      grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) - 1)], sep = '\n', file = zz)
    cat(scenario@model@misc$additionalCodeAfter, sep = '\n', file = zz)
    cat(run_code[(min(c(grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) + 1, length(run_code)))):length(run_code)], sep = '\n', file = zz)
    close(zz)
    if (arg$echo) { 
      cat('Write model to disk: ', round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
      flush.console()
    }

    ## Run model
    gams_run_time <- proc.time()[3]
    tryCatch({
      BEGINDR <- getwd()
      setwd(arg$dir.result)
      if (.Platform$OS.type == "windows") {
        rs <- system(paste('gams mdl.gms', arg$gamsCompileParameter), invisible = arg$invisible, 
                     show.output.on.console = arg$show.output.on.console)
      } else {
        rs <- system(paste('gams mdl.gms', arg$gamsCompileParameter))
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
      return(readLines(paste(arg$dir.result, '/mdl.lst', sep = '')))
    }
    if(arg$echo) cat('GAMS time: ', round(proc.time()[3] - gams_run_time, 2), 's\n', sep = '')
  } else if (solver == 'GLPK' || solver == 'CBC') {  
    ##################################################################################################################################    
    # GLPK & CBC part
    ##################################################################################################################################    

      ### FUNC GLPK 
    zz <- file(paste(arg$dir.result, '/glpk.mod', sep = ''), 'w')
    if (length(grep('^minimize', run_code)) != 1) stop('Wrong GLPK model')
    cat(run_code[1:(grep('^minimize', run_code) - 1)], sep = '\n', file = zz)
    cat(run_code[grep('^minimize', run_code):(grep('^end[;]', run_code) - 1)], 
        sep = '\n', file = zz)
    cat(run_code[grep('^end[;]', run_code):length(run_code)], sep = '\n', file = zz)
    close(zz)
    zz <- file(paste(arg$dir.result, '/glpk.dat', sep = ''), 'w') 
    for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'set') {
      cat(energyRt:::.sm_to_glpk(prec@parameters[[i]]), sep = '\n', file = zz)
    }
    cat('set FORIF := FORIFSET;\n', sep = '\n', file = zz)
    for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'map') {
      cat(energyRt:::.sm_to_glpk(prec@parameters[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'simple') {
      cat(energyRt:::.sm_to_glpk(prec@parameters[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'multi') {
      cat(energyRt:::.sm_to_glpk(prec@parameters[[i]]), sep = '\n', file = zz)
    }                            
    cat('end;', '', sep = '\n', file = zz) 
    close(zz)
    pp2 <- proc.time()[3]
    if(echo) {
      cat('Total preprocessing time: ', round(pp2 - pp1, 2), 's\n', sep = '')
      flush.console()
    }
    tryCatch({
      setwd(arg$dir.result)
      if (.Platform$OS.type == "windows") {
        if (solver  == 'GLPK') {
          rs <- system(paste('glpsol.exe -m glpk.mod -d glpk.dat --log log.csv', arg$glpkCompileParameter), 
                       invisible = arg$invisible, show.output.on.console = arg$show.output.on.console)
        } else {
          rs <- system(paste("cbc glpk.mod%glpk.dat -solve", arg$cbcCompileParameter, 
                             show.output.on.console = arg$show.output.on.console,  invisible = arg$invisible))
        }
      } else {
        if (solver  == 'GLPK') {
          rs <- system(paste('glpsol -m glpk.mod -d glpk.dat --log log.csv', 
                             arg$glpkCompileParameter)) #, mustWork = TRUE)
        } else {
          rs <- system(paste("cbc glpk.mod%glpk.dat -solve", arg$cbcCompileParameter))
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
    pp3 <- proc.time()[3]
    if(echo) cat('GLPK/MathProg time: ', round(pp3 - pp2, 2), 's\n', sep = '')
    if (any(grep('OPTIMAL.*SOLUTION FOUND', readLines(paste(arg$dir.result, '/log.csv', sep = ''))))) {
      z3 <- file(paste(arg$dir.result, '/pStat.csv', sep = ''), 'w')
      cat('value\n1.00\n', file = z3)
      close(z3)
    } else {
      z3 <- file(paste(arg$dir.result, '/pStat.csv', sep = ''), 'w')
      cat('value\n2.00\n', file = z3)
      close(z3)
    }
  } else stop('Unknown solver ', solver) 
  if (readresult) scenario <- read_solution(scenario)
  invisible(scenario)
}
