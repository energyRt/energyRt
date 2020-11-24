#' An S4 class to declare a demand in the model
#'
#' @slot name short name (character) used in sets. 
#' @slot description optional description, comment (character). 
#' @slot commodity character. 
#' @slot unit character. 
#' @slot dem data.frame. 
#' @slot region character. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
#' 
setClass("demand",
      representation(
          name          = "character",
          description   = "character",
          # color         = "data.frame",     
          commodity     = "character",
          unit          = "character",
          dem           = "data.frame",     
          region        = "character",     
          # GIS         = "GIS", # 
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          # color         = data.frame(region   = character(),
          #                            color    = character(),
          #                            stringsAsFactors = FALSE),
          # commodity     = "",
          unit          = "",
          region        = character(),       
          dem           = data.frame(region   = character(),
                                     year     = integer(),
                                     slice    = character(),
                                     dem      = numeric(),
                                     stringsAsFactors = FALSE),
      # GIS           = NULL,
      misc = list()),
      S3methods = TRUE
)

setMethod("initialize", "demand", function(.Object, ...) {.Object})
             
