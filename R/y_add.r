

################################################################################
# Add commodity
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'commodity',
  approxim = 'list'), function(obj, app, approxim) {
  cmd <- energyRt:::.upper_case(app)
  cmd <- stayOnlyVariable(cmd, approxim$region, 'region')
  browser()
  #obj@parameters[['mCommSlice']] <- addData(obj@parameters[['mCommSlice']], data.frame(comm = rep(cmd@name))
  #  if (!energyRt:::.chec_correct_name(cmd@name)) {
#    stop(paste('Incorrect commodity name "', cmd@name, '"', sep = ''))
#  }
##    cat(cmd@name, '\n')
#
#  # Add commodity to set
#  if (isCommodity(obj, cmd@name)) {
#    warning(paste('There is commodity name "', cmd@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousCommodity(obj, cmd@name)
#  }
  # Add ems_from & pEmissionFactor
  dd <- cmd@emis[, c('comm', 'comm', 'mean'), drop = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c('comm', 'commp', 'value')
    dd[, 'commp'] <- cmd@name
    dd[, 'value'] <- as.numeric(dd$value) # Must be remove later
    obj@parameters[['pEmissionFactor']] <- addData(obj@parameters[['pEmissionFactor']], dd)
  }

  dd <- cmd@agg[, c('comm', 'comm', 'agg'), drop = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c('comm', 'commp', 'value')
    dd[, 'comm'] <- cmd@name
    dd[, 'value'] <- as.numeric(dd$value) # Must be remove later
    obj@parameters[['pAggregateFactor']] <- addData(obj@parameters[['pAggregateFactor']], dd)
  }

  # Define mUpComm | mLoComm | mFxComm
  if (cmd@limtype == 'UP')
    obj@parameters[['mUpComm']] <- addData(obj@parameters[['mUpComm']], data.frame(comm = cmd@name))
  if (cmd@limtype == 'LO')
    obj@parameters[['mLoComm']] <- addData(obj@parameters[['mLoComm']], data.frame(comm = cmd@name))
  if (cmd@limtype == 'FX')
    obj@parameters[['mFxComm']] <- addData(obj@parameters[['mFxComm']], data.frame(comm = cmd@name))
  obj
})


################################################################################
# Add apporoximation to standart view
################################################################################
fix_approximation_list <- function(approxim, lev = NULL, comm = NULL) {
  if (!is.null(comm)) {
    if (!is.null(comm)) stop('Internal error: 66a37cde-24e2-4ac5-ab24-b79e0f603bf7')
    lev <- approxim$commodity_slice_map[[comm]]
  }
  approxim$slice <- approxim$slice[[approxim$slice$slice_level[[lev]]]]
  approxim
}

################################################################################
# Add demand
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'demand',
  approxim = 'list'), function(obj, app, approxim) {     
  dem <- energyRt:::.upper_case(app)
  dem <- stayOnlyVariable(dem, approxim$region, 'region')
  approxim <- fix_approximation_list(approxim, comm = dem@commodity)
#  if (!energyRt:::.chec_correct_name(dem@name)) {
#    stop(paste('Incorrect demand name "', dem@name, '"', sep = ''))
#  }
#  if (isDemand(obj, dem@name)) {
#    warning(paste('There is demand name "', dem@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousDemand(obj, dem@name)
#  }
#  obj@parameters[['dem']] <- addData(obj@parameters[['dem']], dem@name)
  obj@parameters[['mDemComm']] <- addData(obj@parameters[['mDemComm']],
      data.frame(dem = dem@name, comm = dem@commodity)) 
  obj@parameters[['pDemand']] <- addData(obj@parameters[['pDemand']],
      simpleInterpolation(dem@dem, 'dem',
      obj@parameters[['pDemand']], approxim, 'dem', dem@name))
  obj
})

