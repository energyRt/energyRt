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
#' \dontrun{
#' en_install_julia_pkgs()
#' }
en_install_julia_pkgs <- function(pkgs = NULL, update = FALSE) {

  if (is.null(pkgs)) {
    pkgs <- c("JuMP", "HiGHS", "Cbc", "Clp", "RData", "RCall", "CodecBzip2",
              "Gadfly", "DataFrames", "CSV", "SQLite", "Dates")
  }

  # check if Julia is installed and available on the path
  
  jp <- get_julia_path() |> paste0("julia")
  if (!file.exists(jp)) {
    # try default path
    jp <- Sys.which("julia")
  }
  if (!file.exists(jp)) {
    stop("\nCannot locate julia executable on the path.", 
         "In Julia is not installed, download and install from https://julialang.org/downloads/")
  }
  
  message("Using Julia at ", jp, "\n")
  
  # create a temporary file to install Julia packages
  tmp_file <- tempfile("julia_install_", fileext = ".jl")
  # tmp <- file("tmp/julia_install.jl", open = "wt")
  tmp_con <- file(tmp_file, open = "wt")

  # write the script to install Julia packages
  writeLines("using Pkg", tmp_con)
  for (pkg in pkgs) {
    writeLines(paste0("Pkg.add(\"", pkg, "\")"), tmp_con, sep = "\n")
  }
  if (update) {
    writeLines("Pkg.update()", tmp_con)
  }
  close(tmp_con)

  # run Julia with the script
  system2(jp, c("--color=yes", tmp_file))

  # remove the temporary file
  unlink(tmp)

  return(invisible())
}

