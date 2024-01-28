fvTechInv = open("output/vTechInv.csv", "w");

println(fvTechInv, "tech,region,year,value");

for (t, r, y) in mTechInv
    if JuMP.value(vTechInv[(t, r, y)]) != 0
        println(fvTechInv, t, ",", r, ",", y, ",", JuMP.value(vTechInv[(t, r, y)]))
    end
end;

close(fvTechInv);

fvTechEac = open("output/vTechEac.csv", "w");

println(fvTechEac, "tech,region,year,value");

for (t, r, y) in mTechEac
    if JuMP.value(vTechEac[(t, r, y)]) != 0
        println(fvTechEac, t, ",", r, ",", y, ",", JuMP.value(vTechEac[(t, r, y)]))
    end
end;

close(fvTechEac);

fvTechOMCost = open("output/vTechOMCost.csv", "w");

println(fvTechOMCost, "tech,region,year,value");

for (t, r, y) in mTechOMCost
    if JuMP.value(vTechOMCost[(t, r, y)]) != 0
        println(fvTechOMCost, t, ",", r, ",", y, ",", JuMP.value(vTechOMCost[(t, r, y)]))
    end
end;

close(fvTechOMCost);

fvSupCost = open("output/vSupCost.csv", "w");

println(fvSupCost, "sup,region,year,value");

for (s1, r, y) in mvSupCost
    if JuMP.value(vSupCost[(s1, r, y)]) != 0
        println(fvSupCost, s1, ",", r, ",", y, ",", JuMP.value(vSupCost[(s1, r, y)]))
    end
end;

close(fvSupCost);

fvEmsFuelTot = open("output/vEmsFuelTot.csv", "w");

println(fvEmsFuelTot, "comm,region,year,slice,value");

for (c, r, y, s) in mEmsFuelTot
    if JuMP.value(vEmsFuelTot[(c, r, y, s)]) != 0
        println(
            fvEmsFuelTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vEmsFuelTot[(c, r, y, s)]),
        )
    end
end;

close(fvEmsFuelTot);

fvBalance = open("output/vBalance.csv", "w");

println(fvBalance, "comm,region,year,slice,value");

for (c, r, y, s) in mvBalance
    if JuMP.value(vBalance[(c, r, y, s)]) != 0
        println(
            fvBalance,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vBalance[(c, r, y, s)]),
        )
    end
end;

close(fvBalance);

fvTotalCost = open("output/vTotalCost.csv", "w");

println(fvTotalCost, "region,year,value");

for (r, y) in mvTotalCost
    if JuMP.value(vTotalCost[(r, y)]) != 0
        println(fvTotalCost, r, ",", y, ",", JuMP.value(vTotalCost[(r, y)]))
    end
end;

close(fvTotalCost);

fvObjective = open("output/vObjective.csv", "w");
println(fvObjective, "value");
println(fvObjective, JuMP.value(vObjective));
close(fvObjective);

fvTaxCost = open("output/vTaxCost.csv", "w");

println(fvTaxCost, "comm,region,year,value");

for (c, r, y) in mTaxCost
    if JuMP.value(vTaxCost[(c, r, y)]) != 0
        println(fvTaxCost, c, ",", r, ",", y, ",", JuMP.value(vTaxCost[(c, r, y)]))
    end
end;

close(fvTaxCost);

fvSubsCost = open("output/vSubsCost.csv", "w");

println(fvSubsCost, "comm,region,year,value");

for (c, r, y) in mSubCost
    if JuMP.value(vSubsCost[(c, r, y)]) != 0
        println(fvSubsCost, c, ",", r, ",", y, ",", JuMP.value(vSubsCost[(c, r, y)]))
    end
end;

close(fvSubsCost);

fvAggOutTot = open("output/vAggOutTot.csv", "w");

println(fvAggOutTot, "comm,region,year,slice,value");

for (c, r, y, s) in mAggOut
    if JuMP.value(vAggOutTot[(c, r, y, s)]) != 0
        println(
            fvAggOutTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vAggOutTot[(c, r, y, s)]),
        )
    end
end;

close(fvAggOutTot);

