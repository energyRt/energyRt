findDuplicates <- function(x) {
  findDuplicates0 <- function(x) {
    check_by_slots <- function(x, slt_name) {
      rs <- NULL
      for (i in slt_name) {
        slt <- slot(x, i)
        set_slot <- colnames(slt)[colnames(slt) %in% c('acomm', energyRt:::.set_al)]
        value_slot <- colnames(slt)[!(colnames(slt) %in% set_slot)]
        fl <- !is.na(slt[, value_slot, drop = FALSE])
        if (any(fl)) {
          for (j in value_slot[apply(fl, 2, any)]) {
            f2 <- duplicated(slt[fl[, j], set_slot, drop = FALSE])
            if (any(f2)) {
              rs <- rbind(rs, data.frame(slot = i, parameter = j, value = sum(f2), stringsAsFactors = FALSE))
            }
          }
        }
      }
      return(rs)
    }
    if (class(x) == 'scenario') 
      return(findDuplicates0(x@model))
    res <- data.frame(repository = character(), object = character(), slot = character(), parameter = character(), stringsAsFactors = FALSE)
    if (class(x) == 'model') {
      rs <- NULL
      for (i in seq_along(x@data)) {
        tmp <- findDuplicates0(x@data[[i]])
        if (!is.null(tmp)) {
          tmp$repository <- x@data[[i]]@name
          rs <- rbind(rs, tmp)
        }
      }
      tmp <- findDuplicates0(x@sysInfo)
      if (!is.null(tmp)) {
        tmp$repository <- '-'
        tmp$object <- 'sysInfo'
        rs <- rbind(rs, tmp[, c(ncol(tmp), 2:ncol(tmp) - 1)])
      }
      if (is.null(rs)) return(NULL)
      return(rs[, c(ncol(rs), 1:(ncol(rs) - 1))])
    } else
    if (class(x) == 'repository') {
      rs <- NULL
      for (i in seq_along(x@data)) {
        tmp <- findDuplicates0(x@data[[i]])
        if (!is.null(tmp)) {
          tmp$object <- x@data[[i]]@name
          rs <- rbind(rs, tmp)
        }
      }
      if (is.null(rs)) return(NULL)
      return(rs[, c(ncol(rs), 1:(ncol(rs) - 1))])
    } else
    if (class(x) %in% c('tax', 'sub', 'weather', 'supply', 'import', 'export', 'trade', 'technology', 'demand', 'storage')) {
      slt_name <- getSlots(class(x))
      slt_name <- names(slt_name)[slt_name == 'data.frame' & !(names(slt_name) %in% c('input', 'output', 'aux'))]
      return(check_by_slots(x, slt_name))
    } else if (class(x) %in% c('slice', 'constraint', 'commodity')) {
    } else if (class(x) %in% c('sysInfo')) {
      return(check_by_slots(x, c('debug', 'discount')))
    } else warning(paste0('Unknown class "', class(x), '"'))
    NULL
  }
  rs <- findDuplicates0(x)
  if (!is.null(rs)) {
    cat(paste0("There are ", nrow(rs), " duplication, total duplication ", sum(rs$value), "\n"))
    return(invisible(rs))
  }
    
}