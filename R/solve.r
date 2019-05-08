solve.model <- function(obj, name = NULL, solver = "GAMS",
                        tmp.path = file.path(getwd(), "solwork"),
                        tmp.time = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
                        tmp.name = paste(solver, obj@name, name, tmp.time, sep = "_"), 
                        tmp.dir = file.path(tmp.path, tmp.name),
                        tmp.del = TRUE, ...) {

  
  arg <- list()
  solve.time.begin <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE
  
  if (is.null(name)) {
    warning('Scenario name is not specified, using "DEFAULT" name')
    name = "DEFAULT"
  }
  if(is.null(tmp.dir) || tmp.dir == "") stop("Incorrect directory tmp.dir: ", tmp.del)
  if (is.null(arg$echo)) {
    message("The solver working directory: ", tmp.dir)
    message("Starting time: ", Sys.time())
  }
  scenario = interpolate(obj, name = name)
  scenario = solver_solve(scenario, name = name, dir.result = tmp.dir, tmp.del = tmp.del, ..., readresult = TRUE)
  if (tmp.del) unlink(tmp.dir, recursive = TRUE)
  invisible(scenario)
}

