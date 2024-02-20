# Solve model and scenario objects ####
# Functions and methods. Multiple methods in this file aim adopting the
# generic `base::solve(a, b, ...)` method to `solve(obj, name, ...)`

#' Functions and methods to solve model and scenario objects
#'
#' The function interpolates model, writes the script in a directory, runs the external software to solve the model, reads the solution results, and returns a scenario object with the solution.
#'
#' @param obj model or scenario object
#' @param name character name of scenario to return
#' @param solver a character or list with solver settings
#' @param tmp.dir character path to temporary directory
#' @param tmp.del logical delete temporary directory after the run
#' @param ...
#'
#' @seealso [read_solution()]
#'
#' @rdname solve
#' @return
#' @export
solve_model <- function(
    obj,
    name = NULL,
    # name = paste("scen", obj@name, sep = "_"),
    solver = NULL,
    # tmp.path = file.path(getwd(), "/solwork"),
    # tmp.time = format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
    # tmp.name = paste(solver, obj@name, name, tmp.time, sep = "_"),
    path = NULL,
    # sol.dir = NULL,
    # sol.del = TRUE,
    tmp.dir = NULL,
    tmp.del = TRUE,
    force = FALSE,
    ...) {
  # 'solve*' return a scenario object, objects from '...' are either
  # passed to 'interpolate' or used to overwrite the newly created
  # scenario object.

  if (!inherits(obj, c("model", "scenario")))
    stop("The first argument must be either model or scenario object")

  if (inherits(obj, "scenario")) {
    # stop("The first argument must be a model object")
    if (obj@status$optimal) {
      if (!force) {
        message(
          "The scenario is already solved to optimal.\n",
          "Use 'force = TRUE' to solve it again.\n",
          "Use 'interpolate(..., force = TRUE)' to interpolate it again.\n")
        return(obj)
      } else {
        # message(".")
        if (is.null(name)) name <- obj@name
      }
    }
  }

  if (is.null(name)) name <- paste("scen", obj@name, sep = "_")
  arg <- list(..., name = name, solver = solver, path = path,
              tmp.del = tmp.del, tmp.dir = tmp.dir)

  # Filter from '...' objects to pass to 'interpolate'
  obj_to_interpolate <- c(
    "repository", "list", newRepository("")@permit, # model data
    "config", "settings", "calendar", "horizon" # settings
    ) |> unique()

  ii <- names(arg) %in% c(
    obj_to_interpolate, "data",
    "name", "desc", "misc", "inMemory", "path", # scenario
    # settings
    "discountFirstYear", "optimizeRetirement", "defVal", "interpolation",
    "debug", "sourceCode", "region"
    # "solver" # !!! add later
    )
  ii <- ii |
    (sapply(arg, function(x) class(x)[1]) %in% c(
    c(obj_to_interpolate, "list"))
    )

  # Interpolate if necessary
  scen <- do.call(interpolate, c(list(object = obj), arg[ii]))
  # scen <- interpolate(obj, arg[ii])
  # the remaining objects will be passed to .executeScenario
  
  # browser()

  arg <- arg[!ii]
  arg$interpolate <- FALSE

  # get name for the tmp.dir
  arg$name <- scen@name
  arg$solver <- solver
  arg <- get_tmp_dir(scen, arg)
  tmp.dir <- arg$tmp.dir
  tmp.del <- arg$tmp.del

  # Run the scenario
  solve.time.start <- proc.time()[3]
  if (is.null(arg$echo)) arg$echo <- TRUE

  if (is.null(name)) {
    name <- paste("scen", obj@name, sep = "_")
    warning('Scenario name is not specified, using default name: ',
            name)
  }
  if (is.null(tmp.dir) || tmp.dir == "") {
    stop("Incorrect directory tmp.dir: ", tmp.dir)
  }
  if (isTRUE(arg$echo)) {
    tmp.msg <- sub(getwd(), "", tmp.dir)
    cat("Scenario directory: ", tmp.msg, "\n")
    cat("Starting time: ", format(Sys.time()), "\n")
  }
  # scen <- interpolate(obj, name = name)
  # browser()
  arg$scen <- scen
  # arg$name <- scen@name
  # arg$solver <- solver
  # arg$tmp.dir <- tmp.dir
  # arg$tmp.del <- tmp.del
  if (is.null(arg$read.solution)) {
    if (is.null(arg$wait) || isTRUE(arg$wait)) {
      arg$read.solution <- TRUE
    } else {
      arg$read.solution <- FALSE
    }
  }
  # browser()
  scen <- do.call(.executeScenario, arg)
  # scen <- .executeScenario(scen,
  #   name = name, solver = solver,
  #   tmp.dir = tmp.dir, tmp.del = tmp.del, ..., read.solution = TRUE
  # )
  if (tmp.del) unlink(tmp.dir, recursive = TRUE)
  scen
}

