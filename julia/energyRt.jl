using Dates
include("inc1.jl")
flog = open("output/log.csv", "w")
println(flog,"parameter,value,time")
println(flog,"\"model language\",JULIA,\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")
println("start ", Dates.format(now(), "HH:MM:SS"))
using JuMP
println(flog,"\"load data\",,\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")
include("data.jl")
include("inc2.jl")
model = Model();
@variable(model, vTechInv[mTechInv]);
@variable(model, vTechEac[mTechEac]);
@variable(model, vTechOMCost[mTechOMCost]);
@variable(model, vSupCost[mvSupCost]);
@variable(model, vEmsFuelTot[mEmsFuelTot]);
@variable(model, vBalance[mvBalance]);
@variable(model, vTotalCost[mvTotalCost]);
@variable(model, vObjective);
@variable(model, vTaxCost[mTaxCost]);
@variable(model, vSubsCost[mSubCost]);
@variable(model, vAggOut[mAggOut]);
@variable(model, vStorageOMCost[mStorageOMCost]);
@variable(model, vTradeCost[mvTradeCost]);
@variable(model, vTradeRowCost[mvTradeRowCost]);
@variable(model, vTradeIrCost[mvTradeIrCost]);
@variable(model, vTechNewCap[mTechNew] >= 0);
@variable(model, vTechRetiredStock[mvTechRetiredStock] >= 0);
@variable(model, vTechRetiredNewCap[mvTechRetiredNewCap] >= 0);
@variable(model, vTechCap[mTechSpan] >= 0);
@variable(model, vTechAct[mvTechAct] >= 0);
@variable(model, vTechInp[mvTechInp] >= 0);
@variable(model, vTechOut[mvTechOut] >= 0);
@variable(model, vTechAInp[mvTechAInp] >= 0);
@variable(model, vTechAOut[mvTechAOut] >= 0);
@variable(model, vSupOut[mSupAva] >= 0);
@variable(model, vSupReserve[mvSupReserve] >= 0);
@variable(model, vDemInp[mvDemInp] >= 0);
@variable(model, vOutTot[mvOutTot] >= 0);
@variable(model, vInpTot[mvInpTot] >= 0);
@variable(model, vInp2Lo[mvInp2Lo] >= 0);
@variable(model, vOut2Lo[mvOut2Lo] >= 0);
@variable(model, vSupOutTot[mSupOutTot] >= 0);
@variable(model, vTechInpTot[mTechInpTot] >= 0);
@variable(model, vTechOutTot[mTechOutTot] >= 0);
@variable(model, vStorageInpTot[mStorageInpTot] >= 0);
@variable(model, vStorageOutTot[mStorageOutTot] >= 0);
@variable(model, vStorageAInp[mvStorageAInp] >= 0);
@variable(model, vStorageAOut[mvStorageAOut] >= 0);
@variable(model, vDummyImport[mDummyImport] >= 0);
@variable(model, vDummyExport[mDummyExport] >= 0);
@variable(model, vStorageInp[mvStorageStore] >= 0);
@variable(model, vStorageOut[mvStorageStore] >= 0);
@variable(model, vStorageStore[mvStorageStore] >= 0);
@variable(model, vStorageInv[mStorageNew] >= 0);
@variable(model, vStorageEac[mStorageEac] >= 0);
@variable(model, vStorageCap[mStorageSpan] >= 0);
@variable(model, vStorageNewCap[mStorageNew] >= 0);
@variable(model, vImport[mImport] >= 0);
@variable(model, vExport[mExport] >= 0);
@variable(model, vTradeIr[mvTradeIr] >= 0);
@variable(model, vTradeIrAInp[mvTradeIrAInp] >= 0);
@variable(model, vTradeIrAInpTot[mvTradeIrAInpTot] >= 0);
@variable(model, vTradeIrAOut[mvTradeIrAOut] >= 0);
@variable(model, vTradeIrAOutTot[mvTradeIrAOutTot] >= 0);
@variable(model, vExportRowAccumulated[mExpComm] >= 0);
@variable(model, vExportRow[mExportRow] >= 0);
@variable(model, vImportRowAccumulated[mImpComm] >= 0);
@variable(model, vImportRow[mImportRow] >= 0);
@variable(model, vTradeCap[mTradeSpan] >= 0);
@variable(model, vTradeInv[mTradeEac] >= 0);
@variable(model, vTradeEac[mTradeEac] >= 0);
@variable(model, vTradeNewCap[mTradeNew] >= 0);
@variable(model, vTotalUserCosts[mvTotalUserCosts] >= 0);
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
@constraint(model, [(h, r, c, cp, y, l) in meqTechSng2Sng], vTechInp[(h,c,r,y,l)]*(if haskey(pTechCinp2use, (h,c,r,y,l)); pTechCinp2use[(h,c,r,y,l)]; else pTechCinp2useDef; end)  ==  (vTechOut[(h,cp,r,y,l)]) / ((if haskey(pTechUse2cact, (h,cp,r,y,l)); pTechUse2cact[(h,cp,r,y,l)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (h,cp,r,y,l)); pTechCact2cout[(h,cp,r,y,l)]; else pTechCact2coutDef; end)));
println("eqTechSng2Sng(tech, region, comm, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
@constraint(model, [(h, r, g, cp, y, l) in meqTechGrp2Sng], (if haskey(pTechGinp2use, (h,g,r,y,l)); pTechGinp2use[(h,g,r,y,l)]; else pTechGinp2useDef; end)*sum((if (h,c,r,y,l) in mvTechInp; (vTechInp[(h,c,r,y,l)]*(if haskey(pTechCinp2ginp, (h,c,r,y,l)); pTechCinp2ginp[(h,c,r,y,l)]; else pTechCinp2ginpDef; end)); else 0; end;) for c in comm if (h,g,c) in mTechGroupComm)  ==  (vTechOut[(h,cp,r,y,l)]) / ((if haskey(pTechUse2cact, (h,cp,r,y,l)); pTechUse2cact[(h,cp,r,y,l)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (h,cp,r,y,l)); pTechCact2cout[(h,cp,r,y,l)]; else pTechCact2coutDef; end)));
println("eqTechGrp2Sng(tech, region, group, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
@constraint(model, [(h, r, c, gp, y, l) in meqTechSng2Grp], vTechInp[(h,c,r,y,l)]*(if haskey(pTechCinp2use, (h,c,r,y,l)); pTechCinp2use[(h,c,r,y,l)]; else pTechCinp2useDef; end)  ==  sum((if (h,cp,r,y,l) in mvTechOut; ((vTechOut[(h,cp,r,y,l)]) / ((if haskey(pTechUse2cact, (h,cp,r,y,l)); pTechUse2cact[(h,cp,r,y,l)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (h,cp,r,y,l)); pTechCact2cout[(h,cp,r,y,l)]; else pTechCact2coutDef; end))); else 0; end;) for cp in comm if (h,gp,cp) in mTechGroupComm));
println("eqTechSng2Grp(tech, region, comm, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
@constraint(model, [(h, r, g, gp, y, l) in meqTechGrp2Grp], (if haskey(pTechGinp2use, (h,g,r,y,l)); pTechGinp2use[(h,g,r,y,l)]; else pTechGinp2useDef; end)*sum((if (h,c,r,y,l) in mvTechInp; (vTechInp[(h,c,r,y,l)]*(if haskey(pTechCinp2ginp, (h,c,r,y,l)); pTechCinp2ginp[(h,c,r,y,l)]; else pTechCinp2ginpDef; end)); else 0; end;) for c in comm if (h,g,c) in mTechGroupComm)  ==  sum((if (h,cp,r,y,l) in mvTechOut; ((vTechOut[(h,cp,r,y,l)]) / ((if haskey(pTechUse2cact, (h,cp,r,y,l)); pTechUse2cact[(h,cp,r,y,l)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (h,cp,r,y,l)); pTechCact2cout[(h,cp,r,y,l)]; else pTechCact2coutDef; end))); else 0; end;) for cp in comm if (h,gp,cp) in mTechGroupComm));
println("eqTechGrp2Grp(tech, region, group, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
@constraint(model, [(h, r, g, c, y, l) in meqTechShareInpLo], vTechInp[(h,c,r,y,l)]  >=  (if haskey(pTechShareLo, (h,c,r,y,l)); pTechShareLo[(h,c,r,y,l)]; else pTechShareLoDef; end)*sum((if (h,cp,r,y,l) in mvTechInp; vTechInp[(h,cp,r,y,l)]; else 0; end;) for cp in comm if (h,g,cp) in mTechGroupComm));
println("eqTechShareInpLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
@constraint(model, [(h, r, g, c, y, l) in meqTechShareInpUp], vTechInp[(h,c,r,y,l)] <=  (if haskey(pTechShareUp, (h,c,r,y,l)); pTechShareUp[(h,c,r,y,l)]; else pTechShareUpDef; end)*sum((if (h,cp,r,y,l) in mvTechInp; vTechInp[(h,cp,r,y,l)]; else 0; end;) for cp in comm if (h,g,cp) in mTechGroupComm));
println("eqTechShareInpUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
@constraint(model, [(h, r, g, c, y, l) in meqTechShareOutLo], vTechOut[(h,c,r,y,l)]  >=  (if haskey(pTechShareLo, (h,c,r,y,l)); pTechShareLo[(h,c,r,y,l)]; else pTechShareLoDef; end)*sum((if (h,cp,r,y,l) in mvTechOut; vTechOut[(h,cp,r,y,l)]; else 0; end;) for cp in comm if (h,g,cp) in mTechGroupComm));
println("eqTechShareOutLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
@constraint(model, [(h, r, g, c, y, l) in meqTechShareOutUp], vTechOut[(h,c,r,y,l)] <=  (if haskey(pTechShareUp, (h,c,r,y,l)); pTechShareUp[(h,c,r,y,l)]; else pTechShareUpDef; end)*sum((if (h,cp,r,y,l) in mvTechOut; vTechOut[(h,cp,r,y,l)]; else 0; end;) for cp in comm if (h,g,cp) in mTechGroupComm));
println("eqTechShareOutUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
@constraint(model, [(h, c, r, y, l) in mvTechAInp], vTechAInp[(h,c,r,y,l)]  ==  (if (h,c,r,y,l) in mTechAct2AInp; (vTechAct[(h,r,y,l)]*(if haskey(pTechAct2AInp, (h,c,r,y,l)); pTechAct2AInp[(h,c,r,y,l)]; else pTechAct2AInpDef; end)); else 0; end;)+(if (h,c,r,y,l) in mTechCap2AInp; (vTechCap[(h,r,y)]*(if haskey(pTechCap2AInp, (h,c,r,y,l)); pTechCap2AInp[(h,c,r,y,l)]; else pTechCap2AInpDef; end)); else 0; end;)+(if (h,c,r,y,l) in mTechNCap2AInp; (vTechNewCap[(h,r,y)]*(if haskey(pTechNCap2AInp, (h,c,r,y,l)); pTechNCap2AInp[(h,c,r,y,l)]; else pTechNCap2AInpDef; end)); else 0; end;)+sum((if haskey(pTechCinp2AInp, (h,c,cp,r,y,l)); pTechCinp2AInp[(h,c,cp,r,y,l)]; else pTechCinp2AInpDef; end)*vTechInp[(h,cp,r,y,l)] for cp in comm if (h,c,cp,r,y,l) in mTechCinp2AInp)+sum((if haskey(pTechCout2AInp, (h,c,cp,r,y,l)); pTechCout2AInp[(h,c,cp,r,y,l)]; else pTechCout2AInpDef; end)*vTechOut[(h,cp,r,y,l)] for cp in comm if (h,c,cp,r,y,l) in mTechCout2AInp));
println("eqTechAInp(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
@constraint(model, [(h, c, r, y, l) in mvTechAOut], vTechAOut[(h,c,r,y,l)]  ==  (if (h,c,r,y,l) in mTechAct2AOut; (vTechAct[(h,r,y,l)]*(if haskey(pTechAct2AOut, (h,c,r,y,l)); pTechAct2AOut[(h,c,r,y,l)]; else pTechAct2AOutDef; end)); else 0; end;)+(if (h,c,r,y,l) in mTechCap2AOut; (vTechCap[(h,r,y)]*(if haskey(pTechCap2AOut, (h,c,r,y,l)); pTechCap2AOut[(h,c,r,y,l)]; else pTechCap2AOutDef; end)); else 0; end;)+(if (h,c,r,y,l) in mTechNCap2AOut; (vTechNewCap[(h,r,y)]*(if haskey(pTechNCap2AOut, (h,c,r,y,l)); pTechNCap2AOut[(h,c,r,y,l)]; else pTechNCap2AOutDef; end)); else 0; end;)+sum((if haskey(pTechCinp2AOut, (h,c,cp,r,y,l)); pTechCinp2AOut[(h,c,cp,r,y,l)]; else pTechCinp2AOutDef; end)*vTechInp[(h,cp,r,y,l)] for cp in comm if (h,c,cp,r,y,l) in mTechCinp2AOut)+sum((if haskey(pTechCout2AOut, (h,c,cp,r,y,l)); pTechCout2AOut[(h,c,cp,r,y,l)]; else pTechCout2AOutDef; end)*vTechOut[(h,cp,r,y,l)] for cp in comm if (h,c,cp,r,y,l) in mTechCout2AOut));
println("eqTechAOut(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in meqTechAfLo], (if haskey(pTechAfLo, (h,r,y,l)); pTechAfLo[(h,r,y,l)]; else pTechAfLoDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfLo, (w,h)); pTechWeatherAfLo[(w,h)]; else pTechWeatherAfLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h) in mTechWeatherAfLo) <=  vTechAct[(h,r,y,l)]);
println("eqTechAfLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in meqTechAfUp], vTechAct[(h,r,y,l)] <=  (if haskey(pTechAfUp, (h,r,y,l)); pTechAfUp[(h,r,y,l)]; else pTechAfUpDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfUp, (w,h)); pTechWeatherAfUp[(w,h)]; else pTechWeatherAfUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h) in mTechWeatherAfUp));
println("eqTechAfUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in meqTechAfsLo], (if haskey(pTechAfsLo, (h,r,y,l)); pTechAfsLo[(h,r,y,l)]; else pTechAfsLoDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfsLo, (w,h)); pTechWeatherAfsLo[(w,h)]; else pTechWeatherAfsLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h) in mTechWeatherAfsLo) <=  sum((if (h,r,y,lp) in mvTechAct; vTechAct[(h,r,y,lp)]; else 0; end;) for lp in slice if (l,lp) in mSliceParentChildE));
println("eqTechAfsLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in meqTechAfsUp], sum((if (h,r,y,lp) in mvTechAct; vTechAct[(h,r,y,lp)]; else 0; end;) for lp in slice if (l,lp) in mSliceParentChildE) <=  (if haskey(pTechAfsUp, (h,r,y,l)); pTechAfsUp[(h,r,y,l)]; else pTechAfsUpDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfsUp, (w,h)); pTechWeatherAfsUp[(w,h)]; else pTechWeatherAfsUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h) in mTechWeatherAfsUp));
println("eqTechAfsUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechRampUp(tech, region, year, slice)$mTechRampUp(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in mTechRampUp], (vTechAct[(h,r,y,l)]) / ((if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end))-sum((vTechAct[(h,r,y,lp)]) / ((if haskey(pSliceShare, (lp)); pSliceShare[(lp)]; else pSliceShareDef; end)) for lp in slice if (((h in mTechFullYear && (lp,l) in mSliceNext) || (!((h in mTechFullYear)) && (lp,l) in mSliceFYearNext)) && (h,r,y,lp) in mvTechAct)) <=  ((if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*365*24*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]) / ((if haskey(pTechRampUp, (h,r,y,l)); pTechRampUp[(h,r,y,l)]; else pTechRampUpDef; end)));
println("eqTechRampUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechRampDown(tech, region, year, slice)$mTechRampDown(tech, region, year, slice)
@constraint(model, [(h, r, y, l) in mTechRampDown], sum((vTechAct[(h,r,y,lp)]) / ((if haskey(pSliceShare, (lp)); pSliceShare[(lp)]; else pSliceShareDef; end)) for lp in slice if (((h in mTechFullYear && (lp,l) in mSliceNext) || (!((h in mTechFullYear)) && (lp,l) in mSliceFYearNext)) && (h,r,y,lp) in mvTechAct))-(vTechAct[(h,r,y,l)]) / ((if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)) <=  ((if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*365*24*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]) / ((if haskey(pTechRampDown, (h,r,y,l)); pTechRampDown[(h,r,y,l)]; else pTechRampDownDef; end)));
println("eqTechRampDown(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
@constraint(model, [(h, c, r, y, l) in meqTechActSng], vTechAct[(h,r,y,l)]  ==  (vTechOut[(h,c,r,y,l)]) / ((if haskey(pTechCact2cout, (h,c,r,y,l)); pTechCact2cout[(h,c,r,y,l)]; else pTechCact2coutDef; end)));
println("eqTechActSng(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
@constraint(model, [(h, g, r, y, l) in meqTechActGrp], vTechAct[(h,r,y,l)]  ==  sum((if (h,c,r,y,l) in mvTechOut; ((vTechOut[(h,c,r,y,l)]) / ((if haskey(pTechCact2cout, (h,c,r,y,l)); pTechCact2cout[(h,c,r,y,l)]; else pTechCact2coutDef; end))); else 0; end;) for c in comm if (h,g,c) in mTechGroupComm));
println("eqTechActGrp(tech, group, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
@constraint(model, [(h, r, c, y, l) in meqTechAfcOutLo], (if haskey(pTechCact2cout, (h,c,r,y,l)); pTechCact2cout[(h,c,r,y,l)]; else pTechCact2coutDef; end)*(if haskey(pTechAfcLo, (h,c,r,y,l)); pTechAfcLo[(h,c,r,y,l)]; else pTechAfcLoDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfcLo, (w,h,c)); pTechWeatherAfcLo[(w,h,c)]; else pTechWeatherAfcLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h,c) in mTechWeatherAfcLo) <=  vTechOut[(h,c,r,y,l)]);
println("eqTechAfcOutLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
@constraint(model, [(h, r, c, y, l) in meqTechAfcOutUp], vTechOut[(h,c,r,y,l)] <=  (if haskey(pTechCact2cout, (h,c,r,y,l)); pTechCact2cout[(h,c,r,y,l)]; else pTechCact2coutDef; end)*(if haskey(pTechAfcUp, (h,c,r,y,l)); pTechAfcUp[(h,c,r,y,l)]; else pTechAfcUpDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*prod((if haskey(pTechWeatherAfcUp, (w,h,c)); pTechWeatherAfcUp[(w,h,c)]; else pTechWeatherAfcUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h,c) in mTechWeatherAfcUp));
println("eqTechAfcOutUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
@constraint(model, [(h, r, c, y, l) in meqTechAfcInpLo], (if haskey(pTechAfcLo, (h,c,r,y,l)); pTechAfcLo[(h,c,r,y,l)]; else pTechAfcLoDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfcLo, (w,h,c)); pTechWeatherAfcLo[(w,h,c)]; else pTechWeatherAfcLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h,c) in mTechWeatherAfcLo) <=  vTechInp[(h,c,r,y,l)]);
println("eqTechAfcInpLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
@constraint(model, [(h, r, c, y, l) in meqTechAfcInpUp], vTechInp[(h,c,r,y,l)] <=  (if haskey(pTechAfcUp, (h,c,r,y,l)); pTechAfcUp[(h,c,r,y,l)]; else pTechAfcUpDef; end)*(if haskey(pTechCap2act, (h)); pTechCap2act[(h)]; else pTechCap2actDef; end)*vTechCap[(h,r,y)]*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pTechWeatherAfcUp, (w,h,c)); pTechWeatherAfcUp[(w,h,c)]; else pTechWeatherAfcUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,h,c) in mTechWeatherAfcUp));
println("eqTechAfcInpUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
@constraint(model, [(h, r, y) in mTechSpan], vTechCap[(h,r,y)]  ==  (if haskey(pTechStock, (h,r,y)); pTechStock[(h,r,y)]; else pTechStockDef; end)-(if (h,r,y) in mvTechRetiredStock; vTechRetiredStock[(h,r,y)]; else 0; end;)+sum((if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*(vTechNewCap[(h,r,yp)]-sum(vTechRetiredNewCap[(h,r,yp,ye)] for ye in year if ((h,r,yp,ye) in mvTechRetiredNewCap && ordYear[(y)] >= ordYear[(ye)]))) for yp in year if ((h,r,yp) in mTechNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTechOlife, (h,r)); pTechOlife[(h,r)]; else pTechOlifeDef; end)+ordYear[(yp)] || (h,r) in mTechOlifeInf))));
println("eqTechCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechRetiredNewCap(tech, region, year)$meqTechRetiredNewCap(tech, region, year)
@constraint(model, [(h, r, y) in meqTechRetiredNewCap], sum(vTechRetiredNewCap[(h,r,y,yp)] for yp in year if (h,r,y,yp) in mvTechRetiredNewCap) <=  vTechNewCap[(h,r,y)]);
println("eqTechRetiredNewCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechRetiredStock(tech, region, year)$mvTechRetiredStock(tech, region, year)
@constraint(model, [(h, r, y) in mvTechRetiredStock], vTechRetiredStock[(h,r,y)] <=  (if haskey(pTechStock, (h,r,y)); pTechStock[(h,r,y)]; else pTechStockDef; end));
println("eqTechRetiredStock(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
@constraint(model, [(h, r, y) in mTechEac], vTechEac[(h,r,y)]  ==  sum((if haskey(pTechEac, (h,r,yp)); pTechEac[(h,r,yp)]; else pTechEacDef; end)*(if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*(vTechNewCap[(h,r,yp)]-sum(vTechRetiredNewCap[(h,r,yp,ye)] for ye in year if ((h,r,yp,ye) in mvTechRetiredNewCap && ordYear[(y)] >= ordYear[(ye)]))) for yp in year if ((h,r,yp) in mTechNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTechOlife, (h,r)); pTechOlife[(h,r)]; else pTechOlifeDef; end)+ordYear[(yp)] || (h,r) in mTechOlifeInf))));
println("eqTechEac(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechInv(tech, region, year)$mTechInv(tech, region, year)
@constraint(model, [(h, r, y) in mTechInv], vTechInv[(h,r,y)]  ==  (if haskey(pTechInvcost, (h,r,y)); pTechInvcost[(h,r,y)]; else pTechInvcostDef; end)*vTechNewCap[(h,r,y)]);
println("eqTechInv(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
@constraint(model, [(h, r, y) in mTechOMCost], vTechOMCost[(h,r,y)]  ==  (if haskey(pTechFixom, (h,r,y)); pTechFixom[(h,r,y)]; else pTechFixomDef; end)*vTechCap[(h,r,y)]+sum((if haskey(pTechVarom, (h,r,y,l)); pTechVarom[(h,r,y,l)]; else pTechVaromDef; end)*vTechAct[(h,r,y,l)]+sum((if haskey(pTechCvarom, (h,c,r,y,l)); pTechCvarom[(h,c,r,y,l)]; else pTechCvaromDef; end)*vTechInp[(h,c,r,y,l)] for c in comm if (h,c) in mTechInpComm)+sum((if haskey(pTechCvarom, (h,c,r,y,l)); pTechCvarom[(h,c,r,y,l)]; else pTechCvaromDef; end)*vTechOut[(h,c,r,y,l)] for c in comm if (h,c) in mTechOutComm)+sum((if haskey(pTechAvarom, (h,c,r,y,l)); pTechAvarom[(h,c,r,y,l)]; else pTechAvaromDef; end)*vTechAOut[(h,c,r,y,l)] for c in comm if (h,c,r,y,l) in mvTechAOut)+sum((if haskey(pTechAvarom, (h,c,r,y,l)); pTechAvarom[(h,c,r,y,l)]; else pTechAvaromDef; end)*vTechAInp[(h,c,r,y,l)] for c in comm if (h,c,r,y,l) in mvTechAInp) for l in slice if (h,l) in mTechSlice));
println("eqTechOMCost(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
@constraint(model, [(u, c, r, y, l) in mSupAvaUp], vSupOut[(u,c,r,y,l)] <=  (if haskey(pSupAvaUp, (u,c,r,y,l)); pSupAvaUp[(u,c,r,y,l)]; else pSupAvaUpDef; end)*prod((if haskey(pSupWeatherUp, (w,u)); pSupWeatherUp[(w,u)]; else pSupWeatherUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,u) in mSupWeatherUp));
println("eqSupAvaUp(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
@constraint(model, [(u, c, r, y, l) in meqSupAvaLo], vSupOut[(u,c,r,y,l)]  >=  (if haskey(pSupAvaLo, (u,c,r,y,l)); pSupAvaLo[(u,c,r,y,l)]; else pSupAvaLoDef; end)*prod((if haskey(pSupWeatherLo, (w,u)); pSupWeatherLo[(w,u)]; else pSupWeatherLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,u) in mSupWeatherLo));
println("eqSupAvaLo(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
@constraint(model, [(u, c, r) in mvSupReserve], vSupReserve[(u,c,r)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vSupOut[(u,c,r,y,l)] for y in year for l in slice if (u,c,r,y,l) in mSupAva));
println("eqSupTotal(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
@constraint(model, [(u, c, r) in mSupReserveUp], (if haskey(pSupReserveUp, (u,c,r)); pSupReserveUp[(u,c,r)]; else pSupReserveUpDef; end)  >=  vSupReserve[(u,c,r)]);
println("eqSupReserveUp(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
@constraint(model, [(u, c, r) in meqSupReserveLo], vSupReserve[(u,c,r)]  >=  (if haskey(pSupReserveLo, (u,c,r)); pSupReserveLo[(u,c,r)]; else pSupReserveLoDef; end));
println("eqSupReserveLo(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
@constraint(model, [(u, r, y) in mvSupCost], vSupCost[(u,r,y)]  ==  sum((if haskey(pSupCost, (u,c,r,y,l)); pSupCost[(u,c,r,y,l)]; else pSupCostDef; end)*vSupOut[(u,c,r,y,l)] for c in comm for l in slice if (u,c,r,y,l) in mSupAva));
println("eqSupCost(sup, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvDemInp], vDemInp[(c,r,y,l)]  ==  sum((if haskey(pDemand, (d,c,r,y,l)); pDemand[(d,c,r,y,l)]; else pDemandDef; end) for d in trade if (d,c) in mDemComm));
println("eqDemInp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mAggOut], vAggOut[(c,r,y,l)]  ==  sum((if haskey(pAggregateFactor, (c,cp)); pAggregateFactor[(c,cp)]; else pAggregateFactorDef; end)*sum(vOutTot[(cp,r,y,lp)] for lp in slice if ((c,r,y,lp) in mvOutTot && (l,lp) in mSliceParentChildE && (cp,lp) in mCommSlice)) for cp in comm if (c,cp) in mAggregateFactor));
println("eqAggOut(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mEmsFuelTot], vEmsFuelTot[(c,r,y,l)]  ==  sum((if haskey(pEmissionFactor, (c,cp)); pEmissionFactor[(c,cp)]; else pEmissionFactorDef; end)*sum((if haskey(pTechEmisComm, (h,cp)); pTechEmisComm[(h,cp)]; else pTechEmisCommDef; end)*sum((if (h,c,cp,r,y,lp) in mTechEmsFuel; vTechInp[(h,cp,r,y,lp)]; else 0; end;) for lp in slice if (c,l,lp) in mCommSliceOrParent) for h in tech if (h,cp) in mTechInpComm) for cp in comm if ((if haskey(pEmissionFactor, (c,cp)); pEmissionFactor[(c,cp)]; else pEmissionFactorDef; end)>0)));
println("eqEmsFuelTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in mvStorageAInp], vStorageAInp[(s,c,r,y,l)]  ==  sum((if (s,c,r,y,l) in mStorageStg2AInp; ((if haskey(pStorageStg2AInp, (s,c,r,y,l)); pStorageStg2AInp[(s,c,r,y,l)]; else pStorageStg2AInpDef; end)*vStorageStore[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCinp2AInp; ((if haskey(pStorageCinp2AInp, (s,c,r,y,l)); pStorageCinp2AInp[(s,c,r,y,l)]; else pStorageCinp2AInpDef; end)*vStorageInp[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCout2AInp; ((if haskey(pStorageCout2AInp, (s,c,r,y,l)); pStorageCout2AInp[(s,c,r,y,l)]; else pStorageCout2AInpDef; end)*vStorageOut[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCap2AInp; ((if haskey(pStorageCap2AInp, (s,c,r,y,l)); pStorageCap2AInp[(s,c,r,y,l)]; else pStorageCap2AInpDef; end)*vStorageCap[(s,r,y)]); else 0; end;)+(if (s,c,r,y,l) in mStorageNCap2AInp; ((if haskey(pStorageNCap2AInp, (s,c,r,y,l)); pStorageNCap2AInp[(s,c,r,y,l)]; else pStorageNCap2AInpDef; end)*vStorageNewCap[(s,r,y)]); else 0; end;) for cp in comm if (s,cp) in mStorageComm));
println("eqStorageAInp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in mvStorageAOut], vStorageAOut[(s,c,r,y,l)]  ==  sum((if (s,c,r,y,l) in mStorageStg2AOut; ((if haskey(pStorageStg2AOut, (s,c,r,y,l)); pStorageStg2AOut[(s,c,r,y,l)]; else pStorageStg2AOutDef; end)*vStorageStore[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCinp2AOut; ((if haskey(pStorageCinp2AOut, (s,c,r,y,l)); pStorageCinp2AOut[(s,c,r,y,l)]; else pStorageCinp2AOutDef; end)*vStorageInp[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCout2AOut; ((if haskey(pStorageCout2AOut, (s,c,r,y,l)); pStorageCout2AOut[(s,c,r,y,l)]; else pStorageCout2AOutDef; end)*vStorageOut[(s,cp,r,y,l)]); else 0; end;)+(if (s,c,r,y,l) in mStorageCap2AOut; ((if haskey(pStorageCap2AOut, (s,c,r,y,l)); pStorageCap2AOut[(s,c,r,y,l)]; else pStorageCap2AOutDef; end)*vStorageCap[(s,r,y)]); else 0; end;)+(if (s,c,r,y,l) in mStorageNCap2AOut; ((if haskey(pStorageNCap2AOut, (s,c,r,y,l)); pStorageNCap2AOut[(s,c,r,y,l)]; else pStorageNCap2AOutDef; end)*vStorageNewCap[(s,r,y)]); else 0; end;) for cp in comm if (s,cp) in mStorageComm));
println("eqStorageAOut(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in mvStorageStore], vStorageStore[(s,c,r,y,l)]  ==  (if haskey(pStorageCharge, (s,c,r,y,l)); pStorageCharge[(s,c,r,y,l)]; else pStorageChargeDef; end)+(if (s,r,y) in mStorageNew; ((if haskey(pStorageNCap2Stg, (s,c,r,y,l)); pStorageNCap2Stg[(s,c,r,y,l)]; else pStorageNCap2StgDef; end)*vStorageNewCap[(s,r,y)]); else 0; end;)+sum((if haskey(pStorageInpEff, (s,c,r,y,lp)); pStorageInpEff[(s,c,r,y,lp)]; else pStorageInpEffDef; end)*vStorageInp[(s,c,r,y,lp)]+(((if haskey(pStorageStgEff, (s,c,r,y,l)); pStorageStgEff[(s,c,r,y,l)]; else pStorageStgEffDef; end))^((if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)))*vStorageStore[(s,c,r,y,lp)]-(vStorageOut[(s,c,r,y,lp)]) / ((if haskey(pStorageOutEff, (s,c,r,y,lp)); pStorageOutEff[(s,c,r,y,lp)]; else pStorageOutEffDef; end)) for lp in slice if ((c,lp) in mCommSlice && ((!((s in mStorageFullYear)) && (lp,l) in mSliceNext) || (s in mStorageFullYear && (lp,l) in mSliceFYearNext)))));
println("eqStorageStore(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageAfLo], vStorageStore[(s,c,r,y,l)]  >=  (if haskey(pStorageAfLo, (s,r,y,l)); pStorageAfLo[(s,r,y,l)]; else pStorageAfLoDef; end)*(if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*prod((if haskey(pStorageWeatherAfLo, (w,s)); pStorageWeatherAfLo[(w,s)]; else pStorageWeatherAfLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherAfLo));
println("eqStorageAfLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageAfUp], vStorageStore[(s,c,r,y,l)] <=  (if haskey(pStorageAfUp, (s,r,y,l)); pStorageAfUp[(s,r,y,l)]; else pStorageAfUpDef; end)*(if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*prod((if haskey(pStorageWeatherAfUp, (w,s)); pStorageWeatherAfUp[(w,s)]; else pStorageWeatherAfUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherAfUp));
println("eqStorageAfUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in mvStorageStore], (vStorageOut[(s,c,r,y,l)]) / ((if haskey(pStorageOutEff, (s,c,r,y,l)); pStorageOutEff[(s,c,r,y,l)]; else pStorageOutEffDef; end)) <=  vStorageStore[(s,c,r,y,l)]);
println("eqStorageClean(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageInpUp], vStorageInp[(s,c,r,y,l)] <=  (if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*(if haskey(pStorageCinpUp, (s,c,r,y,l)); pStorageCinpUp[(s,c,r,y,l)]; else pStorageCinpUpDef; end)*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pStorageWeatherCinpUp, (w,s)); pStorageWeatherCinpUp[(w,s)]; else pStorageWeatherCinpUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherCinpUp));
println("eqStorageInpUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageInpLo], vStorageInp[(s,c,r,y,l)]  >=  (if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*(if haskey(pStorageCinpLo, (s,c,r,y,l)); pStorageCinpLo[(s,c,r,y,l)]; else pStorageCinpLoDef; end)*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pStorageWeatherCinpLo, (w,s)); pStorageWeatherCinpLo[(w,s)]; else pStorageWeatherCinpLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherCinpLo));
println("eqStorageInpLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageOutUp], vStorageOut[(s,c,r,y,l)] <=  (if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*(if haskey(pStorageCoutUp, (s,c,r,y,l)); pStorageCoutUp[(s,c,r,y,l)]; else pStorageCoutUpDef; end)*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pStorageWeatherCoutUp, (w,s)); pStorageWeatherCoutUp[(w,s)]; else pStorageWeatherCoutUpDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherCoutUp));
println("eqStorageOutUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
@constraint(model, [(s, c, r, y, l) in meqStorageOutLo], vStorageOut[(s,c,r,y,l)]  >=  (if haskey(pStorageCap2stg, (s)); pStorageCap2stg[(s)]; else pStorageCap2stgDef; end)*vStorageCap[(s,r,y)]*(if haskey(pStorageCoutLo, (s,c,r,y,l)); pStorageCoutLo[(s,c,r,y,l)]; else pStorageCoutLoDef; end)*(if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*prod((if haskey(pStorageWeatherCoutLo, (w,s)); pStorageWeatherCoutLo[(w,s)]; else pStorageWeatherCoutLoDef; end)*(if haskey(pWeather, (w,r,y,l)); pWeather[(w,r,y,l)]; else pWeatherDef; end) for w in weather if (w,s) in mStorageWeatherCoutLo));
println("eqStorageOutLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
@constraint(model, [(s, r, y) in mStorageSpan], vStorageCap[(s,r,y)]  ==  (if haskey(pStorageStock, (s,r,y)); pStorageStock[(s,r,y)]; else pStorageStockDef; end)+sum((if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*vStorageNewCap[(s,r,yp)] for yp in year if (ordYear[(y)] >= ordYear[(yp)] && ((s,r) in mStorageOlifeInf || ordYear[(y)]<(if haskey(pStorageOlife, (s,r)); pStorageOlife[(s,r)]; else pStorageOlifeDef; end)+ordYear[(yp)]) && (s,r,yp) in mStorageNew)));
println("eqStorageCap(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
@constraint(model, [(s, r, y) in mStorageNew], vStorageInv[(s,r,y)]  ==  (if haskey(pStorageInvcost, (s,r,y)); pStorageInvcost[(s,r,y)]; else pStorageInvcostDef; end)*vStorageNewCap[(s,r,y)]);
println("eqStorageInv(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
@constraint(model, [(s, r, y) in mStorageEac], vStorageEac[(s,r,y)]  ==  sum((if haskey(pStorageEac, (s,r,yp)); pStorageEac[(s,r,yp)]; else pStorageEacDef; end)*(if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*vStorageNewCap[(s,r,yp)] for yp in year if ((s,r,yp) in mStorageNew && ordYear[(y)] >= ordYear[(yp)] && ((s,r) in mStorageOlifeInf || ordYear[(y)]<(if haskey(pStorageOlife, (s,r)); pStorageOlife[(s,r)]; else pStorageOlifeDef; end)+ordYear[(yp)]) && (if haskey(pStorageInvcost, (s,r,yp)); pStorageInvcost[(s,r,yp)]; else pStorageInvcostDef; end) != 0)));
println("eqStorageEac(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
@constraint(model, [(s, r, y) in mStorageOMCost], vStorageOMCost[(s,r,y)]  ==  (if haskey(pStorageFixom, (s,r,y)); pStorageFixom[(s,r,y)]; else pStorageFixomDef; end)*vStorageCap[(s,r,y)]+sum(sum((if haskey(pStorageCostInp, (s,r,y,l)); pStorageCostInp[(s,r,y,l)]; else pStorageCostInpDef; end)*vStorageInp[(s,c,r,y,l)]+(if haskey(pStorageCostOut, (s,r,y,l)); pStorageCostOut[(s,r,y,l)]; else pStorageCostOutDef; end)*vStorageOut[(s,c,r,y,l)]+(if haskey(pStorageCostStore, (s,r,y,l)); pStorageCostStore[(s,r,y,l)]; else pStorageCostStoreDef; end)*vStorageStore[(s,c,r,y,l)] for l in slice if (c,l) in mCommSlice) for c in comm if (s,c) in mStorageComm));
println("eqStorageCost(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
@constraint(model, [(c, dst, y, l) in mImport], vImport[(c,dst,y,l)]  ==  sum(sum(sum((if (d,c,src,dst,y,lp) in mvTradeIr; ((if haskey(pTradeIrEff, (d,src,dst,y,lp)); pTradeIrEff[(d,src,dst,y,lp)]; else pTradeIrEffDef; end)*vTradeIr[(d,c,src,dst,y,lp)]); else 0; end;) for src in region if (d,src,dst) in mTradeRoutes) for d in trade if (d,c) in mTradeComm) for lp in slice if (c,l,lp) in mCommSliceOrParent)+sum(sum((if (m,c,dst,y,lp) in mImportRow; vImportRow[(m,c,dst,y,lp)]; else 0; end;) for m in imp if (m,c) in mImpComm) for lp in slice if (c,l,lp) in mCommSliceOrParent));
println("eqImport(comm, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
@constraint(model, [(c, src, y, l) in mExport], vExport[(c,src,y,l)]  ==  sum(sum(sum((if (d,c,src,dst,y,lp) in mvTradeIr; vTradeIr[(d,c,src,dst,y,lp)]; else 0; end;) for dst in region if (d,src,dst) in mTradeRoutes) for d in trade if (d,c) in mTradeComm) for lp in slice if (c,l,lp) in mCommSliceOrParent)+sum(sum((if (x,c,src,y,lp) in mExportRow; vExportRow[(x,c,src,y,lp)]; else 0; end;) for x in expp if (x,c) in mExpComm) for lp in slice if (c,l,lp) in mCommSliceOrParent));
println("eqExport(comm, src, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
@constraint(model, [(d, c, src, dst, y, l) in meqTradeFlowUp], vTradeIr[(d,c,src,dst,y,l)] <=  (if haskey(pTradeIrUp, (d,src,dst,y,l)); pTradeIrUp[(d,src,dst,y,l)]; else pTradeIrUpDef; end));
println("eqTradeFlowUp(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
@constraint(model, [(d, c, src, dst, y, l) in meqTradeFlowLo], vTradeIr[(d,c,src,dst,y,l)]  >=  (if haskey(pTradeIrLo, (d,src,dst,y,l)); pTradeIrLo[(d,src,dst,y,l)]; else pTradeIrLoDef; end));
println("eqTradeFlowLo(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqCostTrade(region, year)$mvTradeCost(region, year)
@constraint(model, [(r, y) in mvTradeCost], vTradeCost[(r,y)]  ==  (if (r,y) in mvTradeRowCost; vTradeRowCost[(r,y)]; else 0; end;)+(if (r,y) in mvTradeIrCost; vTradeIrCost[(r,y)]; else 0; end;));
println("eqCostTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
@constraint(model, [(r, y) in mvTradeRowCost], vTradeRowCost[(r,y)]  ==  sum((if haskey(pImportRowPrice, (m,r,y,l)); pImportRowPrice[(m,r,y,l)]; else pImportRowPriceDef; end)*vImportRow[(m,c,r,y,l)] for m in imp for c in comm for l in slice if (m,c,r,y,l) in mImportRow)-sum((if haskey(pExportRowPrice, (x,r,y,l)); pExportRowPrice[(x,r,y,l)]; else pExportRowPriceDef; end)*vExportRow[(x,c,r,y,l)] for x in expp for c in comm for l in slice if (x,c,r,y,l) in mExportRow));
println("eqCostRowTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
@constraint(model, [(r, y) in mvTradeIrCost], vTradeIrCost[(r,y)]  ==  sum(vTradeEac[(d,r,y)] for d in trade if (d,r,y) in mTradeEac)+sum(sum(sum((if (d,c,src,r,y,l) in mvTradeIr; ((((if haskey(pTradeIrCost, (d,src,r,y,l)); pTradeIrCost[(d,src,r,y,l)]; else pTradeIrCostDef; end)+(if haskey(pTradeIrMarkup, (d,src,r,y,l)); pTradeIrMarkup[(d,src,r,y,l)]; else pTradeIrMarkupDef; end))*vTradeIr[(d,c,src,r,y,l)])); else 0; end;) for l in slice if (d,l) in mTradeSlice) for c in comm if (d,c) in mTradeComm) for d in trade for src in region if (d,src,r) in mTradeRoutes)-sum(sum(sum((if (d,c,r,dst,y,l) in mvTradeIr; (((if haskey(pTradeIrMarkup, (d,r,dst,y,l)); pTradeIrMarkup[(d,r,dst,y,l)]; else pTradeIrMarkupDef; end)*vTradeIr[(d,c,r,dst,y,l)])); else 0; end;) for l in slice if (d,l) in mTradeSlice) for c in comm if (d,c) in mTradeComm) for d in trade for dst in region if (d,r,dst) in mTradeRoutes));
println("eqCostIrTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
@constraint(model, [(x, c, r, y, l) in mExportRowUp], vExportRow[(x,c,r,y,l)] <=  (if haskey(pExportRowUp, (x,r,y,l)); pExportRowUp[(x,r,y,l)]; else pExportRowUpDef; end));
println("eqExportRowUp(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
@constraint(model, [(x, c, r, y, l) in meqExportRowLo], vExportRow[(x,c,r,y,l)]  >=  (if haskey(pExportRowLo, (x,r,y,l)); pExportRowLo[(x,r,y,l)]; else pExportRowLoDef; end));
println("eqExportRowLo(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
@constraint(model, [(x, c) in mExpComm], vExportRowAccumulated[(x,c)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vExportRow[(x,c,r,y,l)] for r in region for y in year for l in slice if (x,c,r,y,l) in mExportRow));
println("eqExportRowCumulative(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))
# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
@constraint(model, [(x, c) in mExportRowAccumulatedUp], vExportRowAccumulated[(x,c)] <=  (if haskey(pExportRowRes, (x)); pExportRowRes[(x)]; else pExportRowResDef; end));
println("eqExportRowResUp(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))
# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
@constraint(model, [(m, c, r, y, l) in mImportRowUp], vImportRow[(m,c,r,y,l)] <=  (if haskey(pImportRowUp, (m,r,y,l)); pImportRowUp[(m,r,y,l)]; else pImportRowUpDef; end));
println("eqImportRowUp(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
@constraint(model, [(m, c, r, y, l) in meqImportRowLo], vImportRow[(m,c,r,y,l)]  >=  (if haskey(pImportRowLo, (m,r,y,l)); pImportRowLo[(m,r,y,l)]; else pImportRowLoDef; end));
println("eqImportRowLo(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
@constraint(model, [(m, c) in mImpComm], vImportRowAccumulated[(m,c)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vImportRow[(m,c,r,y,l)] for r in region for y in year for l in slice if (m,c,r,y,l) in mImportRow));
println("eqImportRowAccumulated(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))
# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
@constraint(model, [(m, c) in mImportRowAccumulatedUp], vImportRowAccumulated[(m,c)] <=  (if haskey(pImportRowRes, (m)); pImportRowRes[(m)]; else pImportRowResDef; end));
println("eqImportRowResUp(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
@constraint(model, [(d, c, y, l) in meqTradeCapFlow], (if haskey(pSliceShare, (l)); pSliceShare[(l)]; else pSliceShareDef; end)*(if haskey(pTradeCap2Act, (d)); pTradeCap2Act[(d)]; else pTradeCap2ActDef; end)*vTradeCap[(d,y)]  >=  sum(vTradeIr[(d,c,src,dst,y,l)] for src in region for dst in region if (d,c,src,dst,y,l) in mvTradeIr));
println("eqTradeCapFlow(trade, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeCap(trade, year)$mTradeSpan(trade, year)
@constraint(model, [(d, y) in mTradeSpan], vTradeCap[(d,y)]  ==  (if haskey(pTradeStock, (d,y)); pTradeStock[(d,y)]; else pTradeStockDef; end)+sum((if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*vTradeNewCap[(d,yp)] for yp in year if ((d,yp) in mTradeNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTradeOlife, (d)); pTradeOlife[(d)]; else pTradeOlifeDef; end)+ordYear[(yp)] || d in mTradeOlifeInf))));
println("eqTradeCap(trade, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
@constraint(model, [(d, r, y) in mTradeInv], vTradeInv[(d,r,y)]  ==  (if haskey(pTradeInvcost, (d,r,y)); pTradeInvcost[(d,r,y)]; else pTradeInvcostDef; end)*vTradeNewCap[(d,y)]);
println("eqTradeInv(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
@constraint(model, [(d, r, y) in mTradeEac], vTradeEac[(d,r,y)]  ==  sum((if haskey(pTradeEac, (d,r,yp)); pTradeEac[(d,r,yp)]; else pTradeEacDef; end)*(if haskey(pPeriodLen, (yp)); pPeriodLen[(yp)]; else pPeriodLenDef; end)*vTradeNewCap[(d,yp)] for yp in year if ((d,yp) in mTradeNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTradeOlife, (d)); pTradeOlife[(d)]; else pTradeOlifeDef; end)+ordYear[(yp)] || d in mTradeOlifeInf))));
println("eqTradeEac(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
@constraint(model, [(d, c, r, y, l) in mvTradeIrAInp], vTradeIrAInp[(d,c,r,y,l)]  ==  sum((if haskey(pTradeIrCsrc2Ainp, (d,c,r,dst,y,l)); pTradeIrCsrc2Ainp[(d,c,r,dst,y,l)]; else pTradeIrCsrc2AinpDef; end)*sum(vTradeIr[(d,cp,r,dst,y,l)] for cp in comm if (d,cp) in mTradeComm) for dst in region if (d,c,r,dst,y,l) in mTradeIrCsrc2Ainp)+sum((if haskey(pTradeIrCdst2Ainp, (d,c,src,r,y,l)); pTradeIrCdst2Ainp[(d,c,src,r,y,l)]; else pTradeIrCdst2AinpDef; end)*sum(vTradeIr[(d,cp,src,r,y,l)] for cp in comm if (d,cp) in mTradeComm) for src in region if (d,c,src,r,y,l) in mTradeIrCdst2Ainp));
println("eqTradeIrAInp(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
@constraint(model, [(d, c, r, y, l) in mvTradeIrAOut], vTradeIrAOut[(d,c,r,y,l)]  ==  sum((if haskey(pTradeIrCsrc2Aout, (d,c,r,dst,y,l)); pTradeIrCsrc2Aout[(d,c,r,dst,y,l)]; else pTradeIrCsrc2AoutDef; end)*sum(vTradeIr[(d,cp,r,dst,y,l)] for cp in comm if (d,cp) in mTradeComm) for dst in region if (d,c,r,dst,y,l) in mTradeIrCsrc2Aout)+sum((if haskey(pTradeIrCdst2Aout, (d,c,src,r,y,l)); pTradeIrCdst2Aout[(d,c,src,r,y,l)]; else pTradeIrCdst2AoutDef; end)*sum(vTradeIr[(d,cp,src,r,y,l)] for cp in comm if (d,cp) in mTradeComm) for src in region if (d,c,src,r,y,l) in mTradeIrCdst2Aout));
println("eqTradeIrAOut(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvTradeIrAInpTot], vTradeIrAInpTot[(c,r,y,l)]  ==  sum(vTradeIrAInp[(d,c,r,y,lp)] for d in trade for lp in slice if ((c,l,lp) in mCommSliceOrParent && (d,c,r,y,lp) in mvTradeIrAInp)));
println("eqTradeIrAInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvTradeIrAOutTot], vTradeIrAOutTot[(c,r,y,l)]  ==  sum(vTradeIrAOut[(d,c,r,y,lp)] for d in trade for lp in slice if ((c,l,lp) in mCommSliceOrParent && (d,c,r,y,lp) in mvTradeIrAOut)));
println("eqTradeIrAOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in meqBalLo], vBalance[(c,r,y,l)]  >=  0);
println("eqBalLo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in meqBalUp], vBalance[(c,r,y,l)] <=  0);
println("eqBalUp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in meqBalFx], vBalance[(c,r,y,l)]  ==  0);
println("eqBalFx(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvBalance], vBalance[(c,r,y,l)]  ==  (if (c,r,y,l) in mvOutTot; vOutTot[(c,r,y,l)]; else 0; end;)-(if (c,r,y,l) in mvInpTot; vInpTot[(c,r,y,l)]; else 0; end;));
println("eqBal(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqOutTot(comm, region, year, slice)$mvOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvOutTot], vOutTot[(c,r,y,l)]  ==  (if (c,r,y,l) in mDummyImport; vDummyImport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mSupOutTot; vSupOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mEmsFuelTot; vEmsFuelTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mAggOut; vAggOut[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mTechOutTot; vTechOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mStorageOutTot; vStorageOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mImport; vImport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mvTradeIrAOutTot; vTradeIrAOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mOutSub; sum(vOut2Lo[(c,r,y,lp,l)] for lp in slice if ((lp,l) in mSliceParentChild && (c,r,y,lp,l) in mvOut2Lo)); else 0; end;));
println("eqOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mOut2Lo], sum(vOut2Lo[(c,r,y,l,lp)] for lp in slice if (c,r,y,l,lp) in mvOut2Lo)  ==  (if (c,r,y,l) in mSupOutTot; vSupOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mEmsFuelTot; vEmsFuelTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mAggOut; vAggOut[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mTechOutTot; vTechOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mStorageOutTot; vStorageOutTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mImport; vImport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mvTradeIrAOutTot; vTradeIrAOutTot[(c,r,y,l)]; else 0; end;));
println("eqOut2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqInpTot(comm, region, year, slice)$mvInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mvInpTot], vInpTot[(c,r,y,l)]  ==  (if (c,r,y,l) in mvDemInp; vDemInp[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mDummyExport; vDummyExport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mTechInpTot; vTechInpTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mStorageInpTot; vStorageInpTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mExport; vExport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mvTradeIrAInpTot; vTradeIrAInpTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mInpSub; sum(vInp2Lo[(c,r,y,lp,l)] for lp in slice if ((lp,l) in mSliceParentChild && (c,r,y,lp,l) in mvInp2Lo)); else 0; end;));
println("eqInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mInp2Lo], sum(vInp2Lo[(c,r,y,l,lp)] for lp in slice if (c,r,y,l,lp) in mvInp2Lo)  ==  (if (c,r,y,l) in mTechInpTot; vTechInpTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mStorageInpTot; vStorageInpTot[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mExport; vExport[(c,r,y,l)]; else 0; end;)+(if (c,r,y,l) in mvTradeIrAInpTot; vTradeIrAInpTot[(c,r,y,l)]; else 0; end;));
println("eqInp2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mSupOutTot], vSupOutTot[(c,r,y,l)]  ==  sum(sum(vSupOut[(u,c,r,y,lp)] for lp in slice if ((c,l,lp) in mCommSliceOrParent && (u,c,r,y,lp) in mSupAva)) for u in sup if (u,c) in mSupComm));
println("eqSupOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mTechInpTot], vTechInpTot[(c,r,y,l)]  ==  sum(sum((if (h,c,r,y,lp) in mvTechInp; vTechInp[(h,c,r,y,lp)]; else 0; end;) for lp in slice if ((h,lp) in mTechSlice && (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechInpComm)+sum(sum((if (h,c,r,y,lp) in mvTechAInp; vTechAInp[(h,c,r,y,lp)]; else 0; end;) for lp in slice if ((h,lp) in mTechSlice && (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechAInp));
println("eqTechInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mTechOutTot], vTechOutTot[(c,r,y,l)]  ==  sum(sum((if (h,c,r,y,lp) in mvTechOut; vTechOut[(h,c,r,y,lp)]; else 0; end;) for lp in slice if ((h,lp) in mTechSlice && (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechOutComm)+sum(sum((if (h,c,r,y,lp) in mvTechAOut; vTechAOut[(h,c,r,y,lp)]; else 0; end;) for lp in slice if ((h,lp) in mTechSlice && (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechAOut));
println("eqTechOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mStorageInpTot], vStorageInpTot[(c,r,y,l)]  ==  sum(vStorageInp[(s,c,r,y,l)] for s in stg if (s,c,r,y,l) in mvStorageStore)+sum(vStorageAInp[(s,c,r,y,l)] for s in stg if (s,c,r,y,l) in mvStorageAInp));
println("eqStorageInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, l) in mStorageOutTot], vStorageOutTot[(c,r,y,l)]  ==  sum(vStorageOut[(s,c,r,y,l)] for s in stg if (s,c,r,y,l) in mvStorageStore)+sum(vStorageAOut[(s,c,r,y,l)] for s in stg if (s,c,r,y,l) in mvStorageAOut));
println("eqStorageOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
# eqCost(region, year)$mvTotalCost(region, year)
@constraint(model, [(r, y) in mvTotalCost], vTotalCost[(r,y)]  ==  sum(vTechEac[(h,r,y)] for h in tech if (h,r,y) in mTechEac)+sum(vTechOMCost[(h,r,y)] for h in tech if (h,r,y) in mTechOMCost)+sum(vSupCost[(u,r,y)] for u in sup if (u,r,y) in mvSupCost)+sum((if haskey(pDummyImportCost, (c,r,y,l)); pDummyImportCost[(c,r,y,l)]; else pDummyImportCostDef; end)*vDummyImport[(c,r,y,l)] for c in comm for l in slice if (c,r,y,l) in mDummyImport)+sum((if haskey(pDummyExportCost, (c,r,y,l)); pDummyExportCost[(c,r,y,l)]; else pDummyExportCostDef; end)*vDummyExport[(c,r,y,l)] for c in comm for l in slice if (c,r,y,l) in mDummyExport)+sum(vTaxCost[(c,r,y)] for c in comm if (c,r,y) in mTaxCost)-sum(vSubsCost[(c,r,y)] for c in comm if (c,r,y) in mSubCost)+sum(vStorageOMCost[(s,r,y)] for s in stg if (s,r,y) in mStorageOMCost)+sum(vStorageEac[(s,r,y)] for s in stg if (s,r,y) in mStorageEac)+(if (r,y) in mvTradeCost; vTradeCost[(r,y)]; else 0; end;)+(if (r,y) in mvTotalUserCosts; vTotalUserCosts[(r,y)]; else 0; end;));
println("eqCost(region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
@constraint(model, [(c, r, y) in mTaxCost], vTaxCost[(c,r,y)]  ==  sum((if haskey(pTaxCostOut, (c,r,y,l)); pTaxCostOut[(c,r,y,l)]; else pTaxCostOutDef; end)*vOutTot[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvOutTot && (c,l) in mCommSlice))+sum((if haskey(pTaxCostInp, (c,r,y,l)); pTaxCostInp[(c,r,y,l)]; else pTaxCostInpDef; end)*vInpTot[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvInpTot && (c,l) in mCommSlice))+sum((if haskey(pTaxCostBal, (c,r,y,l)); pTaxCostBal[(c,r,y,l)]; else pTaxCostBalDef; end)*vBalance[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvBalance && (c,l) in mCommSlice)));
println("eqTaxCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqSubsCost(comm, region, year)$mSubCost(comm, region, year)
@constraint(model, [(c, r, y) in mSubCost], vSubsCost[(c,r,y)]  ==  sum((if haskey(pSubCostOut, (c,r,y,l)); pSubCostOut[(c,r,y,l)]; else pSubCostOutDef; end)*vOutTot[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvOutTot && (c,l) in mCommSlice))+sum((if haskey(pSubCostInp, (c,r,y,l)); pSubCostInp[(c,r,y,l)]; else pSubCostInpDef; end)*vInpTot[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvInpTot && (c,l) in mCommSlice))+sum((if haskey(pSubCostBal, (c,r,y,l)); pSubCostBal[(c,r,y,l)]; else pSubCostBalDef; end)*vBalance[(c,r,y,l)] for l in slice if ((c,r,y,l) in mvBalance && (c,l) in mCommSlice)));
println("eqSubsCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))
# eqObjective
@constraint(model, vObjective  ==  sum(vTotalCost[(r,y)]*(if haskey(pDiscountFactorMileStone, (r,y)); pDiscountFactorMileStone[(r,y)]; else pDiscountFactorMileStoneDef; end) for r in region for y in year if (r,y) in mvTotalCost));
println("eqObjective done ", Dates.format(now(), "HH:MM:SS"))
# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
@constraint(model, [(h, r, y) in meqLECActivity], sum(vTechAct[(h,r,y,l)] for l in slice if (h,l) in mTechSlice)  >=  (if haskey(pLECLoACT, (r)); pLECLoACT[(r)]; else pLECLoACTDef; end));
println("eqLECActivity(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(flog,"\"solver\",,\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")
@objective(model, Min, vObjective)
include("inc_constraints.jl")
include("inc_costs.jl")
include("inc_solver.jl")
# using Cbc
# set_optimizer(model, Cbc.Optimizer)
include("inc3.jl")
optimize!(model)
hh = "-100"
if termination_status(model) == MOI.OPTIMAL
  hh = "1"
end
println(flog,"\"solution status\",", hh, ",\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")
include("inc4.jl")
println(flog,"\"export results\",,\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")

# Print solution
include("output.jl")
include("inc5.jl")
println(flog,"\"done\",,\"", Dates.format(now(), "yyyy-mm-dd HH:MM:SS"), "\"")
