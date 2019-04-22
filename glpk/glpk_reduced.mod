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



param mSameRegion{region, region};
param mSameSlice{slice, slice};
param mMilestoneLast{year};
param mMilestoneNext{year, year};
param mMilestoneHasNext{year};
param mStartMilestone{year, year};
param mEndMilestone{year, year};
param mMidMilestone{year};
param mCommSlice{comm, slice};
param mTechRetirement{tech};
param mTechUpgrade{tech, tech};
param mTechInpComm{tech, comm};
param mTechOutComm{tech, comm};
param mTechInpGroup{tech, group};
param mTechOutGroup{tech, group};
param mTechOneComm{tech, comm};
param mTechGroupComm{tech, group, comm};
param mTechAInp{tech, comm};
param mTechAOut{tech, comm};
param mTechNew{tech, region, year};
param mTechSpan{tech, region, year};
param mTechSlice{tech, slice};
param mTechEmitedComm{tech, comm};
param mSupSlice{sup, slice};
param mSupComm{sup, comm};
param mSupSpan{sup, region};
param mSupWeatherLo{sup, weather};
param mSupWeatherUp{sup, weather};
param mWeatherSlice{weather, slice};
param mWeatherRegion{weather, region};
param mDemComm{dem, comm};
param mUpComm{comm};
param mLoComm{comm};
param mFxComm{comm};
param mStorageSlice{stg, slice};
param mStorageComm{stg, comm};
param mStorageAInp{stg, comm};
param mStorageAOut{stg, comm};
param mStorageNew{stg, region, year};
param mStorageSpan{stg, region, year};
param mSliceNext{slice, slice};
param mTradeSlice{trade, slice};
param mTradeComm{trade, comm};
param mTradeSrc{trade, region};
param mTradeDst{trade, region};
param mTradeIrAInp{trade, comm};
param mTradeIrAOut{trade, comm};
param mTradeIrCdstAInp{trade, comm};
param mTradeIrCdstAOut{trade, comm};
param mExpComm{expp, comm};
param mImpComm{imp, comm};
param mExpSlice{expp, slice};
param mImpSlice{imp, slice};
param mDiscountZero{region};
param mAllSliceParentChild{slice, slice};
param mTechWeatherAf{tech, weather};
param mTechWeatherAfs{tech, weather};
param mTechWeatherAfc{tech, weather, comm};
param mStorageWeatherAf{stg, weather};
param mStorageWeatherCinp{stg, weather};
param mStorageWeatherCout{stg, weather};
param mTechInpTot{comm, region, year, slice};
param mTechOutTot{comm, region, year, slice};
param mSupOutTot{comm, region, slice};
param mDemInp{comm, slice};
param mEmsFuelTot{comm, region, year, slice};
param mTechEmsFuel{tech, comm, region, year, slice};
param mDummyImport{comm, region, year, slice};
param mDummyExport{comm, region, year, slice};
param mDummyCost{comm, region, year};
param mTradeIr{trade, region, region, year, slice};
param mTradeIrUp{trade, region, region, year, slice};
param mTradeIrAInp2{trade, comm, region, year, slice};
param mTradeIrAInpTot{comm, region, year, slice};
param mTradeIrAOut2{trade, comm, region, year, slice};
param mTradeIrAOutTot{comm, region, year, slice};
param mImportRow{imp, comm, region, year, slice};
param mImportRowUp{imp, comm, region, year, slice};
param mImportRowAccumulatedUp{imp, comm};
param mExportRow{expp, comm, region, year, slice};
param mExportRowUp{expp, comm, region, year, slice};
param mExportRowAccumulatedUp{expp, comm};
param mExport{comm, region, year, slice};
param mImport{comm, region, year, slice};
param mStorageInpTot{comm, region, year, slice};
param mStorageOutTot{comm, region, year, slice};
param mTaxCost{comm, region, year};
param mSubsCost{comm, region, year};
param mAggOut{comm, region, year, slice};
param mTechAfUp{tech, region, year, slice};
param mTechOlifeInf{tech, region};
param mStorageOlifeInf{stg, region};
param mTechAfcUp{tech, comm, region, year, slice};
param mSupAvaUp{sup, comm, region, year, slice};
param mSupReserveUp{sup, comm, region};
param mOut2Lo{comm, region, year, slice};
param mInp2Lo{comm, region, year, slice};
param mLECRegion{region};




param ordYear{year};
param cardYear{year};
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
var vStorageCost{stg, region, year};
var vTradeCost{region, year};
var vTradeRowCost{region, year};
var vTradeIrCost{region, year};




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
var vInp2Lo{comm, region, year, slicep, slice} >= 0;
var vOut2Lo{comm, region, year, slicep, slice} >= 0;
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




s.t.  eqTechSng2Sng{ t in tech,r in region,c in comm,cp in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpComm[t,c] and mTechOneComm[t,c] and mTechOutComm[t,cp] and mTechOneComm[t,cp] and pTechCinp2use[t,c,r,y,s] <> 0)}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechGrp2Sng{ t in tech,r in region,g in group,cp in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpGroup[t,g] and mTechOutComm[t,cp] and mTechOneComm[t,cp])}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:((mTechInpComm[t,c] and mTechGroupComm[t,g,c]))}(vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])  =  (vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechSng2Grp{ t in tech,r in region,c in comm,gp in group,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpComm[t,c] and mTechOneComm[t,c] and mTechOutGroup[t,gp] and pTechCinp2use[t,c,r,y,s] <> 0)}: vTechInp[t,c,r,y,s]*pTechCinp2use[t,c,r,y,s]  =  sum{cp in comm:((mTechOutComm[t,cp] and mTechGroupComm[t,gp,cp]))}((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechGrp2Grp{ t in tech,r in region,g in group,gp in group,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpGroup[t,g] and mTechOutGroup[t,gp])}: pTechGinp2use[t,g,r,y,s]*sum{c in comm:((mTechInpComm[t,c] and mTechGroupComm[t,g,c]))}(vTechInp[t,c,r,y,s]*pTechCinp2ginp[t,c,r,y,s])  =  sum{cp in comm:((mTechOutComm[t,cp] and mTechGroupComm[t,gp,cp]))}((vTechOut[t,cp,r,y,s]) / (pTechUse2cact[t,cp,r,y,s]*pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechUse2Sng{ t in tech,r in region,cp in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutComm[t,cp] and mTechOneComm[t,cp])}: vTechUse[t,r,y,s]  =  (vTechOut[t,cp,r,y,s]) / (pTechCact2cout[t,cp,r,y,s]);

s.t.  eqTechUse2Grp{ t in tech,r in region,gp in group,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutGroup[t,gp])}: vTechUse[t,r,y,s]  =  sum{cp in comm:((mTechOutComm[t,cp] and mTechGroupComm[t,gp,cp]))}((vTechOut[t,cp,r,y,s]) / (pTechCact2cout[t,cp,r,y,s]));

s.t.  eqTechShareInpLo{ t in tech,r in region,g in group,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpGroup[t,g] and mTechInpComm[t,c] and mTechGroupComm[t,g,c] and pTechShareLo[t,c,r,y,s] <> 0)}: vTechInp[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:((mTechInpComm[t,cp] and mTechGroupComm[t,g,cp]))}(vTechInp[t,cp,r,y,s]);

s.t.  eqTechShareInpUp{ t in tech,r in region,g in group,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpGroup[t,g] and mTechInpComm[t,c] and mTechGroupComm[t,g,c] and pTechShareUp[t,c,r,y,s] <> 1)}: vTechInp[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:((mTechInpComm[t,cp] and mTechGroupComm[t,g,cp]))}(vTechInp[t,cp,r,y,s]);

s.t.  eqTechShareOutLo{ t in tech,r in region,g in group,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutGroup[t,g] and mTechOutComm[t,c] and mTechGroupComm[t,g,c] and pTechShareLo[t,c,r,y,s] <> 0)}: vTechOut[t,c,r,y,s]  >=  pTechShareLo[t,c,r,y,s]*sum{cp in comm:((mTechOutComm[t,cp] and mTechGroupComm[t,g,cp]))}(vTechOut[t,cp,r,y,s]);

