using Dates
f = open("log.txt", "w")
println(f, "start ", Dates.format(now(), "HH:MM:SS"))
println("start ", Dates.format(now(), "HH:MM:SS"))
using Cbc
using JuMP
include("data.jl")
model = Model();
@variable(model, vTechInv[mTechNew]);
@variable(model, vTechEac[mTechEac]);
@variable(model, vTechOMCost[mTechOMCost]);
@variable(model, vSupCost[mvSupCost]);
@variable(model, vEmsFuelTot[mEmsFuelTot]);
@variable(model, vBalance[mvBalance]);
@variable(model, vTotalCost[mvTotalCost]);
@variable(model, vObjective);
@variable(model, vTaxCost[mTaxCost]);
@variable(model, vSubsCost[mSubsCost]);
@variable(model, vAggOut[mAggOut]);
@variable(model, vStorageOMCost[mStorageOMCost]);
@variable(model, vTradeCost[mvTradeCost]);
@variable(model, vTradeRowCost[mvTradeRowCost]);
@variable(model, vTradeIrCost[mvTradeIrCost]);
@variable(model, vTechNewCap[mTechNew] >= 0);
@variable(model, vTechRetiredCap[mvTechRetiredCap] >= 0);
@variable(model, vTechCap[mTechSpan] >= 0);
@variable(model, vTechAct[mvTechAct] >= 0);
@variable(model, vTechInp[mvTechInp] >= 0);
@variable(model, vTechOut[mvTechOut] >= 0);
@variable(model, vTechAInp[mvTechAInp] >= 0);
@variable(model, vTechAOut[mvTechAOut] >= 0);
@variable(model, vSupOut[mSupAva] >= 0);
@variable(model, vSupReserve[mvSupReserve] >= 0);
@variable(model, vDemInp[mvDemInp] >= 0);
@variable(model, vOutTot[mvBalance] >= 0);
@variable(model, vInpTot[mvBalance] >= 0);
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
@variable(model, vTradeCap[mvTradeCap] >= 0);
@variable(model, vTradeInv[mTradeEac] >= 0);
@variable(model, vTradeEac[mTradeEac] >= 0);
@variable(model, vTradeNewCap[mvTradeNewCap] >= 0);
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
@constraint(model, [(t, r, c, cp, y, s) in meqTechSng2Sng], vTechInp[(t,c,r,y,s)]*(if haskey(pTechCinp2use, (t,c,r,y,s)); pTechCinp2use[(t,c,r,y,s)]; else pTechCinp2useDef; end)  ==  (vTechOut[(t,cp,r,y,s)]) / ((if haskey(pTechUse2cact, (t,cp,r,y,s)); pTechUse2cact[(t,cp,r,y,s)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (t,cp,r,y,s)); pTechCact2cout[(t,cp,r,y,s)]; else pTechCact2coutDef; end)));
println("eqTechSng2Sng(tech, region, comm, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechSng2Sng(tech, region, comm, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
@constraint(model, [(t, r, g, cp, y, s) in meqTechGrp2Sng], (if haskey(pTechGinp2use, (t,g,r,y,s)); pTechGinp2use[(t,g,r,y,s)]; else pTechGinp2useDef; end)*sum((if (t,c,r,y,s) in mvTechInp; (vTechInp[(t,c,r,y,s)]*(if haskey(pTechCinp2ginp, (t,c,r,y,s)); pTechCinp2ginp[(t,c,r,y,s)]; else pTechCinp2ginpDef; end)); else 0; end;) for c in comm if (t,g,c) in mTechGroupComm)  ==  (vTechOut[(t,cp,r,y,s)]) / ((if haskey(pTechUse2cact, (t,cp,r,y,s)); pTechUse2cact[(t,cp,r,y,s)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (t,cp,r,y,s)); pTechCact2cout[(t,cp,r,y,s)]; else pTechCact2coutDef; end)));
println("eqTechGrp2Sng(tech, region, group, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechGrp2Sng(tech, region, group, commp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
@constraint(model, [(t, r, c, gp, y, s) in meqTechSng2Grp], vTechInp[(t,c,r,y,s)]*(if haskey(pTechCinp2use, (t,c,r,y,s)); pTechCinp2use[(t,c,r,y,s)]; else pTechCinp2useDef; end)  ==  sum((if (t,cp,r,y,s) in mvTechOut; ((vTechOut[(t,cp,r,y,s)]) / ((if haskey(pTechUse2cact, (t,cp,r,y,s)); pTechUse2cact[(t,cp,r,y,s)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (t,cp,r,y,s)); pTechCact2cout[(t,cp,r,y,s)]; else pTechCact2coutDef; end))); else 0; end;) for cp in comm if (t,gp,cp) in mTechGroupComm));
println("eqTechSng2Grp(tech, region, comm, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechSng2Grp(tech, region, comm, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
@constraint(model, [(t, r, g, gp, y, s) in meqTechGrp2Grp], (if haskey(pTechGinp2use, (t,g,r,y,s)); pTechGinp2use[(t,g,r,y,s)]; else pTechGinp2useDef; end)*sum((if (t,c,r,y,s) in mvTechInp; (vTechInp[(t,c,r,y,s)]*(if haskey(pTechCinp2ginp, (t,c,r,y,s)); pTechCinp2ginp[(t,c,r,y,s)]; else pTechCinp2ginpDef; end)); else 0; end;) for c in comm if (t,g,c) in mTechGroupComm)  ==  sum((if (t,cp,r,y,s) in mvTechOut; ((vTechOut[(t,cp,r,y,s)]) / ((if haskey(pTechUse2cact, (t,cp,r,y,s)); pTechUse2cact[(t,cp,r,y,s)]; else pTechUse2cactDef; end)*(if haskey(pTechCact2cout, (t,cp,r,y,s)); pTechCact2cout[(t,cp,r,y,s)]; else pTechCact2coutDef; end))); else 0; end;) for cp in comm if (t,gp,cp) in mTechGroupComm));
println("eqTechGrp2Grp(tech, region, group, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechGrp2Grp(tech, region, group, groupp, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
@constraint(model, [(t, r, g, c, y, s) in meqTechShareInpLo], vTechInp[(t,c,r,y,s)]  >=  (if haskey(pTechShareLo, (t,c,r,y,s)); pTechShareLo[(t,c,r,y,s)]; else pTechShareLoDef; end)*sum((if (t,cp,r,y,s) in mvTechInp; vTechInp[(t,cp,r,y,s)]; else 0; end;) for cp in comm if (t,g,cp) in mTechGroupComm));
println("eqTechShareInpLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechShareInpLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
@constraint(model, [(t, r, g, c, y, s) in meqTechShareInpUp], vTechInp[(t,c,r,y,s)] <=  (if haskey(pTechShareUp, (t,c,r,y,s)); pTechShareUp[(t,c,r,y,s)]; else pTechShareUpDef; end)*sum((if (t,cp,r,y,s) in mvTechInp; vTechInp[(t,cp,r,y,s)]; else 0; end;) for cp in comm if (t,g,cp) in mTechGroupComm));
println("eqTechShareInpUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechShareInpUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
@constraint(model, [(t, r, g, c, y, s) in meqTechShareOutLo], vTechOut[(t,c,r,y,s)]  >=  (if haskey(pTechShareLo, (t,c,r,y,s)); pTechShareLo[(t,c,r,y,s)]; else pTechShareLoDef; end)*sum((if (t,cp,r,y,s) in mvTechOut; vTechOut[(t,cp,r,y,s)]; else 0; end;) for cp in comm if (t,g,cp) in mTechGroupComm));
println("eqTechShareOutLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechShareOutLo(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
@constraint(model, [(t, r, g, c, y, s) in meqTechShareOutUp], vTechOut[(t,c,r,y,s)] <=  (if haskey(pTechShareUp, (t,c,r,y,s)); pTechShareUp[(t,c,r,y,s)]; else pTechShareUpDef; end)*sum((if (t,cp,r,y,s) in mvTechOut; vTechOut[(t,cp,r,y,s)]; else 0; end;) for cp in comm if (t,g,cp) in mTechGroupComm));
println("eqTechShareOutUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechShareOutUp(tech, region, group, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
@constraint(model, [(t, c, r, y, s) in mvTechAInp], vTechAInp[(t,c,r,y,s)]  ==  (vTechAct[(t,r,y,s)]*(if haskey(pTechAct2AInp, (t,c,r,y,s)); pTechAct2AInp[(t,c,r,y,s)]; else pTechAct2AInpDef; end))+(vTechCap[(t,r,y)]*(if haskey(pTechCap2AInp, (t,c,r,y,s)); pTechCap2AInp[(t,c,r,y,s)]; else pTechCap2AInpDef; end))+(if (t,r,y) in mTechNew; (vTechNewCap[(t,r,y)]*(if haskey(pTechNCap2AInp, (t,c,r,y,s)); pTechNCap2AInp[(t,c,r,y,s)]; else pTechNCap2AInpDef; end)); else 0; end;)+sum((if haskey(pTechCinp2AInp, (t,c,cp,r,y,s)); pTechCinp2AInp[(t,c,cp,r,y,s)]; else pTechCinp2AInpDef; end)*vTechInp[(t,cp,r,y,s)] for cp in comm if ((if haskey(pTechCinp2AInp, (t,c,cp,r,y,s)); pTechCinp2AInp[(t,c,cp,r,y,s)]; else pTechCinp2AInpDef; end)>0))+sum((if haskey(pTechCout2AInp, (t,c,cp,r,y,s)); pTechCout2AInp[(t,c,cp,r,y,s)]; else pTechCout2AInpDef; end)*vTechOut[(t,cp,r,y,s)] for cp in comm if ((if haskey(pTechCout2AInp, (t,c,cp,r,y,s)); pTechCout2AInp[(t,c,cp,r,y,s)]; else pTechCout2AInpDef; end)>0)));
println("eqTechAInp(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAInp(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
@constraint(model, [(t, c, r, y, s) in mvTechAOut], vTechAOut[(t,c,r,y,s)]  ==  (vTechAct[(t,r,y,s)]*(if haskey(pTechAct2AOut, (t,c,r,y,s)); pTechAct2AOut[(t,c,r,y,s)]; else pTechAct2AOutDef; end))+(vTechCap[(t,r,y)]*(if haskey(pTechCap2AOut, (t,c,r,y,s)); pTechCap2AOut[(t,c,r,y,s)]; else pTechCap2AOutDef; end))+(if (t,r,y) in mTechNew; (vTechNewCap[(t,r,y)]*(if haskey(pTechNCap2AOut, (t,c,r,y,s)); pTechNCap2AOut[(t,c,r,y,s)]; else pTechNCap2AOutDef; end)); else 0; end;)+sum((if haskey(pTechCinp2AOut, (t,c,cp,r,y,s)); pTechCinp2AOut[(t,c,cp,r,y,s)]; else pTechCinp2AOutDef; end)*vTechInp[(t,cp,r,y,s)] for cp in comm if ((if haskey(pTechCinp2AOut, (t,c,cp,r,y,s)); pTechCinp2AOut[(t,c,cp,r,y,s)]; else pTechCinp2AOutDef; end)>0))+sum((if haskey(pTechCout2AOut, (t,c,cp,r,y,s)); pTechCout2AOut[(t,c,cp,r,y,s)]; else pTechCout2AOutDef; end)*vTechOut[(t,cp,r,y,s)] for cp in comm if ((if haskey(pTechCout2AOut, (t,c,cp,r,y,s)); pTechCout2AOut[(t,c,cp,r,y,s)]; else pTechCout2AOutDef; end)>0)));
println("eqTechAOut(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAOut(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
@constraint(model, [(t, r, y, s) in meqTechAfLo], (if haskey(pTechAfLo, (t,r,y,s)); pTechAfLo[(t,r,y,s)]; else pTechAfLoDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfLo, (t,r,y,s)); paTechWeatherAfLo[(t,r,y,s)]; else paTechWeatherAfLoDef; end) <=  vTechAct[(t,r,y,s)]);
println("eqTechAfLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
@constraint(model, [(t, r, y, s) in meqTechAfUp], vTechAct[(t,r,y,s)] <=  (if haskey(pTechAfUp, (t,r,y,s)); pTechAfUp[(t,r,y,s)]; else pTechAfUpDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfUp, (t,r,y,s)); paTechWeatherAfUp[(t,r,y,s)]; else paTechWeatherAfUpDef; end));
println("eqTechAfUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
@constraint(model, [(t, r, y, s) in meqTechAfsLo], (if haskey(pTechAfsLo, (t,r,y,s)); pTechAfsLo[(t,r,y,s)]; else pTechAfsLoDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfsLo, (t,r,y,s)); paTechWeatherAfsLo[(t,r,y,s)]; else paTechWeatherAfsLoDef; end) <=  sum((if (t,r,y,sp) in mvTechAct; vTechAct[(t,r,y,sp)]; else 0; end;) for sp in slice if (s,sp) in mSliceParentChildE));
println("eqTechAfsLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfsLo(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
@constraint(model, [(t, r, y, s) in meqTechAfsUp], sum((if (t,r,y,sp) in mvTechAct; vTechAct[(t,r,y,sp)]; else 0; end;) for sp in slice if (s,sp) in mSliceParentChildE) <=  (if haskey(pTechAfsUp, (t,r,y,s)); pTechAfsUp[(t,r,y,s)]; else pTechAfsUpDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfsUp, (t,r,y,s)); paTechWeatherAfsUp[(t,r,y,s)]; else paTechWeatherAfsUpDef; end));
println("eqTechAfsUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfsUp(tech, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
@constraint(model, [(t, c, r, y, s) in meqTechActSng], vTechAct[(t,r,y,s)]  ==  (vTechOut[(t,c,r,y,s)]) / ((if haskey(pTechCact2cout, (t,c,r,y,s)); pTechCact2cout[(t,c,r,y,s)]; else pTechCact2coutDef; end)));
println("eqTechActSng(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechActSng(tech, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
@constraint(model, [(t, g, r, y, s) in meqTechActGrp], vTechAct[(t,r,y,s)]  ==  sum((if (t,c,r,y,s) in mvTechOut; ((vTechOut[(t,c,r,y,s)]) / ((if haskey(pTechCact2cout, (t,c,r,y,s)); pTechCact2cout[(t,c,r,y,s)]; else pTechCact2coutDef; end))); else 0; end;) for c in comm if (t,g,c) in mTechGroupComm));
println("eqTechActGrp(tech, group, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechActGrp(tech, group, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
@constraint(model, [(t, r, c, y, s) in meqTechAfcOutLo], (if haskey(pTechCact2cout, (t,c,r,y,s)); pTechCact2cout[(t,c,r,y,s)]; else pTechCact2coutDef; end)*(if haskey(pTechAfcLo, (t,c,r,y,s)); pTechAfcLo[(t,c,r,y,s)]; else pTechAfcLoDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfcLo, (t,c,r,y,s)); paTechWeatherAfcLo[(t,c,r,y,s)]; else paTechWeatherAfcLoDef; end) <=  vTechOut[(t,c,r,y,s)]);
println("eqTechAfcOutLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfcOutLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
@constraint(model, [(t, r, c, y, s) in meqTechAfcOutUp], vTechOut[(t,c,r,y,s)] <=  (if haskey(pTechCact2cout, (t,c,r,y,s)); pTechCact2cout[(t,c,r,y,s)]; else pTechCact2coutDef; end)*(if haskey(pTechAfcUp, (t,c,r,y,s)); pTechAfcUp[(t,c,r,y,s)]; else pTechAfcUpDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfcUp, (t,c,r,y,s)); paTechWeatherAfcUp[(t,c,r,y,s)]; else paTechWeatherAfcUpDef; end));
println("eqTechAfcOutUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfcOutUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
@constraint(model, [(t, r, c, y, s) in meqTechAfcInpLo], (if haskey(pTechAfcLo, (t,c,r,y,s)); pTechAfcLo[(t,c,r,y,s)]; else pTechAfcLoDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfcLo, (t,c,r,y,s)); paTechWeatherAfcLo[(t,c,r,y,s)]; else paTechWeatherAfcLoDef; end) <=  vTechInp[(t,c,r,y,s)]);
println("eqTechAfcInpLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfcInpLo(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
@constraint(model, [(t, r, c, y, s) in meqTechAfcInpUp], vTechInp[(t,c,r,y,s)] <=  (if haskey(pTechAfcUp, (t,c,r,y,s)); pTechAfcUp[(t,c,r,y,s)]; else pTechAfcUpDef; end)*(if haskey(pTechCap2act, (t)); pTechCap2act[(t)]; else pTechCap2actDef; end)*vTechCap[(t,r,y)]*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paTechWeatherAfcUp, (t,c,r,y,s)); paTechWeatherAfcUp[(t,c,r,y,s)]; else paTechWeatherAfcUpDef; end));
println("eqTechAfcInpUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechAfcInpUp(tech, region, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
@constraint(model, [(t, r, y) in mTechSpan], vTechCap[(t,r,y)]  ==  (if haskey(pTechStock, (t,r,y)); pTechStock[(t,r,y)]; else pTechStockDef; end)+sum(vTechNewCap[(t,r,yp)]-sum(vTechRetiredCap[(t,r,yp,ye)] for ye in year if ((t,r,yp,ye) in mvTechRetiredCap && ordYear[(y)] >= ordYear[(ye)])) for yp in year if ((t,r,yp) in mTechNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTechOlife, (t,r)); pTechOlife[(t,r)]; else pTechOlifeDef; end)+ordYear[(yp)] || (t,r) in mTechOlifeInf))));
println("eqTechCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechNewCap(tech, region, year)$meqTechNewCap(tech, region, year)
@constraint(model, [(t, r, y) in meqTechNewCap], sum(vTechRetiredCap[(t,r,y,yp)] for yp in year if (t,r,y,yp) in mvTechRetiredCap) <=  vTechNewCap[(t,r,y)]);
println("eqTechNewCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechNewCap(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
@constraint(model, [(t, r, y) in mTechEac], vTechEac[(t,r,y)]  ==  sum((if haskey(pTechEac, (t,r,yp)); pTechEac[(t,r,yp)]; else pTechEacDef; end)*(vTechNewCap[(t,r,yp)]-sum(vTechRetiredCap[(t,r,yp,ye)] for ye in year if (t,r,yp,ye) in mvTechRetiredCap)) for yp in year if ((t,r,yp) in mTechNew && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTechOlife, (t,r)); pTechOlife[(t,r)]; else pTechOlifeDef; end)+ordYear[(yp)] || (t,r) in mTechOlifeInf))));
println("eqTechEac(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechEac(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechInv(tech, region, year)$mTechNew(tech, region, year)
@constraint(model, [(t, r, y) in mTechNew], vTechInv[(t,r,y)]  ==  (if haskey(pTechInvcost, (t,r,y)); pTechInvcost[(t,r,y)]; else pTechInvcostDef; end)*vTechNewCap[(t,r,y)]);
println("eqTechInv(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechInv(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
@constraint(model, [(t, r, y) in mTechOMCost], vTechOMCost[(t,r,y)]  ==  (if haskey(pTechFixom, (t,r,y)); pTechFixom[(t,r,y)]; else pTechFixomDef; end)*vTechCap[(t,r,y)]+sum((if haskey(pTechVarom, (t,r,y,s)); pTechVarom[(t,r,y,s)]; else pTechVaromDef; end)*vTechAct[(t,r,y,s)]+sum((if haskey(pTechCvarom, (t,c,r,y,s)); pTechCvarom[(t,c,r,y,s)]; else pTechCvaromDef; end)*vTechInp[(t,c,r,y,s)] for c in comm if (t,c) in mTechInpComm)+sum((if haskey(pTechCvarom, (t,c,r,y,s)); pTechCvarom[(t,c,r,y,s)]; else pTechCvaromDef; end)*vTechOut[(t,c,r,y,s)] for c in comm if (t,c) in mTechOutComm)+sum((if haskey(pTechAvarom, (t,c,r,y,s)); pTechAvarom[(t,c,r,y,s)]; else pTechAvaromDef; end)*vTechAOut[(t,c,r,y,s)] for c in comm if (t,c,r,y,s) in mvTechAOut)+sum((if haskey(pTechAvarom, (t,c,r,y,s)); pTechAvarom[(t,c,r,y,s)]; else pTechAvaromDef; end)*vTechAInp[(t,c,r,y,s)] for c in comm if (t,c,r,y,s) in mvTechAInp) for s in slice if (t,s) in mTechSlice));
println("eqTechOMCost(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechOMCost(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
@constraint(model, [(s1, c, r, y, s) in mSupAvaUp], vSupOut[(s1,c,r,y,s)] <=  (if haskey(pSupAvaUp, (s1,c,r,y,s)); pSupAvaUp[(s1,c,r,y,s)]; else pSupAvaUpDef; end)*(if haskey(paSupWeatherUp, (s1,c,r,y,s)); paSupWeatherUp[(s1,c,r,y,s)]; else paSupWeatherUpDef; end));
println("eqSupAvaUp(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupAvaUp(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
@constraint(model, [(s1, c, r, y, s) in meqSupAvaLo], vSupOut[(s1,c,r,y,s)]  >=  (if haskey(pSupAvaLo, (s1,c,r,y,s)); pSupAvaLo[(s1,c,r,y,s)]; else pSupAvaLoDef; end)*(if haskey(paSupWeatherLo, (s1,c,r,y,s)); paSupWeatherLo[(s1,c,r,y,s)]; else paSupWeatherLoDef; end));
println("eqSupAvaLo(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupAvaLo(sup, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
@constraint(model, [(s1, c, r) in mvSupReserve], vSupReserve[(s1,c,r)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vSupOut[(s1,c,r,y,s)] for y in year for s in slice if ((s1,c,r,y,s) in mSupAva && y in mMidMilestone)));
println("eqSupTotal(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupTotal(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
@constraint(model, [(s1, c, r) in mSupReserveUp], (if haskey(pSupReserveUp, (s1,c,r)); pSupReserveUp[(s1,c,r)]; else pSupReserveUpDef; end)  >=  vSupReserve[(s1,c,r)]);
println("eqSupReserveUp(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupReserveUp(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
@constraint(model, [(s1, c, r) in meqSupReserveLo], vSupReserve[(s1,c,r)]  >=  (if haskey(pSupReserveLo, (s1,c,r)); pSupReserveLo[(s1,c,r)]; else pSupReserveLoDef; end));
println("eqSupReserveLo(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupReserveLo(sup, comm, region) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
@constraint(model, [(s1, r, y) in mvSupCost], vSupCost[(s1,r,y)]  ==  sum((if haskey(pSupCost, (s1,c,r,y,s)); pSupCost[(s1,c,r,y,s)]; else pSupCostDef; end)*vSupOut[(s1,c,r,y,s)] for c in comm for s in slice if (s1,c,r,y,s) in mSupAva));
println("eqSupCost(sup, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupCost(sup, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvDemInp], vDemInp[(c,r,y,s)]  ==  sum((if haskey(pDemand, (d,c,r,y,s)); pDemand[(d,c,r,y,s)]; else pDemandDef; end) for d in dem if (d,c) in mDemComm));
println("eqDemInp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqDemInp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mAggOut], vAggOut[(c,r,y,s)]  ==  sum((if haskey(pAggregateFactor, (c,cp)); pAggregateFactor[(c,cp)]; else pAggregateFactorDef; end)*sum(vOutTot[(cp,r,y,sp)] for sp in slice if ((cp,r,y,sp) in mvBalance && (s,sp) in mSliceParentChildE && (cp,sp) in mCommSlice)) for cp in comm if (c,cp) in mAggregateFactor));
println("eqAggOut(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqAggOut(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mEmsFuelTot], vEmsFuelTot[(c,r,y,s)]  ==  sum((if haskey(pEmissionFactor, (c,cp)); pEmissionFactor[(c,cp)]; else pEmissionFactorDef; end)*sum((if haskey(pTechEmisComm, (t,cp)); pTechEmisComm[(t,cp)]; else pTechEmisCommDef; end)*sum((if (t,c,cp,r,y,sp) in mTechEmsFuel; vTechInp[(t,cp,r,y,sp)]; else 0; end;) for sp in slice if (c,s,sp) in mCommSliceOrParent) for t in tech if (t,cp) in mTechInpComm) for cp in comm if ((if haskey(pEmissionFactor, (c,cp)); pEmissionFactor[(c,cp)]; else pEmissionFactorDef; end)>0)));
println("eqEmsFuelTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqEmsFuelTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in mvStorageAInp], vStorageAInp[(st1,c,r,y,s)]  ==  sum((if haskey(pStorageStg2AInp, (st1,c,r,y,s)); pStorageStg2AInp[(st1,c,r,y,s)]; else pStorageStg2AInpDef; end)*vStorageStore[(st1,cp,r,y,s)]+(if haskey(pStorageInp2AInp, (st1,c,r,y,s)); pStorageInp2AInp[(st1,c,r,y,s)]; else pStorageInp2AInpDef; end)*vStorageInp[(st1,cp,r,y,s)]+(if haskey(pStorageOut2AInp, (st1,c,r,y,s)); pStorageOut2AInp[(st1,c,r,y,s)]; else pStorageOut2AInpDef; end)*vStorageOut[(st1,cp,r,y,s)]+(if haskey(pStorageCap2AInp, (st1,c,r,y,s)); pStorageCap2AInp[(st1,c,r,y,s)]; else pStorageCap2AInpDef; end)*vStorageCap[(st1,r,y)]+(if (st1,r,y) in mStorageNew; ((if haskey(pStorageNCap2AInp, (st1,c,r,y,s)); pStorageNCap2AInp[(st1,c,r,y,s)]; else pStorageNCap2AInpDef; end)*vStorageNewCap[(st1,r,y)]); else 0; end;) for cp in comm if (st1,cp) in mStorageComm));
println("eqStorageAInp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageAInp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in mvStorageAOut], vStorageAOut[(st1,c,r,y,s)]  ==  sum((if haskey(pStorageStg2AOut, (st1,c,r,y,s)); pStorageStg2AOut[(st1,c,r,y,s)]; else pStorageStg2AOutDef; end)*vStorageStore[(st1,cp,r,y,s)]+(if haskey(pStorageInp2AOut, (st1,c,r,y,s)); pStorageInp2AOut[(st1,c,r,y,s)]; else pStorageInp2AOutDef; end)*vStorageInp[(st1,cp,r,y,s)]+(if haskey(pStorageOut2AOut, (st1,c,r,y,s)); pStorageOut2AOut[(st1,c,r,y,s)]; else pStorageOut2AOutDef; end)*vStorageOut[(st1,cp,r,y,s)]+(if haskey(pStorageCap2AOut, (st1,c,r,y,s)); pStorageCap2AOut[(st1,c,r,y,s)]; else pStorageCap2AOutDef; end)*vStorageCap[(st1,r,y)]+(if (st1,r,y) in mStorageNew; ((if haskey(pStorageNCap2AOut, (st1,c,r,y,s)); pStorageNCap2AOut[(st1,c,r,y,s)]; else pStorageNCap2AOutDef; end)*vStorageNewCap[(st1,r,y)]); else 0; end;) for cp in comm if (st1,cp) in mStorageComm));
println("eqStorageAOut(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageAOut(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in mvStorageStore], vStorageStore[(st1,c,r,y,s)]  ==  (if haskey(pStorageCharge, (st1,c,r,y,s)); pStorageCharge[(st1,c,r,y,s)]; else pStorageChargeDef; end)+(if (st1,r,y) in mStorageNew; ((if haskey(pStorageNCap2Stg, (st1,c,r,y,s)); pStorageNCap2Stg[(st1,c,r,y,s)]; else pStorageNCap2StgDef; end)*vStorageNewCap[(st1,r,y)]); else 0; end;)+sum((if haskey(pStorageInpEff, (st1,c,r,y,sp)); pStorageInpEff[(st1,c,r,y,sp)]; else pStorageInpEffDef; end)*vStorageInp[(st1,c,r,y,sp)]+(((if haskey(pStorageStgEff, (st1,c,r,y,s)); pStorageStgEff[(st1,c,r,y,s)]; else pStorageStgEffDef; end))^((if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)))*vStorageStore[(st1,c,r,y,sp)]-(vStorageOut[(st1,c,r,y,sp)]) / ((if haskey(pStorageOutEff, (st1,c,r,y,sp)); pStorageOutEff[(st1,c,r,y,sp)]; else pStorageOutEffDef; end)) for sp in slice if ((c,sp) in mCommSlice && ((not((st1 in mStorageFullYear)) && (sp,s) in mSliceNext) || (st1 in mStorageFullYear && (sp,s) in mSliceFYearNext)))));
println("eqStorageStore(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageStore(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageAfLo], vStorageStore[(st1,c,r,y,s)]  >=  (if haskey(pStorageAfLo, (st1,r,y,s)); pStorageAfLo[(st1,r,y,s)]; else pStorageAfLoDef; end)*(if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(paStorageWeatherAfLo, (st1,c,r,y,s)); paStorageWeatherAfLo[(st1,c,r,y,s)]; else paStorageWeatherAfLoDef; end));
println("eqStorageAfLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageAfLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageAfUp], vStorageStore[(st1,c,r,y,s)] <=  (if haskey(pStorageAfUp, (st1,r,y,s)); pStorageAfUp[(st1,r,y,s)]; else pStorageAfUpDef; end)*(if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(paStorageWeatherAfUp, (st1,c,r,y,s)); paStorageWeatherAfUp[(st1,c,r,y,s)]; else paStorageWeatherAfUpDef; end));
println("eqStorageAfUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageAfUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in mvStorageStore], (vStorageOut[(st1,c,r,y,s)]) / ((if haskey(pStorageOutEff, (st1,c,r,y,s)); pStorageOutEff[(st1,c,r,y,s)]; else pStorageOutEffDef; end)) <=  vStorageStore[(st1,c,r,y,s)]);
println("eqStorageClean(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageClean(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageInpUp], vStorageInp[(st1,c,r,y,s)] <=  (if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(pStorageCinpUp, (st1,c,r,y,s)); pStorageCinpUp[(st1,c,r,y,s)]; else pStorageCinpUpDef; end)*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paStorageWeatherCinpUp, (st1,c,r,y,s)); paStorageWeatherCinpUp[(st1,c,r,y,s)]; else paStorageWeatherCinpUpDef; end));
println("eqStorageInpUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageInpUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageInpLo], vStorageInp[(st1,c,r,y,s)]  >=  (if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(pStorageCinpLo, (st1,c,r,y,s)); pStorageCinpLo[(st1,c,r,y,s)]; else pStorageCinpLoDef; end)*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paStorageWeatherCinpLo, (st1,c,r,y,s)); paStorageWeatherCinpLo[(st1,c,r,y,s)]; else paStorageWeatherCinpLoDef; end));
println("eqStorageInpLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageInpLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageOutUp], vStorageOut[(st1,c,r,y,s)] <=  (if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(pStorageCoutUp, (st1,c,r,y,s)); pStorageCoutUp[(st1,c,r,y,s)]; else pStorageCoutUpDef; end)*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paStorageWeatherCoutUp, (st1,c,r,y,s)); paStorageWeatherCoutUp[(st1,c,r,y,s)]; else paStorageWeatherCoutUpDef; end));
println("eqStorageOutUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageOutUp(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
@constraint(model, [(st1, c, r, y, s) in meqStorageOutLo], vStorageOut[(st1,c,r,y,s)]  >=  (if haskey(pStorageCap2stg, (st1)); pStorageCap2stg[(st1)]; else pStorageCap2stgDef; end)*vStorageCap[(st1,r,y)]*(if haskey(pStorageCoutLo, (st1,c,r,y,s)); pStorageCoutLo[(st1,c,r,y,s)]; else pStorageCoutLoDef; end)*(if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(paStorageWeatherCoutLo, (st1,c,r,y,s)); paStorageWeatherCoutLo[(st1,c,r,y,s)]; else paStorageWeatherCoutLoDef; end));
println("eqStorageOutLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageOutLo(stg, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
@constraint(model, [(st1, r, y) in mStorageSpan], vStorageCap[(st1,r,y)]  ==  (if haskey(pStorageStock, (st1,r,y)); pStorageStock[(st1,r,y)]; else pStorageStockDef; end)+sum(vStorageNewCap[(st1,r,yp)] for yp in year if (ordYear[(y)] >= ordYear[(yp)] && ((st1,r) in mStorageOlifeInf || ordYear[(y)]<(if haskey(pStorageOlife, (st1,r)); pStorageOlife[(st1,r)]; else pStorageOlifeDef; end)+ordYear[(yp)]) && (st1,r,yp) in mStorageNew)));
println("eqStorageCap(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageCap(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
@constraint(model, [(st1, r, y) in mStorageNew], vStorageInv[(st1,r,y)]  ==  (if haskey(pStorageInvcost, (st1,r,y)); pStorageInvcost[(st1,r,y)]; else pStorageInvcostDef; end)*vStorageNewCap[(st1,r,y)]);
println("eqStorageInv(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageInv(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
@constraint(model, [(st1, r, y) in mStorageEac], vStorageEac[(st1,r,y)]  ==  sum((if haskey(pStorageEac, (st1,r,yp)); pStorageEac[(st1,r,yp)]; else pStorageEacDef; end)*vStorageNewCap[(st1,r,yp)] for yp in year if ((st1,r,yp) in mStorageNew && ordYear[(y)] >= ordYear[(yp)] && ((st1,r) in mStorageOlifeInf || ordYear[(y)]<(if haskey(pStorageOlife, (st1,r)); pStorageOlife[(st1,r)]; else pStorageOlifeDef; end)+ordYear[(yp)]) && (if haskey(pStorageInvcost, (st1,r,yp)); pStorageInvcost[(st1,r,yp)]; else pStorageInvcostDef; end) != 0)));
println("eqStorageEac(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageEac(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
@constraint(model, [(st1, r, y) in mStorageOMCost], vStorageOMCost[(st1,r,y)]  ==  (if haskey(pStorageFixom, (st1,r,y)); pStorageFixom[(st1,r,y)]; else pStorageFixomDef; end)*vStorageCap[(st1,r,y)]+sum((if haskey(pStorageCostInp, (st1,r,y,s)); pStorageCostInp[(st1,r,y,s)]; else pStorageCostInpDef; end)*vStorageInp[(st1,c,r,y,s)]+(if haskey(pStorageCostOut, (st1,r,y,s)); pStorageCostOut[(st1,r,y,s)]; else pStorageCostOutDef; end)*vStorageOut[(st1,c,r,y,s)]+(if haskey(pStorageCostStore, (st1,r,y,s)); pStorageCostStore[(st1,r,y,s)]; else pStorageCostStoreDef; end)*vStorageStore[(st1,c,r,y,s)] for c in comm for s in slice if ((c,s) in mCommSlice && (st1,c) in mStorageComm)));
println("eqStorageCost(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageCost(stg, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
@constraint(model, [(c, dst, y, s) in mImport], vImport[(c,dst,y,s)]  ==  sum(sum(sum((if (t1,c,src,dst,y,sp) in mvTradeIr; ((if haskey(pTradeIrEff, (t1,src,dst,y,sp)); pTradeIrEff[(t1,src,dst,y,sp)]; else pTradeIrEffDef; end)*vTradeIr[(t1,c,src,dst,y,sp)]); else 0; end;) for src in region if (t1,src,dst) in mTradeRoutes) for t1 in trade if (t1,c) in mTradeComm)+sum((if (i,c,dst,y,sp) in mImportRow; vImportRow[(i,c,dst,y,sp)]; else 0; end;) for i in imp if (i,c) in mImpComm) for sp in slice if (c,s,sp) in mCommSliceOrParent));
println("eqImport(comm, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqImport(comm, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
@constraint(model, [(c, src, y, s) in mExport], vExport[(c,src,y,s)]  ==  sum(sum(sum((if (t1,c,src,dst,y,sp) in mvTradeIr; vTradeIr[(t1,c,src,dst,y,sp)]; else 0; end;) for dst in region if (t1,src,dst) in mTradeRoutes) for t1 in trade if (t1,c) in mTradeComm)+sum((if (e,c,src,y,sp) in mExportRow; vExportRow[(e,c,src,y,sp)]; else 0; end;) for e in expp if (e,c) in mExpComm) for sp in slice if (c,s,sp) in mCommSliceOrParent));
println("eqExport(comm, src, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqExport(comm, src, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
@constraint(model, [(t1, c, src, dst, y, s) in meqTradeFlowUp], vTradeIr[(t1,c,src,dst,y,s)] <=  (if haskey(pTradeIrUp, (t1,src,dst,y,s)); pTradeIrUp[(t1,src,dst,y,s)]; else pTradeIrUpDef; end));
println("eqTradeFlowUp(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeFlowUp(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
@constraint(model, [(t1, c, src, dst, y, s) in meqTradeFlowLo], vTradeIr[(t1,c,src,dst,y,s)]  >=  (if haskey(pTradeIrLo, (t1,src,dst,y,s)); pTradeIrLo[(t1,src,dst,y,s)]; else pTradeIrLoDef; end));
println("eqTradeFlowLo(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeFlowLo(trade, comm, src, dst, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqCostTrade(region, year)$mvTradeCost(region, year)
@constraint(model, [(r, y) in mvTradeCost], vTradeCost[(r,y)]  ==  (if (r,y) in mvTradeRowCost; vTradeRowCost[(r,y)]; else 0; end;)+(if (r,y) in mvTradeIrCost; vTradeIrCost[(r,y)]; else 0; end;));
println("eqCostTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqCostTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
@constraint(model, [(r, y) in mvTradeRowCost], vTradeRowCost[(r,y)]  ==  sum((if haskey(pImportRowPrice, (i,r,y,s)); pImportRowPrice[(i,r,y,s)]; else pImportRowPriceDef; end)*vImportRow[(i,c,r,y,s)] for i in imp for c in comm for s in slice if (i,c,r,y,s) in mImportRow)-sum((if haskey(pExportRowPrice, (e,r,y,s)); pExportRowPrice[(e,r,y,s)]; else pExportRowPriceDef; end)*vExportRow[(e,c,r,y,s)] for e in expp for c in comm for s in slice if (e,c,r,y,s) in mExportRow));
println("eqCostRowTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqCostRowTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
@constraint(model, [(r, y) in mvTradeIrCost], vTradeIrCost[(r,y)]  ==  sum(vTradeEac[(t1,r,y)] for t1 in trade if (t1,r,y) in mTradeEac)+sum(sum(sum((if (t1,c,src,r,y,s) in mvTradeIr; ((((if haskey(pTradeIrCost, (t1,src,r,y,s)); pTradeIrCost[(t1,src,r,y,s)]; else pTradeIrCostDef; end)+(if haskey(pTradeIrMarkup, (t1,src,r,y,s)); pTradeIrMarkup[(t1,src,r,y,s)]; else pTradeIrMarkupDef; end))*vTradeIr[(t1,c,src,r,y,s)])); else 0; end;) for s in slice if (t1,s) in mTradeSlice) for c in comm if (t1,c) in mTradeComm) for t1 in trade for src in region if (t1,src,r) in mTradeRoutes)-sum(sum(sum((if (t1,c,r,dst,y,s) in mvTradeIr; (((if haskey(pTradeIrMarkup, (t1,r,dst,y,s)); pTradeIrMarkup[(t1,r,dst,y,s)]; else pTradeIrMarkupDef; end)*vTradeIr[(t1,c,r,dst,y,s)])); else 0; end;) for s in slice if (t1,s) in mTradeSlice) for c in comm if (t1,c) in mTradeComm) for t1 in trade for dst in region if (t1,r,dst) in mTradeRoutes));
println("eqCostIrTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqCostIrTrade(region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
@constraint(model, [(e, c, r, y, s) in mExportRowUp], vExportRow[(e,c,r,y,s)] <=  (if haskey(pExportRowUp, (e,r,y,s)); pExportRowUp[(e,r,y,s)]; else pExportRowUpDef; end));
println("eqExportRowUp(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqExportRowUp(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
@constraint(model, [(e, c, r, y, s) in meqExportRowLo], vExportRow[(e,c,r,y,s)]  >=  (if haskey(pExportRowLo, (e,r,y,s)); pExportRowLo[(e,r,y,s)]; else pExportRowLoDef; end));
println("eqExportRowLo(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqExportRowLo(expp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
@constraint(model, [(e, c) in mExpComm], vExportRowAccumulated[(e,c)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vExportRow[(e,c,r,y,s)] for r in region for y in year for s in slice if (y in mMidMilestone && (e,c,r,y,s) in mExportRow)));
println("eqExportRowCumulative(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqExportRowCumulative(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))

# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
@constraint(model, [(e, c) in mExportRowAccumulatedUp], vExportRowAccumulated[(e,c)] <=  (if haskey(pExportRowRes, (e)); pExportRowRes[(e)]; else pExportRowResDef; end));
println("eqExportRowResUp(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqExportRowResUp(expp, comm) done ", Dates.format(now(), "HH:MM:SS"))

# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
@constraint(model, [(i, c, r, y, s) in mImportRowUp], vImportRow[(i,c,r,y,s)] <=  (if haskey(pImportRowUp, (i,r,y,s)); pImportRowUp[(i,r,y,s)]; else pImportRowUpDef; end));
println("eqImportRowUp(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqImportRowUp(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
@constraint(model, [(i, c, r, y, s) in meqImportRowLo], vImportRow[(i,c,r,y,s)]  >=  (if haskey(pImportRowLo, (i,r,y,s)); pImportRowLo[(i,r,y,s)]; else pImportRowLoDef; end));
println("eqImportRowLo(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqImportRowLo(imp, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
@constraint(model, [(i, c) in mImpComm], vImportRowAccumulated[(i,c)]  ==  sum((if haskey(pPeriodLen, (y)); pPeriodLen[(y)]; else pPeriodLenDef; end)*vImportRow[(i,c,r,y,s)] for r in region for y in year for s in slice if (i,c,r,y,s) in mImportRow));
println("eqImportRowAccumulated(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqImportRowAccumulated(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))

# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
@constraint(model, [(i, c) in mImportRowAccumulatedUp], vImportRowAccumulated[(i,c)] <=  (if haskey(pImportRowRes, (i)); pImportRowRes[(i)]; else pImportRowResDef; end));
println("eqImportRowResUp(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqImportRowResUp(imp, comm) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
@constraint(model, [(t1, c, y, s) in meqTradeCapFlow], (if haskey(pSliceShare, (s)); pSliceShare[(s)]; else pSliceShareDef; end)*(if haskey(pTradeCap2Act, (t1)); pTradeCap2Act[(t1)]; else pTradeCap2ActDef; end)*vTradeCap[(t1,y)]  >=  sum(vTradeIr[(t1,c,src,dst,y,s)] for src in region for dst in region if (t1,c,src,dst,y,s) in mvTradeIr));
println("eqTradeCapFlow(trade, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeCapFlow(trade, comm, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeCap(trade, year)$mvTradeCap(trade, year)
@constraint(model, [(t1, y) in mvTradeCap], vTradeCap[(t1,y)]  ==  (if haskey(pTradeStock, (t1,y)); pTradeStock[(t1,y)]; else pTradeStockDef; end)+sum(vTradeNewCap[(t1,yp)] for yp in year if ((t1,yp) in mvTradeNewCap && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTradeOlife, (t1)); pTradeOlife[(t1)]; else pTradeOlifeDef; end)+ordYear[(yp)] || t1 in mTradeOlifeInf))));
println("eqTradeCap(trade, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeCap(trade, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
@constraint(model, [(t1, r, y) in mTradeInv], vTradeInv[(t1,r,y)]  ==  (if haskey(pTradeInvcost, (t1,r,y)); pTradeInvcost[(t1,r,y)]; else pTradeInvcostDef; end)*vTradeNewCap[(t1,y)]);
println("eqTradeInv(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeInv(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
@constraint(model, [(t1, r, y) in mTradeEac], vTradeEac[(t1,r,y)]  ==  sum((if haskey(pTradeEac, (t1,r,yp)); pTradeEac[(t1,r,yp)]; else pTradeEacDef; end)*vTradeNewCap[(t1,yp)] for yp in year if ((t1,yp) in mvTradeNewCap && ordYear[(y)] >= ordYear[(yp)] && (ordYear[(y)]<(if haskey(pTradeOlife, (t1)); pTradeOlife[(t1)]; else pTradeOlifeDef; end)+ordYear[(yp)] || t1 in mTradeOlifeInf))));
println("eqTradeEac(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeEac(trade, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
@constraint(model, [(t1, c, r, y, s) in mvTradeIrAInp], vTradeIrAInp[(t1,c,r,y,s)]  ==  sum((if haskey(pTradeIrCsrc2Ainp, (t1,c,r,dst,y,s)); pTradeIrCsrc2Ainp[(t1,c,r,dst,y,s)]; else pTradeIrCsrc2AinpDef; end)*sum(vTradeIr[(t1,cp,r,dst,y,s)] for cp in comm if (t1,cp) in mTradeComm) for dst in region if (t1,r,dst,y,s) in mTradeIr)+sum((if haskey(pTradeIrCdst2Ainp, (t1,c,src,r,y,s)); pTradeIrCdst2Ainp[(t1,c,src,r,y,s)]; else pTradeIrCdst2AinpDef; end)*sum(vTradeIr[(t1,cp,src,r,y,s)] for cp in comm if (t1,cp) in mTradeComm) for src in region if (t1,src,r,y,s) in mTradeIr));
println("eqTradeIrAInp(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeIrAInp(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
@constraint(model, [(t1, c, r, y, s) in mvTradeIrAOut], vTradeIrAOut[(t1,c,r,y,s)]  ==  sum((if haskey(pTradeIrCsrc2Aout, (t1,c,r,dst,y,s)); pTradeIrCsrc2Aout[(t1,c,r,dst,y,s)]; else pTradeIrCsrc2AoutDef; end)*sum(vTradeIr[(t1,cp,r,dst,y,s)] for cp in comm if (t1,cp) in mTradeComm) for dst in region if (t1,r,dst,y,s) in mTradeIr)+sum((if haskey(pTradeIrCdst2Aout, (t1,c,src,r,y,s)); pTradeIrCdst2Aout[(t1,c,src,r,y,s)]; else pTradeIrCdst2AoutDef; end)*sum(vTradeIr[(t1,cp,src,r,y,s)] for cp in comm if (t1,cp) in mTradeComm) for src in region if (t1,src,r,y,s) in mTradeIr));
println("eqTradeIrAOut(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeIrAOut(trade, comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvTradeIrAInpTot], vTradeIrAInpTot[(c,r,y,s)]  ==  sum(vTradeIrAInp[(t1,c,r,y,sp)] for t1 in trade for sp in slice if ((c,s,sp) in mCommSliceOrParent && (t1,c,r,y,sp) in mvTradeIrAInp)));
println("eqTradeIrAInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeIrAInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvTradeIrAOutTot], vTradeIrAOutTot[(c,r,y,s)]  ==  sum(vTradeIrAOut[(t1,c,r,y,sp)] for t1 in trade for sp in slice if ((c,s,sp) in mCommSliceOrParent && (t1,c,r,y,sp) in mvTradeIrAOut)));
println("eqTradeIrAOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTradeIrAOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in meqBalLo], vBalance[(c,r,y,s)]  >=  0);
println("eqBalLo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqBalLo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in meqBalUp], vBalance[(c,r,y,s)] <=  0);
println("eqBalUp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqBalUp(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in meqBalFx], vBalance[(c,r,y,s)]  ==  0);
println("eqBalFx(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqBalFx(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvBalance], vBalance[(c,r,y,s)]  ==  vOutTot[(c,r,y,s)]-vInpTot[(c,r,y,s)]);
println("eqBal(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqBal(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqOutTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvBalance], vOutTot[(c,r,y,s)]  ==  (if (c,r,y,s) in mDummyImport; vDummyImport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mSupOutTot; vSupOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mEmsFuelTot; vEmsFuelTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mAggOut; vAggOut[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mTechOutTot; vTechOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mStorageOutTot; vStorageOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mImport; vImport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mvTradeIrAOutTot; vTradeIrAOutTot[(c,r,y,s)]; else 0; end;)+sum(vOut2Lo[(c,r,y,sp,s)] for sp in slice if ((sp,s) in mSliceParentChild && (c,r,y,sp,s) in mvOut2Lo)));
println("eqOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mOut2Lo], sum(vOut2Lo[(c,r,y,s,sp)] for sp in slice if ((s,sp) in mSliceParentChild && (c,r,y,s,sp) in mvOut2Lo))  ==  (if (c,r,y,s) in mSupOutTot; vSupOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mEmsFuelTot; vEmsFuelTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mAggOut; vAggOut[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mTechOutTot; vTechOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mStorageOutTot; vStorageOutTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mImport; vImport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mvTradeIrAOutTot; vTradeIrAOutTot[(c,r,y,s)]; else 0; end;));
println("eqOut2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqOut2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqInpTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mvBalance], vInpTot[(c,r,y,s)]  ==  (if (c,r,y,s) in mvDemInp; vDemInp[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mDummyExport; vDummyExport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mTechInpTot; vTechInpTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mStorageInpTot; vStorageInpTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mExport; vExport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mvTradeIrAInpTot; vTradeIrAInpTot[(c,r,y,s)]; else 0; end;)+sum(vInp2Lo[(c,r,y,sp,s)] for sp in slice if ((sp,s) in mSliceParentChild && (c,r,y,sp,s) in mvInp2Lo)));
println("eqInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mInp2Lo], sum(vInp2Lo[(c,r,y,s,sp)] for sp in slice if ((s,sp) in mSliceParentChild && (c,r,y,s,sp) in mvInp2Lo))  ==  (if (c,r,y,s) in mTechInpTot; vTechInpTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mStorageInpTot; vStorageInpTot[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mExport; vExport[(c,r,y,s)]; else 0; end;)+(if (c,r,y,s) in mvTradeIrAInpTot; vTradeIrAInpTot[(c,r,y,s)]; else 0; end;));
println("eqInp2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqInp2Lo(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mSupOutTot], vSupOutTot[(c,r,y,s)]  ==  sum(sum((if (s1,c,r,y,sp) in mSupAva; vSupOut[(s1,c,r,y,sp)]; else 0; end;) for sp in slice if (c,s,sp) in mCommSliceOrParent) for s1 in sup if (s1,c) in mSupComm));
println("eqSupOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSupOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mTechInpTot], vTechInpTot[(c,r,y,s)]  ==  sum(sum((if (t,c,r,y,sp) in mvTechInp; vTechInp[(t,c,r,y,sp)]; else 0; end;) for sp in slice if ((t,sp) in mTechSlice && (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechInpComm)+sum(sum((if (t,c,r,y,sp) in mvTechAInp; vTechAInp[(t,c,r,y,sp)]; else 0; end;) for sp in slice if ((t,sp) in mTechSlice && (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechAInp));
println("eqTechInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mTechOutTot], vTechOutTot[(c,r,y,s)]  ==  sum(sum((if (t,c,r,y,sp) in mvTechOut; vTechOut[(t,c,r,y,sp)]; else 0; end;) for sp in slice if ((t,sp) in mTechSlice && (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechOutComm)+sum(sum((if (t,c,r,y,sp) in mvTechAOut; vTechAOut[(t,c,r,y,sp)]; else 0; end;) for sp in slice if ((t,sp) in mTechSlice && (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechAOut));
println("eqTechOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTechOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mStorageInpTot], vStorageInpTot[(c,r,y,s)]  ==  sum(vStorageInp[(st1,c,r,y,s)] for st1 in stg if (st1,c,r,y,s) in mvStorageStore)+sum(vStorageAInp[(st1,c,r,y,s)] for st1 in stg if (st1,c,r,y,s) in mvStorageAInp));
println("eqStorageInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageInpTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
@constraint(model, [(c, r, y, s) in mStorageOutTot], vStorageOutTot[(c,r,y,s)]  ==  sum(vStorageOut[(st1,c,r,y,s)] for st1 in stg if (st1,c,r,y,s) in mvStorageStore)+sum(vStorageAOut[(st1,c,r,y,s)] for st1 in stg if (st1,c,r,y,s) in mvStorageAOut));
println("eqStorageOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqStorageOutTot(comm, region, year, slice) done ", Dates.format(now(), "HH:MM:SS"))

# eqCost(region, year)$mvTotalCost(region, year)
@constraint(model, [(r, y) in mvTotalCost], vTotalCost[(r,y)]  ==  sum(vTechEac[(t,r,y)] for t in tech if (t,r,y) in mTechEac)+sum(vTechOMCost[(t,r,y)] for t in tech if (t,r,y) in mTechOMCost)+sum(vSupCost[(s1,r,y)] for s1 in sup if (s1,r,y) in mvSupCost)+sum((if haskey(pDummyImportCost, (c,r,y,s)); pDummyImportCost[(c,r,y,s)]; else pDummyImportCostDef; end)*vDummyImport[(c,r,y,s)] for c in comm for s in slice if (c,r,y,s) in mDummyImport)+sum((if haskey(pDummyExportCost, (c,r,y,s)); pDummyExportCost[(c,r,y,s)]; else pDummyExportCostDef; end)*vDummyExport[(c,r,y,s)] for c in comm for s in slice if (c,r,y,s) in mDummyExport)+sum(vTaxCost[(c,r,y)] for c in comm if (c,r,y) in mTaxCost)-sum(vSubsCost[(c,r,y)] for c in comm if (c,r,y) in mSubsCost)+sum(vStorageOMCost[(st1,r,y)] for st1 in stg if (st1,r,y) in mStorageOMCost)+sum(vStorageEac[(st1,r,y)] for st1 in stg if (st1,r,y) in mStorageEac)+(if (r,y) in mvTradeCost; vTradeCost[(r,y)]; else 0; end;));
println("eqCost(region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqCost(region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
@constraint(model, [(c, r, y) in mTaxCost], vTaxCost[(c,r,y)]  ==  sum((if haskey(pTaxCost, (c,r,y,s)); pTaxCost[(c,r,y,s)]; else pTaxCostDef; end)*vOutTot[(c,r,y,s)] for s in slice if (c,s) in mCommSlice));
println("eqTaxCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqTaxCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqSubsCost(comm, region, year)$mSubsCost(comm, region, year)
@constraint(model, [(c, r, y) in mSubsCost], vSubsCost[(c,r,y)]  ==  sum((if haskey(pSubsCost, (c,r,y,s)); pSubsCost[(c,r,y,s)]; else pSubsCostDef; end)*vOutTot[(c,r,y,s)] for s in slice if (c,s) in mCommSlice));
println("eqSubsCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqSubsCost(comm, region, year) done ", Dates.format(now(), "HH:MM:SS"))

# eqObjective
@constraint(model, vObjective  ==  sum(vTotalCost[(r,y)]*sum((if haskey(pDiscountFactor, (r,yn)); pDiscountFactor[(r,yn)]; else pDiscountFactorDef; end) for ye in year for yp in year for yn in year if ((y,yp) in mStartMilestone && (y,ye) in mEndMilestone && ordYear[(yn)] >= ordYear[(yp)] && ordYear[(yn)] <= ordYear[(ye)])) for r in region for y in year if (r,y) in mvTotalCost));
println("eqObjective done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqObjective done ", Dates.format(now(), "HH:MM:SS"))

# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
@constraint(model, [(t, r, y) in meqLECActivity], sum(vTechAct[(t,r,y,s)] for s in slice if (t,s) in mTechSlice)  >=  (if haskey(pLECLoACT, (r)); pLECLoACT[(r)]; else pLECLoACTDef; end));
println("eqLECActivity(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))
println(f, "eqLECActivity(tech, region, year) done ", Dates.format(now(), "HH:MM:SS"))

@objective(model, Min, vObjective)
set_optimizer(model, Cbc.Optimizer)
optimize!(model)

# Print solution
fvTechInv = open("output/vTechInv.csv", "w");

println(fvTechInv, "tech,region,year,value");

for (t,r,y) in mTechNew if JuMP.value(vTechInv[(t,r,y)]) != 0
  println(fvTechInv, t, ",", r, ",", y, ",", JuMP.value(vTechInv[(t,r,y)]));
end;
end;


close(fvTechInv);



fvTechEac = open("output/vTechEac.csv", "w");

println(fvTechEac, "tech,region,year,value");

for (t,r,y) in mTechEac if JuMP.value(vTechEac[(t,r,y)]) != 0
  println(fvTechEac, t, ",", r, ",", y, ",", JuMP.value(vTechEac[(t,r,y)]));
end;
end;


close(fvTechEac);



fvTechOMCost = open("output/vTechOMCost.csv", "w");

println(fvTechOMCost, "tech,region,year,value");

for (t,r,y) in mTechOMCost if JuMP.value(vTechOMCost[(t,r,y)]) != 0
  println(fvTechOMCost, t, ",", r, ",", y, ",", JuMP.value(vTechOMCost[(t,r,y)]));
end;
end;


close(fvTechOMCost);



fvSupCost = open("output/vSupCost.csv", "w");

println(fvSupCost, "sup,region,year,value");

for (s1,r,y) in mvSupCost if JuMP.value(vSupCost[(s1,r,y)]) != 0
  println(fvSupCost, s1, ",", r, ",", y, ",", JuMP.value(vSupCost[(s1,r,y)]));
end;
end;


close(fvSupCost);



fvEmsFuelTot = open("output/vEmsFuelTot.csv", "w");

println(fvEmsFuelTot, "comm,region,year,slice,value");

for (c,r,y,s) in mEmsFuelTot if JuMP.value(vEmsFuelTot[(c,r,y,s)]) != 0
  println(fvEmsFuelTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vEmsFuelTot[(c,r,y,s)]));
end;
end;


close(fvEmsFuelTot);



fvBalance = open("output/vBalance.csv", "w");

println(fvBalance, "comm,region,year,slice,value");

for (c,r,y,s) in mvBalance if JuMP.value(vBalance[(c,r,y,s)]) != 0
  println(fvBalance, c, ",", r, ",", y, ",", s, ",", JuMP.value(vBalance[(c,r,y,s)]));
end;
end;


close(fvBalance);



fvTotalCost = open("output/vTotalCost.csv", "w");

println(fvTotalCost, "region,year,value");

for (r,y) in mvTotalCost if JuMP.value(vTotalCost[(r,y)]) != 0
  println(fvTotalCost, r, ",", y, ",", JuMP.value(vTotalCost[(r,y)]));
end;
end;


close(fvTotalCost);



fvObjective = open("output/vObjective.csv", "w");
println(fvObjective, "value");
println(fvObjective, JuMP.value(vObjective));
close(fvObjective);

fvTaxCost = open("output/vTaxCost.csv", "w");

println(fvTaxCost, "comm,region,year,value");

for (c,r,y) in mTaxCost if JuMP.value(vTaxCost[(c,r,y)]) != 0
  println(fvTaxCost, c, ",", r, ",", y, ",", JuMP.value(vTaxCost[(c,r,y)]));
end;
end;


close(fvTaxCost);



fvSubsCost = open("output/vSubsCost.csv", "w");

println(fvSubsCost, "comm,region,year,value");

for (c,r,y) in mSubsCost if JuMP.value(vSubsCost[(c,r,y)]) != 0
  println(fvSubsCost, c, ",", r, ",", y, ",", JuMP.value(vSubsCost[(c,r,y)]));
end;
end;


close(fvSubsCost);



fvAggOut = open("output/vAggOut.csv", "w");

println(fvAggOut, "comm,region,year,slice,value");

for (c,r,y,s) in mAggOut if JuMP.value(vAggOut[(c,r,y,s)]) != 0
  println(fvAggOut, c, ",", r, ",", y, ",", s, ",", JuMP.value(vAggOut[(c,r,y,s)]));
end;
end;


close(fvAggOut);



fvStorageOMCost = open("output/vStorageOMCost.csv", "w");

println(fvStorageOMCost, "stg,region,year,value");

for (st1,r,y) in mStorageOMCost if JuMP.value(vStorageOMCost[(st1,r,y)]) != 0
  println(fvStorageOMCost, st1, ",", r, ",", y, ",", JuMP.value(vStorageOMCost[(st1,r,y)]));
end;
end;


close(fvStorageOMCost);



fvTradeCost = open("output/vTradeCost.csv", "w");

println(fvTradeCost, "region,year,value");

for (r,y) in mvTradeCost if JuMP.value(vTradeCost[(r,y)]) != 0
  println(fvTradeCost, r, ",", y, ",", JuMP.value(vTradeCost[(r,y)]));
end;
end;


close(fvTradeCost);



fvTradeRowCost = open("output/vTradeRowCost.csv", "w");

println(fvTradeRowCost, "region,year,value");

for (r,y) in mvTradeRowCost if JuMP.value(vTradeRowCost[(r,y)]) != 0
  println(fvTradeRowCost, r, ",", y, ",", JuMP.value(vTradeRowCost[(r,y)]));
end;
end;


close(fvTradeRowCost);



fvTradeIrCost = open("output/vTradeIrCost.csv", "w");

println(fvTradeIrCost, "region,year,value");

for (r,y) in mvTradeIrCost if JuMP.value(vTradeIrCost[(r,y)]) != 0
  println(fvTradeIrCost, r, ",", y, ",", JuMP.value(vTradeIrCost[(r,y)]));
end;
end;


close(fvTradeIrCost);



fvTechNewCap = open("output/vTechNewCap.csv", "w");
println(fvTechNewCap, "tech,region,year,value");
for (t,r,y) in mTechNew if JuMP.value(vTechNewCap[(t,r,y)]) != 0
  println(fvTechNewCap, t, ",", r, ",", y, ",", JuMP.value(vTechNewCap[(t,r,y)]));
end;
end;
close(fvTechNewCap);


fvTechRetiredCap = open("output/vTechRetiredCap.csv", "w");
println(fvTechRetiredCap, "tech,region,year,yearp,value");
for (t,r,y,yp) in mvTechRetiredCap if JuMP.value(vTechRetiredCap[(t,r,y,yp)]) != 0
  println(fvTechRetiredCap, t, ",", r, ",", y, ",", yp, ",", JuMP.value(vTechRetiredCap[(t,r,y,yp)]));
end;
end;
close(fvTechRetiredCap);


fvTechCap = open("output/vTechCap.csv", "w");
println(fvTechCap, "tech,region,year,value");
for (t,r,y) in mTechSpan if JuMP.value(vTechCap[(t,r,y)]) != 0
  println(fvTechCap, t, ",", r, ",", y, ",", JuMP.value(vTechCap[(t,r,y)]));
end;
end;
close(fvTechCap);


fvTechAct = open("output/vTechAct.csv", "w");
println(fvTechAct, "tech,region,year,slice,value");
for (t,r,y,s) in mvTechAct if JuMP.value(vTechAct[(t,r,y,s)]) != 0
  println(fvTechAct, t, ",", r, ",", y, ",", s, ",", JuMP.value(vTechAct[(t,r,y,s)]));
end;
end;
close(fvTechAct);


fvTechInp = open("output/vTechInp.csv", "w");
println(fvTechInp, "tech,comm,region,year,slice,value");
for (t,c,r,y,s) in mvTechInp if JuMP.value(vTechInp[(t,c,r,y,s)]) != 0
  println(fvTechInp, t, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechInp[(t,c,r,y,s)]));
end;
end;
close(fvTechInp);


fvTechOut = open("output/vTechOut.csv", "w");
println(fvTechOut, "tech,comm,region,year,slice,value");
for (t,c,r,y,s) in mvTechOut if JuMP.value(vTechOut[(t,c,r,y,s)]) != 0
  println(fvTechOut, t, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechOut[(t,c,r,y,s)]));
end;
end;
close(fvTechOut);


fvTechAInp = open("output/vTechAInp.csv", "w");
println(fvTechAInp, "tech,comm,region,year,slice,value");
for (t,c,r,y,s) in mvTechAInp if JuMP.value(vTechAInp[(t,c,r,y,s)]) != 0
  println(fvTechAInp, t, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechAInp[(t,c,r,y,s)]));
end;
end;
close(fvTechAInp);


fvTechAOut = open("output/vTechAOut.csv", "w");
println(fvTechAOut, "tech,comm,region,year,slice,value");
for (t,c,r,y,s) in mvTechAOut if JuMP.value(vTechAOut[(t,c,r,y,s)]) != 0
  println(fvTechAOut, t, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechAOut[(t,c,r,y,s)]));
end;
end;
close(fvTechAOut);


fvSupOut = open("output/vSupOut.csv", "w");
println(fvSupOut, "sup,comm,region,year,slice,value");
for (s1,c,r,y,s) in mSupAva if JuMP.value(vSupOut[(s1,c,r,y,s)]) != 0
  println(fvSupOut, s1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vSupOut[(s1,c,r,y,s)]));
end;
end;
close(fvSupOut);


fvSupReserve = open("output/vSupReserve.csv", "w");
println(fvSupReserve, "sup,comm,region,value");
for (s1,c,r) in mvSupReserve if JuMP.value(vSupReserve[(s1,c,r)]) != 0
  println(fvSupReserve, s1, ",", c, ",", r, ",", JuMP.value(vSupReserve[(s1,c,r)]));
end;
end;
close(fvSupReserve);


fvDemInp = open("output/vDemInp.csv", "w");
println(fvDemInp, "comm,region,year,slice,value");
for (c,r,y,s) in mvDemInp if JuMP.value(vDemInp[(c,r,y,s)]) != 0
  println(fvDemInp, c, ",", r, ",", y, ",", s, ",", JuMP.value(vDemInp[(c,r,y,s)]));
end;
end;
close(fvDemInp);


fvOutTot = open("output/vOutTot.csv", "w");
println(fvOutTot, "comm,region,year,slice,value");
for (c,r,y,s) in mvBalance if JuMP.value(vOutTot[(c,r,y,s)]) != 0
  println(fvOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vOutTot[(c,r,y,s)]));
end;
end;
close(fvOutTot);


fvInpTot = open("output/vInpTot.csv", "w");
println(fvInpTot, "comm,region,year,slice,value");
for (c,r,y,s) in mvBalance if JuMP.value(vInpTot[(c,r,y,s)]) != 0
  println(fvInpTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vInpTot[(c,r,y,s)]));
end;
end;
close(fvInpTot);


fvInp2Lo = open("output/vInp2Lo.csv", "w");
println(fvInp2Lo, "comm,region,year,slice,slicep,value");
for (c,r,y,s,sp) in mvInp2Lo if JuMP.value(vInp2Lo[(c,r,y,s,sp)]) != 0
  println(fvInp2Lo, c, ",", r, ",", y, ",", s, ",", sp, ",", JuMP.value(vInp2Lo[(c,r,y,s,sp)]));
end;
end;
close(fvInp2Lo);


fvOut2Lo = open("output/vOut2Lo.csv", "w");
println(fvOut2Lo, "comm,region,year,slice,slicep,value");
for (c,r,y,s,sp) in mvOut2Lo if JuMP.value(vOut2Lo[(c,r,y,s,sp)]) != 0
  println(fvOut2Lo, c, ",", r, ",", y, ",", s, ",", sp, ",", JuMP.value(vOut2Lo[(c,r,y,s,sp)]));
end;
end;
close(fvOut2Lo);


fvSupOutTot = open("output/vSupOutTot.csv", "w");
println(fvSupOutTot, "comm,region,year,slice,value");
for (c,r,y,s) in mSupOutTot if JuMP.value(vSupOutTot[(c,r,y,s)]) != 0
  println(fvSupOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vSupOutTot[(c,r,y,s)]));
end;
end;
close(fvSupOutTot);


fvTechInpTot = open("output/vTechInpTot.csv", "w");
println(fvTechInpTot, "comm,region,year,slice,value");
for (c,r,y,s) in mTechInpTot if JuMP.value(vTechInpTot[(c,r,y,s)]) != 0
  println(fvTechInpTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechInpTot[(c,r,y,s)]));
end;
end;
close(fvTechInpTot);


fvTechOutTot = open("output/vTechOutTot.csv", "w");
println(fvTechOutTot, "comm,region,year,slice,value");
for (c,r,y,s) in mTechOutTot if JuMP.value(vTechOutTot[(c,r,y,s)]) != 0
  println(fvTechOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vTechOutTot[(c,r,y,s)]));
end;
end;
close(fvTechOutTot);


fvStorageInpTot = open("output/vStorageInpTot.csv", "w");
println(fvStorageInpTot, "comm,region,year,slice,value");
for (c,r,y,s) in mStorageInpTot if JuMP.value(vStorageInpTot[(c,r,y,s)]) != 0
  println(fvStorageInpTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageInpTot[(c,r,y,s)]));
end;
end;
close(fvStorageInpTot);


fvStorageOutTot = open("output/vStorageOutTot.csv", "w");
println(fvStorageOutTot, "comm,region,year,slice,value");
for (c,r,y,s) in mStorageOutTot if JuMP.value(vStorageOutTot[(c,r,y,s)]) != 0
  println(fvStorageOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageOutTot[(c,r,y,s)]));
end;
end;
close(fvStorageOutTot);


fvStorageAInp = open("output/vStorageAInp.csv", "w");
println(fvStorageAInp, "stg,comm,region,year,slice,value");
for (st1,c,r,y,s) in mvStorageAInp if JuMP.value(vStorageAInp[(st1,c,r,y,s)]) != 0
  println(fvStorageAInp, st1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageAInp[(st1,c,r,y,s)]));
end;
end;
close(fvStorageAInp);


fvStorageAOut = open("output/vStorageAOut.csv", "w");
println(fvStorageAOut, "stg,comm,region,year,slice,value");
for (st1,c,r,y,s) in mvStorageAOut if JuMP.value(vStorageAOut[(st1,c,r,y,s)]) != 0
  println(fvStorageAOut, st1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageAOut[(st1,c,r,y,s)]));
end;
end;
close(fvStorageAOut);


fvDummyImport = open("output/vDummyImport.csv", "w");
println(fvDummyImport, "comm,region,year,slice,value");
for (c,r,y,s) in mDummyImport if JuMP.value(vDummyImport[(c,r,y,s)]) != 0
  println(fvDummyImport, c, ",", r, ",", y, ",", s, ",", JuMP.value(vDummyImport[(c,r,y,s)]));
end;
end;
close(fvDummyImport);


fvDummyExport = open("output/vDummyExport.csv", "w");
println(fvDummyExport, "comm,region,year,slice,value");
for (c,r,y,s) in mDummyExport if JuMP.value(vDummyExport[(c,r,y,s)]) != 0
  println(fvDummyExport, c, ",", r, ",", y, ",", s, ",", JuMP.value(vDummyExport[(c,r,y,s)]));
end;
end;
close(fvDummyExport);


fvStorageInp = open("output/vStorageInp.csv", "w");
println(fvStorageInp, "stg,comm,region,year,slice,value");
for (st1,c,r,y,s) in mvStorageStore if JuMP.value(vStorageInp[(st1,c,r,y,s)]) != 0
  println(fvStorageInp, st1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageInp[(st1,c,r,y,s)]));
end;
end;
close(fvStorageInp);


fvStorageOut = open("output/vStorageOut.csv", "w");
println(fvStorageOut, "stg,comm,region,year,slice,value");
for (st1,c,r,y,s) in mvStorageStore if JuMP.value(vStorageOut[(st1,c,r,y,s)]) != 0
  println(fvStorageOut, st1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageOut[(st1,c,r,y,s)]));
end;
end;
close(fvStorageOut);


fvStorageStore = open("output/vStorageStore.csv", "w");
println(fvStorageStore, "stg,comm,region,year,slice,value");
for (st1,c,r,y,s) in mvStorageStore if JuMP.value(vStorageStore[(st1,c,r,y,s)]) != 0
  println(fvStorageStore, st1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vStorageStore[(st1,c,r,y,s)]));
end;
end;
close(fvStorageStore);


fvStorageInv = open("output/vStorageInv.csv", "w");
println(fvStorageInv, "stg,region,year,value");
for (st1,r,y) in mStorageNew if JuMP.value(vStorageInv[(st1,r,y)]) != 0
  println(fvStorageInv, st1, ",", r, ",", y, ",", JuMP.value(vStorageInv[(st1,r,y)]));
end;
end;
close(fvStorageInv);


fvStorageEac = open("output/vStorageEac.csv", "w");
println(fvStorageEac, "stg,region,year,value");
for (st1,r,y) in mStorageEac if JuMP.value(vStorageEac[(st1,r,y)]) != 0
  println(fvStorageEac, st1, ",", r, ",", y, ",", JuMP.value(vStorageEac[(st1,r,y)]));
end;
end;
close(fvStorageEac);


fvStorageCap = open("output/vStorageCap.csv", "w");
println(fvStorageCap, "stg,region,year,value");
for (st1,r,y) in mStorageSpan if JuMP.value(vStorageCap[(st1,r,y)]) != 0
  println(fvStorageCap, st1, ",", r, ",", y, ",", JuMP.value(vStorageCap[(st1,r,y)]));
end;
end;
close(fvStorageCap);


fvStorageNewCap = open("output/vStorageNewCap.csv", "w");
println(fvStorageNewCap, "stg,region,year,value");
for (st1,r,y) in mStorageNew if JuMP.value(vStorageNewCap[(st1,r,y)]) != 0
  println(fvStorageNewCap, st1, ",", r, ",", y, ",", JuMP.value(vStorageNewCap[(st1,r,y)]));
end;
end;
close(fvStorageNewCap);


fvImport = open("output/vImport.csv", "w");
println(fvImport, "comm,region,year,slice,value");
for (c,r,y,s) in mImport if JuMP.value(vImport[(c,r,y,s)]) != 0
  println(fvImport, c, ",", r, ",", y, ",", s, ",", JuMP.value(vImport[(c,r,y,s)]));
end;
end;
close(fvImport);


fvExport = open("output/vExport.csv", "w");
println(fvExport, "comm,region,year,slice,value");
for (c,r,y,s) in mExport if JuMP.value(vExport[(c,r,y,s)]) != 0
  println(fvExport, c, ",", r, ",", y, ",", s, ",", JuMP.value(vExport[(c,r,y,s)]));
end;
end;
close(fvExport);


fvTradeIr = open("output/vTradeIr.csv", "w");
println(fvTradeIr, "trade,comm,region,regionp,year,slice,value");
for (t1,c,r,rp,y,s) in mvTradeIr if JuMP.value(vTradeIr[(t1,c,r,rp,y,s)]) != 0
  println(fvTradeIr, t1, ",", c, ",", r, ",", rp, ",", y, ",", s, ",", JuMP.value(vTradeIr[(t1,c,r,rp,y,s)]));
end;
end;
close(fvTradeIr);


fvTradeIrAInp = open("output/vTradeIrAInp.csv", "w");
println(fvTradeIrAInp, "trade,comm,region,year,slice,value");
for (t1,c,r,y,s) in mvTradeIrAInp if JuMP.value(vTradeIrAInp[(t1,c,r,y,s)]) != 0
  println(fvTradeIrAInp, t1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTradeIrAInp[(t1,c,r,y,s)]));
end;
end;
close(fvTradeIrAInp);


fvTradeIrAInpTot = open("output/vTradeIrAInpTot.csv", "w");
println(fvTradeIrAInpTot, "comm,region,year,slice,value");
for (c,r,y,s) in mvTradeIrAInpTot if JuMP.value(vTradeIrAInpTot[(c,r,y,s)]) != 0
  println(fvTradeIrAInpTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vTradeIrAInpTot[(c,r,y,s)]));
end;
end;
close(fvTradeIrAInpTot);


fvTradeIrAOut = open("output/vTradeIrAOut.csv", "w");
println(fvTradeIrAOut, "trade,comm,region,year,slice,value");
for (t1,c,r,y,s) in mvTradeIrAOut if JuMP.value(vTradeIrAOut[(t1,c,r,y,s)]) != 0
  println(fvTradeIrAOut, t1, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vTradeIrAOut[(t1,c,r,y,s)]));
end;
end;
close(fvTradeIrAOut);


fvTradeIrAOutTot = open("output/vTradeIrAOutTot.csv", "w");
println(fvTradeIrAOutTot, "comm,region,year,slice,value");
for (c,r,y,s) in mvTradeIrAOutTot if JuMP.value(vTradeIrAOutTot[(c,r,y,s)]) != 0
  println(fvTradeIrAOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vTradeIrAOutTot[(c,r,y,s)]));
end;
end;
close(fvTradeIrAOutTot);


fvExportRowAccumulated = open("output/vExportRowAccumulated.csv", "w");
println(fvExportRowAccumulated, "expp,comm,value");
for (e,c) in mExpComm if JuMP.value(vExportRowAccumulated[(e,c)]) != 0
  println(fvExportRowAccumulated, e, ",", c, ",", JuMP.value(vExportRowAccumulated[(e,c)]));
end;
end;
close(fvExportRowAccumulated);


fvExportRow = open("output/vExportRow.csv", "w");
println(fvExportRow, "expp,comm,region,year,slice,value");
for (e,c,r,y,s) in mExportRow if JuMP.value(vExportRow[(e,c,r,y,s)]) != 0
  println(fvExportRow, e, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vExportRow[(e,c,r,y,s)]));
end;
end;
close(fvExportRow);


fvImportRowAccumulated = open("output/vImportRowAccumulated.csv", "w");
println(fvImportRowAccumulated, "imp,comm,value");
for (i,c) in mImpComm if JuMP.value(vImportRowAccumulated[(i,c)]) != 0
  println(fvImportRowAccumulated, i, ",", c, ",", JuMP.value(vImportRowAccumulated[(i,c)]));
end;
end;
close(fvImportRowAccumulated);


fvImportRow = open("output/vImportRow.csv", "w");
println(fvImportRow, "imp,comm,region,year,slice,value");
for (i,c,r,y,s) in mImportRow if JuMP.value(vImportRow[(i,c,r,y,s)]) != 0
  println(fvImportRow, i, ",", c, ",", r, ",", y, ",", s, ",", JuMP.value(vImportRow[(i,c,r,y,s)]));
end;
end;
close(fvImportRow);


fvTradeCap = open("output/vTradeCap.csv", "w");
println(fvTradeCap, "trade,year,value");
for (t1,y) in mvTradeCap if JuMP.value(vTradeCap[(t1,y)]) != 0
  println(fvTradeCap, t1, ",", y, ",", JuMP.value(vTradeCap[(t1,y)]));
end;
end;
close(fvTradeCap);


fvTradeInv = open("output/vTradeInv.csv", "w");
println(fvTradeInv, "trade,region,year,value");
for (t1,r,y) in mTradeEac if JuMP.value(vTradeInv[(t1,r,y)]) != 0
  println(fvTradeInv, t1, ",", r, ",", y, ",", JuMP.value(vTradeInv[(t1,r,y)]));
end;
end;
close(fvTradeInv);


fvTradeEac = open("output/vTradeEac.csv", "w");
println(fvTradeEac, "trade,region,year,value");
for (t1,r,y) in mTradeEac if JuMP.value(vTradeEac[(t1,r,y)]) != 0
  println(fvTradeEac, t1, ",", r, ",", y, ",", JuMP.value(vTradeEac[(t1,r,y)]));
end;
end;
close(fvTradeEac);


fvTradeNewCap = open("output/vTradeNewCap.csv", "w");
println(fvTradeNewCap, "trade,year,value");
for (t1,y) in mvTradeNewCap if JuMP.value(vTradeNewCap[(t1,y)]) != 0
  println(fvTradeNewCap, t1, ",", y, ",", JuMP.value(vTradeNewCap[(t1,y)]));
end;
end;
close(fvTradeNewCap);


vrb_list = open("output/vrb_list.csv", "w");
println(vrb_list, "value");
println(vrb_list, "vTechInv");
println(vrb_list, "vTechEac");
println(vrb_list, "vTechOMCost");
println(vrb_list, "vSupCost");
println(vrb_list, "vEmsFuelTot");
println(vrb_list, "vBalance");
println(vrb_list, "vTotalCost");
println(vrb_list, "vObjective");
println(vrb_list, "vTaxCost");
println(vrb_list, "vSubsCost");
println(vrb_list, "vAggOut");
println(vrb_list, "vStorageOMCost");
println(vrb_list, "vTradeCost");
println(vrb_list, "vTradeRowCost");
println(vrb_list, "vTradeIrCost");
println(vrb_list, "vTechNewCap");
println(vrb_list, "vTechRetiredCap");
println(vrb_list, "vTechCap");
println(vrb_list, "vTechAct");
println(vrb_list, "vTechInp");
println(vrb_list, "vTechOut");
println(vrb_list, "vTechAInp");
println(vrb_list, "vTechAOut");
println(vrb_list, "vSupOut");
println(vrb_list, "vSupReserve");
println(vrb_list, "vDemInp");
println(vrb_list, "vOutTot");
println(vrb_list, "vInpTot");
println(vrb_list, "vInp2Lo");
println(vrb_list, "vOut2Lo");
println(vrb_list, "vSupOutTot");
println(vrb_list, "vTechInpTot");
println(vrb_list, "vTechOutTot");
println(vrb_list, "vStorageInpTot");
println(vrb_list, "vStorageOutTot");
println(vrb_list, "vStorageAInp");
println(vrb_list, "vStorageAOut");
println(vrb_list, "vDummyImport");
println(vrb_list, "vDummyExport");
println(vrb_list, "vStorageInp");
println(vrb_list, "vStorageOut");
println(vrb_list, "vStorageStore");
println(vrb_list, "vStorageInv");
println(vrb_list, "vStorageEac");
println(vrb_list, "vStorageCap");
println(vrb_list, "vStorageNewCap");
println(vrb_list, "vImport");
println(vrb_list, "vExport");
println(vrb_list, "vTradeIr");
println(vrb_list, "vTradeIrAInp");
println(vrb_list, "vTradeIrAInpTot");
println(vrb_list, "vTradeIrAOut");
println(vrb_list, "vTradeIrAOutTot");
println(vrb_list, "vExportRowAccumulated");
println(vrb_list, "vExportRow");
println(vrb_list, "vImportRowAccumulated");
println(vrb_list, "vImportRow");
println(vrb_list, "vTradeCap");
println(vrb_list, "vTradeInv");
println(vrb_list, "vTradeEac");
println(vrb_list, "vTradeNewCap");

close(vrb_list);
pstat = open("output/pStat.csv", "w");
println(pstat, "value\n1");
close(pstat);
pfinish = open("output/pStat.csv", "w");
println(pfinish, "value\n2");
close(pfinish);
