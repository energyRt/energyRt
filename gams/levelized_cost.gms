********************************************************************************
* Decloration
********************************************************************************
* Main set
set
r region
y year
s slice
g group
c commodity
;
Alias (r, rp), (y, yp), (s, sp), (g, gp), (c, cp), (ce, cp);
* Map
set
input_commodity(c)
output_commodity(c)
share_commodity(c)
cap_commodity(c)
act_commodity(c)
group_commodity(c, g)
obj_commodity(c)
start_year(y)
start_slice(s)
try_region(r)
group_input(g)
group_output(g)
* For CHP
elc_commodity(c)
heat_commodity(c)
;

* Parameter
parameter
pDiscount(r, y)
pDepriciation(r, y)
pEfficiency(r, g, y, s)
pOutEfficiency(r, g, y, s)
pInp2act(r, g, y, s)
pInp2cap(r, c, y, s)
pOut2act(r, g, y, s)
pOut2cap(r, c, y, s)
pCeff(r, c, y, s)
pFixom(r, y)
pVarom(r, y, s)
pInvcost(r, y)
pPrice(r, c, y, s)
pCap2act
pShareMin(r, c, y, s)
pShareMax(r, c, y, s)
pAfMin(r, y, s)
pAfMax(r, y, s)
pFor_activity
pObjective
* For CHP
pChprMin(r, y, s)
pChprMax(r, y, s)
pCeh(r, y, s)
pElcEfficiency(r, y, s)
* For ActFlow
pAfacLo(r, c, y, s)
pAfacUp(r, c, y, s)
IS_CHP
;

variable
* Activity variable
vCap(r, y)
vAct(r, y, s)
vInput(r, c, y, s)
vOutput(r, c, y, s)
* Cost variable
vInv_cost(r, y)
vFix_cost(r, y)
vVar_cost(r, y, s)
vVar_costYear(r, y)
vFlow_cost(r, y, s)
vFlow_costYear(r, y)
vYear_cost(r, y)
vRegion_cost(r)
vTotal_cost
vDiscount_commodity(c)
vDiscount_activity
vInv_costTotal
vFix_costTotal
vVar_costTotal
vFlow_costTotal
*vLevelized_cost(c)
vObjective
* For use effec output commodity
vCapacity
;


********************************************************************************
* Equation
********************************************************************************
**************************************
* Input / Output equation
**************************************
Equation
eqInp2ActOut2Act(r, c, cp, y, s)
eqInp2ActOut2Group(r, c, gp, y, s)
eqInp2GroupOut2Act(r, g, cp, y, s)
eqInp2GroupOut2Group(r, g, gp, y, s)
eqInp2ActOutChp(r, c, y, s)
eqInp2GroupOutChp(r, g, y, s)
eqCpacity_input(r, c, y, s)
eqCpacity_output(r, c, y, s)
eqShare_inputMin(r, g, c, y, s)
eqShare_inputMax(r, g, c, y, s)
eqShare_outputMin(r, g, c, y, s)
eqShare_outputMax(r, g, c, y, s)
eqAfMin(r, y, s)
eqAfMax(r, y, s)
eqActivity_group(r, g, y, s)
eqActivity_activity(r, c, y, s)
eqChprMin(r, y, s)
eqChprMax(r, y, s)
eqAfacLo(r, g, c, y, s)
eqAfacUp(r, g, c, y, s)
;


eqInp2ActOut2Act(r, c, cp, y, s)$(input_commodity(c) and act_commodity(c) and
         output_commodity(cp) and act_commodity(cp))..
                 vInput(r, c, y, s) * pCeff(r, c, y, s) =e=
                         vOutput(r, cp, y, s) / pCeff(r, cp, y, s);

eqInp2ActOut2Group(r, c, gp, y, s)$(input_commodity(c) and act_commodity(c) and
         group_output(gp))..
                 vInput(r, c, y, s) * pCeff(r, c, y, s) *
                         pOut2Act(r, gp, y, s) =e=
                            sum(cp$(output_commodity(cp) and group_commodity(cp, gp)),
                                 vOutput(r, cp, y, s) / pCeff(r, cp, y, s));

