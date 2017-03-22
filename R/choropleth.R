# Function to create choropleth maps
choropleth.scenario <- function(obj, # scenario object
                                #name = NULL, # search over names of all objects
                                # variable = NULL, # character vector with variable names
                                # year = NULL, # numerical vector with slices
                                # slice = "ANNUAL", # character vector with slices
                                # tech = NULL, # character vector with technologies name
                                # comm = NULL,
                                # reg = NULL, # names of regions to plot, all if NULL (NA?)
                                # from_reg = NULL, # character vector with names of source regions
                                # to_reg = NULL, # character vector with names of destimation regions
                                # constrain = NULL, 
                                # supply = NULL,
                                # demand = NULL,
                                # shading = GISTools::auto.shading(variable), # shading schema - see GISTools 
                                # animation = TRUE, # 
                                # animation.file.format = 'pdf', # gif, html
                                # animation.file = NULL, # auto 
                                # for.each = list(), # parameter for animation
                                # for.sum = list(), # parameter for animation
                                ...,
                                src.reg = TRUE,   # logical, if TRUE, map trade for source region
                                dst.reg = !src.reg, # if TRUE, map trade for destination region
                                shading = NULL,
                                main = NULL, 
                                regex = FALSE
) {
  # if(regex) {get_data <- "getData_"} else {get_data <- "getData"}
  # dat <- eval(call(get_data, obj, ..., merge = TRUE, table = TRUE,  drop = FALSE, 
  #                yearsAsFactors = TRUE, stringsAsFactors = TRUE))
  # if(regex) {
  #   dat <- getData_(obj, ..., merge = TRUE, table = TRUE,  drop = FALSE, 
  #                  yearsAsFactors = TRUE, stringsAsFactors = TRUE)
  # } else {
    dat <- getData(obj, ..., merge = TRUE, table = TRUE,  drop = FALSE, 
                     yearsAsFactors = TRUE, stringsAsFactors = TRUE, regex = regex)
#  }
    if (is.null(dat) | nrow(dat) == 0) {
    message("No data for the set of filters")
    return()
  }
  nm <- names(dat)
  cc <- sapply(dat, is.character)
  for (i in nm[cc]) {
    dat[,i] <- as.factor(dat[,i])
  }
  
  ff <- sapply(dat, is.factor)
  rg <- nm == "region"
  src.rg <- nm == "src"
  dst.rg <- nm == "dst"
  if (!any(rg) & any(src.rg) & any(dst.rg)) { # trade
    if (src.reg) {
      #      dat$region = dat$src
      dat <- dplyr::rename(dat, region = src)
    } else if(dst.reg) {
      # dat$region = dat$dst
      dat <- dplyr::rename(dat, region = dst)
    } else {
      stop(" Check src.reg or dst.reg, one of them should be TRUE")
    }
    # } else {
    # stop("The data has no region dimention")
    ff <- sapply(dat, is.factor)
    nm <- names(dat)
    rg <- nm == "region"
    src.rg <- nm == "src"
    dst.rg <- nm == "dst"
  }
  
  ltx <- sapply(dat[, ff & !rg], function(x) {
    levs <- levels(as.factor(as.character(x)))
    n <- 2
    if(length(levs) > n) {
      levs <- paste0("sum(", levs[1], ",..., ", levs[length(levs)], ")")
    } else if (length(levs) > 1 & length(levs) <= n) {
      levs <- paste0("sum(", paste(levs, collapse = ", "), ")")
    } 
    levs
  })
  #ltx
  if (!is.null(main)) {
    ttl <- main
  } else {
    ttl <- paste(names(ltx), "=", ltx, collapse = ", ")
    
    lv <- sapply(dat, function(x) {length(levels(x)) > 1})
    #nm[ff & !rg & lv]
    if (sum(ff & !rg & lv) > 0) {
      dt <- aggregate(dat$value, by = list(dat$region), FUN = "sum")
      names(dt) <- c("region", "value")
      dat <- dt
    }
    # message(paste(nm, collapse = " "))
    # message(paste(names(dat), collapse = " "))
    #ttl
  }
  spdf <- sp::merge(scen.BAU@model@sysInfo@GIS, dat)
  #head(spdf@data)
  if(is.null(shading)) {
    sh <- GISTools::auto.shading(spdf@data[!is.na(spdf@data$value), "value"], n = 9)
  } else {
    sh <- shading
  }
  GISTools::choropleth(spdf, spdf@data[, "value"], main = ttl, cex.main = 0.75,
                       shading = sh)
  GISTools::choro.legend(124, 38, sh = sh, 
                         cex = 0.75, bty = "o")
  
  #spdf <- sp::merge(scen@model@sysInfo@GIS, dat)
  #GISTools::choropleth(spdf, variable, shading)
  #GISTools::choro.legend()
  
  # nyear <- 10
  # nreg <- length(adm1$OBJECTID)
  # animation::saveLatex(
  #   for(i in 1:nyear) {
  #     #choropleth(adm1, cl[,i], main = year + i, cex.main = 3)
  #     GISTools::choropleth(adm1,  runif(nreg), main = year + i, cex.main = 3)
  #   },
  #   ani.width = 800, ani.height = 800, verbose = F
  # )
  # 
}