# a function to use in solve methods
solve.model <- function(a, b, ...) {
  arg <- list(...)
  if (missing(b)) {
    if (!is.null(arg$name)) {
      b <- arg$name
      arg$name <- NULL
    } else {
      b <- NULL
    }
  }
  if (!is.null(arg$obj)) stop("'obj' is 'a' argument in `solve(a, b, ..)` method")
  if (!is.null(arg$name)) stop("'name' is 'b' argument in `solve(a, b, ..)` method")
  arg$obj <- a
  if (!is.null(b)) arg$name <- b
  arg$interpolate <- TRUE
  arg$write <- TRUE
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
solve_scenario <- function(
    obj,
    name = obj@name,
    solver = obj@settings@solver,
    path = obj@path,
    tmp.dir = obj@misc$tmp.dir,
    tmp.del = FALSE,
    force = FALSE,
    ...) {
  # browser()
  if (obj@status$optimal) {
    if (!force) {
      message("The scenario is already solved to optimal.\nUse 'force = TRUE' to solve it again")
      return(obj)
    }
  }

  solve_model(obj,
              name = name, solver = solver, path = path,
              tmp.dir = tmp.dir, tmp.del = tmp.del, force = force,
              ...)
}


# solve_scenario <- function(obj = NULL, tmp.dir = NULL, solver = NULL, ...) {
#   scen <- obj
#   browser()
#   arg <- list(...)
#   if (is.null(tmp.dir)) {
#     if (is.null(scen)) {
#       stop("At least one of two parameters ('scen' or 'tmp.dir') should be specified")
#     } else {
#       tmp.dir <- scen@misc$tmp.dir
#     }
#   } else {
#     if (!is.null(scen)) scen@misc$tmp.dir <- tmp.dir
#   }
#   if (is.character(solver)) solver <- list(lang = solver)
#   solv_par <- read.csv(paste0(.fix_path(tmp.dir), "solver"), stringsAsFactors = FALSE)
#   solver_list <- list()
#   for (i in seq_len(nrow(solv_par))) {
#     tmp <- solv_par[i, "value"]
#     if (tmp %in% c("TRUE", "FALSE")) tmp <- (tmp == "TRUE")
#     solver_list[[solv_par[i, "name"]]] <- tmp
#   }
#   browser()
#   if (!is.null(scen) && !is.null(scen@settings@solver)) {
#     for (i in grep("^(inc[1-5]|files)$", names(scen@settings@solver),
#       value = TRUE, invert = TRUE
#     )) {
#       solver_list[[i]] <- scen@settings@solver[[i]]
#     }
#   }
#   for (i in grep("^(inc[1-5]|files)$", names(solver), value = TRUE, invert = TRUE)) {
#     solver_list[[i]] <- solver[[i]]
#   }
#   if (is.null(scen)) {
#     scen <- new("scenario")
#   }
#
#   arg$scen <- scen
#   arg$tmp.dir <- tmp.dir
#   arg$solver <- solver_list
#   arg$run <- TRUE
#   arg$write <- FALSE
#   do.call(.executeScenario, arg)
#
#   # .executeScenario(
#   #   scen = scen, run = TRUE, solver = solver_list,
#   #   tmp.dir = tmp.dir, write = FALSE, ...
#   # )
# }

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

get_tmp_dir <- function(scen = NULL, arg = NULL) {
  # solver directory (tmp.dir) convention name
  # tmp.dir - full path to the directory for the solver's files
    # tmp.path - path where the tmp.dir will be created
    # tmp.name - name of the directory for the solver's files
    # tmp.dir == file.path(tmp.path, tmp.name)
  # tmp.del - if TRUE, the tmp.dir will be deleted after the scenario is solved
  # return: arg with tmp.dir and tmp.del
  # browser()
  tmp.path <- tmp.name <- NULL

  # 1. tmp.dir is given
  if (!is.null(arg[["tmp.dir"]]) && length(arg[["tmp.dir"]]) > 0) {
    arg[["tmp.dir"]] <- gsub("[\\/]+", "/", arg[["tmp.dir"]])
    return(arg)
  }

  # if (isTRUE(arg[["tmp.del"]]) && is.null(arg[["tmp.dir"]])) {
  if (isTRUE(arg[["tmp.del"]])) {
    arg[["tmp.name"]] <-  format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = "UTC")
    # return(arg)
  }

  # 2. scen@misc$tmp.dir is given
  if (!is.null(scen)) {
    if (!is.null(scen@misc$tmp.dir) && length(scen@misc$tmp.dir) > 0) {
      arg[["tmp.dir"]] <- scen@misc$tmp.dir
      return(arg)
    } else if (!is.null(scen@path)) {
      tmp.path <- scen@path
      # return(arg)
    }
  }

  # 3. tmp.path + tmp.name
  # tmp.path
  if (!is.null(arg[["tmp.path"]])) {
    tmp.path <- arg[["tmp.path"]]
    arg[["tmp.path"]] <- NULL
    tmp.path <- gsub("[\\/]+", "/", tmp.path)
  }
  if (is.null(tmp.path) || length(tmp.path) == 0) {
    tmp.path <- file.path(get_scenarios_path(), scen@name, "solver")
    # if (!is.null(arg[["solver"]])) {
    #   tmp.path <- file.path(tmp.path, arg[["solver"]]$name)
    # }
  }

  # tmp.name
  if (!is.null(arg[["tmp.name"]])) {
    tmp.name <- arg[["tmp.name"]]
    arg[["tmp.name"]] <- NULL
  } else if (!is.null(arg[["solver"]]) && !is.null(arg[["solver"]]$name)) {
    tmp.name <- arg[["solver"]]$name
  } else if (isTRUE(arg[["tmp.del"]])) {
    tmp.name <- format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = "UTC")
  } else {
    tmp.name <- NULL
  }

  tmp.dir <- file.path(tmp.path, tmp.name)
  tmp.dir <- gsub("[\\/]+", "/", tmp.dir)
  arg[["tmp.dir"]] <- tmp.dir
  return(arg)
}

