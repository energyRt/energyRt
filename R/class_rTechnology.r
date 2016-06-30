if (!isClassUnion('repository')) setClassUnion("repository")
#---------------------------------------------------------------------------------------------------------
# Repository : technology
#---------------------------------------------------------------------------------------------------------
setClass("rTechnology",
      representation(
          name          = "character",
          description   = "character",       # Details
          data          = "list"
      ),
      prototype(
          name          = "default_technology",
          description   = "",       # Details
          data          = list()
      ),
      contain   = "repository",
      S3methods = TRUE
);
print.rTechnology <- function(x) print_repository(x, 'technology')

