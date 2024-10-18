# Functions t install external packages and libraries

#' Install Julia packages
#'
#' @param pkgs A character vector of Julia packages to install. The default is
#'  \code{c("JuMP", "HiGHS", "Cbc", "Clp", "RData", "RCall", "CodecBzip2",
#'  "Gadfly", "DataFrames", "CSV", "SQLite", "Dates")}.
#'  If you have pre-installed CPLEX or Gurobi, you can add them to the list.
#'
#' @return NULL if the completion is successful. The verification of the installation is
#' done by the user or by the function \code{en_check_julia()}.
#' @export
#'
#' @examples
en_install_julia_pkgs <- function(pkgs = NULL, update = FALSE) {

  if (is.null(pkgs)) {
    pkgs <- c("JuMP", "HiGHS", "Cbc", "Clp", "RData", "RCall", "CodecBzip2",
              "Gadfly", "DataFrames", "CSV", "SQLite", "Dates")
  }

  # check if Julia is installed
  if (!file.exists(Sys.which("julia"))) {
    stop("Julia is not installed. Please install Julia from https://julialang.org/downloads/")
  }

  # create a temporary file to install Julia packages
  tmp <- tempfile()

  # write the script to install Julia packages
  for (pkg in pkgs) {
    writeLines(paste0("using Pkg; Pkg.add(\"", pkg, "\")"), tmp)
  }
  if (update) {
    writeLines("using Pkg; Pkg.update()", tmp)
  }

  # run Julia with the script
  system2("julia", c("--color=yes", tmp))

  # remove the temporary file
  unlink(tmp)

  return(invisible())
}

