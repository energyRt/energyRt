printf "value\n1.00\n" > "pFinish.csv";
set tech;
set sup;
set dem;
set stg;
set expp;
set imp;
set trade;
set group;
set comm;
set region;
set year;
set slice;
set weather;
set FORIF;



set mSameRegion dimen 2;
set mSameSlice dimen 2;
set mMilestoneFirst dimen 1;
set mMilestoneLast dimen 1;
set mMilestoneNext dimen 2;
set mMilestoneHasNext dimen 1;
set mStartMilestone dimen 2;
set mEndMilestone dimen 2;
set mMidMilestone dimen 1;
set mCommSlice dimen 2;
set mTechRetirement dimen 1;
set mTechUpgrade dimen 2;
set mTechInpComm dimen 2;
set mTechOutComm dimen 2;
set mTechInpGroup dimen 2;
set mTechOutGroup dimen 2;
set mTechOneComm dimen 2;
set mTechGroupComm dimen 3;
set mTechAInp dimen 2;
set mTechAOut dimen 2;
set mTechNew dimen 3;
set mTechSpan dimen 3;
set mTechSalv dimen 2;
set mTechSlice dimen 2;
set mSupSlice dimen 2;
set mSupComm dimen 2;
set mSupSpan dimen 2;
set mSupWeatherLo dimen 2;
set mSupWeatherUp dimen 2;
set mWeatherSlice dimen 2;
set mWeatherRegion dimen 2;
set mDemComm dimen 2;
set mUpComm dimen 1;
set mLoComm dimen 1;
set mFxComm dimen 1;
set mStorageSlice dimen 2;
set mStorageComm dimen 2;
set mStorageAInp dimen 2;
set mStorageAOut dimen 2;
set mStorageNew dimen 3;
set mStorageSpan dimen 3;
set mSliceNext dimen 2;
set mTradeSlice dimen 2;
set mTradeComm dimen 2;
set mTradeSrc dimen 2;
set mTradeDst dimen 2;
set mTradeIrAInp dimen 2;
set mTradeIrAOut dimen 2;
set mTradeIrCdstAInp dimen 2;
set mTradeIrCdstAOut dimen 2;
set mExpComm dimen 2;
set mImpComm dimen 2;
set mExpSlice dimen 2;
set mImpSlice dimen 2;
set mDiscountZero dimen 1;
set mAllSliceParentChildAndSame dimen 2;
set mAllSliceParentChild dimen 2;
set mTechWeatherAf dimen 2;
set mTechWeatherAfs dimen 2;
set mTechWeatherAfc dimen 3;
set mStorageWeatherAf dimen 2;
set mStorageWeatherCinp dimen 2;
set mStorageWeatherCout dimen 2;
set mTradeSpan dimen 4;
set mTradeNew dimen 4;
set mTradeOlifeInf dimen 3;
set mTradeSalv dimen 3;
set mTradeCapacityVariable dimen 1;
set mTechInpTot dimen 4;
set mTechOutTot dimen 4;
set mSupOutTot dimen 3;
set mDemInp dimen 2;
set mEmsFuelTot dimen 4;
set mTechEmsFuel dimen 5;
set mDummyImport dimen 4;
set mDummyExport dimen 4;
set mDummyCost dimen 3;
set mTradeIr dimen 5;
set mTradeIrUp dimen 5;
set mTradeIrAInp2 dimen 5;
set mTradeIrAInpTot dimen 4;
set mTradeIrAOut2 dimen 5;
set mTradeIrAOutTot dimen 4;
set mImportRow dimen 5;
set mImportRowUp dimen 5;
set mImportRowAccumulatedUp dimen 2;
set mExportRow dimen 5;
set mExportRowUp dimen 5;
set mExportRowAccumulatedUp dimen 2;
set mExport dimen 4;
set mImport dimen 4;
set mStorageInpTot dimen 4;
set mStorageOutTot dimen 4;
set mTaxCost dimen 3;
set mSubsCost dimen 3;
set mAggOut dimen 4;
set mTechAfUp dimen 4;
set mTechOlifeInf dimen 2;
set mStorageOlifeInf dimen 2;
set mTechAfcUp dimen 5;
set mSupAvaUp dimen 5;
set mSupAva dimen 5;
set mSupReserveUp dimen 3;
set mOut2Lo dimen 4;
set mInp2Lo dimen 4;
set mLECRegion dimen 1;




param ordYear{year};
param cardYear{year};
param pPeriodLen{year};
param pSliceShare{slice};
param pAggregateFactor{comm, comm};
param pTechOlife{tech, region};
param pTechCinp2ginp{tech, comm, region, year, slice};
param pTechGinp2use{tech, group, region, year, slice};
param pTechCinp2use{tech, comm, region, year, slice};
param pTechUse2cact{tech, comm, region, year, slice};
param pTechCact2cout{tech, comm, region, year, slice};
param pTechEmisComm{tech, comm};
param pTechUse2AInp{tech, comm, region, year, slice};
param pTechAct2AInp{tech, comm, region, year, slice};
param pTechCap2AInp{tech, comm, region, year, slice};
param pTechNCap2AInp{tech, comm, region, year, slice};
param pTechCinp2AInp{tech, comm, comm, region, year, slice};
param pTechCout2AInp{tech, comm, comm, region, year, slice};
param pTechUse2AOut{tech, comm, region, year, slice};
param pTechAct2AOut{tech, comm, region, year, slice};
param pTechCap2AOut{tech, comm, region, year, slice};
param pTechNCap2AOut{tech, comm, region, year, slice};
param pTechCinp2AOut{tech, comm, comm, region, year, slice};
param pTechCout2AOut{tech, comm, comm, region, year, slice};
param pTechFixom{tech, region, year};
param pTechVarom{tech, region, year, slice};
param pTechInvcost{tech, region, year};
param pTechSalv{tech, region, year};
param pTechShareLo{tech, comm, region, year, slice};
param pTechShareUp{tech, comm, region, year, slice};
param pTechAfLo{tech, region, year, slice};
param pTechAfUp{tech, region, year, slice};
param pTechAfsLo{tech, region, year, slice};
param pTechAfsUp{tech, region, year, slice};
param pTechAfcLo{tech, comm, region, year, slice};
param pTechAfcUp{tech, comm, region, year, slice};
param pTechStock{tech, region, year};
param pTechCap2act{tech};
param pTechCvarom{tech, comm, region, year, slice};
param pTechAvarom{tech, comm, region, year, slice};
param pDiscount{region, year};
param pDiscountFactor{region, year};
param pSupCost{sup, comm, region, year, slice};
param pSupAvaUp{sup, comm, region, year, slice};
param pSupAvaLo{sup, comm, region, year, slice};
param pSupReserveUp{sup, comm, region};
param pSupReserveLo{sup, comm, region};
param pDemand{dem, comm, region, year, slice};
param pEmissionFactor{comm, comm};
param pDummyImportCost{comm, region, year, slice};
param pDummyExportCost{comm, region, year, slice};
param pTaxCost{comm, region, year, slice};
param pSubsCost{comm, region, year, slice};
param pWeather{weather, region, year, slice};
param pSupWeatherLo{sup, weather};
param pSupWeatherUp{sup, weather};
param pTechWeatherAfLo{tech, weather};
param pTechWeatherAfUp{tech, weather};
param pTechWeatherAfsLo{tech, weather};
param pTechWeatherAfsUp{tech, weather};
param pTechWeatherAfcLo{tech, weather, comm};
param pTechWeatherAfcUp{tech, weather, comm};
param pStorageWeatherAfUp{stg, weather};
param pStorageWeatherAfLo{stg, weather};
param pStorageWeatherCinpUp{stg, weather};
param pStorageWeatherCinpLo{stg, weather};
param pStorageWeatherCoutUp{stg, weather};
param pStorageWeatherCoutLo{stg, weather};
param pStorageInpEff{stg, comm, region, year, slice};
param pStorageOutEff{stg, comm, region, year, slice};
param pStorageStgEff{stg, comm, region, year, slice};
param pStorageStock{stg, region, year};
param pStorageOlife{stg, region};
param pStorageCostStore{stg, region, year, slice};
param pStorageCostInp{stg, region, year, slice};
param pStorageCostOut{stg, region, year, slice};
param pStorageFixom{stg, region, year};
param pStorageInvcost{stg, region, year};
param pStorageCap2stg{stg};
param pStorageAfLo{stg, region, year, slice};
param pStorageAfUp{stg, region, year, slice};
param pStorageCinpUp{stg, comm, region, year, slice};
param pStorageCinpLo{stg, comm, region, year, slice};
param pStorageCoutUp{stg, comm, region, year, slice};
param pStorageCoutLo{stg, comm, region, year, slice};
param pStorageStg2AInp{stg, comm, region, year, slice};
param pStorageStg2AOut{stg, comm, region, year, slice};
param pStorageInp2AInp{stg, comm, region, year, slice};
param pStorageInp2AOut{stg, comm, region, year, slice};
param pStorageOut2AInp{stg, comm, region, year, slice};
param pStorageOut2AOut{stg, comm, region, year, slice};
param pStorageCap2AInp{stg, comm, region, year, slice};
param pStorageCap2AOut{stg, comm, region, year, slice};
param pStorageNCap2AInp{stg, comm, region, year, slice};
param pStorageNCap2AOut{stg, comm, region, year, slice};
param pTradeIrEff{trade, region, region, year, slice};
param pTradeIrUp{trade, region, region, year, slice};
param pTradeIrLo{trade, region, region, year, slice};
param pTradeIrCost{trade, region, region, year, slice};
param pTradeIrMarkup{trade, region, region, year, slice};
param pTradeIrCsrc2Ainp{trade, comm, region, region, year, slice};
param pTradeIrCsrc2Aout{trade, comm, region, region, year, slice};
param pTradeIrCdst2Ainp{trade, comm, region, region, year, slice};
param pTradeIrCdst2Aout{trade, comm, region, region, year, slice};
param pExportRowRes{expp};
param pExportRowUp{expp, region, year, slice};
param pExportRowLo{expp, region, year, slice};
param pExportRowPrice{expp, region, year, slice};
param pImportRowRes{imp};
param pImportRowUp{imp, region, year, slice};
param pImportRowLo{imp, region, year, slice};
param pImportRowPrice{imp, region, year, slice};
param pTradeStock{trade, region, region, year};
param pTradeOlife{trade, region, region};
param pTradeInvcost{trade, region, region, year};
param pTradeSalv{trade, region, region, year};
param pTradeCap2Act{trade};
param pLECLoACT{region};
param ORD{year};



