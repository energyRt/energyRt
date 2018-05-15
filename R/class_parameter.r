# Class for export to GAMS parameter or map
setClass('parameter', # @parameter
  representation(
    name           = "character",   # @name name Name for GAMS
    dimSetNames             = "character",   # @dimSetNames Dimension sets, comma separated, order is matter
    type            = "factor",      # @type is it map (map),  simple (simple parameter),
                                     # multi (Up / Lo /Fx parameter)
    defVal         = "numeric",     # @defVal Default value : zero value  for map,
                                     # one for single, two for multi
    interpolation   = "character",   # interpolation 'back.inter.forth'
    data            = "data.frame",  # @data Data for export
    #use_now         = "numeric",     # For fast
    #use_all         = "numeric",     # For fast
    # check           = "function",     # ?delete? function for checking map
    colName     = 'character',   # @colName Column name in slot 
# misc$nval 
    nValues     = 'numeric',     # @nValues Number of non-NA values in 'data' (to speed-up processing) 
    misc = "list"
  ),
  prototype(
    name           = NULL,
    dimSetNames             = NULL,
    type            = factor(NA, c('set', 'map', 'simple', 'multi')),
    defVal         = NULL,
    interpolation   = NULL,
    data            = data.frame(),
    #use_now         = 0,     
    #use_all         = 0,
    #check           = function(obj) TRUE,
    colName     = NULL,
    nValues     = 0,
      #! Misc
      misc = list(
        class = NULL,
        slot = NULL
      ))#,
#  validity          = function(object) object@check(object)
);

setMethod("initialize", "parameter", function(.Object, name, dimSetNames, type, 
      check = NULL, defVal = 0, interpolation = 'back.inter.forth', 
      colName = '', cls = NULL, slot = NULL
  ) {
  attr(.Object, 'GUID') <- '8732f62e-0f23-4853-878b-ec8a5cbd5224'
  acceptable_set <- c('tech', 'techp', 'dem', 'sup', 'acomm', 'comm', 'commp', 
                'group', 'region', 'regionp', 'src', 'dst', 
                 'year', 'yearp', 'slice', 'slicep', 'stg', 'expp', 'imp', 'trade', 'cns')
  if (!is.character(name) || length(name) != 1 || !energyRt:::.chec_correct_name(name)) 
    stop(paste('Wrong name: "', name, '"', sep = ''))
  if (length(dimSetNames) == 0 || any(!is.character(dimSetNames)) || 
    any(!(dimSetNames %in% acceptable_set))) {
      stop('Wrong dimSetNames')
  }
  if (all(type != levels(.Object@type))) stop('Wrong type')
  if (length(check) != 0 && (length(check) != 1 || !is.function(check)))
    stop('Wrong check function')
  if (any(!is.numeric(defVal))) stop('Wrong defVal value')
  if (any(!is.character(interpolation)) || gsub('[.]', '',
      sub('forth', '', sub('inter', '', sub('back', '', interpolation)))) != '')
          stop('Wrong interpolation rule')
  if (type == 'simple' && length(defVal) != 1) stop('Wrong defVal value')
  if (type == 'multi' && length(defVal) == 0) stop('Wrong defVal value')
  if (type == 'multi' && length(defVal) == 1) defVal <- rep(defVal, 2)
  if (type == 'simple' && length(interpolation) != 1)
    stop('Wrong interpolation rule')
  if (type == 'multi' && length(interpolation) == 0)
    stop('Wrong interpolation rule')
  if (type == 'multi' && length(interpolation) == 1)
    interpolation <- rep(interpolation, 2)
  .Object@name         <- name
  .Object@dimSetNames           <- dimSetNames
  .Object@type[]        <- type
  if (!is.null(check)) .Object@check <- check
  .Object@defVal       <- defVal
  .Object@interpolation <- interpolation
  .Object@misc$class <- cls
  .Object@misc$slot <- slot
  # Create data
  data <- data.frame(tech = character(), techp = character(), sup = character(), dem = character(), 
      acomm = character(), comm = character(), commp = character(), group = character(),  
      region = character(), regionp = character(), src = character(), dst = character(), 
      year = numeric(), yearp = numeric(), slicep = character(), 
      slice = character(), stg = character(),
      expp = character(), imp = character(), trade = character(), cns = character(), 
      type = factor(levels = c('lo', 'up')),
      value = numeric(), stringsAsFactors = FALSE)
  dimSetNames <- .Object@dimSetNames
  if (type == 'multi') dimSetNames <- c(dimSetNames, 'type')
  if (any(type == c('simple', 'multi'))) dimSetNames <- c(dimSetNames, 'value')
  .Object@data <- data[, dimSetNames, drop = FALSE]
  .Object@colName  <- colName
  .Object
})

