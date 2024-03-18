printf "parameter,value,time\n" > "output/log.csv";
printf  '"model language",glpk,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
printf  '"model definition",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
set comm;
set region;
set year;
set slice;
set sup;
set dem;
set tech;
set stg;
set trade;
set expp;
set imp;
set group;
set weather;
set FORIF;



set mCommReg dimen 2;
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
set mCommSliceOrParent dimen 3;
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
set mTechSlice dimen 2;
set mSupSlice dimen 2;
set mSupComm dimen 2;
set mSupSpan dimen 2;
set mDemComm dimen 2;
set mUpComm dimen 1;
set mLoComm dimen 1;
set mFxComm dimen 1;
set mStorageFullYear dimen 1;
set mStorageComm dimen 2;
set mStorageAInp dimen 2;
set mStorageAOut dimen 2;
set mStorageNew dimen 3;
set mStorageSpan dimen 3;
set mStorageOMCost dimen 3;
set mStorageEac dimen 3;
set mSliceNext dimen 2;
set mSliceFYearNext dimen 2;
set mTradeSlice dimen 2;
set mTradeComm dimen 2;
set mTradeRoutes dimen 3;
set mTradeIrAInp dimen 2;
set mTradeIrAOut dimen 2;
set mExpComm dimen 2;
set mImpComm dimen 2;
set mExpSlice dimen 2;
set mImpSlice dimen 2;
set mDiscountZero dimen 1;
set mSliceParentChildE dimen 2;
set mSliceParentChild dimen 2;
set mTradeSpan dimen 2;
set mTradeNew dimen 2;
set mTradeOlifeInf dimen 1;
set mTradeEac dimen 3;
set mTradeCapacityVariable dimen 1;
set mTradeInv dimen 3;
set mAggregateFactor dimen 2;
set mWeatherSlice dimen 2;
set mWeatherRegion dimen 2;
set mSupWeatherLo dimen 2;
set mSupWeatherUp dimen 2;
set mTechWeatherAfLo dimen 2;
set mTechWeatherAfUp dimen 2;
set mTechWeatherAfsLo dimen 2;
set mTechWeatherAfsUp dimen 2;
set mTechWeatherAfcLo dimen 3;
set mTechWeatherAfcUp dimen 3;
set mStorageWeatherAfLo dimen 2;
set mStorageWeatherAfUp dimen 2;
set mStorageWeatherCinpUp dimen 2;
set mStorageWeatherCinpLo dimen 2;
set mStorageWeatherCoutUp dimen 2;
set mStorageWeatherCoutLo dimen 2;
set mvSupCost dimen 3;
set mvTechInp dimen 5;
set mvSupReserve dimen 3;
set mvTechRetiredNewCap dimen 4;
set mvTechRetiredStock dimen 3;
set mvTechAct dimen 4;
set mvTechInpCommSameSlice dimen 5;
set mvTechOut dimen 5;
set mvTechAInp dimen 5;
set mvTechAOut dimen 5;
set mvDemInp dimen 4;
set mvBalance dimen 4;
set mvInpTot dimen 4;
set mvOutTot dimen 4;
set mvInp2Lo dimen 5;
set mvOut2Lo dimen 5;
set mInpSub dimen 4;
set mOutSub dimen 4;
set mTechCapLo dimen 3;
set mTechCapUp dimen 3;
set mTechNewCapLo dimen 3;
set mTechNewCapUp dimen 3;
set mTechRetLo dimen 3;
set mTechRetUp dimen 3;
set mvStorageAInp dimen 5;
set mvStorageAOut dimen 5;
set mvStorageStore dimen 5;
set meqStorageStore dimen 6;
set mStorageStg2AOut dimen 5;
set mStorageCinp2AOut dimen 5;
set mStorageCout2AOut dimen 5;
set mStorageCap2AOut dimen 5;
set mStorageNCap2AOut dimen 5;
set mStorageStg2AInp dimen 5;
set mStorageCinp2AInp dimen 5;
set mStorageCout2AInp dimen 5;
set mStorageCap2AInp dimen 5;
set mStorageNCap2AInp dimen 5;
set mStorageCapLo dimen 3;
set mStorageCapUp dimen 3;
set mStorageNewCapLo dimen 3;
set mStorageNewCapUp dimen 3;
set mStorageRetLo dimen 3;
set mStorageRetUp dimen 3;
set mvTradeIr dimen 6;
set mTradeIrCsrc2Ainp dimen 6;
set mTradeIrCdst2Ainp dimen 6;
set mTradeIrCsrc2Aout dimen 6;
set mTradeIrCdst2Aout dimen 6;
set mvTradeCost dimen 2;
set mvTradeRowCost dimen 2;
set mvTradeIrCost dimen 2;
set mvTotalCost dimen 2;
set mvTotalUserCosts dimen 2;
set mTradeCapLo dimen 2;
set mTradeCapUp dimen 2;
set mTradeNewCapLo dimen 2;
set mTradeNewCapUp dimen 2;
set mTradeRetLo dimen 2;
set mTradeRetUp dimen 2;
set mTechInv dimen 3;
set mTechInpTot dimen 4;
set mTechInpCommSameSlice dimen 2;
set mTechInpCommAgg dimen 2;
set mTechInpCommAggSlice dimen 4;
set mTechAInpCommSameSlice dimen 2;
set mTechAInpCommAgg dimen 2;
set mTechAInpCommAggSlice dimen 4;
set mTechOutTot dimen 4;
set mTechOutCommSameSlice dimen 2;
set mTechOutCommAgg dimen 2;
set mTechOutCommAggSlice dimen 4;
set mTechAOutCommSameSlice dimen 2;
set mTechAOutCommAgg dimen 2;
set mTechAOutCommAggSlice dimen 4;
set mTechEac dimen 3;
set mTechOMCost dimen 3;
set mSupOutTot dimen 4;
set mEmsFuelTot dimen 4;
set mTechEmsFuel dimen 6;
set mDummyImport dimen 4;
set mDummyExport dimen 4;
set mDummyCost dimen 3;
set mTradeIr dimen 5;
set mvTradeIrAInp dimen 5;
set mvTradeIrAInpTot dimen 4;
set mvTradeIrAOut dimen 5;
set mvTradeIrAOutTot dimen 4;
set mImportRow dimen 5;
set mImportRowUp dimen 5;
set mImportRowCumUp dimen 2;
set mExportRow dimen 5;
set mExportRowUp dimen 5;
set mExportRowCumUp dimen 2;
set mExport dimen 4;
set mImport dimen 4;
set mStorageInpTot dimen 4;
set mStorageOutTot dimen 4;
set mTaxCost dimen 3;
set mSubCost dimen 3;
set mAggOut dimen 4;
set mTechAfUp dimen 4;
set mTechFullYear dimen 1;
set mTechRampUp dimen 5;
set mTechRampDown dimen 5;
set mTechCommOutSliceSliceP dimen 4;
set mTechCommAOutSliceSliceP dimen 4;
set mTechOlifeInf dimen 2;
set mStorageOlifeInf dimen 2;
set mTechAfcUp dimen 5;
set mSupAvaUp dimen 5;
set mSupAva dimen 5;
set mSupReserveUp dimen 3;
set mOut2Lo dimen 4;
set mInp2Lo dimen 4;
set meqTechRetiredNewCap dimen 3;
set meqTechSng2Sng dimen 6;
set meqTechGrp2Sng dimen 6;
set meqTechSng2Grp dimen 6;
set meqTechGrp2Grp dimen 6;
set meqTechShareInpLo dimen 6;
set meqTechShareInpUp dimen 6;
set meqTechShareOutLo dimen 6;
set meqTechShareOutUp dimen 6;
set meqTechAfLo dimen 4;
set meqTechAfUp dimen 4;
set meqTechAfsLo dimen 4;
set meqTechAfsUp dimen 4;
set meqTechActSng dimen 5;
set meqTechActGrp dimen 5;
set meqTechAfcOutLo dimen 5;
set meqTechAfcOutUp dimen 5;
set meqTechAfcInpLo dimen 5;
set meqTechAfcInpUp dimen 5;
set meqSupAvaLo dimen 5;
set meqSupReserveLo dimen 3;
set meqStorageAfLo dimen 5;
set meqStorageAfUp dimen 5;
set meqStorageInpUp dimen 5;
set meqStorageInpLo dimen 5;
set meqStorageOutUp dimen 5;
set meqStorageOutLo dimen 5;
set meqTradeFlowUp dimen 6;
set meqTradeFlowLo dimen 6;
set meqExportRowLo dimen 5;
set meqImportRowUp dimen 5;
set meqImportRowLo dimen 5;
set meqTradeCapFlow dimen 4;
set meqBalLo dimen 4;
set meqBalUp dimen 4;
set meqBalFx dimen 4;
set meqLECActivity dimen 3;
set mTechAct2AInp dimen 5;
set mTechCap2AInp dimen 5;
set mTechNCap2AInp dimen 5;
set mTechCinp2AInp dimen 6;
set mTechCout2AInp dimen 6;
set mTechAct2AOut dimen 5;
set mTechCap2AOut dimen 5;
set mTechNCap2AOut dimen 5;
set mTechCinp2AOut dimen 6;
set mTechCout2AOut dimen 6;
set mLECRegion dimen 1;




