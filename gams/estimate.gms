********************************************************************************
* Decloration
********************************************************************************
* Main set
set
tech technology
region region
year year
slice slice
group group
comm commodity
;
Alias (tech, techp),   (year, yearp), (year, yearpp), (slice, slicep);
Alias (group, groupp), (comm, commp), (comme, commp);
* Map
set
now_year(year)
IS_CHP(tech)
inp_comm(tech, comm)           Input commodity
out_comm(tech, comm)           Output commodity
share_comm(tech, comm)         Share (group) commodity may be exceesive
cap_comm(tech, comm)           Capacity fix commodity
act_comm(tech, comm)           Activity fix commodity
group_comm(tech, group, comm)  Share (group) commodity connect to group
group_cap(tech, group)         Group connect with capacity
group_act(tech, group)         Group connect with activity
group_inp(tech, group)         Group use for input
group_out(tech, group)         Group use for output
start_year(tech, region, year) Start year
end_year(tech, region, year)   End year
* For CHP
elc_comm(tech, comm)           Electricity commodity for CHP
heat_comm(tech, comm)          Heat        commodity for CHP
* Emissions
*ems_from(comm, commp)          Begin what commodity emis second from
inp_ems_comm(tech, comm)
;

* Set priority
* t, sup, g, c, r, y, s
* tech, sup, group, comm, region, year, slice
* Parameter
parameter
* Technology parameter
* pTecLife(t, r)
pTechOlife(tech, region)
* pTecInp2act(t, g, r, y, s)
pTechGinp2act(tech, group, region, year, slice)
* pTecInp2cap(t, c, r, y, s)
pTechCinpcap(tech, comm, region, year, slice)
* pTecOut2act(t, g, r, y, s)
pTechAct2gout(tech, group, region, year, slice)
* 1 / pTecOut2cap(t, c, r, y, s)
pTechCoutcap(tech, comm, region, year, slice)
* pTecCeff(t, c, r, y, s)
pTechCinp2ginp(tech, comm, region, year, slice)
pTechGout2cout(tech, comm, region, year, slice)
pTechAct2cout(tech, comm, region, year, slice)
pTechCinp2act(tech, comm, region, year, slice)
* pTecFix(t, r, y)
pTechFixom(tech, region, year)
* pTecVar(t, r, y, s)
pTechVarom(tech, region, year, slice)
* pTecInv(t, r, y)
pTechInvcost(tech, region, year)
pTechAnnuityInvcost(tech, region, year)
* pTecShareLo(t, c, r, y, s)
pTechShareLo(tech, comm, region, year, slice)
* pTecShareUp(t, c, r, y, s)
pTechShareUp(tech, comm, region, year, slice)
* pTecAfLo(t, r, y, s)
pTechAfaLo(tech, region, year, slice)
* pTecAfUp(t, r, y, s)
pTechAfaUp(tech, region, year, slice)
* pTecChprLo(t, r, y, s)
pTechChprLo(tech, region, year, slice)
* pTecChprUp(t, r, y, s)
pTechChprUp(tech, region, year, slice)
* pTecCeh(t, r, y, s)
pTechCeh(tech, region, year, slice)
* pTecElcEfficiency(t, r, y, s)
pTechElceff(tech, region, year, slice)
* pTecAfacLo(t, c, r, y, s)
pTechAfacLo(tech, comm, region, year, slice)
* pTecAfacUp(t, c, r, y, s)
pTechAfacUp(tech, comm, region, year, slice)
* pTecStock(t, r, y)
pTechStock(tech, region, year)
* pTecCap2act(t)
pTechCap2act(tech)
pTechGinpcap(tech, group, region, year, slice)
pTechGoutcap(tech, group, region, year, slice)
pTechCvarom(tech, comm, region, year, slice)
*pTechStartStart(tech, region)
*pTechEndEnd(tech, region)
* Exit stock and salvage
pTecSalvageDepriciation(tech, region, year)
pDiscount(region, year)
pDiscountMultiple(region, year)
* Demand
pDemand(comm, region, year, slice)
* Emissions
pEmissionFactor(comm, commp)
* Dummy import
pDumCost(comm, region, year, slice)
* Tax
pTaxCost(comm, region, year, slice)
;


