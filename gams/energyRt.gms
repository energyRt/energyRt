$ontext
#!onLatex
\documentclass{article}
\usepackage[a4paper,landscape,margin=1in]{geometry}
\usepackage[utf8]{inputenc}
\usepackage{breqn}
\usepackage{longtable}
\usepackage{graphicx}
\title{Implementation of energyRt Reference Energy System model in GAMS}
\date{May 12, 2019}
\author{Oleg Lugovoy \and Vladimir Potashnikov}
\begin{document}
\maketitle
   \begin{abstract}
         The model is a part of \textbf{energyRt} package for energy systems modeling in \textbf{R}
         (\url{https://github.com/olugovoy/energyRt}), developed by Oleg Lugovoy and Vladimir Potashnikov,
         and implemented in GAMS and GLPK/MathProg by Vladimir Potashnikov.
         The package and the code of the model is dessiminated under GNU Affero General Public License (AGPL-3)
         free public license (see \url{https://www.gnu.org/licenses/agpl.html} for details).
   \end{abstract}
\end{document}
#!offLatex
=======
\end{abstract}
$offtext

$include inc1.gms

OPTION RESLIM=50000, PROFILE=0, SOLVEOPT=REPLACE;
OPTION ITERLIM=999999, LIMROW=0, LIMCOL=0, SOLPRINT=OFF;
*OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;
*OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;

file log_stat / 'output/log.csv'/;
log_stat.lp = 1;
put log_stat;
put "parameter,value,time"/;
put '"model language",gams,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;
put '"model definition",,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;

********************************************************************************
$ontext
\section{Declarations}
$offtext
********************************************************************************
* Main sets
set
tech   technology
sup    supply
dem    demand
stg    storage
expp   export to the rest of the world (ROW)
imp    import from the rest of the world
trade  trade between regions
group  group of input or output commodities in technology
comm   commodity
region region
year   year
slice  time slice
weather  weather
;

Alias (tech, techp), (region, regionp), (year, yearp), (year, yeare), (year, yearn);
Alias (slice, slicep), (slice, slicepp), (group, groupp), (comm, commp), (comm, acomm), (comm, comme), (sup, supp);
alias (region, src), (region, dst);
* Alias for statment
*Alias (year, year_cns), (tech, tech_cns), (dem, dem_cns), (sup, sup_cns), (stg, stg_cns);
*Alias (slice_cns, slice), (trade, trade_cns), (imp, imp_cns), (expp, expp_cns);

* Mapping sets
set
mSameRegion(region, region)   The same region (used in GLPK)
mSameSlice(slice, slice)      The same slice (used in GLPK)
*! technology:input
mMilestoneFirst(year)          First period milestone
mMilestoneLast(year)           Last period milestone
mMilestoneNext(year, year)     Next period milestone
mMilestoneHasNext(year)        Is there next period milestone
mStartMilestone(year, year)    Start of the period
mEndMilestone(year, year)      End of the period
mMidMilestone(year)            Milestone year
mCommSlice(comm, slice)        Commodity to slice
mCommSliceOrParent(comm, slice, slice)
mTechRetirement(tech)          Early retirement option
mTechUpgrade(tech, tech)       Upgrade technology (not implemented yet)
mTechInpComm(tech, comm)       Input commodity
mTechOutComm(tech, comm)       Output commodity
mTechInpGroup(tech, group)     Group input
mTechOutGroup(tech, group)     Group output
mTechOneComm(tech, comm)       Commodity without group
*
mTechGroupComm(tech, group, comm)  Mapping between commodity-groups and commodities
* Aux input comm map
mTechAInp(tech, comm)            Auxiliary input
* Aux output comm map
mTechAOut(tech, comm)            Auxiliary output
*
mTechNew(tech, region, year)     Technologies available for investment
mTechSpan(tech, region, year)    Availability of each technology by regions and milestone years
mTechSlice(tech, slice)          Technology to slice-level
* Supply
mSupSlice(sup, slice)             Supply to slices-level
mSupComm(sup, comm)               Supplied commodities
mSupSpan(sup, region)             Supply in regions
mSupWeatherLo(sup, weather)       Use weather to supply ava.lo
mSupWeatherUp(sup, weather)       Use weather to supply ava.up
mWeatherSlice(weather, slice)     Weather slice
mWeatherRegion(weather, region)   Weather region
* Demand
mDemComm(dem, comm)               Demand commodities
* Ballance
mUpComm(comm)  Commodity balance type PRODUCTION <= CONSUMPTION
mLoComm(comm)  Commodity balance type PRODUCTION >= CONSUMPTION
mFxComm(comm)  Commodity balance type PRODUCTION == CONSUMPTION
* Storage
mStorageFullYear(stg)                 Mapping of storage with joint slice
mStorageComm(stg, comm)            Mapping of storage technology and respective commodity
mStorageAInp(stg, comm)            Aux-commodity input to storage
mStorageAOut(stg, comm)            Aux-commodity output from storage
mStorageNew(stg, region, year)     Storage available for investment
mStorageSpan(stg, region, year)    Storage set showing if the storage may exist in the year and region
mStorageOMCost(stg, region, year)
mStorageEac(stg, region, year)
mSliceNext(slice, slice)           Next slice
mSliceFYearNext(slice, slice)           Next slice joint
* Trade and ROW
mTradeSlice(trade, slice)          Trade to slice
mTradeComm(trade, comm)            Trade commodities
mTradeRoutes(trade, region, region)
mTradeIrAInp(trade, comm)          Auxiliary  input commodity in source region
mTradeIrAOut(trade, comm)          Auxiliary output commodity in source region
mExpComm(expp, comm)               Export commodities
mImpComm(imp, comm)                Import commodities
mExpSlice(expp, slice)             Export to slice
mImpSlice(imp, slice)              Import to slice
* Mapping for Salvage (temporary)
mDiscountZero(region)
mSliceParentChildE(slice, slice) Child slice or the same
mSliceParentChild(slice, slice)        Child slice not the same
*
mTechWeatherAf(tech, weather)
mTechWeatherAfs(tech, weather)
mTechWeatherAfc(tech, weather, comm)
*
mStorageWeatherAf(stg, weather)
mStorageWeatherCinp(stg, weather)
mStorageWeatherCout(stg, weather)


mTradeRoutes(trade, region, region)
mTradeSpan(trade, year)
mTradeNew(trade, year)
mTradeOlifeInf(trade)
mTradeEac(trade, region, year)
mTradeCapacityVariable(trade)
* mTradeNew(trade, year) and pTradeInvcost(trade, region, year) <> 0
mTradeInv(trade, region, year)
mAggregateFactor(comm, comm)
;

* Set priority
* t, sup, g, c, r, y, s
* tech, sup, group, comm, region, year, slice
* Parameter
parameter
ordYear(year)           ord year for GLPK
cardYear(year)          card year for GLPK
pPeriodLen(year)        Length of perios for milestone year
pSliceShare(slice)      Share of slice
* Aggregate
pAggregateFactor(comm, comm)                       Aggregation factor of commodities
* Technology parameter
pTechOlife(tech, region)                           Operational life of technologies
pTechCinp2ginp(tech, comm, region, year, slice)    Multiplier that transforms commodity input into group input
pTechGinp2use(tech, group, region, year, slice)    Multiplier that transforms group input into use
pTechCinp2use(tech, comm, region, year, slice)     Multiplier that transforms commodity input to use
pTechUse2cact(tech, comm, region, year, slice)     Multiplier that transforms use to commodity activity
pTechCact2cout(tech, comm, region, year, slice)    Multiplier that transforms commodity activity to commodity output
pTechEmisComm(tech, comm)                          Combustion factor for input commodity (from 0 to 1)
* Auxiliary input commodities
pTechAct2AInp(tech, comm, region, year, slice)     Multiplier to activity to calculate aux-commodity input
pTechCap2AInp(tech, comm, region, year, slice)     Multiplier to capacity to calculate aux-commodity input
pTechNCap2AInp(tech, comm, region, year, slice)     Multiplier to new-capacity to calculate aux-commodity input
pTechCinp2AInp(tech, comm, comm, region, year, slice)    Multiplier to commodity-input to calculate aux-commodity input
pTechCout2AInp(tech, comm, comm, region, year, slice)    Multiplier to commodity-output to calculate aux-commodity input
* Aux output comm map
pTechAct2AOut(tech, comm, region, year, slice)     Multiplier to activity to calculate aux-commodity output
pTechCap2AOut(tech, comm, region, year, slice)     Multiplier to capacity to calculate aux-commodity output
pTechNCap2AOut(tech, comm, region, year, slice)     Multiplier to new capacity to calculate aux-commodity output
pTechCinp2AOut(tech, comm, comm, region, year, slice)     Multiplier to commodity to calculate aux-commodity output
pTechCout2AOut(tech, comm, comm, region, year, slice)     Multiplier to commodity-output to calculate aux-commodity input
*
pTechFixom(tech, region, year)                      Fixed Operating and maintenance (O&M) costs (per unit of capacity)
pTechVarom(tech, region, year, slice)               Variable O&M costs (per unit of acticity)
pTechInvcost(tech, region, year)                    Investment costs (per unit of capacity)
pTechEac(tech, region, year)                        Eac coefficient for investment costs (per unit of capacity)
pTechShareLo(tech, comm, region, year, slice)       Lower bound for share of the commodity in total group input or output
pTechShareUp(tech, comm, region, year, slice)       Upper bound for share of the commodity in total group input or output
pTechAfLo(tech, region, year, slice)                Lower bound for activity for each slice
pTechAfUp(tech, region, year, slice)                Upper bound for activity for each slice
pTechAfsLo(tech, region, year, slice)               Lower bound for activity for sum over slices
pTechAfsUp(tech, region, year, slice)               Upper bound for activity for sum over slices
pTechAfcLo(tech, comm, region, year, slice)         Lower bound for commodity output
pTechAfcUp(tech, comm, region, year, slice)         Upper bound for commodity output
pTechStock(tech, region, year)                      Technology capacity stock
pTechCap2act(tech)                                  Technology capacity units to activity units conversion factor
pTechCvarom(tech, comm, region, year, slice)        Commodity-specific variable costs (per unit of commodity input or output)
pTechAvarom(tech, comm, region, year, slice)        Auxilary Commodity-specific variable costs (per unit of commodity input or output)
* Exit stock and salvage
pDiscount(region, year)                             Discount rate (can be region and year specific)
pDiscountFactor(region, year)                       Discount factor (cumulative)
pDiscountFactorMileStone(region, year)              Discount factor (cumulative) sum for MileStone
* Supply
pSupCost(sup, comm, region, year, slice)            Costs of supply (price per unit)
pSupAvaUp(sup, comm, region, year, slice)           Upper bound for supply
pSupAvaLo(sup, comm, region, year, slice)           Lower bound for supply
pSupReserveUp(sup, comm, region)                    Total supply reserve by region Up
pSupReserveLo(sup, comm, region)                    Total supply reserve by region Lo
* Demand
pDemand(dem, comm, region, year, slice)             Exogenous demand
* Emissions
pEmissionFactor(comm, comm)                         Emission factor
* Dummy import
pDummyImportCost(comm, region, year, slice)         Dummy costs parameters (for debugging)
pDummyExportCost(comm, region, year, slice)         Dummy costs parameters (for debuging)
* Taxes and subsidies
pTaxCost(comm, region, year, slice)                 Commodity taxes
pSubsCost(comm, region, year, slice)                Commodity subsidies
*
pWeather(weather, region, year, slice)              Weather factor (class weather)
pSupWeatherLo(sup, weather)                         Weather multiplier for supply ava.lo
pSupWeatherUp(sup, weather)                         Weather multiplier for supply ava.up
*
pTechWeatherAfLo(tech, weather)                     Weather multiplier for tech af.lo
pTechWeatherAfUp(tech, weather)                     Weather multiplier for tech af.up
*
pTechWeatherAfsLo(tech, weather)                    Weather multiplier for tech afs.lo
pTechWeatherAfsUp(tech, weather)                    Weather multiplier for tech afs.up

pTechWeatherAfcLo(tech, weather, comm)              Weather multiplier for tech afc.lo
pTechWeatherAfcUp(tech, weather, comm)              Weather multiplier for tech afc.up

pStorageWeatherAfUp(stg, weather)                   Weather multiplier for storages af.up
pStorageWeatherAfLo(stg, weather)                   Weather multiplier for storages af.lo
pStorageWeatherCinpUp(stg, weather)                 Weather multiplier for storages cinp.up
pStorageWeatherCinpLo(stg, weather)                 Weather multiplier for storages cinp.lo
pStorageWeatherCoutUp(stg, weather)                 Weather multiplier for storages cout.up
pStorageWeatherCoutLo(stg, weather)                 Weather multiplier for storages cout.lo
;

* Storage technology parameters
parameter
pStorageInpEff(stg, comm, region, year, slice)      Storage input efficiency
pStorageOutEff(stg, comm, region, year, slice)      Storage output efficiency
pStorageStgEff(stg, comm, region, year, slice)      Storage time-efficiency (annual)
pStorageStock(stg, region, year)                    Storage capacity stock
pStorageOlife(stg, region)                          Storage operational life
pStorageCostStore(stg, region, year, slice)         Storing costs per stored amount (annual)
pStorageCostInp(stg, region, year, slice)           Storage input costs
pStorageCostOut(stg, region, year, slice)           Storage output costs
pStorageFixom(stg, region, year)                    Storage fixed O&M costs
pStorageInvcost(stg, region, year)                  Storage investment costs
pStorageEac(stg, region, year)
pStorageCap2stg(stg)                                Storage capacity units to activity units conversion factor
pStorageAfLo(stg, region, year, slice)              Storage capacity lower bound (minimum charge level)
pStorageAfUp(stg, region, year, slice)              Storage capacity upper bound (maximum charge level)
pStorageCinpUp(stg, comm, region, year, slice)      Storage input upper bound
pStorageCinpLo(stg, comm, region, year, slice)      Storage input lower bound
pStorageCoutUp(stg, comm, region, year, slice)      Storage output upper bound
pStorageCoutLo(stg, comm, region, year, slice)      Storage output lower bound
pStorageNCap2Stg(stg, comm, region, year, slice)   Initial storage charging for new investment
pStorageCharge(stg, comm, region, year, slice)    Initial storage charging for stock
pStorageStg2AInp(stg, comm, region, year, slice)    Storage accumulated volume to auxilary input
pStorageStg2AOut(stg, comm, region, year, slice)    Storage accumulated volume output
pStorageInp2AInp(stg, comm, region, year, slice)    Storage input to auxilary input coefficient
pStorageInp2AOut(stg, comm, region, year, slice)    Storage input to auxilary output coefficient
pStorageOut2AInp(stg, comm, region, year, slice)    Storage output to auxilary input coefficient
pStorageOut2AOut(stg, comm, region, year, slice)    Storage output to auxilary output coefficient
pStorageCap2AInp(stg, comm, region, year, slice)    Storage capacity to auxilary input coefficient
pStorageCap2AOut(stg, comm, region, year, slice)    Storage capacity to auxilary output coefficient
pStorageNCap2AInp(stg, comm, region, year, slice)   Storage new capacity to auxilary input coefficient
pStorageNCap2AOut(stg, comm, region, year, slice)   Storage new capacity to auxilary output coefficient
;
* Trade parameters
parameter
pTradeIrEff(trade, region, region, year, slice)     Inter-regional trade efficiency
pTradeIrUp(trade, region, region, year, slice)      Upper bound on trade flow
pTradeIrLo(trade, region, region, year, slice)      Lower bound on trade flow
pTradeIrCost(trade, region, region, year, slice)    Costs of trade flow
pTradeIrMarkup(trade, region, region, year, slice)  Markup of trade flow
* Aux input and output
pTradeIrCsrc2Ainp(trade, comm, region, region, year, slice)   Auxiliary input commodity in source region
pTradeIrCsrc2Aout(trade, comm, region, region, year, slice)   Auxiliary output commodity in source region
pTradeIrCdst2Ainp(trade, comm, region, region, year, slice)   Auxiliary input commodity in destination region
pTradeIrCdst2Aout(trade, comm, region, region, year, slice)   Auxiliary output commodity in destination region
pExportRowRes(expp)                                  Upper bound on accumulated export to ROW
pExportRowUp(expp, region, year, slice)              Upper bound on export to ROW
pExportRowLo(expp, region, year, slice)              Lower bound on export to ROW
pExportRowPrice(expp, region, year, slice)           Export prices to ROW
pImportRowRes(imp)                                   Upper bound on accumulated import to ROW
pImportRowUp(imp, region, year, slice)               Upper bount on import from ROW
pImportRowLo(imp, region, year, slice)               Lower bound on import from ROW
pImportRowPrice(imp, region, year, slice)            Import prices from ROW
pTradeStock(trade, year)
pTradeOlife(trade)
pTradeInvcost(trade, region, year)
pTradeEac(trade, region, year)
pTradeCap2Act(trade)
;

* Weather parameter
parameter
paTechWeatherAfLo(tech, region, year, slice)
paTechWeatherAfUp(tech, region, year, slice)
paTechWeatherAfsLo(tech, region, year, slice)
paTechWeatherAfsUp(tech, region, year, slice)
paTechWeatherAfcLo(tech, comm, region, year, slice)
paTechWeatherAfcUp(tech, comm, region, year, slice)
paSupWeatherUp(sup, comm, region, year, slice)
paSupWeatherLo(sup, comm, region, year, slice)
paStorageWeatherAfLo(stg, comm, region, year, slice)
paStorageWeatherAfUp(stg, comm, region, year, slice)
paStorageWeatherCinpUp(stg, comm, region, year, slice)
paStorageWeatherCinpLo(stg, comm, region, year, slice)
paStorageWeatherCoutUp(stg, comm, region, year, slice)
paStorageWeatherCoutLo(stg, comm, region, year, slice)
;

set
mvSupCost(sup, region, year)
mvTechInp(tech, comm, region, year, slice)
mvSupReserve(sup, comm, region)
mvTechRetiredCap(tech, region, year, year)
mvTechAct(tech, region, year, slice)
mvTechInp(tech, comm, region, year, slice)
mvTechOut(tech, comm, region, year, slice)
mvTechAInp(tech, comm, region, year, slice)
mvTechAOut(tech, comm, region, year, slice)
mvDemInp(comm, region, year, slice)
mvBalance(comm, region, year, slice)
mvInp2Lo(comm, region, year, slice, slice)
mvOut2Lo(comm, region, year, slice, slice)
mInpSub(comm, region, year, slice) For increase speed eqInpTot
mOutSub(comm, region, year, slice) For increase speed eqOutTot

mvStorageAInp(stg, comm, region, year, slice)
mvStorageAOut(stg, comm, region, year, slice)
mvStorageStore(stg, comm, region, year, slice)
mvStorageStore(stg, comm, region, year, slice)
mvTradeIr(trade, comm, region, region, year, slice)
mvTradeCost(region, year)
mvTradeRowCost(region, year)
mvTradeIrCost(region, year)
mvTotalCost(region, year)
;

$ontext
* Endogenous variables
** Technology
$offtext
positive variable
*@ mTechNew(tech, region, year)
vTechNewCap(tech, region, year)                      New capacity
*@ mvTechRetiredCap(tech, region, year, year)
vTechRetiredCap(tech, region, year, year)            Early retired capacity
*vTechRetrofitCap(tech, region, year, year)
*vTechUpgradeCap(tech, region, year)
* Activity and intput-output
*@ mTechSpan(tech, region, year)
vTechCap(tech, region, year)                         Total capacity of the technology
*@ mvTechAct(tech, region, year, slice)
vTechAct(tech, region, year, slice)                  Activity level of technology
*@ mvTechInp(tech, comm, region, year, slice)
vTechInp(tech, comm, region, year, slice)            Input level
*@ mvTechOut(tech, comm, region, year, slice)
vTechOut(tech, comm, region, year, slice)            Output level
* Auxiliary input & output
*@ mvTechAInp(tech, comm, region, year, slice)
vTechAInp(tech, comm, region, year, slice)           Auxiliary commodity input
*@ mvTechAOut(tech, comm, region, year, slice)
vTechAOut(tech, comm, region, year, slice)           Auxiliary commodity output
;
variable
*@ mTechNew(tech, region, year)
vTechInv(tech, region, year)                         Overnight investment costs
*@ mTechEac(tech, region, year)
vTechEac(tech, region, year)                         Annualized investment costs
*@ mTechOMCost(tech, region, year)
vTechOMCost(tech, region, year)                      Sum of all operational costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)
;
positive variable
* Supply
* (mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region))
*@ mSupAva(sup, comm, region, year, slice)
vSupOut(sup, comm, region, year, slice)              Output of supply
*@ mvSupReserve(sup, comm, region)
vSupReserve(sup, comm, region)                       Total supply reserve
;
variable
*@ mvSupCost(sup, region, year)
vSupCost(sup, region, year)                          Supply costs
;
positive variable
* Demand
*@ mvDemInp(comm, region, year, slice)
vDemInp(comm, region, year, slice)                   Input to demand
;
variable
* Emission
*@ mEmsFuelTot(comm, region, year, slice)
vEmsFuelTot(comm, region, year, slice)                   Total fuel emissions
** mTechEmsFuel(tech, comm, region, year, slice)
*vTechEmsFuel(tech, comm, region, year, slice)            Emissions from commodity input to tech (like fuel combustion)
;
variable
* Ballance
*@ mvBalance(comm, region, year, slice)
vBalance(comm, region, year, slice)                  Net commodity balance
;
positive variable
*@ mvBalance(comm, region, year, slice)
vOutTot(comm, region, year, slice)                   Total commodity output (consumption is not counted)
*@ mvBalance(comm, region, year, slice)
vInpTot(comm, region, year, slice)                   Total commodity input
*@ mvInp2Lo(comm, region, year, slice, slice)
vInp2Lo(comm, region, year, slice, slice)            Desagregation of slices for input parent to (grand)child
*@ mvOut2Lo(comm, region, year, slice, slice)
vOut2Lo(comm, region, year, slice, slice)            Desagregation of slices for output parent to (grand)child
*@ mSupOutTot(comm, region, year, slice)
vSupOutTot(comm, region, year, slice)                Total commodity supply
*@ mTechInpTot(comm, region, year, slice)
vTechInpTot(comm, region, year, slice)               Total commodity input to technologies
*@ mTechOutTot(comm, region, year, slice)
vTechOutTot(comm, region, year, slice)               Total commodity output from technologies
*@ mStorageInpTot(comm, region, year, slice)
vStorageInpTot(comm, region, year, slice)            Total commodity input to storages
*@ mStorageOutTot(comm, region, year, slice)
vStorageOutTot(comm, region, year, slice)            Total commodity output from storages
*@ mvStorageAInp(stg, comm, region, year, slice)
vStorageAInp(stg, comm, region, year, slice)         Aux-commodity input to storage
*@ mvStorageAOut(stg, comm, region, year, slice)
vStorageAOut(stg, comm, region, year, slice)         Aux-commodity input from storage
;
variable
* Costs variable
*@ mvTotalCost(region, year)
vTotalCost(region, year)                             Regional annual total costs
vObjective                                           Objective costs
;
positive variable
* Dummy import
*@ mDummyImport(comm, region, year, slice)
vDummyImport(comm, region, year, slice)               Dummy import (for debugging)
*@ mDummyExport(comm, region, year, slice)
vDummyExport(comm, region, year, slice)               Dummy export (for debugging)
** mDummyCost(comm, region, year)
*vDummyCost(comm, region, year)                        Dummy import & export costs  (for debugging)
;
variable
* Tax
*@ mTaxCost(comm, region, year)
vTaxCost(comm, region, year)                         Total tax levies (tax costs)
* Subs
*@ mSubsCost(comm, region, year)
vSubsCost(comm, region, year)                        Total subsidies (for substraction from costs)
;

variable
*@ mAggOut(comm, region, year, slice)
vAggOut(comm, region, year, slice)                   Aggregated commodity output
;

* Reserves
positive variable
*@ mvStorageStore(stg, comm, region, year, slice)
vStorageInp(stg, comm, region, year, slice)          Storage input
*@ mvStorageStore(stg, comm, region, year, slice)
vStorageOut(stg, comm, region, year, slice)          Storage output
*@ mvStorageStore(stg, comm, region, year, slice)
vStorageStore(stg, comm, region, year, slice)        Storage accumulated level
*@ mStorageNew(stg, region, year)
vStorageInv(stg, region, year)                       Storage technology investments
*@ mStorageEac(stg, region, year)
vStorageEac(stg, region, year)                       Storage technology EAC investments
*@ mStorageSpan(stg, region, year)
vStorageCap(stg, region, year)                       Storage capacity
*@ mStorageNew(stg, region, year)
vStorageNewCap(stg, region, year)                    Storage new capacity
;
variable
*@ mStorageOMCost(stg, region, year)
vStorageOMCost(stg, region, year)                    Storage O&M costs
;

* Trade and Row variable
positive variable
*@ mImport(comm, region, year, slice)
vImport(comm, region, year, slice)                   Total regional import (Ir + ROW)
*@ mExport(comm, region, year, slice)
vExport(comm, region, year, slice)                   Total regional export (Ir + ROW)
*@ mvTradeIr(trade, comm, region, region, year, slice)
vTradeIr(trade, comm, region, region, year, slice)   Total physical trade flows between regions
*@ mvTradeIrAInp(trade, comm, region, year, slice)
vTradeIrAInp(trade, comm, region, year, slice)       Trade auxilari input
*@ mvTradeIrAInpTot(comm, region, year, slice)
vTradeIrAInpTot(comm, region, year, slice)           Trade total auxilari input
*@ mvTradeIrAOut(trade, comm, region, year, slice)
vTradeIrAOut(trade, comm, region, year, slice)       Trade auxilari output
*@ mvTradeIrAOutTot(comm, region, year, slice)
vTradeIrAOutTot(comm, region, year, slice)           Trade auxilari output
*@ mExpComm(expp, comm)
vExportRowAccumulated(expp, comm)                    Accumulated export to ROW
*@ mExportRow(expp, comm, region, year, slice)
vExportRow(expp, comm, region, year, slice)          Export to ROW
*@ mImpComm(imp, comm)
vImportRowAccumulated(imp, comm)                     Accumulated import from ROW
*@ mImportRow(imp, comm, region, year, slice)
vImportRow(imp, comm, region, year, slice)           Import from ROW
;
variable
*@ mvTradeCost(region, year)
vTradeCost(region, year)                             Total trade costs
*@ mvTradeRowCost(region, year)
vTradeRowCost(region, year)                          Trade with ROW costs
*@ mvTradeIrCost(region, year)
vTradeIrCost(region, year)                           Interregional trade costs
;
positive variable
*@ mTradeSpan(trade, year)
vTradeCap(trade, year)
*@ mTradeEac(trade, region, year)
vTradeInv(trade, region, year)
*@ mTradeEac(trade, region, year)
vTradeEac(trade, region, year)
*@ mTradeNew(trade, year)
vTradeNewCap(trade, year)
;

********************************************************************************
* Mapping to drop unised variables and parameters, speed-up the model generation
* (especially in GLPK)
********************************************************************************
set
* (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and (mTechInpComm(tech, comm) or mTechAInp(tech, comm))), 1))
mTechInpTot(comm, region, year, slice)               Total technology input  mapp
* (mTechSlice(tech, slice) and mTechSpan(tech, region, year) and (mTechOutComm(tech, comm) or mTechAOut(tech, comm))), 1))
mTechOutTot(comm, region, year, slice)               Total technology output mapp
mTechEac(tech, region, year)
mTechOMCost(tech, region, year)
* (sum(sup$(mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region)), 1))
mSupOutTot(comm, region, year, slice)
* (sum(dem$mDemComm(dem, comm), 1) and mCommSlice(comm, slice))
mDemInp(comm, slice)
*  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and (sum(commp$(mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and pEmissionFactor(comm, commp) <> 0), 1)), 1))
mEmsFuelTot(comm, region, year, slice)
*  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)), 1))
mTechEmsFuel(tech, comm, comm, region, year, slice)
*  (mCommSlice(comm, slice) and pDummyImportCost(comm, region, year, slice) <> Inf)
mDummyImport(comm, region, year, slice)
*  (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)
mDummyExport(comm, region, year, slice)
* mDummyExport(comm, region, year, slice) or mDummyImport(comm, region, year, slice)
mDummyCost(comm, region, year)
* mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and mTradeRoutes(trade, src, dst))
mTradeIr(trade, region, region, year, slice)
* ((sum(dst$(mTradeIr(trade, region, dst, year, slice) and sum(comm$pTradeIrCdst2Ainp(trade, comm, region, dst, year, slice), 1) <> 0), 1) <> 0) or
*  (sum(src$(mTradeIr(trade, src, region, year, slice) and sum(comm$pTradeIrCsrc2Ainp(trade, comm, src, region, year, slice), 1) <> 0), 1) <> 0))
mvTradeIrAInp(trade, comm, region, year, slice)
* (sum(trade$mvTradeIrAInp(trade, comm, region, year, slice), 1) <> 0)
mvTradeIrAInpTot(comm, region, year, slice)
* ((sum(dst$(mTradeIr(trade, region, dst, year, slice) and sum(comm$pTradeIrCdst2Aout(trade, comm, region, dst, year, slice), 1) <> 0), 1) <> 0) or
*  (sum(src$(mTradeIr(trade, src, region, year, slice) and sum(comm$pTradeIrCsrc2Aout(trade, comm, src, region, year, slice), 1) <> 0), 1) <> 0))
mvTradeIrAOut(trade, comm, region, year, slice)
* (sum(trade$mvTradeIrAOut(trade, comm, region, year, slice), 1) <> 0)
mvTradeIrAOutTot(comm, region, year, slice)
* (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
mImportRow(imp, comm, region, year, slice)
mImportIrSub(comm, region, year, slice)
mImportRowSub(comm, region, year, slice)
mImportIrSubSlice(comm, region, year, slice, slice)
mImportIrSubSliceTrd(trade, comm, region, year, slice, slice)
mImportRowSubSlice(comm, region, year, slice, slice)

mExportIrSubSlice(comm, region, year, slice, slice)
mExportIrSubSliceTrd(trade, comm, region, year, slice, slice)
mExportRowSubSlice(comm, region, year, slice, slice)

mExportIrSub(comm, region, year, slice)
mExportRowSub(comm, region, year, slice)
* (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0 and pImportRowUp(imp, region, year, slice) <> Inf)
mImportRowUp(imp, comm, region, year, slice)
* pImportRowRes <> Inf
mImportRowAccumulatedUp(imp, comm)

mExportRow(expp, comm, region, year, slice)
mExportRowUp(expp, comm, region, year, slice)
mExportRowAccumulatedUp(expp, comm)
* sum(expp$mExportRow(expp, comm, region, year, slice), 1) + sum((trade, dst)$(mTradeIr(trade, region, dst, year, slice) and mTradeComm(trade, comm)), 1) <> 0
mExport(comm, region, year, slice)
* sum(imp$mImportRow(imp, comm, region, year, slice), 1) + sum((trade, src)$(mTradeIr(trade, src, region, year, slice) and mTradeComm(trade, comm)), 1) <> 0
mImport(comm, region, year, slice)
* (sum(stg$(mCommSlice(comm, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAInp(stg, comm)))
mStorageInpTot(comm, region, year, slice)
* (sum(stg$(mCommSlice(comm, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAOut(stg, comm)))
mStorageOutTot(comm, region, year, slice)
*   sum(slice$pTaxCost(comm, region, year, slice), 1)
mTaxCost(comm, region, year)
* sum(slice$pSubsCost(comm, region, year, slice), 1)
mSubsCost(comm, region, year)
* (sum(commp$pAggregateFactor(comm, commp), 1))
mAggOut(comm, region, year, slice)
mTechAfUp(tech, region, year, slice)
mTechAfUp(tech, region, year, slice)
mTechOlifeInf(tech, region)
mStorageOlifeInf(stg, region)
mTechAfcUp(tech, comm, region, year, slice)
mSupAvaUp(sup, comm, region, year, slice)
mSupAva(sup, comm, region, year, slice)
mSupReserveUp(sup, comm, region)
* sum(slicep$(mSliceParentChildE(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0 and
*(mSupOutTot(comm, region, year, slice) or mEmsFuelTot(comm, region, year, slice) or mAggOut(comm, region, year, slice) or
*mTechOutTot(comm, region, year, slice) or mStorageOutTot(comm, region, year, slice) or mImport(comm, region, year, slice) or
*mvTradeIrAOutTot(comm, region, year, slice))
mOut2Lo(comm, region, year, slice)
* sum(slicep$(mSliceParentChildE(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0
* and (mTechInpTot(comm, region, year, slice) or  mStorageInpTot(comm, region, year, slice) or
*  or mExport(comm, region, year, slice) or mTradeIrAInpTot(comm, region, year, slice))
mInp2Lo(comm, region, year, slice)
;

* me
set
meqTechNewCap(tech, region, year)
meqTechSng2Sng(tech, region, comm, comm, year, slice)
meqTechGrp2Sng(tech, region, group, comm, year, slice)
meqTechSng2Grp(tech, region, comm, group, year, slice)
meqTechGrp2Grp(tech, region, group, group, year, slice)
meqTechShareInpLo(tech, region, group, comm, year, slice)
meqTechShareInpUp(tech, region, group, comm, year, slice)
meqTechShareOutLo(tech, region, group, comm, year, slice)
meqTechShareOutUp(tech, region, group, comm, year, slice)
meqTechAfLo(tech, region, year, slice)
meqTechAfUp(tech, region, year, slice)
meqTechAfsLo(tech, region, year, slice)
meqTechAfsUp(tech, region, year, slice)
meqTechActSng(tech, comm, region, year, slice)
meqTechActGrp(tech, group, region, year, slice)
meqTechAfcOutLo(tech, region, comm, year, slice)
meqTechAfcOutUp(tech, region, comm, year, slice)
meqTechAfcInpLo(tech, region, comm, year, slice)
meqTechAfcInpUp(tech, region, comm, year, slice)
meqSupAvaLo(sup, comm, region, year, slice)
meqSupReserveLo(sup, comm, region)
meqStorageAfLo(stg, comm, region, year, slice)
meqStorageAfUp(stg, comm, region, year, slice)
meqStorageInpUp(stg, comm, region, year, slice)
meqStorageInpLo(stg, comm, region, year, slice)
meqStorageOutUp(stg, comm, region, year, slice)
meqStorageOutLo(stg, comm, region, year, slice)
meqTradeFlowUp(trade, comm, region, region, year, slice)
meqTradeFlowLo(trade, comm, region, region, year, slice)
meqExportRowLo(expp, comm, region, year, slice)
meqImportRowUp(imp, comm, region, year, slice)
meqImportRowLo(imp, comm, region, year, slice)
meqTradeCapFlow(trade, comm, year, slice)
meqBalLo(comm, region, year, slice)
meqBalUp(comm, region, year, slice)
meqBalFx(comm, region, year, slice)
meqLECActivity(tech, region, year)
;

$include inc2.gms

********************************************************************************
* Equations
********************************************************************************
********************************************************************************
** Technology equations
********************************************************************************

********************************************************************************
*** Activity Input & Output equations
********************************************************************************

* pTechUse2cact(tech, comm, region, year, slice) * pTechCact2cout(tech, comm, region, year, slice)


Equations
* Input & Output of ungrouped (single) commodities
eqTechSng2Sng(tech, region, comm, commp, year, slice)      Technology input to output
eqTechGrp2Sng(tech, region, group, commp, year, slice)     Technology group input to output
eqTechSng2Grp(tech, region, comm, groupp, year, slice)     Technology input to group output
eqTechGrp2Grp(tech, region, group, groupp, year, slice)    Technology group input to group output
;


eqTechSng2Sng(tech, region, comm, commp, year, slice)$meqTechSng2Sng(tech, region, comm, commp, year, slice)..
   vTechInp(tech, comm, region, year, slice) *
   pTechCinp2use(tech, comm, region, year, slice)
   =e=
   vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice);


eqTechGrp2Sng(tech, region, group, commp, year, slice)$meqTechGrp2Sng(tech, region, group, commp, year, slice)..
   pTechGinp2use(tech, group, region, year, slice) *
   sum(comm$mTechGroupComm(tech, group, comm),
           (vTechInp(tech, comm, region, year, slice) *
           pTechCinp2ginp(tech, comm, region, year, slice))$mvTechInp(tech, comm, region, year, slice)
   )
   =e=
   vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice);


eqTechSng2Grp(tech, region, comm, groupp, year, slice)$meqTechSng2Grp(tech, region, comm, groupp, year, slice)..
   vTechInp(tech, comm, region, year, slice) *
   pTechCinp2use(tech, comm, region, year, slice)
   =e=
    sum(commp$mTechGroupComm(tech, groupp, commp),
           (vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice))$mvTechOut(tech, commp, region, year, slice)
   );

eqTechGrp2Grp(tech, region, group, groupp, year, slice)$meqTechGrp2Grp(tech, region, group, groupp, year, slice)..
   pTechGinp2use(tech, group, region, year, slice) *
   sum(comm$mTechGroupComm(tech, group, comm),
           (vTechInp(tech, comm, region, year, slice) *
           pTechCinp2ginp(tech, comm, region, year, slice))$mvTechInp(tech, comm, region, year, slice)
   )
   =e=
   sum(commp$mTechGroupComm(tech, groupp, commp),
           (vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice))$mvTechOut(tech, commp, region, year, slice)
   );



********************************************************************************
* Shares equations for grouped commodities
********************************************************************************
Equations
* Input Share LO
eqTechShareInpLo(tech, region, group, comm, year, slice)    Technology lower bound on input share
* Input Share UP
eqTechShareInpUp(tech, region, group, comm, year, slice)    Technology upper bound on input share
* Output Share LO
eqTechShareOutLo(tech, region, group, comm, year, slice)    Technology lower bound on output share
* Output Share UP
eqTechShareOutUp(tech, region, group, comm, year, slice)    Technology upper bound on output share
;

* Input Share LO equation
eqTechShareInpLo(tech, region, group, comm, year, slice)$meqTechShareInpLo(tech, region, group, comm, year, slice)..
                  vTechInp(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$mTechGroupComm(tech, group, commp),
                          vTechInp(tech, commp, region, year, slice)$mvTechInp(tech, commp, region, year, slice)
                  );

* Input Share UP equation
eqTechShareInpUp(tech, region, group, comm, year, slice)$meqTechShareInpUp(tech, region, group, comm, year, slice)..
                  vTechInp(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$mTechGroupComm(tech, group, commp),
                          vTechInp(tech, commp, region, year, slice)$mvTechInp(tech, commp, region, year, slice)
                  );

* Output Share LO equation
eqTechShareOutLo(tech, region, group, comm, year, slice)$meqTechShareOutLo(tech, region, group, comm, year, slice)..
                  vTechOut(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$mTechGroupComm(tech, group, commp),
                          vTechOut(tech, commp, region, year, slice)$mvTechOut(tech, commp, region, year, slice)
                  );

* Output Share UP equation
eqTechShareOutUp(tech, region, group, comm, year, slice)$meqTechShareOutUp(tech, region, group, comm, year, slice)..
                  vTechOut(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$mTechGroupComm(tech, group, commp),
                          vTechOut(tech, commp, region, year, slice)$mvTechOut(tech, commp, region, year, slice)
                  );

********************************************************************************
* Auxiliary input & output equations
********************************************************************************
equation
eqTechAInp(tech, comm, region, year, slice) Technology auxiliary commodity input
eqTechAOut(tech, comm, region, year, slice) Technology auxiliary commodity output
;


eqTechAInp(tech, comm, region, year, slice)$mvTechAInp(tech, comm, region, year, slice)..
  vTechAInp(tech, comm, region, year, slice) =e=
  (vTechAct(tech, region, year, slice) *
    pTechAct2AInp(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AInp(tech, comm, region, year, slice)) +
  (vTechNewCap(tech, region, year) *
    pTechNCap2AInp(tech, comm, region, year, slice))$mTechNew(tech, region, year) +
  sum(commp$(pTechCinp2AInp(tech, comm, commp, region, year, slice) > 0),
      pTechCinp2AInp(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$(pTechCout2AInp(tech, comm, commp, region, year, slice) > 0),
      pTechCout2AInp(tech, comm, commp, region, year, slice) *
         vTechOut(tech, commp, region, year, slice));

eqTechAOut(tech, comm, region, year, slice)$mvTechAOut(tech, comm, region, year, slice)..
  vTechAOut(tech, comm, region, year, slice) =e=
  (vTechAct(tech, region, year, slice) *
    pTechAct2AOut(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AOut(tech, comm, region, year, slice)) +
  (vTechNewCap(tech, region, year) *
    pTechNCap2AOut(tech, comm, region, year, slice))$mTechNew(tech, region, year) +
  sum(commp$(pTechCinp2AOut(tech, comm, commp, region, year, slice) > 0),
      pTechCinp2AOut(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$(pTechCout2AOut(tech, comm, commp, region, year, slice) > 0),
      pTechCout2AOut(tech, comm, commp, region, year, slice) *
         vTechOut(tech, commp, region, year, slice));


********************************************************************************
* Availability factor equations
********************************************************************************
Equation
* Availability factor LO
eqTechAfLo(tech, region, year, slice) Technology availability factor lower bound
* Availability factor UP
eqTechAfUp(tech, region, year, slice) Technology availability factor upper bound
* Availability sum factor LO
eqTechAfsLo(tech, region, year, slice) Technology availability factor for sum lower bound
* Availability sum factor UP
eqTechAfsUp(tech, region, year, slice) Technology availability factor for sum upper bound
;

* Availability factor LO
eqTechAfLo(tech, region, year, slice)$meqTechAfLo(tech, region, year, slice)..
         pTechAfLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice)  * paTechWeatherAfLo(tech, region, year, slice)
         =l=
         vTechAct(tech, region, year, slice);

* Availability factor UP
eqTechAfUp(tech, region, year, slice)$meqTechAfUp(tech, region, year, slice)..
         vTechAct(tech, region, year, slice)
         =l=
         pTechAfUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfUp(tech, region, year, slice);

* Availability factor for sum LO
eqTechAfsLo(tech, region, year, slice)$meqTechAfsLo(tech, region, year, slice)..
         pTechAfsLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfsLo(tech, region, year, slice)
         =l=
         sum(slicep$mSliceParentChildE(slice, slicep), vTechAct(tech, region, year, slicep)$mvTechAct(tech, region, year, slicep));

* Availability factor for sum UP
eqTechAfsUp(tech, region, year, slice)$meqTechAfsUp(tech, region, year, slice)..
         sum(slicep$mSliceParentChildE(slice, slicep),
         vTechAct(tech, region, year, slicep)$mvTechAct(tech, region, year, slicep))
         =l=
         pTechAfsUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfsUp(tech, region, year, slice);

********************************************************************************
* Connect activity with output equations
********************************************************************************
Equation
* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)  Technology activity to commodity output
eqTechActGrp(tech, group, region, year, slice) Technology activity to group output
;

* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)$meqTechActSng(tech, comm, region, year, slice)..
  vTechAct(tech, region, year, slice) =e=
                 vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice);

eqTechActGrp(tech, group, region, year, slice)$meqTechActGrp(tech, group, region, year, slice)..
    vTechAct(tech, region, year, slice) =e=
         sum(comm$mTechGroupComm(tech, group, comm),
                 (vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice))$mvTechOut(tech, comm, region, year, slice)
         );

********************************************************************************
* Availability commodity factor equations
********************************************************************************
Equation
* Availability commodity factor LO output equations
eqTechAfcOutLo(tech, region, comm, year, slice) Technology commodity availability factor lower bound
* Availability commodity factor UP output equations
eqTechAfcOutUp(tech, region, comm, year, slice) Technology commodity availability factor upper bound
* Availability commodity factor LO input equations
eqTechAfcInpLo(tech, region, comm, year, slice) Technology commodity availability factor lower bound
* Availability commodity factor UP input equations
eqTechAfcInpUp(tech, region, comm, year, slice) Technology commodity availability factor upper bound
;

* Availability commodity factor LO output equations
eqTechAfcOutLo(tech, region, comm, year, slice)$meqTechAfcOutLo(tech, region, comm, year, slice)..
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfcLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfcLo(tech, comm, region, year, slice)
         =l=
         vTechOut(tech, comm, region, year, slice);

* Availability commodity factor UP output equations
eqTechAfcOutUp(tech, region, comm, year, slice)$meqTechAfcOutUp(tech, region, comm, year, slice)..
         vTechOut(tech, comm, region, year, slice)
         =l=
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfcUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfcUp(tech, comm, region, year, slice);

* Availability commodity factor LO input equations
eqTechAfcInpLo(tech, region, comm, year, slice)$meqTechAfcInpLo(tech, region, comm, year, slice)..
         pTechAfcLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice)  * paTechWeatherAfcLo(tech, comm, region, year, slice)
         =l=
         vTechInp(tech, comm, region, year, slice);

* Availability commodity factor UP input equations
eqTechAfcInpUp(tech, region, comm, year, slice)$meqTechAfcInpUp(tech, region, comm, year, slice)..
         vTechInp(tech, comm, region, year, slice)
         =l=
         pTechAfcUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * paTechWeatherAfcUp(tech, comm, region, year, slice);

********************************************************************************
* Capacity and costs equations
********************************************************************************
Equation
* Capacity equation
eqTechCap(tech, region, year)       Technology capacity
eqTechNewCap(tech, region, year)    Technology new capacity
eqTechEac(tech, region, year)       Technology Equivalent Annual Cost (EAC)
*eqTechRetirementCap(tech, region, year, year)
*eqTechRetrofitCap(tech, region, year, year)
*eqTechUpgradeCap(tech, region, year)
* Investment equation
eqTechInv(tech, region, year)       Technology investment costs
* Aggregated annual costs
eqTechOMCost(tech, region, year)    Technology O&M costs
;

* Capacity equation
eqTechCap(tech, region, year)$mTechSpan(tech, region, year)..
         vTechCap(tech, region, year)
         =e=
         pTechStock(tech, region, year) +
         sum(yearp$(mTechNew(tech, region, yearp) and ordYear(year) >= ordYear(yearp) and
                         (ordYear(year) < pTechOlife(tech, region) + ordYear(yearp) or mTechOlifeInf(tech, region))),
                 vTechNewCap(tech, region, yearp) -
                   sum(yeare$(mvTechRetiredCap(tech, region, yearp, yeare) and
                 ordYear(year) >= ordYear(yeare)), vTechRetiredCap(tech, region, yearp, yeare))
         );

eqTechNewCap(tech, region, year)$meqTechNewCap(tech, region, year)..
    sum(yearp$mvTechRetiredCap(tech, region, year, yearp),
                         vTechRetiredCap(tech, region, year, yearp)
         ) =l= vTechNewCap(tech, region, year);

* EAC equation
eqTechEac(tech, region, year)$mTechEac(tech, region, year)..
         vTechEac(tech, region, year)
         =e=
         sum(yearp$(mTechNew(tech, region, yearp) and ordYear(year) >= ordYear(yearp) and
                         (ordYear(year) < pTechOlife(tech, region) + ordYear(yearp) or mTechOlifeInf(tech, region))),
                  pTechEac(tech, region, yearp) * (
                   vTechNewCap(tech, region, yearp) -
                   sum(yeare$mvTechRetiredCap(tech, region, yearp, yeare),
                       vTechRetiredCap(tech, region, yearp, yeare)))
         )
         ;

*eqTechRetirementCap(tech, region, year, yearp)$(not(mTechRetirement(tech)) or
*  ordYear(yearp) < ordYear(year) or ordYear(yearp) >= ordYear(year) + pTechOlife(tech, region))..
*    vTechRetiredCap(tech, region, year, yearp) =e= 0;

*eqTechRetrofitCap(tech, region, year, yearp)$(ordYear(yearp) < ordYear(year) or ordYear(yearp) >= ordYear(year) + pTechOlife(tech, region))..
*    vTechRetrofitCap(tech, region, year, yearp) =e= 0;

*eqTechUpgradeCap(tech, region, year)..
*    sum((techp, yearp)$(mTechUpgrade(tech, techp)), vTechRetrofitCap(techp, region, yearp, year)) =e= vTechUpgradeCap(tech, region, year);

* Investment equation
eqTechInv(tech, region, year)$mTechNew(tech, region, year)..  vTechInv(tech, region, year) =e=
   pTechInvcost(tech, region, year) * vTechNewCap(tech, region, year);


* Annual O&M costs
eqTechOMCost(tech, region, year)$mTechOMCost(tech, region, year)..
         vTechOMCost(tech, region, year)
         =e=
         pTechFixom(tech, region, year) * vTechCap(tech, region, year) +
         sum(slice$mTechSlice(tech, slice),
                  pTechVarom(tech, region, year, slice) *
                  vTechAct(tech, region, year, slice) +
                  sum(comm$mTechInpComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechInp(tech, comm, region, year, slice)
                  )
                  +
                  sum(comm$mTechOutComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechOut(tech, comm, region, year, slice)
                  )
                  +
                  sum(comm$mvTechAOut(tech, comm, region, year, slice),
                          pTechAvarom(tech, comm, region, year, slice) *
                          vTechAOut(tech, comm, region, year, slice)
                  )
                  +
                  sum(comm$mvTechAInp(tech, comm, region, year, slice),
                          pTechAvarom(tech, comm, region, year, slice) *
                          vTechAInp(tech, comm, region, year, slice)
                  )
         );

**************************************
* Supply equations
**************************************
Equation
eqSupAvaUp(sup, comm, region, year, slice)  Supply availability upper bound
eqSupAvaLo(sup, comm, region, year, slice)  Supply availability lower bound
eqSupTotal(sup, comm, region)               Total supply of each commodity
eqSupReserveUp(sup, comm, region)           Total supply vs reserve check
eqSupReserveLo(sup, comm, region)           Total supply vs reserve check
eqSupCost(sup, region, year)                Total supply costs
;

eqSupAvaUp(sup, comm, region, year, slice)$mSupAvaUp(sup, comm, region, year, slice)..
         vSupOut(sup, comm, region, year, slice)
         =l=
         pSupAvaUp(sup, comm, region, year, slice) * paSupWeatherUp(sup, comm, region, year, slice);

eqSupAvaLo(sup, comm, region, year, slice)$meqSupAvaLo(sup, comm, region, year, slice)..
         vSupOut(sup, comm, region, year, slice)
         =g=
         pSupAvaLo(sup, comm, region, year, slice) * paSupWeatherLo(sup, comm, region, year, slice);

eqSupTotal(sup, comm, region)$mvSupReserve(sup, comm, region)..
         vSupReserve(sup, comm, region)
         =e=
         sum((year, slice)$mSupAva(sup, comm, region, year, slice),
             pPeriodLen(year) * vSupOut(sup, comm, region, year, slice)
         );

eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)..
         pSupReserveUp(sup, comm, region) =g= vSupReserve(sup, comm, region);

eqSupReserveLo(sup, comm, region)$meqSupReserveLo(sup, comm, region)..
         vSupReserve(sup, comm, region) =g= pSupReserveLo(sup, comm, region);


eqSupCost(sup, region, year)$mvSupCost(sup, region, year)..
         vSupCost(sup, region, year)
         =e=
         sum((comm, slice)$mSupAva(sup, comm, region, year, slice),
          pSupCost(sup, comm, region, year, slice) * vSupOut(sup, comm, region, year, slice));

**************************************
* Demand equation
**************************************
Equation
eqDemInp(comm, region, year, slice)  Demand equation
;

eqDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice)..
         vDemInp(comm, region, year, slice)  =e=
         sum(dem$mDemComm(dem, comm), pDemand(dem, comm, region, year, slice));

********************************************************************************
* Emission & Aggregating commodity equation
********************************************************************************
Equation
eqAggOut(comm, region, year, slice)            Aggregating commodity output
eqEmsFuelTot(comm, region, year, slice)         Emissions from commodity consumption (i.e. fuels combustion)
*eqTechEmsFuel(tech, comm, region, year, slice)  Emissions from commodity consumption by technologies
;

eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)..
         vAggOut(comm, region, year, slice)
         =e=
         sum(commp$mAggregateFactor(comm, commp),
                 pAggregateFactor(comm, commp) *  sum(slicep$(mvBalance(commp, region, year, slicep) and
                           mSliceParentChildE(slice, slicep) and mCommSlice(commp, slicep)),
                                    vOutTot(commp, region, year, slicep)
         ));



*eqTechEmsFuel(tech, comm, region, year, slice)$mTechEmsFuel(tech, comm, region, year, slice)..
*         vTechEmsFuel(tech, comm, region, year, slice)
*         =e=
*         sum(commp$(mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and
*                         pEmissionFactor(comm, commp) <> 0
*                 ),
*                   pTechEmisComm(tech, commp) * pEmissionFactor(comm, commp) *
*                   vTechInp(tech, commp, region, year, slice)
*         );



eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)..
     vEmsFuelTot(comm, region, year, slice)
         =e= sum(commp$(pEmissionFactor(comm, commp) > 0),
                 pEmissionFactor(comm, commp) *  sum(tech$mTechInpComm(tech, commp),
                         pTechEmisComm(tech, commp) * sum(slicep$mCommSliceOrParent(comm, slice, slicep),
                 vTechInp(tech, commp, region, year, slicep)$mTechEmsFuel(tech, comm, commp, region, year, slicep)
         )));


*eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)..
*     vEmsFuelTot(comm, region, year, slice)
*         =e= sum(commp$(pEmissionFactor(comm, commp) > 0),
*                 sum(slicep$mCommSliceOrParent(comm, slice, slicep),
*                         sum(tech$mTechEmsFuel(tech, comm, commp, region, year, slicep),
*                 pTechEmisComm(tech, commp) * pEmissionFactor(comm, commp) * vTechInp(tech, commp, region, year, slicep)
*         )));

