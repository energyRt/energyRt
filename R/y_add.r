################################################################################
# Check is slice level exist
################################################################################
.checkSliceLevel <- function(app, approxim) {
  if (length(app@slice) != 0 && all(app@slice != colnames(approxim$slice@levels)[-ncol(approxim$slice@levels)]))
    stop(paste0('Unknown slice level "', app@slice, '" for ', class(app), ': "', app@name, '"'))
}
################################################################################
# Disaggregate slice, e.g. from WINTER to WINTER_DAY and WINTER_NIGHT
################################################################################
.disaggregateSliceLevel <- function(app, approxim) {
  slt <- getSlots(class(app)) 
  slt <- names(slt)[slt == 'data.frame']
  if (class(app) == 'technology') slt <- slt[slt != 'afs']
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
setMethod('.add0', signature(obj = 'modInp', app = 'commodity',
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
  if (length(lev) == 0) {
    if (length(comm) == 0) stop('Internal error: 66a37cde-24e2-4ac5-ab24-b79e0f603bf7')
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
setMethod('.add0', signature(obj = 'modInp', app = 'demand',
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
# Add weather
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'weather',
                            approxim = 'list'), function(obj, app, approxim) {    
                              wth <- energyRt:::.upper_case(app)
                              if (length(wth@slice) == 0&& length(approxim$slice@misc$nlevel) > 1) {
                                stop('For weather slice level have to be define, if more than one slice level')
                              }
                              if (length(wth@slice) == 0) wth@slice <- names(approxim$slice@misc$nlevel)[1]
                              approxim <- .fix_approximation_list(approxim, lev = wth@slice)
                              # region fix
                              if (length(wth@region) != 0) {
                                approxim$region <- approxim$region[approxim$region %in% wth@region]
                              }
                              wth@region <- approxim$region
                              wth <- stayOnlyVariable(wth, approxim$region, 'region')
                              wth <- .disaggregateSliceLevel(wth, approxim)
    obj@parameters[['pWeather']] <- addData(obj@parameters[['pWeather']], simpleInterpolation(wth@weather, 'wval',
       obj@parameters[['pWeather']], approxim, 'weather', wth@name, all.val = TRUE))
    obj@parameters[['mWeatherSlice']] <- addData(obj@parameters[['mWeatherSlice']],
                                                 data.frame(weather = rep(wth@name, length(approxim$slice)), slice = approxim$slice))
    obj@parameters[['mWeatherRegion']] <- addData(obj@parameters[['mWeatherRegion']],
                                            data.frame(weather = rep(wth@name, length(wth@region)), region = wth@region))
    obj
})
 
################################################################################
# Add supply
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'supply',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    sup <- energyRt:::.upper_case(app)
    approxim <- .fix_approximation_list(approxim, comm = sup@commodity, lev = sup@slice)
    sup <- .disaggregateSliceLevel(sup, approxim)
    if (length(sup@region) != 0) {
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
      mSupSpan <- data.frame(sup = rep(sup@name, length(sup@region)), region = sup@region)
      obj@parameters[['mSupSpan']] <- addData(obj@parameters[['mSupSpan']], mSupSpan)
    } else {
      mSupSpan <- data.frame(sup = rep(sup@name, length(approxim$region)), region = approxim$region)
      obj@parameters[['mSupSpan']] <- addData(obj@parameters[['mSupSpan']], mSupSpan)
    }
    sup <- stayOnlyVariable(sup, approxim$region, 'region')
    mSupSlice <- data.frame(sup = rep(sup@name, length(approxim$slice)), slice = approxim$slice)
    obj@parameters[['mSupSlice']] <- addData(obj@parameters[['mSupSlice']], mSupSlice)
    #  if (!energyRt:::.chec_correct_name(sup@name)) {
  #    stop(paste('Incorrect supply name "', sup@name, '"', sep = ''))
  #  }
  #  if (isSupply(obj, sup@name)) {
  #    warning(paste('There is supply name "', sup@name,
  #        '" now, all previous information will be removed', sep = ''))
  #    obj <- removePreviousSupply(obj, sup@name)
  #  }    
  #  obj@parameters[['sup']] <- addData(obj@parameters[['sup']], sup@name)
    mSupComm <- data.frame(sup = sup@name, comm = sup@commodity)
    obj@parameters[['mSupComm']] <- addData(obj@parameters[['mSupComm']], mSupComm)
    pSupCost <- simpleInterpolation(sup@availability, 'cost', obj@parameters[['pSupCost']], approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupCost']] <- addData(obj@parameters[['pSupCost']], pSupCost)
    pSupReserve <- multiInterpolation(sup@reserve, 'res', obj@parameters[['pSupReserve']], 
                       approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupReserve']] <- addData(obj@parameters[['pSupReserve']], pSupReserve)
    pSupAva <- multiInterpolation(sup@availability, 'ava',
                       obj@parameters[['pSupAva']], approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupAva']] <- addData(obj@parameters[['pSupAva']], pSupAva)
    tmp <- pSupAva[pSupAva$value == 0 & pSupAva$type == 'up', 1:5]
    mSupAva <- merge(merge(mSupSpan, list(comm = sup@commodity, year = approxim$mileStoneYears)), mSupSlice)
    mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, tmp), fromLast = TRUE))[1:nrow(mSupAva)], ]
    obj@parameters[['mSupAva']] <- addData(obj@parameters[['mSupAva']], mSupAva)

    obj@parameters[['mSupReserveUp']] <- addData(obj@parameters[['mSupReserveUp']], 
        pSupReserve[pSupReserve$type == 'up' & pSupReserve$value != Inf, c('sup', 'comm', 'region')])
    obj@parameters[['meqSupReserveLo']] <- addData(obj@parameters[['meqSupReserveLo']], 
                                                   pSupReserve[pSupReserve$type == 'lo' & pSupReserve$value != 0, c('sup', 'comm', 'region')])
    
    obj@parameters[['meqSupAvaLo']] <- addData(obj@parameters[['meqSupAvaLo']], 
                                               merge(mSupAva, pSupAva[pSupAva$type == 'lo' & pSupAva$value != 0, 1:5]))
    obj@parameters[['mSupAvaUp']] <- addData(obj@parameters[['mSupAvaUp']], 
                                             merge(mSupAva, pSupAva[pSupAva$type == 'up' & pSupAva$value != Inf, 1:5]))
    
    obj@parameters[['mvSupReserve']] <- addData(obj@parameters[['mvSupReserve']], merge(mSupComm, mSupSpan))
        # For weather
    # mSupWeatherLo(sup, weather)
    wth.lo <- sup@weather[!is.na(sup@weather$wava.lo) | !is.na(sup@weather$wava.fx), 'weather']
    obj@parameters[['mSupWeatherLo']] <- addData(obj@parameters[['mSupWeatherLo']],
                                            data.frame(sup = rep(sup@name, length(wth.lo)), weather = wth.lo))
    # mSupWeatherUp(sup, weather)
    wth.up <- sup@weather[!is.na(sup@weather$wava.up) | !is.na(sup@weather$wava.fx), 'weather']
    obj@parameters[['mSupWeatherUp']] <- addData(obj@parameters[['mSupWeatherUp']],
                                                 data.frame(sup = rep(sup@name, length(wth.up)), weather = wth.up))
    if (nrow(sup@weather) > 0) {
      gg <- sup@weather
      gg$sup <- sup@name
      gg$type <- 'lo'
      a1 <- gg[, c('sup', 'weather', 'type', 'wava.lo'), drop = FALSE]; 
      colnames(a1)[ncol(a1)] <- 'value'
      a2 <- gg[, c('sup', 'weather', 'type', 'wava.fx'), drop = FALSE]; 
      colnames(a2)[ncol(a2)] <- 'value'
      a3 <- gg[, c('sup', 'weather', 'type', 'wava.up'), drop = FALSE]; 
      colnames(a3)[ncol(a3)] <- 'value'
      g1 <- rbind(a1, a2); g1$type <- 'lo'
      g2 <- rbind(a3, a2); g1$type <- 'up'
      gg <- rbind(g1, g2)
      gg <- gg[!is.na(gg$value),, drop = FALSE]
      # sup     weather type    value
        obj@parameters[['pSupWeather']] <- addData(obj@parameters[['pSupWeather']], gg)
    }
    t1 <- mSupAva[, c('sup', 'region', 'year')]; t1 <- t1[!duplicated(t1), ]
    t2 <- pSupCost[pSupCost$value != 0, c('sup', 'region', 'year')]; t2 <- t2[!duplicated(t2), ]
    mvSupCost <- merge(t1, t2)
    obj@parameters[['mvSupCost']] <- addData(obj@parameters[['mvSupCost']], mvSupCost)
    
  obj
})

################################################################################
# Add export
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    exp <- energyRt:::.upper_case(app)
    
  exp <- stayOnlyVariable(exp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = exp@commodity, lev = exp@slice)
  exp <- .disaggregateSliceLevel(exp, approxim)
  mExpSlice <- data.frame(expp = rep(exp@name, length(approxim$slice)), slice = approxim$slice)
  obj@parameters[['mExpSlice']] <- addData(obj@parameters[['mExpSlice']], mExpSlice)
  #  if (!energyRt:::.chec_correct_name(exp@name)) {
#    stop(paste('Incorrect export name "', exp@name, '"', sep = ''))
#  }
#  if (isExport(obj, exp@name)) {
#    warning(paste('There is export name "', exp@name,
#        '" now, all previous information will be removed', sep = ''))
#    obj <- removePreviousExport(obj, exp@name)
#  }    
#  obj@parameters[['expp']] <- addData(obj@parameters[['expp']], exp@name)
  mExpComm <- data.frame(expp = exp@name, comm = exp@commodity)
  obj@parameters[['mExpComm']] <- addData(obj@parameters[['mExpComm']], mExpComm)
  obj@parameters[['pExportRowPrice']] <- addData(obj@parameters[['pExportRowPrice']],
      simpleInterpolation(exp@exp, 'price',
          obj@parameters[['pExportRowPrice']], approxim, 'expp', exp@name))
  pExportRowRes <- NULL
  if (exp@reserve != Inf) pExportRowRes <- data.frame(expp = exp@name, value = exp@reserve)
  obj@parameters[['pExportRowRes']] <- addData(obj@parameters[['pExportRowRes']], pExportRowRes)
  pExportRow <- multiInterpolation(exp@exp, 'exp', obj@parameters[['pExportRow']], approxim, 'expp', exp@name)
  obj@parameters[['pExportRow']] <- addData(obj@parameters[['pExportRow']], pExportRow)
  
  mExportRow <- merge(merge(mExpSlice, list(region = approxim$region)), list(year = approxim$mileStoneYears))
  mExportRow <- mExportRow[(!duplicated(rbind(mExportRow, pExportRow[pExportRow$type == 'up' & pExportRow$value == 0, 1:4]), 
                                        fromLast = TRUE)[1:nrow(mExportRow)]), ]
  mExportRow$comm <- exp@commodity
  obj@parameters[['mExportRow']] <- addData(obj@parameters[['mExportRow']], mExportRow)
  if (!is.null(pExportRow)) {
    tmp <- pExportRow[pExportRow$type == 'up' & pExportRow$value != Inf & pExportRow$value != 0, 1:4]
    tmp$comm <- exp@commodity
    obj@parameters[['mExportRowUp']] <- addData(obj@parameters[['mExportRowUp']], tmp)
    obj@parameters[['meqExportRowLo']] <- addData(obj@parameters[['meqExportRowLo']], 
              merge(mExportRow, pExportRow[pExportRow$type == 'lo' & pExportRow$value != 0, 1:4])) 
  }
  if (!is.null(pExportRowRes)) {
    pExportRowRes$comm <- exp@commodity
    obj@parameters[['mExportRowAccumulatedUp']] <- addData(obj@parameters[['mExportRowAccumulatedUp']], 
                                                         pExportRowRes[pExportRowRes$value != Inf, c('expp', 'comm'), drop = FALSE])
  }
  obj
})

