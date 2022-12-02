fvTechInv = open("output/vTechInv.csv", "w");

println(fvTechInv, "tech,region,year,value");

for (h,r,y) in mTechInv if JuMP.value(vTechInv[(h,r,y)]) != 0
  println(fvTechInv, h, ",", r, ",", y, ",", JuMP.value(vTechInv[(h,r,y)]));
end;
end;


close(fvTechInv);



fvTechEac = open("output/vTechEac.csv", "w");

println(fvTechEac, "tech,region,year,value");

for (h,r,y) in mTechEac if JuMP.value(vTechEac[(h,r,y)]) != 0
  println(fvTechEac, h, ",", r, ",", y, ",", JuMP.value(vTechEac[(h,r,y)]));
end;
end;


close(fvTechEac);



fvTechOMCost = open("output/vTechOMCost.csv", "w");

println(fvTechOMCost, "tech,region,year,value");

for (h,r,y) in mTechOMCost if JuMP.value(vTechOMCost[(h,r,y)]) != 0
  println(fvTechOMCost, h, ",", r, ",", y, ",", JuMP.value(vTechOMCost[(h,r,y)]));
end;
end;


close(fvTechOMCost);



fvSupCost = open("output/vSupCost.csv", "w");

println(fvSupCost, "sup,region,year,value");

for (u,r,y) in mvSupCost if JuMP.value(vSupCost[(u,r,y)]) != 0
  println(fvSupCost, u, ",", r, ",", y, ",", JuMP.value(vSupCost[(u,r,y)]));
end;
end;


close(fvSupCost);



fvEmsFuelTot = open("output/vEmsFuelTot.csv", "w");

println(fvEmsFuelTot, "comm,region,year,slice,value");

for (c,r,y,l) in mEmsFuelTot if JuMP.value(vEmsFuelTot[(c,r,y,l)]) != 0
  println(fvEmsFuelTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vEmsFuelTot[(c,r,y,l)]));
end;
end;


close(fvEmsFuelTot);



fvBalance = open("output/vBalance.csv", "w");

println(fvBalance, "comm,region,year,slice,value");

for (c,r,y,l) in mvBalance if JuMP.value(vBalance[(c,r,y,l)]) != 0
  println(fvBalance, c, ",", r, ",", y, ",", l, ",", JuMP.value(vBalance[(c,r,y,l)]));
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

for (c,r,y) in mSubCost if JuMP.value(vSubsCost[(c,r,y)]) != 0
  println(fvSubsCost, c, ",", r, ",", y, ",", JuMP.value(vSubsCost[(c,r,y)]));
end;
end;


close(fvSubsCost);



fvAggOut = open("output/vAggOut.csv", "w");

println(fvAggOut, "comm,region,year,slice,value");

for (c,r,y,l) in mAggOut if JuMP.value(vAggOut[(c,r,y,l)]) != 0
  println(fvAggOut, c, ",", r, ",", y, ",", l, ",", JuMP.value(vAggOut[(c,r,y,l)]));
end;
end;


close(fvAggOut);



fvStorageOMCost = open("output/vStorageOMCost.csv", "w");

println(fvStorageOMCost, "stg,region,year,value");

for (s,r,y) in mStorageOMCost if JuMP.value(vStorageOMCost[(s,r,y)]) != 0
  println(fvStorageOMCost, s, ",", r, ",", y, ",", JuMP.value(vStorageOMCost[(s,r,y)]));
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
for (h,r,y) in mTechNew if JuMP.value(vTechNewCap[(h,r,y)]) != 0
  println(fvTechNewCap, h, ",", r, ",", y, ",", JuMP.value(vTechNewCap[(h,r,y)]));
end;
end;
close(fvTechNewCap);


fvTechRetiredStock = open("output/vTechRetiredStock.csv", "w");
println(fvTechRetiredStock, "tech,region,year,value");
for (h,r,y) in mvTechRetiredStock if JuMP.value(vTechRetiredStock[(h,r,y)]) != 0
  println(fvTechRetiredStock, h, ",", r, ",", y, ",", JuMP.value(vTechRetiredStock[(h,r,y)]));
