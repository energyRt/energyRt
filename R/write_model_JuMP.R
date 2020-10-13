#################################################################################################################################
# Julia JuMP part
#################################################################################################################################
.write_model_JuMP <- function(arg, scen) {
  run_code <- scen@source[["JuMP"]]
  run_codeout <- scen@source[["JuMPOutput"]]
  # There is not prod in jump julia. Remove it, until jump will be better
  for (i in grep('^[@].*prod[(]', run_code)) {
    xxx <- gsub('^[@].*prod[(]', '', run_code[i])
    k <- 1
    while (k != 0) {
      xxx <- gsub('^[^)(]*', '', xxx)
      if (substr(xxx, 1, 1) == '(') k <- k + 1 else k <- k - 1
      xxx <- gsub('^[)(]', '', xxx)
    }
    run_code[i] <- paste0(gsub('[*][ ]*prod[(]', '*(1 + sum(-1 + ', 
      substr(run_code[i], 1, nchar(run_code[i]) - nchar(xxx))), ')', xxx)
  }
  # Check for complicated weather
  for (pr in c('mTechWeatherAfLo', 'mTechWeatherAfUp', 'mTechWeatherAfsLo', 'mTechWeatherAfsUp', 'mTechWeatherAfcLo', 
        'mTechWeatherAfcUp', 'mTechWeatherAfcLo', 'mTechWeatherAfcUp', 'mSupWeatherUp', 'mSupWeatherLo', 'mStorageWeatherAfLo', 
    'mStorageWeatherAfUp', 'mStorageWeatherCinpUp', 'mStorageWeatherCinpLo', 'mStorageWeatherCoutUp', 'mStorageWeatherCoutLo')) {
    tmp <- getParameterData(scen@modInp@parameters[[pr]])
    tmp$weather <- NULL
    if (anyDuplicated(tmp)) {
      assign('error_msg', tmp[duplicated(tmp),, drop = FALSE], globalenv())
      stop(paste0('It is forbidden to determine more than one weather for Julia, since the prod is not a allowed. ', 
        'List of duplicated weather for map "', pr, '"assign to error_msg.'))
    }
  }
      # For downsize
  fdownsize <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)]
  for (nn in fdownsize) {
    rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
    if (scen@modInp@parameters[[nn]]@type == 'multi') {
      uuu <- paste0(nn, c('Lo', 'Up'))
    } else uuu <- nn
    for (yy in uuu) {
      templ <- paste0('[(]if haskey[(]', yy, '[,]')
      if (any(grep('^pCns', nn))) {
        for (www in seq_along(scen@modInp@gams.equation)) {
          mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
          if (any(mmm)) {
            scen@modInp@gams.equation[[www]]$equation[mmm] <- sapply(strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], yy), .rem_jump, yy, rmm)
          }
        }
      } else {
        mmm <- grep(templ, run_code)
        if (any(mmm)) {
          xx = run_code[mmm]
          ww <- strsplit(xx, templ)[[1]]
          dd = ww[2]
          gsub('; end[)].*', '', dd)
          run_code[mmm] <- sapply(strsplit(run_code[mmm], templ), .rem_jump, yy, rmm)
        }
      }
    }
  }
  dir.create(paste(arg$tmp.dir, '/output', sep = ''), showWarnings = FALSE)
  zz_data_julia <- file(paste(arg$tmp.dir, '/data.jl', sep = ''), 'w')
  zz_data_constr <- file(paste(arg$tmp.dir, '/inc_constraints.jl', sep = ''), 'w')

  .write_inc_solver(scen, arg, "using Cbc\nset_optimizer(model, Cbc.Optimizer)\n", '.jl', 'Cbc')
  dat <- list()
  for (i in names(scen@modInp@parameters)) {
    tmp <- getParameterData(scen@modInp@parameters[[i]])
    colnames(tmp) <- gsub('[.]1', 'p', colnames(tmp))
    # if (!is.null(scen@modInp@parameters[[i]]@data$year)) {
    #   scen@modInp@parameters[[i]]@data$year <- 
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$year))
    # }
    # if (!is.null(scen@modInp@parameters[[i]]@data$yearp)) {
    #   scen@modInp@parameters[[i]]@data$yearp <- 
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$yearp))
    # }
    if (scen@modInp@parameters[[i]]@type != 'multi') {
      dat[[i]] <- tmp
    } else {
      tmp <- getParameterData(scen@modInp@parameters[[i]])
      dat[[paste0(i, 'Up')]] <- tmp[tmp$type == 'up', colnames(tmp) != 'type']
      dat[[paste0(i, 'Lo')]] <- tmp[tmp$type == 'lo', colnames(tmp) != 'type']
    }
  }
  
  save('dat', file = paste0(arg$tmp.dir, "data.RData"))

  cat('using RData\nusing DataFrames\ndt = load("data.RData")["dat"]\n', sep = '\n', file = zz_data_julia)
  for (j in c('set', 'map', 'simple', 'multi')) {
    for(i in names(scen@modInp@parameters)) if (scen@modInp@parameters[[i]]@type == j) {
      cat(energyRt:::.toJuliaHead(scen@modInp@parameters[[i]]), sep = '\n', file = zz_data_julia)
      cat(paste0('println("', i, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_julia)
    }
  }
  close(zz_data_julia)
  # Add constraint
  zz_mod <- file(paste(arg$tmp.dir, '/energyRt.jl', sep = ''), 'w')
  nobj <- grep('^[@]objective', run_code)[1] - 1
  cat(run_code[1:nobj], sep = '\n', file = zz_mod)
  if (length(scen@modInp@gams.equation) > 0) {
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      cat(energyRt:::.equation.from.gams.to.julia(eqt$equation), sep = '\n', file = zz_data_constr)
      cat(paste0('println("', eqt$equationDeclaration2Model, ' done ", Dates.format(now(), "HH:MM:SS"))\n'), file = zz_data_constr)
    }
  }
  close(zz_data_constr)
  cat(run_code[-(1:nobj)], sep = '\n', file = zz_mod)
  close(zz_mod)
  zz_modout <- file(paste(arg$tmp.dir, '/output.jl', sep = ''), 'w')
  cat(run_codeout, sep = '\n', file = zz_modout)
  close(zz_modout)
  .add_five_includes(arg, scen, ".jl")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == '')
    scen@solver$cmdline <- 'julia energyRt.jl'
  scen@solver$code <- c('energyRt.jl', 'output.jl', 'inc_constraints.jl', 'inc_solver.jl')

  scen
}

.rem_jump <- function(x, nn, rmm) {
  for (i in 2:length(x)) {
    # Split for end
    hdd <- gsub('; end[)].*', '', x[i])
    tll <- gsub(paste0('.* ', nn, 'Def; end[)]'), '', x[i])
    argsss <- gsub('(^[ ][(]|[)].*)', '', hdd)
    x[i] <- paste0('(if haskey(', nn, ',', paste0(strsplit(hdd, argsss)[[1]], 
      collapse = paste0(strsplit(argsss, ',')[[1]][-rmm], collapse = ',')),
      '; end)', tll)
  }
  return(paste0(x, collapse = ''))
}
