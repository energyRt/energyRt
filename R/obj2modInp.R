# setGeneric(".obj2modInp",
#            function(obj, app, approxim) standardGeneric(".obj2modInp"))

# =============================================================================#
# Add commodity ####
# =============================================================================#
setMethod(".obj2modInp",
          signature(obj = "modInp", app = "commodity", approxim = "list"),
          function(obj, app, approxim) {
  .checkSliceLevel(app, approxim)
  # cmd <- .upper_case(app)
  # browser()
  cmd <- app
  cmd <- .filter_data_in_slots(cmd, approxim$region, "region")

  # @emis: emissions from commodity consumption (combustion)
  # browser()
  dd <- cmd@emis[, c("comm", "comm", "emis"), drop = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c("comm", "commp", "value")
    dd[, "commp"] <- cmd@name
    dd[, "value"] <- as.numeric(dd$value) # Must be remove later
    obj@parameters[["pEmissionFactor"]] <-
      .dat2par(obj@parameters[["pEmissionFactor"]], as.data.table(dd))
  }

  # @agg: aggregating commodity
  dd <- cmd@agg[, c("comm", "comm", "agg"), drop = FALSE]
  if (nrow(dd) > 0) {
    colnames(dd) <- c("comm", "commp", "value")
    dd[, "comm"] <- cmd@name
    dd[, "value"] <- as.numeric(dd$value) # Must be removed later
    obj@parameters[["pAggregateFactor"]] <-
      .dat2par(obj@parameters[["pAggregateFactor"]], as.data.table(dd))
  }
  # @limtype: mUpComm | mLoComm | mFxComm
  if (cmd@limtype == "UP") {
    obj@parameters[["mUpComm"]] <-
      .dat2par(obj@parameters[["mUpComm"]], data.table(comm = cmd@name))
  } else if (cmd@limtype == "LO") {
    obj@parameters[["mLoComm"]] <-
      .dat2par(obj@parameters[["mLoComm"]], data.table(comm = cmd@name))
  } else if (cmd@limtype == "FX") {
    obj@parameters[["mFxComm"]] <- .dat2par(obj@parameters[["mFxComm"]],
                                             data.table(comm = cmd@name))
  } else {
    stop("Unknown commodity type: ", cmd@limtype, " in ", cmd@name)
  }
  # For slice
  # browser()
  approxim <- .fix_approximation_list(approxim, comm = cmd@name)
  obj@parameters[["mCommSlice"]] <-
    .dat2par(
      obj@parameters[["mCommSlice"]],
      data.table(
      comm = rep(cmd@name, length(approxim$commodity_slice_map[[cmd@name]])),
      slice = approxim$slice # ??? approxim$calendar?
    )
  )

  if (any(is.na(approxim$debug$comm) | approxim$debug$comm == cmd@name)) {
    approxim$debug$comm[is.na(approxim$debug$comm)] <- cmd@name
    dbg <- approxim$debug[!is.na(approxim$debug$comm) &
                            approxim$debug$comm == cmd@name, ,
                          drop = FALSE]
    approxim$comm <- cmd@name
    obj@parameters[["pDummyImportCost"]] <- .dat2par(
      obj@parameters[["pDummyImportCost"]],
      .interp_numpar(dbg, "dummyImport",
                          obj@parameters[["pDummyImportCost"]], approxim)
    )
    obj@parameters[["pDummyExportCost"]] <- .dat2par(
      obj@parameters[["pDummyExportCost"]],
      .interp_numpar(dbg, "dummyExport",
                          obj@parameters[["pDummyExportCost"]], approxim)
    )
  }
  obj
})

# =============================================================================#
# Add demand ####
# =============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "demand",
  approxim = "list"
), function(obj, app, approxim) {
  # dem <- .upper_case(app)
  dem <- app
  if (length(dem@commodity) != 1 || is.na(dem@commodity) ||
      all(dem@commodity != approxim$all_comm)) {
    stop(paste0('Wrong commodity in demand "', dem@name, '"'))
  }
  # browser()
  dem <- .filter_data_in_slots(dem, approxim$region, "region")
  approxim <- .fix_approximation_list(approxim, comm = dem@commodity)
  dem <- .disaggregateSliceLevel(dem, approxim)
  obj@parameters[["mDemComm"]] <- .dat2par(
    obj@parameters[["mDemComm"]],
    data.table(dem = dem@name, comm = dem@commodity)
  )
  # Region
  if (obj@parameters[["pDemand"]]@defVal == 0 && all(!is.na(dem@dem))) {
    if (length(dem@region) != 0) {
      dem@region <- dem@region[dem@region %in% unique(dem@dem$region)]
    }
    approxim$region <- approxim$region[approxim$region %in% unique(dem@dem$region)]
  }
  if (length(dem@region) != 0) {
    dem@dem <- dem@dem[is.na(dem@dem) | dem@dem$region %in% dem@region, , drop = FALSE]
    approxim$region <- approxim$region[approxim$region %in% dem@region]
  }
  # Slice
  mDemInp <- data.table(
    comm = rep(dem@commodity, length(approxim$slice)),
    slice = approxim$slice, stringsAsFactors = FALSE
  )
  mvDemInp <- merge0(merge0(mDemInp, list(year = approxim$mileStoneYears)),
                     list(region = approxim$region))
  obj@parameters[["mvDemInp"]] <-
    .dat2par(obj@parameters[["mvDemInp"]], mvDemInp)
  pDemand <- .interp_numpar(
    dem@dem, "dem", obj@parameters[["pDemand"]], approxim, c("dem", "comm"),
    c(dem@name, dem@commodity)
  )
  obj@parameters[["pDemand"]] <- .dat2par(obj@parameters[["pDemand"]], pDemand)


  obj
})

# ==============================================================================#
# Add weather ####
# ==============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "weather",
  approxim = "list"
), function(obj, app, approxim) {
  # wth <- .upper_case(app)
  wth <- app
  if (length(wth@slice) == 0 && length(approxim$calendar@slices_in_frame) > 1) {
    stop("Slot weather@slice is empty, it should have information about slice level")
  }
  if (length(wth@slice) == 0) wth@slice <- names(approxim$calendar@slices_in_frame)[1]
  approxim <- .fix_approximation_list(approxim, lev = wth@slice)
  # region fix
  if (length(wth@region) != 0) {
    approxim$region <- approxim$region[approxim$region %in% wth@region]
  }
  wth@region <- approxim$region
  wth <- .filter_data_in_slots(wth, approxim$region, "region")
  wth <- .disaggregateSliceLevel(wth, approxim)
  obj@parameters[["pWeather"]]@defVal <- wth@defVal
  obj@parameters[["pWeather"]] <- .dat2par(obj@parameters[["pWeather"]], .interp_numpar(
    wth@weather, "wval",
    obj@parameters[["pWeather"]], approxim, "weather", wth@name
  ))
  obj@parameters[["mWeatherSlice"]] <- .dat2par(
    obj@parameters[["mWeatherSlice"]],
    data.table(weather = rep(wth@name, length(approxim$slice)), slice = approxim$slice)
  )
  obj@parameters[["mWeatherRegion"]] <- .dat2par(
    obj@parameters[["mWeatherRegion"]],
    data.table(weather = rep(wth@name, length(wth@region)), region = wth@region)
  )
  obj
})

# ==============================================================================#
# Add export ####
# ==============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "export",
  approxim = "list"
), function(obj, app, approxim) {
  .checkSliceLevel(app, approxim)
  # exp <- .upper_case(app)
  exp <- app
  if (length(exp@commodity) != 1 || is.na(exp@commodity) || all(exp@commodity != approxim$all_comm)) {
    stop(paste0('Wrong commodity in export "', exp@name, '"'))
  }
  exp <- .filter_data_in_slots(exp, approxim$region, "region")
  approxim <- .fix_approximation_list(approxim, comm = exp@commodity, lev = exp@slice)
  exp <- .disaggregateSliceLevel(exp, approxim)
  mExpSlice <- data.table(expp = rep(exp@name, length(approxim$slice)), slice = approxim$slice)
  obj@parameters[["mExpSlice"]] <- .dat2par(obj@parameters[["mExpSlice"]], mExpSlice)
  mExpComm <- data.table(expp = exp@name, comm = exp@commodity)
  obj@parameters[["mExpComm"]] <- .dat2par(obj@parameters[["mExpComm"]], mExpComm)
  obj@parameters[["pExportRowPrice"]] <- .dat2par(
    obj@parameters[["pExportRowPrice"]],
    .interp_numpar(
      exp@exp, "price",
      obj@parameters[["pExportRowPrice"]], approxim, "expp", exp@name
    )
  )
  pExportRowRes <- NULL
  if (exp@reserve != Inf) pExportRowRes <- data.table(expp = exp@name, value = exp@reserve)
  obj@parameters[["pExportRowRes"]] <- .dat2par(obj@parameters[["pExportRowRes"]], pExportRowRes)
  pExportRow <- .interp_bounds(exp@exp, "exp", obj@parameters[["pExportRow"]], approxim, "expp", exp@name)
  obj@parameters[["pExportRow"]] <- .dat2par(obj@parameters[["pExportRow"]], pExportRow)

  mExportRow <- merge0(merge0(mExpSlice, list(region = approxim$region)), list(year = approxim$mileStoneYears))
  if (!is.null(pExportRow) && nrow(pExportRow) != 0) {
    pExportRow2 <- pExportRow[pExportRow$type == "up" & pExportRow$value == 0, colnames(pExportRow) %in% colnames(mExportRow), drop = FALSE]
    if (nrow(pExportRow2) != 0) {
      # pExportRow2 <- mExportRow[1, 1:2, drop = FALSE]
      if (ncol(pExportRow2) != ncol(mExportRow)) pExportRow2 <- merge0(mExportRow, pExportRow2)
      mExportRow <- mExportRow[(!duplicated(rbind(mExportRow, pExportRow2), fromLast = TRUE)[1:nrow(mExportRow)]), , drop = FALSE]
    }
  }
  mExportRow$comm <- exp@commodity
  obj@parameters[["mExportRow"]] <- .dat2par(obj@parameters[["mExportRow"]], mExportRow)
  if (!is.null(pExportRow) && any(pExportRow$type == "up" & pExportRow$value != Inf & pExportRow$value != 0)) {
    mExportRowUp <- pExportRow[pExportRow$type == "up" & pExportRow$value != Inf & pExportRow$value != 0, colnames(pExportRow) %in% obj@parameters[["mExportRowUp"]]@dimSets, drop = FALSE]
    mExportRowUp$comm <- exp@commodity
    if (!all(obj@parameters[["mExportRowUp"]]@dimSets %in% mExportRowUp)) {
      mExportRowUp <- merge0(mExportRow, mExportRowUp)
    }
    obj@parameters[["mExportRowUp"]] <- .dat2par(obj@parameters[["mExportRowUp"]], mExportRowUp)
    meqExportRowLo <- pExportRow[pExportRow$type == "lo" & pExportRow$value != 0, colnames(pExportRow) %in% obj@parameters[["meqExportRowLo"]]@dimSets, drop = FALSE]
    meqExportRowLo$comm <- exp@commodity
    if (!all(obj@parameters[["meqExportRowLo"]]@dimSets %in% meqExportRowLo)) {
      meqExportRowLo <- merge0(mExportRow, meqExportRowLo)
    }
    obj@parameters[["meqExportRowLo"]] <- .dat2par(
      obj@parameters[["meqExportRowLo"]],
      merge0(mExportRow, meqExportRowLo)
    )
  }
  if (!is.null(pExportRowRes)) {
    pExportRowRes$comm <- exp@commodity
    obj@parameters[["mExportRowAccumulatedUp"]] <- .dat2par(
      obj@parameters[["mExportRowAccumulatedUp"]],
      pExportRowRes[pExportRowRes$value != Inf, c("expp", "comm"), drop = FALSE]
    )
  }
  obj
})

# ==============================================================================#
# Add import ####
# ==============================================================================#
setMethod(
  ".obj2modInp", signature(
    obj = "modInp", app = "import",
    approxim = "list"
  ),
  function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    # imp <- .upper_case(app)
    imp <- app
    if (length(imp@commodity) != 1 || is.na(imp@commodity) || all(imp@commodity != approxim$all_comm)) {
      stop(paste0('Wrong commodity in import "', imp@name, '"'))
    }
    imp <- .filter_data_in_slots(imp, approxim$region, "region")
    approxim <- .fix_approximation_list(approxim, comm = imp@commodity, lev = imp@slice)
    imp <- .disaggregateSliceLevel(imp, approxim)
    mImpSlice <- data.table(imp = rep(imp@name, length(approxim$slice)), slice = approxim$slice)
    obj@parameters[["mImpSlice"]] <- .dat2par(obj@parameters[["mImpSlice"]], mImpSlice)
    mImpComm <- data.table(imp = imp@name, comm = imp@commodity)
    obj@parameters[["mImpComm"]] <- .dat2par(obj@parameters[["mImpComm"]], mImpComm)
    pImportRowPrice <- .interp_numpar(
      imp@imp, "price",
      obj@parameters[["pImportRowPrice"]], approxim, "imp", imp@name
    )
    obj@parameters[["pImportRowPrice"]] <- .dat2par(obj@parameters[["pImportRowPrice"]], pImportRowPrice)
    pImportRowRes <- NULL
    if (imp@reserve != Inf) pImportRowRes <- data.table(imp = imp@name, value = imp@reserve)
    obj@parameters[["pImportRowRes"]] <- .dat2par(obj@parameters[["pImportRowRes"]], pImportRowRes)
    pImportRow <- .interp_bounds(
      imp@imp, "imp",
      obj@parameters[["pImportRow"]], approxim, "imp", imp@name
    )
    obj@parameters[["pImportRow"]] <- .dat2par(obj@parameters[["pImportRow"]], pImportRow)
    mImportRow <- merge0(merge0(mImpSlice, list(region = approxim$region)), list(year = approxim$mileStoneYears))
    if (!is.null(pImportRow) && nrow(pImportRow) != 0) {
      pImportRow2 <- pImportRow[pImportRow$type == "up" & pImportRow$value == 0, colnames(pImportRow) %in% colnames(mImportRow), drop = FALSE]
      if (nrow(pImportRow2) != 0) {
        pImportRow2 <- mImportRow[1, 1:2, drop = FALSE]
        if (ncol(pImportRow2) != ncol(mImportRow)) pImportRow2 <- merge0(mImportRow, pImportRow2)
        mImportRow <- mImportRow[(!duplicated(rbind(mImportRow, pImportRow2), fromLast = TRUE)[1:nrow(mImportRow)]), , drop = FALSE]
      }
    }
    mImportRow$comm <- imp@commodity
    obj@parameters[["mImportRow"]] <- .dat2par(obj@parameters[["mImportRow"]], mImportRow)
    if (!is.null(pImportRow)) {
      mImportRowUp <- pImportRow[pImportRow$type == "up" & pImportRow$value != Inf & pImportRow$value != 0, colnames(pImportRow) %in% obj@parameters[["mImportRowUp"]]@dimSets, drop = FALSE]
      mImportRowUp$comm <- imp@commodity
      if (!all(obj@parameters[["mImportRowUp"]]@dimSets %in% mImportRowUp)) {
        mImportRowUp <- merge0(mImportRow, mImportRowUp)
      }
      obj@parameters[["mImportRowUp"]] <- .dat2par(obj@parameters[["mImportRowUp"]], mImportRowUp)
      meqImportRowLo <- pImportRow[pImportRow$type == "lo" & pImportRow$value != 0, colnames(pImportRow) %in% obj@parameters[["meqImportRowLo"]]@dimSets, drop = FALSE]
      meqImportRowLo$comm <- imp@commodity
      if (!all(obj@parameters[["meqImportRowLo"]]@dimSets %in% meqImportRowLo)) {
        meqImportRowLo <- merge0(mImportRow, meqImportRowLo)
      }
      obj@parameters[["meqImportRowLo"]] <- .dat2par(
        obj@parameters[["meqImportRowLo"]],
        merge0(mImportRow, meqImportRowLo)
      )
    }
    if (!is.null(pImportRowRes)) {
      pImportRowRes$comm <- exp@commodity
      obj@parameters[["mImportRowAccumulatedUp"]] <- .dat2par(
        obj@parameters[["mImportRowAccumulatedUp"]],
        pImportRowRes[pImportRowRes$value != Inf, c("expp", "comm"), drop = FALSE]
      )
    }
    obj
  }
)


