################################################################################
# Check is slice level exist
################################################################################
.checkSliceLevel <- function(app, approxim) {
  if (!is.null(app@slice) && all(app@slice != colnames(approxim$slice@levels)[-ncol(approxim$slice@levels)]))
    stop(paste0('Unknown slice level "', app@slice, '" for ', class(app), ': "', app@name, '"'))
}
################################################################################
# Disaggregate slice, e.g. from WINTER to WINTER_DAY and WINTER_NIGHT
################################################################################
.disaggregateSliceLevel <- function(app, approxim) {
  slt <- getSlots(class(app)) 
  slt <- names(slt)[slt == 'data.frame']
  for (ss in slt) if (any(colnames(slot(app, ss)) == 'slice')) {
    tmp <- slot(app, ss)
    fl <- (!is.na(tmp$slice) & !(tmp$slice %in% approxim$slice))
    if (any(fl)) {
      mark_col <- (sapply(tmp, is.character) | colnames(tmp) == 'year')
      mark_coli <- colnames(tmp)[mark_col]
      t1 <- tmp[fl,, drop = FALSE]
      t2 <- tmp[!fl,, drop = FALSE]
      # Sort from lowest level to largest
      ff <- approxim$parent_child$parent[!duplicated(approxim$parent_child$parent)]
      f1 <- seq_along(ff)
      names(f1) <- ff
      if (!all(t1$slice %in% ff))
        stop(paste0('Unknown slice or slice is not parrent slice, for "', app@name, '" (class ', class(app), '), slot: "',
                    ss, '", slice: "', paste0(t1$slice[!(t1$slice %in% ff)], collapse = '", "'), '"'))      
      t1 <- t1[sort(f1[t1$slice], index.return = TRUE, decreasing = TRUE)$ix,, drop = FALSE]
      # Add child desaggregation 
      for (i in seq_len(nrow(t1))) {
        ll <- approxim$parent_child[approxim$parent_child$parent == t1[i, 'slice'], 'child']
        t0 <- t1[rep(i, length(ll)),, drop = FALSE]
        t0$slice <- ll
        tes <- t0[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z1 <- apply(tes, 1, paste0, collapse = '##')
        tes <- t2[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z2 <- apply(tes, 1, paste0, collapse = '##')
        # If there are the same row, after splititng
        if (any(z1 %in% z2)) {
          merge_col <- merge(t0, t2, by = mark_coli)
          colnames(merge_col)[seq_len(ncol(t0))] <- colnames(t0)
          for (j in colnames(tmp)[!mark_col])
            merge_col[!is.na(merge_col[, paste0(j, '.y')]), j] <- NA
          t0 <- rbind(t0[!((z1 %in% z2)), ], merge_col[, 1:ncol(t0)])
        }
        t2 <- rbind(t2, t0)
      }
      slot(app, ss) <- t2
    }
  }
  app
}

################################################################################
# Add commodity
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'commodity',
  approxim = 'list'), function(obj, app, approxim) {
  .checkSliceLevel(app, approxim)
  cmd <- energyRt:::.upper_case(app)
  cmd <- stayOnlyVariable(cmd, approxim$region, 'region')
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
  # For slice
  approxim <- .fix_approximation_list(approxim, comm = cmd@name)
  obj@parameters[['mCommSlice']] <- addData(obj@parameters[['mCommSlice']], 
                                            data.frame(comm = rep(cmd@name, length(approxim$commodity_slice_map[[cmd@name]])), 
                                                       slice = approxim$slice))
  obj
})


################################################################################
# Add apporoximation list (auxgilary list for approximation) to standart view
################################################################################
.fix_approximation_list <- function(approxim, lev = NULL, comm = NULL) {
  if (is.null(lev)) {
    if (is.null(comm)) stop('Internal error: 66a37cde-24e2-4ac5-ab24-b79e0f603bf7')
    lev <- approxim$commodity_slice_map[[comm]]
  }
  approxim$parent_child <- approxim$slice@all_parent_child
  approxim$slice <- approxim$slice@slice_map[[lev]]
  approxim$parent_child <- approxim$parent_child[approxim$parent_child$child %in% approxim$slice,, drop = FALSE]
  approxim
}

