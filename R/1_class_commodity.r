# Commodity
setClass("commodity",
      representation(
      # General information
          name          = "character",      # Short name
          description   = "character",      # Details
          type	        = "character",      # energy, electricity, material, (fuel?)
          origin        = "character",      # Region of origin
      # Physical Property
          weight        = "data.frame",
          density       = "data.frame",
      # Energy
          LHV           = "data.frame",
          HHV           = "data.frame",
      # Content
          content       = "data.frame",     # Content of various mater
      # Emission Factor
          emis          = "data.frame",     # Other emission factors
          agg           = "data.frame",     # Aggregate factor
      # Miscelaneous
          color         = "character",      #
          source        = "list",
          other         = "list",           #
          limtype       = "factor"
      ),
      prototype(
          name          = "",
          description   = "",
          type	        = "",
          origin        = "",
          weight        = data.frame(unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          density       = data.frame(unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          LHV           = data.frame(unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          HHV           = data.frame(unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          content       = data.frame(name     = character(),
                                     unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          emis          = data.frame(comm     = character(),
                                     unit     = character(),
                                     mean     = numeric(),
                                     sd       = numeric(),
                                     median   = numeric(),
                                     min      = numeric(),
                                     max      = numeric(),
                                     PDF      = character(), # Probability Density Function
                                     stringsAsFactors = FALSE),
          agg          = data.frame(comm     = character(),
                                     unit     = numeric(),
                                     agg     = numeric(),
                                     stringsAsFactors = FALSE),
          color         = "",
          source        = list(),
          other         = list(),
          limtype       = factor('LO', levels = c('FX', 'UP', 'LO'))
      ),
      S3methods = TRUE
)

