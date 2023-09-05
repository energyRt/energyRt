#' An S4 class to specify the model set or parameter
#'
#' @slot name character.
#' @slot dimSets character.
#' @slot type factor.
#' @slot defVal numeric.
#' @slot interpolation character.
#' @slot data data.frame.
#' @slot colName character.
#' @slot nValues numeric.
#' @slot misc list.
#'
#' @include class-model.R
#'
#' @export
#'
setClass(
  "parameter", # @parameter
  representation(
    name = "character", # @name name Name for GAMS
    dimSets = "character", # @dimSets Dimension sets, comma separated, order is matter
    type = "factor", # @type is it map (map),  simple (simple parameter),
    # multi (Up / Lo /Fx parameter)
    defVal = "numeric", # @defVal Default value : zero value  for map,
    # one for single, two for multi
    interpolation = "character", # interpolation 'back.inter.forth'
    data = "data.frame", # @data Data for export
    # not_data        = "logical",  # @data NO flag for map
    colName = "character", # @colName Column name in slot
    nValues = "numeric", # @nValues Number of non-NA values in 'data' (to speed-up processing) - !!! drop in the future
    misc = "list"
  ),
  prototype(
    name = NULL,
    dimSets = NULL,
    type = factor(NA, c("set", "map", "simple", "multi")),
    defVal = NULL,
    interpolation = NULL,
    data = data.frame(),
    # not_data       = FALSE,
    colName = NULL,
    nValues = 0,
    misc = list(
      class = NULL,
      slot = NULL
    )
  ) # ,
)

setMethod("initialize", signature = "parameter",
  function(.Object, name,
           dimSets,
           type,
           check = NULL,
           defVal = 0,
           interpolation = "back.inter.forth",
           colName = "",
           cls = NULL,
           slot = NULL) {

    # expected_sets <- c(
    #   "tech", "techp", "dem", "sup", "weather", "acomm", "comm", "commp",
    #   "group", "region", "regionp", "src", "dst",
    #   "year", "yearp", "slice", "slicep", "stg", "expp", "imp", "trade"
    # )
    if (!is.character(name) || length(name) != 1 || !energyRt:::check_name(name)) {
      stop(paste('Wrong name: "', name, '"', sep = ""))
    }
    if (any(!is.character(dimSets)) || # length(dimSets) == 0 ||
      any(!(dimSets %in% .dimSets))) {
      browser()
      stop("Unknown dimSets: ", dimSets, "\nParameter: ", name)
    }
    if (all(type != levels(.Object@type))) stop("Wrong type")
    if (length(check) != 0 && (length(check) != 1 || !is.function(check))) {
      stop("Wrong check function")
    }
    if (any(!is.numeric(defVal))) stop("Wrong defVal value")
    if (any(!is.character(interpolation)) || any(gsub(
      "[.]", "",
      sub("forth", "", sub("inter", "", sub("back", "", interpolation)))
    ) != "")) {
      stop("Wrong interpolation rule")
    }
    if (type == "simple" && length(defVal) != 1) stop("Wrong defVal value")
    if (type == "multi" && length(defVal) == 0) stop("Wrong defVal value")
    if (type == "multi" && length(defVal) == 1) defVal <- rep(defVal, 2)
    if (type == "simple" && length(interpolation) != 1) {
      stop("Wrong interpolation rule")
    }
    if (type == "multi" && length(interpolation) == 0) {
      stop("Wrong interpolation rule")
    }
    if (type == "multi" && length(interpolation) == 1) {
      interpolation <- rep(interpolation, 2)
    }
    .Object@name <- name
    .Object@dimSets <- dimSets
    .Object@type[] <- type
    if (!is.null(check)) .Object@check <- check
    .Object@defVal <- defVal
    .Object@interpolation <- interpolation
    .Object@misc$class <- cls
    .Object@misc$slot <- slot
    # make @data
    # data <- data.frame(
    #   tech = character(), techp = character(), sup = character(),
    #   weather = character(), dem = character(),
    #   acomm = character(), comm = character(), commp = character(),
    #   group = character(), region = character(), regionp = character(),
    #   src = character(), dst = character(),
    #   year = numeric(), yearp = numeric(), slicep = character(),
    #   slice = character(), stg = character(),
    #   expp = character(), imp = character(), trade = character(),
    #   type = factor(levels = c("lo", "up")),
    #   value = numeric(), stringsAsFactors = FALSE
    # )
    # dimSets <- .Object@dimSets
    data <- as.data.frame(array(character(), c(0, length(.dimSets)),
                                dimnames = list(character(), .dimSets)),
                          stringsAsFactors = FALSE)
    data$type <- factor(levels = c("lo", "up"))
    data$value <- numeric()
    data$year <- integer()
    data$yearp <- integer()
    # data <- as_tibble(data)
    # browser()

    if (type == "multi") dimSets <- c(dimSets, "type")
    if (any(type == c("simple", "multi"))) dimSets <- c(dimSets, "value")
    .Object@data <- data[, dimSets, drop = FALSE]
    .Object@colName <- colName
    .Object
  }
)