################################################################################
# Add demand
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'demand',
  approxim = 'list'), function(obj, app, approxim) {     
  dem <- energyRt:::.upper_case(app)
  dem <- stayOnlyVariable(dem, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = dem@commodity)
  dem <- .disaggregateSliceLevel(dem, approxim)
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
      obj@parameters[['pDemand']], approxim, c('dem', 'comm'), c(dem@name, dem@commodity)))
  obj
})

################################################################################
# Add supply
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'supply',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    # if (!is.null(app@slice)) browser() else cat('-')
    sup <- energyRt:::.upper_case(app)
    approxim <- .fix_approximation_list(approxim, comm = sup@commodity, lev = sup@slice)
    sup <- .disaggregateSliceLevel(sup, approxim)
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
    obj@parameters[['mSupSlice']] <- addData(obj@parameters[['mSupSlice']],
                                            data.frame(sup = rep(sup@name, length(approxim$slice)), slice = approxim$slice))
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
            obj@parameters[['pSupCost']], approxim, c('sup', 'comm'), c(sup@name, sup@commodity)))
    obj@parameters[['pSupReserve']] <- addData(obj@parameters[['pSupReserve']],
      multiInterpolation(sup@reserve, 'res', obj@parameters[['pSupReserve']], 
      approxim, c('sup', 'comm'), c(sup@name, sup@commodity)))
    obj@parameters[['pSupAva']] <- addData(obj@parameters[['pSupAva']],
              multiInterpolation(sup@availability, 'ava',
              obj@parameters[['pSupAva']], approxim, c('sup', 'comm'), c(sup@name, sup@commodity)))
  obj
})

