#' Graphical scetch of technology
#' 
#' \code{draw} is a method for class \code{technology} to graphically depict  
#' input, output, and key parameters of technology
#' @name draw
#' @docType methods
#' 
#' @param tech object of class \code{technology}
#' @param year numeric, the year of operation, optional, in case of some parameters vary by years;
#' if missing, years are ingored, the first assigned parameter is considered. 
#' @param slice character, the time slice, similar to year
#' @param reg character, the region
#' 
draw <- function (...) UseMethod("draw")


draw.technology <- function(        
              tech,
              year = NULL ,
              region = NULL,
              slice = NULL,
              ARROW_FONT = NULL,
              CEX_GREFF = .65,
              act_col = 'red3',
              aux_col = 'royalblue3',
              ncomb_col = 'seagreen3',
              bbcol1 = 'lightblue',
              bbcol2 = 'white',
              sng_lwd = 4,
              grp_lwd = 2,
              rule = new('sysInfo')@interpolation,
              default = new('sysInfo')@default,
              show_all = TRUE
  ) {
  MAR <- par()$mar
  tryCatch({
    par(mar=rep(0,4), mai=rep(0,4))
    if (is.null(region)) {
      region <- get_set(tech, 'region')
      if (length(region) == 0) region <- 'DEF'
      region <- region[1]
    }
    if (is.null(slice)) {
      slice <- get_set(tech, 'slice')
      if (length(slice) == 0) slice <- 'ANNUAL'
      slice <- slice[1]
    }
    if (is.null(year)) {
      year <- get_set(tech, 'year')
      if (length(year) == 0) year <- 2005
      year <- as.numeric(year[1])
    }
    year <- as.numeric(year[1])
    plot.new()
    if (nrow(tech@color) == 0) cll <- rgb(220/255,230/255,242/255) else {
      fl <- !is.na(tech@color$region) & tech@color$region == region & !is.na(tech@color$color)
      if (any(fl)) cll <- tech@color$color[fl][1]
      fl <- is.na(tech@color$region) & !is.na(tech@color$color)
      if (any(fl)) cll <- tech@color$color[fl][1]
    }
    ar_shift <- .04
    lo_border <- .025
    up_border <- .9
    rn_border <- up_border - lo_border
    rect(.25, lo_border, .77, .9, lwd=4, col = cll, border=rgb(56/255,93/255,138/255))
    text(.5,1, tech@name, cex = 1.5)
    text(.5, .95, tech@description)
    ctype <- checkInpOut(tech)
    ctype$comm <- ctype$comm[rev(c(seq(length.out = nrow(ctype$comm))[
       !is.na(ctype$comm$group)][sort(ctype$comm$group[!is.na(ctype$comm$group)], 
      index.return = TRUE)$ix], 
        seq(length.out = nrow(ctype$comm))[is.na(ctype$comm$group)])),, drop = FALSE]
    acomm <- tech@aux$acomm 
    acomm <- acomm[acomm %in% tech@aeff$acomm] 
    if (length(acomm) != 0) {
      approxim <- list(region = region, year = year, slice = slice, comm = acomm)
      aname <- c('act2ainp', 'act2aout', 'use2ainp', 'use2aout', 'cap2ainp', 'cap2aout', 'ncap2ainp', 'ncap2aout')
      acname <- c('cinp2ainp', 'cout2ainp', 'cinp2aout', 'cout2aout')
      aparam <- lapply(acomm, function(y) {
        approxim$acomm <- y
        approxim$comm <- NULL
        tech@aeff <- tech@aeff[tech@aeff$acomm == y,, drop = FALSE]
        sng <- sapply(aname, function(x) interpolation(tech@aeff, x, 
                                default = as.numeric(default[x]), 
                                rule = rule[x], 
                                year_range = range(year),
                                approxim = approxim)[, x])
        sng <- sng[sng != 0]
        ll <- tech@aeff[tech@aeff$acomm == y, , drop = FALSE]
        approxim$comm <- unique(ll[, 'comm'])
        dbl <- lapply(acname, function(x) {
          hh <- interpolation(ll, x, default = as.numeric(default[x]), 
                                rule = rule[x], 
                                year_range = range(year),
                                approxim = approxim)
          hh[hh[, x] != 0,, drop = FALSE]
        })
        names(dbl) <- acname
        dbl <- dbl[sapply(dbl, nrow) != 0]
        list(single = sng, wcomm = dbl, input = any(names(sng) %in% c('act2ainp', 
            'use2ainp', 'cap2ainp', 'ncap2ainp')) || any(names(dbl) %in% c('cinp2ainp', 'cout2ainp')), 
            output = any(names(sng) %in% c('act2aout', 
            'use2aout', 'cap2aout', 'ncap2aout')) || any(names(dbl) %in% c('cinp2aout', 'cout2aout')))
      })
      names(aparam) <- acomm
      ainp <- names(aparam)[sapply(aparam, function(x) x$input)]
      aout <- names(aparam)[sapply(aparam, function(x) x$output)]
    } else {
      ainp <- NULL
      aout <- NULL
    }
    if (any(!(tech@geff$group %in% tech@input$group))) {
      stop(paste('There are undifend "group": ', paste(unique(tech@geff$group[
        !(tech@geff$group %in% tech@input$group)]), collapse = '", "'), sep = ''))
    }
    # LHS
    ccomm <- ctype$comm[ctype$comm$type == 'input',, drop = FALSE]
    if (nrow(ccomm) != 0 || length(ainp) != 0) {
      approxim <- list(region = region, year = year, slice = slice, 
         comm = rownames(ccomm), group = unique(ccomm$group))
      approxim$group <- approxim$group[!is.na(approxim$group)]
      if (length(approxim$group) == 0) approxim$group <- '1'
      if (nrow(ccomm) != 0) {
        # Parameter approximation
        gparam <- interpolation(tech@geff, 'ginp2use', 
                                  default = as.numeric(default['ginp2use']), 
                                  rule = rule['ginp2use'], 
                                  year_range = range(year),
                                  approxim = approxim)
        gg <- c('cinp2ginp', 'cinp2use')
        cparam <- lapply(gg, function(x) {
                                  interpolation(tech@ceff, x, 
                                  default = as.numeric(default[x]), 
                                  rule = rule[x], 
                                  year_range = range(year),
                                  approxim = approxim)})
        names(cparam) <- gg
        share <- interpolation_bound(tech@ceff, 'share', 
                                  default = as.numeric(default[c('share.lo', 'share.up')]), 
                                  rule = as.character(rule[c('share.lo', 'share.up')]), 
                                  year_range = range(year),
                                  approxim = approxim)
      }
      # Figure
      lcount <- nrow(ccomm) + length(ainp)
      larrow <- rev(seq(lo_border + rn_border / (lcount + 1), 
         up_border - rn_border / (lcount + 1), length.out = lcount))
      if (!is.null(ARROW_FONT)) fnt <- min(sapply(rownames(ccomm), 
          function(x) 9 / (6 + .7 * nchar(x[1])))) else fnt <- ARROW_FONT
      # Arrow
      for(i in seq(length.out = nrow(ccomm))) {
        y <- larrow[i]
        if (ccomm[i, 'comb']) cll <- act_col else cll <- ncomb_col
        cmm <- rownames(ccomm)[i]          
        llty <- 1
        llwd <- sng_lwd
        lines(c(.01, .24), rep(y, 2), lwd = llwd, col = cll)
        lines(c(.19, .24, .19), c(y - .02, y, y + .02), lwd = llwd, col = cll, lty = llty)
        gg <- cmm
        if (!is.na(tech@input[tech@input$comm == gg, 'unit'])) 
            gg <- paste(gg, ' (', tech@input[tech@input$comm == gg, 'unit'], ')', sep = '')
        text(.01, y + .03, gg, adj = 0, cex = fnt)
        if (!is.na(ccomm[cmm, 'group'])) {
          s1 <- cparam$cinp2ginp[cparam$cinp2ginp$comm == cmm, 'cinp2ginp']
          if (show_all ||s1 != 1) text(.26, y + .025, paste('cinp2ginp =', to_format(s1)), adj = 0, cex = .8)
          s1 <- share[share$comm == cmm & share$type == 'up', 'share']
          s2 <- share[share$comm == cmm & share$type == 'lo', 'share']
          if (show_all ||s1 != 1 || s2 != 0)
              text(.27, y - .015, paste(to_format(100 * s2), '% .. ',
                to_format(100 * s1), '%', sep = ''), adj = 0, cex = .8)
        } else {
            s1 <- cparam$cinp2use[cparam$cinp2use$comm == cmm, 'cinp2use']
            if (show_all ||s1 != 1)
                text(.27, y + .005, paste('cinp2use =', to_format(s1)), adj = 0, cex = .8)
        }
      }  
     if (any(!is.na(ccomm$group))) {
        for(gr in unique(ccomm$group[!is.na(ccomm$group)])) {
          gmin <- seq(length.out = nrow(ccomm))[!is.na(ccomm$group) & ccomm$group == gr][1]
          gmax <- rev(seq(length.out = nrow(ccomm))[!is.na(ccomm$group) & ccomm$group == gr])[1]
          arr <- c(larrow[gmin] - (larrow[2] - larrow[1]) * .15, larrow[gmax] + (larrow[2] - larrow[1]) * .15)
          if (length(larrow) == 1) arr <- rep(larrow, 2)
          col2 <- act_col
          if (gmin != gmax) {
            lines(rep(.38, 2) + ar_shift, arr, lwd = 3, col = act_col)
            lines(c(.38, .36) + ar_shift, rep(arr[1], 2), lwd = 3, col = act_col)
            lines(c(.38, .36) + ar_shift,  rep(arr[2], 2), lwd = 3, col = act_col)
            bg_col <- bbcol1
            points(.38 + ar_shift, sum(arr) / 2, cex = 3.5, col = act_col, bg = bbcol2, pch = 21)
            text(.38 + ar_shift, sum(arr) / 2, adj = .5, cex = .65, gr)
          } else {
            points(.24, sum(arr) / 2, cex = 3.5, col = act_col, bg = 'white', pch = 21)
            text(.24, sum(arr) / 2, adj = .5, cex = .65, gr)
          }
        }
        if (gparam[gparam$group == gr, 'ginp2use'] != 1)  
          text(.39 + ar_shift, sum(arr) / 2 + .025, paste('ginp2use(', gr, ') =', 
            to_format(gparam[gparam$group == gr, 'ginp2use']), sep = ''), 
                adj = 0, cex = CEX_GREFF)
      }
      # acomm
      for(i in seq(length.out = length(ainp))) {
        KK <- i + nrow(ccomm)
        y <- larrow[KK]
        cll <- aux_col
        cmm <- ainp[i]          
        llty <- 1
        llwd <- sng_lwd
        lines(c(.01, .24), rep(y, 2), lwd = llwd, col = cll)
        lines(c(.19, .24, .19), c(y - .02, y, y + .02), lwd = llwd, col = cll, lty = llty)
        gg <- cmm
        if (!is.na(tech@aux[tech@aux$acomm == gg, 'unit'])) 
            gg <- paste(gg, ' (', tech@aux[tech@aux$acomm == gg, 'unit'], ')', sep = '')
        text(.01, y + .03, gg, adj = 0, cex = fnt)
        # Find 
        ll <- aparam[[cmm]]
        ll$single <- ll$single[names(ll$single) %in% c('act2ainp', 'use2ainp', 'cap2ainp', 'ncap2ainp')]
        ll$wcomm <- ll$wcomm[names(ll$wcomm) %in% c('cinp2ainp', 'cout2ainp')]
        if (sum(c(sapply(ll$wcomm, nrow), recursive = TRUE)) + length(ll$single) > 3) {
            text(.26, y + .005, 'more than\nthree parameters', adj = 0, cex = .8)
        } else {
          if (length(ll$single) != 0)
            text(.26, y + .005 + .03 * c(1, -1, 0)[1:length(ll$single)], 
              paste(names(ll$single), '=', to_format(ll$single)), adj = 0, cex = .8)
          if (sum(c(sapply(ll$wcomm, nrow), recursive = TRUE)) != 0) {
            ff <- sapply(names(ll$wcomm), function(x) {
              paste(c(sapply(seq(along = ll$wcomm[[x]]$comm), function(z) 
                paste(substr(x, 2, 4), '.', ll$wcomm[[x]]$comm[z], 
                  ' = ', to_format(ll$wcomm[[x]][z, x]), sep = ''))
                , recursive = TRUE), collapse = ', ')})
            text(.26, y + .005 + .03 * c(1, -1, 0)[length(ll$single) + 1:length(ff)], 
              ff, adj = 0, cex = .8)
          }
        }
      }  
    }
    # RHS
    ccomm <- ctype$comm[ctype$comm$type == 'output',, drop = FALSE]
    if (nrow(ccomm) != 0 || length(aout) != 0) {
      approxim <- list(region = region, year = year, slice = slice, 
         comm = rownames(ccomm), group = unique(ccomm$group))
      approxim$group <- approxim$group[!is.na(approxim$group)]
      if (length(approxim$group) == 0) approxim$group <- '1'
      # Parameter approximation
      if (nrow(ccomm) != 0) {
        gg <- c('use2cact', 'cact2cout')
        cparam <- lapply(gg, function(x) {
                                  interpolation(tech@ceff, x, 
                                  default = as.numeric(default[x]), 
                                  rule = rule[x], 
                                  year_range = range(year),
                                  approxim = approxim)})
        names(cparam) <- gg
        share <- interpolation_bound(tech@ceff, 'share', 
                                  default = as.numeric(default[c('share.lo', 'share.up')]), 
                                  rule = as.character(rule[c('share.lo', 'share.up')]), 
                                  year_range = range(year),
                                  approxim = approxim)
        afac <- interpolation_bound(tech@ceff, 'afac', 
                                  default = as.numeric(default[c('afac.lo', 'afac.up')]), 
                                  rule = as.character(rule[c('afac.lo', 'afac.up')]), 
                                  year_range = range(year),
                                  approxim = approxim)
      }
       # Figure
        lcount <- nrow(ccomm) + length(aout)
        larrow <- rev(seq(lo_border + rn_border / (lcount + 1), 
            up_border - rn_border / (lcount + 1), length.out = lcount))
        if (!is.null(ARROW_FONT)) fnt <- min(sapply(rownames(ccomm), 
            function(x) 9 / (6 + .7 * nchar(x[1])))) else fnt <- ARROW_FONT
        # Arrow
        for(i in seq(length.out = nrow(ccomm))) {
          y <- larrow[i]
          cll <- act_col
          cmm <- rownames(ccomm)[i]
          llty <- 1
          llwd <- sng_lwd
          lines(c(.77, 1.02), rep(y, 2), lwd = llwd, col = cll)
          lines(c(.97, 1.02, .97), c(y - .02, y, y + .02), lwd = llwd, col = cll, lty = llty)
          gg <- cmm
          if (!is.na(tech@output[tech@output$comm == gg, 'unit'])) 
              gg <- paste(gg, ' (', tech@output[tech@output$comm == gg, 'unit'], ')', sep = '')
          text(.80, y + .03, gg, adj = 0, cex = fnt)
          lo_legend <- paste('afac ',
                  to_format(as.numeric(afac[afac$comm == cmm & afac$type == 'lo', 'afac'])),
                  ' .. ',
                  to_format(as.numeric(afac[afac$comm == cmm & afac$type == 'up', 'afac'])),
                  '', sep = '')
          #if (show_all ||lo_legend != 'afac 0 .. Inf') text(.757, y - .03, lo_legend, adj = 1, cex = .8)
          s1 <- cparam$use2cact[cparam$use2cact$comm == cmm, 'use2cact']
          if (show_all ||s1 != 1) text(.757, y + .03, paste('use2cact =', to_format(s1)), adj = 1, cex = .8)
          s1 <- cparam$cact2cout[cparam$cact2cout$comm == cmm, 'cact2cout']
          if (show_all ||s1 != 1) text(.757, y, paste('cact2cout =', to_format(s1)), adj = 1, cex = .8)
          if (!is.na(ccomm[cmm, 'group'])) {
            s1 <- share[share$comm == cmm & share$type == 'up', 'share']
            s2 <- share[share$comm == cmm & share$type == 'lo', 'share']
            if (show_all ||s1 != 1 || s2 != 0)
                text(.757, y - .03, paste(to_format(100 * s2), '% .. ',
                  to_format(100 * s1), '%', sep = ''), adj = 1, cex = .8)
          } 
        }
       if (any(!is.na(ccomm$group))) {
          for(gr in unique(ccomm$group[!is.na(ccomm$group)])) {
            gmin <- seq(length.out = nrow(ccomm))[!is.na(ccomm$group) & ccomm$group == gr][1]
            gmax <- rev(seq(length.out = nrow(ccomm))[!is.na(ccomm$group) & ccomm$group == gr])[1]
            # arr <- c(larrow[gmin] - .025, larrow[gmax] + 0.05)
            arr <- c(larrow[gmin] - (larrow[2] - larrow[1]) * .15, larrow[gmax] + (larrow[2] - larrow[1]) * .15)
            if (length(larrow) == 1) arr <- rep(larrow, 2)
            col2 <- act_col
            if (gmin != gmax) {
              lines(rep(.56, 2) + ar_shift, arr, lwd = 3, col = act_col)
              lines(c(.56, .59) + ar_shift, rep(arr[1], 2), lwd = 3, col = act_col)
              lines(c(.56, .59) + ar_shift,  rep(arr[2], 2), lwd = 3, col = act_col)
              bg_col <- bbcol1
              points(.56 + ar_shift, sum(arr) / 2, cex = 3.5, col = act_col, bg = bbcol2, pch = 21)
              text(.56 + ar_shift, sum(arr) / 2, adj = .5, cex = .65, gr)
            } else {
              points(.77, sum(arr) / 2 - .01, cex = 3.5, col = act_col, bg = 'white', pch = 21)
              text(.77, sum(arr) / 2 - .01, adj = .5, cex = .65, gr)
            }
          }
        }
      }
      # AUX
      for(i in seq(length.out = length(aout))) {
        KK <- i + nrow(ccomm)
        y <- larrow[KK]
        cll <- aux_col
        cmm <- aout[i]
        llty <- 1
        llwd <- sng_lwd
        lines(c(.77, 1.02), rep(y, 2), lwd = llwd, col = cll)
        lines(c(.97, 1.02, .97), c(y - .02, y, y + .02), lwd = llwd, col = cll, lty = llty)
        gg <- cmm
       if (!is.na(tech@aux[tech@aux$acomm == gg, 'unit'])) 
            gg <- paste(gg, ' (', tech@aux[tech@aux$acomm == gg, 'unit'], ')', sep = '')
        text(.80, y + .03, gg, adj = 0, cex = fnt)
        # Find
        ll <- aparam[[cmm]]
        ll$single <- ll$single[names(ll$single) %in% c('act2aout', 'use2aout', 'cap2aout', 'ncap2aout')]
        ll$wcomm <- ll$wcomm[names(ll$wcomm) %in% c('cinp2aout', 'cout2aout')]
        if (sum(c(sapply(ll$wcomm, nrow), recursive = TRUE)) + length(ll$single) > 3) {
            text(.56, y + .005, 'more than\nthree parameters', adj = 0, cex = .8)
        } else {
          if (length(ll$single) != 0)
            text(.757, y + .005 + .03 * c(1, -1, 0)[1:length(ll$single)],
              paste(names(ll$single), '=', to_format(ll$single)), adj = 1, cex = .8)
          if (sum(c(sapply(ll$wcomm, nrow), recursive = TRUE)) != 0) {
            ff <- sapply(names(ll$wcomm), function(x) {
              paste(c(sapply(seq(along = ll$wcomm[[x]]$comm), function(z) 
                paste(substr(x, 2, 4), '.', ll$wcomm[[x]]$comm[z], 
                  ' = ', to_format(ll$wcomm[[x]][z, x]), sep = ''))
                , recursive = TRUE), collapse = ', ')})
            text(.757, y + .005 + .03 * c(1, -1, 0)[length(ll$single) + 1:length(ff)],
              ff, adj = 1, cex = .8)
          }
        } 
    }
    par(mar = MAR)
    }, interrupt = function(x) {
      par(mar = MAR)
      stop('Solver has been interrupted')
    }, error = function(x) {
      par(mar = MAR)
      stop(x)
    })    
}
