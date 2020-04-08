.write_mapping <- function(prec, interpolation_time_begin) {
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]
  bacs <- paste0(rep('\b', 50), collapse = '')
  x = 1
  cat(paste0(rep(' ', 50), collapse = ''))
  update_time <- function(x) {
    xx <- paste0(' Mapping ', x, ' (64), time: ', round(proc.time()[3] - interpolation_time_begin, 2), 's')
    cat(paste0(bacs, xx, paste0(rep(' ', 50 - nchar(xx)), collapse = '')))
    (x + 1)
  }
  x = update_time(x)
  # Clean previous set data if any
  reduce.sect <- function(x, set) {
  	x <- x[, set, drop = FALSE]
  	x[!duplicated(x),, drop = FALSE]
  }
  x = update_time(x)
  region <- getParameterData(prec@parameters$region)
  x = update_time(x)
  year <- getParameterData(prec@parameters$mMidMilestone)
  x = update_time(x)
  # Total parameter ruductions
  mSliceParentChildE <- getParameterData(prec@parameters$mSliceParentChildE)
  x = update_time(x)
  mCommSlice <- getParameterData(prec@parameters$mCommSlice)
  x = update_time(x)
  uu <- mSliceParentChildE
  x = update_time(x)
  colnames(uu) <- c('slicep', 'slice')
  map_for_comm <- merge(mCommSlice, uu)[, c('comm', 'slicep')]
  x = update_time(x)
  colnames(map_for_comm) <- c('comm', 'slice')
  map_for_comm <- map_for_comm[!duplicated(map_for_comm), ]
  x = update_time(x)
  # mCommSliceOrParent
  l1 <- merge(getParameterData(prec@parameters$comm), getParameterData(prec@parameters$slice))
  x = update_time(x)
  l2 <-merge(mCommSlice, mSliceParentChildE)[, c('comm', 'slice', 'slicep')]
  x = update_time(x)
  l3 <- l2[!duplicated(l2[, c('comm', 'slicep')]), c('comm', 'slicep')]
  x = update_time(x)
  colnames(l3)[2] <- 'slice'
  x = update_time(x)
  l3 <- rbind(l1, l3)
  l3 <- l3[!duplicated(l3) & !duplicated(l3, fromLast=TRUE), ]
  l3$slicep <- l3$slice
  mCommSliceOrParent <- rbind(l2, l3)
  prec@parameters[['mCommSliceOrParent']] <- addData(prec@parameters[['mCommSliceOrParent']], mCommSliceOrParent)
  x = update_time(x)
  
  reduce_total_map <- function(yy) {
    yy$slicep <- yy$slice; yy$slice <- NULL
    reduce.duplicate(merge(yy, mCommSliceOrParent, by = c('comm', 'slicep'))[, -2])
  }
  prec@parameters[['mTechInpTot']] <- addData(prec@parameters[['mTechInpTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechInp)[, -1], getParameterData(prec@parameters$mvTechAInp)[, -1]))))
  x = update_time(x)
  # mTechOutTot(comm, region, year, slice)               Total technology output
  #    (mTechSlice(tech, slice) and mTechSpan(tech, region, year) 
  #    and (mTechOutComm(tech, comm) or mTechAOut(tech, comm))), 1))  
  prec@parameters[['mTechOutTot']] <- addData(prec@parameters[['mTechOutTot']], reduce_total_map(reduce.sect(
    rbind(getParameterData(prec@parameters$mvTechOut)[, -1], getParameterData(prec@parameters$mvTechAOut)[, -1]))))
  x = update_time(x)
  prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], reduce.sect(
    getParameterData(prec@parameters$mSupAva)[, -1]))
  x = update_time(x)
  prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
  	reduce.sect(merge(mCommSlice, getParameterData(prec@parameters$mDemComm), by = 'comm'), c('comm', 'slice')))
  x = update_time(x)
  
  
  #### This section have to move to add (after interpolate comm first)
  tmp0 <- getParameterData(prec@parameters$pTechEmisComm)
  tmp <- merge(getParameterData(prec@parameters$mTechInpComm), tmp0[tmp0$value != 0, ], by = c('tech', 'comm'))
  x = update_time(x)
  colnames(tmp)[colnames(tmp) == 'comm'] <- 'commp'
  tmp1 <- getParameterData(prec@parameters$pEmissionFactor)
  x = update_time(x)
  tmp1 <- tmp1[tmp1$value != 0, ]
  tmp1 <- tmp1[!duplicated(tmp1),, drop = FALSE]
  tmp <- merge(tmp1, tmp, by = 'commp')[, c('tech', 'comm', 'commp')]
  tmp <- tmp[!duplicated(tmp),, drop = FALSE]
  tmp <- merge(getParameterData(prec@parameters$mvTechAct), tmp, by = 'tech')[, c('tech', 'comm', 'commp', 'region', 'year', 'slice')]
  x = update_time(x)
  colnames(tmp)[3] <- 'comm.1'
  prec@parameters[['mTechEmsFuel']] <- addData(prec@parameters[['mTechEmsFuel']], tmp)
  x = update_time(x)
  
  # mEmsFuelTot(comm, region, year, slice)$(sum(tech$(mTechSpan(tech, region, year) and mTechSlice(tech, slice) and mTechEmitedComm(tech, comm)), 1))  
  prec@parameters[['mEmsFuelTot']] <- addData(prec@parameters[['mEmsFuelTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters[['mTechEmsFuel']]), c('comm', 'region', 'year', 'slice'))))
  x = update_time(x)
  no_inf <- function(x) {
    x = getParameterData(prec@parameters[[x]])
    x[x$value != Inf, -ncol(x)]
  }
  prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], no_inf('pDummyImportCost'))
  x = update_time(x)
  prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], no_inf('pDummyExportCost'))
  x = update_time(x)
  
  prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
  	reduce.sect(rbind(getParameterData(prec@parameters[['mDummyImport']]), 
  		getParameterData(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))
  x = update_time(x)
  
  # mvTradeIrAInpTot
  prec@parameters[['mvTradeIrAInpTot']] <- addData(prec@parameters[['mvTradeIrAInpTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters$mvTradeIrAInp), c('comm', 'region', 'year', 'slice'))))
  x = update_time(x)
  prec@parameters[['mvTradeIrAOutTot']] <- addData(prec@parameters[['mvTradeIrAOutTot']], reduce_total_map(
    reduce.sect(getParameterData(prec@parameters$mvTradeIrAOut), c('comm', 'region', 'year', 'slice'))))
  x = update_time(x)
  
    
    # sum(expp$mExportRow(expp, comm, region, year, slice), 1) + sum((trade, dst)$(mTradeIr(trade, region, dst, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    tmp <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'src', 'year', 'slice')]
    colnames(tmp)[2] <- 'region'
    x = update_time(x)
    prec@parameters[['mExport']] <- addData(prec@parameters[['mExport']], reduce_total_map(reduce.sect(rbind(tmp,
    		getParameterData(prec@parameters[['mExportRow']])[, c('comm', 'region', 'year', 'slice')]), 
    	c('comm', 'region', 'year', 'slice'))))
    x = update_time(x)
    # sum(expp$mImportRow(imp, comm, region, year, slice), 1) + sum((trade, src)$(mTradeIr(trade, src, region, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    zz <- merge(getParameterData(prec@parameters$mTradeComm), getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'dst', 'year', 'slice')]
    x = update_time(x)
    colnames(zz)[2] <- 'region'
    prec@parameters[['mImport']] <- addData(prec@parameters[['mImport']], reduce_total_map(reduce.sect(
    	rbind(zz, getParameterData(prec@parameters[['mImportRow']])[, c('comm', 'region', 'year', 'slice')]), 
    	c('comm', 'region', 'year', 'slice'))))
    x = update_time(x)
    
    prec@parameters[['mStorageInpTot']] <- addData(prec@parameters[['mStorageInpTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
    x = update_time(x)
    prec@parameters[['mStorageOutTot']] <- addData(prec@parameters[['mStorageOutTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
    x = update_time(x)
    
    # mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
    prec@parameters[['mTaxCost']] <- addData(prec@parameters[['mTaxCost']], reduce.sect(getParameterData(prec@parameters$pTaxCost), c('comm', 'region', 'year')))
    # mSubsCost(comm, region, year)  sum(slice$pSubsCost(comm, region, year, slice), 1)
    x = update_time(x)
    prec@parameters[['mSubsCost']] <- addData(prec@parameters[['mSubsCost']], reduce.sect(getParameterData(prec@parameters$pSubsCost), c('comm', 'region', 'year')))
    #    (sum(commp$pAggregateFactor(comm, commp), 1))
    x = update_time(x)
    if (nrow(getParameterData(prec@parameters$pAggregateFactor)) > 0) {
      prec@parameters[['mAggOut']] <- addData(prec@parameters[['mAggOut']], reduce_total_map(reduce.duplicate(
        merge(merge(merge(reduce.sect(getParameterData(prec@parameters$pAggregateFactor), 'comm'), getParameterData(prec@parameters$region)), 
                    year), getParameterData(prec@parameters$slice)))))
    }
    x = update_time(x)
    
    a1 <- mCommSlice; colnames(a1)[2] <- 'slicep'
    x = update_time(x)
    a2 <- getParameterData(prec@parameters$mSliceParentChild)
    x = update_time(x)
    for2Lo <- merge(a1, a2, by = 'slicep'); for2Lo$slicep <- NULL
    for2Lo <- reduce.duplicate(for2Lo)
    x = update_time(x)
    cll <- c('comm', 'region', 'year', 'slice')
    mOut2Lo <- merge(reduce.duplicate(rbind(merge(getParameterData(prec@parameters$mSupOutTot), 
                                                  getParameterData(prec@parameters$year))[, cll], 
          getParameterData(prec@parameters$mEmsFuelTot)[, cll], 
          getParameterData(prec@parameters$mAggOut)[, cll], 
          getParameterData(prec@parameters$mTechOutTot)[, cll], 
          getParameterData(prec@parameters$mStorageOutTot)[, cll], 
          getParameterData(prec@parameters$mImport)[, cll], 
          getParameterData(prec@parameters$mvTradeIrAOutTot)[, cll])), for2Lo, by =  c('comm', 'slice'))[, cll]
    x = update_time(x)
    mOut2Lo <- mOut2Lo[!(paste0(mOut2Lo$comm, '#', mOut2Lo$slice) %in% 
                           paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    x = update_time(x)
    prec@parameters[['mOut2Lo']] <- addData(prec@parameters[['mOut2Lo']], mOut2Lo)
    
    mInp2Lo <- merge(reduce.duplicate(rbind(getParameterData(prec@parameters$mTechInpTot)[, cll], 
                                            getParameterData(prec@parameters$mStorageInpTot)[, cll], 
                                            getParameterData(prec@parameters$mExport)[, cll], 
                                            getParameterData(prec@parameters$mvTradeIrAInpTot)[, cll])), 
                     for2Lo, by =  c('comm', 'slice'))[, cll]
    mInp2Lo <- mInp2Lo[!(paste0(mInp2Lo$comm, '#', mInp2Lo$slice) %in% paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    prec@parameters[['mInp2Lo']] <- addData(prec@parameters[['mInp2Lo']], mInp2Lo)
    x = update_time(x)
    
    ##
    dregionyear <- merge(region, year)
    prec@parameters[['mvTradeCost']] <- addData(prec@parameters[['mvTradeCost']], dregionyear)
    prec@parameters[['mvTradeRowCost']] <- addData(prec@parameters[['mvTradeRowCost']], dregionyear)
    prec@parameters[['mvTradeIrCost']] <- addData(prec@parameters[['mvTradeIrCost']], dregionyear)
    x = update_time(x)
    
    prec@parameters[['mvDemInp']] <- addData(prec@parameters[['mvDemInp']], 
      merge(dregionyear, getParameterData(prec@parameters[['mDemInp']]))[,c('comm', 'region', 'year', 'slice')])
    x = update_time(x)
    
    prec@parameters[['mvTotalCost']] <- addData(prec@parameters[['mvTotalCost']], dregionyear)
    x = update_time(x)
    
    prec@parameters[['mvBalance']] <- addData(prec@parameters[['mvBalance']], 
      merge(dregionyear, mCommSlice))
    x = update_time(x)
    
    mvInp2Lo <- merge(getParameterData(prec@parameters[['mInp2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
      )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    x = update_time(x)
    colnames(mvInp2Lo)[5] <- 'slice.1'
    prec@parameters[['mvInp2Lo']] <- addData(prec@parameters[['mvInp2Lo']], mvInp2Lo)
    
    mvOut2Lo <- merge(getParameterData(prec@parameters[['mOut2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
    )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    colnames(mvOut2Lo)[5] <- 'slice.1'
    x = update_time(x)
    prec@parameters[['mvOut2Lo']] <- addData(prec@parameters[['mvOut2Lo']], mvOut2Lo)
    x = update_time(x)
    
    prec@parameters[['meqBalLo']] <- addData(prec@parameters[['meqBalLo']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mLoComm']])))
    x = update_time(x)
    prec@parameters[['meqBalUp']] <- addData(prec@parameters[['meqBalUp']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mUpComm']])))
    x = update_time(x)
    prec@parameters[['meqBalFx']] <- addData(prec@parameters[['meqBalFx']], 
      merge(getParameterData(prec@parameters[['mvBalance']]), getParameterData(prec@parameters[['mFxComm']])))
    x = update_time(x)
    
    prec@parameters[['meqLECActivity']] <- addData(prec@parameters[['meqLECActivity']], 
      merge(getParameterData(prec@parameters[['mTechSpan']]), getParameterData(prec@parameters[['mLECRegion']])))
    x = update_time(x)
    
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
    x = update_time(x)
    if (nrow(pWeather) > 0) {
      pSliceShare <- getParameterData(prec@parameters$pSliceShare)
      colnames(pSliceShare)[ncol(pSliceShare)] <- 'share'
      x = update_time(x)
      mSliceCP <- getParameterData(prec@parameters$mSliceParentChild)
      colnames(mSliceCP) <- c('slicep', 'slice')
      x = update_time(x)
      pWeatherUp <- merge(merge(pWeather, pSliceShare, by = 'slice'), mSliceCP, by = 'slice')
      pWeatherUp$slice <- pWeatherUp$slicep; pWeatherUp$slicep <- NULL 
      x = update_time(x)
      pWeatherUp <- aggregate(data.frame(tot = pWeatherUp$value * pWeatherUp$share, share = pWeatherUp$share), 
        pWeatherUp[, c('weather', 'region', 'year', 'slice')], sum)
      x = update_time(x)
      pWeatherUp$value <- pWeatherUp$tot / pWeatherUp$share
      pWeatherUp <- pWeatherUp[, c('weather', 'region', 'year', 'slice', 'value')]
      
      x = update_time(x)
      pWeatherLo <- merge(pWeather, getParameterData(prec@parameters$mSliceParentChild), by = 'slice')
      pWeatherLo$slice <- pWeatherLo$slicep;
      pWeatherLo <- pWeatherLo[, c('weather', 'region', 'year', 'slice', 'value')]
      pWeather <- rbind(pWeatherUp, pWeatherLo, pWeather)
      x = update_time(x)
      pWeather$mwth <- pWeather$value; pWeather$value <- NULL
    } else x <- x + 6
    
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
      x = update_time(x)
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

    x = update_time(x)
    tmp <- getParameterData(prec@parameters[['pAggregateFactor']])
    tmp <- tmp[tmp$value != 0, ]
    if (nrow(tmp)) {
      tmp$value <- NULL
      colnames(tmp)[2] <- 'comm.1'
      prec@parameters[['mAggregateFactor']] <- addData(prec@parameters[['mAggregateFactor']], tmp)
    }
    x = update_time(x)
    cat(bacs, paste0(rep(' ', 50), collapse = ''), bacs)
    prec
}

