#' Convert units
#'
#' @param from character of length one with unit name
#' @param to character of length one with unit name
#' @param value numeric vector with data to convert
#' @param database units database
#'
#' @return numeric vector with converted values
#' @export convert
#'
#'
setGeneric("convert", function(from, to, ...) standardGeneric("convert"))

setMethod(
  "convert", signature(from = "character", to = "character"),
  function(from, to, value = 1, database = "user") {
    h_from <- .find_unit(from, database = database)
    h_to <- .find_unit(to, database = database)
    if (h_from$type != h_to$type) {
      stop("Different unit type")
    }
    conval <- value * (h_from$coef / h_to$coef)
    names(conval) <- NULL
    conval
  }
)

setGeneric("add_to_convert", function(type, unit, convert_coefficient,
                                      # alias,
                                      # SI_preffixes, database, update,
                                      ...) {
  standardGeneric("add_to_convert")
})

#' Add units to convert function
#'
#' @param type character, type of the unit (one of "Energy", "Power", "Mass", "Time", "Length", "Area", "Pressure", "Density", "Volume", "Flow Rates", "Currency").
#' @param unit character, the name of the new unit.
#' @param convert_coefficient numeric, convert factor to the base unit of this type (see the first column of `convert_data[[database]][[type]]`).
#' @param SI_preffixes logical, can be used with `SI` prefixes, FALSE by default.
#' @param alias character vector, alternative name(s) for the same unit.
#' @param database character name of a database with units (`user` by default, other options are not implemented yet).
#'
#' @return updated `convert_data` in the `.GlobalEnv`, the values will not update the package data.
#' @export
#'
#' @examples
#' do not run
#' convert_data$user$Currency
#' add_to_convert("Currency", unit = "JPY", convert_coefficient = 140)
#' convert_data$user$Currency
#'
setMethod(
  "add_to_convert",
  signature(
    type = "character", unit = "character", convert_coefficient = "numeric"
    # alias = "character", SI_preffixes = "logical", database = "character",
    # update = "logical"
  ),
  function(type, unit, convert_coefficient, alias = "",
           SI_preffixes = FALSE, database = "user", update = TRUE) {
    simple <- SI_preffixes # rename
    # convert_data <- get("convert_data", globalenv())
    alias <- unique(alias)
    # browser()
    if (!exists("convert_data", where = .GlobalEnv)) data("convert_data")
    if (all(names(convert_data[[database]]) != type)) {
      if (!simple) {
        stop("First unit must be standart")
      }
      if (alias[1] != "") {
        for (i in 1:length(alias)) { #ToDo: rewrite
          convert_data[[database]][[type]] <- array(
            c(convert_coefficient, simple, convert_coefficient, simple),
            dim = c(2,2),
            dimnames = list(c("coeff", "simple"), c(unit, alias[i])))
        }
      } else {
        convert_data[[database]][[type]] <- array(c(
          convert_coefficient,
          simple
        ), dim = c(2, 1), dimnames = list(c("coeff","simple"), unit))
      }
    } else if (any(unit == dimnames(convert_data[[type]])[[2]])) {
      if (any(convert_data[[database]][[type]][, unit] != c(
        convert_coefficient,
        simple
      )) && !update) {
        stop("Unit '", unit, "' already exists (use `update = TRUE`?)") # ???
      }
      if (dimnames(convert_data[[database]][[type]])[[2]][1] ==
        unit && convert_data[[database]][[type]][
        simple,
        unit
      ] != convert_coefficient) {
        stop("Base unit '(", unit, " = 1)' cannot be redefined") # ???
      }
      convert_data[[database]][[type]]["simple", unit] <- simple
      convert_data[[database]][[type]]["coeff", unit] <- convert_coefficient
      if (alias[1] != "") {
        convert_data[[database]][[type]]["simple", alias] <- simple
        convert_data[[database]][[type]]["coeff", alias] <- convert_coefficient
      }
    } else if (alias[1] != "") {
      for (i in 1:length(alias)) {
        convert_data[[database]][[type]] <- array(
          c(convert_data[[database]][[type]], convert_coefficient, simple,
            convert_coefficient, simple),
          dim = c(2, 2 + dim(convert_data[[database]][[type]])[2]),
          dimnames = list(
            c("coeff", "simple"),
            c(dimnames(convert_data[[database]][[type]])[[2]], unit, alias[i]))
        )
      }
    } else {
      convert_data[[database]][[type]] <- array(
        c(
          convert_data[[database]][[type]],
          convert_coefficient, simple
        ),
        dim = c(2, 1 + dim(convert_data[[database]][[type]])[2]),
        dimnames = list(c("coeff", "simple"), c(
          dimnames(convert_data[[database]][[type]])[[2]],
          unit
        ))
      )
    }
    jj <- duplicated(colnames(convert_data[[database]][[type]])) #!!! quick fix
    convert_data[[database]][[type]] <- convert_data[[database]][[type]][,!jj]
    assign("convert_data", convert_data, globalenv())
  }
)

.split_to_unit <- function(st, database = "user") {
  ss <- unique(strsplit(st, "[-+*/^]"))[[1]]
  ss <- ss[suppressWarnings(is.na(as.numeric(ss)))]
  h <- lapply(ss, function(x) .simple_.find_unit(x, database))
  g <- array(sapply(h, function(x) x$coef),
    dim = length(ss),
    dimnames = list(ss)
  )
  g2 <- array(sapply(h, function(x) dimnames(convert_data[[database]][[x$type]])[[2]][1]),
    dim = length(ss), dimnames = list(ss)
  )
  s2 <- st
  for (k in ss[sort(nchar(ss), index.return = TRUE, decreasing = TRUE)$ix]) {
    s2 <- gsub(
      k,
      g2[k], s2
    )
  }
  for (k in ss[sort(nchar(ss), index.return = TRUE, decreasing = TRUE)$ix]) {
    st <- gsub(
      k,
      g[k], st
    )
  }
  list(type = s2, coef = eval(parse(text = st)))
}

.find_unit <- function(unit, database = "user") {
  g <- .simple_.find_unit(unit, database = database, FALSE)
  if (!is.null(g)) {
    return(g)
  } else {
    g <- .split_to_unit(unit, database = database)
    g2 <- .simple_.find_unit(g$type, database = database, FALSE)
    if (!is.null(g2)) {
      g2$coef <- g2$coef * g$coef
      return(g2)
    } else {
      return(g)
    }
  }
}

.simple_.find_unit <- function(unit, database = "user", stop_on_error = TRUE) {
  if (!exists("convert_data", where = .GlobalEnv)) data("convert_data")
  i <- 1
  fl <- FALSE
  while (i <= length(convert_data[[database]])) {
    u <- convert_data[[database]][[i]]
    ss <- dimnames(u)[[2]]
    for (k in 1:dim(u)[[2]]) {
      if (ss[k] == unit) {
        return(list(
          type = names(convert_data[[database]])[i],
          coef = u["coeff", k]
        ))
      } else {
        if (any(paste(dimnames(prefix)[[1]], ss[k], sep = "") ==
          unit)) {
          if (ss[k] == unit || (u["simple", k] == 1 &&
            any(paste(dimnames(prefix)[[1]], ss[k], sep = "") ==
              unit))) {
            return(list(
              type = names(convert_data[[database]])[i],
              coef = prefix[paste(dimnames(prefix)[[1]],
                ss[k],
                sep = ""
              ) == unit] * u[
                "coeff",
                k
              ]
            ))
          }
        }
      }
    }
    i <- i + 1
  }
  if (stop_on_error) {
    stop("Unknown unit ", unit)
  } else {
    return(NULL)
  }
}
