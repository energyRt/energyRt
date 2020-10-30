#==============================================================================#
# Add commodity ####
#==============================================================================#
setMethod('.add_set_element', 
  signature(obj = 'modInp', app = 'commodity', approxim = 'list'), 
  function(obj, app, approxim) {
    # cmd <- energyRt:::.upper_case(app)
    cmd <- app
    if (!energyRt:::check_name(cmd@name)) {
      stop(paste('Incorrect commodity name "', cmd@name, '"', sep = ''))
    }
    if (.find_commodity(obj, cmd@name)) {
      warning(paste('There is commodity name "', cmd@name,
                    '" now, all previous information will be removed', sep = ''))
      obj <- .drop_commodity(obj, cmd@name)
    }
    obj@parameters[['comm']] <- .add_data(obj@parameters[['comm']], cmd@name)
    obj
  })

#==============================================================================#
# Add demand ####
#==============================================================================#
setMethod('.add_set_element', 
  signature(obj = 'modInp', app = 'demand', approxim = 'list'), 
  function(obj, app, approxim) { 
    # dem <- energyRt:::.upper_case(app)
    dem <- app
    if (!energyRt:::check_name(dem@name)) {
      stop(paste('Incorrect demand name "', dem@name, '"', sep = ''))
    }
    if (.find_demand(obj, dem@name)) {
      warning(paste('There is demand name "', dem@name,
                    '" now, all previous information will be removed', sep = ''))
      obj <- .drop_demand(obj, dem@name)
    }
    obj@parameters[['dem']] <- .add_data(obj@parameters[['dem']], dem@name)
    obj
  })

#==============================================================================#
# Add weather ####
#==============================================================================#
setMethod(
  '.add_set_element', 
  signature(obj = 'modInp', app = 'weather', approxim = 'list'),
  function(obj, app, approxim) { 
    # wth <- energyRt:::.upper_case(app)
    wth <- app
    if (!energyRt:::check_name(wth@name)) {
      stop(paste('Incorrect weather name "', wth@name, '"', sep = ''))
    }
    if (.find_weather(obj, wth@name)) {
      warning(paste('There is weather name "', wth@name,
                    '" now, all previous information will be removed', sep = ''))
      obj <- .drop_weather(obj, wth@name)
    }
    obj@parameters[['weather']] <- .add_data(obj@parameters[['weather']], wth@name)
    obj
  })

#==============================================================================#
# Add constraint ####
#==============================================================================#
setMethod('.add_set_element',
          signature(obj = 'modInp', app = 'constraint', approxim = 'list'),
          function(obj, app, approxim) {obj})

#==============================================================================#
# Add supply ####
#==============================================================================#
setMethod(
  '.add_set_element', 
  signature(obj = 'modInp', app = 'supply', approxim = 'list'),
  function(obj, app, approxim) {
    # sup <- energyRt:::.upper_case(app)
    sup <- app
    if (!energyRt:::check_name(sup@name)) {
      stop(paste('Incorrect supply name "', sup@name, '"', sep = ''))
    }
    if (.find_supply(obj, sup@name)) {
      warning(paste('There is supply name "', sup@name,
                    '" now, all previous information will be removed', sep = ''))
      obj <- .drop_supply(obj, sup@name)
    }    
    obj@parameters[['sup']] <- .add_data(obj@parameters[['sup']], sup@name)
    obj
  })

#==============================================================================#
# Add storage ####
#==============================================================================#
setMethod(
  '.add_set_element', 
  signature(obj = 'modInp', app = 'storage', approxim = 'list'), 
  function(obj, app, approxim) {
    # stg <- energyRt:::.upper_case(app)
    stg <- app
    if (!energyRt:::check_name(stg@name)) {
      stop(paste('Incorrect storage name "', stg@name, '"', sep = ''))
    }
    if (.find_supply(obj, stg@name)) {
      warning(paste('There is storage name "', stg@name,
                    '" now, all previous information will be removed', sep = ''))
      obj <- .drop_storage(obj, stg@name)
    }    
    obj@parameters[['stg']] <- .add_data(obj@parameters[['stg']], stg@name)
    obj
  })

