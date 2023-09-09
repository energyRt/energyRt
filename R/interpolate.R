# interpolate(scenario, overwrite = TRUE) - updates interpolation in scenario objects

# solve_model(scenario, interpolate = NULL) - solves scenario, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
# returns list with solution status and folder

# read_solution(scen = NULL, folder) - reads results and updates scen, if scen = NULL, creates empty scenario with solution data


# The function creates scenario object with interpolated data, ready to pass to a solver
interpolate <- function(obj, ...) { #- returns class scenario
  ## arguments
  # obj - scenario or model
  # name
  # description
  # n.threads - number of threads use for approximation
  # startYear && fixTo have to define both (or not define both) - run with startYear
  # year - basic horizon year definition (not recommended for use), use only if horizon not defined
  # discount - define discount, not good practice
  # region - define region, not good practice
  # repository - class for add to model (repository or list of repository)
  # echo - print working data

  arg <- list(...)

  interpolation_start_time <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE

  if (class(obj) == "model") {
    scen <- new("scenario")
    scen@model <- obj
    scen@name <- "Default scenario name"
    scen@description <- "Default description"
  } else if (class(obj) == "scenario") {
    scen <- obj
  } else {
    stop('Interpolation is not available for class: "', class(obj), '"')
  }

  if (!is.null(arg$name)) scen@name <- arg$name
  if (!is.null(arg$description)) scen@description <- arg$description
  if (is.null(arg$n.threads)) arg$n.threads <- 1 #+ 0 * detectCores()
  if (is.null(arg$startYear) != is.null(arg$fixTo)) {
    stop("startYear && fixTo have to define both (or not define both")
  }
  if (!is.null(arg$year)) scen@model@sysInfo@year <- arg$year
  if (!is.null(arg$repository)) scen@model <- .add_repository(scen@model, arg$repository)
  if (!is.null(arg$region)) scen@model@sysInfo@region <- arg$region
  if (!is.null(arg$discount)) scen@model@sysInfo@discount <- arg$discount
  if (is.null(arg$verbose)) arg$verbose <- 0

  ### Interpolation
  scen@modInp <- new("modInp")
  ## Fill basic sets
  # Fill year
  if (!is.null(arg$year)) {
    if (nrow(scen@model@sysInfo@horizon) != 0) {
      stop("argument can't use with horizon")
    }
    scen@model@sysInfo@year <- arg$year
  }
  if (nrow(scen@model@sysInfo@horizon) == 0) {
    if (any(sort(scen@model@sysInfo@year) != scen@model@sysInfo@year) ||
      max(scen@model@sysInfo@year) - min(scen@model@sysInfo@year) + 1 !=
      length(scen@model@sysInfo@year)) {
      stop("wrong year parameter")
    }
    scen@model <- setHorizon(scen@model,
      start = scen@model@sysInfo@year[1],
      interval = rep(1, length(scen@model@sysInfo@year))
    )
  }

  scen@modInp@parameters[["year"]] <-
    .dat2par(scen@modInp@parameters[["year"]], scen@model@sysInfo@year)
  # browser()
  scen@modInp@parameters[["mMidMilestone"]] <-
    .dat2par(scen@modInp@parameters[["mMidMilestone"]],
              data.frame(year = scen@model@sysInfo@horizon$mid)
  )
  # Fill slice
  scen@model@sysInfo@slice <- .init_slice(scen@model@sysInfo@slice)
  # browser()
  if (mean(scen@model@sysInfo@yearFraction$fraction) != 1.) {
    # filter out unused slices
    # browser()
    warning(
      "Solving for a fraction of a year, status: experimental. ",
      "Currently only capacity and some totals (`vOutTot` and `vEmsFuelTot`)",
      " variables have been scaled (using the given yearFraction parameter)",
      " to represent annual values of capacity, total output, and emissions.",
      " Hourly (or lower slice level) variables have not been scaled,",
      " their annual sum will be different from their annual aggregates."
    )
    scen@model@data <- subset_slices_repo(
      repo = scen@model@data,
      yearFraction = mean(scen@model@sysInfo@yearFraction$fraction),
      keep_slices = scen@model@sysInfo@slice@all_slice
    )
  }
  # !!!??? add filtering slices here
  # nslices <- nrow(scen@model@sysInfo@slice@levels)
  # scen@model@sysInfo@slice@levels$share <- scen@model@sysInfo@slice@levels$share * nslices/8760
  # scen@model@sysInfo@slice@slice_share$share <- scen@model@sysInfo@slice@slice_share$share * nslices/8760
  #
  scen@modInp@parameters[["slice"]] <- .dat2par(
    scen@modInp@parameters[["slice"]],
    scen@model@sysInfo@slice@all_slice
  )
  # Fill region
  scen@modInp@parameters[["region"]] <-
    .dat2par(scen@modInp@parameters[["region"]], scen@model@sysInfo@region)

  # List for approximation
  # Generate approxim list, that contain basic data for approximation
  xx <- c(obj@sysInfo@horizon$mid[-1] -
    obj@sysInfo@horizon$mid[-nrow(obj@sysInfo@horizon)], 1)
  names(xx) <- obj@sysInfo@horizon$mid

  if (is.null(arg$fullsets)) fullsets <- TRUE else fullsets <- arg$fullsets
  scen@status$fullsets <- fullsets # !!!???

  approxim <- list(
    region = scen@model@sysInfo@region,
    year = scen@model@sysInfo@year,
    slice = scen@model@sysInfo@slice,
    solver = arg$solver,
    mileStoneYears = scen@model@sysInfo@horizon$mid,
    mileStoneForGrowth = xx,
    fullsets = fullsets
  )
  approxim$ry <- merge(
    data.frame(region = approxim$region, stringsAsFactors = FALSE),
    data.frame(year = approxim$mileStoneYears, stringsAsFactors = FALSE)
  )
  approxim$rys <- merge(
    approxim$ry,
    data.frame(slice = approxim$slice@all_slice, stringsAsFactors = FALSE)
  )

  # Basic interpolation parameter from sysInfo
  approxim$all_comm <-
    c(lapply(scen@model@data, function(x) {
      c(lapply(x@data, function(y) {
        if (class(y) != "commodity") {
          return(NULL)
        }
        return(y@name)
      }), recursive = TRUE)
    }), recursive = TRUE)
  names(approxim$all_comm) <- NULL
  scen@modInp <- .read_default_data(scen@modInp, scen@model@sysInfo)

  # (Optional/experimental) trimming the model == dropping unused dimensions
  if (!is.null(arg$trim) && arg$trim) {
    ## Trim before interpolation
    par_name <- grep("^p", names(scen@modInp@parameters), value = TRUE)
    par_name <- par_name[!(par_name %in%
                             c("pEmissionFactor", "pTechEmisComm", "pDiscount"))]
    # Get repository / class structure
    rep_class <- NULL
    for (i in seq_along(scen@model@data)) {
      rep_class <- rbind(rep_class, data.frame(
        repos = rep(i, length(scen@model@data[[i]]@data)),
        class = sapply(scen@model@data[[i]]@data, class),
        name = c(sapply(scen@model@data[[i]]@data, function(x) x@name)),
        stringsAsFactors = FALSE
      ))
    }
    # Trim data
    for (pr in par_name) {
      tmp <- scen@modInp@parameters[[pr]]
      if (!is.null(tmp@misc$class) &&
          (length(tmp@colName) != 1 || tmp@colName != "") &&
          length(tmp@dimSets) > 1) {
        # Get prototype
        prot <- new(tmp@misc$class)
        psb_slot <- getSlots(tmp@misc$class)
        psb_slot <- names(psb_slot)[psb_slot == "data.frame"]
        psb_slot <- psb_slot[!(psb_slot %in% c("defVal", "interpolation"))]
        fl <- sapply(psb_slot, function(x) {
          any(colnames(slot(prot, x)) %in% tmp@colName)
          })
        if (sum(fl) != 1) stop("Internal error")
        slt <- psb_slot[fl]
        need_col <- tmp@dimSets[tmp@dimSets %in% colnames(slot(prot, slt))]
        if (any(pr == c("pDummyImportCost", "pDummyExportCost")))
          need_col <- need_col[need_col != "comm"]
        if (tmp@type == "numpar") {
          val_col <- tmp@colName
        } else {
          val_col <- c(tmp@colName, gsub("[.].*", ".fx", tmp@colName[1]))
        }
        # Try find reduce column
        rep_class2 <- rep_class[rep_class$class == tmp@misc$class, ]
        i <- 0
        while (i < nrow(rep_class2) && length(need_col) != 0) {
          i <- i + 1
          tbl <- slot(scen@model@data[[rep_class2[i, "repos"]]]@data[[rep_class2[i, "name"]]], slt)
          if (nrow(tbl) > 0) {
            need_col <- need_col[apply(is.na(tbl[apply(!is.na(tbl[, val_col, drop = FALSE]), 1, any), need_col, drop = FALSE]), 2, all)]
          }
        }
        if (length(need_col) > 0) {
          scen@modInp@parameters[[pr]]@misc$rem_col <-
            seq_along(tmp@dimSets)[tmp@dimSets %in% need_col]
          scen@modInp@parameters[[pr]]@misc$not_need_interpolate <- need_col
          scen@modInp@parameters[[pr]]@misc$init_dim <- tmp@dimSets
          scen@modInp@parameters[[pr]]@dimSets <-
            tmp@dimSets[!(tmp@dimSets %in% need_col)]
          scen@modInp@parameters[[pr]]@data <-
            scen@modInp@parameters[[pr]]@data[,!(colnames(
              scen@modInp@parameters[[pr]]@data) %in% need_col), drop = FALSE]
          if (arg$verbose >= 1) {
            scen@misc$trimDroppedDimensions <- rbind(
              scen@misc$trimDroppedDimensions,
              data.frame(parameter = rep(pr, length(need_col)),
                         dimname = need_col, stringsAsFactors = FALSE)
            )
            warning(paste0('Dropping dimension "',
                           paste0(need_col, collapse = '", "'),
                           '" from parameter "', pr, '"'))
          }
        }
      }
    }
  }

  scen@modInp <- .obj2modInp(scen@modInp, scen@model@sysInfo, approxim = approxim)

  # Add discount data to approxim
  approxim <- .add_discount_approxim(scen, approxim)

  # Update early retirement parameter
  # browser()
  if (!scen@config@earlyRetirement) {
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
  scen@modInp@set <-
    lapply(scen@modInp@parameters[sapply(scen@modInp@parameters,
                                         function(x) x@type == "set")],
           function(x) .get_data_slot(x)[, 1])

  ## interpolate data by year, slice, ...
  if (arg$echo) cat("Interpolation: ")
  interpolation_count <- .get_objects_count(scen) + 46
  len_name <- .get_objects_len_name(scen)
  if (arg$n.threads == 1) {
    # scen <- .add2_nthreads_1(0, 1, scen, arg, approxim,
    #   interpolation_start_time = interpolation_start_time,
    #   interpolation_count = interpolation_count, len_name = len_name
    # )
  } else {
    warning("Multiple threads are not implemented yet, ignoring `n.threads` parameter")
    # use_par <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) nrow(x@data) == 0)]
    # # require(parallel)
    # cl <- makeCluster(arg$n.threads)
    # scen_pr <- parLapply(
    #   cl, 0:(arg$n.threads - 1), .add2_nthreads_1, arg$n.threads, scen, arg, approxim,
    #   interpolation_start_time, interpolation_count, len_name
    # )
    # stopCluster(cl)
    # scen <- .merge_scen(scen_pr, use_par)
  }
  scen <- .add2_nthreads_1(n.thread = 0, max.thread = 1,
                           scen = scen, arg = arg, approxim = approxim,
                           interpolation_start_time = interpolation_start_time,
                           interpolation_count = interpolation_count,
                           len_name = len_name
                           )

  # Remove duplicates
  scen@modInp@parameters$group <- .unique_set(scen@modInp@parameters$group)
  scen@modInp@parameters$mvDemInp <- .unique_set(scen@modInp@parameters$mvDemInp)

  # Check for unknown set in constraints
  .check_constraint(scen)
  # Check for unknown weather
  .check_weather(scen)
  # Check for unknown set in model and duplicated set
  .check_sets(scen)

  # Tune for LEC
  # if (length(scen@model@LECdata) != 0) {
  #   scen@modInp@parameters$mLECRegion <-
  #     addMultipleSet(
  #       scen@modInp@parameters$mLECRegion,
  #       scen@model@LECdata$region
  #     )
  #   if (length(obj@LECdata$pLECLoACT) == 1) {
  #     scen@modInp@parameters$pLECLoACT <- .dat2par(
  #       scen@modInp@parameters$pLECLoACT,
  #       data.frame(
  #         region = scen@model@LECdata$region,
  #         value = scen@model@LECdata$pLECLoACT
  #       )
  #     )
  #   }
  # }
  # Reduce mapping
  scen@modInp <- .write_mapping(scen@modInp,
    interpolation_count = interpolation_count,
    interpolation_start_time = interpolation_start_time, len_name = len_name
  )

  # Clean parameters, need when nValues != -1, and mean that add NA row for speed
  for (i in names(scen@modInp@parameters)) {
    if (scen@modInp@parameters[[i]]@nValues != -1) {
      scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[
        seq(length.out = scen@modInp@parameters[[i]]@nValues), ,
        drop = FALSE
      ]
    }
  }
  scen@source <- .modelCode
  scen@status$interpolated <- TRUE

  # Check parameters
  scen <- .check_scen_par(scen)
  if (arg$echo) cat(" ", round(proc.time()[3] - interpolation_start_time, 2), "s\n")

  invisible(scen)
}

subset_slices <- function(obj, yearFraction = 1, keep_slices = NULL) {
  # subset_hours <- length(SLICE_SUBSET)
  # subset_fraction <- subset_hours/8760
  if (yearFraction == 1) {
    return(obj)
  }
  keep_slices <- unique(c(NA, "ANNUAL", keep_slices))
  if (inherits(obj, "data.frame")) { # unnesecary - reserved for future
    if (any(names(obj) == "slice")) {
      obj <- filter(obj, slice %in% keep_slices)
    }
    return(obj)
  } else if (!isS4(obj)) {
    return(obj)
  }
  # S4
  slot_names <- slotNames(obj)
  ii <- sapply(slot_names, function(x) {
    inherits(slot(obj, x), "data.frame") &&
      any(colnames(slot(obj, x)) == "slice")
  })
  # summary(ii)
  for (s in slot_names[ii]) {
    # stop()
    slot(obj, s) <- slot(obj, s) %>%
      filter(slice %in% keep_slices)
  }
  #
  # obj <- fract_year_adj(obj, subset_hours, check = TRUE)
  #
  return(obj)
}

subset_slices_repo <- function(repo, yearFraction = 1, keep_slices = NULL) {
  # browser()
  if (yearFraction == 1) {
    return(repo)
  }

  if (inherits(repo, "list")) {
    repo <- lapply(repo, function(o) {
      subset_slices_repo(o, yearFraction, keep_slices)
    })
  }
  # stopifnot(inherits(repo, c("repository")))
  # if (repo)
  # subset_hours <- length(SLICE_SUBSET)
  # subset_fraction <- subset_hours/8760
  # i <- 19
  # browser()
  if (inherits(repo, c("repository"))) {
    x <- repo@data
  } else {
    x <- repo
  }

  for (i in 1:length(x)) {
    # print(i)
    obj <- x[[i]]
    if (inherits(obj, c("repository"))) {
      # obj <- fract_year_adj_repo(obj, subset_hours, check)
      subset_slices_repo(obj, yearFraction, keep_slices)
    } else {
      # print(obj@name)
      # obj <- fract_year_adj(obj, subset_hours, check)
      obj <- subset_slices(obj, yearFraction, keep_slices)
    }
    x[[i]] <- obj
  }
  if (inherits(repo, c("repository"))) {
    repo@data <- x
  } else {
    repo <- x
  }
  return(repo)
}

# Check parameters
.check_scen_par <- function(scen) {
  # Check for non negative parameters, all except 'pAggregateFactor', 'pTechCvarom', 'pTechAvarom', 'pTechVarom', 'pTechInvcost'
  non_negative <- unique(c(
    "pSliceShare", "pTechOlife", "pTechCinp2ginp", "pTechGinp2use", "pTechCinp2use", "pTechUse2cact", "pTechCact2cout",
    "pTechEmisComm", "pTechAct2AInp", "pTechCap2AInp", "pTechNCap2AInp", "pTechCinp2AInp", "pTechCout2AInp",
    "pTechAct2AOut", "pTechCap2AOut", "pTechNCap2AOut", "pTechCinp2AOut", "pTechCout2AOut", "pTechFixom", "pTechShare",
    "pTechShare", "pTechAf", "pTechAf", "pTechAfs", "pTechAfs", "pTechAfc", "pTechAfc", "pTechStock", "pTechCap2act", "pDiscount",
    "pDiscountFactor", "pSupCost", "pSupAva", "pSupAva", "pSupReserve", "pSupReserve", "pDemand", "pEmissionFactor", "pDummyImportCost", "pDummyExportCost",
    "pTaxCostInp", "pSubCostInp", "pTaxCostOut", "pSubCostOut", "pTaxCostBal", "pSubCostBal",
    "pWeather", "pSupWeather", "pSupWeather", "pTechWeatherAf", "pTechWeatherAf", "pTechWeatherAfs", "pTechWeatherAfs",
    "pTechWeatherAfc", "pTechWeatherAfc", "pStorageWeatherAf", "pStorageWeatherAf", "pStorageWeatherCinp", "pStorageWeatherCinp", "pStorageWeatherCout",
    "pStorageWeatherCout", "pStorageInpEff", "pStorageOutEff", "pStorageStgEff", "pStorageStock", "pStorageOlife", "pStorageCostStore", "pStorageCostInp",
    "pStorageCostOut", "pStorageFixom", "pStorageInvcost", "pStorageCap2stg", "pStorageAf", "pStorageAf", "pStorageCinp", "pStorageCinp", "pStorageCout",
    "pStorageCout", "pStorageStg2AInp", "pStorageStg2AOut", "pStorageCinp2AInp", "pStorageCinp2AOut", "pStorageCout2AInp", "pStorageCout2AOut", "pStorageCap2AInp",
    "pStorageCap2AOut", "pStorageNCap2AInp", "pStorageNCap2AOut", "pTradeIrEff", "pTradeIr", "pTradeIr", "pTradeIrCost", "pTradeIrMarkup", "pTradeIrCsrc2Ainp",
    "pTradeIrCsrc2Aout", "pTradeIrCdst2Ainp", "pTradeIrCdst2Aout", "pExportRowRes", "pExportRow", "pExportRow", "pExportRowPrice", "pImportRowRes", "pImportRow",
    "pImportRow", "pImportRowPrice"
  ))
  msg_small_err <- NULL
  for (i in non_negative) {
    if (any(scen@modInp@parameters[[i]]@data$value < 0)) {
      if (any(scen@modInp@parameters[[i]]@data$value < -1e-7)) {
        msg <- paste0('Parameter: "', i, '" have to only non negative value\nWrong data:')
        tmp <- scen@modInp@parameters[[i]]@data[scen@modInp@parameters[[i]]@data$value < 0, , drop = FALSE]
        msg <- c(msg, capture.output(print(tmp[1:min(c(10, nrow(tmp))), , drop = FALSE])))

        if (nrow(tmp) > 10) {
          msg <- c(msg, paste0("Show only first 10 errors data, from ", nrow(tmp), "\n"))
        }
        stop(paste0(msg, collapse = "\n"))
      } else {
        msg_small_err <- c(msg_small_err, i)
        scen@modInp@parameters[[i]]@data[scen@modInp@parameters[[i]]@data$value > -1e-7 &
          scen@modInp@parameters[[i]]@data$value < 0, "value"] <- 0
      }
    }
  }
  if (length(msg_small_err) > 0) {
    warning(paste0(
      "There small negative value (abs(err) < 1e-7) in parameter", "s"[length(msg_small_err) > 1], ': "',
      paste0(msg_small_err, collapse = '", "'), '". Assigned as zerro.'
    ))
  }
  # Check share
  if (nrow(scen@modInp@parameters$pTechShare@data) > 0) {
    mTechGroupComm <- .get_data_slot(scen@modInp@parameters$mTechGroupComm)
    # scen@modInp@parameters$pTechShare@data <- merge(scen@modInp@parameters$pTechShare@data, mTechGroupComm)
    # if (scen@modInp@parameters$pTechShare@nValues != - 1)
    # 		scen@modInp@parameters$pTechShare@nValues <- nrow(scen@modInp@parameters$pTechShare@data)
    tmp <- .add_dropped_zeros(scen@modInp, "pTechShare")
    mTechSpan <- .get_data_slot(scen@modInp@parameters$mTechSpan)
    tmp <- merge(tmp, mTechSpan)
    tmp_lo <- merge(tmp[tmp$type == "lo", , drop = FALSE], mTechGroupComm)
    tmp_up <- merge(tmp[tmp$type == "up", , drop = FALSE], mTechGroupComm)
    tmp_lo <- aggregate(tmp_lo[, "value", drop = FALSE], tmp_lo[, !(colnames(tmp_lo) %in% c("type", "comm", "value")), drop = FALSE], sum)
    tmp_up <- aggregate(tmp_up[, "value", drop = FALSE], tmp_up[, !(colnames(tmp_up) %in% c("type", "comm", "value")), drop = FALSE], sum)
    if (any(tmp_lo$value > 1) || any(tmp_up$value < 1)) {
      tech_wrong_lo <- tmp_lo[tmp_lo$value > 1, , drop = FALSE]
      tech_wrong_up <- tmp_up[tmp_up$value < 1, , drop = FALSE]
      tech_wrong <- unique(c(tech_wrong_up$tech, tech_wrong_lo$tech))
      assign("tech_wrong_lo", tech_wrong_lo, globalenv())
      assign("tech_wrong_up", tech_wrong_up, globalenv())
      stop(paste0(
        "There are wrong share (sum of up less than one or sum of lo large than one)  (wrong data in data frame tech_wrong_lo and tech_wrong_up)",
        ' for technology "', paste0(tech_wrong, collapse = '", "'), '"'
      ))
    }
    fl <- colnames(tmp)[!(colnames(tmp) %in% c("type"))]
    tmp_cmd <- merge(tmp[tmp$type == "lo", fl, drop = FALSE], tmp[tmp$type == "up", fl, drop = FALSE], by = fl[fl != "value"])
    if (any(tmp_cmd$value.x > tmp_cmd$value.y)) {
      tech_wrong <- tmp_cmd[tmp_cmd$value.x > tmp_cmd$value.y, , drop = FALSE]
      assign("tech_wrong", tech_wrong, globalenv())
      stop(paste0(
        'There are wrong share (for tuple (tech, comm, region, year, slice) lo share large than up) (wrong data in data frame tech_wrong) for technology "',
        paste0(unique(tech_wrong$tech), collapse = '", "'), '"'
      ))
    }
  }
  scen
}

.unique_set <- function(obj) {
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues), , drop = FALSE]
    obj@data <- obj@data[!duplicated(obj@data), , drop = FALSE]
  }
  obj@data <- obj@data[!duplicated(obj@data), , drop = FALSE]
  if (obj@nValues != -1) {
    obj@nValues <- nrow(obj@data)
  }
  return(obj)
}

