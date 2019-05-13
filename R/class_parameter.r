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
    not_data        = "logical",  # @data NO flag for map 
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
    not_data        = FALSE,
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
  acceptable_set <- c('tech', 'techp', 'dem', 'sup', 'weather', 'acomm', 'comm', 'commp', 
                'group', 'region', 'regionp', 'src', 'dst', 
                 'year', 'yearp', 'slice', 'slicep', 'stg', 'expp', 'imp', 'trade')
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
  data <- data.frame(tech = character(), techp = character(), sup = character(), weather = character(), dem = character(), 
      acomm = character(), comm = character(), commp = character(), group = character(),  
      region = character(), regionp = character(), src = character(), dst = character(), 
      year = numeric(), yearp = numeric(), slicep = character(), 
      slice = character(), stg = character(),
      expp = character(), imp = character(), trade = character(), 
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
              obj@data[nrow(obj@data) + 1:(nrow(data) + nrow(obj@data)), ] <- NA
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
    if (ncol(dtt) > 2) for(i in seq(ncol(dtt) - 2, 1)) gg <- paste0(dtt[, i], '.', gg)
    c(ret, gg, '/;')
  }
    as_simple <- function(dtt, name, def) {
      add_cnd <- function(y, x) { 
        if (x == '') return(x) else return(paste(x, 'and', y))
      }
      add_cond2 <- ''
      if (any(obj@dimSetNames == 'tech') && any(obj@dimSetNames == 'comm')) {
        add_cond2 <- '(mTechInpComm(tech, comm) or mTechOutComm(tech, comm) or mTechAInp(tech, comm) or mTechAOut(tech, comm))'
        if (any(obj@dimSetNames == 'group')) add_cond2 <- paste('not(mTechOneComm(tech, comm)) and  ', add_cond2, sep = '')
      }
      if (any(obj@dimSetNames == 'tech') && any(obj@dimSetNames == 'slice')) 
        add_cond2 <- add_cnd('mTechSlice(tech, slice)', add_cond2)
      if (any(obj@dimSetNames == 'tech') && any(obj@dimSetNames == 'acomm')) 
        add_cond2 <- add_cnd('(mTechAInp(tech, acomm) or mTechAOut(tech, acomm))', add_cond2)
      if (any(obj@dimSetNames == 'year')) 
        add_cond2 <- add_cnd('mMidMilestone(year)', add_cond2)
      if (add_cond2 != '') add_cond2 <- paste('(', add_cond2, ')', sep = '')
      
      if (nrow(dtt) == 0 || all(dtt$value == def)) {
        return(paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ')', '$'[add_cond2 != ''], add_cond2, ' = ', def, ';', sep = ''))
      } else {
        if (def != 0) {
          if (def == Inf) {
            vnn <- max(dtt$value[dtt$value != Inf]) + 1;
          } else {
            vnn <- max(c(def, dtt$value[dtt$value != Inf])) + 1;
          }
          ppl <- paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ')', sep = '')
          zz <- c(
            paste(ppl, '$( ', add_cond2, ' and '[add_cond2 != ''], ppl, '= ', 0, ') = ', def, ';', sep = ''),
            paste(ppl, '$( ', add_cond2, ' and '[add_cond2 != ''], ppl, '= ', vnn, ') = ', 0, ';', sep = '')
          )
          dtt[dtt$value == 0, 'value'] <- vnn;
          dtt <- dtt[dtt$value != def,, drop = FALSE];
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
      add_nl <- ''
      if (obj@not_data) {
        add_nl <-  paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ')', sep = '')
        add_nl <-  paste(add_nl, ' = not(', add_nl, ');', sep = '')
      }
      if (nrow(obj@data) == 0) {
        if (obj@not_data) {
          ret <- paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') = YES;', sep = '')
        } else {
          ret <- paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') = NO;', sep = '')
        }
        return(ret)
      } else {
        ret <- c('set', paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') /', sep = ''))
        return(c(ret, apply(obj@data, 1, function(x) paste(x, collapse = '.')), '/;', add_nl, ''))
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
# Add Set
setMethod('addMultipleSet', signature(obj = 'parameter', dimSetNames = 'numeric'),
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



