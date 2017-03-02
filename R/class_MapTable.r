# Class for export to GAMS parameter or map
setClass('MapTable', # @parameter
  representation(
    alias           = "character",   # @name name Name for GAMS
    set             = "character",   # @dimSetsNames Dimension sets, comma separated, order is matter
    type            = "factor",      # @type is it map (map),  single (single parameter),
                                     # double (Up / Lo parameter)
    default         = "numeric",     # @defVal Default value : zero value  for map,
                                     # one for single, two for double
    interpolation   = "character",   # interpolation 'back.inter.forth'
    data            = "data.frame",  # @data Data for expotrt
    #use_now         = "numeric",     # For fast
    #use_all         = "numeric",     # For fast
    check           = "function",     # ?delete? function for checking map
    for_sysInfo     = 'character',   # @colName Column name in slot 
# misc$nval 
    true_length     = 'numeric',     # @nValues Number of non-NA values in 'data' (to speed-up processing) 
    misc = "list"
  ),
  prototype(
    alias           = NULL,
    set             = NULL,
    type            = factor(NA, c('set', 'map', 'single', 'double')),
    default         = NULL,
    interpolation   = NULL,
    data            = data.frame(),
    #use_now         = 0,     
    #use_all         = 0,
    check           = function(obj) TRUE,
    for_sysInfo     = NULL,
    true_length     = 0,
      #! Misc
      misc = list(
        GUID = "8732f62e-0f23-4853-878b-ec8a5cbd5224"
      )),
  validity          = function(object) object@check(object)
);

