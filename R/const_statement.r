.vrb_map = list(
    vTechUse = c("tech", "region", "year", "slice"), 
    vTechNewCap = c("tech", "region", "year"), 
    vTechRetiredCap = c("tech", "region", "year", "year"), 
    vTechCap = c("tech", "region", "year"), 
    vTechAct = c("tech", "region", "year", "slice"), 
    vTechInp = c("tech", "comm", "region", "year", "slice"), 
    vTechOut = c("tech", "comm", "region", "year", "slice"), 
    vTechAInp = c("tech", "comm", "region", "year", "slice"), 
    vTechAOut = c("tech", "comm", "region", "year", "slice"), 
    vTechInv = c("tech", "region", "year"), 
    vTechEac = c("tech", "region", "year"), 
    vTechSalv = c("tech", "region"), 
    vTechOMCost = c("tech", "region", "year"), 
    vSupOut = c("sup", "comm", "region", "year", "slice"), 
    vSupReserve = c("sup", "comm", "region"), 
    vSupCost = c("sup", "region", "year"), 
    vDemInp = c("comm", "region", "year", "slice"), 
    vEmsFuelTot = c("comm", "region", "year", "slice"), 
    vTechEmsFuel = c("tech", "comm", "region", "year", "slice"), 
    vBalance = c("comm", "region", "year", "slice"), 
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
    vCost = c("region", "year"), 
    vDummyImport = c("comm", "region", "year", "slice"), 
    vDummyExport = c("comm", "region", "year", "slice"), 
    vDummyCost = c("comm", "region", "year"), 
    vTaxCost = c("comm", "region", "year"), 
    vSubsCost = c("comm", "region", "year"), 
    vAggOut = c("comm", "region", "year", "slice"), 
    vStorageInp = c("stg", "comm", "region", "year", "slice"), 
    vStorageOut = c("stg", "comm", "region", "year", "slice"), 
    vStorageStore = c("stg", "comm", "region", "year", "slice"), 
    vStorageInv = c("stg", "region", "year"), 
    vStorageCap = c("stg", "region", "year"), 
    vStorageNewCap = c("stg", "region", "year"), 
    vStorageSalv = c("stg", "region"), 
    vStorageCost = c("stg", "region", "year"), 
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
    vTradeCost = c("region", "year"), 
    vTradeRowCost = c("region", "year"), 
    vTradeIrCost = c("region", "year")
);
.vrb_mapping = list(
    vTechUse = "vTechUse( tech , region , year , slice ) $ ( mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechNewCap = "vTechNewCap( tech , region , year ) $ mTechNew( tech , region , year )",
  vTechRetiredCap = "vTechRetiredCap( tech , region , year , year ) $ mTechSpan( tech , region , year )",
  vTechCap = "vTechCap( tech , region , year ) $ mTechSpan( tech , region , year )",
  vTechAct = "vTechAct( tech , region , year , slice ) $ ( mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechInp = "vTechInp( tech , comm , region , year , slice ) $ ( mTechInpComm( tech , comm ) and mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechOut = "vTechOut( tech , comm , region , year , slice ) $ ( mTechOutComm( tech , comm ) and mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechAInp = "vTechAInp( tech , comm , region , year , slice ) $ ( mTechAInp( tech , comm ) and mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechAOut = "vTechAOut( tech , comm , region , year , slice ) $ ( mTechAOut( tech , comm ) and mTechSpan( tech , region , year ) and mTechSlice( tech , slice ) )",
  vTechInv = "vTechInv( tech , region , year ) $ mTechNew( tech , region , year )",
  vTechEac = "vTechEac( tech , region , year ) $ mTechSpan( tech , region , year )",
  vTechSalv = "vTechSalv( tech , region ) $ ( sum( year $ mTechNew( tech , region , year_cns ) , 1 ) <> 0 )",
  vTechOMCost = "vTechOMCost( tech , region , year ) $ mTechSpan( tech , region , year )",
  vSupOut = "vSupOut( sup , comm , region , year , slice ) $ mSupAva( sup , comm , region , year , slice )",
  vSupReserve = "vSupReserve( sup , comm , region ) $ ( mSupComm( sup , comm ) and mSupSpan( sup , region ) )",
  vSupCost = "vSupCost( sup , region , year ) $ mSupSpan( sup , region )",
  vDemInp = "vDemInp( comm , region , year , slice ) $ ( mMidMilestone( year ) and mDemInp( comm , slice ) )",
  vEmsFuelTot = "vEmsFuelTot( comm , region , year , slice ) $ mEmsFuelTot( comm , region , year , slice )",
  vTechEmsFuel = "vTechEmsFuel( tech , comm , region , year , slice ) $ mTechEmsFuel( tech , comm , region , year , slice )",
  vBalance = "vBalance( comm , region , year , slice ) $ ( mMidMilestone( year ) and mCommSlice( comm , slice ) )",
  vOutTot = "vOutTot( comm , region , year , slice ) $ ( mMidMilestone( year ) and mCommSlice( comm , slice ) )",
  vInpTot = "vInpTot( comm , region , year , slice ) $ ( mMidMilestone( year ) and mCommSlice( comm , slice ) )",
  vInp2Lo = "vInp2Lo( comm , region , year , slice , slice ) $ mInp2Lo( comm , region , year , slice )",
  vOut2Lo = "vOut2Lo( comm , region , year , slice , slice ) $ mOut2Lo( comm , region , year , slice )",
  vSupOutTot = "vSupOutTot( comm , region , year , slice ) $ mSupOutTot( comm , region , slice )",
  vTechInpTot = "vTechInpTot( comm , region , year , slice ) $ mTechInpTot( comm , region , year , slice )",
  vTechOutTot = "vTechOutTot( comm , region , year , slice ) $ mTechOutTot( comm , region , year , slice )",
  vStorageInpTot = "vStorageInpTot( comm , region , year , slice ) $ mStorageInpTot( comm , region , year , slice )",
  vStorageOutTot = "vStorageOutTot( comm , region , year , slice ) $ mStorageOutTot( comm , region , year , slice )",
  vStorageAInp = "vStorageAInp( stg , comm , region , year , slice ) $ ( mStorageAInp( stg , comm ) and mStorageSlice( stg , slice ) and mStorageSpan( stg , region , year ) )",
  vStorageAOut = "vStorageAOut( stg , comm , region , year , slice ) $ ( mStorageAOut( stg , comm ) and mStorageSlice( stg , slice ) and mStorageSpan( stg , region , year ) )",
  vCost = "vCost( region , year ) $ mMidMilestone( year )",
  vDummyImport = "vDummyImport( comm , region , year , slice ) $ mDummyImport( comm , region , year , slice )",
  vDummyExport = "vDummyExport( comm , region , year , slice ) $ mDummyExport( comm , region , year , slice )",
  vDummyCost = "vDummyCost( comm , region , year ) $ mDummyCost( comm , region , year )",
  vTaxCost = "vTaxCost( comm , region , year ) $ mTaxCost( comm , region , year )",
  vSubsCost = "vSubsCost( comm , region , year ) $ mSubsCost( comm , region , year )",
  vAggOut = "vAggOut( comm , region , year , slice ) $ mAggOut( comm , region , year , slice )",
  vStorageInp = "vStorageInp( stg , comm , region , year , slice ) $ ( mStorageSlice( stg , slice ) and mStorageSpan( stg , region , year ) and mStorageComm( stg , comm ) )",
  vStorageOut = "vStorageOut( stg , comm , region , year , slice ) $ ( mStorageSlice( stg , slice ) and mStorageSpan( stg , region , year ) and mStorageComm( stg , comm ) )",
  vStorageStore = "vStorageStore( stg , comm , region , year , slice ) $ ( mStorageSlice( stg , slice ) and mStorageSpan( stg , region , year ) and mStorageComm( stg , comm ) )",
  vStorageInv = "vStorageInv( stg , region , year ) $ mStorageNew( stg , region , year )",
  vStorageCap = "vStorageCap( stg , region , year ) $ mStorageSpan( stg , region , year )",
  vStorageNewCap = "vStorageNewCap( stg , region , year ) $ mStorageNew( stg , region , year )",
  vStorageSalv = "vStorageSalv( stg , region ) $ ( sum( year $ mStorageSpan( stg , region , year_cns ) , 1 ) <> 0 )",
  vStorageCost = "vStorageCost( stg , region , year ) $ mStorageSpan( stg , region , year )",
  vImport = "vImport( comm , region , year , slice ) $ mImport( comm , region , year , slice )",
  vExport = "vExport( comm , region , year , slice ) $ mExport( comm , region , year , slice )",
  vTradeIr = "vTradeIr( trade , comm , region , region , year , slice ) $ ( mTradeIr( trade , region , region , year , slice ) and mTradeComm( trade , comm ) )",
  vTradeIrAInp = "vTradeIrAInp( trade , comm , region , year , slice ) $ mTradeIrAInp2( trade , comm , region , year , slice )",
  vTradeIrAInpTot = "vTradeIrAInpTot( comm , region , year , slice ) $ mTradeIrAInpTot( comm , region , year , slice )",
  vTradeIrAOut = "vTradeIrAOut( trade , comm , region , year , slice ) $ mTradeIrAOut2( trade , comm , region , year , slice )",
  vTradeIrAOutTot = "vTradeIrAOutTot( comm , region , year , slice ) $ mTradeIrAOutTot( comm , region , year , slice )",
  vExportRowAccumulated = "vExportRowAccumulated( expp , comm ) $ mExpComm( expp , comm )",
  vExportRow = "vExportRow( expp , comm , region , year , slice ) $ mExportRow( expp , comm , region , year , slice )",
  vImportRowAccumulated = "vImportRowAccumulated( imp , comm ) $ mImpComm( imp , comm )",
  vImportRow = "vImportRow( imp , comm , region , year , slice ) $ mImportRow( imp , comm , region , year , slice )",
  vTradeCost = "vTradeCost( region , year ) $ mMidMilestone( year )",
  vTradeRowCost = "vTradeRowCost( region , year ) $ mMidMilestone( year )",
  vTradeIrCost = "vTradeIrCost( region , year ) $ mMidMilestone( year )"
);