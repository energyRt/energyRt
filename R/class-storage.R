# Class storage ####
#' An S4 class to represent storage type of technological process.
#'
#' @description
#' Storage type of technological processes with accumulating capacity of a commodity.
#'
#' @slot name character. Name of the storage (used in sets).
#' @slot desc character. Description of the storage.
#' @slot commodity character. Name of the stored commodity.
#' @slot start data.frame. Start year when the storage technology is available for investment.
#' \describe{
#'  \item{region}{character. Region where the storage technology available for investment. NA for all regions}
#'  \item{start}{integer. The first year when the storage technology is available for investment.}
#' }
#' @slot end data.frame. Last year when the storage technology is available for investment.
#' \describe{
#'  \item{region}{character. Region where the storage technology available for investment. NA for all regions}
#'  \item{end}{integer. The last year when the storage technology is available for investment.}
#' }
#' @slot aux data.frame. Auxiliary commodities.
#' \describe{
#'  \item{acomm}{character. Name of the auxiliary commodity (used in sets).}
#'  \item{unit}{character. Unit of the auxiliary commodity.}
#'  }
#' @slot olife data.frame. Operational life of the storage technology, applicable to the new investment only, the operational life (retirement) of preexiting capacity is described in the @stock slot.
#' \describe{
#'  \item{region}{character. Region where the storage technology is available for investment.}
#'  \item{olife}{integer. Operational life of the storage technology in years.}
#' }
#' @slot stock data.frame. Preexisting capacity of the storage technology
#' \describe{
#'  \item{region}{character. Region where the storage technology is preinstalled.}
#'  \item{year}{integer. Year when the storage technology has preinstalled capacity.}
#'  \item{stock}{numeric. Preexisting capacity of the storage technology for particular year of the model.}
#'  }
#' @slot charge data.frame. Pre-charged level at the beginning of the cycle.
#' \describe{
#'  \item{region}{character. Region where the storage technology is preinstalled or can be installed.}
#'  \item{year}{integer. Year.}
#'  \item{slice}{character. Time slice for wich the charged level will be specifies.}
#'  \item{charge}{numeric. Pre-charged or targeted level at the specified slice.}
#'  }
#' @slot seff data.frame. Storage efficiency parameters.
#' \describe{
#'  \item{region}{character. Region where the storage technology is preinstalled or can be installed. NA for all regions}
#'  \item{year}{integer. Year for wich the storage efficiency will be specifies. NA for all years}
#'  \item{slice}{character. Time slice for wich the storage efficiency will be specifies. NA for all slices}
#'  \item{stgeff}{numeric. Storage decay annual rate.}
#'  \item{inpeff}{numeric. Input efficiency rate.}
#'  \item{outeff}{numeric. Output efficiency rate.}
#'  }
#' @slot af data.frame. Availability factor parameters.
#' \describe{
#' \item{region}{character. Region where the parameter will be actual. NA for all regions}
#' \item{year}{integer. Year when the parameter will be actual. NA for all years}
#' \item{slice}{character. Time slice when the parameter will be actual. NA for all slices}
#' \item{af.lo}{numeric. Lower bound of the availability factor.}
#' \item{af.up}{numeric. Upper bound of the availability factor.}
#' \item{af.fx}{numeric. Fixed value of the availability factor.}
#' \item{cinp.lo}{numeric. Lower bound of the input commodity availability factor.}
#' \item{cinp.up}{numeric. Upper bound of the input commodity availability factor.}
#' \item{cinp.fx}{numeric. Fixed value of the input commodity availability factor.}
#' \item{cout.lo}{numeric. Lower bound of the output commodity availability factor.}
#' \item{cout.up}{numeric. Upper bound of the output commodity availability factor.}
#' \item{cout.fx}{numeric. Fixed value of the output commodity availability factor.}
#' }
#' @slot aeff data.frame. Auxiliary commodities efficiency parameters.
#' \describe{
#' \item{acomm}{character. Name of the auxiliary commodity (used in sets).}
#' \item{region}{character. Region where the parameter will be actual. NA for all regions}
#' \item{year}{integer. Year when the parameter will be actual. NA for all years}
#' \item{slice}{character. Time slice when the parameter will be actual. NA for all slices}
#' \item{stg2ainp}{numeric. Storage to auxiliary input commodity coefficient (multiplier).}
#' \item{cinp2ainp}{numeric. Input commodity to auxiliary input commodity coefficient (multiplier).}
#' \item{cout2ainp}{numeric. Output commodity to auxiliary input commodity coefficient (multiplier).}
#' \item{stg2aout}{numeric. Storage level to auxiliary output commodity coefficient (multiplier).}
#' \item{cinp2aout}{numeric. Input commodity to auxiliary output commodity coefficient (multiplier).}
#' \item{cout2aout}{numeric. Output commodity to auxiliary output commodity coefficient (multiplier).}
#' \item{cap2ainp}{numeric. Capacity to auxiliary input commodity coefficient (multiplier).}
#' \item{cap2aout}{numeric. Capacity to auxiliary output commodity coefficient (multiplier).}
#' \item{ncap2ainp}{numeric. New capacity to auxiliary input commodity coefficient (multiplier).}
#' \item{ncap2aout}{numeric. New capacity to auxiliary output commodity coefficient (multiplier).}
#' \item{ncap2stg}{numeric. New capacity to storage level coefficient (multiplier).}
#' }
#' @slot fixom data.frame. Fixed operation and maintenance cost.
#'  \describe{
#'  \item{region}{character. Region name for wich the parameter will be specified. NA for all regions.}
#'  \item{year}{integer. Year when the specified parameters will be actual. NA for all years.}
#'  \item{fixom}{numeric. Fixed operation and maintenance cost for the speficied sets.}
#' }
#' @slot varom data.frame. Variable operation and maintenance cost.
#' \describe{
#'  \item{region}{character. Region name for wich the parameter will be specified. NA for all regions.}
#'  \item{year}{integer. Year when the specified parameter will be actual. NA for all years.}
#'  \item{slice}{character. Time slice when the specified parameter will be actual. NA for all slices.}
#'  \item{inpcost}{numeric. Costs associated with the input commodity.}
#'  \item{outcost}{numeric. Costs associated with the output commodity.}
#'  \item{stgcost}{numeric. Costs associated with the storage level.}
#' }
#' @slot invcost data.frame. Investment cost.
#' \describe{
#'   \item{region}{character. Region name for wich the parameter will be specified. NA for all regions.}
#'   \item{year}{integer. Year when the specified parameter will be actual. NA for all years.}
#'   \item{invcost}{numeric. Overnight investment cost for the specified region and year.}
#' }
#' @slot fullYear logical. If TRUE, the storage technology operates between timeframes.
#' @slot region character. Region where the storage technology is pre-installed or available for investment.
#' @slot cap2stg numeric. Charging and discharging capacity to the storing capacity inverse ratio.
#' @slot weather data.frame. Weather factors multipliers.
#' \describe{
#'  \item{weather}{character. Name of the applied weather factor.}
#'  \item{waf.lo}{numeric. Coefficient that links the weather factor with the lower bound of the availability factor.}
#'  \item{waf.up}{numeric. Coefficient that links the weather factor with the upper bound of the availability factor.}
#'  \item{waf.fx}{numeric. Coefficient that links the weather factor with the fixed value of the availability factor.}
#'  \item{wcinp.lo}{numeric. Coefficient that links the weather factor with the lower bound of the input commodity availability factor.}
#'  \item{wcinp.up}{numeric. Coefficient that links the weather factor with the upper bound of the input commodity availability factor.}
#'  \item{wcinp.fx}{numeric. Coefficient that links the weather factor with the fixed value of the input commodity availability factor.}
#'  \item{wcout.lo}{numeric. Coefficient that links the weather factor with the lower bound of the output commodity availability factor.}
#' \item{wcout.up}{numeric. Coefficient that links the weather factor with the upper bound of the output commodity availability factor.}
#'  \item{wcout.fx}{numeric. Coefficient that links the weather factor with the fixed value of the output commodity availability factor.}
#' }
#' @slot misc list. Miscellaneous information or parameters.
#'
#' @include class-technology.R
#'
#' @rdname storage
#' @family process
#'
#' @return
#' @export
setClass("storage",
  representation(
    name = "character",
    desc = "character",
    commodity = "character",
    aux = "data.frame", #
    region = "character",
    start = "data.frame",
    end = "data.frame",
    olife = "data.frame", #
    stock = "data.frame", #
    charge = "data.frame", #
    seff = "data.frame", #
    af = "data.frame", # Availability of the resource with prices
    aeff = "data.frame", #  Commodity efficiency
    fixom = "data.frame", #
    varom = "data.frame", #
    invcost = "data.frame",
    fullYear = "logical",
    cap2stg = "numeric", # cap2stg cinp
    weather = "data.frame", # weather condisions multiplier
    misc = "list" #
  ),
  prototype(
    name = "",
    desc = "",
    commodity = "",
    start = data.frame(
      region = character(),
      start = numeric(),
      stringsAsFactors = FALSE
    ),
    end = data.frame(
      region = character(),
      end = numeric(),
      stringsAsFactors = FALSE
    ),
    olife = data.frame(
      region = character(),
      # year = integer(), # add year to distinguish vintages
      olife = numeric(),
      stringsAsFactors = FALSE
    ),
    charge = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      charge = numeric(),
      stringsAsFactors = FALSE
    ),
    stock = data.frame(
      region = character(),
      year = integer(),
      stock = numeric(),
      stringsAsFactors = FALSE
    ),
    seff = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      stgeff = numeric(),
      inpeff = numeric(),
      outeff = numeric(),
      stringsAsFactors = FALSE
    ),
    aux = data.frame(
      acomm = character(),
      unit = character(),
      stringsAsFactors = FALSE
    ),
    aeff = data.frame(
      acomm = character(),
      region = character(),
      year = integer(),
      slice = character(),
      stg2ainp = numeric(),
      cinp2ainp = numeric(),
      cout2ainp = numeric(),
      stg2aout = numeric(),
      cinp2aout = numeric(),
      cout2aout = numeric(),
      cap2ainp = numeric(),
      cap2aout = numeric(),
      ncap2ainp = numeric(),
      ncap2aout = numeric(),
      ncap2stg = numeric(),
      stringsAsFactors = FALSE
    ),
    af = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      af.lo = numeric(),
      af.up = numeric(),
      af.fx = numeric(),
      cinp.up = numeric(),
      cinp.fx = numeric(),
      cinp.lo = numeric(),
      cout.up = numeric(),
      cout.fx = numeric(),
      cout.lo = numeric(),
      stringsAsFactors = FALSE
    ),
    fixom = data.frame(
      region = character(),
      year = integer(),
      fixom = numeric(),
      stringsAsFactors = FALSE
    ),
    varom = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      inpcost = numeric(),
      outcost = numeric(),
      stgcost = numeric(),
      stringsAsFactors = FALSE
    ),
    invcost = data.frame(
      region = character(),
      year = integer(),
      invcost = numeric(),
      stringsAsFactors = FALSE
    ),
    cap2stg = 1,
    fullYear = TRUE,
    region = character(),
    weather = data.frame(
      weather = character(),
      waf.lo = numeric(),
      waf.up = numeric(),
      waf.fx = numeric(),
      wcinp.lo = numeric(),
      wcinp.fx = numeric(),
      wcinp.up = numeric(),
      wcout.lo = numeric(),
      wcout.fx = numeric(),
      wcout.up = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "storage", function(.Object, ...) {
  .Object
})

#' Create new storage object
#'
#' @name newStorage
#' @family storage
#' @rdname storage
#' @export
#'
newStorage <- function(name, ...) {
  .data2slots("storage", name, ...)
}


#' @rdname update
#' @name update
#'
#' @family storage update
#' @keywords storage update
#' @export
setMethod("update", signature(object = "storage"), function(object, ...) {
  # update.storage <- function(obj, ...) {
  .data2slots("storage", object, ...)
})
