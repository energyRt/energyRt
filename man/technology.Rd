% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-technology.R
\name{newTechnology}
\alias{newTechnology}
\alias{update,technology-method}
\title{Create a new "technology" object.}
\usage{
newTechnology(
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
  misc = list(),
  ...
)

\S4method{update}{technology}(object, ...)
}
\arguments{
\item{name}{character. Name of the technology, used in sets.}

\item{desc}{character. Optional description of the technology for reference.}

\item{input}{data.frame. Main commodities input. Main commodities are linked to the process capacity and activity. Their parameters are defined in the \code{ceff} slot.
\describe{
\item{comm}{character. Name of the input commodity.}
\item{unit}{character. Unit of the input commodity.}
\item{group}{character. Name of input-commodities-group.}
\item{combustion}{numeric. combustion factor from 0 to 1 (default 1) to calculate emissions from fuels combustion (commodities intermediate consumption, more broadly)
}
}}

\item{output}{data.frame. Main commodities output. Main commodities are linked to the process capacity and activity. Their parameters are defined in the \code{ceff} slot.
\describe{
\item{comm}{character. Name of the output commodity.}
\item{unit}{character. Unit of the output commodity.}
\item{group}{character. Name of output-commodities-group.}
}}

\item{group}{data.frame. Details for commodity groups if defined in input and output slots (for reference).
\describe{
\item{group}{character. Name of the group. Must match the group names in the input and output slots.}
\item{desc}{character. Description of the group.}
\item{unit}{character. Unit of the group.}
}}

\item{aux}{data.frame. Auxilary commodities, both input and output, their parameters are defined in the \code{aeff} slot.
\describe{
\item{acomm}{character. Name of the auxilary commodity.}
\item{unit}{character. Unit of the auxilary commodity.}
}}

\item{units}{data.frame. Key units of the process activity and capacity (for reference).
\describe{
\item{capacity}{character. Unit of capacity}
\item{use}{character. Unit of 'use' (grouped input) if applicable.}
\item{activity}{character. Unit of activity variable of the technology.}
\item{costs}{character. Currency of costs variable of the technology.}
}}

\item{cap2act}{numeric. Capacity to activity ratio. Default is 1. Specifies how much product (activity, or output commodity if identical) will be produced per unit of capacity.}

\item{geff}{data.frame. Input-commodity-group efficiency parameters.
\describe{
\item{region}{character. Name of region to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of slice to apply the parameter, NA for every slice.}
\item{group}{character. Name of group to apply the parameter. Required, must match the group names in the input and output slots.}
\item{ginp2use}{numeric. Group-input-to-use coefficient, default is 1.}
}}

\item{ceff}{data.frame. Main commodity and activity efficiency parameters.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of slice to apply the parameter, NA for every slice.}
\item{comm}{character. Name of commodity to apply the parameter, different parameters require specification either input or output commodity.}
\item{cinp2use}{numeric. Commodity-input-to-use coefficient, default is 1.}
\item{use2cact}{numeric. Use-to-commodity-activity coefficient, default is 1.}
\item{cact2cout}{numeric. Commodity-activity-to-commodity-output coefficient, default is 1.}
\item{cinp2ginp}{numeric. Commodity-input-to-group-input coefficient, default is 1.}
\item{share.lo}{numeric. Lower bound on a share of commodity within a group, default is 0.}
\item{share.up}{numeric. Upper bound on a share of commodity within a group, default is 1.}
\item{share.fx}{numeric. Fixed share of commodity within a group, ignored if NA. This parameter overrides \code{share.lo} and \code{share.up}.}
\item{afc.lo}{numeric. Lower bound on the physical value of the commodity, ignored if NA.}
\item{afc.up}{numeric. Upper bound on the physical value of the commodity, ignored if NA.}
\item{afc.fx}{numeric. Fixed physical value of the commodity, ignored if NA. This parameter overrides \code{afc.lo} and \code{afc.up}.}
}}

