#---------------------------------------------------------------------------------------------------------
#! set_commodity_type <- function(tech) : Fill table commodity_type and check for conflict type definition
#---------------------------------------------------------------------------------------------------------
# Fill table commodity_type and check for conflict type definition
set_commodity_type <- function(tech) {
 stop('Internal error, use another function from set_commodity_type to checkInpOut')
    commodity_type      = data.frame(#region     = character(),
                                      comm      = character(),
                                      type      = factor(NULL, c('input', 'output')),
                                      use       = factor(NULL, c('cap', 'use')),
                                      act       = logical(),
                                      group     = character(),
                                      unit      = character(),
                                      stringsAsFactors = FALSE)
  # cat(tech@name, '\n')
  # Check for NA
  if (any(is.na(c(tech@input$comm, tech@output$comm))))
      stop('There is NA commodity in input/output ', tech@name)
  if (anyDuplicated(c(tech@input$comm, tech@output$comm)) != 0)
      stop('There are duplicated commodity in input/output')
  if (nrow(tech@input) == 0)  inp_com <- 0 else inp_com <- 1:nrow(tech@input)
  if (nrow(tech@output) == 0) out_com <- max(inp_com) + 0 else out_com <- max(inp_com) + 1:nrow(tech@output) 
  if (nrow(tech@input) == 0 && nrow(tech@output) == 0) return(commodity_type)
  # Include commodity  
  if (nrow(tech@input) != 0) {
    commodity_type[inp_com, 'comm'] <- tech@input$comm
    commodity_type[inp_com, 'type'] <- 'input'
    commodity_type[inp_com, 'group'] <- tech@input$group
    commodity_type[inp_com, 'unit'] <- tech@input$unit
  }
  if (nrow(tech@output) != 0) {
    commodity_type[out_com, 'comm'] <- tech@output$comm
    commodity_type[out_com, 'type'] <- 'output'
    commodity_type[out_com, 'group'] <- tech@output$group
    commodity_type[out_com, 'unit'] <- tech@output$unit
  }
  if (any(is.na(tech@ceff$comm)) || any(!(tech@ceff$comm %in% commodity_type$comm)))
      stop('Wrong commodity in comm ', tech@name)
  # Set CHP commodity
  if (tech@type == 'CHP') {
    if (sum(tech@output$type == 'ELC') != 1 || sum(tech@output$type == 'HET') != 1) 
        stop('Wrong CHP commodity ', tech@name)
    elc_com <- tech@output$comm[!is.na(tech@output$type) & tech@output$type == 'ELC']
    commodity_type[commodity_type$comm == elc_com, 'use'] <- 'elc'
    het_com <- tech@output$comm[!is.na(tech@output$type) & tech@output$type == 'HET']
    commodity_type[commodity_type$comm == het_com, 'use'] <- 'heat'   
    if (any(tech@ceff$comm == elc_com) || any(tech@ceff$comm == elc_com))   
    tmp <- tech@ceff$comm[
    apply(tech@ceff[, c('cinp2use', 'use2cout', 'cinpcap', 'coutcap', 'cinp2ginp', 'gout2cout')], 1, 
      function(x) any(!is.na(x)))]
    if (any(tmp == elc_com) || any(tmp == het_com)) 
      stop('Define unsuitable parameter for CHP commodity ', tech@name)
  } else {
    if (any(tech@output$type %in% c('ELC', 'HET'))) 
      stop('Define CHP parameter for non CHP technology ', tech@name)
  }
  # Check input output
  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinp2use', 'cinpcap', 'cinp2ginp')], 1, function(x) any(!is.na(x)))]
  if (any(tmp %in% out_com)) stop('Confuse input/output commodity')
  tmp <- tech@ceff$comm[apply(tech@ceff[, c('use2cout', 'coutcap', 'gout2cout')], 1, function(x) any(!is.na(x)))]
  if (any(tmp %in% inp_com)) stop('Confuse input/output commodity')
  # Check group/non group
  tmp <- tech@ceff$comm[
    apply(tech@ceff[, c('cinp2use', 'use2cout', 'cinpcap', 'coutcap')], 1, 
      function(x) any(!is.na(x)))]
  if (any(tmp %in% commodity_type[!is.na(commodity_type$group), 'comm'])) 
    stop('Confuse group/non group commodity ', tech@name)
  tmp <- tech@ceff$comm[
    apply(tech@ceff[, c('cinp2ginp', 'gout2cout', 'share.lo', 'share.fx', 'share.up')], 1, 
      function(x) any(!is.na(x)))]
  if (tech@type == 'CHP') {
    tmp <- tmp[tmp != elc_com]
    tmp <- tmp[tmp != het_com]
  }  
  if (any(tmp %in% commodity_type[is.na(commodity_type$group), 'comm']))    
    stop('Confuse group/non group commodity ', tech@name)
  # Check for non duplicate fix parameters
  if (anyDuplicated(c(lapply(c('cinp2use', 'use2cout', 'cinpcap', 'coutcap'), 
    function(x) unique(tech@ceff[!is.na(tech@ceff[, x]), 'comm'])), recursive = TRUE)) != 0) {
    stop('Duplicate fix parameters, see column cinp2use, use2cout, cinpcap, coutcap')
  }
  # Set activity/capacity commodity without gruop
  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinp2use', 'use2cout')], 1, function(x) any(!is.na(x)))]
  commodity_type[commodity_type$comm %in% tmp, 'use'] <- 'act'
  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinpcap', 'coutcap')], 1, function(x) any(!is.na(x)))]
  commodity_type[commodity_type$comm %in% tmp, 'use'] <- 'cap'
  
  # Chec input group and set commodity
  group <- unique(tech@input$group, na.rm = TRUE)
  if (anyDuplicated(c(lapply(c('ginp2use', 'ginpcap'), 
    function(x) unique(tech@geff[!is.na(tech@geff[, x]), 'group'])), recursive = TRUE)) != 0) {
    stop('Duplicate parameters, see column ginp2use, ginpcap')
  }
  cap_group <- unique(tech@geff[!is.na(tech@geff$ginpcap), 'group'])
  commodity_type[(commodity_type$type == 'input' & !is.na(commodity_type$group) 
    & commodity_type$group %in% cap_group), 'use'] <- 'cap'
  commodity_type[commodity_type$type == 'input' & !is.na(commodity_type$group) 
    & is.na(commodity_type$use), 'use'] <- 'act'

  
  # Chec output group and set commodity
  group <- unique(tech@output$group, na.rm = TRUE)
  if (anyDuplicated(c(lapply(c('use2gout', 'goutcap'), 
    function(x) unique(tech@geff[!is.na(tech@geff[, x]), 'group'])), recursive = TRUE)) != 0) {
    stop('Duplicate parameters, see column use2gout, goutcap')
  }
  cap_group <- unique(tech@geff[!is.na(tech@geff$goutcap), 'group'])
  commodity_type[(commodity_type$type == 'output' & !is.na(commodity_type$group) 
    & commodity_type$group %in% cap_group), 'use'] <- 'cap'
  commodity_type[commodity_type$type == 'output' & !is.na(commodity_type$group) 
    & is.na(commodity_type$use), 'use'] <- 'act'
  commodity_type[!is.na(commodity_type$group), 'use'] <- 'group'  
  commodity_type[, 'comb'] <- FALSE
  tech@input$combustion[is.na(tech@input$combustion)] <- TRUE
  commodity_type[commodity_type$comm %in% tech@input[tech@input$combustion == TRUE, 'comm'], 'comb'] <- TRUE
  commodity_type
}

