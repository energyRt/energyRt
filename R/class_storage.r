#---------------------------------------------------------------------------------------------------------
# storage
#---------------------------------------------------------------------------------------------------------
setClass("storage",
      representation(
          name          = "character",
          description   = "character",
          commodity     = "character",
          start         = "data.frame",
          end           = "data.frame",
          aux           = "data.frame",      #
          olife         = "data.frame",    #
          stock         = "data.frame",    #
          seff          = "data.frame",    #
          af           = "data.frame",     # Availability of the resource with prices
          aeff         = "data.frame",    #  Commodity efficiency
          # Costs
          fixom         = "data.frame",    #
          varom         = "data.frame",    #
          invcost       = "data.frame",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          fullYear         = "logical",
          region        = "character",
          cap2stg       = "numeric", # cap2stg cinp
          weather       = "data.frame",    # weather condisions multiplier
          misc = "list"     #
      ),
      prototype(
          name          = "",
          description   = "",
          commodity     = "",
          start         = data.frame(region   = character(),
                                     start    = numeric(),
                                     stringsAsFactors = FALSE),
          end           = data.frame(region   = character(),
                                     end      = numeric(),
                                     stringsAsFactors = FALSE),
          olife         = data.frame(region = character(),
                                            olife = numeric(),
                                            stringsAsFactors = FALSE),
          stock         = data.frame(region = character(),
                                     year  = numeric(),
                                     slice  = numeric(),
                                     stock = numeric(),
                                     charge = numeric(),
                                     stringsAsFactors = FALSE),
          seff         = data.frame(region     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     stgeff    = numeric(),  
                                     inpeff    = numeric(),  
                                     outeff    = numeric(),  # cinp.up...,  cout.up...
                                    cinp.up    = numeric(),  
                                    cinp.fx    = numeric(),  
                                    cinp.lo    = numeric(),  
                                    cout.up    = numeric(),  
                                    cout.fx    = numeric(),  
                                    cout.lo    = numeric(),  
                                    stringsAsFactors = FALSE),
          aux           = data.frame(acomm     = character(),
                                     unit     = character(),
                                     stringsAsFactors = FALSE),
          aeff          = data.frame(
                                      acomm      = character(),
                                      region     = character(),
                                      year       = numeric(),
                                      slice      = character(),
                                      stg2ainp  = numeric(),
                                      cinp2ainp  = numeric(),
                                      cout2ainp  = numeric(),
                                      stg2aout  = numeric(),
                                      cinp2aout  = numeric(),
                                      cout2aout  = numeric(),
                                      cap2ainp  = numeric(),
                                      cap2aout  = numeric(),
                                      ncap2ainp  = numeric(),
                                      ncap2aout  = numeric(),
                                      ncap2stg  = numeric(),
                                      stringsAsFactors = FALSE),
          af  = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     af.lo   = numeric(),
                                     af.up   = numeric(),
                                     af.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          # Costs
          fixom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     fixom    = numeric(),
                                     stringsAsFactors = FALSE),
          varom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     inpcost  = numeric(),
                                     outcost  = numeric(),
                                     stgcost = numeric(),
                                     stringsAsFactors = FALSE),
          invcost       = data.frame(region   = character(),
                                     year     = numeric(),
                                     invcost  = numeric(),
                                     stringsAsFactors = FALSE),
      cap2stg       = 1,
      GIS           = NULL,
      fullYear      = TRUE,
      region        = character(),
      weather      = data.frame(weather  = character(),
                                waf.lo    = numeric(),
                                waf.up    = numeric(),
                                waf.fx    = numeric(),
                                wcinp.lo   = numeric(),
                                wcinp.fx   = numeric(),
                                wcinp.up   = numeric(),
                                wcout.lo   = numeric(),
                                wcout.fx   = numeric(),
                                wcout.up   = numeric(),
                                stringsAsFactors = FALSE),
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "storage", function(.Object, ...) {
  .Object
})
#
#
#commodity
#introweek
#introseasson
#introday
#seff = data.frame(
#  region
#  year
#  season
#  ava.up
#  ava.lo
#  ava.fx
#  ava.fx
#  chargeEff
#  dischargeEff
#  storageEff
#)
#weff = data.frame(
#  region
#  year
#  week
#  ava.up
#  ava.lo
#  ava.fx
#  ava.fx
#  chargeEff
#  dischargeEff
#  storageEff
#)
#deff = data.frame(
#  region
#  year
#  day
#  ava.up
#  ava.lo
#  ava.fx
#  ava.fx
#  chargeEff
#  dischargeEff
#  storageEff
#)
#
#invcost
#fixom
#varom
#
#stock
#
#