param pYearFraction{year};
param pTechOlife{tech, region};
param pTechCinp2ginp{tech, comm, region, year, slice};
param pTechGinp2use{tech, group, region, year, slice};
param pTechCinp2use{tech, comm, region, year, slice};
param pTechUse2cact{tech, comm, region, year, slice};
param pTechCact2cout{tech, comm, region, year, slice};
param pTechEmisComm{tech, comm};
param pTechAct2AInp{tech, comm, region, year, slice};
param pTechCap2AInp{tech, comm, region, year, slice};
param pTechNCap2AInp{tech, comm, region, year, slice};
param pTechCinp2AInp{tech, comm, comm, region, year, slice};
param pTechCout2AInp{tech, comm, comm, region, year, slice};
param pTechAct2AOut{tech, comm, region, year, slice};
param pTechCap2AOut{tech, comm, region, year, slice};
param pTechNCap2AOut{tech, comm, region, year, slice};
param pTechCinp2AOut{tech, comm, comm, region, year, slice};
param pTechCout2AOut{tech, comm, comm, region, year, slice};
param pTechFixom{tech, region, year};
param pTechVarom{tech, region, year, slice};
param pTechInvcost{tech, region, year};
param pTechEac{tech, region, year};
param pTechRetCost{tech, region, year};
param pTechShareLo{tech, comm, region, year, slice};
param pTechShareUp{tech, comm, region, year, slice};
param pTechAfLo{tech, region, year, slice};
param pTechAfUp{tech, region, year, slice};
param pTechRampUp{tech, region, year, slice};
param pTechRampDown{tech, region, year, slice};
param pTechAfsLo{tech, region, year, slice};
param pTechAfsUp{tech, region, year, slice};
param pTechAfcLo{tech, comm, region, year, slice};
param pTechAfcUp{tech, comm, region, year, slice};
param pTechStock{tech, region, year};
param pTechCapUp{tech, region, year};
param pTechCapLo{tech, region, year};
param pTechNewCapUp{tech, region, year};
param pTechNewCapLo{tech, region, year};
param pTechRetUp{tech, region, year};
param pTechRetLo{tech, region, year};
param pTechCap2act{tech};
param pTechCvarom{tech, comm, region, year, slice};
param pTechAvarom{tech, comm, region, year, slice};
param pDiscount{region, year};
param pDiscountFactor{region, year};
param pDiscountFactorMileStone{region, year};
param pSupCost{sup, comm, region, year, slice};
param pSupAvaUp{sup, comm, region, year, slice};
param pSupAvaLo{sup, comm, region, year, slice};
param pSupReserveUp{sup, comm, region};
param pSupReserveLo{sup, comm, region};
param pDemand{dem, comm, region, year, slice};
param pEmissionFactor{comm, comm};
param pDummyImportCost{comm, region, year, slice};
param pDummyExportCost{comm, region, year, slice};
param pTaxCostInp{comm, region, year, slice};
param pTaxCostOut{comm, region, year, slice};
param pTaxCostBal{comm, region, year, slice};
param pSubCostInp{comm, region, year, slice};
param pSubCostOut{comm, region, year, slice};
param pSubCostBal{comm, region, year, slice};
param pAggregateFactor{comm, comm};
param pPeriodLen{year};
param pSliceShare{slice};
param pSliceWeight{slice};
param ordYear{year};
param cardYear{year};
param pStorageInpEff{stg, comm, region, year, slice};
param pStorageOutEff{stg, comm, region, year, slice};
param pStorageStgEff{stg, comm, region, year, slice};
param pStorageStock{stg, region, year};
param pStorageCapUp{stg, region, year};
param pStorageCapLo{stg, region, year};
param pStorageNewCapUp{stg, region, year};
param pStorageNewCapLo{stg, region, year};
param pStorageRetUp{stg, region, year};
param pStorageRetLo{stg, region, year};
param pStorageOlife{stg, region};
param pStorageCostStore{stg, region, year, slice};
param pStorageCostInp{stg, region, year, slice};
param pStorageCostOut{stg, region, year, slice};
param pStorageFixom{stg, region, year};
param pStorageInvcost{stg, region, year};
param pStorageEac{stg, region, year};
param pStorageRetCost{stg, region, year};
param pStorageCap2stg{stg};
param pStorageAfLo{stg, region, year, slice};
param pStorageAfUp{stg, region, year, slice};
param pStorageCinpUp{stg, comm, region, year, slice};
param pStorageCinpLo{stg, comm, region, year, slice};
param pStorageCoutUp{stg, comm, region, year, slice};
param pStorageCoutLo{stg, comm, region, year, slice};
param pStorageNCap2Stg{stg, comm, region, year, slice};
param pStorageCharge{stg, comm, region, year, slice};
param pStorageStg2AInp{stg, comm, region, year, slice};
param pStorageStg2AOut{stg, comm, region, year, slice};
param pStorageCinp2AInp{stg, comm, region, year, slice};
param pStorageCinp2AOut{stg, comm, region, year, slice};
param pStorageCout2AInp{stg, comm, region, year, slice};
param pStorageCout2AOut{stg, comm, region, year, slice};
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
param pTradeStock{trade, year};
param pTradeCapUp{trade, year};
param pTradeCapLo{trade, year};
param pTradeNewCapUp{trade, year};
param pTradeNewCapLo{trade, year};
param pTradeRetUp{trade, year};
param pTradeRetLo{trade, year};
param pTradeOlife{trade};
param pTradeInvcost{trade, region, year};
param pTradeEac{trade, region, year};
param pTradeRetCost{trade, region, year};
param pTradeFixom{trade, year};
param pTradeVarom{trade, region, region, year, slice};
param pTradeCap2Act{trade};
param pWeather{weather, region, year, slice};
param pSupWeatherUp{weather, sup};
param pSupWeatherLo{weather, sup};
param pTechWeatherAfLo{weather, tech};
param pTechWeatherAfUp{weather, tech};
param pTechWeatherAfsLo{weather, tech};
param pTechWeatherAfsUp{weather, tech};
param pTechWeatherAfcLo{weather, tech, comm};
param pTechWeatherAfcUp{weather, tech, comm};
param pStorageWeatherAfLo{weather, stg};
param pStorageWeatherAfUp{weather, stg};
param pStorageWeatherCinpUp{weather, stg};
param pStorageWeatherCinpLo{weather, stg};
param pStorageWeatherCoutUp{weather, stg};
param pStorageWeatherCoutLo{weather, stg};
param pLECLoACT{region};
param ORD{year};



var vTechInv{tech, region, year};
var vTechEac{tech, region, year};
var vTechOMCost{tech, region, year};
var vSupCost{sup, region, year};
var vEmsFuelTot{comm, region, year, slice};
var vBalance{comm, region, year, slice};
var vTotalCost{region, year};
var vObjective;
var vTaxCost{comm, region, year};
var vSubsCost{comm, region, year};
var vAggOutTot{comm, region, year, slice};
var vStorageOMCost{stg, region, year};
var vTradeCost{region, year};
var vTradeRowCost{region, year};
var vTradeIrCost{region, year};




var vTechNewCap{tech, region, year} >= 0;
var vTechRetiredStockCum{tech, region, year} >= 0;
var vTechRetiredStock{tech, region, year} >= 0;
var vTechRetiredNewCap{tech, region, year, year} >= 0;
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
var vStorageInp{stg, comm, region, year, slice} >= 0;
var vStorageOut{stg, comm, region, year, slice} >= 0;
var vStorageStore{stg, comm, region, year, slice} >= 0;
var vStorageInv{stg, region, year} >= 0;
var vStorageEac{stg, region, year} >= 0;
var vStorageCap{stg, region, year} >= 0;
var vStorageNewCap{stg, region, year} >= 0;
var vImportTot{comm, region, year, slice} >= 0;
var vExportTot{comm, region, year, slice} >= 0;
var vTradeIr{trade, comm, region, region, year, slice} >= 0;
var vTradeIrAInp{trade, comm, region, year, slice} >= 0;
var vTradeIrAInpTot{comm, region, year, slice} >= 0;
var vTradeIrAOut{trade, comm, region, year, slice} >= 0;
var vTradeIrAOutTot{comm, region, year, slice} >= 0;
var vExportRowCum{expp, comm} >= 0;
var vExportRow{expp, comm, region, year, slice} >= 0;
var vImportRowCum{imp, comm} >= 0;
var vImportRow{imp, comm, region, year, slice} >= 0;
var vTradeCap{trade, year} >= 0;
var vTradeInv{trade, region, year} >= 0;
var vTradeEac{trade, region, year} >= 0;
var vTradeNewCap{trade, year} >= 0;
var vTotalUserCosts{region, year} >= 0;




# Guid for add equation and add mapping & parameter to constrain
# 22b584bd-a17a-4fa0-9cd9-f603ab684e47
s.t.  eqTechSng2Sng{(t, r, c, cp, y, s) in meqTechSng2Sng}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechGrp2Sng{(t, r, g, cp, y, s) in meqTechGrp2Sng}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:((t,g,c) in mTechGroupComm)}(sum{FORIF: (t,c,r,y,s) in mvTechInp} ((vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])))  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechSng2Grp{(t, r, c, gp, y, s) in meqTechSng2Grp}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  sum{cp in comm:((t,gp,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechOut} (((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]))));

s.t.  eqTechGrp2Grp{(t, r, g, gp, y, s) in meqTechGrp2Grp}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:((t,g,c) in mTechGroupComm)}(sum{FORIF: (t,c,r,y,s) in mvTechInp} ((vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])))  =  sum{cp in comm:((t,gp,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechOut} (((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]))));