createParameter <- function(...) new('parameter', ...)

# Add data to Map Table with check new data
setMethod('addData', signature(obj = 'parameter', data = 'data.frame'),
  function(obj, data) {
    if (nrow(data) > 0) {
      if (ncol(data) != ncol(obj@data) ||
        any(colnames(data) != colnames(obj@data)))
          stop('Internal error: Wrong new data 1')
      if (any(colnames(data) == 'type')) {
        if (any(!(data$type %in% c('lo', 'up'))))
          stop('Internal error: Wrong new data 2')
          data$type <- factor(data$type, levels = c('lo', 'up'))
      }
      for(i in colnames(data)[sapply(data, class) == 'factor'])
        if (i != 'type') data[, i] <- as.character(data[, i])
      class2 <- function(x) if (class(x) == 'integer') 'numeric' else class(x)
      if (any(sapply(data, class2) != sapply(obj@data, class)))
          stop('Internal error: Wrong new data 3')
        #nn <- obj@use_now + 1:nrow(data)
        #obj@use_now <- obj@use_now + nrow(data)
        #if (obj@use_now >= obj@use_all) {
        #  obj@use_all <- obj@use_now + 1e3
        #  obj@data[obj@use_all, ] <- NA
        #}
        #apply(data, 1, function(x) all(!is.na(x)))
        #f (!all(apply(data, 1, function(x) all(!is.na(x))))) print(data)
        data <- data[apply(data, 1, function(x) all(!is.na(x))), , drop = FALSE]
        if (nrow(data) != 0) {
          if (obj@nValues != -1) {
            if (obj@nValues + nrow(data) > nrow(obj@data)) {
              obj@data[nrow(obj@data) + 1:(500 + .25 * nrow(obj@data)), ] <- NA
            }
            nn <- obj@nValues + 1:nrow(data)
            obj@nValues <- obj@nValues + nrow(data)
            #obj@data[nn, ] <- NA
            obj@data[nn, ] <- data
          } else {
            nn <- nrow(obj@data) + 1:nrow(data)
            obj@data[nn, ] <- NA
            obj@data[nn, ] <- data
          }
        }
        #obj@data <- rbind(obj@data, data)
    }
    obj
})

# Add data to Set
setMethod('addData', signature(obj = 'parameter', data = 'character'),
  function(obj, data) {
    if (obj@type != 'set' || length(data) == 0 || !all(is.character(data))) {
          stop('Internal error: Wrong new data')
    }
    #    nn <- obj@use_now + 1:length(data)
    #    obj@use_now <- obj@use_now + length(data)
    #    if (obj@use_now >= obj@use_all) {
    #      obj@use_all <- obj@use_now + 1e3
    #      obj@data[obj@use_all, ] <- NA
    #    }
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
})

# Add data to Set
setMethod('addData', signature(obj = 'parameter', data = 'numeric'),
  function(obj, data) {
    if (obj@type != 'set' || length(data) == 0 || !all(is.numeric(data))) {
          stop('Internal error: Wrong new data')
    }
    #    nn <- obj@use_now + 1:length(data)
    #    obj@use_now <- obj@use_now + length(data)
    #    if (obj@use_now >= obj@use_all) {
    #      obj@use_all <- obj@use_now + 1e3
    #      obj@data[obj@use_all, ] <- NA
    #    }
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
})

# Clear Map Table
setMethod('clear', signature(obj = 'parameter'),
  function(obj) {
    obj@data <- obj@data[0, , drop = FALSE]
    obj
})

# Get all unique set Map Table
setMethod('getSet', signature(obj = 'parameter', dimSetNames = "character"),
  function(obj, dimSetNames) {
    if (length(dimSetNames) != 1 || all(dimSetNames != obj@dimSetNames))
          stop('Internal error: Wrong dimSetNames request')
    # zz <- unique(obj@data[, dimSetNames])
    # zz[!is.na(zz)]
    if (obj@nValues != -1) unique(obj@data[seq(length.out = obj@nValues), dimSetNames]) else 
        unique(obj@data[, dimSetNames])
})

setMethod('getParameterData', signature(obj = 'parameter'), # getParameterTable
  function(obj) {
    if (obj@nValues != -1) obj@data[seq(length.out = obj@nValues),, drop = FALSE] else obj@data
})

# Remove all data by all set
setMethod('removeBySet', signature(obj = 'parameter', dimSetNames = "character", value = "character"),
  function(obj, dimSetNames, value) {
    if (length(dimSetNames) != 1 || all(dimSetNames != obj@dimSetNames))
          stop('Internal error: Wrong dimSetNames request')
    obj@data <- obj@data[!(obj@data[, dimSetNames] %in% value),, drop = FALSE]
    obj
})

