#' An S4 class to represent technology
#' 
#' @slot name A short name of the technology, also used in GAMS and GLPK
#' @slot description Detailed description
#' @slot type A character string to distinguish various types of technologies (optional)
#' @slot sector A character string to assotiate the technology with a particular sector (optional)
#' @slot enbal A reserved name to refer the technology to a certain part of energy balance (optional)
#' @slot color A color to represent the technology with graphical functions (in development)
#' @slot input 
#' unfinished...

setClass("technology",
      representation(
      # General information
        name          = "character",       # Short name
        description   = "character",       # description
        # type	        = "character",       # Optional
      	# sector	      = "character",       # Sector or Technology group - optional
      	# enbal         = "character",       # Which part of energy balance - (export, import, ...,
      	# transformation, consumption, ...
      	# color         = "data.table",      #
      	input         = "data.table",      #
      	output        = "data.table",      #
      	aux           = "data.table",      #
      	units         = "data.table",      #
      	group         = "data.table",      # groups units
      	cap2act       = "numeric",         #
      	# Performance parameters
      	geff          = "data.table",    #  Group efficiency
      	ceff          = "data.table",    #  Commodity efficiency
      	aeff          = "data.table",    #  Commodity efficiency
      	af            = "data.table",    #
      	afs           = "data.table",    #
      	weather       = "data.table",    # weather condisions multiplier
      	# Costs
      	fixom         = "data.table",    #
      	varom         = "data.table",    #
      	invcost       = "data.table",    #
      	# Market
      	start         = "data.table",    #
      	end           = "data.table",    #
      	olife         = "data.table",    #
      	# ucap          = "data.table",    # Capacity of one unit (for integer programming)
      	stock         = "data.table", #
      	early.retirement = "logical",
      	upgrade.technology = "character",
        fullYear         = "logical",
      	slice         = "character",
      	region        = "character",
        # GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
      	misc = "list"
      ), #
	# Default values and structure of slots
	prototype(
		name          = "",
		description   = "",
		# type	        = "",
		# sector	      = "",       # Sector or Technology group - optional
		# enbal         = "",       # Which part of energy balance - (export, import, ...,
		#region        = "",
		# color         = data.table(region   = character(),
			# color    = character(),
			# stringsAsFactors = FALSE),
		input         = data.table(comm     = character(),
			unit     = character(),
			group    = character(),  # may be factor or character?
			combustion = numeric(),
			stringsAsFactors = FALSE),
		output        = data.table(comm     = character(),
			unit     = character(),
			group    = character(),
			stringsAsFactors = FALSE),
		aux           = data.table(acomm     = character(),
			unit     = character(),
			stringsAsFactors = FALSE),
		units         = data.table(capacity = character(),
			use      = character(),
			activity = character(),
			costs    = character(),
			# varom    = character(),
			# fixom    = character(),
			# invcost  = character(),
			stringsAsFactors = FALSE),
		group        = data.table(
			group    = character(),
			description  = character(),  
			unit     = character(),
			#                                    inout     = factor(NULL, c('input', 'output')),
			stringsAsFactors = FALSE),
		cap2act       = 1,
		# group efficiency 
		geff         = data.table(region     = character(),
			year       = integer(),
			slice      = character(),
			group      = character(),
			ginp2use    = numeric(),  
			stringsAsFactors = FALSE),
		# commodity efficiency 
		ceff          = data.table(region     = character(),
			year       = integer(),
			slice      = character(),
			comm       = character(),
			# no groups
			cinp2use    = numeric(),  
			use2cact    = numeric(),  
			cact2cout    = numeric(), 
			cinp2ginp   = numeric(), 
			# shares within groups
			share.lo   = numeric(),
			share.up   = numeric(),
			share.fx   = numeric(),
			# afc
			afc.lo    = numeric(),
			afc.up    = numeric(),
			afc.fx    = numeric(),
			stringsAsFactors = FALSE),
		# Auxilary parameter
		aeff          = data.table(
			acomm      = character(),
			comm       = character(),
			region     = character(),
			year       = integer(),
			slice      = character(),
			cinp2ainp  = numeric(),
			cinp2aout  = numeric(),
			cout2ainp  = numeric(),
			cout2aout  = numeric(),
			act2ainp  = numeric(),
			act2aout  = numeric(),
			cap2ainp  = numeric(),
			cap2aout  = numeric(),
			ncap2ainp  = numeric(),
			ncap2aout  = numeric(),
			# storage part
			stg2ainp  = numeric(),
			sinp2ainp  = numeric(),
			sout2ainp  = numeric(),
			stg2aout  = numeric(),
			sinp2aout  = numeric(),
			sout2aout  = numeric(),
			stringsAsFactors = FALSE),
		af           = data.table(
			region   = character(),
			year     = integer(),
			slice    = character(),
			af.lo    = numeric(),
			af.up    = numeric(),
			af.fx    = numeric(),
			rampup    = numeric(),
			rampdown    = numeric(),
			stringsAsFactors = FALSE),
		afs          = data.table(region   = character(),
			year     = integer(),
			slice    = character(),
			afs.lo   = numeric(),
			afs.up   = numeric(),
			afs.fx   = numeric(),
			stringsAsFactors = FALSE),
		weather      = data.table(weather  = character(),
			comm     = character(),
			wafc.lo   = numeric(),
			wafc.up   = numeric(),
			wafc.fx   = numeric(),
			waf.lo    = numeric(),
			waf.up    = numeric(),
			waf.fx    = numeric(),
			wafs.lo   = numeric(),
			wafs.up   = numeric(),
			wafs.fx   = numeric(),
			stringsAsFactors = FALSE),
		fixom         = data.table(region   = character(),
			year     = integer(),
			fixom    = numeric(),
			stringsAsFactors = FALSE),
		varom         = data.table(region   = character(),
			year     = integer(),
			slice    = character(),
			comm     = character(),
			acomm      = character(),
			varom    = numeric(),
			cvarom   = numeric(),
			avarom   = numeric(),
			stringsAsFactors = FALSE),
		invcost       = data.table(region   = character(),
			year     = integer(),
			invcost  = numeric(),
			stringsAsFactors = FALSE),
		start         = data.table(region   = character(),
			start    = numeric(),
			stringsAsFactors = FALSE),
		end           = data.table(region   = character(),
			end      = numeric(),
			stringsAsFactors = FALSE),
		olife         = data.table(region = character(),
			olife = numeric(),
			stringsAsFactors = FALSE),
		# ucap          = data.table(region = character(),
		# 	year  = integer(),
		# 	ucap = numeric(),
		# 	stringsAsFactors = FALSE),
		stock         = data.table(region = character(),
			year  = integer(),
			stock = numeric(),
			stringsAsFactors = FALSE),
		early.retirement = TRUE,
		upgrade.technology = character(),
		region        = character(),
		slice         = character(),
    fullYear      = TRUE,
	  # GIS           = NULL,
		#! Misc
		misc = list(
		)),
	# validity = .check_technology_data_frame,
	S3methods = TRUE
)
setMethod("initialize", "technology", function(.Object, ...) {
	.Object
})

#---------------------------------------------------------------------------------------------------------
#! check_technology_data_frame <- function(x) : Check structure technology class (only data.table)
#---------------------------------------------------------------------------------------------------------
# .check_technology_data_frame <- function(object) {
#   # check technology data.table
#   g <- getClass('technology')
#   tec <- new('technology')
#   fl <- FALSE
#   for(z in names(g@slots)) {
#     if (g@slots[[z]] == 'data.table') {
#       u <- slot(tec, z)
#       b <- slot(object, z)
#       if (ncol(u) != ncol(b) || any(colnames(u) != colnames(b))) {
#         cat(z,'\n')
#         fl <- TRUE
#       }
#     }
#   }
#   if (fl) stop('Invalid technology object: Wrong data.table')
#   return(NULL)
# }
