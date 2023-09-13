[moved to class_technology.R]
# Fill table commodity_type and check for conflicts type definition
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
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("use2cact", "cact2cout"# , "afc.lo", "afc.up", "afc.fx"
       )]))) {
      if (ctype[i, 'type'] != 'output') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Aux ?
    if (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'act2aout',
              'cap2ainp', 'cap2aout', 'ncap2ainp', 'ncap2aout')])) ||
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp',
              'cinp2aout', 'cout2ainp', 'cout2aout')]))) {
      if (ctype[i, 'type'] != 'aux') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
  }
  for(i in acomm) {
    aux[i, 'input'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'cap2ainp', 'ncap2ainp')])) ||
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp', 'cout2ainp')])))
    aux[i, 'output'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2aout', 'cap2aout', 'ncap2aout')])) ||
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




