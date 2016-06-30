setClass("stock",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # Details
          tech          = "character",       # Stock technology name
          stock 	      = "data.frame"),   # Capacity of one unit (for integer programming)
      # Default values and structure of slots
      prototype(
          name          = "",
          description   = "",
          tech         = NULL,
          stock        = data.frame( tech       = character(),
                                     region     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     stock      = numeric(),
                                     stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
