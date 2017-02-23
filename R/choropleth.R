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
                                ...) {
  dat <- getData(obj, ..., merge.table = TRUE, astable = TRUE, get.parameter = FALSE)
  if (is.null(dat)) {
    message("No data for current set of filters")
    return()
  }
  ff <- sapply(dat, is.factor)
  nm <- names(dat)
  rg <- nm == "region"
  lv <- sapply(dat, function(x) {length(levels(x)) > 1})
  #nm[ff & !rg & lv]
  if (sum(ff & !rg & lv) > 0) {
    dt <- aggregate(dat$value, by = list(dat$region), FUN = "sum")
    names(dt) <- c("region", "value")
    dat <- dt
  }
  ltx <- sapply(dat[, ff & !rg], function(x) {
    levs <- levels(x)
    n <- 2
    if(length(levs) > n) {
      levs <- paste0("sum(", levs[1], ",..., ", levs[length(levs)], ")")
    } else if (length(levs) > 1 & length(levs) <= n) {
      levs <- paste0("sum(", paste(levs, collapse = ", "), ")")
    } 
    levs
  })
  #ltx
  ttl <- paste(names(ltx), "=", ltx, collapse = ", ")
  #ttl
  spdf <- sp::merge(scen.BAU@model@sysInfo@sp, dat)
  #head(spdf@data)

  sh <- GISTools::auto.shading(spdf@data[!is.na(spdf@data$value), "value"], n = 9)
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
