.write_multi_threads <- function(arg, scen, func, type) {
  require(parallel)
  tlp <- lapply(0:(arg$n.threads - 1), function(y) names(scen@modInp@parameters)[
    seq_along(scen@modInp@parameters) %% arg$n.threads == y])
  cl <- makeCluster(arg$n.threads)
  wrt_fun <- function(x, tlp, par, drr, func, type) {
    require(energyRt)
    for (i in tlp[[x + 1]]) {
      zz_data_tmp <- file(paste(drr, '/input/', i, '.', type, sep = ''), 'w')
      cat(func(par[[i]]), sep = '\n', file = zz_data_tmp)
      close(zz_data_tmp)
    }
    NULL
  }
  parLapply(cl, 0:(arg$n.threads - 1), wrt_fun, tlp, scen@modInp@parameters, arg$dir.result, func, type)
  stopCluster(cl)
  NULL
}

.write_inc_solver <- function(scen, arg, def_inc_solver, type, templ) {
  if (!is.null(scen@solver$inc_solver) && !is.null(scen@solver$solver))
    stop('have to define only one argument from scen@solver$inc_solver & scen@solver$solver')
  if (!is.null(scen@solver$solver))
    scen@solver$inc_solver <- gsub(templ, scen@solver$solver, def_inc_solver)
  if (is.null(scen@solver$inc_solver) && is.null(scen@solver$solver))
    scen@solver$inc_solver <- def_inc_solver
  zz <- file(paste0(arg$dir.result, 'inc_solver', type), 'w')
  cat(scen@solver$inc_solver, file = zz, sep = '\n')
  close(zz)
}