################################################################################
# Add supply
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'supply',
  approxim = 'list'), function(obj, app, approxim) {
    sup <- energyRt:::.upper_case(app)
    approxim <- fix_approximation_list(approxim, comm = sup@commodity, lev = sup@slice)
    if (!is.null(sup@region)) {
    approxim$region <- approxim$region[approxim$region %in% sup@region]
    ss <- getSlots('supply')
    ss <- names(ss)[ss == 'data.frame']
    ss <- ss[sapply(ss, function(x) (any(colnames(slot(sup, x)) == 'region') 
      && any(!is.na(slot(sup, x)$region))))]
    for(sl in ss) if (any(!is.na(slot(sup, sl)$region) & !(slot(sup, sl)$region %in% sup@region))) {
      rr <- !is.na(slot(sup, sl)$region) & !(slot(sup, sl)$region %in% sup@region)
      warning(paste('There are data supply "', sup@name, '" for unused region: "', 
        paste(unique(slot(sup, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
      slot(sup, sl) <- slot(sup, sl)[!rr,, drop = FALSE]
    }
    obj@parameters[['mSupSpan']] <- addData(obj@parameters[['mSupSpan']],
        data.frame(sup = rep(sup@name, length(sup@region)), region = sup@region))
  } else {
    obj@parameters[['mSupSpan']] <- addData(obj@parameters[['mSupSpan']],
        data.frame(sup = rep(sup@name, length(approxim$region)), region = approxim$region))
  }
  sup <- stayOnlyVariable(sup, approxim$region, 'region')
#  if (!energyRt:::.chec_correct_name(sup@name)) {
#    stop(paste('Incorrect supply name "', sup@name, '"', sep = ''))
#  }
#  if (isSupply(obj, sup@name)) {
#    warning(paste('There is supply name "', sup@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousSupply(obj, sup@name)
#  }    
#  obj@parameters[['sup']] <- addData(obj@parameters[['sup']], sup@name)
  obj@parameters[['mSupComm']] <- addData(obj@parameters[['mSupComm']],
      data.frame(sup = sup@name, comm = sup@commodity))
  obj@parameters[['pSupCost']] <- addData(obj@parameters[['pSupCost']],
      simpleInterpolation(sup@availability, 'cost',
          obj@parameters[['pSupCost']], approxim, 'sup', sup@name))
  obj@parameters[['pSupReserve']] <- addData(obj@parameters[['pSupReserve']],
      data.frame(sup = sup@name, value = sup@reserve))
  obj@parameters[['pSupAva']] <- addData(obj@parameters[['pSupAva']],
            multiInterpolation(sup@availability, 'ava',
            obj@parameters[['pSupAva']], approxim, 'sup', sup@name))
  obj
})

################################################################################
# Add export
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
  exp <- energyRt:::.upper_case(app)
  exp <- stayOnlyVariable(exp, approxim$region, 'region')
  approxim <- fix_approximation_list(approxim, comm = exp@commodity, lev = exp@slice)
  #  if (!energyRt:::.chec_correct_name(exp@name)) {
#    stop(paste('Incorrect export name "', exp@name, '"', sep = ''))
#  }
#  if (isExport(obj, exp@name)) {
#    warning(paste('There is export name "', exp@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousExport(obj, exp@name)
#  }    
#  obj@parameters[['expp']] <- addData(obj@parameters[['expp']], exp@name)
  obj@parameters[['mExpComm']] <- addData(obj@parameters[['mExpComm']],
      data.frame(expp = exp@name, comm = exp@commodity))
  obj@parameters[['pExportRowPrice']] <- addData(obj@parameters[['pExportRowPrice']],
      simpleInterpolation(exp@exp, 'price',
          obj@parameters[['pExportRowPrice']], approxim, 'expp', exp@name))
  obj@parameters[['pExportRowRes']] <- addData(obj@parameters[['pExportRowRes']],
      data.frame(expp = exp@name, value = exp@reserve))
  obj@parameters[['pExportRow']] <- addData(obj@parameters[['pExportRow']],
            multiInterpolation(exp@exp, 'exp',
            obj@parameters[['pExportRow']], approxim, 'expp', exp@name))
  obj
})

################################################################################
# Add import
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'import',
  approxim = 'list'), function(obj, app, approxim) {
  imp <- energyRt:::.upper_case(app)
  imp <- stayOnlyVariable(imp, approxim$region, 'region')
  approxim <- fix_approximation_list(approxim, comm = imp@commodity, lev = imp@slice)
  #  if (!energyRt:::.chec_correct_name(imp@name)) {
#    stop(paste('Incorrect import name "', imp@name, '"', sep = ''))
#  }
#  if (isImport(obj, imp@name)) {
#    warning(paste('There is import name "', imp@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousImport(obj, imp@name)
#  }    
#  obj@parameters[['imp']] <- addData(obj@parameters[['imp']], imp@name)
  obj@parameters[['mImpComm']] <- addData(obj@parameters[['mImpComm']],
      data.frame(imp = imp@name, comm = imp@commodity))
  obj@parameters[['pImportRowPrice']] <- addData(obj@parameters[['pImportRowPrice']],
      simpleInterpolation(imp@imp, 'price',
          obj@parameters[['pImportRowPrice']], approxim, 'imp', imp@name))
  obj@parameters[['pImportRowRes']] <- addData(obj@parameters[['pImportRowRes']],
      data.frame(imp = imp@name, value = imp@reserve))
  obj@parameters[['pImportRow']] <- addData(obj@parameters[['pImportRow']],
            multiInterpolation(imp@imp, 'imp',
            obj@parameters[['pImportRow']], approxim, 'imp', imp@name))
  obj
})

################################################################################
# Add constrain
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'constrain',
  approxim = 'list'), function(obj, app, approxim) {
  app <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(app@name)) {
    stop(paste('Incorrect constrain name "', app@name, '"', sep = ''))
  }
  if (isConstrain(obj, app@name)) {
    stop(paste('There is constrain name "', app@name,
       '" now', sep = ''))
#    warning(paste('There is constrain name "', app@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousConstrain(obj, app@name)
  }