# Read default parameter from sysInfo
.read_default_data <- function(prec, ss) {
  for (i in seq(along = prec@parameters)) {
    # assign('test', prec@parameters[[i]], globalenv())
    if (any(prec@parameters[[i]]@colName != "")) {
      prec@parameters[[i]]@defVal <-
        as.numeric(ss@defVal[1, prec@parameters[[i]]@colName])
      prec@parameters[[i]]@interpolation <-
        as.character(ss@interpolation[1, prec@parameters[[i]]@colName])
    }
  }
  prec
}

.add_repository <- function(mdl, x) {
  if (class(x) == "list") {
    for (i in seq_along(x)) {
      mdl <- .add.repository(mdl, x[[i]])
    }
  } else {
    mdl <- add(mdl, x)
  }
  mdl
}

.add_discount_approxim <- function(scen, approxim) {
  approxim$discountFactor <- .add_dropped_zeros(scen@modInp,
                                                "pDiscountFactor", FALSE)
  approxim$discount <- .add_dropped_zeros(scen@modInp, "pDiscount", FALSE)
  yy <- approxim$discountFactor
  # ll <- NULL
  # for (rg in unique(yy$region)) {
  # 	l1 <- yy[yy$region == rg, ]
  # 	l1$value <- cumsum(l1$value)
  # 	if (is.null(ll)) ll <- l1 else ll <- rbind(ll, l1)
  # }
  # approxim$discountCum <- ll
  approxim
}
# Get commodity slice map for interpolate
.get_map_commodity_slice_map <- function(obj) {
  xx <- list()
  for (i in seq(along = obj@data)) {
    for (j in seq(along = obj@data[[i]]@data)) { #
      prec <- .add2set(prec, obj@data[[i]]@data[[j]], approxim = approxim)
      if (class(obj@data[[i]]@data[[j]]) == "commodity") {
        if (length(obj@data[[i]]@data[[j]]@slice) == 0) {
          obj@data[[i]]@data[[j]]@slice <- approxim$slice@default_slice_level
        }
        commodity_slice_map[[obj@data[[i]]@data[[j]]@name]] <- obj@data[[i]]@data[[j]]@slice
      }
    }
  }
}