setMethod("initialize", "MapTable", function(.Object, alias, set, type, 
      check = NULL, default = 0, interpolation = 'back.inter.forth', 
      for_sysInfo = ''
  ) {
  acceptable_set <- c('tech', 'techp', 'dem', 'sup', 'acomm', 'comm', 'commp', 
                'group', 'region', 'regionp', 'src', 'dst', 
                 'year', 'yearp', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns')
  if (!is.character(alias) || length(alias) != 1 || !chec_correct_name(alias)) 
    stop(paste('Wrong alias: "', alias, '"', sep = ''))
  if (length(set) == 0 || any(!is.character(set)) || 
    any(!(set %in% acceptable_set))) {
      stop('Wrong set')
  }
  if (all(type != levels(.Object@type))) stop('Wrong type')
  if (length(check) != 0 && (length(check) != 1 || !is.function(set)))
    stop('Wrong check function')
  if (any(!is.numeric(default))) stop('Wrong default value')
  if (any(!is.character(interpolation)) || gsub('[.]', '',
      sub('forth', '', sub('inter', '', sub('back', '', interpolation)))) != '')
          stop('Wrong interpolation rule')
  if (type == 'single' && length(default) != 1) stop('Wrong default value')
  if (type == 'double' && length(default) == 0) stop('Wrong default value')
  if (type == 'double' && length(default) == 1) default <- rep(default, 2)
  if (type == 'single' && length(interpolation) != 1)
    stop('Wrong interpolation rule')
  if (type == 'double' && length(interpolation) == 0)
    stop('Wrong interpolation rule')
  if (type == 'double' && length(interpolation) == 1)
    interpolation <- rep(interpolation, 2)
  .Object@alias         <- alias
  .Object@set           <- set
  .Object@type[]        <- type
  if (!is.null(check)) .Object@check <- check
  .Object@default       <- default
  .Object@interpolation <- interpolation
  # Create data
  data <- data.frame(tech = character(), techp = character(), sup = character(), dem = character(), 
      acomm = character(), comm = character(), commp = character(), group = character(),  
      region = character(), regionp = character(), src = character(), dst = character(), 
      year = numeric(), yearp = numeric(), 
      slice = character(), stg = character(),
      expp = character(), imp = character(), trade = character(), cns = character(), 
      type = factor(levels = c('lo', 'up')),
      Freq = numeric(), stringsAsFactors = FALSE)
  set <- .Object@set
  if (type == 'double') set <- c(set, 'type')
  if (any(type == c('single', 'double'))) set <- c(set, 'Freq')
  .Object@data <- data[, set, drop = FALSE]
  .Object@for_sysInfo  <- for_sysInfo
  .Object
})

MapTable <- function(...) new('MapTable', ...)

# Add data to Map Table with check new data
setMethod('addData', signature(obj = 'MapTable', data = 'data.frame'),
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
          if (obj@true_length != -1) {
            if (obj@true_length + nrow(data) > nrow(obj@data)) {
              obj@data[nrow(obj@data) + 1:(500 + .25 * nrow(obj@data)), ] <- NA
            }
            nn <- obj@true_length + 1:nrow(data)
            obj@true_length <- obj@true_length + nrow(data)
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
setMethod('addData', signature(obj = 'MapTable', data = 'character'),
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
    obj@true_length <- obj@true_length + length(data)
    obj
})

# Add data to Set
setMethod('addData', signature(obj = 'MapTable', data = 'numeric'),
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
    obj@true_length <- obj@true_length + length(data)
    obj
})

# Clear Map Table
setMethod('clear', signature(obj = 'MapTable'),
  function(obj) {
    obj@data <- obj@data[0, , drop = FALSE]
    obj
})

# Get all unique set Map Table
setMethod('getSet', signature(obj = 'MapTable', set = "character"),
  function(obj, set) {
    if (length(set) != 1 || all(set != obj@set))
          stop('Internal error: Wrong set request')
    # zz <- unique(obj@data[, set])
    # zz[!is.na(zz)]
    if (obj@true_length != -1) unique(obj@data[seq(length.out = obj@true_length), set]) else 
        unique(obj@data[, set])
})

setMethod('getDataMapTable', signature(obj = 'MapTable'), # getParameterTable
  function(obj) {
    if (obj@true_length != -1) obj@data[seq(length.out = obj@true_length),, drop = FALSE] else obj@data
})

# Remove all data by all set
setMethod('removeBySet', signature(obj = 'MapTable', set = "character", value = "character"),
  function(obj, set, value) {
    if (length(set) != 1 || all(set != obj@set))
          stop('Internal error: Wrong set request')
    obj@data <- obj@data[!(obj@data[, set] %in% value),, drop = FALSE]
    obj
})

# Generate GAMS code, return character == GAMS code 
setMethod('toGams', signature(obj = 'MapTable'),
  function(obj) {
    if (obj@true_length != -1) {
        obj@data <- obj@data[seq(length.out = obj@true_length),, drop = FALSE]
      }
    if (obj@type == 'set') {                             
      if (nrow(obj@data) == 0) {                         
        ret <- c('set', paste(obj@alias, ' /', sep = ''))
        ret <- c(ret, '1')
        ret <- c(ret, '/;', '')
      } else {
        ret <- c('set', paste(obj@alias, ' /', sep = ''))
        ret <- c(ret, obj@data[, 1]) 
        ret <- c(ret, '/;', '')
      }
    } else if (obj@type == 'map') {
      if (nrow(obj@data) == 0) {
        ret <- paste(obj@alias, '(', paste(obj@set, collapse = ', '), ') = NO;', sep = '')
      } else {
        ret <- c('set', paste(obj@alias, '(', paste(obj@set, collapse = ', '), ') /', sep = ''))
        ret <- c(ret, apply(obj@data, 1, function(x) paste(x, collapse = '.')))
        ret <- c(ret, '/;', '')
      }
    } else if (obj@type == 'single') {
       if (nrow(obj@data) == 0 || all(obj@data$Freq == obj@default)) {
        ret <- paste(obj@alias, '(', paste(obj@set, collapse = ', '), ') = ', obj@default, ';', sep = '')
      } else  if (all(obj@data$Freq[1] == obj@data$Freq)) {
        ret <- paste(obj@alias, '(', paste(obj@set, collapse = ', '), ') = ', obj@data$Freq[1], ';', sep = '')
      } else {
        obj@data <- obj@data[obj@data$Freq != 0,, drop = FALSE]
        ret <- c('parameter', paste(obj@alias, '(', paste(obj@set, collapse = ', '), ') /', sep = ''))
        gg <- obj@data[, 1]
        if (ncol(obj@data) > 2) for(i in 3:ncol(obj@data) - 1) gg <- paste(gg, '.', obj@data[, i], sep = '')
        gg <- paste(gg, obj@data[, ncol(obj@data)])
        ret <- c(ret, gg, '/;', '')
      }  
    } else if (obj@type == 'double') {     
       if (nrow(obj@data) == 0) {
        ret <- c()
        ret <- c(ret, paste(obj@alias, 'Lo(', paste(obj@set, collapse = ', '), ') = ', 
            obj@default[1], ';', sep = ''))
        ret <- c(ret, paste(obj@alias, 'Up(', paste(obj@set, collapse = ', '), ') = ', 
            obj@default[2], ';', sep = ''))
      } else {
        ret <- c()
        for(i in levels(obj@data$type)) {
          if (i == 'lo') {
            ret <- c(ret, 'parameter', paste(obj@alias, 'Lo(', paste(obj@set, collapse = ', '), ') /', sep = ''))
            dta <- obj@data[obj@data$type == 'lo', , drop = FALSE]
          }
          if (i == 'up') {
            ret <- c(ret, 'parameter', paste(obj@alias, 'Up(', paste(obj@set, collapse = ', '), ') /', sep = ''))
            dta <- obj@data[obj@data$type == 'up', , drop = FALSE]
          }
          dta <- dta[, colnames(dta) != 'type', drop = FALSE]
          ret <- c(ret, paste(apply(dta[, -ncol(dta), drop = FALSE], 1, 
              function(x) paste(x, collapse = '.')), dta[, 'Freq']))
          ret <- c(ret, '/;', '')
        }
      }
    } else stop('Must realise')
    ret
})

# Check duplicated row in data
setMethod('checkDuplicatedRow', signature(obj = 'MapTable'),
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
  check_first_column(obj@data[, colnames(obj@data) != 'Freq', drop = FALSE])
})


