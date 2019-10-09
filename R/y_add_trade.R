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
		approxim_srcdst <- approxim
		approxim_srcdst$region <- paste0(trd@routes$src, '##', trd@routes$dst)
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
				tmp <- tmp[-fl,, drop = FALSE]
			}
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
				approxim_srcdst, 'trade', trd@name))
		obj@parameters[['pTradeIrEff']] <- addData(obj@parameters[['pTradeIrEff']],
			simpleInterpolation2(trd@trade, 'teff', obj@parameters[['pTradeIrEff']], 
				approxim_srcdst, 'trade', trd@name))
		# pTradeIrMarkup
		obj@parameters[['pTradeIrMarkup']] <- addData(obj@parameters[['pTradeIrMarkup']],
			simpleInterpolation2(trd@trade, 'markup', obj@parameters[['pTradeIrMarkup']], 
				approxim_srcdst, 'trade', trd@name))
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
					obj@parameters[['pTradeIrCsrc2Ainp']], simpleInterpolation2(trd@aeff, 'csrc2ainp', obj@parameters[['pTradeIrCsrc2Ainp']], 
					  approxim_srcdst, 'trade', trd@name))
				obj@parameters[['pTradeIrCdst2Ainp']] <- addData(
					obj@parameters[['pTradeIrCdst2Ainp']], simpleInterpolation2(trd@aeff, 'cdst2ainp', obj@parameters[['pTradeIrCdst2Ainp']], 
					  approxim_srcdst, 'trade', trd@name, remove_duplicate = list('src', 'dst')))
			}
			for (cc in out_comm) {
				approxim$acomm <- cc
				obj@parameters[['pTradeIrCsrc2Aout']] <- addData(
					obj@parameters[['pTradeIrCsrc2Aout']], simpleInterpolation2(trd@aeff, 'csrc2aout', obj@parameters[['pTradeIrCsrc2Aout']], 
					  approxim_srcdst, 'trade', trd@name))
				obj@parameters[['pTradeIrCdst2Aout']] <- addData(
					obj@parameters[['pTradeIrCdst2Aout']], simpleInterpolation2(trd@aeff, 'cdst2aout', obj@parameters[['pTradeIrCdst2Aout']], 
					  approxim_srcdst, 'trade', trd@name))
			}
		}
		# Add trade data
		if (trd@capacityVariable) {
			obj@parameters[['pTradeCap2Act']] <- addData(obj@parameters[['pTradeCap2Act']],
				data.frame(trade = trd@name, value = trd@cap2act))
			obj@parameters[['mTradeCapacityVariable']] <- addData(obj@parameters[['mTradeCapacityVariable']], data.frame(trade = trd@name))
			
			##!!! Trade 
			if (nrow(trd@invcost) > 0) {
				if (any(is.na(trd@invcost$region)) && nrow(trd@invcost) > 1)
					stop('There is "NA" and other data for invcost in trade class "', trd@name, '".')
				if (any(is.na(trd@invcost$region))) {
					warning('There is a" NA "area for invcost in the"', trd@name, '"trade class. Investments will be smoothed along all routes of the regions.')
					rgg <- unique(c(trd@routes$src, trd@routes$dst))
					trd@invcost <- trd@invcost[rep(1, length(rgg)),, drop = FALSE]
					trd@invcost[, 'region'] <- rgg
					trd@invcost[, 'invcost'] <- trd@invcost[1, 'invcost'] / length(rgg)
				}
			}
			invcost <- simpleInterpolation(trd@invcost, 'invcost', obj@parameters[['pTradeInvcost']], approxim, 'trade', trd@name)
			invcost <- invcost[invcost$value != 0,, drop = FALSE]
			stock_exist <- simpleInterpolation(trd@stock, 'stock', obj@parameters[['pTradeStock']], approxim, 'trade', trd@name)
			obj@parameters[['pTradeStock']] <- addData(obj@parameters[['pTradeStock']], stock_exist)
			obj@parameters[['pTradeOlife']] <- addData(obj@parameters[['pTradeOlife']], 
				data.frame(trade = trd@name, value = trd@olife, stringsAsFactors=FALSE))
			possible_invest_year <- approxim$year
			possible_invest_year <- possible_invest_year[trd@start <= possible_invest_year & possible_invest_year <= trd@end]
			if (length(possible_invest_year) > 0)
				obj@parameters[['mTradeNew']] <- addData(obj@parameters[['mTradeNew']], 
					data.frame(trade = rep(trd@name, length(possible_invest_year)), year = possible_invest_year, stringsAsFactors=FALSE))
			
			if (trd@olife == Inf) {
			  trade_eac <- unique(approxim$year[min(possible_invest_year) <= approxim$year])
			  trade_span <- unique(c(trd@stock$year, trade_eac))
				obj@parameters[['mTradeOlifeInf']] <- addData(obj@parameters[['mTradeOlifeInf']], data.frame(trade = trd@name))
			} else {
			  trade_eac <- unique(c(sapply(possible_invest_year, 
			    function(x) approxim$year[x <= approxim$year & approxim$year <= x + trd@olife]), recursive = TRUE))
			  trade_span <- unique(c(trd@stock$year, trade_eac))
			}
			if (length(trade_span) > 0)
			  obj@parameters[['mTradeSpan']] <- addData(obj@parameters[['mTradeSpan']], 
			    data.frame(trade = rep(trd@name, length(trade_span)), year = trade_span, stringsAsFactors=FALSE))
			if (length(trade_eac) > 0)
			  obj@parameters[['mTradeEac']] <- addData(obj@parameters[['mTradeEac']], 
			    data.frame(trade = rep(trd@name, length(trade_span)), year = trade_eac, stringsAsFactors=FALSE))
			
			# mTradeInv
			if (nrow(invcost) > 0 && nrow(invcost) > 0) {
				end_year <- max(approxim$year)
				obj@parameters[['pTradeInvcost']] <- addData(obj@parameters[['pTradeInvcost']], invcost)
				obj@parameters[['mTradeInv']] <- addData(obj@parameters[['mTradeInv']], invcost[, colnames(invcost) != 'value'])
				invcost$invcost <- invcost$value; invcost$value <- NULL
				
				salv_data <- merge(invcost, approxim$discount, all.x = TRUE)
				salv_data$value[is.na(salv_data$value)] <- 0
				salv_data$discount <- salv_data$value; salv_data$value <- NULL
				salv_data$olife <- trd@olife
				# EAC
				salv_data$eac <- salv_data$invcost / salv_data$olife
				fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
				salv_data$eac[fl] <- salv_data$invcost[fl] * (salv_data$discount[fl] * (1 + salv_data$discount[fl]) ^ salv_data$olife[fl] / 
				    ((1 + salv_data$discount[fl]) ^ salv_data$olife[fl] - 1))
				fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
				salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
				salv_data$trade <- trd@name
				salv_data$value <- salv_data$eac
				pTradeEac <- salv_data[, c('trade', 'region', 'year', 'value')]
				obj@parameters[['pTradeEac']] <- addData(obj@parameters[['pTradeEac']], pTradeEac)
			}
		}
		obj
	})


