# Import
import time
seconds = time.time()
import itertools
from pyomo.environ import *
from pyomo.opt import SolverFactory
import pyomo.environ as pyo
class toPar:
    def __init__(self, val, default):
        self.default = default
        self.val = val
    def get(self, key):
        if key in self.val:
            return (self.val[key])
        return (self.default)
model = ConcreteModel()
##### decl par #####
print("Load finish ", round(time.time() - seconds, 2))
model.vTechInv = Var(mTechNew, doc = "Overnight investment costs");
model.vTechEac = Var(mTechEac, doc = "Annualized investment costs");
model.vTechOMCost = Var(mTechOMCost, doc = "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)");
model.vSupCost = Var(mvSupCost, doc = "Supply costs");
model.vEmsFuelTot = Var(mEmsFuelTot, doc = "Total fuel emissions");
model.vBalance = Var(mvBalance, doc = "Net commodity balance");
model.vTotalCost = Var(mvTotalCost, doc = "Regional annual total costs");
model.vObjective = Var(doc = "Objective costs");
model.vTaxCost = Var(mTaxCost, doc = "Total tax levies (tax costs)");
model.vSubsCost = Var(mSubsCost, doc = "Total subsidies (for substraction from costs)");
model.vAggOut = Var(mAggOut, doc = "Aggregated commodity output");
model.vStorageOMCost = Var(mStorageOMCost, doc = "Storage O&M costs");
model.vTradeCost = Var(mvTradeCost, doc = "Total trade costs");
model.vTradeRowCost = Var(mvTradeRowCost, doc = "Trade with ROW costs");
model.vTradeIrCost = Var(mvTradeIrCost, doc = "Interregional trade costs");
model.vTechNewCap = Var(mTechNew, domain = pyo.NonNegativeReals, doc = "New capacity");
model.vTechRetiredCap = Var(mvTechRetiredCap, domain = pyo.NonNegativeReals, doc = "Early retired capacity");
model.vTechCap = Var(mTechSpan, domain = pyo.NonNegativeReals, doc = "Total capacity of the technology");
model.vTechAct = Var(mvTechAct, domain = pyo.NonNegativeReals, doc = "Activity level of technology");
model.vTechInp = Var(mvTechInp, domain = pyo.NonNegativeReals, doc = "Input level");
model.vTechOut = Var(mvTechOut, domain = pyo.NonNegativeReals, doc = "Output level");
model.vTechAInp = Var(mvTechAInp, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity input");
model.vTechAOut = Var(mvTechAOut, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity output");
model.vSupOut = Var(mSupAva, domain = pyo.NonNegativeReals, doc = "Output of supply");
model.vSupReserve = Var(mvSupReserve, domain = pyo.NonNegativeReals, doc = "Total supply reserve");
model.vDemInp = Var(mvDemInp, domain = pyo.NonNegativeReals, doc = "Input to demand");
model.vOutTot = Var(mvBalance, domain = pyo.NonNegativeReals, doc = "Total commodity output (consumption is not counted)");
model.vInpTot = Var(mvBalance, domain = pyo.NonNegativeReals, doc = "Total commodity input");
model.vInp2Lo = Var(mvInp2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for input parent to (grand)child");
model.vOut2Lo = Var(mvOut2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for output parent to (grand)child");
model.vSupOutTot = Var(mSupOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity supply");
model.vTechInpTot = Var(mTechInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to technologies");
model.vTechOutTot = Var(mTechOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from technologies");
model.vStorageInpTot = Var(mStorageInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to storages");
model.vStorageOutTot = Var(mStorageOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from storages");
model.vStorageAInp = Var(mvStorageAInp, domain = pyo.NonNegativeReals, doc = "Aux-commodity input to storage");
model.vStorageAOut = Var(mvStorageAOut, domain = pyo.NonNegativeReals, doc = "Aux-commodity input from storage");
model.vDummyImport = Var(mDummyImport, domain = pyo.NonNegativeReals, doc = "Dummy import (for debugging)");
model.vDummyExport = Var(mDummyExport, domain = pyo.NonNegativeReals, doc = "Dummy export (for debugging)");
model.vStorageInp = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage input");
model.vStorageOut = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage output");
model.vStorageStore = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage accumulated level");
model.vStorageInv = Var(mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage technology investments");
model.vStorageEac = Var(mStorageEac, domain = pyo.NonNegativeReals, doc = "Storage technology EAC investments");
model.vStorageCap = Var(mStorageSpan, domain = pyo.NonNegativeReals, doc = "Storage capacity");
model.vStorageNewCap = Var(mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage new capacity");
model.vImport = Var(mImport, domain = pyo.NonNegativeReals, doc = "Total regional import (Ir + ROW)");
model.vExport = Var(mExport, domain = pyo.NonNegativeReals, doc = "Total regional export (Ir + ROW)");
model.vTradeIr = Var(mvTradeIr, domain = pyo.NonNegativeReals, doc = "Total physical trade flows between regions");
model.vTradeIrAInp = Var(mvTradeIrAInp, domain = pyo.NonNegativeReals, doc = "Trade auxilari input");
model.vTradeIrAInpTot = Var(mvTradeIrAInpTot, domain = pyo.NonNegativeReals, doc = "Trade total auxilari input");
model.vTradeIrAOut = Var(mvTradeIrAOut, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vTradeIrAOutTot = Var(mvTradeIrAOutTot, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vExportRowAccumulated = Var(mExpComm, domain = pyo.NonNegativeReals, doc = "Accumulated export to ROW");
model.vExportRow = Var(mExportRow, domain = pyo.NonNegativeReals, doc = "Export to ROW");
model.vImportRowAccumulated = Var(mImpComm, domain = pyo.NonNegativeReals, doc = "Accumulated import from ROW");
model.vImportRow = Var(mImportRow, domain = pyo.NonNegativeReals, doc = "Import from ROW");
model.vTradeCap = Var(mvTradeCap, domain = pyo.NonNegativeReals, doc = "");
model.vTradeInv = Var(mTradeEac, domain = pyo.NonNegativeReals, doc = "");
model.vTradeEac = Var(mTradeEac, domain = pyo.NonNegativeReals, doc = "");
model.vTradeNewCap = Var(mvTradeNewCap, domain = pyo.NonNegativeReals, doc = "");
print("Variable finish ", round(time.time() - seconds, 2))
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
model.eqTechSng2Sng = Constraint(meqTechSng2Sng, rule = lambda model, t, r, c, cp, y, s : model.vTechInp[t,c,r,y,s]*pTechCinp2use.get((t,c,r,y,s))  ==  (model.vTechOut[t,cp,r,y,s]) / (pTechUse2cact.get((t,cp,r,y,s))*pTechCact2cout.get((t,cp,r,y,s))));
# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
model.eqTechGrp2Sng = Constraint(meqTechGrp2Sng, rule = lambda model, t, r, g, cp, y, s : pTechGinp2use.get((t,g,r,y,s))*sum(((model.vTechInp[t,c,r,y,s]*pTechCinp2ginp.get((t,c,r,y,s))) if (t,c,r,y,s) in mvTechInp else 0) for c in comm if (t,g,c) in mTechGroupComm)  ==  (model.vTechOut[t,cp,r,y,s]) / (pTechUse2cact.get((t,cp,r,y,s))*pTechCact2cout.get((t,cp,r,y,s))));
# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
model.eqTechSng2Grp = Constraint(meqTechSng2Grp, rule = lambda model, t, r, c, gp, y, s : model.vTechInp[t,c,r,y,s]*pTechCinp2use.get((t,c,r,y,s))  ==  sum((((model.vTechOut[t,cp,r,y,s]) / (pTechUse2cact.get((t,cp,r,y,s))*pTechCact2cout.get((t,cp,r,y,s)))) if (t,cp,r,y,s) in mvTechOut else 0) for cp in comm if (t,gp,cp) in mTechGroupComm));
# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
model.eqTechGrp2Grp = Constraint(meqTechGrp2Grp, rule = lambda model, t, r, g, gp, y, s : pTechGinp2use.get((t,g,r,y,s))*sum(((model.vTechInp[t,c,r,y,s]*pTechCinp2ginp.get((t,c,r,y,s))) if (t,c,r,y,s) in mvTechInp else 0) for c in comm if (t,g,c) in mTechGroupComm)  ==  sum((((model.vTechOut[t,cp,r,y,s]) / (pTechUse2cact.get((t,cp,r,y,s))*pTechCact2cout.get((t,cp,r,y,s)))) if (t,cp,r,y,s) in mvTechOut else 0) for cp in comm if (t,gp,cp) in mTechGroupComm));
# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
model.eqTechShareInpLo = Constraint(meqTechShareInpLo, rule = lambda model, t, r, g, c, y, s : model.vTechInp[t,c,r,y,s]  >=  pTechShareLo.get((t,c,r,y,s))*sum((model.vTechInp[t,cp,r,y,s] if (t,cp,r,y,s) in mvTechInp else 0) for cp in comm if (t,g,cp) in mTechGroupComm));
# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
model.eqTechShareInpUp = Constraint(meqTechShareInpUp, rule = lambda model, t, r, g, c, y, s : model.vTechInp[t,c,r,y,s] <=  pTechShareUp.get((t,c,r,y,s))*sum((model.vTechInp[t,cp,r,y,s] if (t,cp,r,y,s) in mvTechInp else 0) for cp in comm if (t,g,cp) in mTechGroupComm));
# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
model.eqTechShareOutLo = Constraint(meqTechShareOutLo, rule = lambda model, t, r, g, c, y, s : model.vTechOut[t,c,r,y,s]  >=  pTechShareLo.get((t,c,r,y,s))*sum((model.vTechOut[t,cp,r,y,s] if (t,cp,r,y,s) in mvTechOut else 0) for cp in comm if (t,g,cp) in mTechGroupComm));
# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
model.eqTechShareOutUp = Constraint(meqTechShareOutUp, rule = lambda model, t, r, g, c, y, s : model.vTechOut[t,c,r,y,s] <=  pTechShareUp.get((t,c,r,y,s))*sum((model.vTechOut[t,cp,r,y,s] if (t,cp,r,y,s) in mvTechOut else 0) for cp in comm if (t,g,cp) in mTechGroupComm));
# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
model.eqTechAInp = Constraint(mvTechAInp, rule = lambda model, t, c, r, y, s : model.vTechAInp[t,c,r,y,s]  ==  (model.vTechAct[t,r,y,s]*pTechAct2AInp.get((t,c,r,y,s)))+(model.vTechCap[t,r,y]*pTechCap2AInp.get((t,c,r,y,s)))+((model.vTechNewCap[t,r,y]*pTechNCap2AInp.get((t,c,r,y,s))) if (t,r,y) in mTechNew else 0)+sum(pTechCinp2AInp.get((t,c,cp,r,y,s))*model.vTechInp[t,cp,r,y,s] for cp in comm if (pTechCinp2AInp.get((t,c,cp,r,y,s))>0))+sum(pTechCout2AInp.get((t,c,cp,r,y,s))*model.vTechOut[t,cp,r,y,s] for cp in comm if (pTechCout2AInp.get((t,c,cp,r,y,s))>0)));
# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
model.eqTechAOut = Constraint(mvTechAOut, rule = lambda model, t, c, r, y, s : model.vTechAOut[t,c,r,y,s]  ==  (model.vTechAct[t,r,y,s]*pTechAct2AOut.get((t,c,r,y,s)))+(model.vTechCap[t,r,y]*pTechCap2AOut.get((t,c,r,y,s)))+((model.vTechNewCap[t,r,y]*pTechNCap2AOut.get((t,c,r,y,s))) if (t,r,y) in mTechNew else 0)+sum(pTechCinp2AOut.get((t,c,cp,r,y,s))*model.vTechInp[t,cp,r,y,s] for cp in comm if (pTechCinp2AOut.get((t,c,cp,r,y,s))>0))+sum(pTechCout2AOut.get((t,c,cp,r,y,s))*model.vTechOut[t,cp,r,y,s] for cp in comm if (pTechCout2AOut.get((t,c,cp,r,y,s))>0)));
# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
model.eqTechAfLo = Constraint(meqTechAfLo, rule = lambda model, t, r, y, s : pTechAfLo.get((t,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfLo.get((t,r,y,s)) <=  model.vTechAct[t,r,y,s]);
# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
model.eqTechAfUp = Constraint(meqTechAfUp, rule = lambda model, t, r, y, s : model.vTechAct[t,r,y,s] <=  pTechAfUp.get((t,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfUp.get((t,r,y,s)));
# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
model.eqTechAfsLo = Constraint(meqTechAfsLo, rule = lambda model, t, r, y, s : pTechAfsLo.get((t,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfsLo.get((t,r,y,s)) <=  sum((model.vTechAct[t,r,y,sp] if (t,r,y,sp) in mvTechAct else 0) for sp in slice if (s,sp) in mSliceParentChildE));
# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
model.eqTechAfsUp = Constraint(meqTechAfsUp, rule = lambda model, t, r, y, s : sum((model.vTechAct[t,r,y,sp] if (t,r,y,sp) in mvTechAct else 0) for sp in slice if (s,sp) in mSliceParentChildE) <=  pTechAfsUp.get((t,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfsUp.get((t,r,y,s)));
# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
model.eqTechActSng = Constraint(meqTechActSng, rule = lambda model, t, c, r, y, s : model.vTechAct[t,r,y,s]  ==  (model.vTechOut[t,c,r,y,s]) / (pTechCact2cout.get((t,c,r,y,s))));
# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
model.eqTechActGrp = Constraint(meqTechActGrp, rule = lambda model, t, g, r, y, s : model.vTechAct[t,r,y,s]  ==  sum((((model.vTechOut[t,c,r,y,s]) / (pTechCact2cout.get((t,c,r,y,s)))) if (t,c,r,y,s) in mvTechOut else 0) for c in comm if (t,g,c) in mTechGroupComm));
# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
model.eqTechAfcOutLo = Constraint(meqTechAfcOutLo, rule = lambda model, t, r, c, y, s : pTechCact2cout.get((t,c,r,y,s))*pTechAfcLo.get((t,c,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfcLo.get((t,c,r,y,s)) <=  model.vTechOut[t,c,r,y,s]);
# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
model.eqTechAfcOutUp = Constraint(meqTechAfcOutUp, rule = lambda model, t, r, c, y, s : model.vTechOut[t,c,r,y,s] <=  pTechCact2cout.get((t,c,r,y,s))*pTechAfcUp.get((t,c,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfcUp.get((t,c,r,y,s)));
# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
model.eqTechAfcInpLo = Constraint(meqTechAfcInpLo, rule = lambda model, t, r, c, y, s : pTechAfcLo.get((t,c,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfcLo.get((t,c,r,y,s)) <=  model.vTechInp[t,c,r,y,s]);
# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
model.eqTechAfcInpUp = Constraint(meqTechAfcInpUp, rule = lambda model, t, r, c, y, s : model.vTechInp[t,c,r,y,s] <=  pTechAfcUp.get((t,c,r,y,s))*pTechCap2act.get((t))*model.vTechCap[t,r,y]*pSliceShare.get((s))*paTechWeatherAfcUp.get((t,c,r,y,s)));
# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
model.eqTechCap = Constraint(mTechSpan, rule = lambda model, t, r, y : model.vTechCap[t,r,y]  ==  pTechStock.get((t,r,y))+sum(model.vTechNewCap[t,r,yp]-sum(model.vTechRetiredCap[t,r,yp,ye] for ye in year if ((t,r,yp,ye) in mvTechRetiredCap and ordYear.get((y)) >= ordYear.get((ye)))) for yp in year if ((t,r,yp) in mTechNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTechOlife.get((t,r))+ordYear.get((yp)) or (t,r) in mTechOlifeInf))));
# eqTechNewCap(tech, region, year)$meqTechNewCap(tech, region, year)
model.eqTechNewCap = Constraint(meqTechNewCap, rule = lambda model, t, r, y : sum(model.vTechRetiredCap[t,r,y,yp] for yp in year if (t,r,y,yp) in mvTechRetiredCap) <=  model.vTechNewCap[t,r,y]);
# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
model.eqTechEac = Constraint(mTechEac, rule = lambda model, t, r, y : model.vTechEac[t,r,y]  ==  sum(pTechEac.get((t,r,yp))*(model.vTechNewCap[t,r,yp]-sum(model.vTechRetiredCap[t,r,yp,ye] for ye in year if (t,r,yp,ye) in mvTechRetiredCap)) for yp in year if ((t,r,yp) in mTechNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTechOlife.get((t,r))+ordYear.get((yp)) or (t,r) in mTechOlifeInf))));
# eqTechInv(tech, region, year)$mTechNew(tech, region, year)
model.eqTechInv = Constraint(mTechNew, rule = lambda model, t, r, y : model.vTechInv[t,r,y]  ==  pTechInvcost.get((t,r,y))*model.vTechNewCap[t,r,y]);
# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
model.eqTechOMCost = Constraint(mTechOMCost, rule = lambda model, t, r, y : model.vTechOMCost[t,r,y]  ==  pTechFixom.get((t,r,y))*model.vTechCap[t,r,y]+sum(pTechVarom.get((t,r,y,s))*model.vTechAct[t,r,y,s]+sum(pTechCvarom.get((t,c,r,y,s))*model.vTechInp[t,c,r,y,s] for c in comm if (t,c) in mTechInpComm)+sum(pTechCvarom.get((t,c,r,y,s))*model.vTechOut[t,c,r,y,s] for c in comm if (t,c) in mTechOutComm)+sum(pTechAvarom.get((t,c,r,y,s))*model.vTechAOut[t,c,r,y,s] for c in comm if (t,c,r,y,s) in mvTechAOut)+sum(pTechAvarom.get((t,c,r,y,s))*model.vTechAInp[t,c,r,y,s] for c in comm if (t,c,r,y,s) in mvTechAInp) for s in slice if (t,s) in mTechSlice));
# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
model.eqSupAvaUp = Constraint(mSupAvaUp, rule = lambda model, s1, c, r, y, s : model.vSupOut[s1,c,r,y,s] <=  pSupAvaUp.get((s1,c,r,y,s))*paSupWeatherUp.get((s1,c,r,y,s)));
# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
model.eqSupAvaLo = Constraint(meqSupAvaLo, rule = lambda model, s1, c, r, y, s : model.vSupOut[s1,c,r,y,s]  >=  pSupAvaLo.get((s1,c,r,y,s))*paSupWeatherLo.get((s1,c,r,y,s)));
# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
model.eqSupTotal = Constraint(mvSupReserve, rule = lambda model, s1, c, r : model.vSupReserve[s1,c,r]  ==  sum(pPeriodLen.get((y))*model.vSupOut[s1,c,r,y,s] for y in year for s in slice if ((s1,c,r,y,s) in mSupAva and y in mMidMilestone)));
# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
model.eqSupReserveUp = Constraint(mSupReserveUp, rule = lambda model, s1, c, r : pSupReserveUp.get((s1,c,r))  >=  model.vSupReserve[s1,c,r]);
# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
model.eqSupReserveLo = Constraint(meqSupReserveLo, rule = lambda model, s1, c, r : model.vSupReserve[s1,c,r]  >=  pSupReserveLo.get((s1,c,r)));
# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
model.eqSupCost = Constraint(mvSupCost, rule = lambda model, s1, r, y : model.vSupCost[s1,r,y]  ==  sum(pSupCost.get((s1,c,r,y,s))*model.vSupOut[s1,c,r,y,s] for c in comm for s in slice if (s1,c,r,y,s) in mSupAva));
# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
model.eqDemInp = Constraint(mvDemInp, rule = lambda model, c, r, y, s : model.vDemInp[c,r,y,s]  ==  sum(pDemand.get((d,c,r,y,s)) for d in dem if (d,c) in mDemComm));
# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
model.eqAggOut = Constraint(mAggOut, rule = lambda model, c, r, y, s : model.vAggOut[c,r,y,s]  ==  sum(pAggregateFactor.get((c,cp))*sum(model.vOutTot[cp,r,y,sp] for sp in slice if ((cp,r,y,sp) in mvBalance and (s,sp) in mSliceParentChildE and (cp,sp) in mCommSlice)) for cp in comm if (c,cp) in mAggregateFactor));
# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
model.eqEmsFuelTot = Constraint(mEmsFuelTot, rule = lambda model, c, r, y, s : model.vEmsFuelTot[c,r,y,s]  ==  sum(pEmissionFactor.get((c,cp))*sum(pTechEmisComm.get((t,cp))*sum((model.vTechInp[t,cp,r,y,sp] if (t,c,cp,r,y,sp) in mTechEmsFuel else 0) for sp in slice if (c,s,sp) in mCommSliceOrParent) for t in tech if (t,cp) in mTechInpComm) for cp in comm if (pEmissionFactor.get((c,cp))>0)));
# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
model.eqStorageAInp = Constraint(mvStorageAInp, rule = lambda model, st1, c, r, y, s : model.vStorageAInp[st1,c,r,y,s]  ==  sum(pStorageStg2AInp.get((st1,c,r,y,s))*model.vStorageStore[st1,cp,r,y,s]+pStorageInp2AInp.get((st1,c,r,y,s))*model.vStorageInp[st1,cp,r,y,s]+pStorageOut2AInp.get((st1,c,r,y,s))*model.vStorageOut[st1,cp,r,y,s]+pStorageCap2AInp.get((st1,c,r,y,s))*model.vStorageCap[st1,r,y]+((pStorageNCap2AInp.get((st1,c,r,y,s))*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in mStorageNew else 0) for cp in comm if (st1,cp) in mStorageComm));
# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
model.eqStorageAOut = Constraint(mvStorageAOut, rule = lambda model, st1, c, r, y, s : model.vStorageAOut[st1,c,r,y,s]  ==  sum(pStorageStg2AOut.get((st1,c,r,y,s))*model.vStorageStore[st1,cp,r,y,s]+pStorageInp2AOut.get((st1,c,r,y,s))*model.vStorageInp[st1,cp,r,y,s]+pStorageOut2AOut.get((st1,c,r,y,s))*model.vStorageOut[st1,cp,r,y,s]+pStorageCap2AOut.get((st1,c,r,y,s))*model.vStorageCap[st1,r,y]+((pStorageNCap2AOut.get((st1,c,r,y,s))*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in mStorageNew else 0) for cp in comm if (st1,cp) in mStorageComm));
# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageStore = Constraint(mvStorageStore, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s]  ==  pStorageCharge.get((st1,c,r,y,s))+((pStorageNCap2Stg.get((st1,c,r,y,s))*model.vStorageNewCap[st1,r,y]) if (st1,r,y) in mStorageNew else 0)+sum(pStorageInpEff.get((st1,c,r,y,sp))*model.vStorageInp[st1,c,r,y,sp]+((pStorageStgEff.get((st1,c,r,y,s)))^(pSliceShare.get((s))))*model.vStorageStore[st1,c,r,y,sp]-(model.vStorageOut[st1,c,r,y,sp]) / (pStorageOutEff.get((st1,c,r,y,sp))) for sp in slice if ((c,sp) in mCommSlice and ((not((st1 in mStorageFullYear)) and (sp,s) in mSliceNext) or (st1 in mStorageFullYear and (sp,s) in mSliceFYearNext)))));
# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
model.eqStorageAfLo = Constraint(meqStorageAfLo, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s]  >=  pStorageAfLo.get((st1,r,y,s))*pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*paStorageWeatherAfLo.get((st1,c,r,y,s)));
# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
model.eqStorageAfUp = Constraint(meqStorageAfUp, rule = lambda model, st1, c, r, y, s : model.vStorageStore[st1,c,r,y,s] <=  pStorageAfUp.get((st1,r,y,s))*pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*paStorageWeatherAfUp.get((st1,c,r,y,s)));
# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageClean = Constraint(mvStorageStore, rule = lambda model, st1, c, r, y, s : (model.vStorageOut[st1,c,r,y,s]) / (pStorageOutEff.get((st1,c,r,y,s))) <=  model.vStorageStore[st1,c,r,y,s]);
# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
model.eqStorageInpUp = Constraint(meqStorageInpUp, rule = lambda model, st1, c, r, y, s : model.vStorageInp[st1,c,r,y,s] <=  pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*pStorageCinpUp.get((st1,c,r,y,s))*pSliceShare.get((s))*paStorageWeatherCinpUp.get((st1,c,r,y,s)));
# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
model.eqStorageInpLo = Constraint(meqStorageInpLo, rule = lambda model, st1, c, r, y, s : model.vStorageInp[st1,c,r,y,s]  >=  pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*pStorageCinpLo.get((st1,c,r,y,s))*pSliceShare.get((s))*paStorageWeatherCinpLo.get((st1,c,r,y,s)));
# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
model.eqStorageOutUp = Constraint(meqStorageOutUp, rule = lambda model, st1, c, r, y, s : model.vStorageOut[st1,c,r,y,s] <=  pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*pStorageCoutUp.get((st1,c,r,y,s))*pSliceShare.get((s))*paStorageWeatherCoutUp.get((st1,c,r,y,s)));
# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
model.eqStorageOutLo = Constraint(meqStorageOutLo, rule = lambda model, st1, c, r, y, s : model.vStorageOut[st1,c,r,y,s]  >=  pStorageCap2stg.get((st1))*model.vStorageCap[st1,r,y]*pStorageCoutLo.get((st1,c,r,y,s))*pSliceShare.get((s))*paStorageWeatherCoutLo.get((st1,c,r,y,s)));
# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
model.eqStorageCap = Constraint(mStorageSpan, rule = lambda model, st1, r, y : model.vStorageCap[st1,r,y]  ==  pStorageStock.get((st1,r,y))+sum(model.vStorageNewCap[st1,r,yp] for yp in year if (ordYear.get((y)) >= ordYear.get((yp)) and ((st1,r) in mStorageOlifeInf or ordYear.get((y))<pStorageOlife.get((st1,r))+ordYear.get((yp))) and (st1,r,yp) in mStorageNew)));
# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
model.eqStorageInv = Constraint(mStorageNew, rule = lambda model, st1, r, y : model.vStorageInv[st1,r,y]  ==  pStorageInvcost.get((st1,r,y))*model.vStorageNewCap[st1,r,y]);
# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
model.eqStorageEac = Constraint(mStorageEac, rule = lambda model, st1, r, y : model.vStorageEac[st1,r,y]  ==  sum(pStorageEac.get((st1,r,yp))*model.vStorageNewCap[st1,r,yp] for yp in year if ((st1,r,yp) in mStorageNew and ordYear.get((y)) >= ordYear.get((yp)) and ((st1,r) in mStorageOlifeInf or ordYear.get((y))<pStorageOlife.get((st1,r))+ordYear.get((yp))) and pStorageInvcost.get((st1,r,yp)) != 0)));
# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
model.eqStorageCost = Constraint(mStorageOMCost, rule = lambda model, st1, r, y : model.vStorageOMCost[st1,r,y]  ==  pStorageFixom.get((st1,r,y))*model.vStorageCap[st1,r,y]+sum(pStorageCostInp.get((st1,r,y,s))*model.vStorageInp[st1,c,r,y,s]+pStorageCostOut.get((st1,r,y,s))*model.vStorageOut[st1,c,r,y,s]+pStorageCostStore.get((st1,r,y,s))*model.vStorageStore[st1,c,r,y,s] for c in comm for s in slice if ((c,s) in mCommSlice and (st1,c) in mStorageComm)));
# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
model.eqImport = Constraint(mImport, rule = lambda model, c, dst, y, s : model.vImport[c,dst,y,s]  ==  sum(sum(sum(((pTradeIrEff.get((t1,src,dst,y,sp))*model.vTradeIr[t1,c,src,dst,y,sp]) if (t1,c,src,dst,y,sp) in mvTradeIr else 0) for src in region if (t1,src,dst) in mTradeRoutes) for t1 in trade if (t1,c) in mTradeComm)+sum((model.vImportRow[i,c,dst,y,sp] if (i,c,dst,y,sp) in mImportRow else 0) for i in imp if (i,c) in mImpComm) for sp in slice if (c,s,sp) in mCommSliceOrParent));
# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
model.eqExport = Constraint(mExport, rule = lambda model, c, src, y, s : model.vExport[c,src,y,s]  ==  sum(sum(sum((model.vTradeIr[t1,c,src,dst,y,sp] if (t1,c,src,dst,y,sp) in mvTradeIr else 0) for dst in region if (t1,src,dst) in mTradeRoutes) for t1 in trade if (t1,c) in mTradeComm)+sum((model.vExportRow[e,c,src,y,sp] if (e,c,src,y,sp) in mExportRow else 0) for e in expp if (e,c) in mExpComm) for sp in slice if (c,s,sp) in mCommSliceOrParent));
# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
model.eqTradeFlowUp = Constraint(meqTradeFlowUp, rule = lambda model, t1, c, src, dst, y, s : model.vTradeIr[t1,c,src,dst,y,s] <=  pTradeIrUp.get((t1,src,dst,y,s)));
# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
model.eqTradeFlowLo = Constraint(meqTradeFlowLo, rule = lambda model, t1, c, src, dst, y, s : model.vTradeIr[t1,c,src,dst,y,s]  >=  pTradeIrLo.get((t1,src,dst,y,s)));
# eqCostTrade(region, year)$mvTradeCost(region, year)
model.eqCostTrade = Constraint(mvTradeCost, rule = lambda model, r, y : model.vTradeCost[r,y]  ==  (model.vTradeRowCost[r,y] if (r,y) in mvTradeRowCost else 0)+(model.vTradeIrCost[r,y] if (r,y) in mvTradeIrCost else 0));
# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
model.eqCostRowTrade = Constraint(mvTradeRowCost, rule = lambda model, r, y : model.vTradeRowCost[r,y]  ==  sum(pImportRowPrice.get((i,r,y,s))*model.vImportRow[i,c,r,y,s] for i in imp for c in comm for s in slice if (i,c,r,y,s) in mImportRow)-sum(pExportRowPrice.get((e,r,y,s))*model.vExportRow[e,c,r,y,s] for e in expp for c in comm for s in slice if (e,c,r,y,s) in mExportRow));
# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
model.eqCostIrTrade = Constraint(mvTradeIrCost, rule = lambda model, r, y : model.vTradeIrCost[r,y]  ==  sum(model.vTradeEac[t1,r,y] for t1 in trade if (t1,r,y) in mTradeEac)+sum(sum(sum(((((pTradeIrCost.get((t1,src,r,y,s))+pTradeIrMarkup.get((t1,src,r,y,s)))*model.vTradeIr[t1,c,src,r,y,s])) if (t1,c,src,r,y,s) in mvTradeIr else 0) for s in slice if (t1,s) in mTradeSlice) for c in comm if (t1,c) in mTradeComm) for t1 in trade for src in region if (t1,src,r) in mTradeRoutes)-sum(sum(sum((((pTradeIrMarkup.get((t1,r,dst,y,s))*model.vTradeIr[t1,c,r,dst,y,s])) if (t1,c,r,dst,y,s) in mvTradeIr else 0) for s in slice if (t1,s) in mTradeSlice) for c in comm if (t1,c) in mTradeComm) for t1 in trade for dst in region if (t1,r,dst) in mTradeRoutes));
# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
model.eqExportRowUp = Constraint(mExportRowUp, rule = lambda model, e, c, r, y, s : model.vExportRow[e,c,r,y,s] <=  pExportRowUp.get((e,r,y,s)));
# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
model.eqExportRowLo = Constraint(meqExportRowLo, rule = lambda model, e, c, r, y, s : model.vExportRow[e,c,r,y,s]  >=  pExportRowLo.get((e,r,y,s)));
# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
model.eqExportRowCumulative = Constraint(mExpComm, rule = lambda model, e, c : model.vExportRowAccumulated[e,c]  ==  sum(pPeriodLen.get((y))*model.vExportRow[e,c,r,y,s] for r in region for y in year for s in slice if (y in mMidMilestone and (e,c,r,y,s) in mExportRow)));
# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
model.eqExportRowResUp = Constraint(mExportRowAccumulatedUp, rule = lambda model, e, c : model.vExportRowAccumulated[e,c] <=  pExportRowRes.get((e)));
# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
model.eqImportRowUp = Constraint(mImportRowUp, rule = lambda model, i, c, r, y, s : model.vImportRow[i,c,r,y,s] <=  pImportRowUp.get((i,r,y,s)));
# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
model.eqImportRowLo = Constraint(meqImportRowLo, rule = lambda model, i, c, r, y, s : model.vImportRow[i,c,r,y,s]  >=  pImportRowLo.get((i,r,y,s)));
# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
model.eqImportRowAccumulated = Constraint(mImpComm, rule = lambda model, i, c : model.vImportRowAccumulated[i,c]  ==  sum(pPeriodLen.get((y))*model.vImportRow[i,c,r,y,s] for r in region for y in year for s in slice if (i,c,r,y,s) in mImportRow));
# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
model.eqImportRowResUp = Constraint(mImportRowAccumulatedUp, rule = lambda model, i, c : model.vImportRowAccumulated[i,c] <=  pImportRowRes.get((i)));
# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
model.eqTradeCapFlow = Constraint(meqTradeCapFlow, rule = lambda model, t1, c, y, s : pSliceShare.get((s))*pTradeCap2Act.get((t1))*model.vTradeCap[t1,y]  >=  sum(model.vTradeIr[t1,c,src,dst,y,s] for src in region for dst in region if (t1,c,src,dst,y,s) in mvTradeIr));
# eqTradeCap(trade, year)$mvTradeCap(trade, year)
model.eqTradeCap = Constraint(mvTradeCap, rule = lambda model, t1, y : model.vTradeCap[t1,y]  ==  pTradeStock.get((t1,y))+sum(model.vTradeNewCap[t1,yp] for yp in year if ((t1,yp) in mvTradeNewCap and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTradeOlife.get((t1))+ordYear.get((yp)) or t1 in mTradeOlifeInf))));
# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
model.eqTradeInv = Constraint(mTradeInv, rule = lambda model, t1, r, y : model.vTradeInv[t1,r,y]  ==  pTradeInvcost.get((t1,r,y))*model.vTradeNewCap[t1,y]);
# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
model.eqTradeEac = Constraint(mTradeEac, rule = lambda model, t1, r, y : model.vTradeEac[t1,r,y]  ==  sum(pTradeEac.get((t1,r,yp))*model.vTradeNewCap[t1,yp] for yp in year if ((t1,yp) in mvTradeNewCap and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTradeOlife.get((t1))+ordYear.get((yp)) or t1 in mTradeOlifeInf))));
# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
model.eqTradeIrAInp = Constraint(mvTradeIrAInp, rule = lambda model, t1, c, r, y, s : model.vTradeIrAInp[t1,c,r,y,s]  ==  sum(pTradeIrCsrc2Ainp.get((t1,c,r,dst,y,s))*sum(model.vTradeIr[t1,cp,r,dst,y,s] for cp in comm if (t1,cp) in mTradeComm) for dst in region if (t1,r,dst,y,s) in mTradeIr)+sum(pTradeIrCdst2Ainp.get((t1,c,src,r,y,s))*sum(model.vTradeIr[t1,cp,src,r,y,s] for cp in comm if (t1,cp) in mTradeComm) for src in region if (t1,src,r,y,s) in mTradeIr));
# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
model.eqTradeIrAOut = Constraint(mvTradeIrAOut, rule = lambda model, t1, c, r, y, s : model.vTradeIrAOut[t1,c,r,y,s]  ==  sum(pTradeIrCsrc2Aout.get((t1,c,r,dst,y,s))*sum(model.vTradeIr[t1,cp,r,dst,y,s] for cp in comm if (t1,cp) in mTradeComm) for dst in region if (t1,r,dst,y,s) in mTradeIr)+sum(pTradeIrCdst2Aout.get((t1,c,src,r,y,s))*sum(model.vTradeIr[t1,cp,src,r,y,s] for cp in comm if (t1,cp) in mTradeComm) for src in region if (t1,src,r,y,s) in mTradeIr));
# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
model.eqTradeIrAInpTot = Constraint(mvTradeIrAInpTot, rule = lambda model, c, r, y, s : model.vTradeIrAInpTot[c,r,y,s]  ==  sum(model.vTradeIrAInp[t1,c,r,y,sp] for t1 in trade for sp in slice if ((c,s,sp) in mCommSliceOrParent and (t1,c,r,y,sp) in mvTradeIrAInp)));
# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
model.eqTradeIrAOutTot = Constraint(mvTradeIrAOutTot, rule = lambda model, c, r, y, s : model.vTradeIrAOutTot[c,r,y,s]  ==  sum(model.vTradeIrAOut[t1,c,r,y,sp] for t1 in trade for sp in slice if ((c,s,sp) in mCommSliceOrParent and (t1,c,r,y,sp) in mvTradeIrAOut)));
# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
model.eqBalLo = Constraint(meqBalLo, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  >=  0);
# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
model.eqBalUp = Constraint(meqBalUp, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s] <=  0);
# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
model.eqBalFx = Constraint(meqBalFx, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  ==  0);
# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqBal = Constraint(mvBalance, rule = lambda model, c, r, y, s : model.vBalance[c,r,y,s]  ==  model.vOutTot[c,r,y,s]-model.vInpTot[c,r,y,s]);
# eqOutTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqOutTot = Constraint(mvBalance, rule = lambda model, c, r, y, s : model.vOutTot[c,r,y,s]  ==  (model.vDummyImport[c,r,y,s] if (c,r,y,s) in mDummyImport else 0)+(model.vSupOutTot[c,r,y,s] if (c,r,y,s) in mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,s] if (c,r,y,s) in mEmsFuelTot else 0)+(model.vAggOut[c,r,y,s] if (c,r,y,s) in mAggOut else 0)+(model.vTechOutTot[c,r,y,s] if (c,r,y,s) in mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,s] if (c,r,y,s) in mStorageOutTot else 0)+(model.vImport[c,r,y,s] if (c,r,y,s) in mImport else 0)+(model.vTradeIrAOutTot[c,r,y,s] if (c,r,y,s) in mvTradeIrAOutTot else 0)+sum(model.vOut2Lo[c,r,y,sp,s] for sp in slice if ((sp,s) in mSliceParentChild and (c,r,y,sp,s) in mvOut2Lo)));
# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
model.eqOut2Lo = Constraint(mOut2Lo, rule = lambda model, c, r, y, s : sum(model.vOut2Lo[c,r,y,s,sp] for sp in slice if ((s,sp) in mSliceParentChild and (c,r,y,s,sp) in mvOut2Lo))  ==  (model.vSupOutTot[c,r,y,s] if (c,r,y,s) in mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,s] if (c,r,y,s) in mEmsFuelTot else 0)+(model.vAggOut[c,r,y,s] if (c,r,y,s) in mAggOut else 0)+(model.vTechOutTot[c,r,y,s] if (c,r,y,s) in mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,s] if (c,r,y,s) in mStorageOutTot else 0)+(model.vImport[c,r,y,s] if (c,r,y,s) in mImport else 0)+(model.vTradeIrAOutTot[c,r,y,s] if (c,r,y,s) in mvTradeIrAOutTot else 0));
# eqInpTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqInpTot = Constraint(mvBalance, rule = lambda model, c, r, y, s : model.vInpTot[c,r,y,s]  ==  (model.vDemInp[c,r,y,s] if (c,r,y,s) in mvDemInp else 0)+(model.vDummyExport[c,r,y,s] if (c,r,y,s) in mDummyExport else 0)+(model.vTechInpTot[c,r,y,s] if (c,r,y,s) in mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,s] if (c,r,y,s) in mStorageInpTot else 0)+(model.vExport[c,r,y,s] if (c,r,y,s) in mExport else 0)+(model.vTradeIrAInpTot[c,r,y,s] if (c,r,y,s) in mvTradeIrAInpTot else 0)+sum(model.vInp2Lo[c,r,y,sp,s] for sp in slice if ((sp,s) in mSliceParentChild and (c,r,y,sp,s) in mvInp2Lo)));
# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
model.eqInp2Lo = Constraint(mInp2Lo, rule = lambda model, c, r, y, s : sum(model.vInp2Lo[c,r,y,s,sp] for sp in slice if ((s,sp) in mSliceParentChild and (c,r,y,s,sp) in mvInp2Lo))  ==  (model.vTechInpTot[c,r,y,s] if (c,r,y,s) in mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,s] if (c,r,y,s) in mStorageInpTot else 0)+(model.vExport[c,r,y,s] if (c,r,y,s) in mExport else 0)+(model.vTradeIrAInpTot[c,r,y,s] if (c,r,y,s) in mvTradeIrAInpTot else 0));
# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
model.eqSupOutTot = Constraint(mSupOutTot, rule = lambda model, c, r, y, s : model.vSupOutTot[c,r,y,s]  ==  sum(sum((model.vSupOut[s1,c,r,y,sp] if (s1,c,r,y,sp) in mSupAva else 0) for sp in slice if (c,s,sp) in mCommSliceOrParent) for s1 in sup if (s1,c) in mSupComm));
# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
model.eqTechInpTot = Constraint(mTechInpTot, rule = lambda model, c, r, y, s : model.vTechInpTot[c,r,y,s]  ==  sum(sum((model.vTechInp[t,c,r,y,sp] if (t,c,r,y,sp) in mvTechInp else 0) for sp in slice if ((t,sp) in mTechSlice and (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechInpComm)+sum(sum((model.vTechAInp[t,c,r,y,sp] if (t,c,r,y,sp) in mvTechAInp else 0) for sp in slice if ((t,sp) in mTechSlice and (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechAInp));
# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
model.eqTechOutTot = Constraint(mTechOutTot, rule = lambda model, c, r, y, s : model.vTechOutTot[c,r,y,s]  ==  sum(sum((model.vTechOut[t,c,r,y,sp] if (t,c,r,y,sp) in mvTechOut else 0) for sp in slice if ((t,sp) in mTechSlice and (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechOutComm)+sum(sum((model.vTechAOut[t,c,r,y,sp] if (t,c,r,y,sp) in mvTechAOut else 0) for sp in slice if ((t,sp) in mTechSlice and (c,s,sp) in mCommSliceOrParent)) for t in tech if (t,c) in mTechAOut));
# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
model.eqStorageInpTot = Constraint(mStorageInpTot, rule = lambda model, c, r, y, s : model.vStorageInpTot[c,r,y,s]  ==  sum(model.vStorageInp[st1,c,r,y,s] for st1 in stg if (st1,c,r,y,s) in mvStorageStore)+sum(model.vStorageAInp[st1,c,r,y,s] for st1 in stg if (st1,c,r,y,s) in mvStorageAInp));
# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
model.eqStorageOutTot = Constraint(mStorageOutTot, rule = lambda model, c, r, y, s : model.vStorageOutTot[c,r,y,s]  ==  sum(model.vStorageOut[st1,c,r,y,s] for st1 in stg if (st1,c,r,y,s) in mvStorageStore)+sum(model.vStorageAOut[st1,c,r,y,s] for st1 in stg if (st1,c,r,y,s) in mvStorageAOut));
# eqCost(region, year)$mvTotalCost(region, year)
model.eqCost = Constraint(mvTotalCost, rule = lambda model, r, y : model.vTotalCost[r,y]  ==  sum(model.vTechEac[t,r,y] for t in tech if (t,r,y) in mTechEac)+sum(model.vTechOMCost[t,r,y] for t in tech if (t,r,y) in mTechOMCost)+sum(model.vSupCost[s1,r,y] for s1 in sup if (s1,r,y) in mvSupCost)+sum(pDummyImportCost.get((c,r,y,s))*model.vDummyImport[c,r,y,s] for c in comm for s in slice if (c,r,y,s) in mDummyImport)+sum(pDummyExportCost.get((c,r,y,s))*model.vDummyExport[c,r,y,s] for c in comm for s in slice if (c,r,y,s) in mDummyExport)+sum(model.vTaxCost[c,r,y] for c in comm if (c,r,y) in mTaxCost)-sum(model.vSubsCost[c,r,y] for c in comm if (c,r,y) in mSubsCost)+sum(model.vStorageOMCost[st1,r,y] for st1 in stg if (st1,r,y) in mStorageOMCost)+sum(model.vStorageEac[st1,r,y] for st1 in stg if (st1,r,y) in mStorageEac)+(model.vTradeCost[r,y] if (r,y) in mvTradeCost else 0));
# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
model.eqTaxCost = Constraint(mTaxCost, rule = lambda model, c, r, y : model.vTaxCost[c,r,y]  ==  sum(pTaxCost.get((c,r,y,s))*model.vOutTot[c,r,y,s] for s in slice if (c,s) in mCommSlice));
# eqSubsCost(comm, region, year)$mSubsCost(comm, region, year)
model.eqSubsCost = Constraint(mSubsCost, rule = lambda model, c, r, y : model.vSubsCost[c,r,y]  ==  sum(pSubsCost.get((c,r,y,s))*model.vOutTot[c,r,y,s] for s in slice if (c,s) in mCommSlice));
# eqObjective
model.eqObjective = Constraint(rule = lambda model : model.vObjective  ==  sum(model.vTotalCost[r,y]*sum(pDiscountFactor.get((r,yn)) for ye in year for yp in year for yn in year if ((y,yp) in mStartMilestone and (y,ye) in mEndMilestone and ordYear.get((yn)) >= ordYear.get((yp)) and ordYear.get((yn)) <= ordYear.get((ye)))) for r in region for y in year if (r,y) in mvTotalCost));
# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
model.eqLECActivity = Constraint(meqLECActivity, rule = lambda model, t, r, y : sum(model.vTechAct[t,r,y,s] for s in slice if (t,s) in mTechSlice)  >=  pLECLoACT.get((r)));
model.obj = Objective(rule = lambda model: model.vObjective, sense = minimize);
print("Equation finish ", round(time.time() - seconds, 2))
opt = SolverFactory('cplex');
opt.solve(model)
print("Solving finish ", round(time.time() - seconds, 2));
flist = open("output/variable_list.csv","w");
flist.write("value\n");
flist.write("vTechInv\n");
f = open("output/vTechInv.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechNew:
    if model.vTechInv[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechInv[(t,r,y)].value) + "\n")
f.close()
flist.write("vTechEac\n");
f = open("output/vTechEac.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechEac:
    if model.vTechEac[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechEac[(t,r,y)].value) + "\n")
f.close()
flist.write("vTechOMCost\n");
f = open("output/vTechOMCost.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechOMCost:
    if model.vTechOMCost[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechOMCost[(t,r,y)].value) + "\n")
f.close()
flist.write("vSupCost\n");
f = open("output/vSupCost.csv","w");
f.write("sup,region,year,value\n");
for (s1,r,y) in mvSupCost:
    if model.vSupCost[(s1,r,y)].value != 0:
        f.write(str(s1) + "," + str(r) + "," + str(y) + "," +  str(model.vSupCost[(s1,r,y)].value) + "\n")
f.close()
flist.write("vEmsFuelTot\n");
f = open("output/vEmsFuelTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mEmsFuelTot:
    if model.vEmsFuelTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vEmsFuelTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vBalance\n");
f = open("output/vBalance.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvBalance:
    if model.vBalance[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vBalance[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vTotalCost\n");
f = open("output/vTotalCost.csv","w");
f.write("region,year,value\n");
for (r,y) in mvTotalCost:
    if model.vTotalCost[(r,y)].value != 0:
        f.write(str(r) + "," + str(y) + "," +  str(model.vTotalCost[(r,y)].value) + "\n")
f.close()
flist.write("vObjective\n");
f = open("output/vObjective.csv","w");
f.write("value\n" + str(model.vObjective.value) + "\n");
f.close()
flist.write("vTaxCost\n");
f = open("output/vTaxCost.csv","w");
f.write("comm,region,year,value\n");
for (c,r,y) in mTaxCost:
    if model.vTaxCost[(c,r,y)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," +  str(model.vTaxCost[(c,r,y)].value) + "\n")
f.close()
flist.write("vSubsCost\n");
f = open("output/vSubsCost.csv","w");
f.write("comm,region,year,value\n");
for (c,r,y) in mSubsCost:
    if model.vSubsCost[(c,r,y)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," +  str(model.vSubsCost[(c,r,y)].value) + "\n")
f.close()
flist.write("vAggOut\n");
f = open("output/vAggOut.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mAggOut:
    if model.vAggOut[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vAggOut[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageOMCost\n");
f = open("output/vStorageOMCost.csv","w");
f.write("stg,region,year,value\n");
for (st1,r,y) in mStorageOMCost:
    if model.vStorageOMCost[(st1,r,y)].value != 0:
        f.write(str(st1) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageOMCost[(st1,r,y)].value) + "\n")
f.close()
flist.write("vTradeCost\n");
f = open("output/vTradeCost.csv","w");
f.write("region,year,value\n");
for (r,y) in mvTradeCost:
    if model.vTradeCost[(r,y)].value != 0:
        f.write(str(r) + "," + str(y) + "," +  str(model.vTradeCost[(r,y)].value) + "\n")
f.close()
flist.write("vTradeRowCost\n");
f = open("output/vTradeRowCost.csv","w");
f.write("region,year,value\n");
for (r,y) in mvTradeRowCost:
    if model.vTradeRowCost[(r,y)].value != 0:
        f.write(str(r) + "," + str(y) + "," +  str(model.vTradeRowCost[(r,y)].value) + "\n")
f.close()
flist.write("vTradeIrCost\n");
f = open("output/vTradeIrCost.csv","w");
f.write("region,year,value\n");
for (r,y) in mvTradeIrCost:
    if model.vTradeIrCost[(r,y)].value != 0:
        f.write(str(r) + "," + str(y) + "," +  str(model.vTradeIrCost[(r,y)].value) + "\n")
f.close()
flist.write("vTechNewCap\n");
f = open("output/vTechNewCap.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechNew:
    if model.vTechNewCap[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechNewCap[(t,r,y)].value) + "\n")
f.close()
flist.write("vTechRetiredCap\n");
f = open("output/vTechRetiredCap.csv","w");
f.write("tech,region,year,yearp,value\n");
for (t,r,y,yp) in mvTechRetiredCap:
    if model.vTechRetiredCap[(t,r,y,yp)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," + str(yp) + "," +  str(model.vTechRetiredCap[(t,r,y,yp)].value) + "\n")
f.close()
flist.write("vTechCap\n");
f = open("output/vTechCap.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechSpan:
    if model.vTechCap[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechCap[(t,r,y)].value) + "\n")
f.close()
flist.write("vTechAct\n");
f = open("output/vTechAct.csv","w");
f.write("tech,region,year,slice,value\n");
for (t,r,y,s) in mvTechAct:
    if model.vTechAct[(t,r,y,s)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechAct[(t,r,y,s)].value) + "\n")
f.close()
flist.write("vTechInp\n");
f = open("output/vTechInp.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (t,c,r,y,s) in mvTechInp:
    if model.vTechInp[(t,c,r,y,s)].value != 0:
        f.write(str(t) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechInp[(t,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTechOut\n");
f = open("output/vTechOut.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (t,c,r,y,s) in mvTechOut:
    if model.vTechOut[(t,c,r,y,s)].value != 0:
        f.write(str(t) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechOut[(t,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTechAInp\n");
f = open("output/vTechAInp.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (t,c,r,y,s) in mvTechAInp:
    if model.vTechAInp[(t,c,r,y,s)].value != 0:
        f.write(str(t) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechAInp[(t,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTechAOut\n");
f = open("output/vTechAOut.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (t,c,r,y,s) in mvTechAOut:
    if model.vTechAOut[(t,c,r,y,s)].value != 0:
        f.write(str(t) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechAOut[(t,c,r,y,s)].value) + "\n")
f.close()
flist.write("vSupOut\n");
f = open("output/vSupOut.csv","w");
f.write("sup,comm,region,year,slice,value\n");
for (s1,c,r,y,s) in mSupAva:
    if model.vSupOut[(s1,c,r,y,s)].value != 0:
        f.write(str(s1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vSupOut[(s1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vSupReserve\n");
f = open("output/vSupReserve.csv","w");
f.write("sup,comm,region,value\n");
for (s1,c,r) in mvSupReserve:
    if model.vSupReserve[(s1,c,r)].value != 0:
        f.write(str(s1) + "," + str(c) + "," + str(r) + "," +  str(model.vSupReserve[(s1,c,r)].value) + "\n")
f.close()
flist.write("vDemInp\n");
f = open("output/vDemInp.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvDemInp:
    if model.vDemInp[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vDemInp[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vOutTot\n");
f = open("output/vOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvBalance:
    if model.vOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vInpTot\n");
f = open("output/vInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvBalance:
    if model.vInpTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vInpTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vInp2Lo\n");
f = open("output/vInp2Lo.csv","w");
f.write("comm,region,year,slice,slicep,value\n");
for (c,r,y,s,sp) in mvInp2Lo:
    if model.vInp2Lo[(c,r,y,s,sp)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," + str(sp) + "," +  str(model.vInp2Lo[(c,r,y,s,sp)].value) + "\n")
f.close()
flist.write("vOut2Lo\n");
f = open("output/vOut2Lo.csv","w");
f.write("comm,region,year,slice,slicep,value\n");
for (c,r,y,s,sp) in mvOut2Lo:
    if model.vOut2Lo[(c,r,y,s,sp)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," + str(sp) + "," +  str(model.vOut2Lo[(c,r,y,s,sp)].value) + "\n")
f.close()
flist.write("vSupOutTot\n");
f = open("output/vSupOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mSupOutTot:
    if model.vSupOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vSupOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vTechInpTot\n");
f = open("output/vTechInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mTechInpTot:
    if model.vTechInpTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechInpTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vTechOutTot\n");
f = open("output/vTechOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mTechOutTot:
    if model.vTechOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTechOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageInpTot\n");
f = open("output/vStorageInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mStorageInpTot:
    if model.vStorageInpTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageInpTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageOutTot\n");
f = open("output/vStorageOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mStorageOutTot:
    if model.vStorageOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageAInp\n");
f = open("output/vStorageAInp.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (st1,c,r,y,s) in mvStorageAInp:
    if model.vStorageAInp[(st1,c,r,y,s)].value != 0:
        f.write(str(st1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageAInp[(st1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageAOut\n");
f = open("output/vStorageAOut.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (st1,c,r,y,s) in mvStorageAOut:
    if model.vStorageAOut[(st1,c,r,y,s)].value != 0:
        f.write(str(st1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageAOut[(st1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vDummyImport\n");
f = open("output/vDummyImport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mDummyImport:
    if model.vDummyImport[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vDummyImport[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vDummyExport\n");
f = open("output/vDummyExport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mDummyExport:
    if model.vDummyExport[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vDummyExport[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageInp\n");
f = open("output/vStorageInp.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (st1,c,r,y,s) in mvStorageStore:
    if model.vStorageInp[(st1,c,r,y,s)].value != 0:
        f.write(str(st1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageInp[(st1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageOut\n");
f = open("output/vStorageOut.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (st1,c,r,y,s) in mvStorageStore:
    if model.vStorageOut[(st1,c,r,y,s)].value != 0:
        f.write(str(st1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageOut[(st1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageStore\n");
f = open("output/vStorageStore.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (st1,c,r,y,s) in mvStorageStore:
    if model.vStorageStore[(st1,c,r,y,s)].value != 0:
        f.write(str(st1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vStorageStore[(st1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vStorageInv\n");
f = open("output/vStorageInv.csv","w");
f.write("stg,region,year,value\n");
for (st1,r,y) in mStorageNew:
    if model.vStorageInv[(st1,r,y)].value != 0:
        f.write(str(st1) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageInv[(st1,r,y)].value) + "\n")
f.close()
flist.write("vStorageEac\n");
f = open("output/vStorageEac.csv","w");
f.write("stg,region,year,value\n");
for (st1,r,y) in mStorageEac:
    if model.vStorageEac[(st1,r,y)].value != 0:
        f.write(str(st1) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageEac[(st1,r,y)].value) + "\n")
f.close()
flist.write("vStorageCap\n");
f = open("output/vStorageCap.csv","w");
f.write("stg,region,year,value\n");
for (st1,r,y) in mStorageSpan:
    if model.vStorageCap[(st1,r,y)].value != 0:
        f.write(str(st1) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageCap[(st1,r,y)].value) + "\n")
f.close()
flist.write("vStorageNewCap\n");
f = open("output/vStorageNewCap.csv","w");
f.write("stg,region,year,value\n");
for (st1,r,y) in mStorageNew:
    if model.vStorageNewCap[(st1,r,y)].value != 0:
        f.write(str(st1) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageNewCap[(st1,r,y)].value) + "\n")
f.close()
flist.write("vImport\n");
f = open("output/vImport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mImport:
    if model.vImport[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vImport[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vExport\n");
f = open("output/vExport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mExport:
    if model.vExport[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vExport[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vTradeIr\n");
f = open("output/vTradeIr.csv","w");
f.write("trade,comm,region,regionp,year,slice,value\n");
for (t1,c,r,rp,y,s) in mvTradeIr:
    if model.vTradeIr[(t1,c,r,rp,y,s)].value != 0:
        f.write(str(t1) + "," + str(c) + "," + str(r) + "," + str(rp) + "," + str(y) + "," + str(s) + "," +  str(model.vTradeIr[(t1,c,r,rp,y,s)].value) + "\n")
f.close()
flist.write("vTradeIrAInp\n");
f = open("output/vTradeIrAInp.csv","w");
f.write("trade,comm,region,year,slice,value\n");
for (t1,c,r,y,s) in mvTradeIrAInp:
    if model.vTradeIrAInp[(t1,c,r,y,s)].value != 0:
        f.write(str(t1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTradeIrAInp[(t1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTradeIrAInpTot\n");
f = open("output/vTradeIrAInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvTradeIrAInpTot:
    if model.vTradeIrAInpTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTradeIrAInpTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vTradeIrAOut\n");
f = open("output/vTradeIrAOut.csv","w");
f.write("trade,comm,region,year,slice,value\n");
for (t1,c,r,y,s) in mvTradeIrAOut:
    if model.vTradeIrAOut[(t1,c,r,y,s)].value != 0:
        f.write(str(t1) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTradeIrAOut[(t1,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTradeIrAOutTot\n");
f = open("output/vTradeIrAOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvTradeIrAOutTot:
    if model.vTradeIrAOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vTradeIrAOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vExportRowAccumulated\n");
f = open("output/vExportRowAccumulated.csv","w");
f.write("expp,comm,value\n");
for (e,c) in mExpComm:
    if model.vExportRowAccumulated[(e,c)].value != 0:
        f.write(str(e) + "," + str(c) + "," +  str(model.vExportRowAccumulated[(e,c)].value) + "\n")
f.close()
flist.write("vExportRow\n");
f = open("output/vExportRow.csv","w");
f.write("expp,comm,region,year,slice,value\n");
for (e,c,r,y,s) in mExportRow:
    if model.vExportRow[(e,c,r,y,s)].value != 0:
        f.write(str(e) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vExportRow[(e,c,r,y,s)].value) + "\n")
f.close()
flist.write("vImportRowAccumulated\n");
f = open("output/vImportRowAccumulated.csv","w");
f.write("imp,comm,value\n");
for (i,c) in mImpComm:
    if model.vImportRowAccumulated[(i,c)].value != 0:
        f.write(str(i) + "," + str(c) + "," +  str(model.vImportRowAccumulated[(i,c)].value) + "\n")
f.close()
flist.write("vImportRow\n");
f = open("output/vImportRow.csv","w");
f.write("imp,comm,region,year,slice,value\n");
for (i,c,r,y,s) in mImportRow:
    if model.vImportRow[(i,c,r,y,s)].value != 0:
        f.write(str(i) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vImportRow[(i,c,r,y,s)].value) + "\n")
f.close()
flist.write("vTradeCap\n");
f = open("output/vTradeCap.csv","w");
f.write("trade,year,value\n");
for (t1,y) in mvTradeCap:
    if model.vTradeCap[(t1,y)].value != 0:
        f.write(str(t1) + "," + str(y) + "," +  str(model.vTradeCap[(t1,y)].value) + "\n")
f.close()
flist.write("vTradeInv\n");
f = open("output/vTradeInv.csv","w");
f.write("trade,region,year,value\n");
for (t1,r,y) in mTradeEac:
    if model.vTradeInv[(t1,r,y)].value != 0:
        f.write(str(t1) + "," + str(r) + "," + str(y) + "," +  str(model.vTradeInv[(t1,r,y)].value) + "\n")
f.close()
flist.write("vTradeEac\n");
f = open("output/vTradeEac.csv","w");
f.write("trade,region,year,value\n");
for (t1,r,y) in mTradeEac:
    if model.vTradeEac[(t1,r,y)].value != 0:
        f.write(str(t1) + "," + str(r) + "," + str(y) + "," +  str(model.vTradeEac[(t1,r,y)].value) + "\n")
f.close()
flist.write("vTradeNewCap\n");
f = open("output/vTradeNewCap.csv","w");
f.write("trade,year,value\n");
for (t1,y) in mvTradeNewCap:
    if model.vTradeNewCap[(t1,y)].value != 0:
        f.write(str(t1) + "," + str(y) + "," +  str(model.vTradeNewCap[(t1,y)].value) + "\n")
f.close()
f = open("output/raw_data_set.csv","w");
f.write('set,value\n')
for i in tech:
    f.write('tech,' + str(i) + '\n')
for i in sup:
    f.write('sup,' + str(i) + '\n')
for i in dem:
    f.write('dem,' + str(i) + '\n')
for i in stg:
    f.write('stg,' + str(i) + '\n')
for i in expp:
    f.write('expp,' + str(i) + '\n')
for i in imp:
    f.write('imp,' + str(i) + '\n')
for i in trade:
    f.write('trade,' + str(i) + '\n')
for i in group:
    f.write('group,' + str(i) + '\n')
for i in comm:
    f.write('comm,' + str(i) + '\n')
for i in region:
    f.write('region,' + str(i) + '\n')
for i in year:
    f.write('year,' + str(i) + '\n')
for i in slice:
    f.write('slice,' + str(i) + '\n')
for i in weather:
    f.write('weather,' + str(i) + '\n')
f.close()
f = open("output/pStat.csv",'w');
f.write("value\n1.00\n");
f.close();
f = open("output/pFinish.csv",'w');
f.write("value\n2.00\n");
f.close();
flist.close();
