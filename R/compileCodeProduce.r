
sm_compile_model <- function(obj, 
   tmp.dir = NULL, tmp.del = FALSE, ...) {
#####################################################################################
# Argument data prepare
#####################################################################################
  pp1 <- proc.time()[3]
  # Upper case
  arg <- list(...)
  if (any(names(arg) == 'exclude')) arg <- arg[!(names(arg) %in% c('exclude', arg$exclude))]
  if (any(names(arg) == 'solver')) {
    solver <- arg$solver
    arg <- arg[names(arg) != 'solver', drop = FALSE]
  } else solver <- 'GAMS'
  if (solver == 'GAMS') {
    rs <- try(system('gams'))
    if (rs != 0) stop('There is no gams')
  }
  if (is.null(tmp.dir)) {
    tmp.dir <- getwd()
  }
  if (any(names(arg) == 'n.threads')) {
    n.threads <- arg$n.threads
    arg <- arg[names(arg) != 'n.threads', drop = FALSE]
  } else n.threads <- detectCores()
#    if (.Platform$OS.type == "unix") {
#      tmpdir = Sys.getenv('TMPDIR')
#    } else {
#       tmpdir = Sys.getenv('TMP')
#    }
    tmp.dir <-  paste(tmp.dir, '/solwork/', sep = '')
    add_drr <- paste(solver, obj@name, format(Sys.Date(),
       format = '%Y-%m-%d'), format(Sys.time(), format = '%H-%M-%S'), sep = '_')
    #dir.create(paste(tmpdir, '/', add_drr, '/', sep = ''), recursive = TRUE)
    tmp.dir <- paste(tmp.dir, '/', add_drr, sep = '')
    dir.create(tmp.dir, recursive = TRUE)
  #}
  tmpdir <- tmp.dir
  BEGINDR <- getwd()
  description <- ''
  if (is.null(names(arg)) || any(names(arg) == '')) stop('Undefined argument')
  if (any(names(arg) == 'scenario')) {
    if (class(arg$scenario) == 'scenario') {
      name <- arg$scenario@name
      description <- arg$scenario@description
      obj@data <- obj@data[sapply(obj@data, function(x) x@name) %in% 
         sapply(arg$scenario@data, function(x) x@name)]
      obj@data <- arg$scenario@model@sysInfo
    } else {
      if (is.null(names(arg$scenario)) || any(names(arg$scenario) == '')) stop('Wrong argument scenario')
      for(i in names(arg$scenario)) 
        arg[[i]] <- arg$scenario[[i]] 
    }
    arg <- arg[names(arg) != 'scenario', drop = FALSE]    
  }
  if (all(names(arg) != 'name')) stop('Name undefined')
  name <- arg$name
  arg <- arg[names(arg) != 'name', drop = FALSE]    
  if (any(names(arg) == 'description')) {
    description <- arg$description
    arg <- arg[names(arg) != 'description', drop = FALSE]    
  }
  if (any(names(arg) == 'model.type')) {
    model.type <- arg$model.type
    arg <- arg[names(arg) != 'model.type', drop = FALSE]
    if (all(model.type != c('reduced', 'full')))
     stop('Unknown model.type argument, have to be "full" or "reduced"')
  } else model.type <- 'reduced'
  if (model.type == 'reduced') {
    if (length(getNames(obj, class = 'constrain', type = '(fixom|varom|actvarom|cvarom|avarom)')) > 0) {
      stop(paste('Unexeptable constrain for reduced model: "', 
        paste(getNames(obj, class = 'constrain', type = '(fixom|varom|actvarom|cvarom|avarom)'), 
          collapse = '", "'), '"', sep = ''))
    }
  }
  if (any(names(arg) == 'region')) {
    obj@sysInfo@region <- arg$region
    arg <- arg[names(arg) != 'region', drop = FALSE]
  } 
  if (any(names(arg) == 'year')) {
    obj@sysInfo@year <- arg$year
    arg <- arg[names(arg) != 'year', drop = FALSE]
  } 
  if (any(names(arg) == 'slice')) {
    obj@sysInfo@slice <- arg$slice
    arg <- arg[names(arg) != 'slice', drop = FALSE]
  } 
  if (any(names(arg) == 'repository')) {
    rpp <- sapply(obj@data, function(x) x@name)
    if (any(!(arg$repository %in% rpp))) stop('Undefined repository ', 
                                  arg$repository[!(arg$repository %in% rpp)]) 
    obj@data <- obj@data[rpp %in% arg$repository]
    arg <- arg[names(arg) != 'repository', drop = FALSE]
  }
  if (any(names(arg) == 'glpkCompileParameter')) {
    glpkCompileParameter <- arg$glpkCompileParameter
    arg <- arg[names(arg) != 'glpkCompileParameter', drop = FALSE]
  } else glpkCompileParameter <- ''
  if (any(names(arg) == 'gamsCompileParameter')) {
    gamsCompileParameter <- arg$gamsCompileParameter
    arg <- arg[names(arg) != 'gamsCompileParameter', drop = FALSE]
  } else gamsCompileParameter <- ''
  if (any(names(arg) == 'cbcCompileParameter')) {
    cbcCompileParameter <- arg$cbcCompileParameter
    arg <- arg[names(arg) != 'cbcCompileParameter', drop = FALSE]
  } else cbcCompileParameter <- ''
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
#####################################################################################
# Fill data to Code produce
#####################################################################################
  if (nrow(obj@sysInfo@milestone) == 0) {
    if (!all(min(obj@sysInfo@year) + seq(along = obj@sysInfo@year) - 1 == obj@sysInfo@year))
      stop('wrong year, use setMilestoneYears function')
    obj <- setMilestoneYears(obj, start = min(obj@sysInfo@year), interval = rep(1, length(obj@sysInfo@year)))
  }
  # Create exemplar for code
  prec <- new('CodeProduce')
  # List for approximation
  approxim <- list(
      region = obj@sysInfo@region,
      year   = obj@sysInfo@year,
      slice  = obj@sysInfo@slice
  )
  if (any(names(arg) == 'region')) {
      approxim$region = arg$region
      obj@sysInfo@region <- arg$region
      arg <- arg[names(arg) != 'region', drop = FALSE]
  }
  if (any(names(arg) == 'year')) {
      approxim$year = arg$year
      obj@sysInfo@year <- arg$year
      arg <- arg[names(arg) != 'year', drop = FALSE]
  }
  if (any(names(arg) == 'slice')) {
      approxim$slice = arg$slice
      obj@sysInfo@slice <- arg$slice
      arg <- arg[names(arg) != 'slice', drop = FALSE]
  }
  if (any(names(arg) == 'discount')) {
      obj@sysInfo@discount <- arg$discount
      arg <- arg[names(arg) != 'discount', drop = FALSE]
  }
  if (any(names(arg) == 'repository')) {
      obj@data <- obj@data[sapply(obj@data, function(x) x@name %in% arg@repository)]
      arg <- arg[names(arg) != 'repository', drop = FALSE]
  }
  if (any(names(arg) == 'open.folder')) {
      open.folder <- arg$open.folder
      arg <- arg[names(arg) != 'open.folder', drop = FALSE]
  } else open.folder <- FALSE
  # Fill DB by region & slice
  for(i in c('region', 'slice')) {
    prec@maptable[[i]] <- addData(prec@maptable[[i]], approxim[[i]])
  }
  # Fill DB by year
  prec@maptable[['year']] <- addData(prec@maptable[['year']], as.numeric(approxim[['year']]))
  prec <- read_default_data(prec, obj@sysInfo)
  # add set 
  for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) { #if (class(obj@data[[i]]@data[[j]]) == 'technology') {
          prec <- add_name(prec, obj@data[[i]]@data[[j]], approxim = approxim)
        }
    }
    cat('Generating model input files ')
  # Fill DB main data
  if (n.threads > 1) {
    prorgess_bar_p <- proc.time()[3]
    tryCatch({
      cl <- makePSOCKcluster(rep('localhost', n.threads))
      ll <- list()
      cat('1 ', round(proc.time()[3] - prorgess_bar_p, 2), 's\n')
      for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) { 
          ll[[length(ll) + 1]] <- obj@data[[i]]@data[[j]]
        }
      }
      gg <- lapply(1:n.threads - 1, function(x) ll[(seq(along = ll) - 1) %% n.threads == x])
      prclst <- parLapply(cl, gg, 
        function(ll, prec, approxim) {
            require(energyRt)
            for(i in seq(along = ll)) {
              prec <- add0(prec, ll[[i]], approxim = approxim)
            }
          prec
        }, prec, approxim)
      stopCluster(cl)
    }, interrupt = function(x) {
      stopCluster(cl)
      stop('Solver has been interrupted')
    }, error = function(x) {
      stopCluster(cl)
      stop(x)
    })    
    for(i in names(prec@maptable)) {
        hh <- sapply(prclst, function(x) if (x@maptable[[i]]@true_length == -1) 
          nrow(x@maptable[[i]]@data) else x@maptable[[i]]@true_length)
        if (prec@maptable[[i]]@true_length == -1) nn <- nrow(prec@maptable[[i]]@data) else 
          nn <- prec@maptable[[i]]@true_length
        hh <- hh - nn
        n0 <- nn
        fl <- seq(along = hh)[hh != 0]
        if (length(fl) != 0) {
          prec@maptable[[i]]@data[nn + 1:sum(hh), ] <- NA
          for(j in fl) {
            prec@maptable[[i]]@data[nn + 1:hh[j], ] <- prclst[[j]]@maptable[[i]]@data[n0 + 1:hh[j], ]
            nn <- nn + hh[j]
          }
          if (prec@maptable[[i]]@true_length != -1) prec@maptable[[i]]@true_length <- nn
          if (i == 'group' && nn != 0) {
            if (prec@maptable[[i]]@true_length != -1) {
              gr <- unique(prec@maptable[[i]]@data[seq(length.out = prec@maptable[[i]]@true_length), 1])
              prec@maptable[[i]]@data[, 1] <- NA
              prec@maptable[[i]]@data[1:length(gr), 1] <- gr
              prec@maptable[[i]]@true_length <- length(gr)
            } else {
              gr <- unique(prec@maptable[[i]]@data[, 1])
              prec@maptable[[i]]@data <- prec@maptable[[i]]@data[1:length(gr),, drop = FALSE]
              prec@maptable[[i]]@data[, 1] <- gr
            }
          }
        }
    }
  } else if (n.threads == 1) {
    prorgess_bar <- sapply(obj@data, function(x) length(x@data))
    if (is.list(prorgess_bar)) prorgess_bar <- 0 else prorgess_bar <- sum(prorgess_bar)
    prorgess_bar_0 <- 0
    prorgess_bar_dl <- (prorgess_bar + 50 - 1) %/% 50
    hh <- sum(sapply(obj@data, function(x) length(x@data)))
    k <- 0
      prorgess_bar_p <- proc.time()[3]
    # Fill DB main data
      for(i in seq(along = obj@data)) {
          for(j in seq(along = obj@data[[i]]@data)) { 
            k <- k + 1
            hh[k] <- proc.time()[3]
            prec <- add0(prec, obj@data[[i]]@data[[j]], approxim = approxim)
            hh[k] <- hh[k] - proc.time()[3]
            prorgess_bar_0 <- prorgess_bar_0 + 1
            if (prorgess_bar_0 %% prorgess_bar_dl == 0) {
              cat('.')
              flush.console() 
            }
          }
      }
      cat(' ', round(proc.time()[3] - prorgess_bar_p, 2), 's\n')
  } else stop('Uneceptable threads number')
  prec <- add0(prec, obj@sysInfo, approxim = approxim) 