end;
end;
close(fvTechRetiredStock);


fvTechRetiredNewCap = open("output/vTechRetiredNewCap.csv", "w");
println(fvTechRetiredNewCap, "tech,region,year,yearp,value");
for (h,r,y,yp) in mvTechRetiredNewCap if JuMP.value(vTechRetiredNewCap[(h,r,y,yp)]) != 0
  println(fvTechRetiredNewCap, h, ",", r, ",", y, ",", yp, ",", JuMP.value(vTechRetiredNewCap[(h,r,y,yp)]));
end;
end;
close(fvTechRetiredNewCap);


fvTechCap = open("output/vTechCap.csv", "w");
println(fvTechCap, "tech,region,year,value");
for (h,r,y) in mTechSpan if JuMP.value(vTechCap[(h,r,y)]) != 0
  println(fvTechCap, h, ",", r, ",", y, ",", JuMP.value(vTechCap[(h,r,y)]));
end;
end;
close(fvTechCap);


fvTechAct = open("output/vTechAct.csv", "w");
println(fvTechAct, "tech,region,year,slice,value");
for (h,r,y,l) in mvTechAct if JuMP.value(vTechAct[(h,r,y,l)]) != 0
  println(fvTechAct, h, ",", r, ",", y, ",", l, ",", JuMP.value(vTechAct[(h,r,y,l)]));
end;
end;
close(fvTechAct);


fvTechInp = open("output/vTechInp.csv", "w");
println(fvTechInp, "tech,comm,region,year,slice,value");
for (h,c,r,y,l) in mvTechInp if JuMP.value(vTechInp[(h,c,r,y,l)]) != 0
  println(fvTechInp, h, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechInp[(h,c,r,y,l)]));
end;
end;
close(fvTechInp);


fvTechOut = open("output/vTechOut.csv", "w");
println(fvTechOut, "tech,comm,region,year,slice,value");
for (h,c,r,y,l) in mvTechOut if JuMP.value(vTechOut[(h,c,r,y,l)]) != 0
  println(fvTechOut, h, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechOut[(h,c,r,y,l)]));
end;
end;
close(fvTechOut);


fvTechAInp = open("output/vTechAInp.csv", "w");
println(fvTechAInp, "tech,comm,region,year,slice,value");
for (h,c,r,y,l) in mvTechAInp if JuMP.value(vTechAInp[(h,c,r,y,l)]) != 0
  println(fvTechAInp, h, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechAInp[(h,c,r,y,l)]));
end;
end;
close(fvTechAInp);


fvTechAOut = open("output/vTechAOut.csv", "w");
println(fvTechAOut, "tech,comm,region,year,slice,value");
for (h,c,r,y,l) in mvTechAOut if JuMP.value(vTechAOut[(h,c,r,y,l)]) != 0
  println(fvTechAOut, h, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechAOut[(h,c,r,y,l)]));
end;
end;
close(fvTechAOut);


fvSupOut = open("output/vSupOut.csv", "w");
println(fvSupOut, "sup,comm,region,year,slice,value");
for (u,c,r,y,l) in mSupAva if JuMP.value(vSupOut[(u,c,r,y,l)]) != 0
  println(fvSupOut, u, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vSupOut[(u,c,r,y,l)]));
end;
end;
close(fvSupOut);


fvSupReserve = open("output/vSupReserve.csv", "w");
println(fvSupReserve, "sup,comm,region,value");
for (u,c,r) in mvSupReserve if JuMP.value(vSupReserve[(u,c,r)]) != 0
  println(fvSupReserve, u, ",", c, ",", r, ",", JuMP.value(vSupReserve[(u,c,r)]));
end;
end;
close(fvSupReserve);


fvDemInp = open("output/vDemInp.csv", "w");
println(fvDemInp, "comm,region,year,slice,value");
for (c,r,y,l) in mvDemInp if JuMP.value(vDemInp[(c,r,y,l)]) != 0
  println(fvDemInp, c, ",", r, ",", y, ",", l, ",", JuMP.value(vDemInp[(c,r,y,l)]));
