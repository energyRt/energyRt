getEquationsMap <- function() {
  list(
    eqTechSng2Sng = c("tech", "region", "comm", "comm", "year", "slice"), 
    eqTechGrp2Sng = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechSng2Grp = c("tech", "region", "comm", "group", "year", "slice"), 
    eqTechGrp2Grp = c("tech", "region", "group", "group", "year", "slice"), 
    eqTechUse2Sng = c("tech", "region", "comm", "year", "slice"), 
    eqTechUse2Grp = c("tech", "region", "group", "year", "slice"), 
    eqTechShareInpLo = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareInpUp = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareOutLo = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechShareOutUp = c("tech", "region", "group", "comm", "year", "slice"), 
    eqTechAInp = c("tech", "comm", "region", "year", "slice"), 
    eqTechAOut = c("tech", "comm", "region", "year", "slice"), 
    eqTechAfaLo = c("tech", "region", "year", "slice"), 
    eqTechAfaUp = c("tech", "region", "year", "slice"), 
    eqTechActSng = c("tech", "comm", "region", "year", "slice"), 
    eqTechActGrp = c("tech", "group", "region", "year", "slice"), 
    eqTechAfacLo = c("tech", "region", "comm", "year", "slice"), 
    eqTechAfacUp = c("tech", "region", "comm", "year", "slice"), 
    eqTechCap = c("tech", "region", "year"), 
    eqTechNewCap = c("tech", "region", "year"), 
    eqTechEac = c("tech", "region", "year"), 
    eqTechInv = c("tech", "region", "year"), 
    eqTechSalv2 = c("tech", "region", "year"), 
    eqTechSalv3 = c("tech", "region", "year"), 
    eqTechCost1 = c("tech", "region", "year"), 
    eqTechCost2 = c("tech", "region", "year"), 
    eqTechFixom = c("tech", "region", "year"), 
    eqTechVarom = c("tech", "region", "year", "slice"), 
    eqTechActVarom = c("tech", "region", "year", "slice"), 
    eqTechCVarom = c("tech", "region", "year", "slice"), 
    eqTechAVarom = c("tech", "region", "year", "slice"), 
    eqSupAvaUp = c("sup", "comm", "region", "year", "slice"), 
    eqSupAvaLo = c("sup", "comm", "region", "year", "slice"), 
    eqSupReserve = c("sup", "comm"), 
    eqSupReserveCheck = c("sup", "comm"), 
    eqSupCost = c("sup", "region", "year"), 
    eqDemInp = c("comm", "region", "year", "slice"), 
    eqAggOut = c("comm", "region", "year", "slice"), 
    eqEmsFuelTot = c("comm", "region", "year", "slice"), 
    eqTechEmsFuel = c("tech", "comm", "region", "year", "slice"), 
    eqStorageStore = c("stg", "comm", "region", "year", "slice"), 
    eqStorageCap = c("stg", "region", "year"), 
    eqStorageInv = c("stg", "region", "year"), 
    eqStorageFix = c("stg", "region", "year"), 
    eqStorageSalv2 = c("stg", "region", "year"), 
    eqStorageSalv3 = c("stg", "region", "year"), 
    eqStorageVar = c("stg", "region", "year"), 
    eqStorageCost = c("stg", "region", "year"), 
    eqStorageLo = c("stg", "region", "year"), 
    eqStorageUp = c("stg", "region", "year"), 
    eqImport = c("comm", "region", "year", "slice"), 
    eqExport = c("comm", "region", "year", "slice"), 
    eqTradeFlowUp = c("trade", "region", "region", "year", "slice"), 
    eqTradeFlowLo = c("trade", "region", "region", "year", "slice"), 
    eqCostTrade = c("region", "year"), 
    eqCostRowTrade = c("region", "year"), 
    eqCostIrTrade = c("region", "year"), 
    eqExportRowUp = c("expp", "region", "year", "slice"), 
    eqExportRowLo = c("expp", "region", "year", "slice"), 
    eqExportRowRes = c("expp"), 
    eqExportRowResUp = c("expp"), 
    eqImportRowUp = c("imp", "region", "year", "slice"), 
    eqImportRowLo = c("imp", "region", "year", "slice"), 
    eqImportRowRes = c("imp"), 
    eqImportRowResUp = c("imp"), 
    eqBalUp = c("comm", "region", "year", "slice"), 
    eqBalLo = c("comm", "region", "year", "slice"), 
    eqBalFx = c("comm", "region", "year", "slice"), 
    eqBal = c("comm", "region", "year", "slice"), 
    eqOutTot = c("comm", "region", "year", "slice"), 
    eqInpTot = c("comm", "region", "year", "slice"), 
    eqSupOutTot = c("comm", "region", "year", "slice"), 
    eqTechInpTot = c("comm", "region", "year", "slice"), 
    eqTechOutTot = c("comm", "region", "year", "slice"), 
    eqStorageInpTot = c("comm", "region", "year", "slice"), 
    eqStorageOutTot = c("comm", "region", "year", "slice"), 
    eqDumCost = c("comm", "region", "year"), 
    eqCost1 = c("region", "year"), 
    eqCost2 = c("region", "year"), 
    eqTaxCost = c("comm", "region", "year"), 
    eqSubsCost = c("comm", "region", "year"), 
    eqCnsLETechInpShareIn = c("cns"), 
    eqCnsLETechInpShareOut = c("cns"), 
    eqCnsLETechInp = c("cns"), 
    eqCnsGETechInpShareIn = c("cns"), 
    eqCnsGETechInpShareOut = c("cns"), 
    eqCnsGETechInp = c("cns"), 
    eqCnsETechInpShareIn = c("cns"), 
    eqCnsETechInpShareOut = c("cns"), 
    eqCnsETechInp = c("cns"), 
    eqCnsLETechInpSShareIn = c("cns", "slice"), 
    eqCnsLETechInpSShareOut = c("cns", "slice"), 
    eqCnsLETechInpS = c("cns", "slice"), 
    eqCnsGETechInpSShareIn = c("cns", "slice"), 
    eqCnsGETechInpSShareOut = c("cns", "slice"), 
    eqCnsGETechInpS = c("cns", "slice"), 
    eqCnsETechInpSShareIn = c("cns", "slice"), 
    eqCnsETechInpSShareOut = c("cns", "slice"), 
    eqCnsETechInpS = c("cns", "slice"), 
    eqCnsLETechInpYShareIn = c("cns", "year"), 
    eqCnsLETechInpYShareOut = c("cns", "year"), 
    eqCnsLETechInpY = c("cns", "year"), 
    eqCnsLETechInpYGrowth = c("cns", "year", "year"), 
    eqCnsGETechInpYShareIn = c("cns", "year"), 
    eqCnsGETechInpYShareOut = c("cns", "year"), 
    eqCnsGETechInpY = c("cns", "year"), 
    eqCnsGETechInpYGrowth = c("cns", "year", "year"), 
    eqCnsETechInpYShareIn = c("cns", "year"), 
    eqCnsETechInpYShareOut = c("cns", "year"), 
    eqCnsETechInpY = c("cns", "year"), 
    eqCnsETechInpYGrowth = c("cns", "year", "year"), 
    eqCnsLETechInpYSShareIn = c("cns", "year", "slice"), 
    eqCnsLETechInpYSShareOut = c("cns", "year", "slice"), 
    eqCnsLETechInpYS = c("cns", "year", "slice"), 
    eqCnsLETechInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechInpYSShareIn = c("cns", "year", "slice"), 
    eqCnsGETechInpYSShareOut = c("cns", "year", "slice"), 
    eqCnsGETechInpYS = c("cns", "year", "slice"), 
    eqCnsGETechInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechInpYSShareIn = c("cns", "year", "slice"), 
    eqCnsETechInpYSShareOut = c("cns", "year", "slice"), 
    eqCnsETechInpYS = c("cns", "year", "slice"), 
    eqCnsETechInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechInpRShareIn = c("cns", "region"), 
    eqCnsLETechInpRShareOut = c("cns", "region"), 
    eqCnsLETechInpR = c("cns", "region"), 
    eqCnsGETechInpRShareIn = c("cns", "region"), 
    eqCnsGETechInpRShareOut = c("cns", "region"), 
    eqCnsGETechInpR = c("cns", "region"), 
    eqCnsETechInpRShareIn = c("cns", "region"), 
    eqCnsETechInpRShareOut = c("cns", "region"), 
    eqCnsETechInpR = c("cns", "region"), 
    eqCnsLETechInpRSShareIn = c("cns", "region", "slice"), 
    eqCnsLETechInpRSShareOut = c("cns", "region", "slice"), 
    eqCnsLETechInpRS = c("cns", "region", "slice"), 
    eqCnsGETechInpRSShareIn = c("cns", "region", "slice"), 
    eqCnsGETechInpRSShareOut = c("cns", "region", "slice"), 
    eqCnsGETechInpRS = c("cns", "region", "slice"), 
    eqCnsETechInpRSShareIn = c("cns", "region", "slice"), 
    eqCnsETechInpRSShareOut = c("cns", "region", "slice"), 
    eqCnsETechInpRS = c("cns", "region", "slice"), 
    eqCnsLETechInpRYShareIn = c("cns", "region", "year"), 
    eqCnsLETechInpRYShareOut = c("cns", "region", "year"), 
    eqCnsLETechInpRY = c("cns", "region", "year"), 
    eqCnsLETechInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechInpRYShareIn = c("cns", "region", "year"), 
    eqCnsGETechInpRYShareOut = c("cns", "region", "year"), 
    eqCnsGETechInpRY = c("cns", "region", "year"), 
    eqCnsGETechInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechInpRYShareIn = c("cns", "region", "year"), 
    eqCnsETechInpRYShareOut = c("cns", "region", "year"), 
    eqCnsETechInpRY = c("cns", "region", "year"), 
    eqCnsETechInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechInpRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsLETechInpRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsLETechInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechInpRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsGETechInpRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsGETechInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechInpRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsETechInpRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsETechInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechInpCShareIn = c("cns", "comm"), 
    eqCnsLETechInpCShareOut = c("cns", "comm"), 
    eqCnsLETechInpC = c("cns", "comm"), 
    eqCnsGETechInpCShareIn = c("cns", "comm"), 
    eqCnsGETechInpCShareOut = c("cns", "comm"), 
    eqCnsGETechInpC = c("cns", "comm"), 
    eqCnsETechInpCShareIn = c("cns", "comm"), 
    eqCnsETechInpCShareOut = c("cns", "comm"), 
    eqCnsETechInpC = c("cns", "comm"), 
    eqCnsLETechInpCSShareIn = c("cns", "comm", "slice"), 
    eqCnsLETechInpCSShareOut = c("cns", "comm", "slice"), 
    eqCnsLETechInpCS = c("cns", "comm", "slice"), 
    eqCnsGETechInpCSShareIn = c("cns", "comm", "slice"), 
    eqCnsGETechInpCSShareOut = c("cns", "comm", "slice"), 
    eqCnsGETechInpCS = c("cns", "comm", "slice"), 
    eqCnsETechInpCSShareIn = c("cns", "comm", "slice"), 
    eqCnsETechInpCSShareOut = c("cns", "comm", "slice"), 
    eqCnsETechInpCS = c("cns", "comm", "slice"), 
    eqCnsLETechInpCYShareIn = c("cns", "comm", "year"), 
    eqCnsLETechInpCYShareOut = c("cns", "comm", "year"), 
    eqCnsLETechInpCY = c("cns", "comm", "year"), 
    eqCnsLETechInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsGETechInpCYShareIn = c("cns", "comm", "year"), 
    eqCnsGETechInpCYShareOut = c("cns", "comm", "year"), 
    eqCnsGETechInpCY = c("cns", "comm", "year"), 
    eqCnsGETechInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsETechInpCYShareIn = c("cns", "comm", "year"), 
    eqCnsETechInpCYShareOut = c("cns", "comm", "year"), 
    eqCnsETechInpCY = c("cns", "comm", "year"), 
    eqCnsETechInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsLETechInpCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsLETechInpCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsLETechInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsLETechInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsGETechInpCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsGETechInpCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsGETechInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsGETechInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsETechInpCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsETechInpCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsETechInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsETechInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsLETechInpCRShareIn = c("cns", "comm", "region"), 
    eqCnsLETechInpCRShareOut = c("cns", "comm", "region"), 
    eqCnsLETechInpCR = c("cns", "comm", "region"), 
    eqCnsGETechInpCRShareIn = c("cns", "comm", "region"), 
    eqCnsGETechInpCRShareOut = c("cns", "comm", "region"), 
    eqCnsGETechInpCR = c("cns", "comm", "region"), 
    eqCnsETechInpCRShareIn = c("cns", "comm", "region"), 
    eqCnsETechInpCRShareOut = c("cns", "comm", "region"), 
    eqCnsETechInpCR = c("cns", "comm", "region"), 
    eqCnsLETechInpCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsLETechInpCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsLETechInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsGETechInpCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsGETechInpCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsGETechInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsETechInpCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsETechInpCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsETechInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsLETechInpCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsLETechInpCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsLETechInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsLETechInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsGETechInpCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsGETechInpCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsGETechInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsGETechInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsETechInpCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsETechInpCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsETechInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsETechInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsLETechInpCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechInpCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsGETechInpCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechInpCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsETechInpCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechInpCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsLETechOutShareIn = c("cns"), 
    eqCnsLETechOutShareOut = c("cns"), 
    eqCnsLETechOut = c("cns"), 
    eqCnsGETechOutShareIn = c("cns"), 
    eqCnsGETechOutShareOut = c("cns"), 
    eqCnsGETechOut = c("cns"), 
    eqCnsETechOutShareIn = c("cns"), 
    eqCnsETechOutShareOut = c("cns"), 
    eqCnsETechOut = c("cns"), 
    eqCnsLETechOutSShareIn = c("cns", "slice"), 
    eqCnsLETechOutSShareOut = c("cns", "slice"), 
    eqCnsLETechOutS = c("cns", "slice"), 
    eqCnsGETechOutSShareIn = c("cns", "slice"), 
    eqCnsGETechOutSShareOut = c("cns", "slice"), 
    eqCnsGETechOutS = c("cns", "slice"), 
    eqCnsETechOutSShareIn = c("cns", "slice"), 
    eqCnsETechOutSShareOut = c("cns", "slice"), 
    eqCnsETechOutS = c("cns", "slice"), 
    eqCnsLETechOutYShareIn = c("cns", "year"), 
    eqCnsLETechOutYShareOut = c("cns", "year"), 
    eqCnsLETechOutY = c("cns", "year"), 
    eqCnsLETechOutYGrowth = c("cns", "year", "year"), 
    eqCnsGETechOutYShareIn = c("cns", "year"), 
    eqCnsGETechOutYShareOut = c("cns", "year"), 
    eqCnsGETechOutY = c("cns", "year"), 
    eqCnsGETechOutYGrowth = c("cns", "year", "year"), 
    eqCnsETechOutYShareIn = c("cns", "year"), 
    eqCnsETechOutYShareOut = c("cns", "year"), 
    eqCnsETechOutY = c("cns", "year"), 
    eqCnsETechOutYGrowth = c("cns", "year", "year"), 
    eqCnsLETechOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsLETechOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsLETechOutYS = c("cns", "year", "slice"), 
    eqCnsLETechOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsGETechOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsGETechOutYS = c("cns", "year", "slice"), 
    eqCnsGETechOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsETechOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsETechOutYS = c("cns", "year", "slice"), 
    eqCnsETechOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechOutRShareIn = c("cns", "region"), 
    eqCnsLETechOutRShareOut = c("cns", "region"), 
    eqCnsLETechOutR = c("cns", "region"), 
    eqCnsGETechOutRShareIn = c("cns", "region"), 
    eqCnsGETechOutRShareOut = c("cns", "region"), 
    eqCnsGETechOutR = c("cns", "region"), 
    eqCnsETechOutRShareIn = c("cns", "region"), 
    eqCnsETechOutRShareOut = c("cns", "region"), 
    eqCnsETechOutR = c("cns", "region"), 
    eqCnsLETechOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsLETechOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsLETechOutRS = c("cns", "region", "slice"), 
    eqCnsGETechOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsGETechOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsGETechOutRS = c("cns", "region", "slice"), 
    eqCnsETechOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsETechOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsETechOutRS = c("cns", "region", "slice"), 
    eqCnsLETechOutRYShareIn = c("cns", "region", "year"), 
    eqCnsLETechOutRYShareOut = c("cns", "region", "year"), 
    eqCnsLETechOutRY = c("cns", "region", "year"), 
    eqCnsLETechOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechOutRYShareIn = c("cns", "region", "year"), 
    eqCnsGETechOutRYShareOut = c("cns", "region", "year"), 
    eqCnsGETechOutRY = c("cns", "region", "year"), 
    eqCnsGETechOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechOutRYShareIn = c("cns", "region", "year"), 
    eqCnsETechOutRYShareOut = c("cns", "region", "year"), 
    eqCnsETechOutRY = c("cns", "region", "year"), 
    eqCnsETechOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsLETechOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsLETechOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsGETechOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsGETechOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsETechOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsETechOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechOutCShareIn = c("cns", "comm"), 
    eqCnsLETechOutCShareOut = c("cns", "comm"), 
    eqCnsLETechOutC = c("cns", "comm"), 
    eqCnsGETechOutCShareIn = c("cns", "comm"), 
    eqCnsGETechOutCShareOut = c("cns", "comm"), 
    eqCnsGETechOutC = c("cns", "comm"), 
    eqCnsETechOutCShareIn = c("cns", "comm"), 
    eqCnsETechOutCShareOut = c("cns", "comm"), 
    eqCnsETechOutC = c("cns", "comm"), 
    eqCnsLETechOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsLETechOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsLETechOutCS = c("cns", "comm", "slice"), 
    eqCnsGETechOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsGETechOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsGETechOutCS = c("cns", "comm", "slice"), 
    eqCnsETechOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsETechOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsETechOutCS = c("cns", "comm", "slice"), 
    eqCnsLETechOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsLETechOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsLETechOutCY = c("cns", "comm", "year"), 
    eqCnsLETechOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsGETechOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsGETechOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsGETechOutCY = c("cns", "comm", "year"), 
    eqCnsGETechOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsETechOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsETechOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsETechOutCY = c("cns", "comm", "year"), 
    eqCnsETechOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsLETechOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsLETechOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsLETechOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsLETechOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsGETechOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsGETechOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsGETechOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsGETechOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsETechOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsETechOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsETechOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsETechOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsLETechOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsLETechOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsLETechOutCR = c("cns", "comm", "region"), 
    eqCnsGETechOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsGETechOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsGETechOutCR = c("cns", "comm", "region"), 
    eqCnsETechOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsETechOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsETechOutCR = c("cns", "comm", "region"), 
    eqCnsLETechOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsLETechOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsLETechOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsGETechOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsGETechOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsGETechOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsETechOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsETechOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsETechOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsLETechOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsLETechOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsLETechOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsLETechOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsGETechOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsGETechOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsGETechOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsGETechOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsETechOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsETechOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsETechOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsETechOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsLETechOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETechOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsGETechOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETechOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsETechOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETechOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsLETechCap = c("cns"), 
    eqCnsGETechCap = c("cns"), 
    eqCnsETechCap = c("cns"), 
    eqCnsLETechCapY = c("cns", "year"), 
    eqCnsLETechCapYGrowth = c("cns", "year", "year"), 
    eqCnsGETechCapY = c("cns", "year"), 
    eqCnsGETechCapYGrowth = c("cns", "year", "year"), 
    eqCnsETechCapY = c("cns", "year"), 
    eqCnsETechCapYGrowth = c("cns", "year", "year"), 
    eqCnsLETechCapR = c("cns", "region"), 
    eqCnsGETechCapR = c("cns", "region"), 
    eqCnsETechCapR = c("cns", "region"), 
    eqCnsLETechCapRY = c("cns", "region", "year"), 
    eqCnsLETechCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechCapRY = c("cns", "region", "year"), 
    eqCnsGETechCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechCapRY = c("cns", "region", "year"), 
    eqCnsETechCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechNewCap = c("cns"), 
    eqCnsGETechNewCap = c("cns"), 
    eqCnsETechNewCap = c("cns"), 
    eqCnsLETechNewCapY = c("cns", "year"), 
    eqCnsLETechNewCapYGrowth = c("cns", "year", "year"), 
    eqCnsGETechNewCapY = c("cns", "year"), 
    eqCnsGETechNewCapYGrowth = c("cns", "year", "year"), 
    eqCnsETechNewCapY = c("cns", "year"), 
    eqCnsETechNewCapYGrowth = c("cns", "year", "year"), 
    eqCnsLETechNewCapR = c("cns", "region"), 
    eqCnsGETechNewCapR = c("cns", "region"), 
    eqCnsETechNewCapR = c("cns", "region"), 
    eqCnsLETechNewCapRY = c("cns", "region", "year"), 
    eqCnsLETechNewCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechNewCapRY = c("cns", "region", "year"), 
    eqCnsGETechNewCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechNewCapRY = c("cns", "region", "year"), 
    eqCnsETechNewCapRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechInv = c("cns"), 
    eqCnsGETechInv = c("cns"), 
    eqCnsETechInv = c("cns"), 
    eqCnsLETechInvY = c("cns", "year"), 
    eqCnsLETechInvYGrowth = c("cns", "year", "year"), 
    eqCnsGETechInvY = c("cns", "year"), 
    eqCnsGETechInvYGrowth = c("cns", "year", "year"), 
    eqCnsETechInvY = c("cns", "year"), 
    eqCnsETechInvYGrowth = c("cns", "year", "year"), 
    eqCnsLETechInvR = c("cns", "region"), 
    eqCnsGETechInvR = c("cns", "region"), 
    eqCnsETechInvR = c("cns", "region"), 
    eqCnsLETechInvRY = c("cns", "region", "year"), 
    eqCnsLETechInvRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechInvRY = c("cns", "region", "year"), 
    eqCnsGETechInvRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechInvRY = c("cns", "region", "year"), 
    eqCnsETechInvRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechEac = c("cns"), 
    eqCnsGETechEac = c("cns"), 
    eqCnsETechEac = c("cns"), 
    eqCnsLETechEacY = c("cns", "year"), 
    eqCnsLETechEacYGrowth = c("cns", "year", "year"), 
    eqCnsGETechEacY = c("cns", "year"), 
    eqCnsGETechEacYGrowth = c("cns", "year", "year"), 
    eqCnsETechEacY = c("cns", "year"), 
    eqCnsETechEacYGrowth = c("cns", "year", "year"), 
    eqCnsLETechEacR = c("cns", "region"), 
    eqCnsGETechEacR = c("cns", "region"), 
    eqCnsETechEacR = c("cns", "region"), 
    eqCnsLETechEacRY = c("cns", "region", "year"), 
    eqCnsLETechEacRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechEacRY = c("cns", "region", "year"), 
    eqCnsGETechEacRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechEacRY = c("cns", "region", "year"), 
    eqCnsETechEacRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechAct = c("cns"), 
    eqCnsGETechAct = c("cns"), 
    eqCnsETechAct = c("cns"), 
    eqCnsLETechActS = c("cns", "slice"), 
    eqCnsGETechActS = c("cns", "slice"), 
    eqCnsETechActS = c("cns", "slice"), 
    eqCnsLETechActY = c("cns", "year"), 
    eqCnsLETechActYGrowth = c("cns", "year", "year"), 
    eqCnsGETechActY = c("cns", "year"), 
    eqCnsGETechActYGrowth = c("cns", "year", "year"), 
    eqCnsETechActY = c("cns", "year"), 
    eqCnsETechActYGrowth = c("cns", "year", "year"), 
    eqCnsLETechActYS = c("cns", "year", "slice"), 
    eqCnsLETechActYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechActYS = c("cns", "year", "slice"), 
    eqCnsGETechActYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechActYS = c("cns", "year", "slice"), 
    eqCnsETechActYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechActR = c("cns", "region"), 
    eqCnsGETechActR = c("cns", "region"), 
    eqCnsETechActR = c("cns", "region"), 
    eqCnsLETechActRS = c("cns", "region", "slice"), 
    eqCnsGETechActRS = c("cns", "region", "slice"), 
    eqCnsETechActRS = c("cns", "region", "slice"), 
    eqCnsLETechActRY = c("cns", "region", "year"), 
    eqCnsLETechActRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechActRY = c("cns", "region", "year"), 
    eqCnsGETechActRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechActRY = c("cns", "region", "year"), 
    eqCnsETechActRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechActRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechActRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechActRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechActRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechActRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechActRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechVarom = c("cns"), 
    eqCnsGETechVarom = c("cns"), 
    eqCnsETechVarom = c("cns"), 
    eqCnsLETechVaromS = c("cns", "slice"), 
    eqCnsGETechVaromS = c("cns", "slice"), 
    eqCnsETechVaromS = c("cns", "slice"), 
    eqCnsLETechVaromY = c("cns", "year"), 
    eqCnsLETechVaromYGrowth = c("cns", "year", "year"), 
    eqCnsGETechVaromY = c("cns", "year"), 
    eqCnsGETechVaromYGrowth = c("cns", "year", "year"), 
    eqCnsETechVaromY = c("cns", "year"), 
    eqCnsETechVaromYGrowth = c("cns", "year", "year"), 
    eqCnsLETechVaromYS = c("cns", "year", "slice"), 
    eqCnsLETechVaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechVaromYS = c("cns", "year", "slice"), 
    eqCnsGETechVaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechVaromYS = c("cns", "year", "slice"), 
    eqCnsETechVaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechVaromR = c("cns", "region"), 
    eqCnsGETechVaromR = c("cns", "region"), 
    eqCnsETechVaromR = c("cns", "region"), 
    eqCnsLETechVaromRS = c("cns", "region", "slice"), 
    eqCnsGETechVaromRS = c("cns", "region", "slice"), 
    eqCnsETechVaromRS = c("cns", "region", "slice"), 
    eqCnsLETechVaromRY = c("cns", "region", "year"), 
    eqCnsLETechVaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechVaromRY = c("cns", "region", "year"), 
    eqCnsGETechVaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechVaromRY = c("cns", "region", "year"), 
    eqCnsETechVaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechVaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechVaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechVaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechVaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechVaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechVaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechFixom = c("cns"), 
    eqCnsGETechFixom = c("cns"), 
    eqCnsETechFixom = c("cns"), 
    eqCnsLETechFixomY = c("cns", "year"), 
    eqCnsLETechFixomYGrowth = c("cns", "year", "year"), 
    eqCnsGETechFixomY = c("cns", "year"), 
    eqCnsGETechFixomYGrowth = c("cns", "year", "year"), 
    eqCnsETechFixomY = c("cns", "year"), 
    eqCnsETechFixomYGrowth = c("cns", "year", "year"), 
    eqCnsLETechFixomR = c("cns", "region"), 
    eqCnsGETechFixomR = c("cns", "region"), 
    eqCnsETechFixomR = c("cns", "region"), 
    eqCnsLETechFixomRY = c("cns", "region", "year"), 
    eqCnsLETechFixomRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechFixomRY = c("cns", "region", "year"), 
    eqCnsGETechFixomRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechFixomRY = c("cns", "region", "year"), 
    eqCnsETechFixomRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechActvarom = c("cns"), 
    eqCnsGETechActvarom = c("cns"), 
    eqCnsETechActvarom = c("cns"), 
    eqCnsLETechActvaromS = c("cns", "slice"), 
    eqCnsGETechActvaromS = c("cns", "slice"), 
    eqCnsETechActvaromS = c("cns", "slice"), 
    eqCnsLETechActvaromY = c("cns", "year"), 
    eqCnsLETechActvaromYGrowth = c("cns", "year", "year"), 
    eqCnsGETechActvaromY = c("cns", "year"), 
    eqCnsGETechActvaromYGrowth = c("cns", "year", "year"), 
    eqCnsETechActvaromY = c("cns", "year"), 
    eqCnsETechActvaromYGrowth = c("cns", "year", "year"), 
    eqCnsLETechActvaromYS = c("cns", "year", "slice"), 
    eqCnsLETechActvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechActvaromYS = c("cns", "year", "slice"), 
    eqCnsGETechActvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechActvaromYS = c("cns", "year", "slice"), 
    eqCnsETechActvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechActvaromR = c("cns", "region"), 
    eqCnsGETechActvaromR = c("cns", "region"), 
    eqCnsETechActvaromR = c("cns", "region"), 
    eqCnsLETechActvaromRS = c("cns", "region", "slice"), 
    eqCnsGETechActvaromRS = c("cns", "region", "slice"), 
    eqCnsETechActvaromRS = c("cns", "region", "slice"), 
    eqCnsLETechActvaromRY = c("cns", "region", "year"), 
    eqCnsLETechActvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechActvaromRY = c("cns", "region", "year"), 
    eqCnsGETechActvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechActvaromRY = c("cns", "region", "year"), 
    eqCnsETechActvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechActvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechActvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechActvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechActvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechActvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechActvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechCvarom = c("cns"), 
    eqCnsGETechCvarom = c("cns"), 
    eqCnsETechCvarom = c("cns"), 
    eqCnsLETechCvaromS = c("cns", "slice"), 
    eqCnsGETechCvaromS = c("cns", "slice"), 
    eqCnsETechCvaromS = c("cns", "slice"), 
    eqCnsLETechCvaromY = c("cns", "year"), 
    eqCnsLETechCvaromYGrowth = c("cns", "year", "year"), 
    eqCnsGETechCvaromY = c("cns", "year"), 
    eqCnsGETechCvaromYGrowth = c("cns", "year", "year"), 
    eqCnsETechCvaromY = c("cns", "year"), 
    eqCnsETechCvaromYGrowth = c("cns", "year", "year"), 
    eqCnsLETechCvaromYS = c("cns", "year", "slice"), 
    eqCnsLETechCvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechCvaromYS = c("cns", "year", "slice"), 
    eqCnsGETechCvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechCvaromYS = c("cns", "year", "slice"), 
    eqCnsETechCvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechCvaromR = c("cns", "region"), 
    eqCnsGETechCvaromR = c("cns", "region"), 
    eqCnsETechCvaromR = c("cns", "region"), 
    eqCnsLETechCvaromRS = c("cns", "region", "slice"), 
    eqCnsGETechCvaromRS = c("cns", "region", "slice"), 
    eqCnsETechCvaromRS = c("cns", "region", "slice"), 
    eqCnsLETechCvaromRY = c("cns", "region", "year"), 
    eqCnsLETechCvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechCvaromRY = c("cns", "region", "year"), 
    eqCnsGETechCvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechCvaromRY = c("cns", "region", "year"), 
    eqCnsETechCvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechCvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechCvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechCvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechCvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechCvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechCvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechAvarom = c("cns"), 
    eqCnsGETechAvarom = c("cns"), 
    eqCnsETechAvarom = c("cns"), 
    eqCnsLETechAvaromS = c("cns", "slice"), 
    eqCnsGETechAvaromS = c("cns", "slice"), 
    eqCnsETechAvaromS = c("cns", "slice"), 
    eqCnsLETechAvaromY = c("cns", "year"), 
    eqCnsLETechAvaromYGrowth = c("cns", "year", "year"), 
    eqCnsGETechAvaromY = c("cns", "year"), 
    eqCnsGETechAvaromYGrowth = c("cns", "year", "year"), 
    eqCnsETechAvaromY = c("cns", "year"), 
    eqCnsETechAvaromYGrowth = c("cns", "year", "year"), 
    eqCnsLETechAvaromYS = c("cns", "year", "slice"), 
    eqCnsLETechAvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETechAvaromYS = c("cns", "year", "slice"), 
    eqCnsGETechAvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETechAvaromYS = c("cns", "year", "slice"), 
    eqCnsETechAvaromYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETechAvaromR = c("cns", "region"), 
    eqCnsGETechAvaromR = c("cns", "region"), 
    eqCnsETechAvaromR = c("cns", "region"), 
    eqCnsLETechAvaromRS = c("cns", "region", "slice"), 
    eqCnsGETechAvaromRS = c("cns", "region", "slice"), 
    eqCnsETechAvaromRS = c("cns", "region", "slice"), 
    eqCnsLETechAvaromRY = c("cns", "region", "year"), 
    eqCnsLETechAvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETechAvaromRY = c("cns", "region", "year"), 
    eqCnsGETechAvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETechAvaromRY = c("cns", "region", "year"), 
    eqCnsETechAvaromRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETechAvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETechAvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETechAvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETechAvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETechAvaromRYS = c("cns", "region", "year", "slice"), 
    eqCnsETechAvaromRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETechInpLShareIn = c("cns", "tech"), 
    eqCnsLETechInpLShareOut = c("cns", "tech"), 
    eqCnsLETechInpL = c("cns", "tech"), 
    eqCnsGETechInpLShareIn = c("cns", "tech"), 
    eqCnsGETechInpLShareOut = c("cns", "tech"), 
    eqCnsGETechInpL = c("cns", "tech"), 
    eqCnsETechInpLShareIn = c("cns", "tech"), 
    eqCnsETechInpLShareOut = c("cns", "tech"), 
    eqCnsETechInpL = c("cns", "tech"), 
    eqCnsLETechInpLSShareIn = c("cns", "tech", "slice"), 
    eqCnsLETechInpLSShareOut = c("cns", "tech", "slice"), 
    eqCnsLETechInpLS = c("cns", "tech", "slice"), 
    eqCnsGETechInpLSShareIn = c("cns", "tech", "slice"), 
    eqCnsGETechInpLSShareOut = c("cns", "tech", "slice"), 
    eqCnsGETechInpLS = c("cns", "tech", "slice"), 
    eqCnsETechInpLSShareIn = c("cns", "tech", "slice"), 
    eqCnsETechInpLSShareOut = c("cns", "tech", "slice"), 
    eqCnsETechInpLS = c("cns", "tech", "slice"), 
    eqCnsLETechInpLYShareIn = c("cns", "tech", "year"), 
    eqCnsLETechInpLYShareOut = c("cns", "tech", "year"), 
    eqCnsLETechInpLY = c("cns", "tech", "year"), 
    eqCnsLETechInpLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechInpLYShareIn = c("cns", "tech", "year"), 
    eqCnsGETechInpLYShareOut = c("cns", "tech", "year"), 
    eqCnsGETechInpLY = c("cns", "tech", "year"), 
    eqCnsGETechInpLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechInpLYShareIn = c("cns", "tech", "year"), 
    eqCnsETechInpLYShareOut = c("cns", "tech", "year"), 
    eqCnsETechInpLY = c("cns", "tech", "year"), 
    eqCnsETechInpLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechInpLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsLETechInpLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsLETechInpLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechInpLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechInpLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsGETechInpLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsGETechInpLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechInpLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechInpLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsETechInpLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsETechInpLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechInpLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechInpLRShareIn = c("cns", "tech", "region"), 
    eqCnsLETechInpLRShareOut = c("cns", "tech", "region"), 
    eqCnsLETechInpLR = c("cns", "tech", "region"), 
    eqCnsGETechInpLRShareIn = c("cns", "tech", "region"), 
    eqCnsGETechInpLRShareOut = c("cns", "tech", "region"), 
    eqCnsGETechInpLR = c("cns", "tech", "region"), 
    eqCnsETechInpLRShareIn = c("cns", "tech", "region"), 
    eqCnsETechInpLRShareOut = c("cns", "tech", "region"), 
    eqCnsETechInpLR = c("cns", "tech", "region"), 
    eqCnsLETechInpLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsLETechInpLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsLETechInpLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechInpLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsGETechInpLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsGETechInpLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechInpLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsETechInpLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsETechInpLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechInpLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsLETechInpLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsLETechInpLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechInpLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechInpLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsGETechInpLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsGETechInpLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechInpLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechInpLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsETechInpLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsETechInpLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechInpLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechInpLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechInpLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechInpLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechInpLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechInpLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechInpLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechInpLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechInpLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechInpLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechInpLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechInpLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechInpLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechInpLCShareIn = c("cns", "tech", "comm"), 
    eqCnsLETechInpLCShareOut = c("cns", "tech", "comm"), 
    eqCnsLETechInpLC = c("cns", "tech", "comm"), 
    eqCnsGETechInpLCShareIn = c("cns", "tech", "comm"), 
    eqCnsGETechInpLCShareOut = c("cns", "tech", "comm"), 
    eqCnsGETechInpLC = c("cns", "tech", "comm"), 
    eqCnsETechInpLCShareIn = c("cns", "tech", "comm"), 
    eqCnsETechInpLCShareOut = c("cns", "tech", "comm"), 
    eqCnsETechInpLC = c("cns", "tech", "comm"), 
    eqCnsLETechInpLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechInpLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechInpLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechInpLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechInpLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechInpLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsETechInpLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsETechInpLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsETechInpLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechInpLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsLETechInpLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsLETechInpLCY = c("cns", "tech", "comm", "year"), 
    eqCnsLETechInpLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsGETechInpLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsGETechInpLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsGETechInpLCY = c("cns", "tech", "comm", "year"), 
    eqCnsGETechInpLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsETechInpLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsETechInpLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsETechInpLCY = c("cns", "tech", "comm", "year"), 
    eqCnsETechInpLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsLETechInpLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechInpLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechInpLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechInpLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsGETechInpLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechInpLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechInpLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechInpLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsETechInpLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechInpLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechInpLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechInpLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsLETechInpLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsLETechInpLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsLETechInpLCR = c("cns", "tech", "comm", "region"), 
    eqCnsGETechInpLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsGETechInpLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsGETechInpLCR = c("cns", "tech", "comm", "region"), 
    eqCnsETechInpLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsETechInpLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsETechInpLCR = c("cns", "tech", "comm", "region"), 
    eqCnsLETechInpLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechInpLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechInpLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechInpLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechInpLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechInpLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechInpLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechInpLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechInpLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechInpLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechInpLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechInpLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechInpLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsGETechInpLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechInpLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechInpLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechInpLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsETechInpLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechInpLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechInpLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechInpLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsLETechInpLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechInpLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechInpLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechInpLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsGETechInpLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechInpLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechInpLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechInpLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsETechInpLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechInpLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechInpLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechInpLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsLETechOutLShareIn = c("cns", "tech"), 
    eqCnsLETechOutLShareOut = c("cns", "tech"), 
    eqCnsLETechOutL = c("cns", "tech"), 
    eqCnsGETechOutLShareIn = c("cns", "tech"), 
    eqCnsGETechOutLShareOut = c("cns", "tech"), 
    eqCnsGETechOutL = c("cns", "tech"), 
    eqCnsETechOutLShareIn = c("cns", "tech"), 
    eqCnsETechOutLShareOut = c("cns", "tech"), 
    eqCnsETechOutL = c("cns", "tech"), 
    eqCnsLETechOutLSShareIn = c("cns", "tech", "slice"), 
    eqCnsLETechOutLSShareOut = c("cns", "tech", "slice"), 
    eqCnsLETechOutLS = c("cns", "tech", "slice"), 
    eqCnsGETechOutLSShareIn = c("cns", "tech", "slice"), 
    eqCnsGETechOutLSShareOut = c("cns", "tech", "slice"), 
    eqCnsGETechOutLS = c("cns", "tech", "slice"), 
    eqCnsETechOutLSShareIn = c("cns", "tech", "slice"), 
    eqCnsETechOutLSShareOut = c("cns", "tech", "slice"), 
    eqCnsETechOutLS = c("cns", "tech", "slice"), 
    eqCnsLETechOutLYShareIn = c("cns", "tech", "year"), 
    eqCnsLETechOutLYShareOut = c("cns", "tech", "year"), 
    eqCnsLETechOutLY = c("cns", "tech", "year"), 
    eqCnsLETechOutLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechOutLYShareIn = c("cns", "tech", "year"), 
    eqCnsGETechOutLYShareOut = c("cns", "tech", "year"), 
    eqCnsGETechOutLY = c("cns", "tech", "year"), 
    eqCnsGETechOutLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechOutLYShareIn = c("cns", "tech", "year"), 
    eqCnsETechOutLYShareOut = c("cns", "tech", "year"), 
    eqCnsETechOutLY = c("cns", "tech", "year"), 
    eqCnsETechOutLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechOutLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsLETechOutLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsLETechOutLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechOutLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechOutLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsGETechOutLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsGETechOutLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechOutLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechOutLYSShareIn = c("cns", "tech", "year", "slice"), 
    eqCnsETechOutLYSShareOut = c("cns", "tech", "year", "slice"), 
    eqCnsETechOutLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechOutLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechOutLRShareIn = c("cns", "tech", "region"), 
    eqCnsLETechOutLRShareOut = c("cns", "tech", "region"), 
    eqCnsLETechOutLR = c("cns", "tech", "region"), 
    eqCnsGETechOutLRShareIn = c("cns", "tech", "region"), 
    eqCnsGETechOutLRShareOut = c("cns", "tech", "region"), 
    eqCnsGETechOutLR = c("cns", "tech", "region"), 
    eqCnsETechOutLRShareIn = c("cns", "tech", "region"), 
    eqCnsETechOutLRShareOut = c("cns", "tech", "region"), 
    eqCnsETechOutLR = c("cns", "tech", "region"), 
    eqCnsLETechOutLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsLETechOutLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsLETechOutLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechOutLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsGETechOutLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsGETechOutLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechOutLRSShareIn = c("cns", "tech", "region", "slice"), 
    eqCnsETechOutLRSShareOut = c("cns", "tech", "region", "slice"), 
    eqCnsETechOutLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechOutLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsLETechOutLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsLETechOutLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechOutLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechOutLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsGETechOutLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsGETechOutLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechOutLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechOutLRYShareIn = c("cns", "tech", "region", "year"), 
    eqCnsETechOutLRYShareOut = c("cns", "tech", "region", "year"), 
    eqCnsETechOutLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechOutLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechOutLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechOutLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechOutLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechOutLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechOutLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechOutLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechOutLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechOutLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechOutLRYSShareIn = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechOutLRYSShareOut = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechOutLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechOutLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechOutLCShareIn = c("cns", "tech", "comm"), 
    eqCnsLETechOutLCShareOut = c("cns", "tech", "comm"), 
    eqCnsLETechOutLC = c("cns", "tech", "comm"), 
    eqCnsGETechOutLCShareIn = c("cns", "tech", "comm"), 
    eqCnsGETechOutLCShareOut = c("cns", "tech", "comm"), 
    eqCnsGETechOutLC = c("cns", "tech", "comm"), 
    eqCnsETechOutLCShareIn = c("cns", "tech", "comm"), 
    eqCnsETechOutLCShareOut = c("cns", "tech", "comm"), 
    eqCnsETechOutLC = c("cns", "tech", "comm"), 
    eqCnsLETechOutLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechOutLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechOutLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechOutLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechOutLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsGETechOutLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsETechOutLCSShareIn = c("cns", "tech", "comm", "slice"), 
    eqCnsETechOutLCSShareOut = c("cns", "tech", "comm", "slice"), 
    eqCnsETechOutLCS = c("cns", "tech", "comm", "slice"), 
    eqCnsLETechOutLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsLETechOutLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsLETechOutLCY = c("cns", "tech", "comm", "year"), 
    eqCnsLETechOutLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsGETechOutLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsGETechOutLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsGETechOutLCY = c("cns", "tech", "comm", "year"), 
    eqCnsGETechOutLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsETechOutLCYShareIn = c("cns", "tech", "comm", "year"), 
    eqCnsETechOutLCYShareOut = c("cns", "tech", "comm", "year"), 
    eqCnsETechOutLCY = c("cns", "tech", "comm", "year"), 
    eqCnsETechOutLCYGrowth = c("cns", "tech", "comm", "year", "year"), 
    eqCnsLETechOutLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechOutLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechOutLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsLETechOutLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsGETechOutLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechOutLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechOutLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsGETechOutLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsETechOutLCYSShareIn = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechOutLCYSShareOut = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechOutLCYS = c("cns", "tech", "comm", "year", "slice"), 
    eqCnsETechOutLCYSGrowth = c("cns", "tech", "comm", "year", "slice", "year"), 
    eqCnsLETechOutLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsLETechOutLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsLETechOutLCR = c("cns", "tech", "comm", "region"), 
    eqCnsGETechOutLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsGETechOutLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsGETechOutLCR = c("cns", "tech", "comm", "region"), 
    eqCnsETechOutLCRShareIn = c("cns", "tech", "comm", "region"), 
    eqCnsETechOutLCRShareOut = c("cns", "tech", "comm", "region"), 
    eqCnsETechOutLCR = c("cns", "tech", "comm", "region"), 
    eqCnsLETechOutLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechOutLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechOutLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechOutLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechOutLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsGETechOutLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechOutLCRSShareIn = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechOutLCRSShareOut = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsETechOutLCRS = c("cns", "tech", "comm", "region", "slice"), 
    eqCnsLETechOutLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechOutLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechOutLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsLETechOutLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsGETechOutLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechOutLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechOutLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsGETechOutLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsETechOutLCRYShareIn = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechOutLCRYShareOut = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechOutLCRY = c("cns", "tech", "comm", "region", "year"), 
    eqCnsETechOutLCRYGrowth = c("cns", "tech", "comm", "region", "year", "year"), 
    eqCnsLETechOutLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechOutLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechOutLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsLETechOutLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsGETechOutLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechOutLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechOutLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsGETechOutLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsETechOutLCRYSShareIn = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechOutLCRYSShareOut = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechOutLCRYS = c("cns", "tech", "comm", "region", "year", "slice"), 
    eqCnsETechOutLCRYSGrowth = c("cns", "tech", "comm", "region", "year", "slice", "year"), 
    eqCnsLETechCapL = c("cns", "tech"), 
    eqCnsGETechCapL = c("cns", "tech"), 
    eqCnsETechCapL = c("cns", "tech"), 
    eqCnsLETechCapLY = c("cns", "tech", "year"), 
    eqCnsLETechCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechCapLY = c("cns", "tech", "year"), 
    eqCnsGETechCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechCapLY = c("cns", "tech", "year"), 
    eqCnsETechCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechCapLR = c("cns", "tech", "region"), 
    eqCnsGETechCapLR = c("cns", "tech", "region"), 
    eqCnsETechCapLR = c("cns", "tech", "region"), 
    eqCnsLETechCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechNewCapL = c("cns", "tech"), 
    eqCnsGETechNewCapL = c("cns", "tech"), 
    eqCnsETechNewCapL = c("cns", "tech"), 
    eqCnsLETechNewCapLY = c("cns", "tech", "year"), 
    eqCnsLETechNewCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechNewCapLY = c("cns", "tech", "year"), 
    eqCnsGETechNewCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechNewCapLY = c("cns", "tech", "year"), 
    eqCnsETechNewCapLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechNewCapLR = c("cns", "tech", "region"), 
    eqCnsGETechNewCapLR = c("cns", "tech", "region"), 
    eqCnsETechNewCapLR = c("cns", "tech", "region"), 
    eqCnsLETechNewCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechNewCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechNewCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechNewCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechNewCapLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechNewCapLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechInvL = c("cns", "tech"), 
    eqCnsGETechInvL = c("cns", "tech"), 
    eqCnsETechInvL = c("cns", "tech"), 
    eqCnsLETechInvLY = c("cns", "tech", "year"), 
    eqCnsLETechInvLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechInvLY = c("cns", "tech", "year"), 
    eqCnsGETechInvLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechInvLY = c("cns", "tech", "year"), 
    eqCnsETechInvLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechInvLR = c("cns", "tech", "region"), 
    eqCnsGETechInvLR = c("cns", "tech", "region"), 
    eqCnsETechInvLR = c("cns", "tech", "region"), 
    eqCnsLETechInvLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechInvLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechInvLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechInvLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechInvLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechInvLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechEacL = c("cns", "tech"), 
    eqCnsGETechEacL = c("cns", "tech"), 
    eqCnsETechEacL = c("cns", "tech"), 
    eqCnsLETechEacLY = c("cns", "tech", "year"), 
    eqCnsLETechEacLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechEacLY = c("cns", "tech", "year"), 
    eqCnsGETechEacLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechEacLY = c("cns", "tech", "year"), 
    eqCnsETechEacLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechEacLR = c("cns", "tech", "region"), 
    eqCnsGETechEacLR = c("cns", "tech", "region"), 
    eqCnsETechEacLR = c("cns", "tech", "region"), 
    eqCnsLETechEacLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechEacLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechEacLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechEacLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechEacLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechEacLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechActL = c("cns", "tech"), 
    eqCnsGETechActL = c("cns", "tech"), 
    eqCnsETechActL = c("cns", "tech"), 
    eqCnsLETechActLS = c("cns", "tech", "slice"), 
    eqCnsGETechActLS = c("cns", "tech", "slice"), 
    eqCnsETechActLS = c("cns", "tech", "slice"), 
    eqCnsLETechActLY = c("cns", "tech", "year"), 
    eqCnsLETechActLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechActLY = c("cns", "tech", "year"), 
    eqCnsGETechActLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechActLY = c("cns", "tech", "year"), 
    eqCnsETechActLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechActLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechActLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechActLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechActLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechActLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechActLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechActLR = c("cns", "tech", "region"), 
    eqCnsGETechActLR = c("cns", "tech", "region"), 
    eqCnsETechActLR = c("cns", "tech", "region"), 
    eqCnsLETechActLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechActLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechActLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechActLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechActLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechActLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechActLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechActLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechActLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechActLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechActLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechActLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechActLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechActLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechActLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechVaromL = c("cns", "tech"), 
    eqCnsGETechVaromL = c("cns", "tech"), 
    eqCnsETechVaromL = c("cns", "tech"), 
    eqCnsLETechVaromLS = c("cns", "tech", "slice"), 
    eqCnsGETechVaromLS = c("cns", "tech", "slice"), 
    eqCnsETechVaromLS = c("cns", "tech", "slice"), 
    eqCnsLETechVaromLY = c("cns", "tech", "year"), 
    eqCnsLETechVaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechVaromLY = c("cns", "tech", "year"), 
    eqCnsGETechVaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechVaromLY = c("cns", "tech", "year"), 
    eqCnsETechVaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechVaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechVaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechVaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechVaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechVaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechVaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechVaromLR = c("cns", "tech", "region"), 
    eqCnsGETechVaromLR = c("cns", "tech", "region"), 
    eqCnsETechVaromLR = c("cns", "tech", "region"), 
    eqCnsLETechVaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechVaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechVaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechVaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechVaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechVaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechVaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechVaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechVaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechVaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechVaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechVaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechVaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechVaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechVaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechFixomL = c("cns", "tech"), 
    eqCnsGETechFixomL = c("cns", "tech"), 
    eqCnsETechFixomL = c("cns", "tech"), 
    eqCnsLETechFixomLY = c("cns", "tech", "year"), 
    eqCnsLETechFixomLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechFixomLY = c("cns", "tech", "year"), 
    eqCnsGETechFixomLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechFixomLY = c("cns", "tech", "year"), 
    eqCnsETechFixomLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechFixomLR = c("cns", "tech", "region"), 
    eqCnsGETechFixomLR = c("cns", "tech", "region"), 
    eqCnsETechFixomLR = c("cns", "tech", "region"), 
    eqCnsLETechFixomLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechFixomLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechFixomLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechFixomLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechFixomLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechFixomLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechActvaromL = c("cns", "tech"), 
    eqCnsGETechActvaromL = c("cns", "tech"), 
    eqCnsETechActvaromL = c("cns", "tech"), 
    eqCnsLETechActvaromLS = c("cns", "tech", "slice"), 
    eqCnsGETechActvaromLS = c("cns", "tech", "slice"), 
    eqCnsETechActvaromLS = c("cns", "tech", "slice"), 
    eqCnsLETechActvaromLY = c("cns", "tech", "year"), 
    eqCnsLETechActvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechActvaromLY = c("cns", "tech", "year"), 
    eqCnsGETechActvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechActvaromLY = c("cns", "tech", "year"), 
    eqCnsETechActvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechActvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechActvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechActvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechActvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechActvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechActvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechActvaromLR = c("cns", "tech", "region"), 
    eqCnsGETechActvaromLR = c("cns", "tech", "region"), 
    eqCnsETechActvaromLR = c("cns", "tech", "region"), 
    eqCnsLETechActvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechActvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechActvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechActvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechActvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechActvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechActvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechActvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechActvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechActvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechActvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechActvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechActvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechActvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechActvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechCvaromL = c("cns", "tech"), 
    eqCnsGETechCvaromL = c("cns", "tech"), 
    eqCnsETechCvaromL = c("cns", "tech"), 
    eqCnsLETechCvaromLS = c("cns", "tech", "slice"), 
    eqCnsGETechCvaromLS = c("cns", "tech", "slice"), 
    eqCnsETechCvaromLS = c("cns", "tech", "slice"), 
    eqCnsLETechCvaromLY = c("cns", "tech", "year"), 
    eqCnsLETechCvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechCvaromLY = c("cns", "tech", "year"), 
    eqCnsGETechCvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechCvaromLY = c("cns", "tech", "year"), 
    eqCnsETechCvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechCvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechCvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechCvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechCvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechCvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechCvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechCvaromLR = c("cns", "tech", "region"), 
    eqCnsGETechCvaromLR = c("cns", "tech", "region"), 
    eqCnsETechCvaromLR = c("cns", "tech", "region"), 
    eqCnsLETechCvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechCvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechCvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechCvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechCvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechCvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechCvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechCvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechCvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechCvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechCvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechCvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechCvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechCvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechCvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLETechAvaromL = c("cns", "tech"), 
    eqCnsGETechAvaromL = c("cns", "tech"), 
    eqCnsETechAvaromL = c("cns", "tech"), 
    eqCnsLETechAvaromLS = c("cns", "tech", "slice"), 
    eqCnsGETechAvaromLS = c("cns", "tech", "slice"), 
    eqCnsETechAvaromLS = c("cns", "tech", "slice"), 
    eqCnsLETechAvaromLY = c("cns", "tech", "year"), 
    eqCnsLETechAvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsGETechAvaromLY = c("cns", "tech", "year"), 
    eqCnsGETechAvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsETechAvaromLY = c("cns", "tech", "year"), 
    eqCnsETechAvaromLYGrowth = c("cns", "tech", "year", "year"), 
    eqCnsLETechAvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsLETechAvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsGETechAvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsGETechAvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsETechAvaromLYS = c("cns", "tech", "year", "slice"), 
    eqCnsETechAvaromLYSGrowth = c("cns", "tech", "year", "slice", "year"), 
    eqCnsLETechAvaromLR = c("cns", "tech", "region"), 
    eqCnsGETechAvaromLR = c("cns", "tech", "region"), 
    eqCnsETechAvaromLR = c("cns", "tech", "region"), 
    eqCnsLETechAvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsGETechAvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsETechAvaromLRS = c("cns", "tech", "region", "slice"), 
    eqCnsLETechAvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsLETechAvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsGETechAvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsGETechAvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsETechAvaromLRY = c("cns", "tech", "region", "year"), 
    eqCnsETechAvaromLRYGrowth = c("cns", "tech", "region", "year", "year"), 
    eqCnsLETechAvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsLETechAvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsGETechAvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsGETechAvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsETechAvaromLRYS = c("cns", "tech", "region", "year", "slice"), 
    eqCnsETechAvaromLRYSGrowth = c("cns", "tech", "region", "year", "slice", "year"), 
    eqCnsLESupOutShareIn = c("cns"), 
    eqCnsLESupOutShareOut = c("cns"), 
    eqCnsLESupOut = c("cns"), 
    eqCnsGESupOutShareIn = c("cns"), 
    eqCnsGESupOutShareOut = c("cns"), 
    eqCnsGESupOut = c("cns"), 
    eqCnsESupOutShareIn = c("cns"), 
    eqCnsESupOutShareOut = c("cns"), 
    eqCnsESupOut = c("cns"), 
    eqCnsLESupOutSShareIn = c("cns", "slice"), 
    eqCnsLESupOutSShareOut = c("cns", "slice"), 
    eqCnsLESupOutS = c("cns", "slice"), 
    eqCnsGESupOutSShareIn = c("cns", "slice"), 
    eqCnsGESupOutSShareOut = c("cns", "slice"), 
    eqCnsGESupOutS = c("cns", "slice"), 
    eqCnsESupOutSShareIn = c("cns", "slice"), 
    eqCnsESupOutSShareOut = c("cns", "slice"), 
    eqCnsESupOutS = c("cns", "slice"), 
    eqCnsLESupOutYShareIn = c("cns", "year"), 
    eqCnsLESupOutYShareOut = c("cns", "year"), 
    eqCnsLESupOutY = c("cns", "year"), 
    eqCnsLESupOutYGrowth = c("cns", "year", "year"), 
    eqCnsGESupOutYShareIn = c("cns", "year"), 
    eqCnsGESupOutYShareOut = c("cns", "year"), 
    eqCnsGESupOutY = c("cns", "year"), 
    eqCnsGESupOutYGrowth = c("cns", "year", "year"), 
    eqCnsESupOutYShareIn = c("cns", "year"), 
    eqCnsESupOutYShareOut = c("cns", "year"), 
    eqCnsESupOutY = c("cns", "year"), 
    eqCnsESupOutYGrowth = c("cns", "year", "year"), 
    eqCnsLESupOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsLESupOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsLESupOutYS = c("cns", "year", "slice"), 
    eqCnsLESupOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGESupOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsGESupOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsGESupOutYS = c("cns", "year", "slice"), 
    eqCnsGESupOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsESupOutYSShareIn = c("cns", "year", "slice"), 
    eqCnsESupOutYSShareOut = c("cns", "year", "slice"), 
    eqCnsESupOutYS = c("cns", "year", "slice"), 
    eqCnsESupOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLESupOutRShareIn = c("cns", "region"), 
    eqCnsLESupOutRShareOut = c("cns", "region"), 
    eqCnsLESupOutR = c("cns", "region"), 
    eqCnsGESupOutRShareIn = c("cns", "region"), 
    eqCnsGESupOutRShareOut = c("cns", "region"), 
    eqCnsGESupOutR = c("cns", "region"), 
    eqCnsESupOutRShareIn = c("cns", "region"), 
    eqCnsESupOutRShareOut = c("cns", "region"), 
    eqCnsESupOutR = c("cns", "region"), 
    eqCnsLESupOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsLESupOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsLESupOutRS = c("cns", "region", "slice"), 
    eqCnsGESupOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsGESupOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsGESupOutRS = c("cns", "region", "slice"), 
    eqCnsESupOutRSShareIn = c("cns", "region", "slice"), 
    eqCnsESupOutRSShareOut = c("cns", "region", "slice"), 
    eqCnsESupOutRS = c("cns", "region", "slice"), 
    eqCnsLESupOutRYShareIn = c("cns", "region", "year"), 
    eqCnsLESupOutRYShareOut = c("cns", "region", "year"), 
    eqCnsLESupOutRY = c("cns", "region", "year"), 
    eqCnsLESupOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGESupOutRYShareIn = c("cns", "region", "year"), 
    eqCnsGESupOutRYShareOut = c("cns", "region", "year"), 
    eqCnsGESupOutRY = c("cns", "region", "year"), 
    eqCnsGESupOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsESupOutRYShareIn = c("cns", "region", "year"), 
    eqCnsESupOutRYShareOut = c("cns", "region", "year"), 
    eqCnsESupOutRY = c("cns", "region", "year"), 
    eqCnsESupOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLESupOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsLESupOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsLESupOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsLESupOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGESupOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsGESupOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsGESupOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsGESupOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsESupOutRYSShareIn = c("cns", "region", "year", "slice"), 
    eqCnsESupOutRYSShareOut = c("cns", "region", "year", "slice"), 
    eqCnsESupOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsESupOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLESupOutCShareIn = c("cns", "comm"), 
    eqCnsLESupOutCShareOut = c("cns", "comm"), 
    eqCnsLESupOutC = c("cns", "comm"), 
    eqCnsGESupOutCShareIn = c("cns", "comm"), 
    eqCnsGESupOutCShareOut = c("cns", "comm"), 
    eqCnsGESupOutC = c("cns", "comm"), 
    eqCnsESupOutCShareIn = c("cns", "comm"), 
    eqCnsESupOutCShareOut = c("cns", "comm"), 
    eqCnsESupOutC = c("cns", "comm"), 
    eqCnsLESupOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsLESupOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsLESupOutCS = c("cns", "comm", "slice"), 
    eqCnsGESupOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsGESupOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsGESupOutCS = c("cns", "comm", "slice"), 
    eqCnsESupOutCSShareIn = c("cns", "comm", "slice"), 
    eqCnsESupOutCSShareOut = c("cns", "comm", "slice"), 
    eqCnsESupOutCS = c("cns", "comm", "slice"), 
    eqCnsLESupOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsLESupOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsLESupOutCY = c("cns", "comm", "year"), 
    eqCnsLESupOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsGESupOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsGESupOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsGESupOutCY = c("cns", "comm", "year"), 
    eqCnsGESupOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsESupOutCYShareIn = c("cns", "comm", "year"), 
    eqCnsESupOutCYShareOut = c("cns", "comm", "year"), 
    eqCnsESupOutCY = c("cns", "comm", "year"), 
    eqCnsESupOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsLESupOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsLESupOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsLESupOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsLESupOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsGESupOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsGESupOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsGESupOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsGESupOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsESupOutCYSShareIn = c("cns", "comm", "year", "slice"), 
    eqCnsESupOutCYSShareOut = c("cns", "comm", "year", "slice"), 
    eqCnsESupOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsESupOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsLESupOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsLESupOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsLESupOutCR = c("cns", "comm", "region"), 
    eqCnsGESupOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsGESupOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsGESupOutCR = c("cns", "comm", "region"), 
    eqCnsESupOutCRShareIn = c("cns", "comm", "region"), 
    eqCnsESupOutCRShareOut = c("cns", "comm", "region"), 
    eqCnsESupOutCR = c("cns", "comm", "region"), 
    eqCnsLESupOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsLESupOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsLESupOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsGESupOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsGESupOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsGESupOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsESupOutCRSShareIn = c("cns", "comm", "region", "slice"), 
    eqCnsESupOutCRSShareOut = c("cns", "comm", "region", "slice"), 
    eqCnsESupOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsLESupOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsLESupOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsLESupOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsLESupOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsGESupOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsGESupOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsGESupOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsGESupOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsESupOutCRYShareIn = c("cns", "comm", "region", "year"), 
    eqCnsESupOutCRYShareOut = c("cns", "comm", "region", "year"), 
    eqCnsESupOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsESupOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsLESupOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLESupOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLESupOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLESupOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsGESupOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGESupOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGESupOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGESupOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsESupOutCRYSShareIn = c("cns", "comm", "region", "year", "slice"), 
    eqCnsESupOutCRYSShareOut = c("cns", "comm", "region", "year", "slice"), 
    eqCnsESupOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsESupOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsLESupOutLShareIn = c("cns", "sup"), 
    eqCnsLESupOutLShareOut = c("cns", "sup"), 
    eqCnsLESupOutL = c("cns", "sup"), 
    eqCnsGESupOutLShareIn = c("cns", "sup"), 
    eqCnsGESupOutLShareOut = c("cns", "sup"), 
    eqCnsGESupOutL = c("cns", "sup"), 
    eqCnsESupOutLShareIn = c("cns", "sup"), 
    eqCnsESupOutLShareOut = c("cns", "sup"), 
    eqCnsESupOutL = c("cns", "sup"), 
    eqCnsLESupOutLSShareIn = c("cns", "sup", "slice"), 
    eqCnsLESupOutLSShareOut = c("cns", "sup", "slice"), 
    eqCnsLESupOutLS = c("cns", "sup", "slice"), 
    eqCnsGESupOutLSShareIn = c("cns", "sup", "slice"), 
    eqCnsGESupOutLSShareOut = c("cns", "sup", "slice"), 
    eqCnsGESupOutLS = c("cns", "sup", "slice"), 
    eqCnsESupOutLSShareIn = c("cns", "sup", "slice"), 
    eqCnsESupOutLSShareOut = c("cns", "sup", "slice"), 
    eqCnsESupOutLS = c("cns", "sup", "slice"), 
    eqCnsLESupOutLYShareIn = c("cns", "sup", "year"), 
    eqCnsLESupOutLYShareOut = c("cns", "sup", "year"), 
    eqCnsLESupOutLY = c("cns", "sup", "year"), 
    eqCnsLESupOutLYGrowth = c("cns", "sup", "year", "year"), 
    eqCnsGESupOutLYShareIn = c("cns", "sup", "year"), 
    eqCnsGESupOutLYShareOut = c("cns", "sup", "year"), 
    eqCnsGESupOutLY = c("cns", "sup", "year"), 
    eqCnsGESupOutLYGrowth = c("cns", "sup", "year", "year"), 
    eqCnsESupOutLYShareIn = c("cns", "sup", "year"), 
    eqCnsESupOutLYShareOut = c("cns", "sup", "year"), 
    eqCnsESupOutLY = c("cns", "sup", "year"), 
    eqCnsESupOutLYGrowth = c("cns", "sup", "year", "year"), 
    eqCnsLESupOutLYSShareIn = c("cns", "sup", "year", "slice"), 
    eqCnsLESupOutLYSShareOut = c("cns", "sup", "year", "slice"), 
    eqCnsLESupOutLYS = c("cns", "sup", "year", "slice"), 
    eqCnsLESupOutLYSGrowth = c("cns", "sup", "year", "slice", "year"), 
    eqCnsGESupOutLYSShareIn = c("cns", "sup", "year", "slice"), 
    eqCnsGESupOutLYSShareOut = c("cns", "sup", "year", "slice"), 
    eqCnsGESupOutLYS = c("cns", "sup", "year", "slice"), 
    eqCnsGESupOutLYSGrowth = c("cns", "sup", "year", "slice", "year"), 
    eqCnsESupOutLYSShareIn = c("cns", "sup", "year", "slice"), 
    eqCnsESupOutLYSShareOut = c("cns", "sup", "year", "slice"), 
    eqCnsESupOutLYS = c("cns", "sup", "year", "slice"), 
    eqCnsESupOutLYSGrowth = c("cns", "sup", "year", "slice", "year"), 
    eqCnsLESupOutLRShareIn = c("cns", "sup", "region"), 
    eqCnsLESupOutLRShareOut = c("cns", "sup", "region"), 
    eqCnsLESupOutLR = c("cns", "sup", "region"), 
    eqCnsGESupOutLRShareIn = c("cns", "sup", "region"), 
    eqCnsGESupOutLRShareOut = c("cns", "sup", "region"), 
    eqCnsGESupOutLR = c("cns", "sup", "region"), 
    eqCnsESupOutLRShareIn = c("cns", "sup", "region"), 
    eqCnsESupOutLRShareOut = c("cns", "sup", "region"), 
    eqCnsESupOutLR = c("cns", "sup", "region"), 
    eqCnsLESupOutLRSShareIn = c("cns", "sup", "region", "slice"), 
    eqCnsLESupOutLRSShareOut = c("cns", "sup", "region", "slice"), 
    eqCnsLESupOutLRS = c("cns", "sup", "region", "slice"), 
    eqCnsGESupOutLRSShareIn = c("cns", "sup", "region", "slice"), 
    eqCnsGESupOutLRSShareOut = c("cns", "sup", "region", "slice"), 
    eqCnsGESupOutLRS = c("cns", "sup", "region", "slice"), 
    eqCnsESupOutLRSShareIn = c("cns", "sup", "region", "slice"), 
    eqCnsESupOutLRSShareOut = c("cns", "sup", "region", "slice"), 
    eqCnsESupOutLRS = c("cns", "sup", "region", "slice"), 
    eqCnsLESupOutLRYShareIn = c("cns", "sup", "region", "year"), 
    eqCnsLESupOutLRYShareOut = c("cns", "sup", "region", "year"), 
    eqCnsLESupOutLRY = c("cns", "sup", "region", "year"), 
    eqCnsLESupOutLRYGrowth = c("cns", "sup", "region", "year", "year"), 
    eqCnsGESupOutLRYShareIn = c("cns", "sup", "region", "year"), 
    eqCnsGESupOutLRYShareOut = c("cns", "sup", "region", "year"), 
    eqCnsGESupOutLRY = c("cns", "sup", "region", "year"), 
    eqCnsGESupOutLRYGrowth = c("cns", "sup", "region", "year", "year"), 
    eqCnsESupOutLRYShareIn = c("cns", "sup", "region", "year"), 
    eqCnsESupOutLRYShareOut = c("cns", "sup", "region", "year"), 
    eqCnsESupOutLRY = c("cns", "sup", "region", "year"), 
    eqCnsESupOutLRYGrowth = c("cns", "sup", "region", "year", "year"), 
    eqCnsLESupOutLRYSShareIn = c("cns", "sup", "region", "year", "slice"), 
    eqCnsLESupOutLRYSShareOut = c("cns", "sup", "region", "year", "slice"), 
    eqCnsLESupOutLRYS = c("cns", "sup", "region", "year", "slice"), 
    eqCnsLESupOutLRYSGrowth = c("cns", "sup", "region", "year", "slice", "year"), 
    eqCnsGESupOutLRYSShareIn = c("cns", "sup", "region", "year", "slice"), 
    eqCnsGESupOutLRYSShareOut = c("cns", "sup", "region", "year", "slice"), 
    eqCnsGESupOutLRYS = c("cns", "sup", "region", "year", "slice"), 
    eqCnsGESupOutLRYSGrowth = c("cns", "sup", "region", "year", "slice", "year"), 
    eqCnsESupOutLRYSShareIn = c("cns", "sup", "region", "year", "slice"), 
    eqCnsESupOutLRYSShareOut = c("cns", "sup", "region", "year", "slice"), 
    eqCnsESupOutLRYS = c("cns", "sup", "region", "year", "slice"), 
    eqCnsESupOutLRYSGrowth = c("cns", "sup", "region", "year", "slice", "year"), 
    eqCnsLESupOutLCShareIn = c("cns", "sup", "comm"), 
    eqCnsLESupOutLCShareOut = c("cns", "sup", "comm"), 
    eqCnsLESupOutLC = c("cns", "sup", "comm"), 
    eqCnsGESupOutLCShareIn = c("cns", "sup", "comm"), 
    eqCnsGESupOutLCShareOut = c("cns", "sup", "comm"), 
    eqCnsGESupOutLC = c("cns", "sup", "comm"), 
    eqCnsESupOutLCShareIn = c("cns", "sup", "comm"), 
    eqCnsESupOutLCShareOut = c("cns", "sup", "comm"), 
    eqCnsESupOutLC = c("cns", "sup", "comm"), 
    eqCnsLESupOutLCSShareIn = c("cns", "sup", "comm", "slice"), 
    eqCnsLESupOutLCSShareOut = c("cns", "sup", "comm", "slice"), 
    eqCnsLESupOutLCS = c("cns", "sup", "comm", "slice"), 
    eqCnsGESupOutLCSShareIn = c("cns", "sup", "comm", "slice"), 
    eqCnsGESupOutLCSShareOut = c("cns", "sup", "comm", "slice"), 
    eqCnsGESupOutLCS = c("cns", "sup", "comm", "slice"), 
    eqCnsESupOutLCSShareIn = c("cns", "sup", "comm", "slice"), 
    eqCnsESupOutLCSShareOut = c("cns", "sup", "comm", "slice"), 
    eqCnsESupOutLCS = c("cns", "sup", "comm", "slice"), 
    eqCnsLESupOutLCYShareIn = c("cns", "sup", "comm", "year"), 
    eqCnsLESupOutLCYShareOut = c("cns", "sup", "comm", "year"), 
    eqCnsLESupOutLCY = c("cns", "sup", "comm", "year"), 
    eqCnsLESupOutLCYGrowth = c("cns", "sup", "comm", "year", "year"), 
    eqCnsGESupOutLCYShareIn = c("cns", "sup", "comm", "year"), 
    eqCnsGESupOutLCYShareOut = c("cns", "sup", "comm", "year"), 
    eqCnsGESupOutLCY = c("cns", "sup", "comm", "year"), 
    eqCnsGESupOutLCYGrowth = c("cns", "sup", "comm", "year", "year"), 
    eqCnsESupOutLCYShareIn = c("cns", "sup", "comm", "year"), 
    eqCnsESupOutLCYShareOut = c("cns", "sup", "comm", "year"), 
    eqCnsESupOutLCY = c("cns", "sup", "comm", "year"), 
    eqCnsESupOutLCYGrowth = c("cns", "sup", "comm", "year", "year"), 
    eqCnsLESupOutLCYSShareIn = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsLESupOutLCYSShareOut = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsLESupOutLCYS = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsLESupOutLCYSGrowth = c("cns", "sup", "comm", "year", "slice", "year"), 
    eqCnsGESupOutLCYSShareIn = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsGESupOutLCYSShareOut = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsGESupOutLCYS = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsGESupOutLCYSGrowth = c("cns", "sup", "comm", "year", "slice", "year"), 
    eqCnsESupOutLCYSShareIn = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsESupOutLCYSShareOut = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsESupOutLCYS = c("cns", "sup", "comm", "year", "slice"), 
    eqCnsESupOutLCYSGrowth = c("cns", "sup", "comm", "year", "slice", "year"), 
    eqCnsLESupOutLCRShareIn = c("cns", "sup", "comm", "region"), 
    eqCnsLESupOutLCRShareOut = c("cns", "sup", "comm", "region"), 
    eqCnsLESupOutLCR = c("cns", "sup", "comm", "region"), 
    eqCnsGESupOutLCRShareIn = c("cns", "sup", "comm", "region"), 
    eqCnsGESupOutLCRShareOut = c("cns", "sup", "comm", "region"), 
    eqCnsGESupOutLCR = c("cns", "sup", "comm", "region"), 
    eqCnsESupOutLCRShareIn = c("cns", "sup", "comm", "region"), 
    eqCnsESupOutLCRShareOut = c("cns", "sup", "comm", "region"), 
    eqCnsESupOutLCR = c("cns", "sup", "comm", "region"), 
    eqCnsLESupOutLCRSShareIn = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsLESupOutLCRSShareOut = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsLESupOutLCRS = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsGESupOutLCRSShareIn = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsGESupOutLCRSShareOut = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsGESupOutLCRS = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsESupOutLCRSShareIn = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsESupOutLCRSShareOut = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsESupOutLCRS = c("cns", "sup", "comm", "region", "slice"), 
    eqCnsLESupOutLCRYShareIn = c("cns", "sup", "comm", "region", "year"), 
    eqCnsLESupOutLCRYShareOut = c("cns", "sup", "comm", "region", "year"), 
    eqCnsLESupOutLCRY = c("cns", "sup", "comm", "region", "year"), 
    eqCnsLESupOutLCRYGrowth = c("cns", "sup", "comm", "region", "year", "year"), 
    eqCnsGESupOutLCRYShareIn = c("cns", "sup", "comm", "region", "year"), 
    eqCnsGESupOutLCRYShareOut = c("cns", "sup", "comm", "region", "year"), 
    eqCnsGESupOutLCRY = c("cns", "sup", "comm", "region", "year"), 
    eqCnsGESupOutLCRYGrowth = c("cns", "sup", "comm", "region", "year", "year"), 
    eqCnsESupOutLCRYShareIn = c("cns", "sup", "comm", "region", "year"), 
    eqCnsESupOutLCRYShareOut = c("cns", "sup", "comm", "region", "year"), 
    eqCnsESupOutLCRY = c("cns", "sup", "comm", "region", "year"), 
    eqCnsESupOutLCRYGrowth = c("cns", "sup", "comm", "region", "year", "year"), 
    eqCnsLESupOutLCRYSShareIn = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsLESupOutLCRYSShareOut = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsLESupOutLCRYS = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsLESupOutLCRYSGrowth = c("cns", "sup", "comm", "region", "year", "slice", "year"), 
    eqCnsGESupOutLCRYSShareIn = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsGESupOutLCRYSShareOut = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsGESupOutLCRYS = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsGESupOutLCRYSGrowth = c("cns", "sup", "comm", "region", "year", "slice", "year"), 
    eqCnsESupOutLCRYSShareIn = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsESupOutLCRYSShareOut = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsESupOutLCRYS = c("cns", "sup", "comm", "region", "year", "slice"), 
    eqCnsESupOutLCRYSGrowth = c("cns", "sup", "comm", "region", "year", "slice", "year"), 
    eqCnsLETotInp = c("cns"), 
    eqCnsGETotInp = c("cns"), 
    eqCnsETotInp = c("cns"), 
    eqCnsLETotInpS = c("cns", "slice"), 
    eqCnsGETotInpS = c("cns", "slice"), 
    eqCnsETotInpS = c("cns", "slice"), 
    eqCnsLETotInpY = c("cns", "year"), 
    eqCnsLETotInpYGrowth = c("cns", "year", "year"), 
    eqCnsGETotInpY = c("cns", "year"), 
    eqCnsGETotInpYGrowth = c("cns", "year", "year"), 
    eqCnsETotInpY = c("cns", "year"), 
    eqCnsETotInpYGrowth = c("cns", "year", "year"), 
    eqCnsLETotInpYS = c("cns", "year", "slice"), 
    eqCnsLETotInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETotInpYS = c("cns", "year", "slice"), 
    eqCnsGETotInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETotInpYS = c("cns", "year", "slice"), 
    eqCnsETotInpYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETotInpR = c("cns", "region"), 
    eqCnsGETotInpR = c("cns", "region"), 
    eqCnsETotInpR = c("cns", "region"), 
    eqCnsLETotInpRS = c("cns", "region", "slice"), 
    eqCnsGETotInpRS = c("cns", "region", "slice"), 
    eqCnsETotInpRS = c("cns", "region", "slice"), 
    eqCnsLETotInpRY = c("cns", "region", "year"), 
    eqCnsLETotInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETotInpRY = c("cns", "region", "year"), 
    eqCnsGETotInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETotInpRY = c("cns", "region", "year"), 
    eqCnsETotInpRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETotInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETotInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETotInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETotInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETotInpRYS = c("cns", "region", "year", "slice"), 
    eqCnsETotInpRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETotInpC = c("cns", "comm"), 
    eqCnsGETotInpC = c("cns", "comm"), 
    eqCnsETotInpC = c("cns", "comm"), 
    eqCnsLETotInpCS = c("cns", "comm", "slice"), 
    eqCnsGETotInpCS = c("cns", "comm", "slice"), 
    eqCnsETotInpCS = c("cns", "comm", "slice"), 
    eqCnsLETotInpCY = c("cns", "comm", "year"), 
    eqCnsLETotInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsGETotInpCY = c("cns", "comm", "year"), 
    eqCnsGETotInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsETotInpCY = c("cns", "comm", "year"), 
    eqCnsETotInpCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsLETotInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsLETotInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsGETotInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsGETotInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsETotInpCYS = c("cns", "comm", "year", "slice"), 
    eqCnsETotInpCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsLETotInpCR = c("cns", "comm", "region"), 
    eqCnsGETotInpCR = c("cns", "comm", "region"), 
    eqCnsETotInpCR = c("cns", "comm", "region"), 
    eqCnsLETotInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsGETotInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsETotInpCRS = c("cns", "comm", "region", "slice"), 
    eqCnsLETotInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsLETotInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsGETotInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsGETotInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsETotInpCRY = c("cns", "comm", "region", "year"), 
    eqCnsETotInpCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsLETotInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETotInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsGETotInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETotInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsETotInpCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETotInpCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsLETotOut = c("cns"), 
    eqCnsGETotOut = c("cns"), 
    eqCnsETotOut = c("cns"), 
    eqCnsLETotOutS = c("cns", "slice"), 
    eqCnsGETotOutS = c("cns", "slice"), 
    eqCnsETotOutS = c("cns", "slice"), 
    eqCnsLETotOutY = c("cns", "year"), 
    eqCnsLETotOutYGrowth = c("cns", "year", "year"), 
    eqCnsGETotOutY = c("cns", "year"), 
    eqCnsGETotOutYGrowth = c("cns", "year", "year"), 
    eqCnsETotOutY = c("cns", "year"), 
    eqCnsETotOutYGrowth = c("cns", "year", "year"), 
    eqCnsLETotOutYS = c("cns", "year", "slice"), 
    eqCnsLETotOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsGETotOutYS = c("cns", "year", "slice"), 
    eqCnsGETotOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsETotOutYS = c("cns", "year", "slice"), 
    eqCnsETotOutYSGrowth = c("cns", "year", "slice", "year"), 
    eqCnsLETotOutR = c("cns", "region"), 
    eqCnsGETotOutR = c("cns", "region"), 
    eqCnsETotOutR = c("cns", "region"), 
    eqCnsLETotOutRS = c("cns", "region", "slice"), 
    eqCnsGETotOutRS = c("cns", "region", "slice"), 
    eqCnsETotOutRS = c("cns", "region", "slice"), 
    eqCnsLETotOutRY = c("cns", "region", "year"), 
    eqCnsLETotOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsGETotOutRY = c("cns", "region", "year"), 
    eqCnsGETotOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsETotOutRY = c("cns", "region", "year"), 
    eqCnsETotOutRYGrowth = c("cns", "region", "year", "year"), 
    eqCnsLETotOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsLETotOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsGETotOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsGETotOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsETotOutRYS = c("cns", "region", "year", "slice"), 
    eqCnsETotOutRYSGrowth = c("cns", "region", "year", "slice", "year"), 
    eqCnsLETotOutC = c("cns", "comm"), 
    eqCnsGETotOutC = c("cns", "comm"), 
    eqCnsETotOutC = c("cns", "comm"), 
    eqCnsLETotOutCS = c("cns", "comm", "slice"), 
    eqCnsGETotOutCS = c("cns", "comm", "slice"), 
    eqCnsETotOutCS = c("cns", "comm", "slice"), 
    eqCnsLETotOutCY = c("cns", "comm", "year"), 
    eqCnsLETotOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsGETotOutCY = c("cns", "comm", "year"), 
    eqCnsGETotOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsETotOutCY = c("cns", "comm", "year"), 
    eqCnsETotOutCYGrowth = c("cns", "comm", "year", "year"), 
    eqCnsLETotOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsLETotOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsGETotOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsGETotOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsETotOutCYS = c("cns", "comm", "year", "slice"), 
    eqCnsETotOutCYSGrowth = c("cns", "comm", "year", "slice", "year"), 
    eqCnsLETotOutCR = c("cns", "comm", "region"), 
    eqCnsGETotOutCR = c("cns", "comm", "region"), 
    eqCnsETotOutCR = c("cns", "comm", "region"), 
    eqCnsLETotOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsGETotOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsETotOutCRS = c("cns", "comm", "region", "slice"), 
    eqCnsLETotOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsLETotOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsGETotOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsGETotOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsETotOutCRY = c("cns", "comm", "region", "year"), 
    eqCnsETotOutCRYGrowth = c("cns", "comm", "region", "year", "year"), 
    eqCnsLETotOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsLETotOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsGETotOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsGETotOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqCnsETotOutCRYS = c("cns", "comm", "region", "year", "slice"), 
    eqCnsETotOutCRYSGrowth = c("cns", "comm", "region", "year", "slice", "year"), 
    eqLECActivity = c("region", "year", "slice"), 
    eqPreDefTechUse = c("tech", "region", "year", "slice"), 
    eqPreDefTechNewCap = c("tech", "region", "year"), 
    eqPreDefTechRetirementCap = c("tech", "region", "year", "year"), 
    eqPreDefTechCap = c("tech", "region", "year"), 
    eqPreDefTechAct = c("tech", "region", "year", "slice"), 
    eqPreDefTechInp = c("tech", "comm", "region", "year", "slice"), 
    eqPreDefTechOut = c("tech", "comm", "region", "year", "slice"), 
    eqPreDefTechAInp = c("tech", "comm", "region", "year", "slice"), 
    eqPreDefTechAOut = c("tech", "comm", "region", "year", "slice"), 
    eqPreDefSupOut = c("sup", "comm", "region", "year", "slice"), 
    eqPreDefDemInp = c("comm", "region", "year", "slice"), 
    eqPreDefDumOut = c("comm", "region", "year", "slice"), 
    eqPreDefStorageInp = c("stg", "comm", "region", "year", "slice"), 
    eqPreDefStorageOut = c("stg", "comm", "region", "year", "slice"), 
    eqPreDefStorageStore = c("stg", "region", "year", "slice"), 
    eqPreDefStorageCap = c("stg", "region", "year"), 
    eqPreDefStorageNewCap = c("stg", "region", "year"), 
    eqPreDefImport = c("comm", "region", "year", "slice"), 
    eqPreDefExport = c("comm", "region", "year", "slice"), 
    eqPreDefTradeIr = c("trade", "region", "region", "year", "slice"), 
    eqPreDefExportRow = c("expp", "region", "year", "slice"), 
    eqPreDefImportRow = c("imp", "region", "year", "slice"))
}
getVariablesMap <- function() {
  list(
    vTechFixom = c("tech", "region", "year"), 
    vTechVarom = c("tech", "region", "year", "slice"), 
    vTechActVarom = c("tech", "region", "year", "slice"), 
    vTechCVarom = c("tech", "region", "year", "slice"), 
    vTechAVarom = c("tech", "region", "year", "slice"), 
    vTechInv = c("tech", "region", "year"), 
    vTechEac = c("tech", "region", "year"), 
    vTechSalv = c("tech", "region"), 
    vTechCost = c("tech", "region", "year"), 
    vSupCost = c("sup", "region", "year"), 
    vEmsFuelTot = c("comm", "region", "year", "slice"), 
    vTechEmsFuel = c("tech", "comm", "region", "year", "slice"), 
    vBalance = c("comm", "region", "year", "slice"), 
    vCost = c("region", "year"), 
    vTaxCost = c("comm", "region", "year"), 
    vSubsCost = c("comm", "region", "year"), 
    vAggOut = c("comm", "region", "year", "slice"), 
    vStorageCost = c("stg", "region", "year"), 
    vTradeCost = c("region", "year"), 
    vTradeRowCost = c("region", "year"), 
    vTradeIrCost = c("region", "year"), 
    vTechUse = c("tech", "region", "year", "slice"), 
    vTechNewCap = c("tech", "region", "year"), 
    vTechRetirementCap = c("tech", "region", "year", "year"), 
    vTechCap = c("tech", "region", "year"), 
    vTechAct = c("tech", "region", "year", "slice"), 
    vTechInp = c("tech", "comm", "region", "year", "slice"), 
    vTechOut = c("tech", "comm", "region", "year", "slice"), 
    vTechAInp = c("tech", "comm", "region", "year", "slice"), 
    vTechAOut = c("tech", "comm", "region", "year", "slice"), 
    vSupOut = c("sup", "comm", "region", "year", "slice"), 
    vSupReserve = c("sup"), 
    vDemInp = c("comm", "region", "year", "slice"), 
    vOutTot = c("comm", "region", "year", "slice"), 
    vInpTot = c("comm", "region", "year", "slice"), 
    vSupOutTot = c("comm", "region", "year", "slice"), 
    vTechInpTot = c("comm", "region", "year", "slice"), 
    vTechOutTot = c("comm", "region", "year", "slice"), 
    vStorageInpTot = c("comm", "region", "year", "slice"), 
    vStorageOutTot = c("comm", "region", "year", "slice"), 
    vDumOut = c("comm", "region", "year", "slice"), 
    vDumCost = c("comm", "region", "year"), 
    vStorageInp = c("stg", "comm", "region", "year", "slice"), 
    vStorageOut = c("stg", "comm", "region", "year", "slice"), 
    vStorageStore = c("stg", "region", "year", "slice"), 
    vStorageVarom = c("stg", "region", "year"), 
    vStorageFixom = c("stg", "region", "year"), 
    vStorageInv = c("stg", "region", "year"), 
    vStorageSalv = c("stg", "region"), 
    vStorageCap = c("stg", "region", "year"), 
    vStorageNewCap = c("stg", "region", "year"), 
    vImport = c("comm", "region", "year", "slice"), 
    vExport = c("comm", "region", "year", "slice"), 
    vTradeIr = c("trade", "region", "region", "year", "slice"), 
    vExportRowRes = c("expp"), 
    vExportRow = c("expp", "region", "year", "slice"), 
    vImportRowRes = c("imp"), 
    vImportRow = c("imp", "region", "year", "slice"))
}
getEquations <- function() {
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
   cns  = logical(),
   vTechFixom  = logical(),
   vTechVarom  = logical(),
   vTechActVarom  = logical(),
   vTechCVarom  = logical(),
   vTechAVarom  = logical(),
   vTechInv  = logical(),
   vTechEac  = logical(),
   vTechSalv  = logical(),
   vTechCost  = logical(),
   vSupCost  = logical(),
   vEmsFuelTot  = logical(),
   vTechEmsFuel  = logical(),
   vBalance  = logical(),
   vCost  = logical(),
   vObjective  = logical(),
   vTaxCost  = logical(),
   vSubsCost  = logical(),
   vAggOut  = logical(),
   vStorageCost  = logical(),
   vTradeCost  = logical(),
   vTradeRowCost  = logical(),
   vTradeIrCost  = logical(),
   vTechUse  = logical(),
   vTechNewCap  = logical(),
   vTechRetirementCap  = logical(),
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
   vSupOutTot  = logical(),
   vTechInpTot  = logical(),
   vTechOutTot  = logical(),
   vStorageInpTot  = logical(),
   vStorageOutTot  = logical(),
   vDumOut  = logical(),
   vDumCost  = logical(),
   vStorageInp  = logical(),
   vStorageOut  = logical(),
   vStorageStore  = logical(),
   vStorageVarom  = logical(),
   vStorageFixom  = logical(),
   vStorageInv  = logical(),
   vStorageSalv  = logical(),
   vStorageCap  = logical(),
   vStorageNewCap  = logical(),
   vImport  = logical(),
   vExport  = logical(),
   vTradeIr  = logical(),
   vExportRowRes  = logical(),
   vExportRow  = logical(),
   vImportRowRes  = logical(),
   vImportRow  = logical(),
      stringsAsFactors = FALSE);
    rs[1:1797,] <- NA;
    rs["eqTechSng2Sng", c("name", "description")] <- c("eqTechSng2Sng", "Input to Output");
    rs["eqTechSng2Sng", c("tech", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechGrp2Sng", c("name", "description")] <- c("eqTechGrp2Sng", "Group input to output");
    rs["eqTechGrp2Sng", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechSng2Grp", c("name", "description")] <- c("eqTechSng2Grp", "Input to group output");
    rs["eqTechSng2Grp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechGrp2Grp", c("name", "description")] <- c("eqTechGrp2Grp", "Group input to group output");
    rs["eqTechGrp2Grp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp", "vTechOut")] <- TRUE;
    rs["eqTechUse2Sng", c("name", "description")] <- c("eqTechUse2Sng", "Use to output");
    rs["eqTechUse2Sng", c("tech", "comm", "region", "year", "slice", "vTechUse", "vTechOut")] <- TRUE;
    rs["eqTechUse2Grp", c("name", "description")] <- c("eqTechUse2Grp", "Use to group output");
    rs["eqTechUse2Grp", c("tech", "group", "comm", "region", "year", "slice", "vTechUse", "vTechOut")] <- TRUE;
    rs["eqTechShareInpLo", c("name", "description")] <- c("eqTechShareInpLo", "Lower bound on input share");
    rs["eqTechShareInpLo", c("tech", "group", "comm", "region", "year", "slice", "vTechInp")] <- TRUE;
    rs["eqTechShareInpUp", c("name", "description")] <- c("eqTechShareInpUp", "Upper bound on input share");
    rs["eqTechShareInpUp", c("tech", "group", "comm", "region", "year", "slice", "vTechInp")] <- TRUE;
    rs["eqTechShareOutLo", c("name", "description")] <- c("eqTechShareOutLo", "Lower bound on output share");
    rs["eqTechShareOutLo", c("tech", "group", "comm", "region", "year", "slice", "vTechOut")] <- TRUE;
    rs["eqTechShareOutUp", c("name", "description")] <- c("eqTechShareOutUp", "Upper bound on output share");
    rs["eqTechShareOutUp", c("tech", "group", "comm", "region", "year", "slice", "vTechOut")] <- TRUE;
    rs["eqTechAInp", c("name", "description")] <- c("eqTechAInp", "");
    rs["eqTechAInp", c("tech", "comm", "region", "year", "slice", "vTechUse", "vTechNewCap", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp")] <- TRUE;
    rs["eqTechAOut", c("name", "description")] <- c("eqTechAOut", "");
    rs["eqTechAOut", c("tech", "comm", "region", "year", "slice", "vTechUse", "vTechNewCap", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqTechAfaLo", c("name", "description")] <- c("eqTechAfaLo", "");
    rs["eqTechAfaLo", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechAfaUp", c("name", "description")] <- c("eqTechAfaUp", "");
    rs["eqTechAfaUp", c("tech", "region", "year", "slice", "vTechCap", "vTechAct")] <- TRUE;
    rs["eqTechActSng", c("name", "description")] <- c("eqTechActSng", "");
    rs["eqTechActSng", c("tech", "comm", "region", "year", "slice", "vTechAct", "vTechOut")] <- TRUE;
    rs["eqTechActGrp", c("name", "description")] <- c("eqTechActGrp", "");
    rs["eqTechActGrp", c("tech", "group", "comm", "region", "year", "slice", "vTechAct", "vTechOut")] <- TRUE;
    rs["eqTechAfacLo", c("name", "description")] <- c("eqTechAfacLo", "");
    rs["eqTechAfacLo", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechOut")] <- TRUE;
    rs["eqTechAfacUp", c("name", "description")] <- c("eqTechAfacUp", "");
    rs["eqTechAfacUp", c("tech", "comm", "region", "year", "slice", "vTechCap", "vTechOut")] <- TRUE;
    rs["eqTechCap", c("name", "description")] <- c("eqTechCap", "");
    rs["eqTechCap", c("tech", "region", "year", "vTechNewCap", "vTechRetirementCap", "vTechCap")] <- TRUE;
    rs["eqTechNewCap", c("name", "description")] <- c("eqTechNewCap", "");
    rs["eqTechNewCap", c("tech", "region", "year", "vTechNewCap", "vTechRetirementCap")] <- TRUE;
    rs["eqTechEac", c("name", "description")] <- c("eqTechEac", "");
    rs["eqTechEac", c("tech", "region", "year", "vTechEac", "vTechNewCap", "vTechRetirementCap")] <- TRUE;
    rs["eqTechInv", c("name", "description")] <- c("eqTechInv", "");
    rs["eqTechInv", c("tech", "region", "year", "vTechInv", "vTechNewCap")] <- TRUE;
    rs["eqTechSalv2", c("name", "description")] <- c("eqTechSalv2", "");
    rs["eqTechSalv2", c("tech", "region", "year", "vTechSalv", "vTechNewCap", "vTechRetirementCap")] <- TRUE;
    rs["eqTechSalv3", c("name", "description")] <- c("eqTechSalv3", "");
    rs["eqTechSalv3", c("tech", "region", "year", "vTechSalv", "vTechNewCap", "vTechRetirementCap")] <- TRUE;
    rs["eqTechCost1", c("name", "description")] <- c("eqTechCost1", "");
    rs["eqTechCost1", c("tech", "comm", "region", "year", "slice", "vTechInv", "vTechCost", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp", "vTechAOut")] <- TRUE;
    rs["eqTechCost2", c("name", "description")] <- c("eqTechCost2", "");
    rs["eqTechCost2", c("tech", "comm", "region", "year", "slice", "vTechCost", "vTechCap", "vTechAct", "vTechInp", "vTechOut", "vTechAInp", "vTechAOut")] <- TRUE;
    rs["eqTechFixom", c("name", "description")] <- c("eqTechFixom", "");
    rs["eqTechFixom", c("tech", "region", "year", "vTechFixom", "vTechCap")] <- TRUE;
    rs["eqTechVarom", c("name", "description")] <- c("eqTechVarom", "");
    rs["eqTechVarom", c("tech", "comm", "region", "year", "slice", "vTechVarom", "vTechAct", "vTechInp", "vTechOut", "vTechAInp", "vTechAOut")] <- TRUE;
    rs["eqTechActVarom", c("name", "description")] <- c("eqTechActVarom", "");
    rs["eqTechActVarom", c("tech", "region", "year", "slice", "vTechActVarom", "vTechAct")] <- TRUE;
    rs["eqTechCVarom", c("name", "description")] <- c("eqTechCVarom", "");
    rs["eqTechCVarom", c("tech", "comm", "region", "year", "slice", "vTechCVarom", "vTechInp")] <- TRUE;
    rs["eqTechAVarom", c("name", "description")] <- c("eqTechAVarom", "");
    rs["eqTechAVarom", c("tech", "comm", "region", "year", "slice", "vTechAVarom", "vTechAInp")] <- TRUE;
    rs["eqSupAvaUp", c("name", "description")] <- c("eqSupAvaUp", "");
    rs["eqSupAvaUp", c("sup", "comm", "region", "year", "slice", "vSupOut")] <- TRUE;
    rs["eqSupAvaLo", c("name", "description")] <- c("eqSupAvaLo", "");
    rs["eqSupAvaLo", c("sup", "comm", "region", "year", "slice", "vSupOut")] <- TRUE;
    rs["eqSupReserve", c("name", "description")] <- c("eqSupReserve", "");
    rs["eqSupReserve", c("sup", "comm", "region", "year", "slice", "vSupOut", "vSupReserve")] <- TRUE;
    rs["eqSupReserveCheck", c("name", "description")] <- c("eqSupReserveCheck", "");
    rs["eqSupReserveCheck", c("sup", "comm", "vSupReserve")] <- TRUE;
    rs["eqSupCost", c("name", "description")] <- c("eqSupCost", "");
    rs["eqSupCost", c("sup", "comm", "region", "year", "slice", "vSupCost", "vSupOut")] <- TRUE;
    rs["eqDemInp", c("name", "description")] <- c("eqDemInp", "");
    rs["eqDemInp", c("comm", "region", "year", "slice", "vDemInp")] <- TRUE;
    rs["eqAggOut", c("name", "description")] <- c("eqAggOut", "");
    rs["eqAggOut", c("comm", "region", "year", "slice", "vAggOut", "vOutTot")] <- TRUE;
    rs["eqEmsFuelTot", c("name", "description")] <- c("eqEmsFuelTot", "");
    rs["eqEmsFuelTot", c("tech", "comm", "region", "year", "slice", "vEmsFuelTot", "vTechEmsFuel")] <- TRUE;
    rs["eqTechEmsFuel", c("name", "description")] <- c("eqTechEmsFuel", "");
    rs["eqTechEmsFuel", c("tech", "comm", "region", "year", "slice", "vTechEmsFuel", "vTechInp")] <- TRUE;
    rs["eqStorageStore", c("name", "description")] <- c("eqStorageStore", "");
    rs["eqStorageStore", c("stg", "comm", "region", "year", "slice", "vStorageInp", "vStorageOut", "vStorageStore")] <- TRUE;
    rs["eqStorageCap", c("name", "description")] <- c("eqStorageCap", "");
    rs["eqStorageCap", c("stg", "region", "year", "vStorageCap", "vStorageNewCap")] <- TRUE;
    rs["eqStorageInv", c("name", "description")] <- c("eqStorageInv", "");
    rs["eqStorageInv", c("stg", "region", "year", "vStorageInv", "vStorageNewCap")] <- TRUE;
    rs["eqStorageFix", c("name", "description")] <- c("eqStorageFix", "");
    rs["eqStorageFix", c("stg", "region", "year", "vStorageFixom", "vStorageCap")] <- TRUE;
    rs["eqStorageSalv2", c("name", "description")] <- c("eqStorageSalv2", "");
    rs["eqStorageSalv2", c("stg", "region", "year", "vStorageInv", "vStorageSalv")] <- TRUE;
    rs["eqStorageSalv3", c("name", "description")] <- c("eqStorageSalv3", "");
    rs["eqStorageSalv3", c("stg", "region", "year", "vStorageInv", "vStorageSalv")] <- TRUE;
    rs["eqStorageVar", c("name", "description")] <- c("eqStorageVar", "");
    rs["eqStorageVar", c("stg", "comm", "region", "year", "slice", "vStorageInp", "vStorageOut", "vStorageStore", "vStorageVarom")] <- TRUE;
    rs["eqStorageCost", c("name", "description")] <- c("eqStorageCost", "");
    rs["eqStorageCost", c("stg", "region", "year", "vStorageCost", "vStorageVarom", "vStorageFixom", "vStorageInv")] <- TRUE;
    rs["eqStorageLo", c("name", "description")] <- c("eqStorageLo", "");
    rs["eqStorageLo", c("stg", "region", "year", "vStorageCap")] <- TRUE;
    rs["eqStorageUp", c("name", "description")] <- c("eqStorageUp", "");
    rs["eqStorageUp", c("stg", "region", "year", "vStorageCap")] <- TRUE;
    rs["eqImport", c("name", "description")] <- c("eqImport", "");
    rs["eqImport", c("imp", "trade", "comm", "region", "year", "slice", "vImport", "vTradeIr", "vImportRow")] <- TRUE;
    rs["eqExport", c("name", "description")] <- c("eqExport", "");
    rs["eqExport", c("expp", "trade", "comm", "region", "year", "slice", "vExport", "vTradeIr", "vExportRow")] <- TRUE;
    rs["eqTradeFlowUp", c("name", "description")] <- c("eqTradeFlowUp", "");
    rs["eqTradeFlowUp", c("trade", "region", "year", "slice", "vTradeIr")] <- TRUE;
    rs["eqTradeFlowLo", c("name", "description")] <- c("eqTradeFlowLo", "");
    rs["eqTradeFlowLo", c("trade", "region", "year", "slice", "vTradeIr")] <- TRUE;
    rs["eqCostTrade", c("name", "description")] <- c("eqCostTrade", "");
    rs["eqCostTrade", c("region", "year", "vTradeCost", "vTradeRowCost", "vTradeIrCost")] <- TRUE;
    rs["eqCostRowTrade", c("name", "description")] <- c("eqCostRowTrade", "");
    rs["eqCostRowTrade", c("expp", "imp", "region", "year", "slice", "vTradeRowCost", "vExportRow", "vImportRow")] <- TRUE;
    rs["eqCostIrTrade", c("name", "description")] <- c("eqCostIrTrade", "");
    rs["eqCostIrTrade", c("trade", "region", "year", "slice", "vTradeIrCost", "vTradeIr")] <- TRUE;
    rs["eqExportRowUp", c("name", "description")] <- c("eqExportRowUp", "");
    rs["eqExportRowUp", c("expp", "region", "year", "slice", "vExportRow")] <- TRUE;
    rs["eqExportRowLo", c("name", "description")] <- c("eqExportRowLo", "");
    rs["eqExportRowLo", c("expp", "region", "year", "slice", "vExportRow")] <- TRUE;
    rs["eqExportRowRes", c("name", "description")] <- c("eqExportRowRes", "");
    rs["eqExportRowRes", c("expp", "region", "year", "slice", "vExportRowRes", "vExportRow")] <- TRUE;
    rs["eqExportRowResUp", c("name", "description")] <- c("eqExportRowResUp", "");
    rs["eqExportRowResUp", c("expp", "vExportRowRes")] <- TRUE;
    rs["eqImportRowUp", c("name", "description")] <- c("eqImportRowUp", "");
    rs["eqImportRowUp", c("imp", "region", "year", "slice", "vImportRow")] <- TRUE;
    rs["eqImportRowLo", c("name", "description")] <- c("eqImportRowLo", "");
    rs["eqImportRowLo", c("imp", "region", "year", "slice", "vImportRow")] <- TRUE;
    rs["eqImportRowRes", c("name", "description")] <- c("eqImportRowRes", "");
    rs["eqImportRowRes", c("imp", "region", "year", "slice", "vImportRowRes", "vImportRow")] <- TRUE;
    rs["eqImportRowResUp", c("name", "description")] <- c("eqImportRowResUp", "");
    rs["eqImportRowResUp", c("imp", "vImportRowRes")] <- TRUE;
    rs["eqBalUp", c("name", "description")] <- c("eqBalUp", "");
    rs["eqBalUp", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBalLo", c("name", "description")] <- c("eqBalLo", "");
    rs["eqBalLo", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBalFx", c("name", "description")] <- c("eqBalFx", "");
    rs["eqBalFx", c("comm", "region", "year", "slice", "vBalance")] <- TRUE;
    rs["eqBal", c("name", "description")] <- c("eqBal", "");
    rs["eqBal", c("comm", "region", "year", "slice", "vBalance", "vOutTot", "vInpTot")] <- TRUE;
    rs["eqOutTot", c("name", "description")] <- c("eqOutTot", "");
    rs["eqOutTot", c("comm", "region", "year", "slice", "vEmsFuelTot", "vAggOut", "vOutTot", "vSupOutTot", "vTechOutTot", "vStorageOutTot", "vDumOut", "vImport")] <- TRUE;
    rs["eqInpTot", c("name", "description")] <- c("eqInpTot", "");
    rs["eqInpTot", c("comm", "region", "year", "slice", "vDemInp", "vInpTot", "vTechInpTot", "vStorageInpTot", "vExport")] <- TRUE;
    rs["eqSupOutTot", c("name", "description")] <- c("eqSupOutTot", "");
    rs["eqSupOutTot", c("sup", "comm", "region", "year", "slice", "vSupOut", "vSupOutTot")] <- TRUE;
    rs["eqTechInpTot", c("name", "description")] <- c("eqTechInpTot", "");
    rs["eqTechInpTot", c("tech", "comm", "region", "year", "slice", "vTechInp", "vTechAInp", "vTechInpTot")] <- TRUE;
    rs["eqTechOutTot", c("name", "description")] <- c("eqTechOutTot", "");
    rs["eqTechOutTot", c("tech", "comm", "region", "year", "slice", "vTechOut", "vTechAOut", "vTechOutTot")] <- TRUE;
    rs["eqStorageInpTot", c("name", "description")] <- c("eqStorageInpTot", "");
    rs["eqStorageInpTot", c("stg", "comm", "region", "year", "slice", "vStorageInpTot", "vStorageInp")] <- TRUE;
    rs["eqStorageOutTot", c("name", "description")] <- c("eqStorageOutTot", "");
    rs["eqStorageOutTot", c("stg", "comm", "region", "year", "slice", "vStorageOutTot", "vStorageOut")] <- TRUE;
    rs["eqDumCost", c("name", "description")] <- c("eqDumCost", "");
    rs["eqDumCost", c("comm", "region", "year", "slice", "vDumOut", "vDumCost")] <- TRUE;
    rs["eqCost1", c("name", "description")] <- c("eqCost1", "");
    rs["eqCost1", c("tech", "sup", "stg", "comm", "region", "year", "vTechCost", "vSupCost", "vCost", "vTaxCost", "vSubsCost", "vStorageCost", "vTradeCost", "vDumCost")] <- TRUE;
    rs["eqCost2", c("name", "description")] <- c("eqCost2", "");
    rs["eqCost2", c("tech", "sup", "stg", "comm", "region", "year", "vTechSalv", "vTechCost", "vSupCost", "vCost", "vTaxCost", "vSubsCost", "vStorageCost", "vTradeCost", "vDumCost", "vStorageSalv")] <- TRUE;
    rs["eqObjective", c("name", "description")] <- c("eqObjective", "");
    rs["eqObjective", c("region", "year", "vCost", "vObjective")] <- TRUE;
    rs["eqTaxCost", c("name", "description")] <- c("eqTaxCost", "");
    rs["eqTaxCost", c("comm", "region", "year", "slice", "vTaxCost", "vOutTot")] <- TRUE;
    rs["eqSubsCost", c("name", "description")] <- c("eqSubsCost", "");
    rs["eqSubsCost", c("comm", "region", "year", "slice", "vSubsCost", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpShareIn", c("name", "description")] <- c("eqCnsLETechInpShareIn", "");
    rs["eqCnsLETechInpShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpShareOut", c("name", "description")] <- c("eqCnsLETechInpShareOut", "");
    rs["eqCnsLETechInpShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInp", c("name", "description")] <- c("eqCnsLETechInp", "");
    rs["eqCnsLETechInp", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpShareIn", c("name", "description")] <- c("eqCnsGETechInpShareIn", "");
    rs["eqCnsGETechInpShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpShareOut", c("name", "description")] <- c("eqCnsGETechInpShareOut", "");
    rs["eqCnsGETechInpShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInp", c("name", "description")] <- c("eqCnsGETechInp", "");
    rs["eqCnsGETechInp", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpShareIn", c("name", "description")] <- c("eqCnsETechInpShareIn", "");
    rs["eqCnsETechInpShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpShareOut", c("name", "description")] <- c("eqCnsETechInpShareOut", "");
    rs["eqCnsETechInpShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInp", c("name", "description")] <- c("eqCnsETechInp", "");
    rs["eqCnsETechInp", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpSShareIn", c("name", "description")] <- c("eqCnsLETechInpSShareIn", "");
    rs["eqCnsLETechInpSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpSShareOut", c("name", "description")] <- c("eqCnsLETechInpSShareOut", "");
    rs["eqCnsLETechInpSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpS", c("name", "description")] <- c("eqCnsLETechInpS", "");
    rs["eqCnsLETechInpS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpSShareIn", c("name", "description")] <- c("eqCnsGETechInpSShareIn", "");
    rs["eqCnsGETechInpSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpSShareOut", c("name", "description")] <- c("eqCnsGETechInpSShareOut", "");
    rs["eqCnsGETechInpSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpS", c("name", "description")] <- c("eqCnsGETechInpS", "");
    rs["eqCnsGETechInpS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpSShareIn", c("name", "description")] <- c("eqCnsETechInpSShareIn", "");
    rs["eqCnsETechInpSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpSShareOut", c("name", "description")] <- c("eqCnsETechInpSShareOut", "");
    rs["eqCnsETechInpSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpS", c("name", "description")] <- c("eqCnsETechInpS", "");
    rs["eqCnsETechInpS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpYShareIn", c("name", "description")] <- c("eqCnsLETechInpYShareIn", "");
    rs["eqCnsLETechInpYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpYShareOut", c("name", "description")] <- c("eqCnsLETechInpYShareOut", "");
    rs["eqCnsLETechInpYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpY", c("name", "description")] <- c("eqCnsLETechInpY", "");
    rs["eqCnsLETechInpY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpYGrowth", c("name", "description")] <- c("eqCnsLETechInpYGrowth", "");
    rs["eqCnsLETechInpYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpYShareIn", c("name", "description")] <- c("eqCnsGETechInpYShareIn", "");
    rs["eqCnsGETechInpYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpYShareOut", c("name", "description")] <- c("eqCnsGETechInpYShareOut", "");
    rs["eqCnsGETechInpYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpY", c("name", "description")] <- c("eqCnsGETechInpY", "");
    rs["eqCnsGETechInpY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpYGrowth", c("name", "description")] <- c("eqCnsGETechInpYGrowth", "");
    rs["eqCnsGETechInpYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpYShareIn", c("name", "description")] <- c("eqCnsETechInpYShareIn", "");
    rs["eqCnsETechInpYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpYShareOut", c("name", "description")] <- c("eqCnsETechInpYShareOut", "");
    rs["eqCnsETechInpYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpY", c("name", "description")] <- c("eqCnsETechInpY", "");
    rs["eqCnsETechInpY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpYGrowth", c("name", "description")] <- c("eqCnsETechInpYGrowth", "");
    rs["eqCnsETechInpYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpYSShareIn", c("name", "description")] <- c("eqCnsLETechInpYSShareIn", "");
    rs["eqCnsLETechInpYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpYSShareOut", c("name", "description")] <- c("eqCnsLETechInpYSShareOut", "");
    rs["eqCnsLETechInpYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpYS", c("name", "description")] <- c("eqCnsLETechInpYS", "");
    rs["eqCnsLETechInpYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpYSGrowth", c("name", "description")] <- c("eqCnsLETechInpYSGrowth", "");
    rs["eqCnsLETechInpYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpYSShareIn", c("name", "description")] <- c("eqCnsGETechInpYSShareIn", "");
    rs["eqCnsGETechInpYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpYSShareOut", c("name", "description")] <- c("eqCnsGETechInpYSShareOut", "");
    rs["eqCnsGETechInpYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpYS", c("name", "description")] <- c("eqCnsGETechInpYS", "");
    rs["eqCnsGETechInpYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpYSGrowth", c("name", "description")] <- c("eqCnsGETechInpYSGrowth", "");
    rs["eqCnsGETechInpYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpYSShareIn", c("name", "description")] <- c("eqCnsETechInpYSShareIn", "");
    rs["eqCnsETechInpYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpYSShareOut", c("name", "description")] <- c("eqCnsETechInpYSShareOut", "");
    rs["eqCnsETechInpYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpYS", c("name", "description")] <- c("eqCnsETechInpYS", "");
    rs["eqCnsETechInpYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpYSGrowth", c("name", "description")] <- c("eqCnsETechInpYSGrowth", "");
    rs["eqCnsETechInpYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRShareIn", c("name", "description")] <- c("eqCnsLETechInpRShareIn", "");
    rs["eqCnsLETechInpRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpRShareOut", c("name", "description")] <- c("eqCnsLETechInpRShareOut", "");
    rs["eqCnsLETechInpRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpR", c("name", "description")] <- c("eqCnsLETechInpR", "");
    rs["eqCnsLETechInpR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRShareIn", c("name", "description")] <- c("eqCnsGETechInpRShareIn", "");
    rs["eqCnsGETechInpRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpRShareOut", c("name", "description")] <- c("eqCnsGETechInpRShareOut", "");
    rs["eqCnsGETechInpRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpR", c("name", "description")] <- c("eqCnsGETechInpR", "");
    rs["eqCnsGETechInpR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRShareIn", c("name", "description")] <- c("eqCnsETechInpRShareIn", "");
    rs["eqCnsETechInpRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpRShareOut", c("name", "description")] <- c("eqCnsETechInpRShareOut", "");
    rs["eqCnsETechInpRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpR", c("name", "description")] <- c("eqCnsETechInpR", "");
    rs["eqCnsETechInpR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRSShareIn", c("name", "description")] <- c("eqCnsLETechInpRSShareIn", "");
    rs["eqCnsLETechInpRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpRSShareOut", c("name", "description")] <- c("eqCnsLETechInpRSShareOut", "");
    rs["eqCnsLETechInpRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpRS", c("name", "description")] <- c("eqCnsLETechInpRS", "");
    rs["eqCnsLETechInpRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRSShareIn", c("name", "description")] <- c("eqCnsGETechInpRSShareIn", "");
    rs["eqCnsGETechInpRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpRSShareOut", c("name", "description")] <- c("eqCnsGETechInpRSShareOut", "");
    rs["eqCnsGETechInpRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpRS", c("name", "description")] <- c("eqCnsGETechInpRS", "");
    rs["eqCnsGETechInpRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRSShareIn", c("name", "description")] <- c("eqCnsETechInpRSShareIn", "");
    rs["eqCnsETechInpRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpRSShareOut", c("name", "description")] <- c("eqCnsETechInpRSShareOut", "");
    rs["eqCnsETechInpRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpRS", c("name", "description")] <- c("eqCnsETechInpRS", "");
    rs["eqCnsETechInpRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRYShareIn", c("name", "description")] <- c("eqCnsLETechInpRYShareIn", "");
    rs["eqCnsLETechInpRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpRYShareOut", c("name", "description")] <- c("eqCnsLETechInpRYShareOut", "");
    rs["eqCnsLETechInpRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpRY", c("name", "description")] <- c("eqCnsLETechInpRY", "");
    rs["eqCnsLETechInpRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRYGrowth", c("name", "description")] <- c("eqCnsLETechInpRYGrowth", "");
    rs["eqCnsLETechInpRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRYShareIn", c("name", "description")] <- c("eqCnsGETechInpRYShareIn", "");
    rs["eqCnsGETechInpRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpRYShareOut", c("name", "description")] <- c("eqCnsGETechInpRYShareOut", "");
    rs["eqCnsGETechInpRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpRY", c("name", "description")] <- c("eqCnsGETechInpRY", "");
    rs["eqCnsGETechInpRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRYGrowth", c("name", "description")] <- c("eqCnsGETechInpRYGrowth", "");
    rs["eqCnsGETechInpRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRYShareIn", c("name", "description")] <- c("eqCnsETechInpRYShareIn", "");
    rs["eqCnsETechInpRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpRYShareOut", c("name", "description")] <- c("eqCnsETechInpRYShareOut", "");
    rs["eqCnsETechInpRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpRY", c("name", "description")] <- c("eqCnsETechInpRY", "");
    rs["eqCnsETechInpRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRYGrowth", c("name", "description")] <- c("eqCnsETechInpRYGrowth", "");
    rs["eqCnsETechInpRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRYSShareIn", c("name", "description")] <- c("eqCnsLETechInpRYSShareIn", "");
    rs["eqCnsLETechInpRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpRYSShareOut", c("name", "description")] <- c("eqCnsLETechInpRYSShareOut", "");
    rs["eqCnsLETechInpRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpRYS", c("name", "description")] <- c("eqCnsLETechInpRYS", "");
    rs["eqCnsLETechInpRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpRYSGrowth", c("name", "description")] <- c("eqCnsLETechInpRYSGrowth", "");
    rs["eqCnsLETechInpRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRYSShareIn", c("name", "description")] <- c("eqCnsGETechInpRYSShareIn", "");
    rs["eqCnsGETechInpRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpRYSShareOut", c("name", "description")] <- c("eqCnsGETechInpRYSShareOut", "");
    rs["eqCnsGETechInpRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpRYS", c("name", "description")] <- c("eqCnsGETechInpRYS", "");
    rs["eqCnsGETechInpRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpRYSGrowth", c("name", "description")] <- c("eqCnsGETechInpRYSGrowth", "");
    rs["eqCnsGETechInpRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRYSShareIn", c("name", "description")] <- c("eqCnsETechInpRYSShareIn", "");
    rs["eqCnsETechInpRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpRYSShareOut", c("name", "description")] <- c("eqCnsETechInpRYSShareOut", "");
    rs["eqCnsETechInpRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpRYS", c("name", "description")] <- c("eqCnsETechInpRYS", "");
    rs["eqCnsETechInpRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpRYSGrowth", c("name", "description")] <- c("eqCnsETechInpRYSGrowth", "");
    rs["eqCnsETechInpRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCShareIn", c("name", "description")] <- c("eqCnsLETechInpCShareIn", "");
    rs["eqCnsLETechInpCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCShareOut", c("name", "description")] <- c("eqCnsLETechInpCShareOut", "");
    rs["eqCnsLETechInpCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpC", c("name", "description")] <- c("eqCnsLETechInpC", "");
    rs["eqCnsLETechInpC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCShareIn", c("name", "description")] <- c("eqCnsGETechInpCShareIn", "");
    rs["eqCnsGETechInpCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCShareOut", c("name", "description")] <- c("eqCnsGETechInpCShareOut", "");
    rs["eqCnsGETechInpCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpC", c("name", "description")] <- c("eqCnsGETechInpC", "");
    rs["eqCnsGETechInpC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCShareIn", c("name", "description")] <- c("eqCnsETechInpCShareIn", "");
    rs["eqCnsETechInpCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCShareOut", c("name", "description")] <- c("eqCnsETechInpCShareOut", "");
    rs["eqCnsETechInpCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpC", c("name", "description")] <- c("eqCnsETechInpC", "");
    rs["eqCnsETechInpC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCSShareIn", c("name", "description")] <- c("eqCnsLETechInpCSShareIn", "");
    rs["eqCnsLETechInpCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCSShareOut", c("name", "description")] <- c("eqCnsLETechInpCSShareOut", "");
    rs["eqCnsLETechInpCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCS", c("name", "description")] <- c("eqCnsLETechInpCS", "");
    rs["eqCnsLETechInpCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCSShareIn", c("name", "description")] <- c("eqCnsGETechInpCSShareIn", "");
    rs["eqCnsGETechInpCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCSShareOut", c("name", "description")] <- c("eqCnsGETechInpCSShareOut", "");
    rs["eqCnsGETechInpCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCS", c("name", "description")] <- c("eqCnsGETechInpCS", "");
    rs["eqCnsGETechInpCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCSShareIn", c("name", "description")] <- c("eqCnsETechInpCSShareIn", "");
    rs["eqCnsETechInpCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCSShareOut", c("name", "description")] <- c("eqCnsETechInpCSShareOut", "");
    rs["eqCnsETechInpCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCS", c("name", "description")] <- c("eqCnsETechInpCS", "");
    rs["eqCnsETechInpCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCYShareIn", c("name", "description")] <- c("eqCnsLETechInpCYShareIn", "");
    rs["eqCnsLETechInpCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCYShareOut", c("name", "description")] <- c("eqCnsLETechInpCYShareOut", "");
    rs["eqCnsLETechInpCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCY", c("name", "description")] <- c("eqCnsLETechInpCY", "");
    rs["eqCnsLETechInpCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCYGrowth", c("name", "description")] <- c("eqCnsLETechInpCYGrowth", "");
    rs["eqCnsLETechInpCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCYShareIn", c("name", "description")] <- c("eqCnsGETechInpCYShareIn", "");
    rs["eqCnsGETechInpCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCYShareOut", c("name", "description")] <- c("eqCnsGETechInpCYShareOut", "");
    rs["eqCnsGETechInpCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCY", c("name", "description")] <- c("eqCnsGETechInpCY", "");
    rs["eqCnsGETechInpCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCYGrowth", c("name", "description")] <- c("eqCnsGETechInpCYGrowth", "");
    rs["eqCnsGETechInpCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCYShareIn", c("name", "description")] <- c("eqCnsETechInpCYShareIn", "");
    rs["eqCnsETechInpCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCYShareOut", c("name", "description")] <- c("eqCnsETechInpCYShareOut", "");
    rs["eqCnsETechInpCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCY", c("name", "description")] <- c("eqCnsETechInpCY", "");
    rs["eqCnsETechInpCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCYGrowth", c("name", "description")] <- c("eqCnsETechInpCYGrowth", "");
    rs["eqCnsETechInpCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCYSShareIn", c("name", "description")] <- c("eqCnsLETechInpCYSShareIn", "");
    rs["eqCnsLETechInpCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCYSShareOut", c("name", "description")] <- c("eqCnsLETechInpCYSShareOut", "");
    rs["eqCnsLETechInpCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCYS", c("name", "description")] <- c("eqCnsLETechInpCYS", "");
    rs["eqCnsLETechInpCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCYSGrowth", c("name", "description")] <- c("eqCnsLETechInpCYSGrowth", "");
    rs["eqCnsLETechInpCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCYSShareIn", c("name", "description")] <- c("eqCnsGETechInpCYSShareIn", "");
    rs["eqCnsGETechInpCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCYSShareOut", c("name", "description")] <- c("eqCnsGETechInpCYSShareOut", "");
    rs["eqCnsGETechInpCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCYS", c("name", "description")] <- c("eqCnsGETechInpCYS", "");
    rs["eqCnsGETechInpCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCYSGrowth", c("name", "description")] <- c("eqCnsGETechInpCYSGrowth", "");
    rs["eqCnsGETechInpCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCYSShareIn", c("name", "description")] <- c("eqCnsETechInpCYSShareIn", "");
    rs["eqCnsETechInpCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCYSShareOut", c("name", "description")] <- c("eqCnsETechInpCYSShareOut", "");
    rs["eqCnsETechInpCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCYS", c("name", "description")] <- c("eqCnsETechInpCYS", "");
    rs["eqCnsETechInpCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCYSGrowth", c("name", "description")] <- c("eqCnsETechInpCYSGrowth", "");
    rs["eqCnsETechInpCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRShareIn", c("name", "description")] <- c("eqCnsLETechInpCRShareIn", "");
    rs["eqCnsLETechInpCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCRShareOut", c("name", "description")] <- c("eqCnsLETechInpCRShareOut", "");
    rs["eqCnsLETechInpCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCR", c("name", "description")] <- c("eqCnsLETechInpCR", "");
    rs["eqCnsLETechInpCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRShareIn", c("name", "description")] <- c("eqCnsGETechInpCRShareIn", "");
    rs["eqCnsGETechInpCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCRShareOut", c("name", "description")] <- c("eqCnsGETechInpCRShareOut", "");
    rs["eqCnsGETechInpCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCR", c("name", "description")] <- c("eqCnsGETechInpCR", "");
    rs["eqCnsGETechInpCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRShareIn", c("name", "description")] <- c("eqCnsETechInpCRShareIn", "");
    rs["eqCnsETechInpCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCRShareOut", c("name", "description")] <- c("eqCnsETechInpCRShareOut", "");
    rs["eqCnsETechInpCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCR", c("name", "description")] <- c("eqCnsETechInpCR", "");
    rs["eqCnsETechInpCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRSShareIn", c("name", "description")] <- c("eqCnsLETechInpCRSShareIn", "");
    rs["eqCnsLETechInpCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCRSShareOut", c("name", "description")] <- c("eqCnsLETechInpCRSShareOut", "");
    rs["eqCnsLETechInpCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCRS", c("name", "description")] <- c("eqCnsLETechInpCRS", "");
    rs["eqCnsLETechInpCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRSShareIn", c("name", "description")] <- c("eqCnsGETechInpCRSShareIn", "");
    rs["eqCnsGETechInpCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCRSShareOut", c("name", "description")] <- c("eqCnsGETechInpCRSShareOut", "");
    rs["eqCnsGETechInpCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCRS", c("name", "description")] <- c("eqCnsGETechInpCRS", "");
    rs["eqCnsGETechInpCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRSShareIn", c("name", "description")] <- c("eqCnsETechInpCRSShareIn", "");
    rs["eqCnsETechInpCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCRSShareOut", c("name", "description")] <- c("eqCnsETechInpCRSShareOut", "");
    rs["eqCnsETechInpCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCRS", c("name", "description")] <- c("eqCnsETechInpCRS", "");
    rs["eqCnsETechInpCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRYShareIn", c("name", "description")] <- c("eqCnsLETechInpCRYShareIn", "");
    rs["eqCnsLETechInpCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCRYShareOut", c("name", "description")] <- c("eqCnsLETechInpCRYShareOut", "");
    rs["eqCnsLETechInpCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCRY", c("name", "description")] <- c("eqCnsLETechInpCRY", "");
    rs["eqCnsLETechInpCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRYGrowth", c("name", "description")] <- c("eqCnsLETechInpCRYGrowth", "");
    rs["eqCnsLETechInpCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRYShareIn", c("name", "description")] <- c("eqCnsGETechInpCRYShareIn", "");
    rs["eqCnsGETechInpCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCRYShareOut", c("name", "description")] <- c("eqCnsGETechInpCRYShareOut", "");
    rs["eqCnsGETechInpCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCRY", c("name", "description")] <- c("eqCnsGETechInpCRY", "");
    rs["eqCnsGETechInpCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRYGrowth", c("name", "description")] <- c("eqCnsGETechInpCRYGrowth", "");
    rs["eqCnsGETechInpCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRYShareIn", c("name", "description")] <- c("eqCnsETechInpCRYShareIn", "");
    rs["eqCnsETechInpCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCRYShareOut", c("name", "description")] <- c("eqCnsETechInpCRYShareOut", "");
    rs["eqCnsETechInpCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCRY", c("name", "description")] <- c("eqCnsETechInpCRY", "");
    rs["eqCnsETechInpCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRYGrowth", c("name", "description")] <- c("eqCnsETechInpCRYGrowth", "");
    rs["eqCnsETechInpCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRYSShareIn", c("name", "description")] <- c("eqCnsLETechInpCRYSShareIn", "");
    rs["eqCnsLETechInpCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpCRYSShareOut", c("name", "description")] <- c("eqCnsLETechInpCRYSShareOut", "");
    rs["eqCnsLETechInpCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpCRYS", c("name", "description")] <- c("eqCnsLETechInpCRYS", "");
    rs["eqCnsLETechInpCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpCRYSGrowth", c("name", "description")] <- c("eqCnsLETechInpCRYSGrowth", "");
    rs["eqCnsLETechInpCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRYSShareIn", c("name", "description")] <- c("eqCnsGETechInpCRYSShareIn", "");
    rs["eqCnsGETechInpCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpCRYSShareOut", c("name", "description")] <- c("eqCnsGETechInpCRYSShareOut", "");
    rs["eqCnsGETechInpCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpCRYS", c("name", "description")] <- c("eqCnsGETechInpCRYS", "");
    rs["eqCnsGETechInpCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpCRYSGrowth", c("name", "description")] <- c("eqCnsGETechInpCRYSGrowth", "");
    rs["eqCnsGETechInpCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRYSShareIn", c("name", "description")] <- c("eqCnsETechInpCRYSShareIn", "");
    rs["eqCnsETechInpCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpCRYSShareOut", c("name", "description")] <- c("eqCnsETechInpCRYSShareOut", "");
    rs["eqCnsETechInpCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpCRYS", c("name", "description")] <- c("eqCnsETechInpCRYS", "");
    rs["eqCnsETechInpCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpCRYSGrowth", c("name", "description")] <- c("eqCnsETechInpCRYSGrowth", "");
    rs["eqCnsETechInpCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechOutShareIn", c("name", "description")] <- c("eqCnsLETechOutShareIn", "");
    rs["eqCnsLETechOutShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutShareOut", c("name", "description")] <- c("eqCnsLETechOutShareOut", "");
    rs["eqCnsLETechOutShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOut", c("name", "description")] <- c("eqCnsLETechOut", "");
    rs["eqCnsLETechOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutShareIn", c("name", "description")] <- c("eqCnsGETechOutShareIn", "");
    rs["eqCnsGETechOutShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutShareOut", c("name", "description")] <- c("eqCnsGETechOutShareOut", "");
    rs["eqCnsGETechOutShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOut", c("name", "description")] <- c("eqCnsGETechOut", "");
    rs["eqCnsGETechOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutShareIn", c("name", "description")] <- c("eqCnsETechOutShareIn", "");
    rs["eqCnsETechOutShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutShareOut", c("name", "description")] <- c("eqCnsETechOutShareOut", "");
    rs["eqCnsETechOutShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOut", c("name", "description")] <- c("eqCnsETechOut", "");
    rs["eqCnsETechOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutSShareIn", c("name", "description")] <- c("eqCnsLETechOutSShareIn", "");
    rs["eqCnsLETechOutSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutSShareOut", c("name", "description")] <- c("eqCnsLETechOutSShareOut", "");
    rs["eqCnsLETechOutSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutS", c("name", "description")] <- c("eqCnsLETechOutS", "");
    rs["eqCnsLETechOutS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutSShareIn", c("name", "description")] <- c("eqCnsGETechOutSShareIn", "");
    rs["eqCnsGETechOutSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutSShareOut", c("name", "description")] <- c("eqCnsGETechOutSShareOut", "");
    rs["eqCnsGETechOutSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutS", c("name", "description")] <- c("eqCnsGETechOutS", "");
    rs["eqCnsGETechOutS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutSShareIn", c("name", "description")] <- c("eqCnsETechOutSShareIn", "");
    rs["eqCnsETechOutSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutSShareOut", c("name", "description")] <- c("eqCnsETechOutSShareOut", "");
    rs["eqCnsETechOutSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutS", c("name", "description")] <- c("eqCnsETechOutS", "");
    rs["eqCnsETechOutS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutYShareIn", c("name", "description")] <- c("eqCnsLETechOutYShareIn", "");
    rs["eqCnsLETechOutYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutYShareOut", c("name", "description")] <- c("eqCnsLETechOutYShareOut", "");
    rs["eqCnsLETechOutYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutY", c("name", "description")] <- c("eqCnsLETechOutY", "");
    rs["eqCnsLETechOutY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutYGrowth", c("name", "description")] <- c("eqCnsLETechOutYGrowth", "");
    rs["eqCnsLETechOutYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutYShareIn", c("name", "description")] <- c("eqCnsGETechOutYShareIn", "");
    rs["eqCnsGETechOutYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutYShareOut", c("name", "description")] <- c("eqCnsGETechOutYShareOut", "");
    rs["eqCnsGETechOutYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutY", c("name", "description")] <- c("eqCnsGETechOutY", "");
    rs["eqCnsGETechOutY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutYGrowth", c("name", "description")] <- c("eqCnsGETechOutYGrowth", "");
    rs["eqCnsGETechOutYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutYShareIn", c("name", "description")] <- c("eqCnsETechOutYShareIn", "");
    rs["eqCnsETechOutYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutYShareOut", c("name", "description")] <- c("eqCnsETechOutYShareOut", "");
    rs["eqCnsETechOutYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutY", c("name", "description")] <- c("eqCnsETechOutY", "");
    rs["eqCnsETechOutY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutYGrowth", c("name", "description")] <- c("eqCnsETechOutYGrowth", "");
    rs["eqCnsETechOutYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutYSShareIn", c("name", "description")] <- c("eqCnsLETechOutYSShareIn", "");
    rs["eqCnsLETechOutYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutYSShareOut", c("name", "description")] <- c("eqCnsLETechOutYSShareOut", "");
    rs["eqCnsLETechOutYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutYS", c("name", "description")] <- c("eqCnsLETechOutYS", "");
    rs["eqCnsLETechOutYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutYSGrowth", c("name", "description")] <- c("eqCnsLETechOutYSGrowth", "");
    rs["eqCnsLETechOutYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutYSShareIn", c("name", "description")] <- c("eqCnsGETechOutYSShareIn", "");
    rs["eqCnsGETechOutYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutYSShareOut", c("name", "description")] <- c("eqCnsGETechOutYSShareOut", "");
    rs["eqCnsGETechOutYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutYS", c("name", "description")] <- c("eqCnsGETechOutYS", "");
    rs["eqCnsGETechOutYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutYSGrowth", c("name", "description")] <- c("eqCnsGETechOutYSGrowth", "");
    rs["eqCnsGETechOutYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutYSShareIn", c("name", "description")] <- c("eqCnsETechOutYSShareIn", "");
    rs["eqCnsETechOutYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutYSShareOut", c("name", "description")] <- c("eqCnsETechOutYSShareOut", "");
    rs["eqCnsETechOutYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutYS", c("name", "description")] <- c("eqCnsETechOutYS", "");
    rs["eqCnsETechOutYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutYSGrowth", c("name", "description")] <- c("eqCnsETechOutYSGrowth", "");
    rs["eqCnsETechOutYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRShareIn", c("name", "description")] <- c("eqCnsLETechOutRShareIn", "");
    rs["eqCnsLETechOutRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutRShareOut", c("name", "description")] <- c("eqCnsLETechOutRShareOut", "");
    rs["eqCnsLETechOutRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutR", c("name", "description")] <- c("eqCnsLETechOutR", "");
    rs["eqCnsLETechOutR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRShareIn", c("name", "description")] <- c("eqCnsGETechOutRShareIn", "");
    rs["eqCnsGETechOutRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutRShareOut", c("name", "description")] <- c("eqCnsGETechOutRShareOut", "");
    rs["eqCnsGETechOutRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutR", c("name", "description")] <- c("eqCnsGETechOutR", "");
    rs["eqCnsGETechOutR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRShareIn", c("name", "description")] <- c("eqCnsETechOutRShareIn", "");
    rs["eqCnsETechOutRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutRShareOut", c("name", "description")] <- c("eqCnsETechOutRShareOut", "");
    rs["eqCnsETechOutRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutR", c("name", "description")] <- c("eqCnsETechOutR", "");
    rs["eqCnsETechOutR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRSShareIn", c("name", "description")] <- c("eqCnsLETechOutRSShareIn", "");
    rs["eqCnsLETechOutRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutRSShareOut", c("name", "description")] <- c("eqCnsLETechOutRSShareOut", "");
    rs["eqCnsLETechOutRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutRS", c("name", "description")] <- c("eqCnsLETechOutRS", "");
    rs["eqCnsLETechOutRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRSShareIn", c("name", "description")] <- c("eqCnsGETechOutRSShareIn", "");
    rs["eqCnsGETechOutRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutRSShareOut", c("name", "description")] <- c("eqCnsGETechOutRSShareOut", "");
    rs["eqCnsGETechOutRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutRS", c("name", "description")] <- c("eqCnsGETechOutRS", "");
    rs["eqCnsGETechOutRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRSShareIn", c("name", "description")] <- c("eqCnsETechOutRSShareIn", "");
    rs["eqCnsETechOutRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutRSShareOut", c("name", "description")] <- c("eqCnsETechOutRSShareOut", "");
    rs["eqCnsETechOutRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutRS", c("name", "description")] <- c("eqCnsETechOutRS", "");
    rs["eqCnsETechOutRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRYShareIn", c("name", "description")] <- c("eqCnsLETechOutRYShareIn", "");
    rs["eqCnsLETechOutRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutRYShareOut", c("name", "description")] <- c("eqCnsLETechOutRYShareOut", "");
    rs["eqCnsLETechOutRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutRY", c("name", "description")] <- c("eqCnsLETechOutRY", "");
    rs["eqCnsLETechOutRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRYGrowth", c("name", "description")] <- c("eqCnsLETechOutRYGrowth", "");
    rs["eqCnsLETechOutRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRYShareIn", c("name", "description")] <- c("eqCnsGETechOutRYShareIn", "");
    rs["eqCnsGETechOutRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutRYShareOut", c("name", "description")] <- c("eqCnsGETechOutRYShareOut", "");
    rs["eqCnsGETechOutRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutRY", c("name", "description")] <- c("eqCnsGETechOutRY", "");
    rs["eqCnsGETechOutRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRYGrowth", c("name", "description")] <- c("eqCnsGETechOutRYGrowth", "");
    rs["eqCnsGETechOutRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRYShareIn", c("name", "description")] <- c("eqCnsETechOutRYShareIn", "");
    rs["eqCnsETechOutRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutRYShareOut", c("name", "description")] <- c("eqCnsETechOutRYShareOut", "");
    rs["eqCnsETechOutRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutRY", c("name", "description")] <- c("eqCnsETechOutRY", "");
    rs["eqCnsETechOutRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRYGrowth", c("name", "description")] <- c("eqCnsETechOutRYGrowth", "");
    rs["eqCnsETechOutRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRYSShareIn", c("name", "description")] <- c("eqCnsLETechOutRYSShareIn", "");
    rs["eqCnsLETechOutRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutRYSShareOut", c("name", "description")] <- c("eqCnsLETechOutRYSShareOut", "");
    rs["eqCnsLETechOutRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutRYS", c("name", "description")] <- c("eqCnsLETechOutRYS", "");
    rs["eqCnsLETechOutRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutRYSGrowth", c("name", "description")] <- c("eqCnsLETechOutRYSGrowth", "");
    rs["eqCnsLETechOutRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRYSShareIn", c("name", "description")] <- c("eqCnsGETechOutRYSShareIn", "");
    rs["eqCnsGETechOutRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutRYSShareOut", c("name", "description")] <- c("eqCnsGETechOutRYSShareOut", "");
    rs["eqCnsGETechOutRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutRYS", c("name", "description")] <- c("eqCnsGETechOutRYS", "");
    rs["eqCnsGETechOutRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutRYSGrowth", c("name", "description")] <- c("eqCnsGETechOutRYSGrowth", "");
    rs["eqCnsGETechOutRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRYSShareIn", c("name", "description")] <- c("eqCnsETechOutRYSShareIn", "");
    rs["eqCnsETechOutRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutRYSShareOut", c("name", "description")] <- c("eqCnsETechOutRYSShareOut", "");
    rs["eqCnsETechOutRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutRYS", c("name", "description")] <- c("eqCnsETechOutRYS", "");
    rs["eqCnsETechOutRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutRYSGrowth", c("name", "description")] <- c("eqCnsETechOutRYSGrowth", "");
    rs["eqCnsETechOutRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCShareIn", c("name", "description")] <- c("eqCnsLETechOutCShareIn", "");
    rs["eqCnsLETechOutCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCShareOut", c("name", "description")] <- c("eqCnsLETechOutCShareOut", "");
    rs["eqCnsLETechOutCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutC", c("name", "description")] <- c("eqCnsLETechOutC", "");
    rs["eqCnsLETechOutC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCShareIn", c("name", "description")] <- c("eqCnsGETechOutCShareIn", "");
    rs["eqCnsGETechOutCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCShareOut", c("name", "description")] <- c("eqCnsGETechOutCShareOut", "");
    rs["eqCnsGETechOutCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutC", c("name", "description")] <- c("eqCnsGETechOutC", "");
    rs["eqCnsGETechOutC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCShareIn", c("name", "description")] <- c("eqCnsETechOutCShareIn", "");
    rs["eqCnsETechOutCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCShareOut", c("name", "description")] <- c("eqCnsETechOutCShareOut", "");
    rs["eqCnsETechOutCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutC", c("name", "description")] <- c("eqCnsETechOutC", "");
    rs["eqCnsETechOutC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCSShareIn", c("name", "description")] <- c("eqCnsLETechOutCSShareIn", "");
    rs["eqCnsLETechOutCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCSShareOut", c("name", "description")] <- c("eqCnsLETechOutCSShareOut", "");
    rs["eqCnsLETechOutCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCS", c("name", "description")] <- c("eqCnsLETechOutCS", "");
    rs["eqCnsLETechOutCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCSShareIn", c("name", "description")] <- c("eqCnsGETechOutCSShareIn", "");
    rs["eqCnsGETechOutCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCSShareOut", c("name", "description")] <- c("eqCnsGETechOutCSShareOut", "");
    rs["eqCnsGETechOutCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCS", c("name", "description")] <- c("eqCnsGETechOutCS", "");
    rs["eqCnsGETechOutCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCSShareIn", c("name", "description")] <- c("eqCnsETechOutCSShareIn", "");
    rs["eqCnsETechOutCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCSShareOut", c("name", "description")] <- c("eqCnsETechOutCSShareOut", "");
    rs["eqCnsETechOutCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCS", c("name", "description")] <- c("eqCnsETechOutCS", "");
    rs["eqCnsETechOutCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCYShareIn", c("name", "description")] <- c("eqCnsLETechOutCYShareIn", "");
    rs["eqCnsLETechOutCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCYShareOut", c("name", "description")] <- c("eqCnsLETechOutCYShareOut", "");
    rs["eqCnsLETechOutCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCY", c("name", "description")] <- c("eqCnsLETechOutCY", "");
    rs["eqCnsLETechOutCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCYGrowth", c("name", "description")] <- c("eqCnsLETechOutCYGrowth", "");
    rs["eqCnsLETechOutCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCYShareIn", c("name", "description")] <- c("eqCnsGETechOutCYShareIn", "");
    rs["eqCnsGETechOutCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCYShareOut", c("name", "description")] <- c("eqCnsGETechOutCYShareOut", "");
    rs["eqCnsGETechOutCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCY", c("name", "description")] <- c("eqCnsGETechOutCY", "");
    rs["eqCnsGETechOutCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCYGrowth", c("name", "description")] <- c("eqCnsGETechOutCYGrowth", "");
    rs["eqCnsGETechOutCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCYShareIn", c("name", "description")] <- c("eqCnsETechOutCYShareIn", "");
    rs["eqCnsETechOutCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCYShareOut", c("name", "description")] <- c("eqCnsETechOutCYShareOut", "");
    rs["eqCnsETechOutCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCY", c("name", "description")] <- c("eqCnsETechOutCY", "");
    rs["eqCnsETechOutCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCYGrowth", c("name", "description")] <- c("eqCnsETechOutCYGrowth", "");
    rs["eqCnsETechOutCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCYSShareIn", c("name", "description")] <- c("eqCnsLETechOutCYSShareIn", "");
    rs["eqCnsLETechOutCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCYSShareOut", c("name", "description")] <- c("eqCnsLETechOutCYSShareOut", "");
    rs["eqCnsLETechOutCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCYS", c("name", "description")] <- c("eqCnsLETechOutCYS", "");
    rs["eqCnsLETechOutCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCYSGrowth", c("name", "description")] <- c("eqCnsLETechOutCYSGrowth", "");
    rs["eqCnsLETechOutCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCYSShareIn", c("name", "description")] <- c("eqCnsGETechOutCYSShareIn", "");
    rs["eqCnsGETechOutCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCYSShareOut", c("name", "description")] <- c("eqCnsGETechOutCYSShareOut", "");
    rs["eqCnsGETechOutCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCYS", c("name", "description")] <- c("eqCnsGETechOutCYS", "");
    rs["eqCnsGETechOutCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCYSGrowth", c("name", "description")] <- c("eqCnsGETechOutCYSGrowth", "");
    rs["eqCnsGETechOutCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCYSShareIn", c("name", "description")] <- c("eqCnsETechOutCYSShareIn", "");
    rs["eqCnsETechOutCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCYSShareOut", c("name", "description")] <- c("eqCnsETechOutCYSShareOut", "");
    rs["eqCnsETechOutCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCYS", c("name", "description")] <- c("eqCnsETechOutCYS", "");
    rs["eqCnsETechOutCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCYSGrowth", c("name", "description")] <- c("eqCnsETechOutCYSGrowth", "");
    rs["eqCnsETechOutCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRShareIn", c("name", "description")] <- c("eqCnsLETechOutCRShareIn", "");
    rs["eqCnsLETechOutCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCRShareOut", c("name", "description")] <- c("eqCnsLETechOutCRShareOut", "");
    rs["eqCnsLETechOutCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCR", c("name", "description")] <- c("eqCnsLETechOutCR", "");
    rs["eqCnsLETechOutCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRShareIn", c("name", "description")] <- c("eqCnsGETechOutCRShareIn", "");
    rs["eqCnsGETechOutCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCRShareOut", c("name", "description")] <- c("eqCnsGETechOutCRShareOut", "");
    rs["eqCnsGETechOutCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCR", c("name", "description")] <- c("eqCnsGETechOutCR", "");
    rs["eqCnsGETechOutCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRShareIn", c("name", "description")] <- c("eqCnsETechOutCRShareIn", "");
    rs["eqCnsETechOutCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCRShareOut", c("name", "description")] <- c("eqCnsETechOutCRShareOut", "");
    rs["eqCnsETechOutCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCR", c("name", "description")] <- c("eqCnsETechOutCR", "");
    rs["eqCnsETechOutCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRSShareIn", c("name", "description")] <- c("eqCnsLETechOutCRSShareIn", "");
    rs["eqCnsLETechOutCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCRSShareOut", c("name", "description")] <- c("eqCnsLETechOutCRSShareOut", "");
    rs["eqCnsLETechOutCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCRS", c("name", "description")] <- c("eqCnsLETechOutCRS", "");
    rs["eqCnsLETechOutCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRSShareIn", c("name", "description")] <- c("eqCnsGETechOutCRSShareIn", "");
    rs["eqCnsGETechOutCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCRSShareOut", c("name", "description")] <- c("eqCnsGETechOutCRSShareOut", "");
    rs["eqCnsGETechOutCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCRS", c("name", "description")] <- c("eqCnsGETechOutCRS", "");
    rs["eqCnsGETechOutCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRSShareIn", c("name", "description")] <- c("eqCnsETechOutCRSShareIn", "");
    rs["eqCnsETechOutCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCRSShareOut", c("name", "description")] <- c("eqCnsETechOutCRSShareOut", "");
    rs["eqCnsETechOutCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCRS", c("name", "description")] <- c("eqCnsETechOutCRS", "");
    rs["eqCnsETechOutCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRYShareIn", c("name", "description")] <- c("eqCnsLETechOutCRYShareIn", "");
    rs["eqCnsLETechOutCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCRYShareOut", c("name", "description")] <- c("eqCnsLETechOutCRYShareOut", "");
    rs["eqCnsLETechOutCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCRY", c("name", "description")] <- c("eqCnsLETechOutCRY", "");
    rs["eqCnsLETechOutCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRYGrowth", c("name", "description")] <- c("eqCnsLETechOutCRYGrowth", "");
    rs["eqCnsLETechOutCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRYShareIn", c("name", "description")] <- c("eqCnsGETechOutCRYShareIn", "");
    rs["eqCnsGETechOutCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCRYShareOut", c("name", "description")] <- c("eqCnsGETechOutCRYShareOut", "");
    rs["eqCnsGETechOutCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCRY", c("name", "description")] <- c("eqCnsGETechOutCRY", "");
    rs["eqCnsGETechOutCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRYGrowth", c("name", "description")] <- c("eqCnsGETechOutCRYGrowth", "");
    rs["eqCnsGETechOutCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRYShareIn", c("name", "description")] <- c("eqCnsETechOutCRYShareIn", "");
    rs["eqCnsETechOutCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCRYShareOut", c("name", "description")] <- c("eqCnsETechOutCRYShareOut", "");
    rs["eqCnsETechOutCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCRY", c("name", "description")] <- c("eqCnsETechOutCRY", "");
    rs["eqCnsETechOutCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRYGrowth", c("name", "description")] <- c("eqCnsETechOutCRYGrowth", "");
    rs["eqCnsETechOutCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRYSShareIn", c("name", "description")] <- c("eqCnsLETechOutCRYSShareIn", "");
    rs["eqCnsLETechOutCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutCRYSShareOut", c("name", "description")] <- c("eqCnsLETechOutCRYSShareOut", "");
    rs["eqCnsLETechOutCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutCRYS", c("name", "description")] <- c("eqCnsLETechOutCRYS", "");
    rs["eqCnsLETechOutCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutCRYSGrowth", c("name", "description")] <- c("eqCnsLETechOutCRYSGrowth", "");
    rs["eqCnsLETechOutCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRYSShareIn", c("name", "description")] <- c("eqCnsGETechOutCRYSShareIn", "");
    rs["eqCnsGETechOutCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutCRYSShareOut", c("name", "description")] <- c("eqCnsGETechOutCRYSShareOut", "");
    rs["eqCnsGETechOutCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutCRYS", c("name", "description")] <- c("eqCnsGETechOutCRYS", "");
    rs["eqCnsGETechOutCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutCRYSGrowth", c("name", "description")] <- c("eqCnsGETechOutCRYSGrowth", "");
    rs["eqCnsGETechOutCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRYSShareIn", c("name", "description")] <- c("eqCnsETechOutCRYSShareIn", "");
    rs["eqCnsETechOutCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutCRYSShareOut", c("name", "description")] <- c("eqCnsETechOutCRYSShareOut", "");
    rs["eqCnsETechOutCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutCRYS", c("name", "description")] <- c("eqCnsETechOutCRYS", "");
    rs["eqCnsETechOutCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutCRYSGrowth", c("name", "description")] <- c("eqCnsETechOutCRYSGrowth", "");
    rs["eqCnsETechOutCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechCap", c("name", "description")] <- c("eqCnsLETechCap", "");
    rs["eqCnsLETechCap", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCap", c("name", "description")] <- c("eqCnsGETechCap", "");
    rs["eqCnsGETechCap", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCap", c("name", "description")] <- c("eqCnsETechCap", "");
    rs["eqCnsETechCap", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapY", c("name", "description")] <- c("eqCnsLETechCapY", "");
    rs["eqCnsLETechCapY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapYGrowth", c("name", "description")] <- c("eqCnsLETechCapYGrowth", "");
    rs["eqCnsLETechCapYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapY", c("name", "description")] <- c("eqCnsGETechCapY", "");
    rs["eqCnsGETechCapY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapYGrowth", c("name", "description")] <- c("eqCnsGETechCapYGrowth", "");
    rs["eqCnsGETechCapYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapY", c("name", "description")] <- c("eqCnsETechCapY", "");
    rs["eqCnsETechCapY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapYGrowth", c("name", "description")] <- c("eqCnsETechCapYGrowth", "");
    rs["eqCnsETechCapYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapR", c("name", "description")] <- c("eqCnsLETechCapR", "");
    rs["eqCnsLETechCapR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapR", c("name", "description")] <- c("eqCnsGETechCapR", "");
    rs["eqCnsGETechCapR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapR", c("name", "description")] <- c("eqCnsETechCapR", "");
    rs["eqCnsETechCapR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapRY", c("name", "description")] <- c("eqCnsLETechCapRY", "");
    rs["eqCnsLETechCapRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapRYGrowth", c("name", "description")] <- c("eqCnsLETechCapRYGrowth", "");
    rs["eqCnsLETechCapRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapRY", c("name", "description")] <- c("eqCnsGETechCapRY", "");
    rs["eqCnsGETechCapRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapRYGrowth", c("name", "description")] <- c("eqCnsGETechCapRYGrowth", "");
    rs["eqCnsGETechCapRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapRY", c("name", "description")] <- c("eqCnsETechCapRY", "");
    rs["eqCnsETechCapRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapRYGrowth", c("name", "description")] <- c("eqCnsETechCapRYGrowth", "");
    rs["eqCnsETechCapRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechNewCap", c("name", "description")] <- c("eqCnsLETechNewCap", "");
    rs["eqCnsLETechNewCap", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCap", c("name", "description")] <- c("eqCnsGETechNewCap", "");
    rs["eqCnsGETechNewCap", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCap", c("name", "description")] <- c("eqCnsETechNewCap", "");
    rs["eqCnsETechNewCap", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapY", c("name", "description")] <- c("eqCnsLETechNewCapY", "");
    rs["eqCnsLETechNewCapY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapYGrowth", c("name", "description")] <- c("eqCnsLETechNewCapYGrowth", "");
    rs["eqCnsLETechNewCapYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapY", c("name", "description")] <- c("eqCnsGETechNewCapY", "");
    rs["eqCnsGETechNewCapY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapYGrowth", c("name", "description")] <- c("eqCnsGETechNewCapYGrowth", "");
    rs["eqCnsGETechNewCapYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapY", c("name", "description")] <- c("eqCnsETechNewCapY", "");
    rs["eqCnsETechNewCapY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapYGrowth", c("name", "description")] <- c("eqCnsETechNewCapYGrowth", "");
    rs["eqCnsETechNewCapYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapR", c("name", "description")] <- c("eqCnsLETechNewCapR", "");
    rs["eqCnsLETechNewCapR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapR", c("name", "description")] <- c("eqCnsGETechNewCapR", "");
    rs["eqCnsGETechNewCapR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapR", c("name", "description")] <- c("eqCnsETechNewCapR", "");
    rs["eqCnsETechNewCapR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapRY", c("name", "description")] <- c("eqCnsLETechNewCapRY", "");
    rs["eqCnsLETechNewCapRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapRYGrowth", c("name", "description")] <- c("eqCnsLETechNewCapRYGrowth", "");
    rs["eqCnsLETechNewCapRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapRY", c("name", "description")] <- c("eqCnsGETechNewCapRY", "");
    rs["eqCnsGETechNewCapRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapRYGrowth", c("name", "description")] <- c("eqCnsGETechNewCapRYGrowth", "");
    rs["eqCnsGETechNewCapRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapRY", c("name", "description")] <- c("eqCnsETechNewCapRY", "");
    rs["eqCnsETechNewCapRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapRYGrowth", c("name", "description")] <- c("eqCnsETechNewCapRYGrowth", "");
    rs["eqCnsETechNewCapRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechInv", c("name", "description")] <- c("eqCnsLETechInv", "");
    rs["eqCnsLETechInv", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInv", c("name", "description")] <- c("eqCnsGETechInv", "");
    rs["eqCnsGETechInv", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInv", c("name", "description")] <- c("eqCnsETechInv", "");
    rs["eqCnsETechInv", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvY", c("name", "description")] <- c("eqCnsLETechInvY", "");
    rs["eqCnsLETechInvY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvYGrowth", c("name", "description")] <- c("eqCnsLETechInvYGrowth", "");
    rs["eqCnsLETechInvYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvY", c("name", "description")] <- c("eqCnsGETechInvY", "");
    rs["eqCnsGETechInvY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvYGrowth", c("name", "description")] <- c("eqCnsGETechInvYGrowth", "");
    rs["eqCnsGETechInvYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvY", c("name", "description")] <- c("eqCnsETechInvY", "");
    rs["eqCnsETechInvY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvYGrowth", c("name", "description")] <- c("eqCnsETechInvYGrowth", "");
    rs["eqCnsETechInvYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvR", c("name", "description")] <- c("eqCnsLETechInvR", "");
    rs["eqCnsLETechInvR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvR", c("name", "description")] <- c("eqCnsGETechInvR", "");
    rs["eqCnsGETechInvR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvR", c("name", "description")] <- c("eqCnsETechInvR", "");
    rs["eqCnsETechInvR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvRY", c("name", "description")] <- c("eqCnsLETechInvRY", "");
    rs["eqCnsLETechInvRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvRYGrowth", c("name", "description")] <- c("eqCnsLETechInvRYGrowth", "");
    rs["eqCnsLETechInvRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvRY", c("name", "description")] <- c("eqCnsGETechInvRY", "");
    rs["eqCnsGETechInvRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvRYGrowth", c("name", "description")] <- c("eqCnsGETechInvRYGrowth", "");
    rs["eqCnsGETechInvRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvRY", c("name", "description")] <- c("eqCnsETechInvRY", "");
    rs["eqCnsETechInvRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvRYGrowth", c("name", "description")] <- c("eqCnsETechInvRYGrowth", "");
    rs["eqCnsETechInvRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechEac", c("name", "description")] <- c("eqCnsLETechEac", "");
    rs["eqCnsLETechEac", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEac", c("name", "description")] <- c("eqCnsGETechEac", "");
    rs["eqCnsGETechEac", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEac", c("name", "description")] <- c("eqCnsETechEac", "");
    rs["eqCnsETechEac", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacY", c("name", "description")] <- c("eqCnsLETechEacY", "");
    rs["eqCnsLETechEacY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacYGrowth", c("name", "description")] <- c("eqCnsLETechEacYGrowth", "");
    rs["eqCnsLETechEacYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacY", c("name", "description")] <- c("eqCnsGETechEacY", "");
    rs["eqCnsGETechEacY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacYGrowth", c("name", "description")] <- c("eqCnsGETechEacYGrowth", "");
    rs["eqCnsGETechEacYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacY", c("name", "description")] <- c("eqCnsETechEacY", "");
    rs["eqCnsETechEacY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacYGrowth", c("name", "description")] <- c("eqCnsETechEacYGrowth", "");
    rs["eqCnsETechEacYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacR", c("name", "description")] <- c("eqCnsLETechEacR", "");
    rs["eqCnsLETechEacR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacR", c("name", "description")] <- c("eqCnsGETechEacR", "");
    rs["eqCnsGETechEacR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacR", c("name", "description")] <- c("eqCnsETechEacR", "");
    rs["eqCnsETechEacR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacRY", c("name", "description")] <- c("eqCnsLETechEacRY", "");
    rs["eqCnsLETechEacRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacRYGrowth", c("name", "description")] <- c("eqCnsLETechEacRYGrowth", "");
    rs["eqCnsLETechEacRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacRY", c("name", "description")] <- c("eqCnsGETechEacRY", "");
    rs["eqCnsGETechEacRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacRYGrowth", c("name", "description")] <- c("eqCnsGETechEacRYGrowth", "");
    rs["eqCnsGETechEacRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacRY", c("name", "description")] <- c("eqCnsETechEacRY", "");
    rs["eqCnsETechEacRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacRYGrowth", c("name", "description")] <- c("eqCnsETechEacRYGrowth", "");
    rs["eqCnsETechEacRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechAct", c("name", "description")] <- c("eqCnsLETechAct", "");
    rs["eqCnsLETechAct", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechAct", c("name", "description")] <- c("eqCnsGETechAct", "");
    rs["eqCnsGETechAct", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechAct", c("name", "description")] <- c("eqCnsETechAct", "");
    rs["eqCnsETechAct", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActS", c("name", "description")] <- c("eqCnsLETechActS", "");
    rs["eqCnsLETechActS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActS", c("name", "description")] <- c("eqCnsGETechActS", "");
    rs["eqCnsGETechActS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActS", c("name", "description")] <- c("eqCnsETechActS", "");
    rs["eqCnsETechActS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActY", c("name", "description")] <- c("eqCnsLETechActY", "");
    rs["eqCnsLETechActY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActYGrowth", c("name", "description")] <- c("eqCnsLETechActYGrowth", "");
    rs["eqCnsLETechActYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActY", c("name", "description")] <- c("eqCnsGETechActY", "");
    rs["eqCnsGETechActY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActYGrowth", c("name", "description")] <- c("eqCnsGETechActYGrowth", "");
    rs["eqCnsGETechActYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActY", c("name", "description")] <- c("eqCnsETechActY", "");
    rs["eqCnsETechActY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActYGrowth", c("name", "description")] <- c("eqCnsETechActYGrowth", "");
    rs["eqCnsETechActYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActYS", c("name", "description")] <- c("eqCnsLETechActYS", "");
    rs["eqCnsLETechActYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActYSGrowth", c("name", "description")] <- c("eqCnsLETechActYSGrowth", "");
    rs["eqCnsLETechActYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActYS", c("name", "description")] <- c("eqCnsGETechActYS", "");
    rs["eqCnsGETechActYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActYSGrowth", c("name", "description")] <- c("eqCnsGETechActYSGrowth", "");
    rs["eqCnsGETechActYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActYS", c("name", "description")] <- c("eqCnsETechActYS", "");
    rs["eqCnsETechActYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActYSGrowth", c("name", "description")] <- c("eqCnsETechActYSGrowth", "");
    rs["eqCnsETechActYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActR", c("name", "description")] <- c("eqCnsLETechActR", "");
    rs["eqCnsLETechActR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActR", c("name", "description")] <- c("eqCnsGETechActR", "");
    rs["eqCnsGETechActR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActR", c("name", "description")] <- c("eqCnsETechActR", "");
    rs["eqCnsETechActR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActRS", c("name", "description")] <- c("eqCnsLETechActRS", "");
    rs["eqCnsLETechActRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActRS", c("name", "description")] <- c("eqCnsGETechActRS", "");
    rs["eqCnsGETechActRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActRS", c("name", "description")] <- c("eqCnsETechActRS", "");
    rs["eqCnsETechActRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActRY", c("name", "description")] <- c("eqCnsLETechActRY", "");
    rs["eqCnsLETechActRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActRYGrowth", c("name", "description")] <- c("eqCnsLETechActRYGrowth", "");
    rs["eqCnsLETechActRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActRY", c("name", "description")] <- c("eqCnsGETechActRY", "");
    rs["eqCnsGETechActRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActRYGrowth", c("name", "description")] <- c("eqCnsGETechActRYGrowth", "");
    rs["eqCnsGETechActRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActRY", c("name", "description")] <- c("eqCnsETechActRY", "");
    rs["eqCnsETechActRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActRYGrowth", c("name", "description")] <- c("eqCnsETechActRYGrowth", "");
    rs["eqCnsETechActRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActRYS", c("name", "description")] <- c("eqCnsLETechActRYS", "");
    rs["eqCnsLETechActRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActRYSGrowth", c("name", "description")] <- c("eqCnsLETechActRYSGrowth", "");
    rs["eqCnsLETechActRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActRYS", c("name", "description")] <- c("eqCnsGETechActRYS", "");
    rs["eqCnsGETechActRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActRYSGrowth", c("name", "description")] <- c("eqCnsGETechActRYSGrowth", "");
    rs["eqCnsGETechActRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActRYS", c("name", "description")] <- c("eqCnsETechActRYS", "");
    rs["eqCnsETechActRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActRYSGrowth", c("name", "description")] <- c("eqCnsETechActRYSGrowth", "");
    rs["eqCnsETechActRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechVarom", c("name", "description")] <- c("eqCnsLETechVarom", "");
    rs["eqCnsLETechVarom", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVarom", c("name", "description")] <- c("eqCnsGETechVarom", "");
    rs["eqCnsGETechVarom", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVarom", c("name", "description")] <- c("eqCnsETechVarom", "");
    rs["eqCnsETechVarom", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromS", c("name", "description")] <- c("eqCnsLETechVaromS", "");
    rs["eqCnsLETechVaromS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromS", c("name", "description")] <- c("eqCnsGETechVaromS", "");
    rs["eqCnsGETechVaromS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromS", c("name", "description")] <- c("eqCnsETechVaromS", "");
    rs["eqCnsETechVaromS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromY", c("name", "description")] <- c("eqCnsLETechVaromY", "");
    rs["eqCnsLETechVaromY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromYGrowth", c("name", "description")] <- c("eqCnsLETechVaromYGrowth", "");
    rs["eqCnsLETechVaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromY", c("name", "description")] <- c("eqCnsGETechVaromY", "");
    rs["eqCnsGETechVaromY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromYGrowth", c("name", "description")] <- c("eqCnsGETechVaromYGrowth", "");
    rs["eqCnsGETechVaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromY", c("name", "description")] <- c("eqCnsETechVaromY", "");
    rs["eqCnsETechVaromY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromYGrowth", c("name", "description")] <- c("eqCnsETechVaromYGrowth", "");
    rs["eqCnsETechVaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromYS", c("name", "description")] <- c("eqCnsLETechVaromYS", "");
    rs["eqCnsLETechVaromYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromYSGrowth", c("name", "description")] <- c("eqCnsLETechVaromYSGrowth", "");
    rs["eqCnsLETechVaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromYS", c("name", "description")] <- c("eqCnsGETechVaromYS", "");
    rs["eqCnsGETechVaromYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromYSGrowth", c("name", "description")] <- c("eqCnsGETechVaromYSGrowth", "");
    rs["eqCnsGETechVaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromYS", c("name", "description")] <- c("eqCnsETechVaromYS", "");
    rs["eqCnsETechVaromYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromYSGrowth", c("name", "description")] <- c("eqCnsETechVaromYSGrowth", "");
    rs["eqCnsETechVaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromR", c("name", "description")] <- c("eqCnsLETechVaromR", "");
    rs["eqCnsLETechVaromR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromR", c("name", "description")] <- c("eqCnsGETechVaromR", "");
    rs["eqCnsGETechVaromR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromR", c("name", "description")] <- c("eqCnsETechVaromR", "");
    rs["eqCnsETechVaromR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromRS", c("name", "description")] <- c("eqCnsLETechVaromRS", "");
    rs["eqCnsLETechVaromRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromRS", c("name", "description")] <- c("eqCnsGETechVaromRS", "");
    rs["eqCnsGETechVaromRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromRS", c("name", "description")] <- c("eqCnsETechVaromRS", "");
    rs["eqCnsETechVaromRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromRY", c("name", "description")] <- c("eqCnsLETechVaromRY", "");
    rs["eqCnsLETechVaromRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromRYGrowth", c("name", "description")] <- c("eqCnsLETechVaromRYGrowth", "");
    rs["eqCnsLETechVaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromRY", c("name", "description")] <- c("eqCnsGETechVaromRY", "");
    rs["eqCnsGETechVaromRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromRYGrowth", c("name", "description")] <- c("eqCnsGETechVaromRYGrowth", "");
    rs["eqCnsGETechVaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromRY", c("name", "description")] <- c("eqCnsETechVaromRY", "");
    rs["eqCnsETechVaromRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromRYGrowth", c("name", "description")] <- c("eqCnsETechVaromRYGrowth", "");
    rs["eqCnsETechVaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromRYS", c("name", "description")] <- c("eqCnsLETechVaromRYS", "");
    rs["eqCnsLETechVaromRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromRYSGrowth", c("name", "description")] <- c("eqCnsLETechVaromRYSGrowth", "");
    rs["eqCnsLETechVaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromRYS", c("name", "description")] <- c("eqCnsGETechVaromRYS", "");
    rs["eqCnsGETechVaromRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromRYSGrowth", c("name", "description")] <- c("eqCnsGETechVaromRYSGrowth", "");
    rs["eqCnsGETechVaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromRYS", c("name", "description")] <- c("eqCnsETechVaromRYS", "");
    rs["eqCnsETechVaromRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromRYSGrowth", c("name", "description")] <- c("eqCnsETechVaromRYSGrowth", "");
    rs["eqCnsETechVaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechFixom", c("name", "description")] <- c("eqCnsLETechFixom", "");
    rs["eqCnsLETechFixom", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixom", c("name", "description")] <- c("eqCnsGETechFixom", "");
    rs["eqCnsGETechFixom", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixom", c("name", "description")] <- c("eqCnsETechFixom", "");
    rs["eqCnsETechFixom", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomY", c("name", "description")] <- c("eqCnsLETechFixomY", "");
    rs["eqCnsLETechFixomY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomYGrowth", c("name", "description")] <- c("eqCnsLETechFixomYGrowth", "");
    rs["eqCnsLETechFixomYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomY", c("name", "description")] <- c("eqCnsGETechFixomY", "");
    rs["eqCnsGETechFixomY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomYGrowth", c("name", "description")] <- c("eqCnsGETechFixomYGrowth", "");
    rs["eqCnsGETechFixomYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomY", c("name", "description")] <- c("eqCnsETechFixomY", "");
    rs["eqCnsETechFixomY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomYGrowth", c("name", "description")] <- c("eqCnsETechFixomYGrowth", "");
    rs["eqCnsETechFixomYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomR", c("name", "description")] <- c("eqCnsLETechFixomR", "");
    rs["eqCnsLETechFixomR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomR", c("name", "description")] <- c("eqCnsGETechFixomR", "");
    rs["eqCnsGETechFixomR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomR", c("name", "description")] <- c("eqCnsETechFixomR", "");
    rs["eqCnsETechFixomR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomRY", c("name", "description")] <- c("eqCnsLETechFixomRY", "");
    rs["eqCnsLETechFixomRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomRYGrowth", c("name", "description")] <- c("eqCnsLETechFixomRYGrowth", "");
    rs["eqCnsLETechFixomRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomRY", c("name", "description")] <- c("eqCnsGETechFixomRY", "");
    rs["eqCnsGETechFixomRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomRYGrowth", c("name", "description")] <- c("eqCnsGETechFixomRYGrowth", "");
    rs["eqCnsGETechFixomRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomRY", c("name", "description")] <- c("eqCnsETechFixomRY", "");
    rs["eqCnsETechFixomRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomRYGrowth", c("name", "description")] <- c("eqCnsETechFixomRYGrowth", "");
    rs["eqCnsETechFixomRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechActvarom", c("name", "description")] <- c("eqCnsLETechActvarom", "");
    rs["eqCnsLETechActvarom", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvarom", c("name", "description")] <- c("eqCnsGETechActvarom", "");
    rs["eqCnsGETechActvarom", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvarom", c("name", "description")] <- c("eqCnsETechActvarom", "");
    rs["eqCnsETechActvarom", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromS", c("name", "description")] <- c("eqCnsLETechActvaromS", "");
    rs["eqCnsLETechActvaromS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromS", c("name", "description")] <- c("eqCnsGETechActvaromS", "");
    rs["eqCnsGETechActvaromS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromS", c("name", "description")] <- c("eqCnsETechActvaromS", "");
    rs["eqCnsETechActvaromS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromY", c("name", "description")] <- c("eqCnsLETechActvaromY", "");
    rs["eqCnsLETechActvaromY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromYGrowth", c("name", "description")] <- c("eqCnsLETechActvaromYGrowth", "");
    rs["eqCnsLETechActvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromY", c("name", "description")] <- c("eqCnsGETechActvaromY", "");
    rs["eqCnsGETechActvaromY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromYGrowth", c("name", "description")] <- c("eqCnsGETechActvaromYGrowth", "");
    rs["eqCnsGETechActvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromY", c("name", "description")] <- c("eqCnsETechActvaromY", "");
    rs["eqCnsETechActvaromY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromYGrowth", c("name", "description")] <- c("eqCnsETechActvaromYGrowth", "");
    rs["eqCnsETechActvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromYS", c("name", "description")] <- c("eqCnsLETechActvaromYS", "");
    rs["eqCnsLETechActvaromYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromYSGrowth", c("name", "description")] <- c("eqCnsLETechActvaromYSGrowth", "");
    rs["eqCnsLETechActvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromYS", c("name", "description")] <- c("eqCnsGETechActvaromYS", "");
    rs["eqCnsGETechActvaromYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromYSGrowth", c("name", "description")] <- c("eqCnsGETechActvaromYSGrowth", "");
    rs["eqCnsGETechActvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromYS", c("name", "description")] <- c("eqCnsETechActvaromYS", "");
    rs["eqCnsETechActvaromYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromYSGrowth", c("name", "description")] <- c("eqCnsETechActvaromYSGrowth", "");
    rs["eqCnsETechActvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromR", c("name", "description")] <- c("eqCnsLETechActvaromR", "");
    rs["eqCnsLETechActvaromR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromR", c("name", "description")] <- c("eqCnsGETechActvaromR", "");
    rs["eqCnsGETechActvaromR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromR", c("name", "description")] <- c("eqCnsETechActvaromR", "");
    rs["eqCnsETechActvaromR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromRS", c("name", "description")] <- c("eqCnsLETechActvaromRS", "");
    rs["eqCnsLETechActvaromRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromRS", c("name", "description")] <- c("eqCnsGETechActvaromRS", "");
    rs["eqCnsGETechActvaromRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromRS", c("name", "description")] <- c("eqCnsETechActvaromRS", "");
    rs["eqCnsETechActvaromRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromRY", c("name", "description")] <- c("eqCnsLETechActvaromRY", "");
    rs["eqCnsLETechActvaromRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromRYGrowth", c("name", "description")] <- c("eqCnsLETechActvaromRYGrowth", "");
    rs["eqCnsLETechActvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromRY", c("name", "description")] <- c("eqCnsGETechActvaromRY", "");
    rs["eqCnsGETechActvaromRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromRYGrowth", c("name", "description")] <- c("eqCnsGETechActvaromRYGrowth", "");
    rs["eqCnsGETechActvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromRY", c("name", "description")] <- c("eqCnsETechActvaromRY", "");
    rs["eqCnsETechActvaromRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromRYGrowth", c("name", "description")] <- c("eqCnsETechActvaromRYGrowth", "");
    rs["eqCnsETechActvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromRYS", c("name", "description")] <- c("eqCnsLETechActvaromRYS", "");
    rs["eqCnsLETechActvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromRYSGrowth", c("name", "description")] <- c("eqCnsLETechActvaromRYSGrowth", "");
    rs["eqCnsLETechActvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromRYS", c("name", "description")] <- c("eqCnsGETechActvaromRYS", "");
    rs["eqCnsGETechActvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromRYSGrowth", c("name", "description")] <- c("eqCnsGETechActvaromRYSGrowth", "");
    rs["eqCnsGETechActvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromRYS", c("name", "description")] <- c("eqCnsETechActvaromRYS", "");
    rs["eqCnsETechActvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromRYSGrowth", c("name", "description")] <- c("eqCnsETechActvaromRYSGrowth", "");
    rs["eqCnsETechActvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechCvarom", c("name", "description")] <- c("eqCnsLETechCvarom", "");
    rs["eqCnsLETechCvarom", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvarom", c("name", "description")] <- c("eqCnsGETechCvarom", "");
    rs["eqCnsGETechCvarom", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvarom", c("name", "description")] <- c("eqCnsETechCvarom", "");
    rs["eqCnsETechCvarom", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromS", c("name", "description")] <- c("eqCnsLETechCvaromS", "");
    rs["eqCnsLETechCvaromS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromS", c("name", "description")] <- c("eqCnsGETechCvaromS", "");
    rs["eqCnsGETechCvaromS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromS", c("name", "description")] <- c("eqCnsETechCvaromS", "");
    rs["eqCnsETechCvaromS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromY", c("name", "description")] <- c("eqCnsLETechCvaromY", "");
    rs["eqCnsLETechCvaromY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromYGrowth", c("name", "description")] <- c("eqCnsLETechCvaromYGrowth", "");
    rs["eqCnsLETechCvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromY", c("name", "description")] <- c("eqCnsGETechCvaromY", "");
    rs["eqCnsGETechCvaromY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromYGrowth", c("name", "description")] <- c("eqCnsGETechCvaromYGrowth", "");
    rs["eqCnsGETechCvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromY", c("name", "description")] <- c("eqCnsETechCvaromY", "");
    rs["eqCnsETechCvaromY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromYGrowth", c("name", "description")] <- c("eqCnsETechCvaromYGrowth", "");
    rs["eqCnsETechCvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromYS", c("name", "description")] <- c("eqCnsLETechCvaromYS", "");
    rs["eqCnsLETechCvaromYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromYSGrowth", c("name", "description")] <- c("eqCnsLETechCvaromYSGrowth", "");
    rs["eqCnsLETechCvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromYS", c("name", "description")] <- c("eqCnsGETechCvaromYS", "");
    rs["eqCnsGETechCvaromYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromYSGrowth", c("name", "description")] <- c("eqCnsGETechCvaromYSGrowth", "");
    rs["eqCnsGETechCvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromYS", c("name", "description")] <- c("eqCnsETechCvaromYS", "");
    rs["eqCnsETechCvaromYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromYSGrowth", c("name", "description")] <- c("eqCnsETechCvaromYSGrowth", "");
    rs["eqCnsETechCvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromR", c("name", "description")] <- c("eqCnsLETechCvaromR", "");
    rs["eqCnsLETechCvaromR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromR", c("name", "description")] <- c("eqCnsGETechCvaromR", "");
    rs["eqCnsGETechCvaromR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromR", c("name", "description")] <- c("eqCnsETechCvaromR", "");
    rs["eqCnsETechCvaromR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromRS", c("name", "description")] <- c("eqCnsLETechCvaromRS", "");
    rs["eqCnsLETechCvaromRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromRS", c("name", "description")] <- c("eqCnsGETechCvaromRS", "");
    rs["eqCnsGETechCvaromRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromRS", c("name", "description")] <- c("eqCnsETechCvaromRS", "");
    rs["eqCnsETechCvaromRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromRY", c("name", "description")] <- c("eqCnsLETechCvaromRY", "");
    rs["eqCnsLETechCvaromRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromRYGrowth", c("name", "description")] <- c("eqCnsLETechCvaromRYGrowth", "");
    rs["eqCnsLETechCvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromRY", c("name", "description")] <- c("eqCnsGETechCvaromRY", "");
    rs["eqCnsGETechCvaromRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromRYGrowth", c("name", "description")] <- c("eqCnsGETechCvaromRYGrowth", "");
    rs["eqCnsGETechCvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromRY", c("name", "description")] <- c("eqCnsETechCvaromRY", "");
    rs["eqCnsETechCvaromRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromRYGrowth", c("name", "description")] <- c("eqCnsETechCvaromRYGrowth", "");
    rs["eqCnsETechCvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromRYS", c("name", "description")] <- c("eqCnsLETechCvaromRYS", "");
    rs["eqCnsLETechCvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromRYSGrowth", c("name", "description")] <- c("eqCnsLETechCvaromRYSGrowth", "");
    rs["eqCnsLETechCvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromRYS", c("name", "description")] <- c("eqCnsGETechCvaromRYS", "");
    rs["eqCnsGETechCvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromRYSGrowth", c("name", "description")] <- c("eqCnsGETechCvaromRYSGrowth", "");
    rs["eqCnsGETechCvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromRYS", c("name", "description")] <- c("eqCnsETechCvaromRYS", "");
    rs["eqCnsETechCvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromRYSGrowth", c("name", "description")] <- c("eqCnsETechCvaromRYSGrowth", "");
    rs["eqCnsETechCvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechAvarom", c("name", "description")] <- c("eqCnsLETechAvarom", "");
    rs["eqCnsLETechAvarom", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvarom", c("name", "description")] <- c("eqCnsGETechAvarom", "");
    rs["eqCnsGETechAvarom", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvarom", c("name", "description")] <- c("eqCnsETechAvarom", "");
    rs["eqCnsETechAvarom", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromS", c("name", "description")] <- c("eqCnsLETechAvaromS", "");
    rs["eqCnsLETechAvaromS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromS", c("name", "description")] <- c("eqCnsGETechAvaromS", "");
    rs["eqCnsGETechAvaromS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromS", c("name", "description")] <- c("eqCnsETechAvaromS", "");
    rs["eqCnsETechAvaromS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromY", c("name", "description")] <- c("eqCnsLETechAvaromY", "");
    rs["eqCnsLETechAvaromY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromYGrowth", c("name", "description")] <- c("eqCnsLETechAvaromYGrowth", "");
    rs["eqCnsLETechAvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromY", c("name", "description")] <- c("eqCnsGETechAvaromY", "");
    rs["eqCnsGETechAvaromY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromYGrowth", c("name", "description")] <- c("eqCnsGETechAvaromYGrowth", "");
    rs["eqCnsGETechAvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromY", c("name", "description")] <- c("eqCnsETechAvaromY", "");
    rs["eqCnsETechAvaromY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromYGrowth", c("name", "description")] <- c("eqCnsETechAvaromYGrowth", "");
    rs["eqCnsETechAvaromYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromYS", c("name", "description")] <- c("eqCnsLETechAvaromYS", "");
    rs["eqCnsLETechAvaromYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromYSGrowth", c("name", "description")] <- c("eqCnsLETechAvaromYSGrowth", "");
    rs["eqCnsLETechAvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromYS", c("name", "description")] <- c("eqCnsGETechAvaromYS", "");
    rs["eqCnsGETechAvaromYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromYSGrowth", c("name", "description")] <- c("eqCnsGETechAvaromYSGrowth", "");
    rs["eqCnsGETechAvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromYS", c("name", "description")] <- c("eqCnsETechAvaromYS", "");
    rs["eqCnsETechAvaromYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromYSGrowth", c("name", "description")] <- c("eqCnsETechAvaromYSGrowth", "");
    rs["eqCnsETechAvaromYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromR", c("name", "description")] <- c("eqCnsLETechAvaromR", "");
    rs["eqCnsLETechAvaromR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromR", c("name", "description")] <- c("eqCnsGETechAvaromR", "");
    rs["eqCnsGETechAvaromR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromR", c("name", "description")] <- c("eqCnsETechAvaromR", "");
    rs["eqCnsETechAvaromR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromRS", c("name", "description")] <- c("eqCnsLETechAvaromRS", "");
    rs["eqCnsLETechAvaromRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromRS", c("name", "description")] <- c("eqCnsGETechAvaromRS", "");
    rs["eqCnsGETechAvaromRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromRS", c("name", "description")] <- c("eqCnsETechAvaromRS", "");
    rs["eqCnsETechAvaromRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromRY", c("name", "description")] <- c("eqCnsLETechAvaromRY", "");
    rs["eqCnsLETechAvaromRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromRYGrowth", c("name", "description")] <- c("eqCnsLETechAvaromRYGrowth", "");
    rs["eqCnsLETechAvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromRY", c("name", "description")] <- c("eqCnsGETechAvaromRY", "");
    rs["eqCnsGETechAvaromRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromRYGrowth", c("name", "description")] <- c("eqCnsGETechAvaromRYGrowth", "");
    rs["eqCnsGETechAvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromRY", c("name", "description")] <- c("eqCnsETechAvaromRY", "");
    rs["eqCnsETechAvaromRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromRYGrowth", c("name", "description")] <- c("eqCnsETechAvaromRYGrowth", "");
    rs["eqCnsETechAvaromRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromRYS", c("name", "description")] <- c("eqCnsLETechAvaromRYS", "");
    rs["eqCnsLETechAvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromRYSGrowth", c("name", "description")] <- c("eqCnsLETechAvaromRYSGrowth", "");
    rs["eqCnsLETechAvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromRYS", c("name", "description")] <- c("eqCnsGETechAvaromRYS", "");
    rs["eqCnsGETechAvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromRYSGrowth", c("name", "description")] <- c("eqCnsGETechAvaromRYSGrowth", "");
    rs["eqCnsGETechAvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromRYS", c("name", "description")] <- c("eqCnsETechAvaromRYS", "");
    rs["eqCnsETechAvaromRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromRYSGrowth", c("name", "description")] <- c("eqCnsETechAvaromRYSGrowth", "");
    rs["eqCnsETechAvaromRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechInpLShareIn", c("name", "description")] <- c("eqCnsLETechInpLShareIn", "");
    rs["eqCnsLETechInpLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLShareOut", c("name", "description")] <- c("eqCnsLETechInpLShareOut", "");
    rs["eqCnsLETechInpLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpL", c("name", "description")] <- c("eqCnsLETechInpL", "");
    rs["eqCnsLETechInpL", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLShareIn", c("name", "description")] <- c("eqCnsGETechInpLShareIn", "");
    rs["eqCnsGETechInpLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLShareOut", c("name", "description")] <- c("eqCnsGETechInpLShareOut", "");
    rs["eqCnsGETechInpLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpL", c("name", "description")] <- c("eqCnsGETechInpL", "");
    rs["eqCnsGETechInpL", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLShareIn", c("name", "description")] <- c("eqCnsETechInpLShareIn", "");
    rs["eqCnsETechInpLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLShareOut", c("name", "description")] <- c("eqCnsETechInpLShareOut", "");
    rs["eqCnsETechInpLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpL", c("name", "description")] <- c("eqCnsETechInpL", "");
    rs["eqCnsETechInpL", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLSShareIn", c("name", "description")] <- c("eqCnsLETechInpLSShareIn", "");
    rs["eqCnsLETechInpLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLSShareOut", c("name", "description")] <- c("eqCnsLETechInpLSShareOut", "");
    rs["eqCnsLETechInpLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLS", c("name", "description")] <- c("eqCnsLETechInpLS", "");
    rs["eqCnsLETechInpLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLSShareIn", c("name", "description")] <- c("eqCnsGETechInpLSShareIn", "");
    rs["eqCnsGETechInpLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLSShareOut", c("name", "description")] <- c("eqCnsGETechInpLSShareOut", "");
    rs["eqCnsGETechInpLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLS", c("name", "description")] <- c("eqCnsGETechInpLS", "");
    rs["eqCnsGETechInpLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLSShareIn", c("name", "description")] <- c("eqCnsETechInpLSShareIn", "");
    rs["eqCnsETechInpLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLSShareOut", c("name", "description")] <- c("eqCnsETechInpLSShareOut", "");
    rs["eqCnsETechInpLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLS", c("name", "description")] <- c("eqCnsETechInpLS", "");
    rs["eqCnsETechInpLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLYShareIn", c("name", "description")] <- c("eqCnsLETechInpLYShareIn", "");
    rs["eqCnsLETechInpLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLYShareOut", c("name", "description")] <- c("eqCnsLETechInpLYShareOut", "");
    rs["eqCnsLETechInpLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLY", c("name", "description")] <- c("eqCnsLETechInpLY", "");
    rs["eqCnsLETechInpLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLYGrowth", c("name", "description")] <- c("eqCnsLETechInpLYGrowth", "");
    rs["eqCnsLETechInpLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLYShareIn", c("name", "description")] <- c("eqCnsGETechInpLYShareIn", "");
    rs["eqCnsGETechInpLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLYShareOut", c("name", "description")] <- c("eqCnsGETechInpLYShareOut", "");
    rs["eqCnsGETechInpLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLY", c("name", "description")] <- c("eqCnsGETechInpLY", "");
    rs["eqCnsGETechInpLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLYGrowth", c("name", "description")] <- c("eqCnsGETechInpLYGrowth", "");
    rs["eqCnsGETechInpLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLYShareIn", c("name", "description")] <- c("eqCnsETechInpLYShareIn", "");
    rs["eqCnsETechInpLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLYShareOut", c("name", "description")] <- c("eqCnsETechInpLYShareOut", "");
    rs["eqCnsETechInpLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLY", c("name", "description")] <- c("eqCnsETechInpLY", "");
    rs["eqCnsETechInpLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLYGrowth", c("name", "description")] <- c("eqCnsETechInpLYGrowth", "");
    rs["eqCnsETechInpLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLYSShareIn", c("name", "description")] <- c("eqCnsLETechInpLYSShareIn", "");
    rs["eqCnsLETechInpLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLYSShareOut", c("name", "description")] <- c("eqCnsLETechInpLYSShareOut", "");
    rs["eqCnsLETechInpLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLYS", c("name", "description")] <- c("eqCnsLETechInpLYS", "");
    rs["eqCnsLETechInpLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLYSGrowth", c("name", "description")] <- c("eqCnsLETechInpLYSGrowth", "");
    rs["eqCnsLETechInpLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLYSShareIn", c("name", "description")] <- c("eqCnsGETechInpLYSShareIn", "");
    rs["eqCnsGETechInpLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLYSShareOut", c("name", "description")] <- c("eqCnsGETechInpLYSShareOut", "");
    rs["eqCnsGETechInpLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLYS", c("name", "description")] <- c("eqCnsGETechInpLYS", "");
    rs["eqCnsGETechInpLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLYSGrowth", c("name", "description")] <- c("eqCnsGETechInpLYSGrowth", "");
    rs["eqCnsGETechInpLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLYSShareIn", c("name", "description")] <- c("eqCnsETechInpLYSShareIn", "");
    rs["eqCnsETechInpLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLYSShareOut", c("name", "description")] <- c("eqCnsETechInpLYSShareOut", "");
    rs["eqCnsETechInpLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLYS", c("name", "description")] <- c("eqCnsETechInpLYS", "");
    rs["eqCnsETechInpLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLYSGrowth", c("name", "description")] <- c("eqCnsETechInpLYSGrowth", "");
    rs["eqCnsETechInpLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRShareIn", c("name", "description")] <- c("eqCnsLETechInpLRShareIn", "");
    rs["eqCnsLETechInpLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLRShareOut", c("name", "description")] <- c("eqCnsLETechInpLRShareOut", "");
    rs["eqCnsLETechInpLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLR", c("name", "description")] <- c("eqCnsLETechInpLR", "");
    rs["eqCnsLETechInpLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRShareIn", c("name", "description")] <- c("eqCnsGETechInpLRShareIn", "");
    rs["eqCnsGETechInpLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLRShareOut", c("name", "description")] <- c("eqCnsGETechInpLRShareOut", "");
    rs["eqCnsGETechInpLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLR", c("name", "description")] <- c("eqCnsGETechInpLR", "");
    rs["eqCnsGETechInpLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRShareIn", c("name", "description")] <- c("eqCnsETechInpLRShareIn", "");
    rs["eqCnsETechInpLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLRShareOut", c("name", "description")] <- c("eqCnsETechInpLRShareOut", "");
    rs["eqCnsETechInpLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLR", c("name", "description")] <- c("eqCnsETechInpLR", "");
    rs["eqCnsETechInpLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRSShareIn", c("name", "description")] <- c("eqCnsLETechInpLRSShareIn", "");
    rs["eqCnsLETechInpLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLRSShareOut", c("name", "description")] <- c("eqCnsLETechInpLRSShareOut", "");
    rs["eqCnsLETechInpLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLRS", c("name", "description")] <- c("eqCnsLETechInpLRS", "");
    rs["eqCnsLETechInpLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRSShareIn", c("name", "description")] <- c("eqCnsGETechInpLRSShareIn", "");
    rs["eqCnsGETechInpLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLRSShareOut", c("name", "description")] <- c("eqCnsGETechInpLRSShareOut", "");
    rs["eqCnsGETechInpLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLRS", c("name", "description")] <- c("eqCnsGETechInpLRS", "");
    rs["eqCnsGETechInpLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRSShareIn", c("name", "description")] <- c("eqCnsETechInpLRSShareIn", "");
    rs["eqCnsETechInpLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLRSShareOut", c("name", "description")] <- c("eqCnsETechInpLRSShareOut", "");
    rs["eqCnsETechInpLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLRS", c("name", "description")] <- c("eqCnsETechInpLRS", "");
    rs["eqCnsETechInpLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRYShareIn", c("name", "description")] <- c("eqCnsLETechInpLRYShareIn", "");
    rs["eqCnsLETechInpLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLRYShareOut", c("name", "description")] <- c("eqCnsLETechInpLRYShareOut", "");
    rs["eqCnsLETechInpLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLRY", c("name", "description")] <- c("eqCnsLETechInpLRY", "");
    rs["eqCnsLETechInpLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRYGrowth", c("name", "description")] <- c("eqCnsLETechInpLRYGrowth", "");
    rs["eqCnsLETechInpLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRYShareIn", c("name", "description")] <- c("eqCnsGETechInpLRYShareIn", "");
    rs["eqCnsGETechInpLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLRYShareOut", c("name", "description")] <- c("eqCnsGETechInpLRYShareOut", "");
    rs["eqCnsGETechInpLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLRY", c("name", "description")] <- c("eqCnsGETechInpLRY", "");
    rs["eqCnsGETechInpLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRYGrowth", c("name", "description")] <- c("eqCnsGETechInpLRYGrowth", "");
    rs["eqCnsGETechInpLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRYShareIn", c("name", "description")] <- c("eqCnsETechInpLRYShareIn", "");
    rs["eqCnsETechInpLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLRYShareOut", c("name", "description")] <- c("eqCnsETechInpLRYShareOut", "");
    rs["eqCnsETechInpLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLRY", c("name", "description")] <- c("eqCnsETechInpLRY", "");
    rs["eqCnsETechInpLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRYGrowth", c("name", "description")] <- c("eqCnsETechInpLRYGrowth", "");
    rs["eqCnsETechInpLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRYSShareIn", c("name", "description")] <- c("eqCnsLETechInpLRYSShareIn", "");
    rs["eqCnsLETechInpLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLRYSShareOut", c("name", "description")] <- c("eqCnsLETechInpLRYSShareOut", "");
    rs["eqCnsLETechInpLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLRYS", c("name", "description")] <- c("eqCnsLETechInpLRYS", "");
    rs["eqCnsLETechInpLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLRYSGrowth", c("name", "description")] <- c("eqCnsLETechInpLRYSGrowth", "");
    rs["eqCnsLETechInpLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRYSShareIn", c("name", "description")] <- c("eqCnsGETechInpLRYSShareIn", "");
    rs["eqCnsGETechInpLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLRYSShareOut", c("name", "description")] <- c("eqCnsGETechInpLRYSShareOut", "");
    rs["eqCnsGETechInpLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLRYS", c("name", "description")] <- c("eqCnsGETechInpLRYS", "");
    rs["eqCnsGETechInpLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLRYSGrowth", c("name", "description")] <- c("eqCnsGETechInpLRYSGrowth", "");
    rs["eqCnsGETechInpLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRYSShareIn", c("name", "description")] <- c("eqCnsETechInpLRYSShareIn", "");
    rs["eqCnsETechInpLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLRYSShareOut", c("name", "description")] <- c("eqCnsETechInpLRYSShareOut", "");
    rs["eqCnsETechInpLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLRYS", c("name", "description")] <- c("eqCnsETechInpLRYS", "");
    rs["eqCnsETechInpLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLRYSGrowth", c("name", "description")] <- c("eqCnsETechInpLRYSGrowth", "");
    rs["eqCnsETechInpLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCShareIn", c("name", "description")] <- c("eqCnsLETechInpLCShareIn", "");
    rs["eqCnsLETechInpLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCShareOut", c("name", "description")] <- c("eqCnsLETechInpLCShareOut", "");
    rs["eqCnsLETechInpLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLC", c("name", "description")] <- c("eqCnsLETechInpLC", "");
    rs["eqCnsLETechInpLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCShareIn", c("name", "description")] <- c("eqCnsGETechInpLCShareIn", "");
    rs["eqCnsGETechInpLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCShareOut", c("name", "description")] <- c("eqCnsGETechInpLCShareOut", "");
    rs["eqCnsGETechInpLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLC", c("name", "description")] <- c("eqCnsGETechInpLC", "");
    rs["eqCnsGETechInpLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCShareIn", c("name", "description")] <- c("eqCnsETechInpLCShareIn", "");
    rs["eqCnsETechInpLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCShareOut", c("name", "description")] <- c("eqCnsETechInpLCShareOut", "");
    rs["eqCnsETechInpLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLC", c("name", "description")] <- c("eqCnsETechInpLC", "");
    rs["eqCnsETechInpLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCSShareIn", c("name", "description")] <- c("eqCnsLETechInpLCSShareIn", "");
    rs["eqCnsLETechInpLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCSShareOut", c("name", "description")] <- c("eqCnsLETechInpLCSShareOut", "");
    rs["eqCnsLETechInpLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCS", c("name", "description")] <- c("eqCnsLETechInpLCS", "");
    rs["eqCnsLETechInpLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCSShareIn", c("name", "description")] <- c("eqCnsGETechInpLCSShareIn", "");
    rs["eqCnsGETechInpLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCSShareOut", c("name", "description")] <- c("eqCnsGETechInpLCSShareOut", "");
    rs["eqCnsGETechInpLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCS", c("name", "description")] <- c("eqCnsGETechInpLCS", "");
    rs["eqCnsGETechInpLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCSShareIn", c("name", "description")] <- c("eqCnsETechInpLCSShareIn", "");
    rs["eqCnsETechInpLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCSShareOut", c("name", "description")] <- c("eqCnsETechInpLCSShareOut", "");
    rs["eqCnsETechInpLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCS", c("name", "description")] <- c("eqCnsETechInpLCS", "");
    rs["eqCnsETechInpLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCYShareIn", c("name", "description")] <- c("eqCnsLETechInpLCYShareIn", "");
    rs["eqCnsLETechInpLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCYShareOut", c("name", "description")] <- c("eqCnsLETechInpLCYShareOut", "");
    rs["eqCnsLETechInpLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCY", c("name", "description")] <- c("eqCnsLETechInpLCY", "");
    rs["eqCnsLETechInpLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCYGrowth", c("name", "description")] <- c("eqCnsLETechInpLCYGrowth", "");
    rs["eqCnsLETechInpLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCYShareIn", c("name", "description")] <- c("eqCnsGETechInpLCYShareIn", "");
    rs["eqCnsGETechInpLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCYShareOut", c("name", "description")] <- c("eqCnsGETechInpLCYShareOut", "");
    rs["eqCnsGETechInpLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCY", c("name", "description")] <- c("eqCnsGETechInpLCY", "");
    rs["eqCnsGETechInpLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCYGrowth", c("name", "description")] <- c("eqCnsGETechInpLCYGrowth", "");
    rs["eqCnsGETechInpLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCYShareIn", c("name", "description")] <- c("eqCnsETechInpLCYShareIn", "");
    rs["eqCnsETechInpLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCYShareOut", c("name", "description")] <- c("eqCnsETechInpLCYShareOut", "");
    rs["eqCnsETechInpLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCY", c("name", "description")] <- c("eqCnsETechInpLCY", "");
    rs["eqCnsETechInpLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCYGrowth", c("name", "description")] <- c("eqCnsETechInpLCYGrowth", "");
    rs["eqCnsETechInpLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCYSShareIn", c("name", "description")] <- c("eqCnsLETechInpLCYSShareIn", "");
    rs["eqCnsLETechInpLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCYSShareOut", c("name", "description")] <- c("eqCnsLETechInpLCYSShareOut", "");
    rs["eqCnsLETechInpLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCYS", c("name", "description")] <- c("eqCnsLETechInpLCYS", "");
    rs["eqCnsLETechInpLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCYSGrowth", c("name", "description")] <- c("eqCnsLETechInpLCYSGrowth", "");
    rs["eqCnsLETechInpLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCYSShareIn", c("name", "description")] <- c("eqCnsGETechInpLCYSShareIn", "");
    rs["eqCnsGETechInpLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCYSShareOut", c("name", "description")] <- c("eqCnsGETechInpLCYSShareOut", "");
    rs["eqCnsGETechInpLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCYS", c("name", "description")] <- c("eqCnsGETechInpLCYS", "");
    rs["eqCnsGETechInpLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCYSGrowth", c("name", "description")] <- c("eqCnsGETechInpLCYSGrowth", "");
    rs["eqCnsGETechInpLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCYSShareIn", c("name", "description")] <- c("eqCnsETechInpLCYSShareIn", "");
    rs["eqCnsETechInpLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCYSShareOut", c("name", "description")] <- c("eqCnsETechInpLCYSShareOut", "");
    rs["eqCnsETechInpLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCYS", c("name", "description")] <- c("eqCnsETechInpLCYS", "");
    rs["eqCnsETechInpLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCYSGrowth", c("name", "description")] <- c("eqCnsETechInpLCYSGrowth", "");
    rs["eqCnsETechInpLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRShareIn", c("name", "description")] <- c("eqCnsLETechInpLCRShareIn", "");
    rs["eqCnsLETechInpLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCRShareOut", c("name", "description")] <- c("eqCnsLETechInpLCRShareOut", "");
    rs["eqCnsLETechInpLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCR", c("name", "description")] <- c("eqCnsLETechInpLCR", "");
    rs["eqCnsLETechInpLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRShareIn", c("name", "description")] <- c("eqCnsGETechInpLCRShareIn", "");
    rs["eqCnsGETechInpLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCRShareOut", c("name", "description")] <- c("eqCnsGETechInpLCRShareOut", "");
    rs["eqCnsGETechInpLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCR", c("name", "description")] <- c("eqCnsGETechInpLCR", "");
    rs["eqCnsGETechInpLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRShareIn", c("name", "description")] <- c("eqCnsETechInpLCRShareIn", "");
    rs["eqCnsETechInpLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCRShareOut", c("name", "description")] <- c("eqCnsETechInpLCRShareOut", "");
    rs["eqCnsETechInpLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCR", c("name", "description")] <- c("eqCnsETechInpLCR", "");
    rs["eqCnsETechInpLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRSShareIn", c("name", "description")] <- c("eqCnsLETechInpLCRSShareIn", "");
    rs["eqCnsLETechInpLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCRSShareOut", c("name", "description")] <- c("eqCnsLETechInpLCRSShareOut", "");
    rs["eqCnsLETechInpLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCRS", c("name", "description")] <- c("eqCnsLETechInpLCRS", "");
    rs["eqCnsLETechInpLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRSShareIn", c("name", "description")] <- c("eqCnsGETechInpLCRSShareIn", "");
    rs["eqCnsGETechInpLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCRSShareOut", c("name", "description")] <- c("eqCnsGETechInpLCRSShareOut", "");
    rs["eqCnsGETechInpLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCRS", c("name", "description")] <- c("eqCnsGETechInpLCRS", "");
    rs["eqCnsGETechInpLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRSShareIn", c("name", "description")] <- c("eqCnsETechInpLCRSShareIn", "");
    rs["eqCnsETechInpLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCRSShareOut", c("name", "description")] <- c("eqCnsETechInpLCRSShareOut", "");
    rs["eqCnsETechInpLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCRS", c("name", "description")] <- c("eqCnsETechInpLCRS", "");
    rs["eqCnsETechInpLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRYShareIn", c("name", "description")] <- c("eqCnsLETechInpLCRYShareIn", "");
    rs["eqCnsLETechInpLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCRYShareOut", c("name", "description")] <- c("eqCnsLETechInpLCRYShareOut", "");
    rs["eqCnsLETechInpLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCRY", c("name", "description")] <- c("eqCnsLETechInpLCRY", "");
    rs["eqCnsLETechInpLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRYGrowth", c("name", "description")] <- c("eqCnsLETechInpLCRYGrowth", "");
    rs["eqCnsLETechInpLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRYShareIn", c("name", "description")] <- c("eqCnsGETechInpLCRYShareIn", "");
    rs["eqCnsGETechInpLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCRYShareOut", c("name", "description")] <- c("eqCnsGETechInpLCRYShareOut", "");
    rs["eqCnsGETechInpLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCRY", c("name", "description")] <- c("eqCnsGETechInpLCRY", "");
    rs["eqCnsGETechInpLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRYGrowth", c("name", "description")] <- c("eqCnsGETechInpLCRYGrowth", "");
    rs["eqCnsGETechInpLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRYShareIn", c("name", "description")] <- c("eqCnsETechInpLCRYShareIn", "");
    rs["eqCnsETechInpLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCRYShareOut", c("name", "description")] <- c("eqCnsETechInpLCRYShareOut", "");
    rs["eqCnsETechInpLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCRY", c("name", "description")] <- c("eqCnsETechInpLCRY", "");
    rs["eqCnsETechInpLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRYGrowth", c("name", "description")] <- c("eqCnsETechInpLCRYGrowth", "");
    rs["eqCnsETechInpLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRYSShareIn", c("name", "description")] <- c("eqCnsLETechInpLCRYSShareIn", "");
    rs["eqCnsLETechInpLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsLETechInpLCRYSShareOut", c("name", "description")] <- c("eqCnsLETechInpLCRYSShareOut", "");
    rs["eqCnsLETechInpLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsLETechInpLCRYS", c("name", "description")] <- c("eqCnsLETechInpLCRYS", "");
    rs["eqCnsLETechInpLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechInpLCRYSGrowth", c("name", "description")] <- c("eqCnsLETechInpLCRYSGrowth", "");
    rs["eqCnsLETechInpLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRYSShareIn", c("name", "description")] <- c("eqCnsGETechInpLCRYSShareIn", "");
    rs["eqCnsGETechInpLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsGETechInpLCRYSShareOut", c("name", "description")] <- c("eqCnsGETechInpLCRYSShareOut", "");
    rs["eqCnsGETechInpLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsGETechInpLCRYS", c("name", "description")] <- c("eqCnsGETechInpLCRYS", "");
    rs["eqCnsGETechInpLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsGETechInpLCRYSGrowth", c("name", "description")] <- c("eqCnsGETechInpLCRYSGrowth", "");
    rs["eqCnsGETechInpLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRYSShareIn", c("name", "description")] <- c("eqCnsETechInpLCRYSShareIn", "");
    rs["eqCnsETechInpLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vInpTot")] <- TRUE;
    rs["eqCnsETechInpLCRYSShareOut", c("name", "description")] <- c("eqCnsETechInpLCRYSShareOut", "");
    rs["eqCnsETechInpLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp", "vOutTot")] <- TRUE;
    rs["eqCnsETechInpLCRYS", c("name", "description")] <- c("eqCnsETechInpLCRYS", "");
    rs["eqCnsETechInpLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsETechInpLCRYSGrowth", c("name", "description")] <- c("eqCnsETechInpLCRYSGrowth", "");
    rs["eqCnsETechInpLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechInp", "vTechAInp")] <- TRUE;
    rs["eqCnsLETechOutLShareIn", c("name", "description")] <- c("eqCnsLETechOutLShareIn", "");
    rs["eqCnsLETechOutLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLShareOut", c("name", "description")] <- c("eqCnsLETechOutLShareOut", "");
    rs["eqCnsLETechOutLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutL", c("name", "description")] <- c("eqCnsLETechOutL", "");
    rs["eqCnsLETechOutL", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLShareIn", c("name", "description")] <- c("eqCnsGETechOutLShareIn", "");
    rs["eqCnsGETechOutLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLShareOut", c("name", "description")] <- c("eqCnsGETechOutLShareOut", "");
    rs["eqCnsGETechOutLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutL", c("name", "description")] <- c("eqCnsGETechOutL", "");
    rs["eqCnsGETechOutL", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLShareIn", c("name", "description")] <- c("eqCnsETechOutLShareIn", "");
    rs["eqCnsETechOutLShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLShareOut", c("name", "description")] <- c("eqCnsETechOutLShareOut", "");
    rs["eqCnsETechOutLShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutL", c("name", "description")] <- c("eqCnsETechOutL", "");
    rs["eqCnsETechOutL", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLSShareIn", c("name", "description")] <- c("eqCnsLETechOutLSShareIn", "");
    rs["eqCnsLETechOutLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLSShareOut", c("name", "description")] <- c("eqCnsLETechOutLSShareOut", "");
    rs["eqCnsLETechOutLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLS", c("name", "description")] <- c("eqCnsLETechOutLS", "");
    rs["eqCnsLETechOutLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLSShareIn", c("name", "description")] <- c("eqCnsGETechOutLSShareIn", "");
    rs["eqCnsGETechOutLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLSShareOut", c("name", "description")] <- c("eqCnsGETechOutLSShareOut", "");
    rs["eqCnsGETechOutLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLS", c("name", "description")] <- c("eqCnsGETechOutLS", "");
    rs["eqCnsGETechOutLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLSShareIn", c("name", "description")] <- c("eqCnsETechOutLSShareIn", "");
    rs["eqCnsETechOutLSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLSShareOut", c("name", "description")] <- c("eqCnsETechOutLSShareOut", "");
    rs["eqCnsETechOutLSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLS", c("name", "description")] <- c("eqCnsETechOutLS", "");
    rs["eqCnsETechOutLS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLYShareIn", c("name", "description")] <- c("eqCnsLETechOutLYShareIn", "");
    rs["eqCnsLETechOutLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLYShareOut", c("name", "description")] <- c("eqCnsLETechOutLYShareOut", "");
    rs["eqCnsLETechOutLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLY", c("name", "description")] <- c("eqCnsLETechOutLY", "");
    rs["eqCnsLETechOutLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLYGrowth", c("name", "description")] <- c("eqCnsLETechOutLYGrowth", "");
    rs["eqCnsLETechOutLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLYShareIn", c("name", "description")] <- c("eqCnsGETechOutLYShareIn", "");
    rs["eqCnsGETechOutLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLYShareOut", c("name", "description")] <- c("eqCnsGETechOutLYShareOut", "");
    rs["eqCnsGETechOutLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLY", c("name", "description")] <- c("eqCnsGETechOutLY", "");
    rs["eqCnsGETechOutLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLYGrowth", c("name", "description")] <- c("eqCnsGETechOutLYGrowth", "");
    rs["eqCnsGETechOutLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLYShareIn", c("name", "description")] <- c("eqCnsETechOutLYShareIn", "");
    rs["eqCnsETechOutLYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLYShareOut", c("name", "description")] <- c("eqCnsETechOutLYShareOut", "");
    rs["eqCnsETechOutLYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLY", c("name", "description")] <- c("eqCnsETechOutLY", "");
    rs["eqCnsETechOutLY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLYGrowth", c("name", "description")] <- c("eqCnsETechOutLYGrowth", "");
    rs["eqCnsETechOutLYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLYSShareIn", c("name", "description")] <- c("eqCnsLETechOutLYSShareIn", "");
    rs["eqCnsLETechOutLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLYSShareOut", c("name", "description")] <- c("eqCnsLETechOutLYSShareOut", "");
    rs["eqCnsLETechOutLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLYS", c("name", "description")] <- c("eqCnsLETechOutLYS", "");
    rs["eqCnsLETechOutLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLYSGrowth", c("name", "description")] <- c("eqCnsLETechOutLYSGrowth", "");
    rs["eqCnsLETechOutLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLYSShareIn", c("name", "description")] <- c("eqCnsGETechOutLYSShareIn", "");
    rs["eqCnsGETechOutLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLYSShareOut", c("name", "description")] <- c("eqCnsGETechOutLYSShareOut", "");
    rs["eqCnsGETechOutLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLYS", c("name", "description")] <- c("eqCnsGETechOutLYS", "");
    rs["eqCnsGETechOutLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLYSGrowth", c("name", "description")] <- c("eqCnsGETechOutLYSGrowth", "");
    rs["eqCnsGETechOutLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLYSShareIn", c("name", "description")] <- c("eqCnsETechOutLYSShareIn", "");
    rs["eqCnsETechOutLYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLYSShareOut", c("name", "description")] <- c("eqCnsETechOutLYSShareOut", "");
    rs["eqCnsETechOutLYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLYS", c("name", "description")] <- c("eqCnsETechOutLYS", "");
    rs["eqCnsETechOutLYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLYSGrowth", c("name", "description")] <- c("eqCnsETechOutLYSGrowth", "");
    rs["eqCnsETechOutLYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRShareIn", c("name", "description")] <- c("eqCnsLETechOutLRShareIn", "");
    rs["eqCnsLETechOutLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLRShareOut", c("name", "description")] <- c("eqCnsLETechOutLRShareOut", "");
    rs["eqCnsLETechOutLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLR", c("name", "description")] <- c("eqCnsLETechOutLR", "");
    rs["eqCnsLETechOutLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRShareIn", c("name", "description")] <- c("eqCnsGETechOutLRShareIn", "");
    rs["eqCnsGETechOutLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLRShareOut", c("name", "description")] <- c("eqCnsGETechOutLRShareOut", "");
    rs["eqCnsGETechOutLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLR", c("name", "description")] <- c("eqCnsGETechOutLR", "");
    rs["eqCnsGETechOutLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRShareIn", c("name", "description")] <- c("eqCnsETechOutLRShareIn", "");
    rs["eqCnsETechOutLRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLRShareOut", c("name", "description")] <- c("eqCnsETechOutLRShareOut", "");
    rs["eqCnsETechOutLRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLR", c("name", "description")] <- c("eqCnsETechOutLR", "");
    rs["eqCnsETechOutLR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRSShareIn", c("name", "description")] <- c("eqCnsLETechOutLRSShareIn", "");
    rs["eqCnsLETechOutLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLRSShareOut", c("name", "description")] <- c("eqCnsLETechOutLRSShareOut", "");
    rs["eqCnsLETechOutLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLRS", c("name", "description")] <- c("eqCnsLETechOutLRS", "");
    rs["eqCnsLETechOutLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRSShareIn", c("name", "description")] <- c("eqCnsGETechOutLRSShareIn", "");
    rs["eqCnsGETechOutLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLRSShareOut", c("name", "description")] <- c("eqCnsGETechOutLRSShareOut", "");
    rs["eqCnsGETechOutLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLRS", c("name", "description")] <- c("eqCnsGETechOutLRS", "");
    rs["eqCnsGETechOutLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRSShareIn", c("name", "description")] <- c("eqCnsETechOutLRSShareIn", "");
    rs["eqCnsETechOutLRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLRSShareOut", c("name", "description")] <- c("eqCnsETechOutLRSShareOut", "");
    rs["eqCnsETechOutLRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLRS", c("name", "description")] <- c("eqCnsETechOutLRS", "");
    rs["eqCnsETechOutLRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRYShareIn", c("name", "description")] <- c("eqCnsLETechOutLRYShareIn", "");
    rs["eqCnsLETechOutLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLRYShareOut", c("name", "description")] <- c("eqCnsLETechOutLRYShareOut", "");
    rs["eqCnsLETechOutLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLRY", c("name", "description")] <- c("eqCnsLETechOutLRY", "");
    rs["eqCnsLETechOutLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRYGrowth", c("name", "description")] <- c("eqCnsLETechOutLRYGrowth", "");
    rs["eqCnsLETechOutLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRYShareIn", c("name", "description")] <- c("eqCnsGETechOutLRYShareIn", "");
    rs["eqCnsGETechOutLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLRYShareOut", c("name", "description")] <- c("eqCnsGETechOutLRYShareOut", "");
    rs["eqCnsGETechOutLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLRY", c("name", "description")] <- c("eqCnsGETechOutLRY", "");
    rs["eqCnsGETechOutLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRYGrowth", c("name", "description")] <- c("eqCnsGETechOutLRYGrowth", "");
    rs["eqCnsGETechOutLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRYShareIn", c("name", "description")] <- c("eqCnsETechOutLRYShareIn", "");
    rs["eqCnsETechOutLRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLRYShareOut", c("name", "description")] <- c("eqCnsETechOutLRYShareOut", "");
    rs["eqCnsETechOutLRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLRY", c("name", "description")] <- c("eqCnsETechOutLRY", "");
    rs["eqCnsETechOutLRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRYGrowth", c("name", "description")] <- c("eqCnsETechOutLRYGrowth", "");
    rs["eqCnsETechOutLRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRYSShareIn", c("name", "description")] <- c("eqCnsLETechOutLRYSShareIn", "");
    rs["eqCnsLETechOutLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLRYSShareOut", c("name", "description")] <- c("eqCnsLETechOutLRYSShareOut", "");
    rs["eqCnsLETechOutLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLRYS", c("name", "description")] <- c("eqCnsLETechOutLRYS", "");
    rs["eqCnsLETechOutLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLRYSGrowth", c("name", "description")] <- c("eqCnsLETechOutLRYSGrowth", "");
    rs["eqCnsLETechOutLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRYSShareIn", c("name", "description")] <- c("eqCnsGETechOutLRYSShareIn", "");
    rs["eqCnsGETechOutLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLRYSShareOut", c("name", "description")] <- c("eqCnsGETechOutLRYSShareOut", "");
    rs["eqCnsGETechOutLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLRYS", c("name", "description")] <- c("eqCnsGETechOutLRYS", "");
    rs["eqCnsGETechOutLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLRYSGrowth", c("name", "description")] <- c("eqCnsGETechOutLRYSGrowth", "");
    rs["eqCnsGETechOutLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRYSShareIn", c("name", "description")] <- c("eqCnsETechOutLRYSShareIn", "");
    rs["eqCnsETechOutLRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLRYSShareOut", c("name", "description")] <- c("eqCnsETechOutLRYSShareOut", "");
    rs["eqCnsETechOutLRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLRYS", c("name", "description")] <- c("eqCnsETechOutLRYS", "");
    rs["eqCnsETechOutLRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLRYSGrowth", c("name", "description")] <- c("eqCnsETechOutLRYSGrowth", "");
    rs["eqCnsETechOutLRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCShareIn", c("name", "description")] <- c("eqCnsLETechOutLCShareIn", "");
    rs["eqCnsLETechOutLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCShareOut", c("name", "description")] <- c("eqCnsLETechOutLCShareOut", "");
    rs["eqCnsLETechOutLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLC", c("name", "description")] <- c("eqCnsLETechOutLC", "");
    rs["eqCnsLETechOutLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCShareIn", c("name", "description")] <- c("eqCnsGETechOutLCShareIn", "");
    rs["eqCnsGETechOutLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCShareOut", c("name", "description")] <- c("eqCnsGETechOutLCShareOut", "");
    rs["eqCnsGETechOutLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLC", c("name", "description")] <- c("eqCnsGETechOutLC", "");
    rs["eqCnsGETechOutLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCShareIn", c("name", "description")] <- c("eqCnsETechOutLCShareIn", "");
    rs["eqCnsETechOutLCShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCShareOut", c("name", "description")] <- c("eqCnsETechOutLCShareOut", "");
    rs["eqCnsETechOutLCShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLC", c("name", "description")] <- c("eqCnsETechOutLC", "");
    rs["eqCnsETechOutLC", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCSShareIn", c("name", "description")] <- c("eqCnsLETechOutLCSShareIn", "");
    rs["eqCnsLETechOutLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCSShareOut", c("name", "description")] <- c("eqCnsLETechOutLCSShareOut", "");
    rs["eqCnsLETechOutLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCS", c("name", "description")] <- c("eqCnsLETechOutLCS", "");
    rs["eqCnsLETechOutLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCSShareIn", c("name", "description")] <- c("eqCnsGETechOutLCSShareIn", "");
    rs["eqCnsGETechOutLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCSShareOut", c("name", "description")] <- c("eqCnsGETechOutLCSShareOut", "");
    rs["eqCnsGETechOutLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCS", c("name", "description")] <- c("eqCnsGETechOutLCS", "");
    rs["eqCnsGETechOutLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCSShareIn", c("name", "description")] <- c("eqCnsETechOutLCSShareIn", "");
    rs["eqCnsETechOutLCSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCSShareOut", c("name", "description")] <- c("eqCnsETechOutLCSShareOut", "");
    rs["eqCnsETechOutLCSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCS", c("name", "description")] <- c("eqCnsETechOutLCS", "");
    rs["eqCnsETechOutLCS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCYShareIn", c("name", "description")] <- c("eqCnsLETechOutLCYShareIn", "");
    rs["eqCnsLETechOutLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCYShareOut", c("name", "description")] <- c("eqCnsLETechOutLCYShareOut", "");
    rs["eqCnsLETechOutLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCY", c("name", "description")] <- c("eqCnsLETechOutLCY", "");
    rs["eqCnsLETechOutLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCYGrowth", c("name", "description")] <- c("eqCnsLETechOutLCYGrowth", "");
    rs["eqCnsLETechOutLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCYShareIn", c("name", "description")] <- c("eqCnsGETechOutLCYShareIn", "");
    rs["eqCnsGETechOutLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCYShareOut", c("name", "description")] <- c("eqCnsGETechOutLCYShareOut", "");
    rs["eqCnsGETechOutLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCY", c("name", "description")] <- c("eqCnsGETechOutLCY", "");
    rs["eqCnsGETechOutLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCYGrowth", c("name", "description")] <- c("eqCnsGETechOutLCYGrowth", "");
    rs["eqCnsGETechOutLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCYShareIn", c("name", "description")] <- c("eqCnsETechOutLCYShareIn", "");
    rs["eqCnsETechOutLCYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCYShareOut", c("name", "description")] <- c("eqCnsETechOutLCYShareOut", "");
    rs["eqCnsETechOutLCYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCY", c("name", "description")] <- c("eqCnsETechOutLCY", "");
    rs["eqCnsETechOutLCY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCYGrowth", c("name", "description")] <- c("eqCnsETechOutLCYGrowth", "");
    rs["eqCnsETechOutLCYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCYSShareIn", c("name", "description")] <- c("eqCnsLETechOutLCYSShareIn", "");
    rs["eqCnsLETechOutLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCYSShareOut", c("name", "description")] <- c("eqCnsLETechOutLCYSShareOut", "");
    rs["eqCnsLETechOutLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCYS", c("name", "description")] <- c("eqCnsLETechOutLCYS", "");
    rs["eqCnsLETechOutLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCYSGrowth", c("name", "description")] <- c("eqCnsLETechOutLCYSGrowth", "");
    rs["eqCnsLETechOutLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCYSShareIn", c("name", "description")] <- c("eqCnsGETechOutLCYSShareIn", "");
    rs["eqCnsGETechOutLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCYSShareOut", c("name", "description")] <- c("eqCnsGETechOutLCYSShareOut", "");
    rs["eqCnsGETechOutLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCYS", c("name", "description")] <- c("eqCnsGETechOutLCYS", "");
    rs["eqCnsGETechOutLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCYSGrowth", c("name", "description")] <- c("eqCnsGETechOutLCYSGrowth", "");
    rs["eqCnsGETechOutLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCYSShareIn", c("name", "description")] <- c("eqCnsETechOutLCYSShareIn", "");
    rs["eqCnsETechOutLCYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCYSShareOut", c("name", "description")] <- c("eqCnsETechOutLCYSShareOut", "");
    rs["eqCnsETechOutLCYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCYS", c("name", "description")] <- c("eqCnsETechOutLCYS", "");
    rs["eqCnsETechOutLCYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCYSGrowth", c("name", "description")] <- c("eqCnsETechOutLCYSGrowth", "");
    rs["eqCnsETechOutLCYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRShareIn", c("name", "description")] <- c("eqCnsLETechOutLCRShareIn", "");
    rs["eqCnsLETechOutLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCRShareOut", c("name", "description")] <- c("eqCnsLETechOutLCRShareOut", "");
    rs["eqCnsLETechOutLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCR", c("name", "description")] <- c("eqCnsLETechOutLCR", "");
    rs["eqCnsLETechOutLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRShareIn", c("name", "description")] <- c("eqCnsGETechOutLCRShareIn", "");
    rs["eqCnsGETechOutLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCRShareOut", c("name", "description")] <- c("eqCnsGETechOutLCRShareOut", "");
    rs["eqCnsGETechOutLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCR", c("name", "description")] <- c("eqCnsGETechOutLCR", "");
    rs["eqCnsGETechOutLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRShareIn", c("name", "description")] <- c("eqCnsETechOutLCRShareIn", "");
    rs["eqCnsETechOutLCRShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCRShareOut", c("name", "description")] <- c("eqCnsETechOutLCRShareOut", "");
    rs["eqCnsETechOutLCRShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCR", c("name", "description")] <- c("eqCnsETechOutLCR", "");
    rs["eqCnsETechOutLCR", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRSShareIn", c("name", "description")] <- c("eqCnsLETechOutLCRSShareIn", "");
    rs["eqCnsLETechOutLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCRSShareOut", c("name", "description")] <- c("eqCnsLETechOutLCRSShareOut", "");
    rs["eqCnsLETechOutLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCRS", c("name", "description")] <- c("eqCnsLETechOutLCRS", "");
    rs["eqCnsLETechOutLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRSShareIn", c("name", "description")] <- c("eqCnsGETechOutLCRSShareIn", "");
    rs["eqCnsGETechOutLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCRSShareOut", c("name", "description")] <- c("eqCnsGETechOutLCRSShareOut", "");
    rs["eqCnsGETechOutLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCRS", c("name", "description")] <- c("eqCnsGETechOutLCRS", "");
    rs["eqCnsGETechOutLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRSShareIn", c("name", "description")] <- c("eqCnsETechOutLCRSShareIn", "");
    rs["eqCnsETechOutLCRSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCRSShareOut", c("name", "description")] <- c("eqCnsETechOutLCRSShareOut", "");
    rs["eqCnsETechOutLCRSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCRS", c("name", "description")] <- c("eqCnsETechOutLCRS", "");
    rs["eqCnsETechOutLCRS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRYShareIn", c("name", "description")] <- c("eqCnsLETechOutLCRYShareIn", "");
    rs["eqCnsLETechOutLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCRYShareOut", c("name", "description")] <- c("eqCnsLETechOutLCRYShareOut", "");
    rs["eqCnsLETechOutLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCRY", c("name", "description")] <- c("eqCnsLETechOutLCRY", "");
    rs["eqCnsLETechOutLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRYGrowth", c("name", "description")] <- c("eqCnsLETechOutLCRYGrowth", "");
    rs["eqCnsLETechOutLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRYShareIn", c("name", "description")] <- c("eqCnsGETechOutLCRYShareIn", "");
    rs["eqCnsGETechOutLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCRYShareOut", c("name", "description")] <- c("eqCnsGETechOutLCRYShareOut", "");
    rs["eqCnsGETechOutLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCRY", c("name", "description")] <- c("eqCnsGETechOutLCRY", "");
    rs["eqCnsGETechOutLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRYGrowth", c("name", "description")] <- c("eqCnsGETechOutLCRYGrowth", "");
    rs["eqCnsGETechOutLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRYShareIn", c("name", "description")] <- c("eqCnsETechOutLCRYShareIn", "");
    rs["eqCnsETechOutLCRYShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCRYShareOut", c("name", "description")] <- c("eqCnsETechOutLCRYShareOut", "");
    rs["eqCnsETechOutLCRYShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCRY", c("name", "description")] <- c("eqCnsETechOutLCRY", "");
    rs["eqCnsETechOutLCRY", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRYGrowth", c("name", "description")] <- c("eqCnsETechOutLCRYGrowth", "");
    rs["eqCnsETechOutLCRYGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRYSShareIn", c("name", "description")] <- c("eqCnsLETechOutLCRYSShareIn", "");
    rs["eqCnsLETechOutLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsLETechOutLCRYSShareOut", c("name", "description")] <- c("eqCnsLETechOutLCRYSShareOut", "");
    rs["eqCnsLETechOutLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsLETechOutLCRYS", c("name", "description")] <- c("eqCnsLETechOutLCRYS", "");
    rs["eqCnsLETechOutLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechOutLCRYSGrowth", c("name", "description")] <- c("eqCnsLETechOutLCRYSGrowth", "");
    rs["eqCnsLETechOutLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRYSShareIn", c("name", "description")] <- c("eqCnsGETechOutLCRYSShareIn", "");
    rs["eqCnsGETechOutLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsGETechOutLCRYSShareOut", c("name", "description")] <- c("eqCnsGETechOutLCRYSShareOut", "");
    rs["eqCnsGETechOutLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsGETechOutLCRYS", c("name", "description")] <- c("eqCnsGETechOutLCRYS", "");
    rs["eqCnsGETechOutLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsGETechOutLCRYSGrowth", c("name", "description")] <- c("eqCnsGETechOutLCRYSGrowth", "");
    rs["eqCnsGETechOutLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRYSShareIn", c("name", "description")] <- c("eqCnsETechOutLCRYSShareIn", "");
    rs["eqCnsETechOutLCRYSShareIn", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vInpTot")] <- TRUE;
    rs["eqCnsETechOutLCRYSShareOut", c("name", "description")] <- c("eqCnsETechOutLCRYSShareOut", "");
    rs["eqCnsETechOutLCRYSShareOut", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut", "vOutTot")] <- TRUE;
    rs["eqCnsETechOutLCRYS", c("name", "description")] <- c("eqCnsETechOutLCRYS", "");
    rs["eqCnsETechOutLCRYS", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsETechOutLCRYSGrowth", c("name", "description")] <- c("eqCnsETechOutLCRYSGrowth", "");
    rs["eqCnsETechOutLCRYSGrowth", c("tech", "comm", "region", "year", "slice", "cns", "vTechEmsFuel", "vTechOut", "vTechAOut")] <- TRUE;
    rs["eqCnsLETechCapL", c("name", "description")] <- c("eqCnsLETechCapL", "");
    rs["eqCnsLETechCapL", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapL", c("name", "description")] <- c("eqCnsGETechCapL", "");
    rs["eqCnsGETechCapL", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapL", c("name", "description")] <- c("eqCnsETechCapL", "");
    rs["eqCnsETechCapL", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapLY", c("name", "description")] <- c("eqCnsLETechCapLY", "");
    rs["eqCnsLETechCapLY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapLYGrowth", c("name", "description")] <- c("eqCnsLETechCapLYGrowth", "");
    rs["eqCnsLETechCapLYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapLY", c("name", "description")] <- c("eqCnsGETechCapLY", "");
    rs["eqCnsGETechCapLY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapLYGrowth", c("name", "description")] <- c("eqCnsGETechCapLYGrowth", "");
    rs["eqCnsGETechCapLYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapLY", c("name", "description")] <- c("eqCnsETechCapLY", "");
    rs["eqCnsETechCapLY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapLYGrowth", c("name", "description")] <- c("eqCnsETechCapLYGrowth", "");
    rs["eqCnsETechCapLYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapLR", c("name", "description")] <- c("eqCnsLETechCapLR", "");
    rs["eqCnsLETechCapLR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapLR", c("name", "description")] <- c("eqCnsGETechCapLR", "");
    rs["eqCnsGETechCapLR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapLR", c("name", "description")] <- c("eqCnsETechCapLR", "");
    rs["eqCnsETechCapLR", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapLRY", c("name", "description")] <- c("eqCnsLETechCapLRY", "");
    rs["eqCnsLETechCapLRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechCapLRYGrowth", c("name", "description")] <- c("eqCnsLETechCapLRYGrowth", "");
    rs["eqCnsLETechCapLRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapLRY", c("name", "description")] <- c("eqCnsGETechCapLRY", "");
    rs["eqCnsGETechCapLRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsGETechCapLRYGrowth", c("name", "description")] <- c("eqCnsGETechCapLRYGrowth", "");
    rs["eqCnsGETechCapLRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapLRY", c("name", "description")] <- c("eqCnsETechCapLRY", "");
    rs["eqCnsETechCapLRY", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsETechCapLRYGrowth", c("name", "description")] <- c("eqCnsETechCapLRYGrowth", "");
    rs["eqCnsETechCapLRYGrowth", c("tech", "region", "year", "cns", "vTechCap")] <- TRUE;
    rs["eqCnsLETechNewCapL", c("name", "description")] <- c("eqCnsLETechNewCapL", "");
    rs["eqCnsLETechNewCapL", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapL", c("name", "description")] <- c("eqCnsGETechNewCapL", "");
    rs["eqCnsGETechNewCapL", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapL", c("name", "description")] <- c("eqCnsETechNewCapL", "");
    rs["eqCnsETechNewCapL", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapLY", c("name", "description")] <- c("eqCnsLETechNewCapLY", "");
    rs["eqCnsLETechNewCapLY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapLYGrowth", c("name", "description")] <- c("eqCnsLETechNewCapLYGrowth", "");
    rs["eqCnsLETechNewCapLYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapLY", c("name", "description")] <- c("eqCnsGETechNewCapLY", "");
    rs["eqCnsGETechNewCapLY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapLYGrowth", c("name", "description")] <- c("eqCnsGETechNewCapLYGrowth", "");
    rs["eqCnsGETechNewCapLYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapLY", c("name", "description")] <- c("eqCnsETechNewCapLY", "");
    rs["eqCnsETechNewCapLY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapLYGrowth", c("name", "description")] <- c("eqCnsETechNewCapLYGrowth", "");
    rs["eqCnsETechNewCapLYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapLR", c("name", "description")] <- c("eqCnsLETechNewCapLR", "");
    rs["eqCnsLETechNewCapLR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapLR", c("name", "description")] <- c("eqCnsGETechNewCapLR", "");
    rs["eqCnsGETechNewCapLR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapLR", c("name", "description")] <- c("eqCnsETechNewCapLR", "");
    rs["eqCnsETechNewCapLR", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapLRY", c("name", "description")] <- c("eqCnsLETechNewCapLRY", "");
    rs["eqCnsLETechNewCapLRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechNewCapLRYGrowth", c("name", "description")] <- c("eqCnsLETechNewCapLRYGrowth", "");
    rs["eqCnsLETechNewCapLRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapLRY", c("name", "description")] <- c("eqCnsGETechNewCapLRY", "");
    rs["eqCnsGETechNewCapLRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsGETechNewCapLRYGrowth", c("name", "description")] <- c("eqCnsGETechNewCapLRYGrowth", "");
    rs["eqCnsGETechNewCapLRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapLRY", c("name", "description")] <- c("eqCnsETechNewCapLRY", "");
    rs["eqCnsETechNewCapLRY", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsETechNewCapLRYGrowth", c("name", "description")] <- c("eqCnsETechNewCapLRYGrowth", "");
    rs["eqCnsETechNewCapLRYGrowth", c("tech", "region", "year", "cns", "vTechNewCap")] <- TRUE;
    rs["eqCnsLETechInvL", c("name", "description")] <- c("eqCnsLETechInvL", "");
    rs["eqCnsLETechInvL", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvL", c("name", "description")] <- c("eqCnsGETechInvL", "");
    rs["eqCnsGETechInvL", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvL", c("name", "description")] <- c("eqCnsETechInvL", "");
    rs["eqCnsETechInvL", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvLY", c("name", "description")] <- c("eqCnsLETechInvLY", "");
    rs["eqCnsLETechInvLY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvLYGrowth", c("name", "description")] <- c("eqCnsLETechInvLYGrowth", "");
    rs["eqCnsLETechInvLYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvLY", c("name", "description")] <- c("eqCnsGETechInvLY", "");
    rs["eqCnsGETechInvLY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvLYGrowth", c("name", "description")] <- c("eqCnsGETechInvLYGrowth", "");
    rs["eqCnsGETechInvLYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvLY", c("name", "description")] <- c("eqCnsETechInvLY", "");
    rs["eqCnsETechInvLY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvLYGrowth", c("name", "description")] <- c("eqCnsETechInvLYGrowth", "");
    rs["eqCnsETechInvLYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvLR", c("name", "description")] <- c("eqCnsLETechInvLR", "");
    rs["eqCnsLETechInvLR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvLR", c("name", "description")] <- c("eqCnsGETechInvLR", "");
    rs["eqCnsGETechInvLR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvLR", c("name", "description")] <- c("eqCnsETechInvLR", "");
    rs["eqCnsETechInvLR", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvLRY", c("name", "description")] <- c("eqCnsLETechInvLRY", "");
    rs["eqCnsLETechInvLRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechInvLRYGrowth", c("name", "description")] <- c("eqCnsLETechInvLRYGrowth", "");
    rs["eqCnsLETechInvLRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvLRY", c("name", "description")] <- c("eqCnsGETechInvLRY", "");
    rs["eqCnsGETechInvLRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsGETechInvLRYGrowth", c("name", "description")] <- c("eqCnsGETechInvLRYGrowth", "");
    rs["eqCnsGETechInvLRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvLRY", c("name", "description")] <- c("eqCnsETechInvLRY", "");
    rs["eqCnsETechInvLRY", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsETechInvLRYGrowth", c("name", "description")] <- c("eqCnsETechInvLRYGrowth", "");
    rs["eqCnsETechInvLRYGrowth", c("tech", "region", "year", "cns", "vTechInv")] <- TRUE;
    rs["eqCnsLETechEacL", c("name", "description")] <- c("eqCnsLETechEacL", "");
    rs["eqCnsLETechEacL", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacL", c("name", "description")] <- c("eqCnsGETechEacL", "");
    rs["eqCnsGETechEacL", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacL", c("name", "description")] <- c("eqCnsETechEacL", "");
    rs["eqCnsETechEacL", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacLY", c("name", "description")] <- c("eqCnsLETechEacLY", "");
    rs["eqCnsLETechEacLY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacLYGrowth", c("name", "description")] <- c("eqCnsLETechEacLYGrowth", "");
    rs["eqCnsLETechEacLYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacLY", c("name", "description")] <- c("eqCnsGETechEacLY", "");
    rs["eqCnsGETechEacLY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacLYGrowth", c("name", "description")] <- c("eqCnsGETechEacLYGrowth", "");
    rs["eqCnsGETechEacLYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacLY", c("name", "description")] <- c("eqCnsETechEacLY", "");
    rs["eqCnsETechEacLY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacLYGrowth", c("name", "description")] <- c("eqCnsETechEacLYGrowth", "");
    rs["eqCnsETechEacLYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacLR", c("name", "description")] <- c("eqCnsLETechEacLR", "");
    rs["eqCnsLETechEacLR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacLR", c("name", "description")] <- c("eqCnsGETechEacLR", "");
    rs["eqCnsGETechEacLR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacLR", c("name", "description")] <- c("eqCnsETechEacLR", "");
    rs["eqCnsETechEacLR", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacLRY", c("name", "description")] <- c("eqCnsLETechEacLRY", "");
    rs["eqCnsLETechEacLRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechEacLRYGrowth", c("name", "description")] <- c("eqCnsLETechEacLRYGrowth", "");
    rs["eqCnsLETechEacLRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacLRY", c("name", "description")] <- c("eqCnsGETechEacLRY", "");
    rs["eqCnsGETechEacLRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsGETechEacLRYGrowth", c("name", "description")] <- c("eqCnsGETechEacLRYGrowth", "");
    rs["eqCnsGETechEacLRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacLRY", c("name", "description")] <- c("eqCnsETechEacLRY", "");
    rs["eqCnsETechEacLRY", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsETechEacLRYGrowth", c("name", "description")] <- c("eqCnsETechEacLRYGrowth", "");
    rs["eqCnsETechEacLRYGrowth", c("tech", "region", "year", "cns", "vTechEac")] <- TRUE;
    rs["eqCnsLETechActL", c("name", "description")] <- c("eqCnsLETechActL", "");
    rs["eqCnsLETechActL", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActL", c("name", "description")] <- c("eqCnsGETechActL", "");
    rs["eqCnsGETechActL", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActL", c("name", "description")] <- c("eqCnsETechActL", "");
    rs["eqCnsETechActL", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLS", c("name", "description")] <- c("eqCnsLETechActLS", "");
    rs["eqCnsLETechActLS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLS", c("name", "description")] <- c("eqCnsGETechActLS", "");
    rs["eqCnsGETechActLS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLS", c("name", "description")] <- c("eqCnsETechActLS", "");
    rs["eqCnsETechActLS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLY", c("name", "description")] <- c("eqCnsLETechActLY", "");
    rs["eqCnsLETechActLY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLYGrowth", c("name", "description")] <- c("eqCnsLETechActLYGrowth", "");
    rs["eqCnsLETechActLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLY", c("name", "description")] <- c("eqCnsGETechActLY", "");
    rs["eqCnsGETechActLY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLYGrowth", c("name", "description")] <- c("eqCnsGETechActLYGrowth", "");
    rs["eqCnsGETechActLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLY", c("name", "description")] <- c("eqCnsETechActLY", "");
    rs["eqCnsETechActLY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLYGrowth", c("name", "description")] <- c("eqCnsETechActLYGrowth", "");
    rs["eqCnsETechActLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLYS", c("name", "description")] <- c("eqCnsLETechActLYS", "");
    rs["eqCnsLETechActLYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLYSGrowth", c("name", "description")] <- c("eqCnsLETechActLYSGrowth", "");
    rs["eqCnsLETechActLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLYS", c("name", "description")] <- c("eqCnsGETechActLYS", "");
    rs["eqCnsGETechActLYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLYSGrowth", c("name", "description")] <- c("eqCnsGETechActLYSGrowth", "");
    rs["eqCnsGETechActLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLYS", c("name", "description")] <- c("eqCnsETechActLYS", "");
    rs["eqCnsETechActLYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLYSGrowth", c("name", "description")] <- c("eqCnsETechActLYSGrowth", "");
    rs["eqCnsETechActLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLR", c("name", "description")] <- c("eqCnsLETechActLR", "");
    rs["eqCnsLETechActLR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLR", c("name", "description")] <- c("eqCnsGETechActLR", "");
    rs["eqCnsGETechActLR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLR", c("name", "description")] <- c("eqCnsETechActLR", "");
    rs["eqCnsETechActLR", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLRS", c("name", "description")] <- c("eqCnsLETechActLRS", "");
    rs["eqCnsLETechActLRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLRS", c("name", "description")] <- c("eqCnsGETechActLRS", "");
    rs["eqCnsGETechActLRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLRS", c("name", "description")] <- c("eqCnsETechActLRS", "");
    rs["eqCnsETechActLRS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLRY", c("name", "description")] <- c("eqCnsLETechActLRY", "");
    rs["eqCnsLETechActLRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLRYGrowth", c("name", "description")] <- c("eqCnsLETechActLRYGrowth", "");
    rs["eqCnsLETechActLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLRY", c("name", "description")] <- c("eqCnsGETechActLRY", "");
    rs["eqCnsGETechActLRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLRYGrowth", c("name", "description")] <- c("eqCnsGETechActLRYGrowth", "");
    rs["eqCnsGETechActLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLRY", c("name", "description")] <- c("eqCnsETechActLRY", "");
    rs["eqCnsETechActLRY", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLRYGrowth", c("name", "description")] <- c("eqCnsETechActLRYGrowth", "");
    rs["eqCnsETechActLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLRYS", c("name", "description")] <- c("eqCnsLETechActLRYS", "");
    rs["eqCnsLETechActLRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechActLRYSGrowth", c("name", "description")] <- c("eqCnsLETechActLRYSGrowth", "");
    rs["eqCnsLETechActLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLRYS", c("name", "description")] <- c("eqCnsGETechActLRYS", "");
    rs["eqCnsGETechActLRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsGETechActLRYSGrowth", c("name", "description")] <- c("eqCnsGETechActLRYSGrowth", "");
    rs["eqCnsGETechActLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLRYS", c("name", "description")] <- c("eqCnsETechActLRYS", "");
    rs["eqCnsETechActLRYS", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsETechActLRYSGrowth", c("name", "description")] <- c("eqCnsETechActLRYSGrowth", "");
    rs["eqCnsETechActLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAct")] <- TRUE;
    rs["eqCnsLETechVaromL", c("name", "description")] <- c("eqCnsLETechVaromL", "");
    rs["eqCnsLETechVaromL", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromL", c("name", "description")] <- c("eqCnsGETechVaromL", "");
    rs["eqCnsGETechVaromL", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromL", c("name", "description")] <- c("eqCnsETechVaromL", "");
    rs["eqCnsETechVaromL", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLS", c("name", "description")] <- c("eqCnsLETechVaromLS", "");
    rs["eqCnsLETechVaromLS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLS", c("name", "description")] <- c("eqCnsGETechVaromLS", "");
    rs["eqCnsGETechVaromLS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLS", c("name", "description")] <- c("eqCnsETechVaromLS", "");
    rs["eqCnsETechVaromLS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLY", c("name", "description")] <- c("eqCnsLETechVaromLY", "");
    rs["eqCnsLETechVaromLY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLYGrowth", c("name", "description")] <- c("eqCnsLETechVaromLYGrowth", "");
    rs["eqCnsLETechVaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLY", c("name", "description")] <- c("eqCnsGETechVaromLY", "");
    rs["eqCnsGETechVaromLY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLYGrowth", c("name", "description")] <- c("eqCnsGETechVaromLYGrowth", "");
    rs["eqCnsGETechVaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLY", c("name", "description")] <- c("eqCnsETechVaromLY", "");
    rs["eqCnsETechVaromLY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLYGrowth", c("name", "description")] <- c("eqCnsETechVaromLYGrowth", "");
    rs["eqCnsETechVaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLYS", c("name", "description")] <- c("eqCnsLETechVaromLYS", "");
    rs["eqCnsLETechVaromLYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLYSGrowth", c("name", "description")] <- c("eqCnsLETechVaromLYSGrowth", "");
    rs["eqCnsLETechVaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLYS", c("name", "description")] <- c("eqCnsGETechVaromLYS", "");
    rs["eqCnsGETechVaromLYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLYSGrowth", c("name", "description")] <- c("eqCnsGETechVaromLYSGrowth", "");
    rs["eqCnsGETechVaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLYS", c("name", "description")] <- c("eqCnsETechVaromLYS", "");
    rs["eqCnsETechVaromLYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLYSGrowth", c("name", "description")] <- c("eqCnsETechVaromLYSGrowth", "");
    rs["eqCnsETechVaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLR", c("name", "description")] <- c("eqCnsLETechVaromLR", "");
    rs["eqCnsLETechVaromLR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLR", c("name", "description")] <- c("eqCnsGETechVaromLR", "");
    rs["eqCnsGETechVaromLR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLR", c("name", "description")] <- c("eqCnsETechVaromLR", "");
    rs["eqCnsETechVaromLR", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLRS", c("name", "description")] <- c("eqCnsLETechVaromLRS", "");
    rs["eqCnsLETechVaromLRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLRS", c("name", "description")] <- c("eqCnsGETechVaromLRS", "");
    rs["eqCnsGETechVaromLRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLRS", c("name", "description")] <- c("eqCnsETechVaromLRS", "");
    rs["eqCnsETechVaromLRS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLRY", c("name", "description")] <- c("eqCnsLETechVaromLRY", "");
    rs["eqCnsLETechVaromLRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLRYGrowth", c("name", "description")] <- c("eqCnsLETechVaromLRYGrowth", "");
    rs["eqCnsLETechVaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLRY", c("name", "description")] <- c("eqCnsGETechVaromLRY", "");
    rs["eqCnsGETechVaromLRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLRYGrowth", c("name", "description")] <- c("eqCnsGETechVaromLRYGrowth", "");
    rs["eqCnsGETechVaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLRY", c("name", "description")] <- c("eqCnsETechVaromLRY", "");
    rs["eqCnsETechVaromLRY", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLRYGrowth", c("name", "description")] <- c("eqCnsETechVaromLRYGrowth", "");
    rs["eqCnsETechVaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLRYS", c("name", "description")] <- c("eqCnsLETechVaromLRYS", "");
    rs["eqCnsLETechVaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechVaromLRYSGrowth", c("name", "description")] <- c("eqCnsLETechVaromLRYSGrowth", "");
    rs["eqCnsLETechVaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLRYS", c("name", "description")] <- c("eqCnsGETechVaromLRYS", "");
    rs["eqCnsGETechVaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsGETechVaromLRYSGrowth", c("name", "description")] <- c("eqCnsGETechVaromLRYSGrowth", "");
    rs["eqCnsGETechVaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLRYS", c("name", "description")] <- c("eqCnsETechVaromLRYS", "");
    rs["eqCnsETechVaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsETechVaromLRYSGrowth", c("name", "description")] <- c("eqCnsETechVaromLRYSGrowth", "");
    rs["eqCnsETechVaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechVarom")] <- TRUE;
    rs["eqCnsLETechFixomL", c("name", "description")] <- c("eqCnsLETechFixomL", "");
    rs["eqCnsLETechFixomL", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomL", c("name", "description")] <- c("eqCnsGETechFixomL", "");
    rs["eqCnsGETechFixomL", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomL", c("name", "description")] <- c("eqCnsETechFixomL", "");
    rs["eqCnsETechFixomL", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomLY", c("name", "description")] <- c("eqCnsLETechFixomLY", "");
    rs["eqCnsLETechFixomLY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomLYGrowth", c("name", "description")] <- c("eqCnsLETechFixomLYGrowth", "");
    rs["eqCnsLETechFixomLYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomLY", c("name", "description")] <- c("eqCnsGETechFixomLY", "");
    rs["eqCnsGETechFixomLY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomLYGrowth", c("name", "description")] <- c("eqCnsGETechFixomLYGrowth", "");
    rs["eqCnsGETechFixomLYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomLY", c("name", "description")] <- c("eqCnsETechFixomLY", "");
    rs["eqCnsETechFixomLY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomLYGrowth", c("name", "description")] <- c("eqCnsETechFixomLYGrowth", "");
    rs["eqCnsETechFixomLYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomLR", c("name", "description")] <- c("eqCnsLETechFixomLR", "");
    rs["eqCnsLETechFixomLR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomLR", c("name", "description")] <- c("eqCnsGETechFixomLR", "");
    rs["eqCnsGETechFixomLR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomLR", c("name", "description")] <- c("eqCnsETechFixomLR", "");
    rs["eqCnsETechFixomLR", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomLRY", c("name", "description")] <- c("eqCnsLETechFixomLRY", "");
    rs["eqCnsLETechFixomLRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechFixomLRYGrowth", c("name", "description")] <- c("eqCnsLETechFixomLRYGrowth", "");
    rs["eqCnsLETechFixomLRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomLRY", c("name", "description")] <- c("eqCnsGETechFixomLRY", "");
    rs["eqCnsGETechFixomLRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsGETechFixomLRYGrowth", c("name", "description")] <- c("eqCnsGETechFixomLRYGrowth", "");
    rs["eqCnsGETechFixomLRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomLRY", c("name", "description")] <- c("eqCnsETechFixomLRY", "");
    rs["eqCnsETechFixomLRY", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsETechFixomLRYGrowth", c("name", "description")] <- c("eqCnsETechFixomLRYGrowth", "");
    rs["eqCnsETechFixomLRYGrowth", c("tech", "region", "year", "cns", "vTechFixom")] <- TRUE;
    rs["eqCnsLETechActvaromL", c("name", "description")] <- c("eqCnsLETechActvaromL", "");
    rs["eqCnsLETechActvaromL", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromL", c("name", "description")] <- c("eqCnsGETechActvaromL", "");
    rs["eqCnsGETechActvaromL", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromL", c("name", "description")] <- c("eqCnsETechActvaromL", "");
    rs["eqCnsETechActvaromL", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLS", c("name", "description")] <- c("eqCnsLETechActvaromLS", "");
    rs["eqCnsLETechActvaromLS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLS", c("name", "description")] <- c("eqCnsGETechActvaromLS", "");
    rs["eqCnsGETechActvaromLS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLS", c("name", "description")] <- c("eqCnsETechActvaromLS", "");
    rs["eqCnsETechActvaromLS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLY", c("name", "description")] <- c("eqCnsLETechActvaromLY", "");
    rs["eqCnsLETechActvaromLY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLYGrowth", c("name", "description")] <- c("eqCnsLETechActvaromLYGrowth", "");
    rs["eqCnsLETechActvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLY", c("name", "description")] <- c("eqCnsGETechActvaromLY", "");
    rs["eqCnsGETechActvaromLY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLYGrowth", c("name", "description")] <- c("eqCnsGETechActvaromLYGrowth", "");
    rs["eqCnsGETechActvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLY", c("name", "description")] <- c("eqCnsETechActvaromLY", "");
    rs["eqCnsETechActvaromLY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLYGrowth", c("name", "description")] <- c("eqCnsETechActvaromLYGrowth", "");
    rs["eqCnsETechActvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLYS", c("name", "description")] <- c("eqCnsLETechActvaromLYS", "");
    rs["eqCnsLETechActvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLYSGrowth", c("name", "description")] <- c("eqCnsLETechActvaromLYSGrowth", "");
    rs["eqCnsLETechActvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLYS", c("name", "description")] <- c("eqCnsGETechActvaromLYS", "");
    rs["eqCnsGETechActvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLYSGrowth", c("name", "description")] <- c("eqCnsGETechActvaromLYSGrowth", "");
    rs["eqCnsGETechActvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLYS", c("name", "description")] <- c("eqCnsETechActvaromLYS", "");
    rs["eqCnsETechActvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLYSGrowth", c("name", "description")] <- c("eqCnsETechActvaromLYSGrowth", "");
    rs["eqCnsETechActvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLR", c("name", "description")] <- c("eqCnsLETechActvaromLR", "");
    rs["eqCnsLETechActvaromLR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLR", c("name", "description")] <- c("eqCnsGETechActvaromLR", "");
    rs["eqCnsGETechActvaromLR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLR", c("name", "description")] <- c("eqCnsETechActvaromLR", "");
    rs["eqCnsETechActvaromLR", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLRS", c("name", "description")] <- c("eqCnsLETechActvaromLRS", "");
    rs["eqCnsLETechActvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLRS", c("name", "description")] <- c("eqCnsGETechActvaromLRS", "");
    rs["eqCnsGETechActvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLRS", c("name", "description")] <- c("eqCnsETechActvaromLRS", "");
    rs["eqCnsETechActvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLRY", c("name", "description")] <- c("eqCnsLETechActvaromLRY", "");
    rs["eqCnsLETechActvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLRYGrowth", c("name", "description")] <- c("eqCnsLETechActvaromLRYGrowth", "");
    rs["eqCnsLETechActvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLRY", c("name", "description")] <- c("eqCnsGETechActvaromLRY", "");
    rs["eqCnsGETechActvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLRYGrowth", c("name", "description")] <- c("eqCnsGETechActvaromLRYGrowth", "");
    rs["eqCnsGETechActvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLRY", c("name", "description")] <- c("eqCnsETechActvaromLRY", "");
    rs["eqCnsETechActvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLRYGrowth", c("name", "description")] <- c("eqCnsETechActvaromLRYGrowth", "");
    rs["eqCnsETechActvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLRYS", c("name", "description")] <- c("eqCnsLETechActvaromLRYS", "");
    rs["eqCnsLETechActvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechActvaromLRYSGrowth", c("name", "description")] <- c("eqCnsLETechActvaromLRYSGrowth", "");
    rs["eqCnsLETechActvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLRYS", c("name", "description")] <- c("eqCnsGETechActvaromLRYS", "");
    rs["eqCnsGETechActvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsGETechActvaromLRYSGrowth", c("name", "description")] <- c("eqCnsGETechActvaromLRYSGrowth", "");
    rs["eqCnsGETechActvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLRYS", c("name", "description")] <- c("eqCnsETechActvaromLRYS", "");
    rs["eqCnsETechActvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsETechActvaromLRYSGrowth", c("name", "description")] <- c("eqCnsETechActvaromLRYSGrowth", "");
    rs["eqCnsETechActvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechActVarom")] <- TRUE;
    rs["eqCnsLETechCvaromL", c("name", "description")] <- c("eqCnsLETechCvaromL", "");
    rs["eqCnsLETechCvaromL", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromL", c("name", "description")] <- c("eqCnsGETechCvaromL", "");
    rs["eqCnsGETechCvaromL", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromL", c("name", "description")] <- c("eqCnsETechCvaromL", "");
    rs["eqCnsETechCvaromL", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLS", c("name", "description")] <- c("eqCnsLETechCvaromLS", "");
    rs["eqCnsLETechCvaromLS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLS", c("name", "description")] <- c("eqCnsGETechCvaromLS", "");
    rs["eqCnsGETechCvaromLS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLS", c("name", "description")] <- c("eqCnsETechCvaromLS", "");
    rs["eqCnsETechCvaromLS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLY", c("name", "description")] <- c("eqCnsLETechCvaromLY", "");
    rs["eqCnsLETechCvaromLY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLYGrowth", c("name", "description")] <- c("eqCnsLETechCvaromLYGrowth", "");
    rs["eqCnsLETechCvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLY", c("name", "description")] <- c("eqCnsGETechCvaromLY", "");
    rs["eqCnsGETechCvaromLY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLYGrowth", c("name", "description")] <- c("eqCnsGETechCvaromLYGrowth", "");
    rs["eqCnsGETechCvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLY", c("name", "description")] <- c("eqCnsETechCvaromLY", "");
    rs["eqCnsETechCvaromLY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLYGrowth", c("name", "description")] <- c("eqCnsETechCvaromLYGrowth", "");
    rs["eqCnsETechCvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLYS", c("name", "description")] <- c("eqCnsLETechCvaromLYS", "");
    rs["eqCnsLETechCvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLYSGrowth", c("name", "description")] <- c("eqCnsLETechCvaromLYSGrowth", "");
    rs["eqCnsLETechCvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLYS", c("name", "description")] <- c("eqCnsGETechCvaromLYS", "");
    rs["eqCnsGETechCvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLYSGrowth", c("name", "description")] <- c("eqCnsGETechCvaromLYSGrowth", "");
    rs["eqCnsGETechCvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLYS", c("name", "description")] <- c("eqCnsETechCvaromLYS", "");
    rs["eqCnsETechCvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLYSGrowth", c("name", "description")] <- c("eqCnsETechCvaromLYSGrowth", "");
    rs["eqCnsETechCvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLR", c("name", "description")] <- c("eqCnsLETechCvaromLR", "");
    rs["eqCnsLETechCvaromLR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLR", c("name", "description")] <- c("eqCnsGETechCvaromLR", "");
    rs["eqCnsGETechCvaromLR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLR", c("name", "description")] <- c("eqCnsETechCvaromLR", "");
    rs["eqCnsETechCvaromLR", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLRS", c("name", "description")] <- c("eqCnsLETechCvaromLRS", "");
    rs["eqCnsLETechCvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLRS", c("name", "description")] <- c("eqCnsGETechCvaromLRS", "");
    rs["eqCnsGETechCvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLRS", c("name", "description")] <- c("eqCnsETechCvaromLRS", "");
    rs["eqCnsETechCvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLRY", c("name", "description")] <- c("eqCnsLETechCvaromLRY", "");
    rs["eqCnsLETechCvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLRYGrowth", c("name", "description")] <- c("eqCnsLETechCvaromLRYGrowth", "");
    rs["eqCnsLETechCvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLRY", c("name", "description")] <- c("eqCnsGETechCvaromLRY", "");
    rs["eqCnsGETechCvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLRYGrowth", c("name", "description")] <- c("eqCnsGETechCvaromLRYGrowth", "");
    rs["eqCnsGETechCvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLRY", c("name", "description")] <- c("eqCnsETechCvaromLRY", "");
    rs["eqCnsETechCvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLRYGrowth", c("name", "description")] <- c("eqCnsETechCvaromLRYGrowth", "");
    rs["eqCnsETechCvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLRYS", c("name", "description")] <- c("eqCnsLETechCvaromLRYS", "");
    rs["eqCnsLETechCvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechCvaromLRYSGrowth", c("name", "description")] <- c("eqCnsLETechCvaromLRYSGrowth", "");
    rs["eqCnsLETechCvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLRYS", c("name", "description")] <- c("eqCnsGETechCvaromLRYS", "");
    rs["eqCnsGETechCvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsGETechCvaromLRYSGrowth", c("name", "description")] <- c("eqCnsGETechCvaromLRYSGrowth", "");
    rs["eqCnsGETechCvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLRYS", c("name", "description")] <- c("eqCnsETechCvaromLRYS", "");
    rs["eqCnsETechCvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsETechCvaromLRYSGrowth", c("name", "description")] <- c("eqCnsETechCvaromLRYSGrowth", "");
    rs["eqCnsETechCvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechCVarom")] <- TRUE;
    rs["eqCnsLETechAvaromL", c("name", "description")] <- c("eqCnsLETechAvaromL", "");
    rs["eqCnsLETechAvaromL", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromL", c("name", "description")] <- c("eqCnsGETechAvaromL", "");
    rs["eqCnsGETechAvaromL", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromL", c("name", "description")] <- c("eqCnsETechAvaromL", "");
    rs["eqCnsETechAvaromL", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLS", c("name", "description")] <- c("eqCnsLETechAvaromLS", "");
    rs["eqCnsLETechAvaromLS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLS", c("name", "description")] <- c("eqCnsGETechAvaromLS", "");
    rs["eqCnsGETechAvaromLS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLS", c("name", "description")] <- c("eqCnsETechAvaromLS", "");
    rs["eqCnsETechAvaromLS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLY", c("name", "description")] <- c("eqCnsLETechAvaromLY", "");
    rs["eqCnsLETechAvaromLY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLYGrowth", c("name", "description")] <- c("eqCnsLETechAvaromLYGrowth", "");
    rs["eqCnsLETechAvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLY", c("name", "description")] <- c("eqCnsGETechAvaromLY", "");
    rs["eqCnsGETechAvaromLY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLYGrowth", c("name", "description")] <- c("eqCnsGETechAvaromLYGrowth", "");
    rs["eqCnsGETechAvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLY", c("name", "description")] <- c("eqCnsETechAvaromLY", "");
    rs["eqCnsETechAvaromLY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLYGrowth", c("name", "description")] <- c("eqCnsETechAvaromLYGrowth", "");
    rs["eqCnsETechAvaromLYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLYS", c("name", "description")] <- c("eqCnsLETechAvaromLYS", "");
    rs["eqCnsLETechAvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLYSGrowth", c("name", "description")] <- c("eqCnsLETechAvaromLYSGrowth", "");
    rs["eqCnsLETechAvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLYS", c("name", "description")] <- c("eqCnsGETechAvaromLYS", "");
    rs["eqCnsGETechAvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLYSGrowth", c("name", "description")] <- c("eqCnsGETechAvaromLYSGrowth", "");
    rs["eqCnsGETechAvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLYS", c("name", "description")] <- c("eqCnsETechAvaromLYS", "");
    rs["eqCnsETechAvaromLYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLYSGrowth", c("name", "description")] <- c("eqCnsETechAvaromLYSGrowth", "");
    rs["eqCnsETechAvaromLYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLR", c("name", "description")] <- c("eqCnsLETechAvaromLR", "");
    rs["eqCnsLETechAvaromLR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLR", c("name", "description")] <- c("eqCnsGETechAvaromLR", "");
    rs["eqCnsGETechAvaromLR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLR", c("name", "description")] <- c("eqCnsETechAvaromLR", "");
    rs["eqCnsETechAvaromLR", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLRS", c("name", "description")] <- c("eqCnsLETechAvaromLRS", "");
    rs["eqCnsLETechAvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLRS", c("name", "description")] <- c("eqCnsGETechAvaromLRS", "");
    rs["eqCnsGETechAvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLRS", c("name", "description")] <- c("eqCnsETechAvaromLRS", "");
    rs["eqCnsETechAvaromLRS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLRY", c("name", "description")] <- c("eqCnsLETechAvaromLRY", "");
    rs["eqCnsLETechAvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLRYGrowth", c("name", "description")] <- c("eqCnsLETechAvaromLRYGrowth", "");
    rs["eqCnsLETechAvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLRY", c("name", "description")] <- c("eqCnsGETechAvaromLRY", "");
    rs["eqCnsGETechAvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLRYGrowth", c("name", "description")] <- c("eqCnsGETechAvaromLRYGrowth", "");
    rs["eqCnsGETechAvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLRY", c("name", "description")] <- c("eqCnsETechAvaromLRY", "");
    rs["eqCnsETechAvaromLRY", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLRYGrowth", c("name", "description")] <- c("eqCnsETechAvaromLRYGrowth", "");
    rs["eqCnsETechAvaromLRYGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLRYS", c("name", "description")] <- c("eqCnsLETechAvaromLRYS", "");
    rs["eqCnsLETechAvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLETechAvaromLRYSGrowth", c("name", "description")] <- c("eqCnsLETechAvaromLRYSGrowth", "");
    rs["eqCnsLETechAvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLRYS", c("name", "description")] <- c("eqCnsGETechAvaromLRYS", "");
    rs["eqCnsGETechAvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsGETechAvaromLRYSGrowth", c("name", "description")] <- c("eqCnsGETechAvaromLRYSGrowth", "");
    rs["eqCnsGETechAvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLRYS", c("name", "description")] <- c("eqCnsETechAvaromLRYS", "");
    rs["eqCnsETechAvaromLRYS", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsETechAvaromLRYSGrowth", c("name", "description")] <- c("eqCnsETechAvaromLRYSGrowth", "");
    rs["eqCnsETechAvaromLRYSGrowth", c("tech", "region", "year", "slice", "cns", "vTechAVarom")] <- TRUE;
    rs["eqCnsLESupOutShareIn", c("name", "description")] <- c("eqCnsLESupOutShareIn", "");
    rs["eqCnsLESupOutShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutShareOut", c("name", "description")] <- c("eqCnsLESupOutShareOut", "");
    rs["eqCnsLESupOutShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOut", c("name", "description")] <- c("eqCnsLESupOut", "");
    rs["eqCnsLESupOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutShareIn", c("name", "description")] <- c("eqCnsGESupOutShareIn", "");
    rs["eqCnsGESupOutShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutShareOut", c("name", "description")] <- c("eqCnsGESupOutShareOut", "");
    rs["eqCnsGESupOutShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOut", c("name", "description")] <- c("eqCnsGESupOut", "");
    rs["eqCnsGESupOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutShareIn", c("name", "description")] <- c("eqCnsESupOutShareIn", "");
    rs["eqCnsESupOutShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutShareOut", c("name", "description")] <- c("eqCnsESupOutShareOut", "");
    rs["eqCnsESupOutShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOut", c("name", "description")] <- c("eqCnsESupOut", "");
    rs["eqCnsESupOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutSShareIn", c("name", "description")] <- c("eqCnsLESupOutSShareIn", "");
    rs["eqCnsLESupOutSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutSShareOut", c("name", "description")] <- c("eqCnsLESupOutSShareOut", "");
    rs["eqCnsLESupOutSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutS", c("name", "description")] <- c("eqCnsLESupOutS", "");
    rs["eqCnsLESupOutS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutSShareIn", c("name", "description")] <- c("eqCnsGESupOutSShareIn", "");
    rs["eqCnsGESupOutSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutSShareOut", c("name", "description")] <- c("eqCnsGESupOutSShareOut", "");
    rs["eqCnsGESupOutSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutS", c("name", "description")] <- c("eqCnsGESupOutS", "");
    rs["eqCnsGESupOutS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutSShareIn", c("name", "description")] <- c("eqCnsESupOutSShareIn", "");
    rs["eqCnsESupOutSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutSShareOut", c("name", "description")] <- c("eqCnsESupOutSShareOut", "");
    rs["eqCnsESupOutSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutS", c("name", "description")] <- c("eqCnsESupOutS", "");
    rs["eqCnsESupOutS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutYShareIn", c("name", "description")] <- c("eqCnsLESupOutYShareIn", "");
    rs["eqCnsLESupOutYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutYShareOut", c("name", "description")] <- c("eqCnsLESupOutYShareOut", "");
    rs["eqCnsLESupOutYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutY", c("name", "description")] <- c("eqCnsLESupOutY", "");
    rs["eqCnsLESupOutY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutYGrowth", c("name", "description")] <- c("eqCnsLESupOutYGrowth", "");
    rs["eqCnsLESupOutYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutYShareIn", c("name", "description")] <- c("eqCnsGESupOutYShareIn", "");
    rs["eqCnsGESupOutYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutYShareOut", c("name", "description")] <- c("eqCnsGESupOutYShareOut", "");
    rs["eqCnsGESupOutYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutY", c("name", "description")] <- c("eqCnsGESupOutY", "");
    rs["eqCnsGESupOutY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutYGrowth", c("name", "description")] <- c("eqCnsGESupOutYGrowth", "");
    rs["eqCnsGESupOutYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutYShareIn", c("name", "description")] <- c("eqCnsESupOutYShareIn", "");
    rs["eqCnsESupOutYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutYShareOut", c("name", "description")] <- c("eqCnsESupOutYShareOut", "");
    rs["eqCnsESupOutYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutY", c("name", "description")] <- c("eqCnsESupOutY", "");
    rs["eqCnsESupOutY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutYGrowth", c("name", "description")] <- c("eqCnsESupOutYGrowth", "");
    rs["eqCnsESupOutYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutYSShareIn", c("name", "description")] <- c("eqCnsLESupOutYSShareIn", "");
    rs["eqCnsLESupOutYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutYSShareOut", c("name", "description")] <- c("eqCnsLESupOutYSShareOut", "");
    rs["eqCnsLESupOutYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutYS", c("name", "description")] <- c("eqCnsLESupOutYS", "");
    rs["eqCnsLESupOutYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutYSGrowth", c("name", "description")] <- c("eqCnsLESupOutYSGrowth", "");
    rs["eqCnsLESupOutYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutYSShareIn", c("name", "description")] <- c("eqCnsGESupOutYSShareIn", "");
    rs["eqCnsGESupOutYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutYSShareOut", c("name", "description")] <- c("eqCnsGESupOutYSShareOut", "");
    rs["eqCnsGESupOutYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutYS", c("name", "description")] <- c("eqCnsGESupOutYS", "");
    rs["eqCnsGESupOutYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutYSGrowth", c("name", "description")] <- c("eqCnsGESupOutYSGrowth", "");
    rs["eqCnsGESupOutYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutYSShareIn", c("name", "description")] <- c("eqCnsESupOutYSShareIn", "");
    rs["eqCnsESupOutYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutYSShareOut", c("name", "description")] <- c("eqCnsESupOutYSShareOut", "");
    rs["eqCnsESupOutYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutYS", c("name", "description")] <- c("eqCnsESupOutYS", "");
    rs["eqCnsESupOutYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutYSGrowth", c("name", "description")] <- c("eqCnsESupOutYSGrowth", "");
    rs["eqCnsESupOutYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRShareIn", c("name", "description")] <- c("eqCnsLESupOutRShareIn", "");
    rs["eqCnsLESupOutRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutRShareOut", c("name", "description")] <- c("eqCnsLESupOutRShareOut", "");
    rs["eqCnsLESupOutRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutR", c("name", "description")] <- c("eqCnsLESupOutR", "");
    rs["eqCnsLESupOutR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRShareIn", c("name", "description")] <- c("eqCnsGESupOutRShareIn", "");
    rs["eqCnsGESupOutRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutRShareOut", c("name", "description")] <- c("eqCnsGESupOutRShareOut", "");
    rs["eqCnsGESupOutRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutR", c("name", "description")] <- c("eqCnsGESupOutR", "");
    rs["eqCnsGESupOutR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRShareIn", c("name", "description")] <- c("eqCnsESupOutRShareIn", "");
    rs["eqCnsESupOutRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutRShareOut", c("name", "description")] <- c("eqCnsESupOutRShareOut", "");
    rs["eqCnsESupOutRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutR", c("name", "description")] <- c("eqCnsESupOutR", "");
    rs["eqCnsESupOutR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRSShareIn", c("name", "description")] <- c("eqCnsLESupOutRSShareIn", "");
    rs["eqCnsLESupOutRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutRSShareOut", c("name", "description")] <- c("eqCnsLESupOutRSShareOut", "");
    rs["eqCnsLESupOutRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutRS", c("name", "description")] <- c("eqCnsLESupOutRS", "");
    rs["eqCnsLESupOutRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRSShareIn", c("name", "description")] <- c("eqCnsGESupOutRSShareIn", "");
    rs["eqCnsGESupOutRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutRSShareOut", c("name", "description")] <- c("eqCnsGESupOutRSShareOut", "");
    rs["eqCnsGESupOutRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutRS", c("name", "description")] <- c("eqCnsGESupOutRS", "");
    rs["eqCnsGESupOutRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRSShareIn", c("name", "description")] <- c("eqCnsESupOutRSShareIn", "");
    rs["eqCnsESupOutRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutRSShareOut", c("name", "description")] <- c("eqCnsESupOutRSShareOut", "");
    rs["eqCnsESupOutRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutRS", c("name", "description")] <- c("eqCnsESupOutRS", "");
    rs["eqCnsESupOutRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRYShareIn", c("name", "description")] <- c("eqCnsLESupOutRYShareIn", "");
    rs["eqCnsLESupOutRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutRYShareOut", c("name", "description")] <- c("eqCnsLESupOutRYShareOut", "");
    rs["eqCnsLESupOutRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutRY", c("name", "description")] <- c("eqCnsLESupOutRY", "");
    rs["eqCnsLESupOutRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRYGrowth", c("name", "description")] <- c("eqCnsLESupOutRYGrowth", "");
    rs["eqCnsLESupOutRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRYShareIn", c("name", "description")] <- c("eqCnsGESupOutRYShareIn", "");
    rs["eqCnsGESupOutRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutRYShareOut", c("name", "description")] <- c("eqCnsGESupOutRYShareOut", "");
    rs["eqCnsGESupOutRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutRY", c("name", "description")] <- c("eqCnsGESupOutRY", "");
    rs["eqCnsGESupOutRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRYGrowth", c("name", "description")] <- c("eqCnsGESupOutRYGrowth", "");
    rs["eqCnsGESupOutRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRYShareIn", c("name", "description")] <- c("eqCnsESupOutRYShareIn", "");
    rs["eqCnsESupOutRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutRYShareOut", c("name", "description")] <- c("eqCnsESupOutRYShareOut", "");
    rs["eqCnsESupOutRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutRY", c("name", "description")] <- c("eqCnsESupOutRY", "");
    rs["eqCnsESupOutRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRYGrowth", c("name", "description")] <- c("eqCnsESupOutRYGrowth", "");
    rs["eqCnsESupOutRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRYSShareIn", c("name", "description")] <- c("eqCnsLESupOutRYSShareIn", "");
    rs["eqCnsLESupOutRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutRYSShareOut", c("name", "description")] <- c("eqCnsLESupOutRYSShareOut", "");
    rs["eqCnsLESupOutRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutRYS", c("name", "description")] <- c("eqCnsLESupOutRYS", "");
    rs["eqCnsLESupOutRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutRYSGrowth", c("name", "description")] <- c("eqCnsLESupOutRYSGrowth", "");
    rs["eqCnsLESupOutRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRYSShareIn", c("name", "description")] <- c("eqCnsGESupOutRYSShareIn", "");
    rs["eqCnsGESupOutRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutRYSShareOut", c("name", "description")] <- c("eqCnsGESupOutRYSShareOut", "");
    rs["eqCnsGESupOutRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutRYS", c("name", "description")] <- c("eqCnsGESupOutRYS", "");
    rs["eqCnsGESupOutRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutRYSGrowth", c("name", "description")] <- c("eqCnsGESupOutRYSGrowth", "");
    rs["eqCnsGESupOutRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRYSShareIn", c("name", "description")] <- c("eqCnsESupOutRYSShareIn", "");
    rs["eqCnsESupOutRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutRYSShareOut", c("name", "description")] <- c("eqCnsESupOutRYSShareOut", "");
    rs["eqCnsESupOutRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutRYS", c("name", "description")] <- c("eqCnsESupOutRYS", "");
    rs["eqCnsESupOutRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutRYSGrowth", c("name", "description")] <- c("eqCnsESupOutRYSGrowth", "");
    rs["eqCnsESupOutRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCShareIn", c("name", "description")] <- c("eqCnsLESupOutCShareIn", "");
    rs["eqCnsLESupOutCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCShareOut", c("name", "description")] <- c("eqCnsLESupOutCShareOut", "");
    rs["eqCnsLESupOutCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutC", c("name", "description")] <- c("eqCnsLESupOutC", "");
    rs["eqCnsLESupOutC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCShareIn", c("name", "description")] <- c("eqCnsGESupOutCShareIn", "");
    rs["eqCnsGESupOutCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCShareOut", c("name", "description")] <- c("eqCnsGESupOutCShareOut", "");
    rs["eqCnsGESupOutCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutC", c("name", "description")] <- c("eqCnsGESupOutC", "");
    rs["eqCnsGESupOutC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCShareIn", c("name", "description")] <- c("eqCnsESupOutCShareIn", "");
    rs["eqCnsESupOutCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCShareOut", c("name", "description")] <- c("eqCnsESupOutCShareOut", "");
    rs["eqCnsESupOutCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutC", c("name", "description")] <- c("eqCnsESupOutC", "");
    rs["eqCnsESupOutC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCSShareIn", c("name", "description")] <- c("eqCnsLESupOutCSShareIn", "");
    rs["eqCnsLESupOutCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCSShareOut", c("name", "description")] <- c("eqCnsLESupOutCSShareOut", "");
    rs["eqCnsLESupOutCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCS", c("name", "description")] <- c("eqCnsLESupOutCS", "");
    rs["eqCnsLESupOutCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCSShareIn", c("name", "description")] <- c("eqCnsGESupOutCSShareIn", "");
    rs["eqCnsGESupOutCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCSShareOut", c("name", "description")] <- c("eqCnsGESupOutCSShareOut", "");
    rs["eqCnsGESupOutCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCS", c("name", "description")] <- c("eqCnsGESupOutCS", "");
    rs["eqCnsGESupOutCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCSShareIn", c("name", "description")] <- c("eqCnsESupOutCSShareIn", "");
    rs["eqCnsESupOutCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCSShareOut", c("name", "description")] <- c("eqCnsESupOutCSShareOut", "");
    rs["eqCnsESupOutCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCS", c("name", "description")] <- c("eqCnsESupOutCS", "");
    rs["eqCnsESupOutCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCYShareIn", c("name", "description")] <- c("eqCnsLESupOutCYShareIn", "");
    rs["eqCnsLESupOutCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCYShareOut", c("name", "description")] <- c("eqCnsLESupOutCYShareOut", "");
    rs["eqCnsLESupOutCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCY", c("name", "description")] <- c("eqCnsLESupOutCY", "");
    rs["eqCnsLESupOutCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCYGrowth", c("name", "description")] <- c("eqCnsLESupOutCYGrowth", "");
    rs["eqCnsLESupOutCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCYShareIn", c("name", "description")] <- c("eqCnsGESupOutCYShareIn", "");
    rs["eqCnsGESupOutCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCYShareOut", c("name", "description")] <- c("eqCnsGESupOutCYShareOut", "");
    rs["eqCnsGESupOutCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCY", c("name", "description")] <- c("eqCnsGESupOutCY", "");
    rs["eqCnsGESupOutCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCYGrowth", c("name", "description")] <- c("eqCnsGESupOutCYGrowth", "");
    rs["eqCnsGESupOutCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCYShareIn", c("name", "description")] <- c("eqCnsESupOutCYShareIn", "");
    rs["eqCnsESupOutCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCYShareOut", c("name", "description")] <- c("eqCnsESupOutCYShareOut", "");
    rs["eqCnsESupOutCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCY", c("name", "description")] <- c("eqCnsESupOutCY", "");
    rs["eqCnsESupOutCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCYGrowth", c("name", "description")] <- c("eqCnsESupOutCYGrowth", "");
    rs["eqCnsESupOutCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCYSShareIn", c("name", "description")] <- c("eqCnsLESupOutCYSShareIn", "");
    rs["eqCnsLESupOutCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCYSShareOut", c("name", "description")] <- c("eqCnsLESupOutCYSShareOut", "");
    rs["eqCnsLESupOutCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCYS", c("name", "description")] <- c("eqCnsLESupOutCYS", "");
    rs["eqCnsLESupOutCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCYSGrowth", c("name", "description")] <- c("eqCnsLESupOutCYSGrowth", "");
    rs["eqCnsLESupOutCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCYSShareIn", c("name", "description")] <- c("eqCnsGESupOutCYSShareIn", "");
    rs["eqCnsGESupOutCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCYSShareOut", c("name", "description")] <- c("eqCnsGESupOutCYSShareOut", "");
    rs["eqCnsGESupOutCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCYS", c("name", "description")] <- c("eqCnsGESupOutCYS", "");
    rs["eqCnsGESupOutCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCYSGrowth", c("name", "description")] <- c("eqCnsGESupOutCYSGrowth", "");
    rs["eqCnsGESupOutCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCYSShareIn", c("name", "description")] <- c("eqCnsESupOutCYSShareIn", "");
    rs["eqCnsESupOutCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCYSShareOut", c("name", "description")] <- c("eqCnsESupOutCYSShareOut", "");
    rs["eqCnsESupOutCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCYS", c("name", "description")] <- c("eqCnsESupOutCYS", "");
    rs["eqCnsESupOutCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCYSGrowth", c("name", "description")] <- c("eqCnsESupOutCYSGrowth", "");
    rs["eqCnsESupOutCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRShareIn", c("name", "description")] <- c("eqCnsLESupOutCRShareIn", "");
    rs["eqCnsLESupOutCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCRShareOut", c("name", "description")] <- c("eqCnsLESupOutCRShareOut", "");
    rs["eqCnsLESupOutCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCR", c("name", "description")] <- c("eqCnsLESupOutCR", "");
    rs["eqCnsLESupOutCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRShareIn", c("name", "description")] <- c("eqCnsGESupOutCRShareIn", "");
    rs["eqCnsGESupOutCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCRShareOut", c("name", "description")] <- c("eqCnsGESupOutCRShareOut", "");
    rs["eqCnsGESupOutCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCR", c("name", "description")] <- c("eqCnsGESupOutCR", "");
    rs["eqCnsGESupOutCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRShareIn", c("name", "description")] <- c("eqCnsESupOutCRShareIn", "");
    rs["eqCnsESupOutCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCRShareOut", c("name", "description")] <- c("eqCnsESupOutCRShareOut", "");
    rs["eqCnsESupOutCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCR", c("name", "description")] <- c("eqCnsESupOutCR", "");
    rs["eqCnsESupOutCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRSShareIn", c("name", "description")] <- c("eqCnsLESupOutCRSShareIn", "");
    rs["eqCnsLESupOutCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCRSShareOut", c("name", "description")] <- c("eqCnsLESupOutCRSShareOut", "");
    rs["eqCnsLESupOutCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCRS", c("name", "description")] <- c("eqCnsLESupOutCRS", "");
    rs["eqCnsLESupOutCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRSShareIn", c("name", "description")] <- c("eqCnsGESupOutCRSShareIn", "");
    rs["eqCnsGESupOutCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCRSShareOut", c("name", "description")] <- c("eqCnsGESupOutCRSShareOut", "");
    rs["eqCnsGESupOutCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCRS", c("name", "description")] <- c("eqCnsGESupOutCRS", "");
    rs["eqCnsGESupOutCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRSShareIn", c("name", "description")] <- c("eqCnsESupOutCRSShareIn", "");
    rs["eqCnsESupOutCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCRSShareOut", c("name", "description")] <- c("eqCnsESupOutCRSShareOut", "");
    rs["eqCnsESupOutCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCRS", c("name", "description")] <- c("eqCnsESupOutCRS", "");
    rs["eqCnsESupOutCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRYShareIn", c("name", "description")] <- c("eqCnsLESupOutCRYShareIn", "");
    rs["eqCnsLESupOutCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCRYShareOut", c("name", "description")] <- c("eqCnsLESupOutCRYShareOut", "");
    rs["eqCnsLESupOutCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCRY", c("name", "description")] <- c("eqCnsLESupOutCRY", "");
    rs["eqCnsLESupOutCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRYGrowth", c("name", "description")] <- c("eqCnsLESupOutCRYGrowth", "");
    rs["eqCnsLESupOutCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRYShareIn", c("name", "description")] <- c("eqCnsGESupOutCRYShareIn", "");
    rs["eqCnsGESupOutCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCRYShareOut", c("name", "description")] <- c("eqCnsGESupOutCRYShareOut", "");
    rs["eqCnsGESupOutCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCRY", c("name", "description")] <- c("eqCnsGESupOutCRY", "");
    rs["eqCnsGESupOutCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRYGrowth", c("name", "description")] <- c("eqCnsGESupOutCRYGrowth", "");
    rs["eqCnsGESupOutCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRYShareIn", c("name", "description")] <- c("eqCnsESupOutCRYShareIn", "");
    rs["eqCnsESupOutCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCRYShareOut", c("name", "description")] <- c("eqCnsESupOutCRYShareOut", "");
    rs["eqCnsESupOutCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCRY", c("name", "description")] <- c("eqCnsESupOutCRY", "");
    rs["eqCnsESupOutCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRYGrowth", c("name", "description")] <- c("eqCnsESupOutCRYGrowth", "");
    rs["eqCnsESupOutCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRYSShareIn", c("name", "description")] <- c("eqCnsLESupOutCRYSShareIn", "");
    rs["eqCnsLESupOutCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutCRYSShareOut", c("name", "description")] <- c("eqCnsLESupOutCRYSShareOut", "");
    rs["eqCnsLESupOutCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutCRYS", c("name", "description")] <- c("eqCnsLESupOutCRYS", "");
    rs["eqCnsLESupOutCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutCRYSGrowth", c("name", "description")] <- c("eqCnsLESupOutCRYSGrowth", "");
    rs["eqCnsLESupOutCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRYSShareIn", c("name", "description")] <- c("eqCnsGESupOutCRYSShareIn", "");
    rs["eqCnsGESupOutCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutCRYSShareOut", c("name", "description")] <- c("eqCnsGESupOutCRYSShareOut", "");
    rs["eqCnsGESupOutCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutCRYS", c("name", "description")] <- c("eqCnsGESupOutCRYS", "");
    rs["eqCnsGESupOutCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutCRYSGrowth", c("name", "description")] <- c("eqCnsGESupOutCRYSGrowth", "");
    rs["eqCnsGESupOutCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRYSShareIn", c("name", "description")] <- c("eqCnsESupOutCRYSShareIn", "");
    rs["eqCnsESupOutCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutCRYSShareOut", c("name", "description")] <- c("eqCnsESupOutCRYSShareOut", "");
    rs["eqCnsESupOutCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutCRYS", c("name", "description")] <- c("eqCnsESupOutCRYS", "");
    rs["eqCnsESupOutCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutCRYSGrowth", c("name", "description")] <- c("eqCnsESupOutCRYSGrowth", "");
    rs["eqCnsESupOutCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLShareIn", c("name", "description")] <- c("eqCnsLESupOutLShareIn", "");
    rs["eqCnsLESupOutLShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLShareOut", c("name", "description")] <- c("eqCnsLESupOutLShareOut", "");
    rs["eqCnsLESupOutLShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutL", c("name", "description")] <- c("eqCnsLESupOutL", "");
    rs["eqCnsLESupOutL", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLShareIn", c("name", "description")] <- c("eqCnsGESupOutLShareIn", "");
    rs["eqCnsGESupOutLShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLShareOut", c("name", "description")] <- c("eqCnsGESupOutLShareOut", "");
    rs["eqCnsGESupOutLShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutL", c("name", "description")] <- c("eqCnsGESupOutL", "");
    rs["eqCnsGESupOutL", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLShareIn", c("name", "description")] <- c("eqCnsESupOutLShareIn", "");
    rs["eqCnsESupOutLShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLShareOut", c("name", "description")] <- c("eqCnsESupOutLShareOut", "");
    rs["eqCnsESupOutLShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutL", c("name", "description")] <- c("eqCnsESupOutL", "");
    rs["eqCnsESupOutL", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLSShareIn", c("name", "description")] <- c("eqCnsLESupOutLSShareIn", "");
    rs["eqCnsLESupOutLSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLSShareOut", c("name", "description")] <- c("eqCnsLESupOutLSShareOut", "");
    rs["eqCnsLESupOutLSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLS", c("name", "description")] <- c("eqCnsLESupOutLS", "");
    rs["eqCnsLESupOutLS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLSShareIn", c("name", "description")] <- c("eqCnsGESupOutLSShareIn", "");
    rs["eqCnsGESupOutLSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLSShareOut", c("name", "description")] <- c("eqCnsGESupOutLSShareOut", "");
    rs["eqCnsGESupOutLSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLS", c("name", "description")] <- c("eqCnsGESupOutLS", "");
    rs["eqCnsGESupOutLS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLSShareIn", c("name", "description")] <- c("eqCnsESupOutLSShareIn", "");
    rs["eqCnsESupOutLSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLSShareOut", c("name", "description")] <- c("eqCnsESupOutLSShareOut", "");
    rs["eqCnsESupOutLSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLS", c("name", "description")] <- c("eqCnsESupOutLS", "");
    rs["eqCnsESupOutLS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLYShareIn", c("name", "description")] <- c("eqCnsLESupOutLYShareIn", "");
    rs["eqCnsLESupOutLYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLYShareOut", c("name", "description")] <- c("eqCnsLESupOutLYShareOut", "");
    rs["eqCnsLESupOutLYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLY", c("name", "description")] <- c("eqCnsLESupOutLY", "");
    rs["eqCnsLESupOutLY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLYGrowth", c("name", "description")] <- c("eqCnsLESupOutLYGrowth", "");
    rs["eqCnsLESupOutLYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLYShareIn", c("name", "description")] <- c("eqCnsGESupOutLYShareIn", "");
    rs["eqCnsGESupOutLYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLYShareOut", c("name", "description")] <- c("eqCnsGESupOutLYShareOut", "");
    rs["eqCnsGESupOutLYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLY", c("name", "description")] <- c("eqCnsGESupOutLY", "");
    rs["eqCnsGESupOutLY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLYGrowth", c("name", "description")] <- c("eqCnsGESupOutLYGrowth", "");
    rs["eqCnsGESupOutLYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLYShareIn", c("name", "description")] <- c("eqCnsESupOutLYShareIn", "");
    rs["eqCnsESupOutLYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLYShareOut", c("name", "description")] <- c("eqCnsESupOutLYShareOut", "");
    rs["eqCnsESupOutLYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLY", c("name", "description")] <- c("eqCnsESupOutLY", "");
    rs["eqCnsESupOutLY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLYGrowth", c("name", "description")] <- c("eqCnsESupOutLYGrowth", "");
    rs["eqCnsESupOutLYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLYSShareIn", c("name", "description")] <- c("eqCnsLESupOutLYSShareIn", "");
    rs["eqCnsLESupOutLYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLYSShareOut", c("name", "description")] <- c("eqCnsLESupOutLYSShareOut", "");
    rs["eqCnsLESupOutLYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLYS", c("name", "description")] <- c("eqCnsLESupOutLYS", "");
    rs["eqCnsLESupOutLYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLYSGrowth", c("name", "description")] <- c("eqCnsLESupOutLYSGrowth", "");
    rs["eqCnsLESupOutLYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLYSShareIn", c("name", "description")] <- c("eqCnsGESupOutLYSShareIn", "");
    rs["eqCnsGESupOutLYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLYSShareOut", c("name", "description")] <- c("eqCnsGESupOutLYSShareOut", "");
    rs["eqCnsGESupOutLYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLYS", c("name", "description")] <- c("eqCnsGESupOutLYS", "");
    rs["eqCnsGESupOutLYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLYSGrowth", c("name", "description")] <- c("eqCnsGESupOutLYSGrowth", "");
    rs["eqCnsGESupOutLYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLYSShareIn", c("name", "description")] <- c("eqCnsESupOutLYSShareIn", "");
    rs["eqCnsESupOutLYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLYSShareOut", c("name", "description")] <- c("eqCnsESupOutLYSShareOut", "");
    rs["eqCnsESupOutLYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLYS", c("name", "description")] <- c("eqCnsESupOutLYS", "");
    rs["eqCnsESupOutLYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLYSGrowth", c("name", "description")] <- c("eqCnsESupOutLYSGrowth", "");
    rs["eqCnsESupOutLYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRShareIn", c("name", "description")] <- c("eqCnsLESupOutLRShareIn", "");
    rs["eqCnsLESupOutLRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLRShareOut", c("name", "description")] <- c("eqCnsLESupOutLRShareOut", "");
    rs["eqCnsLESupOutLRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLR", c("name", "description")] <- c("eqCnsLESupOutLR", "");
    rs["eqCnsLESupOutLR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRShareIn", c("name", "description")] <- c("eqCnsGESupOutLRShareIn", "");
    rs["eqCnsGESupOutLRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLRShareOut", c("name", "description")] <- c("eqCnsGESupOutLRShareOut", "");
    rs["eqCnsGESupOutLRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLR", c("name", "description")] <- c("eqCnsGESupOutLR", "");
    rs["eqCnsGESupOutLR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRShareIn", c("name", "description")] <- c("eqCnsESupOutLRShareIn", "");
    rs["eqCnsESupOutLRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLRShareOut", c("name", "description")] <- c("eqCnsESupOutLRShareOut", "");
    rs["eqCnsESupOutLRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLR", c("name", "description")] <- c("eqCnsESupOutLR", "");
    rs["eqCnsESupOutLR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRSShareIn", c("name", "description")] <- c("eqCnsLESupOutLRSShareIn", "");
    rs["eqCnsLESupOutLRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLRSShareOut", c("name", "description")] <- c("eqCnsLESupOutLRSShareOut", "");
    rs["eqCnsLESupOutLRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLRS", c("name", "description")] <- c("eqCnsLESupOutLRS", "");
    rs["eqCnsLESupOutLRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRSShareIn", c("name", "description")] <- c("eqCnsGESupOutLRSShareIn", "");
    rs["eqCnsGESupOutLRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLRSShareOut", c("name", "description")] <- c("eqCnsGESupOutLRSShareOut", "");
    rs["eqCnsGESupOutLRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLRS", c("name", "description")] <- c("eqCnsGESupOutLRS", "");
    rs["eqCnsGESupOutLRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRSShareIn", c("name", "description")] <- c("eqCnsESupOutLRSShareIn", "");
    rs["eqCnsESupOutLRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLRSShareOut", c("name", "description")] <- c("eqCnsESupOutLRSShareOut", "");
    rs["eqCnsESupOutLRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLRS", c("name", "description")] <- c("eqCnsESupOutLRS", "");
    rs["eqCnsESupOutLRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRYShareIn", c("name", "description")] <- c("eqCnsLESupOutLRYShareIn", "");
    rs["eqCnsLESupOutLRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLRYShareOut", c("name", "description")] <- c("eqCnsLESupOutLRYShareOut", "");
    rs["eqCnsLESupOutLRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLRY", c("name", "description")] <- c("eqCnsLESupOutLRY", "");
    rs["eqCnsLESupOutLRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRYGrowth", c("name", "description")] <- c("eqCnsLESupOutLRYGrowth", "");
    rs["eqCnsLESupOutLRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRYShareIn", c("name", "description")] <- c("eqCnsGESupOutLRYShareIn", "");
    rs["eqCnsGESupOutLRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLRYShareOut", c("name", "description")] <- c("eqCnsGESupOutLRYShareOut", "");
    rs["eqCnsGESupOutLRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLRY", c("name", "description")] <- c("eqCnsGESupOutLRY", "");
    rs["eqCnsGESupOutLRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRYGrowth", c("name", "description")] <- c("eqCnsGESupOutLRYGrowth", "");
    rs["eqCnsGESupOutLRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRYShareIn", c("name", "description")] <- c("eqCnsESupOutLRYShareIn", "");
    rs["eqCnsESupOutLRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLRYShareOut", c("name", "description")] <- c("eqCnsESupOutLRYShareOut", "");
    rs["eqCnsESupOutLRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLRY", c("name", "description")] <- c("eqCnsESupOutLRY", "");
    rs["eqCnsESupOutLRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRYGrowth", c("name", "description")] <- c("eqCnsESupOutLRYGrowth", "");
    rs["eqCnsESupOutLRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRYSShareIn", c("name", "description")] <- c("eqCnsLESupOutLRYSShareIn", "");
    rs["eqCnsLESupOutLRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLRYSShareOut", c("name", "description")] <- c("eqCnsLESupOutLRYSShareOut", "");
    rs["eqCnsLESupOutLRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLRYS", c("name", "description")] <- c("eqCnsLESupOutLRYS", "");
    rs["eqCnsLESupOutLRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLRYSGrowth", c("name", "description")] <- c("eqCnsLESupOutLRYSGrowth", "");
    rs["eqCnsLESupOutLRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRYSShareIn", c("name", "description")] <- c("eqCnsGESupOutLRYSShareIn", "");
    rs["eqCnsGESupOutLRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLRYSShareOut", c("name", "description")] <- c("eqCnsGESupOutLRYSShareOut", "");
    rs["eqCnsGESupOutLRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLRYS", c("name", "description")] <- c("eqCnsGESupOutLRYS", "");
    rs["eqCnsGESupOutLRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLRYSGrowth", c("name", "description")] <- c("eqCnsGESupOutLRYSGrowth", "");
    rs["eqCnsGESupOutLRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRYSShareIn", c("name", "description")] <- c("eqCnsESupOutLRYSShareIn", "");
    rs["eqCnsESupOutLRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLRYSShareOut", c("name", "description")] <- c("eqCnsESupOutLRYSShareOut", "");
    rs["eqCnsESupOutLRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLRYS", c("name", "description")] <- c("eqCnsESupOutLRYS", "");
    rs["eqCnsESupOutLRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLRYSGrowth", c("name", "description")] <- c("eqCnsESupOutLRYSGrowth", "");
    rs["eqCnsESupOutLRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCShareIn", c("name", "description")] <- c("eqCnsLESupOutLCShareIn", "");
    rs["eqCnsLESupOutLCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCShareOut", c("name", "description")] <- c("eqCnsLESupOutLCShareOut", "");
    rs["eqCnsLESupOutLCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLC", c("name", "description")] <- c("eqCnsLESupOutLC", "");
    rs["eqCnsLESupOutLC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCShareIn", c("name", "description")] <- c("eqCnsGESupOutLCShareIn", "");
    rs["eqCnsGESupOutLCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCShareOut", c("name", "description")] <- c("eqCnsGESupOutLCShareOut", "");
    rs["eqCnsGESupOutLCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLC", c("name", "description")] <- c("eqCnsGESupOutLC", "");
    rs["eqCnsGESupOutLC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCShareIn", c("name", "description")] <- c("eqCnsESupOutLCShareIn", "");
    rs["eqCnsESupOutLCShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCShareOut", c("name", "description")] <- c("eqCnsESupOutLCShareOut", "");
    rs["eqCnsESupOutLCShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLC", c("name", "description")] <- c("eqCnsESupOutLC", "");
    rs["eqCnsESupOutLC", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCSShareIn", c("name", "description")] <- c("eqCnsLESupOutLCSShareIn", "");
    rs["eqCnsLESupOutLCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCSShareOut", c("name", "description")] <- c("eqCnsLESupOutLCSShareOut", "");
    rs["eqCnsLESupOutLCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCS", c("name", "description")] <- c("eqCnsLESupOutLCS", "");
    rs["eqCnsLESupOutLCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCSShareIn", c("name", "description")] <- c("eqCnsGESupOutLCSShareIn", "");
    rs["eqCnsGESupOutLCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCSShareOut", c("name", "description")] <- c("eqCnsGESupOutLCSShareOut", "");
    rs["eqCnsGESupOutLCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCS", c("name", "description")] <- c("eqCnsGESupOutLCS", "");
    rs["eqCnsGESupOutLCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCSShareIn", c("name", "description")] <- c("eqCnsESupOutLCSShareIn", "");
    rs["eqCnsESupOutLCSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCSShareOut", c("name", "description")] <- c("eqCnsESupOutLCSShareOut", "");
    rs["eqCnsESupOutLCSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCS", c("name", "description")] <- c("eqCnsESupOutLCS", "");
    rs["eqCnsESupOutLCS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCYShareIn", c("name", "description")] <- c("eqCnsLESupOutLCYShareIn", "");
    rs["eqCnsLESupOutLCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCYShareOut", c("name", "description")] <- c("eqCnsLESupOutLCYShareOut", "");
    rs["eqCnsLESupOutLCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCY", c("name", "description")] <- c("eqCnsLESupOutLCY", "");
    rs["eqCnsLESupOutLCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCYGrowth", c("name", "description")] <- c("eqCnsLESupOutLCYGrowth", "");
    rs["eqCnsLESupOutLCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCYShareIn", c("name", "description")] <- c("eqCnsGESupOutLCYShareIn", "");
    rs["eqCnsGESupOutLCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCYShareOut", c("name", "description")] <- c("eqCnsGESupOutLCYShareOut", "");
    rs["eqCnsGESupOutLCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCY", c("name", "description")] <- c("eqCnsGESupOutLCY", "");
    rs["eqCnsGESupOutLCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCYGrowth", c("name", "description")] <- c("eqCnsGESupOutLCYGrowth", "");
    rs["eqCnsGESupOutLCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCYShareIn", c("name", "description")] <- c("eqCnsESupOutLCYShareIn", "");
    rs["eqCnsESupOutLCYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCYShareOut", c("name", "description")] <- c("eqCnsESupOutLCYShareOut", "");
    rs["eqCnsESupOutLCYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCY", c("name", "description")] <- c("eqCnsESupOutLCY", "");
    rs["eqCnsESupOutLCY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCYGrowth", c("name", "description")] <- c("eqCnsESupOutLCYGrowth", "");
    rs["eqCnsESupOutLCYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCYSShareIn", c("name", "description")] <- c("eqCnsLESupOutLCYSShareIn", "");
    rs["eqCnsLESupOutLCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCYSShareOut", c("name", "description")] <- c("eqCnsLESupOutLCYSShareOut", "");
    rs["eqCnsLESupOutLCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCYS", c("name", "description")] <- c("eqCnsLESupOutLCYS", "");
    rs["eqCnsLESupOutLCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCYSGrowth", c("name", "description")] <- c("eqCnsLESupOutLCYSGrowth", "");
    rs["eqCnsLESupOutLCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCYSShareIn", c("name", "description")] <- c("eqCnsGESupOutLCYSShareIn", "");
    rs["eqCnsGESupOutLCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCYSShareOut", c("name", "description")] <- c("eqCnsGESupOutLCYSShareOut", "");
    rs["eqCnsGESupOutLCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCYS", c("name", "description")] <- c("eqCnsGESupOutLCYS", "");
    rs["eqCnsGESupOutLCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCYSGrowth", c("name", "description")] <- c("eqCnsGESupOutLCYSGrowth", "");
    rs["eqCnsGESupOutLCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCYSShareIn", c("name", "description")] <- c("eqCnsESupOutLCYSShareIn", "");
    rs["eqCnsESupOutLCYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCYSShareOut", c("name", "description")] <- c("eqCnsESupOutLCYSShareOut", "");
    rs["eqCnsESupOutLCYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCYS", c("name", "description")] <- c("eqCnsESupOutLCYS", "");
    rs["eqCnsESupOutLCYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCYSGrowth", c("name", "description")] <- c("eqCnsESupOutLCYSGrowth", "");
    rs["eqCnsESupOutLCYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRShareIn", c("name", "description")] <- c("eqCnsLESupOutLCRShareIn", "");
    rs["eqCnsLESupOutLCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCRShareOut", c("name", "description")] <- c("eqCnsLESupOutLCRShareOut", "");
    rs["eqCnsLESupOutLCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCR", c("name", "description")] <- c("eqCnsLESupOutLCR", "");
    rs["eqCnsLESupOutLCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRShareIn", c("name", "description")] <- c("eqCnsGESupOutLCRShareIn", "");
    rs["eqCnsGESupOutLCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCRShareOut", c("name", "description")] <- c("eqCnsGESupOutLCRShareOut", "");
    rs["eqCnsGESupOutLCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCR", c("name", "description")] <- c("eqCnsGESupOutLCR", "");
    rs["eqCnsGESupOutLCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRShareIn", c("name", "description")] <- c("eqCnsESupOutLCRShareIn", "");
    rs["eqCnsESupOutLCRShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCRShareOut", c("name", "description")] <- c("eqCnsESupOutLCRShareOut", "");
    rs["eqCnsESupOutLCRShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCR", c("name", "description")] <- c("eqCnsESupOutLCR", "");
    rs["eqCnsESupOutLCR", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRSShareIn", c("name", "description")] <- c("eqCnsLESupOutLCRSShareIn", "");
    rs["eqCnsLESupOutLCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCRSShareOut", c("name", "description")] <- c("eqCnsLESupOutLCRSShareOut", "");
    rs["eqCnsLESupOutLCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCRS", c("name", "description")] <- c("eqCnsLESupOutLCRS", "");
    rs["eqCnsLESupOutLCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRSShareIn", c("name", "description")] <- c("eqCnsGESupOutLCRSShareIn", "");
    rs["eqCnsGESupOutLCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCRSShareOut", c("name", "description")] <- c("eqCnsGESupOutLCRSShareOut", "");
    rs["eqCnsGESupOutLCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCRS", c("name", "description")] <- c("eqCnsGESupOutLCRS", "");
    rs["eqCnsGESupOutLCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRSShareIn", c("name", "description")] <- c("eqCnsESupOutLCRSShareIn", "");
    rs["eqCnsESupOutLCRSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCRSShareOut", c("name", "description")] <- c("eqCnsESupOutLCRSShareOut", "");
    rs["eqCnsESupOutLCRSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCRS", c("name", "description")] <- c("eqCnsESupOutLCRS", "");
    rs["eqCnsESupOutLCRS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRYShareIn", c("name", "description")] <- c("eqCnsLESupOutLCRYShareIn", "");
    rs["eqCnsLESupOutLCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCRYShareOut", c("name", "description")] <- c("eqCnsLESupOutLCRYShareOut", "");
    rs["eqCnsLESupOutLCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCRY", c("name", "description")] <- c("eqCnsLESupOutLCRY", "");
    rs["eqCnsLESupOutLCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRYGrowth", c("name", "description")] <- c("eqCnsLESupOutLCRYGrowth", "");
    rs["eqCnsLESupOutLCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRYShareIn", c("name", "description")] <- c("eqCnsGESupOutLCRYShareIn", "");
    rs["eqCnsGESupOutLCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCRYShareOut", c("name", "description")] <- c("eqCnsGESupOutLCRYShareOut", "");
    rs["eqCnsGESupOutLCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCRY", c("name", "description")] <- c("eqCnsGESupOutLCRY", "");
    rs["eqCnsGESupOutLCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRYGrowth", c("name", "description")] <- c("eqCnsGESupOutLCRYGrowth", "");
    rs["eqCnsGESupOutLCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRYShareIn", c("name", "description")] <- c("eqCnsESupOutLCRYShareIn", "");
    rs["eqCnsESupOutLCRYShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCRYShareOut", c("name", "description")] <- c("eqCnsESupOutLCRYShareOut", "");
    rs["eqCnsESupOutLCRYShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCRY", c("name", "description")] <- c("eqCnsESupOutLCRY", "");
    rs["eqCnsESupOutLCRY", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRYGrowth", c("name", "description")] <- c("eqCnsESupOutLCRYGrowth", "");
    rs["eqCnsESupOutLCRYGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRYSShareIn", c("name", "description")] <- c("eqCnsLESupOutLCRYSShareIn", "");
    rs["eqCnsLESupOutLCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsLESupOutLCRYSShareOut", c("name", "description")] <- c("eqCnsLESupOutLCRYSShareOut", "");
    rs["eqCnsLESupOutLCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsLESupOutLCRYS", c("name", "description")] <- c("eqCnsLESupOutLCRYS", "");
    rs["eqCnsLESupOutLCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLESupOutLCRYSGrowth", c("name", "description")] <- c("eqCnsLESupOutLCRYSGrowth", "");
    rs["eqCnsLESupOutLCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRYSShareIn", c("name", "description")] <- c("eqCnsGESupOutLCRYSShareIn", "");
    rs["eqCnsGESupOutLCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsGESupOutLCRYSShareOut", c("name", "description")] <- c("eqCnsGESupOutLCRYSShareOut", "");
    rs["eqCnsGESupOutLCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsGESupOutLCRYS", c("name", "description")] <- c("eqCnsGESupOutLCRYS", "");
    rs["eqCnsGESupOutLCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsGESupOutLCRYSGrowth", c("name", "description")] <- c("eqCnsGESupOutLCRYSGrowth", "");
    rs["eqCnsGESupOutLCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRYSShareIn", c("name", "description")] <- c("eqCnsESupOutLCRYSShareIn", "");
    rs["eqCnsESupOutLCRYSShareIn", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vInpTot")] <- TRUE;
    rs["eqCnsESupOutLCRYSShareOut", c("name", "description")] <- c("eqCnsESupOutLCRYSShareOut", "");
    rs["eqCnsESupOutLCRYSShareOut", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut", "vOutTot")] <- TRUE;
    rs["eqCnsESupOutLCRYS", c("name", "description")] <- c("eqCnsESupOutLCRYS", "");
    rs["eqCnsESupOutLCRYS", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsESupOutLCRYSGrowth", c("name", "description")] <- c("eqCnsESupOutLCRYSGrowth", "");
    rs["eqCnsESupOutLCRYSGrowth", c("sup", "comm", "region", "year", "slice", "cns", "vSupOut")] <- TRUE;
    rs["eqCnsLETotInp", c("name", "description")] <- c("eqCnsLETotInp", "");
    rs["eqCnsLETotInp", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInp", c("name", "description")] <- c("eqCnsGETotInp", "");
    rs["eqCnsGETotInp", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInp", c("name", "description")] <- c("eqCnsETotInp", "");
    rs["eqCnsETotInp", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpS", c("name", "description")] <- c("eqCnsLETotInpS", "");
    rs["eqCnsLETotInpS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpS", c("name", "description")] <- c("eqCnsGETotInpS", "");
    rs["eqCnsGETotInpS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpS", c("name", "description")] <- c("eqCnsETotInpS", "");
    rs["eqCnsETotInpS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpY", c("name", "description")] <- c("eqCnsLETotInpY", "");
    rs["eqCnsLETotInpY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpYGrowth", c("name", "description")] <- c("eqCnsLETotInpYGrowth", "");
    rs["eqCnsLETotInpYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpY", c("name", "description")] <- c("eqCnsGETotInpY", "");
    rs["eqCnsGETotInpY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpYGrowth", c("name", "description")] <- c("eqCnsGETotInpYGrowth", "");
    rs["eqCnsGETotInpYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpY", c("name", "description")] <- c("eqCnsETotInpY", "");
    rs["eqCnsETotInpY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpYGrowth", c("name", "description")] <- c("eqCnsETotInpYGrowth", "");
    rs["eqCnsETotInpYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpYS", c("name", "description")] <- c("eqCnsLETotInpYS", "");
    rs["eqCnsLETotInpYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpYSGrowth", c("name", "description")] <- c("eqCnsLETotInpYSGrowth", "");
    rs["eqCnsLETotInpYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpYS", c("name", "description")] <- c("eqCnsGETotInpYS", "");
    rs["eqCnsGETotInpYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpYSGrowth", c("name", "description")] <- c("eqCnsGETotInpYSGrowth", "");
    rs["eqCnsGETotInpYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpYS", c("name", "description")] <- c("eqCnsETotInpYS", "");
    rs["eqCnsETotInpYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpYSGrowth", c("name", "description")] <- c("eqCnsETotInpYSGrowth", "");
    rs["eqCnsETotInpYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpR", c("name", "description")] <- c("eqCnsLETotInpR", "");
    rs["eqCnsLETotInpR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpR", c("name", "description")] <- c("eqCnsGETotInpR", "");
    rs["eqCnsGETotInpR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpR", c("name", "description")] <- c("eqCnsETotInpR", "");
    rs["eqCnsETotInpR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpRS", c("name", "description")] <- c("eqCnsLETotInpRS", "");
    rs["eqCnsLETotInpRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpRS", c("name", "description")] <- c("eqCnsGETotInpRS", "");
    rs["eqCnsGETotInpRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpRS", c("name", "description")] <- c("eqCnsETotInpRS", "");
    rs["eqCnsETotInpRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpRY", c("name", "description")] <- c("eqCnsLETotInpRY", "");
    rs["eqCnsLETotInpRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpRYGrowth", c("name", "description")] <- c("eqCnsLETotInpRYGrowth", "");
    rs["eqCnsLETotInpRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpRY", c("name", "description")] <- c("eqCnsGETotInpRY", "");
    rs["eqCnsGETotInpRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpRYGrowth", c("name", "description")] <- c("eqCnsGETotInpRYGrowth", "");
    rs["eqCnsGETotInpRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpRY", c("name", "description")] <- c("eqCnsETotInpRY", "");
    rs["eqCnsETotInpRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpRYGrowth", c("name", "description")] <- c("eqCnsETotInpRYGrowth", "");
    rs["eqCnsETotInpRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpRYS", c("name", "description")] <- c("eqCnsLETotInpRYS", "");
    rs["eqCnsLETotInpRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpRYSGrowth", c("name", "description")] <- c("eqCnsLETotInpRYSGrowth", "");
    rs["eqCnsLETotInpRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpRYS", c("name", "description")] <- c("eqCnsGETotInpRYS", "");
    rs["eqCnsGETotInpRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpRYSGrowth", c("name", "description")] <- c("eqCnsGETotInpRYSGrowth", "");
    rs["eqCnsGETotInpRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpRYS", c("name", "description")] <- c("eqCnsETotInpRYS", "");
    rs["eqCnsETotInpRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpRYSGrowth", c("name", "description")] <- c("eqCnsETotInpRYSGrowth", "");
    rs["eqCnsETotInpRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpC", c("name", "description")] <- c("eqCnsLETotInpC", "");
    rs["eqCnsLETotInpC", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpC", c("name", "description")] <- c("eqCnsGETotInpC", "");
    rs["eqCnsGETotInpC", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpC", c("name", "description")] <- c("eqCnsETotInpC", "");
    rs["eqCnsETotInpC", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCS", c("name", "description")] <- c("eqCnsLETotInpCS", "");
    rs["eqCnsLETotInpCS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCS", c("name", "description")] <- c("eqCnsGETotInpCS", "");
    rs["eqCnsGETotInpCS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCS", c("name", "description")] <- c("eqCnsETotInpCS", "");
    rs["eqCnsETotInpCS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCY", c("name", "description")] <- c("eqCnsLETotInpCY", "");
    rs["eqCnsLETotInpCY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCYGrowth", c("name", "description")] <- c("eqCnsLETotInpCYGrowth", "");
    rs["eqCnsLETotInpCYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCY", c("name", "description")] <- c("eqCnsGETotInpCY", "");
    rs["eqCnsGETotInpCY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCYGrowth", c("name", "description")] <- c("eqCnsGETotInpCYGrowth", "");
    rs["eqCnsGETotInpCYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCY", c("name", "description")] <- c("eqCnsETotInpCY", "");
    rs["eqCnsETotInpCY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCYGrowth", c("name", "description")] <- c("eqCnsETotInpCYGrowth", "");
    rs["eqCnsETotInpCYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCYS", c("name", "description")] <- c("eqCnsLETotInpCYS", "");
    rs["eqCnsLETotInpCYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCYSGrowth", c("name", "description")] <- c("eqCnsLETotInpCYSGrowth", "");
    rs["eqCnsLETotInpCYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCYS", c("name", "description")] <- c("eqCnsGETotInpCYS", "");
    rs["eqCnsGETotInpCYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCYSGrowth", c("name", "description")] <- c("eqCnsGETotInpCYSGrowth", "");
    rs["eqCnsGETotInpCYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCYS", c("name", "description")] <- c("eqCnsETotInpCYS", "");
    rs["eqCnsETotInpCYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCYSGrowth", c("name", "description")] <- c("eqCnsETotInpCYSGrowth", "");
    rs["eqCnsETotInpCYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCR", c("name", "description")] <- c("eqCnsLETotInpCR", "");
    rs["eqCnsLETotInpCR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCR", c("name", "description")] <- c("eqCnsGETotInpCR", "");
    rs["eqCnsGETotInpCR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCR", c("name", "description")] <- c("eqCnsETotInpCR", "");
    rs["eqCnsETotInpCR", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCRS", c("name", "description")] <- c("eqCnsLETotInpCRS", "");
    rs["eqCnsLETotInpCRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCRS", c("name", "description")] <- c("eqCnsGETotInpCRS", "");
    rs["eqCnsGETotInpCRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCRS", c("name", "description")] <- c("eqCnsETotInpCRS", "");
    rs["eqCnsETotInpCRS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCRY", c("name", "description")] <- c("eqCnsLETotInpCRY", "");
    rs["eqCnsLETotInpCRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCRYGrowth", c("name", "description")] <- c("eqCnsLETotInpCRYGrowth", "");
    rs["eqCnsLETotInpCRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCRY", c("name", "description")] <- c("eqCnsGETotInpCRY", "");
    rs["eqCnsGETotInpCRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCRYGrowth", c("name", "description")] <- c("eqCnsGETotInpCRYGrowth", "");
    rs["eqCnsGETotInpCRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCRY", c("name", "description")] <- c("eqCnsETotInpCRY", "");
    rs["eqCnsETotInpCRY", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCRYGrowth", c("name", "description")] <- c("eqCnsETotInpCRYGrowth", "");
    rs["eqCnsETotInpCRYGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCRYS", c("name", "description")] <- c("eqCnsLETotInpCRYS", "");
    rs["eqCnsLETotInpCRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotInpCRYSGrowth", c("name", "description")] <- c("eqCnsLETotInpCRYSGrowth", "");
    rs["eqCnsLETotInpCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCRYS", c("name", "description")] <- c("eqCnsGETotInpCRYS", "");
    rs["eqCnsGETotInpCRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsGETotInpCRYSGrowth", c("name", "description")] <- c("eqCnsGETotInpCRYSGrowth", "");
    rs["eqCnsGETotInpCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCRYS", c("name", "description")] <- c("eqCnsETotInpCRYS", "");
    rs["eqCnsETotInpCRYS", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsETotInpCRYSGrowth", c("name", "description")] <- c("eqCnsETotInpCRYSGrowth", "");
    rs["eqCnsETotInpCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vInpTot")] <- TRUE;
    rs["eqCnsLETotOut", c("name", "description")] <- c("eqCnsLETotOut", "");
    rs["eqCnsLETotOut", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOut", c("name", "description")] <- c("eqCnsGETotOut", "");
    rs["eqCnsGETotOut", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOut", c("name", "description")] <- c("eqCnsETotOut", "");
    rs["eqCnsETotOut", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutS", c("name", "description")] <- c("eqCnsLETotOutS", "");
    rs["eqCnsLETotOutS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutS", c("name", "description")] <- c("eqCnsGETotOutS", "");
    rs["eqCnsGETotOutS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutS", c("name", "description")] <- c("eqCnsETotOutS", "");
    rs["eqCnsETotOutS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutY", c("name", "description")] <- c("eqCnsLETotOutY", "");
    rs["eqCnsLETotOutY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutYGrowth", c("name", "description")] <- c("eqCnsLETotOutYGrowth", "");
    rs["eqCnsLETotOutYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutY", c("name", "description")] <- c("eqCnsGETotOutY", "");
    rs["eqCnsGETotOutY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutYGrowth", c("name", "description")] <- c("eqCnsGETotOutYGrowth", "");
    rs["eqCnsGETotOutYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutY", c("name", "description")] <- c("eqCnsETotOutY", "");
    rs["eqCnsETotOutY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutYGrowth", c("name", "description")] <- c("eqCnsETotOutYGrowth", "");
    rs["eqCnsETotOutYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutYS", c("name", "description")] <- c("eqCnsLETotOutYS", "");
    rs["eqCnsLETotOutYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutYSGrowth", c("name", "description")] <- c("eqCnsLETotOutYSGrowth", "");
    rs["eqCnsLETotOutYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutYS", c("name", "description")] <- c("eqCnsGETotOutYS", "");
    rs["eqCnsGETotOutYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutYSGrowth", c("name", "description")] <- c("eqCnsGETotOutYSGrowth", "");
    rs["eqCnsGETotOutYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutYS", c("name", "description")] <- c("eqCnsETotOutYS", "");
    rs["eqCnsETotOutYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutYSGrowth", c("name", "description")] <- c("eqCnsETotOutYSGrowth", "");
    rs["eqCnsETotOutYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutR", c("name", "description")] <- c("eqCnsLETotOutR", "");
    rs["eqCnsLETotOutR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutR", c("name", "description")] <- c("eqCnsGETotOutR", "");
    rs["eqCnsGETotOutR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutR", c("name", "description")] <- c("eqCnsETotOutR", "");
    rs["eqCnsETotOutR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutRS", c("name", "description")] <- c("eqCnsLETotOutRS", "");
    rs["eqCnsLETotOutRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutRS", c("name", "description")] <- c("eqCnsGETotOutRS", "");
    rs["eqCnsGETotOutRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutRS", c("name", "description")] <- c("eqCnsETotOutRS", "");
    rs["eqCnsETotOutRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutRY", c("name", "description")] <- c("eqCnsLETotOutRY", "");
    rs["eqCnsLETotOutRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutRYGrowth", c("name", "description")] <- c("eqCnsLETotOutRYGrowth", "");
    rs["eqCnsLETotOutRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutRY", c("name", "description")] <- c("eqCnsGETotOutRY", "");
    rs["eqCnsGETotOutRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutRYGrowth", c("name", "description")] <- c("eqCnsGETotOutRYGrowth", "");
    rs["eqCnsGETotOutRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutRY", c("name", "description")] <- c("eqCnsETotOutRY", "");
    rs["eqCnsETotOutRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutRYGrowth", c("name", "description")] <- c("eqCnsETotOutRYGrowth", "");
    rs["eqCnsETotOutRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutRYS", c("name", "description")] <- c("eqCnsLETotOutRYS", "");
    rs["eqCnsLETotOutRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutRYSGrowth", c("name", "description")] <- c("eqCnsLETotOutRYSGrowth", "");
    rs["eqCnsLETotOutRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutRYS", c("name", "description")] <- c("eqCnsGETotOutRYS", "");
    rs["eqCnsGETotOutRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutRYSGrowth", c("name", "description")] <- c("eqCnsGETotOutRYSGrowth", "");
    rs["eqCnsGETotOutRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutRYS", c("name", "description")] <- c("eqCnsETotOutRYS", "");
    rs["eqCnsETotOutRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutRYSGrowth", c("name", "description")] <- c("eqCnsETotOutRYSGrowth", "");
    rs["eqCnsETotOutRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutC", c("name", "description")] <- c("eqCnsLETotOutC", "");
    rs["eqCnsLETotOutC", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutC", c("name", "description")] <- c("eqCnsGETotOutC", "");
    rs["eqCnsGETotOutC", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutC", c("name", "description")] <- c("eqCnsETotOutC", "");
    rs["eqCnsETotOutC", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCS", c("name", "description")] <- c("eqCnsLETotOutCS", "");
    rs["eqCnsLETotOutCS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCS", c("name", "description")] <- c("eqCnsGETotOutCS", "");
    rs["eqCnsGETotOutCS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCS", c("name", "description")] <- c("eqCnsETotOutCS", "");
    rs["eqCnsETotOutCS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCY", c("name", "description")] <- c("eqCnsLETotOutCY", "");
    rs["eqCnsLETotOutCY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCYGrowth", c("name", "description")] <- c("eqCnsLETotOutCYGrowth", "");
    rs["eqCnsLETotOutCYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCY", c("name", "description")] <- c("eqCnsGETotOutCY", "");
    rs["eqCnsGETotOutCY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCYGrowth", c("name", "description")] <- c("eqCnsGETotOutCYGrowth", "");
    rs["eqCnsGETotOutCYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCY", c("name", "description")] <- c("eqCnsETotOutCY", "");
    rs["eqCnsETotOutCY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCYGrowth", c("name", "description")] <- c("eqCnsETotOutCYGrowth", "");
    rs["eqCnsETotOutCYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCYS", c("name", "description")] <- c("eqCnsLETotOutCYS", "");
    rs["eqCnsLETotOutCYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCYSGrowth", c("name", "description")] <- c("eqCnsLETotOutCYSGrowth", "");
    rs["eqCnsLETotOutCYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCYS", c("name", "description")] <- c("eqCnsGETotOutCYS", "");
    rs["eqCnsGETotOutCYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCYSGrowth", c("name", "description")] <- c("eqCnsGETotOutCYSGrowth", "");
    rs["eqCnsGETotOutCYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCYS", c("name", "description")] <- c("eqCnsETotOutCYS", "");
    rs["eqCnsETotOutCYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCYSGrowth", c("name", "description")] <- c("eqCnsETotOutCYSGrowth", "");
    rs["eqCnsETotOutCYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCR", c("name", "description")] <- c("eqCnsLETotOutCR", "");
    rs["eqCnsLETotOutCR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCR", c("name", "description")] <- c("eqCnsGETotOutCR", "");
    rs["eqCnsGETotOutCR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCR", c("name", "description")] <- c("eqCnsETotOutCR", "");
    rs["eqCnsETotOutCR", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCRS", c("name", "description")] <- c("eqCnsLETotOutCRS", "");
    rs["eqCnsLETotOutCRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCRS", c("name", "description")] <- c("eqCnsGETotOutCRS", "");
    rs["eqCnsGETotOutCRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCRS", c("name", "description")] <- c("eqCnsETotOutCRS", "");
    rs["eqCnsETotOutCRS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCRY", c("name", "description")] <- c("eqCnsLETotOutCRY", "");
    rs["eqCnsLETotOutCRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCRYGrowth", c("name", "description")] <- c("eqCnsLETotOutCRYGrowth", "");
    rs["eqCnsLETotOutCRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCRY", c("name", "description")] <- c("eqCnsGETotOutCRY", "");
    rs["eqCnsGETotOutCRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCRYGrowth", c("name", "description")] <- c("eqCnsGETotOutCRYGrowth", "");
    rs["eqCnsGETotOutCRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCRY", c("name", "description")] <- c("eqCnsETotOutCRY", "");
    rs["eqCnsETotOutCRY", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCRYGrowth", c("name", "description")] <- c("eqCnsETotOutCRYGrowth", "");
    rs["eqCnsETotOutCRYGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCRYS", c("name", "description")] <- c("eqCnsLETotOutCRYS", "");
    rs["eqCnsLETotOutCRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsLETotOutCRYSGrowth", c("name", "description")] <- c("eqCnsLETotOutCRYSGrowth", "");
    rs["eqCnsLETotOutCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCRYS", c("name", "description")] <- c("eqCnsGETotOutCRYS", "");
    rs["eqCnsGETotOutCRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsGETotOutCRYSGrowth", c("name", "description")] <- c("eqCnsGETotOutCRYSGrowth", "");
    rs["eqCnsGETotOutCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCRYS", c("name", "description")] <- c("eqCnsETotOutCRYS", "");
    rs["eqCnsETotOutCRYS", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqCnsETotOutCRYSGrowth", c("name", "description")] <- c("eqCnsETotOutCRYSGrowth", "");
    rs["eqCnsETotOutCRYSGrowth", c("comm", "region", "year", "slice", "cns", "vOutTot")] <- TRUE;
    rs["eqLECActivity", c("name", "description")] <- c("eqLECActivity", "");
    rs["eqLECActivity", c("tech", "region", "year", "slice", "vTechAct")] <- TRUE;
    rs["eqPreDefTechUse", c("name", "description")] <- c("eqPreDefTechUse", "");
    rs["eqPreDefTechUse", c("tech", "region", "year", "slice", "vTechUse")] <- TRUE;
    rs["eqPreDefTechNewCap", c("name", "description")] <- c("eqPreDefTechNewCap", "");
    rs["eqPreDefTechNewCap", c("tech", "region", "year", "vTechNewCap")] <- TRUE;
    rs["eqPreDefTechRetirementCap", c("name", "description")] <- c("eqPreDefTechRetirementCap", "");
    rs["eqPreDefTechRetirementCap", c("tech", "region", "year", "vTechRetirementCap")] <- TRUE;
    rs["eqPreDefTechCap", c("name", "description")] <- c("eqPreDefTechCap", "");
    rs["eqPreDefTechCap", c("tech", "region", "year", "vTechCap")] <- TRUE;
    rs["eqPreDefTechAct", c("name", "description")] <- c("eqPreDefTechAct", "");
    rs["eqPreDefTechAct", c("tech", "region", "year", "slice", "vTechAct")] <- TRUE;
    rs["eqPreDefTechInp", c("name", "description")] <- c("eqPreDefTechInp", "");
    rs["eqPreDefTechInp", c("tech", "comm", "region", "year", "slice", "vTechInp")] <- TRUE;
    rs["eqPreDefTechOut", c("name", "description")] <- c("eqPreDefTechOut", "");
    rs["eqPreDefTechOut", c("tech", "comm", "region", "year", "slice", "vTechOut")] <- TRUE;
    rs["eqPreDefTechAInp", c("name", "description")] <- c("eqPreDefTechAInp", "");
    rs["eqPreDefTechAInp", c("tech", "comm", "region", "year", "slice", "vTechAInp")] <- TRUE;
    rs["eqPreDefTechAOut", c("name", "description")] <- c("eqPreDefTechAOut", "");
    rs["eqPreDefTechAOut", c("tech", "comm", "region", "year", "slice", "vTechAOut")] <- TRUE;
    rs["eqPreDefSupOut", c("name", "description")] <- c("eqPreDefSupOut", "");
    rs["eqPreDefSupOut", c("sup", "comm", "region", "year", "slice", "vSupOut")] <- TRUE;
    rs["eqPreDefDemInp", c("name", "description")] <- c("eqPreDefDemInp", "");
    rs["eqPreDefDemInp", c("comm", "region", "year", "slice", "vDemInp")] <- TRUE;
    rs["eqPreDefDumOut", c("name", "description")] <- c("eqPreDefDumOut", "");
    rs["eqPreDefDumOut", c("comm", "region", "year", "slice", "vDumOut")] <- TRUE;
    rs["eqPreDefStorageInp", c("name", "description")] <- c("eqPreDefStorageInp", "");
    rs["eqPreDefStorageInp", c("stg", "comm", "region", "year", "slice", "vStorageInp")] <- TRUE;
    rs["eqPreDefStorageOut", c("name", "description")] <- c("eqPreDefStorageOut", "");
    rs["eqPreDefStorageOut", c("stg", "comm", "region", "year", "slice", "vStorageOut")] <- TRUE;
    rs["eqPreDefStorageStore", c("name", "description")] <- c("eqPreDefStorageStore", "");
    rs["eqPreDefStorageStore", c("stg", "region", "year", "slice", "vStorageStore")] <- TRUE;
    rs["eqPreDefStorageCap", c("name", "description")] <- c("eqPreDefStorageCap", "");
    rs["eqPreDefStorageCap", c("stg", "region", "year", "vStorageCap")] <- TRUE;
    rs["eqPreDefStorageNewCap", c("name", "description")] <- c("eqPreDefStorageNewCap", "");
    rs["eqPreDefStorageNewCap", c("stg", "region", "year", "vStorageNewCap")] <- TRUE;
    rs["eqPreDefImport", c("name", "description")] <- c("eqPreDefImport", "");
    rs["eqPreDefImport", c("comm", "region", "year", "slice", "vImport")] <- TRUE;
    rs["eqPreDefExport", c("name", "description")] <- c("eqPreDefExport", "");
    rs["eqPreDefExport", c("comm", "region", "year", "slice", "vExport")] <- TRUE;
    rs["eqPreDefTradeIr", c("name", "description")] <- c("eqPreDefTradeIr", "");
    rs["eqPreDefTradeIr", c("trade", "region", "year", "slice", "vTradeIr")] <- TRUE;
    rs["eqPreDefExportRow", c("name", "description")] <- c("eqPreDefExportRow", "");
    rs["eqPreDefExportRow", c("expp", "region", "year", "slice", "vExportRow")] <- TRUE;
    rs["eqPreDefImportRow", c("name", "description")] <- c("eqPreDefImportRow", "");
    rs["eqPreDefImportRow", c("imp", "region", "year", "slice", "vImportRow")] <- TRUE;
    rs[, -(1:2)][is.na(rs[, -(1:2)])] <- FALSE;
rs
}
getVariables <- function() {
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
   cns  = logical(),
   eqTechSng2Sng  = logical(),
   eqTechGrp2Sng  = logical(),
   eqTechSng2Grp  = logical(),
   eqTechGrp2Grp  = logical(),
   eqTechUse2Sng  = logical(),
   eqTechUse2Grp  = logical(),
   eqTechShareInpLo  = logical(),
   eqTechShareInpUp  = logical(),
   eqTechShareOutLo  = logical(),
   eqTechShareOutUp  = logical(),
   eqTechAInp  = logical(),
   eqTechAOut  = logical(),
   eqTechAfaLo  = logical(),
   eqTechAfaUp  = logical(),
   eqTechActSng  = logical(),
   eqTechActGrp  = logical(),
   eqTechAfacLo  = logical(),
   eqTechAfacUp  = logical(),
   eqTechCap  = logical(),
   eqTechNewCap  = logical(),
   eqTechEac  = logical(),
   eqTechInv  = logical(),
   eqTechSalv2  = logical(),
   eqTechSalv3  = logical(),
   eqTechCost1  = logical(),
   eqTechCost2  = logical(),
   eqTechFixom  = logical(),
   eqTechVarom  = logical(),
   eqTechActVarom  = logical(),
   eqTechCVarom  = logical(),
   eqTechAVarom  = logical(),
   eqSupAvaUp  = logical(),
   eqSupAvaLo  = logical(),
   eqSupReserve  = logical(),
   eqSupReserveCheck  = logical(),
   eqSupCost  = logical(),
   eqDemInp  = logical(),
   eqAggOut  = logical(),
   eqEmsFuelTot  = logical(),
   eqTechEmsFuel  = logical(),
   eqStorageStore  = logical(),
   eqStorageCap  = logical(),
   eqStorageInv  = logical(),
   eqStorageFix  = logical(),
   eqStorageSalv2  = logical(),
   eqStorageSalv3  = logical(),
   eqStorageVar  = logical(),
   eqStorageCost  = logical(),
   eqStorageLo  = logical(),
   eqStorageUp  = logical(),
   eqImport  = logical(),
   eqExport  = logical(),
   eqTradeFlowUp  = logical(),
   eqTradeFlowLo  = logical(),
   eqCostTrade  = logical(),
   eqCostRowTrade  = logical(),
   eqCostIrTrade  = logical(),
   eqExportRowUp  = logical(),
   eqExportRowLo  = logical(),
   eqExportRowRes  = logical(),
   eqExportRowResUp  = logical(),
   eqImportRowUp  = logical(),
   eqImportRowLo  = logical(),
   eqImportRowRes  = logical(),
   eqImportRowResUp  = logical(),
   eqBalUp  = logical(),
   eqBalLo  = logical(),
   eqBalFx  = logical(),
   eqBal  = logical(),
   eqOutTot  = logical(),
   eqInpTot  = logical(),
   eqSupOutTot  = logical(),
   eqTechInpTot  = logical(),
   eqTechOutTot  = logical(),
   eqStorageInpTot  = logical(),
   eqStorageOutTot  = logical(),
   eqDumCost  = logical(),
   eqCost1  = logical(),
   eqCost2  = logical(),
   eqObjective  = logical(),
   eqTaxCost  = logical(),
   eqSubsCost  = logical(),
   eqCnsLETechInpShareIn  = logical(),
   eqCnsLETechInpShareOut  = logical(),
   eqCnsLETechInp  = logical(),
   eqCnsGETechInpShareIn  = logical(),
   eqCnsGETechInpShareOut  = logical(),
   eqCnsGETechInp  = logical(),
   eqCnsETechInpShareIn  = logical(),
   eqCnsETechInpShareOut  = logical(),
   eqCnsETechInp  = logical(),
   eqCnsLETechInpSShareIn  = logical(),
   eqCnsLETechInpSShareOut  = logical(),
   eqCnsLETechInpS  = logical(),
   eqCnsGETechInpSShareIn  = logical(),
   eqCnsGETechInpSShareOut  = logical(),
   eqCnsGETechInpS  = logical(),
   eqCnsETechInpSShareIn  = logical(),
   eqCnsETechInpSShareOut  = logical(),
   eqCnsETechInpS  = logical(),
   eqCnsLETechInpYShareIn  = logical(),
   eqCnsLETechInpYShareOut  = logical(),
   eqCnsLETechInpY  = logical(),
   eqCnsLETechInpYGrowth  = logical(),
   eqCnsGETechInpYShareIn  = logical(),
   eqCnsGETechInpYShareOut  = logical(),
   eqCnsGETechInpY  = logical(),
   eqCnsGETechInpYGrowth  = logical(),
   eqCnsETechInpYShareIn  = logical(),
   eqCnsETechInpYShareOut  = logical(),
   eqCnsETechInpY  = logical(),
   eqCnsETechInpYGrowth  = logical(),
   eqCnsLETechInpYSShareIn  = logical(),
   eqCnsLETechInpYSShareOut  = logical(),
   eqCnsLETechInpYS  = logical(),
   eqCnsLETechInpYSGrowth  = logical(),
   eqCnsGETechInpYSShareIn  = logical(),
   eqCnsGETechInpYSShareOut  = logical(),
   eqCnsGETechInpYS  = logical(),
   eqCnsGETechInpYSGrowth  = logical(),
   eqCnsETechInpYSShareIn  = logical(),
   eqCnsETechInpYSShareOut  = logical(),
   eqCnsETechInpYS  = logical(),
   eqCnsETechInpYSGrowth  = logical(),
   eqCnsLETechInpRShareIn  = logical(),
   eqCnsLETechInpRShareOut  = logical(),
   eqCnsLETechInpR  = logical(),
   eqCnsGETechInpRShareIn  = logical(),
   eqCnsGETechInpRShareOut  = logical(),
   eqCnsGETechInpR  = logical(),
   eqCnsETechInpRShareIn  = logical(),
   eqCnsETechInpRShareOut  = logical(),
   eqCnsETechInpR  = logical(),
   eqCnsLETechInpRSShareIn  = logical(),
   eqCnsLETechInpRSShareOut  = logical(),
   eqCnsLETechInpRS  = logical(),
   eqCnsGETechInpRSShareIn  = logical(),
   eqCnsGETechInpRSShareOut  = logical(),
   eqCnsGETechInpRS  = logical(),
   eqCnsETechInpRSShareIn  = logical(),
   eqCnsETechInpRSShareOut  = logical(),
   eqCnsETechInpRS  = logical(),
   eqCnsLETechInpRYShareIn  = logical(),
   eqCnsLETechInpRYShareOut  = logical(),
   eqCnsLETechInpRY  = logical(),
   eqCnsLETechInpRYGrowth  = logical(),
   eqCnsGETechInpRYShareIn  = logical(),
   eqCnsGETechInpRYShareOut  = logical(),
   eqCnsGETechInpRY  = logical(),
   eqCnsGETechInpRYGrowth  = logical(),
   eqCnsETechInpRYShareIn  = logical(),
   eqCnsETechInpRYShareOut  = logical(),
   eqCnsETechInpRY  = logical(),
   eqCnsETechInpRYGrowth  = logical(),
   eqCnsLETechInpRYSShareIn  = logical(),
   eqCnsLETechInpRYSShareOut  = logical(),
   eqCnsLETechInpRYS  = logical(),
   eqCnsLETechInpRYSGrowth  = logical(),
   eqCnsGETechInpRYSShareIn  = logical(),
   eqCnsGETechInpRYSShareOut  = logical(),
   eqCnsGETechInpRYS  = logical(),
   eqCnsGETechInpRYSGrowth  = logical(),
   eqCnsETechInpRYSShareIn  = logical(),
   eqCnsETechInpRYSShareOut  = logical(),
   eqCnsETechInpRYS  = logical(),
   eqCnsETechInpRYSGrowth  = logical(),
   eqCnsLETechInpCShareIn  = logical(),
   eqCnsLETechInpCShareOut  = logical(),
   eqCnsLETechInpC  = logical(),
   eqCnsGETechInpCShareIn  = logical(),
   eqCnsGETechInpCShareOut  = logical(),
   eqCnsGETechInpC  = logical(),
   eqCnsETechInpCShareIn  = logical(),
   eqCnsETechInpCShareOut  = logical(),
   eqCnsETechInpC  = logical(),
   eqCnsLETechInpCSShareIn  = logical(),
   eqCnsLETechInpCSShareOut  = logical(),
   eqCnsLETechInpCS  = logical(),
   eqCnsGETechInpCSShareIn  = logical(),
   eqCnsGETechInpCSShareOut  = logical(),
   eqCnsGETechInpCS  = logical(),
   eqCnsETechInpCSShareIn  = logical(),
   eqCnsETechInpCSShareOut  = logical(),
   eqCnsETechInpCS  = logical(),
   eqCnsLETechInpCYShareIn  = logical(),
   eqCnsLETechInpCYShareOut  = logical(),
   eqCnsLETechInpCY  = logical(),
   eqCnsLETechInpCYGrowth  = logical(),
   eqCnsGETechInpCYShareIn  = logical(),
   eqCnsGETechInpCYShareOut  = logical(),
   eqCnsGETechInpCY  = logical(),
   eqCnsGETechInpCYGrowth  = logical(),
   eqCnsETechInpCYShareIn  = logical(),
   eqCnsETechInpCYShareOut  = logical(),
   eqCnsETechInpCY  = logical(),
   eqCnsETechInpCYGrowth  = logical(),
   eqCnsLETechInpCYSShareIn  = logical(),
   eqCnsLETechInpCYSShareOut  = logical(),
   eqCnsLETechInpCYS  = logical(),
   eqCnsLETechInpCYSGrowth  = logical(),
   eqCnsGETechInpCYSShareIn  = logical(),
   eqCnsGETechInpCYSShareOut  = logical(),
   eqCnsGETechInpCYS  = logical(),
   eqCnsGETechInpCYSGrowth  = logical(),
   eqCnsETechInpCYSShareIn  = logical(),
   eqCnsETechInpCYSShareOut  = logical(),
   eqCnsETechInpCYS  = logical(),
   eqCnsETechInpCYSGrowth  = logical(),
   eqCnsLETechInpCRShareIn  = logical(),
   eqCnsLETechInpCRShareOut  = logical(),
   eqCnsLETechInpCR  = logical(),
   eqCnsGETechInpCRShareIn  = logical(),
   eqCnsGETechInpCRShareOut  = logical(),
   eqCnsGETechInpCR  = logical(),
   eqCnsETechInpCRShareIn  = logical(),
   eqCnsETechInpCRShareOut  = logical(),
   eqCnsETechInpCR  = logical(),
   eqCnsLETechInpCRSShareIn  = logical(),
   eqCnsLETechInpCRSShareOut  = logical(),
   eqCnsLETechInpCRS  = logical(),
   eqCnsGETechInpCRSShareIn  = logical(),
   eqCnsGETechInpCRSShareOut  = logical(),
   eqCnsGETechInpCRS  = logical(),
   eqCnsETechInpCRSShareIn  = logical(),
   eqCnsETechInpCRSShareOut  = logical(),
   eqCnsETechInpCRS  = logical(),
   eqCnsLETechInpCRYShareIn  = logical(),
   eqCnsLETechInpCRYShareOut  = logical(),
   eqCnsLETechInpCRY  = logical(),
   eqCnsLETechInpCRYGrowth  = logical(),
   eqCnsGETechInpCRYShareIn  = logical(),
   eqCnsGETechInpCRYShareOut  = logical(),
   eqCnsGETechInpCRY  = logical(),
   eqCnsGETechInpCRYGrowth  = logical(),
   eqCnsETechInpCRYShareIn  = logical(),
   eqCnsETechInpCRYShareOut  = logical(),
   eqCnsETechInpCRY  = logical(),
   eqCnsETechInpCRYGrowth  = logical(),
   eqCnsLETechInpCRYSShareIn  = logical(),
   eqCnsLETechInpCRYSShareOut  = logical(),
   eqCnsLETechInpCRYS  = logical(),
   eqCnsLETechInpCRYSGrowth  = logical(),
   eqCnsGETechInpCRYSShareIn  = logical(),
   eqCnsGETechInpCRYSShareOut  = logical(),
   eqCnsGETechInpCRYS  = logical(),
   eqCnsGETechInpCRYSGrowth  = logical(),
   eqCnsETechInpCRYSShareIn  = logical(),
   eqCnsETechInpCRYSShareOut  = logical(),
   eqCnsETechInpCRYS  = logical(),
   eqCnsETechInpCRYSGrowth  = logical(),
   eqCnsLETechOutShareIn  = logical(),
   eqCnsLETechOutShareOut  = logical(),
   eqCnsLETechOut  = logical(),
   eqCnsGETechOutShareIn  = logical(),
   eqCnsGETechOutShareOut  = logical(),
   eqCnsGETechOut  = logical(),
   eqCnsETechOutShareIn  = logical(),
   eqCnsETechOutShareOut  = logical(),
   eqCnsETechOut  = logical(),
   eqCnsLETechOutSShareIn  = logical(),
   eqCnsLETechOutSShareOut  = logical(),
   eqCnsLETechOutS  = logical(),
   eqCnsGETechOutSShareIn  = logical(),
   eqCnsGETechOutSShareOut  = logical(),
   eqCnsGETechOutS  = logical(),
   eqCnsETechOutSShareIn  = logical(),
   eqCnsETechOutSShareOut  = logical(),
   eqCnsETechOutS  = logical(),
   eqCnsLETechOutYShareIn  = logical(),
   eqCnsLETechOutYShareOut  = logical(),
   eqCnsLETechOutY  = logical(),
   eqCnsLETechOutYGrowth  = logical(),
   eqCnsGETechOutYShareIn  = logical(),
   eqCnsGETechOutYShareOut  = logical(),
   eqCnsGETechOutY  = logical(),
   eqCnsGETechOutYGrowth  = logical(),
   eqCnsETechOutYShareIn  = logical(),
   eqCnsETechOutYShareOut  = logical(),
   eqCnsETechOutY  = logical(),
   eqCnsETechOutYGrowth  = logical(),
   eqCnsLETechOutYSShareIn  = logical(),
   eqCnsLETechOutYSShareOut  = logical(),
   eqCnsLETechOutYS  = logical(),
   eqCnsLETechOutYSGrowth  = logical(),
   eqCnsGETechOutYSShareIn  = logical(),
   eqCnsGETechOutYSShareOut  = logical(),
   eqCnsGETechOutYS  = logical(),
   eqCnsGETechOutYSGrowth  = logical(),
   eqCnsETechOutYSShareIn  = logical(),
   eqCnsETechOutYSShareOut  = logical(),
   eqCnsETechOutYS  = logical(),
   eqCnsETechOutYSGrowth  = logical(),
   eqCnsLETechOutRShareIn  = logical(),
   eqCnsLETechOutRShareOut  = logical(),
   eqCnsLETechOutR  = logical(),
   eqCnsGETechOutRShareIn  = logical(),
   eqCnsGETechOutRShareOut  = logical(),
   eqCnsGETechOutR  = logical(),
   eqCnsETechOutRShareIn  = logical(),
   eqCnsETechOutRShareOut  = logical(),
   eqCnsETechOutR  = logical(),
   eqCnsLETechOutRSShareIn  = logical(),
   eqCnsLETechOutRSShareOut  = logical(),
   eqCnsLETechOutRS  = logical(),
   eqCnsGETechOutRSShareIn  = logical(),
   eqCnsGETechOutRSShareOut  = logical(),
   eqCnsGETechOutRS  = logical(),
   eqCnsETechOutRSShareIn  = logical(),
   eqCnsETechOutRSShareOut  = logical(),
   eqCnsETechOutRS  = logical(),
   eqCnsLETechOutRYShareIn  = logical(),
   eqCnsLETechOutRYShareOut  = logical(),
   eqCnsLETechOutRY  = logical(),
   eqCnsLETechOutRYGrowth  = logical(),
   eqCnsGETechOutRYShareIn  = logical(),
   eqCnsGETechOutRYShareOut  = logical(),
   eqCnsGETechOutRY  = logical(),
   eqCnsGETechOutRYGrowth  = logical(),
   eqCnsETechOutRYShareIn  = logical(),
   eqCnsETechOutRYShareOut  = logical(),
   eqCnsETechOutRY  = logical(),
   eqCnsETechOutRYGrowth  = logical(),
   eqCnsLETechOutRYSShareIn  = logical(),
   eqCnsLETechOutRYSShareOut  = logical(),
   eqCnsLETechOutRYS  = logical(),
   eqCnsLETechOutRYSGrowth  = logical(),
   eqCnsGETechOutRYSShareIn  = logical(),
   eqCnsGETechOutRYSShareOut  = logical(),
   eqCnsGETechOutRYS  = logical(),
   eqCnsGETechOutRYSGrowth  = logical(),
   eqCnsETechOutRYSShareIn  = logical(),
   eqCnsETechOutRYSShareOut  = logical(),
   eqCnsETechOutRYS  = logical(),
   eqCnsETechOutRYSGrowth  = logical(),
   eqCnsLETechOutCShareIn  = logical(),
   eqCnsLETechOutCShareOut  = logical(),
   eqCnsLETechOutC  = logical(),
   eqCnsGETechOutCShareIn  = logical(),
   eqCnsGETechOutCShareOut  = logical(),
   eqCnsGETechOutC  = logical(),
   eqCnsETechOutCShareIn  = logical(),
   eqCnsETechOutCShareOut  = logical(),
   eqCnsETechOutC  = logical(),
   eqCnsLETechOutCSShareIn  = logical(),
   eqCnsLETechOutCSShareOut  = logical(),
   eqCnsLETechOutCS  = logical(),
   eqCnsGETechOutCSShareIn  = logical(),
   eqCnsGETechOutCSShareOut  = logical(),
   eqCnsGETechOutCS  = logical(),
   eqCnsETechOutCSShareIn  = logical(),
   eqCnsETechOutCSShareOut  = logical(),
   eqCnsETechOutCS  = logical(),
   eqCnsLETechOutCYShareIn  = logical(),
   eqCnsLETechOutCYShareOut  = logical(),
   eqCnsLETechOutCY  = logical(),
   eqCnsLETechOutCYGrowth  = logical(),
   eqCnsGETechOutCYShareIn  = logical(),
   eqCnsGETechOutCYShareOut  = logical(),
   eqCnsGETechOutCY  = logical(),
   eqCnsGETechOutCYGrowth  = logical(),
   eqCnsETechOutCYShareIn  = logical(),
   eqCnsETechOutCYShareOut  = logical(),
   eqCnsETechOutCY  = logical(),
   eqCnsETechOutCYGrowth  = logical(),
   eqCnsLETechOutCYSShareIn  = logical(),
   eqCnsLETechOutCYSShareOut  = logical(),
   eqCnsLETechOutCYS  = logical(),
   eqCnsLETechOutCYSGrowth  = logical(),
   eqCnsGETechOutCYSShareIn  = logical(),
   eqCnsGETechOutCYSShareOut  = logical(),
   eqCnsGETechOutCYS  = logical(),
   eqCnsGETechOutCYSGrowth  = logical(),
   eqCnsETechOutCYSShareIn  = logical(),
   eqCnsETechOutCYSShareOut  = logical(),
   eqCnsETechOutCYS  = logical(),
   eqCnsETechOutCYSGrowth  = logical(),
   eqCnsLETechOutCRShareIn  = logical(),
   eqCnsLETechOutCRShareOut  = logical(),
   eqCnsLETechOutCR  = logical(),
   eqCnsGETechOutCRShareIn  = logical(),
   eqCnsGETechOutCRShareOut  = logical(),
   eqCnsGETechOutCR  = logical(),
   eqCnsETechOutCRShareIn  = logical(),
   eqCnsETechOutCRShareOut  = logical(),
   eqCnsETechOutCR  = logical(),
   eqCnsLETechOutCRSShareIn  = logical(),
   eqCnsLETechOutCRSShareOut  = logical(),
   eqCnsLETechOutCRS  = logical(),
   eqCnsGETechOutCRSShareIn  = logical(),
   eqCnsGETechOutCRSShareOut  = logical(),
   eqCnsGETechOutCRS  = logical(),
   eqCnsETechOutCRSShareIn  = logical(),
   eqCnsETechOutCRSShareOut  = logical(),
   eqCnsETechOutCRS  = logical(),
   eqCnsLETechOutCRYShareIn  = logical(),
   eqCnsLETechOutCRYShareOut  = logical(),
   eqCnsLETechOutCRY  = logical(),
   eqCnsLETechOutCRYGrowth  = logical(),
   eqCnsGETechOutCRYShareIn  = logical(),
   eqCnsGETechOutCRYShareOut  = logical(),
   eqCnsGETechOutCRY  = logical(),
   eqCnsGETechOutCRYGrowth  = logical(),
   eqCnsETechOutCRYShareIn  = logical(),
   eqCnsETechOutCRYShareOut  = logical(),
   eqCnsETechOutCRY  = logical(),
   eqCnsETechOutCRYGrowth  = logical(),
   eqCnsLETechOutCRYSShareIn  = logical(),
   eqCnsLETechOutCRYSShareOut  = logical(),
   eqCnsLETechOutCRYS  = logical(),
   eqCnsLETechOutCRYSGrowth  = logical(),
   eqCnsGETechOutCRYSShareIn  = logical(),
   eqCnsGETechOutCRYSShareOut  = logical(),
   eqCnsGETechOutCRYS  = logical(),
   eqCnsGETechOutCRYSGrowth  = logical(),
   eqCnsETechOutCRYSShareIn  = logical(),
   eqCnsETechOutCRYSShareOut  = logical(),
   eqCnsETechOutCRYS  = logical(),
   eqCnsETechOutCRYSGrowth  = logical(),
   eqCnsLETechCap  = logical(),
   eqCnsGETechCap  = logical(),
   eqCnsETechCap  = logical(),
   eqCnsLETechCapY  = logical(),
   eqCnsLETechCapYGrowth  = logical(),
   eqCnsGETechCapY  = logical(),
   eqCnsGETechCapYGrowth  = logical(),
   eqCnsETechCapY  = logical(),
   eqCnsETechCapYGrowth  = logical(),
   eqCnsLETechCapR  = logical(),
   eqCnsGETechCapR  = logical(),
   eqCnsETechCapR  = logical(),
   eqCnsLETechCapRY  = logical(),
   eqCnsLETechCapRYGrowth  = logical(),
   eqCnsGETechCapRY  = logical(),
   eqCnsGETechCapRYGrowth  = logical(),
   eqCnsETechCapRY  = logical(),
   eqCnsETechCapRYGrowth  = logical(),
   eqCnsLETechNewCap  = logical(),
   eqCnsGETechNewCap  = logical(),
   eqCnsETechNewCap  = logical(),
   eqCnsLETechNewCapY  = logical(),
   eqCnsLETechNewCapYGrowth  = logical(),
   eqCnsGETechNewCapY  = logical(),
   eqCnsGETechNewCapYGrowth  = logical(),
   eqCnsETechNewCapY  = logical(),
   eqCnsETechNewCapYGrowth  = logical(),
   eqCnsLETechNewCapR  = logical(),
   eqCnsGETechNewCapR  = logical(),
   eqCnsETechNewCapR  = logical(),
   eqCnsLETechNewCapRY  = logical(),
   eqCnsLETechNewCapRYGrowth  = logical(),
   eqCnsGETechNewCapRY  = logical(),
   eqCnsGETechNewCapRYGrowth  = logical(),
   eqCnsETechNewCapRY  = logical(),
   eqCnsETechNewCapRYGrowth  = logical(),
   eqCnsLETechInv  = logical(),
   eqCnsGETechInv  = logical(),
   eqCnsETechInv  = logical(),
   eqCnsLETechInvY  = logical(),
   eqCnsLETechInvYGrowth  = logical(),
   eqCnsGETechInvY  = logical(),
   eqCnsGETechInvYGrowth  = logical(),
   eqCnsETechInvY  = logical(),
   eqCnsETechInvYGrowth  = logical(),
   eqCnsLETechInvR  = logical(),
   eqCnsGETechInvR  = logical(),
   eqCnsETechInvR  = logical(),
   eqCnsLETechInvRY  = logical(),
   eqCnsLETechInvRYGrowth  = logical(),
   eqCnsGETechInvRY  = logical(),
   eqCnsGETechInvRYGrowth  = logical(),
   eqCnsETechInvRY  = logical(),
   eqCnsETechInvRYGrowth  = logical(),
   eqCnsLETechEac  = logical(),
   eqCnsGETechEac  = logical(),
   eqCnsETechEac  = logical(),
   eqCnsLETechEacY  = logical(),
   eqCnsLETechEacYGrowth  = logical(),
   eqCnsGETechEacY  = logical(),
   eqCnsGETechEacYGrowth  = logical(),
   eqCnsETechEacY  = logical(),
   eqCnsETechEacYGrowth  = logical(),
   eqCnsLETechEacR  = logical(),
   eqCnsGETechEacR  = logical(),
   eqCnsETechEacR  = logical(),
   eqCnsLETechEacRY  = logical(),
   eqCnsLETechEacRYGrowth  = logical(),
   eqCnsGETechEacRY  = logical(),
   eqCnsGETechEacRYGrowth  = logical(),
   eqCnsETechEacRY  = logical(),
   eqCnsETechEacRYGrowth  = logical(),
   eqCnsLETechAct  = logical(),
   eqCnsGETechAct  = logical(),
   eqCnsETechAct  = logical(),
   eqCnsLETechActS  = logical(),
   eqCnsGETechActS  = logical(),
   eqCnsETechActS  = logical(),
   eqCnsLETechActY  = logical(),
   eqCnsLETechActYGrowth  = logical(),
   eqCnsGETechActY  = logical(),
   eqCnsGETechActYGrowth  = logical(),
   eqCnsETechActY  = logical(),
   eqCnsETechActYGrowth  = logical(),
   eqCnsLETechActYS  = logical(),
   eqCnsLETechActYSGrowth  = logical(),
   eqCnsGETechActYS  = logical(),
   eqCnsGETechActYSGrowth  = logical(),
   eqCnsETechActYS  = logical(),
   eqCnsETechActYSGrowth  = logical(),
   eqCnsLETechActR  = logical(),
   eqCnsGETechActR  = logical(),
   eqCnsETechActR  = logical(),
   eqCnsLETechActRS  = logical(),
   eqCnsGETechActRS  = logical(),
   eqCnsETechActRS  = logical(),
   eqCnsLETechActRY  = logical(),
   eqCnsLETechActRYGrowth  = logical(),
   eqCnsGETechActRY  = logical(),
   eqCnsGETechActRYGrowth  = logical(),
   eqCnsETechActRY  = logical(),
   eqCnsETechActRYGrowth  = logical(),
   eqCnsLETechActRYS  = logical(),
   eqCnsLETechActRYSGrowth  = logical(),
   eqCnsGETechActRYS  = logical(),
   eqCnsGETechActRYSGrowth  = logical(),
   eqCnsETechActRYS  = logical(),
   eqCnsETechActRYSGrowth  = logical(),
   eqCnsLETechVarom  = logical(),
   eqCnsGETechVarom  = logical(),
   eqCnsETechVarom  = logical(),
   eqCnsLETechVaromS  = logical(),
   eqCnsGETechVaromS  = logical(),
   eqCnsETechVaromS  = logical(),
   eqCnsLETechVaromY  = logical(),
   eqCnsLETechVaromYGrowth  = logical(),
   eqCnsGETechVaromY  = logical(),
   eqCnsGETechVaromYGrowth  = logical(),
   eqCnsETechVaromY  = logical(),
   eqCnsETechVaromYGrowth  = logical(),
   eqCnsLETechVaromYS  = logical(),
   eqCnsLETechVaromYSGrowth  = logical(),
   eqCnsGETechVaromYS  = logical(),
   eqCnsGETechVaromYSGrowth  = logical(),
   eqCnsETechVaromYS  = logical(),
   eqCnsETechVaromYSGrowth  = logical(),
   eqCnsLETechVaromR  = logical(),
   eqCnsGETechVaromR  = logical(),
   eqCnsETechVaromR  = logical(),
   eqCnsLETechVaromRS  = logical(),
   eqCnsGETechVaromRS  = logical(),
   eqCnsETechVaromRS  = logical(),
   eqCnsLETechVaromRY  = logical(),
   eqCnsLETechVaromRYGrowth  = logical(),
   eqCnsGETechVaromRY  = logical(),
   eqCnsGETechVaromRYGrowth  = logical(),
   eqCnsETechVaromRY  = logical(),
   eqCnsETechVaromRYGrowth  = logical(),
   eqCnsLETechVaromRYS  = logical(),
   eqCnsLETechVaromRYSGrowth  = logical(),
   eqCnsGETechVaromRYS  = logical(),
   eqCnsGETechVaromRYSGrowth  = logical(),
   eqCnsETechVaromRYS  = logical(),
   eqCnsETechVaromRYSGrowth  = logical(),
   eqCnsLETechFixom  = logical(),
   eqCnsGETechFixom  = logical(),
   eqCnsETechFixom  = logical(),
   eqCnsLETechFixomY  = logical(),
   eqCnsLETechFixomYGrowth  = logical(),
   eqCnsGETechFixomY  = logical(),
   eqCnsGETechFixomYGrowth  = logical(),
   eqCnsETechFixomY  = logical(),
   eqCnsETechFixomYGrowth  = logical(),
   eqCnsLETechFixomR  = logical(),
   eqCnsGETechFixomR  = logical(),
   eqCnsETechFixomR  = logical(),
   eqCnsLETechFixomRY  = logical(),
   eqCnsLETechFixomRYGrowth  = logical(),
   eqCnsGETechFixomRY  = logical(),
   eqCnsGETechFixomRYGrowth  = logical(),
   eqCnsETechFixomRY  = logical(),
   eqCnsETechFixomRYGrowth  = logical(),
   eqCnsLETechActvarom  = logical(),
   eqCnsGETechActvarom  = logical(),
   eqCnsETechActvarom  = logical(),
   eqCnsLETechActvaromS  = logical(),
   eqCnsGETechActvaromS  = logical(),
   eqCnsETechActvaromS  = logical(),
   eqCnsLETechActvaromY  = logical(),
   eqCnsLETechActvaromYGrowth  = logical(),
   eqCnsGETechActvaromY  = logical(),
   eqCnsGETechActvaromYGrowth  = logical(),
   eqCnsETechActvaromY  = logical(),
   eqCnsETechActvaromYGrowth  = logical(),
   eqCnsLETechActvaromYS  = logical(),
   eqCnsLETechActvaromYSGrowth  = logical(),
   eqCnsGETechActvaromYS  = logical(),
   eqCnsGETechActvaromYSGrowth  = logical(),
   eqCnsETechActvaromYS  = logical(),
   eqCnsETechActvaromYSGrowth  = logical(),
   eqCnsLETechActvaromR  = logical(),
   eqCnsGETechActvaromR  = logical(),
   eqCnsETechActvaromR  = logical(),
   eqCnsLETechActvaromRS  = logical(),
   eqCnsGETechActvaromRS  = logical(),
   eqCnsETechActvaromRS  = logical(),
   eqCnsLETechActvaromRY  = logical(),
   eqCnsLETechActvaromRYGrowth  = logical(),
   eqCnsGETechActvaromRY  = logical(),
   eqCnsGETechActvaromRYGrowth  = logical(),
   eqCnsETechActvaromRY  = logical(),
   eqCnsETechActvaromRYGrowth  = logical(),
   eqCnsLETechActvaromRYS  = logical(),
   eqCnsLETechActvaromRYSGrowth  = logical(),
   eqCnsGETechActvaromRYS  = logical(),
   eqCnsGETechActvaromRYSGrowth  = logical(),
   eqCnsETechActvaromRYS  = logical(),
   eqCnsETechActvaromRYSGrowth  = logical(),
   eqCnsLETechCvarom  = logical(),
   eqCnsGETechCvarom  = logical(),
   eqCnsETechCvarom  = logical(),
   eqCnsLETechCvaromS  = logical(),
   eqCnsGETechCvaromS  = logical(),
   eqCnsETechCvaromS  = logical(),
   eqCnsLETechCvaromY  = logical(),
   eqCnsLETechCvaromYGrowth  = logical(),
   eqCnsGETechCvaromY  = logical(),
   eqCnsGETechCvaromYGrowth  = logical(),
   eqCnsETechCvaromY  = logical(),
   eqCnsETechCvaromYGrowth  = logical(),
   eqCnsLETechCvaromYS  = logical(),
   eqCnsLETechCvaromYSGrowth  = logical(),
   eqCnsGETechCvaromYS  = logical(),
   eqCnsGETechCvaromYSGrowth  = logical(),
   eqCnsETechCvaromYS  = logical(),
   eqCnsETechCvaromYSGrowth  = logical(),
   eqCnsLETechCvaromR  = logical(),
   eqCnsGETechCvaromR  = logical(),
   eqCnsETechCvaromR  = logical(),
   eqCnsLETechCvaromRS  = logical(),
   eqCnsGETechCvaromRS  = logical(),
   eqCnsETechCvaromRS  = logical(),
   eqCnsLETechCvaromRY  = logical(),
   eqCnsLETechCvaromRYGrowth  = logical(),
   eqCnsGETechCvaromRY  = logical(),
   eqCnsGETechCvaromRYGrowth  = logical(),
   eqCnsETechCvaromRY  = logical(),
   eqCnsETechCvaromRYGrowth  = logical(),
   eqCnsLETechCvaromRYS  = logical(),
   eqCnsLETechCvaromRYSGrowth  = logical(),
   eqCnsGETechCvaromRYS  = logical(),
   eqCnsGETechCvaromRYSGrowth  = logical(),
   eqCnsETechCvaromRYS  = logical(),
   eqCnsETechCvaromRYSGrowth  = logical(),
   eqCnsLETechAvarom  = logical(),
   eqCnsGETechAvarom  = logical(),
   eqCnsETechAvarom  = logical(),
   eqCnsLETechAvaromS  = logical(),
   eqCnsGETechAvaromS  = logical(),
   eqCnsETechAvaromS  = logical(),
   eqCnsLETechAvaromY  = logical(),
   eqCnsLETechAvaromYGrowth  = logical(),
   eqCnsGETechAvaromY  = logical(),
   eqCnsGETechAvaromYGrowth  = logical(),
   eqCnsETechAvaromY  = logical(),
   eqCnsETechAvaromYGrowth  = logical(),
   eqCnsLETechAvaromYS  = logical(),
   eqCnsLETechAvaromYSGrowth  = logical(),
   eqCnsGETechAvaromYS  = logical(),
   eqCnsGETechAvaromYSGrowth  = logical(),
   eqCnsETechAvaromYS  = logical(),
   eqCnsETechAvaromYSGrowth  = logical(),
   eqCnsLETechAvaromR  = logical(),
   eqCnsGETechAvaromR  = logical(),
   eqCnsETechAvaromR  = logical(),
   eqCnsLETechAvaromRS  = logical(),
   eqCnsGETechAvaromRS  = logical(),
   eqCnsETechAvaromRS  = logical(),
   eqCnsLETechAvaromRY  = logical(),
   eqCnsLETechAvaromRYGrowth  = logical(),
   eqCnsGETechAvaromRY  = logical(),
   eqCnsGETechAvaromRYGrowth  = logical(),
   eqCnsETechAvaromRY  = logical(),
   eqCnsETechAvaromRYGrowth  = logical(),
   eqCnsLETechAvaromRYS  = logical(),
   eqCnsLETechAvaromRYSGrowth  = logical(),
   eqCnsGETechAvaromRYS  = logical(),
   eqCnsGETechAvaromRYSGrowth  = logical(),
   eqCnsETechAvaromRYS  = logical(),
   eqCnsETechAvaromRYSGrowth  = logical(),
   eqCnsLETechInpLShareIn  = logical(),
   eqCnsLETechInpLShareOut  = logical(),
   eqCnsLETechInpL  = logical(),
   eqCnsGETechInpLShareIn  = logical(),
   eqCnsGETechInpLShareOut  = logical(),
   eqCnsGETechInpL  = logical(),
   eqCnsETechInpLShareIn  = logical(),
   eqCnsETechInpLShareOut  = logical(),
   eqCnsETechInpL  = logical(),
   eqCnsLETechInpLSShareIn  = logical(),
   eqCnsLETechInpLSShareOut  = logical(),
   eqCnsLETechInpLS  = logical(),
   eqCnsGETechInpLSShareIn  = logical(),
   eqCnsGETechInpLSShareOut  = logical(),
   eqCnsGETechInpLS  = logical(),
   eqCnsETechInpLSShareIn  = logical(),
   eqCnsETechInpLSShareOut  = logical(),
   eqCnsETechInpLS  = logical(),
   eqCnsLETechInpLYShareIn  = logical(),
   eqCnsLETechInpLYShareOut  = logical(),
   eqCnsLETechInpLY  = logical(),
   eqCnsLETechInpLYGrowth  = logical(),
   eqCnsGETechInpLYShareIn  = logical(),
   eqCnsGETechInpLYShareOut  = logical(),
   eqCnsGETechInpLY  = logical(),
   eqCnsGETechInpLYGrowth  = logical(),
   eqCnsETechInpLYShareIn  = logical(),
   eqCnsETechInpLYShareOut  = logical(),
   eqCnsETechInpLY  = logical(),
   eqCnsETechInpLYGrowth  = logical(),
   eqCnsLETechInpLYSShareIn  = logical(),
   eqCnsLETechInpLYSShareOut  = logical(),
   eqCnsLETechInpLYS  = logical(),
   eqCnsLETechInpLYSGrowth  = logical(),
   eqCnsGETechInpLYSShareIn  = logical(),
   eqCnsGETechInpLYSShareOut  = logical(),
   eqCnsGETechInpLYS  = logical(),
   eqCnsGETechInpLYSGrowth  = logical(),
   eqCnsETechInpLYSShareIn  = logical(),
   eqCnsETechInpLYSShareOut  = logical(),
   eqCnsETechInpLYS  = logical(),
   eqCnsETechInpLYSGrowth  = logical(),
   eqCnsLETechInpLRShareIn  = logical(),
   eqCnsLETechInpLRShareOut  = logical(),
   eqCnsLETechInpLR  = logical(),
   eqCnsGETechInpLRShareIn  = logical(),
   eqCnsGETechInpLRShareOut  = logical(),
   eqCnsGETechInpLR  = logical(),
   eqCnsETechInpLRShareIn  = logical(),
   eqCnsETechInpLRShareOut  = logical(),
   eqCnsETechInpLR  = logical(),
   eqCnsLETechInpLRSShareIn  = logical(),
   eqCnsLETechInpLRSShareOut  = logical(),
   eqCnsLETechInpLRS  = logical(),
   eqCnsGETechInpLRSShareIn  = logical(),
   eqCnsGETechInpLRSShareOut  = logical(),
   eqCnsGETechInpLRS  = logical(),
   eqCnsETechInpLRSShareIn  = logical(),
   eqCnsETechInpLRSShareOut  = logical(),
   eqCnsETechInpLRS  = logical(),
   eqCnsLETechInpLRYShareIn  = logical(),
   eqCnsLETechInpLRYShareOut  = logical(),
   eqCnsLETechInpLRY  = logical(),
   eqCnsLETechInpLRYGrowth  = logical(),
   eqCnsGETechInpLRYShareIn  = logical(),
   eqCnsGETechInpLRYShareOut  = logical(),
   eqCnsGETechInpLRY  = logical(),
   eqCnsGETechInpLRYGrowth  = logical(),
   eqCnsETechInpLRYShareIn  = logical(),
   eqCnsETechInpLRYShareOut  = logical(),
   eqCnsETechInpLRY  = logical(),
   eqCnsETechInpLRYGrowth  = logical(),
   eqCnsLETechInpLRYSShareIn  = logical(),
   eqCnsLETechInpLRYSShareOut  = logical(),
   eqCnsLETechInpLRYS  = logical(),
   eqCnsLETechInpLRYSGrowth  = logical(),
   eqCnsGETechInpLRYSShareIn  = logical(),
   eqCnsGETechInpLRYSShareOut  = logical(),
   eqCnsGETechInpLRYS  = logical(),
   eqCnsGETechInpLRYSGrowth  = logical(),
   eqCnsETechInpLRYSShareIn  = logical(),
   eqCnsETechInpLRYSShareOut  = logical(),
   eqCnsETechInpLRYS  = logical(),
   eqCnsETechInpLRYSGrowth  = logical(),
   eqCnsLETechInpLCShareIn  = logical(),
   eqCnsLETechInpLCShareOut  = logical(),
   eqCnsLETechInpLC  = logical(),
   eqCnsGETechInpLCShareIn  = logical(),
   eqCnsGETechInpLCShareOut  = logical(),
   eqCnsGETechInpLC  = logical(),
   eqCnsETechInpLCShareIn  = logical(),
   eqCnsETechInpLCShareOut  = logical(),
   eqCnsETechInpLC  = logical(),
   eqCnsLETechInpLCSShareIn  = logical(),
   eqCnsLETechInpLCSShareOut  = logical(),
   eqCnsLETechInpLCS  = logical(),
   eqCnsGETechInpLCSShareIn  = logical(),
   eqCnsGETechInpLCSShareOut  = logical(),
   eqCnsGETechInpLCS  = logical(),
   eqCnsETechInpLCSShareIn  = logical(),
   eqCnsETechInpLCSShareOut  = logical(),
   eqCnsETechInpLCS  = logical(),
   eqCnsLETechInpLCYShareIn  = logical(),
   eqCnsLETechInpLCYShareOut  = logical(),
   eqCnsLETechInpLCY  = logical(),
   eqCnsLETechInpLCYGrowth  = logical(),
   eqCnsGETechInpLCYShareIn  = logical(),
   eqCnsGETechInpLCYShareOut  = logical(),
   eqCnsGETechInpLCY  = logical(),
   eqCnsGETechInpLCYGrowth  = logical(),
   eqCnsETechInpLCYShareIn  = logical(),
   eqCnsETechInpLCYShareOut  = logical(),
   eqCnsETechInpLCY  = logical(),
   eqCnsETechInpLCYGrowth  = logical(),
   eqCnsLETechInpLCYSShareIn  = logical(),
   eqCnsLETechInpLCYSShareOut  = logical(),
   eqCnsLETechInpLCYS  = logical(),
   eqCnsLETechInpLCYSGrowth  = logical(),
   eqCnsGETechInpLCYSShareIn  = logical(),
   eqCnsGETechInpLCYSShareOut  = logical(),
   eqCnsGETechInpLCYS  = logical(),
   eqCnsGETechInpLCYSGrowth  = logical(),
   eqCnsETechInpLCYSShareIn  = logical(),
   eqCnsETechInpLCYSShareOut  = logical(),
   eqCnsETechInpLCYS  = logical(),
   eqCnsETechInpLCYSGrowth  = logical(),
   eqCnsLETechInpLCRShareIn  = logical(),
   eqCnsLETechInpLCRShareOut  = logical(),
   eqCnsLETechInpLCR  = logical(),
   eqCnsGETechInpLCRShareIn  = logical(),
   eqCnsGETechInpLCRShareOut  = logical(),
   eqCnsGETechInpLCR  = logical(),
   eqCnsETechInpLCRShareIn  = logical(),
   eqCnsETechInpLCRShareOut  = logical(),
   eqCnsETechInpLCR  = logical(),
   eqCnsLETechInpLCRSShareIn  = logical(),
   eqCnsLETechInpLCRSShareOut  = logical(),
   eqCnsLETechInpLCRS  = logical(),
   eqCnsGETechInpLCRSShareIn  = logical(),
   eqCnsGETechInpLCRSShareOut  = logical(),
   eqCnsGETechInpLCRS  = logical(),
   eqCnsETechInpLCRSShareIn  = logical(),
   eqCnsETechInpLCRSShareOut  = logical(),
   eqCnsETechInpLCRS  = logical(),
   eqCnsLETechInpLCRYShareIn  = logical(),
   eqCnsLETechInpLCRYShareOut  = logical(),
   eqCnsLETechInpLCRY  = logical(),
   eqCnsLETechInpLCRYGrowth  = logical(),
   eqCnsGETechInpLCRYShareIn  = logical(),
   eqCnsGETechInpLCRYShareOut  = logical(),
   eqCnsGETechInpLCRY  = logical(),
   eqCnsGETechInpLCRYGrowth  = logical(),
   eqCnsETechInpLCRYShareIn  = logical(),
   eqCnsETechInpLCRYShareOut  = logical(),
   eqCnsETechInpLCRY  = logical(),
   eqCnsETechInpLCRYGrowth  = logical(),
   eqCnsLETechInpLCRYSShareIn  = logical(),
   eqCnsLETechInpLCRYSShareOut  = logical(),
   eqCnsLETechInpLCRYS  = logical(),
   eqCnsLETechInpLCRYSGrowth  = logical(),
   eqCnsGETechInpLCRYSShareIn  = logical(),
   eqCnsGETechInpLCRYSShareOut  = logical(),
   eqCnsGETechInpLCRYS  = logical(),
   eqCnsGETechInpLCRYSGrowth  = logical(),
   eqCnsETechInpLCRYSShareIn  = logical(),
   eqCnsETechInpLCRYSShareOut  = logical(),
   eqCnsETechInpLCRYS  = logical(),
   eqCnsETechInpLCRYSGrowth  = logical(),
   eqCnsLETechOutLShareIn  = logical(),
   eqCnsLETechOutLShareOut  = logical(),
   eqCnsLETechOutL  = logical(),
   eqCnsGETechOutLShareIn  = logical(),
   eqCnsGETechOutLShareOut  = logical(),
   eqCnsGETechOutL  = logical(),
   eqCnsETechOutLShareIn  = logical(),
   eqCnsETechOutLShareOut  = logical(),
   eqCnsETechOutL  = logical(),
   eqCnsLETechOutLSShareIn  = logical(),
   eqCnsLETechOutLSShareOut  = logical(),
   eqCnsLETechOutLS  = logical(),
   eqCnsGETechOutLSShareIn  = logical(),
   eqCnsGETechOutLSShareOut  = logical(),
   eqCnsGETechOutLS  = logical(),
   eqCnsETechOutLSShareIn  = logical(),
   eqCnsETechOutLSShareOut  = logical(),
   eqCnsETechOutLS  = logical(),
   eqCnsLETechOutLYShareIn  = logical(),
   eqCnsLETechOutLYShareOut  = logical(),
   eqCnsLETechOutLY  = logical(),
   eqCnsLETechOutLYGrowth  = logical(),
   eqCnsGETechOutLYShareIn  = logical(),
   eqCnsGETechOutLYShareOut  = logical(),
   eqCnsGETechOutLY  = logical(),
   eqCnsGETechOutLYGrowth  = logical(),
   eqCnsETechOutLYShareIn  = logical(),
   eqCnsETechOutLYShareOut  = logical(),
   eqCnsETechOutLY  = logical(),
   eqCnsETechOutLYGrowth  = logical(),
   eqCnsLETechOutLYSShareIn  = logical(),
   eqCnsLETechOutLYSShareOut  = logical(),
   eqCnsLETechOutLYS  = logical(),
   eqCnsLETechOutLYSGrowth  = logical(),
   eqCnsGETechOutLYSShareIn  = logical(),
   eqCnsGETechOutLYSShareOut  = logical(),
   eqCnsGETechOutLYS  = logical(),
   eqCnsGETechOutLYSGrowth  = logical(),
   eqCnsETechOutLYSShareIn  = logical(),
   eqCnsETechOutLYSShareOut  = logical(),
   eqCnsETechOutLYS  = logical(),
   eqCnsETechOutLYSGrowth  = logical(),
   eqCnsLETechOutLRShareIn  = logical(),
   eqCnsLETechOutLRShareOut  = logical(),
   eqCnsLETechOutLR  = logical(),
   eqCnsGETechOutLRShareIn  = logical(),
   eqCnsGETechOutLRShareOut  = logical(),
   eqCnsGETechOutLR  = logical(),
   eqCnsETechOutLRShareIn  = logical(),
   eqCnsETechOutLRShareOut  = logical(),
   eqCnsETechOutLR  = logical(),
   eqCnsLETechOutLRSShareIn  = logical(),
   eqCnsLETechOutLRSShareOut  = logical(),
   eqCnsLETechOutLRS  = logical(),
   eqCnsGETechOutLRSShareIn  = logical(),
   eqCnsGETechOutLRSShareOut  = logical(),
   eqCnsGETechOutLRS  = logical(),
   eqCnsETechOutLRSShareIn  = logical(),
   eqCnsETechOutLRSShareOut  = logical(),
   eqCnsETechOutLRS  = logical(),
   eqCnsLETechOutLRYShareIn  = logical(),
   eqCnsLETechOutLRYShareOut  = logical(),
   eqCnsLETechOutLRY  = logical(),
   eqCnsLETechOutLRYGrowth  = logical(),
   eqCnsGETechOutLRYShareIn  = logical(),
   eqCnsGETechOutLRYShareOut  = logical(),
   eqCnsGETechOutLRY  = logical(),
   eqCnsGETechOutLRYGrowth  = logical(),
   eqCnsETechOutLRYShareIn  = logical(),
   eqCnsETechOutLRYShareOut  = logical(),
   eqCnsETechOutLRY  = logical(),
   eqCnsETechOutLRYGrowth  = logical(),
   eqCnsLETechOutLRYSShareIn  = logical(),
   eqCnsLETechOutLRYSShareOut  = logical(),
   eqCnsLETechOutLRYS  = logical(),
   eqCnsLETechOutLRYSGrowth  = logical(),
   eqCnsGETechOutLRYSShareIn  = logical(),
   eqCnsGETechOutLRYSShareOut  = logical(),
   eqCnsGETechOutLRYS  = logical(),
   eqCnsGETechOutLRYSGrowth  = logical(),
   eqCnsETechOutLRYSShareIn  = logical(),
   eqCnsETechOutLRYSShareOut  = logical(),
   eqCnsETechOutLRYS  = logical(),
   eqCnsETechOutLRYSGrowth  = logical(),
   eqCnsLETechOutLCShareIn  = logical(),
   eqCnsLETechOutLCShareOut  = logical(),
   eqCnsLETechOutLC  = logical(),
   eqCnsGETechOutLCShareIn  = logical(),
   eqCnsGETechOutLCShareOut  = logical(),
   eqCnsGETechOutLC  = logical(),
   eqCnsETechOutLCShareIn  = logical(),
   eqCnsETechOutLCShareOut  = logical(),
   eqCnsETechOutLC  = logical(),
   eqCnsLETechOutLCSShareIn  = logical(),
   eqCnsLETechOutLCSShareOut  = logical(),
   eqCnsLETechOutLCS  = logical(),
   eqCnsGETechOutLCSShareIn  = logical(),
   eqCnsGETechOutLCSShareOut  = logical(),
   eqCnsGETechOutLCS  = logical(),
   eqCnsETechOutLCSShareIn  = logical(),
   eqCnsETechOutLCSShareOut  = logical(),
   eqCnsETechOutLCS  = logical(),
   eqCnsLETechOutLCYShareIn  = logical(),
   eqCnsLETechOutLCYShareOut  = logical(),
   eqCnsLETechOutLCY  = logical(),
   eqCnsLETechOutLCYGrowth  = logical(),
   eqCnsGETechOutLCYShareIn  = logical(),
   eqCnsGETechOutLCYShareOut  = logical(),
   eqCnsGETechOutLCY  = logical(),
   eqCnsGETechOutLCYGrowth  = logical(),
   eqCnsETechOutLCYShareIn  = logical(),
   eqCnsETechOutLCYShareOut  = logical(),
   eqCnsETechOutLCY  = logical(),
   eqCnsETechOutLCYGrowth  = logical(),
   eqCnsLETechOutLCYSShareIn  = logical(),
   eqCnsLETechOutLCYSShareOut  = logical(),
   eqCnsLETechOutLCYS  = logical(),
   eqCnsLETechOutLCYSGrowth  = logical(),
   eqCnsGETechOutLCYSShareIn  = logical(),
   eqCnsGETechOutLCYSShareOut  = logical(),
   eqCnsGETechOutLCYS  = logical(),
   eqCnsGETechOutLCYSGrowth  = logical(),
   eqCnsETechOutLCYSShareIn  = logical(),
   eqCnsETechOutLCYSShareOut  = logical(),
   eqCnsETechOutLCYS  = logical(),
   eqCnsETechOutLCYSGrowth  = logical(),
   eqCnsLETechOutLCRShareIn  = logical(),
   eqCnsLETechOutLCRShareOut  = logical(),
   eqCnsLETechOutLCR  = logical(),
   eqCnsGETechOutLCRShareIn  = logical(),
   eqCnsGETechOutLCRShareOut  = logical(),
   eqCnsGETechOutLCR  = logical(),
   eqCnsETechOutLCRShareIn  = logical(),
   eqCnsETechOutLCRShareOut  = logical(),
   eqCnsETechOutLCR  = logical(),
   eqCnsLETechOutLCRSShareIn  = logical(),
   eqCnsLETechOutLCRSShareOut  = logical(),
   eqCnsLETechOutLCRS  = logical(),
   eqCnsGETechOutLCRSShareIn  = logical(),
   eqCnsGETechOutLCRSShareOut  = logical(),
   eqCnsGETechOutLCRS  = logical(),
   eqCnsETechOutLCRSShareIn  = logical(),
   eqCnsETechOutLCRSShareOut  = logical(),
   eqCnsETechOutLCRS  = logical(),
   eqCnsLETechOutLCRYShareIn  = logical(),
   eqCnsLETechOutLCRYShareOut  = logical(),
   eqCnsLETechOutLCRY  = logical(),
   eqCnsLETechOutLCRYGrowth  = logical(),
   eqCnsGETechOutLCRYShareIn  = logical(),
   eqCnsGETechOutLCRYShareOut  = logical(),
   eqCnsGETechOutLCRY  = logical(),
   eqCnsGETechOutLCRYGrowth  = logical(),
   eqCnsETechOutLCRYShareIn  = logical(),
   eqCnsETechOutLCRYShareOut  = logical(),
   eqCnsETechOutLCRY  = logical(),
   eqCnsETechOutLCRYGrowth  = logical(),
   eqCnsLETechOutLCRYSShareIn  = logical(),
   eqCnsLETechOutLCRYSShareOut  = logical(),
   eqCnsLETechOutLCRYS  = logical(),
   eqCnsLETechOutLCRYSGrowth  = logical(),
   eqCnsGETechOutLCRYSShareIn  = logical(),
   eqCnsGETechOutLCRYSShareOut  = logical(),
   eqCnsGETechOutLCRYS  = logical(),
   eqCnsGETechOutLCRYSGrowth  = logical(),
   eqCnsETechOutLCRYSShareIn  = logical(),
   eqCnsETechOutLCRYSShareOut  = logical(),
   eqCnsETechOutLCRYS  = logical(),
   eqCnsETechOutLCRYSGrowth  = logical(),
   eqCnsLETechCapL  = logical(),
   eqCnsGETechCapL  = logical(),
   eqCnsETechCapL  = logical(),
   eqCnsLETechCapLY  = logical(),
   eqCnsLETechCapLYGrowth  = logical(),
   eqCnsGETechCapLY  = logical(),
   eqCnsGETechCapLYGrowth  = logical(),
   eqCnsETechCapLY  = logical(),
   eqCnsETechCapLYGrowth  = logical(),
   eqCnsLETechCapLR  = logical(),
   eqCnsGETechCapLR  = logical(),
   eqCnsETechCapLR  = logical(),
   eqCnsLETechCapLRY  = logical(),
   eqCnsLETechCapLRYGrowth  = logical(),
   eqCnsGETechCapLRY  = logical(),
   eqCnsGETechCapLRYGrowth  = logical(),
   eqCnsETechCapLRY  = logical(),
   eqCnsETechCapLRYGrowth  = logical(),
   eqCnsLETechNewCapL  = logical(),
   eqCnsGETechNewCapL  = logical(),
   eqCnsETechNewCapL  = logical(),
   eqCnsLETechNewCapLY  = logical(),
   eqCnsLETechNewCapLYGrowth  = logical(),
   eqCnsGETechNewCapLY  = logical(),
   eqCnsGETechNewCapLYGrowth  = logical(),
   eqCnsETechNewCapLY  = logical(),
   eqCnsETechNewCapLYGrowth  = logical(),
   eqCnsLETechNewCapLR  = logical(),
   eqCnsGETechNewCapLR  = logical(),
   eqCnsETechNewCapLR  = logical(),
   eqCnsLETechNewCapLRY  = logical(),
   eqCnsLETechNewCapLRYGrowth  = logical(),
   eqCnsGETechNewCapLRY  = logical(),
   eqCnsGETechNewCapLRYGrowth  = logical(),
   eqCnsETechNewCapLRY  = logical(),
   eqCnsETechNewCapLRYGrowth  = logical(),
   eqCnsLETechInvL  = logical(),
   eqCnsGETechInvL  = logical(),
   eqCnsETechInvL  = logical(),
   eqCnsLETechInvLY  = logical(),
   eqCnsLETechInvLYGrowth  = logical(),
   eqCnsGETechInvLY  = logical(),
   eqCnsGETechInvLYGrowth  = logical(),
   eqCnsETechInvLY  = logical(),
   eqCnsETechInvLYGrowth  = logical(),
   eqCnsLETechInvLR  = logical(),
   eqCnsGETechInvLR  = logical(),
   eqCnsETechInvLR  = logical(),
   eqCnsLETechInvLRY  = logical(),
   eqCnsLETechInvLRYGrowth  = logical(),
   eqCnsGETechInvLRY  = logical(),
   eqCnsGETechInvLRYGrowth  = logical(),
   eqCnsETechInvLRY  = logical(),
   eqCnsETechInvLRYGrowth  = logical(),
   eqCnsLETechEacL  = logical(),
   eqCnsGETechEacL  = logical(),
   eqCnsETechEacL  = logical(),
   eqCnsLETechEacLY  = logical(),
   eqCnsLETechEacLYGrowth  = logical(),
   eqCnsGETechEacLY  = logical(),
   eqCnsGETechEacLYGrowth  = logical(),
   eqCnsETechEacLY  = logical(),
   eqCnsETechEacLYGrowth  = logical(),
   eqCnsLETechEacLR  = logical(),
   eqCnsGETechEacLR  = logical(),
   eqCnsETechEacLR  = logical(),
   eqCnsLETechEacLRY  = logical(),
   eqCnsLETechEacLRYGrowth  = logical(),
   eqCnsGETechEacLRY  = logical(),
   eqCnsGETechEacLRYGrowth  = logical(),
   eqCnsETechEacLRY  = logical(),
   eqCnsETechEacLRYGrowth  = logical(),
   eqCnsLETechActL  = logical(),
   eqCnsGETechActL  = logical(),
   eqCnsETechActL  = logical(),
   eqCnsLETechActLS  = logical(),
   eqCnsGETechActLS  = logical(),
   eqCnsETechActLS  = logical(),
   eqCnsLETechActLY  = logical(),
   eqCnsLETechActLYGrowth  = logical(),
   eqCnsGETechActLY  = logical(),
   eqCnsGETechActLYGrowth  = logical(),
   eqCnsETechActLY  = logical(),
   eqCnsETechActLYGrowth  = logical(),
   eqCnsLETechActLYS  = logical(),
   eqCnsLETechActLYSGrowth  = logical(),
   eqCnsGETechActLYS  = logical(),
   eqCnsGETechActLYSGrowth  = logical(),
   eqCnsETechActLYS  = logical(),
   eqCnsETechActLYSGrowth  = logical(),
   eqCnsLETechActLR  = logical(),
   eqCnsGETechActLR  = logical(),
   eqCnsETechActLR  = logical(),
   eqCnsLETechActLRS  = logical(),
   eqCnsGETechActLRS  = logical(),
   eqCnsETechActLRS  = logical(),
   eqCnsLETechActLRY  = logical(),
   eqCnsLETechActLRYGrowth  = logical(),
   eqCnsGETechActLRY  = logical(),
   eqCnsGETechActLRYGrowth  = logical(),
   eqCnsETechActLRY  = logical(),
   eqCnsETechActLRYGrowth  = logical(),
   eqCnsLETechActLRYS  = logical(),
   eqCnsLETechActLRYSGrowth  = logical(),
   eqCnsGETechActLRYS  = logical(),
   eqCnsGETechActLRYSGrowth  = logical(),
   eqCnsETechActLRYS  = logical(),
   eqCnsETechActLRYSGrowth  = logical(),
   eqCnsLETechVaromL  = logical(),
   eqCnsGETechVaromL  = logical(),
   eqCnsETechVaromL  = logical(),
   eqCnsLETechVaromLS  = logical(),
   eqCnsGETechVaromLS  = logical(),
   eqCnsETechVaromLS  = logical(),
   eqCnsLETechVaromLY  = logical(),
   eqCnsLETechVaromLYGrowth  = logical(),
   eqCnsGETechVaromLY  = logical(),
   eqCnsGETechVaromLYGrowth  = logical(),
   eqCnsETechVaromLY  = logical(),
   eqCnsETechVaromLYGrowth  = logical(),
   eqCnsLETechVaromLYS  = logical(),
   eqCnsLETechVaromLYSGrowth  = logical(),
   eqCnsGETechVaromLYS  = logical(),
   eqCnsGETechVaromLYSGrowth  = logical(),
   eqCnsETechVaromLYS  = logical(),
   eqCnsETechVaromLYSGrowth  = logical(),
   eqCnsLETechVaromLR  = logical(),
   eqCnsGETechVaromLR  = logical(),
   eqCnsETechVaromLR  = logical(),
   eqCnsLETechVaromLRS  = logical(),
   eqCnsGETechVaromLRS  = logical(),
   eqCnsETechVaromLRS  = logical(),
   eqCnsLETechVaromLRY  = logical(),
   eqCnsLETechVaromLRYGrowth  = logical(),
   eqCnsGETechVaromLRY  = logical(),
   eqCnsGETechVaromLRYGrowth  = logical(),
   eqCnsETechVaromLRY  = logical(),
   eqCnsETechVaromLRYGrowth  = logical(),
   eqCnsLETechVaromLRYS  = logical(),
   eqCnsLETechVaromLRYSGrowth  = logical(),
   eqCnsGETechVaromLRYS  = logical(),
   eqCnsGETechVaromLRYSGrowth  = logical(),
   eqCnsETechVaromLRYS  = logical(),
   eqCnsETechVaromLRYSGrowth  = logical(),
   eqCnsLETechFixomL  = logical(),
   eqCnsGETechFixomL  = logical(),
   eqCnsETechFixomL  = logical(),
   eqCnsLETechFixomLY  = logical(),
   eqCnsLETechFixomLYGrowth  = logical(),
   eqCnsGETechFixomLY  = logical(),
   eqCnsGETechFixomLYGrowth  = logical(),
   eqCnsETechFixomLY  = logical(),
   eqCnsETechFixomLYGrowth  = logical(),
   eqCnsLETechFixomLR  = logical(),
   eqCnsGETechFixomLR  = logical(),
   eqCnsETechFixomLR  = logical(),
   eqCnsLETechFixomLRY  = logical(),
   eqCnsLETechFixomLRYGrowth  = logical(),
   eqCnsGETechFixomLRY  = logical(),
   eqCnsGETechFixomLRYGrowth  = logical(),
   eqCnsETechFixomLRY  = logical(),
   eqCnsETechFixomLRYGrowth  = logical(),
   eqCnsLETechActvaromL  = logical(),
   eqCnsGETechActvaromL  = logical(),
   eqCnsETechActvaromL  = logical(),
   eqCnsLETechActvaromLS  = logical(),
   eqCnsGETechActvaromLS  = logical(),
   eqCnsETechActvaromLS  = logical(),
   eqCnsLETechActvaromLY  = logical(),
   eqCnsLETechActvaromLYGrowth  = logical(),
   eqCnsGETechActvaromLY  = logical(),
   eqCnsGETechActvaromLYGrowth  = logical(),
   eqCnsETechActvaromLY  = logical(),
   eqCnsETechActvaromLYGrowth  = logical(),
   eqCnsLETechActvaromLYS  = logical(),
   eqCnsLETechActvaromLYSGrowth  = logical(),
   eqCnsGETechActvaromLYS  = logical(),
   eqCnsGETechActvaromLYSGrowth  = logical(),
   eqCnsETechActvaromLYS  = logical(),
   eqCnsETechActvaromLYSGrowth  = logical(),
   eqCnsLETechActvaromLR  = logical(),
   eqCnsGETechActvaromLR  = logical(),
   eqCnsETechActvaromLR  = logical(),
   eqCnsLETechActvaromLRS  = logical(),
   eqCnsGETechActvaromLRS  = logical(),
   eqCnsETechActvaromLRS  = logical(),
   eqCnsLETechActvaromLRY  = logical(),
   eqCnsLETechActvaromLRYGrowth  = logical(),
   eqCnsGETechActvaromLRY  = logical(),
   eqCnsGETechActvaromLRYGrowth  = logical(),
   eqCnsETechActvaromLRY  = logical(),
   eqCnsETechActvaromLRYGrowth  = logical(),
   eqCnsLETechActvaromLRYS  = logical(),
   eqCnsLETechActvaromLRYSGrowth  = logical(),
   eqCnsGETechActvaromLRYS  = logical(),
   eqCnsGETechActvaromLRYSGrowth  = logical(),
   eqCnsETechActvaromLRYS  = logical(),
   eqCnsETechActvaromLRYSGrowth  = logical(),
   eqCnsLETechCvaromL  = logical(),
   eqCnsGETechCvaromL  = logical(),
   eqCnsETechCvaromL  = logical(),
   eqCnsLETechCvaromLS  = logical(),
   eqCnsGETechCvaromLS  = logical(),
   eqCnsETechCvaromLS  = logical(),
   eqCnsLETechCvaromLY  = logical(),
   eqCnsLETechCvaromLYGrowth  = logical(),
   eqCnsGETechCvaromLY  = logical(),
   eqCnsGETechCvaromLYGrowth  = logical(),
   eqCnsETechCvaromLY  = logical(),
   eqCnsETechCvaromLYGrowth  = logical(),
   eqCnsLETechCvaromLYS  = logical(),
   eqCnsLETechCvaromLYSGrowth  = logical(),
   eqCnsGETechCvaromLYS  = logical(),
   eqCnsGETechCvaromLYSGrowth  = logical(),
   eqCnsETechCvaromLYS  = logical(),
   eqCnsETechCvaromLYSGrowth  = logical(),
   eqCnsLETechCvaromLR  = logical(),
   eqCnsGETechCvaromLR  = logical(),
   eqCnsETechCvaromLR  = logical(),
   eqCnsLETechCvaromLRS  = logical(),
   eqCnsGETechCvaromLRS  = logical(),
   eqCnsETechCvaromLRS  = logical(),
   eqCnsLETechCvaromLRY  = logical(),
   eqCnsLETechCvaromLRYGrowth  = logical(),
   eqCnsGETechCvaromLRY  = logical(),
   eqCnsGETechCvaromLRYGrowth  = logical(),
   eqCnsETechCvaromLRY  = logical(),
   eqCnsETechCvaromLRYGrowth  = logical(),
   eqCnsLETechCvaromLRYS  = logical(),
   eqCnsLETechCvaromLRYSGrowth  = logical(),
   eqCnsGETechCvaromLRYS  = logical(),
   eqCnsGETechCvaromLRYSGrowth  = logical(),
   eqCnsETechCvaromLRYS  = logical(),
   eqCnsETechCvaromLRYSGrowth  = logical(),
   eqCnsLETechAvaromL  = logical(),
   eqCnsGETechAvaromL  = logical(),
   eqCnsETechAvaromL  = logical(),
   eqCnsLETechAvaromLS  = logical(),
   eqCnsGETechAvaromLS  = logical(),
   eqCnsETechAvaromLS  = logical(),
   eqCnsLETechAvaromLY  = logical(),
   eqCnsLETechAvaromLYGrowth  = logical(),
   eqCnsGETechAvaromLY  = logical(),
   eqCnsGETechAvaromLYGrowth  = logical(),
   eqCnsETechAvaromLY  = logical(),
   eqCnsETechAvaromLYGrowth  = logical(),
   eqCnsLETechAvaromLYS  = logical(),
   eqCnsLETechAvaromLYSGrowth  = logical(),
   eqCnsGETechAvaromLYS  = logical(),
   eqCnsGETechAvaromLYSGrowth  = logical(),
   eqCnsETechAvaromLYS  = logical(),
   eqCnsETechAvaromLYSGrowth  = logical(),
   eqCnsLETechAvaromLR  = logical(),
   eqCnsGETechAvaromLR  = logical(),
   eqCnsETechAvaromLR  = logical(),
   eqCnsLETechAvaromLRS  = logical(),
   eqCnsGETechAvaromLRS  = logical(),
   eqCnsETechAvaromLRS  = logical(),
   eqCnsLETechAvaromLRY  = logical(),
   eqCnsLETechAvaromLRYGrowth  = logical(),
   eqCnsGETechAvaromLRY  = logical(),
   eqCnsGETechAvaromLRYGrowth  = logical(),
   eqCnsETechAvaromLRY  = logical(),
   eqCnsETechAvaromLRYGrowth  = logical(),
   eqCnsLETechAvaromLRYS  = logical(),
   eqCnsLETechAvaromLRYSGrowth  = logical(),
   eqCnsGETechAvaromLRYS  = logical(),
   eqCnsGETechAvaromLRYSGrowth  = logical(),
   eqCnsETechAvaromLRYS  = logical(),
   eqCnsETechAvaromLRYSGrowth  = logical(),
   eqCnsLESupOutShareIn  = logical(),
   eqCnsLESupOutShareOut  = logical(),
   eqCnsLESupOut  = logical(),
   eqCnsGESupOutShareIn  = logical(),
   eqCnsGESupOutShareOut  = logical(),
   eqCnsGESupOut  = logical(),
   eqCnsESupOutShareIn  = logical(),
   eqCnsESupOutShareOut  = logical(),
   eqCnsESupOut  = logical(),
   eqCnsLESupOutSShareIn  = logical(),
   eqCnsLESupOutSShareOut  = logical(),
   eqCnsLESupOutS  = logical(),
   eqCnsGESupOutSShareIn  = logical(),
   eqCnsGESupOutSShareOut  = logical(),
   eqCnsGESupOutS  = logical(),
   eqCnsESupOutSShareIn  = logical(),
   eqCnsESupOutSShareOut  = logical(),
   eqCnsESupOutS  = logical(),
   eqCnsLESupOutYShareIn  = logical(),
   eqCnsLESupOutYShareOut  = logical(),
   eqCnsLESupOutY  = logical(),
   eqCnsLESupOutYGrowth  = logical(),
   eqCnsGESupOutYShareIn  = logical(),
   eqCnsGESupOutYShareOut  = logical(),
   eqCnsGESupOutY  = logical(),
   eqCnsGESupOutYGrowth  = logical(),
   eqCnsESupOutYShareIn  = logical(),
   eqCnsESupOutYShareOut  = logical(),
   eqCnsESupOutY  = logical(),
   eqCnsESupOutYGrowth  = logical(),
   eqCnsLESupOutYSShareIn  = logical(),
   eqCnsLESupOutYSShareOut  = logical(),
   eqCnsLESupOutYS  = logical(),
   eqCnsLESupOutYSGrowth  = logical(),
   eqCnsGESupOutYSShareIn  = logical(),
   eqCnsGESupOutYSShareOut  = logical(),
   eqCnsGESupOutYS  = logical(),
   eqCnsGESupOutYSGrowth  = logical(),
   eqCnsESupOutYSShareIn  = logical(),
   eqCnsESupOutYSShareOut  = logical(),
   eqCnsESupOutYS  = logical(),
   eqCnsESupOutYSGrowth  = logical(),
   eqCnsLESupOutRShareIn  = logical(),
   eqCnsLESupOutRShareOut  = logical(),
   eqCnsLESupOutR  = logical(),
   eqCnsGESupOutRShareIn  = logical(),
   eqCnsGESupOutRShareOut  = logical(),
   eqCnsGESupOutR  = logical(),
   eqCnsESupOutRShareIn  = logical(),
   eqCnsESupOutRShareOut  = logical(),
   eqCnsESupOutR  = logical(),
   eqCnsLESupOutRSShareIn  = logical(),
   eqCnsLESupOutRSShareOut  = logical(),
   eqCnsLESupOutRS  = logical(),
   eqCnsGESupOutRSShareIn  = logical(),
   eqCnsGESupOutRSShareOut  = logical(),
   eqCnsGESupOutRS  = logical(),
   eqCnsESupOutRSShareIn  = logical(),
   eqCnsESupOutRSShareOut  = logical(),
   eqCnsESupOutRS  = logical(),
   eqCnsLESupOutRYShareIn  = logical(),
   eqCnsLESupOutRYShareOut  = logical(),
   eqCnsLESupOutRY  = logical(),
   eqCnsLESupOutRYGrowth  = logical(),
   eqCnsGESupOutRYShareIn  = logical(),
   eqCnsGESupOutRYShareOut  = logical(),
   eqCnsGESupOutRY  = logical(),
   eqCnsGESupOutRYGrowth  = logical(),
   eqCnsESupOutRYShareIn  = logical(),
   eqCnsESupOutRYShareOut  = logical(),
   eqCnsESupOutRY  = logical(),
   eqCnsESupOutRYGrowth  = logical(),
   eqCnsLESupOutRYSShareIn  = logical(),
   eqCnsLESupOutRYSShareOut  = logical(),
   eqCnsLESupOutRYS  = logical(),
   eqCnsLESupOutRYSGrowth  = logical(),
   eqCnsGESupOutRYSShareIn  = logical(),
   eqCnsGESupOutRYSShareOut  = logical(),
   eqCnsGESupOutRYS  = logical(),
   eqCnsGESupOutRYSGrowth  = logical(),
   eqCnsESupOutRYSShareIn  = logical(),
   eqCnsESupOutRYSShareOut  = logical(),
   eqCnsESupOutRYS  = logical(),
   eqCnsESupOutRYSGrowth  = logical(),
   eqCnsLESupOutCShareIn  = logical(),
   eqCnsLESupOutCShareOut  = logical(),
   eqCnsLESupOutC  = logical(),
   eqCnsGESupOutCShareIn  = logical(),
   eqCnsGESupOutCShareOut  = logical(),
   eqCnsGESupOutC  = logical(),
   eqCnsESupOutCShareIn  = logical(),
   eqCnsESupOutCShareOut  = logical(),
   eqCnsESupOutC  = logical(),
   eqCnsLESupOutCSShareIn  = logical(),
   eqCnsLESupOutCSShareOut  = logical(),
   eqCnsLESupOutCS  = logical(),
   eqCnsGESupOutCSShareIn  = logical(),
   eqCnsGESupOutCSShareOut  = logical(),
   eqCnsGESupOutCS  = logical(),
   eqCnsESupOutCSShareIn  = logical(),
   eqCnsESupOutCSShareOut  = logical(),
   eqCnsESupOutCS  = logical(),
   eqCnsLESupOutCYShareIn  = logical(),
   eqCnsLESupOutCYShareOut  = logical(),
   eqCnsLESupOutCY  = logical(),
   eqCnsLESupOutCYGrowth  = logical(),
   eqCnsGESupOutCYShareIn  = logical(),
   eqCnsGESupOutCYShareOut  = logical(),
   eqCnsGESupOutCY  = logical(),
   eqCnsGESupOutCYGrowth  = logical(),
   eqCnsESupOutCYShareIn  = logical(),
   eqCnsESupOutCYShareOut  = logical(),
   eqCnsESupOutCY  = logical(),
   eqCnsESupOutCYGrowth  = logical(),
   eqCnsLESupOutCYSShareIn  = logical(),
   eqCnsLESupOutCYSShareOut  = logical(),
   eqCnsLESupOutCYS  = logical(),
   eqCnsLESupOutCYSGrowth  = logical(),
   eqCnsGESupOutCYSShareIn  = logical(),
   eqCnsGESupOutCYSShareOut  = logical(),
   eqCnsGESupOutCYS  = logical(),
   eqCnsGESupOutCYSGrowth  = logical(),
   eqCnsESupOutCYSShareIn  = logical(),
   eqCnsESupOutCYSShareOut  = logical(),
   eqCnsESupOutCYS  = logical(),
   eqCnsESupOutCYSGrowth  = logical(),
   eqCnsLESupOutCRShareIn  = logical(),
   eqCnsLESupOutCRShareOut  = logical(),
   eqCnsLESupOutCR  = logical(),
   eqCnsGESupOutCRShareIn  = logical(),
   eqCnsGESupOutCRShareOut  = logical(),
   eqCnsGESupOutCR  = logical(),
   eqCnsESupOutCRShareIn  = logical(),
   eqCnsESupOutCRShareOut  = logical(),
   eqCnsESupOutCR  = logical(),
   eqCnsLESupOutCRSShareIn  = logical(),
   eqCnsLESupOutCRSShareOut  = logical(),
   eqCnsLESupOutCRS  = logical(),
   eqCnsGESupOutCRSShareIn  = logical(),
   eqCnsGESupOutCRSShareOut  = logical(),
   eqCnsGESupOutCRS  = logical(),
   eqCnsESupOutCRSShareIn  = logical(),
   eqCnsESupOutCRSShareOut  = logical(),
   eqCnsESupOutCRS  = logical(),
   eqCnsLESupOutCRYShareIn  = logical(),
   eqCnsLESupOutCRYShareOut  = logical(),
   eqCnsLESupOutCRY  = logical(),
   eqCnsLESupOutCRYGrowth  = logical(),
   eqCnsGESupOutCRYShareIn  = logical(),
   eqCnsGESupOutCRYShareOut  = logical(),
   eqCnsGESupOutCRY  = logical(),
   eqCnsGESupOutCRYGrowth  = logical(),
   eqCnsESupOutCRYShareIn  = logical(),
   eqCnsESupOutCRYShareOut  = logical(),
   eqCnsESupOutCRY  = logical(),
   eqCnsESupOutCRYGrowth  = logical(),
   eqCnsLESupOutCRYSShareIn  = logical(),
   eqCnsLESupOutCRYSShareOut  = logical(),
   eqCnsLESupOutCRYS  = logical(),
   eqCnsLESupOutCRYSGrowth  = logical(),
   eqCnsGESupOutCRYSShareIn  = logical(),
   eqCnsGESupOutCRYSShareOut  = logical(),
   eqCnsGESupOutCRYS  = logical(),
   eqCnsGESupOutCRYSGrowth  = logical(),
   eqCnsESupOutCRYSShareIn  = logical(),
   eqCnsESupOutCRYSShareOut  = logical(),
   eqCnsESupOutCRYS  = logical(),
   eqCnsESupOutCRYSGrowth  = logical(),
   eqCnsLESupOutLShareIn  = logical(),
   eqCnsLESupOutLShareOut  = logical(),
   eqCnsLESupOutL  = logical(),
   eqCnsGESupOutLShareIn  = logical(),
   eqCnsGESupOutLShareOut  = logical(),
   eqCnsGESupOutL  = logical(),
   eqCnsESupOutLShareIn  = logical(),
   eqCnsESupOutLShareOut  = logical(),
   eqCnsESupOutL  = logical(),
   eqCnsLESupOutLSShareIn  = logical(),
   eqCnsLESupOutLSShareOut  = logical(),
   eqCnsLESupOutLS  = logical(),
   eqCnsGESupOutLSShareIn  = logical(),
   eqCnsGESupOutLSShareOut  = logical(),
   eqCnsGESupOutLS  = logical(),
   eqCnsESupOutLSShareIn  = logical(),
   eqCnsESupOutLSShareOut  = logical(),
   eqCnsESupOutLS  = logical(),
   eqCnsLESupOutLYShareIn  = logical(),
   eqCnsLESupOutLYShareOut  = logical(),
   eqCnsLESupOutLY  = logical(),
   eqCnsLESupOutLYGrowth  = logical(),
   eqCnsGESupOutLYShareIn  = logical(),
   eqCnsGESupOutLYShareOut  = logical(),
   eqCnsGESupOutLY  = logical(),
   eqCnsGESupOutLYGrowth  = logical(),
   eqCnsESupOutLYShareIn  = logical(),
   eqCnsESupOutLYShareOut  = logical(),
   eqCnsESupOutLY  = logical(),
   eqCnsESupOutLYGrowth  = logical(),
   eqCnsLESupOutLYSShareIn  = logical(),
   eqCnsLESupOutLYSShareOut  = logical(),
   eqCnsLESupOutLYS  = logical(),
   eqCnsLESupOutLYSGrowth  = logical(),
   eqCnsGESupOutLYSShareIn  = logical(),
   eqCnsGESupOutLYSShareOut  = logical(),
   eqCnsGESupOutLYS  = logical(),
   eqCnsGESupOutLYSGrowth  = logical(),
   eqCnsESupOutLYSShareIn  = logical(),
   eqCnsESupOutLYSShareOut  = logical(),
   eqCnsESupOutLYS  = logical(),
   eqCnsESupOutLYSGrowth  = logical(),
   eqCnsLESupOutLRShareIn  = logical(),
   eqCnsLESupOutLRShareOut  = logical(),
   eqCnsLESupOutLR  = logical(),
   eqCnsGESupOutLRShareIn  = logical(),
   eqCnsGESupOutLRShareOut  = logical(),
   eqCnsGESupOutLR  = logical(),
   eqCnsESupOutLRShareIn  = logical(),
   eqCnsESupOutLRShareOut  = logical(),
   eqCnsESupOutLR  = logical(),
   eqCnsLESupOutLRSShareIn  = logical(),
   eqCnsLESupOutLRSShareOut  = logical(),
   eqCnsLESupOutLRS  = logical(),
   eqCnsGESupOutLRSShareIn  = logical(),
   eqCnsGESupOutLRSShareOut  = logical(),
   eqCnsGESupOutLRS  = logical(),
   eqCnsESupOutLRSShareIn  = logical(),
   eqCnsESupOutLRSShareOut  = logical(),
   eqCnsESupOutLRS  = logical(),
   eqCnsLESupOutLRYShareIn  = logical(),
   eqCnsLESupOutLRYShareOut  = logical(),
   eqCnsLESupOutLRY  = logical(),
   eqCnsLESupOutLRYGrowth  = logical(),
   eqCnsGESupOutLRYShareIn  = logical(),
   eqCnsGESupOutLRYShareOut  = logical(),
   eqCnsGESupOutLRY  = logical(),
   eqCnsGESupOutLRYGrowth  = logical(),
   eqCnsESupOutLRYShareIn  = logical(),
   eqCnsESupOutLRYShareOut  = logical(),
   eqCnsESupOutLRY  = logical(),
   eqCnsESupOutLRYGrowth  = logical(),
   eqCnsLESupOutLRYSShareIn  = logical(),
   eqCnsLESupOutLRYSShareOut  = logical(),
   eqCnsLESupOutLRYS  = logical(),
   eqCnsLESupOutLRYSGrowth  = logical(),
   eqCnsGESupOutLRYSShareIn  = logical(),
   eqCnsGESupOutLRYSShareOut  = logical(),
   eqCnsGESupOutLRYS  = logical(),
   eqCnsGESupOutLRYSGrowth  = logical(),
   eqCnsESupOutLRYSShareIn  = logical(),
   eqCnsESupOutLRYSShareOut  = logical(),
   eqCnsESupOutLRYS  = logical(),
   eqCnsESupOutLRYSGrowth  = logical(),
   eqCnsLESupOutLCShareIn  = logical(),
   eqCnsLESupOutLCShareOut  = logical(),
   eqCnsLESupOutLC  = logical(),
   eqCnsGESupOutLCShareIn  = logical(),
   eqCnsGESupOutLCShareOut  = logical(),
   eqCnsGESupOutLC  = logical(),
   eqCnsESupOutLCShareIn  = logical(),
   eqCnsESupOutLCShareOut  = logical(),
   eqCnsESupOutLC  = logical(),
   eqCnsLESupOutLCSShareIn  = logical(),
   eqCnsLESupOutLCSShareOut  = logical(),
   eqCnsLESupOutLCS  = logical(),
   eqCnsGESupOutLCSShareIn  = logical(),
   eqCnsGESupOutLCSShareOut  = logical(),
   eqCnsGESupOutLCS  = logical(),
   eqCnsESupOutLCSShareIn  = logical(),
   eqCnsESupOutLCSShareOut  = logical(),
   eqCnsESupOutLCS  = logical(),
   eqCnsLESupOutLCYShareIn  = logical(),
   eqCnsLESupOutLCYShareOut  = logical(),
   eqCnsLESupOutLCY  = logical(),
   eqCnsLESupOutLCYGrowth  = logical(),
   eqCnsGESupOutLCYShareIn  = logical(),
   eqCnsGESupOutLCYShareOut  = logical(),
   eqCnsGESupOutLCY  = logical(),
   eqCnsGESupOutLCYGrowth  = logical(),
   eqCnsESupOutLCYShareIn  = logical(),
   eqCnsESupOutLCYShareOut  = logical(),
   eqCnsESupOutLCY  = logical(),
   eqCnsESupOutLCYGrowth  = logical(),
   eqCnsLESupOutLCYSShareIn  = logical(),
   eqCnsLESupOutLCYSShareOut  = logical(),
   eqCnsLESupOutLCYS  = logical(),
   eqCnsLESupOutLCYSGrowth  = logical(),
   eqCnsGESupOutLCYSShareIn  = logical(),
   eqCnsGESupOutLCYSShareOut  = logical(),
   eqCnsGESupOutLCYS  = logical(),
   eqCnsGESupOutLCYSGrowth  = logical(),
   eqCnsESupOutLCYSShareIn  = logical(),
   eqCnsESupOutLCYSShareOut  = logical(),
   eqCnsESupOutLCYS  = logical(),
   eqCnsESupOutLCYSGrowth  = logical(),
   eqCnsLESupOutLCRShareIn  = logical(),
   eqCnsLESupOutLCRShareOut  = logical(),
   eqCnsLESupOutLCR  = logical(),
   eqCnsGESupOutLCRShareIn  = logical(),
   eqCnsGESupOutLCRShareOut  = logical(),
   eqCnsGESupOutLCR  = logical(),
   eqCnsESupOutLCRShareIn  = logical(),
   eqCnsESupOutLCRShareOut  = logical(),
   eqCnsESupOutLCR  = logical(),
   eqCnsLESupOutLCRSShareIn  = logical(),
   eqCnsLESupOutLCRSShareOut  = logical(),
   eqCnsLESupOutLCRS  = logical(),
   eqCnsGESupOutLCRSShareIn  = logical(),
   eqCnsGESupOutLCRSShareOut  = logical(),
   eqCnsGESupOutLCRS  = logical(),
   eqCnsESupOutLCRSShareIn  = logical(),
   eqCnsESupOutLCRSShareOut  = logical(),
   eqCnsESupOutLCRS  = logical(),
   eqCnsLESupOutLCRYShareIn  = logical(),
   eqCnsLESupOutLCRYShareOut  = logical(),
   eqCnsLESupOutLCRY  = logical(),
   eqCnsLESupOutLCRYGrowth  = logical(),
   eqCnsGESupOutLCRYShareIn  = logical(),
   eqCnsGESupOutLCRYShareOut  = logical(),
   eqCnsGESupOutLCRY  = logical(),
   eqCnsGESupOutLCRYGrowth  = logical(),
   eqCnsESupOutLCRYShareIn  = logical(),
   eqCnsESupOutLCRYShareOut  = logical(),
   eqCnsESupOutLCRY  = logical(),
   eqCnsESupOutLCRYGrowth  = logical(),
   eqCnsLESupOutLCRYSShareIn  = logical(),
   eqCnsLESupOutLCRYSShareOut  = logical(),
   eqCnsLESupOutLCRYS  = logical(),
   eqCnsLESupOutLCRYSGrowth  = logical(),
   eqCnsGESupOutLCRYSShareIn  = logical(),
   eqCnsGESupOutLCRYSShareOut  = logical(),
   eqCnsGESupOutLCRYS  = logical(),
   eqCnsGESupOutLCRYSGrowth  = logical(),
   eqCnsESupOutLCRYSShareIn  = logical(),
   eqCnsESupOutLCRYSShareOut  = logical(),
   eqCnsESupOutLCRYS  = logical(),
   eqCnsESupOutLCRYSGrowth  = logical(),
   eqCnsLETotInp  = logical(),
   eqCnsGETotInp  = logical(),
   eqCnsETotInp  = logical(),
   eqCnsLETotInpS  = logical(),
   eqCnsGETotInpS  = logical(),
   eqCnsETotInpS  = logical(),
   eqCnsLETotInpY  = logical(),
   eqCnsLETotInpYGrowth  = logical(),
   eqCnsGETotInpY  = logical(),
   eqCnsGETotInpYGrowth  = logical(),
   eqCnsETotInpY  = logical(),
   eqCnsETotInpYGrowth  = logical(),
   eqCnsLETotInpYS  = logical(),
   eqCnsLETotInpYSGrowth  = logical(),
   eqCnsGETotInpYS  = logical(),
   eqCnsGETotInpYSGrowth  = logical(),
   eqCnsETotInpYS  = logical(),
   eqCnsETotInpYSGrowth  = logical(),
   eqCnsLETotInpR  = logical(),
   eqCnsGETotInpR  = logical(),
   eqCnsETotInpR  = logical(),
   eqCnsLETotInpRS  = logical(),
   eqCnsGETotInpRS  = logical(),
   eqCnsETotInpRS  = logical(),
   eqCnsLETotInpRY  = logical(),
   eqCnsLETotInpRYGrowth  = logical(),
   eqCnsGETotInpRY  = logical(),
   eqCnsGETotInpRYGrowth  = logical(),
   eqCnsETotInpRY  = logical(),
   eqCnsETotInpRYGrowth  = logical(),
   eqCnsLETotInpRYS  = logical(),
   eqCnsLETotInpRYSGrowth  = logical(),
   eqCnsGETotInpRYS  = logical(),
   eqCnsGETotInpRYSGrowth  = logical(),
   eqCnsETotInpRYS  = logical(),
   eqCnsETotInpRYSGrowth  = logical(),
   eqCnsLETotInpC  = logical(),
   eqCnsGETotInpC  = logical(),
   eqCnsETotInpC  = logical(),
   eqCnsLETotInpCS  = logical(),
   eqCnsGETotInpCS  = logical(),
   eqCnsETotInpCS  = logical(),
   eqCnsLETotInpCY  = logical(),
   eqCnsLETotInpCYGrowth  = logical(),
   eqCnsGETotInpCY  = logical(),
   eqCnsGETotInpCYGrowth  = logical(),
   eqCnsETotInpCY  = logical(),
   eqCnsETotInpCYGrowth  = logical(),
   eqCnsLETotInpCYS  = logical(),
   eqCnsLETotInpCYSGrowth  = logical(),
   eqCnsGETotInpCYS  = logical(),
   eqCnsGETotInpCYSGrowth  = logical(),
   eqCnsETotInpCYS  = logical(),
   eqCnsETotInpCYSGrowth  = logical(),
   eqCnsLETotInpCR  = logical(),
   eqCnsGETotInpCR  = logical(),
   eqCnsETotInpCR  = logical(),
   eqCnsLETotInpCRS  = logical(),
   eqCnsGETotInpCRS  = logical(),
   eqCnsETotInpCRS  = logical(),
   eqCnsLETotInpCRY  = logical(),
   eqCnsLETotInpCRYGrowth  = logical(),
   eqCnsGETotInpCRY  = logical(),
   eqCnsGETotInpCRYGrowth  = logical(),
   eqCnsETotInpCRY  = logical(),
   eqCnsETotInpCRYGrowth  = logical(),
   eqCnsLETotInpCRYS  = logical(),
   eqCnsLETotInpCRYSGrowth  = logical(),
   eqCnsGETotInpCRYS  = logical(),
   eqCnsGETotInpCRYSGrowth  = logical(),
   eqCnsETotInpCRYS  = logical(),
   eqCnsETotInpCRYSGrowth  = logical(),
   eqCnsLETotOut  = logical(),
   eqCnsGETotOut  = logical(),
   eqCnsETotOut  = logical(),
   eqCnsLETotOutS  = logical(),
   eqCnsGETotOutS  = logical(),
   eqCnsETotOutS  = logical(),
   eqCnsLETotOutY  = logical(),
   eqCnsLETotOutYGrowth  = logical(),
   eqCnsGETotOutY  = logical(),
   eqCnsGETotOutYGrowth  = logical(),
   eqCnsETotOutY  = logical(),
   eqCnsETotOutYGrowth  = logical(),
   eqCnsLETotOutYS  = logical(),
   eqCnsLETotOutYSGrowth  = logical(),
   eqCnsGETotOutYS  = logical(),
   eqCnsGETotOutYSGrowth  = logical(),
   eqCnsETotOutYS  = logical(),
   eqCnsETotOutYSGrowth  = logical(),
   eqCnsLETotOutR  = logical(),
   eqCnsGETotOutR  = logical(),
   eqCnsETotOutR  = logical(),
   eqCnsLETotOutRS  = logical(),
   eqCnsGETotOutRS  = logical(),
   eqCnsETotOutRS  = logical(),
   eqCnsLETotOutRY  = logical(),
   eqCnsLETotOutRYGrowth  = logical(),
   eqCnsGETotOutRY  = logical(),
   eqCnsGETotOutRYGrowth  = logical(),
   eqCnsETotOutRY  = logical(),
   eqCnsETotOutRYGrowth  = logical(),
   eqCnsLETotOutRYS  = logical(),
   eqCnsLETotOutRYSGrowth  = logical(),
   eqCnsGETotOutRYS  = logical(),
   eqCnsGETotOutRYSGrowth  = logical(),
   eqCnsETotOutRYS  = logical(),
   eqCnsETotOutRYSGrowth  = logical(),
   eqCnsLETotOutC  = logical(),
   eqCnsGETotOutC  = logical(),
   eqCnsETotOutC  = logical(),
   eqCnsLETotOutCS  = logical(),
   eqCnsGETotOutCS  = logical(),
   eqCnsETotOutCS  = logical(),
   eqCnsLETotOutCY  = logical(),
   eqCnsLETotOutCYGrowth  = logical(),
   eqCnsGETotOutCY  = logical(),
   eqCnsGETotOutCYGrowth  = logical(),
   eqCnsETotOutCY  = logical(),
   eqCnsETotOutCYGrowth  = logical(),
   eqCnsLETotOutCYS  = logical(),
   eqCnsLETotOutCYSGrowth  = logical(),
   eqCnsGETotOutCYS  = logical(),
   eqCnsGETotOutCYSGrowth  = logical(),
   eqCnsETotOutCYS  = logical(),
   eqCnsETotOutCYSGrowth  = logical(),
   eqCnsLETotOutCR  = logical(),
   eqCnsGETotOutCR  = logical(),
   eqCnsETotOutCR  = logical(),
   eqCnsLETotOutCRS  = logical(),
   eqCnsGETotOutCRS  = logical(),
   eqCnsETotOutCRS  = logical(),
   eqCnsLETotOutCRY  = logical(),
   eqCnsLETotOutCRYGrowth  = logical(),
   eqCnsGETotOutCRY  = logical(),
   eqCnsGETotOutCRYGrowth  = logical(),
   eqCnsETotOutCRY  = logical(),
   eqCnsETotOutCRYGrowth  = logical(),
   eqCnsLETotOutCRYS  = logical(),
   eqCnsLETotOutCRYSGrowth  = logical(),
   eqCnsGETotOutCRYS  = logical(),
   eqCnsGETotOutCRYSGrowth  = logical(),
   eqCnsETotOutCRYS  = logical(),
   eqCnsETotOutCRYSGrowth  = logical(),
   eqLECActivity  = logical(),
   eqPreDefTechUse  = logical(),
   eqPreDefTechNewCap  = logical(),
   eqPreDefTechRetirementCap  = logical(),
   eqPreDefTechCap  = logical(),
   eqPreDefTechAct  = logical(),
   eqPreDefTechInp  = logical(),
   eqPreDefTechOut  = logical(),
   eqPreDefTechAInp  = logical(),
   eqPreDefTechAOut  = logical(),
   eqPreDefSupOut  = logical(),
   eqPreDefDemInp  = logical(),
   eqPreDefDumOut  = logical(),
   eqPreDefStorageInp  = logical(),
   eqPreDefStorageOut  = logical(),
   eqPreDefStorageStore  = logical(),
   eqPreDefStorageCap  = logical(),
   eqPreDefStorageNewCap  = logical(),
   eqPreDefImport  = logical(),
   eqPreDefExport  = logical(),
   eqPreDefTradeIr  = logical(),
   eqPreDefExportRow  = logical(),
   eqPreDefImportRow  = logical(),
      stringsAsFactors = FALSE);
    rs[1:59,] <- NA;
    rs["vTechFixom", c("name", "description")] <- c("vTechFixom", "Fixom");
    rs["vTechFixom", c("tech", "region", "year", "eqTechFixom", "eqCnsLETechFixom", "eqCnsGETechFixom", "eqCnsETechFixom", "eqCnsLETechFixomY", "eqCnsLETechFixomYGrowth", "eqCnsGETechFixomY", "eqCnsGETechFixomYGrowth", "eqCnsETechFixomY", "eqCnsETechFixomYGrowth", "eqCnsLETechFixomR", "eqCnsGETechFixomR", "eqCnsETechFixomR", "eqCnsLETechFixomRY", "eqCnsLETechFixomRYGrowth", "eqCnsGETechFixomRY", "eqCnsGETechFixomRYGrowth", "eqCnsETechFixomRY", "eqCnsETechFixomRYGrowth", "eqCnsLETechFixomL", "eqCnsGETechFixomL", "eqCnsETechFixomL", "eqCnsLETechFixomLY", "eqCnsLETechFixomLYGrowth", "eqCnsGETechFixomLY", "eqCnsGETechFixomLYGrowth", "eqCnsETechFixomLY", "eqCnsETechFixomLYGrowth", "eqCnsLETechFixomLR", "eqCnsGETechFixomLR", "eqCnsETechFixomLR", "eqCnsLETechFixomLRY", "eqCnsLETechFixomLRYGrowth", "eqCnsGETechFixomLRY", "eqCnsGETechFixomLRYGrowth", "eqCnsETechFixomLRY", "eqCnsETechFixomLRYGrowth")] <- TRUE;
    rs["vTechVarom", c("name", "description")] <- c("vTechVarom", "Varom");
    rs["vTechVarom", c("tech", "region", "year", "slice", "eqTechVarom", "eqCnsLETechVarom", "eqCnsGETechVarom", "eqCnsETechVarom", "eqCnsLETechVaromS", "eqCnsGETechVaromS", "eqCnsETechVaromS", "eqCnsLETechVaromY", "eqCnsLETechVaromYGrowth", "eqCnsGETechVaromY", "eqCnsGETechVaromYGrowth", "eqCnsETechVaromY", "eqCnsETechVaromYGrowth", "eqCnsLETechVaromYS", "eqCnsLETechVaromYSGrowth", "eqCnsGETechVaromYS", "eqCnsGETechVaromYSGrowth", "eqCnsETechVaromYS", "eqCnsETechVaromYSGrowth", "eqCnsLETechVaromR", "eqCnsGETechVaromR", "eqCnsETechVaromR", "eqCnsLETechVaromRS", "eqCnsGETechVaromRS", "eqCnsETechVaromRS", "eqCnsLETechVaromRY", "eqCnsLETechVaromRYGrowth", "eqCnsGETechVaromRY", "eqCnsGETechVaromRYGrowth", "eqCnsETechVaromRY", "eqCnsETechVaromRYGrowth", "eqCnsLETechVaromRYS", "eqCnsLETechVaromRYSGrowth", "eqCnsGETechVaromRYS", "eqCnsGETechVaromRYSGrowth", "eqCnsETechVaromRYS", "eqCnsETechVaromRYSGrowth", "eqCnsLETechVaromL", "eqCnsGETechVaromL", "eqCnsETechVaromL", "eqCnsLETechVaromLS", "eqCnsGETechVaromLS", "eqCnsETechVaromLS", "eqCnsLETechVaromLY", "eqCnsLETechVaromLYGrowth", "eqCnsGETechVaromLY", "eqCnsGETechVaromLYGrowth", "eqCnsETechVaromLY", "eqCnsETechVaromLYGrowth", "eqCnsLETechVaromLYS", "eqCnsLETechVaromLYSGrowth", "eqCnsGETechVaromLYS", "eqCnsGETechVaromLYSGrowth", "eqCnsETechVaromLYS", "eqCnsETechVaromLYSGrowth", "eqCnsLETechVaromLR", "eqCnsGETechVaromLR", "eqCnsETechVaromLR", "eqCnsLETechVaromLRS", "eqCnsGETechVaromLRS", "eqCnsETechVaromLRS", "eqCnsLETechVaromLRY", "eqCnsLETechVaromLRYGrowth", "eqCnsGETechVaromLRY", "eqCnsGETechVaromLRYGrowth", "eqCnsETechVaromLRY", "eqCnsETechVaromLRYGrowth", "eqCnsLETechVaromLRYS", "eqCnsLETechVaromLRYSGrowth", "eqCnsGETechVaromLRYS", "eqCnsGETechVaromLRYSGrowth", "eqCnsETechVaromLRYS", "eqCnsETechVaromLRYSGrowth")] <- TRUE;
    rs["vTechActVarom", c("name", "description")] <- c("vTechActVarom", "Activity Varom");
    rs["vTechActVarom", c("tech", "region", "year", "slice", "eqTechActVarom", "eqCnsLETechActvarom", "eqCnsGETechActvarom", "eqCnsETechActvarom", "eqCnsLETechActvaromS", "eqCnsGETechActvaromS", "eqCnsETechActvaromS", "eqCnsLETechActvaromY", "eqCnsLETechActvaromYGrowth", "eqCnsGETechActvaromY", "eqCnsGETechActvaromYGrowth", "eqCnsETechActvaromY", "eqCnsETechActvaromYGrowth", "eqCnsLETechActvaromYS", "eqCnsLETechActvaromYSGrowth", "eqCnsGETechActvaromYS", "eqCnsGETechActvaromYSGrowth", "eqCnsETechActvaromYS", "eqCnsETechActvaromYSGrowth", "eqCnsLETechActvaromR", "eqCnsGETechActvaromR", "eqCnsETechActvaromR", "eqCnsLETechActvaromRS", "eqCnsGETechActvaromRS", "eqCnsETechActvaromRS", "eqCnsLETechActvaromRY", "eqCnsLETechActvaromRYGrowth", "eqCnsGETechActvaromRY", "eqCnsGETechActvaromRYGrowth", "eqCnsETechActvaromRY", "eqCnsETechActvaromRYGrowth", "eqCnsLETechActvaromRYS", "eqCnsLETechActvaromRYSGrowth", "eqCnsGETechActvaromRYS", "eqCnsGETechActvaromRYSGrowth", "eqCnsETechActvaromRYS", "eqCnsETechActvaromRYSGrowth", "eqCnsLETechActvaromL", "eqCnsGETechActvaromL", "eqCnsETechActvaromL", "eqCnsLETechActvaromLS", "eqCnsGETechActvaromLS", "eqCnsETechActvaromLS", "eqCnsLETechActvaromLY", "eqCnsLETechActvaromLYGrowth", "eqCnsGETechActvaromLY", "eqCnsGETechActvaromLYGrowth", "eqCnsETechActvaromLY", "eqCnsETechActvaromLYGrowth", "eqCnsLETechActvaromLYS", "eqCnsLETechActvaromLYSGrowth", "eqCnsGETechActvaromLYS", "eqCnsGETechActvaromLYSGrowth", "eqCnsETechActvaromLYS", "eqCnsETechActvaromLYSGrowth", "eqCnsLETechActvaromLR", "eqCnsGETechActvaromLR", "eqCnsETechActvaromLR", "eqCnsLETechActvaromLRS", "eqCnsGETechActvaromLRS", "eqCnsETechActvaromLRS", "eqCnsLETechActvaromLRY", "eqCnsLETechActvaromLRYGrowth", "eqCnsGETechActvaromLRY", "eqCnsGETechActvaromLRYGrowth", "eqCnsETechActvaromLRY", "eqCnsETechActvaromLRYGrowth", "eqCnsLETechActvaromLRYS", "eqCnsLETechActvaromLRYSGrowth", "eqCnsGETechActvaromLRYS", "eqCnsGETechActvaromLRYSGrowth", "eqCnsETechActvaromLRYS", "eqCnsETechActvaromLRYSGrowth")] <- TRUE;
    rs["vTechCVarom", c("name", "description")] <- c("vTechCVarom", "Commodity Varom");
    rs["vTechCVarom", c("tech", "region", "year", "slice", "eqTechCVarom", "eqCnsLETechCvarom", "eqCnsGETechCvarom", "eqCnsETechCvarom", "eqCnsLETechCvaromS", "eqCnsGETechCvaromS", "eqCnsETechCvaromS", "eqCnsLETechCvaromY", "eqCnsLETechCvaromYGrowth", "eqCnsGETechCvaromY", "eqCnsGETechCvaromYGrowth", "eqCnsETechCvaromY", "eqCnsETechCvaromYGrowth", "eqCnsLETechCvaromYS", "eqCnsLETechCvaromYSGrowth", "eqCnsGETechCvaromYS", "eqCnsGETechCvaromYSGrowth", "eqCnsETechCvaromYS", "eqCnsETechCvaromYSGrowth", "eqCnsLETechCvaromR", "eqCnsGETechCvaromR", "eqCnsETechCvaromR", "eqCnsLETechCvaromRS", "eqCnsGETechCvaromRS", "eqCnsETechCvaromRS", "eqCnsLETechCvaromRY", "eqCnsLETechCvaromRYGrowth", "eqCnsGETechCvaromRY", "eqCnsGETechCvaromRYGrowth", "eqCnsETechCvaromRY", "eqCnsETechCvaromRYGrowth", "eqCnsLETechCvaromRYS", "eqCnsLETechCvaromRYSGrowth", "eqCnsGETechCvaromRYS", "eqCnsGETechCvaromRYSGrowth", "eqCnsETechCvaromRYS", "eqCnsETechCvaromRYSGrowth", "eqCnsLETechCvaromL", "eqCnsGETechCvaromL", "eqCnsETechCvaromL", "eqCnsLETechCvaromLS", "eqCnsGETechCvaromLS", "eqCnsETechCvaromLS", "eqCnsLETechCvaromLY", "eqCnsLETechCvaromLYGrowth", "eqCnsGETechCvaromLY", "eqCnsGETechCvaromLYGrowth", "eqCnsETechCvaromLY", "eqCnsETechCvaromLYGrowth", "eqCnsLETechCvaromLYS", "eqCnsLETechCvaromLYSGrowth", "eqCnsGETechCvaromLYS", "eqCnsGETechCvaromLYSGrowth", "eqCnsETechCvaromLYS", "eqCnsETechCvaromLYSGrowth", "eqCnsLETechCvaromLR", "eqCnsGETechCvaromLR", "eqCnsETechCvaromLR", "eqCnsLETechCvaromLRS", "eqCnsGETechCvaromLRS", "eqCnsETechCvaromLRS", "eqCnsLETechCvaromLRY", "eqCnsLETechCvaromLRYGrowth", "eqCnsGETechCvaromLRY", "eqCnsGETechCvaromLRYGrowth", "eqCnsETechCvaromLRY", "eqCnsETechCvaromLRYGrowth", "eqCnsLETechCvaromLRYS", "eqCnsLETechCvaromLRYSGrowth", "eqCnsGETechCvaromLRYS", "eqCnsGETechCvaromLRYSGrowth", "eqCnsETechCvaromLRYS", "eqCnsETechCvaromLRYSGrowth")] <- TRUE;
    rs["vTechAVarom", c("name", "description")] <- c("vTechAVarom", "Auxilary commodity Varom");
    rs["vTechAVarom", c("tech", "region", "year", "slice", "eqTechAVarom", "eqCnsLETechAvarom", "eqCnsGETechAvarom", "eqCnsETechAvarom", "eqCnsLETechAvaromS", "eqCnsGETechAvaromS", "eqCnsETechAvaromS", "eqCnsLETechAvaromY", "eqCnsLETechAvaromYGrowth", "eqCnsGETechAvaromY", "eqCnsGETechAvaromYGrowth", "eqCnsETechAvaromY", "eqCnsETechAvaromYGrowth", "eqCnsLETechAvaromYS", "eqCnsLETechAvaromYSGrowth", "eqCnsGETechAvaromYS", "eqCnsGETechAvaromYSGrowth", "eqCnsETechAvaromYS", "eqCnsETechAvaromYSGrowth", "eqCnsLETechAvaromR", "eqCnsGETechAvaromR", "eqCnsETechAvaromR", "eqCnsLETechAvaromRS", "eqCnsGETechAvaromRS", "eqCnsETechAvaromRS", "eqCnsLETechAvaromRY", "eqCnsLETechAvaromRYGrowth", "eqCnsGETechAvaromRY", "eqCnsGETechAvaromRYGrowth", "eqCnsETechAvaromRY", "eqCnsETechAvaromRYGrowth", "eqCnsLETechAvaromRYS", "eqCnsLETechAvaromRYSGrowth", "eqCnsGETechAvaromRYS", "eqCnsGETechAvaromRYSGrowth", "eqCnsETechAvaromRYS", "eqCnsETechAvaromRYSGrowth", "eqCnsLETechAvaromL", "eqCnsGETechAvaromL", "eqCnsETechAvaromL", "eqCnsLETechAvaromLS", "eqCnsGETechAvaromLS", "eqCnsETechAvaromLS", "eqCnsLETechAvaromLY", "eqCnsLETechAvaromLYGrowth", "eqCnsGETechAvaromLY", "eqCnsGETechAvaromLYGrowth", "eqCnsETechAvaromLY", "eqCnsETechAvaromLYGrowth", "eqCnsLETechAvaromLYS", "eqCnsLETechAvaromLYSGrowth", "eqCnsGETechAvaromLYS", "eqCnsGETechAvaromLYSGrowth", "eqCnsETechAvaromLYS", "eqCnsETechAvaromLYSGrowth", "eqCnsLETechAvaromLR", "eqCnsGETechAvaromLR", "eqCnsETechAvaromLR", "eqCnsLETechAvaromLRS", "eqCnsGETechAvaromLRS", "eqCnsETechAvaromLRS", "eqCnsLETechAvaromLRY", "eqCnsLETechAvaromLRYGrowth", "eqCnsGETechAvaromLRY", "eqCnsGETechAvaromLRYGrowth", "eqCnsETechAvaromLRY", "eqCnsETechAvaromLRYGrowth", "eqCnsLETechAvaromLRYS", "eqCnsLETechAvaromLRYSGrowth", "eqCnsGETechAvaromLRYS", "eqCnsGETechAvaromLRYSGrowth", "eqCnsETechAvaromLRYS", "eqCnsETechAvaromLRYSGrowth")] <- TRUE;
    rs["vTechInv", c("name", "description")] <- c("vTechInv", "Investment");
    rs["vTechInv", c("tech", "region", "year", "eqTechInv", "eqTechCost1", "eqCnsLETechInv", "eqCnsGETechInv", "eqCnsETechInv", "eqCnsLETechInvY", "eqCnsLETechInvYGrowth", "eqCnsGETechInvY", "eqCnsGETechInvYGrowth", "eqCnsETechInvY", "eqCnsETechInvYGrowth", "eqCnsLETechInvR", "eqCnsGETechInvR", "eqCnsETechInvR", "eqCnsLETechInvRY", "eqCnsLETechInvRYGrowth", "eqCnsGETechInvRY", "eqCnsGETechInvRYGrowth", "eqCnsETechInvRY", "eqCnsETechInvRYGrowth", "eqCnsLETechInvL", "eqCnsGETechInvL", "eqCnsETechInvL", "eqCnsLETechInvLY", "eqCnsLETechInvLYGrowth", "eqCnsGETechInvLY", "eqCnsGETechInvLYGrowth", "eqCnsETechInvLY", "eqCnsETechInvLYGrowth", "eqCnsLETechInvLR", "eqCnsGETechInvLR", "eqCnsETechInvLR", "eqCnsLETechInvLRY", "eqCnsLETechInvLRYGrowth", "eqCnsGETechInvLRY", "eqCnsGETechInvLRYGrowth", "eqCnsETechInvLRY", "eqCnsETechInvLRYGrowth")] <- TRUE;
    rs["vTechEac", c("name", "description")] <- c("vTechEac", "Annualized investment cost");
    rs["vTechEac", c("tech", "region", "year", "eqTechEac", "eqCnsLETechEac", "eqCnsGETechEac", "eqCnsETechEac", "eqCnsLETechEacY", "eqCnsLETechEacYGrowth", "eqCnsGETechEacY", "eqCnsGETechEacYGrowth", "eqCnsETechEacY", "eqCnsETechEacYGrowth", "eqCnsLETechEacR", "eqCnsGETechEacR", "eqCnsETechEacR", "eqCnsLETechEacRY", "eqCnsLETechEacRYGrowth", "eqCnsGETechEacRY", "eqCnsGETechEacRYGrowth", "eqCnsETechEacRY", "eqCnsETechEacRYGrowth", "eqCnsLETechEacL", "eqCnsGETechEacL", "eqCnsETechEacL", "eqCnsLETechEacLY", "eqCnsLETechEacLYGrowth", "eqCnsGETechEacLY", "eqCnsGETechEacLYGrowth", "eqCnsETechEacLY", "eqCnsETechEacLYGrowth", "eqCnsLETechEacLR", "eqCnsGETechEacLR", "eqCnsETechEacLR", "eqCnsLETechEacLRY", "eqCnsLETechEacLRYGrowth", "eqCnsGETechEacLRY", "eqCnsGETechEacLRYGrowth", "eqCnsETechEacLRY", "eqCnsETechEacLRYGrowth")] <- TRUE;
    rs["vTechSalv", c("name", "description")] <- c("vTechSalv", "Salvage costs");
    rs["vTechSalv", c("tech", "region", "eqTechSalv2", "eqTechSalv3", "eqCost2")] <- TRUE;
    rs["vTechCost", c("name", "description")] <- c("vTechCost", "??? VAROM + FIXOM???");
    rs["vTechCost", c("tech", "region", "year", "eqTechCost1", "eqTechCost2", "eqCost1", "eqCost2")] <- TRUE;
    rs["vSupCost", c("name", "description")] <- c("vSupCost", "Supply costs");
    rs["vSupCost", c("sup", "region", "year", "eqSupCost", "eqCost1", "eqCost2")] <- TRUE;
    rs["vEmsFuelTot", c("name", "description")] <- c("vEmsFuelTot", "Total emissions");
    rs["vEmsFuelTot", c("comm", "region", "year", "slice", "eqEmsFuelTot", "eqOutTot")] <- TRUE;
    rs["vTechEmsFuel", c("name", "description")] <- c("vTechEmsFuel", "Emissions on technology level");
    rs["vTechEmsFuel", c("tech", "comm", "region", "year", "slice", "eqEmsFuelTot", "eqTechEmsFuel", "eqCnsLETechOutShareIn", "eqCnsLETechOutShareOut", "eqCnsLETechOut", "eqCnsGETechOutShareIn", "eqCnsGETechOutShareOut", "eqCnsGETechOut", "eqCnsETechOutShareIn", "eqCnsETechOutShareOut", "eqCnsETechOut", "eqCnsLETechOutSShareIn", "eqCnsLETechOutSShareOut", "eqCnsLETechOutS", "eqCnsGETechOutSShareIn", "eqCnsGETechOutSShareOut", "eqCnsGETechOutS", "eqCnsETechOutSShareIn", "eqCnsETechOutSShareOut", "eqCnsETechOutS", "eqCnsLETechOutYShareIn", "eqCnsLETechOutYShareOut", "eqCnsLETechOutY", "eqCnsLETechOutYGrowth", "eqCnsGETechOutYShareIn", "eqCnsGETechOutYShareOut", "eqCnsGETechOutY", "eqCnsGETechOutYGrowth", "eqCnsETechOutYShareIn", "eqCnsETechOutYShareOut", "eqCnsETechOutY", "eqCnsETechOutYGrowth", "eqCnsLETechOutYSShareIn", "eqCnsLETechOutYSShareOut", "eqCnsLETechOutYS", "eqCnsLETechOutYSGrowth", "eqCnsGETechOutYSShareIn", "eqCnsGETechOutYSShareOut", "eqCnsGETechOutYS", "eqCnsGETechOutYSGrowth", "eqCnsETechOutYSShareIn", "eqCnsETechOutYSShareOut", "eqCnsETechOutYS", "eqCnsETechOutYSGrowth", "eqCnsLETechOutRShareIn", "eqCnsLETechOutRShareOut", "eqCnsLETechOutR", "eqCnsGETechOutRShareIn", "eqCnsGETechOutRShareOut", "eqCnsGETechOutR", "eqCnsETechOutRShareIn", "eqCnsETechOutRShareOut", "eqCnsETechOutR", "eqCnsLETechOutRSShareIn", "eqCnsLETechOutRSShareOut", "eqCnsLETechOutRS", "eqCnsGETechOutRSShareIn", "eqCnsGETechOutRSShareOut", "eqCnsGETechOutRS", "eqCnsETechOutRSShareIn", "eqCnsETechOutRSShareOut", "eqCnsETechOutRS", "eqCnsLETechOutRYShareIn", "eqCnsLETechOutRYShareOut", "eqCnsLETechOutRY", "eqCnsLETechOutRYGrowth", "eqCnsGETechOutRYShareIn", "eqCnsGETechOutRYShareOut", "eqCnsGETechOutRY", "eqCnsGETechOutRYGrowth", "eqCnsETechOutRYShareIn", "eqCnsETechOutRYShareOut", "eqCnsETechOutRY", "eqCnsETechOutRYGrowth", "eqCnsLETechOutRYSShareIn", "eqCnsLETechOutRYSShareOut", "eqCnsLETechOutRYS", "eqCnsLETechOutRYSGrowth", "eqCnsGETechOutRYSShareIn", "eqCnsGETechOutRYSShareOut", "eqCnsGETechOutRYS", "eqCnsGETechOutRYSGrowth", "eqCnsETechOutRYSShareIn", "eqCnsETechOutRYSShareOut", "eqCnsETechOutRYS", "eqCnsETechOutRYSGrowth", "eqCnsLETechOutCShareIn", "eqCnsLETechOutCShareOut", "eqCnsLETechOutC", "eqCnsGETechOutCShareIn", "eqCnsGETechOutCShareOut", "eqCnsGETechOutC", "eqCnsETechOutCShareIn", "eqCnsETechOutCShareOut", "eqCnsETechOutC", "eqCnsLETechOutCSShareIn", "eqCnsLETechOutCSShareOut", "eqCnsLETechOutCS", "eqCnsGETechOutCSShareIn", "eqCnsGETechOutCSShareOut", "eqCnsGETechOutCS", "eqCnsETechOutCSShareIn", "eqCnsETechOutCSShareOut", "eqCnsETechOutCS", "eqCnsLETechOutCYShareIn", "eqCnsLETechOutCYShareOut", "eqCnsLETechOutCY", "eqCnsLETechOutCYGrowth", "eqCnsGETechOutCYShareIn", "eqCnsGETechOutCYShareOut", "eqCnsGETechOutCY", "eqCnsGETechOutCYGrowth", "eqCnsETechOutCYShareIn", "eqCnsETechOutCYShareOut", "eqCnsETechOutCY", "eqCnsETechOutCYGrowth", "eqCnsLETechOutCYSShareIn", "eqCnsLETechOutCYSShareOut", "eqCnsLETechOutCYS", "eqCnsLETechOutCYSGrowth", "eqCnsGETechOutCYSShareIn", "eqCnsGETechOutCYSShareOut", "eqCnsGETechOutCYS", "eqCnsGETechOutCYSGrowth", "eqCnsETechOutCYSShareIn", "eqCnsETechOutCYSShareOut", "eqCnsETechOutCYS", "eqCnsETechOutCYSGrowth", "eqCnsLETechOutCRShareIn", "eqCnsLETechOutCRShareOut", "eqCnsLETechOutCR", "eqCnsGETechOutCRShareIn", "eqCnsGETechOutCRShareOut", "eqCnsGETechOutCR", "eqCnsETechOutCRShareIn", "eqCnsETechOutCRShareOut", "eqCnsETechOutCR", "eqCnsLETechOutCRSShareIn", "eqCnsLETechOutCRSShareOut", "eqCnsLETechOutCRS", "eqCnsGETechOutCRSShareIn", "eqCnsGETechOutCRSShareOut", "eqCnsGETechOutCRS", "eqCnsETechOutCRSShareIn", "eqCnsETechOutCRSShareOut", "eqCnsETechOutCRS", "eqCnsLETechOutCRYShareIn", "eqCnsLETechOutCRYShareOut", "eqCnsLETechOutCRY", "eqCnsLETechOutCRYGrowth", "eqCnsGETechOutCRYShareIn", "eqCnsGETechOutCRYShareOut", "eqCnsGETechOutCRY", "eqCnsGETechOutCRYGrowth", "eqCnsETechOutCRYShareIn", "eqCnsETechOutCRYShareOut", "eqCnsETechOutCRY", "eqCnsETechOutCRYGrowth", "eqCnsLETechOutCRYSShareIn", "eqCnsLETechOutCRYSShareOut", "eqCnsLETechOutCRYS", "eqCnsLETechOutCRYSGrowth", "eqCnsGETechOutCRYSShareIn", "eqCnsGETechOutCRYSShareOut", "eqCnsGETechOutCRYS", "eqCnsGETechOutCRYSGrowth", "eqCnsETechOutCRYSShareIn", "eqCnsETechOutCRYSShareOut", "eqCnsETechOutCRYS", "eqCnsETechOutCRYSGrowth", "eqCnsLETechOutLShareIn", "eqCnsLETechOutLShareOut", "eqCnsLETechOutL", "eqCnsGETechOutLShareIn", "eqCnsGETechOutLShareOut", "eqCnsGETechOutL", "eqCnsETechOutLShareIn", "eqCnsETechOutLShareOut", "eqCnsETechOutL", "eqCnsLETechOutLSShareIn", "eqCnsLETechOutLSShareOut", "eqCnsLETechOutLS", "eqCnsGETechOutLSShareIn", "eqCnsGETechOutLSShareOut", "eqCnsGETechOutLS", "eqCnsETechOutLSShareIn", "eqCnsETechOutLSShareOut", "eqCnsETechOutLS", "eqCnsLETechOutLYShareIn", "eqCnsLETechOutLYShareOut", "eqCnsLETechOutLY", "eqCnsLETechOutLYGrowth", "eqCnsGETechOutLYShareIn", "eqCnsGETechOutLYShareOut", "eqCnsGETechOutLY", "eqCnsGETechOutLYGrowth", "eqCnsETechOutLYShareIn", "eqCnsETechOutLYShareOut", "eqCnsETechOutLY", "eqCnsETechOutLYGrowth", "eqCnsLETechOutLYSShareIn", "eqCnsLETechOutLYSShareOut", "eqCnsLETechOutLYS", "eqCnsLETechOutLYSGrowth", "eqCnsGETechOutLYSShareIn", "eqCnsGETechOutLYSShareOut", "eqCnsGETechOutLYS", "eqCnsGETechOutLYSGrowth", "eqCnsETechOutLYSShareIn", "eqCnsETechOutLYSShareOut", "eqCnsETechOutLYS", "eqCnsETechOutLYSGrowth", "eqCnsLETechOutLRShareIn", "eqCnsLETechOutLRShareOut", "eqCnsLETechOutLR", "eqCnsGETechOutLRShareIn", "eqCnsGETechOutLRShareOut", "eqCnsGETechOutLR", "eqCnsETechOutLRShareIn", "eqCnsETechOutLRShareOut", "eqCnsETechOutLR", "eqCnsLETechOutLRSShareIn", "eqCnsLETechOutLRSShareOut", "eqCnsLETechOutLRS", "eqCnsGETechOutLRSShareIn", "eqCnsGETechOutLRSShareOut", "eqCnsGETechOutLRS", "eqCnsETechOutLRSShareIn", "eqCnsETechOutLRSShareOut", "eqCnsETechOutLRS", "eqCnsLETechOutLRYShareIn", "eqCnsLETechOutLRYShareOut", "eqCnsLETechOutLRY", "eqCnsLETechOutLRYGrowth", "eqCnsGETechOutLRYShareIn", "eqCnsGETechOutLRYShareOut", "eqCnsGETechOutLRY", "eqCnsGETechOutLRYGrowth", "eqCnsETechOutLRYShareIn", "eqCnsETechOutLRYShareOut", "eqCnsETechOutLRY", "eqCnsETechOutLRYGrowth", "eqCnsLETechOutLRYSShareIn", "eqCnsLETechOutLRYSShareOut", "eqCnsLETechOutLRYS", "eqCnsLETechOutLRYSGrowth", "eqCnsGETechOutLRYSShareIn", "eqCnsGETechOutLRYSShareOut", "eqCnsGETechOutLRYS", "eqCnsGETechOutLRYSGrowth", "eqCnsETechOutLRYSShareIn", "eqCnsETechOutLRYSShareOut", "eqCnsETechOutLRYS", "eqCnsETechOutLRYSGrowth", "eqCnsLETechOutLCShareIn", "eqCnsLETechOutLCShareOut", "eqCnsLETechOutLC", "eqCnsGETechOutLCShareIn", "eqCnsGETechOutLCShareOut", "eqCnsGETechOutLC", "eqCnsETechOutLCShareIn", "eqCnsETechOutLCShareOut", "eqCnsETechOutLC", "eqCnsLETechOutLCSShareIn", "eqCnsLETechOutLCSShareOut", "eqCnsLETechOutLCS", "eqCnsGETechOutLCSShareIn", "eqCnsGETechOutLCSShareOut", "eqCnsGETechOutLCS", "eqCnsETechOutLCSShareIn", "eqCnsETechOutLCSShareOut", "eqCnsETechOutLCS", "eqCnsLETechOutLCYShareIn", "eqCnsLETechOutLCYShareOut", "eqCnsLETechOutLCY", "eqCnsLETechOutLCYGrowth", "eqCnsGETechOutLCYShareIn", "eqCnsGETechOutLCYShareOut", "eqCnsGETechOutLCY", "eqCnsGETechOutLCYGrowth", "eqCnsETechOutLCYShareIn", "eqCnsETechOutLCYShareOut", "eqCnsETechOutLCY", "eqCnsETechOutLCYGrowth", "eqCnsLETechOutLCYSShareIn", "eqCnsLETechOutLCYSShareOut", "eqCnsLETechOutLCYS", "eqCnsLETechOutLCYSGrowth", "eqCnsGETechOutLCYSShareIn", "eqCnsGETechOutLCYSShareOut", "eqCnsGETechOutLCYS", "eqCnsGETechOutLCYSGrowth", "eqCnsETechOutLCYSShareIn", "eqCnsETechOutLCYSShareOut", "eqCnsETechOutLCYS", "eqCnsETechOutLCYSGrowth", "eqCnsLETechOutLCRShareIn", "eqCnsLETechOutLCRShareOut", "eqCnsLETechOutLCR", "eqCnsGETechOutLCRShareIn", "eqCnsGETechOutLCRShareOut", "eqCnsGETechOutLCR", "eqCnsETechOutLCRShareIn", "eqCnsETechOutLCRShareOut", "eqCnsETechOutLCR", "eqCnsLETechOutLCRSShareIn", "eqCnsLETechOutLCRSShareOut", "eqCnsLETechOutLCRS", "eqCnsGETechOutLCRSShareIn", "eqCnsGETechOutLCRSShareOut", "eqCnsGETechOutLCRS", "eqCnsETechOutLCRSShareIn", "eqCnsETechOutLCRSShareOut", "eqCnsETechOutLCRS", "eqCnsLETechOutLCRYShareIn", "eqCnsLETechOutLCRYShareOut", "eqCnsLETechOutLCRY", "eqCnsLETechOutLCRYGrowth", "eqCnsGETechOutLCRYShareIn", "eqCnsGETechOutLCRYShareOut", "eqCnsGETechOutLCRY", "eqCnsGETechOutLCRYGrowth", "eqCnsETechOutLCRYShareIn", "eqCnsETechOutLCRYShareOut", "eqCnsETechOutLCRY", "eqCnsETechOutLCRYGrowth", "eqCnsLETechOutLCRYSShareIn", "eqCnsLETechOutLCRYSShareOut", "eqCnsLETechOutLCRYS", "eqCnsLETechOutLCRYSGrowth", "eqCnsGETechOutLCRYSShareIn", "eqCnsGETechOutLCRYSShareOut", "eqCnsGETechOutLCRYS", "eqCnsGETechOutLCRYSGrowth", "eqCnsETechOutLCRYSShareIn", "eqCnsETechOutLCRYSShareOut", "eqCnsETechOutLCRYS", "eqCnsETechOutLCRYSGrowth")] <- TRUE;
    rs["vBalance", c("name", "description")] <- c("vBalance", "??? Net commodity balance");
    rs["vBalance", c("comm", "region", "year", "slice", "eqBalUp", "eqBalLo", "eqBalFx", "eqBal")] <- TRUE;
    rs["vCost", c("name", "description")] <- c("vCost", "Total costs");
    rs["vCost", c("region", "year", "eqCost1", "eqCost2", "eqObjective")] <- TRUE;
    rs["vObjective", c("name", "description")] <- c("vObjective", "Objective costs");
    rs["vObjective", c("eqObjective")] <- TRUE;
    rs["vTaxCost", c("name", "description")] <- c("vTaxCost", "Total tax levies");
    rs["vTaxCost", c("comm", "region", "year", "eqCost1", "eqCost2", "eqTaxCost")] <- TRUE;
    rs["vSubsCost", c("name", "description")] <- c("vSubsCost", "Total subsidies");
    rs["vSubsCost", c("comm", "region", "year", "eqCost1", "eqCost2", "eqSubsCost")] <- TRUE;
    rs["vAggOut", c("name", "description")] <- c("vAggOut", "???");
    rs["vAggOut", c("comm", "region", "year", "slice", "eqAggOut", "eqOutTot")] <- TRUE;
    rs["vStorageCost", c("name", "description")] <- c("vStorageCost", "???");
    rs["vStorageCost", c("stg", "region", "year", "eqStorageCost", "eqCost1", "eqCost2")] <- TRUE;
    rs["vTradeCost", c("name", "description")] <- c("vTradeCost", "Trade costs");
    rs["vTradeCost", c("region", "year", "eqCostTrade", "eqCost1", "eqCost2")] <- TRUE;
    rs["vTradeRowCost", c("name", "description")] <- c("vTradeRowCost", "Trade costs");
    rs["vTradeRowCost", c("region", "year", "eqCostTrade", "eqCostRowTrade")] <- TRUE;
    rs["vTradeIrCost", c("name", "description")] <- c("vTradeIrCost", "Trade costs");
    rs["vTradeIrCost", c("region", "year", "eqCostTrade", "eqCostIrTrade")] <- TRUE;
    rs["vTechUse", c("name", "description")] <- c("vTechUse", "Use level in technology");
    rs["vTechUse", c("tech", "region", "year", "slice", "eqTechUse2Sng", "eqTechUse2Grp", "eqTechAInp", "eqTechAOut", "eqPreDefTechUse")] <- TRUE;
    rs["vTechNewCap", c("name", "description")] <- c("vTechNewCap", "New capacity");
    rs["vTechNewCap", c("tech", "region", "year", "eqTechAInp", "eqTechAOut", "eqTechCap", "eqTechNewCap", "eqTechEac", "eqTechInv", "eqTechSalv2", "eqTechSalv3", "eqCnsLETechNewCap", "eqCnsGETechNewCap", "eqCnsETechNewCap", "eqCnsLETechNewCapY", "eqCnsLETechNewCapYGrowth", "eqCnsGETechNewCapY", "eqCnsGETechNewCapYGrowth", "eqCnsETechNewCapY", "eqCnsETechNewCapYGrowth", "eqCnsLETechNewCapR", "eqCnsGETechNewCapR", "eqCnsETechNewCapR", "eqCnsLETechNewCapRY", "eqCnsLETechNewCapRYGrowth", "eqCnsGETechNewCapRY", "eqCnsGETechNewCapRYGrowth", "eqCnsETechNewCapRY", "eqCnsETechNewCapRYGrowth", "eqCnsLETechNewCapL", "eqCnsGETechNewCapL", "eqCnsETechNewCapL", "eqCnsLETechNewCapLY", "eqCnsLETechNewCapLYGrowth", "eqCnsGETechNewCapLY", "eqCnsGETechNewCapLYGrowth", "eqCnsETechNewCapLY", "eqCnsETechNewCapLYGrowth", "eqCnsLETechNewCapLR", "eqCnsGETechNewCapLR", "eqCnsETechNewCapLR", "eqCnsLETechNewCapLRY", "eqCnsLETechNewCapLRYGrowth", "eqCnsGETechNewCapLRY", "eqCnsGETechNewCapLRYGrowth", "eqCnsETechNewCapLRY", "eqCnsETechNewCapLRYGrowth", "eqPreDefTechNewCap")] <- TRUE;
    rs["vTechRetirementCap", c("name", "description")] <- c("vTechRetirementCap", "??? Early retired capacity");
    rs["vTechRetirementCap", c("tech", "region", "year", "eqTechCap", "eqTechNewCap", "eqTechEac", "eqTechSalv2", "eqTechSalv3", "eqPreDefTechRetirementCap")] <- TRUE;
    rs["vTechCap", c("name", "description")] <- c("vTechCap", "Total capacity of the technology");
    rs["vTechCap", c("tech", "region", "year", "eqTechAInp", "eqTechAOut", "eqTechAfaLo", "eqTechAfaUp", "eqTechAfacLo", "eqTechAfacUp", "eqTechCap", "eqTechCost1", "eqTechCost2", "eqTechFixom", "eqCnsLETechCap", "eqCnsGETechCap", "eqCnsETechCap", "eqCnsLETechCapY", "eqCnsLETechCapYGrowth", "eqCnsGETechCapY", "eqCnsGETechCapYGrowth", "eqCnsETechCapY", "eqCnsETechCapYGrowth", "eqCnsLETechCapR", "eqCnsGETechCapR", "eqCnsETechCapR", "eqCnsLETechCapRY", "eqCnsLETechCapRYGrowth", "eqCnsGETechCapRY", "eqCnsGETechCapRYGrowth", "eqCnsETechCapRY", "eqCnsETechCapRYGrowth", "eqCnsLETechCapL", "eqCnsGETechCapL", "eqCnsETechCapL", "eqCnsLETechCapLY", "eqCnsLETechCapLYGrowth", "eqCnsGETechCapLY", "eqCnsGETechCapLYGrowth", "eqCnsETechCapLY", "eqCnsETechCapLYGrowth", "eqCnsLETechCapLR", "eqCnsGETechCapLR", "eqCnsETechCapLR", "eqCnsLETechCapLRY", "eqCnsLETechCapLRYGrowth", "eqCnsGETechCapLRY", "eqCnsGETechCapLRYGrowth", "eqCnsETechCapLRY", "eqCnsETechCapLRYGrowth", "eqPreDefTechCap")] <- TRUE;
    rs["vTechAct", c("name", "description")] <- c("vTechAct", "Activity level of technology");
    rs["vTechAct", c("tech", "region", "year", "slice", "eqTechAInp", "eqTechAOut", "eqTechAfaLo", "eqTechAfaUp", "eqTechActSng", "eqTechActGrp", "eqTechCost1", "eqTechCost2", "eqTechVarom", "eqTechActVarom", "eqCnsLETechAct", "eqCnsGETechAct", "eqCnsETechAct", "eqCnsLETechActS", "eqCnsGETechActS", "eqCnsETechActS", "eqCnsLETechActY", "eqCnsLETechActYGrowth", "eqCnsGETechActY", "eqCnsGETechActYGrowth", "eqCnsETechActY", "eqCnsETechActYGrowth", "eqCnsLETechActYS", "eqCnsLETechActYSGrowth", "eqCnsGETechActYS", "eqCnsGETechActYSGrowth", "eqCnsETechActYS", "eqCnsETechActYSGrowth", "eqCnsLETechActR", "eqCnsGETechActR", "eqCnsETechActR", "eqCnsLETechActRS", "eqCnsGETechActRS", "eqCnsETechActRS", "eqCnsLETechActRY", "eqCnsLETechActRYGrowth", "eqCnsGETechActRY", "eqCnsGETechActRYGrowth", "eqCnsETechActRY", "eqCnsETechActRYGrowth", "eqCnsLETechActRYS", "eqCnsLETechActRYSGrowth", "eqCnsGETechActRYS", "eqCnsGETechActRYSGrowth", "eqCnsETechActRYS", "eqCnsETechActRYSGrowth", "eqCnsLETechActL", "eqCnsGETechActL", "eqCnsETechActL", "eqCnsLETechActLS", "eqCnsGETechActLS", "eqCnsETechActLS", "eqCnsLETechActLY", "eqCnsLETechActLYGrowth", "eqCnsGETechActLY", "eqCnsGETechActLYGrowth", "eqCnsETechActLY", "eqCnsETechActLYGrowth", "eqCnsLETechActLYS", "eqCnsLETechActLYSGrowth", "eqCnsGETechActLYS", "eqCnsGETechActLYSGrowth", "eqCnsETechActLYS", "eqCnsETechActLYSGrowth", "eqCnsLETechActLR", "eqCnsGETechActLR", "eqCnsETechActLR", "eqCnsLETechActLRS", "eqCnsGETechActLRS", "eqCnsETechActLRS", "eqCnsLETechActLRY", "eqCnsLETechActLRYGrowth", "eqCnsGETechActLRY", "eqCnsGETechActLRYGrowth", "eqCnsETechActLRY", "eqCnsETechActLRYGrowth", "eqCnsLETechActLRYS", "eqCnsLETechActLRYSGrowth", "eqCnsGETechActLRYS", "eqCnsGETechActLRYSGrowth", "eqCnsETechActLRYS", "eqCnsETechActLRYSGrowth", "eqLECActivity", "eqPreDefTechAct")] <- TRUE;
    rs["vTechInp", c("name", "description")] <- c("vTechInp", "Input level");
    rs["vTechInp", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechShareInpLo", "eqTechShareInpUp", "eqTechAInp", "eqTechAOut", "eqTechCost1", "eqTechCost2", "eqTechVarom", "eqTechCVarom", "eqTechEmsFuel", "eqTechInpTot", "eqCnsLETechInpShareIn", "eqCnsLETechInpShareOut", "eqCnsLETechInp", "eqCnsGETechInpShareIn", "eqCnsGETechInpShareOut", "eqCnsGETechInp", "eqCnsETechInpShareIn", "eqCnsETechInpShareOut", "eqCnsETechInp", "eqCnsLETechInpSShareIn", "eqCnsLETechInpSShareOut", "eqCnsLETechInpS", "eqCnsGETechInpSShareIn", "eqCnsGETechInpSShareOut", "eqCnsGETechInpS", "eqCnsETechInpSShareIn", "eqCnsETechInpSShareOut", "eqCnsETechInpS", "eqCnsLETechInpYShareIn", "eqCnsLETechInpYShareOut", "eqCnsLETechInpY", "eqCnsLETechInpYGrowth", "eqCnsGETechInpYShareIn", "eqCnsGETechInpYShareOut", "eqCnsGETechInpY", "eqCnsGETechInpYGrowth", "eqCnsETechInpYShareIn", "eqCnsETechInpYShareOut", "eqCnsETechInpY", "eqCnsETechInpYGrowth", "eqCnsLETechInpYSShareIn", "eqCnsLETechInpYSShareOut", "eqCnsLETechInpYS", "eqCnsLETechInpYSGrowth", "eqCnsGETechInpYSShareIn", "eqCnsGETechInpYSShareOut", "eqCnsGETechInpYS", "eqCnsGETechInpYSGrowth", "eqCnsETechInpYSShareIn", "eqCnsETechInpYSShareOut", "eqCnsETechInpYS", "eqCnsETechInpYSGrowth", "eqCnsLETechInpRShareIn", "eqCnsLETechInpRShareOut", "eqCnsLETechInpR", "eqCnsGETechInpRShareIn", "eqCnsGETechInpRShareOut", "eqCnsGETechInpR", "eqCnsETechInpRShareIn", "eqCnsETechInpRShareOut", "eqCnsETechInpR", "eqCnsLETechInpRSShareIn", "eqCnsLETechInpRSShareOut", "eqCnsLETechInpRS", "eqCnsGETechInpRSShareIn", "eqCnsGETechInpRSShareOut", "eqCnsGETechInpRS", "eqCnsETechInpRSShareIn", "eqCnsETechInpRSShareOut", "eqCnsETechInpRS", "eqCnsLETechInpRYShareIn", "eqCnsLETechInpRYShareOut", "eqCnsLETechInpRY", "eqCnsLETechInpRYGrowth", "eqCnsGETechInpRYShareIn", "eqCnsGETechInpRYShareOut", "eqCnsGETechInpRY", "eqCnsGETechInpRYGrowth", "eqCnsETechInpRYShareIn", "eqCnsETechInpRYShareOut", "eqCnsETechInpRY", "eqCnsETechInpRYGrowth", "eqCnsLETechInpRYSShareIn", "eqCnsLETechInpRYSShareOut", "eqCnsLETechInpRYS", "eqCnsLETechInpRYSGrowth", "eqCnsGETechInpRYSShareIn", "eqCnsGETechInpRYSShareOut", "eqCnsGETechInpRYS", "eqCnsGETechInpRYSGrowth", "eqCnsETechInpRYSShareIn", "eqCnsETechInpRYSShareOut", "eqCnsETechInpRYS", "eqCnsETechInpRYSGrowth", "eqCnsLETechInpCShareIn", "eqCnsLETechInpCShareOut", "eqCnsLETechInpC", "eqCnsGETechInpCShareIn", "eqCnsGETechInpCShareOut", "eqCnsGETechInpC", "eqCnsETechInpCShareIn", "eqCnsETechInpCShareOut", "eqCnsETechInpC", "eqCnsLETechInpCSShareIn", "eqCnsLETechInpCSShareOut", "eqCnsLETechInpCS", "eqCnsGETechInpCSShareIn", "eqCnsGETechInpCSShareOut", "eqCnsGETechInpCS", "eqCnsETechInpCSShareIn", "eqCnsETechInpCSShareOut", "eqCnsETechInpCS", "eqCnsLETechInpCYShareIn", "eqCnsLETechInpCYShareOut", "eqCnsLETechInpCY", "eqCnsLETechInpCYGrowth", "eqCnsGETechInpCYShareIn", "eqCnsGETechInpCYShareOut", "eqCnsGETechInpCY", "eqCnsGETechInpCYGrowth", "eqCnsETechInpCYShareIn", "eqCnsETechInpCYShareOut", "eqCnsETechInpCY", "eqCnsETechInpCYGrowth", "eqCnsLETechInpCYSShareIn", "eqCnsLETechInpCYSShareOut", "eqCnsLETechInpCYS", "eqCnsLETechInpCYSGrowth", "eqCnsGETechInpCYSShareIn", "eqCnsGETechInpCYSShareOut", "eqCnsGETechInpCYS", "eqCnsGETechInpCYSGrowth", "eqCnsETechInpCYSShareIn", "eqCnsETechInpCYSShareOut", "eqCnsETechInpCYS", "eqCnsETechInpCYSGrowth", "eqCnsLETechInpCRShareIn", "eqCnsLETechInpCRShareOut", "eqCnsLETechInpCR", "eqCnsGETechInpCRShareIn", "eqCnsGETechInpCRShareOut", "eqCnsGETechInpCR", "eqCnsETechInpCRShareIn", "eqCnsETechInpCRShareOut", "eqCnsETechInpCR", "eqCnsLETechInpCRSShareIn", "eqCnsLETechInpCRSShareOut", "eqCnsLETechInpCRS", "eqCnsGETechInpCRSShareIn", "eqCnsGETechInpCRSShareOut", "eqCnsGETechInpCRS", "eqCnsETechInpCRSShareIn", "eqCnsETechInpCRSShareOut", "eqCnsETechInpCRS", "eqCnsLETechInpCRYShareIn", "eqCnsLETechInpCRYShareOut", "eqCnsLETechInpCRY", "eqCnsLETechInpCRYGrowth", "eqCnsGETechInpCRYShareIn", "eqCnsGETechInpCRYShareOut", "eqCnsGETechInpCRY", "eqCnsGETechInpCRYGrowth", "eqCnsETechInpCRYShareIn", "eqCnsETechInpCRYShareOut", "eqCnsETechInpCRY", "eqCnsETechInpCRYGrowth", "eqCnsLETechInpCRYSShareIn", "eqCnsLETechInpCRYSShareOut", "eqCnsLETechInpCRYS", "eqCnsLETechInpCRYSGrowth", "eqCnsGETechInpCRYSShareIn", "eqCnsGETechInpCRYSShareOut", "eqCnsGETechInpCRYS", "eqCnsGETechInpCRYSGrowth", "eqCnsETechInpCRYSShareIn", "eqCnsETechInpCRYSShareOut", "eqCnsETechInpCRYS", "eqCnsETechInpCRYSGrowth", "eqCnsLETechInpLShareIn", "eqCnsLETechInpLShareOut", "eqCnsLETechInpL", "eqCnsGETechInpLShareIn", "eqCnsGETechInpLShareOut", "eqCnsGETechInpL", "eqCnsETechInpLShareIn", "eqCnsETechInpLShareOut", "eqCnsETechInpL", "eqCnsLETechInpLSShareIn", "eqCnsLETechInpLSShareOut", "eqCnsLETechInpLS", "eqCnsGETechInpLSShareIn", "eqCnsGETechInpLSShareOut", "eqCnsGETechInpLS", "eqCnsETechInpLSShareIn", "eqCnsETechInpLSShareOut", "eqCnsETechInpLS", "eqCnsLETechInpLYShareIn", "eqCnsLETechInpLYShareOut", "eqCnsLETechInpLY", "eqCnsLETechInpLYGrowth", "eqCnsGETechInpLYShareIn", "eqCnsGETechInpLYShareOut", "eqCnsGETechInpLY", "eqCnsGETechInpLYGrowth", "eqCnsETechInpLYShareIn", "eqCnsETechInpLYShareOut", "eqCnsETechInpLY", "eqCnsETechInpLYGrowth", "eqCnsLETechInpLYSShareIn", "eqCnsLETechInpLYSShareOut", "eqCnsLETechInpLYS", "eqCnsLETechInpLYSGrowth", "eqCnsGETechInpLYSShareIn", "eqCnsGETechInpLYSShareOut", "eqCnsGETechInpLYS", "eqCnsGETechInpLYSGrowth", "eqCnsETechInpLYSShareIn", "eqCnsETechInpLYSShareOut", "eqCnsETechInpLYS", "eqCnsETechInpLYSGrowth", "eqCnsLETechInpLRShareIn", "eqCnsLETechInpLRShareOut", "eqCnsLETechInpLR", "eqCnsGETechInpLRShareIn", "eqCnsGETechInpLRShareOut", "eqCnsGETechInpLR", "eqCnsETechInpLRShareIn", "eqCnsETechInpLRShareOut", "eqCnsETechInpLR", "eqCnsLETechInpLRSShareIn", "eqCnsLETechInpLRSShareOut", "eqCnsLETechInpLRS", "eqCnsGETechInpLRSShareIn", "eqCnsGETechInpLRSShareOut", "eqCnsGETechInpLRS", "eqCnsETechInpLRSShareIn", "eqCnsETechInpLRSShareOut", "eqCnsETechInpLRS", "eqCnsLETechInpLRYShareIn", "eqCnsLETechInpLRYShareOut", "eqCnsLETechInpLRY", "eqCnsLETechInpLRYGrowth", "eqCnsGETechInpLRYShareIn", "eqCnsGETechInpLRYShareOut", "eqCnsGETechInpLRY", "eqCnsGETechInpLRYGrowth", "eqCnsETechInpLRYShareIn", "eqCnsETechInpLRYShareOut", "eqCnsETechInpLRY", "eqCnsETechInpLRYGrowth", "eqCnsLETechInpLRYSShareIn", "eqCnsLETechInpLRYSShareOut", "eqCnsLETechInpLRYS", "eqCnsLETechInpLRYSGrowth", "eqCnsGETechInpLRYSShareIn", "eqCnsGETechInpLRYSShareOut", "eqCnsGETechInpLRYS", "eqCnsGETechInpLRYSGrowth", "eqCnsETechInpLRYSShareIn", "eqCnsETechInpLRYSShareOut", "eqCnsETechInpLRYS", "eqCnsETechInpLRYSGrowth", "eqCnsLETechInpLCShareIn", "eqCnsLETechInpLCShareOut", "eqCnsLETechInpLC", "eqCnsGETechInpLCShareIn", "eqCnsGETechInpLCShareOut", "eqCnsGETechInpLC", "eqCnsETechInpLCShareIn", "eqCnsETechInpLCShareOut", "eqCnsETechInpLC", "eqCnsLETechInpLCSShareIn", "eqCnsLETechInpLCSShareOut", "eqCnsLETechInpLCS", "eqCnsGETechInpLCSShareIn", "eqCnsGETechInpLCSShareOut", "eqCnsGETechInpLCS", "eqCnsETechInpLCSShareIn", "eqCnsETechInpLCSShareOut", "eqCnsETechInpLCS", "eqCnsLETechInpLCYShareIn", "eqCnsLETechInpLCYShareOut", "eqCnsLETechInpLCY", "eqCnsLETechInpLCYGrowth", "eqCnsGETechInpLCYShareIn", "eqCnsGETechInpLCYShareOut", "eqCnsGETechInpLCY", "eqCnsGETechInpLCYGrowth", "eqCnsETechInpLCYShareIn", "eqCnsETechInpLCYShareOut", "eqCnsETechInpLCY", "eqCnsETechInpLCYGrowth", "eqCnsLETechInpLCYSShareIn", "eqCnsLETechInpLCYSShareOut", "eqCnsLETechInpLCYS", "eqCnsLETechInpLCYSGrowth", "eqCnsGETechInpLCYSShareIn", "eqCnsGETechInpLCYSShareOut", "eqCnsGETechInpLCYS", "eqCnsGETechInpLCYSGrowth", "eqCnsETechInpLCYSShareIn", "eqCnsETechInpLCYSShareOut", "eqCnsETechInpLCYS", "eqCnsETechInpLCYSGrowth", "eqCnsLETechInpLCRShareIn", "eqCnsLETechInpLCRShareOut", "eqCnsLETechInpLCR", "eqCnsGETechInpLCRShareIn", "eqCnsGETechInpLCRShareOut", "eqCnsGETechInpLCR", "eqCnsETechInpLCRShareIn", "eqCnsETechInpLCRShareOut", "eqCnsETechInpLCR", "eqCnsLETechInpLCRSShareIn", "eqCnsLETechInpLCRSShareOut", "eqCnsLETechInpLCRS", "eqCnsGETechInpLCRSShareIn", "eqCnsGETechInpLCRSShareOut", "eqCnsGETechInpLCRS", "eqCnsETechInpLCRSShareIn", "eqCnsETechInpLCRSShareOut", "eqCnsETechInpLCRS", "eqCnsLETechInpLCRYShareIn", "eqCnsLETechInpLCRYShareOut", "eqCnsLETechInpLCRY", "eqCnsLETechInpLCRYGrowth", "eqCnsGETechInpLCRYShareIn", "eqCnsGETechInpLCRYShareOut", "eqCnsGETechInpLCRY", "eqCnsGETechInpLCRYGrowth", "eqCnsETechInpLCRYShareIn", "eqCnsETechInpLCRYShareOut", "eqCnsETechInpLCRY", "eqCnsETechInpLCRYGrowth", "eqCnsLETechInpLCRYSShareIn", "eqCnsLETechInpLCRYSShareOut", "eqCnsLETechInpLCRYS", "eqCnsLETechInpLCRYSGrowth", "eqCnsGETechInpLCRYSShareIn", "eqCnsGETechInpLCRYSShareOut", "eqCnsGETechInpLCRYS", "eqCnsGETechInpLCRYSGrowth", "eqCnsETechInpLCRYSShareIn", "eqCnsETechInpLCRYSShareOut", "eqCnsETechInpLCRYS", "eqCnsETechInpLCRYSGrowth", "eqPreDefTechInp")] <- TRUE;
    rs["vTechOut", c("name", "description")] <- c("vTechOut", "Output level");
    rs["vTechOut", c("tech", "comm", "region", "year", "slice", "eqTechSng2Sng", "eqTechGrp2Sng", "eqTechSng2Grp", "eqTechGrp2Grp", "eqTechUse2Sng", "eqTechUse2Grp", "eqTechShareOutLo", "eqTechShareOutUp", "eqTechAInp", "eqTechAOut", "eqTechActSng", "eqTechActGrp", "eqTechAfacLo", "eqTechAfacUp", "eqTechCost1", "eqTechCost2", "eqTechVarom", "eqTechOutTot", "eqCnsLETechOutShareIn", "eqCnsLETechOutShareOut", "eqCnsLETechOut", "eqCnsGETechOutShareIn", "eqCnsGETechOutShareOut", "eqCnsGETechOut", "eqCnsETechOutShareIn", "eqCnsETechOutShareOut", "eqCnsETechOut", "eqCnsLETechOutSShareIn", "eqCnsLETechOutSShareOut", "eqCnsLETechOutS", "eqCnsGETechOutSShareIn", "eqCnsGETechOutSShareOut", "eqCnsGETechOutS", "eqCnsETechOutSShareIn", "eqCnsETechOutSShareOut", "eqCnsETechOutS", "eqCnsLETechOutYShareIn", "eqCnsLETechOutYShareOut", "eqCnsLETechOutY", "eqCnsLETechOutYGrowth", "eqCnsGETechOutYShareIn", "eqCnsGETechOutYShareOut", "eqCnsGETechOutY", "eqCnsGETechOutYGrowth", "eqCnsETechOutYShareIn", "eqCnsETechOutYShareOut", "eqCnsETechOutY", "eqCnsETechOutYGrowth", "eqCnsLETechOutYSShareIn", "eqCnsLETechOutYSShareOut", "eqCnsLETechOutYS", "eqCnsLETechOutYSGrowth", "eqCnsGETechOutYSShareIn", "eqCnsGETechOutYSShareOut", "eqCnsGETechOutYS", "eqCnsGETechOutYSGrowth", "eqCnsETechOutYSShareIn", "eqCnsETechOutYSShareOut", "eqCnsETechOutYS", "eqCnsETechOutYSGrowth", "eqCnsLETechOutRShareIn", "eqCnsLETechOutRShareOut", "eqCnsLETechOutR", "eqCnsGETechOutRShareIn", "eqCnsGETechOutRShareOut", "eqCnsGETechOutR", "eqCnsETechOutRShareIn", "eqCnsETechOutRShareOut", "eqCnsETechOutR", "eqCnsLETechOutRSShareIn", "eqCnsLETechOutRSShareOut", "eqCnsLETechOutRS", "eqCnsGETechOutRSShareIn", "eqCnsGETechOutRSShareOut", "eqCnsGETechOutRS", "eqCnsETechOutRSShareIn", "eqCnsETechOutRSShareOut", "eqCnsETechOutRS", "eqCnsLETechOutRYShareIn", "eqCnsLETechOutRYShareOut", "eqCnsLETechOutRY", "eqCnsLETechOutRYGrowth", "eqCnsGETechOutRYShareIn", "eqCnsGETechOutRYShareOut", "eqCnsGETechOutRY", "eqCnsGETechOutRYGrowth", "eqCnsETechOutRYShareIn", "eqCnsETechOutRYShareOut", "eqCnsETechOutRY", "eqCnsETechOutRYGrowth", "eqCnsLETechOutRYSShareIn", "eqCnsLETechOutRYSShareOut", "eqCnsLETechOutRYS", "eqCnsLETechOutRYSGrowth", "eqCnsGETechOutRYSShareIn", "eqCnsGETechOutRYSShareOut", "eqCnsGETechOutRYS", "eqCnsGETechOutRYSGrowth", "eqCnsETechOutRYSShareIn", "eqCnsETechOutRYSShareOut", "eqCnsETechOutRYS", "eqCnsETechOutRYSGrowth", "eqCnsLETechOutCShareIn", "eqCnsLETechOutCShareOut", "eqCnsLETechOutC", "eqCnsGETechOutCShareIn", "eqCnsGETechOutCShareOut", "eqCnsGETechOutC", "eqCnsETechOutCShareIn", "eqCnsETechOutCShareOut", "eqCnsETechOutC", "eqCnsLETechOutCSShareIn", "eqCnsLETechOutCSShareOut", "eqCnsLETechOutCS", "eqCnsGETechOutCSShareIn", "eqCnsGETechOutCSShareOut", "eqCnsGETechOutCS", "eqCnsETechOutCSShareIn", "eqCnsETechOutCSShareOut", "eqCnsETechOutCS", "eqCnsLETechOutCYShareIn", "eqCnsLETechOutCYShareOut", "eqCnsLETechOutCY", "eqCnsLETechOutCYGrowth", "eqCnsGETechOutCYShareIn", "eqCnsGETechOutCYShareOut", "eqCnsGETechOutCY", "eqCnsGETechOutCYGrowth", "eqCnsETechOutCYShareIn", "eqCnsETechOutCYShareOut", "eqCnsETechOutCY", "eqCnsETechOutCYGrowth", "eqCnsLETechOutCYSShareIn", "eqCnsLETechOutCYSShareOut", "eqCnsLETechOutCYS", "eqCnsLETechOutCYSGrowth", "eqCnsGETechOutCYSShareIn", "eqCnsGETechOutCYSShareOut", "eqCnsGETechOutCYS", "eqCnsGETechOutCYSGrowth", "eqCnsETechOutCYSShareIn", "eqCnsETechOutCYSShareOut", "eqCnsETechOutCYS", "eqCnsETechOutCYSGrowth", "eqCnsLETechOutCRShareIn", "eqCnsLETechOutCRShareOut", "eqCnsLETechOutCR", "eqCnsGETechOutCRShareIn", "eqCnsGETechOutCRShareOut", "eqCnsGETechOutCR", "eqCnsETechOutCRShareIn", "eqCnsETechOutCRShareOut", "eqCnsETechOutCR", "eqCnsLETechOutCRSShareIn", "eqCnsLETechOutCRSShareOut", "eqCnsLETechOutCRS", "eqCnsGETechOutCRSShareIn", "eqCnsGETechOutCRSShareOut", "eqCnsGETechOutCRS", "eqCnsETechOutCRSShareIn", "eqCnsETechOutCRSShareOut", "eqCnsETechOutCRS", "eqCnsLETechOutCRYShareIn", "eqCnsLETechOutCRYShareOut", "eqCnsLETechOutCRY", "eqCnsLETechOutCRYGrowth", "eqCnsGETechOutCRYShareIn", "eqCnsGETechOutCRYShareOut", "eqCnsGETechOutCRY", "eqCnsGETechOutCRYGrowth", "eqCnsETechOutCRYShareIn", "eqCnsETechOutCRYShareOut", "eqCnsETechOutCRY", "eqCnsETechOutCRYGrowth", "eqCnsLETechOutCRYSShareIn", "eqCnsLETechOutCRYSShareOut", "eqCnsLETechOutCRYS", "eqCnsLETechOutCRYSGrowth", "eqCnsGETechOutCRYSShareIn", "eqCnsGETechOutCRYSShareOut", "eqCnsGETechOutCRYS", "eqCnsGETechOutCRYSGrowth", "eqCnsETechOutCRYSShareIn", "eqCnsETechOutCRYSShareOut", "eqCnsETechOutCRYS", "eqCnsETechOutCRYSGrowth", "eqCnsLETechOutLShareIn", "eqCnsLETechOutLShareOut", "eqCnsLETechOutL", "eqCnsGETechOutLShareIn", "eqCnsGETechOutLShareOut", "eqCnsGETechOutL", "eqCnsETechOutLShareIn", "eqCnsETechOutLShareOut", "eqCnsETechOutL", "eqCnsLETechOutLSShareIn", "eqCnsLETechOutLSShareOut", "eqCnsLETechOutLS", "eqCnsGETechOutLSShareIn", "eqCnsGETechOutLSShareOut", "eqCnsGETechOutLS", "eqCnsETechOutLSShareIn", "eqCnsETechOutLSShareOut", "eqCnsETechOutLS", "eqCnsLETechOutLYShareIn", "eqCnsLETechOutLYShareOut", "eqCnsLETechOutLY", "eqCnsLETechOutLYGrowth", "eqCnsGETechOutLYShareIn", "eqCnsGETechOutLYShareOut", "eqCnsGETechOutLY", "eqCnsGETechOutLYGrowth", "eqCnsETechOutLYShareIn", "eqCnsETechOutLYShareOut", "eqCnsETechOutLY", "eqCnsETechOutLYGrowth", "eqCnsLETechOutLYSShareIn", "eqCnsLETechOutLYSShareOut", "eqCnsLETechOutLYS", "eqCnsLETechOutLYSGrowth", "eqCnsGETechOutLYSShareIn", "eqCnsGETechOutLYSShareOut", "eqCnsGETechOutLYS", "eqCnsGETechOutLYSGrowth", "eqCnsETechOutLYSShareIn", "eqCnsETechOutLYSShareOut", "eqCnsETechOutLYS", "eqCnsETechOutLYSGrowth", "eqCnsLETechOutLRShareIn", "eqCnsLETechOutLRShareOut", "eqCnsLETechOutLR", "eqCnsGETechOutLRShareIn", "eqCnsGETechOutLRShareOut", "eqCnsGETechOutLR", "eqCnsETechOutLRShareIn", "eqCnsETechOutLRShareOut", "eqCnsETechOutLR", "eqCnsLETechOutLRSShareIn", "eqCnsLETechOutLRSShareOut", "eqCnsLETechOutLRS", "eqCnsGETechOutLRSShareIn", "eqCnsGETechOutLRSShareOut", "eqCnsGETechOutLRS", "eqCnsETechOutLRSShareIn", "eqCnsETechOutLRSShareOut", "eqCnsETechOutLRS", "eqCnsLETechOutLRYShareIn", "eqCnsLETechOutLRYShareOut", "eqCnsLETechOutLRY", "eqCnsLETechOutLRYGrowth", "eqCnsGETechOutLRYShareIn", "eqCnsGETechOutLRYShareOut", "eqCnsGETechOutLRY", "eqCnsGETechOutLRYGrowth", "eqCnsETechOutLRYShareIn", "eqCnsETechOutLRYShareOut", "eqCnsETechOutLRY", "eqCnsETechOutLRYGrowth", "eqCnsLETechOutLRYSShareIn", "eqCnsLETechOutLRYSShareOut", "eqCnsLETechOutLRYS", "eqCnsLETechOutLRYSGrowth", "eqCnsGETechOutLRYSShareIn", "eqCnsGETechOutLRYSShareOut", "eqCnsGETechOutLRYS", "eqCnsGETechOutLRYSGrowth", "eqCnsETechOutLRYSShareIn", "eqCnsETechOutLRYSShareOut", "eqCnsETechOutLRYS", "eqCnsETechOutLRYSGrowth", "eqCnsLETechOutLCShareIn", "eqCnsLETechOutLCShareOut", "eqCnsLETechOutLC", "eqCnsGETechOutLCShareIn", "eqCnsGETechOutLCShareOut", "eqCnsGETechOutLC", "eqCnsETechOutLCShareIn", "eqCnsETechOutLCShareOut", "eqCnsETechOutLC", "eqCnsLETechOutLCSShareIn", "eqCnsLETechOutLCSShareOut", "eqCnsLETechOutLCS", "eqCnsGETechOutLCSShareIn", "eqCnsGETechOutLCSShareOut", "eqCnsGETechOutLCS", "eqCnsETechOutLCSShareIn", "eqCnsETechOutLCSShareOut", "eqCnsETechOutLCS", "eqCnsLETechOutLCYShareIn", "eqCnsLETechOutLCYShareOut", "eqCnsLETechOutLCY", "eqCnsLETechOutLCYGrowth", "eqCnsGETechOutLCYShareIn", "eqCnsGETechOutLCYShareOut", "eqCnsGETechOutLCY", "eqCnsGETechOutLCYGrowth", "eqCnsETechOutLCYShareIn", "eqCnsETechOutLCYShareOut", "eqCnsETechOutLCY", "eqCnsETechOutLCYGrowth", "eqCnsLETechOutLCYSShareIn", "eqCnsLETechOutLCYSShareOut", "eqCnsLETechOutLCYS", "eqCnsLETechOutLCYSGrowth", "eqCnsGETechOutLCYSShareIn", "eqCnsGETechOutLCYSShareOut", "eqCnsGETechOutLCYS", "eqCnsGETechOutLCYSGrowth", "eqCnsETechOutLCYSShareIn", "eqCnsETechOutLCYSShareOut", "eqCnsETechOutLCYS", "eqCnsETechOutLCYSGrowth", "eqCnsLETechOutLCRShareIn", "eqCnsLETechOutLCRShareOut", "eqCnsLETechOutLCR", "eqCnsGETechOutLCRShareIn", "eqCnsGETechOutLCRShareOut", "eqCnsGETechOutLCR", "eqCnsETechOutLCRShareIn", "eqCnsETechOutLCRShareOut", "eqCnsETechOutLCR", "eqCnsLETechOutLCRSShareIn", "eqCnsLETechOutLCRSShareOut", "eqCnsLETechOutLCRS", "eqCnsGETechOutLCRSShareIn", "eqCnsGETechOutLCRSShareOut", "eqCnsGETechOutLCRS", "eqCnsETechOutLCRSShareIn", "eqCnsETechOutLCRSShareOut", "eqCnsETechOutLCRS", "eqCnsLETechOutLCRYShareIn", "eqCnsLETechOutLCRYShareOut", "eqCnsLETechOutLCRY", "eqCnsLETechOutLCRYGrowth", "eqCnsGETechOutLCRYShareIn", "eqCnsGETechOutLCRYShareOut", "eqCnsGETechOutLCRY", "eqCnsGETechOutLCRYGrowth", "eqCnsETechOutLCRYShareIn", "eqCnsETechOutLCRYShareOut", "eqCnsETechOutLCRY", "eqCnsETechOutLCRYGrowth", "eqCnsLETechOutLCRYSShareIn", "eqCnsLETechOutLCRYSShareOut", "eqCnsLETechOutLCRYS", "eqCnsLETechOutLCRYSGrowth", "eqCnsGETechOutLCRYSShareIn", "eqCnsGETechOutLCRYSShareOut", "eqCnsGETechOutLCRYS", "eqCnsGETechOutLCRYSGrowth", "eqCnsETechOutLCRYSShareIn", "eqCnsETechOutLCRYSShareOut", "eqCnsETechOutLCRYS", "eqCnsETechOutLCRYSGrowth", "eqPreDefTechOut")] <- TRUE;
    rs["vTechAInp", c("name", "description")] <- c("vTechAInp", "Auxiliary commodity input");
    rs["vTechAInp", c("tech", "comm", "region", "year", "slice", "eqTechAInp", "eqTechCost1", "eqTechCost2", "eqTechVarom", "eqTechAVarom", "eqTechInpTot", "eqCnsLETechInpShareIn", "eqCnsLETechInpShareOut", "eqCnsLETechInp", "eqCnsGETechInpShareIn", "eqCnsGETechInpShareOut", "eqCnsGETechInp", "eqCnsETechInpShareIn", "eqCnsETechInpShareOut", "eqCnsETechInp", "eqCnsLETechInpSShareIn", "eqCnsLETechInpSShareOut", "eqCnsLETechInpS", "eqCnsGETechInpSShareIn", "eqCnsGETechInpSShareOut", "eqCnsGETechInpS", "eqCnsETechInpSShareIn", "eqCnsETechInpSShareOut", "eqCnsETechInpS", "eqCnsLETechInpYShareIn", "eqCnsLETechInpYShareOut", "eqCnsLETechInpY", "eqCnsLETechInpYGrowth", "eqCnsGETechInpYShareIn", "eqCnsGETechInpYShareOut", "eqCnsGETechInpY", "eqCnsGETechInpYGrowth", "eqCnsETechInpYShareIn", "eqCnsETechInpYShareOut", "eqCnsETechInpY", "eqCnsETechInpYGrowth", "eqCnsLETechInpYSShareIn", "eqCnsLETechInpYSShareOut", "eqCnsLETechInpYS", "eqCnsLETechInpYSGrowth", "eqCnsGETechInpYSShareIn", "eqCnsGETechInpYSShareOut", "eqCnsGETechInpYS", "eqCnsGETechInpYSGrowth", "eqCnsETechInpYSShareIn", "eqCnsETechInpYSShareOut", "eqCnsETechInpYS", "eqCnsETechInpYSGrowth", "eqCnsLETechInpRShareIn", "eqCnsLETechInpRShareOut", "eqCnsLETechInpR", "eqCnsGETechInpRShareIn", "eqCnsGETechInpRShareOut", "eqCnsGETechInpR", "eqCnsETechInpRShareIn", "eqCnsETechInpRShareOut", "eqCnsETechInpR", "eqCnsLETechInpRSShareIn", "eqCnsLETechInpRSShareOut", "eqCnsLETechInpRS", "eqCnsGETechInpRSShareIn", "eqCnsGETechInpRSShareOut", "eqCnsGETechInpRS", "eqCnsETechInpRSShareIn", "eqCnsETechInpRSShareOut", "eqCnsETechInpRS", "eqCnsLETechInpRYShareIn", "eqCnsLETechInpRYShareOut", "eqCnsLETechInpRY", "eqCnsLETechInpRYGrowth", "eqCnsGETechInpRYShareIn", "eqCnsGETechInpRYShareOut", "eqCnsGETechInpRY", "eqCnsGETechInpRYGrowth", "eqCnsETechInpRYShareIn", "eqCnsETechInpRYShareOut", "eqCnsETechInpRY", "eqCnsETechInpRYGrowth", "eqCnsLETechInpRYSShareIn", "eqCnsLETechInpRYSShareOut", "eqCnsLETechInpRYS", "eqCnsLETechInpRYSGrowth", "eqCnsGETechInpRYSShareIn", "eqCnsGETechInpRYSShareOut", "eqCnsGETechInpRYS", "eqCnsGETechInpRYSGrowth", "eqCnsETechInpRYSShareIn", "eqCnsETechInpRYSShareOut", "eqCnsETechInpRYS", "eqCnsETechInpRYSGrowth", "eqCnsLETechInpCShareIn", "eqCnsLETechInpCShareOut", "eqCnsLETechInpC", "eqCnsGETechInpCShareIn", "eqCnsGETechInpCShareOut", "eqCnsGETechInpC", "eqCnsETechInpCShareIn", "eqCnsETechInpCShareOut", "eqCnsETechInpC", "eqCnsLETechInpCSShareIn", "eqCnsLETechInpCSShareOut", "eqCnsLETechInpCS", "eqCnsGETechInpCSShareIn", "eqCnsGETechInpCSShareOut", "eqCnsGETechInpCS", "eqCnsETechInpCSShareIn", "eqCnsETechInpCSShareOut", "eqCnsETechInpCS", "eqCnsLETechInpCYShareIn", "eqCnsLETechInpCYShareOut", "eqCnsLETechInpCY", "eqCnsLETechInpCYGrowth", "eqCnsGETechInpCYShareIn", "eqCnsGETechInpCYShareOut", "eqCnsGETechInpCY", "eqCnsGETechInpCYGrowth", "eqCnsETechInpCYShareIn", "eqCnsETechInpCYShareOut", "eqCnsETechInpCY", "eqCnsETechInpCYGrowth", "eqCnsLETechInpCYSShareIn", "eqCnsLETechInpCYSShareOut", "eqCnsLETechInpCYS", "eqCnsLETechInpCYSGrowth", "eqCnsGETechInpCYSShareIn", "eqCnsGETechInpCYSShareOut", "eqCnsGETechInpCYS", "eqCnsGETechInpCYSGrowth", "eqCnsETechInpCYSShareIn", "eqCnsETechInpCYSShareOut", "eqCnsETechInpCYS", "eqCnsETechInpCYSGrowth", "eqCnsLETechInpCRShareIn", "eqCnsLETechInpCRShareOut", "eqCnsLETechInpCR", "eqCnsGETechInpCRShareIn", "eqCnsGETechInpCRShareOut", "eqCnsGETechInpCR", "eqCnsETechInpCRShareIn", "eqCnsETechInpCRShareOut", "eqCnsETechInpCR", "eqCnsLETechInpCRSShareIn", "eqCnsLETechInpCRSShareOut", "eqCnsLETechInpCRS", "eqCnsGETechInpCRSShareIn", "eqCnsGETechInpCRSShareOut", "eqCnsGETechInpCRS", "eqCnsETechInpCRSShareIn", "eqCnsETechInpCRSShareOut", "eqCnsETechInpCRS", "eqCnsLETechInpCRYShareIn", "eqCnsLETechInpCRYShareOut", "eqCnsLETechInpCRY", "eqCnsLETechInpCRYGrowth", "eqCnsGETechInpCRYShareIn", "eqCnsGETechInpCRYShareOut", "eqCnsGETechInpCRY", "eqCnsGETechInpCRYGrowth", "eqCnsETechInpCRYShareIn", "eqCnsETechInpCRYShareOut", "eqCnsETechInpCRY", "eqCnsETechInpCRYGrowth", "eqCnsLETechInpCRYSShareIn", "eqCnsLETechInpCRYSShareOut", "eqCnsLETechInpCRYS", "eqCnsLETechInpCRYSGrowth", "eqCnsGETechInpCRYSShareIn", "eqCnsGETechInpCRYSShareOut", "eqCnsGETechInpCRYS", "eqCnsGETechInpCRYSGrowth", "eqCnsETechInpCRYSShareIn", "eqCnsETechInpCRYSShareOut", "eqCnsETechInpCRYS", "eqCnsETechInpCRYSGrowth", "eqCnsLETechInpLShareIn", "eqCnsLETechInpLShareOut", "eqCnsLETechInpL", "eqCnsGETechInpLShareIn", "eqCnsGETechInpLShareOut", "eqCnsGETechInpL", "eqCnsETechInpLShareIn", "eqCnsETechInpLShareOut", "eqCnsETechInpL", "eqCnsLETechInpLSShareIn", "eqCnsLETechInpLSShareOut", "eqCnsLETechInpLS", "eqCnsGETechInpLSShareIn", "eqCnsGETechInpLSShareOut", "eqCnsGETechInpLS", "eqCnsETechInpLSShareIn", "eqCnsETechInpLSShareOut", "eqCnsETechInpLS", "eqCnsLETechInpLYShareIn", "eqCnsLETechInpLYShareOut", "eqCnsLETechInpLY", "eqCnsLETechInpLYGrowth", "eqCnsGETechInpLYShareIn", "eqCnsGETechInpLYShareOut", "eqCnsGETechInpLY", "eqCnsGETechInpLYGrowth", "eqCnsETechInpLYShareIn", "eqCnsETechInpLYShareOut", "eqCnsETechInpLY", "eqCnsETechInpLYGrowth", "eqCnsLETechInpLYSShareIn", "eqCnsLETechInpLYSShareOut", "eqCnsLETechInpLYS", "eqCnsLETechInpLYSGrowth", "eqCnsGETechInpLYSShareIn", "eqCnsGETechInpLYSShareOut", "eqCnsGETechInpLYS", "eqCnsGETechInpLYSGrowth", "eqCnsETechInpLYSShareIn", "eqCnsETechInpLYSShareOut", "eqCnsETechInpLYS", "eqCnsETechInpLYSGrowth", "eqCnsLETechInpLRShareIn", "eqCnsLETechInpLRShareOut", "eqCnsLETechInpLR", "eqCnsGETechInpLRShareIn", "eqCnsGETechInpLRShareOut", "eqCnsGETechInpLR", "eqCnsETechInpLRShareIn", "eqCnsETechInpLRShareOut", "eqCnsETechInpLR", "eqCnsLETechInpLRSShareIn", "eqCnsLETechInpLRSShareOut", "eqCnsLETechInpLRS", "eqCnsGETechInpLRSShareIn", "eqCnsGETechInpLRSShareOut", "eqCnsGETechInpLRS", "eqCnsETechInpLRSShareIn", "eqCnsETechInpLRSShareOut", "eqCnsETechInpLRS", "eqCnsLETechInpLRYShareIn", "eqCnsLETechInpLRYShareOut", "eqCnsLETechInpLRY", "eqCnsLETechInpLRYGrowth", "eqCnsGETechInpLRYShareIn", "eqCnsGETechInpLRYShareOut", "eqCnsGETechInpLRY", "eqCnsGETechInpLRYGrowth", "eqCnsETechInpLRYShareIn", "eqCnsETechInpLRYShareOut", "eqCnsETechInpLRY", "eqCnsETechInpLRYGrowth", "eqCnsLETechInpLRYSShareIn", "eqCnsLETechInpLRYSShareOut", "eqCnsLETechInpLRYS", "eqCnsLETechInpLRYSGrowth", "eqCnsGETechInpLRYSShareIn", "eqCnsGETechInpLRYSShareOut", "eqCnsGETechInpLRYS", "eqCnsGETechInpLRYSGrowth", "eqCnsETechInpLRYSShareIn", "eqCnsETechInpLRYSShareOut", "eqCnsETechInpLRYS", "eqCnsETechInpLRYSGrowth", "eqCnsLETechInpLCShareIn", "eqCnsLETechInpLCShareOut", "eqCnsLETechInpLC", "eqCnsGETechInpLCShareIn", "eqCnsGETechInpLCShareOut", "eqCnsGETechInpLC", "eqCnsETechInpLCShareIn", "eqCnsETechInpLCShareOut", "eqCnsETechInpLC", "eqCnsLETechInpLCSShareIn", "eqCnsLETechInpLCSShareOut", "eqCnsLETechInpLCS", "eqCnsGETechInpLCSShareIn", "eqCnsGETechInpLCSShareOut", "eqCnsGETechInpLCS", "eqCnsETechInpLCSShareIn", "eqCnsETechInpLCSShareOut", "eqCnsETechInpLCS", "eqCnsLETechInpLCYShareIn", "eqCnsLETechInpLCYShareOut", "eqCnsLETechInpLCY", "eqCnsLETechInpLCYGrowth", "eqCnsGETechInpLCYShareIn", "eqCnsGETechInpLCYShareOut", "eqCnsGETechInpLCY", "eqCnsGETechInpLCYGrowth", "eqCnsETechInpLCYShareIn", "eqCnsETechInpLCYShareOut", "eqCnsETechInpLCY", "eqCnsETechInpLCYGrowth", "eqCnsLETechInpLCYSShareIn", "eqCnsLETechInpLCYSShareOut", "eqCnsLETechInpLCYS", "eqCnsLETechInpLCYSGrowth", "eqCnsGETechInpLCYSShareIn", "eqCnsGETechInpLCYSShareOut", "eqCnsGETechInpLCYS", "eqCnsGETechInpLCYSGrowth", "eqCnsETechInpLCYSShareIn", "eqCnsETechInpLCYSShareOut", "eqCnsETechInpLCYS", "eqCnsETechInpLCYSGrowth", "eqCnsLETechInpLCRShareIn", "eqCnsLETechInpLCRShareOut", "eqCnsLETechInpLCR", "eqCnsGETechInpLCRShareIn", "eqCnsGETechInpLCRShareOut", "eqCnsGETechInpLCR", "eqCnsETechInpLCRShareIn", "eqCnsETechInpLCRShareOut", "eqCnsETechInpLCR", "eqCnsLETechInpLCRSShareIn", "eqCnsLETechInpLCRSShareOut", "eqCnsLETechInpLCRS", "eqCnsGETechInpLCRSShareIn", "eqCnsGETechInpLCRSShareOut", "eqCnsGETechInpLCRS", "eqCnsETechInpLCRSShareIn", "eqCnsETechInpLCRSShareOut", "eqCnsETechInpLCRS", "eqCnsLETechInpLCRYShareIn", "eqCnsLETechInpLCRYShareOut", "eqCnsLETechInpLCRY", "eqCnsLETechInpLCRYGrowth", "eqCnsGETechInpLCRYShareIn", "eqCnsGETechInpLCRYShareOut", "eqCnsGETechInpLCRY", "eqCnsGETechInpLCRYGrowth", "eqCnsETechInpLCRYShareIn", "eqCnsETechInpLCRYShareOut", "eqCnsETechInpLCRY", "eqCnsETechInpLCRYGrowth", "eqCnsLETechInpLCRYSShareIn", "eqCnsLETechInpLCRYSShareOut", "eqCnsLETechInpLCRYS", "eqCnsLETechInpLCRYSGrowth", "eqCnsGETechInpLCRYSShareIn", "eqCnsGETechInpLCRYSShareOut", "eqCnsGETechInpLCRYS", "eqCnsGETechInpLCRYSGrowth", "eqCnsETechInpLCRYSShareIn", "eqCnsETechInpLCRYSShareOut", "eqCnsETechInpLCRYS", "eqCnsETechInpLCRYSGrowth", "eqPreDefTechAInp")] <- TRUE;
    rs["vTechAOut", c("name", "description")] <- c("vTechAOut", "Auxiliary commodity output");
    rs["vTechAOut", c("tech", "comm", "region", "year", "slice", "eqTechAOut", "eqTechCost1", "eqTechCost2", "eqTechVarom", "eqTechOutTot", "eqCnsLETechOutShareIn", "eqCnsLETechOutShareOut", "eqCnsLETechOut", "eqCnsGETechOutShareIn", "eqCnsGETechOutShareOut", "eqCnsGETechOut", "eqCnsETechOutShareIn", "eqCnsETechOutShareOut", "eqCnsETechOut", "eqCnsLETechOutSShareIn", "eqCnsLETechOutSShareOut", "eqCnsLETechOutS", "eqCnsGETechOutSShareIn", "eqCnsGETechOutSShareOut", "eqCnsGETechOutS", "eqCnsETechOutSShareIn", "eqCnsETechOutSShareOut", "eqCnsETechOutS", "eqCnsLETechOutYShareIn", "eqCnsLETechOutYShareOut", "eqCnsLETechOutY", "eqCnsLETechOutYGrowth", "eqCnsGETechOutYShareIn", "eqCnsGETechOutYShareOut", "eqCnsGETechOutY", "eqCnsGETechOutYGrowth", "eqCnsETechOutYShareIn", "eqCnsETechOutYShareOut", "eqCnsETechOutY", "eqCnsETechOutYGrowth", "eqCnsLETechOutYSShareIn", "eqCnsLETechOutYSShareOut", "eqCnsLETechOutYS", "eqCnsLETechOutYSGrowth", "eqCnsGETechOutYSShareIn", "eqCnsGETechOutYSShareOut", "eqCnsGETechOutYS", "eqCnsGETechOutYSGrowth", "eqCnsETechOutYSShareIn", "eqCnsETechOutYSShareOut", "eqCnsETechOutYS", "eqCnsETechOutYSGrowth", "eqCnsLETechOutRShareIn", "eqCnsLETechOutRShareOut", "eqCnsLETechOutR", "eqCnsGETechOutRShareIn", "eqCnsGETechOutRShareOut", "eqCnsGETechOutR", "eqCnsETechOutRShareIn", "eqCnsETechOutRShareOut", "eqCnsETechOutR", "eqCnsLETechOutRSShareIn", "eqCnsLETechOutRSShareOut", "eqCnsLETechOutRS", "eqCnsGETechOutRSShareIn", "eqCnsGETechOutRSShareOut", "eqCnsGETechOutRS", "eqCnsETechOutRSShareIn", "eqCnsETechOutRSShareOut", "eqCnsETechOutRS", "eqCnsLETechOutRYShareIn", "eqCnsLETechOutRYShareOut", "eqCnsLETechOutRY", "eqCnsLETechOutRYGrowth", "eqCnsGETechOutRYShareIn", "eqCnsGETechOutRYShareOut", "eqCnsGETechOutRY", "eqCnsGETechOutRYGrowth", "eqCnsETechOutRYShareIn", "eqCnsETechOutRYShareOut", "eqCnsETechOutRY", "eqCnsETechOutRYGrowth", "eqCnsLETechOutRYSShareIn", "eqCnsLETechOutRYSShareOut", "eqCnsLETechOutRYS", "eqCnsLETechOutRYSGrowth", "eqCnsGETechOutRYSShareIn", "eqCnsGETechOutRYSShareOut", "eqCnsGETechOutRYS", "eqCnsGETechOutRYSGrowth", "eqCnsETechOutRYSShareIn", "eqCnsETechOutRYSShareOut", "eqCnsETechOutRYS", "eqCnsETechOutRYSGrowth", "eqCnsLETechOutCShareIn", "eqCnsLETechOutCShareOut", "eqCnsLETechOutC", "eqCnsGETechOutCShareIn", "eqCnsGETechOutCShareOut", "eqCnsGETechOutC", "eqCnsETechOutCShareIn", "eqCnsETechOutCShareOut", "eqCnsETechOutC", "eqCnsLETechOutCSShareIn", "eqCnsLETechOutCSShareOut", "eqCnsLETechOutCS", "eqCnsGETechOutCSShareIn", "eqCnsGETechOutCSShareOut", "eqCnsGETechOutCS", "eqCnsETechOutCSShareIn", "eqCnsETechOutCSShareOut", "eqCnsETechOutCS", "eqCnsLETechOutCYShareIn", "eqCnsLETechOutCYShareOut", "eqCnsLETechOutCY", "eqCnsLETechOutCYGrowth", "eqCnsGETechOutCYShareIn", "eqCnsGETechOutCYShareOut", "eqCnsGETechOutCY", "eqCnsGETechOutCYGrowth", "eqCnsETechOutCYShareIn", "eqCnsETechOutCYShareOut", "eqCnsETechOutCY", "eqCnsETechOutCYGrowth", "eqCnsLETechOutCYSShareIn", "eqCnsLETechOutCYSShareOut", "eqCnsLETechOutCYS", "eqCnsLETechOutCYSGrowth", "eqCnsGETechOutCYSShareIn", "eqCnsGETechOutCYSShareOut", "eqCnsGETechOutCYS", "eqCnsGETechOutCYSGrowth", "eqCnsETechOutCYSShareIn", "eqCnsETechOutCYSShareOut", "eqCnsETechOutCYS", "eqCnsETechOutCYSGrowth", "eqCnsLETechOutCRShareIn", "eqCnsLETechOutCRShareOut", "eqCnsLETechOutCR", "eqCnsGETechOutCRShareIn", "eqCnsGETechOutCRShareOut", "eqCnsGETechOutCR", "eqCnsETechOutCRShareIn", "eqCnsETechOutCRShareOut", "eqCnsETechOutCR", "eqCnsLETechOutCRSShareIn", "eqCnsLETechOutCRSShareOut", "eqCnsLETechOutCRS", "eqCnsGETechOutCRSShareIn", "eqCnsGETechOutCRSShareOut", "eqCnsGETechOutCRS", "eqCnsETechOutCRSShareIn", "eqCnsETechOutCRSShareOut", "eqCnsETechOutCRS", "eqCnsLETechOutCRYShareIn", "eqCnsLETechOutCRYShareOut", "eqCnsLETechOutCRY", "eqCnsLETechOutCRYGrowth", "eqCnsGETechOutCRYShareIn", "eqCnsGETechOutCRYShareOut", "eqCnsGETechOutCRY", "eqCnsGETechOutCRYGrowth", "eqCnsETechOutCRYShareIn", "eqCnsETechOutCRYShareOut", "eqCnsETechOutCRY", "eqCnsETechOutCRYGrowth", "eqCnsLETechOutCRYSShareIn", "eqCnsLETechOutCRYSShareOut", "eqCnsLETechOutCRYS", "eqCnsLETechOutCRYSGrowth", "eqCnsGETechOutCRYSShareIn", "eqCnsGETechOutCRYSShareOut", "eqCnsGETechOutCRYS", "eqCnsGETechOutCRYSGrowth", "eqCnsETechOutCRYSShareIn", "eqCnsETechOutCRYSShareOut", "eqCnsETechOutCRYS", "eqCnsETechOutCRYSGrowth", "eqCnsLETechOutLShareIn", "eqCnsLETechOutLShareOut", "eqCnsLETechOutL", "eqCnsGETechOutLShareIn", "eqCnsGETechOutLShareOut", "eqCnsGETechOutL", "eqCnsETechOutLShareIn", "eqCnsETechOutLShareOut", "eqCnsETechOutL", "eqCnsLETechOutLSShareIn", "eqCnsLETechOutLSShareOut", "eqCnsLETechOutLS", "eqCnsGETechOutLSShareIn", "eqCnsGETechOutLSShareOut", "eqCnsGETechOutLS", "eqCnsETechOutLSShareIn", "eqCnsETechOutLSShareOut", "eqCnsETechOutLS", "eqCnsLETechOutLYShareIn", "eqCnsLETechOutLYShareOut", "eqCnsLETechOutLY", "eqCnsLETechOutLYGrowth", "eqCnsGETechOutLYShareIn", "eqCnsGETechOutLYShareOut", "eqCnsGETechOutLY", "eqCnsGETechOutLYGrowth", "eqCnsETechOutLYShareIn", "eqCnsETechOutLYShareOut", "eqCnsETechOutLY", "eqCnsETechOutLYGrowth", "eqCnsLETechOutLYSShareIn", "eqCnsLETechOutLYSShareOut", "eqCnsLETechOutLYS", "eqCnsLETechOutLYSGrowth", "eqCnsGETechOutLYSShareIn", "eqCnsGETechOutLYSShareOut", "eqCnsGETechOutLYS", "eqCnsGETechOutLYSGrowth", "eqCnsETechOutLYSShareIn", "eqCnsETechOutLYSShareOut", "eqCnsETechOutLYS", "eqCnsETechOutLYSGrowth", "eqCnsLETechOutLRShareIn", "eqCnsLETechOutLRShareOut", "eqCnsLETechOutLR", "eqCnsGETechOutLRShareIn", "eqCnsGETechOutLRShareOut", "eqCnsGETechOutLR", "eqCnsETechOutLRShareIn", "eqCnsETechOutLRShareOut", "eqCnsETechOutLR", "eqCnsLETechOutLRSShareIn", "eqCnsLETechOutLRSShareOut", "eqCnsLETechOutLRS", "eqCnsGETechOutLRSShareIn", "eqCnsGETechOutLRSShareOut", "eqCnsGETechOutLRS", "eqCnsETechOutLRSShareIn", "eqCnsETechOutLRSShareOut", "eqCnsETechOutLRS", "eqCnsLETechOutLRYShareIn", "eqCnsLETechOutLRYShareOut", "eqCnsLETechOutLRY", "eqCnsLETechOutLRYGrowth", "eqCnsGETechOutLRYShareIn", "eqCnsGETechOutLRYShareOut", "eqCnsGETechOutLRY", "eqCnsGETechOutLRYGrowth", "eqCnsETechOutLRYShareIn", "eqCnsETechOutLRYShareOut", "eqCnsETechOutLRY", "eqCnsETechOutLRYGrowth", "eqCnsLETechOutLRYSShareIn", "eqCnsLETechOutLRYSShareOut", "eqCnsLETechOutLRYS", "eqCnsLETechOutLRYSGrowth", "eqCnsGETechOutLRYSShareIn", "eqCnsGETechOutLRYSShareOut", "eqCnsGETechOutLRYS", "eqCnsGETechOutLRYSGrowth", "eqCnsETechOutLRYSShareIn", "eqCnsETechOutLRYSShareOut", "eqCnsETechOutLRYS", "eqCnsETechOutLRYSGrowth", "eqCnsLETechOutLCShareIn", "eqCnsLETechOutLCShareOut", "eqCnsLETechOutLC", "eqCnsGETechOutLCShareIn", "eqCnsGETechOutLCShareOut", "eqCnsGETechOutLC", "eqCnsETechOutLCShareIn", "eqCnsETechOutLCShareOut", "eqCnsETechOutLC", "eqCnsLETechOutLCSShareIn", "eqCnsLETechOutLCSShareOut", "eqCnsLETechOutLCS", "eqCnsGETechOutLCSShareIn", "eqCnsGETechOutLCSShareOut", "eqCnsGETechOutLCS", "eqCnsETechOutLCSShareIn", "eqCnsETechOutLCSShareOut", "eqCnsETechOutLCS", "eqCnsLETechOutLCYShareIn", "eqCnsLETechOutLCYShareOut", "eqCnsLETechOutLCY", "eqCnsLETechOutLCYGrowth", "eqCnsGETechOutLCYShareIn", "eqCnsGETechOutLCYShareOut", "eqCnsGETechOutLCY", "eqCnsGETechOutLCYGrowth", "eqCnsETechOutLCYShareIn", "eqCnsETechOutLCYShareOut", "eqCnsETechOutLCY", "eqCnsETechOutLCYGrowth", "eqCnsLETechOutLCYSShareIn", "eqCnsLETechOutLCYSShareOut", "eqCnsLETechOutLCYS", "eqCnsLETechOutLCYSGrowth", "eqCnsGETechOutLCYSShareIn", "eqCnsGETechOutLCYSShareOut", "eqCnsGETechOutLCYS", "eqCnsGETechOutLCYSGrowth", "eqCnsETechOutLCYSShareIn", "eqCnsETechOutLCYSShareOut", "eqCnsETechOutLCYS", "eqCnsETechOutLCYSGrowth", "eqCnsLETechOutLCRShareIn", "eqCnsLETechOutLCRShareOut", "eqCnsLETechOutLCR", "eqCnsGETechOutLCRShareIn", "eqCnsGETechOutLCRShareOut", "eqCnsGETechOutLCR", "eqCnsETechOutLCRShareIn", "eqCnsETechOutLCRShareOut", "eqCnsETechOutLCR", "eqCnsLETechOutLCRSShareIn", "eqCnsLETechOutLCRSShareOut", "eqCnsLETechOutLCRS", "eqCnsGETechOutLCRSShareIn", "eqCnsGETechOutLCRSShareOut", "eqCnsGETechOutLCRS", "eqCnsETechOutLCRSShareIn", "eqCnsETechOutLCRSShareOut", "eqCnsETechOutLCRS", "eqCnsLETechOutLCRYShareIn", "eqCnsLETechOutLCRYShareOut", "eqCnsLETechOutLCRY", "eqCnsLETechOutLCRYGrowth", "eqCnsGETechOutLCRYShareIn", "eqCnsGETechOutLCRYShareOut", "eqCnsGETechOutLCRY", "eqCnsGETechOutLCRYGrowth", "eqCnsETechOutLCRYShareIn", "eqCnsETechOutLCRYShareOut", "eqCnsETechOutLCRY", "eqCnsETechOutLCRYGrowth", "eqCnsLETechOutLCRYSShareIn", "eqCnsLETechOutLCRYSShareOut", "eqCnsLETechOutLCRYS", "eqCnsLETechOutLCRYSGrowth", "eqCnsGETechOutLCRYSShareIn", "eqCnsGETechOutLCRYSShareOut", "eqCnsGETechOutLCRYS", "eqCnsGETechOutLCRYSGrowth", "eqCnsETechOutLCRYSShareIn", "eqCnsETechOutLCRYSShareOut", "eqCnsETechOutLCRYS", "eqCnsETechOutLCRYSGrowth", "eqPreDefTechAOut")] <- TRUE;
    rs["vSupOut", c("name", "description")] <- c("vSupOut", "Output of supply");
    rs["vSupOut", c("sup", "comm", "region", "year", "slice", "eqSupAvaUp", "eqSupAvaLo", "eqSupReserve", "eqSupCost", "eqSupOutTot", "eqCnsLESupOutShareIn", "eqCnsLESupOutShareOut", "eqCnsLESupOut", "eqCnsGESupOutShareIn", "eqCnsGESupOutShareOut", "eqCnsGESupOut", "eqCnsESupOutShareIn", "eqCnsESupOutShareOut", "eqCnsESupOut", "eqCnsLESupOutSShareIn", "eqCnsLESupOutSShareOut", "eqCnsLESupOutS", "eqCnsGESupOutSShareIn", "eqCnsGESupOutSShareOut", "eqCnsGESupOutS", "eqCnsESupOutSShareIn", "eqCnsESupOutSShareOut", "eqCnsESupOutS", "eqCnsLESupOutYShareIn", "eqCnsLESupOutYShareOut", "eqCnsLESupOutY", "eqCnsLESupOutYGrowth", "eqCnsGESupOutYShareIn", "eqCnsGESupOutYShareOut", "eqCnsGESupOutY", "eqCnsGESupOutYGrowth", "eqCnsESupOutYShareIn", "eqCnsESupOutYShareOut", "eqCnsESupOutY", "eqCnsESupOutYGrowth", "eqCnsLESupOutYSShareIn", "eqCnsLESupOutYSShareOut", "eqCnsLESupOutYS", "eqCnsLESupOutYSGrowth", "eqCnsGESupOutYSShareIn", "eqCnsGESupOutYSShareOut", "eqCnsGESupOutYS", "eqCnsGESupOutYSGrowth", "eqCnsESupOutYSShareIn", "eqCnsESupOutYSShareOut", "eqCnsESupOutYS", "eqCnsESupOutYSGrowth", "eqCnsLESupOutRShareIn", "eqCnsLESupOutRShareOut", "eqCnsLESupOutR", "eqCnsGESupOutRShareIn", "eqCnsGESupOutRShareOut", "eqCnsGESupOutR", "eqCnsESupOutRShareIn", "eqCnsESupOutRShareOut", "eqCnsESupOutR", "eqCnsLESupOutRSShareIn", "eqCnsLESupOutRSShareOut", "eqCnsLESupOutRS", "eqCnsGESupOutRSShareIn", "eqCnsGESupOutRSShareOut", "eqCnsGESupOutRS", "eqCnsESupOutRSShareIn", "eqCnsESupOutRSShareOut", "eqCnsESupOutRS", "eqCnsLESupOutRYShareIn", "eqCnsLESupOutRYShareOut", "eqCnsLESupOutRY", "eqCnsLESupOutRYGrowth", "eqCnsGESupOutRYShareIn", "eqCnsGESupOutRYShareOut", "eqCnsGESupOutRY", "eqCnsGESupOutRYGrowth", "eqCnsESupOutRYShareIn", "eqCnsESupOutRYShareOut", "eqCnsESupOutRY", "eqCnsESupOutRYGrowth", "eqCnsLESupOutRYSShareIn", "eqCnsLESupOutRYSShareOut", "eqCnsLESupOutRYS", "eqCnsLESupOutRYSGrowth", "eqCnsGESupOutRYSShareIn", "eqCnsGESupOutRYSShareOut", "eqCnsGESupOutRYS", "eqCnsGESupOutRYSGrowth", "eqCnsESupOutRYSShareIn", "eqCnsESupOutRYSShareOut", "eqCnsESupOutRYS", "eqCnsESupOutRYSGrowth", "eqCnsLESupOutCShareIn", "eqCnsLESupOutCShareOut", "eqCnsLESupOutC", "eqCnsGESupOutCShareIn", "eqCnsGESupOutCShareOut", "eqCnsGESupOutC", "eqCnsESupOutCShareIn", "eqCnsESupOutCShareOut", "eqCnsESupOutC", "eqCnsLESupOutCSShareIn", "eqCnsLESupOutCSShareOut", "eqCnsLESupOutCS", "eqCnsGESupOutCSShareIn", "eqCnsGESupOutCSShareOut", "eqCnsGESupOutCS", "eqCnsESupOutCSShareIn", "eqCnsESupOutCSShareOut", "eqCnsESupOutCS", "eqCnsLESupOutCYShareIn", "eqCnsLESupOutCYShareOut", "eqCnsLESupOutCY", "eqCnsLESupOutCYGrowth", "eqCnsGESupOutCYShareIn", "eqCnsGESupOutCYShareOut", "eqCnsGESupOutCY", "eqCnsGESupOutCYGrowth", "eqCnsESupOutCYShareIn", "eqCnsESupOutCYShareOut", "eqCnsESupOutCY", "eqCnsESupOutCYGrowth", "eqCnsLESupOutCYSShareIn", "eqCnsLESupOutCYSShareOut", "eqCnsLESupOutCYS", "eqCnsLESupOutCYSGrowth", "eqCnsGESupOutCYSShareIn", "eqCnsGESupOutCYSShareOut", "eqCnsGESupOutCYS", "eqCnsGESupOutCYSGrowth", "eqCnsESupOutCYSShareIn", "eqCnsESupOutCYSShareOut", "eqCnsESupOutCYS", "eqCnsESupOutCYSGrowth", "eqCnsLESupOutCRShareIn", "eqCnsLESupOutCRShareOut", "eqCnsLESupOutCR", "eqCnsGESupOutCRShareIn", "eqCnsGESupOutCRShareOut", "eqCnsGESupOutCR", "eqCnsESupOutCRShareIn", "eqCnsESupOutCRShareOut", "eqCnsESupOutCR", "eqCnsLESupOutCRSShareIn", "eqCnsLESupOutCRSShareOut", "eqCnsLESupOutCRS", "eqCnsGESupOutCRSShareIn", "eqCnsGESupOutCRSShareOut", "eqCnsGESupOutCRS", "eqCnsESupOutCRSShareIn", "eqCnsESupOutCRSShareOut", "eqCnsESupOutCRS", "eqCnsLESupOutCRYShareIn", "eqCnsLESupOutCRYShareOut", "eqCnsLESupOutCRY", "eqCnsLESupOutCRYGrowth", "eqCnsGESupOutCRYShareIn", "eqCnsGESupOutCRYShareOut", "eqCnsGESupOutCRY", "eqCnsGESupOutCRYGrowth", "eqCnsESupOutCRYShareIn", "eqCnsESupOutCRYShareOut", "eqCnsESupOutCRY", "eqCnsESupOutCRYGrowth", "eqCnsLESupOutCRYSShareIn", "eqCnsLESupOutCRYSShareOut", "eqCnsLESupOutCRYS", "eqCnsLESupOutCRYSGrowth", "eqCnsGESupOutCRYSShareIn", "eqCnsGESupOutCRYSShareOut", "eqCnsGESupOutCRYS", "eqCnsGESupOutCRYSGrowth", "eqCnsESupOutCRYSShareIn", "eqCnsESupOutCRYSShareOut", "eqCnsESupOutCRYS", "eqCnsESupOutCRYSGrowth", "eqCnsLESupOutLShareIn", "eqCnsLESupOutLShareOut", "eqCnsLESupOutL", "eqCnsGESupOutLShareIn", "eqCnsGESupOutLShareOut", "eqCnsGESupOutL", "eqCnsESupOutLShareIn", "eqCnsESupOutLShareOut", "eqCnsESupOutL", "eqCnsLESupOutLSShareIn", "eqCnsLESupOutLSShareOut", "eqCnsLESupOutLS", "eqCnsGESupOutLSShareIn", "eqCnsGESupOutLSShareOut", "eqCnsGESupOutLS", "eqCnsESupOutLSShareIn", "eqCnsESupOutLSShareOut", "eqCnsESupOutLS", "eqCnsLESupOutLYShareIn", "eqCnsLESupOutLYShareOut", "eqCnsLESupOutLY", "eqCnsLESupOutLYGrowth", "eqCnsGESupOutLYShareIn", "eqCnsGESupOutLYShareOut", "eqCnsGESupOutLY", "eqCnsGESupOutLYGrowth", "eqCnsESupOutLYShareIn", "eqCnsESupOutLYShareOut", "eqCnsESupOutLY", "eqCnsESupOutLYGrowth", "eqCnsLESupOutLYSShareIn", "eqCnsLESupOutLYSShareOut", "eqCnsLESupOutLYS", "eqCnsLESupOutLYSGrowth", "eqCnsGESupOutLYSShareIn", "eqCnsGESupOutLYSShareOut", "eqCnsGESupOutLYS", "eqCnsGESupOutLYSGrowth", "eqCnsESupOutLYSShareIn", "eqCnsESupOutLYSShareOut", "eqCnsESupOutLYS", "eqCnsESupOutLYSGrowth", "eqCnsLESupOutLRShareIn", "eqCnsLESupOutLRShareOut", "eqCnsLESupOutLR", "eqCnsGESupOutLRShareIn", "eqCnsGESupOutLRShareOut", "eqCnsGESupOutLR", "eqCnsESupOutLRShareIn", "eqCnsESupOutLRShareOut", "eqCnsESupOutLR", "eqCnsLESupOutLRSShareIn", "eqCnsLESupOutLRSShareOut", "eqCnsLESupOutLRS", "eqCnsGESupOutLRSShareIn", "eqCnsGESupOutLRSShareOut", "eqCnsGESupOutLRS", "eqCnsESupOutLRSShareIn", "eqCnsESupOutLRSShareOut", "eqCnsESupOutLRS", "eqCnsLESupOutLRYShareIn", "eqCnsLESupOutLRYShareOut", "eqCnsLESupOutLRY", "eqCnsLESupOutLRYGrowth", "eqCnsGESupOutLRYShareIn", "eqCnsGESupOutLRYShareOut", "eqCnsGESupOutLRY", "eqCnsGESupOutLRYGrowth", "eqCnsESupOutLRYShareIn", "eqCnsESupOutLRYShareOut", "eqCnsESupOutLRY", "eqCnsESupOutLRYGrowth", "eqCnsLESupOutLRYSShareIn", "eqCnsLESupOutLRYSShareOut", "eqCnsLESupOutLRYS", "eqCnsLESupOutLRYSGrowth", "eqCnsGESupOutLRYSShareIn", "eqCnsGESupOutLRYSShareOut", "eqCnsGESupOutLRYS", "eqCnsGESupOutLRYSGrowth", "eqCnsESupOutLRYSShareIn", "eqCnsESupOutLRYSShareOut", "eqCnsESupOutLRYS", "eqCnsESupOutLRYSGrowth", "eqCnsLESupOutLCShareIn", "eqCnsLESupOutLCShareOut", "eqCnsLESupOutLC", "eqCnsGESupOutLCShareIn", "eqCnsGESupOutLCShareOut", "eqCnsGESupOutLC", "eqCnsESupOutLCShareIn", "eqCnsESupOutLCShareOut", "eqCnsESupOutLC", "eqCnsLESupOutLCSShareIn", "eqCnsLESupOutLCSShareOut", "eqCnsLESupOutLCS", "eqCnsGESupOutLCSShareIn", "eqCnsGESupOutLCSShareOut", "eqCnsGESupOutLCS", "eqCnsESupOutLCSShareIn", "eqCnsESupOutLCSShareOut", "eqCnsESupOutLCS", "eqCnsLESupOutLCYShareIn", "eqCnsLESupOutLCYShareOut", "eqCnsLESupOutLCY", "eqCnsLESupOutLCYGrowth", "eqCnsGESupOutLCYShareIn", "eqCnsGESupOutLCYShareOut", "eqCnsGESupOutLCY", "eqCnsGESupOutLCYGrowth", "eqCnsESupOutLCYShareIn", "eqCnsESupOutLCYShareOut", "eqCnsESupOutLCY", "eqCnsESupOutLCYGrowth", "eqCnsLESupOutLCYSShareIn", "eqCnsLESupOutLCYSShareOut", "eqCnsLESupOutLCYS", "eqCnsLESupOutLCYSGrowth", "eqCnsGESupOutLCYSShareIn", "eqCnsGESupOutLCYSShareOut", "eqCnsGESupOutLCYS", "eqCnsGESupOutLCYSGrowth", "eqCnsESupOutLCYSShareIn", "eqCnsESupOutLCYSShareOut", "eqCnsESupOutLCYS", "eqCnsESupOutLCYSGrowth", "eqCnsLESupOutLCRShareIn", "eqCnsLESupOutLCRShareOut", "eqCnsLESupOutLCR", "eqCnsGESupOutLCRShareIn", "eqCnsGESupOutLCRShareOut", "eqCnsGESupOutLCR", "eqCnsESupOutLCRShareIn", "eqCnsESupOutLCRShareOut", "eqCnsESupOutLCR", "eqCnsLESupOutLCRSShareIn", "eqCnsLESupOutLCRSShareOut", "eqCnsLESupOutLCRS", "eqCnsGESupOutLCRSShareIn", "eqCnsGESupOutLCRSShareOut", "eqCnsGESupOutLCRS", "eqCnsESupOutLCRSShareIn", "eqCnsESupOutLCRSShareOut", "eqCnsESupOutLCRS", "eqCnsLESupOutLCRYShareIn", "eqCnsLESupOutLCRYShareOut", "eqCnsLESupOutLCRY", "eqCnsLESupOutLCRYGrowth", "eqCnsGESupOutLCRYShareIn", "eqCnsGESupOutLCRYShareOut", "eqCnsGESupOutLCRY", "eqCnsGESupOutLCRYGrowth", "eqCnsESupOutLCRYShareIn", "eqCnsESupOutLCRYShareOut", "eqCnsESupOutLCRY", "eqCnsESupOutLCRYGrowth", "eqCnsLESupOutLCRYSShareIn", "eqCnsLESupOutLCRYSShareOut", "eqCnsLESupOutLCRYS", "eqCnsLESupOutLCRYSGrowth", "eqCnsGESupOutLCRYSShareIn", "eqCnsGESupOutLCRYSShareOut", "eqCnsGESupOutLCRYS", "eqCnsGESupOutLCRYSGrowth", "eqCnsESupOutLCRYSShareIn", "eqCnsESupOutLCRYSShareOut", "eqCnsESupOutLCRYS", "eqCnsESupOutLCRYSGrowth", "eqPreDefSupOut")] <- TRUE;
    rs["vSupReserve", c("name", "description")] <- c("vSupReserve", "Accumulated used reserve");
    rs["vSupReserve", c("sup", "eqSupReserve", "eqSupReserveCheck")] <- TRUE;
    rs["vDemInp", c("name", "description")] <- c("vDemInp", "??? Input???");
    rs["vDemInp", c("comm", "region", "year", "slice", "eqDemInp", "eqInpTot", "eqPreDefDemInp")] <- TRUE;
    rs["vOutTot", c("name", "description")] <- c("vOutTot", "Total commodity output");
    rs["vOutTot", c("comm", "region", "year", "slice", "eqAggOut", "eqBal", "eqOutTot", "eqTaxCost", "eqSubsCost", "eqCnsLETechInpShareOut", "eqCnsGETechInpShareOut", "eqCnsETechInpShareOut", "eqCnsLETechInpSShareOut", "eqCnsGETechInpSShareOut", "eqCnsETechInpSShareOut", "eqCnsLETechInpYShareOut", "eqCnsGETechInpYShareOut", "eqCnsETechInpYShareOut", "eqCnsLETechInpYSShareOut", "eqCnsGETechInpYSShareOut", "eqCnsETechInpYSShareOut", "eqCnsLETechInpRShareOut", "eqCnsGETechInpRShareOut", "eqCnsETechInpRShareOut", "eqCnsLETechInpRSShareOut", "eqCnsGETechInpRSShareOut", "eqCnsETechInpRSShareOut", "eqCnsLETechInpRYShareOut", "eqCnsGETechInpRYShareOut", "eqCnsETechInpRYShareOut", "eqCnsLETechInpRYSShareOut", "eqCnsGETechInpRYSShareOut", "eqCnsETechInpRYSShareOut", "eqCnsLETechInpCShareOut", "eqCnsGETechInpCShareOut", "eqCnsETechInpCShareOut", "eqCnsLETechInpCSShareOut", "eqCnsGETechInpCSShareOut", "eqCnsETechInpCSShareOut", "eqCnsLETechInpCYShareOut", "eqCnsGETechInpCYShareOut", "eqCnsETechInpCYShareOut", "eqCnsLETechInpCYSShareOut", "eqCnsGETechInpCYSShareOut", "eqCnsETechInpCYSShareOut", "eqCnsLETechInpCRShareOut", "eqCnsGETechInpCRShareOut", "eqCnsETechInpCRShareOut", "eqCnsLETechInpCRSShareOut", "eqCnsGETechInpCRSShareOut", "eqCnsETechInpCRSShareOut", "eqCnsLETechInpCRYShareOut", "eqCnsGETechInpCRYShareOut", "eqCnsETechInpCRYShareOut", "eqCnsLETechInpCRYSShareOut", "eqCnsGETechInpCRYSShareOut", "eqCnsETechInpCRYSShareOut", "eqCnsLETechOutShareOut", "eqCnsGETechOutShareOut", "eqCnsETechOutShareOut", "eqCnsLETechOutSShareOut", "eqCnsGETechOutSShareOut", "eqCnsETechOutSShareOut", "eqCnsLETechOutYShareOut", "eqCnsGETechOutYShareOut", "eqCnsETechOutYShareOut", "eqCnsLETechOutYSShareOut", "eqCnsGETechOutYSShareOut", "eqCnsETechOutYSShareOut", "eqCnsLETechOutRShareOut", "eqCnsGETechOutRShareOut", "eqCnsETechOutRShareOut", "eqCnsLETechOutRSShareOut", "eqCnsGETechOutRSShareOut", "eqCnsETechOutRSShareOut", "eqCnsLETechOutRYShareOut", "eqCnsGETechOutRYShareOut", "eqCnsETechOutRYShareOut", "eqCnsLETechOutRYSShareOut", "eqCnsGETechOutRYSShareOut", "eqCnsETechOutRYSShareOut", "eqCnsLETechOutCShareOut", "eqCnsGETechOutCShareOut", "eqCnsETechOutCShareOut", "eqCnsLETechOutCSShareOut", "eqCnsGETechOutCSShareOut", "eqCnsETechOutCSShareOut", "eqCnsLETechOutCYShareOut", "eqCnsGETechOutCYShareOut", "eqCnsETechOutCYShareOut", "eqCnsLETechOutCYSShareOut", "eqCnsGETechOutCYSShareOut", "eqCnsETechOutCYSShareOut", "eqCnsLETechOutCRShareOut", "eqCnsGETechOutCRShareOut", "eqCnsETechOutCRShareOut", "eqCnsLETechOutCRSShareOut", "eqCnsGETechOutCRSShareOut", "eqCnsETechOutCRSShareOut", "eqCnsLETechOutCRYShareOut", "eqCnsGETechOutCRYShareOut", "eqCnsETechOutCRYShareOut", "eqCnsLETechOutCRYSShareOut", "eqCnsGETechOutCRYSShareOut", "eqCnsETechOutCRYSShareOut", "eqCnsLETechInpLShareOut", "eqCnsGETechInpLShareOut", "eqCnsETechInpLShareOut", "eqCnsLETechInpLSShareOut", "eqCnsGETechInpLSShareOut", "eqCnsETechInpLSShareOut", "eqCnsLETechInpLYShareOut", "eqCnsGETechInpLYShareOut", "eqCnsETechInpLYShareOut", "eqCnsLETechInpLYSShareOut", "eqCnsGETechInpLYSShareOut", "eqCnsETechInpLYSShareOut", "eqCnsLETechInpLRShareOut", "eqCnsGETechInpLRShareOut", "eqCnsETechInpLRShareOut", "eqCnsLETechInpLRSShareOut", "eqCnsGETechInpLRSShareOut", "eqCnsETechInpLRSShareOut", "eqCnsLETechInpLRYShareOut", "eqCnsGETechInpLRYShareOut", "eqCnsETechInpLRYShareOut", "eqCnsLETechInpLRYSShareOut", "eqCnsGETechInpLRYSShareOut", "eqCnsETechInpLRYSShareOut", "eqCnsLETechInpLCShareOut", "eqCnsGETechInpLCShareOut", "eqCnsETechInpLCShareOut", "eqCnsLETechInpLCSShareOut", "eqCnsGETechInpLCSShareOut", "eqCnsETechInpLCSShareOut", "eqCnsLETechInpLCYShareOut", "eqCnsGETechInpLCYShareOut", "eqCnsETechInpLCYShareOut", "eqCnsLETechInpLCYSShareOut", "eqCnsGETechInpLCYSShareOut", "eqCnsETechInpLCYSShareOut", "eqCnsLETechInpLCRShareOut", "eqCnsGETechInpLCRShareOut", "eqCnsETechInpLCRShareOut", "eqCnsLETechInpLCRSShareOut", "eqCnsGETechInpLCRSShareOut", "eqCnsETechInpLCRSShareOut", "eqCnsLETechInpLCRYShareOut", "eqCnsGETechInpLCRYShareOut", "eqCnsETechInpLCRYShareOut", "eqCnsLETechInpLCRYSShareOut", "eqCnsGETechInpLCRYSShareOut", "eqCnsETechInpLCRYSShareOut", "eqCnsLETechOutLShareOut", "eqCnsGETechOutLShareOut", "eqCnsETechOutLShareOut", "eqCnsLETechOutLSShareOut", "eqCnsGETechOutLSShareOut", "eqCnsETechOutLSShareOut", "eqCnsLETechOutLYShareOut", "eqCnsGETechOutLYShareOut", "eqCnsETechOutLYShareOut", "eqCnsLETechOutLYSShareOut", "eqCnsGETechOutLYSShareOut", "eqCnsETechOutLYSShareOut", "eqCnsLETechOutLRShareOut", "eqCnsGETechOutLRShareOut", "eqCnsETechOutLRShareOut", "eqCnsLETechOutLRSShareOut", "eqCnsGETechOutLRSShareOut", "eqCnsETechOutLRSShareOut", "eqCnsLETechOutLRYShareOut", "eqCnsGETechOutLRYShareOut", "eqCnsETechOutLRYShareOut", "eqCnsLETechOutLRYSShareOut", "eqCnsGETechOutLRYSShareOut", "eqCnsETechOutLRYSShareOut", "eqCnsLETechOutLCShareOut", "eqCnsGETechOutLCShareOut", "eqCnsETechOutLCShareOut", "eqCnsLETechOutLCSShareOut", "eqCnsGETechOutLCSShareOut", "eqCnsETechOutLCSShareOut", "eqCnsLETechOutLCYShareOut", "eqCnsGETechOutLCYShareOut", "eqCnsETechOutLCYShareOut", "eqCnsLETechOutLCYSShareOut", "eqCnsGETechOutLCYSShareOut", "eqCnsETechOutLCYSShareOut", "eqCnsLETechOutLCRShareOut", "eqCnsGETechOutLCRShareOut", "eqCnsETechOutLCRShareOut", "eqCnsLETechOutLCRSShareOut", "eqCnsGETechOutLCRSShareOut", "eqCnsETechOutLCRSShareOut", "eqCnsLETechOutLCRYShareOut", "eqCnsGETechOutLCRYShareOut", "eqCnsETechOutLCRYShareOut", "eqCnsLETechOutLCRYSShareOut", "eqCnsGETechOutLCRYSShareOut", "eqCnsETechOutLCRYSShareOut", "eqCnsLESupOutShareOut", "eqCnsGESupOutShareOut", "eqCnsESupOutShareOut", "eqCnsLESupOutSShareOut", "eqCnsGESupOutSShareOut", "eqCnsESupOutSShareOut", "eqCnsLESupOutYShareOut", "eqCnsGESupOutYShareOut", "eqCnsESupOutYShareOut", "eqCnsLESupOutYSShareOut", "eqCnsGESupOutYSShareOut", "eqCnsESupOutYSShareOut", "eqCnsLESupOutRShareOut", "eqCnsGESupOutRShareOut", "eqCnsESupOutRShareOut", "eqCnsLESupOutRSShareOut", "eqCnsGESupOutRSShareOut", "eqCnsESupOutRSShareOut", "eqCnsLESupOutRYShareOut", "eqCnsGESupOutRYShareOut", "eqCnsESupOutRYShareOut", "eqCnsLESupOutRYSShareOut", "eqCnsGESupOutRYSShareOut", "eqCnsESupOutRYSShareOut", "eqCnsLESupOutCShareOut", "eqCnsGESupOutCShareOut", "eqCnsESupOutCShareOut", "eqCnsLESupOutCSShareOut", "eqCnsGESupOutCSShareOut", "eqCnsESupOutCSShareOut", "eqCnsLESupOutCYShareOut", "eqCnsGESupOutCYShareOut", "eqCnsESupOutCYShareOut", "eqCnsLESupOutCYSShareOut", "eqCnsGESupOutCYSShareOut", "eqCnsESupOutCYSShareOut", "eqCnsLESupOutCRShareOut", "eqCnsGESupOutCRShareOut", "eqCnsESupOutCRShareOut", "eqCnsLESupOutCRSShareOut", "eqCnsGESupOutCRSShareOut", "eqCnsESupOutCRSShareOut", "eqCnsLESupOutCRYShareOut", "eqCnsGESupOutCRYShareOut", "eqCnsESupOutCRYShareOut", "eqCnsLESupOutCRYSShareOut", "eqCnsGESupOutCRYSShareOut", "eqCnsESupOutCRYSShareOut", "eqCnsLESupOutLShareOut", "eqCnsGESupOutLShareOut", "eqCnsESupOutLShareOut", "eqCnsLESupOutLSShareOut", "eqCnsGESupOutLSShareOut", "eqCnsESupOutLSShareOut", "eqCnsLESupOutLYShareOut", "eqCnsGESupOutLYShareOut", "eqCnsESupOutLYShareOut", "eqCnsLESupOutLYSShareOut", "eqCnsGESupOutLYSShareOut", "eqCnsESupOutLYSShareOut", "eqCnsLESupOutLRShareOut", "eqCnsGESupOutLRShareOut", "eqCnsESupOutLRShareOut", "eqCnsLESupOutLRSShareOut", "eqCnsGESupOutLRSShareOut", "eqCnsESupOutLRSShareOut", "eqCnsLESupOutLRYShareOut", "eqCnsGESupOutLRYShareOut", "eqCnsESupOutLRYShareOut", "eqCnsLESupOutLRYSShareOut", "eqCnsGESupOutLRYSShareOut", "eqCnsESupOutLRYSShareOut", "eqCnsLESupOutLCShareOut", "eqCnsGESupOutLCShareOut", "eqCnsESupOutLCShareOut", "eqCnsLESupOutLCSShareOut", "eqCnsGESupOutLCSShareOut", "eqCnsESupOutLCSShareOut", "eqCnsLESupOutLCYShareOut", "eqCnsGESupOutLCYShareOut", "eqCnsESupOutLCYShareOut", "eqCnsLESupOutLCYSShareOut", "eqCnsGESupOutLCYSShareOut", "eqCnsESupOutLCYSShareOut", "eqCnsLESupOutLCRShareOut", "eqCnsGESupOutLCRShareOut", "eqCnsESupOutLCRShareOut", "eqCnsLESupOutLCRSShareOut", "eqCnsGESupOutLCRSShareOut", "eqCnsESupOutLCRSShareOut", "eqCnsLESupOutLCRYShareOut", "eqCnsGESupOutLCRYShareOut", "eqCnsESupOutLCRYShareOut", "eqCnsLESupOutLCRYSShareOut", "eqCnsGESupOutLCRYSShareOut", "eqCnsESupOutLCRYSShareOut", "eqCnsLETotOut", "eqCnsGETotOut", "eqCnsETotOut", "eqCnsLETotOutS", "eqCnsGETotOutS", "eqCnsETotOutS", "eqCnsLETotOutY", "eqCnsLETotOutYGrowth", "eqCnsGETotOutY", "eqCnsGETotOutYGrowth", "eqCnsETotOutY", "eqCnsETotOutYGrowth", "eqCnsLETotOutYS", "eqCnsLETotOutYSGrowth", "eqCnsGETotOutYS", "eqCnsGETotOutYSGrowth", "eqCnsETotOutYS", "eqCnsETotOutYSGrowth", "eqCnsLETotOutR", "eqCnsGETotOutR", "eqCnsETotOutR", "eqCnsLETotOutRS", "eqCnsGETotOutRS", "eqCnsETotOutRS", "eqCnsLETotOutRY", "eqCnsLETotOutRYGrowth", "eqCnsGETotOutRY", "eqCnsGETotOutRYGrowth", "eqCnsETotOutRY", "eqCnsETotOutRYGrowth", "eqCnsLETotOutRYS", "eqCnsLETotOutRYSGrowth", "eqCnsGETotOutRYS", "eqCnsGETotOutRYSGrowth", "eqCnsETotOutRYS", "eqCnsETotOutRYSGrowth", "eqCnsLETotOutC", "eqCnsGETotOutC", "eqCnsETotOutC", "eqCnsLETotOutCS", "eqCnsGETotOutCS", "eqCnsETotOutCS", "eqCnsLETotOutCY", "eqCnsLETotOutCYGrowth", "eqCnsGETotOutCY", "eqCnsGETotOutCYGrowth", "eqCnsETotOutCY", "eqCnsETotOutCYGrowth", "eqCnsLETotOutCYS", "eqCnsLETotOutCYSGrowth", "eqCnsGETotOutCYS", "eqCnsGETotOutCYSGrowth", "eqCnsETotOutCYS", "eqCnsETotOutCYSGrowth", "eqCnsLETotOutCR", "eqCnsGETotOutCR", "eqCnsETotOutCR", "eqCnsLETotOutCRS", "eqCnsGETotOutCRS", "eqCnsETotOutCRS", "eqCnsLETotOutCRY", "eqCnsLETotOutCRYGrowth", "eqCnsGETotOutCRY", "eqCnsGETotOutCRYGrowth", "eqCnsETotOutCRY", "eqCnsETotOutCRYGrowth", "eqCnsLETotOutCRYS", "eqCnsLETotOutCRYSGrowth", "eqCnsGETotOutCRYS", "eqCnsGETotOutCRYSGrowth", "eqCnsETotOutCRYS", "eqCnsETotOutCRYSGrowth")] <- TRUE;
    rs["vInpTot", c("name", "description")] <- c("vInpTot", "Total commodity input");
    rs["vInpTot", c("comm", "region", "year", "slice", "eqBal", "eqInpTot", "eqCnsLETechInpShareIn", "eqCnsGETechInpShareIn", "eqCnsETechInpShareIn", "eqCnsLETechInpSShareIn", "eqCnsGETechInpSShareIn", "eqCnsETechInpSShareIn", "eqCnsLETechInpYShareIn", "eqCnsGETechInpYShareIn", "eqCnsETechInpYShareIn", "eqCnsLETechInpYSShareIn", "eqCnsGETechInpYSShareIn", "eqCnsETechInpYSShareIn", "eqCnsLETechInpRShareIn", "eqCnsGETechInpRShareIn", "eqCnsETechInpRShareIn", "eqCnsLETechInpRSShareIn", "eqCnsGETechInpRSShareIn", "eqCnsETechInpRSShareIn", "eqCnsLETechInpRYShareIn", "eqCnsGETechInpRYShareIn", "eqCnsETechInpRYShareIn", "eqCnsLETechInpRYSShareIn", "eqCnsGETechInpRYSShareIn", "eqCnsETechInpRYSShareIn", "eqCnsLETechInpCShareIn", "eqCnsGETechInpCShareIn", "eqCnsETechInpCShareIn", "eqCnsLETechInpCSShareIn", "eqCnsGETechInpCSShareIn", "eqCnsETechInpCSShareIn", "eqCnsLETechInpCYShareIn", "eqCnsGETechInpCYShareIn", "eqCnsETechInpCYShareIn", "eqCnsLETechInpCYSShareIn", "eqCnsGETechInpCYSShareIn", "eqCnsETechInpCYSShareIn", "eqCnsLETechInpCRShareIn", "eqCnsGETechInpCRShareIn", "eqCnsETechInpCRShareIn", "eqCnsLETechInpCRSShareIn", "eqCnsGETechInpCRSShareIn", "eqCnsETechInpCRSShareIn", "eqCnsLETechInpCRYShareIn", "eqCnsGETechInpCRYShareIn", "eqCnsETechInpCRYShareIn", "eqCnsLETechInpCRYSShareIn", "eqCnsGETechInpCRYSShareIn", "eqCnsETechInpCRYSShareIn", "eqCnsLETechOutShareIn", "eqCnsGETechOutShareIn", "eqCnsETechOutShareIn", "eqCnsLETechOutSShareIn", "eqCnsGETechOutSShareIn", "eqCnsETechOutSShareIn", "eqCnsLETechOutYShareIn", "eqCnsGETechOutYShareIn", "eqCnsETechOutYShareIn", "eqCnsLETechOutYSShareIn", "eqCnsGETechOutYSShareIn", "eqCnsETechOutYSShareIn", "eqCnsLETechOutRShareIn", "eqCnsGETechOutRShareIn", "eqCnsETechOutRShareIn", "eqCnsLETechOutRSShareIn", "eqCnsGETechOutRSShareIn", "eqCnsETechOutRSShareIn", "eqCnsLETechOutRYShareIn", "eqCnsGETechOutRYShareIn", "eqCnsETechOutRYShareIn", "eqCnsLETechOutRYSShareIn", "eqCnsGETechOutRYSShareIn", "eqCnsETechOutRYSShareIn", "eqCnsLETechOutCShareIn", "eqCnsGETechOutCShareIn", "eqCnsETechOutCShareIn", "eqCnsLETechOutCSShareIn", "eqCnsGETechOutCSShareIn", "eqCnsETechOutCSShareIn", "eqCnsLETechOutCYShareIn", "eqCnsGETechOutCYShareIn", "eqCnsETechOutCYShareIn", "eqCnsLETechOutCYSShareIn", "eqCnsGETechOutCYSShareIn", "eqCnsETechOutCYSShareIn", "eqCnsLETechOutCRShareIn", "eqCnsGETechOutCRShareIn", "eqCnsETechOutCRShareIn", "eqCnsLETechOutCRSShareIn", "eqCnsGETechOutCRSShareIn", "eqCnsETechOutCRSShareIn", "eqCnsLETechOutCRYShareIn", "eqCnsGETechOutCRYShareIn", "eqCnsETechOutCRYShareIn", "eqCnsLETechOutCRYSShareIn", "eqCnsGETechOutCRYSShareIn", "eqCnsETechOutCRYSShareIn", "eqCnsLETechInpLShareIn", "eqCnsGETechInpLShareIn", "eqCnsETechInpLShareIn", "eqCnsLETechInpLSShareIn", "eqCnsGETechInpLSShareIn", "eqCnsETechInpLSShareIn", "eqCnsLETechInpLYShareIn", "eqCnsGETechInpLYShareIn", "eqCnsETechInpLYShareIn", "eqCnsLETechInpLYSShareIn", "eqCnsGETechInpLYSShareIn", "eqCnsETechInpLYSShareIn", "eqCnsLETechInpLRShareIn", "eqCnsGETechInpLRShareIn", "eqCnsETechInpLRShareIn", "eqCnsLETechInpLRSShareIn", "eqCnsGETechInpLRSShareIn", "eqCnsETechInpLRSShareIn", "eqCnsLETechInpLRYShareIn", "eqCnsGETechInpLRYShareIn", "eqCnsETechInpLRYShareIn", "eqCnsLETechInpLRYSShareIn", "eqCnsGETechInpLRYSShareIn", "eqCnsETechInpLRYSShareIn", "eqCnsLETechInpLCShareIn", "eqCnsGETechInpLCShareIn", "eqCnsETechInpLCShareIn", "eqCnsLETechInpLCSShareIn", "eqCnsGETechInpLCSShareIn", "eqCnsETechInpLCSShareIn", "eqCnsLETechInpLCYShareIn", "eqCnsGETechInpLCYShareIn", "eqCnsETechInpLCYShareIn", "eqCnsLETechInpLCYSShareIn", "eqCnsGETechInpLCYSShareIn", "eqCnsETechInpLCYSShareIn", "eqCnsLETechInpLCRShareIn", "eqCnsGETechInpLCRShareIn", "eqCnsETechInpLCRShareIn", "eqCnsLETechInpLCRSShareIn", "eqCnsGETechInpLCRSShareIn", "eqCnsETechInpLCRSShareIn", "eqCnsLETechInpLCRYShareIn", "eqCnsGETechInpLCRYShareIn", "eqCnsETechInpLCRYShareIn", "eqCnsLETechInpLCRYSShareIn", "eqCnsGETechInpLCRYSShareIn", "eqCnsETechInpLCRYSShareIn", "eqCnsLETechOutLShareIn", "eqCnsGETechOutLShareIn", "eqCnsETechOutLShareIn", "eqCnsLETechOutLSShareIn", "eqCnsGETechOutLSShareIn", "eqCnsETechOutLSShareIn", "eqCnsLETechOutLYShareIn", "eqCnsGETechOutLYShareIn", "eqCnsETechOutLYShareIn", "eqCnsLETechOutLYSShareIn", "eqCnsGETechOutLYSShareIn", "eqCnsETechOutLYSShareIn", "eqCnsLETechOutLRShareIn", "eqCnsGETechOutLRShareIn", "eqCnsETechOutLRShareIn", "eqCnsLETechOutLRSShareIn", "eqCnsGETechOutLRSShareIn", "eqCnsETechOutLRSShareIn", "eqCnsLETechOutLRYShareIn", "eqCnsGETechOutLRYShareIn", "eqCnsETechOutLRYShareIn", "eqCnsLETechOutLRYSShareIn", "eqCnsGETechOutLRYSShareIn", "eqCnsETechOutLRYSShareIn", "eqCnsLETechOutLCShareIn", "eqCnsGETechOutLCShareIn", "eqCnsETechOutLCShareIn", "eqCnsLETechOutLCSShareIn", "eqCnsGETechOutLCSShareIn", "eqCnsETechOutLCSShareIn", "eqCnsLETechOutLCYShareIn", "eqCnsGETechOutLCYShareIn", "eqCnsETechOutLCYShareIn", "eqCnsLETechOutLCYSShareIn", "eqCnsGETechOutLCYSShareIn", "eqCnsETechOutLCYSShareIn", "eqCnsLETechOutLCRShareIn", "eqCnsGETechOutLCRShareIn", "eqCnsETechOutLCRShareIn", "eqCnsLETechOutLCRSShareIn", "eqCnsGETechOutLCRSShareIn", "eqCnsETechOutLCRSShareIn", "eqCnsLETechOutLCRYShareIn", "eqCnsGETechOutLCRYShareIn", "eqCnsETechOutLCRYShareIn", "eqCnsLETechOutLCRYSShareIn", "eqCnsGETechOutLCRYSShareIn", "eqCnsETechOutLCRYSShareIn", "eqCnsLESupOutShareIn", "eqCnsGESupOutShareIn", "eqCnsESupOutShareIn", "eqCnsLESupOutSShareIn", "eqCnsGESupOutSShareIn", "eqCnsESupOutSShareIn", "eqCnsLESupOutYShareIn", "eqCnsGESupOutYShareIn", "eqCnsESupOutYShareIn", "eqCnsLESupOutYSShareIn", "eqCnsGESupOutYSShareIn", "eqCnsESupOutYSShareIn", "eqCnsLESupOutRShareIn", "eqCnsGESupOutRShareIn", "eqCnsESupOutRShareIn", "eqCnsLESupOutRSShareIn", "eqCnsGESupOutRSShareIn", "eqCnsESupOutRSShareIn", "eqCnsLESupOutRYShareIn", "eqCnsGESupOutRYShareIn", "eqCnsESupOutRYShareIn", "eqCnsLESupOutRYSShareIn", "eqCnsGESupOutRYSShareIn", "eqCnsESupOutRYSShareIn", "eqCnsLESupOutCShareIn", "eqCnsGESupOutCShareIn", "eqCnsESupOutCShareIn", "eqCnsLESupOutCSShareIn", "eqCnsGESupOutCSShareIn", "eqCnsESupOutCSShareIn", "eqCnsLESupOutCYShareIn", "eqCnsGESupOutCYShareIn", "eqCnsESupOutCYShareIn", "eqCnsLESupOutCYSShareIn", "eqCnsGESupOutCYSShareIn", "eqCnsESupOutCYSShareIn", "eqCnsLESupOutCRShareIn", "eqCnsGESupOutCRShareIn", "eqCnsESupOutCRShareIn", "eqCnsLESupOutCRSShareIn", "eqCnsGESupOutCRSShareIn", "eqCnsESupOutCRSShareIn", "eqCnsLESupOutCRYShareIn", "eqCnsGESupOutCRYShareIn", "eqCnsESupOutCRYShareIn", "eqCnsLESupOutCRYSShareIn", "eqCnsGESupOutCRYSShareIn", "eqCnsESupOutCRYSShareIn", "eqCnsLESupOutLShareIn", "eqCnsGESupOutLShareIn", "eqCnsESupOutLShareIn", "eqCnsLESupOutLSShareIn", "eqCnsGESupOutLSShareIn", "eqCnsESupOutLSShareIn", "eqCnsLESupOutLYShareIn", "eqCnsGESupOutLYShareIn", "eqCnsESupOutLYShareIn", "eqCnsLESupOutLYSShareIn", "eqCnsGESupOutLYSShareIn", "eqCnsESupOutLYSShareIn", "eqCnsLESupOutLRShareIn", "eqCnsGESupOutLRShareIn", "eqCnsESupOutLRShareIn", "eqCnsLESupOutLRSShareIn", "eqCnsGESupOutLRSShareIn", "eqCnsESupOutLRSShareIn", "eqCnsLESupOutLRYShareIn", "eqCnsGESupOutLRYShareIn", "eqCnsESupOutLRYShareIn", "eqCnsLESupOutLRYSShareIn", "eqCnsGESupOutLRYSShareIn", "eqCnsESupOutLRYSShareIn", "eqCnsLESupOutLCShareIn", "eqCnsGESupOutLCShareIn", "eqCnsESupOutLCShareIn", "eqCnsLESupOutLCSShareIn", "eqCnsGESupOutLCSShareIn", "eqCnsESupOutLCSShareIn", "eqCnsLESupOutLCYShareIn", "eqCnsGESupOutLCYShareIn", "eqCnsESupOutLCYShareIn", "eqCnsLESupOutLCYSShareIn", "eqCnsGESupOutLCYSShareIn", "eqCnsESupOutLCYSShareIn", "eqCnsLESupOutLCRShareIn", "eqCnsGESupOutLCRShareIn", "eqCnsESupOutLCRShareIn", "eqCnsLESupOutLCRSShareIn", "eqCnsGESupOutLCRSShareIn", "eqCnsESupOutLCRSShareIn", "eqCnsLESupOutLCRYShareIn", "eqCnsGESupOutLCRYShareIn", "eqCnsESupOutLCRYShareIn", "eqCnsLESupOutLCRYSShareIn", "eqCnsGESupOutLCRYSShareIn", "eqCnsESupOutLCRYSShareIn", "eqCnsLETotInp", "eqCnsGETotInp", "eqCnsETotInp", "eqCnsLETotInpS", "eqCnsGETotInpS", "eqCnsETotInpS", "eqCnsLETotInpY", "eqCnsLETotInpYGrowth", "eqCnsGETotInpY", "eqCnsGETotInpYGrowth", "eqCnsETotInpY", "eqCnsETotInpYGrowth", "eqCnsLETotInpYS", "eqCnsLETotInpYSGrowth", "eqCnsGETotInpYS", "eqCnsGETotInpYSGrowth", "eqCnsETotInpYS", "eqCnsETotInpYSGrowth", "eqCnsLETotInpR", "eqCnsGETotInpR", "eqCnsETotInpR", "eqCnsLETotInpRS", "eqCnsGETotInpRS", "eqCnsETotInpRS", "eqCnsLETotInpRY", "eqCnsLETotInpRYGrowth", "eqCnsGETotInpRY", "eqCnsGETotInpRYGrowth", "eqCnsETotInpRY", "eqCnsETotInpRYGrowth", "eqCnsLETotInpRYS", "eqCnsLETotInpRYSGrowth", "eqCnsGETotInpRYS", "eqCnsGETotInpRYSGrowth", "eqCnsETotInpRYS", "eqCnsETotInpRYSGrowth", "eqCnsLETotInpC", "eqCnsGETotInpC", "eqCnsETotInpC", "eqCnsLETotInpCS", "eqCnsGETotInpCS", "eqCnsETotInpCS", "eqCnsLETotInpCY", "eqCnsLETotInpCYGrowth", "eqCnsGETotInpCY", "eqCnsGETotInpCYGrowth", "eqCnsETotInpCY", "eqCnsETotInpCYGrowth", "eqCnsLETotInpCYS", "eqCnsLETotInpCYSGrowth", "eqCnsGETotInpCYS", "eqCnsGETotInpCYSGrowth", "eqCnsETotInpCYS", "eqCnsETotInpCYSGrowth", "eqCnsLETotInpCR", "eqCnsGETotInpCR", "eqCnsETotInpCR", "eqCnsLETotInpCRS", "eqCnsGETotInpCRS", "eqCnsETotInpCRS", "eqCnsLETotInpCRY", "eqCnsLETotInpCRYGrowth", "eqCnsGETotInpCRY", "eqCnsGETotInpCRYGrowth", "eqCnsETotInpCRY", "eqCnsETotInpCRYGrowth", "eqCnsLETotInpCRYS", "eqCnsLETotInpCRYSGrowth", "eqCnsGETotInpCRYS", "eqCnsGETotInpCRYSGrowth", "eqCnsETotInpCRYS", "eqCnsETotInpCRYSGrowth")] <- TRUE;
    rs["vSupOutTot", c("name", "description")] <- c("vSupOutTot", "Total commodity supply");
    rs["vSupOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqSupOutTot")] <- TRUE;
    rs["vTechInpTot", c("name", "description")] <- c("vTechInpTot", "Total commodity input");
    rs["vTechInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqTechInpTot")] <- TRUE;
    rs["vTechOutTot", c("name", "description")] <- c("vTechOutTot", "Total technology output");
    rs["vTechOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqTechOutTot")] <- TRUE;
    rs["vStorageInpTot", c("name", "description")] <- c("vStorageInpTot", "Total storage input");
    rs["vStorageInpTot", c("comm", "region", "year", "slice", "eqInpTot", "eqStorageInpTot")] <- TRUE;
    rs["vStorageOutTot", c("name", "description")] <- c("vStorageOutTot", "Total storage output");
    rs["vStorageOutTot", c("comm", "region", "year", "slice", "eqOutTot", "eqStorageOutTot")] <- TRUE;
    rs["vDumOut", c("name", "description")] <- c("vDumOut", "Dummy import");
    rs["vDumOut", c("comm", "region", "year", "slice", "eqOutTot", "eqDumCost", "eqPreDefDumOut")] <- TRUE;
    rs["vDumCost", c("name", "description")] <- c("vDumCost", "Dummy import costs");
    rs["vDumCost", c("comm", "region", "year", "eqDumCost", "eqCost1", "eqCost2")] <- TRUE;
    rs["vStorageInp", c("name", "description")] <- c("vStorageInp", "Storage input");
    rs["vStorageInp", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageVar", "eqStorageInpTot", "eqPreDefStorageInp")] <- TRUE;
    rs["vStorageOut", c("name", "description")] <- c("vStorageOut", "Storage output");
    rs["vStorageOut", c("stg", "comm", "region", "year", "slice", "eqStorageStore", "eqStorageVar", "eqStorageOutTot", "eqPreDefStorageOut")] <- TRUE;
    rs["vStorageStore", c("name", "description")] <- c("vStorageStore", "Storage level");
    rs["vStorageStore", c("stg", "region", "year", "slice", "eqStorageStore", "eqStorageVar", "eqPreDefStorageStore")] <- TRUE;
    rs["vStorageVarom", c("name", "description")] <- c("vStorageVarom", "Storage variable O&M costs");
    rs["vStorageVarom", c("stg", "region", "year", "eqStorageVar", "eqStorageCost")] <- TRUE;
    rs["vStorageFixom", c("name", "description")] <- c("vStorageFixom", "Storage fixed O&M costs");
    rs["vStorageFixom", c("stg", "region", "year", "eqStorageFix", "eqStorageCost")] <- TRUE;
    rs["vStorageInv", c("name", "description")] <- c("vStorageInv", "Storage technology investments");
    rs["vStorageInv", c("stg", "region", "year", "eqStorageInv", "eqStorageSalv2", "eqStorageSalv3", "eqStorageCost")] <- TRUE;
    rs["vStorageSalv", c("name", "description")] <- c("vStorageSalv", "Storage salvage costs");
    rs["vStorageSalv", c("stg", "region", "eqStorageSalv2", "eqStorageSalv3", "eqCost2")] <- TRUE;
    rs["vStorageCap", c("name", "description")] <- c("vStorageCap", "??? Total storage capacity");
    rs["vStorageCap", c("stg", "region", "year", "eqStorageCap", "eqStorageFix", "eqStorageLo", "eqStorageUp", "eqPreDefStorageCap")] <- TRUE;
    rs["vStorageNewCap", c("name", "description")] <- c("vStorageNewCap", "Storage new capacity");
    rs["vStorageNewCap", c("stg", "region", "year", "eqStorageCap", "eqStorageInv", "eqPreDefStorageNewCap")] <- TRUE;
    rs["vImport", c("name", "description")] <- c("vImport", "Interregional import");
    rs["vImport", c("comm", "region", "year", "slice", "eqImport", "eqOutTot", "eqPreDefImport")] <- TRUE;
    rs["vExport", c("name", "description")] <- c("vExport", "Interregional export");
    rs["vExport", c("comm", "region", "year", "slice", "eqExport", "eqInpTot", "eqPreDefExport")] <- TRUE;
    rs["vTradeIr", c("name", "description")] <- c("vTradeIr", "Total physical trade flows");
    rs["vTradeIr", c("trade", "region", "year", "slice", "eqImport", "eqExport", "eqTradeFlowUp", "eqTradeFlowLo", "eqCostIrTrade", "eqPreDefTradeIr")] <- TRUE;
    rs["vExportRowRes", c("name", "description")] <- c("vExportRowRes", "??? Export to ROW");
    rs["vExportRowRes", c("expp", "eqExportRowRes", "eqExportRowResUp")] <- TRUE;
    rs["vExportRow", c("name", "description")] <- c("vExportRow", "???");
    rs["vExportRow", c("expp", "region", "year", "slice", "eqExport", "eqCostRowTrade", "eqExportRowUp", "eqExportRowLo", "eqExportRowRes", "eqPreDefExportRow")] <- TRUE;
    rs["vImportRowRes", c("name", "description")] <- c("vImportRowRes", "???");
    rs["vImportRowRes", c("imp", "eqImportRowRes", "eqImportRowResUp")] <- TRUE;
    rs["vImportRow", c("name", "description")] <- c("vImportRow", "???");
    rs["vImportRow", c("imp", "region", "year", "slice", "eqImport", "eqCostRowTrade", "eqImportRowUp", "eqImportRowLo", "eqImportRowRes", "eqPreDefImportRow")] <- TRUE;
    rs[, -(1:2)][is.na(rs[, -(1:2)])] <- FALSE;
rs
}