eqInp2GroupOut2Act(r, g, cp, y, s)$(group_input(g) and
         output_commodity(cp) and act_commodity(cp))..
                 pInp2Act(r, g, y, s) *
                    sum(c$(input_commodity(c) and group_commodity(c, g)),
                       vInput(r, c, y, s) * pCeff(r, c, y, s)) =e=
                         vOutput(r, cp, y, s) / pCeff(r, cp, y, s);

eqInp2GroupOut2Group(r, g, gp, y, s)$(group_input(g) and group_output(gp))..
                 pInp2Act(r, g, y, s) *
                    sum(c$(input_commodity(c) and group_commodity(c, g)),
                       vInput(r, c, y, s) * pCeff(r, c, y, s)) *
                         pOut2Act(r, gp, y, s) =e=
                           sum(cp$(output_commodity(cp) and group_commodity(cp, gp)),
                                 vOutput(r, cp, y, s) / pCeff(r, cp, y, s));

eqInp2ActOutChp(r, c, y, s)$(input_commodity(c) and act_commodity(c) and IS_CHP = 1)..
                 vInput(r, c, y, s) * pCeff(r, c, y, s) * pElcEfficiency(r, y, s) =e=
                   sum((ce,cp)$(elc_commodity(ce) and heat_commodity(cp)),
                         vOutput(r, ce, y, s) + vOutput(r, cp, y, s) * pCeh(r, y, s));

eqInp2GroupOutChp(r, g, y, s)$(group_input(g) and IS_CHP = 1)..
                 pInp2Act(r, g, y, s) *
                    sum(c$(input_commodity(c) and group_commodity(c, g)),
                       vInput(r, c, y, s) * pCeff(r, c, y, s)) * pElcEfficiency(r, y, s) =e=
                           sum((ce,cp)$(elc_commodity(ce) and heat_commodity(cp)),
                             vOutput(r, ce, y, s) + vOutput(r, cp, y, s) * pCeh(r, y, s));


eqCpacity_input(r, c, y, s)$(input_commodity(c) and cap_commodity(c))..
                 vInput(r, c, y, s) =e= vCap(r, y) * pInp2cap(r, c, y, s);

eqCpacity_output(r, c, y, s)$(output_commodity(c) and cap_commodity(c))..
                 vOutput(r, c, y, s) =e= vCap(r, y) * pOut2cap(r, c, y, s);

eqShare_inputMin(r, g, c, y, s)$(group_input(g) and input_commodity(c) and share_commodity(c)
         and group_commodity(c, g))..
                 vInput(r, c, y, s) =g=
                         pShareMin(r, c, y, s) * sum(cp$(input_commodity(cp) and group_commodity(cp, g)),
                                 vInput(r, cp, y, s));

eqShare_inputMax(r, g, c, y, s)$(group_input(g) and input_commodity(c) and share_commodity(c)
         and group_commodity(c, g))..
                 vInput(r, c, y, s) =l=
                         pShareMax(r, c, y, s) * sum(cp$(input_commodity(cp) and group_commodity(cp, g)),
                                 vInput(r, cp, y, s));

eqShare_outputMin(r, g, c, y, s)$(group_output(g) and output_commodity(c) and share_commodity(c)
         and group_commodity(c, g))..
                  vOutput(r, c, y, s) =g=
                         pShareMin(r, c, y, s) * sum(cp$(output_commodity(cp) and group_commodity(cp, g)),
                                 vOutput(r, cp, y, s));

eqShare_outputMax(r, g, c, y, s)$(group_output(g) and output_commodity(c) and share_commodity(c)
         and group_commodity(c, g))..
                 vOutput(r, c, y, s) =l=
                         pShareMax(r, c, y, s) * sum(cp$(output_commodity(cp) and group_commodity(cp, g)),
                                 vOutput(r, cp, y, s));

eqAfMin(r, y, s).. pAfMin(r, y, s) * pCap2act * vCap(r, y) =l= vAct(r, y, s);

eqAfMax(r, y, s).. vAct(r, y, s) =l= pAfMax(r, y, s) * pCap2act * vCap(r, y);


eqActivity_group(r, g, y, s)$group_output(g)..
                 pOut2Act(r, g, y, s) * vAct(r, y, s) =e= sum(c$(output_commodity(c) and group_commodity(c, g)),
                                 vOutput(r, c, y, s));

eqActivity_activity(r, c, y, s)$(output_commodity(c) and act_commodity(c))..
                   vOutput(r, c, y, s) / pCeff(r, c, y, s) =e= vAct(r, y, s);