newParameter <- function(...) new("parameter", ...)

newSet <- function(dimSets) {
  if (length(dimSets) != 1) stop("Sets must have only one dimension")
  newParameter(dimSets, dimSets, "set")
}

setGeneric('.dat2par', function(obj, data) standardGeneric(".dat2par"))

# .dat2par: data.frame ####
setMethod(
  ".dat2par", signature(obj = "parameter", data = "data.frame"),
  function(obj, data) {
    if (nrow(data) > 0) {
      if (ncol(data) != ncol(obj@data) ||
        any(sort(colnames(data)) != sort(colnames(obj@data)))) {
        stop("Internal error: Wrong new data 1")
      }
      data <- data[, colnames(obj@data), drop = FALSE]
      if (any(colnames(data) == "type")) {
        if (any(!(data$type %in% c("lo", "up")))) {
          stop("Internal error: Wrong new data 2")
        }
        data$type <- factor(data$type, levels = c("lo", "up"))
      }
      for (i in colnames(data)[sapply(data, class) == "factor"]) {
        if (i != "type") data[, i] <- as.character(data[, i])
      }
      # class2 <- function(x) if (class(x) == 'integer') 'numeric' else class(x)
      class2 <- function(x) if (inherits(x, "integer")) "numeric" else class(x)
      if (nrow(obj@data) > 0 && # !!! rewrite with exact match
          any(sapply(data, class2) != sapply(obj@data, class))) {
        stop("Internal error: Wrong new data 3")
      }
      data <- data[apply(data, 1, function(x) all(!is.na(x))), , drop = FALSE]
      if (nrow(data) != 0) {
        if (obj@nValues != -1) {
          if (obj@nValues + nrow(data) > nrow(obj@data)) {
            obj@data[nrow(obj@data) + 1:(nrow(data) + nrow(obj@data)), ] <- NA
          }
          nn <- obj@nValues + 1:nrow(data)
          obj@nValues <- obj@nValues + nrow(data)
          obj@data[nn, ] <- data
        } else {
          nn <- nrow(obj@data) + 1:nrow(data)
          obj@data[nn, ] <- NA
          obj@data[nn, ] <- data
        }
      }
    }
    obj@data <- .force_year_class_df(obj@data)
    obj@data <- .force_value_class_df(obj@data)
    obj
  }
)


# .dat2par: character ####
setMethod(
  ".dat2par", signature(obj = "parameter", data = "character"),
  function(obj, data) {
    if (obj@type != "set") {
      stop("Set type of parameter is expected for the character data. \n",
           "Parameter: ", obj@name, ", data: ", head(data), "...")
    }
    if (!all(is.character(data)) ) {
      stop("Assigning non-character (", class(data),
           ") data to the character set ", obj@name)
    }
    if (length(data) == 0) {
      return(obj)
    }
    # !!! rewrite with dplyr or data.table
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
  }
)

