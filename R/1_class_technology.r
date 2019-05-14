#' An S4 class to represent technology
#' 
#' @slot name A short name of the technology, also used in GAMS and GLPK
#' @slot description Detailed description
#' @slot type A character string to distinguish various types of technologies (optional)
#' @slot sector A character string to assotiate the technology with a particular sector (optional)
#' @slot enbal A reserved name to refer the technology to a certain part of energy balance (optional)
#' @slot color A color to represent the technology with graphical functions (in development)
#' @slot input 
#' unfinished...

setClass("technology",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # description
          type	        = "character",       # Optional
          sector	      = "character",       # Sector or Technology group - optional
          enbal         = "character",       # Which part of energy balance - (export, import, ...,
                                             # transformation, consumption, ...
          color         = "data.frame",      #
          input         = "data.frame",      #
          output        = "data.frame",      #
          aux           = "data.frame",      #
          units         = "data.frame",      #
          group         = "data.frame",      # groups units
          cap2act       = "numeric",         #
          cap2stg       = "numeric",         # Technology capacity to storage 
          seff          = "data.frame",      # storage efficiency          
          # Performance parameters
          geff          = "data.frame",    #  Group efficiency
          ceff          = "data.frame",    #  Commodity efficiency
          aeff          = "data.frame",    #  Commodity efficiency
          af            = "data.frame",    #
          afs           = "data.frame",    #
          weather       = "data.frame",    # weather condisions multiplier
          # Costs
          fixom         = "data.frame",    #
          varom         = "data.frame",    #
          invcost       = "data.frame",    #
      # Market
          start         = "data.frame",    #
          end           = "data.frame",    #
          olife         = "data.frame",    #
          ucap          = "data.frame",    # Capacity of one unit (for integer programming)
          stock         = "data.frame", #
          early.retirement = "logical",
          upgrade.technology = "character",
          slice         = "character",
          region        = "character",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          misc = "list"
      ), #
      # Default values and structure of slots
      prototype(
          name          = "",
          description   = "",
          type	        = "",
          sector	      = "",       # Sector or Technology group - optional
          enbal         = "",       # Which part of energy balance - (export, import, ...,
          #region        = "",
          color         = data.frame(region   = character(),
                                     color    = character(),
                                     stringsAsFactors = FALSE),
          input         = data.frame(comm     = character(),
                                     unit     = character(),
                                     group    = character(),  # may be factor or character?
                                     combustion = numeric(),
                                     stringsAsFactors = FALSE),
          output        = data.frame(comm     = character(),
                                     unit     = character(),
                                     group    = character(),
                                     stringsAsFactors = FALSE),
          aux           = data.frame(acomm     = character(),
                                     unit     = character(),
                                     stringsAsFactors = FALSE),
          units         = data.frame(capacity = character(),
                                     use      = character(),
                                     activity = character(),
                                     costs    = character(),
                                     # varom    = character(),
                                     # fixom    = character(),
                                     # invcost  = character(),
                                     stringsAsFactors = FALSE),
          group        = data.frame(
                                    group    = character(),
                                    description  = character(),  
                                    unit     = character(),
#                                    inout     = factor(NULL, c('input', 'output')),
                                    stringsAsFactors = FALSE),
          cap2act       = 1,
          seff         = data.frame(region    = character(),
                                    year      = integer(),
                                    slice     = character(),
                                    stgeff    = numeric(),  
                                    stg2use   = numeric(),  
                                    use2stg   = numeric(),  
                                    stringsAsFactors = FALSE),
          # group efficiency 
          geff         = data.frame(region     = character(),
                                     year       = integer(),
                                     slice      = character(),
                                     group      = character(),
                                     ginp2use    = numeric(),  
                                     stringsAsFactors = FALSE),
                                    # commodity efficiency 
          ceff          = data.frame(region     = character(),
                                     year       = integer(),
                                     slice      = character(),
                                     comm       = character(),
                                     # no groups
                                     cinp2use    = numeric(),  
                                     use2cact    = numeric(),  
                                     cact2cout    = numeric(), 
                                     cinp2ginp   = numeric(), 
                                     # shares within groups
                                     share.lo   = numeric(),
                                     share.up   = numeric(),
                                     share.fx   = numeric(),
                                     # afc
                                     afc.lo    = numeric(),
                                     afc.up    = numeric(),
                                     afc.fx    = numeric(),
                                      stringsAsFactors = FALSE),
# Auxilary parameter
          aeff          = data.frame(
                                     acomm      = character(),
                                     comm       = character(),
                                     region     = character(),
                                     year       = integer(),
                                     slice      = character(),
                                     cinp2ainp  = numeric(),
                                     cinp2aout  = numeric(),
                                     cout2ainp  = numeric(),
                                     cout2aout  = numeric(),
                                     act2ainp  = numeric(),
                                     act2aout  = numeric(),
                                     use2ainp  = numeric(),
                                     use2aout  = numeric(),
                                     cap2ainp  = numeric(),
                                     cap2aout  = numeric(),
                                     ncap2ainp  = numeric(),
                                     ncap2aout  = numeric(),
                                     # storage part
                                     stg2ainp  = numeric(),
                                     sinp2ainp  = numeric(),
                                     sout2ainp  = numeric(),
                                     stg2aout  = numeric(),
                                     sinp2aout  = numeric(),
                                     sout2aout  = numeric(),
                                     stringsAsFactors = FALSE),
          af           = data.frame(region   = character(),
                                     year     = integer(),
                                     slice    = character(),
                                     af.lo    = numeric(),
                                     af.up    = numeric(),
                                     af.fx    = numeric(),
                                     stringsAsFactors = FALSE),
          afs          = data.frame(region   = character(),
                                    year     = integer(),
                                    slice    = character(),
                                    afs.lo   = numeric(),
                                    afs.up   = numeric(),
                                    afs.fx   = numeric(),
                                    stringsAsFactors = FALSE),
          weather      = data.frame(weather  = character(),
                                    comm     = character(),
                                    wafc.lo   = numeric(),
                                    wafc.up   = numeric(),
                                    wafc.fx   = numeric(),
                                    waf.lo    = numeric(),
                                    waf.up    = numeric(),
                                    waf.fx    = numeric(),
                                    wafs.lo   = numeric(),
                                    wafs.up   = numeric(),
                                    wafs.fx   = numeric(),
                                    stringsAsFactors = FALSE),
          fixom         = data.frame(region   = character(),
                                     year     = integer(),
                                     fixom    = numeric(),
                                     stringsAsFactors = FALSE),
          varom         = data.frame(region   = character(),
                                     year     = integer(),
                                     slice    = character(),
                                     comm     = character(),
                                     acomm      = character(),
                                     varom    = numeric(),
                                     cvarom   = numeric(),
                                     avarom   = numeric(),
                                     stringsAsFactors = FALSE),
          invcost       = data.frame(region   = character(),
                                     year     = integer(),
                                     invcost  = numeric(),
                                     stringsAsFactors = FALSE),
          start         = data.frame(region   = character(),
                                     start    = numeric(),
                                     stringsAsFactors = FALSE),
          end           = data.frame(region   = character(),
                                     end      = numeric(),
                                     stringsAsFactors = FALSE),
          olife         = data.frame(region = character(),
                                            olife = numeric(),
                                            stringsAsFactors = FALSE),
          ucap          = data.frame(region = character(),
                                            year  = integer(),
                                            ucap = numeric(),
                                            stringsAsFactors = FALSE),
          stock         = data.frame(region = character(),
                                            year  = integer(),
                                            stock = numeric(),
                                            stringsAsFactors = FALSE),
          early.retirement = TRUE,
          upgrade.technology = character(),
          region        = character(),
          slice         = character(),
          GIS           = NULL,
        #! Misc
        misc = list(
        )),
      validity = .check_technology_data_frame,
      S3methods = TRUE
)
setMethod("initialize", "technology", function(.Object, ...) {
  attr(.Object, 'GUID') <- 'fdaa0d09-9524-405d-b2d8-b6cc1d1ca032'
  .Object
})
              
                                