end;
end;
close(fvDemInp);


fvOutTot = open("output/vOutTot.csv", "w");
println(fvOutTot, "comm,region,year,slice,value");
for (c,r,y,l) in mvOutTot if JuMP.value(vOutTot[(c,r,y,l)]) != 0
  println(fvOutTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vOutTot[(c,r,y,l)]));
end;
end;
close(fvOutTot);


fvInpTot = open("output/vInpTot.csv", "w");
println(fvInpTot, "comm,region,year,slice,value");
for (c,r,y,l) in mvInpTot if JuMP.value(vInpTot[(c,r,y,l)]) != 0
  println(fvInpTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vInpTot[(c,r,y,l)]));
end;
end;
close(fvInpTot);


fvInp2Lo = open("output/vInp2Lo.csv", "w");
println(fvInp2Lo, "comm,region,year,slice,slicep,value");
for (c,r,y,l,lp) in mvInp2Lo if JuMP.value(vInp2Lo[(c,r,y,l,lp)]) != 0
  println(fvInp2Lo, c, ",", r, ",", y, ",", l, ",", lp, ",", JuMP.value(vInp2Lo[(c,r,y,l,lp)]));
end;
end;
close(fvInp2Lo);


fvOut2Lo = open("output/vOut2Lo.csv", "w");
println(fvOut2Lo, "comm,region,year,slice,slicep,value");
for (c,r,y,l,lp) in mvOut2Lo if JuMP.value(vOut2Lo[(c,r,y,l,lp)]) != 0
  println(fvOut2Lo, c, ",", r, ",", y, ",", l, ",", lp, ",", JuMP.value(vOut2Lo[(c,r,y,l,lp)]));
end;
end;
close(fvOut2Lo);


fvSupOutTot = open("output/vSupOutTot.csv", "w");
println(fvSupOutTot, "comm,region,year,slice,value");
for (c,r,y,l) in mSupOutTot if JuMP.value(vSupOutTot[(c,r,y,l)]) != 0
  println(fvSupOutTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vSupOutTot[(c,r,y,l)]));
end;
end;
close(fvSupOutTot);


fvTechInpTot = open("output/vTechInpTot.csv", "w");
println(fvTechInpTot, "comm,region,year,slice,value");
for (c,r,y,l) in mTechInpTot if JuMP.value(vTechInpTot[(c,r,y,l)]) != 0
  println(fvTechInpTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechInpTot[(c,r,y,l)]));
end;
end;
close(fvTechInpTot);


fvTechOutTot = open("output/vTechOutTot.csv", "w");
println(fvTechOutTot, "comm,region,year,slice,value");
for (c,r,y,l) in mTechOutTot if JuMP.value(vTechOutTot[(c,r,y,l)]) != 0
  println(fvTechOutTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vTechOutTot[(c,r,y,l)]));
end;
end;
close(fvTechOutTot);


fvStorageInpTot = open("output/vStorageInpTot.csv", "w");
println(fvStorageInpTot, "comm,region,year,slice,value");
for (c,r,y,l) in mStorageInpTot if JuMP.value(vStorageInpTot[(c,r,y,l)]) != 0
  println(fvStorageInpTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageInpTot[(c,r,y,l)]));
end;
end;
close(fvStorageInpTot);


fvStorageOutTot = open("output/vStorageOutTot.csv", "w");
println(fvStorageOutTot, "comm,region,year,slice,value");
for (c,r,y,l) in mStorageOutTot if JuMP.value(vStorageOutTot[(c,r,y,l)]) != 0
  println(fvStorageOutTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageOutTot[(c,r,y,l)]));
end;
end;
close(fvStorageOutTot);


fvStorageAInp = open("output/vStorageAInp.csv", "w");
println(fvStorageAInp, "stg,comm,region,year,slice,value");
for (s,c,r,y,l) in mvStorageAInp if JuMP.value(vStorageAInp[(s,c,r,y,l)]) != 0
  println(fvStorageAInp, s, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageAInp[(s,c,r,y,l)]));
