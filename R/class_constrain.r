#---------------------------------------------------------------------------------------------------------
# Constrain
#---------------------------------------------------------------------------------------------------------
setClass('constrain', 
      representation(
          name          = "character",
          description   = "character",
          #variable      = "character",
          #gamsVariable  = "character",
          eq            = "factor",
          type          = "factor",
          rhs           = "data.frame",
          unit          = "character",
          for.sum        = "list",
          for.each       = "list",
          defVal       = "numeric", 
          rule          = "character",
          comm          = "character",
          cout          = "logical",
          cinp          = "logical",
          aout          = "logical",
          ainp          = "logical",
          emis          = "logical",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          #variable      = "",
          #gamsVariable  = "",
          eq            = factor('==', levels = c('>=', '<=', '==')),
          type          = factor(NA, levels = c('capacity', 
                                                'newcapacity', 
                                                'invcost', 
                                                'varom', 
                                                'fixom', 
                                                'eac', 
                                                'activity', 
                                                'actvarom', 
                                                'balance', 
                                                'cvarom', 
                                                'avarom', 
                                                'input', 
                                                'output',
                                                'sharein',
                                                'shareout',
                                                'tax',
                                                'subsidy',
                                                'growth.cap',  # >= meen minimum growth temp
                                                'growth.newcap', 
                                                'growth.output', 
                                                'growth.input', 
                                                'growth.eac', 
                                                'growth.invcost', 
                                                'growth.fixom', 
                                                'growth.varom', 
                                                'growth.actvarom', 
                                                'growth.cvarom', 
                                                'growth.avarom', 
                                                'growth.balance', 
                                                'growth.activity'
                                                )),
          rhs           = data.frame(),
          unit          = "",
          for.sum       = list(),
          for.each      = list(),
          defVal       = 0, 
          rule          = as.character('inter.forth'),
          comm          = NULL,
          cout          = TRUE,
          cinp          = TRUE,
          aout          = TRUE,
          ainp          = TRUE,
          emis          = TRUE,
          GIS           = NULL,
        #! Misc
        misc = list(
        )),
      S3methods = TRUE
);

setMethod("initialize", "constrain", function(.Object, ...) {
  attr(.Object, 'GUID') <- '0c9e0d17-222c-481e-8796-bbed7b0c0cc8'
  .Object
})
             
