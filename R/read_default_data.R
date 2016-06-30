read_default_data <- function(prec, ss) {
  for(i in seq(along = prec@maptable)) {
    if (any(prec@maptable[[i]]@for_sysInfo != '')) {
      prec@maptable[[i]]@default <-
        as.numeric(ss@default[1, prec@maptable[[i]]@for_sysInfo])
      prec@maptable[[i]]@interpolation <-
        as.character(ss@interpolation[1, prec@maptable[[i]]@for_sysInfo])
    }
  }
  prec
}