end;
end;
close(fvStorageAInp);


fvStorageAOut = open("output/vStorageAOut.csv", "w");
println(fvStorageAOut, "stg,comm,region,year,slice,value");
for (s,c,r,y,l) in mvStorageAOut if JuMP.value(vStorageAOut[(s,c,r,y,l)]) != 0
  println(fvStorageAOut, s, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageAOut[(s,c,r,y,l)]));
end;
end;
close(fvStorageAOut);


fvDummyImport = open("output/vDummyImport.csv", "w");
println(fvDummyImport, "comm,region,year,slice,value");
for (c,r,y,l) in mDummyImport if JuMP.value(vDummyImport[(c,r,y,l)]) != 0
  println(fvDummyImport, c, ",", r, ",", y, ",", l, ",", JuMP.value(vDummyImport[(c,r,y,l)]));
end;
end;
close(fvDummyImport);


fvDummyExport = open("output/vDummyExport.csv", "w");
println(fvDummyExport, "comm,region,year,slice,value");
for (c,r,y,l) in mDummyExport if JuMP.value(vDummyExport[(c,r,y,l)]) != 0
  println(fvDummyExport, c, ",", r, ",", y, ",", l, ",", JuMP.value(vDummyExport[(c,r,y,l)]));
end;
end;
close(fvDummyExport);


fvStorageInp = open("output/vStorageInp.csv", "w");
println(fvStorageInp, "stg,comm,region,year,slice,value");
for (s,c,r,y,l) in mvStorageStore if JuMP.value(vStorageInp[(s,c,r,y,l)]) != 0
  println(fvStorageInp, s, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageInp[(s,c,r,y,l)]));
end;
end;
close(fvStorageInp);


fvStorageOut = open("output/vStorageOut.csv", "w");
println(fvStorageOut, "stg,comm,region,year,slice,value");
for (s,c,r,y,l) in mvStorageStore if JuMP.value(vStorageOut[(s,c,r,y,l)]) != 0
  println(fvStorageOut, s, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageOut[(s,c,r,y,l)]));
end;
end;
close(fvStorageOut);


fvStorageStore = open("output/vStorageStore.csv", "w");
println(fvStorageStore, "stg,comm,region,year,slice,value");
for (s,c,r,y,l) in mvStorageStore if JuMP.value(vStorageStore[(s,c,r,y,l)]) != 0
  println(fvStorageStore, s, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vStorageStore[(s,c,r,y,l)]));
end;
end;
close(fvStorageStore);


fvStorageInv = open("output/vStorageInv.csv", "w");
println(fvStorageInv, "stg,region,year,value");
for (s,r,y) in mStorageNew if JuMP.value(vStorageInv[(s,r,y)]) != 0
  println(fvStorageInv, s, ",", r, ",", y, ",", JuMP.value(vStorageInv[(s,r,y)]));
end;
end;
close(fvStorageInv);


fvStorageEac = open("output/vStorageEac.csv", "w");
println(fvStorageEac, "stg,region,year,value");
for (s,r,y) in mStorageEac if JuMP.value(vStorageEac[(s,r,y)]) != 0
  println(fvStorageEac, s, ",", r, ",", y, ",", JuMP.value(vStorageEac[(s,r,y)]));
end;
end;
close(fvStorageEac);


fvStorageCap = open("output/vStorageCap.csv", "w");
println(fvStorageCap, "stg,region,year,value");
for (s,r,y) in mStorageSpan if JuMP.value(vStorageCap[(s,r,y)]) != 0
  println(fvStorageCap, s, ",", r, ",", y, ",", JuMP.value(vStorageCap[(s,r,y)]));
end;
end;
close(fvStorageCap);


fvStorageNewCap = open("output/vStorageNewCap.csv", "w");
println(fvStorageNewCap, "stg,region,year,value");
for (s,r,y) in mStorageNew if JuMP.value(vStorageNewCap[(s,r,y)]) != 0
  println(fvStorageNewCap, s, ",", r, ",", y, ",", JuMP.value(vStorageNewCap[(s,r,y)]));
