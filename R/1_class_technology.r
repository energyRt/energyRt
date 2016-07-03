#' An S4 class to represent technology
#' 
#' @slot name A short name of the technology, also used in GAMS and GLPK
#' @slot description Detailed description
#' @slot type A character string to distinguish various types of technologies (optional)
#' @slot sector A character string to assotiate the technology with a particular sector (optional)
#' @slot enbal A reserved name to refer the technology to a certain part of energy balance (optional)
#' @slot color A color to represent the technology with graphical functions (in development)
#' @slot input 
#' ...

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
      # Performance parameters
          geff          = "data.frame",    #  Group efficiency
          ceff          = "data.frame",    #  Commodity efficiency
          aeff         = "data.frame",    #  Commodity efficiency
          afa           = "data.frame",    #
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
          upgrade.technology = "character"
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
                                     activity = character(),
                                     varom    = character(),
                                     fixom    = character(),
                                     invcost  = character(),
                                     stringsAsFactors = FALSE),
          group        = data.frame(
                                    group    = character(),
                                    description  = character(),  
                                    unit     = character(),
                                    inout     = factor(NULL, c('input', 'output')),
                                    stringsAsFactors = FALSE),
          cap2act       = 1,
                                    # group efficiency 
          geff         = data.frame(region     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     group      = character(),
                                     ginp2use    = numeric(),  
                                     stringsAsFactors = FALSE),
                                    # commodity efficiency 
          ceff          = data.frame(region     = character(),
                                     year       = numeric(),
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
                                     # afac
                                     afac.lo    = numeric(),
                                     afac.up    = numeric(),
                                     afac.fx    = numeric(),
                                      stringsAsFactors = FALSE),
# Auxilary parameter
          aeff          = data.frame(
                                     acomm      = character(),
                                     comm       = character(),
                                     region     = character(),
                                     year       = numeric(),
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
                                     stringsAsFactors = FALSE),
          afa           = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     afa.lo   = numeric(),
                                     afa.up   = numeric(),
                                     afa.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          fixom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     fixom    = numeric(),
                                     stringsAsFactors = FALSE),
          varom         = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     comm     = character(),
                                     varom    = numeric(),
                                     cvarom   = numeric(),
                                     stringsAsFactors = FALSE),
          invcost       = data.frame(region   = character(),
                                     year     = numeric(),
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
                                            year  = numeric(),
                                            ucap = numeric(),
                                            stringsAsFactors = FALSE),
          stock         = data.frame(region = character(),
                                            year  = numeric(),
                                            stock = numeric(),
                                            stringsAsFactors = FALSE),
          early.retirement = TRUE,
          upgrade.technology = character()
      ),
      validity = check_technology_data_frame,
      S3methods = TRUE
)