s.t.  eqTechShareOutUp{ t in tech,r in region,g in group,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutGroup[t,g] and mTechOutComm[t,c] and mTechGroupComm[t,g,c] and pTechShareUp[t,c,r,y,s] <> 1)}: vTechOut[t,c,r,y,s] <=  pTechShareUp[t,c,r,y,s]*sum{cp in comm:((mTechOutComm[t,cp] and mTechGroupComm[t,g,cp]))}(vTechOut[t,cp,r,y,s]);

s.t.  eqTechAInp{ t in tech,c in comm,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechAInp[t,c] and mTechSpan[t,r,y])}: vTechAInp[t,c,r,y,s]  =  (vTechUse[t,r,y,s]*pTechUse2AInp[t,c,r,y,s])+(vTechAct[t,r,y,s]*pTechAct2AInp[t,c,r,y,s])+(vTechCap[t,r,y]*pTechCap2AInp[t,c,r,y,s])+(vTechNewCap[t,r,y]*pTechNCap2AInp[t,c,r,y,s])+sum{cp in comm:(pTechCinp2AInp[t,c,cp,r,y,s])}(pTechCinp2AInp[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:(pTechCout2AInp[t,c,cp,r,y,s])}(pTechCout2AInp[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAOut{ t in tech,c in comm,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechAOut[t,c] and mTechSpan[t,r,y])}: vTechAOut[t,c,r,y,s]  =  (vTechUse[t,r,y,s]*pTechUse2AOut[t,c,r,y,s])+(vTechAct[t,r,y,s]*pTechAct2AOut[t,c,r,y,s])+(vTechCap[t,r,y]*pTechCap2AOut[t,c,r,y,s])+(vTechNewCap[t,r,y]*pTechNCap2AOut[t,c,r,y,s])+sum{cp in comm:(pTechCinp2AOut[t,c,cp,r,y,s])}(pTechCinp2AOut[t,c,cp,r,y,s]*vTechInp[t,cp,r,y,s])+sum{cp in comm:(pTechCout2AOut[t,c,cp,r,y,s])}(pTechCout2AOut[t,c,cp,r,y,s]*vTechOut[t,cp,r,y,s]);

s.t.  eqTechAfLo{ t in tech,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and pTechAfLo[t,r,y,s] <> 0 and mTechSpan[t,r,y])}: pTechAfLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mTechWeatherAf[t,wth1] and pTechWeatherAfLo[t,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfLo[t,wth1]) <=  vTechAct[t,r,y,s];

s.t.  eqTechAfUp{ t in tech,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechAfUp[t,r,y,s])}: vTechAct[t,r,y,s] <=  pTechAfUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mTechWeatherAf[t,wth1] and pTechWeatherAfUp[t,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfUp[t,wth1]);

s.t.  eqTechAfsLo{ t in tech,r in region,y in year,s in slice : (mMidMilestone[y] and pTechAfsLo[t,r,y,s]>0 and mTechSpan[t,r,y])}: pTechAfsLo[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mTechWeatherAfs[t,wth1] and pTechWeatherAfsLo[t,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfsLo[t,wth1]) <=  sum{sp in slice:((mTechSlice[t,sp] and (mSameSlice[s,sp] or mAllSliceParentChild[s,sp])))}(vTechAct[t,r,y,sp]);

s.t.  eqTechAfsUp{ t in tech,r in region,y in year,s in slice : (mMidMilestone[y] and pTechAfsUp[t,r,y,s] >= 0 and mTechSpan[t,r,y])}: sum{sp in slice:((mTechSlice[t,sp] and (mSameSlice[s,sp] or mAllSliceParentChild[s,sp])))}(vTechAct[t,r,y,sp]) <=  pTechAfsUp[t,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mTechWeatherAfs[t,wth1] and pTechWeatherAfsUp[t,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfsUp[t,wth1]);

s.t.  eqTechActSng{ t in tech,c in comm,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutComm[t,c] and mTechOneComm[t,c] and pTechCact2cout[t,c,r,y,s] <> 0)}: vTechAct[t,r,y,s]  =  (vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]);

s.t.  eqTechActGrp{ t in tech,g in group,r in region,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechOutGroup[t,g] and mTechSpan[t,r,y])}: vTechAct[t,r,y,s]  =  sum{c in comm:((mTechGroupComm[t,g,c] and pTechCact2cout[t,c,r,y,s] <> 0))}((vTechOut[t,c,r,y,s]) / (pTechCact2cout[t,c,r,y,s]));

s.t.  eqTechAfcOutLo{ t in tech,r in region,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutComm[t,c] and pTechAfcLo[t,c,r,y,s] <> 0)}: pTechCact2cout[t,c,r,y,s]*pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and pTechWeatherAfcLo[t,wth1,c] >= 0 and mTechWeatherAfc[t,wth1,c] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfcLo[t,wth1,c]) <=  vTechOut[t,c,r,y,s];

s.t.  eqTechAfcOutUp{ t in tech,r in region,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechOutComm[t,c] and mTechAfUp[t,r,y,s] and mTechAfcUp[t,c,r,y,s])}: vTechOut[t,c,r,y,s] <=  pTechCact2cout[t,c,r,y,s]*pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and pTechWeatherAfcUp[t,wth1,c] >= 0 and mTechWeatherAfc[t,wth1,c] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfcUp[t,wth1,c]);

s.t.  eqTechAfcInpLo{ t in tech,r in region,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpComm[t,c] and pTechAfcLo[t,c,r,y,s] <> 0)}: pTechAfcLo[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and pTechWeatherAfcLo[t,wth1,c] >= 0 and mTechWeatherAfc[t,wth1,c] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfcLo[t,wth1,c]) <=  vTechInp[t,c,r,y,s];

s.t.  eqTechAfcInpUp{ t in tech,r in region,c in comm,y in year,s in slice : (mTechSlice[t,s] and mMidMilestone[y] and mTechSpan[t,r,y] and mTechInpComm[t,c] and mTechAfUp[t,r,y,s] and mTechAfcUp[t,c,r,y,s])}: vTechInp[t,c,r,y,s] <=  pTechAfcUp[t,c,r,y,s]*pTechCap2act[t]*vTechCap[t,r,y]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and pTechWeatherAfcUp[t,wth1,c] >= 0 and mTechWeatherAfc[t,wth1,c] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pTechWeatherAfcUp[t,wth1,c]);

s.t.  eqTechCap{ t in tech,r in region,y in year : (mMidMilestone[y] and mTechSpan[t,r,y])}: vTechCap[t,r,y]  =  pTechStock[t,r,y]+sum{yp in year:((mTechNew[t,r,yp] and mMidMilestone[yp] and ordYear[y] >= ordYear[yp] and (ordYear[y]<pTechOlife[t,r]+ordYear[yp] or mTechOlifeInf[t,r])))}(vTechNewCap[t,r,yp]-sum{ye in year:((mTechRetirement[t] and mMidMilestone[ye] and ordYear[ye] >= ordYear[yp] and ordYear[ye] <= ordYear[y]))}(vTechRetiredCap[t,r,yp,ye]));

s.t.  eqTechNewCap{ t in tech,r in region,y in year : (mMidMilestone[y] and mTechNew[t,r,y] and mTechRetirement[t])}: sum{yp in year:((mMidMilestone[yp] and ordYear[yp] >= ordYear[y] and ordYear[yp]<ordYear[y]+pTechOlife[t,r]))}(vTechRetiredCap[t,r,y,yp]) <=  vTechNewCap[t,r,y];