********************************************************************************
* Storage equations
********************************************************************************
Equation
eqStorageStore(stg, comm, region, year, slice)  Storage equation
eqStorageAfLo(stg, comm, region, year, slice)   Storage availability factor lower
eqStorageAfUp(stg, comm, region, year, slice)   Storage availability factor upper
eqStorageClean(stg, comm, region, year, slice)  Storage input less Stote
eqStorageAInp(stg, comm, region, year, slice)
eqStorageAOut(stg, comm, region, year, slice)
eqStorageInpUp(stg, comm, region, year, slice)
eqStorageInpLo(stg, comm, region, year, slice)
eqStorageOutUp(stg, comm, region, year, slice)
eqStorageOutLo(stg, comm, region, year, slice)
;

eqStorageAInp(stg, comm, region, year, slice)$mvStorageAInp(stg, comm, region, year, slice)..
  vStorageAInp(stg, comm, region, year, slice) =e=
         sum(commp$mStorageComm(stg, commp),
         pStorageStg2AInp(stg, comm, region, year, slice) * vStorageStore(stg, commp, region, year, slice) +
         pStorageInp2AInp(stg, comm, region, year, slice) * vStorageInp(stg, commp, region, year, slice) +
         pStorageOut2AInp(stg, comm, region, year, slice) * vStorageOut(stg, commp, region, year, slice) +
         pStorageCap2AInp(stg, comm, region, year, slice) * vStorageCap(stg, region, year) +
         (pStorageNCap2AInp(stg, comm, region, year, slice) * vStorageNewCap(stg, region, year))$mStorageNew(stg, region, year)
);


