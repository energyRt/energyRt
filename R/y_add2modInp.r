#==============================================================================#
# Add commodity ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'commodity',
  approxim = 'list'), function(obj, app, approxim) {
  .checkSliceLevel(app, approxim)
  # cmd <- energyRt:::.upper_case(app)
  cmd <- app
  cmd <- stayOnlyVariable(cmd, approxim$region, 'region')
  # Add ems_from & pEmissionFactor
  dd <- cmd@emis[, c('comm', 'comm', 'emis'), with = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c('comm', 'commp', 'value')
    dd$commp <- cmd@name
    dd$value <- as.numeric(dd$value) # Must be remove later
    obj@parameters[['pEmissionFactor']] <- .add_data(obj@parameters[['pEmissionFactor']], dd)
  }

  dd <- cmd@agg[, c('comm', 'comm', 'agg'), with = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c('comm', 'commp', 'value')
    dd$comm <- cmd@name
    dd$value <- as.numeric(dd$value) # Must be remove later
    obj@parameters[['pAggregateFactor']] <- .add_data(obj@parameters[['pAggregateFactor']], dd)
  }
  # Define mUpComm | mLoComm | mFxComm
  if (cmd@limtype == 'UP')
    obj@parameters[['mUpComm']] <- .add_data(obj@parameters[['mUpComm']], data.table(comm = cmd@name))
  if (cmd@limtype == 'LO')
    obj@parameters[['mLoComm']] <- .add_data(obj@parameters[['mLoComm']], data.table(comm = cmd@name))
  if (cmd@limtype == 'FX')
    obj@parameters[['mFxComm']] <- .add_data(obj@parameters[['mFxComm']], data.table(comm = cmd@name))
  # For slice
  approxim <- .fix_approximation_list(approxim, comm = cmd@name)
  obj@parameters[['mCommSlice']] <- .add_data(obj@parameters[['mCommSlice']], 
                          data.table(comm = rep(cmd@name, length(approxim$commodity_slice_map[[cmd@name]])), 
                                                       slice = approxim$slice))
    
  if (any(is.na(approxim$debug$comm) | approxim$debug$comm == cmd@name)) {
    approxim$debug$comm[is.na(approxim$debug$comm)] <- cmd@name
    dbg <- approxim$debug[!is.na(approxim$debug$comm) & approxim$debug$comm == cmd@name,]
    approxim$comm <- cmd@name
    obj@parameters[['pDummyImportCost']] <- .add_data(obj@parameters[['pDummyImportCost']],
        simpleInterpolation(dbg, 'dummyImport', obj@parameters[['pDummyImportCost']], approxim))   
    obj@parameters[['pDummyExportCost']] <- .add_data(obj@parameters[['pDummyExportCost']],
        simpleInterpolation(dbg, 'dummyExport', obj@parameters[['pDummyExportCost']], approxim))   
  }
  obj
})


#==============================================================================#
# Add approximation list ####
# (auxiliary list for approximation) to standard view
#==============================================================================#
.fix_approximation_list <- function(approxim, lev = NULL, comm = NULL) {
  if (length(lev) == 0) {
    if (length(comm) == 0) stop('Internal error: 66a37cde-24e2-4ac5-ab24-b79e0f603bf7')
    lev <- approxim$commodity_slice_map[[comm]]
  }
  approxim$parent_child <- approxim$slice@all_parent_child
  approxim$slice <- approxim$slice@slice_map[[lev]]
  approxim$parent_child <- approxim$parent_child[approxim$parent_child$child %in% approxim$slice,]
  approxim
}

#==============================================================================#
# Add demand ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'demand',
                            approxim = 'list'), function(obj, app, approxim) {  
      # dem <- energyRt:::.upper_case(app)
    dem <- app
    if (length(dem@commodity) != 1 || is.na(dem@commodity) || all(dem@commodity != approxim$all_comm))
			stop(paste0('Wrong commodity in demand "', dem@name, '"'))

      dem <- stayOnlyVariable(dem, approxim$region, 'region')
      approxim <- .fix_approximation_list(approxim, comm = dem@commodity)
      dem <- .disaggregateSliceLevel(dem, approxim)
      obj@parameters[['mDemComm']] <- .add_data(obj@parameters[['mDemComm']],
        data.table(dem = dem@name, comm = dem@commodity)) 
      # Region
      if (obj@parameters[['pDemand']]@defVal == 0 && all(!is.na(dem@dem))) {
        if (length(dem@region) != 0)
          dem@region <- dem@region[dem@region %in% unique(dem@dem$region)]
        approxim$region <- approxim$region[approxim$region %in% unique(dem@dem$region)]
      }
      if (length(dem@region) != 0) {
        dem@dem <- dem@dem[is.na(dem@dem) | dem@dem$region %in% dem@region,]
        approxim$region <- approxim$region[approxim$region %in% dem@region]
      }
      # Slice
      mDemInp <- CJ(comm = dem@commodity, slice = approxim$slice)
      mvDemInp <- CJ(comm = dem@commodity, region = approxim$region, year = approxim$mileStoneYears, slice = approxim$slice)
    obj@parameters[['mvDemInp']] <- .add_data(obj@parameters[['mvDemInp']], mvDemInp)
    
       pDemand <- simpleInterpolation(dem@dem, 'dem', obj@parameters[['pDemand']], approxim, c('dem', 'comm'), 
          c(dem@name, dem@commodity))
       obj@parameters[['pDemand']] <- .add_data(obj@parameters[['pDemand']], pDemand)
      
      
      obj
})

#==============================================================================#
# Add weather ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'weather',
                            approxim = 'list'), function(obj, app, approxim) {    
    # wth <- energyRt:::.upper_case(app)
    wth <- app
    if (length(wth@slice) == 0 && length(approxim$slice@misc$nlevel) > 1) {
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
    obj@parameters[['pWeather']]@defVal <- wth@defVal
    obj@parameters[['pWeather']] <- .add_data(obj@parameters[['pWeather']], simpleInterpolation(wth@weather, 'wval',
       obj@parameters[['pWeather']], approxim, 'weather', wth@name))
    obj@parameters[['mWeatherSlice']] <- .add_data(obj@parameters[['mWeatherSlice']],
                                                 CJ(weather = wth@name, slice = approxim$slice))
    obj@parameters[['mWeatherRegion']] <- .add_data(obj@parameters[['mWeatherRegion']],
                                            CJ(weather = wth@name, region = wth@region))
    obj
})
 
#==============================================================================#
# Add export ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    # exp <- energyRt:::.upper_case(app)
  exp <- app
  if (length(exp@commodity) != 1 || is.na(exp@commodity) || all(exp@commodity != approxim$all_comm))
			stop(paste0('Wrong commodity in export "', exp@name, '"'))
  exp <- stayOnlyVariable(exp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = exp@commodity, lev = exp@slice)
  exp <- .disaggregateSliceLevel(exp, approxim)
  mExpSlice <- CJ(expp = exp@name, slice = approxim$slice)
  obj@parameters[['mExpSlice']] <- .add_data(obj@parameters[['mExpSlice']], mExpSlice)
  mExpComm <- data.table(expp = exp@name, comm = exp@commodity)
  obj@parameters[['mExpComm']] <- .add_data(obj@parameters[['mExpComm']], mExpComm)
  obj@parameters[['pExportRowPrice']] <- .add_data(obj@parameters[['pExportRowPrice']],
      simpleInterpolation(exp@exp, 'price',
          obj@parameters[['pExportRowPrice']], approxim, 'expp', exp@name))
  pExportRowRes <- NULL
  if (exp@reserve != Inf) pExportRowRes <- data.table(expp = exp@name, value = exp@reserve)
  obj@parameters[['pExportRowRes']] <- .add_data(obj@parameters[['pExportRowRes']], pExportRowRes)
  pExportRow <- multiInterpolation(exp@exp, 'exp', obj@parameters[['pExportRow']], approxim, 'expp', exp@name)
  obj@parameters[['pExportRow']] <- .add_data(obj@parameters[['pExportRow']], pExportRow)
  
 mExportRow <- CJ(expp = exp@name, region = approxim$region, year = approxim$mileStoneYears, slice = approxim$slice)
  if (!is.null(pExportRow) && nrow(pExportRow) != 0) {
    pExportRow2 <- pExportRow[pExportRow$type == 'up' & pExportRow$value == 0, 
    													colnames(pExportRow) %in% colnames(mExportRow), with = FALSE]
    if (nrow(pExportRow2) != 0) {
      pExportRow2 <- mExportRow[1, 1:2]
      if (ncol(pExportRow2) != ncol(mExportRow)) pExportRow2 <- .merge_with_null(mExportRow, pExportRow2)
      mExportRow <- mExportRow[(!duplicated(rbind(mExportRow, pExportRow2), fromLast = TRUE)[1:nrow(mExportRow)]),]
    }
  }
  mExportRow$comm <- exp@commodity
  obj@parameters[['mExportRow']] <- .add_data(obj@parameters[['mExportRow']], mExportRow)
  if (!is.null(pExportRow) && any(pExportRow$type == 'up' & pExportRow$value != Inf & pExportRow$value != 0)) {
    mExportRowUp <- pExportRow[pExportRow$type == 'up' & pExportRow$value != Inf & pExportRow$value != 0, 
			colnames(pExportRow) %in% obj@parameters[['mExportRowUp']]@dimSetNames, with = FALSE]
    mExportRowUp$comm <- exp@commodity
    if (!all(obj@parameters[['mExportRowUp']]@dimSetNames %in% mExportRowUp)) 
      mExportRowUp <- .merge_with_null(mExportRow, mExportRowUp)
    obj@parameters[['mExportRowUp']] <- .add_data(obj@parameters[['mExportRowUp']], mExportRowUp)
    meqExportRowLo <- pExportRow[pExportRow$type == 'lo' & pExportRow$value != 0, 
    														 colnames(pExportRow) %in% obj@parameters[['meqExportRowLo']]@dimSetNames, with = FALSE]
    meqExportRowLo$comm <- exp@commodity
    if (!all(obj@parameters[['meqExportRowLo']]@dimSetNames %in% meqExportRowLo)) 
      meqExportRowLo <- .merge_with_null(mExportRow, meqExportRowLo)
    obj@parameters[['meqExportRowLo']] <- .add_data(obj@parameters[['meqExportRowLo']], 
              .merge_with_null(mExportRow, meqExportRowLo)) 
  }
  if (!is.null(pExportRowRes)) {
    pExportRowRes$comm <- exp@commodity
    obj@parameters[['mExportRowAccumulatedUp']] <- .add_data(obj@parameters[['mExportRowAccumulatedUp']], 
           pExportRowRes[pExportRowRes$value != Inf, c('expp', 'comm'), with = FALSE])
  }
  obj
})

#==============================================================================#
# Add import ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'import',
  approxim = 'list'), 
  function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    # imp <- energyRt:::.upper_case(app)
  imp <- app
  if (length(imp@commodity) != 1 || is.na(imp@commodity) || all(imp@commodity != approxim$all_comm))
			stop(paste0('Wrong commodity in import "', imp@name, '"'))
  imp <- stayOnlyVariable(imp, approxim$region, 'region')
  approxim <- .fix_approximation_list(approxim, comm = imp@commodity, lev = imp@slice)
  imp <- .disaggregateSliceLevel(imp, approxim)
  mImpSlice <- data.table(imp = rep(imp@name, length(approxim$slice)), slice = approxim$slice)
  obj@parameters[['mImpSlice']] <- .add_data(obj@parameters[['mImpSlice']],  mImpSlice)
  mImpComm <- data.table(imp = imp@name, comm = imp@commodity)
  obj@parameters[['mImpComm']] <- .add_data(obj@parameters[['mImpComm']], mImpComm)
  pImportRowPrice <- simpleInterpolation(imp@imp, 'price',
                                         obj@parameters[['pImportRowPrice']], approxim, 'imp', imp@name)
  obj@parameters[['pImportRowPrice']] <- .add_data(obj@parameters[['pImportRowPrice']], pImportRowPrice)
  pImportRowRes <- NULL
  if (imp@reserve != Inf) pImportRowRes <- data.table(imp = imp@name, value = imp@reserve)
  obj@parameters[['pImportRowRes']] <- .add_data(obj@parameters[['pImportRowRes']], pImportRowRes)
  pImportRow <- multiInterpolation(imp@imp, 'imp',
                                   obj@parameters[['pImportRow']], approxim, 'imp', imp@name)
  obj@parameters[['pImportRow']] <- .add_data(obj@parameters[['pImportRow']], pImportRow)
  mImportRow <- CJ(imp = imp@name, region = approxim$region, year = approxim$mileStoneYears, slice = approxim$slice)
  if (!is.null(pImportRow) && nrow(pImportRow) != 0) {
    pImportRow2 <- pImportRow[pImportRow$type == 'up' & pImportRow$value == 0, 
    													colnames(pImportRow) %in% colnames(mImportRow), with = FALSE]
    if (nrow(pImportRow2) != 0) {
      pImportRow2 <- mImportRow[1, 1:2]
      if (ncol(pImportRow2) != ncol(mImportRow)) pImportRow2 <- .merge_with_null(mImportRow, pImportRow2)
      mImportRow <- mImportRow[(!duplicated(rbind(mImportRow, pImportRow2), fromLast = TRUE)[1:nrow(mImportRow)]),]
    }
  }
  mImportRow$comm <- imp@commodity
  obj@parameters[['mImportRow']] <- .add_data(obj@parameters[['mImportRow']], mImportRow)
   if (!is.null(pImportRow)) {
    mImportRowUp <- pImportRow[pImportRow$type == 'up' & pImportRow$value != Inf & pImportRow$value != 0, 
    													 colnames(pImportRow) %in% obj@parameters[['mImportRowUp']]@dimSetNames, with = FALSE]
    mImportRowUp$comm <- imp@commodity
    if (!all(obj@parameters[['mImportRowUp']]@dimSetNames %in% mImportRowUp)) 
      mImportRowUp <- .merge_with_null(mImportRow, mImportRowUp)
    obj@parameters[['mImportRowUp']] <- .add_data(obj@parameters[['mImportRowUp']], mImportRowUp)
    meqImportRowLo <- pImportRow[pImportRow$type == 'lo' & pImportRow$value != 0, 
    														 colnames(pImportRow) %in% obj@parameters[['meqImportRowLo']]@dimSetNames, with = FALSE]
    meqImportRowLo$comm <- imp@commodity
    if (!all(obj@parameters[['meqImportRowLo']]@dimSetNames %in% meqImportRowLo)) 
      meqImportRowLo <- .merge_with_null(mImportRow, meqImportRowLo)
    obj@parameters[['meqImportRowLo']] <- .add_data(obj@parameters[['meqImportRowLo']], 
              .merge_with_null(mImportRow, meqImportRowLo)) 
   }
  if (!is.null(pImportRowRes)) {
    pImportRowRes$comm <- exp@commodity
    obj@parameters[['mImportRowAccumulatedUp']] <- .add_data(obj@parameters[['mImportRowAccumulatedUp']], 
           pImportRowRes[pImportRowRes$value != Inf, c('expp', 'comm'), with = FALSE])
  }
  obj
})