positive variable
vTecNewCap(tech, region, year)
* Technology variable
vTecCap(tech, region, year)
vTecAct(tech, region, year, slice)
vTecInp(tech, comm, region, year, slice)
vTecOut(tech, comm, region, year, slice)
;
variable
vTecInv(tech, region, year)
vTecAnnuityInv(tech, region, year)
vTecFix(tech, region, year)
vTecVar(tech, region, year, slice)
vTecCVar(tech, region, year, slice)
vTecVarY(tech, region, year)
vTecCost(tech, region, year)
;
positive variable
* Demand
vDemInp(comm, region, year, slice)
* Emission
vEmsOut(comm, region, year, slice)
vTecInpComb(comm, region, year, slice)
;
variable
* Ballance
vBalance(comm, region, year, slice)
;
positive variable
vOutFull(comm, region, year, slice)
vInpFull(comm, region, year, slice)
vSupOutFull(comm, region, year, slice)
vTecInpFull(comm, region, year, slice)
vTecOutFull(comm, region, year, slice)
;
variable
* Cost variable
vCost(region, year)
vCostR(region)
vObjective
;
positive variable
* Dummy import
vDumOut(comm, region, year, slice)
;
variable
vDumCost(comm, region, year, slice)
vDumCostY(comm, region, year)
;
variable
* Tax
vTaxCost(comm, region, year, slice)
vTaxCostY(comm, region, year)
;


********************************************************************************
* Equation
********************************************************************************
********************************************************************************
* Technology equation
********************************************************************************

********************************************************************************
* Activity Input & Output equations
********************************************************************************
Equation
* Equation Input fix activity & Output fix activity
eqTecInp2ActOut2Act(tech, region, comm, commp, year, slice)
* Equation Input fix activity & Output group activity
eqTecInp2ActOut2Group(tech, region, comm, groupp, year, slice)
* Equation Input group activity & Output fix activity
eqTecInp2GroupOut2Act(tech, region, group, commp, year, slice)
* Equation Input group activity & Output group activity
eqTecInp2GroupOut2Group(tech, region, group, groupp, year, slice)
* Equation Input fix activity & Output CHP
eqTecInp2ActOutChp(tech, comm, region, year, slice)
* Equation Input group activity & Output CHP
eqTecInp2GroupOutChp(tech, group, region, year, slice)
;

* Equation Input fix activity & Output fix activity
eqTecInp2ActOut2Act(tech, region, comm, commp, year, slice)$
         (
                 inp_comm(tech, comm)  and act_comm(tech, comm) and
                 out_comm(tech, commp) and act_comm(tech, commp)
         )..
                 vTecInp(tech, comm, region, year, slice) *
                 pTechCinp2act(tech, comm, region, year, slice)
                 =e=
                 vTecOut(tech, commp, region, year, slice) /
                 pTechAct2cout(tech, commp, region, year, slice);

* Equation Input fix activity & Output group activity
eqTecInp2ActOut2Group(tech, region, comm, groupp, year, slice)$
         (
                 inp_comm(tech, comm)    and act_comm(tech, comm) and
                 group_out(tech, groupp) and group_act(tech, groupp)
         )..

                 vTecInp(tech, comm, region, year, slice) *
                 pTechCinp2act(tech, comm, region, year, slice) *
                 pTechAct2gout(tech, groupp, region, year, slice)
                 =e=
                 sum(commp$(out_comm(tech, commp) and group_comm(tech, groupp, commp)),
                         vTecOut(tech, commp, region, year, slice) /
                         pTechGout2cout(tech, commp, region, year, slice)
                 );

* Equation Input group activity & Output fix activity
eqTecInp2GroupOut2Act(tech, region, group, commp, year, slice)$
         (
                 group_inp(tech, group) and group_act(tech, group) and
                 out_comm(tech, commp)  and act_comm(tech, commp)
         )..
                 pTechGinp2act(tech, group, region, year, slice) *
                 sum(comm$(inp_comm(tech, comm) and group_comm(tech, group, comm)),
                         vTecInp(tech, comm, region, year, slice) *
                         pTechCinp2ginp(tech, comm, region, year, slice)
                 )
                 =e=
                 vTecOut(tech, commp, region, year, slice) /
                 pTechAct2cout(tech, commp, region, year, slice);


* Equation Input group activity & Output group activity
eqTecInp2GroupOut2Group(tech, region, group, groupp, year, slice)$
         (
                 group_inp(tech, group)  and group_act(tech,group) and
                 group_out(tech, groupp) and group_act(tech,groupp)
         )..
                 pTechGinp2act(tech, group, region, year, slice) *
                 sum(comm$(inp_comm(tech, comm) and group_comm(tech, group, comm)),
                         vTecInp(tech, comm, region, year, slice) *
                         pTechCinp2ginp(tech, comm, region, year, slice)
                 ) *
                 pTechAct2gout(tech, groupp, region, year, slice)
                 =e=
                 sum(commp$(out_comm(tech, commp) and group_comm(tech, groupp, commp)),
                         vTecOut(tech, commp, region, year, slice) /
                         pTechGout2cout(tech, commp, region, year, slice)
                 );

