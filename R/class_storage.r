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
          loss          = "data.frame",    #
          afa           = "data.frame",     # Availability of the resource with prices
          aeff         = "data.frame",    #  Commodity efficiency
          # Costs
          fixom         = "data.frame",    #
          varom         = "data.frame",    #
          invcost       = "data.frame",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          slice         = "characterOrNULL",
          region        = "characterOrNULL",
          cap2act       = "numeric",
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
                                     stock = numeric(),
                                     stringsAsFactors = FALSE),
          loss         = data.frame(region     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     storeLoss    = numeric(),  
                                     inpLoss    = numeric(),  
                                     outLoss    = numeric(),  
                                     stringsAsFactors = FALSE),
          aux           = data.frame(acomm     = character(),
                                     unit     = character(),
                                     stringsAsFactors = FALSE),
          aeff          = data.frame(
                                      acomm      = character(),
                                      region     = character(),
                                      year       = numeric(),
                                      slice      = character(),
                                      store2ainp  = numeric(),
                                      inp2ainp  = numeric(),
                                      out2ainp  = numeric(),
                                      store2aout  = numeric(),
                                      inp2aout  = numeric(),
                                      out2aout  = numeric(),
                                      cap2ainp  = numeric(),
                                      cap2aout  = numeric(),
                                      ncap2ainp  = numeric(),
                                      ncap2aout  = numeric(),
                                      stringsAsFactors = FALSE),
          afa  = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     afa.lo   = numeric(),
                                     afa.up   = numeric(),
                                     afa.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          # Costs
          fixom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     fixom    = numeric(),
                                     stringsAsFactors = FALSE),
          varom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     inpCost  = numeric(),
                                     outCost  = numeric(),
                                     storeCost = numeric(),
                                     stringsAsFactors = FALSE),
          invcost       = data.frame(region   = character(),
                                     year     = numeric(),
                                     invcost  = numeric(),
                                     stringsAsFactors = FALSE),
      cap2act       = 1,
      GIS           = NULL,
      slice         = NULL,
      region        = NULL,
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "storage", function(.Object, ...) {
  attr(.Object, 'GUID') <- 'd25eda0d-ed46-4d00-b6d5-38a88d11a313'
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
