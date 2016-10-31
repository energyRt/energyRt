#interpolation_bound(MIN_BIO01@availability, 'ava',
#   default = dfl, rule = rl, year_range = c(2005, 2100),
#   approxim = list(region = 'R1', slice = 'ANNUAL')
#)
#--------------------------------------------------------------------------------------------
# plot supply
#--------------------------------------------------------------------------------------------
plot_supply <- function(obj, commodity, region = NULL, supply = NULL, 
           year = NULL, slice = NULL, inf.col = 'red', ylim = NULL, xlab = '', 
           ylab = '', main = NULL, xlim = NULL, ylim2 = NULL,
           col = 'gray', lwd = 2, density = 20, border = 'black', ylim_min = NULL, ...) {
    # Data calculation 
    if (is.null(region)) region <- obj@sysInfo@region
    if (is.null(year)) year <- obj@sysInfo@year
    if (is.null(slice)) slice <- obj@sysInfo@slice
    if (is.null(region) || length(region) == 0) {
      region <- 'DEF'
      RFL <- TRUE
    } else RFL <- FALSE
    if (is.null(main)) {
      if (RFL) {
        main <- paste('Commodity supply:', commodity)
      } else if (length(region) == 1) {
        main <- paste('Commodity supply: ', commodity, 
          ', in region: "', region, '"', sep = '')
      } else {
        main <- paste('Commodity supply: ', commodity, 
          ', in region: \n"', paste(region, collapse = '", "'), '"', sep = '')
      }        
    }
    approxim = list(region = region, slice = slice)
    rl  <- as.character(obj@sysInfo@interpolation[c('ava.lo', 'ava.up')])
    dfl <- as.numeric(obj@sysInfo@default[c('ava.lo', 'ava.up')])
    year_range <- range(year)
    cyear <- as.character(year)
    gg <- array(0, dim = c(length(year), 2), dimnames = list(year, c('lo', 'up')))
    for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) {
          if (class(obj@data[[i]]@data[[j]]) == 'supply' 
              && commodity == obj@data[[i]]@data[[j]]@commodity &&
              (is.null(supply) || obj@data[[i]]@data[[j]]@name %in% supply)) {
            bnd <- interpolation_bound(obj@data[[i]]@data[[j]]@availability,
               'ava', default = dfl, rule = rl, year_range = year_range,
               approxim = approxim)
            gg <- gg + tapply(bnd$ava, bnd[, c('year', 'type')], sum)[cyear, , drop = FALSE]
          }
        }
    }
    # Plot
    if (is.null(ylim)) ylim <- c(0, max(c(gg[gg != Inf], ylim_min))) else {
      if (min(gg) < ylim[1] || ylim[2] < max(gg[gg != Inf]))
        warning('Plot out of range')
    }
    if (!is.null(ylim2)) {
      if (min(ylim2) < ylim[1]) ylim[1] <- min(ylim2)
      if (max(ylim2) > ylim[2]) ylim[2] <- max(ylim2)
    }
    if (ylim[1] == ylim[2]) ylim[2] <- ylim[1] + 1
    if (max(year) == min(year)) xlim <- 0:1 - .5 + year[1]
    if (any(gg[, 'lo'] == Inf)) stop('Lower range is Inf')
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 8) + .1)
    plot(year, year, type = 'n', ylim =  ylim, xlab = xlab, ylab = ylab, 
      main = main, xlim = xlim, ...)
    if (any(gg == Inf)) {
      par(xpd =TRUE)
      legend(par()$usr[2], par()$usr[4], legend = c('Supply range', 
        'Infinit supply\narea'), bty = 'n', fill = c(col, inf.col))
      par(xpd =FALSE)
    }  
    yy <- gg; yy[yy == Inf] <- max(yy[yy != Inf])
    polygon(c(year, rev(year)), c(yy[cyear, 'lo'], yy[rev(cyear), 'up']), col = col,
      lwd = lwd, density = density, border = border, ...)
    if (any(gg == Inf)) {
      yr <- year[gg[, 'up'] == Inf]
      mm <- par()$usr[4]
      while(length(yr) != 0) {  
        rng <- sum(yr[1] + seq(along = yr) - 1 == yr)
        rr <- yr[1:rng]; 
        lo <- gg[as.character(rr), 'lo']
        if (rr[1] != year[1]) {
          lo <- c(mean(gg[as.character(rr[1] - 0:1), 'lo']), lo)
          rr <- c(rr[1] - .5, rr)
        }
        if (max(rr) != max(year)) {
          lo <- c(lo, mean(gg[as.character(max(rr) + 0:1), 'lo']))
          rr <- c(rr, max(rr) + .5)
        }
        up <- lo; up[] <- mm
        polygon(c(rr, rev(rr)), c(lo, up), col = inf.col,
          lwd = lwd, density = density, border = border, ...)
        yr <- yr[-(1:rng)]
      }
    }    
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 2) + .1)
    gg
}

