# Function to create choropleth maps
# choropleth.scenario <- function(scen, # scenario object
#                                 #name = NULL, # search over names of all objects
#                                 # variable = NULL, # character vector with variable names
#                                 # year = NULL, # numerical vector with slices
#                                 # slice = "ANNUAL", # character vector with slices
#                                 # tech = NULL, # character vector with technologies name
#                                 # comm = NULL,
#                                 # reg = NULL, # names of regions to plot, all if NULL (NA?)
#                                 # from_reg = NULL, # character vector with names of source regions
#                                 # to_reg = NULL, # character vector with names of destimation regions
#                                 # constrain = NULL, 
#                                 # constraint = NULL, 
#                                 # supply = NULL,
#                                 # demand = NULL,
#                                 # shading = GISTools::auto.shading(variable), # shading schema - see GISTools 
#                                 # animation = TRUE, # 
#                                 # animation.file.format = 'pdf', # gif, html
#                                 # animation.file = NULL, # auto 
#                                 # for.each = list(), # parameter for animation
#                                 # for.sum = list(), # parameter for animation
#                                 ...,
#                                 src.reg = TRUE,   # logical, if TRUE, map trade for source region
#                                 dst.reg = !src.reg, # if TRUE, map trade for destination region
#                                 shading = NULL, # colors for syncronization with other data
#                                 cols = "Reds", # used only if shading is not provided
#                                 n = 9, # used only if shading is not provided
#                                 px = NA, # x coordinate of legend locatio
#                                 py = NA, # y coordinate of legend location
#                                 main = NULL, 
#                                 regex = FALSE
# ) {
#   # browser()
#   
#   dat <- getData(scen, ..., merge = TRUE, drop = FALSE, 
#                  yearsAsFactors = TRUE, stringsAsFactors = FALSE)
#   #  }
#   # browser()
#   if (is.null(dat)) {
#     message("No data to display - check the set of filters")
#     return()
#   } else if (nrow(dat) == 0) {
#     message("No data to display - check the set of filters")
#     return()
#   }
#   nm <- names(dat)
#   # cc <- sapply(dat, is.character)
#   # for (i in nm[cc]) {
#   #   dat[,i] <- as.factor(dat[,i])
#   # }
#   # browser()
#   
#   if (!is.factor(dat$year)) dat$year <- as.factor(dat$year)
#   ff <- !sapply(dat, is.numeric)
#   rg <- nm == "region"
#   src.rg <- nm == "src"
#   dst.rg <- nm == "dst"
#   if (!any(rg) & any(src.rg) & any(dst.rg)) { # trade
#     if (src.reg) {
#       #      dat$region = dat$src
#       dat <- dplyr::rename(dat, region = src)
#     } else if(dst.reg) {
#       # dat$region = dat$dst
#       dat <- dplyr::rename(dat, region = dst)
#     } else {
#       stop(" Check src.reg or dst.reg, one of them should be TRUE")
#     }
#     # } else {
#     # stop("The data has no region dimention")
#     ff <- !sapply(dat, is.numeric)
#     nm <- names(dat)
#     rg <- nm == "region"
#     src.rg <- nm == "src"
#     dst.rg <- nm == "dst"
#   }
#   
#   ltx <- sapply(dat[, ff & !rg], function(x) {
#     levs <- levels(as.factor(as.character(x)))
#     n <- 2
#     if(length(levs) > n) {
#       levs <- paste0("sum(", levs[1], ",..., ", levs[length(levs)], ")")
#     } else if (length(levs) > 1 & length(levs) <= n) {
#       levs <- paste0("sum(", paste(levs, collapse = ", "), ")")
#     } 
#     levs
#   })
#   #ltx
#   # browser()
#   if (!is.null(main)) {
#     ttl <- main
#   } else {
#     ttl <- paste(names(ltx), "=", ltx, collapse = ", ")
#   } 
#   lv <- sapply(dat, function(x) {length(unique(x)) > 1 & (!is.numeric(x))})
#   #nm[ff & !rg & lv]
#   if (sum(ff & !rg & lv) > 0) {
#     dt <- aggregate(dat$value, by = list(dat$region), FUN = "sum")
#     names(dt) <- c("region", "value")
#     dat <- dt
#   }
#   # message(paste(nm, collapse = " "))
#   # message(paste(names(dat), collapse = " "))
#   #ttl
#   #}
#   if (is.null(scen@model@sysInfo@GIS)) {
#     message("No GIS information in the scenario. Check YourScenario@GIS")
#   }
#   spdf <- sp::merge(scen@model@sysInfo@GIS, dat)
#   # browser()
#   #head(spdf@data)
#   if(is.null(n)) n = 9
#   if(is.null(cols)) cols = "Reds"
#   if(is.null(shading)) {
#     sh <- GISTools::auto.shading(spdf@data[!is.na(spdf@data$value), "value"], 
#                                  cols = RColorBrewer::brewer.pal(n, cols),
#                                  n = n)
#   } else {
#     sh <- shading
#   }
#   GISTools::choropleth(spdf, spdf@data[, "value"], main = ttl, cex.main = 0.75,
#                        shading = sh)
#   if(!is.na(px) & !is.na(py)) {
#     GISTools::choro.legend(px, py, sh = sh, 
#                            cex = 0.75, bty = "o")
#   }
#   
#   #spdf <- sp::merge(scen@model@sysInfo@GIS, dat)
#   #GISTools::choropleth(spdf, variable, shading)
#   #GISTools::choro.legend()
#   
#   # nyear <- 10
#   # nreg <- length(adm1$scenECTID)
#   # animation::saveLatex(
#   #   for(i in 1:nyear) {
#   #     #choropleth(adm1, cl[,i], main = year + i, cex.main = 3)
#   #     GISTools::choropleth(adm1,  runif(nreg), main = year + i, cex.main = 3)
#   #   },
#   #   ani.width = 800, ani.height = 800, verbose = F
#   # )
#   # 
# }
# 
# # choropleth <- function (...) UseMethod("choropleth")
# 
# arrows_trade <- function(scen, lwd.min = 1, lwd.max = 10, lwd.Inf = lwd.max,
#                          col = "blue", col.Inf = "red",
#                          length = .12, angle = 12, FUN = "sum", 
#                          add = FALSE,
#                          ...) {
#   dat <- getData(scen, ..., # parameter = "pTradeIr", 
#                  drop = FALSE, merge = TRUE, asTibble = FALSE)
#   nm <- names(dat)
#   if (!("src" %in% nm) | !("dst" %in% nm)) {
#     message("No data for source and/or destination region, 'src' and/or 'dst' columns are missing.")
#     message(paste("Names:", nm))
#   }
#   cc <- sapply(dat, is.character)
#   for (i in nm[cc]) {
#     dat[,i] <- as.factor(dat[,i])
#   }
#   # Aggregate data
#   dat <- energyRt:::.agg_srcdst(dat, FUN = FUN)
#   # Coerce to character for merging
#   nm2 <- names(dat)
#   ff <- sapply(dat, is.factor)
#   for (i in nm2[ff]) {
#     dat[,i] <- as.character(dat[,i])
#   }
#   
#   # Add coordinates
#   src <- get_labpt(scen)
#   nm2 <- names(src)
#   ff <- sapply(src, is.factor)
#   for (i in nm2[ff]) {
#     src[,i] <- as.character(src[,i])
#   }
#   
#   names(src) <- c("src", "x.src", "y.src")
#   dst <- src
#   names(dst) <- c("dst", "x.dst", "y.dst")
#   # dat <- dplyr::inner_join(dat, src)
#   # dat <- dplyr::inner_join(dat, dst)
#   dat <- merge(dat, src, by = "src")
#   dat <- merge(dat, dst, by = "dst")
#   
#   #
#   pos <- dat$value > 0
#   ii <- is.infinite(dat$value)
#   if (all(ii & pos)) {
#     dat$lwd <- NA
#     dat$lwd[ii & pos] <- lwd.Inf
#     #message("All Inf") 
#   } else {
#     amax <- max(dat$value[pos])
#     if(is.infinite(amax)) amax <- max(dat$value[pos & !ii])
#     # if(is.infinite(amax)) amax <- mx
#     amin <- min(dat$value[pos])
#     mn <- lwd.min
#     mx <- lwd.max
#     dat$lwd <- NA
#     if (amax > amin) {
#       dat$lwd[pos] <- (dat$value[pos] - amin) * (mx - mn) / (amax - amin)  + mn
#     } else {
#       dat$lwd[pos] <- 0.5 * (lwd.min + lwd.max)
#     }
#     dat$lwd[ii] <- lwd.Inf
#     #message("Not Inf")
#   }
#   dat$col <- col
#   dat$col[ii] <- col.Inf
#   if (!add) plot(scen@model@sysInfo@GIS)
#   arrows(dat$x.src, dat$y.src, dat$x.dst, dat$y.dst, 
#          col = dat$col, length = length, 
#          lwd = dat$lwd, angle = angle)
# }
# 
# agg_region <- function(dat, by = list(dat$region), FUN = "sum",
#                        names = c("region", "value")) {
#   dat <- aggregate(dat$value, by = by, FUN = FUN)
#   names(dat) <- names
#   return(dat)
# }
# 
# .agg_srcdst <- function(dat, by = list(dat$src, dat$dst), FUN = "sum",
#                        names = c("src", "dst", "value")) {
#   dat <- aggregate(dat$value, by = by, FUN = FUN)
#   names(dat) <- names
#   return(dat)
# }

