#---------------------------------------------------------------------------------------------------------
# Scenario
#---------------------------------------------------------------------------------------------------------
setClass("scenario",
      representation(
          name          = "character",
          description   = "character",      
          model         = "model",
          precompiled   = "CodeProduce",      
          result        = "result",
          misc = "list"
      ),
      prototype(
          name          = NULL,
          description   = NULL,      
          model         = NULL,
          precompiled   = NULL,      
          result        = NULL,
      #! Misc
      misc = list(
        GUID = "50b2affe-fd21-43f8-abbd-de74d55e854b"
      )),
      S3methods = TRUE
);


