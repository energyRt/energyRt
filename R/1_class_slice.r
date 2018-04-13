#---------------------------------------------------------------------------------------------------------
# slice
#---------------------------------------------------------------------------------------------------------
setClass("slice",
      representation(
          levels           = "data.frame",
          slice_share      = "data.frame", # Slice that after all, e.g.: ANNUAL, WINTER, WINTER_DAY, and so on with share
          parent_child     = "data.frame", # Stright relation parent-child
          all_parent_child = "data.frame", # All relation parent-child
          misc             = "list"
      ),
      prototype(
        levels           = data.frame(stringsAsFactors = FALSE),
        slice_share      = data.frame(slice = character(), share = numeric(), stringsAsFactors = FALSE),
        parent_child     = data.frame(parent = character(), child = character(), stringsAsFactors = FALSE),
        all_parent_child = data.frame(parent = character(), child = character(), stringsAsFactors = FALSE),
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
      sl@all_parent_child <- sl@all_parent_child[0,, drop = FALSE]
      # sl@all_parent_child[sum(sapply(seq(along = sl@misc$nlevel), function(x) prod(sl@misc$nlevel[1:x]) * (x - 1))), ] <- NA
      
      k <- 0
      for (i in 1:(ncol(dtf) - 2)) {
        l <- nrow(dtf) / prod(sl@misc$nlevel[i]); k <- 1;
        while (k < nrow(dtf)) {
          if (i == 1) s1 <- dtf[k, 1] else s1 <- paste(dtf[k, 2:i, drop = FALSE], collapse = '_')
          for (z in (i + 1):(ncol(dtf) - 1)) {
            uu <- prod(sl@misc$nlevel[2:z])
            tmp <- data.frame(parent = rep(s1, uu), 
                              child = apply(dtf[k - 1 + seq(1, nrow(dtf), by  = uu), 2:z, drop = FALSE], 1, paste, collapse = '_'), 
                              stringsAsFactors = FALSE)
            sl@all_parent_child <- rbind(sl@all_parent_child, tmp)
          }
          k <- k + l
        }
      }
        
        jj <- seq(1, nrow(dtf), length.out = prod(sl@misc$nlevel[i]))
        if (i == 1) s1 <- dtf[jj, 1] else s1 <- apply(dtf[jj, 2:i, drop = FALSE], 1, paste, collapse = '_')
        for (j in seq(along = jj)) {
          for (l in (i + 1):(ncol(dtf) - 1)) {
            s2 <- apply(dtf[, 2:l, drop = FALSE], 1, paste, collapse = '_')
            kk <- k + 1:length(s2)
            sl@all_parent_child[kk, 'parent'] <- s1[j]
            sl@all_parent_child[kk, 'child'] <- s2
            k <- k + length(s2)
          }
        }
        k <- k + l
      }
      
      
      rtt <-list()
      for (i in 1:nrow(sl@slice_share)) {
        
      }
      
      hh <- sum(sapply(seq(along = sl@misc$nlevel), function(x) prod(sl@misc$nlevel[1:x]) * (x - 1)))
      
      
      tt <- sl@all_parent_child
      tt[, ncol(tt)][tt[, ncol(tt)] %in% tt[, ncol(tt) - 1]]
      
      for (i in ) tt <- 
      
      #sl@parent_child$lev <- NULL 
      k <- 0
      for (i in 1:(ncol(dtf) - 2)) {
        jj <- seq(1, nrow(dtf), length.out = prod(sl@misc$nlevel[i]))
        if (i == 1) s1 <- dtf[jj, 1] else s1 <- apply(dtf[jj, 2:i, drop = FALSE], 1, paste, collapse = '_')
        for (j in seq(along = jj)) {
          for (l in (i + 1):(ncol(dtf) - 1)) {
            s2 <- apply(dtf[, 2:l, drop = FALSE], 1, paste, collapse = '_')
            kk <- k + 1:length(s2)
            sl@all_parent_child[kk, 'parent'] <- s1[j]
            sl@all_parent_child[kk, 'child'] <- s2
            k <- k + length(s2)
          }
        }
      }
      
      
        s2 <- apply(dtf[, 2:i, drop = FALSE], 1, paste, collapse = '_')
        ff <- apply(dtf[seq(1, nrow(dtf), length.out = prod(sl@misc$nlevel[i - 1])), 1:(i -1), 
                        drop = FALSE], 1, paste, collapse = '_')
        
        
        
        if (i == (ncol(dtf) - 1)) {
          
        }
        # add matrix
        fl <- seq(along = )(sl@all_parent_child$lev == i)      
        nn <- sl@all_parent_child$parent[fl]
        names(nn) <- sl@all_parent_child$child[fl]
        f2 <- seq(along = sl@all_parent_child$parent)[sl@all_parent_child$parent %in% names(nn)]
        kk <- nrow(sl@all_parent_child) + 1:length(f2)
        sl@all_parent_child[kk, 'child'] <- sl@all_parent_child[f2, 'child']
        sl@all_parent_child[kk, 'parent'] <-nn[sl@all_parent_child[f2, 'parent']]
        sl@all_parent_child[kk, 'parent'] <-nn[sl@all_parent_child[f2, 'parent']]
      }
      
    }

    
    
      # Fill misc list for compilation 
  dtf <- sl@levels
  sl@misc$slice_map <- lapply(dtf[, -ncol(dtf), drop = FALSE], unique)
  names(sl@misc$slice_map) <- colnames(dtf)[-ncol(dtf)]
  sl@misc$slice_ln <-lapply(sl@misc$slice_map, length)
  names(sl@misc$slice_ln) <- colnames(dtf)[-ncol(dtf)]
  sl@misc$slice_level <- list()
  # Calculate pair (parent, child) slice
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
  sl@misc$parent_child <- dtf_loup
  # Default slice level
  sl@misc$default_slice_level <- colnames(dtf0)[ncol(dtf0)]
  # deep level slice 
  sl@misc$deep <- (2:ncol(dtf) - 1)
  names(sl@misc$deep) <- colnames(dtf)[-ncol(dtf)]
  # Time share foe everi slice
  unique_slice_n <- sapply(seq(along = sl@misc$deep), function(x) prod(sl@misc$deep[1:x]))
  unique_slice <- lapply(seq(along = sl@misc$deep[-1]), function(x) unique(sl@misc$deep[2:x]))
  slice_share <- data.frame(slice, 
  
  
  sl
}


#sl <- new('slice')
#sl@levels <- .setSlice(year = 'ANNUAL', ll = c('l1', 'l2'), nn = c('n1', 'n2'), hh = c('h1', 'h2'))
# .init_slice(sl)

