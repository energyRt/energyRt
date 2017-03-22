#---------------------------------------------------------------------------------------------------------
# Fill table commodity_type and check for conflict type definition
checkInpOut <- function(tech) {
  ctype <- data.frame(type      = factor(NULL, c('input', 'output', 'aux')),
                      group     = character(),
                      comb      = numeric(),
                      unit      = character(),
                      stringsAsFactors = FALSE)
  # Define type commodity
  icomm <- tech@input$comm
  ocomm <- tech@output$comm
  acomm <- tech@aux$acomm
  comm <- c(icomm, ocomm, acomm)
  ctype[seq(along = comm), ] <- NA
  rownames(ctype) <- comm
  ctype[icomm, 'type'] <- 'input'
  ctype[ocomm, 'type'] <- 'output'
  ctype[acomm, 'type'] <- 'aux'
  ctype[icomm, c('group', 'unit')] <- tech@input[, c('group', 'unit')]
  ctype[ocomm, c('group', 'unit')] <- tech@output[, c('group', 'unit')]
  ctype[, 'comb'] <- 0  
  tech@input$combustion[is.na(tech@input$combustion)] <- 1
  ctype[tech@input$comm, 'comb'] <- tech@input$combustion
  aux <- data.frame(input   = logical(),
                    output  = logical(),
                    stringsAsFactors = FALSE)
  if (length(acomm)) {
    aux[seq(along = acomm), ] <- FALSE
    rownames(aux) <- acomm
  }
  #  Check type
  #! have to realised 
  if (length(icomm) == 0 && length(ocomm) == 0) 
    warnings('There is no input & output commodity')
 
  # Define technology type by parameter
  for(i in comm) {
    # Group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("cinp2ginp", "share.lo", 
      "share.up", "share.fx")]))) {
        if (is.na(ctype[i, 'group'])) stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Not group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, 'cinp2use']))) {
      if (!is.na(ctype[i, 'group'])) stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Input ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("cinp2use", "cinp2ginp")]))) {
      if (ctype[i, 'type'] != 'input') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Output ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("use2cact", "cact2cout", 
       "afac.lo", "afac.up", "afac.fx")]))) {
      if (ctype[i, 'type'] != 'output') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Aux ?
    if (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'act2aout', 
              'use2ainp', 'use2aout', 'cap2ainp', 'cap2aout', 'ncap2ainp', 'ncap2aout')])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp', 
              'cinp2aout', 'cout2ainp', 'cout2aout')]))) {
      if (ctype[i, 'type'] != 'aux') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
  }
  for(i in acomm) {
    aux[i, 'input'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'use2ainp', 'cap2ainp', 'ncap2ainp')])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp', 'cout2ainp')]))) 
    aux[i, 'output'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2aout', 'use2aout', 'cap2aout', 'ncap2aout')])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2aout', 'cout2aout')]))) 
  }
  gtype <- data.frame(type      = factor(NULL, c('input', 'output')),
                      stringsAsFactors = FALSE)
                      
  # Define type group
  group <- unique(c(tech@geff$group, tech@geff$geff, 
                    tech@group$group, tech@group$geff, 
                    tech@input$group, tech@output$group))
  group <- group[!is.na(group)]
  if (length(group) != 0) {
    if (any(is.na(c(tech@group$group, tech@group$geff)))) 
        stop('There is NA group in technology "', tech@name, '"')
    gtype[seq(along = group), ] <- NA
    rownames(gtype) <- group
   for(i in unique(tech@geff$group)) {
     if (any(!is.na(tech@geff[tech@geff$group == i, 'ginp2use']))) {
       if (!is.na(gtype[i, 'type']) && gtype[i, 'type'] == 'output') 
          stop('Wrong group in technology "', tech@name, '": "', i, '"')
       gtype[i, 'type'] <- 'input'   
     }
   }
   for(i in group) {
     jj <- rownames(ctype)[!is.na(ctype$group) & ctype$group == i]
     if (length(jj) != 0) {
       if (any(ctype[jj, 'type'] == 'input')) {
         if (!is.na(gtype[i, 'type']) && gtype[i, 'type'] == 'output') 
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
         gtype[i, 'type'] <- 'input'   
       }
       if (any(ctype[jj, 'type'] == 'output')) {
         if (!is.na(gtype[i, 'type']) && gtype[i, 'type'] == 'input') 
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
         gtype[i, 'type'] <- 'output'   
       }
     }
   }
   if (any(is.na(gtype[, 'type'])))
     stop('Wrong group in technology "', tech@name, '": "', 
        paste(rownames(gtype)[is.na(gtype[, 'type'])], collapse = '", "'), '"')
  }
  fcmd <- c(tech@ceff$comm, tech@aeff$comm[!is.na(tech@aeff$comm)], tech@aeff$acomm)
  fcmd <- fcmd[!(fcmd %in% c(tech@input$comm, tech@output$comm, tech@aux$acomm))]
  if (length(fcmd) != 0)
     stop('Unknow commodity in technology (there is not definition in input, output or aux) "', 
        tech@name, '": ', paste(fcmd, collapse = '", "'), '"')                                  
  list(comm = ctype, group = gtype, aux = aux)
}

