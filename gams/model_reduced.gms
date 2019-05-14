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

OPTION RESLIM=50000, PROFILE=0, SOLVEOPT=REPLACE;
OPTION ITERLIM=999999, LIMROW=0, LIMCOL=0, SOLPRINT=OFF;
*OPTION RESLIM=50000, PROFILE=1, SOLVEOPT=REPLACE;
*OPTION ITERLIM=999999, LIMROW=10000, LIMCOL=10000, SOLPRINT=ON;
file pFinish1_csv / 'pFinish.csv'/;
pFinish1_csv.lp = 1;
put pFinish1_csv;
put "value"/;
put 1:0:9/;
putclose;

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
expp   export to the rest of the world
imp    import to rest of the world
trade  trade between regons
group  group of input or output commodities in technologies
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
mMilestoneLast(year)           Last period milestone
mMilestoneNext(year, year)     Next period milestone
mMilestoneHasNext(year)        Is there next period milestone
mStartMilestone(year, year)    Start of the period
mEndMilestone(year, year)      Milestone year of the period
mMidMilestone(year)            End of the period
mCommSlice(comm, slice)        Commodity to slice
mTechRetirement(tech)          Early retirement option
mTechUpgrade(tech, tech)       Upgrade by this technology possible for techp
mTechInpComm(tech, comm)       Input commodity
mTechOutComm(tech, comm)       Output commodity
mTechInpGroup(tech, group)     Group input
mTechOutGroup(tech, group)     Group output
mTechOneComm(tech, comm)       Commodity without group
*
mTechGroupComm(tech, group, comm)  Mapping between commodity-groups and commodities
* Aux input comm map
mTechAInp(tech, comm)            Auxiliary input commodity
* Aux output comm map
mTechAOut(tech, comm)            Auxiliary output commodity
*
mTechNew(tech, region, year)     Technologies available for investment
mTechSpan(tech, region, year)    Availability of each technology by regions and milestone years
mTechSlice(tech, slice)          Technology - slice
* Supply
mSupSlice(sup, slice)             Supply by time slices
mSupComm(sup, comm)               Supplied commodities
mSupSpan(sup, region)             Supply techs by regions
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
mStorageSlice(stg, slice)          Storage work in slice
mStorageComm(stg, comm)            Mapping of storage technology and respective commodity
mStorageAInp(stg, comm)
mStorageAOut(stg, comm)
mStorageNew(stg, region, year)     Storage available for investment
mStorageSpan(stg, region, year)    Storage set showing if the storage may exist in the time-span and region
mSliceNext(slice, slice)                          Next slice
* Trade and ROW
mTradeSlice(trade, slice)          Trade work in slice
mTradeComm(trade, comm)            Mapping of trade commodities
mTradeSrc(trade, region)           Mapping of trade source region
mTradeDst(trade, region)           Mapping of trade destination region
mTradeIrAInp(trade, comm)          Auxiliary  input commodity in source
mTradeIrAOut(trade, comm)          Auxiliary output commodity in source
mTradeIrCdstAInp(trade, comm)      Auxiliary  input commodity in destination
mTradeIrCdstAOut(trade, comm)      Auxiliary output commodity in destination
mExpComm(expp, comm)               Mapping of export commodities
mImpComm(imp, comm)                Mapping for import commodities
mExpSlice(expp, slice)             Exp work in slice
mImpSlice(imp, slice)              Imp work in slice
* Zero discount
mDiscountZero(region)                     Auxiliary mapping mapping for  regions with zero discount
mAllSliceParentChildAndSame(slice, slice) Child slice or the same
mAllSliceParentChild(slice, slice)        Child slice not the same
*
mTechWeatherAf(tech, weather)
mTechWeatherAfs(tech, weather)
mTechWeatherAfc(tech, weather, comm)
*
mStorageWeatherAf(stg, weather)
mStorageWeatherCinp(stg, weather)
mStorageWeatherCout(stg, weather)
;

* Set priority
* t, sup, g, c, r, y, s
* tech, sup, group, comm, region, year, slice
* Parameter
parameter
ordYear(year)           ord year for GLPK
cardYear(year)          card year for GLPK
pPeriodLen(year)        milestone len for sum
pSliceShare(slice)      Slice share
* Aggregate
pAggregateFactor(comm, comm)                       Aggragation factor of commodities
* Technology parameter
pTechOlife(tech, region)                           Operational life of technologies
pTechCinp2ginp(tech, comm, region, year, slice)    Multiplying factor for a commodity input to obtain group input
pTechGinp2use(tech, group, region, year, slice)    Multiplying factor for a group input commodity to obtain use
pTechCinp2use(tech, comm, region, year, slice)     Multiplying factor for a commodity input commodity to obtain use
pTechUse2cact(tech, comm, region, year, slice)     Multiplying factor for use to obtain commodity activity
pTechCact2cout(tech, comm, region, year, slice)    Multiplying factor for commodity activity use to obtain commodity output
pTechEmisComm(tech, comm)                          Combustion factor for input commodity (from 0 to 1)
* Auxiliary input commodities
pTechUse2AInp(tech, comm, region, year, slice)     Multiplying factor for use to obtain aux-commodity input
pTechAct2AInp(tech, comm, region, year, slice)     Multiplying factor for activity to obtain aux-commodity input
pTechCap2AInp(tech, comm, region, year, slice)     Multiplying factor for capacity to obtain aux-commodity input
pTechNCap2AInp(tech, comm, region, year, slice)     Multiplying factor for new capacity to obtain aux-commodity input
pTechCinp2AInp(tech, comm, comm, region, year, slice)    Multiplying factor for commodity-input to obtain aux-commodity input
pTechCout2AInp(tech, comm, comm, region, year, slice)    Multiplying factor for commodity-output to obtain aux-commodity input
* Aux output comm map
pTechUse2AOut(tech, comm, region, year, slice)     Multiplying factor for use to obtain aux-commodity output
pTechAct2AOut(tech, comm, region, year, slice)     Multiplying factor for activity to obtain aux-commodity output
pTechCap2AOut(tech, comm, region, year, slice)     Multiplying factor for capacity to obtain aux-commodity output
pTechNCap2AOut(tech, comm, region, year, slice)     Multiplying factor for new capacity to obtain aux-commodity output
pTechCinp2AOut(tech, comm, comm, region, year, slice)     Multiplying factor for commodity to obtain aux-commodity output
pTechCout2AOut(tech, comm, comm, region, year, slice)     Multiplying factor for commodity-output to obtain aux-commodity input
*
pTechFixom(tech, region, year)                      Fixed Operating and maintenance (O&M) costs (per unit of capacity)
pTechVarom(tech, region, year, slice)               Variable  O&M costs (per unit of acticity)
pTechInvcost(tech, region, year)                    Investment costs (per unit of capacity)
pTechShareLo(tech, comm, region, year, slice)       Lower bound for share of the commodity in total group input or output
pTechShareUp(tech, comm, region, year, slice)       Upper bound for share of the commodity in total group input or output
pTechAfLo(tech, region, year, slice)                Lower bound for activity
pTechAfUp(tech, region, year, slice)                Upper bound for activity
pTechAfsLo(tech, region, year, slice)               Lower bound for activity by sum
pTechAfsUp(tech, region, year, slice)               Upper bound for activity by sum
pTechAfcLo(tech, comm, region, year, slice)         Lower bound for commodity output
pTechAfcUp(tech, comm, region, year, slice)         Upper bound for commodity output
pTechStock(tech, region, year)                      Technology capacity stock (accumulated in previous years production capacities)
pTechCap2act(tech)                                  Technology capacity units to activity units conversion factor
pTechCvarom(tech, comm, region, year, slice)        Commodity-specific variable costs (per unit of the commodity input or output)
pTechAvarom(tech, comm, region, year, slice)        Auxilary Commodity-specific variable costs (per unit of the commodity input or output)
* Exit stock and salvage
pDiscount(region, year)                             Discount rate (can be region and year specific)
pDiscountFactor(region, year)                       Discount factor (cumulative)
* Supply
pSupCost(sup, comm, region, year, slice)            Costs of supply
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
pWeather(weather, region, year, slice)              Weather
pSupWeatherLo(sup, weather)                         Weather multiplier
pSupWeatherUp(sup, weather)                         Weather multiplier
*
pTechWeatherAfLo(tech, weather)                     Weather multiplier
pTechWeatherAfUp(tech, weather)                     Weather multiplier
*
pTechWeatherAfsLo(tech, weather)                    Weather multiplier
pTechWeatherAfsUp(tech, weather)                    Weather multiplier

pTechWeatherAfcLo(tech, weather, comm)              Weather multiplier
pTechWeatherAfcUp(tech, weather, comm)              Weather multiplier

pStorageWeatherAfUp(stg, weather)
pStorageWeatherAfLo(stg, weather)
pStorageWeatherCinpUp(stg, weather)
pStorageWeatherCinpLo(stg, weather)
pStorageWeatherCoutUp(stg, weather)
pStorageWeatherCoutLo(stg, weather)
;

* Storage technology parameters
parameter
pStorageInpEff(stg, comm, region, year, slice)      Storage input losses
pStorageOutEff(stg, comm, region, year, slice)      Storage output losses
pStorageStgEff(stg, comm, region, year, slice)      Storage storing losses
pStorageStock(stg, region, year)                    Storage stock
pStorageOlife(stg, region)                          Storage operational life
pStorageCostStore(stg, region, year, slice)         Storing costs
pStorageCostInp(stg, region, year, slice)           Storage input costs
pStorageCostOut(stg, region, year, slice)           Storage output costs
pStorageFixom(stg, region, year)                    Storage fixed O&M costs
pStorageInvcost(stg, region, year)                  Storage investment costs
pStorageCap2stg(stg)                                Storage capacity units to activity units conversion factor
pStorageAfLo(stg, region, year, slice)              Storage lower 'charge' bound (percent)
pStorageAfUp(stg, region, year, slice)              Storage upper 'charge' bound (percent)
pStorageCinpUp(stg, comm, region, year, slice)      Storage input up
pStorageCinpLo(stg, comm, region, year, slice)      Storage input lo
pStorageCoutUp(stg, comm, region, year, slice)      Storage output up
pStorageCoutLo(stg, comm, region, year, slice)      Storage output lo
pStorageStg2AInp(stg, comm, region, year, slice)    Auxilary input
pStorageStg2AOut(stg, comm, region, year, slice)    Auxilary output
pStorageInp2AInp(stg, comm, region, year, slice)    Auxilary input
pStorageInp2AOut(stg, comm, region, year, slice)    Auxilary output
pStorageOut2AInp(stg, comm, region, year, slice)    Auxilary input
pStorageOut2AOut(stg, comm, region, year, slice)    Auxilary output
pStorageCap2AInp(stg, comm, region, year, slice)    Auxilary input
pStorageCap2AOut(stg, comm, region, year, slice)    Auxilary output
pStorageNCap2AInp(stg, comm, region, year, slice)   Auxilary input
pStorageNCap2AOut(stg, comm, region, year, slice)   Auxilary output
;
* Trade parameters
parameter
pTradeIrUp(trade, region, region, year, slice)      Upper bound on trage flow
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
;