s.t.  eqTechEac{ t in tech,r in region,y in year : (mMidMilestone[y] and mTechSpan[t,r,y])}: vTechEac[t,r,y]  =  sum{yp in year:((mTechNew[t,r,yp] and mMidMilestone[yp] and ordYear[y] >= ordYear[yp] and ordYear[y]<pTechOlife[t,r]+ordYear[yp] and not((mTechOlifeInf[t,r])) and pTechInvcost[t,r,yp] <> 0))}((pTechInvcost[t,r,yp]*(vTechNewCap[t,r,yp]-sum{ye in year:((mTechRetirement[t] and mMidMilestone[ye] and ordYear[ye] >= ordYear[yp] and ordYear[ye] <= ordYear[y]))}(vTechRetiredCap[t,r,yp,ye]))) / ((sum{ye in year:((ordYear[ye] >= ordYear[yp] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]))}((pDiscountFactor[r,ye]) / (pDiscountFactor[r,yp]))+sum{ye in year:((ordYear[ye]=cardYear[y] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]-1 and not((mDiscountZero[r]))))}((pDiscountFactor[r,ye]*(1-(((1+pDiscount[r,ye]))^(ordYear[ye]-ordYear[yp]-pTechOlife[t,r]+1)))) / (pDiscountFactor[r,yp]*pDiscount[r,ye]))+sum{ye in year:((ordYear[ye]=cardYear[y] and ordYear[ye]<ordYear[yp]+pTechOlife[t,r]-1 and mDiscountZero[r]))}((pDiscountFactor[r,ye]*(pTechOlife[t,r]-1-ordYear[ye]+ordYear[yp])) / (pDiscountFactor[r,yp])))));

s.t.  eqTechInv{ t in tech,r in region,y in year : (mMidMilestone[y] and mTechNew[t,r,y])}: vTechInv[t,r,y]  =  pTechInvcost[t,r,y]*vTechNewCap[t,r,y];

s.t.  eqTechSalv0{ t in tech,r in region,ye in year : (mDiscountZero[r] and mMilestoneLast[ye] and sum{y in year:(mTechNew[t,r,y])}(1) <> 0)}: vTechSalv[t,r]+sum{y in year,yn in year:((mStartMilestone[yn,y] and mMidMilestone[yn] and mTechNew[t,r,yn] and ordYear[yn]+pTechOlife[t,r]-1>ordYear[ye] and not((mTechOlifeInf[t,r])) and pTechInvcost[t,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pTechInvcost[t,r,yn]*(vTechNewCap[t,r,yn]-sum{yp in year:((mTechRetirement[t]))}(vTechRetiredCap[t,r,y,yp]))) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / ((pDiscountFactor[r,ye])*((pTechOlife[t,r]+ordYear[yn]-1-ordYear[ye]))))))  =  0;

s.t.  eqTechSalv{ t in tech,r in region,ye in year : (not((mDiscountZero[r])) and mMilestoneLast[ye] and sum{y in year:(mTechNew[t,r,y])}(1) <> 0)}: vTechSalv[t,r]+sum{y in year,yn in year:((mStartMilestone[yn,y] and mMidMilestone[yn] and mTechNew[t,r,yn] and ordYear[yn]+pTechOlife[t,r]-1>ordYear[ye] and not((mTechOlifeInf[t,r])) and pTechInvcost[t,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pTechInvcost[t,r,yn]*(vTechNewCap[t,r,yn]-sum{yp in year:((mMidMilestone[yp] and mTechRetirement[t]))}(vTechRetiredCap[t,r,y,yp]))) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / (pDiscountFactor[r,ye]*(((1-((1+pDiscount[r,ye]))^(ordYear[ye]-pTechOlife[t,r]-ordYear[yn]+1))*(1+pDiscount[r,ye])) / (pDiscount[r,ye]))))))  =  0;

s.t.  eqTechOMCost{ t in tech,r in region,y in year : (mMidMilestone[y] and mTechSpan[t,r,y])}: vTechOMCost[t,r,y]  =  pTechFixom[t,r,y]*vTechCap[t,r,y]+sum{s in slice:(mTechSlice[t,s])}(pTechVarom[t,r,y,s]*vTechAct[t,r,y,s]+sum{c in comm:(mTechInpComm[t,c])}(pTechCvarom[t,c,r,y,s]*vTechInp[t,c,r,y,s])+sum{c in comm:(mTechOutComm[t,c])}(pTechCvarom[t,c,r,y,s]*vTechOut[t,c,r,y,s])+sum{c in comm:(mTechAOut[t,c])}(pTechAvarom[t,c,r,y,s]*vTechAOut[t,c,r,y,s])+sum{c in comm:(mTechAInp[t,c])}(pTechAvarom[t,c,r,y,s]*vTechAInp[t,c,r,y,s]));

s.t.  eqSupAvaUp{ s1 in sup,c in comm,r in region,y in year,s in slice : mSupAvaUp[s1,c,r,y,s]}: vSupOut[s1,c,r,y,s] <=  pSupAvaUp[s1,c,r,y,s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mSupWeatherUp[s1,wth1] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pSupWeatherUp[s1,wth1]);

s.t.  eqSupAvaLo{ s1 in sup,c in comm,r in region,y in year,s in slice : (mSupSlice[s1,s] and mMidMilestone[y] and mSupComm[s1,c] and mSupSpan[s1,r])}: vSupOut[s1,c,r,y,s]  >=  pSupAvaLo[s1,c,r,y,s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mSupWeatherLo[s1,wth1] and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pSupWeatherLo[s1,wth1]);

s.t.  eqSupTotal{ s1 in sup,c in comm,r in region : (mSupComm[s1,c] and mSupSpan[s1,r])}: vSupReserve[s1,c,r]  =  sum{y in year,s in slice,ye in year,yp in year:((mSupSlice[s1,s] and mMidMilestone[y] and mStartMilestone[y,ye] and mEndMilestone[y,yp]))}((ordYear[yp]-ordYear[ye]+1)*vSupOut[s1,c,r,y,s]);

s.t.  eqSupReserveUp{ s1 in sup,c in comm,r in region : mSupReserveUp[s1,c,r]}: pSupReserveUp[s1,c,r]  >=  vSupReserve[s1,c,r];

s.t.  eqSupReserveLo{ s1 in sup,c in comm,r in region : (mSupComm[s1,c] and pSupReserveLo[s1,c,r] <> 0 and mSupSpan[s1,r])}: vSupReserve[s1,c,r]  >=  pSupReserveLo[s1,c,r];

s.t.  eqSupCost{ s1 in sup,r in region,y in year : (mMidMilestone[y] and mSupSpan[s1,r])}: vSupCost[s1,r,y]  =  sum{c in comm,s in slice:((mSupSlice[s1,s] and mSupComm[s1,c]))}(pSupCost[s1,c,r,y,s]*vSupOut[s1,c,r,y,s]);

s.t.  eqDemInp{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mDemInp[c,s])}: vDemInp[c,r,y,s]  =  sum{d in dem:(mDemComm[d,c])}(pDemand[d,c,r,y,s]);

s.t.  eqAggOut{ c in comm,r in region,y in year,s in slice : mAggOut[c,r,y,s]}: vAggOut[c,r,y,s]  =  sum{cp in comm:(pAggregateFactor[c,cp])}(pAggregateFactor[c,cp]*vOutTot[cp,r,y,s]);

s.t.  eqTechEmsFuel{ t in tech,c in comm,r in region,y in year,s in slice : mTechEmsFuel[t,c,r,y,s]}: vTechEmsFuel[t,c,r,y,s]  =  sum{cp in comm:((mTechInpComm[t,cp] and pTechEmisComm[t,cp] <> 0 and pEmissionFactor[c,cp] <> 0))}(pTechEmisComm[t,cp]*pEmissionFactor[c,cp]*vTechInp[t,cp,r,y,s]);

s.t.  eqEmsFuelTot{ c in comm,r in region,y in year,s in slice : mEmsFuelTot[c,r,y,s]}: vEmsFuelTot[c,r,y,s]  =  sum{t in tech:(mTechEmsFuel[t,c,r,y,s])}(vTechEmsFuel[t,c,r,y,s]);

s.t.  eqStorageAInp{ st1 in stg,c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mStorageAInp[st1,c] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y])}: vStorageAInp[st1,c,r,y,s]  =  sum{cp in comm:(mStorageComm[st1,cp])}(pStorageStg2AInp[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]+pStorageInp2AInp[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]+pStorageOut2AInp[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]+pStorageCap2AInp[st1,c,r,y,s]*vStorageCap[st1,r,y]+pStorageNCap2AInp[st1,c,r,y,s]*vStorageNewCap[st1,r,y]);

