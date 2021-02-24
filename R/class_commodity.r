#' An S4 class to represent a commodity
#'
#' @slot name short name, used in sets, no white spaces or special characters
#' @slot description (optional) description of 
#' @slot limtype limit type of the commodity in balance equation ("LO" by default)
#' @slot slice the level of time-slice the commodity operates in the model 
#'             (the lowest slice-level used by default)
#' @slot unit the main unit of the commodity used in the model, character string
#' @slot emis data.table with emissions factors, see details
#' @slot agg data.table with aggregation parameters of several commodities into one
#' @slot misc list with miscellaneous information to store
#' 
setClass("commodity",
      representation(
          name          = "character",      # Short name
          description   = "character",      # Details
          limtype       = "factor",
          slice         = "character",
          unit          = "character",
          emis          = "data.table",     # Emission factors
          agg           = "data.table",     # Aggregation parameter
          misc          = "list"
      ),
      prototype(
          name          = character(),
          description   = character(),
          limtype       = factor('LO', levels = c('FX', 'UP', 'LO')),
          slice         = character(),
          unit          = character(),
          agg           = data.table(comm     = character(),
                                     unit     = numeric(),
                                     agg      = numeric(),
                                     stringsAsFactors = FALSE),
          emis          = data.table(comm     = character(),
                                     unit     = character(),
                                     emis     = numeric(),
                                     stringsAsFactors = FALSE),
          misc          = list()),
      S3methods = TRUE
      )

setMethod("initialize", "commodity", function(.Object, ...) {.Object})


