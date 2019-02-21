
################################################################################
# Add statement
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'statement',
                                approxim = 'list'), function(obj, app, approxim) {
                                  if (!energyRt:::.chec_correct_name(app@name)) {
                                    stop(paste('Incorrect statement name "', app@name, '"', sep = ''))
                                  }
                                  if (isStatement(obj, app@name)) {
                                    warning(paste('There is statement name "', app@name,
                                                  '" now, all previous information will be removed', sep = ''))
                                    obj <- removePreviousStatement(obj, cmd@name)
                                  }
                                  obj
                                })


################################################################################
# Add commodity
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'commodity',
                                approxim = 'list'), function(obj, app, approxim) {
                                  cmd <- energyRt:::.upper_case(app)
                                  if (!energyRt:::.chec_correct_name(cmd@name)) {
                                    stop(paste('Incorrect commodity name "', cmd@name, '"', sep = ''))
                                  }
                                  if (isCommodity(obj, cmd@name)) {
                                    warning(paste('There is commodity name "', cmd@name,
                                                  '" now, all previous information will be removed', sep = ''))
                                    obj <- removePreviousCommodity(obj, cmd@name)
                                  }
                                  obj@parameters[['comm']] <- addData(obj@parameters[['comm']], cmd@name)
                                  obj
                                })



################################################################################
# Add demand
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'demand',
                                approxim = 'list'), function(obj, app, approxim) { 
                                  dem <- energyRt:::.upper_case(app)
                                  if (!energyRt:::.chec_correct_name(dem@name)) {
                                    stop(paste('Incorrect demand name "', dem@name, '"', sep = ''))
                                  }
                                  if (isDemand(obj, dem@name)) {
                                    warning(paste('There is demand name "', dem@name,
                                                  '" now, all previous information will be removed', sep = ''))
                                    obj <- removePreviousDemand(obj, dem@name)
                                  }
                                  obj@parameters[['dem']] <- addData(obj@parameters[['dem']], dem@name)
                                  obj
                                })

################################################################################
# Add weather
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'weather',
                                approxim = 'list'), function(obj, app, approxim) { 
                                  wth <- energyRt:::.upper_case(app)
                                  if (!energyRt:::.chec_correct_name(wth@name)) {
                                    stop(paste('Incorrect weather name "', wth@name, '"', sep = ''))
                                  }
                                  if (isWeather(obj, wth@name)) {
                                    warning(paste('There is weather name "', wth@name,
                                                  '" now, all previous information will be removed', sep = ''))
                                    obj <- removePreviousWeather(obj, wth@name)
                                  }
                                  obj@parameters[['weather']] <- addData(obj@parameters[['weather']], wth@name)
                                  obj
                                })

################################################################################
# Add constrain
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'constrain',
  approxim = 'list'), function(obj, app, approxim) { 
  obj
})

################################################################################
# Add supply
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'supply',
approxim = 'list'), function(obj, app, approxim) {
  sup <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(sup@name)) {
    stop(paste('Incorrect supply name "', sup@name, '"', sep = ''))
  }
  if (isSupply(obj, sup@name)) {
    warning(paste('There is supply name "', sup@name,
                  '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousSupply(obj, sup@name)
  }    
  obj@parameters[['sup']] <- addData(obj@parameters[['sup']], sup@name)
  obj
})

################################################################################
# Add storage
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'storage',
approxim = 'list'), function(obj, app, approxim) {
  stg <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(stg@name)) {
    stop(paste('Incorrect storage name "', stg@name, '"', sep = ''))
  }
  if (isSupply(obj, stg@name)) {
    warning(paste('There is storage name "', stg@name,
                  '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousStorage(obj, stg@name)
  }    
  obj@parameters[['stg']] <- addData(obj@parameters[['stg']], stg@name)
  obj
})

################################################################################
# Add export
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
  exp <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(exp@name)) {
    stop(paste('Incorrect export name "', exp@name, '"', sep = ''))
  }
  if (isExport(obj, exp@name)) {
    warning(paste('There is export name "', exp@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousExport(obj, exp@name)
  }    
  obj@parameters[['expp']] <- addData(obj@parameters[['expp']], exp@name)
  obj
})

################################################################################
# Add import
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'import',
  approxim = 'list'), function(obj, app, approxim) {
  imp <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(imp@name)) {
    stop(paste('Incorrect import name "', imp@name, '"', sep = ''))
  }
  if (isImport(obj, imp@name)) {
    warning(paste('There is import name "', imp@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousImport(obj, imp@name)
  }    
  obj@parameters[['imp']] <- addData(obj@parameters[['imp']], imp@name)
  obj
})



################################################################################
# Add technology
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'technology',
  approxim = 'list'), function(obj, app, approxim) {
  tech <- energyRt:::.upper_case(app)
  # Temporary solution for immortality technology
  if (nrow(tech@olife) == 0) {
    tech@olife[1, ] <- NA;
    tech@olife[1, 'olife'] <- 1e3;
  }
  if (!energyRt:::.chec_correct_name(tech@name)) {
    stop(paste('Incorrect technology name "', tech@name, '"', sep = ''))
  }
  if (isTechnology(obj, tech@name)) {
    warning(paste('There is technology name "', tech@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousTechnology(obj, tech@name)
  }
  obj@parameters[['tech']] <- addData(obj@parameters[['tech']], tech@name)
  obj
})

################################################################################
# Add trade
################################################################################
setMethod('add_name', signature(obj = 'modInp', app = 'trade',
  approxim = 'list'), function(obj, app, approxim) { 
  trd <- energyRt:::.upper_case(app)
  if (!energyRt:::.chec_correct_name(trd@name)) {
    stop(paste('Incorrect trade name "', trd@name, '"', sep = ''))
  }
  if (isTrade(obj, trd@name)) {
    warning(paste('There is trade name "', trd@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousTrade(obj, trd@name)
  }
  obj@parameters[['trade']] <- addData(obj@parameters[['trade']], trd@name)
  obj
})



