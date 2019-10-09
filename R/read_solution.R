read_solution <- function(scen, ...) {
  ## arguments
  # scen
  # readOutputFunction = read.csv (may use data.table::fread)
  # dir.result dir from wich read results, by default in scen@misc$dir.result 
  # echo = TRUE - print working data
  arg <- list(...)
  
  read_result_time <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$readOutputFunction)) arg$readOutputFunction <- read.csv
  if (is.null(arg$dir.result)) {
    arg$dir.result <- scen@misc$dir.result 
    if (is.null(arg$dir.result))
      stop('There is not define dir.result, including scen@misc$dir.result')
  }
  

  
  # Read basic variable list (vrb_list) and additional if user need (vrb_list2)
  vrb_list <- arg$readOutputFunction(paste(arg$dir.result, '/output/variable_list.csv', sep = ''), stringsAsFactors = FALSE)$value
  if (file.exists(paste(arg$dir.result, '/output/variable_list2.csv', sep = ''))) {
    vrb_list2 <- arg$readOutputFunction(paste(arg$dir.result, '/output/variable_list2.csv', sep = ''), stringsAsFactors = FALSE)$value
  } else vrb_list2 <- character()
  rr <- list(variables = list(), 
             set = arg$readOutputFunction(paste(arg$dir.result, '/output/raw_data_set.csv', sep = ''), stringsAsFactors = FALSE))
  # Read set and alias
  ss <- list()
  for(k in unique(rr$set$set)) {
    ss[[k]] <- rr$set$value[rr$set$set == k]
  }
  # add alias
  ss$src <- ss$region
  ss$dst <- ss$region
  ss$regionp <- ss$region
  ss$yearp <- ss$year
  ss$acomm <- ss$comm
  ss$commp <- ss$comm
  ss$slicep <- ss$slice
  rr$set_vec <- ss

  # Read variable data
  for(i in c(vrb_list, vrb_list2)) {
    jj <- arg$readOutputFunction(paste(arg$dir.result, '/output/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
    if (ncol(jj) == 1) {
      rr$variables[[i]] <- data.frame(value = jj[1, 1])
    } else {
      for(j in seq_len(ncol(jj))[colnames(jj) != 'value']) {
        # Remove [.][:digit:] if any
        if (all(colnames(jj)[j] != names(rr$set_vec))) 
          colnames(jj)[j] <- gsub('[.].*', '', colnames(jj)[j])
        # Save all data with all levels
        if (colnames(jj)[j] != 'year')
        	jj[, j] <- factor(jj[, j], levels = sort(rr$set_vec[[colnames(jj)[j]]]))
      }
      rr$variables[[i]] <- jj
    }
  }
 
  rr[['solution_report']] <- list(finish = arg$readOutputFunction(paste(arg$dir.result, '/output/pFinish.csv', sep = ''))$value, 
                                  status = arg$readOutputFunction(paste(arg$dir.result, '/output/pStat.csv', sep = ''))$value)
  scen@modOut <- new('modOut')
  scen@modOut@sets <- rr$set_vec
  scen@modOut@variables <- rr$variables
  scen@modOut@compilationStatus <- as.character(rr$solution_report$finish)
  scen@modOut@solutionStatus <- as.character(rr$solution_report$status)
  if (!is.null(scen@misc$data.before)) {
  	scen <- .paste_base_result2new(scen)
  }
  ## Salvage cost calculation
  salvage_cost0 <- function(scen, par) {
    invcost <- energyRt:::.getTotalParameterData(scen@modInp, paste0('p', par, 'Invcost'))
    olife <- energyRt:::.getTotalParameterData(scen@modInp, paste0('p', par, 'Olife'))
    discount <- energyRt:::.getTotalParameterData(scen@modInp, 'pDiscount')
    newcap <- scen@modOut@variables[[paste0('v', par, 'NewCap')]]
    invcost$invcost <- invcost$value; invcost$value <- NULL
    olife$olife <- olife$value; olife$value <- NULL
    discount$discount <- discount$value; discount$value <- NULL
    newcap$newcap <- newcap$value; newcap$value <- NULL
    
    salvage <- merge(merge(newcap, merge(olife, invcost)), discount, all.x = TRUE)
    end_year <- max(energyRt::getParameterData(scen@modInp@parameters$mEndMilestone)$yearp)
    salvage <- merge(salvage, energyRt::getParameterData(scen@modInp@parameters$mStartMilestone))
    salvage$start <- salvage$yearp; salvage$yearp <- NULL
    salvage <- salvage[salvage$start + salvage$olife > end_year, ]
    
    salvage$value <- salvage$newcap * salvage$invcost * ((1 + salvage$discount)^(salvage$olife) - 
        (1 + salvage$discount)^(end_year - salvage$start + 1)) / ((1 + salvage$discount)^salvage$olife - 1) 
    salvage[, c(3, 2, 1, 9)]
  }
  if (rr$solution_report$finish != 2 || rr$solution_report$status != 1) {
    warning('Unsuccessful finish')
  } else {
    # Postprocessing
    scen@modOut@variables$vTechSalv <- salvage_cost0(scen, 'Tech')
    scen@modOut@variables$vStorageSalv <- salvage_cost0(scen, 'Storage')
    scen@modOut@variables$vTradeSalv <- salvage_cost0(scen, 'Trade')
    vDummyImportCost <- merge(energyRt:::getParameterData(scen@modInp@parameters$pDummyImportCost), scen@modOut@variables$vDummyImport, 
      by = c('comm', 'region', 'year', 'slice'))
    vDummyImportCost$value <- vDummyImportCost$value.x * vDummyImportCost$value.y;
    vDummyImportCost$value.x <- NULL; vDummyImportCost$value.y <- NULL;
    scen@modOut@variables$vDummyImportCost <- vDummyImportCost
    vDummyExportCost <- merge(energyRt:::getParameterData(scen@modInp@parameters$pDummyExportCost), scen@modOut@variables$vDummyExport, 
      by = c('comm', 'region', 'year', 'slice'))
    vDummyExportCost$value <- vDummyExportCost$value.x * vDummyExportCost$value.y;
    vDummyExportCost$value.x <- NULL; vDummyExportCost$value.y <- NULL;
    scen@modOut@variables$vDummyExportCost <- vDummyExportCost
  }
  if(arg$echo) cat('Reading solution: ', round(proc.time()[3] - read_result_time, 2), 's\n', sep = '')
  invisible(scen)
}
.paste_base_result2new <- function(scen) {
	# Have to recalculate vObjective (need recalculate salvage before and so on, draft in Github/Misc/package/temp/interpolate_after_for_rest.R)
	for (i in names(scen@misc$data.before)) {
		scen@modOut@variables[[i]] <- rbind(scen@modOut@variables[[i]], scen@misc$data.before[[i]])
	}
	# Correct RowTradeAccumulated
	if (nrow(scen@modOut@variables$vExportRowAccumulated) > 0)
		scen@modOut@variables$vExportRowAccumulated <- aggregate(scen@modOut@variables$vExportRowAccumulated[, 'value', drop = FALSE],
			scen@modOut@variables$vExportRowAccumulated[, c('expp', 'comm'), drop = FALSE], sum)
	if (nrow(scen@modOut@variables$vImportRowAccumulated) > 0)
		scen@modOut@variables$vImportRowAccumulated <- aggregate(scen@modOut@variables$vImportRowAccumulated[, 'value', drop = FALSE],
			scen@modOut@variables$vImportRowAccumulated[, c('imp', 'comm'), drop = FALSE], sum)
  scen	
}


# 