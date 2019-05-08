# interpolate(scenario, overwrite = TRUE) - updates interpolation in scenario objects

# solver_solve(scenario, interpolate = NULL) - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
# returns list with solution status and folder

#read_solution(scen = NULL, folder) - reads results and updates scen, if scen = NULL, creates empty scenario with solution data


# Function that generate empty scenario with approximation, but without compilation and read result
interpolate <- function(obj, ...) { #- returns class scenario
  ## arguments
  # obj - scenario or model
  # name
  # description
  # n.threads - number of threads use for approximation
  # startYear && fixTo have to define both (or not define both) - run with startYear
  # year - basic milestone year definition (not recomendet for use), use only if milestone not defined
  # discount - define discount, not good practice
  # region - define region, not good practice
  # repository - class for add to model (repository or list of repository)
  # echo - print working data
  
  interpolation.time.begin <- proc.time()[3]
  
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (arg$echo) cat('Interplote model\n')
  
  if (class(obj) == 'model') {
    scen <- new('scenario')
    scen@model <- obj
    scen@name <- 'Default scenario name'
    scen@description <- 'Default description'
  } else if (class(obj) == 'scenario') {
    scen <- obj
  } else {
    stop('Undefined class "', obj, '"')
  } 
  
  if (!is.null(arg$name)) scen@name <- arg$name
  if (!is.null(arg$description)) scen@description <- arg$description
  if (is.null(arg$n.threads))  arg$n.threads <- detectCores()
  if (is.null(arg$startYear) != is.null(arg$fixTo)) 
    stop('startYear && fixTo have to define both (or not define both')
  if (!is.null(arg$year)) scen@model@sysInfo@year <- arg$year  
  if (!is.null(arg$repository)) scen@model <- .add.repository(scen@model, arg$repository)
  if (!is.null(arg$region)) scen@model@sysInfo@region <- arg$region
  if (!is.null(arg$discount)) scen@model@sysInfo@discount <- arg$discount
  
  ### Interpolation begin
  scen@modInp <- new('modInp')
  ## Fill basic sets
  # Fill year 
  if (!is.null(arg$year)) {
    if (nrow(scen@model@sysInfo@milestone) != 0)
      stop("argument can't use with milestone")
    scen@model@sysInfo@year <- arg$year
  }
  if (nrow(scen@model@sysInfo@milestone) == 0) {
    if (any(sort(scen@model@sysInfo@year) != scen@model@sysInfo@year) || 
        max(scen@model@sysInfo@year) - min(scen@model@sysInfo@year) + 1 != length(scen@model@sysInfo@year))
      stop('wrong year parameter')
    obj <- setMilestoneYears(obj, start = scen@model@sysInfo@year[1], 
                             interval = rep(1, length(scen@model@sysInfo@year)))
  }
  scen@modInp@parameters[['year']] <- addData(scen@modInp@parameters[['year']], 
                                              as.numeric(approxim[['year']]))
  scen@modInp@parameters[['mMidMilestone']] <- addData(scen@modInp@parameters[['mMidMilestone']], 
                                                       data.frame(year = scen@model@sysInfo@milestone$mid))
  # Fill slice
  scen@model@sysInfo@slice <- .init_slice(scen@model@sysInfo@slice)
  scen@modInp@parameters[['slice']] <- addData(scen@modInp@parameters[['slice']], 
                                               scen@model@sysInfo@slice@all_slice)
  # Fill region
  scen@modInp@parameters[['region']] <- addData(scen@modInp@parameters[['region']], scen@model@sysInfo@region)
  
  # List for approximation
  # Generate approxim list, that contain basic data for approximation
  xx <- c(obj@sysInfo@milestone$mid[-1] - obj@sysInfo@milestone$mid[-nrow(obj@sysInfo@milestone)], 1)
  names(xx) <-  obj@sysInfo@milestone$mid
  approxim <- list(
    region = scen@model@sysInfo@region,
    year   = scen@model@sysInfo@year,
    slice  = scen@model@sysInfo@slice,
    solver = arg$solver,
    mileStoneYears = scen@model@sysInfo@milestone$mid,
    mileStoneForGrowth = xx
  )
  # Fill basic parameter interplotaion from sysInfo
  scen@modInp <- .read_default_data(scen@modInp, scen@model@sysInfo)
  
  .get_map_commodity_slice_map
  commodity_slice_map <- list()
  # add set 
  for(i in seq(along = obj@data)) {
    for(j in seq(along = obj@data[[i]]@data)) { #if (class(obj@data[[i]]@data[[j]]) == 'technology') {
      prec <- add_name(prec, obj@data[[i]]@data[[j]], approxim = approxim)
      if (class(obj@data[[i]]@data[[j]]) == 'commodity') {
        if (length(obj@data[[i]]@data[[j]]@slice) == 0) 
          obj@data[[i]]@data[[j]]@slice <- approxim$slice@default_slice_level
        commodity_slice_map[[obj@data[[i]]@data[[j]]@name]] <- obj@data[[i]]@data[[j]]@slice
      }
    }
  }
  approxim$commodity_slice_map <- commodity_slice_map
  prec@set <- lapply(prec@parameters[sapply(prec@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])
  # assign('approxim', approxim, globalenv())
  prec@gams.equation <- list()
  cat('Generating model input files ')
  # Fill DB main data
  if (n.threads > 1) {
    prorgess_bar_p <- proc.time()[3]
    tryCatch({
      cl <- makePSOCKcluster(rep('localhost', n.threads))
      ll <- list()
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
    for(i in names(prec@parameters)) {
      hh <- sapply(prclst, function(x) if (x@parameters[[i]]@nValues == -1) 
        nrow(x@parameters[[i]]@data) else x@parameters[[i]]@nValues)
      if (prec@parameters[[i]]@nValues == -1) nn <- nrow(prec@parameters[[i]]@data) else 
        nn <- prec@parameters[[i]]@nValues
      hh <- hh - nn
      n0 <- nn
      fl <- seq(along = hh)[hh != 0]
      if (length(fl) != 0) {
        prec@parameters[[i]]@data[nn + 1:sum(hh), ] <- NA
        for(j in fl) {
          prec@parameters[[i]]@data[nn + 1:hh[j], ] <- prclst[[j]]@parameters[[i]]@data[n0 + 1:hh[j], ]
          nn <- nn + hh[j]
        }
        if (prec@parameters[[i]]@nValues != -1) prec@parameters[[i]]@nValues <- nn
        if (i == 'group' && nn != 0) {
          if (prec@parameters[[i]]@nValues != -1) {
            gr <- unique(prec@parameters[[i]]@data[seq(length.out = prec@parameters[[i]]@nValues), 1])
            prec@parameters[[i]]@data[, 1] <- NA
            prec@parameters[[i]]@data[1:length(gr), 1] <- gr
            prec@parameters[[i]]@nValues <- length(gr)
          } else {
            gr <- unique(prec@parameters[[i]]@data[, 1])
            prec@parameters[[i]]@data <- prec@parameters[[i]]@data[1:length(gr),, drop = FALSE]
            prec@parameters[[i]]@data[, 1] <- gr
          }
        }
      }
    }
    # add statement set/parameter
    for(i in seq_along(prclst)) {
      for(j in names(prclst[[i]]@parameters)[!(names(prclst[[i]]@parameters) %in% names(prec@parameters))]) {
        prec@parameters[[j]] <- prclst[[i]]@parameters[[j]]
      }
    }    
    # add statement equation
    for(i in seq_along(prclst)) {
      if (any(names(prclst[[i]]@gams.equation) %in% names(prec@gams.equation))) {
        stop(paste0('There are duplicat statements "', paste0(names(prec@gams.equation)[!(
          names(prec@gams.equation) %in% names(prclst[[i]]@gams.equation))], collapse = '", "'), '"'))
      }
      for(j in names(prclst[[i]]@gams.equation)) {
        prec@gams.equation[[j]] <- prclst[[i]]@gams.equation[[j]]  
      }
    }
    cat(' ', round(proc.time()[3] - prorgess_bar_p, 2), 's\n')
    prclst <- NULL
  } else if (n.threads == 1) {
    prorgess_bar <- sapply(obj@data, function(x) length(x@data))
    if (is.list(prorgess_bar)) prorgess_bar <- 0 else prorgess_bar <- sum(prorgess_bar)
    prorgess_bar_0 <- 0
    prorgess_bar_dl <- (prorgess_bar + 50 - 1) %/% 50
    hh <- sum(sapply(obj@data, function(x) length(x@data)))
    k <- 0
    prorgess_bar_p <- proc.time()[3]
    # assign('approxim_test', approxim, globalenv())
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
  #    for(i in seq(along = prec@parameters)) {
  #      if (prec@parameters[[i]]@nValues != 0) {
  #          prec@parameters[[i]]@data <- prec@parameters[[i]]@data[1:prec@parameters[[i]]@nValues,, drop = FALSE]
  #      }
  #    }
  # assign('prec', prec, globalenv())
  #####################################################################################
  # Handle data
  #####################################################################################
  # Check slots
  check_set <- function(set, alias = NULL) {
    if (is.null(alias)) alias <- set
    ss <- prec@parameters[[set]]@data[, set]
    for(al in alias) {
      for(i in 1:length(prec@parameters)) {
        if (any(prec@parameters[[i]]@dimSetNames == al) 
            && !all(getSet(prec@parameters[[i]], al) %in% ss)) {
          dd <- getSet(prec@parameters[[i]], al)[!(getSet(prec@parameters[[i]], al) %in% ss)]
          dd <- prec@parameters[[i]]@data[prec@parameters[[i]]@data[, set] %in% dd, , drop = FALSE]
          stop(paste('Unknown ', set, ' in slot ', prec@parameters[[i]]@name, '\n', 
                     paste(apply(dd, 1, function(x) paste(x, collapse = '.')), collapse = '\n'), 
                     '\n', sep = ''))               
        }
      }
    }
  }
  # Additional for compatibility with GLPK
  check_set('comm', c('comm', 'commp', 'acomm'))
  for(i in c('expp', 'imp', 'tech', 'trade', 'sup', 'weather', 'group', 'region', 'year', 'slice')) check_set(i)
  if (length(obj@LECdata) != 0) {
    prec@parameters$mLECRegion <- addMultipleSet(prec@parameters$mLECRegion, obj@LECdata$region)
    if (length(obj@LECdata$pLECLoACT) == 1) {
      prec@parameters$pLECLoACT <- addData(prec@parameters$pLECLoACT, 
                                           data.frame(region = obj@LECdata$region, value = obj@LECdata$pLECLoACT))
    }
  }
  ## Constrain
  yy <- c('tech', 'sup', 'weather', 'stg', 'expp', 'imp', 'trade', 'group', 'comm', 'region', 'year', 'slice')
  appr <- lapply(yy, function(x) prec@parameters[[x]]@data[[x]])
  names(appr) <- yy
  appr$group <- appr$group[!is.na(appr$group)]
  # ---------------------------------------------------------------------------------------------------------  
  # Fix to previous data
  # ---------------------------------------------------------------------------------------------------------  
  if (any(names(arg) == 'fix_data')) {
    ll <- c("vTechUse", "vTechNewCap", "vTechRetiredCap",# "vTechRetrofitCap", "vTechUpgradeCap", 
            "vTechCap", "vTechAct", 
            "vTechInp", "vTechOut", "vTechAInp", "vTechAOut", "vSupOut", 
            "vDemInp", "vDummyImport", "vDummyExport", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageCap", 
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
      prec@parameters[[gsub('^.', 'mPreDef', i)]] <- 
        addData(prec@parameters[[gsub('^.', 'mPreDef', i)]], gg[, -ncol(gg)])
      gg <- gg[gg[, 'value'] != 0,] 
      prec@parameters[[gsub('^.', 'preDef', i)]] <- addData(prec@parameters[[gsub('^.', 'preDef', i)]], gg)
      
    }
    arg <- arg[names(arg) != 'fix_data', drop = FALSE]
    arg <- arg[names(arg) != 'fix_scenario', drop = FALSE]
    arg <- arg[names(arg) != 'fix_year', drop = FALSE]
  }
  # pzz <- proc.time()[3]
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
  gg <- .getTotalParameterData(prec, 'pDiscount', need.reduce = FALSE)
  gg <- gg[sort(gg$year, index.return = TRUE)$ix,, drop = FALSE]
  ll <- gg[0,, drop = FALSE]
  for(l in unique(gg$region)) {
    dd <- gg[gg$region == l,, drop = FALSE]
    dd$value <- cumprod(1 / (1 + dd$value))
    ll <- rbind(ll, dd)
  }
  prec@parameters[['pDiscountFactor']] <- addData(prec@parameters[['pDiscountFactor']], ll)
  hh <- gg[gg$year == as.character(max(obj@sysInfo@year)), -2]
  hh <- hh[hh$value == 0, 'region', drop = FALSE]
  # Add mDiscountZero - zero discount rate in final period
  if (nrow(hh) != 0) {
    prec@parameters[['mDiscountZero']] <- addData(prec@parameters[['mDiscountZero']], hh)
  } 
  LL1 <- proc.time()[3]
  ##!!!!!!!!!!!!!!!!!!!!!
  # For remove emission equation
  g1 <- getParameterData(prec@parameters$pTechEmisComm)
  #      if (prec@parameters[['pTechEmisComm']]@nValues != -1)
  #        g1 <- g1[seq(length.out = prec@parameters[['pTechEmisComm']]@nValues),, drop = FALSE]
  g2 <- getParameterData(prec@parameters$pEmissionFactor)
  #      if (prec@parameters[['pEmissionFactor']]@nValues != -1)
  #        g2 <- g2[seq(length.out = prec@parameters[['pEmissionFactor']]@nValues),, drop = FALSE]
  g1 <- g1[g1$value != 0, , drop = FALSE]
  for(g in unique(g2$comm)) {
    cmd <- g2[g2$comm == g, 'commp']
    tec <- unique(g1[g1$comm %in% cmd, 'tech'])
    prec@parameters$mTechEmitedComm <- addData(prec@parameters$mTechEmitedComm,
                                               data.frame(tech = tec, comm = rep(g, length(tec))))
  }
  #  Remove unused technology
  # Early reteirment
  if (!obj@early.retirement) {
    prec@parameters$mTechRetirement@data <- prec@parameters$mTechRetirement@data[0,, drop = FALSE]
    if (prec@parameters$mTechRetirement@nValues != -1)
      prec@parameters$mTechRetirement@nValues <- 0
  }
  # up to year
  if (!is.null(startYear)) {
    assign('prec.before.startYear', prec, globalenv()) # prec = prec.before.startYear
    prec0 <- prec
    # begin
    mile.stone <- prec@parameters$mMidMilestone@data$year
    mile.stone.after <- mile.stone[mile.stone >= startYear] 
    stay.year.begin <- min(prec@parameters$mStartMilestone@data[
      prec@parameters$mStartMilestone@data$year %in% mile.stone.after, 'yearp'], na.rm = TRUE)
    stay.year.end <- max(prec@parameters$mEndMilestone@data[
      prec@parameters$mEndMilestone@data$year %in% mile.stone.after, 'yearp'], na.rm = TRUE)
    
    mile.stone.length <- (prec@parameters$mEndMilestone@data$yearp - prec@parameters$mStartMilestone@data$yearp + 1)
    names(mile.stone.length) <- prec@parameters$mEndMilestone@data$year
    
    # Move new capacity before up to to stock (technology)
    tech.new.cap <- fixTo@modOut@variables$vTechNewCap
    tech.stock <- energyRt:::.getTotalParameterData(prec, 'pTechStock')
    tech.new.cap <- tech.new.cap[tech.new.cap$year <= startYear,, drop = FALSE]
    tech.life <- energyRt:::.getTotalParameterData(prec, 'pTechOlife')
    olife.tmp <- tech.life$value
    names(olife.tmp) <- paste0(tech.life$tech, '#', tech.life$region)
    tech.new.cap$olife <- olife.tmp[paste0(tech.new.cap$tech, '#', tech.new.cap$region)]
    # add 
    for (yr in mile.stone.after) {
      fl_use <- (yr < tech.new.cap$olife + tech.new.cap$year)
      if (any(fl_use)) {
        tmp <- tech.new.cap[fl_use, c('tech', 'region', 'year', 'value')]
        tmp$year <- yr
        tech.stock <- rbind(tech.stock, tmp)
      } 
    }
    fl <-  tech.stock$year >= startYear
    tech.stock2 <- aggregate(tech.stock[fl, 'value', drop = FALSE], tech.stock[fl, c('tech', 'region', 'year')], sum)
    # have to replace tech.stock2 -> pTechStock
    prec <- energyRt:::.setParameterData(prec, 'pTechStock', tech.stock2)
    # Move new capacity before up to to stock (supply)
    # Chage supply reserve
    sup.res.par <- energyRt:::.getTotalParameterData(prec, 'pSupReserve')
    sup.res.use0 <-fixTo@modOut@variables$vSupOut
    sup.res.use0$type <- 'lo'
    sup.res.use0 <- sup.res.use0[, c("sup", "comm", "region", "year", 'type', 'value')]
    sup.res.use0 <- sup.res.use0[sup.res.use0$year < startYear,, drop = FALSE]
    sup.res.use0$value <- (-sup.res.use0$value * mile.stone.length[as.character(sup.res.use0$year)])
    sup.res.use0 <- sup.res.use0[, c("sup", "comm", "region", 'type', 'value')]
    sup.res.use1 <- sup.res.use0
    sup.res.use0$type <- 'up'
    sup.res.use <- rbind(sup.res.use0, sup.res.use1, sup.res.par)
    sup.res.use2 <- aggregate(sup.res.use[, 'value', drop = FALSE], sup.res.use[, c('sup', 'comm', 'region', 'type')], sum)
    sup.res.use2$value[sup.res.use2$value < 0] <- 0
    prec <- energyRt:::.setParameterData(prec, 'pSupReserve', sup.res.use2)
    
    als_year <- c('year', 'yearn', 'yearp', 'yeare')
    for (nn in names(prec@parameters)) {
      if (any(prec@parameters[[nn]]@dimSetNames %in% als_year)) {
        clmn <- als_year[als_year %in% prec@parameters[[nn]]@dimSetNames]
        if (prec@parameters[[nn]]@nValues != -1) {
          prec@parameters[[nn]]@data <- prec@parameters[[nn]]@data[seq_len(prec@parameters[[nn]]@nValues),, drop = FALSE]
        }
        for (cc in clmn)
          prec@parameters[[nn]]@data <- prec@parameters[[nn]]@data[prec@parameters[[nn]]@data[, cc] >= stay.year.begin,, drop = FALSE]
        if (prec@parameters[[nn]]@nValues != -1) {
          prec@parameters[[nn]]@nValues <- nrow(prec@parameters[[nn]]@data)
        }
      }
    }
    assign('prec.after.startYear', prec, globalenv())
  }
  # Reduce mapping
  prec <- .reduce_mapping(prec)  
  # Have to add some code for scenario
  scen@modInp <- prec
  
  scen
}
