################################################################################
# Add storage
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'storage',
	approxim = 'list'), function(obj, app, approxim) {
	  pStorageCout <- NULL; pStorageCinp <- NULL;
		stg <- energyRt:::.upper_case(app)
		stg_slice <- approxim$slice@slice_map[[approxim$commodity_slice_map[[stg@commodity]]]]
		approxim <- .fix_approximation_list(approxim, comm = stg@commodity, lev = NULL)
		stg <- .disaggregateSliceLevel(stg, approxim)
		if (length(stg@region) != 0) {
			approxim$region <- approxim$region[approxim$region %in% stg@region]
			ss <- getSlots('storage')
			ss <- names(ss)[ss == 'data.frame']
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
			obj@parameters[['mStorageFullYear']] <- addData(obj@parameters[['mStorageFullYear']],
				data.frame(stg = stg@name))
		obj@parameters[['mStorageComm']] <- addData(obj@parameters[['mStorageComm']],
			data.frame(stg = stg@name, comm = stg@commodity))
		olife <- simpleInterpolation(stg@olife, 'olife', obj@parameters[['pStorageOlife']], 
		  approxim, 'stg', stg@name, removeDefault = FALSE)
		obj@parameters[['pStorageOlife']] <- addData(obj@parameters[['pStorageOlife']], olife)
		# Loss
		obj@parameters[['pStorageInpEff']] <- addData(obj@parameters[['pStorageInpEff']],
			simpleInterpolation(stg@seff, 'inpeff', obj@parameters[['pStorageInpEff']], 
				approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
		obj@parameters[['pStorageOutEff']] <- addData(obj@parameters[['pStorageOutEff']],
			simpleInterpolation(stg@seff, 'outeff', obj@parameters[['pStorageOutEff']], 
				approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
		obj@parameters[['pStorageStgEff']] <- addData(obj@parameters[['pStorageStgEff']], 
			simpleInterpolation(stg@seff, 'stgeff',  obj@parameters[['pStorageStgEff']], 
				approxim, c('stg', 'comm'), c(stg@name, stg@commodity)))
		# Cost
		pStorageCostInp <- simpleInterpolation(stg@varom, 'inpcost',
		                                       obj@parameters[['pStorageCostInp']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageCostInp']] <- addData(obj@parameters[['pStorageCostInp']], pStorageCostInp)
		pStorageCostOut <- simpleInterpolation(stg@varom, 'outcost',
		                                       obj@parameters[['pStorageCostOut']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageCostOut']] <- addData(obj@parameters[['pStorageCostOut']], pStorageCostOut)
			
		pStorageCostStore <- simpleInterpolation(stg@varom, 'stgcost',
		                                         obj@parameters[['pStorageCostStore']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageCostStore']] <- addData(obj@parameters[['pStorageCostStore']], pStorageCostStore)
			
		pStorageFixom <- simpleInterpolation(stg@fixom, 'fixom',
		                                     obj@parameters[['pStorageFixom']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageFixom']] <- addData(obj@parameters[['pStorageFixom']], pStorageFixom)
		# Ava/Cap
		pStorageAf <- multiInterpolation(stg@af, 'af', obj@parameters[['pStorageAf']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageAf']] <- addData(obj@parameters[['pStorageAf']], pStorageAf)
		obj@parameters[['pStorageCap2stg']] <- addData(obj@parameters[['pStorageCap2stg']],
			data.frame(stg = stg@name, value = stg@cap2stg))
		pStorageCinp <-  multiInterpolation(stg@af, 'cinp', obj@parameters[['pStorageCinp']], approxim, c('stg', 'comm'), c(stg@name, stg@commodity))
		obj@parameters[['pStorageCinp']] <- addData(obj@parameters[['pStorageCinp']], pStorageCinp) 
		pStorageCout <- multiInterpolation(stg@af, 'cout', obj@parameters[['pStorageCout']], approxim, c('stg', 'comm'), c(stg@name, stg@commodity))
		obj@parameters[['pStorageCout']] <- addData(obj@parameters[['pStorageCout']], pStorageCout)
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
			mStorageAInp <- data.frame(stg = rep(stg@name, length(cmp_inp)), comm = cmp_inp)
			obj@parameters[['mStorageAInp']] <- addData(obj@parameters[['mStorageAInp']], mStorageAInp)
			mStorageAOut <- data.frame(stg = rep(stg@name, length(cmp_out)), comm = cmp_out)
      obj@parameters[['mStorageAOut']] <- addData(obj@parameters[['mStorageAOut']], mStorageAOut)
			dd <- data.frame(list = c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 'pStorageCout2AInp', 
				'pStorageCout2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 'pStorageNCap2AInp', 'pStorageNCap2AOut'),
				table = c('stg2ainp', 'stg2aout', 'cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout', 'cap2ainp', 'cap2aout', 'ncap2ainp', 
					'ncap2aout'),
				stringsAsFactors = FALSE)
			approxim_comm <- approxim
			aout_tmp <- list()
			for(i in 1:nrow(dd)) {
				approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
				approxim_comm[['acomm']] <- unique(stg@aeff[!is.na(stg@aeff[, dd[i, 'table']]), 'acomm'])
				if (length(approxim_comm[['acomm']]) != 0) {
					aout_tmp[[dd[i, 'list']]] <- simpleInterpolation(stg@aeff, dd[i, 'table'], obj@parameters[[dd[i, 'list']]], approxim_comm, 'stg', stg@name)
					obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]], aout_tmp[[dd[i, 'list']]])
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
		  obj@parameters[['pStorageNCap2Stg']] <- addData(obj@parameters[['pStorageNCap2Stg']], tmp)
		}

		if (any(!is.na(stg@stock$charge) & stg@stock$charge != 0)) {
		  fl <- (!is.na(stg@stock$charge) & stg@stock$charge != 0)
		  if (any(is.na(stg@stock[fl, c('region', 'year', 'slice')])))
		    stop(paste0('Approximation is not allowed for storage "', stg@name, '" parameter charge'))
		  tmp <- stg@stock[fl, c('region', 'year', 'slice', 'charge')]
		  tmp$stg <- stg@name
		  tmp$comm <- stg@commodity
		  tmp$value <- tmp$charge
		  tmp <- tmp[, c('stg', 'comm', 'region', 'year', 'slice', 'value')]
		  obj@parameters[['pStorageCharge']] <- addData(obj@parameters[['pStorageCharge']], tmp)
		}
		# Some slice
		stock_exist <- simpleInterpolation(stg@stock[, colnames(stg@stock) != 'slice'], 'stock', 
		                                   obj@parameters[['pStorageStock']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageStock']] <- addData(obj@parameters[['pStorageStock']], stock_exist)
		invcost <- simpleInterpolation(stg@invcost, 'invcost', obj@parameters[['pStorageInvcost']], approxim, 'stg', stg@name)
		obj@parameters[['pStorageInvcost']] <- addData(obj@parameters[['pStorageInvcost']], invcost)

		dd0 <- energyRt:::.start_end_fix(approxim, stg, 'stg', stock_exist)
		dd0$new <-  dd0$new[dd0$new$year   %in% approxim$mileStoneYears & dd0$new$region  %in% approxim$region,, drop = FALSE]
		dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears & dd0$span$region %in% approxim$region,, drop = FALSE]
		obj@parameters[['mStorageNew']] <- addData(obj@parameters[['mStorageNew']], dd0$new)
		mStorageSpan <- dd0$span
		obj@parameters[['mStorageSpan']] <- addData(obj@parameters[['mStorageSpan']], dd0$span)
		obj@parameters[['mStorageEac']] <- addData(obj@parameters[['mStorageEac']], dd0$eac)
		
		if (nrow(dd0$new) > 0  && !is.null(invcost) && nrow(invcost) > 0) {
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
  		salv_data$tech <- stg@name
  		salv_data$value <- salv_data$eac
  		pStorageEac <- salv_data[, c('stg', 'region', 'year', 'value')]
  		obj@parameters[['pStorageEac']] <- addData(obj@parameters[['pStorageEac']], unique(pStorageEac[, colnames(pStorageEac) %in% c(obj@parameters[['pStorageEac']]@dimSetNames, 'value'), drop = FALSE]))
    }
			

		if (nrow(stg@weather) > 0) {
      tmp <- .toWeatherImply(stg@weather, 'waf', 'stg', stg@name)
      obj@parameters[['pStorageWeatherAf']] <- addData(obj@parameters[['pStorageWeatherAf']], tmp$par)
      obj@parameters[['mStorageWeatherAfUp']] <- addData(obj@parameters[['mStorageWeatherAfUp']], tmp$mapup)
      obj@parameters[['mStorageWeatherAfLo']] <- addData(obj@parameters[['mStorageWeatherAfLo']], tmp$maplo)

	    tmp <- .toWeatherImply(stg@weather, 'wcinp', 'stg', stg@name)
      obj@parameters[['pStorageWeatherCinp']] <- addData(obj@parameters[['pStorageWeatherCinp']], tmp$par)
      obj@parameters[['mStorageWeatherCinpUp']] <- addData(obj@parameters[['mStorageWeatherCinpUp']], tmp$mapup)
      obj@parameters[['mStorageWeatherCinpLo']] <- addData(obj@parameters[['mStorageWeatherCinpLo']], tmp$maplo)

	    tmp <- .toWeatherImply(stg@weather, 'wcout', 'stg', stg@name)
      obj@parameters[['pStorageWeatherCout']] <- addData(obj@parameters[['pStorageWeatherCout']], tmp$par)
      obj@parameters[['mStorageWeatherCoutUp']] <- addData(obj@parameters[['mStorageWeatherCoutUp']], tmp$mapup)
      obj@parameters[['mStorageWeatherCoutLo']] <- addData(obj@parameters[['mStorageWeatherCoutLo']], tmp$maplo)
		}
		pStorageOlife <- olife
		if (any(pStorageOlife$olife != Inf)) {
			mStorageOlifeInf <- pStorageOlife[pStorageOlife$olife != Inf, colnames(pStorageOlife) %in% 
					obj@parameters[['mStorageOlifeInf']]@dimSetNames, drop = FALSE]
			if (ncol(mStorageOlifeInf) != ncol(obj@parameters[['mStorageOlifeInf']]@data))
				mStorageOlifeInf <- merge(mStorageOlifeInf, mStorageSpan[, colnames(mStorageSpan) %in% 
					obj@parameters[['mStorageOlifeInf']]@dimSetNames, drop = FALSE])
			obj@parameters[['mStorageOlifeInf']] <- addData(obj@parameters[['mStorageOlifeInf']], mStorageOlifeInf)
		}
		dsm <- obj@parameters[['mStorageOMCost']]@dimSetNames
		mStorageOMCost <- NULL
		if (!is.null(mStorageOMCost)) mStorageOMCost <- rbind(mStorageOMCost, pStorageFixom[pStorageFixom$value != 0, dsm])
		if (!is.null(mStorageOMCost)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostInp[pStorageCostInp$value != 0, dsm])
		if (!is.null(mStorageOMCost)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostOut[pStorageCostOut$value != 0, dsm])
		if (!is.null(mStorageOMCost)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostStore[pStorageCostStore$value != 0, dsm])
		if (!is.null(mStorageOMCost)) {
  		mStorageOMCost <- merge(mStorageOMCost[!duplicated(mStorageOMCost), ], mStorageSpan)
  		obj@parameters[['mStorageOMCost']] <- addData(obj@parameters[['mStorageOMCost']], mStorageOMCost)
		}
		mvStorageStore <- merge(mStorageSpan, list(slice = stg_slice))
		mvStorageStore$comm <- stg@commodity
		obj@parameters[['mvStorageStore']] <- addData(obj@parameters[['mvStorageStore']], mvStorageStore)

		if (nrow(stg@aux) != 0) {
			mvStorageStore2 <- mvStorageStore; mvStorageStore2$comm <- NULL
			mvStorageAInp <- merge(mvStorageStore2, mStorageAInp)
		  obj@parameters[['mvStorageAInp']] <- addData(obj@parameters[['mvStorageAInp']], mvStorageAInp)
			mvStorageAOut <- merge(mvStorageStore2, mStorageAOut)
  		obj@parameters[['mvStorageAOut']] <- addData(obj@parameters[['mvStorageAOut']], mvStorageAOut)
  		for (i in c('mStorageStg2AOut', 'mStorageCinp2AOut', 'mStorageCout2AOut', 'mStorageCap2AOut', 'mStorageNCap2AOut', 
  			'mStorageStg2AInp', 'mStorageCinp2AInp', 'mStorageCout2AInp', 'mStorageCap2AInp', 'mStorageNCap2AInp')) 
  			if (!is.null(aout_tmp[[gsub('^m', 'p', i)]])) {
	  			atmp <- aout_tmp[[gsub('^m', 'p', i)]]
	  			if (any(grep('Out$', i))) {
		  			atmp <- atmp[, colnames(atmp)%in% colnames(mvStorageAOut), drop = FALSE]
		  			if (ncol(atmp) != 5) atmp <- merge(atmp, mvStorageAOut)
	  			} else {
		  			atmp <- atmp[, colnames(atmp)%in% colnames(mvStorageAInp), drop = FALSE]
		  			if (ncol(atmp) != 5) atmp <- merge(atmp, mvStorageAInp)
	  			}
	  			obj@parameters[[i]] <- addData(obj@parameters[[i]], atmp)
	  		}
		}
		rem_inf_def1 <- function(x, y) {
		  if (is.null(x)) return(y)
		  x <- x[x$type == 'up' & x$value == Inf, ]
		  y[(!duplicated(rbind(y, x)))[1:nrow(y)], ]
		}
		rem_inf_def_inf <- function(x, y) {
		 merge(x[x$type == 'up' & x$value != Inf, colnames(x) %in% colnames(y), drop = FALSE], y)
		}
		obj@parameters[['meqStorageAfLo']] <- addData(obj@parameters[['meqStorageAfLo']], merge(pStorageAf[pStorageAf$type == 'lo' & pStorageAf$value != 0, 
         ], mvStorageStore))
		obj@parameters[['meqStorageAfUp']] <- addData(obj@parameters[['meqStorageAfUp']], rem_inf_def1(pStorageAf, mvStorageStore))
		if (!is.null(pStorageCinp)) {
  		obj@parameters[['meqStorageInpLo']] <- addData(obj@parameters[['meqStorageInpLo']], merge(pStorageCinp[pStorageCinp$type == 'lo' & pStorageCinp$value != 0, 
  		         colnames(pStorageCinp) %in% obj@parameters[['meqStorageInpLo']]@dimSetNames], mvStorageStore))
  		obj@parameters[['meqStorageInpUp']] <- addData(obj@parameters[['meqStorageInpUp']], rem_inf_def_inf(pStorageCinp, mvStorageStore))
		}
		if (!is.null(pStorageCout)) {
  		obj@parameters[['meqStorageOutLo']] <- addData(obj@parameters[['meqStorageOutLo']], 
  			merge(pStorageCout[pStorageCout$type == 'lo' & pStorageCout$value != 0, 
  		                 colnames(pStorageCout) %in% obj@parameters[['meqStorageOutLo']]@dimSetNames, drop = FALSE], mvStorageStore))
  		obj@parameters[['meqStorageOutUp']] <- addData(obj@parameters[['meqStorageOutUp']], rem_inf_def_inf(pStorageCout, mvStorageStore))
    }
		obj
	})
