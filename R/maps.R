#########################
# equation map
#########################
.variable_mapping = list(
  vTechNewCap = "vTechNewCap( tech , region , year ) $ mTechNew( tech , region , year )",
  vTechRetiredStock = "vTechRetiredStock( tech , region , year ) $ mvTechRetiredStock( tech , region , year )",
  vTechRetiredNewCap = "vTechRetiredNewCap( tech , region , year , year ) $ mvTechRetiredNewCap( tech , region , year , year )",
  vTechCap = "vTechCap( tech , region , year ) $ mTechSpan( tech , region , year )",
  vTechAct = "vTechAct( tech , region , year , slice ) $ mvTechAct( tech , region , year , slice )",
  vTechInp = "vTechInp( tech , comm , region , year , slice ) $ mvTechInp( tech , comm , region , year , slice )",
  vTechOut = "vTechOut( tech , comm , region , year , slice ) $ mvTechOut( tech , comm , region , year , slice )",
  vTechAInp = "vTechAInp( tech , comm , region , year , slice ) $ mvTechAInp( tech , comm , region , year , slice )",
  vTechAOut = "vTechAOut( tech , comm , region , year , slice ) $ mvTechAOut( tech , comm , region , year , slice )",
  vTechInv = "vTechInv( tech , region , year ) $ mTechInv( tech , region , year )",
  vTechEac = "vTechEac( tech , region , year ) $ mTechEac( tech , region , year )",
  vTechOMCost = "vTechOMCost( tech , region , year ) $ mTechOMCost( tech , region , year )",
  vSupOut = "vSupOut( sup , comm , region , year , slice ) $ mSupAva( sup , comm , region , year , slice )",
  vSupReserve = "vSupReserve( sup , comm , region ) $ mvSupReserve( sup , comm , region )",
  vSupCost = "vSupCost( sup , region , year ) $ mvSupCost( sup , region , year )",
  vDemInp = "vDemInp( comm , region , year , slice ) $ mvDemInp( comm , region , year , slice )",
  vEmsFuelTot = "vEmsFuelTot( comm , region , year , slice ) $ mEmsFuelTot( comm , region , year , slice )",
  vBalance = "vBalance( comm , region , year , slice ) $ mvBalance( comm , region , year , slice )",
  vOutTot = "vOutTot( comm , region , year , slice ) $ mvOutTot( comm , region , year , slice )",
  vInpTot = "vInpTot( comm , region , year , slice ) $ mvInpTot( comm , region , year , slice )",
  vInp2Lo = "vInp2Lo( comm , region , year , slice , slice ) $ mvInp2Lo( comm , region , year , slice , slice )",
  vOut2Lo = "vOut2Lo( comm , region , year , slice , slice ) $ mvOut2Lo( comm , region , year , slice , slice )",
  vSupOutTot = "vSupOutTot( comm , region , year , slice ) $ mSupOutTot( comm , region , year , slice )",
  vTechInpTot = "vTechInpTot( comm , region , year , slice ) $ mTechInpTot( comm , region , year , slice )",
  vTechOutTot = "vTechOutTot( comm , region , year , slice ) $ mTechOutTot( comm , region , year , slice )",
  vStorageInpTot = "vStorageInpTot( comm , region , year , slice ) $ mStorageInpTot( comm , region , year , slice )",
  vStorageOutTot = "vStorageOutTot( comm , region , year , slice ) $ mStorageOutTot( comm , region , year , slice )",
  vStorageAInp = "vStorageAInp( stg , comm , region , year , slice ) $ mvStorageAInp( stg , comm , region , year , slice )",
  vStorageAOut = "vStorageAOut( stg , comm , region , year , slice ) $ mvStorageAOut( stg , comm , region , year , slice )",
  vTotalCost = "vTotalCost( region , year ) $ mvTotalCost( region , year )",
  vDummyImport = "vDummyImport( comm , region , year , slice ) $ mDummyImport( comm , region , year , slice )",
  vDummyExport = "vDummyExport( comm , region , year , slice ) $ mDummyExport( comm , region , year , slice )",
  vTaxCost = "vTaxCost( comm , region , year ) $ mTaxCost( comm , region , year )",
  vSubsCost = "vSubsCost( comm , region , year ) $ mSubCost( comm , region , year )",
  vAggOut = "vAggOut( comm , region , year , slice ) $ mAggOut( comm , region , year , slice )",
  vStorageInp = "vStorageInp( stg , comm , region , year , slice ) $ mvStorageStore( stg , comm , region , year , slice )",
  vStorageOut = "vStorageOut( stg , comm , region , year , slice ) $ mvStorageStore( stg , comm , region , year , slice )",
  vStorageStore = "vStorageStore( stg , comm , region , year , slice ) $ mvStorageStore( stg , comm , region , year , slice )",
  vStorageInv = "vStorageInv( stg , region , year ) $ mStorageNew( stg , region , year )",
  vStorageEac = "vStorageEac( stg , region , year ) $ mStorageEac( stg , region , year )",
  vStorageCap = "vStorageCap( stg , region , year ) $ mStorageSpan( stg , region , year )",
  vStorageNewCap = "vStorageNewCap( stg , region , year ) $ mStorageNew( stg , region , year )",
  vStorageOMCost = "vStorageOMCost( stg , region , year ) $ mStorageOMCost( stg , region , year )",
  vImport = "vImport( comm , region , year , slice ) $ mImport( comm , region , year , slice )",
  vExport = "vExport( comm , region , year , slice ) $ mExport( comm , region , year , slice )",
  vTradeIr = "vTradeIr( trade , comm , region , region , year , slice ) $ mvTradeIr( trade , comm , region , region , year , slice )",
  vTradeIrAInp = "vTradeIrAInp( trade , comm , region , year , slice ) $ mvTradeIrAInp( trade , comm , region , year , slice )",
  vTradeIrAInpTot = "vTradeIrAInpTot( comm , region , year , slice ) $ mvTradeIrAInpTot( comm , region , year , slice )",
  vTradeIrAOut = "vTradeIrAOut( trade , comm , region , year , slice ) $ mvTradeIrAOut( trade , comm , region , year , slice )",
  vTradeIrAOutTot = "vTradeIrAOutTot( comm , region , year , slice ) $ mvTradeIrAOutTot( comm , region , year , slice )",
  vExportRowAccumulated = "vExportRowAccumulated( expp , comm ) $ mExpComm( expp , comm )",
  vExportRow = "vExportRow( expp , comm , region , year , slice ) $ mExportRow( expp , comm , region , year , slice )",
  vImportRowAccumulated = "vImportRowAccumulated( imp , comm ) $ mImpComm( imp , comm )",
  vImportRow = "vImportRow( imp , comm , region , year , slice ) $ mImportRow( imp , comm , region , year , slice )",
  vTradeCost = "vTradeCost( region , year ) $ mvTradeCost( region , year )",
  vTradeRowCost = "vTradeRowCost( region , year ) $ mvTradeRowCost( region , year )",
  vTradeIrCost = "vTradeIrCost( region , year ) $ mvTradeIrCost( region , year )",
  vTradeCap = "vTradeCap( trade , year ) $ mTradeSpan( trade , year )",
  vTradeInv = "vTradeInv( trade , region , year ) $ mTradeEac( trade , region , year )",
  vTradeEac = "vTradeEac( trade , region , year ) $ mTradeEac( trade , region , year )",
  vTradeNewCap = "vTradeNewCap( trade , year ) $ mTradeNew( trade , year )"
);
 .variable_set = lapply(.variable_mapping, function(x) strsplit(gsub('[ ]*[)].*$', '', gsub('^[^(]*[(][ ]*', '', x)), '[ ]*[,][ ]*')[[1]])
#########################
# variable description
#########################
.variable_description = c(
  vTechInv = "Overnight investment costs",
  vTechEac = "Annualized investment costs",
  vTechOMCost = "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)",
  vSupCost = "Supply costs",
  vEmsFuelTot = "Total fuel emissions",
  vBalance = "Net commodity balance",
  vTotalCost = "Regional annual total costs",
  vObjective = "Objective costs",
  vTaxCost = "Total tax levies (tax costs)",
  vSubsCost = "Total subsidies (for substraction from costs)",
  vAggOut = "Aggregated commodity output",
  vStorageOMCost = "Storage O&M costs",
  vTradeCost = "Total trade costs",
  vTradeRowCost = "Trade with ROW costs",
  vTradeIrCost = "Interregional trade costs",
  vTechNewCap = "New capacity",
  vTechRetiredStock = "Early retired capacity",
  vTechRetiredNewCap = "Early retired capacity",
  vTechCap = "Total capacity of the technology",
  vTechAct = "Activity level of technology",
  vTechInp = "Input level",
  vTechOut = "Output level",
  vTechAInp = "Auxiliary commodity input",
  vTechAOut = "Auxiliary commodity output",
  vSupOut = "Output of supply",
  vSupReserve = "Total supply reserve",
  vDemInp = "Input to demand",
  vOutTot = "Total commodity output (consumption is not counted)",
  vInpTot = "Total commodity input",
  vInp2Lo = "Desagregation of slices for input parent to (grand)child",
  vOut2Lo = "Desagregation of slices for output parent to (grand)child",
  vSupOutTot = "Total commodity supply",
  vTechInpTot = "Total commodity input to technologies",
  vTechOutTot = "Total commodity output from technologies",
  vStorageInpTot = "Total commodity input to storages",
  vStorageOutTot = "Total commodity output from storages",
  vStorageAInp = "Aux-commodity input to storage",
  vStorageAOut = "Aux-commodity input from storage",
  vDummyImport = "Dummy import (for debugging)",
  vDummyExport = "Dummy export (for debugging)",
  vStorageInp = "Storage input",
  vStorageOut = "Storage output",
  vStorageStore = "Storage accumulated level",
  vStorageInv = "Storage technology investments",
  vStorageEac = "Storage technology EAC investments",
  vStorageCap = "Storage capacity",
  vStorageNewCap = "Storage new capacity",
  vImport = "Total regional import (Ir + ROW)",
  vExport = "Total regional export (Ir + ROW)",
  vTradeIr = "Total physical trade flows between regions",
  vTradeIrAInp = "Trade auxilari input",
  vTradeIrAInpTot = "Trade total auxilari input",
  vTradeIrAOut = "Trade auxilari output",
  vTradeIrAOutTot = "Trade auxilari output",
  vExportRowAccumulated = "Accumulated export to ROW",
  vExportRow = "Export to ROW",
  vImportRowAccumulated = "Accumulated import from ROW",
  vImportRow = "Import from ROW",
  vTradeCap = "",
  vTradeInv = "",
  vTradeEac = "",
  vTradeNewCap = "");
