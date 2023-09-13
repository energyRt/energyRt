#' An S4 class to represent scenario settings
#'
#' @slot subset list.
#' @slot solver list.
#' @slot sourceCode list.
#' @slot yearFraction
#'
#' @include class-config.R
#' @export
setClass("settings",
  representation(
    subset = "list",
    yearFraction = "data.frame",
    solver = "list",
    sourceCode = "list" # Model/scenario source code
    # misc = "list"
  ),
  contains = "config",
  prototype(
    subset = list(
      drop = list(
        timeslices = character(),
        objects = character()
      ),
      keep = list(
        timeslices = character(),
        objects = character()
      )
    ),
    yearFraction = data.frame(
      year = as.numeric(NA),
      fraction = as.numeric(1),
      stringsAsFactors = FALSE
    ),
    solver = list(),
    sourceCode = list() # Model source
    # misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "settings", function(.Object, ...) {
  .Object
})

.config_to_settings <- function(cfg, stt = NULL) {
  # import model configuration to scenario settings
  # (no processing, direct overwriting)
  # browser()
  if (is.null(stt)) stt <- new("settings")
  imp_slots <- slotNames("config")
  imp_slots <- imp_slots[!(imp_slots %in% c(".S3Class"))]
  for (s in imp_slots) {
    slot(stt, s) <- slot(cfg, s)
  }
  return(stt)
}

if (F) {
  cfg <- .config_to_settings(mdl@config)

}
