read_solution <- function(scenario, ...) {
  ## arguments
  # scenario
  # readOutputFunction = read.csv (may use data.table::fread)
  # dir.result dir from wich read results, by default in scenario@misc$tmp.dir 
  
  if (is.null(arg$readOutputFunction)) arg$readOutputFunction <- read.csv
  if (is.null(arg$dir.result)) {
    arg$dir.result <- scenario@misc$dir.result 
    stop('There is not define dir.result, including ')
  }
  

  
  
  vrb_list <- readOutputFunction(paste(tmpdir, '/variable_list.csv', sep = ''), stringsAsFactors = FALSE)$value
  if (file.exists(paste(tmpdir, '/variable_list2.csv', sep = ''))) {
    vrb_list2 <- readOutputFunction(paste(tmpdir, '/variable_list2.csv', sep = ''), stringsAsFactors = FALSE)$value
  } else vrb_list2 <- character()
  if (file.exists(paste(tmpdir, '/variable_list3.csv', sep = ''))) {
    vrb_list <- c(vrb_list, readOutputFunction(paste(tmpdir, '/variable_list3.csv', sep = ''), stringsAsFactors = FALSE)$value)
  } else vrb_list2 <- character()
  rr <- list(variables = list(), par_arr = list(), set = readOutputFunction(paste(tmpdir, 
                                                                                  '/raw_data_set.csv', sep = ''), stringsAsFactors = FALSE))
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
  for(i in vrb_list) {
    gg <- readOutputFunction(paste(tmpdir, '/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
    if (ncol(gg) == 1) {
      if (to_array_result) rr$par_arr[[i]] <- gg[1, 1]  
      rr$variables[[i]] <- data.frame(value = gg[1, 1])
    } else {
      rr$variables[[i]] <- gg
      jj <- gg[, -ncol(gg), drop = FALSE]
      for(j in seq(length.out = ncol(jj))) {
        if (all(colnames(jj)[j] != names(rr$set_vec))) colnames(jj)[j] <- gsub('[.].*', '', colnames(jj)[j])
        jj[, j] <- factor(jj[, j], levels = sort(rr$set_vec[[colnames(jj)[j]]]))
      }
      if (to_array_result) {
        zz <- tapply(gg[,'value'], jj, sum)
        zz[is.na(zz)] <- 0
        rr$par_arr[[i]] <- zz
      }
    }
  }
  # Read constrain data
  for(i in vrb_list2) {
    gg <- readOutputFunction(paste(tmpdir, '/', i, '.csv', sep = ''), stringsAsFactors = FALSE)
    if (nrow(gg) == 0) {
      rr$par_arr[[i]] <- NULL
    } else if (ncol(gg) == 2) {
      if (to_array_result) rr$par_arr[[i]] <- array(c(gg[1, 3:4], recursive = TRUE), dim = 2, dimnames = list(c('value', 'rhs')))
    } else {
      l1 <- gg[, -ncol(gg)]; l1$type[seq(length.out = nrow(gg))] <- 'rhs'
      l2 <- gg[, 1 - ncol(gg)]; l2$type[seq(length.out = nrow(gg))] <- 'value'
      colnames(l1)[ncol(l1) - 1] <- 'type'
      colnames(l2)[ncol(l2) - 1] <- 'type'
      gg <- rbind(l1, l2)
      if (to_array_result) {
        # rr$par_arr[[i]] <- tapply(gg[, ncol(gg) - 1], gg[, 1 - ncol(gg)], sum)
      }
    }
  }
  rr[['solution_report']] <- list(finish = readOutputFunction(paste(tmpdir, '/pFinish.csv', sep = ''))$value, 
                                  status = readOutputFunction(paste(tmpdir, '/pStat.csv', sep = ''))$value)
  pp4 <- proc.time()[3]
  if (tmp.del) {
    #cat(tmpdir, 'yyyyyyyyyyyyyy\n')
    unlink(tmpdir, recursive = TRUE)
  }
  if(echo) cat('Total time: ', round(pp4 - pp1, 2), 's\n', sep = '')
  scn <- new('scenario')
  scn@name <- name
  scn@description <- description
  scn@modInp <- prec
  scn@model <- obj
  scn@modOut <- new('modOut')
  if (to_array_result) scn@modOut@data <- rr$par_arr
  scn@modOut@sets <- rr$set_vec
  scn@modOut@variables <- rr$variables
  scn@modOut@compilationStatus <- as.character(rr$solution_report$finish)
  scn@modOut@solutionStatus <- as.character(rr$solution_report$status)
  for(i in names(scn@modInp@parameters)) {
    if (scn@modInp@parameters[[i]]@nValues != -1) {
      scn@modInp@parameters[[i]]@data <- scn@modInp@parameters[[i]]@data[
        seq(length.out = scn@modInp@parameters[[i]]@nValues),, drop = FALSE]
    }
  }
  if (rr$solution_report$finish != 2 || rr$solution_report$status != 1)
    warning('Unsuccessful finish')
  
}