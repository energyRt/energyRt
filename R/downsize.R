downsize <- function(scen) {
  rs <- find_null_column(scen)
  if (nrow(rs) == 0) return(scen)
  par_name <- grep('^pa', grep('^p', names(scen@modInp@parameters), value = TRUE), value = TRUE, invert = TRUE)
  rs$class <- gsub('technology', 'tech', rs$class)
  rs$class <- gsub('supply', 'sup', rs$class)
  # pDummyImportCost pDummyExportCost 
	for (i in seq_len(nrow(rs))) {
		grep(paste0('p', rs[i, 'class']), par_name, ignore.case = TRUE, value = TRUE)
		scen@modInp@parameters$pTechCvarom
	}
}


.find_null_column <- function(scen) {
	# Collect all class names
	# scn_class <- unique(c(sapply(scen@model@data, function(x) unique(sapply(x@data, class))), recursive = TRUE))
	scn_class <- c('supply', 'demand', 'export', 'import', 'trade', 'technology', 'tax', 'subs')
	rs <- NULL
	# Handle with class 
	for(cls in scn_class) {
		dtf <- getSlots(cls)[getSlots(cls) == 'data.frame']
		tmp <- new(cls)
		# Handle with class/slot
		for (jj in names(dtf)) {
				## Check if
				i <- 1
				fl <- colnames(slot(tmp, jj))[!sapply(slot(tmp, jj), is.numeric) | colnames(slot(tmp, jj)) == 'year']
				while (length(fl) != 0 && i <= length(scen@model@data)) {
					j <- 1
					while (length(fl) != 0 && j <= length(scen@model@data[[i]]@data)) {
						if (class(scen@model@data[[i]]@data) == cls) {
							#fl <- fl[apply(is.na(slot(scen@model@data[[i]]@data, jj)[, fl, drop = FALSE]), 2, all)]
						}
						j <- j + 1
					}
					i <- i + 1
				}
				if (length(fl) != 0)
					rs <- rbind(rs, data.frame(class = rep(cls, length(fl)), slot = rep(jj, length(fl)), col = fl))
		}
	}
	rs	
}