# =============================================================================#
# Add settings ####
# =============================================================================#
setMethod(
  f = ".obj2modInp",
  signature = signature(obj = "modInp", app = "settings", approxim = "list"),
  function(obj, app, approxim) {
  # browser()
  clean_list <- c(
      "mSliceParentChild", "mSliceParentChildE", "mSliceNext",
      "mSliceFYearNext", "pDiscount", "pSliceShare", "pDummyImportCost",
      "pDummyExportCost", "mStartMilestone", "mEndMilestone",
      "mMilestoneLast", "mMilestoneFirst", "mMilestoneNext",
      "mMilestoneHasNext", "mSameSlice", "mSameRegion", "ordYear",
      "pYearFraction",
      "cardYear", "pPeriodLen", "pDiscountFactor", "mDiscountZero"
    )
    for (i in clean_list) {
      obj@parameters[[i]] <- .resetParameter(obj@parameters[[i]])
    }
    obj <- .drop_config_param(obj)
    app <- .filter_data_in_slots(app, approxim$region, "region")
    obj@parameters[["mSliceParentChild"]] <- .dat2par(
      obj@parameters[["mSliceParentChild"]],
      data.table(
        slice = as.character(approxim$calendar@slice_ancestry$parent),
        slicep = as.character(approxim$calendar@slice_ancestry$child),
        stringsAsFactors = FALSE
      )
    )
    obj@parameters[["mSliceParentChildE"]] <- .dat2par(
      obj@parameters[["mSliceParentChildE"]],
      data.table(
        slice = as.character(c(app@calendar@slice_share$slice,
                               approxim$calendar@slice_ancestry$parent)),
        slicep = as.character(c(app@calendar@slice_share$slice,
                                approxim$calendar@slice_ancestry$child)),
        stringsAsFactors = FALSE
      )
    )
    # browser()
    if (length(approxim$calendar@next_in_frame) != 0) {
      obj@parameters[["mSliceNext"]] <-
        .dat2par(obj@parameters[["mSliceNext"]],
                  approxim$calendar@next_in_frame)
      obj@parameters[["mSliceFYearNext"]] <-
        .dat2par(obj@parameters[["mSliceFYearNext"]],
                  approxim$calendar@next_in_year)
    }
    # Discount
    # browser()
    approxim_no_mileStone_Year <- approxim
    approxim_no_mileStone_Year$mileStoneYears <- NULL
    pDiscount <- .interp_numpar(app@discount, "discount",
      obj@parameters[["pDiscount"]], approxim_no_mileStone_Year,
      all.val = TRUE
    )
    obj@parameters[["pDiscount"]] <- .dat2par(obj@parameters[["pDiscount"]], pDiscount)
    approxim_comm <- approxim
    approxim_comm[["comm"]] <- approxim$all_comm
    obj@parameters[["pSliceShare"]] <- .dat2par(
      obj@parameters[["pSliceShare"]],
      data.table(
        slice = approxim$calendar@slice_share$slice,
        value = approxim$calendar@slice_share$share
      )
    )
    approxim_comm$slice <- approxim$calendar@slice_share$slice

    if (nrow(app@horizon@intervals) == 0) { # ???
      browser()
      app <- setHorizon(app,
                        horizon = app@horizon@period,
                        intervals = rep(1, length(app@horizon@period)))
    }

    obj@parameters[["mStartMilestone"]] <- .dat2par(
      obj@parameters[["mStartMilestone"]],
      data.table(year = app@horizon@intervals$mid, yearp = app@horizon@intervals$start)
    )
    obj@parameters[["mEndMilestone"]] <- .dat2par(
      obj@parameters[["mEndMilestone"]],
      data.table(year = app@horizon@intervals$mid, yearp = app@horizon@intervals$end)
    )
    obj@parameters[["mMilestoneLast"]] <- .dat2par(
      obj@parameters[["mMilestoneLast"]],
      data.table(year = max(app@horizon@intervals$mid))
    )
    obj@parameters[["mMilestoneFirst"]] <- .dat2par(
      obj@parameters[["mMilestoneFirst"]],
      data.table(year = min(app@horizon@intervals$mid))
    )
    # browser()
    obj@parameters[["mMilestoneNext"]] <- .dat2par(
      obj@parameters[["mMilestoneNext"]],
      data.table(year = app@horizon@intervals$mid[-nrow(app@horizon@intervals)],
                 yearp = app@horizon@intervals$mid[-1])
    )
    obj@parameters[["mMilestoneHasNext"]] <- .dat2par(
      obj@parameters[["mMilestoneHasNext"]],
      data.table(year = app@horizon@intervals$mid[-nrow(app@horizon@intervals)])
    )

    obj@parameters[["mSameSlice"]] <- .dat2par(
      obj@parameters[["mSameSlice"]],
      data.table(slice = app@calendar@slice_share$slice,
                 slicep = app@calendar@slice_share$slice)
    )
    obj@parameters[["mSameRegion"]] <- .dat2par(
      obj@parameters[["mSameRegion"]],
      data.table(region = app@region,
                 regionp = app@region)
    )
    # browser()
    # tmp <- data.frame(year = .get_data_slot(obj@parameters$year))
    tmp <- .get_data_slot(obj@parameters$year)
    tmp$value <- seq_along(tmp$year)
    obj@parameters[["ordYear"]] <- .dat2par(obj@parameters[["ordYear"]], tmp)
    obj@parameters[["cardYear"]] <- .dat2par(obj@parameters[["cardYear"]],
                                              tmp[nrow(tmp), , drop = FALSE])

    obj@parameters[["pPeriodLen"]] <- .dat2par(
      obj@parameters[["pPeriodLen"]],
      data.table(year = app@horizon@intervals$mid,
                 value = (app@horizon@intervals$end -
                            app@horizon@intervals$start + 1),
                 stringsAsFactors = FALSE)
    )

    pDiscount <-
      pDiscount[sort(pDiscount$year, index.return = TRUE)$ix, , drop = FALSE]
    pDiscountFactor <- pDiscount[0, , drop = FALSE]
    for (l in unique(pDiscount$region)) {
      dd <- pDiscount[pDiscount$region == l, , drop = FALSE]
      dd$value <- cumprod(1 / (1 + dd$value))
      pDiscountFactor <- rbind(pDiscountFactor, dd)
    }
    obj@parameters[["pDiscountFactor"]] <- .dat2par(obj@parameters[["pDiscountFactor"]], pDiscountFactor)
    # pDiscountFactorMileStone
    yrr <- app@horizon@intervals$start[1]:app@horizon@intervals$end[nrow(app@horizon@intervals)]
    tyr <- rep(NA, length(yrr))
    names(tyr) <- yrr
    for (yr in seq_len(nrow(app@horizon@intervals))) {
      tyr[app@horizon@intervals$start[yr] <= yrr & yrr <= app@horizon@intervals$end[yr]] <- app@horizon@intervals$mid[yr]
    }
    # browser()
    pDiscountFactorMileStone <- pDiscountFactor
    pDiscountFactorMileStone$year <-
      tyr[as.character(pDiscountFactorMileStone$year)]
    pDiscountFactorMileStone <- aggregate(
      pDiscountFactorMileStone[, "value", drop = FALSE],
      pDiscountFactorMileStone[, c("region", "year"), drop = FALSE], sum
    )
    if (!app@discountFirstYear) {
      dsc <- pDiscount[pDiscount$year == min(pDiscount$year), ]
      dsc$mlt <- dsc$value + 1
      pDiscountFactorMileStone <-
        merge0(pDiscountFactorMileStone, dsc[, c("region", "mlt")])
      pDiscountFactorMileStone$value <-
        pDiscountFactorMileStone$value * pDiscountFactorMileStone$mlt
      pDiscountFactorMileStone$mlt <- NULL
    }
    obj@parameters[["pDiscountFactorMileStone"]] <-
      .dat2par(obj@parameters[["pDiscountFactorMileStone"]],
                pDiscountFactorMileStone)
    # browser()
    # pDiscountFactorMileStone
    mDiscountZero <-
      pDiscount[pDiscount$year == as.character(max(app@horizon@period)), -2]
    mDiscountZero <- mDiscountZero[mDiscountZero$value == 0, "region", drop = FALSE]
    # Add mDiscountZero - zero discount rate in final int(?)
    if (nrow(mDiscountZero) != 0) {
      obj@parameters[["mDiscountZero"]] <-
        .dat2par(obj@parameters[["mDiscountZero"]], mDiscountZero)
    }
    # browser()
    # pYearFraction <- data.table(year = .get_data_slot(obj@parameters$year))
    pYearFraction <- .get_data_slot(obj@parameters$year)
    pYearFraction$value <- app@yearFraction$fraction
    # browser()
    obj@parameters[["pYearFraction"]] <-
      .dat2par(obj@parameters[["pYearFraction"]], pYearFraction)
    # obj@parameters[['pYearFraction']] <-
    #   .dat2par(obj@parameters[['pYearFraction']],
    #             data.table(value = app@yearFraction))
    # !!!
    obj@parameters[["pYearFraction"]]@defVal <- 1 # !!! temporary fix
    obj
  }
)


# =============================================================================#
# Add constraint ####
# =============================================================================#
setMethod(
  ".obj2modInp",
  signature(obj = "modInp", app = "constraint", approxim = "list"),
  function(obj, app, approxim) {
    # !!! Add interpolation of LHS and RHS here
    # browser()
    # .interp_numpar(
    #   app@rhs, parameter = 'rhs',
    #   # obj@parameters[['']],
    #   approxim = approxim
    #   # add_set_name = 'rhs',
    #   # app@name
    #   )
    .getSetEquation(obj, app, approxim)
  }
)

# =============================================================================#
# Add costs ####
# =============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "costs",
  approxim = "list"
), function(obj, app, approxim) {
  .getCostEquation(obj, app, approxim)
})


# =============================================================================#
# Add tax ####
# =============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "tax",
  approxim = "list"
), function(obj, app, approxim) {
  .subtax_approxim(obj, app, tax, whr = "tax", approxim)
})


# =============================================================================#
# Add sub ####
# =============================================================================#
setMethod(".obj2modInp", signature(
  obj = "modInp", app = "sub",
  approxim = "list"
), function(obj, app, approxim) {
  .subtax_approxim(obj, app, tax, whr = "subsidy", approxim)
})

