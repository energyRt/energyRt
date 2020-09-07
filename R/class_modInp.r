################################################################################
# Class generating code
################################################################################
# ! User never use this class
################################################################################
setClass("modInp", # modInp
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
);



# Constructor
setMethod("initialize", "modInp",
  function(.Object) {
  # Create parameters
    # Base set
    .Object@parameters[['region']] <- createSet('region')    
    .Object@parameters[['year']]   <- createSet('year')    
    .Object@parameters[['slice']]  <- createSet('slice')    
    .Object@parameters[['comm']]   <- createSet('comm')    
    .Object@parameters[['sup']]    <- createSet('sup')    
    .Object@parameters[['dem']]    <- createSet('dem')    
    .Object@parameters[['tech']]   <- createSet('tech')    
    .Object@parameters[['group']]  <- createSet('group')    
    .Object@parameters[['stg']]    <- createSet('stg')    
    .Object@parameters[['expp']]    <- createSet('expp')    
    .Object@parameters[['imp']]    <- createSet('imp')    
    .Object@parameters[['trade']]    <- createSet('trade')    

    # weather
   .Object@parameters[['weather']] <- createSet('weather')    
    .Object@parameters[['pWeather']] <- 
      createParameter('pWeather', c('weather', 'region', 'year', 'slice'), 'simple', 
                      defVal = 1, interpolation = 'back.inter.forth') #, colName = 'wval', cls = 'weather')    
 
   .Object@parameters[['mWeatherSlice']] <- createParameter('mWeatherSlice', c('weather', 'slice'), 'map')
   .Object@parameters[['mWeatherRegion']] <- createParameter('mWeatherRegion', c('weather', 'region'), 'map')

  .Object@parameters[['mSupWeatherLo']] <- createParameter('mSupWeatherLo', c('weather', 'sup'), 'map')
  .Object@parameters[['mSupWeatherUp']] <- createParameter('mSupWeatherUp', c('weather', 'sup'), 'map')
  .Object@parameters[['mTechWeatherAfLo']] <- createParameter('mTechWeatherAfLo', c('weather', 'tech'), 'map')
  .Object@parameters[['mTechWeatherAfUp']] <- createParameter('mTechWeatherAfUp', c('weather', 'tech'), 'map')
  .Object@parameters[['mTechWeatherAfsLo']] <- createParameter('mTechWeatherAfsLo', c('weather', 'tech'), 'map')
  .Object@parameters[['mTechWeatherAfsUp']] <- createParameter('mTechWeatherAfsUp', c('weather', 'tech'), 'map')
  .Object@parameters[['mTechWeatherAfcLo']] <- createParameter('mTechWeatherAfcLo', c('weather', 'tech', 'comm'), 'map')
  .Object@parameters[['mTechWeatherAfcUp']] <- createParameter('mTechWeatherAfcUp', c('weather', 'tech', 'comm'), 'map')
  .Object@parameters[['mStorageWeatherAfLo']] <- createParameter('mStorageWeatherAfLo', c('weather', 'stg'), 'map')
  .Object@parameters[['mStorageWeatherAfUp']] <- createParameter('mStorageWeatherAfUp', c('weather', 'stg'), 'map')
  .Object@parameters[['mStorageWeatherCinpUp']] <- createParameter('mStorageWeatherCinpUp', c('weather', 'stg'), 'map')
  .Object@parameters[['mStorageWeatherCinpLo']] <- createParameter('mStorageWeatherCinpLo', c('weather', 'stg'), 'map')
  .Object@parameters[['mStorageWeatherCoutUp']] <- createParameter('mStorageWeatherCoutUp', c('weather', 'stg'), 'map')
  .Object@parameters[['mStorageWeatherCoutLo']] <- createParameter('mStorageWeatherCoutLo', c('weather', 'stg'), 'map')
  
  .Object@parameters[['pSupWeather']] <- createParameter('pSupWeather', c('weather', 'sup'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pTechWeatherAf']] <- createParameter('pTechWeatherAf', c('weather', 'tech'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pTechWeatherAfs']] <- createParameter('pTechWeatherAfs', c('weather', 'tech'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pTechWeatherAfc']] <- createParameter('pTechWeatherAfc', c('weather', 'tech', 'comm'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pStorageWeatherAf']] <- createParameter('pStorageWeatherAf', c('weather', 'stg'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pStorageWeatherCinp']] <- createParameter('pStorageWeatherCinp', c('weather', 'stg'), 'multi', defVal = 1, interpolation = 'back.inter.forth')
  .Object@parameters[['pStorageWeatherCout']] <- createParameter('pStorageWeatherCout', c('weather', 'stg'), 'multi', defVal = 1, interpolation = 'back.inter.forth')


    
    #
    
    .Object@parameters[['mSliceNext']] <- createParameter('mSliceNext', c('slice', 'slicep'), 'map')    
    .Object@parameters[['mSliceFYearNext']] <- createParameter('mSliceFYearNext', c('slice', 'slicep'), 'map')    
    
    .Object@parameters[['mSameRegion']] <- createParameter('mSameRegion', c('region', 'regionp'), 'map') # for glpk    
    .Object@parameters[['mSameSlice']] <- createParameter('mSameSlice', c('slice', 'slicep'), 'map') # for glpk    
    
    .Object@parameters[['ordYear']] <- createParameter('ordYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    .Object@parameters[['cardYear']] <- createParameter('cardYear', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    .Object@parameters[['pPeriodLen']] <- createParameter('pPeriodLen', 'year', 'simple', 
    	defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    
    # Commodity
    # Map
    .Object@parameters[['mUpComm']] <- createParameter('mUpComm', 'comm', 'map')    
    .Object@parameters[['mLoComm']] <- createParameter('mLoComm', 'comm', 'map')    
    .Object@parameters[['mFxComm']] <- createParameter('mFxComm', 'comm', 'map')    
    # slice data
    .Object@parameters[['mExpSlice']] <- createParameter('mExpSlice', c('expp', 'slice'), 'map', cls = 'export')   
    .Object@parameters[['mImpSlice']] <- createParameter('mImpSlice', c('imp', 'slice'), 'map', cls = 'import')   
    .Object@parameters[['mTechSlice']] <- createParameter('mTechSlice', c('tech', 'slice'), 'map', cls = 'technology')   
    .Object@parameters[['mSupSlice']] <- createParameter('mSupSlice', c('sup', 'slice'), 'map', cls = 'supply')   
    .Object@parameters[['mStorageFullYear']] <- createParameter('mStorageFullYear', c('stg'), 'map', cls = 'storage')   
    .Object@parameters[['mTradeSlice']] <- createParameter('mTradeSlice', c('trade', 'slice'), 'map', cls = 'trade')   
    .Object@parameters[['mCommSlice']] <- createParameter('mCommSlice', c('comm', 'slice'), 'map', cls = 'commodity')   
    .Object@parameters[['mCommSliceOrParent']] <- createParameter('mCommSliceOrParent', c('comm', 'slice', 'slicep'), 'map', cls = 'commodity')   
    .Object@parameters[['mSliceParentChildE']] <- createParameter('mSliceParentChildE', c('slice', 'slicep'), 'map')   
    .Object@parameters[['mSliceParentChild']] <- createParameter('mSliceParentChild', c('slice', 'slicep'), 'map')   
    # simple
    .Object@parameters[['pSliceShare']] <- createParameter('pSliceShare', 'slice', 'simple')   
    .Object@parameters[['pEmissionFactor']] <- 
    	createParameter('pEmissionFactor', c('comm', 'commp'), 'simple',  #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity', colName = 'mean', slot = 'emis')    
    .Object@parameters[['pAggregateFactor']] <- 
    	createParameter('pAggregateFactor', c('comm', 'commp'), 'simple', #PPP
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity') #, colName = 'agg', slot = 'agg')    
    # Other commodity attribute
    # Demand
    # Map
    .Object@parameters[['mDemComm']] <- 
    	createParameter('mDemComm', c('dem', 'comm'), 'map', cls = 'demand')    
    .Object@parameters[['pDemand']] <- 
    	createParameter('pDemand', c('dem', 'comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'dem', cls = 'demand', slot = 'dem')
    # Dummy import
    .Object@parameters[['pDummyImportCost']] <- 
    	createParameter('pDummyImportCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = Inf, interpolation = 'back.inter.forth', colName = 'dummyImport', cls = 'sysInfo', slot = 'debug')    
    # Dummy export
    .Object@parameters[['pDummyExportCost']] <- 
    	createParameter('pDummyExportCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = Inf, interpolation = 'back.inter.forth', colName = 'dummyExport', cls = 'sysInfo', slot = 'debug')    
    # Tax
    .Object@parameters[['pTaxCost']] <- 
    	createParameter('pTaxCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'tax', slot = 'tax')    
    # Subs
    .Object@parameters[['pSubsCost']] <- 
    	createParameter('pSubsCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value') #, cls = 'sub', slot = 'subs')    
    # Supply
    # Map
    .Object@parameters[['mSupComm']] <- 
    	createParameter('mSupComm', c('sup', 'comm'), 'map', cls = 'supply')    
    .Object@parameters[['mSupSpan']] <- createParameter('mSupSpan', c('sup', 'region'), 'map')    
    .Object@parameters[['mvSupCost']] <- createParameter('mvSupCost', c('sup', 'region', 'year'), 'map')    
    # simple
    .Object@parameters[['pSupCost']] <- 
    	createParameter('pSupCost', c('sup', 'comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'cost', cls = 'supply', slot = 'availability')    
    .Object@parameters[['pSupReserve']] <- 
    	createParameter('pSupReserve', c('sup', 'comm', 'region'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'supply', slot = 'reserve', 
    		colName = c('res.lo', 'res.up'))
    # multi
    .Object@parameters[['pSupAva']] <- 
    	createParameter('pSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', 
    		colName = c('ava.lo', 'ava.up'), cls = 'supply', slot = 'availability')    
    # Technology
    # Map
    for(i in c('mTechInpComm', 'mTechOutComm', 'mTechOneComm', 
    	'mTechAInp', 'mTechAOut'))
    	.Object@parameters[[i]] <- createParameter(i, c('tech', 'comm'), 'map', cls = 'technology')    
    for(i in c('mTechInpGroup', 'mTechOutGroup'))
    	.Object@parameters[[i]] <- createParameter(i, c('tech', 'group'), 'map', cls = 'technology')    
    .Object@parameters[['mTechGroupComm']] <- createParameter('mTechGroupComm', 
    	c('tech', 'group', 'comm'), 'map', cls = 'technology')    
    .Object@parameters[['mTechUpgrade']] <- createParameter('mTechUpgrade', 
    	c('tech', 'techp'), 'map', cls = 'technology')    
    .Object@parameters[['mTechRetirement']] <- createParameter('mTechRetirement', c('tech'), 'map', cls = 'technology')    
    # For disable technology with unexceptable start year
    .Object@parameters[['mTechNew']] <- createParameter('mTechNew', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechInv']] <- createParameter('mTechInv', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechSpan']] <- createParameter('mTechSpan', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['meqTechRetiredNewCap']] <- createParameter('meqTechRetiredNewCap', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechOMCost']] <- createParameter('mTechOMCost', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechEac']] <- createParameter('mTechEac', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    
	.Object@parameters[['mTechAct2AInp']] <- createParameter('mTechAct2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCap2AInp']] <- createParameter('mTechCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechNCap2AInp']] <- createParameter('mTechNCap2AInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCinp2AInp']] <- createParameter('mTechCinp2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCout2AInp']] <- createParameter('mTechCout2AInp', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechAct2AOut']] <- createParameter('mTechAct2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCap2AOut']] <- createParameter('mTechCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechNCap2AOut']] <- createParameter('mTechNCap2AOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCinp2AOut']] <- createParameter('mTechCinp2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     
	.Object@parameters[['mTechCout2AOut']] <- createParameter('mTechCout2AOut', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map', cls = 'technology')     

    # simple & multi
    .Object@parameters[['pTechCap2act']] <- 
    	createParameter('pTechCap2act', 'tech', 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', cls = 'technology')#, colName = 'cap2act', slot = 'cap2act')    
    .Object@parameters[['pTechEac']] <- 
      createParameter('pTechEac', c('tech', 'region', 'year'), 'simple', 
        defVal = 0, interpolation = 'back.inter.forth', cls = 'technology', colName = 'invcost')
    .Object@parameters[['pTechEmisComm']] <- createParameter('pTechEmisComm', c('tech', 'comm'), 'simple', 
    	defVal = 1, cls = 'technology', colName = 'combustion')    
    .Object@parameters[['pTechOlife']] <- 
    	createParameter('pTechOlife', c('tech', 'region'), 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'technology', slot = 'cap2act')          
    .Object@parameters[['pTechFixom']] <- createParameter('pTechFixom', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'technology')    
    .Object@parameters[['pTechInvcost']] <- createParameter('pTechInvcost', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'technology')    
    .Object@parameters[['pTechStock']] <- createParameter('pTechStock', 
    	c('tech', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'technology')    
    .Object@parameters[['pTechVarom']] <- createParameter('pTechVarom', 
    	c('tech', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'varom', cls = 'technology')    
    #
    .Object@parameters[['pTechAf']] <- 
    	createParameter('pTechAf', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), 
    		interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'technology')    
    #
    .Object@parameters[['pTechAfs']] <- 
    	createParameter('pTechAfs', c('tech', 'region', 'year', 'slice'), 'multi', defVal = c(0, 0), 
    		interpolation = 'back.inter.forth', colName = c('afs.lo', 'afs.up'), cls = 'technology')    
    .Object@parameters[['pTechGinp2use']] <- createParameter('pTechGinp2use', 
    	c('tech', 'group', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'ginp2use', cls = 'technology')    
    .Object@parameters[['pTechCinp2ginp']] <- createParameter('pTechCinp2ginp', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2ginp', cls = 'technology')    
    .Object@parameters[['pTechUse2cact']] <- createParameter('pTechUse2cact', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'use2cact', cls = 'technology')    
    # Aux
    .Object@parameters[['pTechAct2AInp']] <- createParameter('pTechAct2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2ainp', cls = 'technology')    
    .Object@parameters[['pTechCap2AInp']] <- createParameter('pTechCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2ainp', cls = 'technology')    
    .Object@parameters[['pTechAct2AOut']] <- createParameter('pTechAct2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'act2aout', cls = 'technology')    
    .Object@parameters[['pTechCap2AOut']] <- createParameter('pTechCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    .Object@parameters[['pTechNCap2AInp']] <- createParameter('pTechNCap2AInp', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    .Object@parameters[['pTechNCap2AOut']] <- createParameter('pTechNCap2AOut', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2aout', cls = 'technology')    
    
    .Object@parameters[['pTechCinp2AInp']] <- createParameter('pTechCinp2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2ainp', cls = 'technology')    
    .Object@parameters[['pTechCout2AInp']] <- createParameter('pTechCout2AInp', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2ainp', cls = 'technology')    
    .Object@parameters[['pTechCinp2AOut']] <- createParameter('pTechCinp2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cinp2aout', cls = 'technology')    
    .Object@parameters[['pTechCout2AOut']] <- createParameter('pTechCout2AOut', 
    	c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cout2aout', cls = 'technology')    
    
    # Aux stop
    .Object@parameters[['pTechCact2cout']] <- createParameter('pTechCact2cout', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cact2cout', cls = 'technology')    
    .Object@parameters[['pTechCinp2use']] <- createParameter('pTechCinp2use', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'cinp2use', cls = 'technology')  
    .Object@parameters[['pTechCvarom']] <- createParameter('pTechCvarom', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'cvarom', cls = 'technology')    
    .Object@parameters[['pTechAvarom']] <- createParameter('pTechAvarom', 
    	c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'avarom', cls = 'technology')    
    .Object@parameters[['pTechShare']] <- createParameter('pTechShare', 
    	c('tech', 'comm', 'region', 'year', 'slice'), 'multi', defVal = c(0, 1), interpolation = 'back.inter.forth', 
    	colName = c('share.lo', 'share.up'), cls = 'technology')    
    .Object@parameters[['pTechAfc']] <- createParameter('pTechAfc', c('tech', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', colName = c('afc.lo', 'afc.up'), cls = 'technology')
    
    ## NEED SET ALIAS FOR SYS INFO
    # Reserve
    .Object@parameters[['mStorageComm']] <- createParameter('mStorageComm', c('stg', 'comm'), 'map')    
    # simple & multi
    .Object@parameters[['pStorageOlife']] <- createParameter('pStorageOlife', 
    	c('stg', 'region'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'storage')    
    .Object@parameters[['pStorageStock']] <- createParameter('pStorageStock', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'storage')    
    .Object@parameters[['pStorageFixom']] <- createParameter('pStorageFixom', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'fixom', cls = 'storage')    
    .Object@parameters[['pStorageInvcost']] <- createParameter('pStorageInvcost', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    .Object@parameters[['pStorageEac']] <- createParameter('pStorageEac', c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'storage')    
    
  	.Object@parameters[['pStorageInpEff']] <- createParameter('pStorageInpEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'inpeff', cls = 'storage')    
  	.Object@parameters[['pStorageOutEff']] <- createParameter('pStorageOutEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'outeff', cls = 'storage')    
  	.Object@parameters[['pStorageStgEff']] <- createParameter('pStorageStgEff',  c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
  		defVal = 1, interpolation = 'back.inter.forth', colName = 'stgeff', cls = 'storage')    
 
    .Object@parameters[['pStorageCostStore']] <- createParameter('pStorageCostStore', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'stgcost', cls = 'storage')    
    .Object@parameters[['pStorageCostInp']] <- createParameter('pStorageCostInp', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'inpcost', cls = 'storage')    
    .Object@parameters[['pStorageCostOut']] <- createParameter('pStorageCostOut', c('stg', 'region', 'year', 'slice'), 'simple', 
  		defVal = 0, interpolation = 'back.inter.forth', colName = 'outcost', cls = 'storage')    
  	   	
    .Object@parameters[['pStorageAf']] <- createParameter('pStorageAf', c('stg', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, 1), interpolation = 'back.inter.forth', colName = c('af.lo', 'af.up'), cls = 'storage')
    
    .Object@parameters[['pStorageCap2stg']] <- createParameter('pStorageCap2stg', 'stg', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'storage')#, colName = 'cap2stg', slot = 'cap2stg')    
    .Object@parameters[['pStorageCinp']] <- createParameter('pStorageCinp', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    .Object@parameters[['pStorageCout']] <- createParameter('pStorageCout', c('stg', 'comm', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, -1), interpolation = rep('back.inter.forth', 2), cls = 'storage', colName = c('cinp.lo', 'cinp.up'), slot = 'seff')
    .Object@parameters[['mStorageNew']] <- createParameter('mStorageNew', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageSpan']] <- createParameter('mStorageSpan', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageEac']] <- createParameter('mStorageEac', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageOMCost']] <- createParameter('mStorageOMCost', c('stg', 'region', 'year'), 'map')    
    
    .Object@parameters[['mStorageAInp']] <- createParameter('mStorageAInp', c('stg', 'comm'), 'map', cls = 'storage')    
    .Object@parameters[['mStorageAOut']] <- createParameter('mStorageAOut', c('stg', 'comm'), 'map', cls = 'storage')    
    stg_tmp <- c('pStorageStg2AInp' = 'stg2ainp', 'pStorageStg2AOut' = 'stg2aout', 'pStorageCinp2AInp' = 'cinp2ainp', 'pStorageCinp2AOut' = 'cinp2aout', 
    	'pStorageCout2AInp' = 'cout2ainp', 
				'pStorageCout2AOut' = 'cout2aout', 'pStorageCap2AInp' = 'cap2ainp', 'pStorageCap2AOut' = 'cap2aout', 'pStorageNCap2AInp' = 'ncap2ainp', 'pStorageNCap2AOut' = 'ncap2aout')
    for(i in c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageCinp2AInp', 'pStorageCinp2AOut', 
    	'pStorageCout2AInp', 'pStorageCout2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 
    	'pStorageNCap2AInp', 'pStorageNCap2AOut'))
      .Object@parameters[[i]] <- createParameter(i, c('stg', 'acomm', 'region', 'year', 'slice'), 'simple', 
                                                 defVal = 0, interpolation = 'back.inter.forth', cls = 'storage', colName = stg_tmp[i])    
    .Object@parameters[['pStorageNCap2Stg']] <- createParameter('pStorageNCap2Stg', 
                 c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'ncap2stg')    
    .Object@parameters[['pStorageCharge']] <- createParameter('pStorageCharge', 
              c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '', cls = 'storage', colName = 'charge')    
    for (i in c('mStorageStg2AOut', 'mStorageCinp2AOut', 'mStorageCout2AOut', 'mStorageCap2AOut', 'mStorageNCap2AOut', 'mStorageStg2AInp', 'mStorageCinp2AInp', 
    	'mStorageCout2AInp', 'mStorageCap2AInp', 'mStorageNCap2AInp'))
    		.Object@parameters[[i]] <- createParameter(i, c('stg', 'comm', 'region', 'year', 'slice'), 'map', cls = 'storage')    


    # Trade
    # Map
    .Object@parameters[['mTradeIrAInp']] <- createParameter('mTradeIrAInp', c('trade', 'comm'), 'map', cls = 'trade')   
    .Object@parameters[['mTradeIrAOut']] <- createParameter('mTradeIrAOut', c('trade', 'comm'), 'map', cls = 'trade')   
    .Object@parameters[['mExpComm']] <- 
    	createParameter('mExpComm', c('expp', 'comm'), 'map', cls = 'trade')    
    .Object@parameters[['mImpComm']] <- 
    	createParameter('mImpComm', c('imp', 'comm'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeComm']] <- 
    	createParameter('mTradeComm', c('trade', 'comm'), 'map', cls = 'trade')    
    drt1 <- c('pTradeIrCsrc2Aout', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Aout', 'pTradeIrCdst2Ainp')
    drt2 <- c(        'csrc2aout',         'csrc2ainp',         'cdst2aout',         'cdst2ainp')
    for (i in seq_along(drt1))
    	.Object@parameters[[drt1[i]]] <- createParameter(drt1[i], c('trade', 'acomm', 'src', 'dst', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = drt2[i])    
    
    .Object@parameters[['pTradeIrCost']] <- createParameter('pTradeIrCost', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cost')    
    .Object@parameters[['pTradeIrEff']] <- createParameter('pTradeIrEff', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'teff')    
    .Object@parameters[['pTradeIrMarkup']] <- createParameter('pTradeIrMarkup', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'markup')    
    .Object@parameters[['pExportRowPrice']] <- createParameter('pExportRowPrice', 
    	c('expp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'export', colName = 'price')    
    .Object@parameters[['pImportRowPrice']] <- createParameter('pImportRowPrice', 
    	c('imp', 'region', 'year', 'slice'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', cls = 'import', colName = 'price')    
    .Object@parameters[['pTradeIr']] <- createParameter('pTradeIr', 
    	c('trade', 'src', 'dst', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'trade', colName = c('ava.lo', 'ava.up'))
    .Object@parameters[['pExportRow']] <- createParameter('pExportRow', 
    	c('expp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'export', colName = c('exp.lo', 'exp.up'))
    .Object@parameters[['pImportRow']] <- createParameter('pImportRow', 
    	c('imp', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'import', colName = c('imp.lo', 'imp.up'))
    .Object@parameters[['pExportRowRes']] <- createParameter('pExportRowRes', 
    	'expp', 'simple',  defVal = 0, interpolation = 'back.inter.forth')#, cls = 'export', slot = 'reserve', colName = 'reserve')
    .Object@parameters[['pImportRowRes']] <- createParameter('pImportRowRes', 'imp', 'simple',  defVal = 0, interpolation = 'back.inter.forth') #, cls = 'import', slot = 'reserve', colName = 'reserve')
    # For LEC
    .Object@parameters[['mLECRegion']] <- createParameter('mLECRegion', 'region', 'map')    
    .Object@parameters[['pLECLoACT']] <- 
    	createParameter('pLECLoACT', 'region', 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth')    
    
    
    # Other
    # Discount
    .Object@parameters[['pDiscount']] <- 
    	createParameter('pDiscount', c('region', 'year'), 'simple', 
    		defVal = .1, interpolation = 'back.inter.forth', colName = 'discount', cls = 'sysInfo')    
    # Additional for compatibility 
    .Object@parameters[['pDiscountFactor']] <- createParameter('pDiscountFactor', c('region', 'year'), 'simple')
    .Object@parameters[['pDiscountFactorMileStone']] <- createParameter('pDiscountFactorMileStone', c('region', 'year'), 'simple')
    
    .Object@parameters[['mDiscountZero']] <- createParameter('mDiscountZero', 'region', 'map', defVal = 1) 
    ## Milestone set
    .Object@parameters[['mMidMilestone']] <- createParameter('mMidMilestone', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneHasNext']] <- createParameter('mMilestoneHasNext', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneFirst']] <- createParameter('mMilestoneFirst', 'year', 'map', defVal = 1) 
    .Object@parameters[['mMilestoneLast']] <- createParameter('mMilestoneLast', 'year', 'map', defVal = 1) 
    .Object@parameters[['mStartMilestone']] <- createParameter('mStartMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    .Object@parameters[['mEndMilestone']] <- createParameter('mEndMilestone', c('year', 'yearp'), 'map', defVal = 1) 
    .Object@parameters[['mMilestoneNext']] <- createParameter('mMilestoneNext', c('year', 'yearp'), 'map', defVal = 1) 
    ## Reduce mapping
    .Object@parameters[['mTechInpTot']] <- createParameter('mTechInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechOutTot']] <- createParameter('mTechOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDemInp']] <- createParameter('mDemInp', c('comm', 'slice'), 'map') 
    .Object@parameters[['mEmsFuelTot']] <- createParameter('mEmsFuelTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechEmsFuel']] <- createParameter('mTechEmsFuel', c('tech', 'comm', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mAggregateFactor']] <- createParameter('mAggregateFactor', c('comm', 'comm'), 'map') 
    .Object@parameters[['mDummyImport']] <- createParameter('mDummyImport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyExport']] <- createParameter('mDummyExport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyCost']] <- createParameter('mDummyCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mTradeIr']] <- createParameter('mTradeIr', c('trade', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAInp']] <- createParameter('mvTradeIrAInp', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAOut']] <- createParameter('mvTradeIrAOut', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAInpTot']] <- createParameter('mvTradeIrAInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIrAOutTot']] <- createParameter('mvTradeIrAOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mTradeIrCsrc2Ainp']] <- createParameter('mTradeIrCsrc2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCdst2Ainp']] <- createParameter('mTradeIrCdst2Ainp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCsrc2Aout']] <- createParameter('mTradeIrCsrc2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrCdst2Aout']] <- createParameter('mTradeIrCdst2Aout', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 

    .Object@parameters[['mImportRow']] <- createParameter('mImportRow', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mExportRow']] <- createParameter('mExportRow', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImportRowUp']] <- createParameter('mImportRowUp', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mExportRowUp']] <- createParameter('mExportRowUp', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImportRowAccumulatedUp']] <- createParameter('mImportRowAccumulatedUp', c('imp', 'comm'), 'map') 
    .Object@parameters[['mExportRowAccumulatedUp']] <- createParameter('mExportRowAccumulatedUp', c('expp', 'comm'), 'map') 
    
    .Object@parameters[['mExport']] <- createParameter('mExport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mImport']] <- createParameter('mImport', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mStorageInpTot']] <- createParameter('mStorageInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mStorageOutTot']] <- createParameter('mStorageOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mTaxCost']] <- createParameter('mTaxCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mSubsCost']] <- createParameter('mSubsCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mAggOut']] <- createParameter('mAggOut', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mSupOutTot']] <- createParameter('mSupOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupAvaUp']] <- createParameter('mSupAvaUp', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupAva']] <- createParameter('mSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mSupReserveUp']] <- createParameter('mSupReserveUp', c('sup', 'comm', 'region'), 'map') 
    
    .Object@parameters[['mTechAfUp']] <- createParameter('mTechAfUp', c('tech', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechAfcUp']] <- createParameter('mTechAfcUp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTechOlifeInf']] <- createParameter('mTechOlifeInf', c('tech', 'region'), 'map') 
    .Object@parameters[['mStorageOlifeInf']] <- createParameter('mStorageOlifeInf', c('stg', 'region'), 'map') 
    
    .Object@parameters[['mInp2Lo']] <- createParameter('mInp2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mOut2Lo']] <- createParameter('mOut2Lo', c('comm', 'region', 'year', 'slice'), 'map') 
    
    # Trade capacity data
    # For disable technology with unexceptable start year
    .Object@parameters[['mTradeSpan']] <- createParameter('mTradeSpan', c('trade', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeNew']] <- createParameter('mTradeNew', c('trade', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeOlifeInf']] <- createParameter('mTradeOlifeInf', c('trade'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeCapacityVariable']] <- createParameter('mTradeCapacityVariable', 'trade', 'map', cls = 'trade')    
    .Object@parameters[['mTradeRoutes']] <- createParameter('mTradeRoutes', c('trade', 'src', 'dst'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeInv']] <- createParameter('mTradeInv', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeEac']] <- createParameter('mTradeEac', c('trade', 'region', 'year'), 'map', cls = 'trade')    
    
    .Object@parameters[['pTradeStock']] <- createParameter('pTradeStock', c('trade', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'stock', cls = 'trade')    
    .Object@parameters[['pTradeOlife']] <- createParameter('pTradeOlife', 'trade', 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'olife', cls = 'trade')    
    .Object@parameters[['pTradeInvcost']] <- createParameter('pTradeInvcost', c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    .Object@parameters[['pTradeEac']] <- createParameter('pTradeEac', 
    	c('trade', 'region', 'year'), 'simple', 
    	defVal = 0, interpolation = 'back.inter.forth', colName = 'invcost', cls = 'trade')    
    
    .Object@parameters[['pTradeCap2Act']] <- createParameter('pTradeCap2Act', 'trade', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cap2act', slot = 'cap2act')    
    
    # mv Mapping
    .Object@parameters[['mvSupReserve']] <- createParameter('mvSupReserve', c('sup', 'comm', 'region'), 'map') 
    .Object@parameters[['mvTechRetiredNewCap']] <- createParameter('mvTechRetiredNewCap', c('tech', 'region', 'year', 'year'), 'map') 
    .Object@parameters[['mvTechRetiredStock']] <- createParameter('mvTechRetiredStock', c('tech', 'region', 'year'), 'map') 
    .Object@parameters[['mvTechAct']] <- createParameter('mvTechAct', c('tech', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechInp']] <- createParameter('mvTechInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechOut']] <- createParameter('mvTechOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechAInp']] <- createParameter('mvTechAInp', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTechAOut']] <- createParameter('mvTechAOut', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvDemInp']] <- createParameter('mvDemInp', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvBalance']] <- createParameter('mvBalance', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvInpTot']] <- createParameter('mvInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvOutTot']] <- createParameter('mvOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
    .Object@parameters[['mvInp2Lo']] <- createParameter('mvInp2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    .Object@parameters[['mvOut2Lo']] <- createParameter('mvOut2Lo', c('comm', 'region', 'year', 'slice', 'slice'), 'map') 
    .Object@parameters[['mInpSub']] <- createParameter('mInpSub', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mOutSub']] <- createParameter('mOutSub', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvStorageAInp']] <- createParameter('mvStorageAInp', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvStorageAOut']] <- createParameter('mvStorageAOut', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 

    
    .Object@parameters[['mvStorageStore']] <- createParameter('mvStorageStore', c('stg', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeIr']] <- createParameter('mvTradeIr', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mvTradeCost']] <- createParameter('mvTradeCost', c('region', 'year'), 'map') 

    .Object@parameters[['mvTradeCost']] <- createParameter('mvTradeCost', c('region', 'year'), 'map') 
    .Object@parameters[['mvTradeRowCost']] <- createParameter('mvTradeRowCost', c('region', 'year'), 'map')
    .Object@parameters[['mvTradeIrCost']] <- createParameter('mvTradeIrCost', c('region', 'year'), 'map') 
    .Object@parameters[['mvTotalCost']] <- createParameter('mvTotalCost', c('region', 'year'), 'map') 

    # me*
    .Object@parameters[['meqTechSng2Sng']] <- createParameter('meqTechSng2Sng', c('tech', 'region', 'comm', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechGrp2Sng']] <- createParameter('meqTechGrp2Sng', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechSng2Grp']] <- createParameter('meqTechSng2Grp', c('tech', 'region', 'comm', 'group', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechGrp2Grp']] <- createParameter('meqTechGrp2Grp', c('tech', 'region', 'group', 'group', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareInpLo']] <- createParameter('meqTechShareInpLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareInpUp']] <- createParameter('meqTechShareInpUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareOutLo']] <- createParameter('meqTechShareOutLo', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechShareOutUp']] <- createParameter('meqTechShareOutUp', c('tech', 'region', 'group', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfLo']] <- createParameter('meqTechAfLo', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfUp']] <- createParameter('meqTechAfUp', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfsLo']] <- createParameter('meqTechAfsLo', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfsUp']] <- createParameter('meqTechAfsUp', c('tech', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechActSng']] <- createParameter('meqTechActSng', c('tech', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechActGrp']] <- createParameter('meqTechActGrp', c('tech', 'group', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcOutLo']] <- createParameter('meqTechAfcOutLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcOutUp']] <- createParameter('meqTechAfcOutUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcInpLo']] <- createParameter('meqTechAfcInpLo', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqTechAfcInpUp']] <- createParameter('meqTechAfcInpUp', c('tech', 'region', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqSupAvaLo']] <- createParameter('meqSupAvaLo', c('sup', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqSupReserveLo']] <- createParameter('meqSupReserveLo', c('sup', 'comm', 'region'), 'map')
    .Object@parameters[['meqStorageAfLo']] <- createParameter('meqStorageAfLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageAfUp']] <- createParameter('meqStorageAfUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageInpUp']] <- createParameter('meqStorageInpUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageInpLo']] <- createParameter('meqStorageInpLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageOutUp']] <- createParameter('meqStorageOutUp', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqStorageOutLo']] <- createParameter('meqStorageOutLo', c('stg', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeFlowUp']] <- createParameter('meqTradeFlowUp', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeFlowLo']] <- createParameter('meqTradeFlowLo', c('trade', 'comm', 'src', 'dst', 'year', 'slice'), 'map')
    .Object@parameters[['meqExportRowLo']] <- createParameter('meqExportRowLo', c('expp', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqImportRowLo']] <- createParameter('meqImportRowLo', c('imp', 'comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqTradeCapFlow']] <- createParameter('meqTradeCapFlow', c('trade', 'comm', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalLo']] <- createParameter('meqBalLo', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalUp']] <- createParameter('meqBalUp', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqBalFx']] <- createParameter('meqBalFx', c('comm', 'region', 'year', 'slice'), 'map')
    .Object@parameters[['meqLECActivity']] <- createParameter('meqLECActivity', c('tech', 'region', 'year'), 'map')
        
    
    .Object
  })

# Print
setMethod('print', 'modInp', function(x, ...) {
	if (length(x@parameters) == 0) {
		cat('There is no data\n')
	} else {
		for(i in 1:length(x@parameters)) {
			print(x@parameters[[i]])
    }
  }
})