s.t.  eqStorageAOut{ st1 in stg,c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mStorageAOut[st1,c] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y])}: vStorageAOut[st1,c,r,y,s]  =  sum{cp in comm:(mStorageComm[st1,cp])}(pStorageStg2AOut[st1,c,r,y,s]*vStorageStore[st1,cp,r,y,s]+pStorageInp2AOut[st1,c,r,y,s]*vStorageInp[st1,cp,r,y,s]+pStorageOut2AOut[st1,c,r,y,s]*vStorageOut[st1,cp,r,y,s]+pStorageCap2AOut[st1,c,r,y,s]*vStorageCap[st1,r,y]+pStorageNCap2AOut[st1,c,r,y,s]*vStorageNewCap[st1,r,y]);

s.t.  eqStorageStore{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c])}: vStorageStore[st1,c,r,y,s]  =  pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s]-(vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s])+sum{sp in slice:((mStorageSlice[st1,sp] and mSliceNext[sp,s]))}(pStorageStgEff[st1,c,r,y,s]*vStorageStore[st1,c,r,y,sp]);

s.t.  eqStorageAfLo{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c] and pStorageAfLo[st1,r,y,s])}: vStorageStore[st1,c,r,y,s]  >=  pStorageAfLo[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherAf[st1,wth1] and pStorageWeatherAfLo[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherAfLo[st1,wth1]);

s.t.  eqStorageAfUp{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c])}: vStorageStore[st1,c,r,y,s] <=  pStorageAfUp[st1,r,y,s]*pStorageCap2stg[st1]*vStorageCap[st1,r,y]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherAf[st1,wth1] and pStorageWeatherAfUp[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherAfUp[st1,wth1]);

s.t.  eqStorageClean{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c])}: vStorageInp[st1,c,r,y,s] <=  vStorageStore[st1,c,r,y,s];