$ontext
* Endogenous variables
** Technology
$offtext
positive variable
*@ (mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechUse(tech, region, year, slice)                  Use level in technology
*@ mTechNew(tech, region, year)
vTechNewCap(tech, region, year)                      New capacity
*@ mTechSpan(tech, region, year)
vTechRetiredCap(tech, region, year, year)            Early retired capacity
*vTechRetrofitCap(tech, region, year, year)
*vTechUpgradeCap(tech, region, year)
* Activity and intput-output
*@ mTechSpan(tech, region, year)
vTechCap(tech, region, year)                         Total capacity of the technology
*@ (mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechAct(tech, region, year, slice)                  Activity level of technology
*@ (mTechInpComm(tech, comm) and mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechInp(tech, comm, region, year, slice)            Input level
*@ (mTechOutComm(tech, comm) and mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechOut(tech, comm, region, year, slice)            Output level
* Auxiliary input & output
*@ (mTechAInp(tech, comm) and mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechAInp(tech, comm, region, year, slice)           Auxiliary commodity input
*@ (mTechAOut(tech, comm) and mTechSpan(tech, region, year) and mTechSlice(tech, slice))
vTechAOut(tech, comm, region, year, slice)           Auxiliary commodity output
;
variable
*@ mTechNew(tech, region, year)
vTechInv(tech, region, year)                         Overnight investment costs
*@ mTechSpan(tech, region, year)
vTechEac(tech, region, year)                         Annualized investment costs
*@ (sum(year$mTechNew(tech, region, year_cns), 1) <> 0)
vTechSalv(tech, region)                              Salvage value (on the end of the model horizon, to substract from costs)
*@ mTechSpan(tech, region, year)
vTechOMCost(tech, region, year)                      Sum of all technology-related costs is equal vTechFixom + vTechVarom (AVarom + CVarom + ActVarom)
;
positive variable
* Supply
* (mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region))
*@ mSupAva(sup, comm, region, year, slice)
vSupOut(sup, comm, region, year, slice)              Output of supply processes
*@ (mSupComm(sup, comm) and mSupSpan(sup, region))
vSupReserve(sup, comm, region)                       Cumulative used supply reserve
;
variable
*@ mSupSpan(sup, region)
vSupCost(sup, region, year)                          Supply costs
;
positive variable
* Demand
*@ (mMidMilestone(year) and mDemInp(comm, slice))
vDemInp(comm, region, year, slice)                   Satisfierd level of demands
;
variable
* Emission
*@ mEmsFuelTot(comm, region, year, slice)
vEmsFuelTot(comm, region, year, slice)                   Total fuel emissions
*@ mTechEmsFuel(tech, comm, region, year, slice)
vTechEmsFuel(tech, comm, region, year, slice)            Emissions on technology level by fuel
;
variable
* Ballance
*@ (mMidMilestone(year) and mCommSlice(comm, slice))
vBalance(comm, region, year, slice)                  Net commodity balance
;
positive variable
*@ (mMidMilestone(year) and mCommSlice(comm, slice))
vOutTot(comm, region, year, slice)                   Total commodity output (consumption is not counted)
*@ (mMidMilestone(year) and mCommSlice(comm, slice))
vInpTot(comm, region, year, slice)                   Total commodity input
*@ mInp2Lo(comm, region, year, slice)
vInp2Lo(comm, region, year, slice, slice)           To low level
*@ mOut2Lo(comm, region, year, slice)
vOut2Lo(comm, region, year, slice, slice)           To low level
*@ mSupOutTot(comm, region, slice)
vSupOutTot(comm, region, year, slice)                Total commodity supply
*@ mTechInpTot(comm, region, year, slice)
vTechInpTot(comm, region, year, slice)               Total commodity input
*@ mTechOutTot(comm, region, year, slice)
vTechOutTot(comm, region, year, slice)               Total technology output
*@ mStorageInpTot(comm, region, year, slice)
vStorageInpTot(comm, region, year, slice)            Total storage input
*@ mStorageOutTot(comm, region, year, slice)
vStorageOutTot(comm, region, year, slice)            Total storage output
*@ (mStorageAInp(stg, comm) and mStorageSlice(stg, slice)  and mStorageSpan(stg, region, year))
vStorageAInp(stg, comm, region, year, slice)
*@ (mStorageAOut(stg, comm) and mStorageSlice(stg, slice)  and mStorageSpan(stg, region, year))
vStorageAOut(stg, comm, region, year, slice)
;
variable
* Costs variable
*@ mMidMilestone(year)
vCost(region, year)                                  Total costs
vObjective                                           Objective costs
;
positive variable
* Dummy import
*@ mDummyImport(comm, region, year, slice)
vDummyImport(comm, region, year, slice)                   Dummy import (for debugging)
*@ mDummyExport(comm, region, year, slice)
vDummyExport(comm, region, year, slice)                   Dummy export (for debugging)
*@ mDummyCost(comm, region, year)
vDummyCost(comm, region, year)                         Dummy import & export costs  (for debugging)
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
*@ (mStorageSlice(stg, slice) and mStorageSpan(stg, region, year) and mStorageComm(stg, comm))
vStorageInp(stg, comm, region, year, slice)          Storage input
*@ (mStorageSlice(stg, slice) and mStorageSpan(stg, region, year) and mStorageComm(stg, comm))
vStorageOut(stg, comm, region, year, slice)          Storage output
*@ (mStorageSlice(stg, slice) and mStorageSpan(stg, region, year) and mStorageComm(stg, comm))
vStorageStore(stg, comm, region, year, slice)        Storage level
*@ mStorageNew(stg, region, year)
vStorageInv(stg, region, year)                       Storage technology investments
*@ mStorageSpan(stg, region, year)
vStorageCap(stg, region, year)                       Storage capacity
*@ mStorageNew(stg, region, year)
vStorageNewCap(stg, region, year)                    Storage new capacity
;
variable
*@ (sum(year$mStorageSpan(stg, region, year_cns), 1) <> 0)
vStorageSalv(stg, region)                            Storage salvage costs
*@ mStorageSpan(stg, region, year)
vStorageCost(stg, region, year)                      Storage O&M costs
;

* Trade and Row variable
positive variable
*@ mImport(comm, region, year, slice)
vImport(comm, region, year, slice)                   Total regional import (Ir + ROW)
*@ mExport(comm, region, year, slice)
vExport(comm, region, year, slice)                   Total regional export (Ir + ROW)
*@ (mTradeIr(trade, region, region, year, slice) and mTradeComm(trade, comm))
vTradeIr(trade, comm, region, region, year, slice)   Total physical trade flows between regions
*@ mTradeIrAInp2(trade, comm, region, year, slice)
vTradeIrAInp(trade, comm, region, year, slice)        auxilari input
*@ mTradeIrAInpTot(comm, region, year, slice)
vTradeIrAInpTot(comm, region, year, slice)            auxilari input
*@ mTradeIrAOut2(trade, comm, region, year, slice)
vTradeIrAOut(trade, comm, region, year, slice)       auxilari output
*@ mTradeIrAOutTot(comm, region, year, slice)
vTradeIrAOutTot(comm, region, year, slice)       auxilari output
*@ mExpComm(expp, comm)
vExportRowAccumulated(expp, comm)              Accumulated export to ROW
*@ mExportRow(expp, comm, region, year, slice)
vExportRow(expp, comm, region, year, slice)                Export to ROW
*@ mImpComm(imp, comm)
vImportRowAccumulated(imp, comm)               Accumulated import from ROW
*@ mImportRow(imp, comm, region, year, slice)
vImportRow(imp, comm, region, year, slice)                 Import from ROW
;
variable
*@ mMidMilestone(year)
vTradeCost(region, year)                             Total trade costs
*@ mMidMilestone(year)
vTradeRowCost(region, year)                          Trade costs with ROW
*@  mMidMilestone(year)
vTradeIrCost(region, year)                           Interregional trade costs
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
* (sum(sup$(mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region)), 1))
mSupOutTot(comm, region, slice)
* (sum(dem$mDemComm(dem, comm), 1) and mCommSlice(comm, slice))
mDemInp(comm, slice)
*  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and (sum(commp$(mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and pEmissionFactor(comm, commp) <> 0), 1)), 1))
mEmsFuelTot(comm, region, year, slice)
*  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)), 1))
mTechEmsFuel(tech, comm, region, year, slice)
*  (mCommSlice(comm, slice) and pDummyImportCost(comm, region, year, slice) <> Inf)
mDummyImport(comm, region, year, slice)
*  (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)
mDummyExport(comm, region, year, slice)
* mDummyExport(comm, region, year, slice) or mDummyImport(comm, region, year, slice)
mDummyCost(comm, region, year)
* mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
mTradeIr(trade, region, region, year, slice)
* mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
* pTradeIrUp(trade, src, dst, year, slice) <> Inf
mTradeIrUp(trade, region, region, year, slice)
* ((mTradeSrc(trade, region) or mTradeDst(trade, region)) and (sum(dst$(mTradeSrc(trade, region) and mTradeDst(trade, dst) and not(mSameRegion(region, dst)) and
* pTradeIrCsrc2Ainp(trade, region, dst, year, slice) <> 0), 1)  + sum(src$(mTradeSrc(trade, src) and mTradeDst(trade, region) and not(mSameRegion(region, src)) and
* pTradeIrCdst2Ainp(trade, src, region, year, slice) <> 0), 1) <> 0))
mTradeIrAInp2(trade, comm, region, year, slice)
mTradeIrAInpTot(comm, region, year, slice)
* ((mTradeSrc(trade, region) or mTradeDst(trade, region)) and (sum(dst$(mTradeSrc(trade, region) and mTradeDst(trade, dst) and not(mSameRegion(region, dst)) and
* pTradeIrCsrc2Aout(trade, region, dst, year, slice) <> 0), 1)  + sum(src$(mTradeSrc(trade, src) and mTradeDst(trade, region) and not(mSameRegion(region, src)) and
* pTradeIrCdst2Aout(trade, src, region, year, slice) <> 0), 1) <> 0))
mTradeIrAOut2(trade, comm, region, year, slice)
mTradeIrAOutTot(comm, region, year, slice)
* (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
mImportRow(imp, comm, region, year, slice)
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
* (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAInp(stg, comm)))
mStorageInpTot(comm, region, year, slice)
* (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAOut(stg, comm)))
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
* sum(slicep$(mAllSliceParentChildAndSame(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0 and
*(mSupOutTot(comm, region, slice) or mEmsFuelTot(comm, region, year, slice) or mAggOut(comm, region, year, slice) or
*mTechOutTot(comm, region, year, slice) or mStorageOutTot(comm, region, year, slice) or mImport(comm, region, year, slice) or
*mTradeIrAOutTot(comm, region, year, slice))
mOut2Lo(comm, region, year, slice)
* sum(slicep$(mAllSliceParentChildAndSame(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0
* and (mTechInpTot(comm, region, year, slice) or  mStorageInpTot(comm, region, year, slice) or
*  or mExport(comm, region, year, slice) or mTradeIrAInpTot(comm, region, year, slice))
mInp2Lo(comm, region, year, slice)
;

********************************************************************************
* Equations
********************************************************************************
********************************************************************************
** Technology equations
********************************************************************************

********************************************************************************
*** Activity Input & Output equations
********************************************************************************

* pTechUse2aout(tech, comm, region, year, slice)
* pTechUse2cact(tech, comm, region, year, slice) * pTechCact2cout(tech, comm, region, year, slice)


Equations
* Input & Output of ungrouped (single) commodities
eqTechSng2Sng(tech, region, comm, commp, year, slice)      Technology input to output
eqTechGrp2Sng(tech, region, group, commp, year, slice)     Technology group input to output
eqTechSng2Grp(tech, region, comm, groupp, year, slice)     Technology input to group output
eqTechGrp2Grp(tech, region, group, groupp, year, slice)    Technology group input to group output
eqTechUse2Sng(tech, region, commp, year, slice)            Technology use to output
eqTechUse2Grp(tech, region, groupp, year, slice)           Technology use to group output
;

eqTechSng2Sng(tech, region, comm, commp, year, slice)$
   ( mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechInpComm(tech, comm)  and mTechOneComm(tech, comm) and
     mTechOutComm(tech, commp) and mTechOneComm(tech, commp) and
     pTechCinp2use(tech, comm, region, year, slice) <> 0
   )..
   vTechInp(tech, comm, region, year, slice) *
   pTechCinp2use(tech, comm, region, year, slice)
   =e=
   vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice);


eqTechGrp2Sng(tech, region, group, commp, year, slice)$
   ( mTechSlice(tech, slice) and  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechInpGroup(tech, group) and
     mTechOutComm(tech, commp) and mTechOneComm(tech, commp)
   )..
   pTechGinp2use(tech, group, region, year, slice) *
   sum(comm$(mTechInpComm(tech, comm) and mTechGroupComm(tech, group, comm)),
           vTechInp(tech, comm, region, year, slice) *
           pTechCinp2ginp(tech, comm, region, year, slice)
   )
   =e=
   vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice);

eqTechSng2Grp(tech, region, comm, groupp, year, slice)$
   ( mTechSlice(tech, slice) and  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechInpComm(tech, comm)  and mTechOneComm(tech, comm) and
     mTechOutGroup(tech, groupp) and
     pTechCinp2use(tech, comm, region, year, slice) <> 0
   )..
   vTechInp(tech, comm, region, year, slice) *
   pTechCinp2use(tech, comm, region, year, slice)
   =e=
    sum(commp$(mTechOutComm(tech, commp) and mTechGroupComm(tech, groupp, commp)),
           vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice)
   );

eqTechGrp2Grp(tech, region, group, groupp, year, slice)$
   ( mTechSlice(tech, slice) and  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechInpGroup(tech, group) and
     mTechOutGroup(tech, groupp)
   )..
   pTechGinp2use(tech, group, region, year, slice) *
   sum(comm$(mTechInpComm(tech, comm) and mTechGroupComm(tech, group, comm)),
           vTechInp(tech, comm, region, year, slice) *
           pTechCinp2ginp(tech, comm, region, year, slice)
   )
   =e=
   sum(commp$(mTechOutComm(tech, commp) and mTechGroupComm(tech, groupp, commp)),
           vTechOut(tech, commp, region, year, slice) /
           pTechUse2cact(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice)
   );

eqTechUse2Sng(tech, region, commp, year, slice)$
   ( mTechSlice(tech, slice) and  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechOutComm(tech, commp) and mTechOneComm(tech, commp)
   )..
   vTechUse(tech, region, year, slice) =e=
         vTechOut(tech, commp, region, year, slice) /
         pTechCact2cout(tech, commp, region, year, slice);

eqTechUse2Grp(tech, region, groupp, year, slice)$
   ( mTechSlice(tech, slice) and  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechOutGroup(tech, groupp)
   )..
   vTechUse(tech, region, year, slice) =e=
   sum(commp$(mTechOutComm(tech, commp) and mTechGroupComm(tech, groupp, commp)),
           vTechOut(tech, commp, region, year, slice) /
           pTechCact2cout(tech, commp, region, year, slice)
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
eqTechShareInpLo(tech, region, group, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechInpGroup(tech, group) and mTechInpComm(tech, comm) and
                 mTechGroupComm(tech, group, comm) and
                 pTechShareLo(tech, comm, region, year, slice) <> 0
         )..
                  vTechInp(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$(mTechInpComm(tech, commp) and mTechGroupComm(tech, group, commp)),
                          vTechInp(tech, commp, region, year, slice)
                  );

* Input Share UP equation
eqTechShareInpUp(tech, region, group, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and  mTechSpan(tech, region, year) and
                 mTechInpGroup(tech, group) and mTechInpComm(tech, comm) and
                 mTechGroupComm(tech, group, comm) and
                 pTechShareUp(tech, comm, region, year, slice) <> 1
         )..
                  vTechInp(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$(mTechInpComm(tech, commp) and mTechGroupComm(tech, group, commp)),
                          vTechInp(tech, commp, region, year, slice)
                  );

* Output Share LO equation
eqTechShareOutLo(tech, region, group, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and  mTechSpan(tech, region, year) and
                 mTechOutGroup(tech, group) and mTechOutComm(tech, comm) and
                 mTechGroupComm(tech, group, comm) and
                 pTechShareLo(tech, comm, region, year, slice) <> 0
         )..
                  vTechOut(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$(mTechOutComm(tech, commp) and mTechGroupComm(tech, group, commp)),
                          vTechOut(tech, commp, region, year, slice)
                  );

* Output Share UP equation
eqTechShareOutUp(tech, region, group, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and  mTechSpan(tech, region, year) and
                 mTechOutGroup(tech, group) and mTechOutComm(tech, comm) and
                 mTechGroupComm(tech, group, comm) and
                 pTechShareUp(tech, comm, region, year, slice) <> 1
         )..
                  vTechOut(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$(mTechOutComm(tech, commp) and mTechGroupComm(tech, group, commp)),
                          vTechOut(tech, commp, region, year, slice)
                  );

********************************************************************************
* Auxiliary input & output equations
********************************************************************************
equation
eqTechAInp(tech, comm, region, year, slice) Technology auxiliary commodity input
eqTechAOut(tech, comm, region, year, slice) Technology auxiliary commodity output
;


eqTechAInp(tech, comm, region, year, slice)$(mTechSlice(tech, slice) and mMidMilestone(year) and mTechAInp(tech, comm)  and mTechSpan(tech, region, year))..
  vTechAInp(tech, comm, region, year, slice) =e=
  (vTechUse(tech, region, year, slice) *
    pTechUse2AInp(tech, comm, region, year, slice)) +
  (vTechAct(tech, region, year, slice) *
    pTechAct2AInp(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AInp(tech, comm, region, year, slice)) +
  (vTechNewCap(tech, region, year) *
    pTechNCap2AInp(tech, comm, region, year, slice)) +
  sum(commp$pTechCinp2AInp(tech, comm, commp, region, year, slice),
      pTechCinp2AInp(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$pTechCout2AInp(tech, comm, commp, region, year, slice),
      pTechCout2AInp(tech, comm, commp, region, year, slice) *
         vTechOut(tech, commp, region, year, slice));

eqTechAOut(tech, comm, region, year, slice)$(mTechSlice(tech, slice) and mMidMilestone(year) and mTechAOut(tech, comm) and mTechSpan(tech, region, year))..
  vTechAOut(tech, comm, region, year, slice) =e=
  (vTechUse(tech, region, year, slice) *
    pTechUse2AOut(tech, comm, region, year, slice)) +
  (vTechAct(tech, region, year, slice) *
    pTechAct2AOut(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AOut(tech, comm, region, year, slice)) +
  (vTechNewCap(tech, region, year) *
    pTechNCap2AOut(tech, comm, region, year, slice)) +
  sum(commp$pTechCinp2AOut(tech, comm, commp, region, year, slice),
      pTechCinp2AOut(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$pTechCout2AOut(tech, comm, commp, region, year, slice),
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
eqTechAfLo(tech, region, year, slice)$(mTechSlice(tech, slice) and mMidMilestone(year) and pTechAfLo(tech, region, year, slice) <> 0
  and mTechSpan(tech, region, year))..
         pTechAfLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice)  * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mTechWeatherAf(tech, weather)
                 and pTechWeatherAfLo(tech, weather) >= 0
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfLo(tech, weather))
         =l=
         vTechAct(tech, region, year, slice);

* Availability factor UP
eqTechAfUp(tech, region, year, slice)$(
                 mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechAfUp(tech, region, year, slice)
         )..
         vTechAct(tech, region, year, slice)
         =l=
         pTechAfUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mTechWeatherAf(tech, weather)
           and pTechWeatherAfUp(tech, weather) >= 0
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfUp(tech, weather));

* Availability factor for sum LO
eqTechAfsLo(tech, region, year, slice)$(mMidMilestone(year) and pTechAfsLo(tech, region, year, slice) > 0
  and mTechSpan(tech, region, year))..
         pTechAfsLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mTechWeatherAfs(tech, weather)
                 and pTechWeatherAfsLo(tech, weather) >= 0
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfsLo(tech, weather))
         =l=
         sum(slicep$(mTechSlice(tech, slicep) and mAllSliceParentChildAndSame(slice, slicep)), vTechAct(tech, region, year, slicep));

* Availability factor for sum UP
eqTechAfsUp(tech, region, year, slice)$(mMidMilestone(year) and pTechAfsUp(tech, region, year, slice) >= 0
  and mTechSpan(tech, region, year))..
         sum(slicep$(mTechSlice(tech, slicep) and mAllSliceParentChildAndSame(slice, slicep)), vTechAct(tech, region, year, slicep))
         =l=
         pTechAfsUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice)* prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mTechWeatherAfs(tech, weather)
                 and pTechWeatherAfsUp(tech, weather) >= 0
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfsUp(tech, weather));

********************************************************************************
* Connect activity with output equations
********************************************************************************
Equation
* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)  Technology activity to commodity output
eqTechActGrp(tech, group, region, year, slice) Technology activity to group output
;

* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)$(mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
  mTechOutComm(tech, comm) and mTechOneComm(tech, comm)
  and pTechCact2cout(tech, comm, region, year, slice) <> 0 ).. vTechAct(tech, region, year, slice) =e=
                 vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice);