fvStorageOMCost = open("output/vStorageOMCost.csv", "w");

println(fvStorageOMCost, "stg,region,year,value");

for (st1, r, y) in mStorageOMCost
    if JuMP.value(vStorageOMCost[(st1, r, y)]) != 0
        println(
            fvStorageOMCost,
            st1,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vStorageOMCost[(st1, r, y)]),
        )
    end
end;

close(fvStorageOMCost);

fvTradeCost = open("output/vTradeCost.csv", "w");

println(fvTradeCost, "region,year,value");

for (r, y) in mvTradeCost
    if JuMP.value(vTradeCost[(r, y)]) != 0
        println(fvTradeCost, r, ",", y, ",", JuMP.value(vTradeCost[(r, y)]))
    end
end;

close(fvTradeCost);

fvTradeRowCost = open("output/vTradeRowCost.csv", "w");

println(fvTradeRowCost, "region,year,value");

for (r, y) in mvTradeRowCost
    if JuMP.value(vTradeRowCost[(r, y)]) != 0
        println(fvTradeRowCost, r, ",", y, ",", JuMP.value(vTradeRowCost[(r, y)]))
    end
end;

close(fvTradeRowCost);

fvTradeIrCost = open("output/vTradeIrCost.csv", "w");

println(fvTradeIrCost, "region,year,value");

for (r, y) in mvTradeIrCost
    if JuMP.value(vTradeIrCost[(r, y)]) != 0
        println(fvTradeIrCost, r, ",", y, ",", JuMP.value(vTradeIrCost[(r, y)]))
    end
end;

close(fvTradeIrCost);

fvTechNewCap = open("output/vTechNewCap.csv", "w");
println(fvTechNewCap, "tech,region,year,value");
for (t, r, y) in mTechNew
    if JuMP.value(vTechNewCap[(t, r, y)]) != 0
        println(fvTechNewCap, t, ",", r, ",", y, ",", JuMP.value(vTechNewCap[(t, r, y)]))
    end
end;
close(fvTechNewCap);

fvTechRetiredStock = open("output/vTechRetiredStock.csv", "w");
println(fvTechRetiredStock, "tech,region,year,value");
for (t, r, y) in mvTechRetiredStock
    if JuMP.value(vTechRetiredStock[(t, r, y)]) != 0
        println(
            fvTechRetiredStock,
            t,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vTechRetiredStock[(t, r, y)]),
        )
    end
end;
close(fvTechRetiredStock);

fvTechRetiredNewCap = open("output/vTechRetiredNewCap.csv", "w");
println(fvTechRetiredNewCap, "tech,region,year,yearp,value");
for (t, r, y, yp) in mvTechRetiredNewCap
    if JuMP.value(vTechRetiredNewCap[(t, r, y, yp)]) != 0
        println(
            fvTechRetiredNewCap,
            t,
            ",",
            r,
            ",",
            y,
            ",",
            yp,
            ",",
            JuMP.value(vTechRetiredNewCap[(t, r, y, yp)]),
        )
    end
end;
close(fvTechRetiredNewCap);

fvTechCap = open("output/vTechCap.csv", "w");
println(fvTechCap, "tech,region,year,value");
for (t, r, y) in mTechSpan
    if JuMP.value(vTechCap[(t, r, y)]) != 0
        println(fvTechCap, t, ",", r, ",", y, ",", JuMP.value(vTechCap[(t, r, y)]))
    end
end;
close(fvTechCap);

fvTechAct = open("output/vTechAct.csv", "w");
println(fvTechAct, "tech,region,year,slice,value");
for (t, r, y, s) in mvTechAct
    if JuMP.value(vTechAct[(t, r, y, s)]) != 0
        println(
            fvTechAct,
            t,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechAct[(t, r, y, s)]),
        )
    end
end;
close(fvTechAct);

fvTechInp = open("output/vTechInp.csv", "w");
println(fvTechInp, "tech,comm,region,year,slice,value");
for (t, c, r, y, s) in mvTechInp
    if JuMP.value(vTechInp[(t, c, r, y, s)]) != 0
        println(
            fvTechInp,
            t,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechInp[(t, c, r, y, s)]),
        )
    end
