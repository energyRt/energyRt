# reduce_mapping

#  prec0 = prec
# .Object <- prec0;
#if (FALSE) {
# Add reduce mapping

#prec <- .Object

.reduce_mapping <- function(prec) {
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]
  str_msg <- ' wait a moment reduce mapping  0'
  cat(str_msg)
  # Clean previous set data if any
  cat('\b1')
  reduce.sect <- function(x, set) {
  	x <- x[, set, drop = FALSE]
  	x[!duplicated(x),, drop = FALSE]
  }
  # dregion <- data.frame(region = tmp_map$region, stringsAsFactors = FALSE)
  # dregionyear <- merge(dregion, tmp_map$mMidMilestone)
  
  # Total parameter ruductions
  mSliceParentChildE <- getParameterData(prec@parameters$mSliceParentChildE)
  mCommSlice <- getParameterData(prec@parameters$mCommSlice)
  uu <- mSliceParentChildE
  colnames(uu) <- c('slicep', 'slice')
  map_for_comm <- merge(mCommSlice, uu)[, c('comm', 'slicep')]
  colnames(map_for_comm) <- c('comm', 'slice')
  map_for_comm <- map_for_comm[!duplicated(map_for_comm), ]
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
  
  reduce_total_map <- function(yy) {
    yy$slicep <- yy$slice; yy$slice <- NULL
    reduce.duplicate(merge(yy, mCommSliceOrParent, by = c('comm', 'slicep'))[, -2])
  }
  prec@parameters[['mTechInpTot']] <- addData(prec@parameters[['mTechInpTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechInp)[, -1], getParameterData(prec@parameters$mvTechAInp)[, -1]))))
  # mTechOutTot(comm, region, year, slice)               Total technology output
  #    (mTechSlice(tech, slice) and mTechSpan(tech, region, year) 
  #    and (mTechOutComm(tech, comm) or mTechAOut(tech, comm))), 1))  
  prec@parameters[['mTechOutTot']] <- addData(prec@parameters[['mTechOutTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechOut)[, -1], getParameterData(prec@parameters$mvTechAOut)[, -1]))))
  # mSupOutTot(comm, region, slice)
  #   (sum(sup$(mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region)), 1))
  cat('\b2')
  prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], reduce_total_map(reduce.sect(
    getParameterData(prec@parameters$mSupAva)[, -1])))
  prec@parameters[['mvSupCost']] <- addData(prec@parameters[['mvSupCost']], reduce.sect(
    getParameterData(prec@parameters$mSupAva)[, c('sup', 'region', 'year')]))
  # mDemInp(comm, slice)
  #   (sum(dem$mDemComm(dem, comm), 1) and mCommSlice(comm, slice))    
  prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
  	reduce.sect(merge(mCommSlice, getParameterData(prec@parameters$mDemComm), by = 'comm'), c('comm', 'slice')))
  
  
  # mTechEmsFuel(tech, comm, region, year, slice)
  #  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and 
  #    (sum(commp$(mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and pEmissionFactor(comm, commp) <> 0), 1)), 1)) 
  #### This section have to move to add (after interpolate comm first)
  tmp0 <- getParameterData(prec@parameters$pTechEmisComm)
  tmp <- merge(getParameterData(prec@parameters$mTechInpComm), tmp0[tmp0$value != 0, ], by = c('tech', 'comm'))
  colnames(tmp)[colnames(tmp) == 'comm'] <- 'commp'
  tmp1 <- getParameterData(prec@parameters$pEmissionFactor)
  tmp <- merge(tmp1[tmp1$value != 0, ], tmp, by = 'commp')[, c('tech', 'comm', 'commp')]
  tmp <- tmp[!duplicated(tmp),, drop = FALSE]
  tmp <- merge(getParameterData(prec@parameters$mvTechAct), tmp, by = 'tech')[, c('tech', 'comm', 'commp', 'region', 'year', 'slice')]
  colnames(tmp)[3] <- 'comm.1'
  prec@parameters[['mTechEmsFuel']] <- addData(prec@parameters[['mTechEmsFuel']], tmp)
  
  cat('\b3')
  # mEmsFuelTot(comm, region, year, slice)$(sum(tech$(mTechSpan(tech, region, year) and mTechSlice(tech, slice) and mTechEmitedComm(tech, comm)), 1))  
  prec@parameters[['mEmsFuelTot']] <- addData(prec@parameters[['mEmsFuelTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters[['mTechEmsFuel']]), c('comm', 'region', 'year', 'slice'))))
  # mDummyImport(comm, region, year, slice)
  #    (mCommSlice(comm, slice) and pDummyImportCost(comm, region, year, slice) <> Inf)    
  no_inf <- function(x) {
    x = getParameterData(prec@parameters[[x]])
    x[x$value != 0, -ncol(x)]
  }
  prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], no_inf('pDummyImportCost'))
  # mDummyExport(comm, region, year, slice)
  #    (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)    
  prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], no_inf('pDummyExportCost'))
  
  # mDummyCost(comm, region, year)
  #    (pDummyImportCost(comm, region, year, slice) <> Inf or pDummyExportCost(comm, region, year, slice) <> Inf)   
  prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
  	reduce.sect(rbind(getParameterData(prec@parameters[['mDummyImport']]), 
  		getParameterData(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))
  # mTradeIr(trade, region, region, year, slice)         Total physical trade flows between regions
  # mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and
  #    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
  cat('\b4')
  
  cat('\b5')
  # mvTradeIrAInpTot
  prec@parameters[['mvTradeIrAInpTot']] <- addData(prec@parameters[['mvTradeIrAInpTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters$mvTradeIrAInp), c('comm', 'region', 'year', 'slice'))))
    
    
    cat('\b6')
    # sum(expp$mExportRow(expp, comm, region, year, slice), 1) + sum((trade, dst)$(mTradeIr(trade, region, dst, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    tmp <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'src', 'year', 'slice')]
    colnames(tmp)[2] <- 'region'
    prec@parameters[['mExport']] <- addData(prec@parameters[['mExport']], reduce_total_map(reduce.sect(rbind(tmp,
    		getParameterData(prec@parameters[['mExportRow']])[, c('comm', 'region', 'year', 'slice')]), 
    	c('comm', 'region', 'year', 'slice'))))
    # sum(expp$mImportRow(imp, comm, region, year, slice), 1) + sum((trade, src)$(mTradeIr(trade, src, region, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    zz <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'dst', 'year', 'slice')]
    colnames(zz)[2] <- 'region'
    prec@parameters[['mImport']] <- addData(prec@parameters[['mImport']], reduce_total_map(reduce.sect(
    	rbind(zz, getParameterData(prec@parameters[['mImportRow']])[, c('comm', 'region', 'year', 'slice')]), 
    	c('comm', 'region', 'year', 'slice'))))
    cat('\b7')
    
    
    # mStorageInpTot(comm, region, year, slice)
    #     (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAInp(stg, comm)))

    #######    have to dooo
    # prec@parameters[['mStorageInpTot']] <- addData(prec@parameters[['mStorageInpTot']], reduce_total_map(
    # 	reduce.sect(merge(tmp_map$mStorageSpan, merge(merge(tmp_map$mCommSlice, tmp_map$mStorageComm, by = 'comm'),
    # 		rbind(tmp_map$mStorageComm, tmp_map$mStorageAInp))), c('comm', 'region', 'year', 'slice'))))
    # # mStorageOutTot(comm, region, year, slice)
    # #     (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAOut(stg, comm)))
    # prec@parameters[['mStorageOutTot']] <- addData(prec@parameters[['mStorageOutTot']], reduce_total_map(
    # 	reduce.sect(merge(tmp_map$mStorageSpan, merge(merge(tmp_map$mCommSlice, tmp_map$mStorageComm, by = 'comm'),
    # 		rbind(tmp_map$mStorageComm, tmp_map$mStorageAOut))), c('comm', 'region', 'year', 'slice'))))
    # prec@parameters[['mStorageOlifeInf']] <- addData(prec@parameters[['mStorageOlifeInf']], generate_haveval('pStorageOlife', Inf))
    # mStorageOMCost(stg, region, year) 
    # mStorageOMCost <- rbind(tmp_nozero$pStorageFixom, tmp_nozero$pStorageCostInp[, c('stg', 'region', 'year')], 
    #                         tmp_nozero$pStorageCostOut[, c('stg', 'region', 'year')], tmp_nozero$pStorageCostStore[, c('stg', 'region', 'year')])
    # mStorageOMCost <- merge(mStorageOMCost[!duplicated(mStorageOMCost), ], tmp_map$mStorageSpan)
    # prec@parameters[['mStorageOMCost']] <- addData(prec@parameters[['mStorageOMCost']], mStorageOMCost)
    
browser()    
      # mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
    prec@parameters[['mTaxCost']] <- addData(prec@parameters[['mTaxCost']], reduce.sect(getParameterData(prec@parameters$pTaxCost), c('comm', 'region', 'year')))
    # mSubsCost(comm, region, year)  sum(slice$pSubsCost(comm, region, year, slice), 1)
    prec@parameters[['mSubsCost']] <- addData(prec@parameters[['mSubsCost']], reduce.sect(getParameterData(prec@parameters$pSubsCost), c('comm', 'region', 'year')))
    #    (sum(commp$pAggregateFactor(comm, commp), 1))
    if (nrow(getParameterData(prec@parameters$pAggregateFactor)) > 0)
      prec@parameters[['mAggOut']] <- addData(prec@parameters[['mAggOut']], reduce_total_map(reduce.duplicate(
        merge(merge(merge(reduce.sect(getParameterData(prec@parameters$pAggregateFactor), 'comm'), getParameterData(prec@parameters$region)), 
                    getParameterData(prec@parameters$year)), getParameterData(prec@parameters$slice)))))
    
    
    cat('\b8')
    
    
    #sum(slicep$(mSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)), 1) and
    #(mSupOutTot(comm, region, slice) or mEmsFuelTot(comm, region, year, slice) or mAggOut(comm, region, year, slice) or
    #  mTechOutTot(comm, region, year, slice) or mStorageOutTot(comm, region, year, slice) or mImport(comm, region, year, slice) or
    #  mvTradeIrAOutTot(comm, region, year, slice))
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
    
    cat('\b9')
    # sum(slicep$(mSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0
    #   and (mTechInpTot(comm, region, year, slice) or  mStorageInpTot(comm, region, year, slice) or
    #   or mExport(comm, region, year, slice) or mvTradeIrAInpTot(comm, region, year, slice))
    
    mInp2Lo <- merge(reduce.duplicate(rbind(getParameterData(prec@parameters$mTechInpTot)[, cll], 
                                            getParameterData(prec@parameters$mStorageInpTot)[, cll], 
                                            getParameterData(prec@parameters$mExport)[, cll], 
                                            getParameterData(prec@parameters$mvTradeIrAInpTot)[, cll])), 
                     for2Lo, by =  c('comm', 'slice'))[, cll]
    mInp2Lo <- mInp2Lo[!(paste0(mInp2Lo$comm, '#', mInp2Lo$slice) %in% paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    prec@parameters[['mInp2Lo']] <- addData(prec@parameters[['mInp2Lo']], mInp2Lo)
    
    browser()
    ##
    # mTechOMCost(tech, region, year) 
    mTechOMCost <- rbind(tmp_nozero$pTechFixom, tmp_nozero$pTechVarom[, c('tech', 'region', 'year')], 
      tmp_nozero$pTechCvarom[, c('tech', 'region', 'year')], tmp_nozero$pTechAvarom[, c('tech', 'region', 'year')])
    mTechOMCost <- merge(mTechOMCost[!duplicated(mTechOMCost), ], tmp_map$mTechSpan)
    prec@parameters[['mTechOMCost']] <- addData(prec@parameters[['mTechOMCost']], mTechOMCost)

    
        
    prec@parameters[['mvSupReserve']] <- addData(prec@parameters[['mvSupReserve']], 
      merge(tmp_map$mSupComm, tmp_map$mSupSpan, by = 'sup')[, c('sup', 'comm', 'region')])

    cat('\b\b10')
    
    prec@parameters[['mvDemInp']] <- addData(prec@parameters[['mvDemInp']], 
      merge(dregionyear, getParameterData(prec@parameters[['mDemInp']]))[,c('comm', 'region', 'year', 'slice')])

    prec@parameters[['mvTotalCost']] <- addData(prec@parameters[['mvTotalCost']], dregionyear)
    
    cat('\b\b11')
    prec@parameters[['mvBalance']] <- addData(prec@parameters[['mvBalance']], 
      merge(merge(tmp_map$mMidMilestone, dregion), getParameterData(prec@parameters[['mCommSlice']])
      )[,c('comm', 'region', 'year', 'slice')])
    
    mvInp2Lo <- merge(getParameterData(prec@parameters[['mInp2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
      )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    colnames(mvInp2Lo)[5] <- 'slice.1'
    prec@parameters[['mvInp2Lo']] <- addData(prec@parameters[['mvInp2Lo']], mvInp2Lo)
    
    mvOut2Lo <- merge(getParameterData(prec@parameters[['mvOut2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
    )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    colnames(mvOut2Lo)[5] <- 'slice.1'
    prec@parameters[['mvOut2Lo']] <- addData(prec@parameters[['mvOut2Lo']], mvOut2Lo)

    prec@parameters[['mvStorageStore']] <- addData(prec@parameters[['mvStorageStore']], 
      merge(tmp_map$mStorageSpan, merge(merge(tmp_map$mCommSlice, tmp_map$mStorageComm, by = 'comm'),
        tmp_map$mStorageComm))[, c('stg', 'comm', 'region', 'year', 'slice')])
    
    prec@parameters[['mvStorageAInp']] <- addData(prec@parameters[['mvStorageAInp']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']])[, -2], 
      getParameterData(prec@parameters[['mStorageAInp']]))[,c('stg', 'comm', 'region', 'year', 'slice')])

    prec@parameters[['mvStorageAOut']] <- addData(prec@parameters[['mvStorageAOut']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']])[, -2], 
        getParameterData(prec@parameters[['mStorageAOut']]))[,c('stg', 'comm', 'region', 'year', 'slice')])
    
    prec@parameters[['mvTradeIr']] <- addData(prec@parameters[['mvTradeIr']], 
      merge(getParameterData(prec@parameters[['mTradeIr']]), 
        getParameterData(prec@parameters[['mTradeComm']]))[,c('trade', 'comm', 'src', 'dst', 'year', 'slice')])
    
    dregionyear <- merge(dregion, tmp_map$mMidMilestone)
    prec@parameters[['mvTradeCost']] <- addData(prec@parameters[['mvTradeCost']], dregionyear)
    prec@parameters[['mvTradeRowCost']] <- addData(prec@parameters[['mvTradeRowCost']], dregionyear)
    prec@parameters[['mvTradeIrCost']] <- addData(prec@parameters[['mvTradeIrCost']], dregionyear)

    prec@parameters[['mvTradeCap']] <- addData(prec@parameters[['mvTradeCap']], 
      merge(getParameterData(prec@parameters[['mTradeCapacityVariable']]), 
        getParameterData(prec@parameters[['mTradeSpan']])))
    
    cat('\b\b12')
    prec@parameters[['mvTradeNewCap']] <- addData(prec@parameters[['mvTradeNewCap']], 
      merge(getParameterData(prec@parameters[['mTradeCapacityVariable']]), 
        getParameterData(prec@parameters[['mTradeNew']])))
    
    # **** me
    
    cat('\b\b13')
     
    tmp_func1 <- function(x) {
      x <- generate_allval(x, type = 'lo');
      x[x$value > 0, colnames(x) != 'value']
    }
    tmp_func2 <- function(x) {
      x <- generate_allval(x, type = 'up');
      x[x$value < 1, colnames(x) != 'value']
    }    
    cat('\b\b14')
    cat('\b\b15')

    

    prec@parameters[['meqStorageAfLo']] <- addData(prec@parameters[['meqStorageAfLo']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func1('pStorageAf')))
    prec@parameters[['meqStorageAfUp']] <- addData(prec@parameters[['meqStorageAfUp']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func2('pStorageAf')))
    
    prec@parameters[['meqStorageInpLo']] <- addData(prec@parameters[['meqStorageInpLo']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func1('pStorageCinp')))
    prec@parameters[['meqStorageInpUp']] <- addData(prec@parameters[['meqStorageInpUp']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func2('pStorageCinp')))
    
    prec@parameters[['meqStorageOutLo']] <- addData(prec@parameters[['meqStorageOutLo']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func1('pStorageCout')))
    prec@parameters[['meqStorageOutUp']] <- addData(prec@parameters[['meqStorageOutUp']], 
      merge(getParameterData(prec@parameters[['mvStorageStore']]), 
        tmp_func2('pStorageCout')))
    
    cat('\b\b16')
    prec@parameters[['meqTradeFlowLo']] <- addData(prec@parameters[['meqTradeFlowLo']], 
      merge(getParameterData(prec@parameters[['mvTradeIr']]), 
        tmp_func1('pTradeIr')))
    prec@parameters[['meqTradeFlowUp']] <- addData(prec@parameters[['meqTradeFlowUp']], 
      merge(getParameterData(prec@parameters[['mvTradeIr']]), 
        tmp_func2('pTradeIr')))
    
    prec@parameters[['meqExportRowLo']] <- addData(prec@parameters[['meqExportRowLo']], 
      merge(getParameterData(prec@parameters[['mExportRow']]), 
        tmp_func1('pExportRow')))
    prec@parameters[['meqImportRowLo']] <- addData(prec@parameters[['meqImportRowLo']], 
      merge(getParameterData(prec@parameters[['mImportRow']]), 
        tmp_func1('pImportRow')))
    
    prec@parameters[['meqTradeCapFlow']] <- addData(prec@parameters[['meqTradeCapFlow']], 
      merge(merge(getParameterData(prec@parameters[['mTradeComm']]), 
        getParameterData(prec@parameters[['mvTradeCap']])), getParameterData(prec@parameters[['mTradeSlice']])))
    
    prec@parameters[['meqBalLo']] <- addData(prec@parameters[['meqBalLo']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mLoComm']])))
    prec@parameters[['meqBalUp']] <- addData(prec@parameters[['meqBalUp']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mUpComm']])))
    prec@parameters[['meqBalFx']] <- addData(prec@parameters[['meqBalFx']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mFxComm']])))
    
    prec@parameters[['meqLECActivity']] <- addData(prec@parameters[['meqLECActivity']], 
      merge(getParameterData(prec@parameters[['mTechSpan']]), getParameterData(prec@parameters[['mLECRegion']])))

    tmp_f0 <- function(x) {
      if (nrow(x) == 0) {
        x$value <- numeric()
        return (x)
      }
      x$value <- 1
      x
    }
    
    # Generate pWeather for all slice, including parent & child 
    cat('\b\b17')
    pWeather <- generate_allval('pWeather')
    if (nrow(pWeather) > 0) {
      pSliceShare <- generate_allval('pSliceShare')
      colnames(pSliceShare)[ncol(pSliceShare)] <- 'share'
      mSliceCP <- getParameterData(prec@parameters$mSliceParentChild)
      colnames(mSliceCP) <- c('slicep', 'slice')
      pWeatherUp <- merge(merge(pWeather, pSliceShare, by = 'slice'), mSliceCP, by = 'slice')
      pWeatherUp$slice <- pWeatherUp$slicep; pWeatherUp$slicep <- NULL 
      pWeatherUp <- aggregate(data.frame(tot = pWeatherUp$value * pWeatherUp$share, share = pWeatherUp$share), 
        pWeatherUp[, c('weather', 'region', 'year', 'slice')], sum)
      pWeatherUp$value <- pWeatherUp$tot / pWeatherUp$share
      pWeatherUp <- pWeatherUp[, c('weather', 'region', 'year', 'slice', 'value')]
      
      pWeatherLo <- merge(pWeather, getParameterData(prec@parameters$mSliceParentChild), by = 'slice')
      pWeatherLo$slice <- pWeatherLo$slicep;
      pWeatherLo <- pWeatherLo[, c('weather', 'region', 'year', 'slice', 'value')]
      pWeather <- rbind(pWeatherUp, pWeatherLo, pWeather)
      pWeather$mwth <- pWeather$value; pWeather$value <- NULL
    }
    
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
    
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherAfLo', 'mStorageWeatherAf', 'meqStorageAfLo')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherAfUp', 'mStorageWeatherAf', 'meqStorageAfUp')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCinpLo', 'mStorageWeatherCinp', 'meqStorageInpLo')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCinpUp', 'mStorageWeatherCinp', 'meqStorageInpUp')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCoutLo', 'mStorageWeatherCout', 'meqStorageOutLo')
    towth[nrow(towth) + 1, ] <- c('paStorageWeatherCoutUp', 'mStorageWeatherCout', 'meqStorageOutUp')
    
    for (i in seq_len(nrow(towth))) {
      rft <- getParameterData(prec@parameters[[towth[i, 'base_map']]])
      rdd <- getParameterData(prec@parameters[[towth[i, 'map_to']]])
      if (nrow(rft) > 0) {
        rft <- tmp_f0(rft)
        if (nrow(rdd) > 0) {
          tmp <- merge(rdd, pWeather); tmp$weather <- NULL
          tmp <- aggregate(tmp[, 'mwth', drop = FALSE], tmp[, -ncol(tmp), drop = FALSE], prod)
          tmp <- merge(rft, tmp, all.x = TRUE)
          tmp$value <- tmp$value * tmp$mwth; tmp$mwth <- NULL
          prec@parameters[[towth[i, 'par']]] <- addData(prec@parameters[[towth[i, 'par']]], tmp)
        } else {
          prec@parameters[[towth[i, 'par']]] <- addData(prec@parameters[[towth[i, 'par']]], rft)
        }
      }
    }

    cat('\b\b18')
    tmp <- getParameterData(prec@parameters[['pAggregateFactor']])
    tmp <- tmp[tmp$value != 0, ]
    if (nrow(tmp)) {
      tmp$value <- NULL
      colnames(tmp)[2] <- 'comm.1'
      prec@parameters[['mAggregateFactor']] <- addData(prec@parameters[['mAggregateFactor']], tmp)
    }
    cat(paste0(rep('\b', nchar(str_msg)), collapse = ''), paste0(rep(' ', nchar(str_msg)), collapse = ''),
        paste0(rep('\b', nchar(str_msg)), collapse = ''), sep = '')
    
    prec
}

