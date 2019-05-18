.fix_to_scenario <- function(scen, src, startYear) {
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
  # Chage supply reserve startYear (remove use in base period)
  if (length(scen@modInp@set$sup) > 0) {
  	scen <- .fix.couple.cummulitive.uplo(scen, src, startYear, var.name = 'vSupOut', var.par = 'pSupReserve', mile.stone.length)
  }
  # Chage ExportRow reserve startYear (remove use in base period)
  if (length(scen@modInp@set$expp) > 0) {
  	scen <- .fix.couple.cummulitive(scen, src, startYear, var.name = 'vExportRow', var.par = 'pExportRowRes', mile.stone.length)
  }
  # Chage supply reserve startYear (remove use in base period)
  if (length(scen@modInp@set$imp) > 0) {
  	scen <- .fix.couple.cummulitive(scen, src, startYear, var.name = 'vImportRow', var.par = 'pImportRowRes', mile.stone.length)
  }
  # Remove unused constraint
  scen <- .fix_to_remove_unused_constraint(scen, src, min(mile.stone.after)) 
  # Fix to lag and lead constraint
  scen <- .fix_to_laglead_constraint(scen, src, mile.stone.after, max(mile.stone[mile.stone < startYear])) 
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
  # mMilestoneFirst
  scen@modInp@parameters[['mMilestoneFirst']] <- addData(scen@modInp@parameters[['mMilestoneFirst']], 
  	data.frame(year = min(mile.stone.after)))
  # assign('prec.after.startYear', prec, globalenv())
  scen
}


.fix.couple.cummulitive.uplo <- function(scen, src, startYear, var.name, var.par, mile.stone.length) {
	# Chage supply reserve startYear (remove use in base period)
	sup.res.use0 <- src@modOut@variables[[var.name]]
	sup.res.par <- energyRt:::.getTotalParameterData(scen@modInp, var.par)
	sup.res.use0 <- sup.res.use0[sup.res.use0$year < startYear, ]
	sup.res.use0$type <- 'lo'
	sup.res.use0 <- aggregate(sup.res.use0[, 'value', drop = FALSE] * mile.stone.length[as.character(sup.res.use0$year)], 
														sup.res.use0[, colnames(sup.res.par)[colnames(sup.res.par) != 'value']], sum)
	
	sup.res.use0$value <- (-sup.res.use0$value)
	sup.res.par <- rbind(sup.res.par, sup.res.use0)
	sup.res.use0$type <- 'up'
	sup.res.par <- rbind(sup.res.par, sup.res.use0)
	sup.res.par <- aggregate(sup.res.par[, 'value', drop = FALSE], sup.res.par[, -ncol(sup.res.par)], sum) 
	sup.res.par <- sup.res.par[!(sup.res.par$type == 'lo' & sup.res.par$value <= 0), ]
	sup.res.par[sup.res.par$value < 0, 'value'] <- 0
	scen@modInp <- energyRt:::.setParameterData(scen@modInp, var.par, sup.res.par)
	scen
}

.fix.couple.cummulitive <- function(scen, src, startYear, var.name, var.par, mile.stone.length) {
		# Chage supply reserve startYear (remove use in base period)
		sup.res.use0 <- src@modOut@variables[[var.name]]
		sup.res.par <- energyRt:::.getTotalParameterData(scen@modInp, var.par)
		sup.res.use0 <- sup.res.use0[sup.res.use0$year < startYear, ]
		sup.res.use0 <- aggregate(sup.res.use0[, 'value', drop = FALSE] * mile.stone.length[as.character(sup.res.use0$year)], 
															sup.res.use0[, colnames(sup.res.par)[colnames(sup.res.par) != 'value'], drop = FALSE], sum)
		
		sup.res.use0$value <- (-sup.res.use0$value)
		sup.res.par <- rbind(sup.res.par, sup.res.use0)
		sup.res.par <- aggregate(sup.res.par[, 'value', drop = FALSE], sup.res.par[, -ncol(sup.res.par), drop = FALSE], sum) 
		sup.res.par[sup.res.par$value < 0, 'value'] <- 0
		scen@modInp <- energyRt:::.setParameterData(scen@modInp, var.par, sup.res.par)
		scen
}

