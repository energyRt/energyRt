#---------------------------------------------------------------------------------------------------------
# storage
#---------------------------------------------------------------------------------------------------------
setClass("storage",
      representation(
          name          = "character",
          description   = "character",
          commodity     = "character",
          start         = "data.table",
          end           = "data.table",
          aux           = "data.table",      #
          olife         = "data.table",    #
          stock         = "data.table",    #
          charge        = "data.table",    #
          seff          = "data.table",    #
          af            = "data.table",     # Availability of the resource with prices
          aeff          = "data.table",    #  Commodity efficiency
          # Costs
          fixom         = "data.table",    #
          varom         = "data.table",    #
          invcost       = "data.table",
          # GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          fullYear         = "logical",
          region        = "character",
          cap2stg       = "numeric", # cap2stg cinp
          weather       = "data.table",    # weather condisions multiplier
          misc = "list"     #
      ),
      prototype(
          name          = "",
          description   = "",
          commodity     = "",
          start         = data.table(region   = character(),
                                     start    = numeric(),
                                     stringsAsFactors = FALSE),
          end           = data.table(region   = character(),
                                     end      = numeric(),
                                     stringsAsFactors = FALSE),
          olife         = data.table(region = character(),
                                            olife = numeric(),
                                            stringsAsFactors = FALSE),
          charge         = data.table(region = character(),
                                     year  = numeric(),
                                     slice  = numeric(),
                                     charge = numeric(),
                                     stringsAsFactors = FALSE),
          stock         = data.table(region = character(),
                                     year  = numeric(),
                                     stock = numeric(),
                                     stringsAsFactors = FALSE),
          seff         = data.table(region     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     stgeff    = numeric(),  
                                     inpeff    = numeric(),  
                                     outeff    = numeric(),  # cinp.up...,  cout.up...
                                    stringsAsFactors = FALSE),
          aux           = data.table(acomm     = character(),
                                     unit     = character(),
                                     stringsAsFactors = FALSE),
          aeff          = data.table(
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
          af  = data.table(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     af.lo   = numeric(),
                                     af.up   = numeric(),
                                     af.fx   = numeric(),
                                    cinp.up    = numeric(),  
                                    cinp.fx    = numeric(),  
                                    cinp.lo    = numeric(),  
                                    cout.up    = numeric(),  
                                    cout.fx    = numeric(),  
                                    cout.lo    = numeric(),  
                                     stringsAsFactors = FALSE),
          # Costs
          fixom         = data.table(region   = character(),
                                     year     = numeric(),
                                     fixom    = numeric(),
                                     stringsAsFactors = FALSE),
          varom         = data.table(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     inpcost  = numeric(),
                                     outcost  = numeric(),
                                     stgcost = numeric(),
                                     stringsAsFactors = FALSE),
          invcost       = data.table(region   = character(),
                                     year     = numeric(),
                                     invcost  = numeric(),
                                     stringsAsFactors = FALSE),
      cap2stg       = 1,
      # GIS           = NULL,
      fullYear      = TRUE,
      region        = character(),
      weather      = data.table(weather  = character(),
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
#seff = data.table(
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
#weff = data.table(
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
#deff = data.table(
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
