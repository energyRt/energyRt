.run_solve_model <- function(arg, scen) {
  BEGINDR <- getwd()
  # browser()
  if (!arg$run) return()
  # if(arg$echo) cat(scen@solver$lang, ' time: ')
  if(arg$echo) cat(arg$solver, ' time: ')
  gams_run_time <- proc.time()[3]
  tryCatch({
    setwd(arg$dir.result)
    if (.Platform$OS.type == "windows") {
      if (arg$invisible) {cmd <- ""} else {cmd <- "cmd /k"}
      rs <- shell(paste(cmd, 'gams energyRt.gms', arg$gamsCompileParameter), 
                  invisible = arg$invisible, wait = arg$wait
                  # show.output.on.console = arg$show.output.on.console
  )
    } else {
      rs <- system(paste(cmd, 'gams energyRt.gms', arg$gamsCompileParameter),
                   # paste(scen@solver$cmd), 
                   invisible = arg$invisible, wait = arg$wait
                   # show.output.on.console = arg$show.output.on.console
      )
    }
    setwd(BEGINDR)  
  }, interrupt = function(x) {
    if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
    setwd(BEGINDR)
    stop('Solver has been interrupted')
  }, error = function(x) {
    if (arg$tmp.del) unlink(arg$dir.result, recursive = TRUE)
    setwd(BEGINDR)
    stop(x)
  })    
  if (rs != 0) stop(paste('Solution error code', rs))
  if(arg$echo) cat('', round(proc.time()[3] - gams_run_time, 2), 's\n', sep = '')
}
