# A model with three regions, interregional trade, and a single good
library(energyRt)
library(dplyr)
library(ggplot2)
library(data.table)

# Names of the regions
reg_names <- paste0("R", 1:3)
reg_names
nreg <- length(reg_names)

# time slices, timetable, calendar
# timetable_m12_h24 <- energyRt::make_timetable(
#   list(
#     ANNUAL = "ANNUAL",
#     MONTH = paste0("m", formatC(1:12, width = 2, flag = "0")),
#     HOUR = paste0("h", formatC(1:24, width = 2, flag = "0"))
#   )
# )
#
# calendar_m12_h24 <- newCalendar(
#   name = "CALENDAR_M12_H24",
#   timetable = timetable_m12_h24
# )

N_DAYS <- nreg
N_HOURS <- 4

timetable_d_h <- energyRt::make_timetable(
  list(
    YDAY = paste0("d", formatC(1:N_DAYS, width = 3, flag = "0")),
    HOUR = paste0("h", formatC(1:N_HOURS, width = 2, flag = "0"))
  )
)

calendar_d_h <- newCalendar(
  name = "CALENDAR_D_H",
  timetable = timetable_d_h
)

mod_calendar <- calendar_d_h

# Commodities
INP <- newCommodity("INP", timeframe = "HOUR", emis = list(comm = "EMIS", emis = 1))
# INP <- newCommodity("INP", timeframe = "ANNUAL", emis = list(comm = "EMIS", emis = 1))
OUT <- newCommodity("OUT", timeframe = "HOUR")
EMIS <- newCommodity("EMIS", timeframe = "HOUR")

# Supply
SUP_INP <- newSupply(
  name = "SUP_INP",
  commodity = "INP",
  availability = data.frame(
    region = reg_names,
    # cost = c(1, 2, 3)
    cost = 1
  )
)

# Demand

DEM_OUT <- newDemand(
  name = "DEM_OUT",
  commodity = "OUT",
  dem = mutate(
    expand_grid(
    region = reg_names,
    slice = mod_calendar@timeframes$HOUR
  ),
  dem = 1
  )
)

# technology
TECH <- newTechnology(
  name = "TECH",
  input = list(comm = "INP"),
  output = list(comm = "OUT"),
  invcost = list(invcost = 100),
  fixom = list(fixom = 1),
  varom = list(varom = .1),
  olife = list(olife = 100),
  af = list(af.fx = 1),
  weather = list(weather = "WEA", waf.fx = 1),
  cap2act = N_DAYS * N_HOURS,
)

TECH2 <- TECH |>
  update(name = "TECH2") |>
  update(input = list(comm = "INP", combustion = 0),
         invcost = list(invcost = 200),
         varom = list(varom = .2))

# Weather factors
wea_tbl <- expand_grid(
  region = reg_names,
  slice = mod_calendar@timeframes$HOUR
) |>
  mutate(
    wval = if_else(
      as.integer(str_extract(slice, "[0-9]+")) ==
        as.integer(str_extract(region, "[0-9]+")),
      1, 0)
    # wea = rep(
    #   rep(
    #     c(1, 0),
    #     each = N_HOURS / 2
    #   ), N_DAYS
    # )
  ) |>
  as.data.table()
wea_tbl


WEA <- newWeather(
  name = "WEA",
  weather = wea_tbl,
  timeframe = "HOUR"
)

# Trade
trd_mat <- expand_grid(
  from = reg_names,
  to = reg_names
) |>
  filter(from != to) |>
  as.data.table()

TRADE <- newTrade(
  name = "TRADE",
  commodity = "OUT",
  routes = data.frame(
    dst = trd_mat$to,
    src = trd_mat$from
  ),
  # trade = data.frame()
  cap2act = N_DAYS * N_HOURS,
  olife = list(olife = 100),
  invcost = data.frame(region = reg_names, invcost = 100/nreg)
)

# Model
repo <- newRepository(
  name = "three-region-model-repo",
  # commodities
  INP, OUT, EMIS,
  # Supply
  SUP_INP,
  # Demand
  DEM_OUT,
  # Technology
  TECH, TECH2,
  # Weather
  WEA,
  # Trade
  TRADE
)
summary(repo)

mod <- newModel(
  name = "three-region-model",
  region = reg_names,
  repository = repo,
  calendar = mod_calendar,
  discount = 0,
  horizon = newHorizon(2030)
)

getHorizon(mod)

# Solve
scen <- solve(mod, tmp.del = FALSE)

# Subset calendar
sub_timetable <- mod_calendar@timetable |>
  filter(grepl("h01|h03", HOUR))

sub_calendar <- newCalendar(
  name = "SUB_CALENDAR",
  timetable = sub_timetable,
  year_fraction = sum(sub_timetable$share)
)

scen_sub <- solve(mod, calendar = sub_calendar, tmp.del = FALSE)

# Results
sns <- list(FULL = scen, SUB = scen_sub)

getData(sns, "vObjective", merge = TRUE)
getData(sns, name_ = "vEmsFuel", parameters = F, merge = TRUE)
getData(sns, name_ = "vBalance", comm = "EMIS", merge = TRUE) |>
  group_by(scenario, year, comm) |>
  summarise(value = sum(value))

getData(sns, "vTradeCap", merge = TRUE)
getData(sns, "vTradeIr", merge = TRUE) |>
  pivot_wider(names_from = scenario) |>
  as.data.table()

