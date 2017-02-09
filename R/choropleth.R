# Function to create choropleth maps
choropleth.scenario <- function(scen, # scenario object
                                variable, # character vector with variable names
                                year, # numerical vector with slices
                                slice, # character vector with slices
                                tech, # character vector with technologies name
                                comm,
                                reg = NULL, # names of regions to plot, all if NULL (NA?)
                                from_reg, # character vector with names of source regions
                                to_reg, # character vector with names of destimation regions
                                constrain, 
                                supply,
                                demand,
                                shading = GISTools::auto.shading(variable), # shading schema - see GISTools 
                                animation = TRUE, # 
                                animation.file.format = 'pdf', # gif, html
                                animation.file = NULL, # auto 
                                for.each = list(), # parameter for animation
                                for.sum = list(), # parameter for animation
                                ...) {
  dat <- getData(scen, variable = variable, ...)
  spdf <- sp::SpatialPolygonsDataFrame(scen@model@sysInfo@sp, dat)
  GISTools::choropleth(spdf, variable, shading)
  
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