#----------------------------------------------------------------------------------
#' Create new constrain object
#' 
#' @name newConstrain
#' 
newConstrain0 <- function(name, type, eq = '==', rhs = 0, for.sum = list(), 
   for.each = list(), defVal = 0, rule = NULL, comm = NULL,
    cout = TRUE, cinp = TRUE, aout = TRUE, ainp = TRUE, emis = TRUE) {
  obj <- new('constrain')
  #stopifnot(length(eq) == 1 && eq %in% levels(obj@eq))
  if (length(eq) != 1 || !(eq %in% levels(obj@eq)))   {
    stop('Wrong condition type')
  }
  obj@eq[] <- eq
  # TYPE vs SET   
  if (length(type) != 1 || !(type %in% levels(obj@type)))
    stop('Wrong type')
  if (!is.null(rule)) obj@rule[]     <- rule
  obj@type[] <- type
  obj@defVal  <- defVal
  obj@name     <- name
  obj@cout     <- cout
  obj@cinp     <- cinp
  obj@aout     <- aout
  obj@ainp     <- ainp
  obj@emis     <- emis
  if (type == 'tax') {
      obj@comm     <- comm
      # if (rule == 'defVal')  rule <- 'inter.forth'
      # obj@rule     <- rule
      obj@rhs <- data.frame(region = character(), 
                              year = numeric(), 
                              slice = character(), 
                              tax = numeric(), 
                              stringsAsFactors = FALSE
                              )
      if (is.data.frame(rhs)) {
        if (nrow(rhs) == 0) stop('Wrong rhs in tax constrain')
        nn <- 1:nrow(rhs)
        if (any(colnames(rhs) == 'region')) 
            obj@rhs[nn, 'region'] <- as.character(rhs$region)
        if (any(colnames(rhs) == 'year')) 
            obj@rhs[nn, 'year'] <- as.numeric(rhs$year)
        if (any(colnames(rhs) == 'slice')) 
            obj@rhs[nn, 'slice'] <- as.character(rhs$slice)
        if (any(colnames(rhs) == 'tax')) {
            obj@rhs[nn, 'tax'] <- as.numeric(rhs$tax)
        } else stop('Wrong rhs in tax constrain')
      } else{
        obj@rhs[1, 'tax'] <- rhs
      }
      if (length(for.sum) != 0) warning('for.sum unacceptable for tax constrain')
      if (length(for.each) != 0) {
        uncpt <- names(for.each)[!(names(for.each) %in% c('comm', 'region', 'year', 'slice'))]
        if (any(uncpt)) {
          for.each <- for.each[!(names(for.each) %in% uncpt)]
          warning('for.each unacceptable for tax constrain')
        }
        obj@for.each <- for.each
      }
   } else if (type == 'subsidy') {
      obj@comm     <- comm
      # if (rule == 'defVal')  rule <- 'inter.forth'
      # obj@rule     <- rule
      obj@rhs <- data.frame(region = character(), 
                              year = numeric(), 
                              slice = character(), 
                              subsidy = numeric(), 
                              stringsAsFactors = FALSE
                              )
      if (is.data.frame(rhs)) {
        if (nrow(rhs) == 0) stop('Wrong rhs in subsidy constrain')
        nn <- 1:nrow(rhs)
        if (any(colnames(rhs) == 'region')) 
            obj@rhs[nn, 'region'] <- as.character(rhs$region)
        if (any(colnames(rhs) == 'year')) 
            obj@rhs[nn, 'year'] <- as.numeric(rhs$year)
        if (any(colnames(rhs) == 'slice')) 
            obj@rhs[nn, 'slice'] <- as.character(rhs$slice)
        if (any(colnames(rhs) == 'subsidy')) {
            obj@rhs[nn, 'subsidy'] <- as.numeric(rhs$subsidy)
        } else stop('Wrong rhs in subsidy constrain')
      } else{
        obj@rhs[1, 'subsidy'] <- rhs
      }
      if (length(for.sum) != 0) warning('for.sum unacceptable for subs constrain')
      if (length(for.each) != 0) {
        uncpt <- names(for.each)[!(names(for.each) %in% c('comm', 'region', 'year', 'slice'))]
        if (any(uncpt)) {
          for.each <- for.each[!(names(for.each) %in% uncpt)]
          warning('for.each unacceptable for subs constrain')
        }
        obj@for.each <- for.each
      }
  } else {
#      if (rule == 'defVal')  rule <- 'back.inter.forth'
#      if (rule == 'defVal')  rule <- new('constrain')@rule
#      obj@rule     <- rule
      minset <- list()
      minset$capacity <- c('region', 'year')
      minset$newcapacity <- c('region', 'year')
      minset$invcost <- c('region', 'year')
      minset$fixom <- c('region', 'year')
      minset$varom <- c('region', 'year', 'slice')
      minset$actvarom <- c('region', 'year', 'slice')
      minset$cvarom <- c('region', 'year', 'slice')
      minset$avarom <- c('region', 'year', 'slice')
      minset$eac <- c('region', 'year')
      minset$activity <- c('region', 'year', 'slice')
      minset$input <- c('comm', 'region', 'year', 'slice')
      minset$output <- c('comm', 'region', 'year', 'slice')
      minset$sharein <- c('comm', 'region', 'year', 'slice')
      minset$shareout <- c('comm', 'region', 'year', 'slice')
      minset$balance <- c('comm', 'region', 'year', 'slice')
      
      minset$growth.capacity <- c('region', 'year')
      minset$growth.newcapacity <- c('region', 'year')
      minset$growth.invcost <- c('region', 'year')
      minset$growth.varom <- c('region', 'year', 'slice')
      minset$growth.actvarom <- c('region', 'year', 'slice')
      minset$growth.avarom <- c('region', 'year', 'slice')
      minset$growth.cvarom <- c('region', 'year', 'slice')
      minset$growth.fixom <- c('region', 'year')
      minset$growth.eac <- c('region', 'year')
      minset$growth.activity <- c('region', 'year', 'slice')
      minset$growth.input <- c('comm', 'region', 'year', 'slice')
      minset$growth.output <- c('comm', 'region', 'year', 'slice')
      minset$growth.balance <- c('region', 'year', 'slice')
      
      addset <- list()
      addset$input <- c('tech', 'sup', 'res', 'trade', 'row')
      addset$output <- c('tech', 'sup', 'res', 'trade', 'row')

      addset$growth.input <- c('tech', 'sup', 'res', 'trade', 'row')
      addset$growth.output <- c('tech', 'sup', 'res', 'trade', 'row')

      addset$sharein <- c('tech', 'sup', 'res', 'trade', 'row')
      addset$shareout <- c('tech', 'sup', 'res', 'trade', 'row')

      unqset <- list()
      unqset$capacity <- c('tech', 'res')
      unqset$newcapacity <- c('tech', 'res')
      unqset$invcost <- c('tech', 'res')
      unqset$fixom <- c('tech', 'res')
      unqset$varom <- c('tech', 'res')
      unqset$actvarom <- c('tech', 'res')
      unqset$cvarom <- c('tech', 'res')
      unqset$avarom <- c('tech', 'res')
      unqset$eac <- c('tech', 'res')
      unqset$activity <- c('tech', 'res')

      unqset$growth.capacity <- c('tech', 'res')
      unqset$growth.newcapacity <- c('tech', 'res')
      unqset$growth.invcost <- c('tech', 'res')
      unqset$growth.fixom <- c('tech', 'res')
      unqset$growth.varom <- c('tech', 'res')
      unqset$growth.actvarom <- c('tech', 'res')
      unqset$growth.cvarom <- c('tech', 'res')
      unqset$growth.avarom <- c('tech', 'res')
      unqset$growth.eac <- c('tech', 'res')
      unqset$growth.activity <- c('tech', 'res')

      # Check duplicat set
      if (anyDuplicated(c(names(for.sum), names(for.each)))) {
        stop('There are duplicated set')
      }
      # Check odd set
      if (any(!(c(names(for.sum), names(for.each)) %in% 
        c(minset[[as.character(type)]], addset[[as.character(type)]], 
             unqset[[as.character(type)]])))) {  
        stop('There are odd set')
      }
      # Check minimum set
      tps <- minset[[as.character(type)]]
      if (any(!(tps %in% c(names(for.sum), names(for.each))))) {
        for(i in tps[!(tps %in% c(names(for.sum), names(for.each)))])
          for.each[i] <- list(NULL)
      }
      ### HAVE TO FIX
      # Check additional set
    #  if (length(addset[[as.character(type)]]) != 0 && 
    #  # For future
    #  #  !any(c(names(for.sum), names(for.each)) %in% addset[[as.character(type)]])) {
    #    sum(c(names(for.sum), names(for.each)) %in% addset[[as.character(type)]]) != 1) {
    #    stop('Wrong set sets')
    #    #stop('There is not minimum additional set')
    #  }
      # Check unique set
      if (length(unqset[[as.character(type)]]) != 0 && 
        sum(c(names(for.sum), names(for.each)) %in% unqset[[as.character(type)]]) != 1) {
        stop('Wrong set sets')
      }
      obj@rhs <- data.frame(tech = character(), 
                              trade = character(), 
                              row = character(), 
                              res = character(), 
                              sup = character(), 
                              comm = character(), 
                              region = character(), 
                              year = numeric(), 
                              slice = character(), 
                              rhs = numeric(), 
                              stringsAsFactors = FALSE
                              )
      obj@rhs <- obj@rhs[colnames(obj@rhs) %in% c(names(for.each), 'rhs')]
      if (is.list(rhs) && !is.data.frame(rhs)) {
        rhs2 <- data.frame(stringsAsFactors = FALSE)
        rhs2[1:max(sapply(rhs, length)), ] <- NA
        for(i in names(rhs)) rhs2[, i] <- rhs[[i]]
        rhs <- rhs2
      }
      if (is.numeric(rhs)) {
        obj@defVal <- rhs
      } else if (is.data.frame(rhs)) {
        if (any(!(colnames(rhs) %in% colnames(obj@rhs)))) 
          stop('Uncorrect rhs column name')
        if (nrow(rhs) != 0) {
          obj@rhs[1:nrow(rhs), ] <- NA
          for(cl in colnames(rhs))
            obj@rhs[, cl] <- rhs[, cl]
        }
      } else stop('Uncorrect rhs type')
      #obj@variable <- variable
      #obj@gamsVariable <- paste(variable, '(', paste(ss, collapse = ', '), ')', sep = '')
      obj@for.each  <- for.each
      obj@for.sum   <- for.sum
      if (!energyRt:::.chec_correct_name(name)) stop('Uncorrect constrain name "', name, '"') 
  } 
  # Remove factor problem
  for(i in colnames(obj@rhs)[sapply(obj@rhs, class) == 'factor']) {
    obj@rhs[, i] <- as.character(obj@rhs[, i])
    if (any(i == c('year', 'rhs'))) obj@rhs[, i] <- as.numeric(obj@rhs[, i])
  }
  for(i in colnames(obj@rhs)[colnames(obj@rhs) %in% c('year', 'rhs') &
    sapply(obj@rhs, class) == 'character']) {
    obj@rhs[, i] <- as.numeric(obj@rhs[, i])
  }
  for(i in names(obj@for.each)[sapply(obj@for.each, class) == 'factor']) {
    obj@for.each[[i]] <- as.character(obj@for.each[[i]])
  }
  for(i in names(obj@for.each)[names(obj@for.each) %in% c('year', 'rhs') &
    sapply(obj@for.each, class) == 'character'])
      obj@for.each[[i]] <- as.numeric(obj@for.each[[i]])
  for(i in names(obj@for.sum)[sapply(obj@for.sum, class) == 'factor']) {
    obj@for.sum[[i]] <- as.character(obj@for.sum[[i]])
  }
  for(i in names(obj@for.sum)[names(obj@for.sum) %in% c('year', 'rhs') &
    sapply(obj@for.sum, class) == 'character'])
      obj@for.sum[[i]] <- as.numeric(obj@for.sum[[i]])
  obj
}