eqChprMin(r, y, s).. pChprMin(r, y, s) * sum(c$elc_commodity(c), vOutput(r, c, y, s))
                                 =l= sum(c$heat_commodity(c), vOutput(r, c, y, s));

eqChprMax(r, y, s).. pChprMax(r, y, s) * sum(c$elc_commodity(c), vOutput(r, c, y, s))
                                 =g= sum(c$heat_commodity(c), vOutput(r, c, y, s));

eqAfacLo(r, g, c, y, s)$(group_output(g) and output_commodity(c)
                 and group_commodity(c, g) and pAfacLo(r, c, y, s) <> 0)..
                         pOut2Act(r, g, y, s) * pAfMax(r, y, s) * pAfacLo(r, c, y, s) *
                                         pCap2act * vCap(r, y) =l= vOutput(r, c, y, s);

eqAfacUp(r, g, c, y, s)$(group_output(g) and output_commodity(c)
                 and group_commodity(c, g) and pAfacUp(r, c, y, s) <> Inf)..
                         vOutput(r, c, y, s) =l= pOut2Act(r, g, y, s) * pAfMax(r, y, s) *
                                         pAfacUp(r, c, y, s) * pCap2act * vCap(r, y);

**************************************
* Cost equation
**************************************
Equation
eqInv_cost(r, y)
eqInv_cost2(r, y)
eqFix_cost(r, y)
eqVar_cost(r, y, s)
eqVar_costYear(r, y)
eqFlow_cost(r, y, s)
eqFlow_costYear(r, y)
eqYear_cost(r, y)
eqRegion_cost(r, y)
eqTotal_cost
*eqLevelized_cost(c)
eqInv_costTotal(r, y)
eqFix_costTotal(r, y)
eqVar_costTotal(r, y)
eqFlow_costTotal(r, y)
;

eqInv_cost(r, y)$(start_year(y) and try_region(r))..
                 vInv_cost(r, y) =e= pInvcost(r, y) * vCap(r, y);

eqInv_cost2(r, y)$(not(start_year(y) and try_region(r)))..
                 vInv_cost(r, y) =e= 0;

eqFix_cost(r, y)$try_region(r)..
                 vFix_cost(r, y) =e= pFixom(r, y) * vCap(r, y);

eqVar_cost(r, y, s)$try_region(r)..
                 vVar_cost(r, y, s) =e= pVarom(r, y, s) * vAct(r, y, s);

eqVar_costYear(r, y).. vVar_costYear(r, y) =e=
                                 sum(s, vVar_cost(r, y, s));

eqFlow_cost(r, y, s)..
                 vFlow_cost(r, y, s) =e=
                         sum(c$input_commodity(c), pPrice(r, c, y, s) * vInput(r, c, y, s))
                         - sum(c$output_commodity(c), pPrice(r, c, y, s) * vOutput(r, c, y, s));

eqFlow_costYear(r, y).. vFlow_costYear(r, y) =e=
                                 sum(s, vFlow_cost(r, y, s));

eqYear_cost(r, y).. vYear_cost(r, y) =e= vInv_cost(r, y) + vFix_cost(r, y)
                         + vVar_costYear(r, y) + vFlow_costYear(r, y);

eqRegion_cost(r, y)$start_year(y)..
                 vRegion_cost(r) * pDiscount(r, y) =e=
                         sum(yp, vYear_cost(r, yp) * pDiscount(r, yp));

******************
eqInv_costTotal(r, y)$(start_year(y) and try_region(r))..
                 vInv_costTotal * pDiscount(r, y) =e=
                         sum(yp, vInv_cost(r, yp) * pDiscount(r, yp));

eqFix_costTotal(r, y)$(start_year(y) and try_region(r))..
                 vFix_costTotal * pDiscount(r, y) =e=
                         sum(yp, vFix_cost(r, yp) * pDiscount(r, yp));

eqVar_costTotal(r, y)$(start_year(y) and try_region(r))..
                 vVar_costTotal * pDiscount(r, y) =e=
                         sum(yp, vVar_costYear(r, yp) * pDiscount(r, yp));

eqFlow_costTotal(r, y)$(start_year(y) and try_region(r))..
                 vFlow_costTotal * pDiscount(r, y) =e=
                         sum(yp, vFlow_costYear(r, yp) * pDiscount(r, yp));

