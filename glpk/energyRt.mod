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
set mvStorageAInp dimen 5;
set mvStorageAOut dimen 5;
set mvStorageStore dimen 5;
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
set mTechInv dimen 3;
set mTechInpTot dimen 4;
set mTechOutTot dimen 4;
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
set mImportRowAccumulatedUp dimen 2;
set mExportRow dimen 5;
set mExportRowUp dimen 5;
set mExportRowAccumulatedUp dimen 2;
set mExport dimen 4;
set mImport dimen 4;
set mStorageInpTot dimen 4;
set mStorageOutTot dimen 4;
set mTaxCost dimen 3;
set mSubCost dimen 3;
set mAggOut dimen 4;
set mTechAfUp dimen 4;
set mTechFullYear dimen 1;
set mTechRampUp dimen 4;
set mTechRampDown dimen 4;
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
param ordYear{year};
param cardYear{year};
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
param pStorageEac{stg, region, year};
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
param pTradeOlife{trade};
param pTradeInvcost{trade, region, year};
param pTradeEac{trade, region, year};
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
var vAggOut{comm, region, year, slice};
var vStorageOMCost{stg, region, year};
var vTradeCost{region, year};
var vTradeRowCost{region, year};
var vTradeIrCost{region, year};




var vTechNewCap{tech, region, year} >= 0;
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
var vTradeCap{trade, year} >= 0;
var vTradeInv{trade, region, year} >= 0;
var vTradeEac{trade, region, year} >= 0;
var vTradeNewCap{trade, year} >= 0;
var vTotalUserCosts{region, year} >= 0;




# Guid for add equation and add mapping & parameter to constrain
# 22b584bd-a17a-4fa0-9cd9-f603ab684e47
s.t.  eqTechSng2Sng{(h, r, c, cp, y, l) in meqTechSng2Sng}: vTechInp[h,c,r,y,l]*pTechCinp2use[h,c,r,y,l]  =  (vTechOut[h,cp,r,y,l]) / (pTechUse2cact[h,cp,r,y,l]*pTechCact2cout[h,cp,r,y,l]);

s.t.  eqTechGrp2Sng{(h, r, g, cp, y, l) in meqTechGrp2Sng}: pTechGinp2use[h,g,r,y,l]*sum{c in comm:((h,g,c) in mTechGroupComm)}(sum{FORIF: (h,c,r,y,l) in mvTechInp} ((vTechInp[h,c,r,y,l]*pTechCinp2ginp[h,c,r,y,l])))  =  (vTechOut[h,cp,r,y,l]) / (pTechUse2cact[h,cp,r,y,l]*pTechCact2cout[h,cp,r,y,l]);

s.t.  eqTechSng2Grp{(h, r, c, gp, y, l) in meqTechSng2Grp}: vTechInp[h,c,r,y,l]*pTechCinp2use[h,c,r,y,l]  =  sum{cp in comm:((h,gp,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechOut} (((vTechOut[h,cp,r,y,l]) / (pTechUse2cact[h,cp,r,y,l]*pTechCact2cout[h,cp,r,y,l]))));

s.t.  eqTechGrp2Grp{(h, r, g, gp, y, l) in meqTechGrp2Grp}: pTechGinp2use[h,g,r,y,l]*sum{c in comm:((h,g,c) in mTechGroupComm)}(sum{FORIF: (h,c,r,y,l) in mvTechInp} ((vTechInp[h,c,r,y,l]*pTechCinp2ginp[h,c,r,y,l])))  =  sum{cp in comm:((h,gp,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechOut} (((vTechOut[h,cp,r,y,l]) / (pTechUse2cact[h,cp,r,y,l]*pTechCact2cout[h,cp,r,y,l]))));

s.t.  eqTechShareInpLo{(h, r, g, c, y, l) in meqTechShareInpLo}: vTechInp[h,c,r,y,l]  >=  pTechShareLo[h,c,r,y,l]*sum{cp in comm:((h,g,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechInp} (vTechInp[h,cp,r,y,l]));

s.t.  eqTechShareInpUp{(h, r, g, c, y, l) in meqTechShareInpUp}: vTechInp[h,c,r,y,l] <=  pTechShareUp[h,c,r,y,l]*sum{cp in comm:((h,g,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechInp} (vTechInp[h,cp,r,y,l]));

s.t.  eqTechShareOutLo{(h, r, g, c, y, l) in meqTechShareOutLo}: vTechOut[h,c,r,y,l]  >=  pTechShareLo[h,c,r,y,l]*sum{cp in comm:((h,g,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechOut} (vTechOut[h,cp,r,y,l]));

s.t.  eqTechShareOutUp{(h, r, g, c, y, l) in meqTechShareOutUp}: vTechOut[h,c,r,y,l] <=  pTechShareUp[h,c,r,y,l]*sum{cp in comm:((h,g,cp) in mTechGroupComm)}(sum{FORIF: (h,cp,r,y,l) in mvTechOut} (vTechOut[h,cp,r,y,l]));

s.t.  eqTechAInp{(h, c, r, y, l) in mvTechAInp}: vTechAInp[h,c,r,y,l]  =  sum{FORIF: (h,c,r,y,l) in mTechAct2AInp} ((vTechAct[h,r,y,l]*pTechAct2AInp[h,c,r,y,l]))+sum{FORIF: (h,c,r,y,l) in mTechCap2AInp} ((vTechCap[h,r,y]*pTechCap2AInp[h,c,r,y,l]))+sum{FORIF: (h,c,r,y,l) in mTechNCap2AInp} ((vTechNewCap[h,r,y]*pTechNCap2AInp[h,c,r,y,l]))+sum{cp in comm:((h,c,cp,r,y,l) in mTechCinp2AInp)}(pTechCinp2AInp[h,c,cp,r,y,l]*vTechInp[h,cp,r,y,l])+sum{cp in comm:((h,c,cp,r,y,l) in mTechCout2AInp)}(pTechCout2AInp[h,c,cp,r,y,l]*vTechOut[h,cp,r,y,l]);

s.t.  eqTechAOut{(h, c, r, y, l) in mvTechAOut}: vTechAOut[h,c,r,y,l]  =  sum{FORIF: (h,c,r,y,l) in mTechAct2AOut} ((vTechAct[h,r,y,l]*pTechAct2AOut[h,c,r,y,l]))+sum{FORIF: (h,c,r,y,l) in mTechCap2AOut} ((vTechCap[h,r,y]*pTechCap2AOut[h,c,r,y,l]))+sum{FORIF: (h,c,r,y,l) in mTechNCap2AOut} ((vTechNewCap[h,r,y]*pTechNCap2AOut[h,c,r,y,l]))+sum{cp in comm:((h,c,cp,r,y,l) in mTechCinp2AOut)}(pTechCinp2AOut[h,c,cp,r,y,l]*vTechInp[h,cp,r,y,l])+sum{cp in comm:((h,c,cp,r,y,l) in mTechCout2AOut)}(pTechCout2AOut[h,c,cp,r,y,l]*vTechOut[h,cp,r,y,l]);

s.t.  eqTechAfLo{(h, r, y, l) in meqTechAfLo}: pTechAfLo[h,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h) in mTechWeatherAfLo)}(pTechWeatherAfLo[w,h]*pWeather[w,r,y,l]) <=  vTechAct[h,r,y,l];

s.t.  eqTechAfUp{(h, r, y, l) in meqTechAfUp}: vTechAct[h,r,y,l] <=  pTechAfUp[h,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h) in mTechWeatherAfUp)}(pTechWeatherAfUp[w,h]*pWeather[w,r,y,l]);

s.t.  eqTechAfsLo{(h, r, y, l) in meqTechAfsLo}: pTechAfsLo[h,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h) in mTechWeatherAfsLo)}(pTechWeatherAfsLo[w,h]*pWeather[w,r,y,l]) <=  sum{lp in slice:((l,lp) in mSliceParentChildE)}(sum{FORIF: (h,r,y,lp) in mvTechAct} (vTechAct[h,r,y,lp]));

