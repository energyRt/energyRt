#### Constructor
# !!! optimize - rewrite using array - done
setMethod("initialize", "modInp-old", function(.Object) {
  x <- .Object@parameters
  # sets ####
  x[["region"]] <- newSet("region")
  x[["year"]] <- newSet("year")
  x[["slice"]] <- newSet("slice")
  x[["comm"]] <- newSet("comm")
  x[["sup"]] <- newSet("sup")
  x[["dem"]] <- newSet("dem")
  x[["tech"]] <- newSet("tech")
  x[["group"]] <- newSet("group")
  x[["stg"]] <- newSet("stg")
  x[["expp"]] <- newSet("expp")
  x[["imp"]] <- newSet("imp")
  x[["trade"]] <- newSet("trade")

  # weather ####
  x[["weather"]] <- newSet("weather")
  x[["pWeather"]] <-
    newParameter("pWeather", c("weather", "region", "year", "slice"),
                 "simple",
                 defVal = 1, interpolation = "back.inter.forth",
                 colName = "wval", cls = "weather"
    )
  x[["mWeatherSlice"]] <- newParameter("mWeatherSlice", c("weather", "slice"), "map")
  x[["mWeatherRegion"]] <- newParameter("mWeatherRegion", c("weather", "region"), "map")
  x[["mSupWeatherLo"]] <- newParameter("mSupWeatherLo", c("weather", "sup"), "map")
  x[["mSupWeatherUp"]] <- newParameter("mSupWeatherUp", c("weather", "sup"), "map")
  x[["mTechWeatherAfLo"]] <- newParameter("mTechWeatherAfLo", c("weather", "tech"), "map")
  x[["mTechWeatherAfUp"]] <- newParameter("mTechWeatherAfUp", c("weather", "tech"), "map")
  x[["mTechWeatherAfsLo"]] <- newParameter("mTechWeatherAfsLo", c("weather", "tech"), "map")
  x[["mTechWeatherAfsUp"]] <- newParameter("mTechWeatherAfsUp", c("weather", "tech"), "map")
  x[["mTechWeatherAfcLo"]] <- newParameter("mTechWeatherAfcLo", c("weather", "tech", "comm"), "map")
  x[["mTechWeatherAfcUp"]] <- newParameter("mTechWeatherAfcUp", c("weather", "tech", "comm"), "map")
  x[["mStorageWeatherAfLo"]] <- newParameter("mStorageWeatherAfLo", c("weather", "stg"), "map")
  x[["mStorageWeatherAfUp"]] <- newParameter("mStorageWeatherAfUp", c("weather", "stg"), "map")
  x[["mStorageWeatherCinpUp"]] <- newParameter("mStorageWeatherCinpUp", c("weather", "stg"), "map")
  x[["mStorageWeatherCinpLo"]] <- newParameter("mStorageWeatherCinpLo", c("weather", "stg"), "map")
  x[["mStorageWeatherCoutUp"]] <- newParameter("mStorageWeatherCoutUp", c("weather", "stg"), "map")
  x[["mStorageWeatherCoutLo"]] <- newParameter("mStorageWeatherCoutLo", c("weather", "stg"), "map")
  x[["pSupWeather"]] <-
    newParameter("pSupWeather", c("weather", "sup"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pTechWeatherAf"]] <-
    newParameter("pTechWeatherAf", c("weather", "tech"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pTechWeatherAfs"]] <-
    newParameter("pTechWeatherAfs", c("weather", "tech"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pTechWeatherAfc"]] <-
    newParameter("pTechWeatherAfc", c("weather", "tech", "comm"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pStorageWeatherAf"]] <-
    newParameter("pStorageWeatherAf", c("weather", "stg"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pStorageWeatherCinp"]] <-
    newParameter("pStorageWeatherCinp", c("weather", "stg"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["pStorageWeatherCout"]] <-
    newParameter("pStorageWeatherCout", c("weather", "stg"), "multi",
                 defVal = 1, interpolation = "back.inter.forth"
    )
  x[["mSliceNext"]] <- newParameter("mSliceNext", c("slice", "slicep"), "map")
  x[["mSliceFYearNext"]] <- newParameter("mSliceFYearNext", c("slice", "slicep"), "map")
  x[["mSameRegion"]] <- newParameter("mSameRegion", c("region", "regionp"), "map") # for glpk
  x[["mSameSlice"]] <- newParameter("mSameSlice", c("slice", "slicep"), "map") # for glpk
  x[["ordYear"]] <- newParameter("ordYear", "year", "simple",
                                 defVal = 0, interpolation = "inter.forth", colName = ""
  ) # for glpk
  x[["cardYear"]] <- newParameter("cardYear", "year", "simple",
                                  defVal = 0, interpolation = "inter.forth", colName = ""
  ) # for glpk
  x[["pPeriodLen"]] <- newParameter("pPeriodLen", "year", "simple",
                                    defVal = 0, interpolation = "inter.forth", colName = ""
  ) # for glpk
  # commodity ####
  ### mapping
  x[["mUpComm"]] <- newParameter("mUpComm", "comm", "map")
  x[["mLoComm"]] <- newParameter("mLoComm", "comm", "map")
  x[["mFxComm"]] <- newParameter("mFxComm", "comm", "map")
  # slice ####
  x[["mExpSlice"]] <- newParameter("mExpSlice", c("expp", "slice"), "map", cls = "export")
  x[["mImpSlice"]] <- newParameter("mImpSlice", c("imp", "slice"), "map", cls = "import")
  x[["mTechSlice"]] <- newParameter("mTechSlice", c("tech", "slice"), "map", cls = "technology")
  x[["mSupSlice"]] <- newParameter("mSupSlice", c("sup", "slice"), "map", cls = "supply")
  x[["mStorageFullYear"]] <-
    newParameter("mStorageFullYear", c("stg"), "map", cls = "storage")
  x[["mTradeSlice"]] <-
    newParameter("mTradeSlice", c("trade", "slice"), "map", cls = "trade")
  x[["mCommSlice"]] <-
    newParameter("mCommSlice", c("comm", "slice"), "map", cls = "commodity")
  x[["mCommSliceOrParent"]] <-
    newParameter("mCommSliceOrParent", c("comm", "slice", "slicep"),
                 "map",
                 cls = "commodity"
    )
  x[["mSliceParentChildE"]] <-
    newParameter("mSliceParentChildE", c("slice", "slicep"), "map")
  x[["mSliceParentChild"]] <-
    newParameter("mSliceParentChild", c("slice", "slicep"), "map")
  # simple
  x[["pSliceShare"]] <-
    newParameter("pSliceShare", "slice", "simple")
  x[["pEmissionFactor"]] <-
    newParameter("pEmissionFactor", c("comm", "commp"), "simple", # PPP
                 defVal = 0, interpolation = "back.inter.forth", cls = "commodity",
                 colName = "emis", slot = "emis"
    )
  x[["pAggregateFactor"]] <-
    newParameter("pAggregateFactor", c("comm", "commp"), "simple", # PPP
                 defVal = 0, interpolation = "back.inter.forth", cls = "commodity"
    ) # , colName = 'agg', slot = 'agg')
  # demand ####
  # mapping
  x[["mDemComm"]] <-
    newParameter("mDemComm", c("dem", "comm"), "map", cls = "demand")
  x[["pDemand"]] <-
    newParameter("pDemand", c("dem", "comm", "region", "year", "slice"),
                 "simple",
                 defVal = 0, interpolation = "back.inter.forth",
                 colName = "dem", cls = "demand", slot = "dem"
    )
  # dummy import ####
  x[["pDummyImportCost"]] <-
    newParameter("pDummyImportCost", c("comm", "region", "year", "slice"),
                 "simple",
                 defVal = Inf, interpolation = "back.inter.forth",
                 colName = "dummyImport", cls = "sysInfo", slot = "debug"
    )
  # dummy export ####
  x[["pDummyExportCost"]] <-
    newParameter("pDummyExportCost", c("comm", "region", "year", "slice"),
                 "simple",
                 defVal = Inf, interpolation = "back.inter.forth",
                 colName = "dummyExport", cls = "sysInfo", slot = "debug"
    )
  for (ii in c("Inp", "Out", "Bal")) {
    # tax ####
    x[[paste0("pTaxCost", ii)]] <-
      newParameter(paste0("pTaxCost", ii), c("comm", "region", "year", "slice"), "simple",
                   defVal = 0, interpolation = "inter.forth", colName = "value"
      ) # , cls = 'tax', slot = 'tax')
    # subsidy ####
    x[[paste0("pSubCost", ii)]] <-
      newParameter(paste0("pSubCost", ii), c("comm", "region", "year", "slice"), "simple",
                   defVal = 0, interpolation = "inter.forth", colName = "value"
      ) # , cls = 'sub', slot = 'subs')
  }
  # supply ####
  # mapping
  x[["mSupComm"]] <-
    newParameter("mSupComm", c("sup", "comm"), "map", cls = "supply")
  x[["mSupSpan"]] <-
    newParameter("mSupSpan", c("sup", "region"), "map")
  x[["mvSupCost"]] <-
    newParameter("mvSupCost", c("sup", "region", "year"), "map")
  # simple parameters
  x[["pSupCost"]] <-
    newParameter("pSupCost", c("sup", "comm", "region", "year", "slice"),
                 "simple",
                 defVal = 0, interpolation = "back.inter.forth",
                 colName = "cost", cls = "supply", slot = "availability"
    )
  x[["pSupReserve"]] <-
    newParameter("pSupReserve", c("sup", "comm", "region"), "multi",
                 defVal = c(0, Inf),
                 interpolation = "back.inter.forth",
                 cls = "supply",
                 slot = "reserve", colName = c("res.lo", "res.up")
    )
  # multi parameters
  x[["pSupAva"]] <-
    newParameter("pSupAva", c("sup", "comm", "region", "year", "slice"),
                 "multi",
                 defVal = c(0, Inf), interpolation = "back.inter.forth",
                 colName = c("ava.lo", "ava.up"), cls = "supply", slot = "availability"
    )
  # technology ####
  # mapping
  for (i in c(
    "mTechInpComm", "mTechOutComm", "mTechOneComm",
    "mTechAInp", "mTechAOut"
  )) {
    x[[i]] <- newParameter(i, c("tech", "comm"),
                           "map",
                           cls = "technology"
    )
  }
  for (i in c("mTechInpGroup", "mTechOutGroup")) {
    x[[i]] <- newParameter(i, c("tech", "group"),
                           "map",
                           cls = "technology"
    )
  }
  x[["mTechGroupComm"]] <-
    newParameter("mTechGroupComm", c("tech", "group", "comm"),
                 "map",
                 cls = "technology"
    )
  x[["mTechUpgrade"]] <-
    newParameter("mTechUpgrade", c("tech", "techp"), "map", cls = "technology")
  x[["mTechRetirement"]] <-
    newParameter("mTechRetirement", c("tech"), "map", cls = "technology")
  # For disable technology with unexceptable start year
  x[["mTechNew"]] <- newParameter("mTechNew", c("tech", "region", "year"),
                                  "map",
                                  cls = "technology"
  )
  x[["mTechInv"]] <- newParameter("mTechInv", c("tech", "region", "year"), "map", cls = "technology")
  x[["mTechSpan"]] <- newParameter("mTechSpan", c("tech", "region", "year"), "map", cls = "technology")
  x[["meqTechRetiredNewCap"]] <- newParameter("meqTechRetiredNewCap", c("tech", "region", "year"), "map", cls = "technology")
  x[["mTechOMCost"]] <- newParameter("mTechOMCost", c("tech", "region", "year"), "map", cls = "technology")
  x[["mTechEac"]] <- newParameter("mTechEac", c("tech", "region", "year"), "map", cls = "technology")

  x[["mTechAct2AInp"]] <- newParameter("mTechAct2AInp",
                                       c("tech", "comm", "region", "year", "slice"),
                                       "map",
                                       cls = "technology")
  x[["mTechCap2AInp"]] <- newParameter("mTechCap2AInp", c("tech", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechNCap2AInp"]] <- newParameter("mTechNCap2AInp", c("tech", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechCinp2AInp"]] <- newParameter("mTechCinp2AInp", c("tech", "comm", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechCout2AInp"]] <- newParameter("mTechCout2AInp", c("tech", "comm", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechAct2AOut"]] <- newParameter("mTechAct2AOut", c("tech", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechCap2AOut"]] <- newParameter("mTechCap2AOut", c("tech", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechNCap2AOut"]] <- newParameter("mTechNCap2AOut", c("tech", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechCinp2AOut"]] <- newParameter("mTechCinp2AOut", c("tech", "comm", "comm", "region", "year", "slice"), "map", cls = "technology")
  x[["mTechCout2AOut"]] <- newParameter("mTechCout2AOut", c("tech", "comm", "comm", "region", "year", "slice"), "map", cls = "technology")

  # simple & multi
  x[["pTechCap2act"]] <-
    newParameter("pTechCap2act", "tech", "simple",
                 defVal = 1, interpolation = "back.inter.forth", cls = "technology"
    ) # , colName = 'cap2act', slot = 'cap2act')
  x[["pTechEac"]] <-
    newParameter("pTechEac", c("tech", "region", "year"), "simple",
                 defVal = 0, interpolation = "back.inter.forth", cls = "technology", colName = "invcost"
    )
  x[["pTechEmisComm"]] <- newParameter("pTechEmisComm", c("tech", "comm"), "simple",
                                       defVal = 1, cls = "technology", colName = "combustion"
  )
  x[["pTechOlife"]] <-
    newParameter("pTechOlife", c("tech", "region"), "simple",
                 defVal = 1, interpolation = "back.inter.forth", colName = "olife", cls = "technology", slot = "cap2act"
    )
  x[["pTechFixom"]] <- newParameter("pTechFixom",
                                    c("tech", "region", "year"), "simple",
                                    defVal = 0, interpolation = "back.inter.forth", colName = "fixom", cls = "technology"
  )
  x[["pTechInvcost"]] <- newParameter("pTechInvcost",
                                      c("tech", "region", "year"), "simple",
                                      defVal = 0, interpolation = "back.inter.forth", colName = "invcost", cls = "technology"
  )
  x[["pTechStock"]] <- newParameter("pTechStock",
                                    c("tech", "region", "year"), "simple",
                                    defVal = 0, interpolation = "back.inter.forth", colName = "stock", cls = "technology"
  )
  x[["pTechVarom"]] <- newParameter("pTechVarom",
                                    c("tech", "region", "year", "slice"), "simple",
                                    defVal = 0, interpolation = "back.inter.forth", colName = "varom", cls = "technology"
  )
  #
  x[["pTechAf"]] <-
    newParameter("pTechAf", c("tech", "region", "year", "slice"), "multi",
                 defVal = c(0, 1),
                 interpolation = "back.inter.forth", colName = c("af.lo", "af.up"), cls = "technology"
    )
  #
  x[["pTechRampUp"]] <-
    newParameter("pTechRampUp", c("tech", "region", "year", "slice"), "simple",
                 defVal = Inf,
                 interpolation = "back.inter.forth", colName = "rampup", cls = "technology"
    )
  x[["pTechRampDown"]] <-
    newParameter("pTechRampDown", c("tech", "region", "year", "slice"), "simple",
                 defVal = Inf,
                 interpolation = "back.inter.forth", colName = "rampdown", cls = "technology"
    )
  #
  x[["pTechAfs"]] <-
    newParameter("pTechAfs", c("tech", "region", "year", "slice"), "multi",
                 defVal = c(0, 0),
                 interpolation = "back.inter.forth", colName = c("afs.lo", "afs.up"), cls = "technology"
    )
  x[["pTechGinp2use"]] <- newParameter("pTechGinp2use",
                                       c("tech", "group", "region", "year", "slice"), "simple",
                                       defVal = 1, interpolation = "back.inter.forth", colName = "ginp2use", cls = "technology"
  )
  x[["pTechCinp2ginp"]] <- newParameter("pTechCinp2ginp",
                                        c("tech", "comm", "region", "year", "slice"), "simple",
                                        defVal = 1, interpolation = "back.inter.forth", colName = "cinp2ginp", cls = "technology"
  )
  x[["pTechUse2cact"]] <- newParameter("pTechUse2cact",
                                       c("tech", "comm", "region", "year", "slice"), "simple",
                                       defVal = 1, interpolation = "back.inter.forth", colName = "use2cact", cls = "technology"
  )
  # auxiliary commodity ####
  x[["pTechAct2AInp"]] <- newParameter("pTechAct2AInp",
                                       c("tech", "acomm", "region", "year", "slice"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "act2ainp", cls = "technology"
  )
  x[["pTechCap2AInp"]] <- newParameter("pTechCap2AInp",
                                       c("tech", "acomm", "region", "year", "slice"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "cap2ainp", cls = "technology"
  )
  x[["pTechAct2AOut"]] <- newParameter("pTechAct2AOut",
                                       c("tech", "acomm", "region", "year", "slice"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "act2aout", cls = "technology"
  )
  x[["pTechCap2AOut"]] <- newParameter("pTechCap2AOut",
                                       c("tech", "acomm", "region", "year", "slice"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "cap2aout", cls = "technology"
  )

  x[["pTechNCap2AInp"]] <- newParameter("pTechNCap2AInp",
                                        c("tech", "acomm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cap2aout", cls = "technology"
  )
  x[["pTechNCap2AOut"]] <- newParameter("pTechNCap2AOut",
                                        c("tech", "acomm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cap2aout", cls = "technology"
  )

  x[["pTechCinp2AInp"]] <- newParameter("pTechCinp2AInp",
                                        c("tech", "acomm", "comm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cinp2ainp", cls = "technology"
  )
  x[["pTechCout2AInp"]] <- newParameter("pTechCout2AInp",
                                        c("tech", "acomm", "comm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cout2ainp", cls = "technology"
  )
  x[["pTechCinp2AOut"]] <- newParameter("pTechCinp2AOut",
                                        c("tech", "acomm", "comm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cinp2aout", cls = "technology"
  )
  x[["pTechCout2AOut"]] <- newParameter("pTechCout2AOut",
                                        c("tech", "acomm", "comm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", colName = "cout2aout", cls = "technology"
  )

  # Aux stop
  x[["pTechCact2cout"]] <- newParameter("pTechCact2cout",
                                        c("tech", "comm", "region", "year", "slice"), "simple",
                                        defVal = 1, interpolation = "back.inter.forth", colName = "cact2cout", cls = "technology"
  )
  x[["pTechCinp2use"]] <- newParameter("pTechCinp2use",
                                       c("tech", "comm", "region", "year", "slice"), "simple",
                                       defVal = 1, interpolation = "back.inter.forth", colName = "cinp2use", cls = "technology"
  )
  x[["pTechCvarom"]] <- newParameter("pTechCvarom",
                                     c("tech", "comm", "region", "year", "slice"), "simple",
                                     defVal = 0, interpolation = "back.inter.forth", colName = "cvarom", cls = "technology"
  )
  x[["pTechAvarom"]] <- newParameter("pTechAvarom",
                                     c("tech", "acomm", "region", "year", "slice"), "simple",
                                     defVal = 0, interpolation = "back.inter.forth", colName = "avarom", cls = "technology"
  )
  x[["pTechShare"]] <- newParameter("pTechShare",
                                    c("tech", "comm", "region", "year", "slice"), "multi",
                                    defVal = c(0, 1), interpolation = "back.inter.forth",
                                    colName = c("share.lo", "share.up"), cls = "technology"
  )
  x[["pTechAfc"]] <- newParameter("pTechAfc", c("tech", "comm", "region", "year", "slice"), "multi",
                                  defVal = c(0, Inf), interpolation = "back.inter.forth", colName = c("afc.lo", "afc.up"), cls = "technology"
  )

  ## !!! SET ALIAS FOR SYS INFO
  # reserve ####
  x[["mStorageComm"]] <- newParameter("mStorageComm", c("stg", "comm"), "map")
  # simple & multi
  x[["pStorageOlife"]] <- newParameter("pStorageOlife",
                                       c("stg", "region"), "simple",
                                       defVal = 1, interpolation = "back.inter.forth", colName = "olife", cls = "storage"
  )
  x[["pStorageStock"]] <- newParameter("pStorageStock", c("stg", "region", "year"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "stock", cls = "storage"
  )
  x[["pStorageFixom"]] <- newParameter("pStorageFixom", c("stg", "region", "year"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "fixom", cls = "storage"
  )
  x[["pStorageInvcost"]] <- newParameter("pStorageInvcost", c("stg", "region", "year"), "simple",
                                         defVal = 0, interpolation = "back.inter.forth", colName = "invcost", cls = "storage"
  )
  x[["pStorageEac"]] <- newParameter("pStorageEac", c("stg", "region", "year"), "simple",
                                     defVal = 0, interpolation = "back.inter.forth", colName = "invcost", cls = "storage"
  )

  x[["pStorageInpEff"]] <- newParameter("pStorageInpEff", c("stg", "comm", "region", "year", "slice"), "simple",
                                        defVal = 1, interpolation = "back.inter.forth", colName = "inpeff", cls = "storage"
  )
  x[["pStorageOutEff"]] <- newParameter("pStorageOutEff", c("stg", "comm", "region", "year", "slice"), "simple",
                                        defVal = 1, interpolation = "back.inter.forth", colName = "outeff", cls = "storage"
  )
  x[["pStorageStgEff"]] <- newParameter("pStorageStgEff", c("stg", "comm", "region", "year", "slice"), "simple",
                                        defVal = 1, interpolation = "back.inter.forth", colName = "stgeff", cls = "storage"
  )

  x[["pStorageCostStore"]] <- newParameter("pStorageCostStore", c("stg", "region", "year", "slice"), "simple",
                                           defVal = 0, interpolation = "back.inter.forth", colName = "stgcost", cls = "storage"
  )
  x[["pStorageCostInp"]] <- newParameter("pStorageCostInp", c("stg", "region", "year", "slice"), "simple",
                                         defVal = 0, interpolation = "back.inter.forth", colName = "inpcost", cls = "storage"
  )
  x[["pStorageCostOut"]] <- newParameter("pStorageCostOut", c("stg", "region", "year", "slice"), "simple",
                                         defVal = 0, interpolation = "back.inter.forth", colName = "outcost", cls = "storage"
  )

  x[["pStorageAf"]] <- newParameter("pStorageAf", c("stg", "region", "year", "slice"), "multi",
                                    defVal = c(0, 1), interpolation = "back.inter.forth", colName = c("af.lo", "af.up"), cls = "storage"
  )

  x[["pStorageCap2stg"]] <- newParameter("pStorageCap2stg", "stg", "simple",
                                         defVal = 1, interpolation = "back.inter.forth", cls = "storage"
  ) # , colName = 'cap2stg', slot = 'cap2stg')
  x[["pStorageCinp"]] <- newParameter("pStorageCinp", c("stg", "comm", "region", "year", "slice"), "multi",
                                      defVal = c(0, -1), interpolation = "back.inter.forth", cls = "storage", colName = c("cinp.lo", "cinp.up"), slot = "af"
  )
  x[["pStorageCout"]] <- newParameter("pStorageCout", c("stg", "comm", "region", "year", "slice"), "multi",
                                      defVal = c(0, -1), interpolation = "back.inter.forth", cls = "storage", colName = c("cout.lo", "cout.up"), slot = "af"
  )
  x[["mStorageNew"]] <- newParameter("mStorageNew", c("stg", "region", "year"), "map")
  x[["mStorageSpan"]] <- newParameter("mStorageSpan", c("stg", "region", "year"), "map")
  x[["mStorageEac"]] <- newParameter("mStorageEac", c("stg", "region", "year"), "map")
  x[["mStorageOMCost"]] <- newParameter("mStorageOMCost", c("stg", "region", "year"), "map")
  x[["mStorageAInp"]] <- newParameter("mStorageAInp", c("stg", "comm"), "map", cls = "storage")
  x[["mStorageAOut"]] <- newParameter("mStorageAOut", c("stg", "comm"), "map", cls = "storage")
  stg_tmp <- c(
    "pStorageStg2AInp" = "stg2ainp", "pStorageStg2AOut" = "stg2aout", "pStorageCinp2AInp" = "cinp2ainp", "pStorageCinp2AOut" = "cinp2aout",
    "pStorageCout2AInp" = "cout2ainp",
    "pStorageCout2AOut" = "cout2aout", "pStorageCap2AInp" = "cap2ainp", "pStorageCap2AOut" = "cap2aout", "pStorageNCap2AInp" = "ncap2ainp", "pStorageNCap2AOut" = "ncap2aout"
  )
  for (i in c(
    "pStorageStg2AInp", "pStorageStg2AOut", "pStorageCinp2AInp", "pStorageCinp2AOut",
    "pStorageCout2AInp", "pStorageCout2AOut", "pStorageCap2AInp", "pStorageCap2AOut",
    "pStorageNCap2AInp", "pStorageNCap2AOut"
  )) {
    x[[i]] <- newParameter(i, c("stg", "acomm", "region", "year", "slice"), "simple",
                           defVal = 0, interpolation = "back.inter.forth", cls = "storage", colName = stg_tmp[i]
    )
  }
  x[["pStorageNCap2Stg"]] <- newParameter("pStorageNCap2Stg",
                                          c("stg", "comm", "region", "year", "slice"), "simple",
                                          defVal = 0, interpolation = "", cls = "storage", colName = "ncap2stg"
  )
  x[["pStorageCharge"]] <- newParameter("pStorageCharge",
                                        c("stg", "comm", "region", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "", cls = "storage", colName = "charge"
  )
  for (i in c(
    "mStorageStg2AOut", "mStorageCinp2AOut", "mStorageCout2AOut", "mStorageCap2AOut", "mStorageNCap2AOut", "mStorageStg2AInp", "mStorageCinp2AInp",
    "mStorageCout2AInp", "mStorageCap2AInp", "mStorageNCap2AInp"
  )) {
    x[[i]] <- newParameter(i, c("stg", "comm", "region", "year", "slice"), "map", cls = "storage")
  }


  # trade ####
  # mapping
  x[["mTradeIrAInp"]] <- newParameter("mTradeIrAInp", c("trade", "comm"), "map", cls = "trade")
  x[["mTradeIrAOut"]] <- newParameter("mTradeIrAOut", c("trade", "comm"), "map", cls = "trade")
  x[["mExpComm"]] <-
    newParameter("mExpComm", c("expp", "comm"), "map", cls = "trade")
  x[["mImpComm"]] <-
    newParameter("mImpComm", c("imp", "comm"), "map", cls = "trade")
  x[["mTradeComm"]] <-
    newParameter("mTradeComm", c("trade", "comm"), "map", cls = "trade")
  drt1 <- c("pTradeIrCsrc2Aout", "pTradeIrCsrc2Ainp", "pTradeIrCdst2Aout", "pTradeIrCdst2Ainp")
  drt2 <- c("csrc2aout", "csrc2ainp", "cdst2aout", "cdst2ainp")
  for (i in seq_along(drt1)) {
    x[[drt1[i]]] <- newParameter(drt1[i], c("trade", "acomm", "src", "dst", "year", "slice"), "simple",
                                 defVal = 0, interpolation = "back.inter.forth", cls = "trade", colName = drt2[i]
    )
  }

  x[["pTradeIrCost"]] <- newParameter("pTradeIrCost",
                                      c("trade", "src", "dst", "year", "slice"), "simple",
                                      defVal = 0, interpolation = "back.inter.forth", cls = "trade", colName = "cost"
  )
  x[["pTradeIrEff"]] <- newParameter("pTradeIrEff",
                                     c("trade", "src", "dst", "year", "slice"), "simple",
                                     defVal = 1, interpolation = "back.inter.forth", cls = "trade", colName = "teff"
  )
  x[["pTradeIrMarkup"]] <- newParameter("pTradeIrMarkup",
                                        c("trade", "src", "dst", "year", "slice"), "simple",
                                        defVal = 0, interpolation = "back.inter.forth", cls = "trade", colName = "markup"
  )
  x[["pExportRowPrice"]] <- newParameter("pExportRowPrice",
                                         c("expp", "region", "year", "slice"), "simple",
                                         defVal = 0, interpolation = "back.inter.forth", cls = "export", colName = "price"
  )
  x[["pImportRowPrice"]] <- newParameter("pImportRowPrice",
                                         c("imp", "region", "year", "slice"), "simple",
                                         defVal = 0, interpolation = "back.inter.forth", cls = "import", colName = "price"
  )
  x[["pTradeIr"]] <- newParameter("pTradeIr",
                                  c("trade", "src", "dst", "year", "slice"), "multi",
                                  defVal = c(0, Inf), interpolation = "back.inter.forth", cls = "trade", colName = c("ava.lo", "ava.up")
  )
  x[["pExportRow"]] <- newParameter("pExportRow",
                                    c("expp", "region", "year", "slice"), "multi",
                                    defVal = c(0, Inf), interpolation = "back.inter.forth", cls = "export", colName = c("exp.lo", "exp.up")
  )
  x[["pImportRow"]] <- newParameter("pImportRow",
                                    c("imp", "region", "year", "slice"), "multi",
                                    defVal = c(0, Inf), interpolation = "back.inter.forth", cls = "import", colName = c("imp.lo", "imp.up")
  )
  x[["pExportRowRes"]] <- newParameter("pExportRowRes",
                                       "expp", "simple",
                                       defVal = 0, interpolation = "back.inter.forth"
  ) # , cls = 'export', slot = 'reserve', colName = 'reserve')
  x[["pImportRowRes"]] <- newParameter("pImportRowRes", "imp", "simple", defVal = 0, interpolation = "back.inter.forth") # , cls = 'import', slot = 'reserve', colName = 'reserve')
  # For LEC
  x[["mLECRegion"]] <- newParameter("mLECRegion", "region", "map")
  x[["pLECLoACT"]] <-
    newParameter("pLECLoACT", "region", "simple",
                 defVal = 0, interpolation = "back.inter.forth"
    )


  # other/system ####
  # !!! year fraction ####
  # !!! (experimental - for sample of time-slices)
  x[["pYearFraction"]] <-
    newParameter("pYearFraction", "year", "simple",
                 # newParameter('pYearFraction', character(0), 'simple',
                 defVal = 1.,
                 interpolation = "back.inter.forth",
                 colName = "fraction",
                 cls = "sysInfo"
    )
  # discount ####
  x[["pDiscount"]] <-
    newParameter("pDiscount", c("region", "year"), "simple",
                 defVal = .1, interpolation = "back.inter.forth", colName = "discount", cls = "sysInfo"
    )
  # Additional for compatibility
  x[["pDiscountFactor"]] <- newParameter("pDiscountFactor", c("region", "year"), "simple")
  x[["pDiscountFactorMileStone"]] <- newParameter("pDiscountFactorMileStone", c("region", "year"), "simple")

  x[["mDiscountZero"]] <- newParameter("mDiscountZero", "region", "map", defVal = 1)
  ## milestone set ####
  x[["mMidMilestone"]] <- newParameter("mMidMilestone", "year", "map", defVal = 1)
  x[["mMilestoneHasNext"]] <- newParameter("mMilestoneHasNext", "year", "map", defVal = 1)
  x[["mMilestoneFirst"]] <- newParameter("mMilestoneFirst", "year", "map", defVal = 1)
  x[["mMilestoneLast"]] <- newParameter("mMilestoneLast", "year", "map", defVal = 1)
  x[["mStartMilestone"]] <- newParameter("mStartMilestone", c("year", "yearp"), "map", defVal = 1)
  x[["mEndMilestone"]] <- newParameter("mEndMilestone", c("year", "yearp"), "map", defVal = 1)
  x[["mMilestoneNext"]] <- newParameter("mMilestoneNext", c("year", "yearp"), "map", defVal = 1)
  ## mapping ####
  x[["mTechInpTot"]] <- newParameter("mTechInpTot", c("comm", "region", "year", "slice"), "map")
  x[["mTechOutTot"]] <- newParameter("mTechOutTot", c("comm", "region", "year", "slice"), "map")
  x[["mEmsFuelTot"]] <- newParameter("mEmsFuelTot", c("comm", "region", "year", "slice"), "map")
  x[["mTechEmsFuel"]] <- newParameter("mTechEmsFuel", c("tech", "comm", "comm", "region", "year", "slice"), "map")
  x[["mAggregateFactor"]] <- newParameter("mAggregateFactor", c("comm", "comm"), "map")
  x[["mDummyImport"]] <- newParameter("mDummyImport", c("comm", "region", "year", "slice"), "map")
  x[["mDummyExport"]] <- newParameter("mDummyExport", c("comm", "region", "year", "slice"), "map")
  x[["mDummyCost"]] <- newParameter("mDummyCost", c("comm", "region", "year"), "map")
  x[["mTradeIr"]] <- newParameter("mTradeIr", c("trade", "src", "dst", "year", "slice"), "map")
  x[["mvTradeIrAInp"]] <- newParameter("mvTradeIrAInp", c("trade", "comm", "region", "year", "slice"), "map")
  x[["mvTradeIrAOut"]] <- newParameter("mvTradeIrAOut", c("trade", "comm", "region", "year", "slice"), "map")
  x[["mvTradeIrAInpTot"]] <- newParameter("mvTradeIrAInpTot", c("comm", "region", "year", "slice"), "map")
  x[["mvTradeIrAOutTot"]] <- newParameter("mvTradeIrAOutTot", c("comm", "region", "year", "slice"), "map")

  x[["mTradeIrCsrc2Ainp"]] <- newParameter("mTradeIrCsrc2Ainp", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["mTradeIrCdst2Ainp"]] <- newParameter("mTradeIrCdst2Ainp", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["mTradeIrCsrc2Aout"]] <- newParameter("mTradeIrCsrc2Aout", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["mTradeIrCdst2Aout"]] <- newParameter("mTradeIrCdst2Aout", c("trade", "comm", "src", "dst", "year", "slice"), "map")

  x[["mImportRow"]] <- newParameter("mImportRow", c("imp", "comm", "region", "year", "slice"), "map")
  x[["mExportRow"]] <- newParameter("mExportRow", c("expp", "comm", "region", "year", "slice"), "map")
  x[["mImportRowUp"]] <- newParameter("mImportRowUp", c("imp", "comm", "region", "year", "slice"), "map")
  x[["mExportRowUp"]] <- newParameter("mExportRowUp", c("expp", "comm", "region", "year", "slice"), "map")
  x[["mImportRowAccumulatedUp"]] <- newParameter("mImportRowAccumulatedUp", c("imp", "comm"), "map")
  x[["mExportRowAccumulatedUp"]] <- newParameter("mExportRowAccumulatedUp", c("expp", "comm"), "map")

  x[["mExport"]] <- newParameter("mExport", c("comm", "region", "year", "slice"), "map")
  x[["mImport"]] <- newParameter("mImport", c("comm", "region", "year", "slice"), "map")

  x[["mStorageInpTot"]] <- newParameter("mStorageInpTot", c("comm", "region", "year", "slice"), "map")
  x[["mStorageOutTot"]] <- newParameter("mStorageOutTot", c("comm", "region", "year", "slice"), "map")

  x[["mTaxCost"]] <- newParameter("mTaxCost", c("comm", "region", "year"), "map")
  x[["mSubCost"]] <- newParameter("mSubCost", c("comm", "region", "year"), "map")
  x[["mAggOut"]] <- newParameter("mAggOut", c("comm", "region", "year", "slice"), "map")

  x[["mSupOutTot"]] <- newParameter("mSupOutTot", c("comm", "region", "year", "slice"), "map")
  x[["mSupAvaUp"]] <- newParameter("mSupAvaUp", c("sup", "comm", "region", "year", "slice"), "map")
  x[["mSupAva"]] <- newParameter("mSupAva", c("sup", "comm", "region", "year", "slice"), "map")
  x[["mSupReserveUp"]] <- newParameter("mSupReserveUp", c("sup", "comm", "region"), "map")

  x[["mTechAfUp"]] <- newParameter("mTechAfUp", c("tech", "region", "year", "slice"), "map")
  x[["mTechAfcUp"]] <- newParameter("mTechAfcUp", c("tech", "comm", "region", "year", "slice"), "map")
  x[["mTechOlifeInf"]] <- newParameter("mTechOlifeInf", c("tech", "region"), "map")
  x[["mStorageOlifeInf"]] <- newParameter("mStorageOlifeInf", c("stg", "region"), "map")

  x[["mInp2Lo"]] <- newParameter("mInp2Lo", c("comm", "region", "year", "slice"), "map")
  x[["mOut2Lo"]] <- newParameter("mOut2Lo", c("comm", "region", "year", "slice"), "map")

  x[["mTechRampUp"]] <- newParameter("mTechRampUp", c("tech", "region", "year", "slice"), "map")
  x[["mTechRampDown"]] <- newParameter("mTechRampDown", c("tech", "region", "year", "slice"), "map")
  x[["mTechFullYear"]] <- newParameter("mTechFullYear", c("tech"), "map", cls = "technology")

  # trade capacity data ####
  # To start year
  x[["mTradeSpan"]] <- newParameter("mTradeSpan", c("trade", "year"), "map", cls = "trade")
  x[["mTradeNew"]] <- newParameter("mTradeNew", c("trade", "year"), "map", cls = "trade")
  x[["mTradeOlifeInf"]] <- newParameter("mTradeOlifeInf", c("trade"), "map", cls = "trade")
  x[["mTradeCapacityVariable"]] <- newParameter("mTradeCapacityVariable", "trade", "map", cls = "trade")
  x[["mTradeRoutes"]] <- newParameter("mTradeRoutes", c("trade", "src", "dst"), "map", cls = "trade")
  x[["mTradeInv"]] <- newParameter("mTradeInv", c("trade", "region", "year"), "map", cls = "trade")
  x[["mTradeEac"]] <- newParameter("mTradeEac", c("trade", "region", "year"), "map", cls = "trade")

  x[["pTradeStock"]] <- newParameter("pTradeStock", c("trade", "year"), "simple",
                                     defVal = 0, interpolation = "back.inter.forth", colName = "stock", cls = "trade"
  )
  x[["pTradeOlife"]] <- newParameter("pTradeOlife", "trade", "simple",
                                     defVal = 0, interpolation = "back.inter.forth", colName = "olife", cls = "trade"
  )
  x[["pTradeInvcost"]] <- newParameter("pTradeInvcost", c("trade", "region", "year"), "simple",
                                       defVal = 0, interpolation = "back.inter.forth", colName = "invcost", cls = "trade"
  )
  x[["pTradeEac"]] <- newParameter("pTradeEac",
                                   c("trade", "region", "year"), "simple",
                                   defVal = 0, interpolation = "back.inter.forth", colName = "invcost", cls = "trade"
  )

  x[["pTradeCap2Act"]] <- newParameter("pTradeCap2Act", "trade", "simple",
                                       defVal = 1, interpolation = "back.inter.forth", cls = "trade", colName = "cap2act", slot = "cap2act"
  )

  # mv mapping for variables ####
  x[["mvSupReserve"]] <- newParameter("mvSupReserve", c("sup", "comm", "region"), "map")
  x[["mvTechRetiredNewCap"]] <- newParameter("mvTechRetiredNewCap", c("tech", "region", "year", "year"), "map")
  x[["mvTechRetiredStock"]] <- newParameter("mvTechRetiredStock", c("tech", "region", "year"), "map")
  x[["mvTechAct"]] <- newParameter("mvTechAct", c("tech", "region", "year", "slice"), "map")
  x[["mvTechInp"]] <- newParameter("mvTechInp", c("tech", "comm", "region", "year", "slice"), "map")
  x[["mvTechOut"]] <- newParameter("mvTechOut", c("tech", "comm", "region", "year", "slice"), "map")
  x[["mvTechAInp"]] <- newParameter("mvTechAInp", c("tech", "comm", "region", "year", "slice"), "map")
  x[["mvTechAOut"]] <- newParameter("mvTechAOut", c("tech", "comm", "region", "year", "slice"), "map")
  x[["mvDemInp"]] <- newParameter("mvDemInp", c("comm", "region", "year", "slice"), "map")
  x[["mvBalance"]] <- newParameter("mvBalance", c("comm", "region", "year", "slice"), "map")
  x[["mvInpTot"]] <- newParameter("mvInpTot", c("comm", "region", "year", "slice"), "map")
  x[["mvOutTot"]] <- newParameter("mvOutTot", c("comm", "region", "year", "slice"), "map")

  x[["mvInp2Lo"]] <- newParameter("mvInp2Lo", c("comm", "region", "year", "slice", "slice"), "map")
  x[["mvOut2Lo"]] <- newParameter("mvOut2Lo", c("comm", "region", "year", "slice", "slice"), "map")
  x[["mInpSub"]] <- newParameter("mInpSub", c("comm", "region", "year", "slice"), "map")
  x[["mOutSub"]] <- newParameter("mOutSub", c("comm", "region", "year", "slice"), "map")
  x[["mvStorageAInp"]] <- newParameter("mvStorageAInp", c("stg", "comm", "region", "year", "slice"), "map")
  x[["mvStorageAOut"]] <- newParameter("mvStorageAOut", c("stg", "comm", "region", "year", "slice"), "map")


  x[["mvStorageStore"]] <- newParameter("mvStorageStore", c("stg", "comm", "region", "year", "slice"), "map")
  x[["mvTradeIr"]] <- newParameter("mvTradeIr", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["mvTradeCost"]] <- newParameter("mvTradeCost", c("region", "year"), "map")

  x[["mvTradeCost"]] <- newParameter("mvTradeCost", c("region", "year"), "map")
  x[["mvTradeRowCost"]] <- newParameter("mvTradeRowCost", c("region", "year"), "map")
  x[["mvTradeIrCost"]] <- newParameter("mvTradeIrCost", c("region", "year"), "map")
  x[["mvTotalCost"]] <- newParameter("mvTotalCost", c("region", "year"), "map")
  x[["mvTotalUserCosts"]] <- newParameter("mvTotalUserCosts", c("region", "year"), "map")

  # me - mapping for equations ####
  x[["meqTechSng2Sng"]] <- newParameter("meqTechSng2Sng", c("tech", "region", "comm", "comm", "year", "slice"), "map")
  x[["meqTechGrp2Sng"]] <- newParameter("meqTechGrp2Sng", c("tech", "region", "group", "comm", "year", "slice"), "map")
  x[["meqTechSng2Grp"]] <- newParameter("meqTechSng2Grp", c("tech", "region", "comm", "group", "year", "slice"), "map")
  x[["meqTechGrp2Grp"]] <- newParameter("meqTechGrp2Grp", c("tech", "region", "group", "group", "year", "slice"), "map")
  x[["meqTechShareInpLo"]] <- newParameter("meqTechShareInpLo", c("tech", "region", "group", "comm", "year", "slice"), "map")
  x[["meqTechShareInpUp"]] <- newParameter("meqTechShareInpUp", c("tech", "region", "group", "comm", "year", "slice"), "map")
  x[["meqTechShareOutLo"]] <- newParameter("meqTechShareOutLo", c("tech", "region", "group", "comm", "year", "slice"), "map")
  x[["meqTechShareOutUp"]] <- newParameter("meqTechShareOutUp", c("tech", "region", "group", "comm", "year", "slice"), "map")
  x[["meqTechAfLo"]] <- newParameter("meqTechAfLo", c("tech", "region", "year", "slice"), "map")
  x[["meqTechAfUp"]] <- newParameter("meqTechAfUp", c("tech", "region", "year", "slice"), "map")
  x[["meqTechAfsLo"]] <- newParameter("meqTechAfsLo", c("tech", "region", "year", "slice"), "map")
  x[["meqTechAfsUp"]] <- newParameter("meqTechAfsUp", c("tech", "region", "year", "slice"), "map")
  x[["meqTechActSng"]] <- newParameter("meqTechActSng", c("tech", "comm", "region", "year", "slice"), "map")
  x[["meqTechActGrp"]] <- newParameter("meqTechActGrp", c("tech", "group", "region", "year", "slice"), "map")
  x[["meqTechAfcOutLo"]] <- newParameter("meqTechAfcOutLo", c("tech", "region", "comm", "year", "slice"), "map")
  x[["meqTechAfcOutUp"]] <- newParameter("meqTechAfcOutUp", c("tech", "region", "comm", "year", "slice"), "map")
  x[["meqTechAfcInpLo"]] <- newParameter("meqTechAfcInpLo", c("tech", "region", "comm", "year", "slice"), "map")
  x[["meqTechAfcInpUp"]] <- newParameter("meqTechAfcInpUp", c("tech", "region", "comm", "year", "slice"), "map")
  x[["meqSupAvaLo"]] <- newParameter("meqSupAvaLo", c("sup", "comm", "region", "year", "slice"), "map")
  x[["meqSupReserveLo"]] <- newParameter("meqSupReserveLo", c("sup", "comm", "region"), "map")
  x[["meqStorageAfLo"]] <- newParameter("meqStorageAfLo", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqStorageAfUp"]] <- newParameter("meqStorageAfUp", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqStorageInpUp"]] <- newParameter("meqStorageInpUp", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqStorageInpLo"]] <- newParameter("meqStorageInpLo", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqStorageOutUp"]] <- newParameter("meqStorageOutUp", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqStorageOutLo"]] <- newParameter("meqStorageOutLo", c("stg", "comm", "region", "year", "slice"), "map")
  x[["meqTradeFlowUp"]] <- newParameter("meqTradeFlowUp", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["meqTradeFlowLo"]] <- newParameter("meqTradeFlowLo", c("trade", "comm", "src", "dst", "year", "slice"), "map")
  x[["meqExportRowLo"]] <- newParameter("meqExportRowLo", c("expp", "comm", "region", "year", "slice"), "map")
  x[["meqImportRowLo"]] <- newParameter("meqImportRowLo", c("imp", "comm", "region", "year", "slice"), "map")
  x[["meqTradeCapFlow"]] <- newParameter("meqTradeCapFlow", c("trade", "comm", "year", "slice"), "map")
  x[["meqBalLo"]] <- newParameter("meqBalLo", c("comm", "region", "year", "slice"), "map")
  x[["meqBalUp"]] <- newParameter("meqBalUp", c("comm", "region", "year", "slice"), "map")
  x[["meqBalFx"]] <- newParameter("meqBalFx", c("comm", "region", "year", "slice"), "map")
  x[["meqLECActivity"]] <- newParameter("meqLECActivity", c("tech", "region", "year"), "map")

  .Object@parameters <- x
  .Object
}
)