################################################################################
# Add import
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'import',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    imp <- energyRt:::.upper_case(app)
  imp <- stayOnlyVariable(imp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = imp@commodity, lev = imp@slice)
  imp <- .disaggregateSliceLevel(imp, approxim)
  mImpSlice <- data.frame(imp = rep(imp@name, length(approxim$slice)), slice = approxim$slice)
  obj@parameters[['mImpSlice']] <- addData(obj@parameters[['mImpSlice']],  mImpSlice)
  mImpComm <- data.frame(imp = imp@name, comm = imp@commodity)
  obj@parameters[['mImpComm']] <- addData(obj@parameters[['mImpComm']], mImpComm)
  pImportRowPrice <- simpleInterpolation(imp@imp, 'price',
                                         obj@parameters[['pImportRowPrice']], approxim, 'imp', imp@name)
  obj@parameters[['pImportRowPrice']] <- addData(obj@parameters[['pImportRowPrice']], pImportRowPrice)
  pImportRowRes <- NULL
  if (imp@reserve != Inf) pImportRowRes <- data.frame(imp = imp@name, value = imp@reserve)
  obj@parameters[['pImportRowRes']] <- addData(obj@parameters[['pImportRowRes']], pImportRowRes)
  pImportRow <- multiInterpolation(imp@imp, 'imp',
                                   obj@parameters[['pImportRow']], approxim, 'imp', imp@name)
  obj@parameters[['pImportRow']] <- addData(obj@parameters[['pImportRow']], pImportRow)
  mImportRow <- merge(merge(mImpSlice, list(region = approxim$region)), list(year = approxim$mileStoneYears))
  mImportRow <- mImportRow[(!duplicated(rbind(mImportRow, pImportRow[pImportRow$type == 'up' & pImportRow$value == 0, 1:4]), 
                                        fromLast = TRUE)[1:nrow(mImportRow)]), ]
  mImportRow$comm <- imp@commodity
  obj@parameters[['mImportRow']] <- addData(obj@parameters[['mImportRow']], mImportRow)
  if (!is.null(pImportRow)) {
    tmp <- pImportRow[pImportRow$type == 'up' & pImportRow$value != Inf & pImportRow$value != 0, 1:4]
    tmp$comm <- imp@commodity
    obj@parameters[['mImportRowUp']] <- addData(obj@parameters[['mImportRowUp']], tmp)
    obj@parameters[['meqImportRowLo']] <- addData(obj@parameters[['meqImportRowLo']], 
                                                  merge(mImportRow, pImportRow[pImportRow$type == 'lo' & pImportRow$value != 0, 1:4])) 
  }
  if (!is.null(pImportRowRes)) {
    pImportRowRes$comm <- exp@commodity
    obj@parameters[['mImportRowAccumulatedUp']] <- addData(obj@parameters[['mImportRowAccumulatedUp']], 
           pImportRowRes[pImportRowRes$value != Inf, c('expp', 'comm'), drop = FALSE])
  }
  obj
})


