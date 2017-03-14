################################################################################
# Class generating code
################################################################################
# ! User never use this class
################################################################################
setClass("CodeProduce", # modInp
  representation(
    set = "list", # @sets List with set : tech, sup, group, comm, region, year, slice
    maptable = "list", # @parameters List with techology parameter
    constrain = "list", # @customConstrains
    model_reduced      = "character", # @modelVersion and @solver 
    model_reduced_glpk = "character",
    model_full         = "character", 
    model_full_glpk    = "character",
    misc = "list"
  ),
  prototype(
    set = list(tech = c(), sup = c(), group = c(),
                comm = c(), region = c(), year = c(), slice = c()
    ),
    maptable = list(), # List with techology parameter
    constrain = list(), 
    #model = readLines(paste(Sys.getenv('dropbox'), '/package/bottomup/gams/model.gms', sep = '')),
    #model_glpk = readLines(paste(Sys.getenv('dropbox'), '/package/bottomup/glpk/glpk.mod', sep = ''))
    model_reduced = readLines('gams/model_reduced.gms'),
    model_reduced_glpk = readLines('glpk/glpk_reduced.mod'),
    model_full = readLines('gams/model_full.gms'),
    model_full_glpk = readLines('glpk/glpk_full.mod'),
    #! Misc
    misc = list(
      GUID = "dc8680b2-130d-4a40-86b8-3a33018e005e"
    )
  )
);