get_labpt <- function(scen) {
  labpt <- sapply(1:length(scen@model@sysInfo@GIS@data[,1]), function(x) {
    scen@model@sysInfo@GIS@polygons[[x]]@labpt
  })
  labpt <- cbind(
    scen@model@sysInfo@GIS@data$region,
    as.data.table(t(labpt))
  )
  names(labpt) <- c("region", "x", "y")
  return(labpt)
}

#' Get coordinates of region centers (labpt)
#'
#' @param spdf SpatialPolygonDataFrame object
#' @param regionsAsCharacters logical, should `regions` column in case of `factor` being coerced to character?
#' @param asTibble logical
#'
#' @return data frame with coordinates of the regions' centers.
#' @export getCenters get_labpt_spdf
#' @aliases get_labpt_spdf
#'
#' @examples
#' \dontrun{
#' getCenters(spdf)
#' get_labpt_spdf(spdf)
#' }
#' 
getCenters <- function(spdf, region = "region", 
                       regionsAsCharacters = TRUE, asTibble = TRUE) {
  # browser()
  labpt <- sapply(1:length(spdf@data[,1]), function(x) {
    spdf@polygons[[x]]@labpt
  })
  labpt <- cbind(
    spdf@data[[region]],
    as.data.table(t(labpt))
  )
  names(labpt) <- c("region", "x", "y")
  if (regionsAsCharacters) labpt <- fact2char(labpt)
  if (asTibble & !is_tibble(labpt)) labpt <- tibble::as_tibble(labpt)
  return(labpt)
}


