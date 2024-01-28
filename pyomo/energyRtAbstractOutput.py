head_val = {
    "vTechInv": "tech,region,year,value",
    "vTechEac": "tech,region,year,value",
    "vTechOMCost": "tech,region,year,value",
    "vSupCost": "sup,region,year,value",
    "vEmsFuelTot": "comm,region,year,slice,value",
    "vBalance": "comm,region,year,slice,value",
    "vTotalCost": "region,year,value",
    "vObjective": "value",
    "vTaxCost": "comm,region,year,value",
    "vSubsCost": "comm,region,year,value",
    "vAggOutTot": "comm,region,year,slice,value",
    "vStorageOMCost": "stg,region,year,value",
    "vTradeCost": "region,year,value",
    "vTradeRowCost": "region,year,value",
    "vTradeIrCost": "region,year,value",
    "vTechNewCap": "tech,region,year,value",
    "vTechRetiredStock": "tech,region,year,value",
    "vTechRetiredNewCap": "tech,region,year,year,value",
    "vTechCap": "tech,region,year,value",
    "vTechAct": "tech,region,year,slice,value",
    "vTechInp": "tech,comm,region,year,slice,value",
    "vTechOut": "tech,comm,region,year,slice,value",
    "vTechAInp": "tech,comm,region,year,slice,value",
    "vTechAOut": "tech,comm,region,year,slice,value",
    "vSupOut": "sup,comm,region,year,slice,value",
    "vSupReserve": "sup,comm,region,value",
    "vDemInp": "comm,region,year,slice,value",
    "vOutTot": "comm,region,year,slice,value",
    "vInpTot": "comm,region,year,slice,value",
    "vInp2Lo": "comm,region,year,slice,slice,value",
    "vOut2Lo": "comm,region,year,slice,slice,value",
    "vSupOutTot": "comm,region,year,slice,value",
    "vTechInpTot": "comm,region,year,slice,value",
    "vTechOutTot": "comm,region,year,slice,value",
    "vTechOutTot1": "comm,region,year,slice,value",
    "vTechOutTot2": "comm,region,year,slice,value",
    "vTechOutTot3": "comm,region,year,slice,value",
    "vTechOutTot4": "comm,region,year,slice,value",
    "vStorageInpTot": "comm,region,year,slice,value",
    "vStorageOutTot": "comm,region,year,slice,value",
    "vStorageAInp": "stg,comm,region,year,slice,value",
    "vStorageAOut": "stg,comm,region,year,slice,value",
    "vDummyImport": "comm,region,year,slice,value",
    "vDummyExport": "comm,region,year,slice,value",
    "vStorageInp": "stg,comm,region,year,slice,value",
    "vStorageOut": "stg,comm,region,year,slice,value",
    "vStorageStore": "stg,comm,region,year,slice,value",
    "vStorageInv": "stg,region,year,value",
    "vStorageEac": "stg,region,year,value",
    "vStorageCap": "stg,region,year,value",
    "vStorageNewCap": "stg,region,year,value",
    "vImportTot": "comm,region,year,slice,value",
    "vExportTot": "comm,region,year,slice,value",
    "vTradeIr": "trade,comm,region,region,year,slice,value",
    "vTradeIrAInp": "trade,comm,region,year,slice,value",
    "vTradeIrAInpTot": "comm,region,year,slice,value",
    "vTradeIrAOut": "trade,comm,region,year,slice,value",
    "vTradeIrAOutTot": "comm,region,year,slice,value",
    "vExportRowAccumulated": "expp,comm,value",
    "vExportRow": "expp,comm,region,year,slice,value",
    "vImportRowAccumulated": "imp,comm,value",
    "vImportRow": "imp,comm,region,year,slice,value",
    "vTradeCap": "trade,year,value",
    "vTradeInv": "trade,region,year,value",
    "vTradeEac": "trade,region,year,value",
    "vTradeNewCap": "trade,year,value",
    "vTotalUserCosts": "region,year,value",
}
flist = open("output/variable_list.csv", "w")
flist.write("value\n")
for v in instance.component_objects(Var):
    if str(v) != "fornontriv":
        f = open("output/" + str(v) + ".csv", "w")
        f.write(head_val[str(v)] + "\n")
        flist.write(str(v) + "\n")
        for index in v:
            if not v[index].stale and v[index].value != 0:
                u = ""
                if index != None:
                    for i in index:
                        u = u + str(i) + ","
                    u = u + str(v[index].value)
                else:
                    u = str(v[index].value)
                f.write(u + "\n")
        f.close()
flist.close()
