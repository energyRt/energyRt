solve <- function(...) UseMethod("solve")

#' @rdname solve
#' @method solve model
#' @export
solve.model <- function(obj, name = NULL, solver = "GAMS",
                        tmp.path = file.path(getwd(), "/solwork"),
                        tmp.time = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
                        tmp.name = paste(solver, obj@name, name, tmp.time, sep = "_"),
                        tmp.dir = file.path(tmp.path, tmp.name),
                        tmp.del = TRUE, n.threads = 1, ...) {
  tmp.path <- gsub("[\\/]+", "/", tmp.path)
  tmp.dir <- gsub("[\\/]+", "/", tmp.dir)
  arg <- list()
  solve.time.start <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE

  if (is.null(name)) {
    warning('Scenario name is not specified, using "DEFAULT" name')
    name <- "DEFAULT"
  }
  if (is.null(tmp.dir) || tmp.dir == "") stop("Incorrect directory tmp.dir: ", tmp.del)
  if (is.null(arg$echo)) {
    message("The solver working directory: ", tmp.dir)
    message("Starting time: ", Sys.time())
  }
  scen <- interpolate(obj, name = name, n.threads = n.threads)
  scen <- .solver_solve(scen,
    name = name, solver = solver,
    tmp.dir = tmp.dir, tmp.del = tmp.del, ..., readresult = TRUE
  )
  if (tmp.del) unlink(tmp.dir, recursive = TRUE)
  invisible(scen)
}

setMethod("solve", "model", solve.model)
# .S3method("solve", "model", .solve_model)

#' @rdname solve
#' @method solve scenario
#' @export
solve.scenario <- function(scen = NULL, tmp.dir = NULL, solver = NULL, ...) {
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
  if (!is.null(scen) && !is.null(scen@settings@solver)) {
    for (i in grep("^(inc[1-5]|files)$", names(scen@settings@solver), value = TRUE, invert = TRUE)) {
      solver_list[[i]] <- scen@settings@solver[[i]]
    }
  }
  for (i in grep("^(inc[1-5]|files)$", names(solver), value = TRUE, invert = TRUE)) {
    solver_list[[i]] <- solver[[i]]
  }
  if (is.null(scen)) {
    scen <- new("scenario")
  }
  .solver_solve(
    scen = scen, run = TRUE, solver = solver_list,
    tmp.dir = tmp.dir, write = FALSE, ...
  )
}

setMethod("solve", "scenario", solve.scenario)

# .S3method("solve", "scenario", solve_model)


####### Internal functions ##########

.solver_solve <- function(scen, tmp.dir = NULL, solver = NULL, ..., interpolate = FALSE,
                          readresult = FALSE, write = TRUE) {
  # - solves scen, interpolate if required (NULL), force (TRUE), or no interpolation (FALSE, error if not interpolated)
  ## arguments
  # tmp.dir - solver working directory
  # echo = TRUE - print working data
  # open.folder = FALSE - open folder before the run
  # show.output.on.console = FALSE & invisible = FALSE arg for command system
  # only.listing = FALSE (!depreciated?) generate only listing file (works for gams only)
  # readresult = TRUE read result
  # tmp.del delete results
  arg <- list(tmp.dir = tmp.dir, solver = solver, ...)
  if (is.null(arg$tmp.dir)) {

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
  if (is.null(arg$readresult)) arg$readresult <- TRUE
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
    } else if (any(grep("^(glpk|cbcb)$", scen@settings@solver$lang, ignore.case = TRUE))) {
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
  if (readresult && arg$run) scen <- read_solution(scen)

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
