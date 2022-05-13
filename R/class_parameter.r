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
    colName     = 'character',   # @colName Column name in slot 
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
    colName     = NULL,
    nValues     = 0,
      #! Misc
      misc = list(
        class = NULL,
        slot = NULL
      ))#,
);

setMethod("initialize", "parameter", 
          function(.Object, name, dimSetNames, type, 
                   check = NULL, defVal = 0, interpolation = 'back.inter.forth', 
                   colName = '', cls = NULL, slot = NULL) {
  acceptable_set <- c('tech', 'techp', 'dem', 'sup', 'weather', 'acomm', 'comm', 'commp', 
                'group', 'region', 'regionp', 'src', 'dst', 
                 'year', 'yearp', 'slice', 'slicep', 'stg', 'expp', 'imp', 'trade')
  if (!is.character(name) || length(name) != 1 || !energyRt:::check_name(name)) 
    stop(paste('Wrong name: "', name, '"', sep = ''))
  if (any(!is.character(dimSetNames)) || #length(dimSetNames) == 0 || 
    any(!(dimSetNames %in% acceptable_set))) {
      stop('Wrong dimSetNames')
  }
  if (all(type != levels(.Object@type))) stop('Wrong type')
  if (length(check) != 0 && (length(check) != 1 || !is.function(check)))
    stop('Wrong check function')
  if (any(!is.numeric(defVal))) stop('Wrong defVal value')
  if (any(!is.character(interpolation)) || any(gsub('[.]', '',
      sub('forth', '', sub('inter', '', sub('back', '', interpolation)))) != ''))
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

newParameter <- function(...) new('parameter', ...)

.resetParameter <- function(x) {
  x@data <- x@data[0,, drop = FALSE]
  if (x@nValues > 0) x@nValues <- 0
  x
} 
# Add data to Map Table with check new data
setMethod('.add_data', signature(obj = 'parameter', data = 'data.frame'),
  function(obj, data) {
    if (nrow(data) > 0) {
      if (ncol(data) != ncol(obj@data) ||
        any(sort(colnames(data)) != sort(colnames(obj@data))))
          stop('Internal error: Wrong new data 1')
      data <- data[, colnames(obj@data), drop = FALSE]
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
        data <- data[apply(data, 1, function(x) all(!is.na(x))), , drop = FALSE]
        if (nrow(data) != 0) {
          if (obj@nValues != -1) {
            if (obj@nValues + nrow(data) > nrow(obj@data)) {
              obj@data[nrow(obj@data) + 1:(nrow(data) + nrow(obj@data)), ] <- NA
            }
            nn <- obj@nValues + 1:nrow(data)
            obj@nValues <- obj@nValues + nrow(data)
            obj@data[nn, ] <- data
          } else {
            nn <- nrow(obj@data) + 1:nrow(data)
            obj@data[nn, ] <- NA
            obj@data[nn, ] <- data
          }
        }
    }
    obj
})

# Add data to Set
setMethod('.add_data', signature(obj = 'parameter', data = 'character'),
  function(obj, data) {
    if (obj@type != 'set' || length(data) == 0 || !all(is.character(data))) {
          stop('Internal error: Wrong new data')
    }
    if (length(data) == 0) return(obj)
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
})

# Add data to Set
setMethod('.add_data', signature(obj = 'parameter', data = 'numeric'),
  function(obj, data) {
    if (obj@type != 'set' || length(data) == 0 || !all(is.numeric(data))) {
          stop('Internal error: Wrong new data')
    }
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
})

# Clear Map Table
# setMethod('clear', signature(obj = 'parameter'),
.reset <- function(obj) {
    obj@data <- obj@data[0, , drop = FALSE]
    if (obj@nValues != -1) obj@nValues <- 0
    obj
}

# Get all unique set Map Table
# setMethod('getSet', signature(obj = 'parameter', dimSetNames = "character"),
#   function(obj, dimSetNames) {
#     if (length(dimSetNames) != 1 || all(dimSetNames != obj@dimSetNames))
#           stop('Internal error: Wrong dimSetNames request')
#     if (obj@nValues != -1) unique(obj@data[seq(length.out = obj@nValues), dimSetNames]) else 
#         unique(obj@data[, dimSetNames])
# })

# setMethod('.get_data_slot', signature(obj = 'parameter'), # getParameterTable
.get_data_slot <-  function(obj) {
    if (obj@nValues != -1) obj@data[seq(length.out = obj@nValues),, drop = FALSE] else obj@data
}

# Remove all data by all set
# setMethod('.drop_set_value', signature(obj = 'parameter', dimSetNames = "character", value = "character"),
.drop_set_value <- function(obj, dimSetNames, value) {
    if (length(dimSetNames) != 1 || all(dimSetNames != obj@dimSetNames))
          stop('(internal function) check dimSetNames')
    obj@data <- obj@data[!(obj@data[, dimSetNames] %in% value),, drop = FALSE]
    obj
}


# Generate GAMS code, return character == GAMS code 
.toGams0 <- function(obj, include.def) {
    gen_gg <- function(name, dtt) {
      if (ncol(dtt) == 1) {
      	ret <- paste0(name, ' = ', dtt[1, 1], ';')
      } else {
      	ret <- paste0(name, '("', dtt[, 1])
      	for (i in seq_len(ncol(dtt) - 2) + 1) {
      		ret <- paste0(ret, '", "', dtt[, i])
      	}
      	paste0(ret, '") = ', dtt[, ncol(dtt)], ';')
      }
    }
    as_simple <- function(dtt, name, def, include.def) {
      if (include.def) {
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
        if (name == 'pTradeIrEff') 	
          add_cond2 <- '(sum(comm$(mTradeComm(trade, comm) and mvTradeIr(trade, comm, src, dst, year, slice)), 1))'	
        if (name == 'pTechGinp2use') 	
          add_cond2 <- '(sum(commp$meqTechGrp2Sng(tech, region, group, commp, year, slice), 1) + (sum(groupp$meqTechGrp2Grp(tech, region, group, groupp, year, slice), 1) <> 0))'	
        if (name == 'pTechAfUp') 	
          add_cond2 <- 'meqTechAfUp(tech, region, year, slice)'	
        
        if (add_cond2 != '') add_cond2 <- paste('(', add_cond2, ')', sep = '')
        if (nrow(dtt) == 0 || all(dtt$value == def)) { #	
          return(paste(name, '(', paste(obj@dimSetNames, collapse = ', '), ')', '$'[add_cond2 != ''], add_cond2, ' = ', def, ';', sep = ''))	
        } else {	
          if (def != 0 && def != Inf) {	
            zz <- paste0(name, '(', paste0(obj@dimSetNames, collapse = ', '), ')', '$'[add_cond2 != ''], add_cond2, ' = ', def, ';')	
          } else zz <- ''	
          return(c(zz, gen_gg(name, dtt[dtt$value != def,, drop = FALSE]))) # 	
        }  	
      }
      if (nrow(dtt) == 0 || all(dtt$value %in% c(0, Inf))) { #
        if (ncol(dtt) > 1) return(paste0(name, '(', paste0(colnames(dtt)[-ncol(dtt)], collapse = ', '), ')$0 = 0;')) 
        return(paste0(name, '$0 = 0;')) 
      } else {
          return(c(gen_gg(name, dtt[dtt$value != 0 & dtt$value != Inf,, drop = FALSE]))) # 
      }  
    }
  if (obj@nValues != -1) {
        obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
      }
    if (obj@type == 'set') {                             
      if (nrow(obj@data) == 0) {                         
        return(paste0('set\n', obj@name, ' / 1 /;\n'))
      } else {
        return(c('set', paste(obj@name, ' /', sep = ''), sort(obj@data[, 1]), '/;', ''))
      }
    } else if (obj@type == 'map') {
      if (nrow(obj@data) == 0) {
        return(paste0(obj@name, '(', paste0(obj@dimSetNames, collapse = ', '), ')$0 = NO;'))
      } else {
        ret <- c('set', paste(obj@name, '(', paste(obj@dimSetNames, collapse = ', '), ') /', sep = ''))
        return(c(ret, apply(obj@data, 1, function(x) paste(x, collapse = '.')), '/;', ''))
      }
    } else if (obj@type == 'simple') {
        return(as_simple(obj@data, obj@name, obj@defVal, include.def))
    } else if (obj@type == 'multi') {     
      return(c(
        as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE], 
                  paste0(obj@name, 'Lo'), obj@defVal[1], include.def),
        as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE], 
                  paste0(obj@name, 'Up'), obj@defVal[2], include.def)
      ))
    } else stop(paste0('Error: .toGams: unknown parameter type: ', obj@type, " / ", obj@name))
    ret
}

