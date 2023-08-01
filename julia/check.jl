println("Julia Version: ", VERSION)
using Dates
using JuMP
model = Model();
@variable(model, vObjective);
# eqObjective
@constraint(model, vObjective  ==  123);
@objective(model, Min, vObjective)
using Cbc
set_optimizer(model, Cbc.Optimizer)

optimize!(model)

fvObjective = open("check_result", "w");
println(fvObjective, JuMP.value(vObjective));
close(fvObjective);