# Apply func to data in scenario by class and return scenario
.apply_to_code_ret_scen <- function(scen, func, ..., clss = NULL) {
  for (i in seq(along = scen@model@data)) {
    for (j in seq(along = scen@model@data[[i]]@data)) {
      if (is.null(clss) || any(class(scen@model@data[[i]]@data[[j]]) == clss)) {
        scen@model@data[[i]]@data[[j]] <- func(scen@model@data[[i]]@data[[j]],
                                               ...)
      }
    }
  }
  scen
}

# Apply func to data in scenario by class and return list
.apply_to_code_ret_list <- function(scen, func, ..., clss = NULL,
                                    need.name = TRUE) {
  rs <- list()
  for (i in seq(along = scen@model@data)) {
    for (j in seq(along = scen@model@data[[i]]@data)) {
      if (is.null(clss) || any(class(scen@model@data[[i]]@data[[j]]) == clss)) {
        if (need.name) {
          rr <- func(scen@model@data[[i]]@data[[j]], ...)
          rs[[rr$name]] <- rr$val
        } else {
          rs[[length(rs) + 1]] <- func(scen@model@data[[i]]@data[[j]], ...)
        }
      }
    }
  }
  rs
}

# Fill slice level for commodity if not defined
.fill_default_slice_leve4comm <- function(scen, def.level) {
  .apply_to_code_ret_scen(
    scen = scen, clss = "commodity", def.level,
    func = function(x, def.level) {
      if (length(x@slice) == 0) x@slice <- def.level
      x
    }
  )
}

