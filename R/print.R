# Print modInp ####
setMethod("print", "modInp", function(x, ...) {
  if (length(x@parameters) == 0) {
    cat("There is no data\n")
  } else {
    for (i in 1:length(x@parameters)) {
      print(x@parameters[[i]])
    }
  }
})

# Print commodity ####
print.commodity <- function(x) {
  # print commodity
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, "\n")
  # if (x@type != '') cat('type: ', x@type, '\n')
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  # if (x@origin != '') cat('Region of origin: ',x@origin, '\n')
  if (!is.null(x@misc$color)) cat("color: ", x@misc$color, "\n")

  g <- getClass("commodity")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) {
    g@slots[[z]] ==
      "data.frame"
  })]
  for (i in zz) if_print_data_frame(x, i)
}

print.demand <- function(x) {
  # print demand
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, "\n")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  cat("Commodity: ", x@commodity, "\n")
  g <- getClass("demand")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) {
    g@slots[[z]] ==
      "data.frame"
  })]
  for (i in zz) if_print_data_frame(x, i)
}


#------------------------------------------------------------------------------
print.equation <- function(x) {
  # print equation
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, ", eq: ", as.character(x@eq), ", defVal: ", x@defVal, "\n", sep = "")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  g <- getClass("equation")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) {
    g@slots[[z]] ==
      "data.frame"
  })]
  for (i in zz) if_print_data_frame(x, i)
  for (i in seq_along(x@lhs)) {
    cat("Term ", i, ":\n", sep = "")
    print(x@lhs[[i]])
  }
}

#------------------------------------------------------------------------------
print.summand <- function(x) {
  # print equation
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("variable: ", x@variable, ", defVal: ", x@defVal, "\n", sep = "")
  g <- getClass("summand")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) {
    g@slots[[z]] ==
      "data.frame"
  })]
  for (i in zz) if_print_data_frame(x, i)
  if (length(x@for.sum) != 0) {
    cat("for.sum set:\n")
    print(x@for.sum)
  }
}

#------------------------------------------------------------------------------
print.model <- function(x) {
  # print model
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, "\n")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  print(x@sysInfo)
  if (length(x@data) != 0) {
    for (i in 1:length(x@data)) {
      cat("Repository ", i, "(", class(x@data[[i]]), "):\n", sep = "")
      print(x@data[[i]])
    }
  }
}

#------------------------------------------------------------------------------
print.region <- function(x) {
  cat("Name: ", x@name, "\n")
  # if (x@type != '') cat('type: ', x@type, '\n')
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  if (!is.null(x@misc$color)) cat("color: ", x@misc$color, "\n")
}

#------------------------------------------------------------------------------
print.repository <- function(x) {
  cat("Name: ", x@name, "\n")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  for (i in seq(along = x@data)) {
    cat(class(x@data[[i]]), " ", i, ":\n", sep = "")
    print(x@data[[i]])
  }
}

#------------------------------------------------------------------------------
print.scenario <- function(x) {
  cat("Name: ", x@name, "\n")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  if (!is.null(x@model)) {
    cat("Model:\n")
    print(x@model)
  }
  #    if (!is.null(x@discount)) cat('Discount: ', x@discount, '\n')
  #    if (!is.null(x@year)) {
  #      cat('Year:\n')
  #      print(x@year)
  #    }
  #    if (!is.null(x@slice)) {
  #      cat('Slice:\n')
  #      print(x@slice)
  #    }
  #    if (!is.null(x@repository)) {
  #      cat('Repository:\n')
  #      print(x@repository)
  #    }
  #    if (!is.null(x@result)) {
  #      cat('result:\n')
  #      print(x@result)
  #    }
}

#------------------------------------------------------------------------------
print.supply <- function(x) {
  # print supply
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, "\n")
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  cat("Commodity: ", x@commodity, "\n")
  # cat('Reserve: ', x@reserve, '\n')
  if (!is.null(x@region)) cat('region: "', paste(x@region, collapse = '", "'), '"\n', sep = "")
  g <- getClass("supply")
  zz <- names(g@slots)[sapply(names(g@slots), function(z) {
    g@slots[[z]] ==
      "data.frame"
  })]
  for (i in zz) if_print_data_frame(x, i)
}

#------------------------------------------------------------------------------
print.technology <- function(x, ...) {
  # print technology
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  cat("Name: ", x@name, "\n")
  # if (x@type!='') cat('type: ', x@type, '\n')
  if (length(x@description) != 0 && x@description != "") cat("description: ", x@description, "\n")
  if (x@cap2act != "") cat("cap2act: ", x@cap2act, "\n")
  if (!is.null(x@region)) cat('region: "', paste(x@region, collapse = '", "'), '"\n', sep = "")
  # if(!is.null(x@reporting_years)) cat('reporting years: ', x@reporting_years, '\n')
  for (i in energyRt:::.technology_data_frame()) if_print_data_frame(x, i)
}

#------------------------------------------------------------------------------
print.sysInfo <- function(x) {
  # print model
  if_print_data_frame <- function(x, sl) {
    if (nrow(slot(x, sl)) != 0) {
      cat("\n", sl, "\n")
      print(slot(x, sl))
      cat("\n")
    }
  }
  for (i in c("region", "year", "milestone", "slice")) {
    if (is.null(slot(x, i))) {
      cat("There is no ", i, "\n", sep = "")
    } else {
      cat(i, ":\n", sep = "")
      print(slot(x, i))
    }
  }
  if_print_data_frame(x, "debug")
  if_print_data_frame(x, "discount")
  # if_print_data_frame(x, 'tax')
  if_print_data_frame(x, "defVal")
  if_print_data_frame(x, "interpolation")
}