end;
close(fvTechInp);

fvTechOut = open("output/vTechOut.csv", "w");
println(fvTechOut, "tech,comm,region,year,slice,value");
for (t, c, r, y, s) in mvTechOut
    if JuMP.value(vTechOut[(t, c, r, y, s)]) != 0
        println(
            fvTechOut,
            t,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOut[(t, c, r, y, s)]),
        )
    end
end;
close(fvTechOut);

fvTechAInp = open("output/vTechAInp.csv", "w");
println(fvTechAInp, "tech,comm,region,year,slice,value");
for (t, c, r, y, s) in mvTechAInp
    if JuMP.value(vTechAInp[(t, c, r, y, s)]) != 0
        println(
            fvTechAInp,
            t,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechAInp[(t, c, r, y, s)]),
        )
    end
end;
close(fvTechAInp);

fvTechAOut = open("output/vTechAOut.csv", "w");
println(fvTechAOut, "tech,comm,region,year,slice,value");
for (t, c, r, y, s) in mvTechAOut
    if JuMP.value(vTechAOut[(t, c, r, y, s)]) != 0
        println(
            fvTechAOut,
            t,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechAOut[(t, c, r, y, s)]),
        )
    end
end;
close(fvTechAOut);

fvSupOut = open("output/vSupOut.csv", "w");
println(fvSupOut, "sup,comm,region,year,slice,value");
for (s1, c, r, y, s) in mSupAva
    if JuMP.value(vSupOut[(s1, c, r, y, s)]) != 0
        println(
            fvSupOut,
            s1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vSupOut[(s1, c, r, y, s)]),
        )
    end
end;
close(fvSupOut);

fvSupReserve = open("output/vSupReserve.csv", "w");
println(fvSupReserve, "sup,comm,region,value");
for (s1, c, r) in mvSupReserve
    if JuMP.value(vSupReserve[(s1, c, r)]) != 0
        println(fvSupReserve, s1, ",", c, ",", r, ",", JuMP.value(vSupReserve[(s1, c, r)]))
    end
end;
close(fvSupReserve);

fvDemInp = open("output/vDemInp.csv", "w");
println(fvDemInp, "comm,region,year,slice,value");
for (c, r, y, s) in mvDemInp
    if JuMP.value(vDemInp[(c, r, y, s)]) != 0
        println(fvDemInp, c, ",", r, ",", y, ",", s, ",", JuMP.value(vDemInp[(c, r, y, s)]))
    end
end;
close(fvDemInp);

fvOutTot = open("output/vOutTot.csv", "w");
println(fvOutTot, "comm,region,year,slice,value");
for (c, r, y, s) in mvOutTot
    if JuMP.value(vOutTot[(c, r, y, s)]) != 0
        println(fvOutTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vOutTot[(c, r, y, s)]))
    end
end;
close(fvOutTot);

fvInpTot = open("output/vInpTot.csv", "w");
println(fvInpTot, "comm,region,year,slice,value");
for (c, r, y, s) in mvInpTot
    if JuMP.value(vInpTot[(c, r, y, s)]) != 0
        println(fvInpTot, c, ",", r, ",", y, ",", s, ",", JuMP.value(vInpTot[(c, r, y, s)]))
    end
end;
close(fvInpTot);

fvInp2Lo = open("output/vInp2Lo.csv", "w");
println(fvInp2Lo, "comm,region,year,slice,slicep,value");
for (c, r, y, s, sp) in mvInp2Lo
    if JuMP.value(vInp2Lo[(c, r, y, s, sp)]) != 0
        println(
            fvInp2Lo,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            sp,
            ",",
            JuMP.value(vInp2Lo[(c, r, y, s, sp)]),
        )
    end
end;
close(fvInp2Lo);

fvOut2Lo = open("output/vOut2Lo.csv", "w");
println(fvOut2Lo, "comm,region,year,slice,slicep,value");
for (c, r, y, s, sp) in mvOut2Lo
    if JuMP.value(vOut2Lo[(c, r, y, s, sp)]) != 0
        println(
            fvOut2Lo,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            sp,
            ",",
            JuMP.value(vOut2Lo[(c, r, y, s, sp)]),
        )
    end
