#' Title
#'
#' @slot name character. 
#' @slot description character. 
#' @slot commodity character. 
#' @slot unit character. 
#' @slot reserve numeric. 
#' @slot imp data.frame. 
#' @slot slice character. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
#' 
setClass("import",
      representation(
          name          = "character",
          description   = "character",
          # color         = "data.frame",      #
          commodity     = "character",
          unit          = "character",
          reserve       = "numeric",
          imp           = "data.frame",
          slice         = "character",
          # GIS                = "GIS", 
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          # color         = data.frame(region   = character(),
          #                            color    = character(),
          #                            stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          reserve       = Inf,
          imp           = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     imp.lo   = numeric(),
                                     imp.up   = numeric(),
                                     imp.fx   = numeric(),
                                     price     = numeric(),
                                     stringsAsFactors = FALSE),
      slice         = character(),
      # GIS           = NULL,
      misc = list()),
      S3methods = TRUE
);
setMethod("initialize", "import", function(.Object, ...) {.Object})
