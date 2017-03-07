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
                                main = NULL
) {
  dat <- getData(obj, ..., merge.table = TRUE, astable = TRUE,  drop = FALSE, 
                 yearsAsFactors = TRUE, stringsAsFactors = TRUE)
  if (is.null(dat)) {
    message("No data for current set of filters")
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
  spdf <- sp::merge(scen.BAU@model@sysInfo@sp, dat)
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
  
  #spdf <- sp::merge(scen@model@sysInfo@sp, dat)
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
