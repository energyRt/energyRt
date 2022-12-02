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
model.vTechInv = Var(model.mTechInv, doc = "Overnight investment costs");
model.vTechEac = Var(model.mTechEac, doc = "Annualized investment costs");
model.vTechOMCost = Var(model.mTechOMCost, doc = "Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)");
model.vSupCost = Var(model.mvSupCost, doc = "Supply costs");
model.vEmsFuelTot = Var(model.mEmsFuelTot, doc = "Total emissions from fuels combustion");
model.vBalance = Var(model.mvBalance, doc = "Net commodity balance");
model.vTotalCost = Var(model.mvTotalCost, doc = "Regional annual total costs");
model.vObjective = Var(doc = "Objective costs");
model.vTaxCost = Var(model.mTaxCost, doc = "Total tax levies (tax costs)");
model.vSubsCost = Var(model.mSubCost, doc = "Total subsidies (for substraction from costs)");
model.vAggOut = Var(model.mAggOut, doc = "Aggregated commodity output");
model.vStorageOMCost = Var(model.mStorageOMCost, doc = "Storage O&M costs");
model.vTradeCost = Var(model.mvTradeCost, doc = "Total trade costs");
model.vTradeRowCost = Var(model.mvTradeRowCost, doc = "Trade with ROW costs");
model.vTradeIrCost = Var(model.mvTradeIrCost, doc = "Interregional trade costs");
model.vTechNewCap = Var(model.mTechNew, domain = pyo.NonNegativeReals, doc = "New capacity");
model.vTechRetiredStock = Var(model.mvTechRetiredStock, domain = pyo.NonNegativeReals, doc = "Early retired stock");
model.vTechRetiredNewCap = Var(model.mvTechRetiredNewCap, domain = pyo.NonNegativeReals, doc = "Early retired new capacity");
model.vTechCap = Var(model.mTechSpan, domain = pyo.NonNegativeReals, doc = "Total capacity of the technology");
model.vTechAct = Var(model.mvTechAct, domain = pyo.NonNegativeReals, doc = "Activity level of technology");
model.vTechInp = Var(model.mvTechInp, domain = pyo.NonNegativeReals, doc = "Input level");
model.vTechOut = Var(model.mvTechOut, domain = pyo.NonNegativeReals, doc = "Output level");
model.vTechAInp = Var(model.mvTechAInp, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity input");
model.vTechAOut = Var(model.mvTechAOut, domain = pyo.NonNegativeReals, doc = "Auxiliary commodity output");
model.vSupOut = Var(model.mSupAva, domain = pyo.NonNegativeReals, doc = "Output of supply");
model.vSupReserve = Var(model.mvSupReserve, domain = pyo.NonNegativeReals, doc = "Total supply reserve");
model.vDemInp = Var(model.mvDemInp, domain = pyo.NonNegativeReals, doc = "Input to demand");
model.vOutTot = Var(model.mvOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output (consumption is not substracted)");
model.vInpTot = Var(model.mvInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input");
model.vInp2Lo = Var(model.mvInp2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for input parent to (grand)child");
model.vOut2Lo = Var(model.mvOut2Lo, domain = pyo.NonNegativeReals, doc = "Desagregation of slices for output parent to (grand)child");
model.vSupOutTot = Var(model.mSupOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity supply");
model.vTechInpTot = Var(model.mTechInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to technologies");
model.vTechOutTot = Var(model.mTechOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from technologies");
model.vStorageInpTot = Var(model.mStorageInpTot, domain = pyo.NonNegativeReals, doc = "Total commodity input to storage");
model.vStorageOutTot = Var(model.mStorageOutTot, domain = pyo.NonNegativeReals, doc = "Total commodity output from storage");
model.vStorageAInp = Var(model.mvStorageAInp, domain = pyo.NonNegativeReals, doc = "Aux-commodity input to storage");
model.vStorageAOut = Var(model.mvStorageAOut, domain = pyo.NonNegativeReals, doc = "Aux-commodity input from storage");
model.vDummyImport = Var(model.mDummyImport, domain = pyo.NonNegativeReals, doc = "Dummy import (for debugging)");
model.vDummyExport = Var(model.mDummyExport, domain = pyo.NonNegativeReals, doc = "Dummy export (for debugging)");
model.vStorageInp = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage input");
model.vStorageOut = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage output");
model.vStorageStore = Var(model.mvStorageStore, domain = pyo.NonNegativeReals, doc = "Storage level");
model.vStorageInv = Var(model.mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage investments");
model.vStorageEac = Var(model.mStorageEac, domain = pyo.NonNegativeReals, doc = "Storage EAC investments");
model.vStorageCap = Var(model.mStorageSpan, domain = pyo.NonNegativeReals, doc = "Storage capacity");
model.vStorageNewCap = Var(model.mStorageNew, domain = pyo.NonNegativeReals, doc = "Storage new capacity");
model.vImport = Var(model.mImport, domain = pyo.NonNegativeReals, doc = "Total regional import (Ir + ROW)");
model.vExport = Var(model.mExport, domain = pyo.NonNegativeReals, doc = "Total regional export (Ir + ROW)");
model.vTradeIr = Var(model.mvTradeIr, domain = pyo.NonNegativeReals, doc = "Total physical trade flows between regions");
model.vTradeIrAInp = Var(model.mvTradeIrAInp, domain = pyo.NonNegativeReals, doc = "Trade auxilari input");
model.vTradeIrAInpTot = Var(model.mvTradeIrAInpTot, domain = pyo.NonNegativeReals, doc = "Trade total auxilari input");
model.vTradeIrAOut = Var(model.mvTradeIrAOut, domain = pyo.NonNegativeReals, doc = "Trade auxilari output");
model.vTradeIrAOutTot = Var(model.mvTradeIrAOutTot, domain = pyo.NonNegativeReals, doc = "Trade auxilari output total");
model.vExportRowAccumulated = Var(model.mExpComm, domain = pyo.NonNegativeReals, doc = "Accumulated export to ROW");
model.vExportRow = Var(model.mExportRow, domain = pyo.NonNegativeReals, doc = "Export to ROW");
model.vImportRowAccumulated = Var(model.mImpComm, domain = pyo.NonNegativeReals, doc = "Accumulated import from ROW");
model.vImportRow = Var(model.mImportRow, domain = pyo.NonNegativeReals, doc = "Import from ROW");
model.vTradeCap = Var(model.mTradeSpan, domain = pyo.NonNegativeReals, doc = "Trade capacity");
model.vTradeInv = Var(model.mTradeEac, domain = pyo.NonNegativeReals, doc = "Investment in trade capacity (overnight)");
model.vTradeEac = Var(model.mTradeEac, domain = pyo.NonNegativeReals, doc = "Investment in trade capacity (EAC)");
model.vTradeNewCap = Var(model.mTradeNew, domain = pyo.NonNegativeReals, doc = "New trade capacity");
model.vTotalUserCosts = Var(model.mvTotalUserCosts, domain = pyo.NonNegativeReals, doc = "Total additional costs (set by user)");
# eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)
model.eqTechSng2Sng = Constraint(model.meqTechSng2Sng, rule = lambda model, h, r, c, cp, y, l : model.vTechInp[h,c,r,y,l]*model.pTechCinp2use[h,c,r,y,l]  ==  (model.vTechOut[h,cp,r,y,l]) / (model.pTechUse2cact[h,cp,r,y,l]*model.pTechCact2cout[h,cp,r,y,l]));
# eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)
model.eqTechGrp2Sng = Constraint(model.meqTechGrp2Sng, rule = lambda model, h, r, g, cp, y, l : model.pTechGinp2use[h,g,r,y,l]*sum(((model.vTechInp[h,c,r,y,l]*model.pTechCinp2ginp[h,c,r,y,l]) if (h,c,r,y,l) in model.mvTechInp else 0) for c in model.comm if (h,g,c) in model.mTechGroupComm)  ==  (model.vTechOut[h,cp,r,y,l]) / (model.pTechUse2cact[h,cp,r,y,l]*model.pTechCact2cout[h,cp,r,y,l]));
# eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)
model.eqTechSng2Grp = Constraint(model.meqTechSng2Grp, rule = lambda model, h, r, c, gp, y, l : model.vTechInp[h,c,r,y,l]*model.pTechCinp2use[h,c,r,y,l]  ==  sum((((model.vTechOut[h,cp,r,y,l]) / (model.pTechUse2cact[h,cp,r,y,l]*model.pTechCact2cout[h,cp,r,y,l])) if (h,cp,r,y,l) in model.mvTechOut else 0) for cp in model.comm if (h,gp,cp) in model.mTechGroupComm));
# eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)
model.eqTechGrp2Grp = Constraint(model.meqTechGrp2Grp, rule = lambda model, h, r, g, gp, y, l : model.pTechGinp2use[h,g,r,y,l]*sum(((model.vTechInp[h,c,r,y,l]*model.pTechCinp2ginp[h,c,r,y,l]) if (h,c,r,y,l) in model.mvTechInp else 0) for c in model.comm if (h,g,c) in model.mTechGroupComm)  ==  sum((((model.vTechOut[h,cp,r,y,l]) / (model.pTechUse2cact[h,cp,r,y,l]*model.pTechCact2cout[h,cp,r,y,l])) if (h,cp,r,y,l) in model.mvTechOut else 0) for cp in model.comm if (h,gp,cp) in model.mTechGroupComm));
# eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)
model.eqTechShareInpLo = Constraint(model.meqTechShareInpLo, rule = lambda model, h, r, g, c, y, l : model.vTechInp[h,c,r,y,l]  >=  model.pTechShareLo[h,c,r,y,l]*sum((model.vTechInp[h,cp,r,y,l] if (h,cp,r,y,l) in model.mvTechInp else 0) for cp in model.comm if (h,g,cp) in model.mTechGroupComm));
# eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)
model.eqTechShareInpUp = Constraint(model.meqTechShareInpUp, rule = lambda model, h, r, g, c, y, l : model.vTechInp[h,c,r,y,l] <=  model.pTechShareUp[h,c,r,y,l]*sum((model.vTechInp[h,cp,r,y,l] if (h,cp,r,y,l) in model.mvTechInp else 0) for cp in model.comm if (h,g,cp) in model.mTechGroupComm));
# eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)
model.eqTechShareOutLo = Constraint(model.meqTechShareOutLo, rule = lambda model, h, r, g, c, y, l : model.vTechOut[h,c,r,y,l]  >=  model.pTechShareLo[h,c,r,y,l]*sum((model.vTechOut[h,cp,r,y,l] if (h,cp,r,y,l) in model.mvTechOut else 0) for cp in model.comm if (h,g,cp) in model.mTechGroupComm));
# eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)
model.eqTechShareOutUp = Constraint(model.meqTechShareOutUp, rule = lambda model, h, r, g, c, y, l : model.vTechOut[h,c,r,y,l] <=  model.pTechShareUp[h,c,r,y,l]*sum((model.vTechOut[h,cp,r,y,l] if (h,cp,r,y,l) in model.mvTechOut else 0) for cp in model.comm if (h,g,cp) in model.mTechGroupComm));
# eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)
model.eqTechAInp = Constraint(model.mvTechAInp, rule = lambda model, h, c, r, y, l : model.vTechAInp[h,c,r,y,l]  ==  ((model.vTechAct[h,r,y,l]*model.pTechAct2AInp[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechAct2AInp else 0)+((model.vTechCap[h,r,y]*model.pTechCap2AInp[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechCap2AInp else 0)+((model.vTechNewCap[h,r,y]*model.pTechNCap2AInp[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechNCap2AInp else 0)+sum(model.pTechCinp2AInp[h,c,cp,r,y,l]*model.vTechInp[h,cp,r,y,l] for cp in model.comm if (h,c,cp,r,y,l) in model.mTechCinp2AInp)+sum(model.pTechCout2AInp[h,c,cp,r,y,l]*model.vTechOut[h,cp,r,y,l] for cp in model.comm if (h,c,cp,r,y,l) in model.mTechCout2AInp));
# eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)
model.eqTechAOut = Constraint(model.mvTechAOut, rule = lambda model, h, c, r, y, l : model.vTechAOut[h,c,r,y,l]  ==  ((model.vTechAct[h,r,y,l]*model.pTechAct2AOut[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechAct2AOut else 0)+((model.vTechCap[h,r,y]*model.pTechCap2AOut[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechCap2AOut else 0)+((model.vTechNewCap[h,r,y]*model.pTechNCap2AOut[h,c,r,y,l]) if (h,c,r,y,l) in model.mTechNCap2AOut else 0)+sum(model.pTechCinp2AOut[h,c,cp,r,y,l]*model.vTechInp[h,cp,r,y,l] for cp in model.comm if (h,c,cp,r,y,l) in model.mTechCinp2AOut)+sum(model.pTechCout2AOut[h,c,cp,r,y,l]*model.vTechOut[h,cp,r,y,l] for cp in model.comm if (h,c,cp,r,y,l) in model.mTechCout2AOut));
# eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)
model.eqTechAfLo = Constraint(model.meqTechAfLo, rule = lambda model, h, r, y, l : model.pTechAfLo[h,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfLo[w,h]*model.pWeather[w,r,y,l] for w in model.weather if (w,h) in model.mTechWeatherAfLo) <=  model.vTechAct[h,r,y,l]);
# eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)
model.eqTechAfUp = Constraint(model.meqTechAfUp, rule = lambda model, h, r, y, l : model.vTechAct[h,r,y,l] <=  model.pTechAfUp[h,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfUp[w,h]*model.pWeather[w,r,y,l] for w in model.weather if (w,h) in model.mTechWeatherAfUp));
# eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)
model.eqTechAfsLo = Constraint(model.meqTechAfsLo, rule = lambda model, h, r, y, l : model.pTechAfsLo[h,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfsLo[w,h]*model.pWeather[w,r,y,l] for w in model.weather if (w,h) in model.mTechWeatherAfsLo) <=  sum((model.vTechAct[h,r,y,lp] if (h,r,y,lp) in model.mvTechAct else 0) for lp in model.slice if (l,lp) in model.mSliceParentChildE));
# eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)
model.eqTechAfsUp = Constraint(model.meqTechAfsUp, rule = lambda model, h, r, y, l : sum((model.vTechAct[h,r,y,lp] if (h,r,y,lp) in model.mvTechAct else 0) for lp in model.slice if (l,lp) in model.mSliceParentChildE) <=  model.pTechAfsUp[h,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfsUp[w,h]*model.pWeather[w,r,y,l] for w in model.weather if (w,h) in model.mTechWeatherAfsUp));
# eqTechRampUp(tech, region, year, slice)$mTechRampUp(tech, region, year, slice)
model.eqTechRampUp = Constraint(model.mTechRampUp, rule = lambda model, h, r, y, l : (model.vTechAct[h,r,y,l]) / (model.pSliceShare[l])-sum((model.vTechAct[h,r,y,lp]) / (model.pSliceShare[lp]) for lp in model.slice if (((h in model.mTechFullYear and (lp,l) in model.mSliceNext) or (not((h in model.mTechFullYear)) and (lp,l) in model.mSliceFYearNext)) and (h,r,y,lp) in model.mvTechAct)) <=  (model.pSliceShare[l]*365*24*model.pTechCap2act[h]*model.vTechCap[h,r,y]) / (model.pTechRampUp[h,r,y,l]));
# eqTechRampDown(tech, region, year, slice)$mTechRampDown(tech, region, year, slice)
model.eqTechRampDown = Constraint(model.mTechRampDown, rule = lambda model, h, r, y, l : sum((model.vTechAct[h,r,y,lp]) / (model.pSliceShare[lp]) for lp in model.slice if (((h in model.mTechFullYear and (lp,l) in model.mSliceNext) or (not((h in model.mTechFullYear)) and (lp,l) in model.mSliceFYearNext)) and (h,r,y,lp) in model.mvTechAct))-(model.vTechAct[h,r,y,l]) / (model.pSliceShare[l]) <=  (model.pSliceShare[l]*365*24*model.pTechCap2act[h]*model.vTechCap[h,r,y]) / (model.pTechRampDown[h,r,y,l]));
# eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)
model.eqTechActSng = Constraint(model.meqTechActSng, rule = lambda model, h, c, r, y, l : model.vTechAct[h,r,y,l]  ==  (model.vTechOut[h,c,r,y,l]) / (model.pTechCact2cout[h,c,r,y,l]));
# eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)
model.eqTechActGrp = Constraint(model.meqTechActGrp, rule = lambda model, h, g, r, y, l : model.vTechAct[h,r,y,l]  ==  sum((((model.vTechOut[h,c,r,y,l]) / (model.pTechCact2cout[h,c,r,y,l])) if (h,c,r,y,l) in model.mvTechOut else 0) for c in model.comm if (h,g,c) in model.mTechGroupComm));
# eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)
model.eqTechAfcOutLo = Constraint(model.meqTechAfcOutLo, rule = lambda model, h, r, c, y, l : model.pTechCact2cout[h,c,r,y,l]*model.pTechAfcLo[h,c,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfcLo[w,h,c]*model.pWeather[w,r,y,l] for w in model.weather if (w,h,c) in model.mTechWeatherAfcLo) <=  model.vTechOut[h,c,r,y,l]);
# eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)
model.eqTechAfcOutUp = Constraint(model.meqTechAfcOutUp, rule = lambda model, h, r, c, y, l : model.vTechOut[h,c,r,y,l] <=  model.pTechCact2cout[h,c,r,y,l]*model.pTechAfcUp[h,c,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*prod(model.pTechWeatherAfcUp[w,h,c]*model.pWeather[w,r,y,l] for w in model.weather if (w,h,c) in model.mTechWeatherAfcUp));
# eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)
model.eqTechAfcInpLo = Constraint(model.meqTechAfcInpLo, rule = lambda model, h, r, c, y, l : model.pTechAfcLo[h,c,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfcLo[w,h,c]*model.pWeather[w,r,y,l] for w in model.weather if (w,h,c) in model.mTechWeatherAfcLo) <=  model.vTechInp[h,c,r,y,l]);
# eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)
model.eqTechAfcInpUp = Constraint(model.meqTechAfcInpUp, rule = lambda model, h, r, c, y, l : model.vTechInp[h,c,r,y,l] <=  model.pTechAfcUp[h,c,r,y,l]*model.pTechCap2act[h]*model.vTechCap[h,r,y]*model.pSliceShare[l]*prod(model.pTechWeatherAfcUp[w,h,c]*model.pWeather[w,r,y,l] for w in model.weather if (w,h,c) in model.mTechWeatherAfcUp));
# eqTechCap(tech, region, year)$mTechSpan(tech, region, year)
model.eqTechCap = Constraint(model.mTechSpan, rule = lambda model, h, r, y : model.vTechCap[h,r,y]  ==  model.pTechStock[h,r,y]-(model.vTechRetiredStock[h,r,y] if (h,r,y) in model.mvTechRetiredStock else 0)+sum(model.pPeriodLen[yp]*(model.vTechNewCap[h,r,yp]-sum(model.vTechRetiredNewCap[h,r,yp,ye] for ye in model.year if ((h,r,yp,ye) in model.mvTechRetiredNewCap and model.ordYear[y] >= model.ordYear[ye]))) for yp in model.year if ((h,r,yp) in model.mTechNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTechOlife[h,r]+model.ordYear[yp] or (h,r) in model.mTechOlifeInf))));
# eqTechRetiredNewCap(tech, region, year)$meqTechRetiredNewCap(tech, region, year)
model.eqTechRetiredNewCap = Constraint(model.meqTechRetiredNewCap, rule = lambda model, h, r, y : sum(model.vTechRetiredNewCap[h,r,y,yp] for yp in model.year if (h,r,y,yp) in model.mvTechRetiredNewCap) <=  model.vTechNewCap[h,r,y]);
# eqTechRetiredStock(tech, region, year)$mvTechRetiredStock(tech, region, year)
model.eqTechRetiredStock = Constraint(model.mvTechRetiredStock, rule = lambda model, h, r, y : model.vTechRetiredStock[h,r,y] <=  model.pTechStock[h,r,y]);
# eqTechEac(tech, region, year)$mTechEac(tech, region, year)
model.eqTechEac = Constraint(model.mTechEac, rule = lambda model, h, r, y : model.vTechEac[h,r,y]  ==  sum(model.pTechEac[h,r,yp]*model.pPeriodLen[yp]*(model.vTechNewCap[h,r,yp]-sum(model.vTechRetiredNewCap[h,r,yp,ye] for ye in model.year if ((h,r,yp,ye) in model.mvTechRetiredNewCap and model.ordYear[y] >= model.ordYear[ye]))) for yp in model.year if ((h,r,yp) in model.mTechNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTechOlife[h,r]+model.ordYear[yp] or (h,r) in model.mTechOlifeInf))));
# eqTechInv(tech, region, year)$mTechInv(tech, region, year)
model.eqTechInv = Constraint(model.mTechInv, rule = lambda model, h, r, y : model.vTechInv[h,r,y]  ==  model.pTechInvcost[h,r,y]*model.vTechNewCap[h,r,y]);
# eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)
model.eqTechOMCost = Constraint(model.mTechOMCost, rule = lambda model, h, r, y : model.vTechOMCost[h,r,y]  ==  model.pTechFixom[h,r,y]*model.vTechCap[h,r,y]+sum(model.pTechVarom[h,r,y,l]*model.vTechAct[h,r,y,l]+sum(model.pTechCvarom[h,c,r,y,l]*model.vTechInp[h,c,r,y,l] for c in model.comm if (h,c) in model.mTechInpComm)+sum(model.pTechCvarom[h,c,r,y,l]*model.vTechOut[h,c,r,y,l] for c in model.comm if (h,c) in model.mTechOutComm)+sum(model.pTechAvarom[h,c,r,y,l]*model.vTechAOut[h,c,r,y,l] for c in model.comm if (h,c,r,y,l) in model.mvTechAOut)+sum(model.pTechAvarom[h,c,r,y,l]*model.vTechAInp[h,c,r,y,l] for c in model.comm if (h,c,r,y,l) in model.mvTechAInp) for l in model.slice if (h,l) in model.mTechSlice));
# eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)
model.eqSupAvaUp = Constraint(model.mSupAvaUp, rule = lambda model, u, c, r, y, l : model.vSupOut[u,c,r,y,l] <=  model.pSupAvaUp[u,c,r,y,l]*prod(model.pSupWeatherUp[w,u]*model.pWeather[w,r,y,l] for w in model.weather if (w,u) in model.mSupWeatherUp));
# eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)
model.eqSupAvaLo = Constraint(model.meqSupAvaLo, rule = lambda model, u, c, r, y, l : model.vSupOut[u,c,r,y,l]  >=  model.pSupAvaLo[u,c,r,y,l]*prod(model.pSupWeatherLo[w,u]*model.pWeather[w,r,y,l] for w in model.weather if (w,u) in model.mSupWeatherLo));
# eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)
model.eqSupTotal = Constraint(model.mvSupReserve, rule = lambda model, u, c, r : model.vSupReserve[u,c,r]  ==  sum(model.pPeriodLen[y]*model.vSupOut[u,c,r,y,l] for y in model.year for l in model.slice if (u,c,r,y,l) in model.mSupAva));
# eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)
model.eqSupReserveUp = Constraint(model.mSupReserveUp, rule = lambda model, u, c, r : model.pSupReserveUp[u,c,r]  >=  model.vSupReserve[u,c,r]);
# eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)
model.eqSupReserveLo = Constraint(model.meqSupReserveLo, rule = lambda model, u, c, r : model.vSupReserve[u,c,r]  >=  model.pSupReserveLo[u,c,r]);
# eqSupCost(sup, region, year)$mvSupCost(sup, region, year)
model.eqSupCost = Constraint(model.mvSupCost, rule = lambda model, u, r, y : model.vSupCost[u,r,y]  ==  sum(model.pSupCost[u,c,r,y,l]*model.vSupOut[u,c,r,y,l] for c in model.comm for l in model.slice if (u,c,r,y,l) in model.mSupAva));
# eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)
model.eqDemInp = Constraint(model.mvDemInp, rule = lambda model, c, r, y, l : model.vDemInp[c,r,y,l]  ==  sum(model.pDemand[d,c,r,y,l] for d in model.trade if (d,c) in model.mDemComm));
# eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)
model.eqAggOut = Constraint(model.mAggOut, rule = lambda model, c, r, y, l : model.vAggOut[c,r,y,l]  ==  sum(model.pAggregateFactor[c,cp]*sum(model.vOutTot[cp,r,y,lp] for lp in model.slice if ((c,r,y,lp) in model.mvOutTot and (l,lp) in model.mSliceParentChildE and (cp,lp) in model.mCommSlice)) for cp in model.comm if (c,cp) in model.mAggregateFactor));
# eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)
model.eqEmsFuelTot = Constraint(model.mEmsFuelTot, rule = lambda model, c, r, y, l : model.vEmsFuelTot[c,r,y,l]  ==  sum(model.pEmissionFactor[c,cp]*sum(model.pTechEmisComm[h,cp]*sum((model.vTechInp[h,cp,r,y,lp] if (h,c,cp,r,y,lp) in model.mTechEmsFuel else 0) for lp in model.slice if (c,l,lp) in model.mCommSliceOrParent) for h in model.tech if (h,cp) in model.mTechInpComm) for cp in model.comm if (model.pEmissionFactor[c,cp]>0)));
# eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)
model.eqStorageAInp = Constraint(model.mvStorageAInp, rule = lambda model, s, c, r, y, l : model.vStorageAInp[s,c,r,y,l]  ==  sum(((model.pStorageStg2AInp[s,c,r,y,l]*model.vStorageStore[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageStg2AInp else 0)+((model.pStorageCinp2AInp[s,c,r,y,l]*model.vStorageInp[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageCinp2AInp else 0)+((model.pStorageCout2AInp[s,c,r,y,l]*model.vStorageOut[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageCout2AInp else 0)+((model.pStorageCap2AInp[s,c,r,y,l]*model.vStorageCap[s,r,y]) if (s,c,r,y,l) in model.mStorageCap2AInp else 0)+((model.pStorageNCap2AInp[s,c,r,y,l]*model.vStorageNewCap[s,r,y]) if (s,c,r,y,l) in model.mStorageNCap2AInp else 0) for cp in model.comm if (s,cp) in model.mStorageComm));
# eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)
model.eqStorageAOut = Constraint(model.mvStorageAOut, rule = lambda model, s, c, r, y, l : model.vStorageAOut[s,c,r,y,l]  ==  sum(((model.pStorageStg2AOut[s,c,r,y,l]*model.vStorageStore[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageStg2AOut else 0)+((model.pStorageCinp2AOut[s,c,r,y,l]*model.vStorageInp[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageCinp2AOut else 0)+((model.pStorageCout2AOut[s,c,r,y,l]*model.vStorageOut[s,cp,r,y,l]) if (s,c,r,y,l) in model.mStorageCout2AOut else 0)+((model.pStorageCap2AOut[s,c,r,y,l]*model.vStorageCap[s,r,y]) if (s,c,r,y,l) in model.mStorageCap2AOut else 0)+((model.pStorageNCap2AOut[s,c,r,y,l]*model.vStorageNewCap[s,r,y]) if (s,c,r,y,l) in model.mStorageNCap2AOut else 0) for cp in model.comm if (s,cp) in model.mStorageComm));
# eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageStore = Constraint(model.mvStorageStore, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l]  ==  model.pStorageCharge[s,c,r,y,l]+((model.pStorageNCap2Stg[s,c,r,y,l]*model.vStorageNewCap[s,r,y]) if (s,r,y) in model.mStorageNew else 0)+sum(model.pStorageInpEff[s,c,r,y,lp]*model.vStorageInp[s,c,r,y,lp]+((model.pStorageStgEff[s,c,r,y,l])**(model.pSliceShare[l]))*model.vStorageStore[s,c,r,y,lp]-(model.vStorageOut[s,c,r,y,lp]) / (model.pStorageOutEff[s,c,r,y,lp]) for lp in model.slice if ((c,lp) in model.mCommSlice and ((not((s in model.mStorageFullYear)) and (lp,l) in model.mSliceNext) or (s in model.mStorageFullYear and (lp,l) in model.mSliceFYearNext)))));
# eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)
model.eqStorageAfLo = Constraint(model.meqStorageAfLo, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l]  >=  model.pStorageAfLo[s,r,y,l]*model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*prod(model.pStorageWeatherAfLo[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherAfLo));
# eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)
model.eqStorageAfUp = Constraint(model.meqStorageAfUp, rule = lambda model, s, c, r, y, l : model.vStorageStore[s,c,r,y,l] <=  model.pStorageAfUp[s,r,y,l]*model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*prod(model.pStorageWeatherAfUp[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherAfUp));
# eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)
model.eqStorageClean = Constraint(model.mvStorageStore, rule = lambda model, s, c, r, y, l : (model.vStorageOut[s,c,r,y,l]) / (model.pStorageOutEff[s,c,r,y,l]) <=  model.vStorageStore[s,c,r,y,l]);
# eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)
model.eqStorageInpUp = Constraint(model.meqStorageInpUp, rule = lambda model, s, c, r, y, l : model.vStorageInp[s,c,r,y,l] <=  model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*model.pStorageCinpUp[s,c,r,y,l]*model.pSliceShare[l]*prod(model.pStorageWeatherCinpUp[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherCinpUp));
# eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)
model.eqStorageInpLo = Constraint(model.meqStorageInpLo, rule = lambda model, s, c, r, y, l : model.vStorageInp[s,c,r,y,l]  >=  model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*model.pStorageCinpLo[s,c,r,y,l]*model.pSliceShare[l]*prod(model.pStorageWeatherCinpLo[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherCinpLo));
# eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)
model.eqStorageOutUp = Constraint(model.meqStorageOutUp, rule = lambda model, s, c, r, y, l : model.vStorageOut[s,c,r,y,l] <=  model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*model.pStorageCoutUp[s,c,r,y,l]*model.pSliceShare[l]*prod(model.pStorageWeatherCoutUp[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherCoutUp));
# eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)
model.eqStorageOutLo = Constraint(model.meqStorageOutLo, rule = lambda model, s, c, r, y, l : model.vStorageOut[s,c,r,y,l]  >=  model.pStorageCap2stg[s]*model.vStorageCap[s,r,y]*model.pStorageCoutLo[s,c,r,y,l]*model.pSliceShare[l]*prod(model.pStorageWeatherCoutLo[w,s]*model.pWeather[w,r,y,l] for w in model.weather if (w,s) in model.mStorageWeatherCoutLo));
# eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)
model.eqStorageCap = Constraint(model.mStorageSpan, rule = lambda model, s, r, y : model.vStorageCap[s,r,y]  ==  model.pStorageStock[s,r,y]+sum(model.pPeriodLen[yp]*model.vStorageNewCap[s,r,yp] for yp in model.year if (model.ordYear[y] >= model.ordYear[yp] and ((s,r) in model.mStorageOlifeInf or model.ordYear[y]<model.pStorageOlife[s,r]+model.ordYear[yp]) and (s,r,yp) in model.mStorageNew)));
# eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)
model.eqStorageInv = Constraint(model.mStorageNew, rule = lambda model, s, r, y : model.vStorageInv[s,r,y]  ==  model.pStorageInvcost[s,r,y]*model.vStorageNewCap[s,r,y]);
# eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)
model.eqStorageEac = Constraint(model.mStorageEac, rule = lambda model, s, r, y : model.vStorageEac[s,r,y]  ==  sum(model.pStorageEac[s,r,yp]*model.pPeriodLen[yp]*model.vStorageNewCap[s,r,yp] for yp in model.year if ((s,r,yp) in model.mStorageNew and model.ordYear[y] >= model.ordYear[yp] and ((s,r) in model.mStorageOlifeInf or model.ordYear[y]<model.pStorageOlife[s,r]+model.ordYear[yp]) and model.pStorageInvcost[s,r,yp] != 0)));
# eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)
model.eqStorageCost = Constraint(model.mStorageOMCost, rule = lambda model, s, r, y : model.vStorageOMCost[s,r,y]  ==  model.pStorageFixom[s,r,y]*model.vStorageCap[s,r,y]+sum(sum(model.pStorageCostInp[s,r,y,l]*model.vStorageInp[s,c,r,y,l]+model.pStorageCostOut[s,r,y,l]*model.vStorageOut[s,c,r,y,l]+model.pStorageCostStore[s,r,y,l]*model.vStorageStore[s,c,r,y,l] for l in model.slice if (c,l) in model.mCommSlice) for c in model.comm if (s,c) in model.mStorageComm));
# eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)
model.eqImport = Constraint(model.mImport, rule = lambda model, c, dst, y, l : model.vImport[c,dst,y,l]  ==  sum(sum(sum(((model.pTradeIrEff[d,src,dst,y,lp]*model.vTradeIr[d,c,src,dst,y,lp]) if (d,c,src,dst,y,lp) in model.mvTradeIr else 0) for src in model.region if (d,src,dst) in model.mTradeRoutes) for d in model.trade if (d,c) in model.mTradeComm) for lp in model.slice if (c,l,lp) in model.mCommSliceOrParent)+sum(sum((model.vImportRow[m,c,dst,y,lp] if (m,c,dst,y,lp) in model.mImportRow else 0) for m in model.imp if (m,c) in model.mImpComm) for lp in model.slice if (c,l,lp) in model.mCommSliceOrParent));
# eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)
model.eqExport = Constraint(model.mExport, rule = lambda model, c, src, y, l : model.vExport[c,src,y,l]  ==  sum(sum(sum((model.vTradeIr[d,c,src,dst,y,lp] if (d,c,src,dst,y,lp) in model.mvTradeIr else 0) for dst in model.region if (d,src,dst) in model.mTradeRoutes) for d in model.trade if (d,c) in model.mTradeComm) for lp in model.slice if (c,l,lp) in model.mCommSliceOrParent)+sum(sum((model.vExportRow[x,c,src,y,lp] if (x,c,src,y,lp) in model.mExportRow else 0) for x in model.expp if (x,c) in model.mExpComm) for lp in model.slice if (c,l,lp) in model.mCommSliceOrParent));
# eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)
model.eqTradeFlowUp = Constraint(model.meqTradeFlowUp, rule = lambda model, d, c, src, dst, y, l : model.vTradeIr[d,c,src,dst,y,l] <=  model.pTradeIrUp[d,src,dst,y,l]);
# eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)
model.eqTradeFlowLo = Constraint(model.meqTradeFlowLo, rule = lambda model, d, c, src, dst, y, l : model.vTradeIr[d,c,src,dst,y,l]  >=  model.pTradeIrLo[d,src,dst,y,l]);
# eqCostTrade(region, year)$mvTradeCost(region, year)
model.eqCostTrade = Constraint(model.mvTradeCost, rule = lambda model, r, y : model.vTradeCost[r,y]  ==  (model.vTradeRowCost[r,y] if (r,y) in model.mvTradeRowCost else 0)+(model.vTradeIrCost[r,y] if (r,y) in model.mvTradeIrCost else 0));
# eqCostRowTrade(region, year)$mvTradeRowCost(region, year)
model.eqCostRowTrade = Constraint(model.mvTradeRowCost, rule = lambda model, r, y : model.vTradeRowCost[r,y]  ==  sum(model.pImportRowPrice[m,r,y,l]*model.vImportRow[m,c,r,y,l] for m in model.imp for c in model.comm for l in model.slice if (m,c,r,y,l) in model.mImportRow)-sum(model.pExportRowPrice[x,r,y,l]*model.vExportRow[x,c,r,y,l] for x in model.expp for c in model.comm for l in model.slice if (x,c,r,y,l) in model.mExportRow));
# eqCostIrTrade(region, year)$mvTradeIrCost(region, year)
model.eqCostIrTrade = Constraint(model.mvTradeIrCost, rule = lambda model, r, y : model.vTradeIrCost[r,y]  ==  sum(model.vTradeEac[d,r,y] for d in model.trade if (d,r,y) in model.mTradeEac)+sum(sum(sum(((((model.pTradeIrCost[d,src,r,y,l]+model.pTradeIrMarkup[d,src,r,y,l])*model.vTradeIr[d,c,src,r,y,l])) if (d,c,src,r,y,l) in model.mvTradeIr else 0) for l in model.slice if (d,l) in model.mTradeSlice) for c in model.comm if (d,c) in model.mTradeComm) for d in model.trade for src in model.region if (d,src,r) in model.mTradeRoutes)-sum(sum(sum((((model.pTradeIrMarkup[d,r,dst,y,l]*model.vTradeIr[d,c,r,dst,y,l])) if (d,c,r,dst,y,l) in model.mvTradeIr else 0) for l in model.slice if (d,l) in model.mTradeSlice) for c in model.comm if (d,c) in model.mTradeComm) for d in model.trade for dst in model.region if (d,r,dst) in model.mTradeRoutes));
# eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)
model.eqExportRowUp = Constraint(model.mExportRowUp, rule = lambda model, x, c, r, y, l : model.vExportRow[x,c,r,y,l] <=  model.pExportRowUp[x,r,y,l]);
# eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)
model.eqExportRowLo = Constraint(model.meqExportRowLo, rule = lambda model, x, c, r, y, l : model.vExportRow[x,c,r,y,l]  >=  model.pExportRowLo[x,r,y,l]);
# eqExportRowCumulative(expp, comm)$mExpComm(expp, comm)
model.eqExportRowCumulative = Constraint(model.mExpComm, rule = lambda model, x, c : model.vExportRowAccumulated[x,c]  ==  sum(model.pPeriodLen[y]*model.vExportRow[x,c,r,y,l] for r in model.region for y in model.year for l in model.slice if (x,c,r,y,l) in model.mExportRow));
# eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)
model.eqExportRowResUp = Constraint(model.mExportRowAccumulatedUp, rule = lambda model, x, c : model.vExportRowAccumulated[x,c] <=  model.pExportRowRes[x]);
# eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)
model.eqImportRowUp = Constraint(model.mImportRowUp, rule = lambda model, m, c, r, y, l : model.vImportRow[m,c,r,y,l] <=  model.pImportRowUp[m,r,y,l]);
# eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)
model.eqImportRowLo = Constraint(model.meqImportRowLo, rule = lambda model, m, c, r, y, l : model.vImportRow[m,c,r,y,l]  >=  model.pImportRowLo[m,r,y,l]);
# eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm)
model.eqImportRowAccumulated = Constraint(model.mImpComm, rule = lambda model, m, c : model.vImportRowAccumulated[m,c]  ==  sum(model.pPeriodLen[y]*model.vImportRow[m,c,r,y,l] for r in model.region for y in model.year for l in model.slice if (m,c,r,y,l) in model.mImportRow));
# eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm)
model.eqImportRowResUp = Constraint(model.mImportRowAccumulatedUp, rule = lambda model, m, c : model.vImportRowAccumulated[m,c] <=  model.pImportRowRes[m]);
# eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)
model.eqTradeCapFlow = Constraint(model.meqTradeCapFlow, rule = lambda model, d, c, y, l : model.pSliceShare[l]*model.pTradeCap2Act[d]*model.vTradeCap[d,y]  >=  sum(model.vTradeIr[d,c,src,dst,y,l] for src in model.region for dst in model.region if (d,c,src,dst,y,l) in model.mvTradeIr));
# eqTradeCap(trade, year)$mTradeSpan(trade, year)
model.eqTradeCap = Constraint(model.mTradeSpan, rule = lambda model, d, y : model.vTradeCap[d,y]  ==  model.pTradeStock[d,y]+sum(model.pPeriodLen[yp]*model.vTradeNewCap[d,yp] for yp in model.year if ((d,yp) in model.mTradeNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTradeOlife[d]+model.ordYear[yp] or d in model.mTradeOlifeInf))));
# eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)
model.eqTradeInv = Constraint(model.mTradeInv, rule = lambda model, d, r, y : model.vTradeInv[d,r,y]  ==  model.pTradeInvcost[d,r,y]*model.vTradeNewCap[d,y]);
# eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)
model.eqTradeEac = Constraint(model.mTradeEac, rule = lambda model, d, r, y : model.vTradeEac[d,r,y]  ==  sum(model.pTradeEac[d,r,yp]*model.pPeriodLen[yp]*model.vTradeNewCap[d,yp] for yp in model.year if ((d,yp) in model.mTradeNew and model.ordYear[y] >= model.ordYear[yp] and (model.ordYear[y]<model.pTradeOlife[d]+model.ordYear[yp] or d in model.mTradeOlifeInf))));
# eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)
model.eqTradeIrAInp = Constraint(model.mvTradeIrAInp, rule = lambda model, d, c, r, y, l : model.vTradeIrAInp[d,c,r,y,l]  ==  sum(model.pTradeIrCsrc2Ainp[d,c,r,dst,y,l]*sum(model.vTradeIr[d,cp,r,dst,y,l] for cp in model.comm if (d,cp) in model.mTradeComm) for dst in model.region if (d,c,r,dst,y,l) in model.mTradeIrCsrc2Ainp)+sum(model.pTradeIrCdst2Ainp[d,c,src,r,y,l]*sum(model.vTradeIr[d,cp,src,r,y,l] for cp in model.comm if (d,cp) in model.mTradeComm) for src in model.region if (d,c,src,r,y,l) in model.mTradeIrCdst2Ainp));
# eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)
model.eqTradeIrAOut = Constraint(model.mvTradeIrAOut, rule = lambda model, d, c, r, y, l : model.vTradeIrAOut[d,c,r,y,l]  ==  sum(model.pTradeIrCsrc2Aout[d,c,r,dst,y,l]*sum(model.vTradeIr[d,cp,r,dst,y,l] for cp in model.comm if (d,cp) in model.mTradeComm) for dst in model.region if (d,c,r,dst,y,l) in model.mTradeIrCsrc2Aout)+sum(model.pTradeIrCdst2Aout[d,c,src,r,y,l]*sum(model.vTradeIr[d,cp,src,r,y,l] for cp in model.comm if (d,cp) in model.mTradeComm) for src in model.region if (d,c,src,r,y,l) in model.mTradeIrCdst2Aout));
# eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)
model.eqTradeIrAInpTot = Constraint(model.mvTradeIrAInpTot, rule = lambda model, c, r, y, l : model.vTradeIrAInpTot[c,r,y,l]  ==  sum(model.vTradeIrAInp[d,c,r,y,lp] for d in model.trade for lp in model.slice if ((c,l,lp) in model.mCommSliceOrParent and (d,c,r,y,lp) in model.mvTradeIrAInp)));
# eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)
model.eqTradeIrAOutTot = Constraint(model.mvTradeIrAOutTot, rule = lambda model, c, r, y, l : model.vTradeIrAOutTot[c,r,y,l]  ==  sum(model.vTradeIrAOut[d,c,r,y,lp] for d in model.trade for lp in model.slice if ((c,l,lp) in model.mCommSliceOrParent and (d,c,r,y,lp) in model.mvTradeIrAOut)));
# eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)
model.eqBalLo = Constraint(model.meqBalLo, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  >=  0);
# eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)
model.eqBalUp = Constraint(model.meqBalUp, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l] <=  0);
# eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)
model.eqBalFx = Constraint(model.meqBalFx, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  ==  0);
# eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)
model.eqBal = Constraint(model.mvBalance, rule = lambda model, c, r, y, l : model.vBalance[c,r,y,l]  ==  (model.vOutTot[c,r,y,l] if (c,r,y,l) in model.mvOutTot else 0)-(model.vInpTot[c,r,y,l] if (c,r,y,l) in model.mvInpTot else 0));
# eqOutTot(comm, region, year, slice)$mvOutTot(comm, region, year, slice)
model.eqOutTot = Constraint(model.mvOutTot, rule = lambda model, c, r, y, l : model.vOutTot[c,r,y,l]  ==  (model.vDummyImport[c,r,y,l] if (c,r,y,l) in model.mDummyImport else 0)+(model.vSupOutTot[c,r,y,l] if (c,r,y,l) in model.mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,l] if (c,r,y,l) in model.mEmsFuelTot else 0)+(model.vAggOut[c,r,y,l] if (c,r,y,l) in model.mAggOut else 0)+(model.vTechOutTot[c,r,y,l] if (c,r,y,l) in model.mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,l] if (c,r,y,l) in model.mStorageOutTot else 0)+(model.vImport[c,r,y,l] if (c,r,y,l) in model.mImport else 0)+(model.vTradeIrAOutTot[c,r,y,l] if (c,r,y,l) in model.mvTradeIrAOutTot else 0)+(sum(model.vOut2Lo[c,r,y,lp,l] for lp in model.slice if ((lp,l) in model.mSliceParentChild and (c,r,y,lp,l) in model.mvOut2Lo)) if (c,r,y,l) in model.mOutSub else 0));
# eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)
model.eqOut2Lo = Constraint(model.mOut2Lo, rule = lambda model, c, r, y, l : sum(model.vOut2Lo[c,r,y,l,lp] for lp in model.slice if (c,r,y,l,lp) in model.mvOut2Lo)  ==  (model.vSupOutTot[c,r,y,l] if (c,r,y,l) in model.mSupOutTot else 0)+(model.vEmsFuelTot[c,r,y,l] if (c,r,y,l) in model.mEmsFuelTot else 0)+(model.vAggOut[c,r,y,l] if (c,r,y,l) in model.mAggOut else 0)+(model.vTechOutTot[c,r,y,l] if (c,r,y,l) in model.mTechOutTot else 0)+(model.vStorageOutTot[c,r,y,l] if (c,r,y,l) in model.mStorageOutTot else 0)+(model.vImport[c,r,y,l] if (c,r,y,l) in model.mImport else 0)+(model.vTradeIrAOutTot[c,r,y,l] if (c,r,y,l) in model.mvTradeIrAOutTot else 0));
# eqInpTot(comm, region, year, slice)$mvInpTot(comm, region, year, slice)
model.eqInpTot = Constraint(model.mvInpTot, rule = lambda model, c, r, y, l : model.vInpTot[c,r,y,l]  ==  (model.vDemInp[c,r,y,l] if (c,r,y,l) in model.mvDemInp else 0)+(model.vDummyExport[c,r,y,l] if (c,r,y,l) in model.mDummyExport else 0)+(model.vTechInpTot[c,r,y,l] if (c,r,y,l) in model.mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,l] if (c,r,y,l) in model.mStorageInpTot else 0)+(model.vExport[c,r,y,l] if (c,r,y,l) in model.mExport else 0)+(model.vTradeIrAInpTot[c,r,y,l] if (c,r,y,l) in model.mvTradeIrAInpTot else 0)+(sum(model.vInp2Lo[c,r,y,lp,l] for lp in model.slice if ((lp,l) in model.mSliceParentChild and (c,r,y,lp,l) in model.mvInp2Lo)) if (c,r,y,l) in model.mInpSub else 0));
# eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)
model.eqInp2Lo = Constraint(model.mInp2Lo, rule = lambda model, c, r, y, l : sum(model.vInp2Lo[c,r,y,l,lp] for lp in model.slice if (c,r,y,l,lp) in model.mvInp2Lo)  ==  (model.vTechInpTot[c,r,y,l] if (c,r,y,l) in model.mTechInpTot else 0)+(model.vStorageInpTot[c,r,y,l] if (c,r,y,l) in model.mStorageInpTot else 0)+(model.vExport[c,r,y,l] if (c,r,y,l) in model.mExport else 0)+(model.vTradeIrAInpTot[c,r,y,l] if (c,r,y,l) in model.mvTradeIrAInpTot else 0));
# eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)
model.eqSupOutTot = Constraint(model.mSupOutTot, rule = lambda model, c, r, y, l : model.vSupOutTot[c,r,y,l]  ==  sum(sum(model.vSupOut[u,c,r,y,lp] for lp in model.slice if ((c,l,lp) in model.mCommSliceOrParent and (u,c,r,y,lp) in model.mSupAva)) for u in model.sup if (u,c) in model.mSupComm));
# eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)
model.eqTechInpTot = Constraint(model.mTechInpTot, rule = lambda model, c, r, y, l : model.vTechInpTot[c,r,y,l]  ==  sum(sum((model.vTechInp[h,c,r,y,lp] if (h,c,r,y,lp) in model.mvTechInp else 0) for lp in model.slice if ((h,lp) in model.mTechSlice and (c,l,lp) in model.mCommSliceOrParent)) for h in model.tech if (h,c) in model.mTechInpComm)+sum(sum((model.vTechAInp[h,c,r,y,lp] if (h,c,r,y,lp) in model.mvTechAInp else 0) for lp in model.slice if ((h,lp) in model.mTechSlice and (c,l,lp) in model.mCommSliceOrParent)) for h in model.tech if (h,c) in model.mTechAInp));
# eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)
model.eqTechOutTot = Constraint(model.mTechOutTot, rule = lambda model, c, r, y, l : model.vTechOutTot[c,r,y,l]  ==  sum(sum((model.vTechOut[h,c,r,y,lp] if (h,c,r,y,lp) in model.mvTechOut else 0) for lp in model.slice if ((h,lp) in model.mTechSlice and (c,l,lp) in model.mCommSliceOrParent)) for h in model.tech if (h,c) in model.mTechOutComm)+sum(sum((model.vTechAOut[h,c,r,y,lp] if (h,c,r,y,lp) in model.mvTechAOut else 0) for lp in model.slice if ((h,lp) in model.mTechSlice and (c,l,lp) in model.mCommSliceOrParent)) for h in model.tech if (h,c) in model.mTechAOut));
# eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)
model.eqStorageInpTot = Constraint(model.mStorageInpTot, rule = lambda model, c, r, y, l : model.vStorageInpTot[c,r,y,l]  ==  sum(model.vStorageInp[s,c,r,y,l] for s in model.stg if (s,c,r,y,l) in model.mvStorageStore)+sum(model.vStorageAInp[s,c,r,y,l] for s in model.stg if (s,c,r,y,l) in model.mvStorageAInp));
# eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)
model.eqStorageOutTot = Constraint(model.mStorageOutTot, rule = lambda model, c, r, y, l : model.vStorageOutTot[c,r,y,l]  ==  sum(model.vStorageOut[s,c,r,y,l] for s in model.stg if (s,c,r,y,l) in model.mvStorageStore)+sum(model.vStorageAOut[s,c,r,y,l] for s in model.stg if (s,c,r,y,l) in model.mvStorageAOut));
# eqCost(region, year)$mvTotalCost(region, year)
model.eqCost = Constraint(model.mvTotalCost, rule = lambda model, r, y : model.vTotalCost[r,y]  ==  sum(model.vTechEac[h,r,y] for h in model.tech if (h,r,y) in model.mTechEac)+sum(model.vTechOMCost[h,r,y] for h in model.tech if (h,r,y) in model.mTechOMCost)+sum(model.vSupCost[u,r,y] for u in model.sup if (u,r,y) in model.mvSupCost)+sum(model.pDummyImportCost[c,r,y,l]*model.vDummyImport[c,r,y,l] for c in model.comm for l in model.slice if (c,r,y,l) in model.mDummyImport)+sum(model.pDummyExportCost[c,r,y,l]*model.vDummyExport[c,r,y,l] for c in model.comm for l in model.slice if (c,r,y,l) in model.mDummyExport)+sum(model.vTaxCost[c,r,y] for c in model.comm if (c,r,y) in model.mTaxCost)-sum(model.vSubsCost[c,r,y] for c in model.comm if (c,r,y) in model.mSubCost)+sum(model.vStorageOMCost[s,r,y] for s in model.stg if (s,r,y) in model.mStorageOMCost)+sum(model.vStorageEac[s,r,y] for s in model.stg if (s,r,y) in model.mStorageEac)+(model.vTradeCost[r,y] if (r,y) in model.mvTradeCost else 0)+(model.vTotalUserCosts[r,y] if (r,y) in model.mvTotalUserCosts else 0));
# eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)
model.eqTaxCost = Constraint(model.mTaxCost, rule = lambda model, c, r, y : model.vTaxCost[c,r,y]  ==  sum(model.pTaxCostOut[c,r,y,l]*model.vOutTot[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvOutTot and (c,l) in model.mCommSlice))+sum(model.pTaxCostInp[c,r,y,l]*model.vInpTot[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvInpTot and (c,l) in model.mCommSlice))+sum(model.pTaxCostBal[c,r,y,l]*model.vBalance[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvBalance and (c,l) in model.mCommSlice)));
# eqSubsCost(comm, region, year)$mSubCost(comm, region, year)
model.eqSubsCost = Constraint(model.mSubCost, rule = lambda model, c, r, y : model.vSubsCost[c,r,y]  ==  sum(model.pSubCostOut[c,r,y,l]*model.vOutTot[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvOutTot and (c,l) in model.mCommSlice))+sum(model.pSubCostInp[c,r,y,l]*model.vInpTot[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvInpTot and (c,l) in model.mCommSlice))+sum(model.pSubCostBal[c,r,y,l]*model.vBalance[c,r,y,l] for l in model.slice if ((c,r,y,l) in model.mvBalance and (c,l) in model.mCommSlice)));
# eqObjective
model.eqObjective = Constraint(rule = lambda model : model.vObjective  ==  sum(model.vTotalCost[r,y]*model.pDiscountFactorMileStone[r,y] for r in model.region for y in model.year if (r,y) in model.mvTotalCost));
# eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)
model.eqLECActivity = Constraint(model.meqLECActivity, rule = lambda model, h, r, y : sum(model.vTechAct[h,r,y,l] for l in model.slice if (h,l) in model.mTechSlice)  >=  model.pLECLoACT[r]);
model.fornontriv = Var(domain = pyo.NonNegativeReals)
model.eqnontriv = Constraint(rule = lambda model: model.fornontriv == 0)
exec(open("inc_constraints.py").read())
exec(open("inc_costs.py").read())
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