#==============================================================================#
# ??? ####
#==============================================================================#
.start_end_fix <- function(approxim, app, als, stock_exist) {
  if (is.null(stock_exist)) stock_exist <- data.table()
  stock_exist <- stock_exist[stock_exist$value != 0, ]
  # Start / End year
  dd <- CJ(enable = TRUE, app = app@name,
			region = approxim$region, year = approxim$year)  
  
  colnames(dd)[2] <- als
  dstart_ind <- seq_along(approxim$region)
  names(dstart_ind) <- approxim$region
  dstart <- data.table(region = approxim$region, year = as.numeric(rep(NA, length(approxim$region))))
  fl <- is.na(app@start$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dstart$year <- app@start$start[fl]
  }
  if (any(!fl)) {
    dstart[dstart_ind[app@start$region[!fl]], year] <- app@start$start[!fl]
  }
  dstart <- dstart[!is.na(dstart$year),]
  for(rr in seq_along(dstart$region)) {
    if (!is.na(dstart$year[rr]) && any(dd$year < dstart$year[rr]))
    	dd$enable[dd$region == dstart$region[rr] & dd$year < dstart$year[rr]] <- FALSE
  } 
  dd_able <- dd
  ## end 
  dend <- data.table(region = approxim$region, 
                     year = as.numeric(rep(NA, length(approxim$region))))
  fl <- is.na(app@end$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dend$year <- app@end$end[fl]
  }
  if (any(!fl)) {
    dend$year[dstart_ind[app@end$region[!fl]]] <- app@end$end[!fl]
  }
  dend <- dend[!is.na(dend$year),]
  for(rr in seq_along(dend$region)) {
    if (any(dd$year > dend$year[rr])) dd$enable[dd$region == dend$region[rr] & dd$year > dend$year[rr]] <- FALSE
  }  
  dd <- dd[dd$enable, -1, with = FALSE]
  ## life 
  dlife <- data.table(region = approxim$region, year = as.numeric(rep(NA, length(approxim$region))))
  fl <- is.na(app@olife$region)
  if (any(fl)) {
    if (sum(fl) != 1) stop('Wrong start year for "', class(app), '" ', app@name)
    dlife$year <- app@olife$olife[fl]
  }
  if (any(!fl)) {
    dlife$year[dstart_ind[app@olife$region][!fl]] <- app@olife$olife[!fl]
  }
  dlife <- dlife[!is.na(dlife$year),]
  for(rr in seq_along(dlife$region)[dlife$region %in% dend$region]) {
    if (any(dd_able$year >= dend$year[dlife$region[rr]] + dlife$year[dlife$region[rr]])) 
      dd_able$enable[dd_able$region == dlife$region[rr] & dd_able$year >= dend$year[dstart_ind[rr]] + dlife$year[rr]] <- FALSE
  }  
  dd_eac <- dd_able
  if (nrow(stock_exist) != 0 && any(!dd_able$enable)) {
    for(rr in unique(stock_exist$region)) {
      dd_able$enable[dd_able$region == rr & dd_able$year %in% stock_exist$year[stock_exist$region == rr]] <- TRUE
    }
  }   
  # 
  dd_able <- dd_able[dd_able$enable, -1, with = FALSE]
  dd_eac <- dd_eac[dd_eac$enable, -1, with = FALSE]
  dd <- dd[dd$year %in% approxim$mileStoneYears, ]
  dd_eac <- dd_eac[dd_eac$year %in% approxim$mileStoneYears, ]
  dd_able <- dd_able[dd_able$year %in% approxim$mileStoneYears, ]
  list(new = dd, span = dd_able, eac = dd_eac)
}


#==============================================================================#
# Add sysInfo ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'sysInfo', approxim = 'list'), 
  function(obj, app, approxim) {
    clean_list <- c('mSliceParentChild', 'mSliceParentChildE', 'mSliceNext', 
                    'mSliceFYearNext', 'pDiscount', 'pSliceShare', 'pDummyImportCost', 
                    'pDummyExportCost', 'mStartMilestone', 'mEndMilestone', 
                    'mMilestoneLast', 'mMilestoneFirst', 'mMilestoneNext', 
                    'mMilestoneHasNext', 'mSameSlice', 'mSameRegion', 'ordYear', 
                    'cardYear', 'pPeriodLen', 'pDiscountFactor', 'mDiscountZero')
    for (i in clean_list)
      obj@parameters[[i]] <- .resetParameter(obj@parameters[[i]])
  obj <- .drop_sysinfo_param(obj)
  app <- stayOnlyVariable(app, approxim$region, 'region')
  obj@parameters[['mSliceParentChild']] <- .add_data(obj@parameters[['mSliceParentChild']],
                                  data.table(slice = as.character(approxim$slice@all_parent_child$parent), 
                                             slicep = as.character(approxim$slice@all_parent_child$child)))
  obj@parameters[['mSliceParentChildE']] <- .add_data(obj@parameters[['mSliceParentChildE']],
                  data.table(slice = as.character(c(app@slice@all_slice, approxim$slice@all_parent_child$parent)), 
                             slicep = as.character(c(app@slice@all_slice, approxim$slice@all_parent_child$child))))
  if (length(approxim$slice@misc$next_slice) != 0) {
    obj@parameters[['mSliceNext']] <- .add_data(obj@parameters[['mSliceNext']], approxim$slice@misc$next_slice)
    obj@parameters[['mSliceFYearNext']] <- .add_data(obj@parameters[['mSliceFYearNext']], 
                                                   approxim$slice@misc$fyear_next_slice)
  }
  # Discount
  approxim_no_mileStone_Year <- approxim
  approxim_no_mileStone_Year$mileStoneYears <- NULL
  pDiscount <- simpleInterpolation(app@discount, 'discount',
                      obj@parameters[['pDiscount']], approxim_no_mileStone_Year, all.val = TRUE)
  obj@parameters[['pDiscount']] <- .add_data(obj@parameters[['pDiscount']], pDiscount)
  approxim_comm <- approxim
  approxim_comm[['comm']] <- approxim$all_comm
  obj@parameters[['pSliceShare']] <- .add_data(obj@parameters[['pSliceShare']], 
                                             data.table(slice = approxim$slice@slice_share$slice, 
                                                        value = approxim$slice@slice_share$share))
  approxim_comm$slice <- approxim$slice@all_slice

  if (nrow(app@milestone) == 0) {
    app <- setMilestoneYears(app, start = min(app@year), interval = rep(1, length(app@year)))
  }

  obj@parameters[['mStartMilestone']] <- .add_data(obj@parameters[['mStartMilestone']], 
    data.table(year = app@milestone$mid, yearp = app@milestone$start))
  obj@parameters[['mEndMilestone']] <- .add_data(obj@parameters[['mEndMilestone']], 
    data.table(year = app@milestone$mid, yearp = app@milestone$end))
  obj@parameters[['mMilestoneLast']] <- .add_data(obj@parameters[['mMilestoneLast']], 
  	data.table(year = max(app@milestone$mid)))
  obj@parameters[['mMilestoneFirst']] <- .add_data(obj@parameters[['mMilestoneFirst']], 
  	data.table(year = min(app@milestone$mid)))
  
  obj@parameters[['mMilestoneNext']] <- .add_data(obj@parameters[['mMilestoneNext']], 
    data.table(year = app@milestone$mid[-nrow(app@milestone)], yearp = app@milestone$mid[-1])) 
  obj@parameters[['mMilestoneHasNext']] <- .add_data(obj@parameters[['mMilestoneHasNext']], 
    data.table(year = app@milestone$mid[-nrow(app@milestone)])) 

  obj@parameters[['mSameSlice']] <- .add_data(obj@parameters[['mSameSlice']], 
    data.table(slice = app@slice@all_slice, slicep = app@slice@all_slice))
  obj@parameters[['mSameRegion']] <- .add_data(obj@parameters[['mSameRegion']], 
    data.table(region = app@region, regionp = app@region))
  tmp <- .get_data_slot(obj@parameters$year)
  tmp$value <- seq_along(tmp$year)
  obj@parameters[['ordYear']] <- .add_data(obj@parameters[['ordYear']], tmp)
  obj@parameters[['cardYear']] <- .add_data(obj@parameters[['cardYear']], tmp[nrow(tmp),])
  
  obj@parameters[['pPeriodLen']] <- .add_data(obj@parameters[['pPeriodLen']], 
     data.table(year = app@milestone$mid, value = (app@milestone$end - app@milestone$start + 1)))
  
  ####################################################
  pDiscount <- pDiscount[sort(pDiscount$year, index.return = TRUE)$ix,]
  pDiscountFactor <- pDiscount[0,]
  for(l in unique(pDiscount$region)) {
    dd <- pDiscount[pDiscount$region == l,]
    dd$value <- cumprod(1 / (1 + dd$value))
    pDiscountFactor <- rbind(pDiscountFactor, dd)
  }
  obj@parameters[['pDiscountFactor']] <- .add_data(obj@parameters[['pDiscountFactor']], pDiscountFactor)
  # pDiscountFactorMileStone
  yrr <- app@milestone$start[1]:app@milestone$end[nrow(app@milestone)]
  tyr <- rep(NA, length(yrr))
  names(tyr) <- yrr
  for (yr in seq_len(nrow(app@milestone))) {
    tyr[app@milestone$start[yr] <= yrr & yrr <= app@milestone$end[yr]] <- app@milestone$mid[yr]
  }
  pDiscountFactorMileStone <- pDiscountFactor
  pDiscountFactorMileStone$year <- tyr[as.character(pDiscountFactorMileStone$year)]
  pDiscountFactorMileStone <- pDiscountFactorMileStone %>% group_by(region, year) %>%
  									summarise(.groups = 'drop', value = sum(value))
  if (!app@discountFirstYear) {
    dsc <- pDiscount[pDiscount$year == min(pDiscount$year), ]
    dsc$mlt <- dsc$value + 1
    pDiscountFactorMileStone <- merge(pDiscountFactorMileStone, dsc[, c('region', 'mlt'), with = FALSE])
    pDiscountFactorMileStone$value <- pDiscountFactorMileStone$value * pDiscountFactorMileStone$mlt
    pDiscountFactorMileStone$mlt <- NULL
    pDiscountFactorMileStone <- as.data.table(pDiscountFactorMileStone)
  }
  obj@parameters[['pDiscountFactorMileStone']] <- .add_data(obj@parameters[['pDiscountFactorMileStone']], 
  																													pDiscountFactorMileStone)
  # pDiscountFactorMileStone
  mDiscountZero <- pDiscount[pDiscount$year == as.character(max(app@year)), -2]
  mDiscountZero <- mDiscountZero[mDiscountZero$value == 0, 'region', with = FALSE]
  # Add mDiscountZero - zero discount rate in final period
  if (nrow(mDiscountZero) != 0) {
    obj@parameters[['mDiscountZero']] <- .add_data(obj@parameters[['mDiscountZero']], mDiscountZero)
  } 
  obj
})



#==============================================================================#
# Add constraint ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'constraint',
                             approxim = 'list'), function(obj, app, approxim) {
                               .getSetEquation(obj, app, approxim)
                             })

#==============================================================================#
# Add costs ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'costs',
                             approxim = 'list'), function(obj, app, approxim) {
                               .getCostEquation(obj, app, approxim)
                             })

#==============================================================================#
# Add tax & sub ####
#==============================================================================#
.subtax_approxim <- function(obj, app, tax, whr, approxim) {
  if (all(app@comm != names(approxim$commodity_slice_map)))
    stop('Unknown commodity "', app@comm, '" in ', whr, ' "', app@name, '"')
  if (length(app@region) != 0) {
    if (!all(app@region %in% approxim$region))
      stop(paste0(whr, ': unknown region "', paste0(app@region[!(app@region %in% approxim$region)], collapse = '", "'), '"'))
    approxim$region <- app@region
  }
  approxim$slice <- approxim$slice@slice_map[[approxim$commodity_slice_map[[app@comm]]]]
  if (whr == 'tax') {
		for (ii in c('Inp', 'Out', 'Bal')) {
	  	obj@parameters[[paste0('pTaxCost', ii)]] <- .add_data(obj@parameters[[paste0('pTaxCost', ii)]],
	    	  simpleInterpolation(app@tax, tolower(ii), obj@parameters[[paste0('pTaxCost', ii)]], 
	    	  										approxim, 'comm', app@comm))
		}
  } else if (whr == 'subsidy') {
		for (ii in c('Inp', 'Out', 'Bal')) {
	  	obj@parameters[[paste0('pSubCost', ii)]] <- .add_data(obj@parameters[[paste0('pSubCost', ii)]],
	    	  simpleInterpolation(app@sub, tolower(ii), obj@parameters[[paste0('pSubCost', ii)]], 
	    	  										approxim, 'comm', app@comm))
		}
  } else stop('internal error ', whr)
  obj
}
#==============================================================================#
# Add tax ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'tax',
                             approxim = 'list'), function(obj, app, approxim) {
                               .subtax_approxim(obj, app, tax, whr = 'tax', approxim) 
                             })


#==============================================================================#
# Add sub ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'sub',
                             approxim = 'list'), function(obj, app, approxim) {
                               .subtax_approxim(obj, app, tax, whr = 'subsidy', approxim) 
                             })