s.t.  eqTechAfsUp{(h, r, y, l) in meqTechAfsUp}: sum{lp in slice:((l,lp) in mSliceParentChildE)}(sum{FORIF: (h,r,y,lp) in mvTechAct} (vTechAct[h,r,y,lp])) <=  pTechAfsUp[h,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h) in mTechWeatherAfsUp)}(pTechWeatherAfsUp[w,h]*pWeather[w,r,y,l]);

s.t.  eqTechRampUp{(h, r, y, l) in mTechRampUp}: (vTechAct[h,r,y,l]) / (pSliceShare[l])-sum{lp in slice:((((h in mTechFullYear and (lp,l) in mSliceNext) or (not((h in mTechFullYear)) and (lp,l) in mSliceFYearNext)) and (h,r,y,lp) in mvTechAct))}((vTechAct[h,r,y,lp]) / (pSliceShare[lp])) <=  (pSliceShare[l]*365*24*pTechCap2act[h]*vTechCap[h,r,y]) / (pTechRampUp[h,r,y,l]);

s.t.  eqTechRampDown{(h, r, y, l) in mTechRampDown}: sum{lp in slice:((((h in mTechFullYear and (lp,l) in mSliceNext) or (not((h in mTechFullYear)) and (lp,l) in mSliceFYearNext)) and (h,r,y,lp) in mvTechAct))}((vTechAct[h,r,y,lp]) / (pSliceShare[lp]))-(vTechAct[h,r,y,l]) / (pSliceShare[l]) <=  (pSliceShare[l]*365*24*pTechCap2act[h]*vTechCap[h,r,y]) / (pTechRampDown[h,r,y,l]);

s.t.  eqTechActSng{(h, c, r, y, l) in meqTechActSng}: vTechAct[h,r,y,l]  =  (vTechOut[h,c,r,y,l]) / (pTechCact2cout[h,c,r,y,l]);

s.t.  eqTechActGrp{(h, g, r, y, l) in meqTechActGrp}: vTechAct[h,r,y,l]  =  sum{c in comm:((h,g,c) in mTechGroupComm)}(sum{FORIF: (h,c,r,y,l) in mvTechOut} (((vTechOut[h,c,r,y,l]) / (pTechCact2cout[h,c,r,y,l]))));

s.t.  eqTechAfcOutLo{(h, r, c, y, l) in meqTechAfcOutLo}: pTechCact2cout[h,c,r,y,l]*pTechAfcLo[h,c,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h,c) in mTechWeatherAfcLo)}(pTechWeatherAfcLo[w,h,c]*pWeather[w,r,y,l]) <=  vTechOut[h,c,r,y,l];

s.t.  eqTechAfcOutUp{(h, r, c, y, l) in meqTechAfcOutUp}: vTechOut[h,c,r,y,l] <=  pTechCact2cout[h,c,r,y,l]*pTechAfcUp[h,c,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*prod{w in weather:((w,h,c) in mTechWeatherAfcUp)}(pTechWeatherAfcUp[w,h,c]*pWeather[w,r,y,l]);

s.t.  eqTechAfcInpLo{(h, r, c, y, l) in meqTechAfcInpLo}: pTechAfcLo[h,c,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h,c) in mTechWeatherAfcLo)}(pTechWeatherAfcLo[w,h,c]*pWeather[w,r,y,l]) <=  vTechInp[h,c,r,y,l];

s.t.  eqTechAfcInpUp{(h, r, c, y, l) in meqTechAfcInpUp}: vTechInp[h,c,r,y,l] <=  pTechAfcUp[h,c,r,y,l]*pTechCap2act[h]*vTechCap[h,r,y]*pSliceShare[l]*prod{w in weather:((w,h,c) in mTechWeatherAfcUp)}(pTechWeatherAfcUp[w,h,c]*pWeather[w,r,y,l]);

s.t.  eqTechCap{(h, r, y) in mTechSpan}: vTechCap[h,r,y]  =  pTechStock[h,r,y]-sum{FORIF: (h,r,y) in mvTechRetiredStock} (vTechRetiredStock[h,r,y])+sum{yp in year:(((h,r,yp) in mTechNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[h,r]+ordYear[yp] or (h,r) in mTechOlifeInf)))}(pPeriodLen[yp]*(vTechNewCap[h,r,yp]-sum{ye in year:(((h,r,yp,ye) in mvTechRetiredNewCap and ordYear[y] >= ordYear[ye]))}(vTechRetiredNewCap[h,r,yp,ye])));

s.t.  eqTechRetiredNewCap{(h, r, y) in meqTechRetiredNewCap}: sum{yp in year:((h,r,y,yp) in mvTechRetiredNewCap)}(vTechRetiredNewCap[h,r,y,yp]) <=  vTechNewCap[h,r,y];

s.t.  eqTechRetiredStock{(h, r, y) in mvTechRetiredStock}: vTechRetiredStock[h,r,y] <=  pTechStock[h,r,y];

s.t.  eqTechEac{(h, r, y) in mTechEac}: vTechEac[h,r,y]  =  sum{yp in year:(((h,r,yp) in mTechNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[h,r]+ordYear[yp] or (h,r) in mTechOlifeInf)))}(pTechEac[h,r,yp]*pPeriodLen[yp]*(vTechNewCap[h,r,yp]-sum{ye in year:(((h,r,yp,ye) in mvTechRetiredNewCap and ordYear[y] >= ordYear[ye]))}(vTechRetiredNewCap[h,r,yp,ye])));

s.t.  eqTechInv{(h, r, y) in mTechInv}: vTechInv[h,r,y]  =  pTechInvcost[h,r,y]*vTechNewCap[h,r,y];

s.t.  eqTechOMCost{(h, r, y) in mTechOMCost}: vTechOMCost[h,r,y]  =  pTechFixom[h,r,y]*vTechCap[h,r,y]+sum{l in slice:((h,l) in mTechSlice)}(pTechVarom[h,r,y,l]*vTechAct[h,r,y,l]+sum{c in comm:((h,c) in mTechInpComm)}(pTechCvarom[h,c,r,y,l]*vTechInp[h,c,r,y,l])+sum{c in comm:((h,c) in mTechOutComm)}(pTechCvarom[h,c,r,y,l]*vTechOut[h,c,r,y,l])+sum{c in comm:((h,c,r,y,l) in mvTechAOut)}(pTechAvarom[h,c,r,y,l]*vTechAOut[h,c,r,y,l])+sum{c in comm:((h,c,r,y,l) in mvTechAInp)}(pTechAvarom[h,c,r,y,l]*vTechAInp[h,c,r,y,l]));