* Equation Input fix activity & Output CHP
eqTecInp2ActOutChp(tech, comm, region, year, slice)$
         (
                 inp_comm(tech, comm) and act_comm(tech, comm) and
                 IS_CHP(tech)
         )..
                 vTecInp(tech, comm, region, year, slice) *
                 pTechCinp2act(tech, comm, region, year, slice) *
                 pTechElceff(tech, region, year, slice)
                 =e=
                 sum((comme, commp)$(elc_comm(tech, comme) and heat_comm(tech, commp)),
                         vTecOut(tech, comme, region, year, slice) +
                         vTecOut(tech, commp, region, year, slice) *
                         pTechCeh(tech, region, year, slice)
                 );

* Equation Input group activity & Output CHP
eqTecInp2GroupOutChp(tech, group, region, year, slice)$
         (
                 group_inp(tech, group) and group_act(tech, group) and
                 IS_CHP(tech)
         )..
                 pTechGinp2act(tech, group, region, year, slice) *
                 sum(comm$(inp_comm(tech, comm) and group_comm(tech, group, comm)),
                         vTecInp(tech, comm, region, year, slice) *
                         pTechCinp2ginp(tech, comm, region, year, slice)
                 ) *
                 pTechElceff(tech, region, year, slice)
                 =e=
                 sum((comme, commp)$(elc_comm(tech, comme) and heat_comm(tech, commp)),
                         vTecOut(tech, comme, region, year, slice) +
                         vTecOut(tech, commp, region, year, slice) *
                         pTechCeh(tech, region, year, slice)
                 );


********************************************************************************
* Input & Output capacity equations
********************************************************************************
Equation
* Input fix capacity eqution
eqTecCapInp(tech, comm, region, year, slice)
* Input group capacity eqution
eqTecCapInpGroup(tech, region, group, year, slice)
* Output fix capacity eqution
eqTecCapOut(tech, comm, region, year, slice)
* Output group capacity eqution
eqTecCapOutGroup(tech, region, group, year, slice)
;

* Input fix capacity eqution
eqTecCapInp(tech, comm, region, year, slice)$
         (
                 inp_comm(tech, comm) and cap_comm(tech, comm)
         )..
                 vTecInp(tech, comm, region, year, slice)
                 =e=
                 vTecCap(tech, region, year) *
                 pTechCinpcap(tech, comm, region, year, slice);

* Input group capacity eqution
eqTecCapInpGroup(tech, region, group, year, slice)$
         (
                 group_inp(tech, group) and group_cap(tech, group)
         )..
                 sum(comm$(inp_comm(tech, comm) and group_comm(tech, group, comm)),
                         vTecInp(tech, comm, region, year, slice) *
                         pTechCinp2ginp(tech, comm, region, year, slice)
                 )
                 =e=
                 vTecCap(tech, region, year) *
                 pTechGinpcap(tech, group, region, year, slice);

* Output fix capacity eqution
eqTecCapOut(tech, comm, region, year, slice)$
         (
                 out_comm(tech, comm) and cap_comm(tech, comm)
         )..
                 vTecOut(tech, comm, region, year, slice)
                 =e=
                 vTecCap(tech, region, year) *
                 pTechCoutcap(tech, comm, region, year, slice);

* Output group capacity eqution
eqTecCapOutGroup(tech, region, group, year, slice)$
         (
                 group_out(tech, group) and group_cap(tech, group)
         )..
                 sum(comm$(out_comm(tech, comm) and group_comm(tech, group, comm)),
                         vTecOut(tech, comm, region, year, slice) /
                         pTechGout2cout(tech, comm, region, year, slice)
                 )
                 =e=
                 vTecCap(tech, region, year) *
                 pTechGoutcap(tech, group, region, year, slice);


********************************************************************************
* Share equations
********************************************************************************
Equation
* Input Share LO equation
eqTecShareInpLo(tech, region, group, comm, year, slice)
* Input Share UP equation
eqTecShareInpUp(tech, region, group, comm, year, slice)
* Output Share LO equation
eqTecShareOutLo(tech, region, group, comm, year, slice)
* Output Share UP equation
eqTecShareOutUp(tech, region, group, comm, year, slice)
;

* Input Share LO equation
eqTecShareInpLo(tech, region, group, comm, year, slice)$
         (
                 group_inp(tech, group) and inp_comm(tech, comm) and
                 share_comm(tech, comm) and group_comm(tech, group, comm)
         )..
                  vTecInp(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$(inp_comm(tech, commp) and group_comm(tech, group, commp)),
                          vTecInp(tech, commp, region, year, slice)
                  );

