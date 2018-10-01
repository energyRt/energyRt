run_in_bg <- function(mdl, tmp.dir = NULL, ...) {
  if (is.null(tmp.dir)) tmp.dir <- getwd()
  add_drr <- paste0('bg/bg_', format(Sys.Date(), format = '%Y-%m-%d'), '_', format(Sys.time(), format = '%H-%M-%S'))
  tmp.dir <- paste(tmp.dir, '/', add_drr, sep = '')
  dir.create(tmp.dir, recursive = TRUE)
  save(list = 'mdl', file = paste0(tmp.dir, '/mdl.RData'))
  
  zz <- file(paste0(tmp.dir, '/sc.R'), 'w')
  cat('require(energyRt)\n', file = zz)
  cat('require(energyRt)\n', file = zz)
  close(zz)
  
  nn <- getwd()
  tryCatch({
    setwd(tmp.dir)
    shell.exec('')
  }, 
  error = function(e) {setwd(nn);})
  
}
check_bg <- function(x) {
  
}