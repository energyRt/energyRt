# one input, one output, efficiency = 1
INP <- newCommodity("INP", desc = "input")
OUT <- newCommodity("OUT", desc = "output")
SUP_INP <- newSupply("SUP_INP", desc = "supply of input", commodity = "INP")
DEM_OUT <- newDemand(
  name = "DEM_OUT", 
  desc = "demand for output", 
  commodity = "OUT",
  dem = data.frame(
    # region = "ONE",
    year = 2010:2020,
    # slice = "ONE",
    dem = 100
  )
)

TECH <- newTechnology(
  name = "TECH", 
  desc = "technology",
  input = list(comm = "INP"),
  output = list(comm = "OUT"),
  invcost = list(invcost = 100),
  fixom = list(fixom = 10),
  varom = list(varom = 1),
  olife = list(olife = 10)
  )
# draw(TECH)
repo_one <- newRepository(
  name = "repo_one",
  INP, OUT, SUP_INP, DEM_OUT, TECH
  )

m <- newModel(
  name = "ONE",
  data = repo_one,
  horizon = newHorizon(2010, 1),
  discount = 0,
  region = "ONE"
  )
getHorizon(m)

show_progress_bar(FALSE)
scen <- solve(m, solver = "glpk")
scen
getData(scen, "vTechCap")
getData(scen, name_ = "cost")
getData(scen, name_ = "inv")
getData(scen, name_ = "eac")
getData(scen, name_ = "dem")

# Early retirement
m@config@early.retirement <- TRUE
TECH1 <- update(TECH, early.retirement = TRUE, name = "TECH1",
                stock = data.frame(stock = c(rep(1, 5), 0), year = 2010:2015))
TECH2 <- update(TECH, early.retirement = TRUE, name = "TECH2",
                invcost = list(invcost = 10),
                fixom = list(fixom = 0),
                start = list(start = 2012)
                )

repo_ret <- add(repo_one, TECH1, TECH2)

m <- newModel(
  name = "ONE",
  data = repo_ret,
  horizon = newHorizon(2010:2025),
  discount = 0,
  region = "ONE",
  early.retirement = TRUE
)
getHorizon(m)
m@config@early.retirement

scen_ret <- interpolate(m)
scen_ret <- write_sc(scen_ret, 
                    solver = solver_options$gams_gdx_cplex, 
                    tmp.dir = "tmp/mod_one_ret")
scen_ret <- solve(scen_ret)
scen_ret <- read(scen_ret)


# scen_ret <- solve(
#   m,
#   solver = "glpk"
#   )
scen_ret
getData(scen_ret, "vTechCap", drop.zeros = TRUE)
getData(scen_ret, name_ = "NewCap", drop.zeros = TRUE)
getData(scen_ret, name_ = "retire", drop.zeros = TRUE)
getData(scen_ret, name_ = "dem")
