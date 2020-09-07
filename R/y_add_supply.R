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
    tmp <- pSupAva[pSupAva$value == 0 & pSupAva$type == 'up', colnames(pSupAva) != 'value', drop = FALSE]
    mSupAva <- merge(merge(mSupSpan, list(comm = sup@commodity, year = approxim$mileStoneYears)), mSupSlice)
    if (!is.null(tmp) && nrow(tmp) != 0) {
      if (all(colnames(mSupAva) %in% colnames(tmp))) {
        mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, tmp[, colnames(mSupAva)]), fromLast = TRUE))[1:nrow(mSupAva)], ]
      } else {
        mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, merge(mSupAva, tmp[, colnames(tmp) %in% colnames(mSupAva), drop = FALSE])[, colnames(mSupAva)]
          ), fromLast = TRUE))[1:nrow(mSupAva)], ]
      }
    }
    obj@parameters[['mSupAva']] <- addData(obj@parameters[['mSupAva']], mSupAva)

    obj@parameters[['mSupReserveUp']] <- addData(obj@parameters[['mSupReserveUp']], 
        pSupReserve[pSupReserve$type == 'up' & pSupReserve$value != Inf, c('sup', 'comm', 'region')])
    obj@parameters[['meqSupReserveLo']] <- addData(obj@parameters[['meqSupReserveLo']], 
                                                   pSupReserve[pSupReserve$type == 'lo' & pSupReserve$value != 0, c('sup', 'comm', 'region')])
    obj@parameters[['meqSupAvaLo']] <- addData(obj@parameters[['meqSupAvaLo']], 
                                               merge(mSupAva, pSupAva[pSupAva$type == 'lo' & pSupAva$value != 0, colnames(pSupAva) %in% colnames(mSupAva)]))
    obj@parameters[['mSupAvaUp']] <- addData(obj@parameters[['mSupAvaUp']], 
                                             merge(mSupAva, pSupAva[pSupAva$type == 'up' & pSupAva$value != Inf, colnames(pSupAva) %in% colnames(mSupAva)]))
    
    obj@parameters[['mvSupReserve']] <- addData(obj@parameters[['mvSupReserve']], merge(mSupComm, mSupSpan))
    # For weather
    # mSupWeatherLo(sup, weather)
    wth.lo <- unique(sup@weather[!is.na(sup@weather$wava.lo) | !is.na(sup@weather$wava.fx), 'weather'])
    obj@parameters[['mSupWeatherLo']] <- addData(obj@parameters[['mSupWeatherLo']],
                                            data.frame(sup = rep(sup@name, length(wth.lo)), weather = wth.lo))
    # mSupWeatherUp(sup, weather)
    wth.up <- unique(sup@weather[!is.na(sup@weather$wava.up) | !is.na(sup@weather$wava.fx), 'weather'])
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
    t2 <- pSupCost[pSupCost$value != 0, colnames(pSupCost)[colnames(pSupCost) %in% c('sup', 'region', 'year')], drop = FALSE]; t2 <- t2[!duplicated(t2),, drop = FALSE]
    if (!is.null(t2) && ncol(t2) != 3) {
      t2 <- merge(t2, mSupAva[!duplicated(mSupAva[, c('sup', 'region', 'year')]), c('sup', 'region', 'year')])
    }
    mvSupCost <- merge(t1, t2)
    mvSupCost <- mvSupCost[!duplicated(mvSupCost), ]
    obj@parameters[['mvSupCost']] <- addData(obj@parameters[['mvSupCost']], mvSupCost)
  obj
})
