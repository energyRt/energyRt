#' Title
#'
#' @slot name character. 
#' @slot description character. 
#' @slot commodity character. 
#' @slot unit character. 
#' @slot reserve numeric. 
#' @slot exp data.table. 
#' @slot slice character. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
setClass("export",
      representation(
          name          = "character",
          description   = "character",
          # color         = "data.table",      #
          commodity     = "character",
          unit          = "character",
          reserve       = "numeric",
          exp           = "data.table",
          slice         = "character",
          # GIS                = "GIS", # 
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          # color         = data.table(region   = character(),
          #                            color    = character(),
          #                            stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          reserve       = Inf,
          exp           = data.table(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     exp.lo   = numeric(),
                                     exp.up   = numeric(),
                                     exp.fx   = numeric(),
                                     price     = numeric(),
                                     stringsAsFactors = FALSE),
      # GIS           = NULL,
      slice         = character(),
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
)

setMethod("initialize", "export", function(.Object, ...) {.Object})
