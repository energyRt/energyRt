.onAttach <- function(...) {
  packageStartupMessage(
"energyRt version: 0.11.19-dev (2024-02-21)\n",
"======================== WARNING ==========================\n",
"The package is currently in preparation for its first release
and publication on CRAN. The names, behavior, and meaning of
functions, methods, and parameters are being reviewed and
might be changed to improve the readability and
transparency of the code, consistency with other libraries,
functionality and features of the final product.
Thanks for testing and your patience.
Please report bugs, issues or suggest improvements here:
https://github.com/energyRt/energyRt/issues\n",
"-----------------------------------------------------------\n",
"  Change log: \n",
"  https://github.com/energyRt/energyRt/blob/dev/dev/changelog.txt\n",
"==========================================================="
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

  # environments
  .initiate_env <- function(e) {
    if (!exists(e, envir = .GlobalEnv)) {
      assign(e, new.env(parent = .GlobalEnv), envir = .GlobalEnv)
    }
  }
  .initiate_env(".scen")
  .initiate_env(".tmp")
}
