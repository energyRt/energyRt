write_model <- function(..., tmp.dir = NULL) {
  solver_solve(..., run = FALSE, tmp.dir = tmp.dir, write = TRUE)
}

solve_model <- function(tmp.dir = NULL, scen = NULL, solver = NULL, ...) {
  if (is.character(solver)) solver <- list(lang = solver)
  solv_par <- read.csv(paste0(.fix_path(tmp.dir), 'solver'), stringsAsFactors = FALSE)
  solver0 <- list()
  for (i in seq_len(nrow(solv_par))) {
    tmp <- solv_par[i, 'value']
    if (tmp %in% c('TRUE', 'FALSE')) tmp <- (tmp == 'TRUE')
    solver0[[solv_par[i, 'name']]] <- tmp
  }
  if (!is.null(scen) && !is.null(scen@solver))
    for (i in grep('^(inc[1-5]|files)$', names(scen@solver), value = TRUE, invert = TRUE)) 
      solver0[[i]] <- scen@solver[[i]]
  for (i in grep('^(inc[1-5]|files)$', names(solver), value = TRUE, invert = TRUE)) 
    solver0[[i]] <- solver[[i]]
  if (is.null(scen)) {
    scen = new('scenario')
  }
  solver_solve(scen = scen, run = TRUE, solver = solver0, tmp.dir = tmp.dir, write = FALSE, ...)
}

.fix_path <- function(x) gsub('[\\/]+', '/', paste0(x, '/'))

solver_solve <- function(scen, ..., interpolate = FALSE, readresult = FALSE, write = TRUE) { 
  # - solves scen, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
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
  # browser()
  arg <- list(...)
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) {
    scen@solver <- list(lang = "GAMS")
  } else if (is.character(arg$solver)) {
    scen@solver <- list(lang = arg$solver)
  } else if (is.list(arg$solver)) {
    scen@solver <- arg$solver
  }
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  # if (is.null(arg$invisible)) arg$invisible <- FALSE
  if (is.null(arg$tmp.del)) arg$tmp.del <- FALSE
  if (is.null(arg$readresult)) arg$readresult <- TRUE
  arg$write <- write
  if (is.null(arg$wait)) {
    if (is.null(scen@solver$wait)) {
      arg$wait <- TRUE
    } else arg$wait <- scen@solver$wait
  } else if (is.null(arg$invisible)) arg$invisible <- arg$wait
  scen@solver$wait <- arg$wait
  if (is.null(arg$invisible)) {
    if (is.null(scen@solver$invisible)) {
      arg$invisible <- TRUE
    } else arg$invisible <- scen@solver$invisible
  }
  scen@solver$invisible <- arg$invisible
  if (is.null(arg$run)) arg$run <- TRUE
  
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
      stop("scenario object is not found")
    }
  } else {
    scen@misc$dir.result <- arg$dir.result
    tmp_name <- scen@name
  }
  arg$dir.result <- .fix_path(arg$dir.result)
  arg$tmp.dir <- .fix_path(arg$tmp.dir)
  if (!is.null(scen)) scen@misc$dir.result <- .fix_path(scen@misc$dir.result)
  
  if (is.null(arg$tmp.dir)) {
    arg$tmp.dir <- .file.path(file.path(getwd(), "solwork"), paste(arg$solver$lang, tmp_name, #scen@name, 
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
      scen <- .write_model_GAMS(arg, scen)
    } else if (scen@solver$lang %in% c('GLPK', 'CBC')) { 
      scen <- .write_model_GLPK_CBC(arg, scen)
    } else if (any(grep("^pyomo", scen@solver$lang, ignore.case = TRUE))) {
      scen <- .write_model_PYOMO(arg, scen)
    } else if (scen@solver$lang == 'JULIA') {
      scen <- .write_model_JULIA(arg, scen)
    } else stop('Unknown solver ', scen@solver$lang) 
    
    ## Write solver parameter
    nn <- grep('^(inc[1-5]|files)$', names(scen@solver), value = TRUE, invert = TRUE)
    tmp <- data.frame(name = nn, 
              value = sapply(scen@solver[nn], function(x) paste0(c(x, recursive = TRUE), collapse = ' ')),
              stringsAsFactors = FALSE)
    write.csv(tmp, file = paste0(arg$tmp.dir, 'solver'), row.names=FALSE)
    
    if (arg$echo) { 
      cat(round(proc.time()[3] - solver_solver_time, 2), 's\n', sep = '')
      flush.console()
    }
  }
  .run_solve_model(arg, scen) # For all solvers
  
  if (readresult && arg$run) scen <- read_solution(scen)

  invisible(scen)
}
