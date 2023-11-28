# library(arrow)

#' Save scenario object into a scenario directory
#'
#' @param scen
#' @param path
#' @param format
#' @param overwrite
#' @param clean_start
#' @param write_log
#' @param verbose
#'
#' @return
#' @export
#'
#' @examples
save_scenario <- function(scen,
                          path = scen@path,
                          # save_model = FALSE,
                          # save_modInp = TRUE,
                          format = "parquet",
                          overwrite = TRUE,
                          clean_start = FALSE,
                          write_log = TRUE,
                          verbose = FALSE) {
  # identify directories
  if (is.null(path)) {
    scen@path <- file.path("scenarios", scen@name)
    message("Scenarios directory: ", scen@path)
  } else {
    scen@path <- path
  }

  if (isOnDisk(scen)) {
    stopifnot(dir.exists(path))
    return(scen)
  }

  # clean directories
  if (clean_start) {
    if (verbose) message("Cleaning directory '", scen@path, "'")
    if (write_log) {
      ff <- list.files(scen@path, include.dirs = TRUE)
      ff <- ff[!(ff == "logfile.csv")]
      clear_status <- unlink(file.path(scen@path, ff), recursive = TRUE,
                             force = TRUE)
      if (clear_status != 0) stop("Cannot delete content of'", scen@path,
                                  "' directory")
      rm(ff)
    } else {
      clear_status <- unlink(file.path(scen@path), force = TRUE,
                             recursive = TRUE)
      if (clear_status != 0) stop("Cannot delete '", scen@path, "' directory")
    }
  }
  # create scenario directories
  # dir.create(file.path(scen@path, "modOut", "sets"),
  #            recursive = T, showWarnings = F)
  # dir.create(file.path(scen@path, "modOut", "variables"), showWarnings = F)
  # dir.create(file.path(scen@path, "modOut", "misc"), showWarnings = F)

  # write format and log
  format_file <- file.path(scen@path, "format")
  write(format, format_file, append = FALSE)
  class_file <- file.path(scen@path, "class")
  write(class(scen), class_file, append = FALSE)
  log_file <- (file.path(scen@path, "logfile.csv"))
  write(paste(lubridate::now(tzone = "UTC"), "format", format, sep = ","),
        file = log_file, append = TRUE)

  # save variables in `format`
  # for (v in names(scen@modOut@variables)) {
  #   cat(v, "\n")
  #   # x <- scen@modOut@variables[[v]]
  #   nm <- names(scen@modOut@variables[[v]])
  #   ii <- duplicated(nm)
  #   if (any(ii)) {
  #     nm[ii] <- paste0(nm[ii], "2")
  #     names(scen@modOut@variables[[v]]) <- nm
  #   }
  #   arrow::write_dataset(
  #     x,
  #     path = file.path(scen@path, "modOut", "variables", v),
  #     format = "arrow"
  #   )
  # }

  message("Saving large data-frames on disk")
  scen <- obj2disk(scen, path = scen@path, format = format,
                   verbose = verbose)
  message("Saving the thinned scenario object")
  save(scen, file = file.path(scen@path, "scen.RData"))
  return(invisible(scen))
}

if (F) {
  getObjPath(scen)
  scen_ondisk <- save_scenario(
    scen = scen,
    path = file.path("scenarios", scen@name),
    verbose = T
  )
  isInMemory(scen_ondisk)
  isOnDisk(scen_ondisk)
  getObjPath(scen_ondisk)
  getObjPath(scen_ondisk@model)
  getObjPath(scen_ondisk@model@data$repo)
  getObjPath(scen_ondisk@modOut)
  scen_ondisk@modOut@misc
  scen_ondisk@modInp@misc
  scen_ondisk@modInp@parameters$region@misc

}

# mem2disk
# mem_to_disk
# disk2mem

