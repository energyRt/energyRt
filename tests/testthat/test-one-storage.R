# source("~/.ideea/settings.R")
# library(energyRt)
# library(tidyverse)

h10 <- make_timetable(
  struct = list(
    ANNUAL = "ANNUAL",
    HOUR = paste0("h", 0:9))
)

calendar_h10 <- newCalendar(h10, name = "h10")

INP <- newCommodity("INP", timeframe = "HOUR")
OUT <- newCommodity("OUT", timeframe = "HOUR")

SUP_INP <- newSupply(
  name = "SUP_INP",
  commodity = "INP",
  availability = data.frame(
    cost = 1
  )
)

TECH <- newTechnology(
  name = "TECH",
  input = list(comm = "INP"),
  output = list(comm = "OUT"),
  invcost = list(invcost = 100),
  # fixom = list(fixom = 1),
  # varom = list(varom = .1),
  olife = list(olife = 10), 
  cap2act = 10
)

DEM <- newDemand(
  name = "DEM",
  commodity = "OUT",
  dem = data.frame(
    # region = "REG",
    # year = 2010:2050,
    slice = h10$HOUR,
    dem = rep(c(0, 10), 5)
  )
)
DEM@dem

STG <- newStorage(
  name = "STG1H",
  desc = "Storage with 1 hour capacity",
  commodity = "OUT",
  invcost = list(invcost = 10),
  olife = list(olife = 10)
)

repo_stg <- newRepository("repo_stg", INP, OUT, SUP_INP, TECH, DEM)

mod_unit <- newModel(
  name = "UNIT_stg",
  desc = "Unit test model with storage",
  repo = repo_stg,
  calendar = calendar_h10,
  region = "REG",
  horizon = newHorizon(2010),
  discount = 0
)

set_default_solver(solver_options$gams_gdx_cplex)
# scen_stg <- solve(mod_unit, name = "scen_stg", STG)
scen_stg <- solve_model(mod_unit, name = "scen_stg", STG)
# scen_stg <- solve(add(mod_unit, STG), name = "scen_stg")
getData(scen_stg, "vObjective")
getData(scen_stg, name_ = "NewCap", merge = TRUE, process = TRUE)

STG2H <- update(STG, 
                cap2stg = 2, # MW * cap2stg = MWh
                name = "STG2H",
                invcost = list(invcost = 20),
                desc = "Storage with 2 hours capacity")
scen_stg2h <- solve_model(mod_unit, STG2H, name = "scen_stg2h")
getData(scen_stg2h, "vObjective")

# 2h storage has twice lower release capacity ("MW") than 1h storage
getData(scen_stg2h, name_ = "NewCap", merge = TRUE, process = TRUE)

# but the level of stored energy is the same in both cases
getData(list(scen_stg, scen_stg2h), "vStorageStore", merge = TRUE, 
        process = TRUE) |>
  select(-1) |>
  pivot_wider(names_from = "process")