#########################
# equation description
#########################
.equation_description = c(
  eqTechSng2Sng = "Technology input to output",
  eqTechGrp2Sng = "Technology group input to output",
  eqTechSng2Grp = "Technology input to group output",
  eqTechGrp2Grp = "Technology group input to group output",
  eqTechShareInpLo = "Technology lower bound on input share",
  eqTechShareInpUp = "Technology upper bound on input share",
  eqTechShareOutLo = "Technology lower bound on output share",
  eqTechShareOutUp = "Technology upper bound on output share",
  eqTechAInp = "Technology auxiliary commodity input",
  eqTechAOut = "Technology auxiliary commodity output",
  eqTechAfLo = "Technology availability factor lower bound",
  eqTechAfUp = "Technology availability factor upper bound",
  eqTechAfsLo = "Technology availability factor for sum lower bound",
  eqTechAfsUp = "Technology availability factor for sum upper bound",
  eqTechActSng = "Technology activity to commodity output",
  eqTechActGrp = "Technology activity to group output",
  eqTechAfcOutLo = "Technology commodity availability factor lower bound",
  eqTechAfcOutUp = "Technology commodity availability factor upper bound",
  eqTechAfcInpLo = "Technology commodity availability factor lower bound",
  eqTechAfcInpUp = "Technology commodity availability factor upper bound",
  eqTechCap = "Technology capacity",
  eqTechRetiredNewCap = "Stock retired eqution",
  eqTechRetiredStock = "Stock retired eqution",
  eqTechEac = "Technology Equivalent Annual Cost (EAC)",
  eqTechInv = "Technology investment costs",
  eqTechOMCost = "Technology O&M costs",
  eqSupAvaUp = "Supply availability upper bound",
  eqSupAvaLo = "Supply availability lower bound",
  eqSupTotal = "Total supply of each commodity",
  eqSupReserveUp = "Total supply vs reserve check",
  eqSupReserveLo = "Total supply vs reserve check",
  eqSupCost = "Total supply costs",
  eqDemInp = "Demand equation",
  eqAggOut = "Aggregating commodity output",
  eqEmsFuelTot = "Emissions from commodity consumption (i.e. fuels combustion)",
  eqStorageStore = "Storage equation",
  eqStorageAfLo = "Storage availability factor lower",
  eqStorageAfUp = "Storage availability factor upper",
  eqStorageClean = "Storage input less Stote",
  eqStorageAInp = "",
  eqStorageAOut = "",
  eqStorageInpUp = "",
  eqStorageInpLo = "",
  eqStorageOutUp = "",
  eqStorageOutLo = "",
  eqStorageCap = "Storage capacity",
  eqStorageInv = "Storage investments",
  eqStorageEac = "",
  eqStorageCost = "Storage total costs",
  eqImport = "Import equation",
  eqExport = "Export equation",
  eqTradeFlowUp = "Trade upper bound",
  eqTradeFlowLo = "Trade lower bound",
  eqCostTrade = "Total trade costs",
  eqCostRowTrade = "Costs of trade with the Rest of the World (ROW)",
  eqCostIrTrade = "Costs of import",
  eqExportRowUp = "Export to ROW upper bound",
  eqExportRowLo = "Export to ROW lower bound",
  eqExportRowCumulative = "Cumulative export to ROW",
  eqExportRowResUp = "Accumulated export to ROW upper bound",
  eqImportRowUp = "Import from ROW upper bound",
  eqImportRowLo = "Import of ROW lower bound",
  eqImportRowAccumulated = "Accumulated import from ROW",
  eqImportRowResUp = "Accumulated import from ROW upper bound",
  eqTradeCap = "",
  eqTradeInv = "",
  eqTradeEac = "",
  eqTradeCapFlow = "",
  eqTradeIrAInp = "Trade auxiliary commodity input",
  eqTradeIrAOut = "Trade auxiliary commodity output",
  eqTradeIrAInpTot = "Trade auxiliary commodity input",
  eqTradeIrAOutTot = "Trade auxiliary commodity output",
  eqBalUp = "PRODUCTION <= CONSUMPTION commodity balance",
  eqBalLo = "PRODUCTION >= CONSUMPTION commodity balance",
  eqBalFx = "PRODUCTION = CONSUMPTION commodity balance",
  eqBal = "Commodity balance",
  eqOutTot = "Total commodity output",
  eqInpTot = "Total commodity input",
  eqInp2Lo = "From coomodity slice to lo level",
  eqOut2Lo = "From coomodity slice to lo level",
  eqSupOutTot = "Supply total output",
  eqTechInpTot = "Technology total input",
  eqTechOutTot = "Technology total output",
  eqStorageInpTot = "Storage total input",
  eqStorageOutTot = "Storage total output",
  eqCost = "Total costs",
  eqTaxCost = "Commodity taxes",
  eqSubsCost = "Commodity subsidy",
  eqObjective = "Objective equation",
  eqLECActivity = "");
#########################
# equation set
#########################
.equation_set = list(
  eqTechSng2Sng = c("tech", "region", "comm", "commp", "year", "slice"),
  eqTechGrp2Sng = c("tech", "region", "group", "commp", "year", "slice"),
  eqTechSng2Grp = c("tech", "region", "comm", "groupp", "year", "slice"),
  eqTechGrp2Grp = c("tech", "region", "group", "groupp", "year", "slice"),
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
  eqTechRetiredNewCap = c("tech", "region", "year"),
  eqTechRetiredStock = c("tech", "region", "year"),
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
  eqLECActivity = c("tech", "region", "year"));
#########################
# parameter description
#########################
.parameter_description = c(
  ordYear = "ord year for GLPK",
  cardYear = "card year for GLPK",
  pPeriodLen = "Length of perios for milestone year",
  pSliceShare = "Share of slice",
  pAggregateFactor = "Aggregation factor of commodities",
  pTechOlife = "Operational life of technologies",
  pTechCinp2ginp = "Multiplier that transforms commodity input into group input",
  pTechGinp2use = "Multiplier that transforms group input into use",
  pTechCinp2use = "Multiplier that transforms commodity input to use",
  pTechUse2cact = "Multiplier that transforms use to commodity activity",
  pTechCact2cout = "Multiplier that transforms commodity activity to commodity output",
  pTechEmisComm = "Combustion factor for input commodity (from 0 to 1)",
  pTechAct2AInp = "Multiplier to activity to calculate aux-commodity input",
  pTechCap2AInp = "Multiplier to capacity to calculate aux-commodity input",
  pTechNCap2AInp = "Multiplier to new-capacity to calculate aux-commodity input",
  pTechCinp2AInp = "Multiplier to commodity-input to calculate aux-commodity input",
  pTechCout2AInp = "Multiplier to commodity-output to calculate aux-commodity input",
  pTechAct2AOut = "Multiplier to activity to calculate aux-commodity output",
  pTechCap2AOut = "Multiplier to capacity to calculate aux-commodity output",
  pTechNCap2AOut = "Multiplier to new capacity to calculate aux-commodity output",
  pTechCinp2AOut = "Multiplier to commodity to calculate aux-commodity output",
  pTechCout2AOut = "Multiplier to commodity-output to calculate aux-commodity input",
  pTechFixom = "Fixed Operating and maintenance (O&M) costs (per unit of capacity)",
  pTechVarom = "Variable O&M costs (per unit of acticity)",
  pTechInvcost = "Investment costs (per unit of capacity)",
  pTechEac = "Eac coefficient for investment costs (per unit of capacity)",
  pTechShareLo = "Lower bound for share of the commodity in total group input or output",
  pTechShareUp = "Upper bound for share of the commodity in total group input or output",
  pTechAfLo = "Lower bound for activity for each slice",
  pTechAfUp = "Upper bound for activity for each slice",
  pTechAfsLo = "Lower bound for activity for sum over slices",
  pTechAfsUp = "Upper bound for activity for sum over slices",
  pTechAfcLo = "Lower bound for commodity output",
  pTechAfcUp = "Upper bound for commodity output",
  pTechStock = "Technology capacity stock",
  pTechCap2act = "Technology capacity units to activity units conversion factor",
  pTechCvarom = "Commodity-specific variable costs (per unit of commodity input or output)",
  pTechAvarom = "Auxilary Commodity-specific variable costs (per unit of commodity input or output)",
  pDiscount = "Discount rate (can be region and year specific)",
  pDiscountFactor = "Discount factor (cumulative)",
  pDiscountFactorMileStone = "Discount factor (cumulative) sum for MileStone",
  pSupCost = "Costs of supply (price per unit)",
  pSupAvaUp = "Upper bound for supply",
  pSupAvaLo = "Lower bound for supply",
  pSupReserveUp = "Total supply reserve by region Up",
  pSupReserveLo = "Total supply reserve by region Lo",
  pDemand = "Exogenous demand",
  pEmissionFactor = "Emission factor",
  pDummyImportCost = "Dummy costs parameters (for debugging)",
  pDummyExportCost = "Dummy costs parameters (for debuging)",
  pTaxCostInp = "Commodity taxes for input",
  pTaxCostOut = "Commodity taxes for output",
  pTaxCostBal = "Commodity taxes for balance",
  pSubCostInp = "Commodity subsidies for input",
  pSubCostOut = "Commodity subsidies for output",
  pSubCostBal = "Commodity subsidies for balance",
  pStorageInpEff = "Storage input efficiency",
  pStorageOutEff = "Storage output efficiency",
  pStorageStgEff = "Storage time-efficiency (annual)",
  pStorageStock = "Storage capacity stock",
  pStorageOlife = "Storage operational life",
  pStorageCostStore = "Storing costs per stored amount (annual)",
  pStorageCostInp = "Storage input costs",
  pStorageCostOut = "Storage output costs",
  pStorageFixom = "Storage fixed O&M costs",
  pStorageInvcost = "Storage investment costs",
  pStorageEac = "",
  pStorageCap2stg = "Storage capacity units to activity units conversion factor",
  pStorageAfLo = "Storage capacity lower bound (minimum charge level)",
  pStorageAfUp = "Storage capacity upper bound (maximum charge level)",
  pStorageCinpUp = "Storage input upper bound",
  pStorageCinpLo = "Storage input lower bound",
  pStorageCoutUp = "Storage output upper bound",
  pStorageCoutLo = "Storage output lower bound",
  pStorageNCap2Stg = "Initial storage charging for new investment",
  pStorageCharge = "Initial storage charging for stock",
  pStorageStg2AInp = "Storage accumulated volume to auxilary input",
  pStorageStg2AOut = "Storage accumulated volume output",
  pStorageCinp2AInp = "Storage input to auxilary input coefficient",
  pStorageCinp2AOut = "Storage input to auxilary output coefficient",
  pStorageCout2AInp = "Storage output to auxilary input coefficient",
  pStorageCout2AOut = "Storage output to auxilary output coefficient",
  pStorageCap2AInp = "Storage capacity to auxilary input coefficient",
  pStorageCap2AOut = "Storage capacity to auxilary output coefficient",
  pStorageNCap2AInp = "Storage new capacity to auxilary input coefficient",
  pStorageNCap2AOut = "Storage new capacity to auxilary output coefficient",
  pTradeIrEff = "Inter-regional trade efficiency",
  pTradeIrUp = "Upper bound on trade flow",
  pTradeIrLo = "Lower bound on trade flow",
  pTradeIrCost = "Costs of trade flow",
  pTradeIrMarkup = "Markup of trade flow",
  pTradeIrCsrc2Ainp = "Auxiliary input commodity in source region",
  pTradeIrCsrc2Aout = "Auxiliary output commodity in source region",
  pTradeIrCdst2Ainp = "Auxiliary input commodity in destination region",
  pTradeIrCdst2Aout = "Auxiliary output commodity in destination region",
  pExportRowRes = "Upper bound on accumulated export to ROW",
  pExportRowUp = "Upper bound on export to ROW",
  pExportRowLo = "Lower bound on export to ROW",
  pExportRowPrice = "Export prices to ROW",
  pImportRowRes = "Upper bound on accumulated import to ROW",
  pImportRowUp = "Upper bount on import from ROW",
  pImportRowLo = "Lower bound on import from ROW",
  pImportRowPrice = "Import prices from ROW",
  pTradeStock = "",
  pTradeOlife = "",
  pTradeInvcost = "",
  pTradeEac = "",
  pTradeCap2Act = "",
  pWeather = "",
  pSupWeatherUp = "",
  pSupWeatherLo = "",
  pTechWeatherAfLo = "",
  pTechWeatherAfUp = "",
  pTechWeatherAfsLo = "",
  pTechWeatherAfsUp = "",
  pTechWeatherAfcLo = "",
  pTechWeatherAfcUp = "",
  pStorageWeatherAfLo = "",
  pStorageWeatherAfUp = "",
  pStorageWeatherCinpUp = "",
  pStorageWeatherCinpLo = "",
  pStorageWeatherCoutUp = "",
  pStorageWeatherCoutLo = "",
  pLECLoACT = "");
