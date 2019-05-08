
.sm_compile_model <- function(obj, 
   tmp.dir = NULL, tmp.del = FALSE, ...) {

   scn
}

#setMethod('solve', signature(obj = 'model'), energyRt:::.sm_compile_model)
solve.model <- function(obj, name = NULL, solver = "GAMS",
                        tmp.path = file.path(getwd(), "solwork"),
                        tmp.time = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
                        tmp.name = paste(solver, obj@name, name, tmp.time, sep = "_"), 
                        tmp.dir = file.path(tmp.path, tmp.name),
                        tmp.del = TRUE, ...) {

  # if (all(names(list(...)) != 'name')) {
  #   warning('Scenario name is not specified, using "DEFAULT" name')
  #   energyRt:::.sm_compile_model(obj, name = 'DEFAULT', ...)
  # } else energyRt:::.sm_compile_model(obj, ...)
  
  if (is.null(name)) {
    warning('Scenario name is not specified, using "DEFAULT" name')
    name = "DEFAULT"
  }
  
  if(is.null(tmp.dir) || tmp.dir == "") stop("Incorrect directory tmp.dir: ", tmp.del)
  
  # tmp.dir <- file.path(tmp.path, paste0(tmp.name))
  message("The solver working directory: ", tmp.dir)
  message("Starting time: ", Sys.time())
  energyRt:::.sm_compile_model(obj, name = name, tmp.dir = tmp.dir, tmp.del = tmp.del, ...)
}