end;
close(fvOut2Lo);

fvSupOutTot = open("output/vSupOutTot.csv", "w");
println(fvSupOutTot, "comm,region,year,slice,value");
for (c, r, y, s) in mSupOutTot
    if JuMP.value(vSupOutTot[(c, r, y, s)]) != 0
        println(
            fvSupOutTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vSupOutTot[(c, r, y, s)]),
        )
    end
end;
close(fvSupOutTot);

fvTechInpTot = open("output/vTechInpTot.csv", "w");
println(fvTechInpTot, "comm,region,year,slice,value");
for (c, r, y, s) in mTechInpTot
    if JuMP.value(vTechInpTot[(c, r, y, s)]) != 0
        println(
            fvTechInpTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechInpTot[(c, r, y, s)]),
        )
    end
end;
close(fvTechInpTot);

fvTechOutTot = open("output/vTechOutTot.csv", "w");
println(fvTechOutTot, "comm,region,year,slice,value");
for (c, r, y, s) in mTechOutTot
    if JuMP.value(vTechOutTot[(c, r, y, s)]) != 0
        println(
            fvTechOutTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOutTot[(c, r, y, s)]),
        )
    end
end;
close(fvTechOutTot);

fvTechOutTot1 = open("output/vTechOutTot1.csv", "w");
println(fvTechOutTot1, "comm,region,year,slice,value");
for (c, r, y, s) in mTechOutTot
    if JuMP.value(vTechOutTot1[(c, r, y, s)]) != 0
        println(
            fvTechOutTot1,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOutTot1[(c, r, y, s)]),
        )
    end
end;
close(fvTechOutTot1);

fvTechOutTot2 = open("output/vTechOutTot2.csv", "w");
println(fvTechOutTot2, "comm,region,year,slice,value");
for (c, r, y, s) in mTechOutTot
    if JuMP.value(vTechOutTot2[(c, r, y, s)]) != 0
        println(
            fvTechOutTot2,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOutTot2[(c, r, y, s)]),
        )
    end
end;
close(fvTechOutTot2);

fvTechOutTot3 = open("output/vTechOutTot3.csv", "w");
println(fvTechOutTot3, "comm,region,year,slice,value");
for (c, r, y, s) in mTechOutTot
    if JuMP.value(vTechOutTot3[(c, r, y, s)]) != 0
        println(
            fvTechOutTot3,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOutTot3[(c, r, y, s)]),
        )
    end
end;
close(fvTechOutTot3);

fvTechOutTot4 = open("output/vTechOutTot4.csv", "w");
println(fvTechOutTot4, "comm,region,year,slice,value");
for (c, r, y, s) in mTechOutTot
    if JuMP.value(vTechOutTot4[(c, r, y, s)]) != 0
        println(
            fvTechOutTot4,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTechOutTot4[(c, r, y, s)]),
        )
    end
end;
close(fvTechOutTot4);

fvStorageInpTot = open("output/vStorageInpTot.csv", "w");
println(fvStorageInpTot, "comm,region,year,slice,value");
for (c, r, y, s) in mStorageInpTot
    if JuMP.value(vStorageInpTot[(c, r, y, s)]) != 0
        println(
            fvStorageInpTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageInpTot[(c, r, y, s)]),
        )
    end
end;
close(fvStorageInpTot);

fvStorageOutTot = open("output/vStorageOutTot.csv", "w");
println(fvStorageOutTot, "comm,region,year,slice,value");
for (c, r, y, s) in mStorageOutTot
    if JuMP.value(vStorageOutTot[(c, r, y, s)]) != 0
        println(
            fvStorageOutTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageOutTot[(c, r, y, s)]),
        )
    end
end;
close(fvStorageOutTot);

fvStorageAInp = open("output/vStorageAInp.csv", "w");
println(fvStorageAInp, "stg,comm,region,year,slice,value");
for (st1, c, r, y, s) in mvStorageAInp
    if JuMP.value(vStorageAInp[(st1, c, r, y, s)]) != 0
        println(
            fvStorageAInp,
            st1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageAInp[(st1, c, r, y, s)]),
        )
    end
