#' An S4 class to represent model input
#'
#' @slot set list. 
#' @slot parameters list. 
#' @slot modelVersion character. 
#' @slot solver character. 
#' @slot gams.equation list. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
#' 
setClass("modInp", 
  representation(
    set = "list", # @sets List with set : tech, sup, group, comm, region, year, slice
    parameters = "list", # @parameters List with techology parameter
    modelVersion        = "character",
    solver              = "character",
    gams.equation  = 'list',
    costs.equation = 'character',
    misc = "list"
  ),
  prototype(
    set = list(),
    parameters     = list(),
    modelVersion   = "",
    solver         = "",
    gams.equation  = list(),
    costs.equation = character(),
    #! Misc
    misc = list(
    )
  )
)

#### Constructor ####
# !!! optimize - rewrite using array
setMethod("initialize", "modInp",
  function(.Object) {
    x <- .Object@parameters
    # sets ####
    x[['region']] <- newSet('region')    
    x[['year']]   <- newSet('year')    
    x[['slice']]  <- newSet('slice')    
    x[['comm']]   <- newSet('comm')    
    x[['sup']]    <- newSet('sup')    
    x[['dem']]    <- newSet('dem')    
    x[['tech']]   <- newSet('tech')    
    x[['group']]  <- newSet('group')    
    x[['stg']]    <- newSet('stg')    
    x[['expp']]   <- newSet('expp')    
    x[['imp']]    <- newSet('imp')    
    x[['trade']]  <- newSet('trade')    

    # weather ####
    x[['weather']] <- newSet('weather')
    x[['pWeather']] <- 
      newParameter('pWeather', c('weather', 'region', 'year', 'slice'), 
                   'simple', defVal = 1, interpolation = 'back.inter.forth', 
                   colName = 'wval', cls = 'weather')    
    x[['mWeatherSlice']] <- newParameter('mWeatherSlice', c('weather', 'slice'), 'map')
    x[['mWeatherRegion']] <- newParameter('mWeatherRegion', c('weather', 'region'), 'map')
    x[['mSupWeatherLo']] <- newParameter('mSupWeatherLo', c('weather', 'sup'), 'map')
    x[['mSupWeatherUp']] <- newParameter('mSupWeatherUp', c('weather', 'sup'), 'map')
    x[['mTechWeatherAfLo']] <- newParameter('mTechWeatherAfLo', c('weather', 'tech'), 'map')
    x[['mTechWeatherAfUp']] <- newParameter('mTechWeatherAfUp', c('weather', 'tech'), 'map')
    x[['mTechWeatherAfsLo']] <- newParameter('mTechWeatherAfsLo', c('weather', 'tech'), 'map')
    x[['mTechWeatherAfsUp']] <- newParameter('mTechWeatherAfsUp', c('weather', 'tech'), 'map')
    x[['mTechWeatherAfcLo']] <- newParameter('mTechWeatherAfcLo', c('weather', 'tech', 'comm'), 'map')
    x[['mTechWeatherAfcUp']] <- newParameter('mTechWeatherAfcUp', c('weather', 'tech', 'comm'), 'map')
    x[['mStorageWeatherAfLo']] <- newParameter('mStorageWeatherAfLo', c('weather', 'stg'), 'map')
    x[['mStorageWeatherAfUp']] <- newParameter('mStorageWeatherAfUp', c('weather', 'stg'), 'map')
    x[['mStorageWeatherCinpUp']] <- newParameter('mStorageWeatherCinpUp', c('weather', 'stg'), 'map')
    x[['mStorageWeatherCinpLo']] <- newParameter('mStorageWeatherCinpLo', c('weather', 'stg'), 'map')
    x[['mStorageWeatherCoutUp']] <- newParameter('mStorageWeatherCoutUp', c('weather', 'stg'), 'map')
    x[['mStorageWeatherCoutLo']] <- newParameter('mStorageWeatherCoutLo', c('weather', 'stg'), 'map')
    x[['pSupWeather']] <- 
      newParameter('pSupWeather', c('weather', 'sup'), 'multi',
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pTechWeatherAf']] <- 
      newParameter('pTechWeatherAf', c('weather', 'tech'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pTechWeatherAfs']] <- 
      newParameter('pTechWeatherAfs', c('weather', 'tech'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pTechWeatherAfc']] <-
      newParameter('pTechWeatherAfc', c('weather', 'tech', 'comm'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pStorageWeatherAf']] <- 
      newParameter('pStorageWeatherAf', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pStorageWeatherCinp']] <- 
      newParameter('pStorageWeatherCinp', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['pStorageWeatherCout']] <- 
      newParameter('pStorageWeatherCout', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    x[['mSliceNext']] <- newParameter('mSliceNext', c('slice', 'slicep'), 'map')    
    x[['mSliceFYearNext']] <- newParameter('mSliceFYearNext', c('slice', 'slicep'), 'map')    
    x[['mSameRegion']] <- newParameter('mSameRegion', c('region', 'regionp'), 'map') # for glpk    
    x[['mSameSlice']] <- newParameter('mSameSlice', c('slice', 'slicep'), 'map') # for glpk    
    x[['ordYear']] <- newParameter('ordYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    x[['cardYear']] <- newParameter('cardYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    x[['pPeriodLen']] <- newParameter('pPeriodLen', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    # commodity ####
    ### mapping 
    x[['mUpComm']] <- newParameter('mUpComm', 'comm', 'map')    
    x[['mLoComm']] <- newParameter('mLoComm', 'comm', 'map')    
    x[['mFxComm']] <- newParameter('mFxComm', 'comm', 'map')    
    # slice ####
    x[['mExpSlice']] <- newParameter('mExpSlice', c('expp', 'slice'), 'map', cls = 'export')   
    x[['mImpSlice']] <- newParameter('mImpSlice', c('imp', 'slice'), 'map', cls = 'import')   
    x[['mTechSlice']] <- newParameter('mTechSlice', c('tech', 'slice'), 'map', cls = 'technology')   
    x[['mSupSlice']] <- newParameter('mSupSlice', c('sup', 'slice'), 'map', cls = 'supply')   
    x[['mStorageFullYear']] <- 
      newParameter('mStorageFullYear', c('stg'), 'map', cls = 'storage')   
    x[['mTradeSlice']] <- 
      newParameter('mTradeSlice', c('trade', 'slice'), 'map', cls = 'trade')   
    x[['mCommSlice']] <- 
      newParameter('mCommSlice', c('comm', 'slice'), 'map', cls = 'commodity')   
    x[['mCommSliceOrParent']] <- 
      newParameter('mCommSliceOrParent', c('comm', 'slice', 'slicep'), 
                   'map', cls = 'commodity')   
    x[['mSliceParentChildE']] <- 
      newParameter('mSliceParentChildE', c('slice', 'slicep'), 'map')   
    x[['mSliceParentChild']] <- 
      newParameter('mSliceParentChild', c('slice', 'slicep'), 'map')   
    # simple
    x[['pSliceShare']] <- 
      newParameter('pSliceShare', 'slice', 'simple')   
    x[['pEmissionFactor']] <- 
    	newParameter('pEmissionFactor', c('comm', 'commp'), 'simple',  #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity', 
    		colName = 'emis', slot = 'emis')    
    x[['pAggregateFactor']] <- 
    	newParameter('pAggregateFactor', c('comm', 'commp'), 'simple', #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity') #, colName = 'agg', slot = 'agg')    
    # demand ####
    # mapping
    x[['mDemComm']] <- 
    	newParameter('mDemComm', c('dem', 'comm'), 'map', cls = 'demand')    
    x[['pDemand']] <- 
    	newParameter('pDemand', c('dem', 'comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = 0, interpolation = 'back.inter.forth', 
    	             colName = 'dem', cls = 'demand', slot = 'dem')
    # dummy import ####
    x[['pDummyImportCost']] <- 
    	newParameter('pDummyImportCost', c('comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = Inf, interpolation = 'back.inter.forth', 
    	             colName = 'dummyImport', cls = 'sysInfo', slot = 'debug')    
    # dummy export ####
    x[['pDummyExportCost']] <- 
    	newParameter('pDummyExportCost', c('comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = Inf, interpolation = 'back.inter.forth', 
    	             colName = 'dummyExport', cls = 'sysInfo', slot = 'debug')    
    for (ii in c('Inp', 'Out', 'Bal')) {
	    # tax ####
	    x[[paste0('pTaxCost', ii)]] <- 
	    	newParameter(paste0('pTaxCost', ii), c('comm', 'region', 'year', 'slice'), 'simple', 
	    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'tax', slot = 'tax')    
	    # subsidy ####
	    x[[paste0('pSubCost', ii)]] <- 
	    	newParameter(paste0('pSubCost', ii), c('comm', 'region', 'year', 'slice'), 'simple', 
	    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'sub', slot = 'subs')    
    }
    # supply ####
    # mapping
    x[['mSupComm']] <- 
    	newParameter('mSupComm', c('sup', 'comm'), 'map', cls = 'supply')    
    x[['mSupSpan']] <- 
      newParameter('mSupSpan', c('sup', 'region'), 'map')    
    x[['mvSupCost']] <- 
      newParameter('mvSupCost', c('sup', 'region', 'year'), 'map')    
    # simple parameters
    x[['pSupCost']] <- 
    	newParameter('pSupCost', c('sup', 'comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = 0, interpolation = 'back.inter.forth', 
    	             colName = 'cost', cls = 'supply', slot = 'availability')    
    x[['pSupReserve']] <- 
    	newParameter('pSupReserve', c('sup', 'comm', 'region'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'supply', 
    		slot = 'reserve', colName = c('res.lo', 'res.up'))
    # multi parameters
    x[['pSupAva']] <- 
    	newParameter('pSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 
    	             'multi', defVal = c(0, Inf), interpolation = 'back.inter.forth', 
    	             colName = c('ava.lo', 'ava.up'), cls = 'supply', slot = 'availability')    
    # technology ####
    # mapping
    for(i in c('mTechInpComm', 'mTechOutComm', 'mTechOneComm', 
               'mTechAInp', 'mTechAOut'))
    	x[[i]] <- newParameter(i, c('tech', 'comm'), 
    	                                        'map', cls = 'technology')    
    for(i in c('mTechInpGroup', 'mTechOutGroup'))
    	x[[i]] <- newParameter(i, c('tech', 'group'), 
    	                                        'map', cls = 'technology')    
    x[['mTechGroupComm']] <- 
      newParameter('mTechGroupComm', c('tech', 'group', 'comm'), 
                   'map', cls = 'technology')    
    x[['mTechUpgrade']] <- 
      newParameter('mTechUpgrade', c('tech', 'techp'), 'map', cls = 'technology')    
    x[['mTechRetirement']] <- 
      newParameter('mTechRetirement', c('tech'), 'map', cls = 'technology')    
    # For disable technology with unexceptable start year
    x[['mTechNew']] <- newParameter('mTechNew', c('tech', 'region', 'year'), 
                                                     'map', cls = 'technology')    
    x[['mTechInv']] <- newParameter('mTechInv', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    x[['mTechSpan']] <- newParameter('mTechSpan', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    x[['meqTechRetiredNewCap']] <- newParameter('meqTechRetiredNewCap', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    x[['mTechOMCost']] <- newParameter('mTechOMCost', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    x[['mTechEac']] <- newParameter('mTechEac', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    
	x[['mTechAct2AInp']] <- newParameter('mTechAct2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCap2AInp']] <- newParameter('mTechCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechNCap2AInp']] <- newParameter('mTechNCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCinp2AInp']] <- newParameter('mTechCinp2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCout2AInp']] <- newParameter('mTechCout2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechAct2AOut']] <- newParameter('mTechAct2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCap2AOut']] <- newParameter('mTechCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechNCap2AOut']] <- newParameter('mTechNCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCinp2AOut']] <- newParameter('mTechCinp2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	x[['mTechCout2AOut']] <- newParameter('mTechCout2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     

    # simple & multi
    x[['pTechCap2act']] <- 
    	newParameter('pTechCap2act', 'tech', 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', cls = 'technology')#, colName = 'cap2act', slot = 'cap2act')    
    x[['pTechEac']] <- 
      newParameter('pTechEac', c('tech', 'region', 'year'), 'simple', 
        defVal = 0, interpolation = 'back.inter.forth', cls = 'technology', colName = 'invcost')
    x[['pTechEmisComm']] <- newParameter('pTechEmisComm', c('tech', 'comm'), 'simple', 
    	defVal = 1, cls = 'technology', colName = 'combustion')    
    x[['pTechOlife']] <- 
    	newParameter('pTechOlife', c('tech', 'region'), 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'technology', slot = 'cap2act')          
    x[['pTechFixom']] <- newParameter('pTechFixom', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'technology')    
    x[['pTechInvcost']] <- newParameter('pTechInvcost', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'technology')    
    x[['pTechStock']] <- newParameter('pTechStock', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'technology')    
    x[['pTechVarom']] <- newParameter('pTechVarom', 
    	c('tech', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'varom', cls = 'technology')    
    #
    x[['pTechAf']] <- 
    	newParameter('pTechAf', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), 
    		interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'technology')    
    #
    x[['pTechAfs']] <- 
    	newParameter('pTechAfs', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 0), 
    		interpolation = 'back.inter.forth', colName = c('afs.lo', 'afs.up'), cls = 'technology')    
    x[['pTechGinp2use']] <- newParameter('pTechGinp2use', 
    	c('tech', 'group', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'ginp2use', cls = 'technology')    
    x[['pTechCinp2ginp']] <- newParameter('pTechCinp2ginp', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2ginp', cls = 'technology')    
    x[['pTechUse2cact']] <- newParameter('pTechUse2cact', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'use2cact', cls = 'technology')    
    # auxiliary commodity ####
    x[['pTechAct2AInp']] <- newParameter('pTechAct2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2ainp', cls = 'technology')    
    x[['pTechCap2AInp']] <- newParameter('pTechCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2ainp', cls = 'technology')    
    x[['pTechAct2AOut']] <- newParameter('pTechAct2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2aout', cls = 'technology')    
    x[['pTechCap2AOut']] <- newParameter('pTechCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    x[['pTechNCap2AInp']] <- newParameter('pTechNCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    x[['pTechNCap2AOut']] <- newParameter('pTechNCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    x[['pTechCinp2AInp']] <- newParameter('pTechCinp2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2ainp', cls = 'technology')    
    x[['pTechCout2AInp']] <- newParameter('pTechCout2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2ainp', cls = 'technology')    
    x[['pTechCinp2AOut']] <- newParameter('pTechCinp2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2aout', cls = 'technology')    
    x[['pTechCout2AOut']] <- newParameter('pTechCout2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2aout', cls = 'technology')    
    
    # Aux stop
    x[['pTechCact2cout']] <- newParameter('pTechCact2cout', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cact2cout', cls = 'technology')    
    x[['pTechCinp2use']] <- newParameter('pTechCinp2use', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2use', cls = 'technology')  
    x[['pTechCvarom']] <- newParameter('pTechCvarom', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cvarom', cls = 'technology')    
    x[['pTechAvarom']] <- newParameter('pTechAvarom', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'avarom', cls = 'technology')    
    x[['pTechShare']] <- newParameter('pTechShare', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), interpolation = 'back.inter.forth', 
    	colName = c('share.lo', 'share.up'), cls = 'technology')    
    x[['pTechAfc']] <- newParameter('pTechAfc', c('tech', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', colName = c('afc.lo', 'afc.up'), cls = 'technology')
    
    ## !!! SET ALIAS FOR SYS INFO
    # reserve ####
    x[['mStorageComm']] <- newParameter('mStorageComm', c('stg', 'comm'), 'map')    
    # simple & multi
    x[['pStorageOlife']] <- newParameter('pStorageOlife', 
    	c('stg', 'region'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'storage')    
    x[['pStorageStock']] <- newParameter('pStorageStock', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'storage')    
    x[['pStorageFixom']] <- newParameter('pStorageFixom', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'storage')    
    x[['pStorageInvcost']] <- newParameter('pStorageInvcost', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    x[['pStorageEac']] <- newParameter('pStorageEac', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    
  	x[['pStorageInpEff']] <- newParameter('pStorageInpEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'inpeff', cls = 'storage')    
  	x[['pStorageOutEff']] <- newParameter('pStorageOutEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'outeff', cls = 'storage')    
  	x[['pStorageStgEff']] <- newParameter('pStorageStgEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'stgeff', cls = 'storage')    
 
    x[['pStorageCostStore']] <- newParameter('pStorageCostStore', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'stgcost', cls = 'storage')    
    x[['pStorageCostInp']] <- newParameter('pStorageCostInp', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'inpcost', cls = 'storage')    
    x[['pStorageCostOut']] <- newParameter('pStorageCostOut', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'outcost', cls = 'storage')    
  	   	
    x[['pStorageAf']] <- newParameter('pStorageAf', c('stg', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, 1), interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'storage')
    
    x[['pStorageCap2stg']] <- newParameter('pStorageCap2stg', 'stg', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'storage')#, colName = 'cap2stg', slot = 'cap2stg')    
    x[['pStorageCinp']] <- newParameter('pStorageCinp', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    x[['pStorageCout']] <- newParameter('pStorageCout', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    x[['mStorageNew']] <- newParameter('mStorageNew', c('stg', 'region', 'year'), 'map')    
    x[['mStorageSpan']] <- newParameter('mStorageSpan', c('stg', 'region', 'year'), 'map')    
    x[['mStorageEac']] <- newParameter('mStorageEac', c('stg', 'region', 'year'), 'map')    
    x[['mStorageOMCost']] <- newParameter('mStorageOMCost', c('stg', 'region', 'year'), 'map')    
    
    x[['mStorageAInp']] <- newParameter('mStorageAInp', c('stg', 'comm'), 'map', cls = 'storage')    
    x[['mStorageAOut']] <- newParameter('mStorageAOut', c('stg', 'comm'), 'map', cls = 'storage')    
    stg_tmp <- c('pStorageStg2AInp' = 'stg2ainp', 'pStorageStg2AOut' = 'stg2aout', 'pStorageCinp2AInp' = 'cinp2ainp', 'pStorageCinp2AOut' = 'cinp2aout', 
    	'pStorageCout2AInp' = 'cout2ainp', 
				'pStorageCout2AOut' = 'cout2aout', 'pStorageCap2AInp' = 'cap2ainp', 'pStorageCap2AOut' = 'cap2aout', 'pStorageNCap2AInp' = 'ncap2ainp', 'pStorageNCap2AOut' = 'ncap2aout')
    for(i in c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 
    	'pStorageCout2AInp', 'pStorageCout2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 
    	'pStorageNCap2AInp', 'pStorageNCap2AOut'))
      x[[i]] <- newParameter(i, c('stg', 'acomm', 'region', 'year', 'slice'), 'simple', 
                                                 defVal = 0, interpolation = 'back.inter.forth', cls = 'storage', colName = stg_tmp[i])    
    x[['pStorageNCap2Stg']] <- newParameter('pStorageNCap2Stg', 
                 c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'ncap2stg')    
    x[['pStorageCharge']] <- newParameter('pStorageCharge', 
              c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'charge')    
    for (i in c('mStorageStg2AOut', 'mStorageCinp2AOut', 'mStorageCout2AOut', 'mStorageCap2AOut', 'mStorageNCap2AOut', 'mStorageStg2AInp', 'mStorageCinp2AInp', 
    	'mStorageCout2AInp', 'mStorageCap2AInp', 'mStorageNCap2AInp'))
    		x[[i]] <- newParameter(i, c('stg', 'comm', 'region', 'year', 'slice'), 'map', cls = 'storage')    


    # trade ####
    # mapping
    x[['mTradeIrAInp']] <- newParameter('mTradeIrAInp', c('trade', 'comm'), 'map', cls = 'trade')   
    x[['mTradeIrAOut']] <- newParameter('mTradeIrAOut', c('trade', 'comm'), 'map', cls = 'trade')   
    x[['mExpComm']] <- 
    	newParameter('mExpComm', c('expp', 'comm'), 'map', cls = 'trade')    
    x[['mImpComm']] <- 
    	newParameter('mImpComm', c('imp', 'comm'), 'map', cls = 'trade')    
    x[['mTradeComm']] <- 
    	newParameter('mTradeComm', c('trade', 'comm'), 'map', cls = 'trade')    
    drt1 <- c('pTradeIrCsrc2Aout', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Aout', 'pTradeIrCdst2Ainp')
    drt2 <- c(        'csrc2aout',         'csrc2ainp',         'cdst2aout',         'cdst2ainp')
    for (i in seq_along(drt1))
    	x[[drt1[i]]] <- newParameter(drt1[i], c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = drt2[i])    
    
    x[['pTradeIrCost']] <- newParameter('pTradeIrCost', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cost')    
    x[['pTradeIrEff']] <- newParameter('pTradeIrEff', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'teff')    
    x[['pTradeIrMarkup']] <- newParameter('pTradeIrMarkup', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'markup')    
    x[['pExportRowPrice']] <- newParameter('pExportRowPrice', 
    	c('expp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'export', colName = 'price')    
    x[['pImportRowPrice']] <- newParameter('pImportRowPrice', 
    	c('imp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'import', colName = 'price')    
    x[['pTradeIr']] <- newParameter('pTradeIr', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'trade', colName = c('ava.lo', 'ava.up'))
    x[['pExportRow']] <- newParameter('pExportRow', 
    	c('expp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'export', colName = c('exp.lo', 'exp.up'))
    x[['pImportRow']] <- newParameter('pImportRow', 
    	c('imp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'import', colName = c('imp.lo', 'imp.up'))
    x[['pExportRowRes']] <- newParameter('pExportRowRes', 
    	'expp', 'simple',  defVal = 0, interpolation = 'back.inter.forth')#, cls = 'export', slot = 'reserve', colName = 'reserve')
    x[['pImportRowRes']] <- newParameter('pImportRowRes', 'imp', 'simple',  defVal = 0, interpolation = 'back.inter.forth') #, cls = 'import', slot = 'reserve', colName = 'reserve')
    # For LEC
    x[['mLECRegion']] <- newParameter('mLECRegion', 'region', 'map')    
    x[['pLECLoACT']] <- 
    	newParameter('pLECLoACT', 'region', 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth')    
    
    
    # other/system ####
    # discount ####
    x[['pDiscount']] <- 
    	newParameter('pDiscount', c('region', 'year'), 'simple', 
    		defVal = .1, interpolation = 'back.inter.forth', colName = 'discount', cls = 'sysInfo')    
    # Additional for compatibility 
    x[['pDiscountFactor']] <- newParameter('pDiscountFactor', c('region', 'year'), 'simple')
    x[['pDiscountFactorMileStone']] <- newParameter('pDiscountFactorMileStone', c('region', 'year'), 'simple')
    
    x[['mDiscountZero']] <- newParameter('mDiscountZero', 'region', 'map', defVal = 1) 
    ## milestone set ####
    x[['mMidMilestone']] <- newParameter('mMidMilestone', 'year', 'map', defVal = 1) 
    x[['mMilestoneHasNext']] <- newParameter('mMilestoneHasNext', 'year', 'map', defVal = 1) 
    x[['mMilestoneFirst']] <- newParameter('mMilestoneFirst', 'year', 'map', defVal = 1) 
    x[['mMilestoneLast']] <- newParameter('mMilestoneLast', 'year', 'map', defVal = 1) 
    x[['mStartMilestone']] <- newParameter('mStartMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    x[['mEndMilestone']] <- newParameter('mEndMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    x[['mMilestoneNext']] <- newParameter('mMilestoneNext', c('year', 'yearp'), 'map', defVal = 1) 
    ## mapping ####
    x[['mTechInpTot']] <- newParameter('mTechInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mTechOutTot']] <- newParameter('mTechOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mEmsFuelTot']] <- newParameter('mEmsFuelTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mTechEmsFuel']] <- newParameter('mTechEmsFuel', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mAggregateFactor']] <- newParameter('mAggregateFactor', c('comm', 'comm'), 'map') 
    x[['mDummyImport']] <- newParameter('mDummyImport', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mDummyExport']] <- newParameter('mDummyExport', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mDummyCost']] <- newParameter('mDummyCost', c('comm', 'region', 'year'), 'map') 
    x[['mTradeIr']] <- newParameter('mTradeIr', c('trade', 'src', 'dst', 'year', 'slice'), 'map') 
    x[['mvTradeIrAInp']] <- newParameter('mvTradeIrAInp', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTradeIrAOut']] <- newParameter('mvTradeIrAOut', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTradeIrAInpTot']] <- newParameter('mvTradeIrAInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTradeIrAOutTot']] <- newParameter('mvTradeIrAOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    x[['mTradeIrCsrc2Ainp']] <- newParameter('mTradeIrCsrc2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    x[['mTradeIrCdst2Ainp']] <- newParameter('mTradeIrCdst2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    x[['mTradeIrCsrc2Aout']] <- newParameter('mTradeIrCsrc2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    x[['mTradeIrCdst2Aout']] <- newParameter('mTradeIrCdst2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 

    x[['mImportRow']] <- newParameter('mImportRow', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mExportRow']] <- newParameter('mExportRow', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mImportRowUp']] <- newParameter('mImportRowUp', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mExportRowUp']] <- newParameter('mExportRowUp', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mImportRowAccumulatedUp']] <- newParameter('mImportRowAccumulatedUp', c('imp', 'comm'), 'map') 
    x[['mExportRowAccumulatedUp']] <- newParameter('mExportRowAccumulatedUp', c('expp', 'comm'), 'map') 
    
    x[['mExport']] <- newParameter('mExport', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mImport']] <- newParameter('mImport', c('comm', 'region', 'year', 'slice'), 'map') 
    
    x[['mStorageInpTot']] <- newParameter('mStorageInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mStorageOutTot']] <- newParameter('mStorageOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    x[['mTaxCost']] <- newParameter('mTaxCost', c('comm', 'region', 'year'), 'map') 
    x[['mSubCost']] <- newParameter('mSubCost', c('comm', 'region', 'year'), 'map') 
    x[['mAggOut']] <- newParameter('mAggOut', c('comm', 'region', 'year', 'slice'), 'map') 
    
    x[['mSupOutTot']] <- newParameter('mSupOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mSupAvaUp']] <- newParameter('mSupAvaUp', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mSupAva']] <- newParameter('mSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mSupReserveUp']] <- newParameter('mSupReserveUp', c('sup', 'comm', 'region'), 'map') 
    
    x[['mTechAfUp']] <- newParameter('mTechAfUp', c('tech', 'region', 'year', 'slice'), 'map') 
    x[['mTechAfcUp']] <- newParameter('mTechAfcUp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mTechOlifeInf']] <- newParameter('mTechOlifeInf', c('tech', 'region'), 'map') 
    x[['mStorageOlifeInf']] <- newParameter('mStorageOlifeInf', c('stg', 'region'), 'map') 
    
    x[['mInp2Lo']] <- newParameter('mInp2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mOut2Lo']] <- newParameter('mOut2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    
    # trade capacity data ####
    # To start year 
    x[['mTradeSpan']] <- newParameter('mTradeSpan', c('trade', 'year'), 'map', cls = 'trade')    
    x[['mTradeNew']] <- newParameter('mTradeNew', c('trade', 'year'), 'map', cls = 'trade')    
    x[['mTradeOlifeInf']] <- newParameter('mTradeOlifeInf', c('trade'), 'map', cls = 'trade')    
    x[['mTradeCapacityVariable']] <- newParameter('mTradeCapacityVariable', 'trade', 'map', cls = 'trade')    
    x[['mTradeRoutes']] <- newParameter('mTradeRoutes', c('trade', 'src', 'dst'), 'map', cls = 'trade')    
    x[['mTradeInv']] <- newParameter('mTradeInv', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    x[['mTradeEac']] <- newParameter('mTradeEac', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    
    x[['pTradeStock']] <- newParameter('pTradeStock', c('trade', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'trade')    
    x[['pTradeOlife']] <- newParameter('pTradeOlife', 'trade', 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'olife', cls = 'trade')    
    x[['pTradeInvcost']] <- newParameter('pTradeInvcost', c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    x[['pTradeEac']] <- newParameter('pTradeEac', 
    	c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    
    x[['pTradeCap2Act']] <- newParameter('pTradeCap2Act', 'trade', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cap2act', slot = 'cap2act')    
    
    # mv mapping for variables ####
    x[['mvSupReserve']] <- newParameter('mvSupReserve', c('sup', 'comm', 'region'), 'map') 
    x[['mvTechRetiredNewCap']] <- newParameter('mvTechRetiredNewCap', c('tech', 'region', 'year', 'year'), 'map') 
    x[['mvTechRetiredStock']] <- newParameter('mvTechRetiredStock', c('tech', 'region', 'year'), 'map') 
    x[['mvTechAct']] <- newParameter('mvTechAct', c('tech', 'region', 'year', 'slice'), 'map') 
    x[['mvTechInp']] <- newParameter('mvTechInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTechOut']] <- newParameter('mvTechOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTechAInp']] <- newParameter('mvTechAInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTechAOut']] <- newParameter('mvTechAOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvDemInp']] <- newParameter('mvDemInp', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mvBalance']] <- newParameter('mvBalance', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mvInpTot']] <- newParameter('mvInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mvOutTot']] <- newParameter('mvOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    x[['mvInp2Lo']] <- newParameter('mvInp2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    x[['mvOut2Lo']] <- newParameter('mvOut2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    x[['mInpSub']] <- newParameter('mInpSub', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mOutSub']] <- newParameter('mOutSub', c('comm', 'region', 'year', 'slice'), 'map') 
    x[['mvStorageAInp']] <- newParameter('mvStorageAInp', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvStorageAOut']] <- newParameter('mvStorageAOut', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 

    
    x[['mvStorageStore']] <- newParameter('mvStorageStore', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    x[['mvTradeIr']] <- newParameter('mvTradeIr', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    x[['mvTradeCost']] <- newParameter('mvTradeCost', c('region', 'year'), 'map') 

    x[['mvTradeCost']] <- newParameter('mvTradeCost', c('region', 'year'), 'map') 
    x[['mvTradeRowCost']] <- newParameter('mvTradeRowCost', c('region', 'year'), 'map')
    x[['mvTradeIrCost']] <- newParameter('mvTradeIrCost', c('region', 'year'), 'map') 
    x[['mvTotalCost']] <- newParameter('mvTotalCost', c('region', 'year'), 'map') 
    x[['mvTotalUserCosts']] <- newParameter('mvTotalUserCosts', c('region', 'year'), 'map') 
		
    # me - mapping for equations ####
    x[['meqTechSng2Sng']] <- newParameter('meqTechSng2Sng', c('tech', 'region', 'comm', 'comm', 'year', 'slice'), 'map')
    x[['meqTechGrp2Sng']] <- newParameter('meqTechGrp2Sng', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    x[['meqTechSng2Grp']] <- newParameter('meqTechSng2Grp', c('tech', 'region', 'comm', 'group', 'year', 'slice'), 'map')
    x[['meqTechGrp2Grp']] <- newParameter('meqTechGrp2Grp', c('tech', 'region', 'group', 'group', 'year', 'slice'), 'map')
    x[['meqTechShareInpLo']] <- newParameter('meqTechShareInpLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    x[['meqTechShareInpUp']] <- newParameter('meqTechShareInpUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    x[['meqTechShareOutLo']] <- newParameter('meqTechShareOutLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    x[['meqTechShareOutUp']] <- newParameter('meqTechShareOutUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    x[['meqTechAfLo']] <- newParameter('meqTechAfLo', c('tech', 'region', 'year', 'slice'), 'map')
    x[['meqTechAfUp']] <- newParameter('meqTechAfUp', c('tech', 'region', 'year', 'slice'), 'map')
    x[['meqTechAfsLo']] <- newParameter('meqTechAfsLo', c('tech', 'region', 'year', 'slice'), 'map')
    x[['meqTechAfsUp']] <- newParameter('meqTechAfsUp', c('tech', 'region', 'year', 'slice'), 'map')
    x[['meqTechActSng']] <- newParameter('meqTechActSng', c('tech', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqTechActGrp']] <- newParameter('meqTechActGrp', c('tech', 'group', 'region', 'year', 'slice'), 'map')
    x[['meqTechAfcOutLo']] <- newParameter('meqTechAfcOutLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    x[['meqTechAfcOutUp']] <- newParameter('meqTechAfcOutUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    x[['meqTechAfcInpLo']] <- newParameter('meqTechAfcInpLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    x[['meqTechAfcInpUp']] <- newParameter('meqTechAfcInpUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    x[['meqSupAvaLo']] <- newParameter('meqSupAvaLo', c('sup', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqSupReserveLo']] <- newParameter('meqSupReserveLo', c('sup', 'comm', 'region'), 'map')
    x[['meqStorageAfLo']] <- newParameter('meqStorageAfLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqStorageAfUp']] <- newParameter('meqStorageAfUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqStorageInpUp']] <- newParameter('meqStorageInpUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqStorageInpLo']] <- newParameter('meqStorageInpLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqStorageOutUp']] <- newParameter('meqStorageOutUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqStorageOutLo']] <- newParameter('meqStorageOutLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqTradeFlowUp']] <- newParameter('meqTradeFlowUp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    x[['meqTradeFlowLo']] <- newParameter('meqTradeFlowLo', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    x[['meqExportRowLo']] <- newParameter('meqExportRowLo', c('expp', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqImportRowLo']] <- newParameter('meqImportRowLo', c('imp', 'comm', 'region', 'year', 'slice'), 'map')
    x[['meqTradeCapFlow']] <- newParameter('meqTradeCapFlow', c('trade', 'comm', 'year', 'slice'), 'map')
    x[['meqBalLo']] <- newParameter('meqBalLo', c('comm', 'region', 'year', 'slice'), 'map')
    x[['meqBalUp']] <- newParameter('meqBalUp', c('comm', 'region', 'year', 'slice'), 'map')
    x[['meqBalFx']] <- newParameter('meqBalFx', c('comm', 'region', 'year', 'slice'), 'map')
    x[['meqLECActivity']] <- newParameter('meqLECActivity', c('tech', 'region', 'year'), 'map')

    .Object@parameters <- x
    .Object
  })


#### Internal functions ####
.get_default_values <- function(modInp, name, drop.unused.values) {
  # Returns data.frame with default values of parameters on 
  #       expanded grid of all (or used only, like milestone-years) 
  #       values of the parameter dimension (e.g. sets)
  # name - "character", name of the parameter
  drop_duplicates <- function(x) x[!duplicated(x),, drop = FALSE]
  sets0 <- modInp@parameters[[name]]@dimSetNames
  sets <- NULL
  for (i in sets0) {
    j <- i
    if (any(i == c('src', 'dst'))) j <- 'region'
    tmp <- .get_data_slot(modInp@parameters[[j]])
    colnames(tmp) <- i
    if (nrow(tmp) == 0) return(NULL)
    if (drop.unused.values) {
      if (i == 'slice' && any(colnames(sets) == 'comm')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mCommSlice), tmp)
      } 
      if (i == 'comm' && any(colnames(sets) == 'sup')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mSupComm), tmp)
      }      
      if (i == 'region' && any(colnames(sets) == 'sup') && all(sets0 != 'year')) {
        tmp <- merge(drop_duplicates(
          .get_data_slot(modInp@parameters$mSupSpan)[, c('sup', 'region')]), tmp)
      }      
      if (i == 'year' && any(colnames(sets) == 'sup') && any(colnames(sets) == 'region')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mSupSpan), tmp)
      }      
      if (i == 'year') {
        tmp <- merge(.get_data_slot(modInp@parameters$mMidMilestone), tmp)
      }
      if (i == 'year' && any(colnames(sets) == 'tech')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mTechSpan), tmp)
      }
      if (i == 'region' && any(colnames(sets) == 'tech') && all(sets0 != 'year')) {
        tmp <- merge(drop_duplicates(
          .get_data_slot(modInp@parameters$mTechSpan)[, c('tech', 'region')]), tmp)
      }
      
      if (i == 'comm' && any(colnames(sets) == 'tech')) {
        tmp <- merge(rbind(.get_data_slot(modInp@parameters$mTechInpComm), 
                           .get_data_slot(modInp@parameters$mTechOutComm)), tmp)
      }
      if (i == 'slice' && any(colnames(sets) == 'tech')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mTechSlice), tmp)
      }
      if (i == 'src') {
        aa <- .get_data_slot(modInp@parameters$mTradeSrc)
        colnames(aa)[2] <- 'src'
        tmp <- merge(aa, tmp)
      }
      if (i == 'dst') {
        aa <- .get_data_slot(modInp@parameters$mTradeDst)
        colnames(aa)[2] <- 'dst'
        tmp <- merge(aa, tmp)
      }
      if (i == 'comm' && any(colnames(sets) == 'trade')) {
        tmp <- merge(.get_data_slot(modInp@parameters$mTradeComm), tmp)
      }
    }
    if (is.null(sets)) {
      sets <- tmp
    } else {
      sets <- merge(sets, tmp)
    }
  }
  if (modInp@parameters[[name]]@type == 'simple' && (is.null(sets) || nrow(sets) != 0)) {
    sets$value <- modInp@parameters[[name]]@defVal
    if (!is.data.frame(sets)) sets <- as.data.frame(sets)
  } 
  if (modInp@parameters[[name]]@type == 'multi' && (is.null(sets) || nrow(sets) != 0)) {
    sets$type <- 'lo'
    sets$value <- modInp@parameters[[name]]@defVal[1]
    sets2 <- sets
    sets2$type <- 'up'
    sets2$value <- modInp@parameters[[name]]@defVal[2]
    sets <- rbind(sets, sets2)
  } 
  sets
}

.add_dropped_zeros <- function(modInp, name, drop.unused.values = TRUE, use.dplyr = FALSE) {
  # Returns data.frame filled the parameter ("name") data with added, previous dropped zeros (if any)
  # rare use - currently reserved for "fix to scenario" routines (and some excessive/double-checking use)
  tmp <- .get_default_values(modInp, name, drop.unused.values)
  # tmp$value <- 0
  dtt <- .get_data_slot(modInp@parameters[[name]])
  # browser()
  if (!is.null(tmp)) {
    if (use.dplyr) {
      cols <- colnames(dtt)
      gg <- suppressMessages(dplyr::anti_join(tmp, dtt[,cols], by = cols[cols != 'value']))
      gg <- suppressMessages(dplyr::left_join(dtt, gg))
      return(gg)
    } else {
      if (ncol(dtt) == ncol(tmp)) gg <- rbind(dtt, tmp) else
        gg <- rbind(dtt, unique(tmp[, colnames(dtt), drop = FALSE]))
      if (ncol(gg) == 1) return(dtt)
     }
  } else {
    gg <- dtt
  }
  gg[!duplicated(gg[, colnames(gg) != 'value']),, drop = FALSE]
}

# !!! use methods instead?

.find_commodity <- function(modInp, name) {
  fl <- FALSE
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
    fl <- fl || any(modInp@parameters[[i]]@data$comm == name, na.rm = TRUE)
  for(i in c('pEmissionFactor')) # 'ems_from', 
    fl <- fl || any(modInp@parameters[[i]]@data$commp == name, na.rm = TRUE)
  fl
}

.drop_commodity <- function(modInp, name) {
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'comm', name)
  for(i in c('pEmissionFactor')) # 'ems_from', 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'commp', name)
  modInp
}

.find_demand <- function(obj, name) {
  fl <- FALSE
  for(i in c('pDemand')) 
    fl <- fl || any(obj@parameters[[i]]@data$comm == name, na.rm = TRUE)
  fl
}

.drop_demand <- function(modInp, name) {
  for(i in c('pDemand')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'comm', name)
  modInp
}

.find_weather <- function(modInp, name) {
  fl <- FALSE
  for(i in c('pWeather')) 
    fl <- fl || any(modInp@parameters[[i]]@data$comm == name, na.rm = TRUE)
  fl
}

.drop_weather <- function(modInp, name) {
  stop('The method is not available for class "weather", re-interpolation is required ', name)
  modInp
}

.find_supply <- function(modInp, name) {
  fl <- FALSE
  for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
    fl <- fl || any(modInp@parameters[[i]]@data$sup == name, na.rm = TRUE)
  fl
}

.drop_supply <- function(modInp, name) {
  for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'sup', name)
  modInp
}

.find_export <- function(modInp, name) {
  fl <- FALSE
  for(i in c('expp', 'mExpComm', 'pExportRowPrice', 'pExportRowRes', 'pExportRow')) 
    fl <- fl || any(modInp@parameters[[i]]@data$expp == name, na.rm = TRUE)
  fl
}

.drop_export <- function(modInp, name) {
  for(i in c('expp', 'mExpComm', 'pRowExportPrice', 'pRowExportRes', 'pRowExport')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'expp', name)
  modInp
}

.find_import <- function(modInp, name) {
  fl <- FALSE
  for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
             'pImportRow')) 
    fl <- fl || any(modInp@parameters[[i]]@data$imp == name, na.rm = TRUE)
  fl
}

.drop_import <- function(modInp, name) {
  for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
             'pImportRow')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'imp', name)
  modInp
}

.find_trade <- function(modInp, name) {
  any(modInp@parameters$trade@data$trade == name, na.rm = TRUE)
}

.drop_trade <- function(modInp, name) {
  stop('The method is not available for class "trade", re-interpolation is required ', name)
  modInp
}

.find_technology <- function(modInp, name) {
  any(modInp@parameters$tech@data$tech == name, na.rm = TRUE)
}

.drop_technology <- function(modInp, name) {
  stop('The method is not available for class "technology", re-interpolation is required ', name)
  modInp
}

.find_constraint <- function(modInp, name) {
  any(names(modInp@parameters$constraint) == name)
}

.drop_sysinfo_param <- function(modInp) {
  for(i in c('pDiscount', 'pDummyImportCost', 'pDummyExportCost')) 
    modInp@parameters[[i]] <- .reset(modInp@parameters[[i]])
  modInp
}

.get_stg_prm_lst <- function() {
  # vector with parameter-names, relevant to "storage"
  c('mStorageSlice', 'ndefpStorageOlife', 'mStorageComm',
    'mStorageNew', 'mStorageSpan', 'ndefpStorageCapUp', 
    'ndefpStorageAvaUp', 'pStorageInpLoss', 'pStorageOutLoss', 
    'pStorageStoreLoss', 'pStorageStock', 'pStorageOlife', 
    'pStorageCapUp', 'pStorageCapLo', 'pStorageCostStore', 
    'pStorageCostInp', 'pStorageCostOut', 'pStorageFixom', 
    'pStorageInvcost', 'pStorageAvaLo', 'pStorageAvaUp')
}

.find_storage <- function(modInp, name) {
  fl <- FALSE
  for(i in .get_stg_prm_lst()) 
    fl <- fl || any(modInp@parameters[[i]]@data$stg == name, na.rm = TRUE)
  fl
}

.drop_storage <- function(obj, name) {
  for(i in .get_stg_prm_lst()) 
    obj@parameters[[i]] <- .drop_set_value(obj@parameters[[i]], 'stg', name)
  obj
}

#### <end> ####