# Constructor
setMethod("initialize", "CodeProduce",
  function(.Object) {
  # Create MapTable
    # Base set
    .Object@maptable[['region']] <- createSet('region')    
    .Object@maptable[['year']]   <- createSet('year')    
    .Object@maptable[['slice']]  <- createSet('slice')    
    .Object@maptable[['comm']]   <- createSet('comm')    
    .Object@maptable[['sup']]    <- createSet('sup')    
    .Object@maptable[['dem']]    <- createSet('dem')    
    .Object@maptable[['tech']]   <- createSet('tech')    
    .Object@maptable[['group']]  <- createSet('group')    
    .Object@maptable[['stg']]    <- createSet('stg')    
    .Object@maptable[['expp']]    <- createSet('expp')    
    .Object@maptable[['imp']]    <- createSet('imp')    
    .Object@maptable[['trade']]    <- createSet('trade')    
    .Object@maptable[['cns']] <- createSet('cns')    

    .Object@maptable[['mSlicePrevious']] <- MapTable('mSlicePrevious', c('slice', 'slice'), 'map')    
    .Object@maptable[['mSlicePreviousYear']] <- MapTable('mSlicePreviousYear', 'slice', 'map')    

  # Commodity
    # Map
    #.Object@maptable[['ems_from']] <- 
    #    MapTable('ems_from', c('comm', 'commp'), 'map')    
    .Object@maptable[['mUpComm']] <- MapTable('mUpComm', 'comm', 'map')    
    .Object@maptable[['mLoComm']] <- MapTable('mLoComm', 'comm', 'map')    
    .Object@maptable[['mFxComm']] <- MapTable('mFxComm', 'comm', 'map')    
    # Single
    .Object@maptable[['pEmissionFactor']] <- 
        MapTable('pEmissionFactor', c('comm', 'commp'), 'single',  #PPP
        default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pAggregateFactor']] <- 
        MapTable('pAggregateFactor', c('comm', 'commp'), 'single', #PPP
        default = 0, interpolation = 'back.inter.forth')    
  # Other commodity attribute
    # Demand
    # Map
    .Object@maptable[['mDemComm']] <- 
        MapTable('mDemComm', c('dem', 'comm'), 'map')    
    .Object@maptable[['pDemand']] <- 
        MapTable('pDemand', c('dem', 'region', 'year', 'slice'), 'single', 
        default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'dem')
    # Dummy import
    .Object@maptable[['pDummyImportCost']] <- 
        MapTable('pDummyImportCost', c('comm', 'region', 'year', 'slice'), 'single', 
        default = Inf, interpolation = 'back.inter.forth', for_sysInfo = 'dummyImport')    
    # Dummy export
    .Object@maptable[['pDummyExportCost']] <- 
        MapTable('pDummyExportCost', c('comm', 'region', 'year', 'slice'), 'single', 
        default = Inf, interpolation = 'back.inter.forth', for_sysInfo = 'dummyExport')    
    # Tax
    .Object@maptable[['pTaxCost']] <- 
        MapTable('pTaxCost', c('comm', 'region', 'year', 'slice'), 'single', 
        default = 0, interpolation = 'inter.forth', for_sysInfo = 'tax')    
    # Subs
    .Object@maptable[['pSubsCost']] <- 
        MapTable('pSubsCost', c('comm', 'region', 'year', 'slice'), 'single', 
        default = 0, interpolation = 'inter.forth', for_sysInfo = 'subs')    
  # Supply
    # Map
    .Object@maptable[['mSupComm']] <- 
        MapTable('mSupComm', c('sup', 'comm'), 'map')    
    .Object@maptable[['mSupSpan']] <- 
        MapTable('mSupSpan', c('sup', 'region'), 'map')    
    # Single
    .Object@maptable[['pSupCost']] <- 
        MapTable('pSupCost', c('sup', 'region', 'year', 'slice'), 'single', 
        default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cost')    
    .Object@maptable[['pSupReserve']] <- 
        MapTable('pSupReserve', c('sup'), 'single', 
        default = Inf, interpolation = 'back.inter.forth')    
    # Double
    .Object@maptable[['pSupAva']] <- 
        MapTable('pSupAva', c('sup', 'region', 'year', 'slice'), 'double', 
        default = c(0, Inf), interpolation = 'back.inter.forth', 
          for_sysInfo = c('ava.lo', 'ava.up'))    
  # Technology
    # Map
    for(i in c('mTechInpComm', 'mTechOutComm', 'mTechOneComm', 
      'mTechEmitedComm', 'mTechAInp', 'mTechAOut'))
        .Object@maptable[[i]] <- MapTable(i, c('tech', 'comm'), 'map')    
#    for(i in c('mTechCinpAInp', 'mTechCoutAInp', 'mTechCinpAOut', 'mTechCoutAOut'))
#        .Object@maptable[[i]] <- MapTable(i, c('tech', 'comm', 'commp'), 'map')    
    for(i in c('mTechInpGroup', 'mTechOutGroup'))
        .Object@maptable[[i]] <- MapTable(i, c('tech', 'group'), 'map')    
    .Object@maptable[['mTechGroupComm']] <- MapTable('mTechGroupComm', 
        c('tech', 'group', 'comm'), 'map')    
#    .Object@maptable[['mTechStartYear']] <- MapTable('mTechStartYear', 
#        c('tech', 'region', 'year'), 'map')    
#    .Object@maptable[['mTechEndYear']] <- MapTable('mTechEndYear', 
#        c('tech', 'region', 'year'), 'map')    
    .Object@maptable[['mTechUpgrade']] <- MapTable('mTechUpgrade', 
        c('tech', 'techp'), 'map')    
    .Object@maptable[['mTechRetirement']] <- MapTable('mTechRetirement', c('tech'), 'map')    
    # For disable technology with unexceptable start year
    .Object@maptable[['mTechNew']] <- MapTable('mTechNew', c('tech', 'region', 'year'), 'map')    
    .Object@maptable[['mTechSpan']] <- MapTable('mTechSpan', c('tech', 'region', 'year'), 'map')    
    # Single & Double
    .Object@maptable[['pTechCap2act']] <- 
        MapTable('pTechCap2act', 'tech', 'single', 
        default = 1, interpolation = 'back.inter.forth')    
    .Object@maptable[['pTechEmisComm']] <- MapTable('pTechEmisComm', c('tech', 'comm'), 'single', default = 1)    
    .Object@maptable[['pTechOlife']] <- 
        MapTable('pTechOlife', c('tech', 'region'), 'single', 
        default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'olife')          
        .Object@maptable[['pTechFixom']] <- MapTable('pTechFixom', 
              c('tech', 'region', 'year'), 'single', 
        default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'fixom')    
        .Object@maptable[['pTechInvcost']] <- MapTable('pTechInvcost', 
              c('tech', 'region', 'year'), 'single', 
        default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'invcost')    
        .Object@maptable[['pTechStock']] <- MapTable('pTechStock', 
              c('tech', 'region', 'year'), 'single', 
        default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'stock')    
        .Object@maptable[['pTechVarom']] <- MapTable('pTechVarom', 
              c('tech', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'varom')    
        .Object@maptable[['pTechAfa']] <- MapTable('pTechAfa', 
              c('tech', 'region', 'year', 'slice'), 'double', 
                default = c(0, 1), interpolation = 'back.inter.forth', 
                for_sysInfo = c('afa.lo', 'afa.up'))    
        .Object@maptable[['pTechGinp2use']] <- MapTable('pTechGinp2use', 
              c('tech', 'group', 'region', 'year', 'slice'), 'single', 
                default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'ginp2use')    
        .Object@maptable[['pTechCinp2ginp']] <- MapTable('pTechCinp2ginp', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'cinp2ginp')    
        .Object@maptable[['pTechUse2cact']] <- MapTable('pTechUse2cact', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'use2cact')    
        # Aux
        .Object@maptable[['pTechUse2AInp']] <- MapTable('pTechUse2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'use2ainp')    
        .Object@maptable[['pTechAct2AInp']] <- MapTable('pTechAct2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'act2ainp')    
        .Object@maptable[['pTechCap2AInp']] <- MapTable('pTechCap2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cap2ainp')    
        .Object@maptable[['pTechUse2AOut']] <- MapTable('pTechUse2AOut', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'use2aout')    
        .Object@maptable[['pTechAct2AOut']] <- MapTable('pTechAct2AOut', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'act2aout')    
        .Object@maptable[['pTechCap2AOut']] <- MapTable('pTechCap2AOut', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cap2aout')    

        .Object@maptable[['pTechNCap2AInp']] <- MapTable('pTechNCap2AInp', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cap2aout')    
        .Object@maptable[['pTechNCap2AOut']] <- MapTable('pTechNCap2AOut', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cap2aout')    

        .Object@maptable[['pTechCinp2AInp']] <- MapTable('pTechCinp2AInp', 
              c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cinp2ainp')    
        .Object@maptable[['pTechCout2AInp']] <- MapTable('pTechCout2AInp', 
              c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cout2ainp')    
        .Object@maptable[['pTechCinp2AOut']] <- MapTable('pTechCinp2AOut', 
              c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cinp2aout')    
        .Object@maptable[['pTechCout2AOut']] <- MapTable('pTechCout2AOut', 
              c('tech', 'acomm', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cout2aout')    

        # Aux stop
        .Object@maptable[['pTechCact2cout']] <- MapTable('pTechCact2cout', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'cact2cout')    
        .Object@maptable[['pTechCinp2use']] <- MapTable('pTechCinp2use', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 1, interpolation = 'back.inter.forth', for_sysInfo = 'cinp2use')  
        .Object@maptable[['pTechCvarom']] <- MapTable('pTechCvarom', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'cvarom')    
        .Object@maptable[['pTechAvarom']] <- MapTable('pTechAvarom', 
              c('tech', 'acomm', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth', for_sysInfo = 'avarom')    
        .Object@maptable[['pTechShare']] <- MapTable('pTechShare', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'double', 
                default = c(0, 1), interpolation = 'back.inter.forth', 
                for_sysInfo = c('share.lo', 'share.up'))    
        .Object@maptable[['pTechAfac']] <- MapTable('pTechAfac', 
              c('tech', 'comm', 'region', 'year', 'slice'), 'double', 
                default = c(0, Inf), interpolation = 'back.inter.forth', 
                for_sysInfo = c('afac.lo', 'afac.up'))
                
  ## NEED SET ALIAS FOR SYS INFO
  # Reserve
    .Object@maptable[['mStorageComm']] <- MapTable('mStorageComm', c('stg', 'comm'), 'map')    
    # Single & Double
        .Object@maptable[['pStorageOlife']] <- MapTable('pStorageOlife', 
              c('stg', 'region'), 'single', 
                default = 1, interpolation = 'back.inter.forth')    
    for(i in c('pStorageStock', 'pStorageFixom', 'pStorageInvcost'))
        .Object@maptable[[i]] <- MapTable(i, 
              c('stg', 'region', 'year'), 'single', 
                default = 0, interpolation = 'back.inter.forth')    
    for(i in c('pStorageInpLoss', 'pStorageOutLoss', 'pStorageStoreStock',
               'pStorageCostStore', 'pStorageCostInp', 'pStorageCostOut'))
        .Object@maptable[[i]] <- MapTable(i, 
              c('stg', 'region', 'year', 'slice'), 'single', 
                default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pStorageStoreLoss']] <- MapTable('pStorageStoreLoss', 
          c('stg', 'region', 'year', 'slice'), 'single', 
            default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pStorageCap']] <- MapTable('pStorageCap', 
          c('stg', 'region', 'year'), 'double', 
            default = c(0, Inf), interpolation = 'back.inter.forth')
    .Object@maptable[['mStorageNew']] <- MapTable('mStorageNew', c('stg', 'region', 'year'), 'map')    
    .Object@maptable[['mStorageSpan']] <- MapTable('mStorageSpan', c('stg', 'region', 'year'), 'map')    
  # Trade
    # Map
    .Object@maptable[['mExpComm']] <- 
        MapTable('mExpComm', c('expp', 'comm'), 'map')    
    .Object@maptable[['mImpComm']] <- 
        MapTable('mImpComm', c('imp', 'comm'), 'map')    
    .Object@maptable[['mTradeComm']] <- 
        MapTable('mTradeComm', c('trade', 'comm'), 'map')    
    .Object@maptable[['mTradeSrc']] <- 
        MapTable('mTradeSrc', c('trade', 'region'), 'map')    
    .Object@maptable[['mTradeDst']] <- 
        MapTable('mTradeDst', c('trade', 'region'), 'map')    
    .Object@maptable[['mSlicePrevious']] <- MapTable('mSlicePrevious', c('slice', 'slice'), 'map')    
    .Object@maptable[['pTradeIrCost']] <- MapTable('pTradeIrCost', 
          c('trade', 'src', 'dst', 'year', 'slice'), 'single', 
            default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pTradeIrMarkup']] <- MapTable('pTradeIrMarkup', 
          c('trade', 'src', 'dst', 'year', 'slice'), 'single', 
            default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pExportRowPrice']] <- MapTable('pExportRowPrice', 
          c('expp', 'region', 'year', 'slice'), 'single', 
            default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pImportRowPrice']] <- MapTable('pImportRowPrice', 
          c('imp', 'region', 'year', 'slice'), 'single', 
            default = 0, interpolation = 'back.inter.forth')    
    .Object@maptable[['pTradeIr']] <- MapTable('pTradeIr', 
          c('trade', 'src', 'dst', 'year', 'slice'), 'double', 
            default = c(0, Inf), interpolation = 'back.inter.forth')
    .Object@maptable[['pExportRow']] <- MapTable('pExportRow', 
          c('expp', 'region', 'year', 'slice'), 'double', 
            default = c(0, Inf), interpolation = 'back.inter.forth')
    .Object@maptable[['pImportRow']] <- MapTable('pImportRow', 
          c('imp', 'region', 'year', 'slice'), 'double', 
            default = c(0, Inf), interpolation = 'back.inter.forth')
    .Object@maptable[['pExportRowRes']] <- MapTable('pExportRowRes', 
          'expp', 'single',  default = 0, interpolation = 'back.inter.forth')
    .Object@maptable[['pImportRowRes']] <- MapTable('pImportRowRes', 
          'imp', 'single',  default = 0, interpolation = 'back.inter.forth')
  # For LEC
  .Object@maptable[['mLECRegion']] <- MapTable('mLECRegion', 'region', 'map')    
  .Object@maptable[['pLECLoACT']] <- 
        MapTable('pLECLoACT', 'region', 'single', 
                default = 0, interpolation = 'back.inter.forth')    

  # Standard constraint
    # Map
    for(i in c("mCnsLType", "mCnsLhsComm", "mCnsLhsRegion", "mCnsLhsYear", "mCnsLhsSlice", 
      "mCnsLe", "mCnsGe", "mCnsRhsTypeShareIn", "mCnsRhsTypeShareOut", "mCnsRhsTypeConst", "mCnsInpTech", 
      "mCnsOutTech", "mCnsCapTech", "mCnsNewCapTech", "mCnsOutSup", "mCnsInp", "mCnsOut", "mCnsInvTech",
      "mCnsEacTech", "mCnsTechCInp", "mCnsTechCOut", "mCnsTechAInp", "mCnsTechAOut", "mCnsTechEmis",
      "mCnsActTech", "mCnsRhsTypeGrowth", "mCnsFixomTech", 
      "mCnsVaromTech", "mCnsActVaromTech", "mCnsCVaromTech", "mCnsAVaromTech"))
        .Object@maptable[[i]] <- MapTable(i, 'cns', 'map')    
    for(i in c('tech', 'sup', 'comm', 'region', 'year', 'slice')) {
        nn <- paste('mCns', toupper(substr(i, 1, 1)), substr(i, 2, nchar(i)), sep = '')
        .Object@maptable[[nn]] <- MapTable(nn, c('cns', i), 'map')    
    }
    .Object@maptable[['mCnsTech']] <- MapTable('mCnsTech', c('cns', 'tech'), 'map') 
    .Object@maptable[['mCnsSup']] <- MapTable('mCnsSup', c('cns', 'sup'), 'map') 
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
      .Object@maptable[[gsub('[(].*', '', i)]] <- MapTable(gsub('[(].*', '', i), 
            strsplit(gsub('[)]', '', gsub('.*[(]', '', i)), ', ')[[1]], 'single', 
              default = 0, interpolation = 'back.inter.forth')      
    }

  # Other
    # Discount
    .Object@maptable[['pDiscount']] <- 
        MapTable('pDiscount', c('region', 'year'), 'single', 
                default = .1, interpolation = 'back.inter.forth', for_sysInfo = 'discount')    
  # Additional for compatibility with GLPK
  .Object@maptable[['ndefpTechOlife']] <- MapTable('ndefpTechOlife', c('tech', 'region'), 'map')   
  .Object@maptable[['defpTechAfaUp']] <- MapTable('defpTechAfaUp', c('tech', 'region', 'year', 'slice'), 'map')   
  .Object@maptable[['defpTechAfacUp']] <- 
      MapTable('defpTechAfacUp', c('tech', 'comm', 'region', 'year', 'slice'), 'map')    
  .Object@maptable[['defpSupAvaUp']] <- 
      MapTable('defpSupAvaUp', c('sup', 'region', 'year', 'slice'), 'map')    
  .Object@maptable[['defpSupReserve']] <- MapTable('defpSupReserve', c('sup'), 'map')    
  .Object@maptable[['defpStorageCapUp']] <- MapTable('defpStorageCapUp', c('stg', 'region', 'year'), 'map')    
  .Object@maptable[['defpTradeIrUp']] <- MapTable('defpTradeIrUp', 
                                        c('trade', 'src', 'dst', 'year', 'slice'), 'map')    
    .Object@maptable[['defpExportRowRes']] <- MapTable('defpExportRowRes', 'expp', 'map')    
    .Object@maptable[['defpImportRowRes']] <- MapTable('defpImportRowRes', 'imp', 'map')    
    .Object@maptable[['defpExportRowUp']] <- MapTable('defpExportRowUp', 
        c('expp', 'region', 'year', 'slice'), 'map')    
    .Object@maptable[['defpImportRowUp']] <- MapTable('defpImportRowUp', 
        c('imp', 'region', 'year', 'slice'), 'map')    
  .Object@maptable[['defpDummyImportCost']] <- MapTable('defpDummyImportCost', 
      c('comm', 'region', 'year', 'slice'), 'map')    
  .Object@maptable[['defpDummyExportCost']] <- MapTable('defpDummyExportCost', 
      c('comm', 'region', 'year', 'slice'), 'map')    
  .Object@maptable[['pDiscountFactor']] <- MapTable('pDiscountFactor', c('region', 'year'), 'single')    
  .Object@maptable[['mDiscountZero']] <- MapTable('mDiscountZero', 'region', 'map', default = 1) 
  ## Milestone set
  .Object@maptable[['mMidMilestone']] <- MapTable('mMidMilestone', 'year', 'map', default = 1) 
  .Object@maptable[['mMilestoneHasNext']] <- MapTable('mMilestoneHasNext', 'year', 'map', default = 1) 
  .Object@maptable[['mMilestoneLast']] <- MapTable('mMilestoneLast', 'year', 'map', default = 1) 
  .Object@maptable[['mStartMilestone']] <- MapTable('mStartMilestone', c('year', 'yearp'), 'map', default = 1) 
  .Object@maptable[['mEndMilestone']] <- MapTable('mEndMilestone', c('year', 'yearp'), 'map', default = 1) 
  .Object@maptable[['mMilestoneNext']] <- MapTable('mMilestoneNext', c('year', 'yearp'), 'map', default = 1) 

  ## Fix to previous value 
   .Object <- constrCodeProduce(.Object)  
  .Object
})

# Print
setMethod('print', 'CodeProduce', function(x, ...) {
  if (length(x@maptable) == 0) {
    cat('There is no data\n')
  } else {
    for(i in 1:length(x@maptable)) {
      print(x@maptable[[i]])
    }
  }
})

