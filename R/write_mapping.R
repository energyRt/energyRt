.write_mapping <- function(prec, interpolation_time_begin, interpolation_count, len_name) {
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]
  bacs <- paste0(rep('\b', len_name), collapse = '')
  rest = interpolation_count - 77;
  cat(paste0(rep(' ', len_name), collapse = ''))

  # Clean previous set data if any
  reduce.sect <- function(x, set) {
  	x <- x[, set, drop = FALSE]
  	x[!duplicated(x),, drop = FALSE]
  }
  .interpolation_message('region', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  region <- getParameterData(prec@parameters$region)
  .interpolation_message('mMidMilestone', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  year <- getParameterData(prec@parameters$mMidMilestone)
  .interpolation_message('mSliceParentChildE', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  # Total parameter ruductions
  mSliceParentChildE <- getParameterData(prec@parameters$mSliceParentChildE)
  .interpolation_message('mCommSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mCommSlice <- getParameterData(prec@parameters$mCommSlice)
  uu <- mSliceParentChildE
  colnames(uu) <- c('slicep', 'slice')
  map_for_comm <- merge(mCommSlice, uu)[, c('comm', 'slicep')]
  colnames(map_for_comm) <- c('comm', 'slice')
  map_for_comm <- map_for_comm[!duplicated(map_for_comm), ]
  .interpolation_message('mCommSliceOrParent', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  # mCommSliceOrParent
  l1 <- merge(getParameterData(prec@parameters$comm), getParameterData(prec@parameters$slice))
  l2 <-merge(mCommSlice, mSliceParentChildE)[, c('comm', 'slice', 'slicep')]
  l3 <- l2[!duplicated(l2[, c('comm', 'slicep')]), c('comm', 'slicep')]
  colnames(l3)[2] <- 'slice'
  l3 <- rbind(l1, l3)
  l3 <- l3[!duplicated(l3) & !duplicated(l3, fromLast=TRUE), ]
  l3$slicep <- l3$slice
  mCommSliceOrParent <- rbind(l2, l3)
  prec@parameters[['mCommSliceOrParent']] <- addData(prec@parameters[['mCommSliceOrParent']], mCommSliceOrParent)
  .interpolation_message('mTechInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  reduce_total_map <- function(yy) {
    yy$slicep <- yy$slice; yy$slice <- NULL
    reduce.duplicate(merge(yy, mCommSliceOrParent, by = c('comm', 'slicep'))[, -2])
  }
  prec@parameters[['mTechInpTot']] <- addData(prec@parameters[['mTechInpTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechInp)[, -1], getParameterData(prec@parameters$mvTechAInp)[, -1]))))
  .interpolation_message('mTechOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mTechOutTot']] <- addData(prec@parameters[['mTechOutTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechOut)[, -1], getParameterData(prec@parameters$mvTechAOut)[, -1]))))
  .interpolation_message('mSupOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], reduce.sect(
    getParameterData(prec@parameters$mSupAva)[, -1]))
  .interpolation_message('mDemInp', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
  	reduce.sect(merge(mCommSlice, getParameterData(prec@parameters$mDemComm), by = 'comm'), c('comm', 'slice')))
  
  .interpolation_message('pEmissionFactor', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  #### This section have to move to add (after interpolate comm first)
  
  tmp0 <- getParameterData(prec@parameters$pTechEmisComm)
  tmp <- merge(getParameterData(prec@parameters$mvTechInp), tmp0[tmp0$value != 0, ], by = c('tech', 'comm'))
  .interpolation_message('mvTechAct', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  colnames(tmp)[colnames(tmp) == 'comm'] <- 'commp'
  tmp1 <- getParameterData(prec@parameters$pEmissionFactor)
  .interpolation_message('mvTechAct', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  tmp1 <- tmp1[tmp1$value != 0, ]
  tmp1 <- tmp1[!duplicated(tmp1),, drop = FALSE]
  tmp <- merge(tmp1, tmp, by = 'commp')[, c('tech', 'comm', 'commp', 'region', 'year', 'slice')]
  tmp <- tmp[!duplicated(tmp),, drop = FALSE]
  .interpolation_message('mTechEmsFuel', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  colnames(tmp)[3] <- 'comm.1'
  prec@parameters[['mTechEmsFuel']] <- addData(prec@parameters[['mTechEmsFuel']], tmp)
  .interpolation_message('mEmsFuelTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  # mEmsFuelTot(comm, region, year, slice)$(sum(tech$(mTechSpan(tech, region, year) and mTechSlice(tech, slice) and mTechEmitedComm(tech, comm)), 1))  
  prec@parameters[['mEmsFuelTot']] <- addData(prec@parameters[['mEmsFuelTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters[['mTechEmsFuel']]), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mDummyImport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  no_inf <- function(x) {
    x = getParameterData(prec@parameters[[x]])
    x[x$value != Inf, -ncol(x)]
  }
  prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], no_inf('pDummyImportCost'))
  .interpolation_message('mDummyExport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], no_inf('pDummyExportCost'))
  .interpolation_message('mDummyCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
  	reduce.sect(rbind(getParameterData(prec@parameters[['mDummyImport']]), 
  		getParameterData(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))
  .interpolation_message('mvTradeIrAInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  # mvTradeIrAInpTot
  prec@parameters[['mvTradeIrAInpTot']] <- addData(prec@parameters[['mvTradeIrAInpTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters$mvTradeIrAInp), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mvTradeIrAOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mvTradeIrAOutTot']] <- addData(prec@parameters[['mvTradeIrAOutTot']], reduce_total_map(
    reduce.sect(getParameterData(prec@parameters$mvTradeIrAOut), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mTradeComm', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
    
    ### Export
    mCommSliceOrParent2 <- mCommSliceOrParent
    colnames(mCommSliceOrParent2)[3] <- 'slice.1'
    # .interpolation_message('mExportIrSubSliceTrd', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExportIrSubSliceTrd <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))
    colnames(mExportIrSubSliceTrd)[6] <- 'slice.1'
    mExportIrSubSliceTrd$dst <- NULL
    mExportIrSubSliceTrd <- merge(mExportIrSubSliceTrd, mCommSliceOrParent2)
    colnames(mExportIrSubSliceTrd)[4] <- 'region'
    mExportIrSubSliceTrd <- mExportIrSubSliceTrd[!duplicated(mExportIrSubSliceTrd), ]
    # prec@parameters[['mExportIrSubSliceTrd']] <- addData(prec@parameters[['mExportIrSubSliceTrd']], mExportIrSubSliceTrd)
    # .interpolation_message('mExportIrSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExportIrSubSlice <- mExportIrSubSliceTrd[, -3]
    mExportIrSubSlice <- mExportIrSubSlice[!duplicated(mExportIrSubSlice), ]
    # prec@parameters[['mExportIrSubSlice']] <- addData(prec@parameters[['mExportIrSubSlice']], mExportIrSubSlice)
    # .interpolation_message('mExportIrSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExportIrSub <- mExportIrSubSlice[, -2]
    mExportIrSub <- mExportIrSub[!duplicated(mExportIrSub), ]
    # prec@parameters[['mExportIrSub']c] <-С addData(prec@parameters[['mExportIrSub']], mExportIrSub)
    # .interpolation_message('mExportRowSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExportRowSubTmp <- reduce.sect(getParameterData(prec@parameters[['mExportRow']])[, c('comm', 'region', 'year', 'slice')],
      c('comm', 'region', 'year', 'slice'))
    # .interpolation_message('mExportRowSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    colnames(mExportRowSubTmp)[4] <- 'slice.1'
    mExportRowSubSlice <- merge(mExportRowSubTmp, mCommSliceOrParent2)
    # prec@parameters[['mExportRowSubSlice']] <- addData(prec@parameters[['mExportRowSubSlice']], mExportRowSubSlice)
    # .interpolation_message('mExportRowSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExportRowSub <- mExportRowSubSlice[, colnames(mExportRowSubSlice) != 'slice.1']
    mExportRowSub <- mExportRowSub[!duplicated(mExportRowSub), ]
    # prec@parameters[['mExportRowSub']] <- addData(prec@parameters[['mExportRowSub']], mExportRowSub)
    .interpolation_message('mExport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mExport <- rbind(mExportRowSub, mExportIrSub)
    mExport <- mExport[!duplicated(mExport), ]
    prec@parameters[['mExport']] <- addData(prec@parameters[['mExport']], mExport)
    
    ### Import
    # .interpolation_message('mImportIrSubSliceTrd', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImportIrSubSliceTrd <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))
    colnames(mImportIrSubSliceTrd)[6] <- 'slice.1'
    mImportIrSubSliceTrd$src <- NULL
    mImportIrSubSliceTrd <- merge(mImportIrSubSliceTrd, mCommSliceOrParent2)
    colnames(mImportIrSubSliceTrd)[4] <- 'region'
    mImportIrSubSliceTrd <- mImportIrSubSliceTrd[!duplicated(mImportIrSubSliceTrd), ]
    # prec@parameters[['mImportIrSubSliceTrd']] <- addData(prec@parameters[['mImportIrSubSliceTrd']], mImportIrSubSliceTrd)
    # .interpolation_message('mImportIrSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImportIrSubSlice <- mImportIrSubSliceTrd[, -3]
    mImportIrSubSlice <- mImportIrSubSlice[!duplicated(mImportIrSubSlice), ]
    # prec@parameters[['mImportIrSubSlice']] <- addData(prec@parameters[['mImportIrSubSlice']], mImportIrSubSlice)
    # .interpolation_message('mImportIrSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImportIrSub <- mImportIrSubSlice[, -2]
    mImportIrSub <- mImportIrSub[!duplicated(mImportIrSub), ]
    # prec@parameters[['mImportIrSub']] <- addData(prec@parameters[['mImportIrSub']], mImportIrSub)
    # .interpolation_message('mImportRowSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImportRowSubTmp <- reduce.sect(getParameterData(prec@parameters[['mImportRow']])[, c('comm', 'region', 'year', 'slice')],
    c('comm', 'region', 'year', 'slice'))
    # .interpolation_message('mImportRowSubSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    colnames(mImportRowSubTmp)[4] <- 'slice.1'
    mImportRowSubSlice <- merge(mImportRowSubTmp, mCommSliceOrParent2)
    # prec@parameters[['mImportRowSubSlice']] <- addData(prec@parameters[['mImportRowSubSlice']], mImportRowSubSlice)
    # .interpolation_message('mImportRowSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImportRowSub <- mImportRowSubSlice[, colnames(mImportRowSubSlice) != 'slice.1']
    mImportRowSub <- mImportRowSub[!duplicated(mImportRowSub), ]
    # prec@parameters[['mImportRowSub']] <- addData(prec@parameters[['mImportRowSub']], mImportRowSub)
    .interpolation_message('mImport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mImport <- rbind(mImportRowSub, mImportIrSub)
    mImport <- mImport[!duplicated(mImport), ]
    prec@parameters[['mImport']] <- addData(prec@parameters[['mImport']], mImport)
    
    #
    .interpolation_message('mStorageInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    prec@parameters[['mStorageInpTot']] <- addData(prec@parameters[['mStorageInpTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
    .interpolation_message('mStorageOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['mStorageOutTot']] <- addData(prec@parameters[['mStorageOutTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
    .interpolation_message('mTaxCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    # mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
    prec@parameters[['mTaxCost']] <- addData(prec@parameters[['mTaxCost']], reduce.sect(getParameterData(prec@parameters$pTaxCost), c('comm', 'region', 'year')))
    # mSubsCost(comm, region, year)  sum(slice$pSubsCost(comm, region, year, slice), 1)
    .interpolation_message('mSubsCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['mSubsCost']] <- addData(prec@parameters[['mSubsCost']], reduce.sect(getParameterData(prec@parameters$pSubsCost), c('comm', 'region', 'year')))
    #    (sum(commp$pAggregateFactor(comm, commp), 1))
    .interpolation_message('mAggOut', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    if (nrow(getParameterData(prec@parameters$pAggregateFactor)) > 0) {
      prec@parameters[['mAggOut']] <- addData(prec@parameters[['mAggOut']], reduce_total_map(reduce.duplicate(
        merge(merge(merge(reduce.sect(getParameterData(prec@parameters$pAggregateFactor), 'comm'), getParameterData(prec@parameters$region)), 
                    year), getParameterData(prec@parameters$slice)))))
    }
    .interpolation_message('mOut2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    a1 <- mCommSlice; colnames(a1)[2] <- 'slicep'
    a2 <- getParameterData(prec@parameters$mSliceParentChild)
    for2Lo <- merge(a1, a2, by = 'slicep'); for2Lo$slicep <- NULL
    for2Lo <- reduce.duplicate(for2Lo)
    cll <- c('comm', 'region', 'year', 'slice')
    mOut2Lo <- merge(reduce.duplicate(rbind(merge(getParameterData(prec@parameters$mSupOutTot), 
                                                  getParameterData(prec@parameters$year))[, cll], 
          getParameterData(prec@parameters$mEmsFuelTot)[, cll], 
          getParameterData(prec@parameters$mAggOut)[, cll], 
          getParameterData(prec@parameters$mTechOutTot)[, cll], 
          getParameterData(prec@parameters$mStorageOutTot)[, cll], 
          getParameterData(prec@parameters$mImport)[, cll], 
          getParameterData(prec@parameters$mvTradeIrAOutTot)[, cll])), for2Lo, by =  c('comm', 'slice'))[, cll]
    mOut2Lo <- mOut2Lo[!(paste0(mOut2Lo$comm, '#', mOut2Lo$slice) %in% 
                           paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    prec@parameters[['mOut2Lo']] <- addData(prec@parameters[['mOut2Lo']], mOut2Lo)
    
    .interpolation_message('mInp2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mInp2Lo <- merge(reduce.duplicate(rbind(getParameterData(prec@parameters$mTechInpTot)[, cll], 
                                            getParameterData(prec@parameters$mStorageInpTot)[, cll], 
                                            getParameterData(prec@parameters$mExport)[, cll], 
                                            getParameterData(prec@parameters$mvTradeIrAInpTot)[, cll])), 
                     for2Lo, by =  c('comm', 'slice'))[, cll]
    mInp2Lo <- mInp2Lo[!(paste0(mInp2Lo$comm, '#', mInp2Lo$slice) %in% paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    prec@parameters[['mInp2Lo']] <- addData(prec@parameters[['mInp2Lo']], mInp2Lo)
    .interpolation_message('mvTradeCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    ##
    dregionyear <- merge(region, year)
    .interpolation_message('mvTradeCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['mvTradeCost']] <- addData(prec@parameters[['mvTradeCost']], dregionyear)
    .interpolation_message('mvTradeRowCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['mvTradeRowCost']] <- addData(prec@parameters[['mvTradeRowCost']], dregionyear)
    .interpolation_message('mvTradeIrCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['mvTradeIrCost']] <- addData(prec@parameters[['mvTradeIrCost']], dregionyear)
    .interpolation_message('mvDemInp', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    prec@parameters[['mvDemInp']] <- addData(prec@parameters[['mvDemInp']], 
      merge(dregionyear, getParameterData(prec@parameters[['mDemInp']]))[,c('comm', 'region', 'year', 'slice')])
    .interpolation_message('mvTotalCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    prec@parameters[['mvTotalCost']] <- addData(prec@parameters[['mvTotalCost']], dregionyear)
    .interpolation_message('mvInp2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mCommSlice2 <- getParameterData(prec@parameters[['mCommSlice']])
    colnames(mCommSlice2)[2] <- 'slicep'
    mvInp2Lo <- merge(getParameterData(prec@parameters[['mInp2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
      )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    mvInp2Lo <- merge(mvInp2Lo, mCommSlice2)
    colnames(mvInp2Lo)[colnames(mvInp2Lo) == 'slicep'] <- 'slice.1'
    mvInp2Lo <- mvInp2Lo[, c("comm", "region", "year", "slice", "slice.1")]
    prec@parameters[['mvInp2Lo']] <- addData(prec@parameters[['mvInp2Lo']], mvInp2Lo)
    
    .interpolation_message('mInpSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    if (!is.null(mvInp2Lo)) {
      mInpSub <- mvInp2Lo[!duplicated(mvInp2Lo[, -4]), -4]
      colnames(mInpSub)[4] <- 'slice'
      prec@parameters[['mInpSub']] <- addData(prec@parameters[['mInpSub']], mInpSub)
    }

    .interpolation_message('mvOut2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mvOut2Lo <- merge(getParameterData(prec@parameters[['mOut2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
    )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    mvOut2Lo <- merge(mvOut2Lo, mCommSlice2)
    colnames(mvOut2Lo)[colnames(mvOut2Lo) == 'slicep'] <- 'slice.1'
    mvOut2Lo <- mvOut2Lo[, c("comm", "region", "year", "slice", "slice.1")]
    
    prec@parameters[['mvOut2Lo']] <- addData(prec@parameters[['mvOut2Lo']], mvOut2Lo)
    
    .interpolation_message('mOutSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    if (!is.null(mvOut2Lo)) {
      mOutSub <- mvOut2Lo[!duplicated(mvOut2Lo[, -4]), -4]
      colnames(mOutSub)[4] <- 'slice'
      prec@parameters[['mOutSub']] <- addData(prec@parameters[['mOutSub']], mOutSub)
    }
    .interpolation_message('meqLECActivity', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    prec@parameters[['meqLECActivity']] <- addData(prec@parameters[['meqLECActivity']], 
      merge(getParameterData(prec@parameters[['mTechSpan']]), getParameterData(prec@parameters[['mLECRegion']])))
    .interpolation_message('pWeather', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    
    tmp_f0 <- function(x) {
      if (nrow(x) == 0) {
        x$value <- numeric()
        return (x)
      }
      x$value <- 1
      x
    }
    
    # Generate pWeather for all slice, including parent & child 
    pWeather <- getParameterData(prec@parameters$pWeather)
    if (nrow(pWeather) > 0) {
      pSliceShare <- getParameterData(prec@parameters$pSliceShare)
      colnames(pSliceShare)[ncol(pSliceShare)] <- 'share'
      mSliceCP <- getParameterData(prec@parameters$mSliceParentChild)
      colnames(mSliceCP) <- c('slicep', 'slice')
      .interpolation_message('pWeatherUp', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
      pWeatherUp <- merge(merge(pWeather, pSliceShare, by = 'slice'), mSliceCP, by = 'slice')
      pWeatherUp$slice <- pWeatherUp$slicep; pWeatherUp$slicep <- NULL 
      pWeatherUp <- aggregate(data.frame(tot = pWeatherUp$value * pWeatherUp$share, share = pWeatherUp$share), 
        pWeatherUp[, c('weather', 'region', 'year', 'slice')], sum)
      pWeatherUp$value <- pWeatherUp$tot / pWeatherUp$share
      pWeatherUp <- pWeatherUp[, c('weather', 'region', 'year', 'slice', 'value')]
      
      .interpolation_message('pWeatherLo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
      pWeatherLo <- merge(pWeather, getParameterData(prec@parameters$mSliceParentChild), by = 'slice')
      pWeatherLo$slice <- pWeatherLo$slicep;
      pWeatherLo <- pWeatherLo[, c('weather', 'region', 'year', 'slice', 'value')]
      pWeather <- rbind(pWeatherUp, pWeatherLo, pWeather)
      pWeather$mwth <- pWeather$value; pWeather$value <- NULL
    } else rest <- rest + 2
    
    towth <- data.frame(par = character(), base_map = character(), map_to = character(), stringsAsFactors = FALSE)
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfUp', 'meqTechAfUp', 'mTechWeatherAf')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfLo', 'meqTechAfLo', 'mTechWeatherAf')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfsLo', 'meqTechAfsLo', 'mTechWeatherAfs')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfsUp', 'meqTechAfsUp', 'mTechWeatherAfs')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfcLo', 'meqTechAfcOutLo', 'mTechWeatherAfc')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfcLo', 'meqTechAfcInpLo', 'mTechWeatherAfc')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfcUp', 'meqTechAfcOutUp', 'mTechWeatherAfc')
    towth[nrow(towth) + 1, ] <- c('paTechWeatherAfcUp', 'meqTechAfcInpUp', 'mTechWeatherAfc')

    towth[nrow(towth) + 1, ] <- c('paSupWeatherLo', 'meqSupAvaLo', 'mSupWeatherLo')
    towth[nrow(towth) + 1, ] <- c('paSupWeatherUp', 'mSupAvaUp', 'mSupWeatherUp')
    
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherAfLo', 'meqStorageAfLo', 'mStorageWeatherAf')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherAfUp', 'meqStorageAfUp', 'mStorageWeatherAf')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCinpLo', 'meqStorageInpLo', 'mStorageWeatherCinp')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCinpUp', 'meqStorageInpUp', 'mStorageWeatherCinp')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCoutLo', 'meqStorageOutLo', 'mStorageWeatherCout')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCoutUp', 'meqStorageOutUp', 'mStorageWeatherCout')
    
    for (i in seq_len(nrow(towth))) {
      .interpolation_message(towth[i, 3], rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
      rft <- getParameterData(prec@parameters[[towth[i, 'base_map']]])
      rdd <- getParameterData(prec@parameters[[towth[i, 'map_to']]])
      rft <- tmp_f0(rft)
      if (nrow(rft) > 0) {
        rft$value <- 1
        if (nrow(rdd) > 0) {
          tmp <- merge(rdd, pWeather); tmp$weather <- NULL
          tmp <- aggregate(tmp[, 'mwth', drop = FALSE], tmp[, -ncol(tmp), drop = FALSE], prod)
          tmp <- merge(rft, tmp, all = TRUE)
          tmp[is.na(tmp)] <- 1
          tmp$value <- tmp$value * tmp$mwth; tmp$mwth <- NULL
          prec@parameters[[towth[i, 'par']]] <- addData(prec@parameters[[towth[i, 'par']]], tmp)
        } else {
          prec@parameters[[towth[i, 'par']]] <- addData(prec@parameters[[towth[i, 'par']]], rft)
        }
      }
    }
    .interpolation_message('mvInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mvInpTot <- rbind(
      getParameterData(prec@parameters$mvDemInp),
      getParameterData(prec@parameters$mDummyExport),
      getParameterData(prec@parameters$mTechInpTot),
      getParameterData(prec@parameters$mStorageInpTot),
      getParameterData(prec@parameters$mExport),
      getParameterData(prec@parameters$mvTradeIrAInpTot),
      getParameterData(prec@parameters$mInpSub))
    mvInpTot <- mvInpTot[!duplicated(mvInpTot), ]
    mvInpTot <- merge(mvInpTot, mCommSlice)
    # prec@parameters[['mvInpTot']] <- addData(prec@parameters[['mvInpTot']], mvInpTot)
    .interpolation_message('mvOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mvOutTot <- rbind(
      getParameterData(prec@parameters$mDummyImport),
      getParameterData(prec@parameters$mSupOutTot),
      getParameterData(prec@parameters$mEmsFuelTot),
      getParameterData(prec@parameters$mAggOut),
      getParameterData(prec@parameters$mTechOutTot),
      getParameterData(prec@parameters$mStorageOutTot),
      getParameterData(prec@parameters$mImport),
      getParameterData(prec@parameters$mvTradeIrAOutTot),
      getParameterData(prec@parameters$mOutSub)
    )
    mvOutTot <- mvOutTot[!duplicated(mvOutTot), ]
    mvOutTot <- merge(mvOutTot, mCommSlice)
    # prec@parameters[['mvOutTot']] <- addData(prec@parameters[['mvOutTot']], mvOutTot)
    .interpolation_message('mvBalance', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    mvBalance <- rbind(mvInpTot, mvOutTot)
    mvBalance <- mvBalance[!duplicated(mvBalance), ]
    mvBalance <- merge(dregionyear, mCommSlice)
    prec@parameters[['mvBalance']] <- addData(prec@parameters[['mvBalance']], mvBalance)
    prec@parameters[['mvInpTot']] <- addData(prec@parameters[['mvInpTot']], mvBalance)
    prec@parameters[['mvOutTot']] <- addData(prec@parameters[['mvOutTot']], mvBalance)

    .interpolation_message('meqBalLo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['meqBalLo']] <- addData(prec@parameters[['meqBalLo']], 
                                             merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mLoComm']])))
    .interpolation_message('meqBalUp', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['meqBalUp']] <- addData(prec@parameters[['meqBalUp']], 
                                             merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mUpComm']])))
    .interpolation_message('meqBalFx', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    prec@parameters[['meqBalFx']] <- addData(prec@parameters[['meqBalFx']], 
                                             merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mFxComm']])))
    
    .interpolation_message('mAggregateFactor', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
    tmp <- getParameterData(prec@parameters[['pAggregateFactor']])
    tmp <- tmp[tmp$value != 0, ]
    if (nrow(tmp)) {
      tmp$value <- NULL
      colnames(tmp)[2] <- 'comm.1'
      prec@parameters[['mAggregateFactor']] <- addData(prec@parameters[['mAggregateFactor']], tmp)
    }
    cat(bacs, paste0(rep(' ', len_name), collapse = ''), bacs)
    prec
}

