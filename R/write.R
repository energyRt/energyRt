
write.default <- function(x, file = "data",
                          ncolumns = if(is.character(x)) 1 else 5,
                          append = FALSE, sep = " ") {
  base::write(x, file, ncolumns, append, sep)
}

#' Title
#'
#' @param scen 
#' @param tmp.dir 
#' @param solver 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
write.scenario <- function(scen, tmp.dir = NULL, solver = NULL, ...) {
  if (is.null(tmp.dir)) {
    if (!is.null(scen@misc$tmp.dir)) tmp.dir <- scen@misc$tmp.dir
  } else { 
    scen@misc$tmp.dir <- tmp.dir
  }
  if (F) {} # check if the scenario is interpolated
  if (is.null(solver)) solver <- scen@solver
  .solver_solve(scen, tmp.dir = tmp.dir, solver = solver, ..., 
                run = FALSE, write = TRUE)
}

write.model <- function(scen, ...) {
  message('Error: 
  No applicable method for "write" applied to an object of class "model".
  Use "interpolate(model, ...)" instead to get "scenario" object,
  and then "write(scenario, ...)"')
  # stop()
}
  

write_model <- function(scen, tmp.dir = NULL, solver = NULL, ...) {
  message("The function is depreciated, use `write` instead")
  write.scenario(scen, tmp.dir, solver, ...)
}


#### Internal functions ####
.write_multi_threads <- function(arg, scen, func, type) {
  require(parallel)
  tlp <- lapply(0:(arg$n.threads - 1), function(y) names(scen@modInp@parameters)[
    seq_along(scen@modInp@parameters) %% arg$n.threads == y])
  cl <- makeCluster(arg$n.threads)
  wrt_fun <- function(x, tlp, par, drr, func, type) {
    require(energyRt)
    for (i in tlp[[x + 1]]) {
      zz_data_tmp <- file(paste(drr, '/input/', i, '.', type, sep = ''), 'w')
      cat(func(par[[i]]), sep = '\n', file = zz_data_tmp)
      close(zz_data_tmp)
    }
    NULL
  }
  parLapply(cl, 0:(arg$n.threads - 1), wrt_fun, tlp, scen@modInp@parameters, arg$tmp.dir, func, type)
  stopCluster(cl)
  NULL
}

.write_inc_solver <- function(scen, arg, def_inc_solver, type, templ) {
  if (!is.null(scen@solver$inc_solver) && !is.null(scen@solver$solver))
    stop('have to define only one argument from scen@solver$inc_solver & scen@solver$solver')
  if (!is.null(scen@solver$solver))
    scen@solver$inc_solver <- gsub(templ, scen@solver$solver, def_inc_solver)
  if (is.null(scen@solver$inc_solver) && is.null(scen@solver$solver))
    scen@solver$inc_solver <- def_inc_solver
  zz <- file(paste0(arg$tmp.dir, 'inc_solver', type), 'w')
  cat(scen@solver$inc_solver, file = zz, sep = '\n')
  close(zz)
}

# writes "include" files to tmp.dir ("inc1" ... "inc5" - see GAMS code)
.write_inc_files <- function(arg, scen, type) { # renamed .add_five_includes
  if (is.null(type)) {
    fl <- c(names(scen@solver$files))
    for (i in 1:5)
      if (is.null(scen@solver[[paste0('inc', i)]]))
        fl <- c(fl, paste0('inc', i)) 
      if (is.null(fl)) {
        tmp <- paste0('There is (are) ', length(fl), 
                      ' files, that not suitable for lang ', scen@solver@lang,
                      '. File(s) list: "', paste0(fl, collapse = '", "'), '"')
        stop(tmp)
      }
  } 
  for (i in 1:5) {
    zz <- file(paste0(arg$tmp.dir, 'inc', i, type), 'w')
    cat(scen@solver[[paste0('inc', i)]], sep = '\n', file = zz)
    close(zz)
  }
  for (i in names(scen@solver$files)) {
    zz <- file(paste0(arg$tmp.dir, i), 'w')
    cat(scen@solver$files[[i]], sep = '\n', file = zz)
    close(zz)
  }
}

.write_mapping <- function(prec, interpolation_time_begin, interpolation_count, len_name) {
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]
  bacs <- paste0(rep('\b', len_name), collapse = '')
  rest = interpolation_count - 77;
  cat(paste0(rep(' ', len_name), collapse = ''))
  
  # Clean previous set data if any
  reduce.sect <- function(x, set) {
    x <- x[, set, drop = FALSE]
    x[!duplicated(x),, drop = FALSE]
  }
  reduce.sect.merge.unique <- function(xxx, set) {
    gg <- NULL
    for (x in xxx)
      gg <- rbind(gg, reduce.sect(x, set))
    unique(gg)
  }
  
  .interpolation_message('region', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  region <- .get_data_slot(prec@parameters$region)
  .interpolation_message('mMidMilestone', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  year <- .get_data_slot(prec@parameters$mMidMilestone)
  .interpolation_message('mSliceParentChildE', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  # Total parameter ruductions
  mSliceParentChildE <- .get_data_slot(prec@parameters$mSliceParentChildE)
  .interpolation_message('mCommSlice', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mCommSlice <- .get_data_slot(prec@parameters$mCommSlice)
  uu <- mSliceParentChildE
  colnames(uu) <- c('slicep', 'slice')
  map_for_comm <- merge0(mCommSlice, uu)[, c('comm', 'slicep')]
  colnames(map_for_comm) <- c('comm', 'slice')
  map_for_comm <- map_for_comm[!duplicated(map_for_comm), ]
  .interpolation_message('mCommSliceOrParent', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  # mCommSliceOrParent
  l1 <- merge0(.get_data_slot(prec@parameters$comm), .get_data_slot(prec@parameters$slice))
  l2 <-merge0(mCommSlice, mSliceParentChildE)[, c('comm', 'slice', 'slicep')]
  l3 <- l2[!duplicated(l2[, c('comm', 'slicep')]), c('comm', 'slicep')]
  colnames(l3)[2] <- 'slice'
  l3 <- rbind(l1, l3)
  l3 <- l3[!duplicated(l3) & !duplicated(l3, fromLast=TRUE), ]
  l3$slicep <- l3$slice
  mCommSliceOrParent <- rbind(l2, l3)
  prec@parameters[['mCommSliceOrParent']] <- .add_data(prec@parameters[['mCommSliceOrParent']], mCommSliceOrParent)
  .interpolation_message('mTechInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  reduce_total_map <- function(yy) {
    yy$slicep <- yy$slice; yy$slice <- NULL
    reduce.duplicate(merge0(yy, mCommSliceOrParent, by = c('comm', 'slicep'))[, -2])
  }
  prec@parameters[['mTechInpTot']] <- .add_data(prec@parameters[['mTechInpTot']], reduce_total_map(reduce.sect(
    rbind(.get_data_slot(prec@parameters$mvTechInp)[, -1], .get_data_slot(prec@parameters$mvTechAInp)[, -1]))))
  .interpolation_message('mTechOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mTechOutTot']] <- .add_data(prec@parameters[['mTechOutTot']], reduce_total_map(reduce.sect(
    rbind(.get_data_slot(prec@parameters$mvTechOut)[, -1], .get_data_slot(prec@parameters$mvTechAOut)[, -1]))))
  .interpolation_message('mSupOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mSupOutTot']] <- .add_data(prec@parameters[['mSupOutTot']], reduce.sect(
    .get_data_slot(prec@parameters$mSupAva)[, -1]))
  
  .interpolation_message('pEmissionFactor', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  #### This section have to move to add (after interpolate comm first)
  tmp0 <- .get_data_slot(prec@parameters$pTechEmisComm)
  tmp <- merge0(.get_data_slot(prec@parameters$mvTechInp), tmp0[tmp0$value != 0, ], by = c('tech', 'comm'))
  .interpolation_message('mvTechAct', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  colnames(tmp)[colnames(tmp) == 'comm'] <- 'commp'
  tmp1 <- .get_data_slot(prec@parameters$pEmissionFactor)
  .interpolation_message('mvTechAct', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  tmp1 <- tmp1[tmp1$value != 0, ]
  tmp1 <- tmp1[!duplicated(tmp1),, drop = FALSE]
  tmp <- merge0(tmp1, tmp, by = 'commp')[, c('tech', 'comm', 'commp', 'region', 'year', 'slice')]
  tmp <- tmp[!duplicated(tmp),, drop = FALSE]
  .interpolation_message('mTechEmsFuel', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  colnames(tmp)[3] <- 'comm.1'
  prec@parameters[['mTechEmsFuel']] <- .add_data(prec@parameters[['mTechEmsFuel']], tmp)
  .interpolation_message('mEmsFuelTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['mEmsFuelTot']] <- .add_data(prec@parameters[['mEmsFuelTot']], reduce_total_map(
    reduce.sect(.get_data_slot(prec@parameters[['mTechEmsFuel']]), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mDummyImport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  no_inf <- function(y) {
    x = .get_data_slot(prec@parameters[[y]])
    if (!is.null(prec@parameters[[y]]@misc$not_need_interpolate)) {
      nn <- rev(prec@parameters[[y]]@misc$not_need_interpolate)
      nn[nn == 'slice'] <- 'mCommSlice'
      nn[nn == 'year'] <- 'mMidMilestone'
      for(i in nn)
        x <- merge0(.get_data_slot(prec@parameters[[i]]), x)
    }
    x[x$value != Inf, -ncol(x)]
  }
  prec@parameters[['mDummyImport']] <- .add_data(prec@parameters[['mDummyImport']], no_inf('pDummyImportCost'))
  .interpolation_message('mDummyExport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mDummyExport']] <- .add_data(prec@parameters[['mDummyExport']], no_inf('pDummyExportCost'))
  .interpolation_message('mDummyCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['mDummyCost']] <- .add_data(prec@parameters[['mDummyCost']], 
                                               reduce.sect(rbind(.get_data_slot(prec@parameters[['mDummyImport']]), 
                                                                 .get_data_slot(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))
  .interpolation_message('mvTradeIrAInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  # mvTradeIrAInpTot
  prec@parameters[['mvTradeIrAInpTot']] <- .add_data(prec@parameters[['mvTradeIrAInpTot']], reduce_total_map(
    reduce.sect(.get_data_slot(prec@parameters$mvTradeIrAInp), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mvTradeIrAOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mvTradeIrAOutTot']] <- .add_data(prec@parameters[['mvTradeIrAOutTot']], reduce_total_map(
    reduce.sect(.get_data_slot(prec@parameters$mvTradeIrAOut), c('comm', 'region', 'year', 'slice'))))
  .interpolation_message('mTradeComm', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  
  ### Export
  mCommSliceOrParent2 <- mCommSliceOrParent
  colnames(mCommSliceOrParent2)[3] <- 'slice.1'
  mExportIrSubSliceTrd <- merge0(.get_data_slot(prec@parameters$mTradeComm), .get_data_slot(prec@parameters[['mTradeIr']]))
  colnames(mExportIrSubSliceTrd)[6] <- 'slice.1'
  mExportIrSubSliceTrd$dst <- NULL
  mExportIrSubSliceTrd <- merge0(mExportIrSubSliceTrd, mCommSliceOrParent2)
  colnames(mExportIrSubSliceTrd)[4] <- 'region'
  mExportIrSubSliceTrd <- mExportIrSubSliceTrd[!duplicated(mExportIrSubSliceTrd), ]
  mExportIrSubSlice <- mExportIrSubSliceTrd[, -3]
  mExportIrSubSlice <- mExportIrSubSlice[!duplicated(mExportIrSubSlice), ]
  mExportIrSub <- mExportIrSubSlice[, -2]
  mExportIrSub <- mExportIrSub[!duplicated(mExportIrSub), ]
  mExportRowSubTmp <- reduce.sect(.get_data_slot(prec@parameters[['mExportRow']])[, c('comm', 'region', 'year', 'slice')],
                                  c('comm', 'region', 'year', 'slice'))
  colnames(mExportRowSubTmp)[4] <- 'slice.1'
  mExportRowSubSlice <- merge0(mExportRowSubTmp, mCommSliceOrParent2)
  mExportRowSub <- mExportRowSubSlice[, colnames(mExportRowSubSlice) != 'slice.1']
  mExportRowSub <- mExportRowSub[!duplicated(mExportRowSub), ]
  .interpolation_message('mExport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mExport <- rbind(mExportRowSub, mExportIrSub)
  mExport <- mExport[!duplicated(mExport), ]
  prec@parameters[['mExport']] <- .add_data(prec@parameters[['mExport']], mExport)
  
  ### Import
  mImportIrSubSliceTrd <- merge0(.get_data_slot(prec@parameters$mTradeComm), .get_data_slot(prec@parameters[['mTradeIr']]))
  colnames(mImportIrSubSliceTrd)[6] <- 'slice.1'
  mImportIrSubSliceTrd$src <- NULL
  mImportIrSubSliceTrd <- merge0(mImportIrSubSliceTrd, mCommSliceOrParent2)
  colnames(mImportIrSubSliceTrd)[4] <- 'region'
  mImportIrSubSliceTrd <- mImportIrSubSliceTrd[!duplicated(mImportIrSubSliceTrd), ]
  mImportIrSubSlice <- mImportIrSubSliceTrd[, -3]
  mImportIrSubSlice <- mImportIrSubSlice[!duplicated(mImportIrSubSlice), ]
  mImportIrSub <- mImportIrSubSlice[, -2]
  mImportIrSub <- mImportIrSub[!duplicated(mImportIrSub), ]
  mImportRowSubTmp <- reduce.sect(.get_data_slot(prec@parameters[['mImportRow']])[, c('comm', 'region', 'year', 'slice')],
                                  c('comm', 'region', 'year', 'slice'))
  colnames(mImportRowSubTmp)[4] <- 'slice.1'
  mImportRowSubSlice <- merge0(mImportRowSubTmp, mCommSliceOrParent2)
  mImportRowSub <- mImportRowSubSlice[, colnames(mImportRowSubSlice) != 'slice.1']
  mImportRowSub <- mImportRowSub[!duplicated(mImportRowSub), ]
  .interpolation_message('mImport', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mImport <- rbind(mImportRowSub, mImportIrSub)
  mImport <- mImport[!duplicated(mImport), ]
  prec@parameters[['mImport']] <- .add_data(prec@parameters[['mImport']], mImport)
  
  #
  .interpolation_message('mStorageInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['mStorageInpTot']] <- .add_data(prec@parameters[['mStorageInpTot']], 
                                                   reduce.sect(rbind(.get_data_slot(prec@parameters$mvStorageAInp)[, -1], .get_data_slot(prec@parameters$mvStorageStore)[, -1])))
  .interpolation_message('mStorageOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mStorageOutTot']] <- .add_data(prec@parameters[['mStorageOutTot']], 
                                                   reduce.sect(rbind(.get_data_slot(prec@parameters$mvStorageAInp)[, -1], .get_data_slot(prec@parameters$mvStorageStore)[, -1])))
  .interpolation_message('mTaxCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  # mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
  prec@parameters[['mTaxCost']] <- .add_data(prec@parameters[['mTaxCost']], 
      reduce.sect.merge.unique(list(
        .get_data_slot(prec@parameters$pTaxCostInp),
        .get_data_slot(prec@parameters$pTaxCostOut),
        .get_data_slot(prec@parameters$pTaxCostBal)
        ), c('comm', 'region', 'year')))
  # mSubCost(comm, region, year)  sum(slice$pSubCost(comm, region, year, slice), 1)
  .interpolation_message('mSubCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mSubCost']] <- .add_data(prec@parameters[['mSubCost']], 
      reduce.sect.merge.unique(list(
        .get_data_slot(prec@parameters$pSubCostInp),
        .get_data_slot(prec@parameters$pSubCostOut),
        .get_data_slot(prec@parameters$pSubCostBal)
        ), c('comm', 'region', 'year')))
  #    (sum(commp$pAggregateFactor(comm, commp), 1))
  .interpolation_message('mAggOut', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  if (nrow(.get_data_slot(prec@parameters$pAggregateFactor)) > 0) {
    prec@parameters[['mAggOut']] <- .add_data(prec@parameters[['mAggOut']], reduce_total_map(reduce.duplicate(
      merge0(merge0(merge0(reduce.sect(.get_data_slot(prec@parameters$pAggregateFactor), 'comm'), .get_data_slot(prec@parameters$region)), 
                  year), .get_data_slot(prec@parameters$slice)))))
  }
  .interpolation_message('mOut2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  a1 <- mCommSlice; colnames(a1)[2] <- 'slicep'
  a2 <- .get_data_slot(prec@parameters$mSliceParentChild)
  for2Lo <- merge0(a1, a2, by = 'slicep'); for2Lo$slicep <- NULL
  for2Lo <- reduce.duplicate(for2Lo)
  cll <- c('comm', 'region', 'year', 'slice')
  mOut2Lo <- merge0(reduce.duplicate(rbind(merge0(.get_data_slot(prec@parameters$mSupOutTot), 
                                                .get_data_slot(prec@parameters$year))[, cll], 
                                          .get_data_slot(prec@parameters$mEmsFuelTot)[, cll], 
                                          .get_data_slot(prec@parameters$mAggOut)[, cll], 
                                          .get_data_slot(prec@parameters$mTechOutTot)[, cll], 
                                          .get_data_slot(prec@parameters$mStorageOutTot)[, cll], 
                                          .get_data_slot(prec@parameters$mImport)[, cll], 
                                          .get_data_slot(prec@parameters$mvTradeIrAOutTot)[, cll])), for2Lo, by =  c('comm', 'slice'))[, cll]
  mOut2Lo <- mOut2Lo[!(paste0(mOut2Lo$comm, '#', mOut2Lo$slice) %in% 
                         paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
  prec@parameters[['mOut2Lo']] <- .add_data(prec@parameters[['mOut2Lo']], mOut2Lo)
  
  .interpolation_message('mInp2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mInp2Lo <- merge0(reduce.duplicate(rbind(.get_data_slot(prec@parameters$mTechInpTot)[, cll], 
                                          .get_data_slot(prec@parameters$mStorageInpTot)[, cll], 
                                          .get_data_slot(prec@parameters$mExport)[, cll], 
                                          .get_data_slot(prec@parameters$mvTradeIrAInpTot)[, cll])), 
                   for2Lo, by =  c('comm', 'slice'))[, cll]
  mInp2Lo <- mInp2Lo[!(paste0(mInp2Lo$comm, '#', mInp2Lo$slice) %in% paste0(mCommSlice$comm, '#', mCommSlice$slice)), ]
  prec@parameters[['mInp2Lo']] <- .add_data(prec@parameters[['mInp2Lo']], mInp2Lo)
  .interpolation_message('mvTradeCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  ##
  dregionyear <- merge0(region, year)
  .interpolation_message('mvTradeCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mvTradeCost']] <- .add_data(prec@parameters[['mvTradeCost']], dregionyear)
  .interpolation_message('mvTradeRowCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mvTradeRowCost']] <- .add_data(prec@parameters[['mvTradeRowCost']], dregionyear)
  .interpolation_message('mvTradeIrCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['mvTradeIrCost']] <- .add_data(prec@parameters[['mvTradeIrCost']], dregionyear)
  
  .interpolation_message('mvTotalCost', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['mvTotalCost']] <- .add_data(prec@parameters[['mvTotalCost']], dregionyear)
  .interpolation_message('mvInp2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mCommSlice2 <- .get_data_slot(prec@parameters[['mCommSlice']])
  colnames(mCommSlice2)[2] <- 'slicep'
  mvInp2Lo <- merge0(.get_data_slot(prec@parameters[['mInp2Lo']]), .get_data_slot(prec@parameters[['mSliceParentChild']])
  )[,c('comm', 'region', 'year', 'slice', 'slicep')]
  mvInp2Lo <- merge0(mvInp2Lo, mCommSlice2)
  colnames(mvInp2Lo)[colnames(mvInp2Lo) == 'slicep'] <- 'slice.1'
  mvInp2Lo <- mvInp2Lo[, c("comm", "region", "year", "slice", "slice.1")]
  prec@parameters[['mvInp2Lo']] <- .add_data(prec@parameters[['mvInp2Lo']], mvInp2Lo)
  
  .interpolation_message('mInpSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  if (!is.null(mvInp2Lo)) {
    mInpSub <- mvInp2Lo[!duplicated(mvInp2Lo[, -4]), -4]
    colnames(mInpSub)[4] <- 'slice'
    prec@parameters[['mInpSub']] <- .add_data(prec@parameters[['mInpSub']], mInpSub)
  }
  
  .interpolation_message('mvOut2Lo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mvOut2Lo <- merge0(.get_data_slot(prec@parameters[['mOut2Lo']]), .get_data_slot(prec@parameters[['mSliceParentChild']])
  )[,c('comm', 'region', 'year', 'slice', 'slicep')]
  mvOut2Lo <- merge0(mvOut2Lo, mCommSlice2)
  colnames(mvOut2Lo)[colnames(mvOut2Lo) == 'slicep'] <- 'slice.1'
  mvOut2Lo <- mvOut2Lo[, c("comm", "region", "year", "slice", "slice.1")]
  
  prec@parameters[['mvOut2Lo']] <- .add_data(prec@parameters[['mvOut2Lo']], mvOut2Lo)
  
  .interpolation_message('mOutSub', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  if (!is.null(mvOut2Lo)) {
    mOutSub <- mvOut2Lo[!duplicated(mvOut2Lo[, -4]), -4]
    colnames(mOutSub)[4] <- 'slice'
    prec@parameters[['mOutSub']] <- .add_data(prec@parameters[['mOutSub']], mOutSub)
  }
  .interpolation_message('meqLECActivity', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  prec@parameters[['meqLECActivity']] <- .add_data(prec@parameters[['meqLECActivity']], 
                                                   merge0(.get_data_slot(prec@parameters[['mTechSpan']]), .get_data_slot(prec@parameters[['mLECRegion']])))
  
  .interpolation_message('mvTotalUserCosts', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  
  mCosts <- lapply(grep('^mCosts', names(prec@parameters), value = TRUE), function(x) {
    xx <- .get_data_slot(prec@parameters[[x]])
    xx <- unique(xx[, colnames(xx) %in% c('region', 'year'), drop = FALSE])
    if (nrow(xx) == nrow(dregionyear) || ncol(xx) == 0) return(dregionyear)
    if (is.null(xx$region)) return(dregionyear[dregionyear$year %in% unique(xx$year),, drop = FALSE]) else
    if (is.null(xx$year)) return(dregionyear[dregionyear$region %in% unique(xx$region),, drop = FALSE]) else 
      return(xx)
  })
  if (any(sapply(mCosts, nrow) == nrow(dregionyear))) {
    prec@parameters[['mvTotalUserCosts']] <- .add_data(prec@parameters[['mvTotalUserCosts']], dregionyear)
  } else {
    if (length(mCosts) != 0) {
      mCosts2 <- mCosts[[1]][0, ]
      mCosts2[prod(sapply(mCosts2, nrow)), ] <- NA
      nnn <- 0
      for (qqq in seq_along(mCosts2)) {
        mCosts2[seq_len(nrow(mCosts[[qqq]])) + nnn, ] <- mCosts[[qqq]]
        nnn <- nnn + nrow(mCosts[[qqq]])
      }
      mCosts <- mCosts2
      prec@parameters[['mvTotalUserCosts']] <- .add_data(prec@parameters[['mvTotalUserCosts']], 
                                                        unique(mCosts))
    }
  }
     if (length(prec@costs.equation) == 0) {
      prec@costs.equation <- 
        'eqTotalUserCosts(region, year)$mvTotalUserCosts(region, year).. vTotalUserCosts(region, year) =e= 0;'
    } else {
      prec@costs.equation <- paste0('eqTotalUserCosts(region, year)$mvTotalUserCosts(region, year).. ', 
          'vTotalUserCosts(region, year) =e= ', 
          gsub('[+][ ]*[-]', '-', paste0(prec@costs.equation, collapse = ' + ')), ';')
    }

  tmp_f0 <- function(x) {
    if (nrow(x) == 0) {
      x$value <- numeric()
      return (x)
    }
    x$value <- 1
    x
  }
  
  .interpolation_message('mvInpTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mvInpTot <- rbind(
    .get_data_slot(prec@parameters$mvDemInp),
    .get_data_slot(prec@parameters$mDummyExport),
    .get_data_slot(prec@parameters$mTechInpTot),
    .get_data_slot(prec@parameters$mStorageInpTot),
    .get_data_slot(prec@parameters$mExport),
    .get_data_slot(prec@parameters$mvTradeIrAInpTot),
    .get_data_slot(prec@parameters$mInpSub))
  mvInpTot <- mvInpTot[!duplicated(mvInpTot), ]
  mvInpTot <- merge0(mvInpTot, mCommSlice)
  .interpolation_message('mvOutTot', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mvOutTot <- rbind(
    .get_data_slot(prec@parameters$mDummyImport),
    .get_data_slot(prec@parameters$mSupOutTot),
    .get_data_slot(prec@parameters$mEmsFuelTot),
    .get_data_slot(prec@parameters$mAggOut),
    .get_data_slot(prec@parameters$mTechOutTot),
    .get_data_slot(prec@parameters$mStorageOutTot),
    .get_data_slot(prec@parameters$mImport),
    .get_data_slot(prec@parameters$mvTradeIrAOutTot),
    .get_data_slot(prec@parameters$mOutSub)
  )
  mvOutTot <- mvOutTot[!duplicated(mvOutTot), ]
  mvOutTot <- merge0(mvOutTot, mCommSlice)
  .interpolation_message('mvBalance', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  mvBalance <- rbind(mvInpTot, mvOutTot)
  mvBalance <- mvBalance[!duplicated(mvBalance), ]
  mvBalance <- merge0(dregionyear, mCommSlice)
  prec@parameters[['mvBalance']] <- .add_data(prec@parameters[['mvBalance']], mvBalance)
  prec@parameters[['mvInpTot']] <- .add_data(prec@parameters[['mvInpTot']], mvBalance)
  prec@parameters[['mvOutTot']] <- .add_data(prec@parameters[['mvOutTot']], mvBalance)
  
  .interpolation_message('meqBalLo', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['meqBalLo']] <- .add_data(prec@parameters[['meqBalLo']], 
                                             merge0(.get_data_slot(prec@parameters[['mvBalance']]), .get_data_slot(prec@parameters[['mLoComm']])))
  .interpolation_message('meqBalUp', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['meqBalUp']] <- .add_data(prec@parameters[['meqBalUp']], 
                                             merge0(.get_data_slot(prec@parameters[['mvBalance']]), .get_data_slot(prec@parameters[['mUpComm']])))
  .interpolation_message('meqBalFx', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  prec@parameters[['meqBalFx']] <- .add_data(prec@parameters[['meqBalFx']], 
                                             merge0(.get_data_slot(prec@parameters[['mvBalance']]), .get_data_slot(prec@parameters[['mFxComm']])))
  
  .interpolation_message('mAggregateFactor', rest, interpolation_count, interpolation_time_begin, len_name); rest = rest + 1
  tmp <- .get_data_slot(prec@parameters[['pAggregateFactor']])
  tmp <- tmp[tmp$value != 0, ]
  if (nrow(tmp)) {
    tmp$value <- NULL
    colnames(tmp)[2] <- 'comm.1'
    prec@parameters[['mAggregateFactor']] <- .add_data(prec@parameters[['mAggregateFactor']], tmp)
  }
  cat(bacs, paste0(rep(' ', len_name), collapse = ''), bacs)
  prec
}

