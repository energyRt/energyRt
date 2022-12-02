flist = open("output/variable_list.csv","w");
flist.write("value\n");
flist.write("vTechInv\n");
f = open("output/vTechInv.csv","w");
f.write("tech,region,year,value\n");
for (h,r,y) in mTechInv:
    if model.vTechInv[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechInv[(h,r,y)].value) + "\n")
f.close()
flist.write("vTechEac\n");
f = open("output/vTechEac.csv","w");
f.write("tech,region,year,value\n");
for (h,r,y) in mTechEac:
    if model.vTechEac[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechEac[(h,r,y)].value) + "\n")
f.close()
flist.write("vTechOMCost\n");
f = open("output/vTechOMCost.csv","w");
f.write("tech,region,year,value\n");
for (h,r,y) in mTechOMCost:
    if model.vTechOMCost[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechOMCost[(h,r,y)].value) + "\n")
f.close()
flist.write("vSupCost\n");
f = open("output/vSupCost.csv","w");
f.write("sup,region,year,value\n");
for (u,r,y) in mvSupCost:
    if model.vSupCost[(u,r,y)].value != 0:
        f.write(str(u) + "," + str(r) + "," + str(y) + "," +  str(model.vSupCost[(u,r,y)].value) + "\n")
f.close()
flist.write("vEmsFuelTot\n");
f = open("output/vEmsFuelTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mEmsFuelTot:
    if model.vEmsFuelTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vEmsFuelTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vBalance\n");
f = open("output/vBalance.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvBalance:
    if model.vBalance[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vBalance[(c,r,y,l)].value) + "\n")
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
for (c,r,y) in mSubCost:
    if model.vSubsCost[(c,r,y)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," +  str(model.vSubsCost[(c,r,y)].value) + "\n")
f.close()
flist.write("vAggOut\n");
f = open("output/vAggOut.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mAggOut:
    if model.vAggOut[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vAggOut[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageOMCost\n");
f = open("output/vStorageOMCost.csv","w");
f.write("stg,region,year,value\n");
for (s,r,y) in mStorageOMCost:
    if model.vStorageOMCost[(s,r,y)].value != 0:
        f.write(str(s) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageOMCost[(s,r,y)].value) + "\n")
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
for (h,r,y) in mTechNew:
    if model.vTechNewCap[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechNewCap[(h,r,y)].value) + "\n")
f.close()
flist.write("vTechRetiredStock\n");
f = open("output/vTechRetiredStock.csv","w");
f.write("tech,region,year,value\n");
for (h,r,y) in mvTechRetiredStock:
    if model.vTechRetiredStock[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechRetiredStock[(h,r,y)].value) + "\n")
f.close()
flist.write("vTechRetiredNewCap\n");
f = open("output/vTechRetiredNewCap.csv","w");
f.write("tech,region,year,yearp,value\n");
for (h,r,y,yp) in mvTechRetiredNewCap:
    if model.vTechRetiredNewCap[(h,r,y,yp)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," + str(yp) + "," +  str(model.vTechRetiredNewCap[(h,r,y,yp)].value) + "\n")
f.close()
flist.write("vTechCap\n");
f = open("output/vTechCap.csv","w");
f.write("tech,region,year,value\n");
for (h,r,y) in mTechSpan:
    if model.vTechCap[(h,r,y)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," +  str(model.vTechCap[(h,r,y)].value) + "\n")
f.close()
flist.write("vTechAct\n");
f = open("output/vTechAct.csv","w");
f.write("tech,region,year,slice,value\n");
for (h,r,y,l) in mvTechAct:
    if model.vTechAct[(h,r,y,l)].value != 0:
        f.write(str(h) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechAct[(h,r,y,l)].value) + "\n")
f.close()
flist.write("vTechInp\n");
f = open("output/vTechInp.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (h,c,r,y,l) in mvTechInp:
    if model.vTechInp[(h,c,r,y,l)].value != 0:
        f.write(str(h) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechInp[(h,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTechOut\n");
f = open("output/vTechOut.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (h,c,r,y,l) in mvTechOut:
    if model.vTechOut[(h,c,r,y,l)].value != 0:
        f.write(str(h) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechOut[(h,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTechAInp\n");
f = open("output/vTechAInp.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (h,c,r,y,l) in mvTechAInp:
    if model.vTechAInp[(h,c,r,y,l)].value != 0:
        f.write(str(h) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechAInp[(h,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTechAOut\n");
f = open("output/vTechAOut.csv","w");
f.write("tech,comm,region,year,slice,value\n");
for (h,c,r,y,l) in mvTechAOut:
    if model.vTechAOut[(h,c,r,y,l)].value != 0:
        f.write(str(h) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechAOut[(h,c,r,y,l)].value) + "\n")
f.close()
flist.write("vSupOut\n");
f = open("output/vSupOut.csv","w");
f.write("sup,comm,region,year,slice,value\n");
for (u,c,r,y,l) in mSupAva:
    if model.vSupOut[(u,c,r,y,l)].value != 0:
        f.write(str(u) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vSupOut[(u,c,r,y,l)].value) + "\n")
f.close()
flist.write("vSupReserve\n");
f = open("output/vSupReserve.csv","w");
f.write("sup,comm,region,value\n");
for (u,c,r) in mvSupReserve:
    if model.vSupReserve[(u,c,r)].value != 0:
        f.write(str(u) + "," + str(c) + "," + str(r) + "," +  str(model.vSupReserve[(u,c,r)].value) + "\n")
f.close()
flist.write("vDemInp\n");
f = open("output/vDemInp.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvDemInp:
    if model.vDemInp[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vDemInp[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vOutTot\n");
f = open("output/vOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvOutTot:
    if model.vOutTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vOutTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vInpTot\n");
f = open("output/vInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvInpTot:
    if model.vInpTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vInpTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vInp2Lo\n");
f = open("output/vInp2Lo.csv","w");
f.write("comm,region,year,slice,slicep,value\n");
for (c,r,y,l,lp) in mvInp2Lo:
    if model.vInp2Lo[(c,r,y,l,lp)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," + str(lp) + "," +  str(model.vInp2Lo[(c,r,y,l,lp)].value) + "\n")
f.close()
flist.write("vOut2Lo\n");
f = open("output/vOut2Lo.csv","w");
f.write("comm,region,year,slice,slicep,value\n");
for (c,r,y,l,lp) in mvOut2Lo:
    if model.vOut2Lo[(c,r,y,l,lp)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," + str(lp) + "," +  str(model.vOut2Lo[(c,r,y,l,lp)].value) + "\n")
f.close()
flist.write("vSupOutTot\n");
f = open("output/vSupOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mSupOutTot:
    if model.vSupOutTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vSupOutTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vTechInpTot\n");
f = open("output/vTechInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mTechInpTot:
    if model.vTechInpTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechInpTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vTechOutTot\n");
f = open("output/vTechOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mTechOutTot:
    if model.vTechOutTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTechOutTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageInpTot\n");
f = open("output/vStorageInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mStorageInpTot:
    if model.vStorageInpTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageInpTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageOutTot\n");
f = open("output/vStorageOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mStorageOutTot:
    if model.vStorageOutTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageOutTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageAInp\n");
f = open("output/vStorageAInp.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (s,c,r,y,l) in mvStorageAInp:
    if model.vStorageAInp[(s,c,r,y,l)].value != 0:
        f.write(str(s) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageAInp[(s,c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageAOut\n");
f = open("output/vStorageAOut.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (s,c,r,y,l) in mvStorageAOut:
    if model.vStorageAOut[(s,c,r,y,l)].value != 0:
        f.write(str(s) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageAOut[(s,c,r,y,l)].value) + "\n")
f.close()
flist.write("vDummyImport\n");
f = open("output/vDummyImport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mDummyImport:
    if model.vDummyImport[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vDummyImport[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vDummyExport\n");
f = open("output/vDummyExport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mDummyExport:
    if model.vDummyExport[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vDummyExport[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageInp\n");
f = open("output/vStorageInp.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (s,c,r,y,l) in mvStorageStore:
    if model.vStorageInp[(s,c,r,y,l)].value != 0:
        f.write(str(s) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageInp[(s,c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageOut\n");
f = open("output/vStorageOut.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (s,c,r,y,l) in mvStorageStore:
    if model.vStorageOut[(s,c,r,y,l)].value != 0:
        f.write(str(s) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageOut[(s,c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageStore\n");
f = open("output/vStorageStore.csv","w");
f.write("stg,comm,region,year,slice,value\n");
for (s,c,r,y,l) in mvStorageStore:
    if model.vStorageStore[(s,c,r,y,l)].value != 0:
        f.write(str(s) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vStorageStore[(s,c,r,y,l)].value) + "\n")
f.close()
flist.write("vStorageInv\n");
f = open("output/vStorageInv.csv","w");
f.write("stg,region,year,value\n");
for (s,r,y) in mStorageNew:
    if model.vStorageInv[(s,r,y)].value != 0:
        f.write(str(s) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageInv[(s,r,y)].value) + "\n")
f.close()
flist.write("vStorageEac\n");
f = open("output/vStorageEac.csv","w");
f.write("stg,region,year,value\n");
for (s,r,y) in mStorageEac:
    if model.vStorageEac[(s,r,y)].value != 0:
        f.write(str(s) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageEac[(s,r,y)].value) + "\n")
f.close()
flist.write("vStorageCap\n");
f = open("output/vStorageCap.csv","w");
f.write("stg,region,year,value\n");
for (s,r,y) in mStorageSpan:
    if model.vStorageCap[(s,r,y)].value != 0:
        f.write(str(s) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageCap[(s,r,y)].value) + "\n")
f.close()
flist.write("vStorageNewCap\n");
f = open("output/vStorageNewCap.csv","w");
f.write("stg,region,year,value\n");
for (s,r,y) in mStorageNew:
    if model.vStorageNewCap[(s,r,y)].value != 0:
        f.write(str(s) + "," + str(r) + "," + str(y) + "," +  str(model.vStorageNewCap[(s,r,y)].value) + "\n")
f.close()
flist.write("vImport\n");
f = open("output/vImport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mImport:
    if model.vImport[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vImport[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vExport\n");
f = open("output/vExport.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mExport:
    if model.vExport[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vExport[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vTradeIr\n");
f = open("output/vTradeIr.csv","w");
f.write("trade,comm,region,regionp,year,slice,value\n");
for (d,c,r,rp,y,l) in mvTradeIr:
    if model.vTradeIr[(d,c,r,rp,y,l)].value != 0:
        f.write(str(d) + "," + str(c) + "," + str(r) + "," + str(rp) + "," + str(y) + "," + str(l) + "," +  str(model.vTradeIr[(d,c,r,rp,y,l)].value) + "\n")
f.close()
flist.write("vTradeIrAInp\n");
f = open("output/vTradeIrAInp.csv","w");
f.write("trade,comm,region,year,slice,value\n");
for (d,c,r,y,l) in mvTradeIrAInp:
    if model.vTradeIrAInp[(d,c,r,y,l)].value != 0:
        f.write(str(d) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTradeIrAInp[(d,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTradeIrAInpTot\n");
f = open("output/vTradeIrAInpTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvTradeIrAInpTot:
    if model.vTradeIrAInpTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTradeIrAInpTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vTradeIrAOut\n");
f = open("output/vTradeIrAOut.csv","w");
f.write("trade,comm,region,year,slice,value\n");
for (d,c,r,y,l) in mvTradeIrAOut:
    if model.vTradeIrAOut[(d,c,r,y,l)].value != 0:
        f.write(str(d) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTradeIrAOut[(d,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTradeIrAOutTot\n");
f = open("output/vTradeIrAOutTot.csv","w");
f.write("comm,region,year,slice,value\n");
for (c,r,y,l) in mvTradeIrAOutTot:
    if model.vTradeIrAOutTot[(c,r,y,l)].value != 0:
        f.write(str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vTradeIrAOutTot[(c,r,y,l)].value) + "\n")
f.close()
flist.write("vExportRowAccumulated\n");
f = open("output/vExportRowAccumulated.csv","w");
f.write("expp,comm,value\n");
for (x,c) in mExpComm:
    if model.vExportRowAccumulated[(x,c)].value != 0:
        f.write(str(x) + "," + str(c) + "," +  str(model.vExportRowAccumulated[(x,c)].value) + "\n")
f.close()
flist.write("vExportRow\n");
f = open("output/vExportRow.csv","w");
f.write("expp,comm,region,year,slice,value\n");
for (x,c,r,y,l) in mExportRow:
    if model.vExportRow[(x,c,r,y,l)].value != 0:
        f.write(str(x) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vExportRow[(x,c,r,y,l)].value) + "\n")
f.close()
flist.write("vImportRowAccumulated\n");
f = open("output/vImportRowAccumulated.csv","w");
f.write("imp,comm,value\n");
for (m,c) in mImpComm:
    if model.vImportRowAccumulated[(m,c)].value != 0:
        f.write(str(m) + "," + str(c) + "," +  str(model.vImportRowAccumulated[(m,c)].value) + "\n")
f.close()
flist.write("vImportRow\n");
f = open("output/vImportRow.csv","w");
f.write("imp,comm,region,year,slice,value\n");
for (m,c,r,y,l) in mImportRow:
    if model.vImportRow[(m,c,r,y,l)].value != 0:
        f.write(str(m) + "," + str(c) + "," + str(r) + "," + str(y) + "," + str(l) + "," +  str(model.vImportRow[(m,c,r,y,l)].value) + "\n")
f.close()
flist.write("vTradeCap\n");
f = open("output/vTradeCap.csv","w");
f.write("trade,year,value\n");
for (d,y) in mTradeSpan:
    if model.vTradeCap[(d,y)].value != 0:
        f.write(str(d) + "," + str(y) + "," +  str(model.vTradeCap[(d,y)].value) + "\n")
f.close()
flist.write("vTradeInv\n");
f = open("output/vTradeInv.csv","w");
f.write("trade,region,year,value\n");
for (d,r,y) in mTradeEac:
    if model.vTradeInv[(d,r,y)].value != 0:
        f.write(str(d) + "," + str(r) + "," + str(y) + "," +  str(model.vTradeInv[(d,r,y)].value) + "\n")
f.close()
flist.write("vTradeEac\n");
f = open("output/vTradeEac.csv","w");
f.write("trade,region,year,value\n");
for (d,r,y) in mTradeEac:
    if model.vTradeEac[(d,r,y)].value != 0:
        f.write(str(d) + "," + str(r) + "," + str(y) + "," +  str(model.vTradeEac[(d,r,y)].value) + "\n")
f.close()
flist.write("vTradeNewCap\n");
f = open("output/vTradeNewCap.csv","w");
f.write("trade,year,value\n");
for (d,y) in mTradeNew:
    if model.vTradeNewCap[(d,y)].value != 0:
        f.write(str(d) + "," + str(y) + "," +  str(model.vTradeNewCap[(d,y)].value) + "\n")
f.close()
flist.write("vTotalUserCosts\n");
f = open("output/vTotalUserCosts.csv","w");
f.write("region,year,value\n");
for (r,y) in mvTotalUserCosts:
    if model.vTotalUserCosts[(r,y)].value != 0:
        f.write(str(r) + "," + str(y) + "," +  str(model.vTotalUserCosts[(r,y)].value) + "\n")
f.close()
f = open("output/raw_data_set.csv","w");
f.write('set,value\n')
for i in comm:
    f.write('comm,' + str(i) + '\n')
for i in region:
    f.write('region,' + str(i) + '\n')
for i in year:
    f.write('year,' + str(i) + '\n')
for i in slice:
    f.write('slice,' + str(i) + '\n')
for i in sup:
    f.write('sup,' + str(i) + '\n')
for i in dem:
    f.write('dem,' + str(i) + '\n')
for i in tech:
    f.write('tech,' + str(i) + '\n')
for i in stg:
    f.write('stg,' + str(i) + '\n')
for i in trade:
    f.write('trade,' + str(i) + '\n')
for i in expp:
    f.write('expp,' + str(i) + '\n')
for i in imp:
    f.write('imp,' + str(i) + '\n')
for i in group:
    f.write('group,' + str(i) + '\n')
for i in weather:
    f.write('weather,' + str(i) + '\n')
f.close()
flist.close();
