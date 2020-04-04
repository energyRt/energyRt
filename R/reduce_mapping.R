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
  region <- getParameterData(prec@parameters$region)
  year <- getParameterData(prec@parameters$mMidMilestone)
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
  cat('\b2')
  prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], reduce.sect(
    getParameterData(prec@parameters$mSupAva)[, -1]))
  prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
  	reduce.sect(merge(mCommSlice, getParameterData(prec@parameters$mDemComm), by = 'comm'), c('comm', 'slice')))
  
  
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
  no_inf <- function(x) {
    x = getParameterData(prec@parameters[[x]])
    x[x$value != Inf, -ncol(x)]
  }
  prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], no_inf('pDummyImportCost'))
  prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], no_inf('pDummyExportCost'))
  
  prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
  	reduce.sect(rbind(getParameterData(prec@parameters[['mDummyImport']]), 
  		getParameterData(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))

    cat('\b3')
  # mvTradeIrAInpTot
  prec@parameters[['mvTradeIrAInpTot']] <- addData(prec@parameters[['mvTradeIrAInpTot']], reduce_total_map(
  	reduce.sect(getParameterData(prec@parameters$mvTradeIrAInp), c('comm', 'region', 'year', 'slice'))))
    
    
    cat('\b4')
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
    cat('\b5')
    
    prec@parameters[['mStorageInpTot']] <- addData(prec@parameters[['mStorageInpTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
    prec@parameters[['mStorageOutTot']] <- addData(prec@parameters[['mStorageOutTot']], 
      reduce.sect(rbind(getParameterData(prec@parameters$mvStorageAInp)[, -1], getParameterData(prec@parameters$mvStorageStore)[, -1])))
      
    # mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
    prec@parameters[['mTaxCost']] <- addData(prec@parameters[['mTaxCost']], reduce.sect(getParameterData(prec@parameters$pTaxCost), c('comm', 'region', 'year')))
    # mSubsCost(comm, region, year)  sum(slice$pSubsCost(comm, region, year, slice), 1)
    prec@parameters[['mSubsCost']] <- addData(prec@parameters[['mSubsCost']], reduce.sect(getParameterData(prec@parameters$pSubsCost), c('comm', 'region', 'year')))
    #    (sum(commp$pAggregateFactor(comm, commp), 1))
    if (nrow(getParameterData(prec@parameters$pAggregateFactor)) > 0) {
      prec@parameters[['mAggOut']] <- addData(prec@parameters[['mAggOut']], reduce_total_map(reduce.duplicate(
        merge(merge(merge(reduce.sect(getParameterData(prec@parameters$pAggregateFactor), 'comm'), getParameterData(prec@parameters$region)), 
                    year), getParameterData(prec@parameters$slice)))))
    }
    
    
    cat('\b8')
    
    
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
    
    mInp2Lo <- merge(reduce.duplicate(rbind(getParameterData(prec@parameters$mTechInpTot)[, cll], 
                                            getParameterData(prec@parameters$mStorageInpTot)[, cll], 
                                            getParameterData(prec@parameters$mExport)[, cll], 
                                            getParameterData(prec@parameters$mvTradeIrAInpTot)[, cll])), 
                     for2Lo, by =  c('comm', 'slice'))[, cll]
    mInp2Lo <- mInp2Lo[!(paste0(mInp2Lo$comm, '#', mInp2Lo$slice) %in% paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
    prec@parameters[['mInp2Lo']] <- addData(prec@parameters[['mInp2Lo']], mInp2Lo)
    
    ##
    dregionyear <- merge(region, year)
    prec@parameters[['mvTradeCost']] <- addData(prec@parameters[['mvTradeCost']], dregionyear)
    prec@parameters[['mvTradeRowCost']] <- addData(prec@parameters[['mvTradeRowCost']], dregionyear)
    prec@parameters[['mvTradeIrCost']] <- addData(prec@parameters[['mvTradeIrCost']], dregionyear)
    
    cat('\b\b10')
    prec@parameters[['mvDemInp']] <- addData(prec@parameters[['mvDemInp']], 
      merge(dregionyear, getParameterData(prec@parameters[['mDemInp']]))[,c('comm', 'region', 'year', 'slice')])

    prec@parameters[['mvTotalCost']] <- addData(prec@parameters[['mvTotalCost']], dregionyear)
    
    cat('\b\b11')
    prec@parameters[['mvBalance']] <- addData(prec@parameters[['mvBalance']], 
      merge(dregionyear, mCommSlice))
    
    mvInp2Lo <- merge(getParameterData(prec@parameters[['mInp2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
      )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    colnames(mvInp2Lo)[5] <- 'slice.1'
    prec@parameters[['mvInp2Lo']] <- addData(prec@parameters[['mvInp2Lo']], mvInp2Lo)
    
    mvOut2Lo <- merge(getParameterData(prec@parameters[['mvOut2Lo']]), getParameterData(prec@parameters[['mSliceParentChild']])
    )[,c('comm', 'region', 'year', 'slice', 'slicep')]
    colnames(mvOut2Lo)[5] <- 'slice.1'
    prec@parameters[['mvOut2Lo']] <- addData(prec@parameters[['mvOut2Lo']], mvOut2Lo)

   
    
    # **** me

     
    cat('\b\b16')
    
    
     
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
    pWeather <- getParameterData(prec@parameters$pWeather)
    if (nrow(pWeather) > 0) {
      pSliceShare <- getParameterData(prec@parameters$pSliceShare)
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

