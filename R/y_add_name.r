
setMethod('add_name', signature(obj = 'CodeProduce', app = 'commodity',
  approxim = 'list'), function(obj, app, approxim) {
  cmd <- upper_case(app)
  if (!chec_correct_name(cmd@name)) {
    stop(paste('Incorrect commodity name "', cmd@name, '"', sep = ''))
  }
  if (isCommodity(obj, cmd@name)) {
    warning(paste('There is commodity name "', cmd@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousCommodity(obj, cmd@name)
  }
  obj@maptable[['comm']] <- addData(obj@maptable[['comm']], cmd@name)
  obj
})



################################################################################
# Add demand
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'demand',
  approxim = 'list'), function(obj, app, approxim) { 
  dem <- upper_case(app)
  if (!chec_correct_name(dem@name)) {
    stop(paste('Incorrect demand name "', dem@name, '"', sep = ''))
  }
  if (isDemand(obj, dem@name)) {
    warning(paste('There is demand name "', dem@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousDemand(obj, dem@name)
  }
  obj@maptable[['dem']] <- addData(obj@maptable[['dem']], dem@name)
  obj
})

################################################################################
# Add constrain
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'constrain',
  approxim = 'list'), function(obj, app, approxim) { 
  obj
})

################################################################################
# Add supply
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'supply',
  approxim = 'list'), function(obj, app, approxim) {
  sup <- upper_case(app)
  if (!chec_correct_name(sup@name)) {
    stop(paste('Incorrect supply name "', sup@name, '"', sep = ''))
  }
  if (isSupply(obj, sup@name)) {
    warning(paste('There is supply name "', sup@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousSupply(obj, sup@name)
  }    
  obj@maptable[['sup']] <- addData(obj@maptable[['sup']], sup@name)
  obj
})

################################################################################
# Add export
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'export',
  approxim = 'list'), function(obj, app, approxim) {
  exp <- upper_case(app)
  if (!chec_correct_name(exp@name)) {
    stop(paste('Incorrect export name "', exp@name, '"', sep = ''))
  }
  if (isExport(obj, exp@name)) {
    warning(paste('There is export name "', exp@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousExport(obj, exp@name)
  }    
  obj@maptable[['expp']] <- addData(obj@maptable[['expp']], exp@name)
  obj
})

################################################################################
# Add import
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'import',
  approxim = 'list'), function(obj, app, approxim) {
  imp <- upper_case(app)
  if (!chec_correct_name(imp@name)) {
    stop(paste('Incorrect import name "', imp@name, '"', sep = ''))
  }
  if (isImport(obj, imp@name)) {
    warning(paste('There is import name "', imp@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousImport(obj, imp@name)
  }    
  obj@maptable[['imp']] <- addData(obj@maptable[['imp']], imp@name)
  obj
})



################################################################################
# Add technology
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'technology',
  approxim = 'list'), function(obj, app, approxim) {
  tech <- upper_case(app)
  # Temporary solution for immortality technology
  if (nrow(tech@olife) == 0) {
    tech@olife[1, ] <- NA;
    tech@olife[1, 'olife'] <- 1e3;
  }
  if (!chec_correct_name(tech@name)) {
    stop(paste('Incorrect technology name "', tech@name, '"', sep = ''))
  }
  if (isTechnology(obj, tech@name)) {
    warning(paste('There is technology name "', tech@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousTechnology(obj, tech@name)
  }
  obj@maptable[['tech']] <- addData(obj@maptable[['tech']], tech@name)
  obj
})

################################################################################
# Add trade
################################################################################
setMethod('add_name', signature(obj = 'CodeProduce', app = 'trade',
  approxim = 'list'), function(obj, app, approxim) { 
  trd <- upper_case(app)
  if (!chec_correct_name(trd@name)) {
    stop(paste('Incorrect trade name "', trd@name, '"', sep = ''))
  }
  if (isTrade(obj, trd@name)) {
    warning(paste('There is trade name "', trd@name,
        '" now, all previous information will be removed', sep = ''))
    obj <- removePreviousTrade(obj, trd@name)
  }
  obj@maptable[['trade']] <- addData(obj@maptable[['trade']], trd@name)
  obj
})



