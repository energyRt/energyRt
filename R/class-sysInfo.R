#' Class (S4) to represent model configuration settings.
#'
#' @slot discount data.frame.
#' @slot region character.
#' @slot year numeric.
#' @slot milestone data.frame.
#' @slot slice slice.
#' @slot discountFirstYear logical.
#' @slot interpolation data.frame.
#' @slot defVal data.frame.
#' @slot yearFraction data.frame.
#' @slot debug data.frame.
#' @slot misc list.
#'
#' @include class-slice.R class-timeslices.R
#'
#' @return
#' @export
#'
#' @examples
setClass("sysInfo",
  representation(
    discount = "data.frame",
    region = "character",
    year = "numeric",
    milestone = "data.frame", # !!!rename to milestoneYears?
    slice = "slice", # !!!rename to timeslices?
    interpolation = "data.frame",
    defVal = "data.frame",
    discountFirstYear = "logical",
    earlyRetirement = "logical",
    yearFraction = "data.frame",
    debug = "data.frame",
    misc = "list"
  ),
  prototype(
    debug = data.frame(
      comm = character(),
      region = character(),
      # sp = NULL,
      year = numeric(),
      slice = character(),
      dummyImport = numeric(),
      dummyExport = numeric(),
      stringsAsFactors = FALSE
    ),
    discount = data.frame(
      region = character(),
      year = numeric(),
      discount = numeric(),
      stringsAsFactors = FALSE
    ),
    region = NULL,
    year = as.numeric(2005:2050),
    milestone = data.frame(
      start = numeric(),
      mid = numeric(),
      end = numeric()
    ),
    slice = new("slice"),
    discountFirstYear = FALSE,
    earlyRetirement = FALSE,
    defVal = as.data.frame(.defVal, stringsAsFactors = FALSE),
    interpolation = as.data.frame(.defInt, stringsAsFactors = FALSE),
    yearFraction = data.frame(
      year = as.numeric(NA),
      fraction = as.numeric(1),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "sysInfo", function(.Object, ...) {
  .Object
})

# setClass("settings",
#          representation(sample = "list"),
#          contains = "sysInfo",
#          S3methods = TRUE)


setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))

setMethod("setTimeSlices", signature(obj = "sysInfo"), function(obj, ...) {
  obj@slice <- .setTimeSlices(...)
  obj
})

setGeneric("setMilestoneYears",
           function(obj, start, interval) standardGeneric("setMilestoneYears"))

setMethod("setMilestoneYears",
          signature(obj = "sysInfo", start = "numeric", interval = "numeric"),
  function(obj, start, interval) {
    obj@milestone <- milestoneYears(start, interval)
    obj@year <- min(obj@milestone$start):max(obj@milestone$end)
    obj
  }
)

setGeneric("getMilestoneYears",
           function(obj) standardGeneric("getMilestoneYears"))

setMethod("getMilestoneYears",
          signature(obj = "sysInfo"),
          function(obj) {
            obj@milestone
})

setGeneric("milestoneYears",
           function(start, interval) standardGeneric("milestoneYears"))

setMethod("milestoneYears",
          signature(start = "numeric", interval = "numeric"),
          function(start, interval) {
  if (interval[1] != 1) stop("setMileStoneYears: first interval have to be 1")
  mlst <- data.frame(
    start = start + cumsum(c(0, interval[-length(interval)])),
    mid = rep(NA, length(interval)), end = start + cumsum(interval) - 1
  )
  mlst[, "mid"] <- trunc(.5 * (mlst[, "start"] + mlst[, "end"]))
  mlst
})