s.t.  eqTechShareInpLo{(t, r, g, c, y, s) in meqTechShareInpLo}: vTechInp[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:((t,g,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechInp} (vTechInp[t,cp,r,y,s]));

s.t.  eqTechShareInpUp{(t, r, g, c, y, s) in meqTechShareInpUp}: vTechInp[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:((t,g,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechInp} (vTechInp[t,cp,r,y,s]));

s.t.  eqTechShareOutLo{(t, r, g, c, y, s) in meqTechShareOutLo}: vTechOut[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:((t,g,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechOut} (vTechOut[t,cp,r,y,s]));

s.t.  eqTechShareOutUp{(t, r, g, c, y, s) in meqTechShareOutUp}: vTechOut[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:((t,g,cp) in mTechGroupComm)}(sum{FORIF: (t,cp,r,y,s) in mvTechOut} (vTechOut[t,cp,r,y,s]));

s.t.  eqTechAInp{(t, c, r, y, s) in mvTechAInp}: vTechAInp[t,c,r,y,s]  =  sum{FORIF: (t,c,r,y,s) in mTechAct2AInp} ((vTechAct[t,r,y,s]*pTechAct2AInp[t,c,r,y,s]))+sum{FORIF: (t,c,r,y,s) in mTechCap2AInp} ((vTechCap[t,r,y]*pTechCap2AInp[t,c,r,y,s]))+sum{FORIF: (t,c,r,y,s) in mTechNCap2AInp} ((vTechNewCap[t,r,y]*pTechNCap2AInp[t,c,r,y,s]))+sum{cp in comm:((t,c,cp,r,y,s) in mTechCinp2AInp)}(pTechCinp2AInp[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:((t,c,cp,r,y,s) in mTechCout2AInp)}(pTechCout2AInp[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAOut{(t, c, r, y, s) in mvTechAOut}: vTechAOut[t,c,r,y,s]  =  sum{FORIF: (t,c,r,y,s) in mTechAct2AOut} ((vTechAct[t,r,y,s]*pTechAct2AOut[t,c,r,y,s]))+sum{FORIF: (t,c,r,y,s) in mTechCap2AOut} ((vTechCap[t,r,y]*pTechCap2AOut[t,c,r,y,s]))+sum{FORIF: (t,c,r,y,s) in mTechNCap2AOut} ((vTechNewCap[t,r,y]*pTechNCap2AOut[t,c,r,y,s]))+sum{cp in comm:((t,c,cp,r,y,s) in mTechCinp2AOut)}(pTechCinp2AOut[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:((t,c,cp,r,y,s) in mTechCout2AOut)}(pTechCout2AOut[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAfLo{(t, r, y, s) in meqTechAfLo}: pTechAfLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t) in mTechWeatherAfLo)}(pTechWeatherAfLo[wth1,t]*pWeather[wth1,r,y,s]) <=  vTechAct[t,r,y,s];

s.t.  eqTechAfUp{(t, r, y, s) in meqTechAfUp}: vTechAct[t,r,y,s] <=  pTechAfUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t) in mTechWeatherAfUp)}(pTechWeatherAfUp[wth1,t]*pWeather[wth1,r,y,s]);

s.t.  eqTechAfsLo{(t, r, y, s) in meqTechAfsLo}: pTechAfsLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t) in mTechWeatherAfsLo)}(pTechWeatherAfsLo[wth1,t]*pWeather[wth1,r,y,s]) <=  sum{sp in slice:((s,sp) in mSliceParentChildE)}(sum{FORIF: (t,r,y,sp) in mvTechAct} (vTechAct[t,r,y,sp]));

s.t.  eqTechAfsUp{(t, r, y, s) in meqTechAfsUp}: sum{sp in slice:((s,sp) in mSliceParentChildE)}(sum{FORIF: (t,r,y,sp) in mvTechAct} (vTechAct[t,r,y,sp])) <=  pTechAfsUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t) in mTechWeatherAfsUp)}(pTechWeatherAfsUp[wth1,t]*pWeather[wth1,r,y,s]);

s.t.  eqTechRampUp{(t, r, y, s, sp) in mTechRampUp}: (vTechAct[t,r,y,s]) / (pSliceShare[s])-(vTechAct[t,r,y,sp]) / (pSliceShare[sp]) <=  (pSliceShare[s]*pTechCap2act[t]*pTechCap2act[t]*vTechCap[t,r,y]) / (pTechRampUp[t,r,y,s]);

s.t.  eqTechRampDown{(t, r, y, s, sp) in mTechRampDown}: (vTechAct[t,r,y,sp]) / (pSliceShare[sp])-(vTechAct[t,r,y,s]) / (pSliceShare[s]) <=  (pSliceShare[s]*pTechCap2act[t]*pTechCap2act[t]*vTechCap[t,r,y]) / (pTechRampDown[t,r,y,s]);

s.t.  eqTechActSng{(t, c, r, y, s) in meqTechActSng}: vTechAct[t,r,y,s]  =  (vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]);

s.t.  eqTechActGrp{(t, g, r, y, s) in meqTechActGrp}: vTechAct[t,r,y,s]  =  sum{c in comm:((t,g,c) in mTechGroupComm)}(sum{FORIF: (t,c,r,y,s) in mvTechOut} (((vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]))));

s.t.  eqTechAfcOutLo{(t, r, c, y, s) in meqTechAfcOutLo}: pTechCact2cout[t,c,r,y,s]*pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t,c) in mTechWeatherAfcLo)}(pTechWeatherAfcLo[wth1,t,c]*pWeather[wth1,r,y,s]) <=  vTechOut[t,c,r,y,s];

s.t.  eqTechAfcOutUp{(t, r, c, y, s) in meqTechAfcOutUp}: vTechOut[t,c,r,y,s] <=  pTechCact2cout[t,c,r,y,s]*pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*prod{wth1 in weather:((wth1,t,c) in mTechWeatherAfcUp)}(pTechWeatherAfcUp[wth1,t,c]*pWeather[wth1,r,y,s]);

s.t.  eqTechAfcInpLo{(t, r, c, y, s) in meqTechAfcInpLo}: pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t,c) in mTechWeatherAfcLo)}(pTechWeatherAfcLo[wth1,t,c]*pWeather[wth1,r,y,s]) <=  vTechInp[t,c,r,y,s];

s.t.  eqTechAfcInpUp{(t, r, c, y, s) in meqTechAfcInpUp}: vTechInp[t,c,r,y,s] <=  pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{wth1 in weather:((wth1,t,c) in mTechWeatherAfcUp)}(pTechWeatherAfcUp[wth1,t,c]*pWeather[wth1,r,y,s]);

s.t.  eqTechCap{(t, r, y) in mTechSpan}: vTechCap[t,r,y]  =  pTechStock[t,r,y]-sum{FORIF: (t,r,y) in mvTechRetiredStock} (vTechRetiredStockCum[t,r,y])+sum{yp in year:(((t,r,yp) in mTechNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[t,r]+ordYear[yp] or (t,r) in mTechOlifeInf)))}(pPeriodLen[yp]*(vTechNewCap[t,r,yp]-sum{ye in year:(((t,r,yp,ye) in mvTechRetiredNewCap and ordYear[y] >= ordYear[ye]))}(vTechRetiredNewCap[t,r,yp,ye])));

s.t.  eqTechCapLo{(t, r, y) in mTechCapLo}: vTechCap[t,r,y]  >=  pTechCapLo[t,r,y];

s.t.  eqTechCapUp{(t, r, y) in mTechCapUp}: vTechCap[t,r,y] <=  pTechCapUp[t,r,y];

s.t.  eqTechNewCapLo{(t, r, y) in mTechNewCapLo}: vTechNewCap[t,r,y]  >=  pTechNewCapLo[t,r,y];

s.t.  eqTechNewCapUp{(t, r, y) in mTechNewCapUp}: vTechNewCap[t,r,y] <=  pTechNewCapUp[t,r,y];

s.t.  eqTechRetiredNewCap{(t, r, y) in meqTechRetiredNewCap}: sum{yp in year:((t,r,y,yp) in mvTechRetiredNewCap)}(vTechRetiredNewCap[t,r,y,yp]) <=  vTechNewCap[t,r,y];

s.t.  eqTechRetiredStockCum{(t, r, y) in mvTechRetiredStock}: vTechRetiredStockCum[t,r,y] <=  pTechStock[t,r,y];

s.t.  eqTechRetiredStock{(t, r, y) in mvTechRetiredStock}: vTechRetiredStock[t,r,y]  =  vTechRetiredStockCum[t,r,y]-sum{yp in year:((yp,y) in mMilestoneNext)}(vTechRetiredStockCum[t,r,yp]);

s.t.  eqTechEac{(t, r, y) in mTechEac}: vTechEac[t,r,y]  =  sum{yp in year:(((t,r,yp) in mTechNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[t,r]+ordYear[yp] or (t,r) in mTechOlifeInf)))}(pTechEac[t,r,yp]*pPeriodLen[yp]*(vTechNewCap[t,r,yp]-sum{ye in year:(((t,r,yp,ye) in mvTechRetiredNewCap and ordYear[y] >= ordYear[ye]))}(vTechRetiredNewCap[t,r,yp,ye])));

s.t.  eqTechInv{(t, r, y) in mTechInv}: vTechInv[t,r,y]  =  pTechInvcost[t,r,y]*vTechNewCap[t,r,y];

s.t.  eqTechOMCost{(t, r, y) in mTechOMCost}: vTechOMCost[t,r,y]  =  pTechFixom[t,r,y]*vTechCap[t,r,y]+sum{s in slice:((t,s) in mTechSlice)}(pTechVarom[t,r,y,s]*pSliceWeight[s]*vTechAct[t,r,y,s]+sum{c in comm:((t,c) in mTechInpComm)}(pTechCvarom[t,c,r,y,s]*pSliceWeight[s]*vTechInp[t,c,r,y,s])+sum{c in comm:((t,c) in mTechOutComm)}(pTechCvarom[t,c,r,y,s]*pSliceWeight[s]*vTechOut[t,c,r,y,s])+sum{c in comm:((t,c,r,y,s) in mvTechAOut)}(pTechAvarom[t,c,r,y,s]*pSliceWeight[s]*vTechAOut[t,c,r,y,s])+sum{c in comm:((t,c,r,y,s) in mvTechAInp)}(pTechAvarom[t,c,r,y,s]*pSliceWeight[s]*vTechAInp[t,c,r,y,s]));

