.get_scen_data <- function(scen) {
  fl_set <- sapply(scen@modInp@parameters, function(x) ((x@type == 'set') | (x@type == 'map')))
  set_list <- lapply(scen@modInp@parameters[fl_set], function(x) getParameterData(x))
  params <- lapply(scen@modInp@parameters[!fl_set], function(x) {
    gg <- getParameterData(x)
    for (i in colnames(gg)[!(colnames(gg) %in% c('type', 'value'))]) {
      gg[[i]] <- factor(gg[[i]]) # , levels = set_list[[i]]
    }
    if (!is.null(gg$type)) {
      gg$type <- factor(gg$type, levels = c('lo', 'up'))
    }
    gg
  })
  return(c(set_list, params))
}


.df2uels <- function(df, name = "x", value = "value") {
  # The function takes data frame or character vector and returns
  # named list for exporting to GDX-file using gdxrrw
  if (!is.data.frame(df)) {
    df <- data.frame(df)
    colnames(df) <- name
  }
  domains <- names(df)
  v = domains != value
  nr <- nrow(df)
  nc <- sum(v)
  if (all(v)) {
    type = "set"
  } else {
    type = "parameter"
  }
  df2val <- function(dd) {
    if (nrow(dd) > 0) {
      for(j in domains[v]) {
        dd[,j] <- as.numeric(dd[,j])
      }
      dd <- as.matrix(dd)
    } else {
      rr = nr
      if (type == "set") rr = 1
      dd <- matrix(1L, nrow = rr, ncol = length(v))
    }
    dd
  }
  if (nr > 0) {
    for(j in domains[v]) {
      df[,j] <- factor(df[,j]) # add levels from sets!
    }
    uels <- list(
      name = name,
      type = type,
      dim = nc,
      domains = domains[v],
      uels = lapply(domains[v], function(x) levels(df[,x])),
      val = df2val(df),
      form = "sparse"
    )  
  } else {
    uels <- list(
      name = name,
      type = type,
      dim = nc,
      domains = domains[v],
      uels = lapply(domains[v], function(x) "1"),
      val = df2val(df), #matrix(nrow = 0, ncol = nc),
      form = "sparse"
    )
  }
  return(uels)
}

.write_gdx_list <- function(dat, gdxName = "data.gdx") {
  # the function exports names list of sets and parameters 
  # to GDX file
  stopifnot("gdxrrw" %in% rownames(installed.packages()))
  #!!! need to check of `gdxrrw` is initialized
  cat("Writing to ", gdxName)
  nms <- names(dat)
  x <- list()
  for(i in nms) {
    x <- c(x, list(.df2uels(dat[[i]], i)))
  }
  gdxrrw::wgdx(gdxName = gdxName, x, squeeze = FALSE)
}

