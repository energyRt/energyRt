variable
vObjective
;


**********************************************
** Objective and aggregated costs equations
**********************************************
Equation
eqObjective                         Objective equation
;


eqObjective..
   vObjective =e= 123 ;

model check /all/;
Solve check minimizing vObjective using LP;


file vObjective_csv / 'check_result'/;
vObjective_csv.lp = 1;
vObjective_csv.nd = 1;
vObjective_csv.nz = 1e-25;
vObjective_csv.nr = 2;
put vObjective_csv;
put vObjective.l:0:15/;
putclose;