# =============================================================================#
# Add storage ####
# =============================================================================#
setMethod(
  ".obj2modInp", signature(obj = "modInp", app = "storage", approxim = "list"),
  function(obj, app, approxim) {
    pStorageCout <- NULL
    pStorageCinp <- NULL
    # stg <- .upper_case(app)
    stg <- app
    if (length(stg@commodity) != 1 ||
        is.na(stg@commodity) ||
        all(stg@commodity != approxim$all_comm)) {
      stop(paste0('Wrong commodity in storage "', stg@name, '"'))
    }

    stg_slice <-
      approxim$calendar@timeframes[[approxim$commodity_slice_map[[stg@commodity]]]]
    approxim <- .fix_approximation_list(approxim, comm = stg@commodity, lev = NULL)
    stg <- .disaggregateSliceLevel(stg, approxim)
    if (length(stg@region) != 0) {
      approxim$region <- approxim$region[approxim$region %in% stg@region]
      ss <- getSlots("storage")
      ss <- names(ss)[ss %in% "data.frame"]
      ss <- ss[sapply(ss, function(x) {
        (any(colnames(slot(stg, x)) == "region") &&
          any(!is.na(slot(stg, x)$region)))
      })]
      for (sl in ss) {
        if (any(!is.na(slot(stg, sl)$region) &
                !(slot(stg, sl)$region %in% stg@region))) {
          rr <- !is.na(slot(stg, sl)$region) &
            !(slot(stg, sl)$region %in% stg@region)
          warning(paste('There are data storage "', stg@name,
                        '" for unused region: "',
            paste(unique(slot(stg, sl)$region[rr]), collapse = '", "'), '"',
            sep = ""
          ))
          slot(stg, sl) <- slot(stg, sl)[!rr, , drop = FALSE]
        }
      }
    }
    stg <- .filter_data_in_slots(stg, approxim$region, "region")
    if (stg@fullYear) {
      obj@parameters[["mStorageFullYear"]] <- .dat2par(
        obj@parameters[["mStorageFullYear"]],
        data.table(stg = stg@name)
      )
    }
    obj@parameters[["mStorageComm"]] <- .dat2par(
      obj@parameters[["mStorageComm"]],
      data.table(stg = stg@name, comm = stg@commodity)
    )
    olife <- .interp_numpar(
      stg@olife, "olife",
      obj@parameters[["pStorageOlife"]],
      approxim, "stg", stg@name
      # removeDefault = FALSE
    )
    obj@parameters[["pStorageOlife"]] <- .dat2par(obj@parameters[["pStorageOlife"]], olife)
    # Loss
    obj@parameters[["pStorageInpEff"]] <- .dat2par(
      obj@parameters[["pStorageInpEff"]],
      .interp_numpar(
        stg@seff, "inpeff", obj@parameters[["pStorageInpEff"]],
        approxim, c("stg", "comm"), c(stg@name, stg@commodity)
      )
    )
    obj@parameters[["pStorageOutEff"]] <- .dat2par(
      obj@parameters[["pStorageOutEff"]],
      .interp_numpar(
        stg@seff, "outeff", obj@parameters[["pStorageOutEff"]],
        approxim, c("stg", "comm"), c(stg@name, stg@commodity)
      )
    )
    obj@parameters[["pStorageStgEff"]] <- .dat2par(
      obj@parameters[["pStorageStgEff"]],
      .interp_numpar(
        stg@seff, "stgeff", obj@parameters[["pStorageStgEff"]],
        approxim, c("stg", "comm"), c(stg@name, stg@commodity)
      )
    )
    # Cost
    pStorageCostInp <- .interp_numpar(
      stg@varom, "inpcost",
      obj@parameters[["pStorageCostInp"]], approxim, "stg", stg@name
    )
    obj@parameters[["pStorageCostInp"]] <-
      .dat2par(obj@parameters[["pStorageCostInp"]], pStorageCostInp)
    pStorageCostOut <- .interp_numpar(
      stg@varom, "outcost",
      obj@parameters[["pStorageCostOut"]], approxim, "stg", stg@name
    )
    obj@parameters[["pStorageCostOut"]] <-
      .dat2par(obj@parameters[["pStorageCostOut"]], pStorageCostOut)

    pStorageCostStore <- .interp_numpar(
      stg@varom, "stgcost",
      obj@parameters[["pStorageCostStore"]], approxim, "stg", stg@name
    )
    obj@parameters[["pStorageCostStore"]] <-
      .dat2par(obj@parameters[["pStorageCostStore"]], pStorageCostStore)

    pStorageFixom <- .interp_numpar(
      stg@fixom, "fixom",
      obj@parameters[["pStorageFixom"]], approxim, "stg", stg@name
    )
    obj@parameters[["pStorageFixom"]] <-
      .dat2par(obj@parameters[["pStorageFixom"]], pStorageFixom)
    # Ava/Cap
    pStorageAf <- .interp_bounds(stg@af, "af", obj@parameters[["pStorageAf"]], approxim, "stg", stg@name)
    obj@parameters[["pStorageAf"]] <- .dat2par(obj@parameters[["pStorageAf"]], pStorageAf)
    obj@parameters[["pStorageCap2stg"]] <- .dat2par(
      obj@parameters[["pStorageCap2stg"]],
      data.table(stg = stg@name, value = stg@cap2stg)
    )
    pStorageCinp <- .interp_bounds(stg@af, "cinp", obj@parameters[["pStorageCinp"]], approxim, c("stg", "comm"), c(stg@name, stg@commodity))
    obj@parameters[["pStorageCinp"]] <- .dat2par(obj@parameters[["pStorageCinp"]], pStorageCinp)
    pStorageCout <- .interp_bounds(stg@af, "cout", obj@parameters[["pStorageCout"]], approxim, c("stg", "comm"), c(stg@name, stg@commodity))
    obj@parameters[["pStorageCout"]] <- .dat2par(obj@parameters[["pStorageCout"]], pStorageCout)
    # Aux input/output
    if (nrow(stg@aux) != 0) {
      if (any(!(stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in%
                stg@aux$acomm[!is.na(stg@aux$acomm)]))) {
        cmm <- stg@aeff$acomm[!is.na(stg@aeff$acomm)][stg@aeff$acomm[!is.na(stg@aeff$acomm)] %in% stg@aux$acomm[!is.na(stg@aux$acomm)]]
        stop(paste0('Unknown aux commodity "',
                    paste0(cmm, collapse = '", "'), '", in storage "', stg@name, '"'))
      }
      stg@aeff <- stg@aeff[!is.na(stg@aeff$acomm), , drop = FALSE]
      ainp_flag <- c("stg2ainp", "cinp2ainp", "cout2ainp", "cap2ainp",
                     "ncap2ainp")
      aout_flag <- c("stg2aout", "cinp2aout", "cout2aout", "cap2aout",
                     "ncap2aout")
      cmp_inp <- stg@aeff[apply(!is.na(stg@aeff[, ainp_flag]), 1, any), "acomm"]
      cmp_out <- stg@aeff[apply(!is.na(stg@aeff[, aout_flag]), 1, any), "acomm"]
      mStorageAInp <- data.table(
        stg = rep(stg@name, length(cmp_inp)),
        comm = cmp_inp)
      obj@parameters[["mStorageAInp"]] <-
        .dat2par(obj@parameters[["mStorageAInp"]], mStorageAInp)
      mStorageAOut <- data.table(
        stg = rep(stg@name, length(cmp_out)),
        comm = cmp_out
        )
      obj@parameters[["mStorageAOut"]] <- .dat2par(obj@parameters[["mStorageAOut"]], mStorageAOut)
      dd <- data.table(
        list = c(
          "pStorageStg2AInp", "pStorageStg2AOut", "pStorageCinp2AInp", "pStorageCinp2AOut", "pStorageCout2AInp",
          "pStorageCout2AOut", "pStorageCap2AInp", "pStorageCap2AOut", "pStorageNCap2AInp", "pStorageNCap2AOut"
        ),
        table = c(
          "stg2ainp", "stg2aout", "cinp2ainp", "cinp2aout", "cout2ainp", "cout2aout", "cap2ainp", "cap2aout", "ncap2ainp",
          "ncap2aout"
        ),
        stringsAsFactors = FALSE
      )
      approxim_comm <- approxim
      aout_tmp <- list()
      for (i in 1:nrow(dd)) {
        approxim_comm <- approxim_comm[names(approxim_comm) != "comm"]
        approxim_comm[["acomm"]] <-
          unique(stg@aeff[!is.na(stg@aeff[, dd[i, "table"]]), "acomm"])
        if (length(approxim_comm[["acomm"]]) != 0) {
          aout_tmp[[dd[i, "list"]]] <-
            .interp_numpar(stg@aeff, dd[i, "table"],
                           obj@parameters[[dd[i, "list"]]],
                           approxim_comm, "stg", stg@name)
          obj@parameters[[dd[i, "list"]]] <-
            .dat2par(obj@parameters[[dd[i, "list"]]], aout_tmp[[dd[i, "list"]]])
        }
      }
    } else {
      if (nrow(stg@aeff) != 0 && any(stg@aeff$acomm[!is.na(stg@aeff$acomm)])) {
        stop(paste0(
          'Unknown aux commodity "',
          paste0(stg@aeff$acomm[!is.na(stg@aeff$acomm)], collapse = '", "'),
          '", in storage "', stg@name, '"'
        ))
      }
    }
    if (any(!is.na(stg@aeff$ncap2stg) & stg@aeff$ncap2stg != 0)) {
      fl <- (!is.na(stg@aeff$ncap2stg) & stg@aeff$ncap2stg != 0)
      if (any(is.na(stg@aeff[fl, c("region", "year", "slice")]))) {
        stop(paste0('Interpolation is not allowed for storage "',
                    stg@name, '" parameter ncap2stg'))
      }
      tmp <- stg@aeff[fl, c("region", "year", "slice", "ncap2stg")]
      tmp$stg <- stg@name
      tmp$comm <- stg@commodity
      tmp$value <- tmp$ncap2stg
      tmp <- tmp[, c("stg", "comm", "region", "year", "slice", "value")]
      obj@parameters[["pStorageNCap2Stg"]] <-
        .dat2par(obj@parameters[["pStorageNCap2Stg"]], tmp)
    }

    if (any(!is.na(stg@charge$charge) & stg@charge$charge != 0)) {
      fl <- (!is.na(stg@charge$charge) & stg@charge$charge != 0)
      if (any(is.na(stg@charge[fl, c("region", "year", "slice")]))) {
        stop(paste0('Interpolation is not allowed for storage "',
                    stg@name, '" parameter charge'))
      }
      tmp <- stg@charge[fl, c("region", "year", "slice", "charge")]
      tmp$stg <- stg@name
      tmp$comm <- stg@commodity
      tmp$value <- tmp$charge
      tmp <- tmp[, c("stg", "comm", "region", "year", "slice", "value")]
      obj@parameters[["pStorageCharge"]] <-
        .dat2par(obj@parameters[["pStorageCharge"]], tmp)
    }
    # Some slice
    stock_exist <- .interp_numpar(
      stg@stock, "stock",
      obj@parameters[["pStorageStock"]], approxim, "stg", stg@name
    )
    obj@parameters[["pStorageStock"]] <-
      .dat2par(obj@parameters[["pStorageStock"]], stock_exist)
    invcost <- .interp_numpar(stg@invcost, "invcost",
                              obj@parameters[["pStorageInvcost"]],
                              approxim, "stg", stg@name)
    obj@parameters[["pStorageInvcost"]] <- .dat2par(obj@parameters[["pStorageInvcost"]], invcost)


    # browser()
    dd0 <- .start_end_fix(approxim, stg, "stg", stock_exist)
    dd0$new <- dd0$new[dd0$new$year %in% approxim$mileStoneYears &
                         dd0$new$region %in% approxim$region, , drop = FALSE]
    dd0$span <- dd0$span[
      dd0$span$year %in% approxim$mileStoneYears &
        dd0$span$region %in% approxim$region, , drop = FALSE]
    obj@parameters[["mStorageNew"]] <-
      .dat2par(obj@parameters[["mStorageNew"]], dd0$new)
    mStorageSpan <- dd0$span
    obj@parameters[["mStorageSpan"]] <-
      .dat2par(obj@parameters[["mStorageSpan"]], dd0$span)
    obj@parameters[["mStorageEac"]] <-
      .dat2par(obj@parameters[["mStorageEac"]], dd0$eac)

    if (nrow(dd0$new) > 0 && !is.null(invcost) && nrow(invcost) > 0) {
      salv_data <- merge0(dd0$new, approxim$discount, all.x = TRUE)
      salv_data$value[is.na(salv_data$value)] <- 0
      salv_data$discount <- salv_data$value
      salv_data$value <- NULL
      olife$olife <- olife$value
      olife$value <- NULL
      salv_data <- merge0(salv_data, olife)
      invcost$invcost <- invcost$value
      invcost$value <- NULL
      salv_data <- merge0(salv_data, invcost)
      # EAC
      salv_data$eac <- salv_data$invcost / salv_data$olife
      fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
      salv_data$eac[fl] <-
        salv_data$invcost[fl] *
        (salv_data$discount[fl] *
           (1 + salv_data$discount[fl])^salv_data$olife[fl] /
           ((1 + salv_data$discount[fl])^salv_data$olife[fl] - 1)
         )
      fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
      salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
      salv_data$tech <- stg@name
      salv_data$value <- salv_data$eac
      pStorageEac <- salv_data[, c("stg", "region", "year", "value")]
      obj@parameters[["pStorageEac"]] <-
        .dat2par(
          obj@parameters[["pStorageEac"]],
          unique(
            select(pStorageEac,
                   any_of(c(obj@parameters[["pStorageEac"]]@dimSets, "value"))
                   )
            # pStorageEac[, colnames(pStorageEac) %in%
            #               c(obj@parameters[["pStorageEac"]]@dimSets, "value"),
            #             drop = FALSE])
          ))
    }

    if (nrow(stg@weather) > 0) {
      tmp <- .toWeatherImply(stg@weather, "waf", "stg", stg@name)
      obj@parameters[["pStorageWeatherAf"]] <-
        .dat2par(obj@parameters[["pStorageWeatherAf"]], tmp$par)
      obj@parameters[["mStorageWeatherAfUp"]] <-
        .dat2par(obj@parameters[["mStorageWeatherAfUp"]], tmp$mapup)
      obj@parameters[["mStorageWeatherAfLo"]] <-
        .dat2par(obj@parameters[["mStorageWeatherAfLo"]], tmp$maplo)

      tmp <- .toWeatherImply(stg@weather, "wcinp", "stg", stg@name)
      obj@parameters[["pStorageWeatherCinp"]] <-
        .dat2par(obj@parameters[["pStorageWeatherCinp"]], tmp$par)
      obj@parameters[["mStorageWeatherCinpUp"]] <-
        .dat2par(obj@parameters[["mStorageWeatherCinpUp"]], tmp$mapup)
      obj@parameters[["mStorageWeatherCinpLo"]] <-
        .dat2par(obj@parameters[["mStorageWeatherCinpLo"]], tmp$maplo)

      tmp <- .toWeatherImply(stg@weather, "wcout", "stg", stg@name)
      obj@parameters[["pStorageWeatherCout"]] <-
        .dat2par(obj@parameters[["pStorageWeatherCout"]], tmp$par)
      obj@parameters[["mStorageWeatherCoutUp"]] <-
        .dat2par(obj@parameters[["mStorageWeatherCoutUp"]], tmp$mapup)
      obj@parameters[["mStorageWeatherCoutLo"]] <-
        .dat2par(obj@parameters[["mStorageWeatherCoutLo"]], tmp$maplo)
    }
    pStorageOlife <- olife
    if (any(pStorageOlife$olife != Inf)) {
      mStorageOlifeInf <-
        select(filter(pStorageOlife, !is.infinite(olife)),
               any_of(obj@parameters[["mStorageOlifeInf"]]@dimSets))
      # pStorageOlife[pStorageOlife$olife != Inf,
      #                 colnames(pStorageOlife) %in%
      #                   obj@parameters[["mStorageOlifeInf"]]@dimSets,
      #                 drop = FALSE]
      if (ncol(mStorageOlifeInf) != ncol(obj@parameters[["mStorageOlifeInf"]]@data)) {
        mStorageOlifeInf <- merge0(
          mStorageOlifeInf,
          select(filter(mStorageSpan, !duplicated(region)),
                 any_of(obj@parameters[["mStorageOlifeInf"]]@dimSets))
          # mStorageSpan[!duplicated(mStorageSpan$region),
          #              colnames(mStorageSpan) %in%
          #                obj@parameters[["mStorageOlifeInf"]]@dimSets,
          #              drop = FALSE]
          )
      }
      obj@parameters[["mStorageOlifeInf"]] <-
        .dat2par(obj@parameters[["mStorageOlifeInf"]], mStorageOlifeInf)
    }
    mStorageOMCost <- NULL
    add_omcost <- function(mStorageOMCost, pStorageFixom) {
      if (is.null(pStorageFixom) || all(pStorageFixom$value == 0)) {
        return(mStorageOMCost)
      }
      return(rbind(
        mStorageOMCost,
        merge0(mStorageSpan,
               select(filter(pStorageFixom, value != 0),
                      any_of(colnames(mStorageSpan))
                      )
               )
        # pStorageFixom[pStorageFixom$value != 0,
        #   colnames(pStorageFixom) %in% colnames(mStorageSpan),
        #   drop = FALSE
        # ])
      ))
    }
    mStorageOMCost <- add_omcost(mStorageOMCost, pStorageFixom)
    mStorageOMCost <- add_omcost(mStorageOMCost, pStorageCostInp)
    mStorageOMCost <- add_omcost(mStorageOMCost, pStorageCostOut)
    mStorageOMCost <- add_omcost(mStorageOMCost, pStorageCostStore)

    if (!is.null(mStorageOMCost)) {
      mStorageOMCost <- merge0(mStorageOMCost[!duplicated(mStorageOMCost), ], mStorageSpan)
      obj@parameters[["mStorageOMCost"]] <- .dat2par(obj@parameters[["mStorageOMCost"]], mStorageOMCost)
    }
    # dsm <- obj@parameters[['mStorageOMCost']]@dimSets
    # mStorageOMCost <- NULL
    # browser()
    # if (!is.null(pStorageFixom)) mStorageOMCost <-
    #   rbind(mStorageOMCost,
    #         pStorageFixom[pStorageFixom$value != 0, colnames(pStorageFixom) %in% dsm, drop = FALSE])
    # if (!is.null(pStorageCostInp)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostInp[pStorageCostInp$value != 0, dsm])
    # if (!is.null(pStorageCostOut)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostOut[pStorageCostOut$value != 0, dsm])
    # if (!is.null(pStorageCostStore)) mStorageOMCost <- rbind(mStorageOMCost, pStorageCostStore[pStorageCostStore$value != 0, dsm])
    # if (!is.null(mStorageOMCost)) {
    #   mStorageOMCost <- merge0(mStorageOMCost[!duplicated(mStorageOMCost), ], mStorageSpan)
    #   obj@parameters[['mStorageOMCost']] <- .dat2par(obj@parameters[['mStorageOMCost']], mStorageOMCost)
    # }
    # browser()
    mvStorageStore <- merge0(mStorageSpan, data.table(slice = stg_slice))
    if (nrow(mvStorageStore) > 0) {
      mvStorageStore$comm <- stg@commodity
    } else {
      mvStorageStore$comm <- character()
    }
    obj@parameters[["mvStorageStore"]] <- .dat2par(obj@parameters[["mvStorageStore"]], mvStorageStore)

    if (nrow(stg@aux) != 0) {
      mvStorageStore2 <- mvStorageStore
      mvStorageStore2$comm <- NULL
      mvStorageAInp <- merge0(mvStorageStore2, mStorageAInp)
      obj@parameters[["mvStorageAInp"]] <-
        .dat2par(obj@parameters[["mvStorageAInp"]], mvStorageAInp)
      mvStorageAOut <- merge0(mvStorageStore2, mStorageAOut)
      obj@parameters[["mvStorageAOut"]] <-
        .dat2par(obj@parameters[["mvStorageAOut"]], mvStorageAOut)
      for (i in c(
        "mStorageStg2AOut", "mStorageCinp2AOut", "mStorageCout2AOut",
        "mStorageCap2AOut", "mStorageNCap2AOut", "mStorageStg2AInp",
        "mStorageCinp2AInp", "mStorageCout2AInp", "mStorageCap2AInp",
        "mStorageNCap2AInp")) {
        if (!is.null(aout_tmp[[gsub("^m", "p", i)]])) {
          atmp <- aout_tmp[[gsub("^m", "p", i)]]
          if (any(grep("Out$", i))) {
            # atmp <- atmp[, colnames(atmp) %in% colnames(mvStorageAOut), drop = FALSE]
            atmp <- atmp %>% select(any_of(colnames(mvStorageAOut)))
            if (ncol(atmp) != 5) atmp <- merge0(atmp, mvStorageAOut)
          } else {
            # atmp <- atmp[, colnames(atmp) %in% colnames(mvStorageAInp), drop = FALSE]
            atmp <- atmp %>% select(any_of(colnames(mvStorageAInp)))
            if (ncol(atmp) != 5) atmp <- merge0(atmp, mvStorageAInp)
          }
          obj@parameters[[i]] <- .dat2par(obj@parameters[[i]], atmp)
        }
      }
    }
    rem_inf_def1 <- function(x, y) {
      if (is.null(x)) return(y)
      # browser()
      # jjs <- intersect(names(x), names(y))
      ex_cols <- c("value", "type")
      x <- filter(x, type == 'up' & value == Inf) %>% select(-any_of(ex_cols))
      y <- select(y, -any_of(ex_cols))
      ii <- duplicated(bind_rows(y, x))[1:nrow(y)]
      y <- filter(y, !ii)
      return(y)

      # rbind(
      #   select(filter(x, type == "up", x$value == Inf), any_of(jjs)),
      #   select(y, any_of(jjs))
      #   ) %>% unique()

      # x <- x[x$type == "up" & x$value == Inf, ]
      # r <- try(y[(!duplicated(rbind(y, select(x, -value))))[1:nrow(y)], ])
      # # y[(!duplicated(rbind(y, x)))[1:nrow(y)], ]
      # if (inherits(r, "try-error")) browser() # !!! To check
      # r
      # merge0(
      #   select(filter(x, type == "up", x$value == Inf), any_of(colnames(y))),
      #   y)
    }
    rem_inf_def_inf <- function(x, y) {
      merge0(
        # x[x$type == "up" & x$value != Inf, colnames(x) %in% colnames(y),
        #     drop = FALSE],
        select(filter(x, type == "up", x$value != Inf), any_of(colnames(y))),
        y)
    }
    obj@parameters[["meqStorageAfLo"]] <-
      .dat2par(obj@parameters[["meqStorageAfLo"]],
               merge0(
                 # pStorageAf[pStorageAf$type == "lo" & pStorageAf$value != 0, ],
                 filter(pStorageAf, type == "lo" & value != 0),
                 mvStorageStore
                 ))
    # browser() #!!! check meqStorageAfUp
    obj@parameters[["meqStorageAfUp"]] <-
      .dat2par(obj@parameters[["meqStorageAfUp"]],
               rem_inf_def1(pStorageAf, mvStorageStore)
               )
    if (!is.null(pStorageCinp)) {
      obj@parameters[["meqStorageInpLo"]] <-
        .dat2par(
          obj@parameters[["meqStorageInpLo"]],
          merge0(
            # pStorageCinp[pStorageCinp$type == "lo" & pStorageCinp$value != 0,
            #              colnames(pStorageCinp) %in%
            #                obj@parameters[["meqStorageInpLo"]]@dimSets],
            select(filter(pStorageCinp, type == "lo" & value != 0),
                   any_of(obj@parameters[["meqStorageInpLo"]]@dimSets)),
            mvStorageStore))
      obj@parameters[["meqStorageInpUp"]] <-
        .dat2par(obj@parameters[["meqStorageInpUp"]],
                 rem_inf_def_inf(pStorageCinp, mvStorageStore))
    }
    if (!is.null(pStorageCout)) {
      obj@parameters[["meqStorageOutLo"]] <-
        .dat2par(
          obj@parameters[["meqStorageOutLo"]],
          merge0(
            # pStorageCout[pStorageCout$type == "lo" & pStorageCout$value != 0,
            #              colnames(pStorageCout) %in%
            #                obj@parameters[["meqStorageOutLo"]]@dimSets,
            #              drop = FALSE],
            select(filter(pStorageCout, type == "lo" & value != 0),
                   any_of(obj@parameters[["meqStorageOutLo"]]@dimSets)),
            mvStorageStore)
      )
      obj@parameters[["meqStorageOutUp"]] <-
        .dat2par(obj@parameters[["meqStorageOutUp"]],
                 rem_inf_def_inf(pStorageCout, mvStorageStore))
    }
    obj
  }
)


