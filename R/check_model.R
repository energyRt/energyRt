.check_gams <- function(tmp.dir = getwd(), tmp.del = TRUE, cmdline = NULL, lang) {
	suppressWarnings(dir.create(tmp.dir))
	scen <- new('scenario')
	check_value <- trunc(runif(1, 0, 1e4))
	zz <- file(paste0(tmp.dir, '/check.', c(GAMS = 'gms', PYOMO = 'py', GLPK = 'mod', JULIA = 'jl')[lang]), 'w')
	cat(gsub('123', check_value, energyRt:::.modelCode[[paste0('check', lang)]]), file = zz,  sep = '\n')
	close(zz)
	if (is.null(cmdline)) {
		if (lang == 'GAMS') cmdline <- 'gams check.gms' else
		if (lang == 'PYOMO') cmdline <- 'python check.py' else
		if (lang == 'JULIA') cmdline <- 'julia check.jl' else
		if (lang == 'GLPK') cmdline <- 'glpsol -m check.mod'
	}
	HOMEDIR <- getwd()
	## Run code
	 tryCatch({
    setwd(tmp.dir)
    rs <- system(cmdline)
    setwd(HOMEDIR)  
  }, interrupt = function(x) {
    if (tmp.del) unlink(tmp.dir, recursive = TRUE)
    setwd(HOMEDIR)
    stop('Solver has been interrupted')
  }, error = function(x) {
    if (tmp.del) unlink(tmp.dir, recursive = TRUE)
    setwd(HOMEDIR)
    stop(paste0('Solver "', lang, '" doesn\'t work'))
  })
	# Check results
	check_result <- as.numeric(readLines(paste0(tmp.dir, '/check_result'))[1])
  if (tmp.del) unlink(tmp.dir, recursive = TRUE)
	if (check_result != check_value)
		stop(paste0('Solver "', lang, '" doesn\'t work'))
}
check_gams <- function(...) .check_gams(lang = 'GAMS', ...) 
check_python <- function(...) .check_gams(lang = 'PYOMO', ...) 
check_glpk <- function(...) .check_gams(lang = 'GLPK', ...) 
check_julia <- function(...) .check_gams(lang = 'JULIA', ...) 