################################################################################
# Add export
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    exp <- energyRt:::.upper_case(app)
  exp <- stayOnlyVariable(exp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = exp@commodity, lev = exp@slice)
  exp <- .disaggregateSliceLevel(exp, approxim)
  obj@parameters[['mExpSlice']] <- addData(obj@parameters[['mExpSlice']],
                                             data.frame(expp = rep(exp@name, length(approxim$slice)), slice = approxim$slice))
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
    .checkSliceLevel(app, approxim)
    imp <- energyRt:::.upper_case(app)
  imp <- stayOnlyVariable(imp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = imp@commodity, lev = imp@slice)
  imp <- .disaggregateSliceLevel(imp, approxim)
  obj@parameters[['mImpSlice']] <- addData(obj@parameters[['mImpSlice']],
                                           data.frame(imp = rep(imp@name, length(approxim$slice)), slice = approxim$slice))
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
      approxim2 <- .fix_approximation_list(approxim, comm = app@comm)
      for(cc in names(app@for.each)) if (!is.null(app@for.each[[cc]])) {
        approxim2[[cc]] <- app@for.each[[cc]]
      }
     obj@parameters[['pTaxCost']] <- addData(obj@parameters[['pTaxCost']],
        simpleInterpolation(app@rhs, 'tax',
         obj@parameters[['pTaxCost']], approxim2, 'comm', app@comm))
  } else
  if (app@type == 'subsidy') {
      approxim2 <- .fix_approximation_list(approxim, comm = app@comm)
      for(cc in names(app@for.each)) if (!is.null(app@for.each[[cc]])) {
        approxim2[[cc]] <- app@for.each[[cc]]
      }
     obj@parameters[['pSubsCost']] <- addData(obj@parameters[['pSubsCost']],
        simpleInterpolation(app@rhs, 'subsidy',
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

.start_end_fix <- function(approxim, app, als, stock_exist) {
  # Start / End year
  dd <- data.frame(enable = rep(TRUE, length(approxim$region) * length(approxim$year)),
                   app = rep(app@name, length(approxim$region) * length(approxim$year)),
                   region = rep(approxim$region, length(approxim$year)), 
                   year = c(t(matrix(rep(approxim$year, length(approxim$region)), length(approxim$year)))), 
                   stringsAsFactors = FALSE)   
  colnames(dd)[2] <- als
  dstart <- data.frame(row.names = approxim$region, region = approxim$region, 
                       year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(app@start$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dstart[, 'year'] <- app@start[fl, 'start']
  }
  if (any(!fl)) {
    dstart[app@start[!fl, 'region'], 'year'] <- app@start[!fl, 'start']
  }
  dstart <- dstart[!is.na(dstart$year),, drop = FALSE]
  for(rr in dstart$region) {
    if (!is.na(dstart[rr, 'year']) && any(dd$year < dstart[rr, 'year'])) dd[dd$region == rr & dd$year < dstart[rr, 'year'], 'enable'] <- FALSE
  } 
  dd_able <- dd
  ## end 
  dend <- data.frame(row.names = approxim$region, region = approxim$region, 
                     year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(app@end$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dend[, 'year'] <- app@end[fl, 'end']
  }
  if (any(!fl)) {
    dend[app@end[!fl, 'region'], 'year'] <- app@end[!fl, 'end']
  }
  dend <- dend[!is.na(dend$year),, drop = FALSE]
  for(rr in dend$region) {
    if (any(dd$year > dend[rr, 'year'])) dd[dd$region == rr & dd$year > dend[rr, 'year'], 'enable'] <- FALSE
  }  
  dd <- dd[dd$enable, -1, drop = FALSE]
  ## life 
  dlife <- data.frame(row.names = approxim$region, region = approxim$region, 
                      year = rep(NA, length(approxim$region)), stringsAsFactors = FALSE)
  fl <- is.na(app@olife$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dlife[, 'year'] <- app@olife[fl, 'olife']
  }
  if (any(!fl)) {
    dlife[app@olife[!fl, 'region'], 'year'] <- app@olife[!fl, 'olife']
  }
  dlife <- dlife[!is.na(dlife$year),, drop = FALSE]
  for(rr in dlife$region[dlife$region %in% dend$region]) {
    if (any(dd_able$year >= dend[rr, 'year'] + dlife[rr, 'year'])) 
      dd_able[dd_able$region == rr & dd_able$year >= dend[rr, 'year'] + dlife[rr, 'year'], 'enable'] <- FALSE
  }  
  if (nrow(stock_exist) != 0 && any(!dd_able$enable)) {
    for(rr in unique(stock_exist$region)) {
      dd_able[dd_able$region == rr & dd_able$year %in% stock_exist[stock_exist$region == rr, 'year'], 'enable'] <- TRUE
    }
  }   
  dd_able <- dd_able[dd_able$enable, -1, drop = FALSE]
  list(new = dd, span = dd_able)
}
################################################################################
# Add technology
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'technology',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
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
    use_cmd <- unique(sapply(c(tech@output$comm, tech@output$comm, tech@aux$acomm), function(x) approxim$commodity_slice_map[x]))
    tech@slice <- colnames(approxim$slice@levels)[max(c(approxim$slice@misc$deep[c(use_cmd, recursive = TRUE)], recursive = TRUE))]
  }
  approxim <- .fix_approximation_list(approxim, lev = tech@slice)
  tech <- .disaggregateSliceLevel(tech, approxim)
  obj@parameters[['mTechSlice']] <- addData(obj@parameters[['mTechSlice']],
                                           data.frame(tech = rep(tech@name, length(approxim$slice)), slice = approxim$slice, 
                                                      stringsAsFactors = FALSE))
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
    #gg <- gg[gg$type == 'up' & gg$value == Inf, ]
    #if (nrow(gg) != 0) 
    #  obj@parameters[['ndefpTechAfacUp']] <- addData(obj@parameters[['dnefpTechAfacUp']],
    #        gg[, obj@parameters[['ndefpTechAfacUp']]@dimSetNames])

  }
  gg <- multiInterpolation(tech@afa, 'afa',
            obj@parameters[['pTechAfa']], approxim, 'tech', tech@name)
  obj@parameters[['pTechAfa']] <- addData(obj@parameters[['pTechAfa']], gg)
  #gg <- gg[gg$type == 'up' & gg$value == Inf, ]
  #if (nrow(gg) != 0) 
  #    obj@parameters[['ndefpTechAfaUp']] <- addData(obj@parameters[['ndefpTechAfaUp']],
  #          gg[, obj@parameters[['ndefpTechAfaUp']]@dimSetNames])

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
    
  stock_exist <- obj@parameters[["pTechStock"]]@data[!is.na(obj@parameters[["pTechStock"]]@data$tech) & 
                                                obj@parameters[['pTechStock']]@data$tech == tech@name & 
                                                obj@parameters[['pTechStock']]@data$value != 0, c('region', 'year'), drop = FALSE] 
  dd0 <- .start_end_fix(approxim, tech, 'tech', stock_exist)
  obj@parameters[['mTechNew']] <- addData(obj@parameters[['mTechNew']], dd0$new)
  obj@parameters[['mTechSpan']] <- addData(obj@parameters[['mTechSpan']], dd0$span)
#  cat(tech@name, '\n')
  if (all(ctype$comm$type != 'output')) 
    stop('Techology "', tech@name, '", there is not activity commodity')   
  obj
})




################################################################################
# Add sysInfo
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'sysInfo',
  approxim = 'list'), function(obj, app, approxim) {
  #  assign('obj', obj, globalenv())
  #  assign('app', app, globalenv())
  #  assign('approxim', approxim, globalenv())
  obj <- removePreviousSysInfo(obj)
  app <- stayOnlyVariable(app, approxim$region, 'region')
  obj@parameters[['mAllSliceParentChild']] <- addData(obj@parameters[['mAllSliceParentChild']],
      data.frame(slice = as.character(approxim$slice@all_parent_child$parent), 
                 slicep = as.character(approxim$slice@all_parent_child$child), stringsAsFactors = FALSE))
  if (!is.null(approxim$slice@misc$next_slice))
    obj@parameters[['mSliceNext']] <- addData(obj@parameters[['mSliceNext']], approxim$slice@misc$next_slice)
  # Discount
  approxim.no.mileStone.Year <- approxim
  approxim.no.mileStone.Year$mileStoneYears <- NULL
      obj@parameters[['pDiscount']] <- addData(obj@parameters[['pDiscount']],
        simpleInterpolation(app@discount, 'discount',
          obj@parameters[['pDiscount']], approxim.no.mileStone.Year))
  approxim_comm <- approxim
  approxim_comm[['comm']] <- obj@parameters$comm@data$comm
  obj@parameters[['pSliceShare']] <- addData(obj@parameters[['pSliceShare']], 
                                             data.frame(slice = approxim$slice@slice_share$slice, 
                                                        value = approxim$slice@slice_share$share))
  approxim_comm$slice <- approxim$slice@all_slice
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

  obj@parameters[['mSameSlice']] <- addData(obj@parameters[['mSameSlice']], 
    data.frame(slice = app@slice@all_slice, slicep = app@slice@all_slice))
  obj@parameters[['mSameRegion']] <- addData(obj@parameters[['mSameRegion']], 
    data.frame(region = app@region, regionp = app@region))
  tmp <- data.frame(year = getParameterData(obj@parameters$year))
  tmp$value <- seq_along(tmp$year)
  obj@parameters[['ordYear']] <- addData(obj@parameters[['ordYear']], tmp)
  obj@parameters[['cardYear']] <- addData(obj@parameters[['cardYear']], tmp[nrow(tmp),, drop = FALSE])
  
  obj
})

