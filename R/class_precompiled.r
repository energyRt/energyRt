#---------------------------------------------------------------------------------------------------------
# precompiled
#---------------------------------------------------------------------------------------------------------
setClass("precompiled",
      representation(
          name          = "character",
          description   = "character",       # Details
          defaultCode   = "character",
          #defaultInit   = "character",
          setInit       = "list",
          parameterInit = "list",
          clearInit     = "list",
          # General parameter from model for correct test
          region        = "character",
          year          = "numeric",
          slice         = "character",
          commodity     = "character",
          technology    = "character",
          demand        = "character",
          supply        = "character",
          # General parameter from model for correct test
          useCommodity  = "character",
          useTechnology = "character",
          useDemand     = "character",
          useSupply     = "character",
          # Default parameter
          interpolation = "data.frame",
          default       = "data.frame",
          set_type      = "data.frame"
      ),
      prototype(
          name          = "",
          description   = "",       # Details
          defaultCode   = readLines('gams/model.gms'),       # Get from gams model
          #defaultInit   = "",       # Calculate from interpolation & defaultValue
          setInit       = list(),   # Initializtion set (from precompiled)
          parameterInit = list(),   # Initializtion parameter (from precompiled)
          clearInit     = list(),   # Clear code
          # General parameter from model for correct test
          region        = NULL,
          year          = NULL,
          slice         = NULL,
          commodity     = NULL,
          technology    = NULL,
          demand        = NULL,
          supply        = NULL,
          # General parameter from model for correct test
          useCommodity  = NULL,
          useTechnology = NULL,
          useDemand     = NULL,
          useSupply     = NULL,
          # Default parameter
          interpolation = data.frame(),
          default       = data.frame(),
          set_type      = data.frame(name = character(), type = factor(levels = c('technology',
                                                                    'region',
                                                                    'supply',
                                                                    'demand',
                                                                    'commodity'
                                                                    )), stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