##  obj@parameters[['sup']] <- addData(obj@parameters[['sup']], sup@name)
##  obj@parameters[['mSupComm']] <- addData(obj@parameters[['mSupComm']],
##      data.frame(sup = sup@name, comm = sup@commodity))
##  obj@parameters[['pSupCost']] <- addData(obj@parameters[['pSupCost']],
##      simpleInterpolation(sup@availability, 'cost',
##          obj@parameters[['pSupCost']], approxim, 'sup', sup@name))
##  obj@parameters[['pSupReserve']] <- addData(obj@parameters[['pSupReserve']],
##      data.frame(sup = sup@name, value = sup@reserve))
##  obj@parameters[['pSupAva']] <- addData(obj@parameters[['pSupAva']],
##            multiInterpolation(sup@availability, 'ava',
##            obj@parameters[['pSupAva']], approxim, 'sup', sup@name))
#  if (!energyRt:::.chec_correct_name(app@name)) {
#    stop(paste('Incorrect technology name "', app@name, '"', sep = ''))
#  }
#  if (isConstrain(obj, app@name)) {
#    warning(paste('There is constrain name "', app@name,
#        '" now, all previous information will be removed', sep = ''))
#  }
#  tt <- showEquation(app, approxim)
#  obj@constrain[[app@name]] <- tt 
  if (any(names(app@for.each) == 'year') && !is.null(app@for.each$year) && 
    (max(app@for.each$year) < min(approxim$year) || min(app@for.each$year) > max(approxim$year))) {
     return(obj)
  }
  if (any(names(app@for.sum) == 'year') && !is.null(app@for.sum$year) && 
    (max(app@for.sum$year) < min(approxim$year) || min(app@for.sum$year) > max(approxim$year))) {
     return(obj)
  }
  if (app@type == 'tax') {
      approxim2 <- approxim
      for(cc in names(app@for.each)) if (!is.null(app@for.each[[cc]])) {
        approxim2[[cc]] <- app@for.each[[cc]]
      }
     obj@parameters[['pTaxCost']] <- addData(obj@parameters[['pTaxCost']],
        simpleInterpolation(app@rhs, 'tax',
         obj@parameters[['pTaxCost']], approxim2, 'comm', app@comm))
  } else
  if (app@type == 'subs') {
      approxim2 <- approxim
      for(cc in names(app@for.each)) if (!is.null(app@for.each[[cc]])) {
        approxim2[[cc]] <- app@for.each[[cc]]
      }
     obj@parameters[['pSubsCost']] <- addData(obj@parameters[['pSubsCost']],
        simpleInterpolation(app@rhs, 'subs',
         obj@parameters[['pSubsCost']], approxim2, 'comm', app@comm))
  } else {
    # Define lhs equation type
    ccc <- c("comm", "region", "year", "slice")
    if (app@type %in% c('capacity', 'newcapacity', 'invcost', 'eac', 'fixom', 'growth.capacity', 
      'growth.newcapacity', 'growth.invcost', 'growth.eac', 'growth.fixom')) ccc <- c("region", "year")
    if (app@type %in% c('activity', 'growth.activity')) ccc <- c("region", "year", "slice")
    # capacity newcapacity activity input output sharein shareout
    if (app@type %in% c('growth.output', 'output', 'shareout')) before <- 'Out' else
    if (app@type %in% c('growth.input', 'input', 'sharein'))   before <- 'Inp' else
    if (app@type %in% c('growth.capacity', 'capacity')) before <- 'Cap' else
    if (app@type %in% c('growth.newcapacity', 'newcapacity')) before <- 'NewCap' else 
    if (app@type %in% c('growth.invcost', 'invcost')) before <- 'Inv' else
    if (app@type %in% c('growth.varom', 'varom')) before <- 'Varom' else
    if (app@type %in% c('growth.varom', 'actvarom')) before <- 'ActVarom' else
    if (app@type %in% c('growth.varom', 'cvarom')) before <- 'CVarom' else
    if (app@type %in% c('growth.varom', 'avarom')) before <- 'AVarom' else
    if (app@type %in% c('growth.fixom', 'fixom')) before <- 'Fixom' else
    if (app@type %in% c('growth.balance', 'balance')) before <- 'Balance' else
    if (app@type %in% c('growth.activity', 'activity')) before <- 'Act' else
    if (app@type %in% c('growth.eac', 'eac')) before <- 'Eac' else stop('Unknown constrain type')
    ast <- c(names(app@for.sum), names(app@for.each))[!(c(names(app@for.sum), names(app@for.each)) %in% ccc)] 
    if (length(ast) > 1) stop('Wrong constrain') else
    if (length(ast) == 1) {
      before <- paste(before, toupper(substr(ast, 1, 1)), substr(ast, 2, nchar(ast)), sep = '')
      if (any(names(app@for.each) == ast)) {
        obj@parameters[['mCnsLType']] <- addData(obj@parameters[['mCnsLType']], 
             data.frame(cns = app@name, stringsAsFactors = FALSE))
      }
    }
    FL <- TRUE
    for(cc in ccc) if (nrow(obj@parameters[[cc]]@data) == 0) FL <- FALSE
    if (length(ast) != 0 && nrow(obj@parameters[[ast]]@data) == 0) FL <- FALSE
   if (FL) {
      obj@parameters[['cns']] <- addData(obj@parameters[['cns']], app@name)
      obj@parameters[[paste('mCns', before, sep = '')]] <- 
        addData(obj@parameters[[paste('mCns', before, sep = '')]], 
           data.frame(cns = app@name, stringsAsFactors = FALSE))  
      if (app@type == 'sharein')  
        obj@parameters[['mCnsRhsTypeShareIn']] <- 
           addData(obj@parameters[['mCnsRhsTypeShareIn']], 
             data.frame(cns = app@name, stringsAsFactors = FALSE)) else
      if (app@type == 'shareout')  obj@parameters[['mCnsRhsTypeShareOut']] <- 
        addData(obj@parameters[['mCnsRhsTypeShareOut']], 
          data.frame(cns = app@name, stringsAsFactors = FALSE)) else
      if (any(grep('growth', as.character(app@type))))  
        obj@parameters[['mCnsRhsTypeGrowth']] <- 
           addData(obj@parameters[['mCnsRhsTypeGrowth']], 
             data.frame(cns = app@name, stringsAsFactors = FALSE)) else
              obj@parameters[['mCnsRhsTypeConst']] <- addData(obj@parameters[['mCnsRhsTypeConst']], 
                  data.frame(cns = app@name, stringsAsFactors = FALSE))
      for(cc in c(ccc, ast[length(ast) == 1])) {
        if (length(ast) == 1 && cc == ast) {
          if (cc %in% names(app@for.sum)) {
            if (is.null(app@for.sum[[cc]])) ll <- obj@parameters[[cc]]@data[, cc] else
              ll <- app@for.sum[[cc]]
          } else {
            if (is.null(app@for.each[[cc]])) ll <- obj@parameters[[cc]]@data[, cc] else
              ll <- app@for.each[[cc]]
            }
        } else if (cc %in% names(app@for.sum)) {
          if (is.null(app@for.sum[[cc]])) ll <- obj@parameters[[cc]]@data[, cc] else
            ll <- app@for.sum[[cc]]
          nn <- paste('mCnsLhs', toupper(substr(cc, 1, 1)), substr(cc, 2, nchar(cc)), sep = '')
          obj@parameters[[nn]] <- addData(obj@parameters[[nn]], data.frame(cns = app@name,
            stringsAsFactors = FALSE))
        } else if (cc %in% names(app@for.each)) {
          if (is.null(app@for.each[[cc]])) ll <- obj@parameters[[cc]]@data[, cc] else
            ll <- app@for.each[[cc]]
          approxim[[cc]] <- ll
        } else stop('Wrong constrain')
        if (cc == 'year') ll <- ll[ll %in% obj@parameters$year@data[, 'year']] 
        nn <- paste('mCns', toupper(substr(cc, 1, 1)), substr(cc, 2, nchar(cc)), sep = '')
        dtt <- data.frame(cns = rep(app@name, length(ll)), ll, stringsAsFactors = FALSE)
        colnames(dtt) <- c('cns', cc)
        obj@parameters[[nn]] <- addData(obj@parameters[[nn]], dtt)
      }
      # Choose technology output
      if (any(ast == 'tech')) {
        if (app@type %in% c('growth.output', 'output', 'shareout')) {
          if (app@cout) obj@parameters[['mCnsTechCOut']] <- addData(obj@parameters[['mCnsTechCOut']], 
            data.frame(cns = app@name, stringsAsFactors = FALSE))
          if (app@aout) obj@parameters[['mCnsTechAOut']] <- addData(obj@parameters[['mCnsTechAOut']], 
            data.frame(cns = app@name, stringsAsFactors = FALSE))
          if (app@emis) obj@parameters[['mCnsTechEmis']] <- addData(obj@parameters[['mCnsTechEmis']], 
            data.frame(cns = app@name, stringsAsFactors = FALSE))
        } else if (app@type %in% c('growth.input', 'input', 'sharein')) {
          if (app@cinp) obj@parameters[['mCnsTechCInp']] <- addData(obj@parameters[['mCnsTechCInp']], 
            data.frame(cns = app@name, stringsAsFactors = FALSE))
          if (app@ainp) obj@parameters[['mCnsTechAInp']] <- addData(obj@parameters[['mCnsTechAInp']], 
            data.frame(cns = app@name, stringsAsFactors = FALSE))
        }
      }
      # Define rhs type
      if (app@eq == '>=') obj@parameters[['mCnsGe']] <- addData(obj@parameters[['mCnsGe']], 
          data.frame(cns = app@name, stringsAsFactors = FALSE))
      if (app@eq == '<=') obj@parameters[['mCnsLe']] <- addData(obj@parameters[['mCnsLe']], 
          data.frame(cns = app@name, stringsAsFactors = FALSE))
    }
    # Define rhs
        year_range <- range(obj@parameters$year@data[, 'year'])
        approxim <- approxim[names(approxim) %in% names(app@for.each)] 
        if (any(colnames(approxim) == 'year')) {
          year_range <- c(max(c(min(approxim$year), year_range[1])), min(c(max(approxim$year), year_range[2]))) 
        }
        if (any(names(app@for.each) == 'year') && !is.null(app@for.each$year)) {
          approxim$year <- min(app@for.each$year):max(app@for.each$year)
          year_range <- c(max(c(min(approxim$year), year_range[1])), min(c(max(approxim$year), year_range[2]))) 
        }
        for(i in names(app@for.each)[!(names(app@for.each) %in% names(approxim))]) 
            approxim[[i]] <- app@for.each[[i]]
        if (length(approxim) != 0) {
          rhs <- interpolation(app@rhs, 'rhs', approxim = approxim, year_range = year_range,
              rule = app@rule, defVal = app@defVal)
          colnames(rhs)[ncol(rhs)] <- 'value'
          rhs <- cbind(cns = rep(app@name, nrow(rhs)), rhs)
        } else {
          if (nrow(app@rhs) == 0) 
            rhs <- data.frame(cns = app@name, value = app@defVal, stringsAsFactors = FALSE) else
          if (nrow(app@rhs) == 1) 
            rhs <- data.frame(cns = app@name, value = app@rhs$rhs, stringsAsFactors = FALSE) else
          stop('Wrong rhs constrain: "', app@name, '"')
        }
        if (any(colnames(rhs) == 'year')) rhs$year <- as.numeric(as.character(rhs$year))
        if (all(names(app@for.each) != ast)) ii <- '' else ii <- paste(toupper(substr(ast, 1, 1)), 
          substr(ast, 2, nchar(ast)), sep = '')
        nn <- paste('pRhs', ii, paste(toupper(substr(ccc[ccc %in% names(app@for.each)], 1, 1)), 
          collapse = ''), sep = '')
      obj@parameters[[nn]] <- addData(obj@parameters[[nn]], rhs[, colnames(obj@parameters[[nn]]@data)])
    # Define sharein & shareout type
  }
  obj
})

