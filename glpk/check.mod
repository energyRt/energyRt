
var vObjective;

s.t.  eqObjective: vObjective  =  123;

minimize vObjective2 : vObjective;

solve;

printf "%s\n",vObjective > "check_result";

end;


