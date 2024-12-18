% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-weather.R
\docType{class}
\name{class-weather}
\alias{class-weather}
\title{S4 class to represent weather factors}
\description{
\code{weather} is a data-carrying class with exogenous shocks
used to influence operation of processes in the model.
}
\details{
Weather factors are separated from the model parameters
and can be added or replaced for different scenarios.
!!!Additional details...
}
\section{Slots}{

\describe{
\item{\code{name}}{character. Name of the weather factor, used in sets.}

\item{\code{desc}}{character. Description of the weather factor.}

\item{\code{unit}}{character. Unit of the weather factor.}

\item{\code{region}}{character. Region where the weather factor is applied.}

\item{\code{timeframe}}{character. Timeframe of the weather factor.}

\item{\code{defVal}}{numeric. Default value of the weather factor, 0 by default.}

\item{\code{weather}}{data.frame. Weather factor values.
\describe{
\item{region}{character. Region name to apply the parameter, NA for every region.}
\item{year}{integer. Year to apply the parameter, NA for every year.}
\item{slice}{character. Time slice to apply the parameter, NA for every slice.}
\item{wval}{numeric. Weather factor value.}
}}

\item{\code{misc}}{list. Additional information.}
}}

\concept{class weather data}
