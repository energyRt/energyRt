# interpolate(scenario, overwrite = TRUE) - updates interpolation in scenario objects

# solve_model(scenario, interpolate = NULL) - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
# returns list with solution status and folder

#read_solution(scen = NULL, folder) - reads results and updates scen, if scen = NULL, creates empty scenario with solution data


# Function that generate empty scenario with approximation, but without compilation and read result
interpolate <- function(obj, ...) { #- returns class scenario
  ## arguments
  # obj - scenario or model
  # name
  # description
  # n.threads - number of threads use for approximation
  # startYear && fixTo have to define both (or not define both) - run with startYear
  # year - basic milestone year definition (not recomendet for use), use only if milestone not defined
  # discount - define discount, not good practice
  # region - define region, not good practice
  # repository - class for add to model (repository or list of repository)
  # echo - print working data
  
  arg <- list(...)

    
  interpolation_time_begin <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE
  
  if (class(obj) == 'model') {
    scen <- new('scenario')
    scen@model <- obj
    scen@name <- 'Default scenario name'
    scen@description <- 'Default description'
  } else if (class(obj) == 'scenario') {
    scen <- obj
  } else {
    stop('Undefined class "', obj, '"')
  } 
  
  if (!is.null(arg$name)) scen@name <- arg$name
  if (!is.null(arg$description)) scen@description <- arg$description
  if (is.null(arg$n.threads))  arg$n.threads <- 1 + 0*detectCores()
  if (is.null(arg$startYear) != is.null(arg$fixTo)) 
    stop('startYear && fixTo have to define both (or not define both')
  if (!is.null(arg$year)) scen@model@sysInfo@year <- arg$year  
  if (!is.null(arg$repository)) scen@model <- .add_repository(scen@model, arg$repository)
  if (!is.null(arg$region)) scen@model@sysInfo@region <- arg$region
  if (!is.null(arg$discount)) scen@model@sysInfo@discount <- arg$discount
  
    
  ### Interpolation begin
  scen@modInp <- new('modInp')
  ## Fill basic sets
  # Fill year 
  if (!is.null(arg$year)) {
    if (nrow(scen@model@sysInfo@milestone) != 0)
      stop("argument can't use with milestone")
    scen@model@sysInfo@year <- arg$year
  }
  if (nrow(scen@model@sysInfo@milestone) == 0) {
    if (any(sort(scen@model@sysInfo@year) != scen@model@sysInfo@year) || 
        max(scen@model@sysInfo@year) - min(scen@model@sysInfo@year) + 1 != length(scen@model@sysInfo@year))
      stop('wrong year parameter')
    scen@model <- setMilestoneYears(scen@model, start = scen@model@sysInfo@year[1], 
                             interval = rep(1, length(scen@model@sysInfo@year)))
  }
  scen@modInp@parameters[['year']] <- addData(scen@modInp@parameters[['year']], scen@model@sysInfo@year)
  scen@modInp@parameters[['mMidMilestone']] <- addData(scen@modInp@parameters[['mMidMilestone']], 
                                                       data.frame(year = scen@model@sysInfo@milestone$mid))
  # Fill slice
  scen@model@sysInfo@slice <- energyRt:::.init_slice(scen@model@sysInfo@slice)
  scen@modInp@parameters[['slice']] <- addData(scen@modInp@parameters[['slice']], 
                                               scen@model@sysInfo@slice@all_slice)
  # Fill region
  scen@modInp@parameters[['region']] <- addData(scen@modInp@parameters[['region']], scen@model@sysInfo@region)
  
  # List for approximation
  # Generate approxim list, that contain basic data for approximation
  xx <- c(obj@sysInfo@milestone$mid[-1] - obj@sysInfo@milestone$mid[-nrow(obj@sysInfo@milestone)], 1)
  names(xx) <-  obj@sysInfo@milestone$mid
  
  if (is.null(arg$fullsets)) fullsets <- TRUE else
    fullsets <- arg$fullsets
  scen@status$fullsets <- fullsets
  
  approxim <- list(
    region = scen@model@sysInfo@region,
    year   = scen@model@sysInfo@year,
    slice  = scen@model@sysInfo@slice,
    solver = arg$solver,
    mileStoneYears = scen@model@sysInfo@milestone$mid,
    mileStoneForGrowth = xx,
    fullsets = fullsets
  )
  approxim$ry <- merge(data.frame(region = approxim$region, stringsAsFactors = FALSE), 
    data.frame(year = approxim$mileStoneYears, stringsAsFactors = FALSE))
  approxim$rys <- merge(approxim$ry,
    data.frame(slice = approxim$slice@all_slice, stringsAsFactors = FALSE))
  # Fill basic parameter interplotaion from sysInfo
  approxim$all_comm <- c(lapply(scen@model@data, function(x) c(lapply(x@data, function(y) {
  	if (class(y) != 'commodity') return(NULL)
  	return(y@name)
  }), recursive = TRUE)), recursive = TRUE)
  names(approxim$all_comm) <- NULL
  scen@modInp <- .read_default_data(scen@modInp, scen@model@sysInfo)
  
    if (!is.null(arg$trim) && arg$trim) {
    ## Trim before   interpolation
    par_name <- grep('^p', names(scen@modInp@parameters), value = TRUE)
    par_name <- par_name[!(par_name %in% c(c('pEmissionFactor', 'pTechEmisComm', 'pDiscount')))]
    par_name <- grep('^p.+Weather', par_name, value = TRUE, invert = TRUE) 
    # Get repository / class structure
    rep_class <- NULL
    for (i in seq_along(scen@model@data)) {
      rep_class <- rbind(rep_class, data.frame(repos = rep(i, length(scen@model@data[[i]]@data)), 
        class = sapply(scen@model@data[[i]]@data, class), 
        name = c(sapply(scen@model@data[[i]]@data, function(x) x@name)),
        stringsAsFactors = FALSE))
    }
    # Trim data
    for (pr in par_name) {
      tmp <- scen@modInp@parameters[[pr]]
      if (!is.null(tmp@misc$class) && (length(tmp@colName) != 1 || tmp@colName != '') && length(tmp@dimSetNames) > 1) {
        # Get prototype
        prot <- new(tmp@misc$class)
        psb_slot <- getSlots(tmp@misc$class)
        psb_slot <- names(psb_slot)[psb_slot == 'data.frame']
        psb_slot <- psb_slot[!(psb_slot %in% c('defVal', 'interpolation'))]
        fl <- sapply(psb_slot, function(x) any(colnames(slot(prot, x)) %in% tmp@colName))
        if (sum(fl) != 1) stop('Internal error')
        slt <- psb_slot[fl]
        need_col <- tmp@dimSetNames[tmp@dimSetNames %in% colnames(slot(prot, slt))]
        if (any(pr == c('pDummyImportCost', 'pDummyExportCost'))) need_col <- need_col[need_col != 'comm']
        if (tmp@type == 'simple') val_col <- tmp@colName else 
          val_col <- c(tmp@colName, gsub('[.].*', '.fx', tmp@colName[1]))
        # Try find reduce column
        rep_class2 <- rep_class[rep_class$class == tmp@misc$class, ]
        i <- 0
        while (i < nrow(rep_class2) && length(need_col) != 0) {
          i <- i + 1
          tbl <- slot(scen@model@data[[rep_class2[i, 'repos']]]@data[[rep_class2[i, 'name']]], slt)
          if (nrow(tbl) > 0)
            need_col <- need_col[apply(is.na(tbl[apply(!is.na(tbl[, val_col, drop = FALSE]), 1, any), need_col, drop = FALSE]), 2, all)]
        }
        if (length(need_col) > 0) {
          scen@modInp@parameters[[pr]]@misc$rem_col <- seq_along(tmp@dimSetNames)[tmp@dimSetNames %in% need_col]
          scen@modInp@parameters[[pr]]@misc$not_need_interpolate <- need_col
          scen@modInp@parameters[[pr]]@misc$init_dim <- tmp@dimSetNames
          scen@modInp@parameters[[pr]]@dimSetNames <- tmp@dimSetNames[!(tmp@dimSetNames %in% need_col)]
          scen@modInp@parameters[[pr]]@data <- scen@modInp@parameters[[pr]]@data[, !(colnames(scen@modInp@parameters[[pr]]@data) %in% need_col), drop = FALSE]
        }
      }
    }
  }
  
  scen@modInp <- .add0(scen@modInp, scen@model@sysInfo, approxim = approxim) 
  
  # Add discount data to approxim
  approxim <- .add_discount_approxim(scen, approxim)
  
  # Remove early retirement if not need
  if (!scen@model@early.retirement) {
    scen <- .remove_early_retirment(scen)
  }
  approxim$debug <- scen@model@sysInfo@debug
  # Fill slice level for commodity if not defined
  scen <- .fill_default_slice_leve4comm(scen, def.level = approxim$slice@default_slice_level)
  # Add commodity slice_level map to approxim
  approxim$commodity_slice_map <- .get_map_commodity_slice_map(scen)
  scen@misc$approxim <- approxim
  
  # Fill set list for interpolation and os one  
  scen <- .add_name_for_basic_set(scen, approxim)
  scen@modInp@set <- lapply(scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])



  
  ## Begin interpolate data   by year, slice, ...
  # Begin interpolate data  
  if (arg$echo) cat('Interpolation: ')
  interpolation_count <- .get_objects_count(scen) + 61
  len_name <- .get_objects_len_name(scen)
  if (arg$n.threads == 1) {
    scen <- .add2_nthreads_1(0, 1, scen, arg, approxim, interpolation_time_begin = interpolation_time_begin, 
                             interpolation_count = interpolation_count, len_name = len_name)
  } else {
    use_par <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) nrow(x@data) == 0)]
    require(parallel)
    cl <- makeCluster(arg$n.threads)
    scen_pr <- parLapply(cl, 0:(arg$n.threads - 1), .add2_nthreads_1, arg$n.threads, scen, arg, approxim, 
                         interpolation_time_begin, interpolation_count, len_name)
    stopCluster(cl)
    scen <- .merge_scen(scen_pr, use_par)
  }
  # Remove group duplication
  scen@modInp@parameters$group <- .unique_set(scen@modInp@parameters$group)
  
  # Tune for LEC 
  if (length(scen@model@LECdata) != 0) {
    scen@modInp@parameters$mLECRegion <- addMultipleSet(scen@modInp@parameters$mLECRegion, scen@model@LECdata$region)
    if (length(obj@LECdata$pLECLoACT) == 1) {
      scen@modInp@parameters$pLECLoACT <- addData(scen@modInp@parameters$pLECLoACT, 
                                           data.frame(region = scen@model@LECdata$region, value = scen@model@LECdata$pLECLoACT))
    }
  }
  # Reduce mapping
  scen@modInp <- .write_mapping(scen@modInp, interpolation_count = interpolation_count,
                                interpolation_time_begin = interpolation_time_begin, len_name = len_name)
  
  # Clean parameters, need when nValues != -1, and mean that add NA row for speed
  for(i in names(scen@modInp@parameters)) {
    if (scen@modInp@parameters[[i]]@nValues != -1) {
      scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[
        seq(length.out = scen@modInp@parameters[[i]]@nValues),, drop = FALSE]
    }
  }
  scen@source <- energyRt:::.modelCode
  scen@status$interpolated <- TRUE

  # Check parameters
  scen <- .check_scen_par(scen)
  if (arg$echo) cat(' ', round(proc.time()[3] - interpolation_time_begin, 2), 's\n')
  
  invisible(scen)
}
