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
          misc = "list"
      ),
      prototype(
          name          = NULL,
          description   = NULL,      
          model         = NULL,
          modInp        = NULL,      
          modOut        = NULL,
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "scenario", function(.Object, ...) {
  attr(.Object, 'GUID') <- '50b2affe-fd21-43f8-abbd-de74d55e854b'
  .Object
})
                                              

