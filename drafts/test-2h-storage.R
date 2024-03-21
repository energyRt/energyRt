library(energyRt)
stopifnot(packageVersion("energyRt") >= "0.11.27")
library(tidyverse)
library(data.table)
# source("~/.ideea/settings.R")
source("~/.energyRt/settings.R")

h12 <- make_timetable(
  struct = list(
    ANNUAL = "ANNUAL",
    HOUR = paste0("h", formatC(0:11, width = 2, flag = "0")))
)

calendar_h12 <- newCalendar(h12, name = "h12")

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
  cap2act = nrow(calendar_h12@timetable)
)

DEM <- newDemand(
  name = "DEM",
  commodity = "OUT",
  dem = data.frame(
    # region = "REG",
    # year = 2010:2050,
    slice = h12$HOUR,
    dem = rep(c(rep(0, 2), rep(10, 2)), 3) # 2 hours period
    # dem = rep(c(rep(5, 6), rep(10, 6)), 1) # two levels
    # ========================================================
    # Cases when 2h storage is less efficient than 1h storage:
    # dem = c(rep(c(rep(0, 2), rep(10, 2)), 2), 0, 0, 0, 20) # peak (last hour)
    # dem = c(rep(c(rep(0, 2), rep(0, 2)), 2), 0, 0, 0, 12) # peak
  )
)
DEM@dem
plot(DEM@dem$dem, type = "s", col = "red", lwd = 2, ylab = "load", xlab = "hour")
points(DEM@dem$dem, col = "red", pch = 16)

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
  calendar = calendar_h12,
  region = "REG",
  horizon = newHorizon(2010),
  discount = 0
)

# set_default_solver(solver_options$glpk)
set_default_solver(solver_options$gams_gdx_cbc)
scen_stg <- solve(add(mod_unit, STG), name = "scen_stg", tmp.del = F)
getData(scen_stg, "vObjective")
getData(scen_stg, name_ = "NewCap", merge = TRUE, process = TRUE)

STG2H <- update(
  STG,
  cap2stg = 2, # MW * cap2stg = MWh
  af = list(
    cout.up = 1, # Inf by default
    cinp.up = 1  # Inf by default
  ),
  invcost = list(invcost = 20), # double energy capacity, double costs
  name = "STG2H",
  desc = "Storage with 2 hours capacity"
  )
scen_stg2h <- solve(add(mod_unit, STG2H), name = "scen_stg2h", tmp.del = F)
# scen_stg2h <- read_solution(scen_stg2h)
sns <- list(scen_stg, scen_stg2h)
getData(sns, "vObjective", merge = T)

scen_stg2h@modInp@parameters$pStorageCap2stg@data
scen_stg2h@modInp@parameters$pStorageCout@data
scen_stg2h@modInp@parameters$pStorageInvcost@data

# 2h storage has twice lower release capacity ("MW") than 1h storage
getData(sns, name_ = "NewCap", merge = TRUE, process = TRUE) |>
  select(-name) |>
  pivot_wider(names_from = "process")

getData(sns, name_ = "pStorageEac", merge = T, process = T)

# but the level of stored energy is the same in both cases
getData(sns, "vStorageStore", merge = TRUE,
        process = TRUE) |>
  select(-1) |>
  pivot_wider(names_from = "process")

getData(sns, "vStorageStore", merge = TRUE,
        process = TRUE) |>
  select(-1) |>
  pivot_wider(names_from = "process")

getData(sns, "vStorageInp", merge = TRUE,
        process = TRUE) |>
  select(-1) |>
  pivot_wider(names_from = "process")

getData(sns, "vStorageOut", merge = TRUE,
        process = TRUE) |>
  select(-1) |>
  pivot_wider(names_from = "process")

getData(sns, "vTechOut", merge = TRUE,
        process = TRUE) |>
  select(-name) |>
  pivot_wider(names_from = "scenario")
  # as.data.table()

vStorageCap <- getData(sns, "vStorageCap", merge = TRUE, process = TRUE) |>
  pivot_wider(names_from = "name")
vStorageCap

stg_op <- getData(sns, c("vStorageOut", "vStorageInp",
                         # "vStorageStore",
                         "vTechOut"
                         ),
                  process = T, merge = T) |>
  mutate(
    value = if_else(grepl("vStorageInp", name), -value, value)
  ) |>
  left_join(vStorageCap) |>
  mutate(
    val_per_cap = signif(value / vStorageCap, 2)
    ) |>
  as.data.table()
stg_op

DemOut <- getData(sns, c("pDemand", "vTechOut"), merge = T, process = T) |>
  as.data.table() |>
  select(-process) |>
  pivot_wider(names_from = name, values_fill = 0)

ggplot(stg_op) +
  geom_bar(aes(slice, value, fill = name), stat = "identity") +
  # geom_area(aes(as.factor(slice), value, fill = name)) +
  facet_wrap(~scenario, ncol = 1) +
  geom_step(aes(slice, pDemand, color = process, group = scenario),
            data = DemOut, color = "red", show.legend = F,
            inherit.aes = F, linewidth = 1) +
  geom_line(aes(slice, vTechOut, color = process, group = scenario),
            data = DemOut, color = "blue", linetype = 3, linewidth = 1) +
  theme_bw()

ggplot(stg_op) +
  geom_bar(aes(slice, val_per_cap, fill = name), stat = "identity") +
  # geom_area(aes(as.factor(slice), value, fill = name)) +
  facet_wrap(~scenario, ncol = 1) +
  # geom_step(aes(slice, value, group = scenario),
  #           data = vDemand, color = "red", inherit.aes = F, linewidth = 1) +
  theme_bw() +
  labs(title = "Storage operation per unit of storage (discharge) capacity")

stg_lev <- getData(sns,
                   c(
                     "vStorageOut", "vStorageInp",
                      "vStorageStore", "vTechOut"
                      ),
process = T, merge = T) |>
  mutate(
    value = if_else(grepl("vStorageInp", name), -value, value)
  ) |>
  left_join(vStorageCap) |>
  mutate(
    val_per_cap = signif(value / vStorageCap, 2)
  ) |>
  as.data.table()
stg_lev

ggplot(stg_lev) +
  geom_bar(aes(slice, value, fill = name), stat = "identity") +
  # geom_area(aes(as.factor(slice), value, fill = name)) +
  facet_wrap(~scenario, ncol = 1) +
  geom_step(aes(slice, pDemand, group = scenario),
            data = DemOut, color = "red", inherit.aes = F, linewidth = 1) +
  theme_bw()

ggplot(filter(stg_lev, grepl("Storage", name, ignore.case = T))) +
  geom_bar(aes(slice, val_per_cap, fill = name), stat = "identity") +
  # geom_area(aes(as.factor(slice), value, fill = name)) +
  facet_wrap(~scenario, ncol = 1, scales = "free_y") +
  # geom_step(aes(slice, value, group = scenario),
  #           data = vDemand, color = "red", inherit.aes = F, linewidth = 1) +
  theme_bw() +
  labs(title = "Storage level per unit of storage (discharge) capacity")