################################################################################
# Add technology
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'technology',
  approxim = 'list'), function(obj, app, approxim) {
#  mTechInpComm(tech, comm)       Input commodity
#  mTechOutComm(tech, comm)       Output commodity
#  mTechCapComm(tech, comm)       Capacity fix commodity
#  mTechActComm(tech, comm)       Activity fix commodity
#  mTechUseComm(tech, comm)       Activity fix commodity
#  mTechOneComm(tech, comm)    Single commodity
#  mTechGroupComm(tech, group, comm)  Share (group) commodity connect to group
#  mTechCapGroup(tech, group)         Group connect with capacity
#  mTechUseGroup(tech, group)         Group connect with use
#  mTechActGroup(tech, group)         Group connect with use
#  mTechInpGroup(tech, group)         Group use for input
#  mTechOutGroup(tech, group)         Group use for output
#  mTechStartYear(tech, region, year) Start year
#  mTechEndYear(tech, region, year)   End year
#  mTechDisable(tech, region)     Disable new technology
#  * Emissions
#  mTechEmisComm(tech, comm)
#  mTechEmitedComm(tech, comm)
#  mUpComm(comm)  PRODUCTION <= CONSUMPTION
#  mLoComm(comm)  PRODUCTION >= CONSUMPTION
#  mFxComm(comm)  PRODUCTION = CONSUMPTION
  tech <- energyRt:::.upper_case(app)
  if (is.null(tech@slice)) {
    tech@slice <- names(approxim$deep)[max(approxim$deep[unique(sapply(c(tech@output$comm, 
       tech@output$comm, tech@aux$acomm), function(x) approxim$commodity_slice_map[x]))])]
  }
  approxim <- fix_approximation_list(approxim, lev = tech@slice)
  if (!is.null(tech@region)) {
    approxim$region <- approxim$region[approxim$region %in% tech@region]
    ss <- getSlots('technology')
    ss <- names(ss)[ss == 'data.frame']
    ss <- ss[sapply(ss, function(x) (any(colnames(slot(tech, x)) == 'region') 
      && any(!is.na(slot(tech, x)$region))))]
    for(sl in ss) if (any(!is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region))) {
      rr <- !is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region)
      warning(paste('There are data technology "', tech@name, '"for unused region: "', 
        paste(unique(slot(tech, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
      slot(tech, sl) <- slot(tech, sl)[!rr,, drop = FALSE]
    }
  }
  tech <- stayOnlyVariable(tech, approxim$region, 'region')
  # Temporary solution for immortality technology
  if (nrow(tech@olife) == 0) {
    tech@olife[1, ] <- NA;
    tech@olife[1, 'olife'] <- Inf;
  }
#  if (!energyRt:::.chec_correct_name(tech@name)) {
#    stop(paste('Incorrect technology name "', tech@name, '"', sep = ''))
#  }
#  if (isTechnology(obj, tech@name)) {
#    warning(paste('There is technology name "', tech@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousTechnology(obj, tech@name)
#  }
#  obj@parameters[['tech']] <- addData(obj@parameters[['tech']], tech@name)
  # Map
  ctype <- checkInpOut(tech)
  # Need choose comm more accuracy
  approxim_comm <- approxim
  approxim_comm[['comm']] <- rownames(ctype$comm)
  if (length(approxim_comm[['comm']]) != 0) {
    obj@parameters[['pTechCvarom']] <- addData(obj@parameters[['pTechCvarom']],
      simpleInterpolation(tech@varom, 'cvarom',
       obj@parameters[['pTechCvarom']], approxim_comm, 'tech', tech@name))
  }
  approxim_acomm <- approxim
  approxim_acomm[['acomm']] <- rownames(ctype$aux)
  if (length(approxim_acomm[['acomm']]) != 0) {
    obj@parameters[['pTechAvarom']] <- addData(obj@parameters[['pTechAvarom']],
      simpleInterpolation(tech@varom, 'avarom',
       obj@parameters[['pTechAvarom']], approxim_acomm, 'tech', tech@name))
  }
  approxim_comm[['comm']] <- rownames(ctype$comm)
  if (length(approxim_comm[['comm']]) != 0) {
    gg <- multiInterpolation(tech@ceff, 'afac',
            obj@parameters[['pTechAfac']], approxim_comm, 'tech', tech@name)
    obj@parameters[['pTechAfac']] <- addData(obj@parameters[['pTechAfac']], gg)
    gg <- gg[gg$type == 'up' & gg$value != Inf, ]
    if (nrow(gg) != 0) 
      obj@parameters[['defpTechAfacUp']] <- addData(obj@parameters[['defpTechAfacUp']],
            gg[, obj@parameters[['defpTechAfacUp']]@dimSetNames])

  }
  gg <- multiInterpolation(tech@afa, 'afa',
            obj@parameters[['pTechAfa']], approxim, 'tech', tech@name)
  obj@parameters[['pTechAfa']] <- addData(obj@parameters[['pTechAfa']], gg)
  gg <- gg[gg$type == 'up' & gg$value != Inf, ]
  if (nrow(gg) != 0) 
      obj@parameters[['defpTechAfaUp']] <- addData(obj@parameters[['defpTechAfaUp']],
            gg[, obj@parameters[['defpTechAfaUp']]@dimSetNames])

  approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input']
  if (length(approxim_comm[['comm']]) != 0) {
    obj@parameters[['pTechCinp2use']] <- addData(obj@parameters[['pTechCinp2use']],
      simpleInterpolation(tech@ceff, 'cinp2use',
       obj@parameters[['pTechCinp2use']], approxim_comm, 'tech', tech@name))
  }
  approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'output']
  if (length(approxim_comm[['comm']]) != 0) {
    obj@parameters[['pTechUse2cact']] <- addData(obj@parameters[['pTechUse2cact']],  
       simpleInterpolation(tech@ceff, 'use2cact',
       obj@parameters[['pTechUse2cact']], approxim_comm, 'tech', tech@name))
    obj@parameters[['pTechCact2cout']] <- addData(obj@parameters[['pTechCact2cout']],
      simpleInterpolation(tech@ceff, 'cact2cout',
       obj@parameters[['pTechCact2cout']], approxim_comm, 'tech', tech@name))
    if (any(!is.na(tech@ceff$cact2cout) & (tech@ceff$cact2cout == 0 | tech@ceff$cact2cout == Inf)))
      stop('cact2cout is not correct ', tech@name)
    if (any(!is.na(tech@ceff$use2cact) & (tech@ceff$use2cact == 0 | tech@ceff$use2cact == Inf)))
      stop('use2cact is not correct ', tech@name)
  }
  approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input' & !is.na(ctype$comm[, 'group'])]
  if (length(approxim_comm[['comm']]) != 0) {
    obj@parameters[['pTechCinp2ginp']] <- addData(obj@parameters[['pTechCinp2ginp']],
      simpleInterpolation(tech@ceff, 'cinp2ginp',
       obj@parameters[['pTechCinp2ginp']], approxim_comm, 'tech', tech@name))
  }
  if (tech@early.retirement) 
     obj@parameters[['mTechRetirement']] <- addData(obj@parameters[['mTechRetirement']], data.frame(tech = tech@name))
  if (length(tech@upgrade.technology) != 0)
     obj@parameters[['mTechUpgrade']] <- addData(obj@parameters[['mTechUpgrade']], 
        data.frame(tech = rep(tech@name, length(tech@upgrade.technology)), techp = tech@upgrade.technology))
  cmm <- rownames(ctype$comm)[ctype$comm$type == 'input'] 
  if (length(cmm) != 0)
    obj@parameters[['mTechInpComm']] <- addData(obj@parameters[['mTechInpComm']],
      data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
  cmm <- rownames(ctype$comm)[ctype$comm$type == 'output']
  if (length(cmm) != 0)
    obj@parameters[['mTechOutComm']] <- addData(obj@parameters[['mTechOutComm']],
      data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
  cmm <- rownames(ctype$comm)[is.na(ctype$comm$group)] 
  if (length(cmm) != 0)
    obj@parameters[['mTechOneComm']] <- addData(obj@parameters[['mTechOneComm']],
      data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
  approxim_comm[['comm']] <- rownames(ctype$comm)[!is.na(ctype$comm$group)]
  if (length(approxim_comm[['comm']]) != 0)
    obj@parameters[['pTechShare']] <- addData(obj@parameters[['pTechShare']],
          multiInterpolation(tech@ceff, 'share',
            obj@parameters[['pTechShare']], approxim_comm, 'tech', tech@name))
  cmm <- rownames(ctype$comm)[ctype$comm$comb != 0]
  if (length(cmm) != 0) {
    obj@parameters[['pTechEmisComm']] <- addData(obj@parameters[['pTechEmisComm']],
      data.frame(tech = rep(tech@name, nrow(ctype$comm)), comm = rownames(ctype$comm),
        value = ctype$comm$comb))
  }
  gpp <- rownames(ctype$group)[ctype$group$type == 'input']
  if (length(gpp) != 0)
    obj@parameters[['mTechInpGroup']] <- addData(obj@parameters[['mTechInpGroup']],
      data.frame(tech = rep(tech@name, length(gpp)), group = gpp))
  gpp <- rownames(ctype$group)[ctype$group$type == 'output']
  if (length(gpp) != 0)
    obj@parameters[['mTechOutGroup']] <- addData(obj@parameters[['mTechOutGroup']],
      data.frame(tech = rep(tech@name, length(gpp)), group = gpp))
  approxim_group <- approxim
  approxim_group[['group']] <- rownames(ctype$group)[ctype$group$type == 'input']
  if (length(approxim_group[['group']]) != 0)
      obj@parameters[['pTechGinp2use']] <- addData(obj@parameters[['pTechGinp2use']],
        simpleInterpolation(tech@geff, 'ginp2use',
          obj@parameters[['pTechGinp2use']], approxim_group, 'tech', tech@name))
  if (nrow(ctype$group) > 0)
    obj@parameters[['group']] <- addMultipleSet(obj@parameters[['group']], rownames(ctype$group))
 fl <- !is.na(ctype$comm$group)
  if (any(fl)) {
    gcomm <- data.frame(tech = rep(tech@name, sum(fl)), group = ctype$comm$group[fl], 
        comm = rownames(ctype$comm)[fl], stringsAsFactors = FALSE)
    obj@parameters[['mTechGroupComm']] <- addData(obj@parameters[['mTechGroupComm']], gcomm)
  }
  if (any(ctype$aux$output)) {    
    cmm <- rownames(ctype$aux)[ctype$aux$output]
    obj@parameters[['mTechAOut']] <- addData(obj@parameters[['mTechAOut']],
      data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
  }
  if (any(ctype$aux$input)) {    
    cmm <- rownames(ctype$aux)[ctype$aux$input]
    obj@parameters[['mTechAInp']] <- addData(obj@parameters[['mTechAInp']],
      data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
  }
  dd <- data.frame(list = c('pTechUse2AOut', 'pTechAct2AOut', 'pTechCap2AOut', 
       'pTechUse2AInp', 'pTechAct2AInp', 'pTechCap2AInp', 'pTechNCap2AInp', 'pTechNCap2AOut'),
    table = c('use2aout', 'act2aout', 'cap2aout', 'use2ainp', 'act2ainp', 'cap2ainp', 'ncap2ainp', 'ncap2aout'),
    stringsAsFactors = FALSE)
  for(i in 1:nrow(dd)) {
    approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
    approxim_comm[['acomm']] <- unique(tech@aeff[!is.na(tech@aeff[, dd[i, 'table']]), 'acomm'])
    if (length(approxim_comm[['acomm']]) != 0) {
       obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
              simpleInterpolation(tech@aeff, dd[i, 'table'], 
                obj@parameters[[dd[i, 'list']]], approxim_comm, 'tech', tech@name))
    }
  }                
                
    # simple & multi
    obj@parameters[['pTechCap2act']] <- addData(obj@parameters[['pTechCap2act']],
      data.frame(tech = tech@name, value = tech@cap2act))
    dd <- data.frame(list = c('pTechOlife', 'pTechFixom', 'pTechInvcost', 'pTechStock',
      'pTechVarom'),
      table = c('olife', 'fixom', 'invcost', 'stock', 'varom'),
      stringsAsFactors = FALSE)
    for(i in 1:nrow(dd)) {
      obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
        simpleInterpolation(slot(tech, dd[i, 'table']),
          dd[i, 'table'], obj@parameters[[dd[i, 'list']]], approxim, 'tech', tech@name))
    }
    if (nrow(tech@aeff) != 0) {
        for(i in 1:4) {
          tech@aeff <- tech@aeff[!is.na(tech@aeff$acomm),]
          ll <- c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout')[i]
          tbl <- c('pTechCinp2AInp', 'pTechCinp2AOut', 'pTechCout2AInp', 'pTechCout2AOut')[i]          
          tbl2 <- c('mTechCinpAInp', 'mTechCinpAOut', 'mTechCoutAInp', 'mTechCoutAOut')[i]     
          yy <- tech@aeff[!is.na(tech@aeff[, ll]), ]
          if (nrow(yy) != 0) {
            approxim_commp <- approxim
            approxim_commp$acomm <- unique(yy$acomm); 
            approxim_commp$comm <- unique(yy$comm)
            obj@parameters[[tbl]] <- addData(obj@parameters[[tbl]],
            simpleInterpolation(yy, ll, obj@parameters[[tbl]], 
                  approxim_commp, 'tech', tech@name))
          }
#            tech@aeff <- tech@aeff[!is.na(tech@aeff$comm) & !is.na(tech@aeff$commp),]
#            for(cmd in approxim_commp$comm) {
#              cmm <- tech@aeff[tech@aeff$comm == cmd & !is.na(tech@aeff[, ll]), 'commp']
#              obj@parameters[[tbl2]] <- addData(obj@parameters[[tbl2]], 
#                  data.frame(tech = rep(tech@name, length(cmm)), comm = rep(cmd, length(cmm)), commp = cmm))
#           }
        }
    }
  
  # Start / End year
  dd <- data.frame(enable = rep(TRUE, length(approxim$region) * length(approxim$year)),
    tech = rep(tech@name, length(approxim$region) * length(approxim$year)),
    region = rep(approxim$region, length(approxim$year)), 
    year = c(t(matrix(rep(approxim$year, length(approxim$region)), length(approxim$year)))), 
    stringsAsFactors = FALSE)   
  dstart <- data.frame(row.names = approxim$region, region = approxim$region, 
    year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(tech@start$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for technology ', tech@name)
    dstart[, 'year'] <- tech@start[fl, 'start']
  }
  if (any(!fl)) {
    dstart[tech@start[!fl, 'region'], 'year'] <- tech@start[!fl, 'start']
  }
  dstart <- dstart[!is.na(dstart$year),, drop = FALSE]
  for(rr in dstart$region) {
    if (!is.na(dstart[rr, 'year']) && any(dd$year < dstart[rr, 'year'])) dd[dd$region == rr & dd$year < dstart[rr, 'year'], 'enable'] <- FALSE
  } 
  dd_able <- dd
  ## end 
  dend <- data.frame(row.names = approxim$region, region = approxim$region, 
    year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(tech@end$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for technology ', tech@name)
    dend[, 'year'] <- tech@end[fl, 'end']
  }
  if (any(!fl)) {
    dend[tech@end[!fl, 'region'], 'year'] <- tech@end[!fl, 'end']
  }
  dend <- dend[!is.na(dend$year),, drop = FALSE]
  for(rr in dend$region) {
    if (any(dd$year > dend[rr, 'year'])) dd[dd$region == rr & dd$year > dend[rr, 'year'], 'enable'] <- FALSE
  }  
  dd <- dd[dd$enable, -1, drop = FALSE]
  obj@parameters[['mTechNew']] <- addData(obj@parameters[['mTechNew']], dd)
  ## life 
  dlife <- data.frame(row.names = approxim$region, region = approxim$region, 
    year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(tech@olife$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for technology ', tech@name)
    dlife[, 'year'] <- tech@olife[fl, 'olife']
  }
  if (any(!fl)) {
    dlife[tech@olife[!fl, 'region'], 'year'] <- tech@olife[!fl, 'olife']
  }
  dlife <- dlife[!is.na(dlife$year),, drop = FALSE]
  for(rr in dlife$region[dlife$region %in% dend$region]) {
    if (any(dd_able$year >= dend[rr, 'year'] + dlife[rr, 'year'])) 
      dd_able[dd_able$region == rr & dd_able$year >= dend[rr, 'year'] + dlife[rr, 'year'], 'enable'] <- FALSE
  }  
  gg <- obj@parameters[["pTechStock"]]@data[!is.na(obj@parameters[["pTechStock"]]@data$tech) & 
     obj@parameters[['pTechStock']]@data$tech == tech@name & 
     obj@parameters[['pTechStock']]@data$value != 0,, drop = FALSE] 
  
  if (nrow(gg) != 0 && any(!dd_able$enable)) {
    for(rr in unique(gg$region)) {
      dd_able[dd_able$region == rr & dd_able$year %in% gg[gg$region == rr, 'year'], 'enable'] <- TRUE
    }
  }   
  dd_able <- dd_able[dd_able$enable, -1, drop = FALSE]
#  cat(tech@name, '\n')
  obj@parameters[['mTechSpan']] <- addData(obj@parameters[['mTechSpan']], dd_able)
  if (all(ctype$comm$type != 'output')) 
    stop('Techology "', tech@name, '", there is not activity commodity')   
  obj
})

################################################################################
# Add sysInfo
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'sysInfo',
  approxim = 'list'), function(obj, app, approxim) {
  obj <- removePreviousSysInfo(obj)
  app <- stayOnlyVariable(app, approxim$region, 'region')
  # Discount
      obj@parameters[['pDiscount']] <- addData(obj@parameters[['pDiscount']],
        simpleInterpolation(app@discount, 'discount',
          obj@parameters[['pDiscount']], approxim))
  approxim_comm <- approxim
  approxim_comm[['comm']] <- obj@parameters$comm@data$comm
  if (length(approxim_comm[['comm']]) != 0) {
    # Dummy import
      obj@parameters[['pDummyImportCost']] <- addData(obj@parameters[['pDummyImportCost']],
        simpleInterpolation(app@debug, 'dummyImport',
          obj@parameters[['pDummyImportCost']], approxim_comm))
    # Dummy export
      obj@parameters[['pDummyExportCost']] <- addData(obj@parameters[['pDummyExportCost']],
        simpleInterpolation(app@debug, 'dummyExport',
          obj@parameters[['pDummyExportCost']], approxim_comm))
#    # Tax
#      obj@parameters[['pTaxCost']] <- addData(obj@parameters[['pTaxCost']],
#        simpleInterpolation(app@tax, 'tax',
#          obj@parameters[['pTaxCost']], approxim_comm))
#    # Subs
#      obj@parameters[['pSubsCost']] <- addData(obj@parameters[['pSubsCost']],
#        simpleInterpolation(app@subs, 'subs',
#          obj@parameters[['pSubsCost']], approxim_comm))
  }
  if (nrow(app@milestone) == 0) {
    app <- setMileStoneYears(app, start = min(app@year), interval = rep(1, length(app@year)))
  }

  obj@parameters[['mMidMilestone']] <- addData(obj@parameters[['mMidMilestone']], 
    data.frame(year = app@milestone$mid))
  obj@parameters[['mStartMilestone']] <- addData(obj@parameters[['mStartMilestone']], 
    data.frame(year = app@milestone$mid, yearp = app@milestone$start))
  obj@parameters[['mEndMilestone']] <- addData(obj@parameters[['mEndMilestone']], 
    data.frame(year = app@milestone$mid, yearp = app@milestone$end))
  obj@parameters[['mMilestoneLast']] <- addData(obj@parameters[['mMilestoneLast']], 
    data.frame(year = max(app@milestone$mid)))

  obj@parameters[['mMilestoneNext']] <- addData(obj@parameters[['mMilestoneNext']], 
    data.frame(year = app@milestone$mid[-nrow(app@milestone)], yearp = app@milestone$mid[-1])) 
  obj@parameters[['mMilestoneHasNext']] <- addData(obj@parameters[['mMilestoneHasNext']], 
    data.frame(year = app@milestone$mid[-nrow(app@milestone)])) 
  obj
})

################################################################################
# Add trade
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'trade',
  approxim = 'list'), function(obj, app, approxim) {
  trd <- energyRt:::.upper_case(app)
  trd <- stayOnlyVariable(trd, approxim$region, 'region') ## ??
  approxim <- fix_approximation_list(approxim, comm = trd@commodity, lev = trd@slice)
  if (is.null(trd@commodity)) stop('There is not commodity for trade flow ', trd@name)
  obj@parameters[['mTradeComm']] <- addData(obj@parameters[['mTradeComm']],
      data.frame(trade = trd@name, comm = trd@commodity))
  if (is.null(trd@source)) rg <- obj@parameters$region@data$region else rg <- trd@source
  obj@parameters[['mTradeSrc']] <- addData(obj@parameters[['mTradeSrc']],
      data.frame(trade = rep(trd@name, length(rg)), region = rg))
  if (is.null(trd@destination)) rg <- obj@parameters$region@data$region else rg <- trd@destination
  obj@parameters[['mTradeDst']] <- addData(obj@parameters[['mTradeDst']],
      data.frame(trade = rep(trd@name, length(rg)), region = rg))
  #
  if (length(trd@source) != 0) {
    approxim$src <- trd@source; 
    approxim$src <- approxim$src[approxim$src %in% approxim$region]
  } else approxim$src <- approxim$region 
  if (length(trd@destination) != 0) {
    approxim$dst <- trd@destination; 
    approxim$dst <- approxim$dst[approxim$dst %in% approxim$region]
  } else approxim$dst <- approxim$region
  approxim <- approxim[names(approxim) != 'region']
  # pTradeIrCost
  obj@parameters[['pTradeIrCost']] <- addData(obj@parameters[['pTradeIrCost']],
    simpleInterpolation(trd@trade, 'cost', obj@parameters[['pTradeIrCost']], 
      approxim, 'trade', trd@name))
  # pTradeIrMarkup
  obj@parameters[['pTradeIrMarkup']] <- addData(obj@parameters[['pTradeIrMarkup']],
    simpleInterpolation(trd@trade, 'markup', obj@parameters[['pTradeIrMarkup']], 
      approxim, 'trade', trd@name))
  # pTradeIr
    gg <- multiInterpolation(trd@trade, 'ava',
            obj@parameters[['pTradeIr']], approxim, 'trade', trd@name)
    obj@parameters[['pTradeIr']] <- addData(obj@parameters[['pTradeIr']], gg)
    gg <- gg[gg$type == 'up' & gg$value != Inf, ]
    if (nrow(gg) != 0) 
      obj@parameters[['defpTradeIrUp']] <- addData(obj@parameters[['defpTradeIrUp']],
            gg[, obj@parameters[['defpTradeIrUp']]@dimSetNames])
  obj
})


