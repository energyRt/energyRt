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
		mTechSlice <- data.frame(tech = rep(tech@name, length(approxim$slice)), slice = approxim$slice, 
		                         stringsAsFactors = FALSE)
		obj@parameters[['mTechSlice']] <- addData(obj@parameters[['mTechSlice']], mTechSlice)
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
		  pTechCvarom <- simpleInterpolation(tech@varom, 'cvarom',
		                                     obj@parameters[['pTechCvarom']], approxim_comm, 'tech', tech@name, remValue = 0)
			obj@parameters[['pTechCvarom']] <- addData(obj@parameters[['pTechCvarom']], pTechCvarom)
				
		} else pTechCvarom <- NULL
		approxim_acomm <- approxim
		approxim_acomm[['acomm']] <- rownames(ctype$aux)
		if (length(approxim_acomm[['acomm']]) != 0) {
		  pTechAvarom <- simpleInterpolation(tech@varom, 'avarom',
          obj@parameters[['pTechAvarom']], approxim_acomm, 'tech', tech@name, remValue = 0)
			obj@parameters[['pTechAvarom']] <- addData(obj@parameters[['pTechAvarom']], pTechAvarom)
		} else pTechAvarom <- NULL
		approxim_comm[['comm']] <- rownames(ctype$comm)
		if (length(approxim_comm[['comm']]) != 0) {
		  pTechAfc <- multiInterpolation(tech@ceff, 'afc',
				obj@parameters[['pTechAfc']], approxim_comm, 'tech', tech@name, remValueUp = Inf, remValueLo = 0)
			obj@parameters[['pTechAfc']] <- addData(obj@parameters[['pTechAfc']], pTechAfc)
			#gg <- gg[gg$type == 'up' & gg$value == Inf, ]
			#if (nrow(gg) != 0) 
			#  obj@parameters[['ndefpTechAfcUp']] <- addData(obj@parameters[['dnefpTechAfcUp']],
			#        gg[, obj@parameters[['ndefpTechAfcUp']]@dimSetNames])
			
		} else pTechAfc <- NULL
		
		# Stock & Capacity
		stock_exist <- simpleInterpolation(tech@stock, 'stock', obj@parameters[['pTechStock']], approxim, 'tech', tech@name)
		obj@parameters[['pTechStock']] <- addData(obj@parameters[['pTechStock']], stock_exist)
		olife <- simpleInterpolation(tech@olife, 'olife', obj@parameters[['pTechOlife']], approxim, 'tech', tech@name, removeDefault = FALSE)
		obj@parameters[['pTechOlife']] <- addData(obj@parameters[['pTechOlife']], olife)		
		
		dd0 <- energyRt:::.start_end_fix(approxim, tech, 'tech', stock_exist)
		dd0$new <-  dd0$new[dd0$new$year   %in% approxim$mileStoneYears & dd0$new$region  %in% approxim$region,, drop = FALSE]
		dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears & dd0$span$region %in% approxim$region,, drop = FALSE]
		obj@parameters[['mTechNew']] <- addData(obj@parameters[['mTechNew']], dd0$new)

		invcost <- simpleInterpolation(tech@invcost, 'invcost', obj@parameters[['pTechInvcost']], approxim, 'tech', tech@name)
		if (!is.null(invcost)) invcost <- merge(dd0$new, invcost)
		obj@parameters[['mTechInv']] <- addData(obj@parameters[['mTechInv']], invcost[, colnames(invcost) != 'value'])
		obj@parameters[['pTechInvcost']] <- addData(obj@parameters[['pTechInvcost']], invcost)
		
		obj@parameters[['mTechSpan']] <- addData(obj@parameters[['mTechSpan']], dd0$span)
		obj@parameters[['mTechEac']] <- addData(obj@parameters[['mTechEac']], dd0$eac)
	
		if (nrow(dd0$new) > 0 && !is.null(invcost)) {
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
		pTechAf <- multiInterpolation(tech@af, 'af',
			obj@parameters[['pTechAf']], approxim, 'tech', tech@name, remValueUp = Inf, remValueLo = 0)
		obj@parameters[['pTechAf']] <- addData(obj@parameters[['pTechAf']], pTechAf)
		if (nrow(tech@afs) > 0) {
			afs_slice <- unique(tech@afs$slice)
			afs_slice <- afs_slice[!is.na(afs_slice)]
			approxim.afs <- approxim
			approxim.afs$slice <- afs_slice
			pTechAfs <- multiInterpolation(tech@afs, 'afs', obj@parameters[['pTechAfs']], approxim.afs, 'tech', 
			  tech@name, remValueUp = Inf, remValueLo = 0)
			obj@parameters[['pTechAfs']] <- addData(obj@parameters[['pTechAfs']], pTechAfs)
		} else pTechAfs <- NULL
		#gg <- gg[gg$type == 'up' & gg$value == Inf, ]
		#if (nrow(gg) != 0) 
		#    obj@parameters[['ndefpTechAfUp']] <- addData(obj@parameters[['ndefpTechAfUp']],
		#          gg[, obj@parameters[['ndefpTechAfUp']]@dimSetNames])

		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input' & is.na(ctype$comm[, 'group'])]
		if (length(approxim_comm[['comm']]) != 0) {
		  pTechCinp2use <- simpleInterpolation(tech@ceff, 'cinp2use',
		                                       obj@parameters[['pTechCinp2use']], approxim_comm, 'tech', tech@name)
			obj@parameters[['pTechCinp2use']] <- addData(obj@parameters[['pTechCinp2use']], pTechCinp2use)
		} else pTechCinp2use <- NULL
		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'output']
		if (length(approxim_comm[['comm']]) != 0) {
		  pTechUse2cact <- simpleInterpolation(tech@ceff, 'use2cact',
		                                       obj@parameters[['pTechUse2cact']], approxim_comm, 'tech', tech@name)
			obj@parameters[['pTechUse2cact']] <- addData(obj@parameters[['pTechUse2cact']],  pTechUse2cact)
			pTechCact2cout <- 	simpleInterpolation(tech@ceff, 'cact2cout',
			                                       obj@parameters[['pTechCact2cout']], approxim_comm, 'tech', tech@name)
			obj@parameters[['pTechCact2cout']] <- addData(obj@parameters[['pTechCact2cout']], pTechCact2cout)
			if (any(!is.na(tech@ceff$cact2cout) & (tech@ceff$cact2cout == 0 | tech@ceff$cact2cout == Inf)))
				stop('cact2cout is not correct ', tech@name)
			if (any(!is.na(tech@ceff$use2cact) & (tech@ceff$use2cact == 0 | tech@ceff$use2cact == Inf)))
				stop('use2cact is not correct ', tech@name)
		} else {pTechUse2cact <- NULL; pTechCact2cout <- NULL;}
		approxim_comm[['comm']] <- rownames(ctype$comm)[ctype$comm$type == 'input' & !is.na(ctype$comm[, 'group'])]
		if (length(approxim_comm[['comm']]) != 0) {
		  pTechCinp2ginp <- simpleInterpolation(tech@ceff, 'cinp2ginp',
		                      obj@parameters[['pTechCinp2ginp']], approxim_comm, 'tech', tech@name)
			obj@parameters[['pTechCinp2ginp']] <- addData(obj@parameters[['pTechCinp2ginp']], pTechCinp2ginp)
		} else pTechCinp2ginp <- NULL
		if (tech@early.retirement) 
			obj@parameters[['mTechRetirement']] <- addData(obj@parameters[['mTechRetirement']], data.frame(tech = tech@name))
		if (length(tech@upgrade.technology) != 0)
			obj@parameters[['mTechUpgrade']] <- addData(obj@parameters[['mTechUpgrade']], 
				data.frame(tech = rep(tech@name, length(tech@upgrade.technology)), techp = tech@upgrade.technology))
		cmm <- rownames(ctype$comm)[ctype$comm$type == 'input'] 
		if (length(cmm) != 0) {
		  mTechInpComm <- data.frame(tech = rep(tech@name, length(cmm)), comm = cmm)
			obj@parameters[['mTechInpComm']] <- addData(obj@parameters[['mTechInpComm']], mTechInpComm)
		} else mTechInpComm <- NULL
		cmm <- rownames(ctype$comm)[ctype$comm$type == 'output']
		if (length(cmm) != 0) {
		  mTechOutComm <- data.frame(tech = rep(tech@name, length(cmm)), comm = cmm)
			obj@parameters[['mTechOutComm']] <- addData(obj@parameters[['mTechOutComm']], mTechOutComm)
		} else mTechOutComm <- NULL
		cmm <- rownames(ctype$comm)[is.na(ctype$comm$group)] 
		if (length(cmm) != 0) {
		  mTechOneComm <- data.frame(tech = rep(tech@name, length(cmm)), comm = cmm)
			obj@parameters[['mTechOneComm']] <- addData(obj@parameters[['mTechOneComm']], mTechOneComm)
		} else mTechOneComm <- NULL
		approxim_comm[['comm']] <- rownames(ctype$comm)[!is.na(ctype$comm$group)]
		if (length(approxim_comm[['comm']]) != 0) {
		  pTechShare <- multiInterpolation(tech@ceff, 'share',
        obj@parameters[['pTechShare']], approxim_comm, 'tech', tech@name, remValueUp = 1, remValueLo = 0)
      obj@parameters[['pTechShare']] <- addData(obj@parameters[['pTechShare']], pTechShare)
		} else pTechShare <- NULL
		cmm <- rownames(ctype$comm)[ctype$comm$comb != 0]
		if (length(cmm) != 0) {
			obj@parameters[['pTechEmisComm']] <- addData(obj@parameters[['pTechEmisComm']],
				data.frame(tech = rep(tech@name, nrow(ctype$comm)), comm = rownames(ctype$comm),
					value = ctype$comm$comb))
		} 
		gpp <- rownames(ctype$group)[ctype$group$type == 'input']
		if (length(gpp) != 0) {
		  mTechInpGroup <- data.frame(tech = rep(tech@name, length(gpp)), group = gpp)
			obj@parameters[['mTechInpGroup']] <- addData(obj@parameters[['mTechInpGroup']], mTechInpGroup)
		} else mTechInpGroup <- NULL
		gpp <- rownames(ctype$group)[ctype$group$type == 'output']
		if (length(gpp) != 0) {
		  mTechOutGroup <- data.frame(tech = rep(tech@name, length(gpp)), group = gpp)
			obj@parameters[['mTechOutGroup']] <- addData(obj@parameters[['mTechOutGroup']], mTechOutGroup)
		} else mTechOutGroup <- NULL
		approxim_group <- approxim
		approxim_group[['group']] <- rownames(ctype$group)[ctype$group$type == 'input']
		if (length(approxim_group[['group']]) != 0) {
		  pTechGinp2use <- simpleInterpolation(tech@geff, 'ginp2use',
        obj@parameters[['pTechGinp2use']], approxim_group, 'tech', tech@name)
			obj@parameters[['pTechGinp2use']] <- addData(obj@parameters[['pTechGinp2use']], pTechGinp2use)
		} else pTechGinp2use <- NULL
		if (nrow(ctype$group) > 0)
			obj@parameters[['group']] <- addMultipleSet(obj@parameters[['group']], rownames(ctype$group))
		fl <- !is.na(ctype$comm$group)
		if (any(fl)) {
		  mTechGroupComm <- data.frame(tech = rep(tech@name, sum(fl)), group = ctype$comm$group[fl], 
				comm = rownames(ctype$comm)[fl], stringsAsFactors = FALSE)
			obj@parameters[['mTechGroupComm']] <- addData(obj@parameters[['mTechGroupComm']], mTechGroupComm)
		} else mTechGroupComm <- NULL
		if (any(ctype$aux$output)) {    
			cmm <- rownames(ctype$aux)[ctype$aux$output]
			mTechAOut <- data.frame(tech = rep(tech@name, length(cmm)), comm = cmm)
			obj@parameters[['mTechAOut']] <- addData(obj@parameters[['mTechAOut']], mTechAOut)
		} else mTechAOut <- NULL
		if (any(ctype$aux$input)) {    
			cmm <- rownames(ctype$aux)[ctype$aux$input]
			mTechAInp <- data.frame(tech = rep(tech@name, length(cmm)), comm = cmm)
			obj@parameters[['mTechAInp']] <- addData(obj@parameters[['mTechAInp']], mTechAInp)
		} else mTechAInp <- NULL
              
	
		# simple & multi
		obj@parameters[['pTechCap2act']] <- addData(obj@parameters[['pTechCap2act']],
			data.frame(tech = tech@name, value = tech@cap2act))
		pTechFixom <- simpleInterpolation(tech@fixom, 'fixom', obj@parameters[['pTechFixom']], approxim, 'tech', tech@name)
		obj@parameters[['pTechFixom']] <- addData(obj@parameters[['pTechFixom']], pTechFixom)
		pTechVarom <- simpleInterpolation(tech@varom, 'varom', obj@parameters[['pTechVarom']], approxim, 'tech', tech@name)
		obj@parameters[['pTechVarom']] <- addData(obj@parameters[['pTechVarom']], pTechVarom)

	
		## Move from reduce 
		
	  mTechNew = dd0$new
	  mTechSpan = dd0$span
	  pTechOlife = olife
	  if (tech@early.retirement) {
	    obj@parameters[['mvTechRetiredStock']] <- addData(obj@parameters[['mvTechRetiredStock']], 
	                                                         stock_exist[stock_exist$value != 0, colnames(stock_exist) != 'value'])
	    
	  }
	  if (nrow(dd0$new) > 0 && tech@early.retirement) {
	    obj@parameters[['meqTechRetiredNewCap']] <- addData(obj@parameters[['meqTechRetiredNewCap']], mTechNew)
	    
	    
	    mvTechRetiredCap0 <- merge(merge(mTechNew, mTechSpan, by = c('tech', 'region')), 
	                               pTechOlife, by = c('tech', 'region'))
	    mvTechRetiredCap0 <- mvTechRetiredCap0[(
	      mvTechRetiredCap0$year.x + mvTechRetiredCap0$olife > mvTechRetiredCap0$year.y &
	                                              mvTechRetiredCap0$year.x <= mvTechRetiredCap0$year.y), -5] 
	    colnames(mvTechRetiredCap0)[3:4] <- c('year', 'year.1')
	    obj@parameters[['mvTechRetiredNewCap']] <- addData(obj@parameters[['mvTechRetiredNewCap']], 
	                                                     mvTechRetiredCap0)
	  }
	  mvTechAct <- merge(mTechSpan, mTechSlice, by = 'tech')
	  obj@parameters[['mvTechAct']] <- addData(obj@parameters[['mvTechAct']], mvTechAct)
	 # Stay only variable with non zero output
	 merge_table <- function(mvTechInp, pTechCinp2use) {
	    if (is.null(pTechCinp2use) || nrow(pTechCinp2use) == 0) return(NULL)
	    return(merge(mvTechInp, pTechCinp2use[pTechCinp2use$value != 0 & pTechCinp2use$value != Inf, colnames(pTechCinp2use) != 'value']))
	 }
	 merge_table2 <- function(mvTechInp, pTechCinp2use, pTechCinp2ginp) {
	    tmp <- rbind(merge_table(mvTechInp, pTechCinp2use), merge_table(mvTechInp, pTechCinp2ginp))
	    tmp[!duplicated(tmp),, drop = FALSE]
	 }	 
	  if (!is.null(mTechInpComm)) {
	    mvTechInp <- merge(mvTechAct, mTechInpComm, by = 'tech')
	 		mvTechInp <- merge_table2(mvTechInp, pTechCinp2use, pTechCinp2ginp)
	    obj@parameters[['mvTechInp']]  <- addData(obj@parameters[['mvTechInp']], mvTechInp)
	  } else mvTechInp <- NULL
	  if (!is.null(mTechOutComm)) {
	    mvTechOut <-  merge(mvTechAct, mTechOutComm, by = 'tech')
	    obj@parameters[['mvTechOut']]  <- addData(obj@parameters[['mvTechOut']], mvTechOut)
	  } else mvTechOut <- NULL
	  if (!is.null(mTechAInp)) {
	    mvTechAInp <- merge(mvTechAct, mTechAInp, by = 'tech')
	    obj@parameters[['mvTechAInp']] <- addData(obj@parameters[['mvTechAInp']], mvTechAInp)
	  } else mvTechAInp <- NULL
	  if (!is.null(mTechAOut)) {
	    mvTechAOut <- merge(mvTechAct, mTechAOut, by = 'tech')
	    obj@parameters[['mvTechAOut']] <- addData(obj@parameters[['mvTechAOut']], mvTechAOut)
	  } else mvTechAOut <- NULL

	 #### aeff begin
		if (nrow(tech@aeff) != 0) {
			if (any(is.na(tech@aeff$acomm)))
				stop(paste0('NA value in column acomm is forbidden in the slot aeff ', tech@name))
			if (any(is.na(tech@aeff[apply(!is.na(tech@aeff[, c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout'), drop = FALSE]), 1, any), 'comm'])))
				stop(paste0('NA value in column  comm is forbidden in the slot aeff ', tech@name))
			for(i in 1:4) {
				tech@aeff <- tech@aeff[!is.na(tech@aeff$acomm),]
				ll <- c('cinp2ainp', 'cinp2aout', 'cout2ainp', 'cout2aout')[i]
				tbl <- c('pTechCinp2AInp', 'pTechCinp2AOut', 'pTechCout2AInp', 'pTechCout2AOut')[i]
				tbl2 <- c('mTechCinp2AInp', 'mTechCinp2AOut', 'mTechCout2AInp', 'mTechCout2AOut')[i]
				yy <- tech@aeff[!is.na(tech@aeff[, ll]), ]
				if (nrow(yy) != 0) {
					approxim_commp <- approxim
					approxim_commp$acomm <- unique(yy$acomm);
					approxim_commp$comm <- unique(yy$comm)
					tmp <- simpleInterpolation(yy, ll, obj@parameters[[tbl]], approxim_commp, 'tech', tech@name);
					tmp <- tmp[tmp$value != 0, ]
					if (nrow(tmp) > 0) {
						obj@parameters[[tbl]] <- addData(obj@parameters[[tbl]], tmp)
						tmp$value <- NULL
						if (!all(c("tech", "acomm", "comm", "region", "year", "slice") %in% colnames(tmp))) {
							if (i %in% c(1, 3)) tmp <- merge(tmp, mvTechInp) else tmp <- merge(tmp, mvTechOut)
						}
						tmp$comm.1 <- tmp$comm; tmp$comm <- tmp$acomm; tmp$acomm <- NULL;
						obj@parameters[[tbl2]] <- addData(obj@parameters[[tbl2]], tmp)
					}
				}
			}
		}
	 	dd <- data.frame(list = c('pTechAct2AOut', 'pTechCap2AOut', 'pTechNCap2AOut', 
			'pTechAct2AInp', 'pTechCap2AInp', 'pTechNCap2AInp'),
			table = c('act2aout', 'cap2aout', 'ncap2aout', 'act2ainp', 'cap2ainp', 'ncap2ainp'),
			tab2 = c('mTechAct2AOut', 'mTechCap2AOut', 'mTechNCap2AOut', 'mTechAct2AInp', 'mTechCap2AInp', 'mTechNCap2AInp'),
			stringsAsFactors = FALSE)

		for(i in 1:nrow(dd)) {
			approxim_comm <- approxim_comm[names(approxim_comm) != 'comm']
			approxim_comm[['acomm']] <- unique(tech@aeff[!is.na(tech@aeff[, dd[i, 'table']]), 'acomm'])
			if (length(approxim_comm[['acomm']]) != 0) {
				tmp <- simpleInterpolation(tech@aeff, dd[i, 'table'], obj@parameters[[dd[i, 'list']]], approxim_comm, 'tech', tech@name)		
				obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]], tmp)
				if (!all(c("tech", "acomm", "region", "year", "slice") %in% colnames(tmp))) {
					if (i <= 3) ll <- mvTechInp else ll <- mvTechOut;
					ll$comm <- NULL
					tmp <- merge(tmp, ll)
				}
				tmp$comm <- tmp$acomm; tmp$acomm <- NULL;
				obj@parameters[[dd[i, 'tab2']]] <- addData(obj@parameters[[dd[i, 'tab2']]], tmp)
			}
		}  
	 #### aeff end
	  if (!is.null(mTechInpGroup) && !is.null(mTechOutGroup)) {
	    meqTechGrp2Grp <- merge(merge(mTechInpGroup, mTechOutGroup, by =  'tech', suffix = c('', '.1')), 
	          mvTechAct)[, c('tech', 'region', 'group', 'group.1', 'year', 'slice')]
	    obj@parameters[['meqTechGrp2Grp']] <- addData(obj@parameters[['meqTechGrp2Grp']], meqTechGrp2Grp)
	  } else meqTechGrp2Grp <- NULL
	  if (!is.null(mTechInpGroup) || !is.null(mTechOutGroup)) {
	    mpTechShareLo <- pTechShare[pTechShare$type == 'lo' & pTechShare$value > 0, colnames(pTechShare) != 'value']
	    mpTechShareUp <- pTechShare[pTechShare$type == 'up' & pTechShare$value < 1, colnames(pTechShare) != 'value']
	  } else {mpTechShareUp <- NULL; mpTechShareLo <- NULL;}
	  
	  if (!is.null(mvTechOut) && !is.null(mTechOutGroup) && !is.null(mTechGroupComm)) {
	    techGroupOut <- merge(merge(mvTechOut, mTechOutGroup), mTechGroupComm)
	  } else techGroupOut <- NULL
	  if (!is.null(mvTechInp) && !is.null(mTechInpGroup) && !is.null(mTechGroupComm)) {
	    techGroupInp <- merge(merge(mvTechInp, mTechInpGroup), mTechGroupComm)
	  } else techGroupInp <- NULL
	  if (!is.null(mvTechInp) && !is.null(mTechOneComm)) {
	    techSingInp <- merge(mvTechInp, mTechOneComm);
	    if (!is.null(pTechCinp2use)) techSingInp <- merge(techSingInp, pTechCinp2use[pTechCinp2use$value != 0, colnames(pTechCinp2use) %in% colnames(techSingInp), drop = FALSE])
	    if (nrow(techSingInp) == 0) techSingInp <- NULL
	  } else techSingInp <- NULL
	  if (!is.null(mvTechOut) && !is.null(mTechOneComm)) {
	    techSingOut <- merge(mvTechOut, mTechOneComm);
	    if (!is.null(pTechCact2cout)) techSingOut <- merge(techSingOut, pTechCact2cout[pTechCact2cout$value != 0, colnames(pTechCact2cout) %in% colnames(techSingOut), drop = FALSE])
	    if (nrow(techSingOut) == 0) techSingOut <- NULL
	  } else techSingOut <- NULL
	  if (!is.null(mTechInpGroup) && !is.null(techSingOut)) {
	    meqTechGrp2Sng <- merge(mTechInpGroup, techSingOut)
	    obj@parameters[['meqTechGrp2Sng']] <- addData(obj@parameters[['meqTechGrp2Sng']], meqTechGrp2Sng)
	  } else meqTechGrp2Sng <- NULL
	  if (!is.null(mTechOutGroup) && !is.null(techSingInp)) {
	    meqTechSng2Grp <- merge(mTechOutGroup, techSingInp)
	    obj@parameters[['meqTechSng2Grp']] <- addData(obj@parameters[['meqTechSng2Grp']], meqTechSng2Grp)
	  } else meqTechSng2Grp <- NULL
  
	  if (!is.null(techSingInp) && !is.null(techSingOut)) {
	    meqTechSng2Sng <- merge(techSingInp, techSingOut, by = c('tech', 'region', 'year', 'slice'), suffixes = c("",".1"))
	    obj@parameters[['meqTechSng2Sng']] <- addData(obj@parameters[['meqTechSng2Sng']], meqTechSng2Sng)
	  } else meqTechSng2Sng <- NULL
	  if (!is.null(mpTechShareLo) && !is.null(techGroupOut)) {
	    meqTechShareOutLo <- merge(mpTechShareLo, techGroupOut)
	    obj@parameters[['meqTechShareOutLo']] <- addData(obj@parameters[['meqTechShareOutLo']], 
	                                                     meqTechShareOutLo[, obj@parameters[['meqTechShareOutLo']]@dimSetNames])
	  } else meqTechShareOutLo <- NULL
	  if (!is.null(mpTechShareUp) && !is.null(techGroupOut)) {
	    meqTechShareOutUp <- merge(mpTechShareUp, techGroupOut)
	    obj@parameters[['meqTechShareOutUp']] <- addData(obj@parameters[['meqTechShareOutUp']], 
	                                                     meqTechShareOutUp[, obj@parameters[['meqTechShareOutUp']]@dimSetNames])
	  } else meqTechShareOutUp <- NULL
	  
	  if (!is.null(mpTechShareLo) && !is.null(techGroupInp)) {
	    meqTechShareInpLo <- merge(mpTechShareLo, techGroupInp)
	    obj@parameters[['meqTechShareInpLo']] <- addData(obj@parameters[['meqTechShareInpLo']], 
	                                                     meqTechShareInpLo[, obj@parameters[['meqTechShareInpLo']]@dimSetNames])
	  } else meqTechShareInpLo <- NULL
	  if (!is.null(mpTechShareUp) && !is.null(techGroupInp)) {
	    meqTechShareInpUp <- merge(mpTechShareUp, techGroupInp)
	    obj@parameters[['meqTechShareInpUp']] <- addData(obj@parameters[['meqTechShareInpUp']], 
	                                                     meqTechShareInpUp[, obj@parameters[['meqTechShareInpUp']]@dimSetNames])
	  } else meqTechShareInpUp <- NULL
	  
 	 ####
	  outer_inf <- function(mvTechAct, pTechAf) {
	  	merge(mvTechAct, pTechAf[pTechAf$value == Inf & pTechAf$type == 'up',
	                                                    colnames(pTechAf) %in% colnames(mvTechAct)])
	  }
	  if (!is.null(pTechAf) && any(pTechAf$value != 0 & pTechAf$type == 'lo')) {
	    obj@parameters[['meqTechAfLo']] <- addData(obj@parameters[['meqTechAfLo']],
	            merge(mvTechAct, pTechAf[pTechAf$value != 0 & pTechAf$type == 'lo', colnames(pTechAf)[colnames(pTechAf) %in% colnames(mvTechAct)]]))
	  }
    obj@parameters[['meqTechAfUp']] <- addData(obj@parameters[['meqTechAfUp']], outer_inf(mvTechAct, pTechAf))
	  if (!is.null(pTechAfs)) {
	    obj@parameters[['meqTechAfsLo']] <- addData(obj@parameters[['meqTechAfsLo']],
	              merge(mTechSpan, pTechAfs[pTechAfs$value != 0 & pTechAfs$type == 'lo', 
	              	colnames(pTechAfs)[colnames(pTechAfs) %in% colnames(mTechSpan)]]))
	    meqTechAfsUp <- merge(mTechSpan, 
	      pTechAfs[pTechAfs$value != Inf & pTechAfs$type == 'up', obj@parameters[['meqTechAfsUp']]@dimSetNames])
	    obj@parameters[['meqTechAfsUp']] <- addData(obj@parameters[['meqTechAfsUp']], meqTechAfsUp)
	  }
	if (!is.null(techSingOut)) {
	    obj@parameters[['meqTechActSng']] <- addData(obj@parameters[['meqTechActSng']], techSingOut)
	  } else meqTechActSng <- NULL
	  if (!is.null(mTechOutGroup)) {
	    obj@parameters[['meqTechActGrp']] <- addData(obj@parameters[['meqTechActGrp']], merge(mvTechAct, mTechOutGroup))
	  } else meqTechActGrp <- NULL
	  
	  if (!is.null(pTechAfc)) {
	    obj@parameters[['meqTechAfcOutLo']] <- addData(obj@parameters[['meqTechAfcOutLo']],
	                        merge(mvTechOut, pTechAfc[pTechAfc$value != 0 & pTechAfc$type == 'lo', obj@parameters[['meqTechAfcOutLo']]@dimSetNames]))
	    obj@parameters[['meqTechAfcOutUp']] <- addData(obj@parameters[['meqTechAfcOutUp']],
	                       merge(mvTechOut, pTechAfc[pTechAfc$value != Inf & pTechAfc$type == 'up', obj@parameters[['meqTechAfcOutLo']]@dimSetNames]))
	    obj@parameters[['meqTechAfcInpLo']] <- addData(obj@parameters[['meqTechAfcInpLo']],
	                      merge(mvTechInp, pTechAfc[pTechAfc$value != 0 & pTechAfc$type == 'lo', obj@parameters[['meqTechAfcOutLo']]@dimSetNames]))
	    obj@parameters[['meqTechAfcInpUp']] <- addData(obj@parameters[['meqTechAfcInpUp']],
	                     merge(mvTechInp, pTechAfc[pTechAfc$value != Inf & pTechAfc$type == 'up', obj@parameters[['meqTechAfcOutLo']]@dimSetNames]))
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
		# mTechOMCost(tech, region, year) 
		
	mTechOMCost <- NULL
		add_omcost <- function(mTechOMCost, pTechFixom) {
			if (is.null(pTechFixom)) return(mTechOMCost) 
			return(rbind(mTechOMCost, merge(mvTechAct, pTechFixom[pTechFixom$value != 0, colnames(pTechFixom) %in% colnames(pTechFixom), drop = FALSE])))
		}
		mTechOMCost <- add_omcost(mTechOMCost, pTechFixom)
		mTechOMCost <- add_omcost(mTechOMCost, pTechVarom)
		mTechOMCost <- add_omcost(pTechAvarom, pTechCvarom)
		
		if (!is.null(mTechOMCost)) {
  		mTechOMCost <- merge(mTechOMCost[!duplicated(mTechOMCost), ], mTechSpan)
  		obj@parameters[['mTechOMCost']] <- addData(obj@parameters[['mTechOMCost']], mTechOMCost)
		}
		obj
	})