eqStorageAOut(stg, comm, region, year, slice)$mvStorageAOut(stg, comm, region, year, slice)..
  vStorageAOut(stg, comm, region, year, slice) =e= sum(commp$mStorageComm(stg, commp),
         pStorageStg2AOut(stg, comm, region, year, slice) * vStorageStore(stg, commp, region, year, slice) +
         pStorageInp2AOut(stg, comm, region, year, slice) * vStorageInp(stg, commp, region, year, slice) +
         pStorageOut2AOut(stg, comm, region, year, slice) * vStorageOut(stg, commp, region, year, slice) +
         pStorageCap2AOut(stg, comm, region, year, slice) * vStorageCap(stg, region, year) +
         (pStorageNCap2AOut(stg, comm, region, year, slice) * vStorageNewCap(stg, region, year))$mStorageNew(stg, region, year)
);


eqStorageStore(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)..
  vStorageStore(stg, comm, region, year, slice) =e= pStorageCharge(stg, comm, region, year, slice) +
          (pStorageNCap2Stg(stg, comm, region, year, slice) * vStorageNewCap(stg, region, year))$mStorageNew(stg, region, year) +
          sum(slicep$(mCommSlice(comm, slicep) and ((not(mStorageFullYear(stg)) and mSliceNext(slicep, slice))
         or (mStorageFullYear(stg) and mSliceFYearNext(slicep, slice)))),
     pStorageInpEff(stg, comm, region, year, slicep) * vStorageInp(stg, comm, region, year, slicep)
    +     (pStorageStgEff(stg, comm, region, year, slice) ** pSliceShare(slice)) * vStorageStore(stg, comm, region, year, slicep)
   - vStorageOut(stg, comm, region, year, slicep) / pStorageOutEff(stg, comm, region, year, slicep));