end;
close(fvStorageAInp);

fvStorageAOut = open("output/vStorageAOut.csv", "w");
println(fvStorageAOut, "stg,comm,region,year,slice,value");
for (st1, c, r, y, s) in mvStorageAOut
    if JuMP.value(vStorageAOut[(st1, c, r, y, s)]) != 0
        println(
            fvStorageAOut,
            st1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageAOut[(st1, c, r, y, s)]),
        )
    end
end;
close(fvStorageAOut);

fvDummyImport = open("output/vDummyImport.csv", "w");
println(fvDummyImport, "comm,region,year,slice,value");
for (c, r, y, s) in mDummyImport
    if JuMP.value(vDummyImport[(c, r, y, s)]) != 0
        println(
            fvDummyImport,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vDummyImport[(c, r, y, s)]),
        )
    end
end;
close(fvDummyImport);

fvDummyExport = open("output/vDummyExport.csv", "w");
println(fvDummyExport, "comm,region,year,slice,value");
for (c, r, y, s) in mDummyExport
    if JuMP.value(vDummyExport[(c, r, y, s)]) != 0
        println(
            fvDummyExport,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vDummyExport[(c, r, y, s)]),
        )
    end
end;
close(fvDummyExport);

fvStorageInp = open("output/vStorageInp.csv", "w");
println(fvStorageInp, "stg,comm,region,year,slice,value");
for (st1, c, r, y, s) in mvStorageStore
    if JuMP.value(vStorageInp[(st1, c, r, y, s)]) != 0
        println(
            fvStorageInp,
            st1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageInp[(st1, c, r, y, s)]),
        )
    end
end;
close(fvStorageInp);

fvStorageOut = open("output/vStorageOut.csv", "w");
println(fvStorageOut, "stg,comm,region,year,slice,value");
for (st1, c, r, y, s) in mvStorageStore
    if JuMP.value(vStorageOut[(st1, c, r, y, s)]) != 0
        println(
            fvStorageOut,
            st1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageOut[(st1, c, r, y, s)]),
        )
    end
end;
close(fvStorageOut);

fvStorageStore = open("output/vStorageStore.csv", "w");
println(fvStorageStore, "stg,comm,region,year,slice,value");
for (st1, c, r, y, s) in mvStorageStore
    if JuMP.value(vStorageStore[(st1, c, r, y, s)]) != 0
        println(
            fvStorageStore,
            st1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vStorageStore[(st1, c, r, y, s)]),
        )
    end
end;
close(fvStorageStore);

fvStorageInv = open("output/vStorageInv.csv", "w");
println(fvStorageInv, "stg,region,year,value");
for (st1, r, y) in mStorageNew
    if JuMP.value(vStorageInv[(st1, r, y)]) != 0
        println(
            fvStorageInv,
            st1,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vStorageInv[(st1, r, y)]),
        )
    end
end;
close(fvStorageInv);

fvStorageEac = open("output/vStorageEac.csv", "w");
println(fvStorageEac, "stg,region,year,value");
for (st1, r, y) in mStorageEac
    if JuMP.value(vStorageEac[(st1, r, y)]) != 0
        println(
            fvStorageEac,
            st1,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vStorageEac[(st1, r, y)]),
        )
    end
end;
close(fvStorageEac);

fvStorageCap = open("output/vStorageCap.csv", "w");
println(fvStorageCap, "stg,region,year,value");
for (st1, r, y) in mStorageSpan
    if JuMP.value(vStorageCap[(st1, r, y)]) != 0
        println(
            fvStorageCap,
            st1,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vStorageCap[(st1, r, y)]),
        )
    end
end;
close(fvStorageCap);

fvStorageNewCap = open("output/vStorageNewCap.csv", "w");
println(fvStorageNewCap, "stg,region,year,value");
for (st1, r, y) in mStorageNew
    if JuMP.value(vStorageNewCap[(st1, r, y)]) != 0
        println(
            fvStorageNewCap,
            st1,
            ",",
            r,
            ",",
            y,
            ",",
            JuMP.value(vStorageNewCap[(st1, r, y)]),
        )
    end
