################################################################################
# Add technology
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'technology',
	approxim = 'list'), function(obj, app, approxim) {
		energyRt:::.checkSliceLevel(app, approxim)
		#  mTechInpComm(tech, comm)       Input commodity
		#  mTechOutComm(tech, comm)       Output commodity
		#  mTechCapComm(tech, comm)       Capacity fix commodity
		#  mTechActComm(tech, comm)       Activity fix commodity
		#  mTechUseComm(tech, comm)       Activity fix commodity
		#  mTechOneComm(tech, comm)    Single commodity
		#  mTechGroupComm(tech, group, comm)  Share (group) commodity connect to group
		#  mTechCapGroup(tech, group)         Group connect with capacity
		#  mTechUseGroup(tech, group)         Group connect with use
		#  mTechActGroup(tech, group)         Group connect with use
		#  mTechInpGroup(tech, group)         Group use for input
		#  mTechOutGroup(tech, group)         Group use for output
		#  mTechStartYear(tech, region, year) Start year
		#  mTechEndYear(tech, region, year)   End year
		#  mTechDisable(tech, region)     Disable new technology
		#  * Emissions
		#  mTechEmisComm(tech, comm)
		#  mTechEmitedComm(tech, comm)
		#  mUpComm(comm)  PRODUCTION <= CONSUMPTION
		#  mLoComm(comm)  PRODUCTION >= CONSUMPTION
		#  mFxComm(comm)  PRODUCTION = CONSUMPTION
		tech <- energyRt:::.upper_case(app)
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
		obj@parameters[['mTechSlice']] <- addData(obj@parameters[['mTechSlice']],
			data.frame(tech = rep(tech@name, length(approxim$slice)), slice = approxim$slice, 
				stringsAsFactors = FALSE))
		if (length(tech@region) != 0) {
			approxim$region <- approxim$region[approxim$region %in% tech@region]
			ss <- getSlots('technology')
			ss <- names(ss)[ss == 'data.frame']
			ss <- ss[sapply(ss, function(x) (any(colnames(slot(tech, x)) == 'region') 
				&& any(!is.na(slot(tech, x)$region))))]
			for(sl in ss) if (any(!is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region))) {
				rr <- !is.na(slot(tech, sl)$region) & !(slot(tech, sl)$region %in% tech@region)
				warning(paste('There are data technology "', tech@name, '"for unused region: "', 
					paste(unique(slot(tech, sl)$region[rr]), collapse = '", "'), '"', sep = ''))
				slot(tech, sl) <- slot(tech, sl)[!rr,, drop = FALSE]
			}
		}
		tech <- stayOnlyVariable(tech, approxim$region, 'region')
		# # Temporary solution for immortality technology
		# if (nrow(tech@olife) == 0) {
		#   tech@olife[1, ] <- NA;
		#   tech@olife[1, 'olife'] <- Inf;
		# }
		
		# Map
		ctype <- checkInpOut(tech)
		# Need choose comm more accuracy
		approxim_comm <- approxim
		approxim_comm[['comm']] <- rownames(ctype$comm)
		if (length(approxim_comm[['comm']]) != 0) {
			obj@parameters[['pTechCvarom']] <- addData(obj@parameters[['pTechCvarom']],
				simpleInterpolation(tech@varom, 'cvarom',
					obj@parameters[['pTechCvarom']], approxim_comm, 'tech', tech@name))
		}
		approxim_acomm <- approxim
		approxim_acomm[['acomm']] <- rownames(ctype$aux)
		if (length(approxim_acomm[['acomm']]) != 0) {
			obj@parameters[['pTechAvarom']] <- addData(obj@parameters[['pTechAvarom']],
				simpleInterpolation(tech@varom, 'avarom',
					obj@parameters[['pTechAvarom']], approxim_acomm, 'tech', tech@name))
		}
		approxim_comm[['comm']] <- rownames(ctype$comm)
		if (length(approxim_comm[['comm']]) != 0) {
			gg <- multiInterpolation(tech@ceff, 'afc',
				obj@parameters[['pTechAfc']], approxim_comm, 'tech', tech@name)
			obj@parameters[['pTechAfc']] <- addData(obj@parameters[['pTechAfc']], gg)
			#gg <- gg[gg$type == 'up' & gg$value == Inf, ]
			#if (nrow(gg) != 0) 
			#  obj@parameters[['ndefpTechAfcUp']] <- addData(obj@parameters[['dnefpTechAfcUp']],
			#        gg[, obj@parameters[['ndefpTechAfcUp']]@dimSetNames])
			
		}
		gg <- multiInterpolation(tech@af, 'af',
			obj@parameters[['pTechAf']], approxim, 'tech', tech@name)
		obj@parameters[['pTechAf']] <- addData(obj@parameters[['pTechAf']], gg)
		if (nrow(tech@afs) > 0) {
			afs_slice <- unique(tech@afs$slice)
			afs_slice <- afs_slice[!is.na(afs_slice)]
			approxim.afs <- approxim
			approxim.afs$slice <- afs_slice
			gg <- multiInterpolation(tech@afs, 'afs', obj@parameters[['pTechAfs']], approxim.afs, 'tech', tech@name)
			obj@parameters[['pTechAfs']] <- addData(obj@parameters[['pTechAfs']], gg)
		}
		#gg <- gg[gg$type == 'up' & gg$value == Inf, ]
		#if (nrow(gg) != 0) 
		#    obj@parameters[['ndefpTechAfUp']] <- addData(obj@parameters[['ndefpTechAfUp']],
		#          gg[, obj@parameters[['ndefpTechAfUp']]@dimSetNames])
		
		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input']
		if (length(approxim_comm[['comm']]) != 0) {
			obj@parameters[['pTechCinp2use']] <- addData(obj@parameters[['pTechCinp2use']],
				simpleInterpolation(tech@ceff, 'cinp2use',
					obj@parameters[['pTechCinp2use']], approxim_comm, 'tech', tech@name))
		}
		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'output']
		if (length(approxim_comm[['comm']]) != 0) {
			obj@parameters[['pTechUse2cact']] <- addData(obj@parameters[['pTechUse2cact']],  
				simpleInterpolation(tech@ceff, 'use2cact',
					obj@parameters[['pTechUse2cact']], approxim_comm, 'tech', tech@name))
			obj@parameters[['pTechCact2cout']] <- addData(obj@parameters[['pTechCact2cout']],
				simpleInterpolation(tech@ceff, 'cact2cout',
					obj@parameters[['pTechCact2cout']], approxim_comm, 'tech', tech@name))
			if (any(!is.na(tech@ceff$cact2cout) & (tech@ceff$cact2cout == 0 | tech@ceff$cact2cout == Inf)))
				stop('cact2cout is not correct ', tech@name)
			if (any(!is.na(tech@ceff$use2cact) & (tech@ceff$use2cact == 0 | tech@ceff$use2cact == Inf)))
				stop('use2cact is not correct ', tech@name)
		}
		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input' & !is.na(ctype$comm[, 'group'])]
		if (length(approxim_comm[['comm']]) != 0) {
			obj@parameters[['pTechCinp2ginp']] <- addData(obj@parameters[['pTechCinp2ginp']],
				simpleInterpolation(tech@ceff, 'cinp2ginp',
					obj@parameters[['pTechCinp2ginp']], approxim_comm, 'tech', tech@name))
		}
		if (tech@early.retirement) 
			obj@parameters[['mTechRetirement']] <- addData(obj@parameters[['mTechRetirement']], data.frame(tech = tech@name))
		if (length(tech@upgrade.technology) != 0)
			obj@parameters[['mTechUpgrade']] <- addData(obj@parameters[['mTechUpgrade']], 
				data.frame(tech = rep(tech@name, length(tech@upgrade.technology)), techp = tech@upgrade.technology))
		cmm <- rownames(ctype$comm)[ctype$comm$type == 'input'] 
		if (length(cmm) != 0)
			obj@parameters[['mTechInpComm']] <- addData(obj@parameters[['mTechInpComm']],
				data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
		cmm <- rownames(ctype$comm)[ctype$comm$type == 'output']
		if (length(cmm) != 0)
			obj@parameters[['mTechOutComm']] <- addData(obj@parameters[['mTechOutComm']],
				data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
		cmm <- rownames(ctype$comm)[is.na(ctype$comm$group)] 
		if (length(cmm) != 0)
			obj@parameters[['mTechOneComm']] <- addData(obj@parameters[['mTechOneComm']],
				data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
		approxim_comm[['comm']] <- rownames(ctype$comm)[!is.na(ctype$comm$group)]
		if (length(approxim_comm[['comm']]) != 0)
			obj@parameters[['pTechShare']] <- addData(obj@parameters[['pTechShare']],
				multiInterpolation(tech@ceff, 'share',
					obj@parameters[['pTechShare']], approxim_comm, 'tech', tech@name))
		cmm <- rownames(ctype$comm)[ctype$comm$comb != 0]
		if (length(cmm) != 0) {
			obj@parameters[['pTechEmisComm']] <- addData(obj@parameters[['pTechEmisComm']],
				data.frame(tech = rep(tech@name, nrow(ctype$comm)), comm = rownames(ctype$comm),
					value = ctype$comm$comb))
		}
		gpp <- rownames(ctype$group)[ctype$group$type == 'input']
		if (length(gpp) != 0)
			obj@parameters[['mTechInpGroup']] <- addData(obj@parameters[['mTechInpGroup']],
				data.frame(tech = rep(tech@name, length(gpp)), group = gpp))
		gpp <- rownames(ctype$group)[ctype$group$type == 'output']
		if (length(gpp) != 0)
			obj@parameters[['mTechOutGroup']] <- addData(obj@parameters[['mTechOutGroup']],
				data.frame(tech = rep(tech@name, length(gpp)), group = gpp))
		approxim_group <- approxim
		approxim_group[['group']] <- rownames(ctype$group)[ctype$group$type == 'input']
		if (length(approxim_group[['group']]) != 0)
			obj@parameters[['pTechGinp2use']] <- addData(obj@parameters[['pTechGinp2use']],
				simpleInterpolation(tech@geff, 'ginp2use',
					obj@parameters[['pTechGinp2use']], approxim_group, 'tech', tech@name))
		if (nrow(ctype$group) > 0)
			obj@parameters[['group']] <- addMultipleSet(obj@parameters[['group']], rownames(ctype$group))
		fl <- !is.na(ctype$comm$group)
		if (any(fl)) {
			gcomm <- data.frame(tech = rep(tech@name, sum(fl)), group = ctype$comm$group[fl], 
				comm = rownames(ctype$comm)[fl], stringsAsFactors = FALSE)
			obj@parameters[['mTechGroupComm']] <- addData(obj@parameters[['mTechGroupComm']], gcomm)
		}
		if (any(ctype$aux$output)) {    
			cmm <- rownames(ctype$aux)[ctype$aux$output]
			obj@parameters[['mTechAOut']] <- addData(obj@parameters[['mTechAOut']],
				data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
		}
		if (any(ctype$aux$input)) {    
			cmm <- rownames(ctype$aux)[ctype$aux$input]
			obj@parameters[['mTechAInp']] <- addData(obj@parameters[['mTechAInp']],
				data.frame(tech = rep(tech@name, length(cmm)), comm = cmm))
		}
		dd <- data.frame(list = c('pTechAct2AOut', 'pTechCap2AOut', 
			'pTechAct2AInp', 'pTechCap2AInp', 'pTechNCap2AInp', 'pTechNCap2AOut'),
			table = c('act2aout', 'cap2aout', 'act2ainp', 'cap2ainp', 'ncap2ainp', 'ncap2aout'),
			stringsAsFactors = FALSE)
		for(i in 1:nrow(dd)) {
			approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
			approxim_comm[['acomm']] <- unique(tech@aeff[!is.na(tech@aeff[, dd[i, 'table']]), 'acomm'])
			if (length(approxim_comm[['acomm']]) != 0) {
				obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
					simpleInterpolation(tech@aeff, dd[i, 'table'], 
						obj@parameters[[dd[i, 'list']]], approxim_comm, 'tech', tech@name))
			}
		}                
		
		# simple & multi
		obj@parameters[['pTechCap2act']] <- addData(obj@parameters[['pTechCap2act']],
			data.frame(tech = tech@name, value = tech@cap2act))
		dd <- data.frame(
		  list = c('pTechFixom', 'pTechVarom'),
			table = c('fixom', 'varom'), 
			stringsAsFactors = FALSE)
		for(i in 1:nrow(dd)) {
			obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
				simpleInterpolation(slot(tech, dd[i, 'table']),
					dd[i, 'table'], obj@parameters[[dd[i, 'list']]], approxim, 'tech', tech@name))
		}

		if (nrow(tech@aeff) != 0) {
			for(i in 1:4) {
				tech@aeff <- tech@aeff[!is.na(tech@aeff$acomm),]
				ll <- c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout')[i]
				tbl <- c('pTechCinp2AInp', 'pTechCinp2AOut', 'pTechCout2AInp', 'pTechCout2AOut')[i]          
				tbl2 <- c('mTechCinpAInp', 'mTechCinpAOut', 'mTechCoutAInp', 'mTechCoutAOut')[i]     
				yy <- tech@aeff[!is.na(tech@aeff[, ll]), ]
				if (nrow(yy) != 0) {
					approxim_commp <- approxim
					approxim_commp$acomm <- unique(yy$acomm); 
					approxim_commp$comm <- unique(yy$comm)
					obj@parameters[[tbl]] <- addData(obj@parameters[[tbl]],
						simpleInterpolation(yy, ll, obj@parameters[[tbl]], 
							approxim_commp, 'tech', tech@name))
				}
			}
		}
		# Stock & Capacity
		stock_exist <- simpleInterpolation(tech@stock, 'stock', obj@parameters[['pTechStock']], approxim, 'tech', tech@name)
		obj@parameters[['pTechStock']] <- addData(obj@parameters[['pTechStock']], stock_exist)
		invcost <- simpleInterpolation(tech@invcost, 'invcost', obj@parameters[['pTechInvcost']], approxim, 'tech', tech@name)
		obj@parameters[['pTechInvcost']] <- addData(obj@parameters[['pTechInvcost']], invcost)
		olife <- simpleInterpolation(tech@olife, 'olife', obj@parameters[['pTechOlife']], approxim, 'tech', tech@name, removeDefault = FALSE)
		obj@parameters[['pTechOlife']] <- addData(obj@parameters[['pTechOlife']], olife)		
		
		dd0 <- energyRt:::.start_end_fix(approxim, tech, 'tech', stock_exist)
		dd0$new <-  dd0$new[dd0$new$year   %in% approxim$mileStoneYears & dd0$new$region  %in% approxim$region,, drop = FALSE]
		dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears & dd0$span$region %in% approxim$region,, drop = FALSE]
		obj@parameters[['mTechNew']] <- addData(obj@parameters[['mTechNew']], dd0$new)
		obj@parameters[['mTechSpan']] <- addData(obj@parameters[['mTechSpan']], dd0$span)
		obj@parameters[['mTechEac']] <- addData(obj@parameters[['mTechEac']], dd0$eac)
		
		if (nrow(dd0$new) > 0 && nrow(invcost) > 0) {
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
		  pTechEac <- salv_data[, c('tech', 'region', 'year', 'value')]
		  obj@parameters[['pTechEac']] <- addData(obj@parameters[['pTechEac']], pTechEac)
		}
		# Weather part
		merge.weather <- function(tech, nm, add = NULL) {
			waf <- tech@weather[, c('weather', add, paste0(nm, c('.lo', '.fx', '.up'))), drop = FALSE]
			waf <- waf[rowSums(!is.na(waf)) > length(add) + 1,, drop = FALSE]
			if (nrow(waf) == 0) return(NULL)
			# Map parts
			if (length(add) == 0) {
				m <- unique(waf$weather)
				m <- data.frame(tech = rep(tech@name, length(m)), weather = m)
			} else {
				m <- waf[, c('weather', add), drop = FALSE]
				m <- m[(!duplicated(apply(m, 1, paste0, collapse = '#'))),, drop = FALSE]
				m$tech <- tech@name
				m <- m[, c(ncol(m), 1:(ncol(m) - 1)), drop = FALSE]
			}
			waf20 <- data.frame(
				tech = rep(tech@name, 4 * nrow(waf)),
				weather = rep(waf$weather, 4),
				stringsAsFactors = FALSE)
			for (i in add) {
				waf20[, i] <- rep(waf[, i], 4)
			}
			waf20$type <- c(rep('lo', 2 * nrow(waf)), rep('up', 2 * nrow(waf)))
			waf20$value <- c(waf[, paste0(nm, '.lo')], waf[, paste0(nm, '.fx')], 
				waf[, paste0(nm, '.up')], waf[, paste0(nm, '.fx')])
			waf20 <- waf20[!is.na(waf20$value),, drop = FALSE]
			list(m = m, p = waf20)
		}
		tmp <- merge.weather(tech, 'waf')
		if (length(tmp) != 0) {
			obj@parameters[['mTechWeatherAf']] <- addData(obj@parameters[['mTechWeatherAf']], tmp$m)
			obj@parameters[['pTechWeatherAf']] <- addData(obj@parameters[['pTechWeatherAf']], tmp$p)
		}
		tmp <- merge.weather(tech, 'wafs')
		if (length(tmp) != 0) {
			obj@parameters[['mTechWeatherAfs']] <- addData(obj@parameters[['mTechWeatherAfs']], tmp$m)
			obj@parameters[['pTechWeatherAfs']] <- addData(obj@parameters[['pTechWeatherAfs']], tmp$p)
		}
		tmp <- merge.weather(tech, 'wafc', 'comm')
		if (length(tmp) != 0) {
			obj@parameters[['mTechWeatherAfc']] <- addData(obj@parameters[['mTechWeatherAfc']], tmp$m)
			obj@parameters[['pTechWeatherAfc']] <- addData(obj@parameters[['pTechWeatherAfc']], tmp$p)
		}
		#  cat(tech@name, '\n')
		if (all(ctype$comm$type != 'output')) 
			stop('Techology "', tech@name, '", there is not activity commodity')   
		obj
	})