eqStorageAfLo(stg, comm, region, year, slice)$meqStorageAfLo(stg, comm, region, year, slice)..
  vStorageStore(stg, comm, region, year, slice) =g= pStorageAfLo(stg, region, year, slice) *
     pStorageCap2stg(stg) * vStorageCap(stg, region, year) * paStorageWeatherAfLo(stg, comm, region, year, slice)
         ;

eqStorageAfUp(stg, comm, region, year, slice)$meqStorageAfUp(stg, comm, region, year, slice)..
  vStorageStore(stg, comm, region, year, slice) =l= pStorageAfUp(stg, region, year, slice) *
     pStorageCap2stg(stg) * vStorageCap(stg, region, year) * paStorageWeatherAfUp(stg, comm, region, year, slice);

eqStorageClean(stg, comm, region, year, slice)$mvStorageStore(stg, comm, region, year, slice)..
  vStorageOut(stg, comm, region, year, slice)  / pStorageOutEff(stg, comm, region, year, slice) =l=
                 vStorageStore(stg, comm, region, year, slice);



* Have to be simple
eqStorageInpUp(stg, comm, region, year, slice)$meqStorageInpUp(stg, comm, region, year, slice)..
  vStorageInp(stg, comm, region, year, slice) =l=
    pStorageCap2stg(stg) * vStorageCap(stg, region, year) *
         pStorageCinpUp(stg, comm, region, year, slice) * pSliceShare(slice) * paStorageWeatherCinpUp(stg, comm, region, year, slice);