# Generate GAMS code, return character == GAMS code 
.toGams <- function(obj) {
  gen_gg <- function(name, dtt) {
    ret <- c('parameter', paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ') /', sep = ''))
    gg <- paste(dtt[, ncol(dtt) - 1], dtt[, ncol(dtt)])
    if (ncol(dtt) > 2) for(i in seq(ncol(dtt) - 2, 1)) gg <- paste(dtt[, i], '.', gg, sep = '')
    c(ret, gg, '/;')
  }
    as_simple <- function(dtt, name, def) {
      add_cond2 <- ''
      if (any(obj@dimSetNames == 'tech') && any(obj@dimSetNames == 'comm')) 
        add_cond2 <- '(mTechInpComm(tech, comm) or mTechOutComm(tech, comm) or mTechAInp(tech, comm) or mTechAOut(tech, comm))'
      if (nrow(dtt) == 0 || all(dtt$value == def)) {
        return(paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ')', '$'[add_cond2 != ''], add_cond2, ' = ', def, ';', sep = ''))
      } else {
        if (def != 0) {
          vnn <- max(dtt$value[dtt$value != Inf]) + 1;
          ppl <- paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ')', sep = '')
          zz <- c(
            paste(ppl, '$( ', add_cond2, ' and '[add_cond2 != ''], ppl, '= ', 0, ') = ', def, ';', sep = ''),
            paste(ppl, '$( ', add_cond2, ' and '[add_cond2 != ''], ppl, '= ', vnn, ') = ', 0, ';', sep = '')
          )
          dtt[dtt$value == 0, 'value'] <- vnn;
          return(c(gen_gg(name, dtt), zz))
        } else {
          return(gen_gg(name, dtt))
        }
      }  
    }
  if (obj@nValues != -1) {
        obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
      }
    if (obj@type == 'set') {                             
      if (nrow(obj@data) == 0) {                         
        ret <- c('set', paste(obj@name, ' /', sep = ''))
        ret <- c(ret, '1')
        ret <- c(ret, '/;', '')
      } else {
        return(c('set', paste(obj@name, ' /', sep = ''), obj@data[, 1], '/;', ''))
      }
    } else if (obj@type == 'map') {
      if (nrow(obj@data) == 0) {
        ret <- paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') = NO;', sep = '')
      } else {
        ret <- c('set', paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') /', sep = ''))
        return(c(ret, apply(obj@data, 1, function(x) paste(x, collapse = '.')), '/;', ''))
      }
    } else if (obj@type == 'simple') {
      ret <- as_simple(obj@data, obj@name, obj@defVal)
    } else if (obj@type == 'multi') {     
       if (nrow(obj@data) == 0) {
        ret <- c()
        ret <- c(ret, paste(obj@name, 'Lo(', paste(obj@dimSetNames, collapse = ', '), ') = ', 
            obj@defVal[1], ';', sep = ''))
        ret <- c(ret, paste(obj@name, 'Up(', paste(obj@dimSetNames, collapse = ', '), ') = ', 
            obj@defVal[2], ';', sep = ''))
      } else {
        ret <- c(
          as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE], paste(obj@name, 'Lo', sep = ''), obj@defVal[1]),
          as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE], paste(obj@name, 'Up', sep = ''), obj@defVal[2])
        )
      }
    } else stop('Must realise')
    ret
}

# Check duplicated row in data
setMethod('checkDuplicatedRow', signature(obj = 'parameter'),
  function(obj) {
  check_first_column <- function(x, legend = '') {
    if (ncol(x) == 1) {
      if (anyDuplicated(x[, 1])) 
        stop(paste('There is duplicated value ', sub('^[.]', '', legend), 
            '.', anyDuplicated(x[, 1]), sep = ''))
    } else {
      for(i in unique(x[, 1])) {
        check_first_column(x[x[,1] == i, -1, drop = FALSE], 
          legend = paste(legend, '.', i, sep = ''))
      }
    }
  }
  check_first_column(obj@data[, colnames(obj@data) != 'value', drop = FALSE])
})


# Create Set
createSet <- function(dimSetNames) {
  if (length(dimSetNames) != 1) stop('Internal error: Wrong dimSetNames')
  createParameter(dimSetNames, dimSetNames, 'set')  
}
# Add Set
setMethod('addSet', signature(obj = 'parameter', dimSetNames = 'character'),
  function(obj, dimSetNames) {
    gg <- data.frame(dimSetNames)
    colnames(gg) <- obj@dimSetNames
    if (any(dimSetNames == obj@data[, 1])) stop('Internal error: There is multiple dimSetNames')
    addData(obj, gg)
})
# Add Set
setMethod('addMultipleSet', signature(obj = 'parameter', dimSetNames = 'character'),
  function(obj, dimSetNames) {
    dimSetNames <- dimSetNames[!(dimSetNames %in% obj@data[,1])]
    if (length(dimSetNames) == 0) {
      obj
    } else {
      gg <- data.frame(dimSetNames)
      colnames(gg) <- obj@dimSetNames
      addData(obj, gg)
    }
})

