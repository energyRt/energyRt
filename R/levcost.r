
summary.levcost <- function(x) x$total
sm_levcost <- function(obj, tmp.dir = NULL, tmp.del = TRUE, ...) {
  tech <- upper_case(obj)
  arg <- list(...)
  # prepare model
  reps <- new('repository')
  # Initial parameter
 # tech <- tec
 # arg <- list(discount = .1) #, comm = 'ELC') # For test
  if (all(names(arg) != 'echo')) {
    echo <- TRUE
  } else echo <- arg$echo
  
  if (any(names(arg) == 'solver')) {
    solver <- arg$solver
    arg <- arg[names(arg) != 'solver', drop = FALSE]
  } else solver <- 'GAMS'
  if (any(names(arg) == 'discount')) {
    discount <- arg$discount
    if (is.numeric(discount)) discount <- data.frame(discount = discount, stringsAsFactors = TRUE)
    if (all(colnames(discount) != 'region')) discount <- cbind(discount, region = rep(NA, nrow(discount)))
    if (all(colnames(discount) != 'year')) discount <- cbind(discount, year = rep(NA, nrow(discount)))
    discount <- discount[, c('region', 'year', 'discount'), drop = FALSE]
    discount$region <- as.character(discount$region)
    discount$year <- as.numeric(discount$year)
    arg <- arg[names(arg) != 'discount', drop = FALSE]
  } else {
    discount <- data.frame(region     = character(),
                                     year       = numeric(),
                                     discount    = numeric(),
                                     stringsAsFactors = FALSE)
    discount[1, 'discount'] <- .1
    warning('Discount is not specified, default value 10%')
  }
  if (any(names(arg) == 'tax') && !is.null(arg$tax)) {
    tax <- arg$tax
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
    arg <- arg[names(arg) != 'tax', drop = FALSE]
    for(i in unique(tax$comm)) {
      txx <- newConstrain(paste('TAX', i, sep = ''), 'tax', comm = i, 
         rhs = tax[tax$comm == i, colnames(tax) != 'comm'])
      reps <- add_to_repository(reps, txx);
    }
  } 
  if (any(names(arg) == 'subs') && !is.null(arg$subs)) {
    subs <- arg$subs
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
      sbs <- newConstrain(paste('SUBS', i, sep = ''), 'subs', comm = i, 
         rhs = subs[subs$comm == i, colnames(subs) != 'comm'])
      reps <- add_to_repository(reps, sbs);
    }
    arg <- arg[names(arg) != 'subs', drop = FALSE]
  }
  if (any(names(arg) == 'region')) {
    region <- arg$region
    stopifnot(is.character(region) && length(region) == 1)
    arg <- arg[names(arg) != 'region', drop = FALSE]
  } else if (length(obj@region) != 0) {
    region <- obj@region[1]
  } else region <- 'DEF'
  if (any(names(arg) == 'slice')) {
    slice <- arg$slice
    stopifnot(is.character(slice))
    arg <- arg[names(arg) != 'slice', drop = FALSE]
  } else slice <- 'ANNAUL'
  if (any(names(arg) == 'start_year')) {
    start_year <- arg$start_year
    stopifnot(is.numeric(start_year) && length(start_year) == 1)
    arg <- arg[names(arg) != 'start_year', drop = FALSE]
  } else {
    start_year <- max(c(tech@start$start, 2005, na.rm = TRUE))
    warning('Start year is not specified, default value ', start_year)
  }
  if (any(names(arg) == 'comm')) {
    comm <- toupper(arg$comm)
    stopifnot(is.character(comm) && length(comm) == 1)
    arg <- arg[names(arg) != 'comm', drop = FALSE]
  } else comm <- NULL
  if (any(names(arg) == 'glpkCompileParameter')) {
    glpkCompileParameter <- arg$glpkCompileParameter
    arg <- arg[names(arg) != 'glpkCompileParameter', drop = FALSE]
  } else glpkCompileParameter <- ''
  if (any(names(arg) == 'gamsCompileParameter')) {
    gamsCompileParameter <- arg$gamsCompileParameter
    arg <- arg[names(arg) != 'gamsCompileParameter', drop = FALSE]
  } else gamsCompileParameter <- ''
  if (any(names(arg) == 'cbcCompileParameter')) {
    cbcCompileParameter <- arg$cbcCompileParameter
    arg <- arg[names(arg) != 'cbcCompileParameter', drop = FALSE]
  } else cbcCompileParameter <- ''
  if (any(names(arg) == 'ignore.years')) {
    if (arg$ignore.years) {
      tech@start <- tech@start[0,, drop = FALSE]
      tech@end   <-   tech@end[0,, drop = FALSE]
    }
    arg <- arg[names(arg) != 'ignore.years', drop = FALSE]
  }
  # Check start & end year possibility
  fl <- (!is.na(tech@start$region) & tech@start$region == region)
  if (!any(fl)) fl <- is.na(tech@start$region)
  if (any(fl) && any(tech@start[fl, 'start'] > start_year)) 
    stop('Start year belong to unacceptable time region (see start year)')
  fl <- (!is.na(tech@end$region) & tech@end$region == region)
  if (!any(fl)) fl <- is.na(tech@end$region)
  if (any(fl) && any(tech@end[fl, 'end'] <= start_year)) 
    stop('Start year belong to unacceptable time region (see end year)')
