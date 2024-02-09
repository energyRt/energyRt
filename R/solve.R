# Solve model and scenario objects ####
# Functions and methods. Multiple methods in this file aim adopting the
# generic `base::solve(a, b, ...)` method to `solve(obj, name, ...)`

#' Functions and methods to solve model and scenario objects
#'
#' The function interpolates model, writes the script in a directory, runs the external software to solve the model, reads the solution results, and returns a scenario object with the solution.
#'
#' @param obj model object
#' @param name character name of scenario to return
#' @param solver a character or list with solver settings
#' @param tmp.path
#' @param tmp.timestamp
#' @param tmp.name
#' @param tmp.dir
#' @param tmp.del
#' @param ...
#'
#' @seealso [read_solution()]
#'
#' @rdname solve
#' @return
#' @export
solve_model <- function(
    obj,
    name = paste("scen", obj@name, sep = "_"),
    solver = NULL,
    # tmp.path = file.path(getwd(), "/solwork"),
    # tmp.time = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
    # tmp.name = paste(solver, obj@name, name, tmp.time, sep = "_"),
    tmp.dir = NULL,
    tmp.del = TRUE,
    ...) {
  # browser()
  arg <- list(...)
  # tmp.path
  if (!is.null(arg[["tmp.del"]])) {
    tmp.path <- arg[["tmp.path"]]; arg[["tmp.path"]] <- NULL
    tmp.path <- gsub("[\\/]+", "/", tmp.path)
  }
  # tmp.path
  if (!is.null(arg[["tmp.path"]])) {
    tmp.path <- arg[["tmp.path"]]; arg[["tmp.path"]] <- NULL
    tmp.path <- gsub("[\\/]+", "/", tmp.path)
  } else {
    tmp.path = file.path(getwd(), "/solwork")
  }
  # tmp.timestamp
  if (!is.null(arg[["tmp.timestamp"]])) {
    if (!is.logical(arg[["tmp.timestamp"]])) {
      tmp.timestamp <- arg[["tmp.timestamp"]]; arg[["tmp.timestamp"]] <- NULL
    } else if (arg[["tmp.timestamp"]]) {
      tmp.timestamp = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = "UTC")
      arg[["tmp.timestamp"]] <- NULL
    } else {
      tmp.timestamp <- NULL; arg[["tmp.timestamp"]] <- NULL
    }
  } else {
    if (tmp.del) {
      tmp.timestamp <- format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = "UTC")
    } else {
      tmp.timestamp <- NULL
    }
  }
  # tmp.name
  if (!is.null(arg[["tmp.name"]])) {
    tmp.name <- arg[["tmp.name"]]; arg[["tmp.name"]] <- NULL
    # tmp.name <- gsub("[\\/]+", "/", tmp.path)
  } else {
    tmp.name <- obj@name
    paste(obj@name, name, sep = "_")
    if (!is.null(tmp.timestamp)) {
      tmp.name <- paste(tmp.name, tmp.timestamp, sep = "_")
    }
  }
  # tmp.dir
  if (is.null(tmp.dir)) {
    if (!is.null(arg[["tmp.dir"]])) {
      tmp.dir <- arg[["tmp.dir"]]; arg[["tmp.dir"]] <- NULL
    } else {
      if (is.null(tmp.name) | tmp.name == "") {
        stop('Scenario directory name cannot be NULL or ""')
      }
      tmp.dir <- file.path(tmp.path, tmp.name)
    }
  }

  # tmp.dir = file.path(tmp.path, tmp.name),
  # tmp.path <- gsub("[\\/]+", "/", tmp.path)
  tmp.dir <- gsub("[\\/]+", "/", tmp.dir)
  solve.time.start <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE

  if (is.null(name)) {
    warning('Scenario name is not specified, using "DEFAULT" name')
    name <- "DEFAULT"
  }
  if (is.null(tmp.dir) || tmp.dir == "") stop("Incorrect directory tmp.dir: ", tmp.del)
  if (arg$echo) {
    tmp.msg <- sub(getwd(), "", tmp.dir)
    cat("Scenario directory: ", tmp.msg, "\n")
    cat("Starting time: ", format(Sys.time()), "\n")
  }
  scen <- interpolate(obj, name = name)
  arg$scen <- scen
  arg$name <- name
  arg$solver <- solver
  arg$tmp.dir <- tmp.dir
  arg$tmp.del <- tmp.del
  arg$read.solution <- TRUE
  scen <- do.call(.solver_solve, arg)
  # scen <- .solver_solve(scen,
  #   name = name, solver = solver,
  #   tmp.dir = tmp.dir, tmp.del = tmp.del, ..., read.solution = TRUE
  # )
  if (tmp.del) unlink(tmp.dir, recursive = TRUE)
  invisible(scen)
}

