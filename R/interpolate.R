# interpolate(scenario, overwrite = TRUE) - updates interpolation in scenario objects

# solver_solve(scenario, interpolate = NULL) - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
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
  
  interpolation.time.begin <- proc.time()[3]
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (arg$echo) cat('Interplote model\n')
  
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
  if (is.null(arg$n.threads))  arg$n.threads <- detectCores()
  if (is.null(arg$startYear) != is.null(arg$fixTo)) 
    stop('startYear && fixTo have to define both (or not define both')
  if (!is.null(arg$year)) scen@model@sysInfo@year <- arg$year  
  if (!is.null(arg$repository)) scen@model <- .add.repository(scen@model, arg$repository)
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
    obj <- setMilestoneYears(obj, start = scen@model@sysInfo@year[1], 
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
  approxim <- list(
    region = scen@model@sysInfo@region,
    year   = scen@model@sysInfo@year,
    slice  = scen@model@sysInfo@slice,
    solver = arg$solver,
    mileStoneYears = scen@model@sysInfo@milestone$mid,
    mileStoneForGrowth = xx
  )
  # Fill basic parameter interplotaion from sysInfo
  scen@modInp <- .read_default_data(scen@modInp, scen@model@sysInfo)
  
  # Fill slice level for commodity if not defined
  scen <- .fill_default_slice_leve4comm(scen, def.level = approxim$slice@default_slice_level)
  # Add commodity slice_level map to approxim
  approxim$commodity_slice_map <- .get_map_commodity_slice_map(scen)

  # Fill set list for interpolation and os one  
  scen@modInp@set <- lapply(scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])

  ## Begin interpolate data   by year, slice, ...
  # Begin interpolate data  
  if (arg$echo) cat('Generating model input files ')
  if (arg$n.threads == 1) {
    scen <- add0.nthreads_1(scen, arg)
  } else {
    stop('have to do')
  }
  scen@modInp <- add0(scen@modInp, scen@model@sysInfo, approxim = approxim) 
  if (arg$echo) cat(' ', round(proc.time()[3] - interpolation.time.begin, 2), 's\n')
  # Tune for LEC 
  if (length(scen@model@LECdata) != 0) {
    prec@parameters$mLECRegion <- addMultipleSet(scen@modInp@parameters$mLECRegion, scen@model@LECdata$region)
    if (length(obj@LECdata$pLECLoACT) == 1) {
      scen@modInp@parameters$pLECLoACT <- addData(scen@modInp@parameters$pLECLoACT, 
                                           data.frame(region = scen@model@LECdata$region, value = scen@model@LECdata$pLECLoACT))
    }
  }
  # Reduce mapping
  scen@modInp <- .reduce_mapping(scen@modInp)  
  scen
}