s.t.  eqStorageInpUp{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c] and pStorageCinpUp[st1,c,r,y,s] >= 0)}: pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s] <=  pStorageCinpUp[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherCinp[st1,wth1] and pStorageWeatherCinpUp[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherCinpUp[st1,wth1]);

s.t.  eqStorageInpLo{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c] and pStorageCinpLo[st1,c,r,y,s]>0)}: pStorageInpEff[st1,c,r,y,s]*vStorageInp[st1,c,r,y,s]  >=  pStorageCinpLo[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherCinp[st1,wth1] and pStorageWeatherCinpLo[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherCinpLo[st1,wth1]);

s.t.  eqStorageOutUp{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c] and pStorageCoutUp[st1,c,r,y,s] >= 0)}: (vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s]) <=  pStorageCoutUp[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherCout[st1,wth1] and pStorageWeatherCoutUp[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherCoutUp[st1,wth1]);

s.t.  eqStorageOutLo{ st1 in stg,c in comm,r in region,y in year,s in slice : (mStorageSlice[st1,s] and mMidMilestone[y] and mStorageSpan[st1,r,y] and mStorageComm[st1,c] and pStorageCoutLo[st1,c,r,y,s]>0)}: (vStorageOut[st1,c,r,y,s]) / (pStorageOutEff[st1,c,r,y,s])  >=  pStorageCoutLo[st1,c,r,y,s]*pSliceShare[s]*prod{sp in slice,wth1 in weather:((mWeatherRegion[wth1,r] and mWeatherSlice[wth1,sp] and mStorageWeatherCout[st1,wth1] and pStorageWeatherCoutLo[st1,wth1] >= 0 and (mAllSliceParentChild[s,sp] or mSameSlice[s,sp])))}(pWeather[wth1,r,y,s]*pStorageWeatherCoutLo[st1,wth1]);

s.t.  eqStorageCap{ st1 in stg,r in region,y in year : (mMidMilestone[y] and mStorageSpan[st1,r,y])}: vStorageCap[st1,r,y]  =  pStorageStock[st1,r,y]+sum{yp in year:((ordYear[y] >= ordYear[yp] and (mStorageOlifeInf[st1,r] or ordYear[y]<pStorageOlife[st1,r]+ordYear[yp]) and mStorageNew[st1,r,y]))}(vStorageNewCap[st1,r,yp]);

s.t.  eqStorageInv{ st1 in stg,r in region,y in year : (mMidMilestone[y] and mStorageNew[st1,r,y])}: vStorageInv[st1,r,y]  =  pStorageInvcost[st1,r,y]*vStorageNewCap[st1,r,y];

s.t.  eqStorageCost{ st1 in stg,r in region,y in year : (mMidMilestone[y] and mStorageSpan[st1,r,y])}: vStorageCost[st1,r,y]  =  pStorageFixom[st1,r,y]*vStorageCap[st1,r,y]+sum{c in comm,s in slice:((mStorageSlice[st1,s] and mStorageComm[st1,c]))}(pStorageCostInp[st1,r,y,s]*vStorageInp[st1,c,r,y,s]+pStorageCostOut[st1,r,y,s]*vStorageOut[st1,c,r,y,s]+pStorageCostStore[st1,r,y,s]*vStorageStore[st1,c,r,y,s])+sum{FORIF: mStorageNew[st1,r,y]} (vStorageInv[st1,r,y]);

s.t.  eqStorageSalv0{ st1 in stg,r in region,ye in year : (mDiscountZero[r] and mMilestoneLast[ye] and sum{y in year:(mStorageNew[st1,r,y])}(1) <> 0)}: vStorageSalv[st1,r]+sum{y in year,yn in year:((mStartMilestone[yn,y] and mMidMilestone[yn] and mStorageNew[st1,r,yn] and ordYear[yn]+pStorageOlife[st1,r]-1>ordYear[ye] and not((mStorageOlifeInf[st1,r])) and pStorageInvcost[st1,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pStorageInvcost[st1,r,yn]*vStorageNewCap[st1,r,yn]) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / ((pDiscountFactor[r,ye])*((pStorageOlife[st1,r]+ordYear[yn]-1-ordYear[ye]))))))  =  0;

s.t.  eqStorageSalv{ st1 in stg,r in region,ye in year : (not((mDiscountZero[r])) and mMilestoneLast[ye] and sum{y in year:(mStorageNew[st1,r,y])}(1) <> 0)}: vStorageSalv[st1,r]+sum{y in year,yn in year:((mStartMilestone[yn,y] and mMidMilestone[yn] and mStorageNew[st1,r,yn] and ordYear[yn]+pStorageOlife[st1,r]-1>ordYear[ye] and not((mStorageOlifeInf[st1,r])) and pStorageInvcost[st1,r,yn] <> 0))}((((pDiscountFactor[r,yn]) / (pDiscountFactor[r,ye]))*pStorageInvcost[st1,r,yn]*vStorageNewCap[st1,r,yn]) / ((1+((sum{yp in year:((ordYear[yp] >= ordYear[yn]))}(pDiscountFactor[r,yp]))) / (pDiscountFactor[r,ye]*(((1-((1+pDiscount[r,ye]))^(ordYear[ye]-pStorageOlife[st1,r]-ordYear[yn]+1))*(1+pDiscount[r,ye])) / (pDiscount[r,ye]))))))  =  0;

s.t.  eqImport{ c in comm,dst in region,y in year,s in slice : mImport[c,dst,y,s]}: vImport[c,dst,y,s]  =  sum{t1 in trade,src in region:((mTradeIr[t1,src,dst,y,s] and mTradeComm[t1,c]))}(vTradeIr[t1,c,src,dst,y,s])+sum{i in imp:(mImportRow[i,c,dst,y,s])}(vImportRow[i,c,dst,y,s]);

s.t.  eqExport{ c in comm,src in region,y in year,s in slice : mExport[c,src,y,s]}: vExport[c,src,y,s]  =  sum{t1 in trade,dst in region:((mTradeIr[t1,src,dst,y,s] and mTradeComm[t1,c]))}(vTradeIr[t1,c,src,dst,y,s])+sum{e in expp:(mExportRow[e,c,src,y,s])}(vExportRow[e,c,src,y,s]);

s.t.  eqTradeFlowUp{ t1 in trade,c in comm,src in region,dst in region,y in year,s in slice : (mTradeIrUp[t1,src,dst,y,s] and mTradeComm[t1,c])}: vTradeIr[t1,c,src,dst,y,s] <=  pTradeIrUp[t1,src,dst,y,s];

s.t.  eqTradeFlowLo{ t1 in trade,c in comm,src in region,dst in region,y in year,s in slice : (mTradeIr[t1,src,dst,y,s] and pTradeIrLo[t1,src,dst,y,s] and mTradeComm[t1,c])}: vTradeIr[t1,c,src,dst,y,s]  >=  pTradeIrLo[t1,src,dst,y,s];

s.t.  eqCostTrade{ r in region,y in year : mMidMilestone[y]}: vTradeCost[r,y]  =  vTradeRowCost[r,y]+vTradeIrCost[r,y];

s.t.  eqCostRowTrade{ r in region,y in year : mMidMilestone[y]}: vTradeRowCost[r,y]  =  sum{i in imp,c in comm,s in slice:(mImportRow[i,c,r,y,s])}(pImportRowPrice[i,r,y,s]*vImportRow[i,c,r,y,s])-sum{e in expp,c in comm,s in slice:(mExportRow[e,c,r,y,s])}(pExportRowPrice[e,r,y,s]*vExportRow[e,c,r,y,s]);

s.t.  eqCostIrTrade{ r in region,y in year : mMidMilestone[y]}: vTradeIrCost[r,y]  =  sum{t1 in trade,c in comm,src in region,s in slice:((mTradeSlice[t1,s] and mTradeSrc[t1,src] and mTradeDst[t1,r] and not((mSameRegion[src,r])) and mTradeComm[t1,c]))}((pTradeIrCost[t1,src,r,y,s]+pTradeIrMarkup[t1,src,r,y,s])*vTradeIr[t1,c,src,r,y,s])-sum{t1 in trade,c in comm,dst in region,s in slice:((mTradeSlice[t1,s] and mTradeSrc[t1,r] and mTradeDst[t1,dst] and not((mSameRegion[dst,r])) and mTradeComm[t1,c]))}(pTradeIrMarkup[t1,r,dst,y,s]*vTradeIr[t1,c,r,dst,y,s]);

s.t.  eqExportRowUp{ e in expp,c in comm,r in region,y in year,s in slice : mExportRowUp[e,c,r,y,s]}: vExportRow[e,c,r,y,s] <=  pExportRowUp[e,r,y,s];

s.t.  eqExportRowLo{ e in expp,c in comm,r in region,y in year,s in slice : (mExportRow[e,c,r,y,s] and pExportRowLo[e,r,y,s] <> 0)}: vExportRow[e,c,r,y,s]  >=  pExportRowLo[e,r,y,s];

s.t.  eqExportRowCumulative{ e in expp,c in comm : mExpComm[e,c]}: vExportRowAccumulated[e,c]  =  sum{r in region,y in year,s in slice,ye in year,yp in year:((mMidMilestone[y] and mStartMilestone[y,ye] and mEndMilestone[y,yp] and mExportRow[e,c,r,y,s]))}((ordYear[yp]-ordYear[ye]+1)*vExportRow[e,c,r,y,s]);

s.t.  eqExportRowResUp{ e in expp,c in comm : (mExportRowAccumulatedUp[e,c] and mExpComm[e,c])}: vExportRowAccumulated[e,c] <=  pExportRowRes[e];

s.t.  eqImportRowUp{ i in imp,c in comm,r in region,y in year,s in slice : mImportRowUp[i,c,r,y,s]}: vImportRow[i,c,r,y,s] <=  pImportRowUp[i,r,y,s];

s.t.  eqImportRowLo{ i in imp,c in comm,r in region,y in year,s in slice : (mImportRow[i,c,r,y,s] and pImportRowLo[i,r,y,s] <> 0)}: vImportRow[i,c,r,y,s]  >=  pImportRowLo[i,r,y,s];

s.t.  eqImportRowAccumulated{ i in imp,c in comm : mImpComm[i,c]}: vImportRowAccumulated[i,c]  =  sum{r in region,y in year,s in slice,ye in year,yp in year:((mImportRow[i,c,r,y,s] and mStartMilestone[y,ye] and mEndMilestone[y,yp]))}((ordYear[yp]-ordYear[ye]+1)*vImportRow[i,c,r,y,s]);

s.t.  eqImportRowResUp{ i in imp,c in comm : mImportRowAccumulatedUp[i,c]}: vImportRowAccumulated[i,c] <=  pImportRowRes[i];

s.t.  eqTradeIrAInp{ t1 in trade,c in comm,r in region,y in year,s in slice : mTradeIrAInp2[t1,c,r,y,s]}: vTradeIrAInp[t1,c,r,y,s]  =  sum{dst in region:((mTradeSrc[t1,r] and mTradeDst[t1,dst] and not((mSameRegion[r,dst]))))}(pTradeIrCsrc2Ainp[t1,c,r,dst,y,s]*sum{cp in comm:(mTradeComm[t1,cp])}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:((mTradeSrc[t1,src] and mTradeDst[t1,r] and not((mSameRegion[r,src]))))}(pTradeIrCdst2Ainp[t1,c,src,r,y,s]*sum{cp in comm:(mTradeComm[t1,cp])}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAOut{ t1 in trade,c in comm,r in region,y in year,s in slice : mTradeIrAOut2[t1,c,r,y,s]}: vTradeIrAOut[t1,c,r,y,s]  =  sum{dst in region:((mTradeSrc[t1,r] and mTradeDst[t1,dst] and not((mSameRegion[r,dst]))))}(pTradeIrCsrc2Aout[t1,c,r,dst,y,s]*sum{cp in comm:(mTradeComm[t1,cp])}(vTradeIr[t1,cp,r,dst,y,s]))+sum{src in region:((mTradeSrc[t1,src] and mTradeDst[t1,r] and not((mSameRegion[r,src]))))}(pTradeIrCdst2Aout[t1,c,src,r,y,s]*sum{cp in comm:(mTradeComm[t1,cp])}(vTradeIr[t1,cp,src,r,y,s]));

s.t.  eqTradeIrAInpTot{ c in comm,r in region,y in year,s in slice : mTradeIrAInpTot[c,r,y,s]}: vTradeIrAInpTot[c,r,y,s]  =  sum{t1 in trade:(mTradeIrAInp2[t1,c,r,y,s])}(vTradeIrAInp[t1,c,r,y,s]);

s.t.  eqTradeIrAOutTot{ c in comm,r in region,y in year,s in slice : mTradeIrAOutTot[c,r,y,s]}: vTradeIrAOutTot[c,r,y,s]  =  sum{t1 in trade:(mTradeIrAOut2[t1,c,r,y,s])}(vTradeIrAOut[t1,c,r,y,s]);

s.t.  eqBalLo{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mLoComm[c] and mCommSlice[c,s])}: vBalance[c,r,y,s]  >=  0;

s.t.  eqBalUp{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mUpComm[c] and mCommSlice[c,s])}: vBalance[c,r,y,s] <=  0;

s.t.  eqBalFx{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mFxComm[c] and mCommSlice[c,s])}: vBalance[c,r,y,s]  =  0;

s.t.  eqBal{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mCommSlice[c,s])}: vBalance[c,r,y,s]  =  vOutTot[c,r,y,s]-vInpTot[c,r,y,s];

s.t.  eqOutTot{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mCommSlice[c,s])}: vOutTot[c,r,y,s]  =  sum{FORIF: mDummyImport[c,r,y,s]} (vDummyImport[c,r,y,s])+sum{sp in slice:((mSameSlice[s,sp] or mAllSliceParentChild[s,sp]))}(sum{FORIF: mSupOutTot[c,r,sp]} (vSupOutTot[c,r,y,sp])+sum{FORIF: mEmsFuelTot[c,r,y,sp]} (vEmsFuelTot[c,r,y,sp])+sum{FORIF: mAggOut[c,r,y,sp]} (vAggOut[c,r,y,sp])+sum{FORIF: mTechOutTot[c,r,y,sp]} (vTechOutTot[c,r,y,sp])+sum{FORIF: mStorageOutTot[c,r,y,sp]} (vStorageOutTot[c,r,y,sp])+sum{FORIF: mImport[c,r,y,sp]} (vImport[c,r,y,sp])+sum{FORIF: mTradeIrAOutTot[c,r,y,sp]} (vTradeIrAOutTot[c,r,y,sp]))+sum{sp in slice:((mAllSliceParentChild[sp,s] and mOut2Lo[c,r,y,sp]))}(vOut2Lo[c,r,y,sp,s]);

