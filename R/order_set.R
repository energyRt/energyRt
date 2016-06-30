order_set <- function(x) {
  gg <- c('tech', 'sup', 'res', 'row',
    'trade', 'group', 'comm', 'region', 'year', 'slice')
  gg[gg %in% x]
}