end;
close(fvStorageNewCap);

fvImportTot = open("output/vImportTot.csv", "w");
println(fvImportTot, "comm,region,year,slice,value");
for (c, r, y, s) in mImport
    if JuMP.value(vImportTot[(c, r, y, s)]) != 0
        println(
            fvImportTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vImportTot[(c, r, y, s)]),
        )
    end
end;
close(fvImportTot);

fvExportTot = open("output/vExportTot.csv", "w");
println(fvExportTot, "comm,region,year,slice,value");
for (c, r, y, s) in mExport
    if JuMP.value(vExportTot[(c, r, y, s)]) != 0
        println(
            fvExportTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vExportTot[(c, r, y, s)]),
        )
    end
end;
close(fvExportTot);

fvTradeIr = open("output/vTradeIr.csv", "w");
println(fvTradeIr, "trade,comm,region,regionp,year,slice,value");
for (t1, c, r, rp, y, s) in mvTradeIr
    if JuMP.value(vTradeIr[(t1, c, r, rp, y, s)]) != 0
        println(
            fvTradeIr,
            t1,
            ",",
            c,
            ",",
            r,
            ",",
            rp,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTradeIr[(t1, c, r, rp, y, s)]),
        )
    end
end;
close(fvTradeIr);

fvTradeIrAInp = open("output/vTradeIrAInp.csv", "w");
println(fvTradeIrAInp, "trade,comm,region,year,slice,value");
for (t1, c, r, y, s) in mvTradeIrAInp
    if JuMP.value(vTradeIrAInp[(t1, c, r, y, s)]) != 0
        println(
            fvTradeIrAInp,
            t1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTradeIrAInp[(t1, c, r, y, s)]),
        )
    end
end;
close(fvTradeIrAInp);

fvTradeIrAInpTot = open("output/vTradeIrAInpTot.csv", "w");
println(fvTradeIrAInpTot, "comm,region,year,slice,value");
for (c, r, y, s) in mvTradeIrAInpTot
    if JuMP.value(vTradeIrAInpTot[(c, r, y, s)]) != 0
        println(
            fvTradeIrAInpTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTradeIrAInpTot[(c, r, y, s)]),
        )
    end
end;
close(fvTradeIrAInpTot);

fvTradeIrAOut = open("output/vTradeIrAOut.csv", "w");
println(fvTradeIrAOut, "trade,comm,region,year,slice,value");
for (t1, c, r, y, s) in mvTradeIrAOut
    if JuMP.value(vTradeIrAOut[(t1, c, r, y, s)]) != 0
        println(
            fvTradeIrAOut,
            t1,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTradeIrAOut[(t1, c, r, y, s)]),
        )
    end
end;
close(fvTradeIrAOut);

fvTradeIrAOutTot = open("output/vTradeIrAOutTot.csv", "w");
println(fvTradeIrAOutTot, "comm,region,year,slice,value");
for (c, r, y, s) in mvTradeIrAOutTot
    if JuMP.value(vTradeIrAOutTot[(c, r, y, s)]) != 0
        println(
            fvTradeIrAOutTot,
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vTradeIrAOutTot[(c, r, y, s)]),
        )
    end
end;
close(fvTradeIrAOutTot);

fvExportRowAccumulated = open("output/vExportRowAccumulated.csv", "w");
println(fvExportRowAccumulated, "expp,comm,value");
for (e, c) in mExpComm
    if JuMP.value(vExportRowAccumulated[(e, c)]) != 0
        println(
            fvExportRowAccumulated,
            e,
            ",",
            c,
            ",",
            JuMP.value(vExportRowAccumulated[(e, c)]),
        )
    end
end;
close(fvExportRowAccumulated);

fvExportRow = open("output/vExportRow.csv", "w");
println(fvExportRow, "expp,comm,region,year,slice,value");
for (e, c, r, y, s) in mExportRow
    if JuMP.value(vExportRow[(e, c, r, y, s)]) != 0
        println(
            fvExportRow,
            e,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vExportRow[(e, c, r, y, s)]),
        )
    end
end;
close(fvExportRow);