data2disk <- function(obj, path = NULL, format = "parquet", verbose = FALSE) {
  # saves certain type of data to disk, returns TRUE if saved, FALSE if not
  if (is.null(path)) path <- getObjPath(obj)
  stopifnot(!is.null(path))
  # dir.create(path, recursive = T, showWarnings = F)
  # browser()
  # obj_class <- class(obj)

  if (inherits(obj, "data.frame")) {
    obj <- as.data.table(obj)
    obj_class <- class(obj)
    if (verbose) cat(path, format, "\n")
    if (anyDuplicatedSets(obj)) obj <- rename_duplicated_sets(obj)
    dir.create(path, recursive = T, showWarnings = F)
    arrow::write_dataset(obj, path = path, format = format)
    # write(format, file = file.path(path, "format"), append = FALSE)
    # write(obj_class, file = file.path(path, "class"), append = FALSE)
    return(invisible(TRUE))
  } else if (inherits(obj, c("character", "numeric", "logical"))) {
    if (verbose) cat(path, "csv", "\n")
    # if (anyDuplicatedSets(obj)) obj <- rename_duplicated_sets(obj)
    # arrow::write_dataset(obj, path = path, format = "csv")
    # browser()
    obj <- as.data.table(obj)
    data.table::setnames(obj, old = "obj", new = basename(path))
    # fwrite(obj, file = file.path(path, "obj.csv"))
    dir.create(path, recursive = T, showWarnings = F)
    arrow::write_dataset(obj, path = path, format = "csv")
    # write(obj_class, file = file.path(path, "class"), append = FALSE)
    # write("csv", file = file.path(path, "format"), append = FALSE)
    return(invisible(TRUE))
    # } else if (isS4(obj)) {
    #   obj <- set_ondisk_slots(obj)
    #   ondsk <- get_ondisk_slots(obj)
    #   isSaved <- FALSE
    #   for (s in slotNames(obj)) {
    #     if ((s %in% ondsk) | (isS4(slot(obj, s)))) {
    #       xs <- obj2disk(slot(obj, s), path = file.path(path, s), format = format,
    #                      verbose = verbose)
    #       if (xs) {
    #         isSaved <- TRUE
    #       }
    #     }
    #   }
    #   return(invisible(isSaved))
    # } else if (length(obj) > 1) {
    #   nm <- names(obj)
    #   isSaved <- FALSE
    #   if (length(nm) == length(obj)) {
    #     for (n in nm) {
    #       xn <- obj2disk(obj[[n]], path = file.path(path, n), format = format,
    #                      verbose = verbose)
    #       if (xn) {
    #         isSaved <- TRUE
    #       }
    #     }
    #     return(invisible(isSaved))
    #   # } else { # save as is
    #   #   save(obj, file = file.path(path, "obj.Rdata"))
    #   #   write(class(obj), file.path(path, "class"), append = FALSE)
    #   #   write("Rdata", file.path(path, "format"), append = FALSE)
    #   }
    # } else {
  }
  return(FALSE)
  # save as is
  # if (verbose) cat(path, "obj.RData", "\n")
  # save(obj, file = file.path(path, "obj.RData"))
  # write(class(obj), file = file.path(path, "class"), append = FALSE)
  # write("RData", file = file.path(path, "format"), append = FALSE)
  # return(invisible(TRUE))
}