.remove_constraint <- function(scen, cnst4rem) {
	scen@modInp@gams.equation <- scen@modInp@gams.equation[!(names(scen@modInp@gams.equation) %in% cnst4rem)] 
	# Set and parameters for removing
	tmp <- paste0('(', paste0(cnst4rem, collapse = '|'), ')')
	need_rem <- c(
		grep(paste0('^(pCnsMult|mCns)', tmp, '[_][[:digit:]]+$'), names(scen@modInp@parameters), value = TRUE),
		grep(paste0('^pCnsRhs', tmp, '$'), names(scen@modInp@parameters), value = TRUE)
	)
	scen@modInp@parameters <- scen@modInp@parameters[!(names(scen@modInp@parameters) %in% need_rem)]
	scen
}
# scen = BAU; src = BAU; startYear = 2020
.fix_to_remove_unused_constraint <- function(scen, src, startYear) {
	map_cnd <- grep('^mCns', names(scen@modInp@parameters), value = TRUE)
	if (length(map_cnd) == 0) return(scen);
	map_cnd <- map_cnd[sapply(scen@modInp@parameters[map_cnd], 
														function(x) (any(x@dimSetNames == 'year') && all(x@data$year < startYear)))]
	if (length(map_cnd) == 0) return(scen);
	cnst4rem <- unique(sub('[_][[:digit:]]+$', '', sub('^mCns', '', map_cnd)))
	.remove_constraint(scen, cnst4rem)
}