* Input Share UP equation
eqTecShareInpUp(tech, region, group, comm, year, slice)$
         (
                 group_inp(tech, group) and inp_comm(tech, comm) and
                 share_comm(tech, comm) and group_comm(tech, group, comm)
         )..
                  vTecInp(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$(inp_comm(tech, commp) and group_comm(tech, group, commp)),
                          vTecInp(tech, commp, region, year, slice)
                  );

* Output Share LO equation
eqTecShareOutLo(tech, region, group, comm, year, slice)$
         (
                 group_out(tech, group) and out_comm(tech, comm) and
                 share_comm(tech, comm) and group_comm(tech, group, comm)
         )..
                  vTecOut(tech, comm, region, year, slice)
                  =g=
                  pTechShareLo(tech, comm, region, year, slice) *
                  sum(commp$(out_comm(tech, commp) and group_comm(tech, group, commp)),
                          vTecOut(tech, commp, region, year, slice)
                  );

* Output Share UP equation
eqTecShareOutUp(tech, region, group, comm, year, slice)$
         (
                 group_out(tech, group) and out_comm(tech, comm) and
                 share_comm(tech, comm) and group_comm(tech, group, comm)
         )..
                  vTecOut(tech, comm, region, year, slice)
                  =l=
                  pTechShareUp(tech, comm, region, year, slice) *
                  sum(commp$(out_comm(tech, commp) and group_comm(tech, group, commp)),
                          vTecOut(tech, commp, region, year, slice)
                  );

********************************************************************************
* Availability factor equations
********************************************************************************
Equation
* Availability factor LO
eqTecAfLo(tech, region, year, slice)
* Availability factor UP
eqTecAfUp(tech, region, year, slice)
;