.start_end_fix <- function(approxim, app, als, stock_exist) {
  if (is.null(stock_exist)) stock_exist <- data.frame()
  stock_exist <- stock_exist[stock_exist$value != 0, ]
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
  dd_eac <- dd_able
  if (nrow(stock_exist) != 0 && any(!dd_able$enable)) {
    for(rr in unique(stock_exist$region)) {
      dd_able[dd_able$region == rr & dd_able$year %in% stock_exist[stock_exist$region == rr, 'year'], 'enable'] <- TRUE
    }
  }   
  # 
  dd_able <- dd_able[dd_able$enable, -1, drop = FALSE]
  dd_eac <- dd_eac[dd_eac$enable, -1, drop = FALSE]
  dd <- dd[dd$year %in% approxim$mileStoneYears, ]
  dd_eac <- dd_eac[dd_eac$year %in% approxim$mileStoneYears, ]
  dd_able <- dd_able[dd_able$year %in% approxim$mileStoneYears, ]
  list(new = dd, span = dd_able, eac = dd_eac)
}


################################################################################
# Add sysInfo
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'sysInfo',
  approxim = 'list'), function(obj, app, approxim) {
    clean_list <- c('mSliceParentChild', 'mSliceParentChildE', 'mSliceNext', 'mSliceFYearNext', 'pDiscount', 'pSliceShare', 'pDummyImportCost', 
      'pDummyExportCost', 'mStartMilestone', 'mEndMilestone', 'mMilestoneLast', 'mMilestoneFirst', 'mMilestoneNext', 
      'mMilestoneHasNext', 'mSameSlice', 'mSameRegion', 'ordYear', 'cardYear', 'pPeriodLen', 'pDiscountFactor', 'mDiscountZero')
    for (i in clean_list)
      obj@parameters[[i]] <- .clearParameter(obj@parameters[[i]])
    #  assign('obj', obj, globalenv())
  #  assign('app', app, globalenv())
  #  assign('approxim', approxim, globalenv())
  obj <- removePreviousSysInfo(obj)
  app <- stayOnlyVariable(app, approxim$region, 'region')
  obj@parameters[['mSliceParentChild']] <- addData(obj@parameters[['mSliceParentChild']],
                                  data.frame(slice = as.character(approxim$slice@all_parent_child$parent), 
                                             slicep = as.character(approxim$slice@all_parent_child$child), stringsAsFactors = FALSE))
  obj@parameters[['mSliceParentChildE']] <- addData(obj@parameters[['mSliceParentChildE']],
                  data.frame(slice = as.character(c(app@slice@all_slice, approxim$slice@all_parent_child$parent)), 
                             slicep = as.character(c(app@slice@all_slice, approxim$slice@all_parent_child$child)), stringsAsFactors = FALSE))
  if (length(approxim$slice@misc$next_slice) != 0) {
    obj@parameters[['mSliceNext']] <- addData(obj@parameters[['mSliceNext']], approxim$slice@misc$next_slice)
    obj@parameters[['mSliceFYearNext']] <- addData(obj@parameters[['mSliceFYearNext']], 
                                                   approxim$slice@misc$fyear_next_slice)
  }
  # Discount
  approxim_no_mileStone_Year <- approxim
  approxim_no_mileStone_Year$mileStoneYears <- NULL
  pDiscount <- simpleInterpolation(app@discount, 'discount',
                      obj@parameters[['pDiscount']], approxim_no_mileStone_Year, all.val = TRUE)
  obj@parameters[['pDiscount']] <- addData(obj@parameters[['pDiscount']], pDiscount)
  approxim_comm <- approxim
  approxim_comm[['comm']] <- approxim$all_comm
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
  }
  if (nrow(app@milestone) == 0) {
    app <- setMilestoneYears(app, start = min(app@year), interval = rep(1, length(app@year)))
  }

  obj@parameters[['mStartMilestone']] <- addData(obj@parameters[['mStartMilestone']], 
    data.frame(year = app@milestone$mid, yearp = app@milestone$start))
  obj@parameters[['mEndMilestone']] <- addData(obj@parameters[['mEndMilestone']], 
    data.frame(year = app@milestone$mid, yearp = app@milestone$end))
  obj@parameters[['mMilestoneLast']] <- addData(obj@parameters[['mMilestoneLast']], 
  	data.frame(year = max(app@milestone$mid)))
  obj@parameters[['mMilestoneFirst']] <- addData(obj@parameters[['mMilestoneFirst']], 
  	data.frame(year = min(app@milestone$mid)))
  
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
  
  obj@parameters[['pPeriodLen']] <- addData(obj@parameters[['pPeriodLen']], 
     data.frame(year = app@milestone$mid, value = (app@milestone$end - app@milestone$start + 1), stringsAsFactors = FALSE))
  
  ####################################################
  pDiscount <- pDiscount[sort(pDiscount$year, index.return = TRUE)$ix,, drop = FALSE]
  pDiscountFactor <- pDiscount[0,, drop = FALSE]
  for(l in unique(pDiscount$region)) {
    dd <- pDiscount[pDiscount$region == l,, drop = FALSE]
    dd$value <- cumprod(1 / (1 + dd$value))
    pDiscountFactor <- rbind(pDiscountFactor, dd)
  }
  obj@parameters[['pDiscountFactor']] <- addData(obj@parameters[['pDiscountFactor']], pDiscountFactor)
  # pDiscountFactorMileStone
  yrr <- app@milestone$start[1]:app@milestone$end[nrow(app@milestone)]
  tyr <- rep(NA, length(yrr))
  names(tyr) <- yrr
  for (yr in seq_len(nrow(app@milestone))) {
    tyr[app@milestone$start[yr] <= yrr & yrr <= app@milestone$end[yr]] <- app@milestone$mid[yr]
  }
  pDiscountFactorMileStone <- pDiscountFactor
  pDiscountFactorMileStone$year <- tyr[as.character(pDiscountFactorMileStone$year)]
  pDiscountFactorMileStone <- aggregate(pDiscountFactorMileStone[,'value', drop = FALSE], 
                                        pDiscountFactorMileStone[, c('region', 'year'), drop = FALSE], sum)
  if (!app@discountFirstYear) {
    dsc <- pDiscount[pDiscount$year == min(pDiscount$year), ]
    dsc$mlt <- dsc$value + 1
    pDiscountFactorMileStone <- merge(pDiscountFactorMileStone, dsc[, c('region', 'mlt')])
    pDiscountFactorMileStone$value <- pDiscountFactorMileStone$value * pDiscountFactorMileStone$mlt
    pDiscountFactorMileStone$mlt <- NULL
  }
  obj@parameters[['pDiscountFactorMileStone']] <- addData(obj@parameters[['pDiscountFactorMileStone']], pDiscountFactorMileStone)
  # pDiscountFactorMileStone
  mDiscountZero <- pDiscount[pDiscount$year == as.character(max(app@year)), -2]
  mDiscountZero <- mDiscountZero[mDiscountZero$value == 0, 'region', drop = FALSE]
  # Add mDiscountZero - zero discount rate in final period
  if (nrow(mDiscountZero) != 0) {
    obj@parameters[['mDiscountZero']] <- addData(obj@parameters[['mDiscountZero']], mDiscountZero)
  } 
  obj
})