# =============================================================================#
# Add supply ####
# =============================================================================#
setMethod(".obj2modInp",
  signature(obj = "modInp", app = "supply", approxim = "list"),
  function(obj, app, approxim) {
    .checkSliceLevel(app, approxim)
    sup <- app
    # sup <- .upper_case(app)
    if (length(sup@commodity) != 1 || is.na(sup@commodity) ||
        all(sup@commodity != approxim$all_comm)) {
      stop(paste0('Wrong commodity in supply "', sup@name, '"'))
    }
    approxim <- .fix_approximation_list(approxim, comm = sup@commodity,
                                        lev = sup@slice)
    sup <- .disaggregateSliceLevel(sup, approxim)
    if (length(sup@region) != 0) {
      approxim$region <- approxim$region[approxim$region %in% sup@region]
      ss <- getSlots("supply")
      ss <- names(ss)[ss %in% "data.frame"]
      ss <- ss[sapply(ss, function(x) {
        (any(colnames(slot(sup, x)) == "region") &&
           any(!is.na(slot(sup, x)$region)))
        })]
      for (sl in ss) {
        if (any(!is.na(slot(sup, sl)$region) &
                !(slot(sup, sl)$region %in% sup@region))) {
          rr <- !is.na(slot(sup, sl)$region) &
            !(slot(sup, sl)$region %in% sup@region)
          warning(
            paste('There are data supply "', sup@name, '" for unused region: "',
            paste(unique(slot(sup, sl)$region[rr]), collapse = '", "'), '"',
            sep = ""
          ))
          slot(sup, sl) <- slot(sup, sl)[!rr, , drop = FALSE]
        }
      }
      mSupSpan <- data.table(sup = rep(sup@name, length(sup@region)),
                             region = sup@region)
      obj@parameters[["mSupSpan"]] <- .dat2par(obj@parameters[["mSupSpan"]],
                                               mSupSpan)
    } else {
      mSupSpan <- data.table(sup = rep(sup@name, length(approxim$region)),
                             region = approxim$region)
      obj@parameters[["mSupSpan"]] <- .dat2par(obj@parameters[["mSupSpan"]],
                                               mSupSpan)
    }
    sup <- .filter_data_in_slots(sup, approxim$region, "region")
    mSupSlice <- data.table(sup = rep(sup@name, length(approxim$slice)),
                            slice = approxim$slice)
    obj@parameters[["mSupSlice"]] <-
      .dat2par(obj@parameters[["mSupSlice"]], mSupSlice)
    # browser()
    mSupComm <- data.table(sup = sup@name, comm = sup@commodity)
    obj@parameters[["mSupComm"]] <- .dat2par(obj@parameters[["mSupComm"]], mSupComm)
    # browser()
    pSupCost <- .interp_numpar(sup@availability, "cost",
                               obj@parameters[["pSupCost"]],
                               approxim, c("sup", "comm"),
                               c(sup@name, sup@commodity))
    obj@parameters[["pSupCost"]] <- .dat2par(obj@parameters[["pSupCost"]],
                                             pSupCost)
    # browser()
    pSupReserve <- .interp_bounds(
      sup@reserve, "res", obj@parameters[["pSupReserve"]],
      approxim, c("sup", "comm"), c(sup@name, sup@commodity)
    )
    obj@parameters[["pSupReserve"]] <-
      .dat2par(obj@parameters[["pSupReserve"]], pSupReserve)
    # browser()
    pSupAva <- .interp_bounds(
      sup@availability, "ava",
      obj@parameters[["pSupAva"]], approxim, c("sup", "comm"),
      c(sup@name, sup@commodity)
    )
    obj@parameters[["pSupAva"]] <- .dat2par(obj@parameters[["pSupAva"]], pSupAva)
    # zero_ava_up <- pSupAva[pSupAva$value == 0 & pSupAva$type == "up",
    #                        colnames(pSupAva) != "value", drop = FALSE]
    # browser()
    if (is.null(pSupAva)) {
      zero_ava_up <- NULL
    } else {
      zero_ava_up <- pSupAva %>%
        filter(value == 0, type == "up") %>%
        select(-any_of("value"))
      # browser()
    }
    # mSupAva <- merge0(merge0(mSupSpan, list(comm = sup@commodity, year = approxim$mileStoneYears)), mSupSlice)
      mSupAva <- mSupSpan %>%
        merge0(list(comm = sup@commodity, year = approxim$mileStoneYears)) %>%
        merge0(mSupSlice)

    if (!is.null(zero_ava_up) && nrow(zero_ava_up) != 0) {
      if (all(colnames(mSupAva) %in% colnames(zero_ava_up))) {
        # mSupAva <-
        #   mSupAva[(!duplicated(
        #     rbind(mSupAva, zero_ava_up[, colnames(mSupAva)]),
        #     fromLast = TRUE))[1:nrow(mSupAva)], ]
        ii <- mSupAva %>%
          rbind(select(zero_ava_up, all_of(colnames(mSupAva)))) %>%
          duplicated(fromLast = TRUE)
          # filter(n() <= nrow(mSupAva))
        ii <- ii[1:nrow(mSupAva)]
        mSupAva <- mSupAva[!ii,]
      } else {
        # mSupAva <- mSupAva[(!duplicated(rbind(mSupAva, merge0(mSupAva, zero_ava_up[, colnames(zero_ava_up) %in% colnames(mSupAva), drop = FALSE])[, colnames(mSupAva)]), fromLast = TRUE))[1:nrow(mSupAva)], ]
        ii <- mSupAva %>%
          rbind(
            merge0(mSupAva,
                   select(zero_ava_up, any_of(colnames(mSupAva)))                   )
            ) %>%
          select(all_of(colnames(mSupAva))) %>%
          duplicated(fromLast = TRUE)
        ii <- ii[1:nrow(mSupAva)] # ???
        mSupAva <- mSupAva[!ii,]
      }
    }
    obj@parameters[["mSupAva"]] <- .dat2par(obj@parameters[["mSupAva"]], mSupAva)
    mvSupReserve <- merge0(mSupComm, mSupSpan)
    obj@parameters[["mvSupReserve"]] <-
      .dat2par(obj@parameters[["mvSupReserve"]], mvSupReserve)
    if (all(c("sup", "comm", "region") %in% colnames(pSupReserve))) {
      obj@parameters[["mSupReserveUp"]] <-
        .dat2par(
          obj@parameters[["mSupReserveUp"]],
          pSupReserve[pSupReserve$type == "up" & pSupReserve$value != Inf,
                      c("sup", "comm", "region")]
          )
      obj@parameters[["meqSupReserveLo"]] <-
        .dat2par(
          obj@parameters[["meqSupReserveLo"]],
          pSupReserve[pSupReserve$type == "lo" & pSupReserve$value != 0,
                      c("sup", "comm", "region")]
          )
    } else {
      # obj@parameters[["mSupReserveUp"]] <- .dat2par(
      #   obj@parameters[["mSupReserveUp"]],
      #   merge0(mvSupReserve, pSupReserve[pSupReserve$type == "up" & pSupReserve$value != Inf,
      #     colnames(pSupReserve) %in% c("sup", "comm", "region"),
      #     drop = FALSE
      #   ])
      # )
      .null_to_empty_param("pSupReserve", obj@parameters)
      # browser()
      obj@parameters[["mSupReserveUp"]] <-
        .dat2par(
          obj@parameters[["mSupReserveUp"]],
          merge0(mvSupReserve,
                 select(
                   filter(pSupReserve, type == "up" & value != Inf),
                   any_of(c("sup", "comm", "region"))
                   )
                 )
          )
      # obj@parameters[["meqSupReserveLo"]] <- .dat2par(
      #   obj@parameters[["meqSupReserveLo"]],
      #   merge0(mvSupReserve, pSupReserve[pSupReserve$type == "lo" & pSupReserve$value != 0,
      #     colnames(pSupReserve) %in% c("sup", "comm", "region"),
      #     drop = FALSE
      #   ])
      # )
      obj@parameters[["meqSupReserveLo"]] <-
        .dat2par(
          obj@parameters[["meqSupReserveLo"]],
          merge0(mvSupReserve,
                 select(
                   filter(pSupReserve, type == "lo" & value != 0),
                   any_of(c("sup", "comm", "region"))
                   )
                 )
          )
    }
    .null_to_empty_param("pSupAva", obj@parameters)
    obj@parameters[["meqSupAvaLo"]] <- .dat2par(
      obj@parameters[["meqSupAvaLo"]],
      # merge0(mSupAva, pSupAva[pSupAva$type == "lo" & pSupAva$value != 0, colnames(pSupAva) %in% colnames(mSupAva)])
      merge0(mSupAva,
             select(
               filter(pSupAva, type == "lo" & value != 0),
               all_of(colnames(mSupAva))
               )
             )
    )
    # .null_to_empty_param("pSupAva", obj@parameters)
    # browser()
    obj@parameters[["mSupAvaUp"]] <- .dat2par(
      obj@parameters[["mSupAvaUp"]],
      # merge0(mSupAva, pSupAva[pSupAva$type == "up" & pSupAva$value != Inf,
      # colnames(pSupAva) %in% colnames(mSupAva)])
      merge0(mSupAva,
             select(
               filter(pSupAva, type == "up" & value != Inf),
               all_of(colnames(mSupAva))
               )
             )
    )
    # For weather
    # browser()
    if (nrow(sup@weather) > 0) {
      tmp <- .toWeatherImply(sup@weather, "wava", "sup", sup@name)
      obj@parameters[["pSupWeather"]] <-
        .dat2par(obj@parameters[["pSupWeather"]], tmp$par)
      obj@parameters[["mSupWeatherUp"]] <-
        .dat2par(obj@parameters[["mSupWeatherUp"]], tmp$mapup)
      obj@parameters[["mSupWeatherLo"]] <-
        .dat2par(obj@parameters[["mSupWeatherLo"]], tmp$maplo)
    }
    t1 <- mSupAva[, c("sup", "region", "year")] %>% unique()
    # t1 <- t1[!duplicated(t1), ]
    # t2 <- pSupCost[pSupCost$value != 0, colnames(pSupCost)[colnames(pSupCost) %in% c("sup", "region", "year")], drop = FALSE]
    # t2 <- t2[!duplicated(t2), , drop = FALSE]
    # browser()
    .null_to_empty_param("pSupCost", obj@parameters)
    t2 <- pSupCost %>%
      filter(value != 0) %>%
      select(any_of(c("sup", "region", "year"))) %>%
      unique()
    if (!is.null(t2) && ncol(t2) != 3) {
      browser()
      # t2 <- merge0(t2, mSupAva[!duplicated(mSupAva[, c("sup", "region", "year")]),
      #                          c("sup", "region", "year")])
      t2 <- merge0(t2, unique(mSupAva[, c("sup", "region", "year")]))
    }
    mvSupCost <- merge0(t1, t2)
    mvSupCost <- mvSupCost[!duplicated(mvSupCost), ]
    obj@parameters[["mvSupCost"]] <- .dat2par(obj@parameters[["mvSupCost"]], mvSupCost)
    obj
  }
)

.toWeatherImply <- function(dtf, val, add_set, add_val, sets = NULL) {
  dtf <- as.data.table(dtf)
  # browser() ### !!! ToDo: dplyr
  # f1 <- dtf[!is.na(dtf[, paste0(val, ".up")]),
  #           c(paste0(val, ".up"), "weather", sets),
  #           drop = FALSE]
  # colnames(f1)[1] <- "value"
  c_nm <- paste0(val, ".up")
  ii <- select(dtf, all_of(c_nm))[[1]] %>% is.na()
  f1 <- dtf %>%
    filter(!ii) %>%
    select(all_of(c(c_nm, "weather", sets))) %>%
    rename(value = all_of(c_nm))
  # f2 <- dtf[!is.na(dtf[, paste0(val, ".fx")]),
  #           c(paste0(val, ".fx"), "weather", sets),
  #           drop = FALSE]
  # colnames(f2)[1] <- "value"
  c_nm <- paste0(val, ".fx")
  ii <- select(dtf, all_of(c_nm))[[1]] %>% is.na()
  f2 <- dtf %>%
    filter(!ii) %>%
    select(all_of(c(c_nm, "weather", sets))) %>%
    rename(value = all_of(c_nm))
  # f3 <- dtf[!is.na(dtf[, paste0(val, ".lo")]),
  #           c(paste0(val, ".lo"), "weather", sets),
  #           drop = FALSE]
  # colnames(f3)[1] <- "value"
  c_nm <- paste0(val, ".lo")
  ii <- select(dtf, all_of(c_nm))[[1]] %>% is.na()
  f3 <- dtf %>%
    filter(!ii) %>%
    select(all_of(c(c_nm, "weather", sets))) %>%
    rename(value = all_of(c_nm))
  rs <- list(par = NULL)
  if (nrow(f1) + nrow(f2) != 0) {
    tmp <- rbind(f1, f2)
    # tmp[, add_set] <- add_val
    tmp[[add_set]] <- add_val
    # rs$mapup <- tmp[, -1, drop = FALSE]
    rs$mapup <- select(tmp, -value)
    tmp$type <- "up"
    rs$par <- tmp
  }
  if (nrow(f3) + nrow(f2) != 0) {
    tmp <- rbind(f3, f2)
    # tmp[, add_set] <- add_val
    tmp[[add_set]] <- add_val
    # rs$maplo <- tmp[, -1, drop = FALSE]
    rs$maplo <- select(tmp, -value)
    tmp$type <- "lo"
    rs$par <- rbind(rs$par, tmp)
  }
  rs
}


.add_ramp0 <- function(obj, name, tech, mact, approxim) {
  if (any(!is.na(tech@af[[name]]))) {
    # browser()
    pname <- paste0(
      "p", c("technology" = "Tech", "storage" = "Storage")[class(tech)],
      c("rampup" = "RampUp", "rampdown" = "RampDown", name)[name]
    )
    set_name <- c("technology" = "tech", "storage" = "stg")[class(tech)]
    mname <- sub("^p", "m", pname)
    rampup <- tech@af[!is.na(tech@af[[name]]), ]
    approxim2 <- approxim
    if (all(!is.na(rampup$slice))) {
      approxim2$slice <- approxim2$slice[approxim2$slice %in% unique(rampup$slice)]
    }
    pTechRampUp <- .interp_numpar(
      rampup, name,
      obj@parameters[[pname]], approxim2, set_name, tech@name
    )
    mTechRampUp <- pTechRampUp[, colnames(pTechRampUp) != "value", drop = FALSE]
    if (ncol(mTechRampUp) != ncol(obj@parameters[[mname]]@data)) {
      mTechRampUp <- merge0(mTechRampUp, mact)
    }
    # !!! Temporary fix: drop values beyond technology lifespan
    # synchronizing with activity slices
    if (!is.null(pTechRampUp$region)) {
      pTechRampUp <- dplyr::filter(pTechRampUp, region %in% unique(mact$region))
      mTechRampUp <- dplyr::filter(mTechRampUp, region %in% unique(mact$region))
    }
    if (!is.null(pTechRampUp$year)) {
      pTechRampUp <- dplyr::filter(pTechRampUp, year %in% unique(mact$year))
      mTechRampUp <- dplyr::filter(mTechRampUp, year %in% unique(mact$year))
    }
    if (!is.null(pTechRampUp$slice)) {
      pTechRampUp <- dplyr::filter(pTechRampUp, slice %in% unique(mact$slice))
      mTechRampUp <- dplyr::filter(mTechRampUp, slice %in% unique(mact$slice))
    }
    # !!! end

    obj@parameters[[pname]] <- .dat2par(obj@parameters[[pname]], pTechRampUp)
    obj@parameters[[mname]] <- .dat2par(obj@parameters[[mname]], mTechRampUp)
  }
  obj
}

