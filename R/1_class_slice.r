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
  dtf <- sl@levels
  sl@misc$slice_map <- lapply(dtf[, -ncol(dtf), drop = FALSE], unique)
  names(sl@misc$slice_map) <- colnames(dtf)[-ncol(dtf)]
  sl@misc$slice_ln <-lapply(sl@misc$slice_map, length)
  names(sl@misc$slice_ln) <- colnames(dtf)[-ncol(dtf)]
  sl@misc$slice_level <- list()
  # Calculate sub slice
  sbs <- list()
  dtf0 <- dtf[, 2:(ncol(dtf) - 1), drop = FALSE]
  if (ncol(dtf) > 3) {
    for (i in ncol(dtf0):2 - 1) {
      tm2 <- unique(dtf0[, i + 1])
      tmp <- unique(apply(dtf0[, 1:i, drop = FALSE], 1, paste, collapse = "_"))
      sl@misc$slice_level[[colnames(dtf0)[i]]] <- tmp
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
  sl@misc$slice_level[[colnames(dtf)[1]]] <- dtf[1, 1]
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
  # Default slice level
  sl@misc$default_slice_level <- colnames(dtf0)[ncol(dtf0)]
  # deep level slice 
  sl@misc$deep <- (2:ncol(dtf) - 1)
  names(sl@misc$deep) <- colnames(dtf)[-ncol(dtf)]
  sl
}


#sl <- new('slice')
#sl@levels <- .setSlice(year = 'ANNUAL', ll = c('l1', 'l2'), nn = c('n1', 'n2'), hh = c('h1', 'h2'))
# .init_slice(sl)