#--------------------------------------------------------------------------------------------
# plot export
#--------------------------------------------------------------------------------------------
plot_export <- function(obj, commodity, region = NULL, export = NULL, 
           year = NULL, slice = NULL, inf.col = 'red', ylim = NULL, xlab = '', 
           ylab = '', main = NULL, xlim = NULL, ylim2 = NULL,
           col = 'gray', lwd = 2, density = 20, border = 'black', ...) {
    # Data calculation 
    if (is.null(region)) region <- obj@sysInfo@region
    if (is.null(year)) year <- obj@sysInfo@year
    if (is.null(slice)) slice <- obj@sysInfo@slice
    if (is.null(region) || length(region) == 0) {
      region <- 'DEF'
      RFL <- TRUE
    } else RFL <- FALSE
    if (is.null(main)) {
      if (RFL) {
        main <- paste('Commodity export:', commodity)
      } else if (length(region) == 1) {
        main <- paste('Commodity export: ', commodity, 
          ', in region: "', region, '"', sep = '')
      } else {
        main <- paste('Commodity export: ', commodity, 
          ', in region: \n"', paste(region, collapse = '", "'), '"', sep = '')
      }        
    }
    approxim = list(region = region, slice = slice)
    rl  <- as.character(obj@sysInfo@interpolation[c('ava.lo', 'ava.up')])
    dfl <- as.numeric(obj@sysInfo@default[c('ava.lo', 'ava.up')])
    year_range <- range(year)
    cyear <- as.character(year)
    gg <- array(0, dim = c(length(year), 2), dimnames = list(year, c('lo', 'up')))
    for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) {
          if (class(obj@data[[i]]@data[[j]]) == 'export' 
              && commodity == obj@data[[i]]@data[[j]]@commodity &&
              (is.null(export) || obj@data[[i]]@data[[j]]@name %in% export)) {
            bnd <- interpolation_bound(obj@data[[i]]@data[[j]]@exp,
               'exp', default = dfl, rule = rl, year_range = year_range,
               approxim = approxim)
            gg <- gg + tapply(bnd$exp, bnd[, c('year', 'type')], sum)[cyear, , drop = FALSE]
          }
        }
    }
    # Plot
    if (is.null(ylim)) ylim <- c(0, max(gg[gg != Inf])) else {
      if (min(gg) < ylim[1] || ylim[2] < max(gg[gg != Inf]))
        warning('Plot out of range')
    }
    if (!is.null(ylim2)) {
      if (min(ylim2) < ylim[1]) ylim[1] <- min(ylim2)
      if (max(ylim2) > ylim[2]) ylim[2] <- max(ylim2)
    }
    if (ylim[1] == ylim[2]) ylim[2] <- ylim[1] + 1
    if (max(year) == min(year)) xlim <- 0:1 - .5 + year[1]
    if (any(gg[, 'lo'] == Inf)) stop('Lower range is Inf')
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 8) + .1)
    plot(year, year, type = 'n', ylim =  ylim, xlab = xlab, ylab = ylab, 
      main = main, xlim = xlim, ...)
    if (any(gg == Inf)) {
      par(xpd =TRUE)
      legend(par()$usr[2], par()$usr[4], legend = c('Export range', 
        'Infinit export\narea'), bty = 'n', fill = c(col, inf.col))
      par(xpd =FALSE)
    }  
    yy <- gg; yy[yy == Inf] <- max(yy[yy != Inf])
    polygon(c(year, rev(year)), c(yy[cyear, 'lo'], yy[rev(cyear), 'up']), col = col,
      lwd = lwd, density = density, border = border, ...)
    if (any(gg == Inf)) {
      yr <- year[gg[, 'up'] == Inf]
      mm <- par()$usr[4]
      while(length(yr) != 0) {  
        rng <- sum(yr[1] + seq(along = yr) - 1 == yr)
        rr <- yr[1:rng]; 
        lo <- gg[as.character(rr), 'lo']
        if (rr[1] != year[1]) {
          lo <- c(mean(gg[as.character(rr[1] - 0:1), 'lo']), lo)
          rr <- c(rr[1] - .5, rr)
        }
        if (max(rr) != max(year)) {
          lo <- c(lo, mean(gg[as.character(max(rr) + 0:1), 'lo']))
          rr <- c(rr, max(rr) + .5)
        }
        up <- lo; up[] <- mm
        polygon(c(rr, rev(rr)), c(lo, up), col = inf.col,
          lwd = lwd, density = density, border = border, ...)
        yr <- yr[-(1:rng)]
      }
    }    
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 2) + .1)
    gg
}