# Add name for basic set
.add_name_for_basic_set <- function(scen, approxim) {
  for (i in seq(along = scen@model@data)) {
    for (j in seq(along = scen@model@data[[i]]@data)) {
      scen@modInp <- .add2set(scen@modInp, scen@model@data[[i]]@data[[j]], approxim)
    }
  }
  scen
}

.remove_early_retirment <- function(scen) {
  scen <- .apply_to_code_ret_scen(
    scen = scen, clss = "technology",
    func = function(x) {
      x@earlyRetirement <- FALSE
      x
    }
  )
  scen
}

# Add commodity slice_level map to approxim
.get_map_commodity_slice_map <- function(scen) {
  .apply_to_code_ret_list(scen = scen, clss = "commodity", func = function(x) {
    list(name = x@name, val = x@slice)
  })
}



# Implement add0 for all parameters
.add2_nthreads_1 <- function(n.thread, max.thread, scen, arg, approxim,
                             interpolation_start_time, interpolation_count, len_name) {
  # A couple of string for progress bar
  num_classes_for_progrees_bar <- sum(c(sapply(scen@model@data,
                                               function(x) length(x@data)),
                                        recursive = TRUE))
  # if (num_classes_for_progrees_bar < 50) {
  #   need.tick <- rep(TRUE, num_classes_for_progrees_bar)
  # } else {
  #   need.tick <- rep(FALSE, num_classes_for_progrees_bar)
  #   need.tick[trunc(seq(1, num_classes_for_progrees_bar, length.out = 50))] <- TRUE
  # }
  # Fill DB main data
  tmlg <- 0
  mnch <- 0
  cat(rep(" ", len_name), sep = "")
  k <- 0
  time.log.nm <- rep(NA, num_classes_for_progrees_bar)
  time.log.tm <- rep(NA, num_classes_for_progrees_bar)
  mdinp <- list()
  for (i in seq(along = scen@model@data)) {
    for (j in seq(along = scen@model@data[[i]]@data)) {
      k <- k + 1
      if (k %% max.thread == n.thread) {
        tmlg <- tmlg + 1
        if (arg$echo) {
          .interpolation_message(scen@model@data[[i]]@data[[j]]@name, k, interpolation_count,
                                 interpolation_start_time = interpolation_start_time, len_name
          )
        }
        p1 <- proc.time()[3]
        # tryCatch({
        if (class(scen@model@data[[i]]@data[[j]]) == "constraint") {
          scen@modInp <- .obj2modInp(scen@modInp, scen@model@data[[i]]@data[[j]], approxim = approxim)
        } else {
          mdinp[[length(mdinp) + 1]] <- .obj2modInp(scen@modInp, scen@model@data[[i]]@data[[j]], approxim = approxim)@parameters
        }
        # }, error = function(e) {
        #   assign('add0_message', list(tracedata = sys.calls(),
        #     add0_arg = list(obj = scen@modInp, app = scen@model@data[[i]]@data[[j]], approxim = approxim)),
        #     globalenv())
        #   message('\nError in .obj2modInp function, additional info in "add0_message" object\n')
        #   stop(e)
        # })
        time.log.nm[tmlg] <- scen@model@data[[i]]@data[[j]]@name
        time.log.tm[tmlg] <- proc.time()[3] - p1
        # if (need.tick[k] && arg$echo) {
        #   cat('.')
        #   flush.console()
        # }
      }
    }
  }
  # require(data.table)
  nval <- rep(NA, length(mdinp))
  for (pr in names(mdinp[[1]])) {
    if (scen@modInp@parameters[[pr]]@nValues <= 0) {
      if (mdinp[[1]][[pr]]@nValues != -1) {
        for (i in seq_along(mdinp)) {
          nval[i] <- mdinp[[i]][[pr]]@nValues
        }
        if (any(nval != 0)) {
          scen@modInp@parameters[[pr]]@data <- as.data.frame(rbindlist(lapply(
            mdinp[nval != 0],
            function(x) x[[pr]]@data[1:x[[pr]]@nValues, , drop = FALSE]
          )))
          scen@modInp@parameters[[pr]]@nValues <- sum(nval)
        }
      } else {
        stop("don't assume that this is the case")
      }
    }
  }
  scen@misc$time.log <- data.frame(
    name = time.log.nm[seq_len(tmlg)],
    time = time.log.tm[seq_len(tmlg)], stringsAsFactors = FALSE
  )
  # if (arg$echo) cat(' ')
  if (arg$echo) {
    .remove_char(len_name)
  }
  scen
}