################################################################################
# Add trade
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'trade',
  approxim = 'list'), function(obj, app, approxim) {
  trd <- energyRt:::.upper_case(app)
  trd <- stayOnlyVariable(trd, approxim$region, 'region') ## ??
  remove_duplicate <- list(c('src', 'dst'))
  approxim <- .fix_approximation_list(approxim, comm = trd@commodity)
  trd <- .disaggregateSliceLevel(trd, approxim)
  obj@parameters[['mTradeSlice']] <- addData(obj@parameters[['mTradeSlice']],
                                            data.frame(trade = rep(trd@name, length(approxim$slice)), slice = approxim$slice))
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
      approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
  # pTradeIrMarkup
  obj@parameters[['pTradeIrMarkup']] <- addData(obj@parameters[['pTradeIrMarkup']],
    simpleInterpolation(trd@trade, 'markup', obj@parameters[['pTradeIrMarkup']], 
      approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
  # pTradeIr
    gg <- multiInterpolation(trd@trade, 'ava',
            obj@parameters[['pTradeIr']], approxim, 'trade', trd@name, remove_duplicate = remove_duplicate)
    obj@parameters[['pTradeIr']] <- addData(obj@parameters[['pTradeIr']], gg)
    # Trade ainp
    if (nrow(trd@aux) != 0) {
      if (any(is.na(trd@aux$acomm))) 
        stop('Wrong aux commodity for trade "', trd@name, '"')
      trd@aeff <- trd@aeff[!is.na(trd@aeff$acomm),, drop = FALSE]
      if (!all(trd@aeff$acomm %in% trd@aux$acomm))
        stop('Wrong aux commodity for trade "', trd@name, '"')
      inp_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2ainp) | !is.na(trd@aeff$cdst2ainp), 'acomm'])
      out_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2aout) | !is.na(trd@aeff$cdst2aout), 'acomm'])
      if (length(inp_comm) != 0) obj@parameters[['mTradeIrAInp']] <- addData(obj@parameters[['mTradeIrAInp']], 
                                                                             data.frame(trade = rep(trd@name, length(inp_comm)), comm = inp_comm))
      if (length(out_comm) != 0) obj@parameters[['mTradeIrAOut']] <- addData(obj@parameters[['mTradeIrAOut']], 
                                                                             data.frame(trade = rep(trd@name, length(out_comm)), comm = out_comm))
      for (cc in inp_comm) {
        approxim$acomm <- cc
        obj@parameters[['pTradeIrCsrc2Ainp']] <- addData(
          obj@parameters[['pTradeIrCsrc2Ainp']], simpleInterpolation(trd@aeff, 'csrc2ainp', obj@parameters[['pTradeIrCsrc2Ainp']], 
                                                                     approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
        obj@parameters[['pTradeIrCdst2Ainp']] <- addData(
          obj@parameters[['pTradeIrCdst2Ainp']], simpleInterpolation(trd@aeff, 'cdst2ainp', obj@parameters[['pTradeIrCdst2Ainp']], 
                                                                     approxim, 'trade', trd@name, remove_duplicate = list('src', 'dst')))
      }
      for (cc in out_comm) {
        approxim$acomm <- cc
        obj@parameters[['pTradeIrCsrc2Aout']] <- addData(
          obj@parameters[['pTradeIrCsrc2Aout']], simpleInterpolation(trd@aeff, 'csrc2aout', obj@parameters[['pTradeIrCsrc2Aout']], 
                                                                     approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
        obj@parameters[['pTradeIrCdst2Aout']] <- addData(
          obj@parameters[['pTradeIrCdst2Aout']], simpleInterpolation(trd@aeff, 'cdst2aout', obj@parameters[['pTradeIrCdst2Aout']], 
                                                                     approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
      }
    }
  obj
})


################################################################################
# Add storage
################################################################################
setMethod('add0', signature(obj = 'modInp', app = 'storage',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    stg <- energyRt:::.upper_case(app)
    approxim <- .fix_approximation_list(approxim, comm = stg@commodity, lev = stg@slice)
    stg <- .disaggregateSliceLevel(stg, approxim)
    if (!is.null(stg@region)) {
      approxim$region <- approxim$region[approxim$region %in% stg@region]
      ss <- getSlots('storage')
      ss <- names(ss)[ss == 'data.frame']
      ss <- ss[sapply(ss, function(x) (any(colnames(slot(stg, x)) == 'region') 
                                       && any(!is.na(slot(stg, x)$region))))]
      for(sl in ss) if (any(!is.na(slot(stg, sl)$region) & !(slot(stg, sl)$region %in% stg@region))) {
        rr <- !is.na(slot(stg, sl)$region) & !(slot(stg, sl)$region %in% stg@region)
        warning(paste('There are data storage "', stg@name, '" for unused region: "', 
                      paste(unique(slot(stg, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
        slot(stg, sl) <- slot(stg, sl)[!rr,, drop = FALSE]
      }
    }
    stg <- stayOnlyVariable(stg, approxim$region, 'region')
    obj@parameters[['mStorageSlice']] <- addData(obj@parameters[['mStorageSlice']],
                                             data.frame(stg = rep(stg@name, length(approxim$slice)), slice = approxim$slice))
    obj@parameters[['mStorageComm']] <- addData(obj@parameters[['mStorageComm']],
                                            data.frame(stg = stg@name, comm = stg@commodity))
    obj@parameters[['pStorageOlife']] <- addData(obj@parameters[['pStorageOlife']],
                                                   simpleInterpolation(stg@olife, 'olife', obj@parameters[['pStorageOlife']], 
                                                                       approxim, 'stg', stg@name))
    # Loss
    obj@parameters[['pStorageInpEff']] <- addData(obj@parameters[['pStorageInpEff']],
                                                   simpleInterpolation(stg@seff, 'inpeff', obj@parameters[['pStorageInpEff']], 
                                                                       approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
    obj@parameters[['pStorageOutEff']] <- addData(obj@parameters[['pStorageOutEff']],
                                                   simpleInterpolation(stg@seff, 'outeff', obj@parameters[['pStorageOutEff']], 
                                                                       approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
    obj@parameters[['pStorageStgEff']] <- addData(obj@parameters[['pStorageStgEff']], 
                                                     simpleInterpolation(stg@seff, 'stgeff',  obj@parameters[['pStorageStgEff']], 
                                                                         approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
    # Cost
    obj@parameters[['pStorageCostInp']] <- addData(obj@parameters[['pStorageCostInp']],
                                                   simpleInterpolation(stg@varom, 'inpcost',
                                                                       obj@parameters[['pStorageCostInp']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageCostOut']] <- addData(obj@parameters[['pStorageCostOut']],
                                                   simpleInterpolation(stg@varom, 'outcost',
                                                                       obj@parameters[['pStorageCostOut']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageCostStore']] <- addData(obj@parameters[['pStorageCostStore']],
                                                   simpleInterpolation(stg@varom, 'stgcost',
                                                                       obj@parameters[['pStorageCostStore']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageInvcost']] <- addData(obj@parameters[['pStorageInvcost']],
                                                   simpleInterpolation(stg@invcost, 'invcost',
                                                                       obj@parameters[['pStorageInvcost']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageFixom']] <- addData(obj@parameters[['pStorageFixom']],
                                                   simpleInterpolation(stg@fixom, 'fixom',
                                                                       obj@parameters[['pStorageFixom']], approxim, 'stg', stg@name))
    # Ava/Cap
    obj@parameters[['pStorageStock']] <- addData(obj@parameters[['pStorageStock']],
                                                 simpleInterpolation(stg@stock, 'stock',
                                                                     obj@parameters[['pStorageStock']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageAfa']] <- addData(obj@parameters[['pStorageAfa']],
                                               multiInterpolation(stg@afa, 'afa',
                                                                  obj@parameters[['pStorageAfa']], approxim, 'stg', stg@name))
    obj@parameters[['pStorageCap2act']] <- addData(obj@parameters[['pStorageCap2act']],
                                                data.frame(stg = stg@name, value = stg@cap2act))
    # Aux input/output
    if (nrow(stg@aux) != 0) {
      if (any(!(stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in% stg@aux$acomm[!is.na(stg@aux$acomm)]))) {
        cmm <- stg@aeff$acomm[!is.na(stg@aeff$acomm)][stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in% stg@aux$acomm[!is.na(stg@aux$acomm)]]
        stop(paste0('Unknown aux commodity "', paste0(cmm, collapse = '", "'), '", in storage "', stg@name, '"'))
      }
      stg@aeff <- stg@aeff[!is.na(stg@aeff$acomm),, drop = FALSE]
      ainp_flag <- c('stg2ainp', 'inp2ainp', 'out2ainp', 'cap2ainp', 'ncap2ainp')
      aout_flag <- c('stg2aout', 'inp2aout', 'out2aout', 'cap2aout', 'ncap2aout')
      cmp_inp <- stg@aeff[apply(!is.na(stg@aeff[, ainp_flag]), 1, any), 'acomm']
      cmp_out <- stg@aeff[apply(!is.na(stg@aeff[, aout_flag]), 1, any), 'acomm']
      obj@parameters[['mStorageAInp']] <- addData(obj@parameters[['mStorageAInp']],
                                                  data.frame(stg = rep(stg@name, length(cmp_inp)), comm = cmp_inp))
      obj@parameters[['mStorageAOut']] <- addData(obj@parameters[['mStorageAOut']],
                                                  data.frame(stg = rep(stg@name, length(cmp_out)), comm = cmp_out))
      dd <- data.frame(list = c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageInp2AInp', 'pStorageInp2AOut', 'pStorageOut2AInp', 
                                'pStorageOut2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 'pStorageNCap2AInp', 'pStorageNCap2AOut'),
                       table = c('stg2ainp', 'stg2aout', 'inp2ainp', 'inp2aout', 'out2ainp', 'out2aout', 'cap2ainp', 'cap2aout', 'ncap2ainp', 
                                 'ncap2aout'),
                       stringsAsFactors = FALSE)
      approxim_comm <- approxim
      for(i in 1:nrow(dd)) {
        approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
        approxim_comm[['acomm']] <- unique(stg@aeff[!is.na(stg@aeff[, dd[i, 'table']]), 'acomm'])
        if (length(approxim_comm[['acomm']]) != 0) {
          obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
                                                     simpleInterpolation(stg@aeff, dd[i, 'table'], 
                                                                         obj@parameters[[dd[i, 'list']]], approxim_comm, 'stg', stg@name))
        }
      }                
    } else {
      if (nrow(stg@aeff) != 0)
        stop(paste0('Unknown aux commodity "', paste0(stg@aeff$acomm[!is.na(stg@aeff$acomm)], collapse = '", "'), '", in storage "', stg@name, '"'))
    }
    # Some slice
    stock_exist <- obj@parameters[["pStorageStock"]]@data[!is.na(obj@parameters[["pStorageStock"]]@data$stg) & 
                                                         obj@parameters[['pStorageStock']]@data$stg == stg@name & 
                                                         obj@parameters[['pStorageStock']]@data$value != 0, c('region', 'year'), drop = FALSE] 
    dd0 <- .start_end_fix(approxim, stg, 'stg', stock_exist)
    obj@parameters[['mStorageNew']] <- addData(obj@parameters[['mStorageNew']], dd0$new)
    obj@parameters[['mStorageSpan']] <- addData(obj@parameters[['mStorageSpan']], dd0$span)
    obj
  })