#--------------------------------------------------------------------------------------------
# plot import
#--------------------------------------------------------------------------------------------
plot_import <- function(obj, commodity, region = NULL, import = NULL, 
           year = NULL, slice = NULL, inf.col = 'red', ylim = NULL, xlab = '', 
           ylab = '', main = NULL, xlim = NULL, ylim2 = NULL,
           col = 'gray', lwd = 2, density = 20, border = 'black', ...) {
    # Data calculation 
    if (is.null(region)) region <- obj@sysInfo@region
    if (is.null(year)) year <- obj@sysInfo@year
    if (is.null(slice)) slice <- obj@sysInfo@slice
    if (is.null(region) || length(region) == 0) {
      region <- 'DEF'
      RFL <- TRUE
    } else RFL <- FALSE
    if (is.null(main)) {
      if (RFL) {
        main <- paste('Commodity import:', commodity)
      } else if (length(region) == 1) {
        main <- paste('Commodity import: ', commodity, 
          ', in region: "', region, '"', sep = '')
      } else {
        main <- paste('Commodity import: ', commodity, 
          ', in region: \n"', paste(region, collapse = '", "'), '"', sep = '')
      }        
    }
    approxim = list(region = region, slice = slice)
    rl  <- as.character(obj@sysInfo@interpolation[c('ava.lo', 'ava.up')])
    dfl <- as.numeric(obj@sysInfo@default[c('ava.lo', 'ava.up')])
    year_range <- range(year)
    cyear <- as.character(year)
    gg <- array(0, dim = c(length(year), 2), dimnames = list(year, c('lo', 'up')))
    for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) {
          if (class(obj@data[[i]]@data[[j]]) == 'import' 
              && commodity == obj@data[[i]]@data[[j]]@commodity &&
              (is.null(import) || obj@data[[i]]@data[[j]]@name %in% import)) {
            bnd <- interpolation_bound(obj@data[[i]]@data[[j]]@imp,
               'imp', default = dfl, rule = rl, year_range = year_range,
               approxim = approxim)
            gg <- gg + tapply(bnd$imp, bnd[, c('year', 'type')], sum)[cyear, , drop = FALSE]
          }
        }
    }
    # Plot
    if (is.null(ylim)) ylim <- c(0, max(gg[gg != Inf])) else {
      if (min(gg) < ylim[1] || ylim[2] < max(gg[gg != Inf]))
        warning('Plot out of range')
    }
    if (!is.null(ylim2)) {
      if (min(ylim2) < ylim[1]) ylim[1] <- min(ylim2)
      if (max(ylim2) > ylim[2]) ylim[2] <- max(ylim2)
    }
    if (ylim[1] == ylim[2]) ylim[2] <- ylim[1] + 1
    if (max(year) == min(year)) xlim <- 0:1 - .5 + year[1]
    if (any(gg[, 'lo'] == Inf)) stop('Lower range is Inf')
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 8) + .1)
    plot(year, year, type = 'n', ylim =  ylim, xlab = xlab, ylab = ylab, 
      main = main, xlim = xlim, ...)
    if (any(gg == Inf)) {
      par(xpd =TRUE)
      legend(par()$usr[2], par()$usr[4], legend = c('Import range', 
        'Infinit import\narea'), bty = 'n', fill = c(col, inf.col))
      par(xpd =FALSE)
    }  
    yy <- gg; yy[yy == Inf] <- max(yy[yy != Inf])
    polygon(c(year, rev(year)), c(yy[cyear, 'lo'], yy[rev(cyear), 'up']), col = col,
      lwd = lwd, density = density, border = border, ...)
    if (any(gg == Inf)) {
      yr <- year[gg[, 'up'] == Inf]
      mm <- par()$usr[4]
      while(length(yr) != 0) {  
        rng <- sum(yr[1] + seq(along = yr) - 1 == yr)
        rr <- yr[1:rng]; 
        lo <- gg[as.character(rr), 'lo']
        if (rr[1] != year[1]) {
          lo <- c(mean(gg[as.character(rr[1] - 0:1), 'lo']), lo)
          rr <- c(rr[1] - .5, rr)
        }
        if (max(rr) != max(year)) {
          lo <- c(lo, mean(gg[as.character(max(rr) + 0:1), 'lo']))
          rr <- c(rr, max(rr) + .5)
        }
        up <- lo; up[] <- mm
        polygon(c(rr, rev(rr)), c(lo, up), col = inf.col,
          lwd = lwd, density = density, border = border, ...)
        yr <- yr[-(1:rng)]
      }
    }    
    if (any(gg == Inf)) par(mar = c(5, 4, 4, 2) + .1)
    gg
}

