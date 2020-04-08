# Add all include files to tmp.dir (for solver_solve, type = file type for five include files)
.add_five_includes <- function(arg, scen, type) {
  if (is.null(type)) {
    fl <- c(names(scen@solver$files))
    for (i in 1:5)
      if (is.null(scen@solver[[paste0('inc', i)]]))
        fl <- c(fl, paste0('inc', i)) 
    if (is.null(fl)) {
      tmp <- paste0('There is (are) ', length(fl), ' files, that not suitable for lang ', scen@solver@lang, 
             '. File(s) list: "', paste0(fl, collapse = '", "'), '"')
      stop(tmp)
    }
  } 
  for (i in 1:5) {
    zz <- file(paste0(arg$dir.result, 'inc', i, type), 'w')
    cat(scen@solver[[paste0('inc', i)]], sep = '\n', file = zz)
    close(zz)
  }
  for (i in names(scen@solver$files)) {
    zz <- file(paste0(arg$dir.result, i), 'w')
    cat(scen@solver$files[[i]], sep = '\n', file = zz)
    close(zz)
  }
}
