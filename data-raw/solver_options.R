## Python/Pyomo
Pyomo <- list(
  name = "pyomo",
  lang = "PYOMO",
  export_format = "SQLite",
  # solver = "cplex"
  # solver = "glpk"
  solver = "cbc"
)

pyomo_cbc <- Pyomo
pyomo_cbc$name <- "pyomo_cbc"


pyomo_cplex <- Pyomo
pyomo_cplex$name <- "pyomo_cplex"
pyomo_cplex$solver <- "cplex"

pyomo_cplex_barrier <- pyomo_cplex
pyomo_cplex_barrier$name <- "pyomo_cplex_barrier"

pyomo_cbc <- Pyomo; pyomo_cbc$name <- "pyomo_cbc"

pyomo_cplex <- Pyomo
pyomo_cplex$solver <- "cplex"; pyomo_cplex$name <- "pyomo_cplex"

pyomo_cplex_barrier <- pyomo_cplex;
pyomo_cplex_barrier$name <- "pyomo_cplex_barrier"
pyomo_cplex_barrier$inc4 <- {
"opt.options['lpmethod'] = 4
opt.options['solutiontype'] = 2"}

pyomo_glpk <- Pyomo
pyomo_glpk$name <- "pyomo_glpk"
pyomo_glpk$solver <- "glpk"


## Julia/JuMP ####
julia_cbc <- list(
  name = "julia_cbc",
  lang = "JuMP",
  solver = "Cbc"
)

julia_glpk <- list(
  name = "julia_glpk",
  lang = "JuMP",
  solver = "GLPK"
)

julia_cplex <- list(
  name = "julia_cplex",
  lang = "JuMP",
  solver = "CPLEX"
)

julia_cplex_barrier <- julia_cplex
julia_cplex_barrier$name <- "julia_cplex_barrier"
julia_cplex_barrier$inc3 <- {'
set_optimizer_attribute(model, "CPXPARAM_LPMethod", 4) # barrier CPX_ALG_BARRIER
set_optimizer_attribute(model, "CPXPARAM_SolutionType", 2) # CPX_NONBASIC_SOLN'}

julia_highs <- list(
  name = "julia_highs",
  lang = "JuMP",
  solver = "HiGHS"
)


julia_highs_barrier <- julia_highs
julia_highs_barrier$name <- "julia_highs_barrier"
julia_highs_barrier$inc3 <- c({
'# HiGHS options in JuMP/Julia
# Uncomment options to use
set_optimizer_attribute(model, "presolve", "on")
# set_attribute(model, "time_limit", 3600.0)

# "Barrier" method
set_optimizer_attribute(model, "solver", "ipm") # barrier "Interior Point Method"
# set_optimizer_attribute(model, "ipm_optimality_tolerance", 1e-5) #
set_optimizer_attribute(model, "run_crossover", "off") # polishing the solution
'
})

julia_highs_simplex <- julia_highs
julia_highs_simplex$name <- "julia_highs_simplex"
julia_highs_simplex$inc3 <- c({
'# HiGHS options in JuMP/Julia
# Uncomment options to use
set_optimizer_attribute(model, "presolve", "on")
# set_attribute(model, "time_limit", 3600.0)

# Simplex
set_attribute(model, "solver", "simplex")
#set_attribute(model, "simplex_strategy", "on")
'})

julia_highs_parallel <- julia_highs
julia_highs_parallel$name <- "julia_highs_parallel"
julia_highs_parallel$inc3 <- c({
'# HiGHS options in JuMP/Julia
# Uncomment options to use
set_optimizer_attribute(model, "presolve", "on")
# set_attribute(model, "time_limit", 3600.0)

# Parallel Dual simplex
set_attribute(model, "solver", "choose")
set_attribute(model, "parallel", "on")
set_attribute(model, "threads", 8)
set_attribute(model, "simplex_max_concurrency", 8)
'})


## GLPK
glpk <- list(name = "glpk", lang = "GLPK")

## GAMS
# gams_path <- options::opt("gams_path")
# gams_cmd_line <- file.path(gams_path, "gams.exe energyRt.gms")

gams_cplex <- list(
  name = "gams_cplex",
  lang = "GAMS",
  solver = "CPLEX"
)

gams_gdx_cplex <- list(
  name = "gams_gdx_cplex",
  lang = "GAMS",
  import_format = "GDX",
  export_format = "GDX",
  solver = "CPLEX"
)

gams_gdx_cplex_barrier <- gams_gdx_cplex
gams_gdx_cplex_barrier$name <- "gams_gdx_cplex_barrier"
gams_gdx_cplex_barrier$inc3 <- {"
*energyRt.holdfixed = 1;
*energyRt.dictfile = 0;
*option solvelink = 5;
*option InteractiveSolver = 1;
option iterlim = 1e9;
option reslim = 1e7;
option threads = 0;
*option LP = CPLEX;
energyRt.OptFile = 1;
*option savepoint = 1;
*option bRatio = 0;
*execute_loadpoint 'energyRt_p';

$onecho > cplex.opt
*interactive 1
*advind 0
* predual 1
* BarStartAlg 4
* tuningtilim 2400
*aggcutlim 3
*aggfill 10
*aggind 25

parallelmode -1
threads -1
lpmethod 4
*reinv 1e4

*preind: turn presolver on/off (1/0)
*preind 0
*scaind 1
*scaind -1
*predual -1
solutiontype 2

*printoptions 1
*names no
*freegamsmodel 1
*memoryemphasis 1

*barcolnz 5
*numericalemphasis 1
*barepcomp 1e-5
*barstartalg 2
*predual 1
*baralg 1

*epopt 1e-1
*eprhs 1e-1
*dpriind 2
*ppriind 3
*perind 1
*epmrk 0.1

*tuningdisplay 2
*simdisplay 2
*bardisplay 2

*CraInd 0

$offecho
"}


gams_gdx_cplex_parallel <- gams_gdx_cplex
gams_gdx_cplex_parallel$name <- "gams_gdx_cplex_parallel"
gams_gdx_cplex_parallel$inc3 <- {
"
*energyRt.holdfixed = 1;
*energyRt.dictfile = 0;
option solvelink = 0;
*option InteractiveSolver = 1;
option iterlim = 1e9;
option reslim = 1e7;
*option threads = 0;
*option solvelink = 5;
*option LP = CPLEX;
energyRt.OptFile = 1;
*option savepoint = 1;
*option bRatio = 0;
*execute_loadpoint 'energyRt_p';
$onecho > cplex.opt
*interactive 1
* advind 0
* predual 1
* BarStartAlg 4
* tuningtilim 2400
*aggcutlim 3
*aggfill 10
*aggind 25
*bardisplay 2
parallelmode -1
lpmethod 6
*printoptions 1
*names no
*freegamsmodel 1
*memoryemphasis 1
threads -1
*barepcomp 1e-5
*scaind 1
*predual -1
*solutiontype 2

*epopt 1e-1
*eprhs 1e-1
*barepcomp 1e-5
*epmrk 0.1

$offecho
*$exit
"} # GAMS options ####

gams_cbc <- list(
  name = "gams_cbc",
  lang = "GAMS",
  solver = "CBC"
)

gams_gdx_cbc <- list(
  name = "gams_gdx_cbc",
  lang = "GAMS",
  import_format = "GDX",
  export_format = "GDX",
  solver = "CBC"
)

solver_options <- list(
  # GLPK
  glpk = glpk,
  # Python/Pyomo
  pyomo_cbc = pyomo_cbc,
  pyomo_cplex = pyomo_cplex,
  pyomo_cplex_barrier = pyomo_cplex_barrier,
  pyomo_glpk = pyomo_glpk,
  # julia
  julia_cbc = julia_cbc,
  julia_cplex = julia_cplex,
  julia_cplex_barrier = julia_cplex_barrier,
  julia_highs = julia_highs,
  julia_highs_barrier = julia_highs_barrier,
  julia_glpk = julia_glpk,
  julia_highs_simplex = julia_highs_simplex,
  julia_highs_parallel = julia_highs_parallel,
  # GAMS
  gams_csv_cplex = gams_cplex,
  gams_gdx_cplex = gams_gdx_cplex,
  gams_gdx_cplex_barrier = gams_gdx_cplex_barrier,
  gams_gdx_cplex_parallel = gams_gdx_cplex_parallel,
  gams_csv_cbc = gams_cbc,
  gams_gdx_cbc = gams_gdx_cbc
)

usethis::use_data(solver_options, overwrite = TRUE)

## Solver options - DRAFT
# solver_options <- function(
#     lang = "Pyomo",
#     export_format = "SQLite",
#     solver = "cbc",
#     algorithm = NULL,
#     inc1 = NULL,
#     inc2 = NULL,
#     inc3 = NULL,
#     inc4 = NULL,
#     inc5 = NULL
#   ) {
#
#   options <- list(
#     lang = lang,
#     export_format = export_format,
#     solver = solver,
#     inc1 = inc1,
#     inc2 = inc2,
#     inc3 = inc3,
#     inc4 = inc4,
#     inc5 = inc5
#   )
#
#   if (lang == "Pyomo") {
#     # Pyomo
#   } else if (lang == "Julia") {
#     # Julia
#   } else if (lang == "GLPK") {
#     # GLPK
#   } else if (lang == "GAMS") {
#     # GAMS
#   } else {
#     stop("Unknown language")
#   }
# }
