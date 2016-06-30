#---------------------------------------------------------------------------------------------------------
#! get_result_data_parameter < -function() : get matrix with colnames set, and rownames parameter
#!      for output
#---------------------------------------------------------------------------------------------------------
get_result_data_parameter <- function() {
    data_parameter  = data.frame(parameter   = character(),
                              technology  = logical(),
                              supply      = logical(),
                              group       = logical(),
                              comm        = logical(),
                              region      = logical(),
                              year        = logical(),
                              slice       = logical())
    parameter <- c('vTecNewCap','vTecCap',
        'vTecAct','vTecInp','vTecOut','vTecInv','vTecFix','vTecVar',
        'vTecVarY','vTecCost','vSupOut','vSupReserve','vSupCost',
        'vSupCostY','vDemInp','vEmsOut','vTecInpComb','vBalance',
        'vOutFull','vInpFull','vSupOutFull','vTecInpFull','vTecOutFull',
        'vCost','vCostR','vObjective','vDumOut','vDumCost','vDumCostY', 'Modelstat','vTaxCost','vTaxCostY')
    data_parameter <- array(FALSE, dim = c(length(parameter), 7),
          dimnames = list(parameter, c('technology', 'supply', 'group', 'comm', 'region', 'year', 'slice')))
    data_parameter['vTecNewCap', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vTecCap', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vTecAct', c('technology', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecInp', c('technology', 'comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecOut', c('technology', 'comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecInv', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vTecFix', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vTecVar', c('technology', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecVarY', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vTecCost', c('technology', 'region', 'year')] <- TRUE
    data_parameter['vSupOut', c('supply', 'comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vSupReserve', 'supply'] <- TRUE
    data_parameter['vSupCost', c('supply', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vSupCostY', c('supply', 'region', 'year')] <- TRUE
    data_parameter['vDemInp', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vEmsOut', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecInpComb', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vBalance', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vOutFull', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vInpFull', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vSupOutFull', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecInpFull', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTecOutFull', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vCost', c('region', 'year')] <- TRUE
    data_parameter['vCostR', 'region'] <- TRUE
    data_parameter['vDumOut', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vDumCost', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vDumCostY', c('comm', 'region', 'year')] <- TRUE
    data_parameter['vTaxCost', c('comm', 'region', 'year', 'slice')] <- TRUE
    data_parameter['vTaxCostY', c('comm', 'region', 'year')] <- TRUE
    data_parameter
}


get_parameter_set_name <- function(parameter) {
  data_parameter <- get_result_data_parameter()
  if (all(parameter != rownames(data_parameter))) stop('Undefined parameter ', parameter)
  colnames(data_parameter)[data_parameter[parameter, ]]
}