s.t.  eqSupAvaUp{(s1, c, r, y, s) in mSupAvaUp}: vSupOut[s1,c,r,y,s] <=  pSupAvaUp[s1,c,r,y,s]*prod{wth1 in weather:((wth1,s1) in mSupWeatherUp)}(pSupWeatherUp[wth1,s1]*pWeather[wth1,r,y,s]);

s.t.  eqSupAvaLo{(s1, c, r, y, s) in meqSupAvaLo}: vSupOut[s1,c,r,y,s]  >=  pSupAvaLo[s1,c,r,y,s]*prod{wth1 in weather:((wth1,s1) in mSupWeatherLo)}(pSupWeatherLo[wth1,s1]*pWeather[wth1,r,y,s]);

s.t.  eqSupReserve{(s1, c, r) in mvSupReserve}: vSupReserve[s1,c,r]  =  sum{y in year,s in slice:((s1,c,r,y,s) in mSupAva)}(pPeriodLen[y]*pSliceWeight[s]*vSupOut[s1,c,r,y,s]);

s.t.  eqSupReserveUp{(s1, c, r) in mSupReserveUp}: vSupReserve[s1,c,r] <=  pSupReserveUp[s1,c,r];

s.t.  eqSupReserveLo{(s1, c, r) in meqSupReserveLo}: vSupReserve[s1,c,r]  >=  pSupReserveLo[s1,c,r];

s.t.  eqSupCost{(s1, r, y) in mvSupCost}: vSupCost[s1,r,y]  =  sum{c in comm,s in slice:((s1,c,r,y,s) in mSupAva)}(pSupCost[s1,c,r,y,s]*pSliceWeight[s]*vSupOut[s1,c,r,y,s]);

s.t.  eqDemInp{(c, r, y, s) in mvDemInp}: vDemInp[c,r,y,s]  =  sum{d in dem:((d,c) in mDemComm)}(pDemand[d,c,r,y,s]);

s.t.  eqAggOutTot{(c, r, y, s) in mAggOut}: vAggOutTot[c,r,y,s]  =  sum{cp in comm:((c,cp) in mAggregateFactor)}(pAggregateFactor[c,cp]*sum{sp in slice:(((c,r,y,sp) in mvOutTot and (s,sp) in mSliceParentChildE and (cp,sp) in mCommSlice))}(sum{FORIF: (cp,r,y,sp) in mvOutTot} (vOutTot[cp,r,y,sp])));

s.t.  eqEmsFuelTot{(c, r, y, s) in mEmsFuelTot}: vEmsFuelTot[c,r,y,s]  =  sum{cp in comm:((pEmissionFactor[c,cp]>0))}(pEmissionFactor[c,cp]*sum{t in tech:((t,cp) in mTechInpComm)}(pTechEmisComm[t,cp]*sum{sp in slice:((c,s,sp) in mCommSliceOrParent)}(sum{FORIF: (t,c,cp,r,y,sp) in mTechEmsFuel} (vTechInp[t,cp,r,y,sp]))))*pSliceWeight[s];

