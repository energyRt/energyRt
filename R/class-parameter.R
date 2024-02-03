#' An S4 class to specify the model set or parameter
#'
#' @slot name character.
#' @slot desc character.
#' @slot dimSets character.
#' @slot type factor,
#' @slot defVal numeric.
#' @slot interpolation character.
#' @slot data data.frame.
#' @slot inClass
#' @slot misc list.
#'
#' @include class-model.R
#' @family parameter
#' @export
#'
setClass(
  "parameter", # @parameter
  representation(
    name = "character", # @name name Name for GAMS
    desc = "character",
    type = "factor", # set, map, numpar, or bounds (Up / Lo /Fx)
    dimSets = "character", # @dimSets comma separated, order is matter
    defVal = "numeric", # @defVal Default value : zero value  for map,
    data = "data.frame", # @data Data for export
    # one for numpar, two for bounds
    interpolation = "character", # interpolation 'back.inter.forth'
    # not_data        = "logical",  # @data NO flag for map
    # class = "character",
    # slot = "character",
    inClass = "data.frame",
    # colName = "character", # @inClass$colName Column name in slot
    # nValues = "numeric", # @misc$nValues Number of non-NA values in 'data' (to speed-up processing) - !!! drop in the future
    misc = "list"
  ),
  prototype(
    name = NULL,
    dimSets = NULL,
    type = factor(NA, c("set", "map", "numpar", "bounds")),
    defVal = NULL,
    interpolation = NULL,
    data = data.frame(),
    # not_data       = FALSE,
    # colName = NULL,
    # nValues = 0,
    inClass = data.frame(
      class = character(),
      slot = character(),
      colName = character()
    ),
    misc = list(
      # class = NULL,
      # slot = NULL,
      nValues = 0
    )
  ) # ,
)