# a function to use in solve methods
solve.model <- function(a, b, ...) {
  arg <- list(...)
  if (missing(b)) {
    if (!is.null(arg$name)) {
      b <- arg$name; arg$name <- NULL
    } else {
      b <- NULL
    }
  }
  if (!is.null(arg$obj)) stop("'obj' is 'a' argument in `solve(a, b, ..)` method")
  if (!is.null(arg$name)) stop("'name' is 'b' argument in `solve(a, b, ..)` method")
  arg$obj <- a
  if (!is.null(b)) arg$name <- b
  do.call(solve_model, arg)
}

## solve(model, character) ####
#' @rdname solve
#' @export
setMethod("solve", signature(a = "model", b = "character"), solve.model)

## solve(model, missing) ####
#' @export
#' @noRd
setMethod("solve", signature(a = "model", b = "missing"), solve.model)

# .S3method("solve", "model", .solve_model)

#' Solve scenario
#'
#' @export
#' @rdname solve
solve_scenario <- function(obj = NULL, tmp.dir = NULL, solver = NULL, ...) {
  scen <- obj
  # browser()
  arg <- list(...)
  if (is.null(tmp.dir)) {
    if (is.null(scen)) {
      stop("At least one of two parameters ('scen' or 'tmp.dir') should be specified")
    } else {
      tmp.dir <- scen@misc$tmp.dir
    }
  } else {
    if (!is.null(scen)) scen@misc$tmp.dir <- tmp.dir
  }
  if (is.character(solver)) solver <- list(lang = solver)
  solv_par <- read.csv(paste0(.fix_path(tmp.dir), "solver"), stringsAsFactors = FALSE)
  solver_list <- list()
  for (i in seq_len(nrow(solv_par))) {
    tmp <- solv_par[i, "value"]
    if (tmp %in% c("TRUE", "FALSE")) tmp <- (tmp == "TRUE")
    solver_list[[solv_par[i, "name"]]] <- tmp
  }
  # browser()
  if (!is.null(scen) && !is.null(scen@settings@solver)) {
    for (i in grep("^(inc[1-5]|files)$", names(scen@settings@solver),
                   value = TRUE, invert = TRUE)) {
      solver_list[[i]] <- scen@settings@solver[[i]]
    }
  }
  for (i in grep("^(inc[1-5]|files)$", names(solver), value = TRUE, invert = TRUE)) {
    solver_list[[i]] <- solver[[i]]
  }
  if (is.null(scen)) {
    scen <- new("scenario")
  }

  arg$scen <- scen
  arg$tmp.dir <- tmp.dir
  arg$solver <- solver_list
  arg$run <- TRUE
  arg$write <- FALSE
  do.call(.solver_solve, arg)

  # .solver_solve(
  #   scen = scen, run = TRUE, solver = solver_list,
  #   tmp.dir = tmp.dir, write = FALSE, ...
  # )
}

# a function to use in solve methods
solve.scenario <- function(a, b, ...) {
  if (missing(b)) b <- NULL
  arg <- list(...)
  if (!is.null(arg$obj)) stop("'obj' is 'a' argument in `solve(a, b, ..)` method")
  if (!is.null(arg$name)) stop("'name' is 'b' argument in `solve(a, b, ..)` method")
  arg$obj <- a
  if (!is.null(b)) arg$name <- b
  do.call(solve_scenario, arg)
}

## solve(scenario, character) ####
#' @rdname solve
#' @export
setMethod("solve", signature(a = "scenario", b = "character"), solve.scenario)

## solve(scenario, missing) ####
#' @export
#' @noRd
setMethod("solve", signature(a = "scenario", b = "missing"), solve.scenario)

