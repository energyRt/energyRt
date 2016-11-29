check_maptable <- function(prec) {
  error_type <- c()
  # Check that lo bound less or equal up bound
  for(pr in names(prec@maptable)[sapply(prec@maptable,
    function(x) x@type == 'double')]) 
      if (nrow(prec@maptable[[pr]]@data) > 0 && prec@maptable[[pr]]@true_length != 0) {
    if (prec@maptable[[pr]]@true_length != -1)  
      prec@maptable[[pr]]@data <- prec@maptable[[pr]]@data[seq(length.out = 
        prec@maptable[[pr]]@true_length),, drop = FALSE]
    gg <- prec@maptable[[pr]]@data
    fl <- gg[gg$type == 'lo', 'Freq'] > gg[gg$type == 'up', 'Freq']
    stopifnot(all(gg[gg$type == 'lo', 0:1 - ncol(gg)] ==
        gg[gg$type == 'up', 0:1 - ncol(gg)]))
    if (any(fl)) {
      error_type <- c(error_type, pr)
      cat('Error: Unexcaptable bound value (up bound less lo bound) "',
        pr, '":\n', sep = '')
      invisible(apply(gg[gg$type == 'lo', 0:1 - ncol(gg)][fl, ], 1, function(x)
        cat(paste(x, collapse = '.'), '\n')))
    }
  }
  if (length(error_type)) stop('Unexcaptable bound value (up bound less lo bound) "',
    paste(error_type, collapse = '", "'), '"')
  shr <- prec@maptable$pTechShare@data
#  # Check sum share.lo <= 1 and sum share.up >= 1
  if (nrow(shr) > 0) {
  FL <- FALSE
  p1 <- proc.time()[3]
    # Devide commodity by technology/group/inp&out
    inp_comm <- prec@maptable$mTechInpComm@data
    out_comm <- prec@maptable$mTechOutComm@data
    group_comm <- prec@maptable$mTechGroupComm@data
    inp_comm[, 'als'] <- 'input'
    out_comm[, 'als'] <- 'output'
    shr <- merge(merge(shr, group_comm), rbind(inp_comm, out_comm))
    # Check and out
    hh <- tapply(shr$Freq, shr[, c('type', 'tech', 'als', 'group', 'region', 'year', 'slice')], sum)
    if (max(hh['lo',,,,,,], na.rm = TRUE) > 1) {
      FL <- TRUE
      ll <- apply(hh['lo',,,,,,, drop = FALSE], 2:7, sum); ll[is.na(ll)] <- 0
      tec <- dimnames(ll)[[1]][apply(ll > 1, 1, any)]
      for(tt in tec) {
        al <- dimnames(ll)[[2]][apply(ll[tt,,,,,, drop = FALSE] > 1, 2, any)]
        for(a in al) {
          gr <- dimnames(ll)[[3]][apply(ll[tt, a,,,,, drop = FALSE] > 1, 2, any)]
          for(g in gr) {
            if (length(unique(ll[tt, a, g,,,])) == 1) {
              #cat('', tt, a, g, '\n')
              cat('Share lo more than 1 for ', a, ' commodity: ', tt, '.',
                 g, '.*.*.*', ' ', ll[tt, a, g, 1, 1, ], '\n', sep = '')
            }  else {
              rg <- dimnames(ll)[[4]][apply(ll[tt, a, g,,,, drop = FALSE] > 1, 
                2, any)][1]
              yr <- dimnames(ll)[[5]][apply(ll[tt, a, g, rg,,, drop = FALSE] > 1, 
                2, any)][1]
              sl <- dimnames(ll)[[6]][apply(ll[tt, a, g, rg, yr,, drop = FALSE] > 1, 
                2, any)][1]
              cat('Share lo more than 1 for ', a, ' commodity, first row: ', tt, '.',
                 g, '.', rg, '.', yr, '.', sl, ' ', ll[tt, a, g, rg, yr, sl], 
                   '\n', sep = '')
              }
            }
          }
        }
      }
    if (min(hh['up',,,,,,], na.rm = TRUE) < 1) {
      FL <- TRUE
      ll <- apply(hh['up',,,,,,, drop = FALSE], 2:7, sum); ll[is.na(ll)] <- 1
      tec <- dimnames(ll)[[1]][apply(ll < 1, 1, any)]
      for(tt in tec) {
        al <- dimnames(ll)[[2]][apply(ll[tt,,,,,, drop = FALSE] < 1, 2, any)]
        for(a in al) {
          gr <- dimnames(ll)[[3]][apply(ll[tt, a,,,,, drop = FALSE] < 1, 2, any)]
          for(g in gr) {
            if (length(unique(ll[tt, a, g,,,])) == 1) {
              #cat('', tt, a, g, '\n')
              cat('Share up less than 1 for ', a, ' commodity: ', tt, '.',
                 g, '.*.*.*', ' ', ll[tt, a, g, 1, 1, ], '\n', sep = '')
            }  else {
              rg <- dimnames(ll)[[4]][apply(ll[tt, a, g,,,, drop = FALSE] < 1, 
                2, any)][1]
              yr <- dimnames(ll)[[5]][apply(ll[tt, a, g, rg,,, drop = FALSE] < 1, 
                2, any)][1]
              sl <- dimnames(ll)[[6]][apply(ll[tt, a, g, rg, yr,, drop = FALSE] < 1, 
                2, any)][1]
              cat('Share up less than 1 for ', a, ' commodity, first row: ', tt, '.',
                 g, '.', rg, '.', yr, '.', sl, ' ', ll[tt, a, g, rg, yr, sl], 
                   '\n', sep = '')
              }
            }
          }
        }
      }
    if (FL) stop('Unexceptable share parameter')
  }
}

