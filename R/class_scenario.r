#---------------------------------------------------------------------------------------------------------
# Scenario
#---------------------------------------------------------------------------------------------------------
setClass("scenario",
      representation(
          name          = "character",
          description   = "character",      
          model         = "model",
          modInp        = "modInp",     # @modInp // @parameters 
          modOut        = "modOut",          # @modOut // @variables
          source  = "list",          # Model source
          solver  = "list",
          status  = "list",
          misc = "list"
      ),
      prototype(
          name          = NULL,
          description   = NULL,      
          model         = NULL,
          modInp        = NULL,      
          modOut        = NULL,
          source  = list(),          # Model source
          solver = list(),
          status = list(
            interpolated = FALSE,
            optimal = FALSE),
          #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "scenario", function(.Object, ...) {
  .Object
})

.modelCode <- list(
  GAMS = readLines('gams/energyRt.gms'),
  JuMP = readLines('julia/energyRt.jl'),
  JuMPOutput = readLines('julia/energyRtOutput.jl'),
  PYOMOConcrete = readLines('pyomo/energyRtConcrete.py'),
  PYOMOConcreteOutput = readLines('pyomo/energyRtConcreteOutput.py'),
  PYOMOAbstract = readLines('pyomo/energyRtAbstract.py'),
  PYOMOAbstractOutput = readLines('pyomo/energyRtAbstractOutput.py'),
  GLPK = readLines('glpk/energyRt.mod'),
  GAMS_output = readLines('gams/output.gms'),
  checkGAMS = readLines('gams/check.gms'),
  checkJULIA = readLines('julia/check.jl'),
  checkPYOMO = readLines('pyomo/check.py'),
  checkGLPK = readLines('glpk/check.mod')
  )


