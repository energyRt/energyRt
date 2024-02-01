.onAttach <- function(...) {
  packageStartupMessage(
"energyRt version: 0.11.08-dev (2024-01-31)\n",
"======================== WARNING ==========================\n",
"The package is currently in preparation for its first release
and publication on CRAN. The names, behavior, meaning of
functions, methods, parameters are being reviewed and
may be changed in order to improve the readability and
transparency of the code, consistency with other libraries,
functionality and features of the final product.
Thanks for testing and for your patience.
Please report bugs, issues or suggest improvements here:
    https://github.com/energyRt/energyRt/issues\n",
"-----------------------------------------------------------\n",
'For older models install `0.01.25.9000` (2022-12-05) version:\n',
'remotes::install_github("energyRt/energyRt", \n',
'                        ref = "master-snapshot-2022-dec")\n',
"===========================================================")

  # options
  options(en.debug = FALSE)
  options(en.verbose = TRUE)
  options(en.progress_bar = TRUE)
  options(progressr.clear = FALSE)
  options(en.scenarios_dir = "scenarios/")

  # progressr::handlers("cli")
  # progressr::handlers("pbcol")
  # progressr::handlers("progress")
  # progressr::handlers(global = TRUE)

  # environments
  .initiate_env <- function(e) {
    if (!exists(e, envir = .GlobalEnv)) {
      assign(e, new.env(parent = .GlobalEnv), envir = .GlobalEnv)
    }
  }
  .initiate_env(".scen")
  .initiate_env(".tmp")

}