.merge_scen <- function(scen_pr, use_par) {
  if (scen_pr[[1]]@modInp@parameters$mCommSlice@nValues == -1) {
    stop("have to do")
  }
  scen <- scen_pr[[1]]
  scen_pr <- scen_pr[-1]
  for (nm in use_par) {
    hh <- sapply(scen_pr, function(x) x@modInp@parameters[[nm]]@nValues)
    if (sum(hh) != 0) {
      scen@modInp@parameters[[nm]]@data[scen@modInp@parameters[[nm]]@nValues +
                                          sum(hh), ] <- NA
    }
    for (i in seq_along(hh)[hh != 0]) {
      scen@modInp@parameters[[nm]]@data[scen@modInp@parameters[[nm]]@nValues +
                                          1:hh[i], ] <-
        scen_pr[[i]]@modInp@parameters[[nm]]@data[1:hh[i], ]
      scen@modInp@parameters[[nm]]@nValues <-
        scen@modInp@parameters[[nm]]@nValues + hh[i]
    }
  }
  for (i in seq_along(scen_pr)) {
    scen@misc$time.log <- rbind(scen@misc$time.log, scen_pr[[i]]@misc$time.log)
  }

  scen
}

# Implement add0 for all parameters
.get_objects_count <- function(scen) {
  sum(c(sapply(scen@model@data, function(x) length(x@data)), recursive = TRUE))
}
.get_objects_len_name <- function(scen) {
  (25 + max(c(30, max(c(sapply(scen@model@data, function(x) {
    max(sapply(x@data, function(y) nchar(y@name)))
  }), recursive = TRUE)))))
}