eqTechActGrp(tech, group, region, year, slice)$(mTechSlice(tech, slice) and mMidMilestone(year) and mTechOutGroup(tech, group)
   and mTechSpan(tech, region, year)).. vTechAct(tech, region, year, slice) =e=
         sum(comm$(mTechGroupComm(tech, group, comm) and pTechCact2cout(tech, comm, region, year, slice) <> 0),
                 vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice)
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
eqTechAfcOutLo(tech, region, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechOutComm(tech, comm) and
                 pTechAfcLo(tech, comm, region, year, slice) <> 0
         )..
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfcLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep)
                 and pTechWeatherAfcLo(tech, weather, comm) >= 0  and mTechWeatherAfc(tech, weather, comm)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfcLo(tech, weather, comm))
         =l=
         vTechOut(tech, comm, region, year, slice);

* Availability commodity factor UP output equations
eqTechAfcOutUp(tech, region, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechOutComm(tech, comm) and
                 mTechAfUp(tech, region, year, slice) and
                 mTechAfcUp(tech, comm, region, year, slice)
         )..
         vTechOut(tech, comm, region, year, slice)
         =l=
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfcUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep)
                 and pTechWeatherAfcUp(tech, weather, comm) >= 0  and mTechWeatherAfc(tech, weather, comm)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfcUp(tech, weather, comm));

* Availability commodity factor LO input equations
eqTechAfcInpLo(tech, region, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechInpComm(tech, comm) and
                 pTechAfcLo(tech, comm, region, year, slice) <> 0
         )..
         pTechAfcLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice)  * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep)
                 and pTechWeatherAfcLo(tech, weather, comm) >= 0  and mTechWeatherAfc(tech, weather, comm)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfcLo(tech, weather, comm))
         =l=
         vTechInp(tech, comm, region, year, slice);

* Availability commodity factor UP input equations
eqTechAfcInpUp(tech, region, comm, year, slice)$
         (       mTechSlice(tech, slice) and mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechInpComm(tech, comm) and
                 mTechAfUp(tech, region, year, slice) and
                 mTechAfcUp(tech, comm, region, year, slice)
         )..
         vTechInp(tech, comm, region, year, slice)
         =l=
         pTechAfcUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year) *
         pSliceShare(slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep)
                 and pTechWeatherAfcUp(tech, weather, comm) >= 0  and mTechWeatherAfc(tech, weather, comm)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pTechWeatherAfcUp(tech, weather, comm));

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
* Salvage value
*eqTechSalv1(tech, region)
eqTechSalv(tech, region, yeare)     Technology salvage costs
eqTechSalv0(tech, region, yeare)    Technology salvage costs when discount is zero
* Aggregated annual costs
eqTechOMCost(tech, region, year)    Technology O&M costs
;

* Capacity equation
eqTechCap(tech, region, year)$(mMidMilestone(year) and  mTechSpan(tech, region, year))..
         vTechCap(tech, region, year)
         =e=
         pTechStock(tech, region, year) +
         sum((yearp)$
                 (       mTechNew(tech, region, yearp) and mMidMilestone(yearp) and
                         ordYear(year) >= ordYear(yearp) and
                         (ordYear(year) < pTechOlife(tech, region) + ordYear(yearp) or mTechOlifeInf(tech, region))
                 ),
                 vTechNewCap(tech, region, yearp) -
                   sum(yeare$(mTechRetirement(tech) and mMidMilestone(yeare) and
                       ordYear(yeare) >= ordYear(yearp) and ordYear(yeare) <= ordYear(year)),
                         vTechRetiredCap(tech, region, yearp, yeare))
         );

eqTechNewCap(tech, region, year)$(mMidMilestone(year) and mTechNew(tech, region, year) and mTechRetirement(tech))..
    sum(yearp$(mMidMilestone(yearp) and ordYear(yearp) >= ordYear(year) and ordYear(yearp) < ordYear(year) + pTechOlife(tech, region)),
                         vTechRetiredCap(tech, region, year, yearp)
         ) =l= vTechNewCap(tech, region, year);

* EAC equation
eqTechEac(tech, region, year)$(mMidMilestone(year) and  mTechSpan(tech, region, year))..
         vTechEac(tech, region, year)
         =e=
         sum((yearp)$
                 (       mTechNew(tech, region, yearp) and mMidMilestone(yearp) and
                         ordYear(year) >= ordYear(yearp) and
                         ordYear(year) < pTechOlife(tech, region) + ordYear(yearp) and
                         not(mTechOlifeInf(tech, region)) and pTechInvcost(tech, region, yearp) <> 0
                 ),
                  pTechInvcost(tech, region, yearp) * (
*                   sum(yeare$(ordYear(yeare) = ordYear(year) and ordYear(yearp) = ordYear(year)), pTechStock(tech, region, yeare)) +
                   vTechNewCap(tech, region, yearp) -
                   sum((yeare)$(mTechRetirement(tech) and mMidMilestone(yeare) and ordYear(yeare) >= ordYear(yearp) and ordYear(yeare) <= ordYear(year)),
                       vTechRetiredCap(tech, region, yearp, yeare))) /
                 (
* Before the model end year
   sum((yeare)$(ordYear(yeare) >= ordYear(yearp) and ordYear(yeare) < ordYear(yearp) + pTechOlife(tech, region)),
     pDiscountFactor(region, yeare) / pDiscountFactor(region, yearp))
* After the model end year
+ sum((yeare)$(ordYear(yeare) = cardYear(year) and ordYear(yeare) < ordYear(yearp) + pTechOlife(tech, region) - 1 and not(mDiscountZero(region))),
      pDiscountFactor(region, yeare) / pDiscountFactor(region, yearp) *
   (1 - ((1 + pDiscount(region, yeare)) ** (ordYear(yeare) - ordYear(yearp) - pTechOlife(tech, region) + 1))) / pDiscount(region, yeare))
+  sum((yeare)$(ordYear(yeare) = cardYear(year) and ordYear(yeare) < ordYear(yearp) + pTechOlife(tech, region) - 1 and mDiscountZero(region)),
      pDiscountFactor(region, yeare) / pDiscountFactor(region, yearp) * (pTechOlife(tech, region) - 1 - ordYear(yeare) + ordYear(yearp)))
                 )
         );

*eqTechRetirementCap(tech, region, year, yearp)$(not(mTechRetirement(tech)) or
*  ordYear(yearp) < ordYear(year) or ordYear(yearp) >= ordYear(year) + pTechOlife(tech, region))..
*    vTechRetiredCap(tech, region, year, yearp) =e= 0;

*eqTechRetrofitCap(tech, region, year, yearp)$(ordYear(yearp) < ordYear(year) or ordYear(yearp) >= ordYear(year) + pTechOlife(tech, region))..
*    vTechRetrofitCap(tech, region, year, yearp) =e= 0;

*eqTechUpgradeCap(tech, region, year)..
*    sum((techp, yearp)$(mTechUpgrade(tech, techp)), vTechRetrofitCap(techp, region, yearp, year)) =e= vTechUpgradeCap(tech, region, year);