\item{aeff}{data.frame. Parameters linking main commodities, activities, and capacities to auxiliary commodities.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of slice to apply the parameter, NA for every slice.}
\item{acomm}{character. Name of auxilary commodity to apply the parameter.}
\item{cinp2ainp}{numeric. Main-commodity-input-to-auxilary-commodity-input coefficient, ignored if NA.}
\item{cinp2aout}{numeric. Main-commodity-input-to-auxilary-commodity-output coefficient, ignored if NA.}
\item{cout2ainp}{numeric. Main-commodity-output-to-auxilary-commodity-input coefficient, ignored if NA.}
\item{cout2aout}{numeric. Main-commodity-output-to-auxilary-commodity-output coefficient, ignored if NA.}
\item{act2ainp}{numeric. Technology-activity-to-auxilary-commodity-input coefficient, ignored if NA.}
\item{act2aout}{numeric. Technology-activity-to-auxilary-commodity-output coefficient, ignored if NA.}
\item{cap2ainp}{numeric. Technology-capacity-to-auxilary-commodity-input coefficient, ignored if NA.}
\item{cap2aout}{numeric. Technology-capacity-to-auxilary-commodity-output coefficient, ignored if NA.}
\item{ncap2ainp}{numeric. Technology-new-capacity-to-auxilary-commodity-input-coefficient, ignored if NA.}
\item{ncap2aout}{numeric. Technology-new-capacity-to-auxilary-commodity-output coefficient, ignored if NA.}
}}

\item{af}{data.frame. Timeslice-level availability factor parameters.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of slice to apply the parameter, NA for every slice.}
\item{af.lo}{numeric. Lower bound on the availability factor, default is 0.}
\item{af.up}{numeric. Upper bound on the availability factor, default is 1.}
\item{af.fx}{numeric. Fixed availability factor, ignored if NA. This parameter overrides \code{af.lo} and \code{af.up}.}
\item{rampup}{numeric. Ramping-up time constraint RHS value, ignored if NA. Depends on the technology timeframe.}
\item{rampdown}{numeric. Ramping-down time constraint RHS value, ignored if NA. Depends on the technology timeframe.}
}}

\item{afs}{data.frame. Timeframe-level availability factor constraints.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of slice to apply the parameter, required.}
\item{afs.lo}{numeric. Lower bound on the availability factor for the timeframe, default is 0.}
\item{afs.up}{numeric. Upper bound on the availability factor for the timeframe, default is 1.}
\item{afs.fx}{numeric. Fixed availability factor for the timeframe, ignored if NA. This parameter overrides \code{afs.lo} and \code{afs.up}.}
}}

\item{weather}{data.frame. Parameters linking \verb{weather factors} (external shocks specified by \code{weather} class) to the availability parameters \code{af}, \code{afs}, and \code{afc}.
\describe{
\item{weather}{character. Name of the applied weather factor, required, must match the weather factor names in a \code{weather} class in the model.}
\item{comm}{character. Name of the commodity with specified \verb{afc.*} to be affected by the weather factor, required if \verb{afc.*} parameters are specified.}
\item{wafc.lo}{numeric. Multiplying coefficient to the lower bound on the commodity availability parameter \code{afc.lo}, ignored if NA.}
\item{wafc.up}{numeric. Multiplying coefficient to the upper bound on the commodity availability parameter \code{afc.up}, ignored if NA.}
\item{wafc.fx}{numeric. Multiplying coefficient to the fixed value of the commodity availability parameter \code{afc.fx}, ignored if NA. This parameter overrides \code{wafc.lo} and \code{wafc.up}.}
\item{waf.lo}{numeric. Multiplying coefficient to the lower bound on the availability factor parameter \code{af.lo}, ignored if NA.}
\item{waf.up}{numeric. Multiplying coefficient to the upper bound on the availability factor parameter \code{af.up}, ignored if NA.}
\item{waf.fx}{numeric. Multiplying coefficient to the fixed value on the availability factor parameter \code{af.fx}, ignored if NA. This parameter overrides \code{waf.lo} and \code{waf.up}.}
\item{wafs.up}{numeric. Multiplying coefficient to the upper bound on the availability factor parameter \code{afs.up}, ignored if NA.}
\item{wafs.lo}{numeric. Multiplying coefficient to the lower bound on the availability factor parameter \code{afs.lo}, ignored if NA.}
\item{wafs.fx}{numeric. Multiplying coefficient to the fixed value on the availability factor parameter \code{afs.fx}, ignored if NA. This parameter overrides \code{wafs.lo} and \code{wafs.up}.}
}}

