.fix_to_scenario <- function(scen, src, startYear) {
	scen = BAU; src = BAU; startYear = 2020
  # up to year
  # assign('prec.before.startYear', scen@modInp, globalenv()) # prec = prec.before.startYear
  # begin
  mile.stone <- scen@modInp@parameters$mMidMilestone@data$year
  mile.stone.after <- mile.stone[mile.stone >= startYear] 
  stay.year.begin <- min(scen@modInp@parameters$mStartMilestone@data[
    scen@modInp@parameters$mStartMilestone@data$year %in% mile.stone.after, 'yearp'], na.rm = TRUE)
  stay.year.end <- max(scen@modInp@parameters$mEndMilestone@data[
    scen@modInp@parameters$mEndMilestone@data$year %in% mile.stone.after, 'yearp'], na.rm = TRUE)
  
  mile.stone.length <- (scen@modInp@parameters$mEndMilestone@data$yearp - scen@modInp@parameters$mStartMilestone@data$yearp + 1)
  names(mile.stone.length) <- scen@modInp@parameters$mEndMilestone@data$year
  
  # Move new capacity before startYear to to stock (technology)
  if (length(scen@modInp@set$tech) > 0) {
	  tech.new.cap <- src@modOut@variables$vTechNewCap
	  tech.stock <- energyRt:::.getTotalParameterData(scen@modInp, 'pTechStock')
	  tech.new.cap <- tech.new.cap[tech.new.cap$year <= startYear,, drop = FALSE]
	  tech.life <- energyRt:::.getTotalParameterData(scen@modInp, 'pTechOlife')
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
	  scen@modInp <- energyRt:::.setParameterData(scen@modInp, 'pTechStock', tech.stock2)
  }
  # Move new capacity before startYear to to stock (technology)
  if (length(scen@modInp@set$stg) > 0) {
	  stg.new.cap <- src@modOut@variables$vStorageNewCap
	  stg.stock <- energyRt:::.getTotalParameterData(scen@modInp, 'pStorageStock')
	  stg.new.cap <- stg.new.cap[stg.new.cap$year <= startYear,, drop = FALSE]
	  stg.life <- energyRt:::.getTotalParameterData(scen@modInp, 'pStorageOlife')
	  olife.tmp <- stg.life$value
	  names(olife.tmp) <- paste0(stg.life$stg, '#', stg.life$region)
	  stg.new.cap$olife <- olife.tmp[paste0(stg.new.cap$stg, '#', stg.new.cap$region)]
	  # add 
	  for (yr in mile.stone.after) {
	  	fl_use <- (yr < stg.new.cap$olife + stg.new.cap$year)
	  	if (any(fl_use)) {
	  		tmp <- stg.new.cap[fl_use, c('stg', 'region', 'year', 'value')]
	  		tmp$year <- yr
	  		stg.stock <- rbind(stg.stock, tmp)
	  	} 
	  }
	  fl <-  stg.stock$year >= startYear
	  stg.stock2 <- aggregate(stg.stock[fl, 'value', drop = FALSE], stg.stock[fl, c('stg', 'region', 'year')], sum)
	  # have to replace stg.stock2 -> pStorageStock
	  scen@modInp <- energyRt:::.setParameterData(scen@modInp, 'pStorageStock', stg.stock2)
  }
  if (length(scen@modInp@set$sup) > 0) {
	  # Chage supply reserve startYear (remove use in base period)
	  sup.res.use0 <- src@modOut@variables$vSupOut
	  sup.res.use0 <- sup.res.use0[sup.res.use0$year < startYear, ]
	  sup.res.use0 <- aggregate(sup.res.use0[, 'value', drop = FALSE] * mile.stone.length[as.character(sup.res.use0$year)], 
	  													sup.res.use0[, c('sup', 'comm', 'region')], sum)
	  sup.res.use0$type <- 'lo'
	  sup.res.use0$value <- (-sup.res.use0$value)
	  sup.res.use0 <- sup.res.use0[, c("sup", "comm", "region", 'type', 'value')]
	  sup.res.par <- energyRt:::.getTotalParameterData(scen@modInp, 'pSupReserve')
	  sup.res.par <- rbind(sup.res.par, sup.res.use0)
	  sup.res.use0$type <- 'up'
	  sup.res.par <- rbind(sup.res.par, sup.res.use0)
	  sup.res.par <- aggregate(sup.res.par[, 'value', drop = FALSE], sup.res.par[, -ncol(sup.res.par)], sum) 
	  sup.res.par <- sup.res.par[!(sup.res.par$type == 'lo' & sup.res.par$value <= 0), ]
	  sup.res.par[sup.res.par$value < 0, 'value'] <- 0
	  scen@modInp <- energyRt:::.setParameterData(scen@modInp, 'pSupReserve', sup.res.par)
  }
  # Remove all data after start year
  als_year <- c('year', 'yearn', 'yearp', 'yeare')
  for (nn in names(scen@modInp@parameters)) {
    if (any(scen@modInp@parameters[[nn]]@dimSetNames %in% als_year)) {
      clmn <- als_year[als_year %in% scen@modInp@parameters[[nn]]@dimSetNames]
      # Shrink data.frame if need
      if (scen@modInp@parameters[[nn]]@nValues != -1) {
        scen@modInp@parameters[[nn]]@data <- scen@modInp@parameters[[nn]]@data[seq_len(scen@modInp@parameters[[nn]]@nValues),, drop = FALSE]
      }
      for (cc in clmn)
        scen@modInp@parameters[[nn]]@data <- scen@modInp@parameters[[nn]]@data[scen@modInp@parameters[[nn]]@data[, cc] >= stay.year.begin,, drop = FALSE]
      if (scen@modInp@parameters[[nn]]@nValues != -1) {
        scen@modInp@parameters[[nn]]@nValues <- nrow(scen@modInp@parameters[[nn]]@data)
      }
    }
  }
  # assign('prec.after.startYear', prec, globalenv())
  scen
}




.fix.couple <- function(scen, src, startYear, var.name, var.par) {
		# Chage supply reserve startYear (remove use in base period)
		sup.res.use0 <- src@modOut@variables$vSupOut
		sup.res.use0 <- sup.res.use0[sup.res.use0$year < startYear, ]
		sup.res.use0 <- aggregate(sup.res.use0[, 'value', drop = FALSE] * mile.stone.length[as.character(sup.res.use0$year)], 
															sup.res.use0[, c('sup', 'comm', 'region')], sum)
		sup.res.use0$type <- 'lo'
		sup.res.use0$value <- (-sup.res.use0$value)
		sup.res.use0 <- sup.res.use0[, c("sup", "comm", "region", 'type', 'value')]
		sup.res.par <- energyRt:::.getTotalParameterData(scen@modInp, 'pSupReserve')
		sup.res.par <- rbind(sup.res.par, sup.res.use0)
		sup.res.use0$type <- 'up'
		sup.res.par <- rbind(sup.res.par, sup.res.use0)
		sup.res.par <- aggregate(sup.res.par[, 'value', drop = FALSE], sup.res.par[, -ncol(sup.res.par)], sum) 
		sup.res.par <- sup.res.par[!(sup.res.par$type == 'lo' & sup.res.par$value <= 0), ]
		sup.res.par[sup.res.par$value < 0, 'value'] <- 0
		scen@modInp <- energyRt:::.setParameterData(scen@modInp, 'pSupReserve', sup.res.par)
}