end;
end;
close(fvStorageNewCap);


fvImport = open("output/vImport.csv", "w");
println(fvImport, "comm,region,year,slice,value");
for (c,r,y,l) in mImport if JuMP.value(vImport[(c,r,y,l)]) != 0
  println(fvImport, c, ",", r, ",", y, ",", l, ",", JuMP.value(vImport[(c,r,y,l)]));
end;
end;
close(fvImport);


fvExport = open("output/vExport.csv", "w");
println(fvExport, "comm,region,year,slice,value");
for (c,r,y,l) in mExport if JuMP.value(vExport[(c,r,y,l)]) != 0
  println(fvExport, c, ",", r, ",", y, ",", l, ",", JuMP.value(vExport[(c,r,y,l)]));
end;
end;
close(fvExport);


fvTradeIr = open("output/vTradeIr.csv", "w");
println(fvTradeIr, "trade,comm,region,regionp,year,slice,value");
for (d,c,r,rp,y,l) in mvTradeIr if JuMP.value(vTradeIr[(d,c,r,rp,y,l)]) != 0
  println(fvTradeIr, d, ",", c, ",", r, ",", rp, ",", y, ",", l, ",", JuMP.value(vTradeIr[(d,c,r,rp,y,l)]));
end;
end;
close(fvTradeIr);


fvTradeIrAInp = open("output/vTradeIrAInp.csv", "w");
println(fvTradeIrAInp, "trade,comm,region,year,slice,value");
for (d,c,r,y,l) in mvTradeIrAInp if JuMP.value(vTradeIrAInp[(d,c,r,y,l)]) != 0
  println(fvTradeIrAInp, d, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTradeIrAInp[(d,c,r,y,l)]));
end;
end;
close(fvTradeIrAInp);


fvTradeIrAInpTot = open("output/vTradeIrAInpTot.csv", "w");
println(fvTradeIrAInpTot, "comm,region,year,slice,value");
for (c,r,y,l) in mvTradeIrAInpTot if JuMP.value(vTradeIrAInpTot[(c,r,y,l)]) != 0
  println(fvTradeIrAInpTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vTradeIrAInpTot[(c,r,y,l)]));
end;
end;
close(fvTradeIrAInpTot);


fvTradeIrAOut = open("output/vTradeIrAOut.csv", "w");
println(fvTradeIrAOut, "trade,comm,region,year,slice,value");
for (d,c,r,y,l) in mvTradeIrAOut if JuMP.value(vTradeIrAOut[(d,c,r,y,l)]) != 0
  println(fvTradeIrAOut, d, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vTradeIrAOut[(d,c,r,y,l)]));
end;
end;
close(fvTradeIrAOut);


fvTradeIrAOutTot = open("output/vTradeIrAOutTot.csv", "w");
println(fvTradeIrAOutTot, "comm,region,year,slice,value");
for (c,r,y,l) in mvTradeIrAOutTot if JuMP.value(vTradeIrAOutTot[(c,r,y,l)]) != 0
  println(fvTradeIrAOutTot, c, ",", r, ",", y, ",", l, ",", JuMP.value(vTradeIrAOutTot[(c,r,y,l)]));
end;
end;
close(fvTradeIrAOutTot);


fvExportRowAccumulated = open("output/vExportRowAccumulated.csv", "w");
println(fvExportRowAccumulated, "expp,comm,value");
for (x,c) in mExpComm if JuMP.value(vExportRowAccumulated[(x,c)]) != 0
  println(fvExportRowAccumulated, x, ",", c, ",", JuMP.value(vExportRowAccumulated[(x,c)]));
end;
end;
close(fvExportRowAccumulated);


fvExportRow = open("output/vExportRow.csv", "w");
println(fvExportRow, "expp,comm,region,year,slice,value");
for (x,c,r,y,l) in mExportRow if JuMP.value(vExportRow[(x,c,r,y,l)]) != 0
  println(fvExportRow, x, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vExportRow[(x,c,r,y,l)]));
end;
end;
close(fvExportRow);