* Availability factor LO
eqTecAfLo(tech, region, year, slice)..
         pTechAfaLo(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTecCap(tech, region, year)
         =l=
         vTecAct(tech, region, year, slice);

* Availability factor UP
eqTecAfUp(tech, region, year, slice)$(
                 pTechAfaUp(tech, region, year, slice) <> Inf
         )..
         vTecAct(tech, region, year, slice)
         =l=
         pTechAfaUp(tech, region, year, slice) *
         pTechCap2act(tech) *
         vTecCap(tech, region, year);



********************************************************************************
* Connect activity with output equations
********************************************************************************
Equation
* Connect activity with group activity output
eqTecActGroup(tech, group, region, year, slice)
* Connect activity with output actvity commodity
eqTecActAct(tech, comm, region, year, slice)
* Connect activity with output CHP
eqTecActChp(tech, region, year, slice)
;

* Connect activity with group activity output
eqTecActGroup(tech, group, region, year, slice)$group_out(tech, group)..
         pTechAct2gout(tech, group, region, year, slice) *
         vTecAct(tech, region, year, slice)
         =e=
         sum(comm$(out_comm(tech, comm) and group_comm(tech, group, comm)),
                 vTecOut(tech, comm, region, year, slice)
         );

* Connect activity with output actvity commodity
eqTecActAct(tech, comm, region, year, slice)$
         (
                 out_comm(tech, comm) and act_comm(tech, comm)
         )..
         vTecOut(tech, comm, region, year, slice) /
         pTechAct2cout(tech, comm, region, year, slice)
         =e=
         vTecAct(tech, region, year, slice);

* Connect activity with output CHP
eqTecActChp(tech, region, year, slice)$IS_CHP(tech)..
         sum(comm$elc_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         )
         +
         sum(comm$heat_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         )
         *
         pTechCeh(tech, region, year, slice)
         =e=
         vTecAct(tech, region, year, slice);

********************************************************************************
* CHPR equations
********************************************************************************
Equation
* CHPR LO equation
eqTecChprLo(tech, region, year, slice)
* CHPR UP equation
eqTecChprUp(tech, region, year, slice)
;

* CHPR LO equation
eqTecChprLo(tech, region, year, slice)$IS_CHP(tech)..
         pTechChprLo(tech, region, year, slice) *
         sum(comm$elc_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         )
         =l=
         sum(comm$heat_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         );

* CHPR UP equation
eqTecChprUp(tech, region, year, slice)$IS_CHP(tech)..
         pTechChprUp(tech, region, year, slice) *
         sum(comm$elc_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         )
         =g=
         sum(comm$heat_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         );

********************************************************************************
* Availability commodity factor equations
********************************************************************************
Equation
* Availability commodity factor LO equations
eqTecAfacLo(tech, region, group, comm, year, slice)
* Availability commodity factor UP equations
eqTecAfacUp(tech, region, group, comm, year, slice)
;

* Availability commodity factor LO equations
eqTecAfacLo(tech, region, group, comm, year, slice)$
         (
                 group_out(tech, group)        and out_comm(tech, comm) and
                 group_comm(tech, group, comm) and
                 pTechAfacLo(tech, comm, region, year, slice) <> 0
         )..
         pTechAct2Gout(tech, group, region, year, slice) *
         pTechAfaUp(tech, region, year, slice) *
         pTechAfacLo(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTecCap(tech, region, year)
         =l=
         vTecOut(tech, comm, region, year, slice);

* Availability commodity factor UP equations
eqTecAfacUp(tech, region, group, comm, year, slice)$
         (
                 group_out(tech, group)        and out_comm(tech, comm) and
                 group_comm(tech, group, comm) and
                 pTechAfacUp(tech, comm, region, year, slice) <> Inf
         )..
         vTecOut(tech, comm, region, year, slice)
         =l=
         pTechAct2Gout(tech, group, region, year, slice) *
         pTechAfaUp(tech, region, year, slice) *
         pTechAfacUp(tech, comm, region, year, slice) *
         pTechCap2act(tech) *
         vTecCap(tech, region, year);

********************************************************************************
* Capacity and cost equations
********************************************************************************
Equation
* Capacity eqaution
eqTecCap(tech, region, year)
* Investition eqaution
eqTecInv(tech, region, year)
eqTecAnnuityInv(tech, region, year)
* FIX O & M eqaution
eqTecFix(tech, region, year)
* Varom O & M eqaution
eqTecVar(tech, region, year, slice)
* Commodity Varom O & M eqaution
eqTecCVar(tech, region, year, slice)
* Commodity Varom O & M and Varom O & M aggregate by year eqaution
eqTecVarY(tech, region, year)
* Cost aggregate by year eqaution
eqTecCost(tech, region, year)
* Disable new capacity
eqTecNewCap(tech, region, year, yearp, yearpp)
;

* Capacity eqaution
eqTecCap(tech, region, year)..
         vTecCap(tech, region, year)
         =e=
         pTechStock(tech, region, year) +
         sum(yearp$
                 (
                         ORD(year) >= ORD(yearp) and
                         ORD(year) < pTechOlife(tech, region) + ORD(yearp)
                 ),
                 vTecNewCap(tech, region, yearp)
         );

* Investition eqaution
eqTecInv(tech, region, year)..
         vTecInv(tech, region, year)
         =e=
         pTechInvcost(tech, region, year) *
         vTecNewCap(tech, region, year);

* Annuity Investition eqaution
eqTecAnnuityInv(tech, region, year)..
         vTecAnnuityInv(tech, region, year)
         =e=
         pTechAnnuityInvcost(tech, region, year) *
         vTecNewCap(tech, region, year);

* FIX O & M eqaution
eqTecFix(tech, region, year)..
         vTecFix(tech, region, year)
         =e=
         pTechFixom(tech, region, year) *
         vTecCap(tech, region, year);

* Varom O & M eqaution
eqTecVar(tech, region, year, slice)..
         vTecVar(tech, region, year, slice)
         =e=
         pTechVarom(tech, region, year, slice) *
         vTecAct(tech, region, year, slice);

* Commodity Varom O & M eqaution
eqTecCVar(tech, region, year, slice)..
         vTecCVar(tech, region, year, slice)
         =e=
         sum(comm$inp_comm(tech, comm),
                 pTechCvarom(tech, comm, region, year, slice) *
                 vTecInp(tech, comm, region, year, slice)
         ) +
         sum(comm$out_comm(tech, comm),
                 pTechCvarom(tech, comm, region, year, slice) *
                 vTecOut(tech, comm, region, year, slice)
         );

* Commodity Varom O & M and Varom O & M aggregate by year eqaution
eqTecVarY(tech, region, year)..
         vTecVarY(tech, region, year)
         =e=
         sum(slice,
                 vTecVar(tech, region, year, slice) +
                 vTecCVar(tech, region, year, slice)
         );

* Cost aggregate by year eqaution
eqTecCost(tech, region, year)..
         vTecCost(tech, region, year)
         =e=
         vTecAnnuityInv(tech, region, year) +
*         vTecInv(tech, region, year) +
         vTecFix(tech, region, year) +
         vTecVarY(tech, region, year);

* Disable new capacity
eqTecNewCap(tech, region, year, yearp, yearpp)$(
         start_year(tech, region, yearp) and end_year(tech, region, yearpp) and
         ORD(year) < ORD(yearp) and ORD(year) > ORD(yearpp))..
         vTecNewCap(tech, region, year) =e= 0;

**************************************
* Demand equation
**************************************
Equation
eqDemInp(comm, region, year, slice)
;

eqDemInp(comm, region, year, slice)..
         vDemInp(comm, region, year, slice)
         =e=
         pDemand(comm, region, year, slice);

**************************************
* Emission equation
**************************************
Equation
eqEmsOut(comm, region, year, slice)
;


eqEmsOut(comm, region, year, slice)..
         vEmsOut(comm, region, year, slice)
         =e=
         sum(commp$pEmissionFactor(comm, commp),
                 pEmissionFactor(comm, commp) *
                 vTecInpComb(commp, region, year, slice)
         );

**************************************
* Ballance equation & dummy
**************************************
Equation
eqBalFx(comm, region, year, slice)
eqBal(comm, region, year, slice)
eqOutFull(comm, region, year, slice)
eqInpFull(comm, region, year, slice)
eqTecInpFull(comm, region, year, slice)
eqEmsInpFull(comm, region, year, slice)
eqTecOutFull(comm, region, year, slice)
;


eqBalFx(comm, region, year, slice)..
         vBalance(comm, region, year, slice) =e= 0;

eqBal(comm, region, year, slice)..
         vBalance(comm, region, year, slice)
         =e=
         vOutFull(comm, region, year, slice) -
         vInpFull(comm, region, year, slice);

eqOutFull(comm, region, year, slice)..
         vOutFull(comm, region, year, slice)
         =e=
         vEmsOut(comm, region, year, slice) +
         vTecOutFull(comm, region, year, slice) +
         vDumOut(comm, region, year, slice);

eqInpFull(comm, region, year, slice)..
         vInpFull(comm, region, year, slice)
         =e=
         vTecInpFull(comm, region, year, slice) +
         vDemInp(comm, region, year, slice);

eqTecInpFull(comm, region, year, slice)..
         vTecInpFull(comm, region, year, slice)
         =e=
         sum(tech$inp_comm(tech, comm),
                 vTecInp(tech, comm, region, year, slice)
         );

eqEmsInpFull(comm, region, year, slice)..
         vTecInpComb(comm, region, year, slice)
         =e=
         sum(tech$(
                         inp_comm(tech, comm) and inp_ems_comm(tech, comm)
                 ),
                 vTecInp(tech, comm, region, year, slice)
         );

eqTecOutFull(comm, region, year, slice)..
         vTecOutFull(comm, region, year, slice)
         =e=
         sum(tech$out_comm(tech, comm),
                 vTecOut(tech, comm, region, year, slice)
         );



**************************************
* Cost equation
**************************************
Equation
eqDumCost(comm, region, year, slice)
eqDumCostY(comm, region, year)
eqCost(region, year)
eqCostR(region)
eqObjective
* Tax
eqTaxCost(comm, region, year, slice)
eqTaxCostY(comm, region, year)
;

eqDumCost(comm, region, year, slice)..
         vDumCost(comm, region, year, slice)
         =e=
         (
                 pDumCost(comm, region, year, slice) *
                 vDumOut(comm, region, year, slice)
         )$(pDumCost(comm, region, year, slice) <> Inf);

eqDumCostY(comm, region, year)..
         vDumCostY(comm, region, year)
         =e=
         sum(slice, vDumCost(comm, region, year, slice));


eqCost(region, year)..
         vCost(region, year)
         =e=
         sum(tech, vTecCost(tech, region, year)) +
         sum(comm, vDumCostY(comm, region, year)) +
         sum(comm, vTaxCostY(comm, region, year));

eqCostR(region)..
         vCostR(region)
         =e=
         sum(year,
                 pDiscountMultiple(region, year) *
                 vCost(region, year)
         ) +
         sum((tech, year),
                 pTecSalvageDepriciation(tech, region, year) *
                 vTecNewCap(tech, region, year)
         );

eqObjective..
         vObjective =e= sum((region,year)$now_year(year), vCost(region, year));

* Tax
eqTaxCost(comm, region, year, slice)..
         vTaxCost(comm, region, year, slice)
         =e=
         pTaxCost(comm, region, year, slice) *
         vOutFull(comm, region, year, slice);

eqTaxCostY(comm, region, year)..
         vTaxCostY(comm, region, year)
         =e=
         sum(slice, vTaxCost(comm, region, year, slice));


*$INCLUDE data.inc
* pTecSalvageDepriciation(tech, region, year)


model st_model /
********************************************************************************
* Equation
********************************************************************************
********************************************************************************
* Technology equation
********************************************************************************
********************************************************************************
* Activity Input & Output equations
********************************************************************************
* Equation Input fix activity & Output fix activity
eqTecInp2ActOut2Act
* Equation Input fix activity & Output group activity
eqTecInp2ActOut2Group
* Equation Input group activity & Output fix activity
eqTecInp2GroupOut2Act
* Equation Input group activity & Output group activity
eqTecInp2GroupOut2Group
* Equation Input fix activity & Output CHP
eqTecInp2ActOutChp
* Equation Input group activity & Output CHP
eqTecInp2GroupOutChp
********************************************************************************
* Input & Output capacity equations
********************************************************************************
* Input fix capacity eqution
eqTecCapInp
* Input group capacity eqution
eqTecCapInpGroup
* Output fix capacity eqution
eqTecCapOut
* Output group capacity eqution
eqTecCapOutGroup
********************************************************************************
* Share equations
********************************************************************************
* Input Share LO equation
eqTecShareInpLo
* Input Share UP equation
eqTecShareInpUp
* Output Share LO equation
eqTecShareOutLo
* Output Share UP equation
eqTecShareOutUp
********************************************************************************
* Availability factor equations
********************************************************************************
* Availability factor LO
eqTecAfLo
* Availability factor UP
eqTecAfUp
********************************************************************************
* Connect activity with output equations
********************************************************************************
* Connect activity with group activity output
eqTecActGroup
* Connect activity with output actvity commodity
eqTecActAct
* Connect activity with output CHP
eqTecActChp
********************************************************************************
* CHPR equations
********************************************************************************
* CHPR LO equation
eqTecChprLo
* CHPR UP equation
eqTecChprUp
********************************************************************************
* Availability commodity factor equations
********************************************************************************
* Availability commodity factor LO equations
eqTecAfacLo
* Availability commodity factor UP equations
eqTecAfacUp
********************************************************************************
* Capacity and cost equations
********************************************************************************
* Capacity eqaution
eqTecCap
* Investition eqaution
eqTecInv
eqTecAnnuityInv
* FIX O & M eqaution
eqTecFix
* Varom O & M eqaution
eqTecVar
* Commodity Varom O & M eqaution
eqTecCVar
* Commodity Varom O & M and Varom O & M aggregate by year eqaution
eqTecVarY
* Cost aggregate by year eqaution
eqTecCost
* Disable new capacity
eqTecNewCap
**************************************
* Demand equation
**************************************
eqDemInp
**************************************
* Emission equation
**************************************
eqEmsOut
**************************************
* Ballance equation & dummy
**************************************
eqBalFx
eqBal
eqOutFull
eqInpFull
eqTecInpFull
eqEmsInpFull
eqTecOutFull
**************************************
* Cost equation
**************************************
eqDumCost
eqDumCostY
eqCost
eqCostR
eqObjective
* Tax
eqTaxCost
eqTaxCostY
/;

* Place to insert your data
* 8e0e2519-23ac-4cde-a239-d4cc154851c6

$EXIT

pDiscountMultiple(region, year) = 1 /
         prod(yearp$(ORD(yearp) <= ORD(year)), 1 + pDiscount(region, yearp));

pTecSalvageDepriciation(tech, region, year) = 0;
loop(yearp$(CARD(year) = ORD(yearp)),
         pTecSalvageDepriciation(tech, region, year)$(
                 ORD(year) + pTechOlife(tech, region) > ORD(yearp)
         ) =
         (1 + pDiscount(region, yearp)) ** (
                 pTechOlife(tech, region) - (ORD(yearp) - ORD(year))
         ) / pDiscountMultiple(region, yearp);
);


vDumOut.FX(comm, region, year, slice)$(pDumCost(comm, region, year, slice) = Inf) = 0;

Solve st_model minimizing vObjective using LP;

file raw_data_set / 'raw_data_set.csv'/;
raw_data_set.lp = 1;
put raw_data_set;
put 'name,value' /;
loop(tech, put 'tech,' tech.tl:0 /;);
loop(group, put 'group,' group.tl:0 /;);
loop(comm, put 'comm,' comm.tl:0 /;);
loop(year, put 'year,' year.tl:0 /;);
loop(region, put 'region,' region.tl:0 /;);
loop(slice, put 'slice,' slice.tl:0 /;);
putclose;

file raw_data_par / 'raw_data_par.csv'/;
raw_data_par.lp = 1;
put raw_data_par;

put 'parameter,tech,sup,group,comm,region,year,slice,value' /;
put 'vObjective,-,-,-,-,-,-,-,'vObjective.l:0:9 /;
put 'Modelstat,-,-,-,-,-,-,-,'st_model.Modelstat:0:9 /;
loop((comm, sup)$(sup_comm(sup, comm) and vSupReserve.l(sup)),
                 put 'vSupReserve,-,'sup.tl:0',-,'comm.tl:0',-,-,-,'vSupReserve.l(sup):0:9 /;);
loop(region$vCostR.l(region), put 'vCostR,-,-,-,-,'region.tl:0',-,-,'vCostR.l(region):0:9 /;);
loop((region, year)$vCost.l(region, year), put 'vCost,-,-,-,-,'region.tl:0','year.tl:0',-,'vCost.l(region, year):0:9 /;);
loop((tech, region, year)$vTecNewCap.l(tech, region, year), put 'vTecNewCap,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0',-,'vTecNewCap.l(tech, region, year):0:9 /;);
loop((tech, region, year)$vTecCap.l(tech, region, year), put 'vTecCap,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0',-,'vTecCap.l(tech, region, year):0:9 /;);
loop((tech, region, year)$vTecVarY.l(tech, region, year), put 'vTecVarY,'tech.tl:0',-,,-,'region.tl:0','year.tl:0',-,'vTecVarY.l(tech, region, year):0:9 /;);
loop((tech, region, year)$vTecCost.l(tech, region, year), put 'vTecCost,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0',-,'vTecCost.l(tech, region, year):0:9 /;);
loop((tech, region, year)$vTecInv.l(tech, region, year), put 'vTecInv,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0',-,'vTecInv.l(tech, region, year):0:9 /;);
loop((tech, region, year)$vTecFix.l(tech, region, year), put 'vTecFix,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0',-,'vTecFix.l(tech, region, year):0:9 /;);
loop((comm, region, year)$vDumCostY.l(comm, region, year), put 'vDumCostY,-,-,-,'comm.tl:0','region.tl:0','year.tl:0',-,'vDumCostY.l(comm, region, year):0:9 /;);
loop((comm, region, year, slice)$vDumOut.l(comm, region, year, slice), put 'vDumOut,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vDumOut.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vDumCost.l(comm, region, year, slice), put 'vDumCost,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vDumCost.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vEmsOut.l(comm, region, year, slice), put 'vEmsOut,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vEmsOut.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vTecInpComb.l(comm, region, year, slice), put 'vTecInpComb,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTecInpComb.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vBalance.l(comm, region, year, slice), put 'vBalance,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vBalance.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vOutFull.l(comm, region, year, slice), put 'vOutFull,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vOutFull.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vInpFull.l(comm, region, year, slice), put 'vInpFull,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vInpFull.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vSupOutFull.l(comm, region, year, slice), put 'vSupOutFull,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vSupOutFull.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vTecInpFull.l(comm, region, year, slice), put 'vTecInpFull,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTecInpFull.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vTecOutFull.l(comm, region, year, slice), put 'vTecOutFull,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTecOutFull.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vDemInp.l(comm, region, year, slice), put 'vDemInp,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vDemInp.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year, slice)$vTaxCost.l(comm, region, year, slice), put 'vTaxCost,-,-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTaxCost.l(comm, region, year, slice):0:9 /;);
loop((comm, region, year)$vTaxCostY.l(comm, region, year), put 'vTaxCostY,-,-,-,'comm.tl:0','region.tl:0','year.tl:0',-,'vTaxCostY.l(comm, region, year):0:9 /;);
loop((tech, region, year, slice)$vTecAct.l(tech, region, year, slice), put 'vTecAct,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0','slice.tl:0','vTecAct.l(tech, region, year, slice):0:9 /;);
loop((tech, region, year, slice)$vTecVar.l(tech, region, year, slice), put 'vTecVar,'tech.tl:0',-,-,-,'region.tl:0','year.tl:0','slice.tl:0','vTecVar.l(tech, region, year, slice):0:9 /;);
loop((tech, comm, region, year, slice)$vTecInp.l(tech, comm, region, year, slice), put 'vTecInp,'tech.tl:0',-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTecInp.l(tech, comm, region, year, slice):0:9 /;);
loop((tech, comm, region, year, slice)$vTecOut.l(tech, comm, region, year, slice), put 'vTecOut,'tech.tl:0',-,-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vTecOut.l(tech, comm, region, year, slice):0:9 /;);
loop((sup, region, year, slice)$vSupCost.l(sup, region, year, slice), put 'vSupCost,-,'sup.tl:0',-,-,'region.tl:0','year.tl:0','slice.tl:0','vSupCost.l(sup, region, year, slice):0:9 /;);
loop((sup, comm, region, year, slice)$vSupOut.l(sup, comm, region, year, slice), put 'vSupOut,-,'sup.tl:0',-,'comm.tl:0','region.tl:0','year.tl:0','slice.tl:0','vSupOut.l(sup, comm, region, year, slice):0:9 /;);
loop((sup, region, year)$vSupCostY.l(sup, region, year), put 'vSupCostY,-,'sup.tl:0',-,-,'region.tl:0','year.tl:0',-,'vSupCostY.l(sup, region, year):0:9 /;);
putclose;