## solve(missing, missing) ####
#' @export
#' @noRd
setMethod("solve", signature(a = "missing", b = "missing"), function(...) {
  # browser()
  arg <- list(...)
  if (is.null(arg$obj)) do.call(NextMethod, arg)
  if (class(arg$obj)[1] == "scenario") {
    return(do.call(solve_scenario, arg))
  } else if (class(arg$obj)[1] == "model") {
    return(do.call(solve_model, arg))
  } else {
    NextMethod(arg)
  }
})


####### Internal functions ##########

.solver_solve <- function(scen, tmp.dir = NULL, solver = NULL, ...,
                          interpolate = FALSE,
                          read.solution = FALSE, write = TRUE) {
  # - solves scen, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # tmp.dir - solver working directory
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder before the run
  # show.output.on.console = FALSE & invisible = FALSE arg for command system
  # only.listing = FALSE (!depreciated?) generate only listing file (works for gams only)
  # read.solution = TRUE read result
  # tmp.del delete results
  # browser()
  arg <- list(tmp.dir = tmp.dir, solver = solver, ...)
  if (is.null(arg$tmp.dir)) {
    browser()
  }
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) {
    scen@settings@solver <- list(lang = "PYOMO")
  } else if (is.character(arg$solver)) {
    scen@settings@solver <- list(lang = arg$solver)
  } else if (is.list(arg$solver)) {
    scen@settings@solver <- arg$solver
  }
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  # if (is.null(arg$invisible)) arg$invisible <- FALSE
  if (is.null(arg$tmp.del)) arg$tmp.del <- FALSE
  if (is.null(arg$read.solution)) arg$read.solution <- TRUE
  arg$write <- write
  if (is.null(arg$wait)) {
    if (is.null(scen@settings@solver$wait)) {
      arg$wait <- TRUE
    } else {
      arg$wait <- scen@settings@solver$wait
    }
  } else if (is.null(arg$invisible)) arg$invisible <- arg$wait
  scen@settings@solver$wait <- arg$wait
  if (is.null(arg$invisible)) {
    if (is.null(scen@settings@solver$invisible)) {
      arg$invisible <- TRUE
    } else {
      arg$invisible <- scen@settings@solver$invisible
    }
  }
  scen@settings@solver$invisible <- arg$invisible
  if (is.null(arg$run)) arg$run <- TRUE
  if (is.null(arg$n.threads)) arg$n.threads <- 1

  # if (is.null(arg$onefile)) arg$onefile <- FALSE
  # if (!is.null(arg$dir.result)) {
  #   warning("solve_model: parameter `dir.result` is depreciated, use `tmp.dir` instead")
  #   if (is.null(arg$tmp.dir)) {
  #     arg$tmp.dir <- arg$dir.result
  #   } else {
  #     stop("check `dir.result` and `tmp.dir` - only one should be used")
  #   }
  # } else {
  #   # temporary - will be depreciated
  #   arg$dir.result <- arg$tmp.dir
  # }

  if (is.null(scen)) {
    if (interpolate | arg$write) {
      stop("scenario object not found")
    }
  } else {
    scen@misc$tmp.dir <- arg$tmp.dir
    tmp_name <- scen@name
  }
  # arg$dir.result <- .fix_path(arg$dir.result)
  arg$tmp.dir <- .fix_path(arg$tmp.dir)
  if (!is.null(scen)) scen@misc$tmp.dir <- .fix_path(scen@misc$tmp.dir)

  if (is.null(arg$tmp.dir)) {
    arg$tmp.dir <- .file.path(
      file.path(getwd(), "solwork"),
      paste(arg$solver$lang, tmp_name, # scen@name,
        format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
        sep = "_"
      )
    )
  }
  # arg$dir.result <- arg$tmp.dir

  # interpolate
  if (interpolate) scen <- energyRt::interpolate(scen, ...)

  # Important miscs
  dir.create(arg$tmp.dir, recursive = TRUE, showWarnings = FALSE)
  if (arg$open.folder) shell.exec(arg$tmp.dir)

  if (arg$write) {
    if (arg$echo) cat("Writing files: ")
    solver_solver_time <- proc.time()[3]
    if (any(grep("^gams$", scen@settings@solver$lang, ignore.case = TRUE))) {
      if (is.null(arg$trim)) arg$trim <- FALSE
      scen <- .write_model_GAMS(arg, scen, trim = arg$trim)
    } else if (any(grep("^(glpk|cbcb)$", scen@settings@solver$lang,
                        ignore.case = TRUE))) {
      scen <- .write_model_GLPK_CBC(arg, scen)
    } else if (any(grep("^pyomo", scen@settings@solver$lang, ignore.case = TRUE))) {
      scen <- .write_model_PYOMO(arg, scen)
    } else if (any(grep("^jump$", scen@settings@solver$lang, ignore.case = TRUE))) {
      scen <- .write_model_JuMP(arg, scen)
    } else {
      stop("Unknown solver ", scen@settings@solver$lang)
    }

    ## Write solver parameter
    nn <- grep("^(inc[1-5]|files|code[[:digit:]]*)$",
      names(scen@settings@solver),
      value = TRUE, invert = TRUE
    )
    tmp <- data.frame(
      name = nn,
      value = sapply(
        scen@settings@solver[nn],
        function(x) paste0(c(x, recursive = TRUE), collapse = " ")
      ),
      stringsAsFactors = FALSE
    )
    tmp <- rbind(tmp, data.frame(
      name = paste0("code", seq_along(scen@settings@solver$code)),
      value = scen@settings@solver$code, stringsAsFactors = FALSE
    ))
    write.csv(tmp, file = paste0(arg$tmp.dir, "solver"), row.names = FALSE)

    if (arg$echo) {
      cat(round(proc.time()[3] - solver_solver_time, 2), "s\n", sep = "")
      flush.console()
    }
  }
  .run_solve_model(arg, scen) # For all solvers
  # browser()
  if (read.solution && arg$run) scen <- read_solution(scen)

  invisible(scen)
}

