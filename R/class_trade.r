setClass("trade",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # Details
          commodity     = "character",       # Vector if NULL that
          source        = "characterOrNULL",       # if NULL that in all region
          destination   = "characterOrNULL",       # if NULL that in all region
      # Performance parameters
          trade         = "data.frame",
          misc = "list"
      ),
      # Default values and structure of slots
      prototype(
      # General information
         name           = "default_trade",       # Short name
         description    = "",
         commodity      = NULL,       #
         source         = character(),
         destination    = character(),
         trade          = data.frame(
                                     src        = character(),
                                     dst        = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     ava.up     = numeric(),
                                     ava.fx     = numeric(),
                                     ava.lo     = numeric(),
                                     cost       = numeric(),
                                     markup     = numeric(),
                                     stringsAsFactors = FALSE),
        #! Misc
        misc = list(
          GUID = "97e0ed37-fc8a-4210-ad95-702cf75bed56"
        )),
      S3methods = TRUE
);