var vTechInv{tech, region, year};
var vTechEac{tech, region, year};
var vTechSalv{tech, region};
var vTechOMCost{tech, region, year};
var vSupCost{sup, region, year};
var vEmsFuelTot{comm, region, year, slice};
var vTechEmsFuel{tech, comm, region, year, slice};
var vBalance{comm, region, year, slice};
var vCost{region, year};
var vObjective;
var vTaxCost{comm, region, year};
var vSubsCost{comm, region, year};
var vAggOut{comm, region, year, slice};
var vStorageSalv{stg, region};
var vStorageOMCost{stg, region, year};
var vTradeCost{region, year};
var vTradeRowCost{region, year};
var vTradeIrCost{region, year};
var vTradeSalv{trade, region, region};




var vTechUse{tech, region, year, slice} >= 0;
var vTechNewCap{tech, region, year} >= 0;
var vTechRetiredCap{tech, region, year, year} >= 0;
var vTechCap{tech, region, year} >= 0;
var vTechAct{tech, region, year, slice} >= 0;
var vTechInp{tech, comm, region, year, slice} >= 0;
var vTechOut{tech, comm, region, year, slice} >= 0;
var vTechAInp{tech, comm, region, year, slice} >= 0;
var vTechAOut{tech, comm, region, year, slice} >= 0;
var vSupOut{sup, comm, region, year, slice} >= 0;
var vSupReserve{sup, comm, region} >= 0;
var vDemInp{comm, region, year, slice} >= 0;
var vOutTot{comm, region, year, slice} >= 0;
var vInpTot{comm, region, year, slice} >= 0;
var vInp2Lo{comm, region, year, slice, slice} >= 0;
var vOut2Lo{comm, region, year, slice, slice} >= 0;
var vSupOutTot{comm, region, year, slice} >= 0;
var vTechInpTot{comm, region, year, slice} >= 0;
var vTechOutTot{comm, region, year, slice} >= 0;
var vStorageInpTot{comm, region, year, slice} >= 0;
var vStorageOutTot{comm, region, year, slice} >= 0;
var vStorageAInp{stg, comm, region, year, slice} >= 0;
var vStorageAOut{stg, comm, region, year, slice} >= 0;
var vDummyImport{comm, region, year, slice} >= 0;
var vDummyExport{comm, region, year, slice} >= 0;
var vDummyCost{comm, region, year} >= 0;
var vStorageInp{stg, comm, region, year, slice} >= 0;
var vStorageOut{stg, comm, region, year, slice} >= 0;
var vStorageStore{stg, comm, region, year, slice} >= 0;
var vStorageInv{stg, region, year} >= 0;
var vStorageCap{stg, region, year} >= 0;
var vStorageNewCap{stg, region, year} >= 0;
var vImport{comm, region, year, slice} >= 0;
var vExport{comm, region, year, slice} >= 0;
var vTradeIr{trade, comm, region, region, year, slice} >= 0;
var vTradeIrAInp{trade, comm, region, year, slice} >= 0;
var vTradeIrAInpTot{comm, region, year, slice} >= 0;
var vTradeIrAOut{trade, comm, region, year, slice} >= 0;
var vTradeIrAOutTot{comm, region, year, slice} >= 0;
var vExportRowAccumulated{expp, comm} >= 0;
var vExportRow{expp, comm, region, year, slice} >= 0;
var vImportRowAccumulated{imp, comm} >= 0;
var vImportRow{imp, comm, region, year, slice} >= 0;
var vTradeCap{trade, region, region, year} >= 0;
var vTradeInv{trade, region, region, year} >= 0;
var vTradeNewCap{trade, region, region, year} >= 0;




# Guid for add equation and add mapping & parameter to constrain
# 22b584bd-a17a-4fa0-9cd9-f603ab684e47
s.t.  eqTechSng2Sng{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, c) in (mTechInpComm inter mTechOneComm), (t, cp) in (mTechOutComm inter mTechOneComm) : y in mMidMilestone and pTechCinp2use[t,c,r,y,s] <> 0}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechGrp2Sng{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g) in mTechInpGroup, (t, cp) in (mTechOutComm inter mTechOneComm) : y in mMidMilestone}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:(((t,c) in mTechInpComm and (t,g,c) in mTechGroupComm))}(vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechSng2Grp{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, c) in (mTechInpComm inter mTechOneComm), (t, gp) in mTechOutGroup : y in mMidMilestone and pTechCinp2use[t,c,r,y,s] <> 0}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  sum{cp in comm:(((t,cp) in mTechOutComm and (t,gp,cp) in mTechGroupComm))}((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechGrp2Grp{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g) in mTechInpGroup, (t, gp) in mTechOutGroup : y in mMidMilestone}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:(((t,c) in mTechInpComm and (t,g,c) in mTechGroupComm))}(vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])  =  sum{cp in comm:(((t,cp) in mTechOutComm and (t,gp,cp) in mTechGroupComm))}((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechUse2Sng{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, cp) in (mTechOutComm inter mTechOneComm) : y in mMidMilestone}: vTechUse[t,r,y,s]  =  (vTechOut[t,cp,r,y,s]) / (pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechUse2Grp{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, gp) in mTechOutGroup : y in mMidMilestone}: vTechUse[t,r,y,s]  =  sum{cp in comm:(((t,cp) in mTechOutComm and (t,gp,cp) in mTechGroupComm))}((vTechOut[t,cp,r,y,s]) / (pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechShareInpLo{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g, c) in mTechGroupComm : y in mMidMilestone and (t, g) in mTechInpGroup and (t, c) in mTechInpComm and pTechShareLo[t,c,r,y,s] <> 0}: vTechInp[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:(((t,cp) in mTechInpComm and (t,g,cp) in mTechGroupComm))}(vTechInp[t,cp,r,y,s]);

s.t.  eqTechShareInpUp{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g, c) in mTechGroupComm : y in mMidMilestone and (t, g) in mTechInpGroup and (t, c) in mTechInpComm and pTechShareUp[t,c,r,y,s] <> 1}: vTechInp[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:(((t,cp) in mTechInpComm and (t,g,cp) in mTechGroupComm))}(vTechInp[t,cp,r,y,s]);

s.t.  eqTechShareOutLo{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g, c) in mTechGroupComm : y in mMidMilestone and (t, g) in mTechOutGroup and (t, c) in mTechOutComm and pTechShareLo[t,c,r,y,s] <> 0}: vTechOut[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:(((t,cp) in mTechOutComm and (t,g,cp) in mTechGroupComm))}(vTechOut[t,cp,r,y,s]);

s.t.  eqTechShareOutUp{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, g, c) in mTechGroupComm : y in mMidMilestone and (t, g) in mTechOutGroup and (t, c) in mTechOutComm and pTechShareUp[t,c,r,y,s] <> 1}: vTechOut[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:(((t,cp) in mTechOutComm and (t,g,cp) in mTechGroupComm))}(vTechOut[t,cp,r,y,s]);

