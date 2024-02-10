#' An S4 class to represent technology
#'
#' @rdname technology
#'
#' @slot name character, name of technology used in sets
#' @slot desc character, optional description of the technology for reference.
#' @slot input main (non-auxilary) input commodities, data.frame with columns:
#' \describe{
#'   \item{comm}{character, name of input commodity}
#'   \item{unit}{character, unit of the input commodity}
#'   \item{group}{character, name of input group for input commodities-substitutes}
#'   \item{combustion}{numeric, combustion factor from 0 to 1 (default 1) to calculate emissions from fuels combustion (commodities intermediate consumption, more broadly)}
#' }
#' @slot output main (non-auxilary) output commodities, data.frame with columns:
#' \describe{
#'   \item{comm}{character, name of output commodity}
#'   \item{unit}{character, unit of the output commodity}
#'   \item{group}{character, name of output group for output commodities-substitutes}
#' }
#' @slot aux auxilary commodities, both input and output, data.frame with columns:
#' \describe{
#'   \item{acomm}{character, name of auxilary commodity}
#'   \item{unit}{character, unit of the auxilary commodity}
#' }
#' @slot units key units of the process activity and capacity. data.frame with columns:
#' \describe{
#'   \item{capacity}{character, name of capacity unit}
#'   \item{use}{character, name of use unit}
#'   \item{activity}{character, name of activity unit}
#'   \item{costs}{character, name of cost unit}
#' }
#' @slot group optional details for groups, data.frame with columns:
#' \describe{
#'   \item{group}{character, name of group}
#'   \item{desc}{character, optional description of the group}
#'   \item{unit}{character, optional unit of the group}
#' }
#' @slot cap2act numeric. Capacity to activity ratio. Default 1. Specifies how much product (output) will be produced per unit of capacity.
#' @slot geff input-group efficiency parameter, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of slice for which the parameter will be applied, NA for every slice}
#'  \item{group}{character, name of group for which the parameter will be applied, required}
#'  \item{ginp2use}{numeric, group input to use ratio, NA means no changes of default value}
#' }
#' @slot ceff commodity-related efficiency parameters, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of slice for which the parameter will be applied, NA for every slice}
#'  \item{comm}{character, name of commodity for which the parameter will be applied, required}
#'  \item{cinp2use}{numeric, commodity input to use parameter, NA means default value}
#'  \item{use2cact}{numeric, use to commodity activity parameter, NA means default value}
#'  \item{cact2cout}{numeric, commodity activity to commodity output parameter, NA means default value (1)}
#'  \item{cinp2ginp}{numeric, commodity input to group input parameter, NA means default value (1)}
#'  \item{share.lo}{numeric, lower bound on a share of commodity within a group, NA means default value(0) or fixed value if specified}
#'  \item{share.up}{numeric, upper bound on a share of commodity within a group, NA means default value(1) or fixed value if specified}
#'  \item{share.fx}{numeric, fixed share of commodity within a group, NA ignored}
#'  \item{afc.lo}{numeric, lower bound on the physical value of the commodity, NA ignored}
#'  \item{afc.up}{numeric, upper bound on the physical value of the commodity, NA ignored}
#'  \item{afc.fx}{numeric, fixed physical value of the commodity, NA ignored}
#' }
#' @slot aeff auxilary-commodity-related efficiency parameters, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of slice for which the parameter will be applied, NA for every slice}
#'  \item{acomm}{character, name of auxilary commodity for which the parameter will be applied, required}
#'  \item{cinp2ainp}{numeric, main commodity input to auxilary commodity input parameter, NA ignored}
#'  \item{cinp2aout}{numeric, main commodity input to auxilary commodity output parameter, NA ignored}
#'  \item{cout2ainp}{numeric, main commodity output to auxilary commodity input parameter, NA ignored}
#'  \item{cout2aout}{numeric, main commodity output to auxilary commodity output parameter, NA ignored}
#'  \item{act2ainp}{numeric, technology activity to auxilary commodity input parameter, NA ignored}
#'  \item{act2aout}{numeric, technology activity to auxilary commodity output parameter, NA ignored}
#'  \item{cap2ainp}{numeric, technology capacity to auxilary commodity input parameter, NA ignored}
#'  \item{cap2aout}{numeric, technology capacity to auxilary commodity output parameter, NA ignored}
#'  \item{ncap2ainp}{numeric, technology new capacity to auxilary commodity input parameter, NA ignored}
#'  \item{ncap2aout}{numeric, technology new capacity to auxilary commodity output parameter, NA ignored}
#'  \item{stg2ainp}{(!!!not implemented!!!) numeric, technology storage level to auxilary commodity input parameter, NA ignored}
#'  \item{stg2aout}{(!!!not implemented!!!) numeric, technology storage level to auxilary commodity output parameter, NA ignored}
#'  \item{sinp2ainp}{(!!!not implemented!!!) numeric, technology storage input to auxilary commodity input parameter, NA ignored}
#'  \item{sinp2aout}{(!!!not implemented!!!) numeric, technology storage input to auxilary commodity output parameter, NA ignored}
#'  \item{sout2ainp}{(!!!not implemented!!!) numeric, technology storage output to auxilary commodity input parameter, NA ignored}
#'  \item{sout2aout}{(!!!not implemented!!!) numeric, technology storage output to auxilary commodity output parameter, NA ignored}
#'  }
#' @slot af timeslice-level availability factor parameters, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of slice for which the parameter will be applied, NA for every time-slice of the technology timeframe}
#'  \item{af.lo}{numeric, lower bound on the availability factor, NA means default value (0) or fixed value if specified}
#'  \item{af.up}{numeric, upper bound on the availability factor, NA means default value (1) or fixed value if specified}
#'  \item{af.fx}{numeric, fixed availability factor, NA ignored}
#'  \item{rampup}{numeric, ramp-up time constraint, NA ignored}
#'  \item{rampdown}{numeric, ramp-down time constraint, NA ignored}
#'  }
#' @slot afs timeframe level (or group of slices) availability factor constraints, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of the timeframe for which the parameter will be applied, requires, NA will return an error}
#'  \item{afs.lo}{numeric, lower bound on the availability factor for the timeframe, NA means default value (0) or fixed value if specified}
#'  \item{afs.up}{numeric, upper bound on the availability factor for the timeframe, NA means default value (1) or fixed value if specified}
#'  \item{afs.fx}{numeric, fixed availability factor for the timeframe, NA ignored}
#'  }
#' @slot weather external ("weather") factors affecting the technology availability paramaters, data.frame with columns:
#' \describe{
#'  \item{weather}{character, name of the applied weather factor, required}
#'  \item{comm}{character, name of the commodity with specified `afc.*` affected by the weather factor, required}
#'  \item{wafc.lo}{numeric, multiplying coefficient to the lower bound on the commodity availability parameter `afc.lo`, NAs ignored of fixed values used}
#'  \item{wafc.up}{numeric, multiplying coefficient to the upper bound on the commodity availability parameter `afc.up`, NAs ignored of fixed values used}
#'  \item{wafc.fx}{numeric, multiplying coefficient to the fixed value of the commodity availability parameter `afc.fx`, NAs ignored of fixed values used}
#'  \item{waf.lo}{numeric, multiplying coefficient to the lower bound on the availability factor parameter `af.lo`, NAs ignored of fixed values used}
#'  \item{waf.up}{numeric, multiplying coefficient to the upper bound on the availability factor parameter `af.up`, NAs ignored of fixed values used}
#'  \item{waf.fx}{numeric, multiplying coefficient to the fixed value on the availability factor parameter `af.fx`, NAs ignored of fixed values used}
#'  \item{wafs.up}{numeric, multiplying coefficient to the upper bound on the availability factor parameter `afs.up`, NAs ignored of fixed values used}
#'  \item{wafs.lo}{numeric, multiplying coefficient to the lower bound on the availability factor parameter `afs.lo`, NAs ignored of fixed values used}
#'  \item{wafs.fx}{numeric, multiplying coefficient to the fixed value on the availability factor parameter `afs.fx`, NAs ignored of fixed values used}
#'  }
#' @slot fixom fixed operational and maintenance cost (per unit of capacity a year), data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{fixom}{numeric, fixed operational and maintannance cost, NA means default value (0)}
#'  }
#' @slot varom variable operational and maintenance cost (per unit of activity or commodity), data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{slice}{character, name of the time-slice or (grand-)parent timeframe for which the parameter will be applied, NA for every time-slice of the technology timeframe}
#'  \item{varom}{numeric, variable operational and maintannance cost per unit of activity, NA means default value (0)}
#'  \item{comm}{character, name of the commodity for which the parameter will be applied, required for `cvarom` parameter}
#'  \item{cvarom}{numeric, variable operational and maintannance cost per unit of commodity, NA means default value (0)}
#'  \item{acomm}{character, name of the auxilary commodity for which the `avarom` will be applied, required for `avarom` parameter}
#'  \item{avarom}{numeric, variable operational and maintannance cost per unit of auxilary commodity, NA means default value (0)}
#' }
#' @slot invcost total overnight investment costs of the project (per unit of capacity), data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the parameter will be applied, NA for every year}
#'  \item{invcost}{numeric, total overnight investment costs of the project (per unit of capacity), NA means default value (0)}
#' }
#' @slot start the first year the technology can be installed, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{start}{integer, the first year the technology can be installed, NA means all years of the model horizon}
#' }
#' @slot end the last year the technology can be installed, data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA means default value (-Inf)}
#'  \item{end}{integer, the last year the technology can be installed, NA means default value (Inf)}
#' }
#' @slot olife operational life of the installed technology (in years), data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{olife}{integer, operational life of the installed technology (in years), NA means default value (1)}
#' }
#' @slot stock predefined stock of the installed technology (in units of capacity), data.frame with columns:
#' \describe{
#'  \item{region}{character, name of the region for which the parameter will be applied, NA for every region}
#'  \item{year}{integer, year for which the stock will be specified, required, values between specified years will be interpolated.}
#'  \item{stock}{numeric, predefined existing of future capacity of the technology (in units of capacity), NA means default value (0)}
#' }
#' @slot optimizeRetirement logical. Currently ignored.
#' @slot upgrade.technology character. Currently ignored.
#' @slot fullYear logical. Currently ignored.
#' @slot timeframe character name of timeframe level the technology is operating. By default, the lowest level of commodities in the technology is applied.
#' @slot region character vector of regions where the technology exist or can be installed.
#' @slot misc list with any miscellaneous information.
#' @slot capacity data.frame (not implemented!) Capacity parameters of the technology.
#'
#' @include class-supply.R
#'
#' @family technology
#'
#' @export
#'
setClass("technology",
  representation(
    # General information
    name = "character", # Short name
    desc = "character", # desc
    input = "data.frame", #
    output = "data.frame", #
    aux = "data.frame", #
    units = "data.frame", #
    group = "data.frame", # groups units
    cap2act = "numeric", #
    # Performance parameters
    geff = "data.frame", #
    ceff = "data.frame", #
    aeff = "data.frame", #
    af = "data.frame", #
    afs = "data.frame", #
    weather = "data.frame", #
    # Costs
    fixom = "data.frame", #
    varom = "data.frame", #
    invcost = "data.frame", #
    # Market
    start = "data.frame", #
    end = "data.frame", #
    olife = "data.frame", #
    # stock = "data.frame", #
    capacity = "data.frame", #
    optimizeRetirement = "logical",
    # upgrade.technology = "character",
    fullYear = "logical",
    timeframe = "character",
    region = "character",
    misc = "list"
  ), #
  prototype(
    name = "",
    desc = "",
    input = data.frame(
      comm = character(),
      unit = character(),
      group = character(), # may be factor or character?
      combustion = numeric(),
      stringsAsFactors = FALSE
    ),
    output = data.frame(
      comm = character(),
      unit = character(),
      group = character(),
      stringsAsFactors = FALSE
    ),
    aux = data.frame(
      acomm = character(),
      unit = character(),
      stringsAsFactors = FALSE
    ),
    units = data.frame(
      capacity = character(),
      use = character(),
      activity = character(),
      costs = character(),
      stringsAsFactors = FALSE
    ),
    group = data.frame(
      group = character(),
      desc = character(),
      unit = character(),
      stringsAsFactors = FALSE
    ),
    cap2act = 1,
    # group efficiency
    geff = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      group = character(),
      ginp2use = numeric(),
      stringsAsFactors = FALSE
    ),
    # commodity efficiency
    ceff = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      comm = character(),
      cinp2use = numeric(),
      use2cact = numeric(),
      cact2cout = numeric(),
      cinp2ginp = numeric(),
      share.lo = numeric(),
      share.up = numeric(),
      share.fx = numeric(),
      afc.lo = numeric(), # !!! check and potentially rename avc.*
      afc.up = numeric(),
      afc.fx = numeric(),
      stringsAsFactors = FALSE
    ),
    # Auxilary parameter
    aeff = data.frame(
      acomm = character(),
      comm = character(),
      region = character(),
      year = integer(),
      slice = character(),
      cinp2ainp = numeric(),
      cinp2aout = numeric(),
      cout2ainp = numeric(),
      cout2aout = numeric(),
      act2ainp = numeric(),
      act2aout = numeric(),
      cap2ainp = numeric(),
      cap2aout = numeric(),
      ncap2ainp = numeric(),
      ncap2aout = numeric(),
      # storage part
      stg2ainp = numeric(),
      sinp2ainp = numeric(),
      sout2ainp = numeric(),
      stg2aout = numeric(),
      sinp2aout = numeric(),
      sout2aout = numeric(),
      stringsAsFactors = FALSE
    ),
    af = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      af.lo = numeric(),
      af.up = numeric(),
      af.fx = numeric(),
      rampup = numeric(),
      rampdown = numeric(),
      stringsAsFactors = FALSE
    ),
    afs = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      afs.lo = numeric(),
      afs.up = numeric(),
      afs.fx = numeric(),
      stringsAsFactors = FALSE
    ),
    weather = data.frame(
      weather = character(),
      comm = character(),
      wafc.lo = numeric(),
      wafc.up = numeric(),
      wafc.fx = numeric(),
      waf.lo = numeric(),
      waf.up = numeric(),
      waf.fx = numeric(),
      wafs.lo = numeric(),
      wafs.up = numeric(),
      wafs.fx = numeric(),
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
      comm = character(),
      acomm = character(),
      varom = numeric(),
      cvarom = numeric(),
      avarom = numeric(),
      stringsAsFactors = FALSE
    ),
    invcost = data.frame(
      region = character(),
      year = integer(),
      invcost = numeric(),
      wacc = numeric(),
      retcost = numeric(),
      stringsAsFactors = FALSE
    ),
    start = data.frame(
      region = character(),
      start = integer(),
      stringsAsFactors = FALSE
    ),
    end = data.frame(
      region = character(),
      end = integer(),
      stringsAsFactors = FALSE
    ),
    olife = data.frame(
      region = character(),
      olife = integer(),
      stringsAsFactors = FALSE
    ),
    # stock = data.frame(
    #   region = character(),
    #   year = integer(),
    #   stock = numeric(),
    #   stringsAsFactors = FALSE
    # ),
    capacity = data.frame(
      region = character(),
      year = integer(),
      stock = numeric(),
      cap.lo = numeric(),
      cap.up = numeric(),
      cap.fx = numeric(),
      ncap.lo = numeric(),
      ncap.up = numeric(),
      ncap.fx = numeric(),
      ret.lo = numeric(),
      ret.up = numeric(),
      ret.fx = numeric(),
      stringsAsFactors = FALSE
    ),
    optimizeRetirement = TRUE,
    # upgrade.technology = character(),
    region = character(),
    timeframe = character(),
    misc = list()
  ),
  # validity = .check_technology_data_frame,
  S3methods = FALSE
)

