################################################################################
# Add trade
################################################################################
setMethod('.add0', signature(obj = 'modInp', app = 'trade',
	approxim = 'list'), function(obj, app, approxim) {
		trd <- energyRt:::.upper_case(app)
		trd <- stayOnlyVariable(trd, approxim$region, 'region') ## ??
		remove_duplicate <- list(c('src', 'dst'))
		approxim <- .fix_approximation_list(approxim, comm = trd@commodity)
		trd <- .disaggregateSliceLevel(trd, approxim)
		# other flag
		obj@parameters[['mTradeSlice']] <- addData(obj@parameters[['mTradeSlice']],
			data.frame(trade = rep(trd@name, length(approxim$slice)), slice = approxim$slice))
		if (length(trd@commodity) == 0) stop('There is not commodity for trade flow ', trd@name)
		obj@parameters[['mTradeComm']] <- addData(obj@parameters[['mTradeComm']],
			data.frame(trade = trd@name, comm = trd@commodity))
		obj@parameters[['mTradeRoutes']] <- addData(obj@parameters[['mTradeRoutes']],
			cbind(trade = rep(trd@name, nrow(trd@routes)), trd@routes))
		# approxim <- approxim[names(approxim) != 'region']
		approxim$region <- paste0(trd@routes$src, '##', trd@routes$dst)
		# Apply routes to approximation
		routes <- trd@routes
		imply_routes <- function(tmp) {
			# Checking user data for errors
			kk <- tmp[!is.na(tmp$src) & !is.na(tmp$dst), c('src', 'dst'), drop = FALSE]
			if (nrow(kk) > 0) {
				if (nrow(kk) != nrow(merge(kk, routes))) {
					cat('There are data for class trade "', trd@name, ' for unknown routes:\n', sep = '')
					kk$ind <- seq_len(nrow(kk))
					print(kk[kk$ind[!(kk$ind %in% merge(kk, routes))], c('src', 'dst'), drop = FALSE])
				}
			}
			# Approximation src/dst pair
			if (any(is.na(tmp$src) != is.na(tmp$dst))) {
				# src NA
				fl <- seq_len(nrow(tmp))[is.na(tmp$src) & !is.na(tmp$dst)]
				if (length(fl) > 0) {
					for (i in fl) {
						dst <- routes$dst[!(routes$dst %in% tmp[i, 'dst'])]
						if (length(dst) > 0) {
							nn <- nrow(tmp) + seq_along(dst)
							tmp <- rbind(tmp, tmp[rep(i, length(dst)),, drop = FALSE])
							tmp[nn, 'dst'] <- dst
						}
					}
					tmp <- tmp[-fl,, drop = FALSE]
				}
				# dst NA
				fl <- seq_len(nrow(tmp))[!is.na(tmp$src) & is.na(tmp$dst)]
				if (length(fl) > 0) {
					for (i in fl) {
						src <- routes$dst[!(routes$src %in% tmp[i, 'src'])]
						if (length(src) > 0) {
							nn <- nrow(tmp) + seq_along(src)
							tmp <- rbind(tmp, tmp[rep(i, length(src)),, drop = FALSE])
							tmp[nn, 'src'] <- src
						}
					}
					tmp <- tmp[-fl,, drop = FALSE]
				}
			}
			# src & dst NA
			fl <- seq_len(nrow(tmp))[is.na(tmp$src) & is.na(tmp$dst)]
			if (length(fl) > 0) {
				kk <- rbind(tmp[-fl, c('src', 'dst'), drop = FALSE], routes)
				kk <- kk[!(duplicated(kk) | duplicated(kk, fromLast = TRUE)),, drop = FALSE]
			}
			if (length(fl) > 0 && nrow(kk) > 0) {
				nn <- nrow(tmp) + seq_len(nrow(kk) * length(fl))
				tmp <- rbind(tmp, tmp[c(t(matrix(fl, length(fl), nrow(kk)))),, drop = FALSE])
				tmp[nn, 'src'] <- kk$src
				tmp[nn, 'dst'] <- kk$dst
			}
			tmp <- tmp[-fl,, drop = FALSE]
			rownames(tmp) <- NULL
			tmp
		}
		simpleInterpolation2 <- function(frm, ...) {
			if (nrow(frm) == 0) return(data.frame())
			frm <- imply_routes(frm)
			frm$region <- paste0(trd@routes$src, '##', trd@routes$dst)
			frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), drop = FALSE]
			dd <- simpleInterpolation(frm, ...)
			dd$src <- gsub('##.*', '', dd$region)
			dd$dst <- gsub('.*##', '', dd$region)
			rd <- seq_len(ncol(dd))[colnames(dd) == 'region']
			dd[, c(colnames(dd)[2:rd - 1], 'src', 'dst', colnames(dd)[(rd + 1):(ncol(dd) - 2)])]
		}
		multiInterpolation2 <- function(frm, ...) {
			if (nrow(frm) == 0) return(data.frame())
			frm <- imply_routes(frm)
			frm$region <- paste0(trd@routes$src, '##', trd@routes$dst)
			frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), drop = FALSE]
			dd <- multiInterpolation(frm, ...)
			dd$src <- gsub('##.*', '', dd$region)
			dd$dst <- gsub('.*##', '', dd$region)
			rd <- seq_len(ncol(dd))[colnames(dd) == 'region']
			dd[, c(colnames(dd)[2:rd - 1], 'src', 'dst', colnames(dd)[(rd + 1):(ncol(dd) - 2)])]
		}
		# pTradeIrCost
		obj@parameters[['pTradeIrCost']] <- addData(obj@parameters[['pTradeIrCost']],
			simpleInterpolation2(trd@trade, 'cost', obj@parameters[['pTradeIrCost']], 
				approxim, 'trade', trd@name))
		obj@parameters[['pTradeIrEff']] <- addData(obj@parameters[['pTradeIrEff']],
			simpleInterpolation2(trd@trade, 'teff', obj@parameters[['pTradeIrEff']], 
				approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
		# pTradeIrMarkup
		obj@parameters[['pTradeIrMarkup']] <- addData(obj@parameters[['pTradeIrMarkup']],
			simpleInterpolation2(trd@trade, 'markup', obj@parameters[['pTradeIrMarkup']], 
				approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
		# pTradeIr
		gg <- multiInterpolation2(trd@trade, 'ava',
			obj@parameters[['pTradeIr']], approxim, 'trade', trd@name)
		obj@parameters[['pTradeIr']] <- addData(obj@parameters[['pTradeIr']], gg)
		# Trade ainp
		if (nrow(trd@aux) != 0) {
			if (any(is.na(trd@aux$acomm))) 
				stop('Wrong aux commodity for trade "', trd@name, '"')
			trd@aeff <- trd@aeff[!is.na(trd@aeff$acomm),, drop = FALSE]
			if (!all(trd@aeff$acomm %in% trd@aux$acomm))
				stop('Wrong aux commodity for trade "', trd@name, '"')
			inp_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2ainp) | !is.na(trd@aeff$cdst2ainp), 'acomm'])
			out_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2aout) | !is.na(trd@aeff$cdst2aout), 'acomm'])
			if (length(inp_comm) != 0) obj@parameters[['mTradeIrAInp']] <- addData(obj@parameters[['mTradeIrAInp']], 
				data.frame(trade = rep(trd@name, length(inp_comm)), comm = inp_comm))
			if (length(out_comm) != 0) obj@parameters[['mTradeIrAOut']] <- addData(obj@parameters[['mTradeIrAOut']], 
				data.frame(trade = rep(trd@name, length(out_comm)), comm = out_comm))
			for (cc in inp_comm) {
				approxim$acomm <- cc
				obj@parameters[['pTradeIrCsrc2Ainp']] <- addData(
					obj@parameters[['pTradeIrCsrc2Ainp']], simpleInterpolation(trd@aeff, 'csrc2ainp', obj@parameters[['pTradeIrCsrc2Ainp']], 
						approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
				obj@parameters[['pTradeIrCdst2Ainp']] <- addData(
					obj@parameters[['pTradeIrCdst2Ainp']], simpleInterpolation(trd@aeff, 'cdst2ainp', obj@parameters[['pTradeIrCdst2Ainp']], 
						approxim, 'trade', trd@name, remove_duplicate = list('src', 'dst')))
			}
			for (cc in out_comm) {
				approxim$acomm <- cc
				obj@parameters[['pTradeIrCsrc2Aout']] <- addData(
					obj@parameters[['pTradeIrCsrc2Aout']], simpleInterpolation(trd@aeff, 'csrc2aout', obj@parameters[['pTradeIrCsrc2Aout']], 
						approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
				obj@parameters[['pTradeIrCdst2Aout']] <- addData(
					obj@parameters[['pTradeIrCdst2Aout']], simpleInterpolation(trd@aeff, 'cdst2aout', obj@parameters[['pTradeIrCdst2Aout']], 
						approxim, 'trade', trd@name, remove_duplicate = remove_duplicate))
			}
		}
		# Add trade data
		if (trd@capacityVariable) {
			obj@parameters[['pTradeCap2Act']] <- addData(obj@parameters[['pTradeCap2Act']],
				data.frame(trade = trd@name, value = trd@cap2act))
			
			obj@parameters[['mTradeCapacityVariable']] <- addData(obj@parameters[['mTradeCapacityVariable']], data.frame(trade = trd@name))
			
			##!!! Trade 
			if (nrow(trd@invcost) > 0) {
				if (any(is.na(trd@invcost$invcost)) && nrow(trd@invcost) > 1)
					stop('There is "NA" and other data for invcost in trade class "', trd@name, '".')
				if (any(is.na(trd@invcost$invcost))) {
					warning('There is a" NA "area for invcost in the"', trd@name, '"trade class. Investments will be smoothed along all routes of the regions.')
					rgg <- unique(c(trd@routes, recursive = TRUE))
					trd@invcost <- trd@invcost[rep(1, length(rgg)),, drop = FALSE]
					trd@invcost[, 'region'] <- rgg
					trd@invcost[, 'region'] <- trd@invcost[1, 'invcost'] / length(rgg)
				}
			}
			dd <- data.frame(list = c('pTradeInvcost', 'pTradeStock'),
				table = c('invcost', 'stock'),
				stringsAsFactors = FALSE)
			for(i in 1:nrow(dd)) {
				obj@parameters[[dd[i, 'list']]] <- addData(obj@parameters[[dd[i, 'list']]],
					simpleInterpolation(slot(trd, dd[i, 'table']),
						dd[i, 'table'], obj@parameters[[dd[i, 'list']]], approxim, 'trade', trd@name))
			}
			obj@parameters[['pTradeOlife']] <- addData(obj@parameters[['pTradeOlife']],
				simpleInterpolation(slot(trd, 'olife'),
					'olife', obj@parameters[['pTradeOlife']], approxim, 'trade', trd@name, removeDefault = FALSE))
			stock_exist <- getParameterData(obj@parameters[["pTradeStock"]])[, c('trade', 'src', 'dst', 'year')]
			dd0 <- list()
			dd0$new <- merge(merge(approxim$src, approxim$dst), approxim$mileStoneYears, by = NULL)
			colnames(dd0$new) <- c('src', 'dst', 'year')
			for (yr in seq_len(nrow(trd@start))) {
				if (is.na(trd@start$src[i])) src <- approxim$src
				if (is.na(trd@start$dst[i])) dst <- approxim$dst
				dd0$new <- dd0$new[!(dd0$new$src %in% src) | !(dd0$new$dst %in% dst) | dd0$new$year >= trd@start[i, 'year'],, drop = FALSE]
			}
			for (yr in seq_len(nrow(trd@end))) {
				if (is.na(trd@end$src[i])) src <- approxim$src
				if (is.na(trd@end$dst[i])) dst <- approxim$dst
				dd0$new <- dd0$new[!(dd0$new$src %in% src) | !(dd0$new$dst %in% dst) | dd0$new$year < trd@end[i, 'year'],, drop = FALSE]
			}
			dd0$new$trade <- trd@name; dd0$new <- dd0$new[, c('trade', 'src', 'dst', 'year')]
			dd0$old <- rbind(dd0$new, stock_exist)
			dd0$old <- dd0$old[!duplicated(dd0$old),, drop = FALSE]	
			obj@parameters[['mTradeNew']] <- addData(obj@parameters[['mTradeNew']], dd0$new)
			obj@parameters[['mTradeSpan']] <- addData(obj@parameters[['mTradeSpan']], dd0$old)    	
			# mTradeOlifeInf				    		 
			olife <- simpleInterpolation(trd@olife, 'olife', obj@parameters$pTradeOlife, approxim, 'trade', trd@name, removeDefault = FALSE)
			mTradeOlifeInf <- olife
			mTradeOlifeInf <- mTradeOlifeInf[mTradeOlifeInf$value == Inf, colnames(mTradeOlifeInf) != 'value']
			obj@parameters[['mTradeOlifeInf']] <- addData(obj@parameters[['mTradeOlifeInf']], mTradeOlifeInf)
			## Salvage parameter
			tmp <- merge(dd0$new, olife, by = c('trade', 'src', 'dst'))
			end_year <- max(approxim$year)
			tmp <- tmp[tmp$year + tmp$value > end_year, ]
			tmp2 <- tmp[, c('trade', 'src', 'dst')]
			mTradeSalv <- tmp2[!duplicated(tmp2), ]
			if (nrow(mTradeSalv) > 0) {
				discountCum <- approxim$discountCum
				discountFactor <- approxim$discountFactor
				discount <- approxim$discount
				discountCum$src <- discountCum$region
				discountFactor$src <- discountFactor$region
				discount$src <- discount$region
				discountCum$region <- NULL
				discountFactor$region <- NULL
				discount$region <- NULL
				
				obj@parameters[['mTradeSalv']] <- addData(obj@parameters[['mTradeSalv']], mTradeSalv)
				# pTradeSalv calculation
				tmp2 <- tmp; tmp2$life <- tmp2$value; tmp2$value <- NULL
				tmp2 <- merge(tmp2, discountCum, by = c('src', 'year'))
				# Calculate
				tmp3 <- merge(merge(
					discount[discount$year == end_year, c('src', 'value')], 
					discountCum[discountCum$year == end_year, c('src', 'value')], 
					by = 'src'),
					discountFactor[discountFactor$year == end_year, c('src', 'value')], 
					by = 'src')
				tmp3$value <- tmp3$value / (1 + tmp3$value.x) + tmp3$value.y
				tmp3 <- tmp3[, c('src', 'value')]
				tmp2 <- merge(tmp2, tmp3, 'src')
				tmp2$s1 <- tmp2$value.y - tmp2$value.x; tmp2$value.y <- NULL; tmp2$value.x <- NULL
				# tmp2$s1 = sum_y 1 ^ rest 1 / (1 + r) ^ y
				tmp2$rest <- (tmp2$life - (end_year - tmp2$year) - 1)
				tmp2 <- merge(tmp2, discount[discount$year == end_year, c('src', 'value')], by = 'src')
				tmp2$fin_dsc <- tmp2$value; tmp2$value <- NULL
				tmp2$s2 <- 0
				fl <- (tmp2$fin_dsc == 0)
				if (any(fl)) {
					tmp2[fl, 's2'] <- tmp2[fl, 'rest']
				} 
				if (any(!fl)) {
					tmp2[!fl, 's2'] <- ((1 + tmp2[!fl, 'fin_dsc']) ^ (-tmp2[!fl, 'rest']) - 1) / (1 / (1 + tmp2[!fl, 'fin_dsc']) - 1)
				} 
				tmp2 <- merge(tmp2, discountFactor[discountFactor$year == end_year, c('src', 'value')], by = 'src')
				tmp2$s2 <- (tmp2$s2 * tmp2$value / (tmp2$fin_dsc + 1)); tmp2$fn_factor <- tmp2$value;  tmp2$value <- NULL
				# tmp2$s2 = sum_y rest ^ life 1 / (1 + r) ^ y
				tmp2$value <- tmp2$s1 / (tmp2$s1 + tmp2$s2) - 1
				
				tmp2 <- merge(tmp2, discountFactor, by = c('src', 'year'))
				tmp2$value <- tmp2$value.x * tmp2$value.y / tmp2$fn_factor
				obj@parameters[['pTradeSalv']] <- addData(obj@parameters[['pTradeSalv']], tmp2[, c('trade', 'src', 'dst', 'year', 'value')])
			}
		}
		
		
		
		
		# .Object@parameters[['mTradeSalv']] <- createParameter('mTradeSalv', c('trade', 'region', 'region'), 'map', cls = 'trade')    
		# 
		# .Object@parameters[['pTradeSalv']] <- createParameter('pTradeSalv', 
		# 	c('trade', 'region', 'region', 'year'), 'simple', 
		# 	defVal = 0, interpolation = 'back.inter.forth', colName = '', cls = 'trade')    
		
		# mTradeSpan(trade, region, region, year)
		# mTradeNew(trade, region, region, year)
		# mTradeOlifeInf(trade, region, region)
		# mTradeSalv(trade, region, region)
		# 
		# pTradeStock(trade, region, region, year)
		# pTradeOlife(trade, region, region)
		# pTradeInvcost(trade, region, region, year)
		# pTradeSalv(trade, region, region, year)
		# mCapacityVariable(trade)
		obj
	})


