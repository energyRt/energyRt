
summary.levcost <- function(x) x$total
.sm_levcost <- function(obj, echo = TRUE, n.threads = 1, 
                        subs = NULL, tax = NULL, discount = NULL, region = NULL, start_year = NULL, 
                        comm = NULL, ignore.years = NULL, slice = NULL, price = NULL, ...) {
  tech <- energyRt:::.upper_case(obj)
  price0 <- price
  arg <- list(...)
  # prepare model
  reps <- new('repository')
  # Initial parameter
 # tech <- tec
 # arg <- list(discount = .1) #, comm = 'ELC') # For test
  if (!is.null(discount)) {
    if (is.numeric(discount)) discount <- data.frame(discount = discount, stringsAsFactors = TRUE)
    if (all(colnames(discount) != 'region')) discount <- cbind(discount, region = rep(NA, nrow(discount)))
    if (all(colnames(discount) != 'year')) discount <- cbind(discount, year = rep(NA, nrow(discount)))
    discount <- discount[, c('region', 'year', 'discount'), drop = FALSE]
    discount$region <- as.character(discount$region)
    discount$year <- as.numeric(discount$year)
  } else {
    discount <- data.frame(region     = character(),
                                     year       = numeric(),
                                     discount    = numeric(),
                                     stringsAsFactors = FALSE)
    discount[1, 'discount'] <- .1
    warning('Discount is not specified, default value 10%')
  }
  if (!is.null(tax)) {
    if (!is.data.frame(tax) && is.list(tax)) {
      gg <- sapply(tax, length)
      if (any(gg[1] != gg)) stop('Error subs argument')
      tax <- as.data.frame(tax)
    }
    stopifnot(is.data.frame(tax))
    if (all(colnames(tax) != 'region')) tax <- cbind(tax, region = rep(NA, nrow(tax)))
    if (all(colnames(tax) != 'year')) tax <- cbind(tax, year = rep(NA, nrow(tax)))
    if (all(colnames(tax) != 'slice')) tax <- cbind(tax, slice = rep(NA, nrow(tax)))
    tax <- tax[, c('comm', 'region', 'year', 'slice', 'tax'), drop = FALSE]
    tax$comm <- as.character(tax$comm)
    tax$region <- as.character(tax$region)
    tax$year <- as.numeric(tax$year)
    tax$slice <- as.character(tax$slice)
    for(i in unique(tax$comm)) {
      txx <- newConstrainS(paste('TAX', i, sep = ''), 'tax', comm = i, 
         rhs = tax[tax$comm == i, colnames(tax) != 'comm'])
      reps <- add(reps, txx);
    }
  } 
  if (!is.null(subs)) {
    if (!is.data.frame(subs) && is.list(subs)) {
      gg <- sapply(sunbs, length)
      if (any(gg[1] != gg)) stop('Error subs argument')
      subs <- as.data.frame(subs)
    }
    stopifnot(is.data.frame(subs))
    if (all(colnames(subs) != 'region')) subs <- cbind(subs, region = rep(NA, nrow(subs)))
    if (all(colnames(subs) != 'year')) subs <- cbind(subs, year = rep(NA, nrow(subs)))
    if (all(colnames(subs) != 'slice')) subs <- cbind(subs, slice = rep(NA, nrow(subs)))
    subs <- subs[, c('comm', 'region', 'year', 'slice', 'subs'), drop = FALSE]
    subs$comm <- as.character(subs$comm)
    subs$region <- as.character(subs$region)
    subs$year <- as.numeric(subs$year)
    subs$slice <- as.character(subs$slice)
    for(i in unique(subs$comm)) {
      sbs <- newConstrainS(paste('SUBS', i, sep = ''), 'subs', comm = i, 
         rhs = subs[subs$comm == i, colnames(subs) != 'comm'])
      reps <- add(reps, sbs);
    }
  }
  if (!is.null(region)) {
    stopifnot(is.character(region) && length(region) == 1)
    arg <- arg[names(arg) != 'region', drop = FALSE]
  } else if (length(obj@region) != 0) {
    region <- obj@region[1]
  } else region <- 'DEF'
  if (!is.null(start_year)) {
    stopifnot(is.numeric(start_year) && length(start_year) == 1)
  } else {
    start_year <- max(c(tech@start$start, 2005, na.rm = TRUE))
    warning('Start year is not specified, default value ', start_year)
  }
  if (!is.null(comm)) {
    stopifnot(is.character(comm) && length(comm) == 1)
  } else comm <- NULL
  if (!is.null(ignore.years)) {
    if (ignore.years) {
      tech@start <- tech@start[0,, drop = FALSE]
      tech@end   <-   tech@end[0,, drop = FALSE]
    }
  }
  tech@end <- tech@end[!is.na(tech@end$end),, drop = FALSE]
  tech@start <- tech@start[!is.na(tech@start$start),, drop = FALSE]
  # Check start & end year possibility
  fl <- (!is.na(tech@start$region) & tech@start$region == region)
  if (!any(fl)) fl <- is.na(tech@start$region)
  if (any(fl) && any(tech@start[fl, 'start'] > start_year)) 
    stop('Start year belong to unacceptable time region (see start year)')
  fl <- (!is.na(tech@end$region) & tech@end$region == region)
  if (!any(fl)) fl <- is.na(tech@end$region)
  if (any(fl) && any(tech@end[fl, 'end'] <= start_year)) 
    stop('Start year belong to unacceptable time region (see end year)')
  price <- data.frame(comm = character(), region = character(),
            year = numeric(), slice = character(), price = numeric(),
              stringsAsFactors = FALSE)
  if (!is.null(price0)) {
    stopifnot(is.data.frame(price0) && all(colnames(price0) %in% c('comm', 'region', 
      'year', 'slice', 'price')))
    price[1:nrow(price0), ] <- NA
    for(i in colnames(price0)) price[, i] <- price0[,i]
    if (any(!is.na(price$year))) price$year[!is.na(price$year)] <- as.numeric(price$year[!is.na(price$year)])
  }
  if (nrow(tech@olife) == 0 && all(tech@olife$region != region, na.rm = TRUE)
  && all(!is.na(tech@olife$region))) {
    year <- start_year
    warning('Lifetime of the technology is not specified, default value 1')
  } else {
    if (any(tech@olife$region == region, na.rm = TRUE)) {
      year <- start_year + 0:(tech@olife$olife[tech@olife$region == region][1]-1)
    } else {
        year <- start_year + 0:(tech@olife$olife[is.na(tech@olife$region)][1]-1)
    }
  }
  if (nrow(tech@stock)) {
     tech@stock <- tech@stock[0,, drop = FALSE]
     warnings('There is stock in technology, remove all stock')
  }


  reps <- add(reps, tech)
  colnames(price)[colnames(price) == 'price'] <- 'cost'
  for(i in tech@input$comm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    tmpc@limtype[] <- 'FX'
    reps <- add(reps, tmpc)
    tmpm <- new('supply')
    tmpm@name <- paste('MIN', i, sep = '')
    tmpm@commodity <- i
    if (any(price$comm == i)) {
       tmpm@availability[1:sum(price$comm == i), colnames(price)[colnames(price) != 'comm']] <-
           price[price$comm == i, colnames(price)[colnames(price) != 'comm']]
    }
    reps <- add(reps, tmpm)
  }
  for(i in tech@output$comm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    if (!is.null(comm) && comm == i) {
      tmpc@limtype[] <- 'FX'
    } else {
      tmpc@limtype[] <- 'LO'
    }
    reps <- add(reps, tmpc)
  }
  acommin_sup <- tech@aeff[apply(!is.na(tech@aeff[, grep('ainp', colnames(tech@aeff))]), 1, any), 'acomm']
  for(i in tech@aux$acomm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    tmpc@limtype[] <- 'LO'
    reps <- add(reps, tmpc)
     #if (any(names(arg) == 'subs') && !is.null(arg$subs) && any(subs$comm == i)) 
     if (any(acommin_sup == i)) { 
        tmpm <- new('supply')
        tmpm@name <- paste('MIN', i, sep = '')
        tmpm@commodity <- i
        if (any(price$comm == i)) {
           tmpm@availability[1:sum(price$comm == i), colnames(price)[colnames(price) != 'comm']] <-
               price[price$comm == i, colnames(price)[colnames(price) != 'comm']]
        }
        reps <- add(reps, tmpm)
      }
  }  
 # browser()
  additionalCode <- ''
  if (!is.null(slice)) {
    if (any(class(slice) == c('scenario', 'model', 'sysInfo', 'slice'))) {
      mdl <- newModel(paste('Levelized cost technology', tech@name))
      if (class(slice) == 'scenario') mdl@sysInfo@slice <- slice@model@sysInfo@slice
      if (class(slice) == 'model') mdl@sysInfo@slice <- slice@sysInfo@slice
      if (class(slice) == 'sysInfo') mdl@sysInfo@slice <- slice@slice
      if (class(slice) == 'slice') mdl@sysInfo@slice <- slice
    } else mdl <- newModel(paste('Levelized cost technology', tech@name), slice = slice)
    num.slice <- nrow(mdl@sysInfo@slice@levels)
  } else {
    mdl <- newModel(paste('levcost_', tech@name) , slice = 'ANNUAL')
    num.slice <- 1
  }
  if (!is.null(comm)) {
    comm2 <- comm
    while (any(comm2 == c(tech@input$comm, tech@output$comm, tech@aux$comm))) comm2 <- paste0(comm2, 'dm')
    tmpd <- newDemand(
      name = paste0('DEM', comm2),
      commodity = comm,
      dem = list(region = region, dem = 1 / num.slice)
    )
    reps <- add(reps, tmpd)
    reps <- add(reps, newCommodity(comm2, agg = list(comm = comm, agg = 1)))
      
  }
  mdl@LECdata$region <- region
  mdl <-add(mdl, reps)
  mdl@sysInfo@region <- region
  mdl@sysInfo@year   <- year
 #  mdl@sysInfo@slice  <- slice
  mdl@sysInfo@discount <- discount
  mdl@LECdata$region <- region
  if (is.null(comm)) {
     mdl@LECdata$pLECLoACT <- 1
  }                    
  #if (!is.null(tax)) mdl@sysInfo@tax <- tax
  #if (!is.null(subs)) mdl@sysInfo@subs <- subs
  #, tmp.dir = tmp.dir
  rr <- solve(mdl, name = 'LEC', echo = echo, n.threads = n.threads, ...)
  if (!(rr@modOut@solutionStatus == 1 && 
            rr@modOut@compilationStatus == 2 && 
            all(rr@modOut@data$vDummyImport == 0))) stop('Error in solution')
    dsc <- rr@modInp@parameters[['pDiscountFactor']]@data
    dsc <- dsc[, 2:3, drop = FALSE]
    colnames(dsc)[2] <- 'discount.factor'
    rownames(dsc) <- dsc$year
    ff <- c(
      'vTechInp' = 'input',
      'vTechOut' = 'output',
      'vTechAInp' = 'ainput',
      'vTechAOut' = 'aoutput',
      'vTaxCost' = 'tax',
      'vSubsCost' = 'subs'
      )
    for (i in names(ff)) {
      ndd <- rr@modOut@variables[[i]]
      if (nrow(ndd) > 0) {
        ndd <- tapply(ndd$value, ndd[, c('comm', 'year')], sum)
        ndd[is.na(ndd)] <- 0
        for (j in rownames(ndd)) {
          ii <- paste0(ff[i], '.', j)
          dsc[, ii] <- 0
          dsc[colnames(ndd), ii] <- ndd[j, ]
        }
      }    
    }
    ndd <- rr@modOut@variables$vSupCost
    if (nrow(ndd) > 0) {
      spp <- rr@modInp@parameters$mSupComm@data$comm
      names(spp) <- rr@modInp@parameters$mSupComm@data$sup
      ndd$comm <- spp[ndd$sup]
      ndd <- tapply(ndd$value, ndd[, c('comm', 'year')], sum)
      ndd[is.na(ndd)] <- 0
      for (i in rownames(ndd)) {
        ii <- paste0('cost.', i)
        dsc[, ii] <- 0
        dsc[colnames(ndd), ii] <- ndd[i, ]
      }
    }
    if (any(grep('^cost[.]', colnames(dsc)))) {
      dsc[, 'fuel.cost'] <- dsc[, grep('^cost[.]', colnames(dsc))]
    } else dsc$fuel.cost <- 0
    if (any(grep('^tax[.]', colnames(dsc)))) {
      dsc[, 'fuel.tax'] <- dsc[, grep('^tax[.]', colnames(dsc))]
    } else dsc$fuel.tax <- 0
    if (any(grep('^subs[.]', colnames(dsc)))) {
      dsc[, 'fuel.subs'] <- dsc[, grep('^subs[.]', colnames(dsc))]
    } else dsc$fuel.subs <- 0
    dsc[, 'fuel.total'] <- rowSums(dsc[, c('fuel.subs', 'fuel.tax', 'fuel.cost'), drop = FALSE])
    gfix <- merge(
      rr@modInp@parameters[['pTechFixom']]@data,
      rr@modOut@variables$vTechCap, by = c('tech', 'region', 'year'))
    dsc[as.character(gfix$year), 'fixom'] <- gfix$value.x *  gfix$value.y
    dsc[is.na(dsc[, 'fixom']), 'fixom'] <- 0
    dsc[, 'varom'] <- 0
    gvar <- merge(
      rr@modInp@parameters[['pTechVarom']]@data,
      rr@modOut@variables$vTechAct, by = c('tech', 'region', 'year', 'slice'))
    if (nrow(gvar) > 0) {
      gvar <- tapply(gvar$value.x * gvar$value.y, gvar$year, sum)
      dsc[names(gvar), 'varom'] <- gvar
    }
    gvar <- merge(
      rr@modInp@parameters$pTechCvarom@data,
      rbind(
        rr@modOut@variables$vTechInp, rr@modOut@variables$vTechAInp,
        rr@modOut@variables$vTechOut, rr@modOut@variables$vTechAOut), 
      by = c('tech', 'region', 'year', 'slice'))
    if (nrow(gvar) > 0) {
      gvar <- tapply(gvar$value.x * gvar$value.y, gvar$year, sum)
      dsc[names(gvar), 'varom'] <- dsc[names(gvar), 'varom'] + gvar
    }  
    dsc$invcost <- 0
    ndd <- rr@modOut@variables$vTechInv
    if (nrow(ndd) > 0) {
      ginv <- tapply(ndd$value, ndd$year, sum)
      dsc[names(ginv), 'invcost'] <- ginv
    }
    dsc$total.cost <- apply(dsc[, c('fuel.total', 'invcost', 'fixom', 'varom')], 1, sum)
    dsc[, 'total.discount.cost'] <- dsc[, 'total.cost'] * dsc[, 'discount.factor']
  dd <- sum(dsc[, 'discount.factor'])
  structure(list(total = (rr@modOut@variables$vObjective[1, 1] / sum(dd)), 
    invcost = sum(dsc[, 'invcost'] * dsc[, 'discount.factor']) / dd,
    fixom = sum(dsc[, 'fixom'] * dsc[, 'discount.factor']) / dd, 
    varom = sum(dsc[, 'varom'] * dsc[, 'discount.factor']) / dd,
    fuel = sum(dsc[, 'fuel.cost'] * dsc[, 'discount.factor']) / dd, 
    tax = sum(dsc[, 'fuel.tax'] * dsc[, 'discount.factor']) / dd,
    subsidy = sum(dsc[, 'fuel.subs'] * dsc[, 'discount.factor']) / dd,
    table = dsc), 
    class = 'levcost')
}

