getConstrainResults <- function(scenario, constrain) {
  if (length(constrain) > 1) {
    rst <- list()
    for(i in constrain)
      rst[[i]] <- getConstrainResults(scenario, i)[[1]]
      rst
  } else {
    prec <- scenario@precompiled@maptable
    tcns <- getObjects(scenario, 'constrain', name = constrain, regex = FALSE)[[1]]
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
      gg <- prec[[paste('mCns', fcase(st), sep = '')]]@data
      cns.set[[st]] <- gg[gg$cns == constrain, st]
    }
    # Variable
    if (tcns@type %in% c('output', 'shareout')) before <- 'Out' else
    if (tcns@type %in% c('input', 'sharein'))   before <- 'Inp' else
    if (tcns@type == 'capacity') before <- 'Cap' else
    if (tcns@type == 'newcapacity') before <- 'NewCap' else
    if (tcns@type == 'invcost') before <- 'Inv' else
    if (tcns@type == 'eac') before <- 'Eac' else stop('Unknown constrain type')
    vrb <- paste('v', fcase(ad_smpl), before, sep = '')
    if (length(ad_smpl) == 0) vrb <- paste(vrb, 'Tot', sep = '')
    if (length(vary.set) == 0) {
      eval(parse(text = paste('gg <- dtt[[vrb]][', paste('as.character(cns.set$', names(cns.set), ')',
        sep = '', collapse = ', '), ', drop = FALSE]', sep = '')))
      lhs <- sum(gg)
      rhs <- prec[['pRhs']]@data
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
      rhs <- prec[[paste('pRhs', fcase(ad_smpl)[length(ad_smpl) != 0 && any(ad_smpl == names(tcns@for.each))],
        paste(toupper(substr(vary.set, 1, 1)), collapse = ''), sep = '')]]@data
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
        gg <- gg[gg$comm %in% cns.set$comm & gg$region %in% cns.set$region & gg$year %in% cns.set$year &
          gg$slice %in% cns.set$slice, c(vary.set2,
            'Freq'), drop = FALSE]
        gg <- aggregate(gg$Freq, by = gg[, -ncol(gg), drop = FALSE], FUN = "sum")
        v1 <- apply(gg[, -ncol(gg), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
        v1 <- v1[v1 %in% v2]
        gg <- gg[sort(v1, index.return = TRUE)$ix, ncol(gg), drop = FALSE]
        rhs <- rhs * gg
      }
      eval(parse(text = paste('gg <- dtt[[vrb]][', paste('as.character(cns.set$', names(cns.set), ')',
        sep = '', collapse = ', '), ', drop = FALSE]', sep = '')))
      gg <- apply(gg, seq(along = is.vary)[is.vary[c(ad_smpl, std_smp)]], sum)
      lhs <- as.data.frame.table(as.array(gg))
      v1 <- apply(lhs[, -ncol(lhs), drop = FALSE], 1, function(x) paste(x, collapse = '#'))
      lhs <- lhs[v1 %in% v2,, drop = FALSE]
      v1 <- v1[v1 %in% v2]
      lhs <- lhs[sort(v1, index.return = TRUE)$ix, 'Freq', drop = FALSE]
      tbl[, 'lhs'] <- lhs
      tbl[, 'rhs'] <- rhs
      tbl[, 'is.active'] <- NA
      tbl[, 'is.active'] <- c(lhs == rhs)
      rownames(tbl) <- NULL
      ll <- list(tbl)
      names(ll) <- constrain
      ll
    }
  }
}