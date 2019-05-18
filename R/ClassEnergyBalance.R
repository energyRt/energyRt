#ToDo:
# Class technology, slot @enbal will have a name either a) a name of the sector
# b) name of a function wich will assign the sector
# Class energyBalance:
# add slot @function which will have a list with functions to assign
# technologies to a particular part of a balance.

setClass("energyBalance",
          representation(
            # General information
            name          = "character",      # Short name
            details       = "character",      # Details
            type          = "character",      # Optional
            data.source   = "list",           # Source of the data
            unit          = "character",      # Main energy unit of the balance
            rows          = "data.frame",     # Sector or Technology group - optional
            columns       = "data.frame",     #       # Which part of energy balance - (export, import, ...,
#            long.names    = "data.frame",
            id            = "list",
#            id.region     = "character",      #
#            id.year       = "character", 
#            id.slice      = "character", 
#            id.rownames   = "character",
#            id.other      = "data.frame",
            data          = "data.frame",
            misc = "list"
          ),
          prototype(
            name          = "",
            details       = "",
            type          = "",
            data.source   = list(), 
            unit          = character(),
            rows          = data.frame(name     = character(),
                                       type     = factor(NULL, c('data', 
                                                                 'subsum', 
                                                                 'total', 
                                                                 'info')),
                                       segment  = factor(NULL, c('supply', 
                                                                 'transform', 
                                                                 'consumption')), ## alt: section 
                                       sector   = character(), # export, import, stockchange,
                                       parent   = character(), # if subsector 
                                       unit     = character(), # overrides @mainUnit
                                       color    = character(),
                                       stringsAsFactors = FALSE),                           
            columns       = data.frame(name = character(),
                                       type = factor(NULL, c('id', 
                                                             'data', 
                                                             'subsum', 
                                                             'total', 
                                                             'info')),
                                       #unit     = character(), # overrides @mainUnit
                                       parent = character(),
                                       stringsAsFactors = FALSE),
            id            = list(region = character(),
                                 year = character(),
                                 slice = character(),
                                 rows = character()),
                                 #, stringsAsFactors = FALSE),
            data          = data.frame(),
            #! Misc
            misc = list(
            )),
            S3methods = TRUE
);

setMethod("initialize", "energyBalance", function(.Object, ...) {
  .Object
})