.interpolation_message <- function(name, num, interpolation_count,
                                   interpolation_start_time, len_name) {
  jj <- paste0(
    num, " (", interpolation_count, "),",
    paste0(rep(" ", max(c(1, 15 - (nchar(name) %% 15)))), collapse = ""),
    name, ", time: ", round(proc.time()[3] - interpolation_start_time, 2), "s"
  )
  # bug "invalid langth.out element - workaround
  length_out <- len_name - nchar(jj)
  if (length_out < 0) {
    len_name <- len_name + abs(length_out)
    length_out <- 0
  }
  jj <- paste0(jj, paste0(rep(" ", length_out), collapse = ""))
  cat(rep_len("\b", len_name), jj, sep = "") # , rep(' ', 100), rep('\b', 100)
}

.remove_char <- function(x) {
  if (is.character(x)) x <- nchar(x)
  if (x == 0) {
    return()
  }
  n1 <- paste0(rep("\b", x), collapse = "")
  cat(n1, paste0(rep(" ", x), collapse = ""), n1, sep = "")
}


.check_constraint <- function(scen) {
  # Collect sets data
  sets <- list()
  for (ss in c(
    "tech", "sup", "dem", "stg", "expp", "imp", "trade",
    "group", "comm", "region", "year", "slice"
  )) {
    sets[[ss]] <- .get_data_slot(scen@modInp@parameters[[ss]])[[ss]]
  }
  add_to_err <- function(err_msg, cns, slt, have, psb) {
    if (!all(have %in% psb)) {
      have <- unique(have[!(have %in% psb)])
      tmp <- data.frame(value = have, stringsAsFactors = FALSE)
      tmp$slot <- slt
      tmp$constraint <- cns
      return(rbind(err_msg, tmp[, c("constraint", "slot", "value"), drop = FALSE]))
    }
    return(err_msg)
  }
  sets$lag.year <- sets$year
  sets$lead.year <- sets$year
  err_msg <- NULL
  # Check sets in constraints
  for (i in seq_along(scen@model@data)) {
    for (j in seq_along(scen@model@data[[i]]@data)[
      sapply(scen@model@data[[i]]@data, class) == "constraint"]) {
      tmp <- scen@model@data[[i]]@data[[j]]
      for (k in colnames(tmp@rhs)) {
        if (k != "value" && k != "year") {
          err_msg <- add_to_err(err_msg, cns = tmp@name, slt = "rhs",
                                have = tmp@for.each[[k]], psb = sets[[k]])
        }
      }
      for (u in seq_along(tmp@lhs)) {
        for (k in colnames(tmp@lhs[[u]]@mult)) {
          if (k != "value" && k != "year") {
            err_msg <- add_to_err(err_msg, cns = tmp@name,
                                  slt = paste0("lhs (", u, ") mult"),
                                  have = tmp@lhs[[u]]@mult[[k]], psb = sets[[k]])
          }
        }
        for (k in names(tmp@lhs[[u]]@for.sum)) {
          if (k != "value" && k != "year" && !all(is.na(tmp@lhs[[u]]@for.sum[[k]]))) {
            err_msg <- add_to_err(err_msg, cns = tmp@name,
                                  slt = paste0("lhs (", u, ") for.sum"),
                                  have = tmp@lhs[[u]]@for.sum[[k]], psb = sets[[k]])
          }
        }
      }
    }
  }
  if (!is.null(err_msg)) {
    nn <- capture.output(err_msg)
    stop(paste0("There unknow sets in constrint(s)\n", paste0(nn, collapse = "\n")))
  }
}

