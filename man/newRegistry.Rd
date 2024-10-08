% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/registry.R
\name{newRegistry}
\alias{newRegistry}
\title{Create a new registry object.}
\usage{
newRegistry(
  class = c("scenario", "model", "repository"),
  name = NULL,
  registry_env = ".GlobalEnv",
  store_env = ".scen"
)
}
\arguments{
\item{class}{character, type of the classes to be stored in the registry.}

\item{name}{character, name of the registry object.}

\item{registry_env}{character, environment to store the registry object.}

\item{store_env}{character, environment to store the objects.}
}
\description{
Create a new registry object.
}