obj2disk <- function(obj, path = NULL, format = "parquet",
                     save_not_S4 = FALSE,
                     force_save = FALSE,
                     verbose = FALSE) {
  # identifies which slots of S4 obj are savable,
  # proceeds with saving and wiping the saved slots with marks in @misc
  if (is.null(path)) path <- getObjPath(obj)
  stopifnot(!is.null(path))
  # dir.create(path, recursive = T, showWarnings = F)
  # browser()
  # obj_class <- class(obj)
  # if (inherits(obj, "list")) browser()
  # if (inherits(obj, "modOut")) browser()
  # if (inherits(obj, "weather")) browser()
  if (isOnDisk(obj)) {
    stopifnot(dir.exists(path))
    return(obj)
  }
  isSaved <- FALSE
  if (isS4(obj)) {
    obj <- set_ondisk_slots(obj)
    ondsk <- get_ondisk_slots(obj)
    stopifnot(all(ondsk %in% slotNames(obj)))
    for (s in ondsk) { # slots to save
      if (isS4(slot(obj, s))) {
        slot(obj, s) <- obj2disk(slot(obj, s), path = file.path(path, s),
                                 format = format, verbose = verbose)
        if (isOnDisk(slot(obj, s))) isSaved <- TRUE
      } else if (inherits(slot(obj, s), "list")) {
        # list of S4s (repo@data, modInp@parameters) or data.frames, etc.
        nm <- names(slot(obj, s))
        ii <- nm == ""
        if (any(ii)) nm[ii] <- (1:length(nm))[ii] # numbers as names for unnamed
        # dim_list <- vector("list", length(nm)); names(dim_list) <- nm
        dim_list <- list()
        for (i in nm) { # loop over list
          if (isS4(slot(obj, s)[[i]])) { # list of S4
            slot(obj, s)[[i]] <-  obj2disk(
              slot(obj, s)[[i]],
              path = file.path(path, s, i),
              save_not_S4 = TRUE,
              format = format,
              verbose = verbose
            )
            # if (inherits(obj, "weather")) browser()
            if (isOnDisk(slot(obj, s)[[i]])) isSaved <- TRUE
          } else { # call data2disk for not S4 elements
            xs <- data2disk(slot(obj, s)[[i]], path = file.path(path, s, i),
                            format = format, verbose = verbose)
            if (xs) {
              isSaved <- TRUE
              dim_list[[i]] <- dim(slot(obj, s)[[i]])
              # browser()
              slot(obj, s)[[i]] <- reset_slot(slot(obj, s)[[i]])
              # slot(obj, s) <- setObjPath(slot(obj, s),
              # path = file.path(path, s))
            }
          }
        }
        # save dim_list
      } else { # obj@s slot is not S4
        xs <- data2disk(slot(obj, s), path = file.path(path, s),
                        format = format, verbose = verbose)
        if (xs) {
          isSaved <- TRUE
          # browser()
          # store dim
          slot(obj, s) <- reset_slot(slot(obj, s))
          obj <- setObjPath(obj, path = file.path(path))
        }
      }
    }
  } else if (save_not_S4) {
    x <- data2disk(obj, path = file.path(path),
                   format = format, verbose = verbose)
    if (x) {
      isSaved <- TRUE
      # store dim
      obj <- reset_slot(obj)
    }
  }
  # mark if any data is on disk
  # if (inherits(obj, "scenario")) browser()
  if (isSaved) {
    obj <- mark_ondisk(obj)
    obj <- setObjPath(obj, path = path)
    # } else {
    #   obj <- mark_inMemory(obj)
  }
  return(obj)
}

reset_slot <- function(x) {
  if (inherits(x, "data.frame")) return(x[0,])
  if (is.vector(x)) return(x[0])
  return(x)
}

if (F) {
  isOnDisk(scen)
  isInMemory(scen)
  scen_ondisk <- obj2disk(scen, file.path("scenarios", scen@name), verbose = F)
  isOnDisk(scen_ondisk)
  isInMemory(scen_ondisk)
  size(scen); size(scen_ondisk)
  fs::dir_info(file.path("scenarios", scen@name), recurse = T)$size %>% sum()
  scen_ondisk2 <- obj2disk(scen_ondisk, file.path("scenarios", scen@name),
                           verbose = T)
  isInMemory(scen_ondisk2)
  fs::dir_info(file.path("scenarios", scen@name), recurse = T)$size %>% sum()
  # obj2disk(scen@modOut, file.path("scenarios", scen@name), verbose = T)
}

rename_duplicated_sets <- function(x) {
  # x <- table
  stopifnot(inherits(x, "data.frame"))
  nm <- colnames(x)
  ii <- duplicated(nm)
  if (any(ii)) {
    nm[ii] <- paste0(nm[ii], "2")
    colnames(x) <- nm
  }
  x
}

anyDuplicatedSets <- function(x) {
  if (!inherits(x, "data.frame")) return(NULL)
  any(duplicated(colnames(x)))
}

