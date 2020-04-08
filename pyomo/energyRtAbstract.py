import datetime
print("start time: " + str(datetime.datetime.now()) + "\n")
flog = open('output/log.csv', 'w')
flog.write('parameter,value,time\n')
flog.write('"model language",PyomoConcrete,"' + str(datetime.datetime.now()) + '"\n')
# Import
import time
seconds = time.time()
from pyomo.environ import *
from pyomo.opt import SolverFactory
import pyomo.environ as pyo
model = AbstractModel()
exec(open("inc1.py").read())
##### decl par #####
model.vTechInv = Var(model.mTechNew, doc = "Overnight investment costs");
model.vTechEac = Var(model.mTechEac, doc = "Annualized investment costs");
model.vTechOMCost = Var(model.mTechOMCost, doc = "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)");
model.vSupCost = Var(model.mvSupCost, doc = "Supply costs");
model.vEmsFuelTot = Var(model.mEmsFuelTot, doc = "Total fuel emissions");
model.vBalance = Var(model.mvBalance, doc = "Net commodity balance");
model.vTotalCost = Var(model.mvTotalCost, doc = "Regional annual total costs");
model.vObjective = Var(doc = "Objective costs");
model.vTaxCost = Var(model.mTaxCost, doc = "Total tax levies (tax costs)");
model.vSubsCost = Var(model.mSubsCost, doc = "Total subsidies (for substraction from costs)");
model.vAggOut = Var(model.mAggOut, doc = "Aggregated commodity output");
model.vStorageOMCost = Var(model.mStorageOMCost, doc = "Storage O&M costs");
model.vTradeCost = Var(model.mvTradeCost, doc = "Total trade costs");
model.vTradeRowCost = Var(model.mvTradeRowCost, doc = "Trade with ROW costs");
model.vTradeIrCost = Var(model.mvTradeIrCost, doc = "Interregional trade costs");
model.vTechNewCap = Var(model.mTechNew, domain = pyo.NonNegativeReals, doc = "New capacity");
model.vTechRetiredCap = Var(model.mvTechRetiredCap, domain = pyo.NonNegativeReals, doc = "Early retired capacity");
model.vTechCap = Var(model.mTechSpan, domain = pyo.NonNegativeReals, doc = "Total capacity of the technology");
model.vTechAct = Var(model.mvTechAct, domain = pyo.NonNegativeReals, doc = "Activity level of technology");
model.vTechInp = Var(model.mvTechInp, domain = pyo.NonNegativeReals, doc = "Input level");
model.vTechOut = Var(model.mvTechOut, domain = pyo.NonNegativeReals, doc = "Output level");
model.vTechAInp = Var(model.mvTechAInp, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity input");
model.vTechAOut = Var(model.mvTechAOut, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity output");
model.vSupOut = Var(model.mSupAva, domain = pyo.NonNegativeReals, doc = "Output of supply");
model.vSupReserve = Var(model.mvSupReserve, domain = pyo.NonNegativeReals, doc = "Total supply reserve");
model.vDemInp = Var(model.mvDemInp, domain = pyo.NonNegativeReals, doc = "Input to demand");
model.vOutTot = Var(model.mvBalance, domain = pyo.NonNegativeReals, doc = "Total commodity output (consumption is not counted)");
model.vInpTot = Var(model.mvBalance, domain = pyo.NonNegativeReals, doc = "Total commodity input");
model.vInp2Lo = Var(model.mvInp2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for input parent to (grand)child");
model.vOut2Lo = Var(model.mvOut2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for output parent to (grand)child");
model.vSupOutTot = Var(model.mSupOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity supply");
model.vTechInpTot = Var(model.mTechInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to technologies");
model.vTechOutTot = Var(model.mTechOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from technologies");
model.vStorageInpTot = Var(model.mStorageInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to storages");
model.vStorageOutTot = Var(model.mStorageOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from storages");
model.vStorageAInp = Var(model.mvStorageAInp, domain = pyo.NonNegativeReals, doc = "Aux-commodity input to storage");
model.vStorageAOut = Var(model.mvStorageAOut, domain = pyo.NonNegativeReals, doc = "Aux-commodity input from storage");
model.vDummyImport = Var(model.mDummyImport, domain = pyo.NonNegativeReals, doc = "Dummy import (for debugging)");
model.vDummyExport = Var(model.mDummyExport, domain = pyo.NonNegativeReals, doc = "Dummy export (for debugging)");
model.vStorageInp = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage input");
model.vStorageOut = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage output");
model.vStorageStore = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage accumulated level");
model.vStorageInv = Var(model.mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage technology investments");
model.vStorageEac = Var(model.mStorageEac, domain = pyo.NonNegativeReals, doc = "Storage technology EAC investments");
model.vStorageCap = Var(model.mStorageSpan, domain = pyo.NonNegativeReals, doc = "Storage capacity");
model.vStorageNewCap = Var(model.mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage new capacity");
model.vImport = Var(model.mImport, domain = pyo.NonNegativeReals, doc = "Total regional import (Ir + ROW)");
model.vExport = Var(model.mExport, domain = pyo.NonNegativeReals, doc = "Total regional export (Ir + ROW)");
model.vTradeIr = Var(model.mvTradeIr, domain = pyo.NonNegativeReals, doc = "Total physical trade flows between regions");
model.vTradeIrAInp = Var(model.mvTradeIrAInp, domain = pyo.NonNegativeReals, doc = "Trade auxilari input");
model.vTradeIrAInpTot = Var(model.mvTradeIrAInpTot, domain = pyo.NonNegativeReals, doc = "Trade total auxilari input");
model.vTradeIrAOut = Var(model.mvTradeIrAOut, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vTradeIrAOutTot = Var(model.mvTradeIrAOutTot, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vExportRowAccumulated = Var(model.mExpComm, domain = pyo.NonNegativeReals, doc = "Accumulated export to ROW");
model.vExportRow = Var(model.mExportRow, domain = pyo.NonNegativeReals, doc = "Export to ROW");
model.vImportRowAccumulated = Var(model.mImpComm, domain = pyo.NonNegativeReals, doc = "Accumulated import from ROW");
model.vImportRow = Var(model.mImportRow, domain = pyo.NonNegativeReals, doc = "Import from ROW");
model.vTradeCap = Var(model.mTradeSpan, domain = pyo.NonNegativeReals, doc = "");
model.vTradeInv = Var(model.mTradeEac, domain = pyo.NonNegativeReals, doc = "");
model.vTradeEac = Var(model.mTradeEac, domain = pyo.NonNegativeReals, doc = "");
model.vTradeNewCap = Var(model.mTradeNew, domain = pyo.NonNegativeReals, doc = "");
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
model.eqTechSng2Sng = Constraint(model.meqTechSng2Sng, rule = lambda model, t, r, c, cp, y, s : model.vTechInp[t,c,r,y,s]*model.pTechCinp2use[t,c,r,y,s]  ==  (model.vTechOut[t,cp,r,y,s]) / (model.pTechUse2cact[t,cp,r,y,s]*model.pTechCact2cout[t,cp,r,y,s]));
# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
model.eqTechGrp2Sng = Constraint(model.meqTechGrp2Sng, rule = lambda model, t, r, g, cp, y, s : model.pTechGinp2use[t,g,r,y,s]*sum(((model.vTechInp[t,c,r,y,s]*model.pTechCinp2ginp[t,c,r,y,s]) if (t,c,r,y,s) in model.mvTechInp else 0) for c in model.comm if (t,g,c) in model.mTechGroupComm)  ==  (model.vTechOut[t,cp,r,y,s]) / (model.pTechUse2cact[t,cp,r,y,s]*model.pTechCact2cout[t,cp,r,y,s]));
# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
model.eqTechSng2Grp = Constraint(model.meqTechSng2Grp, rule = lambda model, t, r, c, gp, y, s : model.vTechInp[t,c,r,y,s]*model.pTechCinp2use[t,c,r,y,s]  ==  sum((((model.vTechOut[t,cp,r,y,s]) / (model.pTechUse2cact[t,cp,r,y,s]*model.pTechCact2cout[t,cp,r,y,s])) if (t,cp,r,y,s) in model.mvTechOut else 0) for cp in model.comm if (t,gp,cp) in model.mTechGroupComm));
# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
model.eqTechGrp2Grp = Constraint(model.meqTechGrp2Grp, rule = lambda model, t, r, g, gp, y, s : model.pTechGinp2use[t,g,r,y,s]*sum(((model.vTechInp[t,c,r,y,s]*model.pTechCinp2ginp[t,c,r,y,s]) if (t,c,r,y,s) in model.mvTechInp else 0) for c in model.comm if (t,g,c) in model.mTechGroupComm)  ==  sum((((model.vTechOut[t,cp,r,y,s]) / (model.pTechUse2cact[t,cp,r,y,s]*model.pTechCact2cout[t,cp,r,y,s])) if (t,cp,r,y,s) in model.mvTechOut else 0) for cp in model.comm if (t,gp,cp) in model.mTechGroupComm));
# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
model.eqTechShareInpLo = Constraint(model.meqTechShareInpLo, rule = lambda model, t, r, g, c, y, s : model.vTechInp[t,c,r,y,s]  >=  model.pTechShareLo[t,c,r,y,s]*sum((model.vTechInp[t,cp,r,y,s] if (t,cp,r,y,s) in model.mvTechInp else 0) for cp in model.comm if (t,g,cp) in model.mTechGroupComm));
# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
model.eqTechShareInpUp = Constraint(model.meqTechShareInpUp, rule = lambda model, t, r, g, c, y, s : model.vTechInp[t,c,r,y,s] <=  model.pTechShareUp[t,c,r,y,s]*sum((model.vTechInp[t,cp,r,y,s] if (t,cp,r,y,s) in model.mvTechInp else 0) for cp in model.comm if (t,g,cp) in model.mTechGroupComm));
# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
model.eqTechShareOutLo = Constraint(model.meqTechShareOutLo, rule = lambda model, t, r, g, c, y, s : model.vTechOut[t,c,r,y,s]  >=  model.pTechShareLo[t,c,r,y,s]*sum((model.vTechOut[t,cp,r,y,s] if (t,cp,r,y,s) in model.mvTechOut else 0) for cp in model.comm if (t,g,cp) in model.mTechGroupComm));
# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
model.eqTechShareOutUp = Constraint(model.meqTechShareOutUp, rule = lambda model, t, r, g, c, y, s : model.vTechOut[t,c,r,y,s] <=  model.pTechShareUp[t,c,r,y,s]*sum((model.vTechOut[t,cp,r,y,s] if (t,cp,r,y,s) in model.mvTechOut else 0) for cp in model.comm if (t,g,cp) in model.mTechGroupComm));
# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
model.eqTechAInp = Constraint(model.mvTechAInp, rule = lambda model, t, c, r, y, s : model.vTechAInp[t,c,r,y,s]  ==  (model.vTechAct[t,r,y,s]*model.pTechAct2AInp[t,c,r,y,s])+(model.vTechCap[t,r,y]*model.pTechCap2AInp[t,c,r,y,s])+((model.vTechNewCap[t,r,y]*model.pTechNCap2AInp[t,c,r,y,s]) if (t,r,y) in model.mTechNew else 0)+sum(model.pTechCinp2AInp[t,c,cp,r,y,s]*model.vTechInp[t,cp,r,y,s] for cp in model.comm if (model.pTechCinp2AInp[t,c,cp,r,y,s]>0))+sum(model.pTechCout2AInp[t,c,cp,r,y,s]*model.vTechOut[t,cp,r,y,s] for cp in model.comm if (model.pTechCout2AInp[t,c,cp,r,y,s]>0)));
# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
model.eqTechAOut = Constraint(model.mvTechAOut, rule = lambda model, t, c, r, y, s : model.vTechAOut[t,c,r,y,s]  ==  (model.vTechAct[t,r,y,s]*model.pTechAct2AOut[t,c,r,y,s])+(model.vTechCap[t,r,y]*model.pTechCap2AOut[t,c,r,y,s])+((model.vTechNewCap[t,r,y]*model.pTechNCap2AOut[t,c,r,y,s]) if (t,r,y) in model.mTechNew else 0)+sum(model.pTechCinp2AOut[t,c,cp,r,y,s]*model.vTechInp[t,cp,r,y,s] for cp in model.comm if (model.pTechCinp2AOut[t,c,cp,r,y,s]>0))+sum(model.pTechCout2AOut[t,c,cp,r,y,s]*model.vTechOut[t,cp,r,y,s] for cp in model.comm if (model.pTechCout2AOut[t,c,cp,r,y,s]>0)));
# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
model.eqTechAfLo = Constraint(model.meqTechAfLo, rule = lambda model, t, r, y, s : model.pTechAfLo[t,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfLo[t,r,y,s] <=  model.vTechAct[t,r,y,s]);
# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
model.eqTechAfUp = Constraint(model.meqTechAfUp, rule = lambda model, t, r, y, s : model.vTechAct[t,r,y,s] <=  model.pTechAfUp[t,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfUp[t,r,y,s]);
# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
model.eqTechAfsLo = Constraint(model.meqTechAfsLo, rule = lambda model, t, r, y, s : model.pTechAfsLo[t,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfsLo[t,r,y,s] <=  sum((model.vTechAct[t,r,y,sp] if (t,r,y,sp) in model.mvTechAct else 0) for sp in model.slice if (s,sp) in model.mSliceParentChildE));
# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
model.eqTechAfsUp = Constraint(model.meqTechAfsUp, rule = lambda model, t, r, y, s : sum((model.vTechAct[t,r,y,sp] if (t,r,y,sp) in model.mvTechAct else 0) for sp in model.slice if (s,sp) in model.mSliceParentChildE) <=  model.pTechAfsUp[t,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfsUp[t,r,y,s]);
# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
model.eqTechActSng = Constraint(model.meqTechActSng, rule = lambda model, t, c, r, y, s : model.vTechAct[t,r,y,s]  ==  (model.vTechOut[t,c,r,y,s]) / (model.pTechCact2cout[t,c,r,y,s]));
# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
model.eqTechActGrp = Constraint(model.meqTechActGrp, rule = lambda model, t, g, r, y, s : model.vTechAct[t,r,y,s]  ==  sum((((model.vTechOut[t,c,r,y,s]) / (model.pTechCact2cout[t,c,r,y,s])) if (t,c,r,y,s) in model.mvTechOut else 0) for c in model.comm if (t,g,c) in model.mTechGroupComm));
# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
model.eqTechAfcOutLo = Constraint(model.meqTechAfcOutLo, rule = lambda model, t, r, c, y, s : model.pTechCact2cout[t,c,r,y,s]*model.pTechAfcLo[t,c,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfcLo[t,c,r,y,s] <=  model.vTechOut[t,c,r,y,s]);
# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
model.eqTechAfcOutUp = Constraint(model.meqTechAfcOutUp, rule = lambda model, t, r, c, y, s : model.vTechOut[t,c,r,y,s] <=  model.pTechCact2cout[t,c,r,y,s]*model.pTechAfcUp[t,c,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfcUp[t,c,r,y,s]);
# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
model.eqTechAfcInpLo = Constraint(model.meqTechAfcInpLo, rule = lambda model, t, r, c, y, s : model.pTechAfcLo[t,c,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfcLo[t,c,r,y,s] <=  model.vTechInp[t,c,r,y,s]);
# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
model.eqTechAfcInpUp = Constraint(model.meqTechAfcInpUp, rule = lambda model, t, r, c, y, s : model.vTechInp[t,c,r,y,s] <=  model.pTechAfcUp[t,c,r,y,s]*model.pTechCap2act[t]*model.vTechCap[t,r,y]*model.pSliceShare[s]*model.paTechWeatherAfcUp[t,c,r,y,s]);
# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
model.eqTechCap = Constraint(model.mTechSpan, rule = lambda model, t, r, y : model.vTechCap[t,r,y]  ==  model.pTechStock[t,r,y]+sum(model.vTechNewCap[t,r,yp]-sum(model.vTechRetiredCap[t,r,yp,ye] for ye in model.year if ((t,r,yp,ye) in model.mvTechRetiredCap and model.ordYear[y] >= model.ordYear[ye])) for yp in model.year if ((t,r,yp) in model.mTechNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTechOlife[t,r]+model.ordYear[yp] or (t,r) in model.mTechOlifeInf))));
# eqTechNewCap(tech, region, year)$meqTechNewCap(tech, region, year)
model.eqTechNewCap = Constraint(model.meqTechNewCap, rule = lambda model, t, r, y : sum(model.vTechRetiredCap[t,r,y,yp] for yp in model.year if (t,r,y,yp) in model.mvTechRetiredCap) <=  model.vTechNewCap[t,r,y]);
# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
model.eqTechEac = Constraint(model.mTechEac, rule = lambda model, t, r, y : model.vTechEac[t,r,y]  ==  sum(model.pTechEac[t,r,yp]*(model.vTechNewCap[t,r,yp]-sum(model.vTechRetiredCap[t,r,yp,ye] for ye in model.year if (t,r,yp,ye) in model.mvTechRetiredCap)) for yp in model.year if ((t,r,yp) in model.mTechNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTechOlife[t,r]+model.ordYear[yp] or (t,r) in model.mTechOlifeInf))));
# eqTechInv(tech, region, year)$mTechNew(tech, region, year)
model.eqTechInv = Constraint(model.mTechNew, rule = lambda model, t, r, y : model.vTechInv[t,r,y]  ==  model.pTechInvcost[t,r,y]*model.vTechNewCap[t,r,y]);
# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
model.eqTechOMCost = Constraint(model.mTechOMCost, rule = lambda model, t, r, y : model.vTechOMCost[t,r,y]  ==  model.pTechFixom[t,r,y]*model.vTechCap[t,r,y]+sum(model.pTechVarom[t,r,y,s]*model.vTechAct[t,r,y,s]+sum(model.pTechCvarom[t,c,r,y,s]*model.vTechInp[t,c,r,y,s] for c in model.comm if (t,c) in model.mTechInpComm)+sum(model.pTechCvarom[t,c,r,y,s]*model.vTechOut[t,c,r,y,s] for c in model.comm if (t,c) in model.mTechOutComm)+sum(model.pTechAvarom[t,c,r,y,s]*model.vTechAOut[t,c,r,y,s] for c in model.comm if (t,c,r,y,s) in model.mvTechAOut)+sum(model.pTechAvarom[t,c,r,y,s]*model.vTechAInp[t,c,r,y,s] for c in model.comm if (t,c,r,y,s) in model.mvTechAInp) for s in model.slice if (t,s) in model.mTechSlice));
# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
model.eqSupAvaUp = Constraint(model.mSupAvaUp, rule = lambda model, s1, c, r, y, s : model.vSupOut[s1,c,r,y,s] <=  model.pSupAvaUp[s1,c,r,y,s]*model.paSupWeatherUp[s1,c,r,y,s]);
# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
model.eqSupAvaLo = Constraint(model.meqSupAvaLo, rule = lambda model, s1, c, r, y, s : model.vSupOut[s1,c,r,y,s]  >=  model.pSupAvaLo[s1,c,r,y,s]*model.paSupWeatherLo[s1,c,r,y,s]);
# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
model.eqSupTotal = Constraint(model.mvSupReserve, rule = lambda model, s1, c, r : model.vSupReserve[s1,c,r]  ==  sum(model.pPeriodLen[y]*model.vSupOut[s1,c,r,y,s] for y in model.year for s in model.slice if (s1,c,r,y,s) in model.mSupAva));
# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
model.eqSupReserveUp = Constraint(model.mSupReserveUp, rule = lambda model, s1, c, r : model.pSupReserveUp[s1,c,r]  >=  model.vSupReserve[s1,c,r]);
# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
model.eqSupReserveLo = Constraint(model.meqSupReserveLo, rule = lambda model, s1, c, r : model.vSupReserve[s1,c,r]  >=  model.pSupReserveLo[s1,c,r]);
# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
model.eqSupCost = Constraint(model.mvSupCost, rule = lambda model, s1, r, y : model.vSupCost[s1,r,y]  ==  sum(model.pSupCost[s1,c,r,y,s]*model.vSupOut[s1,c,r,y,s] for c in model.comm for s in model.slice if (s1,c,r,y,s) in model.mSupAva));
# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
model.eqDemInp = Constraint(model.mvDemInp, rule = lambda model, c, r, y, s : model.vDemInp[c,r,y,s]  ==  sum(model.pDemand[d,c,r,y,s] for d in model.dem if (d,c) in model.mDemComm));
# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
model.eqAggOut = Constraint(model.mAggOut, rule = lambda model, c, r, y, s : model.vAggOut[c,r,y,s]  ==  sum(model.pAggregateFactor[c,cp]*sum(model.vOutTot[cp,r,y,sp] for sp in model.slice if ((cp,r,y,sp) in model.mvBalance and (s,sp) in model.mSliceParentChildE and (cp,sp) in model.mCommSlice)) for cp in model.comm if (c,cp) in model.mAggregateFactor));
# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
model.eqEmsFuelTot = Constraint(model.mEmsFuelTot, rule = lambda model, c, r, y, s : model.vEmsFuelTot[c,r,y,s]  ==  sum(model.pEmissionFactor[c,cp]*sum(model.pTechEmisComm[t,cp]*sum((model.vTechInp[t,cp,r,y,sp] if (t,c,cp,r,y,sp) in model.mTechEmsFuel else 0) for sp in model.slice if (c,s,sp) in model.mCommSliceOrParent) for t in model.tech if (t,cp) in model.mTechInpComm) for cp in model.comm if (model.pEmissionFactor[c,cp]>0)));
# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
model.eqStorageAInp = Constraint(model.mvStorageAInp, rule = lambda model, st1, c, r, y, s : model.vStorageAInp[st1,c,r,y,s]  ==  sum(model.pStorageStg2AInp[st1,c,r,y,s]*model.vStorageStore[st1,cp,r,y,s]+model.pStorageInp2AInp[st1,c,r,y,s]*model.vStorageInp[st1,cp,r,y,s]+model.pStorageOut2AInp[st1,c,r,y,s]*model.vStorageOut[st1,cp,r,y,s]+model.pStorageCap2AInp[st1,c,r,y,s]*model.vStorageCap[st1,r,y]+((model.pStorageNCap2AInp[st1,c,r,y,s]*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in model.mStorageNew else 0) for cp in model.comm if (st1,cp) in model.mStorageComm));
# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
model.eqStorageAOut = Constraint(model.mvStorageAOut, rule = lambda model, st1, c, r, y, s : model.vStorageAOut[st1,c,r,y,s]  ==  sum(model.pStorageStg2AOut[st1,c,r,y,s]*model.vStorageStore[st1,cp,r,y,s]+model.pStorageInp2AOut[st1,c,r,y,s]*model.vStorageInp[st1,cp,r,y,s]+model.pStorageOut2AOut[st1,c,r,y,s]*model.vStorageOut[st1,cp,r,y,s]+model.pStorageCap2AOut[st1,c,r,y,s]*model.vStorageCap[st1,r,y]+((model.pStorageNCap2AOut[st1,c,r,y,s]*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in model.mStorageNew else 0) for cp in model.comm if (st1,cp) in model.mStorageComm));
# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageStore = Constraint(model.mvStorageStore, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s]  ==  model.pStorageCharge[st1,c,r,y,s]+((model.pStorageNCap2Stg[st1,c,r,y,s]*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in model.mStorageNew else 0)+sum(model.pStorageInpEff[st1,c,r,y,sp]*model.vStorageInp[st1,c,r,y,sp]+((model.pStorageStgEff[st1,c,r,y,s])**(model.pSliceShare[s]))*model.vStorageStore[st1,c,r,y,sp]-(model.vStorageOut[st1,c,r,y,sp]) / (model.pStorageOutEff[st1,c,r,y,sp]) for sp in model.slice if ((c,sp) in model.mCommSlice and ((not((st1 in model.mStorageFullYear)) and (sp,s) in model.mSliceNext) or (st1 in model.mStorageFullYear and (sp,s) in model.mSliceFYearNext)))));
# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
model.eqStorageAfLo = Constraint(model.meqStorageAfLo, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s]  >=  model.pStorageAfLo[st1,r,y,s]*model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.paStorageWeatherAfLo[st1,c,r,y,s]);
# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
model.eqStorageAfUp = Constraint(model.meqStorageAfUp, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s] <=  model.pStorageAfUp[st1,r,y,s]*model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.paStorageWeatherAfUp[st1,c,r,y,s]);
# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageClean = Constraint(model.mvStorageStore, rule = lambda model, st1, c, r, y, s : (model.vStorageOut[st1,c,r,y,s]) / (model.pStorageOutEff[st1,c,r,y,s]) <=  model.vStorageStore[st1,c,r,y,s]);
# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
model.eqStorageInpUp = Constraint(model.meqStorageInpUp, rule = lambda model, st1, c, r, y, s : model.vStorageInp[st1,c,r,y,s] <=  model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.pStorageCinpUp[st1,c,r,y,s]*model.pSliceShare[s]*model.paStorageWeatherCinpUp[st1,c,r,y,s]);
# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
model.eqStorageInpLo = Constraint(model.meqStorageInpLo, rule = lambda model, st1, c, r, y, s : model.vStorageInp[st1,c,r,y,s]  >=  model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.pStorageCinpLo[st1,c,r,y,s]*model.pSliceShare[s]*model.paStorageWeatherCinpLo[st1,c,r,y,s]);
# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
model.eqStorageOutUp = Constraint(model.meqStorageOutUp, rule = lambda model, st1, c, r, y, s : model.vStorageOut[st1,c,r,y,s] <=  model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.pStorageCoutUp[st1,c,r,y,s]*model.pSliceShare[s]*model.paStorageWeatherCoutUp[st1,c,r,y,s]);
# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
model.eqStorageOutLo = Constraint(model.meqStorageOutLo, rule = lambda model, st1, c, r, y, s : model.vStorageOut[st1,c,r,y,s]  >=  model.pStorageCap2stg[st1]*model.vStorageCap[st1,r,y]*model.pStorageCoutLo[st1,c,r,y,s]*model.pSliceShare[s]*model.paStorageWeatherCoutLo[st1,c,r,y,s]);
# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
model.eqStorageCap = Constraint(model.mStorageSpan, rule = lambda model, st1, r, y : model.vStorageCap[st1,r,y]  ==  model.pStorageStock[st1,r,y]+sum(model.vStorageNewCap[st1,r,yp] for yp in model.year if (model.ordYear[y] >= model.ordYear[yp] and ((st1,r) in model.mStorageOlifeInf or model.ordYear[y]<model.pStorageOlife[st1,r]+model.ordYear[yp]) and (st1,r,yp) in model.mStorageNew)));
# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
model.eqStorageInv = Constraint(model.mStorageNew, rule = lambda model, st1, r, y : model.vStorageInv[st1,r,y]  ==  model.pStorageInvcost[st1,r,y]*model.vStorageNewCap[st1,r,y]);
# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
model.eqStorageEac = Constraint(model.mStorageEac, rule = lambda model, st1, r, y : model.vStorageEac[st1,r,y]  ==  sum(model.pStorageEac[st1,r,yp]*model.vStorageNewCap[st1,r,yp] for yp in model.year if ((st1,r,yp) in model.mStorageNew and model.ordYear[y] >= model.ordYear[yp] and ((st1,r) in model.mStorageOlifeInf or model.ordYear[y]<model.pStorageOlife[st1,r]+model.ordYear[yp]) and model.pStorageInvcost[st1,r,yp] != 0)));
# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
model.eqStorageCost = Constraint(model.mStorageOMCost, rule = lambda model, st1, r, y : model.vStorageOMCost[st1,r,y]  ==  model.pStorageFixom[st1,r,y]*model.vStorageCap[st1,r,y]+sum(model.pStorageCostInp[st1,r,y,s]*model.vStorageInp[st1,c,r,y,s]+model.pStorageCostOut[st1,r,y,s]*model.vStorageOut[st1,c,r,y,s]+model.pStorageCostStore[st1,r,y,s]*model.vStorageStore[st1,c,r,y,s] for c in model.comm for s in model.slice if ((c,s) in model.mCommSlice and (st1,c) in model.mStorageComm)));
# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
model.eqImport = Constraint(model.mImport, rule = lambda model, c, dst, y, s : model.vImport[c,dst,y,s]  ==  sum(sum(sum(((model.pTradeIrEff[t1,src,dst,y,sp]*model.vTradeIr[t1,c,src,dst,y,sp]) if (t1,c,src,dst,y,sp) in model.mvTradeIr else 0) for src in model.region if (t1,src,dst) in model.mTradeRoutes) for t1 in model.trade if (t1,c) in model.mTradeComm)+sum((model.vImportRow[i,c,dst,y,sp] if (i,c,dst,y,sp) in model.mImportRow else 0) for i in model.imp if (i,c) in model.mImpComm) for sp in model.slice if (c,s,sp) in model.mCommSliceOrParent));
# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
model.eqExport = Constraint(model.mExport, rule = lambda model, c, src, y, s : model.vExport[c,src,y,s]  ==  sum(sum(sum((model.vTradeIr[t1,c,src,dst,y,sp] if (t1,c,src,dst,y,sp) in model.mvTradeIr else 0) for dst in model.region if (t1,src,dst) in model.mTradeRoutes) for t1 in model.trade if (t1,c) in model.mTradeComm)+sum((model.vExportRow[e,c,src,y,sp] if (e,c,src,y,sp) in model.mExportRow else 0) for e in model.expp if (e,c) in model.mExpComm) for sp in model.slice if (c,s,sp) in model.mCommSliceOrParent));
# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
model.eqTradeFlowUp = Constraint(model.meqTradeFlowUp, rule = lambda model, t1, c, src, dst, y, s : model.vTradeIr[t1,c,src,dst,y,s] <=  model.pTradeIrUp[t1,src,dst,y,s]);
# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
model.eqTradeFlowLo = Constraint(model.meqTradeFlowLo, rule = lambda model, t1, c, src, dst, y, s : model.vTradeIr[t1,c,src,dst,y,s]  >=  model.pTradeIrLo[t1,src,dst,y,s]);
# eqCostTrade(region, year)$mvTradeCost(region, year)
model.eqCostTrade = Constraint(model.mvTradeCost, rule = lambda model, r, y : model.vTradeCost[r,y]  ==  (model.vTradeRowCost[r,y] if (r,y) in model.mvTradeRowCost else 0)+(model.vTradeIrCost[r,y] if (r,y) in model.mvTradeIrCost else 0));
# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
model.eqCostRowTrade = Constraint(model.mvTradeRowCost, rule = lambda model, r, y : model.vTradeRowCost[r,y]  ==  sum(model.pImportRowPrice[i,r,y,s]*model.vImportRow[i,c,r,y,s] for i in model.imp for c in model.comm for s in model.slice if (i,c,r,y,s) in model.mImportRow)-sum(model.pExportRowPrice[e,r,y,s]*model.vExportRow[e,c,r,y,s] for e in model.expp for c in model.comm for s in model.slice if (e,c,r,y,s) in model.mExportRow));
# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
model.eqCostIrTrade = Constraint(model.mvTradeIrCost, rule = lambda model, r, y : model.vTradeIrCost[r,y]  ==  sum(model.vTradeEac[t1,r,y] for t1 in model.trade if (t1,r,y) in model.mTradeEac)+sum(sum(sum(((((model.pTradeIrCost[t1,src,r,y,s]+model.pTradeIrMarkup[t1,src,r,y,s])*model.vTradeIr[t1,c,src,r,y,s])) if (t1,c,src,r,y,s) in model.mvTradeIr else 0) for s in model.slice if (t1,s) in model.mTradeSlice) for c in model.comm if (t1,c) in model.mTradeComm) for t1 in model.trade for src in model.region if (t1,src,r) in model.mTradeRoutes)-sum(sum(sum((((model.pTradeIrMarkup[t1,r,dst,y,s]*model.vTradeIr[t1,c,r,dst,y,s])) if (t1,c,r,dst,y,s) in model.mvTradeIr else 0) for s in model.slice if (t1,s) in model.mTradeSlice) for c in model.comm if (t1,c) in model.mTradeComm) for t1 in model.trade for dst in model.region if (t1,r,dst) in model.mTradeRoutes));
# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
model.eqExportRowUp = Constraint(model.mExportRowUp, rule = lambda model, e, c, r, y, s : model.vExportRow[e,c,r,y,s] <=  model.pExportRowUp[e,r,y,s]);
# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
model.eqExportRowLo = Constraint(model.meqExportRowLo, rule = lambda model, e, c, r, y, s : model.vExportRow[e,c,r,y,s]  >=  model.pExportRowLo[e,r,y,s]);
# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
model.eqExportRowCumulative = Constraint(model.mExpComm, rule = lambda model, e, c : model.vExportRowAccumulated[e,c]  ==  sum(model.pPeriodLen[y]*model.vExportRow[e,c,r,y,s] for r in model.region for y in model.year for s in model.slice if (e,c,r,y,s) in model.mExportRow));
# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
model.eqExportRowResUp = Constraint(model.mExportRowAccumulatedUp, rule = lambda model, e, c : model.vExportRowAccumulated[e,c] <=  model.pExportRowRes[e]);
# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
model.eqImportRowUp = Constraint(model.mImportRowUp, rule = lambda model, i, c, r, y, s : model.vImportRow[i,c,r,y,s] <=  model.pImportRowUp[i,r,y,s]);
# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
model.eqImportRowLo = Constraint(model.meqImportRowLo, rule = lambda model, i, c, r, y, s : model.vImportRow[i,c,r,y,s]  >=  model.pImportRowLo[i,r,y,s]);
# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
model.eqImportRowAccumulated = Constraint(model.mImpComm, rule = lambda model, i, c : model.vImportRowAccumulated[i,c]  ==  sum(model.pPeriodLen[y]*model.vImportRow[i,c,r,y,s] for r in model.region for y in model.year for s in model.slice if (i,c,r,y,s) in model.mImportRow));
# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
model.eqImportRowResUp = Constraint(model.mImportRowAccumulatedUp, rule = lambda model, i, c : model.vImportRowAccumulated[i,c] <=  model.pImportRowRes[i]);
# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
model.eqTradeCapFlow = Constraint(model.meqTradeCapFlow, rule = lambda model, t1, c, y, s : model.pSliceShare[s]*model.pTradeCap2Act[t1]*model.vTradeCap[t1,y]  >=  sum(model.vTradeIr[t1,c,src,dst,y,s] for src in model.region for dst in model.region if (t1,c,src,dst,y,s) in model.mvTradeIr));
# eqTradeCap(trade, year)$mTradeSpan(trade, year)
model.eqTradeCap = Constraint(model.mTradeSpan, rule = lambda model, t1, y : model.vTradeCap[t1,y]  ==  model.pTradeStock[t1,y]+sum(model.vTradeNewCap[t1,yp] for yp in model.year if ((t1,yp) in model.mTradeNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTradeOlife[t1]+model.ordYear[yp] or t1 in model.mTradeOlifeInf))));
# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
model.eqTradeInv = Constraint(model.mTradeInv, rule = lambda model, t1, r, y : model.vTradeInv[t1,r,y]  ==  model.pTradeInvcost[t1,r,y]*model.vTradeNewCap[t1,y]);
# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
model.eqTradeEac = Constraint(model.mTradeEac, rule = lambda model, t1, r, y : model.vTradeEac[t1,r,y]  ==  sum(model.pTradeEac[t1,r,yp]*model.vTradeNewCap[t1,yp] for yp in model.year if ((t1,yp) in model.mTradeNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTradeOlife[t1]+model.ordYear[yp] or t1 in model.mTradeOlifeInf))));
# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
model.eqTradeIrAInp = Constraint(model.mvTradeIrAInp, rule = lambda model, t1, c, r, y, s : model.vTradeIrAInp[t1,c,r,y,s]  ==  sum(model.pTradeIrCsrc2Ainp[t1,c,r,dst,y,s]*sum(model.vTradeIr[t1,cp,r,dst,y,s] for cp in model.comm if (t1,cp) in model.mTradeComm) for dst in model.region if (t1,r,dst,y,s) in model.mTradeIr)+sum(model.pTradeIrCdst2Ainp[t1,c,src,r,y,s]*sum(model.vTradeIr[t1,cp,src,r,y,s] for cp in model.comm if (t1,cp) in model.mTradeComm) for src in model.region if (t1,src,r,y,s) in model.mTradeIr));
# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
model.eqTradeIrAOut = Constraint(model.mvTradeIrAOut, rule = lambda model, t1, c, r, y, s : model.vTradeIrAOut[t1,c,r,y,s]  ==  sum(model.pTradeIrCsrc2Aout[t1,c,r,dst,y,s]*sum(model.vTradeIr[t1,cp,r,dst,y,s] for cp in model.comm if (t1,cp) in model.mTradeComm) for dst in model.region if (t1,r,dst,y,s) in model.mTradeIr)+sum(model.pTradeIrCdst2Aout[t1,c,src,r,y,s]*sum(model.vTradeIr[t1,cp,src,r,y,s] for cp in model.comm if (t1,cp) in model.mTradeComm) for src in model.region if (t1,src,r,y,s) in model.mTradeIr));
# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
model.eqTradeIrAInpTot = Constraint(model.mvTradeIrAInpTot, rule = lambda model, c, r, y, s : model.vTradeIrAInpTot[c,r,y,s]  ==  sum(model.vTradeIrAInp[t1,c,r,y,sp] for t1 in model.trade for sp in model.slice if ((c,s,sp) in model.mCommSliceOrParent and (t1,c,r,y,sp) in model.mvTradeIrAInp)));
# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
model.eqTradeIrAOutTot = Constraint(model.mvTradeIrAOutTot, rule = lambda model, c, r, y, s : model.vTradeIrAOutTot[c,r,y,s]  ==  sum(model.vTradeIrAOut[t1,c,r,y,sp] for t1 in model.trade for sp in model.slice if ((c,s,sp) in model.mCommSliceOrParent and (t1,c,r,y,sp) in model.mvTradeIrAOut)));
# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
model.eqBalLo = Constraint(model.meqBalLo, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  >=  0);
# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
model.eqBalUp = Constraint(model.meqBalUp, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s] <=  0);
# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
model.eqBalFx = Constraint(model.meqBalFx, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  ==  0);
# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqBal = Constraint(model.mvBalance, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  ==  model.vOutTot[c,r,y,s]-model.vInpTot[c,r,y,s]);
# eqOutTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqOutTot = Constraint(model.mvBalance, rule = lambda model, c, r, y, s : model.vOutTot[c,r,y,s]  ==  (model.vDummyImport[c,r,y,s] if (c,r,y,s) in model.mDummyImport else 0)+(model.vSupOutTot[c,r,y,s] if (c,r,y,s) in model.mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,s] if (c,r,y,s) in model.mEmsFuelTot else 0)+(model.vAggOut[c,r,y,s] if (c,r,y,s) in model.mAggOut else 0)+(model.vTechOutTot[c,r,y,s] if (c,r,y,s) in model.mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,s] if (c,r,y,s) in model.mStorageOutTot else 0)+(model.vImport[c,r,y,s] if (c,r,y,s) in model.mImport else 0)+(model.vTradeIrAOutTot[c,r,y,s] if (c,r,y,s) in model.mvTradeIrAOutTot else 0)+sum(model.vOut2Lo[c,r,y,sp,s] for sp in model.slice if ((sp,s) in model.mSliceParentChild and (c,r,y,sp,s) in model.mvOut2Lo)));
# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
model.eqOut2Lo = Constraint(model.mOut2Lo, rule = lambda model, c, r, y, s : sum(model.vOut2Lo[c,r,y,s,sp] for sp in model.slice if ((s,sp) in model.mSliceParentChild and (c,r,y,s,sp) in model.mvOut2Lo))  ==  (model.vSupOutTot[c,r,y,s] if (c,r,y,s) in model.mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,s] if (c,r,y,s) in model.mEmsFuelTot else 0)+(model.vAggOut[c,r,y,s] if (c,r,y,s) in model.mAggOut else 0)+(model.vTechOutTot[c,r,y,s] if (c,r,y,s) in model.mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,s] if (c,r,y,s) in model.mStorageOutTot else 0)+(model.vImport[c,r,y,s] if (c,r,y,s) in model.mImport else 0)+(model.vTradeIrAOutTot[c,r,y,s] if (c,r,y,s) in model.mvTradeIrAOutTot else 0));
# eqInpTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqInpTot = Constraint(model.mvBalance, rule = lambda model, c, r, y, s : model.vInpTot[c,r,y,s]  ==  (model.vDemInp[c,r,y,s] if (c,r,y,s) in model.mvDemInp else 0)+(model.vDummyExport[c,r,y,s] if (c,r,y,s) in model.mDummyExport else 0)+(model.vTechInpTot[c,r,y,s] if (c,r,y,s) in model.mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,s] if (c,r,y,s) in model.mStorageInpTot else 0)+(model.vExport[c,r,y,s] if (c,r,y,s) in model.mExport else 0)+(model.vTradeIrAInpTot[c,r,y,s] if (c,r,y,s) in model.mvTradeIrAInpTot else 0)+sum(model.vInp2Lo[c,r,y,sp,s] for sp in model.slice if ((sp,s) in model.mSliceParentChild and (c,r,y,sp,s) in model.mvInp2Lo)));
# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
model.eqInp2Lo = Constraint(model.mInp2Lo, rule = lambda model, c, r, y, s : sum(model.vInp2Lo[c,r,y,s,sp] for sp in model.slice if ((s,sp) in model.mSliceParentChild and (c,r,y,s,sp) in model.mvInp2Lo))  ==  (model.vTechInpTot[c,r,y,s] if (c,r,y,s) in model.mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,s] if (c,r,y,s) in model.mStorageInpTot else 0)+(model.vExport[c,r,y,s] if (c,r,y,s) in model.mExport else 0)+(model.vTradeIrAInpTot[c,r,y,s] if (c,r,y,s) in model.mvTradeIrAInpTot else 0));
# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
model.eqSupOutTot = Constraint(model.mSupOutTot, rule = lambda model, c, r, y, s : model.vSupOutTot[c,r,y,s]  ==  sum(sum((model.vSupOut[s1,c,r,y,sp] if (s1,c,r,y,sp) in model.mSupAva else 0) for sp in model.slice if (c,s,sp) in model.mCommSliceOrParent) for s1 in model.sup if (s1,c) in model.mSupComm));
# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
model.eqTechInpTot = Constraint(model.mTechInpTot, rule = lambda model, c, r, y, s : model.vTechInpTot[c,r,y,s]  ==  sum(sum((model.vTechInp[t,c,r,y,sp] if (t,c,r,y,sp) in model.mvTechInp else 0) for sp in model.slice if ((t,sp) in model.mTechSlice and (c,s,sp) in model.mCommSliceOrParent)) for t in model.tech if (t,c) in model.mTechInpComm)+sum(sum((model.vTechAInp[t,c,r,y,sp] if (t,c,r,y,sp) in model.mvTechAInp else 0) for sp in model.slice if ((t,sp) in model.mTechSlice and (c,s,sp) in model.mCommSliceOrParent)) for t in model.tech if (t,c) in model.mTechAInp));
# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
model.eqTechOutTot = Constraint(model.mTechOutTot, rule = lambda model, c, r, y, s : model.vTechOutTot[c,r,y,s]  ==  sum(sum((model.vTechOut[t,c,r,y,sp] if (t,c,r,y,sp) in model.mvTechOut else 0) for sp in model.slice if ((t,sp) in model.mTechSlice and (c,s,sp) in model.mCommSliceOrParent)) for t in model.tech if (t,c) in model.mTechOutComm)+sum(sum((model.vTechAOut[t,c,r,y,sp] if (t,c,r,y,sp) in model.mvTechAOut else 0) for sp in model.slice if ((t,sp) in model.mTechSlice and (c,s,sp) in model.mCommSliceOrParent)) for t in model.tech if (t,c) in model.mTechAOut));
# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
model.eqStorageInpTot = Constraint(model.mStorageInpTot, rule = lambda model, c, r, y, s : model.vStorageInpTot[c,r,y,s]  ==  sum(model.vStorageInp[st1,c,r,y,s] for st1 in model.stg if (st1,c,r,y,s) in model.mvStorageStore)+sum(model.vStorageAInp[st1,c,r,y,s] for st1 in model.stg if (st1,c,r,y,s) in model.mvStorageAInp));
# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
model.eqStorageOutTot = Constraint(model.mStorageOutTot, rule = lambda model, c, r, y, s : model.vStorageOutTot[c,r,y,s]  ==  sum(model.vStorageOut[st1,c,r,y,s] for st1 in model.stg if (st1,c,r,y,s) in model.mvStorageStore)+sum(model.vStorageAOut[st1,c,r,y,s] for st1 in model.stg if (st1,c,r,y,s) in model.mvStorageAOut));
# eqCost(region, year)$mvTotalCost(region, year)
model.eqCost = Constraint(model.mvTotalCost, rule = lambda model, r, y : model.vTotalCost[r,y]  ==  sum(model.vTechEac[t,r,y] for t in model.tech if (t,r,y) in model.mTechEac)+sum(model.vTechOMCost[t,r,y] for t in model.tech if (t,r,y) in model.mTechOMCost)+sum(model.vSupCost[s1,r,y] for s1 in model.sup if (s1,r,y) in model.mvSupCost)+sum(model.pDummyImportCost[c,r,y,s]*model.vDummyImport[c,r,y,s] for c in model.comm for s in model.slice if (c,r,y,s) in model.mDummyImport)+sum(model.pDummyExportCost[c,r,y,s]*model.vDummyExport[c,r,y,s] for c in model.comm for s in model.slice if (c,r,y,s) in model.mDummyExport)+sum(model.vTaxCost[c,r,y] for c in model.comm if (c,r,y) in model.mTaxCost)-sum(model.vSubsCost[c,r,y] for c in model.comm if (c,r,y) in model.mSubsCost)+sum(model.vStorageOMCost[st1,r,y] for st1 in model.stg if (st1,r,y) in model.mStorageOMCost)+sum(model.vStorageEac[st1,r,y] for st1 in model.stg if (st1,r,y) in model.mStorageEac)+(model.vTradeCost[r,y] if (r,y) in model.mvTradeCost else 0));
# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
model.eqTaxCost = Constraint(model.mTaxCost, rule = lambda model, c, r, y : model.vTaxCost[c,r,y]  ==  sum(model.pTaxCost[c,r,y,s]*model.vOutTot[c,r,y,s] for s in model.slice if (c,s) in model.mCommSlice));
# eqSubsCost(comm, region, year)$mSubsCost(comm, region, year)
model.eqSubsCost = Constraint(model.mSubsCost, rule = lambda model, c, r, y : model.vSubsCost[c,r,y]  ==  sum(model.pSubsCost[c,r,y,s]*model.vOutTot[c,r,y,s] for s in model.slice if (c,s) in model.mCommSlice));
# eqObjective
model.eqObjective = Constraint(rule = lambda model : model.vObjective  ==  sum(model.vTotalCost[r,y]*model.pDiscountFactorMileStone[r,y] for r in model.region for y in model.year if (r,y) in model.mvTotalCost));
# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
model.eqLECActivity = Constraint(model.meqLECActivity, rule = lambda model, t, r, y : sum(model.vTechAct[t,r,y,s] for s in model.slice if (t,s) in model.mTechSlice)  >=  model.pLECLoACT[r]);
exec(open("inc_constraints.py").read())
model.obj = Objective(rule = lambda model: model.vObjective, sense = minimize);


print("model.create_instance begin ", round(time.time() - seconds, 2));
exec(open("inc2.py").read())
flog.write('"load data",,"' + str(datetime.datetime.now()) + '"\n')
instance = model.create_instance("data.dat");
print("model.create_instance end ", round(time.time() - seconds, 2));

exec(open("inc_solver.py").read())
# opt = SolverFactory('cplex');
flog.write('"solver",,"' + str(datetime.datetime.now()) + '"\n')
exec(open("inc3.py").read())
slv = opt.solve(instance);
exec(open("inc4.py").read())
print("opt solve ", round(time.time() - seconds, 2));
flog.write('"solution status",' + str((slv.solver.status == SolverStatus.ok) *1) + ',"' + str(datetime.datetime.now()) + '"\n')
flog.write('"export results",,"' + str(datetime.datetime.now()) + '"\n')
exec(open("output.py").read())
flog.write('"done",,"' + str(datetime.datetime.now()) + '"\n')
flog.close();
exec(open("inc5.py").read())
