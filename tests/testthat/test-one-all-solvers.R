# Config/testthat/edition: 3
# Config/testthat/parallel: true
# usethis::edit_r_environ()
# TESTTHAT_CPUS=4
# file.edit("~/.energyRt/settings.R")
source("~/.energyRt/settings.R")
get_python_path()

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
    # region = NA,
    # year = NA,
    # slice = NA,
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
  olife = list(olife = 10)
)

# draw(TECH)
DEM <- newDemand(
  name = "DEM",
  commodity = "OUT",
  dem = data.frame(
    # region = NA,
    # year = NA,
    # slice = NA,
    dem = 1
  )
)

repo <- newRepository("repo", INP, OUT, SUP_INP, TECH, DEM)

mod_unit <- newModel(
  name = "UNIT",
  desc = "Unit test model",
  repo = repo,
  calendar = calendar_h10,
  region = "REG",
  horizon = newHorizon(2010:2050),
  discount = 0
)

# mod_unit@config@calendar
# scen_unit <- solve(mod_unit, solver = solver_options$glpk)
# vObjective <- getData(scen_unit, "vObjective", merge = TRUE)$value
vObjective <- 4510

test_that("ONE_glpk", {
  invisible({
    scen <- solve(mod_unit, solver = solver_options$glpk)
  })
  vObj <- getData(scen, "vObjective", merge = TRUE)$value
  expect_equal(vObjective, vObj)
})

# test_that("ONE_pyomo_highs", {
# not working (Windows)
#   invisible({
#     # scen <- solve(mod_unit, solver = solver_options$pyomo_cbc)
#     scen_ph <- interpolate(mod_unit)
#     pyomo_highs <- solver_options$pyomo_cbc
#     pyomo_highs$solver <- "highspy" # not working
#     # pyomo_highs$name <- "pyomo_highspy" # not working
#     scen_ph <- write_sc(scen_ph, solver = pyomo_highs)
#     scen_ph@misc$tmp.dir
#     solve_scenario(scen_ph, force = F, wait = F, read = T)
#     scen_ph_i <- read(scen_ph)
#   })
#   # scen <- solve(mod_unit, solver = solver_options$pyomo_glpk)
#   vObj <- getData(scen, "vObjective", merge = TRUE)$value
#   expect_equal(vObjective, vObj)
# })

test_that("ONE_pyomo_cbc", {
  invisible({
    scen <- solve(mod_unit, solver = solver_options$pyomo_cbc)
  })
  # scen <- solve(mod_unit, solver = solver_options$pyomo_glpk)
  vObj <- getData(scen, "vObjective", merge = TRUE)$value
  expect_equal(vObjective, vObj)
})

test_that("ONE_julia_highs", {
  invisible({
    scen <- solve(mod_unit, solver = solver_options$julia_highs)
  })
  # scen <- solve(mod_unit, solver = solver_options$pyomo_glpk)
  vObj <- getData(scen, "vObjective", merge = TRUE)$value
  expect_equal(vObjective, vObj)
})

test_that("ONE_gams_gdx_cplex", {
  invisible({
    scen <- solve(mod_unit, solver = solver_options$gams_gdx_cplex)
  })
  vObj <- getData(scen, "vObjective", merge = TRUE)$value
  expect_equal(vObjective, vObj)
})

