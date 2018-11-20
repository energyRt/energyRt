################################################################################
# Class generating code
################################################################################
# ! User never use this class
################################################################################
setClass("modInp", # modInp
  representation(
    set = "list", # @sets List with set : tech, sup, group, comm, region, year, slice
    parameters = "list", # @parameters List with techology parameter
    customConstrains = "list", # @customConstrains
    modelVersion        = "character",
    solver              = "character",
    misc = "list"
  ),
  prototype(
    set = list(tech = c(), sup = c(), group = c(),
                comm = c(), region = c(), year = c(), slice = c()
    ),
    parameters = list(), # List with techology parameter
    customConstrains = list(), 
    modelVersion        = "",
    solver              = "",
    #! Misc
    misc = list(
    )
  )
);



# Constructor
setMethod("initialize", "modInp",
  function(.Object) {
  # Create parameters
    attr(.Object, 'GUID') <- 'dc8680b2-130d-4a40-86b8-3a33018e005e'
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
    .Object@parameters[['cns']] <- createSet('cns')    

    .Object@parameters[['mSliceNext']] <- createParameter('mSliceNext', c('slice', 'slicep'), 'map')    

    .Object@parameters[['mSameRegion']] <- createParameter('mSameRegion', c('region', 'regionp'), 'map') # for glpk    
    .Object@parameters[['mSameSlice']] <- createParameter('mSameSlice', c('slice', 'slicep'), 'map') # for glpk    
    
    .Object@parameters[['ordYear']] <- createParameter('ordYear', 'year', 'simple', 
        defVal = 0, interpolation = 'inter.forth', colName = '') # for glpk    
    .Object@parameters[['cardYear']] <- createParameter('cardYear', 'year', 'simple', 
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
    .Object@parameters[['mStorageSlice']] <- createParameter('mStorageSlice', c('stg', 'slice'), 'map', cls = 'storage')   
    .Object@parameters[['mTradeSlice']] <- createParameter('mTradeSlice', c('trade', 'slice'), 'map', cls = 'trade')   
    .Object@parameters[['mCommSlice']] <- createParameter('mCommSlice', c('comm', 'slice'), 'map', cls = 'commodity')   
    .Object@parameters[['mAllSliceParentChild']] <- createParameter('mAllSliceParentChild', c('slice', 'slicep'), 'map')   
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
        defVal = 0, interpolation = 'inter.forth', colName = 'tax', cls = 'constrain')    
    # Subs
    .Object@parameters[['pSubsCost']] <- 
        createParameter('pSubsCost', c('comm', 'region', 'year', 'slice'), 'simple', 
        defVal = 0, interpolation = 'inter.forth', colName = 'subs', cls = 'constrain')    
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
      'mTechEmitedComm', 'mTechAInp', 'mTechAOut'))
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
    # simple & multi
    .Object@parameters[['pTechCap2act']] <- 
        createParameter('pTechCap2act', 'tech', 'simple', 
        defVal = 1, interpolation = 'back.inter.forth', cls = 'technology', colName = 'cap2act', slot = 'cap2act')    
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
        .Object@parameters[['pTechAfa']] <- createParameter('pTechAfa', 
              c('tech', 'region', 'year', 'slice'), 'multi', 
                defVal = c(0, 1), interpolation = 'back.inter.forth', 
                colName = c('afa.lo', 'afa.up'), cls = 'technology')    
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
        .Object@parameters[['pTechUse2AInp']] <- createParameter('pTechUse2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
                defVal = 0, interpolation = 'back.inter.forth', colName = 'use2ainp', cls = 'technology')    
        .Object@parameters[['pTechAct2AInp']] <- createParameter('pTechAct2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
                defVal = 0, interpolation = 'back.inter.forth', colName = 'act2ainp', cls = 'technology')    
        .Object@parameters[['pTechCap2AInp']] <- createParameter('pTechCap2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
                defVal = 0, interpolation = 'back.inter.forth', colName = 'cap2ainp', cls = 'technology')    
        .Object@parameters[['pTechUse2AOut']] <- createParameter('pTechUse2AOut', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'simple', 
                defVal = 0, interpolation = 'back.inter.forth', colName = 'use2aout', cls = 'technology')    
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
        .Object@parameters[['pTechAfac']] <- createParameter('pTechAfac', c('tech', 'comm', 'region', 'year', 'slice'), 'multi', 
                defVal = c(0, Inf), interpolation = 'back.inter.forth', colName = c('afac.lo', 'afac.up'), cls = 'technology')
                
  ## NEED SET ALIAS FOR SYS INFO
  # Reserve
    .Object@parameters[['mStorageComm']] <- createParameter('mStorageComm', c('stg', 'comm'), 'map')    
    # simple & multi
        .Object@parameters[['pStorageOlife']] <- createParameter('pStorageOlife', 
              c('stg', 'region'), 'simple', 
                defVal = 1, interpolation = 'back.inter.forth', colName = 'olife')    
    for(i in c('pStorageStock', 'pStorageFixom', 'pStorageInvcost'))
        .Object@parameters[[i]] <- createParameter(i, 
              c('stg', 'region', 'year'), 'simple', 
                defVal = 0, interpolation = 'back.inter.forth')    
        for(i in c('pStorageInpEff', 'pStorageOutEff', 'pStorageStgEff'))
          .Object@parameters[[i]] <- createParameter(i, 
                                                     c('stg', 'comm', 'region', 'year', 'slice'), 'simple', 
                                                     defVal = 0, interpolation = 'back.inter.forth')    
        for(i in c('pStorageCostStore', 'pStorageCostInp', 'pStorageCostOut'))
          .Object@parameters[[i]] <- createParameter(i, 
                                                     c('stg', 'region', 'year', 'slice'), 'simple', 
                                                     defVal = 0, interpolation = 'back.inter.forth')    
        .Object@parameters[['pStorageAfa']] <- createParameter('pStorageAfa', 
                                                           c('stg', 'region', 'year', 'slice'), 'multi', 
                                                           defVal = c(0, 1), interpolation = 'back.inter.forth')
    .Object@parameters[['pStorageCap2act']] <- createParameter('pStorageCap2act', 'stg', 'simple', 
                      defVal = 1, interpolation = 'back.inter.forth', cls = 'storage', colName = 'cap2cat', slot = 'cap2act')    
    .Object@parameters[['mStorageNew']] <- createParameter('mStorageNew', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageSpan']] <- createParameter('mStorageSpan', c('stg', 'region', 'year'), 'map')    
    .Object@parameters[['mStorageAInp']] <- createParameter('mStorageAInp', c('stg', 'comm'), 'map', cls = 'storage')    
    .Object@parameters[['mStorageAOut']] <- createParameter('mStorageAOut', c('stg', 'comm'), 'map', cls = 'storage')    
    for(i in c('pStorageStg2AInp', 'pStorageStg2AOut', 'pStorageInp2AInp', 'pStorageInp2AOut', 
               'pStorageOut2AInp', 'pStorageOut2AOut', 'pStorageCap2AInp', 'pStorageCap2AOut', 
               'pStorageNCap2AInp', 'pStorageNCap2AOut'))
      .Object@parameters[[i]] <- createParameter(i, c('stg', 'acomm', 'region', 'year', 'slice'), 'simple', 
                                                 defVal = 0, interpolation = 'back.inter.forth')    
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
    .Object@parameters[['mTradeSrc']] <- 
        createParameter('mTradeSrc', c('trade', 'region'), 'map', cls = 'trade')    
    .Object@parameters[['mTradeDst']] <- 
        createParameter('mTradeDst', c('trade', 'region'), 'map', cls = 'trade')  
    drt1 <- c('pTradeIrCsrc2Aout', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Aout', 'pTradeIrCdst2Ainp')
    drt2 <- c(        'csrc2aout',         'csrc2ainp',         'cdst2aout',         'cdst2ainp')
    for (i in seq_along(drt1))
      .Object@parameters[[drt1[i]]] <- createParameter(drt1[i], c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
                                                            defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = drt2[i])    
    
    .Object@parameters[['pTradeIrCost']] <- createParameter('pTradeIrCost', 
          c('trade', 'src', 'dst', 'year', 'slice'), 'simple', 
            defVal = 0, interpolation = 'back.inter.forth', cls = 'trade', colName = 'cost')    
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

  # Standard constraint
    # Map
    for(i in c("mCnsLType", "mCnsLhsComm", "mCnsLhsRegion", "mCnsLhsYear", "mCnsLhsSlice", 
      "mCnsLe", "mCnsGe", "mCnsRhsTypeShareIn", "mCnsRhsTypeShareOut", "mCnsRhsTypeConst", "mCnsInpTech", 
      "mCnsOutTech", "mCnsCapTech", "mCnsNewCapTech", "mCnsOutSup", "mCnsInp", "mCnsOut", "mCnsInvTech",
      "mCnsEacTech", "mCnsTechCInp", "mCnsTechCOut", "mCnsTechAInp", "mCnsTechAOut", "mCnsTechEmis",
      "mCnsActTech", "mCnsRhsTypeGrowth", "mCnsFixomTech", 
      "mCnsVaromTech", "mCnsActVaromTech", "mCnsCVaromTech", "mCnsAVaromTech", "mCnsBalance"))
        .Object@parameters[[i]] <- createParameter(i, 'cns', 'map', cls = 'constrain')    
    for(i in c('tech', 'sup', 'comm', 'region', 'year', 'slice')) {
        nn <- paste('mCns', toupper(substr(i, 1, 1)), substr(i, 2, nchar(i)), sep = '')
        .Object@parameters[[nn]] <- createParameter(nn, c('cns', i), 'map', cls = 'constrain')    
    }
    .Object@parameters[['mCnsTech']] <- createParameter('mCnsTech', c('cns', 'tech'), 'map', cls = 'constrain') 
    .Object@parameters[['mCnsSup']] <- createParameter('mCnsSup', c('cns', 'sup'), 'map', cls = 'constrain') 
    for(i in c("pRhs(cns)", "pRhsS(cns, slice)", "pRhsY(cns, year)", "pRhsYS(cns, year, slice)", 
      "pRhsR(cns, region)", "pRhsRS(cns, region, slice)", "pRhsRY(cns, region, year)", 
      "pRhsRYS(cns, region, year, slice)", "pRhsC(cns, comm)", "pRhsCS(cns, comm, slice)", 
      "pRhsCY(cns, comm, year)", "pRhsCYS(cns, comm, year, slice)", "pRhsCR(cns, comm, region)", 
      "pRhsCRS(cns, comm, region, slice)", "pRhsCRY(cns, comm, region, year)", 
      "pRhsCRYS(cns, comm, region, year, slice)", "pRhsTech(cns, tech)", 
      "pRhsTechS(cns, tech, slice)", "pRhsTechY(cns, tech, year)", "pRhsTechYS(cns, tech, year, slice)", 
      "pRhsTechR(cns, tech, region)", "pRhsTechRS(cns, tech, region, slice)", 
      "pRhsTechRY(cns, tech, region, year)", "pRhsTechRYS(cns, tech, region, year, slice)", 
      "pRhsTechC(cns, tech, comm)", "pRhsTechCS(cns, tech, comm, slice)", "pRhsTechCY(cns, tech, comm, year)",
      "pRhsTechCYS(cns, tech, comm, year, slice)", "pRhsTechCR(cns, tech, comm, region)", 
      "pRhsTechCRS(cns, tech, comm, region, slice)", "pRhsTechCRY(cns, tech, comm, region, year)", 
      "pRhsTechCRYS(cns, tech, comm, region, year, slice)", "pRhsSup(cns, sup)", 
      "pRhsSupS(cns, sup, slice)", "pRhsSupY(cns, sup, year)", "pRhsSupYS(cns, sup, year, slice)", 
      "pRhsSupR(cns, sup, region)", "pRhsSupRS(cns, sup, region, slice)", "pRhsSupRY(cns, sup, region, year)",
      "pRhsSupRYS(cns, sup, region, year, slice)", "pRhsSupC(cns, sup, comm)", "pRhsSupCS(cns, sup, comm, slice)",
      "pRhsSupCY(cns, sup, comm, year)", "pRhsSupCYS(cns, sup, comm, year, slice)", 
      "pRhsSupCR(cns, sup, comm, region)", "pRhsSupCRS(cns, sup, comm, region, slice)", 
      "pRhsSupCRY(cns, sup, comm, region, year)", "pRhsSupCRYS(cns, sup, comm, region, year, slice)")) {
      .Object@parameters[[gsub('[(].*', '', i)]] <- createParameter(gsub('[(].*', '', i), 
            strsplit(gsub('[)]', '', gsub('.*[(]', '', i)), ', ')[[1]], 'simple', 
              defVal = 0, interpolation = 'back.inter.forth', cls = 'constrain', colName = 'rhs')      
    }

  # Other
    # Discount
    .Object@parameters[['pDiscount']] <- 
        createParameter('pDiscount', c('region', 'year'), 'simple', 
                defVal = .1, interpolation = 'back.inter.forth', colName = 'discount', cls = 'sysInfo')    
  # Additional for compatibility with GLPK
  .Object@parameters[['ndefpTechOlife']] <- createParameter('ndefpTechOlife', c('tech', 'region'), 'map')   
  .Object@parameters[['ndefpTechAfaUp']] <- createParameter('ndefpTechAfaUp', c('tech', 'region', 'year', 'slice'), 'map')   
  .Object@parameters[['ndefpTechAfacUp']] <- 
      createParameter('ndefpTechAfacUp', c('tech', 'comm', 'region', 'year', 'slice'), 'map')    
  .Object@parameters[['ndefpSupAvaUp']] <- 
      createParameter('ndefpSupAvaUp', c('sup', 'comm', 'region', 'year', 'slice'), 'map')    
  .Object@parameters[['ndefpSupReserveUp']] <- createParameter('ndefpSupReserveUp', c('sup', 'comm', 'region'), 'map')    
  .Object@parameters[['ndefpStorageOlife']] <- createParameter('ndefpStorageOlife', c('stg', 'region'), 'map')   
  .Object@parameters[['ndefpTradeIrUp']] <- createParameter('ndefpTradeIrUp', 
                                        c('trade', 'src', 'dst', 'year', 'slice'), 'map')    
    .Object@parameters[['ndefpExportRowRes']] <- createParameter('ndefpExportRowRes', 'expp', 'map')    
    .Object@parameters[['ndefpImportRowRes']] <- createParameter('ndefpImportRowRes', 'imp', 'map')    
    .Object@parameters[['ndefpExportRowUp']] <- createParameter('ndefpExportRowUp', 
        c('expp', 'region', 'year', 'slice'), 'map')    
    .Object@parameters[['ndefpImportRowUp']] <- createParameter('ndefpImportRowUp', 
        c('imp', 'region', 'year', 'slice'), 'map')    
  .Object@parameters[['ndefpDummyImportCost']] <- createParameter('ndefpDummyImportCost', 
      c('comm', 'region', 'year', 'slice'), 'map')    
  .Object@parameters[['ndefpDummyExportCost']] <- createParameter('ndefpDummyExportCost', 
      c('comm', 'region', 'year', 'slice'), 'map')    
  .Object@parameters[['pDiscountFactor']] <- createParameter('pDiscountFactor', c('region', 'year'), 'simple')    
  .Object@parameters[['mDiscountZero']] <- createParameter('mDiscountZero', 'region', 'map', defVal = 1) 
  ## Milestone set
  .Object@parameters[['mMidMilestone']] <- createParameter('mMidMilestone', 'year', 'map', defVal = 1) 
  .Object@parameters[['mMilestoneHasNext']] <- createParameter('mMilestoneHasNext', 'year', 'map', defVal = 1) 
  .Object@parameters[['mMilestoneLast']] <- createParameter('mMilestoneLast', 'year', 'map', defVal = 1) 
  .Object@parameters[['mStartMilestone']] <- createParameter('mStartMilestone', c('year', 'yearp'), 'map', defVal = 1) 
  .Object@parameters[['mEndMilestone']] <- createParameter('mEndMilestone', c('year', 'yearp'), 'map', defVal = 1) 
  .Object@parameters[['mMilestoneNext']] <- createParameter('mMilestoneNext', c('year', 'yearp'), 'map', defVal = 1) 
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