#########################
# parameter set
#########################
.parameter_set = list(
  ordYear = c("year"),
  cardYear = c("year"),
  pPeriodLen = c("year"),
  pSliceShare = c("slice"),
  pAggregateFactor = c("comm", "comm"),
  pTechOlife = c("tech", "region"),
  pTechCinp2ginp = c("tech", "comm", "region", "year", "slice"),
  pTechGinp2use = c("tech", "group", "region", "year", "slice"),
  pTechCinp2use = c("tech", "comm", "region", "year", "slice"),
  pTechUse2cact = c("tech", "comm", "region", "year", "slice"),
  pTechCact2cout = c("tech", "comm", "region", "year", "slice"),
  pTechEmisComm = c("tech", "comm"),
  pTechAct2AInp = c("tech", "comm", "region", "year", "slice"),
  pTechCap2AInp = c("tech", "comm", "region", "year", "slice"),
  pTechNCap2AInp = c("tech", "comm", "region", "year", "slice"),
  pTechCinp2AInp = c("tech", "comm", "comm", "region", "year", "slice"),
  pTechCout2AInp = c("tech", "comm", "comm", "region", "year", "slice"),
  pTechAct2AOut = c("tech", "comm", "region", "year", "slice"),
  pTechCap2AOut = c("tech", "comm", "region", "year", "slice"),
  pTechNCap2AOut = c("tech", "comm", "region", "year", "slice"),
  pTechCinp2AOut = c("tech", "comm", "comm", "region", "year", "slice"),
  pTechCout2AOut = c("tech", "comm", "comm", "region", "year", "slice"),
  pTechFixom = c("tech", "region", "year"),
  pTechVarom = c("tech", "region", "year", "slice"),
  pTechInvcost = c("tech", "region", "year"),
  pTechEac = c("tech", "region", "year"),
  pTechShareLo = c("tech", "comm", "region", "year", "slice"),
  pTechShareUp = c("tech", "comm", "region", "year", "slice"),
  pTechAfLo = c("tech", "region", "year", "slice"),
  pTechAfUp = c("tech", "region", "year", "slice"),
  pTechAfsLo = c("tech", "region", "year", "slice"),
  pTechAfsUp = c("tech", "region", "year", "slice"),
  pTechAfcLo = c("tech", "comm", "region", "year", "slice"),
  pTechAfcUp = c("tech", "comm", "region", "year", "slice"),
  pTechStock = c("tech", "region", "year"),
  pTechCap2act = c("tech"),
  pTechCvarom = c("tech", "comm", "region", "year", "slice"),
  pTechAvarom = c("tech", "comm", "region", "year", "slice"),
  pDiscount = c("region", "year"),
  pDiscountFactor = c("region", "year"),
  pDiscountFactorMileStone = c("region", "year"),
  pSupCost = c("sup", "comm", "region", "year", "slice"),
  pSupAvaUp = c("sup", "comm", "region", "year", "slice"),
  pSupAvaLo = c("sup", "comm", "region", "year", "slice"),
  pSupReserveUp = c("sup", "comm", "region"),
  pSupReserveLo = c("sup", "comm", "region"),
  pDemand = c("dem", "comm", "region", "year", "slice"),
  pEmissionFactor = c("comm", "comm"),
  pDummyImportCost = c("comm", "region", "year", "slice"),
  pDummyExportCost = c("comm", "region", "year", "slice"),
  pTaxCostInp = c("comm", "region", "year", "slice"),
  pTaxCostOut = c("comm", "region", "year", "slice"),
  pTaxCostBal = c("comm", "region", "year", "slice"),
  pSubCostInp = c("comm", "region", "year", "slice"),
  pSubCostOut = c("comm", "region", "year", "slice"),
  pSubCostBal = c("comm", "region", "year", "slice"),
  pStorageInpEff = c("stg", "comm", "region", "year", "slice"),
  pStorageOutEff = c("stg", "comm", "region", "year", "slice"),
  pStorageStgEff = c("stg", "comm", "region", "year", "slice"),
  pStorageStock = c("stg", "region", "year"),
  pStorageOlife = c("stg", "region"),
  pStorageCostStore = c("stg", "region", "year", "slice"),
  pStorageCostInp = c("stg", "region", "year", "slice"),
  pStorageCostOut = c("stg", "region", "year", "slice"),
  pStorageFixom = c("stg", "region", "year"),
  pStorageInvcost = c("stg", "region", "year"),
  pStorageEac = c("stg", "region", "year"),
  pStorageCap2stg = c("stg"),
  pStorageAfLo = c("stg", "region", "year", "slice"),
  pStorageAfUp = c("stg", "region", "year", "slice"),
  pStorageCinpUp = c("stg", "comm", "region", "year", "slice"),
  pStorageCinpLo = c("stg", "comm", "region", "year", "slice"),
  pStorageCoutUp = c("stg", "comm", "region", "year", "slice"),
  pStorageCoutLo = c("stg", "comm", "region", "year", "slice"),
  pStorageNCap2Stg = c("stg", "comm", "region", "year", "slice"),
  pStorageCharge = c("stg", "comm", "region", "year", "slice"),
  pStorageStg2AInp = c("stg", "comm", "region", "year", "slice"),
  pStorageStg2AOut = c("stg", "comm", "region", "year", "slice"),
  pStorageCinp2AInp = c("stg", "comm", "region", "year", "slice"),
  pStorageCinp2AOut = c("stg", "comm", "region", "year", "slice"),
  pStorageCout2AInp = c("stg", "comm", "region", "year", "slice"),
  pStorageCout2AOut = c("stg", "comm", "region", "year", "slice"),
  pStorageCap2AInp = c("stg", "comm", "region", "year", "slice"),
  pStorageCap2AOut = c("stg", "comm", "region", "year", "slice"),
  pStorageNCap2AInp = c("stg", "comm", "region", "year", "slice"),
  pStorageNCap2AOut = c("stg", "comm", "region", "year", "slice"),
  pTradeIrEff = c("trade", "region", "region", "year", "slice"),
  pTradeIrUp = c("trade", "region", "region", "year", "slice"),
  pTradeIrLo = c("trade", "region", "region", "year", "slice"),
  pTradeIrCost = c("trade", "region", "region", "year", "slice"),
  pTradeIrMarkup = c("trade", "region", "region", "year", "slice"),
  pTradeIrCsrc2Ainp = c("trade", "comm", "region", "region", "year", "slice"),
  pTradeIrCsrc2Aout = c("trade", "comm", "region", "region", "year", "slice"),
  pTradeIrCdst2Ainp = c("trade", "comm", "region", "region", "year", "slice"),
  pTradeIrCdst2Aout = c("trade", "comm", "region", "region", "year", "slice"),
  pExportRowRes = c("expp"),
  pExportRowUp = c("expp", "region", "year", "slice"),
  pExportRowLo = c("expp", "region", "year", "slice"),
  pExportRowPrice = c("expp", "region", "year", "slice"),
  pImportRowRes = c("imp"),
  pImportRowUp = c("imp", "region", "year", "slice"),
  pImportRowLo = c("imp", "region", "year", "slice"),
  pImportRowPrice = c("imp", "region", "year", "slice"),
  pTradeStock = c("trade", "year"),
  pTradeOlife = c("trade"),
  pTradeInvcost = c("trade", "region", "year"),
  pTradeEac = c("trade", "region", "year"),
  pTradeCap2Act = c("trade"),
  pWeather = c("weather", "region", "year", "slice"),
  pSupWeatherUp = c("weather", "sup"),
  pSupWeatherLo = c("weather", "sup"),
  pTechWeatherAfLo = c("weather", "tech"),
  pTechWeatherAfUp = c("weather", "tech"),
  pTechWeatherAfsLo = c("weather", "tech"),
  pTechWeatherAfsUp = c("weather", "tech"),
  pTechWeatherAfcLo = c("weather", "tech", "comm"),
  pTechWeatherAfcUp = c("weather", "tech", "comm"),
  pStorageWeatherAfLo = c("weather", "stg"),
  pStorageWeatherAfUp = c("weather", "stg"),
  pStorageWeatherCinpUp = c("weather", "stg"),
  pStorageWeatherCinpLo = c("weather", "stg"),
  pStorageWeatherCoutUp = c("weather", "stg"),
  pStorageWeatherCoutLo = c("weather", "stg"),
  pLECLoACT = c("region"));
