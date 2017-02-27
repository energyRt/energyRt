# Fuel-mix functions


addGroups <- function(dt, 
                      mapping = list(), 
                      select = list(),
                      replace = FALSE,
                      aggregate = TRUE,
                      na.rm = TRUE,
                      zero.rm = TRUE
) {
  # Drop unused rows 
  if (length(select) > 0) {
    sDimNames <- names(select)
    sDimNames <- sDimNames[sapply(select, length) > 0] # Non-empty
    dimNames <- names(dt)
    dimNames <- dimNames[dimNames %in% sDimNames]
    for (dn in dimNames) {
      zz <- dt[, dn] %in% select[[dn]]
      dt <- dt[zz, ]
    }
  }
  # Add groups
  dimNames <- names(dt)
  gDimNames <- names(mapping)
  gDimNames <- gDimNames[sapply(mapping, length) > 0] # Non-empty
  dimNames <- dimNames[dimNames %in% gDimNames]
  for (dn in dimNames) {
    #      message(dn)
    gdim <- paste0("g", dn)
    #      message(gdim)
    if (replace) {
      if (any(gdim %in% names(dt))) {
        stop(paste(gdim, "already exists"))
      }}
    grNames <- names(mapping[[dn]])
    dt[, gdim] <- factor(NA, levels = c(grNames, NA), ordered = TRUE)
    for (gn in grNames) {
      #        message(mapping[[dn]][[gn]])
      #sapply(grNames, function(x) {
      for (x in grNames) {
        ii <-  dt[, dn] %in% mapping[[dn]][[gn]]
        #            message(sum(ii))
        dt[ii, gdim] <- gn
      }
      #})
    }
    na <- is.na(dt[, gdim])
    if(all(na)) {
      dt[, gdim] <- NULL
    } else if(aggregate) {
      dt[, dn] <- NULL
      # remove NAs in groups
      if (any(na) & na.rm) dt <- dt[!na, ]
    }
  }
  # Remove zeros
  if (zero.rm) dt <- dt[dt$value != 0, ]
  # Aggregate by groups
  if (aggregate) {
    dimNames <- names(dt)
    dimNames <- dimNames[dimNames != "value"]
    dt <- ungroup(dt)
    for (dn in dimNames) {
      dt <- dplyr::group_by_(dt, dn, add = TRUE)
    }
    dt <- summarize(dt, value = sum(value))
  }
  # dt <- dplyr::group_by_(dt, "year", "gtech") %>% 
  #       dplyr::summarize(value = sum(value))
  
  # Drop NA's
  
  return(dt)
}

ggplot_bar_by_gtech <- function(
  scen,
  variable,
  comm,
  mapping,
  select, 
  colours,
  ...) {
  
  get_data <- "getData_"
  if (length(comm) > 1) get_data <- "getData"
  if (length(variable) > 1) get_data <- "getData"
  
  dat <- eval(call(get_data, scen, variable = variable, comm = comm, 
                  get.parameter = F, merge.table = T, drop = F, remove_zero_dim = T))
  
  dat <- addGroups(dat, mapping, select, zero.rm = T, na.rm = T)
  
  a <- ggplot(dat, aes(x = year, y = value, fill = gtech)) + 
    geom_col() 
  #  + 
  #  scale_fill_manual(values=cbPalette)
  #  scale_fill_brewer()
  #  scale_fill_brewer(palette="Paired")
  if (!is.null(colours)) {
    a <- a + scale_fill_manual(values=colours)
  }
  return(a)
}

ggplot_bar_by_gcomm <- function(
  scen,
  variable,
  comm,
  mapping,
  select,
  colours,
  ...) {
  
  get_data <- "getData_"
  if (length(comm) > 1) get_data <- "getData"
  if (length(variable) > 1) get_data <- "getData"
  
  dat <- eval(call(get_data, scen, variable = variable, comm = comm, 
                  get.parameter = F, merge.table = T, drop = F, remove_zero_dim = T))
  
  dat <- addGroups(dat, mapping, select, zero.rm = T, na.rm = T)
  
  a <- ggplot(dat, aes(x = year, y = value, fill = gcomm)) + 
    geom_col() 
  #  + 
  #  scale_fill_manual(values=cbPalette)
  #  scale_fill_brewer()
  #  scale_fill_brewer(palette="Paired")
  if (!is.null(colours)) {
    a <- a + scale_fill_manual(values=colours)
  }
  return(a)
}