\item{capacity}{data.frame. Capacity of the installed technology (in units of capacity).
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, required, values between specified years will be interpolated.}
\item{stock}{numeric. Predefined capacity of the technology in units of capacity, default is 0. This parameter also defines the exogenous capacity retirement (age-based), or exogenous capacity additions, not optimized by the model, and not included in investment costs.
}
\item{cap.lo}{numeric. Lower bound on the total capacity (preexisting stock and new installations), ignored if NA.}
\item{cap.up}{numeric. Upper bound on the total capacity (preexisting stock and new installations), ignored if NA.}
\item{cap.fx}{numeric. Fixed total capacity (preexisting stock and new installations), ignored if NA. This parameter overrides \code{cap.lo} and \code{cap.up}.}
\item{ncap.lo}{numeric. Lower bound on the new capacity (new installations), ignored if NA.}
\item{ncap.up}{numeric. Upper bound on the new capacity (new installations), ignored if NA.}
\item{ncap.fx}{numeric. Fixed new capacity (new installations), ignored if NA. This parameter overrides \code{ncap.lo} and \code{ncap.up}.}
\item{ret.lo}{numeric. Lower bound on the capacity retirement (age-based), ignored if NA.}
\item{ret.up}{numeric. Upper bound on the capacity retirement (age-based), ignored if NA.}
\item{ret.fx}{numeric. Fixed capacity retirement (age-based), ignored if NA. This parameter overrides \code{ret.lo} and \code{ret.up}.}
}}

\item{invcost}{data.frame. Total overnight investment costs of the project (per unit of capacity).
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{invcost}{numeric. Total overnight investment costs of the project (per unit of capacity), default is 0.}
\item{wacc}{numeric. Weighted average cost of capital, (currently ignored).}
}}

\item{fixom}{data.frame. Fixed operational and maintenance cost (per unit of capacity a year).
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{fixom}{numeric. Fixed operational and maintenance cost, default is 0.}
}}

\item{varom}{data.frame. Variable operational and maintenance cost (per unit of activity or commodity).
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Name of the time-slice or (grand-)parent timeframe to apply the parameter, NA for every time-slice of the technology timeframe.}
\item{varom}{numeric. Variable operational and maintenance cost per unit of activity, default is 0.}
\item{comm}{character. Name of the commodity for which the parameter will be applied, required for \code{cvarom} parameter.}
\item{cvarom}{numeric. Variable operational and maintenance cost per unit of commodity, default is 0.}
\item{acomm}{character. Name of the auxilary commodity for which the \code{avarom} will be applied, required for \code{avarom} parameter.}
\item{avarom}{numeric. Variable operational and maintenance cost per unit of auxilary commodity, default is 0.}
}}

\item{olife}{data.frame. Operational life of the installed technology (in years).
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{olife}{integer. Operational life of the technology if installed during optimization, in years, default is 1.}
}}

\item{region}{character. Vector of regions where the technology exists or can be installed. Optional. If not specified, the technology is applied to all regions. If specified, must include all regions used in other slots.}

\item{start}{data.frame. The first year the technology can be installed.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{start}{integer. The first year the technology can be installed, NA means all years of the modeled horizon.}
}}

\item{end}{data.frame. The last year the technology can be installed.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{end}{integer. The last year the technology can be installed, default is Inf.}
}}

