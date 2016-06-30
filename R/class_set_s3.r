gams_set_alias <- array(c('t', 'c', 'g', 'r', 'y', 's'), dim = 6,
      dimnames = list(c('technology', 'comm', 'group', 'region', 'year', 'slice')))

# For fill constrain set
create_set <- function(name, set = NULL, alias = NULL) {
  if (all(name != c('technology', 'supply', 'group', 'comm', 'region', 'year', 'slice')))
      stop('Unknown set name ', name)
  if (is.null(alias)) alias <- name else {
    if (length(alias) != 1) stop('Incorrect alias names')
    alias <- tolower(alias)
    if (gsub('[[:alpha:]][[:alnum:]]*', '', alias) != '' || alias == '') stop('Incorrect alias names')
    #if (any(alias == c('c', 't', 'g', 'y', 'sup', 's', 'r')))
    #  stop('Incorrect alias names, system reserved: c, t, g, y, sup, s, r')
    if (!is.null(set) && (any(is.na(set)) || any(set == '') || anyDuplicated(set)))
      stop('Incorrect set')
  }
  structure(list(alias = alias, name = name, set = set, gams_alias = NULL), class = 'set')
}

prepare.set <- function(x, level = NULL, prefix = '') {
  x$gams_alias <- tolower(paste(prefix, x$alias, sep = ''))
  if (gsub('[[:alpha:]][[:alnum:]_]*', '', x$gams_alias) != '' || x$gams_alias == '')
      stop('Incorrect gams alias names: "', x$gams_alias, '"')
  if (length(x$set) == 0) {
    clearCode <- paste('alias(', gams_set_alias[x$name], ', ', x$gams_alias, ');', sep = '')
  } else {
    if (!all(x$set %in% level[[x$name]])) {
      stop('Incorrect set: "', x$name, '", names: "', paste(x$set[!(x$set %in% level[[x$name]])], collapse = '", "'), '"')
    }
    clearCode <- c('set', paste(x$gams_alias, '(', gams_set_alias[x$name], ') /', sep = ''),
                    x$set, '/;', '')
  }
  list(set = x, clearCode = clearCode)
}

print.set <- function(x) {
  if (x$alias == x$name) {
    cat('Set name: "', x$name, '"', sep = '')
  } else cat('Set alias: "', x$alias, '", set: "', x$name, '"', sep = '')
  if (!is.null(x$gams_alias)) cat(', gams set alias: "', x$gams_alias, '"', sep = '')
  if (length(x$set) != 0) {
    cat('\n  value: "', paste(x$set, collapse = '", "'), '"\n', sep = '')
  } else cat(', there isn\'t defined value\n')
}
#prepare(create_set('region', c('RUS', 'CHN')), level = list(region = c('RUS', 'CHN')))