en_open_dataset <- function(path, format = NULL, engine = "arrow") {
  # identify format
  ff <- list.files(path)
  ext <- tools::file_ext(ff) %>% unique()
  if (is.null(format)) {
    if (all(ext %in% "csv")) {
      format <- "csv"
    } else if (all(ext %in% "parquet")) {
      format <- "parquet"
    } else if (all(ext %in% "RData")) {
      format <- "RData"
    } else {
      stop("Cannot identify format of the dataset\n     ",
           paste0(length(ff), " files or directories, extensions: '"),
           paste(ext, collapse =   "', '"), "'")
    }
  } else {
    # !!! check if files are consistent with the format
  }

  if (engine == "arrow") {
    if (format == "csv") return(arrow::open_csv_dataset(path))
    if (format == "parquet") return(arrow::open_dataset(path))
  }
  if (format == "RData") return(NULL)

}

if (F) {
  p <- "scenarios/base/sets/comm/"
  en_open_dataset(p)
  en_open_dataset("scenarios/base/variables/")
  a <- en_open_dataset("scenarios/base/variables/vTechOut")
  a |>
    filter(value > 0.1) |>
    collect()
}

isInMemory <- function(obj) {
  if (!isS4(obj)) return(TRUE)
  sts <- slotNames(obj)
  if (any(sts %in% "inMemory")) {
    return(obj@inMemory)
  } else if (any(sts %in% "misc")) {
    if (!is.null(obj@misc$inMemory)) {
      return(obj@misc$inMemory)
    }
  }
  return(TRUE)
}

isOnDisk <- function(obj) {!isInMemory(obj)}

if (F) {
  isInMemory(scen)
  isInMemory(scen@model)
  scen@model@misc$inMemory <- FALSE
  isInMemory(scen@model)
}

getObjPath <- function(obj, path = NULL) {
  if (!isS4(obj)) return(NULL)
  sts <- slotNames(obj)
  if (any(sts %in% "path")) {
    return(obj@path)
  } else if (any(sts %in% "misc")) {
    if (!is.null(obj@misc$path)) {
      return(obj@misc$path)
    }
  }
  return(NULL)
}

setObjPath <- function(obj, path = NULL) {
  if (!isS4(obj)) return(obj)
  sts <- slotNames(obj)
  if (any(sts %in% "path")) {
    obj@path <- path
    return(obj)
  } else if (any(sts %in% "misc")) {
    obj@misc$path <- path
    return(obj)
    # }
  }
  return(obj)
}

if (F) {
  getObjPath(scen)
  getObjPath(scen@model)
  scen@model@misc$path <- "scenarios/base/model"
  getObjPath(scen@model)
}

get_lazy_data <- function(obj, slot = NULL, element = NULL,
                          InMemory = isInMemory(obj),
                          path = NULL) {
  # browser()
  # check if the object is "inMemory"
  if (InMemory) {
    if (is.null(slot)) {
      x <- obj
    } else {
      if (!.hasSlot(obj, slot)) return(NULL)
      x <- slot(obj, slot)
    }
    if (!is.null(element)) x <- x[[element]]
    return(x)
  }
  if (is.null(path)) path <- getObjPath(obj)
  stopifnot(!is.null(path))
  if (!is.null(slot) && !.hasSlot(obj, slot)) return(NULL)
  path <- paste(c(path, slot, element), collapse = "/") |> normalizePath()
  qu <- try(en_open_dataset(path), silent = T)
  if (inherits(qu, "try-error")) return(NULL)
  return(qu)
}

if (F) {
  get_lazy_data(obj = scen, slot = "name")
  get_lazy_data(scen@modOut,
                slot = "variables",
                element = "vTechOut",
                InMemory = F,
                path = "scenarios/base") |>
    collect() %>%
    as.data.table()

  get_lazy_data(scen@modOut@variables, element = "vObjective", InMemory = T) %>%
    collect()
  get_lazy_data(scen@modOut@variables, element = "vObjective",
                InMemory = F,
                path = "scenarios/base/variables") %>%
    collect()
}