# Check duplicated row in data
# setMethod('.check_duplicates_in_parameter', signature(obj = 'parameter'),
# .check_duplicates_in_parameter <- function(obj) {
#   fl <- duplicated(obj@data[, colnames(obj@data) != 'value', drop = FALSE])
#   if (any(fl)) {
#     message('Duplicated rows found in parameter ', obj@name)
#     print(obj@data[fl,, drop = FALSE])
#     stop()
#   }
# }


# Create Set
newSet <- function(dimSetNames) {
  if (length(dimSetNames) != 1) stop('Internal error: Wrong dimSetNames')
  newParameter(dimSetNames, dimSetNames, 'set')  
}
# Add Set
# setMethod('addSet', signature(obj = 'parameter', dimSetNames = 'character'),
#   function(obj, dimSetNames) {
#     gg <- data.frame(dimSetNames)
#     colnames(gg) <- obj@dimSetNames
#     if (any(dimSetNames == obj@data[, 1])) stop('Internal error: There is multiple dimSetNames')
#     .add_data(obj, gg)
# })
# Add Set
setMethod('addMultipleSet', signature(obj = 'parameter', dimSetNames = 'character'),
  function(obj, dimSetNames) {
    dimSetNames <- dimSetNames[!(dimSetNames %in% obj@data[,1])]
    if (length(dimSetNames) == 0) {
      obj
    } else {
      gg <- data.frame(dimSetNames)
      colnames(gg) <- obj@dimSetNames
      .add_data(obj, gg)
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
              .add_data(obj, gg)
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


# Generate PYOMO code, return character vector
.toPyomo <- function(obj) {
 as_simple <- function(data, name, name2, def) {
    if (def == Inf) def <- 0
    if (ncol(obj@data) == 1) {
      if (nrow(obj@data) == 1) def <- obj@data[[1]]
      return(paste0("# ", name, name2, '\n', name, ' = toPar(set(), ', def, ')\n'))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      if (nrow(data) == 0) {
        rtt <- paste0("# ", name, name2, '\n', name, ' = toPar(set(), ', def, ')\n')
        return(rtt)
      }
      rtt <- paste0("# ", name, name2, '\ntmp = {} \n')
      kk <- paste0("tmp[('", data[, 1])
      for (i in seq_len(ncol(data) - 2) + 1)
        kk <- paste0(kk, "', '", data[, i])
      kk <- paste0(kk, "')] = ", data[, 'value'])
      kk <- c(rtt, paste0(kk, collapse = '\n'), '\n\n', paste0(name,' = toPar(tmp, ', def, ')\n'))
      return(kk)
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    tmp <- ''
    if (nrow(obj@data) > 0)
      tmp <- paste0("['", paste0(sort(obj@data[, 1]), collapse = "', '"), "']")
    return(c(paste0("# ", obj@name), paste0('\n', obj@name, ' = set(', tmp, ');')))
  } else if (obj@type == 'map') {
    ret <- paste0('# ', obj@name, '(', paste0(obj@dimSetNames, collapse = ', '), ')')
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0('\n', obj@name, ' = set();')))
    } else {
      return(c(ret, paste0('\n', obj@name, ' = set([', paste0(paste0("('", apply(obj@data, 1, 
        function(x) paste(x, collapse = "', '")), "')"), collapse = ',\n'), ']);')))
    }
  } else if (obj@type == 'simple') {
    return(as_simple(obj@data, obj@name, gsub('[(][)]', '', paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')')), 
                     obj@defVal))
  } else if (obj@type == 'multi') {
    hh = gsub('[(][)]', '', paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')'))
    return(c(
      as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Lo', sep = ''), hh, obj@defVal[1]),
      as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Up', sep = ''), hh, obj@defVal[2])
    ))
  } else stop(paste0('Error: .toPyomo: unknown parameter type: ', obj@type, " / ", obj@name))
}

