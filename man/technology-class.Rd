\name{technology-class}
\Rdversion{1.1}
\docType{class}
\alias{technology-class}

\title{Class \code{"technology"}}
\description{
%%  ~~ A concise (1-5 lines) description of what the class is. ~~
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("technology", ...)}.
%%  ~~ describe objects here ~~ 
}
\section{Slots}{
  \describe{
    \item{\code{name}:}{Object of class \code{"character"} -- short name }
    \item{\code{type}:}{Object of class \code{"character"} -- type of technology }
    \item{\code{description}:}{Object of class \code{"character"} -- description }
    \item{\code{region}:}{Object of class \code{"character"} -- region }
    \item{\code{color}:}{Object of class \code{"data.frame"} --  }
    \item{\code{commodity_in}:}{Object of class \code{"data.frame"} -- mostly description,
      \emph{see shares and efficiency}
      \describe{
	\item{\code{comm}}{character : commodity name}
	\item{\code{unit}}{character : unit }
	\item{\code{aux}}{logical    : is auxilary (just flag)}
	\item{\code{group}}{integer  : for calculate share}}}
    \item{\code{commodity_out}:}{Object of class \code{"data.frame"} -- mostly description,
      \emph{see shares and efficiency}
      \describe{
	\item{\code{comm}}{character : commodity name}
	\item{\code{unit}}{character : unit }
	\item{\code{aux}}{logical    : is auxilary (just flag)}
	\item{\code{group}}{integer  : for calculate share}
        \item{\code{capacity}}{character : ???}}}
    \item{\code{units}:}{Object of class \code{"data.frame"}(nrow less one) -- unit for non-commodity parameter 
    \code{capacity}, \code{activity}, \code{varom}, \code{fixom}, \code{invcost}}
    \item{\code{cap2act}:}{Object of class \code{"numeric"} -- capacity to activity parameter, by default 1}
    \item{\code{shares}:}{Object of class \code{"data.frame"} -- technological parameter
      \describe{
	\item{\code{comm}}{character   : commodity name}
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{inp2act}}{numeric  : consumption from one unit of activity, only for group equal zero }
	\item{\code{inp2cap}}{numeric  : consumption from one unit of capacity (e.g. for support purpose),
	  only for group equal zero}
	\item{\code{out2act}}{numeric  : output from one unit of activity, only for group equal zero }
	\item{\code{out2cap}}{numeric  : output from one unit of capacity, only for group equal zero }
	\item{\code{share.up}}{numeric : maximum share of commodity from group, only for group greter zero
	  \emph{see share rule}}
	\item{\code{share.fx}}{numeric : fixing share of commodity from group, only for group greter zero
	  \emph{see share rule}}
	\item{\code{share.lo}}{numeric : minimum share of commodity from group, only for group greter zero
	  \emph{see share rule}}
	\item{\code{ceff}}{numeric     : commodity efficiency, only for group greter zero}
	\item{\code{actflo}}{numeric     : ???}}}
    \item{\code{efficiency}:}{Object of class \code{"data.frame"} -- efficiency for group,
      only for group greter zero
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{eff}}{numeric      : group efficiency}
	\item{\code{group}}{numeric    : greter zero}}}    
    \item{\code{availability}:}{Object of class \code{"data.frame"} -- availability factor,
      \emph{see availability rule}
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{af.up}}{numeric    : maximum availability factor }
	\item{\code{af.fx}}{numeric    : fix availability factor }
	\item{\code{af.lo}}{numeric    : minimum availability factor }}}    
    \item{\code{ceh}:}{Object of class \code{"data.frame"} -- CEH
      only for CHP station
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{ceh}}{numeric}}}    
    \item{\code{chpr}:}{Object of class \code{"data.frame"} -- coefficient Heat to Power ratio
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{chpr.up}}{numeric    : maximum chpr}
	\item{\code{chpr.fx}}{numeric    : fix chpr}
	\item{\code{chpr.lo}}{numeric    : minimum  chpr}}}    
    \item{\code{fixom}:}{Object of class \code{"data.frame"} -- FIX O & M cost (by capacity)
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{fixom}}{numeric    : FIX O & M cost (by capacity)}}}    
    \item{\code{varom}:}{Object of class \code{"data.frame"} -- Variable O & M cost (by activity)
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{varom}}{numeric    : Variable O & M cost (by activity)}}}  
    \item{\code{invcost}:}{Object of class \code{"data.frame"} -- Invest cost (by new capacity)
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{invcost}}{numeric    : Invest cost (by new capacity)}}}  
    \item{\code{start}:}{Object of class \code{"data.frame"} -- Start year 
      \describe{
	\item{\code{region}}{character}
	\item{\code{start}}{numeric : start year}}}
    \item{\code{end}:}{Object of class \code{"data.frame"} -- End year 
      \describe{
	\item{\code{region}}{character}
	\item{\code{end}}{numeric : end year}}}
    \item{\code{operation_life}:}{Object of class \code{"data.frame"} -- Operational life year
      (time for pay investition cost) 
      \describe{
	\item{\code{region}}{character}
	\item{\code{olife}}{numeric : Operational life year}}}
    \item{\code{residual_capacity}:}{Object of class \code{"data.frame"} -- residual capacity
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{stock}}{numeric}}}
    \item{\code{residual_life}:}{Object of class \code{"data.frame"} -- residual life for initial stock
      \describe{
	\item{\code{region}}{character}
	\item{\code{rlife}}{numeric : residual life}}}
    \item{\code{activity_bound}:}{Object of class \code{"data.frame"} -- activity bound constraint,
      \emph{see activity bound constraint rule}
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{slice}}{character  : time slice e.g. ANNUAL, WD, WN ...}
	\item{\code{act.up}}{numeric    : maximum activity}
	\item{\code{act.fx}}{numeric    : fix activity}
	\item{\code{act.lo}}{numeric    : minimum activity}}} 
    \item{\code{cumulative_reserve}:}{Object of class \code{"data.frame"} -- cumulative reserve
      for storage technology
      \describe{
	\item{\code{region}}{character}
	\item{\code{year}}{numeric}
	\item{\code{cum}}{numeric : cumulative reserve}}}
    \item{\code{reporting_years}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{interpolation}:}{Object of class \code{"data.frame"} ~~ }
    \item{\code{default_value}:}{Object of class \code{"data.frame"} ~~ }
    \item{\code{par}:}{Object of class \code{"array"} ~~ }
    \item{\code{.S3Class}:}{Object of class \code{"character"} ~~ }
  }
}
\section{Methods}{
No methods defined with class "technology" in the signature.
}
\references{
%%  ~~put references to the literature/web site here~~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%%  ~~objects to See Also as \code{\link{~~fun~~}}, ~~~
%%  ~~or \code{\linkS4class{CLASSNAME}} for links to other classes ~~~
}
\examples{
showClass("technology")
}
\keyword{classes}