# defVal = data.frame(
#   # !!! distinguish interpolation for different objects and slots
#   teff = as.numeric(1),
#   cap2cat = as.numeric(1),
#   wcinp.lo = as.numeric(0),
#   wcinp.up = as.numeric(0),
#   wcout.lo = as.numeric(0),
#   wcout.up = as.numeric(0),
#   waf.lo = as.numeric(0),
#   waf.up = as.numeric(0),
#   wafs.lo = as.numeric(0),
#   wafs.up = as.numeric(0),
#   wafc.lo = as.numeric(0),
#   wafc.up = as.numeric(0),
#   cap2stg = as.numeric(1),
#   cinp.lo = as.numeric(0),
#   cinp.up = as.numeric(Inf),
#   cout.lo = as.numeric(0),
#   cout.up = as.numeric(Inf),
#   wava.lo = as.numeric(0),
#   wava.up = as.numeric(0),
#   wval = as.numeric(0),
#   cinp2use = as.numeric(1),
#   ginp2use = as.numeric(1),
#   cinp2ginp = as.numeric(1),
#   use2cact = as.numeric(1),
#   cact2cout = as.numeric(1),
#   share.lo = as.numeric(0),
#   share.up = as.numeric(1),
#   af.lo = as.numeric(0),
#   af.up = as.numeric(1),
#   afs.lo = as.numeric(0),
#   afs.up = as.numeric(Inf),
#   ava.lo = as.numeric(0),
#   ava.up = as.numeric(Inf),
#   fixom = as.numeric(0),
#   varom = as.numeric(0),
#   invcost = as.numeric(0),
#   olife = as.numeric(1),
#   stock = as.numeric(0),
#   afc.lo = as.numeric(0),
#   afc.up = as.numeric(Inf),
#   dummyImport = as.numeric(Inf),
#   dummyExport = as.numeric(Inf),
#   dem = as.numeric(0),
#   cost = as.numeric(0),
#   tax = as.numeric(0),
#   subs = as.numeric(0),
#   cvarom = as.numeric(0),
#   avarom = as.numeric(0),
#   discount = as.numeric(.1),
#   act2ainp = as.numeric(0),
#   cap2ainp = as.numeric(0),
#   act2aout = as.numeric(0),
#   cap2aout = as.numeric(0),
#   cinp2ainp = as.numeric(0),
#   cout2ainp = as.numeric(0),
#   cinp2aout = as.numeric(0),
#   cout2aout = as.numeric(0),
#   stg2ainp = as.numeric(0),
#   stg2aout = as.numeric(0),
#   ncap2aout = as.numeric(0),
#   ncap2ainp = as.numeric(0),
#   ncap2stg = as.numeric(0),
#   charge = as.numeric(0),
#   emis = as.numeric(0),
#   reserve = as.numeric(Inf),
#   res.up = as.numeric(Inf),
#   res.lo = as.numeric(0),
#   cap2act = as.numeric(1),
#   ord = as.numeric(1),
#   card = as.numeric(1),
#   combustion = as.numeric(1),
#   markup = as.numeric(0),
#   price = as.numeric(0),
#   exp.lo = as.numeric(0),
#   exp.up = as.numeric(Inf),
#   imp.lo = as.numeric(0),
#   imp.up = as.numeric(Inf),
#   rhs = as.numeric(0),
#   agg = as.numeric(0),
#   csrc2aout = as.numeric(0),
#   csrc2ainp = as.numeric(0),
#   cdst2aout = as.numeric(0),
#   cdst2ainp = as.numeric(0),
#   inpeff = as.numeric(1),
#   stgeff = as.numeric(1),
#   outeff = as.numeric(1),
#   inpcost = as.numeric(0),
#   stgcost = as.numeric(0),
#   outcost = as.numeric(0),
#   value = as.numeric(0),
#   rampup = as.numeric(Inf),
#   rampdown = as.numeric(Inf),
#   # fraction  = as.numeric(1),
#   stringsAsFactors = FALSE
# ),
# interpolation = data.frame(
#   teff = as.character("back.inter.forth"),
#   cap2cat = as.character("back.inter.forth"),
#   wcinp.lo = as.character("back.inter.forth"),
#   wcinp.up = as.character("back.inter.forth"),
#   wcout.lo = as.character("back.inter.forth"),
#   wcout.up = as.character("back.inter.forth"),
#   cap2stg = as.character("back.inter.forth"),
#   waf.lo = as.character("back.inter.forth"),
#   waf.up = as.character("back.inter.forth"),
#   wafs.lo = as.character("back.inter.forth"),
#   wafs.up = as.character("back.inter.forth"),
#   wafc.lo = as.character("back.inter.forth"),
#   wafc.up = as.character("back.inter.forth"),
#   cinp.lo = as.character("back.inter.forth"),
#   cinp.up = as.character("back.inter.forth"),
#   cout.lo = as.character("back.inter.forth"),
#   cout.up = as.character("back.inter.forth"),
#   wava.lo = as.character("back.inter.forth"),
#   wava.up = as.character("back.inter.forth"),
#   wval = as.character("back.inter.forth"),
#   cinp2use = as.character("back.inter.forth"),
#   ginp2use = as.character("back.inter.forth"),
#   cinp2ginp = as.character("back.inter.forth"),
#   cact2cout = as.character("back.inter.forth"),
#   use2cact = as.character("back.inter.forth"),
#   share.lo = as.character("back.inter.forth"),
#   share.up = as.character("back.inter.forth"),
#   af.lo = as.character("back.inter.forth"),
#   af.up = as.character("back.inter.forth"),
#   afs.lo = as.character("back.inter.forth"),
#   afs.up = as.character("back.inter.forth"),
#   ava.lo = as.character("back.inter.forth"),
#   ava.up = as.character("back.inter.forth"),
#   fixom = as.character("back.inter.forth"),
#   varom = as.character("back.inter.forth"),
#   invcost = as.character("back.inter.forth"),
#   olife = as.character("back.inter.forth"),
#   stock = as.character("back.inter.forth"),
#   afc.lo = as.character("back.inter.forth"),
#   afc.up = as.character("back.inter.forth"),
#   dummyImport = as.character("back.inter.forth"),
#   dummyExport = as.character("back.inter.forth"),
#   dem = as.character("back.inter.forth"),
#   cost = as.character("back.inter.forth"),
#   tax = as.character("inter.forth"),
#   subs = as.character("inter.forth"),
#   cvarom = as.character("back.inter.forth"),
#   avarom = as.character("back.inter.forth"),
#   discount = as.character("back.inter.forth"),
#   act2ainp = as.character("back.inter.forth"),
#   cap2ainp = as.character("back.inter.forth"),
#   act2aout = as.character("back.inter.forth"),
#   cap2aout = as.character("back.inter.forth"),
#   cinp2ainp = as.character("back.inter.forth"),
#   cout2ainp = as.character("back.inter.forth"),
#   cinp2aout = as.character("back.inter.forth"),
#   stg2ainp = as.character("back.inter.forth"),
#   stg2aout = as.character("back.inter.forth"),
#   cout2aout = as.character("back.inter.forth"),
#   ncap2aout = as.character("back.inter.forth"),
#   ncap2ainp = as.character("back.inter.forth"),
#   ncap2stg = as.character(""),
#   charge = as.character(""),
#   emis = as.character("back.inter.forth"),
#   reserve = as.character("back.inter.forth"),
#   res.up = as.character("back.inter.forth"),
#   res.lo = as.character("back.inter.forth"),
#   cap2act = as.character("back.inter.forth"),
#   ord = as.character("back.inter.forth"),
#   card = as.character("back.inter.forth"),
#   combustion = as.character("back.inter.forth"),
#   markup = as.character("back.inter.forth"),
#   price = as.character("back.inter.forth"),
#   exp.lo = as.character("back.inter.forth"),
#   exp.up = as.character("back.inter.forth"),
#   imp.lo = as.character("back.inter.forth"),
#   imp.up = as.character("back.inter.forth"),
#   rhs = as.character("back.inter.forth"),
#   agg = as.character("back.inter.forth"),
#   csrc2aout = as.character("back.inter.forth"),
#   csrc2ainp = as.character("back.inter.forth"),
#   cdst2aout = as.character("back.inter.forth"),
#   cdst2ainp = as.character("back.inter.forth"),
#   inpeff = as.character("back.inter.forth"),
#   stgeff = as.character("back.inter.forth"),
#   outeff = as.character("back.inter.forth"),
#   value = as.character("back.inter.forth"),
#   inpcost = as.character("back.inter.forth"),
#   stgcost = as.character("back.inter.forth"),
#   outcost = as.character("back.inter.forth"),
#   rampup = as.character("back.inter.forth"),
#   rampdown = as.character("back.inter.forth"),
#   fraction = as.character("back.inter.forth"),
#   stringsAsFactors = FALSE
# ),
# yearFraction = 1.,