s.t.  eqTechAInp{(t, s) in mTechSlice, (t, c) in mTechAInp, (t, r, y) in mTechSpan : y in mMidMilestone}: vTechAInp[t,c,r,y,s]  =  (vTechUse[t,r,y,s]*pTechUse2AInp[t,c,r,y,s])+(vTechAct[t,r,y,s]*pTechAct2AInp[t,c,r,y,s])+(vTechCap[t,r,y]*pTechCap2AInp[t,c,r,y,s])+(vTechNewCap[t,r,y]*pTechNCap2AInp[t,c,r,y,s])+sum{cp in comm:(pTechCinp2AInp[t,c,cp,r,y,s])}(pTechCinp2AInp[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:(pTechCout2AInp[t,c,cp,r,y,s])}(pTechCout2AInp[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAOut{(t, s) in mTechSlice, (t, c) in mTechAOut, (t, r, y) in mTechSpan : y in mMidMilestone}: vTechAOut[t,c,r,y,s]  =  (vTechUse[t,r,y,s]*pTechUse2AOut[t,c,r,y,s])+(vTechAct[t,r,y,s]*pTechAct2AOut[t,c,r,y,s])+(vTechCap[t,r,y]*pTechCap2AOut[t,c,r,y,s])+(vTechNewCap[t,r,y]*pTechNCap2AOut[t,c,r,y,s])+sum{cp in comm:(pTechCinp2AOut[t,c,cp,r,y,s])}(pTechCinp2AOut[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:(pTechCout2AOut[t,c,cp,r,y,s])}(pTechCout2AOut[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAfLo{(t, s) in mTechSlice, y in mMidMilestone, r in region : pTechAfLo[t,r,y,s] <> 0 and (t,r,y) in mTechSpan}: pTechAfLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (t,wth1) in mTechWeatherAf and pTechWeatherAfLo[t,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfLo[t,wth1]) <=  vTechAct[t,r,y,s];

s.t.  eqTechAfUp{(t, r, y, s) in mTechAfUp : (t, s) in mTechSlice and y in mMidMilestone and (t, r, y) in mTechSpan}: vTechAct[t,r,y,s] <=  pTechAfUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (t,wth1) in mTechWeatherAf and pTechWeatherAfUp[t,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfUp[t,wth1]);

s.t.  eqTechAfsLo{y in mMidMilestone, t in tech, r in region, s in slice : pTechAfsLo[t,r,y,s]>0 and (t,r,y) in mTechSpan}: pTechAfsLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (t,wth1) in mTechWeatherAfs and pTechWeatherAfsLo[t,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfsLo[t,wth1]) <=  sum{sp in slice:(((t,sp) in mTechSlice and (s,sp) in mAllSliceParentChildAndSame))}(vTechAct[t,r,y,sp]);

s.t.  eqTechAfsUp{y in mMidMilestone, t in tech, r in region, s in slice : pTechAfsUp[t,r,y,s] >= 0 and (t,r,y) in mTechSpan}: sum{sp in slice:(((t,sp) in mTechSlice and (s,sp) in mAllSliceParentChildAndSame))}(vTechAct[t,r,y,sp]) <=  pTechAfsUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (t,wth1) in mTechWeatherAfs and pTechWeatherAfsUp[t,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfsUp[t,wth1]);

s.t.  eqTechActSng{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, c) in (mTechOutComm inter mTechOneComm) : y in mMidMilestone and pTechCact2cout[t,c,r,y,s] <> 0}: vTechAct[t,r,y,s]  =  (vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]);

s.t.  eqTechActGrp{(t, s) in mTechSlice, (t, g) in mTechOutGroup, (t, r, y) in mTechSpan : y in mMidMilestone}: vTechAct[t,r,y,s]  =  sum{c in comm:(((t,g,c) in mTechGroupComm and pTechCact2cout[t,c,r,y,s] <> 0))}((vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]));

s.t.  eqTechAfcOutLo{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, c) in mTechOutComm : y in mMidMilestone and pTechAfcLo[t,c,r,y,s] <> 0}: pTechCact2cout[t,c,r,y,s]*pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and pTechWeatherAfcLo[t,wth1,c] >= 0 and (t,wth1,c) in mTechWeatherAfc and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfcLo[t,wth1,c]) <=  vTechOut[t,c,r,y,s];

s.t.  eqTechAfcOutUp{(t, c, r, y, s) in mTechAfcUp : (t, s) in mTechSlice and y in mMidMilestone and (t, r, y) in mTechSpan and (t, c) in mTechOutComm and (t, r, y, s) in mTechAfUp}: vTechOut[t,c,r,y,s] <=  pTechCact2cout[t,c,r,y,s]*pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and pTechWeatherAfcUp[t,wth1,c] >= 0 and (t,wth1,c) in mTechWeatherAfc and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfcUp[t,wth1,c]);

s.t.  eqTechAfcInpLo{(t, s) in mTechSlice, (t, r, y) in mTechSpan, (t, c) in mTechInpComm : y in mMidMilestone and pTechAfcLo[t,c,r,y,s] <> 0}: pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and pTechWeatherAfcLo[t,wth1,c] >= 0 and (t,wth1,c) in mTechWeatherAfc and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfcLo[t,wth1,c]) <=  vTechInp[t,c,r,y,s];

s.t.  eqTechAfcInpUp{(t, c, r, y, s) in mTechAfcUp : (t, s) in mTechSlice and y in mMidMilestone and (t, r, y) in mTechSpan and (t, c) in mTechInpComm and (t, r, y, s) in mTechAfUp}: vTechInp[t,c,r,y,s] <=  pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and pTechWeatherAfcUp[t,wth1,c] >= 0 and (t,wth1,c) in mTechWeatherAfc and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pTechWeatherAfcUp[t,wth1,c]);

s.t.  eqTechCap{(t, r, y) in mTechSpan : y in mMidMilestone}: vTechCap[t,r,y]  =  pTechStock[t,r,y]+sum{yp in year:(((t,r,yp) in mTechNew and yp in mMidMilestone and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[t,r]+ordYear[yp] or (t,r) in mTechOlifeInf)))}(vTechNewCap[t,r,yp]-sum{ye in year:((t in mTechRetirement and ye in mMidMilestone and ordYear[ye] >= ordYear[yp] and ordYear[ye] <= ordYear[y]))}(vTechRetiredCap[t,r,yp,ye]));

s.t.  eqTechNewCap{(t, r, y) in mTechNew : y in mMidMilestone and t in mTechRetirement}: sum{yp in year:((yp in mMidMilestone and ordYear[yp] >= ordYear[y] and ordYear[yp]<ordYear[y]+pTechOlife[t,r]))}(vTechRetiredCap[t,r,y,yp]) <=  vTechNewCap[t,r,y];

s.t.  eqTechEac{(t, r, y) in mTechSpan : y in mMidMilestone}: vTechEac[t,r,y]  =  sum{yp in year:(((t,r,yp) in mTechNew and yp in mMidMilestone and ordYear[y] >= ordYear[yp] and ordYear[y]<pTechOlife[t,r]+ordYear[yp] and not(((t,r) in mTechOlifeInf)) and pTechInvcost[t,r,yp] <> 0))}((pTechInvcost[t,r,yp]*(vTechNewCap[t,r,yp]-sum{ye in year:((t in mTechRetirement and ye in mMidMilestone and ordYear[ye] >= ordYear[yp] and ordYear[ye] <= ordYear[y]))}(vTechRetiredCap[t,r,yp,ye]))) / ((sum{ye in year:((ordYear[ye] >= ordYear[yp] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]))}((pDiscountFactor[r,ye]) / (pDiscountFactor[r,yp]))+sum{ye in year:((ordYear[ye]=cardYear[y] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]-1 and not((r in mDiscountZero))))}((pDiscountFactor[r,ye]*(1-(((1+pDiscount[r,ye]))^(ordYear[ye]-ordYear[yp]-pTechOlife[t,r]+1)))) / (pDiscountFactor[r,yp]*pDiscount[r,ye]))+sum{ye in year:((ordYear[ye]=cardYear[y] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]-1 and r in mDiscountZero))}((pDiscountFactor[r,ye]*(pTechOlife[t,r]-1-ordYear[ye]+ordYear[yp])) / (pDiscountFactor[r,yp])))));

s.t.  eqTechInv{(t, r, y) in mTechNew : y in mMidMilestone}: vTechInv[t,r,y]  =  pTechInvcost[t,r,y]*vTechNewCap[t,r,y];

s.t.  eqTechSalv{(t, r) in mTechSalv, ye in mMilestoneLast}: vTechSalv[t,r]  =  sum{y in year:((y in mMidMilestone and (t,r,y) in mTechNew and ordYear[y]+pTechOlife[t,r]-1>ordYear[ye] and not(((t,r) in mTechOlifeInf)) and pTechInvcost[t,r,y] <> 0))}(pTechSalv[t,r,y]*pTechInvcost[t,r,y]*(vTechNewCap[t,r,y]-sum{yp in year:(t in mTechRetirement)}(vTechRetiredCap[t,r,y,yp])));

s.t.  eqTechOMCost{(t, r, y) in mTechSpan : y in mMidMilestone}: vTechOMCost[t,r,y]  =  pTechFixom[t,r,y]*vTechCap[t,r,y]+sum{s in slice:((t,s) in mTechSlice)}(pTechVarom[t,r,y,s]*vTechAct[t,r,y,s]+sum{c in comm:((t,c) in mTechInpComm)}(pTechCvarom[t,c,r,y,s]*vTechInp[t,c,r,y,s])+sum{c in comm:((t,c) in mTechOutComm)}(pTechCvarom[t,c,r,y,s]*vTechOut[t,c,r,y,s])+sum{c in comm:((t,c) in mTechAOut)}(pTechAvarom[t,c,r,y,s]*vTechAOut[t,c,r,y,s])+sum{c in comm:((t,c) in mTechAInp)}(pTechAvarom[t,c,r,y,s]*vTechAInp[t,c,r,y,s]));

s.t.  eqSupAvaUp{(s1, c, r, y, s) in mSupAvaUp}: vSupOut[s1,c,r,y,s] <=  pSupAvaUp[s1,c,r,y,s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (s1,wth1) in mSupWeatherUp and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pSupWeatherUp[s1,wth1]);

s.t.  eqSupAvaLo{(s1, c, r, y, s) in mSupAva}: vSupOut[s1,c,r,y,s]  >=  pSupAvaLo[s1,c,r,y,s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (s1,wth1) in mSupWeatherLo and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pSupWeatherLo[s1,wth1]);