setMethod("initialize", "technology", function(.Object, ...) {
  .Object
})

#' Create object of class `technology`.
#'
#' @family technology, process
#' @rdname technology
#'
#' @return an object of class technology.
#' @export
#'
#' @examples
newTechnology <- function(
    name = "",
    desc = "",
    input = data.frame(),
    output = data.frame(),
    group = data.frame(),
    aux = data.frame(),
    units = data.frame(),
    cap2act = as.numeric(1),
    geff = data.frame(),
    ceff = data.frame(),
    aeff = data.frame(),
    af = data.frame(),
    afs = data.frame(),
    weather = data.frame(),
    # stock = data.frame(),
    capacity = data.frame(),
    invcost = data.frame(),
    fixom = data.frame(),
    varom = data.frame(),
    olife = data.frame(),
    region = character(),
    start = data.frame(),
    end = data.frame(),
    timeframe = character(),
    fullYear = TRUE,
    optimizeRetirement = FALSE,
    # upgrade.technology = character(),
    misc = list()) {
  # browser()
  .data2slots("technology", name,
    desc = desc,
    input = input,
    output = output,
    group = group,
    aux = aux,
    units = units,
    cap2act = cap2act,
    geff = geff,
    ceff = ceff,
    aeff = aeff,
    af = af,
    afs = afs,
    weather = weather,
    # stock = stock,
    capacity = capacity,
    invcost = invcost,
    fixom = fixom,
    varom = varom,
    olife = olife,
    region = region,
    start = start,
    end = end,
    timeframe = timeframe,
    fullYear = fullYear,
    optimizeRetirement = optimizeRetirement,
    # upgrade.technology = upgrade.technology,
    misc = misc
  )
}

