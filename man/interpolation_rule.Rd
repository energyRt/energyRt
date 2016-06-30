\name{interpolation_rule}
\alias{interpolation_rule}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  %%  ~~function to do ... ~~
  interpolation_rule
}
\description{
  %%  ~~ A concise (1-5 lines) description of what the function does. ~~
  return parameter interpolation for slot class technology
  possible flag "back" | "intra" | "forth"
  (e.g. back.intra or back.intra.forth)
}
\usage{
interpolation_rule(tech, reg = NA, param, default = "none")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{tech}{
    %%     ~~Describe \code{tech} here~~
    class technology
}
  \item{reg}{
    %%     ~~Describe \code{reg} here~~
    region of interpolation
}
  \item{param}{
    %%     ~~Describe \code{param} here~~
    parameter for interpolation (not check)
}
  \item{default}{
    %%     ~~Describe \code{default} here~~
    return if there is no approximation default
}
}