#  if (any(names(arg) == 'use_out_price')) {
#    use_out_price <- arg$use_out_price
#    stopifnot(is.logical(use_out_price) && length(use_out_price) == 1)
#    arg <- arg[names(arg) != 'use_out_price', drop = FALSE]
#  } else use_out_price <- TRUE
  price <- data.frame(comm = character(), region = character(),
            year = numeric(), slice = character(), price = numeric(),
              stringsAsFactors = FALSE)
  if (any(names(arg) == 'price')) {
    stopifnot(is.data.frame(arg$price) && all(colnames(arg$price) %in% c('comm', 'region', 
      'year', 'slice', 'price')))
    price[1:nrow(arg$price), ] <- NA
    for(i in colnames(arg$price)) price[, i] <- arg$price[,i]
    if (any(!is.na(price$year))) price$year[!is.na(price$year)] <- as.numeric(price$year[!is.na(price$year)])
    arg <- arg[names(arg) != 'price', drop = FALSE]
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


  reps <- add_to_repository(reps, tech)
  colnames(price)[colnames(price) == 'price'] <- 'cost'
  for(i in tech@input$comm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    tmpc@limtype[] <- 'FX'
    reps <- add_to_repository(reps, tmpc)
    tmpm <- new('supply')
    tmpm@name <- paste('MIN', i, sep = '')
    tmpm@commodity <- i
    if (any(price$comm == i)) {
       tmpm@availability[1:sum(price$comm == i), colnames(price)[colnames(price) != 'comm']] <-
           price[price$comm == i, colnames(price)[colnames(price) != 'comm']]
    }
    reps <- add_to_repository(reps, tmpm)
  }
  for(i in tech@output$comm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    if (!is.null(comm) && comm == i) {
      tmpc@limtype[] <- 'FX'
    } else {
      tmpc@limtype[] <- 'LO'
    }
    reps <- add_to_repository(reps, tmpc)
  }
  acommin_sup <- tech@aeff[apply(!is.na(tech@aeff[, grep('ainp', colnames(tech@aeff))]), 1, any), 'acomm']
  for(i in tech@aux$acomm) {
    tmpc <- new('commodity')
    tmpc@name <- i
    tmpc@limtype[] <- 'LO'
    reps <- add_to_repository(reps, tmpc)
     #if (any(names(arg) == 'subs') && !is.null(arg$subs) && any(subs$comm == i)) 
     if (any(acommin_sup == i)) { 
        tmpm <- new('supply')
        tmpm@name <- paste('MIN', i, sep = '')
        tmpm@commodity <- i
        if (any(price$comm == i)) {
           tmpm@availability[1:sum(price$comm == i), colnames(price)[colnames(price) != 'comm']] <-
               price[price$comm == i, colnames(price)[colnames(price) != 'comm']]
        }
        reps <- add_to_repository(reps, tmpm)
      }
  }  
 # browser()
  additionalCode <- ''
  if (!is.null(comm)) {
    tmpd <- new('demand')
    tmpd@name <- paste('DEM', comm, sep = '')
    tmpd@commodity <- comm
    tmpd@dem[1, 'dem'] <- 1
    tmpd@dem[1, 'region'] <- region
    reps <- add_to_repository(reps, tmpd)
  }
  mdl <- new('model')
  mdl@name <- paste('Levelized cost technology', tech@name) 
  mdl@LECdata$region <- region
  mdl <- add_to_model(mdl, reps)
  mdl@sysInfo@region <- region
  mdl@sysInfo@year   <- year
  mdl@sysInfo@slice  <- slice
  mdl@sysInfo@discount <- discount
  mdl@LECdata$region <- region
  if (is.null(comm)) {
     mdl@LECdata$pLECLoACT <- 1
  }                    
  #if (!is.null(tax)) mdl@sysInfo@tax <- tax
  #if (!is.null(subs)) mdl@sysInfo@subs <- subs
  #, tmp.dir = tmp.dir
  rr <- solve(mdl, name = 'LEC', solver = solver, tmp.del = tmp.del, tmp.dir = tmp.dir, 
    glpkCompileParameter = glpkCompileParameter, gamsCompileParameter = gamsCompileParameter,
    cbcCompileParameter = cbcCompileParameter, echo = echo)
  if (!(rr@result@solution_report$status == 1 && 
            rr@result@solution_report$finish == 2 && 
            all(rr@result@data$vDumOut == 0))) stop('Error in solution')
##  # Additional table          
##    dsc <- rr@precompiled@maptable[['pDiscountFactor']]@data
##    dsc <- dsc[dsc$region == region, 2:3, drop = FALSE]
##    colnames(dsc)[2] <- 'discount.factor'
##    yy <- rep(0, nrow(dsc))
##    for(i in c(tech@input$comm, tech@output$comm)) {
##      if (any(i == tech@input$comm)) {
##        gg <-  apply(rr@result@data$vTechInp[1, i, region,,, drop = FALSE], 4, sum)
##        dsc[, paste('input.', i, sep = '')] <- gg
##        fl <- TRUE
##      } else {
##        gg <-  apply(rr@result@data$vTechOut[1, i, region,,, drop = FALSE], 4, sum)
##        dsc[, paste('output.', i, sep = '')] <- gg
##        fl <- FALSE
##      }            
##      if (fl) {
##        dsc[, paste('avarage.cost.', i, sep = '')] <-
##          rr@result@data$vSupCost[paste('MIN', i, sep = ''), region,] / gg
##      }
##      dsc[, paste('avarage.tax.', i, sep = '')] <- rr@result@data$vTaxCost[i,region, ] / gg
##      dsc[, paste('avarage.subs.', i, sep = '')] <- rr@result@data$vSubsCost[i,region, ] / gg
##      if (fl) {
##        dsc[, paste('cost.', i, sep = '')] <-
##          rr@result@data$vSupCost[paste('MIN', i, sep = ''), region,]
##      }
##      dsc[, paste('tax.', i, sep = '')] <- rr@result@data$vTaxCost[i,region, ]
##      dsc[, paste('subs.', i, sep = '')] <- rr@result@data$vSubsCost[i,region, ]
##      if (fl) {
##        dsc[, paste('total.cost.', i, sep = '')] <- dsc[, paste('cost.', i, sep = '')] 
##          + dsc[, paste('tax.', i, sep = '')] - dsc[, paste('subs.', i, sep = '')]
##      } else {
##        dsc[, paste('total.cost.', i, sep = '')] <- dsc[, paste('tax.', i, sep = '')] 
##          - dsc[, paste('subs.', i, sep = '')]
##      }
##      xx <- dsc[, paste('total.cost.', i, sep = '')]
##      xx[is.na(xx)] <- 0
##      yy <- yy + xx
##    }
##    for(i in 1:ncol(dsc))
##      dsc[is.nan(dsc[, i]) | dsc[, i] == Inf, i] <- NA
##    dsc <- dsc[, c(TRUE, TRUE, apply(dsc[,-(1:2), drop = FALSE], 2, function(x) any(!is.na(x) & x !=0)))]
##    dsc[, 'fuelcost'] <- yy
##    dsc[, 'invcost'] <- rr@result@data$vTechInv[1, region, ]
##    dsc[, 'fixom'] <- rr@result@data$vTechFixom[1, region, ]
##    dsc[, 'varom'] <- rr@result@data$vTechVaromY[1, region, ]
##    dsc[, 'total.cost'] <- apply(dsc[, ncol(dsc) - (0:3)], 1, sum)
##    dsc[, 'total.discount.cost'] <- dsc[, 'total.cost'] * dsc[, 'discount.factor']
   for(i in names(rr@precompiled@maptable))
     if (rr@precompiled@maptable[[i]]@true_length != -1) {
       rr@precompiled@maptable[[i]]@data <- rr@precompiled@maptable[[i]]@data[
           seq(length.out = rr@precompiled@maptable[[i]]@true_length),, drop = FALSE]
     }
  # Additional table          
    dsc <- rr@precompiled@maptable[['pDiscountFactor']]@data
    dsc <- dsc[dsc$region == region, 2:3, drop = FALSE]
    colnames(dsc)[2] <- 'discount.factor'
    cst <- rep(0, nrow(dsc))
    sbs <- rep(0, nrow(dsc))
    tx <- rep(0, nrow(dsc))
    for(i in c(tech@input$comm, tech@output$comm, tech@aux$acomm)) {
      if (any(i == tech@input$comm)) {
        gg <-  apply(rr@result@data$vTechInp[1, i, region,,, drop = FALSE], 4, sum)
        dsc[, paste('input.', i, sep = '')] <- gg
        fl <- TRUE
      } else if (any(i == tech@output$comm)) {
        gg <-  apply(rr@result@data$vTechOut[1, i, region,,, drop = FALSE], 4, sum)
        dsc[, paste('output.', i, sep = '')] <- gg
        fl <- FALSE
      } else {
        gg <-  apply(rr@result@data$vTechAOut[1, i, region,,, drop = FALSE], 4, sum)
        dsc[, paste('aux.output.', i, sep = '')] <- gg
        gg <-  apply(rr@result@data$vTechAInp[1, i, region,,, drop = FALSE], 4, sum)
        dsc[, paste('aux.input.', i, sep = '')] <- gg
        fl <- FALSE
      }            
      if (fl) {
        cst <- cst + rr@result@data$vSupCost[paste('MIN', i, sep = ''), region,]
      }
      tx <- tx + rr@result@data$vTaxCost[i, region, ]
      sbs <- sbs + rr@result@data$vSubsCost[i, region, ]
    }
    dsc[, 'fuel.cost'] <- cst
    dsc[, 'fuel.tax'] <- tx 
    dsc[, 'fuel.subs'] <- sbs
    dsc[, 'fuel.total'] <- cst + tx - sbs
    dsc[, 'invcost'] <- rr@result@data$vTechInv[1, region, ]
    g2 <- rr@precompiled@maptable[['pTechFixom']]@data
    dsc[, 'fixom'] <- (tapply(g2$Freq, g2[, 1:3], sum) * rr@result@data$vTechCap)[1, region,]
    g1 <- rr@precompiled@maptable[['pTechVarom']]@data
    g3 <- rr@precompiled@maptable[['pTechCvarom']]@data
    g4 <- tapply(g3$Freq, g3[, 1:5], sum)
    dsc[, 'varom'] <- apply(tapply(g1$Freq, g1[, 1:4], sum) * 
      rr@result@data$vTechAct, 1:3, sum)[1, region, ] +
      apply(g4 *(rr@result@data$vTechInp[, dimnames(g4)$comm,,,, drop = FALSE] +
      rr@result@data$vTechOut[, dimnames(g4)$comm,,,, drop = FALSE]), c(1, 3:4), sum)[1, region, ]
    dsc[, 'total.cost'] <- apply(dsc[, c('fuel.total', 'invcost', 'fixom', 'varom')], 1, sum)
    dsc[, 'total.discount.cost'] <- dsc[, 'total.cost'] * dsc[, 'discount.factor']
  dd <- sum(dsc[, 'discount.factor'])
  structure(list(total = rr@result@data$vObjective / dd, 
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
#' @example 
#'  
#' 
sm_levcost_scenario <- function(obj, commodity) {
  if (is.null(commodity) || length(commodity) != 1) stop('levcost: wrong commodity')
  if (any(obj@precompiled@maptable$mDemComm@data$comm != commodity) &&
    any(obj@result@data$vDemInp[dimnames(obj@result@data$vDemInp)$comm != commodity,,,] != 0)) 
      stop('levcost: demand commodity have to be only one')
  if (all(obj@precompiled@maptable$mDemComm@data$comm != commodity) || 
    all(obj@result@data$vDemInp[commodity,,,] == 0)) 
      stop('levcost: there is not demand for commodity')
  
  gg <- obj@precompiled@maptable$pDiscountFactor@data
  (obj@result@data$vObjective / sum(
    tapply(gg$Freq, gg[, c('region', 'year')], sum)
    * apply(obj@result@data$vDemInp[commodity,,,, drop  = FALSE], 2:3, sum)
  ))
}

setMethod('levcost', signature(obj = 'technology'), sm_levcost)
setMethod('levcost', signature(obj = 'scenario'), sm_levcost_scenario)