fvImportRowAccumulated = open("output/vImportRowAccumulated.csv", "w");
println(fvImportRowAccumulated, "imp,comm,value");
for (m,c) in mImpComm if JuMP.value(vImportRowAccumulated[(m,c)]) != 0
  println(fvImportRowAccumulated, m, ",", c, ",", JuMP.value(vImportRowAccumulated[(m,c)]));
end;
end;
close(fvImportRowAccumulated);


fvImportRow = open("output/vImportRow.csv", "w");
println(fvImportRow, "imp,comm,region,year,slice,value");
for (m,c,r,y,l) in mImportRow if JuMP.value(vImportRow[(m,c,r,y,l)]) != 0
  println(fvImportRow, m, ",", c, ",", r, ",", y, ",", l, ",", JuMP.value(vImportRow[(m,c,r,y,l)]));
end;
end;
close(fvImportRow);


fvTradeCap = open("output/vTradeCap.csv", "w");
println(fvTradeCap, "trade,year,value");
for (d,y) in mTradeSpan if JuMP.value(vTradeCap[(d,y)]) != 0
  println(fvTradeCap, d, ",", y, ",", JuMP.value(vTradeCap[(d,y)]));
end;
end;
close(fvTradeCap);


fvTradeInv = open("output/vTradeInv.csv", "w");
println(fvTradeInv, "trade,region,year,value");
for (d,r,y) in mTradeEac if JuMP.value(vTradeInv[(d,r,y)]) != 0
  println(fvTradeInv, d, ",", r, ",", y, ",", JuMP.value(vTradeInv[(d,r,y)]));
end;
end;
close(fvTradeInv);


fvTradeEac = open("output/vTradeEac.csv", "w");
println(fvTradeEac, "trade,region,year,value");
for (d,r,y) in mTradeEac if JuMP.value(vTradeEac[(d,r,y)]) != 0
  println(fvTradeEac, d, ",", r, ",", y, ",", JuMP.value(vTradeEac[(d,r,y)]));
end;
end;
close(fvTradeEac);


fvTradeNewCap = open("output/vTradeNewCap.csv", "w");
println(fvTradeNewCap, "trade,year,value");
for (d,y) in mTradeNew if JuMP.value(vTradeNewCap[(d,y)]) != 0
  println(fvTradeNewCap, d, ",", y, ",", JuMP.value(vTradeNewCap[(d,y)]));
end;
end;
close(fvTradeNewCap);


fvTotalUserCosts = open("output/vTotalUserCosts.csv", "w");
println(fvTotalUserCosts, "region,year,value");
for (r,y) in mvTotalUserCosts if JuMP.value(vTotalUserCosts[(r,y)]) != 0
  println(fvTotalUserCosts, r, ",", y, ",", JuMP.value(vTotalUserCosts[(r,y)]));
end;
end;
close(fvTotalUserCosts);


vrb_list = open("output/variable_list.csv", "w");
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
println(vrb_list, "vTechRetiredStock");
println(vrb_list, "vTechRetiredNewCap");
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
println(vrb_list, "vTotalUserCosts");

close(vrb_list);
raw_data = open("output/raw_data_set.csv", "w");
println(raw_data, "set,value");
for rr = comm
    println(raw_data, "comm,",rr)
end
for rr = region
    println(raw_data, "region,",rr)
end
for rr = year
    println(raw_data, "year,",rr)
end
for rr = slice
    println(raw_data, "slice,",rr)
end
for rr = sup
    println(raw_data, "sup,",rr)
end
for rr = dem
    println(raw_data, "dem,",rr)
end
for rr = tech
    println(raw_data, "tech,",rr)
end
for rr = stg
    println(raw_data, "stg,",rr)
end
for rr = trade
    println(raw_data, "trade,",rr)
end
for rr = expp
    println(raw_data, "expp,",rr)
end
for rr = imp
    println(raw_data, "imp,",rr)
end
for rr = group
    println(raw_data, "group,",rr)
end
for rr = weather
    println(raw_data, "weather,",rr)
end

close(raw_data);