####### Internal functions ##########
.executeScenario <- function(
    scen,
    tmp.dir = NULL,
    solver = NULL,
    ...,
    interpolate = FALSE,
    read.solution = FALSE,
    write = FALSE) {
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
  arg <- list(
    tmp.dir = tmp.dir, solver = solver,
    read.solution = read.solution,
    write = write,
    ...
  )
  # arg <- get_tmp_dir(scen, arg)
  # if (is.null(arg$tmp.dir)) {
  #   browser()
  #   stop("tmp.dir is not specified")
  # }
  if (is.null(arg$echo)) arg$echo <- TRUE
  if (is.null(arg$solver)) {
    if (is.null(scen@settings@solver)) {
      # arg$solver <- list(lang = "PYOMO")
      arg$solver <- get_default_solver()
    } else {
      arg$solver <- scen@settings@solver
    }
    # scen@settings@solver <- list(lang = "PYOMO")
  } else if (is.character(arg$solver)) {
    scen@settings@solver <- list(name = arg$solver, lang = arg$solver)
  } else if (is.list(arg$solver)) {
    scen@settings@solver <- arg$solver
  }
  if (is.null(arg$open.folder)) arg$open.folder <- FALSE
  if (is.null(arg$show.output.on.console)) arg$show.output.on.console <- FALSE
  # if (is.null(arg$invisible)) arg$invisible <- FALSE
  if (is.null(arg$read.solution)) arg$read.solution <- TRUE
  if (is.null(arg$tmp.del)) arg$tmp.del <- arg$read.solution
  # arg$write <- write
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
  # browser()
  arg <- get_tmp_dir(scen, arg)

  if (is.null(scen)) {
    if (interpolate | arg$write) {
      stop("scenario object not found")
    }
  } else {
    scen@misc$tmp.dir <- arg$tmp.dir
    tmp_name <- scen@name
  }
  # arg$dir.result <- .fix_path(arg$dir.result)
  # arg$tmp.dir <- .fix_path(arg$tmp.dir)
  # if (!is.null(scen)) scen@misc$tmp.dir <- .fix_path(scen@misc$tmp.dir)

  # if (is.null(arg$tmp.dir)) {
  #   arg$tmp.dir <- .file.path(
  #     file.path(getwd(), "solwork"),
  #     paste(arg$solver$lang, tmp_name, # scen@name,
  #       format(Sys.time(), "%Y%m%d%H%M%S%Z", tz = Sys.timezone()),
  #       sep = "_"
  #     )
  #   )
  # }
  # arg$dir.result <- arg$tmp.dir

  # interpolate
  # browser()
  if (interpolate) {
    scen <- energyRt::interpolate(scen, ...)
    arg$write <- TRUE
    interpolate <- FALSE
    arg$interpolate <- FALSE
  }

  # write
  # browser()
  # dir.create(arg$tmp.dir, recursive = TRUE, showWarnings = FALSE)
  # if (arg$open.folder) shell.exec(arg$tmp.dir)
  if (is.null(arg$tmp.dir) || length(arg$tmp.dir) == 0) {
    stop("tmp.dir is not specified")
  }
  if (!isTRUE(arg$write) & !dir.exists(arg$tmp.dir)) {
    stop(paste(
      "tmp.dir does not exist:\n  ", 
      arg$tmp.dir, "\n  ",
      "hint: run 'write_script' for the specified solver and 'tmp.dir'"
      ))
  }
  if (arg$write) {
    dir.create(arg$tmp.dir, recursive = TRUE, showWarnings = FALSE)
    if (arg$echo) cat("Solver directory: ", arg$tmp.dir, "\n")
    if (arg$echo) cat("Writing files: ")
    solver_solver_time <- proc.time()[3]
    if (any(grep("^gams$", scen@settings@solver$lang, ignore.case = TRUE))) {
      # if (is.null(arg$trim)) arg$trim <- FALSE
      # scen <- .write_model_GAMS(arg, scen, trim = arg$trim)
      scen <- .write_model_GAMS(arg, scen, trim = FALSE)
    } else if (any(grep("^(glpk|cbcb)$", scen@settings@solver$lang,
      ignore.case = TRUE
    ))) {
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
    write.csv(tmp, file = file.path(arg$tmp.dir, "solver"), row.names = FALSE)

    if (arg$echo) {
      cat(round(proc.time()[3] - solver_solver_time, 2), "s\n", sep = "")
      flush.console()
    }
  }
  # browser()
  if (isTRUE(arg$run)) .call_solver(arg, scen)
  if (isTRUE(arg$read.solution) && isTRUE(arg$run)) scen <- read_solution(scen)

  return(scen)
}

.call_solver <- function(arg, scen) {
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