s.t.  eqStorageAInp{(st1, c, r, y, s) in mvStorageAInp}: vStorageAInp[st1,c,r,y,s]  =  sum{cp in comm:((st1,cp) in mStorageComm)}(sum{FORIF: (st1,c,r,y,s) in mStorageStg2AInp} ((pStorageStg2AInp[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCinp2AInp} ((pStorageCinp2AInp[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCout2AInp} ((pStorageCout2AInp[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCap2AInp} ((pStorageCap2AInp[st1,c,r,y,s]*vStorageCap[st1,r,y]))+sum{FORIF: (st1,c,r,y,s) in mStorageNCap2AInp} ((pStorageNCap2AInp[st1,c,r,y,s]*vStorageNewCap[st1,r,y])));

s.t.  eqStorageAOut{(st1, c, r, y, s) in mvStorageAOut}: vStorageAOut[st1,c,r,y,s]  =  sum{cp in comm:((st1,cp) in mStorageComm)}(sum{FORIF: (st1,c,r,y,s) in mStorageStg2AOut} ((pStorageStg2AOut[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCinp2AOut} ((pStorageCinp2AOut[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCout2AOut} ((pStorageCout2AOut[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]))+sum{FORIF: (st1,c,r,y,s) in mStorageCap2AOut} ((pStorageCap2AOut[st1,c,r,y,s]*vStorageCap[st1,r,y]))+sum{FORIF: (st1,c,r,y,s) in mStorageNCap2AOut} ((pStorageNCap2AOut[st1,c,r,y,s]*vStorageNewCap[st1,r,y])));

s.t.  eqStorageStore{(st1, c, r, y, sp, s) in meqStorageStore}: vStorageStore[st1,c,r,y,s]  =  pStorageCharge[st1,c,r,y,s]+sum{FORIF: (st1,r,y) in mStorageNew} ((pStorageNCap2Stg[st1,c,r,y,s]*vStorageNewCap[st1,r,y]))+pStorageInpEff[st1,c,r,y,sp]*vStorageInp[st1,c,r,y,sp]+((pStorageStgEff[st1,c,r,y,s])^(pSliceShare[s]))*vStorageStore[st1,c,r,y,sp]-(vStorageOut[st1,c,r,y,sp]) / (pStorageOutEff[st1,c,r,y,sp]);

s.t.  eqStorageAfLo{(st1, c, r, y, s) in meqStorageAfLo}: vStorageStore[st1,c,r,y,s]  >=  pStorageAfLo[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherAfLo)}(pStorageWeatherAfLo[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageAfUp{(st1, c, r, y, s) in meqStorageAfUp}: vStorageStore[st1,c,r,y,s] <=  pStorageAfUp[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherAfUp)}(pStorageWeatherAfUp[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageClear{(st1, c, r, y, s) in mvStorageStore}: (vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s]) <=  vStorageStore[st1,c,r,y,s];

s.t.  eqStorageInpUp{(st1, c, r, y, s) in meqStorageInpUp}: vStorageInp[st1,c,r,y,s] <=  vStorageCap[st1,r,y]*pStorageCinpUp[st1,c,r,y,s]*pSliceShare[s]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherCinpUp)}(pStorageWeatherCinpUp[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageInpLo{(st1, c, r, y, s) in meqStorageInpLo}: vStorageInp[st1,c,r,y,s]  >=  vStorageCap[st1,r,y]*pStorageCinpLo[st1,c,r,y,s]*pSliceShare[s]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherCinpLo)}(pStorageWeatherCinpLo[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageOutUp{(st1, c, r, y, s) in meqStorageOutUp}: vStorageOut[st1,c,r,y,s] <=  vStorageCap[st1,r,y]*pStorageCoutUp[st1,c,r,y,s]*pSliceShare[s]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherCoutUp)}(pStorageWeatherCoutUp[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageOutLo{(st1, c, r, y, s) in meqStorageOutLo}: vStorageOut[st1,c,r,y,s]  >=  vStorageCap[st1,r,y]*pStorageCoutLo[st1,c,r,y,s]*pSliceShare[s]*prod{wth1 in weather:((wth1,st1) in mStorageWeatherCoutLo)}(pStorageWeatherCoutLo[wth1,st1]*pWeather[wth1,r,y,s]);

s.t.  eqStorageCap{(st1, r, y) in mStorageSpan}: vStorageCap[st1,r,y]  =  pStorageStock[st1,r,y]+sum{yp in year:((ordYear[y] >= ordYear[yp] and ((st1,r) in mStorageOlifeInf or ordYear[y]<pStorageOlife[st1,r]+ordYear[yp]) and (st1,r,yp) in mStorageNew))}(pPeriodLen[yp]*vStorageNewCap[st1,r,yp]);

s.t.  eqStorageCapLo{(st1, r, y) in mStorageCapLo}: vStorageCap[st1,r,y]  >=  pStorageCapLo[st1,r,y];

s.t.  eqStorageCapUp{(st1, r, y) in mStorageCapUp}: vStorageCap[st1,r,y] <=  pStorageCapUp[st1,r,y];

s.t.  eqStorageNewCapLo{(st1, r, y) in mStorageNewCapLo}: vStorageNewCap[st1,r,y]  >=  pStorageNewCapLo[st1,r,y];

s.t.  eqStorageNewCapUp{(st1, r, y) in mStorageNewCapUp}: vStorageNewCap[st1,r,y] <=  pStorageNewCapUp[st1,r,y];

s.t.  eqStorageInv{(st1, r, y) in mStorageNew}: vStorageInv[st1,r,y]  =  pStorageInvcost[st1,r,y]*vStorageNewCap[st1,r,y];

s.t.  eqStorageEac{(st1, r, y) in mStorageEac}: vStorageEac[st1,r,y]  =  sum{yp in year:(((st1,r,yp) in mStorageNew and ordYear[y] >= ordYear[yp] and ((st1,r) in mStorageOlifeInf or ordYear[y]<pStorageOlife[st1,r]+ordYear[yp]) and pStorageInvcost[st1,r,yp] <> 0))}(pStorageEac[st1,r,yp]*pPeriodLen[yp]*vStorageNewCap[st1,r,yp]);

s.t.  eqStorageCost{(st1, r, y) in mStorageOMCost}: vStorageOMCost[st1,r,y]  =  pStorageFixom[st1,r,y]*vStorageCap[st1,r,y]+sum{c in comm:((st1,c) in mStorageComm)}(sum{s in slice:((c,s) in mCommSlice)}(pStorageCostInp[st1,r,y,s]*pSliceWeight[s]*vStorageInp[st1,c,r,y,s]+pStorageCostOut[st1,r,y,s]*pSliceWeight[s]*vStorageOut[st1,c,r,y,s]+pStorageCostStore[st1,r,y,s]*pSliceWeight[s]*vStorageStore[st1,c,r,y,s]));

s.t.  eqImportTot{(c, dst, y, s) in mImport}: vImportTot[c,dst,y,s]  =  sum{t1 in trade:((t1,c) in mTradeComm)}(sum{src in region:((t1,src,dst) in mTradeRoutes)}(sum{FORIF: (t1,c,src,dst,y,s) in mvTradeIr} ((pTradeIrEff[t1,src,dst,y,s]*vTradeIr[t1,c,src,dst,y,s]))))*pSliceWeight[s]+sum{i in imp:((i,c) in mImpComm)}(sum{FORIF: (i,c,dst,y,s) in mImportRow} (vImportRow[i,c,dst,y,s]))*pSliceWeight[s];

s.t.  eqExportTot{(c, src, y, s) in mExport}: vExportTot[c,src,y,s]  =  sum{t1 in trade:((t1,c) in mTradeComm)}(sum{dst in region:((t1,src,dst) in mTradeRoutes)}(sum{FORIF: (t1,c,src,dst,y,s) in mvTradeIr} (vTradeIr[t1,c,src,dst,y,s])))*pSliceWeight[s]+sum{e in expp:((e,c) in mExpComm)}(sum{FORIF: (e,c,src,y,s) in mExportRow} (vExportRow[e,c,src,y,s]))*pSliceWeight[s];

s.t.  eqTradeFlowUp{(t1, c, src, dst, y, s) in meqTradeFlowUp}: vTradeIr[t1,c,src,dst,y,s] <=  pTradeIrUp[t1,src,dst,y,s];

s.t.  eqTradeFlowLo{(t1, c, src, dst, y, s) in meqTradeFlowLo}: vTradeIr[t1,c,src,dst,y,s]  >=  pTradeIrLo[t1,src,dst,y,s];

s.t.  eqCostTrade{(r, y) in mvTradeCost}: vTradeCost[r,y]  =  sum{FORIF: (r,y) in mvTradeRowCost} (vTradeRowCost[r,y])+sum{FORIF: (r,y) in mvTradeIrCost} (vTradeIrCost[r,y]);

s.t.  eqCostRowTrade{(r, y) in mvTradeRowCost}: vTradeRowCost[r,y]  =  sum{i in imp,c in comm,s in slice:((i,c,r,y,s) in mImportRow)}(pImportRowPrice[i,r,y,s]*pSliceWeight[s]*vImportRow[i,c,r,y,s])-sum{e in expp,c in comm,s in slice:((e,c,r,y,s) in mExportRow)}(pExportRowPrice[e,r,y,s]*pSliceWeight[s]*vExportRow[e,c,r,y,s]);

s.t.  eqCostIrTrade{(r, y) in mvTradeIrCost}: vTradeIrCost[r,y]  =  sum{t1 in trade:((t1,y) in mTradeSpan)}(pTradeFixom[t1,y]*pTradeStock[t1,y])+sum{t1 in trade:(((t1,y) in mTradeSpan and t1 in mTradeCapacityVariable))}(pTradeFixom[t1,y]*(vTradeCap[t1,y]-pTradeStock[t1,y]))+sum{t1 in trade:((t1,r,y) in mTradeEac)}(vTradeEac[t1,r,y])+sum{t1 in trade,src in region:((t1,src,r) in mTradeRoutes)}(sum{c in comm:((t1,c) in mTradeComm)}(sum{s in slice:((t1,s) in mTradeSlice)}(sum{FORIF: (t1,c,src,r,y,s) in mvTradeIr} (((pTradeIrCost[t1,src,r,y,s]+pTradeIrMarkup[t1,src,r,y,s])*vTradeIr[t1,c,src,r,y,s]*pSliceWeight[s])))))-sum{t1 in trade,dst in region:((t1,r,dst) in mTradeRoutes)}(sum{c in comm:((t1,c) in mTradeComm)}(sum{s in slice:((t1,s) in mTradeSlice)}(sum{FORIF: (t1,c,r,dst,y,s) in mvTradeIr} (((pTradeIrCost[t1,r,dst,y,s]+pTradeIrMarkup[t1,r,dst,y,s])*vTradeIr[t1,c,r,dst,y,s]*pSliceWeight[s])))));

s.t.  eqExportRowUp{(e, c, r, y, s) in mExportRowUp}: vExportRow[e,c,r,y,s] <=  pExportRowUp[e,r,y,s];

s.t.  eqExportRowLo{(e, c, r, y, s) in meqExportRowLo}: vExportRow[e,c,r,y,s]  >=  pExportRowLo[e,r,y,s];

s.t.  eqExportRowCum{(e, c) in mExpComm}: vExportRowCum[e,c]  =  sum{r in region,y in year,s in slice:((e,c,r,y,s) in mExportRow)}(pPeriodLen[y]*pSliceWeight[s]*vExportRow[e,c,r,y,s]);

s.t.  eqExportRowResUp{(e, c) in mExportRowCumUp}: vExportRowCum[e,c] <=  pExportRowRes[e];

s.t.  eqImportRowUp{(i, c, r, y, s) in mImportRowUp}: vImportRow[i,c,r,y,s] <=  pImportRowUp[i,r,y,s];

s.t.  eqImportRowLo{(i, c, r, y, s) in meqImportRowLo}: vImportRow[i,c,r,y,s]  >=  pImportRowLo[i,r,y,s];

s.t.  eqImportRowCum{(i, c) in mImpComm}: vImportRowCum[i,c]  =  sum{r in region,y in year,s in slice:((i,c,r,y,s) in mImportRow)}(pPeriodLen[y]*pSliceWeight[s]*vImportRow[i,c,r,y,s]);

s.t.  eqImportRowResUp{(i, c) in mImportRowCumUp}: vImportRowCum[i,c] <=  pImportRowRes[i];

s.t.  eqTradeCapFlow{(t1, c, y, s) in meqTradeCapFlow}: pSliceShare[s]*pTradeCap2Act[t1]*vTradeCap[t1,y]  >=  sum{src in region,dst in region:((t1,c,src,dst,y,s) in mvTradeIr)}(vTradeIr[t1,c,src,dst,y,s]);

s.t.  eqTradeCap{(t1, y) in mTradeSpan}: vTradeCap[t1,y]  =  pTradeStock[t1,y]+sum{yp in year:(((t1,yp) in mTradeNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTradeOlife[t1]+ordYear[yp] or t1 in mTradeOlifeInf)))}(pPeriodLen[yp]*vTradeNewCap[t1,yp]);

s.t.  eqTradeCapLo{(t1, y) in mTradeCapLo}: vTradeCap[t1,y]  >=  pTradeCapLo[t1,y];

s.t.  eqTradeCapUp{(t1, y) in mTradeCapUp}: vTradeCap[t1,y] <=  pTradeCapUp[t1,y];

s.t.  eqTradeNewCapLo{(t1, y) in mTradeNewCapLo}: vTradeNewCap[t1,y]  >=  pTradeNewCapLo[t1,y];

s.t.  eqTradeNewCapUp{(t1, y) in mTradeNewCapUp}: vTradeNewCap[t1,y] <=  pTradeNewCapUp[t1,y];

s.t.  eqTradeInv{(t1, r, y) in mTradeInv}: vTradeInv[t1,r,y]  =  pTradeInvcost[t1,r,y]*vTradeNewCap[t1,y];

s.t.  eqTradeEac{(t1, r, y) in mTradeEac}: vTradeEac[t1,r,y]  =  sum{yp in year:(((t1,yp) in mTradeNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTradeOlife[t1]+ordYear[yp] or t1 in mTradeOlifeInf)))}(pTradeEac[t1,r,yp]*pPeriodLen[yp]*vTradeNewCap[t1,yp]);

s.t.  eqTradeIrAInp{(t1, c, r, y, s) in mvTradeIrAInp}: vTradeIrAInp[t1,c,r,y,s]  =  sum{dst in region:((t1,c,r,dst,y,s) in mTradeIrCsrc2Ainp)}(pTradeIrCsrc2Ainp[t1,c,r,dst,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:((t1,c,src,r,y,s) in mTradeIrCdst2Ainp)}(pTradeIrCdst2Ainp[t1,c,src,r,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAOut{(t1, c, r, y, s) in mvTradeIrAOut}: vTradeIrAOut[t1,c,r,y,s]  =  sum{dst in region:((t1,c,r,dst,y,s) in mTradeIrCsrc2Aout)}(pTradeIrCsrc2Aout[t1,c,r,dst,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:((t1,c,src,r,y,s) in mTradeIrCdst2Aout)}(pTradeIrCdst2Aout[t1,c,src,r,y,s]*sum{cp in comm:((t1,cp) in mTradeComm)}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAInpTot{(c, r, y, s) in mvTradeIrAInpTot}: vTradeIrAInpTot[c,r,y,s]  =  pSliceWeight[s]*sum{t1 in trade,sp in slice:(((c,s,sp) in mCommSliceOrParent and (t1,c,r,y,sp) in mvTradeIrAInp))}(vTradeIrAInp[t1,c,r,y,sp]);

s.t.  eqTradeIrAOutTot{(c, r, y, s) in mvTradeIrAOutTot}: vTradeIrAOutTot[c,r,y,s]  =  pSliceWeight[s]*sum{t1 in trade,sp in slice:(((c,s,sp) in mCommSliceOrParent and (t1,c,r,y,sp) in mvTradeIrAOut))}(vTradeIrAOut[t1,c,r,y,sp]);

s.t.  eqBalLo{(c, r, y, s) in meqBalLo}: vBalance[c,r,y,s]  >=  0;

s.t.  eqBalUp{(c, r, y, s) in meqBalUp}: vBalance[c,r,y,s] <=  0;

s.t.  eqBalFx{(c, r, y, s) in meqBalFx}: vBalance[c,r,y,s]  =  0;

s.t.  eqBal{(c, r, y, s) in mvBalance}: vBalance[c,r,y,s]  =  sum{FORIF: (c,r,y,s) in mvOutTot} (vOutTot[c,r,y,s])-sum{FORIF: (c,r,y,s) in mvInpTot} (vInpTot[c,r,y,s]);

s.t.  eqOutTot{(c, r, y, s) in mvOutTot}: vOutTot[c,r,y,s]  =  pSliceWeight[s]*sum{FORIF: (c,r,y,s) in mDummyImport} (vDummyImport[c,r,y,s])+sum{FORIF: (c,r,y,s) in mSupOutTot} (vSupOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mEmsFuelTot} (vEmsFuelTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mAggOut} (vAggOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTechOutTot} (vTechOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageOutTot} (vStorageOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mImport} (vImportTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mvTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,s])+pSliceWeight[s]*sum{FORIF: (c,r,y,s) in mOutSub} (sum{sp in slice:(((sp,s) in mSliceParentChild and (c,r,y,sp,s) in mvOut2Lo))}(vOut2Lo[c,r,y,sp,s]));

s.t.  eqOut2Lo{(c, r, y, s) in mOut2Lo}: sum{sp in slice:((c,r,y,s,sp) in mvOut2Lo)}(vOut2Lo[c,r,y,s,sp])  =  sum{FORIF: (c,r,y,s) in mSupOutTot} (vSupOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mEmsFuelTot} (vEmsFuelTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mAggOut} (vAggOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTechOutTot} (vTechOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageOutTot} (vStorageOutTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mImport} (vImportTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mvTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,s]);

s.t.  eqInpTot{(c, r, y, s) in mvInpTot}: vInpTot[c,r,y,s]  =  pSliceWeight[s]*sum{FORIF: (c,r,y,s) in mvDemInp} (vDemInp[c,r,y,s])+pSliceWeight[s]*sum{FORIF: (c,r,y,s) in mDummyExport} (vDummyExport[c,r,y,s])+sum{FORIF: (c,r,y,s) in mTechInpTot} (vTechInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageInpTot} (vStorageInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mExport} (vExportTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mvTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,s])+pSliceWeight[s]*sum{FORIF: (c,r,y,s) in mInpSub} (sum{sp in slice:(((sp,s) in mSliceParentChild and (c,r,y,sp,s) in mvInp2Lo))}(vInp2Lo[c,r,y,sp,s]));

s.t.  eqInp2Lo{(c, r, y, s) in mInp2Lo}: sum{sp in slice:((c,r,y,s,sp) in mvInp2Lo)}(vInp2Lo[c,r,y,s,sp])  =  sum{FORIF: (c,r,y,s) in mTechInpTot} (vTechInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mStorageInpTot} (vStorageInpTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mExport} (vExportTot[c,r,y,s])+sum{FORIF: (c,r,y,s) in mvTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,s]);

s.t.  eqSupOutTot{(c, r, y, s) in mSupOutTot}: vSupOutTot[c,r,y,s]  =  pSliceWeight[s]*sum{s1 in sup:((s1,c) in mSupComm)}(vSupOut[s1,c,r,y,s]);

s.t.  eqTechInpTot{(c, r, y, s) in mTechInpTot}: vTechInpTot[c,r,y,s]  =  pSliceWeight[s]*sum{t in tech:((t,c) in mTechInpCommSameSlice)}(sum{FORIF: (t,c,r,y,s) in mvTechInp} (vTechInp[t,c,r,y,s]))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechInpCommAgg)}(sum{sp in slice:((t,c,sp,s) in mTechInpCommAggSlice)}(sum{FORIF: (t,c,r,y,sp) in mvTechInp} (vTechInp[t,c,r,y,sp])))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechAInpCommSameSlice)}(sum{FORIF: (t,c,r,y,s) in mvTechAInp} (vTechAInp[t,c,r,y,s]))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechAInpCommAgg)}(sum{sp in slice:((t,c,sp,s) in mTechAInpCommAggSlice)}(sum{FORIF: (t,c,r,y,sp) in mvTechAInp} (vTechAInp[t,c,r,y,sp])));

s.t.  eqTechOutTot{(c, r, y, s) in mTechOutTot}: vTechOutTot[c,r,y,s]  =  pSliceWeight[s]*sum{t in tech:((t,c) in mTechOutCommSameSlice)}(sum{FORIF: (t,c,r,y,s) in mvTechOut} (vTechOut[t,c,r,y,s]))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechOutCommAgg)}(sum{sp in slice:((t,c,sp,s) in mTechOutCommAggSlice)}(sum{FORIF: (t,c,r,y,sp) in mvTechOut} (vTechOut[t,c,r,y,sp])))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechAOutCommSameSlice)}(sum{FORIF: (t,c,r,y,s) in mvTechAOut} (vTechAOut[t,c,r,y,s]))+pSliceWeight[s]*sum{t in tech:((t,c) in mTechAOutCommAgg)}(sum{sp in slice:((t,c,sp,s) in mTechAOutCommAggSlice)}(sum{FORIF: (t,c,r,y,sp) in mvTechAOut} (vTechAOut[t,c,r,y,sp])));

