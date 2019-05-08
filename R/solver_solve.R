solver_solve(scenario, ..., interpolate = FALSE) { # - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # solver = 'GAMS' use solver for model
  # tmp.dir - dir for solver
  # gamsCompileParameter, glpkCompileParameter, cbcCompileParameter - parameter for compiler (to cmd/sh)
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder befor run
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) arg$solver <- 'GAMS'
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$tmp.dir)) {
    tmp.dir <- getwd()
    tmp.dir <-  paste(tmp.dir, '/solwork/', sep = '')
    add_drr <- paste0(solver, '_', obj@name, '_', 
                      format(Sys.Date(), format = '%Y_%m_%d'), '_', 
                      format(Sys.time(), format = '%H_%M_%S'))
    arg$tmp.dir <- paste(tmp.dir, '/', add_drr, sep = '')
  }
  
  if (any(names(arg) == 'echo')) {
    echo <- arg$echo
    arg <- arg[names(arg) != 'echo', drop = FALSE]
  } else echo <- TRUE
  if (any(names(arg) == 'show.output.on.console')) {
    show.output.on.console <- arg$show.output.on.console
    arg <- arg[names(arg) != 'show.output.on.console', drop = FALSE]
  } else show.output.on.console <- TRUE
  if (any(names(arg) == 'invisible')) {
    arg_invisible <- arg$invisible
    arg <- arg[names(arg) != 'invisible', drop = FALSE]
  } else arg_invisible <- TRUE
  
  
  # interpolate if need  
  if (interpolate) scenario <- aenergyRt::interpolate(scenario, ...)
  
  
  # Important miscs
  dir.create(arg$tmp.dir, recursive = TRUE)
  if (arg$open.folder) shell.exec(tmpdir)
  # Check if gams (if it use) is available
  if (arg$solver == 'GAMS') {
    rs <- try(system('gams'))
    if (rs != 0) stop('There is no gams')
  }
  
  
  
  
  
  #!################
  ### FUNC GAMS 
  #### Code load
  run_code <- energyRt::modelCode[[solver]][[model.type]]
  if (open.folder) shell.exec(tmpdir)
  if (solver == 'GAMS') {
    zz <- file(paste(tmpdir, '/mdl.gpr', sep = ''), 'w')
    cat(c('[RP:MDL]', '1=', '', '[OPENWINDOW_1]', 
          gsub('[/][/]*', '\\\\', paste('FILE0=', tmp.dir, '/mdl.gms', sep = '')),
          gsub('[/][/]*', '\\\\', paste('FILE1=', tmp.dir, '/mdl.lst', sep = '')), '', 'MAXIM=1', 
          'TOP=50', 'LEFT=50', 'HEIGHT=400', 'WIDTH=400', ''), sep = '\n', file = zz)
    close(zz)
    zz <- file(paste(tmpdir, '/mdl.gms', sep = ''), 'w')
    cat(run_code[1:(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) - 1)], sep = '\n', file = zz)
    # cat(run_code[1:(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) - 1)], sep = '\n', file = zz)
    # prec <<- prec 
    # assign('prec', prec, globalenv())
    # cat('.....---------........\n')
    # pzz <- proc.time()[3]
    file_w <- c()
    if (n.threads > 1) { #  && FALSE
      tryCatch({
        pp <- proc.time()[3]
        nth <- min(c(2, n.threads))
        cl <- makePSOCKcluster(rep('localhost', nth))
        gg <- lapply(1:nth - 1, function(x) seq(along = prec@parameters)[(seq(along = prec@parameters) - 1) %% nth == x])
        prclst <- parLapply(cl, gg, 
                            function(ll, zz) {
                              ll <- zz[ll]
                              require(energyRt)
                              rs <- rep(character(), length(ll))
                              ss <- list()
                              rs[seq(along = ll)] <- NA
                              for(i in seq(along = ll)) {
                                ss[[i]] <- energyRt:::.toGams(ll[[i]])
                                rs[i] <- as.character(ll[[i]]@type)
                              }
                              list(rs = rs, ss = ss)
                            }, prec@parameters)
        stopCluster(cl)
      }, interrupt = function(x) {
        stopCluster(cl)
        stop('Solver has been interrupted')
      }, error = function(x) {
        stopCluster(cl)
        stop(x)
      })
      file_w <- c(
        c(lapply(prclst, function(x) x$ss[x$rs == 'set']), recursive = TRUE),
        c(lapply(prclst, function(x) x$ss[x$rs == 'map']), recursive = TRUE),
        c(lapply(prclst, function(x) x$ss[x$rs == 'simple']), recursive = TRUE),
        c(lapply(prclst, function(x) x$ss[x$rs == 'multi']), recursive = TRUE)
      )
      prclst <- NULL
    } else if (n.threads == 1) { # || TRUE
      file_w <- c()
      for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'set') {
        file_w <- c(file_w, energyRt:::.toGams(prec@parameters[[i]]))
        #cat(energyRt:::.toGams(prec@parameters[[i]]), sep = '\n', file = zz)
      }
      for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'map') {
        file_w <- c(file_w, energyRt:::.toGams(prec@parameters[[i]]))
        #cat(energyRt:::.toGams(prec@parameters[[i]]), sep = '\n', file = zz)
      }
      for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'simple') {
        file_w <- c(file_w, energyRt:::.toGams(prec@parameters[[i]]))
        #cat(energyRt:::.toGams(prec@parameters[[i]]), sep = '\n', file = zz)
      }
      for(i in names(prec@parameters)) if (prec@parameters[[i]]@type == 'multi') {
        file_w <- c(file_w, energyRt:::.toGams(prec@parameters[[i]]))
        # cat(energyRt:::.toGams(prec@parameters[[i]]), sep = '\n', file = zz)
      }
    } else stop('Uneceptable threads number')
    #cat('pzz5: ', round(proc.time()[3] - pzz, 2), '\n')
    #pzz <- proc.time()[3]
    cat(file_w, sep = '\n', file = zz)
    file_w <- NULL
    # Add Statment equation 
    if (length(prec@gams.equation) > 0) {
      cat('equation', sapply(prec@gams.equation, function(x) x$equationDeclaration), ';', '', sep = '\n', file = zz) 
      cat(sapply(prec@gams.equation, function(x) x$equation), '', sep = '\n', file = zz) 
    }
    # cat('pzz6: ', round(proc.time()[3] - pzz, 2), '\n')
    if (any(names(obj@misc) == 'additionalEquationGAMS')) cat(obj@misc$additionalEquationGAMS$code, sep = '\n', file = zz)
    
    cat(run_code[(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', run_code) + 1):
                   (grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) - 1)], sep = '\n', file = zz)
    #####
    # Add Statment equation 
    if (length(prec@gams.equation) > 0) {
      cat(sapply(prec@gams.equation, function(x) x$equationDeclaration2Model), sep = '\n', file = zz) 
    }
    if (any(names(obj@misc) == 'additionalEquationGAMS')) cat(obj@misc$additionalEquationGAMS$declaration, sep = '\n', file = zz)
    cat(run_code[(grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', run_code) + 1):
                   (grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) - 1)], sep = '\n', file = zz)
    
    cat(run_code[(grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', run_code) + 1):
                   (grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) - 1)], sep = '\n', file = zz)
    if (only.listing) {
      cat('OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;\n',
          'OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;\n',
          'option iterlim = 0;\n', 
          'Solve st_model minimizing vObjective using LP;\n$EXIT\n', file = zz, sep = '')
    }
    cat(obj@misc$additionalCode, sep = '\n', file = zz)
    cat(run_code[(grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', run_code) + 1):(
      grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) - 1)], sep = '\n', file = zz)
    cat(obj@misc$additionalCodeAfter, sep = '\n', file = zz)
    cat(run_code[(min(c(grep('99089425-31110-4440-be57-2ca102e9cee1', run_code) + 1, length(run_code)))):length(run_code)], sep = '\n', file = zz)
    # Add constrain file to read list
    close(zz)
    pp2 <- proc.time()[3]
    if (echo) { 
      cat('Total preprocessing time: ', round(pp2 - pp1, 2), 's\n', sep = '')
      flush.console()
    }
    tryCatch({
      setwd(tmpdir)
      if (.Platform$OS.type == "windows") {
        rs <- system(paste('gams mdl.gms', gamsCompileParameter), invisible = arg_invisible, 
                     show.output.on.console = show.output.on.console)
      } else {
        rs <- system(paste('gams mdl.gms', gamsCompileParameter))
      }
      setwd(BEGINDR)  
    }, interrupt = function(x) {
      if (tmp.del) unlink(tmpdir, recursive = TRUE)
      setwd(BEGINDR)
      stop('Solver has been interrupted')
    }, error = function(x) {
      if (tmp.del) unlink(tmpdir, recursive = TRUE)
      setwd(BEGINDR)
      stop(x)
    })    
    if (rs != 0) stop(paste('Solution error code', rs))
    if (only.listing) {
      return(readLines(paste(tmpdir, '/mdl.lst', sep = '')))
    }
    pp3 <- proc.time()[3]
    if(echo) cat('GAMS time: ', round(pp3 - pp2, 2), 's\n', sep = '')
  } else if (solver == 'GLPK' || solver == 'CBC') {   
    ### FUNC GLPK 
    zz <- file(paste(tmpdir, '/glpk.mod', sep = ''), 'w')
    if (length(grep('^minimize', run_code)) != 1) stop('Wrong GLPK model')
    cat(run_code[1:(grep('^minimize', run_code) - 1)], sep = '\n', file = zz)
    cat(run_code[grep('^minimize', run_code):(grep('^end[;]', run_code) - 1)], 
        sep = '\n', file = zz)
    cat(run_code[grep('^end[;]', run_code):length(run_code)], sep = '\n', file = zz)
    close(zz)
    zz <- file(paste(tmpdir, '/glpk.dat', sep = ''), 'w') 
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
    ##!!!!!!!!!!!!!!!!!!!!!
    ## ORD function
    #cat('param ORD :=', sep = '\n', file = zz)
    #cat(paste(prec@parameters$year@data$year, seq(along = prec@parameters$year@data$year)), sep = '\n', file = zz)
    #cat(';', '', sep = '\n', file = zz) 
    #cat('param ORDr :=', sep = '\n', file = zz)
    #cat(paste(prec@parameters$region@data$region, seq(along = prec@parameters$region@data$region)), sep = '\n', file = zz)
    #cat(';', '', sep = '\n', file = zz) 
    ##!!!!!!!!!!!!!!!!!!!!!  
    cat('end;', '', sep = '\n', file = zz) 
    close(zz)
    pp2 <- proc.time()[3]
    if(echo) {
      cat('Total preprocessing time: ', round(pp2 - pp1, 2), 's\n', sep = '')
      flush.console()
    }
    tryCatch({
      setwd(tmpdir)
      if (.Platform$OS.type == "windows") {
        if (solver  == 'GLPK') {
          #<<<<<<< HEAD
          #          rs <- system('glpsol.exe -m glpk.mod -d glpk.dat --log log.csv --exact')      
          ##          rs <- system('glpsol.exe -m glpk.mod -d glpk.dat --log log.csv --xcheck')      
          #        } else {
          #          rs <- system("cbc glpk.mod%glpk.dat -solve")
          #        }
          #      } else {
          #        if (solver  == 'GLPK') {
          #          rs <- system('glpsol -m glpk.mod -d glpk.dat --log log.csv') #, mustWork = TRUE)
          #          rs <- system('glpsol -m glpk.mod -d glpk.dat --log log.csv --xcheck') #, mustWork = TRUE)
          ## =======
          rs <- system(paste('glpsol.exe -m glpk.mod -d glpk.dat --log log.csv', glpkCompileParameter), 
                       invisible = arg_invisible, show.output.on.console = show.output.on.console)
        } else {
          rs <- system(paste("cbc glpk.mod%glpk.dat -solve", cbcCompileParameter, 
                             show.output.on.console = show.output.on.console,  invisible = arg_invisible))
        }
      } else {
        if (solver  == 'GLPK') {
          rs <- system(paste('glpsol -m glpk.mod -d glpk.dat --log log.csv', 
                             glpkCompileParameter)) #, mustWork = TRUE)
          #>>>>>>> 00e795fd76161408e7b5782a3aaf58177d36e20e
        } else {
          rs <- system(paste("cbc glpk.mod%glpk.dat -solve", cbcCompileParameter))
        }
      }
      setwd(BEGINDR)  
      if (rs != 0) stop(paste('Error in compilation with code', rs))
    }, interrupt = function(x) {
      if (tmp.del) unlink(tmpdir, recursive = TRUE)
      setwd(BEGINDR)
      stop('Solver have been interrupted')
    }, error = function(x) {
      if (tmp.del) unlink(tmpdir, recursive = TRUE)
      setwd(BEGINDR)
      stop(x)
    })    
    pp3 <- proc.time()[3]
    if(echo) cat('GLPK/MathProg time: ', round(pp3 - pp2, 2), 's\n', sep = '')
    if (any(grep('OPTIMAL.*SOLUTION FOUND', readLines(paste(tmpdir, '/log.csv', sep = ''))))) {
      z3 <- file(paste(tmpdir, '/pStat.csv', sep = ''), 'w')
      cat('value\n1.00\n', file = z3)
      close(z3)
    } else {
      z3 <- file(paste(tmpdir, '/pStat.csv', sep = ''), 'w')
      cat('value\n2.00\n', file = z3)
      close(z3)
    }
  } else stop('Unknown solver ', solver) 
  
  
}