fvImportRowAccumulated = open("output/vImportRowAccumulated.csv", "w");
println(fvImportRowAccumulated, "imp,comm,value");
for (i, c) in mImpComm
    if JuMP.value(vImportRowAccumulated[(i, c)]) != 0
        println(
            fvImportRowAccumulated,
            i,
            ",",
            c,
            ",",
            JuMP.value(vImportRowAccumulated[(i, c)]),
        )
    end
end;
close(fvImportRowAccumulated);

fvImportRow = open("output/vImportRow.csv", "w");
println(fvImportRow, "imp,comm,region,year,slice,value");
for (i, c, r, y, s) in mImportRow
    if JuMP.value(vImportRow[(i, c, r, y, s)]) != 0
        println(
            fvImportRow,
            i,
            ",",
            c,
            ",",
            r,
            ",",
            y,
            ",",
            s,
            ",",
            JuMP.value(vImportRow[(i, c, r, y, s)]),
        )
    end
end;
close(fvImportRow);

fvTradeCap = open("output/vTradeCap.csv", "w");
println(fvTradeCap, "trade,year,value");
for (t1, y) in mTradeSpan
    if JuMP.value(vTradeCap[(t1, y)]) != 0
        println(fvTradeCap, t1, ",", y, ",", JuMP.value(vTradeCap[(t1, y)]))
    end
end;
close(fvTradeCap);

fvTradeInv = open("output/vTradeInv.csv", "w");
println(fvTradeInv, "trade,region,year,value");
for (t1, r, y) in mTradeEac
    if JuMP.value(vTradeInv[(t1, r, y)]) != 0
        println(fvTradeInv, t1, ",", r, ",", y, ",", JuMP.value(vTradeInv[(t1, r, y)]))
    end
end;
close(fvTradeInv);

fvTradeEac = open("output/vTradeEac.csv", "w");
println(fvTradeEac, "trade,region,year,value");
for (t1, r, y) in mTradeEac
    if JuMP.value(vTradeEac[(t1, r, y)]) != 0
        println(fvTradeEac, t1, ",", r, ",", y, ",", JuMP.value(vTradeEac[(t1, r, y)]))
    end
end;
close(fvTradeEac);

fvTradeNewCap = open("output/vTradeNewCap.csv", "w");
println(fvTradeNewCap, "trade,year,value");
for (t1, y) in mTradeNew
    if JuMP.value(vTradeNewCap[(t1, y)]) != 0
        println(fvTradeNewCap, t1, ",", y, ",", JuMP.value(vTradeNewCap[(t1, y)]))
    end
end;
close(fvTradeNewCap);

fvTotalUserCosts = open("output/vTotalUserCosts.csv", "w");
println(fvTotalUserCosts, "region,year,value");
for (r, y) in mvTotalUserCosts
    if JuMP.value(vTotalUserCosts[(r, y)]) != 0
        println(fvTotalUserCosts, r, ",", y, ",", JuMP.value(vTotalUserCosts[(r, y)]))
    end
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
println(vrb_list, "vAggOutTot");
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
println(vrb_list, "vTechOutTot1");
println(vrb_list, "vTechOutTot2");
println(vrb_list, "vTechOutTot3");
println(vrb_list, "vTechOutTot4");
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
println(vrb_list, "vImportTot");
println(vrb_list, "vExportTot");
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
for rr in comm
    println(raw_data, "comm,", rr)
end
for rr in region
    println(raw_data, "region,", rr)
end
for rr in year
    println(raw_data, "year,", rr)
end
for rr in slice
    println(raw_data, "slice,", rr)
end
for rr in sup
    println(raw_data, "sup,", rr)
end
for rr in dem
    println(raw_data, "dem,", rr)
end
for rr in tech
    println(raw_data, "tech,", rr)
end
for rr in stg
    println(raw_data, "stg,", rr)
end
for rr in trade
    println(raw_data, "trade,", rr)
end
for rr in expp
    println(raw_data, "expp,", rr)
end
for rr in imp
    println(raw_data, "imp,", rr)
end
for rr in group
    println(raw_data, "group,", rr)
end
for rr in weather
    println(raw_data, "weather,", rr)
end

close(raw_data);
