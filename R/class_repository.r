#---------------------------------------------------------------------------------------------------------
# Repository : technology
#---------------------------------------------------------------------------------------------------------
setClass("repository",
      representation(
          name          = "character",
          description   = "character",       # Details
          data          = "list"
      ),
      prototype(
          name          = "default_repository",
          description   = "",       # Details
          data          = list()
      ),
      S3methods = TRUE
);
print.rTechnology <- function(x) print_repository(x, 'technology')



# Get repository names
get_repository_name <- function(x) {
  sapply(x@data, function(z) z@name)
}

