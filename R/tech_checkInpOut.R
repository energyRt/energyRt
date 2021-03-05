#---------------------------------------------------------------------------------------------------------
# Fill table commodity_type and check for conflict type definition
checkInpOut <- function(tech) {
  ctype <- data.table(type      = factor(NULL, c('input', 'output', 'aux')),
                      group     = character(),
                      comb      = numeric(),
                      unit      = character(),
                      stringsAsFactors = FALSE)
  # Define type commodity
  icomm <- tech@input$comm
  ocomm <- tech@output$comm
  acomm <- tech@aux$acomm
  comm <- c(icomm, ocomm, acomm)
  comm_ind <- seq_along(comm)
  names(comm_ind) <- comm
  ctype[seq(along = comm), ] <- NA

  icomm2 <- comm_ind[icomm]
  ocomm2 <- comm_ind[ocomm]
  acomm2 <- comm_ind[acomm]
  
  ctype$type[icomm2] <- 'input'
  ctype$type[ocomm2] <- 'output'
  ctype$type[acomm2] <- 'aux'
  
  ctype$group[icomm2] <- tech@input$group
  ctype$unit[icomm2] <- tech@input$unit

  ctype$group[ocomm2] <- tech@output$group
  ctype$unit[ocomm2] <- tech@output$unit

  ctype$comb <- 0  
  tech@input$combustion[is.na(tech@input$combustion)] <- 1
  ctype$comb[icomm2] <- tech@input$combustion
  
  aux <- data.table(input   = logical(),
                    output  = logical(),
                    stringsAsFactors = FALSE)
  if (length(acomm)) {
    aux <- data.table(input   = rep(FALSE, length(acomm)),
                    output  = rep(FALSE, length(acomm)))
    acomm_ind <- seq_along(acomm)
    names(acomm_ind) <- acomm
  }
  #  Check type
  #! have to realised 
  if (length(icomm) == 0 && length(ocomm) == 0) 
    warnings('There is no input & output commodity')
 
  # Define technology type by parameter
  for(i in comm) {
    # Group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("cinp2ginp", "share.lo", 
      "share.up", "share.fx"), with = FALSE]))) {
        if (is.na(ctype[comm_ind[i], 'group'])) stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Not group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, 'cinp2use', with = FALSE]))) {
      if (!is.na(ctype[comm_ind[i], 'group'])) stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Input ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("cinp2use", "cinp2ginp"), with = FALSE]))) {
      if (ctype[comm_ind[i], 'type'] != 'input') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Output ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("use2cact", "cact2cout"# , "afc.lo", "afc.up", "afc.fx"
       ), with = FALSE]))) {
      if (ctype[comm_ind[i], 'type'] != 'output') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Aux ?
    if (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'act2aout', 
              'cap2ainp', 'cap2aout', 'ncap2ainp', 'ncap2aout'), with = FALSE])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp', 
              'cinp2aout', 'cout2ainp', 'cout2aout'), with = FALSE]))) {
      if (ctype[comm_ind[i], 'type'] != 'aux') stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
  }
  for(i in acomm) {
    aux[acomm_ind[i], 'input'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2ainp', 'cap2ainp', 'ncap2ainp'), with = FALSE])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2ainp', 'cout2ainp'), with = FALSE]))) 
    aux[acomm_ind[i], 'output'] <- (any(!is.na(tech@aeff[tech@aeff$acomm == i, c('act2aout', 'cap2aout', 'ncap2aout'), with = FALSE])) || 
        any(!is.na(tech@aeff[tech@aeff$acomm == i, c('cinp2aout', 'cout2aout'), with = FALSE]))) 
  }
                      
  # Define type group
  gtype <- data.table(type = factor(NULL, c('input', 'output')))
  group <- unique(c(tech@geff$group, tech@geff$geff, 
                    tech@group$group, tech@group$geff, 
                    tech@input$group, tech@output$group))
  group <- unique(group[!is.na(group)])
  if (length(group) != 0) {
    if (any(is.na(c(tech@group$group, tech@group$geff)))) 
        stop('There is NA group in technology "', tech@name, '"')

   gtype <- data.table(group = group, type = factor(rep(NA, length(group)), c('input', 'output')))
   
   for(i in unique(tech@geff$group)) {
     if (any(!is.na(tech@geff[tech@geff$group == i, 'ginp2use']))) {
       if (!is.na(gtype$type[i]) && gtype$type[i] == 'output') 
          stop('Wrong group in technology "', tech@name, '": "', i, '"')
       gtype$type[i] <- 'input'   
     }
   }
   for(i in seq_along(group)) {
     jj <- comm_ind[!is.na(ctype$group) & ctype$group == group[i]]
     if (length(jj) != 0) {
       if (any(ctype$type[jj] == 'input')) {
         if (!is.na(gtype$type[i]) && gtype$type[i] == 'output') 
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
         gtype$type[i] <- 'input'   
       }
       if (any(ctype[jj, 'type'] == 'output')) {
         if (!is.na(gtype$type[i]) && gtype$type[i] == 'input') 
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
         gtype$type[i] <- 'output'   
       }
     }
   }
   if (any(is.na(gtype$type)))
     stop('Wrong group in technology "', tech@name, '": "', 
        paste(group[is.na(gtype$type)], collapse = '", "'), '"')
  }
  fcmd <- c(tech@ceff$comm, tech@aeff$comm[!is.na(tech@aeff$comm)], tech@aeff$acomm)
  fcmd <- fcmd[!(fcmd %in% c(tech@input$comm, tech@output$comm, tech@aux$acomm))]
  if (length(fcmd) != 0)
     stop('Unknow commodity in technology (there is not definition in input, output or aux) "', 
        tech@name, '": ', paste(fcmd, collapse = '", "'), '"')                                  
  list(comm = ctype, group = gtype, aux = aux)
}


 
  
