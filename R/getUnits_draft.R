getUnits <- function(tech) {
  u <- list()
  # id ========================================= ####
  u$name <- tech@name
  u$description <- tech@description
  # commodities ========================================= ####
  u$input <- tech@input$unit
  names(u$input) <- tech@input$comm
  n.cinp <- length(u$input)
  n.ginp <- sum(!is.na(tech@input$group))
  #ii <- !is.na(tech@input$group)
  inp_groups <- levels(as.factor(tech@input$group))
  n.inp_groups <- length(inp_groups)
  
  u$output <- tech@output$unit
  names(u$output) <- tech@output$comm
  n.cout <- length(u$output)
  n.out_groups <- levels(as.factor(tech@output$group))
  
  u$comm <- c(u$input, u$output)
  
  u$acomm <- tech@aux$unit
  names(u$acomm) <- tech@aux$acomm
  
  u$comm_all <- c(u$comm, u$acomm)
  
  # groups ========================================= ####
  u$group <- tech@group$unit
  names(u$group) <- tech@group$group
  n.group <- (length(tech@group$group))
  
  
  # capacity ========================================= ####
  u$stock <- tech@units$capacity
  u$capacity <- u$stock
  u$cap <- u$stock
  
  # activity ========================================= ####
  u$use <- tech@units$use
  if(is.null(u$use) || is.na(u$use) || length(u$use) == 0) u$use <- "USE"
  u$act <- tech@units$activity
  if(is.null(u$act) || is.na(u$act) || length(u$act) == 0) u$act <- "ACT"
  u$activity <- u$act
  
  # capacity to activity
  u$cap2act <- paste0(u$act, "/", u$cap)
  
  # geff ========================================= ####
  u$ginp2use <- paste0(u$use, "/", u$group)
  names(u$ginp2use) <- names(u$group)
  
  # ceff ========================================= ####
  u$cinp2use <- paste0(u$use, "/", u$input)
  names(u$cinp2use) <- names(u$input)
  
  u$use2cact <- rep(paste0(u$act, "/", u$use), n.cout)
  names(u$use2cact) <- names(u$output)
  
  u$cact2cout <- paste0(u$act, "/", u$output)
  names(u$cact2cout) <- names(u$output)
  
  a2b <- function(idx, a, b = NULL, ab = NULL, ua, ub) {
    # a - vector with input parameters
    # b - vector (the same length with "a") with output parameters
    # ab - mapping vector from "a" to "b"
    # ua - vector with a-units
    # ub - vector with b-units
    if(is.null(idx) || length(idx) == 0) return(NA)
    if(is.null(b) & !is.null(ab)) {
      if(dim(ab)[2] > 1) {
        aa <- ab[,2]
        names(aa) <- ab[,1]
        ab <- aa
      }
      b <- NULL
      b <- sapply(a, function(x) ab[x])
    }
    
    a2b <- NULL
    for(i in 1:length(a)) {
      if(!is.na(idx[i])) {
        a2b_i <- paste0(ub[b[i]], "/", ua[a[i]])
        names(a2b_i) <- a[i]
        a2b <- c(a2b, a2b_i)
      }
    }
    return(a2b)
  }
  u$cinp2ginp <- a2b(idx = tech@ceff$cinp2ginp, 
                     a = tech@input$comm, 
                     ab = tech@input[, c("comm", "group")],
                     ua = u$input, 
                     ub = u$group)
  
  com_group <- rbind(tech@input[, c("comm", "group")],
                     tech@output[, c("comm", "group")])
  com_group <- com_group[!is.na(com_group$group),]
  com_group <- dplyr::distinct(com_group)
  #com2gr <- com_group$group
  #names(com2gr) <- com_group$comm
  
  u$share.lo <- a2b(idx = tech@ceff$share.lo, 
                    a = tech@ceff$comm, 
                    ab = com_group,
                    ua = u$comm, 
                    ub = u$group)
  
  u$share.up <- a2b(idx = tech@ceff$share.up, 
                    a = tech@ceff$comm, 
                    ab = com_group,
                    ua = u$comm, 
                    ub = u$group)
  
  u$share.fx <- a2b(idx = tech@ceff$share.fx, 
                    a = tech@ceff$comm, 
                    ab = com_group,
                    ua = u$comm, 
                    ub = u$group)
  
  u$afc.lo <- NA
  u$afc.up <- NA
  u$afc.fx <- NA
  
  # aeff ========================================= ####
  
  # if(dim(tech@aeff)[1] > 0) {
  
  n2acomm <- function(dat, name, ua) {
    #dat <- dat[, c("acomm", "comm", name)
    ii <- !is.na(dat[, name])
    dat <- dplyr::distinct(dat[ii, c("acomm", "comm", name)])
    if(dim(dat)[1] > 0) {
      b <- dat$acomm
      ub <- u$acomm[b]
      n2acom <- paste0(ub, "/", ua)
      names(n2acom) <- dat$acomm
    } else {
      n2acom <- NULL
    }
    return(n2acom)
  }
  
  u$cinp2ainp <- a2b(idx = tech@aeff$cinp2ainp, 
                     a = tech@aeff$comm, 
                     b = tech@aeff$acomm,
                     ua = u$input, 
                     ub = u$acomm) 
  
  u$cinp2aout <- a2b(idx = tech@aeff$cinp2aout, 
                     a = tech@aeff$comm, 
                     b = tech@aeff$acomm,
                     ua = u$input, 
                     ub = u$acomm)
  
  u$cout2ainp <- a2b(idx = tech@aeff$cout2ainp, 
                     a = tech@aeff$comm, 
                     b = tech@aeff$acomm,
                     ua = u$output, 
                     ub = u$acomm)
  
  u$cout2aout <- a2b(idx = tech@aeff$cout2aout, 
                     a = tech@aeff$comm, 
                     b = tech@aeff$acomm,
                     ua = u$output, 
                     ub = u$acomm)
  
  u$act2ainp <- n2acomm(tech@aeff, "act2ainp", u$act)
  u$act2aout <- n2acomm(tech@aeff, "act2aout", u$act)
  u$use2ainp <- n2acomm(tech@aeff, "use2ainp", u$use)
  u$use2aout <- n2acomm(tech@aeff, "use2aout", u$use)
  u$cap2ainp <- n2acomm(tech@aeff, "cap2ainp", u$cap)
  u$cap2aout <- n2acomm(tech@aeff, "cap2aout", u$cap)
  u$ncap2ainp <- n2acomm(tech@aeff, "ncap2ainp", u$cap)
  u$ncap2aout <- n2acomm(tech@aeff, "ncap2aout", u$cap)
  # } else {
  #   u$cinp2ainp <- NA 
  #   u$cinp2aout <- NA
  #   u$cout2ainp <- NA
  #   u$cout2aout <- NA
  #   u$act2ainp <- NA
  #   u$act2aout <- NA
  #   u$use2ainp <- NA
  #   u$use2aout <- NA
  #   u$cap2ainp <- NA
  #   u$cap2aout <- NA
  #   u$ncap2ainp <- NA
  #   u$ncap2aout <- NA
  #   }
  
  u$af <- NA # !!!
  
  #costs ========================================= ####
  u$cost <- tech@units$cost
  u$fixom <- paste0(u$cost, "/", u$capacity)
  u$varom <- paste0(u$cost, "/", u$activity)
  u$cvarom <- NA # !!!
  u$avarom <- NA # !!!
  u$invcost <- paste0(u$cost, "/", u$capacity)
  
  return(u)
}