set_ondisk_slots <- function(obj) {
  if (inherits(obj, "weather")) {
    obj@misc$slots_on_disk <- c("weather")
  } else if (inherits(obj, "demand")) {
    obj@misc$slots_on_disk <- c("dem")
  } else if (inherits(obj, "model")) {
    obj@misc$slots_on_disk <- c("data")
  } else if (inherits(obj, "repository")) {
    obj@misc$slots_on_disk <- c("data")
  } else if (inherits(obj, "parameter")) {
    obj@misc$slots_on_disk <- c("data")
  } else if (inherits(obj, "modInp")) {
    obj@misc$slots_on_disk <- c("parameters")
  } else if (inherits(obj, "modOut")) {
    obj@misc$slots_on_disk <- c("variables")
  } else if (inherits(obj, "scenario")) {
    obj@misc$slots_on_disk <- c("model", "modInp", "modOut")
  }
  obj
}

get_ondisk_slots <- function(obj) {
  if (!isS4(obj)) return(NULL)
  if (!.hasSlot(obj, "misc")) return(NULL)
  return(obj@misc$slots_on_disk)
}

mark_ondisk <- function(obj) {
  sts <- slotNames(obj)
  if (any(sts %in% "inMemory")) {
    obj@inMemory <- FALSE
    return(obj)
  } else if (any(sts %in% "misc")) {
    obj@misc$inMemory <- FALSE
    return(obj)
  }
  return(obj)

}

mark_inMemory <- function(obj) {
  sts <- slotNames(obj)
  if (any(sts %in% "inMemory")) {
    obj@inMemory <- TRUE
    return(obj)
  } else if (any(sts %in% "misc")) {
    obj@misc$inMemory <- TRUE
    return(obj)
  }
  return(obj)
}

if (F) {

  mi <- scen@model
  mi@misc
  mi <- set_ondisk_slots(mi)
  mi@misc

}

load_scenario <- function(path, inMemory = FALSE) {

}

if (F) {
  findData(scen, "")
}

#' Load scenario (in progress)
#'
#' @param path
#' @param name
#' @param env
#' @param overwrite
#' @param ignore_errors
#' @param verbose
#'
#' @return
#' @export
#'
#' @examples
load_scenario <- function(path, name = NULL, env = .scen, overwrite = FALSE,
                          ignore_errors = FALSE, verbose = TRUE) {
  if (!file.exists(path) & !dir.exists(path)) {
    msg <- paste0("File or directory '", path, "' does not exist")
    if (!ignore_errors) stop(msg)
    if (verbose) message(msg)
    return(invisible(FALSE))
  }
  finf <- file.info(path)
  if (finf$isdir) {
    path <- file.path(path, "scen.RData")
    if (!file.exists(path)) {
      msg <- paste0("Scenario file '", path, "' has not been found.")
      if (!ignore_errors) stop(msg)
      if (verbose) message(msg)
      return(invisible(FALSE))
    }
  }
  if (!(exists(".en_tmp") && is.environment(.en_tmp))) {
    .en_tmp <- new.env(parent = .GlobalEnv)
  }
  # on.exit(rm(.en_tmp))
  nm <- load(path, envir = .en_tmp)
  if (length(nm) != 1) {
    msg <- paste0("Scenario file '", path,
                  "' must contain only one (scenario) object",
                  ", actual number of objects: ", length(nm)
    )
    if (!ignore_errors) stop(msg)
    if (verbose) message(msg)
    return(invisible(FALSE))
  }
  if (!inherits(get(nm, envir = .en_tmp), "scenario")) {
    msg <- paste0(path, " must contain a 'scenario' object; actual class: ",
                  class(get(nm, envir = .en_tmp))
    )
    if (!ignore_errors) stop(msg)
    if (verbose) message(msg)
    return(invisible(FALSE))
  }
  if (is.null(name)) name <- get(nm, envir = .en_tmp)@name
  if (exists(name, envir = .scen) & !overwrite) {
    msg <- paste0("Scenario '", name,
                  "' already exists in '.scen' environment. \n",
                  "Use 'overwrite = TRUE' or different name")
    if (!ignore_errors) stop(msg)
    if (verbose) message(msg)
    return(invisible(FALSE))
  }
  assign(name, get(nm, envir = .en_tmp), envir = .scen)
  assign(nm, NULL, envir = .en_tmp)
  return(invisible(TRUE))
}

