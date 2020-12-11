using Dates
using JuMP
model = Model();
@variable(model, vObjective);
# eqObjective
@constraint(model, vObjective  ==  123);

fvObjective = open("check_result", "w");
println(fvObjective, JuMP.value(vObjective));
close(fvObjective);