eqStorageInpLo(stg, comm, region, year, slice)$meqStorageInpLo(stg, comm, region, year, slice)..
  vStorageInp(stg, comm, region, year, slice) =g=
    pStorageCap2stg(stg) * vStorageCap(stg, region, year) * pStorageCinpLo(stg, comm, region, year, slice) * pSliceShare(slice) *
         paStorageWeatherCinpLo(stg, comm, region, year, slice);

*
eqStorageOutUp(stg, comm, region, year, slice)$meqStorageOutUp(stg, comm, region, year, slice)..
  vStorageOut(stg, comm, region, year, slice) =l=
    pStorageCap2stg(stg) * vStorageCap(stg, region, year) * pStorageCoutUp(stg, comm, region, year, slice) * pSliceShare(slice) *
         paStorageWeatherCoutUp(stg, comm, region, year, slice);

eqStorageOutLo(stg, comm, region, year, slice)$meqStorageOutLo(stg, comm, region, year, slice)..
  vStorageOut(stg, comm, region, year, slice)  =g=
    pStorageCap2stg(stg) * vStorageCap(stg, region, year) * pStorageCoutLo(stg, comm, region, year, slice) * pSliceShare(slice) *
         paStorageWeatherCoutLo(stg, comm, region, year, slice);


********************************************************************************
* Capacity and costs equations for storage
********************************************************************************
Equation
* Capacity equation
eqStorageCap(stg, region, year)     Storage capacity
* Investition equation
eqStorageInv(stg, region, year)     Storage investments
eqStorageEac(stg, region, year)
* Aggregated annual costs
eqStorageCost(stg, region, year)  Storage total costs
* Constrain capacity
;

