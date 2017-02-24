getConstrainResults <- function(scenario, constrain) {
  if (length(constrain) > 1) {
    rst <- list()
    for(i in constrain)
      rst[[i]] <- getConstrainResults(scenario, i)[[1]]
      rst
  } else {
    prec <- scenario@precompiled@maptable
    tcns <- getObjects(scenario, class = 'constrain', name = constrain, regex = FALSE)[[1]]
    dtt <- scenario@result@data
    fcase <- function(x) if (length(x) == 0 || nchar(x) <= 1) toupper(x) else
      paste(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)), sep = '')
    smpl_sl <- c(names(tcns@for.each), names(tcns@for.sum))
    std_smp <- c('comm', 'region', 'year', 'slice')
    ad_smpl <- smpl_sl[!(smpl_sl %in% std_smp)]
    if (length(ad_smpl) == 1) std_smp <- std_smp[std_smp != ad_smpl]
    std_smp <- std_smp[std_smp %in% smpl_sl]
#    vary.set <- c(ad_smpl[length(ad_smpl) != 0 && any(ad_smpl == names(tcns@for.each))], std_smp)
    is.vary <- c(rep(TRUE, length(tcns@for.each)), rep(FALSE, length(tcns@for.sum)))
    names(is.vary) <- smpl_sl
    vary.set <- std_smp[std_smp %in% names(is.vary)[is.vary]]
    vary.set2 <- c(ad_smpl[is.vary[ad_smpl]], std_smp[std_smp %in% names(is.vary)[is.vary]])
    cns.set <- list()
    for(st in c(ad_smpl, std_smp)) {
      gg <- getDataMapTable(prec[[paste('mCns', fcase(st), sep = '')]])
      cns.set[[st]] <- gg[gg$cns == constrain, st]
    }
    mlst <- getMileStone(scenario)
    if (any(names(cns.set) == 'year')) {
      GROWTH_CNS <- any(grep('growth', as.character(tcns@type)))
      mm <- cns.set$year[cns.set$year %in% mlst$mid]
      if (GROWTH_CNS && mm[length(mm)] != mlst[nrow(mlst), 'mid']) {
          mm <- c(mm, mlst[seq(length.out = nrow(mlst))[mm[length(mm)] == mlst$mid] + 1, 'mid'])
      }
      cns.set$year <- mm
    }
    # Variable
    if (tcns@type %in% c('growth.output', 'output', 'shareout')) before <- 'Out' else
    if (tcns@type %in% c('growth.input', 'input', 'sharein'))   before <- 'Inp' else
    if (tcns@type %in% c('growth.capacity', 'capacity')) before <- 'Cap' else
    if (tcns@type %in% c('growth.newcapacity', 'newcapacity')) before <- 'NewCap' else
    if (tcns@type %in% c('growth.invcost', 'invcost')) before <- 'Inv' else
    if (tcns@type %in% c('growth.fixom', 'fixom')) before <- 'Fixom' else
    if (tcns@type %in% c('growth.varom', 'varom')) before <- 'Varom' else
    if (tcns@type %in% c('growth.activity', 'activity')) before <- 'Act' else
    if (tcns@type %in% c('growth.eac', 'eac')) before <- 'Eac' else stop('Unknown constrain type')
    vrb <- paste('v', fcase(ad_smpl), before, sep = '')
    if (length(ad_smpl) == 0) vrb <- paste(vrb, 'Tot', sep = '')
    if (length(vary.set) == 0) {
      eval(parse(text = paste('gg <- dtt[[vrb]][', paste('as.character(cns.set$', names(cns.set), ')',
        sep = '', collapse = ', '), ', drop = FALSE]', sep = '')))
      # Adjust to different period length
      if (any(names(cns.set) == 'year')) {
          yr <- sapply(cns.set$year, function(x) {fl <- mlst$mid == x; (mlst$end[fl] - mlst$start[fl] + 1)})
          gg <- as.data.frame.table(gg)
          for(i in seq(along = cns.set$year)) {
            gg[gg$year == cns.set$year[i], 'Freq'] <- yr[i] * gg[gg$year == cns.set$year[i], 'Freq']
          }
          gg <- sum(gg$Freq)
      }
      lhs <- sum(gg)
      rhs <- getDataMapTable(prec[['pRhs']])
      rhs <- rhs[rhs == constrain, 2]
      ll <- list(data.frame(lhs = lhs, rhs = rhs, is.active = c(lhs == rhs)))
      names(ll) <- constrain
     ll
    } else {
      tbl <- data.frame(cns.set[[vary.set2[1]]], stringsAsFactors = FALSE)
      colnames(tbl) <- vary.set2[1]
      for(i in vary.set2[-1]) {
        tbl <- tbl[rep(1:nrow(tbl), length(cns.set[[i]])),, drop = FALSE]
        tbl[, i] <- NA
        tbl[, i] <- c(t(matrix(cns.set[[i]], length(cns.set[[i]]), nrow(tbl) / length(cns.set[[i]]))))
      }
      rhs <- getDataMapTable(prec[[paste('pRhs', fcase(ad_smpl)[length(ad_smpl) != 0 && 
        any(ad_smpl == names(tcns@for.each))], paste(toupper(substr(vary.set, 1, 1)), collapse = ''), sep = '')]])
      rhs <- rhs[rhs$cns == constrain, -1, drop = FALSE]
      v1 <- apply(rhs[, -ncol(rhs), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
      v2 <- apply(tbl, 1, function(x) paste(x, collapse = '#'))
      tbl <- tbl[sort(v2, index.return = TRUE)$ix,, drop = FALSE]
      rhs <- rhs[v1 %in% v2,, drop = FALSE]
      v1 <- v1[v1 %in% v2]
      rhs <- rhs[sort(v1, index.return = TRUE)$ix, 'Freq', drop = FALSE]
      if (tcns@type %in% c('sharein', 'shareout')) {
        if (tcns@type == 'sharein') gg <- dtt$vInpTot else gg <- dtt$vOutTot
        gg <- as.data.frame.table(gg)
        # Adjust to different period length
        if (any(names(cns.set) == 'year') && all(names(vary.set) != 'year')) {
            yr <- sapply(cns.set$year, function(x) {fl <- mlst$mid == x; (mlst$end[fl] - mlst$start[fl] + 1)})
            for(i in seq(along = cns.set$year)) {
              gg[gg$year == cns.set$year[i], 'Freq'] <- yr[i] * gg[gg$year == cns.set$year[i], 'Freq']
            }
        }
        gg <- gg[gg$comm %in% cns.set$comm & gg$region %in% cns.set$region & gg$year %in% cns.set$year &
          gg$slice %in% cns.set$slice, c(vary.set2,
            'Freq'), drop = FALSE]
        gg <- aggregate(gg$Freq, by = gg[, -ncol(gg), drop = FALSE], FUN = "sum")
        v1 <- apply(gg[, -ncol(gg), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
        v1 <- v1[v1 %in% v2]
        gg <- gg[sort(v1, index.return = TRUE)$ix, ncol(gg), drop = FALSE]
        tolhs <- gg
      } else if (GROWTH_CNS) {
        rhs <- getDataMapTable(prec[[paste('pRhs', fcase(ad_smpl)[length(ad_smpl) != 0 && 
          any(ad_smpl == names(tcns@for.each))], paste(toupper(substr(vary.set, 1, 1)), 
            collapse = ''), sep = '')]])
        rhs <- rhs[rhs$cns == constrain, -1, drop = FALSE]
        rhs[, 'mid'] <- NA
        mlst2 <- mlst[mlst$mid %in% mm,, drop = FALSE]
        for(i in seq(length.out = nrow(mlst2) - 1)) {
          rhs[mlst2$mid[i] <= rhs$year & rhs$year < mlst2$mid[i + 1], 'mid'] <- mlst2$mid[i]
        }
        if (max(mlst$mid) == max(mlst2$mid)) {
          rhs[mlst2$mid[nrow(mlst2)] <= rhs$year, 'mid'] <- mlst2$mid[nrow(mlst2)]
        } else {
          hh <- mlst[seq(length.out = nrow(mlst))[mlst$mid == max(mlst2$mid)] + 1, 'mid']
          rhs[mlst2$mid[nrow(mlst2)] <= rhs$year & rhs$year < hh, 'mid'] <- mlst2$mid[nrow(mlst2)]
        }
        rhs$year <- rhs$mid
        rhs <- rhs[, -ncol(rhs), drop = FALSE]
        rhs <- aggregate(rhs$Freq, by = rhs[, -ncol(rhs), drop = FALSE], FUN = "prod")
        colnames(rhs)[ncol(rhs)] <- 'Freq'
        v1 <- apply(rhs[, -ncol(rhs), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
        v2 <- apply(tbl, 1, function(x) paste(x, collapse = '#'))
        tbl <- tbl[sort(v2, index.return = TRUE)$ix,, drop = FALSE]
        rhs <- rhs[v1 %in% v2,, drop = FALSE]
        v1 <- v1[v1 %in% v2]
        rhs <- rhs[sort(v1, index.return = TRUE)$ix, 'Freq', drop = FALSE]
      }
      tt <- paste('gg <- dtt[[vrb]][', paste('as.character(cns.set$', names(cns.set), ')',
        sep = '', collapse = ', '), ', drop = FALSE]', sep = '')
      eval(parse(text = tt))
      gg <- as.data.frame.table(gg)
      # Adjust to different period length
      if (any(names(cns.set) == 'year') && all(names(vary.set) != 'year')) {
          yr <- sapply(cns.set$year, function(x) {fl <- mlst$mid == x; (mlst$end[fl] - mlst$start[fl] + 1)})
          for(i in seq(along = cns.set$year)) {
            gg[gg$year == cns.set$year[i], 'Freq'] <- yr[i] * gg[gg$year == cns.set$year[i], 'Freq']
          }
      }
      lhs <- aggregate(gg$Freq, gg[, names(cns.set)[is.vary[c(ad_smpl, std_smp)]]], sum)
      v1 <- apply(lhs[, -ncol(lhs), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
      lhs <- lhs[v1 %in% v2,, drop = FALSE]
      v1 <- v1[v1 %in% v2]
      lhs <- lhs[sort(v1, index.return = TRUE)$ix, 'x', drop = FALSE] 
      if (tcns@type %in% c('sharein', 'shareout')) lhs <- lhs / tolhs
      tbl[, 'lhs'] <- lhs
      tbl[, 'rhs'] <- rhs
      if (GROWTH_CNS) {
        if (nrow(tbl) <= 1) tbl <- tbl[0,, drop = FALSE] else {
          tbl[-nrow(tbl), 'lhs'] <- ((tbl[-1, 'lhs'] / tbl[-nrow(tbl), 'lhs']) #^ 
            # (1 / (tbl[-1, 'year'] - tbl[-nrow(tbl), 'year']))
             )
          tbl <- tbl[-nrow(tbl),, drop = FALSE]
        }
      } 
      if (nrow(tbl) > 0) {
        tbl[, 'is.active'] <- NA
        tol <- 1e-10 * min(abs(c(tbl$rhs, tbl$rhs)[c(tbl$rhs, tbl$rhs) != 0]))
        tbl[, 'is.active'] <- abs(tbl$lhs - tbl$rhs) < tol
      }
      rownames(tbl) <- NULL
      ll <- list(tbl)
      names(ll) <- constrain
      ll
    }
  }
}