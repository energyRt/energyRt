\name{plot.technology}
\alias{plot.technology}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  plot.technology
%%  ~~function to do ... ~~
}
\description{
  function for plot class technology, attention more than one plot
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.technology(x, xlab = "", ylab = "", lwd = 2, lty = 1, years = range(get_set(x, "year")), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
    %%     ~~Describe \code{x} here~~
    class technology
}
\item{years}{
  years for interpoltion
%%     ~~Describe \code{years} here~~
}
  \item{\dots}{
    %%     ~~Describe \code{\dots} here~~
    default graphical parameter  \code{\link{plot.default}}
}
}
