# @eval options::as_roxygen_docs()

# solver ####
#' @export
options::define_option(
  "solver",
  desc = "Default solver to use in solving models.",
  default = list(
    name = "glpk",
    lang = "glpk"
  ),
  option_name = "solver"
  # envvar_name = "SOLVER"
)

#' @export
get_default_solver <- function() {
  options::get("solver")
}

#' @export
set_default_solver <- function(solver) {
  options::set("solver", solver)
}

# GAMS ####
options::define_option(
  "gams_path",
  desc = "Path to GAMS executable.",
  default = NULL,
  option_name = "gams_path",
  envvar_name = "GAMS_PATH"
)

# gdxlib ####
options::define_option(
  "gdxlib_path",
  desc = "Path to GDX library.",
  default = NULL,
  option_name = "gdxlib_path",
  envvar_name = "GDXLIB_PATH"
)

# Python ####
options::define_option(
  "python_path",
  desc = "Path to Python executable.",
  default = NULL,
  option_name = "python_path",
  envvar_name = "PYTHON_PATH"
)

# Julia ####
options::define_option(
  "julia_path",
  desc = "Path to Julia executable.",
  default = NULL,
  option_name = "julia_path",
  envvar_name = "JULIA_PATH"
)

# verbose ####
options::define_option(
  "verbose",
  desc = "Verbosity level.",
  default = 0,
  option_name = "verbose"
  # envvar_name = "VERBOSE"
)

# debug ####
options::define_option(
  "debug",
  desc = "Debug level.",
  default = 0,
  option_name = "debug"
  # envvar_name = "DEBUG"
)

# progress_bar ####
options::define_option(
  "progress_bar",
  desc = "Progress bar.",
  default = TRUE,
  option_name = "progress_bar"
  # envvar_name = "PROGRESS_BAR"
)

# scenarios_dir ####
options::define_option(
  "scenarios_dir",
  desc = "Directory to store scenarios.",
  default = "scenarios/",
  option_name = "scenarios_dir"
  # envvar_name = "SCENARIOS_DIR"
)

get_scenarios_dir <- function() {
  options::opt("scenarios_dir")
}

isVerbose <- function(level = 1) {
  options::opt("verbose", env = "energyRt") >= level
}

set_option <- function(name, value) {
  options::set_opt(name, value, env = "energyRt")
}

get_option <- function(name) {
  options::get_opt(name, env = "energyRt")
}

# default_registry ####
options::define_option(
  "default_registry",
  desc = "Default registry to use for repositories, models, scenarios.",
  default = list(
    name = "registry",
    env = ".scen"
  ),
  option_name = "default_registry"
  # envvar_name = "DEFAULT_REGISTRY"
)

set_default_registry <- function(
    obj_name = "registry", 
    env_name = ".scen"
  ) {
    registry = list(name = obj_name, env = env_name)
  options::opt_set("default_registry", registry)
}
use_registry <- set_default_registry
set_registry <- set_default_registry

# set_default_registry.registry <- function(registry) {
#   obj_name <- deparse(substitute(registry))
#   set_default_registry(obj_name, registry)
# }

get_default_registry <- function() {
  options::opt("default_registry")
}
which_registry <- get_default_registry

get_registry <- function() {
  r <- which_registry()
  get(r$name, envir = get(r$env))
}