#' @param object object of class technology
#'
#' @param ... slot-names with data to update (see `newTechnology`)
#'
#' @rdname technology
#' @family update technology process
#' @method update technology
#' @export
setMethod("update", "technology", function(object, ...) {
  .data2slots("technology", object, ...)
})

# get names of data.frame slots
.technology_data_frame <- function() {
  # get technology slot data.frame names
  g <- getClass("technology")
  names(g@slots)[sapply(names(g@slots), function(z) g@slots[[z]] == "data.frame")]
}

# table commodity_type and checks
checkInpOut <- function(tech) {
  ctype <- data.frame(
    type = factor(NULL, c("input", "output", "aux")),
    group = character(),
    comb = numeric(),
    unit = character(),
    stringsAsFactors = FALSE
  )
  # Define type commodity
  icomm <- tech@input$comm
  ocomm <- tech@output$comm
  acomm <- tech@aux$acomm
  comm <- c(icomm, ocomm, acomm)
  ctype[seq(along = comm), ] <- NA
  rownames(ctype) <- comm
  ctype[icomm, "type"] <- "input"
  ctype[ocomm, "type"] <- "output"
  ctype[acomm, "type"] <- "aux"
  ctype[icomm, c("group", "unit")] <- tech@input[, c("group", "unit")]
  ctype[ocomm, c("group", "unit")] <- tech@output[, c("group", "unit")]
  ctype[, "comb"] <- 0
  tech@input$combustion[is.na(tech@input$combustion)] <- 1
  ctype[tech@input$comm, "comb"] <- tech@input$combustion
  aux <- data.frame(
    input = logical(),
    output = logical(),
    stringsAsFactors = FALSE
  )
  if (length(acomm)) {
    aux[seq(along = acomm), ] <- FALSE
    rownames(aux) <- acomm
  }
  #  Check type
  # ! have to realised
  if (length(icomm) == 0 && length(ocomm) == 0) {
    warnings("There is no input & output commodity")
  }

  # Define technology type by parameter
  for (i in comm) {
    # Group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c(
      "cinp2ginp", "share.lo",
      "share.up", "share.fx"
    )]))) {
      if (is.na(ctype[i, "group"])) {
        stop('Wrong commodity "', tech@name, '": "', i, '"')
      }
    }
    # Not group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, "cinp2use"]))) {
      if (!is.na(ctype[i, "group"])) {
        stop('Wrong commodity "', tech@name, '": "', i, '"')
      }
    }
    # Input ?
    if (any(!is.na(tech@ceff[
      tech@ceff$comm == i,

      c("cinp2use", "cinp2ginp")
    ]))) {
      if (ctype[i, "type"] != "input") {
        stop('Wrong commodity "', tech@name, '": "', i, '"')
      }
    }
    # Output ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c(
      "use2cact", "cact2cout" # , "afc.lo", "afc.up", "afc.fx"
    )]))) {
      if (ctype[i, "type"] != "output") {
        stop('Wrong commodity "', tech@name, '": "', i, '"')
      }
    }
    # Aux ?
    if (any(!is.na(tech@aeff[tech@aeff$acomm == i, c(
      "act2ainp", "act2aout",
      "cap2ainp", "cap2aout", "ncap2ainp", "ncap2aout"
    )])) ||
      any(!is.na(tech@aeff[tech@aeff$acomm == i, c(
        "cinp2ainp",
        "cinp2aout", "cout2ainp", "cout2aout"
      )]))) {
      if (ctype[i, "type"] != "aux") {
        stop('Wrong commodity "', tech@name, '": "', i, '"')
      }
    }
  }
  for (i in acomm) {
    aux[i, "input"] <- (any(!is.na(
      tech@aeff[tech@aeff$acomm == i, c("act2ainp", "cap2ainp", "ncap2ainp")]
    )) ||
      any(!is.na(tech@aeff[tech@aeff$acomm == i, c("cinp2ainp", "cout2ainp")])))
    aux[i, "output"] <- (any(!is.na(
      tech@aeff[tech@aeff$acomm == i, c("act2aout", "cap2aout", "ncap2aout")]
    )) ||
      any(!is.na(tech@aeff[tech@aeff$acomm == i, c("cinp2aout", "cout2aout")])))
  }
  gtype <- data.frame(
    type = factor(NULL, c("input", "output")),
    stringsAsFactors = FALSE
  )

  # Define type group
  group <- unique(c(
    tech@geff$group, tech@geff$geff,
    tech@group$group, tech@group$geff,
    tech@input$group, tech@output$group
  ))
  group <- group[!is.na(group)]
  if (length(group) != 0) {
    if (any(is.na(c(tech@group$group, tech@group$geff)))) {
      stop('There is NA group in technology "', tech@name, '"')
    }
    gtype[seq(along = group), ] <- NA
    rownames(gtype) <- group
    for (i in unique(tech@geff$group)) {
      if (any(!is.na(tech@geff[tech@geff$group == i, "ginp2use"]))) {
        if (!is.na(gtype[i, "type"]) && gtype[i, "type"] == "output") {
          stop('Wrong group in technology "', tech@name, '": "', i, '"')
        }
        gtype[i, "type"] <- "input"
      }
    }
    for (i in group) {
      jj <- rownames(ctype)[!is.na(ctype$group) & ctype$group == i]
      if (length(jj) != 0) {
        if (any(ctype[jj, "type"] == "input")) {
          if (!is.na(gtype[i, "type"]) && gtype[i, "type"] == "output") {
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
          }
          gtype[i, "type"] <- "input"
        }
        if (any(ctype[jj, "type"] == "output")) {
          if (!is.na(gtype[i, "type"]) && gtype[i, "type"] == "input") {
            stop('Wrong group in technology "', tech@name, '": "', i, '"')
          }
          gtype[i, "type"] <- "output"
        }
      }
    }
    if (any(is.na(gtype[, "type"]))) {
      stop(
        'Wrong group in technology "', tech@name, '": "',
        paste(rownames(gtype)[is.na(gtype[, "type"])], collapse = '", "'), '"'
      )
    }
  }
  fcmd <- c(tech@ceff$comm, tech@aeff$comm[!is.na(tech@aeff$comm)], tech@aeff$acomm)
  fcmd <- fcmd[!(fcmd %in% c(tech@input$comm, tech@output$comm, tech@aux$acomm))]
  if (length(fcmd) != 0) {
    stop(
      'Unknow commodity in technology (there is not definition in input, output or aux) "',
      tech@name, '": ', paste(fcmd, collapse = '", "'), '"'
    )
  }
  list(comm = ctype, group = gtype, aux = aux)
}
