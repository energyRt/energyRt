write_model <- function(..., tmp.dir = NULL) {
  solver_solve(..., run = FALSE, tmp.dir = tmp.dir, write = TRUE)
}

solve_model <- function(tmp.dir, wait = TRUE, invisible = wait, ...) {
  solver_solve(scen = NULL, tmp.dir = tmp.dir, wait = wait, write = FALSE, invisible = invisible, ...)
}

solver_solve <- function(scen, ..., interpolate = FALSE, readresult = FALSE, 
                         write = TRUE, wait = TRUE, invisible = wait) { # - solves scen, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # solver = 'GAMS' use solver for model
  # tmp.dir - solver working directore
  # gamsCompileParameter, glpkCompileParameter, cbcCompileParameter - parameter for compiler (to cmd/sh)
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder before the run
  # show.output.on.console = FALSE & invisible = FALSE arg for command system
  # only.listing = FALSE (!depreciated?) generate only listing file (works for gams only)
  # readresult = TRUE read result
  # tmp.del delete results
  fix_path <- function(x) gsub('[\\/]+', '/', paste0(x, '/'))
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) {
    scen@solver <- list(lang = "GAMS")
  } else if (is.character(arg$solver)) {
    scen@solver <- list(lang = arg$solver)
  }
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  # if (is.null(arg$invisible)) arg$invisible <- FALSE
  arg$invisible <- invisible
  if (is.null(arg$tmp.del)) arg$tmp.del <- FALSE
  if (is.null(arg$readresult)) arg$readresult <- TRUE
  arg$write <- write
  arg$wait <- wait
  if (is.null(arg$write)) arg$write <- TRUE
  if (is.null(arg$run)) arg$run <- TRUE
  if (is.null(arg$JuMP)) arg$JuMP <- FALSE
  
  # if (is.null(arg$onefile)) arg$onefile <- FALSE
  if (!is.null(arg$dir.result)) {
    warning("solve_model: parameter `dir.result` is depreciated, use `tmp.dir` instead")
    if (is.null(arg$tmp.dir)) {
      arg$tmp.dir <- arg$dir.result
    } else {
      stop("check `dir.result` and `tmp.dir` - only one should be used")
    }
  } else {
    # temporary - will be depreciated
    arg$dir.result <- arg$tmp.dir
  }
  
  if (is.null(scen)) {
    if (interpolate | arg$write) {
      stop("scenario object is not provided")
    }
  } else {
    scen@misc$dir.result <- arg$dir.result
    tmp_name <- scen@name
  }
  arg$dir.result <- fix_path(arg$dir.result)
  arg$tmp.dir <- fix_path(arg$tmp.dir)
  scen@misc$dir.result <- fix_path(scen@misc$dir.result)
  
  if (is.null(arg$tmp.dir)) {
    arg$tmp.dir <- file.path(file.path(getwd(), "solwork"), paste(arg$solver, tmp_name, #scen@name, 
          format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()), sep = "_"))
  }
  arg$dir.result <- arg$tmp.dir
  
  # interpolate 
  if (interpolate) scen <- energyRt::interpolate(scen, ...)
  
  # Important miscs
  dir.create(arg$dir.result, recursive = TRUE, showWarnings = FALSE)
  if (arg$open.folder) shell.exec(arg$dir.result)

  if (arg$write) { 
    if (arg$echo) cat('Writing files: ')
    solver_solver_time <- proc.time()[3]
    if (scen@solver$lang == 'GAMS') {
      scen <- .solver_run_GAMS(arg, scen)
    } else if (scen@solver$lang %in% c('GLPK', 'CBC')) { 
      scen <- .solver_run_GLPK_CBC(arg, scen)
    } else if (any(grep("^pyomo", scen@solver$lang, ignore.case = TRUE))) {
      scen <- .solver_run_PYOMO(arg, scen)
    } else if (scen@solver$lang == 'JULIA') {
      scen <- .solver_run_JULIA(arg, scen)
    } else stop('Unknown solver ', scen@solver$lang) 
    if (arg$echo) { 
      cat(round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
      flush.console()
    }
  }
  .run_solve_model(arg, scen) # For all solvers
  
  if (readresult && arg$run) scen <- read_solution(scen)

  invisible(scen)
}