.toPyomoAbstractModel <- function(obj) {
   as_simple <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      if (nrow(data) != 0) def <- data$value
      return(paste0("# ", name, '\nparam ', name, ' := ', def, ';\n'))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, "\nparam ", name, ' default ', def, ' := ')
      if (nrow(data) == 0) {
        return(paste0("# ", name, name2, " no data except default\n"))
      }
      kk <- paste0('  ', data[, 1])
      for (i in seq_len(ncol(data) - 2) + 1)
        kk <- paste0(kk, ' ', data[, i])
      kk <- paste0(kk, ' ', data[, 'value'])
      kk <- c(rtt, paste0(kk, collapse = '\n'), '\n;\n')
      return(kk)
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    tmp <- ''
    if (nrow(obj@data) > 0)
      tmp <- paste0('\n  ', sort(obj@data[, 1]), collapse = '')
    return(c(paste0("# ", obj@name), paste0('\nset ', obj@name, ' := ', tmp, ';')))
  } else if (obj@type == 'map') {
    ret <- paste0('# ', obj@name, '(', paste0(obj@dimSetNames, collapse = ', '), ')')
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0('set ', obj@name, ' := ;')))
    } else {
      return(c(ret, paste0('set ', obj@name, ' := \n', paste0(paste0('  ', apply(obj@data, 1,
        function(x) paste(x, collapse = ' ')), '\n'), collapse = ''), ';')))
    }
  } else if (obj@type == 'simple') {
    return(as_simple(obj@data, obj@name, paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')'), obj@defVal))
  } else if (obj@type == 'multi') {
    hh = paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')')
    return(c(
      as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, 'Lo', sep = ''), hh, obj@defVal[1]),
      as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, 'Up', sep = ''), hh, obj@defVal[2])
    ))
  } else stop(paste0('Error: .toPyomoAbstractModel: unknown parameter type: ', obj@type, " / ", obj@name))
}