s.t.  eqOut2Lo{ c in comm,r in region,y in year,s in slice : mOut2Lo[c,r,y,s]}: sum{sp in slice:((mAllSliceParentChild[s,sp] and mCommSlice[c,sp]))}(vOut2Lo[c,r,y,s,sp])  =  sum{FORIF: mSupOutTot[c,r,s]} (vSupOutTot[c,r,y,s])+sum{FORIF: mEmsFuelTot[c,r,y,s]} (vEmsFuelTot[c,r,y,s])+sum{FORIF: mAggOut[c,r,y,s]} (vAggOut[c,r,y,s])+sum{FORIF: mTechOutTot[c,r,y,s]} (vTechOutTot[c,r,y,s])+sum{FORIF: mStorageOutTot[c,r,y,s]} (vStorageOutTot[c,r,y,s])+sum{FORIF: mImport[c,r,y,s]} (vImport[c,r,y,s])+sum{FORIF: mTradeIrAOutTot[c,r,y,s]} (vTradeIrAOutTot[c,r,y,s]);

s.t.  eqInpTot{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mCommSlice[c,s])}: vInpTot[c,r,y,s]  =  sum{FORIF: mDemInp[c,s]} (vDemInp[c,r,y,s])+sum{FORIF: mDummyExport[c,r,y,s]} (vDummyExport[c,r,y,s])+sum{sp in slice:((mSameSlice[s,sp] or mAllSliceParentChild[s,sp]))}(sum{FORIF: mTechInpTot[c,r,y,sp]} (vTechInpTot[c,r,y,sp])+sum{FORIF: mStorageInpTot[c,r,y,sp]} (vStorageInpTot[c,r,y,sp])+sum{FORIF: mExport[c,r,y,sp]} (vExport[c,r,y,sp])+sum{FORIF: mTradeIrAInpTot[c,r,y,sp]} (vTradeIrAInpTot[c,r,y,sp]))+sum{sp in slice:((mAllSliceParentChild[sp,s] and mInp2Lo[c,r,y,sp]))}(vInp2Lo[c,r,y,sp,s]);

s.t.  eqInp2Lo{ c in comm,r in region,y in year,s in slice : mInp2Lo[c,r,y,s]}: sum{sp in slice:((mAllSliceParentChild[s,sp] and mCommSlice[c,sp]))}(vInp2Lo[c,r,y,s,sp])  =  sum{FORIF: mTechInpTot[c,r,y,s]} (vTechInpTot[c,r,y,s])+sum{FORIF: mStorageInpTot[c,r,y,s]} (vStorageInpTot[c,r,y,s])+sum{FORIF: mExport[c,r,y,s]} (vExport[c,r,y,s])+sum{FORIF: mTradeIrAInpTot[c,r,y,s]} (vTradeIrAInpTot[c,r,y,s]);

s.t.  eqSupOutTot{ c in comm,r in region,y in year,s in slice : (mMidMilestone[y] and mSupOutTot[c,r,s])}: vSupOutTot[c,r,y,s]  =  sum{s1 in sup:((mSupSlice[s1,s] and mSupComm[s1,c] and mSupSpan[s1,r]))}(vSupOut[s1,c,r,y,s]);

s.t.  eqTechInpTot{ c in comm,r in region,y in year,s in slice : mTechInpTot[c,r,y,s]}: vTechInpTot[c,r,y,s]  =  sum{t in tech:((mTechSpan[t,r,y] and mTechInpComm[t,c] and mTechSlice[t,s]))}(vTechInp[t,c,r,y,s])+sum{t in tech:((mTechSpan[t,r,y] and mTechAInp[t,c] and mTechSlice[t,s]))}(vTechAInp[t,c,r,y,s]);

s.t.  eqTechOutTot{ c in comm,r in region,y in year,s in slice : mTechOutTot[c,r,y,s]}: vTechOutTot[c,r,y,s]  =  sum{t in tech:((mTechSlice[t,s] and mTechSpan[t,r,y] and mTechSlice[t,s] and mTechOutComm[t,c]))}(vTechOut[t,c,r,y,s])+sum{t in tech:((mTechSlice[t,s] and mTechSpan[t,r,y] and mTechSlice[t,s] and mTechAOut[t,c]))}(vTechAOut[t,c,r,y,s]);

s.t.  eqStorageInpTot{ c in comm,r in region,y in year,s in slice : mStorageInpTot[c,r,y,s]}: vStorageInpTot[c,r,y,s]  =  sum{st1 in stg:((mStorageComm[st1,c] and pStorageInpEff[st1,c,r,y,s] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y]))}(vStorageInp[st1,c,r,y,s])+sum{st1 in stg:((mStorageAInp[st1,c] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y]))}(vStorageAInp[st1,c,r,y,s]);

s.t.  eqStorageOutTot{ c in comm,r in region,y in year,s in slice : mStorageOutTot[c,r,y,s]}: vStorageOutTot[c,r,y,s]  =  sum{st1 in stg:((mStorageComm[st1,c] and pStorageOutEff[st1,c,r,y,s] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y]))}(vStorageOut[st1,c,r,y,s])+sum{st1 in stg:((mStorageAOut[st1,c] and mStorageSlice[st1,s] and mStorageSpan[st1,r,y]))}(vStorageAOut[st1,c,r,y,s]);

s.t.  eqDummyCost{ c in comm,r in region,y in year : (mMidMilestone[y] and mDummyCost[c,r,y])}: vDummyCost[c,r,y]  =  sum{s in slice:(mDummyImport[c,r,y,s])}(pDummyImportCost[c,r,y,s]*vDummyImport[c,r,y,s])+sum{s in slice:(mDummyExport[c,r,y,s])}(pDummyExportCost[c,r,y,s]*vDummyExport[c,r,y,s]);

s.t.  eqCost{ r in region,y in year : (mMidMilestone[y])}: vCost[r,y]  =  sum{t in tech:(mTechSpan[t,r,y])}(vTechOMCost[t,r,y])+sum{s1 in sup:(mSupSpan[s1,r])}(vSupCost[s1,r,y])+sum{c in comm:(mDummyCost[c,r,y])}(vDummyCost[c,r,y])+sum{c in comm:(mTaxCost[c,r,y])}(vTaxCost[c,r,y])-sum{c in comm:(mSubsCost[c,r,y])}(vSubsCost[c,r,y])+sum{st1 in stg:(mStorageSpan[st1,r,y])}(vStorageCost[st1,r,y])+vTradeCost[r,y];

s.t.  eqTaxCost{ c in comm,r in region,y in year : mTaxCost[c,r,y]}: vTaxCost[c,r,y]  =  sum{s in slice}(pTaxCost[c,r,y,s]*vOutTot[c,r,y,s]);

s.t.  eqSubsCost{ c in comm,r in region,y in year : mSubsCost[c,r,y]}: vSubsCost[c,r,y]  =  sum{s in slice}(pSubsCost[c,r,y,s]*vOutTot[c,r,y,s]);

s.t.  eqObjective: vObjective  =  sum{r in region,y in year,yp in year:((mMidMilestone[y] and mStartMilestone[y,yp]))}(pDiscountFactor[r,yp]*sum{t in tech:(mTechNew[t,r,y])}(vTechInv[t,r,y]))+sum{r in region,y in year:(mMidMilestone[y])}(vCost[r,y]*sum{ye in year,yp in year,yn in year:((mStartMilestone[y,yp] and mEndMilestone[y,ye] and ordYear[yn] >= ordYear[yp] and ordYear[yn] <= ordYear[ye]))}(pDiscountFactor[r,yn]))+sum{r in region,y in year,t in tech:((mMilestoneLast[y] and sum{yp in year:(mTechNew[t,r,yp])}(1) <> 0))}(pDiscountFactor[r,y]*vTechSalv[t,r])+sum{r in region,y in year,st1 in stg:((mMilestoneLast[y] and sum{yp in year:(mStorageNew[st1,r,yp])}(1) <> 0))}(pDiscountFactor[r,y]*vStorageSalv[st1,r]);

