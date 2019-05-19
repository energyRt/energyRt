.remove_all_par_from_param <- function(scen, lst) {
  cls <- class(lst[[1]])
  slc <- c(technology = 'tech', supply = 'sup', storage = 'stg')[cls]
  all_par <- grep('^(p|m)Cns', names(scen@modInp@parameters), value = TRUE, invert = TRUE)
  tec_name <- sapply(lst, function(x) x@name)
  # Remove previous data
  for (i in all_par) {
    if (any(scen@modInp@parameters[[i]]@dimSetNames == slc)) {
      if (scen@modInp@parameters[[i]]@nValues != -1) {
        scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[seq_len(scen@modInp@parameters[[i]]@nValues),, drop = FALSE]
      }
      scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[!(scen@modInp@parameters[[i]]@data[, slc] %in% tec_name),, drop = FALSE]
      if (scen@modInp@parameters[[i]]@nValues != -1) {
        scen@modInp@parameters[[i]]@nValues <- nrow(scen@modInp@parameters[[i]]@data)
      }
    }
  }
  # Add change technology
  for(i in tec_name) {
    scen@modInp <- add_name(scen@modInp, lst[[i]], scen@misc$approxim)
  }
  scen@modInp@set <- lapply(scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])
  for(i in tec_name) {
    scen@modInp <- .add0(scen@modInp, arg$technology[[i]], approxim = scen@misc$approxim)
  }
  scen
}
.update_scenario_class <- function(scen, ...) {
  p1 = proc.time()[3];
  cat('Update model ')
  arg <- list(...)
  cls <- sapply(arg, class)
  arg <- lapply(unique(cls), function(x) arg[x == cls])  
  names(arg) <- unique(cls)
  if (!is.null(arg$technology)) {
    scen <- .remove_all_par_from_param(scen, arg$technology)
  }
  if (!is.null(arg$supply)) {
    scen <- .remove_all_par_from_param(scen, arg$supply)
  }
  if (!is.null(arg$storage)) {
    scen <- .remove_all_par_from_param(scen, arg$storage)
  }
  scen@modInp <- energyRt:::.reduce_mapping(scen@modInp)
  cat(round(proc.time()[3] - p1, 2), 's\n', sep = '')
  scen
}

# scen = BAU
# arg = list(mdl@data[[1]]@data$ELC_Coallz)