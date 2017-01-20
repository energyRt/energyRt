### Welcome to energyRt pages

**energyRt** is a package for [R](https://www.r-project.org/) to develop Reference Energy System (RES) models and analyze energy-technologies.

**energyRt** package includes a standard RES (or "Bottom-Up") linear, cost-minimizing model, which can be solved by [GAMS](http://www.gams.com/) or [GLPK](https://www.gnu.org/software/glpk/). The model has similarities with [TIMES/MARKAL](http://iea-etsap.org/web/tools.asp), [OSeMOSYS](http://www.osemosys.org/), but has its own specifics, f.i. definition of technologies. 

**energyRt** package is a set of _classes_, _methods_, and _functions_ in [R](https://www.r-project.org/) which are designed to:  
- handle data, assist in defining RES models,  
- helps to analyze data, check for errors and bugs before parsing it into solver,  
- parses your dataset to GAMS or GLPK and run them to solve the model,  
- reads solution and imports results back to R,  
- assists in analysis of results and reporting. 

### Motivation

- minimize time of development and application of RES/BottomUp models,
- boost learning curve in energy modeling, 
- improve transparency and understanding of energy models,
- use power of open-source to improve energy models and their application,
- making reproducible research (see [Reproducible Research with R and R Studio] (https://github.com/christophergandrud/Rep-Res-Book) by @christophergandrud and/or [Dynamic Documents with R and knitr] (https://github.com/yihui/knitr-book) by @yihui) accessible in RES-modeling,
- integration with other models and software.

### Development status

The project is in an active development phase. Current functionality allows to develop basic RES models. Some features (incl. regions, storage technologies) and documentation are in development. Testing for bugs.

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