# =============================================================================# # Add technology ####
# =============================================================================#
setMethod(
  ".obj2modInp",
  signature(obj = "modInp", app = "technology", approxim = "list"),
  function(obj, app, approxim) {
    # browser()
    .checkSliceLevel(app, approxim)
    # tech <- .upper_case(app)
    tech <- app
    if (length(tech@slice) == 0) {
      use_cmd <- unique(
        sapply(c(tech@output$comm, tech@output$comm, tech@aux$acomm),
               function(x) approxim$commodity_slice_map[x])
        )
      tech@slice <- colnames(approxim$calendar@timetable)[
        max(c(approxim$calendar@frame_rank[c(use_cmd, recursive = TRUE)],
              recursive = TRUE))
        ]
    }
    # Disaggregated AFS, if there is a slice level
    if (nrow(tech@afs) != 0 &&
        any(tech@afs$slice %in% names(approxim$calendar@timeframes))) {
      chk <- seq_len(nrow(tech@afs))[tech@afs$slice %in%
                                       names(approxim$calendar@timeframes)]
      for (cc in chk) {
        slc <- approxim$calendar@timeframes[[tech@afs[cc, "slice"]]]
        tmp <- tech@afs[rep(cc, length(slc)), ]
        tmp$slice <- slc
        tech@afs <- rbind(tech@afs, tmp)
      }
      tech@afs <- tech@afs[-chk, ]
    }
    approxim <- .fix_approximation_list(approxim, lev = tech@slice)
    tech <- .disaggregateSliceLevel(tech, approxim)
    mTechSlice <- data.table(
      tech = rep(tech@name, length(approxim$slice)), slice = approxim$slice,
      stringsAsFactors = FALSE
    )
    obj@parameters[["mTechSlice"]] <-
      .dat2par(obj@parameters[["mTechSlice"]], mTechSlice)
    if (length(tech@region) != 0) {
      approxim$region <- approxim$region[approxim$region %in% tech@region]
      ss <- getSlots("technology")
      ss <- names(ss)[ss %in% "data.frame"]
      ss <- ss[sapply(ss, function(x) {
        (any(colnames(slot(tech, x)) == "region") &&
          any(!is.na(slot(tech, x)$region)))
      })]
      for (sl in ss) {
        if (any(!is.na(slot(tech, sl)$region) &
                !(slot(tech, sl)$region %in% tech@region))) {
          rr <- !is.na(slot(tech, sl)$region) &
            !(slot(tech, sl)$region %in% tech@region)
          warning(
            paste('There are data technology "', tech@name,
                  '"for unused region: "',
                  paste(unique(slot(tech, sl)$region[rr]), collapse = '", "'),
                  '"',
                  sep = ""
                )
            )
          slot(tech, sl) <- slot(tech, sl)[!rr, , drop = FALSE]
        }
      }
    }
    tech <- .filter_data_in_slots(tech, approxim$region, "region")
    # Map
    ctype <- checkInpOut(tech)
    # Need choose comm more accuracy
    approxim_comm <- approxim
    approxim_comm[["comm"]] <- rownames(ctype$comm)
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechCvarom <- .interp_numpar(tech@varom, "cvarom",
        obj@parameters[["pTechCvarom"]], approxim_comm, "tech", tech@name
        # remValue = 0
      )
      obj@parameters[["pTechCvarom"]] <-
        .dat2par(obj@parameters[["pTechCvarom"]], pTechCvarom)
    } else {
      pTechCvarom <- NULL
    }
    approxim_acomm <- approxim
    approxim_acomm[["acomm"]] <- rownames(ctype$aux)
    if (length(approxim_acomm[["acomm"]]) != 0) {
      pTechAvarom <- .interp_numpar(tech@varom, "avarom",
        obj@parameters[["pTechAvarom"]], approxim_acomm, "tech", tech@name
        # remValue = 0
      )
      obj@parameters[["pTechAvarom"]] <-
        .dat2par(obj@parameters[["pTechAvarom"]], pTechAvarom)
    } else {
      pTechAvarom <- NULL
    }
    approxim_comm[["comm"]] <- rownames(ctype$comm)
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechAfc <- .interp_bounds(tech@ceff, "afc",
        obj@parameters[["pTechAfc"]], approxim_comm, "tech", tech@name,
        remValueUp = Inf, remValueLo = 0
      )
      obj@parameters[["pTechAfc"]] <-
        .dat2par(obj@parameters[["pTechAfc"]], pTechAfc)
    } else {
      pTechAfc <- NULL
    }
    # Stock & Capacity
    stock_exist <- .interp_numpar(tech@stock, "stock",
                                       obj@parameters[["pTechStock"]], approxim,
                                       "tech", tech@name)
    obj@parameters[["pTechStock"]] <-
      .dat2par(obj@parameters[["pTechStock"]], stock_exist)
    olife <- .interp_numpar(tech@olife, "olife",
                                 obj@parameters[["pTechOlife"]], approxim,
                                 "tech", tech@name
                                 # , removeDefault = FALSE
                                 )
    obj@parameters[["pTechOlife"]] <-
      .dat2par(obj@parameters[["pTechOlife"]], olife)
    # browser() # check warning msg
    dd0 <- .start_end_fix(approxim, tech, "tech", stock_exist)
    dd0$new <- dd0$new[dd0$new$year %in% approxim$mileStoneYears &
                         dd0$new$region %in% approxim$region, , drop = FALSE]
    dd0$span <- dd0$span[dd0$span$year %in% approxim$mileStoneYears &
                           dd0$span$region %in% approxim$region, , drop = FALSE]
    obj@parameters[["mTechNew"]] <-
      .dat2par(obj@parameters[["mTechNew"]], dd0$new)

    invcost <- .interp_numpar(tech@invcost, "invcost",
                                   obj@parameters[["pTechInvcost"]], approxim,
                                   "tech", tech@name)
    if (!is.null(invcost)) {
      # browser()
      minvcost <- merge0(dd0$new, invcost)
      obj@parameters[["mTechInv"]] <-
        .dat2par(obj@parameters[["mTechInv"]],
                  minvcost[, -"value"])
      obj@parameters[["pTechInvcost"]] <-
        .dat2par(obj@parameters[["pTechInvcost"]], invcost)
      obj@parameters[["mTechEac"]] <-
        .dat2par(obj@parameters[["mTechEac"]], dd0$eac)
    }
    # browser()
    obj@parameters[["mTechSpan"]] <-
      .dat2par(obj@parameters[["mTechSpan"]], dd0$span)

    if (nrow(dd0$new) > 0 && !is.null(invcost)) {
      salv_data <- merge0(dd0$new, approxim$discount, all.x = TRUE)
      salv_data$value[is.na(salv_data$value)] <- 0
      salv_data$discount <- salv_data$value
      salv_data$value <- NULL
      olife$olife <- olife$value
      olife$value <- NULL
      salv_data <- merge0(salv_data, olife)
      invcost$invcost <- invcost$value
      invcost$value <- NULL
      salv_data <- merge0(salv_data, invcost)
      # EAC
      salv_data$eac <- salv_data$invcost / salv_data$olife
      fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
      salv_data$eac[fl] <- salv_data$invcost[fl] *
        (salv_data$discount[fl] *
           (1 + salv_data$discount[fl])^salv_data$olife[fl] /
           ((1 + salv_data$discount[fl])^salv_data$olife[fl] - 1)
         )
      fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
      salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]

      salv_data$tech <- tech@name
      salv_data$value <- salv_data$eac
      # browser()
      pTechEac <- salv_data[, c("tech", "region", "year", "value")]
      co <- c(obj@parameters[["pTechEac"]]@dimSets, "value")
      obj@parameters[["pTechEac"]] <-
        .dat2par(obj@parameters[["pTechEac"]], unique(select(pTechEac, all_of(co))))
            # unique(pTechEac[, c(obj@parameters[["pTechEac"]]@dimSets, "value")]))
    }
    pTechAf <- .interp_bounds(tech@af, "af",
      obj@parameters[["pTechAf"]], approxim, "tech", tech@name,
      remValueUp = Inf, remValueLo = 0
    )
    obj@parameters[["pTechAf"]] <-
      .dat2par(obj@parameters[["pTechAf"]], pTechAf)
    if (nrow(tech@afs) > 0) {
      afs_slice <- unique(tech@afs$slice)
      afs_slice <- afs_slice[!is.na(afs_slice)]
      approxim.afs <- approxim
      approxim.afs$slice <- afs_slice
      pTechAfs <- .interp_bounds(
        tech@afs, "afs",
        obj@parameters[["pTechAfs"]],
        approxim.afs, "tech",
        tech@name,
        remValueUp = Inf,
        remValueLo = 0
      )
      obj@parameters[["pTechAfs"]] <- .dat2par(obj@parameters[["pTechAfs"]], pTechAfs)
    } else {
      pTechAfs <- NULL
    }

    approxim_comm[["comm"]] <-
      rownames(ctype$comm)[ctype$comm$type == "input" & is.na(ctype$comm[, "group"])]
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechCinp2use <- .interp_numpar(
        tech@ceff, "cinp2use",
        obj@parameters[["pTechCinp2use"]], approxim_comm, "tech", tech@name
      )
      obj@parameters[["pTechCinp2use"]] <-
        .dat2par(obj@parameters[["pTechCinp2use"]], pTechCinp2use)
    } else {
      pTechCinp2use <- NULL
    }
    approxim_comm[["comm"]] <- rownames(ctype$comm)[ctype$comm$type == "output"]
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechUse2cact <- .interp_numpar(
        tech@ceff, "use2cact",
        obj@parameters[["pTechUse2cact"]], approxim_comm, "tech", tech@name
      )
      obj@parameters[["pTechUse2cact"]] <-
        .dat2par(obj@parameters[["pTechUse2cact"]], pTechUse2cact)
      pTechCact2cout <- .interp_numpar(
        tech@ceff, "cact2cout",
        obj@parameters[["pTechCact2cout"]], approxim_comm, "tech", tech@name
      )
      obj@parameters[["pTechCact2cout"]] <-
        .dat2par(obj@parameters[["pTechCact2cout"]], pTechCact2cout)
      if (any(!is.na(tech@ceff$cact2cout) & (tech@ceff$cact2cout == 0 | tech@ceff$cact2cout == Inf))) {
        stop("cact2cout is not correct ", tech@name)
      }
      if (any(!is.na(tech@ceff$use2cact) &
              (tech@ceff$use2cact == 0 | tech@ceff$use2cact == Inf))) {
        stop("use2cact is not correct ", tech@name)
      }
    } else {
      pTechUse2cact <- NULL
      pTechCact2cout <- NULL
    }
    approxim_comm[["comm"]] <-
      rownames(ctype$comm)[ctype$comm$type == "input" & !is.na(ctype$comm[, "group"])]
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechCinp2ginp <- .interp_numpar(
        tech@ceff, "cinp2ginp",
        obj@parameters[["pTechCinp2ginp"]], approxim_comm, "tech", tech@name
      )
      obj@parameters[["pTechCinp2ginp"]] <-
        .dat2par(obj@parameters[["pTechCinp2ginp"]], pTechCinp2ginp)
    } else {
      pTechCinp2ginp <- NULL
    }
    if (tech@early.retirement) {
      obj@parameters[["mTechRetirement"]] <-
        .dat2par(obj@parameters[["mTechRetirement"]], data.table(tech = tech@name))
    }
    if (length(tech@upgrade.technology) != 0) {
      obj@parameters[["mTechUpgrade"]] <- .dat2par(
        obj@parameters[["mTechUpgrade"]],
        data.table(tech = rep(tech@name, length(tech@upgrade.technology)),
                   techp = tech@upgrade.technology)
      )
    }
    cmm <- rownames(ctype$comm)[ctype$comm$type == "input"]
    if (length(cmm) != 0) {
      mTechInpComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[["mTechInpComm"]] <-
        .dat2par(obj@parameters[["mTechInpComm"]], mTechInpComm)
    } else {
      mTechInpComm <- NULL
    }
    cmm <- rownames(ctype$comm)[ctype$comm$type == "output"]
    if (length(cmm) != 0) {
      mTechOutComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[["mTechOutComm"]] <-
        .dat2par(obj@parameters[["mTechOutComm"]], mTechOutComm)
    } else {
      mTechOutComm <- NULL
    }
    cmm <- rownames(ctype$comm)[is.na(ctype$comm$group)]
    if (length(cmm) != 0) {
      mTechOneComm <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[["mTechOneComm"]] <-
        .dat2par(obj@parameters[["mTechOneComm"]], mTechOneComm)
    } else {
      mTechOneComm <- NULL
    }
    approxim_comm[["comm"]] <- rownames(ctype$comm)[!is.na(ctype$comm$group)]
    if (length(approxim_comm[["comm"]]) != 0) {
      pTechShare <- .interp_bounds(tech@ceff, "share",
        obj@parameters[["pTechShare"]], approxim_comm, "tech", tech@name,
        remValueUp = 1, remValueLo = 0
      )
      obj@parameters[["pTechShare"]] <-
        .dat2par(obj@parameters[["pTechShare"]], pTechShare)
    } else {
      pTechShare <- NULL
    }
    cmm <- rownames(ctype$comm)[ctype$comm$comb != 0]
    if (length(cmm) != 0) {
      obj@parameters[["pTechEmisComm"]] <- .dat2par(
        obj@parameters[["pTechEmisComm"]],
        data.table(
          tech = rep(tech@name, nrow(ctype$comm)),
          comm = rownames(ctype$comm),
          value = ctype$comm$comb
        )
      )
    }
    gpp <- rownames(ctype$group)[ctype$group$type == "input"]
    if (length(gpp) != 0) {
      mTechInpGroup <- data.table(tech = rep(tech@name, length(gpp)), group = gpp)
      obj@parameters[["mTechInpGroup"]] <-
        .dat2par(obj@parameters[["mTechInpGroup"]], mTechInpGroup)
    } else {
      mTechInpGroup <- NULL
    }
    gpp <- rownames(ctype$group)[ctype$group$type == "output"]
    if (length(gpp) != 0) {
      mTechOutGroup <- data.table(tech = rep(tech@name, length(gpp)), group = gpp)
      obj@parameters[["mTechOutGroup"]] <-
        .dat2par(obj@parameters[["mTechOutGroup"]], mTechOutGroup)
    } else {
      mTechOutGroup <- NULL
    }
    approxim_group <- approxim
    approxim_group[["group"]] <- rownames(ctype$group)[ctype$group$type == "input"]
    if (length(approxim_group[["group"]]) != 0) {
      pTechGinp2use <- .interp_numpar(
        tech@geff, "ginp2use",
        obj@parameters[["pTechGinp2use"]], approxim_group, "tech", tech@name
      )
      obj@parameters[["pTechGinp2use"]] <-
        .dat2par(obj@parameters[["pTechGinp2use"]], pTechGinp2use)
    } else {
      pTechGinp2use <- NULL
    }
    if (nrow(ctype$group) > 0) {
      obj@parameters[["group"]] <- addMultipleSet(obj@parameters[["group"]], rownames(ctype$group))
    }
    fl <- !is.na(ctype$comm$group)
    if (any(fl)) {
      mTechGroupComm <- data.table(
        tech = rep(tech@name, sum(fl)), group = ctype$comm$group[fl],
        comm = rownames(ctype$comm)[fl], stringsAsFactors = FALSE
      )
      obj@parameters[["mTechGroupComm"]] <- .dat2par(obj@parameters[["mTechGroupComm"]], mTechGroupComm)
    } else {
      mTechGroupComm <- NULL
    }
    if (any(ctype$aux$output)) {
      cmm <- rownames(ctype$aux)[ctype$aux$output]
      mTechAOut <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[["mTechAOut"]] <- .dat2par(obj@parameters[["mTechAOut"]], mTechAOut)
    } else {
      mTechAOut <- NULL
    }
    if (any(ctype$aux$input)) {
      cmm <- rownames(ctype$aux)[ctype$aux$input]
      mTechAInp <- data.table(tech = rep(tech@name, length(cmm)), comm = cmm)
      obj@parameters[["mTechAInp"]] <- .dat2par(obj@parameters[["mTechAInp"]], mTechAInp)
    } else {
      mTechAInp <- NULL
    }
    # numpar & bounds
    obj@parameters[["pTechCap2act"]] <- .dat2par(
      obj@parameters[["pTechCap2act"]],
      data.table(tech = tech@name, value = tech@cap2act)
    )
    pTechFixom <- .interp_numpar(tech@fixom, "fixom", obj@parameters[["pTechFixom"]], approxim, "tech", tech@name)
    obj@parameters[["pTechFixom"]] <- .dat2par(obj@parameters[["pTechFixom"]], pTechFixom)
    pTechVarom <- .interp_numpar(tech@varom, "varom", obj@parameters[["pTechVarom"]], approxim, "tech", tech@name)
    obj@parameters[["pTechVarom"]] <- .dat2par(obj@parameters[["pTechVarom"]], pTechVarom)

    ## Move from reduce
    mTechNew <- dd0$new
    mTechSpan <- dd0$span
    pTechOlife <- olife
    if (tech@early.retirement) {
      obj@parameters[["mvTechRetiredStock"]] <- .dat2par(
        obj@parameters[["mvTechRetiredStock"]],
        stock_exist[stock_exist$value != 0, colnames(stock_exist) != "value"]
      )
    }
    # browser()
    if (nrow(dd0$new) > 0 && tech@early.retirement) {
      obj@parameters[["meqTechRetiredNewCap"]] <- .dat2par(obj@parameters[["meqTechRetiredNewCap"]], mTechNew)


      mvTechRetiredCap0 <- merge0(merge0(mTechNew, mTechSpan, by = c("tech", "region")),
        pTechOlife,
        by = c("tech", "region")
      )
      mvTechRetiredCap0 <- mvTechRetiredCap0[(
        mvTechRetiredCap0$year.x + mvTechRetiredCap0$olife > mvTechRetiredCap0$year.y &
          mvTechRetiredCap0$year.x <= mvTechRetiredCap0$year.y), -5]
      colnames(mvTechRetiredCap0)[3:4] <- c("year", "year.1")
      obj@parameters[["mvTechRetiredNewCap"]] <- .dat2par(
        obj@parameters[["mvTechRetiredNewCap"]],
        mvTechRetiredCap0
      )
    }
    mvTechAct <- merge0(mTechSpan, mTechSlice, by = "tech")
    obj@parameters[["mvTechAct"]] <-
      .dat2par(obj@parameters[["mvTechAct"]], mvTechAct)
    # Stay only variable with non zero output
    merge_table <- function(mvTechInp, pTechCinp2use) {
      if (is.null(pTechCinp2use) || nrow(pTechCinp2use) == 0) {
        return(NULL)
      }
      return(merge0(
        mvTechInp,
        # pTechCinp2use[pTechCinp2use$value != 0 & pTechCinp2use$value != Inf,
        #               colnames(pTechCinp2use) != "value", drop = FALSE]
        select(
          filter(pTechCinp2use, value != 0 & value < Inf),
          -any_of("value")
        )
      ))
    }
    merge_table2 <- function(mvTechInp, pTechCinp2use, pTechCinp2ginp) {
      if (is.null(pTechCinp2use)) {
        return(merge_table(mvTechInp, pTechCinp2ginp))
      }
      if (is.null(pTechCinp2ginp)) {
        return(merge_table(mvTechInp, pTechCinp2use))
      }
      merge0(mvTechInp, unique(rbind(
        pTechCinp2use[pTechCinp2use$value != 0 & pTechCinp2use$value != Inf, ],
        pTechCinp2ginp[pTechCinp2ginp$value != 0 & pTechCinp2ginp$value != Inf, ]
      )))
    }
    if (!is.null(mTechInpComm)) {
      mvTechInp <- merge0(mvTechAct, mTechInpComm, by = "tech")
      mvTechInp <- merge_table2(mvTechInp, pTechCinp2use, pTechCinp2ginp)
      obj@parameters[["mvTechInp"]] <-
        .dat2par(obj@parameters[["mvTechInp"]], mvTechInp)
    } else {
      mvTechInp <- NULL
    }
    if (!is.null(mTechOutComm)) {
      mvTechOut <- merge0(mvTechAct, mTechOutComm, by = "tech")
      obj@parameters[["mvTechOut"]] <-
        .dat2par(obj@parameters[["mvTechOut"]], mvTechOut)
    } else {
      mvTechOut <- NULL
    }
    if (!is.null(mTechAInp)) {
      mvTechAInp <- merge0(mvTechAct, mTechAInp, by = "tech")
      obj@parameters[["mvTechAInp"]] <-
        .dat2par(obj@parameters[["mvTechAInp"]], mvTechAInp)
    } else {
      mvTechAInp <- NULL
    }
    if (!is.null(mTechAOut)) {
      # browser()
      mvTechAOut <- merge0(mvTechAct, mTechAOut, by = "tech")
      obj@parameters[["mvTechAOut"]] <-
        .dat2par(obj@parameters[["mvTechAOut"]], mvTechAOut)
    } else {
      mvTechAOut <- NULL
    }
    #### aeff ####
    if (nrow(tech@aeff) != 0) {
      if (any(is.na(tech@aeff$acomm))) {
        stop(paste0("NA values in column acomm, slot aeff ", tech@name))
      }
      if (any(is.na(tech@aeff[apply(!is.na(tech@aeff[, c("cinp2ainp", "cinp2aout", "cout2ainp", "cout2aout"), drop = FALSE]), 1, any), "comm"]))) {
        stop(paste0("NA value in column comm, slot aeff ", tech@name), "\n",
             "Parameter 'aeff' requires commodity specification.")
      }
      for (i in 1:4) {
        tech@aeff <- tech@aeff[!is.na(tech@aeff$acomm), ]
        ll <- c("cinp2ainp", "cinp2aout", "cout2ainp", "cout2aout")[i]
        tbl <- c("pTechCinp2AInp", "pTechCinp2AOut", "pTechCout2AInp",
                 "pTechCout2AOut")[i]
        tbl2 <- c("mTechCinp2AInp", "mTechCinp2AOut", "mTechCout2AInp",
                  "mTechCout2AOut")[i]
        # browser()
        # yy <- tech@aeff[!is.na(tech@aeff[, ll]), ]
        yy <- tech@aeff[!is.na(tech@aeff[[ll]]), ]
        if (nrow(yy) != 0) {
          approxim_commp <- approxim
          approxim_commp$acomm <- unique(yy$acomm)
          approxim_commp$comm <- unique(yy$comm)
          tmp <- .interp_numpar(yy, ll, obj@parameters[[tbl]],
                                approxim_commp, "tech", tech@name)
          tmp <- tmp[tmp$value != 0, ]
          if (nrow(tmp) > 0) {
            obj@parameters[[tbl]] <- .dat2par(obj@parameters[[tbl]], tmp)
            tmp$value <- NULL
            if (!all(c("tech", "acomm", "comm", "region", "year", "slice") %in%
                     colnames(tmp))) {
              if (i %in% c(1, 3)) {
                tmp <- merge0(tmp, mvTechInp)
              } else {
                tmp <- merge0(tmp, mvTechOut)
              }
            }
            tmp$comm.1 <- tmp$comm
            tmp$comm <- tmp$acomm
            tmp$acomm <- NULL
            obj@parameters[[tbl2]] <-
              .dat2par(obj@parameters[[tbl2]], tmp[!duplicated(tmp), ])
          }
        }
      }
    }
    dd <- data.frame(
      list = c(
        "pTechAct2AOut", "pTechCap2AOut", "pTechNCap2AOut",
        "pTechAct2AInp", "pTechCap2AInp", "pTechNCap2AInp"
      ),
      table = c("act2aout", "cap2aout", "ncap2aout",
                "act2ainp", "cap2ainp", "ncap2ainp"),
      tab2 = c("mTechAct2AOut", "mTechCap2AOut", "mTechNCap2AOut",
               "mTechAct2AInp", "mTechCap2AInp", "mTechNCap2AInp"),
      stringsAsFactors = FALSE
    )
    # browser()
    for (i in 1:nrow(dd)) {
      approxim_comm <- approxim_comm[names(approxim_comm) != "comm"]
      approxim_comm[["acomm"]] <-
        unique(tech@aeff[!is.na(tech@aeff[, dd$table[i]]), "acomm"])
      if (length(approxim_comm[["acomm"]]) != 0) {
        tmp <- .interp_numpar(tech@aeff, dd$table[i],
                              obj@parameters[[dd$list[i]]],
                              approxim_comm, "tech", tech@name)
        obj@parameters[[dd[i, "list"]]] <-
          .dat2par(obj@parameters[[dd[i, "list"]]], tmp)
        if (!all(c("tech", "acomm", "region", "year", "slice") %in% colnames(tmp))) {
          if (i <= 3) ll <- mvTechInp else ll <- mvTechOut
          ll$comm <- NULL
          tmp <- merge0(tmp, unique(ll))
        }
        tmp$comm <- tmp$acomm
        tmp$acomm <- NULL
        tmp$value <- NULL
        if (ncol(tmp) != ncol(mvTechAct) + 1) {
          tmp <- merge0(tmp, mvTechAct)
        }
        obj@parameters[[dd[i, "tab2"]]] <- .dat2par(obj@parameters[[dd[i, "tab2"]]], tmp)
      }
    }
    #### aeff end
    if (!is.null(mTechInpGroup) && !is.null(mTechOutGroup)) {
      meqTechGrp2Grp <- merge0(
        merge0(mTechInpGroup, mTechOutGroup, by = "tech", suffix = c("", ".1")),
        mvTechAct
      )[, c("tech", "region", "group", "group.1", "year", "slice")]
      obj@parameters[["meqTechGrp2Grp"]] <- .dat2par(obj@parameters[["meqTechGrp2Grp"]], meqTechGrp2Grp)
    } else {
      meqTechGrp2Grp <- NULL
    }
    if (!is.null(mTechInpGroup) || !is.null(mTechOutGroup)) {
      mpTechShareLo <- pTechShare[pTechShare$type == "lo" & pTechShare$value > 0, colnames(pTechShare) != "value"]
      mpTechShareUp <- pTechShare[pTechShare$type == "up" & pTechShare$value < 1, colnames(pTechShare) != "value"]
    } else {
      mpTechShareUp <- NULL
      mpTechShareLo <- NULL
    }
    if (!is.null(mvTechOut) && !is.null(mTechOutGroup) && !is.null(mTechGroupComm)) {
      techGroupOut <- merge0(merge0(mvTechOut, mTechOutGroup), mTechGroupComm)
    } else {
      techGroupOut <- NULL
    }
    if (!is.null(mvTechInp) && !is.null(mTechInpGroup) && !is.null(mTechGroupComm)) {
      techGroupInp <- merge0(merge0(mvTechInp, mTechInpGroup), mTechGroupComm)
    } else {
      techGroupInp <- NULL
    }
    if (!is.null(mvTechInp) && !is.null(mTechOneComm)) {
      techSingInp <- merge0(mvTechInp, mTechOneComm)
      if (!is.null(pTechCinp2use)) {
        techSingInp <- merge0(
          techSingInp,
          # pTechCinp2use[pTechCinp2use$value != 0,
          #               colnames(pTechCinp2use) %in% colnames(techSingInp),
          #               drop = FALSE]
          select(
            filter(pTechCinp2use, value != 0),
            any_of(colnames(techSingInp))
            )
        )
      }
      if (nrow(techSingInp) == 0) techSingInp <- NULL
    } else {
      techSingInp <- NULL
    }
    if (!is.null(mvTechOut) && !is.null(mTechOneComm)) {
      techSingOut <- merge0(mvTechOut, mTechOneComm)
      if (!is.null(pTechCact2cout)) {
        techSingOut <- merge0(
          techSingOut,
          # pTechCact2cout[pTechCact2cout$value != 0,
          #                colnames(pTechCact2cout) %in% colnames(techSingOut),
          #                drop = FALSE]
          select(
            filter(pTechCact2cout, value != 0),
            any_of(colnames(techSingOut))
          )
        )
      }
      if (nrow(techSingOut) == 0) techSingOut <- NULL
    } else {
      techSingOut <- NULL
    }
    if (!is.null(mTechInpGroup) && !is.null(techSingOut)) {
      meqTechGrp2Sng <- merge0(mTechInpGroup, techSingOut)
      obj@parameters[["meqTechGrp2Sng"]] <-
        .dat2par(obj@parameters[["meqTechGrp2Sng"]], meqTechGrp2Sng)
    } else {
      meqTechGrp2Sng <- NULL
    }
    if (!is.null(mTechOutGroup) && !is.null(techSingInp)) {
      meqTechSng2Grp <- merge0(mTechOutGroup, techSingInp)
      obj@parameters[["meqTechSng2Grp"]] <-
        .dat2par(obj@parameters[["meqTechSng2Grp"]], meqTechSng2Grp)
    } else {
      meqTechSng2Grp <- NULL
    }

    if (!is.null(techSingInp) && !is.null(techSingOut)) {
      # browser()
      meqTechSng2Sng <- merge0(techSingInp, techSingOut,
                               by = c("tech", "region", "year", "slice"),
                               suffixes = c("", ".1"))
      obj@parameters[["meqTechSng2Sng"]] <-
        .dat2par(obj@parameters[["meqTechSng2Sng"]], meqTechSng2Sng)
    } else {
      meqTechSng2Sng <- NULL
    }
    if (!is.null(mpTechShareLo) && !is.null(techGroupOut)) {
      meqTechShareOutLo <- merge0(mpTechShareLo, techGroupOut)
      obj@parameters[["meqTechShareOutLo"]] <- .dat2par(
        obj@parameters[["meqTechShareOutLo"]],
        meqTechShareOutLo[, obj@parameters[["meqTechShareOutLo"]]@dimSets]
      )
    } else {
      meqTechShareOutLo <- NULL
    }
    if (!is.null(mpTechShareUp) && !is.null(techGroupOut)) {
      meqTechShareOutUp <- merge0(mpTechShareUp, techGroupOut)
      obj@parameters[["meqTechShareOutUp"]] <- .dat2par(
        obj@parameters[["meqTechShareOutUp"]],
        meqTechShareOutUp[, obj@parameters[["meqTechShareOutUp"]]@dimSets]
      )
    } else {
      meqTechShareOutUp <- NULL
    }
    if (!is.null(mpTechShareLo) && !is.null(techGroupInp)) {
      meqTechShareInpLo <- merge0(mpTechShareLo, techGroupInp)
      obj@parameters[["meqTechShareInpLo"]] <- .dat2par(
        obj@parameters[["meqTechShareInpLo"]],
        meqTechShareInpLo[, obj@parameters[["meqTechShareInpLo"]]@dimSets]
      )
    } else {
      meqTechShareInpLo <- NULL
    }
    if (!is.null(mpTechShareUp) && !is.null(techGroupInp)) {
      meqTechShareInpUp <- merge0(mpTechShareUp, techGroupInp)
      obj@parameters[["meqTechShareInpUp"]] <- .dat2par(
        obj@parameters[["meqTechShareInpUp"]],
        meqTechShareInpUp[, obj@parameters[["meqTechShareInpUp"]]@dimSets]
      )
    } else {
      meqTechShareInpUp <- NULL
    }

    ####
    outer_inf <- function(mvTechAct, pTechAf) {
      merge0(mvTechAct,
             # pTechAf[pTechAf$value != Inf & pTechAf$type == "up",
             #         colnames(pTechAf) %in% colnames(mvTechAct),
             #         drop = FALSE]
             select(
               filter(pTechAf, value != Inf & type == "up"),
               any_of(colnames(mvTechAct))
             )
      )
    }
    if (!is.null(pTechAf) && any(pTechAf$value != 0 & pTechAf$type == "lo")) {
      obj@parameters[["meqTechAfLo"]] <-
        .dat2par(
          obj@parameters[["meqTechAfLo"]],
          merge0(mvTechAct,
                 # pTechAf[pTechAf$value != 0 & pTechAf$type == "lo",
                 #         colnames(pTechAf)[colnames(pTechAf) %in% colnames(mvTechAct)],
                 #         drop = FALSE]
                 select(
                   filter(pTechAf, value != 0 & type == "lo"),
                   any_of(colnames(mvTechAct))
                   )
                 )
          )
    }
    obj@parameters[["meqTechAfUp"]] <-
      .dat2par(obj@parameters[["meqTechAfUp"]], outer_inf(mvTechAct, pTechAf))
    if (!is.null(pTechAfs)) {
      obj@parameters[["meqTechAfsLo"]] <-
        .dat2par(
          obj@parameters[["meqTechAfsLo"]],
          merge0(
            mTechSpan,
            # pTechAfs[
            #   pTechAfs$value != 0 & pTechAfs$type == "lo",
            #   colnames(pTechAfs)[
            #     colnames(pTechAfs) %in%
            #       obj@parameters[["meqTechAfsLo"]]@dimSets]
            #   ]
            select(
              filter(pTechAfs, value != 0 & type == "lo"),
              any_of(obj@parameters[["meqTechAfsLo"]]@dimSets)
              )
            )
          )
      meqTechAfsUp <- merge0(
        mTechSpan,
        # pTechAfs[pTechAfs$value != Inf & pTechAfs$type == "up",
        #          colnames(pTechAfs) %in% obj@parameters[["meqTechAfsUp"]]@dimSets,
        #          drop = FALSE]
        select(
          filter(pTechAfs, value != Inf & type == "up"),
          any_of(obj@parameters[["meqTechAfsUp"]]@dimSets)
        )
      )
      obj@parameters[["meqTechAfsUp"]] <-
        .dat2par(obj@parameters[["meqTechAfsUp"]], meqTechAfsUp)
    }
    if (!is.null(techSingOut)) {
      obj@parameters[["meqTechActSng"]] <-
        .dat2par(obj@parameters[["meqTechActSng"]], techSingOut)
    } else {
      meqTechActSng <- NULL
    }
    if (!is.null(mTechOutGroup)) {
      obj@parameters[["meqTechActGrp"]] <-
        .dat2par(obj@parameters[["meqTechActGrp"]],
                 merge0(mvTechAct, mTechOutGroup))
    } else {
      meqTechActGrp <- NULL
    }
    if (!is.null(pTechAfc)) {
      merge_afc <- function(prm, mvTechOut, pTechAfc, type) {
        if (is.null(pTechAfc) || nrow(pTechAfc) == 0) {
          return(prm)
        }
        if (type == "up") {
          # pTechAfc <- pTechAfc[
          #   pTechAfc$value != Inf & pTechAfc$type == "up",
          #   colnames(pTechAfc) %in%  obj@parameters[["meqTechAfcOutLo"]]@dimSets,
          #   drop = FALSE]
          pTechAfc <- pTechAfc %>%
            filter(value != Inf, type == "up") %>%
            select(any_of(obj@parameters[["meqTechAfcOutLo"]]@dimSets))
        } else {
          # pTechAfc <- pTechAfc[
          #   pTechAfc$value != 0 & pTechAfc$type == "lo",
          #   colnames(pTechAfc) %in% obj@parameters[["meqTechAfcOutLo"]]@dimSets,
          #   drop = FALSE]
          pTechAfc <- pTechAfc %>%
            filter(value != 0 & type == "lo") %>%
            select(any_of(obj@parameters[["meqTechAfcOutLo"]]@dimSets))
        }
        if (nrow(pTechAfc) == 0) {
          return(prm)
        }
        return(.dat2par(prm, merge0(mvTechOut, pTechAfc)))
      }
      obj@parameters[["meqTechAfcOutLo"]] <-
        merge_afc(obj@parameters[["meqTechAfcOutLo"]], mvTechOut, pTechAfc, "lo")
      obj@parameters[["meqTechAfcOutUp"]] <-
        merge_afc(obj@parameters[["meqTechAfcOutUp"]], mvTechOut, pTechAfc, "up")
      obj@parameters[["meqTechAfcInpLo"]] <-
        merge_afc(obj@parameters[["meqTechAfcInpLo"]], mvTechInp, pTechAfc, "lo")
      obj@parameters[["meqTechAfcInpUp"]] <-
        merge_afc(obj@parameters[["meqTechAfcInpUp"]], mvTechInp, pTechAfc, "up")
    }

    if (nrow(tech@weather) > 0) { # !!!ToDo: dplyr
      tmp <- .toWeatherImply(tech@weather, "waf", "tech", tech@name)
      obj@parameters[["pTechWeatherAf"]] <-
        .dat2par(obj@parameters[["pTechWeatherAf"]], tmp$par)
      obj@parameters[["mTechWeatherAfUp"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfUp"]], tmp$mapup)
      obj@parameters[["mTechWeatherAfLo"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfLo"]], tmp$maplo)

      tmp <- .toWeatherImply(tech@weather, "wafs", "tech", tech@name)
      obj@parameters[["pTechWeatherAfs"]] <-
        .dat2par(obj@parameters[["pTechWeatherAfs"]], tmp$par)
      obj@parameters[["mTechWeatherAfsUp"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfsUp"]], tmp$mapup)
      obj@parameters[["mTechWeatherAfsLo"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfsLo"]], tmp$maplo)

      if (any(is.na(tech@weather$comm)[
        apply(!is.na(tech@weather[, c("wafc.lo", "wafc.up", "wafc.fx"),
                                  drop = FALSE]), 1, any)])) {
        stop("comm must be defined for wafc.* parameters")
      }
      tmp <- .toWeatherImply(tech@weather, "wafc", "tech", tech@name, "comm")
      obj@parameters[["pTechWeatherAfc"]] <-
        .dat2par(obj@parameters[["pTechWeatherAfc"]], tmp$par)
      obj@parameters[["mTechWeatherAfcUp"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfcUp"]], tmp$mapup)
      obj@parameters[["mTechWeatherAfcLo"]] <-
        .dat2par(obj@parameters[["mTechWeatherAfcLo"]], tmp$maplo)
    }

    if (all(ctype$comm$type != "output")) {
      stop('Techology "', tech@name, '", there is not activity commodity')
    }
    # mTechOMCost(tech, region, year)
    mTechOMCost <- NULL
    add_omcost <- function(mTechOMCost, pTechFixom) {
      if (is.null(pTechFixom) || all(pTechFixom$value == 0)) {
        return(mTechOMCost)
      }
      x <- rbind(
        mTechOMCost,
        merge0(
          mTechSpan,
          # pTechFixom[pTechFixom$value != 0,
          #            colnames(pTechFixom) %in% colnames(mTechSpan),
          #            drop = FALSE]
          select(
            filter(pTechFixom, value != 0),
            any_of(colnames(mTechSpan))
            )
          )
        )
      return(x)
    }
    mTechOMCost <- add_omcost(mTechOMCost, pTechFixom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechVarom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechCvarom)
    mTechOMCost <- add_omcost(mTechOMCost, pTechAvarom)

    if (!is.null(mTechOMCost)) {
      mTechOMCost <- merge0(mTechOMCost[!duplicated(mTechOMCost), ], mTechSpan)
      obj@parameters[["mTechOMCost"]] <-
        .dat2par(obj@parameters[["mTechOMCost"]], mTechOMCost)
    }

    ### Ramp
    if (tech@fullYear) {
      obj@parameters[["mTechFullYear"]] <- .dat2par(
        obj@parameters[["mTechFullYear"]],
        data.table(tech = tech@name)
      )
    }

    obj <- .add_ramp0(obj, "rampup", tech, mvTechAct, approxim)
    obj <- .add_ramp0(obj, "rampdown", tech, mvTechAct, approxim)
    obj
  }
)


# ==============================================================================#
# Add trade ####
# ==============================================================================#
setMethod(
  ".obj2modInp", signature(
    obj = "modInp", app = "trade",
    approxim = "list"
  ),
  function(obj, app, approxim) {
    # trd <- .upper_case(app)
    trd <- app
    if (length(trd@commodity) != 1 || is.na(trd@commodity) ||
        all(trd@commodity != approxim$all_comm)) {
      stop(paste0('Wrong commodity in trade "', trd@name, '"'))
    }
    trd <- .filter_data_in_slots(trd, approxim$region, "region") ## ??
    remove_duplicate <- list(c("src", "dst"))
    approxim <- .fix_approximation_list(approxim, comm = trd@commodity)
    trd <- .disaggregateSliceLevel(trd, approxim)
    # other flag
    mTradeSlice <- data.table(
      trade = rep(trd@name, length(approxim$slice)),
      slice = approxim$slice)
    obj@parameters[["mTradeSlice"]] <-
      .dat2par(obj@parameters[["mTradeSlice"]], mTradeSlice)
    if (length(trd@commodity) == 0)
      stop("There is not commodity for trade flow ", trd@name)
    obj@parameters[["mTradeComm"]] <-
      .dat2par(obj@parameters[["mTradeComm"]],
               data.table(trade = trd@name,
                          comm = trd@commodity)
    )
    # !!!
    mTradeRoutes <- cbind(
      data.table(trade = rep(trd@name, nrow(trd@routes))),
      trd@routes
      )
    obj@parameters[["mTradeRoutes"]] <-
      .dat2par(obj@parameters[["mTradeRoutes"]], mTradeRoutes)
    pTradeIrCdst2Aout <- NULL
    pTradeIrCsrc2Aout <- NULL
    pTradeIrCdst2Ainp <- NULL
    pTradeIrCsrc2Ainp <- NULL
    # approxim <- approxim[names(approxim) != 'region']
    approxim_srcdst <- approxim
    approxim_srcdst$region <- paste0(trd@routes$src, "##", trd@routes$dst)
    # Apply routes to approximation
    routes <- trd@routes
    imply_routes <- function(tmp) {
      # Checking user data for errors
      kk <- tmp[!is.na(tmp$src) & !is.na(tmp$dst), c("src", "dst"),
                drop = FALSE]
      if (nrow(kk) > 0) {
        if (nrow(kk) != nrow(merge0(kk, routes))) {
          cat('There are data for class trade "', trd@name,
              " for unknown routes:\n", sep = "")
          kk$ind <- seq_len(nrow(kk))
          print(kk[kk$ind[!(kk$ind %in% merge0(kk, routes))],
                   c("src", "dst"), drop = FALSE])
        }
      }
      # Approximation src/dst pair
      if (any(is.na(tmp$src) != is.na(tmp$dst))) {
        # src NA
        fl <- seq_len(nrow(tmp))[is.na(tmp$src) & !is.na(tmp$dst)]
        if (length(fl) > 0) {
          for (i in fl) {
            dst <- routes$dst[!(routes$dst %in% tmp[i, "dst"])]
            if (length(dst) > 0) {
              nn <- nrow(tmp) + seq_along(dst)
              tmp <- rbind(tmp, tmp[rep(i, length(dst)), , drop = FALSE])
              tmp[nn, "dst"] <- dst
            }
          }
          tmp <- tmp[-fl, , drop = FALSE]
        }
        # dst NA
        fl <- seq_len(nrow(tmp))[!is.na(tmp$src) & is.na(tmp$dst)]
        if (length(fl) > 0) {
          for (i in fl) {
            src <- routes$dst[!(routes$src %in% tmp[i, "src"])]
            if (length(src) > 0) {
              nn <- nrow(tmp) + seq_along(src)
              tmp <- rbind(tmp, tmp[rep(i, length(src)), , drop = FALSE])
              tmp[nn, "src"] <- src
            }
          }
          tmp <- tmp[-fl, , drop = FALSE]
        }
      }
      # src & dst NA
      fl <- seq_len(nrow(tmp))[is.na(tmp$src) & is.na(tmp$dst)]
      if (length(fl) > 0) {
        # kk <- rbind(tmp[-fl, c("src", "dst"), drop = FALSE], routes)
        kk <- rbind(
          select(filter(tmp, -fl), all_of(c("src", "dst")),
          routes)
          )
        kk <- kk[!(duplicated(kk) | duplicated(kk, fromLast = TRUE)), ,
                 drop = FALSE]
      }
      if (length(fl) > 0 && nrow(kk) > 0) {
        nn <- nrow(tmp) + seq_len(nrow(kk) * length(fl))
        tmp <- rbind(tmp,
                     tmp[c(t(matrix(fl, length(fl), nrow(kk)))), ,
                         drop = FALSE])
        # tmp[nn, "src"] <- kk$src
        # tmp[nn, "dst"] <- kk$dst
        tmp$src[nn] <- kk$src
        tmp$dst[nn] <- kk$dst
        tmp <- tmp %>% filter(-fl)
      }
      rownames(tmp) <- NULL
      tmp
    }
    .interp_numpar2 <- function(dtf, approxim, parameter, ...) {
      if (all(list(...)[[1]]@dimSets != "src") &&
          all(list(...)[[1]]@dimSets != "dst")) {
        return(.interp_numpar(dtf, approxim = approxim,
                              parameter = parameter, ...))
      }
      dtf <- dtf[!is.na(dtf[[parameter]]), ]
      if (nrow(dtf) == 0 && !approxim$fullsets) {
        return(NULL)
      }
      if (nrow(dtf) != 0) {
        dtf <- imply_routes(dtf)
        dtf$region <- paste0(dtf$src, "##", dtf$dst)
      } else {
        dtf$region <- character()
      }
      dtf$src <- NULL
      dtf$dst <- NULL
      # dtf <- dtf[, c(ncol(dtf), 2:ncol(dtf) - 1), drop = FALSE]
      jj <- colnames(dtf)[c(ncol(dtf), 2:ncol(dtf) - 1)]
      dtf <- dtf %>% select(all_of(jj))
      dd <- .interp_numpar(dtf, approxim = approxim,
                           parameter = parameter, ...)
      if (is.null(dd) || nrow(dd) == 0) {
        return(NULL)
      }
      if (any(list(...)[[1]]@dimSets == "src"))
        dd$src <- gsub("##.*", "", dd$region)
      if (any(list(...)[[1]]@dimSets == "dst"))
        dd$dst <- gsub(".*##", "", dd$region)
      dd$region <- NULL
      dd
    }
    .interp_bounds2 <- function(dtf, approxim, parameter, ...) {
      # browser()
      if (all(list(...)[[1]]@dimSets != "src") &&
          all(list(...)[[1]]@dimSets != "dst")) {
        return(.interp_bounds(dtf, approxim = approxim,
                              parameter = parameter, ...))
      }
      # dtf <- dtf[apply(
      #   !is.na(dtf[, paste0(parameter,
      #                       c(".lo", ".up", ".fx"))]), 1, any), ]
      dtf_bnd <- select(dtf, all_of(paste0(parameter, c(".lo", ".up", ".fx"))))
      dtf <- dtf[apply(!is.na(dtf_bnd), 1, any), ]
      if (nrow(dtf) == 0 && !approxim$fullsets) {
        return(NULL)
      }
      if (nrow(dtf) != 0) {
        # clo <- dtf[, paste0(parameter, ".lo")]
        clo <- dtf %>% select(all_of(paste0(parameter, ".lo")))
        # cup <- dtf[, paste0(parameter, ".up")]
        cup <- dtf %>% select(all_of(paste0(parameter, ".up")))
        # cfx <- dtf[, paste0(parameter, ".fx")]
        cfx <- dtf %>% select(all_of(paste0(parameter, ".fx")))
        # dtf[, paste0(parameter, c(".up", ".fx", ".lo"))] <- NA
        # dtf <- mutate_at(dtf, # superseded
        #                  .vars = paste0(parameter, c(".up", ".fx", ".lo")),
        #                  .funs = function(x) NA)
        dtf <- mutate(dtf, across(paste0(parameter, c(".up", ".fx", ".lo")),
                                  function(x) as.numeric(NA))
                      )
        dtf <- rbind(dtf, dtf)
        # dtf[, paste0(parameter, ".lo")] <- c(clo, cfx)
        dtf[[paste0(parameter, ".lo")]] <- c(clo[[1]], cfx[[1]])
        frm_lo <- imply_routes(dtf[!is.na(c(clo[[1]], cfx[[1]])), ])
        # dtf[, paste0(parameter, ".lo")] <- NA
        dtf[[paste0(parameter, ".lo")]] <- as.numeric(NA)
        # dtf[, paste0(parameter, ".up")] <- c(cup, cfx)
        dtf[[paste0(parameter, ".up")]] <- c(cup[[1]], cfx[[1]])
        frm_up <- imply_routes(dtf[!is.na(c(cup[[1]], cfx[[1]])), ])
        dtf <- rbind(frm_lo, frm_up)
        dtf$region <- paste0(dtf$src, "##", dtf$dst)
      } else {
        dtf$region <- character()
      }
      dtf$src <- NULL
      dtf$dst <- NULL
      dtf_nms <- colnames(dtf)[c(ncol(dtf), 2:ncol(dtf) - 1)]
      # dtf <- dtf[, c(ncol(dtf), 2:ncol(dtf) - 1), drop = FALSE]
      dtf <- dtf %>% select(all_of(dtf_nms))
      dd <- .interp_bounds(dtf, approxim = approxim,
                           parameter = parameter, ...)
      if (is.null(dd) || nrow(dd) == 0) {
        return(NULL)
      }
      if (any(list(...)[[1]]@dimSets == "src"))
        dd$src <- gsub("##.*", "", dd$region)
      if (any(list(...)[[1]]@dimSets == "dst"))
        dd$dst <- gsub(".*##", "", dd$region)
      dd$region <- NULL
      dd
    }
    # pTradeIrCost
    obj@parameters[["pTradeIrCost"]] <-
      .dat2par(obj@parameters[["pTradeIrCost"]],
               .interp_numpar2(
                 trd@trade,
                 parameter = "cost", obj@parameters[["pTradeIrCost"]],
                 approxim = approxim_srcdst, "trade", trd@name
                 )
               )
    pTradeIrEff <- .interp_numpar2(trd@trade, parameter = "teff",
                                   obj@parameters[["pTradeIrEff"]],
                                   approxim = approxim_srcdst, "trade",
                                   trd@name
                                   )
    obj@parameters[["pTradeIrEff"]] <-
      .dat2par(obj@parameters[["pTradeIrEff"]], pTradeIrEff)
    # pTradeIrMarkup
    obj@parameters[["pTradeIrMarkup"]] <- .dat2par(
      obj@parameters[["pTradeIrMarkup"]],
      .interp_numpar2(trd@trade,
        parameter = "markup", obj@parameters[["pTradeIrMarkup"]],
        approxim = approxim_srcdst, "trade", trd@name
      )
    )
    # pTradeIr
    pTradeIr <- .interp_bounds2(trd@trade,
      parameter = "ava",
      obj@parameters[["pTradeIr"]],
      approxim = approxim_srcdst, "trade", trd@name
    )
    obj@parameters[["pTradeIr"]] <-
      .dat2par(obj@parameters[["pTradeIr"]], pTradeIr)
    # Trade ainp
    mTradeIrAInp <- NULL
    mTradeIrAOut <- NULL
    if (nrow(trd@aux) != 0) {
      if (any(is.na(trd@aux$acomm))) {
        stop('Wrong aux commodity for trade "', trd@name, '"')
      }
      trd@aeff <- trd@aeff[!is.na(trd@aeff$acomm), , drop = FALSE]
      if (!all(trd@aeff$acomm %in% trd@aux$acomm)) {
        stop('Wrong aux commodity for trade "', trd@name, '"')
      }
      inp_comm <-
        unique(trd@aeff[!is.na(trd@aeff$csrc2ainp) |
                          !is.na(trd@aeff$cdst2ainp), "acomm"])
      out_comm <-
        unique(trd@aeff[!is.na(trd@aeff$csrc2aout) |
                          !is.na(trd@aeff$cdst2aout), "acomm"])
      if (length(inp_comm) != 0) {
        mTradeIrAInp <-
          data.table(trade = rep(trd@name, length(inp_comm)),
                     comm = inp_comm)
        obj@parameters[["mTradeIrAInp"]] <-
          .dat2par(obj@parameters[["mTradeIrAInp"]], mTradeIrAInp)
      }
      if (length(out_comm) != 0) {
        mTradeIrAOut <- data.table(
          trade = rep(trd@name, length(out_comm)),
          comm = out_comm)
        obj@parameters[["mTradeIrAOut"]] <-
          .dat2par(obj@parameters[["mTradeIrAOut"]], mTradeIrAOut)
      }
      for (cc in inp_comm) {
        approxim_srcdst$acomm <- cc
        pTradeIrCsrc2Ainp <-
          .interp_numpar2(trd@aeff,
          parameter = "csrc2ainp",
          obj@parameters[["pTradeIrCsrc2Ainp"]],
          approxim = approxim_srcdst, "trade", trd@name
        )
        obj@parameters[["pTradeIrCsrc2Ainp"]] <-
          .dat2par(obj@parameters[["pTradeIrCsrc2Ainp"]],
                   pTradeIrCsrc2Ainp)
        pTradeIrCdst2Ainp <-
          .interp_numpar2(trd@aeff,
          parameter = "cdst2ainp",
          obj@parameters[["pTradeIrCdst2Ainp"]],
          approxim = approxim_srcdst, "trade", trd@name
        )
        obj@parameters[["pTradeIrCdst2Ainp"]] <-
          .dat2par(obj@parameters[["pTradeIrCdst2Ainp"]],
                   pTradeIrCdst2Ainp)
      }
      for (cc in out_comm) {
        approxim_srcdst$acomm <- cc
        pTradeIrCsrc2Aout <-
          .interp_numpar2(trd@aeff, parameter = "csrc2aout",
                          obj@parameters[["pTradeIrCsrc2Aout"]],
                          approxim = approxim_srcdst, "trade",
                          trd@name)
        obj@parameters[["pTradeIrCsrc2Aout"]] <-
          .dat2par(obj@parameters[["pTradeIrCsrc2Aout"]],
                   pTradeIrCsrc2Aout)
        pTradeIrCdst2Aout <-
          .interp_numpar2(trd@aeff,
          parameter = "cdst2aout", obj@parameters[["pTradeIrCdst2Aout"]],
          approxim = approxim_srcdst, "trade", trd@name
        )
        obj@parameters[["pTradeIrCdst2Aout"]] <-
          .dat2par(obj@parameters[["pTradeIrCdst2Aout"]],
                   pTradeIrCdst2Aout)
      }
      approxim_srcdst$acomm <- NULL
    }
    # Add trade data
    if (trd@capacityVariable) {
      obj@parameters[["pTradeCap2Act"]] <-
        .dat2par(
        obj@parameters[["pTradeCap2Act"]],
        data.table(trade = trd@name, value = trd@cap2act)
      )
      mTradeCapacityVariable <- data.table(trade = trd@name)
      obj@parameters[["mTradeCapacityVariable"]] <-
        .dat2par(obj@parameters[["mTradeCapacityVariable"]],
                 mTradeCapacityVariable)

      ## !!! Trade
      if (nrow(trd@invcost) > 0) {
        if (any(is.na(trd@invcost$region)) && nrow(trd@invcost) > 1) {
          stop('There is "NA" and other data for invcost in trade class "',
               trd@name, '".')
        }
        if (any(is.na(trd@invcost$region))) {
          warning('There is a" NA "area for invcost in the"', trd@name,
                  '"trade class. Investments will be smoothed along all ',
                  'routes of the regions.')
          rgg <- unique(c(trd@routes$src, trd@routes$dst))
          trd@invcost <- trd@invcost[rep(1, length(rgg)), , drop = FALSE]
          trd@invcost[, "region"] <- rgg
          trd@invcost[, "invcost"] <- trd@invcost[1, "invcost"] / length(rgg)
        }
      }
      invcost <- .interp_numpar(trd@invcost, "invcost",
                                obj@parameters[["pTradeInvcost"]], approxim,
                                "trade", trd@name)
      invcost <- invcost[invcost$value != 0, , drop = FALSE]
      if (!is.null(invcost$year)) {
        invcost <- invcost[trd@start <= invcost$year & invcost$year <= trd@end, ,
                           drop = FALSE]
      }
      if (!is.null(invcost) && nrow(invcost) == 0) invcost <- NULL
      stock_exist <- .interp_numpar(trd@stock, "stock",
                                    obj@parameters[["pTradeStock"]], approxim,
                                    "trade", trd@name)
      obj@parameters[["pTradeStock"]] <-
        .dat2par(obj@parameters[["pTradeStock"]], stock_exist)
      obj@parameters[["pTradeOlife"]] <- .dat2par(
        obj@parameters[["pTradeOlife"]],
        data.table(trade = trd@name, value = trd@olife, stringsAsFactors = FALSE)
      )
      possible_invest_year <- approxim$mileStoneYears
      possible_invest_year <- possible_invest_year[
        trd@start <= possible_invest_year & possible_invest_year <= trd@end
        ]
      if (length(possible_invest_year) > 0) {
        obj@parameters[["mTradeNew"]] <- .dat2par(
          obj@parameters[["mTradeNew"]],
          data.table(trade = rep(trd@name, length(possible_invest_year)),
                     year = possible_invest_year,
                     stringsAsFactors = FALSE)
        )
      }

      min0 <- function(x) {
        if (length(x) == 0) {
          return(-Inf)
        }
        return(min(x))
      }
      if (trd@olife == Inf) {
        trade_eac <- unique(
          approxim$year[min0(possible_invest_year) <= approxim$year]
          )
        trade_span <- unique(c(trd@stock$year, trade_eac))
        obj@parameters[["mTradeOlifeInf"]] <-
          .dat2par(obj@parameters[["mTradeOlifeInf"]],
                   data.table(trade = trd@name))
      } else {
        trade_eac <- unique(c(sapply(
          possible_invest_year,
          function(x) {
            approxim$year[x <= approxim$year & approxim$year <= x + trd@olife]
          }
        ), recursive = TRUE))
        trade_span <- unique(c(trd@stock$year, trade_eac))
      }
      trade_eac <- trade_eac[trade_eac %in% approxim$mileStoneYears]
      trade_span <- trade_span[trade_span %in% approxim$mileStoneYears]
      if (length(trade_span) > 0) {
        mTradeSpan <- data.table(
          trade = rep(trd@name, length(trade_span)),
          year = trade_span,
          stringsAsFactors = FALSE)
        obj@parameters[["mTradeSpan"]] <-
          .dat2par(obj@parameters[["mTradeSpan"]], mTradeSpan)
        meqTradeCapFlow <- merge0(mTradeSpan, mTradeSlice)
        meqTradeCapFlow$comm <- trd@commodity
        obj@parameters[["meqTradeCapFlow"]] <-
          .dat2par(obj@parameters[["meqTradeCapFlow"]], meqTradeCapFlow)
      }
      # mTradeInv
      if (!is.null(invcost)) {
        end_year <- max(approxim$year)
        obj@parameters[["pTradeInvcost"]] <-
          .dat2par(obj@parameters[["pTradeInvcost"]], invcost)
        if (any(!(obj@parameters[["mTradeInv"]]@dimSets %in%
                  colnames(invcost)))) {
          if (is.null(invcost$year)) {
            invcost <- merge0(invcost, list(year = possible_invest_year))
          }
          if (is.null(invcost$region)) {
            invcost <- merge0(invcost, approxim["region"])
          }
        }
        obj@parameters[["mTradeInv"]] <-
          .dat2par(obj@parameters[["mTradeInv"]],
                   # invcost[, colnames(invcost) != "value"]
                   select(invcost, -value)
                   )
        invcost$invcost <- invcost$value
        invcost$value <- NULL
        if (length(trade_eac) > 0) {
          # browser()
          # mTradeEac <- merge(unique(invcost$region), trade_eac) %>%
            # as.data.table()
          mTradeEac <- expand_grid(
            region = unique(invcost$region),
            year = trade_eac) %>%
            as.data.table()
          mTradeEac$trade <- trd@name
          # mTradeEac$region <- as.character(mTradeEac$x)
          # mTradeEac$year <- mTradeEac$y
          # mTradeEac$x <- NULL
          # mTradeEac$y <- NULL
          obj@parameters[["mTradeEac"]] <-
            .dat2par(obj@parameters[["mTradeEac"]], mTradeEac)
        }
        salv_data <- merge0(invcost, approxim$discount, all.x = TRUE)
        salv_data$value[is.na(salv_data$value)] <- 0
        salv_data$discount <- salv_data$value
        salv_data$value <- NULL
        salv_data$olife <- trd@olife
        # EAC
        salv_data$eac <- salv_data$invcost / salv_data$olife
        fl <- (salv_data$discount != 0 & salv_data$olife != Inf)
        salv_data$eac[fl] <- salv_data$invcost[fl] *
          (salv_data$discount[fl] *
             (1 + salv_data$discount[fl])^salv_data$olife[fl] /
             ((1 + salv_data$discount[fl])^salv_data$olife[fl] - 1))
        fl <- (salv_data$discount != 0 & salv_data$olife == Inf)
        salv_data$eac[fl] <- salv_data$invcost[fl] * salv_data$discount[fl]
        salv_data$trade <- trd@name
        salv_data$value <- salv_data$eac
        pTradeEac <- salv_data[, c("trade", "region", "year", "value")]
        obj@parameters[["pTradeEac"]] <-
          .dat2par(
            obj@parameters[["pTradeEac"]],
            unique(
             # pTradeEac[, colnames(pTradeEac) %in%
             #             c(obj@parameters[["pTradeEac"]]@dimSets, "value"),
             #           drop = FALSE]
              select(
                pTradeEac,
                any_of(c(obj@parameters[["pTradeEac"]]@dimSets, "value")))
              ))
      }
    }
    ####
    mTradeIr <- merge0(mTradeRoutes, mTradeSlice)
    if (trd@capacityVariable) {
      mTradeIr <- merge0(mTradeIr, mTradeSpan)
    } else {
      mTradeIr <- merge0(mTradeIr, list(year = approxim$mileStoneYears))
    }

    obj@parameters[["mTradeIr"]] <-
      .dat2par(obj@parameters[["mTradeIr"]], mTradeIr)
    ### To trades
    if (!is.null(mTradeIrAInp)) {
      if (!is.null(pTradeIrCsrc2Ainp) && any(pTradeIrCsrc2Ainp$value != 0)) {
        mTradeIrCsrc2Ainp <-
          select(
            filter(pTradeIrCsrc2Ainp, value != 0),
            any_of(c("trade", "acomm", "src", "dst", "year", "slice"))
          )
      # pTradeIrCsrc2Ainp[pTradeIrCsrc2Ainp$value != 0,
      #                   colnames(pTradeIrCsrc2Ainp) %in%
      #                     c("trade", "acomm", "src", "dst", "year", "slice"),
      #                   drop = FALSE]

        if (is.null(mTradeIrCsrc2Ainp$acomm))
          mTradeIrCsrc2Ainp <- merge0(mTradeIrCsrc2Ainp, mTradeIrAInp)
        mTradeIrCsrc2Ainp$comm <- mTradeIrCsrc2Ainp$acomm
        mTradeIrCsrc2Ainp$acomm <- NULL
        if (ncol(mTradeIrCsrc2Ainp) != 6) {
          mTradeIrCsrc2Ainp <- merge0(mTradeIrCsrc2Ainp, mTradeIr)
        }
        obj@parameters[["mTradeIrCsrc2Ainp"]] <-
          .dat2par(obj@parameters[["mTradeIrCsrc2Ainp"]], mTradeIrCsrc2Ainp)
        a1 <- unique(
          mTradeIrCsrc2Ainp[, c("trade", "comm", "src", "year", "slice")]
          )
        colnames(a1)[3] <- "region"
      } else {
        a1 <- NULL
      }
      if (!is.null(pTradeIrCdst2Ainp) && any(pTradeIrCdst2Ainp$value != 0)) {
        mTradeIrCdst2Ainp <-
          select(
            filter(pTradeIrCdst2Ainp, value != 0),
            any_of(c("trade", "acomm", "src", "dst", "year", "slice"))
          )
        # pTradeIrCdst2Ainp[
        #   pTradeIrCdst2Ainp$value != 0,
        #   colnames(pTradeIrCdst2Ainp) %in%
        #     c("trade", "acomm", "src", "dst", "year", "slice"),
        #   drop = FALSE]

        if (is.null(mTradeIrCdst2Ainp$acomm)) {
          mTradeIrCdst2Ainp <- merge0(mTradeIrCdst2Ainp, mTradeIrAInp)
        }
        mTradeIrCdst2Ainp$comm <- mTradeIrCdst2Ainp$acomm
        mTradeIrCdst2Ainp$acomm <- NULL
        if (ncol(mTradeIrCdst2Ainp) != 6) {
          mTradeIrCdst2Ainp <- merge0(mTradeIrCdst2Ainp, mTradeIr)
        }
        obj@parameters[["mTradeIrCdst2Ainp"]] <-
          .dat2par(obj@parameters[["mTradeIrCdst2Ainp"]], mTradeIrCdst2Ainp)
        a2 <- unique(
          mTradeIrCdst2Ainp[, c("trade", "comm", "dst", "year", "slice")]
          )
        colnames(a2)[3] <- "region"
      } else {
        a2 <- NULL
      }
      obj@parameters[["mvTradeIrAInp"]] <-
        .dat2par(obj@parameters[["mvTradeIrAInp"]], unique(rbind(a1, a2)))
    }

    if (!is.null(mTradeIrAOut)) {
      if (!is.null(pTradeIrCsrc2Aout) && any(pTradeIrCsrc2Aout$value != 0)) {
        mTradeIrCsrc2Aout <-
          select(filter(pTradeIrCsrc2Aout, value != 0),
                 any_of(c("trade", "acomm", "src", "dst", "year", "slice")))
        # pTradeIrCsrc2Aout[
          #   pTradeIrCsrc2Aout$value != 0,
          #   colnames(pTradeIrCsrc2Aout) %in%
          #     c("trade", "acomm", "src", "dst", "year", "slice"),
          #   drop = FALSE]
        if (is.null(mTradeIrCsrc2Aout$acomm)) {
          mTradeIrCsrc2Aout <- merge0(mTradeIrCsrc2Aout, mTradeIrAOut)
        }
        mTradeIrCsrc2Aout$comm <- mTradeIrCsrc2Aout$acomm
        mTradeIrCsrc2Aout$acomm <- NULL
        if (ncol(mTradeIrCsrc2Aout) != 6) {
          mTradeIrCsrc2Aout <- merge0(mTradeIrCsrc2Aout, mTradeIr)
        }
        obj@parameters[["mTradeIrCsrc2Aout"]] <-
          .dat2par(obj@parameters[["mTradeIrCsrc2Aout"]], mTradeIrCsrc2Aout)
        a1 <- unique(
          mTradeIrCsrc2Aout[, c("trade", "comm", "src", "year", "slice")]
          )
        colnames(a1)[3] <- "region"
      } else {
        a1 <- NULL
      }
      if (!is.null(pTradeIrCdst2Aout) && any(pTradeIrCdst2Aout$value != 0)) {
        mTradeIrCdst2Aout <-
          select(filter(pTradeIrCdst2Aout, value != 0.),
                 any_of(c("trade", "acomm", "src", "dst", "year", "slice")))
          # pTradeIrCdst2Aout[
          #   pTradeIrCdst2Aout$value != 0,
          #   colnames(pTradeIrCdst2Aout) %in%
          #     c("trade", "acomm", "src", "dst", "year", "slice"),
          #   drop = FALSE]
        if (is.null(mTradeIrCdst2Aout$acomm)) {
          mTradeIrCdst2Aout <- merge0(mTradeIrCdst2Aout, mTradeIrAOut)
        }
        mTradeIrCdst2Aout$comm <- mTradeIrCdst2Aout$acomm
        mTradeIrCdst2Aout$acomm <- NULL
        if (ncol(mTradeIrCdst2Aout) != 6) {
          mTradeIrCdst2Aout <- merge0(mTradeIrCdst2Aout, mTradeIr)
        }
        obj@parameters[["mTradeIrCdst2Aout"]] <-
          .dat2par(obj@parameters[["mTradeIrCdst2Aout"]], mTradeIrCdst2Aout)
        a2 <- unique(
          mTradeIrCdst2Aout[, c("trade", "comm", "dst", "year", "slice")]
          )
        colnames(a2)[3] <- "region"
      } else {
        a2 <- NULL
      }
      obj@parameters[["mvTradeIrAOut"]] <-
        .dat2par(obj@parameters[["mvTradeIrAOut"]], unique(rbind(a1, a2)))
    }
    mvTradeIr <- mTradeIr
    mvTradeIr$comm <- trd@commodity
    obj@parameters[["mvTradeIr"]] <-
      .dat2par(obj@parameters[["mvTradeIr"]], mvTradeIr)
    if (!is.null(pTradeIr)) {
      pTradeIr$comm <- trd@commodity
      obj@parameters[["meqTradeFlowLo"]] <-
        .dat2par(
          obj@parameters[["meqTradeFlowLo"]],
          merge0(
            mvTradeIr,
            select(
              filter(pTradeIr, type == "lo" & value != 0),
              any_of(colnames(mvTradeIr))
            )
            # pTradeIr[pTradeIr$type == "lo" & pTradeIr$value != 0,
            #          colnames(pTradeIr) %in% colnames(mvTradeIr),
            #          drop = FALSE]
            )
          )
      obj@parameters[["meqTradeFlowUp"]] <-
        .dat2par(
          obj@parameters[["meqTradeFlowUp"]],
          merge0(
            mvTradeIr,
            select(filter(pTradeIr, type == "up" & value != Inf))
          )
          # pTradeIr[pTradeIr$type == "up" & pTradeIr$value != Inf,
                 #          colnames(pTradeIr) %in% colnames(mvTradeIr),
                 #          drop = FALSE]
                 # )
        )
      pTradeIr$comm <- NULL
    }
    obj
  }
)

# ==============================================================================#
# Internal functions ####
# ==============================================================================#

# ???
.start_end_fix <- function(approxim, app, als, stock_exist) {
  # browser()
  if (is.null(stock_exist)) stock_exist <- data.table()
  stock_exist <- stock_exist[stock_exist$value != 0, ]
  # Start / End year
  dd <- data.table(
    enable = rep(TRUE, length(approxim$region) * length(approxim$year)),
    app = rep(app@name, length(approxim$region) * length(approxim$year)),
    region = rep(approxim$region, length(approxim$year)),
    year = c(t(matrix(rep(approxim$year, length(approxim$region)),
                      length(approxim$year)))),
    stringsAsFactors = FALSE
  )
  colnames(dd)[2] <- als
  dstart <- data.table(
    row.names = approxim$region, region = approxim$region,
    year = as.integer(rep(NA, length(approxim$region))),
    stringsAsFactors = FALSE
  )
  fl <- is.na(app@start$region)
  if (any(fl)) {
    if (sum(fl) != 1) {
      stop('Wrong start year for "', class(app), '" ', app@name)
    }
    dstart[, "year"] <- app@start[fl, "start"]
  }
  if (any(!fl)) {
    dstart[app@start[!fl, "region"], "year"] <- app@start[!fl, "start"]
  }
  dstart <- dstart[!is.na(dstart$year), , drop = FALSE]
  for (rr in dstart$region) {
    # browser()
    # if (!is.na(dstart[rr, "year"]) && any(dd$year < dstart[rr, "year"]))
    #   dd[dd$region == rr & dd$year < dstart[rr, "year"], "enable"] <- FALSE
    ii <- dstart$region %in% rr
    if (!is.na(dstart$year[ii]) && any(dd$year < dstart$year[ii])) {
      dd$enable[dd$region == rr & dd$year < dstart$year[ii]] <- FALSE
    }
  }
  dd_able <- dd
  ## end
  dend <- data.table(
    row.names = approxim$region,
    region = approxim$region,
    year = as.integer(rep(NA, length(approxim$region))),
    stringsAsFactors = FALSE
  )
  fl <- is.na(app@end$region)
  if (any(fl)) {
    if (sum(fl) != 1)
      stop('Wrong start year for "', class(app), '" ', app@name)
    dend[, "year"] <- app@end[fl, "end"]
  }
  if (any(!fl)) {
    dend[app@end[!fl, "region"], "year"] <- app@end[!fl, "end"]
  }
  dend <- dend[!is.na(dend$year), , drop = FALSE]
  for (rr in dend$region) {
    ii <- dend$region %in% rr
    if (any(dd$year > dend$year[ii]))
      dd[dd$region == rr & dd$year > dend$year[ii], "enable"] <- FALSE
  }
  dd <- dd[dd$enable, -1, drop = FALSE]
  ## life
  dlife <- data.table(
    row.names = approxim$region, region = approxim$region,
    year = as.integer(rep(NA, length(approxim$region))),
    stringsAsFactors = FALSE
  )
  fl <- is.na(app@olife$region)
  if (any(fl)) {
    if (sum(fl) != 1)
      stop('Wrong start year for "', class(app), '" ', app@name)
    dlife[, "year"] <- app@olife[fl, "olife"] # !!! ???
  }
  if (any(!fl)) {
    dlife[app@olife[!fl, "region"], "year"] <- app@olife[!fl, "olife"]
  }
  dlife <- dlife[!is.na(dlife$year), , drop = FALSE]
  for (rr in dlife$region[dlife$region %in% dend$region]) {
    # browser()
    nn <- dend$region %in% rr
    ii <- dlife$region %in% rr
    if (any(dd_able$year >= dend$year[nn] + dlife$year[ii])) {
      ee <- dd_able$region == rr &
            dd_able$year >= dend$year[nn] + dlife$year[rr]
      dd_able$enable[ee] <- FALSE
    }
  }
  dd_eac <- dd_able
  if (nrow(stock_exist) != 0 && any(!dd_able$enable)) {
    for (rr in unique(stock_exist$region)) {
      ii <- stock_exist$region == rr
      ee <- dd_able$region == rr & dd_able$year %in% stock_exist$year[ii]
      dd_able$enable[ee] <- TRUE
    }
  }
  #
  dd_able <- dd_able[dd_able$enable, -1, drop = FALSE]
  dd_eac <- dd_eac[dd_eac$enable, -1, drop = FALSE]
  dd <- dd[dd$year %in% approxim$mileStoneYears, ]
  dd_eac <- dd_eac[dd_eac$year %in% approxim$mileStoneYears, ]
  dd_able <- dd_able[dd_able$year %in% approxim$mileStoneYears, ]
  list(new = dd, span = dd_able, eac = dd_eac)
}

# =============================================================================#
# ???
merge0 <- function(x, y,
                   by = intersect(
                     colnames(as.data.table(x)),
                     colnames(as.data.table(y))
                   ),
                   ...) {
  # assign('x', x, globalenv()) assign('y', y, globalenv())
  if (length(by) != 0) {
    # browser()
    y <- as.data.table(y) %>% .force_year_class_df()
    x <- as.data.table(x) %>% .force_year_class_df()
    xy <- merge(x, y, by = by, ..., allow.cartesian = TRUE)
    # return(as.data.table(xy)) # debug pDiscountFactorMileStone
    return(xy)
  }
  # browser()
  # y <- as.data.table(y) %>% .force_year_class_df()
  # x <- as.data.table(x) %>% .force_year_class_df()
  y <- .force_year_class_df(y)
  x <- .force_year_class_df(x)
  # xy <- merge(x, y)
  xy <- dplyr::cross_join(x, y) # !!! rewrite
  # colnames(xy) <- c(colnames(x), colnames(y)) # ???
  # return(as.data.table(xy))
  return(as.data.table(xy))
}

.force_year_class_df <- function(dtf) {
  if (!is.data.frame(dtf) & !is.list(dtf)) browser()
  # return(dtf)
  # temporary solution to avoid merging conflicts
  year_vars <- c("year", "yearp", "start", "end", "olife")
  force_class <- "integer"
  # force_class <- "numeric"
  for (y in year_vars) {
    if (!is.null(dtf[[y]]) && !inherits(dtf, force_class)) {
      dtf[[y]] <- as(dtf[[y]], force_class)
    }
  }
  as.data.table(dtf)
}

.force_value_class_df <- function(dtf) {
  if (!is.data.frame(dtf) & !is.list(dtf)) browser()
  # return(dtf)
  # temporary solution to avoid merging conflicts
  if (!is.null(dtf[["value"]]) && !inherits(dtf[["value"]], "numeric")) {
    print(as_tibble(dtf))
    stop("Non-numeric 'value' column")
    dtf[["value"]] <- as.numeric(dtf[["value"]])
  }
  as.data.table(dtf)
}

# ==============================================================================#
# ???
.filter_data_in_slots <- function(obj, lst, coln) {
  # browser()
  # filter out
  ss <- getSlots(class(obj))
  if (any(names(ss) == coln) && ss[coln] == "character") {
    # !!! adding (potentially) missing filter for character slots like region
    if (!all(is.na(slot(obj, coln))) && length(slot(obj, coln)) > 0) {
      slot(obj, coln) <- slot(obj, coln)[slot(obj, coln) %in% lst]
    }
  }
  ss <- names(ss)[ss %in% "data.frame"]
  ss <- ss[sapply(ss, function(x) {
    any(colnames(slot(obj, x)) == coln) && nrow(slot(obj, x)) != 0
    })]
  for (sl in ss) {
    slot(obj, sl) <- slot(obj, sl)[
      is.na(slot(obj, sl)[, coln]) |
        slot(obj, sl)[, coln] %in% lst, ,
      drop = FALSE]
  }
  obj
}

# ==============================================================================#
# Add approximation list
# (auxiliary list for approximation) to standard view
# ==============================================================================#
.fix_approximation_list <- function(approxim, lev = NULL, comm = NULL) {
  # better name?
  # browser()
  if (length(lev) == 0) {
    if (length(comm) == 0) {
      stop("Internal error: 66a37cde-24e2-4ac5-ab24-b79e0f603bf7")
    }
    lev <- approxim$commodity_slice_map[[comm]]
  }
  # ??? better name for approxim$parent_child ???
  approxim$parent_child <- approxim$calendar@slice_ancestry
  approxim$slice <- approxim$calendar@timeframes[[lev]]
  # approxim$parent_child <-
  #   approxim$parent_child[approxim$parent_child$child %in% approxim$slice, ,
  #                         drop = FALSE]
  approxim$parent_child <- approxim$parent_child %>%
    filter(child %in% approxim$slice)
  approxim
}

# ==============================================================================#
# tax & sub
# ==============================================================================#
.subtax_approxim <- function(obj, app, tax, whr, approxim) {
  if (all(app@comm != names(approxim$commodity_slice_map))) {
    stop('Unknown commodity "', app@comm, '" in ', whr, ' "', app@name, '"')
  }
  if (length(app@region) != 0) {
    if (!all(app@region %in% approxim$region)) {
      stop(paste0(whr, ': unknown region "',
                  paste0(app@region[!(app@region %in% approxim$region)],
                         collapse = '", "'), '"'))
    }
    approxim$region <- app@region
  }
  browser()
  approxim$slice <-
    approxim$calendar@timeframes[[approxim$commodity_slice_map[[app@comm]]]]
  if (whr == "tax") {
    for (ii in c("Inp", "Out", "Bal")) {
      obj@parameters[[paste0("pTaxCost", ii)]] <- .dat2par(
        obj@parameters[[paste0("pTaxCost", ii)]],
        .interp_numpar(
          app@tax, tolower(ii), obj@parameters[[paste0("pTaxCost", ii)]],
          approxim, "comm", app@comm
        )
      )
    }
  } else if (whr == "subsidy") {
    for (ii in c("Inp", "Out", "Bal")) {
      obj@parameters[[paste0("pSubCost", ii)]] <- .dat2par(
        obj@parameters[[paste0("pSubCost", ii)]],
        .interp_numpar(
          app@sub, tolower(ii), obj@parameters[[paste0("pSubCost", ii)]],
          approxim, "comm", app@comm
        )
      )
    }
  } else {
    stop("internal error ", whr)
  }
  obj
}


# ==============================================================================#
.null_to_empty_param <- function(pname, pp) {
  # pp - podInp@parameters
  # browser()
  # pp <- get(pp, envir = parent.frame())
  p <- get(pname, envir = parent.frame())
  if (is.null(p)) p <- pp[[pname]]@data[0, ]
  assign(pname, p, envir = parent.frame())
  # p
}

.n2e <- .null_to_empty_param