s.t.  eqStorageInpTot{(c, r, y, s) in mStorageInpTot}: vStorageInpTot[c,r,y,s]  =  pSliceWeight[s]*sum{st1 in stg:((st1,c,r,y,s) in mvStorageStore)}(vStorageInp[st1,c,r,y,s])+pSliceWeight[s]*sum{st1 in stg:((st1,c,r,y,s) in mvStorageAInp)}(vStorageAInp[st1,c,r,y,s]);

s.t.  eqStorageOutTot{(c, r, y, s) in mStorageOutTot}: vStorageOutTot[c,r,y,s]  =  pSliceWeight[s]*sum{st1 in stg:((st1,c,r,y,s) in mvStorageStore)}(vStorageOut[st1,c,r,y,s])+pSliceWeight[s]*sum{st1 in stg:((st1,c,r,y,s) in mvStorageAOut)}(vStorageAOut[st1,c,r,y,s]);

s.t.  eqCost{(r, y) in mvTotalCost}: vTotalCost[r,y]  =  sum{t in tech:((t,r,y) in mTechEac)}(vTechEac[t,r,y])+sum{t in tech:((t,r,y) in mvTechRetiredStock)}(pTechRetCost[t,r,y]*(vTechRetiredStock[t,r,y]+sum{yp in year:((t,r,yp,y) in mvTechRetiredNewCap)}(vTechRetiredNewCap[t,r,yp,y])))+sum{t in tech,yp in year:((t,r,yp,y) in mvTechRetiredNewCap)}(pTechRetCost[t,r,y]*vTechRetiredNewCap[t,r,yp,y])+sum{t in tech:((t,r,y) in mTechOMCost)}(vTechOMCost[t,r,y])+sum{s1 in sup:((s1,r,y) in mvSupCost)}(vSupCost[s1,r,y])+sum{c in comm,s in slice:((c,r,y,s) in mDummyImport)}(pDummyImportCost[c,r,y,s]*pSliceWeight[s]*vDummyImport[c,r,y,s])+sum{c in comm,s in slice:((c,r,y,s) in mDummyExport)}(pDummyExportCost[c,r,y,s]*pSliceWeight[s]*vDummyExport[c,r,y,s])+sum{c in comm:((c,r,y) in mTaxCost)}(vTaxCost[c,r,y])-sum{c in comm:((c,r,y) in mSubCost)}(vSubsCost[c,r,y])+sum{st1 in stg:((st1,r,y) in mStorageOMCost)}(vStorageOMCost[st1,r,y])+sum{st1 in stg:((st1,r,y) in mStorageEac)}(vStorageEac[st1,r,y])+sum{FORIF: (r,y) in mvTradeCost} (vTradeCost[r,y])+sum{FORIF: (r,y) in mvTotalUserCosts} (vTotalUserCosts[r,y]);

s.t.  eqTaxCost{(c, r, y) in mTaxCost}: vTaxCost[c,r,y]  =  sum{s in slice:(((c,r,y,s) in mvOutTot and (c,s) in mCommSlice))}(pTaxCostOut[c,r,y,s]*vOutTot[c,r,y,s])+sum{s in slice:(((c,r,y,s) in mvInpTot and (c,s) in mCommSlice))}(pTaxCostInp[c,r,y,s]*vInpTot[c,r,y,s])+sum{s in slice:(((c,r,y,s) in mvBalance and (c,s) in mCommSlice))}(pTaxCostBal[c,r,y,s]*vBalance[c,r,y,s]);

s.t.  eqSubsCost{(c, r, y) in mSubCost}: vSubsCost[c,r,y]  =  sum{s in slice:(((c,r,y,s) in mvOutTot and (c,s) in mCommSlice))}(pSubCostOut[c,r,y,s]*vOutTot[c,r,y,s])+sum{s in slice:(((c,r,y,s) in mvInpTot and (c,s) in mCommSlice))}(pSubCostInp[c,r,y,s]*vInpTot[c,r,y,s])+sum{s in slice:(((c,r,y,s) in mvBalance and (c,s) in mCommSlice))}(pSubCostBal[c,r,y,s]*vBalance[c,r,y,s]);

s.t.  eqObjective: vObjective  =  sum{r in region,y in year:((r,y) in mvTotalCost)}(pDiscountFactorMileStone[r,y]*vTotalCost[r,y]);

s.t.  eqLECActivity{(t, r, y) in meqLECActivity}: sum{s in slice:((t,s) in mTechSlice)}(vTechAct[t,r,y,s])  >=  pLECLoACT[r];

printf  '"solver",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
minimize vObjective2 : vObjective;

solve;