s.t.  eqSupAvaUp{(u, c, r, y, l) in mSupAvaUp}: vSupOut[u,c,r,y,l] <=  pSupAvaUp[u,c,r,y,l]*prod{w in weather:((w,u) in mSupWeatherUp)}(pSupWeatherUp[w,u]*pWeather[w,r,y,l]);

s.t.  eqSupAvaLo{(u, c, r, y, l) in meqSupAvaLo}: vSupOut[u,c,r,y,l]  >=  pSupAvaLo[u,c,r,y,l]*prod{w in weather:((w,u) in mSupWeatherLo)}(pSupWeatherLo[w,u]*pWeather[w,r,y,l]);

s.t.  eqSupTotal{(u, c, r) in mvSupReserve}: vSupReserve[u,c,r]  =  sum{y in year,l in slice:((u,c,r,y,l) in mSupAva)}(pPeriodLen[y]*vSupOut[u,c,r,y,l]);

s.t.  eqSupReserveUp{(u, c, r) in mSupReserveUp}: pSupReserveUp[u,c,r]  >=  vSupReserve[u,c,r];

s.t.  eqSupReserveLo{(u, c, r) in meqSupReserveLo}: vSupReserve[u,c,r]  >=  pSupReserveLo[u,c,r];

s.t.  eqSupCost{(u, r, y) in mvSupCost}: vSupCost[u,r,y]  =  sum{c in comm,l in slice:((u,c,r,y,l) in mSupAva)}(pSupCost[u,c,r,y,l]*vSupOut[u,c,r,y,l]);

s.t.  eqDemInp{(c, r, y, l) in mvDemInp}: vDemInp[c,r,y,l]  =  sum{d in trade:((d,c) in mDemComm)}(pDemand[d,c,r,y,l]);

s.t.  eqAggOut{(c, r, y, l) in mAggOut}: vAggOut[c,r,y,l]  =  sum{cp in comm:((c,cp) in mAggregateFactor)}(pAggregateFactor[c,cp]*sum{lp in slice:(((c,r,y,lp) in mvOutTot and (l,lp) in mSliceParentChildE and (cp,lp) in mCommSlice))}(vOutTot[cp,r,y,lp]));

s.t.  eqEmsFuelTot{(c, r, y, l) in mEmsFuelTot}: vEmsFuelTot[c,r,y,l]  =  sum{cp in comm:((pEmissionFactor[c,cp]>0))}(pEmissionFactor[c,cp]*sum{h in tech:((h,cp) in mTechInpComm)}(pTechEmisComm[h,cp]*sum{lp in slice:((c,l,lp) in mCommSliceOrParent)}(sum{FORIF: (h,c,cp,r,y,lp) in mTechEmsFuel} (vTechInp[h,cp,r,y,lp]))));