eqTotal_cost.. vTotal_cost =e= sum(r, vRegion_cost(r));

**************************************
* Dummy equation
**************************************
Equation
eqCapacity(r, y)
;

eqCapacity(r, y)$try_region(r).. vCap(r, y) =e= vCapacity * pDepriciation(r, y);


**************************************
* Objective equation
**************************************
Equation
eqDiscount_commodity(c)
eqDiscount_activity
eqObjective
;

eqDiscount_commodity(c).. vDiscount_commodity(c) =e= sum((r, y, s),
                                  pDiscount(r, y) * vOutput(r, c, y, s));

eqDiscount_activity.. vDiscount_activity =e= sum((r, y, s),
                                  pDiscount(r, y) * vAct(r, y, s));

eqObjective..  vObjective =e= sum(c$obj_commodity(c), vDiscount_commodity(c))
                         + vDiscount_activity * pFor_activity;
*eqObjective(c)$obj_commodity(c)..  vObjective =e= sum((r, y, s), vAct(r, y, s));

*$EXIT

model max_commodity /
eqInp2ActOut2Act
eqInp2ActOut2Group
eqInp2GroupOut2Act
eqInp2GroupOut2Group
eqInp2ActOutChp
eqInp2GroupOutChp
eqCpacity_input
eqCpacity_output
eqShare_inputMin
eqShare_inputMax
eqShare_outputMin
eqShare_outputMax
eqAfMin
eqAfMax
eqActivity_group
eqActivity_activity
eqChprMin
eqChprMax
eqAfacLo
eqAfacUp
eqInv_cost
eqInv_cost2
eqFix_cost
eqVar_cost
eqVar_costYear
eqFlow_cost
eqFlow_costYear
eqYear_cost
eqRegion_cost
eqTotal_cost
*eqLevelized_cost
eqInv_costTotal
eqFix_costTotal
eqVar_costTotal
eqFlow_costTotal
eqObjective
eqCapacity
eqDiscount_commodity
eqDiscount_activity
/;

*$EXIT
$INCLUDE 'data_levelised.inc'

*ANY_GROUP   = 0;
*loop((r, g, y, s)$(pOutEfficiency(r, g, y, s) <> 1), ANY_GROUP = 1);

*$INCLUDE 'c:/tmp/gms/data_levelised.inc'

pPrice(r, c, y, s)$obj_commodity(c) = 0;
vCapacity.FX = 1;


Solve max_commodity maximizing vObjective using LP;

*Display obj_commodity, pDiscount, vCap.L, vAct.L, pAfMin;
*Display pAfMax, pInp2act, pOut2act, group_commodity;


pObjective = vObjective.L;
vDiscount_commodity.FX(c)$obj_commodity(c) = vDiscount_commodity.L(c);
if(pFor_activity = 1, vDiscount_activity.FX = vDiscount_activity.L);


model min_cost /
eqInp2ActOut2Act
eqInp2ActOut2Group
eqInp2GroupOut2Act
eqInp2GroupOut2Group
eqInp2ActOutChp
eqInp2GroupOutChp
eqCpacity_input
eqCpacity_output
eqShare_inputMin
eqShare_inputMax
eqShare_outputMin
eqShare_outputMax
eqAfMin
eqAfMax
eqActivity_group
eqActivity_activity
eqChprMin
eqChprMax
eqAfacLo
eqAfacUp
eqInv_cost
eqInv_cost2
eqFix_cost
eqVar_cost
eqVar_costYear
eqFlow_cost
eqFlow_costYear
eqYear_cost
eqRegion_cost
eqTotal_cost
*eqLevelized_cost
eqInv_costTotal
eqFix_costTotal
eqVar_costTotal
eqFlow_costTotal
eqObjective
eqCapacity
eqDiscount_commodity
eqDiscount_activity
/;

vCapacity.UP = Inf;
vCapacity.LO = 0;
Solve min_cost minimizing vTotal_cost using LP;

