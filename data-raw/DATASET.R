## Source this script to recreate the package data

source("data-raw/maps.R")

.modelCode <- list(
  GAMS = readLines("gams/energyRt.gms"),
  JuMP = readLines("julia/energyRt.jl"),
  JuMPOutput = readLines("julia/energyRtOutput.jl"),
  PYOMOConcrete = readLines("pyomo/energyRtConcrete.py"),
  PYOMOConcreteOutput = readLines("pyomo/energyRtConcreteOutput.py"),
  PYOMOAbstract = readLines("pyomo/energyRtAbstract.py"),
  PYOMOAbstractOutput = readLines("pyomo/energyRtAbstractOutput.py"),
  GLPK = readLines("glpk/energyRt.mod"),
  GAMS_output = readLines("gams/output.gms"),
  checkGAMS = readLines("gams/check.gms"),
  checkJULIA = readLines("julia/check.jl"),
  checkPYOMO = readLines("pyomo/check.py"),
  checkGLPK = readLines("glpk/check.mod")
)

# data, visible to user ####
# usethis::use_data(utopia_continent, utopia_island,
#                   utopia_honeycomb, utopia_squares,
#                   internal = FALSE, overwrite = TRUE)
usethis::use_data(model_structure, #.modelCode,
                  internal = FALSE, overwrite = TRUE)

# Internal data ####
.defVal <- yaml::read_yaml("data-raw/config_default_values.yml")
.defInt <- yaml::read_yaml(file = "data-raw/config_default_interpolation.yml")
.modInp <- yaml::read_yaml("data-raw/modInp.yml")

# all names of sets used in parameter@dimSet
.dimSets <- c(
  "tech", "techp", "dem", "sup", "weather", "acomm", "comm", "commp",
  "group", "region", "regionp", "src", "dst",
  "year", "yearp", "slice", "slicep", "stg", "expp", "imp", "trade"
)

.set_dimSets <- .set_set # drop after renaming in gams2x

# DefVal <- .defVal

# .set_set,
usethis::use_data(
  .dimSets,
  .modInp,
  .defInt,
  .defVal,
  # DefVal,
  .set_dimSets,
  .set_description,
  .parameter_set,
  .parameter_description,
  .variable_set,
  .variable_description,
  .variable_mapping,
  .equation_mapping,
  .equation_set,
  .equation_description,
  .equation_variable,
  .modelCode,
  internal = T, overwrite = TRUE
)