* Investment equation
eqTechInv(tech, region, year)$(mMidMilestone(year) and mTechNew(tech, region, year))..  vTechInv(tech, region, year) =e=
   pTechInvcost(tech, region, year) * vTechNewCap(tech, region, year);

* Salvage value
eqTechSalv0(tech, region, yeare)$(mDiscountZero(region) and mMilestoneLast(yeare) and sum(year$mTechNew(tech, region, year), 1) <> 0)..
    vTechSalv(tech, region)
    +
   sum((year, yearn)$(mStartMilestone(yearn, year) and mMidMilestone(yearn) and mTechNew(tech, region, yearn)
         and ordYear(yearn) + pTechOlife(tech, region) - 1 > ordYear(yeare) and not(mTechOlifeInf(tech, region))  and pTechInvcost(tech, region, yearn) <> 0),
    (pDiscountFactor(region, yearn) /  pDiscountFactor(region, yeare)) *
    pTechInvcost(tech, region, yearn) * (vTechNewCap(tech, region, yearn)
     - sum(yearp$(mTechRetirement(tech)), vTechRetiredCap(tech, region, year, yearp)))  / (
      1
        + (sum(yearp$(ordYear(yearp) >= ordYear(yearn)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / (
           (pTechOlife(tech, region) + ordYear(yearn) - 1 - ordYear(yeare)
           ))
    ))  =e= 0;


eqTechSalv(tech, region, yeare)$(mMilestoneLast(yeare) and not(mDiscountZero(region)) and sum(year$mTechNew(tech, region, year), 1) <> 0)..
    vTechSalv(tech, region)
    +
   sum((year, yearn)$(mStartMilestone(yearn, year) and mMidMilestone(yearn)
  and mTechNew(tech, region, yearn) and ordYear(yearn) + pTechOlife(tech, region) - 1 > ordYear(yeare) and not(mTechOlifeInf(tech, region))
   and pTechInvcost(tech, region, yearn) <> 0),
    (pDiscountFactor(region, yearn) /  pDiscountFactor(region, yeare)) *
    pTechInvcost(tech, region, yearn) * (vTechNewCap(tech, region, yearn)
      - sum(yearp$(mMidMilestone(yearp) and mTechRetirement(tech)), vTechRetiredCap(tech, region, year, yearp))) / (
      1
        + (sum(yearp$(ordYear(yearp) >= ordYear(yearn)), pDiscountFactor(region, yearp)))
        / pDiscountFactor(region, yeare) / ((
           1 - (1 + pDiscount(region, yeare)) ** (ordYear(yeare) - pTechOlife(tech, region) - ordYear(yearn) + 1)
           )  *  (1 + pDiscount(region, yeare)) / pDiscount(region, yeare))
    ))  =e= 0;

* Annual O&M costs
eqTechOMCost(tech, region, year)$(mMidMilestone(year) and mTechSpan(tech, region, year))..
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
                  sum(comm$mTechAOut(tech, comm),
                          pTechAvarom(tech, comm, region, year, slice) *
                          vTechAOut(tech, comm, region, year, slice)
                  )
                  +
                  sum(comm$mTechAInp(tech, comm),
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
         pSupAvaUp(sup, comm, region, year, slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mSupWeatherUp(sup, weather)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pSupWeatherUp(sup, weather));

eqSupAvaLo(sup, comm, region, year, slice)$ mSupAva(sup, comm, region, year, slice)..
         vSupOut(sup, comm, region, year, slice)
         =g=
         pSupAvaLo(sup, comm, region, year, slice) * prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mSupWeatherLo(sup, weather)
           and mAllSliceParentChildAndSame(slice, slicep)), pWeather(weather, region, year, slice) * pSupWeatherLo(sup, weather));

eqSupTotal(sup, comm, region)$(mSupComm(sup, comm) and mSupSpan(sup, region))..
         vSupReserve(sup, comm, region)
         =e=
         sum((year, slice)$(mSupAva(sup, comm, region, year, slice) and mMidMilestone(year)),
             pPeriodLen(year) * vSupOut(sup, comm, region, year, slice)
         );

eqSupReserveUp(sup, comm, region)$mSupReserveUp(sup, comm, region)..
         pSupReserveUp(sup, comm, region) =g= vSupReserve(sup, comm, region);

eqSupReserveLo(sup, comm, region)$
         (
                 mSupComm(sup, comm) and  pSupReserveLo(sup, comm, region) <> 0 and mSupSpan(sup, region)
         )..
         vSupReserve(sup, comm, region) =g= pSupReserveLo(sup, comm, region);


eqSupCost(sup, region, year)$(mMidMilestone(year) and mSupSpan(sup, region))..
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

eqDemInp(comm, region, year, slice)$(mMidMilestone(year) and mDemInp(comm, slice))..
         vDemInp(comm, region, year, slice)  =e=
         sum(dem$mDemComm(dem, comm), pDemand(dem, comm, region, year, slice));

********************************************************************************
* Emission & Aggregating commodity equation
********************************************************************************
Equation
eqAggOut(comm, region, year, slice)            Aggregating commodity output
eqEmsFuelTot(comm, region, year, slice)         Emissions from commodity consumption (i.e. fuels combustion)
eqTechEmsFuel(tech, comm, region, year, slice)  Emissions from commodity consumption by technologies
;

eqAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice)..
         vAggOut(comm, region, year, slice)
         =e=
         sum(commp$pAggregateFactor(comm, commp),
                 pAggregateFactor(comm, commp) *
                  vOutTot(commp, region, year, slice)
         );

eqTechEmsFuel(tech, comm, region, year, slice)$mTechEmsFuel(tech, comm, region, year, slice)..
         vTechEmsFuel(tech, comm, region, year, slice)
         =e=
         sum(commp$(mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and
                         pEmissionFactor(comm, commp) <> 0
                 ),
                   pTechEmisComm(tech, commp) * pEmissionFactor(comm, commp) *
                   vTechInp(tech, commp, region, year, slice)
         );

eqEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice)..
     vEmsFuelTot(comm, region, year, slice)
         =e= sum(tech$mTechEmsFuel(tech, comm, region, year, slice), vTechEmsFuel(tech, comm, region, year, slice));

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

eqStorageAInp(stg, comm, region, year, slice)$(mMidMilestone(year) and mStorageAInp(stg, comm)
  and mStorageSlice(stg, slice)  and mStorageSpan(stg, region, year))..
  vStorageAInp(stg, comm, region, year, slice) =e= sum(commp$mStorageComm(stg, commp),
         pStorageStg2AInp(stg, comm, region, year, slice) * vStorageStore(stg, commp, region, year, slice) +
         pStorageInp2AInp(stg, comm, region, year, slice) * vStorageInp(stg, commp, region, year, slice) +
         pStorageOut2AInp(stg, comm, region, year, slice) * vStorageOut(stg, commp, region, year, slice) +
         pStorageCap2AInp(stg, comm, region, year, slice) * vStorageCap(stg, region, year) +
         pStorageNCap2AInp(stg, comm, region, year, slice) * vStorageNewCap(stg, region, year)
);

eqStorageAOut(stg, comm, region, year, slice)$(mMidMilestone(year) and mStorageAOut(stg, comm)
  and mStorageSlice(stg, slice)  and mStorageSpan(stg, region, year))..
  vStorageAOut(stg, comm, region, year, slice) =e= sum(commp$mStorageComm(stg, commp),
         pStorageStg2AOut(stg, comm, region, year, slice) * vStorageStore(stg, commp, region, year, slice) +
         pStorageInp2AOut(stg, comm, region, year, slice) * vStorageInp(stg, commp, region, year, slice) +
         pStorageOut2AOut(stg, comm, region, year, slice) * vStorageOut(stg, commp, region, year, slice) +
         pStorageCap2AOut(stg, comm, region, year, slice) * vStorageCap(stg, region, year) +
         pStorageNCap2AOut(stg, comm, region, year, slice) * vStorageNewCap(stg, region, year)
);


eqStorageStore(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm))..
  vStorageStore(stg, comm, region, year, slice) =e=
  pStorageInpEff(stg, comm, region, year, slice) * vStorageInp(stg, comm, region, year, slice) -
  vStorageOut(stg, comm, region, year, slice) / pStorageOutEff(stg, comm, region, year, slice) +
  sum(slicep$(mStorageSlice(stg, slicep) and mSliceNext(slicep, slice)),
  pStorageStgEff(stg, comm, region, year, slice) * vStorageStore(stg, comm, region, year, slicep));

eqStorageAfLo(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm) and pStorageAfLo(stg, region, year, slice))..
  vStorageStore(stg, comm, region, year, slice) =g= pStorageAfLo(stg, region, year, slice) *
     pStorageCap2stg(stg) * vStorageCap(stg, region, year) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherAf(stg, weather)
                 and pStorageWeatherAfLo(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherAfLo(stg, weather));

eqStorageAfUp(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm))..
  vStorageStore(stg, comm, region, year, slice) =l= pStorageAfUp(stg, region, year, slice) *
     pStorageCap2stg(stg) * vStorageCap(stg, region, year) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherAf(stg, weather)
                 and pStorageWeatherAfUp(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherAfUp(stg, weather));

eqStorageClean(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm))..
  vStorageInp(stg, comm, region, year, slice) =l= vStorageStore(stg, comm, region, year, slice);

*
eqStorageInpUp(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm) and pStorageCinpUp(stg, comm, region, year, slice) >= 0)..
  pStorageInpEff(stg, comm, region, year, slice) * vStorageInp(stg, comm, region, year, slice) =l=
    pStorageCinpUp(stg, comm, region, year, slice) * pSliceShare(slice) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherCinp(stg, weather)
                 and pStorageWeatherCinpUp(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherCinpUp(stg, weather));

eqStorageInpLo(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm) and pStorageCinpLo(stg, comm, region, year, slice) > 0)..
  pStorageInpEff(stg, comm, region, year, slice) * vStorageInp(stg, comm, region, year, slice) =g=
    pStorageCinpLo(stg, comm, region, year, slice) * pSliceShare(slice) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherCinp(stg, weather)
                 and pStorageWeatherCinpLo(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherCinpLo(stg, weather));

*
eqStorageOutUp(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm) and pStorageCoutUp(stg, comm, region, year, slice) >= 0)..
  vStorageOut(stg, comm, region, year, slice) / pStorageOutEff(stg, comm, region, year, slice) =l=
    pStorageCoutUp(stg, comm, region, year, slice) * pSliceShare(slice) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherCout(stg, weather)
                 and pStorageWeatherCoutUp(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherCoutUp(stg, weather));

eqStorageOutLo(stg, comm, region, year, slice)$(mStorageSlice(stg, slice) and mMidMilestone(year) and mStorageSpan(stg, region, year)
  and mStorageComm(stg, comm) and pStorageCoutLo(stg, comm, region, year, slice) > 0)..
  vStorageOut(stg, comm, region, year, slice) / pStorageOutEff(stg, comm, region, year, slice)  =g=
    pStorageCoutLo(stg, comm, region, year, slice) * pSliceShare(slice) *
         prod((slicep, weather)$(mWeatherRegion(weather, region) and mWeatherSlice(weather, slicep) and mStorageWeatherCout(stg, weather)
                 and pStorageWeatherCoutLo(stg, weather) >= 0 and mAllSliceParentChildAndSame(slice, slicep)),
                    pWeather(weather, region, year, slice) * pStorageWeatherCoutLo(stg, weather));


********************************************************************************
* Capacity and costs equations for storage
********************************************************************************
Equation
* Capacity equation
eqStorageCap(stg, region, year)     Storage capacity
* Investition equation
eqStorageInv(stg, region, year)     Storage investments
* Aggregated annual costs
eqStorageCost(stg, region, year)  Storage total costs
* Salvage value
eqStorageSalv0(stg, region, yeare)  Storage salvage equation for zero discount
eqStorageSalv(stg, region, yeare)   Storage salvage equation
* Constrain capacity
;

* Capacity equation
eqStorageCap(stg, region, year)$(mMidMilestone(year) and mStorageSpan(stg, region, year))..
         vStorageCap(stg, region, year)
         =e=
         pStorageStock(stg, region, year) +
         sum(yearp$
                 (
                         ordYear(year) >= ordYear(yearp) and
                         (mStorageOlifeInf(stg, region) or ordYear(year) < pStorageOlife(stg, region) + ordYear(yearp)) and
                         mStorageNew(stg, region, year)
                 ),
                 vStorageNewCap(stg, region, yearp)
         );

* Investition equation
eqStorageInv(stg, region, year)$(mMidMilestone(year) and mStorageNew(stg, region, year))..
         vStorageInv(stg, region, year)
         =e=
         pStorageInvcost(stg, region, year) *
         vStorageNewCap(stg, region, year);

* FIX O & M + Inv Costequation
eqStorageCost(stg, region, year)$(mMidMilestone(year) and mStorageSpan(stg, region, year))..
         vStorageCost(stg, region, year)
         =e=
         pStorageFixom(stg, region, year) * vStorageCap(stg, region, year) +
         sum((comm, slice)$(mStorageSlice(stg, slice) and mStorageComm(stg, comm)),
             pStorageCostInp(stg, region, year, slice) * vStorageInp(stg, comm, region, year, slice)
             + pStorageCostOut(stg, region, year, slice) * vStorageOut(stg, comm, region, year, slice)
             + pStorageCostStore(stg, region, year, slice) * vStorageStore(stg, comm, region, year, slice)
         )
         + vStorageInv(stg, region, year)$mStorageNew(stg, region, year);

