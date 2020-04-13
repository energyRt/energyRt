..getEquationsDim <- function() {
  list(
    eqTechSng2Sng = c("tech", "region", "comm", "comm", "year", "slice"), 
    eqTechGrp2Sng = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechSng2Grp = c("tech", "region", "comm", "group", "year", "slice"), 
    eqTechGrp2Grp = c("tech", "region", "group", "group", "year", "slice"), 
    eqTechShareInpLo = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareInpUp = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareOutLo = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareOutUp = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechAInp = c("tech", "comm", "region", "year", "slice"), 
    eqTechAOut = c("tech", "comm", "region", "year", "slice"), 
    eqTechAfLo = c("tech", "region", "year", "slice"), 
    eqTechAfUp = c("tech", "region", "year", "slice"), 
    eqTechAfsLo = c("tech", "region", "year", "slice"), 
    eqTechAfsUp = c("tech", "region", "year", "slice"), 
    eqTechActSng = c("tech", "comm", "region", "year", "slice"), 
    eqTechActGrp = c("tech", "group", "region", "year", "slice"), 
    eqTechAfcOutLo = c("tech", "region", "comm", "year", "slice"), 
    eqTechAfcOutUp = c("tech", "region", "comm", "year", "slice"), 
    eqTechAfcInpLo = c("tech", "region", "comm", "year", "slice"), 
    eqTechAfcInpUp = c("tech", "region", "comm", "year", "slice"), 
    eqTechCap = c("tech", "region", "year"), 
    eqTechRetirementNewCap = c("tech", "region", "year"), 
    eqTechRetirementStock = c("tech", "region", "year"), 
    eqTechEac = c("tech", "region", "year"), 
    eqTechInv = c("tech", "region", "year"), 
    eqTechOMCost = c("tech", "region", "year"), 
    eqSupAvaUp = c("sup", "comm", "region", "year", "slice"), 
    eqSupAvaLo = c("sup", "comm", "region", "year", "slice"), 
    eqSupTotal = c("sup", "comm", "region"), 
    eqSupReserveUp = c("sup", "comm", "region"), 
    eqSupReserveLo = c("sup", "comm", "region"), 
    eqSupCost = c("sup", "region", "year"), 
    eqDemInp = c("comm", "region", "year", "slice"), 
    eqAggOut = c("comm", "region", "year", "slice"), 
    eqEmsFuelTot = c("comm", "region", "year", "slice"), 
    eqStorageStore = c("stg", "comm", "region", "year", "slice"), 
    eqStorageAfLo = c("stg", "comm", "region", "year", "slice"), 
    eqStorageAfUp = c("stg", "comm", "region", "year", "slice"), 
    eqStorageClean = c("stg", "comm", "region", "year", "slice"), 
    eqStorageAInp = c("stg", "comm", "region", "year", "slice"), 
    eqStorageAOut = c("stg", "comm", "region", "year", "slice"), 
    eqStorageInpUp = c("stg", "comm", "region", "year", "slice"), 
    eqStorageInpLo = c("stg", "comm", "region", "year", "slice"), 
    eqStorageOutUp = c("stg", "comm", "region", "year", "slice"), 
    eqStorageOutLo = c("stg", "comm", "region", "year", "slice"), 
    eqStorageCap = c("stg", "region", "year"), 
    eqStorageInv = c("stg", "region", "year"), 
    eqStorageEac = c("stg", "region", "year"), 
    eqStorageCost = c("stg", "region", "year"), 
    eqImport = c("comm", "region", "year", "slice"), 
    eqExport = c("comm", "region", "year", "slice"), 
    eqTradeFlowUp = c("trade", "comm", "region", "region", "year", "slice"), 
    eqTradeFlowLo = c("trade", "comm", "region", "region", "year", "slice"), 
    eqCostTrade = c("region", "year"), 
    eqCostRowTrade = c("region", "year"), 
    eqCostIrTrade = c("region", "year"), 
    eqExportRowUp = c("expp", "comm", "region", "year", "slice"), 
    eqExportRowLo = c("expp", "comm", "region", "year", "slice"), 
    eqExportRowCumulative = c("expp", "comm"), 
    eqExportRowResUp = c("expp", "comm"), 
    eqImportRowUp = c("imp", "comm", "region", "year", "slice"), 
    eqImportRowLo = c("imp", "comm", "region", "year", "slice"), 
    eqImportRowAccumulated = c("imp", "comm"), 
    eqImportRowResUp = c("imp", "comm"), 
    eqTradeCap = c("trade", "year"), 
    eqTradeInv = c("trade", "region", "year"), 
    eqTradeEac = c("trade", "region", "year"), 
    eqTradeCapFlow = c("trade", "comm", "year", "slice"), 
    eqTradeIrAInp = c("trade", "comm", "region", "year", "slice"), 
    eqTradeIrAOut = c("trade", "comm", "region", "year", "slice"), 
    eqTradeIrAInpTot = c("comm", "region", "year", "slice"), 
    eqTradeIrAOutTot = c("comm", "region", "year", "slice"), 
    eqBalUp = c("comm", "region", "year", "slice"), 
    eqBalLo = c("comm", "region", "year", "slice"), 
    eqBalFx = c("comm", "region", "year", "slice"), 
    eqBal = c("comm", "region", "year", "slice"), 
    eqOutTot = c("comm", "region", "year", "slice"), 
    eqInpTot = c("comm", "region", "year", "slice"), 
    eqInp2Lo = c("comm", "region", "year", "slice"), 
    eqOut2Lo = c("comm", "region", "year", "slice"), 
    eqSupOutTot = c("comm", "region", "year", "slice"), 
    eqTechInpTot = c("comm", "region", "year", "slice"), 
    eqTechOutTot = c("comm", "region", "year", "slice"), 
    eqStorageInpTot = c("comm", "region", "year", "slice"), 
    eqStorageOutTot = c("comm", "region", "year", "slice"), 
    eqCost = c("region", "year"), 
    eqTaxCost = c("comm", "region", "year"), 
    eqSubsCost = c("comm", "region", "year"), 
    eqLECActivity = c("tech", "region", "year"))
}
..getVariablesDim <- function() {
  list(
    vTechInv = c("tech", "region", "year"), 
    vTechEac = c("tech", "region", "year"), 
    vTechOMCost = c("tech", "region", "year"), 
    vSupCost = c("sup", "region", "year"), 
    vEmsFuelTot = c("comm", "region", "year", "slice"), 
    vBalance = c("comm", "region", "year", "slice"), 
    vTotalCost = c("region", "year"), 
    vTaxCost = c("comm", "region", "year"), 
    vSubsCost = c("comm", "region", "year"), 
    vAggOut = c("comm", "region", "year", "slice"), 
    vStorageOMCost = c("stg", "region", "year"), 
    vTradeCost = c("region", "year"), 
    vTradeRowCost = c("region", "year"), 
    vTradeIrCost = c("region", "year"), 
    vTechNewCap = c("tech", "region", "year"), 
    vTechRetirementStock = c("tech", "region", "year"), 
    vTechRetirementNewCap = c("tech", "region", "year", "year"), 
    vTechCap = c("tech", "region", "year"), 
    vTechAct = c("tech", "region", "year", "slice"), 
    vTechInp = c("tech", "comm", "region", "year", "slice"), 
    vTechOut = c("tech", "comm", "region", "year", "slice"), 
    vTechAInp = c("tech", "comm", "region", "year", "slice"), 
    vTechAOut = c("tech", "comm", "region", "year", "slice"), 
    vSupOut = c("sup", "comm", "region", "year", "slice"), 
    vSupReserve = c("sup", "comm", "region"), 
    vDemInp = c("comm", "region", "year", "slice"), 
    vOutTot = c("comm", "region", "year", "slice"), 
    vInpTot = c("comm", "region", "year", "slice"), 
    vInp2Lo = c("comm", "region", "year", "slice", "slice"), 
    vOut2Lo = c("comm", "region", "year", "slice", "slice"), 
    vSupOutTot = c("comm", "region", "year", "slice"), 
    vTechInpTot = c("comm", "region", "year", "slice"), 
    vTechOutTot = c("comm", "region", "year", "slice"), 
    vStorageInpTot = c("comm", "region", "year", "slice"), 
    vStorageOutTot = c("comm", "region", "year", "slice"), 
    vStorageAInp = c("stg", "comm", "region", "year", "slice"), 
    vStorageAOut = c("stg", "comm", "region", "year", "slice"), 
    vDummyImport = c("comm", "region", "year", "slice"), 
    vDummyExport = c("comm", "region", "year", "slice"), 
    vStorageInp = c("stg", "comm", "region", "year", "slice"), 
    vStorageOut = c("stg", "comm", "region", "year", "slice"), 
    vStorageStore = c("stg", "comm", "region", "year", "slice"), 
    vStorageInv = c("stg", "region", "year"), 
    vStorageEac = c("stg", "region", "year"), 
    vStorageCap = c("stg", "region", "year"), 
    vStorageNewCap = c("stg", "region", "year"), 
    vImport = c("comm", "region", "year", "slice"), 
    vExport = c("comm", "region", "year", "slice"), 
    vTradeIr = c("trade", "comm", "region", "region", "year", "slice"), 
    vTradeIrAInp = c("trade", "comm", "region", "year", "slice"), 
    vTradeIrAInpTot = c("comm", "region", "year", "slice"), 
    vTradeIrAOut = c("trade", "comm", "region", "year", "slice"), 
    vTradeIrAOutTot = c("comm", "region", "year", "slice"), 
    vExportRowAccumulated = c("expp", "comm"), 
    vExportRow = c("expp", "comm", "region", "year", "slice"), 
    vImportRowAccumulated = c("imp", "comm"), 
    vImportRow = c("imp", "comm", "region", "year", "slice"), 
    vTradeCap = c("trade", "year"), 
    vTradeInv = c("trade", "region", "year"), 
    vTradeEac = c("trade", "region", "year"), 
    vTradeNewCap = c("trade", "year"))
}
..getEquations <- function() {
    rs <- data.frame(name = character(), description = character(), 
   tech  = logical(),
   sup  = logical(),
   dem  = logical(),
   stg  = logical(),
   expp  = logical(),
   imp  = logical(),
   trade  = logical(),
   group  = logical(),
   comm  = logical(),
   region  = logical(),
   year  = logical(),
   slice  = logical(),
   weather  = logical(),
   vTechInv  = logical(),
   vTechEac  = logical(),
   vTechOMCost  = logical(),
   vSupCost  = logical(),
   vEmsFuelTot  = logical(),
   vBalance  = logical(),
   vTotalCost  = logical(),
   vObjective  = logical(),
   vTaxCost  = logical(),
   vSubsCost  = logical(),
   vAggOut  = logical(),
   vStorageOMCost  = logical(),
   vTradeCost  = logical(),
   vTradeRowCost  = logical(),
   vTradeIrCost  = logical(),
   vTechNewCap  = logical(),
   vTechRetirementStock  = logical(),
   vTechRetirementNewCap  = logical(),
   vTechCap  = logical(),
   vTechAct  = logical(),
   vTechInp  = logical(),
   vTechOut  = logical(),
   vTechAInp  = logical(),
   vTechAOut  = logical(),
   vSupOut  = logical(),
   vSupReserve  = logical(),
   vDemInp  = logical(),
   vOutTot  = logical(),
   vInpTot  = logical(),
   vInp2Lo  = logical(),
   vOut2Lo  = logical(),
   vSupOutTot  = logical(),
   vTechInpTot  = logical(),
   vTechOutTot  = logical(),
   vStorageInpTot  = logical(),
   vStorageOutTot  = logical(),
   vStorageAInp  = logical(),
   vStorageAOut  = logical(),
   vDummyImport  = logical(),
   vDummyExport  = logical(),
   vStorageInp  = logical(),
   vStorageOut  = logical(),
   vStorageStore  = logical(),
   vStorageInv  = logical(),
   vStorageEac  = logical(),
   vStorageCap  = logical(),
   vStorageNewCap  = logical(),
   vImport  = logical(),
   vExport  = logical(),
   vTradeIr  = logical(),
   vTradeIrAInp  = logical(),
   vTradeIrAInpTot  = logical(),
   vTradeIrAOut  = logical(),
   vTradeIrAOutTot  = logical(),
   vExportRowAccumulated  = logical(),
   vExportRow  = logical(),
   vImportRowAccumulated  = logical(),
   vImportRow  = logical(),
   vTradeCap  = logical(),
   vTradeInv  = logical(),
   vTradeEac  = logical(),
   vTradeNewCap  = logical(),
      stringsAsFactors = FALSE);
    rs[1:90,] <- NA;
    rownames(rs) <- c("eqTechSng2Sng",
 "eqTechGrp2Sng",
 "eqTechSng2Grp",
 "eqTechGrp2Grp",
 "eqTechShareInpLo",
 "eqTechShareInpUp",
 "eqTechShareOutLo",
 "eqTechShareOutUp",
 "eqTechAInp",
 "eqTechAOut",
 "eqTechAfLo",
 "eqTechAfUp",
 "eqTechAfsLo",
 "eqTechAfsUp",
 "eqTechActSng",
 "eqTechActGrp",
 "eqTechAfcOutLo",
 "eqTechAfcOutUp",
 "eqTechAfcInpLo",
 "eqTechAfcInpUp",
 "eqTechCap",
 "eqTechRetirementNewCap",
 "eqTechRetirementStock",
 "eqTechEac",
 "eqTechInv",
 "eqTechOMCost",
 "eqSupAvaUp",
 "eqSupAvaLo",
 "eqSupTotal",
 "eqSupReserveUp",
 "eqSupReserveLo",
 "eqSupCost",
 "eqDemInp",
 "eqAggOut",
 "eqEmsFuelTot",
 "eqStorageStore",
 "eqStorageAfLo",
 "eqStorageAfUp",
 "eqStorageClean",
 "eqStorageAInp",
 "eqStorageAOut",
 "eqStorageInpUp",
 "eqStorageInpLo",
 "eqStorageOutUp",
 "eqStorageOutLo",
 "eqStorageCap",
 "eqStorageInv",
 "eqStorageEac",
 "eqStorageCost",
 "eqImport",
 "eqExport",
 "eqTradeFlowUp",
 "eqTradeFlowLo",
 "eqCostTrade",
 "eqCostRowTrade",
 "eqCostIrTrade",
 "eqExportRowUp",
 "eqExportRowLo",
 "eqExportRowCumulative",
 "eqExportRowResUp",
 "eqImportRowUp",
 "eqImportRowLo",
 "eqImportRowAccumulated",
 "eqImportRowResUp",
 "eqTradeCap",
 "eqTradeInv",
 "eqTradeEac",
 "eqTradeCapFlow",
 "eqTradeIrAInp",
 "eqTradeIrAOut",
 "eqTradeIrAInpTot",
 "eqTradeIrAOutTot",
 "eqBalUp",
 "eqBalLo",
 "eqBalFx",
 "eqBal",
 "eqOutTot",
 "eqInpTot",
 "eqInp2Lo",
 "eqOut2Lo",
 "eqSupOutTot",
 "eqTechInpTot",
 "eqTechOutTot",
 "eqStorageInpTot",
 "eqStorageOutTot",
 "eqCost",
 "eqTaxCost",
 "eqSubsCost",
 "eqObjective",
 "eqLECActivity");
    rs["eqTechSng2Sng", c("name", "description")] <- c("eqTechSng2Sng", "Technology input to output");
    rs["eqTechSng2Sng", c("tech", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechGrp2Sng", c("name", "description")] <- c("eqTechGrp2Sng", "Technology group input to output");
    rs["eqTechGrp2Sng", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechSng2Grp", c("name", "description")] <- c("eqTechSng2Grp", "Technology input to group output");
    rs["eqTechSng2Grp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechGrp2Grp", c("name", "description")] <- c("eqTechGrp2Grp", "Technology group input to group output");
    rs["eqTechGrp2Grp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechShareInpLo", c("name", "description")] <- c("eqTechShareInpLo", "Technology lower bound on input share");
    rs["eqTechShareInpLo", c("tech", "group", "comm", "region", "year", "slice", "vTechInp")] <- TRUE;
    rs["eqTechShareInpUp", c("name", "description")] <- c("eqTechShareInpUp", "Technology upper bound on input share");
    rs["eqTechShareInpUp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp")] <- TRUE;
    rs["eqTechShareOutLo", c("name", "description")] <- c("eqTechShareOutLo", "Technology lower bound on output share");
    rs["eqTechShareOutLo", c("tech", "group", "comm", "region", "year", "slice", "vTechOut")] <- TRUE;
    rs["eqTechShareOutUp", c("name", "description")] <- c("eqTechShareOutUp", "Technology upper bound on output share");
    rs["eqTechShareOutUp", c("tech", "group", "comm", "region", "year", "slice", "vTechOut")] <- TRUE;
    rs["eqTechAInp", c("name", "description")] <- c("eqTechAInp", "Technology auxiliary commodity input");
    rs["eqTechAInp", c("tech", "comm", "region", "year", "slice", "vTechNewCap", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp")] <- TRUE;
    rs["eqTechAOut", c("name", "description")] <- c("eqTechAOut", "Technology auxiliary commodity output");
    rs["eqTechAOut", c("tech", "comm", "region", "year", "slice", "vTechNewCap", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqTechAfLo", c("name", "description")] <- c("eqTechAfLo", "Technology availability factor lower bound");
    rs["eqTechAfLo", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechAfUp", c("name", "description")] <- c("eqTechAfUp", "Technology availability factor upper bound");
    rs["eqTechAfUp", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechAfsLo", c("name", "description")] <- c("eqTechAfsLo", "Technology availability factor for sum lower bound");
    rs["eqTechAfsLo", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechAfsUp", c("name", "description")] <- c("eqTechAfsUp", "Technology availability factor for sum upper bound");
    rs["eqTechAfsUp", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechActSng", c("name", "description")] <- c("eqTechActSng", "Technology activity to commodity output");
    rs["eqTechActSng", c("tech", "comm", "region", "year", "slice", "vTechAct", "vTechOut")] <- TRUE;
    rs["eqTechActGrp", c("name", "description")] <- c("eqTechActGrp", "Technology activity to group output");
    rs["eqTechActGrp", c("tech", "group", "comm", "region", "year", "slice", "vTechAct", "vTechOut")] <- TRUE;
    rs["eqTechAfcOutLo", c("name", "description")] <- c("eqTechAfcOutLo", "Technology commodity availability factor lower bound");
    rs["eqTechAfcOutLo", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechOut")] <- TRUE;
    rs["eqTechAfcOutUp", c("name", "description")] <- c("eqTechAfcOutUp", "Technology commodity availability factor upper bound");
    rs["eqTechAfcOutUp", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechOut")] <- TRUE;
    rs["eqTechAfcInpLo", c("name", "description")] <- c("eqTechAfcInpLo", "Technology commodity availability factor lower bound");
    rs["eqTechAfcInpLo", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechInp")] <- TRUE;
    rs["eqTechAfcInpUp", c("name", "description")] <- c("eqTechAfcInpUp", "Technology commodity availability factor upper bound");
    rs["eqTechAfcInpUp", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechInp")] <- TRUE;
    rs["eqTechCap", c("name", "description")] <- c("eqTechCap", "Technology capacity");
    rs["eqTechCap", c("tech", "region", "year", "vTechNewCap", "vTechRetirementStock", "vTechRetirementNewCap", "vTechCap")] <- TRUE;
    rs["eqTechRetirementNewCap", c("name", "description")] <- c("eqTechRetirementNewCap", "Stock retired eqution");
    rs["eqTechRetirementNewCap", c("tech", "region", "year", "vTechNewCap", "vTechRetirementNewCap")] <- TRUE;
    rs["eqTechRetirementStock", c("name", "description")] <- c("eqTechRetirementStock", "Stock retired eqution");
    rs["eqTechRetirementStock", c("tech", "region", "year", "vTechRetirementStock")] <- TRUE;
    rs["eqTechEac", c("name", "description")] <- c("eqTechEac", "Technology Equivalent Annual Cost (EAC)");
    rs["eqTechEac", c("tech", "region", "year", "vTechEac", "vTechNewCap", "vTechRetirementNewCap")] <- TRUE;
    rs["eqTechInv", c("name", "description")] <- c("eqTechInv", "Technology investment costs");
    rs["eqTechInv", c("tech", "region", "year", "vTechInv", "vTechNewCap")] <- TRUE;
    rs["eqTechOMCost", c("name", "description")] <- c("eqTechOMCost", "Technology O&M costs");
    rs["eqTechOMCost", c("tech", "comm", "region", "year", "slice", "vTechOMCost", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp", "vTechAOut")] <- TRUE;
    rs["eqSupAvaUp", c("name", "description")] <- c("eqSupAvaUp", "Supply availability upper bound");
    rs["eqSupAvaUp", c("sup", "comm", "region", "year", "slice", "vSupOut")] <- TRUE;
    rs["eqSupAvaLo", c("name", "description")] <- c("eqSupAvaLo", "Supply availability lower bound");
    rs["eqSupAvaLo", c("sup", "comm", "region", "year", "slice", "vSupOut")] <- TRUE;
    rs["eqSupTotal", c("name", "description")] <- c("eqSupTotal", "Total supply of each commodity");
    rs["eqSupTotal", c("sup", "comm", "region", "year", "slice", "vSupOut", "vSupReserve")] <- TRUE;
    rs["eqSupReserveUp", c("name", "description")] <- c("eqSupReserveUp", "Total supply vs reserve check");
    rs["eqSupReserveUp", c("sup", "comm", "region", "vSupReserve")] <- TRUE;
    rs["eqSupReserveLo", c("name", "description")] <- c("eqSupReserveLo", "Total supply vs reserve check");
    rs["eqSupReserveLo", c("sup", "comm", "region", "vSupReserve")] <- TRUE;
    rs["eqSupCost", c("name", "description")] <- c("eqSupCost", "Total supply costs");
    rs["eqSupCost", c("sup", "comm", "region", "year", "slice", "vSupCost", "vSupOut")] <- TRUE;
    rs["eqDemInp", c("name", "description")] <- c("eqDemInp", "Demand equation");
    rs["eqDemInp", c("comm", "region", "year", "slice", "vDemInp")] <- TRUE;
    rs["eqAggOut", c("name", "description")] <- c("eqAggOut", "Aggregating commodity output");
    rs["eqAggOut", c("comm", "region", "year", "slice", "vAggOut", "vOutTot")] <- TRUE;
    rs["eqEmsFuelTot", c("name", "description")] <- c("eqEmsFuelTot", "Emissions from commodity consumption (i.e. fuels combustion)");
    rs["eqEmsFuelTot", c("tech", "comm", "region", "year", "slice", "vEmsFuelTot", "vTechInp")] <- TRUE;
    rs["eqStorageStore", c("name", "description")] <- c("eqStorageStore", "Storage equation");
    rs["eqStorageStore", c("stg", "comm", "region", "year", "slice", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageNewCap")] <- TRUE;
    rs["eqStorageAfLo", c("name", "description")] <- c("eqStorageAfLo", "Storage availability factor lower");
    rs["eqStorageAfLo", c("stg", "comm", "region", "year", "slice", "vStorageStore", "vStorageCap")] <- TRUE;
    rs["eqStorageAfUp", c("name", "description")] <- c("eqStorageAfUp", "Storage availability factor upper");
    rs["eqStorageAfUp", c("stg", "comm", "region", "year", "slice", "vStorageStore", "vStorageCap")] <- TRUE;
    rs["eqStorageClean", c("name", "description")] <- c("eqStorageClean", "Storage input less Stote");
    rs["eqStorageClean", c("stg", "comm", "region", "year", "slice", "vStorageOut", "vStorageStore")] <- TRUE;
    rs["eqStorageAInp", c("name", "description")] <- c("eqStorageAInp", "");
    rs["eqStorageAInp", c("stg", "comm", "region", "year", "slice", "vStorageAInp", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageCap", "vStorageNewCap")] <- TRUE;
    rs["eqStorageAOut", c("name", "description")] <- c("eqStorageAOut", "");
    rs["eqStorageAOut", c("stg", "comm", "region", "year", "slice", "vStorageAOut", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageCap", "vStorageNewCap")] <- TRUE;
    rs["eqStorageInpUp", c("name", "description")] <- c("eqStorageInpUp", "");
    rs["eqStorageInpUp", c("stg", "comm", "region", "year", "slice", "vStorageInp", "vStorageCap")] <- TRUE;
    rs["eqStorageInpLo", c("name", "description")] <- c("eqStorageInpLo", "");
    rs["eqStorageInpLo", c("stg", "comm", "region", "year", "slice", "vStorageInp", "vStorageCap")] <- TRUE;
    rs["eqStorageOutUp", c("name", "description")] <- c("eqStorageOutUp", "");
    rs["eqStorageOutUp", c("stg", "comm", "region", "year", "slice", "vStorageOut", "vStorageCap")] <- TRUE;
    rs["eqStorageOutLo", c("name", "description")] <- c("eqStorageOutLo", "");
    rs["eqStorageOutLo", c("stg", "comm", "region", "year", "slice", "vStorageOut", "vStorageCap")] <- TRUE;
    rs["eqStorageCap", c("name", "description")] <- c("eqStorageCap", "Storage capacity");
    rs["eqStorageCap", c("stg", "region", "year", "vStorageCap", "vStorageNewCap")] <- TRUE;
    rs["eqStorageInv", c("name", "description")] <- c("eqStorageInv", "Storage investments");
    rs["eqStorageInv", c("stg", "region", "year", "vStorageInv", "vStorageNewCap")] <- TRUE;
    rs["eqStorageEac", c("name", "description")] <- c("eqStorageEac", "");
    rs["eqStorageEac", c("stg", "region", "year", "vStorageEac", "vStorageNewCap")] <- TRUE;
    rs["eqStorageCost", c("name", "description")] <- c("eqStorageCost", "Storage total costs");
    rs["eqStorageCost", c("stg", "comm", "region", "year", "slice", "vStorageOMCost", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageCap")] <- TRUE;
    rs["eqImport", c("name", "description")] <- c("eqImport", "Import equation");
    rs["eqImport", c("imp", "trade", "comm", "region", "year", "slice", "vImport", "vTradeIr", "vImportRow")] <- TRUE;
    rs["eqExport", c("name", "description")] <- c("eqExport", "Export equation");
    rs["eqExport", c("expp", "trade", "comm", "region", "year", "slice", "vExport", "vTradeIr", "vExportRow")] <- TRUE;
    rs["eqTradeFlowUp", c("name", "description")] <- c("eqTradeFlowUp", "Trade upper bound");
    rs["eqTradeFlowUp", c("trade", "comm", "region", "year", "slice", "vTradeIr")] <- TRUE;
    rs["eqTradeFlowLo", c("name", "description")] <- c("eqTradeFlowLo", "Trade lower bound");
    rs["eqTradeFlowLo", c("trade", "comm", "region", "year", "slice", "vTradeIr")] <- TRUE;
    rs["eqCostTrade", c("name", "description")] <- c("eqCostTrade", "Total trade costs");
    rs["eqCostTrade", c("region", "year", "vTradeCost", "vTradeRowCost", "vTradeIrCost")] <- TRUE;
    rs["eqCostRowTrade", c("name", "description")] <- c("eqCostRowTrade", "Costs of trade with the Rest of the World (ROW)");
    rs["eqCostRowTrade", c("expp", "imp", "comm", "region", "year", "slice", "vTradeRowCost", "vExportRow", "vImportRow")] <- TRUE;
    rs["eqCostIrTrade", c("name", "description")] <- c("eqCostIrTrade", "Costs of import");
    rs["eqCostIrTrade", c("trade", "comm", "region", "year", "slice", "vTradeIrCost", "vTradeIr", "vTradeEac")] <- TRUE;
    rs["eqExportRowUp", c("name", "description")] <- c("eqExportRowUp", "Export to ROW upper bound");
    rs["eqExportRowUp", c("expp", "comm", "region", "year", "slice", "vExportRow")] <- TRUE;
    rs["eqExportRowLo", c("name", "description")] <- c("eqExportRowLo", "Export to ROW lower bound");
    rs["eqExportRowLo", c("expp", "comm", "region", "year", "slice", "vExportRow")] <- TRUE;
    rs["eqExportRowCumulative", c("name", "description")] <- c("eqExportRowCumulative", "Cumulative export to ROW");
    rs["eqExportRowCumulative", c("expp", "comm", "region", "year", "slice", "vExportRowAccumulated", "vExportRow")] <- TRUE;
    rs["eqExportRowResUp", c("name", "description")] <- c("eqExportRowResUp", "Accumulated export to ROW upper bound");
    rs["eqExportRowResUp", c("expp", "comm", "vExportRowAccumulated")] <- TRUE;
    rs["eqImportRowUp", c("name", "description")] <- c("eqImportRowUp", "Import from ROW upper bound");
    rs["eqImportRowUp", c("imp", "comm", "region", "year", "slice", "vImportRow")] <- TRUE;
    rs["eqImportRowLo", c("name", "description")] <- c("eqImportRowLo", "Import of ROW lower bound");
    rs["eqImportRowLo", c("imp", "comm", "region", "year", "slice", "vImportRow")] <- TRUE;
    rs["eqImportRowAccumulated", c("name", "description")] <- c("eqImportRowAccumulated", "Accumulated import from ROW");
    rs["eqImportRowAccumulated", c("imp", "comm", "region", "year", "slice", "vImportRowAccumulated", "vImportRow")] <- TRUE;
    rs["eqImportRowResUp", c("name", "description")] <- c("eqImportRowResUp", "Accumulated import from ROW upper bound");
    rs["eqImportRowResUp", c("imp", "comm", "vImportRowAccumulated")] <- TRUE;
    rs["eqTradeCap", c("name", "description")] <- c("eqTradeCap", "");
    rs["eqTradeCap", c("trade", "year", "vTradeCap", "vTradeNewCap")] <- TRUE;
    rs["eqTradeInv", c("name", "description")] <- c("eqTradeInv", "");
    rs["eqTradeInv", c("trade", "region", "year", "vTradeInv", "vTradeNewCap")] <- TRUE;
    rs["eqTradeEac", c("name", "description")] <- c("eqTradeEac", "");
    rs["eqTradeEac", c("trade", "region", "year", "vTradeEac", "vTradeNewCap")] <- TRUE;
    rs["eqTradeCapFlow", c("name", "description")] <- c("eqTradeCapFlow", "");
    rs["eqTradeCapFlow", c("trade", "comm", "region", "year", "slice", "vTradeIr", "vTradeCap")] <- TRUE;
    rs["eqTradeIrAInp", c("name", "description")] <- c("eqTradeIrAInp", "Trade auxiliary commodity input");
    rs["eqTradeIrAInp", c("trade", "comm", "region", "year", "slice", "vTradeIr", "vTradeIrAInp")] <- TRUE;
    rs["eqTradeIrAOut", c("name", "description")] <- c("eqTradeIrAOut", "Trade auxiliary commodity output");
    rs["eqTradeIrAOut", c("trade", "comm", "region", "year", "slice", "vTradeIr", "vTradeIrAOut")] <- TRUE;
    rs["eqTradeIrAInpTot", c("name", "description")] <- c("eqTradeIrAInpTot", "Trade auxiliary commodity input");
    rs["eqTradeIrAInpTot", c("trade", "comm", "region", "year", "slice", "vTradeIrAInp", "vTradeIrAInpTot")] <- TRUE;
    rs["eqTradeIrAOutTot", c("name", "description")] <- c("eqTradeIrAOutTot", "Trade auxiliary commodity output");
    rs["eqTradeIrAOutTot", c("trade", "comm", "region", "year", "slice", "vTradeIrAOut", "vTradeIrAOutTot")] <- TRUE;
    rs["eqBalUp", c("name", "description")] <- c("eqBalUp", "PRODUCTION <= CONSUMPTION commodity balance");
    rs["eqBalUp", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBalLo", c("name", "description")] <- c("eqBalLo", "PRODUCTION >= CONSUMPTION commodity balance");
    rs["eqBalLo", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBalFx", c("name", "description")] <- c("eqBalFx", "PRODUCTION = CONSUMPTION commodity balance");
    rs["eqBalFx", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBal", c("name", "description")] <- c("eqBal", "Commodity balance");
    rs["eqBal", c("comm", "region", "year", "slice", "vBalance", "vOutTot", "vInpTot")] <- TRUE;
    rs["eqOutTot", c("name", "description")] <- c("eqOutTot", "Total commodity output");
    rs["eqOutTot", c("comm", "region", "year", "slice", "vEmsFuelTot", "vAggOut", "vOutTot", "vOut2Lo", "vSupOutTot", "vTechOutTot", "vStorageOutTot", "vDummyImport", "vImport", "vTradeIrAOutTot")] <- TRUE;
    rs["eqInpTot", c("name", "description")] <- c("eqInpTot", "Total commodity input");
    rs["eqInpTot", c("comm", "region", "year", "slice", "vDemInp", "vInpTot", "vInp2Lo", "vTechInpTot", "vStorageInpTot", "vDummyExport", "vExport", "vTradeIrAInpTot")] <- TRUE;
    rs["eqInp2Lo", c("name", "description")] <- c("eqInp2Lo", "From coomodity slice to lo level");
    rs["eqInp2Lo", c("comm", "region", "year", "slice", "vInp2Lo", "vTechInpTot", "vStorageInpTot", "vExport", "vTradeIrAInpTot")] <- TRUE;
    rs["eqOut2Lo", c("name", "description")] <- c("eqOut2Lo", "From coomodity slice to lo level");
    rs["eqOut2Lo", c("comm", "region", "year", "slice", "vEmsFuelTot", "vAggOut", "vOut2Lo", "vSupOutTot", "vTechOutTot", "vStorageOutTot", "vImport", "vTradeIrAOutTot")] <- TRUE;
    rs["eqSupOutTot", c("name", "description")] <- c("eqSupOutTot", "Supply total output");
    rs["eqSupOutTot", c("sup", "comm", "region", "year", "slice", "vSupOut", "vSupOutTot")] <- TRUE;
    rs["eqTechInpTot", c("name", "description")] <- c("eqTechInpTot", "Technology total input");
    rs["eqTechInpTot", c("tech", "comm", "region", "year", "slice", "vTechInp", "vTechAInp", "vTechInpTot")] <- TRUE;
    rs["eqTechOutTot", c("name", "description")] <- c("eqTechOutTot", "Technology total output");
    rs["eqTechOutTot", c("tech", "comm", "region", "year", "slice", "vTechOut", "vTechAOut", "vTechOutTot")] <- TRUE;
    rs["eqStorageInpTot", c("name", "description")] <- c("eqStorageInpTot", "Storage total input");
    rs["eqStorageInpTot", c("stg", "comm", "region", "year", "slice", "vStorageInpTot", "vStorageAInp", "vStorageInp")] <- TRUE;
    rs["eqStorageOutTot", c("name", "description")] <- c("eqStorageOutTot", "Storage total output");
    rs["eqStorageOutTot", c("stg", "comm", "region", "year", "slice", "vStorageOutTot", "vStorageAOut", "vStorageOut")] <- TRUE;
    rs["eqCost", c("name", "description")] <- c("eqCost", "Total costs");
    rs["eqCost", c("tech", "sup", "stg", "comm", "region", "year", "slice", "vTechEac", "vTechOMCost", "vSupCost", "vTotalCost", "vTaxCost", "vSubsCost", "vStorageOMCost", "vTradeCost", "vDummyImport", "vDummyExport", "vStorageEac")] <- TRUE;
    rs["eqTaxCost", c("name", "description")] <- c("eqTaxCost", "Commodity taxes");
    rs["eqTaxCost", c("comm", "region", "year", "slice", "vTaxCost", "vOutTot")] <- TRUE;
    rs["eqSubsCost", c("name", "description")] <- c("eqSubsCost", "Commodity subsidy");
    rs["eqSubsCost", c("comm", "region", "year", "slice", "vSubsCost", "vOutTot")] <- TRUE;
    rs["eqObjective", c("name", "description")] <- c("eqObjective", "Objective equation");
    rs["eqObjective", c("region", "year", "vTotalCost", "vObjective")] <- TRUE;
    rs["eqLECActivity", c("name", "description")] <- c("eqLECActivity", "");
    rs["eqLECActivity", c("tech", "region", "year", "slice", "vTechAct")] <- TRUE;
    rs[, -(1:2)][is.na(rs[, -(1:2)])] <- FALSE;
rs
}
..getVariables <- function() {
    rs <- data.frame(name = character(), description = character(), 
   tech  = logical(),
   sup  = logical(),
   dem  = logical(),
   stg  = logical(),
   expp  = logical(),
   imp  = logical(),
   trade  = logical(),
   group  = logical(),
   comm  = logical(),
   region  = logical(),
   year  = logical(),
   slice  = logical(),
   weather  = logical(),
   eqTechSng2Sng  = logical(),
   eqTechGrp2Sng  = logical(),
   eqTechSng2Grp  = logical(),
   eqTechGrp2Grp  = logical(),
   eqTechShareInpLo  = logical(),
   eqTechShareInpUp  = logical(),
   eqTechShareOutLo  = logical(),
   eqTechShareOutUp  = logical(),
   eqTechAInp  = logical(),
   eqTechAOut  = logical(),
   eqTechAfLo  = logical(),
   eqTechAfUp  = logical(),
   eqTechAfsLo  = logical(),
   eqTechAfsUp  = logical(),
   eqTechActSng  = logical(),
   eqTechActGrp  = logical(),
   eqTechAfcOutLo  = logical(),
   eqTechAfcOutUp  = logical(),
   eqTechAfcInpLo  = logical(),
   eqTechAfcInpUp  = logical(),
   eqTechCap  = logical(),
   eqTechRetirementNewCap  = logical(),
   eqTechRetirementStock  = logical(),
   eqTechEac  = logical(),
   eqTechInv  = logical(),
   eqTechOMCost  = logical(),
   eqSupAvaUp  = logical(),
   eqSupAvaLo  = logical(),
   eqSupTotal  = logical(),
   eqSupReserveUp  = logical(),
   eqSupReserveLo  = logical(),
   eqSupCost  = logical(),
   eqDemInp  = logical(),
   eqAggOut  = logical(),
   eqEmsFuelTot  = logical(),
   eqStorageStore  = logical(),
   eqStorageAfLo  = logical(),
   eqStorageAfUp  = logical(),
   eqStorageClean  = logical(),
   eqStorageAInp  = logical(),
   eqStorageAOut  = logical(),
   eqStorageInpUp  = logical(),
   eqStorageInpLo  = logical(),
   eqStorageOutUp  = logical(),
   eqStorageOutLo  = logical(),
   eqStorageCap  = logical(),
   eqStorageInv  = logical(),
   eqStorageEac  = logical(),
   eqStorageCost  = logical(),
   eqImport  = logical(),
   eqExport  = logical(),
   eqTradeFlowUp  = logical(),
   eqTradeFlowLo  = logical(),
   eqCostTrade  = logical(),
   eqCostRowTrade  = logical(),
   eqCostIrTrade  = logical(),
   eqExportRowUp  = logical(),
   eqExportRowLo  = logical(),
   eqExportRowCumulative  = logical(),
   eqExportRowResUp  = logical(),
   eqImportRowUp  = logical(),
   eqImportRowLo  = logical(),
   eqImportRowAccumulated  = logical(),
   eqImportRowResUp  = logical(),
   eqTradeCap  = logical(),
   eqTradeInv  = logical(),
   eqTradeEac  = logical(),
   eqTradeCapFlow  = logical(),
   eqTradeIrAInp  = logical(),
   eqTradeIrAOut  = logical(),
   eqTradeIrAInpTot  = logical(),
   eqTradeIrAOutTot  = logical(),
   eqBalUp  = logical(),
   eqBalLo  = logical(),
   eqBalFx  = logical(),
   eqBal  = logical(),
   eqOutTot  = logical(),
   eqInpTot  = logical(),
   eqInp2Lo  = logical(),
   eqOut2Lo  = logical(),
   eqSupOutTot  = logical(),
   eqTechInpTot  = logical(),
   eqTechOutTot  = logical(),
   eqStorageInpTot  = logical(),
   eqStorageOutTot  = logical(),
   eqCost  = logical(),
   eqTaxCost  = logical(),
   eqSubsCost  = logical(),
   eqObjective  = logical(),
   eqLECActivity  = logical(),
      stringsAsFactors = FALSE);
    rs[1:62,] <- NA;
    rownames(rs) <- c("vTechInv", "vTechEac", "vTechOMCost", "vSupCost", "vEmsFuelTot", "vBalance", "vTotalCost", "vObjective", "vTaxCost", "vSubsCost", "vAggOut", "vStorageOMCost", "vTradeCost", "vTradeRowCost", "vTradeIrCost", "vTechNewCap", "vTechRetirementStock", "vTechRetirementNewCap", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp", "vTechAOut", "vSupOut", "vSupReserve", "vDemInp", "vOutTot", "vInpTot", "vInp2Lo", "vOut2Lo", "vSupOutTot", "vTechInpTot", "vTechOutTot", "vStorageInpTot", "vStorageOutTot", "vStorageAInp", "vStorageAOut", "vDummyImport", "vDummyExport", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageInv", "vStorageEac", "vStorageCap", "vStorageNewCap", "vImport", "vExport", "vTradeIr", "vTradeIrAInp", "vTradeIrAInpTot", "vTradeIrAOut", "vTradeIrAOutTot", "vExportRowAccumulated", "vExportRow", "vImportRowAccumulated", "vImportRow", "vTradeCap", "vTradeInv", "vTradeEac", "vTradeNewCap");
    rs["vTechInv", c("name", "description")] <- c("vTechInv", "Overnight investment costs");
    rs["vTechInv", c("tech", "region", "year", "eqTechInv")] <- TRUE;
    rs["vTechEac", c("name", "description")] <- c("vTechEac", "Annualized investment costs");
    rs["vTechEac", c("tech", "region", "year", "eqTechEac", "eqCost")] <- TRUE;
    rs["vTechOMCost", c("name", "description")] <- c("vTechOMCost", "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)");
    rs["vTechOMCost", c("tech", "region", "year", "eqTechOMCost", "eqCost")] <- TRUE;
    rs["vSupCost", c("name", "description")] <- c("vSupCost", "Supply costs");
    rs["vSupCost", c("sup", "region", "year", "eqSupCost", "eqCost")] <- TRUE;
    rs["vEmsFuelTot", c("name", "description")] <- c("vEmsFuelTot", "Total fuel emissions");
    rs["vEmsFuelTot", c("comm", "region", "year", "slice", "eqEmsFuelTot", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["vBalance", c("name", "description")] <- c("vBalance", "Net commodity balance");
    rs["vBalance", c("comm", "region", "year", "slice", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal")] <- TRUE;
    rs["vTotalCost", c("name", "description")] <- c("vTotalCost", "Regional annual total costs");
    rs["vTotalCost", c("region", "year", "eqCost", "eqObjective")] <- TRUE;
    rs["vObjective", c("name", "description")] <- c("vObjective", "Objective costs");
    rs["vObjective", c("eqObjective")] <- TRUE;
    rs["vTaxCost", c("name", "description")] <- c("vTaxCost", "Total tax levies (tax costs)");
    rs["vTaxCost", c("comm", "region", "year", "eqCost", "eqTaxCost")] <- TRUE;
    rs["vSubsCost", c("name", "description")] <- c("vSubsCost", "Total subsidies (for substraction from costs)");
    rs["vSubsCost", c("comm", "region", "year", "eqCost", "eqSubsCost")] <- TRUE;
    rs["vAggOut", c("name", "description")] <- c("vAggOut", "Aggregated commodity output");
    rs["vAggOut", c("comm", "region", "year", "slice", "eqAggOut", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["vStorageOMCost", c("name", "description")] <- c("vStorageOMCost", "Storage O&M costs");
    rs["vStorageOMCost", c("stg", "region", "year", "eqStorageCost", "eqCost")] <- TRUE;
    rs["vTradeCost", c("name", "description")] <- c("vTradeCost", "Total trade costs");
    rs["vTradeCost", c("region", "year", "eqCostTrade", "eqCost")] <- TRUE;
    rs["vTradeRowCost", c("name", "description")] <- c("vTradeRowCost", "Trade with ROW costs");
    rs["vTradeRowCost", c("region", "year", "eqCostTrade", "eqCostRowTrade")] <- TRUE;
    rs["vTradeIrCost", c("name", "description")] <- c("vTradeIrCost", "Interregional trade costs");
    rs["vTradeIrCost", c("region", "year", "eqCostTrade", "eqCostIrTrade")] <- TRUE;
    rs["vTechNewCap", c("name", "description")] <- c("vTechNewCap", "New capacity");
    rs["vTechNewCap", c("tech", "region", "year", "eqTechAInp", "eqTechAOut", "eqTechCap", "eqTechRetirementNewCap", "eqTechEac", "eqTechInv")] <- TRUE;
    rs["vTechRetirementStock", c("name", "description")] <- c("vTechRetirementStock", "Early retired capacity");
    rs["vTechRetirementStock", c("tech", "region", "year", "eqTechCap", "eqTechRetirementStock")] <- TRUE;
    rs["vTechRetirementNewCap", c("name", "description")] <- c("vTechRetirementNewCap", "Early retired capacity");
    rs["vTechRetirementNewCap", c("tech", "region", "year", "eqTechCap", "eqTechRetirementNewCap", "eqTechEac")] <- TRUE;
    rs["vTechCap", c("name", "description")] <- c("vTechCap", "Total capacity of the technology");
    rs["vTechCap", c("tech", "region", "year", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechCap", "eqTechOMCost")] <- TRUE;
    rs["vTechAct", c("name", "description")] <- c("vTechAct", "Activity level of technology");
    rs["vTechAct", c("tech", "region", "year", "slice", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechActSng", "eqTechActGrp", "eqTechOMCost", "eqLECActivity")] <- TRUE;
    rs["vTechInp", c("name", "description")] <- c("vTechInp", "Input level");
    rs["vTechInp", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechAInp", "eqTechAOut", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechOMCost", "eqEmsFuelTot", "eqTechInpTot")] <- TRUE;
    rs["vTechOut", c("name", "description")] <- c("vTechOut", "Output level");
    rs["vTechOut", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechOMCost", "eqTechOutTot")] <- TRUE;
    rs["vTechAInp", c("name", "description")] <- c("vTechAInp", "Auxiliary commodity input");
    rs["vTechAInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp", "eqTechOMCost", "eqTechInpTot")] <- TRUE;
    rs["vTechAOut", c("name", "description")] <- c("vTechAOut", "Auxiliary commodity output");
    rs["vTechAOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut", "eqTechOMCost", "eqTechOutTot")] <- TRUE;
    rs["vSupOut", c("name", "description")] <- c("vSupOut", "Output of supply");
    rs["vSupOut", c("sup", "comm", "region", "year", "slice", "eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupCost", "eqSupOutTot")] <- TRUE;
    rs["vSupReserve", c("name", "description")] <- c("vSupReserve", "Total supply reserve");
    rs["vSupReserve", c("sup", "comm", "region", "eqSupTotal", "eqSupReserveUp", "eqSupReserveLo")] <- TRUE;
    rs["vDemInp", c("name", "description")] <- c("vDemInp", "Input to demand");
    rs["vDemInp", c("comm", "region", "year", "slice", "eqDemInp", "eqInpTot")] <- TRUE;
    rs["vOutTot", c("name", "description")] <- c("vOutTot", "Total commodity output (consumption is not counted)");
    rs["vOutTot", c("comm", "region", "year", "slice", "eqAggOut", "eqBal", "eqOutTot", "eqTaxCost", "eqSubsCost")] <- TRUE;
    rs["vInpTot", c("name", "description")] <- c("vInpTot", "Total commodity input");
    rs["vInpTot", c("comm", "region", "year", "slice", "eqBal", "eqInpTot")] <- TRUE;
    rs["vInp2Lo", c("name", "description")] <- c("vInp2Lo", "Desagregation of slices for input parent to (grand)child");
    rs["vInp2Lo", c("comm", "region", "year", "slice", "eqInpTot", "eqInp2Lo")] <- TRUE;
    rs["vOut2Lo", c("name", "description")] <- c("vOut2Lo", "Desagregation of slices for output parent to (grand)child");
    rs["vOut2Lo", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["vSupOutTot", c("name", "description")] <- c("vSupOutTot", "Total commodity supply");
    rs["vSupOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqSupOutTot")] <- TRUE;
    rs["vTechInpTot", c("name", "description")] <- c("vTechInpTot", "Total commodity input to technologies");
    rs["vTechInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqInp2Lo", "eqTechInpTot")] <- TRUE;
    rs["vTechOutTot", c("name", "description")] <- c("vTechOutTot", "Total commodity output from technologies");
    rs["vTechOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqTechOutTot")] <- TRUE;
    rs["vStorageInpTot", c("name", "description")] <- c("vStorageInpTot", "Total commodity input to storages");
    rs["vStorageInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqInp2Lo", "eqStorageInpTot")] <- TRUE;
    rs["vStorageOutTot", c("name", "description")] <- c("vStorageOutTot", "Total commodity output from storages");
    rs["vStorageOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqStorageOutTot")] <- TRUE;
    rs["vStorageAInp", c("name", "description")] <- c("vStorageAInp", "Aux-commodity input to storage");
    rs["vStorageAInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp", "eqStorageInpTot")] <- TRUE;
    rs["vStorageAOut", c("name", "description")] <- c("vStorageAOut", "Aux-commodity input from storage");
    rs["vStorageAOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut", "eqStorageOutTot")] <- TRUE;
    rs["vDummyImport", c("name", "description")] <- c("vDummyImport", "Dummy import (for debugging)");
    rs["vDummyImport", c("comm", "region", "year", "slice", "eqOutTot", "eqCost")] <- TRUE;
    rs["vDummyExport", c("name", "description")] <- c("vDummyExport", "Dummy export (for debugging)");
    rs["vDummyExport", c("comm", "region", "year", "slice", "eqInpTot", "eqCost")] <- TRUE;
    rs["vStorageInp", c("name", "description")] <- c("vStorageInp", "Storage input");
    rs["vStorageInp", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageCost", "eqStorageInpTot")] <- TRUE;
    rs["vStorageOut", c("name", "description")] <- c("vStorageOut", "Storage output");
    rs["vStorageOut", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCost", "eqStorageOutTot")] <- TRUE;
    rs["vStorageStore", c("name", "description")] <- c("vStorageStore", "Storage accumulated level");
    rs["vStorageStore", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageCost")] <- TRUE;
    rs["vStorageInv", c("name", "description")] <- c("vStorageInv", "Storage technology investments");
    rs["vStorageInv", c("stg", "region", "year", "eqStorageInv")] <- TRUE;
    rs["vStorageEac", c("name", "description")] <- c("vStorageEac", "Storage technology EAC investments");
    rs["vStorageEac", c("stg", "region", "year", "eqStorageEac", "eqCost")] <- TRUE;
    rs["vStorageCap", c("name", "description")] <- c("vStorageCap", "Storage capacity");
    rs["vStorageCap", c("stg", "region", "year", "eqStorageAfLo", "eqStorageAfUp", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCap", "eqStorageCost")] <- TRUE;
    rs["vStorageNewCap", c("name", "description")] <- c("vStorageNewCap", "Storage new capacity");
    rs["vStorageNewCap", c("stg", "region", "year", "eqStorageStore", "eqStorageAInp", "eqStorageAOut", "eqStorageCap", "eqStorageInv", "eqStorageEac")] <- TRUE;
    rs["vImport", c("name", "description")] <- c("vImport", "Total regional import (Ir + ROW)");
    rs["vImport", c("comm", "region", "year", "slice", "eqImport", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["vExport", c("name", "description")] <- c("vExport", "Total regional export (Ir + ROW)");
    rs["vExport", c("comm", "region", "year", "slice", "eqExport", "eqInpTot", "eqInp2Lo")] <- TRUE;
    rs["vTradeIr", c("name", "description")] <- c("vTradeIr", "Total physical trade flows between regions");
    rs["vTradeIr", c("trade", "comm", "region", "year", "slice", "eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostIrTrade", "eqTradeCapFlow", "eqTradeIrAInp", "eqTradeIrAOut")] <- TRUE;
    rs["vTradeIrAInp", c("name", "description")] <- c("vTradeIrAInp", "Trade auxilari input");
    rs["vTradeIrAInp", c("trade", "comm", "region", "year", "slice", "eqTradeIrAInp", "eqTradeIrAInpTot")] <- TRUE;
    rs["vTradeIrAInpTot", c("name", "description")] <- c("vTradeIrAInpTot", "Trade total auxilari input");
    rs["vTradeIrAInpTot", c("comm", "region", "year", "slice", "eqTradeIrAInpTot", "eqInpTot", "eqInp2Lo")] <- TRUE;
    rs["vTradeIrAOut", c("name", "description")] <- c("vTradeIrAOut", "Trade auxilari output");
    rs["vTradeIrAOut", c("trade", "comm", "region", "year", "slice", "eqTradeIrAOut", "eqTradeIrAOutTot")] <- TRUE;
    rs["vTradeIrAOutTot", c("name", "description")] <- c("vTradeIrAOutTot", "Trade auxilari output");
    rs["vTradeIrAOutTot", c("comm", "region", "year", "slice", "eqTradeIrAOutTot", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["vExportRowAccumulated", c("name", "description")] <- c("vExportRowAccumulated", "Accumulated export to ROW");
    rs["vExportRowAccumulated", c("expp", "comm", "eqExportRowCumulative", "eqExportRowResUp")] <- TRUE;
    rs["vExportRow", c("name", "description")] <- c("vExportRow", "Export to ROW");
    rs["vExportRow", c("expp", "comm", "region", "year", "slice", "eqExport", "eqCostRowTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative")] <- TRUE;
    rs["vImportRowAccumulated", c("name", "description")] <- c("vImportRowAccumulated", "Accumulated import from ROW");
    rs["vImportRowAccumulated", c("imp", "comm", "eqImportRowAccumulated", "eqImportRowResUp")] <- TRUE;
    rs["vImportRow", c("name", "description")] <- c("vImportRow", "Import from ROW");
    rs["vImportRow", c("imp", "comm", "region", "year", "slice", "eqImport", "eqCostRowTrade", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated")] <- TRUE;
    rs["vTradeCap", c("name", "description")] <- c("vTradeCap", "");
    rs["vTradeCap", c("trade", "year", "eqTradeCap", "eqTradeCapFlow")] <- TRUE;
    rs["vTradeInv", c("name", "description")] <- c("vTradeInv", "");
    rs["vTradeInv", c("trade", "region", "year", "eqTradeInv")] <- TRUE;
    rs["vTradeEac", c("name", "description")] <- c("vTradeEac", "");
    rs["vTradeEac", c("trade", "region", "year", "eqCostIrTrade", "eqTradeEac")] <- TRUE;
    rs["vTradeNewCap", c("name", "description")] <- c("vTradeNewCap", "");
    rs["vTradeNewCap", c("trade", "year", "eqTradeCap", "eqTradeInv", "eqTradeEac")] <- TRUE;
    rs[, -(1:2)][is.na(rs[, -(1:2)])] <- FALSE;
rs
}
..getParameters <- function() {
    rs <- data.frame(name = character(), description = character(), type = character(), 
   type  = logical(),
   tech  = logical(),
   sup  = logical(),
   dem  = logical(),
   stg  = logical(),
   expp  = logical(),
   imp  = logical(),
   trade  = logical(),
   group  = logical(),
   comm  = logical(),
   region  = logical(),
   year  = logical(),
   slice  = logical(),
   weather  = logical(),
   eqTechSng2Sng  = logical(),
   eqTechGrp2Sng  = logical(),
   eqTechSng2Grp  = logical(),
   eqTechGrp2Grp  = logical(),
   eqTechShareInpLo  = logical(),
   eqTechShareInpUp  = logical(),
   eqTechShareOutLo  = logical(),
   eqTechShareOutUp  = logical(),
   eqTechAInp  = logical(),
   eqTechAOut  = logical(),
   eqTechAfLo  = logical(),
   eqTechAfUp  = logical(),
   eqTechAfsLo  = logical(),
   eqTechAfsUp  = logical(),
   eqTechActSng  = logical(),
   eqTechActGrp  = logical(),
   eqTechAfcOutLo  = logical(),
   eqTechAfcOutUp  = logical(),
   eqTechAfcInpLo  = logical(),
   eqTechAfcInpUp  = logical(),
   eqTechCap  = logical(),
   eqTechRetirementNewCap  = logical(),
   eqTechRetirementStock  = logical(),
   eqTechEac  = logical(),
   eqTechInv  = logical(),
   eqTechOMCost  = logical(),
   eqSupAvaUp  = logical(),
   eqSupAvaLo  = logical(),
   eqSupTotal  = logical(),
   eqSupReserveUp  = logical(),
   eqSupReserveLo  = logical(),
   eqSupCost  = logical(),
   eqDemInp  = logical(),
   eqAggOut  = logical(),
   eqEmsFuelTot  = logical(),
   eqStorageStore  = logical(),
   eqStorageAfLo  = logical(),
   eqStorageAfUp  = logical(),
   eqStorageClean  = logical(),
   eqStorageAInp  = logical(),
   eqStorageAOut  = logical(),
   eqStorageInpUp  = logical(),
   eqStorageInpLo  = logical(),
   eqStorageOutUp  = logical(),
   eqStorageOutLo  = logical(),
   eqStorageCap  = logical(),
   eqStorageInv  = logical(),
   eqStorageEac  = logical(),
   eqStorageCost  = logical(),
   eqImport  = logical(),
   eqExport  = logical(),
   eqTradeFlowUp  = logical(),
   eqTradeFlowLo  = logical(),
   eqCostTrade  = logical(),
   eqCostRowTrade  = logical(),
   eqCostIrTrade  = logical(),
   eqExportRowUp  = logical(),
   eqExportRowLo  = logical(),
   eqExportRowCumulative  = logical(),
   eqExportRowResUp  = logical(),
   eqImportRowUp  = logical(),
   eqImportRowLo  = logical(),
   eqImportRowAccumulated  = logical(),
   eqImportRowResUp  = logical(),
   eqTradeCap  = logical(),
   eqTradeInv  = logical(),
   eqTradeEac  = logical(),
   eqTradeCapFlow  = logical(),
   eqTradeIrAInp  = logical(),
   eqTradeIrAOut  = logical(),
   eqTradeIrAInpTot  = logical(),
   eqTradeIrAOutTot  = logical(),
   eqBalUp  = logical(),
   eqBalLo  = logical(),
   eqBalFx  = logical(),
   eqBal  = logical(),
   eqOutTot  = logical(),
   eqInpTot  = logical(),
   eqInp2Lo  = logical(),
   eqOut2Lo  = logical(),
   eqSupOutTot  = logical(),
   eqTechInpTot  = logical(),
   eqTechOutTot  = logical(),
   eqStorageInpTot  = logical(),
   eqStorageOutTot  = logical(),
   eqCost  = logical(),
   eqTaxCost  = logical(),
   eqSubsCost  = logical(),
   eqObjective  = logical(),
   eqLECActivity  = logical(),
      stringsAsFactors = FALSE);
    rs[1:318,] <- NA;
    rownames(rs) <- c("tech",
"sup",
"dem",
"stg",
"expp",
"imp",
"trade",
"group",
"comm",
"region",
"year",
"slice",
"weather",
"mSameRegion",
"mSameSlice",
"mMilestoneFirst",
"mMilestoneLast",
"mMilestoneNext",
"mMilestoneHasNext",
"mStartMilestone",
"mEndMilestone",
"mMidMilestone",
"mCommSlice",
"mCommSliceOrParent",
"mTechRetirement",
"mTechUpgrade",
"mTechInpComm",
"mTechOutComm",
"mTechInpGroup",
"mTechOutGroup",
"mTechOneComm",
"mTechGroupComm",
"mTechAInp",
"mTechAOut",
"mTechNew",
"mTechSpan",
"mTechSlice",
"mSupSlice",
"mSupComm",
"mSupSpan",
"mSupWeatherLo",
"mSupWeatherUp",
"mWeatherSlice",
"mWeatherRegion",
"mDemComm",
"mUpComm",
"mLoComm",
"mFxComm",
"mStorageFullYear",
"mStorageComm",
"mStorageAInp",
"mStorageAOut",
"mStorageNew",
"mStorageSpan",
"mStorageOMCost",
"mStorageEac",
"mSliceNext",
"mSliceFYearNext",
"mTradeSlice",
"mTradeComm",
"mTradeRoutes",
"mTradeIrAInp",
"mTradeIrAOut",
"mExpComm",
"mImpComm",
"mExpSlice",
"mImpSlice",
"mDiscountZero",
"mSliceParentChildE",
"mSliceParentChild",
"mTechWeatherAf",
"mTechWeatherAfs",
"mTechWeatherAfc",
"mStorageWeatherAf",
"mStorageWeatherCinp",
"mStorageWeatherCout",
"mTradeSpan",
"mTradeNew",
"mTradeOlifeInf",
"mTradeEac",
"mTradeCapacityVariable",
"mTradeInv",
"mAggregateFactor",
"mvSupCost",
"mvTechInp",
"mvSupReserve",
"mvTechRetirementNewCap",
"mvTechRetirementStock",
"mvTechAct",
"mvTechOut",
"mvTechAInp",
"mvTechAOut",
"mvDemInp",
"mvBalance",
"mvInpTot",
"mvOutTot",
"mvInp2Lo",
"mvOut2Lo",
"mInpSub",
"mOutSub",
"mvStorageAInp",
"mvStorageAOut",
"mvStorageStore",
"mvTradeIr",
"mvTradeCost",
"mvTradeRowCost",
"mvTradeIrCost",
"mvTotalCost",
"mTechInpTot",
"mTechOutTot",
"mTechEac",
"mTechOMCost",
"mSupOutTot",
"mDemInp",
"mEmsFuelTot",
"mTechEmsFuel",
"mDummyImport",
"mDummyExport",
"mDummyCost",
"mTradeIr",
"mvTradeIrAInp",
"mvTradeIrAInpTot",
"mvTradeIrAOut",
"mvTradeIrAOutTot",
"mImportRow",
"mImportRowUp",
"mImportRowAccumulatedUp",
"mExportRow",
"mExportRowUp",
"mExportRowAccumulatedUp",
"mExport",
"mImport",
"mStorageInpTot",
"mStorageOutTot",
"mTaxCost",
"mSubsCost",
"mAggOut",
"mTechAfUp",
"mTechOlifeInf",
"mStorageOlifeInf",
"mTechAfcUp",
"mSupAvaUp",
"mSupAva",
"mSupReserveUp",
"mOut2Lo",
"mInp2Lo",
"meqTechRetirementNewCap",
"meqTechSng2Sng",
"meqTechGrp2Sng",
"meqTechSng2Grp",
"meqTechGrp2Grp",
"meqTechShareInpLo",
"meqTechShareInpUp",
"meqTechShareOutLo",
"meqTechShareOutUp",
"meqTechAfLo",
"meqTechAfUp",
"meqTechAfsLo",
"meqTechAfsUp",
"meqTechActSng",
"meqTechActGrp",
"meqTechAfcOutLo",
"meqTechAfcOutUp",
"meqTechAfcInpLo",
"meqTechAfcInpUp",
"meqSupAvaLo",
"meqSupReserveLo",
"meqStorageAfLo",
"meqStorageAfUp",
"meqStorageInpUp",
"meqStorageInpLo",
"meqStorageOutUp",
"meqStorageOutLo",
"meqTradeFlowUp",
"meqTradeFlowLo",
"meqExportRowLo",
"meqImportRowUp",
"meqImportRowLo",
"meqTradeCapFlow",
"meqBalLo",
"meqBalUp",
"meqBalFx",
"meqLECActivity",
"mLECRegion",
"ordYear",
"cardYear",
"pPeriodLen",
"pSliceShare",
"pAggregateFactor",
"pTechOlife",
"pTechCinp2ginp",
"pTechGinp2use",
"pTechCinp2use",
"pTechUse2cact",
"pTechCact2cout",
"pTechEmisComm",
"pTechAct2AInp",
"pTechCap2AInp",
"pTechNCap2AInp",
"pTechCinp2AInp",
"pTechCout2AInp",
"pTechAct2AOut",
"pTechCap2AOut",
"pTechNCap2AOut",
"pTechCinp2AOut",
"pTechCout2AOut",
"pTechFixom",
"pTechVarom",
"pTechInvcost",
"pTechEac",
"pTechShareLo",
"pTechShareUp",
"pTechAfLo",
"pTechAfUp",
"pTechAfsLo",
"pTechAfsUp",
"pTechAfcLo",
"pTechAfcUp",
"pTechStock",
"pTechCap2act",
"pTechCvarom",
"pTechAvarom",
"pDiscount",
"pDiscountFactor",
"pDiscountFactorMileStone",
"pSupCost",
"pSupAvaUp",
"pSupAvaLo",
"pSupReserveUp",
"pSupReserveLo",
"pDemand",
"pEmissionFactor",
"pDummyImportCost",
"pDummyExportCost",
"pTaxCost",
"pSubsCost",
"pWeather",
"pSupWeatherLo",
"pSupWeatherUp",
"pTechWeatherAfLo",
"pTechWeatherAfUp",
"pTechWeatherAfsLo",
"pTechWeatherAfsUp",
"pTechWeatherAfcLo",
"pTechWeatherAfcUp",
"pStorageWeatherAfUp",
"pStorageWeatherAfLo",
"pStorageWeatherCinpUp",
"pStorageWeatherCinpLo",
"pStorageWeatherCoutUp",
"pStorageWeatherCoutLo",
"pStorageInpEff",
"pStorageOutEff",
"pStorageStgEff",
"pStorageStock",
"pStorageOlife",
"pStorageCostStore",
"pStorageCostInp",
"pStorageCostOut",
"pStorageFixom",
"pStorageInvcost",
"pStorageEac",
"pStorageCap2stg",
"pStorageAfLo",
"pStorageAfUp",
"pStorageCinpUp",
"pStorageCinpLo",
"pStorageCoutUp",
"pStorageCoutLo",
"pStorageNCap2Stg",
"pStorageCharge",
"pStorageStg2AInp",
"pStorageStg2AOut",
"pStorageInp2AInp",
"pStorageInp2AOut",
"pStorageOut2AInp",
"pStorageOut2AOut",
"pStorageCap2AInp",
"pStorageCap2AOut",
"pStorageNCap2AInp",
"pStorageNCap2AOut",
"pTradeIrEff",
"pTradeIrUp",
"pTradeIrLo",
"pTradeIrCost",
"pTradeIrMarkup",
"pTradeIrCsrc2Ainp",
"pTradeIrCsrc2Aout",
"pTradeIrCdst2Ainp",
"pTradeIrCdst2Aout",
"pExportRowRes",
"pExportRowUp",
"pExportRowLo",
"pExportRowPrice",
"pImportRowRes",
"pImportRowUp",
"pImportRowLo",
"pImportRowPrice",
"pTradeStock",
"pTradeOlife",
"pTradeInvcost",
"pTradeEac",
"pTradeCap2Act",
"paTechWeatherAfLo",
"paTechWeatherAfUp",
"paTechWeatherAfsLo",
"paTechWeatherAfsUp",
"paTechWeatherAfcLo",
"paTechWeatherAfcUp",
"paSupWeatherUp",
"paSupWeatherLo",
"paStorageWeatherAfLo",
"paStorageWeatherAfUp",
"paStorageWeatherCinpUp",
"paStorageWeatherCinpLo",
"paStorageWeatherCoutUp",
"paStorageWeatherCoutLo",
"pLECLoACT");
    rs["tech", c("name", "description", "type")] <- c("tech", "technology", "set");
    rs["tech", c("eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechCap", "eqTechRetirementNewCap", "eqTechRetirementStock", "eqTechEac", "eqTechInv", "eqTechOMCost", "eqEmsFuelTot", "eqTechInpTot", "eqTechOutTot", "eqCost", "eqLECActivity")] <- TRUE;
    rs["sup", c("name", "description", "type")] <- c("sup", "supply", "set");
    rs["sup", c("eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupReserveUp", "eqSupReserveLo", "eqSupCost", "eqSupOutTot", "eqCost")] <- TRUE;
    rs["dem", c("name", "description", "type")] <- c("dem", "demand", "set");
    rs["dem", c("eqDemInp")] <- TRUE;
    rs["stg", c("name", "description", "type")] <- c("stg", "storage", "set");
    rs["stg", c("eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCap", "eqStorageInv", "eqStorageEac", "eqStorageCost", "eqStorageInpTot", "eqStorageOutTot", "eqCost")] <- TRUE;
    rs["expp", c("name", "description", "type")] <- c("expp", "export to the rest of the world (ROW)", "map");
    rs["expp", c("eqExport", "eqCostRowTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative", "eqExportRowResUp")] <- TRUE;
    rs["imp", c("name", "description", "type")] <- c("imp", "import from the rest of the world", "set");
    rs["imp", c("eqImport", "eqCostRowTrade", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated", "eqImportRowResUp")] <- TRUE;
    rs["trade", c("name", "description", "type")] <- c("trade", "trade between regions", "set");
    rs["trade", c("eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostIrTrade", "eqTradeCap", "eqTradeInv", "eqTradeEac", "eqTradeCapFlow", "eqTradeIrAInp", "eqTradeIrAOut", "eqTradeIrAInpTot", "eqTradeIrAOutTot")] <- TRUE;
    rs["group", c("name", "description", "type")] <- c("group", "group of input or output commodities in technology", "set");
    rs["group", c("eqTechGrp2Sng", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechActGrp")] <- TRUE;
    rs["comm", c("name", "description", "type")] <- c("comm", "commodity", "set");
    rs["comm", c("eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechOMCost", "eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupReserveUp", "eqSupReserveLo", "eqSupCost", "eqDemInp", "eqAggOut", "eqEmsFuelTot", "eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCost", "eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostRowTrade", "eqCostIrTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative", "eqExportRowResUp", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated", "eqImportRowResUp", "eqTradeCapFlow", "eqTradeIrAInp", "eqTradeIrAOut", "eqTradeIrAInpTot", "eqTradeIrAOutTot", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal", "eqOutTot", "eqInpTot", "eqInp2Lo", "eqOut2Lo", "eqSupOutTot", "eqTechInpTot", "eqTechOutTot", "eqStorageInpTot", "eqStorageOutTot", "eqCost", "eqTaxCost", "eqSubsCost")] <- TRUE;
    rs["region", c("name", "description", "type")] <- c("region", "region", "set");
    rs["region", c("eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechCap", "eqTechRetirementNewCap", "eqTechRetirementStock", "eqTechEac", "eqTechInv", "eqTechOMCost", "eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupReserveUp", "eqSupReserveLo", "eqSupCost", "eqDemInp", "eqAggOut", "eqEmsFuelTot", "eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCap", "eqStorageInv", "eqStorageEac", "eqStorageCost", "eqCostTrade", "eqCostRowTrade", "eqCostIrTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated", "eqTradeInv", "eqTradeEac", "eqTradeIrAInp", "eqTradeIrAOut", "eqTradeIrAInpTot", "eqTradeIrAOutTot", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal", "eqOutTot", "eqInpTot", "eqInp2Lo", "eqOut2Lo", "eqSupOutTot", "eqTechInpTot", "eqTechOutTot", "eqStorageInpTot", "eqStorageOutTot", "eqCost", "eqTaxCost", "eqSubsCost", "eqObjective", "eqLECActivity")] <- TRUE;
    rs["year", c("name", "description", "type")] <- c("year", "year", "set");
    rs["year", c("eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechCap", "eqTechRetirementNewCap", "eqTechRetirementStock", "eqTechEac", "eqTechInv", "eqTechOMCost", "eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupCost", "eqDemInp", "eqAggOut", "eqEmsFuelTot", "eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCap", "eqStorageInv", "eqStorageEac", "eqStorageCost", "eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostTrade", "eqCostRowTrade", "eqCostIrTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated", "eqTradeCap", "eqTradeInv", "eqTradeEac", "eqTradeCapFlow", "eqTradeIrAInp", "eqTradeIrAOut", "eqTradeIrAInpTot", "eqTradeIrAOutTot", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal", "eqOutTot", "eqInpTot", "eqInp2Lo", "eqOut2Lo", "eqSupOutTot", "eqTechInpTot", "eqTechOutTot", "eqStorageInpTot", "eqStorageOutTot", "eqCost", "eqTaxCost", "eqSubsCost", "eqObjective", "eqLECActivity")] <- TRUE;
    rs["slice", c("name", "description", "type")] <- c("slice", "time slice", "set");
    rs["slice", c("eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqTechOMCost", "eqSupAvaUp", "eqSupAvaLo", "eqSupTotal", "eqSupCost", "eqDemInp", "eqAggOut", "eqEmsFuelTot", "eqStorageStore", "eqStorageAfLo", "eqStorageAfUp", "eqStorageClean", "eqStorageAInp", "eqStorageAOut", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqStorageCost", "eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostRowTrade", "eqCostIrTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowCumulative", "eqImportRowUp", "eqImportRowLo", "eqImportRowAccumulated", "eqTradeCapFlow", "eqTradeIrAInp", "eqTradeIrAOut", "eqTradeIrAInpTot", "eqTradeIrAOutTot", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal", "eqOutTot", "eqInpTot", "eqInp2Lo", "eqOut2Lo", "eqSupOutTot", "eqTechInpTot", "eqTechOutTot", "eqStorageInpTot", "eqStorageOutTot", "eqCost", "eqTaxCost", "eqSubsCost", "eqLECActivity")] <- TRUE;
    rs["weather", c("name", "description", "type")] <- c("weather", "weather", "set");
    rs["mSameRegion", c("name", "description", "type")] <- c("mSameRegion", "The same region (used in GLPK)", "map");
    rs["mSameRegion", c("region")] <- TRUE;
    rs["mSameSlice", c("name", "description", "type")] <- c("mSameSlice", "The same slice (used in GLPK)", "map");
    rs["mSameSlice", c("slice")] <- TRUE;
    rs["mMilestoneFirst", c("name", "description", "type")] <- c("mMilestoneFirst", "First period milestone", "map");
    rs["mMilestoneFirst", c("year")] <- TRUE;
    rs["mMilestoneLast", c("name", "description", "type")] <- c("mMilestoneLast", "Last period milestone", "map");
    rs["mMilestoneLast", c("year")] <- TRUE;
    rs["mMilestoneNext", c("name", "description", "type")] <- c("mMilestoneNext", "Next period milestone", "map");
    rs["mMilestoneNext", c("year")] <- TRUE;
    rs["mMilestoneHasNext", c("name", "description", "type")] <- c("mMilestoneHasNext", "Is there next period milestone", "map");
    rs["mMilestoneHasNext", c("year")] <- TRUE;
    rs["mStartMilestone", c("name", "description", "type")] <- c("mStartMilestone", "Start of the period", "map");
    rs["mStartMilestone", c("year")] <- TRUE;
    rs["mEndMilestone", c("name", "description", "type")] <- c("mEndMilestone", "End of the period", "map");
    rs["mEndMilestone", c("year")] <- TRUE;
    rs["mMidMilestone", c("name", "description", "type")] <- c("mMidMilestone", "Milestone year", "map");
    rs["mMidMilestone", c("year")] <- TRUE;
    rs["mCommSlice", c("name", "description", "type")] <- c("mCommSlice", "Commodity to slice", "map");
    rs["mCommSlice", c("comm", "slice", "eqStorageStore", "eqStorageCost", "eqSubsCost")] <- TRUE;
    rs["mCommSliceOrParent", c("name", "description", "type")] <- c("mCommSliceOrParent", "", "map");
    rs["mCommSliceOrParent", c("comm", "slice", "eqEmsFuelTot", "eqImport", "eqExport", "eqTradeIrAInpTot", "eqTradeIrAOutTot", "eqSupOutTot")] <- TRUE;
    rs["mTechRetirement", c("name", "description", "type")] <- c("mTechRetirement", "Early retirement option", "map");
    rs["mTechRetirement", c("tech")] <- TRUE;
    rs["mTechUpgrade", c("name", "description", "type")] <- c("mTechUpgrade", "Upgrade technology (not implemented yet)", "map");
    rs["mTechUpgrade", c("tech")] <- TRUE;
    rs["mTechInpComm", c("name", "description", "type")] <- c("mTechInpComm", "Input commodity", "map");
    rs["mTechInpComm", c("tech", "comm", "eqTechOMCost", "eqEmsFuelTot", "eqTechInpTot")] <- TRUE;
    rs["mTechOutComm", c("name", "description", "type")] <- c("mTechOutComm", "Output commodity", "map");
    rs["mTechOutComm", c("tech", "comm", "eqTechOMCost", "eqTechOutTot")] <- TRUE;
    rs["mTechInpGroup", c("name", "description", "type")] <- c("mTechInpGroup", "Group input", "map");
    rs["mTechInpGroup", c("tech", "group")] <- TRUE;
    rs["mTechOutGroup", c("name", "description", "type")] <- c("mTechOutGroup", "Group output", "map");
    rs["mTechOutGroup", c("tech", "group")] <- TRUE;
    rs["mTechOneComm", c("name", "description", "type")] <- c("mTechOneComm", "Commodity without group", "map");
    rs["mTechOneComm", c("tech", "comm")] <- TRUE;
    rs["mTechGroupComm", c("name", "description", "type")] <- c("mTechGroupComm", "Mapping between commodity-groups and commodities", "map");
    rs["mTechGroupComm", c("tech", "group", "comm", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechActGrp")] <- TRUE;
    rs["mTechAInp", c("name", "description", "type")] <- c("mTechAInp", "Auxiliary input", "map");
    rs["mTechAInp", c("tech", "comm", "eqTechInpTot")] <- TRUE;
    rs["mTechAOut", c("name", "description", "type")] <- c("mTechAOut", "Auxiliary output", "map");
    rs["mTechAOut", c("tech", "comm", "eqTechOutTot")] <- TRUE;
    rs["mTechNew", c("name", "description", "type")] <- c("mTechNew", "Technologies available for investment", "map");
    rs["mTechNew", c("tech", "region", "year", "eqTechAInp", "eqTechAOut", "eqTechCap", "eqTechEac", "eqTechInv")] <- TRUE;
    rs["mTechSpan", c("name", "description", "type")] <- c("mTechSpan", "Availability of each technology by regions and milestone years", "map");
    rs["mTechSpan", c("tech", "region", "year", "eqTechCap")] <- TRUE;
    rs["mTechSlice", c("name", "description", "type")] <- c("mTechSlice", "Technology to slice-level", "map");
    rs["mTechSlice", c("tech", "slice", "eqTechOMCost", "eqTechInpTot", "eqTechOutTot", "eqLECActivity")] <- TRUE;
    rs["mSupSlice", c("name", "description", "type")] <- c("mSupSlice", "Supply to slices-level", "map");
    rs["mSupSlice", c("sup", "slice")] <- TRUE;
    rs["mSupComm", c("name", "description", "type")] <- c("mSupComm", "Supplied commodities", "map");
    rs["mSupComm", c("sup", "comm", "eqSupOutTot")] <- TRUE;
    rs["mSupSpan", c("name", "description", "type")] <- c("mSupSpan", "Supply in regions", "map");
    rs["mSupSpan", c("sup", "region")] <- TRUE;
    rs["mSupWeatherLo", c("name", "description", "type")] <- c("mSupWeatherLo", "Use weather to supply ava.lo", "map");
    rs["mSupWeatherLo", c("sup", "weather")] <- TRUE;
    rs["mSupWeatherUp", c("name", "description", "type")] <- c("mSupWeatherUp", "Use weather to supply ava.up", "map");
    rs["mSupWeatherUp", c("sup", "weather")] <- TRUE;
    rs["mWeatherSlice", c("name", "description", "type")] <- c("mWeatherSlice", "Weather slice", "map");
    rs["mWeatherSlice", c("slice", "weather")] <- TRUE;
    rs["mWeatherRegion", c("name", "description", "type")] <- c("mWeatherRegion", "Weather region", "map");
    rs["mWeatherRegion", c("region", "weather")] <- TRUE;
    rs["mDemComm", c("name", "description", "type")] <- c("mDemComm", "Demand commodities", "map");
    rs["mDemComm", c("dem", "comm", "eqDemInp")] <- TRUE;
    rs["mUpComm", c("name", "description", "type")] <- c("mUpComm", "Commodity balance type PRODUCTION <= CONSUMPTION", "map");
    rs["mUpComm", c("comm")] <- TRUE;
    rs["mLoComm", c("name", "description", "type")] <- c("mLoComm", "Commodity balance type PRODUCTION >= CONSUMPTION", "map");
    rs["mLoComm", c("comm")] <- TRUE;
    rs["mFxComm", c("name", "description", "type")] <- c("mFxComm", "Commodity balance type PRODUCTION == CONSUMPTION", "map");
    rs["mFxComm", c("comm")] <- TRUE;
    rs["mStorageFullYear", c("name", "description", "type")] <- c("mStorageFullYear", "Mapping of storage with joint slice", "map");
    rs["mStorageFullYear", c("stg", "eqStorageStore")] <- TRUE;
    rs["mStorageComm", c("name", "description", "type")] <- c("mStorageComm", "Mapping of storage technology and respective commodity", "map");
    rs["mStorageComm", c("stg", "comm", "eqStorageAInp", "eqStorageAOut", "eqStorageCost")] <- TRUE;
    rs["mStorageAInp", c("name", "description", "type")] <- c("mStorageAInp", "Aux-commodity input to storage", "map");
    rs["mStorageAInp", c("stg", "comm")] <- TRUE;
    rs["mStorageAOut", c("name", "description", "type")] <- c("mStorageAOut", "Aux-commodity output from storage", "map");
    rs["mStorageAOut", c("stg", "comm")] <- TRUE;
    rs["mStorageNew", c("name", "description", "type")] <- c("mStorageNew", "Storage available for investment", "map");
    rs["mStorageNew", c("stg", "region", "year", "eqStorageStore", "eqStorageAInp", "eqStorageAOut", "eqStorageInv", "eqStorageEac")] <- TRUE;
    rs["mStorageSpan", c("name", "description", "type")] <- c("mStorageSpan", "Storage set showing if the storage may exist in the year and region", "map");
    rs["mStorageSpan", c("stg", "region", "year", "eqStorageCap")] <- TRUE;
    rs["mStorageOMCost", c("name", "description", "type")] <- c("mStorageOMCost", "", "map");
    rs["mStorageOMCost", c("stg", "region", "year", "eqStorageCost", "eqCost")] <- TRUE;
    rs["mStorageEac", c("name", "description", "type")] <- c("mStorageEac", "", "map");
    rs["mStorageEac", c("stg", "region", "year", "eqStorageEac", "eqCost")] <- TRUE;
    rs["mSliceNext", c("name", "description", "type")] <- c("mSliceNext", "Next slice", "map");
    rs["mSliceNext", c("slice")] <- TRUE;
    rs["mSliceFYearNext", c("name", "description", "type")] <- c("mSliceFYearNext", "Next slice joint", "map");
    rs["mSliceFYearNext", c("slice")] <- TRUE;
    rs["mTradeSlice", c("name", "description", "type")] <- c("mTradeSlice", "Trade to slice", "map");
    rs["mTradeSlice", c("trade", "slice", "eqCostIrTrade")] <- TRUE;
    rs["mTradeComm", c("name", "description", "type")] <- c("mTradeComm", "Trade commodities", "map");
    rs["mTradeComm", c("trade", "comm", "eqImport", "eqExport", "eqCostIrTrade", "eqTradeIrAInp", "eqTradeIrAOut")] <- TRUE;
    rs["mTradeRoutes", c("name", "description", "type")] <- c("mTradeRoutes", "", "map");
    rs["mTradeRoutes", c("trade", "region", "eqImport", "eqExport", "eqCostIrTrade")] <- TRUE;
    rs["mTradeIrAInp", c("name", "description", "type")] <- c("mTradeIrAInp", "Auxiliary input commodity in source region", "map");
    rs["mTradeIrAInp", c("trade", "comm")] <- TRUE;
    rs["mTradeIrAOut", c("name", "description", "type")] <- c("mTradeIrAOut", "Auxiliary output commodity in source region", "map");
    rs["mTradeIrAOut", c("trade", "comm")] <- TRUE;
    rs["mExpComm", c("name", "description", "type")] <- c("mExpComm", "Export commodities", "map");
    rs["mExpComm", c("expp", "comm", "eqExport", "eqExportRowCumulative")] <- TRUE;
    rs["mImpComm", c("name", "description", "type")] <- c("mImpComm", "Import commodities", "map");
    rs["mImpComm", c("imp", "comm", "eqImport", "eqImportRowAccumulated")] <- TRUE;
    rs["mExpSlice", c("name", "description", "type")] <- c("mExpSlice", "Export to slice", "map");
    rs["mExpSlice", c("expp", "slice")] <- TRUE;
    rs["mImpSlice", c("name", "description", "type")] <- c("mImpSlice", "Import to slice", "map");
    rs["mImpSlice", c("imp", "slice")] <- TRUE;
    rs["mDiscountZero", c("name", "description", "type")] <- c("mDiscountZero", "", "map");
    rs["mDiscountZero", c("region")] <- TRUE;
    rs["mSliceParentChildE", c("name", "description", "type")] <- c("mSliceParentChildE", "Child slice or the same", "map");
    rs["mSliceParentChildE", c("slice", "eqTechAfsLo", "eqTechAfsUp")] <- TRUE;
    rs["mSliceParentChild", c("name", "description", "type")] <- c("mSliceParentChild", "Child slice not the same", "map");
    rs["mSliceParentChild", c("slice", "eqOutTot", "eqInpTot")] <- TRUE;
    rs["mTechWeatherAf", c("name", "description", "type")] <- c("mTechWeatherAf", "", "map");
    rs["mTechWeatherAf", c("tech", "weather")] <- TRUE;
    rs["mTechWeatherAfs", c("name", "description", "type")] <- c("mTechWeatherAfs", "", "map");
    rs["mTechWeatherAfs", c("tech", "weather")] <- TRUE;
    rs["mTechWeatherAfc", c("name", "description", "type")] <- c("mTechWeatherAfc", "", "map");
    rs["mTechWeatherAfc", c("tech", "comm", "weather")] <- TRUE;
    rs["mStorageWeatherAf", c("name", "description", "type")] <- c("mStorageWeatherAf", "", "map");
    rs["mStorageWeatherAf", c("stg", "weather")] <- TRUE;
    rs["mStorageWeatherCinp", c("name", "description", "type")] <- c("mStorageWeatherCinp", "", "map");
    rs["mStorageWeatherCinp", c("stg", "weather")] <- TRUE;
    rs["mStorageWeatherCout", c("name", "description", "type")] <- c("mStorageWeatherCout", "", "map");
    rs["mStorageWeatherCout", c("stg", "weather")] <- TRUE;
    rs["mTradeSpan", c("name", "description", "type")] <- c("mTradeSpan", "", "map");
    rs["mTradeSpan", c("trade", "year", "eqTradeCap")] <- TRUE;
    rs["mTradeNew", c("name", "description", "type")] <- c("mTradeNew", "", "map");
    rs["mTradeNew", c("trade", "year", "eqTradeCap", "eqTradeEac")] <- TRUE;
    rs["mTradeOlifeInf", c("name", "description", "type")] <- c("mTradeOlifeInf", "", "map");
    rs["mTradeOlifeInf", c("trade")] <- TRUE;
    rs["mTradeEac", c("name", "description", "type")] <- c("mTradeEac", "", "map");
    rs["mTradeEac", c("trade", "region", "year", "eqCostIrTrade", "eqTradeEac")] <- TRUE;
    rs["mTradeCapacityVariable", c("name", "description", "type")] <- c("mTradeCapacityVariable", "", "map");
    rs["mTradeCapacityVariable", c("trade")] <- TRUE;
    rs["mTradeInv", c("name", "description", "type")] <- c("mTradeInv", "", "map");
    rs["mTradeInv", c("trade", "region", "year", "eqTradeInv")] <- TRUE;
    rs["mAggregateFactor", c("name", "description", "type")] <- c("mAggregateFactor", "", "map");
    rs["mAggregateFactor", c("comm", "eqAggOut")] <- TRUE;
    rs["mvSupCost", c("name", "description", "type")] <- c("mvSupCost", "", "map");
    rs["mvSupCost", c("sup", "region", "year", "eqSupCost", "eqCost")] <- TRUE;
    rs["mvTechInp", c("name", "description", "type")] <- c("mvTechInp", "", "map");
    rs["mvTechInp", c("tech", "comm", "region", "year", "slice", "eqTechGrp2Sng", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechInpTot")] <- TRUE;
    rs["mvSupReserve", c("name", "description", "type")] <- c("mvSupReserve", "", "map");
    rs["mvSupReserve", c("sup", "comm", "region", "eqSupTotal")] <- TRUE;
    rs["mvTechRetirementNewCap", c("name", "description", "type")] <- c("mvTechRetirementNewCap", "", "map");
    rs["mvTechRetirementNewCap", c("tech", "region", "year", "eqTechCap", "eqTechRetirementNewCap", "eqTechEac")] <- TRUE;
    rs["mvTechRetirementStock", c("name", "description", "type")] <- c("mvTechRetirementStock", "", "map");
    rs["mvTechRetirementStock", c("tech", "region", "year", "eqTechCap", "eqTechRetirementStock")] <- TRUE;
    rs["mvTechAct", c("name", "description", "type")] <- c("mvTechAct", "", "map");
    rs["mvTechAct", c("tech", "region", "year", "slice", "eqTechAfsLo", "eqTechAfsUp")] <- TRUE;
    rs["mvTechOut", c("name", "description", "type")] <- c("mvTechOut", "", "map");
    rs["mvTechOut", c("tech", "comm", "region", "year", "slice", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechActGrp", "eqTechOutTot")] <- TRUE;
    rs["mvTechAInp", c("name", "description", "type")] <- c("mvTechAInp", "", "map");
    rs["mvTechAInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp", "eqTechOMCost", "eqTechInpTot")] <- TRUE;
    rs["mvTechAOut", c("name", "description", "type")] <- c("mvTechAOut", "", "map");
    rs["mvTechAOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut", "eqTechOMCost", "eqTechOutTot")] <- TRUE;
    rs["mvDemInp", c("name", "description", "type")] <- c("mvDemInp", "", "map");
    rs["mvDemInp", c("comm", "region", "year", "slice", "eqDemInp", "eqInpTot")] <- TRUE;
    rs["mvBalance", c("name", "description", "type")] <- c("mvBalance", "", "map");
    rs["mvBalance", c("comm", "region", "year", "slice", "eqBal")] <- TRUE;
    rs["mvInpTot", c("name", "description", "type")] <- c("mvInpTot", "", "map");
    rs["mvInpTot", c("comm", "region", "year", "slice", "eqBal", "eqInpTot")] <- TRUE;
    rs["mvOutTot", c("name", "description", "type")] <- c("mvOutTot", "", "map");
    rs["mvOutTot", c("comm", "region", "year", "slice", "eqAggOut", "eqBal", "eqOutTot", "eqTaxCost")] <- TRUE;
    rs["mvInp2Lo", c("name", "description", "type")] <- c("mvInp2Lo", "", "map");
    rs["mvInp2Lo", c("comm", "region", "year", "slice", "eqInp2Lo")] <- TRUE;
    rs["mvOut2Lo", c("name", "description", "type")] <- c("mvOut2Lo", "", "map");
    rs["mvOut2Lo", c("comm", "region", "year", "slice", "eqOut2Lo")] <- TRUE;
    rs["mInpSub", c("name", "description", "type")] <- c("mInpSub", "For increase speed eqInpTot", "map");
    rs["mInpSub", c("comm", "region", "year", "slice", "eqInpTot")] <- TRUE;
    rs["mOutSub", c("name", "description", "type")] <- c("mOutSub", "For increase speed eqOutTot", "map");
    rs["mOutSub", c("comm", "region", "year", "slice", "eqOutTot")] <- TRUE;
    rs["mvStorageAInp", c("name", "description", "type")] <- c("mvStorageAInp", "", "map");
    rs["mvStorageAInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp", "eqStorageInpTot")] <- TRUE;
    rs["mvStorageAOut", c("name", "description", "type")] <- c("mvStorageAOut", "", "map");
    rs["mvStorageAOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut", "eqStorageOutTot")] <- TRUE;
    rs["mvStorageStore", c("name", "description", "type")] <- c("mvStorageStore", "", "map");
    rs["mvStorageStore", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageClean", "eqStorageInpTot", "eqStorageOutTot")] <- TRUE;
    rs["mvTradeIr", c("name", "description", "type")] <- c("mvTradeIr", "", "map");
    rs["mvTradeIr", c("trade", "comm", "region", "year", "slice", "eqImport", "eqExport", "eqCostIrTrade", "eqTradeCapFlow")] <- TRUE;
    rs["mvTradeCost", c("name", "description", "type")] <- c("mvTradeCost", "", "map");
    rs["mvTradeCost", c("region", "year", "eqCostTrade", "eqCost")] <- TRUE;
    rs["mvTradeRowCost", c("name", "description", "type")] <- c("mvTradeRowCost", "", "map");
    rs["mvTradeRowCost", c("region", "year", "eqCostTrade", "eqCostRowTrade")] <- TRUE;
    rs["mvTradeIrCost", c("name", "description", "type")] <- c("mvTradeIrCost", "", "map");
    rs["mvTradeIrCost", c("region", "year", "eqCostTrade", "eqCostIrTrade")] <- TRUE;
    rs["mvTotalCost", c("name", "description", "type")] <- c("mvTotalCost", "", "map");
    rs["mvTotalCost", c("region", "year", "eqCost", "eqObjective")] <- TRUE;
    rs["mTechInpTot", c("name", "description", "type")] <- c("mTechInpTot", "Total technology input mapp", "map");
    rs["mTechInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqInp2Lo", "eqTechInpTot")] <- TRUE;
    rs["mTechOutTot", c("name", "description", "type")] <- c("mTechOutTot", "Total technology output mapp", "map");
    rs["mTechOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqTechOutTot")] <- TRUE;
    rs["mTechEac", c("name", "description", "type")] <- c("mTechEac", "", "map");
    rs["mTechEac", c("tech", "region", "year", "eqTechEac", "eqCost")] <- TRUE;
    rs["mTechOMCost", c("name", "description", "type")] <- c("mTechOMCost", "", "map");
    rs["mTechOMCost", c("tech", "region", "year", "eqTechOMCost", "eqCost")] <- TRUE;
    rs["mSupOutTot", c("name", "description", "type")] <- c("mSupOutTot", "", "map");
    rs["mSupOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqSupOutTot")] <- TRUE;
    rs["mDemInp", c("name", "description", "type")] <- c("mDemInp", "", "map");
    rs["mDemInp", c("comm", "slice")] <- TRUE;
    rs["mEmsFuelTot", c("name", "description", "type")] <- c("mEmsFuelTot", "", "map");
    rs["mEmsFuelTot", c("comm", "region", "year", "slice", "eqEmsFuelTot", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["mTechEmsFuel", c("name", "description", "type")] <- c("mTechEmsFuel", "", "map");
    rs["mTechEmsFuel", c("tech", "comm", "region", "year", "slice", "eqEmsFuelTot")] <- TRUE;
    rs["mDummyImport", c("name", "description", "type")] <- c("mDummyImport", "", "map");
    rs["mDummyImport", c("comm", "region", "year", "slice", "eqOutTot", "eqCost")] <- TRUE;
    rs["mDummyExport", c("name", "description", "type")] <- c("mDummyExport", "", "map");
    rs["mDummyExport", c("comm", "region", "year", "slice", "eqInpTot", "eqCost")] <- TRUE;
    rs["mDummyCost", c("name", "description", "type")] <- c("mDummyCost", "", "map");
    rs["mDummyCost", c("comm", "region", "year")] <- TRUE;
    rs["mTradeIr", c("name", "description", "type")] <- c("mTradeIr", "", "map");
    rs["mTradeIr", c("trade", "region", "year", "slice", "eqTradeIrAInp", "eqTradeIrAOut")] <- TRUE;
    rs["mvTradeIrAInp", c("name", "description", "type")] <- c("mvTradeIrAInp", "", "map");
    rs["mvTradeIrAInp", c("trade", "comm", "region", "year", "slice", "eqTradeIrAInp")] <- TRUE;
    rs["mvTradeIrAInpTot", c("name", "description", "type")] <- c("mvTradeIrAInpTot", "", "map");
    rs["mvTradeIrAInpTot", c("comm", "region", "year", "slice", "eqTradeIrAInpTot", "eqInpTot", "eqInp2Lo")] <- TRUE;
    rs["mvTradeIrAOut", c("name", "description", "type")] <- c("mvTradeIrAOut", "", "map");
    rs["mvTradeIrAOut", c("trade", "comm", "region", "year", "slice", "eqTradeIrAOut")] <- TRUE;
    rs["mvTradeIrAOutTot", c("name", "description", "type")] <- c("mvTradeIrAOutTot", "", "map");
    rs["mvTradeIrAOutTot", c("comm", "region", "year", "slice", "eqTradeIrAOutTot", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["mImportRow", c("name", "description", "type")] <- c("mImportRow", "", "map");
    rs["mImportRow", c("imp", "comm", "region", "year", "slice", "eqImport", "eqCostRowTrade", "eqImportRowAccumulated")] <- TRUE;
    rs["mImportRowUp", c("name", "description", "type")] <- c("mImportRowUp", "", "map");
    rs["mImportRowUp", c("imp", "comm", "region", "year", "slice", "eqImportRowUp")] <- TRUE;
    rs["mImportRowAccumulatedUp", c("name", "description", "type")] <- c("mImportRowAccumulatedUp", "", "map");
    rs["mImportRowAccumulatedUp", c("imp", "comm", "eqImportRowResUp")] <- TRUE;
    rs["mExportRow", c("name", "description", "type")] <- c("mExportRow", "", "map");
    rs["mExportRow", c("expp", "comm", "region", "year", "slice", "eqExport", "eqCostRowTrade", "eqExportRowCumulative")] <- TRUE;
    rs["mExportRowUp", c("name", "description", "type")] <- c("mExportRowUp", "", "map");
    rs["mExportRowUp", c("expp", "comm", "region", "year", "slice", "eqExportRowUp")] <- TRUE;
    rs["mExportRowAccumulatedUp", c("name", "description", "type")] <- c("mExportRowAccumulatedUp", "", "map");
    rs["mExportRowAccumulatedUp", c("expp", "comm", "eqExportRowResUp")] <- TRUE;
    rs["mExport", c("name", "description", "type")] <- c("mExport", "", "map");
    rs["mExport", c("comm", "region", "year", "slice", "eqExport", "eqInpTot", "eqInp2Lo")] <- TRUE;
    rs["mImport", c("name", "description", "type")] <- c("mImport", "", "map");
    rs["mImport", c("comm", "region", "year", "slice", "eqImport", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["mStorageInpTot", c("name", "description", "type")] <- c("mStorageInpTot", "", "map");
    rs["mStorageInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqInp2Lo", "eqStorageInpTot")] <- TRUE;
    rs["mStorageOutTot", c("name", "description", "type")] <- c("mStorageOutTot", "", "map");
    rs["mStorageOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqOut2Lo", "eqStorageOutTot")] <- TRUE;
    rs["mTaxCost", c("name", "description", "type")] <- c("mTaxCost", "", "map");
    rs["mTaxCost", c("comm", "region", "year", "eqCost", "eqTaxCost")] <- TRUE;
    rs["mSubsCost", c("name", "description", "type")] <- c("mSubsCost", "", "map");
    rs["mSubsCost", c("comm", "region", "year", "eqCost", "eqSubsCost")] <- TRUE;
    rs["mAggOut", c("name", "description", "type")] <- c("mAggOut", "", "map");
    rs["mAggOut", c("comm", "region", "year", "slice", "eqAggOut", "eqOutTot", "eqOut2Lo")] <- TRUE;
    rs["mTechAfUp", c("name", "description", "type")] <- c("mTechAfUp", "", "map");
    rs["mTechAfUp", c("tech", "region", "year", "slice")] <- TRUE;
    rs["mTechOlifeInf", c("name", "description", "type")] <- c("mTechOlifeInf", "", "map");
    rs["mTechOlifeInf", c("tech", "region")] <- TRUE;
    rs["mStorageOlifeInf", c("name", "description", "type")] <- c("mStorageOlifeInf", "", "map");
    rs["mStorageOlifeInf", c("stg", "region", "eqStorageCap", "eqStorageEac")] <- TRUE;
    rs["mTechAfcUp", c("name", "description", "type")] <- c("mTechAfcUp", "", "map");
    rs["mTechAfcUp", c("tech", "comm", "region", "year", "slice")] <- TRUE;
    rs["mSupAvaUp", c("name", "description", "type")] <- c("mSupAvaUp", "", "map");
    rs["mSupAvaUp", c("sup", "comm", "region", "year", "slice", "eqSupAvaUp")] <- TRUE;
    rs["mSupAva", c("name", "description", "type")] <- c("mSupAva", "", "map");
    rs["mSupAva", c("sup", "comm", "region", "year", "slice", "eqSupTotal", "eqSupCost")] <- TRUE;
    rs["mSupReserveUp", c("name", "description", "type")] <- c("mSupReserveUp", "", "map");
    rs["mSupReserveUp", c("sup", "comm", "region", "eqSupReserveUp")] <- TRUE;
    rs["mOut2Lo", c("name", "description", "type")] <- c("mOut2Lo", "", "map");
    rs["mOut2Lo", c("comm", "region", "year", "slice", "eqOut2Lo")] <- TRUE;
    rs["mInp2Lo", c("name", "description", "type")] <- c("mInp2Lo", "", "map");
    rs["mInp2Lo", c("comm", "region", "year", "slice", "eqInp2Lo")] <- TRUE;
    rs["meqTechRetirementNewCap", c("name", "description", "type")] <- c("meqTechRetirementNewCap", "", "map");
    rs["meqTechRetirementNewCap", c("tech", "region", "year", "eqTechRetirementNewCap")] <- TRUE;
    rs["meqTechSng2Sng", c("name", "description", "type")] <- c("meqTechSng2Sng", "", "map");
    rs["meqTechSng2Sng", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng")] <- TRUE;
    rs["meqTechGrp2Sng", c("name", "description", "type")] <- c("meqTechGrp2Sng", "", "map");
    rs["meqTechGrp2Sng", c("tech", "group", "comm", "region", "year", "slice", "eqTechGrp2Sng")] <- TRUE;
    rs["meqTechSng2Grp", c("name", "description", "type")] <- c("meqTechSng2Grp", "", "map");
    rs["meqTechSng2Grp", c("tech", "group", "comm", "region", "year", "slice", "eqTechSng2Grp")] <- TRUE;
    rs["meqTechGrp2Grp", c("name", "description", "type")] <- c("meqTechGrp2Grp", "", "map");
    rs["meqTechGrp2Grp", c("tech", "group", "region", "year", "slice", "eqTechGrp2Grp")] <- TRUE;
    rs["meqTechShareInpLo", c("name", "description", "type")] <- c("meqTechShareInpLo", "", "map");
    rs["meqTechShareInpLo", c("tech", "group", "comm", "region", "year", "slice", "eqTechShareInpLo")] <- TRUE;
    rs["meqTechShareInpUp", c("name", "description", "type")] <- c("meqTechShareInpUp", "", "map");
    rs["meqTechShareInpUp", c("tech", "group", "comm", "region", "year", "slice", "eqTechShareInpUp")] <- TRUE;
    rs["meqTechShareOutLo", c("name", "description", "type")] <- c("meqTechShareOutLo", "", "map");
    rs["meqTechShareOutLo", c("tech", "group", "comm", "region", "year", "slice", "eqTechShareOutLo")] <- TRUE;
    rs["meqTechShareOutUp", c("name", "description", "type")] <- c("meqTechShareOutUp", "", "map");
    rs["meqTechShareOutUp", c("tech", "group", "comm", "region", "year", "slice", "eqTechShareOutUp")] <- TRUE;
    rs["meqTechAfLo", c("name", "description", "type")] <- c("meqTechAfLo", "", "map");
    rs["meqTechAfLo", c("tech", "region", "year", "slice", "eqTechAfLo")] <- TRUE;
    rs["meqTechAfUp", c("name", "description", "type")] <- c("meqTechAfUp", "", "map");
    rs["meqTechAfUp", c("tech", "region", "year", "slice", "eqTechAfUp")] <- TRUE;
    rs["meqTechAfsLo", c("name", "description", "type")] <- c("meqTechAfsLo", "", "map");
    rs["meqTechAfsLo", c("tech", "region", "year", "slice", "eqTechAfsLo")] <- TRUE;
    rs["meqTechAfsUp", c("name", "description", "type")] <- c("meqTechAfsUp", "", "map");
    rs["meqTechAfsUp", c("tech", "region", "year", "slice", "eqTechAfsUp")] <- TRUE;
    rs["meqTechActSng", c("name", "description", "type")] <- c("meqTechActSng", "", "map");
    rs["meqTechActSng", c("tech", "comm", "region", "year", "slice", "eqTechActSng")] <- TRUE;
    rs["meqTechActGrp", c("name", "description", "type")] <- c("meqTechActGrp", "", "map");
    rs["meqTechActGrp", c("tech", "group", "region", "year", "slice", "eqTechActGrp")] <- TRUE;
    rs["meqTechAfcOutLo", c("name", "description", "type")] <- c("meqTechAfcOutLo", "", "map");
    rs["meqTechAfcOutLo", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutLo")] <- TRUE;
    rs["meqTechAfcOutUp", c("name", "description", "type")] <- c("meqTechAfcOutUp", "", "map");
    rs["meqTechAfcOutUp", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutUp")] <- TRUE;
    rs["meqTechAfcInpLo", c("name", "description", "type")] <- c("meqTechAfcInpLo", "", "map");
    rs["meqTechAfcInpLo", c("tech", "comm", "region", "year", "slice", "eqTechAfcInpLo")] <- TRUE;
    rs["meqTechAfcInpUp", c("name", "description", "type")] <- c("meqTechAfcInpUp", "", "map");
    rs["meqTechAfcInpUp", c("tech", "comm", "region", "year", "slice", "eqTechAfcInpUp")] <- TRUE;
    rs["meqSupAvaLo", c("name", "description", "type")] <- c("meqSupAvaLo", "", "map");
    rs["meqSupAvaLo", c("sup", "comm", "region", "year", "slice", "eqSupAvaLo")] <- TRUE;
    rs["meqSupReserveLo", c("name", "description", "type")] <- c("meqSupReserveLo", "", "map");
    rs["meqSupReserveLo", c("sup", "comm", "region", "eqSupReserveLo")] <- TRUE;
    rs["meqStorageAfLo", c("name", "description", "type")] <- c("meqStorageAfLo", "", "map");
    rs["meqStorageAfLo", c("stg", "comm", "region", "year", "slice", "eqStorageAfLo")] <- TRUE;
    rs["meqStorageAfUp", c("name", "description", "type")] <- c("meqStorageAfUp", "", "map");
    rs["meqStorageAfUp", c("stg", "comm", "region", "year", "slice", "eqStorageAfUp")] <- TRUE;
    rs["meqStorageInpUp", c("name", "description", "type")] <- c("meqStorageInpUp", "", "map");
    rs["meqStorageInpUp", c("stg", "comm", "region", "year", "slice", "eqStorageInpUp")] <- TRUE;
    rs["meqStorageInpLo", c("name", "description", "type")] <- c("meqStorageInpLo", "", "map");
    rs["meqStorageInpLo", c("stg", "comm", "region", "year", "slice", "eqStorageInpLo")] <- TRUE;
    rs["meqStorageOutUp", c("name", "description", "type")] <- c("meqStorageOutUp", "", "map");
    rs["meqStorageOutUp", c("stg", "comm", "region", "year", "slice", "eqStorageOutUp")] <- TRUE;
    rs["meqStorageOutLo", c("name", "description", "type")] <- c("meqStorageOutLo", "", "map");
    rs["meqStorageOutLo", c("stg", "comm", "region", "year", "slice", "eqStorageOutLo")] <- TRUE;
    rs["meqTradeFlowUp", c("name", "description", "type")] <- c("meqTradeFlowUp", "", "map");
    rs["meqTradeFlowUp", c("trade", "comm", "region", "year", "slice", "eqTradeFlowUp")] <- TRUE;
    rs["meqTradeFlowLo", c("name", "description", "type")] <- c("meqTradeFlowLo", "", "map");
    rs["meqTradeFlowLo", c("trade", "comm", "region", "year", "slice", "eqTradeFlowLo")] <- TRUE;
    rs["meqExportRowLo", c("name", "description", "type")] <- c("meqExportRowLo", "", "map");
    rs["meqExportRowLo", c("expp", "comm", "region", "year", "slice", "eqExportRowLo")] <- TRUE;
    rs["meqImportRowUp", c("name", "description", "type")] <- c("meqImportRowUp", "", "map");
    rs["meqImportRowUp", c("imp", "comm", "region", "year", "slice")] <- TRUE;
    rs["meqImportRowLo", c("name", "description", "type")] <- c("meqImportRowLo", "", "map");
    rs["meqImportRowLo", c("imp", "comm", "region", "year", "slice", "eqImportRowLo")] <- TRUE;
    rs["meqTradeCapFlow", c("name", "description", "type")] <- c("meqTradeCapFlow", "", "map");
    rs["meqTradeCapFlow", c("trade", "comm", "year", "slice", "eqTradeCapFlow")] <- TRUE;
    rs["meqBalLo", c("name", "description", "type")] <- c("meqBalLo", "", "map");
    rs["meqBalLo", c("comm", "region", "year", "slice", "eqBalLo")] <- TRUE;
    rs["meqBalUp", c("name", "description", "type")] <- c("meqBalUp", "", "map");
    rs["meqBalUp", c("comm", "region", "year", "slice", "eqBalUp")] <- TRUE;
    rs["meqBalFx", c("name", "description", "type")] <- c("meqBalFx", "", "map");
    rs["meqBalFx", c("comm", "region", "year", "slice", "eqBalFx")] <- TRUE;
    rs["meqLECActivity", c("name", "description", "type")] <- c("meqLECActivity", "", "map");
    rs["meqLECActivity", c("tech", "region", "year", "eqLECActivity")] <- TRUE;
    rs["mLECRegion", c("name", "description", "type")] <- c("mLECRegion", "", "map");
    rs["mLECRegion", c("region")] <- TRUE;
    rs["ordYear", c("name", "description", "type")] <- c("ordYear", "ord year for GLPK", "parameter");
    rs["ordYear", c("year", "eqTechCap", "eqTechEac", "eqStorageCap", "eqStorageEac", "eqTradeCap", "eqTradeEac")] <- TRUE;
    rs["cardYear", c("name", "description", "type")] <- c("cardYear", "card year for GLPK", "parameter");
    rs["cardYear", c("year")] <- TRUE;
    rs["pPeriodLen", c("name", "description", "type")] <- c("pPeriodLen", "Length of perios for milestone year", "parameter");
    rs["pPeriodLen", c("year", "eqSupTotal", "eqExportRowCumulative", "eqImportRowAccumulated")] <- TRUE;
    rs["pSliceShare", c("name", "description", "type")] <- c("pSliceShare", "Share of slice", "parameter");
    rs["pSliceShare", c("slice", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp", "eqStorageStore", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo", "eqTradeCapFlow")] <- TRUE;
    rs["pAggregateFactor", c("name", "description", "type")] <- c("pAggregateFactor", "Aggregation factor of commodities", "parameter");
    rs["pAggregateFactor", c("comm", "eqAggOut")] <- TRUE;
    rs["pTechOlife", c("name", "description", "type")] <- c("pTechOlife", "Operational life of technologies", "parameter");
    rs["pTechOlife", c("tech", "region", "eqTechCap", "eqTechEac")] <- TRUE;
    rs["pTechCinp2ginp", c("name", "description", "type")] <- c("pTechCinp2ginp", "Multiplier that transforms commodity input into group input", "parameter");
    rs["pTechCinp2ginp", c("tech", "comm", "region", "year", "slice", "eqTechGrp2Sng", "eqTechGrp2Grp")] <- TRUE;
    rs["pTechGinp2use", c("name", "description", "type")] <- c("pTechGinp2use", "Multiplier that transforms group input into use", "parameter");
    rs["pTechGinp2use", c("tech", "group", "region", "year", "slice", "eqTechGrp2Sng", "eqTechGrp2Grp")] <- TRUE;
    rs["pTechCinp2use", c("name", "description", "type")] <- c("pTechCinp2use", "Multiplier that transforms commodity input to use", "parameter");
    rs["pTechCinp2use", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechSng2Grp")] <- TRUE;
    rs["pTechUse2cact", c("name", "description", "type")] <- c("pTechUse2cact", "Multiplier that transforms use to commodity activity", "parameter");
    rs["pTechUse2cact", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp")] <- TRUE;
    rs["pTechCact2cout", c("name", "description", "type")] <- c("pTechCact2cout", "Multiplier that transforms commodity activity to commodity output", "parameter");
    rs["pTechCact2cout", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechActSng", "eqTechActGrp", "eqTechAfcOutLo", "eqTechAfcOutUp")] <- TRUE;
    rs["pTechEmisComm", c("name", "description", "type")] <- c("pTechEmisComm", "Combustion factor for input commodity (from 0 to 1)", "parameter");
    rs["pTechEmisComm", c("tech", "comm", "eqEmsFuelTot")] <- TRUE;
    rs["pTechAct2AInp", c("name", "description", "type")] <- c("pTechAct2AInp", "Multiplier to activity to calculate aux-commodity input", "parameter");
    rs["pTechAct2AInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp")] <- TRUE;
    rs["pTechCap2AInp", c("name", "description", "type")] <- c("pTechCap2AInp", "Multiplier to capacity to calculate aux-commodity input", "parameter");
    rs["pTechCap2AInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp")] <- TRUE;
    rs["pTechNCap2AInp", c("name", "description", "type")] <- c("pTechNCap2AInp", "Multiplier to new-capacity to calculate aux-commodity input", "parameter");
    rs["pTechNCap2AInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp")] <- TRUE;
    rs["pTechCinp2AInp", c("name", "description", "type")] <- c("pTechCinp2AInp", "Multiplier to commodity-input to calculate aux-commodity input", "parameter");
    rs["pTechCinp2AInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp")] <- TRUE;
    rs["pTechCout2AInp", c("name", "description", "type")] <- c("pTechCout2AInp", "Multiplier to commodity-output to calculate aux-commodity input", "parameter");
    rs["pTechCout2AInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp")] <- TRUE;
    rs["pTechAct2AOut", c("name", "description", "type")] <- c("pTechAct2AOut", "Multiplier to activity to calculate aux-commodity output", "parameter");
    rs["pTechAct2AOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut")] <- TRUE;
    rs["pTechCap2AOut", c("name", "description", "type")] <- c("pTechCap2AOut", "Multiplier to capacity to calculate aux-commodity output", "parameter");
    rs["pTechCap2AOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut")] <- TRUE;
    rs["pTechNCap2AOut", c("name", "description", "type")] <- c("pTechNCap2AOut", "Multiplier to new capacity to calculate aux-commodity output", "parameter");
    rs["pTechNCap2AOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut")] <- TRUE;
    rs["pTechCinp2AOut", c("name", "description", "type")] <- c("pTechCinp2AOut", "Multiplier to commodity to calculate aux-commodity output", "parameter");
    rs["pTechCinp2AOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut")] <- TRUE;
    rs["pTechCout2AOut", c("name", "description", "type")] <- c("pTechCout2AOut", "Multiplier to commodity-output to calculate aux-commodity input", "parameter");
    rs["pTechCout2AOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut")] <- TRUE;
    rs["pTechFixom", c("name", "description", "type")] <- c("pTechFixom", "Fixed Operating and maintenance (O&M) costs (per unit of capacity)", "parameter");
    rs["pTechFixom", c("tech", "region", "year", "eqTechOMCost")] <- TRUE;
    rs["pTechVarom", c("name", "description", "type")] <- c("pTechVarom", "Variable O&M costs (per unit of acticity)", "parameter");
    rs["pTechVarom", c("tech", "region", "year", "slice", "eqTechOMCost")] <- TRUE;
    rs["pTechInvcost", c("name", "description", "type")] <- c("pTechInvcost", "Investment costs (per unit of capacity)", "parameter");
    rs["pTechInvcost", c("tech", "region", "year", "eqTechInv")] <- TRUE;
    rs["pTechEac", c("name", "description", "type")] <- c("pTechEac", "Eac coefficient for investment costs (per unit of capacity)", "parameter");
    rs["pTechEac", c("tech", "region", "year", "eqTechEac")] <- TRUE;
    rs["pTechShareLo", c("name", "description", "type")] <- c("pTechShareLo", "Lower bound for share of the commodity in total group input or output", "parameter");
    rs["pTechShareLo", c("tech", "comm", "region", "year", "slice", "eqTechShareInpLo", "eqTechShareOutLo")] <- TRUE;
    rs["pTechShareUp", c("name", "description", "type")] <- c("pTechShareUp", "Upper bound for share of the commodity in total group input or output", "parameter");
    rs["pTechShareUp", c("tech", "comm", "region", "year", "slice", "eqTechShareInpUp", "eqTechShareOutUp")] <- TRUE;
    rs["pTechAfLo", c("name", "description", "type")] <- c("pTechAfLo", "Lower bound for activity for each slice", "parameter");
    rs["pTechAfLo", c("tech", "region", "year", "slice", "eqTechAfLo")] <- TRUE;
    rs["pTechAfUp", c("name", "description", "type")] <- c("pTechAfUp", "Upper bound for activity for each slice", "parameter");
    rs["pTechAfUp", c("tech", "region", "year", "slice", "eqTechAfUp")] <- TRUE;
    rs["pTechAfsLo", c("name", "description", "type")] <- c("pTechAfsLo", "Lower bound for activity for sum over slices", "parameter");
    rs["pTechAfsLo", c("tech", "region", "year", "slice", "eqTechAfsLo")] <- TRUE;
    rs["pTechAfsUp", c("name", "description", "type")] <- c("pTechAfsUp", "Upper bound for activity for sum over slices", "parameter");
    rs["pTechAfsUp", c("tech", "region", "year", "slice", "eqTechAfsUp")] <- TRUE;
    rs["pTechAfcLo", c("name", "description", "type")] <- c("pTechAfcLo", "Lower bound for commodity output", "parameter");
    rs["pTechAfcLo", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutLo", "eqTechAfcInpLo")] <- TRUE;
    rs["pTechAfcUp", c("name", "description", "type")] <- c("pTechAfcUp", "Upper bound for commodity output", "parameter");
    rs["pTechAfcUp", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutUp", "eqTechAfcInpUp")] <- TRUE;
    rs["pTechStock", c("name", "description", "type")] <- c("pTechStock", "Technology capacity stock", "parameter");
    rs["pTechStock", c("tech", "region", "year", "eqTechCap", "eqTechRetirementStock")] <- TRUE;
    rs["pTechCap2act", c("name", "description", "type")] <- c("pTechCap2act", "Technology capacity units to activity units conversion factor", "parameter");
    rs["pTechCap2act", c("tech", "eqTechAfLo", "eqTechAfUp", "eqTechAfsLo", "eqTechAfsUp", "eqTechAfcOutLo", "eqTechAfcOutUp", "eqTechAfcInpLo", "eqTechAfcInpUp")] <- TRUE;
    rs["pTechCvarom", c("name", "description", "type")] <- c("pTechCvarom", "Commodity-specific variable costs (per unit of commodity input or output)", "parameter");
    rs["pTechCvarom", c("tech", "comm", "region", "year", "slice", "eqTechOMCost")] <- TRUE;
    rs["pTechAvarom", c("name", "description", "type")] <- c("pTechAvarom", "Auxilary Commodity-specific variable costs (per unit of commodity input or output)", "parameter");
    rs["pTechAvarom", c("tech", "comm", "region", "year", "slice", "eqTechOMCost")] <- TRUE;
    rs["pDiscount", c("name", "description", "type")] <- c("pDiscount", "Discount rate (can be region and year specific)", "parameter");
    rs["pDiscount", c("region", "year")] <- TRUE;
    rs["pDiscountFactor", c("name", "description", "type")] <- c("pDiscountFactor", "Discount factor (cumulative)", "parameter");
    rs["pDiscountFactor", c("region", "year")] <- TRUE;
    rs["pDiscountFactorMileStone", c("name", "description", "type")] <- c("pDiscountFactorMileStone", "Discount factor (cumulative) sum for MileStone", "parameter");
    rs["pDiscountFactorMileStone", c("region", "year", "eqObjective")] <- TRUE;
    rs["pSupCost", c("name", "description", "type")] <- c("pSupCost", "Costs of supply (price per unit)", "parameter");
    rs["pSupCost", c("sup", "comm", "region", "year", "slice", "eqSupCost")] <- TRUE;
    rs["pSupAvaUp", c("name", "description", "type")] <- c("pSupAvaUp", "Upper bound for supply", "parameter");
    rs["pSupAvaUp", c("sup", "comm", "region", "year", "slice", "eqSupAvaUp")] <- TRUE;
    rs["pSupAvaLo", c("name", "description", "type")] <- c("pSupAvaLo", "Lower bound for supply", "parameter");
    rs["pSupAvaLo", c("sup", "comm", "region", "year", "slice", "eqSupAvaLo")] <- TRUE;
    rs["pSupReserveUp", c("name", "description", "type")] <- c("pSupReserveUp", "Total supply reserve by region Up", "parameter");
    rs["pSupReserveUp", c("sup", "comm", "region", "eqSupReserveUp")] <- TRUE;
    rs["pSupReserveLo", c("name", "description", "type")] <- c("pSupReserveLo", "Total supply reserve by region Lo", "parameter");
    rs["pSupReserveLo", c("sup", "comm", "region", "eqSupReserveLo")] <- TRUE;
    rs["pDemand", c("name", "description", "type")] <- c("pDemand", "Exogenous demand", "parameter");
    rs["pDemand", c("dem", "comm", "region", "year", "slice", "eqDemInp")] <- TRUE;
    rs["pEmissionFactor", c("name", "description", "type")] <- c("pEmissionFactor", "Emission factor", "parameter");
    rs["pEmissionFactor", c("comm", "eqEmsFuelTot")] <- TRUE;
    rs["pDummyImportCost", c("name", "description", "type")] <- c("pDummyImportCost", "Dummy costs parameters (for debugging)", "parameter");
    rs["pDummyImportCost", c("comm", "region", "year", "slice", "eqCost")] <- TRUE;
    rs["pDummyExportCost", c("name", "description", "type")] <- c("pDummyExportCost", "Dummy costs parameters (for debuging)", "parameter");
    rs["pDummyExportCost", c("comm", "region", "year", "slice", "eqCost")] <- TRUE;
    rs["pTaxCost", c("name", "description", "type")] <- c("pTaxCost", "Commodity taxes", "parameter");
    rs["pTaxCost", c("comm", "region", "year", "slice", "eqTaxCost")] <- TRUE;
    rs["pSubsCost", c("name", "description", "type")] <- c("pSubsCost", "Commodity subsidies", "parameter");
    rs["pSubsCost", c("comm", "region", "year", "slice", "eqSubsCost")] <- TRUE;
    rs["pWeather", c("name", "description", "type")] <- c("pWeather", "Weather factor (class weather)", "parameter");
    rs["pWeather", c("region", "year", "slice", "weather")] <- TRUE;
    rs["pSupWeatherLo", c("name", "description", "type")] <- c("pSupWeatherLo", "Weather multiplier for supply ava.lo", "parameter");
    rs["pSupWeatherLo", c("sup", "weather")] <- TRUE;
    rs["pSupWeatherUp", c("name", "description", "type")] <- c("pSupWeatherUp", "Weather multiplier for supply ava.up", "parameter");
    rs["pSupWeatherUp", c("sup", "weather")] <- TRUE;
    rs["pTechWeatherAfLo", c("name", "description", "type")] <- c("pTechWeatherAfLo", "Weather multiplier for tech af.lo", "parameter");
    rs["pTechWeatherAfLo", c("tech", "weather")] <- TRUE;
    rs["pTechWeatherAfUp", c("name", "description", "type")] <- c("pTechWeatherAfUp", "Weather multiplier for tech af.up", "parameter");
    rs["pTechWeatherAfUp", c("tech", "weather")] <- TRUE;
    rs["pTechWeatherAfsLo", c("name", "description", "type")] <- c("pTechWeatherAfsLo", "Weather multiplier for tech afs.lo", "parameter");
    rs["pTechWeatherAfsLo", c("tech", "weather")] <- TRUE;
    rs["pTechWeatherAfsUp", c("name", "description", "type")] <- c("pTechWeatherAfsUp", "Weather multiplier for tech afs.up", "parameter");
    rs["pTechWeatherAfsUp", c("tech", "weather")] <- TRUE;
    rs["pTechWeatherAfcLo", c("name", "description", "type")] <- c("pTechWeatherAfcLo", "Weather multiplier for tech afc.lo", "parameter");
    rs["pTechWeatherAfcLo", c("tech", "comm", "weather")] <- TRUE;
    rs["pTechWeatherAfcUp", c("name", "description", "type")] <- c("pTechWeatherAfcUp", "Weather multiplier for tech afc.up", "parameter");
    rs["pTechWeatherAfcUp", c("tech", "comm", "weather")] <- TRUE;
    rs["pStorageWeatherAfUp", c("name", "description", "type")] <- c("pStorageWeatherAfUp", "Weather multiplier for storages af.up", "parameter");
    rs["pStorageWeatherAfUp", c("stg", "weather")] <- TRUE;
    rs["pStorageWeatherAfLo", c("name", "description", "type")] <- c("pStorageWeatherAfLo", "Weather multiplier for storages af.lo", "parameter");
    rs["pStorageWeatherAfLo", c("stg", "weather")] <- TRUE;
    rs["pStorageWeatherCinpUp", c("name", "description", "type")] <- c("pStorageWeatherCinpUp", "Weather multiplier for storages cinp.up", "parameter");
    rs["pStorageWeatherCinpUp", c("stg", "weather")] <- TRUE;
    rs["pStorageWeatherCinpLo", c("name", "description", "type")] <- c("pStorageWeatherCinpLo", "Weather multiplier for storages cinp.lo", "parameter");
    rs["pStorageWeatherCinpLo", c("stg", "weather")] <- TRUE;
    rs["pStorageWeatherCoutUp", c("name", "description", "type")] <- c("pStorageWeatherCoutUp", "Weather multiplier for storages cout.up", "parameter");
    rs["pStorageWeatherCoutUp", c("stg", "weather")] <- TRUE;
    rs["pStorageWeatherCoutLo", c("name", "description", "type")] <- c("pStorageWeatherCoutLo", "Weather multiplier for storages cout.lo", "parameter");
    rs["pStorageWeatherCoutLo", c("stg", "weather")] <- TRUE;
    rs["pStorageInpEff", c("name", "description", "type")] <- c("pStorageInpEff", "Storage input efficiency", "parameter");
    rs["pStorageInpEff", c("stg", "comm", "region", "year", "slice", "eqStorageStore")] <- TRUE;
    rs["pStorageOutEff", c("name", "description", "type")] <- c("pStorageOutEff", "Storage output efficiency", "parameter");
    rs["pStorageOutEff", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageClean")] <- TRUE;
    rs["pStorageStgEff", c("name", "description", "type")] <- c("pStorageStgEff", "Storage time-efficiency (annual)", "parameter");
    rs["pStorageStgEff", c("stg", "comm", "region", "year", "slice", "eqStorageStore")] <- TRUE;
    rs["pStorageStock", c("name", "description", "type")] <- c("pStorageStock", "Storage capacity stock", "parameter");
    rs["pStorageStock", c("stg", "region", "year", "eqStorageCap")] <- TRUE;
    rs["pStorageOlife", c("name", "description", "type")] <- c("pStorageOlife", "Storage operational life", "parameter");
    rs["pStorageOlife", c("stg", "region", "eqStorageCap", "eqStorageEac")] <- TRUE;
    rs["pStorageCostStore", c("name", "description", "type")] <- c("pStorageCostStore", "Storing costs per stored amount (annual)", "parameter");
    rs["pStorageCostStore", c("stg", "region", "year", "slice", "eqStorageCost")] <- TRUE;
    rs["pStorageCostInp", c("name", "description", "type")] <- c("pStorageCostInp", "Storage input costs", "parameter");
    rs["pStorageCostInp", c("stg", "region", "year", "slice", "eqStorageCost")] <- TRUE;
    rs["pStorageCostOut", c("name", "description", "type")] <- c("pStorageCostOut", "Storage output costs", "parameter");
    rs["pStorageCostOut", c("stg", "region", "year", "slice", "eqStorageCost")] <- TRUE;
    rs["pStorageFixom", c("name", "description", "type")] <- c("pStorageFixom", "Storage fixed O&M costs", "parameter");
    rs["pStorageFixom", c("stg", "region", "year", "eqStorageCost")] <- TRUE;
    rs["pStorageInvcost", c("name", "description", "type")] <- c("pStorageInvcost", "Storage investment costs", "parameter");
    rs["pStorageInvcost", c("stg", "region", "year", "eqStorageInv")] <- TRUE;
    rs["pStorageEac", c("name", "description", "type")] <- c("pStorageEac", "", "parameter");
    rs["pStorageEac", c("stg", "region", "year", "eqStorageEac")] <- TRUE;
    rs["pStorageCap2stg", c("name", "description", "type")] <- c("pStorageCap2stg", "Storage capacity units to activity units conversion factor", "parameter");
    rs["pStorageCap2stg", c("stg", "eqStorageAfLo", "eqStorageAfUp", "eqStorageInpUp", "eqStorageInpLo", "eqStorageOutUp", "eqStorageOutLo")] <- TRUE;
    rs["pStorageAfLo", c("name", "description", "type")] <- c("pStorageAfLo", "Storage capacity lower bound (minimum charge level)", "parameter");
    rs["pStorageAfLo", c("stg", "region", "year", "slice", "eqStorageAfLo")] <- TRUE;
    rs["pStorageAfUp", c("name", "description", "type")] <- c("pStorageAfUp", "Storage capacity upper bound (maximum charge level)", "parameter");
    rs["pStorageAfUp", c("stg", "region", "year", "slice", "eqStorageAfUp")] <- TRUE;
    rs["pStorageCinpUp", c("name", "description", "type")] <- c("pStorageCinpUp", "Storage input upper bound", "parameter");
    rs["pStorageCinpUp", c("stg", "comm", "region", "year", "slice", "eqStorageInpUp")] <- TRUE;
    rs["pStorageCinpLo", c("name", "description", "type")] <- c("pStorageCinpLo", "Storage input lower bound", "parameter");
    rs["pStorageCinpLo", c("stg", "comm", "region", "year", "slice", "eqStorageInpLo")] <- TRUE;
    rs["pStorageCoutUp", c("name", "description", "type")] <- c("pStorageCoutUp", "Storage output upper bound", "parameter");
    rs["pStorageCoutUp", c("stg", "comm", "region", "year", "slice", "eqStorageOutUp")] <- TRUE;
    rs["pStorageCoutLo", c("name", "description", "type")] <- c("pStorageCoutLo", "Storage output lower bound", "parameter");
    rs["pStorageCoutLo", c("stg", "comm", "region", "year", "slice", "eqStorageOutLo")] <- TRUE;
    rs["pStorageNCap2Stg", c("name", "description", "type")] <- c("pStorageNCap2Stg", "Initial storage charging for new investment", "parameter");
    rs["pStorageNCap2Stg", c("stg", "comm", "region", "year", "slice", "eqStorageStore")] <- TRUE;
    rs["pStorageCharge", c("name", "description", "type")] <- c("pStorageCharge", "Initial storage charging for stock", "parameter");
    rs["pStorageCharge", c("stg", "comm", "region", "year", "slice", "eqStorageStore")] <- TRUE;
    rs["pStorageStg2AInp", c("name", "description", "type")] <- c("pStorageStg2AInp", "Storage accumulated volume to auxilary input", "parameter");
    rs["pStorageStg2AInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp")] <- TRUE;
    rs["pStorageStg2AOut", c("name", "description", "type")] <- c("pStorageStg2AOut", "Storage accumulated volume output", "parameter");
    rs["pStorageStg2AOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut")] <- TRUE;
    rs["pStorageInp2AInp", c("name", "description", "type")] <- c("pStorageInp2AInp", "Storage input to auxilary input coefficient", "parameter");
    rs["pStorageInp2AInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp")] <- TRUE;
    rs["pStorageInp2AOut", c("name", "description", "type")] <- c("pStorageInp2AOut", "Storage input to auxilary output coefficient", "parameter");
    rs["pStorageInp2AOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut")] <- TRUE;
    rs["pStorageOut2AInp", c("name", "description", "type")] <- c("pStorageOut2AInp", "Storage output to auxilary input coefficient", "parameter");
    rs["pStorageOut2AInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp")] <- TRUE;
    rs["pStorageOut2AOut", c("name", "description", "type")] <- c("pStorageOut2AOut", "Storage output to auxilary output coefficient", "parameter");
    rs["pStorageOut2AOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut")] <- TRUE;
    rs["pStorageCap2AInp", c("name", "description", "type")] <- c("pStorageCap2AInp", "Storage capacity to auxilary input coefficient", "parameter");
    rs["pStorageCap2AInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp")] <- TRUE;
    rs["pStorageCap2AOut", c("name", "description", "type")] <- c("pStorageCap2AOut", "Storage capacity to auxilary output coefficient", "parameter");
    rs["pStorageCap2AOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut")] <- TRUE;
    rs["pStorageNCap2AInp", c("name", "description", "type")] <- c("pStorageNCap2AInp", "Storage new capacity to auxilary input coefficient", "parameter");
    rs["pStorageNCap2AInp", c("stg", "comm", "region", "year", "slice", "eqStorageAInp")] <- TRUE;
    rs["pStorageNCap2AOut", c("name", "description", "type")] <- c("pStorageNCap2AOut", "Storage new capacity to auxilary output coefficient", "parameter");
    rs["pStorageNCap2AOut", c("stg", "comm", "region", "year", "slice", "eqStorageAOut")] <- TRUE;
    rs["pTradeIrEff", c("name", "description", "type")] <- c("pTradeIrEff", "Inter-regional trade efficiency", "parameter");
    rs["pTradeIrEff", c("trade", "region", "year", "slice", "eqImport")] <- TRUE;
    rs["pTradeIrUp", c("name", "description", "type")] <- c("pTradeIrUp", "Upper bound on trade flow", "parameter");
    rs["pTradeIrUp", c("trade", "region", "year", "slice", "eqTradeFlowUp")] <- TRUE;
    rs["pTradeIrLo", c("name", "description", "type")] <- c("pTradeIrLo", "Lower bound on trade flow", "parameter");
    rs["pTradeIrLo", c("trade", "region", "year", "slice", "eqTradeFlowLo")] <- TRUE;
    rs["pTradeIrCost", c("name", "description", "type")] <- c("pTradeIrCost", "Costs of trade flow", "parameter");
    rs["pTradeIrCost", c("trade", "region", "year", "slice", "eqCostIrTrade")] <- TRUE;
    rs["pTradeIrMarkup", c("name", "description", "type")] <- c("pTradeIrMarkup", "Markup of trade flow", "parameter");
    rs["pTradeIrMarkup", c("trade", "region", "year", "slice", "eqCostIrTrade")] <- TRUE;
    rs["pTradeIrCsrc2Ainp", c("name", "description", "type")] <- c("pTradeIrCsrc2Ainp", "Auxiliary input commodity in source region", "parameter");
    rs["pTradeIrCsrc2Ainp", c("trade", "comm", "region", "year", "slice", "eqTradeIrAInp")] <- TRUE;
    rs["pTradeIrCsrc2Aout", c("name", "description", "type")] <- c("pTradeIrCsrc2Aout", "Auxiliary output commodity in source region", "parameter");
    rs["pTradeIrCsrc2Aout", c("trade", "comm", "region", "year", "slice", "eqTradeIrAOut")] <- TRUE;
    rs["pTradeIrCdst2Ainp", c("name", "description", "type")] <- c("pTradeIrCdst2Ainp", "Auxiliary input commodity in destination region", "parameter");
    rs["pTradeIrCdst2Ainp", c("trade", "comm", "region", "year", "slice", "eqTradeIrAInp")] <- TRUE;
    rs["pTradeIrCdst2Aout", c("name", "description", "type")] <- c("pTradeIrCdst2Aout", "Auxiliary output commodity in destination region", "parameter");
    rs["pTradeIrCdst2Aout", c("trade", "comm", "region", "year", "slice", "eqTradeIrAOut")] <- TRUE;
    rs["pExportRowRes", c("name", "description", "type")] <- c("pExportRowRes", "Upper bound on accumulated export to ROW", "parameter");
    rs["pExportRowRes", c("expp", "eqExportRowResUp")] <- TRUE;
    rs["pExportRowUp", c("name", "description", "type")] <- c("pExportRowUp", "Upper bound on export to ROW", "parameter");
    rs["pExportRowUp", c("expp", "region", "year", "slice", "eqExportRowUp")] <- TRUE;
    rs["pExportRowLo", c("name", "description", "type")] <- c("pExportRowLo", "Lower bound on export to ROW", "parameter");
    rs["pExportRowLo", c("expp", "region", "year", "slice", "eqExportRowLo")] <- TRUE;
    rs["pExportRowPrice", c("name", "description", "type")] <- c("pExportRowPrice", "Export prices to ROW", "parameter");
    rs["pExportRowPrice", c("expp", "region", "year", "slice", "eqCostRowTrade")] <- TRUE;
    rs["pImportRowRes", c("name", "description", "type")] <- c("pImportRowRes", "Upper bound on accumulated import to ROW", "parameter");
    rs["pImportRowRes", c("imp", "eqImportRowResUp")] <- TRUE;
    rs["pImportRowUp", c("name", "description", "type")] <- c("pImportRowUp", "Upper bount on import from ROW", "parameter");
    rs["pImportRowUp", c("imp", "region", "year", "slice", "eqImportRowUp")] <- TRUE;
    rs["pImportRowLo", c("name", "description", "type")] <- c("pImportRowLo", "Lower bound on import from ROW", "parameter");
    rs["pImportRowLo", c("imp", "region", "year", "slice", "eqImportRowLo")] <- TRUE;
    rs["pImportRowPrice", c("name", "description", "type")] <- c("pImportRowPrice", "Import prices from ROW", "parameter");
    rs["pImportRowPrice", c("imp", "region", "year", "slice", "eqCostRowTrade")] <- TRUE;
    rs["pTradeStock", c("name", "description", "type")] <- c("pTradeStock", "", "parameter");
    rs["pTradeStock", c("trade", "year", "eqTradeCap")] <- TRUE;
    rs["pTradeOlife", c("name", "description", "type")] <- c("pTradeOlife", "", "parameter");
    rs["pTradeOlife", c("trade", "eqTradeCap", "eqTradeEac")] <- TRUE;
    rs["pTradeInvcost", c("name", "description", "type")] <- c("pTradeInvcost", "", "parameter");
    rs["pTradeInvcost", c("trade", "region", "year", "eqTradeInv")] <- TRUE;
    rs["pTradeEac", c("name", "description", "type")] <- c("pTradeEac", "", "parameter");
    rs["pTradeEac", c("trade", "region", "year", "eqTradeEac")] <- TRUE;
    rs["pTradeCap2Act", c("name", "description", "type")] <- c("pTradeCap2Act", "", "parameter");
    rs["pTradeCap2Act", c("trade", "eqTradeCapFlow")] <- TRUE;
    rs["paTechWeatherAfLo", c("name", "description", "type")] <- c("paTechWeatherAfLo", "", "parameter");
    rs["paTechWeatherAfLo", c("tech", "region", "year", "slice", "eqTechAfLo")] <- TRUE;
    rs["paTechWeatherAfUp", c("name", "description", "type")] <- c("paTechWeatherAfUp", "", "parameter");
    rs["paTechWeatherAfUp", c("tech", "region", "year", "slice", "eqTechAfUp")] <- TRUE;
    rs["paTechWeatherAfsLo", c("name", "description", "type")] <- c("paTechWeatherAfsLo", "", "parameter");
    rs["paTechWeatherAfsLo", c("tech", "region", "year", "slice", "eqTechAfsLo")] <- TRUE;
    rs["paTechWeatherAfsUp", c("name", "description", "type")] <- c("paTechWeatherAfsUp", "", "parameter");
    rs["paTechWeatherAfsUp", c("tech", "region", "year", "slice", "eqTechAfsUp")] <- TRUE;
    rs["paTechWeatherAfcLo", c("name", "description", "type")] <- c("paTechWeatherAfcLo", "", "parameter");
    rs["paTechWeatherAfcLo", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutLo", "eqTechAfcInpLo")] <- TRUE;
    rs["paTechWeatherAfcUp", c("name", "description", "type")] <- c("paTechWeatherAfcUp", "", "parameter");
    rs["paTechWeatherAfcUp", c("tech", "comm", "region", "year", "slice", "eqTechAfcOutUp", "eqTechAfcInpUp")] <- TRUE;
    rs["paSupWeatherUp", c("name", "description", "type")] <- c("paSupWeatherUp", "", "parameter");
    rs["paSupWeatherUp", c("sup", "comm", "region", "year", "slice", "eqSupAvaUp")] <- TRUE;
    rs["paSupWeatherLo", c("name", "description", "type")] <- c("paSupWeatherLo", "", "parameter");
    rs["paSupWeatherLo", c("sup", "comm", "region", "year", "slice", "eqSupAvaLo")] <- TRUE;
    rs["paStorageWeatherAfLo", c("name", "description", "type")] <- c("paStorageWeatherAfLo", "", "parameter");
    rs["paStorageWeatherAfLo", c("stg", "comm", "region", "year", "slice", "eqStorageAfLo")] <- TRUE;
    rs["paStorageWeatherAfUp", c("name", "description", "type")] <- c("paStorageWeatherAfUp", "", "parameter");
    rs["paStorageWeatherAfUp", c("stg", "comm", "region", "year", "slice", "eqStorageAfUp")] <- TRUE;
    rs["paStorageWeatherCinpUp", c("name", "description", "type")] <- c("paStorageWeatherCinpUp", "", "parameter");
    rs["paStorageWeatherCinpUp", c("stg", "comm", "region", "year", "slice", "eqStorageInpUp")] <- TRUE;
    rs["paStorageWeatherCinpLo", c("name", "description", "type")] <- c("paStorageWeatherCinpLo", "", "parameter");
    rs["paStorageWeatherCinpLo", c("stg", "comm", "region", "year", "slice", "eqStorageInpLo")] <- TRUE;
    rs["paStorageWeatherCoutUp", c("name", "description", "type")] <- c("paStorageWeatherCoutUp", "", "parameter");
    rs["paStorageWeatherCoutUp", c("stg", "comm", "region", "year", "slice", "eqStorageOutUp")] <- TRUE;
    rs["paStorageWeatherCoutLo", c("name", "description", "type")] <- c("paStorageWeatherCoutLo", "", "parameter");
    rs["paStorageWeatherCoutLo", c("stg", "comm", "region", "year", "slice", "eqStorageOutLo")] <- TRUE;
    rs["pLECLoACT", c("name", "description", "type")] <- c("pLECLoACT", "", "parameter");
    rs["pLECLoACT", c("region", "eqLECActivity")] <- TRUE;
    rs$type <- factor(rs$type, levels = c("set", "map", "parameter"))
    rs[, -(1:2)][is.na(rs[, -(1:2)])] <- FALSE;
rs
}
    .getParameters <- ..getParameters()
     getParameters <- function(parameter = TRUE, set = FALSE, map = FALSE, equation = FALSE, all = NULL) {
if (!is.null(all) && all) {parameter = TRUE; set = TRUE; map = TRUE;}
     gg <- energyRt:::.getParameters
     if (!equation) gg <- gg[,c("name", "description", "type", "tech", "sup", "dem", "stg", "expp", "imp", "trade", "group", "comm", "region", "year", "slice", "weather"), drop = FALSE]
     if (!set) gg <- gg[gg$type != "set",, drop = FALSE]
     if (!parameter) gg <- gg[gg$type != "parameter",, drop = FALSE]
     if (!map) gg <- gg[gg$type != "map",, drop = FALSE]
     gg
}
    .getVariables <- ..getVariables()
     getVariables <- function(equation = FALSE, row.names = TRUE) {
     gg <- energyRt:::.getVariables
     if (!row.names) rownames(gg) <- NULL
     if (equation) gg else gg[,c("name", "description", "tech", "sup", "dem", "stg", "expp", "imp", "trade", "group", "comm", "region", "year", "slice", "weather"), drop = FALSE]}
    .getEquations <- ..getEquations()
     getEquations <- function() {energyRt:::.getEquations}
    .getVariablesDim <- ..getVariablesDim()
     getVariablesDim <- function() {energyRt:::.getVariablesDim}
    .getEquationsDim <- ..getEquationsDim()
     getEquationsDim <- function() {energyRt:::.getEquationsDim}
