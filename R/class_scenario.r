#---------------------------------------------------------------------------------------------------------
# Scenario
#---------------------------------------------------------------------------------------------------------
setClass("scenario",
      representation(
          name          = "character",
          description   = "character",      
          model         = "model",
          precompiled   = "CodeProduce",      
          result        = "result"
      ),
      prototype(
          name          = NULL,
          description   = NULL,      
          model         = NULL,
          precompiled   = NULL,      
          result        = NULL
      ),
      S3methods = TRUE
);