# Add data to Map Table with check new data
setMethod('print', 'parameter', function(x, ...) {
  if (nrow(x@data) == 0) {
    cat('parameter "', x@name, '" is empty\n', sep = '')
  } else {
    cat('parameter "', x@name, '"\n', sep = '')
    print(x@data)
  }
})

.sm_to_glpk <-  function(obj) {
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    if (nrow(obj@data) == 0) {
      ret <- c(paste('set ', obj@name, ' := 1;', sep = ''), '')
    } else {
      ret <- c(paste('set ', obj@name, ' := ', paste(obj@data[, 1], collapse = ' '), ';', sep = ''), '')
    }
  } else if (obj@type == 'map') {
    if (nrow(obj@data) == 0) {
      ret <- paste('param ', obj@name, ' default 0 := ;', sep = '')
    } else {
      ret <- paste('param ', obj@name, ' default 0 := ', sep = '')
      ret <- c(ret, apply(obj@data, 1, function(x) paste('[', paste(x, collapse = ','), '] 1', sep = '')))
      ret <- c(ret, ';', '')
    }
  } else if (obj@type == 'simple') {
    if (nrow(obj@data) == 0) {
      dd <- obj@defVal
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, ' default ', dd, ' := ;', sep = '')
    } else {
      ret <- paste('param ', obj@name, ' default 0 := ', sep = '')
      fl <- obj@data[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(obj@data[fl, -ncol(obj@data), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', obj@data[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
  } else if (obj@type == 'multi') {
    gg <- obj@data
    gg <- gg[gg$type == 'lo', , drop = FALSE]
    gg <- gg[, colnames(gg) != 'type'] 
    if (nrow(gg) == 0 || all(gg$value[1] == gg$value)) {
      if (nrow(gg) == 0) dd <- obj@defVal[1] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, 'Lo default ', dd, ' := ;', sep = '')
    } else {
      ret <- paste('param ', obj@name, 'Lo default 0 := ', sep = '')
      fl <- gg[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
    gg <- obj@data
    gg <- gg[gg$type == 'up', , drop = FALSE]
    gg <- gg[, colnames(gg) != 'type'] 
    if (nrow(gg) == 0 || all(gg$value[1] == gg$value)) {
      if (nrow(gg) == 0) dd <- obj@defVal[2] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- c(ret, paste('param ', obj@name, 'Up default ', dd, ' := ;', sep = ''))
    } else {
      ret <- c(ret, paste('param ', obj@name, 'Up default 0 := ', sep = ''))
      fl <- gg[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
  } else stop('Must realise')
  ret
}

#dd <- new('parameter', 'comm', 'comm', 'simple')
#dd <- addData(dd, data.frame(comm = 'a1'))

## Test
# dd <- new('parameter', 'comm', 'comm', 'simple')
# toGams(dd)
# dd <- addData(dd, data.frame(comm = 'a1'))
# toGams(dd)
# dd <- createSet('comm')
# dd <- addSet(dd, 'hyt')
# dd <- addMultipleSet(dd, 'hyt2')
# createParameter('gh', 'comm', 'multi')
# dd <- createParameter('gh', 'comm', 'map')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1'))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2'))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- createParameter('gh', c('comm', 'year'), 'map')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- createParameter('gh', 'comm', 'simple')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', value = 5))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', value = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- createParameter('gh', c('comm', 'year'), 'simple')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005, value = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, value = 52))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- createParameter('gh', 'comm', 'multi')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', type = 'lo', value = 5))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', type = 'lo', value = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', type = 'up', value = 53))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- createParameter('gh', c('comm', 'year'), 'multi')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005, type = 'up', value = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'lo', value = 52))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'up', value = 53))
# toGams(dd)
# checkDuplicatedRow(dd)
# ##dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'up', value = 53))
# ##checkDuplicatedRow(dd) # Gerate error
# validObject(createParameter('gh', 'comm', 'simple'))
# dd <- createParameter('gh', c('comm', 'year'), 'multi')
# dd <- addData(dd, data.frame(comm = '1', year = 2, type = 'lo', value = 2, stringsAsFactors = FALSE))
# getSet(dd, 'year')
# clear(dd)
# removeBySet(dd, 'comm', '21')