# Create Set
createSet <- function(set) {
  if (length(set) != 1) stop('Internal error: Wrong set')
  MapTable(set, set, 'set')  
}
# Add Set
setMethod('addSet', signature(obj = 'MapTable', set = 'character'),
  function(obj, set) {
    gg <- data.frame(set)
    colnames(gg) <- obj@set
    if (any(set == obj@data[, 1])) stop('Internal error: There is multiple set')
    addData(obj, gg)
})
# Add Set
setMethod('addMultipleSet', signature(obj = 'MapTable', set = 'character'),
  function(obj, set) {
    set <- set[!(set %in% obj@data[,1])]
    if (length(set) == 0) {
      obj
    } else {
      gg <- data.frame(set)
      colnames(gg) <- obj@set
      addData(obj, gg)
    }
})

# Add data to Map Table with check new data
setMethod('print', 'MapTable', function(x, ...) {
  if (nrow(x@data) == 0) {
    cat('MapTable "', x@alias, '" is empty\n', sep = '')
  } else {
    cat('MapTable "', x@alias, '"\n', sep = '')
    print(x@data)
  }
})


#dd <- new('MapTable', 'comm', 'comm', 'single')
#dd <- addData(dd, data.frame(comm = 'a1'))

## Test
# dd <- new('MapTable', 'comm', 'comm', 'single')
# toGams(dd)
# dd <- addData(dd, data.frame(comm = 'a1'))
# toGams(dd)
# dd <- createSet('comm')
# dd <- addSet(dd, 'hyt')
# dd <- addMultipleSet(dd, 'hyt2')
# MapTable('gh', 'comm', 'double')
# dd <- MapTable('gh', 'comm', 'map')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1'))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2'))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- MapTable('gh', c('comm', 'year'), 'map')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- MapTable('gh', 'comm', 'single')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', Freq = 5))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', Freq = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- MapTable('gh', c('comm', 'year'), 'single')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005, Freq = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, Freq = 52))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- MapTable('gh', 'comm', 'double')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', type = 'lo', Freq = 5))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', type = 'lo', Freq = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', type = 'up', Freq = 53))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- MapTable('gh', c('comm', 'year'), 'double')
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'a1', year = 2005, type = 'up', Freq = 51))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'lo', Freq = 52))
# toGams(dd)
# checkDuplicatedRow(dd)
# dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'up', Freq = 53))
# toGams(dd)
# checkDuplicatedRow(dd)
# ##dd <- addData(dd, data.frame(comm = 'b2', year = 2012, type = 'up', Freq = 53))
# ##checkDuplicatedRow(dd) # Gerate error
# validObject(MapTable('gh', 'comm', 'single'))
# dd <- MapTable('gh', c('comm', 'year'), 'double')
# dd <- addData(dd, data.frame(comm = '1', year = 2, type = 'lo', Freq = 2, stringsAsFactors = FALSE))
# getSet(dd, 'year')
# clear(dd)
# removeBySet(dd, 'comm', '21')