#' Calculate levelized costs
#' 
#' \code{levcost} is a method for class \code{technology} to calculate 
#' levelized costs of production of commodity
#' @name levcost
#' @docType methods
#' 
#' @param tech object of class \code{technology}
#' @param start_year numeric, the year of investments
#' @param discount numeric, the discount rate
#' @param price data frame with input commodity prices, has three mandatory fields:
#' 
#'    \code{comm} character, names of commodities 
#'        
#'    \code{price} numeric, prices of the commodity
#'    
#'    \code{year} numeric, years
#' @param solver character, name of solver software "GAMS" or "GLPK"
#' @param tmp.dir a dirrectory for temporary files to run the model, by default
#'                '/solwork' in the project directory.
#' @param tmp.del a logical scalar indicating if solver temporary files should be deleted. 
#'  
#' 

setMethod('levcost', signature(obj = 'repository'), function(obj, ...) {
  if (all(names(list(...)) != 'comm')) stop('Undefined comm for levcost with signature "model", "commodity"')
  lapply(getObjects(obj, class = 'technology', output = list(comm = list(...)$comm)), 
      function(x) energyRt:::.sm_levcost(x, ...))})
setMethod('levcost', signature(obj = 'technology'), energyRt:::.sm_levcost)
setMethod('levcost', signature(obj = 'scenario'), function(obj, commodity) {
  if (is.null(commodity) || length(commodity) != 1) stop('levcost: wrong commodity')
  if (any(obj@modInp@parameters$mDemComm@data$comm != commodity) &&
    any(obj@modOut@data$vDemInp[dimnames(obj@modOut@data$vDemInp)$comm != commodity,,,] != 0)) 
      stop('levcost: demand commodity have to be only one')
  if (all(obj@modInp@parameters$mDemComm@data$comm != commodity) || 
    all(obj@modOut@data$vDemInp[commodity,,,] == 0)) 
      stop('levcost: there is not demand for commodity')
  
  gg <- obj@modInp@parameters$pDiscountFactor@data
  (obj@modOut@data$vObjective / sum(
    tapply(gg$value, gg[, c('region', 'year')], sum)
    * apply(obj@modOut@data$vDemInp[commodity,,,, drop  = FALSE], 2:3, sum)
  ))
})