file levelized_cost /levelized_cost.csv/;
levelized_cost.lp = 1;
put levelized_cost;
put 'parameter,name' /;
put 'rs,'max_commodity.Modelstat:0:9 /;
put 'rs,'min_cost.Modelstat:0:9 /;
put 'TotalCostMin,'vTotal_cost.L:0:9 /;
put 'InvCostMin,'vInv_costTotal.L:0:9 /;
put 'FixCostMin,'vFix_costTotal.L:0:9 /;
put 'VarCostMin,'vVar_costTotal.L:0:9 /;
put 'FlowCostMin,'vFlow_costTotal.L:0:9 /;

vCapacity.FX = 1;

Solve min_cost maximizing vTotal_cost using LP;
put 'rs,'min_cost.Modelstat:0:9 /;
put 'TotalCostMax,'vTotal_cost.L:0:9 /;
put 'pObjective,'pObjective:0:9 /;
putclose;

********************************************************************************************************
* Stop
********************************************************************************************************

file log_set /'c:\tmp\gams\log_set.csv'/;
log_set.lp = 1;
put log_set;
put 'r'; loop(r, put ','r.tl:0); put /;
put 'y'; loop(y, put ','y.tl:0); put /;
put 's'; loop(s, put ','s.tl:0); put /;
put 'c'; loop(c, put ','c.tl:0); put /;
put 'g'; loop(g, put ','g.tl:0); put /;
putclose;

file log_data /'c:\tmp\gams\log_data.csv'/;
log_data.lp = 1;
put log_data;

put 'name,r,y,s,c,g,data'/;
put 'vTotal_cost,NA,NA,NA,NA,NA,'vTotal_cost.l:0:9/;
put 'vCapacity,NA,NA,NA,NA,NA,'vCapacity.l:0:9/;
put 'vObjective,NA,NA,NA,NA,NA,'vObjective.l:0:9/;
*put 'lev_cost,NA,NA,NA,NA,NA,'lev_cost:0:9/;

loop(r, put 'vRegion_cost,'r.tl:0',NA,NA,NA,NA,'vRegion_cost.l(r):0:9/;);
loop(c, put 'vDiscount_commodity,NA,NA,NA,'c.tl:0',NA,'vDiscount_commodity.l(c):0:9/;);

loop((r, y), put 'vCap,'r.tl:0','y.tl:0',NA,NA,NA,'vCap.l(r, y):0:9/;);
loop((r, y), put 'vFlow_costYear,'r.tl:0','y.tl:0',NA,NA,NA,'vFlow_costYear.l(r, y):0:9/;);
loop((r, y), put 'vYear_cost,'r.tl:0','y.tl:0',NA,NA,NA,'vYear_cost.l(r, y):0:9/;);
loop((r, y), put 'vVar_costYear,'r.tl:0','y.tl:0',NA,NA,NA,'vVar_costYear.l(r, y):0:9/;);
loop((r, y), put 'vInv_cost,'r.tl:0','y.tl:0',NA,NA,NA,'vInv_cost.l(r, y):0:9/;);
loop((r, y), put 'vFix_cost,'r.tl:0','y.tl:0',NA,NA,NA,'vFix_cost.l(r, y):0:9/;);

loop((r, y, s), put 'vAct,'r.tl:0','y.tl:0','s.tl:0',NA,NA,'vAct.l(r, y, s):0:9/;);
loop((r, y, s), put 'vVar_cost,'r.tl:0','y.tl:0','s.tl:0',NA,NA,'vVar_cost.l(r, y, s):0:9/;);
loop((r, y, s), put 'vFlow_cost,'r.tl:0','y.tl:0','s.tl:0'NA,NA,,'vFlow_cost.l(r, y, s):0:9/;);

loop((r, c, y, s), put 'vInput,'r.tl:0','y.tl:0','s.tl:0','c.tl:0',NA,'vInput.l(r, c, y, s):0:9/;);
loop((r, c, y, s), put 'vOutput,'r.tl:0','y.tl:0','s.tl:0','c.tl:0',NA,'vOutput.l(r, c, y, s):0:9/;);

loop((r, g, y, s)$group_input(g), put 'vGroup_input,'r.tl:0','y.tl:0','s.tl:0',NA,'g.tl:0','vGroup_input.l(r, g, y, s):0:9/;);
loop((r, g, y, s)$group_output(g), put 'vGroup_output,'r.tl:0','y.tl:0','s.tl:0',NA,'g.tl:0','vGroup_output.l(r, g, y, s):0:9/;);

putclose;

*eqLevelized_cost(c)
*eqObjective

Display ANY_GROUP;