#--------------------------------------------------------------------------------------------
# plot demand
#--------------------------------------------------------------------------------------------
plot_demand <- function(obj, commodity, region = NULL, demand = NULL,
           year = NULL, slice = NULL, ylim = NULL, xlab = '', 
           ylab = '', main = NULL, xlim = NULL,
           col = 'gray', lwd = 2, ...) {
    # Data calculation 
    if (is.null(region)) region <- obj@sysInfo@region
    if (is.null(year)) year <- obj@sysInfo@year
    if (is.null(slice)) slice <- obj@sysInfo@slice
    if (is.null(region) || length(region) == 0) {
      region <- 'DEF'
      RFL <- TRUE
    } else RFL <- FALSE
    if (is.null(main)) {
      if (RFL) {
        main <- paste('Commodity demand:', commodity)
      } else if (length(region) == 1) {
        main <- paste('Commodity demand: ', commodity, 
          ', in region: "', region, '"', sep = '')
      } else {
        main <- paste('Commodity demand: ', commodity, 
          ', in region: \n"', paste(region, collapse = '", "'), '"', sep = '')
      }        
    }
    approxim = list(region = region, slice = slice)
    rl  <- as.character(obj@sysInfo@interpolation['dem'])
    dfl <- as.numeric(obj@sysInfo@default['dem'])
    year_range <- range(year)
    cyear <- as.character(year)
    gg <- array(0, dim = length(year), dimnames = list(year))
    for(i in seq(along = obj@data)) {
        for(j in seq(along = obj@data[[i]]@data)) {
          if (class(obj@data[[i]]@data[[j]]) == 'demand' 
              && commodity == obj@data[[i]]@data[[j]]@commodity &&
              (is.null(demand) || obj@data[[i]]@data[[j]]@name %in% demand)) {
            bnd <- interpolation(obj@data[[i]]@data[[j]]@dem,
               'dem', default = dfl, rule = rl, year_range = year_range,
               approxim = approxim)
            gg <- gg + tapply(bnd$dem, bnd$year, sum)[cyear, drop = FALSE]
          }
        }
    }
    if (any(gg == Inf)) stop('Infinit demand for commodity ', commodity)
   # Plot
    if (is.null(ylim)) ylim <- c(0, max(gg[gg != Inf])) else {
      if (min(gg) < ylim[1] || ylim[2] < max(gg[gg != Inf]))
        warning('Plot out of range')
    }
    if (max(year) == min(year)) {
      year <- year + 0:1 - .5
      gg <- rep(gg, 2)
    }
    plot(year, gg, type = 'l', ylim =  ylim, xlab = xlab, ylab = ylab, 
      main = main, xlim = xlim, lwd = lwd, ...)
    gg
}