* Salvage value
eqStorageSalv0(stg, region, yeare)$(mDiscountZero(region) and mMilestoneLast(yeare) and sum(year$mStorageNew(stg, region, year), 1) <> 0)..
    vStorageSalv(stg, region)
    +
   sum((year, yearn)$(mStartMilestone(yearn, year) and mMidMilestone(yearn) and mStorageNew(stg, region, yearn)
         and ordYear(yearn) + pStorageOlife(stg, region) - 1 > ordYear(yeare) and not(mStorageOlifeInf(stg, region))  and pStorageInvcost(stg, region, yearn) <> 0),
    (pDiscountFactor(region, yearn) /  pDiscountFactor(region, yeare)) *
    pStorageInvcost(stg, region, yearn) * vStorageNewCap(stg, region, yearn)  / (
      1
        + (sum(yearp$(ordYear(yearp) >= ordYear(yearn)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / (
           (pStorageOlife(stg, region) + ordYear(yearn) - 1 - ordYear(yeare)
           ))
    ))  =e= 0;


eqStorageSalv(stg, region, yeare)$(mMilestoneLast(yeare) and not(mDiscountZero(region)) and sum(year$mStorageNew(stg, region, year), 1) <> 0)..
    vStorageSalv(stg, region)
    +
   sum((year, yearn)$(mStartMilestone(yearn, year) and mMidMilestone(yearn)
  and mStorageNew(stg, region, yearn) and ordYear(yearn) + pStorageOlife(stg, region) - 1 > ordYear(yeare) and not(mStorageOlifeInf(stg, region))
   and pStorageInvcost(stg, region, yearn) <> 0),
    (pDiscountFactor(region, yearn) /  pDiscountFactor(region, yeare)) *
    pStorageInvcost(stg, region, yearn) * vStorageNewCap(stg, region, yearn) / (
      1
        + (sum(yearp$(ordYear(yearp) >= ordYear(yearn)), pDiscountFactor(region, yearp)))
        / pDiscountFactor(region, yeare) / ((
           1 - (1 + pDiscount(region, yeare)) ** (ordYear(yeare) - pStorageOlife(stg, region) - ordYear(yearn) + 1)
           )  *  (1 + pDiscount(region, yeare)) / pDiscount(region, yeare))
    ))  =e= 0;


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
;

eqImport(comm, dst, year, slice)$mImport(comm, dst, year, slice)..
  vImport(comm, dst, year, slice) =e=
  sum((trade, src)$(mTradeIr(trade, src, dst, year, slice) and mTradeComm(trade, comm)), vTradeIr(trade, comm, src, dst, year, slice))
         + sum(imp$mImportRow(imp, comm, dst, year, slice), vImportRow(imp, comm, dst, year, slice));

eqExport(comm, src, year, slice)$mExport(comm, src, year, slice)..
  vExport(comm, src, year, slice) =e=
  sum((trade, dst)$(mTradeIr(trade, src, dst, year, slice) and mTradeComm(trade, comm)), vTradeIr(trade, comm, src, dst, year, slice))
         + sum(expp$mExportRow(expp, comm, src, year, slice), vExportRow(expp, comm, src, year, slice));

eqTradeFlowUp(trade, comm, src, dst, year, slice)$(mTradeIrUp(trade, src, dst, year, slice) and mTradeComm(trade, comm))..
      vTradeIr(trade, comm, src, dst, year, slice) =l= pTradeIrUp(trade, src, dst, year, slice);

eqTradeFlowLo(trade, comm, src, dst, year, slice)$(mTradeIr(trade, src, dst, year, slice) and
    pTradeIrLo(trade, src, dst, year, slice) and mTradeComm(trade, comm))..
      vTradeIr(trade, comm, src, dst, year, slice) =g= pTradeIrLo(trade, src, dst, year, slice);

eqCostTrade(region, year)$mMidMilestone(year)..
  vTradeCost(region, year) =e= vTradeRowCost(region, year) + vTradeIrCost(region, year);

eqCostRowTrade(region, year)$mMidMilestone(year).. vTradeRowCost(region, year) =e=
* Row
  sum((imp, comm, slice)$mImportRow(imp, comm, region, year, slice), pImportRowPrice(imp, region, year, slice) *
     vImportRow(imp, comm, region, year, slice)) -
  sum((expp, comm, slice)$mExportRow(expp, comm, region, year, slice), pExportRowPrice(expp, region, year, slice) *
      vExportRow(expp, comm, region, year, slice));

eqCostIrTrade(region, year)$mMidMilestone(year).. vTradeIrCost(region, year) =e=
* Import
  sum((trade, comm, src, slice)$(mTradeSlice(trade, slice) and mTradeSrc(trade, src) and mTradeDst(trade, region)
         and not(mSameRegion(src, region)) and mTradeComm(trade, comm)),
    (pTradeIrCost(trade, src, region, year, slice) + pTradeIrMarkup(trade, src, region, year, slice)) *
        vTradeIr(trade, comm, src, region, year, slice))
* Plus markup from export
  - sum((trade, comm, dst, slice)$(mTradeSlice(trade, slice) and mTradeSrc(trade, region) and mTradeDst(trade, dst)
         and not(mSameRegion(dst, region)) and mTradeComm(trade, comm)),
    pTradeIrMarkup(trade, region, dst, year, slice) * vTradeIr(trade, comm, region, dst, year, slice));

eqExportRowUp(expp, comm, region, year, slice)$mExportRowUp(expp, comm, region, year, slice)..
  vExportRow(expp, comm, region, year, slice)  =l= pExportRowUp(expp, region, year, slice);

eqExportRowLo(expp, comm, region, year, slice)$(mExportRow(expp, comm, region, year, slice) and pExportRowLo(expp, region, year, slice) <> 0)..
  vExportRow(expp, comm, region, year, slice)  =g= pExportRowLo(expp, region, year, slice);

eqExportRowCumulative(expp, comm)$mExpComm(expp, comm).. vExportRowAccumulated(expp, comm) =e=
    sum((region, year, slice)$(mMidMilestone(year) and mExportRow(expp, comm, region, year, slice)),
        pPeriodLen(year) * vExportRow(expp, comm, region, year, slice)
);

eqExportRowResUp(expp, comm)$(mExportRowAccumulatedUp(expp, comm) and mExpComm(expp, comm))..
                 vExportRowAccumulated(expp, comm) =l= pExportRowRes(expp);

eqImportRowUp(imp, comm, region, year, slice)$mImportRowUp(imp, comm, region, year, slice)..
  vImportRow(imp, comm, region, year, slice)  =l= pImportRowUp(imp, region, year, slice);

eqImportRowLo(imp, comm, region, year, slice)$(mImportRow(imp, comm, region, year, slice) and pImportRowLo(imp, region, year, slice) <> 0)..
  vImportRow(imp, comm, region, year, slice)  =g= pImportRowLo(imp, region, year, slice);

eqImportRowAccumulated(imp, comm)$mImpComm(imp, comm).. vImportRowAccumulated(imp, comm) =e=
    sum((region, year, slice)$mImportRow(imp, comm, region, year, slice),
         pPeriodLen(year) * vImportRow(imp, comm, region, year, slice)
);

eqImportRowResUp(imp, comm)$mImportRowAccumulatedUp(imp, comm).. vImportRowAccumulated(imp, comm) =l= pImportRowRes(imp);


********************************************************************************
* Auxiliary input & output equations
********************************************************************************
equation
eqTradeIrAInp(trade, comm, region, year, slice) Trade auxiliary commodity input
eqTradeIrAOut(trade, comm, region, year, slice) Trade auxiliary commodity output
eqTradeIrAInpTot(comm, region, year, slice) Trade auxiliary commodity input
eqTradeIrAOutTot(comm, region, year, slice) Trade auxiliary commodity output
;

eqTradeIrAInp(trade, comm, region, year, slice)$mTradeIrAInp2(trade, comm, region, year, slice)..
  vTradeIrAInp(trade, comm, region, year, slice) =e=
    sum(dst$(mTradeSrc(trade, region) and mTradeDst(trade, dst) and not(mSameRegion(region, dst))),
      pTradeIrCsrc2Ainp(trade, comm, region, dst, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, region, dst, year, slice)))
    + sum(src$(mTradeSrc(trade, src) and mTradeDst(trade, region) and not(mSameRegion(region, src))),
      pTradeIrCdst2Ainp(trade, comm, src, region, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, src, region, year, slice)));

eqTradeIrAOut(trade, comm, region, year, slice)$mTradeIrAOut2(trade, comm, region, year, slice)..
  vTradeIrAOut(trade, comm, region, year, slice) =e=
    sum(dst$(mTradeSrc(trade, region) and mTradeDst(trade, dst) and not(mSameRegion(region, dst))),
      pTradeIrCsrc2Aout(trade, comm, region, dst, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, region, dst, year, slice)))
    + sum(src$(mTradeSrc(trade, src) and mTradeDst(trade, region) and not(mSameRegion(region, src))),
      pTradeIrCdst2Aout(trade, comm, src, region, year, slice) * sum(commp$mTradeComm(trade, commp), vTradeIr(trade, commp, src, region, year, slice)));

eqTradeIrAInpTot(comm, region, year, slice)$mTradeIrAInpTot(comm, region, year, slice)..
  vTradeIrAInpTot(comm, region, year, slice) =e= sum(trade$mTradeIrAInp2(trade, comm, region, year, slice), vTradeIrAInp(trade, comm, region, year, slice));

eqTradeIrAOutTot(comm, region, year, slice)$mTradeIrAOutTot(comm, region, year, slice)..
  vTradeIrAOutTot(comm, region, year, slice) =e= sum(trade$mTradeIrAOut2(trade, comm, region, year, slice), vTradeIrAOut(trade, comm, region, year, slice));

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

eqBalLo(comm, region, year, slice)$(mMidMilestone(year) and mLoComm(comm) and mCommSlice(comm, slice))..
         vBalance(comm, region, year, slice) =g= 0;

eqBalUp(comm, region, year, slice)$(mMidMilestone(year) and mUpComm(comm) and mCommSlice(comm, slice))..
         vBalance(comm, region, year, slice) =l= 0;

eqBalFx(comm, region, year, slice)$(mMidMilestone(year) and mFxComm(comm) and mCommSlice(comm, slice))..
         vBalance(comm, region, year, slice) =e= 0;

eqBal(comm, region, year, slice)$(mMidMilestone(year) and mCommSlice(comm, slice))..
         vBalance(comm, region, year, slice) =e= vOutTot(comm, region, year, slice) - vInpTot(comm, region, year, slice);

eqOutTot(comm, region, year, slice)$(mMidMilestone(year) and mCommSlice(comm, slice))..
         vOutTot(comm, region, year, slice)
         =e=
         vDummyImport(comm, region, year, slice)$mDummyImport(comm, region, year, slice) +
         sum(slicep$mAllSliceParentChildAndSame(slice, slicep),
                  vSupOutTot(comm, region, year, slicep)$mSupOutTot(comm, region, slicep) +
                  vEmsFuelTot(comm, region, year, slicep)$mEmsFuelTot(comm, region, year, slicep) +
                  vAggOut(comm, region, year, slicep)$mAggOut(comm, region, year, slicep) +
                  vTechOutTot(comm, region, year, slicep)$mTechOutTot(comm, region, year, slicep)  +
                  vStorageOutTot(comm, region, year, slicep)$mStorageOutTot(comm, region, year, slicep) +
                  vImport(comm, region, year, slicep)$mImport(comm, region, year, slicep) +
                  vTradeIrAOutTot(comm, region, year, slicep)$mTradeIrAOutTot(comm, region, year, slicep)
         ) +
         sum(slicep$(mAllSliceParentChild(slicep, slice) and mOut2Lo(comm, region, year, slicep)),
                 vOut2Lo(comm, region, year, slicep, slice));

eqOut2Lo(comm, region, year, slice)$mOut2Lo(comm, region, year, slice)..
         sum(slicep$(mAllSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)),
                 vOut2Lo(comm, region, year, slice, slicep))
         =e=
                  vSupOutTot(comm, region, year, slice)$mSupOutTot(comm, region, slice) +
                  vEmsFuelTot(comm, region, year, slice)$mEmsFuelTot(comm, region, year, slice) +
                  vAggOut(comm, region, year, slice)$mAggOut(comm, region, year, slice) +
                  vTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)  +
                  vStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice) +
                  vImport(comm, region, year, slice)$mImport(comm, region, year, slice) +
                  vTradeIrAOutTot(comm, region, year, slice)$mTradeIrAOutTot(comm, region, year, slice);