# .dat2par: numeric ####
setMethod(
  ".dat2par", signature(obj = "parameter", data = "numeric"),
  function(obj, data) {
    if (obj@type != "set") {
      stop("Set type of parameter is expected for the numeric data. \n",
           "Parameter: ", obj@name, ", data: ", head(data), "...")
    }
    if (!all(is.numeric(data))) {
      stop("Assigning non-numeric (", class(data),
           ") data to the numeric set ", obj@name)
    }
    if (length(data) == 0) {
      return(obj)
    }
    # !!! rewrite with dplyr or data.table
    nn <- nrow(obj@data) + 1:length(data)
    obj@data[nn, ] <- data
    obj@nValues <- obj@nValues + length(data)
    obj
  }
)

.resetParameter <- function(x) {
  x@data <- x@data[0, , drop = FALSE]
  if (x@nValues > 0) x@nValues <- 0
  x
}


# Clear Map Table
# setMethod('clear', signature(obj = 'parameter'),
# .reset <- function(obj) {
#   obj@data <- obj@data[0, , drop = FALSE]
#   if (obj@nValues != -1) obj@nValues <- 0
#   obj
# }

# Get all unique set Map Table
# setMethod('getSet', signature(obj = 'parameter', dimSets = "character"),
#   function(obj, dimSets) {
#     if (length(dimSets) != 1 || all(dimSets != obj@dimSets))
#           stop('Internal error: Wrong dimSets request')
#     if (obj@nValues != -1) unique(obj@data[seq(length.out = obj@nValues), dimSets]) else
#         unique(obj@data[, dimSets])
# })

# setMethod('.get_data_slot', signature(obj = 'parameter'), # getParameterTable
.get_data_slot <- function(obj) {
  if (obj@nValues != -1) { # reserved for???
    obj@data[seq(length.out = obj@nValues), , drop = FALSE]
  } else {
    obj@data
  }
}

# Remove all data by all set
# setMethod('.drop_set_value', signature(obj = 'parameter', dimSets = "character", value = "character"),
.drop_set_value <- function(obj, dimSets, value) {
  browser()
  if (length(dimSets) != 1 || all(dimSets != obj@dimSets)) {
    stop(
      "Inconsistent sets in parameter ", obj@name,
      "check dimSets: ", paste(dimSets, collapse = ", ")
    )
  }
  obj@data <- obj@data[!(obj@data[, dimSets] %in% value), , drop = FALSE]
  obj
}

setGeneric('addMultipleSet',
           function(obj, dimSets) standardGeneric("addMultipleSet"))

# mapping character ####
setMethod(
  "addMultipleSet", signature(obj = "parameter", dimSets = "character"),
  function(obj, dimSets) {
    dimSets <- dimSets[!(dimSets %in% obj@data[, 1])]
    if (length(dimSets) == 0) {
      obj
    } else {
      gg <- data.frame(dimSets)
      colnames(gg) <- obj@dimSets
      .dat2par(obj, gg)
    }
  }
)

# mapping numeric ####
setMethod(
  "addMultipleSet", signature(obj = "parameter", dimSets = "numeric"),
  function(obj, dimSets) {
    dimSets <- dimSets[!(dimSets %in% obj@data[, 1])]
    if (length(dimSets) == 0) {
      obj
    } else {
      gg <- data.frame(dimSets)
      colnames(gg) <- obj@dimSets
      .dat2par(obj, gg)
    }
  }
)

# print parameter ####
setMethod("print", "parameter", function(x, ...) {
  if (nrow(x@data) == 0) {
    cat('parameter "', x@name, '" is empty\n', sep = "")
  } else {
    cat('parameter "', x@name, '"\n', sep = "")
    print(x@data)
  }
})

setMethod(
  ".dat2par", signature(obj = "parameter", data = "NULL"),
  function(obj, data) {
    return(obj)
  }
)