#--------------------------------------------------------------------------------------------
# plot model
#--------------------------------------------------------------------------------------------
plot.model <- function(obj, type, ...) {
  if (type == 'supply')  plot_supply(obj, ...) else
  if (type == 'demand')  plot_demand(obj, ...) else
  if (type == 'export')  plot_export(obj, ...) else
  if (type == 'import')  plot_import(obj, ...) else
  stop('Unknown plot type ', type)
}

#--------------------------------------------------------------------------------------------
# plot universal
#--------------------------------------------------------------------------------------------
plot_universal <- function(obj, discount = .1, region = NULL, year = 2000:2050, 
  slice = 'ANNUAL', ...) {
  mdl <- new('model')
  reps <- new('repository')      
  reps <- add(reps, obj);
  mdl <- add(mdl, reps)
  if (!is.null(region)) {
    mdl@sysInfo@region <- region
  } else {
    if (class(obj) == 'demand') {
      region <- obj@dem$region[!is.na(obj@dem$region)]
    } else if (class(obj) == 'supply') {
      region <- obj@sup$region[!is.na(obj@sup$region)]
    } else if (class(obj) == 'export') {
      region <- obj@exp$region[!is.na(obj@exp$region)]
    } else if (class(obj) == 'import') {
      region <- obj@imp$region[!is.na(obj@imp$region)]
    } 
    if (!is.null(region)) 
      mdl@sysInfo@region <- region
  }
  mdl@sysInfo@year   <- year
  mdl@sysInfo@slice  <- slice
  if (is.numeric(discount)) {
    mdl@sysInfo@discount[1, 'discount'] <- discount
  } else if (is.list(discount)) {
    if (!is.data.frame(discount)) 
      discount <- as.data.frame(discount)
    if (nrow(discount) == 0) stop('Error discount')
    mdl@sysInfo@discount <- mdl@sysInfo@discount[0, , drop = FALSE]
    mdl@sysInfo@discount[1:nrow(discount), ] <- NA
    for(i in colnames(discount)) {
      mdl@sysInfo@discount[1:nrow(discount), i] <- dicount[, i] 
    }
  } else stop('Error discount')
  plot(mdl, type = class(obj), commodity = obj@commodity, ...)
}

plot.demand <- plot_universal
plot.supply <- plot_universal
plot.export <- plot_universal
plot.import <- plot_universal

#plot.supply <- function(obj, discount = .1, region = NULL, year = 2000:2050, 
#  slice = 'ANNUAL', ...) {
#  mdl <- new('model')
#  reps <- new('repository')      
#  reps <- add(reps, obj);
#  mdl <- add(mdl, reps)
#  if (!is.null(region)) {
#    mdl@sysInfo@region <- region
#  } else {
#    region <- obj@availability$region[!is.na(obj@availability$region)]
#    if (!is.null(region)) 
#      mdl@sysInfo@region <- region
#  }
#  mdl@sysInfo@year   <- year
#  mdl@sysInfo@slice  <- slice
#  if (is.numeric(discount)) {
#    mdl@sysInfo@discount[1, 'discount'] <- discount
#  } else if (is.list(discount)) {
#    if (!is.data.frame(discount)) 
#      discount <- as.data.frame(discount)
#    if (nrow(discount) == 0) stop('Error discount')
#    mdl@sysInfo@discount <- mdl@sysInfo@discount[0, , drop = FALSE]
#    mdl@sysInfo@discount[1:nrow(discount), ] <- NA
#    for(i in colnames(discount)) {
#      mdl@sysInfo@discount[1:nrow(discount), i] <- dicount[, i] 
#    }
#  } else stop('Error discount')
#  plot(mdl, type = 'supply', commodity = obj@commodity, ...)
#}

#plot(mdl, 'supply', 'COA', year = 2007:2040)
#plot(mdl, 'demand', 'ELCC', year = 2007:2040)
#
