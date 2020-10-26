# # Obsolete?
# .upper_case <- function(x) {
#   UseMethod(".upper_case")
# }
# 
# # Upper case all set in 
# .upper_case.technology <- function(tec) {
# #  tec@name <- toupper(tec@name)
# #  gg <- getClass('technology')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(tec, i)) > 0) {
# #    zz <- slot(tec, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice', 'acomm', 'commp')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(tec, i) <- zz
# #  }
#   tec
# }
# 
# # Upper case all set in 
# .upper_case.trade <- function(trd) {
# #  trd@name <- toupper(trd@name)
# #  gg <- getClass('trade')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(trd, i)) > 0) {
# #    zz <- slot(trd, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(trd, i) <- zz
# #  }
#   trd
# }
# 
# # Upper case all set in 
# .upper_case.commodity <- function(cmd) {
# #  cmd@name <- toupper(cmd@name)
# #  gg <- getClass('commodity')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(cmd, i)) > 0) {
# #    zz <- slot(cmd, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(cmd, i) <- zz
# #  }
#   cmd
# }
# 
# # Upper case all set in 
# .upper_case.constraint <- function(cns) {
# #  slc <- c('tech', 'sup', 'res', 'row', 'trade', 'region', 'comm', 'slice')
# #  cns@name <- toupper(cns@name)
# #  gg <- getClass('constraint')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(cns, i)) > 0) {
# #    zz <- slot(cns, i)
# #    for(j in colnames(zz)[colnames(zz) %in% slc])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(cns, i) <- zz
# #  }
# #  for(i in names(cns@for.each)[names(cns@for.each) %in% slc & !sapply(cns@for.each, is.null)])
# #    cns@for.each[[i]] <- toupper(cns@for.each[[i]])
# #  for(i in names(cns@for.sum)[names(cns@for.sum) %in% slc & !sapply(cns@for.sum, is.null)])
# #    cns@for.sum[[i]] <- toupper(cns@for.sum[[i]])
#   cns
# }
# 
# # Upper case all set in 
# .upper_case.supply <- function(sup) {
# #  sup@name <- toupper(sup@name)
# #  gg <- getClass('supply')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(sup, i)) > 0) {
# #    zz <- slot(sup, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(sup, i) <- zz
# #  }
#   sup
# }
# 
# # Upper case all set in 
# .upper_case.export <- function(exp) {
# #  exp@name <- toupper(exp@name)
# #  gg <- getClass('export')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(exp, i)) > 0) {
# #    zz <- slot(exp, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(exp, i) <- zz
# #  }
#   exp
# }
# 
# # Upper case all set in 
# .upper_case.import <- function(imp) {
# #  imp@name <- toupper(imp@name)
# #  gg <- getClass('import')
# #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
# #  if (nrow(slot(imp, i)) > 0) {
# #    zz <- slot(imp, i)
# #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
# #      zz[, j] <- toupper(zz[, j])
# #    slot(imp, i) <- zz
# #  }
#   imp
# }
# 
# .upper_case.demand <- function(dem) {
#   #  dem@name <- toupper(dem@name)
#   #  gg <- getClass('demand')
#   #  for(i in names(gg@slots)[gg@slots == 'data.frame'])
#   #  if (nrow(slot(dem, i)) > 0) {
#   #    zz <- slot(dem, i)
#   #    for(j in colnames(zz)[colnames(zz) %in% c('region', 'comm', 'slice')])
#   #      zz[, j] <- toupper(zz[, j])
#   #    slot(dem, i) <- zz
#   #  }
#   dem
# }
# .upper_case.weather <- function(wth) {
#   wth
# }
# 
# .upper_case.storage <- function(stg) {
#   stg
# }
# 
# 
# .upper_case.region <- function(reg) {
# #  reg@name <- toupper(reg@name)
#   reg
# }


check_name <- function(x) {
  (
    length(x) != 1 || !is.character(x) || 
      sub('^[[:alpha:]][[:alnum:]_]*$', '', x) == ''
  )
}
