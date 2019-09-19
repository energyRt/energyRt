### energyRt: Making Energy Systems modeling as simple as a linear regression in R

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

The project has the first *beta* release, which includes *Utopia* model examples, solvable with *GAMS* or *GLPK*. Main functions have been documented, the extended tutorial is in process. By now, the functionaligy of the package allows developing multi-region models with hierarhical time-slices, exogenous and endogenous trade routes, and flexible technologies. Several large-scale projects are on the way, including "CHN_ELC_PRO" (China Electric Power Sector province level) and "usensys" (US energy system model). A visualization of some scenarios is available here:  
 - [usensys](https://github.com/olugovoy/usensys)   
 - [usensys-youtube](https://www.youtube.com/channel/UCw4fCrRTozmAqwHY63oLT2A)   
 - [CHN_ELC_PRO](https://www.youtube.com/channel/UC27Gbh61fGX4-WrGi6jd_og).  
...

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