#########################
# equation map
#########################
.equation_mapping = list(
  eqTechSng2Sng = "meqTechSng2Sng(tech, region, comm, commp, year, slice)",
  eqTechGrp2Sng = "meqTechGrp2Sng(tech, region, group, commp, year, slice)",
  eqTechSng2Grp = "meqTechSng2Grp(tech, region, comm, groupp, year, slice)",
  eqTechGrp2Grp = "meqTechGrp2Grp(tech, region, group, groupp, year, slice)",
  eqTechShareInpLo = "meqTechShareInpLo(tech, region, group, comm, year, slice)",
  eqTechShareInpUp = "meqTechShareInpUp(tech, region, group, comm, year, slice)",
  eqTechShareOutLo = "meqTechShareOutLo(tech, region, group, comm, year, slice)",
  eqTechShareOutUp = "meqTechShareOutUp(tech, region, group, comm, year, slice)",
  eqTechAInp = "mvTechAInp(tech, comm, region, year, slice)",
  eqTechAOut = "mvTechAOut(tech, comm, region, year, slice)",
  eqTechAfLo = "meqTechAfLo(tech, region, year, slice)",
  eqTechAfUp = "meqTechAfUp(tech, region, year, slice)",
  eqTechAfsLo = "meqTechAfsLo(tech, region, year, slice)",
  eqTechAfsUp = "meqTechAfsUp(tech, region, year, slice)",
  eqTechActSng = "meqTechActSng(tech, comm, region, year, slice)",
  eqTechActGrp = "meqTechActGrp(tech, group, region, year, slice)",
  eqTechAfcOutLo = "meqTechAfcOutLo(tech, region, comm, year, slice)",
  eqTechAfcOutUp = "meqTechAfcOutUp(tech, region, comm, year, slice)",
  eqTechAfcInpLo = "meqTechAfcInpLo(tech, region, comm, year, slice)",
  eqTechAfcInpUp = "meqTechAfcInpUp(tech, region, comm, year, slice)",
  eqTechCap = "mTechSpan(tech, region, year)",
  eqTechRetiredNewCap = "meqTechRetiredNewCap(tech, region, year)",
  eqTechRetiredStock = "mvTechRetiredStock(tech, region, year)",
  eqTechEac = "mTechEac(tech, region, year)",
  eqTechInv = "mTechInv(tech, region, year)  vTechInv(tech, region, year) =e=",
  eqTechOMCost = "mTechOMCost(tech, region, year)",
  eqSupAvaUp = "mSupAvaUp(sup, comm, region, year, slice)",
  eqSupAvaLo = "meqSupAvaLo(sup, comm, region, year, slice)",
  eqSupTotal = "mvSupReserve(sup, comm, region)",
  eqSupReserveUp = "mSupReserveUp(sup, comm, region)",
  eqSupReserveLo = "meqSupReserveLo(sup, comm, region)",
  eqSupCost = "mvSupCost(sup, region, year)",
  eqDemInp = "mvDemInp(comm, region, year, slice)",
  eqAggOut = "mAggOut(comm, region, year, slice)",
  eqEmsFuelTot = "mEmsFuelTot(comm, region, year, slice)",
  eqStorageStore = "mvStorageStore(stg, comm, region, year, slice)",
  eqStorageAfLo = "meqStorageAfLo(stg, comm, region, year, slice)",
  eqStorageAfUp = "meqStorageAfUp(stg, comm, region, year, slice)",
  eqStorageClean = "mvStorageStore(stg, comm, region, year, slice)",
  eqStorageAInp = "mvStorageAInp(stg, comm, region, year, slice)",
  eqStorageAOut = "mvStorageAOut(stg, comm, region, year, slice)",
  eqStorageInpUp = "meqStorageInpUp(stg, comm, region, year, slice)",
  eqStorageInpLo = "meqStorageInpLo(stg, comm, region, year, slice)",
  eqStorageOutUp = "meqStorageOutUp(stg, comm, region, year, slice)",
  eqStorageOutLo = "meqStorageOutLo(stg, comm, region, year, slice)",
  eqStorageCap = "mStorageSpan(stg, region, year)",
  eqStorageInv = "mStorageNew(stg, region, year)",
  eqStorageEac = "mStorageEac(stg, region, year)",
  eqStorageCost = "mStorageOMCost(stg, region, year)",
  eqImport = "mImport(comm, dst, year, slice)",
  eqExport = "mExport(comm, src, year, slice)",
  eqTradeFlowUp = "meqTradeFlowUp(trade, comm, src, dst, year, slice)",
  eqTradeFlowLo = "meqTradeFlowLo(trade, comm, src, dst, year, slice)",
  eqCostTrade = "mvTradeCost(region, year)",
  eqCostRowTrade = "mvTradeRowCost(region, year) vTradeRowCost(region, year) =e=",
  eqCostIrTrade = "mvTradeIrCost(region, year) vTradeIrCost(region, year) =e=",
  eqExportRowUp = "mExportRowUp(expp, comm, region, year, slice)",
  eqExportRowLo = "meqExportRowLo(expp, comm, region, year, slice)",
  eqExportRowCumulative = "mExpComm(expp, comm) vExportRowAccumulated(expp, comm) =e=",
  eqExportRowResUp = "mExportRowAccumulatedUp(expp, comm)",
  eqImportRowUp = "mImportRowUp(imp, comm, region, year, slice)",
  eqImportRowLo = "meqImportRowLo(imp, comm, region, year, slice)",
  eqImportRowAccumulated = "mImpComm(imp, comm) vImportRowAccumulated(imp, comm) =e=",
  eqImportRowResUp = "mImportRowAccumulatedUp(imp, comm) vImportRowAccumulated(imp, comm) =l= pImportRowRes(imp);",
  eqTradeCap = "mTradeSpan(trade, year)",
  eqTradeInv = "mTradeInv(trade, region, year)",
  eqTradeEac = "mTradeEac(trade, region, year)",
  eqTradeCapFlow = "meqTradeCapFlow(trade, comm, year, slice)",
  eqTradeIrAInp = "mvTradeIrAInp(trade, comm, region, year, slice)",
  eqTradeIrAOut = "mvTradeIrAOut(trade, comm, region, year, slice)",
  eqTradeIrAInpTot = "mvTradeIrAInpTot(comm, region, year, slice)",
  eqTradeIrAOutTot = "mvTradeIrAOutTot(comm, region, year, slice)",
  eqBalUp = "meqBalUp(comm, region, year, slice)",
  eqBalLo = "meqBalLo(comm, region, year, slice)",
  eqBalFx = "meqBalFx(comm, region, year, slice)",
  eqBal = "mvBalance(comm, region, year, slice)",
  eqOutTot = "mvOutTot(comm, region, year, slice)",
  eqInpTot = "mvInpTot(comm, region, year, slice)",
  eqInp2Lo = "mInp2Lo(comm, region, year, slice)",
  eqOut2Lo = "mOut2Lo(comm, region, year, slice)",
  eqSupOutTot = "mSupOutTot(comm, region, year, slice)",
  eqTechInpTot = "mTechInpTot(comm, region, year, slice)",
  eqTechOutTot = "mTechOutTot(comm, region, year, slice)",
  eqStorageInpTot = "mStorageInpTot(comm, region, year, slice)",
  eqStorageOutTot = "mStorageOutTot(comm, region, year, slice)",
  eqCost = "mvTotalCost(region, year)",
  eqTaxCost = "mTaxCost(comm, region, year)",
  eqSubsCost = "mSubCost(comm, region, year)",
  eqObjective = "",
  eqLECActivity = "meqLECActivity(tech, region, year)"
);
#########################
# set description
#########################
.set_description = c(
  weather = "weather",
  tech = "technology",
  sup = "supply",
  dem = "demand",
  stg = "storage",
  expp = "export to the rest of the world (ROW)",
  imp = "import from the rest of the world",
  trade = "trade between regions",
  group = "group of input or output commodities in technology",
  comm = "commodity",
  region = "region",
  year = "year",
  slice = "time slice",
  mSameRegion = "The same region (used in GLPK)",
  mSameSlice = "The same slice (used in GLPK)",
  mMilestoneFirst = "First period milestone",
  mMilestoneLast = "Last period milestone",
  mMilestoneNext = "Next period milestone",
  mMilestoneHasNext = "Is there next period milestone",
  mStartMilestone = "Start of the period",
  mEndMilestone = "End of the period",
  mMidMilestone = "Milestone year",
  mCommSlice = "Commodity to slice",
  mCommSliceOrParent = "",
  mTechRetirement = "Early retirement option",
  mTechUpgrade = "Upgrade technology (not implemented yet)",
  mTechInpComm = "Input commodity",
  mTechOutComm = "Output commodity",
  mTechInpGroup = "Group input",
  mTechOutGroup = "Group output",
  mTechOneComm = "Commodity without group",
  mTechGroupComm = "Mapping between commodity-groups and commodities",
  mTechAInp = "Auxiliary input",
  mTechAOut = "Auxiliary output",
  mTechNew = "Technologies available for investment",
  mTechSpan = "Availability of each technology by regions and milestone years",
  mTechSlice = "Technology to slice-level",
  mSupSlice = "Supply to slices-level",
  mSupComm = "Supplied commodities",
  mSupSpan = "Supply in regions",
  mDemComm = "Demand commodities",
  mUpComm = "Commodity balance type PRODUCTION <= CONSUMPTION",
  mLoComm = "Commodity balance type PRODUCTION >= CONSUMPTION",
  mFxComm = "Commodity balance type PRODUCTION == CONSUMPTION",
  mStorageFullYear = "Mapping of storage with joint slice",
  mStorageComm = "Mapping of storage technology and respective commodity",
  mStorageAInp = "Aux-commodity input to storage",
  mStorageAOut = "Aux-commodity output from storage",
  mStorageNew = "Storage available for investment",
  mStorageSpan = "Storage set showing if the storage may exist in the year and region",
  mStorageOMCost = "",
  mStorageEac = "",
  mSliceNext = "Next slice",
  mSliceFYearNext = "Next slice joint",
  mTradeSlice = "Trade to slice",
  mTradeComm = "Trade commodities",
  mTradeRoutes = "",
  mTradeIrAInp = "Auxiliary input commodity in source region",
  mTradeIrAOut = "Auxiliary output commodity in source region",
  mExpComm = "Export commodities",
  mImpComm = "Import commodities",
  mExpSlice = "Export to slice",
  mImpSlice = "Import to slice",
  mDiscountZero = "",
  mSliceParentChildE = "Child slice or the same",
  mSliceParentChild = "Child slice not the same",
  mTradeSpan = "",
  mTradeNew = "",
  mTradeOlifeInf = "",
  mTradeEac = "",
  mTradeCapacityVariable = "",
  mTradeInv = "",
  mAggregateFactor = "",
  mWeatherSlice = "",
  mWeatherRegion = "",
  mSupWeatherLo = "",
  mSupWeatherUp = "",
  mTechWeatherAfLo = "",
  mTechWeatherAfUp = "",
  mTechWeatherAfsLo = "",
  mTechWeatherAfsUp = "",
  mTechWeatherAfcLo = "",
  mTechWeatherAfcUp = "",
  mStorageWeatherAfLo = "",
  mStorageWeatherAfUp = "",
  mStorageWeatherCinpUp = "",
  mStorageWeatherCinpLo = "",
  mStorageWeatherCoutUp = "",
  mStorageWeatherCoutLo = "",
  mvSupCost = "",
  mvTechInp = "",
  mvSupReserve = "",
  mvTechRetiredNewCap = "",
  mvTechRetiredStock = "",
  mvTechAct = "",
  mvTechOut = "",
  mvTechAInp = "",
  mvTechAOut = "",
  mvDemInp = "",
  mvBalance = "",
  mvInpTot = "",
  mvOutTot = "",
  mvInp2Lo = "",
  mvOut2Lo = "",
  mInpSub = "For increase speed eqInpTot",
  mOutSub = "For increase speed eqOutTot",
  mvStorageAInp = "",
  mvStorageAOut = "",
  mvStorageStore = "",
  mStorageStg2AOut = "",
  mStorageCinp2AOut = "",
  mStorageCout2AOut = "",
  mStorageCap2AOut = "",
  mStorageNCap2AOut = "",
  mStorageStg2AInp = "",
  mStorageCinp2AInp = "",
  mStorageCout2AInp = "",
  mStorageCap2AInp = "",
  mStorageNCap2AInp = "",
  mvTradeIr = "",
  mTradeIrCsrc2Ainp = "",
  mTradeIrCdst2Ainp = "",
  mTradeIrCsrc2Aout = "",
  mTradeIrCdst2Aout = "",
  mvTradeCost = "",
  mvTradeRowCost = "",
  mvTradeIrCost = "",
  mvTotalCost = "",
  mTechInv = "",
  mTechInpTot = "Total technology input mapp",
  mTechOutTot = "Total technology output mapp",
  mTechEac = "",
  mTechOMCost = "",
  mSupOutTot = "",
  mEmsFuelTot = "",
  mTechEmsFuel = "",
  mDummyImport = "",
  mDummyExport = "",
  mDummyCost = "",
  mTradeIr = "",
  mvTradeIrAInp = "",
  mvTradeIrAInpTot = "",
  mvTradeIrAOut = "",
  mvTradeIrAOutTot = "",
  mImportRow = "",
  mImportRowUp = "",
  mImportRowAccumulatedUp = "",
  mExportRow = "",
  mExportRowUp = "",
  mExportRowAccumulatedUp = "",
  mExport = "",
  mImport = "",
  mStorageInpTot = "",
  mStorageOutTot = "",
  mTaxCost = "",
  mSubCost = "",
  mAggOut = "",
  mTechAfUp = "",
  mTechOlifeInf = "",
  mStorageOlifeInf = "",
  mTechAfcUp = "",
  mSupAvaUp = "",
  mSupAva = "",
  mSupReserveUp = "",
  mOut2Lo = "",
  mInp2Lo = "",
  meqTechRetiredNewCap = "",
  meqTechSng2Sng = "",
  meqTechGrp2Sng = "",
  meqTechSng2Grp = "",
  meqTechGrp2Grp = "",
  meqTechShareInpLo = "",
  meqTechShareInpUp = "",
  meqTechShareOutLo = "",
  meqTechShareOutUp = "",
  meqTechAfLo = "",
  meqTechAfUp = "",
  meqTechAfsLo = "",
  meqTechAfsUp = "",
  meqTechActSng = "",
  meqTechActGrp = "",
  meqTechAfcOutLo = "",
  meqTechAfcOutUp = "",
  meqTechAfcInpLo = "",
  meqTechAfcInpUp = "",
  meqSupAvaLo = "",
  meqSupReserveLo = "",
  meqStorageAfLo = "",
  meqStorageAfUp = "",
  meqStorageInpUp = "",
  meqStorageInpLo = "",
  meqStorageOutUp = "",
  meqStorageOutLo = "",
  meqTradeFlowUp = "",
  meqTradeFlowLo = "",
  meqExportRowLo = "",
  meqImportRowUp = "",
  meqImportRowLo = "",
  meqTradeCapFlow = "",
  meqBalLo = "",
  meqBalUp = "",
  meqBalFx = "",
  meqLECActivity = "",
  mTechAct2AInp = "",
  mTechCap2AInp = "",
  mTechNCap2AInp = "",
  mTechCinp2AInp = "",
  mTechCout2AInp = "",
  mTechAct2AOut = "",
  mTechCap2AOut = "",
  mTechNCap2AOut = "",
  mTechCinp2AOut = "",
  mTechCout2AOut = "",
  mLECRegion = "");