arrows_trade <- function(scen, lwd.min = 1, lwd.max = 10, lwd.Inf = lwd.max,
                         col = "blue", col.Inf = "red",
                         length = .12, angle = 12, FUN = "sum", 
                         add = FALSE,
                         ...) {
  dat <- getData(scen, ..., # parameter = "pTradeIr", 
                 table = TRUE, drop = FALSE, merge = TRUE)
  nm <- names(dat)
  if (!("src" %in% nm) | !("dst" %in% nm)) {
    message("No data for source and/or destination region, 'src' and/or 'dst' columns are missing.")
    message(paste("Names:", nm))
  }
  cc <- sapply(dat, is.character)
  for (i in nm[cc]) {
    dat[,i] <- as.factor(dat[,i])
  }
  # Aggregate data
  dat <- energyRt:::.agg_srcdst(dat, FUN = FUN)
  # Coerce to character for merging
  nm2 <- names(dat)
  ff <- sapply(dat, is.factor)
  for (i in nm2[ff]) {
    dat[,i] <- as.character(dat[,i])
  }
  
  # Add coordinates
  src <- get_labpt(scen)
  nm2 <- names(src)
  ff <- sapply(src, is.factor)
  for (i in nm2[ff]) {
    src[,i] <- as.character(src[,i])
  }
  
  names(src) <- c("src", "x.src", "y.src")
  dst <- src
  names(dst) <- c("dst", "x.dst", "y.dst")
  # dat <- dplyr::inner_join(dat, src)
  # dat <- dplyr::inner_join(dat, dst)
  dat <- merge(dat, src, by = "src")
  dat <- merge(dat, dst, by = "dst")
  
  #
  pos <- dat$value > 0
  ii <- is.infinite(dat$value)
  if (all(ii & pos)) {
    dat$lwd <- NA
    dat$lwd[ii & pos] <- lwd.Inf
    #message("All Inf") 
  } else {
    amax <- max(dat$value[pos])
    if(is.infinite(amax)) amax <- max(dat$value[pos & !ii])
    # if(is.infinite(amax)) amax <- mx
    amin <- min(dat$value[pos])
    mn <- lwd.min
    mx <- lwd.max
    dat$lwd <- NA
    if (amax > amin) {
      dat$lwd[pos] <- (dat$value[pos] - amin) * (mx - mn) / (amax - amin)  + mn
    } else {
      dat$lwd[pos] <- 0.5 * (lwd.min + lwd.max)
    }
    dat$lwd[ii] <- lwd.Inf
    #message("Not Inf")
  }
  dat$col <- col
  dat$col[ii] <- col.Inf
  if (!add) plot(scen@model@sysInfo@GIS)
  arrows(dat$x.src, dat$y.src, dat$x.dst, dat$y.dst, 
         col = dat$col, length = length, 
         lwd = dat$lwd, angle = angle)
}

agg_region <- function(dat, by = list(dat$region), FUN = "sum",
                       names = c("region", "value")) {
  dat <- aggregate(dat$value, by = by, FUN = FUN)
  names(dat) <- names
  return(dat)
}

.agg_srcdst <- function(dat, by = list(dat$src, dat$dst), FUN = "sum",
                       names = c("src", "dst", "value")) {
  dat <- aggregate(dat$value, by = by, FUN = FUN)
  names(dat) <- names
  return(dat)
}

get_labpt <- function(scen) {
  labpt <- sapply(scen@model@sysInfo@GIS$OBJECTID, function(x) {
    scen.BAU@model@sysInfo@GIS@polygons[[x]]@labpt
  })
  labpt <- cbind(
    scen@model@sysInfo@GIS@data$region,
    as.data.frame(t(labpt))
  )
  names(labpt) <- c("region", "x", "y")
  return(labpt)
}

add_labpt <- function(dat, labpt, ID = "region", pref = paste0(ID, "."), sfx = NULL) {
  # Adding coordnates of regions' centers
  names(labpt) <- c(ID, paste0(pref, names(labpt) [2:3], sfx))
  dat <- merge(dat, labpt, by = ID)
  
}

getSPDF <- function(scen, ...) {
  SPDF <- scen@model@sysInfo@GIS
  if (is.null(SPDF)) {
    stop("The scenario has no spatial information. Check 'scen@model@sysInfo@GIS'")
  }
  
  dat <- getData(scen, ..., table = TRUE, merge = TRUE, drop = FALSE)
  dat <- agg_region(dat)
  SPDF <- sp::merge(SPDF, dat)
  return(SPDF)
}
