read_solution <- function(scenario, ...) {
  ## arguments
  # scenario
  # readOutputFunction = read.csv (may use data.table::fread)
  # dir.result dir from wich read results, by default in scenario@misc$dir.result 
  # echo = TRUE - print working data
  arg <- list(...)
  
  read_result_time <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$readOutputFunction)) arg$readOutputFunction <- read.csv
  if (is.null(arg$dir.result)) {
    arg$dir.result <- scenario@misc$dir.result 
    if (is.null(arg$dir.result))
      stop('There is not define dir.result, including scenario@misc$dir.result')
  }
  

  
  # Read basic variable list (vrb_list) and additional if user need (vrb_list2)
  vrb_list <- arg$readOutputFunction(paste(arg$dir.result, '/variable_list.csv', sep = ''), stringsAsFactors = FALSE)$value
  if (file.exists(paste(arg$dir.result, '/variable_list2.csv', sep = ''))) {
    vrb_list2 <- arg$readOutputFunction(paste(arg$dir.result, '/variable_list2.csv', sep = ''), stringsAsFactors = FALSE)$value
  } else vrb_list2 <- character()
  rr <- list(variables = list(), 
             set = arg$readOutputFunction(paste(arg$dir.result, '/raw_data_set.csv', sep = ''), stringsAsFactors = FALSE))
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
    jj <- arg$readOutputFunction(paste(arg$dir.result, '/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
    if (ncol(jj) == 1) {
      rr$variables[[i]] <- data.frame(value = jj[1, 1])
    } else {
      for(j in seq_len(ncol(jj))[colnames(jj) != 'value']) {
        # Remove [.][:digit:] if any
        if (all(colnames(jj)[j] != names(rr$set_vec))) 
          colnames(jj)[j] <- gsub('[.].*', '', colnames(jj)[j])
        # Save all data with all levels
        jj[, j] <- factor(jj[, j], levels = sort(rr$set_vec[[colnames(jj)[j]]]))
      }
      rr$variables[[i]] <- jj
    }
  }
 
  rr[['solution_report']] <- list(finish = arg$readOutputFunction(paste(arg$dir.result, '/pFinish.csv', sep = ''))$value, 
                                  status = arg$readOutputFunction(paste(arg$dir.result, '/pStat.csv', sep = ''))$value)
  scenario@modOut <- new('modOut')
  scenario@modOut@sets <- rr$set_vec
  scenario@modOut@variables <- rr$variables
  scenario@modOut@compilationStatus <- as.character(rr$solution_report$finish)
  scenario@modOut@solutionStatus <- as.character(rr$solution_report$status)
  if (rr$solution_report$finish != 2 || rr$solution_report$status != 1)
    warning('Unsuccessful finish')
  if(arg$echo) cat('Read result time: ', round(proc.time()[3] - read_result_time, 2), 's\n', sep = '')
  invisible(scenario)
}