* Capacity equation
eqStorageCap(stg, region, year)$mStorageSpan(stg, region, year)..
         vStorageCap(stg, region, year)
         =e=
         pStorageStock(stg, region, year) +
         sum(yearp$
                 (
                         ordYear(year) >= ordYear(yearp) and
                         (mStorageOlifeInf(stg, region) or ordYear(year) < pStorageOlife(stg, region) + ordYear(yearp)) and
                         mStorageNew(stg, region, yearp)
                 ),
                 vStorageNewCap(stg, region, yearp)
         );

* Investition equation
eqStorageInv(stg, region, year)$mStorageNew(stg, region, year)..
         vStorageInv(stg, region, year)
         =e=
         pStorageInvcost(stg, region, year) *
         vStorageNewCap(stg, region, year);

* EAC equation
eqStorageEac(stg, region, year)$mStorageEac(stg, region, year)..
         vStorageEac(stg, region, year)
         =e=
         sum((yearp)$
                 (       mStorageNew(stg, region, yearp) and ordYear(year) >= ordYear(yearp) and
                         (mStorageOlifeInf(stg, region) or ordYear(year) < pStorageOlife(stg, region) + ordYear(yearp)) and pStorageInvcost(stg, region, yearp) <> 0
                 ),
                  pStorageEac(stg, region, yearp) * vStorageNewCap(stg, region, yearp)
         );


* FIX O & M
eqStorageCost(stg, region, year)$mStorageOMCost(stg, region, year)..
         vStorageOMCost(stg, region, year)
         =e=
         pStorageFixom(stg, region, year) * vStorageCap(stg, region, year) +
         sum(comm$mStorageComm(stg, comm),
         sum(slice$mCommSlice(comm, slice),
             pStorageCostInp(stg, region, year, slice) * vStorageInp(stg, comm, region, year, slice)
             + pStorageCostOut(stg, region, year, slice) * vStorageOut(stg, comm, region, year, slice)
             + pStorageCostStore(stg, region, year, slice) * vStorageStore(stg, comm, region, year, slice)
         ));



********************************************************************************
* Interregional and ROW Trade equations
********************************************************************************
equation
eqImport(comm, region, year, slice)     Import equation
eqExport(comm, region, year, slice)     Export equation
eqTradeFlowUp(trade, comm, region, region, year, slice)   Trade upper bound
eqTradeFlowLo(trade, comm, region, region, year, slice)   Trade lower bound
*eqCostTrade(region, year, slice)
eqCostTrade(region, year)       Total trade costs
eqCostRowTrade(region, year)    Costs of trade with the Rest of the World (ROW)
eqCostIrTrade(region, year)     Costs of import
eqExportRowUp(expp, comm, region, year, slice)    Export to ROW upper bound
eqExportRowLo(expp, comm, region, year, slice)    Export to ROW lower bound
eqExportRowCumulative(expp, comm)                 Cumulative export to ROW
eqExportRowResUp(expp, comm)                      Accumulated export to ROW upper bound
eqImportRowUp(imp, comm, region, year, slice)     Import from ROW upper bound
eqImportRowLo(imp, comm, region, year, slice)     Import of ROW lower bound
eqImportRowAccumulated(imp, comm)                 Accumulated import from ROW
eqImportRowResUp(imp, comm)                       Accumulated import from ROW upper bound
eqTradeCap(trade, year)
eqTradeInv(trade, region, year)
eqTradeEac(trade, region, year)
eqTradeCapFlow(trade, comm, year, slice)
;



eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)..
  vImport(comm, dst, year, slice) =e=
    sum(slicep$mImportIrSubSlice(comm, dst, year, slice, slicep),
        sum(trade$mImportIrSubSliceTrd(trade, comm, dst, year, slice, slicep),
             sum(src$mTradeRoutes(trade, src, dst),
               (pTradeIrEff(trade, src, dst, year, slicep) * vTradeIr(trade, comm, src, dst, year, slicep))$mvTradeIr(trade, comm, src, dst, year, slicep)
         )))$mImportIrSub(comm, dst, year, slice)
         +  sum(slicep$mImportRowSubSlice(comm, dst, year, slice, slicep),
                 sum(imp$mImpComm(imp, comm), vImportRow(imp, comm, dst, year, slicep)$mImportRow(imp, comm, dst, year, slicep)))$mImportRowSub(comm, dst, year, slice);

eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)..
  vExport(comm, src, year, slice) =e=
   sum(slicep$mExportIrSubSlice(comm, src, year, slice, slicep),
         sum(trade$mExportIrSubSliceTrd(trade, comm, src, year, slice, slicep), sum(dst$mTradeRoutes(trade, src, dst),
                 vTradeIr(trade, comm, src, dst, year, slicep)$mvTradeIr(trade, comm, src, dst, year, slicep))))$mExportIrSub(comm, src, year, slice)
    + sum(slicep$mExportRowSubSlice(comm, src, year, slice, slicep),
        sum(expp$mExpComm(expp, comm), vExportRow(expp, comm, src, year, slicep)$mExportRow(expp, comm, src, year, slicep)))$mExportRowSub(comm, src, year, slice);


eqTradeFlowUp(trade, comm, src, dst, year, slice)$meqTradeFlowUp(trade, comm, src, dst, year, slice)..
      vTradeIr(trade, comm, src, dst, year, slice) =l= pTradeIrUp(trade, src, dst, year, slice);

eqTradeFlowLo(trade, comm, src, dst, year, slice)$meqTradeFlowLo(trade, comm, src, dst, year, slice)..
      vTradeIr(trade, comm, src, dst, year, slice) =g= pTradeIrLo(trade, src, dst, year, slice);

