#' An S4 class to represent technology
#'
#' @slot name character.
#' @slot description character.
#' @slot input data.frame.
#' @slot output data.frame.
#' @slot aux data.frame.
#' @slot units data.frame.
#' @slot group data.frame.
#' @slot cap2act numeric.
#' @slot geff data.frame.
#' @slot ceff data.frame.
#' @slot aeff data.frame.
#' @slot af data.frame.
#' @slot afs data.frame.
#' @slot weather data.frame.
#' @slot fixom data.frame.
#' @slot varom data.frame.
#' @slot invcost data.frame.
#' @slot start data.frame.
#' @slot end data.frame.
#' @slot olife data.frame.
#' @slot stock data.frame.
#' @slot earlyRetirement logical.
#' @slot upgrade.technology character.
#' @slot fullYear logical.
#' @slot slice character.
#' @slot region character.
#' @slot misc list.
#'
#' @include class-supply.R
#'
#' @return
#' @export
#'
setClass("technology",
  representation(
    # General information
    name = "character", # Short name
    description = "character", # description
    input = "data.frame", #
    output = "data.frame", #
    aux = "data.frame", #
    units = "data.frame", #
    group = "data.frame", # groups units
    cap2act = "numeric", #
    # Performance parameters
    geff = "data.frame", #  Group efficiency
    ceff = "data.frame", #  Commodity efficiency
    aeff = "data.frame", #  Commodity efficiency
    af = "data.frame", #
    afs = "data.frame", #
    weather = "data.frame", # weather condisions multiplier
    # Costs
    fixom = "data.frame", #
    varom = "data.frame", #
    invcost = "data.frame", #
    # Market
    start = "data.frame", #
    end = "data.frame", #
    olife = "data.frame", #
    stock = "data.frame", #
    earlyRetirement = "logical",
    upgrade.technology = "character",
    fullYear = "logical",
    slice = "character",
    region = "character",
    misc = "list"
  ), #
  # Default values and structure of slots
  prototype(
    name = "",
    description = "",
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
      description = character(),
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
      # no groups
      cinp2use = numeric(),
      use2cact = numeric(),
      cact2cout = numeric(),
      cinp2ginp = numeric(),
      # shares within groups
      share.lo = numeric(),
      share.up = numeric(),
      share.fx = numeric(),
      # afc
      afc.lo = numeric(),
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
      stringsAsFactors = FALSE
    ),
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
      olife = numeric(),
      stringsAsFactors = FALSE
    ),
    stock = data.frame(
      region = character(),
      year = integer(),
      stock = numeric(),
      stringsAsFactors = FALSE
    ),
    earlyRetirement = TRUE,
    upgrade.technology = character(),
    region = character(),
    slice = character(),
    misc = list()
  ),
  # validity = .check_technology_data_frame,
  S3methods = TRUE
)

setMethod("initialize", "technology", function(.Object, ...) {
  .Object
})

#' Create object of class `technology` with specified parameters.
#'
#' @param name
#' @param description
#' @param input
#' @param output
#' @param group
#' @param cap2act
#' @param geff
#' @param ceff
#' @param aeff
#' @param af
#' @param afs
#' @param weather
#' @param stock
#' @param invcost
#' @param fixom
#' @param varom
#' @param olife
#' @param region
#' @param start
#' @param end
#' @param slice
#' @param fullYear
#' @param earlyRetirement
#' @param upgrade.technology
#' @param misc
#'
#' @return
#' @export
#'
#' @examples
newTechnology <- function(
    name = "",
    description = "",
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
    stock = data.frame(),
    invcost = data.frame(),
    fixom = data.frame(),
    varom = data.frame(),
    olife = data.frame(),
    region = character(),
    start = data.frame(),
    end = data.frame(),
    slice = character(),
    fullYear = TRUE,
    earlyRetirement = FALSE,
    upgrade.technology = character(),
    misc = list()) {
  # browser()
  .data2slots("technology", name,
    description = description,
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
    stock = stock,
    invcost = invcost,
    fixom = fixom,
    varom = varom,
    olife = olife,
    region = region,
    start = start,
    end = end,
    slice = slice,
    fullYear = fullYear,
    earlyRetirement = earlyRetirement,
    upgrade.technology = upgrade.technology,
    misc = misc
  )
}

update.technology <- function(obj, ...) .data2slots("technology", obj, ...)

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
      if (is.na(ctype[i, "group"]))
        stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Not group ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, "cinp2use"]))) {
      if (!is.na(ctype[i, "group"]))
        stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Input ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c("cinp2use", "cinp2ginp")]))) {
      if (ctype[i, "type"] != "input")
        stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
    # Output ?
    if (any(!is.na(tech@ceff[tech@ceff$comm == i, c(
      "use2cact", "cact2cout" # , "afc.lo", "afc.up", "afc.fx"
    )]))) {
      if (ctype[i, "type"] != "output")
        stop('Wrong commodity "', tech@name, '": "', i, '"')
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
      if (ctype[i, "type"] != "aux")
        stop('Wrong commodity "', tech@name, '": "', i, '"')
    }
  }
  for (i in acomm) {
    aux[i, "input"] <- (any(!is.na(
      tech@aeff[tech@aeff$acomm == i, c("act2ainp", "cap2ainp", "ncap2ainp")])) ||
      any(!is.na(tech@aeff[tech@aeff$acomm == i, c("cinp2ainp", "cout2ainp")])))
    aux[i, "output"] <- (any(!is.na(
      tech@aeff[tech@aeff$acomm == i, c("act2aout", "cap2aout", "ncap2aout")])) ||
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