get_labpt_spdf <- getCenters

fact2char <- function(df, asTibble = TRUE) {
  stopifnot(is.data.table(df))
  jj <- sapply(df, is.factor)
  for (j in names(df)[jj]) {
    df[[j]] <- as.character(df[[j]])
  }
  if (asTibble) {df <- as_tibble(df)}
  df
}

#' Adding region centers coordinate to a data frame
#'
#' @param dat data.table, should have a column with regions' IDs
#' @param labpt data.table with regions' coordinates
#' @param ID character, name of the column with region IDs (default = "region")
#' @param pref tbd
#' @param sfx tbd
#' 
addCenters <- function(dat, labpt, ID = "region", pref = paste0(ID, "."), sfx = NULL) {
  # Adding coordnates of regions' centers
  names(labpt) <- c(ID, paste0(pref, names(labpt) [2:3], sfx))
  dat <- merge(dat, labpt, by = ID)
}

  add_labpt <- addCenters

getSPDF <- function(scen, ...) {
  SPDF <- scen@model@sysInfo@GIS
  if (is.null(SPDF)) {
    stop("The scenario has no spatial information. Check 'scen@model@sysInfo@GIS'")
  }
  
  dat <- getData(scen, ..., merge = TRUE, drop = FALSE)
  dat <- agg_region(dat)
  SPDF <- sp::merge(SPDF, dat)
  return(SPDF)
}