#gg <- lapply(technology, function(tech) if (length(c(tech@geff$group, tech@geff$geff, 
#                    tech@group$group, tech@group$geff, 
#                    tech@input$group, tech@output$geff)) == 0) checkInpOut(tech))
#  
#  

#  
#sapply(technology, function(x) { 
#  if (length(c(x@group$group, x@geff$group, x@input$group, x@output$group)) != 0) {
#    if (any((x@input$group %in% x@output$group)[!is.na(x@input$group)]) 
#      || any((x@output$group %in% x@input$group)[!is.na(x@output$group)])) {
#      tt <<- x
#      stop()
#    }
#    gr <- c(x@input$group, x@output$group)
#    gr <- gr[!is.na(gr)]
#    if (length(gr) != 0 && !all(c(x@group$group, x@geff$group) %in% gr)) {
#      tt <<- x
#      stop()
#    }
#    unique(c(x@group$group, x@geff$group))
#  }
#})
 
  
# 
#  # Dump check
#  if (any(is.na(comm)))
#      stop('There is NA commodity in input/output ', tech@name)
#  if (anyDuplicated(comm) != 0)
#      stop('There are duplicated commodity in input/output')
#  # Check activity & non activity output commodity and set activity commodity flag
#  ctype[, 'act'] <- FALSE
#  for(i in ocomm) {
#    fl <- apply(!is.na(tech@ceff[tech@ceff$comm == i, c('use2aout', 'use2cact', 'cact2cout'), 
#      drop = FALSE]), 2, any)
#    if (fl[2] != fl[3] || fl[1] == fl[2])
#        stop('There is ativity & non activity output commodity simultaneously ', 
#          '(or there is no data att all) in technology "', tech@name, '"')
#    if (fl[2]) ctype[i, 'act'] <- TRUE
#  }
#  # Check for any activity commodity
#  if (all(!ctype[, 'act'])) 
#      stop('There is no activity commodity in technology "', tech@name, '"')
###  # Check group with activity and non-activity commodity
###  gtype[i, 'outact'] <- FALSE
###  cctype <- ctype[ocomm[!is.na(ctype[ocomm, 'group'])],, drop = FALSE]
###  if (nrow(cctype) != 0) {
###    for(i in group) {
###      tt <- cctype[cctype[, 'group'] == i, 'act']
###      if (!all(tt) && !all(!tt)) stop('There is group with activity & non-activity', 
###             ' commodity in technology "', tech@name, '"')
###      gtype[i, 'act'] <- tt[1]
###    }
###  }
#  
#  # Check input atribute for output commodity & vice versa
#  if (any(!is.na(tech@ceff[tech@ceff$comm %in% ocomm, 
#    c('cinp2use', 'cinpcap', 'cinp2ginp')])))
#      stop('There are input atribute for output commodity in technology "', tech@name, '"')
#  if (any(!is.na(tech@ceff[tech@ceff$comm %in% icomm, c('use2aout', 'use2cact', 
#    'cact2cout', 'coutcap', 'afac.lo', 'afac.up', 'afac.fx')])))
#      stop('There are output atribute for input commodity in technology "', tech@name, '"')
#  # Check group atribute for single commodity & vice versa
#  if (any(!is.na(tech@ceff[tech@ceff$comm %in% comm[!is.na(ctype$group)], 
#    c('cinp2use', 'cinpcap', 'coutcap')])))
#      stop('There are group atribute for single commodity "', tech@name, '"')
#  if (any(!is.na(tech@ceff[tech@ceff$comm %in% comm[is.na(ctype$group)], 
#    c('cinp2ginp', 'share.lo', 'share.up', 'share.fx')])))
#      stop('There are single atribute for group commodity "', tech@name, '"')
#
#  # Check and set group have input or output commodity
#  if ()
#      
#
#
#  ceff_param <- c('cinp2use', 'use2aout', 'use2cact', 'cact2cout', 'cinpcap',
#                 'coutcap', 'cinp2ginp', 'share.lo', 'share.up',
#                 'share.fx', 'afac.lo', 'afac.up', 'afac.fx')
#
#  ceff_group <- c('cinp2use', 'use2aout', 'use2cact', 'cact2cout', 'cinpcap',
#                 'coutcap', 'cinp2ginp', 'share.lo', 'share.up',
#                 'share.fx', 'afac.lo', 'afac.up', 'afac.fx')
#
#  tpp <- array(FALSE, dim = c(length(comm), length(ceff_param)), dimnames = list(comm, ceff_param))
#  for(i in comm)
#    tpp[i, ] <- apply(tech@ceff[tech@ceff$comm == i,
#       ceff_param, drop = FALSE], 2, function(x) any(!is.na(x)))
#
#
#  if (nrow(tech@input) == 0)  inp_com <- 0 else inp_com <- 1:nrow(tech@input)
#  if (nrow(tech@output) == 0) out_com <- max(inp_com) + 0 else out_com <- max(inp_com) + 1:nrow(tech@output)
#  if (nrow(tech@input) == 0 && nrow(tech@output) == 0) return(commodity_type)
#  # Include commodity
#  if (nrow(tech@input) != 0) {
#    commodity_type[inp_com, 'comm'] <- tech@input$comm
#    commodity_type[inp_com, 'type'] <- 'input'
#    commodity_type[inp_com, 'group'] <- tech@input$group
#    commodity_type[inp_com, 'unit'] <- tech@input$unit
#  }
#  if (nrow(tech@output) != 0) {
#    commodity_type[out_com, 'comm'] <- tech@output$comm
#    commodity_type[out_com, 'type'] <- 'output'
#    commodity_type[out_com, 'group'] <- tech@output$group
#    commodity_type[out_com, 'unit'] <- tech@output$unit
#  }
#  if (any(is.na(tech@ceff$comm)) || any(!(tech@ceff$comm %in% commodity_type$comm)))
#      stop('Wrong commodity in comm ', tech@name)
#  # Set CHP commodity
#  if (tech@type == 'CHP') {
#    if (sum(tech@output$type == 'ELC') != 1 || sum(tech@output$type == 'HET') != 1)
#        stop('Wrong CHP commodity ', tech@name)
#    elc_com <- tech@output$comm[!is.na(tech@output$type) & tech@output$type == 'ELC']
#    commodity_type[commodity_type$comm == elc_com, 'use'] <- 'elc'
#    het_com <- tech@output$comm[!is.na(tech@output$type) & tech@output$type == 'HET']
#    commodity_type[commodity_type$comm == het_com, 'use'] <- 'heat'
#    if (any(tech@ceff$comm == elc_com) || any(tech@ceff$comm == elc_com))
#    tmp <- tech@ceff$comm[
#    apply(tech@ceff[, c('cinp2use', 'use2aout', 'cinpcap', 'coutcap', 'cinp2ginp', 'gout2cout')], 1,
#      function(x) any(!is.na(x)))]
#    if (any(tmp == elc_com) || any(tmp == het_com))
#      stop('Define unsuitable parameter for CHP commodity ', tech@name)
#  } else {
#    if (any(tech@output$type %in% c('ELC', 'HET')))
#      stop('Define CHP parameter for non CHP technology ', tech@name)
#  }
#  # Check input output
#  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinp2use', 'cinpcap', 'cinp2ginp')], 1, function(x) any(!is.na(x)))]
#  if (any(tmp %in% out_com)) stop('Confuse input/output commodity')
#  tmp <- tech@ceff$comm[apply(tech@ceff[, c('use2aout', 'coutcap', 'gout2cout')], 1, function(x) any(!is.na(x)))]
#  if (any(tmp %in% inp_com)) stop('Confuse input/output commodity')
#  # Check group/non group
#  tmp <- tech@ceff$comm[
#    apply(tech@ceff[, c('cinp2use', 'use2aout', 'cinpcap', 'coutcap')], 1,
#      function(x) any(!is.na(x)))]
#  if (any(tmp %in% commodity_type[!is.na(commodity_type$group), 'comm']))
#    stop('Confuse group/non group commodity ', tech@name)
#  tmp <- tech@ceff$comm[
#    apply(tech@ceff[, c('cinp2ginp', 'gout2cout', 'share.lo', 'share.fx', 'share.up')], 1,
#      function(x) any(!is.na(x)))]
#  if (tech@type == 'CHP') {
#    tmp <- tmp[tmp != elc_com]
#    tmp <- tmp[tmp != het_com]
#  }
#  if (any(tmp %in% commodity_type[is.na(commodity_type$group), 'comm']))
#    stop('Confuse group/non group commodity ', tech@name)
#  # Check for non duplicate fix parameters
#  if (anyDuplicated(c(lapply(c('cinp2use', 'use2aout', 'cinpcap', 'coutcap'),
#    function(x) unique(tech@ceff[!is.na(tech@ceff[, x]), 'comm'])), recursive = TRUE)) != 0) {
#    stop('Duplicate fix parameters, see column cinp2use, use2aout, cinpcap, coutcap')
#  }
#  # Set activity/capacity commodity without gruop
#  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinp2use', 'use2aout')], 1, function(x) any(!is.na(x)))]
#  commodity_type[commodity_type$comm %in% tmp, 'use'] <- 'act'
#  tmp <- tech@ceff$comm[apply(tech@ceff[, c('cinpcap', 'coutcap')], 1, function(x) any(!is.na(x)))]
#  commodity_type[commodity_type$comm %in% tmp, 'use'] <- 'cap'
#
#  # Chec input group and set commodity
#  group <- unique(tech@input$group, na.rm = TRUE)
#  if (anyDuplicated(c(lapply(c('ginp2use', 'ginpcap'),
#    function(x) unique(tech@geff[!is.na(tech@geff[, x]), 'group'])), recursive = TRUE)) != 0) {
#    stop('Duplicate parameters, see column ginp2use, ginpcap')
#  }
#  cap_group <- unique(tech@geff[!is.na(tech@geff$ginpcap), 'group'])
#  commodity_type[(commodity_type$type == 'input' & !is.na(commodity_type$group)
#    & commodity_type$group %in% cap_group), 'use'] <- 'cap'
#  commodity_type[commodity_type$type == 'input' & !is.na(commodity_type$group)
#    & is.na(commodity_type$use), 'use'] <- 'act'
#
#
#  # Chec output group and set commodity
#  group <- unique(tech@output$group, na.rm = TRUE)
#  if (anyDuplicated(c(lapply(c('use2gout', 'goutcap'),
#    function(x) unique(tech@geff[!is.na(tech@geff[, x]), 'group'])), recursive = TRUE)) != 0) {
#    stop('Duplicate parameters, see column use2gout, goutcap')
#  }
#  cap_group <- unique(tech@geff[!is.na(tech@geff$goutcap), 'group'])
#  commodity_type[(commodity_type$type == 'output' & !is.na(commodity_type$group)
#    & commodity_type$group %in% cap_group), 'use'] <- 'cap'
#  commodity_type[commodity_type$type == 'output' & !is.na(commodity_type$group)
#    & is.na(commodity_type$use), 'use'] <- 'act'
#  commodity_type[!is.na(commodity_type$group), 'use'] <- 'group'
#  commodity_type[, 'comb'] <- FALSE
#  tech@input$combustion[is.na(tech@input$combustion)] <- TRUE
#  commodity_type[commodity_type$comm %in% tech@input[tech@input$combustion == TRUE, 'comm'], 'comb'] <- TRUE
#  commodity_type
#}
#