# last_noinc_mile = max(mile.stone[mile.stone < startYear])
.fix_to_laglead_constraint <- function(scen, src, mile.stone.after, last_noinc_mile) {
	# Find scenario with lead & lag year 
	l_year_cns <- names(scen@modInp@gams.equation)[sapply(scen@modInp@gams.equation, function(x) any(grep('([ ]|[$]|[(])mMilestoneNext[(]', x$equation)))]
	# if lag stop (not realised now)
	for (x in l_year_cns) {
		if (any(grep('not[(]mStartMilestone[(]year[)][)]', sub('.*[$]', '', sub('[.][.].*', '', scen@modInp@gams.equation[[x]]$equation)))))
			stop('lag year nor realised for start run from year')
	}
	# For lead year
	# cns= l_year_cns[1]
	for (cns in l_year_cns) {
		NEW_PAR <- 0
		new_cns <- paste0('2', cns)
		rst <- scen@modInp@gams.equation[[cns]]
		rst$equationDeclaration2Model <- sub('^eqCns', 'eqCns2', rst$equationDeclaration2Model)
		rst$equationDeclaration <- sub('^eqCns', 'eqCns2', rst$equationDeclaration)
		# Make a copy constraint for init period
	  eqt <- scen@modInp@gams.equation[[cns]]$equation
	  eqt <- sub(' mMilestoneHasNext[(]year[)]', ' mMilestoneFirst(year)', eqt)
	  eqt <- sub('^eqCns', 'eqCns2', eqt)
	  # Split eqt by summand
	  eqt0 <- sub('.*[.][.][[:blank:]]*', '', eqt)
		eqt_en <- sub('[.][.].*', '.. ', eqt)
		while (nchar(eqt0) != 0) {
			eqt0 <- sub('[[:blank:]]*', '', eqt0)
			if (any(substr(eqt0, 1, 1) == c('+', '-'))) {
				eqt2 <- sub('^[+-][[:blank:]]*[[:digit:].]*[[:blank:]]*', '', eqt0)
				eqt_en <- paste0(eqt_en, ' ', substr(eqt0, 1, nchar(eqt0) - nchar(eqt2)))
				eqt0 <- eqt2
			} else if (any(substr(eqt0, 1, 1) == '=')) {
				eqt_en <- paste0(eqt_en, ' ', substr(eqt0, 1, 3))
				eqt0 <- substr(eqt0, 4, nchar(eqt0))
			} else if (substr(eqt0, 1, 4) == 'sum(') {
				# .get.bracket = energyRt:::.get.bracket
				brk <- .get.bracket(substr(eqt0, 4, nchar(eqt0)))
				if (any(grep('( |[(]|[$])mMilestoneNext[(]year, yearp[)]', brk$beg))) {
################ There are next, and it have to rename yearp to year, and remove slice
					# Replace yearp -> year
					eqt2 <- brk$beg
					nn <- strsplit(eqt2, 'yearp')[[1]]
					mcan <- c(',', '(', ')', ' ')
					if (length(nn) > 1) {
						for (i in 2:length(nn)) {
							if (any(substr(nn[i], 1, 1) == mcan) && any(substr(nn[i - 1], nchar(nn[i - 1]), nchar(nn[i - 1])) == mcan)) {
								nn[i - 1] <- paste0(nn[i - 1], 'year')
							} else {
								nn[i - 1] <- paste0(nn[i - 1], 'yearp')
							}
						}
						eqt2 <- paste0(nn, collapse = '')
					}
					# Replace pCnsMult
					if (any(grep('pCnsMult', eqt2))) {
						nn <- strsplit(eqt2, 'pCnsMult[[:alnum:]_]*')[[1]]
						if (any(strsplit(gsub('([[:blank:]]*|[(]|[)].*)', '', nn[2]), ',')[[1]] == 'year')) {
							prm <- gsub('(^[[:blank:]]*|[(].*)', '', substr(eqt2, nchar(nn[1]), nchar(eqt2)))
							tpr <- energyRt:::.getTotalParameterData(scen@modInp, prm)
							tpr <- tpr[tpr$year == last_noinc_mile, colnames(tpr) != 'year', drop = FALSE]
							# Replace
							if (ncol(tpr) == 1) {
								eqt2 <- sub('pCnsMult[[:alnum:]_]*[(][^)]*[)]', tpr$value, eqt2)
							} else {
								NEW_PAR <- NEW_PAR + 1
								xx <- createParameter(paste0('pCnsMult', new_cns, '_', NEW_PAR), colnames(tpr)[-ncol(tpr)], 'simple', defVal = 0, 
									interpolation = 'back.inter.forth')
								scen@modInp@parameters[[xx@name]] <- addData(xx, tpr)
								eqt2 <- sub('pCnsMult[[:alnum:]_]*[(][^)]*[)]', paste0(xx@name, '(', paste0(xx@dimSetNames, collapse = ' , '), ')'), eqt2)
							}
						}
					}
					# Remove condition mMilestoneNext(year, year) and mMidMilestone(year)
					eqt2 <- gsub('(mMidMilestone|mMilestoneNext)[(]year(|[,][[:blank:]]*year)[)]', '', eqt2)
					eqt2 <- gsub('and([[:blank:]]+and)*', 'and ', eqt2)
					eqt2 <- substr(eqt2, 2, nchar(eqt2) - 1)
					if (substr(eqt2, 1, 1) == '(') {
						loop <- strsplit(gsub('(^[(]|[)].*|[[:blank:]]*)', '', eqt2), '[,]')[[1]]
						loop <- loop[loop != 'year']
						eqt_en <- paste0(eqt_en, ' sum((',paste0(loop, collapse = ', '), gsub('^[^)]*', '', eqt2), ')')
						eqt0 <- brk$end
					} else {
						stop('fix to lead constraint: have to write for removing sum condition')
					}
				} else if (any(grep('( |[(]|[,])year([ ]|[)]|[,])', brk$beg))) {
######## There are year, and it have to replace to constant or parameter
					xx <- sub('^[(]', '', sub('[)]$', '', brk$beg))
					cond <- sub('[,][[:blank:]]*(|[+-]*[[:blank:]]*([[:digit:].]*|pCnsMult.*)[[:blank:]]*[*][[:blank:]]*)[[:blank:]]*v[[:alnum:]]*[(][^)]*[)]$', '', xx)
					to_const <- sub('^[[:blank:]]*', '', substr(xx, nchar(cond) + 2, nchar(xx)))
					# Get variable and parameter if need data
					vrb <- sub(paste0('^[+-]*[[:blank:]]*([[:digit:].]*|pCnsMult', cns, '[_][[:digit:]]*[(][^)]*[)])[[:blank:]]*[*][[:blank:]]*'), '', to_const)
					param <- sub('[[:blank:]]*[*][[:blank:]]*$', '', substr(to_const, 1, nchar(to_const) - nchar(vrb)))
					tpr <- src@modOut@variables[[sub('[(].*', '', vrb)]]
					if (any(grep('pCnsMult', param))) {
						const <- energyRt:::.getTotalParameterData(scen@modInp, gsub('([[:blank:]]*|[+-]|[(].*)', '', param))
						tpr <- merge(tpr, const, by = colnames(const)[colnames(const) != 'value'])
						tpr$value <- tpr$value.x * tpr$value.y
						if (any(grep('[-]', param))) tpr$value <- (-tpr$value)
						tpr$value.x <- NULL; tpr$value.y <- NULL;
					} else {
						tpr$value <- as.numeric(param) * tpr$value
					}
					# Reduce by mapping
					cond2 <- sub('^[^$]*[$]', '', cond)
					if (substr(cond2, 1, 1) == '(') cond2 <- sub('^[(]', '', sub('[)]$', '', cond2))
					if (!is.null(tpr$year)) {
						tpr <- tpr[tpr$year == last_noinc_mile, ]
					}
					forMrg <- gsub('[(].*$', '', strsplit(cond2, 'and ')[[1]])
					for (fr in forMrg) {
						tmp <- getParameterData(prec@parameters[[fr]])
						#tmp <- energyRt:::.getTotalParameterData(scen@modInp, fr)
						tpr <- merge(tpr, tmp, by = colnames(tmp)[colnames(tmp) != 'value'])
					}
					# Summing sum set & year
					rem.sum <- c('year', strsplit(gsub(' ', '', sub('^[(]', '', sub('([)]|)[$].*$', '', cond))), '[,]')[[1]])
					tpr <- tpr[, !(colnames(tpr) %in% rem.sum), drop = FALSE]
					# Add parameter or const to equation
					if (ncol(tpr) > 1) {
						tpr <- aggregate(tpr[, 'value', drop = FALSE], tpr[, colnames(tpr) != 'value', drop = FALSE], sum)
						NEW_PAR <- NEW_PAR + 1
						xx <- createParameter(paste0('pCnsMult', new_cns, '_', NEW_PAR), colnames(tpr)[-ncol(tpr)], 'simple', defVal = 0, 
							interpolation = 'back.inter.forth')
						scen@modInp@parameters[[xx@name]] <- addData(xx, tpr)
						eqt_en <- paste0(eqt_en, xx@name, '(', paste0(xx@dimSetNames, collapse = ', '), ')')
					} else {
						tpr <- sum(tpr$value)
						if (tpr != 0) eqt_en <- paste0(eqt_en, '+'[tpr >= 0], tpr) 
					}
					eqt0 <- brk$end
				} else  {
					# Stay as before
					stop('fix to: sum( Stay as before')
					eqt_en <- paste0(eqt_en, 'sum', brk$beg)
					eqt0 <- brk$end
				} 
			} else if (any(substr(eqt0, 1, 3) == 'pCns')) {
				stop('fix to: pCns')
			} else if (any(grep('^[[:digit:].]+', eqt0))) {
				tmp <- sub('^[[:digit:].]*', '', eqt0)
				eqt_en <- paste0(eqt_en, ' ', substr(eqt0, 1, nchar(tmp)))
				eqt0 <- tmp
			} else if (substr(eqt0, 1, 1) == ';') {
				eqt_en <- paste0(eqt_en, ' ', substr(eqt0, 1, 1))
				eqt0 <- ''
			} else if (any(substr(eqt0, 1, 1) == c('v'))) {
				stop('fix to: v')
			} else {
				stop('fix to: Unknown cond')
			}  
			
		}
		eqt_en <- gsub('([+][[:blank:]]*)*[-]', '-', eqt_en)
		eqt_en <- gsub('([+][[:blank:]]*)*[+]', '+', eqt_en)
		rst$equation <- eqt_en
		scen@modInp@gams.equation[[sub('^eqCns', '', rst$equationDeclaration2Model)]] <- rst
	}
	scen
}
