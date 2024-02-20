# usethis::use_package("registry")
# Registry is class for storing and managing records of scenarios, models, and repositories. 
# Unless specified, the registry is stored in the global environment. It has entries of objects located either in the global environment (.GlobalEnv), default environment to store scenario or model objects (.scen), or stored in the file system.
# The 'registry' objects are lightweight and can be saved on the disk and loaded back.

#' Create a new registry object.
#'
#' @param class character, type of the classes to be stored in the registry.
#' @param name character, name of the registry object.
#' @param registry_env character, environment to store the registry object.
#' @param store_env character, environment to store the objects.
#'
#' @return
#' @export
#'
#' @examples
newRegistry <- function(
    class = c("scenario", "model", "repository"),
    name = NULL,
    registry_env = ".GlobalEnv",
    store_env = ".scen"
  ) {
  # inventory
  book <- registry::registry()
  # key values:
  book$set_field("name", "character", is_mandatory = TRUE, is_key = TRUE)
  book$set_field("class", "character", is_mandatory = TRUE, is_key = TRUE)
  book$set_field("project", "character", is_mandatory = FALSE, is_key = FALSE)
  # user/system specific:
  book$set_field("path", "character", is_mandatory = FALSE, is_key = FALSE)
  # entry specific:
  book$set_field("memo", "character", is_mandatory = FALSE, is_key = FALSE)
  book$set_field("datetime", class(Sys.time()), is_mandatory = FALSE, 
                 is_key = FALSE)
  book$set_field("user", "character")
  book$set_field("system", "character")
  # book$set_field("path", "character")
  # book$set_field("registry_env", "character", default = env)
  book$set_field("env", "character", default = store_env)
  if (!is.null(name)) {
    if (exists(name, envir = get(registry_env))) {
      stop(
        "Registry already exists in the environment.\n",
        "Remove it rm(", name, ") first or use a different name."
      )
    }
    assign(name, book, envir = get(registry_env))
    cat("Registry ", name, " created.\n")
  }
  return(invisible(book))
}

#' Register an object in the registry.
#'
#' @param obj object to be registered.
#' @param registry registry object to add the entry.
#' @param name character, name of the object.
#' @param project character, optional, the name of the project.
#' @param path character, optional path to the object's 'onDisk' directory.
#' @param memo character, optional short note about the object.
#' @param datetime timestamp, optional, date and time of the registration.
#' @param user character, optional, user who registered the object.
#' @param system character, optional, system where the object is registered.
#' @param ...  (reserved for future use).
#' @param env character, environment where the object is stored.
#' @param replace logical, if TRUE, replace the existing entry.
#'
#' @return
#' @export
#'
#' @examples
register <- function(
    obj,
    registry,
    # registry = get(".scen$registry"),
    # class = NULL,
    name = obj@name,
    project = "",
    path = "",
    # updatable
    memo = "",
    datetime = lubridate::now(tzone = "UTC"),
    user = Sys.info()["user"],
    system = Sys.info()["sysname"],
    ...,
    env = obj@misc$env,
    replace = FALSE
    # update = TRUE, 
    # history = FALSE
    ) {
  browser()
  
  reg_exist <- registry$get_entry(
    name = name,
    project = project,
    path = path,
    ...
  )
  
  if (!is.null(reg_exist)) {
    if (replace) {
      registry$remove_entry(name)
    # } else if (history) {
      # update fields:
    } else {
      stop(
        "Object ", name, " already exists in the registry.\n",
        "Use replace = TRUE to replace."
      )
    }
  }
  
  registry$set_entry(
    name = obj@name,
    class = class(obj),
    project = project,
    path = path,
    memo = memo,
    datetime = datetime,
    user = user,
    system = system,
    env = env
    # ...
  )
}

#' @export
getScenario <- function(name, registry = get_registry(), ...) {
  registry[[name]]
}

#' @export
get_entry <- function(name, registry = get_registry(), ...) {
  registry$get_entry(name, ...)
}

#' @export
get_entry_object <- function(name, registry = get_registry(), ...) {
  re <- registry$get_entry(name, ...)
  get(re$name, envir = re$env)[[name]]
}


if (F) {
  ls(pattern = "scen_")
  # set_scenario_path("scenarios")
  get_scenarios_dir()

  # SCEN <- newRegistry(class = "scenario")
  newRegistry(name = "SCEN")
  rm(SCEN)
  .scen |> ls()
  newRegistry(name = "SCEN")
  set_default_registry("SCEN", ".GlobalEnv")
  which_registry()
  get_registry()
  
  SCEN$get_fields() |> names()
  use_registry("SCEN")
  which_registry()
  
  register(scen_BASE, SCEN)
  SCEN$get_entries("BASE")
  SCEN$n_of_entries()
  SCEN$has_entry("BASE")
  
  SCEN[["BASE"]]
  getScenario("BASE")

  newScenario("TEST", path = "scenarios")
  getScenario("TEST")
  newScenario("TEST", path = "scenarios", registry = SCEN)
  newScenario("TEST", path = "scenarios", registry = SCEN, replace = TRUE)
  SCEN$get_entries("TEST")
  SCEN$n_of_entries()
  SCEN$get_entries()
  SCEN[["TEST"]]
  register(scen_TEST, SCEN)
  
}