#########################
# set set
#########################
.set_set = list(
  mSameRegion = c("region", "region"),
  mSameSlice = c("slice", "slice"),
  mMilestoneFirst = c("year"),
  mMilestoneLast = c("year"),
  mMilestoneNext = c("year", "year"),
  mMilestoneHasNext = c("year"),
  mStartMilestone = c("year", "year"),
  mEndMilestone = c("year", "year"),
  mMidMilestone = c("year"),
  mCommSlice = c("comm", "slice"),
  mCommSliceOrParent = c("comm", "slice", "slice"),
  mTechRetirement = c("tech"),
  mTechUpgrade = c("tech", "tech"),
  mTechInpComm = c("tech", "comm"),
  mTechOutComm = c("tech", "comm"),
  mTechInpGroup = c("tech", "group"),
  mTechOutGroup = c("tech", "group"),
  mTechOneComm = c("tech", "comm"),
  mTechGroupComm = c("tech", "group", "comm"),
  mTechAInp = c("tech", "comm"),
  mTechAOut = c("tech", "comm"),
  mTechNew = c("tech", "region", "year"),
  mTechSpan = c("tech", "region", "year"),
  mTechSlice = c("tech", "slice"),
  mSupSlice = c("sup", "slice"),
  mSupComm = c("sup", "comm"),
  mSupSpan = c("sup", "region"),
  mDemComm = c("dem", "comm"),
  mUpComm = c("comm"),
  mLoComm = c("comm"),
  mFxComm = c("comm"),
  mStorageFullYear = c("stg"),
  mStorageComm = c("stg", "comm"),
  mStorageAInp = c("stg", "comm"),
  mStorageAOut = c("stg", "comm"),
  mStorageNew = c("stg", "region", "year"),
  mStorageSpan = c("stg", "region", "year"),
  mStorageOMCost = c("stg", "region", "year"),
  mStorageEac = c("stg", "region", "year"),
  mSliceNext = c("slice", "slice"),
  mSliceFYearNext = c("slice", "slice"),
  mTradeSlice = c("trade", "slice"),
  mTradeComm = c("trade", "comm"),
  mTradeRoutes = c("trade", "region", "region"),
  mTradeIrAInp = c("trade", "comm"),
  mTradeIrAOut = c("trade", "comm"),
  mExpComm = c("expp", "comm"),
  mImpComm = c("imp", "comm"),
  mExpSlice = c("expp", "slice"),
  mImpSlice = c("imp", "slice"),
  mDiscountZero = c("region"),
  mSliceParentChildE = c("slice", "slice"),
  mSliceParentChild = c("slice", "slice"),
  mTradeSpan = c("trade", "year"),
  mTradeNew = c("trade", "year"),
  mTradeOlifeInf = c("trade"),
  mTradeEac = c("trade", "region", "year"),
  mTradeCapacityVariable = c("trade"),
  mTradeInv = c("trade", "region", "year"),
  mAggregateFactor = c("comm", "comm"),
  mWeatherSlice = c("weather", "slice"),
  mWeatherRegion = c("weather", "region"),
  mSupWeatherLo = c("weather", "sup"),
  mSupWeatherUp = c("weather", "sup"),
  mTechWeatherAfLo = c("weather", "tech"),
  mTechWeatherAfUp = c("weather", "tech"),
  mTechWeatherAfsLo = c("weather", "tech"),
  mTechWeatherAfsUp = c("weather", "tech"),
  mTechWeatherAfcLo = c("weather", "tech", "comm"),
  mTechWeatherAfcUp = c("weather", "tech", "comm"),
  mStorageWeatherAfLo = c("weather", "stg"),
  mStorageWeatherAfUp = c("weather", "stg"),
  mStorageWeatherCinpUp = c("weather", "stg"),
  mStorageWeatherCinpLo = c("weather", "stg"),
  mStorageWeatherCoutUp = c("weather", "stg"),
  mStorageWeatherCoutLo = c("weather", "stg"),
  mvSupCost = c("sup", "region", "year"),
  mvTechInp = c("tech", "comm", "region", "year", "slice"),
  mvSupReserve = c("sup", "comm", "region"),
  mvTechRetiredNewCap = c("tech", "region", "year", "year"),
  mvTechRetiredStock = c("tech", "region", "year"),
  mvTechAct = c("tech", "region", "year", "slice"),
  mvTechOut = c("tech", "comm", "region", "year", "slice"),
  mvTechAInp = c("tech", "comm", "region", "year", "slice"),
  mvTechAOut = c("tech", "comm", "region", "year", "slice"),
  mvDemInp = c("comm", "region", "year", "slice"),
  mvBalance = c("comm", "region", "year", "slice"),
  mvInpTot = c("comm", "region", "year", "slice"),
  mvOutTot = c("comm", "region", "year", "slice"),
  mvInp2Lo = c("comm", "region", "year", "slice", "slice"),
  mvOut2Lo = c("comm", "region", "year", "slice", "slice"),
  mInpSub = c("comm", "region", "year", "slice"),
  mOutSub = c("comm", "region", "year", "slice"),
  mvStorageAInp = c("stg", "comm", "region", "year", "slice"),
  mvStorageAOut = c("stg", "comm", "region", "year", "slice"),
  mvStorageStore = c("stg", "comm", "region", "year", "slice"),
  mStorageStg2AOut = c("stg", "comm", "region", "year", "slice"),
  mStorageCinp2AOut = c("stg", "comm", "region", "year", "slice"),
  mStorageCout2AOut = c("stg", "comm", "region", "year", "slice"),
  mStorageCap2AOut = c("stg", "comm", "region", "year", "slice"),
  mStorageNCap2AOut = c("stg", "comm", "region", "year", "slice"),
  mStorageStg2AInp = c("stg", "comm", "region", "year", "slice"),
  mStorageCinp2AInp = c("stg", "comm", "region", "year", "slice"),
  mStorageCout2AInp = c("stg", "comm", "region", "year", "slice"),
  mStorageCap2AInp = c("stg", "comm", "region", "year", "slice"),
  mStorageNCap2AInp = c("stg", "comm", "region", "year", "slice"),
  mvTradeIr = c("trade", "comm", "region", "region", "year", "slice"),
  mTradeIrCsrc2Ainp = c("trade", "comm", "region", "region", "year", "slice"),
  mTradeIrCdst2Ainp = c("trade", "comm", "region", "region", "year", "slice"),
  mTradeIrCsrc2Aout = c("trade", "comm", "region", "region", "year", "slice"),
  mTradeIrCdst2Aout = c("trade", "comm", "region", "region", "year", "slice"),
  mvTradeCost = c("region", "year"),
  mvTradeRowCost = c("region", "year"),
  mvTradeIrCost = c("region", "year"),
  mvTotalCost = c("region", "year"),
  mTechInv = c("tech", "region", "year"),
  mTechInpTot = c("comm", "region", "year", "slice"),
  mTechOutTot = c("comm", "region", "year", "slice"),
  mTechEac = c("tech", "region", "year"),
  mTechOMCost = c("tech", "region", "year"),
  mSupOutTot = c("comm", "region", "year", "slice"),
  mEmsFuelTot = c("comm", "region", "year", "slice"),
  mTechEmsFuel = c("tech", "comm", "comm", "region", "year", "slice"),
  mDummyImport = c("comm", "region", "year", "slice"),
  mDummyExport = c("comm", "region", "year", "slice"),
  mDummyCost = c("comm", "region", "year"),
  mTradeIr = c("trade", "region", "region", "year", "slice"),
  mvTradeIrAInp = c("trade", "comm", "region", "year", "slice"),
  mvTradeIrAInpTot = c("comm", "region", "year", "slice"),
  mvTradeIrAOut = c("trade", "comm", "region", "year", "slice"),
  mvTradeIrAOutTot = c("comm", "region", "year", "slice"),
  mImportRow = c("imp", "comm", "region", "year", "slice"),
  mImportRowUp = c("imp", "comm", "region", "year", "slice"),
  mImportRowAccumulatedUp = c("imp", "comm"),
  mExportRow = c("expp", "comm", "region", "year", "slice"),
  mExportRowUp = c("expp", "comm", "region", "year", "slice"),
  mExportRowAccumulatedUp = c("expp", "comm"),
  mExport = c("comm", "region", "year", "slice"),
  mImport = c("comm", "region", "year", "slice"),
  mStorageInpTot = c("comm", "region", "year", "slice"),
  mStorageOutTot = c("comm", "region", "year", "slice"),
  mTaxCost = c("comm", "region", "year"),
  mSubCost = c("comm", "region", "year"),
  mAggOut = c("comm", "region", "year", "slice"),
  mTechAfUp = c("tech", "region", "year", "slice"),
  mTechOlifeInf = c("tech", "region"),
  mStorageOlifeInf = c("stg", "region"),
  mTechAfcUp = c("tech", "comm", "region", "year", "slice"),
  mSupAvaUp = c("sup", "comm", "region", "year", "slice"),
  mSupAva = c("sup", "comm", "region", "year", "slice"),
  mSupReserveUp = c("sup", "comm", "region"),
  mOut2Lo = c("comm", "region", "year", "slice"),
  mInp2Lo = c("comm", "region", "year", "slice"),
  meqTechRetiredNewCap = c("tech", "region", "year"),
  meqTechSng2Sng = c("tech", "region", "comm", "comm", "year", "slice"),
  meqTechGrp2Sng = c("tech", "region", "group", "comm", "year", "slice"),
  meqTechSng2Grp = c("tech", "region", "comm", "group", "year", "slice"),
  meqTechGrp2Grp = c("tech", "region", "group", "group", "year", "slice"),
  meqTechShareInpLo = c("tech", "region", "group", "comm", "year", "slice"),
  meqTechShareInpUp = c("tech", "region", "group", "comm", "year", "slice"),
  meqTechShareOutLo = c("tech", "region", "group", "comm", "year", "slice"),
  meqTechShareOutUp = c("tech", "region", "group", "comm", "year", "slice"),
  meqTechAfLo = c("tech", "region", "year", "slice"),
  meqTechAfUp = c("tech", "region", "year", "slice"),
  meqTechAfsLo = c("tech", "region", "year", "slice"),
  meqTechAfsUp = c("tech", "region", "year", "slice"),
  meqTechActSng = c("tech", "comm", "region", "year", "slice"),
  meqTechActGrp = c("tech", "group", "region", "year", "slice"),
  meqTechAfcOutLo = c("tech", "region", "comm", "year", "slice"),
  meqTechAfcOutUp = c("tech", "region", "comm", "year", "slice"),
  meqTechAfcInpLo = c("tech", "region", "comm", "year", "slice"),
  meqTechAfcInpUp = c("tech", "region", "comm", "year", "slice"),
  meqSupAvaLo = c("sup", "comm", "region", "year", "slice"),
  meqSupReserveLo = c("sup", "comm", "region"),
  meqStorageAfLo = c("stg", "comm", "region", "year", "slice"),
  meqStorageAfUp = c("stg", "comm", "region", "year", "slice"),
  meqStorageInpUp = c("stg", "comm", "region", "year", "slice"),
  meqStorageInpLo = c("stg", "comm", "region", "year", "slice"),
  meqStorageOutUp = c("stg", "comm", "region", "year", "slice"),
  meqStorageOutLo = c("stg", "comm", "region", "year", "slice"),
  meqTradeFlowUp = c("trade", "comm", "region", "region", "year", "slice"),
  meqTradeFlowLo = c("trade", "comm", "region", "region", "year", "slice"),
  meqExportRowLo = c("expp", "comm", "region", "year", "slice"),
  meqImportRowUp = c("imp", "comm", "region", "year", "slice"),
  meqImportRowLo = c("imp", "comm", "region", "year", "slice"),
  meqTradeCapFlow = c("trade", "comm", "year", "slice"),
  meqBalLo = c("comm", "region", "year", "slice"),
  meqBalUp = c("comm", "region", "year", "slice"),
  meqBalFx = c("comm", "region", "year", "slice"),
  meqLECActivity = c("tech", "region", "year"),
  mTechAct2AInp = c("tech", "comm", "region", "year", "slice"),
  mTechCap2AInp = c("tech", "comm", "region", "year", "slice"),
  mTechNCap2AInp = c("tech", "comm", "region", "year", "slice"),
  mTechCinp2AInp = c("tech", "comm", "comm", "region", "year", "slice"),
  mTechCout2AInp = c("tech", "comm", "comm", "region", "year", "slice"),
  mTechAct2AOut = c("tech", "comm", "region", "year", "slice"),
  mTechCap2AOut = c("tech", "comm", "region", "year", "slice"),
  mTechNCap2AOut = c("tech", "comm", "region", "year", "slice"),
  mTechCinp2AOut = c("tech", "comm", "comm", "region", "year", "slice"),
  mTechCout2AOut = c("tech", "comm", "comm", "region", "year", "slice"),
  mLECRegion = c("region"));