#    for(i in seq(along = prec@maptable)) {
#      if (prec@maptable[[i]]@true_length != 0) {
#          prec@maptable[[i]]@data <- prec@maptable[[i]]@data[1:prec@maptable[[i]]@true_length,, drop = FALSE]
#      }
#    }
#####################################################################################
# Handle data
#####################################################################################
  # Check slots
  check_set <- function(set, alias = NULL) {
    if (is.null(alias)) alias <- set
    ss <- prec@maptable[[set]]@data[, set]
    for(al in alias) {
      for(i in 1:length(prec@maptable)) {
        if (any(prec@maptable[[i]]@set == al) 
            && !all(getSet(prec@maptable[[i]], al) %in% ss)) {
              dd <- getSet(prec@maptable[[i]], al)[!(getSet(prec@maptable[[i]], al) %in% ss)]
              dd <- prec@maptable[[i]]@data[prec@maptable[[i]]@data[, set] %in% dd, , drop = FALSE]
              stop(paste('Unknown ', set, ' in slot ', prec@maptable[[i]]@alias, '\n', 
                paste(apply(dd, 1, function(x) paste(x, collapse = '.')), collapse = '\n'), 
                '\n', sep = ''))               
        }
      }
    }
  }
  # Additional for compatibility with GLPK
  check_set('comm', c('comm', 'commp', 'acomm'))
  for(i in c('expp', 'imp', 'tech', 'trade', 'sup', 'group', 'region', 'year', 'slice')) check_set(i)
  if (length(obj@LECdata) != 0) {
     prec@maptable$mLECRegion <- addMultipleSet(prec@maptable$mLECRegion, obj@LECdata$region)
     if (length(obj@LECdata$pLECLoACT) == 1) {
        prec@maptable$pLECLoACT <- addData(prec@maptable$pLECLoACT, 
            data.frame(region = obj@LECdata$region, Freq = obj@LECdata$pLECLoACT))
     }
  }
  ## Constrain
  yy <- c('tech', 'sup', 'stg', 'expp', 'imp', 'trade', 'group', 'comm', 'region', 'year', 'slice')
  appr <- lapply(yy, function(x) prec@maptable[[x]]@data[[x]])
  names(appr) <- yy
  appr$group <- appr$group[!is.na(appr$group)]