setMethod("initialize", signature = "parameter",
  function(.Object,
           name,
           dimSets,
           type,
           check = NULL,
           defVal = 0,
           interpolation = "back.inter.forth",
           inClass = NULL,
           colName = NULL,
           cls = NULL,
           slot = NULL) {

    # if (name == "DEBUG") browser() # DEBUG
    # expected_sets <- c(
    #   "tech", "techp", "dem", "sup", "weather", "acomm", "comm", "commp",
    #   "group", "region", "regionp", "src", "dst",
    #   "year", "yearp", "slice", "slicep", "stg", "expp", "imp", "trade"
    # )
    if (!is.character(name) || length(name) != 1 || !check_name(name)) {
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
    if (type == "numpar" && length(defVal) != 1) stop("Wrong defVal value")
    if (type == "bounds" && length(defVal) == 0) stop("Wrong defVal value")
    if (type == "bounds" && length(defVal) == 1) defVal <- rep(defVal, 2)
    if (type == "numpar" && length(interpolation) != 1) {
      stop("Wrong interpolation rule")
    }
    if (type == "bounds" && length(interpolation) == 0) {
      stop("Wrong interpolation rule")
    }
    if (type == "bounds" && length(interpolation) == 1) {
      interpolation <- rep(interpolation, 2)
    }
    .Object@name <- name
    .Object@dimSets <- dimSets
    .Object@type[] <- type
    if (!is.null(check)) .Object@check <- check
    .Object@defVal <- defVal
    .Object@interpolation <- interpolation
    # .Object@inClass$class <- cls
    # .Object@inClass$slot <- slot
    # make @data
    # data <- data.frame(
    #   tech = character(), techp = character(), sup = character(),
    #   weather = character(), dem = character(),
    #   acomm = character(), comm = character(), commp = character(),
    #   group = character(), region = character(), regionp = character(),
    #   src = character(), dst = character(),
    #   year = integer(), yearp = numeric(), slicep = character(),
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

    if (type == "bounds") dimSets <- c(dimSets, "type")
    if (any(type == c("numpar", "bounds"))) dimSets <- c(dimSets, "value")
    .Object@data <- data[, dimSets, drop = FALSE] %>% as.data.table
    # .Object@data <- select(data, all_of(dimSets)) #!!! drops duplicated columns
    if (any(!is_null(inClass), !is_null(cls), !is_null(slot),
             !is_null(colName) && any(colName != ""))) {
      # add the record
      if (nrow(.Object@inClass) > 0)
        message("multiple records in parameter ", name, "@inClass")
      if (!is.null(inClass)) {
        .Object@inClass <- bind_rows(.Object@inClass, inClass)
      } else {
        # message("initialize parameter: unfinished translation: ",
        #         name, " ", cls, " ", slot, " ", colName) # debug
      .Object@inClass <- .Object@inClass %>%
        add_row(
          class = cls,
          slot = slot,
          colName = colName)
      }
    }
    # .Object@inClass$colName <- colName
    .Object
  }
)

#' @family parameter
#' @export
newParameter <- function(...) new("parameter", ...)

#' @family parameter
#' @export
newSet <- function(dimSets) {
  if (length(dimSets) != 1) stop("Sets must have only one dimension")
  newParameter(dimSets, dimSets, "set")
}

# setGeneric('.dat2par', function(obj, data) standardGeneric(".dat2par"))

# .dat2par: data.frame ####
setMethod(
  ".dat2par", signature(obj = "parameter", data = "data.frame"),
  function(obj, data) {
    # cat(paste0(obj@name, ": ", class(data)[1], ", ncol =", ncol(data), "\n"))
    # if (!is.data.table(data)) browser() # DEBUG
    if (!is.data.table(data)) { # DEBUG
      # warning("\nDEBUG info: class ", class(data), " in ", obj@name, "@data\n")
      # browser()
    }
    # if (obj@name == "ordYear") browser() # DEBUG
    # browser()
    if (nrow(data) > 0) {
      if (ncol(data) != ncol(obj@data) ||
        any(sort(colnames(data)) != sort(colnames(obj@data)))) {
        stop("Internal error: Wrong new data 1")
      }
      # data <- data[, colnames(obj@data), drop = FALSE]
      data <- select(data, all_of(colnames(obj@data)))
      if (any(colnames(data) == "type")) {
        if (any(!(data$type %in% c("lo", "up")))) {
          stop("Internal error: Wrong new data 2")
        }
        data$type <- factor(data$type, levels = c("lo", "up"))
      }
      for (i in colnames(data)[sapply(data, class) == "factor"]) {
        if (i != "type") data[[i]] <- as.character(data[[i]])
      }
      # class2 <- function(x) if (class(x) == 'integer') 'numeric' else class(x)
      class2 <- function(x) if (inherits(x, "integer")) "numeric" else class(x)
      if (nrow(obj@data) > 0 && # !!! rewrite with exact match
          any(sapply(data, class2) != sapply(obj@data, class))) {
        stop("Internal error: Wrong new data 3")
      }
      # data <- data[apply(data, 1, function(x) all(!is.na(x))), , drop = FALSE]
      data <- drop_na(data)
      if (nrow(data) != 0) { # !!! rewrite !!!
        if (obj@misc$nValues != -1) { # ??? add after nrow = nValues?
          # if (obj@misc$nValues + nrow(data) > nrow(obj@data)) {
          #   browser()
          #   obj@data[nrow(obj@data) + 1:(nrow(data) + nrow(obj@data)), ] <- NA
          # }
          # nn <- obj@misc$nValues + 1:nrow(data)
          # obj@misc$nValues <- obj@misc$nValues + nrow(data)
          # obj@data[nn, ] <- data
          # obj@data <- bind_rows(obj@data, data)
          obj@data <- rbindlist(list(as.data.table(obj@data),
                                     as.data.table(data)), use.names = TRUE)
          obj@misc$nValues <- obj@misc$nValues + length(data)

          obj@misc$nValues <- nrow(obj@data)
        } else { # append ???
          # nn <- nrow(obj@data) + 1:nrow(data)
          # obj@data[nn, ] <- NA
          # obj@data[nn, ] <- data
          # obj@data <- bind_rows(obj@data, data)
          obj@data <- rbindlist(list(as.data.table(obj@data),
                                     as.data.table(data)), use.names = TRUE)
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
    # browser()
    if (obj@type != "set") {
      message("Error: ", obj@name, " parameter:")
      print(head(data))
      stop("Set type of parameter is expected for the character data. \n",
           "Parameter: ", obj@name, ", data: ", head(data), "...")
    }
    if (!all(is.character(data)) ) {
      stop("Assigning non-character (", class(data),
           ") data to the character set ", obj@name)
    }
    if (length(data) == 0) {
      obj@data <- as.data.table(obj@data)
      return(obj)
    }
    # !!! rewrite with dplyr or data.table
    # nn <- nrow(obj@data) + 1:length(data)
    # obj@data[nn, ] <- data
    obj@data <- rbindlist(list(as.data.table(obj@data), as.data.table(data)),
                          use.names = FALSE)
    if (ncol(obj@data) != 1) browser()
    if (is.factor(obj@data[[1]])) browser()
    obj@misc$nValues <- obj@misc$nValues + length(data)
    obj
  }
)

# .dat2par: numeric ####
setMethod(
  ".dat2par", signature(obj = "parameter", data = "numeric"),
  function(obj, data) {
    # browser()
    if (obj@type != "set") {
      stop("Set type of parameter is expected for the numeric data. \n",
           "Parameter: ", obj@name, ", data: ", head(data), "...")
    }
    if (!all(is.numeric(data))) {
      stop("Assigning non-numeric (", class(data),
           ") data to the numeric set ", obj@name)
    }
    if (length(data) == 0) {
      obj@data <- as.data.table(obj@data)
      return(obj)
    }
    # !!! rewrite with dplyr or data.table
    # nn <- nrow(obj@data) + 1:length(data)
    # obj@data[nn, ] <- data
    obj@data <- rbindlist(list(as.data.table(obj@data), as.data.table(data)),
                          use.names = FALSE)
    obj@data <- .force_year_class_df(obj@data)
    obj@data <- .force_value_class_df(obj@data)
    obj@misc$nValues <- obj@misc$nValues + length(data)
    obj
  }
)

.resetParameter <- function(x) {
  x@data <- x@data[0, , drop = FALSE]
  if (x@misc$nValues > 0) x@misc$nValues <- 0
  x
}


# Clear Map Table
# setMethod('clear', signature(obj = 'parameter'),
# .reset <- function(obj) {
#   obj@data <- obj@data[0, , drop = FALSE]
#   if (obj@misc$nValues != -1) obj@misc$nValues <- 0
#   obj
# }

# Get all unique set Map Table
# setMethod('getSet', signature(obj = 'parameter', dimSets = "character"),
#   function(obj, dimSets) {
#     if (length(dimSets) != 1 || all(dimSets != obj@dimSets))
#           stop('Internal error: Wrong dimSets request')
#     if (obj@misc$nValues != -1) unique(obj@data[seq(length.out = obj@misc$nValues), dimSets]) else
#         unique(obj@data[, dimSets])
# })

# setMethod('.get_data_slot', signature(obj = 'parameter'), # getParameterTable
.get_data_slot <- function(obj) {
  if (obj@misc$nValues != -1) { # reserved for???
    # obj@data[seq(length.out = obj@misc$nValues), , drop = FALSE]
    ii <- seq(length.out = min(nrow(obj@data), obj@misc$nValues))
    return(obj@data[ii, , drop = FALSE])
  } else {
    obj@data
  }
}

# Remove all data by all set
# setMethod('.drop_set_value', signature(obj = 'parameter', dimSets = "character", value = "character"),
.drop_set_value <- function(obj, dimSets, value) {
  # !!! better name? value -> ? dimSets -> dimSet?
  # browser()
  if (length(dimSets) != 1 || all(dimSets != obj@dimSets)) {
    stop(
      "Inconsistent sets in parameter ", obj@name,
      "check dimSets: ", paste(dimSets, collapse = ", ")
    )
  }
  # obj@data <- obj@data[!(obj@data[, dimSets] %in% value), , drop = FALSE]
  ii <- obj@data[[dimSets]] %in% value
  if (length(dimSets) > 1) browser() # check filter below
  obj@data <- obj@data %>% filter(!ii)
  obj
}

setGeneric('addMultipleSet',
           function(obj, dimSets) standardGeneric("addMultipleSet"))

# mapping character ####
setMethod(
  "addMultipleSet", signature(obj = "parameter", dimSets = "character"),
  function(obj, dimSets) {
    dimSets <- dimSets[!(dimSets %in% obj@data[[1]])]
    if (length(dimSets) == 0) {
      obj
    } else {
      gg <- data.frame(dimSets)
      colnames(gg) <- obj@dimSets
      gg <- as.data.table(gg)
      .dat2par(obj, gg)
    }
  }
)

# mapping numeric ####
setMethod(
  "addMultipleSet", signature(obj = "parameter", dimSets = "numeric"),
  function(obj, dimSets) {
    dimSets <- dimSets[!(dimSets %in% obj@data[[1]])]
    if (length(dimSets) == 0) {
      obj
    } else {
      gg <- data.frame(dimSets)
      colnames(gg) <- obj@dimSets
      gg <- as.data.table(gg)
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

