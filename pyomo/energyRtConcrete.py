verbose = True
import datetime
print("start time: " + str(datetime.datetime.now().strftime("%H:%M:%S")) + "\n")
flog = open('output/log.csv', 'w')
flog.write('parameter,value,time\n')
flog.write('"model language",PyomoConcrete,"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
flog.write('"load data",,"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
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
exec(open("inc1.py").read())
model = ConcreteModel()
import pandas as pd
import sqlite3
con = sqlite3.connect("input/data.db")
def read_set(name):
    tbl = pd.read_sql_query("SELECT * from " + name, con)
    if tbl.shape[1] > 1:
        return tbl.to_records(index=False).tolist()
    else:
        return list(tbl.iloc[:,0])
def read_dict(name):
    tbl = pd.read_sql_query("SELECT * from " + name, con)
    if tbl.shape[1] > 2:
        idx = pd.MultiIndex.from_frame(tbl.drop(columns = "value"))
    else:
        idx = tbl.iloc[:,0].tolist()
    tbl = pd.DataFrame(tbl.value.tolist(), index = idx, columns = ["value"])
    return tbl.to_dict()["value"]
##### decl par #####
print("variables... " + str(datetime.datetime.now().strftime("%H:%M:%S")) + " (" + str(round(time.time() - seconds, 2)) + " s)")
model.vTechInv = Var(mTechInv, doc = "Overnight investment costs");
model.vTechEac = Var(mTechEac, doc = "Annualized investment costs");
model.vTechOMCost = Var(mTechOMCost, doc = "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)");
model.vSupCost = Var(mvSupCost, doc = "Supply costs");
model.vEmsFuelTot = Var(mEmsFuelTot, doc = "Total emissions from fuels combustion");
model.vBalance = Var(mvBalance, doc = "Net commodity balance");
model.vTotalCost = Var(mvTotalCost, doc = "Regional annual total costs");
model.vObjective = Var(doc = "Objective costs");
model.vTaxCost = Var(mTaxCost, doc = "Total tax levies (tax costs)");
model.vSubsCost = Var(mSubCost, doc = "Total subsidies (for substraction from costs)");
model.vAggOut = Var(mAggOut, doc = "Aggregated commodity output");
model.vStorageOMCost = Var(mStorageOMCost, doc = "Storage O&M costs");
model.vTradeCost = Var(mvTradeCost, doc = "Total trade costs");
model.vTradeRowCost = Var(mvTradeRowCost, doc = "Trade with ROW costs");
model.vTradeIrCost = Var(mvTradeIrCost, doc = "Interregional trade costs");
model.vTechNewCap = Var(mTechNew, domain = pyo.NonNegativeReals, doc = "New capacity");
model.vTechRetiredStock = Var(mvTechRetiredStock, domain = pyo.NonNegativeReals, doc = "Early retired stock");
model.vTechRetiredNewCap = Var(mvTechRetiredNewCap, domain = pyo.NonNegativeReals, doc = "Early retired new capacity");
model.vTechCap = Var(mTechSpan, domain = pyo.NonNegativeReals, doc = "Total capacity of the technology");
model.vTechAct = Var(mvTechAct, domain = pyo.NonNegativeReals, doc = "Activity level of technology");
model.vTechInp = Var(mvTechInp, domain = pyo.NonNegativeReals, doc = "Input level");
model.vTechOut = Var(mvTechOut, domain = pyo.NonNegativeReals, doc = "Output level");
model.vTechAInp = Var(mvTechAInp, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity input");
model.vTechAOut = Var(mvTechAOut, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity output");
model.vSupOut = Var(mSupAva, domain = pyo.NonNegativeReals, doc = "Output of supply");
model.vSupReserve = Var(mvSupReserve, domain = pyo.NonNegativeReals, doc = "Total supply reserve");
model.vDemInp = Var(mvDemInp, domain = pyo.NonNegativeReals, doc = "Input to demand");
model.vOutTot = Var(mvOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output (consumption is not substracted)");
model.vInpTot = Var(mvInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input");
model.vInp2Lo = Var(mvInp2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for input parent to (grand)child");
model.vOut2Lo = Var(mvOut2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for output parent to (grand)child");
model.vSupOutTot = Var(mSupOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity supply");
model.vTechInpTot = Var(mTechInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to technologies");
model.vTechOutTot = Var(mTechOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from technologies");
model.vStorageInpTot = Var(mStorageInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to storage");
model.vStorageOutTot = Var(mStorageOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from storage");
model.vStorageAInp = Var(mvStorageAInp, domain = pyo.NonNegativeReals, doc = "Aux-commodity input to storage");
model.vStorageAOut = Var(mvStorageAOut, domain = pyo.NonNegativeReals, doc = "Aux-commodity input from storage");
model.vDummyImport = Var(mDummyImport, domain = pyo.NonNegativeReals, doc = "Dummy import (for debugging)");
model.vDummyExport = Var(mDummyExport, domain = pyo.NonNegativeReals, doc = "Dummy export (for debugging)");
model.vStorageInp = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage input");
model.vStorageOut = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage output");
model.vStorageStore = Var(mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage level");
model.vStorageInv = Var(mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage investments");
model.vStorageEac = Var(mStorageEac, domain = pyo.NonNegativeReals, doc = "Storage EAC investments");
model.vStorageCap = Var(mStorageSpan, domain = pyo.NonNegativeReals, doc = "Storage capacity");
model.vStorageNewCap = Var(mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage new capacity");
model.vImport = Var(mImport, domain = pyo.NonNegativeReals, doc = "Total regional import (Ir + ROW)");
model.vExport = Var(mExport, domain = pyo.NonNegativeReals, doc = "Total regional export (Ir + ROW)");
model.vTradeIr = Var(mvTradeIr, domain = pyo.NonNegativeReals, doc = "Total physical trade flows between regions");
model.vTradeIrAInp = Var(mvTradeIrAInp, domain = pyo.NonNegativeReals, doc = "Trade auxilari input");
model.vTradeIrAInpTot = Var(mvTradeIrAInpTot, domain = pyo.NonNegativeReals, doc = "Trade total auxilari input");
model.vTradeIrAOut = Var(mvTradeIrAOut, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vTradeIrAOutTot = Var(mvTradeIrAOutTot, domain = pyo.NonNegativeReals, doc = "Trade auxilari output total");
model.vExportRowAccumulated = Var(mExpComm, domain = pyo.NonNegativeReals, doc = "Accumulated export to ROW");
model.vExportRow = Var(mExportRow, domain = pyo.NonNegativeReals, doc = "Export to ROW");
model.vImportRowAccumulated = Var(mImpComm, domain = pyo.NonNegativeReals, doc = "Accumulated import from ROW");
model.vImportRow = Var(mImportRow, domain = pyo.NonNegativeReals, doc = "Import from ROW");
model.vTradeCap = Var(mTradeSpan, domain = pyo.NonNegativeReals, doc = "Trade capacity");
model.vTradeInv = Var(mTradeEac, domain = pyo.NonNegativeReals, doc = "Investment in trade capacity (overnight)");
model.vTradeEac = Var(mTradeEac, domain = pyo.NonNegativeReals, doc = "Investment in trade capacity (EAC)");
model.vTradeNewCap = Var(mTradeNew, domain = pyo.NonNegativeReals, doc = "New trade capacity");
model.vTotalUserCosts = Var(mvTotalUserCosts, domain = pyo.NonNegativeReals, doc = "Total additional costs (set by user)");
exec(open("inc2.py").read())
print("equations... " + str(datetime.datetime.now().strftime("%H:%M:%S")) + " (" + str(round(time.time() - seconds, 2)) + " s)")
if verbose: print("eqTechSng2Sng ", end = "")
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
model.eqTechSng2Sng = Constraint(meqTechSng2Sng, rule = lambda model, h, r, c, cp, y, l : model.vTechInp[h,c,r,y,l]*pTechCinp2use.get((h,c,r,y,l))  ==  (model.vTechOut[h,cp,r,y,l]) / (pTechUse2cact.get((h,cp,r,y,l))*pTechCact2cout.get((h,cp,r,y,l))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechGrp2Sng ", end = "")
# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
model.eqTechGrp2Sng = Constraint(meqTechGrp2Sng, rule = lambda model, h, r, g, cp, y, l : pTechGinp2use.get((h,g,r,y,l))*sum(((model.vTechInp[h,c,r,y,l]*pTechCinp2ginp.get((h,c,r,y,l))) if (h,c,r,y,l) in mvTechInp else 0) for c in comm if (h,g,c) in mTechGroupComm)  ==  (model.vTechOut[h,cp,r,y,l]) / (pTechUse2cact.get((h,cp,r,y,l))*pTechCact2cout.get((h,cp,r,y,l))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechSng2Grp ", end = "")
# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
model.eqTechSng2Grp = Constraint(meqTechSng2Grp, rule = lambda model, h, r, c, gp, y, l : model.vTechInp[h,c,r,y,l]*pTechCinp2use.get((h,c,r,y,l))  ==  sum((((model.vTechOut[h,cp,r,y,l]) / (pTechUse2cact.get((h,cp,r,y,l))*pTechCact2cout.get((h,cp,r,y,l)))) if (h,cp,r,y,l) in mvTechOut else 0) for cp in comm if (h,gp,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechGrp2Grp ", end = "")
# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
model.eqTechGrp2Grp = Constraint(meqTechGrp2Grp, rule = lambda model, h, r, g, gp, y, l : pTechGinp2use.get((h,g,r,y,l))*sum(((model.vTechInp[h,c,r,y,l]*pTechCinp2ginp.get((h,c,r,y,l))) if (h,c,r,y,l) in mvTechInp else 0) for c in comm if (h,g,c) in mTechGroupComm)  ==  sum((((model.vTechOut[h,cp,r,y,l]) / (pTechUse2cact.get((h,cp,r,y,l))*pTechCact2cout.get((h,cp,r,y,l)))) if (h,cp,r,y,l) in mvTechOut else 0) for cp in comm if (h,gp,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechShareInpLo ", end = "")
# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
model.eqTechShareInpLo = Constraint(meqTechShareInpLo, rule = lambda model, h, r, g, c, y, l : model.vTechInp[h,c,r,y,l]  >=  pTechShareLo.get((h,c,r,y,l))*sum((model.vTechInp[h,cp,r,y,l] if (h,cp,r,y,l) in mvTechInp else 0) for cp in comm if (h,g,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechShareInpUp ", end = "")
# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
model.eqTechShareInpUp = Constraint(meqTechShareInpUp, rule = lambda model, h, r, g, c, y, l : model.vTechInp[h,c,r,y,l] <=  pTechShareUp.get((h,c,r,y,l))*sum((model.vTechInp[h,cp,r,y,l] if (h,cp,r,y,l) in mvTechInp else 0) for cp in comm if (h,g,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechShareOutLo ", end = "")
# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
model.eqTechShareOutLo = Constraint(meqTechShareOutLo, rule = lambda model, h, r, g, c, y, l : model.vTechOut[h,c,r,y,l]  >=  pTechShareLo.get((h,c,r,y,l))*sum((model.vTechOut[h,cp,r,y,l] if (h,cp,r,y,l) in mvTechOut else 0) for cp in comm if (h,g,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechShareOutUp ", end = "")
# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
model.eqTechShareOutUp = Constraint(meqTechShareOutUp, rule = lambda model, h, r, g, c, y, l : model.vTechOut[h,c,r,y,l] <=  pTechShareUp.get((h,c,r,y,l))*sum((model.vTechOut[h,cp,r,y,l] if (h,cp,r,y,l) in mvTechOut else 0) for cp in comm if (h,g,cp) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAInp ", end = "")
# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
model.eqTechAInp = Constraint(mvTechAInp, rule = lambda model, h, c, r, y, l : model.vTechAInp[h,c,r,y,l]  ==  ((model.vTechAct[h,r,y,l]*pTechAct2AInp.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechAct2AInp else 0)+((model.vTechCap[h,r,y]*pTechCap2AInp.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechCap2AInp else 0)+((model.vTechNewCap[h,r,y]*pTechNCap2AInp.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechNCap2AInp else 0)+sum(pTechCinp2AInp.get((h,c,cp,r,y,l))*model.vTechInp[h,cp,r,y,l] for cp in comm if (h,c,cp,r,y,l) in mTechCinp2AInp)+sum(pTechCout2AInp.get((h,c,cp,r,y,l))*model.vTechOut[h,cp,r,y,l] for cp in comm if (h,c,cp,r,y,l) in mTechCout2AInp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAOut ", end = "")
# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
model.eqTechAOut = Constraint(mvTechAOut, rule = lambda model, h, c, r, y, l : model.vTechAOut[h,c,r,y,l]  ==  ((model.vTechAct[h,r,y,l]*pTechAct2AOut.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechAct2AOut else 0)+((model.vTechCap[h,r,y]*pTechCap2AOut.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechCap2AOut else 0)+((model.vTechNewCap[h,r,y]*pTechNCap2AOut.get((h,c,r,y,l))) if (h,c,r,y,l) in mTechNCap2AOut else 0)+sum(pTechCinp2AOut.get((h,c,cp,r,y,l))*model.vTechInp[h,cp,r,y,l] for cp in comm if (h,c,cp,r,y,l) in mTechCinp2AOut)+sum(pTechCout2AOut.get((h,c,cp,r,y,l))*model.vTechOut[h,cp,r,y,l] for cp in comm if (h,c,cp,r,y,l) in mTechCout2AOut));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfLo ", end = "")
# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
model.eqTechAfLo = Constraint(meqTechAfLo, rule = lambda model, h, r, y, l : pTechAfLo.get((h,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfLo.get((w,h))*pWeather.get((w,r,y,l)) for w in weather if (w,h) in mTechWeatherAfLo) <=  model.vTechAct[h,r,y,l]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfUp ", end = "")
# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
model.eqTechAfUp = Constraint(meqTechAfUp, rule = lambda model, h, r, y, l : model.vTechAct[h,r,y,l] <=  pTechAfUp.get((h,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfUp.get((w,h))*pWeather.get((w,r,y,l)) for w in weather if (w,h) in mTechWeatherAfUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfsLo ", end = "")
# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
model.eqTechAfsLo = Constraint(meqTechAfsLo, rule = lambda model, h, r, y, l : pTechAfsLo.get((h,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfsLo.get((w,h))*pWeather.get((w,r,y,l)) for w in weather if (w,h) in mTechWeatherAfsLo) <=  sum((model.vTechAct[h,r,y,lp] if (h,r,y,lp) in mvTechAct else 0) for lp in slice if (l,lp) in mSliceParentChildE));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfsUp ", end = "")
# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
model.eqTechAfsUp = Constraint(meqTechAfsUp, rule = lambda model, h, r, y, l : sum((model.vTechAct[h,r,y,lp] if (h,r,y,lp) in mvTechAct else 0) for lp in slice if (l,lp) in mSliceParentChildE) <=  pTechAfsUp.get((h,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfsUp.get((w,h))*pWeather.get((w,r,y,l)) for w in weather if (w,h) in mTechWeatherAfsUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechRampUp ", end = "")
# eqTechRampUp(tech, region, year, slice)$mTechRampUp(tech, region, year, slice)
model.eqTechRampUp = Constraint(mTechRampUp, rule = lambda model, h, r, y, l : (model.vTechAct[h,r,y,l]) / (pSliceShare.get((l)))-sum((model.vTechAct[h,r,y,lp]) / (pSliceShare.get((lp))) for lp in slice if (((h in mTechFullYear and (lp,l) in mSliceNext) or (not((h in mTechFullYear)) and (lp,l) in mSliceFYearNext)) and (h,r,y,lp) in mvTechAct)) <=  (pSliceShare.get((l))*365*24*pTechCap2act.get((h))*model.vTechCap[h,r,y]) / (pTechRampUp.get((h,r,y,l))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechRampDown ", end = "")
# eqTechRampDown(tech, region, year, slice)$mTechRampDown(tech, region, year, slice)
model.eqTechRampDown = Constraint(mTechRampDown, rule = lambda model, h, r, y, l : sum((model.vTechAct[h,r,y,lp]) / (pSliceShare.get((lp))) for lp in slice if (((h in mTechFullYear and (lp,l) in mSliceNext) or (not((h in mTechFullYear)) and (lp,l) in mSliceFYearNext)) and (h,r,y,lp) in mvTechAct))-(model.vTechAct[h,r,y,l]) / (pSliceShare.get((l))) <=  (pSliceShare.get((l))*365*24*pTechCap2act.get((h))*model.vTechCap[h,r,y]) / (pTechRampDown.get((h,r,y,l))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechActSng ", end = "")
# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
model.eqTechActSng = Constraint(meqTechActSng, rule = lambda model, h, c, r, y, l : model.vTechAct[h,r,y,l]  ==  (model.vTechOut[h,c,r,y,l]) / (pTechCact2cout.get((h,c,r,y,l))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechActGrp ", end = "")
# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
model.eqTechActGrp = Constraint(meqTechActGrp, rule = lambda model, h, g, r, y, l : model.vTechAct[h,r,y,l]  ==  sum((((model.vTechOut[h,c,r,y,l]) / (pTechCact2cout.get((h,c,r,y,l)))) if (h,c,r,y,l) in mvTechOut else 0) for c in comm if (h,g,c) in mTechGroupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfcOutLo ", end = "")
# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
model.eqTechAfcOutLo = Constraint(meqTechAfcOutLo, rule = lambda model, h, r, c, y, l : pTechCact2cout.get((h,c,r,y,l))*pTechAfcLo.get((h,c,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfcLo.get((w,h,c))*pWeather.get((w,r,y,l)) for w in weather if (w,h,c) in mTechWeatherAfcLo) <=  model.vTechOut[h,c,r,y,l]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfcOutUp ", end = "")
# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
model.eqTechAfcOutUp = Constraint(meqTechAfcOutUp, rule = lambda model, h, r, c, y, l : model.vTechOut[h,c,r,y,l] <=  pTechCact2cout.get((h,c,r,y,l))*pTechAfcUp.get((h,c,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*prod(pTechWeatherAfcUp.get((w,h,c))*pWeather.get((w,r,y,l)) for w in weather if (w,h,c) in mTechWeatherAfcUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfcInpLo ", end = "")
# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
model.eqTechAfcInpLo = Constraint(meqTechAfcInpLo, rule = lambda model, h, r, c, y, l : pTechAfcLo.get((h,c,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfcLo.get((w,h,c))*pWeather.get((w,r,y,l)) for w in weather if (w,h,c) in mTechWeatherAfcLo) <=  model.vTechInp[h,c,r,y,l]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechAfcInpUp ", end = "")
# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
model.eqTechAfcInpUp = Constraint(meqTechAfcInpUp, rule = lambda model, h, r, c, y, l : model.vTechInp[h,c,r,y,l] <=  pTechAfcUp.get((h,c,r,y,l))*pTechCap2act.get((h))*model.vTechCap[h,r,y]*pSliceShare.get((l))*prod(pTechWeatherAfcUp.get((w,h,c))*pWeather.get((w,r,y,l)) for w in weather if (w,h,c) in mTechWeatherAfcUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechCap ", end = "")
# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
model.eqTechCap = Constraint(mTechSpan, rule = lambda model, h, r, y : model.vTechCap[h,r,y]  ==  pTechStock.get((h,r,y))-(model.vTechRetiredStock[h,r,y] if (h,r,y) in mvTechRetiredStock else 0)+sum(pPeriodLen.get((yp))*(model.vTechNewCap[h,r,yp]-sum(model.vTechRetiredNewCap[h,r,yp,ye] for ye in year if ((h,r,yp,ye) in mvTechRetiredNewCap and ordYear.get((y)) >= ordYear.get((ye))))) for yp in year if ((h,r,yp) in mTechNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTechOlife.get((h,r))+ordYear.get((yp)) or (h,r) in mTechOlifeInf))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechRetiredNewCap ", end = "")
# eqTechRetiredNewCap(tech, region, year)$meqTechRetiredNewCap(tech, region, year)
model.eqTechRetiredNewCap = Constraint(meqTechRetiredNewCap, rule = lambda model, h, r, y : sum(model.vTechRetiredNewCap[h,r,y,yp] for yp in year if (h,r,y,yp) in mvTechRetiredNewCap) <=  model.vTechNewCap[h,r,y]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechRetiredStock ", end = "")
# eqTechRetiredStock(tech, region, year)$mvTechRetiredStock(tech, region, year)
model.eqTechRetiredStock = Constraint(mvTechRetiredStock, rule = lambda model, h, r, y : model.vTechRetiredStock[h,r,y] <=  pTechStock.get((h,r,y)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechEac ", end = "")
# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
model.eqTechEac = Constraint(mTechEac, rule = lambda model, h, r, y : model.vTechEac[h,r,y]  ==  sum(pTechEac.get((h,r,yp))*pPeriodLen.get((yp))*(model.vTechNewCap[h,r,yp]-sum(model.vTechRetiredNewCap[h,r,yp,ye] for ye in year if ((h,r,yp,ye) in mvTechRetiredNewCap and ordYear.get((y)) >= ordYear.get((ye))))) for yp in year if ((h,r,yp) in mTechNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTechOlife.get((h,r))+ordYear.get((yp)) or (h,r) in mTechOlifeInf))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechInv ", end = "")
# eqTechInv(tech, region, year)$mTechInv(tech, region, year)
model.eqTechInv = Constraint(mTechInv, rule = lambda model, h, r, y : model.vTechInv[h,r,y]  ==  pTechInvcost.get((h,r,y))*model.vTechNewCap[h,r,y]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechOMCost ", end = "")
# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
model.eqTechOMCost = Constraint(mTechOMCost, rule = lambda model, h, r, y : model.vTechOMCost[h,r,y]  ==  pTechFixom.get((h,r,y))*model.vTechCap[h,r,y]+sum(pTechVarom.get((h,r,y,l))*model.vTechAct[h,r,y,l]+sum(pTechCvarom.get((h,c,r,y,l))*model.vTechInp[h,c,r,y,l] for c in comm if (h,c) in mTechInpComm)+sum(pTechCvarom.get((h,c,r,y,l))*model.vTechOut[h,c,r,y,l] for c in comm if (h,c) in mTechOutComm)+sum(pTechAvarom.get((h,c,r,y,l))*model.vTechAOut[h,c,r,y,l] for c in comm if (h,c,r,y,l) in mvTechAOut)+sum(pTechAvarom.get((h,c,r,y,l))*model.vTechAInp[h,c,r,y,l] for c in comm if (h,c,r,y,l) in mvTechAInp) for l in slice if (h,l) in mTechSlice));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupAvaUp ", end = "")
# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
model.eqSupAvaUp = Constraint(mSupAvaUp, rule = lambda model, u, c, r, y, l : model.vSupOut[u,c,r,y,l] <=  pSupAvaUp.get((u,c,r,y,l))*prod(pSupWeatherUp.get((w,u))*pWeather.get((w,r,y,l)) for w in weather if (w,u) in mSupWeatherUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupAvaLo ", end = "")
# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
model.eqSupAvaLo = Constraint(meqSupAvaLo, rule = lambda model, u, c, r, y, l : model.vSupOut[u,c,r,y,l]  >=  pSupAvaLo.get((u,c,r,y,l))*prod(pSupWeatherLo.get((w,u))*pWeather.get((w,r,y,l)) for w in weather if (w,u) in mSupWeatherLo));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupTotal ", end = "")
# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
model.eqSupTotal = Constraint(mvSupReserve, rule = lambda model, u, c, r : model.vSupReserve[u,c,r]  ==  sum(pPeriodLen.get((y))*model.vSupOut[u,c,r,y,l] for y in year for l in slice if (u,c,r,y,l) in mSupAva));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupReserveUp ", end = "")
# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
model.eqSupReserveUp = Constraint(mSupReserveUp, rule = lambda model, u, c, r : pSupReserveUp.get((u,c,r))  >=  model.vSupReserve[u,c,r]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupReserveLo ", end = "")
# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
model.eqSupReserveLo = Constraint(meqSupReserveLo, rule = lambda model, u, c, r : model.vSupReserve[u,c,r]  >=  pSupReserveLo.get((u,c,r)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupCost ", end = "")
# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
model.eqSupCost = Constraint(mvSupCost, rule = lambda model, u, r, y : model.vSupCost[u,r,y]  ==  sum(pSupCost.get((u,c,r,y,l))*model.vSupOut[u,c,r,y,l] for c in comm for l in slice if (u,c,r,y,l) in mSupAva));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqDemInp ", end = "")
# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
model.eqDemInp = Constraint(mvDemInp, rule = lambda model, c, r, y, l : model.vDemInp[c,r,y,l]  ==  sum(pDemand.get((d,c,r,y,l)) for d in trade if (d,c) in mDemComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqAggOut ", end = "")
# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
model.eqAggOut = Constraint(mAggOut, rule = lambda model, c, r, y, l : model.vAggOut[c,r,y,l]  ==  sum(pAggregateFactor.get((c,cp))*sum(model.vOutTot[cp,r,y,lp] for lp in slice if ((c,r,y,lp) in mvOutTot and (l,lp) in mSliceParentChildE and (cp,lp) in mCommSlice)) for cp in comm if (c,cp) in mAggregateFactor));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqEmsFuelTot ", end = "")
# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
model.eqEmsFuelTot = Constraint(mEmsFuelTot, rule = lambda model, c, r, y, l : model.vEmsFuelTot[c,r,y,l]  ==  sum(pEmissionFactor.get((c,cp))*sum(pTechEmisComm.get((h,cp))*sum((model.vTechInp[h,cp,r,y,lp] if (h,c,cp,r,y,lp) in mTechEmsFuel else 0) for lp in slice if (c,l,lp) in mCommSliceOrParent) for h in tech if (h,cp) in mTechInpComm) for cp in comm if (pEmissionFactor.get((c,cp))>0)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageAInp ", end = "")
# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
model.eqStorageAInp = Constraint(mvStorageAInp, rule = lambda model, s, c, r, y, l : model.vStorageAInp[s,c,r,y,l]  ==  sum(((pStorageStg2AInp.get((s,c,r,y,l))*model.vStorageStore[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageStg2AInp else 0)+((pStorageCinp2AInp.get((s,c,r,y,l))*model.vStorageInp[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageCinp2AInp else 0)+((pStorageCout2AInp.get((s,c,r,y,l))*model.vStorageOut[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageCout2AInp else 0)+((pStorageCap2AInp.get((s,c,r,y,l))*model.vStorageCap[s,r,y]) if (s,c,r,y,l) in mStorageCap2AInp else 0)+((pStorageNCap2AInp.get((s,c,r,y,l))*model.vStorageNewCap[s,r,y]) if (s,c,r,y,l) in mStorageNCap2AInp else 0) for cp in comm if (s,cp) in mStorageComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageAOut ", end = "")
# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
model.eqStorageAOut = Constraint(mvStorageAOut, rule = lambda model, s, c, r, y, l : model.vStorageAOut[s,c,r,y,l]  ==  sum(((pStorageStg2AOut.get((s,c,r,y,l))*model.vStorageStore[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageStg2AOut else 0)+((pStorageCinp2AOut.get((s,c,r,y,l))*model.vStorageInp[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageCinp2AOut else 0)+((pStorageCout2AOut.get((s,c,r,y,l))*model.vStorageOut[s,cp,r,y,l]) if (s,c,r,y,l) in mStorageCout2AOut else 0)+((pStorageCap2AOut.get((s,c,r,y,l))*model.vStorageCap[s,r,y]) if (s,c,r,y,l) in mStorageCap2AOut else 0)+((pStorageNCap2AOut.get((s,c,r,y,l))*model.vStorageNewCap[s,r,y]) if (s,c,r,y,l) in mStorageNCap2AOut else 0) for cp in comm if (s,cp) in mStorageComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageStore ", end = "")
# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageStore = Constraint(mvStorageStore, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l]  ==  pStorageCharge.get((s,c,r,y,l))+((pStorageNCap2Stg.get((s,c,r,y,l))*model.vStorageNewCap[s,r,y]) if (s,r,y) in mStorageNew else 0)+sum(pStorageInpEff.get((s,c,r,y,lp))*model.vStorageInp[s,c,r,y,lp]+((pStorageStgEff.get((s,c,r,y,l)))**(pSliceShare.get((l))))*model.vStorageStore[s,c,r,y,lp]-(model.vStorageOut[s,c,r,y,lp]) / (pStorageOutEff.get((s,c,r,y,lp))) for lp in slice if ((c,lp) in mCommSlice and ((not((s in mStorageFullYear)) and (lp,l) in mSliceNext) or (s in mStorageFullYear and (lp,l) in mSliceFYearNext)))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageAfLo ", end = "")
# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
model.eqStorageAfLo = Constraint(meqStorageAfLo, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l]  >=  pStorageAfLo.get((s,r,y,l))*pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*prod(pStorageWeatherAfLo.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherAfLo));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageAfUp ", end = "")
# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
model.eqStorageAfUp = Constraint(meqStorageAfUp, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l] <=  pStorageAfUp.get((s,r,y,l))*pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*prod(pStorageWeatherAfUp.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherAfUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageClean ", end = "")
# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageClean = Constraint(mvStorageStore, rule = lambda model, s, c, r, y, l : (model.vStorageOut[s,c,r,y,l]) / (pStorageOutEff.get((s,c,r,y,l))) <=  model.vStorageStore[s,c,r,y,l]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageInpUp ", end = "")
# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
model.eqStorageInpUp = Constraint(meqStorageInpUp, rule = lambda model, s, c, r, y, l : model.vStorageInp[s,c,r,y,l] <=  pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*pStorageCinpUp.get((s,c,r,y,l))*pSliceShare.get((l))*prod(pStorageWeatherCinpUp.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherCinpUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageInpLo ", end = "")
# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
model.eqStorageInpLo = Constraint(meqStorageInpLo, rule = lambda model, s, c, r, y, l : model.vStorageInp[s,c,r,y,l]  >=  pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*pStorageCinpLo.get((s,c,r,y,l))*pSliceShare.get((l))*prod(pStorageWeatherCinpLo.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherCinpLo));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageOutUp ", end = "")
# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
model.eqStorageOutUp = Constraint(meqStorageOutUp, rule = lambda model, s, c, r, y, l : model.vStorageOut[s,c,r,y,l] <=  pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*pStorageCoutUp.get((s,c,r,y,l))*pSliceShare.get((l))*prod(pStorageWeatherCoutUp.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherCoutUp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageOutLo ", end = "")
# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
model.eqStorageOutLo = Constraint(meqStorageOutLo, rule = lambda model, s, c, r, y, l : model.vStorageOut[s,c,r,y,l]  >=  pStorageCap2stg.get((s))*model.vStorageCap[s,r,y]*pStorageCoutLo.get((s,c,r,y,l))*pSliceShare.get((l))*prod(pStorageWeatherCoutLo.get((w,s))*pWeather.get((w,r,y,l)) for w in weather if (w,s) in mStorageWeatherCoutLo));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageCap ", end = "")
# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
model.eqStorageCap = Constraint(mStorageSpan, rule = lambda model, s, r, y : model.vStorageCap[s,r,y]  ==  pStorageStock.get((s,r,y))+sum(pPeriodLen.get((yp))*model.vStorageNewCap[s,r,yp] for yp in year if (ordYear.get((y)) >= ordYear.get((yp)) and ((s,r) in mStorageOlifeInf or ordYear.get((y))<pStorageOlife.get((s,r))+ordYear.get((yp))) and (s,r,yp) in mStorageNew)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageInv ", end = "")
# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
model.eqStorageInv = Constraint(mStorageNew, rule = lambda model, s, r, y : model.vStorageInv[s,r,y]  ==  pStorageInvcost.get((s,r,y))*model.vStorageNewCap[s,r,y]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageEac ", end = "")
# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
model.eqStorageEac = Constraint(mStorageEac, rule = lambda model, s, r, y : model.vStorageEac[s,r,y]  ==  sum(pStorageEac.get((s,r,yp))*pPeriodLen.get((yp))*model.vStorageNewCap[s,r,yp] for yp in year if ((s,r,yp) in mStorageNew and ordYear.get((y)) >= ordYear.get((yp)) and ((s,r) in mStorageOlifeInf or ordYear.get((y))<pStorageOlife.get((s,r))+ordYear.get((yp))) and pStorageInvcost.get((s,r,yp)) != 0)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageCost ", end = "")
# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
model.eqStorageCost = Constraint(mStorageOMCost, rule = lambda model, s, r, y : model.vStorageOMCost[s,r,y]  ==  pStorageFixom.get((s,r,y))*model.vStorageCap[s,r,y]+sum(sum(pStorageCostInp.get((s,r,y,l))*model.vStorageInp[s,c,r,y,l]+pStorageCostOut.get((s,r,y,l))*model.vStorageOut[s,c,r,y,l]+pStorageCostStore.get((s,r,y,l))*model.vStorageStore[s,c,r,y,l] for l in slice if (c,l) in mCommSlice) for c in comm if (s,c) in mStorageComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqImport ", end = "")
# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
model.eqImport = Constraint(mImport, rule = lambda model, c, dst, y, l : model.vImport[c,dst,y,l]  ==  sum(sum(sum(((pTradeIrEff.get((d,src,dst,y,lp))*model.vTradeIr[d,c,src,dst,y,lp]) if (d,c,src,dst,y,lp) in mvTradeIr else 0) for src in region if (d,src,dst) in mTradeRoutes) for d in trade if (d,c) in mTradeComm) for lp in slice if (c,l,lp) in mCommSliceOrParent)+sum(sum((model.vImportRow[m,c,dst,y,lp] if (m,c,dst,y,lp) in mImportRow else 0) for m in imp if (m,c) in mImpComm) for lp in slice if (c,l,lp) in mCommSliceOrParent));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqExport ", end = "")
# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
model.eqExport = Constraint(mExport, rule = lambda model, c, src, y, l : model.vExport[c,src,y,l]  ==  sum(sum(sum((model.vTradeIr[d,c,src,dst,y,lp] if (d,c,src,dst,y,lp) in mvTradeIr else 0) for dst in region if (d,src,dst) in mTradeRoutes) for d in trade if (d,c) in mTradeComm) for lp in slice if (c,l,lp) in mCommSliceOrParent)+sum(sum((model.vExportRow[x,c,src,y,lp] if (x,c,src,y,lp) in mExportRow else 0) for x in expp if (x,c) in mExpComm) for lp in slice if (c,l,lp) in mCommSliceOrParent));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeFlowUp ", end = "")
# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
model.eqTradeFlowUp = Constraint(meqTradeFlowUp, rule = lambda model, d, c, src, dst, y, l : model.vTradeIr[d,c,src,dst,y,l] <=  pTradeIrUp.get((d,src,dst,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeFlowLo ", end = "")
# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
model.eqTradeFlowLo = Constraint(meqTradeFlowLo, rule = lambda model, d, c, src, dst, y, l : model.vTradeIr[d,c,src,dst,y,l]  >=  pTradeIrLo.get((d,src,dst,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqCostTrade ", end = "")
# eqCostTrade(region, year)$mvTradeCost(region, year)
model.eqCostTrade = Constraint(mvTradeCost, rule = lambda model, r, y : model.vTradeCost[r,y]  ==  (model.vTradeRowCost[r,y] if (r,y) in mvTradeRowCost else 0)+(model.vTradeIrCost[r,y] if (r,y) in mvTradeIrCost else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqCostRowTrade ", end = "")
# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
model.eqCostRowTrade = Constraint(mvTradeRowCost, rule = lambda model, r, y : model.vTradeRowCost[r,y]  ==  sum(pImportRowPrice.get((m,r,y,l))*model.vImportRow[m,c,r,y,l] for m in imp for c in comm for l in slice if (m,c,r,y,l) in mImportRow)-sum(pExportRowPrice.get((x,r,y,l))*model.vExportRow[x,c,r,y,l] for x in expp for c in comm for l in slice if (x,c,r,y,l) in mExportRow));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqCostIrTrade ", end = "")
# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
model.eqCostIrTrade = Constraint(mvTradeIrCost, rule = lambda model, r, y : model.vTradeIrCost[r,y]  ==  sum(model.vTradeEac[d,r,y] for d in trade if (d,r,y) in mTradeEac)+sum(sum(sum(((((pTradeIrCost.get((d,src,r,y,l))+pTradeIrMarkup.get((d,src,r,y,l)))*model.vTradeIr[d,c,src,r,y,l])) if (d,c,src,r,y,l) in mvTradeIr else 0) for l in slice if (d,l) in mTradeSlice) for c in comm if (d,c) in mTradeComm) for d in trade for src in region if (d,src,r) in mTradeRoutes)-sum(sum(sum((((pTradeIrMarkup.get((d,r,dst,y,l))*model.vTradeIr[d,c,r,dst,y,l])) if (d,c,r,dst,y,l) in mvTradeIr else 0) for l in slice if (d,l) in mTradeSlice) for c in comm if (d,c) in mTradeComm) for d in trade for dst in region if (d,r,dst) in mTradeRoutes));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqExportRowUp ", end = "")
# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
model.eqExportRowUp = Constraint(mExportRowUp, rule = lambda model, x, c, r, y, l : model.vExportRow[x,c,r,y,l] <=  pExportRowUp.get((x,r,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqExportRowLo ", end = "")
# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
model.eqExportRowLo = Constraint(meqExportRowLo, rule = lambda model, x, c, r, y, l : model.vExportRow[x,c,r,y,l]  >=  pExportRowLo.get((x,r,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqExportRowCumulative ", end = "")
# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
model.eqExportRowCumulative = Constraint(mExpComm, rule = lambda model, x, c : model.vExportRowAccumulated[x,c]  ==  sum(pPeriodLen.get((y))*model.vExportRow[x,c,r,y,l] for r in region for y in year for l in slice if (x,c,r,y,l) in mExportRow));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqExportRowResUp ", end = "")
# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
model.eqExportRowResUp = Constraint(mExportRowAccumulatedUp, rule = lambda model, x, c : model.vExportRowAccumulated[x,c] <=  pExportRowRes.get((x)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqImportRowUp ", end = "")
# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
model.eqImportRowUp = Constraint(mImportRowUp, rule = lambda model, m, c, r, y, l : model.vImportRow[m,c,r,y,l] <=  pImportRowUp.get((m,r,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqImportRowLo ", end = "")
# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
model.eqImportRowLo = Constraint(meqImportRowLo, rule = lambda model, m, c, r, y, l : model.vImportRow[m,c,r,y,l]  >=  pImportRowLo.get((m,r,y,l)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqImportRowAccumulated ", end = "")
# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
model.eqImportRowAccumulated = Constraint(mImpComm, rule = lambda model, m, c : model.vImportRowAccumulated[m,c]  ==  sum(pPeriodLen.get((y))*model.vImportRow[m,c,r,y,l] for r in region for y in year for l in slice if (m,c,r,y,l) in mImportRow));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqImportRowResUp ", end = "")
# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
model.eqImportRowResUp = Constraint(mImportRowAccumulatedUp, rule = lambda model, m, c : model.vImportRowAccumulated[m,c] <=  pImportRowRes.get((m)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeCapFlow ", end = "")
# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
model.eqTradeCapFlow = Constraint(meqTradeCapFlow, rule = lambda model, d, c, y, l : pSliceShare.get((l))*pTradeCap2Act.get((d))*model.vTradeCap[d,y]  >=  sum(model.vTradeIr[d,c,src,dst,y,l] for src in region for dst in region if (d,c,src,dst,y,l) in mvTradeIr));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeCap ", end = "")
# eqTradeCap(trade, year)$mTradeSpan(trade, year)
model.eqTradeCap = Constraint(mTradeSpan, rule = lambda model, d, y : model.vTradeCap[d,y]  ==  pTradeStock.get((d,y))+sum(pPeriodLen.get((yp))*model.vTradeNewCap[d,yp] for yp in year if ((d,yp) in mTradeNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTradeOlife.get((d))+ordYear.get((yp)) or d in mTradeOlifeInf))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeInv ", end = "")
# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
model.eqTradeInv = Constraint(mTradeInv, rule = lambda model, d, r, y : model.vTradeInv[d,r,y]  ==  pTradeInvcost.get((d,r,y))*model.vTradeNewCap[d,y]);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeEac ", end = "")
# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
model.eqTradeEac = Constraint(mTradeEac, rule = lambda model, d, r, y : model.vTradeEac[d,r,y]  ==  sum(pTradeEac.get((d,r,yp))*pPeriodLen.get((yp))*model.vTradeNewCap[d,yp] for yp in year if ((d,yp) in mTradeNew and ordYear.get((y)) >= ordYear.get((yp)) and (ordYear.get((y))<pTradeOlife.get((d))+ordYear.get((yp)) or d in mTradeOlifeInf))));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeIrAInp ", end = "")
# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
model.eqTradeIrAInp = Constraint(mvTradeIrAInp, rule = lambda model, d, c, r, y, l : model.vTradeIrAInp[d,c,r,y,l]  ==  sum(pTradeIrCsrc2Ainp.get((d,c,r,dst,y,l))*sum(model.vTradeIr[d,cp,r,dst,y,l] for cp in comm if (d,cp) in mTradeComm) for dst in region if (d,c,r,dst,y,l) in mTradeIrCsrc2Ainp)+sum(pTradeIrCdst2Ainp.get((d,c,src,r,y,l))*sum(model.vTradeIr[d,cp,src,r,y,l] for cp in comm if (d,cp) in mTradeComm) for src in region if (d,c,src,r,y,l) in mTradeIrCdst2Ainp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeIrAOut ", end = "")
# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
model.eqTradeIrAOut = Constraint(mvTradeIrAOut, rule = lambda model, d, c, r, y, l : model.vTradeIrAOut[d,c,r,y,l]  ==  sum(pTradeIrCsrc2Aout.get((d,c,r,dst,y,l))*sum(model.vTradeIr[d,cp,r,dst,y,l] for cp in comm if (d,cp) in mTradeComm) for dst in region if (d,c,r,dst,y,l) in mTradeIrCsrc2Aout)+sum(pTradeIrCdst2Aout.get((d,c,src,r,y,l))*sum(model.vTradeIr[d,cp,src,r,y,l] for cp in comm if (d,cp) in mTradeComm) for src in region if (d,c,src,r,y,l) in mTradeIrCdst2Aout));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeIrAInpTot ", end = "")
# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
model.eqTradeIrAInpTot = Constraint(mvTradeIrAInpTot, rule = lambda model, c, r, y, l : model.vTradeIrAInpTot[c,r,y,l]  ==  sum(model.vTradeIrAInp[d,c,r,y,lp] for d in trade for lp in slice if ((c,l,lp) in mCommSliceOrParent and (d,c,r,y,lp) in mvTradeIrAInp)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTradeIrAOutTot ", end = "")
# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
model.eqTradeIrAOutTot = Constraint(mvTradeIrAOutTot, rule = lambda model, c, r, y, l : model.vTradeIrAOutTot[c,r,y,l]  ==  sum(model.vTradeIrAOut[d,c,r,y,lp] for d in trade for lp in slice if ((c,l,lp) in mCommSliceOrParent and (d,c,r,y,lp) in mvTradeIrAOut)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqBalLo ", end = "")
# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
model.eqBalLo = Constraint(meqBalLo, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  >=  0);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqBalUp ", end = "")
# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
model.eqBalUp = Constraint(meqBalUp, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l] <=  0);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqBalFx ", end = "")
# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
model.eqBalFx = Constraint(meqBalFx, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  ==  0);
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqBal ", end = "")
# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqBal = Constraint(mvBalance, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  ==  (model.vOutTot[c,r,y,l] if (c,r,y,l) in mvOutTot else 0)-(model.vInpTot[c,r,y,l] if (c,r,y,l) in mvInpTot else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqOutTot ", end = "")
# eqOutTot(comm, region, year, slice)$mvOutTot(comm, region, year, slice)
model.eqOutTot = Constraint(mvOutTot, rule = lambda model, c, r, y, l : model.vOutTot[c,r,y,l]  ==  (model.vDummyImport[c,r,y,l] if (c,r,y,l) in mDummyImport else 0)+(model.vSupOutTot[c,r,y,l] if (c,r,y,l) in mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,l] if (c,r,y,l) in mEmsFuelTot else 0)+(model.vAggOut[c,r,y,l] if (c,r,y,l) in mAggOut else 0)+(model.vTechOutTot[c,r,y,l] if (c,r,y,l) in mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,l] if (c,r,y,l) in mStorageOutTot else 0)+(model.vImport[c,r,y,l] if (c,r,y,l) in mImport else 0)+(model.vTradeIrAOutTot[c,r,y,l] if (c,r,y,l) in mvTradeIrAOutTot else 0)+(sum(model.vOut2Lo[c,r,y,lp,l] for lp in slice if ((lp,l) in mSliceParentChild and (c,r,y,lp,l) in mvOut2Lo)) if (c,r,y,l) in mOutSub else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqOut2Lo ", end = "")
# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
model.eqOut2Lo = Constraint(mOut2Lo, rule = lambda model, c, r, y, l : sum(model.vOut2Lo[c,r,y,l,lp] for lp in slice if (c,r,y,l,lp) in mvOut2Lo)  ==  (model.vSupOutTot[c,r,y,l] if (c,r,y,l) in mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,l] if (c,r,y,l) in mEmsFuelTot else 0)+(model.vAggOut[c,r,y,l] if (c,r,y,l) in mAggOut else 0)+(model.vTechOutTot[c,r,y,l] if (c,r,y,l) in mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,l] if (c,r,y,l) in mStorageOutTot else 0)+(model.vImport[c,r,y,l] if (c,r,y,l) in mImport else 0)+(model.vTradeIrAOutTot[c,r,y,l] if (c,r,y,l) in mvTradeIrAOutTot else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqInpTot ", end = "")
# eqInpTot(comm, region, year, slice)$mvInpTot(comm, region, year, slice)
model.eqInpTot = Constraint(mvInpTot, rule = lambda model, c, r, y, l : model.vInpTot[c,r,y,l]  ==  (model.vDemInp[c,r,y,l] if (c,r,y,l) in mvDemInp else 0)+(model.vDummyExport[c,r,y,l] if (c,r,y,l) in mDummyExport else 0)+(model.vTechInpTot[c,r,y,l] if (c,r,y,l) in mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,l] if (c,r,y,l) in mStorageInpTot else 0)+(model.vExport[c,r,y,l] if (c,r,y,l) in mExport else 0)+(model.vTradeIrAInpTot[c,r,y,l] if (c,r,y,l) in mvTradeIrAInpTot else 0)+(sum(model.vInp2Lo[c,r,y,lp,l] for lp in slice if ((lp,l) in mSliceParentChild and (c,r,y,lp,l) in mvInp2Lo)) if (c,r,y,l) in mInpSub else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqInp2Lo ", end = "")
# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
model.eqInp2Lo = Constraint(mInp2Lo, rule = lambda model, c, r, y, l : sum(model.vInp2Lo[c,r,y,l,lp] for lp in slice if (c,r,y,l,lp) in mvInp2Lo)  ==  (model.vTechInpTot[c,r,y,l] if (c,r,y,l) in mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,l] if (c,r,y,l) in mStorageInpTot else 0)+(model.vExport[c,r,y,l] if (c,r,y,l) in mExport else 0)+(model.vTradeIrAInpTot[c,r,y,l] if (c,r,y,l) in mvTradeIrAInpTot else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSupOutTot ", end = "")
# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
model.eqSupOutTot = Constraint(mSupOutTot, rule = lambda model, c, r, y, l : model.vSupOutTot[c,r,y,l]  ==  sum(sum(model.vSupOut[u,c,r,y,lp] for lp in slice if ((c,l,lp) in mCommSliceOrParent and (u,c,r,y,lp) in mSupAva)) for u in sup if (u,c) in mSupComm));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechInpTot ", end = "")
# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
model.eqTechInpTot = Constraint(mTechInpTot, rule = lambda model, c, r, y, l : model.vTechInpTot[c,r,y,l]  ==  sum(sum((model.vTechInp[h,c,r,y,lp] if (h,c,r,y,lp) in mvTechInp else 0) for lp in slice if ((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechInpComm)+sum(sum((model.vTechAInp[h,c,r,y,lp] if (h,c,r,y,lp) in mvTechAInp else 0) for lp in slice if ((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechAInp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTechOutTot ", end = "")
# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
model.eqTechOutTot = Constraint(mTechOutTot, rule = lambda model, c, r, y, l : model.vTechOutTot[c,r,y,l]  ==  sum(sum((model.vTechOut[h,c,r,y,lp] if (h,c,r,y,lp) in mvTechOut else 0) for lp in slice if ((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechOutComm)+sum(sum((model.vTechAOut[h,c,r,y,lp] if (h,c,r,y,lp) in mvTechAOut else 0) for lp in slice if ((h,lp) in mTechSlice and (c,l,lp) in mCommSliceOrParent)) for h in tech if (h,c) in mTechAOut));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageInpTot ", end = "")
# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
model.eqStorageInpTot = Constraint(mStorageInpTot, rule = lambda model, c, r, y, l : model.vStorageInpTot[c,r,y,l]  ==  sum(model.vStorageInp[s,c,r,y,l] for s in stg if (s,c,r,y,l) in mvStorageStore)+sum(model.vStorageAInp[s,c,r,y,l] for s in stg if (s,c,r,y,l) in mvStorageAInp));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqStorageOutTot ", end = "")
# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
model.eqStorageOutTot = Constraint(mStorageOutTot, rule = lambda model, c, r, y, l : model.vStorageOutTot[c,r,y,l]  ==  sum(model.vStorageOut[s,c,r,y,l] for s in stg if (s,c,r,y,l) in mvStorageStore)+sum(model.vStorageAOut[s,c,r,y,l] for s in stg if (s,c,r,y,l) in mvStorageAOut));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqCost ", end = "")
# eqCost(region, year)$mvTotalCost(region, year)
model.eqCost = Constraint(mvTotalCost, rule = lambda model, r, y : model.vTotalCost[r,y]  ==  sum(model.vTechEac[h,r,y] for h in tech if (h,r,y) in mTechEac)+sum(model.vTechOMCost[h,r,y] for h in tech if (h,r,y) in mTechOMCost)+sum(model.vSupCost[u,r,y] for u in sup if (u,r,y) in mvSupCost)+sum(pDummyImportCost.get((c,r,y,l))*model.vDummyImport[c,r,y,l] for c in comm for l in slice if (c,r,y,l) in mDummyImport)+sum(pDummyExportCost.get((c,r,y,l))*model.vDummyExport[c,r,y,l] for c in comm for l in slice if (c,r,y,l) in mDummyExport)+sum(model.vTaxCost[c,r,y] for c in comm if (c,r,y) in mTaxCost)-sum(model.vSubsCost[c,r,y] for c in comm if (c,r,y) in mSubCost)+sum(model.vStorageOMCost[s,r,y] for s in stg if (s,r,y) in mStorageOMCost)+sum(model.vStorageEac[s,r,y] for s in stg if (s,r,y) in mStorageEac)+(model.vTradeCost[r,y] if (r,y) in mvTradeCost else 0)+(model.vTotalUserCosts[r,y] if (r,y) in mvTotalUserCosts else 0));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqTaxCost ", end = "")
# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
model.eqTaxCost = Constraint(mTaxCost, rule = lambda model, c, r, y : model.vTaxCost[c,r,y]  ==  sum(pTaxCostOut.get((c,r,y,l))*model.vOutTot[c,r,y,l] for l in slice if ((c,r,y,l) in mvOutTot and (c,l) in mCommSlice))+sum(pTaxCostInp.get((c,r,y,l))*model.vInpTot[c,r,y,l] for l in slice if ((c,r,y,l) in mvInpTot and (c,l) in mCommSlice))+sum(pTaxCostBal.get((c,r,y,l))*model.vBalance[c,r,y,l] for l in slice if ((c,r,y,l) in mvBalance and (c,l) in mCommSlice)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqSubsCost ", end = "")
# eqSubsCost(comm, region, year)$mSubCost(comm, region, year)
model.eqSubsCost = Constraint(mSubCost, rule = lambda model, c, r, y : model.vSubsCost[c,r,y]  ==  sum(pSubCostOut.get((c,r,y,l))*model.vOutTot[c,r,y,l] for l in slice if ((c,r,y,l) in mvOutTot and (c,l) in mCommSlice))+sum(pSubCostInp.get((c,r,y,l))*model.vInpTot[c,r,y,l] for l in slice if ((c,r,y,l) in mvInpTot and (c,l) in mCommSlice))+sum(pSubCostBal.get((c,r,y,l))*model.vBalance[c,r,y,l] for l in slice if ((c,r,y,l) in mvBalance and (c,l) in mCommSlice)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqObjective ", end = "")
# eqObjective
model.eqObjective = Constraint(rule = lambda model : model.vObjective  ==  sum(model.vTotalCost[r,y]*pDiscountFactorMileStone.get((r,y)) for r in region for y in year if (r,y) in mvTotalCost));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
if verbose: print("eqLECActivity ", end = "")
# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
model.eqLECActivity = Constraint(meqLECActivity, rule = lambda model, h, r, y : sum(model.vTechAct[h,r,y,l] for l in slice if (h,l) in mTechSlice)  >=  pLECLoACT.get((r)));
if verbose: print(datetime.datetime.now().strftime("%H:%M:%S"), " (", round(time.time() - seconds, 2), " s)", sep = "")
model.obj = Objective(rule = lambda model: model.vObjective, sense = minimize);
exec(open("inc3.py").read())
model.fornontriv = Var(domain = pyo.NonNegativeReals)
model.eqnontriv = Constraint(rule = lambda model: model.fornontriv == 0)
exec(open("inc_constraints.py").read())
exec(open("inc_costs.py").read())
exec(open("inc_solver.py").read())
# opt = SolverFactory('cplex');
exec(open("inc4.py").read())
flog.write('"solver",,"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
print("solving... ");
slv = opt.solve(model, tee = True)
print("done " + str(datetime.datetime.now().strftime("%H:%M:%S")) + " (" + str(round(time.time() - seconds, 2)) + " s)");
flog.write('"solution status",' + str((slv.solver.status == SolverStatus.ok) *1) + ',"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
flog.write('"export results",,"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
exec(open("inc5.py").read())
exec(open("output.py").read())
flog.write('"done",,"' + str(datetime.datetime.now().strftime("%H:%M:%S")) + '"\n')
flog.close();
