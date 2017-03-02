#---------------------------------------------------------------------------------------------------------
# Repository : technology
#---------------------------------------------------------------------------------------------------------
setClass("repository",
      representation(
          name          = "character",
          description   = "character",       # Details
          data          = "list",
          misc = "list"
      ),
      prototype(
          name          = "default_repository",
          description   = "",       # Details
          data          = list(),
      #! Misc
      misc = list(
        GUID = "d8433f44-c3c6-42fd-ae89-780e4e8b7329"
      )),
      S3methods = TRUE
);
print.rTechnology <- function(x) print_repository(x, 'technology')



# Get repository names
get_repository_name <- function(x) {
  sapply(x@data, function(z) z@name)
}

