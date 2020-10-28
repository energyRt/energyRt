# Check parameters
.check_scen_par <- function(scen) {
	# Check for non negative parameters, all except 'pAggregateFactor', 'pTechCvarom', 'pTechAvarom', 'pTechVarom', 'pTechInvcost'
	non_negative <- unique(c('pSliceShare', 'pTechOlife', 'pTechCinp2ginp', 'pTechGinp2use', 'pTechCinp2use', 'pTechUse2cact', 'pTechCact2cout', 
		'pTechEmisComm', 'pTechAct2AInp', 'pTechCap2AInp', 'pTechNCap2AInp', 'pTechCinp2AInp', 'pTechCout2AInp', 
		'pTechAct2AOut', 'pTechCap2AOut', 'pTechNCap2AOut', 'pTechCinp2AOut', 'pTechCout2AOut', 'pTechFixom', 'pTechShare', 
		'pTechShare', 'pTechAf', 'pTechAf', 'pTechAfs', 'pTechAfs', 'pTechAfc', 'pTechAfc', 'pTechStock', 'pTechCap2act', 'pDiscount', 
		'pDiscountFactor', 'pSupCost', 'pSupAva', 'pSupAva', 'pSupReserve', 'pSupReserve', 'pDemand', 'pEmissionFactor', 'pDummyImportCost', 'pDummyExportCost', 
		'pTaxCost', 'pSubsCost', 'pWeather', 'pSupWeather', 'pSupWeather', 'pTechWeatherAf', 'pTechWeatherAf', 'pTechWeatherAfs', 'pTechWeatherAfs', 
		'pTechWeatherAfc', 'pTechWeatherAfc', 'pStorageWeatherAf', 'pStorageWeatherAf', 'pStorageWeatherCinp', 'pStorageWeatherCinp', 'pStorageWeatherCout', 
		'pStorageWeatherCout', 'pStorageInpEff', 'pStorageOutEff', 'pStorageStgEff', 'pStorageStock', 'pStorageOlife', 'pStorageCostStore', 'pStorageCostInp', 
		'pStorageCostOut', 'pStorageFixom', 'pStorageInvcost', 'pStorageCap2stg', 'pStorageAf', 'pStorageAf', 'pStorageCinp', 'pStorageCinp', 'pStorageCout', 
		'pStorageCout', 'pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 'pStorageCout2AInp', 'pStorageCout2AOut', 'pStorageCap2AInp', 
		'pStorageCap2AOut', 'pStorageNCap2AInp', 'pStorageNCap2AOut', 'pTradeIrEff', 'pTradeIr', 'pTradeIr', 'pTradeIrCost', 'pTradeIrMarkup', 'pTradeIrCsrc2Ainp', 
		'pTradeIrCsrc2Aout', 'pTradeIrCdst2Ainp', 'pTradeIrCdst2Aout', 'pExportRowRes', 'pExportRow', 'pExportRow', 'pExportRowPrice', 'pImportRowRes', 'pImportRow', 
		'pImportRow', 'pImportRowPrice'))
	msg_small_err <- NULL
	for (i in non_negative)	{
		if (any(scen@modInp@parameters[[i]]@data$value < 0)) {
			if (any(scen@modInp@parameters[[i]]@data$value < -1e-7)) {
				msg <- paste0('Parameter: "', i, '" have to only non negative value\nWrong data:')
				tmp <- scen@modInp@parameters[[i]]@data[scen@modInp@parameters[[i]]@data$value < 0,, drop = FALSE]
				msg <- c(msg, capture.output(print(tmp[1:min(c(10, nrow(tmp))),, drop = FALSE])))
				
				if (nrow(tmp) > 10) {
					msg <- c(msg, paste0('Show only first 10 errors data, from ', nrow(tmp), '\n'))
				}
				stop(paste0(msg, collapse = '\n'))
			} else {
				msg_small_err <- c(msg_small_err, i)
				scen@modInp@parameters[[i]]@data[scen@modInp@parameters[[i]]@data$value > -1e-7 &
						scen@modInp@parameters[[i]]@data$value < 0, 'value'] <- 0
			}
		}
	}
	if (length(msg_small_err) > 0)
	 warning(paste0('There small negative value (abs(err) < 1e-7) in parameter', 's'[length(msg_small_err) > 1], ': "', 
		paste0(msg_small_err, collapse = '", "'), '". Assigned as zerro.'))
	# Check share 
	if (nrow(scen@modInp@parameters$pTechShare@data) > 0) {
		mTechGroupComm <- .get_data_slot(scen@modInp@parameters$mTechGroupComm)
  	#scen@modInp@parameters$pTechShare@data <- merge(scen@modInp@parameters$pTechShare@data, mTechGroupComm)
  	#if (scen@modInp@parameters$pTechShare@nValues != - 1)
    #		scen@modInp@parameters$pTechShare@nValues <- nrow(scen@modInp@parameters$pTechShare@data)
		tmp <- .add_dropped_zeros(scen@modInp, 'pTechShare')
		mTechSpan <- .get_data_slot(scen@modInp@parameters$mTechSpan)
		tmp <- merge(tmp, mTechSpan)
		tmp_lo <- merge(tmp[tmp$type == 'lo',, drop = FALSE], mTechGroupComm)
		tmp_up <- merge(tmp[tmp$type == 'up',, drop = FALSE], mTechGroupComm)
		tmp_lo <- aggregate(tmp_lo[, 'value', drop = FALSE], tmp_lo[, !(colnames(tmp_lo) %in% c('type', 'comm', 'value')), drop = FALSE], sum)
		tmp_up <- aggregate(tmp_up[, 'value', drop = FALSE], tmp_up[, !(colnames(tmp_up) %in% c('type', 'comm', 'value')), drop = FALSE], sum)
		if (any(tmp_lo$value > 1) || any(tmp_up$value < 1)) {
			tech_wrong_lo <- tmp_lo[tmp_lo$value > 1,, drop = FALSE]
			tech_wrong_up <- tmp_up[tmp_up$value < 1,, drop = FALSE]
			tech_wrong <- unique(c(tech_wrong_up$tech, tech_wrong_lo$tech))
			assign('tech_wrong_lo', tech_wrong_lo, globalenv())
			assign('tech_wrong_up', tech_wrong_up, globalenv())
			stop(paste0('There are wrong share (sum of up less than one or sum of lo large than one)  (wrong data in data frame tech_wrong_lo and tech_wrong_up)', 
				' for technology "', paste0(tech_wrong, collapse = '", "'), '"'))
		}
		fl <- colnames(tmp)[!(colnames(tmp) %in% c('type'))]
		tmp_cmd <- merge(tmp[tmp$type == 'lo', fl, drop = FALSE], tmp[tmp$type == 'up', fl, drop = FALSE], by = fl[fl != 'value'])
		if (any(tmp_cmd$value.x > tmp_cmd$value.y)) {
			tech_wrong <- tmp_cmd[tmp_cmd$value.x > tmp_cmd$value.y,, drop = FALSE]
			assign('tech_wrong', tech_wrong, globalenv())
			stop(paste0('There are wrong share (for tuple (tech, comm, region, year, slice) lo share large than up) (wrong data in data frame tech_wrong) for technology "', 
				paste0(unique(tech_wrong$tech), collapse = '", "'), '"'))
		}
	}
	scen
}
