getData.model <- function() {
  gh <- new('modInp')@parameters
  gh <- gh[sapply(gh, function(x) !is.null(x@misc$class))]
  psb_set <-data.frame(name = sapply(gh, function(x) x@name), type = sapply(gh, function(x) x@type), 
    class = sapply(gh, function(x) x@misc$class), column = sapply(gh, function(x) gsub('[.].*', '', x@colName[1])), 
                       stringsAsFactors = FALSE)
  psb_set$slot <- NA
  ff <- unique(psb_set$class); 
  cl <- lapply(ff, function(x) new(x)); names(cl) <- ff
  sl <- lapply(ff, function(x) getSlots(x)); names(sl) <- ff
  psb_set <- psb_set[psb_set$type %in% c('simple', 'multi'),, drop = FALSE]
  for(i in 1:nrow(psb_set)) {
    if (!is.null(gh[[psb_set[i, 'name']]]@misc$slot)) {
      psb_set[i, 'slot'] <- gh[[psb_set[i, 'name']]]@misc$slot 
    } else if (any(psb_set[i, 'column'] == c('tax', 'subs', 'rhs'))) {
      psb_set[i, 'slot'] <- 'rhs'
    } else {
      cc <- psb_set[i, 'class']
      hh <- names(sl[[cc]])[sl[[cc]] == 'data.frame']
      hh <- hh[!(hh %in% c('interpolation', 'defVal', 'units'))]
      if (psb_set[i, 'type'] == 'simple')  mm <- psb_set[i, 'column'] else mm <- paste(psb_set[i, 'column'], '.lo', sep = '')
      psb_set[i, 'slot'] <- hh[sapply(hh, function(x) any(colnames(slot(cl[[cc]], x)) == mm))]
    }
  }
  NULL
}