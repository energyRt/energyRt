\name{approximation-rule}
\alias{approximation-rule}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Main rule approximation
}
\description{
  \describe{
    \item{UP, LO, FX}{Command FX use like two seprate command UP and LO, with the
      same parameter.}
    \item{Year and Season}{if you want set parameter for all Year, you
      need set NA. The same procedure for Season. if there is parameter
      with and without NA, in first use parameter with NA, and after than without
      NA. if there is parameter with Year == NA and another parameter
      with Season == NA, than create error, but not only if it's one the
      same parameter.}
    \item{Rule}{Rule of approximation set for evry class in
      "interpolation" slot. The "default is back.intra.forth". This is
      three different flag  "back", "intra", "forth". All approximation
      is linear.}
   }
}