# Generate Julia code, return character vector
.toJulia <- function(obj) {
  as_simple <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      return(c(
        paste0("# ", name),
        paste0(name, ' = ', data$value)))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, '\n', name, "Def = ", def, ";\n")
      if (nrow(data) == 0) {
        return(paste0(rtt, name, ' = Dict()'))
      }
      val = as.character(data[1, ncol(data)])
      if (!any(grep('[.e]', val))) val <- paste0(val, '.')
      rtt = c(rtt, paste0(name, ' = Dict((:', paste0(data[1, -ncol(data)], collapse = ', :'), ') => ', val, ');'))
      if (nrow(data) == 1) return(rtt)
      kk <- paste0(name, '[(:', data[-1, 1])
      for (i in seq_len(ncol(data) - 2) + 1)
        kk <- paste0(kk, ', :', data[-1, i])
      kk <- paste0(kk, ')] = ', data[-1, 'value'])
      return(c(rtt, kk))
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    tmp <- ''
    if (nrow(obj@data) > 0)
      tmp <- paste0('\n  (:', paste0(sort(obj@data[, 1]), collapse = '),\n  (:'), ')\n')
    return(c(paste0("# ", obj@name), paste0(obj@name, ' = [', tmp, ']')))
  } else if (obj@type == 'map') {
    ret <- paste0('# ', obj@name)
    if (ncol(obj@data) > 1) ret <- paste0(ret, '(', paste0(obj@dimSetNames, collapse = ', '), ')')
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0(obj@name, ' = []')))
    } else {
      return(c(ret, paste0(obj@name, ' = Set()'), paste0('push!(', obj@name, ', ', paste0('(:', apply(obj@data, 1, 
                   function(x) paste(x, collapse = ',:')), '))\n'), collapse = '')))
    }
  } else if (obj@type == 'simple') {
    return(as_simple(obj@data, obj@name, paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')'), obj@defVal))
  } else if (obj@type == 'multi') {
    hh = paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')')
    return(c(
      as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Lo', sep = ''), hh, obj@defVal[1]),
      as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Up', sep = ''), hh, obj@defVal[2])
    ))
  } else stop('Must realise')
}

setMethod('.add_data', signature(obj = 'parameter', data = 'NULL'),
          function(obj, data) return(obj))

