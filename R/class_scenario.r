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
            optimial = FALSE),
          #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "scenario", function(.Object, ...) {
  .Object
})
                                              

