#==============================================================================#
# ???? ####
#==============================================================================#
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
    sup <- unique(c(slice@slice_map[1:(nl - 1)], recursive = TRUE))
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
      for (ss in sup) if (any(df1$slice == ss)) {
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
    sup <- unique(c(slice@slice_map[(nl + 1):(ncol(slice@levels) - 1)], recursive = TRUE))
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

#==============================================================================#
# Check if slice level exist ####
#==============================================================================#
.checkSliceLevel <- function(app, approxim) {
  if (length(app@slice) != 0 && all(app@slice != colnames(approxim$slice@levels)[-ncol(approxim$slice@levels)]))
    stop(paste0('Unknown slice level "', app@slice, '" for ', class(app), ': "', app@name, '"'))
}
#==============================================================================#
# Disaggregate slice ####
# e.g. from WINTER to WINTER_DAY and WINTER_NIGHT
#==============================================================================#
.disaggregateSliceLevel <- function(app, approxim) {
  slt <- getSlots(class(app)) 
  slt <- names(slt)[slt == 'data.frame']
  if (class(app) == 'technology') slt <- slt[slt != 'afs']
  for (ss in slt) if (any(colnames(slot(app, ss)) == 'slice')) {
    tmp <- slot(app, ss)
    fl <- (!is.na(tmp$slice) & !(tmp$slice %in% approxim$slice))
    if (any(fl)) {
      mark_col <- (sapply(tmp, is.character) | colnames(tmp) == 'year')
      mark_coli <- colnames(tmp)[mark_col]
      t1 <- tmp[fl,, drop = FALSE]
      t2 <- tmp[!fl,, drop = FALSE]
      # Sort from lowest level to largest
      ff <- approxim$parent_child$parent[!duplicated(approxim$parent_child$parent)]
      f1 <- seq_along(ff)
      names(f1) <- ff
      if (!all(t1$slice %in% ff))
        stop(paste0('Unknown slice or slice is not parrent slice, for "', app@name, '" (class ', class(app), '), slot: "',
                    ss, '", slice: "', paste0(t1$slice[!(t1$slice %in% ff)], collapse = '", "'), '"'))      
      t1 <- t1[sort(f1[t1$slice], index.return = TRUE, decreasing = TRUE)$ix,, drop = FALSE]
      # Add child desaggregation 
      for (i in seq_len(nrow(t1))) {
        ll <- approxim$parent_child[approxim$parent_child$parent == t1[i, 'slice'], 'child']
        t0 <- t1[rep(i, length(ll)),, drop = FALSE]
        t0$slice <- ll
        tes <- t0[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z1 <- apply(tes, 1, paste0, collapse = '##')
        tes <- t2[, mark_coli, drop = FALSE]; tes[is.na(tes)] <- '-'
        z2 <- apply(tes, 1, paste0, collapse = '##')
        # If there are the same row, after splititng
        if (any(z1 %in% z2)) {
          merge_col <- merge(t0, t2, by = mark_coli)
          colnames(merge_col)[seq_len(ncol(t0))] <- colnames(t0)
          for (j in colnames(tmp)[!mark_col])
            merge_col[!is.na(merge_col[, paste0(j, '.y')]), j] <- NA
          t0 <- rbind(t0[!((z1 %in% z2)), ], merge_col[, 1:ncol(t0)])
        }
        t2 <- rbind(t2, t0)
      }
      slot(app, ss) <- t2
    }
  }
  app
}

