setClass("trade",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # Details
          commodity     = "character",       # Vector if NULL that
          source        = "character",       # if NULL that in global region
          destination   = "character",       # if NULL that in global region
      # Performance parameters
          trade         = "data.frame"
      ),
      # Default values and structure of slots
      prototype(
      # General information
         name           = "default_trade",       # Short name
         description    = "",
         commodity      = NULL,       #
         source         = NULL,
         destination    = NULL,
         trade          = data.frame(
                                     source       = character(),
                                     destination  = character(),
                                     comm       = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     ava.up     = numeric(),
                                     ava.fx     = numeric(),
                                     ava.lo     = numeric(),
                                     cost       = numeric(),
                                     stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