#########################
# equation_variable 
#########################
.equation_variable <- data.frame(equation = character(), variable = character(), stringsAsFactors = FALSE)
.equation_variable[1:233, ] <- NA;
.equation_variable[1, ] <- c("eqTechSng2Sng", "vTechInp")
.equation_variable[2, ] <- c("eqTechSng2Sng", "vTechOut")
.equation_variable[3, ] <- c("eqTechGrp2Sng", "vTechInp")
.equation_variable[4, ] <- c("eqTechGrp2Sng", "vTechOut")
.equation_variable[5, ] <- c("eqTechSng2Grp", "vTechInp")
.equation_variable[6, ] <- c("eqTechSng2Grp", "vTechOut")
.equation_variable[7, ] <- c("eqTechGrp2Grp", "vTechInp")
.equation_variable[8, ] <- c("eqTechGrp2Grp", "vTechOut")
.equation_variable[9, ] <- c("eqTechShareInpLo", "vTechInp")
.equation_variable[10, ] <- c("eqTechShareInpUp", "vTechInp")
.equation_variable[11, ] <- c("eqTechShareOutLo", "vTechOut")
.equation_variable[12, ] <- c("eqTechShareOutUp", "vTechOut")
.equation_variable[13, ] <- c("eqTechAInp", "vTechNewCap")
.equation_variable[14, ] <- c("eqTechAInp", "vTechCap")
.equation_variable[15, ] <- c("eqTechAInp", "vTechAct")
.equation_variable[16, ] <- c("eqTechAInp", "vTechInp")
.equation_variable[17, ] <- c("eqTechAInp", "vTechOut")
.equation_variable[18, ] <- c("eqTechAInp", "vTechAInp")
.equation_variable[19, ] <- c("eqTechAOut", "vTechNewCap")
.equation_variable[20, ] <- c("eqTechAOut", "vTechCap")
.equation_variable[21, ] <- c("eqTechAOut", "vTechAct")
.equation_variable[22, ] <- c("eqTechAOut", "vTechInp")
.equation_variable[23, ] <- c("eqTechAOut", "vTechOut")
.equation_variable[24, ] <- c("eqTechAOut", "vTechAOut")
.equation_variable[25, ] <- c("eqTechAfLo", "vTechCap")
.equation_variable[26, ] <- c("eqTechAfLo", "vTechAct")
.equation_variable[27, ] <- c("eqTechAfUp", "vTechCap")
.equation_variable[28, ] <- c("eqTechAfUp", "vTechAct")
.equation_variable[29, ] <- c("eqTechAfsLo", "vTechCap")
.equation_variable[30, ] <- c("eqTechAfsLo", "vTechAct")
.equation_variable[31, ] <- c("eqTechAfsUp", "vTechCap")
.equation_variable[32, ] <- c("eqTechAfsUp", "vTechAct")
.equation_variable[33, ] <- c("eqTechActSng", "vTechAct")
.equation_variable[34, ] <- c("eqTechActSng", "vTechOut")
.equation_variable[35, ] <- c("eqTechActGrp", "vTechAct")
.equation_variable[36, ] <- c("eqTechActGrp", "vTechOut")
.equation_variable[37, ] <- c("eqTechAfcOutLo", "vTechCap")
.equation_variable[38, ] <- c("eqTechAfcOutLo", "vTechOut")
.equation_variable[39, ] <- c("eqTechAfcOutUp", "vTechCap")
.equation_variable[40, ] <- c("eqTechAfcOutUp", "vTechOut")
.equation_variable[41, ] <- c("eqTechAfcInpLo", "vTechCap")
.equation_variable[42, ] <- c("eqTechAfcInpLo", "vTechInp")
.equation_variable[43, ] <- c("eqTechAfcInpUp", "vTechCap")
.equation_variable[44, ] <- c("eqTechAfcInpUp", "vTechInp")
.equation_variable[45, ] <- c("eqTechCap", "vTechNewCap")
.equation_variable[46, ] <- c("eqTechCap", "vTechRetiredStock")
.equation_variable[47, ] <- c("eqTechCap", "vTechRetiredNewCap")
.equation_variable[48, ] <- c("eqTechCap", "vTechCap")
.equation_variable[49, ] <- c("eqTechRetiredNewCap", "vTechNewCap")
.equation_variable[50, ] <- c("eqTechRetiredNewCap", "vTechRetiredNewCap")
.equation_variable[51, ] <- c("eqTechRetiredStock", "vTechRetiredStock")
.equation_variable[52, ] <- c("eqTechEac", "vTechEac")
.equation_variable[53, ] <- c("eqTechEac", "vTechNewCap")
.equation_variable[54, ] <- c("eqTechEac", "vTechRetiredNewCap")
.equation_variable[55, ] <- c("eqTechInv", "vTechInv")
.equation_variable[56, ] <- c("eqTechInv", "vTechNewCap")
.equation_variable[57, ] <- c("eqTechOMCost", "vTechOMCost")
.equation_variable[58, ] <- c("eqTechOMCost", "vTechCap")
.equation_variable[59, ] <- c("eqTechOMCost", "vTechAct")
.equation_variable[60, ] <- c("eqTechOMCost", "vTechInp")
.equation_variable[61, ] <- c("eqTechOMCost", "vTechOut")
.equation_variable[62, ] <- c("eqTechOMCost", "vTechAInp")
.equation_variable[63, ] <- c("eqTechOMCost", "vTechAOut")
.equation_variable[64, ] <- c("eqSupAvaUp", "vSupOut")
.equation_variable[65, ] <- c("eqSupAvaLo", "vSupOut")
.equation_variable[66, ] <- c("eqSupTotal", "vSupOut")
.equation_variable[67, ] <- c("eqSupTotal", "vSupReserve")
.equation_variable[68, ] <- c("eqSupReserveUp", "vSupReserve")
.equation_variable[69, ] <- c("eqSupReserveLo", "vSupReserve")
.equation_variable[70, ] <- c("eqSupCost", "vSupCost")
.equation_variable[71, ] <- c("eqSupCost", "vSupOut")
.equation_variable[72, ] <- c("eqDemInp", "vDemInp")
.equation_variable[73, ] <- c("eqAggOut", "vAggOut")
.equation_variable[74, ] <- c("eqAggOut", "vOutTot")
.equation_variable[75, ] <- c("eqEmsFuelTot", "vEmsFuelTot")
.equation_variable[76, ] <- c("eqEmsFuelTot", "vTechInp")
.equation_variable[77, ] <- c("eqStorageStore", "vStorageAInp")
.equation_variable[78, ] <- c("eqStorageStore", "vStorageInp")
.equation_variable[79, ] <- c("eqStorageStore", "vStorageOut")
.equation_variable[80, ] <- c("eqStorageStore", "vStorageStore")
.equation_variable[81, ] <- c("eqStorageStore", "vStorageCap")
.equation_variable[82, ] <- c("eqStorageStore", "vStorageNewCap")
.equation_variable[83, ] <- c("eqStorageAfLo", "vStorageAOut")
.equation_variable[84, ] <- c("eqStorageAfLo", "vStorageInp")
.equation_variable[85, ] <- c("eqStorageAfLo", "vStorageOut")
.equation_variable[86, ] <- c("eqStorageAfLo", "vStorageStore")
.equation_variable[87, ] <- c("eqStorageAfLo", "vStorageCap")
.equation_variable[88, ] <- c("eqStorageAfLo", "vStorageNewCap")
.equation_variable[89, ] <- c("eqStorageAfUp", "vStorageInp")
.equation_variable[90, ] <- c("eqStorageAfUp", "vStorageOut")
.equation_variable[91, ] <- c("eqStorageAfUp", "vStorageStore")
.equation_variable[92, ] <- c("eqStorageAfUp", "vStorageNewCap")
.equation_variable[93, ] <- c("eqStorageClean", "vStorageStore")
.equation_variable[94, ] <- c("eqStorageClean", "vStorageCap")
.equation_variable[95, ] <- c("eqStorageAInp", "vStorageStore")
.equation_variable[96, ] <- c("eqStorageAInp", "vStorageCap")
.equation_variable[97, ] <- c("eqStorageAOut", "vStorageOut")
.equation_variable[98, ] <- c("eqStorageAOut", "vStorageStore")
.equation_variable[99, ] <- c("eqStorageInpUp", "vStorageInp")
.equation_variable[100, ] <- c("eqStorageInpUp", "vStorageCap")
.equation_variable[101, ] <- c("eqStorageInpLo", "vStorageInp")
.equation_variable[102, ] <- c("eqStorageInpLo", "vStorageCap")
.equation_variable[103, ] <- c("eqStorageOutUp", "vStorageOut")
.equation_variable[104, ] <- c("eqStorageOutUp", "vStorageCap")
.equation_variable[105, ] <- c("eqStorageOutLo", "vStorageOut")
.equation_variable[106, ] <- c("eqStorageOutLo", "vStorageCap")
.equation_variable[107, ] <- c("eqStorageCap", "vStorageCap")
.equation_variable[108, ] <- c("eqStorageCap", "vStorageNewCap")
.equation_variable[109, ] <- c("eqStorageInv", "vStorageInv")
.equation_variable[110, ] <- c("eqStorageInv", "vStorageNewCap")
.equation_variable[111, ] <- c("eqStorageEac", "vStorageEac")
.equation_variable[112, ] <- c("eqStorageEac", "vStorageNewCap")
.equation_variable[113, ] <- c("eqStorageCost", "vStorageOMCost")
.equation_variable[114, ] <- c("eqStorageCost", "vStorageInp")
.equation_variable[115, ] <- c("eqStorageCost", "vStorageOut")
.equation_variable[116, ] <- c("eqStorageCost", "vStorageStore")
.equation_variable[117, ] <- c("eqStorageCost", "vStorageCap")
.equation_variable[118, ] <- c("eqImport", "vImport")
.equation_variable[119, ] <- c("eqImport", "vTradeIr")
.equation_variable[120, ] <- c("eqImport", "vImportRow")
.equation_variable[121, ] <- c("eqExport", "vExport")
.equation_variable[122, ] <- c("eqExport", "vTradeIr")
.equation_variable[123, ] <- c("eqExport", "vExportRow")
.equation_variable[124, ] <- c("eqTradeFlowUp", "vTradeIr")
.equation_variable[125, ] <- c("eqTradeFlowLo", "vTradeIr")
.equation_variable[126, ] <- c("eqCostTrade", "vTradeCost")
.equation_variable[127, ] <- c("eqCostTrade", "vTradeRowCost")
.equation_variable[128, ] <- c("eqCostTrade", "vTradeIrCost")
.equation_variable[129, ] <- c("eqCostRowTrade", "vTradeRowCost")
.equation_variable[130, ] <- c("eqCostRowTrade", "vExportRow")
.equation_variable[131, ] <- c("eqCostRowTrade", "vImportRow")
.equation_variable[132, ] <- c("eqCostIrTrade", "vTradeIrCost")
.equation_variable[133, ] <- c("eqCostIrTrade", "vTradeIr")
.equation_variable[134, ] <- c("eqCostIrTrade", "vTradeEac")
.equation_variable[135, ] <- c("eqExportRowUp", "vExportRow")
.equation_variable[136, ] <- c("eqExportRowLo", "vExportRow")
.equation_variable[137, ] <- c("eqExportRowCumulative", "vExportRowAccumulated")
.equation_variable[138, ] <- c("eqExportRowCumulative", "vExportRow")
.equation_variable[139, ] <- c("eqExportRowResUp", "vExportRowAccumulated")
.equation_variable[140, ] <- c("eqImportRowUp", "vImportRow")
.equation_variable[141, ] <- c("eqImportRowLo", "vImportRow")
.equation_variable[142, ] <- c("eqImportRowAccumulated", "vImportRowAccumulated")
.equation_variable[143, ] <- c("eqImportRowAccumulated", "vImportRow")
.equation_variable[144, ] <- c("eqImportRowResUp", "vImportRowAccumulated")
.equation_variable[145, ] <- c("eqTradeCap", "vTradeIr")
.equation_variable[146, ] <- c("eqTradeCap", "vTradeCap")
.equation_variable[147, ] <- c("eqTradeInv", "vTradeCap")
.equation_variable[148, ] <- c("eqTradeInv", "vTradeNewCap")
.equation_variable[149, ] <- c("eqTradeEac", "vTradeInv")
.equation_variable[150, ] <- c("eqTradeEac", "vTradeNewCap")
.equation_variable[151, ] <- c("eqTradeCapFlow", "vTradeEac")
.equation_variable[152, ] <- c("eqTradeCapFlow", "vTradeNewCap")
.equation_variable[153, ] <- c("eqTradeIrAInp", "vTradeIr")
.equation_variable[154, ] <- c("eqTradeIrAInp", "vTradeIrAInp")
.equation_variable[155, ] <- c("eqTradeIrAOut", "vTradeIr")
.equation_variable[156, ] <- c("eqTradeIrAOut", "vTradeIrAOut")
.equation_variable[157, ] <- c("eqTradeIrAInpTot", "vTradeIrAInp")
.equation_variable[158, ] <- c("eqTradeIrAInpTot", "vTradeIrAInpTot")
.equation_variable[159, ] <- c("eqTradeIrAOutTot", "vTradeIrAOut")
.equation_variable[160, ] <- c("eqTradeIrAOutTot", "vTradeIrAOutTot")
.equation_variable[161, ] <- c("eqBalUp", "vBalance")
.equation_variable[162, ] <- c("eqBalLo", "vBalance")
.equation_variable[163, ] <- c("eqBalFx", "vBalance")
.equation_variable[164, ] <- c("eqBal", "vBalance")
.equation_variable[165, ] <- c("eqBal", "vOutTot")
.equation_variable[166, ] <- c("eqBal", "vInpTot")
.equation_variable[167, ] <- c("eqOutTot", "vEmsFuelTot")
.equation_variable[168, ] <- c("eqOutTot", "vAggOut")
.equation_variable[169, ] <- c("eqOutTot", "vOutTot")
.equation_variable[170, ] <- c("eqOutTot", "vOut2Lo")
.equation_variable[171, ] <- c("eqOutTot", "vSupOutTot")
.equation_variable[172, ] <- c("eqOutTot", "vTechOutTot")
.equation_variable[173, ] <- c("eqOutTot", "vStorageOutTot")
.equation_variable[174, ] <- c("eqOutTot", "vDummyImport")
.equation_variable[175, ] <- c("eqOutTot", "vImport")
.equation_variable[176, ] <- c("eqOutTot", "vTradeIrAOutTot")
.equation_variable[177, ] <- c("eqInpTot", "vEmsFuelTot")
.equation_variable[178, ] <- c("eqInpTot", "vAggOut")
.equation_variable[179, ] <- c("eqInpTot", "vOut2Lo")
.equation_variable[180, ] <- c("eqInpTot", "vSupOutTot")
.equation_variable[181, ] <- c("eqInpTot", "vTechOutTot")
.equation_variable[182, ] <- c("eqInpTot", "vStorageOutTot")
.equation_variable[183, ] <- c("eqInpTot", "vImport")
.equation_variable[184, ] <- c("eqInpTot", "vTradeIrAOutTot")
.equation_variable[185, ] <- c("eqInp2Lo", "vDemInp")
.equation_variable[186, ] <- c("eqInp2Lo", "vInpTot")
.equation_variable[187, ] <- c("eqInp2Lo", "vInp2Lo")
.equation_variable[188, ] <- c("eqInp2Lo", "vTechInpTot")
.equation_variable[189, ] <- c("eqInp2Lo", "vStorageInpTot")
.equation_variable[190, ] <- c("eqInp2Lo", "vDummyExport")
.equation_variable[191, ] <- c("eqInp2Lo", "vExport")
.equation_variable[192, ] <- c("eqInp2Lo", "vTradeIrAInpTot")
.equation_variable[193, ] <- c("eqOut2Lo", "vInp2Lo")
.equation_variable[194, ] <- c("eqOut2Lo", "vTechInpTot")
.equation_variable[195, ] <- c("eqOut2Lo", "vStorageInpTot")
.equation_variable[196, ] <- c("eqOut2Lo", "vExport")
.equation_variable[197, ] <- c("eqOut2Lo", "vTradeIrAInpTot")
.equation_variable[198, ] <- c("eqSupOutTot", "vSupOut")
.equation_variable[199, ] <- c("eqSupOutTot", "vSupOutTot")
.equation_variable[200, ] <- c("eqTechInpTot", "vTechInp")
.equation_variable[201, ] <- c("eqTechInpTot", "vTechAInp")
.equation_variable[202, ] <- c("eqTechInpTot", "vTechInpTot")
.equation_variable[203, ] <- c("eqTechOutTot", "vTechOut")
.equation_variable[204, ] <- c("eqTechOutTot", "vTechAOut")
.equation_variable[205, ] <- c("eqTechOutTot", "vTechOutTot")
.equation_variable[206, ] <- c("eqStorageInpTot", "vStorageInpTot")
.equation_variable[207, ] <- c("eqStorageInpTot", "vStorageAInp")
.equation_variable[208, ] <- c("eqStorageInpTot", "vStorageInp")
.equation_variable[209, ] <- c("eqStorageOutTot", "vStorageOutTot")
.equation_variable[210, ] <- c("eqStorageOutTot", "vStorageAOut")
.equation_variable[211, ] <- c("eqStorageOutTot", "vStorageOut")
.equation_variable[212, ] <- c("eqCost", "vTechEac")
.equation_variable[213, ] <- c("eqCost", "vTechOMCost")
.equation_variable[214, ] <- c("eqCost", "vSupCost")
.equation_variable[215, ] <- c("eqCost", "vTotalCost")
.equation_variable[216, ] <- c("eqCost", "vTaxCost")
.equation_variable[217, ] <- c("eqCost", "vSubsCost")
.equation_variable[218, ] <- c("eqCost", "vStorageOMCost")
.equation_variable[219, ] <- c("eqCost", "vTradeCost")
.equation_variable[220, ] <- c("eqCost", "vDummyImport")
.equation_variable[221, ] <- c("eqCost", "vDummyExport")
.equation_variable[222, ] <- c("eqCost", "vStorageEac")
.equation_variable[223, ] <- c("eqTaxCost", "vBalance")
.equation_variable[224, ] <- c("eqTaxCost", "vTaxCost")
.equation_variable[225, ] <- c("eqTaxCost", "vOutTot")
.equation_variable[226, ] <- c("eqTaxCost", "vInpTot")
.equation_variable[227, ] <- c("eqSubsCost", "vBalance")
.equation_variable[228, ] <- c("eqSubsCost", "vSubsCost")
.equation_variable[229, ] <- c("eqSubsCost", "vOutTot")
.equation_variable[230, ] <- c("eqSubsCost", "vInpTot")
.equation_variable[231, ] <- c("eqObjective", "vTotalCost")
.equation_variable[232, ] <- c("eqObjective", "vObjective")
.equation_variable[233, ] <- c("eqLECActivity", "vTechAct")
getVariablesSet <- function() energyRt:::.variable_set
getVariablesDescription <- function() energyRt:::.variable_description
getVariablesMapping <- function() energyRt:::.variable_mapping
getEquationMapping <- function() energyRt:::.equation_mapping
getEquationsSet <- function() energyRt:::.equation_set
getEquationsDescription <- function() energyRt:::.equation_description
getEquationsVariables <- function() energyRt:::.equation_variable