get_input_group <- function(tech) {
  #tech@group$group[!is.na(tech@group$ginp2use) | !is.na(tech@group$ginpcap)] 
  zz <- unique(tech@input$group, na.rm = TRUE)
  if (all(is.na(zz))) NULL else zz
}

capacity_group <- function(tech) {
  tech@geff$group[!is.na(tech@geff$ginpcap) | !is.na(tech@geff$goutcap)] 
}

get_output_group <- function(tech) {
  #tech@group$group[!is.na(tech@group$use2gout) | !is.na(tech@group$goutcap)] 
  zz <- unique(tech@output$group, na.rm = TRUE)
  if (all(is.na(zz))) NULL else zz
}

set_group_type <- function(tech) {
 stop('Internal error, use another function from set_group_type to checkInpOut')
    g_type      = data.frame(#region     = character(),
                              group     = character(),
                              input     = logical(),
                              output    = logical(),
                              type      = factor(NULL, c('cap', 'act')),
                              stringsAsFactors = FALSE)
    grp <- unique(get_input_group(tech), get_output_group(tech))
    if (length(grp) == 0) {
      g_type  
    } else {
      g_type[1:length(grp), 'group'] <- grp
      g_type[, c('input', 'output')] <- FALSE     
      g_type[grp %in% get_input_group(tech), 'input'] <- TRUE
      g_type[grp %in% get_output_group(tech), 'output'] <- TRUE
      g_type[, 'type'] <- 'act'
      g_type[grp %in% capacity_group(tech), 'type'] <- 'cap'
      g_type
    }
}