# ---------------------------------------------------------------------------------------------------------  
# Fix to previous data
# ---------------------------------------------------------------------------------------------------------  
  if (any(names(arg) == 'fix_data')) {
      ll <- c("vTechUse", "vTechNewCap", "vTechRetiredCap",# "vTechRetrofitCap", "vTechUpgradeCap", 
              "vTechCap", "vTechAct", 
              "vTechInp", "vTechOut", "vTechAInp", "vTechAOut", "vSupOut", 
              "vDemInp", "vDummyOut", "vDummyInp", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageCap", 
              "vStorageNewCap", "vImport", "vExport", "vTradeFlow", "vExportRow", "vImportRow")
      if (!is.character(arg$fix_data) || any(!(arg$fix_data %in% c('all', ll)))) {
        if (!is.character(arg$fix_data)) stop('Uncorrect fix_data') else
          stop('Unknown fix_data ', paste(arg$fix_data[!(arg$fix_data %in% c('all', ll))], collapse = ', '))
      }
      if (any(arg$fix_data == 'all') && length(arg$fix_data) != 1) 
        stop('Value all and other one is prohibited fix_data')
      if (arg$fix_data != 'all') ll <- ll[ll %in% arg$fix_data]
      for(i in ll) {
        p1 <- proc.time()[3]
        gg <- as.data.frame.table(arg$fix_scenario@result@data[[i]], stringsAsFactors = FALSE)
        for(j in seq(length.out = ncol(gg) - 1)) {
          k <- gsub('[.].*', '', colnames(gg)[j])
          gg <- gg[gg[, j] %in% appr[[k]],, drop = FALSE]
          if (k == 'year') {
            gg <- gg[gg[, j] %in% arg$fix_year,, drop = FALSE]
            gg[, j] <- as.numeric(gg[, j])
          }
        }
        colnames(gg) <- gsub('[.]1', 'p', colnames(gg))
        colnames(gg) <- gsub('[.]2', 'e', colnames(gg))
        prec@maptable[[gsub('^.', 'mPreDef', i)]] <- 
           addData(prec@maptable[[gsub('^.', 'mPreDef', i)]], gg[, -ncol(gg)])
        gg <- gg[gg[, 'Freq'] != 0,] 
        prec@maptable[[gsub('^.', 'preDef', i)]] <- addData(prec@maptable[[gsub('^.', 'preDef', i)]], gg)
      
      }
      arg <- arg[names(arg) != 'fix_data', drop = FALSE]
      arg <- arg[names(arg) != 'fix_scenario', drop = FALSE]
      arg <- arg[names(arg) != 'fix_year', drop = FALSE]
  }
