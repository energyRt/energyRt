.split_slice <- function(obj, slice, lev = NULL, na.like = NULL) {
  if (!any(class(obj) %in% c('demand', 'export', 'import', 'trade'))) return(obj)
  slice <- .init_slice(slice)
  if (is.null(lev)) {
    if (any(names(getSlots(class(obj))) == 'slice') && !is.null(obj@slice)) {
      lev <- unique(slice@levels[, obj@slice])
    } else {
      lev <- unique(slice@levels[, ncol(slice@levels) - 1])
    }
  }
  nms <- names(getSlots(class(obj)))
  nms <- nms[sapply(nms, function(x) (class(slot(obj, x)) == 'data.frame' 
                                      && any(colnames(slot(obj, x)) == 'slice')) && nrow(slot(obj, x)) > 0)]
  # Replace NA to slice
  if (!is.null(na.like)) {
    slc <- unique(slice@levels[, na.like])
    for (nn in nms) if (any(is.na(slot(obj, nn)$slice))) {
      dtf <- slot(obj, nn)
      df1 <- dtf[is.na(dtf$slice),, drop = FALSE]
      df2 <- dtf[!is.na(dtf$slice),, drop = FALSE]
      df1[, 'slice'] <- slc[1]
      for (ss in slc[-1]) {
        tmp <- df1; tmp[, 'slice'] <- ss;
        df1 <- rbind(df1, tmp)
      }
      slot(obj, nn) <- rbind(df2, df1)
    }
  }
  # Split higher to lowwer
  nl <- seq(along = slice@slice_map)[sapply(slice@slice_map, function(x) all(x %in% lev))]
  if (nl > 1) {
    sup <- unique(c(slice@levels[, 1:(nl - 1)], recursive = TRUE))
    for (nn in nms) if (any(!is.na(slot(obj, nn)$slice) & slot(obj, nn)$slice %in% sup)) {
      dtf <- slot(obj, nn)
      ft <- (!(sapply(dtf, class) %in% c('character', 'factor')) & !(substr(colnames(dtf), 1, 4) %in% c('pric', 'cost', 'year')))
      fl <- (!is.na(dtf$slice) & dtf$slice %in% sup)
      df1 <- dtf[ fl,, drop = FALSE]
      df2 <- dtf[!fl,, drop = FALSE]
      tt <- slice@all_parent_child[slice@all_parent_child$child %in% lev, ]
      hh <- slice@slice_share$share; names(hh) <- slice@slice_share$slice
      tt[, 'share'] <- hh[tt$child] / hh[tt$parent]
      gg <- NULL
      for (ss in sup) {
        kk <- tt[tt$parent == ss, ]
        tmp <- df1[df1$slice == ss, ];
        for (uu in seq(length.out = nrow(kk))) {
          tm2 <- tmp[tmp$slice == kk[uu, 'parent'], ]; 
          tm2[, ft] <- tm2[, ft] * kk[uu, 'share']
          tm2[, 'slice'] <- kk[uu, 'child']
          if (is.null(gg)) {
            gg <- tm2
          } else gg <- rbind(gg, tm2)
        }
      }
      gg <- gg[!(apply(gg[, !ft, drop = FALSE], 1, paste, collapse = "#") %in% 
                   apply(df1[, !ft, drop = FALSE], 1, paste, collapse = "#")),, drop = FALSE]
      slot(obj, nn) <- rbind(df2, gg)
    }
  }
  # Split lower to higher
  if (nl < ncol(slice@levels) - 1) {
    sup <- unique(c(slice@levels[, (nl + 1):(ncol(slice@levels) - 1)], recursive = TRUE))
    for (nn in nms) if (any(!is.na(slot(obj, nn)$slice) & slot(obj, nn)$slice %in% sup)) {
      dtf <- slot(obj, nn)
      ft <- (!(sapply(dtf, class) %in% c('character', 'factor')) & substr(colnames(dtf), 1, 4) != 'year')
      fl <- (!is.na(dtf$slice) & dtf$slice %in% sup)
      df1 <- dtf[ fl,, drop = FALSE]
      df2 <- dtf[!fl,, drop = FALSE]
      tt <- slice@all_parent_child[slice@all_parent_child$parent %in% lev, ]
      hh <- slice@slice_share$share; names(hh) <- slice@slice_share$slice
      tt[, 'share'] <-hh[tt$child]
      gg <- NULL
      for (ss in unique(tt$parent)) {
        kk <- tt[tt$parent == ss, ]
        tmp <- df1[df1$slice %in% kk$child, ];
        ll <- apply(tmp[, (!ft & colnames(tmp) != 'slice'), drop = FALSE], 1, paste, collapse = "#")
        ee <- seq(along = ll)[!duplicated(ll)]
        for (uu in ee) {
          tm2 <- tmp[ll[uu] == ll, ]; 
          qq <- hh[tm2[, 'slice']]
          jj <- apply(tm2[, ft], 2, function(x) {
            if (all(is.na(x))) return(NA)
            (sum(x) * sum(qq) / sum(qq[!is.na(x)]))
          }); 
          gh <- tmp[uu, ]; gh[1, ft] <- jj;
          gh[, 'slice'] <- ss
          if (is.null(gg)) {
            gg <- gh
          } else gg <- rbind(gg, gh)
        }
      }
      gg <- gg[!(apply(gg[, !ft, drop = FALSE], 1, paste, collapse = "#") %in% 
                   apply(df1[, !ft, drop = FALSE], 1, paste, collapse = "#")),, drop = FALSE]
      slot(obj, nn) <- rbind(df2, gg)
    }
  }
  obj
}