################################################################################
# Add constraint
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'constraint',
                             approxim = 'list'), function(obj, app, approxim) {
                               .getSetEquation(obj, app, approxim)
                             })

################################################################################
# Add tax & sub
################################################################################
.subtax_approxim <- function(obj, app, tax, whr) {
  if (all(app@comm != names(approxim$commodity_slice_map)))
    stop('Unknown commodity "', app@comm, '" in ', whr, ' "', app@name, '"')
  if (length(app@region) != 0) {
    if (!all(app@region %in% approxim$region))
      stop(paste0(whr, ': unknown region "', paste0(app@region[!(app@region %in% approxim$region)], collapse = '", "'), '"'))
    approxim$region <- app@region
  }
  if (length(app@year) != 0) {
    if (!all(app@year %in% approxim$year))
      stop(paste0(whr, ': unknown year "', paste0(app@year[!(app@year %in% approxim$year)], collapse = '", "'), '"'))
    approxim$year <- app@year
  }
  
  
  if (length(app@slice) != 0) {
    if (!all(app@slice %in% approxim$slice@all_slice))
      stop(paste0(whr, ': unknown slice "', paste0(app@slice[!(app@slice %in% approxim$slice@all_slice)], collapse = '", "'), '"'))

    slc <- approxim$commodity_slice_map[[app@comm]]
    # if there are child slice on commodity
    if (!all(app@slice %in% slc)) {
      not_alowed <- approxim$slice@all_parent_child[approxim$slice@all_parent_child$parent %in% slc, 'child']
      if (any(not_alowed %in% app@slice))
        stop(paste0(whr, ': child slice for commodity level is not allowed: "', paste0(not_alowed[not_alowed %in% app@slice], collapse = '", "'), '"'))
    }
    # if there are parent slice on commodity
    if (!all(app@slice %in% slc)) {
      have_to_split <- app@slice[!(app@slice %in% slc)]
      ust_slc <-  approxim$slice@all_parent_child[approxim$slice@all_parent_child$parent %in% have_to_split & 
                                                    approxim$slice@all_parent_child$child %in% slc, ]
      approxim$slice <- c(app@slice[app@slice %in% slc], ust_slc$child)
      # split slice on data.frame
      if (is.data.frame(app@value) && !is.null(app@value$slice) && any(app@value$slice %in% have_to_split)) {
        rr0 <- app@value[!(app@value$slice %in% have_to_split), ]
        tmp <- app@value[app@value$slice %in% have_to_split, ]; 
        tmp_slice <- tmp$slice; tmp$slice <- NULL
        for (spl in have_to_split) {
          spl2 <- ust_slc[ust_slc$parent == spl, 'child']
          rr0 <- rbind(rr0, merge(tmp[tmp_slice == spl,], data.frame(slice = spl2, stringsAsFactors=FALSE))[, colnames(rr0)])
        }
        app@value <- rr0
      }
    }
  } else {
    approxim$slice <- approxim$slice@slice_map[[approxim$commodity_slice_map[[app@comm]]]]
  }
  # Generate app@value
  if (nrow(app@value) == 0) {
    app@value <- data.frame(region = NA, year = NA, slice = NA, value = app@defVal) 
  }
  for (i in c('region', 'year', 'slice')) {
    if (all(colnames(app@value) != i)) {
      app@value[, i] <- NA
    }
  }
  if (whr == 'tax') {
    par <- 'pTaxCost'
  } else if (whr == 'subsidy') {
    par <- 'pSubsCost'
  } else stop('internal error ', whr)
  obj@parameters[[par]] <- addData(obj@parameters[[par]],
      simpleInterpolation(app@value, 'value', obj@parameters[[par]], approxim, 'comm', app@comm))
  obj
}
################################################################################
# Add tax
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'tax',
                             approxim = 'list'), function(obj, app, approxim) {
                               assign('obj', obj, globalenv())
                               assign('app', app, globalenv())
                               assign('approxim', approxim, globalenv())
                               .subtax_approxim(obj, app, tax, whr = 'tax') 
                             })


################################################################################
# Add sub
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'sub',
                             approxim = 'list'), function(obj, app, approxim) {
                               .subtax_approxim(obj, app, tax, whr = 'subsidy') 
                             })



