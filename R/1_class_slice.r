#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
# !!! rename? slice_share -> share
# all_slice -> ???
# all_parent_child -> ???
setClass("slice",
      representation(
          levels           = "data.table",
          slice_share      = "data.table", # Slice that after all, e.g.: ANNUAL, WINTER, WINTER_DAY, and so on with share
          parent_child     = "data.table", # Stright relation parent-child
          all_parent_child = "data.table", # All relation parent-child
          slice_map        = "list", # Slices set by level
          default_slice_level = "character", # Default slice map
          all_slice        = "character", 
          misc             = "list"
      ),
      prototype(
        levels           = data.table(),
        slice_share      = data.table(slice = character(), share = numeric()),
        parent_child     = data.table(parent = character(), child = character()),
        all_parent_child = data.table(parent = character(), child = character()),
        slice_map        = list(), # Slices set by level
        default_slice_level      = character(), # Default slice map
        all_slice        = character(),
        misc = list()
      ),                           
      S3methods = TRUE
);
             
.init_slice <- function(sl) {
  if (nrow(sl@levels) == 0) { 
    warning('There is not slice, add "ANNUAL"')
    sl@levels <- .setSlice(ANNUAL = 'ANNUAL')
  }
  # Check for correctness of data frame
  .slice_check_data(sl@levels)
  sl@misc <- list()
  # Calculate other data
    dtf <- sl@levels
    # deep level slice 
    sl@misc$deep <- (2:ncol(dtf) - 1)
    names(sl@misc$deep) <- colnames(dtf)[-ncol(dtf)]
    # count level slice 
    sl@misc$nlevel <- sapply(dtf[, -ncol(dtf), with = FALSE], function(x) length(unique(x)))
    names(sl@misc$nlevel) <- colnames(dtf)[-ncol(dtf)]
    
    sl@slice_share <- sl@slice_share[0, ] %>% add_row(slice = rep(NA, sum(sapply(seq(along = sl@misc$nlevel), function(x) prod(sl@misc$nlevel[1:x])))))
    #   
    sl@slice_share$slice[1] <- dtf[[1]][1]
    sl@slice_share$share[1] <- 1
    k <- 1
    if (ncol(dtf) > 2) {
      for (i in 2:(ncol(dtf) - 1)) {
        tmp <- apply(dtf[, 2:i, with = FALSE], 1, paste, collapse = '_')
        tmp <- tapply(dtf[[ncol(dtf)]], tmp, sum)
        sl@slice_share[k + seq(along = tmp), 'slice'] <- names(tmp)
        sl@slice_share[k + seq(along = tmp), 'share'] <- tmp
        k <- (k + length(tmp))
      }
    }
      # slice_map & all_slice
      tmp <- nchar(sl@slice_share$slice) - nchar(gsub('[_]', '', sl@slice_share$slice)) + 2
      names(tmp) <- sl@slice_share$slice
      tmp[sl@levels[[1]][1]] <- 1
      sl@slice_map <- lapply(1:(ncol(sl@levels) - 1), function(x) names(tmp)[tmp == x])
      names(sl@slice_map) <- colnames(sl@levels)[-ncol(sl@levels)]
      sl@default_slice_level <- colnames(sl@levels)[ncol(sl@levels) - 1]
      sl@all_slice <- sl@slice_share$slice

    
    # parent_child
    if (nrow(sl@levels) == 1) {
      sl@parent_child <- sl@parent_child[0,]
      sl@all_parent_child <- sl@all_parent_child[0,]
    } else {
      sl@parent_child <- sl@parent_child[0,] %>% add_row(parent = rep(NA, (nrow(sl@slice_share) - 1)))
      i <- 1; k <- 0; z <- 1
      while (i != ncol(dtf) - 1) {
        l <- sl@misc$nlevel[i + 1]
        for (j in 1:sl@misc$nlevel[i]) {
          sl@parent_child[k + 1:l, 'parent'] <- sl@slice_share[z, 'slice']
          sl@parent_child[k + 1:l, 'child'] <- sl@slice_share[1 + k + 1:l, 'slice']
          #sl@parent_child[k + 1:l, 'lev'] <- i + 1
          k <- k + l
          z <- z + 1
        }
        i <- i + 1
      }
      # all parent child realtion fill
      tmp <- sl@parent_child
      tmp$nlev <- NA
      for (i in seq_along(sl@slice_map)) {
        tmp[tmp$parent %in% sl@slice_map[[i]], 'nlev'] <- i
      }
      ll <- tmp[tmp$nlev  + 1 == length(sl@slice_map), -3]
      for (i in rev(seq_along(sl@slice_map))[-(1:2)]) {
        gg <- tmp[tmp$nlev == i, -3]; g3 <- gg;
        colnames(gg)[2] <- 'sht'
        l2 <- ll
        colnames(l2)[1] <- 'sht'
        g2 <- merge(gg, l2); g2$sht <- NULL
        ll <- rbind(ll, g2, g3)  
      }
      sl@all_parent_child <- ll
    }
  
  # next_slice <- list()
  sl@misc$next_slice <- NULL
  if (nrow(sl@levels) != 1) {
    tmp <- sl@parent_child; 
    tmp$next_slice <- NA
    j <- 1
    for (i in 1:(nrow(tmp) - 1)) {
      if (tmp[i, 'parent'] == tmp[i + 1, 'parent']) {
        tmp[i, 'next_slice'] <- tmp[i + 1, 'child']
      } else {
        tmp[i, 'next_slice'] <- tmp[j, 'child']
        j <- i + 1
      }
    }
    tmp[i + 1, 'next_slice'] <- tmp[j, 'child']
    sl@misc$next_slice <- data.table(slice = tmp$child, slicep = tmp$next_slice, stringsAsFactors = FALSE)
    n1 <- c(lapply(sl@slice_map[-1], function(x) x), recursive = TRUE); names(n1) <- NULL
    n2 <- c(lapply(sl@slice_map[-1], function(x) c(x[-1], x[1])), recursive = TRUE); 
    names(n2) <- NULL
    sl@misc$fyear_next_slice <- data.table(slice = n1, slicep = n2, stringsAsFactors = FALSE)
  }
  sl
}