s.t.  eqSupTotal{(s1, c) in mSupComm, (s1, r) in mSupSpan}: vSupReserve[s1,c,r]  =  sum{y in year,s in slice:(((s1,c,r,y,s) in mSupAva and y in mMidMilestone))}(pPeriodLen[y]*vSupOut[s1,c,r,y,s]);

s.t.  eqSupReserveUp{(s1, c, r) in mSupReserveUp}: pSupReserveUp[s1,c,r]  >=  vSupReserve[s1,c,r];

s.t.  eqSupReserveLo{(s1, c) in mSupComm, r in region : pSupReserveLo[s1,c,r] <> 0 and (s1,r) in mSupSpan}: vSupReserve[s1,c,r]  >=  pSupReserveLo[s1,c,r];

s.t.  eqSupCost{y in mMidMilestone, (s1, r) in mSupSpan}: vSupCost[s1,r,y]  =  sum{c in comm,s in slice:((s1,c,r,y,s) in mSupAva)}(pSupCost[s1,c,r,y,s]*vSupOut[s1,c,r,y,s]);

s.t.  eqDemInp{y in mMidMilestone, (c, s) in mDemInp, r in region}: vDemInp[c,r,y,s]  =  sum{d in dem:((d,c) in mDemComm)}(pDemand[d,c,r,y,s]);

s.t.  eqAggOut{(c, r, y, s) in mAggOut}: vAggOut[c,r,y,s]  =  sum{cp in comm:(pAggregateFactor[c,cp])}(pAggregateFactor[c,cp]*vOutTot[cp,r,y,s]);

s.t.  eqTechEmsFuel{(t, c, r, y, s) in mTechEmsFuel}: vTechEmsFuel[t,c,r,y,s]  =  sum{cp in comm:(((t,cp) in mTechInpComm and pTechEmisComm[t,cp] <> 0 and pEmissionFactor[c,cp] <> 0))}(pTechEmisComm[t,cp]*pEmissionFactor[c,cp]*vTechInp[t,cp,r,y,s]);

s.t.  eqEmsFuelTot{(c, r, y, s) in mEmsFuelTot}: vEmsFuelTot[c,r,y,s]  =  sum{t in tech:((t,c,r,y,s) in mTechEmsFuel)}(vTechEmsFuel[t,c,r,y,s]);

s.t.  eqStorageAInp{(st1, c) in mStorageAInp, (st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan : y in mMidMilestone}: vStorageAInp[st1,c,r,y,s]  =  sum{cp in comm:((st1,cp) in mStorageComm)}(pStorageStg2AInp[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]+pStorageInp2AInp[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]+pStorageOut2AInp[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]+pStorageCap2AInp[st1,c,r,y,s]*vStorageCap[st1,r,y]+pStorageNCap2AInp[st1,c,r,y,s]*vStorageNewCap[st1,r,y]);

s.t.  eqStorageAOut{(st1, c) in mStorageAOut, (st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan : y in mMidMilestone}: vStorageAOut[st1,c,r,y,s]  =  sum{cp in comm:((st1,cp) in mStorageComm)}(pStorageStg2AOut[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]+pStorageInp2AOut[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]+pStorageOut2AOut[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]+pStorageCap2AOut[st1,c,r,y,s]*vStorageCap[st1,r,y]+pStorageNCap2AOut[st1,c,r,y,s]*vStorageNewCap[st1,r,y]);

s.t.  eqStorageStore{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone}: vStorageStore[st1,c,r,y,s]  =  pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s]-(vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s])+sum{sp in slice:(((st1,sp) in mStorageSlice and (sp,s) in mSliceNext))}(pStorageStgEff[st1,c,r,y,s]*vStorageStore[st1,c,r,y,sp]);

s.t.  eqStorageAfLo{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone and pStorageAfLo[st1,r,y,s]}: vStorageStore[st1,c,r,y,s]  >=  pStorageAfLo[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherAf and pStorageWeatherAfLo[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherAfLo[st1,wth1]);

s.t.  eqStorageAfUp{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone}: vStorageStore[st1,c,r,y,s] <=  pStorageAfUp[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherAf and pStorageWeatherAfUp[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherAfUp[st1,wth1]);

s.t.  eqStorageClean{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone}: vStorageInp[st1,c,r,y,s] <=  vStorageStore[st1,c,r,y,s];

s.t.  eqStorageInpUp{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone and pStorageCinpUp[st1,c,r,y,s] >= 0}: pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s] <=  pStorageCinpUp[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherCinp and pStorageWeatherCinpUp[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherCinpUp[st1,wth1]);

s.t.  eqStorageInpLo{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone and pStorageCinpLo[st1,c,r,y,s]>0}: pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s]  >=  pStorageCinpLo[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherCinp and pStorageWeatherCinpLo[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherCinpLo[st1,wth1]);

s.t.  eqStorageOutUp{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone and pStorageCoutUp[st1,c,r,y,s] >= 0}: (vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s]) <=  pStorageCoutUp[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherCout and pStorageWeatherCoutUp[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherCoutUp[st1,wth1]);

s.t.  eqStorageOutLo{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : y in mMidMilestone and pStorageCoutLo[st1,c,r,y,s]>0}: (vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s])  >=  pStorageCoutLo[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:(((wth1,r) in mWeatherRegion and (wth1,sp) in mWeatherSlice and (st1,wth1) in mStorageWeatherCout and pStorageWeatherCoutLo[st1,wth1] >= 0 and (s,sp) in mAllSliceParentChildAndSame))}(pWeather[wth1,r,y,s]*pStorageWeatherCoutLo[st1,wth1]);

s.t.  eqStorageCap{(st1, r, y) in mStorageSpan : y in mMidMilestone}: vStorageCap[st1,r,y]  =  pStorageStock[st1,r,y]+sum{yp in year:((ordYear[y] >= ordYear[yp] and ((st1,r) in mStorageOlifeInf or ordYear[y]<pStorageOlife[st1,r]+ordYear[yp]) and (st1,r,y) in mStorageNew))}(vStorageNewCap[st1,r,yp]);

s.t.  eqStorageInv{(st1, r, y) in mStorageNew : y in mMidMilestone}: vStorageInv[st1,r,y]  =  pStorageInvcost[st1,r,y]*vStorageNewCap[st1,r,y];

s.t.  eqStorageCost{(st1, r, y) in mStorageSpan : y in mMidMilestone}: vStorageOMCost[st1,r,y]  =  pStorageFixom[st1,r,y]*vStorageCap[st1,r,y]+sum{c in comm,s in slice:(((st1,s) in mStorageSlice and (st1,c) in mStorageComm))}(pStorageCostInp[st1,r,y,s]*vStorageInp[st1,c,r,y,s]+pStorageCostOut[st1,r,y,s]*vStorageOut[st1,c,r,y,s]+pStorageCostStore[st1,r,y,s]*vStorageStore[st1,c,r,y,s]);

s.t.  eqStorageSalv0{r in mDiscountZero, ye in mMilestoneLast, st1 in stg : sum{y in year:((st1,r,y) in mStorageNew)}(1) <> 0}: vStorageSalv[st1,r]+sum{y in year,yn in year:(((yn,y) in mStartMilestone and yn in mMidMilestone and (st1,r,yn) in mStorageNew and ordYear[yn]+pStorageOlife[st1,r]-1>ordYear[ye] and not(((st1,r) in mStorageOlifeInf)) and pStorageInvcost[st1,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pStorageInvcost[st1,r,yn]*vStorageNewCap[st1,r,yn]) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / ((pDiscountFactor[r,ye])*((pStorageOlife[st1,r]+ordYear[yn]-1-ordYear[ye]))))))  =  0;

s.t.  eqStorageSalv{ye in mMilestoneLast, st1 in stg, r in region : not((r in mDiscountZero)) and sum{y in year:((st1,r,y) in mStorageNew)}(1) <> 0}: vStorageSalv[st1,r]+sum{y in year,yn in year:(((yn,y) in mStartMilestone and yn in mMidMilestone and (st1,r,yn) in mStorageNew and ordYear[yn]+pStorageOlife[st1,r]-1>ordYear[ye] and not(((st1,r) in mStorageOlifeInf)) and pStorageInvcost[st1,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pStorageInvcost[st1,r,yn]*vStorageNewCap[st1,r,yn]) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / (pDiscountFactor[r,ye]*(((1-((1+pDiscount[r,ye]))^(ordYear[ye]-pStorageOlife[st1,r]-ordYear[yn]+1))*(1+pDiscount[r,ye])) / (pDiscount[r,ye]))))))  =  0;

s.t.  eqImport{(c, dst, y, s) in mImport}: vImport[c,dst,y,s]  =  sum{t1 in trade,src in region:(((t1,src,dst,y,s) in mTradeIr and (t1,c) in mTradeComm))}(pTradeIrEff[t1,src,dst,y,s]*vTradeIr[t1,c,src,dst,y,s])+sum{i in imp:((i,c,dst,y,s) in mImportRow)}(vImportRow[i,c,dst,y,s]);

s.t.  eqExport{(c, src, y, s) in mExport}: vExport[c,src,y,s]  =  sum{t1 in trade,dst in region:(((t1,src,dst,y,s) in mTradeIr and (t1,c) in mTradeComm))}(vTradeIr[t1,c,src,dst,y,s])+sum{e in expp:((e,c,src,y,s) in mExportRow)}(vExportRow[e,c,src,y,s]);

s.t.  eqTradeFlowUp{(t1, src, dst, y, s) in mTradeIrUp, (t1, c) in mTradeComm}: vTradeIr[t1,c,src,dst,y,s] <=  pTradeIrUp[t1,src,dst,y,s];

s.t.  eqTradeFlowLo{(t1, src, dst, y, s) in mTradeIr, c in comm : pTradeIrLo[t1,src,dst,y,s] and (t1,c) in mTradeComm}: vTradeIr[t1,c,src,dst,y,s]  >=  pTradeIrLo[t1,src,dst,y,s];

s.t.  eqCostTrade{y in mMidMilestone, r in region}: vTradeCost[r,y]  =  vTradeRowCost[r,y]+vTradeIrCost[r,y];

s.t.  eqCostRowTrade{y in mMidMilestone, r in region}: vTradeRowCost[r,y]  =  sum{i in imp,c in comm,s in slice:((i,c,r,y,s) in mImportRow)}(pImportRowPrice[i,r,y,s]*vImportRow[i,c,r,y,s])-sum{e in expp,c in comm,s in slice:((e,c,r,y,s) in mExportRow)}(pExportRowPrice[e,r,y,s]*vExportRow[e,c,r,y,s]);

s.t.  eqCostIrTrade{y in mMidMilestone, r in region}: vTradeIrCost[r,y]  =  sum{t1 in trade,c in comm,src in region,s in slice:(((t1,s) in mTradeSlice and (t1,src) in mTradeSrc and (t1,r) in mTradeDst and not(((src,r) in mSameRegion)) and (t1,c) in mTradeComm))}((pTradeIrCost[t1,src,r,y,s]+pTradeIrMarkup[t1,src,r,y,s])*vTradeIr[t1,c,src,r,y,s])-sum{t1 in trade,c in comm,dst in region,s in slice:(((t1,s) in mTradeSlice and (t1,r) in mTradeSrc and (t1,dst) in mTradeDst and not(((dst,r) in mSameRegion)) and (t1,c) in mTradeComm))}(pTradeIrMarkup[t1,r,dst,y,s]*vTradeIr[t1,c,r,dst,y,s]);

s.t.  eqExportRowUp{(e, c, r, y, s) in mExportRowUp}: vExportRow[e,c,r,y,s] <=  pExportRowUp[e,r,y,s];

s.t.  eqExportRowLo{(e, c, r, y, s) in mExportRow : pExportRowLo[e,r,y,s] <> 0}: vExportRow[e,c,r,y,s]  >=  pExportRowLo[e,r,y,s];

s.t.  eqExportRowCumulative{(e, c) in mExpComm}: vExportRowAccumulated[e,c]  =  sum{r in region,y in year,s in slice:((y in mMidMilestone and (e,c,r,y,s) in mExportRow))}(pPeriodLen[y]*vExportRow[e,c,r,y,s]);

s.t.  eqExportRowResUp{(e, c) in (mExportRowAccumulatedUp inter mExpComm)}: vExportRowAccumulated[e,c] <=  pExportRowRes[e];

s.t.  eqImportRowUp{(i, c, r, y, s) in mImportRowUp}: vImportRow[i,c,r,y,s] <=  pImportRowUp[i,r,y,s];

s.t.  eqImportRowLo{(i, c, r, y, s) in mImportRow : pImportRowLo[i,r,y,s] <> 0}: vImportRow[i,c,r,y,s]  >=  pImportRowLo[i,r,y,s];

s.t.  eqImportRowAccumulated{(i, c) in mImpComm}: vImportRowAccumulated[i,c]  =  sum{r in region,y in year,s in slice:((i,c,r,y,s) in mImportRow)}(pPeriodLen[y]*vImportRow[i,c,r,y,s]);

s.t.  eqImportRowResUp{(i, c) in mImportRowAccumulatedUp}: vImportRowAccumulated[i,c] <=  pImportRowRes[i];

s.t.  eqTradeCapFlow{(t1, c) in mTradeComm, (t1, s) in mTradeSlice, (t1, src, dst, y) in mTradeSpan : t1 in mTradeCapacityVariable and y in mMidMilestone}: vTradeCap[t1,src,dst,y]  >=  pTradeCap2Act[t1]*vTradeIr[t1,c,src,dst,y,s];

s.t.  eqTradeCap{(t1, src, dst, y) in mTradeSpan : t1 in mTradeCapacityVariable and y in mMidMilestone}: vTradeCap[t1,src,dst,y]  =  pTradeStock[t1,src,dst,y]+sum{yp in year:(((t1,src,dst,yp) in mTradeNew and yp in mMidMilestone and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTradeOlife[t1,src,dst]+ordYear[yp] or (t1,src,dst) in mTradeOlifeInf)))}(vTradeNewCap[t1,src,dst,yp]);