.check_weather <- function(scen) {
  weather <- scen@modInp@parameters$weather@data$weather
  err_msg <- list()
  pars <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) {
    !is.null(x@data$weather) &&
      nrow(x@data) != 0
  })]
  for (pr in pars) {
    tmp <- scen@modInp@parameters[[pr]]@data
    tmp <- tmp[!is.na(tmp$weather) & !(tmp$weather %in% weather), , drop = FALSE]
    if (nrow(tmp) != 0) err_msg[[pr]] <- tmp
  }
  if (length(err_msg) != 0) {
    nn <- capture.output(err_msg)
    stop(paste0("There unknow weather in parameters\n", paste0(nn, collapse = "\n")))
  }
}

# Check for unknown sets
.check_sets <- function(scen) {
  lsets <- lapply(scen@modInp@parameters, function(x) {
    if (x@type == "set") .get_data_slot(x)[[1]]
  })
  lsets <- lsets[!sapply(lsets, is.null)]
  # Add alias for set
  lsets$src <- lsets$region
  lsets$dst <- lsets$region
  dset <- unique(c(lapply(scen@modInp@parameters,
                          function(x) x@dimSets), recursive = TRUE))
  dset <- dset[!(dset %in% names(lsets))]
  for (ss in dset) {
    i <- 1
    while (i <= length(lsets) && length(grep(names(lsets)[i], ss)) != 1) i <- i + 1
    if (i > length(lsets)) stop("Internal error. Alias problem")
    lsets[[ss]] <- lsets[[i]]
  }

  error_duplicated_value <- NULL
  err_dtf <- NULL
  int_err <- NULL

  for (prm in scen@modInp@parameters) {
    if (!all(prm@dimSets %in% names(lsets))) {
      int_err <- unique(c(int_err, prm@dimSets[!(prm@dimSets %in% names(lsets))]))
    } else {
      tmp <- .get_data_slot(prm)[, prm@dimSets, drop = FALSE]
      for (ss in prm@dimSets) {
        unq <- unique(tmp[[ss]])
        fl <- !(unq %in% lsets[[ss]])
        if (any(fl)) {
          err_dtf <- rbind(err_dtf, data.frame(name = prm@name, set = ss,
                                               value = unq[fl]))
        }
      }
      tmp <- .get_data_slot(prm)[, colnames(prm@data) != "value", drop = FALSE]
      tmp <- tmp[duplicated(tmp), , drop = FALSE]
      if (nrow(tmp) != 0) {
        error_duplicated_value <- rbind(
          error_duplicated_value,
          data.frame(name = prm@name, value = apply(tmp, 1, paste0, collapse = "."))
        )
      }
    }
  }
  if (length(int_err) != 0) {
    stop(paste0('Internal error. Unknown set "',
                paste0(int_err, collapse = '", "'), '"'))
  }
  if (!is.null(err_dtf)) {
    assign("unknown_sets", err_dtf, globalenv())
    err_msg <- c(
      "There is (are) unknown sets (see unknown_sets in globalenv)\n",
      paste0(capture.output(print(head(err_dtf))), collapse = "\n")
    )
    if (nrow(head(err_dtf)) != nrow(err_dtf)) {
      err_msg <- c(err_msg, paste0("\n", nrow(err_dtf) - nrow(head(err_dtf)),
                                   " row(s) was ommited"))
    }
    stop(err_msg)
  }
  if (!is.null(error_duplicated_value)) {
    assign("error_duplicated_value", error_duplicated_value, globalenv())
    err_msg <- c(
      "There is (are) duplicated values (see error_duplicated_value in globalenv)\n",
      paste0(capture.output(print(head(error_duplicated_value))), collapse = "\n")
    )
    if (nrow(head(error_duplicated_value)) != nrow(error_duplicated_value)) {
      err_msg <- c(err_msg, paste0("\n",
                                   nrow(error_duplicated_value) -
                                     nrow(head(error_duplicated_value)),
                                   " row(s) was ommited"))
    }
    stop(err_msg)
  }
}

