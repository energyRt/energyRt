#' @include docs.R
# @eval options::as_roxygen_docs()

# set default rounding in data.table for 'unique' and 'duplicated' functions
data.table::setNumericRounding(2)

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
  options::opt("solver")
}

#' @export
set_default_solver <- function(solver) {
  options::opt_set("solver", solver)
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

# # GLPK ####
options::define_option(
  "glpk_path",
  desc = "Path to GLPK executable.",
  default = NULL,
  option_name = "glpk_path",
  envvar_name = "glpk_path"
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

# scenarios_path ####
options::define_option(
  "scenarios_path",
  desc = "Path to scenarios directory.",
  default = "scenarios/",
  option_name = "scenarios_path"
)

#' @export
get_scenarios_path <- function() {
  options::opt("scenarios_path")
}

#' @export
isVerbose <- function(level = 1) {
  options::opt("verbose", env = "energyRt") >= level
}

#' @export
set_option <- function(name, value) {
  options::opt_set(name, value, env = "energyRt")
}

#' @export
get_option <- function(name, default = NULL) {
  options::opt(name, default = default, env = "energyRt")
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

#' @export
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

#' @export
which_registry <- function() {
  options::opt("default_registry")
}
# which_registry <- get_default_registry


#' Returns the current registry object.
#'
#' @return The current registry object.
#' @export
get_registry <- function() {
  r <- which_registry()
  if (exists(r$name, envir = get(r$env))) {
    rg <- get(r$name, envir = get(r$env))
  } else {
    rg <- newRegistry(name = r$name, registry_env = r$env)
    # return(NULL)
  }
  rg
  # get(r$name, envir = get(r$env))
}

# save global settings
# sys_dir <- "~/.energyRt"
# dir.create(sys_dir)
# dir.exists(sys_dir)
# write_lines(c(
#   'energyRt::set_gams_path("...")',
#   'energyRt::set_gdxlib_path("...")'
# ), file = fp(sys_dir, "settings.R"))
