% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-repository.R, R/class-model.R
\name{add,repository-method}
\alias{add,repository-method}
\alias{add,model-method}
\title{Add an object to the model's repository}
\usage{
\S4method{add}{repository}(obj, ..., overwrite = FALSE)

\S4method{add}{model}(obj, ..., overwrite = FALSE, repo_name = NULL)
}
\arguments{
\item{obj}{model object}

\item{...}{model elements, allowed classes: ...}

\item{overwrite}{logical, if TRUE, objects with the same name will be overwritten, error will be reported if FALSE}

\item{repo_name}{character, optional name of a (sub-)repository to add the object.}
}
\value{
model object with added elements to the repository
}
\description{
Add an object to the model's repository
}
\concept{repository}