\item{timeframe}{character. Name of timeframe level the technology is operating. By default, the lowest level of timeframe of commodities used in the technology is applied.}

\item{fullYear}{logical. Incidates if the technology is operating on a full-year basis. Used in storages. currently ignored for technologies.}

\item{optimizeRetirement}{logical. Incidates if the retirement of the technology should be optimized. Also requires the same parameter in the \code{model} or \code{scenario} class to be set to TRUE to be effective.}

\item{misc}{list. List of additional parameters that are not used in the model but can be used for reference or user-defined functions. For example, links to the source of the technology data, or other metadata.}

\item{...}{slot-names with data to update (see \code{newTechnology})}

\item{object}{object of class technology}
}
\value{
An object of class technology.
}
\description{
This function initializes and returns an S4 object of class \code{technology},
representing a specific technology with given attributes.
The function has the same arguments as slot-names in the \code{technology} class.
Every argument has a specific format as described below and in the class
documentation.
}
\examples{
ECOAL <- newTechnology(
  name = "ECOAL", # name, used in sets, no white spaces or special characters
  desc = "Generic coal power plant", # any description of the technology
  input = data.frame(
    comm = "COAL", # name of input commodity
    unit = "MMBtu", # unit of the input commodity
    # combustion factor from 0 to 1 (default 1) to calculate emissions
    # from fuels combustion (commodities intermediate consumption, more broadly)
    combustion = 1
  ),
  output = data.frame(
    comm = "ELC", # name of output commodity
    unit = "MWh" # unit of the output commodity
  ),
  aux = data.frame(
    acomm = c("NOx", "SO2", "Hg"), # names of auxilary commodities
    unit = c("kg", "kg", "g") # units
  ),
  # Capacity to activity ration: 8760 MWh output a year per MW of capacity
  cap2act = 8760,
  ceff = data.frame( # efficiency parameters for the main commodities
    comm = "COAL",
    # efficiency, 1/10 MWh per MMBtu, inverse heat rate
    # check: 1 / convert(10, "MMBtu", "MWh") ~= 34\% efficiency
    cinp2use = 1 / 10
  ),
  aeff = data.frame( # paramaters for the auxilary commodities
    acomm = c("NOx", "SO2", "Hg"),
    act2aout = c(0.1, 0.2, 0.3) # emission factors, linked to activity
  ),
  af = data.frame( # availability (capacity) factor by time slices
    af.up = 0.95 # maximum 95\% per hour
  ),
  afs = data.frame( # availability factor by timeframes
    slice = "ANNUAL", # annual availability factor
    afs.lo = 0.40, # at least 40\% per year
    afs.up = 0.85 # maximum 85\% per year
  ),
  fixom = data.frame( # fixed operational and maintenance cost
    region = c("R1", "R2", NA), # regions, NA - all other regions
    fixom = c(100, 200, 150) # MW a year
  ),
  varom = data.frame( # variable operational and maintenance cost
    region = c("R1", "R2"), # regions
    varom = c(1, 2) # $1 and $2 per MWh
  ),
  invcost = data.frame( # investment cost
    year = c(2020, 2030, 2040), # to differentiate by years
    invcost = c(1000, 900, 800) # $1000, $900, $800 per MW
  ),
  start = data.frame( # start year
    start = 2020 # can be installed from 2020
  ),
  end = data.frame( # end year
    end = 2040 # can be installed until 2040
  ),
  olife = data.frame( # operational life
    olife = 30 # years
  ),
  capacity = data.frame( # existing capacity
    year = c(2020, 2030, 2040), # to differentiate by years
    region = c("R1"), # exists only in R1
    stock = c(300, 200, 100) # age-based exogenous retirement
  ),
  # regions where the technology can be installed
  region = c("R1", "R2", "R5", "R7"),
)
draw(ECOAL)

}
\concept{technology process}
\concept{update technology process}
