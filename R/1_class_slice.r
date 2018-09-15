#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels           = "data.frame",
          slice_share      = "data.frame", # Slice that after all, e.g.: ANNUAL, WINTER, WINTER_DAY, and so on with share
          parent_child     = "data.frame", # Stright relation parent-child
          all_parent_child = "data.frame", # All relation parent-child
          slice_map        = "list", # Slices set by level
          default_slice_level = "characterOrNULL", # Default slice map
          all_slice        = "characterOrNULL", 
          misc             = "list"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE),
        slice_share      = data.frame(slice = character(), share = numeric(), stringsAsFactors = FALSE),
        parent_child     = data.frame(parent = character(), child = character(), stringsAsFactors = FALSE),
        all_parent_child = data.frame(parent = character(), child = character(), stringsAsFactors = FALSE),
        slice_map        = list(), # Slices set by level
        default_slice_level      = NULL, # Default slice map
        all_slice        = NULL,
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
  sl@misc <- list()
  # Calculate other data
    dtf <- sl@levels
    # deep level slice 
    sl@misc$deep <- (2:ncol(dtf) - 1)
    names(sl@misc$deep) <- colnames(dtf)[-ncol(dtf)]
    # count level slice 
    sl@misc$nlevel <- sapply(dtf[, -ncol(dtf), drop = FALSE], function(x) length(unique(x)))
    names(sl@misc$nlevel) <- colnames(dtf)[-ncol(dtf)]
    
    sl@slice_share[1:sum(sapply(seq(along = sl@misc$nlevel), function(x) prod(sl@misc$nlevel[1:x]))), ] <- NA
    #   
    sl@slice_share[1, 'slice'] <- dtf[1, 1]
    sl@slice_share[1, 'share'] <- 1
    k <- 1
    if (ncol(dtf) > 2) {
      for (i in 2:(ncol(dtf) - 1)) {
        tmp <- apply(dtf[, 2:i, drop = FALSE], 1, paste, collapse = '_')
        tmp <- tapply(dtf[, ncol(dtf)], tmp, sum)
        sl@slice_share[k + seq(along = tmp), 'slice'] <- names(tmp)
        sl@slice_share[k + seq(along = tmp), 'share'] <- tmp
        k <- (k + length(tmp))
      }
    }
    # parent_child
    if (nrow(sl@levels) == 1) {
      sl@parent_child <- sl@parent_child[0,, drop = FALSE]
      sl@all_parent_child <- sl@all_parent_child[0,, drop = FALSE]
    } else {
      sl@parent_child <- sl@parent_child[0,]
      #sl@parent_child$lev <- numeric()
      sl@parent_child[1:(nrow(sl@slice_share) - 1), ] <- NA
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
      sl@all_parent_child[sum(sapply(seq(along = sl@misc$nlevel), function(x) prod(sl@misc$nlevel[1:x]) * (x - 1))), ] <- NA
      l2 <- unique(c(sl@parent_child$parent, sl@parent_child$child))
      l2 <- l2[l2 != sl@levels[1, 1]]      
      sl@all_parent_child[1:length(l2), 'parent'] <- sl@levels[1, 1]
      sl@all_parent_child[1:length(l2), 'child'] <- l2
      tt <- sl@parent_child[sl@parent_child$parent != sl@levels[1, 1],, drop = FALSE]
      k <- length(l2)
      for (i in l2) {
        kk <- grep(paste('^', i, '_', sep = ''), sl@parent_child$child)
        sl@all_parent_child[k + seq(along = kk), 'parent'] <- i
        sl@all_parent_child[k + seq(along = kk), 'child'] <- sl@parent_child[kk, 'child']
        k <- (length(kk) + k)
      }  
    }
  # slice_map  
  tmp <- nchar(sl@slice_share$slice) - nchar(gsub('[_]', '', sl@slice_share$slice)) + 2
  names(tmp) <- sl@slice_share$slice
  tmp[sl@levels[1, 1]] <- 1
  sl@slice_map <- lapply(1:(ncol(sl@levels) - 1), function(x) names(tmp)[tmp == x])
  names(sl@slice_map) <- colnames(sl@levels)[-ncol(sl@levels)]
  sl@default_slice_level <- colnames(sl@levels)[ncol(sl@levels) - 1]
  sl@all_slice <- sl@slice_share$slice
  
  # next_slice <- list()
  sl@misc$next_slice <- NULL
  if (nrow(sl@levels) != 1) {
    tmp <- sl@parent_child; 
    #tmp$lv <- NA; 
    tmp$next_slice <- NA
    #for (i in names(sl@slice_map))
    #  tmp[tmp$parent %in% sl@slice_map[[i]], 'lv'] <- i
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
    sl@misc$next_slice <- data.frame(slice = tmp$child, slicep = tmp$next_slice, stringsAsFactors = FALSE)
  }
  sl
}