.run_solve_model <- function(arg, scen) {
  # browser()
  HOMEDIR <- getwd()
  if (!arg$run) {
    return()
  }
  if (arg$echo) cat("Starting ", scen@settings@solver$lang, "\n")
  gams_run_time <- proc.time()[3]
  tryCatch(
    {
      setwd(arg$tmp.dir)
      if (.Platform$OS.type == "windows") {
        if (arg$invisible) {
          cmd <- ""
        } else {
          cmd <- "cmd /k"
        }
        rs <- system(paste(cmd, scen@settings@solver$cmdline), #' gams energyRt.gms', arg$gamsCompileParameter),
          invisible = arg$invisible, wait = arg$wait
          # show.output.on.console = arg$show.output.on.console
        )
      } else {
        # browser()
        rs <- system(paste(scen@settings@solver$cmdline),
          # invisible = arg$invisible,
          wait = arg$wait
          # show.output.on.console = arg$show.output.on.console
        )
      }
      setwd(HOMEDIR)
    },
    interrupt = function(x) {
      if (arg$tmp.del) unlink(arg$tmp.dir, recursive = TRUE)
      setwd(HOMEDIR)
      stop("Solver has been interrupted")
    },
    error = function(x) {
      if (arg$tmp.del) unlink(arg$tmp.dir, recursive = TRUE)
      setwd(HOMEDIR)
      stop(x)
    }
  )
  if (rs != 0) stop(paste("Solution error code", rs))
  if (arg$echo) cat("", round(proc.time()[3] - gams_run_time, 2), "s\n", sep = "")
}

.generate_gpr_gams_file <- function(tmp.dir) {
  # Generates GAMS-project file
  fn <- file(paste(tmp.dir, "/energyRt_project.gpr", sep = ""), "w")
  cat(c(
    "[RP:MDL]", "1=", "", "[OPENWINDOW_1]",
    "FILE0=energyRt.gms",
    "FILE1=energyRt.lst",
    # gsub('[/][/]*', '\\\\', paste('FILE0=', tmp.dir, '/energyRt.gms', sep = '')),
    # gsub('[/][/]*', '\\\\', paste('FILE1=', tmp.dir, '/energyRt.lst', sep = '')),
    "", "MAXIM=1",
    "TOP=50", "LEFT=50", "HEIGHT=400", "WIDTH=400", ""
  ), sep = "\n", file = fn)
  close(fn)
}
