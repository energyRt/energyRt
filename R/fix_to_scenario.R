.fix_to_scenario <- function(scen, src, startYear) {
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
}