##----------------------------------------------------------------------------------
#sm_toGams_constrain <- function(obj, approxim, year_range) {
#  eqDecFull <- NULL
#  add_code <- c()
#  add_set <- c()
#  eqDec <- c()
#  if (all(obj@type != c('tax', 'subsidy'))) {
#      # Add set
#      specSet <- list()
#      for(i in names(obj@for.each)[!sapply(obj@for.each, is.null)])
#        specSet[[i]] <- obj@for.each[[i]]   
#      for(i in names(obj@for.sum)[!sapply(obj@for.sum, is.null)])
#        specSet[[i]] <- obj@for.sum[[i]]   
#      aliasSet <- paste('alsCns', obj@name, names(specSet), sep = '')
#      aliasSetFull <- paste('alsCns', obj@name, names(specSet), '(', 
#           names(specSet), ')', sep = '')
#      names(aliasSetFull) <- names(specSet)
#      if (any(names(specSet) == 'year')) {
#        specSet$year <- specSet$year[year_range[1] <= as.numeric(specSet$year) &
#           as.numeric(specSet$year) <= year_range[2]]
#      } 
#      #
#      for(i in names(specSet)) {
#       add_code <- c(add_code, 'set', aliasSetFull[[i]], ';')
#       add_set <- c(add_set, 'set', paste(aliasSetFull[[i]], '/'), specSet[[i]], '/;')
#      }
#      #
#      tp <- as.character(obj@type)
#      # Add equation
#      eqDec <- paste('eqCns', obj@name, sep = '')
#      eqDecFull <- paste('eqCns', obj@name, '(', 
#        paste(names(obj@for.each), collapse = ', '), ')', sep = '')
#      eqDec2 <- eqDecFull
#      if (any(names(specSet) %in% names(obj@for.each))) {
#        if (sum(names(specSet) %in% names(obj@for.each)) != 1) {
#          eqDecFull <- paste(eqDecFull, '$(', paste(
#            aliasSetFull[names(aliasSetFull) %in% names(obj@for.each)], 
#              collapse = ' and '), ')', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, '$', 
#            aliasSetFull[names(aliasSetFull) %in% names(obj@for.each)], sep = '')
#        }
#      }
#      eqDecFull <- paste(eqDecFull, '.. ', sep = '')
#      # Add LHS
#      if (length(obj@for.sum) != 0) {
#        if (length(obj@for.sum) != 1) {
#          eqDecFull <- paste(eqDecFull, 'sum((', paste(names(obj@for.sum), 
#            collapse = ', '), ')', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, 'sum(', names(obj@for.sum), 
#           '', sep = '')
#        }
#        if (any(names(specSet) %in% names(obj@for.sum))) {
#          if (sum(names(aliasSetFull) %in% names(obj@for.sum)) != 1) {
#            eqDecFull <- paste(eqDecFull, '$(', 
#              paste(aliasSetFull[names(aliasSetFull) %in% names(obj@for.sum)], 
#                collapse = ' and '), ')', sep = '')
#          } else {
#            eqDecFull <- paste(eqDecFull, '$', 
#              aliasSetFull[names(aliasSetFull) %in% names(obj@for.sum)], sep = '')
#          }
#        }
#        eqDecFull <- paste(eqDecFull, ', ', sep = '')
#      }                                                  
#      # add variable
#      if (tp == 'input' && all(!(c(names(obj@for.sum), names(obj@for.each)) %in% 
#         c('tech', 'sup', 'res', 'trade', 'row')))) vrb <- 'vInpTot' else
#      if (tp == 'output' && all(!(c(names(obj@for.sum), names(obj@for.each)) %in% 
#         c('tech', 'sup', 'res', 'trade', 'row')))) vrb <- 'vOutTot' else {
#        gg <- c('tech', 'sup', 'res', 'trade', 'row')
#        g2 <- c('vTech', 'vSup', 'vRes', 'vTrade', 'vRow')
#        g3 <- c('Tech', 'Sup', 'Res', 'Trade', 'Row')
#        names(g2) <- gg   
#        names(g3) <- gg   
#        gg <- gg[gg %in% c(names(obj@for.sum), names(obj@for.each))]
#        if (length(gg) != 1) {
#          if (tp %in% c('sharein', 'shareout')) stop('Undefined LHS variable') else
#            stop('Internal error 1')
#        }
#        vrb <- g2[gg]
#        if (tp == 'capacity') vrb <- paste(vrb, 'Cap', sep = '') else
#        if (tp == 'newcapacity') vrb <- paste(vrb, 'NewCap', sep = '') else
#        if (tp == 'activity') vrb <- paste(vrb, 'Act', sep = '') else
#        if (tp %in% c('input', 'sharein')) vrb <- paste(vrb, 'Inp', sep = '') else
#        if (tp %in% c('output', 'shareout')) vrb <- paste(vrb, 'Out', sep = '')
#      } 
#      eqDecFull <- paste(eqDecFull, vrb, '(', 
#        paste(order_set(c(names(obj@for.sum), names(obj@for.each))), 
#          collapse = ', '), ')', sep = '')
#      if (tp %in% c('input', 'sharein', 'output', 'shareout') && 
#        !(vrb %in% c('vInpTot', 'vOutTot'))) {
#        eqDecFull <- paste(eqDecFull, '$m', g3[gg], sep = '')
#        if (tp %in% c('input', 'sharein')) {
#          eqDecFull <- paste(eqDecFull, 'InpComm', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, 'OutComm', sep = '')
#        }
#          hh <- c(names(obj@for.sum), names(obj@for.each))
#          hh <- hh[!(hh %in% c('region', 'year', 'slice'))]
#        eqDecFull <- paste(eqDecFull, '(',
#          paste(order_set(hh), collapse = ', '), ')', sep = '')
#      }
#      #  
#      if (length(obj@for.sum) != 0) {
#        eqDecFull <- paste(eqDecFull, ')', sep = '')
#      }
#      # Condition
#      if (obj@eq == '<=') eqDecFull <- paste(eqDecFull, ' =l= ', sep = '') else
#      if (obj@eq == '=') eqDecFull <- paste(eqDecFull, ' =e= ', sep = '') else
#      if (obj@eq == '>=') eqDecFull <- paste(eqDecFull, ' =g= ', sep = '') else
#        stop('Unknown equation type')
#      # RHS  
#      if (nrow(obj@rhs) == 0) {
#        if (tp %in% c('sharein', 'shareout')) {
#          if (tp == 'sharein') {
#            vv <- 'vInpTot(comm, region, year, slice)'
#          } else {
#            vv <- 'vOutTot(comm, region, year, slice)'
#          }          
#          eqDecFull <- paste(eqDecFull, obj@defVal, ' * ', vv, ';', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, obj@defVal, ';', sep = '')
#        }
#      } else {                                                               
#        gg <- obj@rhs
#        for(cl in colnames(gg)[colnames(gg) %in% names(approxim)])
#          gg[, cl] <- as.character(gg[, cl])
#        if (any(colnames(gg) == 'year')) gg[, 'year'] <- as.numeric(gg[, 'year'])
#        for (i in colnames(gg)[colnames(gg) %in% names(obj@for.each)]) {
#          if (!is.null(obj@for.each[[i]])) {
#            gg <- gg[is.na(gg[, i]) | gg[, i] %in% obj@for.each[[i]], , drop = FALSE]
#            approxim[[i]] <- approxim[[i]][approxim[[i]] %in% obj@for.each[[i]]]
#          }  
#        }
#        for (i in colnames(gg)[colnames(gg) %in% names(obj@for.sum)]) {
#          if (!is.null(obj@for.sum[[i]])) {
#            gg <- gg[is.na(gg[, i]) | gg[, i] %in% obj@for.sum[[i]], , drop = FALSE]
#            approxim[[i]] <- approxim[[i]][approxim[[i]] %in% obj@for.each[[i]]]
#          }  
#        }
#        rhs <- interpolation(gg, 'rhs', approxim = approxim, year_range = year_range,
#            rule = obj@rule, defVal = obj@defVal)  
#        prm <- paste('rhsCns', obj@name, '(', paste(colnames(rhs)[-ncol(rhs)], 
#           collapse = ', '), ')', sep = '')
#        if (tp == 'sharein' || tp == 'shareout') {
#          if (all(names(obj@for.each) != 'comm')) stop('There is no commodity definition to ', tp, ' type')
#          if (tp == 'sharein') {
#            vv <- 'vInpTot(comm, region, year, slice)'
#          } else {
#            vv <- 'vOutTot(comm, region, year, slice)'
#          }
#          if (all(c('comm', 'region', 'year', 'slice') %in% names(obj@for.each))) {
#            eqDecFull <- paste(eqDecFull, prm, ' * ', vv, ';', sep = '')
#          } else {      
#            qq <- c('comm', 'region', 'year', 'slice')[c('comm', 'region', 'year', 'slice') 
#                  %in% names(obj@for.sum)]
#            if (length(qq) == 1) {
#              eqDecFull <- paste(eqDecFull, 'sum(', qq, '', sep = '')
#            } else {
#              eqDecFull <- paste(eqDecFull, 'sum((', paste(qq, collapse = ', '), ')', sep = '')
#            }
#            q2 <- names(obj@for.sum[qq])[!sapply(obj@for.sum[qq], is.null)]
#            if (length(q2) == 1) {
#              eqDecFull <- paste(eqDecFull, '$', aliasSetFull[q2], '', sep = '')
#            } else if (length(q2) > 1) {
#              eqDecFull <- paste(eqDecFull, '$(', paste(aliasSetFull[q2], collapse = ' and '), ')', sep = '')
#            }
#            eqDecFull <- paste(eqDecFull, ', ', prm, ' * ', vv, ');', sep = '')
#          }
#        } else {
#            eqDecFull <- paste(eqDecFull, prm, ';', sep = '')
#        }
#        add_set <- c(add_set, 'parameter', paste(prm, '/'), paste(
#        apply(rhs[, -ncol(rhs), drop = FALSE], 1, function(x) paste(x, collapse = '.'))
#        , rhs[, ncol(rhs)]), '/;')
#        add_code <- c(add_code, 'parameter', prm, ';')
#      }  
#      add_code <- c(add_code, 'Equation', eqDec, ';', '', eqDecFull)
#      #cat(eqDecFull, '\n')
#  }
#  debug_code <- function(xx) {
#    nm <- gsub('[($].*', '', gsub('[.][.].*', '', xx))
#    ll <- gsub('[=].[=].*', '', gsub('.*[.][.]', '', xx))
#    ff <- strsplit(ll, '')[[1]]
#    f2 <- grep('[[:alnum:]_]', ff, invert = TRUE)
#    k <- 0
#    for(i in seq(length.out = nchar(ll))[ff == 'v']) {
#      if (any(f2 == i - 1)) {
#        j <- min(f2[f2 > i])
#        ll <- paste(substr(ll, 1, j - 1 + k), '.l', substr(ll, j + k, nchar(ll)), sep = '')
#        k <- k + 2
#      }
#    }
#    hdd <- paste(ll, ':0:15","',  gsub(';', '', gsub('.*[=].[=]', '(', xx)), '):0:15/;', sep = '')
#    hdd <- gsub('vOutTot[(]', 'vOutTot.l(', hdd)
#    hdd <- gsub('vInpTot[(]', 'vInpTot.l(', hdd)
#    l2 <- gsub('[.][.].*', '', xx)
#    use_set <- character()
#    # There is loop
#    if (any(grep('[(]', gsub('[$].*', '', l2)))) {
#      use_set <- gsub('[$].*', '', gsub('^[[:alnum:]_]*', '', l2))
#      use_set <- strsplit(gsub('[ ()]', '', use_set), ',')[[1]]
#      hdd <- paste('loop(', gsub('^[[:alnum:]_]*', '', l2), ', put ', 
#           paste(use_set, '.tl:0","', sep = '', collapse = ''), hdd, ');', sep = '')
#    } else if (any(grep('[$]', l2))) { # there is only condition
#      hdd <- paste('if(', gsub('^.*[$]', '', l2), ', put ', hdd, '));', sep = '')
#    } else {
#      hdd <- paste('put ', hdd, sep = '')
#    }
#    eqd <- paste("file ", nm, "_csv / '", nm, ".csv'/;\n", 
#    nm, "_csv.lp = 1;\nput ", nm, "_csv;\n", sep = '')
#    if (length(use_set) == 0) {
#      eqd <- c(eqd, 'put "value,rhs"/;')
#    } else {
#      eqd <- c(eqd, paste('put "', paste(use_set, collapse = ','), ',value,rhs"/;', sep = ''))
#    }
#    eqd <- paste(c(eqd, hdd, 'putclose;\n\n'), collapse = '\n')
#    names(eqd) <- nm
#    eqd
#  } 
#  if (is.null(eqDecFull)) debug_data <- NULL else debug_data <- debug_code(eqDecFull) 
#  list(add_code = add_code, add_data = add_set, eq_decl = eqDec, debug_data = debug_data)
#}
#
#
#
##----------------------------------------------------------------------------------
#sm_toGlpk_constrain <- function(obj, approxim, year_range) {
##  assign('year_range', year_range, globalenv())
##  assign('approxim', approxim, globalenv())
##  assign('obj', obj, globalenv())
#  eqDecFull <- NULL
#  add_code <- c()
#  add_set <- c()
#  eqDec <- c()
#  if (all(obj@type != c('tax', 'subsidy'))) {
#      # Add set
#      slc <- c('tech', 'sup', 'res', 'row', 'trade', 'group', 'comm', 'region', 'year', 'slice')
#      al_slc <- c('t', 'sp', 'rs', 'rw', 'trd', 'g', 'c', 'r', 'y', 's')
#      names(al_slc) <- slc 
#      # Add set
#      specSet <- list()
#      for(i in names(obj@for.each)[!sapply(obj@for.each, is.null)])
#        specSet[[i]] <- obj@for.each[[i]]   
#      for(i in names(obj@for.sum)[!sapply(obj@for.sum, is.null)])
#        specSet[[i]] <- obj@for.sum[[i]]   
#      aliasSet <- paste('alsCns', obj@name, names(specSet), sep = '')
#      names(aliasSet) <- names(specSet)
#      aliasSetFull <- paste('alsCns', obj@name, names(specSet), '{', names(specSet), '}', sep = '')
#      names(aliasSetFull) <- names(specSet)
#      aliasSetFull2 <- paste('alsCns', obj@name, names(specSet), '[', al_slc[names(specSet)], ']', sep = '')
#      names(aliasSetFull2) <- names(specSet)
#      if (any(names(specSet) == 'year')) {
#        specSet$year <- specSet$year[year_range[1] <= as.numeric(specSet$year) &
#           as.numeric(specSet$year) <= year_range[2]]
#      } 
#      #
#      for(i in names(specSet)) {
#       add_code <- c(add_code, paste('param ', aliasSetFull[[i]], ';', sep = ''))
#       add_set <- c(add_set, paste('param ', aliasSet[[i]], ' defVal 0 := ', sep = ''), 
#         paste('[', specSet[[i]], '] 1', sep = ''), ';')
#      }
#      #
#      tp <- as.character(obj@type)
#      # Add equation
#      eqDec <- paste('eqCns', obj@name, sep = '')
#      eqDecFull <- paste('eqCns', obj@name, '{', 
#        paste(paste(al_slc[names(obj@for.each)], 'in', 
#          names(obj@for.each)), collapse = ', '), sep = '')
#      eqDec2 <- eqDecFull
#      if (any(names(specSet) %in% names(obj@for.each))) {
#        if (sum(names(specSet) %in% names(obj@for.each)) != 1) {
#          eqDecFull <- paste(eqDecFull, ' : ( ', paste(
#            aliasSetFull2[names(aliasSetFull2) %in% names(obj@for.each)], 
#              collapse = ' and '), ' )', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, ' : ', 
#            aliasSetFull2[names(aliasSetFull2) %in% names(obj@for.each)], sep = '')
#        }
#      }
#      eqDecFull <- paste(eqDecFull, ' }: ', sep = '')
#      # Add LHS
#      if (length(obj@for.sum) != 0) {
#        if (length(obj@for.sum) != 1) {
#          eqDecFull <- paste(eqDecFull, 'sum{', 
#            paste(paste(al_slc[names(obj@for.sum)],  
#              'in', names(obj@for.sum)), collapse = ', '), sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, 'sum{',  paste(al_slc[names(obj@for.sum)],  
#              'in', names(obj@for.sum)), sep = '')
#        }
#        if (any(names(specSet) %in% names(obj@for.sum))) {
#          if (sum(names(aliasSetFull) %in% names(obj@for.sum)) != 1) {
#            eqDecFull <- paste(eqDecFull, ' : ', 
#              paste(aliasSetFull2[names(aliasSetFull) %in% names(obj@for.sum)], 
#                collapse = ' and '), '', sep = '')
#          } else {
#            eqDecFull <- paste(eqDecFull, ' : ', 
#              aliasSetFull2[names(aliasSetFull) %in% names(obj@for.sum)], sep = '')
#          }
#        }
#        eqDecFull <- paste(eqDecFull, '} (', sep = '')
#      }                                                  
#      # add variable
#      if (tp == 'input' && all(!(c(names(obj@for.sum), names(obj@for.each)) %in% 
#         c('tech', 'sup', 'res', 'trade', 'row')))) vrb <- 'vInpTot' else
#      if (tp == 'output' && all(!(c(names(obj@for.sum), names(obj@for.each)) %in% 
#         c('tech', 'sup', 'res', 'trade', 'row')))) vrb <- 'vOutTot' else {
#        gg <- c('tech', 'sup', 'res', 'trade', 'row')
#        g2 <- c('vTech', 'vSup', 'vRes', 'vTrade', 'vRow')
#        g3 <- c('Tech', 'Sup', 'Res', 'Trade', 'Row')
#        names(g2) <- gg   
#        names(g3) <- gg   
#        gg <- gg[gg %in% c(names(obj@for.sum), names(obj@for.each))]
#        if (length(gg) != 1) {
#          if (tp %in% c('sharein', 'shareout')) stop('Undefined LHS variable') else
#            stop('Internal error 1')
#        }
#        vrb <- g2[gg]
#        if (tp == 'capacity') vrb <- paste(vrb, 'Cap', sep = '') else
#        if (tp == 'newcapacity') vrb <- paste(vrb, 'NewCap', sep = '') else
#        if (tp == 'activity') vrb <- paste(vrb, 'Act', sep = '') else
#        if (tp %in% c('input', 'sharein')) vrb <- paste(vrb, 'Inp', sep = '') else
#        if (tp %in% c('output', 'shareout')) vrb <- paste(vrb, 'Out', sep = '')
#      }
#      eqDecFull <- paste(eqDecFull, vrb, '[', 
#        paste(al_slc[order_set(c(names(obj@for.sum), names(obj@for.each)))], 
#          collapse = ', '), ']', sep = '')
#      ## Add check
#      if (tp %in% c('input', 'sharein', 'output', 'shareout') && 
#        !(vrb %in% c('vInpTot', 'vOutTot'))) {
#        eqDecFull <- paste(eqDecFull, ' * m', g3[gg], sep = '')
#        if (tp %in% c('input', 'sharein')) {
#          eqDecFull <- paste(eqDecFull, 'InpComm', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, 'OutComm', sep = '')
#        }
#          hh <- c(names(obj@for.sum), names(obj@for.each))
#          hh <- hh[!(hh %in% c('region', 'year', 'slice'))]
#        eqDecFull <- paste(eqDecFull, '[',
#          paste(al_slc[order_set(hh)], collapse = ', '), ']', sep = '')
#      }
#      #        
#      if (length(obj@for.sum) != 0) {
#        eqDecFull <- paste(eqDecFull, ')', sep = '')
#      }
#      # Condition
#      if (obj@eq == '<=') eqDecFull <- paste(eqDecFull, ' <= ', sep = '') else
#      if (obj@eq == '=') eqDecFull <- paste(eqDecFull, ' = ', sep = '') else
#      if (obj@eq == '>=') eqDecFull <- paste(eqDecFull, ' >= ', sep = '') else
#        stop('Unknown equation type')
#      # RHS  
#      if (nrow(obj@rhs) == 0) {
#        if (tp %in% c('sharein', 'shareout')) {
#          if (tp == 'sharein') {
#            vv <- 'vInpTot(comm, region, year, slice)'
#          } else {
#            vv <- 'vOutTot(comm, region, year, slice)'
#          }          
#          eqDecFull <- paste(eqDecFull, obj@defVal, ' * ', vv, ';', sep = '')
#        } else {
#          eqDecFull <- paste(eqDecFull, obj@defVal, ';', sep = '')
#        }
#      } else {                                                               
#        gg <- obj@rhs
#        for(cl in colnames(gg)[colnames(gg) %in% names(approxim)])
#          gg[, cl] <- as.character(gg[, cl])
#        if (any(colnames(gg) == 'year')) gg[, 'year'] <- as.numeric(gg[, 'year'])
#        for (i in colnames(gg)[colnames(gg) %in% names(obj@for.each)]) {
#          if (!is.null(obj@for.each[[i]])) {
#            gg <- gg[is.na(gg[, i]) | gg[, i] %in% obj@for.each[[i]], , drop = FALSE]
#            approxim[[i]] <- approxim[[i]][approxim[[i]] %in% obj@for.each[[i]]]
#          }  
#        }
#        for (i in colnames(gg)[colnames(gg) %in% names(obj@for.sum)]) {
#          if (!is.null(obj@for.sum[[i]])) {
#            gg <- gg[is.na(gg[, i]) | gg[, i] %in% obj@for.sum[[i]], , drop = FALSE]
#            approxim[[i]] <- approxim[[i]][approxim[[i]] %in% obj@for.each[[i]]]
#          }  
#        }
#        rhs <- interpolation(gg, 'rhs', approxim = approxim, year_range = year_range,
#            rule = obj@rule, defVal = obj@defVal)
#        prm <- paste('rhsCns', obj@name, '[', paste(al_slc[colnames(rhs)[-ncol(rhs)]], 
#           collapse = ', '), ']', sep = '')
#        prm2 <- paste('rhsCns', obj@name, '{', paste(colnames(rhs)[-ncol(rhs)], 
#           collapse = ', '), '}', sep = '')
#        prm3 <- paste('rhsCns', obj@name, sep = '')
#        if (tp == 'sharein' || tp == 'shareout') {
#          if (all(names(obj@for.each) != 'comm')) stop('There is no commodity definition to ', tp, ' type')
#          if (tp == 'sharein') {
#            vv <- 'vInpTot[c, r, y, s]'
#          } else {
#            vv <- 'vOutTot[c, r, y, s]'
#          }
#          if (all(c('comm', 'region', 'year', 'slice') %in% names(obj@for.each))) {
#            eqDecFull <- paste(eqDecFull, prm, ' * ', vv, ';', sep = '')
#          } else {      
#            qq <- c('comm', 'region', 'year', 'slice')[c('comm', 'region', 'year', 'slice') 
#              %in% names(obj@for.sum)]
#            if (length(qq) == 1) {
#              eqDecFull <- paste(eqDecFull, 'sum{', paste(al_slc[qq], 'in', qq), '', sep = '')
#            } else {
#              eqDecFull <- paste(eqDecFull, 'sum{', paste(paste(al_slc[qq], 'in', qq), 
#                 collapse = ', '), '', sep = '')
#            }
#            q2 <- names(obj@for.sum[qq])[!sapply(obj@for.sum[qq], is.null)]
#            if (length(q2) == 1) {
#              eqDecFull <- paste(eqDecFull, ': ', aliasSetFull2[q2], '', sep = '')
#            } else if (length(q2) > 1) {
#              eqDecFull <- paste(eqDecFull, ': ', paste(aliasSetFull2[q2], collapse = ' and '), sep = '')
#            }
#            eqDecFull <- paste(eqDecFull, ' }( ', prm, ' * ', vv, ');', sep = '')
#          }
#        } else {
#            eqDecFull <- paste(eqDecFull, prm, ';', sep = '')
#        }
#        add_code <- c(add_code, paste('param ', prm2, ';', sep = ''))
#        add_set <- c(add_set, paste('param ', prm3, ' defVal 0 := ', sep = ''), 
#          paste('[', apply(rhs[, -ncol(rhs), drop = FALSE], 1, function(x) paste(x, collapse = ',')),
#            '] ', rhs[, ncol(rhs)], sep = ''), ';')
#      }  
#      add_code <- c(add_code, paste('s.t.', eqDecFull))
#      #cat(eqDecFull, '\n')
#  }
#  debug_code <- function(xx) {
#    nm <- gsub('[{].*', '', xx)
#    cnd <- gsub('.*[{]', '', gsub('[}].*', '', xx))
#    vrb <- strsplit(gsub(' in [[:alnum:]]*', '', gsub('[:].*', '', cnd)), ',')[[1]]
#    rr <- gsub('.*[}][[:blank:]]*[:]', '', xx)
#    slc <- gsub('[ ]', '', strsplit(gsub('[[:alnum:]]* in ', '', gsub('[:].*', '', cnd)), ',')[[1]])
#    dbg <- paste('printf "', paste(slc, rep(',', length(slc)), sep = '', collapse = ''), 
#      'value,rhs\\n" > "', nm, '.csv";\n', collapse = '', sep = '')
#    dbg <- paste(dbg, 'for{', cnd, '} {\nprintf "', paste(rep('%s,', length(vrb)), collapse = ''),
#      '%d,%d\\n", ', paste(vrb, rep(',', length(vrb)), collapse = '', sep = ''), gsub('[<>=][=]*.*', '', rr),
#      ',', gsub('[;]', '', gsub('.*[<>=][=]*', '', rr)), ' >> "', nm, '.csv";\n',
#      '}\n', sep = '')
#    names(dbg) <- nm
#    dbg
#  } 
#  if (is.null(eqDecFull)) debug_data <- NULL else debug_data <- debug_code(eqDecFull) 
#  list(add_code = add_code, add_data = add_set, eq_decl = eqDec, debug_data = debug_data)
#}
#

#setMethod('toGams', signature(obj = 'constrain'), sm_toGams_constrain)

#obj <- newConstrain('f3', 'capacity', 'FX', for.each = list(tech = NULL))
#obj <- newConstrain('f3', 'capacity', 'FX', for.each = list(tech = c('ELCCOA', 'ELCGAS')))
#obj <- newConstrain('f3', 'capacity', 'FX', for.each = list(tech = c('ELCCOA', 'ELCGAS')),
#  rhs = data.frame(year = 2005:2010, rhs = 1:6, region = c('CHN', rep(NA, 5))))
#toGams(obj)
# sm_toGams_constrain(obj)