# ---------------------------------------------------------------------------------------------------------  
# Get only listing file
# ---------------------------------------------------------------------------------------------------------  
  if (any(names(arg) == 'only.listing')) {
      only.listing <- arg$only.listing
      if (only.listing && solver != 'GAMS') {
         stop('only.listing file have to be only with GAMS "solver"')
      }
      arg <- arg[names(arg) != 'only.listing', drop = FALSE]
  } else only.listing <- FALSE
  
  if (length(arg) != 0) warning('Unknown argument ', names(arg))
# ---------------------------------------------------------------------------------------------------------  
      gg <- prec@maptable[['pDiscount']]@data
      gg <- gg[sort(gg$year, index.return = TRUE)$ix,, drop = FALSE]
      ll <- gg[0,, drop = FALSE]
      for(l in unique(gg$region)) {
        dd <- gg[gg$region == l,, drop = FALSE]
        dd$Freq <- cumprod(1 / (1 + dd$Freq))
        ll <- rbind(ll, dd)
      }
      prec@maptable[['pDiscountFactor']] <- addData(prec@maptable[['pDiscountFactor']], ll)
       hh <- gg[gg$year == as.character(max(obj@sysInfo@year)), -2]
       hh <- hh[hh$Freq == 0, 'region', drop = FALSE]
      # Add mDiscountZero - zero discount rate in final period
      if (nrow(hh) != 0) {
        prec@maptable[['mDiscountZero']] <- addData(prec@maptable[['mDiscountZero']], hh)
      } 
LL1 <- proc.time()[3]
      ##!!!!!!!!!!!!!!!!!!!!!
      # Add defpSupReserve
      gg <- getDataMapTable(prec@maptable[['pSupReserve']])
