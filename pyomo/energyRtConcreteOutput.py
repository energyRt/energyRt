flist = open("output/variable_list.csv","w");
flist.write("value\n");
flist.write("vTechInv\n");
f = open("output/vTechInv.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mTechInv:
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
flist.write("vTechRetiredStock\n");
f = open("output/vTechRetiredStock.csv","w");
f.write("tech,region,year,value\n");
for (t,r,y) in mvTechRetiredStock:
    if model.vTechRetiredStock[(t,r,y)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," +  str(model.vTechRetiredStock[(t,r,y)].value) + "\n")
f.close()
flist.write("vTechRetiredNewCap\n");
f = open("output/vTechRetiredNewCap.csv","w");
f.write("tech,region,year,yearp,value\n");
for (t,r,y,yp) in mvTechRetiredNewCap:
    if model.vTechRetiredNewCap[(t,r,y,yp)].value != 0:
        f.write(str(t) + "," + str(r) + "," + str(y) + "," + str(yp) + "," +  str(model.vTechRetiredNewCap[(t,r,y,yp)].value) + "\n")
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
for (c,r,y,s) in mvOutTot:
    if model.vOutTot[(c,r,y,s)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(s) + "," +  str(model.vOutTot[(c,r,y,s)].value) + "\n")
f.close()
flist.write("vInpTot\n");
f = open("output/vInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,s) in mvInpTot:
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
for (t1,y) in mTradeSpan:
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
for (t1,y) in mTradeNew:
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
f.close()
flist.close();
