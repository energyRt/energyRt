get_use_commodity <- function(x) UseMethod("get_use_commodity")

get_use_commodity.technology <- function(x) get_set(x, 'comm')

get_use_commodity.rTechnology <- function(x) {
  toupper(unique(c(lapply(x@data, function(z) get_set(z, 'comm')), recursive = TRUE)))
}

get_use_commodity.rCommodity <- function(x) {
  toupper(unique(sapply(x@data, function(z) z@name)))
}

get_use_commodity.rSupply <- function(x) {
  toupper(unique(sapply(x@data, function(z) z@commodity)))
}

get_use_commodity.rDemand <- function(x) {
  toupper(unique(sapply(x@data, function(z) z@name)))
}

get_use_commodity.model <- function(x) {
  unique(c(lapply(x@data, function(z) get_use_commodity(z)), recursive = TRUE))
}