s.t.  eqLECActivity{ t in tech,r in region,y in year : (mLECRegion[r] and mTechSpan[t,r,y])}: sum{s in slice:(mTechSlice[t,s])}(vTechAct[t,r,y,s])  >=  pLECLoACT[r];

minimize vObjective2 : vObjective;

solve;


printf "value\n2.00\n" > "pFinish.csv";
printf "tech,region,year,value\n" > "vTechInv.csv";
for {t in tech,r in region,y in year : vTechInv[t,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", t,r,y, vTechInv[t,r,y] >> "vTechInv.csv";
} 
printf "tech,region,year,value\n" > "vTechEac.csv";
for {t in tech,r in region,y in year : vTechEac[t,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", t,r,y, vTechEac[t,r,y] >> "vTechEac.csv";
} 
printf "tech,region,value\n" > "vTechSalv.csv";
for {t in tech,r in region : vTechSalv[t,r] <> 0} { 
    printf "%s,%s,%f\n", t,r, vTechSalv[t,r] >> "vTechSalv.csv";
} 
printf "tech,region,year,value\n" > "vTechOMCost.csv";
for {t in tech,r in region,y in year : vTechOMCost[t,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", t,r,y, vTechOMCost[t,r,y] >> "vTechOMCost.csv";
} 
printf "sup,region,year,value\n" > "vSupCost.csv";
for {s1 in sup,r in region,y in year : vSupCost[s1,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", s1,r,y, vSupCost[s1,r,y] >> "vSupCost.csv";
} 
printf "comm,region,year,slice,value\n" > "vEmsFuelTot.csv";
for {c in comm,r in region,y in year,s in slice : vEmsFuelTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vEmsFuelTot[c,r,y,s] >> "vEmsFuelTot.csv";
} 
printf "tech,comm,region,year,slice,value\n" > "vTechEmsFuel.csv";
for {t in tech,c in comm,r in region,y in year,s in slice : vTechEmsFuel[t,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s, vTechEmsFuel[t,c,r,y,s] >> "vTechEmsFuel.csv";
} 
printf "comm,region,year,slice,value\n" > "vBalance.csv";
for {c in comm,r in region,y in year,s in slice : vBalance[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vBalance[c,r,y,s] >> "vBalance.csv";
} 
printf "region,year,value\n" > "vCost.csv";
for {r in region,y in year : vCost[r,y] <> 0} { 
    printf "%s,%s,%f\n", r,y, vCost[r,y] >> "vCost.csv";
} 
printf "value\n%s\n",vObjective > "vObjective.csv";
printf "comm,region,year,value\n" > "vTaxCost.csv";
for {c in comm,r in region,y in year : vTaxCost[c,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", c,r,y, vTaxCost[c,r,y] >> "vTaxCost.csv";
} 
printf "comm,region,year,value\n" > "vSubsCost.csv";
for {c in comm,r in region,y in year : vSubsCost[c,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", c,r,y, vSubsCost[c,r,y] >> "vSubsCost.csv";
} 
printf "comm,region,year,slice,value\n" > "vAggOut.csv";
for {c in comm,r in region,y in year,s in slice : vAggOut[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vAggOut[c,r,y,s] >> "vAggOut.csv";
} 
printf "stg,region,value\n" > "vStorageSalv.csv";
for {st1 in stg,r in region : vStorageSalv[st1,r] <> 0} { 
    printf "%s,%s,%f\n", st1,r, vStorageSalv[st1,r] >> "vStorageSalv.csv";
} 
printf "stg,region,year,value\n" > "vStorageCost.csv";
for {st1 in stg,r in region,y in year : vStorageCost[st1,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", st1,r,y, vStorageCost[st1,r,y] >> "vStorageCost.csv";
} 
printf "region,year,value\n" > "vTradeCost.csv";
for {r in region,y in year : vTradeCost[r,y] <> 0} { 
    printf "%s,%s,%f\n", r,y, vTradeCost[r,y] >> "vTradeCost.csv";
} 
printf "region,year,value\n" > "vTradeRowCost.csv";
for {r in region,y in year : vTradeRowCost[r,y] <> 0} { 
    printf "%s,%s,%f\n", r,y, vTradeRowCost[r,y] >> "vTradeRowCost.csv";
} 
printf "region,year,value\n" > "vTradeIrCost.csv";
for {r in region,y in year : vTradeIrCost[r,y] <> 0} { 
    printf "%s,%s,%f\n", r,y, vTradeIrCost[r,y] >> "vTradeIrCost.csv";
} 
printf "tech,region,year,slice,value\n" > "vTechUse.csv";
for {t in tech,r in region,y in year,s in slice : vTechUse[t,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", t,r,y,s, vTechUse[t,r,y,s] >> "vTechUse.csv";
} 
printf "tech,region,year,value\n" > "vTechNewCap.csv";
for {t in tech,r in region,y in year : vTechNewCap[t,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", t,r,y, vTechNewCap[t,r,y] >> "vTechNewCap.csv";
} 
printf "tech,region,year,yearp,value\n" > "vTechRetiredCap.csv";
for {t in tech,r in region,y in year,yp in year : vTechRetiredCap[t,r,y,yp] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", t,r,y,yp, vTechRetiredCap[t,r,y,yp] >> "vTechRetiredCap.csv";
} 
printf "tech,region,year,value\n" > "vTechCap.csv";
for {t in tech,r in region,y in year : vTechCap[t,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", t,r,y, vTechCap[t,r,y] >> "vTechCap.csv";
} 
printf "tech,region,year,slice,value\n" > "vTechAct.csv";
for {t in tech,r in region,y in year,s in slice : vTechAct[t,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", t,r,y,s, vTechAct[t,r,y,s] >> "vTechAct.csv";
} 
printf "tech,comm,region,year,slice,value\n" > "vTechInp.csv";
for {t in tech,c in comm,r in region,y in year,s in slice : vTechInp[t,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s, vTechInp[t,c,r,y,s] >> "vTechInp.csv";
} 
printf "tech,comm,region,year,slice,value\n" > "vTechOut.csv";
for {t in tech,c in comm,r in region,y in year,s in slice : vTechOut[t,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s, vTechOut[t,c,r,y,s] >> "vTechOut.csv";
} 
printf "tech,comm,region,year,slice,value\n" > "vTechAInp.csv";
for {t in tech,c in comm,r in region,y in year,s in slice : vTechAInp[t,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s, vTechAInp[t,c,r,y,s] >> "vTechAInp.csv";
} 
printf "tech,comm,region,year,slice,value\n" > "vTechAOut.csv";
for {t in tech,c in comm,r in region,y in year,s in slice : vTechAOut[t,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t,c,r,y,s, vTechAOut[t,c,r,y,s] >> "vTechAOut.csv";
} 
printf "sup,comm,region,year,slice,value\n" > "vSupOut.csv";
for {s1 in sup,c in comm,r in region,y in year,s in slice : vSupOut[s1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", s1,c,r,y,s, vSupOut[s1,c,r,y,s] >> "vSupOut.csv";
} 
printf "sup,comm,region,value\n" > "vSupReserve.csv";
for {s1 in sup,c in comm,r in region : vSupReserve[s1,c,r] <> 0} { 
    printf "%s,%s,%s,%f\n", s1,c,r, vSupReserve[s1,c,r] >> "vSupReserve.csv";
} 
printf "comm,region,year,slice,value\n" > "vDemInp.csv";
for {c in comm,r in region,y in year,s in slice : vDemInp[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vDemInp[c,r,y,s] >> "vDemInp.csv";
} 
printf "comm,region,year,slice,value\n" > "vOutTot.csv";
for {c in comm,r in region,y in year,s in slice : vOutTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vOutTot[c,r,y,s] >> "vOutTot.csv";
} 
printf "comm,region,year,slice,value\n" > "vInpTot.csv";
for {c in comm,r in region,y in year,s in slice : vInpTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vInpTot[c,r,y,s] >> "vInpTot.csv";
} 
printf "comm,region,year,slicep,slice,value\n" > "vInp2Lo.csv";
for {c in comm,r in region,y in year,sp in slice,s in slice : vInp2Lo[c,r,y,sp,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", c,r,y,sp,s, vInp2Lo[c,r,y,sp,s] >> "vInp2Lo.csv";
} 
printf "comm,region,year,slicep,slice,value\n" > "vOut2Lo.csv";
for {c in comm,r in region,y in year,sp in slice,s in slice : vOut2Lo[c,r,y,sp,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", c,r,y,sp,s, vOut2Lo[c,r,y,sp,s] >> "vOut2Lo.csv";
} 
printf "comm,region,year,slice,value\n" > "vSupOutTot.csv";
for {c in comm,r in region,y in year,s in slice : vSupOutTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vSupOutTot[c,r,y,s] >> "vSupOutTot.csv";
} 
printf "comm,region,year,slice,value\n" > "vTechInpTot.csv";
for {c in comm,r in region,y in year,s in slice : vTechInpTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vTechInpTot[c,r,y,s] >> "vTechInpTot.csv";
} 
printf "comm,region,year,slice,value\n" > "vTechOutTot.csv";
for {c in comm,r in region,y in year,s in slice : vTechOutTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vTechOutTot[c,r,y,s] >> "vTechOutTot.csv";
} 
printf "comm,region,year,slice,value\n" > "vStorageInpTot.csv";
for {c in comm,r in region,y in year,s in slice : vStorageInpTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vStorageInpTot[c,r,y,s] >> "vStorageInpTot.csv";
} 
printf "comm,region,year,slice,value\n" > "vStorageOutTot.csv";
for {c in comm,r in region,y in year,s in slice : vStorageOutTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vStorageOutTot[c,r,y,s] >> "vStorageOutTot.csv";
} 
printf "stg,comm,region,year,slice,value\n" > "vStorageAInp.csv";
for {st1 in stg,c in comm,r in region,y in year,s in slice : vStorageAInp[st1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s, vStorageAInp[st1,c,r,y,s] >> "vStorageAInp.csv";
} 
printf "stg,comm,region,year,slice,value\n" > "vStorageAOut.csv";
for {st1 in stg,c in comm,r in region,y in year,s in slice : vStorageAOut[st1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s, vStorageAOut[st1,c,r,y,s] >> "vStorageAOut.csv";
} 
printf "comm,region,year,slice,value\n" > "vDummyImport.csv";
for {c in comm,r in region,y in year,s in slice : vDummyImport[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vDummyImport[c,r,y,s] >> "vDummyImport.csv";
} 
printf "comm,region,year,slice,value\n" > "vDummyExport.csv";
for {c in comm,r in region,y in year,s in slice : vDummyExport[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vDummyExport[c,r,y,s] >> "vDummyExport.csv";
} 
printf "comm,region,year,value\n" > "vDummyCost.csv";
for {c in comm,r in region,y in year : vDummyCost[c,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", c,r,y, vDummyCost[c,r,y] >> "vDummyCost.csv";
} 
printf "stg,comm,region,year,slice,value\n" > "vStorageInp.csv";
for {st1 in stg,c in comm,r in region,y in year,s in slice : vStorageInp[st1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s, vStorageInp[st1,c,r,y,s] >> "vStorageInp.csv";
} 
printf "stg,comm,region,year,slice,value\n" > "vStorageOut.csv";
for {st1 in stg,c in comm,r in region,y in year,s in slice : vStorageOut[st1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s, vStorageOut[st1,c,r,y,s] >> "vStorageOut.csv";
} 
printf "stg,comm,region,year,slice,value\n" > "vStorageStore.csv";
for {st1 in stg,c in comm,r in region,y in year,s in slice : vStorageStore[st1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", st1,c,r,y,s, vStorageStore[st1,c,r,y,s] >> "vStorageStore.csv";
} 
printf "stg,region,year,value\n" > "vStorageInv.csv";
for {st1 in stg,r in region,y in year : vStorageInv[st1,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", st1,r,y, vStorageInv[st1,r,y] >> "vStorageInv.csv";
} 
printf "stg,region,year,value\n" > "vStorageCap.csv";
for {st1 in stg,r in region,y in year : vStorageCap[st1,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", st1,r,y, vStorageCap[st1,r,y] >> "vStorageCap.csv";
} 
printf "stg,region,year,value\n" > "vStorageNewCap.csv";
for {st1 in stg,r in region,y in year : vStorageNewCap[st1,r,y] <> 0} { 
    printf "%s,%s,%s,%f\n", st1,r,y, vStorageNewCap[st1,r,y] >> "vStorageNewCap.csv";
} 
printf "comm,region,year,slice,value\n" > "vImport.csv";
for {c in comm,r in region,y in year,s in slice : vImport[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vImport[c,r,y,s] >> "vImport.csv";
} 
printf "comm,region,year,slice,value\n" > "vExport.csv";
for {c in comm,r in region,y in year,s in slice : vExport[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vExport[c,r,y,s] >> "vExport.csv";
} 
printf "trade,comm,region,regionp,year,slice,value\n" > "vTradeIr.csv";
for {t1 in trade,c in comm,r in region,rp in region,y in year,s in slice : vTradeIr[t1,c,r,rp,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%s,%f\n", t1,c,r,rp,y,s, vTradeIr[t1,c,r,rp,y,s] >> "vTradeIr.csv";
} 
printf "trade,comm,region,year,slice,value\n" > "vTradeIrAInp.csv";
for {t1 in trade,c in comm,r in region,y in year,s in slice : vTradeIrAInp[t1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s, vTradeIrAInp[t1,c,r,y,s] >> "vTradeIrAInp.csv";
} 
printf "comm,region,year,slice,value\n" > "vTradeIrAInpTot.csv";
for {c in comm,r in region,y in year,s in slice : vTradeIrAInpTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vTradeIrAInpTot[c,r,y,s] >> "vTradeIrAInpTot.csv";
} 
printf "trade,comm,region,year,slice,value\n" > "vTradeIrAOut.csv";
for {t1 in trade,c in comm,r in region,y in year,s in slice : vTradeIrAOut[t1,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", t1,c,r,y,s, vTradeIrAOut[t1,c,r,y,s] >> "vTradeIrAOut.csv";
} 
printf "comm,region,year,slice,value\n" > "vTradeIrAOutTot.csv";
for {c in comm,r in region,y in year,s in slice : vTradeIrAOutTot[c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%f\n", c,r,y,s, vTradeIrAOutTot[c,r,y,s] >> "vTradeIrAOutTot.csv";
} 
printf "expp,comm,value\n" > "vExportRowAccumulated.csv";
for {e in expp,c in comm : vExportRowAccumulated[e,c] <> 0} { 
    printf "%s,%s,%f\n", e,c, vExportRowAccumulated[e,c] >> "vExportRowAccumulated.csv";
} 
printf "expp,comm,region,year,slice,value\n" > "vExportRow.csv";
for {e in expp,c in comm,r in region,y in year,s in slice : vExportRow[e,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", e,c,r,y,s, vExportRow[e,c,r,y,s] >> "vExportRow.csv";
} 
printf "imp,comm,value\n" > "vImportRowAccumulated.csv";
for {i in imp,c in comm : vImportRowAccumulated[i,c] <> 0} { 
    printf "%s,%s,%f\n", i,c, vImportRowAccumulated[i,c] >> "vImportRowAccumulated.csv";
} 
printf "imp,comm,region,year,slice,value\n" > "vImportRow.csv";
for {i in imp,c in comm,r in region,y in year,s in slice : vImportRow[i,c,r,y,s] <> 0} { 
    printf "%s,%s,%s,%s,%s,%f\n", i,c,r,y,s, vImportRow[i,c,r,y,s] >> "vImportRow.csv";
} 


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
    printf "vStorageCost\n" >> "variable_list.csv";
    printf "vTradeCost\n" >> "variable_list.csv";
    printf "vTradeRowCost\n" >> "variable_list.csv";
    printf "vTradeIrCost\n" >> "variable_list.csv";
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
for {y in year : mMidMilestone[y] <> 0} {
    printf "year,%s\n", y >> "raw_data_set.csv";
}
for {s in slice} {
    printf "slice,%s\n", s >> "raw_data_set.csv";
}
for {wth1 in weather} {
    printf "weather,%s\n", wth1 >> "raw_data_set.csv";
}
end;


