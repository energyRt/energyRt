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
		mTradeSlice <- data.frame(trade = rep(trd@name, length(approxim$slice)), slice = approxim$slice)
		obj@parameters[['mTradeSlice']] <- addData(obj@parameters[['mTradeSlice']], mTradeSlice)
		if (length(trd@commodity) == 0) stop('There is not commodity for trade flow ', trd@name)
		obj@parameters[['mTradeComm']] <- addData(obj@parameters[['mTradeComm']],
			data.frame(trade = trd@name, comm = trd@commodity))
		mTradeRoutes <- cbind(trade = rep(trd@name, nrow(trd@routes)), trd@routes)
		obj@parameters[['mTradeRoutes']] <- addData(obj@parameters[['mTradeRoutes']], mTradeRoutes)
		pTradeIrCdst2Aout <- NULL; pTradeIrCsrc2Aout <- NULL; pTradeIrCdst2Ainp <- NULL; pTradeIrCsrc2Ainp <- NULL;
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
		simpleInterpolation2 <- function(frm, approxim, ...) {
			if (nrow(frm) == 0 && !approxim$include.default) return(NULL)
		  if (nrow(frm) != 0) {
  		  frm <- imply_routes(frm)
  			frm$region <- paste0(frm$src, '##', frm$dst)
		  } else {
		    frm$region <- character()
		  }
		  frm$src <- NULL; frm$dst <- NULL
		  frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), drop = FALSE]
		  dd <- simpleInterpolation(frm, approxim = approxim, ...)
			if (is.null(dd) || nrow(dd) == 0) return(NULL)
			dd$src <- gsub('##.*', '', dd$region)
			dd$dst <- gsub('.*##', '', dd$region)
			rd <- seq_len(ncol(dd))[colnames(dd) == 'region']
			dd[, c(colnames(dd)[2:rd - 1], 'src', 'dst', colnames(dd)[(rd + 1):(ncol(dd) - 2)])]
		}
		multiInterpolation2 <- function(frm, approxim, ...) {
			if (nrow(frm) == 0 && !approxim$include.default) return(NULL)
		  if (nrow(frm) != 0) {
		    frm <- imply_routes(frm)
		    frm$region <- paste0(frm$src, '##', frm$dst)
		  } else {
		    frm$region <- character()
		  }
		  frm$src <- NULL; frm$dst <- NULL
		  frm <- frm[, c(ncol(frm), 2:ncol(frm) - 1), drop = FALSE]
		  dd <- multiInterpolation(frm, approxim = approxim, ...)
			if (is.null(dd) || nrow(dd) == 0) return(NULL)
			dd$src <- gsub('##.*', '', dd$region)
			dd$dst <- gsub('.*##', '', dd$region)
			rd <- seq_len(ncol(dd))[colnames(dd) == 'region']
			dd[, c(colnames(dd)[2:rd - 1], 'src', 'dst', colnames(dd)[(rd + 1):(ncol(dd) - 2)])]
		}
		# if (trd@name == 'nuc_trade') browser()
		# pTradeIrCost
		obj@parameters[['pTradeIrCost']] <- addData(obj@parameters[['pTradeIrCost']],
			simpleInterpolation2(trd@trade, 'cost', obj@parameters[['pTradeIrCost']], 
				approxim = approxim_srcdst, 'trade', trd@name))
		pTradeIrEff <- simpleInterpolation2(trd@trade, 'teff', obj@parameters[['pTradeIrEff']], 
		                     approxim = approxim_srcdst, 'trade', trd@name)
		obj@parameters[['pTradeIrEff']] <- addData(obj@parameters[['pTradeIrEff']], pTradeIrEff)
		# pTradeIrMarkup
		obj@parameters[['pTradeIrMarkup']] <- addData(obj@parameters[['pTradeIrMarkup']],
			simpleInterpolation2(trd@trade, 'markup', obj@parameters[['pTradeIrMarkup']], 
			                     approxim = approxim_srcdst, 'trade', trd@name))
		# pTradeIr
		pTradeIr <- multiInterpolation2(trd@trade, 'ava',
			obj@parameters[['pTradeIr']], approxim = approxim, 'trade', trd@name)
		obj@parameters[['pTradeIr']] <- addData(obj@parameters[['pTradeIr']], pTradeIr)
		# Trade ainp
		mTradeIrAInp <- NULL; mTradeIrAOut <- NULL;
		if (nrow(trd@aux) != 0) {
			if (any(is.na(trd@aux$acomm))) 
				stop('Wrong aux commodity for trade "', trd@name, '"')
			trd@aeff <- trd@aeff[!is.na(trd@aeff$acomm),, drop = FALSE]
			if (!all(trd@aeff$acomm %in% trd@aux$acomm))
				stop('Wrong aux commodity for trade "', trd@name, '"')
			inp_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2ainp) | !is.na(trd@aeff$cdst2ainp), 'acomm'])
			out_comm <- unique(trd@aeff[!is.na(trd@aeff$csrc2aout) | !is.na(trd@aeff$cdst2aout), 'acomm'])
			if (length(inp_comm) != 0) {
			  mTradeIrAInp <- data.frame(trade = rep(trd@name, length(inp_comm)), comm = inp_comm)
			  obj@parameters[['mTradeIrAInp']] <- addData(obj@parameters[['mTradeIrAInp']], mTradeIrAInp)
			} 
			if (length(out_comm) != 0) {
			  mTradeIrAOut <- data.frame(trade = rep(trd@name, length(out_comm)), comm = out_comm)
			  obj@parameters[['mTradeIrAOut']] <- addData(obj@parameters[['mTradeIrAOut']], mTradeIrAOut)
			} 
			for (cc in inp_comm) {
				approxim$acomm <- cc
				pTradeIrCsrc2Ainp <- simpleInterpolation2(trd@aeff, 'csrc2ainp', obj@parameters[['pTradeIrCsrc2Ainp']], 
				                                          approxim = approxim_srcdst, 'trade', trd@name)
				obj@parameters[['pTradeIrCsrc2Ainp']] <- addData(obj@parameters[['pTradeIrCsrc2Ainp']], pTradeIrCsrc2Ainp)
				pTradeIrCdst2Ainp <- simpleInterpolation2(trd@aeff, 'cdst2ainp', obj@parameters[['pTradeIrCdst2Ainp']], 
				                                          approxim = approxim_srcdst, 'trade', trd@name, remove_duplicate = list('src', 'dst'))
				obj@parameters[['pTradeIrCdst2Ainp']] <- addData(obj@parameters[['pTradeIrCdst2Ainp']], pTradeIrCdst2Ainp)
			}
			for (cc in out_comm) {
				approxim$acomm <- cc
				pTradeIrCsrc2Aout <- simpleInterpolation2(trd@aeff, 'csrc2aout', obj@parameters[['pTradeIrCsrc2Aout']], 
				                     approxim = approxim_srcdst, 'trade', trd@name)
				obj@parameters[['pTradeIrCsrc2Aout']] <- addData(obj@parameters[['pTradeIrCsrc2Aout']], pTradeIrCsrc2Aout)
				pTradeIrCdst2Aout <- simpleInterpolation2(trd@aeff, 'cdst2aout', obj@parameters[['pTradeIrCdst2Aout']], 
				                     approxim = approxim_srcdst, 'trade', trd@name)
				obj@parameters[['pTradeIrCdst2Aout']] <- addData(obj@parameters[['pTradeIrCdst2Aout']], pTradeIrCdst2Aout)
			}
		}
		# Add trade data
		if (trd@capacityVariable) {
			obj@parameters[['pTradeCap2Act']] <- addData(obj@parameters[['pTradeCap2Act']],
				data.frame(trade = trd@name, value = trd@cap2act))
			mTradeCapacityVariable <- data.frame(trade = trd@name)
			obj@parameters[['mTradeCapacityVariable']] <- addData(obj@parameters[['mTradeCapacityVariable']], mTradeCapacityVariable)
			
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
			invcost <- invcost[invcost$value != 0 & trd@start <= invcost$year & invcost$year < trd@end,, drop = FALSE]
			stock_exist <- simpleInterpolation(trd@stock, 'stock', obj@parameters[['pTradeStock']], approxim, 'trade', trd@name)
			obj@parameters[['pTradeStock']] <- addData(obj@parameters[['pTradeStock']], stock_exist)
			obj@parameters[['pTradeOlife']] <- addData(obj@parameters[['pTradeOlife']], 
				data.frame(trade = trd@name, value = trd@olife, stringsAsFactors=FALSE))
			possible_invest_year <- approxim$year
			possible_invest_year <- possible_invest_year[trd@start <= possible_invest_year & possible_invest_year <= trd@end]
			if (length(possible_invest_year) > 0)
				obj@parameters[['mTradeNew']] <- addData(obj@parameters[['mTradeNew']], 
					data.frame(trade = rep(trd@name, length(possible_invest_year)), year = possible_invest_year, stringsAsFactors=FALSE))
			
			min0 <- function(x) {
			  if (length(x) == 0) return(-Inf)
			  return(min(x))
			}
			if (trd@olife == Inf) {
			  trade_eac <- unique(approxim$year[min0(possible_invest_year) <= approxim$year])
			  trade_span <- unique(c(trd@stock$year, trade_eac))
				obj@parameters[['mTradeOlifeInf']] <- addData(obj@parameters[['mTradeOlifeInf']], data.frame(trade = trd@name))
			} else {
			  trade_eac <- unique(c(sapply(possible_invest_year, 
			    function(x) approxim$year[x <= approxim$year & approxim$year <= x + trd@olife]), recursive = TRUE))
			  trade_span <- unique(c(trd@stock$year, trade_eac))
			}
			if (length(trade_span) > 0) {
			  mTradeSpan <- data.frame(trade = rep(trd@name, length(trade_span)), year = trade_span, stringsAsFactors=FALSE)
			  obj@parameters[['mTradeSpan']] <- addData(obj@parameters[['mTradeSpan']], mTradeSpan)
			  meqTradeCapFlow <- merge(mTradeSpan, mTradeSlice)
			  meqTradeCapFlow$comm <- trd@commodity
			  obj@parameters[['meqTradeCapFlow']] <- addData(obj@parameters[['meqTradeCapFlow']], meqTradeCapFlow)
			}
			# mTradeInv
			if (!is.null(invcost)) {
				end_year <- max(approxim$year)
				obj@parameters[['pTradeInvcost']] <- addData(obj@parameters[['pTradeInvcost']], invcost)
				obj@parameters[['mTradeInv']] <- addData(obj@parameters[['mTradeInv']], invcost[, colnames(invcost) != 'value'])
				invcost$invcost <- invcost$value; invcost$value <- NULL
				if (length(trade_eac) > 0) {
				  mTradeEac <- merge(unique(invcost$region), trade_eac)
				  mTradeEac$trade <- trd@name
				  mTradeEac$region <- as.character(mTradeEac$x)
				  mTradeEac$year <- mTradeEac$y
				  mTradeEac$x <- NULL; mTradeEac$y <- NULL
				  obj@parameters[['mTradeEac']] <- addData(obj@parameters[['mTradeEac']], mTradeEac)
				}

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
		########
		mTradeIr <- merge(mTradeRoutes, mTradeSlice)
		if (trd@capacityVariable) {
		  mTradeIr <- merge(mTradeIr, mTradeSpan)
		} else mTradeIr <- merge(mTradeIr, list(year = approxim$mileStoneYears))
		obj@parameters[['mTradeIr']] <- addData(obj@parameters[['mTradeIr']], mTradeIr)
		
		### To trades
		# mvTradeIrAInp(trade, comm, region, year, slice)
		if (!is.null(mTradeIrAInp)) {
		  browser()
      a0 <- mTradeIrAInp; colnames(a0)[2] <- 'acomm'
      if (!is.null(pTradeIrCsrc2Ainp))
        a1 <- merge(a0, pTradeIrCsrc2Ainp[pTradeIrCsrc2Ainp$value != 0, colnames(a0)]) 
      if (!is.null(pTradeIrCdst2Ainp))
        a1 <- merge(a0, pTradeIrCdst2Ainp[pTradeIrCdst2Ainp$value != 0, colnames(a0)]) 
      colnames(a1)[2:4] <- c('comm', 'region', 'region.1')
      obj@parameters[['mvTradeIrAInp']] <- addData(obj@parameters[['mvTradeIrAInp']],
                                                  merge(a1, mTradeIr)[, c('trade', 'comm', 'region', 'year', 'slice')])
		}
		if (!is.null(mTradeIrAOut)) {
		  a0 <- mTradeIrAOut; colnames(a0)[2] <- 'acomm'
      if (!is.null(pTradeIrCsrc2Aout))
        a1 <- merge(a0, pTradeIrCsrc2Aout[pTradeIrCsrc2Aout$value != 0, colnames(a0)]) 
      if (!is.null(pTradeIrCdst2Aout))
        a1 <- merge(a0, pTradeIrCdst2Aout[pTradeIrCdst2Aout$value != 0, colnames(a0)]) 
      colnames(a1)[2:4] <- c('comm', 'region', 'region.1')
      obj@parameters[['mvTradeIrAOut']] <- addData(obj@parameters[['mvTradeIrAOut']],
                                                    merge(a1, mTradeIr)[, c('trade', 'comm', 'region', 'year', 'slice')])
		}

		mvTradeIr <- mTradeIr; mvTradeIr$comm <- trd@commodity
		obj@parameters[['mvTradeIr']] <- addData(obj@parameters[['mvTradeIr']], mvTradeIr) 
		if (!is.null(pTradeIr)) {
		  pTradeIr$comm <- trd@commodity
		  obj@parameters[['meqTradeFlowLo']] <- addData(obj@parameters[['meqTradeFlowLo']], 
		                                                merge(mvTradeIr, pTradeIr[pTradeIr$type == 'lo' & pTradeIr$value != 0, colnames(mvTradeIr)]))
		  obj@parameters[['meqTradeFlowUp']] <- addData(obj@parameters[['meqTradeFlowUp']], 
		                                                merge(mvTradeIr, pTradeIr[pTradeIr$type == 'up' & pTradeIr$value != Inf, colnames(mvTradeIr)]))
		  pTradeIr$comm <- NULL
		}
		obj
	})