.unique_set <- function(obj) {
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
    obj@data <- obj@data[!duplicated(obj@data),, drop = FALSE]
  }
  obj@data <- obj@data[!duplicated(obj@data),, drop = FALSE]
  if (obj@nValues != -1) 
    obj@nValues <- nrow(obj@data)
  return(obj)    
}

.toJuliaHead <- function(obj) {
  as_simple <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      return(c(
        paste0("# ", name),
        paste0(name, ' = ', data$value)))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, '\n', name, "Def = ", def, ";\n")
      if (nrow(data) == 0) {
        return(paste0(rtt, name, ' = Dict()'))
      }
      colnames(data) <- gsub('[.]1', 'p', colnames(data))
      return(c(rtt, paste0(name, ' = Dict()'), paste0('for i in 1:nrow(dt["', name,'"])'),
               paste0('    ', name, '[(', paste0('dt["', name,'"][i, :', colnames(data)[-ncol(data)], ']',
                  collapse = ', '), ')] = dt["', name,'"][i, :value]'), 'end'))
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'map' || obj@type == 'set') {
    ret <- paste0('# ', obj@name)
    if (ncol(obj@data) > 1) ret <- paste0(ret, '(', paste0(obj@dimSetNames, collapse = ', '), ')')
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0(obj@name, ' = []')))
    } else {
      colnames(obj@data) <- gsub('[.]1', 'p', colnames(obj@data))
      return(c(ret, paste0(obj@name, ' = Set()'), paste0('for i in 1:nrow(dt["', obj@name,'"])'),
               paste0('    push!(', obj@name, ', (', paste0('dt["', obj@name,'"][i, :',
                               colnames(obj@data), ']', collapse = ', '), '))'), 'end'))

    }
  } else if (obj@type == 'simple') {
    return(as_simple(obj@data, obj@name, paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')'), obj@defVal))
  } else if (obj@type == 'multi') {
    hh = paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')')
    return(c(
      as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE],
                paste(obj@name, 'Lo', sep = ''), hh, obj@defVal[1]),
      as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE],
                paste(obj@name, 'Up', sep = ''), hh, obj@defVal[2])
    ))
  } else stop(paste0('Error: .toJuliaHead: unknown parameter type: ', obj@type, " / ", obj@name))
}


.toPyomSQLite  <- function(obj) {
  as_simple <- function(data, name, name2, def) {
    if (def == Inf) def <- 0
    if (ncol(obj@data) == 1) {
      stop('.toPyomSQLite: check @data in ', obj@name)
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      if (nrow(data) == 0) {
        rtt <- paste0("# ", name, name2, '\n', name, ' = toPar(set(), ', def, ')\n')
        return(rtt)
      }
      rtt <- paste0("# ", name, name2, '\n')
      kk <- paste0(name,' = toPar(read_dict("', name, '"), ', def, ')\n')
      return(kk)
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    tmp <- ''
    if (nrow(obj@data) > 0) {
      tmp = paste0("read_set('", obj@name,"')")
    }
    return(c(paste0("# ", obj@name), paste0('\n', obj@name, ' = set(', tmp, ')')))
  } else if (obj@type == 'map') {
    ret <- paste0('# ', obj@name, '(', paste0(obj@dimSetNames, collapse = ', '), ')')
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0('\n', obj@name, ' = set();')))
    } else {
      tmp = paste0("read_set('", obj@name,"')")
      return(c(ret, paste0('\n', obj@name, ' = set(', tmp, ')')))
    }
  } else if (obj@type == 'simple') {
    return(as_simple(obj@data, obj@name, paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')'), obj@defVal))
  } else if (obj@type == 'multi') {
    hh = paste0('(', paste0(obj@dimSetNames, collapse = ', '), ')')
    return(c(
      as_simple(obj@data[obj@data$type == 'lo', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Lo', sep = ''), hh, obj@defVal[1]),
      as_simple(obj@data[obj@data$type == 'up', 1 - ncol(obj@data), drop = FALSE], 
        paste(obj@name, 'Up', sep = ''), hh, obj@defVal[2])
    ))
  } else stop(paste0('Error: .toPyomo: unknown parameter type: ', obj@type, " / ", obj@name))
}


