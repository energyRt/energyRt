verbose = True
import datetime

print("start time: " + str(datetime.datetime.now().strftime("%H:%M:%S")) + "\n")
flog = open("check_result", "w")
import time

seconds = time.time()
import itertools
from pyomo.environ import *
from pyomo.opt import SolverFactory
import pyomo.environ as pyo

model = ConcreteModel()
##### decl par #####
print(
    "variables... "
    + str(datetime.datetime.now().strftime("%H:%M:%S"))
    + " ("
    + str(round(time.time() - seconds, 2))
    + " s)"
)
model.vObjective = Var(doc="Objective costs")
print(
    "equations... "
    + str(datetime.datetime.now().strftime("%H:%M:%S"))
    + " ("
    + str(round(time.time() - seconds, 2))
    + " s)"
)
# eqObjective
model.eqObjective = Constraint(rule=lambda model: model.vObjective == 123)
if verbose:
    print(
        datetime.datetime.now().strftime("%H:%M:%S"),
        " (",
        round(time.time() - seconds, 2),
        " s)",
        sep="",
    )
model.obj = Objective(rule=lambda model: model.vObjective, sense=minimize)
print("solving... ")
opt = SolverFactory("cplex")
slv = opt.solve(model, tee=True)
flog.write(str(model.vObjective.value) + "\n")
flog.close()