s.t.  eqStorageAInp{(s, c, r, y, l) in mvStorageAInp}: vStorageAInp[s,c,r,y,l]  =  sum{cp in comm:((s,cp) in mStorageComm)}(sum{FORIF: (s,c,r,y,l) in mStorageStg2AInp} ((pStorageStg2AInp[s,c,r,y,l]*vStorageStore[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCinp2AInp} ((pStorageCinp2AInp[s,c,r,y,l]*vStorageInp[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCout2AInp} ((pStorageCout2AInp[s,c,r,y,l]*vStorageOut[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCap2AInp} ((pStorageCap2AInp[s,c,r,y,l]*vStorageCap[s,r,y]))+sum{FORIF: (s,c,r,y,l) in mStorageNCap2AInp} ((pStorageNCap2AInp[s,c,r,y,l]*vStorageNewCap[s,r,y])));

s.t.  eqStorageAOut{(s, c, r, y, l) in mvStorageAOut}: vStorageAOut[s,c,r,y,l]  =  sum{cp in comm:((s,cp) in mStorageComm)}(sum{FORIF: (s,c,r,y,l) in mStorageStg2AOut} ((pStorageStg2AOut[s,c,r,y,l]*vStorageStore[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCinp2AOut} ((pStorageCinp2AOut[s,c,r,y,l]*vStorageInp[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCout2AOut} ((pStorageCout2AOut[s,c,r,y,l]*vStorageOut[s,cp,r,y,l]))+sum{FORIF: (s,c,r,y,l) in mStorageCap2AOut} ((pStorageCap2AOut[s,c,r,y,l]*vStorageCap[s,r,y]))+sum{FORIF: (s,c,r,y,l) in mStorageNCap2AOut} ((pStorageNCap2AOut[s,c,r,y,l]*vStorageNewCap[s,r,y])));

s.t.  eqStorageStore{(s, c, r, y, l) in mvStorageStore}: vStorageStore[s,c,r,y,l]  =  pStorageCharge[s,c,r,y,l]+sum{FORIF: (s,r,y) in mStorageNew} ((pStorageNCap2Stg[s,c,r,y,l]*vStorageNewCap[s,r,y]))+sum{lp in slice:(((c,lp) in mCommSlice and ((not((s in mStorageFullYear)) and (lp,l) in mSliceNext) or (s in mStorageFullYear and (lp,l) in mSliceFYearNext))))}(pStorageInpEff[s,c,r,y,lp]*vStorageInp[s,c,r,y,lp]+((pStorageStgEff[s,c,r,y,l])^(pSliceShare[l]))*vStorageStore[s,c,r,y,lp]-(vStorageOut[s,c,r,y,lp]) / (pStorageOutEff[s,c,r,y,lp]));

s.t.  eqStorageAfLo{(s, c, r, y, l) in meqStorageAfLo}: vStorageStore[s,c,r,y,l]  >=  pStorageAfLo[s,r,y,l]*pStorageCap2stg[s]*vStorageCap[s,r,y]*prod{w in weather:((w,s) in mStorageWeatherAfLo)}(pStorageWeatherAfLo[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageAfUp{(s, c, r, y, l) in meqStorageAfUp}: vStorageStore[s,c,r,y,l] <=  pStorageAfUp[s,r,y,l]*pStorageCap2stg[s]*vStorageCap[s,r,y]*prod{w in weather:((w,s) in mStorageWeatherAfUp)}(pStorageWeatherAfUp[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageClean{(s, c, r, y, l) in mvStorageStore}: (vStorageOut[s,c,r,y,l]) / (pStorageOutEff[s,c,r,y,l]) <=  vStorageStore[s,c,r,y,l];

s.t.  eqStorageInpUp{(s, c, r, y, l) in meqStorageInpUp}: vStorageInp[s,c,r,y,l] <=  pStorageCap2stg[s]*vStorageCap[s,r,y]*pStorageCinpUp[s,c,r,y,l]*pSliceShare[l]*prod{w in weather:((w,s) in mStorageWeatherCinpUp)}(pStorageWeatherCinpUp[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageInpLo{(s, c, r, y, l) in meqStorageInpLo}: vStorageInp[s,c,r,y,l]  >=  pStorageCap2stg[s]*vStorageCap[s,r,y]*pStorageCinpLo[s,c,r,y,l]*pSliceShare[l]*prod{w in weather:((w,s) in mStorageWeatherCinpLo)}(pStorageWeatherCinpLo[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageOutUp{(s, c, r, y, l) in meqStorageOutUp}: vStorageOut[s,c,r,y,l] <=  pStorageCap2stg[s]*vStorageCap[s,r,y]*pStorageCoutUp[s,c,r,y,l]*pSliceShare[l]*prod{w in weather:((w,s) in mStorageWeatherCoutUp)}(pStorageWeatherCoutUp[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageOutLo{(s, c, r, y, l) in meqStorageOutLo}: vStorageOut[s,c,r,y,l]  >=  pStorageCap2stg[s]*vStorageCap[s,r,y]*pStorageCoutLo[s,c,r,y,l]*pSliceShare[l]*prod{w in weather:((w,s) in mStorageWeatherCoutLo)}(pStorageWeatherCoutLo[w,s]*pWeather[w,r,y,l]);

s.t.  eqStorageCap{(s, r, y) in mStorageSpan}: vStorageCap[s,r,y]  =  pStorageStock[s,r,y]+sum{yp in year:((ordYear[y] >= ordYear[yp] and ((s,r) in mStorageOlifeInf or ordYear[y]<pStorageOlife[s,r]+ordYear[yp]) and (s,r,yp) in mStorageNew))}(pPeriodLen[yp]*vStorageNewCap[s,r,yp]);

s.t.  eqStorageInv{(s, r, y) in mStorageNew}: vStorageInv[s,r,y]  =  pStorageInvcost[s,r,y]*vStorageNewCap[s,r,y];

s.t.  eqStorageEac{(s, r, y) in mStorageEac}: vStorageEac[s,r,y]  =  sum{yp in year:(((s,r,yp) in mStorageNew and ordYear[y] >= ordYear[yp] and ((s,r) in mStorageOlifeInf or ordYear[y]<pStorageOlife[s,r]+ordYear[yp]) and pStorageInvcost[s,r,yp] <> 0))}(pStorageEac[s,r,yp]*pPeriodLen[yp]*vStorageNewCap[s,r,yp]);

s.t.  eqStorageCost{(s, r, y) in mStorageOMCost}: vStorageOMCost[s,r,y]  =  pStorageFixom[s,r,y]*vStorageCap[s,r,y]+sum{c in comm:((s,c) in mStorageComm)}(sum{l in slice:((c,l) in mCommSlice)}(pStorageCostInp[s,r,y,l]*vStorageInp[s,c,r,y,l]+pStorageCostOut[s,r,y,l]*vStorageOut[s,c,r,y,l]+pStorageCostStore[s,r,y,l]*vStorageStore[s,c,r,y,l]));

s.t.  eqImport{(c, dst, y, l) in mImport}: vImport[c,dst,y,l]  =  sum{lp in slice:((c,l,lp) in mCommSliceOrParent)}(sum{d in trade:((d,c) in mTradeComm)}(sum{src in region:((d,src,dst) in mTradeRoutes)}(sum{FORIF: (d,c,src,dst,y,lp) in mvTradeIr} ((pTradeIrEff[d,src,dst,y,lp]*vTradeIr[d,c,src,dst,y,lp])))))+sum{lp in slice:((c,l,lp) in mCommSliceOrParent)}(sum{m in imp:((m,c) in mImpComm)}(sum{FORIF: (m,c,dst,y,lp) in mImportRow} (vImportRow[m,c,dst,y,lp])));

s.t.  eqExport{(c, src, y, l) in mExport}: vExport[c,src,y,l]  =  sum{lp in slice:((c,l,lp) in mCommSliceOrParent)}(sum{d in trade:((d,c) in mTradeComm)}(sum{dst in region:((d,src,dst) in mTradeRoutes)}(sum{FORIF: (d,c,src,dst,y,lp) in mvTradeIr} (vTradeIr[d,c,src,dst,y,lp]))))+sum{lp in slice:((c,l,lp) in mCommSliceOrParent)}(sum{x in expp:((x,c) in mExpComm)}(sum{FORIF: (x,c,src,y,lp) in mExportRow} (vExportRow[x,c,src,y,lp])));

s.t.  eqTradeFlowUp{(d, c, src, dst, y, l) in meqTradeFlowUp}: vTradeIr[d,c,src,dst,y,l] <=  pTradeIrUp[d,src,dst,y,l];

s.t.  eqTradeFlowLo{(d, c, src, dst, y, l) in meqTradeFlowLo}: vTradeIr[d,c,src,dst,y,l]  >=  pTradeIrLo[d,src,dst,y,l];

s.t.  eqCostTrade{(r, y) in mvTradeCost}: vTradeCost[r,y]  =  sum{FORIF: (r,y) in mvTradeRowCost} (vTradeRowCost[r,y])+sum{FORIF: (r,y) in mvTradeIrCost} (vTradeIrCost[r,y]);

s.t.  eqCostRowTrade{(r, y) in mvTradeRowCost}: vTradeRowCost[r,y]  =  sum{m in imp,c in comm,l in slice:((m,c,r,y,l) in mImportRow)}(pImportRowPrice[m,r,y,l]*vImportRow[m,c,r,y,l])-sum{x in expp,c in comm,l in slice:((x,c,r,y,l) in mExportRow)}(pExportRowPrice[x,r,y,l]*vExportRow[x,c,r,y,l]);

s.t.  eqCostIrTrade{(r, y) in mvTradeIrCost}: vTradeIrCost[r,y]  =  sum{d in trade:((d,r,y) in mTradeEac)}(vTradeEac[d,r,y])+sum{d in trade,src in region:((d,src,r) in mTradeRoutes)}(sum{c in comm:((d,c) in mTradeComm)}(sum{l in slice:((d,l) in mTradeSlice)}(sum{FORIF: (d,c,src,r,y,l) in mvTradeIr} ((((pTradeIrCost[d,src,r,y,l]+pTradeIrMarkup[d,src,r,y,l])*vTradeIr[d,c,src,r,y,l]))))))-sum{d in trade,dst in region:((d,r,dst) in mTradeRoutes)}(sum{c in comm:((d,c) in mTradeComm)}(sum{l in slice:((d,l) in mTradeSlice)}(sum{FORIF: (d,c,r,dst,y,l) in mvTradeIr} (((pTradeIrMarkup[d,r,dst,y,l]*vTradeIr[d,c,r,dst,y,l]))))));

s.t.  eqExportRowUp{(x, c, r, y, l) in mExportRowUp}: vExportRow[x,c,r,y,l] <=  pExportRowUp[x,r,y,l];

s.t.  eqExportRowLo{(x, c, r, y, l) in meqExportRowLo}: vExportRow[x,c,r,y,l]  >=  pExportRowLo[x,r,y,l];

s.t.  eqExportRowCumulative{(x, c) in mExpComm}: vExportRowAccumulated[x,c]  =  sum{r in region,y in year,l in slice:((x,c,r,y,l) in mExportRow)}(pPeriodLen[y]*vExportRow[x,c,r,y,l]);

s.t.  eqExportRowResUp{(x, c) in mExportRowAccumulatedUp}: vExportRowAccumulated[x,c] <=  pExportRowRes[x];

s.t.  eqImportRowUp{(m, c, r, y, l) in mImportRowUp}: vImportRow[m,c,r,y,l] <=  pImportRowUp[m,r,y,l];

s.t.  eqImportRowLo{(m, c, r, y, l) in meqImportRowLo}: vImportRow[m,c,r,y,l]  >=  pImportRowLo[m,r,y,l];

s.t.  eqImportRowAccumulated{(m, c) in mImpComm}: vImportRowAccumulated[m,c]  =  sum{r in region,y in year,l in slice:((m,c,r,y,l) in mImportRow)}(pPeriodLen[y]*vImportRow[m,c,r,y,l]);

s.t.  eqImportRowResUp{(m, c) in mImportRowAccumulatedUp}: vImportRowAccumulated[m,c] <=  pImportRowRes[m];

s.t.  eqTradeCapFlow{(d, c, y, l) in meqTradeCapFlow}: pSliceShare[l]*pTradeCap2Act[d]*vTradeCap[d,y]  >=  sum{src in region,dst in region:((d,c,src,dst,y,l) in mvTradeIr)}(vTradeIr[d,c,src,dst,y,l]);

s.t.  eqTradeCap{(d, y) in mTradeSpan}: vTradeCap[d,y]  =  pTradeStock[d,y]+sum{yp in year:(((d,yp) in mTradeNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTradeOlife[d]+ordYear[yp] or d in mTradeOlifeInf)))}(pPeriodLen[yp]*vTradeNewCap[d,yp]);

s.t.  eqTradeInv{(d, r, y) in mTradeInv}: vTradeInv[d,r,y]  =  pTradeInvcost[d,r,y]*vTradeNewCap[d,y];

s.t.  eqTradeEac{(d, r, y) in mTradeEac}: vTradeEac[d,r,y]  =  sum{yp in year:(((d,yp) in mTradeNew and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTradeOlife[d]+ordYear[yp] or d in mTradeOlifeInf)))}(pTradeEac[d,r,yp]*pPeriodLen[yp]*vTradeNewCap[d,yp]);

s.t.  eqTradeIrAInp{(d, c, r, y, l) in mvTradeIrAInp}: vTradeIrAInp[d,c,r,y,l]  =  sum{dst in region:((d,c,r,dst,y,l) in mTradeIrCsrc2Ainp)}(pTradeIrCsrc2Ainp[d,c,r,dst,y,l]*sum{cp in comm:((d,cp) in mTradeComm)}(vTradeIr[d,cp,r,dst,y,l]))+sum{src in region:((d,c,src,r,y,l) in mTradeIrCdst2Ainp)}(pTradeIrCdst2Ainp[d,c,src,r,y,l]*sum{cp in comm:((d,cp) in mTradeComm)}(vTradeIr[d,cp,src,r,y,l]));

s.t.  eqTradeIrAOut{(d, c, r, y, l) in mvTradeIrAOut}: vTradeIrAOut[d,c,r,y,l]  =  sum{dst in region:((d,c,r,dst,y,l) in mTradeIrCsrc2Aout)}(pTradeIrCsrc2Aout[d,c,r,dst,y,l]*sum{cp in comm:((d,cp) in mTradeComm)}(vTradeIr[d,cp,r,dst,y,l]))+sum{src in region:((d,c,src,r,y,l) in mTradeIrCdst2Aout)}(pTradeIrCdst2Aout[d,c,src,r,y,l]*sum{cp in comm:((d,cp) in mTradeComm)}(vTradeIr[d,cp,src,r,y,l]));

s.t.  eqTradeIrAInpTot{(c, r, y, l) in mvTradeIrAInpTot}: vTradeIrAInpTot[c,r,y,l]  =  sum{d in trade,lp in slice:(((c,l,lp) in mCommSliceOrParent and (d,c,r,y,lp) in mvTradeIrAInp))}(vTradeIrAInp[d,c,r,y,lp]);

s.t.  eqTradeIrAOutTot{(c, r, y, l) in mvTradeIrAOutTot}: vTradeIrAOutTot[c,r,y,l]  =  sum{d in trade,lp in slice:(((c,l,lp) in mCommSliceOrParent and (d,c,r,y,lp) in mvTradeIrAOut))}(vTradeIrAOut[d,c,r,y,lp]);

s.t.  eqBalLo{(c, r, y, l) in meqBalLo}: vBalance[c,r,y,l]  >=  0;

s.t.  eqBalUp{(c, r, y, l) in meqBalUp}: vBalance[c,r,y,l] <=  0;

s.t.  eqBalFx{(c, r, y, l) in meqBalFx}: vBalance[c,r,y,l]  =  0;

s.t.  eqBal{(c, r, y, l) in mvBalance}: vBalance[c,r,y,l]  =  sum{FORIF: (c,r,y,l) in mvOutTot} (vOutTot[c,r,y,l])-sum{FORIF: (c,r,y,l) in mvInpTot} (vInpTot[c,r,y,l]);

s.t.  eqOutTot{(c, r, y, l) in mvOutTot}: vOutTot[c,r,y,l]  =  sum{FORIF: (c,r,y,l) in mDummyImport} (vDummyImport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mSupOutTot} (vSupOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mEmsFuelTot} (vEmsFuelTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mAggOut} (vAggOut[c,r,y,l])+sum{FORIF: (c,r,y,l) in mTechOutTot} (vTechOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mStorageOutTot} (vStorageOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mImport} (vImport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mvTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mOutSub} (sum{lp in slice:(((lp,l) in mSliceParentChild and (c,r,y,lp,l) in mvOut2Lo))}(vOut2Lo[c,r,y,lp,l]));

s.t.  eqOut2Lo{(c, r, y, l) in mOut2Lo}: sum{lp in slice:((c,r,y,l,lp) in mvOut2Lo)}(vOut2Lo[c,r,y,l,lp])  =  sum{FORIF: (c,r,y,l) in mSupOutTot} (vSupOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mEmsFuelTot} (vEmsFuelTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mAggOut} (vAggOut[c,r,y,l])+sum{FORIF: (c,r,y,l) in mTechOutTot} (vTechOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mStorageOutTot} (vStorageOutTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mImport} (vImport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mvTradeIrAOutTot} (vTradeIrAOutTot[c,r,y,l]);

s.t.  eqInpTot{(c, r, y, l) in mvInpTot}: vInpTot[c,r,y,l]  =  sum{FORIF: (c,r,y,l) in mvDemInp} (vDemInp[c,r,y,l])+sum{FORIF: (c,r,y,l) in mDummyExport} (vDummyExport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mTechInpTot} (vTechInpTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mStorageInpTot} (vStorageInpTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mExport} (vExport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mvTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mInpSub} (sum{lp in slice:(((lp,l) in mSliceParentChild and (c,r,y,lp,l) in mvInp2Lo))}(vInp2Lo[c,r,y,lp,l]));

s.t.  eqInp2Lo{(c, r, y, l) in mInp2Lo}: sum{lp in slice:((c,r,y,l,lp) in mvInp2Lo)}(vInp2Lo[c,r,y,l,lp])  =  sum{FORIF: (c,r,y,l) in mTechInpTot} (vTechInpTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mStorageInpTot} (vStorageInpTot[c,r,y,l])+sum{FORIF: (c,r,y,l) in mExport} (vExport[c,r,y,l])+sum{FORIF: (c,r,y,l) in mvTradeIrAInpTot} (vTradeIrAInpTot[c,r,y,l]);

s.t.  eqSupOutTot{(c, r, y, l) in mSupOutTot}: vSupOutTot[c,r,y,l]  =  sum{u in sup:((u,c) in mSupComm)}(sum{lp in slice:(((c,l,lp) in mCommSliceOrParent and (u,c,r,y,lp) in mSupAva))}(vSupOut[u,c,r,y,lp]));

s.t.  eqTechInpTot{(c, r, y, l) in mTechInpTot}: vTechInpTot[c,r,y,l]  =  sum{h in tech:((h,c) in mTechInpComm)}(sum{lp in slice:(((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent))}(sum{FORIF: (h,c,r,y,lp) in mvTechInp} (vTechInp[h,c,r,y,lp])))+sum{h in tech:((h,c) in mTechAInp)}(sum{lp in slice:(((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent))}(sum{FORIF: (h,c,r,y,lp) in mvTechAInp} (vTechAInp[h,c,r,y,lp])));

s.t.  eqTechOutTot{(c, r, y, l) in mTechOutTot}: vTechOutTot[c,r,y,l]  =  sum{h in tech:((h,c) in mTechOutComm)}(sum{lp in slice:(((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent))}(sum{FORIF: (h,c,r,y,lp) in mvTechOut} (vTechOut[h,c,r,y,lp])))+sum{h in tech:((h,c) in mTechAOut)}(sum{lp in slice:(((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent))}(sum{FORIF: (h,c,r,y,lp) in mvTechAOut} (vTechAOut[h,c,r,y,lp])));

s.t.  eqStorageInpTot{(c, r, y, l) in mStorageInpTot}: vStorageInpTot[c,r,y,l]  =  sum{s in stg:((s,c,r,y,l) in mvStorageStore)}(vStorageInp[s,c,r,y,l])+sum{s in stg:((s,c,r,y,l) in mvStorageAInp)}(vStorageAInp[s,c,r,y,l]);

s.t.  eqStorageOutTot{(c, r, y, l) in mStorageOutTot}: vStorageOutTot[c,r,y,l]  =  sum{s in stg:((s,c,r,y,l) in mvStorageStore)}(vStorageOut[s,c,r,y,l])+sum{s in stg:((s,c,r,y,l) in mvStorageAOut)}(vStorageAOut[s,c,r,y,l]);

s.t.  eqCost{(r, y) in mvTotalCost}: vTotalCost[r,y]  =  sum{h in tech:((h,r,y) in mTechEac)}(vTechEac[h,r,y])+sum{h in tech:((h,r,y) in mTechOMCost)}(vTechOMCost[h,r,y])+sum{u in sup:((u,r,y) in mvSupCost)}(vSupCost[u,r,y])+sum{c in comm,l in slice:((c,r,y,l) in mDummyImport)}(pDummyImportCost[c,r,y,l]*vDummyImport[c,r,y,l])+sum{c in comm,l in slice:((c,r,y,l) in mDummyExport)}(pDummyExportCost[c,r,y,l]*vDummyExport[c,r,y,l])+sum{c in comm:((c,r,y) in mTaxCost)}(vTaxCost[c,r,y])-sum{c in comm:((c,r,y) in mSubCost)}(vSubsCost[c,r,y])+sum{s in stg:((s,r,y) in mStorageOMCost)}(vStorageOMCost[s,r,y])+sum{s in stg:((s,r,y) in mStorageEac)}(vStorageEac[s,r,y])+sum{FORIF: (r,y) in mvTradeCost} (vTradeCost[r,y])+sum{FORIF: (r,y) in mvTotalUserCosts} (vTotalUserCosts[r,y]);

s.t.  eqTaxCost{(c, r, y) in mTaxCost}: vTaxCost[c,r,y]  =  sum{l in slice:(((c,r,y,l) in mvOutTot and (c,l) in mCommSlice))}(pTaxCostOut[c,r,y,l]*vOutTot[c,r,y,l])+sum{l in slice:(((c,r,y,l) in mvInpTot and (c,l) in mCommSlice))}(pTaxCostInp[c,r,y,l]*vInpTot[c,r,y,l])+sum{l in slice:(((c,r,y,l) in mvBalance and (c,l) in mCommSlice))}(pTaxCostBal[c,r,y,l]*vBalance[c,r,y,l]);

s.t.  eqSubsCost{(c, r, y) in mSubCost}: vSubsCost[c,r,y]  =  sum{l in slice:(((c,r,y,l) in mvOutTot and (c,l) in mCommSlice))}(pSubCostOut[c,r,y,l]*vOutTot[c,r,y,l])+sum{l in slice:(((c,r,y,l) in mvInpTot and (c,l) in mCommSlice))}(pSubCostInp[c,r,y,l]*vInpTot[c,r,y,l])+sum{l in slice:(((c,r,y,l) in mvBalance and (c,l) in mCommSlice))}(pSubCostBal[c,r,y,l]*vBalance[c,r,y,l]);

s.t.  eqObjective: vObjective  =  sum{r in region,y in year:((r,y) in mvTotalCost)}(vTotalCost[r,y]*pDiscountFactorMileStone[r,y]);

s.t.  eqLECActivity{(h, r, y) in meqLECActivity}: sum{l in slice:((h,l) in mTechSlice)}(vTechAct[h,r,y,l])  >=  pLECLoACT[r];

printf  '"solver",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
minimize vObjective2 : vObjective;

solve;


printf  '"solution status",1,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
printf  '"export results",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
printf "tech,region,year,value\n" > "output/vTechNewCap.csv";
for{(h, r, y) in mTechNew : vTechNewCap[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechNewCap[h,r,y] >> "output/vTechNewCap.csv";
}
printf "tech,region,year,value\n" > "output/vTechRetiredStock.csv";
for{(h, r, y) in mvTechRetiredStock : vTechRetiredStock[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechRetiredStock[h,r,y] >> "output/vTechRetiredStock.csv";
}
printf "tech,region,year,yearp,value\n" > "output/vTechRetiredNewCap.csv";
for{(h, r, y, yp) in mvTechRetiredNewCap : vTechRetiredNewCap[h,r,y,yp] <> 0} {
  printf "%s,%s,%s,%s,%f\n", h,r,y,yp,vTechRetiredNewCap[h,r,y,yp] >> "output/vTechRetiredNewCap.csv";
}
printf "tech,region,year,value\n" > "output/vTechCap.csv";
for{(h, r, y) in mTechSpan : vTechCap[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechCap[h,r,y] >> "output/vTechCap.csv";
}
printf "tech,region,year,slice,value\n" > "output/vTechAct.csv";
for{(h, r, y, l) in mvTechAct : vTechAct[h,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", h,r,y,l,vTechAct[h,r,y,l] >> "output/vTechAct.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechInp.csv";
for{(h, c, r, y, l) in mvTechInp : vTechInp[h,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", h,c,r,y,l,vTechInp[h,c,r,y,l] >> "output/vTechInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechOut.csv";
for{(h, c, r, y, l) in mvTechOut : vTechOut[h,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", h,c,r,y,l,vTechOut[h,c,r,y,l] >> "output/vTechOut.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechAInp.csv";
for{(h, c, r, y, l) in mvTechAInp : vTechAInp[h,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", h,c,r,y,l,vTechAInp[h,c,r,y,l] >> "output/vTechAInp.csv";
}
printf "tech,comm,region,year,slice,value\n" > "output/vTechAOut.csv";
for{(h, c, r, y, l) in mvTechAOut : vTechAOut[h,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", h,c,r,y,l,vTechAOut[h,c,r,y,l] >> "output/vTechAOut.csv";
}
printf "tech,region,year,value\n" > "output/vTechInv.csv";
for{(h, r, y) in mTechInv : vTechInv[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechInv[h,r,y] >> "output/vTechInv.csv";
}
printf "tech,region,year,value\n" > "output/vTechEac.csv";
for{(h, r, y) in mTechEac : vTechEac[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechEac[h,r,y] >> "output/vTechEac.csv";
}
printf "tech,region,year,value\n" > "output/vTechOMCost.csv";
for{(h, r, y) in mTechOMCost : vTechOMCost[h,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", h,r,y,vTechOMCost[h,r,y] >> "output/vTechOMCost.csv";
}
printf "sup,comm,region,year,slice,value\n" > "output/vSupOut.csv";
for{(u, c, r, y, l) in mSupAva : vSupOut[u,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", u,c,r,y,l,vSupOut[u,c,r,y,l] >> "output/vSupOut.csv";
}
printf "sup,comm,region,value\n" > "output/vSupReserve.csv";
for{(u, c, r) in mvSupReserve : vSupReserve[u,c,r] <> 0} {
  printf "%s,%s,%s,%f\n", u,c,r,vSupReserve[u,c,r] >> "output/vSupReserve.csv";
}
printf "sup,region,year,value\n" > "output/vSupCost.csv";
for{(u, r, y) in mvSupCost : vSupCost[u,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", u,r,y,vSupCost[u,r,y] >> "output/vSupCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDemInp.csv";
for{(c, r, y, l) in mvDemInp : vDemInp[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vDemInp[c,r,y,l] >> "output/vDemInp.csv";
}
printf "comm,region,year,slice,value\n" > "output/vEmsFuelTot.csv";
for{(c, r, y, l) in mEmsFuelTot : vEmsFuelTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vEmsFuelTot[c,r,y,l] >> "output/vEmsFuelTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vBalance.csv";
for{(c, r, y, l) in mvBalance : vBalance[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vBalance[c,r,y,l] >> "output/vBalance.csv";
}
printf "comm,region,year,slice,value\n" > "output/vOutTot.csv";
for{(c, r, y, l) in mvOutTot : vOutTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vOutTot[c,r,y,l] >> "output/vOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vInpTot.csv";
for{(c, r, y, l) in mvInpTot : vInpTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vInpTot[c,r,y,l] >> "output/vInpTot.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "output/vInp2Lo.csv";
for{(c, r, y, l, lp) in mvInp2Lo : vInp2Lo[c,r,y,l,lp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,l,lp,vInp2Lo[c,r,y,l,lp] >> "output/vInp2Lo.csv";
}
printf "comm,region,year,slice,slicep,value\n" > "output/vOut2Lo.csv";
for{(c, r, y, l, lp) in mvOut2Lo : vOut2Lo[c,r,y,l,lp] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", c,r,y,l,lp,vOut2Lo[c,r,y,l,lp] >> "output/vOut2Lo.csv";
}
printf "comm,region,year,slice,value\n" > "output/vSupOutTot.csv";
for{(c, r, y, l) in mSupOutTot : vSupOutTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vSupOutTot[c,r,y,l] >> "output/vSupOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTechInpTot.csv";
for{(c, r, y, l) in mTechInpTot : vTechInpTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vTechInpTot[c,r,y,l] >> "output/vTechInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTechOutTot.csv";
for{(c, r, y, l) in mTechOutTot : vTechOutTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vTechOutTot[c,r,y,l] >> "output/vTechOutTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vStorageInpTot.csv";
for{(c, r, y, l) in mStorageInpTot : vStorageInpTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vStorageInpTot[c,r,y,l] >> "output/vStorageInpTot.csv";
}
printf "comm,region,year,slice,value\n" > "output/vStorageOutTot.csv";
for{(c, r, y, l) in mStorageOutTot : vStorageOutTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vStorageOutTot[c,r,y,l] >> "output/vStorageOutTot.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageAInp.csv";
for{(s, c, r, y, l) in mvStorageAInp : vStorageAInp[s,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s,c,r,y,l,vStorageAInp[s,c,r,y,l] >> "output/vStorageAInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageAOut.csv";
for{(s, c, r, y, l) in mvStorageAOut : vStorageAOut[s,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s,c,r,y,l,vStorageAOut[s,c,r,y,l] >> "output/vStorageAOut.csv";
}
printf "region,year,value\n" > "output/vTotalCost.csv";
for{(r, y) in mvTotalCost : vTotalCost[r,y] <> 0} {
  printf "%s,%s,%f\n", r,y,vTotalCost[r,y] >> "output/vTotalCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDummyImport.csv";
for{(c, r, y, l) in mDummyImport : vDummyImport[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vDummyImport[c,r,y,l] >> "output/vDummyImport.csv";
}
printf "comm,region,year,slice,value\n" > "output/vDummyExport.csv";
for{(c, r, y, l) in mDummyExport : vDummyExport[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vDummyExport[c,r,y,l] >> "output/vDummyExport.csv";
}
printf "comm,region,year,value\n" > "output/vTaxCost.csv";
for{(c, r, y) in mTaxCost : vTaxCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vTaxCost[c,r,y] >> "output/vTaxCost.csv";
}
printf "comm,region,year,value\n" > "output/vSubsCost.csv";
for{(c, r, y) in mSubCost : vSubsCost[c,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", c,r,y,vSubsCost[c,r,y] >> "output/vSubsCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vAggOut.csv";
for{(c, r, y, l) in mAggOut : vAggOut[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vAggOut[c,r,y,l] >> "output/vAggOut.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageInp.csv";
for{(s, c, r, y, l) in mvStorageStore : vStorageInp[s,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s,c,r,y,l,vStorageInp[s,c,r,y,l] >> "output/vStorageInp.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageOut.csv";
for{(s, c, r, y, l) in mvStorageStore : vStorageOut[s,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s,c,r,y,l,vStorageOut[s,c,r,y,l] >> "output/vStorageOut.csv";
}
printf "stg,comm,region,year,slice,value\n" > "output/vStorageStore.csv";
for{(s, c, r, y, l) in mvStorageStore : vStorageStore[s,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", s,c,r,y,l,vStorageStore[s,c,r,y,l] >> "output/vStorageStore.csv";
}
printf "stg,region,year,value\n" > "output/vStorageInv.csv";
for{(s, r, y) in mStorageNew : vStorageInv[s,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s,r,y,vStorageInv[s,r,y] >> "output/vStorageInv.csv";
}
printf "stg,region,year,value\n" > "output/vStorageEac.csv";
for{(s, r, y) in mStorageEac : vStorageEac[s,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s,r,y,vStorageEac[s,r,y] >> "output/vStorageEac.csv";
}
printf "stg,region,year,value\n" > "output/vStorageCap.csv";
for{(s, r, y) in mStorageSpan : vStorageCap[s,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s,r,y,vStorageCap[s,r,y] >> "output/vStorageCap.csv";
}
printf "stg,region,year,value\n" > "output/vStorageNewCap.csv";
for{(s, r, y) in mStorageNew : vStorageNewCap[s,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s,r,y,vStorageNewCap[s,r,y] >> "output/vStorageNewCap.csv";
}
printf "stg,region,year,value\n" > "output/vStorageOMCost.csv";
for{(s, r, y) in mStorageOMCost : vStorageOMCost[s,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", s,r,y,vStorageOMCost[s,r,y] >> "output/vStorageOMCost.csv";
}
printf "comm,region,year,slice,value\n" > "output/vImport.csv";
for{(c, r, y, l) in mImport : vImport[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vImport[c,r,y,l] >> "output/vImport.csv";
}
printf "comm,region,year,slice,value\n" > "output/vExport.csv";
for{(c, r, y, l) in mExport : vExport[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vExport[c,r,y,l] >> "output/vExport.csv";
}
printf "trade,comm,src,dst,year,slice,value\n" > "output/vTradeIr.csv";
for{(d, c, src, dst, y, l) in mvTradeIr : vTradeIr[d,c,src,dst,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%s,%f\n", d,c,src,dst,y,l,vTradeIr[d,c,src,dst,y,l] >> "output/vTradeIr.csv";
}
printf "trade,comm,region,year,slice,value\n" > "output/vTradeIrAInp.csv";
for{(d, c, r, y, l) in mvTradeIrAInp : vTradeIrAInp[d,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", d,c,r,y,l,vTradeIrAInp[d,c,r,y,l] >> "output/vTradeIrAInp.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTradeIrAInpTot.csv";
for{(c, r, y, l) in mvTradeIrAInpTot : vTradeIrAInpTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vTradeIrAInpTot[c,r,y,l] >> "output/vTradeIrAInpTot.csv";
}
printf "trade,comm,region,year,slice,value\n" > "output/vTradeIrAOut.csv";
for{(d, c, r, y, l) in mvTradeIrAOut : vTradeIrAOut[d,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", d,c,r,y,l,vTradeIrAOut[d,c,r,y,l] >> "output/vTradeIrAOut.csv";
}
printf "comm,region,year,slice,value\n" > "output/vTradeIrAOutTot.csv";
for{(c, r, y, l) in mvTradeIrAOutTot : vTradeIrAOutTot[c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%f\n", c,r,y,l,vTradeIrAOutTot[c,r,y,l] >> "output/vTradeIrAOutTot.csv";
}
printf "expp,comm,value\n" > "output/vExportRowAccumulated.csv";
for{(x, c) in mExpComm : vExportRowAccumulated[x,c] <> 0} {
  printf "%s,%s,%f\n", x,c,vExportRowAccumulated[x,c] >> "output/vExportRowAccumulated.csv";
}
printf "expp,comm,region,year,slice,value\n" > "output/vExportRow.csv";
for{(x, c, r, y, l) in mExportRow : vExportRow[x,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", x,c,r,y,l,vExportRow[x,c,r,y,l] >> "output/vExportRow.csv";
}
printf "imp,comm,value\n" > "output/vImportRowAccumulated.csv";
for{(m, c) in mImpComm : vImportRowAccumulated[m,c] <> 0} {
  printf "%s,%s,%f\n", m,c,vImportRowAccumulated[m,c] >> "output/vImportRowAccumulated.csv";
}
printf "imp,comm,region,year,slice,value\n" > "output/vImportRow.csv";
for{(m, c, r, y, l) in mImportRow : vImportRow[m,c,r,y,l] <> 0} {
  printf "%s,%s,%s,%s,%s,%f\n", m,c,r,y,l,vImportRow[m,c,r,y,l] >> "output/vImportRow.csv";
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
for{(d, y) in mTradeSpan : vTradeCap[d,y] <> 0} {
  printf "%s,%s,%f\n", d,y,vTradeCap[d,y] >> "output/vTradeCap.csv";
}
printf "trade,region,year,value\n" > "output/vTradeInv.csv";
for{(d, r, y) in mTradeEac : vTradeInv[d,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", d,r,y,vTradeInv[d,r,y] >> "output/vTradeInv.csv";
}
printf "trade,region,year,value\n" > "output/vTradeEac.csv";
for{(d, r, y) in mTradeEac : vTradeEac[d,r,y] <> 0} {
  printf "%s,%s,%s,%f\n", d,r,y,vTradeEac[d,r,y] >> "output/vTradeEac.csv";
}
printf "trade,year,value\n" > "output/vTradeNewCap.csv";
for{(d, y) in mTradeNew : vTradeNewCap[d,y] <> 0} {
  printf "%s,%s,%f\n", d,y,vTradeNewCap[d,y] >> "output/vTradeNewCap.csv";
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
    printf "vAggOut\n" >> "output/variable_list.csv";
    printf "vStorageOMCost\n" >> "output/variable_list.csv";
    printf "vTradeCost\n" >> "output/variable_list.csv";
    printf "vTradeRowCost\n" >> "output/variable_list.csv";
    printf "vTradeIrCost\n" >> "output/variable_list.csv";
    printf "vTechNewCap\n" >> "output/variable_list.csv";
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
    printf "vImport\n" >> "output/variable_list.csv";
    printf "vExport\n" >> "output/variable_list.csv";
    printf "vTradeIr\n" >> "output/variable_list.csv";
    printf "vTradeIrAInp\n" >> "output/variable_list.csv";
    printf "vTradeIrAInpTot\n" >> "output/variable_list.csv";
    printf "vTradeIrAOut\n" >> "output/variable_list.csv";
    printf "vTradeIrAOutTot\n" >> "output/variable_list.csv";
    printf "vExportRowAccumulated\n" >> "output/variable_list.csv";
    printf "vExportRow\n" >> "output/variable_list.csv";
    printf "vImportRowAccumulated\n" >> "output/variable_list.csv";
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
for {l in slice} {
    printf "slice,%s\n", l >> "output/raw_data_set.csv";
}
for {u in sup} {
    printf "sup,%s\n", u >> "output/raw_data_set.csv";
}
for {d in dem} {
    printf "dem,%s\n", d >> "output/raw_data_set.csv";
}
for {h in tech} {
    printf "tech,%s\n", h >> "output/raw_data_set.csv";
}
for {s in stg} {
    printf "stg,%s\n", s >> "output/raw_data_set.csv";
}
for {d in trade} {
    printf "trade,%s\n", d >> "output/raw_data_set.csv";
}
for {x in expp} {
    printf "expp,%s\n", x >> "output/raw_data_set.csv";
}
for {m in imp} {
    printf "imp,%s\n", m >> "output/raw_data_set.csv";
}
for {g in group} {
    printf "group,%s\n", g >> "output/raw_data_set.csv";
}
for {w in weather} {
    printf "weather,%s\n", w >> "output/raw_data_set.csv";
}
printf  '"done",,"%s"\n', time2str(gmtime(), "%Y-%m-%d %M:%H:S %TZ") >> "output/log.csv";
end;