#      if (prec@maptable[['pSupReserve']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pSupReserve']]@true_length),, drop = FALSE]
      gg <- gg[gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpSupReserve']] <- 
          addData(prec@maptable[['defpSupReserve']], gg[, 1:(ncol(gg) - 1), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pSupReserve']]@default == Inf) {
        prec@maptable[['defpSupReserve']]@default <- 0
      }  else prec@maptable[['defpSupReserve']]@default <- 1
      # Add defpSupAvaUp
      gg <- getDataMapTable(prec@maptable[['pSupAva']])
#      if (prec@maptable[['pSupAva']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pSupAva']]@true_length),, drop = FALSE]
      gg <- gg[gg$Freq != Inf & gg$type == 'up', ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpSupAvaUp']] <- addData(prec@maptable[['defpSupAvaUp']], 
           gg[, 1:(ncol(gg) - 2), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pSupAva']]@default == Inf) {
        prec@maptable[['defpSupAvaUp']]@default <- 0
      }  else prec@maptable[['defpSupAvaUp']]@default <- 1
      # Add pDummyImportCost
      gg <- getDataMapTable(prec@maptable[['pDummyImportCost']])
      gg <- gg[gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpDummyImportCost']] <- 
          addData(prec@maptable[['defpDummyImportCost']], gg[, 1:(ncol(gg) - 1), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pDummyImportCost']]@default == Inf) {
        prec@maptable[['defpDummyImportCost']]@default <- 0
      } else prec@maptable[['defpDummyImportCost']]@default <- 1
      # Add pDummyExportCost
      gg <- getDataMapTable(prec@maptable[['pDummyExportCost']])
      gg <- gg[gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpDummyExportCost']] <- 
          addData(prec@maptable[['defpDummyExportCost']], gg[, 1:(ncol(gg) - 1), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pDummyExportCost']]@default == Inf) {
        prec@maptable[['defpDummyExportCost']]@default <- 0
      } else prec@maptable[['defpDummyExportCost']]@default <- 1
      # defpExportRowRes   
      gg <- getDataMapTable(prec@maptable[['pExportRowRes']])
#      if (prec@maptable[['pExportRowRes']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pExportRowRes']]@true_length),, drop = FALSE]
      gg <- gg[gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpExportRowRes']] <- addData(prec@maptable[['defpExportRowRes']], 
          gg[, 1:(ncol(gg) - 1), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pExportRowRes']]@default == Inf) {
        prec@maptable[['defpExportRowRes']]@default <- 0
      }  else prec@maptable[['defpExportRowRes']]@default <- 1
      # defpImportRowRes
      gg <- getDataMapTable(prec@maptable[['pImportRowRes']])
#      if (prec@maptable[['pImportRowRes']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pImportRowRes']]@true_length),, drop = FALSE]
      gg <- gg[gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpImportRowRes']] <- addData(prec@maptable[['defpImportRowRes']], 
          gg[, 1:(ncol(gg) - 1), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pImportRowRes']]@default == Inf) {
        prec@maptable[['defpImportRowRes']]@default <- 0
      }  else prec@maptable[['defpImportRowRes']]@default <- 1
      # defpExportRowUp 
      gg <- getDataMapTable(prec@maptable[['pExportRow']])
#      if (prec@maptable[['pExportRow']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pExportRow']]@true_length),, drop = FALSE]
      gg <- gg[gg$type == 'up' & gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpExportRowUp']] <- addData(prec@maptable[['defpExportRowUp']], 
          gg[, 1:(ncol(gg) - 2), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pExportRow']]@default[2] == Inf) {
        prec@maptable[['defpExportRowUp']]@default <- 0
      }  else prec@maptable[['defpExportRowUp']]@default <- 1
      # defpImportRowUp
      gg <- getDataMapTable(prec@maptable[['pImportRow']])
#      if (prec@maptable[['pImportRow']]@true_length != -1)
#        gg <- gg[seq(length.out = prec@maptable[['pImportRow']]@true_length),, drop = FALSE]
      gg <- gg[gg$type == 'up' & gg$Freq != Inf, ]
      if (nrow(gg) != 0) {
        prec@maptable[['defpImportRowUp']] <- addData(prec@maptable[['defpImportRowUp']], 
          gg[, 1:(ncol(gg) - 2), drop = FALSE])
      } else if (nrow(gg) == 0 && prec@maptable[['pImportRow']]@default[2] == Inf) {
        prec@maptable[['defpImportRowUp']]@default <- 0
      }  else prec@maptable[['defpImportRowUp']]@default <- 1
      # For remove emission equation
      g1 <- getDataMapTable(prec@maptable$pTechEmisComm)
#      if (prec@maptable[['pTechEmisComm']]@true_length != -1)
#        g1 <- g1[seq(length.out = prec@maptable[['pTechEmisComm']]@true_length),, drop = FALSE]
      g2 <- getDataMapTable(prec@maptable$pEmissionFactor)
#      if (prec@maptable[['pEmissionFactor']]@true_length != -1)
#        g2 <- g2[seq(length.out = prec@maptable[['pEmissionFactor']]@true_length),, drop = FALSE]
      g1 <- g1[g1$Freq != 0, , drop = FALSE]
      for(g in unique(g2$comm)) {
        cmd <- g2[g2$comm == g, 'commp']
        tec <- unique(g1[g1$comm %in% cmd, 'tech'])
        prec@maptable$mTechEmitedComm <- addData(prec@maptable$mTechEmitedComm,
          data.frame(tech = tec, comm = rep(g, length(tec))))
      }
      # Tech oilfe
      olf <- getDataMapTable(prec@maptable$pTechOlife)
      inv <- getDataMapTable(prec@maptable$pTechInvcost)
      olf <- olf[olf$Freq == Inf,, drop = FALSE]
      if (nrow(olf) > 0) {
        inv <- aggregate(inv$Freq, by = inv[, c('tech', 'region')], FUN = "max")
        inv <- inv[inv$tech %in% unique(olf$tech) & inv$x != 0,, drop = FALSE]
        oo <- paste(olf$tech, olf$region, sep = '#')
        ii <- paste(inv$tech, inv$region, sep = '#')
        if (any(oo %in%  ii)) {
          print('There is technology with infinite olife and non zero invcost: ')
          print(inv[ii %in% oo, -ncol(inv), drop = FALSE])
          stop('See previous errors')
        }
        prec@maptable$ndefpTechOlife <- addData(prec@maptable$ndefpTechOlife, olf[, -ncol(olf), drop = FALSE])
      }
      # Check user error
      check_maptable(prec)
########
#  Remove unused technology
########
    for(i in seq(along =obj@data)) {
        FF <- rep(TRUE, length(obj@data[[i]]@data))
        for(j in seq(along = obj@data[[i]]@data)) if (class(obj@data[[i]]@data[[j]]) == 'constrain') {
          if (any(names(obj@data[[i]]@data[[j]]@for.each) == 'tech') && 
            !is.null(obj@data[[i]]@data[[j]]@for.each$tech)) {
            obj@data[[i]]@data[[j]]@for.each$tech <- obj@data[[i]]@data[[j]]@for.each$tech[
              obj@data[[i]]@data[[j]]@for.each$tech %in% prec@maptable$tech@data$tech]
              if (length(obj@data[[i]]@data[[j]]@for.each$tech) == 0) FF[j] <- FALSE
          }
          if (any(names(obj@data[[i]]@data[[j]]@for.sum) == 'tech') && 
            !is.null(obj@data[[i]]@data[[j]]@for.sum$tech)) {
            obj@data[[i]]@data[[j]]@for.sum$tech <- obj@data[[i]]@data[[j]]@for.sum$tech[
              obj@data[[i]]@data[[j]]@for.sum$tech %in% prec@maptable$tech@data$tech]
              if (length(obj@data[[i]]@data[[j]]@for.sum$tech) == 0) FF[j] <- FALSE
          }
        }
        obj@data[[i]]@data <- obj@data[[i]]@data[FF]
    }
    # Early reteirment
    if (!obj@early.retirement) {
      prec@maptable$mTechRetirement@data <- prec@maptable$mTechRetirement@data[0,, drop = FALSE]
      if (prec@maptable$mTechRetirement@true_length != -1)
        prec@maptable$mTechRetirement@true_length <- 0
    }
#!################
### FUNC GAMS 
  if (open.folder) shell.exec(tmpdir)
  if (solver == 'GAMS') {
    zz <- file(paste(tmpdir, '/mdl.gpr', sep = ''), 'w')
    cat(c('[RP:MDL]', '1=', '', '[OPENWINDOW_1]', 
      gsub('[/][/]*', '\\\\', paste('FILE0=', tmp.dir, '/mdl.gms', sep = '')),
      gsub('[/][/]*', '\\\\', paste('FILE1=', tmp.dir, '/mdl.lst', sep = '')), '', 'MAXIM=1', 
      'TOP=50', 'LEFT=50', 'HEIGHT=400', 'WIDTH=400', ''), sep = '\n', file = zz)
    close(zz)
    if (model.type == 'reduced') {
      cdd <- prec@model_reduced
    } else {
      cdd <- prec@model_full
    }
   zz <- file(paste(tmpdir, '/mdl.gms', sep = ''), 'w')
   cat(cdd[1:(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', cdd) - 1)], sep = '\n', file = zz)
   
   for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'set') {
      cat(toGams(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'map') {
      cat(toGams(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'single') {
      cat(toGams(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'double') {
      cat(toGams(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    cat(cdd[(grep('e0fc7d1e-fd81-4745-a0eb-2a142f837d1c', cdd) + 1):
        (grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', cdd) - 1)], sep = '\n', file = zz)
    cat(cdd[(grep('c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f', cdd) + 1):
        (grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', cdd) - 1)], sep = '\n', file = zz)
  
    cat(cdd[(grep('ddd355e0-0023-45e9-b0d3-1ad83ba74b3a', cdd) + 1):
        (grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', cdd) - 1)], sep = '\n', file = zz)
    if (only.listing) {
      cat('OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;\n',
          'OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;\n',
          'option iterlim = 0;\n', 
          'Solve st_model minimizing vObjective using LP;\n$EXIT\n', file = zz, sep = '')
    
    }
    cat(obj@additionalCode, sep = '\n', file = zz)
    cat(cdd[(grep('f374f3df-5fd6-44f1-b08a-1a09485cbe3d', cdd) + 1):(
        grep('47b574db-2b0b-4556-a2e1-b323430d6ae6', cdd) - 1)], sep = '\n', file = zz)
    cat(obj@additionalCodeAfter, sep = '\n', file = zz)
    cat(cdd[(min(c(grep('47b574db-2b0b-4556-a2e1-b323430d6ae6', cdd) + 1, length(cdd)))):length(cdd)], sep = '\n', file = zz)
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
    if(echo) cat('Solver work time: ', round(pp3 - pp2, 2), 's\n', sep = '')
  } else if (solver == 'GLPK' || solver == 'CBC') {   
### FUNC GLPK 
    if (model.type == 'reduced') {
      glpk_model <- prec@model_reduced_glpk
    } else {
      glpk_model <- prec@model_full_glpk
    }
      zz <- file(paste(tmpdir, '/glpk.mod', sep = ''), 'w')
      if (length(grep('^minimize', glpk_model)) != 1) stop('Wrong GLPK model')
      cat(glpk_model[1:(grep('^minimize', glpk_model) - 1)], sep = '\n', file = zz)
#      for(i in seq(along = CNS)) {
#        cat(CNS[[i]]$add_code, sep = '\n', file = zz)
#      }
      cat(glpk_model[grep('^minimize', glpk_model):(grep('^end[;]', glpk_model) - 1)], 
          sep = '\n', file = zz)
      cat(glpk_model[grep('^end[;]', glpk_model):length(glpk_model)], sep = '\n', file = zz)
      close(zz)
#    cdd <- prec@model
    if (model.type == 'reduced') {
      glpk_model <- prec@model_reduced_glpk
    } else {
      glpk_model <- prec@model_full_glpk
    }
      zz <- file(paste(tmpdir, '/glpk.dat', sep = ''), 'w') 
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'set') {
      cat(sm_to_glpk(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    cat('set FORIF := FORIFSET;\n', sep = '\n', file = zz)
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'map') {
      cat(sm_to_glpk(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'single') {
      cat(sm_to_glpk(prec@maptable[[i]]), sep = '\n', file = zz)
    }
    for(i in names(prec@maptable)) if (prec@maptable[[i]]@type == 'double') {
      cat(sm_to_glpk(prec@maptable[[i]]), sep = '\n', file = zz)
    }                            
#    for(i in seq(along = CNS)) {
#      cat(CNS[[i]]$add_data, sep = '\n', file = zz)
#    }
    ##!!!!!!!!!!!!!!!!!!!!!
    ## ORD function
    cat('param ORD :=', sep = '\n', file = zz)  
    cat(paste(prec@maptable$year@data$year, seq(along = prec@maptable$year@data$year)), sep = '\n', file = zz)  
    cat(';', '', sep = '\n', file = zz) 
    cat('end;', '', sep = '\n', file = zz) 
    ##!!!!!!!!!!!!!!!!!!!!!  
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
      if(echo) cat('Solver work time: ', round(pp3 - pp2, 2), 's\n', sep = '')
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
    vrb_list <- read.csv(paste(tmpdir, '/variable_list.csv', sep = ''), stringsAsFactors = FALSE)$value
    if (file.exists(paste(tmpdir, '/variable_list2.csv', sep = ''))) {
      vrb_list2 <- read.csv(paste(tmpdir, '/variable_list2.csv', sep = ''), stringsAsFactors = FALSE)$value
    } else vrb_list2 <- character()
    rr <- list(par_arr = list(), set = read.csv(paste(tmpdir, 
      '/raw_data_set.csv', sep = ''), stringsAsFactors = FALSE))
    ss <- list()
    for(k in unique(rr$set$set)) {
      ss[[k]] <- rr$set$value[rr$set$set == k]
    }
    # add alias
    ss$src <- ss$region
    ss$dst <- ss$region
    ss$regionp <- ss$region
    ss$yearp <- ss$year
    ss$acomm <- ss$comm
    ss$commp <- ss$comm
    rr$set_vec <- ss
    for(i in vrb_list) {
      gg <- read.csv(paste(tmpdir, '/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
      if (ncol(gg) == 1) {
        rr$par_arr[[i]] <- gg[1, 1]  
      } else {
        jj <- gg[, -ncol(gg), drop = FALSE]
        for(j in seq(length.out = ncol(jj))) {
          if (all(colnames(jj)[j] != names(rr$set_vec))) colnames(jj)[j] <- gsub('[.].*', '', colnames(jj)[j])
          jj[, j] <- factor(jj[, j], levels = sort(rr$set_vec[[colnames(jj)[j]]]))
        }
        zz <- tapply(gg[,'value'], jj, sum)
        zz[is.na(zz)] <- 0
        rr$par_arr[[i]] <- zz
      }
    }
    # Read constrain data
    for(i in vrb_list2) {
      gg <- read.csv(paste(tmpdir, '/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
      if (nrow(gg) == 0) {
        rr$par_arr[[i]] <- NULL
      } else if (ncol(gg) == 2) {
        rr$par_arr[[i]] <- array(c(gg[1, 3:4], recursive = TRUE), dim = 2, dimnames = list(c('value', 'rhs')))
      } else {
        l1 <- gg[, -ncol(gg)]; l1$type[seq(length.out = nrow(gg))] <- 'rhs'
        l2 <- gg[, 1 - ncol(gg)]; l2$type[seq(length.out = nrow(gg))] <- 'value'
        colnames(l1)[ncol(l1) - 1] <- 'type'
        colnames(l2)[ncol(l2) - 1] <- 'type'
        gg <- rbind(l1, l2)
        rr$par_arr[[i]] <- tapply(gg[, ncol(gg) - 1], gg[, 1 - ncol(gg)], sum)
        
      }
    }
    rr[['solution_report']] <- list(finish = read.csv(paste(tmpdir, '/pFinish.csv', sep = ''))$value, 
      status = read.csv(paste(tmpdir, '/pStat.csv', sep = ''))$value)
    pp4 <- proc.time()[3]
     if (tmp.del) {
       #cat(tmpdir, 'yyyyyyyyyyyyyy\n')
       unlink(tmpdir, recursive = TRUE)
     }
    if(echo) cat('Total time: ', round(pp4 - pp1, 2), 's\n', sep = '')
   scn <- new('scenario')
   scn@name <- name
   scn@description <- description
   scn@precompiled <- prec
   scn@model <- obj
   scn@result <- new('result')
   scn@result@data <- rr$par_arr
   scn@result@set <- rr$set_vec
   scn@result@solution_report <- rr$solution_report
   if (rr$solution_report$finish != 2 || rr$solution_report$status != 1)
     warning('Unsuccessful finish')
   scn
}

#setMethod('solve', signature(obj = 'model'), sm_compile_model)
solve.model <- function(obj, ...) {
  if (all(names(list(...)) != 'name')) {
    warning('Scenario name is not specified, using "DEFAULT" name')
    sm_compile_model(obj, name = 'DEFAULT', ...)
  } else sm_compile_model(obj, ...)
}

sm_to_glpk <-  function(obj) {
    if (obj@true_length != -1) {
        obj@data <- obj@data[seq(length.out = obj@true_length),, drop = FALSE]
      }
    if (obj@type == 'set') {
      if (nrow(obj@data) == 0) {
        ret <- c(paste('set ', obj@alias, ' := 1;', sep = ''), '')
      } else {
        ret <- c(paste('set ', obj@alias, ' := ', paste(obj@data[, 1], collapse = ' '), ';', sep = ''), '')
      }
    } else if (obj@type == 'map') {
      if (nrow(obj@data) == 0) {
        ret <- paste('param ', obj@alias, ' default 0 := ;', sep = '')
      } else {
        ret <- paste('param ', obj@alias, ' default 0 := ', sep = '')
        ret <- c(ret, apply(obj@data, 1, function(x) paste('[', paste(x, collapse = ','), '] 1', sep = '')))
        ret <- c(ret, ';', '')
      }
    } else if (obj@type == 'single') {
       if (nrow(obj@data) == 0) {
        dd <- obj@default
        if (dd == Inf) dd <- 0
        ret <- paste('param ', obj@alias, ' default ', dd, ' := ;', sep = '')
      } else {
        ret <- paste('param ', obj@alias, ' default 0 := ', sep = '')
        fl <- obj@data[, 'Freq'] != Inf
        if (any(fl)) {
          ret <- c(ret, paste('[', apply(obj@data[fl, -ncol(obj@data), drop = FALSE], 1, 
            function(x) paste(x, collapse = ',')), '] ', obj@data[fl, 'Freq'], sep = ''))
        }
        ret <- c(ret, ';', '')
      }
    } else if (obj@type == 'double') {
      gg <- obj@data
      gg <- gg[gg$type == 'lo', , drop = FALSE]
      gg <- gg[, colnames(gg) != 'type'] 
       if (nrow(gg) == 0 || all(gg$Freq[1] == gg$Freq)) {
        if (nrow(gg) == 0) dd <- obj@default[1] else dd <- gg$Freq[1]
        if (dd == Inf) dd <- 0
        ret <- paste('param ', obj@alias, 'Lo default ', dd, ' := ;', sep = '')
      } else {
        ret <- paste('param ', obj@alias, 'Lo default 0 := ', sep = '')
        fl <- gg[, 'Freq'] != Inf
        if (any(fl)) {
          ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
            function(x) paste(x, collapse = ',')), '] ', gg[fl, 'Freq'], sep = ''))
        }
        ret <- c(ret, ';', '')
       }
      gg <- obj@data
      gg <- gg[gg$type == 'up', , drop = FALSE]
      gg <- gg[, colnames(gg) != 'type'] 
       if (nrow(gg) == 0 || all(gg$Freq[1] == gg$Freq)) {
        if (nrow(gg) == 0) dd <- obj@default[2] else dd <- gg$Freq[1]
        if (dd == Inf) dd <- 0
        ret <- c(ret, paste('param ', obj@alias, 'Up default ', dd, ' := ;', sep = ''))
      } else {
        ret <- c(ret, paste('param ', obj@alias, 'Up default 0 := ', sep = ''))
        fl <- gg[, 'Freq'] != Inf
        if (any(fl)) {
          ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
            function(x) paste(x, collapse = ',')), '] ', gg[fl, 'Freq'], sep = ''))
        }
        ret <- c(ret, ';', '')
       }
    } else stop('Must realise')
    ret
}