#==============================================================================#
# Add export ####
#==============================================================================#
setMethod(
  '.add_set_element', 
  signature(obj = 'modInp', app = 'export', approxim = 'list'), 
  function(obj, app, approxim) {
    # exp <- energyRt:::.upper_case(app)
    exp <- app
    if (!energyRt:::check_name(exp@name)) {
      stop(paste('Incorrect export name "', exp@name, '"', sep = ''))
    }
    if (.find_export(obj, exp@name)) {
      warning(paste('There is export name "', exp@name,
          '" now, all previous information will be removed', sep = ''))
      obj <- .drop_export(obj, exp@name)
    }    
    obj@parameters[['expp']] <- .add_data(obj@parameters[['expp']], exp@name)
    obj
  })

#==============================================================================#
# Add import ####
#==============================================================================#
setMethod(
  '.add_set_element', 
  signature(obj = 'modInp', app = 'import', approxim = 'list'), 
  function(obj, app, approxim) {
    # imp <- energyRt:::.upper_case(app)
    imp <- app
    if (!energyRt:::check_name(imp@name)) {
      stop(paste('Incorrect import name "', imp@name, '"', sep = ''))
    }
    if (.find_import(obj, imp@name)) {
      warning(paste('There is import name "', imp@name,
          '" now, all previous information will be removed', sep = ''))
      obj <- .drop_import(obj, imp@name)
    }    
    obj@parameters[['imp']] <- .add_data(obj@parameters[['imp']], imp@name)
    obj
  })

#==============================================================================#
# Add technology ####
#==============================================================================#
setMethod(
  '.add_set_element',
  signature(obj = 'modInp', app = 'technology', approxim = 'list'), 
  function(obj, app, approxim) {
    # tech <- energyRt:::.upper_case(app)
    tech <- app
    # Temporary solution for infinite-olife technology
    if (nrow(tech@olife) == 0) {
      tech@olife[1, ] <- NA;
      tech@olife[1, 'olife'] <- 1e3;
    }
    if (!energyRt:::check_name(tech@name)) {
      stop(paste('Incorrect technology name "', tech@name, '"', sep = ''))
    }
    if (.find_technology(obj, tech@name)) {
      warning(paste('There is technology name "', tech@name,
          '" now, all previous information will be removed', sep = ''))
      obj <- .drop_technology(obj, tech@name)
    }
    obj@parameters[['tech']] <- .add_data(obj@parameters[['tech']], tech@name)
    obj
  })

#==============================================================================#
# Add trade ####
#==============================================================================#
setMethod('.add_set_element', 
  signature(obj = 'modInp', app = 'trade', approxim = 'list'),
  function(obj, app, approxim) { 
  # trd <- energyRt:::.upper_case(app)
    trd <- app
    if (!energyRt:::check_name(trd@name)) {
      stop(paste('Incorrect trade name "', trd@name, '"', sep = ''))
    }
    if (.find_trade(obj, trd@name)) {
      warning(paste('There is trade name "', trd@name,
          '" now, all previous information will be removed', sep = ''))
      obj <- .drop_trade(obj, trd@name)
    }
    obj@parameters[['trade']] <- .add_data(obj@parameters[['trade']], trd@name)
    obj
  })


#==============================================================================#
# Add tax ####
#==============================================================================#
setMethod('.add_set_element', 
          signature(obj = 'modInp', app = 'tax', approxim = 'list'), 
          function(obj, app, approxim) {obj})

#==============================================================================#
# Add subsidy ####
#==============================================================================#
setMethod('.add_set_element', 
          signature(obj = 'modInp', app = 'sub', approxim = 'list'), 
          function(obj, app, approxim) {obj})


