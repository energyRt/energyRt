$ontext
<<<<<<< HEAD
#!onLatex
=======
>>>>>>> 59858bf63953f28d2c24fd90456ced6d76912388
\documentclass{article}
\usepackage[a4paper,landscape,margin=1in]{geometry}
\usepackage[utf8]{inputenc}
\usepackage{breqn}
\usepackage{longtable}
\usepackage{graphicx}
\title{Implementation of energyRt Reference Energy System model in GAMS}
\date{July 1, 2016}
\author{Oleg Lugovoy \and Vladimir Potashnikov}
\begin{document}
\maketitle
   \begin{abstract}
         The model is a part of \textbf{energyRt} package for energy systems modeling in \textbf{R}
         (\url{https://github.com/olugovoy/energyRt}), developed by Oleg Lugovoy and Vladimir Potashnikov,
         and implemented in GAMS and GLPK/MathProg by Vladimir Potashnikov.
<<<<<<< HEAD
         The package and the code of the model is dessiminated under GNU Affero General Public License (AGPL-3)
         free public license (see \url{https://www.gnu.org/licenses/agpl.html} for details).
   \end{abstract}
\end{document}
#!offLatex
=======
   \end{abstract}

>>>>>>> 59858bf63953f28d2c24fd90456ced6d76912388
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
;

Alias (tech, techp), (region, regionp), (year, yearp), (year, yeare), (year, yearn);
Alias (slice, slicep), (group, groupp), (comm, commp), (comm, acomm), (comm, comme), (sup, supp);

* Mapping sets
set
*! technology:input
mMilestoneLast(year)           Last period milestone
mStartMilestone(year, year)    ???
mEndMilestone(year, year)      ???
mMidMilestone(year)            ???
mTechRetirement(tech)          Early retirement option
mTechUpgrade(tech, tech)       Upgrade by this technology possible for techp
mTechInpComm(tech, comm)       Input main commodity
mTechOutComm(tech, comm)       Output main commodity
mTechInpGroup(tech, group)     Group input
mTechOutGroup(tech, group)     Group output
mTechOneComm(tech, comm)       Commodity without group
*
mTechGroupComm(tech, group, comm)  Mapping between commodity-groups and commodities
* Aux input comm map
mTechAInp(tech, comm)            Auxiliary input commodity
mTechCinpAInp(tech, comm, comm)  to Inp aux inp commodity (second commodity is main)
mTechCoutAInp(tech, comm, comm)  to Out aux inp commodity (second commodity is main)
* Aux output comm map
mTechAOut(tech, comm)            Auxiliary output commodity
mTechCinpAOut(tech, comm, comm)  to Inp aux out commodity (second commodity is main)
mTechCoutAOut(tech, comm, comm)  to Out aux out commodity (second commodity is main)
*
mTechNew(tech, region, year)     Technologies available for investment
mTechSpan(tech, region, year)    Assisting set showing if the tech may exist in the time-span and region
* Emissions
mTechEmitedComm(tech, comm)      Mapping for emissions and technologies
* Supply
mSupComm(sup, comm)              Mapping for supply commodities
* Demand
mDemComm(dem, comm)              Mapping for demand commodities
* Ballance
mUpComm(comm)  Commodity balance type PRODUCTION <= CONSUMPTION
mLoComm(comm)  Commodity balance type PRODUCTION >= CONSUMPTION
mFxComm(comm)  Commodity balance type PRODUCTION = CONSUMPTION
defpTechAfaUp(tech, region, year, slice)         Auxiliary mapping for Inf - used in GLPK-MathProg only
defpTechAfacUp(tech, comm, region, year, slice)  Auxiliary mapping for Inf - used in GLPK-MathProg only
defpSupReserve(sup)                              Auxiliary mapping for Inf - used in GLPK-MathProg only
defpSupAvaUp(sup, region, year, slice)           Auxiliary mapping for Inf - used in GLPK-MathProg only
defpDumCost(comm, region, year, slice)           Auxiliary mapping for Inf - used in GLPK-MathProg only
* Storage set
$ontext
<<<<<<< HEAD
*# RENAME
=======
>>>>>>> 59858bf63953f28d2c24fd90456ced6d76912388
$offtext
mStorageComm(stg, comm)                              Mapping of storage technology and respective commodity
* Storage
defpStorageCapUp(stg, region, year)              Auxiliary mapping for Inf - used in GLPK-MathProg only
mSlicePrevious(slice, slice)                     Mapping of slices for storage techs
mSlicePreviousYear(slice)                        Mapping of slices for storage techs
* Trade and ROW
mTradeComm(trade, comm)                          Mapping of trade commodities
mExpComm(expp, comm)                             Mapping of export commodities
mImpComm(imp, comm)                              Mapping for import commodities
defpTradeFlowUp(trade, region, region, year, slice)     Auxiliary mapping for Inf - used in GLPK-MathProg only
defpRowExportRes(expp)                                  Auxiliary mapping for Inf - used in GLPK-MathProg only
defpRowExportUp(expp, region, year, slice)              Auxiliary mapping for Inf - used in GLPK-MathProg only
defpRowImportRes(imp)                                   Auxiliary mapping for Inf - used in GLPK-MathProg only
defpRowImportUp(imp, region, year, slice)               Auxiliary mapping for Inf - used in GLPK-MathProg only
* Zero discount
mDiscountZero(region)                            Auxiliary mapping mapping for  regions with zero discount
;

* Set priority
* t, sup, g, c, r, y, s
* tech, sup, group, comm, region, year, slice
* Parameter
parameter
pMilestone1(year, year)                            ???
pMilestone2(year, year)                            ???
* Aggregate
pAggregateFactor(comm, comm)                       Aggragation factor of
* Technology parameter
pTechOlife(tech, region)                           Operational life of technologies

pTechCinp2ginp(tech, comm, region, year, slice)    Multiplying factor for a commodity intput to obtain group input
pTechGinp2use(tech, group, region, year, slice)    Multiplying factor for a group input commodity to obtain use
pTechCinp2use(tech, comm, region, year, slice)     Multiplying factor for a commodity input commodity to obtain use
pTechUse2cact(tech, comm, region, year, slice)     Multiplying factor for use to obtain commodity activity
pTechCact2cout(tech, comm, region, year, slice)    Multiplying factor for commodity activity use to obtain commodity output
pTechEmisComm(tech, comm)                          Combustion factor for input commodity (from 0 to 1)
* Auxiliary input commodities
pTechUse2AInp(tech, comm, region, year, slice)     Multiplying factor for use to obtain aux-commodity input
pTechAct2AInp(tech, comm, region, year, slice)     Multiplying factor for activity to obtain aux-commodity input
pTechCap2AInp(tech, comm, region, year, slice)     Multiplying factor for capacity to obtain aux-commodity input
pTechCinp2AInp(tech, comm, comm, region, year, slice)    Multiplying factor for commodity-input to obtain aux-commodity input
pTechCout2AInp(tech, comm, comm, region, year, slice)    Multiplying factor for commodity-output to obtain aux-commodity input
* Aux output comm map
pTechUse2AOut(tech, comm, region, year, slice)     Multiplying factor for use to obtain aux-commodity output
pTechAct2AOut(tech, comm, region, year, slice)     Multiplying factor for activity to obtain aux-commodity output
pTechCap2AOut(tech, comm, region, year, slice)     Multiplying factor for capacity to obtain aux-commodity output
pTechCinp2AOut(tech, comm, comm, region, year, slice)     Multiplying factor for commodity to obtain aux-commodity output
pTechCout2AOut(tech, comm, comm, region, year, slice)     Multiplying factor for commodity-output to obtain aux-commodity input
*
pTechFixom(tech, region, year)                      Fixed Operating and maintenance (O&M) costs (per unit of capacity)
pTechVarom(tech, region, year, slice)               Variable  O&M costs (per unit of acticity)
pTechInvcost(tech, region, year)                    Investment costs (per unit of capacity)
pTechShareLo(tech, comm, region, year, slice)       Lower bound for share of the commodity in total group input or output
pTechShareUp(tech, comm, region, year, slice)       Upper bound for share of the commodity in total group input or output
pTechAfaLo(tech, region, year, slice)               Lower bound for activity
pTechAfaUp(tech, region, year, slice)               Upper bound for activity
pTechAfacLo(tech, comm, region, year, slice)        Lower bound for commodity output
pTechAfacUp(tech, comm, region, year, slice)        Upper bound for commodity output
pTechStock(tech, region, year)                      Technology capacity stock (accumulated in previous years production capacities)
pTechCap2act(tech)                                  Technology capacity units to activity units conversion factor
pTechCvarom(tech, comm, region, year, slice)        Commodity-specific variable costs (per unit of the commodity input or output)
* Exit stock and salvage
pDiscount(region, year)                             Discount rate (can be region and year specific)
*# RENAME  pDiscountFactor
pDiscountFactor(region, year)                       Discount factor (cumulative)
* Supply
pSupCost(sup, region, year, slice)                  Costs of supply
pSupAvaUp(sup, region, year, slice)                 Upper bound for supply
pSupAvaLo(sup, region, year, slice)                 Lower bound for supply
pSupReserve(sup)                                    Total supply reserve
* Demand
pDemand(dem, region, year, slice)                   Exogenous demand
* Emissions
pEmissionFactor(comm, comm)                         Emission factor
* Dummy import
pDumCost(comm, region, year, slice)                 Dummy costs parameters
* Tax
pTaxCost(comm, region, year, slice)                 Taxes
pSubsCost(comm, region, year, slice)                Subsidies
;

* Storage technology parameters
parameter
pStorageInpLoss(stg, region, year, slice)           Storage input losses
pStorageOutLoss(stg, region, year, slice)           Storage output losses
pStorageStoreLoss(stg, region, year, slice)         Storage storing losses
pStorageStock(stg, region, year)                    Storage stock
pStorageOlife(stg, region)                          Storage operational life
pStorageCapUp(stg, region, year)                    Storage upper bound on capacity
pStorageCapLo(stg, region, year)                    Storage lower bound on capacity
pStorageCostStore(stg, region, year, slice)         Storing costs
pStorageCostInp(stg, region, year, slice)           Storage input costs
pStorageCostOut(stg, region, year, slice)           Storage output costs
pStorageFixom(stg, region, year)                    Storage fixed O&M costs
pStorageInvcost(stg, region, year)                  Storage investment costs
pStorageStoreStock(stg, region, year, slice)        Storage capacity stock
;
* Trade parameters
parameter
pTradeFlowUp(trade, region, region, year, slice)     Upper bound on trage flow
pTradeFlowLo(trade, region, region, year, slice)     Lower bound on trade flow
pTradeFlowCost(trade, region, region, year, slice)   Costs of trade flow
pRowExportRes(expp)                                  Upper bound on accumulated export to ROW
pRowExportUp(expp, region, year, slice)              Upper bound on export to ROW
pRowExportLo(expp, region, year, slice)              Lower bound on export to ROW
pRowExportPrice(expp, region, year, slice)           Export prices to ROW
pRowImportRes(imp)                                   Upper bound on accumulated import to ROW
pRowImportUp(imp, region, year, slice)               Upper bount on import from ROW
pRowImportLo(imp, region, year, slice)               Lower bound on import from ROW
pRowImportPrice(imp, region, year, slice)            Import prices from ROW
;

$ontext
<<<<<<< HEAD
* Endogenous variables
** Technology
=======
* Endigenous variables
>>>>>>> 59858bf63953f28d2c24fd90456ced6d76912388
$offtext
positive variable
vTechUse(tech, region, year, slice)                  Use level in technology
vTechNewCap(tech, region, year)                      New capacity
vTechRetirementCap(tech, region, year, year)         ??? Early retired capacity
*vTechRetrofitCap(tech, region, year, year)
*vTechUpgradeCap(tech, region, year)
* Activity and intput-output
vTechCap(tech, region, year)                         Total capacity of the technology
vTechAct(tech, region, year, slice)                  Activity level of technology
vTechInp(tech, comm, region, year, slice)            Input level
vTechOut(tech, comm, region, year, slice)            Output level
* Auxiliary input & output
vTechAInp(tech, comm, region, year, slice)           Auxiliary commodity input
vTechAOut(tech, comm, region, year, slice)           Auxiliary commodity output
;
variable
vTechInv(tech, region, year)                         Investment
vTechSalv(tech, region)                              Salvage costs
vTechCost(tech, region, year)                        ??? VAROM + FIXOM???
;
positive variable
* Supply
vSupOut(sup, comm, region, year, slice)              Output of supply
vSupReserve(sup)                                     Accumulated used reserve
;
variable
vSupCost(sup, region, year)                          Supply costs
;
positive variable
* Demand
*#! RENAME?
vDemInp(comm, region, year, slice)                   ??? Input???
;
variable
* Emission
vEmsTot(comm, region, year, slice)                   Total emissions
vTechEms(tech, comm, region, year, slice)            Emissions on technology level
;
variable
* Ballance
vBalance(comm, region, year, slice)                  ??? Net commodity balance
;
positive variable
vOutTot(comm, region, year, slice)                   Total commodity output
vInpTot(comm, region, year, slice)                   Total commodity input
vSupOutTot(comm, region, year, slice)                Total commodity supply
vTechInpTot(comm, region, year, slice)               Total commodity input
vTechOutTot(comm, region, year, slice)               Total technology output
vStorageInpTot(comm, region, year, slice)            Total storage input
vStorageOutTot(comm, region, year, slice)            Total storage output
;
variable
* Cost variable
vCost(region, year)                                  Total costs
vObjective                                           Objective costs
;
positive variable
* Dummy import
vDumOut(comm, region, year, slice)                   Dummy import
vDumCost(comm, region, year)                         Dummy import costs
;
variable
* Tax
vTaxCost(comm, region, year)                         Total tax levies
* Subs
vSubsCost(comm, region, year)                        Total subsidies
;

variable
vAggOut(comm, region, year, slice)                   ???
;


* Reserves
positive variable
vStorageInp(stg, comm, region, year, slice)          Storage input
vStorageOut(stg, comm, region, year, slice)          Storage output
vStorageStore(stg, region, year, slice)              Storage level
vStorageVarom(stg, region, year)                     Storage variable O&M costs
vStorageFixom(stg, region, year)                     Storage fixed O&M costs
vStorageInv(stg, region, year)                       Storage technology investments
vStorageSalv(stg, region)                            Storage salvage costs
vStorageCap(stg, region, year)                       ??? Total storage capacity
vStorageNewCap(stg, region, year)                    Storage new capacity
;
variable
vStorageCost(stg, region, year)                      ???
;

* Trade and Row variable
positive variable
vImport(comm, region, year, slice)                   Interregional import
vExport(comm, region, year, slice)                   Interregional export
vTradeFlow(trade, region, region, year, slice)       ??? Total monetary trade flows
vRowExportRes(expp)                                  ??? Export to ROW
vRowExport(expp, region, year, slice)                ???
vRowImportRes(imp)                                   ???
vRowImport(imp, region, year, slice)                 ???
;
variable
vTradeCost(region, year)                             Trade costs
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
eqTechSng2Sng(tech, region, comm, commp, year, slice)      Input to Output
eqTechGrp2Sng(tech, region, group, commp, year, slice)     Group input to output
eqTechSng2Grp(tech, region, comm, groupp, year, slice)     Input to group output
eqTechGrp2Grp(tech, region, group, groupp, year, slice)    Group input to group output
eqTechUse2Sng(tech, region, commp, year, slice)            Use to output
eqTechUse2Grp(tech, region, groupp, year, slice)           Use to group output
;

eqTechSng2Sng(tech, region, comm, commp, year, slice)$
   ( mMidMilestone(year) and mTechSpan(tech, region, year) and
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
   (  mMidMilestone(year) and mTechSpan(tech, region, year) and
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
   (  mMidMilestone(year) and mTechSpan(tech, region, year) and
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
   (  mMidMilestone(year) and mTechSpan(tech, region, year) and
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
   (  mMidMilestone(year) and mTechSpan(tech, region, year) and
     mTechOutComm(tech, commp) and mTechOneComm(tech, commp)
   )..
   vTechUse(tech, region, year, slice) =e=
         vTechOut(tech, commp, region, year, slice) /
         pTechCact2cout(tech, commp, region, year, slice);

eqTechUse2Grp(tech, region, groupp, year, slice)$
   (  mMidMilestone(year) and mTechSpan(tech, region, year) and
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
eqTechShareInpLo(tech, region, group, comm, year, slice)    Lower bound on input share
* Input Share UP
eqTechShareInpUp(tech, region, group, comm, year, slice)    Upper bound on input share
* Output Share LO
eqTechShareOutLo(tech, region, group, comm, year, slice)    Lower bound on output share
* Output Share UP
eqTechShareOutUp(tech, region, group, comm, year, slice)    Upper bound on output share
;

* Input Share LO equation
eqTechShareInpLo(tech, region, group, comm, year, slice)$
         (       mMidMilestone(year) and mTechSpan(tech, region, year) and
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
         (       mMidMilestone(year) and  mTechSpan(tech, region, year) and
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
         (       mMidMilestone(year) and  mTechSpan(tech, region, year) and
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
         (       mMidMilestone(year) and  mTechSpan(tech, region, year) and
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
eqTechAInp(tech, comm, region, year, slice)
eqTechAOut(tech, comm, region, year, slice)
;


eqTechAInp(tech, comm, region, year, slice)$(mMidMilestone(year) and mTechAInp(tech, comm)  and mTechSpan(tech, region, year))..
  vTechAInp(tech, comm, region, year, slice) =e=
  (vTechUse(tech, region, year, slice) *
    pTechUse2AInp(tech, comm, region, year, slice)) +
  (vTechAct(tech, region, year, slice) *
    pTechAct2AInp(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AInp(tech, comm, region, year, slice)) +
  sum(commp$mTechCinpAInp(tech, comm, commp),
      pTechCinp2AInp(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$mTechCoutAInp(tech, comm, commp),
      pTechCout2AInp(tech, comm, commp, region, year, slice) *
         vTechOut(tech, commp, region, year, slice));

eqTechAOut(tech, comm, region, year, slice)$(mMidMilestone(year) and mTechAOut(tech, comm) and mTechSpan(tech, region, year))..
  vTechAOut(tech, comm, region, year, slice) =e=
  (vTechUse(tech, region, year, slice) *
    pTechUse2AOut(tech, comm, region, year, slice)) +
  (vTechAct(tech, region, year, slice) *
    pTechAct2AOut(tech, comm, region, year, slice)) +
  (vTechCap(tech, region, year) *
    pTechCap2AOut(tech, comm, region, year, slice)) +
  sum(commp$mTechCinpAOut(tech, comm, commp),
      pTechCinp2AOut(tech, comm, commp, region, year, slice) *
         vTechInp(tech, commp, region, year, slice)) +
  sum(commp$mTechCoutAOut(tech, comm, commp),
      pTechCout2AOut(tech, comm, commp, region, year, slice) *
         vTechOut(tech, commp, region, year, slice));


********************************************************************************
* Availability factor equations
********************************************************************************
Equation
* Availability factor LO
eqTechAfaLo(tech, region, year, slice)
* Availability factor UP
eqTechAfaUp(tech, region, year, slice)
;

* Availability factor LO
eqTechAfaLo(tech, region, year, slice)$(mMidMilestone(year) and pTechAfaLo(tech, region, year, slice) <> 0
  and mTechSpan(tech, region, year))..
         pTechAfaLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year)
         =l=
         vTechAct(tech, region, year, slice);

* Availability factor UP
eqTechAfaUp(tech, region, year, slice)$(
                 mMidMilestone(year) and mTechSpan(tech, region, year) and
                 defpTechAfaUp(tech, region, year, slice)
         )..
         vTechAct(tech, region, year, slice)
         =l=
         pTechAfaUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year);


********************************************************************************
* Connect activity with output equations
********************************************************************************
Equation
* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)
eqTechActGrp(tech, group, region, year, slice)
;

* Connect activity with output
eqTechActSng(tech, comm, region, year, slice)$(mMidMilestone(year) and mTechSpan(tech, region, year) and
  mTechOutComm(tech, comm) and mTechOneComm(tech, comm)
  and pTechCact2cout(tech, comm, region, year, slice) <> 0 ).. vTechAct(tech, region, year, slice) =e=
                 vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice);

eqTechActGrp(tech, group, region, year, slice)$(mMidMilestone(year) and mTechOutGroup(tech, group)
   and mTechSpan(tech, region, year)).. vTechAct(tech, region, year, slice) =e=
         sum(comm$(mTechGroupComm(tech, group, comm) and pTechCact2cout(tech, comm, region, year, slice) <> 0),
                 vTechOut(tech, comm, region, year, slice) / pTechCact2cout(tech, comm, region, year, slice)
         );



********************************************************************************
* Availability commodity factor equations
********************************************************************************
Equation
* Availability commodity factor LO equations
eqTechAfacLo(tech, region, comm, year, slice)
* Availability commodity factor UP equations
eqTechAfacUp(tech, region, comm, year, slice)
;

* Availability commodity factor LO equations
eqTechAfacLo(tech, region, comm, year, slice)$
         (       mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechOutComm(tech, comm) and
                 defpTechAfaUp(tech, region, year, slice) and
                 pTechAfacLo(tech, comm, region, year, slice) <> 0
         )..
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfaLo(tech, region, year, slice) *
         pTechAfacLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year)
         =l=
         vTechOut(tech, comm, region, year, slice);

* Availability commodity factor LO equations
eqTechAfacUp(tech, region, comm, year, slice)$
         (       mMidMilestone(year) and mTechSpan(tech, region, year) and
                 mTechOutComm(tech, comm) and
                 defpTechAfaUp(tech, region, year, slice) and
                 defpTechAfacUp(tech, comm, region, year, slice)
         )..
         vTechOut(tech, comm, region, year, slice)
         =l=
         pTechCact2cout(tech, comm, region, year, slice) *
         pTechAfaUp(tech, region, year, slice) *
         pTechAfacUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTechCap(tech, region, year);

********************************************************************************
* Capacity and cost equations
********************************************************************************
Equation
* Capacity eqaution
eqTechCap(tech, region, year)
eqTechNewCap(tech, region, year)
*eqTechRetirementCap(tech, region, year, year)
*eqTechRetrofitCap(tech, region, year, year)
*eqTechUpgradeCap(tech, region, year)
* Investition eqaution
eqTechInv(tech, region, year)
* Salvage cost
*eqTechSalv1(tech, region)
eqTechSalv2(tech, region, yeare)
eqTechSalv3(tech, region, yeare)
* Cost aggregate by year eqaution
eqTechCost1(tech, region, year)
eqTechCost2(tech, region, year)
;


* Capacity eqaution
eqTechCap(tech, region, year)$(mMidMilestone(year) and  mTechSpan(tech, region, year))..
         vTechCap(tech, region, year)
         =e=
         pTechStock(tech, region, year) +
         sum((yearp)$
                 (       mTechNew(tech, region, yearp) and
                         ORD(year) >= ORD(yearp) and
                         ORD(year) < pTechOlife(tech, region) + ORD(yearp)
                 ),
                 vTechNewCap(tech, region, yearp) -
                   sum(yeare$(mTechRetirement(tech) and ORD(yeare) >= ORD(yearp) and ORD(yeare) <= ORD(year)),
                       vTechRetirementCap(tech, region, yearp, yeare))
         );

eqTechNewCap(tech, region, year)$(mMidMilestone(year) and mTechNew(tech, region, year) and mTechRetirement(tech))..
    sum(yearp$(mMidMilestone(yearp) and ORD(yearp) >= ORD(year) and ORD(yearp) < ORD(year) + pTechOlife(tech, region)),
                         vTechRetirementCap(tech, region, year, yearp)
         ) =l= vTechNewCap(tech, region, year);

*eqTechRetirementCap(tech, region, year, yearp)$(not(mTechRetirement(tech)) or
*  ORD(yearp) < ORD(year) or ORD(yearp) >= ORD(year) + pTechOlife(tech, region))..
*    vTechRetirementCap(tech, region, year, yearp) =e= 0;

*eqTechRetrofitCap(tech, region, year, yearp)$(ORD(yearp) < ORD(year) or ORD(yearp) >= ORD(year) + pTechOlife(tech, region))..
*    vTechRetrofitCap(tech, region, year, yearp) =e= 0;

*eqTechUpgradeCap(tech, region, year)..
*    sum((techp, yearp)$(mTechUpgrade(tech, techp)), vTechRetrofitCap(techp, region, yearp, year)) =e= vTechUpgradeCap(tech, region, year);

* Investition eqaution
eqTechInv(tech, region, year)$(mMidMilestone(year) and mTechNew(tech, region, year))..  vTechInv(tech, region, year) =e=
   pTechInvcost(tech, region, year) * vTechNewCap(tech, region, year);

* Salvage cost
eqTechSalv2(tech, region, yeare)$(mDiscountZero(region) and mMilestoneLast(yeare))..
    vTechSalv(tech, region)
    +
   sum(year$(mMidMilestone(year) and mTechNew(tech, region, year) and ORD(year) + pTechOlife(tech, region) - 1 > ORD(yeare)),
    (pDiscountFactor(region, year) /  pDiscountFactor(region, yeare)) *
    pTechInvcost(tech, region, year) * (vTechNewCap(tech, region, year)
     - sum(yearp$(mMidMilestone(yearp) and mTechRetirement(tech)), vTechRetirementCap(tech, region, year, yearp)))  / (
      1
        + (sum(yearp$(ORD(yearp) >= ORD(year)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / (sum(yearn$(ORD(yeare) = ORD(yearn)),
           (pTechOlife(tech, region) + ORD(year) - 1 - ORD(yeare)
           )))
    ))  =e= 0;


eqTechSalv3(tech, region, yeare)$(not(mDiscountZero(region)) and mMilestoneLast(yeare))..
    vTechSalv(tech, region)
    +
   sum(year$(mMidMilestone(year) and mTechNew(tech, region, year) and ORD(year) + pTechOlife(tech, region) - 1 > ORD(yeare)),
    (pDiscountFactor(region, year) /  pDiscountFactor(region, yeare)) *
    pTechInvcost(tech, region, year) * (vTechNewCap(tech, region, year)
      - sum(yearp$(mMidMilestone(year) and mTechRetirement(tech)), vTechRetirementCap(tech, region, year, yearp))) / (
      1
        + (sum(yearp$(mMidMilestone(yearp) and ORD(yearp) >= ORD(year)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / (sum(yearn$(ORD(yeare) = ORD(yearn)), (
           1 - (1 + pDiscount(region, yearn)) ** (ORD(yeare)
                 - pTechOlife(tech, region) - ORD(year) + 1)
           )  *  (1 + pDiscount(region, yearn)) / pDiscount(region, yearn)))
    ))  =e= 0;

* Cost aggregate by year eqaution
eqTechCost1(tech, region, year)$(mMidMilestone(year) and mTechSpan(tech, region, year) and mTechNew(tech, region, year))..
         vTechCost(tech, region, year)
         =e=
         (vTechInv(tech, region, year) +
         pTechFixom(tech, region, year) * vTechCap(tech, region, year) +
         sum(slice,
                  pTechVarom(tech, region, year, slice) *
                  vTechAct(tech, region, year, slice) +
                  sum(comm$mTechInpComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechInp(tech, comm, region, year, slice)
                  ) +
                  sum(comm$mTechOutComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechOut(tech, comm, region, year, slice)
                  )
         ));

eqTechCost2(tech, region, year)$(mMidMilestone(year) and mTechSpan(tech, region, year) and not(mTechNew(tech, region, year)))..
         vTechCost(tech, region, year)
         =e=
         (pTechFixom(tech, region, year) * vTechCap(tech, region, year) +
         sum(slice,
                  pTechVarom(tech, region, year, slice) *
                  vTechAct(tech, region, year, slice) +
                  sum(comm$mTechInpComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechInp(tech, comm, region, year, slice)
                  ) +
                  sum(comm$mTechOutComm(tech, comm),
                          pTechCvarom(tech, comm, region, year, slice) *
                          vTechOut(tech, comm, region, year, slice)
                  )
         ));


**************************************
* Supply equation
**************************************
Equation
eqSupAvaUp(sup, comm, region, year, slice)
eqSupAvaLo(sup, comm, region, year, slice)
eqSupReserve(sup, comm)
eqSupReserveCheck(sup, comm)
eqSupCost(sup, region, year)
;

eqSupAvaUp(sup, comm, region, year, slice)$(mMidMilestone(year) and mSupComm(sup, comm) and
         defpSupAvaUp(sup, region, year, slice))..
         vSupOut(sup, comm, region, year, slice)
         =l=
         pSupAvaUp(sup, region, year, slice);

eqSupAvaLo(sup, comm, region, year, slice)$(mMidMilestone(year) and mSupComm(sup, comm))..
         vSupOut(sup, comm, region, year, slice)
         =g=
         pSupAvaLo(sup, region, year, slice);

eqSupReserve(sup, comm)$mSupComm(sup, comm)..
         vSupReserve(sup)
         =e=
         sum((region, year, slice, yeare, yearp)$(mMidMilestone(year) and
                mStartMilestone(year, yeare) and mEndMilestone(year, yearp)),
             (ORD(yearp) - ORD(yeare) + 1) * vSupOut(sup, comm, region, year, slice)
         );

eqSupReserveCheck(sup, comm)$
         (
                 mSupComm(sup, comm) and defpSupReserve(sup)
         )..
         pSupReserve(sup) =g= vSupReserve(sup);

eqSupCost(sup, region, year)$mMidMilestone(year)..
         vSupCost(sup, region, year)
         =e=
         sum((comm, slice)$mSupComm(sup, comm),
          pSupCost(sup, region, year, slice) * vSupOut(sup, comm, region, year, slice));

**************************************
* Demand equation
**************************************
Equation
eqDemInp(comm, region, year, slice)
*eqDemInp2(comm, region, year, slice, year, year)
;

eqDemInp(comm, region, year, slice)$mMidMilestone(year)..
         vDemInp(comm, region, year, slice)  =e=
         sum(dem$mDemComm(dem, comm), pDemand(dem, region, year, slice));

*eqDemInp2(comm, region, year, slice, yeare, yearp)$(
*  not(mMidMilestone(year)) and mMilestone1(year, yeare) and mMilestone2(year, yearp))..
*         pMilestone1(year, yeare) * vDemInp(comm, region, yeare, slice) +
*         pMilestone2(year, yearp) * vDemInp(comm, region, yearp, slice)
*         =g=
*         sum(dem$mDemComm(dem, comm), pDemand(dem, region, year, slice));


**************************************
* Emission & Aggregate equation
**************************************
Equation
eqAggOut(comm, region, year, slice)
eqEmsTot(comm, region, year, slice)
eqTechEms(tech, comm, region, year, slice)
;



eqAggOut(comm, region, year, slice)$mMidMilestone(year)..
         vAggOut(comm, region, year, slice)
         =e=
         sum(commp$pAggregateFactor(comm, commp),
                 pAggregateFactor(comm, commp) *
                  vOutTot(commp, region, year, slice)
         );


eqTechEms(tech, comm, region, year, slice)$(
  mMidMilestone(year) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm))..
         vTechEms(tech, comm, region, year, slice)
         =e=
         sum(commp$(
                         mTechInpComm(tech, commp) and pTechEmisComm(tech, commp) <> 0 and
                         pEmissionFactor(comm, commp) <> 0
                 ),
                   pTechEmisComm(tech, commp) * pEmissionFactor(comm, commp) *
                   vTechInp(tech, commp, region, year, slice)
         );

eqEmsTot(comm, region, year, slice)$mMidMilestone(year).. vEmsTot(comm, region, year, slice)
         =e= sum(tech$(mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)),
            vTechEms(tech, comm, region, year, slice));

********************************************************************************
* Store equations for reserve
********************************************************************************
Equation
eqStorageStore(stg, comm, region, year, slice)
;

eqStorageStore(stg, comm, region, year, slice)$mMidMilestone(year)..
  vStorageStore(stg, region, year, slice) =e=
  (1 - pStorageInpLoss(stg, region, year, slice)) * vStorageInp(stg, comm, region, year, slice) -
  (1 - pStorageOutLoss(stg, region, year, slice)) * vStorageOut(stg, comm, region, year, slice) +
  sum(slicep$(mSlicePrevious(slice, slicep) and not(mSlicePreviousYear(slice))),
  (1 - pStorageStoreLoss(stg, region, year, slice)) * vStorageStore(stg, region, year, slicep)) +
  sum((yearp, slicep)$(ORD(yearp) + 1 = ORD(year) and mSlicePrevious(slice, slicep) and mSlicePreviousYear(slice)),
  (1 - pStorageStoreLoss(stg, region, year, slice)) * vStorageStore(stg, region, yearp, slicep)) +
  pStorageStoreStock(stg, region, year, slice);

********************************************************************************
* Capacity and cost equations for reserve
********************************************************************************
Equation
* Capacity eqaution
eqStorageCap(stg, region, year)
* Investition eqaution
eqStorageInv(stg, region, year)
* FIX O & M eqaution
eqStorageFix(stg, region, year)
* Salvage cost
eqStorageSalv2(stg, region, yeare)
eqStorageSalv3(stg, region, yeare)
* Commodity Varom O & M aggregate by year eqaution
eqStorageVar(stg, region, year)
* Cost aggregate by year eqaution
eqStorageCost1(stg, region, year)
eqStorageCost2(stg, region, year)
* Constrain capacity
eqStorageLo(stg, region, year)
eqStorageUp(stg, region, year)
;

* Capacity eqaution
eqStorageCap(stg, region, year)$mMidMilestone(year)..
         vStorageCap(stg, region, year)
         =e=
         pStorageStock(stg, region, year) +
         sum(yearp$
                 (
                         ORD(year) >= ORD(yearp) and
                         ORD(year) < pStorageOlife(stg, region) + ORD(yearp)
                 ),
                 vStorageNewCap(stg, region, yearp)
         );

* Investition eqaution
eqStorageInv(stg, region, year)$mMidMilestone(year)..
         vStorageInv(stg, region, year)
         =e=
         pStorageInvcost(stg, region, year) *
         vStorageNewCap(stg, region, year);

* FIX O & M eqaution
eqStorageFix(stg, region, year)$mMidMilestone(year)..
         vStorageFixom(stg, region, year)
         =e=
         pStorageFixom(stg, region, year) *
         vStorageCap(stg, region, year);

* Salvage cost
eqStorageSalv2(stg, region, yeare)$(mMidMilestone(yeare) and mDiscountZero(region))..
         vStorageSalv(stg, region)
         +
        sum(year$(mMidMilestone(year) and ORD(year) + pStorageOlife(stg, region) - 1 > ORD(yeare)), vStorageInv(stg, region, year) *
   (pDiscountFactor(region, year) /  pDiscountFactor(region, yeare)) / (
      1
        + (sum(yearp$(ORD(yearp) >= ORD(year)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / ((
           1 - (1 + pDiscount(region, yeare)) ** (ORD(yeare)
                 - pStorageOlife(stg, region) - ORD(year) + 1)
           )  *  (1 + pDiscount(region, yeare)) / pDiscount(region, yeare))
    ))   =e= 0;

eqStorageSalv3(stg, region, yeare)$(mMidMilestone(yeare) and not(mDiscountZero(region)))..
         vStorageSalv(stg, region)
         +
         sum(year$(mMidMilestone(year) and ORD(year) + pStorageOlife(stg, region) - 1 > ORD(yeare)), vStorageInv(stg, region, year) *
      (pDiscountFactor(region, year) /  pDiscountFactor(region, yeare)) / (
      1
        + (sum(yearp$(ORD(yearp) >= ORD(year)), pDiscountFactor(region, yearp)))
        / (pDiscountFactor(region, yeare)
          ) / ((
           1 - (1 + pDiscount(region, yeare)) ** (ORD(yeare)
                 - pStorageOlife(stg, region) - ORD(year) + 1)
           )  *  (1 + pDiscount(region, yeare)) / pDiscount(region, yeare)))
    )  =e= 0;

* Varom O & M aggregate by year eqaution
eqStorageVar(stg, region, year)$mMidMilestone(year)..
         vStorageVarom(stg, region, year)
         =e=
         sum((slice, comm)$mStorageComm(stg, comm),
                  pStorageCostInp(stg, region, year, slice) * vStorageInp(stg, comm, region, year, slice) +
                  pStorageCostOut(stg, region, year, slice) * vStorageOut(stg, comm, region, year, slice) +
                  pStorageCostStore(stg, region, year, slice) * vStorageStore(stg, region, year, slice));

* Cost aggregate by year eqaution
eqStorageCost1(stg, region, year)$(mMidMilestone(year) and not(mMilestoneLast(year)))..
         vStorageCost(stg, region, year)
         =e=
         vStorageInv(stg, region, year) +
         vStorageFixom(stg, region, year) +
         vStorageVarom(stg, region, year);

eqStorageCost2(stg, region, year)$(mMidMilestone(year) and mMilestoneLast(year))..
         vStorageCost(stg, region, year)
         =e=
         vStorageInv(stg, region, year) +
         vStorageFixom(stg, region, year) +
         vStorageVarom(stg, region, year) +
         vStorageSalv(stg, region);

* Disable new capacity
eqStorageLo(stg, region, year)$(mMidMilestone(year) and pStorageCapLo(stg, region, year))..
         vStorageCap(stg, region, year) =g= pStorageCapLo(stg, region, year);

eqStorageUp(stg, region, year)$(mMidMilestone(year) and defpStorageCapUp(stg, region, year))..
        vStorageCap(stg, region, year) =l= pStorageCapUp(stg, region, year);



**************************************
* Trade and ROW equations
**************************************
equation
eqImport(comm, region, year, slice)
eqExport(comm, region, year, slice)
eqTradeFlowUp(trade, region, region, year, slice)
eqTradeFlowLo(trade, region, region, year, slice)
*eqCostTrade(region, year, slice)
eqCostTrade(region, year)
eqRowExportUp(expp, region, year, slice)
eqRowExportLo(expp, region, year, slice)
eqRowExportRes(expp)
eqRowExportResUp(expp)
eqRowImportUp(imp, region, year, slice)
eqRowImportLo(imp, region, year, slice)
eqRowImportRes(imp)
eqRowImportResUp(imp)
;

eqImport(comm, region, year, slice)$mMidMilestone(year)..
  vImport(comm, region, year, slice) =e=
  sum((trade, regionp)$mTradeComm(trade, comm), vTradeFlow(trade, regionp, region, year, slice)) +
  sum(imp$mImpComm(imp, comm), vRowImport(imp, region, year, slice));

eqExport(comm, region, year, slice)$mMidMilestone(year)..
  vExport(comm, region, year, slice) =e=
  sum((trade, regionp)$mTradeComm(trade, comm), vTradeFlow(trade, region, regionp, year, slice)) +
  sum(expp$mExpComm(expp, comm), vRowExport(expp, region, year, slice));

eqTradeFlowUp(trade, region, regionp, year, slice)$(
  mMidMilestone(year) and defpTradeFlowUp(trade, region, regionp, year, slice))..
  vTradeFlow(trade, region, regionp, year, slice) =l= pTradeFlowUp(trade, region, regionp, year, slice);

eqTradeFlowLo(trade, region, regionp, year, slice)$(
  mMidMilestone(year) and pTradeFlowLo(trade, region, regionp, year, slice))..
  vTradeFlow(trade, region, regionp, year, slice) =g= pTradeFlowLo(trade, region, regionp, year, slice);


eqCostTrade(region, year)$mMidMilestone(year).. vTradeCost(region, year) =e=
  sum((trade, regionp, slice), pTradeFlowCost(trade, regionp, region, year, slice) *
      vTradeFlow(trade, regionp, region, year, slice)) +
  sum((imp, slice), pRowImportPrice(imp, region, year, slice) *
     vRowImport(imp, region, year, slice)) -
  sum((expp, slice), pRowExportPrice(expp, region, year, slice) *
      vRowExport(expp, region, year, slice));

*eqCostTradeY(region, year).. vTradeCostY(region, year) =e=
*  sum(slice, vTradeCost(region, year, slice));


eqRowExportUp(expp, region, year, slice)$(mMidMilestone(year) and defpRowExportUp(expp, region, year, slice))..
  vRowExport(expp, region, year, slice)  =l= pRowExportUp(expp, region, year, slice);

eqRowExportLo(expp, region, year, slice)$(mMidMilestone(year) and pRowExportLo(expp, region, year, slice) <> 0)..
  vRowExport(expp, region, year, slice)  =g= pRowExportLo(expp, region, year, slice);

eqRowExportRes(expp).. vRowExportRes(expp) =e=
    sum((region, year, slice, yeare, yearp)$(mMidMilestone(year) and
                mStartMilestone(year, yeare) and mEndMilestone(year, yearp)),
       (ORD(yearp) - ORD(yeare) + 1) * vRowExport(expp, region, year, slice)
);

eqRowExportResUp(expp)$defpRowExportRes(expp).. vRowExportRes(expp) =l= pRowExportRes(expp);



eqRowImportUp(imp, region, year, slice)$(mMidMilestone(year) and defpRowImportUp(imp, region, year, slice))..
  vRowImport(imp, region, year, slice)  =l= pRowImportUp(imp, region, year, slice);

eqRowImportLo(imp, region, year, slice)$(mMidMilestone(year) and pRowImportLo(imp, region, year, slice) <> 0)..
  vRowImport(imp, region, year, slice)  =g= pRowImportLo(imp, region, year, slice);

eqRowImportRes(imp).. vRowImportRes(imp) =e=
    sum((region, year, slice, yeare, yearp)$(mMidMilestone(year) and
                mStartMilestone(year, yeare) and mEndMilestone(year, yearp)),
         (ORD(yearp) - ORD(yeare) + 1) * vRowImport(imp, region, year, slice)
);

eqRowImportResUp(imp)$defpRowImportRes(imp).. vRowImportRes(imp) =l= pRowImportRes(imp);


**************************************
* Balance equation & dummy
**************************************
Equation
eqBalUp(comm, region, year, slice)
eqBalLo(comm, region, year, slice)
eqBalFx(comm, region, year, slice)
eqBal(comm, region, year, slice)
eqOutTot(comm, region, year, slice)
eqInpTot(comm, region, year, slice)
eqSupOutTot(comm, region, year, slice)
eqTechInpTot(comm, region, year, slice)
eqTechOutTot(comm, region, year, slice)
eqStorageInpTot(comm, region, year, slice)
eqStorageOutTot(comm, region, year, slice)
;


eqBalLo(comm, region, year, slice)$(mMidMilestone(year) and mLoComm(comm))..
         vBalance(comm, region, year, slice) =g= 0;

eqBalUp(comm, region, year, slice)$(mMidMilestone(year) and mUpComm(comm))..
         vBalance(comm, region, year, slice) =l= 0;

eqBalFx(comm, region, year, slice)$(mMidMilestone(year) and mFxComm(comm))..
         vBalance(comm, region, year, slice) =e= 0;

eqBal(comm, region, year, slice)$mMidMilestone(year)..
         vBalance(comm, region, year, slice)
         =e=
         vOutTot(comm, region, year, slice) -
         vInpTot(comm, region, year, slice);

eqOutTot(comm, region, year, slice)$mMidMilestone(year)..
         vOutTot(comm, region, year, slice)
         =e=
         vSupOutTot(comm, region, year, slice) +
         vEmsTot(comm, region, year, slice) +
         vAggOut(comm, region, year, slice) +
         vTechOutTot(comm, region, year, slice) +
         vDumOut(comm, region, year, slice) +
         vStorageOutTot(comm, region, year, slice) +
         vImport(comm, region, year, slice);

eqInpTot(comm, region, year, slice)$mMidMilestone(year)..
         vInpTot(comm, region, year, slice)
         =e=
         vTechInpTot(comm, region, year, slice) +
         vDemInp(comm, region, year, slice) +
         vStorageInpTot(comm, region, year, slice) +
         vExport(comm, region, year, slice);

eqSupOutTot(comm, region, year, slice)$mMidMilestone(year)..
         vSupOutTot(comm, region, year, slice)
         =e=
         sum(sup$mSupComm(sup, comm),
                 vSupOut(sup, comm, region, year, slice)
         );

eqTechInpTot(comm, region, year, slice)$mMidMilestone(year)..
         vTechInpTot(comm, region, year, slice)
         =e=
         sum(tech$(mTechSpan(tech, region, year) and mTechInpComm(tech, comm)),
             vTechInp(tech, comm, region, year, slice)) +
         sum(tech$(mTechSpan(tech, region, year) and mTechAInp(tech, comm)),
             vTechAInp(tech, comm, region, year, slice));

eqTechOutTot(comm, region, year, slice)$mMidMilestone(year)..
         vTechOutTot(comm, region, year, slice)
         =e=
         sum(tech$(mTechSpan(tech, region, year) and mTechOutComm(tech, comm)),
             vTechOut(tech, comm, region, year, slice)) +
         sum(tech$(mTechSpan(tech, region, year) and mTechAOut(tech, comm)),
             vTechAOut(tech, comm, region, year, slice));


eqStorageInpTot(comm, region, year, slice)$mMidMilestone(year)..
         vStorageInpTot(comm, region, year, slice)
         =e=
         sum(stg$mStorageComm(stg, comm),
                 vStorageInp(stg, comm, region, year, slice)
         );

eqStorageOutTot(comm, region, year, slice)$mMidMilestone(year)..
         vStorageOutTot(comm, region, year, slice)
         =e=
         sum(stg$mStorageComm(stg, comm),
                 vStorageOut(stg, comm, region, year, slice)
         );



**************************************
* Cost equations
**************************************
Equation
eqDumOut(comm, region, year, slice)
eqDumCost(comm, region, year)
eqCost1(region, year)
eqCost2(region, year)
eqObjective
* Tax
eqTaxCost(comm, region, year)
* Subs
eqSubsCost(comm, region, year)
;

eqDumOut(comm, region, year, slice)$(mMidMilestone(year) and not(defpDumCost(comm, region, year, slice)))..
         vDumOut(comm, region, year, slice) =e= 0;

eqDumCost(comm, region, year)$mMidMilestone(year)..
         vDumCost(comm, region, year)
         =e=
         sum(slice$(defpDumCost(comm, region, year, slice)),
         pDumCost(comm, region, year, slice) * vDumOut(comm, region, year, slice));


eqCost1(region, year)$(mMidMilestone(year) and not(mMilestoneLast(year)))..
         vCost(region, year)
         =e=
         sum(tech$mTechSpan(tech, region, year), vTechCost(tech, region, year))
         + sum(sup, vSupCost(sup, region, year))
         + sum(comm, vDumCost(comm, region, year))
         + sum(comm, vTaxCost(comm, region, year))
         - sum(comm, vSubsCost(comm, region, year))
         + sum(stg, vStorageCost(stg, region, year))
         + vTradeCost(region, year);

eqCost2(region, year)$(mMidMilestone(year) and mMilestoneLast(year))..
         vCost(region, year)
         =e=
         sum(tech$mTechSpan(tech, region, year), vTechCost(tech, region, year))
         + sum(tech, vTechSalv(tech, region))
         + sum(stg, vStorageSalv(stg, region))
         + sum(sup, vSupCost(sup, region, year))
         + sum(comm, vDumCost(comm, region, year))
         + sum(comm, vTaxCost(comm, region, year))
         - sum(comm, vSubsCost(comm, region, year))
         + sum(stg, vStorageCost(stg, region, year))
         + vTradeCost(region, year);

eqObjective..
         vObjective =e= sum((region, year)$mMidMilestone(year), pDiscountFactor(region, year) *
                 vCost(region, year));
* Tax
eqTaxCost(comm, region, year)$mMidMilestone(year)..
         vTaxCost(comm, region, year)
         =e=
         sum(slice, pTaxCost(comm, region, year, slice) *
         vOutTot(comm, region, year, slice));


* Subs
eqSubsCost(comm, region, year)$mMidMilestone(year)..
         vSubsCost(comm, region, year)
         =e=
         sum(slice, pSubsCost(comm, region, year, slice) *
         vOutTot(comm, region, year, slice));


* End generation latex file
*\end{document}
* ------------------------------------------------------------------------------
* Standart constrain: Begin
* ------------------------------------------------------------------------------
*!1: Constrains
$ontext
bla-bla-bla
$offtext
set
cns
mCnsLe(cns)
mCnsGe(cns)
mCnsRhsTypeConst(cns)
mCnsRhsTypeShareIn(cns)
mCnsRhsTypeShareOut(cns)


mCnsInpTech(cns)
mCnsOutTech(cns)
mCnsCapTech(cns)
mCnsNewCapTech(cns)
mCnsOutSup(cns)
mCnsInp(cns)
mCnsOut(cns)

mCnsTech(cns, tech)
mCnsSup(cns, sup)
mCnsComm(cns, comm)
mCnsRegion(cns, region)
mCnsYear(cns, year)
mCnsSlice(cns, slice)

mCnsLType(cns)
mCnsLhsComm(cns)
mCnsLhsRegion(cns)
mCnsLhsYear(cns)
mCnsLhsSlice(cns)
;


parameter
pRhs(cns)
pRhsS(cns, slice)
pRhsY(cns, year)
pRhsYS(cns, year, slice)
pRhsR(cns, region)
pRhsRS(cns, region, slice)
pRhsRY(cns, region, year)
pRhsRYS(cns, region, year, slice)
pRhsC(cns, comm)
pRhsCS(cns, comm, slice)
pRhsCY(cns, comm, year)
pRhsCYS(cns, comm, year, slice)
pRhsCR(cns, comm, region)
pRhsCRS(cns, comm, region, slice)
pRhsCRY(cns, comm, region, year)
pRhsCRYS(cns, comm, region, year, slice)
pRhsTech(cns, tech)
pRhsTechS(cns, tech, slice)
pRhsTechY(cns, tech, year)
pRhsTechYS(cns, tech, year, slice)
pRhsTechR(cns, tech, region)
pRhsTechRS(cns, tech, region, slice)
pRhsTechRY(cns, tech, region, year)
pRhsTechRYS(cns, tech, region, year, slice)
pRhsTechC(cns, tech, comm)
pRhsTechCS(cns, tech, comm, slice)
pRhsTechCY(cns, tech, comm, year)
pRhsTechCYS(cns, tech, comm, year, slice)
pRhsTechCR(cns, tech, comm, region)
pRhsTechCRS(cns, tech, comm, region, slice)
pRhsTechCRY(cns, tech, comm, region, year)
pRhsTechCRYS(cns, tech, comm, region, year, slice)
pRhsSup(cns, sup)
pRhsSupS(cns, sup, slice)
pRhsSupY(cns, sup, year)
pRhsSupYS(cns, sup, year, slice)
pRhsSupR(cns, sup, region)
pRhsSupRS(cns, sup, region, slice)
pRhsSupRY(cns, sup, region, year)
pRhsSupRYS(cns, sup, region, year, slice)
pRhsSupC(cns, sup, comm)
pRhsSupCS(cns, sup, comm, slice)
pRhsSupCY(cns, sup, comm, year)
pRhsSupCYS(cns, sup, comm, year, slice)
pRhsSupCR(cns, sup, comm, region)
pRhsSupCRS(cns, sup, comm, region, slice)
pRhsSupCRY(cns, sup, comm, region, year)
pRhsSupCRYS(cns, sup, comm, region, year, slice)
;

equation
eqCnsLETechInpShareIn(cns)
eqCnsLETechInpShareOut(cns)
eqCnsLETechInp(cns)
eqCnsGETechInpShareIn(cns)
eqCnsGETechInpShareOut(cns)
eqCnsGETechInp(cns)
eqCnsETechInpShareIn(cns)
eqCnsETechInpShareOut(cns)
eqCnsETechInp(cns)
eqCnsLETechInpSShareIn(cns, slice)
eqCnsLETechInpSShareOut(cns, slice)
eqCnsLETechInpS(cns, slice)
eqCnsGETechInpSShareIn(cns, slice)
eqCnsGETechInpSShareOut(cns, slice)
eqCnsGETechInpS(cns, slice)
eqCnsETechInpSShareIn(cns, slice)
eqCnsETechInpSShareOut(cns, slice)
eqCnsETechInpS(cns, slice)
eqCnsLETechInpYShareIn(cns, year)
eqCnsLETechInpYShareOut(cns, year)
eqCnsLETechInpY(cns, year)
eqCnsGETechInpYShareIn(cns, year)
eqCnsGETechInpYShareOut(cns, year)
eqCnsGETechInpY(cns, year)
eqCnsETechInpYShareIn(cns, year)
eqCnsETechInpYShareOut(cns, year)
eqCnsETechInpY(cns, year)
eqCnsLETechInpYSShareIn(cns, year, slice)
eqCnsLETechInpYSShareOut(cns, year, slice)
eqCnsLETechInpYS(cns, year, slice)
eqCnsGETechInpYSShareIn(cns, year, slice)
eqCnsGETechInpYSShareOut(cns, year, slice)
eqCnsGETechInpYS(cns, year, slice)
eqCnsETechInpYSShareIn(cns, year, slice)
eqCnsETechInpYSShareOut(cns, year, slice)
eqCnsETechInpYS(cns, year, slice)
eqCnsLETechInpRShareIn(cns, region)
eqCnsLETechInpRShareOut(cns, region)
eqCnsLETechInpR(cns, region)
eqCnsGETechInpRShareIn(cns, region)
eqCnsGETechInpRShareOut(cns, region)
eqCnsGETechInpR(cns, region)
eqCnsETechInpRShareIn(cns, region)
eqCnsETechInpRShareOut(cns, region)
eqCnsETechInpR(cns, region)
eqCnsLETechInpRSShareIn(cns, region, slice)
eqCnsLETechInpRSShareOut(cns, region, slice)
eqCnsLETechInpRS(cns, region, slice)
eqCnsGETechInpRSShareIn(cns, region, slice)
eqCnsGETechInpRSShareOut(cns, region, slice)
eqCnsGETechInpRS(cns, region, slice)
eqCnsETechInpRSShareIn(cns, region, slice)
eqCnsETechInpRSShareOut(cns, region, slice)
eqCnsETechInpRS(cns, region, slice)
eqCnsLETechInpRYShareIn(cns, region, year)
eqCnsLETechInpRYShareOut(cns, region, year)
eqCnsLETechInpRY(cns, region, year)
eqCnsGETechInpRYShareIn(cns, region, year)
eqCnsGETechInpRYShareOut(cns, region, year)
eqCnsGETechInpRY(cns, region, year)
eqCnsETechInpRYShareIn(cns, region, year)
eqCnsETechInpRYShareOut(cns, region, year)
eqCnsETechInpRY(cns, region, year)
eqCnsLETechInpRYSShareIn(cns, region, year, slice)
eqCnsLETechInpRYSShareOut(cns, region, year, slice)
eqCnsLETechInpRYS(cns, region, year, slice)
eqCnsGETechInpRYSShareIn(cns, region, year, slice)
eqCnsGETechInpRYSShareOut(cns, region, year, slice)
eqCnsGETechInpRYS(cns, region, year, slice)
eqCnsETechInpRYSShareIn(cns, region, year, slice)
eqCnsETechInpRYSShareOut(cns, region, year, slice)
eqCnsETechInpRYS(cns, region, year, slice)
eqCnsLETechInpCShareIn(cns, comm)
eqCnsLETechInpCShareOut(cns, comm)
eqCnsLETechInpC(cns, comm)
eqCnsGETechInpCShareIn(cns, comm)
eqCnsGETechInpCShareOut(cns, comm)
eqCnsGETechInpC(cns, comm)
eqCnsETechInpCShareIn(cns, comm)
eqCnsETechInpCShareOut(cns, comm)
eqCnsETechInpC(cns, comm)
eqCnsLETechInpCSShareIn(cns, comm, slice)
eqCnsLETechInpCSShareOut(cns, comm, slice)
eqCnsLETechInpCS(cns, comm, slice)
eqCnsGETechInpCSShareIn(cns, comm, slice)
eqCnsGETechInpCSShareOut(cns, comm, slice)
eqCnsGETechInpCS(cns, comm, slice)
eqCnsETechInpCSShareIn(cns, comm, slice)
eqCnsETechInpCSShareOut(cns, comm, slice)
eqCnsETechInpCS(cns, comm, slice)
eqCnsLETechInpCYShareIn(cns, comm, year)
eqCnsLETechInpCYShareOut(cns, comm, year)
eqCnsLETechInpCY(cns, comm, year)
eqCnsGETechInpCYShareIn(cns, comm, year)
eqCnsGETechInpCYShareOut(cns, comm, year)
eqCnsGETechInpCY(cns, comm, year)
eqCnsETechInpCYShareIn(cns, comm, year)
eqCnsETechInpCYShareOut(cns, comm, year)
eqCnsETechInpCY(cns, comm, year)
eqCnsLETechInpCYSShareIn(cns, comm, year, slice)
eqCnsLETechInpCYSShareOut(cns, comm, year, slice)
eqCnsLETechInpCYS(cns, comm, year, slice)
eqCnsGETechInpCYSShareIn(cns, comm, year, slice)
eqCnsGETechInpCYSShareOut(cns, comm, year, slice)
eqCnsGETechInpCYS(cns, comm, year, slice)
eqCnsETechInpCYSShareIn(cns, comm, year, slice)
eqCnsETechInpCYSShareOut(cns, comm, year, slice)
eqCnsETechInpCYS(cns, comm, year, slice)
eqCnsLETechInpCRShareIn(cns, comm, region)
eqCnsLETechInpCRShareOut(cns, comm, region)
eqCnsLETechInpCR(cns, comm, region)
eqCnsGETechInpCRShareIn(cns, comm, region)
eqCnsGETechInpCRShareOut(cns, comm, region)
eqCnsGETechInpCR(cns, comm, region)
eqCnsETechInpCRShareIn(cns, comm, region)
eqCnsETechInpCRShareOut(cns, comm, region)
eqCnsETechInpCR(cns, comm, region)
eqCnsLETechInpCRSShareIn(cns, comm, region, slice)
eqCnsLETechInpCRSShareOut(cns, comm, region, slice)
eqCnsLETechInpCRS(cns, comm, region, slice)
eqCnsGETechInpCRSShareIn(cns, comm, region, slice)
eqCnsGETechInpCRSShareOut(cns, comm, region, slice)
eqCnsGETechInpCRS(cns, comm, region, slice)
eqCnsETechInpCRSShareIn(cns, comm, region, slice)
eqCnsETechInpCRSShareOut(cns, comm, region, slice)
eqCnsETechInpCRS(cns, comm, region, slice)
eqCnsLETechInpCRYShareIn(cns, comm, region, year)
eqCnsLETechInpCRYShareOut(cns, comm, region, year)
eqCnsLETechInpCRY(cns, comm, region, year)
eqCnsGETechInpCRYShareIn(cns, comm, region, year)
eqCnsGETechInpCRYShareOut(cns, comm, region, year)
eqCnsGETechInpCRY(cns, comm, region, year)
eqCnsETechInpCRYShareIn(cns, comm, region, year)
eqCnsETechInpCRYShareOut(cns, comm, region, year)
eqCnsETechInpCRY(cns, comm, region, year)
eqCnsLETechInpCRYSShareIn(cns, comm, region, year, slice)
eqCnsLETechInpCRYSShareOut(cns, comm, region, year, slice)
eqCnsLETechInpCRYS(cns, comm, region, year, slice)
eqCnsGETechInpCRYSShareIn(cns, comm, region, year, slice)
eqCnsGETechInpCRYSShareOut(cns, comm, region, year, slice)
eqCnsGETechInpCRYS(cns, comm, region, year, slice)
eqCnsETechInpCRYSShareIn(cns, comm, region, year, slice)
eqCnsETechInpCRYSShareOut(cns, comm, region, year, slice)
eqCnsETechInpCRYS(cns, comm, region, year, slice)
eqCnsLETechOutShareIn(cns)
eqCnsLETechOutShareOut(cns)
eqCnsLETechOut(cns)
eqCnsGETechOutShareIn(cns)
eqCnsGETechOutShareOut(cns)
eqCnsGETechOut(cns)
eqCnsETechOutShareIn(cns)
eqCnsETechOutShareOut(cns)
eqCnsETechOut(cns)
eqCnsLETechOutSShareIn(cns, slice)
eqCnsLETechOutSShareOut(cns, slice)
eqCnsLETechOutS(cns, slice)
eqCnsGETechOutSShareIn(cns, slice)
eqCnsGETechOutSShareOut(cns, slice)
eqCnsGETechOutS(cns, slice)
eqCnsETechOutSShareIn(cns, slice)
eqCnsETechOutSShareOut(cns, slice)
eqCnsETechOutS(cns, slice)
eqCnsLETechOutYShareIn(cns, year)
eqCnsLETechOutYShareOut(cns, year)
eqCnsLETechOutY(cns, year)
eqCnsGETechOutYShareIn(cns, year)
eqCnsGETechOutYShareOut(cns, year)
eqCnsGETechOutY(cns, year)
eqCnsETechOutYShareIn(cns, year)
eqCnsETechOutYShareOut(cns, year)
eqCnsETechOutY(cns, year)
eqCnsLETechOutYSShareIn(cns, year, slice)
eqCnsLETechOutYSShareOut(cns, year, slice)
eqCnsLETechOutYS(cns, year, slice)
eqCnsGETechOutYSShareIn(cns, year, slice)
eqCnsGETechOutYSShareOut(cns, year, slice)
eqCnsGETechOutYS(cns, year, slice)
eqCnsETechOutYSShareIn(cns, year, slice)
eqCnsETechOutYSShareOut(cns, year, slice)
eqCnsETechOutYS(cns, year, slice)
eqCnsLETechOutRShareIn(cns, region)
eqCnsLETechOutRShareOut(cns, region)
eqCnsLETechOutR(cns, region)
eqCnsGETechOutRShareIn(cns, region)
eqCnsGETechOutRShareOut(cns, region)
eqCnsGETechOutR(cns, region)
eqCnsETechOutRShareIn(cns, region)
eqCnsETechOutRShareOut(cns, region)
eqCnsETechOutR(cns, region)
eqCnsLETechOutRSShareIn(cns, region, slice)
eqCnsLETechOutRSShareOut(cns, region, slice)
eqCnsLETechOutRS(cns, region, slice)
eqCnsGETechOutRSShareIn(cns, region, slice)
eqCnsGETechOutRSShareOut(cns, region, slice)
eqCnsGETechOutRS(cns, region, slice)
eqCnsETechOutRSShareIn(cns, region, slice)
eqCnsETechOutRSShareOut(cns, region, slice)
eqCnsETechOutRS(cns, region, slice)
eqCnsLETechOutRYShareIn(cns, region, year)
eqCnsLETechOutRYShareOut(cns, region, year)
eqCnsLETechOutRY(cns, region, year)
eqCnsGETechOutRYShareIn(cns, region, year)
eqCnsGETechOutRYShareOut(cns, region, year)
eqCnsGETechOutRY(cns, region, year)
eqCnsETechOutRYShareIn(cns, region, year)
eqCnsETechOutRYShareOut(cns, region, year)
eqCnsETechOutRY(cns, region, year)
eqCnsLETechOutRYSShareIn(cns, region, year, slice)
eqCnsLETechOutRYSShareOut(cns, region, year, slice)
eqCnsLETechOutRYS(cns, region, year, slice)
eqCnsGETechOutRYSShareIn(cns, region, year, slice)
eqCnsGETechOutRYSShareOut(cns, region, year, slice)
eqCnsGETechOutRYS(cns, region, year, slice)
eqCnsETechOutRYSShareIn(cns, region, year, slice)
eqCnsETechOutRYSShareOut(cns, region, year, slice)
eqCnsETechOutRYS(cns, region, year, slice)
eqCnsLETechOutCShareIn(cns, comm)
eqCnsLETechOutCShareOut(cns, comm)
eqCnsLETechOutC(cns, comm)
eqCnsGETechOutCShareIn(cns, comm)
eqCnsGETechOutCShareOut(cns, comm)
eqCnsGETechOutC(cns, comm)
eqCnsETechOutCShareIn(cns, comm)
eqCnsETechOutCShareOut(cns, comm)
eqCnsETechOutC(cns, comm)
eqCnsLETechOutCSShareIn(cns, comm, slice)
eqCnsLETechOutCSShareOut(cns, comm, slice)
eqCnsLETechOutCS(cns, comm, slice)
eqCnsGETechOutCSShareIn(cns, comm, slice)
eqCnsGETechOutCSShareOut(cns, comm, slice)
eqCnsGETechOutCS(cns, comm, slice)
eqCnsETechOutCSShareIn(cns, comm, slice)
eqCnsETechOutCSShareOut(cns, comm, slice)
eqCnsETechOutCS(cns, comm, slice)
eqCnsLETechOutCYShareIn(cns, comm, year)
eqCnsLETechOutCYShareOut(cns, comm, year)
eqCnsLETechOutCY(cns, comm, year)
eqCnsGETechOutCYShareIn(cns, comm, year)
eqCnsGETechOutCYShareOut(cns, comm, year)
eqCnsGETechOutCY(cns, comm, year)
eqCnsETechOutCYShareIn(cns, comm, year)
eqCnsETechOutCYShareOut(cns, comm, year)
eqCnsETechOutCY(cns, comm, year)
eqCnsLETechOutCYSShareIn(cns, comm, year, slice)
eqCnsLETechOutCYSShareOut(cns, comm, year, slice)
eqCnsLETechOutCYS(cns, comm, year, slice)
eqCnsGETechOutCYSShareIn(cns, comm, year, slice)
eqCnsGETechOutCYSShareOut(cns, comm, year, slice)
eqCnsGETechOutCYS(cns, comm, year, slice)
eqCnsETechOutCYSShareIn(cns, comm, year, slice)
eqCnsETechOutCYSShareOut(cns, comm, year, slice)
eqCnsETechOutCYS(cns, comm, year, slice)
eqCnsLETechOutCRShareIn(cns, comm, region)
eqCnsLETechOutCRShareOut(cns, comm, region)
eqCnsLETechOutCR(cns, comm, region)
eqCnsGETechOutCRShareIn(cns, comm, region)
eqCnsGETechOutCRShareOut(cns, comm, region)
eqCnsGETechOutCR(cns, comm, region)
eqCnsETechOutCRShareIn(cns, comm, region)
eqCnsETechOutCRShareOut(cns, comm, region)
eqCnsETechOutCR(cns, comm, region)
eqCnsLETechOutCRSShareIn(cns, comm, region, slice)
eqCnsLETechOutCRSShareOut(cns, comm, region, slice)
eqCnsLETechOutCRS(cns, comm, region, slice)
eqCnsGETechOutCRSShareIn(cns, comm, region, slice)
eqCnsGETechOutCRSShareOut(cns, comm, region, slice)
eqCnsGETechOutCRS(cns, comm, region, slice)
eqCnsETechOutCRSShareIn(cns, comm, region, slice)
eqCnsETechOutCRSShareOut(cns, comm, region, slice)
eqCnsETechOutCRS(cns, comm, region, slice)
eqCnsLETechOutCRYShareIn(cns, comm, region, year)
eqCnsLETechOutCRYShareOut(cns, comm, region, year)
eqCnsLETechOutCRY(cns, comm, region, year)
eqCnsGETechOutCRYShareIn(cns, comm, region, year)
eqCnsGETechOutCRYShareOut(cns, comm, region, year)
eqCnsGETechOutCRY(cns, comm, region, year)
eqCnsETechOutCRYShareIn(cns, comm, region, year)
eqCnsETechOutCRYShareOut(cns, comm, region, year)
eqCnsETechOutCRY(cns, comm, region, year)
eqCnsLETechOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsLETechOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsLETechOutCRYS(cns, comm, region, year, slice)
eqCnsGETechOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsGETechOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsGETechOutCRYS(cns, comm, region, year, slice)
eqCnsETechOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsETechOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsETechOutCRYS(cns, comm, region, year, slice)
eqCnsLETechCap(cns)
eqCnsGETechCap(cns)
eqCnsETechCap(cns)
eqCnsLETechCapY(cns, year)
eqCnsGETechCapY(cns, year)
eqCnsETechCapY(cns, year)
eqCnsLETechCapR(cns, region)
eqCnsGETechCapR(cns, region)
eqCnsETechCapR(cns, region)
eqCnsLETechCapRY(cns, region, year)
eqCnsGETechCapRY(cns, region, year)
eqCnsETechCapRY(cns, region, year)
eqCnsLETechNewCap(cns)
eqCnsGETechNewCap(cns)
eqCnsETechNewCap(cns)
eqCnsLETechNewCapY(cns, year)
eqCnsGETechNewCapY(cns, year)
eqCnsETechNewCapY(cns, year)
eqCnsLETechNewCapR(cns, region)
eqCnsGETechNewCapR(cns, region)
eqCnsETechNewCapR(cns, region)
eqCnsLETechNewCapRY(cns, region, year)
eqCnsGETechNewCapRY(cns, region, year)
eqCnsETechNewCapRY(cns, region, year)
eqCnsLETechInpLShareIn(cns, tech)
eqCnsLETechInpLShareOut(cns, tech)
eqCnsLETechInpL(cns, tech)
eqCnsGETechInpLShareIn(cns, tech)
eqCnsGETechInpLShareOut(cns, tech)
eqCnsGETechInpL(cns, tech)
eqCnsETechInpLShareIn(cns, tech)
eqCnsETechInpLShareOut(cns, tech)
eqCnsETechInpL(cns, tech)
eqCnsLETechInpLSShareIn(cns, tech, slice)
eqCnsLETechInpLSShareOut(cns, tech, slice)
eqCnsLETechInpLS(cns, tech, slice)
eqCnsGETechInpLSShareIn(cns, tech, slice)
eqCnsGETechInpLSShareOut(cns, tech, slice)
eqCnsGETechInpLS(cns, tech, slice)
eqCnsETechInpLSShareIn(cns, tech, slice)
eqCnsETechInpLSShareOut(cns, tech, slice)
eqCnsETechInpLS(cns, tech, slice)
eqCnsLETechInpLYShareIn(cns, tech, year)
eqCnsLETechInpLYShareOut(cns, tech, year)
eqCnsLETechInpLY(cns, tech, year)
eqCnsGETechInpLYShareIn(cns, tech, year)
eqCnsGETechInpLYShareOut(cns, tech, year)
eqCnsGETechInpLY(cns, tech, year)
eqCnsETechInpLYShareIn(cns, tech, year)
eqCnsETechInpLYShareOut(cns, tech, year)
eqCnsETechInpLY(cns, tech, year)
eqCnsLETechInpLYSShareIn(cns, tech, year, slice)
eqCnsLETechInpLYSShareOut(cns, tech, year, slice)
eqCnsLETechInpLYS(cns, tech, year, slice)
eqCnsGETechInpLYSShareIn(cns, tech, year, slice)
eqCnsGETechInpLYSShareOut(cns, tech, year, slice)
eqCnsGETechInpLYS(cns, tech, year, slice)
eqCnsETechInpLYSShareIn(cns, tech, year, slice)
eqCnsETechInpLYSShareOut(cns, tech, year, slice)
eqCnsETechInpLYS(cns, tech, year, slice)
eqCnsLETechInpLRShareIn(cns, tech, region)
eqCnsLETechInpLRShareOut(cns, tech, region)
eqCnsLETechInpLR(cns, tech, region)
eqCnsGETechInpLRShareIn(cns, tech, region)
eqCnsGETechInpLRShareOut(cns, tech, region)
eqCnsGETechInpLR(cns, tech, region)
eqCnsETechInpLRShareIn(cns, tech, region)
eqCnsETechInpLRShareOut(cns, tech, region)
eqCnsETechInpLR(cns, tech, region)
eqCnsLETechInpLRSShareIn(cns, tech, region, slice)
eqCnsLETechInpLRSShareOut(cns, tech, region, slice)
eqCnsLETechInpLRS(cns, tech, region, slice)
eqCnsGETechInpLRSShareIn(cns, tech, region, slice)
eqCnsGETechInpLRSShareOut(cns, tech, region, slice)
eqCnsGETechInpLRS(cns, tech, region, slice)
eqCnsETechInpLRSShareIn(cns, tech, region, slice)
eqCnsETechInpLRSShareOut(cns, tech, region, slice)
eqCnsETechInpLRS(cns, tech, region, slice)
eqCnsLETechInpLRYShareIn(cns, tech, region, year)
eqCnsLETechInpLRYShareOut(cns, tech, region, year)
eqCnsLETechInpLRY(cns, tech, region, year)
eqCnsGETechInpLRYShareIn(cns, tech, region, year)
eqCnsGETechInpLRYShareOut(cns, tech, region, year)
eqCnsGETechInpLRY(cns, tech, region, year)
eqCnsETechInpLRYShareIn(cns, tech, region, year)
eqCnsETechInpLRYShareOut(cns, tech, region, year)
eqCnsETechInpLRY(cns, tech, region, year)
eqCnsLETechInpLRYSShareIn(cns, tech, region, year, slice)
eqCnsLETechInpLRYSShareOut(cns, tech, region, year, slice)
eqCnsLETechInpLRYS(cns, tech, region, year, slice)
eqCnsGETechInpLRYSShareIn(cns, tech, region, year, slice)
eqCnsGETechInpLRYSShareOut(cns, tech, region, year, slice)
eqCnsGETechInpLRYS(cns, tech, region, year, slice)
eqCnsETechInpLRYSShareIn(cns, tech, region, year, slice)
eqCnsETechInpLRYSShareOut(cns, tech, region, year, slice)
eqCnsETechInpLRYS(cns, tech, region, year, slice)
eqCnsLETechInpLCShareIn(cns, tech, comm)
eqCnsLETechInpLCShareOut(cns, tech, comm)
eqCnsLETechInpLC(cns, tech, comm)
eqCnsGETechInpLCShareIn(cns, tech, comm)
eqCnsGETechInpLCShareOut(cns, tech, comm)
eqCnsGETechInpLC(cns, tech, comm)
eqCnsETechInpLCShareIn(cns, tech, comm)
eqCnsETechInpLCShareOut(cns, tech, comm)
eqCnsETechInpLC(cns, tech, comm)
eqCnsLETechInpLCSShareIn(cns, tech, comm, slice)
eqCnsLETechInpLCSShareOut(cns, tech, comm, slice)
eqCnsLETechInpLCS(cns, tech, comm, slice)
eqCnsGETechInpLCSShareIn(cns, tech, comm, slice)
eqCnsGETechInpLCSShareOut(cns, tech, comm, slice)
eqCnsGETechInpLCS(cns, tech, comm, slice)
eqCnsETechInpLCSShareIn(cns, tech, comm, slice)
eqCnsETechInpLCSShareOut(cns, tech, comm, slice)
eqCnsETechInpLCS(cns, tech, comm, slice)
eqCnsLETechInpLCYShareIn(cns, tech, comm, year)
eqCnsLETechInpLCYShareOut(cns, tech, comm, year)
eqCnsLETechInpLCY(cns, tech, comm, year)
eqCnsGETechInpLCYShareIn(cns, tech, comm, year)
eqCnsGETechInpLCYShareOut(cns, tech, comm, year)
eqCnsGETechInpLCY(cns, tech, comm, year)
eqCnsETechInpLCYShareIn(cns, tech, comm, year)
eqCnsETechInpLCYShareOut(cns, tech, comm, year)
eqCnsETechInpLCY(cns, tech, comm, year)
eqCnsLETechInpLCYSShareIn(cns, tech, comm, year, slice)
eqCnsLETechInpLCYSShareOut(cns, tech, comm, year, slice)
eqCnsLETechInpLCYS(cns, tech, comm, year, slice)
eqCnsGETechInpLCYSShareIn(cns, tech, comm, year, slice)
eqCnsGETechInpLCYSShareOut(cns, tech, comm, year, slice)
eqCnsGETechInpLCYS(cns, tech, comm, year, slice)
eqCnsETechInpLCYSShareIn(cns, tech, comm, year, slice)
eqCnsETechInpLCYSShareOut(cns, tech, comm, year, slice)
eqCnsETechInpLCYS(cns, tech, comm, year, slice)
eqCnsLETechInpLCRShareIn(cns, tech, comm, region)
eqCnsLETechInpLCRShareOut(cns, tech, comm, region)
eqCnsLETechInpLCR(cns, tech, comm, region)
eqCnsGETechInpLCRShareIn(cns, tech, comm, region)
eqCnsGETechInpLCRShareOut(cns, tech, comm, region)
eqCnsGETechInpLCR(cns, tech, comm, region)
eqCnsETechInpLCRShareIn(cns, tech, comm, region)
eqCnsETechInpLCRShareOut(cns, tech, comm, region)
eqCnsETechInpLCR(cns, tech, comm, region)
eqCnsLETechInpLCRSShareIn(cns, tech, comm, region, slice)
eqCnsLETechInpLCRSShareOut(cns, tech, comm, region, slice)
eqCnsLETechInpLCRS(cns, tech, comm, region, slice)
eqCnsGETechInpLCRSShareIn(cns, tech, comm, region, slice)
eqCnsGETechInpLCRSShareOut(cns, tech, comm, region, slice)
eqCnsGETechInpLCRS(cns, tech, comm, region, slice)
eqCnsETechInpLCRSShareIn(cns, tech, comm, region, slice)
eqCnsETechInpLCRSShareOut(cns, tech, comm, region, slice)
eqCnsETechInpLCRS(cns, tech, comm, region, slice)
eqCnsLETechInpLCRYShareIn(cns, tech, comm, region, year)
eqCnsLETechInpLCRYShareOut(cns, tech, comm, region, year)
eqCnsLETechInpLCRY(cns, tech, comm, region, year)
eqCnsGETechInpLCRYShareIn(cns, tech, comm, region, year)
eqCnsGETechInpLCRYShareOut(cns, tech, comm, region, year)
eqCnsGETechInpLCRY(cns, tech, comm, region, year)
eqCnsETechInpLCRYShareIn(cns, tech, comm, region, year)
eqCnsETechInpLCRYShareOut(cns, tech, comm, region, year)
eqCnsETechInpLCRY(cns, tech, comm, region, year)
eqCnsLETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsLETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsLETechInpLCRYS(cns, tech, comm, region, year, slice)
eqCnsGETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsGETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsGETechInpLCRYS(cns, tech, comm, region, year, slice)
eqCnsETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsETechInpLCRYS(cns, tech, comm, region, year, slice)
eqCnsLETechOutLShareIn(cns, tech)
eqCnsLETechOutLShareOut(cns, tech)
eqCnsLETechOutL(cns, tech)
eqCnsGETechOutLShareIn(cns, tech)
eqCnsGETechOutLShareOut(cns, tech)
eqCnsGETechOutL(cns, tech)
eqCnsETechOutLShareIn(cns, tech)
eqCnsETechOutLShareOut(cns, tech)
eqCnsETechOutL(cns, tech)
eqCnsLETechOutLSShareIn(cns, tech, slice)
eqCnsLETechOutLSShareOut(cns, tech, slice)
eqCnsLETechOutLS(cns, tech, slice)
eqCnsGETechOutLSShareIn(cns, tech, slice)
eqCnsGETechOutLSShareOut(cns, tech, slice)
eqCnsGETechOutLS(cns, tech, slice)
eqCnsETechOutLSShareIn(cns, tech, slice)
eqCnsETechOutLSShareOut(cns, tech, slice)
eqCnsETechOutLS(cns, tech, slice)
eqCnsLETechOutLYShareIn(cns, tech, year)
eqCnsLETechOutLYShareOut(cns, tech, year)
eqCnsLETechOutLY(cns, tech, year)
eqCnsGETechOutLYShareIn(cns, tech, year)
eqCnsGETechOutLYShareOut(cns, tech, year)
eqCnsGETechOutLY(cns, tech, year)
eqCnsETechOutLYShareIn(cns, tech, year)
eqCnsETechOutLYShareOut(cns, tech, year)
eqCnsETechOutLY(cns, tech, year)
eqCnsLETechOutLYSShareIn(cns, tech, year, slice)
eqCnsLETechOutLYSShareOut(cns, tech, year, slice)
eqCnsLETechOutLYS(cns, tech, year, slice)
eqCnsGETechOutLYSShareIn(cns, tech, year, slice)
eqCnsGETechOutLYSShareOut(cns, tech, year, slice)
eqCnsGETechOutLYS(cns, tech, year, slice)
eqCnsETechOutLYSShareIn(cns, tech, year, slice)
eqCnsETechOutLYSShareOut(cns, tech, year, slice)
eqCnsETechOutLYS(cns, tech, year, slice)
eqCnsLETechOutLRShareIn(cns, tech, region)
eqCnsLETechOutLRShareOut(cns, tech, region)
eqCnsLETechOutLR(cns, tech, region)
eqCnsGETechOutLRShareIn(cns, tech, region)
eqCnsGETechOutLRShareOut(cns, tech, region)
eqCnsGETechOutLR(cns, tech, region)
eqCnsETechOutLRShareIn(cns, tech, region)
eqCnsETechOutLRShareOut(cns, tech, region)
eqCnsETechOutLR(cns, tech, region)
eqCnsLETechOutLRSShareIn(cns, tech, region, slice)
eqCnsLETechOutLRSShareOut(cns, tech, region, slice)
eqCnsLETechOutLRS(cns, tech, region, slice)
eqCnsGETechOutLRSShareIn(cns, tech, region, slice)
eqCnsGETechOutLRSShareOut(cns, tech, region, slice)
eqCnsGETechOutLRS(cns, tech, region, slice)
eqCnsETechOutLRSShareIn(cns, tech, region, slice)
eqCnsETechOutLRSShareOut(cns, tech, region, slice)
eqCnsETechOutLRS(cns, tech, region, slice)
eqCnsLETechOutLRYShareIn(cns, tech, region, year)
eqCnsLETechOutLRYShareOut(cns, tech, region, year)
eqCnsLETechOutLRY(cns, tech, region, year)
eqCnsGETechOutLRYShareIn(cns, tech, region, year)
eqCnsGETechOutLRYShareOut(cns, tech, region, year)
eqCnsGETechOutLRY(cns, tech, region, year)
eqCnsETechOutLRYShareIn(cns, tech, region, year)
eqCnsETechOutLRYShareOut(cns, tech, region, year)
eqCnsETechOutLRY(cns, tech, region, year)
eqCnsLETechOutLRYSShareIn(cns, tech, region, year, slice)
eqCnsLETechOutLRYSShareOut(cns, tech, region, year, slice)
eqCnsLETechOutLRYS(cns, tech, region, year, slice)
eqCnsGETechOutLRYSShareIn(cns, tech, region, year, slice)
eqCnsGETechOutLRYSShareOut(cns, tech, region, year, slice)
eqCnsGETechOutLRYS(cns, tech, region, year, slice)
eqCnsETechOutLRYSShareIn(cns, tech, region, year, slice)
eqCnsETechOutLRYSShareOut(cns, tech, region, year, slice)
eqCnsETechOutLRYS(cns, tech, region, year, slice)
eqCnsLETechOutLCShareIn(cns, tech, comm)
eqCnsLETechOutLCShareOut(cns, tech, comm)
eqCnsLETechOutLC(cns, tech, comm)
eqCnsGETechOutLCShareIn(cns, tech, comm)
eqCnsGETechOutLCShareOut(cns, tech, comm)
eqCnsGETechOutLC(cns, tech, comm)
eqCnsETechOutLCShareIn(cns, tech, comm)
eqCnsETechOutLCShareOut(cns, tech, comm)
eqCnsETechOutLC(cns, tech, comm)
eqCnsLETechOutLCSShareIn(cns, tech, comm, slice)
eqCnsLETechOutLCSShareOut(cns, tech, comm, slice)
eqCnsLETechOutLCS(cns, tech, comm, slice)
eqCnsGETechOutLCSShareIn(cns, tech, comm, slice)
eqCnsGETechOutLCSShareOut(cns, tech, comm, slice)
eqCnsGETechOutLCS(cns, tech, comm, slice)
eqCnsETechOutLCSShareIn(cns, tech, comm, slice)
eqCnsETechOutLCSShareOut(cns, tech, comm, slice)
eqCnsETechOutLCS(cns, tech, comm, slice)
eqCnsLETechOutLCYShareIn(cns, tech, comm, year)
eqCnsLETechOutLCYShareOut(cns, tech, comm, year)
eqCnsLETechOutLCY(cns, tech, comm, year)
eqCnsGETechOutLCYShareIn(cns, tech, comm, year)
eqCnsGETechOutLCYShareOut(cns, tech, comm, year)
eqCnsGETechOutLCY(cns, tech, comm, year)
eqCnsETechOutLCYShareIn(cns, tech, comm, year)
eqCnsETechOutLCYShareOut(cns, tech, comm, year)
eqCnsETechOutLCY(cns, tech, comm, year)
eqCnsLETechOutLCYSShareIn(cns, tech, comm, year, slice)
eqCnsLETechOutLCYSShareOut(cns, tech, comm, year, slice)
eqCnsLETechOutLCYS(cns, tech, comm, year, slice)
eqCnsGETechOutLCYSShareIn(cns, tech, comm, year, slice)
eqCnsGETechOutLCYSShareOut(cns, tech, comm, year, slice)
eqCnsGETechOutLCYS(cns, tech, comm, year, slice)
eqCnsETechOutLCYSShareIn(cns, tech, comm, year, slice)
eqCnsETechOutLCYSShareOut(cns, tech, comm, year, slice)
eqCnsETechOutLCYS(cns, tech, comm, year, slice)
eqCnsLETechOutLCRShareIn(cns, tech, comm, region)
eqCnsLETechOutLCRShareOut(cns, tech, comm, region)
eqCnsLETechOutLCR(cns, tech, comm, region)
eqCnsGETechOutLCRShareIn(cns, tech, comm, region)
eqCnsGETechOutLCRShareOut(cns, tech, comm, region)
eqCnsGETechOutLCR(cns, tech, comm, region)
eqCnsETechOutLCRShareIn(cns, tech, comm, region)
eqCnsETechOutLCRShareOut(cns, tech, comm, region)
eqCnsETechOutLCR(cns, tech, comm, region)
eqCnsLETechOutLCRSShareIn(cns, tech, comm, region, slice)
eqCnsLETechOutLCRSShareOut(cns, tech, comm, region, slice)
eqCnsLETechOutLCRS(cns, tech, comm, region, slice)
eqCnsGETechOutLCRSShareIn(cns, tech, comm, region, slice)
eqCnsGETechOutLCRSShareOut(cns, tech, comm, region, slice)
eqCnsGETechOutLCRS(cns, tech, comm, region, slice)
eqCnsETechOutLCRSShareIn(cns, tech, comm, region, slice)
eqCnsETechOutLCRSShareOut(cns, tech, comm, region, slice)
eqCnsETechOutLCRS(cns, tech, comm, region, slice)
eqCnsLETechOutLCRYShareIn(cns, tech, comm, region, year)
eqCnsLETechOutLCRYShareOut(cns, tech, comm, region, year)
eqCnsLETechOutLCRY(cns, tech, comm, region, year)
eqCnsGETechOutLCRYShareIn(cns, tech, comm, region, year)
eqCnsGETechOutLCRYShareOut(cns, tech, comm, region, year)
eqCnsGETechOutLCRY(cns, tech, comm, region, year)
eqCnsETechOutLCRYShareIn(cns, tech, comm, region, year)
eqCnsETechOutLCRYShareOut(cns, tech, comm, region, year)
eqCnsETechOutLCRY(cns, tech, comm, region, year)
eqCnsLETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsLETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsLETechOutLCRYS(cns, tech, comm, region, year, slice)
eqCnsGETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsGETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsGETechOutLCRYS(cns, tech, comm, region, year, slice)
eqCnsETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)
eqCnsETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)
eqCnsETechOutLCRYS(cns, tech, comm, region, year, slice)
eqCnsLETechCapL(cns, tech)
eqCnsGETechCapL(cns, tech)
eqCnsETechCapL(cns, tech)
eqCnsLETechCapLY(cns, tech, year)
eqCnsGETechCapLY(cns, tech, year)
eqCnsETechCapLY(cns, tech, year)
eqCnsLETechCapLR(cns, tech, region)
eqCnsGETechCapLR(cns, tech, region)
eqCnsETechCapLR(cns, tech, region)
eqCnsLETechCapLRY(cns, tech, region, year)
eqCnsGETechCapLRY(cns, tech, region, year)
eqCnsETechCapLRY(cns, tech, region, year)
eqCnsLETechNewCapL(cns, tech)
eqCnsGETechNewCapL(cns, tech)
eqCnsETechNewCapL(cns, tech)
eqCnsLETechNewCapLY(cns, tech, year)
eqCnsGETechNewCapLY(cns, tech, year)
eqCnsETechNewCapLY(cns, tech, year)
eqCnsLETechNewCapLR(cns, tech, region)
eqCnsGETechNewCapLR(cns, tech, region)
eqCnsETechNewCapLR(cns, tech, region)
eqCnsLETechNewCapLRY(cns, tech, region, year)
eqCnsGETechNewCapLRY(cns, tech, region, year)
eqCnsETechNewCapLRY(cns, tech, region, year)
eqCnsLESupOutShareIn(cns)
eqCnsLESupOutShareOut(cns)
eqCnsLESupOut(cns)
eqCnsGESupOutShareIn(cns)
eqCnsGESupOutShareOut(cns)
eqCnsGESupOut(cns)
eqCnsESupOutShareIn(cns)
eqCnsESupOutShareOut(cns)
eqCnsESupOut(cns)
eqCnsLESupOutSShareIn(cns, slice)
eqCnsLESupOutSShareOut(cns, slice)
eqCnsLESupOutS(cns, slice)
eqCnsGESupOutSShareIn(cns, slice)
eqCnsGESupOutSShareOut(cns, slice)
eqCnsGESupOutS(cns, slice)
eqCnsESupOutSShareIn(cns, slice)
eqCnsESupOutSShareOut(cns, slice)
eqCnsESupOutS(cns, slice)
eqCnsLESupOutYShareIn(cns, year)
eqCnsLESupOutYShareOut(cns, year)
eqCnsLESupOutY(cns, year)
eqCnsGESupOutYShareIn(cns, year)
eqCnsGESupOutYShareOut(cns, year)
eqCnsGESupOutY(cns, year)
eqCnsESupOutYShareIn(cns, year)
eqCnsESupOutYShareOut(cns, year)
eqCnsESupOutY(cns, year)
eqCnsLESupOutYSShareIn(cns, year, slice)
eqCnsLESupOutYSShareOut(cns, year, slice)
eqCnsLESupOutYS(cns, year, slice)
eqCnsGESupOutYSShareIn(cns, year, slice)
eqCnsGESupOutYSShareOut(cns, year, slice)
eqCnsGESupOutYS(cns, year, slice)
eqCnsESupOutYSShareIn(cns, year, slice)
eqCnsESupOutYSShareOut(cns, year, slice)
eqCnsESupOutYS(cns, year, slice)
eqCnsLESupOutRShareIn(cns, region)
eqCnsLESupOutRShareOut(cns, region)
eqCnsLESupOutR(cns, region)
eqCnsGESupOutRShareIn(cns, region)
eqCnsGESupOutRShareOut(cns, region)
eqCnsGESupOutR(cns, region)
eqCnsESupOutRShareIn(cns, region)
eqCnsESupOutRShareOut(cns, region)
eqCnsESupOutR(cns, region)
eqCnsLESupOutRSShareIn(cns, region, slice)
eqCnsLESupOutRSShareOut(cns, region, slice)
eqCnsLESupOutRS(cns, region, slice)
eqCnsGESupOutRSShareIn(cns, region, slice)
eqCnsGESupOutRSShareOut(cns, region, slice)
eqCnsGESupOutRS(cns, region, slice)
eqCnsESupOutRSShareIn(cns, region, slice)
eqCnsESupOutRSShareOut(cns, region, slice)
eqCnsESupOutRS(cns, region, slice)
eqCnsLESupOutRYShareIn(cns, region, year)
eqCnsLESupOutRYShareOut(cns, region, year)
eqCnsLESupOutRY(cns, region, year)
eqCnsGESupOutRYShareIn(cns, region, year)
eqCnsGESupOutRYShareOut(cns, region, year)
eqCnsGESupOutRY(cns, region, year)
eqCnsESupOutRYShareIn(cns, region, year)
eqCnsESupOutRYShareOut(cns, region, year)
eqCnsESupOutRY(cns, region, year)
eqCnsLESupOutRYSShareIn(cns, region, year, slice)
eqCnsLESupOutRYSShareOut(cns, region, year, slice)
eqCnsLESupOutRYS(cns, region, year, slice)
eqCnsGESupOutRYSShareIn(cns, region, year, slice)
eqCnsGESupOutRYSShareOut(cns, region, year, slice)
eqCnsGESupOutRYS(cns, region, year, slice)
eqCnsESupOutRYSShareIn(cns, region, year, slice)
eqCnsESupOutRYSShareOut(cns, region, year, slice)
eqCnsESupOutRYS(cns, region, year, slice)
eqCnsLESupOutCShareIn(cns, comm)
eqCnsLESupOutCShareOut(cns, comm)
eqCnsLESupOutC(cns, comm)
eqCnsGESupOutCShareIn(cns, comm)
eqCnsGESupOutCShareOut(cns, comm)
eqCnsGESupOutC(cns, comm)
eqCnsESupOutCShareIn(cns, comm)
eqCnsESupOutCShareOut(cns, comm)
eqCnsESupOutC(cns, comm)
eqCnsLESupOutCSShareIn(cns, comm, slice)
eqCnsLESupOutCSShareOut(cns, comm, slice)
eqCnsLESupOutCS(cns, comm, slice)
eqCnsGESupOutCSShareIn(cns, comm, slice)
eqCnsGESupOutCSShareOut(cns, comm, slice)
eqCnsGESupOutCS(cns, comm, slice)
eqCnsESupOutCSShareIn(cns, comm, slice)
eqCnsESupOutCSShareOut(cns, comm, slice)
eqCnsESupOutCS(cns, comm, slice)
eqCnsLESupOutCYShareIn(cns, comm, year)
eqCnsLESupOutCYShareOut(cns, comm, year)
eqCnsLESupOutCY(cns, comm, year)
eqCnsGESupOutCYShareIn(cns, comm, year)
eqCnsGESupOutCYShareOut(cns, comm, year)
eqCnsGESupOutCY(cns, comm, year)
eqCnsESupOutCYShareIn(cns, comm, year)
eqCnsESupOutCYShareOut(cns, comm, year)
eqCnsESupOutCY(cns, comm, year)
eqCnsLESupOutCYSShareIn(cns, comm, year, slice)
eqCnsLESupOutCYSShareOut(cns, comm, year, slice)
eqCnsLESupOutCYS(cns, comm, year, slice)
eqCnsGESupOutCYSShareIn(cns, comm, year, slice)
eqCnsGESupOutCYSShareOut(cns, comm, year, slice)
eqCnsGESupOutCYS(cns, comm, year, slice)
eqCnsESupOutCYSShareIn(cns, comm, year, slice)
eqCnsESupOutCYSShareOut(cns, comm, year, slice)
eqCnsESupOutCYS(cns, comm, year, slice)
eqCnsLESupOutCRShareIn(cns, comm, region)
eqCnsLESupOutCRShareOut(cns, comm, region)
eqCnsLESupOutCR(cns, comm, region)
eqCnsGESupOutCRShareIn(cns, comm, region)
eqCnsGESupOutCRShareOut(cns, comm, region)
eqCnsGESupOutCR(cns, comm, region)
eqCnsESupOutCRShareIn(cns, comm, region)
eqCnsESupOutCRShareOut(cns, comm, region)
eqCnsESupOutCR(cns, comm, region)
eqCnsLESupOutCRSShareIn(cns, comm, region, slice)
eqCnsLESupOutCRSShareOut(cns, comm, region, slice)
eqCnsLESupOutCRS(cns, comm, region, slice)
eqCnsGESupOutCRSShareIn(cns, comm, region, slice)
eqCnsGESupOutCRSShareOut(cns, comm, region, slice)
eqCnsGESupOutCRS(cns, comm, region, slice)
eqCnsESupOutCRSShareIn(cns, comm, region, slice)
eqCnsESupOutCRSShareOut(cns, comm, region, slice)
eqCnsESupOutCRS(cns, comm, region, slice)
eqCnsLESupOutCRYShareIn(cns, comm, region, year)
eqCnsLESupOutCRYShareOut(cns, comm, region, year)
eqCnsLESupOutCRY(cns, comm, region, year)
eqCnsGESupOutCRYShareIn(cns, comm, region, year)
eqCnsGESupOutCRYShareOut(cns, comm, region, year)
eqCnsGESupOutCRY(cns, comm, region, year)
eqCnsESupOutCRYShareIn(cns, comm, region, year)
eqCnsESupOutCRYShareOut(cns, comm, region, year)
eqCnsESupOutCRY(cns, comm, region, year)
eqCnsLESupOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsLESupOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsLESupOutCRYS(cns, comm, region, year, slice)
eqCnsGESupOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsGESupOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsGESupOutCRYS(cns, comm, region, year, slice)
eqCnsESupOutCRYSShareIn(cns, comm, region, year, slice)
eqCnsESupOutCRYSShareOut(cns, comm, region, year, slice)
eqCnsESupOutCRYS(cns, comm, region, year, slice)
eqCnsLESupOutLShareIn(cns, sup)
eqCnsLESupOutLShareOut(cns, sup)
eqCnsLESupOutL(cns, sup)
eqCnsGESupOutLShareIn(cns, sup)
eqCnsGESupOutLShareOut(cns, sup)
eqCnsGESupOutL(cns, sup)
eqCnsESupOutLShareIn(cns, sup)
eqCnsESupOutLShareOut(cns, sup)
eqCnsESupOutL(cns, sup)
eqCnsLESupOutLSShareIn(cns, sup, slice)
eqCnsLESupOutLSShareOut(cns, sup, slice)
eqCnsLESupOutLS(cns, sup, slice)
eqCnsGESupOutLSShareIn(cns, sup, slice)
eqCnsGESupOutLSShareOut(cns, sup, slice)
eqCnsGESupOutLS(cns, sup, slice)
eqCnsESupOutLSShareIn(cns, sup, slice)
eqCnsESupOutLSShareOut(cns, sup, slice)
eqCnsESupOutLS(cns, sup, slice)
eqCnsLESupOutLYShareIn(cns, sup, year)
eqCnsLESupOutLYShareOut(cns, sup, year)
eqCnsLESupOutLY(cns, sup, year)
eqCnsGESupOutLYShareIn(cns, sup, year)
eqCnsGESupOutLYShareOut(cns, sup, year)
eqCnsGESupOutLY(cns, sup, year)
eqCnsESupOutLYShareIn(cns, sup, year)
eqCnsESupOutLYShareOut(cns, sup, year)
eqCnsESupOutLY(cns, sup, year)
eqCnsLESupOutLYSShareIn(cns, sup, year, slice)
eqCnsLESupOutLYSShareOut(cns, sup, year, slice)
eqCnsLESupOutLYS(cns, sup, year, slice)
eqCnsGESupOutLYSShareIn(cns, sup, year, slice)
eqCnsGESupOutLYSShareOut(cns, sup, year, slice)
eqCnsGESupOutLYS(cns, sup, year, slice)
eqCnsESupOutLYSShareIn(cns, sup, year, slice)
eqCnsESupOutLYSShareOut(cns, sup, year, slice)
eqCnsESupOutLYS(cns, sup, year, slice)
eqCnsLESupOutLRShareIn(cns, sup, region)
eqCnsLESupOutLRShareOut(cns, sup, region)
eqCnsLESupOutLR(cns, sup, region)
eqCnsGESupOutLRShareIn(cns, sup, region)
eqCnsGESupOutLRShareOut(cns, sup, region)
eqCnsGESupOutLR(cns, sup, region)
eqCnsESupOutLRShareIn(cns, sup, region)
eqCnsESupOutLRShareOut(cns, sup, region)
eqCnsESupOutLR(cns, sup, region)
eqCnsLESupOutLRSShareIn(cns, sup, region, slice)
eqCnsLESupOutLRSShareOut(cns, sup, region, slice)
eqCnsLESupOutLRS(cns, sup, region, slice)
eqCnsGESupOutLRSShareIn(cns, sup, region, slice)
eqCnsGESupOutLRSShareOut(cns, sup, region, slice)
eqCnsGESupOutLRS(cns, sup, region, slice)
eqCnsESupOutLRSShareIn(cns, sup, region, slice)
eqCnsESupOutLRSShareOut(cns, sup, region, slice)
eqCnsESupOutLRS(cns, sup, region, slice)
eqCnsLESupOutLRYShareIn(cns, sup, region, year)
eqCnsLESupOutLRYShareOut(cns, sup, region, year)
eqCnsLESupOutLRY(cns, sup, region, year)
eqCnsGESupOutLRYShareIn(cns, sup, region, year)
eqCnsGESupOutLRYShareOut(cns, sup, region, year)
eqCnsGESupOutLRY(cns, sup, region, year)
eqCnsESupOutLRYShareIn(cns, sup, region, year)
eqCnsESupOutLRYShareOut(cns, sup, region, year)
eqCnsESupOutLRY(cns, sup, region, year)
eqCnsLESupOutLRYSShareIn(cns, sup, region, year, slice)
eqCnsLESupOutLRYSShareOut(cns, sup, region, year, slice)
eqCnsLESupOutLRYS(cns, sup, region, year, slice)
eqCnsGESupOutLRYSShareIn(cns, sup, region, year, slice)
eqCnsGESupOutLRYSShareOut(cns, sup, region, year, slice)
eqCnsGESupOutLRYS(cns, sup, region, year, slice)
eqCnsESupOutLRYSShareIn(cns, sup, region, year, slice)
eqCnsESupOutLRYSShareOut(cns, sup, region, year, slice)
eqCnsESupOutLRYS(cns, sup, region, year, slice)
eqCnsLESupOutLCShareIn(cns, sup, comm)
eqCnsLESupOutLCShareOut(cns, sup, comm)
eqCnsLESupOutLC(cns, sup, comm)
eqCnsGESupOutLCShareIn(cns, sup, comm)
eqCnsGESupOutLCShareOut(cns, sup, comm)
eqCnsGESupOutLC(cns, sup, comm)
eqCnsESupOutLCShareIn(cns, sup, comm)
eqCnsESupOutLCShareOut(cns, sup, comm)
eqCnsESupOutLC(cns, sup, comm)
eqCnsLESupOutLCSShareIn(cns, sup, comm, slice)
eqCnsLESupOutLCSShareOut(cns, sup, comm, slice)
eqCnsLESupOutLCS(cns, sup, comm, slice)
eqCnsGESupOutLCSShareIn(cns, sup, comm, slice)
eqCnsGESupOutLCSShareOut(cns, sup, comm, slice)
eqCnsGESupOutLCS(cns, sup, comm, slice)
eqCnsESupOutLCSShareIn(cns, sup, comm, slice)
eqCnsESupOutLCSShareOut(cns, sup, comm, slice)
eqCnsESupOutLCS(cns, sup, comm, slice)
eqCnsLESupOutLCYShareIn(cns, sup, comm, year)
eqCnsLESupOutLCYShareOut(cns, sup, comm, year)
eqCnsLESupOutLCY(cns, sup, comm, year)
eqCnsGESupOutLCYShareIn(cns, sup, comm, year)
eqCnsGESupOutLCYShareOut(cns, sup, comm, year)
eqCnsGESupOutLCY(cns, sup, comm, year)
eqCnsESupOutLCYShareIn(cns, sup, comm, year)
eqCnsESupOutLCYShareOut(cns, sup, comm, year)
eqCnsESupOutLCY(cns, sup, comm, year)
eqCnsLESupOutLCYSShareIn(cns, sup, comm, year, slice)
eqCnsLESupOutLCYSShareOut(cns, sup, comm, year, slice)
eqCnsLESupOutLCYS(cns, sup, comm, year, slice)
eqCnsGESupOutLCYSShareIn(cns, sup, comm, year, slice)
eqCnsGESupOutLCYSShareOut(cns, sup, comm, year, slice)
eqCnsGESupOutLCYS(cns, sup, comm, year, slice)
eqCnsESupOutLCYSShareIn(cns, sup, comm, year, slice)
eqCnsESupOutLCYSShareOut(cns, sup, comm, year, slice)
eqCnsESupOutLCYS(cns, sup, comm, year, slice)
eqCnsLESupOutLCRShareIn(cns, sup, comm, region)
eqCnsLESupOutLCRShareOut(cns, sup, comm, region)
eqCnsLESupOutLCR(cns, sup, comm, region)
eqCnsGESupOutLCRShareIn(cns, sup, comm, region)
eqCnsGESupOutLCRShareOut(cns, sup, comm, region)
eqCnsGESupOutLCR(cns, sup, comm, region)
eqCnsESupOutLCRShareIn(cns, sup, comm, region)
eqCnsESupOutLCRShareOut(cns, sup, comm, region)
eqCnsESupOutLCR(cns, sup, comm, region)
eqCnsLESupOutLCRSShareIn(cns, sup, comm, region, slice)
eqCnsLESupOutLCRSShareOut(cns, sup, comm, region, slice)
eqCnsLESupOutLCRS(cns, sup, comm, region, slice)
eqCnsGESupOutLCRSShareIn(cns, sup, comm, region, slice)
eqCnsGESupOutLCRSShareOut(cns, sup, comm, region, slice)
eqCnsGESupOutLCRS(cns, sup, comm, region, slice)
eqCnsESupOutLCRSShareIn(cns, sup, comm, region, slice)
eqCnsESupOutLCRSShareOut(cns, sup, comm, region, slice)
eqCnsESupOutLCRS(cns, sup, comm, region, slice)
eqCnsLESupOutLCRYShareIn(cns, sup, comm, region, year)
eqCnsLESupOutLCRYShareOut(cns, sup, comm, region, year)
eqCnsLESupOutLCRY(cns, sup, comm, region, year)
eqCnsGESupOutLCRYShareIn(cns, sup, comm, region, year)
eqCnsGESupOutLCRYShareOut(cns, sup, comm, region, year)
eqCnsGESupOutLCRY(cns, sup, comm, region, year)
eqCnsESupOutLCRYShareIn(cns, sup, comm, region, year)
eqCnsESupOutLCRYShareOut(cns, sup, comm, region, year)
eqCnsESupOutLCRY(cns, sup, comm, region, year)
eqCnsLESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)
eqCnsLESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)
eqCnsLESupOutLCRYS(cns, sup, comm, region, year, slice)
eqCnsGESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)
eqCnsGESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)
eqCnsGESupOutLCRYS(cns, sup, comm, region, year, slice)
eqCnsESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)
eqCnsESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)
eqCnsESupOutLCRYS(cns, sup, comm, region, year, slice)
eqCnsLETotInp(cns)
eqCnsGETotInp(cns)
eqCnsETotInp(cns)
eqCnsLETotInpS(cns, slice)
eqCnsGETotInpS(cns, slice)
eqCnsETotInpS(cns, slice)
eqCnsLETotInpY(cns, year)
eqCnsGETotInpY(cns, year)
eqCnsETotInpY(cns, year)
eqCnsLETotInpYS(cns, year, slice)
eqCnsGETotInpYS(cns, year, slice)
eqCnsETotInpYS(cns, year, slice)
eqCnsLETotInpR(cns, region)
eqCnsGETotInpR(cns, region)
eqCnsETotInpR(cns, region)
eqCnsLETotInpRS(cns, region, slice)
eqCnsGETotInpRS(cns, region, slice)
eqCnsETotInpRS(cns, region, slice)
eqCnsLETotInpRY(cns, region, year)
eqCnsGETotInpRY(cns, region, year)
eqCnsETotInpRY(cns, region, year)
eqCnsLETotInpRYS(cns, region, year, slice)
eqCnsGETotInpRYS(cns, region, year, slice)
eqCnsETotInpRYS(cns, region, year, slice)
eqCnsLETotInpC(cns, comm)
eqCnsGETotInpC(cns, comm)
eqCnsETotInpC(cns, comm)
eqCnsLETotInpCS(cns, comm, slice)
eqCnsGETotInpCS(cns, comm, slice)
eqCnsETotInpCS(cns, comm, slice)
eqCnsLETotInpCY(cns, comm, year)
eqCnsGETotInpCY(cns, comm, year)
eqCnsETotInpCY(cns, comm, year)
eqCnsLETotInpCYS(cns, comm, year, slice)
eqCnsGETotInpCYS(cns, comm, year, slice)
eqCnsETotInpCYS(cns, comm, year, slice)
eqCnsLETotInpCR(cns, comm, region)
eqCnsGETotInpCR(cns, comm, region)
eqCnsETotInpCR(cns, comm, region)
eqCnsLETotInpCRS(cns, comm, region, slice)
eqCnsGETotInpCRS(cns, comm, region, slice)
eqCnsETotInpCRS(cns, comm, region, slice)
eqCnsLETotInpCRY(cns, comm, region, year)
eqCnsGETotInpCRY(cns, comm, region, year)
eqCnsETotInpCRY(cns, comm, region, year)
eqCnsLETotInpCRYS(cns, comm, region, year, slice)
eqCnsGETotInpCRYS(cns, comm, region, year, slice)
eqCnsETotInpCRYS(cns, comm, region, year, slice)
eqCnsLETotOut(cns)
eqCnsGETotOut(cns)
eqCnsETotOut(cns)
eqCnsLETotOutS(cns, slice)
eqCnsGETotOutS(cns, slice)
eqCnsETotOutS(cns, slice)
eqCnsLETotOutY(cns, year)
eqCnsGETotOutY(cns, year)
eqCnsETotOutY(cns, year)
eqCnsLETotOutYS(cns, year, slice)
eqCnsGETotOutYS(cns, year, slice)
eqCnsETotOutYS(cns, year, slice)
eqCnsLETotOutR(cns, region)
eqCnsGETotOutR(cns, region)
eqCnsETotOutR(cns, region)
eqCnsLETotOutRS(cns, region, slice)
eqCnsGETotOutRS(cns, region, slice)
eqCnsETotOutRS(cns, region, slice)
eqCnsLETotOutRY(cns, region, year)
eqCnsGETotOutRY(cns, region, year)
eqCnsETotOutRY(cns, region, year)
eqCnsLETotOutRYS(cns, region, year, slice)
eqCnsGETotOutRYS(cns, region, year, slice)
eqCnsETotOutRYS(cns, region, year, slice)
eqCnsLETotOutC(cns, comm)
eqCnsGETotOutC(cns, comm)
eqCnsETotOutC(cns, comm)
eqCnsLETotOutCS(cns, comm, slice)
eqCnsGETotOutCS(cns, comm, slice)
eqCnsETotOutCS(cns, comm, slice)
eqCnsLETotOutCY(cns, comm, year)
eqCnsGETotOutCY(cns, comm, year)
eqCnsETotOutCY(cns, comm, year)
eqCnsLETotOutCYS(cns, comm, year, slice)
eqCnsGETotOutCYS(cns, comm, year, slice)
eqCnsETotOutCYS(cns, comm, year, slice)
eqCnsLETotOutCR(cns, comm, region)
eqCnsGETotOutCR(cns, comm, region)
eqCnsETotOutCR(cns, comm, region)
eqCnsLETotOutCRS(cns, comm, region, slice)
eqCnsGETotOutCRS(cns, comm, region, slice)
eqCnsETotOutCRS(cns, comm, region, slice)
eqCnsLETotOutCRY(cns, comm, region, year)
eqCnsGETotOutCRY(cns, comm, region, year)
eqCnsETotOutCRY(cns, comm, region, year)
eqCnsLETotOutCRYS(cns, comm, region, year, slice)
eqCnsGETotOutCRYS(cns, comm, region, year, slice)
eqCnsETotOutCRYS(cns, comm, region, year, slice)
;




eqCnsLETechInpShareIn(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpShareOut(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInp(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns))
        )
       =l= 0;

eqCnsGETechInpShareIn(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpShareOut(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInp(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns))
        )
       =g= 0;

eqCnsETechInpShareIn(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpShareOut(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInp(cns)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhs(cns))
        )
       =e= 0;

eqCnsLETechInpSShareIn(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpSShareOut(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpS(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =l= 0;

eqCnsGETechInpSShareIn(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpSShareOut(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpS(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =g= 0;

eqCnsETechInpSShareIn(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpSShareOut(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpS(cns, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =e= 0;

eqCnsLETechInpYShareIn(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpYShareOut(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpY(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year))
       =l= 0;

eqCnsGETechInpYShareIn(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpYShareOut(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpY(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year))
       =g= 0;

eqCnsETechInpYShareIn(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpYShareOut(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpY(cns, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsY(cns, year))
       =e= 0;

eqCnsLETechInpYSShareIn(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpYSShareOut(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpYS(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =l= 0;

eqCnsGETechInpYSShareIn(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpYSShareOut(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpYS(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =g= 0;

eqCnsETechInpYSShareIn(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpYSShareOut(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpYS(cns, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =e= 0;

eqCnsLETechInpRShareIn(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpRShareOut(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpR(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETechInpRShareIn(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpRShareOut(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpR(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETechInpRShareIn(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpRShareOut(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpR(cns, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETechInpRSShareIn(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpRSShareOut(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpRS(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =l= 0;

eqCnsGETechInpRSShareIn(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpRSShareOut(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpRS(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =g= 0;

eqCnsETechInpRSShareIn(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpRSShareOut(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpRS(cns, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =e= 0;

eqCnsLETechInpRYShareIn(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpRYShareOut(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpRY(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETechInpRYShareIn(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpRYShareOut(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpRY(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETechInpRYShareIn(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpRYShareOut(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpRY(cns, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETechInpRYSShareIn(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpRYSShareOut(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpRYS(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =l= 0;

eqCnsGETechInpRYSShareIn(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpRYSShareOut(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpRYS(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =g= 0;

eqCnsETechInpRYSShareIn(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpRYSShareOut(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpRYS(cns, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =e= 0;

eqCnsLETechInpCShareIn(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCShareOut(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpC(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =l= 0;

eqCnsGETechInpCShareIn(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCShareOut(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpC(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =g= 0;

eqCnsETechInpCShareIn(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCShareOut(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpC(cns, comm)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =e= 0;

eqCnsLETechInpCSShareIn(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCSShareOut(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCS(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =l= 0;

eqCnsGETechInpCSShareIn(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCSShareOut(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCS(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =g= 0;

eqCnsETechInpCSShareIn(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCSShareOut(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCS(cns, comm, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =e= 0;

eqCnsLETechInpCYShareIn(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCYShareOut(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCY(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =l= 0;

eqCnsGETechInpCYShareIn(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCYShareOut(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCY(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =g= 0;

eqCnsETechInpCYShareIn(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCYShareOut(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCY(cns, comm, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =e= 0;

eqCnsLETechInpCYSShareIn(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCYSShareOut(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCYS(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =l= 0;

eqCnsGETechInpCYSShareIn(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCYSShareOut(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCYS(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =g= 0;

eqCnsETechInpCYSShareIn(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCYSShareOut(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCYS(cns, comm, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =e= 0;

eqCnsLETechInpCRShareIn(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCRShareOut(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCR(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =l= 0;

eqCnsGETechInpCRShareIn(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCRShareOut(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCR(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =g= 0;

eqCnsETechInpCRShareIn(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCRShareOut(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCR(cns, comm, region)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =e= 0;

eqCnsLETechInpCRSShareIn(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCRSShareOut(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpCRS(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =l= 0;

eqCnsGETechInpCRSShareIn(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCRSShareOut(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpCRS(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =g= 0;

eqCnsETechInpCRSShareIn(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCRSShareOut(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpCRS(cns, comm, region, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =e= 0;

eqCnsLETechInpCRYShareIn(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCRYShareOut(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCRY(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =l= 0;

eqCnsGETechInpCRYShareIn(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCRYShareOut(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCRY(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =g= 0;

eqCnsETechInpCRYShareIn(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCRYShareOut(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCRY(cns, comm, region, year)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =e= 0;

eqCnsLETechInpCRYSShareIn(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCRYSShareOut(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpCRYS(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =l= 0;

eqCnsGETechInpCRYSShareIn(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCRYSShareOut(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpCRYS(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =g= 0;

eqCnsETechInpCRYSShareIn(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCRYSShareOut(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpCRYS(cns, comm, region, year, slice)$(mCnsInpTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =e= 0;

eqCnsLETechOutShareIn(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutShareOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns))
        )
       =l= 0;

eqCnsGETechOutShareIn(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutShareOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns))
        )
       =g= 0;

eqCnsETechOutShareIn(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutShareOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOut(cns)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhs(cns))
        )
       =e= 0;

eqCnsLETechOutSShareIn(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutSShareOut(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutS(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =l= 0;

eqCnsGETechOutSShareIn(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutSShareOut(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutS(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =g= 0;

eqCnsETechOutSShareIn(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutSShareOut(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutS(cns, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =e= 0;

eqCnsLETechOutYShareIn(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutYShareOut(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutY(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year))
       =l= 0;

eqCnsGETechOutYShareIn(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutYShareOut(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutY(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year))
       =g= 0;

eqCnsETechOutYShareIn(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutYShareOut(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutY(cns, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsY(cns, year))
       =e= 0;

eqCnsLETechOutYSShareIn(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutYSShareOut(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutYS(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =l= 0;

eqCnsGETechOutYSShareIn(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutYSShareOut(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutYS(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =g= 0;

eqCnsETechOutYSShareIn(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutYSShareOut(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutYS(cns, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, region)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =e= 0;

eqCnsLETechOutRShareIn(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutRShareOut(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutR(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETechOutRShareIn(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutRShareOut(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutR(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETechOutRShareIn(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutRShareOut(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutR(cns, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETechOutRSShareIn(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutRSShareOut(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutRS(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =l= 0;

eqCnsGETechOutRSShareIn(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutRSShareOut(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutRS(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =g= 0;

eqCnsETechOutRSShareIn(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutRSShareOut(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutRS(cns, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =e= 0;

eqCnsLETechOutRYShareIn(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutRYShareOut(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutRY(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETechOutRYShareIn(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutRYShareOut(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutRY(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETechOutRYShareIn(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutRYShareOut(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutRY(cns, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, comm, slice)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETechOutRYSShareIn(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutRYSShareOut(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutRYS(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =l= 0;

eqCnsGETechOutRYSShareIn(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutRYSShareOut(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutRYS(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =g= 0;

eqCnsETechOutRYSShareIn(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutRYSShareOut(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutRYS(cns, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, comm)$(mCnsTech(cns, tech) and mCnsComm(cns, comm) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =e= 0;

eqCnsLETechOutCShareIn(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCShareOut(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutC(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =l= 0;

eqCnsGETechOutCShareIn(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCShareOut(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutC(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =g= 0;

eqCnsETechOutCShareIn(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCShareOut(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutC(cns, comm)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =e= 0;

eqCnsLETechOutCSShareIn(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCSShareOut(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCS(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =l= 0;

eqCnsGETechOutCSShareIn(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCSShareOut(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCS(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =g= 0;

eqCnsETechOutCSShareIn(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCSShareOut(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCS(cns, comm, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =e= 0;

eqCnsLETechOutCYShareIn(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCYShareOut(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCY(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =l= 0;

eqCnsGETechOutCYShareIn(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCYShareOut(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCY(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =g= 0;

eqCnsETechOutCYShareIn(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCYShareOut(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCY(cns, comm, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region, slice)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =e= 0;

eqCnsLETechOutCYSShareIn(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCYSShareOut(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCYS(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =l= 0;

eqCnsGETechOutCYSShareIn(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCYSShareOut(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCYS(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =g= 0;

eqCnsETechOutCYSShareIn(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCYSShareOut(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCYS(cns, comm, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =e= 0;

eqCnsLETechOutCRShareIn(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCRShareOut(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCR(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =l= 0;

eqCnsGETechOutCRShareIn(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCRShareOut(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCR(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =g= 0;

eqCnsETechOutCRShareIn(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCRShareOut(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCR(cns, comm, region)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, slice, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =e= 0;

eqCnsLETechOutCRSShareIn(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCRSShareOut(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutCRS(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =l= 0;

eqCnsGETechOutCRSShareIn(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCRSShareOut(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutCRS(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =g= 0;

eqCnsETechOutCRSShareIn(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCRSShareOut(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutCRS(cns, comm, region, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =e= 0;

eqCnsLETechOutCRYShareIn(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCRYShareOut(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCRY(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =l= 0;

eqCnsGETechOutCRYShareIn(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCRYShareOut(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCRY(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =g= 0;

eqCnsETechOutCRYShareIn(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCRYShareOut(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCRY(cns, comm, region, year)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, slice)$(mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =e= 0;

eqCnsLETechOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutCRYS(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =l= 0;

eqCnsGETechOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutCRYS(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =g= 0;

eqCnsETechOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutCRYS(cns, comm, region, year, slice)$(mCnsOutTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =e= 0;

eqCnsLETechCap(cns)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhs(cns))
        )
       =l= 0;

eqCnsGETechCap(cns)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhs(cns))
        )
       =g= 0;

eqCnsETechCap(cns)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhs(cns))
        )
       =e= 0;

eqCnsLETechCapY(cns, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsY(cns, year))
       =l= 0;

eqCnsGETechCapY(cns, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsY(cns, year))
       =g= 0;

eqCnsETechCapY(cns, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsY(cns, year))
       =e= 0;

eqCnsLETechCapR(cns, region)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETechCapR(cns, region)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETechCapR(cns, region)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETechCapRY(cns, region, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETechCapRY(cns, region, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETechCapRY(cns, region, year)$(mCnsCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETechNewCap(cns)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhs(cns))
        )
       =l= 0;

eqCnsGETechNewCap(cns)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhs(cns))
        )
       =g= 0;

eqCnsETechNewCap(cns)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((tech, region, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhs(cns))
        )
       =e= 0;

eqCnsLETechNewCapY(cns, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsY(cns, year))
       =l= 0;

eqCnsGETechNewCapY(cns, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsY(cns, year))
       =g= 0;

eqCnsETechNewCapY(cns, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech, region)$(mCnsTech(cns, tech) and mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsY(cns, year))
       =e= 0;

eqCnsLETechNewCapR(cns, region)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETechNewCapR(cns, region)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETechNewCapR(cns, region)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((tech, year, yeare, yearp)$(mCnsTech(cns, tech) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETechNewCapRY(cns, region, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETechNewCapRY(cns, region, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETechNewCapRY(cns, region, year)$(mCnsNewCapTech(cns) and not(mCnsLType(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((tech)$(mCnsTech(cns, tech) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETechInpLShareIn(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLShareOut(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpL(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =l= 0;

eqCnsGETechInpLShareIn(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLShareOut(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpL(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =g= 0;

eqCnsETechInpLShareIn(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLShareOut(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpL(cns, tech)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =e= 0;

eqCnsLETechInpLSShareIn(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLSShareOut(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLS(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =l= 0;

eqCnsGETechInpLSShareIn(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLSShareOut(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLS(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =g= 0;

eqCnsETechInpLSShareIn(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLSShareOut(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLS(cns, tech, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =e= 0;

eqCnsLETechInpLYShareIn(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLYShareOut(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLY(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =l= 0;

eqCnsGETechInpLYShareIn(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLYShareOut(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLY(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =g= 0;

eqCnsETechInpLYShareIn(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLYShareOut(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLY(cns, tech, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =e= 0;

eqCnsLETechInpLYSShareIn(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLYSShareOut(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLYS(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =l= 0;

eqCnsGETechInpLYSShareIn(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLYSShareOut(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLYS(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =g= 0;

eqCnsETechInpLYSShareIn(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLYSShareOut(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLYS(cns, tech, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =e= 0;

eqCnsLETechInpLRShareIn(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLRShareOut(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLR(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =l= 0;

eqCnsGETechInpLRShareIn(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLRShareOut(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLR(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =g= 0;

eqCnsETechInpLRShareIn(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLRShareOut(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLR(cns, tech, region)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =e= 0;

eqCnsLETechInpLRSShareIn(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLRSShareOut(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLRS(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =l= 0;

eqCnsGETechInpLRSShareIn(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLRSShareOut(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLRS(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =g= 0;

eqCnsETechInpLRSShareIn(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLRSShareOut(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLRS(cns, tech, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =e= 0;

eqCnsLETechInpLRYShareIn(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLRYShareOut(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLRY(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =l= 0;

eqCnsGETechInpLRYShareIn(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLRYShareOut(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLRY(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =g= 0;

eqCnsETechInpLRYShareIn(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLRYShareOut(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLRY(cns, tech, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =e= 0;

eqCnsLETechInpLRYSShareIn(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLRYSShareOut(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLRYS(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =l= 0;

eqCnsGETechInpLRYSShareIn(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLRYSShareOut(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLRYS(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =g= 0;

eqCnsETechInpLRYSShareIn(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLRYSShareOut(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLRYS(cns, tech, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechInp(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =e= 0;

eqCnsLETechInpLCShareIn(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCShareOut(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLC(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =l= 0;

eqCnsGETechInpLCShareIn(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCShareOut(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLC(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =g= 0;

eqCnsETechInpLCShareIn(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCShareOut(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLC(cns, tech, comm)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =e= 0;

eqCnsLETechInpLCSShareIn(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCSShareOut(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCS(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =l= 0;

eqCnsGETechInpLCSShareIn(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCSShareOut(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCS(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =g= 0;

eqCnsETechInpLCSShareIn(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCSShareOut(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCS(cns, tech, comm, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =e= 0;

eqCnsLETechInpLCYShareIn(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCYShareOut(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCY(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =l= 0;

eqCnsGETechInpLCYShareIn(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCYShareOut(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCY(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =g= 0;

eqCnsETechInpLCYShareIn(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCYShareOut(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCY(cns, tech, comm, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =e= 0;

eqCnsLETechInpLCYSShareIn(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCYSShareOut(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCYS(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =l= 0;

eqCnsGETechInpLCYSShareIn(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCYSShareOut(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCYS(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =g= 0;

eqCnsETechInpLCYSShareIn(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCYSShareOut(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCYS(cns, tech, comm, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =e= 0;

eqCnsLETechInpLCRShareIn(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCRShareOut(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCR(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =l= 0;

eqCnsGETechInpLCRShareIn(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCRShareOut(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCR(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =g= 0;

eqCnsETechInpLCRShareIn(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCRShareOut(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCR(cns, tech, comm, region)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =e= 0;

eqCnsLETechInpLCRSShareIn(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCRSShareOut(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechInpLCRS(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =l= 0;

eqCnsGETechInpLCRSShareIn(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCRSShareOut(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechInpLCRS(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =g= 0;

eqCnsETechInpLCRSShareIn(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCRSShareOut(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechInpLCRS(cns, tech, comm, region, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechInp(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =e= 0;

eqCnsLETechInpLCRYShareIn(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCRYShareOut(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechInpLCRY(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =l= 0;

eqCnsGETechInpLCRYShareIn(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCRYShareOut(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechInpLCRY(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =g= 0;

eqCnsETechInpLCRYShareIn(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCRYShareOut(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechInpLCRY(cns, tech, comm, region, year)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechInp(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =e= 0;

eqCnsLETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =l= 0;

eqCnsLETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =l= 0;

eqCnsLETechInpLCRYS(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =l= 0;

eqCnsGETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =g= 0;

eqCnsGETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =g= 0;

eqCnsGETechInpLCRYS(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =g= 0;

eqCnsETechInpLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =e= 0;

eqCnsETechInpLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =e= 0;

eqCnsETechInpLCRYS(cns, tech, comm, region, year, slice)$(mCnsInpTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechInp(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =e= 0;

eqCnsLETechOutLShareIn(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLShareOut(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutL(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =l= 0;

eqCnsGETechOutLShareIn(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLShareOut(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutL(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =g= 0;

eqCnsETechOutLShareIn(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLShareOut(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutL(cns, tech)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTech(cns, tech))
        )
       =e= 0;

eqCnsLETechOutLSShareIn(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLSShareOut(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLS(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =l= 0;

eqCnsGETechOutLSShareIn(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLSShareOut(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLS(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =g= 0;

eqCnsETechOutLSShareIn(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLSShareOut(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLS(cns, tech, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechS(cns, tech, slice))
        )
       =e= 0;

eqCnsLETechOutLYShareIn(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLYShareOut(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLY(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =l= 0;

eqCnsGETechOutLYShareIn(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLYShareOut(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLY(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =g= 0;

eqCnsETechOutLYShareIn(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLYShareOut(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLY(cns, tech, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechY(cns, tech, year))
       =e= 0;

eqCnsLETechOutLYSShareIn(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLYSShareOut(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLYS(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =l= 0;

eqCnsGETechOutLYSShareIn(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLYSShareOut(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLYS(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =g= 0;

eqCnsETechOutLYSShareIn(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLYSShareOut(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLYS(cns, tech, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechYS(cns, tech, year, slice))
       =e= 0;

eqCnsLETechOutLRShareIn(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLRShareOut(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLR(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =l= 0;

eqCnsGETechOutLRShareIn(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLRShareOut(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLR(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =g= 0;

eqCnsETechOutLRShareIn(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLRShareOut(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLR(cns, tech, region)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechR(cns, tech, region))
        )
       =e= 0;

eqCnsLETechOutLRSShareIn(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLRSShareOut(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLRS(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =l= 0;

eqCnsGETechOutLRSShareIn(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLRSShareOut(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLRS(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =g= 0;

eqCnsETechOutLRSShareIn(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLRSShareOut(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLRS(cns, tech, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechRS(cns, tech, region, slice))
        )
       =e= 0;

eqCnsLETechOutLRYShareIn(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLRYShareOut(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLRY(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =l= 0;

eqCnsGETechOutLRYShareIn(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLRYShareOut(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLRY(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =g= 0;

eqCnsETechOutLRYShareIn(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLRYShareOut(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLRY(cns, tech, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRY(cns, tech, region, year))
       =e= 0;

eqCnsLETechOutLRYSShareIn(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLRYSShareOut(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLRYS(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =l= 0;

eqCnsGETechOutLRYSShareIn(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLRYSShareOut(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLRYS(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =g= 0;

eqCnsETechOutLRYSShareIn(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLRYSShareOut(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLRYS(cns, tech, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vTechOut(tech, comm, region, year, slice) - pRhsTechRYS(cns, tech, region, year, slice))
       =e= 0;

eqCnsLETechOutLCShareIn(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCShareOut(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLC(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =l= 0;

eqCnsGETechOutLCShareIn(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCShareOut(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLC(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =g= 0;

eqCnsETechOutLCShareIn(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCShareOut(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLC(cns, tech, comm)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechC(cns, tech, comm))
        )
       =e= 0;

eqCnsLETechOutLCSShareIn(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCSShareOut(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCS(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =l= 0;

eqCnsGETechOutLCSShareIn(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCSShareOut(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCS(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =g= 0;

eqCnsETechOutLCSShareIn(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCSShareOut(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCS(cns, tech, comm, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCS(cns, tech, comm, slice))
        )
       =e= 0;

eqCnsLETechOutLCYShareIn(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCYShareOut(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCY(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =l= 0;

eqCnsGETechOutLCYShareIn(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCYShareOut(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCY(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =g= 0;

eqCnsETechOutLCYShareIn(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCYShareOut(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCY(cns, tech, comm, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCY(cns, tech, comm, year))
       =e= 0;

eqCnsLETechOutLCYSShareIn(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCYSShareOut(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCYS(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =l= 0;

eqCnsGETechOutLCYSShareIn(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCYSShareOut(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCYS(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =g= 0;

eqCnsETechOutLCYSShareIn(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCYSShareOut(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCYS(cns, tech, comm, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCYS(cns, tech, comm, year, slice))
       =e= 0;

eqCnsLETechOutLCRShareIn(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCRShareOut(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCR(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =l= 0;

eqCnsGETechOutLCRShareIn(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCRShareOut(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCR(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =g= 0;

eqCnsETechOutLCRShareIn(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCRShareOut(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCR(cns, tech, comm, region)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCR(cns, tech, comm, region))
        )
       =e= 0;

eqCnsLETechOutLCRSShareIn(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCRSShareOut(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLETechOutLCRS(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =l= 0;

eqCnsGETechOutLCRSShareIn(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCRSShareOut(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGETechOutLCRS(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =g= 0;

eqCnsETechOutLCRSShareIn(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCRSShareOut(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsETechOutLCRS(cns, tech, comm, region, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechOut(tech, comm, region, year, slice) - pRhsTechCRS(cns, tech, comm, region, slice))
        )
       =e= 0;

eqCnsLETechOutLCRYShareIn(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCRYShareOut(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLETechOutLCRY(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =l= 0;

eqCnsGETechOutLCRYShareIn(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCRYShareOut(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGETechOutLCRY(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =g= 0;

eqCnsETechOutLCRYShareIn(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCRYShareOut(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsETechOutLCRY(cns, tech, comm, region, year)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vTechOut(tech, comm, region, year, slice) - pRhsTechCRY(cns, tech, comm, region, year))
       =e= 0;

eqCnsLETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =l= 0;

eqCnsLETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =l= 0;

eqCnsLETechOutLCRYS(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =l= 0;

eqCnsGETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =g= 0;

eqCnsGETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =g= 0;

eqCnsGETechOutLCRYS(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =g= 0;

eqCnsETechOutLCRYSShareIn(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareIn(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =e= 0;

eqCnsETechOutLCRYSShareOut(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeShareOut(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =e= 0;

eqCnsETechOutLCRYS(cns, tech, comm, region, year, slice)$(mCnsOutTech(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechOut(tech, comm, region, year, slice) - pRhsTechCRYS(cns, tech, comm, region, year, slice)
       =e= 0;

eqCnsLETechCapL(cns, tech)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =l= 0;

eqCnsGETechCapL(cns, tech)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =g= 0;

eqCnsETechCapL(cns, tech)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =e= 0;

eqCnsLETechCapLY(cns, tech, year)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =l= 0;

eqCnsGETechCapLY(cns, tech, year)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =g= 0;

eqCnsETechCapLY(cns, tech, year)$(mCnsCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechSpan(tech, region, year)),  vTechCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =e= 0;

eqCnsLETechCapLR(cns, tech, region)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =l= 0;

eqCnsGETechCapLR(cns, tech, region)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =g= 0;

eqCnsETechCapLR(cns, tech, region)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechSpan(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =e= 0;

eqCnsLETechCapLRY(cns, tech, region, year)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =l= 0;

eqCnsGETechCapLRY(cns, tech, region, year)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =g= 0;

eqCnsETechCapLRY(cns, tech, region, year)$(mCnsCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechSpan(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =e= 0;

eqCnsLETechNewCapL(cns, tech)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =l= 0;

eqCnsGETechNewCapL(cns, tech)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =g= 0;

eqCnsETechNewCapL(cns, tech)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTech(cns, tech))
        )
       =e= 0;

eqCnsLETechNewCapLY(cns, tech, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =l= 0;

eqCnsGETechNewCapLY(cns, tech, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =g= 0;

eqCnsETechNewCapLY(cns, tech, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region) and mTechNew(tech, region, year)),  vTechNewCap(tech, region, year) - pRhsTechY(cns, tech, year))
       =e= 0;

eqCnsLETechNewCapLR(cns, tech, region)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =l= 0;

eqCnsGETechNewCapLR(cns, tech, region)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =g= 0;

eqCnsETechNewCapLR(cns, tech, region)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mTechNew(tech, region, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vTechNewCap(tech, region, year) - pRhsTechR(cns, tech, region))
        )
       =e= 0;

eqCnsLETechNewCapLRY(cns, tech, region, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechNewCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =l= 0;

eqCnsGETechNewCapLRY(cns, tech, region, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsGe(cns) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechNewCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =g= 0;

eqCnsETechNewCapLRY(cns, tech, region, year)$(mCnsNewCapTech(cns) and mCnsLType(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsTech(cns, tech) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mTechNew(tech, region, year) and mCnsRhsTypeConst(cns))..
       vTechNewCap(tech, region, year) - pRhsTechRY(cns, tech, region, year)
       =e= 0;

eqCnsLESupOutShareIn(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutShareOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns))
        )
       =l= 0;

eqCnsGESupOutShareIn(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutShareOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns))
        )
       =g= 0;

eqCnsESupOutShareIn(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutShareOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOut(cns)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhs(cns))
        )
       =e= 0;

eqCnsLESupOutSShareIn(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutSShareOut(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutS(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =l= 0;

eqCnsGESupOutSShareIn(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutSShareOut(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutS(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =g= 0;

eqCnsESupOutSShareIn(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutSShareOut(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutS(cns, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsS(cns, slice))
        )
       =e= 0;

eqCnsLESupOutYShareIn(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutYShareOut(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutY(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year))
       =l= 0;

eqCnsGESupOutYShareIn(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutYShareOut(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutY(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year))
       =g= 0;

eqCnsESupOutYShareIn(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutYShareOut(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutY(cns, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsY(cns, year))
       =e= 0;

eqCnsLESupOutYSShareIn(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutYSShareOut(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutYS(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =l= 0;

eqCnsGESupOutYSShareIn(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutYSShareOut(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutYS(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =g= 0;

eqCnsESupOutYSShareIn(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutYSShareOut(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutYS(cns, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, region)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsYS(cns, year, slice))
       =e= 0;

eqCnsLESupOutRShareIn(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutRShareOut(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutR(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGESupOutRShareIn(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutRShareOut(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutR(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsESupOutRShareIn(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutRShareOut(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutR(cns, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLESupOutRSShareIn(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutRSShareOut(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutRS(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =l= 0;

eqCnsGESupOutRSShareIn(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutRSShareOut(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutRS(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =g= 0;

eqCnsESupOutRSShareIn(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutRSShareOut(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutRS(cns, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =e= 0;

eqCnsLESupOutRYShareIn(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutRYShareOut(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutRY(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGESupOutRYShareIn(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutRYShareOut(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutRY(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsESupOutRYShareIn(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutRYShareOut(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutRY(cns, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, comm, slice)$(mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLESupOutRYSShareIn(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutRYSShareOut(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutRYS(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =l= 0;

eqCnsGESupOutRYSShareIn(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutRYSShareOut(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutRYS(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =g= 0;

eqCnsESupOutRYSShareIn(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutRYSShareOut(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutRYS(cns, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, comm)$(mCnsSup(cns, sup) and mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =e= 0;

eqCnsLESupOutCShareIn(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCShareOut(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutC(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =l= 0;

eqCnsGESupOutCShareIn(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCShareOut(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutC(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =g= 0;

eqCnsESupOutCShareIn(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCShareOut(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutC(cns, comm)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsC(cns, comm))
        )
       =e= 0;

eqCnsLESupOutCSShareIn(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCSShareOut(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCS(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =l= 0;

eqCnsGESupOutCSShareIn(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCSShareOut(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCS(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =g= 0;

eqCnsESupOutCSShareIn(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCSShareOut(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCS(cns, comm, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =e= 0;

eqCnsLESupOutCYShareIn(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCYShareOut(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCY(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =l= 0;

eqCnsGESupOutCYShareIn(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCYShareOut(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCY(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =g= 0;

eqCnsESupOutCYShareIn(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCYShareOut(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCY(cns, comm, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, region, slice)$(mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCY(cns, comm, year))
       =e= 0;

eqCnsLESupOutCYSShareIn(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCYSShareOut(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCYS(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =l= 0;

eqCnsGESupOutCYSShareIn(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCYSShareOut(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCYS(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =g= 0;

eqCnsESupOutCYSShareIn(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCYSShareOut(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCYS(cns, comm, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, region)$(mCnsSup(cns, sup) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =e= 0;

eqCnsLESupOutCRShareIn(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCRShareOut(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCR(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =l= 0;

eqCnsGESupOutCRShareIn(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCRShareOut(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCR(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =g= 0;

eqCnsESupOutCRShareIn(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCRShareOut(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCR(cns, comm, region)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((sup, year, slice, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =e= 0;

eqCnsLESupOutCRSShareIn(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCRSShareOut(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutCRS(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =l= 0;

eqCnsGESupOutCRSShareIn(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCRSShareOut(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutCRS(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =g= 0;

eqCnsESupOutCRSShareIn(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCRSShareOut(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutCRS(cns, comm, region, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup, year, yeare, yearp)$(mCnsSup(cns, sup) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =e= 0;

eqCnsLESupOutCRYShareIn(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCRYShareOut(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCRY(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =l= 0;

eqCnsGESupOutCRYShareIn(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCRYShareOut(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCRY(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =g= 0;

eqCnsESupOutCRYShareIn(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCRYShareOut(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCRY(cns, comm, region, year)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((sup, slice)$(mCnsSup(cns, sup) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =e= 0;

eqCnsLESupOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutCRYS(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =l= 0;

eqCnsGESupOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutCRYS(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =g= 0;

eqCnsESupOutCRYSShareIn(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCRYSShareOut(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutCRYS(cns, comm, region, year, slice)$(mCnsOutSup(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((sup)$(mCnsSup(cns, sup)),  vSupOut(sup, comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice))
       =e= 0;

eqCnsLESupOutLShareIn(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLShareOut(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutL(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup))
        )
       =l= 0;

eqCnsGESupOutLShareIn(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLShareOut(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutL(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup))
        )
       =g= 0;

eqCnsESupOutLShareIn(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLShareOut(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutL(cns, sup)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSup(cns, sup))
        )
       =e= 0;

eqCnsLESupOutLSShareIn(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLSShareOut(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLS(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice))
        )
       =l= 0;

eqCnsGESupOutLSShareIn(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLSShareOut(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLS(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice))
        )
       =g= 0;

eqCnsESupOutLSShareIn(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLSShareOut(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLS(cns, sup, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupS(cns, sup, slice))
        )
       =e= 0;

eqCnsLESupOutLYShareIn(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLYShareOut(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLY(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year))
       =l= 0;

eqCnsGESupOutLYShareIn(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLYShareOut(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLY(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year))
       =g= 0;

eqCnsESupOutLYShareIn(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLYShareOut(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLY(cns, sup, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupY(cns, sup, year))
       =e= 0;

eqCnsLESupOutLYSShareIn(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLYSShareOut(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLYS(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice))
       =l= 0;

eqCnsGESupOutLYSShareIn(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLYSShareOut(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLYS(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice))
       =g= 0;

eqCnsESupOutLYSShareIn(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLYSShareOut(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLYS(cns, sup, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupYS(cns, sup, year, slice))
       =e= 0;

eqCnsLESupOutLRShareIn(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLRShareOut(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLR(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region))
        )
       =l= 0;

eqCnsGESupOutLRShareIn(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLRShareOut(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLR(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region))
        )
       =g= 0;

eqCnsESupOutLRShareIn(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLRShareOut(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLR(cns, sup, region)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupR(cns, sup, region))
        )
       =e= 0;

eqCnsLESupOutLRSShareIn(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLRSShareOut(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLRS(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice))
        )
       =l= 0;

eqCnsGESupOutLRSShareIn(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLRSShareOut(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLRS(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice))
        )
       =g= 0;

eqCnsESupOutLRSShareIn(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLRSShareOut(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLRS(cns, sup, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupRS(cns, sup, region, slice))
        )
       =e= 0;

eqCnsLESupOutLRYShareIn(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLRYShareOut(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLRY(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year))
       =l= 0;

eqCnsGESupOutLRYShareIn(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLRYShareOut(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLRY(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year))
       =g= 0;

eqCnsESupOutLRYShareIn(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLRYShareOut(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLRY(cns, sup, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRY(cns, sup, region, year))
       =e= 0;

eqCnsLESupOutLRYSShareIn(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLRYSShareOut(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLRYS(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice))
       =l= 0;

eqCnsGESupOutLRYSShareIn(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLRYSShareOut(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLRYS(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice))
       =g= 0;

eqCnsESupOutLRYSShareIn(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLRYSShareOut(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLRYS(cns, sup, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vSupOut(sup, comm, region, year, slice) - pRhsSupRYS(cns, sup, region, year, slice))
       =e= 0;

eqCnsLESupOutLCShareIn(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCShareOut(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLC(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm))
        )
       =l= 0;

eqCnsGESupOutLCShareIn(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCShareOut(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLC(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm))
        )
       =g= 0;

eqCnsESupOutLCShareIn(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCShareOut(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLC(cns, sup, comm)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupC(cns, sup, comm))
        )
       =e= 0;

eqCnsLESupOutLCSShareIn(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCSShareOut(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCS(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice))
        )
       =l= 0;

eqCnsGESupOutLCSShareIn(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCSShareOut(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCS(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice))
        )
       =g= 0;

eqCnsESupOutLCSShareIn(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCSShareOut(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCS(cns, sup, comm, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCS(cns, sup, comm, slice))
        )
       =e= 0;

eqCnsLESupOutLCYShareIn(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCYShareOut(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCY(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year))
       =l= 0;

eqCnsGESupOutLCYShareIn(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCYShareOut(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCY(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year))
       =g= 0;

eqCnsESupOutLCYShareIn(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCYShareOut(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCY(cns, sup, comm, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCY(cns, sup, comm, year))
       =e= 0;

eqCnsLESupOutLCYSShareIn(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCYSShareOut(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCYS(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice))
       =l= 0;

eqCnsGESupOutLCYSShareIn(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCYSShareOut(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCYS(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice))
       =g= 0;

eqCnsESupOutLCYSShareIn(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCYSShareOut(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCYS(cns, sup, comm, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCYS(cns, sup, comm, year, slice))
       =e= 0;

eqCnsLESupOutLCRShareIn(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCRShareOut(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCR(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region))
        )
       =l= 0;

eqCnsGESupOutLCRShareIn(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCRShareOut(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCR(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region))
        )
       =g= 0;

eqCnsESupOutLCRShareIn(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareIn(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCRShareOut(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeShareOut(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCR(cns, sup, comm, region)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCR(cns, sup, comm, region))
        )
       =e= 0;

eqCnsLESupOutLCRSShareIn(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCRSShareOut(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =l= 0;

eqCnsLESupOutLCRS(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice))
        )
       =l= 0;

eqCnsGESupOutLCRSShareIn(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCRSShareOut(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =g= 0;

eqCnsGESupOutLCRS(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice))
        )
       =g= 0;

eqCnsESupOutLCRSShareIn(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vInpTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCRSShareOut(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice) * vOutTot(comm, region, year, slice))
        )
       =e= 0;

eqCnsESupOutLCRS(cns, sup, comm, region, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vSupOut(sup, comm, region, year, slice) - pRhsSupCRS(cns, sup, comm, region, slice))
        )
       =e= 0;

eqCnsLESupOutLCRYShareIn(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vInpTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCRYShareOut(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vOutTot(comm, region, year, slice))
       =l= 0;

eqCnsLESupOutLCRY(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year))
       =l= 0;

eqCnsGESupOutLCRYShareIn(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vInpTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCRYShareOut(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vOutTot(comm, region, year, slice))
       =g= 0;

eqCnsGESupOutLCRY(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year))
       =g= 0;

eqCnsESupOutLCRYShareIn(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareIn(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vInpTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCRYShareOut(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeShareOut(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year) * vOutTot(comm, region, year, slice))
       =e= 0;

eqCnsESupOutLCRY(cns, sup, comm, region, year)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vSupOut(sup, comm, region, year, slice) - pRhsSupCRY(cns, sup, comm, region, year))
       =e= 0;

eqCnsLESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =l= 0;

eqCnsLESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =l= 0;

eqCnsLESupOutLCRYS(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice)
       =l= 0;

eqCnsGESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =g= 0;

eqCnsGESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =g= 0;

eqCnsGESupOutLCRYS(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice)
       =g= 0;

eqCnsESupOutLCRYSShareIn(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareIn(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vInpTot(comm, region, year, slice)
       =e= 0;

eqCnsESupOutLCRYSShareOut(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeShareOut(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice) * vOutTot(comm, region, year, slice)
       =e= 0;

eqCnsESupOutLCRYS(cns, sup, comm, region, year, slice)$(mCnsOutSup(cns) and mCnsLType(cns) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSup(cns, sup) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vSupOut(sup, comm, region, year, slice) - pRhsSupCRYS(cns, sup, comm, region, year, slice)
       =e= 0;

eqCnsLETotInp(cns)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhs(cns))
        )
       =l= 0;

eqCnsGETotInp(cns)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhs(cns))
        )
       =g= 0;

eqCnsETotInp(cns)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhs(cns))
        )
       =e= 0;

eqCnsLETotInpS(cns, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =l= 0;

eqCnsGETotInpS(cns, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =g= 0;

eqCnsETotInpS(cns, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =e= 0;

eqCnsLETotInpY(cns, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsY(cns, year))
       =l= 0;

eqCnsGETotInpY(cns, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsY(cns, year))
       =g= 0;

eqCnsETotInpY(cns, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsY(cns, year))
       =e= 0;

eqCnsLETotInpYS(cns, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =l= 0;

eqCnsGETotInpYS(cns, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =g= 0;

eqCnsETotInpYS(cns, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =e= 0;

eqCnsLETotInpR(cns, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETotInpR(cns, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETotInpR(cns, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETotInpRS(cns, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =l= 0;

eqCnsGETotInpRS(cns, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =g= 0;

eqCnsETotInpRS(cns, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =e= 0;

eqCnsLETotInpRY(cns, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETotInpRY(cns, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETotInpRY(cns, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETotInpRYS(cns, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vInpTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =l= 0;

eqCnsGETotInpRYS(cns, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vInpTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =g= 0;

eqCnsETotInpRYS(cns, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vInpTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =e= 0;

eqCnsLETotInpC(cns, comm)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =l= 0;

eqCnsGETotInpC(cns, comm)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =g= 0;

eqCnsETotInpC(cns, comm)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =e= 0;

eqCnsLETotInpCS(cns, comm, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =l= 0;

eqCnsGETotInpCS(cns, comm, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =g= 0;

eqCnsETotInpCS(cns, comm, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =e= 0;

eqCnsLETotInpCY(cns, comm, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =l= 0;

eqCnsGETotInpCY(cns, comm, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =g= 0;

eqCnsETotInpCY(cns, comm, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =e= 0;

eqCnsLETotInpCYS(cns, comm, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =l= 0;

eqCnsGETotInpCYS(cns, comm, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =g= 0;

eqCnsETotInpCYS(cns, comm, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vInpTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =e= 0;

eqCnsLETotInpCR(cns, comm, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =l= 0;

eqCnsGETotInpCR(cns, comm, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =g= 0;

eqCnsETotInpCR(cns, comm, region)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =e= 0;

eqCnsLETotInpCRS(cns, comm, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =l= 0;

eqCnsGETotInpCRS(cns, comm, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =g= 0;

eqCnsETotInpCRS(cns, comm, region, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vInpTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =e= 0;

eqCnsLETotInpCRY(cns, comm, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =l= 0;

eqCnsGETotInpCRY(cns, comm, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =g= 0;

eqCnsETotInpCRY(cns, comm, region, year)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vInpTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =e= 0;

eqCnsLETotInpCRYS(cns, comm, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vInpTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =l= 0;

eqCnsGETotInpCRYS(cns, comm, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vInpTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =g= 0;

eqCnsETotInpCRYS(cns, comm, region, year, slice)$(mCnsInp(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vInpTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =e= 0;

eqCnsLETotOut(cns)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhs(cns))
        )
       =l= 0;

eqCnsGETotOut(cns)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhs(cns))
        )
       =g= 0;

eqCnsETotOut(cns)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhs(cns))
        )
       =e= 0;

eqCnsLETotOutS(cns, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =l= 0;

eqCnsGETotOutS(cns, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =g= 0;

eqCnsETotOutS(cns, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsS(cns, slice))
        )
       =e= 0;

eqCnsLETotOutY(cns, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsY(cns, year))
       =l= 0;

eqCnsGETotOutY(cns, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsY(cns, year))
       =g= 0;

eqCnsETotOutY(cns, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, region, slice)$(mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsY(cns, year))
       =e= 0;

eqCnsLETotOutYS(cns, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =l= 0;

eqCnsGETotOutYS(cns, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =g= 0;

eqCnsETotOutYS(cns, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, region)$(mCnsComm(cns, comm) and mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsYS(cns, year, slice))
       =e= 0;

eqCnsLETotOutR(cns, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =l= 0;

eqCnsGETotOutR(cns, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =g= 0;

eqCnsETotOutR(cns, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((comm, year, slice, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsR(cns, region))
        )
       =e= 0;

eqCnsLETotOutRS(cns, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =l= 0;

eqCnsGETotOutRS(cns, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =g= 0;

eqCnsETotOutRS(cns, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm, year, yeare, yearp)$(mCnsComm(cns, comm) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsRS(cns, region, slice))
        )
       =e= 0;

eqCnsLETotOutRY(cns, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =l= 0;

eqCnsGETotOutRY(cns, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =g= 0;

eqCnsETotOutRY(cns, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((comm, slice)$(mCnsComm(cns, comm) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsRY(cns, region, year))
       =e= 0;

eqCnsLETotOutRYS(cns, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vOutTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =l= 0;

eqCnsGETotOutRYS(cns, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vOutTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =g= 0;

eqCnsETotOutRYS(cns, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and mCnsLhsComm(cns) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((comm)$(mCnsComm(cns, comm)),  vOutTot(comm, region, year, slice) - pRhsRYS(cns, region, year, slice))
       =e= 0;

eqCnsLETotOutC(cns, comm)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =l= 0;

eqCnsGETotOutC(cns, comm)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =g= 0;

eqCnsETotOutC(cns, comm)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRhsTypeConst(cns))..
       sum((region, year, slice, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsC(cns, comm))
        )
       =e= 0;

eqCnsLETotOutCS(cns, comm, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =l= 0;

eqCnsGETotOutCS(cns, comm, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =g= 0;

eqCnsETotOutCS(cns, comm, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region, year, yeare, yearp)$(mCnsRegion(cns, region) and mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCS(cns, comm, slice))
        )
       =e= 0;

eqCnsLETotOutCY(cns, comm, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =l= 0;

eqCnsGETotOutCY(cns, comm, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =g= 0;

eqCnsETotOutCY(cns, comm, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((region, slice)$(mCnsRegion(cns, region) and mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCY(cns, comm, year))
       =e= 0;

eqCnsLETotOutCYS(cns, comm, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =l= 0;

eqCnsGETotOutCYS(cns, comm, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =g= 0;

eqCnsETotOutCYS(cns, comm, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and mCnsLhsRegion(cns) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((region)$(mCnsRegion(cns, region)),  vOutTot(comm, region, year, slice) - pRhsCYS(cns, comm, year, slice))
       =e= 0;

eqCnsLETotOutCR(cns, comm, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =l= 0;

eqCnsGETotOutCR(cns, comm, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =g= 0;

eqCnsETotOutCR(cns, comm, region)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsRhsTypeConst(cns))..
       sum((year, slice, yeare, yearp)$(mCnsYear(cns, year) and mCnsSlice(cns, slice) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCR(cns, comm, region))
        )
       =e= 0;

eqCnsLETotOutCRS(cns, comm, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =l= 0;

eqCnsGETotOutCRS(cns, comm, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =g= 0;

eqCnsETotOutCRS(cns, comm, region, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and mCnsLhsYear(cns) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       sum((year, yeare, yearp)$(mCnsYear(cns, year) and mMidMilestone(year) and   mStartMilestone(year, yeare) and mEndMilestone(year, yearp)), (ORD(yearp) - ORD(yeare) + 1) * (vOutTot(comm, region, year, slice) - pRhsCRS(cns, comm, region, slice))
        )
       =e= 0;

eqCnsLETotOutCRY(cns, comm, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =l= 0;

eqCnsGETotOutCRY(cns, comm, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =g= 0;

eqCnsETotOutCRY(cns, comm, region, year)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and mCnsLhsSlice(cns) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsRhsTypeConst(cns))..
       sum((slice)$(mCnsSlice(cns, slice)),  vOutTot(comm, region, year, slice) - pRhsCRY(cns, comm, region, year))
       =e= 0;

eqCnsLETotOutCRYS(cns, comm, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsLe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vOutTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =l= 0;

eqCnsGETotOutCRYS(cns, comm, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and mCnsGe(cns) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vOutTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =g= 0;

eqCnsETotOutCRYS(cns, comm, region, year, slice)$(mCnsOut(cns) and not(mCnsLType(cns)) and not(mCnsLhsComm(cns)) and not(mCnsLhsRegion(cns)) and not(mCnsLhsYear(cns)) and not(mCnsLhsSlice(cns)) and not(mCnsLe(cns)) and not(mCnsGe(cns)) and mCnsComm(cns, comm) and mCnsRegion(cns, region) and mCnsYear(cns, year) and mCnsSlice(cns, slice) and mCnsRhsTypeConst(cns))..
       vOutTot(comm, region, year, slice) - pRhsCRYS(cns, comm, region, year, slice)
       =e= 0;



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
eqLECActivity(region, year, slice)
;

eqLECActivity(region, year, slice)$mLECRegion(region).. sum(tech$mTechSpan(tech, region, year), vTechAct(tech, region, year, slice)) =g= pLECLoACT(region);




*$INCLUDE data.inc
* e0fc7d1e-fd81-4745-a0eb-2a142f837d1c

model st_model /
********************************************************************************
* Equation
********************************************************************************
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
eqTechAfaLo
* Availability factor UP
eqTechAfaUp
********************************************************************************
* Connect activity with output equations
********************************************************************************
* Connect activity with output
eqTechActSng
eqTechActGrp
********************************************************************************
* Availability commodity factor equations
********************************************************************************
* Availability commodity factor LO equations
eqTechAfacLo
* Availability commodity factor UP equations
eqTechAfacUp
********************************************************************************
* Capacity and cost equations
********************************************************************************
* Capacity eqaution
eqTechCap
eqTechNewCap
*eqTechRetirementCap
*eqTechRetrofitCap
*eqTechUpgradeCap
* Investition eqaution
eqTechInv
* FIX O & M eqaution
* Salvage cost
*eqTechSalv1
eqTechSalv2
eqTechSalv3
* Commodity Varom O & M and Varom O & M aggregate by year eqaution
* Cost aggregate by year eqaution
eqTechCost1
eqTechCost2
* Disable new capacity
*eqTechNewCapDisable
**************************************
* Supply equation
**************************************
eqSupAvaUp
eqSupAvaLo
eqSupReserve
eqSupReserveCheck
eqSupCost
**************************************
* Demand equation
**************************************
eqDemInp
**************************************
* Emission & Aggregate equation
**************************************
eqAggOut
eqEmsTot
eqTechEms
********************************************************************************
* Store equations for reserve
********************************************************************************
eqStorageStore
********************************************************************************
* Capacity and cost equations for reserve
********************************************************************************
* Capacity eqaution
eqStorageCap
* Investition eqaution
eqStorageInv
* FIX O & M eqaution
eqStorageFix
* Salvage cost
eqStorageSalv2
eqStorageSalv3
* Commodity Varom O & M aggregate by year eqaution
eqStorageVar
* Cost aggregate by year eqaution
eqStorageCost1
eqStorageCost2
* Constrain capacity
eqStorageLo
eqStorageUp
**************************************
* Trade and Row equation
**************************************
eqImport
eqExport
eqTradeFlowUp
eqTradeFlowLo
eqCostTrade
eqRowExportUp
eqRowExportLo
eqRowExportRes
eqRowExportResUp
eqRowImportUp
eqRowImportLo
eqRowImportRes
eqRowImportResUp
**************************************
* Ballance equation & dummy
**************************************
eqBalUp
eqBalLo
eqBalFx
eqBal
eqOutTot
eqInpTot
eqSupOutTot
eqTechInpTot
eqTechOutTot
eqStorageInpTot
eqStorageOutTot
**************************************
* Cost equation
**************************************
eqDumOut
eqDumCost
eqCost1
eqCost2
eqObjective
* Tax
eqTaxCost
* Subs
eqSubsCost
**************************************
* Standard constrain
**************************************
eqCnsLETechInpShareIn
eqCnsLETechInpShareOut
eqCnsLETechInp
eqCnsGETechInpShareIn
eqCnsGETechInpShareOut
eqCnsGETechInp
eqCnsETechInpShareIn
eqCnsETechInpShareOut
eqCnsETechInp
eqCnsLETechInpSShareIn
eqCnsLETechInpSShareOut
eqCnsLETechInpS
eqCnsGETechInpSShareIn
eqCnsGETechInpSShareOut
eqCnsGETechInpS
eqCnsETechInpSShareIn
eqCnsETechInpSShareOut
eqCnsETechInpS
eqCnsLETechInpYShareIn
eqCnsLETechInpYShareOut
eqCnsLETechInpY
eqCnsGETechInpYShareIn
eqCnsGETechInpYShareOut
eqCnsGETechInpY
eqCnsETechInpYShareIn
eqCnsETechInpYShareOut
eqCnsETechInpY
eqCnsLETechInpYSShareIn
eqCnsLETechInpYSShareOut
eqCnsLETechInpYS
eqCnsGETechInpYSShareIn
eqCnsGETechInpYSShareOut
eqCnsGETechInpYS
eqCnsETechInpYSShareIn
eqCnsETechInpYSShareOut
eqCnsETechInpYS
eqCnsLETechInpRShareIn
eqCnsLETechInpRShareOut
eqCnsLETechInpR
eqCnsGETechInpRShareIn
eqCnsGETechInpRShareOut
eqCnsGETechInpR
eqCnsETechInpRShareIn
eqCnsETechInpRShareOut
eqCnsETechInpR
eqCnsLETechInpRSShareIn
eqCnsLETechInpRSShareOut
eqCnsLETechInpRS
eqCnsGETechInpRSShareIn
eqCnsGETechInpRSShareOut
eqCnsGETechInpRS
eqCnsETechInpRSShareIn
eqCnsETechInpRSShareOut
eqCnsETechInpRS
eqCnsLETechInpRYShareIn
eqCnsLETechInpRYShareOut
eqCnsLETechInpRY
eqCnsGETechInpRYShareIn
eqCnsGETechInpRYShareOut
eqCnsGETechInpRY
eqCnsETechInpRYShareIn
eqCnsETechInpRYShareOut
eqCnsETechInpRY
eqCnsLETechInpRYSShareIn
eqCnsLETechInpRYSShareOut
eqCnsLETechInpRYS
eqCnsGETechInpRYSShareIn
eqCnsGETechInpRYSShareOut
eqCnsGETechInpRYS
eqCnsETechInpRYSShareIn
eqCnsETechInpRYSShareOut
eqCnsETechInpRYS
eqCnsLETechInpCShareIn
eqCnsLETechInpCShareOut
eqCnsLETechInpC
eqCnsGETechInpCShareIn
eqCnsGETechInpCShareOut
eqCnsGETechInpC
eqCnsETechInpCShareIn
eqCnsETechInpCShareOut
eqCnsETechInpC
eqCnsLETechInpCSShareIn
eqCnsLETechInpCSShareOut
eqCnsLETechInpCS
eqCnsGETechInpCSShareIn
eqCnsGETechInpCSShareOut
eqCnsGETechInpCS
eqCnsETechInpCSShareIn
eqCnsETechInpCSShareOut
eqCnsETechInpCS
eqCnsLETechInpCYShareIn
eqCnsLETechInpCYShareOut
eqCnsLETechInpCY
eqCnsGETechInpCYShareIn
eqCnsGETechInpCYShareOut
eqCnsGETechInpCY
eqCnsETechInpCYShareIn
eqCnsETechInpCYShareOut
eqCnsETechInpCY
eqCnsLETechInpCYSShareIn
eqCnsLETechInpCYSShareOut
eqCnsLETechInpCYS
eqCnsGETechInpCYSShareIn
eqCnsGETechInpCYSShareOut
eqCnsGETechInpCYS
eqCnsETechInpCYSShareIn
eqCnsETechInpCYSShareOut
eqCnsETechInpCYS
eqCnsLETechInpCRShareIn
eqCnsLETechInpCRShareOut
eqCnsLETechInpCR
eqCnsGETechInpCRShareIn
eqCnsGETechInpCRShareOut
eqCnsGETechInpCR
eqCnsETechInpCRShareIn
eqCnsETechInpCRShareOut
eqCnsETechInpCR
eqCnsLETechInpCRSShareIn
eqCnsLETechInpCRSShareOut
eqCnsLETechInpCRS
eqCnsGETechInpCRSShareIn
eqCnsGETechInpCRSShareOut
eqCnsGETechInpCRS
eqCnsETechInpCRSShareIn
eqCnsETechInpCRSShareOut
eqCnsETechInpCRS
eqCnsLETechInpCRYShareIn
eqCnsLETechInpCRYShareOut
eqCnsLETechInpCRY
eqCnsGETechInpCRYShareIn
eqCnsGETechInpCRYShareOut
eqCnsGETechInpCRY
eqCnsETechInpCRYShareIn
eqCnsETechInpCRYShareOut
eqCnsETechInpCRY
eqCnsLETechInpCRYSShareIn
eqCnsLETechInpCRYSShareOut
eqCnsLETechInpCRYS
eqCnsGETechInpCRYSShareIn
eqCnsGETechInpCRYSShareOut
eqCnsGETechInpCRYS
eqCnsETechInpCRYSShareIn
eqCnsETechInpCRYSShareOut
eqCnsETechInpCRYS
eqCnsLETechOutShareIn
eqCnsLETechOutShareOut
eqCnsLETechOut
eqCnsGETechOutShareIn
eqCnsGETechOutShareOut
eqCnsGETechOut
eqCnsETechOutShareIn
eqCnsETechOutShareOut
eqCnsETechOut
eqCnsLETechOutSShareIn
eqCnsLETechOutSShareOut
eqCnsLETechOutS
eqCnsGETechOutSShareIn
eqCnsGETechOutSShareOut
eqCnsGETechOutS
eqCnsETechOutSShareIn
eqCnsETechOutSShareOut
eqCnsETechOutS
eqCnsLETechOutYShareIn
eqCnsLETechOutYShareOut
eqCnsLETechOutY
eqCnsGETechOutYShareIn
eqCnsGETechOutYShareOut
eqCnsGETechOutY
eqCnsETechOutYShareIn
eqCnsETechOutYShareOut
eqCnsETechOutY
eqCnsLETechOutYSShareIn
eqCnsLETechOutYSShareOut
eqCnsLETechOutYS
eqCnsGETechOutYSShareIn
eqCnsGETechOutYSShareOut
eqCnsGETechOutYS
eqCnsETechOutYSShareIn
eqCnsETechOutYSShareOut
eqCnsETechOutYS
eqCnsLETechOutRShareIn
eqCnsLETechOutRShareOut
eqCnsLETechOutR
eqCnsGETechOutRShareIn
eqCnsGETechOutRShareOut
eqCnsGETechOutR
eqCnsETechOutRShareIn
eqCnsETechOutRShareOut
eqCnsETechOutR
eqCnsLETechOutRSShareIn
eqCnsLETechOutRSShareOut
eqCnsLETechOutRS
eqCnsGETechOutRSShareIn
eqCnsGETechOutRSShareOut
eqCnsGETechOutRS
eqCnsETechOutRSShareIn
eqCnsETechOutRSShareOut
eqCnsETechOutRS
eqCnsLETechOutRYShareIn
eqCnsLETechOutRYShareOut
eqCnsLETechOutRY
eqCnsGETechOutRYShareIn
eqCnsGETechOutRYShareOut
eqCnsGETechOutRY
eqCnsETechOutRYShareIn
eqCnsETechOutRYShareOut
eqCnsETechOutRY
eqCnsLETechOutRYSShareIn
eqCnsLETechOutRYSShareOut
eqCnsLETechOutRYS
eqCnsGETechOutRYSShareIn
eqCnsGETechOutRYSShareOut
eqCnsGETechOutRYS
eqCnsETechOutRYSShareIn
eqCnsETechOutRYSShareOut
eqCnsETechOutRYS
eqCnsLETechOutCShareIn
eqCnsLETechOutCShareOut
eqCnsLETechOutC
eqCnsGETechOutCShareIn
eqCnsGETechOutCShareOut
eqCnsGETechOutC
eqCnsETechOutCShareIn
eqCnsETechOutCShareOut
eqCnsETechOutC
eqCnsLETechOutCSShareIn
eqCnsLETechOutCSShareOut
eqCnsLETechOutCS
eqCnsGETechOutCSShareIn
eqCnsGETechOutCSShareOut
eqCnsGETechOutCS
eqCnsETechOutCSShareIn
eqCnsETechOutCSShareOut
eqCnsETechOutCS
eqCnsLETechOutCYShareIn
eqCnsLETechOutCYShareOut
eqCnsLETechOutCY
eqCnsGETechOutCYShareIn
eqCnsGETechOutCYShareOut
eqCnsGETechOutCY
eqCnsETechOutCYShareIn
eqCnsETechOutCYShareOut
eqCnsETechOutCY
eqCnsLETechOutCYSShareIn
eqCnsLETechOutCYSShareOut
eqCnsLETechOutCYS
eqCnsGETechOutCYSShareIn
eqCnsGETechOutCYSShareOut
eqCnsGETechOutCYS
eqCnsETechOutCYSShareIn
eqCnsETechOutCYSShareOut
eqCnsETechOutCYS
eqCnsLETechOutCRShareIn
eqCnsLETechOutCRShareOut
eqCnsLETechOutCR
eqCnsGETechOutCRShareIn
eqCnsGETechOutCRShareOut
eqCnsGETechOutCR
eqCnsETechOutCRShareIn
eqCnsETechOutCRShareOut
eqCnsETechOutCR
eqCnsLETechOutCRSShareIn
eqCnsLETechOutCRSShareOut
eqCnsLETechOutCRS
eqCnsGETechOutCRSShareIn
eqCnsGETechOutCRSShareOut
eqCnsGETechOutCRS
eqCnsETechOutCRSShareIn
eqCnsETechOutCRSShareOut
eqCnsETechOutCRS
eqCnsLETechOutCRYShareIn
eqCnsLETechOutCRYShareOut
eqCnsLETechOutCRY
eqCnsGETechOutCRYShareIn
eqCnsGETechOutCRYShareOut
eqCnsGETechOutCRY
eqCnsETechOutCRYShareIn
eqCnsETechOutCRYShareOut
eqCnsETechOutCRY
eqCnsLETechOutCRYSShareIn
eqCnsLETechOutCRYSShareOut
eqCnsLETechOutCRYS
eqCnsGETechOutCRYSShareIn
eqCnsGETechOutCRYSShareOut
eqCnsGETechOutCRYS
eqCnsETechOutCRYSShareIn
eqCnsETechOutCRYSShareOut
eqCnsETechOutCRYS
eqCnsLETechCap
eqCnsGETechCap
eqCnsETechCap
eqCnsLETechCapY
eqCnsGETechCapY
eqCnsETechCapY
eqCnsLETechCapR
eqCnsGETechCapR
eqCnsETechCapR
eqCnsLETechCapRY
eqCnsGETechCapRY
eqCnsETechCapRY
eqCnsLETechNewCap
eqCnsGETechNewCap
eqCnsETechNewCap
eqCnsLETechNewCapY
eqCnsGETechNewCapY
eqCnsETechNewCapY
eqCnsLETechNewCapR
eqCnsGETechNewCapR
eqCnsETechNewCapR
eqCnsLETechNewCapRY
eqCnsGETechNewCapRY
eqCnsETechNewCapRY
eqCnsLETechInpLShareIn
eqCnsLETechInpLShareOut
eqCnsLETechInpL
eqCnsGETechInpLShareIn
eqCnsGETechInpLShareOut
eqCnsGETechInpL
eqCnsETechInpLShareIn
eqCnsETechInpLShareOut
eqCnsETechInpL
eqCnsLETechInpLSShareIn
eqCnsLETechInpLSShareOut
eqCnsLETechInpLS
eqCnsGETechInpLSShareIn
eqCnsGETechInpLSShareOut
eqCnsGETechInpLS
eqCnsETechInpLSShareIn
eqCnsETechInpLSShareOut
eqCnsETechInpLS
eqCnsLETechInpLYShareIn
eqCnsLETechInpLYShareOut
eqCnsLETechInpLY
eqCnsGETechInpLYShareIn
eqCnsGETechInpLYShareOut
eqCnsGETechInpLY
eqCnsETechInpLYShareIn
eqCnsETechInpLYShareOut
eqCnsETechInpLY
eqCnsLETechInpLYSShareIn
eqCnsLETechInpLYSShareOut
eqCnsLETechInpLYS
eqCnsGETechInpLYSShareIn
eqCnsGETechInpLYSShareOut
eqCnsGETechInpLYS
eqCnsETechInpLYSShareIn
eqCnsETechInpLYSShareOut
eqCnsETechInpLYS
eqCnsLETechInpLRShareIn
eqCnsLETechInpLRShareOut
eqCnsLETechInpLR
eqCnsGETechInpLRShareIn
eqCnsGETechInpLRShareOut
eqCnsGETechInpLR
eqCnsETechInpLRShareIn
eqCnsETechInpLRShareOut
eqCnsETechInpLR
eqCnsLETechInpLRSShareIn
eqCnsLETechInpLRSShareOut
eqCnsLETechInpLRS
eqCnsGETechInpLRSShareIn
eqCnsGETechInpLRSShareOut
eqCnsGETechInpLRS
eqCnsETechInpLRSShareIn
eqCnsETechInpLRSShareOut
eqCnsETechInpLRS
eqCnsLETechInpLRYShareIn
eqCnsLETechInpLRYShareOut
eqCnsLETechInpLRY
eqCnsGETechInpLRYShareIn
eqCnsGETechInpLRYShareOut
eqCnsGETechInpLRY
eqCnsETechInpLRYShareIn
eqCnsETechInpLRYShareOut
eqCnsETechInpLRY
eqCnsLETechInpLRYSShareIn
eqCnsLETechInpLRYSShareOut
eqCnsLETechInpLRYS
eqCnsGETechInpLRYSShareIn
eqCnsGETechInpLRYSShareOut
eqCnsGETechInpLRYS
eqCnsETechInpLRYSShareIn
eqCnsETechInpLRYSShareOut
eqCnsETechInpLRYS
eqCnsLETechInpLCShareIn
eqCnsLETechInpLCShareOut
eqCnsLETechInpLC
eqCnsGETechInpLCShareIn
eqCnsGETechInpLCShareOut
eqCnsGETechInpLC
eqCnsETechInpLCShareIn
eqCnsETechInpLCShareOut
eqCnsETechInpLC
eqCnsLETechInpLCSShareIn
eqCnsLETechInpLCSShareOut
eqCnsLETechInpLCS
eqCnsGETechInpLCSShareIn
eqCnsGETechInpLCSShareOut
eqCnsGETechInpLCS
eqCnsETechInpLCSShareIn
eqCnsETechInpLCSShareOut
eqCnsETechInpLCS
eqCnsLETechInpLCYShareIn
eqCnsLETechInpLCYShareOut
eqCnsLETechInpLCY
eqCnsGETechInpLCYShareIn
eqCnsGETechInpLCYShareOut
eqCnsGETechInpLCY
eqCnsETechInpLCYShareIn
eqCnsETechInpLCYShareOut
eqCnsETechInpLCY
eqCnsLETechInpLCYSShareIn
eqCnsLETechInpLCYSShareOut
eqCnsLETechInpLCYS
eqCnsGETechInpLCYSShareIn
eqCnsGETechInpLCYSShareOut
eqCnsGETechInpLCYS
eqCnsETechInpLCYSShareIn
eqCnsETechInpLCYSShareOut
eqCnsETechInpLCYS
eqCnsLETechInpLCRShareIn
eqCnsLETechInpLCRShareOut
eqCnsLETechInpLCR
eqCnsGETechInpLCRShareIn
eqCnsGETechInpLCRShareOut
eqCnsGETechInpLCR
eqCnsETechInpLCRShareIn
eqCnsETechInpLCRShareOut
eqCnsETechInpLCR
eqCnsLETechInpLCRSShareIn
eqCnsLETechInpLCRSShareOut
eqCnsLETechInpLCRS
eqCnsGETechInpLCRSShareIn
eqCnsGETechInpLCRSShareOut
eqCnsGETechInpLCRS
eqCnsETechInpLCRSShareIn
eqCnsETechInpLCRSShareOut
eqCnsETechInpLCRS
eqCnsLETechInpLCRYShareIn
eqCnsLETechInpLCRYShareOut
eqCnsLETechInpLCRY
eqCnsGETechInpLCRYShareIn
eqCnsGETechInpLCRYShareOut
eqCnsGETechInpLCRY
eqCnsETechInpLCRYShareIn
eqCnsETechInpLCRYShareOut
eqCnsETechInpLCRY
eqCnsLETechInpLCRYSShareIn
eqCnsLETechInpLCRYSShareOut
eqCnsLETechInpLCRYS
eqCnsGETechInpLCRYSShareIn
eqCnsGETechInpLCRYSShareOut
eqCnsGETechInpLCRYS
eqCnsETechInpLCRYSShareIn
eqCnsETechInpLCRYSShareOut
eqCnsETechInpLCRYS
eqCnsLETechOutLShareIn
eqCnsLETechOutLShareOut
eqCnsLETechOutL
eqCnsGETechOutLShareIn
eqCnsGETechOutLShareOut
eqCnsGETechOutL
eqCnsETechOutLShareIn
eqCnsETechOutLShareOut
eqCnsETechOutL
eqCnsLETechOutLSShareIn
eqCnsLETechOutLSShareOut
eqCnsLETechOutLS
eqCnsGETechOutLSShareIn
eqCnsGETechOutLSShareOut
eqCnsGETechOutLS
eqCnsETechOutLSShareIn
eqCnsETechOutLSShareOut
eqCnsETechOutLS
eqCnsLETechOutLYShareIn
eqCnsLETechOutLYShareOut
eqCnsLETechOutLY
eqCnsGETechOutLYShareIn
eqCnsGETechOutLYShareOut
eqCnsGETechOutLY
eqCnsETechOutLYShareIn
eqCnsETechOutLYShareOut
eqCnsETechOutLY
eqCnsLETechOutLYSShareIn
eqCnsLETechOutLYSShareOut
eqCnsLETechOutLYS
eqCnsGETechOutLYSShareIn
eqCnsGETechOutLYSShareOut
eqCnsGETechOutLYS
eqCnsETechOutLYSShareIn
eqCnsETechOutLYSShareOut
eqCnsETechOutLYS
eqCnsLETechOutLRShareIn
eqCnsLETechOutLRShareOut
eqCnsLETechOutLR
eqCnsGETechOutLRShareIn
eqCnsGETechOutLRShareOut
eqCnsGETechOutLR
eqCnsETechOutLRShareIn
eqCnsETechOutLRShareOut
eqCnsETechOutLR
eqCnsLETechOutLRSShareIn
eqCnsLETechOutLRSShareOut
eqCnsLETechOutLRS
eqCnsGETechOutLRSShareIn
eqCnsGETechOutLRSShareOut
eqCnsGETechOutLRS
eqCnsETechOutLRSShareIn
eqCnsETechOutLRSShareOut
eqCnsETechOutLRS
eqCnsLETechOutLRYShareIn
eqCnsLETechOutLRYShareOut
eqCnsLETechOutLRY
eqCnsGETechOutLRYShareIn
eqCnsGETechOutLRYShareOut
eqCnsGETechOutLRY
eqCnsETechOutLRYShareIn
eqCnsETechOutLRYShareOut
eqCnsETechOutLRY
eqCnsLETechOutLRYSShareIn
eqCnsLETechOutLRYSShareOut
eqCnsLETechOutLRYS
eqCnsGETechOutLRYSShareIn
eqCnsGETechOutLRYSShareOut
eqCnsGETechOutLRYS
eqCnsETechOutLRYSShareIn
eqCnsETechOutLRYSShareOut
eqCnsETechOutLRYS
eqCnsLETechOutLCShareIn
eqCnsLETechOutLCShareOut
eqCnsLETechOutLC
eqCnsGETechOutLCShareIn
eqCnsGETechOutLCShareOut
eqCnsGETechOutLC
eqCnsETechOutLCShareIn
eqCnsETechOutLCShareOut
eqCnsETechOutLC
eqCnsLETechOutLCSShareIn
eqCnsLETechOutLCSShareOut
eqCnsLETechOutLCS
eqCnsGETechOutLCSShareIn
eqCnsGETechOutLCSShareOut
eqCnsGETechOutLCS
eqCnsETechOutLCSShareIn
eqCnsETechOutLCSShareOut
eqCnsETechOutLCS
eqCnsLETechOutLCYShareIn
eqCnsLETechOutLCYShareOut
eqCnsLETechOutLCY
eqCnsGETechOutLCYShareIn
eqCnsGETechOutLCYShareOut
eqCnsGETechOutLCY
eqCnsETechOutLCYShareIn
eqCnsETechOutLCYShareOut
eqCnsETechOutLCY
eqCnsLETechOutLCYSShareIn
eqCnsLETechOutLCYSShareOut
eqCnsLETechOutLCYS
eqCnsGETechOutLCYSShareIn
eqCnsGETechOutLCYSShareOut
eqCnsGETechOutLCYS
eqCnsETechOutLCYSShareIn
eqCnsETechOutLCYSShareOut
eqCnsETechOutLCYS
eqCnsLETechOutLCRShareIn
eqCnsLETechOutLCRShareOut
eqCnsLETechOutLCR
eqCnsGETechOutLCRShareIn
eqCnsGETechOutLCRShareOut
eqCnsGETechOutLCR
eqCnsETechOutLCRShareIn
eqCnsETechOutLCRShareOut
eqCnsETechOutLCR
eqCnsLETechOutLCRSShareIn
eqCnsLETechOutLCRSShareOut
eqCnsLETechOutLCRS
eqCnsGETechOutLCRSShareIn
eqCnsGETechOutLCRSShareOut
eqCnsGETechOutLCRS
eqCnsETechOutLCRSShareIn
eqCnsETechOutLCRSShareOut
eqCnsETechOutLCRS
eqCnsLETechOutLCRYShareIn
eqCnsLETechOutLCRYShareOut
eqCnsLETechOutLCRY
eqCnsGETechOutLCRYShareIn
eqCnsGETechOutLCRYShareOut
eqCnsGETechOutLCRY
eqCnsETechOutLCRYShareIn
eqCnsETechOutLCRYShareOut
eqCnsETechOutLCRY
eqCnsLETechOutLCRYSShareIn
eqCnsLETechOutLCRYSShareOut
eqCnsLETechOutLCRYS
eqCnsGETechOutLCRYSShareIn
eqCnsGETechOutLCRYSShareOut
eqCnsGETechOutLCRYS
eqCnsETechOutLCRYSShareIn
eqCnsETechOutLCRYSShareOut
eqCnsETechOutLCRYS
eqCnsLETechCapL
eqCnsGETechCapL
eqCnsETechCapL
eqCnsLETechCapLY
eqCnsGETechCapLY
eqCnsETechCapLY
eqCnsLETechCapLR
eqCnsGETechCapLR
eqCnsETechCapLR
eqCnsLETechCapLRY
eqCnsGETechCapLRY
eqCnsETechCapLRY
eqCnsLETechNewCapL
eqCnsGETechNewCapL
eqCnsETechNewCapL
eqCnsLETechNewCapLY
eqCnsGETechNewCapLY
eqCnsETechNewCapLY
eqCnsLETechNewCapLR
eqCnsGETechNewCapLR
eqCnsETechNewCapLR
eqCnsLETechNewCapLRY
eqCnsGETechNewCapLRY
eqCnsETechNewCapLRY
eqCnsLESupOutShareIn
eqCnsLESupOutShareOut
eqCnsLESupOut
eqCnsGESupOutShareIn
eqCnsGESupOutShareOut
eqCnsGESupOut
eqCnsESupOutShareIn
eqCnsESupOutShareOut
eqCnsESupOut
eqCnsLESupOutSShareIn
eqCnsLESupOutSShareOut
eqCnsLESupOutS
eqCnsGESupOutSShareIn
eqCnsGESupOutSShareOut
eqCnsGESupOutS
eqCnsESupOutSShareIn
eqCnsESupOutSShareOut
eqCnsESupOutS
eqCnsLESupOutYShareIn
eqCnsLESupOutYShareOut
eqCnsLESupOutY
eqCnsGESupOutYShareIn
eqCnsGESupOutYShareOut
eqCnsGESupOutY
eqCnsESupOutYShareIn
eqCnsESupOutYShareOut
eqCnsESupOutY
eqCnsLESupOutYSShareIn
eqCnsLESupOutYSShareOut
eqCnsLESupOutYS
eqCnsGESupOutYSShareIn
eqCnsGESupOutYSShareOut
eqCnsGESupOutYS
eqCnsESupOutYSShareIn
eqCnsESupOutYSShareOut
eqCnsESupOutYS
eqCnsLESupOutRShareIn
eqCnsLESupOutRShareOut
eqCnsLESupOutR
eqCnsGESupOutRShareIn
eqCnsGESupOutRShareOut
eqCnsGESupOutR
eqCnsESupOutRShareIn
eqCnsESupOutRShareOut
eqCnsESupOutR
eqCnsLESupOutRSShareIn
eqCnsLESupOutRSShareOut
eqCnsLESupOutRS
eqCnsGESupOutRSShareIn
eqCnsGESupOutRSShareOut
eqCnsGESupOutRS
eqCnsESupOutRSShareIn
eqCnsESupOutRSShareOut
eqCnsESupOutRS
eqCnsLESupOutRYShareIn
eqCnsLESupOutRYShareOut
eqCnsLESupOutRY
eqCnsGESupOutRYShareIn
eqCnsGESupOutRYShareOut
eqCnsGESupOutRY
eqCnsESupOutRYShareIn
eqCnsESupOutRYShareOut
eqCnsESupOutRY
eqCnsLESupOutRYSShareIn
eqCnsLESupOutRYSShareOut
eqCnsLESupOutRYS
eqCnsGESupOutRYSShareIn
eqCnsGESupOutRYSShareOut
eqCnsGESupOutRYS
eqCnsESupOutRYSShareIn
eqCnsESupOutRYSShareOut
eqCnsESupOutRYS
eqCnsLESupOutCShareIn
eqCnsLESupOutCShareOut
eqCnsLESupOutC
eqCnsGESupOutCShareIn
eqCnsGESupOutCShareOut
eqCnsGESupOutC
eqCnsESupOutCShareIn
eqCnsESupOutCShareOut
eqCnsESupOutC
eqCnsLESupOutCSShareIn
eqCnsLESupOutCSShareOut
eqCnsLESupOutCS
eqCnsGESupOutCSShareIn
eqCnsGESupOutCSShareOut
eqCnsGESupOutCS
eqCnsESupOutCSShareIn
eqCnsESupOutCSShareOut
eqCnsESupOutCS
eqCnsLESupOutCYShareIn
eqCnsLESupOutCYShareOut
eqCnsLESupOutCY
eqCnsGESupOutCYShareIn
eqCnsGESupOutCYShareOut
eqCnsGESupOutCY
eqCnsESupOutCYShareIn
eqCnsESupOutCYShareOut
eqCnsESupOutCY
eqCnsLESupOutCYSShareIn
eqCnsLESupOutCYSShareOut
eqCnsLESupOutCYS
eqCnsGESupOutCYSShareIn
eqCnsGESupOutCYSShareOut
eqCnsGESupOutCYS
eqCnsESupOutCYSShareIn
eqCnsESupOutCYSShareOut
eqCnsESupOutCYS
eqCnsLESupOutCRShareIn
eqCnsLESupOutCRShareOut
eqCnsLESupOutCR
eqCnsGESupOutCRShareIn
eqCnsGESupOutCRShareOut
eqCnsGESupOutCR
eqCnsESupOutCRShareIn
eqCnsESupOutCRShareOut
eqCnsESupOutCR
eqCnsLESupOutCRSShareIn
eqCnsLESupOutCRSShareOut
eqCnsLESupOutCRS
eqCnsGESupOutCRSShareIn
eqCnsGESupOutCRSShareOut
eqCnsGESupOutCRS
eqCnsESupOutCRSShareIn
eqCnsESupOutCRSShareOut
eqCnsESupOutCRS
eqCnsLESupOutCRYShareIn
eqCnsLESupOutCRYShareOut
eqCnsLESupOutCRY
eqCnsGESupOutCRYShareIn
eqCnsGESupOutCRYShareOut
eqCnsGESupOutCRY
eqCnsESupOutCRYShareIn
eqCnsESupOutCRYShareOut
eqCnsESupOutCRY
eqCnsLESupOutCRYSShareIn
eqCnsLESupOutCRYSShareOut
eqCnsLESupOutCRYS
eqCnsGESupOutCRYSShareIn
eqCnsGESupOutCRYSShareOut
eqCnsGESupOutCRYS
eqCnsESupOutCRYSShareIn
eqCnsESupOutCRYSShareOut
eqCnsESupOutCRYS
eqCnsLESupOutLShareIn
eqCnsLESupOutLShareOut
eqCnsLESupOutL
eqCnsGESupOutLShareIn
eqCnsGESupOutLShareOut
eqCnsGESupOutL
eqCnsESupOutLShareIn
eqCnsESupOutLShareOut
eqCnsESupOutL
eqCnsLESupOutLSShareIn
eqCnsLESupOutLSShareOut
eqCnsLESupOutLS
eqCnsGESupOutLSShareIn
eqCnsGESupOutLSShareOut
eqCnsGESupOutLS
eqCnsESupOutLSShareIn
eqCnsESupOutLSShareOut
eqCnsESupOutLS
eqCnsLESupOutLYShareIn
eqCnsLESupOutLYShareOut
eqCnsLESupOutLY
eqCnsGESupOutLYShareIn
eqCnsGESupOutLYShareOut
eqCnsGESupOutLY
eqCnsESupOutLYShareIn
eqCnsESupOutLYShareOut
eqCnsESupOutLY
eqCnsLESupOutLYSShareIn
eqCnsLESupOutLYSShareOut
eqCnsLESupOutLYS
eqCnsGESupOutLYSShareIn
eqCnsGESupOutLYSShareOut
eqCnsGESupOutLYS
eqCnsESupOutLYSShareIn
eqCnsESupOutLYSShareOut
eqCnsESupOutLYS
eqCnsLESupOutLRShareIn
eqCnsLESupOutLRShareOut
eqCnsLESupOutLR
eqCnsGESupOutLRShareIn
eqCnsGESupOutLRShareOut
eqCnsGESupOutLR
eqCnsESupOutLRShareIn
eqCnsESupOutLRShareOut
eqCnsESupOutLR
eqCnsLESupOutLRSShareIn
eqCnsLESupOutLRSShareOut
eqCnsLESupOutLRS
eqCnsGESupOutLRSShareIn
eqCnsGESupOutLRSShareOut
eqCnsGESupOutLRS
eqCnsESupOutLRSShareIn
eqCnsESupOutLRSShareOut
eqCnsESupOutLRS
eqCnsLESupOutLRYShareIn
eqCnsLESupOutLRYShareOut
eqCnsLESupOutLRY
eqCnsGESupOutLRYShareIn
eqCnsGESupOutLRYShareOut
eqCnsGESupOutLRY
eqCnsESupOutLRYShareIn
eqCnsESupOutLRYShareOut
eqCnsESupOutLRY
eqCnsLESupOutLRYSShareIn
eqCnsLESupOutLRYSShareOut
eqCnsLESupOutLRYS
eqCnsGESupOutLRYSShareIn
eqCnsGESupOutLRYSShareOut
eqCnsGESupOutLRYS
eqCnsESupOutLRYSShareIn
eqCnsESupOutLRYSShareOut
eqCnsESupOutLRYS
eqCnsLESupOutLCShareIn
eqCnsLESupOutLCShareOut
eqCnsLESupOutLC
eqCnsGESupOutLCShareIn
eqCnsGESupOutLCShareOut
eqCnsGESupOutLC
eqCnsESupOutLCShareIn
eqCnsESupOutLCShareOut
eqCnsESupOutLC
eqCnsLESupOutLCSShareIn
eqCnsLESupOutLCSShareOut
eqCnsLESupOutLCS
eqCnsGESupOutLCSShareIn
eqCnsGESupOutLCSShareOut
eqCnsGESupOutLCS
eqCnsESupOutLCSShareIn
eqCnsESupOutLCSShareOut
eqCnsESupOutLCS
eqCnsLESupOutLCYShareIn
eqCnsLESupOutLCYShareOut
eqCnsLESupOutLCY
eqCnsGESupOutLCYShareIn
eqCnsGESupOutLCYShareOut
eqCnsGESupOutLCY
eqCnsESupOutLCYShareIn
eqCnsESupOutLCYShareOut
eqCnsESupOutLCY
eqCnsLESupOutLCYSShareIn
eqCnsLESupOutLCYSShareOut
eqCnsLESupOutLCYS
eqCnsGESupOutLCYSShareIn
eqCnsGESupOutLCYSShareOut
eqCnsGESupOutLCYS
eqCnsESupOutLCYSShareIn
eqCnsESupOutLCYSShareOut
eqCnsESupOutLCYS
eqCnsLESupOutLCRShareIn
eqCnsLESupOutLCRShareOut
eqCnsLESupOutLCR
eqCnsGESupOutLCRShareIn
eqCnsGESupOutLCRShareOut
eqCnsGESupOutLCR
eqCnsESupOutLCRShareIn
eqCnsESupOutLCRShareOut
eqCnsESupOutLCR
eqCnsLESupOutLCRSShareIn
eqCnsLESupOutLCRSShareOut
eqCnsLESupOutLCRS
eqCnsGESupOutLCRSShareIn
eqCnsGESupOutLCRSShareOut
eqCnsGESupOutLCRS
eqCnsESupOutLCRSShareIn
eqCnsESupOutLCRSShareOut
eqCnsESupOutLCRS
eqCnsLESupOutLCRYShareIn
eqCnsLESupOutLCRYShareOut
eqCnsLESupOutLCRY
eqCnsGESupOutLCRYShareIn
eqCnsGESupOutLCRYShareOut
eqCnsGESupOutLCRY
eqCnsESupOutLCRYShareIn
eqCnsESupOutLCRYShareOut
eqCnsESupOutLCRY
eqCnsLESupOutLCRYSShareIn
eqCnsLESupOutLCRYSShareOut
eqCnsLESupOutLCRYS
eqCnsGESupOutLCRYSShareIn
eqCnsGESupOutLCRYSShareOut
eqCnsGESupOutLCRYS
eqCnsESupOutLCRYSShareIn
eqCnsESupOutLCRYSShareOut
eqCnsESupOutLCRYS
eqCnsLETotInp
eqCnsGETotInp
eqCnsETotInp
eqCnsLETotInpS
eqCnsGETotInpS
eqCnsETotInpS
eqCnsLETotInpY
eqCnsGETotInpY
eqCnsETotInpY
eqCnsLETotInpYS
eqCnsGETotInpYS
eqCnsETotInpYS
eqCnsLETotInpR
eqCnsGETotInpR
eqCnsETotInpR
eqCnsLETotInpRS
eqCnsGETotInpRS
eqCnsETotInpRS
eqCnsLETotInpRY
eqCnsGETotInpRY
eqCnsETotInpRY
eqCnsLETotInpRYS
eqCnsGETotInpRYS
eqCnsETotInpRYS
eqCnsLETotInpC
eqCnsGETotInpC
eqCnsETotInpC
eqCnsLETotInpCS
eqCnsGETotInpCS
eqCnsETotInpCS
eqCnsLETotInpCY
eqCnsGETotInpCY
eqCnsETotInpCY
eqCnsLETotInpCYS
eqCnsGETotInpCYS
eqCnsETotInpCYS
eqCnsLETotInpCR
eqCnsGETotInpCR
eqCnsETotInpCR
eqCnsLETotInpCRS
eqCnsGETotInpCRS
eqCnsETotInpCRS
eqCnsLETotInpCRY
eqCnsGETotInpCRY
eqCnsETotInpCRY
eqCnsLETotInpCRYS
eqCnsGETotInpCRYS
eqCnsETotInpCRYS
eqCnsLETotOut
eqCnsGETotOut
eqCnsETotOut
eqCnsLETotOutS
eqCnsGETotOutS
eqCnsETotOutS
eqCnsLETotOutY
eqCnsGETotOutY
eqCnsETotOutY
eqCnsLETotOutYS
eqCnsGETotOutYS
eqCnsETotOutYS
eqCnsLETotOutR
eqCnsGETotOutR
eqCnsETotOutR
eqCnsLETotOutRS
eqCnsGETotOutRS
eqCnsETotOutRS
eqCnsLETotOutRY
eqCnsGETotOutRY
eqCnsETotOutRY
eqCnsLETotOutRYS
eqCnsGETotOutRYS
eqCnsETotOutRYS
eqCnsLETotOutC
eqCnsGETotOutC
eqCnsETotOutC
eqCnsLETotOutCS
eqCnsGETotOutCS
eqCnsETotOutCS
eqCnsLETotOutCY
eqCnsGETotOutCY
eqCnsETotOutCY
eqCnsLETotOutCYS
eqCnsGETotOutCYS
eqCnsETotOutCYS
eqCnsLETotOutCR
eqCnsGETotOutCR
eqCnsETotOutCR
eqCnsLETotOutCRS
eqCnsGETotOutCRS
eqCnsETotOutCRS
eqCnsLETotOutCRY
eqCnsGETotOutCRY
eqCnsETotOutCRY
eqCnsLETotOutCRYS
eqCnsGETotOutCRYS
eqCnsETotOutCRYS
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

option lp = cbc;

* f374f3df-5fd6-44f1-b08a-1a09485cbe3d

Solve st_model minimizing vObjective using LP;


file pModelStat_csv / 'pStat.csv'/;
pModelStat_csv.lp = 1;
put pModelStat_csv;
put "value"/;
put st_model.Modelstat:0:9/;
putclose;
file pFinish2_csv / 'pFinish.csv'/;
pFinish2_csv.lp = 1;
put pFinish2_csv;
put "value"/;
put 2:0/;
putclose;

* 99089425-31110-4440-be57-2ca102e9cee1