s.t.  eqTradeInv{(t1, src, dst, y) in mTradeNew : t1 in mTradeCapacityVariable and y in mMidMilestone}: vTradeInv[t1,src,dst,y]  =  pTradeInvcost[t1,src,dst,y]*vTradeNewCap[t1,src,dst,y];

s.t.  eqTradeSalv{(t1, src, dst) in mTradeSalv, ye in mMilestoneLast : t1 in mTradeCapacityVariable}: vTradeSalv[t1,src,dst]  =  sum{y in year:((y in mMidMilestone and (t1,src,dst,y) in mTradeNew and ordYear[y]+pTradeOlife[t1,src,dst]-1>ordYear[ye] and not(((t1,src,dst) in mTradeOlifeInf)) and pTradeInvcost[t1,src,dst,y] <> 0))}(pTradeSalv[t1,src,dst,y]*pTradeInvcost[t1,src,dst,y]*vTradeNewCap[t1,src,dst,y]);

s.t.  eqTradeIrAInp{(t1, c, r, y, s) in mTradeIrAInp2}: vTradeIrAInp[t1,c,r,y,s]  =  sum{dst in region:(((t1,r) in mTradeSrc and (t1,dst) in mTradeDst and not(((r,dst) in mSameRegion))))}(pTradeIrCsrc2Ainp[t1,c,r,dst,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:(((t1,src) in mTradeSrc and (t1,r) in mTradeDst and not(((r,src) in mSameRegion))))}(pTradeIrCdst2Ainp[t1,c,src,r,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAOut{(t1, c, r, y, s) in mTradeIrAOut2}: vTradeIrAOut[t1,c,r,y,s]  =  sum{dst in region:(((t1,r) in mTradeSrc and (t1,dst) in mTradeDst and not(((r,dst) in mSameRegion))))}(pTradeIrCsrc2Aout[t1,c,r,dst,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:(((t1,src) in mTradeSrc and (t1,r) in mTradeDst and not(((r,src) in mSameRegion))))}(pTradeIrCdst2Aout[t1,c,src,r,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAInpTot{(c, r, y, s) in mTradeIrAInpTot}: vTradeIrAInpTot[c,r,y,s]  =  sum{t1 in trade:((t1,c,r,y,s) in mTradeIrAInp2)}(vTradeIrAInp[t1,c,r,y,s]);

s.t.  eqTradeIrAOutTot{(c, r, y, s) in mTradeIrAOutTot}: vTradeIrAOutTot[c,r,y,s]  =  sum{t1 in trade:((t1,c,r,y,s) in mTradeIrAOut2)}(vTradeIrAOut[t1,c,r,y,s]);

s.t.  eqBalLo{y in mMidMilestone, (c, s) in mCommSlice, r in region : c in mLoComm}: vBalance[c,r,y,s]  >=  0;

s.t.  eqBalUp{y in mMidMilestone, (c, s) in mCommSlice, r in region : c in mUpComm}: vBalance[c,r,y,s] <=  0;

s.t.  eqBalFx{y in mMidMilestone, (c, s) in mCommSlice, r in region : c in mFxComm}: vBalance[c,r,y,s]  =  0;

s.t.  eqBal{y in mMidMilestone, (c, s) in mCommSlice, r in region}: vBalance[c,r,y,s]  =  vOutTot[c,r,y,s]-vInpTot[c,r,y,s];

s.t.  eqOutTot{y in mMidMilestone, (c, s) in mCommSlice, r in region}: vOutTot[c,r,y,s]  =  sum{FORIF: (c,r,y,s) in mDummyImport} (vDummyImport[c,r,y,s])+sum{sp in slice:((s,sp) in mAllSliceParentChildAndSame)}(sum{FORIF: (c,r,sp) in mSupOutTot} (vSupOutTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mEmsFuelTot} (vEmsFuelTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mAggOut} (vAggOut[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mTechOutTot} (vTechOutTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mStorageOutTot} (vStorageOutTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mImport} (vImport[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,sp]))+sum{sp in slice:(((sp,s) in mAllSliceParentChild and (c,r,y,sp) in mOut2Lo))}(vOut2Lo[c,r,y,sp,s]);

s.t.  eqOut2Lo{(c, r, y, s) in mOut2Lo}: sum{sp in slice:(((s,sp) in mAllSliceParentChild and (c,sp) in mCommSlice))}(vOut2Lo[c,r,y,s,sp])  =  sum{FORIF: (c,r,s) in mSupOutTot} (vSupOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mEmsFuelTot} (vEmsFuelTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mAggOut} (vAggOut[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTechOutTot} (vTechOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageOutTot} (vStorageOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mImport} (vImport[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,s]);

s.t.  eqInpTot{y in mMidMilestone, (c, s) in mCommSlice, r in region}: vInpTot[c,r,y,s]  =  sum{FORIF: (c,s) in mDemInp} (vDemInp[c,r,y,s])+sum{FORIF: (c,r,y,s) in mDummyExport} (vDummyExport[c,r,y,s])+sum{sp in slice:((s,sp) in mAllSliceParentChildAndSame)}(sum{FORIF: (c,r,y,sp) in mTechInpTot} (vTechInpTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mStorageInpTot} (vStorageInpTot[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mExport} (vExport[c,r,y,sp])+sum{FORIF: (c,r,y,sp) in mTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,sp]))+sum{sp in slice:(((sp,s) in mAllSliceParentChild and (c,r,y,sp) in mInp2Lo))}(vInp2Lo[c,r,y,sp,s]);

s.t.  eqInp2Lo{(c, r, y, s) in mInp2Lo}: sum{sp in slice:(((s,sp) in mAllSliceParentChild and (c,sp) in mCommSlice))}(vInp2Lo[c,r,y,s,sp])  =  sum{FORIF: (c,r,y,s) in mTechInpTot} (vTechInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageInpTot} (vStorageInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mExport} (vExport[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,s]);

s.t.  eqSupOutTot{y in mMidMilestone, (c, r, s) in mSupOutTot}: vSupOutTot[c,r,y,s]  =  sum{s1 in sup:((s1,c,r,y,s) in mSupAva)}(vSupOut[s1,c,r,y,s]);

s.t.  eqTechInpTot{(c, r, y, s) in mTechInpTot}: vTechInpTot[c,r,y,s]  =  sum{t in tech:(((t,r,y) in mTechSpan and (t,c) in mTechInpComm and (t,s) in mTechSlice))}(vTechInp[t,c,r,y,s])+sum{t in tech:(((t,r,y) in mTechSpan and (t,c) in mTechAInp and (t,s) in mTechSlice))}(vTechAInp[t,c,r,y,s]);

s.t.  eqTechOutTot{(c, r, y, s) in mTechOutTot}: vTechOutTot[c,r,y,s]  =  sum{t in tech:(((t,s) in mTechSlice and (t,r,y) in mTechSpan and (t,s) in mTechSlice and (t,c) in mTechOutComm))}(vTechOut[t,c,r,y,s])+sum{t in tech:(((t,s) in mTechSlice and (t,r,y) in mTechSpan and (t,s) in mTechSlice and (t,c) in mTechAOut))}(vTechAOut[t,c,r,y,s]);

s.t.  eqStorageInpTot{(c, r, y, s) in mStorageInpTot}: vStorageInpTot[c,r,y,s]  =  sum{st1 in stg:(((st1,c) in mStorageComm and pStorageInpEff[st1,c,r,y,s] and (st1,s) in mStorageSlice and (st1,r,y) in mStorageSpan))}(vStorageInp[st1,c,r,y,s])+sum{st1 in stg:(((st1,c) in mStorageAInp and (st1,s) in mStorageSlice and (st1,r,y) in mStorageSpan))}(vStorageAInp[st1,c,r,y,s]);

s.t.  eqStorageOutTot{(c, r, y, s) in mStorageOutTot}: vStorageOutTot[c,r,y,s]  =  sum{st1 in stg:(((st1,c) in mStorageComm and pStorageOutEff[st1,c,r,y,s] and (st1,s) in mStorageSlice and (st1,r,y) in mStorageSpan))}(vStorageOut[st1,c,r,y,s])+sum{st1 in stg:(((st1,c) in mStorageAOut and (st1,s) in mStorageSlice and (st1,r,y) in mStorageSpan))}(vStorageAOut[st1,c,r,y,s]);

s.t.  eqDummyCost{(c, r, y) in mDummyCost : y in mMidMilestone}: vDummyCost[c,r,y]  =  sum{s in slice:((c,r,y,s) in mDummyImport)}(pDummyImportCost[c,r,y,s]*vDummyImport[c,r,y,s])+sum{s in slice:((c,r,y,s) in mDummyExport)}(pDummyExportCost[c,r,y,s]*vDummyExport[c,r,y,s]);

s.t.  eqCost{y in mMidMilestone, r in region}: vCost[r,y]  =  sum{t in tech:((t,r,y) in mTechSpan)}(vTechOMCost[t,r,y])+sum{s1 in sup:((s1,r) in mSupSpan)}(vSupCost[s1,r,y])+sum{c in comm:((c,r,y) in mDummyCost)}(vDummyCost[c,r,y])+sum{c in comm:((c,r,y) in mTaxCost)}(vTaxCost[c,r,y])-sum{c in comm:((c,r,y) in mSubsCost)}(vSubsCost[c,r,y])+sum{st1 in stg:((st1,r,y) in mStorageSpan)}(vStorageOMCost[st1,r,y])+vTradeCost[r,y];

s.t.  eqTaxCost{(c, r, y) in mTaxCost}: vTaxCost[c,r,y]  =  sum{s in slice:((c,s) in mCommSlice)}(pTaxCost[c,r,y,s]*vOutTot[c,r,y,s]);

s.t.  eqSubsCost{(c, r, y) in mSubsCost}: vSubsCost[c,r,y]  =  sum{s in slice:((c,s) in mCommSlice)}(pSubsCost[c,r,y,s]*vOutTot[c,r,y,s]);

s.t.  eqObjective: vObjective  =  sum{r in region,y in year,yp in year:((y in mMidMilestone and (y,yp) in mStartMilestone))}(pDiscountFactor[r,yp]*sum{t in tech:((t,r,y) in mTechNew)}(vTechInv[t,r,y]))+sum{r in region,y in year,yp in year:((y in mMidMilestone and (y,yp) in mStartMilestone))}(pDiscountFactor[r,yp]*sum{st1 in stg:((st1,r,y) in mStorageNew)}(vStorageInv[st1,r,y]))+sum{r in region,y in year:(y in mMidMilestone)}(vCost[r,y]*sum{ye in year,yp in year,yn in year:(((y,yp) in mStartMilestone and (y,ye) in mEndMilestone and ordYear[yn] >= ordYear[yp] and ordYear[yn] <= ordYear[ye]))}(pDiscountFactor[r,yn]))+sum{r in region,y in year,t in tech:((y in mMilestoneLast and (t,r) in mTechSalv))}(pDiscountFactor[r,y]*vTechSalv[t,r])+sum{r in region,y in year,st1 in stg:((y in mMilestoneLast and sum{yp in year:((st1,r,yp) in mStorageNew)}(1) <> 0))}(pDiscountFactor[r,y]*vStorageSalv[st1,r])+sum{src in region,dst in region,y in year,yp in year:((y in mMidMilestone and (y,yp) in mStartMilestone))}(pDiscountFactor[src,yp]*sum{t1 in trade:((t1 in mTradeCapacityVariable and (t1,src,dst,y) in mTradeNew))}(vTradeInv[t1,src,dst,y]))+sum{src in region,dst in region,y in year,t1 in trade:((t1 in mTradeCapacityVariable and y in mMilestoneLast and (t1,src,dst) in mTradeSalv))}(pDiscountFactor[src,y]*vTradeSalv[t1,src,dst]);

s.t.  eqLECActivity{(t, r, y) in mTechSpan : r in mLECRegion}: sum{s in slice:((t,s) in mTechSlice)}(vTechAct[t,r,y,s])  >=  pLECLoACT[r];

minimize vObjective2 : vObjective;

solve;


printf "value\n2.00\n" > "pFinish.csv";
printf "tech,region,year,slice,value\n" > "vTechUse.csv";
for{(t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechUse[t,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t,r,y,s,vTechUse[t,r,y,s] >> "vTechUse.csv";
}
printf "tech,region,year,value\n" > "vTechNewCap.csv";
for{(t, r, y) in mTechNew : vTechNewCap[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechNewCap[t,r,y] >> "vTechNewCap.csv";
}
printf "tech,region,year,yearp,value\n" > "vTechRetiredCap.csv";
for{(t, r, y) in mTechSpan, yp in year : vTechRetiredCap[t,r,y,yp] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t,r,y,yp,vTechRetiredCap[t,r,y,yp] >> "vTechRetiredCap.csv";
}
printf "tech,region,year,value\n" > "vTechCap.csv";
for{(t, r, y) in mTechSpan : vTechCap[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechCap[t,r,y] >> "vTechCap.csv";
}
printf "tech,region,year,slice,value\n" > "vTechAct.csv";
for{(t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechAct[t,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t,r,y,s,vTechAct[t,r,y,s] >> "vTechAct.csv";
}
printf "tech,comm,region,year,slice,value\n" > "vTechInp.csv";
for{(t, c) in mTechInpComm, (t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechInp[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechInp[t,c,r,y,s] >> "vTechInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "vTechOut.csv";
for{(t, c) in mTechOutComm, (t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechOut[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechOut[t,c,r,y,s] >> "vTechOut.csv";
}
printf "tech,comm,region,year,slice,value\n" > "vTechAInp.csv";
for{(t, c) in mTechAInp, (t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechAInp[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechAInp[t,c,r,y,s] >> "vTechAInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "vTechAOut.csv";
for{(t, c) in mTechAOut, (t, r, y) in mTechSpan, (t, s) in mTechSlice : vTechAOut[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechAOut[t,c,r,y,s] >> "vTechAOut.csv";
}
printf "tech,region,year,value\n" > "vTechInv.csv";
for{(t, r, y) in mTechNew : vTechInv[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechInv[t,r,y] >> "vTechInv.csv";
}
printf "tech,region,year,value\n" > "vTechEac.csv";
for{(t, r, y) in mTechSpan : vTechEac[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechEac[t,r,y] >> "vTechEac.csv";
}
printf "tech,region,value\n" > "vTechSalv.csv";
for{t in tech, r in region : vTechSalv[t,r] <> 0} {
  printf "%s,%s,%f\n", t,r,vTechSalv[t,r] >> "vTechSalv.csv";
}
printf "tech,region,year,value\n" > "vTechOMCost.csv";
for{(t, r, y) in mTechSpan : vTechOMCost[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechOMCost[t,r,y] >> "vTechOMCost.csv";
}
printf "sup,comm,region,year,slice,value\n" > "vSupOut.csv";
for{(s1, c, r, y, s) in mSupAva : vSupOut[s1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s1,c,r,y,s,vSupOut[s1,c,r,y,s] >> "vSupOut.csv";
}
printf "sup,comm,region,value\n" > "vSupReserve.csv";
for{(s1, c) in mSupComm, (s1, r) in mSupSpan : vSupReserve[s1,c,r] <> 0} {
  printf "%s,%s,%s,%f\n", s1,c,r,vSupReserve[s1,c,r] >> "vSupReserve.csv";
}
printf "sup,region,year,value\n" > "vSupCost.csv";
for{(s1, r) in mSupSpan, y in year : vSupCost[s1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s1,r,y,vSupCost[s1,r,y] >> "vSupCost.csv";
}
printf "comm,region,year,slice,value\n" > "vDemInp.csv";
for{y in mMidMilestone, (c, s) in mDemInp, r in region : vDemInp[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDemInp[c,r,y,s] >> "vDemInp.csv";
}
printf "comm,region,year,slice,value\n" > "vEmsFuelTot.csv";
for{(c, r, y, s) in mEmsFuelTot : vEmsFuelTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vEmsFuelTot[c,r,y,s] >> "vEmsFuelTot.csv";
}
printf "tech,comm,region,year,slice,value\n" > "vTechEmsFuel.csv";
for{(t, c, r, y, s) in mTechEmsFuel : vTechEmsFuel[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechEmsFuel[t,c,r,y,s] >> "vTechEmsFuel.csv";
}
printf "comm,region,year,slice,value\n" > "vBalance.csv";
for{y in mMidMilestone, (c, s) in mCommSlice, r in region : vBalance[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vBalance[c,r,y,s] >> "vBalance.csv";
}
printf "comm,region,year,slice,value\n" > "vOutTot.csv";
for{y in mMidMilestone, (c, s) in mCommSlice, r in region : vOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vOutTot[c,r,y,s] >> "vOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "vInpTot.csv";
for{y in mMidMilestone, (c, s) in mCommSlice, r in region : vInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vInpTot[c,r,y,s] >> "vInpTot.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "vInp2Lo.csv";
for{(c, r, y, s) in mInp2Lo, sp in slice : vInp2Lo[c,r,y,s,sp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,s,sp,vInp2Lo[c,r,y,s,sp] >> "vInp2Lo.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "vOut2Lo.csv";
for{(c, r, y, s) in mOut2Lo, sp in slice : vOut2Lo[c,r,y,s,sp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,s,sp,vOut2Lo[c,r,y,s,sp] >> "vOut2Lo.csv";
}
printf "comm,region,year,slice,value\n" > "vSupOutTot.csv";
for{(c, r, s) in mSupOutTot, y in year : vSupOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vSupOutTot[c,r,y,s] >> "vSupOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "vTechInpTot.csv";
for{(c, r, y, s) in mTechInpTot : vTechInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTechInpTot[c,r,y,s] >> "vTechInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "vTechOutTot.csv";
for{(c, r, y, s) in mTechOutTot : vTechOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTechOutTot[c,r,y,s] >> "vTechOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "vStorageInpTot.csv";
for{(c, r, y, s) in mStorageInpTot : vStorageInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vStorageInpTot[c,r,y,s] >> "vStorageInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "vStorageOutTot.csv";
for{(c, r, y, s) in mStorageOutTot : vStorageOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vStorageOutTot[c,r,y,s] >> "vStorageOutTot.csv";
}
printf "stg,comm,region,year,slice,value\n" > "vStorageAInp.csv";
for{(st1, c) in mStorageAInp, (st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan : vStorageAInp[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageAInp[st1,c,r,y,s] >> "vStorageAInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "vStorageAOut.csv";
for{(st1, c) in mStorageAOut, (st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan : vStorageAOut[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageAOut[st1,c,r,y,s] >> "vStorageAOut.csv";
}
printf "region,year,value\n" > "vCost.csv";
for{y in mMidMilestone, r in region : vCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vCost[r,y] >> "vCost.csv";
}
printf "comm,region,year,slice,value\n" > "vDummyImport.csv";
for{(c, r, y, s) in mDummyImport : vDummyImport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDummyImport[c,r,y,s] >> "vDummyImport.csv";
}
printf "comm,region,year,slice,value\n" > "vDummyExport.csv";
for{(c, r, y, s) in mDummyExport : vDummyExport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDummyExport[c,r,y,s] >> "vDummyExport.csv";
}
printf "comm,region,year,value\n" > "vDummyCost.csv";
for{(c, r, y) in mDummyCost : vDummyCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vDummyCost[c,r,y] >> "vDummyCost.csv";
}
printf "comm,region,year,value\n" > "vTaxCost.csv";
for{(c, r, y) in mTaxCost : vTaxCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vTaxCost[c,r,y] >> "vTaxCost.csv";
}
printf "comm,region,year,value\n" > "vSubsCost.csv";
for{(c, r, y) in mSubsCost : vSubsCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vSubsCost[c,r,y] >> "vSubsCost.csv";
}
printf "comm,region,year,slice,value\n" > "vAggOut.csv";
for{(c, r, y, s) in mAggOut : vAggOut[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vAggOut[c,r,y,s] >> "vAggOut.csv";
}
printf "stg,comm,region,year,slice,value\n" > "vStorageInp.csv";
for{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : vStorageInp[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageInp[st1,c,r,y,s] >> "vStorageInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "vStorageOut.csv";
for{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : vStorageOut[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageOut[st1,c,r,y,s] >> "vStorageOut.csv";
}
printf "stg,comm,region,year,slice,value\n" > "vStorageStore.csv";
for{(st1, s) in mStorageSlice, (st1, r, y) in mStorageSpan, (st1, c) in mStorageComm : vStorageStore[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageStore[st1,c,r,y,s] >> "vStorageStore.csv";
}
printf "stg,region,year,value\n" > "vStorageInv.csv";
for{(st1, r, y) in mStorageNew : vStorageInv[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageInv[st1,r,y] >> "vStorageInv.csv";
}
printf "stg,region,year,value\n" > "vStorageCap.csv";
for{(st1, r, y) in mStorageSpan : vStorageCap[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageCap[st1,r,y] >> "vStorageCap.csv";
}
printf "stg,region,year,value\n" > "vStorageNewCap.csv";
for{(st1, r, y) in mStorageNew : vStorageNewCap[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageNewCap[st1,r,y] >> "vStorageNewCap.csv";
}
printf "stg,region,value\n" > "vStorageSalv.csv";
for{st1 in stg, r in region : vStorageSalv[st1,r] <> 0} {
  printf "%s,%s,%f\n", st1,r,vStorageSalv[st1,r] >> "vStorageSalv.csv";
}
printf "stg,region,year,value\n" > "vStorageOMCost.csv";
for{(st1, r, y) in mStorageSpan : vStorageOMCost[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageOMCost[st1,r,y] >> "vStorageOMCost.csv";
}
printf "comm,region,year,slice,value\n" > "vImport.csv";
for{(c, r, y, s) in mImport : vImport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vImport[c,r,y,s] >> "vImport.csv";
}
printf "comm,region,year,slice,value\n" > "vExport.csv";
for{(c, r, y, s) in mExport : vExport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vExport[c,r,y,s] >> "vExport.csv";
}
printf "trade,comm,src,dst,year,slice,value\n" > "vTradeIr.csv";
for{(t1, src, dst, y, s) in mTradeIr, (t1, c) in mTradeComm : vTradeIr[t1,c,src,dst,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%s,%f\n", t1,c,src,dst,y,s,vTradeIr[t1,c,src,dst,y,s] >> "vTradeIr.csv";
}
printf "trade,comm,region,year,slice,value\n" > "vTradeIrAInp.csv";
for{(t1, c, r, y, s) in mTradeIrAInp2 : vTradeIrAInp[t1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s,vTradeIrAInp[t1,c,r,y,s] >> "vTradeIrAInp.csv";
}
printf "comm,region,year,slice,value\n" > "vTradeIrAInpTot.csv";
for{(c, r, y, s) in mTradeIrAInpTot : vTradeIrAInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTradeIrAInpTot[c,r,y,s] >> "vTradeIrAInpTot.csv";
}
printf "trade,comm,region,year,slice,value\n" > "vTradeIrAOut.csv";
for{(t1, c, r, y, s) in mTradeIrAOut2 : vTradeIrAOut[t1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s,vTradeIrAOut[t1,c,r,y,s] >> "vTradeIrAOut.csv";
}
printf "comm,region,year,slice,value\n" > "vTradeIrAOutTot.csv";
for{(c, r, y, s) in mTradeIrAOutTot : vTradeIrAOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTradeIrAOutTot[c,r,y,s] >> "vTradeIrAOutTot.csv";
}
printf "expp,comm,value\n" > "vExportRowAccumulated.csv";
for{(e, c) in mExpComm : vExportRowAccumulated[e,c] <> 0} {
  printf "%s,%s,%f\n", e,c,vExportRowAccumulated[e,c] >> "vExportRowAccumulated.csv";
}
printf "expp,comm,region,year,slice,value\n" > "vExportRow.csv";
for{(e, c, r, y, s) in mExportRow : vExportRow[e,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", e,c,r,y,s,vExportRow[e,c,r,y,s] >> "vExportRow.csv";
}
printf "imp,comm,value\n" > "vImportRowAccumulated.csv";
for{(i, c) in mImpComm : vImportRowAccumulated[i,c] <> 0} {
  printf "%s,%s,%f\n", i,c,vImportRowAccumulated[i,c] >> "vImportRowAccumulated.csv";
}
printf "imp,comm,region,year,slice,value\n" > "vImportRow.csv";
for{(i, c, r, y, s) in mImportRow : vImportRow[i,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", i,c,r,y,s,vImportRow[i,c,r,y,s] >> "vImportRow.csv";
}
printf "region,year,value\n" > "vTradeCost.csv";
for{y in mMidMilestone, r in region : vTradeCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeCost[r,y] >> "vTradeCost.csv";
}
printf "region,year,value\n" > "vTradeRowCost.csv";
for{y in mMidMilestone, r in region : vTradeRowCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeRowCost[r,y] >> "vTradeRowCost.csv";
}
printf "region,year,value\n" > "vTradeIrCost.csv";
for{y in mMidMilestone, r in region : vTradeIrCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeIrCost[r,y] >> "vTradeIrCost.csv";
}
printf "trade,src,dst,value\n" > "vTradeSalv.csv";
for{t1 in trade, src in region, dst in region : vTradeSalv[t1,src,dst] <> 0} {
  printf "%s,%s,%s,%f\n", t1,src,dst,vTradeSalv[t1,src,dst] >> "vTradeSalv.csv";
}
printf "trade,src,dst,year,value\n" > "vTradeCap.csv";
for{(t1, src, dst, y) in mTradeSpan : t1 in mTradeCapacityVariable and y in mMidMilestonevTradeCap[t1,src,dst,y] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t1,src,dst,y,vTradeCap[t1,src,dst,y] >> "vTradeCap.csv";
}
printf "trade,src,dst,year,value\n" > "vTradeInv.csv";
for{(t1, src, dst, y) in mTradeNew : t1 in mTradeCapacityVariable and y in mMidMilestonevTradeInv[t1,src,dst,y] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t1,src,dst,y,vTradeInv[t1,src,dst,y] >> "vTradeInv.csv";
}
printf "trade,src,dst,year,value\n" > "vTradeNewCap.csv";
for{(t1, src, dst, y) in mTradeNew : t1 in mTradeCapacityVariable and y in mMidMilestonevTradeNewCap[t1,src,dst,y] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t1,src,dst,y,vTradeNewCap[t1,src,dst,y] >> "vTradeNewCap.csv";
}
printf "value\n%s\n",vObjective > "vObjective.csv";


printf "value\n" > "variable_list.csv";
    printf "vTechInv\n" >> "variable_list.csv";
    printf "vTechEac\n" >> "variable_list.csv";
    printf "vTechSalv\n" >> "variable_list.csv";
    printf "vTechOMCost\n" >> "variable_list.csv";
    printf "vSupCost\n" >> "variable_list.csv";
    printf "vEmsFuelTot\n" >> "variable_list.csv";
    printf "vTechEmsFuel\n" >> "variable_list.csv";
    printf "vBalance\n" >> "variable_list.csv";
    printf "vCost\n" >> "variable_list.csv";
    printf "vObjective\n" >> "variable_list.csv";
    printf "vTaxCost\n" >> "variable_list.csv";
    printf "vSubsCost\n" >> "variable_list.csv";
    printf "vAggOut\n" >> "variable_list.csv";
    printf "vStorageSalv\n" >> "variable_list.csv";
    printf "vStorageOMCost\n" >> "variable_list.csv";
    printf "vTradeCost\n" >> "variable_list.csv";
    printf "vTradeRowCost\n" >> "variable_list.csv";
    printf "vTradeIrCost\n" >> "variable_list.csv";
    printf "vTradeSalv\n" >> "variable_list.csv";
    printf "vTechUse\n" >> "variable_list.csv";
    printf "vTechNewCap\n" >> "variable_list.csv";
    printf "vTechRetiredCap\n" >> "variable_list.csv";
    printf "vTechCap\n" >> "variable_list.csv";
    printf "vTechAct\n" >> "variable_list.csv";
    printf "vTechInp\n" >> "variable_list.csv";
    printf "vTechOut\n" >> "variable_list.csv";
    printf "vTechAInp\n" >> "variable_list.csv";
    printf "vTechAOut\n" >> "variable_list.csv";
    printf "vSupOut\n" >> "variable_list.csv";
    printf "vSupReserve\n" >> "variable_list.csv";
    printf "vDemInp\n" >> "variable_list.csv";
    printf "vOutTot\n" >> "variable_list.csv";
    printf "vInpTot\n" >> "variable_list.csv";
    printf "vInp2Lo\n" >> "variable_list.csv";
    printf "vOut2Lo\n" >> "variable_list.csv";
    printf "vSupOutTot\n" >> "variable_list.csv";
    printf "vTechInpTot\n" >> "variable_list.csv";
    printf "vTechOutTot\n" >> "variable_list.csv";
    printf "vStorageInpTot\n" >> "variable_list.csv";
    printf "vStorageOutTot\n" >> "variable_list.csv";
    printf "vStorageAInp\n" >> "variable_list.csv";
    printf "vStorageAOut\n" >> "variable_list.csv";
    printf "vDummyImport\n" >> "variable_list.csv";
    printf "vDummyExport\n" >> "variable_list.csv";
    printf "vDummyCost\n" >> "variable_list.csv";
    printf "vStorageInp\n" >> "variable_list.csv";
    printf "vStorageOut\n" >> "variable_list.csv";
    printf "vStorageStore\n" >> "variable_list.csv";
    printf "vStorageInv\n" >> "variable_list.csv";
    printf "vStorageCap\n" >> "variable_list.csv";
    printf "vStorageNewCap\n" >> "variable_list.csv";
    printf "vImport\n" >> "variable_list.csv";
    printf "vExport\n" >> "variable_list.csv";
    printf "vTradeIr\n" >> "variable_list.csv";
    printf "vTradeIrAInp\n" >> "variable_list.csv";
    printf "vTradeIrAInpTot\n" >> "variable_list.csv";
    printf "vTradeIrAOut\n" >> "variable_list.csv";
    printf "vTradeIrAOutTot\n" >> "variable_list.csv";
    printf "vExportRowAccumulated\n" >> "variable_list.csv";
    printf "vExportRow\n" >> "variable_list.csv";
    printf "vImportRowAccumulated\n" >> "variable_list.csv";
    printf "vImportRow\n" >> "variable_list.csv";
    printf "vTradeCap\n" >> "variable_list.csv";
    printf "vTradeInv\n" >> "variable_list.csv";
    printf "vTradeNewCap\n" >> "variable_list.csv";


printf "set,value\n" > "raw_data_set.csv";
for {t in tech} {
    printf "tech,%s\n", t >> "raw_data_set.csv";
}
for {s1 in sup} {
    printf "sup,%s\n", s1 >> "raw_data_set.csv";
}
for {d in dem} {
    printf "dem,%s\n", d >> "raw_data_set.csv";
}
for {st1 in stg} {
    printf "stg,%s\n", st1 >> "raw_data_set.csv";
}
for {e in expp} {
    printf "expp,%s\n", e >> "raw_data_set.csv";
}
for {i in imp} {
    printf "imp,%s\n", i >> "raw_data_set.csv";
}
for {t1 in trade} {
    printf "trade,%s\n", t1 >> "raw_data_set.csv";
}
for {g in group} {
    printf "group,%s\n", g >> "raw_data_set.csv";
}
for {c in comm} {
    printf "comm,%s\n", c >> "raw_data_set.csv";
}
for {r in region} {
    printf "region,%s\n", r >> "raw_data_set.csv";
}
for {y in mMidMilestone} {
    printf "year,%s\n", y >> "raw_data_set.csv";
}
for {s in slice} {
    printf "slice,%s\n", s >> "raw_data_set.csv";
}
for {wth1 in weather} {
    printf "weather,%s\n", wth1 >> "raw_data_set.csv";
}
end;


