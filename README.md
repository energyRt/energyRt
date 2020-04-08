# energyRt: energy analysis toolbox in R

**energyRt** is a package for [R](https://www.r-project.org/) to develop Reference Energy System (RES) models (also known as Capacity Expansion Models (CEM), or "Bottom-Up" technological energy models), and analyze energy-technologies.

**energyRt** package provides tools to formulate the main "bricks" of an energy system model in **R**, and solve the model with one of the mainstream mathematical programming languages:  
* [GAMS](http://www.gams.com/),  
* [GLPK/Mathprog](https://www.gnu.org/software/glpk/),  
* [Python/Pyomo] (http://www.pyomo.org/),  
* [Julia/JuMP] (http://www.juliaopt.org/JuMP.jl/stable/).  

The RES/CEM model has similarities with [TIMES/MARKAL](http://iea-etsap.org/web/tools.asp), [OSeMOSYS](http://www.osemosys.org/), but has its own specifics, f.i. definition of technologies. 

**energyRt** package is a set of _classes_, _methods_, and _functions_ in [R](https://www.r-project.org/) which are designed to:  
- handle data, assist in defining RES models,  
- helps to analyze data, check for errors and bugs before parsing it into solver,  
- parses your dataset to GAMS or GLPK or Python/Pyomo or Julia/JuMP and runs them to solve the model,  
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

The current functionality allows development of multi-regional RES models from basic to well advanced level of complexity, including multiple regions, exogenous or endogenous interregional trade routes (for example, electricity grid), multilevel/nested time-slices, as well as flexible definition of technologies, storages. The package documentation is in development. By now, the best way to test the functionality of the package is to check fully functional examples of the model (see *Examples* bellow).  

## Installation

### Prerequisites
   
#### R and RStudio
Assuming that R is already installed (if not, please download and install from https://www.r-project.org/), we also recommend RStudio (https://www.rstudio.com/), a powerful IDE (Integrated Development Environment) for R. It simplifies usage of R, provides number of features such as reproducible research (integration with Markdown, Sweave), integration with  version control (github, svn).   

#### GAMS or GLPK or Python or Julia to solve the model   
The cost-minimising linear programming model (the set of equation for LP problem), emboddied into *energyRt* package requires additional software to solve it. Currently *energyRt* model code  is written in several languages *GAMS*, *GLPK*, *Python/Pyomo*, *Julia/Jump*. At least one of them is required to solve the model.

The General Algebraic Modeling System (*GAMS*, http://gams.com/) is a powerful proprietary modeling system. Suitable LP solvers: CBC (included in the basic GAMS version, very powerful open source solver) or CPLEX. Others LP solvers have not been tested, but may work as well.

GAMS path should be also added to the environmental variables in your operating system.  

*GLPK* is an open source Linear Programming Kit which includes powerful LP and MIP solver, and basic language for creating mathematical programming models (Mathprog or GMPL – for details see https://en.wikibooks.org/wiki/GLPK/GMPL_%28MathProg%29) 

GLPK/GMPL is an open source alternative to GAMS, but only for LP and MIP problems. GLPK/GMPL is a bit slower than GAMS for small models, and significantly slower for large models, partially because of the slower Mathprog (GMPL) language processor.  

##### Installing GLPK on PC/Windows systems   
Download GLPK binaries for Windows:
https://sourceforge.net/projects/winglpk/
Follow the installation instructions, and add the path to the Windows environment variables.   

##### Installing GLPK on Mac systems
We are not familiar if there are any GLPK-binaries/installers for Mac OSx. Therefore the following example is for installed from source with a standard procedure:
gzip -d glpk-4.57.tar.gz   
tar -x < glpk-4.57.tar   
cd glpk-4.57   
./configure   
make   
make check   
make install   
make distclean   
   
After installation check:    
which glpsol   
glpsol   
or glpsol -v   

Response from glpsol will be an indicator of successful installation.   

Alternatively, GLPK is included in homebrew-science installer library.   
See: http://brew.sh/ and https://github.com/Homebrew/homebrew-science for details.  

##### Installing Pythom/Pyomo   
Please folow one of the standard procedures to install Python, make it available in your system's terminal/cmd, install Pyomo package and LP solver(s). CPLEX or Gurobi are recommended for large scale models.  

##### Installing Julia/JuMP    
Similarly, follow the standard procedure of installing Julia and JuMP package, as well as the solvers and links to the solvers. *Currently Julia/JuMP version of energyRt is suitable for small-scale models and is recommended for testing only, the code for large-scale models is in progress.*

### energyRt
Currently the package is hosted only on GitHub. To install the package:   
devtools::install_github("olugovoy/energyRt")   
 
# Examples
* **UTOPIA** -- up to 11 regions model is saved in vignettes of the project `energyRt/vignettes/`.   
* **USENSYS** -- large scale model of US energy system is in progress. First version(s) are available here (https://github.com/usensys/usensys).