eqInpTot(comm, region, year, slice)$(mMidMilestone(year) and mCommSlice(comm, slice))..
         vInpTot(comm, region, year, slice)
         =e=
         vDemInp(comm, region, year, slice)$mDemInp(comm, slice) +
         vDummyExport(comm, region, year, slice)$mDummyExport(comm, region, year, slice) +
         sum(slicep$mAllSliceParentChildAndSame(slice, slicep),
                  vTechInpTot(comm, region, year, slicep)$mTechInpTot(comm, region, year, slicep) +
                  vStorageInpTot(comm, region, year, slicep)$mStorageInpTot(comm, region, year, slicep) +
                  vExport(comm, region, year, slicep)$mExport(comm, region, year, slicep) +
                  vTradeIrAInpTot(comm, region, year, slicep)$mTradeIrAInpTot(comm, region, year, slicep)
         ) + sum(slicep$(mAllSliceParentChild(slicep, slice) and mInp2Lo(comm, region, year, slicep)),
                 vInp2Lo(comm, region, year, slicep, slice));

eqInp2Lo(comm, region, year, slice)$mInp2Lo(comm, region, year, slice)..
        sum(slicep$(mAllSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)),
                 vInp2Lo(comm, region, year, slice, slicep))
         =e=
                  vTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice) +
                  vStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice) +
                  vExport(comm, region, year, slice)$mExport(comm, region, year, slice) +
                  vTradeIrAInpTot(comm, region, year, slice)$mTradeIrAInpTot(comm, region, year, slice);

eqSupOutTot(comm, region, year, slice)$(mMidMilestone(year) and mSupOutTot(comm, region, slice))..
         vSupOutTot(comm, region, year, slice) =e=
                 sum(sup$mSupAva(sup, comm, region, year, slice), vSupOut(sup, comm, region, year, slice));

eqTechInpTot(comm, region, year, slice)$mTechInpTot(comm, region, year, slice)..
         vTechInpTot(comm, region, year, slice)
         =e=
         sum(tech$(mTechSpan(tech, region, year) and mTechInpComm(tech, comm) and mTechSlice(tech, slice)),
             vTechInp(tech, comm, region, year, slice)) +
         sum(tech$(mTechSpan(tech, region, year) and mTechAInp(tech, comm) and mTechSlice(tech, slice)),
             vTechAInp(tech, comm, region, year, slice));

eqTechOutTot(comm, region, year, slice)$mTechOutTot(comm, region, year, slice)..
         vTechOutTot(comm, region, year, slice)
         =e=
         sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year)  and mTechSlice(tech, slice) and mTechOutComm(tech, comm)),
             vTechOut(tech, comm, region, year, slice)) +
         sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year)  and mTechSlice(tech, slice) and mTechAOut(tech, comm)),
             vTechAOut(tech, comm, region, year, slice));

eqStorageInpTot(comm, region, year, slice)$mStorageInpTot(comm, region, year, slice)..
         vStorageInpTot(comm, region, year, slice)
         =e=
         sum(stg$(mStorageComm(stg, comm) and pStorageInpEff(stg, comm, region, year, slice)
                 and mStorageSlice(stg, slice)and mStorageSpan(stg, region, year)),
                 vStorageInp(stg, comm, region, year, slice)
         ) +
         sum(stg$(mStorageAInp(stg, comm) and mStorageSlice(stg, slice) and mStorageSpan(stg, region, year)),
                 vStorageAInp(stg, comm, region, year, slice)
         );

eqStorageOutTot(comm, region, year, slice)$mStorageOutTot(comm, region, year, slice)..
         vStorageOutTot(comm, region, year, slice)
         =e=
         sum(stg$(mStorageComm(stg, comm) and pStorageOutEff(stg, comm, region, year, slice)
                 and mStorageSlice(stg, slice) and mStorageSpan(stg, region, year)),
                 vStorageOut(stg, comm, region, year, slice)
         ) +
         sum(stg$(mStorageAOut(stg, comm) and mStorageSlice(stg, slice) and mStorageSpan(stg, region, year)),
                 vStorageAOut(stg, comm, region, year, slice)
         );

**************************************
* Objective and aggregated costs equations
**************************************
Equation
eqCost(region, year)                Total costs
eqTaxCost(comm, region, year)       Commodity taxes
eqSubsCost(comm, region, year)      Commodity subsidy
eqDummyCost(comm, region, year)     Dummy import and export costs
eqObjective                         Objective equation
;

eqDummyCost(comm, region, year)$(mMidMilestone(year) and  mDummyCost(comm, region, year))..
         vDummyCost(comm, region, year)
         =e=
         sum(slice$mDummyImport(comm, region, year, slice),
           pDummyImportCost(comm, region, year, slice) * vDummyImport(comm, region, year, slice)) +
         sum(slice$mDummyExport(comm, region, year, slice),
           pDummyExportCost(comm, region, year, slice) * vDummyExport(comm, region, year, slice));

eqCost(region, year)$(mMidMilestone(year))..
         vCost(region, year)
         =e=
         sum(tech$mTechSpan(tech, region, year), vTechOMCost(tech, region, year))
         + sum(sup$mSupSpan(sup, region), vSupCost(sup, region, year))
         + sum(comm$mDummyCost(comm, region, year), vDummyCost(comm, region, year))
         + sum(comm$mTaxCost(comm, region, year), vTaxCost(comm, region, year))
         - sum(comm$mSubsCost(comm, region, year), vSubsCost(comm, region, year))
         + sum(stg$mStorageSpan(stg, region, year), vStorageCost(stg, region, year))
         + vTradeCost(region, year);

eqTaxCost(comm, region, year)$mTaxCost(comm, region, year)..
         vTaxCost(comm, region, year)
         =e= sum(slice$mCommSlice(comm, slice), pTaxCost(comm, region, year, slice) * vOutTot(comm, region, year, slice));

eqSubsCost(comm, region, year)$mSubsCost(comm, region, year)..
         vSubsCost(comm, region, year)
         =e= sum(slice$mCommSlice(comm, slice), pSubsCost(comm, region, year, slice) * vOutTot(comm, region, year, slice));

eqObjective..
   vObjective =e= sum((region, year, yearp)$(mMidMilestone(year) and mStartMilestone(year, yearp)),
           pDiscountFactor(region, yearp) *  sum(tech$mTechNew(tech, region, year), vTechInv(tech, region, year))) +
         sum((region, year)$mMidMilestone(year),
           vCost(region, year) * sum((yeare, yearp, yearn)$(mStartMilestone(year, yearp) and mEndMilestone(year, yeare)
                 and ordYear(yearn) >= ordYear(yearp) and ordYear(yearn) <= ordYear(yeare)), pDiscountFactor(region, yearn))) +
         sum((region, year, tech)$(mMilestoneLast(year) and  sum(yearp$mTechNew(tech, region, yearp), 1) <> 0),
                 pDiscountFactor(region, year) * vTechSalv(tech, region)) +
         sum((region, year, stg)$(mMilestoneLast(year) and  sum(yearp$mStorageNew(stg, region, yearp), 1) <> 0),
                 pDiscountFactor(region, year) * vStorageSalv(stg, region));

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

eqLECActivity(tech, region, year)$(mLECRegion(region) and mTechSpan(tech, region, year))..
         sum(slice$mTechSlice(tech, slice), vTechAct(tech, region, year, slice)) =g= pLECLoACT(region);

*$INCLUDE data.inc
* e0fc7d1e-fd81-4745-a0eb-2a142f837d1c

model energyRt /
********************************************************************************
* Activity Input & Output equations
********************************************************************************
* Equation Input fix activity & Output fix no activity
eqTechSng2Sng
eqTechGrp2Sng
eqTechSng2Grp
eqTechGrp2Grp
eqTechUse2Sng
eqTechUse2Grp
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
* Salvage value
*eqTechSalv1
eqTechSalv0
eqTechSalv
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
eqTechEmsFuel
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
* Salvage value
eqStorageSalv0
eqStorageSalv
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
eqDummyCost
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

* Place to insert your data
* ddd355e0-0023-45e9-b0d3-1ad83ba74b3a
*$EXIT

*option lp = cbc;

*$exit
* f374f3df-5fd6-44f1-b08a-1a09485cbe3d

Solve energyRt minimizing vObjective using LP;

file pModelStat_csv / 'pStat.csv'/;
pModelStat_csv.lp = 1;
put pModelStat_csv;
put "value"/;
put energyRt.Modelstat:0:9/;
putclose;
file pFinish2_csv / 'pFinish.csv'/;
pFinish2_csv.lp = 1;
put pFinish2_csv;
put "value"/;
put 2:0/;
putclose;

* 99089425-31110-4440-be57-2ca102e9cee1