printf  '"solution status",1,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
printf  '"export results",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
printf "tech,region,year,value\n" > "output/vTechNewCap.csv";
for{(t, r, y) in mTechNew : vTechNewCap[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechNewCap[t,r,y] >> "output/vTechNewCap.csv";
}
printf "tech,region,year,value\n" > "output/vTechRetiredStockCum.csv";
for{(t, r, y) in mvTechRetiredStock : vTechRetiredStockCum[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechRetiredStockCum[t,r,y] >> "output/vTechRetiredStockCum.csv";
}
printf "tech,region,year,value\n" > "output/vTechRetiredStock.csv";
for{(t, r, y) in mvTechRetiredStock : vTechRetiredStock[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechRetiredStock[t,r,y] >> "output/vTechRetiredStock.csv";
}
printf "tech,region,year,yearp,value\n" > "output/vTechRetiredNewCap.csv";
for{(t, r, y, yp) in mvTechRetiredNewCap : vTechRetiredNewCap[t,r,y,yp] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t,r,y,yp,vTechRetiredNewCap[t,r,y,yp] >> "output/vTechRetiredNewCap.csv";
}
printf "tech,region,year,value\n" > "output/vTechCap.csv";
for{(t, r, y) in mTechSpan : vTechCap[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechCap[t,r,y] >> "output/vTechCap.csv";
}
printf "tech,region,year,slice,value\n" > "output/vTechAct.csv";
for{(t, r, y, s) in mvTechAct : vTechAct[t,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", t,r,y,s,vTechAct[t,r,y,s] >> "output/vTechAct.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechInp.csv";
for{(t, c, r, y, s) in mvTechInp : vTechInp[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechInp[t,c,r,y,s] >> "output/vTechInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechOut.csv";
for{(t, c, r, y, s) in mvTechOut : vTechOut[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechOut[t,c,r,y,s] >> "output/vTechOut.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechAInp.csv";
for{(t, c, r, y, s) in mvTechAInp : vTechAInp[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechAInp[t,c,r,y,s] >> "output/vTechAInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechAOut.csv";
for{(t, c, r, y, s) in mvTechAOut : vTechAOut[t,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s,vTechAOut[t,c,r,y,s] >> "output/vTechAOut.csv";
}
printf "tech,region,year,value\n" > "output/vTechInv.csv";
for{(t, r, y) in mTechInv : vTechInv[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechInv[t,r,y] >> "output/vTechInv.csv";
}
printf "tech,region,year,value\n" > "output/vTechEac.csv";
for{(t, r, y) in mTechEac : vTechEac[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechEac[t,r,y] >> "output/vTechEac.csv";
}
printf "tech,region,year,value\n" > "output/vTechOMCost.csv";
for{(t, r, y) in mTechOMCost : vTechOMCost[t,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t,r,y,vTechOMCost[t,r,y] >> "output/vTechOMCost.csv";
}
printf "sup,comm,region,year,slice,value\n" > "output/vSupOut.csv";
for{(s1, c, r, y, s) in mSupAva : vSupOut[s1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s1,c,r,y,s,vSupOut[s1,c,r,y,s] >> "output/vSupOut.csv";
}
printf "sup,comm,region,value\n" > "output/vSupReserve.csv";
for{(s1, c, r) in mvSupReserve : vSupReserve[s1,c,r] <> 0} {
  printf "%s,%s,%s,%f\n", s1,c,r,vSupReserve[s1,c,r] >> "output/vSupReserve.csv";
}
printf "sup,region,year,value\n" > "output/vSupCost.csv";
for{(s1, r, y) in mvSupCost : vSupCost[s1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s1,r,y,vSupCost[s1,r,y] >> "output/vSupCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDemInp.csv";
for{(c, r, y, s) in mvDemInp : vDemInp[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDemInp[c,r,y,s] >> "output/vDemInp.csv";
}
printf "comm,region,year,slice,value\n" > "output/vEmsFuelTot.csv";
for{(c, r, y, s) in mEmsFuelTot : vEmsFuelTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vEmsFuelTot[c,r,y,s] >> "output/vEmsFuelTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vBalance.csv";
for{(c, r, y, s) in mvBalance : vBalance[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vBalance[c,r,y,s] >> "output/vBalance.csv";
}
printf "comm,region,year,slice,value\n" > "output/vOutTot.csv";
for{(c, r, y, s) in mvOutTot : vOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vOutTot[c,r,y,s] >> "output/vOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vInpTot.csv";
for{(c, r, y, s) in mvInpTot : vInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vInpTot[c,r,y,s] >> "output/vInpTot.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "output/vInp2Lo.csv";
for{(c, r, y, s, sp) in mvInp2Lo : vInp2Lo[c,r,y,s,sp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,s,sp,vInp2Lo[c,r,y,s,sp] >> "output/vInp2Lo.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "output/vOut2Lo.csv";
for{(c, r, y, s, sp) in mvOut2Lo : vOut2Lo[c,r,y,s,sp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,s,sp,vOut2Lo[c,r,y,s,sp] >> "output/vOut2Lo.csv";
}
printf "comm,region,year,slice,value\n" > "output/vSupOutTot.csv";
for{(c, r, y, s) in mSupOutTot : vSupOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vSupOutTot[c,r,y,s] >> "output/vSupOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTechInpTot.csv";
for{(c, r, y, s) in mTechInpTot : vTechInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTechInpTot[c,r,y,s] >> "output/vTechInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTechOutTot.csv";
for{(c, r, y, s) in mTechOutTot : vTechOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTechOutTot[c,r,y,s] >> "output/vTechOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vStorageInpTot.csv";
for{(c, r, y, s) in mStorageInpTot : vStorageInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vStorageInpTot[c,r,y,s] >> "output/vStorageInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vStorageOutTot.csv";
for{(c, r, y, s) in mStorageOutTot : vStorageOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vStorageOutTot[c,r,y,s] >> "output/vStorageOutTot.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageAInp.csv";
for{(st1, c, r, y, s) in mvStorageAInp : vStorageAInp[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageAInp[st1,c,r,y,s] >> "output/vStorageAInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageAOut.csv";
for{(st1, c, r, y, s) in mvStorageAOut : vStorageAOut[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageAOut[st1,c,r,y,s] >> "output/vStorageAOut.csv";
}
printf "region,year,value\n" > "output/vTotalCost.csv";
for{(r, y) in mvTotalCost : vTotalCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTotalCost[r,y] >> "output/vTotalCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDummyImport.csv";
for{(c, r, y, s) in mDummyImport : vDummyImport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDummyImport[c,r,y,s] >> "output/vDummyImport.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDummyExport.csv";
for{(c, r, y, s) in mDummyExport : vDummyExport[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vDummyExport[c,r,y,s] >> "output/vDummyExport.csv";
}
printf "comm,region,year,value\n" > "output/vTaxCost.csv";
for{(c, r, y) in mTaxCost : vTaxCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vTaxCost[c,r,y] >> "output/vTaxCost.csv";
}
printf "comm,region,year,value\n" > "output/vSubsCost.csv";
for{(c, r, y) in mSubCost : vSubsCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vSubsCost[c,r,y] >> "output/vSubsCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vAggOutTot.csv";
for{(c, r, y, s) in mAggOut : vAggOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vAggOutTot[c,r,y,s] >> "output/vAggOutTot.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageInp.csv";
for{(st1, c, r, y, s) in mvStorageStore : vStorageInp[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageInp[st1,c,r,y,s] >> "output/vStorageInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageOut.csv";
for{(st1, c, r, y, s) in mvStorageStore : vStorageOut[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageOut[st1,c,r,y,s] >> "output/vStorageOut.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageStore.csv";
for{(st1, c, r, y, s) in mvStorageStore : vStorageStore[st1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s,vStorageStore[st1,c,r,y,s] >> "output/vStorageStore.csv";
}
printf "stg,region,year,value\n" > "output/vStorageInv.csv";
for{(st1, r, y) in mStorageNew : vStorageInv[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageInv[st1,r,y] >> "output/vStorageInv.csv";
}
printf "stg,region,year,value\n" > "output/vStorageEac.csv";
for{(st1, r, y) in mStorageEac : vStorageEac[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageEac[st1,r,y] >> "output/vStorageEac.csv";
}
printf "stg,region,year,value\n" > "output/vStorageCap.csv";
for{(st1, r, y) in mStorageSpan : vStorageCap[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageCap[st1,r,y] >> "output/vStorageCap.csv";
}
printf "stg,region,year,value\n" > "output/vStorageNewCap.csv";
for{(st1, r, y) in mStorageNew : vStorageNewCap[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageNewCap[st1,r,y] >> "output/vStorageNewCap.csv";
}
printf "stg,region,year,value\n" > "output/vStorageOMCost.csv";
for{(st1, r, y) in mStorageOMCost : vStorageOMCost[st1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", st1,r,y,vStorageOMCost[st1,r,y] >> "output/vStorageOMCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vImportTot.csv";
for{(c, r, y, s) in mImport : vImportTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vImportTot[c,r,y,s] >> "output/vImportTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vExportTot.csv";
for{(c, r, y, s) in mExport : vExportTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vExportTot[c,r,y,s] >> "output/vExportTot.csv";
}
printf "trade,comm,src,dst,year,slice,value\n" > "output/vTradeIr.csv";
for{(t1, c, src, dst, y, s) in mvTradeIr : vTradeIr[t1,c,src,dst,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%s,%f\n", t1,c,src,dst,y,s,vTradeIr[t1,c,src,dst,y,s] >> "output/vTradeIr.csv";
}
printf "trade,comm,region,year,slice,value\n" > "output/vTradeIrAInp.csv";
for{(t1, c, r, y, s) in mvTradeIrAInp : vTradeIrAInp[t1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s,vTradeIrAInp[t1,c,r,y,s] >> "output/vTradeIrAInp.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTradeIrAInpTot.csv";
for{(c, r, y, s) in mvTradeIrAInpTot : vTradeIrAInpTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTradeIrAInpTot[c,r,y,s] >> "output/vTradeIrAInpTot.csv";
}
printf "trade,comm,region,year,slice,value\n" > "output/vTradeIrAOut.csv";
for{(t1, c, r, y, s) in mvTradeIrAOut : vTradeIrAOut[t1,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s,vTradeIrAOut[t1,c,r,y,s] >> "output/vTradeIrAOut.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTradeIrAOutTot.csv";
for{(c, r, y, s) in mvTradeIrAOutTot : vTradeIrAOutTot[c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,s,vTradeIrAOutTot[c,r,y,s] >> "output/vTradeIrAOutTot.csv";
}
printf "expp,comm,value\n" > "output/vExportRowCum.csv";
for{(e, c) in mExpComm : vExportRowCum[e,c] <> 0} {
  printf "%s,%s,%f\n", e,c,vExportRowCum[e,c] >> "output/vExportRowCum.csv";
}
printf "expp,comm,region,year,slice,value\n" > "output/vExportRow.csv";
for{(e, c, r, y, s) in mExportRow : vExportRow[e,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", e,c,r,y,s,vExportRow[e,c,r,y,s] >> "output/vExportRow.csv";
}
printf "imp,comm,value\n" > "output/vImportRowCum.csv";
for{(i, c) in mImpComm : vImportRowCum[i,c] <> 0} {
  printf "%s,%s,%f\n", i,c,vImportRowCum[i,c] >> "output/vImportRowCum.csv";
}
printf "imp,comm,region,year,slice,value\n" > "output/vImportRow.csv";
for{(i, c, r, y, s) in mImportRow : vImportRow[i,c,r,y,s] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", i,c,r,y,s,vImportRow[i,c,r,y,s] >> "output/vImportRow.csv";
}
printf "region,year,value\n" > "output/vTradeCost.csv";
for{(r, y) in mvTradeCost : vTradeCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeCost[r,y] >> "output/vTradeCost.csv";
}
printf "region,year,value\n" > "output/vTradeRowCost.csv";
for{(r, y) in mvTradeRowCost : vTradeRowCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeRowCost[r,y] >> "output/vTradeRowCost.csv";
}
printf "region,year,value\n" > "output/vTradeIrCost.csv";
for{(r, y) in mvTradeIrCost : vTradeIrCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTradeIrCost[r,y] >> "output/vTradeIrCost.csv";
}
printf "trade,year,value\n" > "output/vTradeCap.csv";
for{(t1, y) in mTradeSpan : vTradeCap[t1,y] <> 0} {
  printf "%s,%s,%f\n", t1,y,vTradeCap[t1,y] >> "output/vTradeCap.csv";
}
printf "trade,region,year,value\n" > "output/vTradeInv.csv";
for{(t1, r, y) in mTradeEac : vTradeInv[t1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t1,r,y,vTradeInv[t1,r,y] >> "output/vTradeInv.csv";
}
printf "trade,region,year,value\n" > "output/vTradeEac.csv";
for{(t1, r, y) in mTradeEac : vTradeEac[t1,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", t1,r,y,vTradeEac[t1,r,y] >> "output/vTradeEac.csv";
}
printf "trade,year,value\n" > "output/vTradeNewCap.csv";
for{(t1, y) in mTradeNew : vTradeNewCap[t1,y] <> 0} {
  printf "%s,%s,%f\n", t1,y,vTradeNewCap[t1,y] >> "output/vTradeNewCap.csv";
}
printf "region,year,value\n" > "output/vTotalUserCosts.csv";
for{(r, y) in mvTotalUserCosts : vTotalUserCosts[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTotalUserCosts[r,y] >> "output/vTotalUserCosts.csv";
}
printf "value\n%s\n",vObjective > "output/vObjective.csv";


printf "value\n" > "output/variable_list.csv";
    printf "vTechInv\n" >> "output/variable_list.csv";
    printf "vTechEac\n" >> "output/variable_list.csv";
    printf "vTechOMCost\n" >> "output/variable_list.csv";
    printf "vSupCost\n" >> "output/variable_list.csv";
    printf "vEmsFuelTot\n" >> "output/variable_list.csv";
    printf "vBalance\n" >> "output/variable_list.csv";
    printf "vTotalCost\n" >> "output/variable_list.csv";
    printf "vObjective\n" >> "output/variable_list.csv";
    printf "vTaxCost\n" >> "output/variable_list.csv";
    printf "vSubsCost\n" >> "output/variable_list.csv";
    printf "vAggOutTot\n" >> "output/variable_list.csv";
    printf "vStorageOMCost\n" >> "output/variable_list.csv";
    printf "vTradeCost\n" >> "output/variable_list.csv";
    printf "vTradeRowCost\n" >> "output/variable_list.csv";
    printf "vTradeIrCost\n" >> "output/variable_list.csv";
    printf "vTechNewCap\n" >> "output/variable_list.csv";
    printf "vTechRetiredStockCum\n" >> "output/variable_list.csv";
    printf "vTechRetiredStock\n" >> "output/variable_list.csv";
    printf "vTechRetiredNewCap\n" >> "output/variable_list.csv";
    printf "vTechCap\n" >> "output/variable_list.csv";
    printf "vTechAct\n" >> "output/variable_list.csv";
    printf "vTechInp\n" >> "output/variable_list.csv";
    printf "vTechOut\n" >> "output/variable_list.csv";
    printf "vTechAInp\n" >> "output/variable_list.csv";
    printf "vTechAOut\n" >> "output/variable_list.csv";
    printf "vSupOut\n" >> "output/variable_list.csv";
    printf "vSupReserve\n" >> "output/variable_list.csv";
    printf "vDemInp\n" >> "output/variable_list.csv";
    printf "vOutTot\n" >> "output/variable_list.csv";
    printf "vInpTot\n" >> "output/variable_list.csv";
    printf "vInp2Lo\n" >> "output/variable_list.csv";
    printf "vOut2Lo\n" >> "output/variable_list.csv";
    printf "vSupOutTot\n" >> "output/variable_list.csv";
    printf "vTechInpTot\n" >> "output/variable_list.csv";
    printf "vTechOutTot\n" >> "output/variable_list.csv";
    printf "vStorageInpTot\n" >> "output/variable_list.csv";
    printf "vStorageOutTot\n" >> "output/variable_list.csv";
    printf "vStorageAInp\n" >> "output/variable_list.csv";
    printf "vStorageAOut\n" >> "output/variable_list.csv";
    printf "vDummyImport\n" >> "output/variable_list.csv";
    printf "vDummyExport\n" >> "output/variable_list.csv";
    printf "vStorageInp\n" >> "output/variable_list.csv";
    printf "vStorageOut\n" >> "output/variable_list.csv";
    printf "vStorageStore\n" >> "output/variable_list.csv";
    printf "vStorageInv\n" >> "output/variable_list.csv";
    printf "vStorageEac\n" >> "output/variable_list.csv";
    printf "vStorageCap\n" >> "output/variable_list.csv";
    printf "vStorageNewCap\n" >> "output/variable_list.csv";
    printf "vImportTot\n" >> "output/variable_list.csv";
    printf "vExportTot\n" >> "output/variable_list.csv";
    printf "vTradeIr\n" >> "output/variable_list.csv";
    printf "vTradeIrAInp\n" >> "output/variable_list.csv";
    printf "vTradeIrAInpTot\n" >> "output/variable_list.csv";
    printf "vTradeIrAOut\n" >> "output/variable_list.csv";
    printf "vTradeIrAOutTot\n" >> "output/variable_list.csv";
    printf "vExportRowCum\n" >> "output/variable_list.csv";
    printf "vExportRow\n" >> "output/variable_list.csv";
    printf "vImportRowCum\n" >> "output/variable_list.csv";
    printf "vImportRow\n" >> "output/variable_list.csv";
    printf "vTradeCap\n" >> "output/variable_list.csv";
    printf "vTradeInv\n" >> "output/variable_list.csv";
    printf "vTradeEac\n" >> "output/variable_list.csv";
    printf "vTradeNewCap\n" >> "output/variable_list.csv";
    printf "vTotalUserCosts\n" >> "output/variable_list.csv";


printf "set,value\n" > "output/raw_data_set.csv";
for {c in comm} {
    printf "comm,%s\n", c >> "output/raw_data_set.csv";
}
for {r in region} {
    printf "region,%s\n", r >> "output/raw_data_set.csv";
}
for {y in mMidMilestone} {
    printf "year,%s\n", y >> "output/raw_data_set.csv";
}
for {s in slice} {
    printf "slice,%s\n", s >> "output/raw_data_set.csv";
}
for {s1 in sup} {
    printf "sup,%s\n", s1 >> "output/raw_data_set.csv";
}
for {d in dem} {
    printf "dem,%s\n", d >> "output/raw_data_set.csv";
}
for {t in tech} {
    printf "tech,%s\n", t >> "output/raw_data_set.csv";
}
for {st1 in stg} {
    printf "stg,%s\n", st1 >> "output/raw_data_set.csv";
}
for {t1 in trade} {
    printf "trade,%s\n", t1 >> "output/raw_data_set.csv";
}
for {e in expp} {
    printf "expp,%s\n", e >> "output/raw_data_set.csv";
}
for {i in imp} {
    printf "imp,%s\n", i >> "output/raw_data_set.csv";
}
for {g in group} {
    printf "group,%s\n", g >> "output/raw_data_set.csv";
}
for {wth1 in weather} {
    printf "weather,%s\n", wth1 >> "output/raw_data_set.csv";
}
printf  '"done",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
end;


