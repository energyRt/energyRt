#### modInp-class ####

setClass("modInp", 
  representation(
    set = "list", # @sets List with set : tech, sup, group, comm, region, year, slice
    parameters = "list", # @parameters List with techology parameter
    modelVersion        = "character",
    solver              = "character",
    gams.equation  = 'list',
    misc = "list"
  ),
  prototype(
    set = list(tech = c(), sup = c(), group = c(),
                comm = c(), region = c(), year = c(), slice = c()
    ),
    parameters = list(), # List with techology parameter
    modelVersion        = "",
    solver              = "",
    gams.equation  = list(),
    #! Misc
    misc = list(
    )
  )
)

#### Constructor ####
setMethod("initialize", "modInp",
  function(.Object) {
    # sets ####
    .Object@parameters[['region']] <- newSet('region')    
    .Object@parameters[['year']]   <- newSet('year')    
    .Object@parameters[['slice']]  <- newSet('slice')    
    .Object@parameters[['comm']]   <- newSet('comm')    
    .Object@parameters[['sup']]    <- newSet('sup')    
    .Object@parameters[['dem']]    <- newSet('dem')    
    .Object@parameters[['tech']]   <- newSet('tech')    
    .Object@parameters[['group']]  <- newSet('group')    
    .Object@parameters[['stg']]    <- newSet('stg')    
    .Object@parameters[['expp']]    <- newSet('expp')    
    .Object@parameters[['imp']]    <- newSet('imp')    
    .Object@parameters[['trade']]    <- newSet('trade')    

    # weather ####
    .Object@parameters[['weather']] <- newSet('weather')
    .Object@parameters[['pWeather']] <- 
      newParameter('pWeather', c('weather', 'region', 'year', 'slice'), 
                   'simple', defVal = 1, interpolation = 'back.inter.forth', 
                   colName = 'wval', cls = 'weather')    
    .Object@parameters[['mWeatherSlice']] <- 
      newParameter('mWeatherSlice', c('weather', 'slice'), 'map')
    .Object@parameters[['mWeatherRegion']] <- 
      newParameter('mWeatherRegion', c('weather', 'region'), 'map')
    .Object@parameters[['mSupWeatherLo']] <- 
      newParameter('mSupWeatherLo', c('weather', 'sup'), 'map')
    .Object@parameters[['mSupWeatherUp']] <- 
      newParameter('mSupWeatherUp', c('weather', 'sup'), 'map')
    .Object@parameters[['mTechWeatherAfLo']] <- 
      newParameter('mTechWeatherAfLo', c('weather', 'tech'), 'map')
    .Object@parameters[['mTechWeatherAfUp']] <- 
      newParameter('mTechWeatherAfUp', c('weather', 'tech'), 'map')
    .Object@parameters[['mTechWeatherAfsLo']] <- 
      newParameter('mTechWeatherAfsLo', c('weather', 'tech'), 'map')
    .Object@parameters[['mTechWeatherAfsUp']] <- 
      newParameter('mTechWeatherAfsUp', c('weather', 'tech'), 'map')
    .Object@parameters[['mTechWeatherAfcLo']] <- 
      newParameter('mTechWeatherAfcLo', c('weather', 'tech', 'comm'), 'map')
    .Object@parameters[['mTechWeatherAfcUp']] <- 
      newParameter('mTechWeatherAfcUp', c('weather', 'tech', 'comm'), 'map')
    .Object@parameters[['mStorageWeatherAfLo']] <- 
      newParameter('mStorageWeatherAfLo', c('weather', 'stg'), 'map')
    .Object@parameters[['mStorageWeatherAfUp']] <- 
      newParameter('mStorageWeatherAfUp', c('weather', 'stg'), 'map')
    .Object@parameters[['mStorageWeatherCinpUp']] <- 
      newParameter('mStorageWeatherCinpUp', c('weather', 'stg'), 'map')
    .Object@parameters[['mStorageWeatherCinpLo']] <- 
      newParameter('mStorageWeatherCinpLo', c('weather', 'stg'), 'map')
    .Object@parameters[['mStorageWeatherCoutUp']] <- 
      newParameter('mStorageWeatherCoutUp', c('weather', 'stg'), 'map')
    .Object@parameters[['mStorageWeatherCoutLo']] <- 
      newParameter('mStorageWeatherCoutLo', c('weather', 'stg'), 'map')
    .Object@parameters[['pSupWeather']] <- 
      newParameter('pSupWeather', c('weather', 'sup'), 'multi',
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pTechWeatherAf']] <- 
      newParameter('pTechWeatherAf', c('weather', 'tech'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pTechWeatherAfs']] <- 
      newParameter('pTechWeatherAfs', c('weather', 'tech'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pTechWeatherAfc']] <-
      newParameter('pTechWeatherAfc', c('weather', 'tech', 'comm'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pStorageWeatherAf']] <- 
      newParameter('pStorageWeatherAf', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pStorageWeatherCinp']] <- 
      newParameter('pStorageWeatherCinp', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['pStorageWeatherCout']] <- 
      newParameter('pStorageWeatherCout', c('weather', 'stg'), 'multi', 
                   defVal = 1, interpolation = 'back.inter.forth')
    .Object@parameters[['mSliceNext']] <- 
      newParameter('mSliceNext', c('slice', 'slicep'), 'map')    
    .Object@parameters[['mSliceFYearNext']] <- 
      newParameter('mSliceFYearNext', c('slice', 'slicep'), 'map')    
    .Object@parameters[['mSameRegion']] <- 
      newParameter('mSameRegion', c('region', 'regionp'), 'map') # for glpk    
    .Object@parameters[['mSameSlice']] <- 
      newParameter('mSameSlice', c('slice', 'slicep'), 'map') # for glpk    
    .Object@parameters[['ordYear']] <- 
      newParameter('ordYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    .Object@parameters[['cardYear']] <- 
      newParameter('cardYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    .Object@parameters[['pPeriodLen']] <-
      newParameter('pPeriodLen', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    # commodity ####
    ### mapping 
    .Object@parameters[['mUpComm']] <- newParameter('mUpComm', 'comm', 'map')    
    .Object@parameters[['mLoComm']] <- newParameter('mLoComm', 'comm', 'map')    
    .Object@parameters[['mFxComm']] <- newParameter('mFxComm', 'comm', 'map')    
    # slice ####
    .Object@parameters[['mExpSlice']] <- 
      newParameter('mExpSlice', c('expp', 'slice'), 'map', cls = 'export')   
    .Object@parameters[['mImpSlice']] <- 
      newParameter('mImpSlice', c('imp', 'slice'), 'map', cls = 'import')   
    .Object@parameters[['mTechSlice']] <- 
      newParameter('mTechSlice', c('tech', 'slice'), 'map', cls = 'technology')   
    .Object@parameters[['mSupSlice']] <- 
      newParameter('mSupSlice', c('sup', 'slice'), 'map', cls = 'supply')   
    .Object@parameters[['mStorageFullYear']] <- 
      newParameter('mStorageFullYear', c('stg'), 'map', cls = 'storage')   
    .Object@parameters[['mTradeSlice']] <- 
      newParameter('mTradeSlice', c('trade', 'slice'), 'map', cls = 'trade')   
    .Object@parameters[['mCommSlice']] <- 
      newParameter('mCommSlice', c('comm', 'slice'), 'map', cls = 'commodity')   
    .Object@parameters[['mCommSliceOrParent']] <- 
      newParameter('mCommSliceOrParent', c('comm', 'slice', 'slicep'), 
                   'map', cls = 'commodity')   
    .Object@parameters[['mSliceParentChildE']] <- 
      newParameter('mSliceParentChildE', c('slice', 'slicep'), 'map')   
    .Object@parameters[['mSliceParentChild']] <- 
      newParameter('mSliceParentChild', c('slice', 'slicep'), 'map')   
    # simple
    .Object@parameters[['pSliceShare']] <- 
      newParameter('pSliceShare', 'slice', 'simple')   
    .Object@parameters[['pEmissionFactor']] <- 
    	newParameter('pEmissionFactor', c('comm', 'commp'), 'simple',  #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity', 
    		colName = 'mean', slot = 'emis')    
    .Object@parameters[['pAggregateFactor']] <- 
    	newParameter('pAggregateFactor', c('comm', 'commp'), 'simple', #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity') #, colName = 'agg', slot = 'agg')    
    # demand ####
    # mapping
    .Object@parameters[['mDemComm']] <- 
    	newParameter('mDemComm', c('dem', 'comm'), 'map', cls = 'demand')    
    .Object@parameters[['pDemand']] <- 
    	newParameter('pDemand', c('dem', 'comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = 0, interpolation = 'back.inter.forth', 
    	             colName = 'dem', cls = 'demand', slot = 'dem')
    # dummy import ####
    .Object@parameters[['pDummyImportCost']] <- 
    	newParameter('pDummyImportCost', c('comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = Inf, interpolation = 'back.inter.forth', 
    	             colName = 'dummyImport', cls = 'sysInfo', slot = 'debug')    
    # dummy export ####
    .Object@parameters[['pDummyExportCost']] <- 
    	newParameter('pDummyExportCost', c('comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = Inf, interpolation = 'back.inter.forth', 
    	             colName = 'dummyExport', cls = 'sysInfo', slot = 'debug')    
    # tax ####
    .Object@parameters[['pTaxCost']] <- 
    	newParameter('pTaxCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'tax', slot = 'tax')    
    # subsidy ####
    .Object@parameters[['pSubsCost']] <- 
    	newParameter('pSubsCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'sub', slot = 'subs')    
    # supply ####
    # mapping
    .Object@parameters[['mSupComm']] <- 
    	newParameter('mSupComm', c('sup', 'comm'), 'map', cls = 'supply')    
    .Object@parameters[['mSupSpan']] <- 
      newParameter('mSupSpan', c('sup', 'region'), 'map')    
    .Object@parameters[['mvSupCost']] <- 
      newParameter('mvSupCost', c('sup', 'region', 'year'), 'map')    
    # simple parameters
    .Object@parameters[['pSupCost']] <- 
    	newParameter('pSupCost', c('sup', 'comm', 'region', 'year', 'slice'), 
    	             'simple', defVal = 0, interpolation = 'back.inter.forth', 
    	             colName = 'cost', cls = 'supply', slot = 'availability')    
    .Object@parameters[['pSupReserve']] <- 
    	newParameter('pSupReserve', c('sup', 'comm', 'region'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'supply', 
    		slot = 'reserve', colName = c('res.lo', 'res.up'))
    # multi parameters
    .Object@parameters[['pSupAva']] <- 
    	newParameter('pSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 
    	             'multi', defVal = c(0, Inf), interpolation = 'back.inter.forth', 
    	             colName = c('ava.lo', 'ava.up'), cls = 'supply', slot = 'availability')    
    # technology ####
    # mapping
    for(i in c('mTechInpComm', 'mTechOutComm', 'mTechOneComm', 
               'mTechAInp', 'mTechAOut'))
    	.Object@parameters[[i]] <- newParameter(i, c('tech', 'comm'), 
    	                                        'map', cls = 'technology')    
    for(i in c('mTechInpGroup', 'mTechOutGroup'))
    	.Object@parameters[[i]] <- newParameter(i, c('tech', 'group'), 
    	                                        'map', cls = 'technology')    
    .Object@parameters[['mTechGroupComm']] <- 
      newParameter('mTechGroupComm', c('tech', 'group', 'comm'), 
                   'map', cls = 'technology')    
    .Object@parameters[['mTechUpgrade']] <- 
      newParameter('mTechUpgrade', c('tech', 'techp'), 'map', cls = 'technology')    
    .Object@parameters[['mTechRetirement']] <- 
      newParameter('mTechRetirement', c('tech'), 'map', cls = 'technology')    
    # For disable technology with unexceptable start year
    .Object@parameters[['mTechNew']] <- newParameter('mTechNew', c('tech', 'region', 'year'), 
                                                     'map', cls = 'technology')    
    .Object@parameters[['mTechInv']] <- newParameter('mTechInv', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechSpan']] <- newParameter('mTechSpan', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['meqTechRetiredNewCap']] <- newParameter('meqTechRetiredNewCap', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechOMCost']] <- newParameter('mTechOMCost', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechEac']] <- newParameter('mTechEac', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    
	.Object@parameters[['mTechAct2AInp']] <- newParameter('mTechAct2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCap2AInp']] <- newParameter('mTechCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechNCap2AInp']] <- newParameter('mTechNCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCinp2AInp']] <- newParameter('mTechCinp2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCout2AInp']] <- newParameter('mTechCout2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechAct2AOut']] <- newParameter('mTechAct2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCap2AOut']] <- newParameter('mTechCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechNCap2AOut']] <- newParameter('mTechNCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCinp2AOut']] <- newParameter('mTechCinp2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCout2AOut']] <- newParameter('mTechCout2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     

    # simple & multi
    .Object@parameters[['pTechCap2act']] <- 
    	newParameter('pTechCap2act', 'tech', 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', cls = 'technology')#, colName = 'cap2act', slot = 'cap2act')    
    .Object@parameters[['pTechEac']] <- 
      newParameter('pTechEac', c('tech', 'region', 'year'), 'simple', 
        defVal = 0, interpolation = 'back.inter.forth', cls = 'technology', colName = 'invcost')
    .Object@parameters[['pTechEmisComm']] <- newParameter('pTechEmisComm', c('tech', 'comm'), 'simple', 
    	defVal = 1, cls = 'technology', colName = 'combustion')    
    .Object@parameters[['pTechOlife']] <- 
    	newParameter('pTechOlife', c('tech', 'region'), 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'technology', slot = 'cap2act')          
    .Object@parameters[['pTechFixom']] <- newParameter('pTechFixom', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'technology')    
    .Object@parameters[['pTechInvcost']] <- newParameter('pTechInvcost', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'technology')    
    .Object@parameters[['pTechStock']] <- newParameter('pTechStock', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'technology')    
    .Object@parameters[['pTechVarom']] <- newParameter('pTechVarom', 
    	c('tech', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'varom', cls = 'technology')    
    #
    .Object@parameters[['pTechAf']] <- 
    	newParameter('pTechAf', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), 
    		interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'technology')    
    #
    .Object@parameters[['pTechAfs']] <- 
    	newParameter('pTechAfs', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 0), 
    		interpolation = 'back.inter.forth', colName = c('afs.lo', 'afs.up'), cls = 'technology')    
    .Object@parameters[['pTechGinp2use']] <- newParameter('pTechGinp2use', 
    	c('tech', 'group', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'ginp2use', cls = 'technology')    
    .Object@parameters[['pTechCinp2ginp']] <- newParameter('pTechCinp2ginp', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2ginp', cls = 'technology')    
    .Object@parameters[['pTechUse2cact']] <- newParameter('pTechUse2cact', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'use2cact', cls = 'technology')    
    # auxiliary commodity ####
    .Object@parameters[['pTechAct2AInp']] <- newParameter('pTechAct2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2ainp', cls = 'technology')    
    .Object@parameters[['pTechCap2AInp']] <- newParameter('pTechCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2ainp', cls = 'technology')    
    .Object@parameters[['pTechAct2AOut']] <- newParameter('pTechAct2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2aout', cls = 'technology')    
    .Object@parameters[['pTechCap2AOut']] <- newParameter('pTechCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    .Object@parameters[['pTechNCap2AInp']] <- newParameter('pTechNCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    .Object@parameters[['pTechNCap2AOut']] <- newParameter('pTechNCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    .Object@parameters[['pTechCinp2AInp']] <- newParameter('pTechCinp2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2ainp', cls = 'technology')    
    .Object@parameters[['pTechCout2AInp']] <- newParameter('pTechCout2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2ainp', cls = 'technology')    
    .Object@parameters[['pTechCinp2AOut']] <- newParameter('pTechCinp2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2aout', cls = 'technology')    
    .Object@parameters[['pTechCout2AOut']] <- newParameter('pTechCout2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2aout', cls = 'technology')    
    
    # Aux stop
    .Object@parameters[['pTechCact2cout']] <- newParameter('pTechCact2cout', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cact2cout', cls = 'technology')    
    .Object@parameters[['pTechCinp2use']] <- newParameter('pTechCinp2use', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2use', cls = 'technology')  
    .Object@parameters[['pTechCvarom']] <- newParameter('pTechCvarom', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cvarom', cls = 'technology')    
    .Object@parameters[['pTechAvarom']] <- newParameter('pTechAvarom', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'avarom', cls = 'technology')    
    .Object@parameters[['pTechShare']] <- newParameter('pTechShare', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), interpolation = 'back.inter.forth', 
    	colName = c('share.lo', 'share.up'), cls = 'technology')    
    .Object@parameters[['pTechAfc']] <- newParameter('pTechAfc', c('tech', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', colName = c('afc.lo', 'afc.up'), cls = 'technology')
    
    ## !!! SET ALIAS FOR SYS INFO
    # reserve ####
    .Object@parameters[['mStorageComm']] <- newParameter('mStorageComm', c('stg', 'comm'), 'map')    
    # simple & multi
    .Object@parameters[['pStorageOlife']] <- newParameter('pStorageOlife', 
    	c('stg', 'region'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'storage')    
    .Object@parameters[['pStorageStock']] <- newParameter('pStorageStock', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'storage')    
    .Object@parameters[['pStorageFixom']] <- newParameter('pStorageFixom', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'storage')    
    .Object@parameters[['pStorageInvcost']] <- newParameter('pStorageInvcost', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    .Object@parameters[['pStorageEac']] <- newParameter('pStorageEac', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    
  	.Object@parameters[['pStorageInpEff']] <- newParameter('pStorageInpEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'inpeff', cls = 'storage')    
  	.Object@parameters[['pStorageOutEff']] <- newParameter('pStorageOutEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'outeff', cls = 'storage')    
  	.Object@parameters[['pStorageStgEff']] <- newParameter('pStorageStgEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'stgeff', cls = 'storage')    
 
    .Object@parameters[['pStorageCostStore']] <- newParameter('pStorageCostStore', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'stgcost', cls = 'storage')    
    .Object@parameters[['pStorageCostInp']] <- newParameter('pStorageCostInp', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'inpcost', cls = 'storage')    
    .Object@parameters[['pStorageCostOut']] <- newParameter('pStorageCostOut', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'outcost', cls = 'storage')    
  	   	
    .Object@parameters[['pStorageAf']] <- newParameter('pStorageAf', c('stg', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, 1), interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'storage')
    
    .Object@parameters[['pStorageCap2stg']] <- newParameter('pStorageCap2stg', 'stg', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'storage')#, colName = 'cap2stg', slot = 'cap2stg')    
    .Object@parameters[['pStorageCinp']] <- newParameter('pStorageCinp', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    .Object@parameters[['pStorageCout']] <- newParameter('pStorageCout', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    .Object@parameters[['mStorageNew']] <- newParameter('mStorageNew', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageSpan']] <- newParameter('mStorageSpan', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageEac']] <- newParameter('mStorageEac', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageOMCost']] <- newParameter('mStorageOMCost', c('stg', 'region', 'year'), 'map')    
    
    .Object@parameters[['mStorageAInp']] <- newParameter('mStorageAInp', c('stg', 'comm'), 'map', cls = 'storage')    
    .Object@parameters[['mStorageAOut']] <- newParameter('mStorageAOut', c('stg', 'comm'), 'map', cls = 'storage')    
    stg_tmp <- c('pStorageStg2AInp' = 'stg2ainp', 'pStorageStg2AOut' = 'stg2aout', 'pStorageCinp2AInp' = 'cinp2ainp', 'pStorageCinp2AOut' = 'cinp2aout', 
    	'pStorageCout2AInp' = 'cout2ainp', 
				'pStorageCout2AOut' = 'cout2aout', 'pStorageCap2AInp' = 'cap2ainp', 'pStorageCap2AOut' = 'cap2aout', 'pStorageNCap2AInp' = 'ncap2ainp', 'pStorageNCap2AOut' = 'ncap2aout')
    for(i in c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 
    	'pStorageCout2AInp', 'pStorageCout2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 
    	'pStorageNCap2AInp', 'pStorageNCap2AOut'))
      .Object@parameters[[i]] <- newParameter(i, c('stg', 'acomm', 'region', 'year', 'slice'), 'simple', 
                                                 defVal = 0, interpolation = 'back.inter.forth', cls = 'storage', colName = stg_tmp[i])    
    .Object@parameters[['pStorageNCap2Stg']] <- newParameter('pStorageNCap2Stg', 
                 c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'ncap2stg')    
    .Object@parameters[['pStorageCharge']] <- newParameter('pStorageCharge', 
              c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'charge')    
    for (i in c('mStorageStg2AOut', 'mStorageCinp2AOut', 'mStorageCout2AOut', 'mStorageCap2AOut', 'mStorageNCap2AOut', 'mStorageStg2AInp', 'mStorageCinp2AInp', 
    	'mStorageCout2AInp', 'mStorageCap2AInp', 'mStorageNCap2AInp'))
    		.Object@parameters[[i]] <- newParameter(i, c('stg', 'comm', 'region', 'year', 'slice'), 'map', cls = 'storage')    


    # trade ####
    # mapping
    .Object@parameters[['mTradeIrAInp']] <- newParameter('mTradeIrAInp', c('trade', 'comm'), 'map', cls = 'trade')   
    .Object@parameters[['mTradeIrAOut']] <- newParameter('mTradeIrAOut', c('trade', 'comm'), 'map', cls = 'trade')   
    .Object@parameters[['mExpComm']] <- 
    	newParameter('mExpComm', c('expp', 'comm'), 'map', cls = 'trade')    
    .Object@parameters[['mImpComm']] <- 
    	newParameter('mImpComm', c('imp', 'comm'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeComm']] <- 
    	newParameter('mTradeComm', c('trade', 'comm'), 'map', cls = 'trade')    
    drt1 <- c('pTradeIrCsrc2Aout', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Aout', 'pTradeIrCdst2Ainp')
    drt2 <- c(        'csrc2aout',         'csrc2ainp',         'cdst2aout',         'cdst2ainp')
    for (i in seq_along(drt1))
    	.Object@parameters[[drt1[i]]] <- newParameter(drt1[i], c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = drt2[i])    
    
    .Object@parameters[['pTradeIrCost']] <- newParameter('pTradeIrCost', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cost')    
    .Object@parameters[['pTradeIrEff']] <- newParameter('pTradeIrEff', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'teff')    
    .Object@parameters[['pTradeIrMarkup']] <- newParameter('pTradeIrMarkup', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'markup')    
    .Object@parameters[['pExportRowPrice']] <- newParameter('pExportRowPrice', 
    	c('expp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'export', colName = 'price')    
    .Object@parameters[['pImportRowPrice']] <- newParameter('pImportRowPrice', 
    	c('imp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'import', colName = 'price')    
    .Object@parameters[['pTradeIr']] <- newParameter('pTradeIr', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'trade', colName = c('ava.lo', 'ava.up'))
    .Object@parameters[['pExportRow']] <- newParameter('pExportRow', 
    	c('expp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'export', colName = c('exp.lo', 'exp.up'))
    .Object@parameters[['pImportRow']] <- newParameter('pImportRow', 
    	c('imp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'import', colName = c('imp.lo', 'imp.up'))
    .Object@parameters[['pExportRowRes']] <- newParameter('pExportRowRes', 
    	'expp', 'simple',  defVal = 0, interpolation = 'back.inter.forth')#, cls = 'export', slot = 'reserve', colName = 'reserve')
    .Object@parameters[['pImportRowRes']] <- newParameter('pImportRowRes', 'imp', 'simple',  defVal = 0, interpolation = 'back.inter.forth') #, cls = 'import', slot = 'reserve', colName = 'reserve')
    # For LEC
    .Object@parameters[['mLECRegion']] <- newParameter('mLECRegion', 'region', 'map')    
    .Object@parameters[['pLECLoACT']] <- 
    	newParameter('pLECLoACT', 'region', 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth')    
    
    
    # other/system ####
    # discount ####
    .Object@parameters[['pDiscount']] <- 
    	newParameter('pDiscount', c('region', 'year'), 'simple', 
    		defVal = .1, interpolation = 'back.inter.forth', colName = 'discount', cls = 'sysInfo')    
    # Additional for compatibility 
    .Object@parameters[['pDiscountFactor']] <- newParameter('pDiscountFactor', c('region', 'year'), 'simple')
    .Object@parameters[['pDiscountFactorMileStone']] <- newParameter('pDiscountFactorMileStone', c('region', 'year'), 'simple')
    
    .Object@parameters[['mDiscountZero']] <- newParameter('mDiscountZero', 'region', 'map', defVal = 1) 
    ## milestone set ####
    .Object@parameters[['mMidMilestone']] <- newParameter('mMidMilestone', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneHasNext']] <- newParameter('mMilestoneHasNext', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneFirst']] <- newParameter('mMilestoneFirst', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneLast']] <- newParameter('mMilestoneLast', 'year', 'map', defVal = 1) 
    .Object@parameters[['mStartMilestone']] <- newParameter('mStartMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    .Object@parameters[['mEndMilestone']] <- newParameter('mEndMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    .Object@parameters[['mMilestoneNext']] <- newParameter('mMilestoneNext', c('year', 'yearp'), 'map', defVal = 1) 
    ## mapping ####
    .Object@parameters[['mTechInpTot']] <- newParameter('mTechInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechOutTot']] <- newParameter('mTechOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDemInp']] <- newParameter('mDemInp', c('comm', 'slice'), 'map') 
    .Object@parameters[['mEmsFuelTot']] <- newParameter('mEmsFuelTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechEmsFuel']] <- newParameter('mTechEmsFuel', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mAggregateFactor']] <- newParameter('mAggregateFactor', c('comm', 'comm'), 'map') 
    .Object@parameters[['mDummyImport']] <- newParameter('mDummyImport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyExport']] <- newParameter('mDummyExport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyCost']] <- newParameter('mDummyCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mTradeIr']] <- newParameter('mTradeIr', c('trade', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAInp']] <- newParameter('mvTradeIrAInp', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAOut']] <- newParameter('mvTradeIrAOut', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAInpTot']] <- newParameter('mvTradeIrAInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAOutTot']] <- newParameter('mvTradeIrAOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mTradeIrCsrc2Ainp']] <- newParameter('mTradeIrCsrc2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCdst2Ainp']] <- newParameter('mTradeIrCdst2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCsrc2Aout']] <- newParameter('mTradeIrCsrc2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCdst2Aout']] <- newParameter('mTradeIrCdst2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 

    .Object@parameters[['mImportRow']] <- newParameter('mImportRow', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mExportRow']] <- newParameter('mExportRow', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImportRowUp']] <- newParameter('mImportRowUp', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mExportRowUp']] <- newParameter('mExportRowUp', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImportRowAccumulatedUp']] <- newParameter('mImportRowAccumulatedUp', c('imp', 'comm'), 'map') 
    .Object@parameters[['mExportRowAccumulatedUp']] <- newParameter('mExportRowAccumulatedUp', c('expp', 'comm'), 'map') 
    
    .Object@parameters[['mExport']] <- newParameter('mExport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImport']] <- newParameter('mImport', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mStorageInpTot']] <- newParameter('mStorageInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mStorageOutTot']] <- newParameter('mStorageOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mTaxCost']] <- newParameter('mTaxCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mSubsCost']] <- newParameter('mSubsCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mAggOut']] <- newParameter('mAggOut', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mSupOutTot']] <- newParameter('mSupOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupAvaUp']] <- newParameter('mSupAvaUp', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupAva']] <- newParameter('mSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupReserveUp']] <- newParameter('mSupReserveUp', c('sup', 'comm', 'region'), 'map') 
    
    .Object@parameters[['mTechAfUp']] <- newParameter('mTechAfUp', c('tech', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechAfcUp']] <- newParameter('mTechAfcUp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechOlifeInf']] <- newParameter('mTechOlifeInf', c('tech', 'region'), 'map') 
    .Object@parameters[['mStorageOlifeInf']] <- newParameter('mStorageOlifeInf', c('stg', 'region'), 'map') 
    
    .Object@parameters[['mInp2Lo']] <- newParameter('mInp2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mOut2Lo']] <- newParameter('mOut2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    
    # trade capacity data ####
    # To start year 
    .Object@parameters[['mTradeSpan']] <- newParameter('mTradeSpan', c('trade', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeNew']] <- newParameter('mTradeNew', c('trade', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeOlifeInf']] <- newParameter('mTradeOlifeInf', c('trade'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeCapacityVariable']] <- newParameter('mTradeCapacityVariable', 'trade', 'map', cls = 'trade')    
    .Object@parameters[['mTradeRoutes']] <- newParameter('mTradeRoutes', c('trade', 'src', 'dst'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeInv']] <- newParameter('mTradeInv', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeEac']] <- newParameter('mTradeEac', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    
    .Object@parameters[['pTradeStock']] <- newParameter('pTradeStock', c('trade', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'trade')    
    .Object@parameters[['pTradeOlife']] <- newParameter('pTradeOlife', 'trade', 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'olife', cls = 'trade')    
    .Object@parameters[['pTradeInvcost']] <- newParameter('pTradeInvcost', c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    .Object@parameters[['pTradeEac']] <- newParameter('pTradeEac', 
    	c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    
    .Object@parameters[['pTradeCap2Act']] <- newParameter('pTradeCap2Act', 'trade', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cap2act', slot = 'cap2act')    
    
    # mv mapping for variables ####
    .Object@parameters[['mvSupReserve']] <- newParameter('mvSupReserve', c('sup', 'comm', 'region'), 'map') 
    .Object@parameters[['mvTechRetiredNewCap']] <- newParameter('mvTechRetiredNewCap', c('tech', 'region', 'year', 'year'), 'map') 
    .Object@parameters[['mvTechRetiredStock']] <- newParameter('mvTechRetiredStock', c('tech', 'region', 'year'), 'map') 
    .Object@parameters[['mvTechAct']] <- newParameter('mvTechAct', c('tech', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechInp']] <- newParameter('mvTechInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechOut']] <- newParameter('mvTechOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechAInp']] <- newParameter('mvTechAInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechAOut']] <- newParameter('mvTechAOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvDemInp']] <- newParameter('mvDemInp', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvBalance']] <- newParameter('mvBalance', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvInpTot']] <- newParameter('mvInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvOutTot']] <- newParameter('mvOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mvInp2Lo']] <- newParameter('mvInp2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    .Object@parameters[['mvOut2Lo']] <- newParameter('mvOut2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    .Object@parameters[['mInpSub']] <- newParameter('mInpSub', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mOutSub']] <- newParameter('mOutSub', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvStorageAInp']] <- newParameter('mvStorageAInp', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvStorageAOut']] <- newParameter('mvStorageAOut', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 

    
    .Object@parameters[['mvStorageStore']] <- newParameter('mvStorageStore', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIr']] <- newParameter('mvTradeIr', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeCost']] <- newParameter('mvTradeCost', c('region', 'year'), 'map') 

    .Object@parameters[['mvTradeCost']] <- newParameter('mvTradeCost', c('region', 'year'), 'map') 
    .Object@parameters[['mvTradeRowCost']] <- newParameter('mvTradeRowCost', c('region', 'year'), 'map')
    .Object@parameters[['mvTradeIrCost']] <- newParameter('mvTradeIrCost', c('region', 'year'), 'map') 
    .Object@parameters[['mvTotalCost']] <- newParameter('mvTotalCost', c('region', 'year'), 'map') 

    # me - mapping for equations ####
    .Object@parameters[['meqTechSng2Sng']] <- newParameter('meqTechSng2Sng', c('tech', 'region', 'comm', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechGrp2Sng']] <- newParameter('meqTechGrp2Sng', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechSng2Grp']] <- newParameter('meqTechSng2Grp', c('tech', 'region', 'comm', 'group', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechGrp2Grp']] <- newParameter('meqTechGrp2Grp', c('tech', 'region', 'group', 'group', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareInpLo']] <- newParameter('meqTechShareInpLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareInpUp']] <- newParameter('meqTechShareInpUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareOutLo']] <- newParameter('meqTechShareOutLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareOutUp']] <- newParameter('meqTechShareOutUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfLo']] <- newParameter('meqTechAfLo', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfUp']] <- newParameter('meqTechAfUp', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfsLo']] <- newParameter('meqTechAfsLo', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfsUp']] <- newParameter('meqTechAfsUp', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechActSng']] <- newParameter('meqTechActSng', c('tech', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechActGrp']] <- newParameter('meqTechActGrp', c('tech', 'group', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcOutLo']] <- newParameter('meqTechAfcOutLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcOutUp']] <- newParameter('meqTechAfcOutUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcInpLo']] <- newParameter('meqTechAfcInpLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcInpUp']] <- newParameter('meqTechAfcInpUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqSupAvaLo']] <- newParameter('meqSupAvaLo', c('sup', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqSupReserveLo']] <- newParameter('meqSupReserveLo', c('sup', 'comm', 'region'), 'map')
    .Object@parameters[['meqStorageAfLo']] <- newParameter('meqStorageAfLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageAfUp']] <- newParameter('meqStorageAfUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageInpUp']] <- newParameter('meqStorageInpUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageInpLo']] <- newParameter('meqStorageInpLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageOutUp']] <- newParameter('meqStorageOutUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageOutLo']] <- newParameter('meqStorageOutLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeFlowUp']] <- newParameter('meqTradeFlowUp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeFlowLo']] <- newParameter('meqTradeFlowLo', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    .Object@parameters[['meqExportRowLo']] <- newParameter('meqExportRowLo', c('expp', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqImportRowLo']] <- newParameter('meqImportRowLo', c('imp', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeCapFlow']] <- newParameter('meqTradeCapFlow', c('trade', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalLo']] <- newParameter('meqBalLo', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalUp']] <- newParameter('meqBalUp', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalFx']] <- newParameter('meqBalFx', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqLECActivity']] <- newParameter('meqLECActivity', c('tech', 'region', 'year'), 'map')

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

#### <end> ####
