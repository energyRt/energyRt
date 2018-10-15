### Welcome to energyRt pages

**energyRt** is a package for [R](https://www.r-project.org/) to develop Reference Energy System (RES) models and analyze energy-technologies.

**energyRt** package provides tools to build RES ("Bottom-Up"), technological, linear cost-minimizing models, which can be solved using [GAMS](http://www.gams.com/) and [GLPK](https://www.gnu.org/software/glpk/). The RES model has similarities with [TIMES/MARKAL](http://iea-etsap.org/web/tools.asp), [OSeMOSYS](http://www.osemosys.org/), but has its own specifics, f.i. definition of technologies. 

**energyRt** package is a set of _classes_, _methods_, and _functions_ in [R](https://www.r-project.org/) which are designed to:  
- handle data, assist in defining RES models,  
- helps to analyze data, check for errors and bugs before parsing it into solver,  
- parses your dataset to GAMS or GLPK and runs them to solve the model,  
- reads the solution and imports results back to R,  
- assists with an analysis of results and reporting. 

### Motivation

- minimize time of development and application of RES/BottomUp models,
- boost learning curve in energy modeling, 
- improve transparency and understanding of energy models,
- use power of open-source to improve energy models and their application,
- making reproducible research (see [Reproducible Research with R and R Studio] (https://github.com/christophergandrud/Rep-Res-Book) by @christophergandrud and/or [Dynamic Documents with R and knitr] (https://github.com/yihui/knitr-book) by @yihui) accessible in RES-modeling,
- integration with other models and software.

### Development status

The project is in an preparation of the first official release, which includes the documentation and a set of examples (expected - Nov 2018). Current functionality allows development of multi-regional RES models with trade, time-slices, and variety of technologies, an integration with GIS (via _sp_ and _choropleth_ packages), pivot tables (via _rPivotTable_), authomatic pdf-reports for models and scenarios, analysis of levelized costs of tehcnologies, and other features.

### Authors and Contributors
The package is designed by Oleg Lugovoy (@olugovoy) and Vladimir Potashnikov (@vpotashnikov).

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-5046584-25', 'auto');
  ga('send', 'pageview');

</script>