eqCostTrade(region, year)$mvTradeCost(region, year)..
  vTradeCost(region, year) =e= vTradeRowCost(region, year)$mvTradeRowCost(region, year) + vTradeIrCost(region, year)$mvTradeIrCost(region, year);

eqCostRowTrade(region, year)$mvTradeRowCost(region, year).. vTradeRowCost(region, year) =e=
* Row
  sum((imp, comm, slice)$mImportRow(imp, comm, region, year, slice), pImportRowPrice(imp, region, year, slice) *
     vImportRow(imp, comm, region, year, slice)) -
  sum((expp, comm, slice)$mExportRow(expp, comm, region, year, slice), pExportRowPrice(expp, region, year, slice) *
      vExportRow(expp, comm, region, year, slice));

eqCostIrTrade(region, year)$mvTradeIrCost(region, year).. vTradeIrCost(region, year) =e=
* Eac
  sum(trade$mTradeEac(trade, region, year), vTradeEac(trade, region, year)) +
* Import
  sum((trade, src)$mTradeRoutes(trade, src, region), sum(comm$mTradeComm(trade, comm), sum(slice$mTradeSlice(trade, slice),
         (((pTradeIrCost(trade, src, region, year, slice) + pTradeIrMarkup(trade, src, region, year, slice)) *
        vTradeIr(trade, comm, src, region, year, slice)))$mvTradeIr(trade, comm, src, region, year, slice)
  )))
* Export
  -sum((trade, dst)$mTradeRoutes(trade, region, dst), sum(comm$mTradeComm(trade, comm), sum(slice$mTradeSlice(trade, slice),
         ((pTradeIrMarkup(trade, region, dst, year, slice) * vTradeIr(trade, comm, region, dst, year, slice)))$mvTradeIr(trade, comm, region, dst, year, slice)
  )));


eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)..
  vExportRow(expp, comm, region, year, slice)  =l= pExportRowUp(expp, region, year, slice);

eqExportRowLo(expp, comm, region, year, slice)$meqExportRowLo(expp, comm, region, year, slice)..
  vExportRow(expp, comm, region, year, slice)  =g= pExportRowLo(expp, region, year, slice);

eqExportRowCumulative(expp, comm)$mExpComm(expp, comm).. vExportRowAccumulated(expp, comm) =e=
    sum((region, year, slice)$mExportRow(expp, comm, region, year, slice),
        pPeriodLen(year) * vExportRow(expp, comm, region, year, slice)
);

eqExportRowResUp(expp, comm)$mExportRowAccumulatedUp(expp, comm)..
                 vExportRowAccumulated(expp, comm) =l= pExportRowRes(expp);

eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)..
  vImportRow(imp, comm, region, year, slice)  =l= pImportRowUp(imp, region, year, slice);

eqImportRowLo(imp, comm, region, year, slice)$meqImportRowLo(imp, comm, region, year, slice)..
  vImportRow(imp, comm, region, year, slice)  =g= pImportRowLo(imp, region, year, slice);

eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm).. vImportRowAccumulated(imp, comm) =e=
    sum((region, year, slice)$mImportRow(imp, comm, region, year, slice),
         pPeriodLen(year) * vImportRow(imp, comm, region, year, slice)
);

eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm).. vImportRowAccumulated(imp, comm) =l= pImportRowRes(imp);


********************************************************************************
* Trade IR capacity equations
********************************************************************************

* Capacity equation
eqTradeCapFlow(trade, comm, year, slice)$meqTradeCapFlow(trade, comm, year, slice)..
         pSliceShare(slice) * pTradeCap2Act(trade) * vTradeCap(trade, year) =g=
                 sum((src, dst)$mvTradeIr(trade, comm, src, dst, year, slice), vTradeIr(trade, comm, src, dst, year, slice));

* Capacity equation
eqTradeCap(trade, year)$mTradeSpan(trade, year)..
         vTradeCap(trade, year)
         =e=
         pTradeStock(trade, year) +
         sum(yearp$(mTradeNew(trade, yearp) and  ordYear(year) >= ordYear(yearp) and
            (ordYear(year) < pTradeOlife(trade) + ordYear(yearp) or mTradeOlifeInf(trade))), vTradeNewCap(trade, yearp));

* Investment equation
eqTradeInv(trade, region, year)$mTradeInv(trade, region, year)..
         vTradeInv(trade, region, year) =e=
                 pTradeInvcost(trade, region, year) * vTradeNewCap(trade, year);

* EAC equation
eqTradeEac(trade, region, year)$mTradeEac(trade, region, year)..
         vTradeEac(trade, region, year)
         =e=
         sum(yearp$(mTradeNew(trade, yearp) and  ordYear(year) >= ordYear(yearp) and
            (ordYear(year) < pTradeOlife(trade) + ordYear(yearp) or mTradeOlifeInf(trade))),
                pTradeEac(trade, region, yearp) * vTradeNewCap(trade, yearp));

********************************************************************************
* Auxiliary input & output equations
********************************************************************************
equation
eqTradeIrAInp(trade, comm, region, year, slice) Trade auxiliary commodity input
eqTradeIrAOut(trade, comm, region, year, slice) Trade auxiliary commodity output
eqTradeIrAInpTot(comm, region, year, slice) Trade auxiliary commodity input
eqTradeIrAOutTot(comm, region, year, slice) Trade auxiliary commodity output
;

* ((sum(dst$(mTradeIr(trade, region, dst, year, slice) and sum(comm$pTradeIrCdst2Ainp(trade, comm, region, dst, year, slice), 1) <> 0), 1) <> 0) or
*  (sum(src$(mTradeIr(trade, src, region, year, slice) and sum(comm$pTradeIrCsrc2Ainp(trade, comm, src, region, year, slice), 1) <> 0), 1) <> 0))


eqTradeIrAInp(trade, comm, region, year, slice)$mvTradeIrAInp(trade, comm, region, year, slice)..
  vTradeIrAInp(trade, comm, region, year, slice) =e=
    sum(dst$mTradeIr(trade, region, dst, year, slice),
      pTradeIrCsrc2Ainp(trade, comm, region, dst, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, region, dst, year, slice)))
    + sum(src$mTradeIr(trade, src, region, year, slice),
      pTradeIrCdst2Ainp(trade, comm, src, region, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, src, region, year, slice)));

eqTradeIrAOut(trade, comm, region, year, slice)$mvTradeIrAOut(trade, comm, region, year, slice)..
  vTradeIrAOut(trade, comm, region, year, slice) =e=
    sum(dst$mTradeIr(trade, region, dst, year, slice),
      pTradeIrCsrc2Aout(trade, comm, region, dst, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, region, dst, year, slice)))
    + sum(src$mTradeIr(trade, src, region, year, slice),
      pTradeIrCdst2Aout(trade, comm, src, region, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, src, region, year, slice)));

eqTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice)..
  vTradeIrAInpTot(comm, region, year, slice) =e=
   sum((trade, slicep)$(mCommSliceOrParent(comm, slice, slicep) and mvTradeIrAInp(trade, comm, region, year, slicep)),
                 vTradeIrAInp(trade, comm, region, year, slicep));

eqTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice)..
  vTradeIrAOutTot(comm, region, year, slice) =e=

   sum((trade, slicep)$(mCommSliceOrParent(comm, slice, slicep) and mvTradeIrAOut(trade, comm, region, year, slicep)),
         vTradeIrAOut(trade, comm, region, year, slicep));



********************************************************************************
* Balance equations & dummy import & export
********************************************************************************
Equation
eqBalUp(comm, region, year, slice)   PRODUCTION <= CONSUMPTION commodity balance
eqBalLo(comm, region, year, slice)   PRODUCTION >= CONSUMPTION commodity balance
eqBalFx(comm, region, year, slice)   PRODUCTION = CONSUMPTION commodity balance
eqBal(comm, region, year, slice)     Commodity balance
eqOutTot(comm, region, year, slice)     Total commodity output
eqInpTot(comm, region, year, slice)     Total commodity input
eqInp2Lo(comm, region, year, slice)           From coomodity slice to lo level
eqOut2Lo(comm, region, year, slice)           From coomodity slice to lo level
eqSupOutTot(comm, region, year, slice)      Supply total output
eqTechInpTot(comm, region, year, slice)     Technology total input
eqTechOutTot(comm, region, year, slice)     Technology total output
eqStorageInpTot(comm, region, year, slice)  Storage total input
eqStorageOutTot(comm, region, year, slice)  Storage total output
;

eqBalLo(comm, region, year, slice)$meqBalLo(comm, region, year, slice)..
         vBalance(comm, region, year, slice) =g= 0;

eqBalUp(comm, region, year, slice)$meqBalUp(comm, region, year, slice)..
         vBalance(comm, region, year, slice) =l= 0;

eqBalFx(comm, region, year, slice)$meqBalFx(comm, region, year, slice)..
         vBalance(comm, region, year, slice) =e= 0;

eqBal(comm, region, year, slice)$mvBalance(comm, region, year, slice)..
         vBalance(comm, region, year, slice) =e= vOutTot(comm, region, year, slice) - vInpTot(comm, region, year, slice);

eqOutTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)..
         vOutTot(comm, region, year, slice)
         =e=
         vDummyImport(comm, region, year, slice)$mDummyImport(comm, region, year, slice) +
                  vSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice) +
                  vEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice) +
                  vAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice) +
                  vTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)  +
                  vStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice) +
                  vImport(comm, region, year, slice)$mImport(comm, region, year, slice) +
                  vTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice) +
         sum(slicep$(mSliceParentChild(slicep, slice) and mvOut2Lo(comm, region, year, slicep, slice)),
                 vOut2Lo(comm, region, year, slicep, slice))$mOutSub(comm, region, year, slice);

eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)..
         sum(slicep$mvOut2Lo(comm, region, year, slice, slicep), vOut2Lo(comm, region, year, slice, slicep))
         =e=
                  vSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice) +
                  vEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice) +
                  vAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice) +
                  vTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)  +
                  vStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice) +
                  vImport(comm, region, year, slice)$mImport(comm, region, year, slice) +
                  vTradeIrAOutTot(comm, region, year, slice)$mvTradeIrAOutTot(comm, region, year, slice);

eqInpTot(comm, region, year, slice)$mvBalance(comm, region, year, slice)..
         vInpTot(comm, region, year, slice)
         =e=
         vDemInp(comm, region, year, slice)$mvDemInp(comm, region, year, slice) +
         vDummyExport(comm, region, year, slice)$mDummyExport(comm, region, year, slice) +
         vTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice) +
         vStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice) +
         vExport(comm, region, year, slice)$mExport(comm, region, year, slice) +
         vTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice) +
         sum(slicep$(mSliceParentChild(slicep, slice) and mvInp2Lo(comm, region, year, slicep, slice)),
                 vInp2Lo(comm, region, year, slicep, slice))$mInpSub(comm, region, year, slice);

eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)..
        sum(slicep$mvInp2Lo(comm, region, year, slice, slicep), vInp2Lo(comm, region, year, slice, slicep))
         =e=
                  vTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice) +
                  vStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice) +
                  vExport(comm, region, year, slice)$mExport(comm, region, year, slice) +
                  vTradeIrAInpTot(comm, region, year, slice)$mvTradeIrAInpTot(comm, region, year, slice);

eqSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, year, slice)..
         vSupOutTot(comm, region, year, slice) =e=
         sum(sup$mSupComm(sup, comm), sum(slicep$mSupAva(sup, comm, region, year, slicep),
                 vSupOut(sup, comm, region, year, slicep)));

eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)..
         vTechInpTot(comm, region, year, slice)
         =e=
         sum(tech$mTechInpComm(tech, comm), sum(slicep$(mTechSlice(tech, slicep) and mCommSliceOrParent(comm, slice, slicep)),
                         vTechInp(tech, comm, region, year, slicep)$mvTechInp(tech, comm, region, year, slicep)
                  ))
         +
         sum(tech$mTechAInp(tech, comm), sum(slicep$(mTechSlice(tech, slicep) and mCommSliceOrParent(comm, slice, slicep)),
                         vTechAInp(tech, comm, region, year, slicep)$mvTechAInp(tech, comm, region, year, slicep)));


eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)..
         vTechOutTot(comm, region, year, slice)
         =e=
         sum(tech$mTechOutComm(tech, comm), sum(slicep$(mTechSlice(tech, slicep) and mCommSliceOrParent(comm, slice, slicep)),
                         vTechOut(tech, comm, region, year, slicep)$mvTechOut(tech, comm, region, year, slicep)
                  ))
         +
         sum(tech$mTechAOut(tech, comm), sum(slicep$(mTechSlice(tech, slicep) and mCommSliceOrParent(comm, slice, slicep)),
                         vTechAOut(tech, comm, region, year, slicep)$mvTechAOut(tech, comm, region, year, slicep)));

eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)..
         vStorageInpTot(comm, region, year, slice)
         =e=
         sum(stg$mvStorageStore(stg, comm, region, year, slice),
                 vStorageInp(stg, comm, region, year, slice)
         ) +
         sum(stg$mvStorageAInp(stg, comm, region, year, slice),
                  vStorageAInp(stg, comm, region, year, slice)
         );

eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)..
         vStorageOutTot(comm, region, year, slice)
         =e=
          sum(stg$mvStorageStore(stg, comm, region, year, slice),
                 vStorageOut(stg, comm, region, year, slice)
         ) +
         sum(stg$mvStorageAOut(stg, comm, region, year, slice),
                  vStorageAOut(stg, comm, region, year, slice)
         );


**************************************
* Objective and aggregated costs equations
**************************************
Equation
eqCost(region, year)                Total costs
eqTaxCost(comm, region, year)       Commodity taxes
eqSubsCost(comm, region, year)      Commodity subsidy
*eqDummyCost(comm, region, year)     Dummy import and export costs
eqObjective                         Objective equation
;

*eqDummyCost(comm, region, year)$(mMidMilestone(year) and  mDummyCost(comm, region, year))..
*         vDummyCost(comm, region, year)
*         =e=
*         sum(slice$mDummyImport(comm, region, year, slice),
*           pDummyImportCost(comm, region, year, slice) * vDummyImport(comm, region, year, slice)) +
*         sum(slice$mDummyExport(comm, region, year, slice),
*           pDummyExportCost(comm, region, year, slice) * vDummyExport(comm, region, year, slice));

eqCost(region, year)$mvTotalCost(region, year)..
         vTotalCost(region, year)
         =e=
         sum(tech$mTechEac(tech, region, year), vTechEac(tech, region, year))
         + sum(tech$mTechOMCost(tech, region, year), vTechOMCost(tech, region, year))
         + sum(sup$mvSupCost(sup, region, year), vSupCost(sup, region, year))
*        + sum(comm$mDummyCost(comm, region, year), vDummyCost(comm, region, year))
         + sum((comm, slice)$mDummyImport(comm, region, year, slice),
                    pDummyImportCost(comm, region, year, slice) * vDummyImport(comm, region, year, slice))
         + sum((comm, slice)$mDummyExport(comm, region, year, slice),
                   pDummyExportCost(comm, region, year, slice) * vDummyExport(comm, region, year, slice))
         + sum(comm$mTaxCost(comm, region, year), vTaxCost(comm, region, year))
         - sum(comm$mSubsCost(comm, region, year), vSubsCost(comm, region, year))
         + sum(stg$mStorageOMCost(stg, region, year), vStorageOMCost(stg, region, year))
         + sum(stg$mStorageEac(stg, region, year), vStorageEac(stg, region, year))
         + vTradeCost(region, year)$mvTradeCost(region, year);


eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)..
         vTaxCost(comm, region, year)
         =e= sum(slice$mCommSlice(comm, slice), pTaxCost(comm, region, year, slice) * vOutTot(comm, region, year, slice));

eqSubsCost(comm, region, year)$mSubsCost(comm, region, year)..
         vSubsCost(comm, region, year)
         =e= sum(slice$mCommSlice(comm, slice), pSubsCost(comm, region, year, slice) * vOutTot(comm, region, year, slice));

eqObjective..
   vObjective =e=
         sum((region, year)$mvTotalCost(region, year),
           vTotalCost(region, year) * pDiscountFactorMileStone(region, year));

* Latex file end
*\end{document}
* 39aa2518-d4e0-44a6-a7c7-a44fb70f9a1e

* ------------------------------------------------------------------------------
* Standart constrain: end
* ------------------------------------------------------------------------------
**************************************
* LEC set & parameter & variable
**************************************
set
mLECRegion(region)
;

parameter
pLECLoACT(region)
;

**************************************
* LEC equation
**************************************
Equation
eqLECActivity(tech, region, year)
;

eqLECActivity(tech, region, year)$meqLECActivity(tech, region, year)..
         sum(slice$mTechSlice(tech, slice), vTechAct(tech, region, year, slice)) =g= pLECLoACT(region);

*$INCLUDE data.inc
* e0fc7d1e-fd81-4745-a0eb-2a142f837d1c

$ontext
model energyRt /
********************************************************************************
* Activity Input & Output equations
********************************************************************************
* Equation Input fix activity & Output fix no activity
eqTechSng2Sng
eqTechGrp2Sng
eqTechSng2Grp
eqTechGrp2Grp
********************************************************************************
* Share equations
********************************************************************************
* Input Share LO equation
eqTechShareInpLo
* Input Share UP equation
eqTechShareInpUp
* Output Share LO equation
eqTechShareOutLo
* Output Share UP equation
eqTechShareOutUp
********************************************************************************
* Aux input & output equations
********************************************************************************
eqTechAInp
eqTechAOut
********************************************************************************
* Availability factor equations
********************************************************************************
* Availability factor LO
eqTechAfLo
* Availability factor UP
eqTechAfUp
* Availability factor for sum Lo
eqTechAfsLo
* Availability factor for sum UP
eqTechAfsUp
********************************************************************************
* Connect activity with output equations
********************************************************************************
* Connect activity with output
eqTechActSng
eqTechActGrp
********************************************************************************
* Availability commodity factor equations
********************************************************************************
* Availability commodity factor LO output equations
eqTechAfcOutLo
* Availability commodity factor UP output equations
eqTechAfcOutUp
* Availability commodity factor LO input equations
eqTechAfcInpLo
* Availability commodity factor UP input equations
eqTechAfcInpUp
********************************************************************************
* Capacity and costs equations
********************************************************************************
* Capacity equation
eqTechCap
eqTechNewCap
*eqTechRetirementCap
*eqTechRetrofitCap
*eqTechUpgradeCap
* Investition equation
eqTechInv
eqTechEac
* FIX O & M equation
* Commodity Varom O & M and Varom O & M aggregate by year equation
* Aggregated annual costs
eqTechOMCost
* Disable new capacity
*eqTechNewCapDisable
**************************************
* Supply equation
**************************************
eqSupAvaUp
eqSupAvaLo
eqSupReserveUp
eqSupReserveLo
eqSupTotal
eqSupCost
**************************************
* Demand equation
**************************************
eqDemInp
**************************************
* Emission & Aggregate equation
**************************************
eqAggOut
eqEmsFuelTot
*eqTechEmsFuel
********************************************************************************
* Store equations for reserve
********************************************************************************
eqStorageStore
********************************************************************************
* Capacity and costs equations for reserve
********************************************************************************
* Capacity equation
eqStorageCap
* Investition equation
eqStorageInv
eqStorageEac
* Salvage value
* Constrain capacity
eqStorageCost
eqStorageAfLo
eqStorageAfUp
eqStorageClean
eqStorageInpUp
eqStorageInpLo
eqStorageOutUp
eqStorageOutLo
eqStorageAInp
eqStorageAOut
**************************************
* Trade and Row equation
**************************************
eqImport
eqExport
eqTradeFlowUp
eqTradeFlowLo
eqCostTrade
eqTradeIrAInp
eqTradeIrAInpTot
eqTradeIrAOut
eqTradeIrAOutTot
eqCostRowTrade
eqCostIrTrade
eqExportRowUp
eqExportRowLo
eqExportRowCumulative
eqExportRowResUp
eqImportRowUp
eqImportRowLo
eqImportRowAccumulated
eqImportRowResUp
eqTradeCap
eqTradeCapFlow
eqTradeInv
eqTradeEac
**************************************
* Ballance equation & dummy
**************************************
eqBalUp
eqBalLo
eqBalFx
eqBal
eqOutTot
eqOut2Lo
eqInpTot
eqInp2Lo
eqSupOutTot
eqTechInpTot
eqTechOutTot
eqStorageInpTot
eqStorageOutTot
**************************************
* Costs' equations
**************************************
*eqDummyCost
eqCost
eqObjective
* Tax
eqTaxCost
* Subs
eqSubsCost
* c4524d56-feab-4fcb-9500-5f5bad8f694d
**************************************
* Fix to previous value
**************************************
* 542b24cb-368e-4635-b52e-00c791d5a3b3
**************************************
* LEC equation
**************************************
eqLECActivity
* Additional equation (e.g. Constrain)
* c7a5e905-1d09-4a38-bf1a-b1ac1551ba4f
/;
$offtext
$include inc_constraints.gms

model energyRt / all / ;

*$EXIT

put log_stat;
put '"load data",,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;

$include data.gms

* ddd355e0-0023-45e9-b0d3-1ad83ba74b3a
*$EXIT


$include inc3.gms

put log_stat;
put '"solver",,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;

$include inc_solver.gms
*option lp = cplex;

Solve energyRt minimizing vObjective using LP;

put log_stat;
put '"solution status",' energyRt.Modelstat:0:0 ',"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;
put '"export results",,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0'"'/;

$include inc4.gms

$include output.gms

$include inc5.gms


put log_stat;
put 'done,,"' GYear(JNow):0:0 "-" GMonth(JNow):0:0 "-" GDay(JNow):0:0 " " GHour(JNow):0:0 ":" GMinute(JNow):0:0 ":" GSecond(JNow):0:0 '"'/;
putclose;
