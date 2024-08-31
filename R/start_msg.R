.onAttach <- function(...) {
  packageStartupMessage(
    glue::glue('energyRt version: {packageVersion("energyRt")}-beta ({packageDate("energyRt")})'),
    "\n"
    )

  # options
  # options(en.debug = FALSE)
  # options(en.verbose = TRUE)
  # options(en.progress_bar = TRUE)
  options(progressr.clear = FALSE)
  # options(en.scenarios_path = "scenarios/")

  # progressr::handlers("cli")
  # progressr::handlers("pbcol")
  # progressr::handlers("progress")
  # progressr::handlers(global = TRUE)

  # load global settings if exist
  if (file.exists("~/.energyRt.R")) {
    try({
      source("~/.energyRt.R")
    })
  }

  # environments
  .initiate_env <- function(e) {
    if (!exists(e, envir = .GlobalEnv)) {
      assign(e, new.env(parent = .GlobalEnv), envir = .GlobalEnv)
    }
  }
  .initiate_env(".scen")
  .initiate_env(".tmp")
}