setMethod('levcost', signature(obj = 'list'), function(obj, ...) {
  #if (all(names(list(...)) != 'comm')) stop('Undefined comm for levcost with signature "model", "commodity"')
  lapply(obj, function(x) energyRt:::.sm_levcost(x, ...))})

setMethod('levcost', signature(obj = 'technology'), energyRt:::.sm_levcost)
setMethod('levcost', signature(obj = 'scenario'), function(obj, commodity) {
  if (is.null(commodity) || length(commodity) != 1) stop('levcost: wrong commodity')
  if (any(obj@modInp@parameters$mDemComm@data$comm != commodity) &&
      any(obj@modOut@data$vDemInp[dimnames(obj@modOut@data$vDemInp)$comm != commodity,,,] != 0)) 
    stop('levcost: demand commodity have to be only one')
  if (all(obj@modInp@parameters$mDemComm@data$comm != commodity) || 
      all(obj@modOut@data$vDemInp[commodity,,,] == 0)) 
    stop('levcost: there is not demand for commodity')
  
  gg <- obj@modInp@parameters$pDiscountFactor@data
  (obj@modOut@data$vObjective / sum(
    tapply(gg$value, gg[, c('region', 'year')], sum)
    * apply(obj@modOut@data$vDemInp[commodity,,,, drop  = FALSE], 2:3, sum)
  ))
})

 