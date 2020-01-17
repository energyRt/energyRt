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
    .Object@parameters[['weather']] <- createSet('weather')    

    # weather
    .Object@parameters[['mSupWeatherLo']] <- createParameter('mSupWeatherLo', c('sup', 'weather'), 'map')    
    .Object@parameters[['mSupWeatherUp']] <- createParameter('mSupWeatherUp', c('sup', 'weather'), 'map')    
    .Object@parameters[['mWeatherSlice']] <- createParameter('mWeatherSlice', c('weather', 'slice'), 'map')
    .Object@parameters[['mWeatherRegion']] <- createParameter('mWeatherRegion', c('weather', 'region'), 'map')
    .Object@parameters[['pWeather']] <- 
      createParameter('pWeather', c('weather', 'region', 'year', 'slice'), 'simple', 
                      defVal = 1, interpolation = 'back.inter.forth', colName = 'wval', cls = 'weather')    
    .Object@parameters[['pSupWeather']] <- 
      createParameter('pSupWeather', c('sup', 'weather'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('wava.lo', 'wava.up'), cls = 'weather')    
    
    .Object@parameters[['mTechWeatherAf']] <- createParameter('mTechWeatherAf', c('tech', 'weather'), 'map')    
    .Object@parameters[['mTechWeatherAfs']] <- createParameter('mTechWeatherAfs', c('tech', 'weather'), 'map')    
    .Object@parameters[['mTechWeatherAfc']] <- createParameter('mTechWeatherAfc', c('tech', 'weather', 'comm'), 'map')    
    
    .Object@parameters[['pTechWeatherAf']] <- 
      createParameter('pTechWeatherAf', c('tech', 'weather'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('waf.lo', 'waf.up'), cls = 'weather')    
    .Object@parameters[['pTechWeatherAfs']] <- 
      createParameter('pTechWeatherAfs', c('tech', 'weather'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('wafs.lo', 'wafs.up'), cls = 'weather')    
    .Object@parameters[['pTechWeatherAfc']] <- 
      createParameter('pTechWeatherAfc', c('tech', 'weather', 'comm'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('wafc.lo', 'wafc.up'), cls = 'weather')    
    
    .Object@parameters[['mStorageWeatherAf']] <- createParameter('mStorageWeatherAf', c('stg', 'weather'), 'map')    
    .Object@parameters[['pStorageWeatherAf']] <- 
      createParameter('pStorageWeatherAf', c('stg', 'weather'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('waf.lo', 'waf.up'), cls = 'weather')    
    
    .Object@parameters[['mStorageWeatherCinp']] <- createParameter('mStorageWeatherCinp', c('stg', 'weather'), 'map')    
    .Object@parameters[['pStorageWeatherCinp']] <- 
      createParameter('pStorageWeatherCinp', c('stg', 'weather'), 'multi', 
                      defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('wcinp.lo', 'wcinp.up'), cls = 'weather')    
    
    .Object@parameters[['mStorageWeatherCout']] <- createParameter('mStorageWeatherCout', c('stg', 'weather'), 'map')    
    .Object@parameters[['pStorageWeatherCout']] <- 
    	createParameter('pStorageWeatherCout', c('stg', 'weather'), 'multi', 
    		defVal = c(1, 1), interpolation = 'back.inter.forth', colName = c('wcout.lo', 'wcout.up'), cls = 'weather')    
    
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
    #.Object@parameters[['ems_from']] <- 
    #    createParameter('ems_from', c('comm', 'commp'), 'map')    
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
    		defVal = 0, interpolation = 'back.inter.forth', cls = 'commodity', colName = 'agg', slot = 'agg')    
    # Other commodity attribute
    # Demand
    # Map
    .Object@parameters[['mDemComm']] <- 
    	createParameter('mDemComm', c('dem', 'comm'), 'map', cls = 'demand')    
    .Object@parameters[['pDemand']] <- 
    	createParameter('pDemand', c('dem', 'comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'dem', cls = 'demand')
    # Dummy import
    .Object@parameters[['pDummyImportCost']] <- 
    	createParameter('pDummyImportCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = Inf, interpolation = 'back.inter.forth', colName = 'dummyImport', cls = 'sysInfo')    
    # Dummy export
    .Object@parameters[['pDummyExportCost']] <- 
    	createParameter('pDummyExportCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = Inf, interpolation = 'back.inter.forth', colName = 'dummyExport', cls = 'sysInfo')    
    # Tax
    .Object@parameters[['pTaxCost']] <- 
    	createParameter('pTaxCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value', cls = 'tax')    
    # Subs
    .Object@parameters[['pSubsCost']] <- 
    	createParameter('pSubsCost', c('comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'inter.forth', colName = 'value', cls = 'sub')    
    # Supply
    # Map
    .Object@parameters[['mSupComm']] <- 
    	createParameter('mSupComm', c('sup', 'comm'), 'map', cls = 'supply')    
    .Object@parameters[['mSupSpan']] <- 
    	createParameter('mSupSpan', c('sup', 'region'), 'map')    
    # simple
    .Object@parameters[['pSupCost']] <- 
    	createParameter('pSupCost', c('sup', 'comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth', colName = 'cost', cls = 'supply')    
    .Object@parameters[['pSupReserve']] <- 
    	createParameter('pSupReserve', c('sup', 'comm', 'region'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', cls = 'supply', slot = 'reserve', 
    		colName = c('res.lo', 'res.up'))
    # multi
    .Object@parameters[['pSupAva']] <- 
    	createParameter('pSupAva', c('sup', 'comm', 'region', 'year', 'slice'), 'multi', 
    		defVal = c(0, Inf), interpolation = 'back.inter.forth', 
    		colName = c('ava.lo', 'ava.up'), cls = 'supply')    
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
    .Object@parameters[['mTechSpan']] <- createParameter('mTechSpan', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechOMCost']] <- createParameter('mTechOMCost', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    .Object@parameters[['mTechEac']] <- createParameter('mTechEac', c('tech', 'region', 'year'), 'map', cls = 'technology')    
    # simple & multi
    .Object@parameters[['pTechCap2act']] <- 
    	createParameter('pTechCap2act', 'tech', 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', cls = 'technology', colName = 'cap2act', slot = 'cap2act')    
    .Object@parameters[['pTechEac']] <- 
      createParameter('pTechEac', c('tech', 'region', 'year'), 'simple', 
        defVal = 0, interpolation = 'back.inter.forth', cls = 'technology')    
    .Object@parameters[['pTechEmisComm']] <- createParameter('pTechEmisComm', c('tech', 'comm'), 'simple', 
    	defVal = 1, cls = 'technology', colName = 'combustion')    
    .Object@parameters[['pTechOlife']] <- 
    	createParameter('pTechOlife', c('tech', 'region'), 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth', colName = 'olife', cls = 'technology')          
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
    	defVal = 1, interpolation = 'back.inter.forth', colName = 'olife')    
    for(i in c('pStorageStock', 'pStorageFixom', 'pStorageInvcost', 'pStorageEac'))
    	.Object@parameters[[i]] <- createParameter(i, c('stg', 'region', 'year'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth')    
    for(i in c('pStorageInpEff', 'pStorageOutEff', 'pStorageStgEff'))
    	.Object@parameters[[i]] <- createParameter(i, 
    		c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
    		defVal = 1, interpolation = 'back.inter.forth')    
    for(i in c('pStorageCostStore', 'pStorageCostInp', 'pStorageCostOut'))
    	.Object@parameters[[i]] <- createParameter(i, 
    		c('stg', 'region', 'year', 'slice'), 'simple', 
    		defVal = 0, interpolation = 'back.inter.forth')    
    .Object@parameters[['pStorageAf']] <- createParameter('pStorageAf', 
    	c('stg', 'region', 'year', 'slice'), 'multi', 
    	defVal = c(0, 1), interpolation = 'back.inter.forth')
    .Object@parameters[['pStorageCap2stg']] <- createParameter('pStorageCap2stg', 'stg', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'storage', colName = 'cap2stg', slot = 'cap2stg')    
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
    for(i in c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageInp2AInp', 'pStorageInp2AOut', 
    	'pStorageOut2AInp', 'pStorageOut2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 
    	'pStorageNCap2AInp', 'pStorageNCap2AOut'))
      .Object@parameters[[i]] <- createParameter(i, c('stg', 'acomm', 'region', 'year', 'slice'), 'simple', 
                                                 defVal = 0, interpolation = 'back.inter.forth')    
    .Object@parameters[['pStorageNCap2Stg']] <- createParameter('pStorageNCap2Stg', 
                 c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '')    
    .Object@parameters[['pStorageCharge']] <- createParameter('pStorageCharge', 
              c('stg', 'comm', 'region', 'year', 'slice'), 'simple', defVal = 0, interpolation = '')    
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
    	'expp', 'simple',  defVal = 0, interpolation = 'back.inter.forth', cls = 'export', 
    	slot = 'reserve', colName = 'reserve')
    .Object@parameters[['pImportRowRes']] <- createParameter('pImportRowRes', 
    	'imp', 'simple',  defVal = 0, interpolation = 'back.inter.forth', cls = 'import', slot = 'reserve', colName = 'reserve')
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
    # Additional for compatibility with GLPK
    .Object@parameters[['pDiscountFactor']] <- createParameter('pDiscountFactor', c('region', 'year'), 'simple')    
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
    .Object@parameters[['mTechEmsFuel']] <- createParameter('mTechEmsFuel', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyImport']] <- createParameter('mDummyImport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyExport']] <- createParameter('mDummyExport', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mDummyCost']] <- createParameter('mDummyCost', c('comm', 'region', 'year'), 'map') 
    .Object@parameters[['mTradeIr']] <- createParameter('mTradeIr', c('trade', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrUp']] <- createParameter('mTradeIrUp', c('trade', 'src', 'dst', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrAInp2']] <- createParameter('mTradeIrAInp2', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrAOut2']] <- createParameter('mTradeIrAOut2', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrAInpTot']] <- createParameter('mTradeIrAInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
    .Object@parameters[['mTradeIrAOutTot']] <- createParameter('mTradeIrAOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
    
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
    
    .Object@parameters[['mSupOutTot']] <- createParameter('mSupOutTot', c('comm', 'region', 'slice'), 'map') 
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
    	defVal = 0, interpolation = 'back.inter.forth', colName = '', cls = 'trade')    
    
    .Object@parameters[['pTradeCap2Act']] <- createParameter('pTradeCap2Act', 'trade', 'simple', 
    	defVal = 1, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cap2act', slot = 'cap2act')    
    
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

