setClass("trade",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # Details
          commodity     = "character",       # Vector if NULL that
          source        = "character",       # if NULL that in all region
          destination   = "character",       # if NULL that in all region
      # Performance parameters
          trade         = "data.frame",
          aux           = "data.frame",      #
          aeff         = "data.frame",    #  Commodity efficiency
      	invcost = "data.frame",
      	olife = "data.frame",
      	start = "data.frame",
      	end = "data.frame",
      	stock = "data.frame",
      	capacityVariable = "logical",
      	GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
      	cap2act       = "numeric",         #
      	misc = "list"
      ),
	# Default values and structure of slots
	prototype(
		# General information
		name           = "default_trade",       # Short name
		description    = "",
		commodity      = NULL,       #
		source         = character(),
		destination    = character(),
		trade          = data.frame(
			src        = character(),
			dst        = character(),
			year       = numeric(),
			slice      = character(),
			ava.up     = numeric(),
			ava.fx     = numeric(),
			ava.lo     = numeric(),
			cost       = numeric(),
			markup     = numeric(),
			teff        = numeric(),
			stringsAsFactors = FALSE),
		invcost = data.frame(
			src        = character(),
			dst        = character(),
			year       = numeric(),
			invcost    = numeric(),
			stringsAsFactors = FALSE),
		olife = data.frame(
			src        = character(),
			dst        = character(),
			olife    = numeric(),
			stringsAsFactors = FALSE),
		start = data.frame(
			src        = character(),
			dst        = character(),
			start    = numeric(),
			stringsAsFactors = FALSE),
		end = data.frame(
			src        = character(),
			dst        = character(),
			end    = numeric(),
			stringsAsFactors = FALSE),
		stock         = data.frame(
			src = character(),
			dst = character(),
			year  = integer(),
			stock = numeric(),
			stringsAsFactors = FALSE),
		capacityVariable = FALSE,
		aux           = data.frame(acomm     = character(),
			unit     = character(),
			stringsAsFactors = FALSE),
		# Auxilary parameter
		aeff          = data.frame(
			acomm      = character(),
			src     = character(),
			dst     = character(),
			year       = numeric(),
			slice      = character(),
			csrc2aout  = numeric(),
			csrc2ainp  = numeric(),
			cdst2aout  = numeric(),
			cdst2ainp  = numeric(),
			stringsAsFactors = FALSE),
		cap2act       = 1,         #
		GIS           = NULL,
		# slice = NULL,
		#! Misc
		misc = list(
		)),
	S3methods = TRUE
);
setMethod("initialize", "trade", function(.Object, ...) {
	.Object
})