#==============================================================================#
# Add storage ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'storage', approxim = 'list'), 
          function(obj, app, approxim) {
            pStorageCout <- NULL; pStorageCinp <- NULL;
            # stg <- energyRt:::.upper_case(app)
            stg <- app
            if (length(stg@commodity) != 1 || is.na(stg@commodity) || all(stg@commodity != approxim$all_comm))
              stop(paste0('Wrong commodity in storage "', stg@name, '"'))
            
            stg_slice <- approxim$slice@slice_map[[approxim$commodity_slice_map[[stg@commodity]]]]
            approxim <- .fix_approximation_list(approxim, comm = stg@commodity, lev = NULL)
            stg <- .disaggregateSliceLevel(stg, approxim)
            if (length(stg@region) != 0) {
              approxim$region <- approxim$region[approxim$region %in% stg@region]
              ss <- getSlots('storage')
              ss <- names(ss)[ss == 'data.table']
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
            if (stg@fullYear)
              obj@parameters[['mStorageFullYear']] <- .add_data(obj@parameters[['mStorageFullYear']],
                                                                data.table(stg = stg@name))
            obj@parameters[['mStorageComm']] <- .add_data(obj@parameters[['mStorageComm']],
                                                          data.table(stg = stg@name, comm = stg@commodity))
            olife <- simpleInterpolation(stg@olife, 'olife', obj@parameters[['pStorageOlife']], 
                                         approxim, 'stg', stg@name, removeDefault = FALSE)
            obj@parameters[['pStorageOlife']] <- .add_data(obj@parameters[['pStorageOlife']], olife)
            # Loss
            obj@parameters[['pStorageInpEff']] <- .add_data(obj@parameters[['pStorageInpEff']],
                 simpleInterpolation(stg@seff, 'inpeff', obj@parameters[['pStorageInpEff']], 
                   approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
            obj@parameters[['pStorageOutEff']] <- .add_data(obj@parameters[['pStorageOutEff']],
                       simpleInterpolation(stg@seff, 'outeff', obj@parameters[['pStorageOutEff']], 
                            approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
            obj@parameters[['pStorageStgEff']] <- .add_data(obj@parameters[['pStorageStgEff']], 
                            simpleInterpolation(stg@seff, 'stgeff',  obj@parameters[['pStorageStgEff']], 
                                                approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
            # Cost
            pStorageCostInp <- simpleInterpolation(stg@varom, 'inpcost',
                                                   obj@parameters[['pStorageCostInp']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageCostInp']] <- .add_data(obj@parameters[['pStorageCostInp']], pStorageCostInp)
            pStorageCostOut <- simpleInterpolation(stg@varom, 'outcost',
                                                   obj@parameters[['pStorageCostOut']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageCostOut']] <- .add_data(obj@parameters[['pStorageCostOut']], pStorageCostOut)
            
            pStorageCostStore <- simpleInterpolation(stg@varom, 'stgcost',
                                                     obj@parameters[['pStorageCostStore']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageCostStore']] <- .add_data(obj@parameters[['pStorageCostStore']], pStorageCostStore)
            
            pStorageFixom <- simpleInterpolation(stg@fixom, 'fixom',
                                                 obj@parameters[['pStorageFixom']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageFixom']] <- .add_data(obj@parameters[['pStorageFixom']], pStorageFixom)
            # Ava/Cap
            pStorageAf <- multiInterpolation(stg@af, 'af', obj@parameters[['pStorageAf']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageAf']] <- .add_data(obj@parameters[['pStorageAf']], pStorageAf)
            obj@parameters[['pStorageCap2stg']] <- .add_data(obj@parameters[['pStorageCap2stg']],
                                                         data.table(stg = stg@name, value = stg@cap2stg))
            pStorageCinp <-  multiInterpolation(stg@af, 'cinp', obj@parameters[['pStorageCinp']], approxim, 
            																		c('stg', 'comm'), c(stg@name, stg@commodity))
            obj@parameters[['pStorageCinp']] <- .add_data(obj@parameters[['pStorageCinp']], pStorageCinp) 
            pStorageCout <- multiInterpolation(stg@af, 'cout', obj@parameters[['pStorageCout']], approxim, 
            																	 c('stg', 'comm'), c(stg@name, stg@commodity))
            obj@parameters[['pStorageCout']] <- .add_data(obj@parameters[['pStorageCout']], pStorageCout)
            # Aux input/output
            if (nrow(stg@aux) != 0) {
              if (any(!(stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in% stg@aux$acomm[!is.na(stg@aux$acomm)]))) {
                cmm <- stg@aeff$acomm[!is.na(stg@aeff$acomm)][stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in% stg@aux$acomm[!is.na(stg@aux$acomm)]]
                stop(paste0('Unknown aux commodity "', paste0(cmm, collapse = '", "'), '", in storage "', stg@name, '"'))
              }
              stg@aeff <- stg@aeff[!is.na(stg@aeff$acomm),, drop = FALSE]
              ainp_flag <- c('stg2ainp', 'cinp2ainp', 'cout2ainp', 'cap2ainp', 'ncap2ainp')
              aout_flag <- c('stg2aout', 'cinp2aout', 'cout2aout', 'cap2aout', 'ncap2aout')
              cmp_inp <- stg@aeff[apply(!is.na(stg@aeff[, ainp_flag]), 1, any), 'acomm']
              cmp_out <- stg@aeff[apply(!is.na(stg@aeff[, aout_flag]), 1, any), 'acomm']
              mStorageAInp <- data.table(stg = rep(stg@name, length(cmp_inp)), comm = cmp_inp)
              obj@parameters[['mStorageAInp']] <- .add_data(obj@parameters[['mStorageAInp']], mStorageAInp)
              mStorageAOut <- data.table(stg = rep(stg@name, length(cmp_out)), comm = cmp_out)
              obj@parameters[['mStorageAOut']] <- .add_data(obj@parameters[['mStorageAOut']], mStorageAOut)
              dd <- data.table(
              	list = c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 'pStorageCout2AInp', 
                     'pStorageCout2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 'pStorageNCap2AInp', 'pStorageNCap2AOut'),
                table = c('stg2ainp', 'stg2aout', 'cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout', 'cap2ainp', 'cap2aout', 
                					'ncap2ainp', 'ncap2aout'))
              approxim_comm <- approxim
              aout_tmp <- list()
              for(i in 1:nrow(dd)) {
                approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
                approxim_comm[['acomm']] <- unique(stg@aeff[!is.na(stg@aeff[, dd$table[i]]), 'acomm'])
                if (length(approxim_comm[['acomm']]) != 0) {
                  aout_tmp[[dd$list[i]]] <- simpleInterpolation(stg@aeff, dd$table[i],
                  	 obj@parameters[[dd$list[i]]], approxim_comm, 'stg', stg@name)
                  obj@parameters[[dd$list[i]]] <- .add_data(obj@parameters[[dd$list[i]]], aout_tmp[[dd$list[i]]])
                }
              }                
            } else {
              if (nrow(stg@aeff) != 0 && any(stg@aeff$acomm[!is.na(stg@aeff$acomm)]))
                stop(paste0('Unknown aux commodity "', paste0(stg@aeff$acomm[!is.na(stg@aeff$acomm)], collapse = '", "'), 
                            '", in storage "', stg@name, '"'))
            }
            if (any(!is.na(stg@aeff$ncap2stg) & stg@aeff$ncap2stg != 0)) {
              fl <- (!is.na(stg@aeff$ncap2stg) & stg@aeff$ncap2stg != 0)
              if (any(is.na(stg@aeff[fl, c('region', 'year', 'slice')])))
                stop(paste0('Approximation is not allowed for storage "', stg@name, '" parameter ncap2stg'))
              tmp <- stg@aeff[fl, c('region', 'year', 'slice', 'ncap2stg')]
              tmp$stg <- stg@name
              tmp$comm <- stg@commodity
              tmp$value <- tmp$ncap2stg
              tmp <- tmp[, c('stg', 'comm', 'region', 'year', 'slice', 'value')]
              obj@parameters[['pStorageNCap2Stg']] <- .add_data(obj@parameters[['pStorageNCap2Stg']], tmp)
            }
            
            if (any(!is.na(stg@charge$charge) & stg@charge$charge != 0)) {
              fl <- (!is.na(stg@charge$charge) & stg@charge$charge != 0)
              if (any(is.na(stg@charge[fl, c('region', 'year', 'slice')])))
                stop(paste0('Approximation is not allowed for storage "', stg@name, '" parameter charge'))
              tmp <- stg@charge[fl, c('region', 'year', 'slice', 'charge')]
              tmp$stg <- stg@name
              tmp$comm <- stg@commodity
              tmp$value <- tmp$charge
              tmp <- tmp[, c('stg', 'comm', 'region', 'year', 'slice', 'value')]
              obj@parameters[['pStorageCharge']] <- .add_data(obj@parameters[['pStorageCharge']], tmp)
            }
            # Some slice
            stock_exist <- simpleInterpolation(stg@stock, 'stock', 
                                               obj@parameters[['pStorageStock']], approxim, 'stg', stg@name)
            obj@parameters[['pStorageStock']] <- .add_data(obj@parameters[['pStorageStock']], stock_exist)
            invcost <- simpleInterpolation(stg@invcost, 'invcost', obj@parameters[['pStorageInvcost']], 
            															 approxim, 'stg', stg@name)
            obj@parameters[['pStorageInvcost']] <- .add_data(obj@parameters[['pStorageInvcost']], invcost)
            
            dd0 <- energyRt:::.start_end_fix(approxim, stg, 'stg', stock_exist)
            dd0$new <-  dd0$new[dd0$new$year   %in% approxim$mileStoneYears & dd0$new$region  %in% approxim$region,]
            dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears & dd0$span$region %in% approxim$region,]
            obj@parameters[['mStorageNew']] <- .add_data(obj@parameters[['mStorageNew']], dd0$new)
            mStorageSpan <- dd0$span
            obj@parameters[['mStorageSpan']] <- .add_data(obj@parameters[['mStorageSpan']], dd0$span)
            obj@parameters[['mStorageEac']] <- .add_data(obj@parameters[['mStorageEac']], dd0$eac)
            
            if (nrow(dd0$new) > 0  && !is.null(invcost) && nrow(invcost) > 0) {
              salv_data <- .merge_with_null(dd0$new, approxim$discount, all.x = TRUE)
              salv_data$value[is.na(salv_data$value)] <- 0
              salv_data$discount <- salv_data$value; salv_data$value <- NULL
              olife$olife <- olife$value; olife$value <- NULL
              salv_data <- .merge_with_null(salv_data, olife)
              invcost$invcost <- invcost$value; invcost$value <- NULL
              salv_data <- .merge_with_null(salv_data, invcost)
              # EAC
              salv_data$eac <- salv_data$invcost / salv_data$olife
              fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
              salv_data$eac[fl] <- salv_data$invcost[fl] * 
              	(salv_data$discount[fl] * (1 + salv_data$discount[fl]) ^ salv_data$olife[fl] / 
                     ((1 + salv_data$discount[fl]) ^ salv_data$olife[fl] - 1))
              fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
              salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
              salv_data$tech <- stg@name
              salv_data$value <- salv_data$eac
              pStorageEac <- salv_data[, c('stg', 'region', 'year', 'value')]
              obj@parameters[['pStorageEac']] <- .add_data(obj@parameters[['pStorageEac']], 
                      unique(pStorageEac[, colnames(pStorageEac) %in% c(obj@parameters[['pStorageEac']]@dimSetNames, 'value'),
                      									 with = FALSE]))
            }
            
            
            if (nrow(stg@weather) > 0) {
              tmp <- .toWeatherImply(stg@weather, 'waf', 'stg', stg@name)
              obj@parameters[['pStorageWeatherAf']] <- .add_data(obj@parameters[['pStorageWeatherAf']], tmp$par)
              obj@parameters[['mStorageWeatherAfUp']] <- .add_data(obj@parameters[['mStorageWeatherAfUp']], tmp$mapup)
              obj@parameters[['mStorageWeatherAfLo']] <- .add_data(obj@parameters[['mStorageWeatherAfLo']], tmp$maplo)
              
              tmp <- .toWeatherImply(stg@weather, 'wcinp', 'stg', stg@name)
              obj@parameters[['pStorageWeatherCinp']] <- .add_data(obj@parameters[['pStorageWeatherCinp']], tmp$par)
              obj@parameters[['mStorageWeatherCinpUp']] <- .add_data(obj@parameters[['mStorageWeatherCinpUp']], tmp$mapup)
              obj@parameters[['mStorageWeatherCinpLo']] <- .add_data(obj@parameters[['mStorageWeatherCinpLo']], tmp$maplo)
              
              tmp <- .toWeatherImply(stg@weather, 'wcout', 'stg', stg@name)
              obj@parameters[['pStorageWeatherCout']] <- .add_data(obj@parameters[['pStorageWeatherCout']], tmp$par)
              obj@parameters[['mStorageWeatherCoutUp']] <- .add_data(obj@parameters[['mStorageWeatherCoutUp']], tmp$mapup)
              obj@parameters[['mStorageWeatherCoutLo']] <- .add_data(obj@parameters[['mStorageWeatherCoutLo']], tmp$maplo)
            }
            pStorageOlife <- olife
            if (any(pStorageOlife$olife != Inf)) {
              mStorageOlifeInf <- pStorageOlife[pStorageOlife$olife != Inf, colnames(pStorageOlife) %in% 
                                                  obj@parameters[['mStorageOlifeInf']]@dimSetNames, with = FALSE]
              if (ncol(mStorageOlifeInf) != ncol(obj@parameters[['mStorageOlifeInf']]@data))
                mStorageOlifeInf <- .merge_with_null(mStorageOlifeInf, mStorageSpan[, colnames(mStorageSpan) %in% 
                    obj@parameters[['mStorageOlifeInf']]@dimSetNames, with = FALSE])
              obj@parameters[['mStorageOlifeInf']] <- .add_data(obj@parameters[['mStorageOlifeInf']], mStorageOlifeInf)
            }
            dsm <- obj@parameters[['mStorageOMCost']]@dimSetNames
            mStorageOMCost <- NULL
            if (!is.null(mStorageOMCost)) 
            	mStorageOMCost <- rbind(mStorageOMCost, pStorageFixom[pStorageFixom$value != 0, dsm, with = FALSE])
            if (!is.null(mStorageOMCost)) 
            	mStorageOMCost <- rbind(mStorageOMCost, pStorageCostInp[pStorageCostInp$value != 0, dsm, with = FALSE])
            if (!is.null(mStorageOMCost)) 
            	mStorageOMCost <- rbind(mStorageOMCost, pStorageCostOut[pStorageCostOut$value != 0, dsm, with = FALSE])
            if (!is.null(mStorageOMCost))
            	mStorageOMCost <- rbind(mStorageOMCost, pStorageCostStore[pStorageCostStore$value != 0, dsm, with = FALSE])
            if (!is.null(mStorageOMCost)) {
              mStorageOMCost <- .merge_with_null(mStorageOMCost[!duplicated(mStorageOMCost), ], mStorageSpan)
              obj@parameters[['mStorageOMCost']] <- .add_data(obj@parameters[['mStorageOMCost']], mStorageOMCost)
            }
            mvStorageStore <- .merge_with_null(mStorageSpan, list(slice = stg_slice))
            mvStorageStore$comm <- stg@commodity
            obj@parameters[['mvStorageStore']] <- .add_data(obj@parameters[['mvStorageStore']], mvStorageStore)
            
            if (nrow(stg@aux) != 0) {
              mvStorageStore2 <- mvStorageStore; mvStorageStore2$comm <- NULL
              mvStorageAInp <- .merge_with_null(mvStorageStore2, mStorageAInp)
              obj@parameters[['mvStorageAInp']] <- .add_data(obj@parameters[['mvStorageAInp']], mvStorageAInp)
              mvStorageAOut <- .merge_with_null(mvStorageStore2, mStorageAOut)
              obj@parameters[['mvStorageAOut']] <- .add_data(obj@parameters[['mvStorageAOut']], mvStorageAOut)
              for (i in c('mStorageStg2AOut', 'mStorageCinp2AOut', 'mStorageCout2AOut', 'mStorageCap2AOut', 
              						'mStorageNCap2AOut', 'mStorageStg2AInp', 'mStorageCinp2AInp', 'mStorageCout2AInp', 
              						'mStorageCap2AInp', 'mStorageNCap2AInp')) 
                if (!is.null(aout_tmp[[gsub('^m', 'p', i)]])) {
                  atmp <- aout_tmp[[gsub('^m', 'p', i)]]
                  if (any(grep('Out$', i))) {
                    atmp <- atmp[, colnames(atmp)%in% colnames(mvStorageAOut), with = FALSE]
                    if (ncol(atmp) != 5) atmp <- .merge_with_null(atmp, mvStorageAOut)
                  } else {
                    atmp <- atmp[, colnames(atmp)%in% colnames(mvStorageAInp), with = FALSE]
                    if (ncol(atmp) != 5) atmp <- .merge_with_null(atmp, mvStorageAInp)
                  }
                  obj@parameters[[i]] <- .add_data(obj@parameters[[i]], atmp)
                }
            }
            rem_inf_def1 <- function(x, y) {
              if (is.null(x)) return(y)
              x <- x[x$type == 'up' & x$value == Inf, ]
              y[(!duplicated(rbind(y, x)))[1:nrow(y)], ]
            }
            rem_inf_def_inf <- function(x, y) {
              .merge_with_null(x[x$type == 'up' & x$value != Inf, colnames(x) %in% colnames(y), with = FALSE], y)
            }
            obj@parameters[['meqStorageAfLo']] <- .add_data(obj@parameters[['meqStorageAfLo']], 
            .merge_with_null(pStorageAf[pStorageAf$type == 'lo' & pStorageAf$value != 0,], mvStorageStore))
            obj@parameters[['meqStorageAfUp']] <- .add_data(obj@parameters[['meqStorageAfUp']], 
            						rem_inf_def1(pStorageAf, mvStorageStore))
            if (!is.null(pStorageCinp)) {
              obj@parameters[['meqStorageInpLo']] <- .add_data(obj@parameters[['meqStorageInpLo']], 
              			.merge_with_null(pStorageCinp[pStorageCinp$type == 'lo' & pStorageCinp$value != 0, 
                         colnames(pStorageCinp) %in% obj@parameters[['meqStorageInpLo']]@dimSetNames, with = FALSE], 
              						mvStorageStore))
              obj@parameters[['meqStorageInpUp']] <- .add_data(obj@parameters[['meqStorageInpUp']], 
              																								 rem_inf_def_inf(pStorageCinp, mvStorageStore))
            }
            if (!is.null(pStorageCout)) {
              obj@parameters[['meqStorageOutLo']] <- .add_data(obj@parameters[['meqStorageOutLo']], 
                     .merge_with_null(pStorageCout[pStorageCout$type == 'lo' & pStorageCout$value != 0, 
                       colnames(pStorageCout) %in% obj@parameters[['meqStorageOutLo']]@dimSetNames, with = FALSE], 
                       mvStorageStore))
              obj@parameters[['meqStorageOutUp']] <- .add_data(obj@parameters[['meqStorageOutUp']], 
              																								 rem_inf_def_inf(pStorageCout, mvStorageStore))
            }
            
            obj
          })


.merge_with_null <- function(x, y, by = NULL, ...) {
	if (is.null(x) || is.null(y) || nrow(x) == 0 || nrow(y) == 0) return(NULL)
	if (length(by) == 0) by <- intersect(colnames(x), colnames(y))
	if (length(by) == 0) return(data.table(crossing(x, y)))
	if (ncol(x) == ncol(y) && ncol(x) == length(by))
		return(rbind(x, y)[duplicated(rbind(x, y)), ])
	return (merge(x, y, by = by, ...))
}
#==============================================================================#
# Add supply ####
#==============================================================================#
setMethod('.add0', signature(obj = 'modInp', app = 'supply',
                     approxim = 'list'), 
  function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    sup <- app
    # sup <- energyRt:::.upper_case(app)
    if (length(sup@commodity) != 1 || is.na(sup@commodity) || all(sup@commodity != approxim$all_comm))
      stop(paste0('Wrong commodity in supply "', sup@name, '"'))
    approxim <- .fix_approximation_list(approxim, comm = sup@commodity, lev = sup@slice)
    sup <- .disaggregateSliceLevel(sup, approxim)
    if (length(sup@region) != 0) {
      approxim$region <- approxim$region[approxim$region %in% sup@region]
      ss <- getSlots('supply')
      ss <- names(ss)[ss == 'data.table']
      ss <- ss[sapply(ss, function(x) (any(colnames(slot(sup, x)) == 'region') 
                                       && any(!is.na(slot(sup, x)$region))))]
      for(sl in ss) if (any(!is.na(slot(sup, sl)$region) & !(slot(sup, sl)$region %in% sup@region))) {
        rr <- !is.na(slot(sup, sl)$region) & !(slot(sup, sl)$region %in% sup@region)
        warning(paste('There are data supply "', sup@name, '" for unused region: "', 
                      paste(unique(slot(sup, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
        slot(sup, sl) <- slot(sup, sl)[!rr,, drop = FALSE]
      }
      mSupSpan <- CJ(sup = sup@name, region = sup@region)
      obj@parameters[['mSupSpan']] <- .add_data(obj@parameters[['mSupSpan']], mSupSpan)
    } else {
      mSupSpan <- CJ(sup = sup@name, region = approxim$region)
      obj@parameters[['mSupSpan']] <- .add_data(obj@parameters[['mSupSpan']], mSupSpan)
    }
    sup <- stayOnlyVariable(sup, approxim$region, 'region')
    mSupSlice <- data.table(sup = rep(sup@name, length(approxim$slice)), slice = approxim$slice)
    obj@parameters[['mSupSlice']] <- .add_data(obj@parameters[['mSupSlice']], mSupSlice)
    mSupComm <- data.table(sup = sup@name, comm = sup@commodity)
    obj@parameters[['mSupComm']] <- .add_data(obj@parameters[['mSupComm']], mSupComm)
    pSupCost <- simpleInterpolation(sup@availability, 'cost', obj@parameters[['pSupCost']],
    																approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupCost']] <- .add_data(obj@parameters[['pSupCost']], pSupCost)
    pSupReserve <- multiInterpolation(sup@reserve, 'res', obj@parameters[['pSupReserve']], 
                                      approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupReserve']] <- .add_data(obj@parameters[['pSupReserve']], pSupReserve)
    pSupAva <- multiInterpolation(sup@availability, 'ava',
                                  obj@parameters[['pSupAva']], approxim, c('sup', 'comm'), c(sup@name, sup@commodity))
    obj@parameters[['pSupAva']] <- .add_data(obj@parameters[['pSupAva']], pSupAva)
    zero_ava_up <- pSupAva[pSupAva$value == 0 & pSupAva$type == 'up', colnames(pSupAva) != 'value', with = FALSE]
    mSupAva <- merge.data.table(merge.data.table(mSupSpan, CJ(sup = sup@name, comm = sup@commodity, 
			year = approxim$mileStoneYears), by = 'sup'), mSupSlice, by = 'sup')

    if (!is.null(zero_ava_up) && nrow(zero_ava_up) != 0) {
      if (all(colnames(mSupAva) %in% colnames(zero_ava_up))) {
        mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, zero_ava_up[, colnames(mSupAva)]), fromLast = TRUE))[1:nrow(mSupAva)], ]
      } else {
        mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, merge(mSupAva, 
        					zero_ava_up[, colnames(zero_ava_up) %in% colnames(mSupAva), with = FALSE])[, colnames(mSupAva), with = FALSE]
        ), fromLast = TRUE))[1:nrow(mSupAva)], ]
      }
    }
    obj@parameters[['mSupAva']] <- .add_data(obj@parameters[['mSupAva']], mSupAva)
    mvSupReserve <- mSupSpan
    mvSupReserve$comm <- mSupComm$comm
    obj@parameters[['mvSupReserve']] <- .add_data(obj@parameters[['mvSupReserve']], mvSupReserve)
    if (all(c('sup', 'comm', 'region') %in% colnames(pSupReserve))) {
      obj@parameters[['mSupReserveUp']] <- .add_data(obj@parameters[['mSupReserveUp']], 
              pSupReserve[pSupReserve$type == 'up' & pSupReserve$value != Inf, c('sup', 'comm', 'region'), with = FALSE])
      obj@parameters[['meqSupReserveLo']] <- .add_data(obj@parameters[['meqSupReserveLo']], 
              pSupReserve[pSupReserve$type == 'lo' & pSupReserve$value != 0, c('sup', 'comm', 'region'), with = FALSE])
    } else {
      obj@parameters[['mSupReserveUp']] <- .add_data(obj@parameters[['mSupReserveUp']], 
               .merge_with_null(mvSupReserve, pSupReserve[pSupReserve$type == 'up' & pSupReserve$value != Inf, 
                    colnames(pSupReserve) %in% c('sup', 'comm', 'region'), with = FALSE]))
      obj@parameters[['meqSupReserveLo']] <- .add_data(obj@parameters[['meqSupReserveLo']], 
         .merge_with_null(mvSupReserve, pSupReserve[pSupReserve$type == 'lo' & pSupReserve$value != 0, 
                     colnames(pSupReserve) %in% c('sup', 'comm', 'region'), with = FALSE]))
    }
    obj@parameters[['meqSupAvaLo']] <- .add_data(obj@parameters[['meqSupAvaLo']], 
            .merge_with_null(mSupAva, pSupAva[pSupAva$type == 'lo' & pSupAva$value != 0, 
            											 colnames(pSupAva) %in% colnames(mSupAva), with = FALSE]))
    obj@parameters[['mSupAvaUp']] <- .add_data(obj@parameters[['mSupAvaUp']], 
            .merge_with_null(mSupAva, pSupAva[pSupAva$type == 'up' & pSupAva$value != Inf, 
            											 colnames(pSupAva) %in% colnames(mSupAva), with = FALSE]))
    
    # For weather
    if (nrow(sup@weather) > 0) {
      tmp <- .toWeatherImply(sup@weather, 'wava', 'sup', sup@name)
      obj@parameters[['pSupWeather']] <- .add_data(obj@parameters[['pSupWeather']], tmp$par)
      obj@parameters[['mSupWeatherUp']] <- .add_data(obj@parameters[['mSupWeatherUp']], tmp$mapup)
      obj@parameters[['mSupWeatherLo']] <- .add_data(obj@parameters[['mSupWeatherLo']], tmp$maplo)
    }
    t1 <- mSupAva[, c('sup', 'region', 'year')]; t1 <- t1[!duplicated(t1), ]
    t2 <- pSupCost[pSupCost$value != 0, colnames(pSupCost)[colnames(pSupCost) %in% c('sup', 'region', 'year')], 
    							 with = FALSE]; t2 <- t2[!duplicated(t2),]
    if (!is.null(t2) && ncol(t2) != 3) {
      t2 <- .merge_with_null(t2, mSupAva[!duplicated(mSupAva[, c('sup', 'region', 'year')]), c('sup', 'region', 'year'), with = FALSE])
    }
    mvSupCost <- .merge_with_null(t1, t2)
    mvSupCost <- mvSupCost[!duplicated(mvSupCost), ]
    obj@parameters[['mvSupCost']] <- .add_data(obj@parameters[['mvSupCost']], mvSupCost)
    obj
  })

.toWeatherImply <- function(frm, val, add_set, add_val, sets = NULL) {
  f1 <- frm[!is.na(frm[[paste0(val, '.up')]]), c(paste0(val, '.up'), 'weather', sets), with = FALSE]; colnames(f1)[1] <- 'value'
  f2 <- frm[!is.na(frm[[paste0(val, '.fx')]]), c(paste0(val, '.fx'), 'weather', sets), with = FALSE]; colnames(f2)[1] <- 'value'
  f3 <- frm[!is.na(frm[[paste0(val, '.lo')]]), c(paste0(val, '.lo'), 'weather', sets), with = FALSE]; colnames(f3)[1] <- 'value'
  rs <- list(par = NULL)
  if (nrow(f1) + nrow(f2) != 0) {
    tmp <- rbind(f1, f2)
    tmp[, add_set] <- add_val
    rs$mapup <- tmp[, -1, with = FALSE]
    tmp$type <- 'up'
    rs$par <- tmp
  }
  if (nrow(f3) + nrow(f2) != 0) {
    tmp <- rbind(f3, f2)
    tmp[, add_set] <- add_val
    rs$maplo <- tmp[, -1, with = FALSE]
    tmp$type <- 'lo'
    rs$par <- rbind(rs$par, tmp)
  }
  rs
}


.add_ramp0 <- function(obj, name, tech, mact, approxim) {
  if (any(!is.na(tech@af[[name]]))) {
  	pname <- paste0('p', c('technology' = 'Tech', 'storage' = 'Storage')[class(tech)], 
  									c('rampup' = 'RampUp', 'rampdown' = 'RampDown', name)[name])
  	set_name <- c('technology' = 'tech', 'storage' = 'stg')[class(tech)]
  	mname <- sub('^p', 'm', pname)
  	rampup <- tech@af[!is.na(tech@af[[name]]), ]
  	approxim2 <- approxim
  	if (all(!is.na(rampup$slice)))
  		approxim2$slice <- approxim2$slice[approxim2$slice %in% unique(rampup$slice)]
    pTechRampUp <- simpleInterpolation(rampup, name,
              obj@parameters[[pname]], approxim2, set_name, tech@name)
		mTechRampUp <- pTechRampUp[, colnames(pTechRampUp) != 'value', drop = FALSE]
    if (ncol(mTechRampUp) != ncol(obj@parameters[[mname]]@data)) {
    	mTechRampUp <- merge(mTechRampUp, mact)
    }
		obj@parameters[[pname]] <- .add_data(obj@parameters[[pname]], pTechRampUp)
		obj@parameters[[mname]] <- .add_data(obj@parameters[[mname]], mTechRampUp)
  }
	obj
}

#==============================================================================#
# Add technology ####
#==============================================================================#
setMethod(
  '.add0', signature(obj = 'modInp', app = 'technology', approxim = 'list'), 
  function(obj, app, approxim) {
    energyRt:::.checkSliceLevel(app, approxim)
    # tech <- energyRt:::.upper_case(app)
    tech <- app
    if (length(tech@slice) == 0) {
      use_cmd <- unique(sapply(c(tech@output$comm, tech@output$comm, tech@aux$acomm), function(x) approxim$commodity_slice_map[x]))
      tech@slice <- colnames(approxim$slice@levels)[max(c(approxim$slice@misc$deep[c(use_cmd, recursive = TRUE)], recursive = TRUE))]
    }
    # Disaggregated AFS, if there is a slice level
    if (nrow(tech@afs) != 0 && any(tech@afs$slice %in% names(approxim$slice@slice_map))) {
      chk <- seq_len(nrow(tech@afs))[tech@afs$slice %in% names(approxim$slice@slice_map)]
      for (cc in chk) {
        slc <- approxim$slice@slice_map[[tech@afs[cc, 'slice']]]
        tmp <- tech@afs[rep(cc, length(slc)), ]
        tmp$slice <- slc
        tech@afs <- rbind(tech@afs, tmp)
      }
      tech@afs <- tech@afs[-chk, ]
    }
    approxim <- energyRt:::.fix_approximation_list(approxim, lev = tech@slice)
    tech <- .disaggregateSliceLevel(tech, approxim)
    mTechSlice <- data.table(tech = rep(tech@name, length(approxim$slice)), slice = approxim$slice)
    obj@parameters[['mTechSlice']] <- .add_data(obj@parameters[['mTechSlice']], mTechSlice)
    if (length(tech@region) != 0) {
      approxim$region <- approxim$region[approxim$region %in% tech@region]
      ss <- getSlots('technology')
      ss <- names(ss)[ss == 'data.table']
      ss <- ss[sapply(ss, function(x) (any(colnames(slot(tech, x)) == 'region') 
                                       && any(!is.na(slot(tech, x)$region))))]
      for(sl in ss) if (any(!is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region))) {
        rr <- !is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region)
        warning(paste('There are data technology "', tech@name, '"for unused region: "', 
                      paste(unique(slot(tech, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
        slot(tech, sl) <- slot(tech, sl)[!rr,]
      }
    }
    tech <- stayOnlyVariable(tech, approxim$region, 'region')
    # Map
    ctype <- checkInpOut(tech)
    # Need choose comm more accuracy
    approxim_comm <- approxim
    approxim_comm[['comm']] <- ctype$comm$comm
    if (length(approxim_comm[['comm']]) != 0) {
      pTechCvarom <- simpleInterpolation(tech@varom, 'cvarom',
                                         obj@parameters[['pTechCvarom']], approxim_comm, 'tech', tech@name, remValue = 0)
      obj@parameters[['pTechCvarom']] <- .add_data(obj@parameters[['pTechCvarom']], pTechCvarom)
      
    } else pTechCvarom <- NULL
    approxim_acomm <- approxim
    approxim_acomm[['acomm']] <- rownames(ctype$aux)
    if (length(approxim_acomm[['acomm']]) != 0) {
      pTechAvarom <- simpleInterpolation(tech@varom, 'avarom',
                                         obj@parameters[['pTechAvarom']], approxim_acomm, 'tech', tech@name, remValue = 0)
      obj@parameters[['pTechAvarom']] <- .add_data(obj@parameters[['pTechAvarom']], pTechAvarom)
    } else pTechAvarom <- NULL
    approxim_comm[['comm']] <- ctype$comm$comm
    if (length(approxim_comm[['comm']]) != 0) {
      pTechAfc <- multiInterpolation(tech@ceff, 'afc',
            obj@parameters[['pTechAfc']], approxim_comm, 'tech', tech@name, remValueUp = Inf, remValueLo = 0)
      obj@parameters[['pTechAfc']] <- .add_data(obj@parameters[['pTechAfc']], pTechAfc)
    } else pTechAfc <- NULL
    # Stock & Capacity
    stock_exist <- simpleInterpolation(tech@stock, 'stock', obj@parameters[['pTechStock']], approxim, 'tech', tech@name)
    obj@parameters[['pTechStock']] <- .add_data(obj@parameters[['pTechStock']], stock_exist)
    olife <- simpleInterpolation(tech@olife, 'olife', obj@parameters[['pTechOlife']], approxim, 'tech', tech@name, removeDefault = FALSE)
    obj@parameters[['pTechOlife']] <- .add_data(obj@parameters[['pTechOlife']], olife)		
    dd0 <- energyRt:::.start_end_fix(approxim, tech, 'tech', stock_exist)
    dd0$new <-  dd0$new[dd0$new$year   %in% approxim$mileStoneYears & dd0$new$region  %in% approxim$region,]
    dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears & dd0$span$region %in% approxim$region,]
    obj@parameters[['mTechNew']] <- .add_data(obj@parameters[['mTechNew']], dd0$new)
    
    invcost <- simpleInterpolation(tech@invcost, 'invcost', obj@parameters[['pTechInvcost']], approxim, 'tech', tech@name)
    if (!is.null(invcost)) {
      minvcost <- merge(dd0$new, invcost) 
      obj@parameters[['mTechInv']] <- .add_data(obj@parameters[['mTechInv']], minvcost[, colnames(minvcost) != 'value'])
      obj@parameters[['pTechInvcost']] <- .add_data(obj@parameters[['pTechInvcost']], invcost)
      obj@parameters[['mTechEac']] <- .add_data(obj@parameters[['mTechEac']], dd0$eac)
    }
    obj@parameters[['mTechSpan']] <- .add_data(obj@parameters[['mTechSpan']], dd0$span)
    
    if (nrow(dd0$new) > 0 && !is.null(invcost)) {
      salv_data <- merge(dd0$new, approxim$discount, all.x = TRUE)
      salv_data$value[is.na(salv_data$value)] <- 0
      salv_data$discount <- salv_data$value; salv_data$value <- NULL
      olife$olife <- olife$value; olife$value <- NULL
      salv_data <- merge(salv_data, olife)
      invcost$invcost <- invcost$value; invcost$value <- NULL
      salv_data <- merge(salv_data, invcost)
      # EAC
      salv_data$eac <- salv_data$invcost / salv_data$olife
      fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
      salv_data$eac[fl] <- salv_data$invcost[fl] * (salv_data$discount[fl] * (1 + salv_data$discount[fl]) ^ salv_data$olife[fl] / 
                                                      ((1 + salv_data$discount[fl]) ^ salv_data$olife[fl] - 1))
      fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
      salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
      
      salv_data$tech <- tech@name
      salv_data$value <- salv_data$eac
      pTechEac <- salv_data[, c('tech', 'region', 'year', 'value'), with = FALSE]
      obj@parameters[['pTechEac']] <- .add_data(obj@parameters[['pTechEac']], 
					unique(pTechEac[, c(obj@parameters[['pTechEac']]@dimSetNames, 'value'), with = FALSE]))
    }
    pTechAf <- multiInterpolation(tech@af, 'af',
                                  obj@parameters[['pTechAf']], approxim, 'tech', tech@name, remValueUp = Inf, remValueLo = 0)
    obj@parameters[['pTechAf']] <- .add_data(obj@parameters[['pTechAf']], pTechAf)
    if (nrow(tech@afs) > 0) {
      afs_slice <- unique(tech@afs$slice)
      afs_slice <- afs_slice[!is.na(afs_slice)]
      approxim.afs <- approxim
      approxim.afs$slice <- afs_slice
      pTechAfs <- multiInterpolation(tech@afs, 'afs', obj@parameters[['pTechAfs']], approxim.afs, 'tech', 
                                     tech@name, remValueUp = Inf, remValueLo = 0)
      obj@parameters[['pTechAfs']] <- .add_data(obj@parameters[['pTechAfs']], pTechAfs)
    } else pTechAfs <- NULL

    
    approxim_comm[['comm']] <- ctype$comm$comm[ctype$comm$type == 'input' & is.na(ctype$comm[, 'group'])]
    if (length(approxim_comm[['comm']]) != 0) {
      pTechCinp2use <- simpleInterpolation(tech@ceff, 'cinp2use',
                                           obj@parameters[['pTechCinp2use']], approxim_comm, 'tech', tech@name)
      
      obj@parameters[['pTechCinp2use']] <- .add_data(obj@parameters[['pTechCinp2use']], pTechCinp2use)
    } else pTechCinp2use <- NULL
    approxim_comm[['comm']] <- ctype$comm$comm[ctype$comm$type == 'output']
    if (length(approxim_comm[['comm']]) != 0) {
      pTechUse2cact <- simpleInterpolation(tech@ceff, 'use2cact',
                                           obj@parameters[['pTechUse2cact']], approxim_comm, 'tech', tech@name)
      obj@parameters[['pTechUse2cact']] <- .add_data(obj@parameters[['pTechUse2cact']],  pTechUse2cact)
      pTechCact2cout <- 	simpleInterpolation(tech@ceff, 'cact2cout',
                                             obj@parameters[['pTechCact2cout']], approxim_comm, 'tech', tech@name)
      obj@parameters[['pTechCact2cout']] <- .add_data(obj@parameters[['pTechCact2cout']], pTechCact2cout)
      if (any(!is.na(tech@ceff$cact2cout) & (tech@ceff$cact2cout == 0 | tech@ceff$cact2cout == Inf)))
        stop('cact2cout is not correct ', tech@name)
      if (any(!is.na(tech@ceff$use2cact) & (tech@ceff$use2cact == 0 | tech@ceff$use2cact == Inf)))
        stop('use2cact is not correct ', tech@name)
    } else {pTechUse2cact <- NULL; pTechCact2cout <- NULL;}
    approxim_comm[['comm']] <- ctype$comm$comm[ctype$comm$type == 'input' & !is.na(ctype$comm[['group']])]
    if (length(approxim_comm[['comm']]) != 0) {
      pTechCinp2ginp <- simpleInterpolation(tech@ceff, 'cinp2ginp',
                                            obj@parameters[['pTechCinp2ginp']], approxim_comm, 'tech', tech@name)
      obj@parameters[['pTechCinp2ginp']] <- .add_data(obj@parameters[['pTechCinp2ginp']], pTechCinp2ginp)
    } else pTechCinp2ginp <- NULL
    if (tech@early.retirement) 
      obj@parameters[['mTechRetirement']] <- .add_data(obj@parameters[['mTechRetirement']], data.table(tech = tech@name))
    if (length(tech@upgrade.technology) != 0)
      obj@parameters[['mTechUpgrade']] <- .add_data(obj@parameters[['mTechUpgrade']], 
                                                    data.table(tech = rep(tech@name, length(tech@upgrade.technology)), techp = tech@upgrade.technology))
    cmm <- ctype$comm$comm[ctype$comm$type == 'input'] 
    if (length(cmm) != 0) {
      mTechInpComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[['mTechInpComm']] <- .add_data(obj@parameters[['mTechInpComm']], mTechInpComm)
    } else mTechInpComm <- NULL
    cmm <- ctype$comm$comm[ctype$comm$type == 'output']
    if (length(cmm) != 0) {
      mTechOutComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[['mTechOutComm']] <- .add_data(obj@parameters[['mTechOutComm']], mTechOutComm)
    } else mTechOutComm <- NULL
    cmm <- ctype$comm$comm[is.na(ctype$comm$group)] 
    if (length(cmm) != 0) {
      mTechOneComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[['mTechOneComm']] <- .add_data(obj@parameters[['mTechOneComm']], mTechOneComm)
    } else mTechOneComm <- NULL
    approxim_comm[['comm']] <- ctype$comm$comm[!is.na(ctype$comm$group)]
    if (length(approxim_comm[['comm']]) != 0) {
      pTechShare <- multiInterpolation(tech@ceff, 'share',
                 obj@parameters[['pTechShare']], approxim_comm, 'tech', tech@name, remValueUp = 1, remValueLo = 0)
      obj@parameters[['pTechShare']] <- .add_data(obj@parameters[['pTechShare']], pTechShare)
    } else pTechShare <- NULL
    cmm <- ctype$comm$comm[ctype$comm$comb != 0]
    if (length(cmm) != 0) {
      obj@parameters[['pTechEmisComm']] <- .add_data(obj@parameters[['pTechEmisComm']],
                     data.table(tech = rep(tech@name, nrow(ctype$comm)), comm = ctype$comm$comm,
                                value = ctype$comm$comb))
    } 
    gpp <- rownames(ctype$group)[ctype$group$type == 'input']
    if (length(gpp) != 0) {
      mTechInpGroup <- data.table(tech = rep(tech@name, length(gpp)), group = gpp)
      obj@parameters[['mTechInpGroup']] <- .add_data(obj@parameters[['mTechInpGroup']], mTechInpGroup)
    } else mTechInpGroup <- NULL
    gpp <- rownames(ctype$group)[ctype$group$type == 'output']
    if (length(gpp) != 0) {
      mTechOutGroup <- data.table(tech = rep(tech@name, length(gpp)), group = gpp)
      obj@parameters[['mTechOutGroup']] <- .add_data(obj@parameters[['mTechOutGroup']], mTechOutGroup)
    } else mTechOutGroup <- NULL
    approxim_group <- approxim
    approxim_group[['group']] <- rownames(ctype$group)[ctype$group$type == 'input']
    if (length(approxim_group[['group']]) != 0) {
      pTechGinp2use <- simpleInterpolation(tech@geff, 'ginp2use',
                                           obj@parameters[['pTechGinp2use']], approxim_group, 'tech', tech@name)
      obj@parameters[['pTechGinp2use']] <- .add_data(obj@parameters[['pTechGinp2use']], pTechGinp2use)
    } else pTechGinp2use <- NULL
    if (nrow(ctype$group) > 0)
      obj@parameters[['group']] <- addMultipleSet(obj@parameters[['group']], rownames(ctype$group))
    fl <- !is.na(ctype$comm$group)
    if (any(fl)) {
      mTechGroupComm <- data.table(tech = rep(tech@name, sum(fl)), group = ctype$comm$group[fl], 
                                   comm = ctype$comm$comm[fl], stringsAsFactors = FALSE)
      obj@parameters[['mTechGroupComm']] <- .add_data(obj@parameters[['mTechGroupComm']], mTechGroupComm)
    } else mTechGroupComm <- NULL
    if (any(ctype$aux$output)) {    
      cmm <- rownames(ctype$aux)[ctype$aux$output]
      mTechAOut <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[['mTechAOut']] <- .add_data(obj@parameters[['mTechAOut']], mTechAOut)
    } else mTechAOut <- NULL
    if (any(ctype$aux$input)) {    
      cmm <- rownames(ctype$aux)[ctype$aux$input]
      mTechAInp <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[['mTechAInp']] <- .add_data(obj@parameters[['mTechAInp']], mTechAInp)
    } else mTechAInp <- NULL
    # simple & multi
    obj@parameters[['pTechCap2act']] <- .add_data(obj@parameters[['pTechCap2act']],
                       data.table(tech = tech@name, value = tech@cap2act))
    pTechFixom <- simpleInterpolation(tech@fixom, 'fixom', obj@parameters[['pTechFixom']], approxim, 'tech', tech@name)
    obj@parameters[['pTechFixom']] <- .add_data(obj@parameters[['pTechFixom']], pTechFixom)
    pTechVarom <- simpleInterpolation(tech@varom, 'varom', obj@parameters[['pTechVarom']], approxim, 'tech', tech@name)
    obj@parameters[['pTechVarom']] <- .add_data(obj@parameters[['pTechVarom']], pTechVarom)
    
    ## Move from reduce 
    mTechNew = dd0$new
    mTechSpan = dd0$span
    pTechOlife = olife
    if (tech@early.retirement) {
      obj@parameters[['mvTechRetiredStock']] <- .add_data(obj@parameters[['mvTechRetiredStock']], 
                              stock_exist[stock_exist$value != 0, colnames(stock_exist) != 'value', with = FALSE])
    }
    if (nrow(dd0$new) > 0 && tech@early.retirement) {
      obj@parameters[['meqTechRetiredNewCap']] <- .add_data(obj@parameters[['meqTechRetiredNewCap']], mTechNew)
      
      
      mvTechRetiredCap0 <- merge(merge(mTechNew, mTechSpan, by = c('tech', 'region')), 
                                 pTechOlife, by = c('tech', 'region'))
      mvTechRetiredCap0 <- mvTechRetiredCap0[(
        mvTechRetiredCap0$year.x + mvTechRetiredCap0$olife > mvTechRetiredCap0$year.y &
          mvTechRetiredCap0$year.x <= mvTechRetiredCap0$year.y), -5, with = FALSE] 
      colnames(mvTechRetiredCap0)[3:4] <- c('year', 'yearp')
      obj@parameters[['mvTechRetiredNewCap']] <- .add_data(obj@parameters[['mvTechRetiredNewCap']], 
                                                           mvTechRetiredCap0)
    }
    mvTechAct <- mTechSpan[,list(slice = mTechSlice$slice), by = mTechSpan]
    obj@parameters[['mvTechAct']] <- .add_data(obj@parameters[['mvTechAct']], mvTechAct)
    # Stay only variable with non zero output
    merge_table <- function(mvTechInp, pTechCinp2use) {
      if (is.null(pTechCinp2use) || nrow(pTechCinp2use) == 0) return(NULL)
      return(merge(mvTechInp, pTechCinp2use[pTechCinp2use$value != 0 & pTechCinp2use$value != Inf, colnames(pTechCinp2use) != 'value', with = FALSE]))
    }
    merge_table2 <- function(mvTechInp, pTechCinp2use, pTechCinp2ginp) {
      tmp <- rbind(merge_table(mvTechInp, pTechCinp2use), merge_table(mvTechInp, pTechCinp2ginp))
      tmp[!duplicated(tmp),]
    }	 
    expand_comm <- function(x, y) x[,list(comm = y$comm), by = x]
    if (!is.null(mTechInpComm)) {
      mvTechInp <- expand_comm(mvTechAct, mTechInpComm)
      mvTechInp <- merge_table2(mvTechInp, pTechCinp2use, pTechCinp2ginp)
      obj@parameters[['mvTechInp']]  <- .add_data(obj@parameters[['mvTechInp']], mvTechInp)
    } else mvTechInp <- NULL
    if (!is.null(mTechOutComm)) {
      mvTechOut <-  expand_comm(mvTechAct, mTechOutComm)
      obj@parameters[['mvTechOut']]  <- .add_data(obj@parameters[['mvTechOut']], mvTechOut)
    } else mvTechOut <- NULL
    if (!is.null(mTechAInp)) {
      mvTechAInp <- expand_comm(mvTechAct, mTechAInp)
      obj@parameters[['mvTechAInp']] <- .add_data(obj@parameters[['mvTechAInp']], mvTechAInp)
    } else mvTechAInp <- NULL
    if (!is.null(mTechAOut)) {
      mvTechAOut <- expand_comm(mvTechAct, mTechAOut)
      obj@parameters[['mvTechAOut']] <- .add_data(obj@parameters[['mvTechAOut']], mvTechAOut)
    } else mvTechAOut <- NULL
    #### aeff begin
    if (nrow(tech@aeff) != 0) {
      if (any(is.na(tech@aeff$acomm)))
        stop(paste0('NA value in column acomm is forbidden in the slot aeff ', tech@name))
      if (any(is.na(tech@aeff[apply(!is.na(tech@aeff[, c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout'), with = FALSE]), 1, any), 'comm'])))
        stop(paste0('NA value in column  comm is forbidden in the slot aeff ', tech@name))
      for(i in 1:4) {
        tech@aeff <- tech@aeff[!is.na(tech@aeff$acomm),]
        ll <- c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout')[i]
        tbl <- c('pTechCinp2AInp', 'pTechCinp2AOut', 'pTechCout2AInp', 'pTechCout2AOut')[i]
        tbl2 <- c('mTechCinp2AInp', 'mTechCinp2AOut', 'mTechCout2AInp', 'mTechCout2AOut')[i]
        yy <- tech@aeff[!is.na(tech@aeff[[ll]]), ]
        if (nrow(yy) != 0) {
          approxim_commp <- approxim
          approxim_commp$acomm <- unique(yy$acomm);
          approxim_commp$comm <- unique(yy$comm)
          tmp <- simpleInterpolation(yy, ll, obj@parameters[[tbl]], approxim_commp, 'tech', tech@name);
          tmp <- tmp[tmp$value != 0, ]
          if (nrow(tmp) > 0) {
            obj@parameters[[tbl]] <- .add_data(obj@parameters[[tbl]], tmp)
            tmp$value <- NULL
            if (!all(c("tech", "acomm", "comm", "region", "year", "slice") %in% colnames(tmp))) {
              if (i %in% c(1, 3)) tmp <- merge(tmp, mvTechInp) else tmp <- merge(tmp, mvTechOut)
            }
            tmp$commp <- tmp$comm; tmp$comm <- tmp$acomm; tmp$acomm <- NULL;
            obj@parameters[[tbl2]] <- .add_data(obj@parameters[[tbl2]], tmp[!duplicated(tmp), ])
          }
        }
      }
	    dd <- data.table(list = c('pTechAct2AOut', 'pTechCap2AOut', 'pTechNCap2AOut', 
	                              'pTechAct2AInp', 'pTechCap2AInp', 'pTechNCap2AInp'),
	                     table = c('act2aout', 'cap2aout', 'ncap2aout', 'act2ainp', 'cap2ainp', 'ncap2ainp'),
	                     tab2 = c('mTechAct2AOut', 'mTechCap2AOut', 'mTechNCap2AOut', 'mTechAct2AInp', 'mTechCap2AInp', 'mTechNCap2AInp'),
	                     stringsAsFactors = FALSE)
	    
	    for(i in 1:nrow(dd)) {
	      approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
	      approxim_comm[['acomm']] <- unique(tech@aeff[!is.na(tech@aeff[, dd$table[i]]), 'acomm'])
	      if (length(approxim_comm[['acomm']]) != 0) {
	        tmp <- simpleInterpolation(tech@aeff, dd$table[i], obj@parameters[[dd$list[i]]], approxim_comm, 'tech', tech@name)		
	        obj@parameters[[dd$list[i]]] <- .add_data(obj@parameters[[dd$list[i]]], tmp)
	        if (!all(c("tech", "acomm", "region", "year", "slice") %in% colnames(tmp))) {
	          if (i <= 3) ll <- mvTechOut else ll <- mvTechInp;
	          ll$comm <- NULL
	          tmp <- merge(tmp, unique(ll))
	        }
	        tmp$comm <- tmp$acomm; tmp$acomm <- NULL; tmp$value <- NULL
	        if (ncol(tmp) != ncol(mvTechAct) + 1) {
	          tmp <- merge(tmp, mvTechAct)
	        }
	        obj@parameters[[dd$tab2[i]]] <- .add_data(obj@parameters[[dd$tab2[i]]], tmp)
	      }
	    }  
    }
    #### aeff end
    if (!is.null(mTechInpGroup) && !is.null(mTechOutGroup)) {
      meqTechGrp2Grp <- merge(merge(mTechInpGroup, mTechOutGroup, by =  'tech', suffix = c('', 'p')), 
                              mvTechAct)[, c('tech', 'region', 'group', 'groupp', 'year', 'slice')]
      obj@parameters[['meqTechGrp2Grp']] <- .add_data(obj@parameters[['meqTechGrp2Grp']], meqTechGrp2Grp)
    } else meqTechGrp2Grp <- NULL
    if (!is.null(mTechInpGroup) || !is.null(mTechOutGroup)) {
      mpTechShareLo <- pTechShare[pTechShare$type == 'lo' & pTechShare$value > 0, colnames(pTechShare) != 'value', with = FALSE]
      mpTechShareUp <- pTechShare[pTechShare$type == 'up' & pTechShare$value < 1, colnames(pTechShare) != 'value', with = FALSE]
    } else {mpTechShareUp <- NULL; mpTechShareLo <- NULL;}
    if (!is.null(mvTechOut) && !is.null(mTechOutGroup) && !is.null(mTechGroupComm)) {
      techGroupOut <- merge(merge(mvTechOut, mTechOutGroup), mTechGroupComm)
    } else techGroupOut <- NULL
    if (!is.null(mvTechInp) && !is.null(mTechInpGroup) && !is.null(mTechGroupComm)) {
      techGroupInp <- merge(merge(mvTechInp, mTechInpGroup), mTechGroupComm)
    } else techGroupInp <- NULL
    if (!is.null(mvTechInp) && !is.null(mTechOneComm)) {
      techSingInp <- merge(mvTechInp, mTechOneComm);
      if (!is.null(pTechCinp2use)) 
      	techSingInp <- merge(techSingInp, pTechCinp2use[pTechCinp2use$value != 0,
      													colnames(pTechCinp2use) %in% colnames(techSingInp), with = FALSE], by = colnames(techSingInp))
      if (nrow(techSingInp) == 0) techSingInp <- NULL
    } else techSingInp <- NULL
    if (!is.null(mvTechOut) && !is.null(mTechOneComm)) {
      techSingOut <- merge(mvTechOut, mTechOneComm);
      if (!is.null(pTechCact2cout)) techSingOut <- merge(techSingOut, pTechCact2cout[pTechCact2cout$value != 0, 
      													colnames(pTechCact2cout) %in% colnames(techSingOut), with = FALSE], by = colnames(techSingOut))
      if (nrow(techSingOut) == 0) techSingOut <- NULL
    } else techSingOut <- NULL
    if (!is.null(mTechInpGroup) && !is.null(techSingOut)) {
      meqTechGrp2Sng <- merge(mTechInpGroup, techSingOut)
      obj@parameters[['meqTechGrp2Sng']] <- .add_data(obj@parameters[['meqTechGrp2Sng']], meqTechGrp2Sng)
    } else meqTechGrp2Sng <- NULL
    if (!is.null(mTechOutGroup) && !is.null(techSingInp)) {
      meqTechSng2Grp <- merge(mTechOutGroup, techSingInp)
      obj@parameters[['meqTechSng2Grp']] <- .add_data(obj@parameters[['meqTechSng2Grp']], meqTechSng2Grp)
    } else meqTechSng2Grp <- NULL
    
    if (!is.null(techSingInp) && !is.null(techSingOut)) {
      meqTechSng2Sng <- merge(techSingInp, techSingOut, by = c('tech', 'region', 'year', 'slice'), suffixes = c("","p"))
      obj@parameters[['meqTechSng2Sng']] <- .add_data(obj@parameters[['meqTechSng2Sng']], meqTechSng2Sng)
    } else meqTechSng2Sng <- NULL
    if (!is.null(mpTechShareLo) && !is.null(techGroupOut)) {
      meqTechShareOutLo <- merge(mpTechShareLo, techGroupOut)
      obj@parameters[['meqTechShareOutLo']] <- .add_data(obj@parameters[['meqTechShareOutLo']], 
                  meqTechShareOutLo[, obj@parameters[['meqTechShareOutLo']]@dimSetNames, with = FALSE])
    } else meqTechShareOutLo <- NULL
    if (!is.null(mpTechShareUp) && !is.null(techGroupOut)) {
      meqTechShareOutUp <- merge(mpTechShareUp, techGroupOut)
      obj@parameters[['meqTechShareOutUp']] <- .add_data(obj@parameters[['meqTechShareOutUp']], 
                             meqTechShareOutUp[, obj@parameters[['meqTechShareOutUp']]@dimSetNames, with = FALSE])
    } else meqTechShareOutUp <- NULL
    if (!is.null(mpTechShareLo) && !is.null(techGroupInp)) {
      meqTechShareInpLo <- merge(mpTechShareLo, techGroupInp)
      obj@parameters[['meqTechShareInpLo']] <- .add_data(obj@parameters[['meqTechShareInpLo']], 
                    meqTechShareInpLo[, obj@parameters[['meqTechShareInpLo']]@dimSetNames, with = FALSE])
    } else meqTechShareInpLo <- NULL
    if (!is.null(mpTechShareUp) && !is.null(techGroupInp)) {
      meqTechShareInpUp <- merge(mpTechShareUp, techGroupInp)
      obj@parameters[['meqTechShareInpUp']] <- .add_data(obj@parameters[['meqTechShareInpUp']], 
                        meqTechShareInpUp[, obj@parameters[['meqTechShareInpUp']]@dimSetNames, with = FALSE])
    } else meqTechShareInpUp <- NULL
    
    ####
    outer_inf <- function(mvTechAct, pTechAf) {
    	if (is.null(mvTechAct)) retunrn(NULL)
    	fl <- pTechAf$value != Inf & pTechAf$type == 'up'
    	if (!any(fl)) retunrn(NULL)
      merge(mvTechAct, pTechAf[fl, colnames(mvTechAct), with = FALSE], by = colnames(mvTechAct))
    }
    if (!is.null(pTechAf) && any(pTechAf$value != 0 & pTechAf$type == 'lo')) {
      obj@parameters[['meqTechAfLo']] <- .add_data(obj@parameters[['meqTechAfLo']],
             merge(mvTechAct, pTechAf[pTechAf$value != 0 & pTechAf$type == 'lo', colnames(pTechAf)[colnames(pTechAf) %in% colnames(mvTechAct)], with = FALSE]))
    }
    obj@parameters[['meqTechAfUp']] <- .add_data(obj@parameters[['meqTechAfUp']], outer_inf(mvTechAct, pTechAf))
    if (!is.null(pTechAfs)) {
      obj@parameters[['meqTechAfsLo']] <- .add_data(obj@parameters[['meqTechAfsLo']],
              merge(mTechSpan, pTechAfs[pTechAfs$value != 0 & pTechAfs$type == 'lo', 
                      colnames(pTechAfs)[colnames(pTechAfs) %in% obj@parameters[['meqTechAfsLo']]@dimSetNames, with = FALSE]]))
      meqTechAfsUp <- merge(mTechSpan, 
                pTechAfs[pTechAfs$value != Inf & pTechAfs$type == 'up', colnames(pTechAfs) %in% obj@parameters[['meqTechAfsUp']]@dimSetNames, with = FALSE])
      obj@parameters[['meqTechAfsUp']] <- .add_data(obj@parameters[['meqTechAfsUp']], meqTechAfsUp)
    }
    if (!is.null(techSingOut)) {
      obj@parameters[['meqTechActSng']] <- .add_data(obj@parameters[['meqTechActSng']], techSingOut)
    } else meqTechActSng <- NULL
    if (!is.null(mTechOutGroup)) {
      obj@parameters[['meqTechActGrp']] <- .add_data(obj@parameters[['meqTechActGrp']], merge(mvTechAct, mTechOutGroup))
    } else meqTechActGrp <- NULL
    if (!is.null(pTechAfc)) {
      merge_afc <- function(prm, mvTechOut, pTechAfc,  type) {
        if (is.null(pTechAfc) || nrow(pTechAfc) == 0) return(prm)
        if (type == 'up') {
          pTechAfc <- pTechAfc[pTechAfc$value != Inf & pTechAfc$type == 'up', 
          										 colnames(pTechAfc) %in% obj@parameters[['meqTechAfcOutLo']]@dimSetNames, with = FALSE]
        } else pTechAfc <- pTechAfc[pTechAfc$value != 0 & pTechAfc$type == 'lo', 
        														colnames(pTechAfc) %in% obj@parameters[['meqTechAfcOutLo']]@dimSetNames, with = FALSE]
        if (nrow(pTechAfc) == 0) return(prm)
        return(.add_data(prm, merge(mvTechOut, pTechAfc)))
      }
      obj@parameters[['meqTechAfcOutLo']] <- merge_afc(obj@parameters[['meqTechAfcOutLo']], mvTechOut, pTechAfc, 'lo')
      obj@parameters[['meqTechAfcOutUp']] <- merge_afc(obj@parameters[['meqTechAfcOutUp']], mvTechOut, pTechAfc, 'up')
      obj@parameters[['meqTechAfcInpLo']] <- merge_afc(obj@parameters[['meqTechAfcInpLo']], mvTechInp, pTechAfc, 'lo')
      obj@parameters[['meqTechAfcInpUp']] <- merge_afc(obj@parameters[['meqTechAfcInpUp']], mvTechInp, pTechAfc, 'up')
    }
    
    if (nrow(tech@weather) > 0) {
      tmp <- .toWeatherImply(tech@weather, 'waf', 'tech', tech@name)
      obj@parameters[['pTechWeatherAf']] <- .add_data(obj@parameters[['pTechWeatherAf']], tmp$par)
      obj@parameters[['mTechWeatherAfUp']] <- .add_data(obj@parameters[['mTechWeatherAfUp']], tmp$mapup)
      obj@parameters[['mTechWeatherAfLo']] <- .add_data(obj@parameters[['mTechWeatherAfLo']], tmp$maplo)
      
      tmp <- .toWeatherImply(tech@weather, 'wafs', 'tech', tech@name)
      obj@parameters[['pTechWeatherAfs']] <- .add_data(obj@parameters[['pTechWeatherAfs']], tmp$par)
      obj@parameters[['mTechWeatherAfsUp']] <- .add_data(obj@parameters[['mTechWeatherAfsUp']], tmp$mapup)
      obj@parameters[['mTechWeatherAfsLo']] <- .add_data(obj@parameters[['mTechWeatherAfsLo']], tmp$maplo)
      
      if (any(is.na(tech@weather$comm)[apply(!is.na(tech@weather[, c('wafc.lo', 'wafc.up', 'wafc.fx'), drop = FALSE]), 1, any)]))
        stop('For wafc.* have to define comm')
      tmp <- .toWeatherImply(tech@weather, 'wafc', 'tech', tech@name, 'comm')
      obj@parameters[['pTechWeatherAfc']] <- .add_data(obj@parameters[['pTechWeatherAfc']], tmp$par)
      obj@parameters[['mTechWeatherAfcUp']] <- .add_data(obj@parameters[['mTechWeatherAfcUp']], tmp$mapup)
      obj@parameters[['mTechWeatherAfcLo']] <- .add_data(obj@parameters[['mTechWeatherAfcLo']], tmp$maplo)
    }
    
    
    if (all(ctype$comm$type != 'output')) 
      stop('Techology "', tech@name, '", there is not activity commodity')  
    # mTechOMCost(tech, region, year) 
    mTechOMCost <- NULL
    add_omcost <- function(mTechOMCost, pTechFixom) {
      if (is.null(pTechFixom) || all(pTechFixom$value == 0)) return(mTechOMCost) 
      return(rbind(mTechOMCost, merge(mTechSpan, pTechFixom[pTechFixom$value != 0, colnames(pTechFixom) %in% colnames(mTechSpan), with = FALSE])))
    }
    mTechOMCost <- add_omcost(mTechOMCost, pTechFixom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechVarom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechCvarom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechAvarom)
    
    if (!is.null(mTechOMCost)) {
      mTechOMCost <- merge(mTechOMCost[!duplicated(mTechOMCost), ], mTechSpan)
      obj@parameters[['mTechOMCost']] <- .add_data(obj@parameters[['mTechOMCost']], mTechOMCost)
    }
    
    ### Ramp
    if (tech@fullYear)
    	obj@parameters[['mTechFullYear']] <- .add_data(obj@parameters[['mTechFullYear']],
                                                                data.table(tech = tech@name))

    obj <- .add_ramp0(obj, 'rampup', tech, mvTechAct, approxim)
    obj <- .add_ramp0(obj, 'rampdown', tech, mvTechAct, approxim)
    obj
  })


#==============================================================================#
# Add trade ####
#==============================================================================#
setMethod(
  '.add0', signature(obj = 'modInp', app = 'trade',
                     approxim = 'list'), 
  function(obj, app, approxim) {
    # trd <- energyRt:::.upper_case(app)
    trd <- app
    if (length(trd@commodity) != 1 || is.na(trd@commodity) || all(trd@commodity != approxim$all_comm))
      stop(paste0('Wrong commodity in trade "', trd@name, '"'))
    trd <- stayOnlyVariable(trd, approxim$region, 'region') ## ??
    remove_duplicate <- list(c('src', 'dst'))
    approxim <- .fix_approximation_list(approxim, comm = trd@commodity)
    trd <- .disaggregateSliceLevel(trd, approxim)
    # other flag
    mTradeSlice <- data.table(trade = rep(trd@name, length(approxim$slice)), slice = approxim$slice)
    obj@parameters[['mTradeSlice']] <- .add_data(obj@parameters[['mTradeSlice']], mTradeSlice)
    if (length(trd@commodity) == 0) stop('There is not commodity for trade flow ', trd@name)
    obj@parameters[['mTradeComm']] <- .add_data(obj@parameters[['mTradeComm']],
                                                data.table(trade = trd@name, comm = trd@commodity))
    mTradeRoutes <- cbind(trade = rep(trd@name, nrow(trd@routes)), trd@routes)
    obj@parameters[['mTradeRoutes']] <- .add_data(obj@parameters[['mTradeRoutes']], mTradeRoutes)
    pTradeIrCdst2Aout <- NULL; pTradeIrCsrc2Aout <- NULL; pTradeIrCdst2Ainp <- NULL; pTradeIrCsrc2Ainp <- NULL;
    # approxim <- approxim[names(approxim) != 'region']
    approxim_srcdst <- approxim
    approxim_srcdst$region <- paste0(trd@routes$src, '##', trd@routes$dst)
    # Apply routes to approximation
    routes <- trd@routes
    imply_routes <- function(tmp) {
      # Checking user data for errors
      kk <- tmp[!is.na(tmp$src) & !is.na(tmp$dst), c('src', 'dst'), drop = FALSE]
      if (nrow(kk) > 0) {
        if (nrow(kk) != nrow(.merge_with_null(kk, routes))) {
          cat('There are data for class trade "', trd@name, ' for unknown routes:\n', sep = '')
          kk$ind <- seq_len(nrow(kk))
          print(kk[kk$ind[!(kk$ind %in% .merge_with_null(kk, routes))], c('src', 'dst'), drop = FALSE])
        }
      }
      # Approximation src/dst pair
      if (any(is.na(tmp$src) != is.na(tmp$dst))) {
        # src NA
        fl <- seq_len(nrow(tmp))[is.na(tmp$src) & !is.na(tmp$dst)]
        if (length(fl) > 0) {
          for (i in fl) {
            dst <- routes$dst[!(routes$dst %in% tmp[i, 'dst'])]
            if (length(dst) > 0) {
              nn <- nrow(tmp) + seq_along(dst)
              tmp <- rbind(tmp, tmp[rep(i, length(dst)),, drop = FALSE])
              tmp[nn, 'dst'] <- dst
            }
          }
          tmp <- tmp[-fl,, drop = FALSE]
        }
        # dst NA
        fl <- seq_len(nrow(tmp))[!is.na(tmp$src) & is.na(tmp$dst)]
        if (length(fl) > 0) {
          for (i in fl) {
            src <- routes$dst[!(routes$src %in% tmp[i, 'src'])]
            if (length(src) > 0) {
              nn <- nrow(tmp) + seq_along(src)
              tmp <- rbind(tmp, tmp[rep(i, length(src)),, drop = FALSE])
              tmp[nn, 'src'] <- src
            }
          }
          tmp <- tmp[-fl,, drop = FALSE]
        }
      }
      # src & dst NA
      fl <- seq_len(nrow(tmp))[is.na(tmp$src) & is.na(tmp$dst)]
      if (length(fl) > 0) {
        kk <- rbind(tmp[-fl, c('src', 'dst'), drop = FALSE], routes)
        kk <- kk[!(duplicated(kk) | duplicated(kk, fromLast = TRUE)),, drop = FALSE]
      }
      if (length(fl) > 0 && nrow(kk) > 0) {
        nn <- nrow(tmp) + seq_len(nrow(kk) * length(fl))
        tmp <- rbind(tmp, tmp[c(t(matrix(fl, length(fl), nrow(kk)))),, drop = FALSE])
        tmp[nn, 'src'] <- kk$src
        tmp[nn, 'dst'] <- kk$dst
        tmp <- tmp[-fl,, drop = FALSE]
      }
      rownames(tmp) <- NULL
      tmp
    }
    simpleInterpolation2 <- function(frm, approxim, parameter, ...) {
      frm <- frm[!is.na(frm[[parameter]]), ]
      if (nrow(frm) == 0 && !approxim$fullsets) return(NULL)
      if (nrow(frm) != 0) {
        frm <- imply_routes(frm)
        frm$region <- paste0(frm$src, '##', frm$dst)
      } else {
        frm$region <- character()
      }
      frm$src <- NULL; frm$dst <- NULL
      frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), with = FALSE]
      dd <- simpleInterpolation(frm, approxim = approxim, parameter = parameter, ...)
      if (is.null(dd) || nrow(dd) == 0) return(NULL)
      if (any(list(...)[[1]]@dimSetNames == 'src')) dd$src <- gsub('##.*', '', dd$region)
      if (any(list(...)[[1]]@dimSetNames == 'dst')) dd$dst <- gsub('.*##', '', dd$region)
      dd$region <- NULL
      dd
    }
    multiInterpolation2 <- function(frm, approxim, parameter, ...) {
      frm <- frm[!is.na(frm[[paste0(parameter, '.lo')]]) | !is.na(frm[[paste0(parameter, '.up')]]) | !is.na(frm[[paste0(parameter, '.fx')]]), ]
      if (nrow(frm) == 0 && !approxim$fullsets) return(NULL)
      if (nrow(frm) != 0) {
        clo <- frm[[paste0(parameter, '.lo')]]
        cup <- frm[[paste0(parameter, '.up')]]
        cfx <- frm[[paste0(parameter, '.fx')]]
        frm[, paste0(parameter, c('.up', '.fx', '.lo'))] <- NA
        frm <- rbind(frm, frm)
        frm[[paste0(parameter, '.lo')]] <- c(clo, cfx)
        frm_lo <- imply_routes(frm[!is.na(c(clo, cfx)), ])
        frm[[paste0(parameter, '.lo')]] <- NA
        frm[[paste0(parameter, '.up')]] <- c(cup, cfx)
        frm_up <- imply_routes(frm[!is.na(c(cup, cfx)),])
        frm <- rbind(frm_lo, frm_up)
        frm$region <- paste0(frm$src, '##', frm$dst)
      } else {
        frm$region <- character()
      } 
      frm$src <- NULL; frm$dst <- NULL
      frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), with = FALSE]
      dd <- multiInterpolation(frm, approxim = approxim, parameter = parameter, ...)
      if (is.null(dd) || nrow(dd) == 0) return(NULL)
      if (any(list(...)[[1]]@dimSetNames == 'src')) dd$src <- gsub('##.*', '', dd$region)
      if (any(list(...)[[1]]@dimSetNames == 'dst')) dd$dst <- gsub('.*##', '', dd$region)
      dd$region <- NULL
      dd
    }
    # pTradeIrCost
    obj@parameters[['pTradeIrCost']] <- .add_data(obj@parameters[['pTradeIrCost']],
                                                  simpleInterpolation2(trd@trade, parameter = 'cost', obj@parameters[['pTradeIrCost']], 
                                                                       approxim = approxim_srcdst, 'trade', trd@name))
    pTradeIrEff <- simpleInterpolation2(trd@trade, parameter = 'teff', obj@parameters[['pTradeIrEff']], 
                                        approxim = approxim_srcdst, 'trade', trd@name)
    obj@parameters[['pTradeIrEff']] <- .add_data(obj@parameters[['pTradeIrEff']], pTradeIrEff)
    # pTradeIrMarkup
    obj@parameters[['pTradeIrMarkup']] <- .add_data(obj@parameters[['pTradeIrMarkup']],
                                                    simpleInterpolation2(trd@trade, parameter = 'markup', obj@parameters[['pTradeIrMarkup']], 
                                                                         approxim = approxim_srcdst, 'trade', trd@name))
    # pTradeIr
    pTradeIr <- multiInterpolation2(trd@trade, parameter = 'ava',
                                    obj@parameters[['pTradeIr']], approxim = approxim_srcdst, 'trade', trd@name)
    obj@parameters[['pTradeIr']] <- .add_data(obj@parameters[['pTradeIr']], pTradeIr)
    # Trade ainp
    mTradeIrAInp <- NULL; mTradeIrAOut <- NULL;
    if (nrow(trd@aux) != 0) {
      if (any(is.na(trd@aux$acomm))) 
        stop('Wrong aux commodity for trade "', trd@name, '"')
      trd@aeff <- trd@aeff[!is.na(trd@aeff$acomm),, drop = FALSE]
      if (!all(trd@aeff$acomm %in% trd@aux$acomm))
        stop('Wrong aux commodity for trade "', trd@name, '"')
      inp_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2ainp) | !is.na(trd@aeff$cdst2ainp), 'acomm'])
      out_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2aout) | !is.na(trd@aeff$cdst2aout), 'acomm'])
      if (length(inp_comm) != 0) {
        mTradeIrAInp <- data.table(trade = rep(trd@name, length(inp_comm)), comm = inp_comm)
        obj@parameters[['mTradeIrAInp']] <- .add_data(obj@parameters[['mTradeIrAInp']], mTradeIrAInp)
      } 
      if (length(out_comm) != 0) {
        mTradeIrAOut <- data.table(trade = rep(trd@name, length(out_comm)), comm = out_comm)
        obj@parameters[['mTradeIrAOut']] <- .add_data(obj@parameters[['mTradeIrAOut']], mTradeIrAOut)
      } 
      for (cc in inp_comm) {
        approxim_srcdst$acomm <- cc
        pTradeIrCsrc2Ainp <- simpleInterpolation2(trd@aeff, parameter = 'csrc2ainp', obj@parameters[['pTradeIrCsrc2Ainp']], 
                                                  approxim = approxim_srcdst, 'trade', trd@name)
        obj@parameters[['pTradeIrCsrc2Ainp']] <- .add_data(obj@parameters[['pTradeIrCsrc2Ainp']], pTradeIrCsrc2Ainp)
        pTradeIrCdst2Ainp <- simpleInterpolation2(trd@aeff, parameter = 'cdst2ainp', obj@parameters[['pTradeIrCdst2Ainp']], 
                                                  approxim = approxim_srcdst, 'trade', trd@name)
        obj@parameters[['pTradeIrCdst2Ainp']] <- .add_data(obj@parameters[['pTradeIrCdst2Ainp']], pTradeIrCdst2Ainp)
      }
      for (cc in out_comm) {
        approxim_srcdst$acomm <- cc
        pTradeIrCsrc2Aout <- simpleInterpolation2(trd@aeff, parameter = 'csrc2aout', obj@parameters[['pTradeIrCsrc2Aout']], 
                                                  approxim = approxim_srcdst, 'trade', trd@name)
        obj@parameters[['pTradeIrCsrc2Aout']] <- .add_data(obj@parameters[['pTradeIrCsrc2Aout']], pTradeIrCsrc2Aout)
        pTradeIrCdst2Aout <- simpleInterpolation2(trd@aeff, parameter = 'cdst2aout', obj@parameters[['pTradeIrCdst2Aout']], 
                                                  approxim = approxim_srcdst, 'trade', trd@name)
        obj@parameters[['pTradeIrCdst2Aout']] <- .add_data(obj@parameters[['pTradeIrCdst2Aout']], pTradeIrCdst2Aout)
      }
      approxim_srcdst$acomm <- NULL
    }
    # Add trade data
    if (trd@capacityVariable) {
      obj@parameters[['pTradeCap2Act']] <- .add_data(obj@parameters[['pTradeCap2Act']],
                                                     data.table(trade = trd@name, value = trd@cap2act))
      mTradeCapacityVariable <- data.table(trade = trd@name)
      obj@parameters[['mTradeCapacityVariable']] <- .add_data(obj@parameters[['mTradeCapacityVariable']], mTradeCapacityVariable)
      
      ##!!! Trade 
      if (nrow(trd@invcost) > 0) {
        if (any(is.na(trd@invcost$region)) && nrow(trd@invcost) > 1)
          stop('There is "NA" and other data for invcost in trade class "', trd@name, '".')
        if (any(is.na(trd@invcost$region))) {
          warning('There is a" NA "area for invcost in the"', trd@name, '"trade class. Investments will be smoothed along all routes of the regions.')
          rgg <- unique(c(trd@routes$src, trd@routes$dst))
          trd@invcost <- trd@invcost[rep(1, length(rgg)),, drop = FALSE]
          trd@invcost[, 'region'] <- rgg
          trd@invcost[, 'invcost'] <- trd@invcost[1, 'invcost'] / length(rgg)
        }
      }
      invcost <- simpleInterpolation(trd@invcost, 'invcost', obj@parameters[['pTradeInvcost']], approxim, 'trade', trd@name)
      invcost <- invcost[invcost$value != 0,, drop = FALSE]
      if (!is.null(invcost$year)) invcost <- invcost[trd@start <= invcost$year & invcost$year <= trd@end,, drop = FALSE]
      if (nrow(invcost) == 0) invcost <- NULL
      stock_exist <- simpleInterpolation(trd@stock, 'stock', obj@parameters[['pTradeStock']], approxim, 'trade', trd@name)
      obj@parameters[['pTradeStock']] <- .add_data(obj@parameters[['pTradeStock']], stock_exist)
      obj@parameters[['pTradeOlife']] <- .add_data(obj@parameters[['pTradeOlife']], 
                                                   data.table(trade = trd@name, value = trd@olife, stringsAsFactors=FALSE))
      possible_invest_year <- approxim$mileStoneYears
      possible_invest_year <- possible_invest_year[trd@start <= possible_invest_year & possible_invest_year <= trd@end]
      if (length(possible_invest_year) > 0)
        obj@parameters[['mTradeNew']] <- .add_data(obj@parameters[['mTradeNew']], 
                                                   data.table(trade = rep(trd@name, length(possible_invest_year)), year = possible_invest_year, stringsAsFactors=FALSE))
      
      min0 <- function(x) {
        if (length(x) == 0) return(-Inf)
        return(min(x))
      }
      if (trd@olife == Inf) {
        trade_eac <- unique(approxim$year[min0(possible_invest_year) <= approxim$year])
        trade_span <- unique(c(trd@stock$year, trade_eac))
        obj@parameters[['mTradeOlifeInf']] <- .add_data(obj@parameters[['mTradeOlifeInf']], data.table(trade = trd@name))
      } else {
        trade_eac <- unique(c(sapply(possible_invest_year, 
                                     function(x) approxim$year[x <= approxim$year & approxim$year <= x + trd@olife]), recursive = TRUE))
        trade_span <- unique(c(trd@stock$year, trade_eac))
      }
      trade_eac <- trade_eac[trade_eac %in% approxim$mileStoneYears]
      trade_span <- trade_span[trade_span %in% approxim$mileStoneYears]
      if (length(trade_span) > 0) {
        mTradeSpan <- data.table(trade = rep(trd@name, length(trade_span)), year = trade_span, stringsAsFactors=FALSE)
        obj@parameters[['mTradeSpan']] <- .add_data(obj@parameters[['mTradeSpan']], mTradeSpan)
        meqTradeCapFlow <- .merge_with_null(mTradeSpan, mTradeSlice)
        meqTradeCapFlow$comm <- trd@commodity
        obj@parameters[['meqTradeCapFlow']] <- .add_data(obj@parameters[['meqTradeCapFlow']], meqTradeCapFlow)
      }
      # mTradeInv
      if (!is.null(invcost)) {
        end_year <- max(approxim$year)
        obj@parameters[['pTradeInvcost']] <- .add_data(obj@parameters[['pTradeInvcost']], invcost)
        if (any(!(obj@parameters[['mTradeInv']]@dimSetNames %in% colnames(invcost)))) {
          if (is.null(invcost$year)) {
            invcost <- .merge_with_null(invcost, list(year = possible_invest_year))
          }
          if (is.null(invcost$region)) {
            invcost <- .merge_with_null(invcost, approxim['region'])
          }
        }
        obj@parameters[['mTradeInv']] <- .add_data(obj@parameters[['mTradeInv']], invcost[, colnames(invcost) != 'value'])
        invcost$invcost <- invcost$value; invcost$value <- NULL
        if (length(trade_eac) > 0) {
          mTradeEac <- .merge_with_null(unique(invcost$region), trade_eac)
          mTradeEac$trade <- trd@name
          mTradeEac$region <- as.character(mTradeEac$x)
          mTradeEac$year <- mTradeEac$y
          mTradeEac$x <- NULL; mTradeEac$y <- NULL
          obj@parameters[['mTradeEac']] <- .add_data(obj@parameters[['mTradeEac']], mTradeEac)
        }
        
        salv_data <- .merge_with_null(invcost, approxim$discount, all.x = TRUE)
        salv_data$value[is.na(salv_data$value)] <- 0
        salv_data$discount <- salv_data$value; salv_data$value <- NULL
        salv_data$olife <- trd@olife
        # EAC
        salv_data$eac <- salv_data$invcost / salv_data$olife
        fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
        salv_data$eac[fl] <- salv_data$invcost[fl] * (salv_data$discount[fl] * (1 + salv_data$discount[fl]) ^ salv_data$olife[fl] / 
                                                        ((1 + salv_data$discount[fl]) ^ salv_data$olife[fl] - 1))
        fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
        salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
        salv_data$trade <- trd@name
        salv_data$value <- salv_data$eac
        pTradeEac <- salv_data[, c('trade', 'region', 'year', 'value')]
        obj@parameters[['pTradeEac']] <- .add_data(obj@parameters[['pTradeEac']], unique(pTradeEac[, colnames(pTradeEac) %in% c(obj@parameters[['pTradeEac']]@dimSetNames, 'value'), drop = FALSE]))
      }
    }
    ####
    mTradeIr <- .merge_with_null(mTradeRoutes, mTradeSlice)
    if (trd@capacityVariable) {
      mTradeIr <- .merge_with_null(mTradeIr, mTradeSpan)
    } else mTradeIr <- data.table(crossing(mTradeIr, data.table(year = approxim$mileStoneYears)))

    obj@parameters[['mTradeIr']] <- .add_data(obj@parameters[['mTradeIr']], mTradeIr)
    ### To trades
    if (!is.null(mTradeIrAInp)) {
      if (!is.null(pTradeIrCsrc2Ainp) && any(pTradeIrCsrc2Ainp$value != 0)) {
        mTradeIrCsrc2Ainp <- pTradeIrCsrc2Ainp[pTradeIrCsrc2Ainp$value != 0, colnames(pTradeIrCsrc2Ainp) %in% c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), drop = FALSE]
        if (is.null(mTradeIrCsrc2Ainp$acomm)) mTradeIrCsrc2Ainp <- .merge_with_null(mTradeIrCsrc2Ainp, mTradeIrAInp)
        mTradeIrCsrc2Ainp$comm <- mTradeIrCsrc2Ainp$acomm; mTradeIrCsrc2Ainp$acomm <- NULL
        if (ncol(mTradeIrCsrc2Ainp) != 6) mTradeIrCsrc2Ainp <- .merge_with_null(mTradeIrCsrc2Ainp, mTradeIr)
        obj@parameters[['mTradeIrCsrc2Ainp']] <- .add_data(obj@parameters[['mTradeIrCsrc2Ainp']], mTradeIrCsrc2Ainp)
        a1 <-  unique(mTradeIrCsrc2Ainp[, c('trade', 'comm', 'src', 'year', 'slice')])
        colnames(a1)[3] <- 'region'
      }  else a1 <- NULL
      if (!is.null(pTradeIrCdst2Ainp) && any(pTradeIrCdst2Ainp$value != 0)) {
        mTradeIrCdst2Ainp <- pTradeIrCdst2Ainp[pTradeIrCdst2Ainp$value != 0, colnames(pTradeIrCdst2Ainp) %in% c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), drop = FALSE]
        if (is.null(mTradeIrCdst2Ainp$acomm)) mTradeIrCdst2Ainp <- .merge_with_null(mTradeIrCdst2Ainp, mTradeIrAInp)
        mTradeIrCdst2Ainp$comm <- mTradeIrCdst2Ainp$acomm; mTradeIrCdst2Ainp$acomm <- NULL
        if (ncol(mTradeIrCdst2Ainp) != 6) mTradeIrCdst2Ainp <- .merge_with_null(mTradeIrCdst2Ainp, mTradeIr)
        obj@parameters[['mTradeIrCdst2Ainp']] <- .add_data(obj@parameters[['mTradeIrCdst2Ainp']], mTradeIrCdst2Ainp)
        a2 <-  unique(mTradeIrCdst2Ainp[, c('trade', 'comm', 'dst', 'year', 'slice')])
        colnames(a2)[3] <- 'region'
      } else a2 <- NULL
      obj@parameters[['mvTradeIrAInp']] <- .add_data(obj@parameters[['mvTradeIrAInp']], unique(rbind(a1, a2)))
    }
    
    if (!is.null(mTradeIrAOut)) {
      if (!is.null(pTradeIrCsrc2Aout) && any(pTradeIrCsrc2Aout$value != 0)) {
        mTradeIrCsrc2Aout <- pTradeIrCsrc2Aout[pTradeIrCsrc2Aout$value != 0, colnames(pTradeIrCsrc2Aout) %in% c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), drop = FALSE]
        if (is.null(mTradeIrCsrc2Aout$acomm)) mTradeIrCsrc2Aout <- .merge_with_null(mTradeIrCsrc2Aout, mTradeIrAOut)
        mTradeIrCsrc2Aout$comm <- mTradeIrCsrc2Aout$acomm; mTradeIrCsrc2Aout$acomm <- NULL
        if (ncol(mTradeIrCsrc2Aout) != 6) mTradeIrCsrc2Aout <- .merge_with_null(mTradeIrCsrc2Aout, mTradeIr)
        obj@parameters[['mTradeIrCsrc2Aout']] <- .add_data(obj@parameters[['mTradeIrCsrc2Aout']], mTradeIrCsrc2Aout)
        a1 <-  unique(mTradeIrCsrc2Aout[, c('trade', 'comm', 'src', 'year', 'slice')])
        colnames(a1)[3] <- 'region'
      }  else a1 <- NULL
      if (!is.null(pTradeIrCdst2Aout) && any(pTradeIrCdst2Aout$value != 0)) {
        mTradeIrCdst2Aout <- pTradeIrCdst2Aout[pTradeIrCdst2Aout$value != 0, colnames(pTradeIrCdst2Aout) %in% c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), drop = FALSE]
        if (is.null(mTradeIrCdst2Aout$acomm)) mTradeIrCdst2Aout <- .merge_with_null(mTradeIrCdst2Aout, mTradeIrAOut)
        mTradeIrCdst2Aout$comm <- mTradeIrCdst2Aout$acomm; mTradeIrCdst2Aout$acomm <- NULL
        if (ncol(mTradeIrCdst2Aout) != 6) mTradeIrCdst2Aout <- .merge_with_null(mTradeIrCdst2Aout, mTradeIr)
        obj@parameters[['mTradeIrCdst2Aout']] <- .add_data(obj@parameters[['mTradeIrCdst2Aout']], mTradeIrCdst2Aout)
        a2 <-  unique(mTradeIrCdst2Aout[, c('trade', 'comm', 'dst', 'year', 'slice')])
        colnames(a2)[3] <- 'region'
      } else a2 <- NULL
      obj@parameters[['mvTradeIrAOut']] <- .add_data(obj@parameters[['mvTradeIrAOut']], unique(rbind(a1, a2)))
    }
    mvTradeIr <- mTradeIr; mvTradeIr$comm <- trd@commodity
    obj@parameters[['mvTradeIr']] <- .add_data(obj@parameters[['mvTradeIr']], mvTradeIr) 
    if (!is.null(pTradeIr)) {
      pTradeIr$comm <- trd@commodity
      obj@parameters[['meqTradeFlowLo']] <- .add_data(obj@parameters[['meqTradeFlowLo']], .merge_with_null(mvTradeIr, pTradeIr[pTradeIr$type == 'lo' & pTradeIr$value != 0, 
                                                                                                                    colnames(pTradeIr) %in% colnames(mvTradeIr), drop = FALSE]))
      obj@parameters[['meqTradeFlowUp']] <- .add_data(obj@parameters[['meqTradeFlowUp']], .merge_with_null(mvTradeIr, pTradeIr[pTradeIr$type == 'up' & pTradeIr$value != Inf, 
                                                                                                                    colnames(pTradeIr) %in% colnames(mvTradeIr), drop = FALSE]))
      pTradeIr$comm <- NULL
    }
    obj
  })






