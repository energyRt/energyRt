#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels         = "data.frame",
          misc           = "list"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE),
        misc = list()
      ),                           
      S3methods = TRUE
);
             
.init_slice <- function(sl) {
  if (nrow(sl@levels) == 0) { 
    warning('There is not slice, add "ANNUAL"')
    sl@levels <- .setSlice(year = 'ANNUAL')
  }
  # Check for correctness of data frame
  .slice_check_data(sl@levels)
  # Fill misc list for compilation 
  msc <- list()
  dtf <- sl@levels
  if (nrow(dtf) == 1) {
    dtf[, '_full.name'] <- dtf[, 1]
  } else {
    dtf[, '_full_name'] <- apply(dtf[, -c(1, ncol(dtf)), drop = FALSE], 1, paste, collapse = "_")
  }
  # dtf
  # Calculate sub slice
  sbs <- list()
  if (ncol(dtf) > 3) {
    dtf0 <- dtf[, 2:(ncol(dtf) - 2), drop = FALSE]
    for (i in ncol(dtf0):2 - 1) {
      tm2 <- unique(dtf0[, i + 1])
      tmp <- unique(apply(dtf0[, 1:i, drop = FALSE], 1, paste, collapse = "_"))
      for (xx in unique(tmp)) {
        oo <- paste(xx, '_', tm2, sep = '')
        sbs[[xx]] <- c(oo, sbs[oo], recursive = TRUE)
        names(sbs[[xx]]) <- NULL
      }
    }
  }
  tm2 <- unique(dtf0[, 1])
  sbs[[dtf[1, 1]]] <- c(tm2, sbs[tm2], recursive = TRUE)
  names(sbs[[dtf[1, 1]]]) <- NULL
  # to data.frame
  dtf_loup <- data.frame(par = character(), sub = character(), stringsAsFactors = FALSE)
  dtf_loup[1:sum(sapply(sbs, length)), ] <- NA
  k <- 0
  for (i in names(sbs)) {
    nn <- (k + 1:length(sbs[[i]]))
    dtf_loup[nn, 'par'] <- i
    dtf_loup[nn, 'sub'] <- sbs[[i]]
    k <- k + length(sbs[[i]])
  }
  sl@misc$psrsubmap <- dtf_loup
  sl
}


#sl <- new('slice')
#sl@levels <- .setSlice(year = 'ANNUAL', ll = c('l1', 'l2'), nn = c('n1', 'n2'), hh = c('h1', 'h2'))
# .init_slice(sl)