file vTechInv_csv / 'vTechInv.csv'/;
vTechInv_csv.lp = 1;
vTechInv_csv.nd = 1;
vTechInv_csv.nz = 1e-25;
vTechInv_csv.nr = 2;
put vTechInv_csv;
put "tech,region,year,value"/;
loop((tech,region,year)$(vTechInv.l(tech,region,year) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0","vTechInv.l(tech,region,year):0:15/;);
putclose; 
file vTechEac_csv / 'vTechEac.csv'/;
vTechEac_csv.lp = 1;
vTechEac_csv.nd = 1;
vTechEac_csv.nz = 1e-25;
vTechEac_csv.nr = 2;
put vTechEac_csv;
put "tech,region,year,value"/;
loop((tech,region,year)$(vTechEac.l(tech,region,year) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0","vTechEac.l(tech,region,year):0:15/;);
putclose; 
file vTechSalv_csv / 'vTechSalv.csv'/;
vTechSalv_csv.lp = 1;
vTechSalv_csv.nd = 1;
vTechSalv_csv.nz = 1e-25;
vTechSalv_csv.nr = 2;
put vTechSalv_csv;
put "tech,region,value"/;
loop((tech,region)$vTechSalv.l(tech,region), put tech.tl:0",", region.tl:0","vTechSalv.l(tech,region):0:15/;);
putclose; 
file vTechOMCost_csv / 'vTechOMCost.csv'/;
vTechOMCost_csv.lp = 1;
vTechOMCost_csv.nd = 1;
vTechOMCost_csv.nz = 1e-25;
vTechOMCost_csv.nr = 2;
put vTechOMCost_csv;
put "tech,region,year,value"/;
loop((tech,region,year)$(vTechOMCost.l(tech,region,year) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0","vTechOMCost.l(tech,region,year):0:15/;);
putclose; 
file vSupCost_csv / 'vSupCost.csv'/;
vSupCost_csv.lp = 1;
vSupCost_csv.nd = 1;
vSupCost_csv.nz = 1e-25;
vSupCost_csv.nr = 2;
put vSupCost_csv;
put "sup,region,year,value"/;
loop((sup,region,year)$(vSupCost.l(sup,region,year) and mMidMilestone(year)), put sup.tl:0",", region.tl:0",", year.tl:0","vSupCost.l(sup,region,year):0:15/;);
putclose; 
file vEmsFuelTot_csv / 'vEmsFuelTot.csv'/;
vEmsFuelTot_csv.lp = 1;
vEmsFuelTot_csv.nd = 1;
vEmsFuelTot_csv.nz = 1e-25;
vEmsFuelTot_csv.nr = 2;
put vEmsFuelTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vEmsFuelTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vEmsFuelTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vTechEmsFuel_csv / 'vTechEmsFuel.csv'/;
vTechEmsFuel_csv.lp = 1;
vTechEmsFuel_csv.nd = 1;
vTechEmsFuel_csv.nz = 1e-25;
vTechEmsFuel_csv.nr = 2;
put vTechEmsFuel_csv;
put "tech,comm,region,year,slice,value"/;
loop((tech,comm,region,year,slice)$(vTechEmsFuel.l(tech,comm,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechEmsFuel.l(tech,comm,region,year,slice):0:15/;);
putclose; 
file vBalance_csv / 'vBalance.csv'/;
vBalance_csv.lp = 1;
vBalance_csv.nd = 1;
vBalance_csv.nz = 1e-25;
vBalance_csv.nr = 2;
put vBalance_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vBalance.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vBalance.l(comm,region,year,slice):0:15/;);
putclose; 
file vCost_csv / 'vCost.csv'/;
vCost_csv.lp = 1;
vCost_csv.nd = 1;
vCost_csv.nz = 1e-25;
vCost_csv.nr = 2;
put vCost_csv;
put "region,year,value"/;
loop((region,year)$(vCost.l(region,year) and mMidMilestone(year)), put region.tl:0",", year.tl:0","vCost.l(region,year):0:15/;);
putclose; 
file vObjective_csv / 'vObjective.csv'/;
vObjective_csv.lp = 1;
vObjective_csv.nd = 1;
vObjective_csv.nz = 1e-25;
vObjective_csv.nr = 2;
put vObjective_csv;
put "value"/vObjective.l:0:15/;
putclose;
file vTaxCost_csv / 'vTaxCost.csv'/;
vTaxCost_csv.lp = 1;
vTaxCost_csv.nd = 1;
vTaxCost_csv.nz = 1e-25;
vTaxCost_csv.nr = 2;
put vTaxCost_csv;
put "comm,region,year,value"/;
loop((comm,region,year)$(vTaxCost.l(comm,region,year) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0","vTaxCost.l(comm,region,year):0:15/;);
putclose; 
file vSubsCost_csv / 'vSubsCost.csv'/;
vSubsCost_csv.lp = 1;
vSubsCost_csv.nd = 1;
vSubsCost_csv.nz = 1e-25;
vSubsCost_csv.nr = 2;
put vSubsCost_csv;
put "comm,region,year,value"/;
loop((comm,region,year)$(vSubsCost.l(comm,region,year) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0","vSubsCost.l(comm,region,year):0:15/;);
putclose; 
file vAggOut_csv / 'vAggOut.csv'/;
vAggOut_csv.lp = 1;
vAggOut_csv.nd = 1;
vAggOut_csv.nz = 1e-25;
vAggOut_csv.nr = 2;
put vAggOut_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vAggOut.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vAggOut.l(comm,region,year,slice):0:15/;);
putclose; 
file vStorageSalv_csv / 'vStorageSalv.csv'/;
vStorageSalv_csv.lp = 1;
vStorageSalv_csv.nd = 1;
vStorageSalv_csv.nz = 1e-25;
vStorageSalv_csv.nr = 2;
put vStorageSalv_csv;
put "stg,region,value"/;
loop((stg,region)$vStorageSalv.l(stg,region), put stg.tl:0",", region.tl:0","vStorageSalv.l(stg,region):0:15/;);
putclose; 
file vStorageCost_csv / 'vStorageCost.csv'/;
vStorageCost_csv.lp = 1;
vStorageCost_csv.nd = 1;
vStorageCost_csv.nz = 1e-25;
vStorageCost_csv.nr = 2;
put vStorageCost_csv;
put "stg,region,year,value"/;
loop((stg,region,year)$(vStorageCost.l(stg,region,year) and mMidMilestone(year)), put stg.tl:0",", region.tl:0",", year.tl:0","vStorageCost.l(stg,region,year):0:15/;);
putclose; 
file vTradeCost_csv / 'vTradeCost.csv'/;
vTradeCost_csv.lp = 1;
vTradeCost_csv.nd = 1;
vTradeCost_csv.nz = 1e-25;
vTradeCost_csv.nr = 2;
put vTradeCost_csv;
put "region,year,value"/;
loop((region,year)$(vTradeCost.l(region,year) and mMidMilestone(year)), put region.tl:0",", year.tl:0","vTradeCost.l(region,year):0:15/;);
putclose; 
file vTradeRowCost_csv / 'vTradeRowCost.csv'/;
vTradeRowCost_csv.lp = 1;
vTradeRowCost_csv.nd = 1;
vTradeRowCost_csv.nz = 1e-25;
vTradeRowCost_csv.nr = 2;
put vTradeRowCost_csv;
put "region,year,value"/;
loop((region,year)$(vTradeRowCost.l(region,year) and mMidMilestone(year)), put region.tl:0",", year.tl:0","vTradeRowCost.l(region,year):0:15/;);
putclose; 
file vTradeIrCost_csv / 'vTradeIrCost.csv'/;
vTradeIrCost_csv.lp = 1;
vTradeIrCost_csv.nd = 1;
vTradeIrCost_csv.nz = 1e-25;
vTradeIrCost_csv.nr = 2;
put vTradeIrCost_csv;
put "region,year,value"/;
loop((region,year)$(vTradeIrCost.l(region,year) and mMidMilestone(year)), put region.tl:0",", year.tl:0","vTradeIrCost.l(region,year):0:15/;);
putclose; 
file vTechUse_csv / 'vTechUse.csv'/;
vTechUse_csv.lp = 1;
vTechUse_csv.nd = 1;
vTechUse_csv.nz = 1e-25;
vTechUse_csv.nr = 2;
put vTechUse_csv;
put "tech,region,year,slice,value"/;
loop((tech,region,year,slice)$(vTechUse.l(tech,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechUse.l(tech,region,year,slice):0:15/;);
putclose; 
file vTechNewCap_csv / 'vTechNewCap.csv'/;
vTechNewCap_csv.lp = 1;
vTechNewCap_csv.nd = 1;
vTechNewCap_csv.nz = 1e-25;
vTechNewCap_csv.nr = 2;
put vTechNewCap_csv;
put "tech,region,year,value"/;
loop((tech,region,year)$(vTechNewCap.l(tech,region,year) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0","vTechNewCap.l(tech,region,year):0:15/;);
putclose; 
file vTechRetiredCap_csv / 'vTechRetiredCap.csv'/;
vTechRetiredCap_csv.lp = 1;
vTechRetiredCap_csv.nd = 1;
vTechRetiredCap_csv.nz = 1e-25;
vTechRetiredCap_csv.nr = 2;
put vTechRetiredCap_csv;
put "tech,region,year,yearp,value"/;
loop((tech,region,year,yearp)$(vTechRetiredCap.l(tech,region,year,yearp) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0",", yearp.tl:0","vTechRetiredCap.l(tech,region,year,yearp):0:15/;);
putclose; 
file vTechCap_csv / 'vTechCap.csv'/;
vTechCap_csv.lp = 1;
vTechCap_csv.nd = 1;
vTechCap_csv.nz = 1e-25;
vTechCap_csv.nr = 2;
put vTechCap_csv;
put "tech,region,year,value"/;
loop((tech,region,year)$(vTechCap.l(tech,region,year) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0","vTechCap.l(tech,region,year):0:15/;);
putclose; 
file vTechAct_csv / 'vTechAct.csv'/;
vTechAct_csv.lp = 1;
vTechAct_csv.nd = 1;
vTechAct_csv.nz = 1e-25;
vTechAct_csv.nr = 2;
put vTechAct_csv;
put "tech,region,year,slice,value"/;
loop((tech,region,year,slice)$(vTechAct.l(tech,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechAct.l(tech,region,year,slice):0:15/;);
putclose; 
file vTechInp_csv / 'vTechInp.csv'/;
vTechInp_csv.lp = 1;
vTechInp_csv.nd = 1;
vTechInp_csv.nz = 1e-25;
vTechInp_csv.nr = 2;
put vTechInp_csv;
put "tech,comm,region,year,slice,value"/;
loop((tech,comm,region,year,slice)$(vTechInp.l(tech,comm,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechInp.l(tech,comm,region,year,slice):0:15/;);
putclose; 
file vTechOut_csv / 'vTechOut.csv'/;
vTechOut_csv.lp = 1;
vTechOut_csv.nd = 1;
vTechOut_csv.nz = 1e-25;
vTechOut_csv.nr = 2;
put vTechOut_csv;
put "tech,comm,region,year,slice,value"/;
loop((tech,comm,region,year,slice)$(vTechOut.l(tech,comm,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechOut.l(tech,comm,region,year,slice):0:15/;);
putclose; 
file vTechAInp_csv / 'vTechAInp.csv'/;
vTechAInp_csv.lp = 1;
vTechAInp_csv.nd = 1;
vTechAInp_csv.nz = 1e-25;
vTechAInp_csv.nr = 2;
put vTechAInp_csv;
put "tech,comm,region,year,slice,value"/;
loop((tech,comm,region,year,slice)$(vTechAInp.l(tech,comm,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechAInp.l(tech,comm,region,year,slice):0:15/;);
putclose; 
file vTechAOut_csv / 'vTechAOut.csv'/;
vTechAOut_csv.lp = 1;
vTechAOut_csv.nd = 1;
vTechAOut_csv.nz = 1e-25;
vTechAOut_csv.nr = 2;
put vTechAOut_csv;
put "tech,comm,region,year,slice,value"/;
loop((tech,comm,region,year,slice)$(vTechAOut.l(tech,comm,region,year,slice) and mMidMilestone(year)), put tech.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechAOut.l(tech,comm,region,year,slice):0:15/;);
putclose; 
file vSupOut_csv / 'vSupOut.csv'/;
vSupOut_csv.lp = 1;
vSupOut_csv.nd = 1;
vSupOut_csv.nz = 1e-25;
vSupOut_csv.nr = 2;
put vSupOut_csv;
put "sup,comm,region,year,slice,value"/;
loop((sup,comm,region,year,slice)$(vSupOut.l(sup,comm,region,year,slice) and mMidMilestone(year)), put sup.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vSupOut.l(sup,comm,region,year,slice):0:15/;);
putclose; 
file vSupReserve_csv / 'vSupReserve.csv'/;
vSupReserve_csv.lp = 1;
vSupReserve_csv.nd = 1;
vSupReserve_csv.nz = 1e-25;
vSupReserve_csv.nr = 2;
put vSupReserve_csv;
put "sup,comm,region,value"/;
loop((sup,comm,region)$vSupReserve.l(sup,comm,region), put sup.tl:0",", comm.tl:0",", region.tl:0","vSupReserve.l(sup,comm,region):0:15/;);
putclose; 
file vDemInp_csv / 'vDemInp.csv'/;
vDemInp_csv.lp = 1;
vDemInp_csv.nd = 1;
vDemInp_csv.nz = 1e-25;
vDemInp_csv.nr = 2;
put vDemInp_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vDemInp.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vDemInp.l(comm,region,year,slice):0:15/;);
putclose; 
file vOutTot_csv / 'vOutTot.csv'/;
vOutTot_csv.lp = 1;
vOutTot_csv.nd = 1;
vOutTot_csv.nz = 1e-25;
vOutTot_csv.nr = 2;
put vOutTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vOutTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vOutTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vInpTot_csv / 'vInpTot.csv'/;
vInpTot_csv.lp = 1;
vInpTot_csv.nd = 1;
vInpTot_csv.nz = 1e-25;
vInpTot_csv.nr = 2;
put vInpTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vInpTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vInpTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vInp2Lo_csv / 'vInp2Lo.csv'/;
vInp2Lo_csv.lp = 1;
vInp2Lo_csv.nd = 1;
vInp2Lo_csv.nz = 1e-25;
vInp2Lo_csv.nr = 2;
put vInp2Lo_csv;
put "comm,region,year,slice,slicep,value"/;
loop((comm,region,year,slice,slicep)$(vInp2Lo.l(comm,region,year,slice,slicep) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0",", slicep.tl:0","vInp2Lo.l(comm,region,year,slice,slicep):0:15/;);
putclose; 
file vOut2Lo_csv / 'vOut2Lo.csv'/;
vOut2Lo_csv.lp = 1;
vOut2Lo_csv.nd = 1;
vOut2Lo_csv.nz = 1e-25;
vOut2Lo_csv.nr = 2;
put vOut2Lo_csv;
put "comm,region,year,slice,slicep,value"/;
loop((comm,region,year,slice,slicep)$(vOut2Lo.l(comm,region,year,slice,slicep) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0",", slicep.tl:0","vOut2Lo.l(comm,region,year,slice,slicep):0:15/;);
putclose; 
file vSupOutTot_csv / 'vSupOutTot.csv'/;
vSupOutTot_csv.lp = 1;
vSupOutTot_csv.nd = 1;
vSupOutTot_csv.nz = 1e-25;
vSupOutTot_csv.nr = 2;
put vSupOutTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vSupOutTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vSupOutTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vTechInpTot_csv / 'vTechInpTot.csv'/;
vTechInpTot_csv.lp = 1;
vTechInpTot_csv.nd = 1;
vTechInpTot_csv.nz = 1e-25;
vTechInpTot_csv.nr = 2;
put vTechInpTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vTechInpTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechInpTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vTechOutTot_csv / 'vTechOutTot.csv'/;
vTechOutTot_csv.lp = 1;
vTechOutTot_csv.nd = 1;
vTechOutTot_csv.nz = 1e-25;
vTechOutTot_csv.nr = 2;
put vTechOutTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vTechOutTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTechOutTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vStorageInpTot_csv / 'vStorageInpTot.csv'/;
vStorageInpTot_csv.lp = 1;
vStorageInpTot_csv.nd = 1;
vStorageInpTot_csv.nz = 1e-25;
vStorageInpTot_csv.nr = 2;
put vStorageInpTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vStorageInpTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageInpTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vStorageOutTot_csv / 'vStorageOutTot.csv'/;
vStorageOutTot_csv.lp = 1;
vStorageOutTot_csv.nd = 1;
vStorageOutTot_csv.nz = 1e-25;
vStorageOutTot_csv.nr = 2;
put vStorageOutTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vStorageOutTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageOutTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vStorageAInp_csv / 'vStorageAInp.csv'/;
vStorageAInp_csv.lp = 1;
vStorageAInp_csv.nd = 1;
vStorageAInp_csv.nz = 1e-25;
vStorageAInp_csv.nr = 2;
put vStorageAInp_csv;
put "stg,comm,region,year,slice,value"/;
loop((stg,comm,region,year,slice)$(vStorageAInp.l(stg,comm,region,year,slice) and mMidMilestone(year)), put stg.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageAInp.l(stg,comm,region,year,slice):0:15/;);
putclose; 
file vStorageAOut_csv / 'vStorageAOut.csv'/;
vStorageAOut_csv.lp = 1;
vStorageAOut_csv.nd = 1;
vStorageAOut_csv.nz = 1e-25;
vStorageAOut_csv.nr = 2;
put vStorageAOut_csv;
put "stg,comm,region,year,slice,value"/;
loop((stg,comm,region,year,slice)$(vStorageAOut.l(stg,comm,region,year,slice) and mMidMilestone(year)), put stg.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageAOut.l(stg,comm,region,year,slice):0:15/;);
putclose; 
file vDummyImport_csv / 'vDummyImport.csv'/;
vDummyImport_csv.lp = 1;
vDummyImport_csv.nd = 1;
vDummyImport_csv.nz = 1e-25;
vDummyImport_csv.nr = 2;
put vDummyImport_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vDummyImport.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vDummyImport.l(comm,region,year,slice):0:15/;);
putclose; 
file vDummyExport_csv / 'vDummyExport.csv'/;
vDummyExport_csv.lp = 1;
vDummyExport_csv.nd = 1;
vDummyExport_csv.nz = 1e-25;
vDummyExport_csv.nr = 2;
put vDummyExport_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vDummyExport.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vDummyExport.l(comm,region,year,slice):0:15/;);
putclose; 
file vDummyCost_csv / 'vDummyCost.csv'/;
vDummyCost_csv.lp = 1;
vDummyCost_csv.nd = 1;
vDummyCost_csv.nz = 1e-25;
vDummyCost_csv.nr = 2;
put vDummyCost_csv;
put "comm,region,year,value"/;
loop((comm,region,year)$(vDummyCost.l(comm,region,year) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0","vDummyCost.l(comm,region,year):0:15/;);
putclose; 
file vStorageInp_csv / 'vStorageInp.csv'/;
vStorageInp_csv.lp = 1;
vStorageInp_csv.nd = 1;
vStorageInp_csv.nz = 1e-25;
vStorageInp_csv.nr = 2;
put vStorageInp_csv;
put "stg,comm,region,year,slice,value"/;
loop((stg,comm,region,year,slice)$(vStorageInp.l(stg,comm,region,year,slice) and mMidMilestone(year)), put stg.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageInp.l(stg,comm,region,year,slice):0:15/;);
putclose; 
file vStorageOut_csv / 'vStorageOut.csv'/;
vStorageOut_csv.lp = 1;
vStorageOut_csv.nd = 1;
vStorageOut_csv.nz = 1e-25;
vStorageOut_csv.nr = 2;
put vStorageOut_csv;
put "stg,comm,region,year,slice,value"/;
loop((stg,comm,region,year,slice)$(vStorageOut.l(stg,comm,region,year,slice) and mMidMilestone(year)), put stg.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageOut.l(stg,comm,region,year,slice):0:15/;);
putclose; 
file vStorageStore_csv / 'vStorageStore.csv'/;
vStorageStore_csv.lp = 1;
vStorageStore_csv.nd = 1;
vStorageStore_csv.nz = 1e-25;
vStorageStore_csv.nr = 2;
put vStorageStore_csv;
put "stg,comm,region,year,slice,value"/;
loop((stg,comm,region,year,slice)$(vStorageStore.l(stg,comm,region,year,slice) and mMidMilestone(year)), put stg.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vStorageStore.l(stg,comm,region,year,slice):0:15/;);
putclose; 
file vStorageInv_csv / 'vStorageInv.csv'/;
vStorageInv_csv.lp = 1;
vStorageInv_csv.nd = 1;
vStorageInv_csv.nz = 1e-25;
vStorageInv_csv.nr = 2;
put vStorageInv_csv;
put "stg,region,year,value"/;
loop((stg,region,year)$(vStorageInv.l(stg,region,year) and mMidMilestone(year)), put stg.tl:0",", region.tl:0",", year.tl:0","vStorageInv.l(stg,region,year):0:15/;);
putclose; 
file vStorageCap_csv / 'vStorageCap.csv'/;
vStorageCap_csv.lp = 1;
vStorageCap_csv.nd = 1;
vStorageCap_csv.nz = 1e-25;
vStorageCap_csv.nr = 2;
put vStorageCap_csv;
put "stg,region,year,value"/;
loop((stg,region,year)$(vStorageCap.l(stg,region,year) and mMidMilestone(year)), put stg.tl:0",", region.tl:0",", year.tl:0","vStorageCap.l(stg,region,year):0:15/;);
putclose; 
file vStorageNewCap_csv / 'vStorageNewCap.csv'/;
vStorageNewCap_csv.lp = 1;
vStorageNewCap_csv.nd = 1;
vStorageNewCap_csv.nz = 1e-25;
vStorageNewCap_csv.nr = 2;
put vStorageNewCap_csv;
put "stg,region,year,value"/;
loop((stg,region,year)$(vStorageNewCap.l(stg,region,year) and mMidMilestone(year)), put stg.tl:0",", region.tl:0",", year.tl:0","vStorageNewCap.l(stg,region,year):0:15/;);
putclose; 
file vImport_csv / 'vImport.csv'/;
vImport_csv.lp = 1;
vImport_csv.nd = 1;
vImport_csv.nz = 1e-25;
vImport_csv.nr = 2;
put vImport_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vImport.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vImport.l(comm,region,year,slice):0:15/;);
putclose; 
file vExport_csv / 'vExport.csv'/;
vExport_csv.lp = 1;
vExport_csv.nd = 1;
vExport_csv.nz = 1e-25;
vExport_csv.nr = 2;
put vExport_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vExport.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vExport.l(comm,region,year,slice):0:15/;);
putclose; 
file vTradeIr_csv / 'vTradeIr.csv'/;
vTradeIr_csv.lp = 1;
vTradeIr_csv.nd = 1;
vTradeIr_csv.nz = 1e-25;
vTradeIr_csv.nr = 2;
put vTradeIr_csv;
put "trade,comm,src,dst,year,slice,value"/;
loop((trade,comm,region,regionp,year,slice)$(vTradeIr.l(trade,comm,region,regionp,year,slice) and mMidMilestone(year)), put trade.tl:0",", comm.tl:0",", region.tl:0",", regionp.tl:0",", year.tl:0",", slice.tl:0","vTradeIr.l(trade,comm,region,regionp,year,slice):0:15/;);
putclose; 
file vTradeIrAInp_csv / 'vTradeIrAInp.csv'/;
vTradeIrAInp_csv.lp = 1;
vTradeIrAInp_csv.nd = 1;
vTradeIrAInp_csv.nz = 1e-25;
vTradeIrAInp_csv.nr = 2;
put vTradeIrAInp_csv;
put "trade,comm,region,year,slice,value"/;
loop((trade,comm,region,year,slice)$(vTradeIrAInp.l(trade,comm,region,year,slice) and mMidMilestone(year)), put trade.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTradeIrAInp.l(trade,comm,region,year,slice):0:15/;);
putclose; 
file vTradeIrAInpTot_csv / 'vTradeIrAInpTot.csv'/;
vTradeIrAInpTot_csv.lp = 1;
vTradeIrAInpTot_csv.nd = 1;
vTradeIrAInpTot_csv.nz = 1e-25;
vTradeIrAInpTot_csv.nr = 2;
put vTradeIrAInpTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vTradeIrAInpTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTradeIrAInpTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vTradeIrAOut_csv / 'vTradeIrAOut.csv'/;
vTradeIrAOut_csv.lp = 1;
vTradeIrAOut_csv.nd = 1;
vTradeIrAOut_csv.nz = 1e-25;
vTradeIrAOut_csv.nr = 2;
put vTradeIrAOut_csv;
put "trade,comm,region,year,slice,value"/;
loop((trade,comm,region,year,slice)$(vTradeIrAOut.l(trade,comm,region,year,slice) and mMidMilestone(year)), put trade.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTradeIrAOut.l(trade,comm,region,year,slice):0:15/;);
putclose; 
file vTradeIrAOutTot_csv / 'vTradeIrAOutTot.csv'/;
vTradeIrAOutTot_csv.lp = 1;
vTradeIrAOutTot_csv.nd = 1;
vTradeIrAOutTot_csv.nz = 1e-25;
vTradeIrAOutTot_csv.nr = 2;
put vTradeIrAOutTot_csv;
put "comm,region,year,slice,value"/;
loop((comm,region,year,slice)$(vTradeIrAOutTot.l(comm,region,year,slice) and mMidMilestone(year)), put comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vTradeIrAOutTot.l(comm,region,year,slice):0:15/;);
putclose; 
file vExportRowAccumulated_csv / 'vExportRowAccumulated.csv'/;
vExportRowAccumulated_csv.lp = 1;
vExportRowAccumulated_csv.nd = 1;
vExportRowAccumulated_csv.nz = 1e-25;
vExportRowAccumulated_csv.nr = 2;
put vExportRowAccumulated_csv;
put "expp,comm,value"/;
loop((expp,comm)$vExportRowAccumulated.l(expp,comm), put expp.tl:0",", comm.tl:0","vExportRowAccumulated.l(expp,comm):0:15/;);
putclose; 
file vExportRow_csv / 'vExportRow.csv'/;
vExportRow_csv.lp = 1;
vExportRow_csv.nd = 1;
vExportRow_csv.nz = 1e-25;
vExportRow_csv.nr = 2;
put vExportRow_csv;
put "expp,comm,region,year,slice,value"/;
loop((expp,comm,region,year,slice)$(vExportRow.l(expp,comm,region,year,slice) and mMidMilestone(year)), put expp.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vExportRow.l(expp,comm,region,year,slice):0:15/;);
putclose; 
file vImportRowAccumulated_csv / 'vImportRowAccumulated.csv'/;
vImportRowAccumulated_csv.lp = 1;
vImportRowAccumulated_csv.nd = 1;
vImportRowAccumulated_csv.nz = 1e-25;
vImportRowAccumulated_csv.nr = 2;
put vImportRowAccumulated_csv;
put "imp,comm,value"/;
loop((imp,comm)$vImportRowAccumulated.l(imp,comm), put imp.tl:0",", comm.tl:0","vImportRowAccumulated.l(imp,comm):0:15/;);
putclose; 
file vImportRow_csv / 'vImportRow.csv'/;
vImportRow_csv.lp = 1;
vImportRow_csv.nd = 1;
vImportRow_csv.nz = 1e-25;
vImportRow_csv.nr = 2;
put vImportRow_csv;
put "imp,comm,region,year,slice,value"/;
loop((imp,comm,region,year,slice)$(vImportRow.l(imp,comm,region,year,slice) and mMidMilestone(year)), put imp.tl:0",", comm.tl:0",", region.tl:0",", year.tl:0",", slice.tl:0","vImportRow.l(imp,comm,region,year,slice):0:15/;);
putclose; 
file variable_list_csv / 'variable_list.csv'/;
variable_list_csv.lp = 1;
put variable_list_csv;
    put "value"/;
    put "vTechInv"/;
    put "vTechEac"/;
    put "vTechSalv"/;
    put "vTechOMCost"/;
    put "vSupCost"/;
    put "vEmsFuelTot"/;
    put "vTechEmsFuel"/;
    put "vBalance"/;
    put "vCost"/;
    put "vObjective"/;
    put "vTaxCost"/;
    put "vSubsCost"/;
    put "vAggOut"/;
    put "vStorageSalv"/;
    put "vStorageCost"/;
    put "vTradeCost"/;
    put "vTradeRowCost"/;
    put "vTradeIrCost"/;
    put "vTechUse"/;
    put "vTechNewCap"/;
    put "vTechRetiredCap"/;
    put "vTechCap"/;
    put "vTechAct"/;
    put "vTechInp"/;
    put "vTechOut"/;
    put "vTechAInp"/;
    put "vTechAOut"/;
    put "vSupOut"/;
    put "vSupReserve"/;
    put "vDemInp"/;
    put "vOutTot"/;
    put "vInpTot"/;
    put "vInp2Lo"/;
    put "vOut2Lo"/;
    put "vSupOutTot"/;
    put "vTechInpTot"/;
    put "vTechOutTot"/;
    put "vStorageInpTot"/;
    put "vStorageOutTot"/;
    put "vStorageAInp"/;
    put "vStorageAOut"/;
    put "vDummyImport"/;
    put "vDummyExport"/;
    put "vDummyCost"/;
    put "vStorageInp"/;
    put "vStorageOut"/;
    put "vStorageStore"/;
    put "vStorageInv"/;
    put "vStorageCap"/;
    put "vStorageNewCap"/;
    put "vImport"/;
    put "vExport"/;
    put "vTradeIr"/;
    put "vTradeIrAInp"/;
    put "vTradeIrAInpTot"/;
    put "vTradeIrAOut"/;
    put "vTradeIrAOutTot"/;
    put "vExportRowAccumulated"/;
    put "vExportRow"/;
    put "vImportRowAccumulated"/;
    put "vImportRow"/;
 putclose;
file raw_data_set_csv / 'raw_data_set.csv'/;
raw_data_set_csv.lp = 1;
put raw_data_set_csv;
put "set,value"/;
loop(tech, put "tech,"tech.tl:0/;);
loop(sup, put "sup,"sup.tl:0/;);
loop(dem, put "dem,"dem.tl:0/;);
loop(stg, put "stg,"stg.tl:0/;);
loop(expp, put "expp,"expp.tl:0/;);
loop(imp, put "imp,"imp.tl:0/;);
loop(trade, put "trade,"trade.tl:0/;);
loop(group, put "group,"group.tl:0/;);
loop(comm, put "comm,"comm.tl:0/;);
loop(region, put "region,"region.tl:0/;);
loop(year$mMidMilestone(year), put "year,"year.tl:0/;);
loop(slice, put "slice,"slice.tl:0/;);
loop(weather, put "weather,"weather.tl:0/;);
putclose;


* 47b574db-2b0b-4556-a2e1-b323430d6ae6

