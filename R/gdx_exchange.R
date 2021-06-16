.get_scen_data <- function(scen) {
  all_factor <- function(x) {
    for (i in colnames(x)[colnames(x) != 'value'])
      x[[i]] <- factor(x[[i]])
    x
  }
  gg <- list()
  for (i in names(scen@modInp@parameters)) {
    if (scen@modInp@parameters[[i]]@type != 'multi') {
      gg[[i]] <- all_factor(.get_data_slot(scen@modInp@parameters[[i]]))
    } else {
      tmp <- .get_data_slot(scen@modInp@parameters[[i]])
      gg[[paste0(i, 'Lo')]] <- all_factor(tmp[tmp$type == 'lo', colnames(tmp) != 'type', drop = FALSE])
      gg[[paste0(i, 'Up')]] <- all_factor(tmp[tmp$type == 'up', colnames(tmp) != 'type', drop = FALSE])
    }
    gg
  }
  return(gg)
}

.df2uels <- function(df, name = "x", value = "value") {
  # The function takes data.frame or character vector and returns
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
  # the function exports named list of sets and parameters to GDX file
  stopifnot("gdxrrw" %in% rownames(installed.packages()))
  cat(" data.gdx ")
  nms <- names(dat)
  max_length <- max(nchar(nms))
  x <- list()
  wipe <- ""
  for(i in nms){
    cat(wipe, "(", i, ")", rep(" ", max_length - nchar(i) + 1), sep = "")
    wipe <- paste0(rep("\b", max_length + 3), collapse = "")
    x <- c(x, list(.df2uels(dat[[i]], i)))
  } 
  gdxrrw::wgdx(gdxName = gdxName, x, squeeze = FALSE)
  cat(wipe, sep = "")
  cat(rep(" ", max_length + 3), sep = "")
  cat(rep(" ", max_length + 3), sep = "")
  cat(wipe, wipe, "\b, ", utils:::format.object_size(file.size(gdxName), "auto"), ", ", sep = "")
}

.write_sqlite_list <- function(dat, sqlFile = "data.db") {
  cat(basename(sqlFile), " ", sep = "")
  tStart <- Sys.time()
  if (file.exists(sqlFile)) file.remove(sqlFile)
  con <- DBI::dbConnect(RSQLite::SQLite(), sqlFile)
  # DBI::dbListTables(con)
  nms <- names(dat)
  max_length <- max(nchar(nms))
  wipe <- ""
  for(i in nms) {
    cat(wipe, "(", i, ")", rep(" ", max_length - nchar(i) + 1), sep = "")
    wipe <- paste0(rep("\b", max_length + 3), collapse = "")
    # cat(wipe, i, rep(" ", 10), sep = "")
    # wipe <- paste0(rep("\b", nchar(i) + 10), collapse = "")
    DBI::dbWriteTable(con, i, dat[[i]], overwrite = TRUE)
  }
  DBI::dbDisconnect(con)
  # finf <- file.info(sqlFile)
  # format(finf["size"])
  cat(wipe, sep = "")
  cat(rep(" ", max_length + 3), sep = "")
  cat(rep(" ", max_length + 3), sep = "")
  cat(wipe, wipe, "\b, ", utils:::format.object_size(file.size(sqlFile), "auto"), ", ", sep = "")
  # cat(format(round(Sys.time() - tStart), 1))
}
