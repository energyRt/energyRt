# new version (in progress) on interpolate method and related functions

# loop over model data ####
# model@data (x) is a list of repositories
dapply <- function(x, f, ...) {
  ll <- NULL
  for (i in 1:length(x)) {
    cc <- sapply(x[[i]]@data, FUN = f, ...)
    ll <- c(ll, cc)
  }
  ll
}

if (F) {
  dapply(m@data, "class")
}

flatten_mod_data <- function(x) {
  # browser()
  ll <- list()
  for (i in 1:length(x)) {
    d <- x[[i]]@data
    ll <- c(ll, d)
  }
  ll
}

if (F) {
  flatten_mod_data(m@data)
}

expand_regions <- function(x, regions = NULL) {
  # browser()
  b <- x %>%
    filter(is.na(region)) %>%
    select(-region) %>%
    expand_grid(region = regions)
  x %>%
    filter(!is.na(region)) %>%
    rbind(b)
}

fmSupCommReg <- function(m, regions = NULL) {
  # m - model
  ii <- dapply(m@data, inherits, "supply")
  if (sum(ii) == 0) return(data.table(sup = "", comm = "", region = "")[0,])
  a <- lapply(m[[ii]], function(ob) {
    if (length(ob@region) > 0) {
      regs <- ob@region
    } else {
      regs <- NA # @reserves & @availability values might be restrictive, not checking
    }
    data.table(sup = ob@name, comm = ob@commodity, region = regs)
    }) %>%
    rbindlist()
  if (is.null(a)) {
    a <- data.table(sup = "", comm = "", region = "")[0,]
  }
  if (is.null(regions)) return(a)
  # expand
  expand_regions(a, regions)
  # b <- a %>%
  #   filter(is.na(region)) %>%
  #   select(-region) %>%
  #   expand_grid(region = regions)
  # a %>%
  #   filter(!is.na(region)) %>%
  #   rbind(b)
}

if (F) {
  fmSupCommReg(m)
  fmSupCommReg(m)
  a <- fmSupCommReg(m)
  fmSupCommReg(m, regions = paste0("R", 1:7)) %>% arrange(sup)
  fmSupCommReg(m)
  fmSupCommReg(m, regions = paste0("R", 1:7)) %>% arrange(sup)
}

fmImpCommReg <- function(m, regions = NULL) {
  # m - model
  ii <- dapply(m@data, inherits, "import")
  if (sum(ii) == 0) return(data.table(imp = "", comm = "", region = "")[0,])

  a <- lapply(m[[ii]], function(ob) {
    if (nrow(ob@imp) > 0) {
      if (all(!is.na(ob@imp$region))) {
        regs <- unique(ob@imp$region)
      } else {
        regs <- NA
      }
    }
    data.table(imp = ob@name, comm = ob@commodity, region = regs)
  }) %>%
    rbindlist()
  if (is.null(a)) {
    a <- data.table(imp = "", comm = "", region = "")[0,]
  }

  if (is.null(regions)) return(a)
  # expand
  expand_regions(a, regions)
}

if (F) {
  mImpCommReg(m)
  fmImpCommReg(m)
  mImpCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
  mSupCommReg(m)
  mSupCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
}

fmTradeCommReg <- function(m, regions = NULL) {
  # browser()
  ii <- dapply(m@data, inherits, "trade")
  if (sum(ii) == 0) return(data.table(trade = "", comm = "", region = "")[0,])

  a <- lapply(m[[ii]], function(ob) {
    if (nrow(ob@routes) > 0) {
      if (all(!is.na(ob@routes$dst))) {
        regs <- unique(ob@routes$dst)
      } else {
        regs <- NA
      }
    }
    data.table(trade = ob@name, comm = ob@commodity, region = regs)
    }) %>%
    rbindlist()
  if (is.null(a)) {
    a <- data.table(trade = "", comm = "", region = "")[0,]
  }

  if (is.null(regions)) return(a)
  # expand
  expand_regions(a, regions)
}

if (F) {
  mTradeCommReg(m)
  mTradeCommReg(m)
  mTradeCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
  mSupCommReg(m)
  mSupCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
}

fmTechOutCommReg <- function(m, regions = NULL) {
  # browser()
  ii <- dapply(m@data, inherits, "technology")
  if (sum(ii) == 0) return(data.table(tech = "", comm = "", region = "")[0,])

  acomm_par <- names(m[[ii]][[1]]@aeff)
  param_out <- acomm_par[grepl("out$", acomm_par)]

  a <- lapply(m[[ii]], function(ob) {
    if (length(ob@region) > 0) {
      regs <- unique(ob@region)
    } else {
      regs <- c(NA)
    }

    if (nrow(ob@aeff) > 0) {
      acomm_out <- sapply(select(ob@aeff, any_of(param_out)), function(x) {
        !is.na(x)
      })
      ii <- apply(acomm_out, 1, any)
      acomm_out <- ob@aeff$acomm[ii] %>% unique()
    } else {
      acomm_out <- NULL
    }

    expand_grid(
      tech = ob@name,
      comm = unique(
        c(
          # ob@input$comm
          ob@output$comm,
          acomm_out
        )
      ),
      region = regs
    )
    }) %>%
    rbindlist()
  if (is.null(a)) {
    a <- data.table(tech = "", comm = "", region = "")[0,]
  }

  if (is.null(regions)) return(a)
  # expand
  expand_regions(a, regions)
}

if (F) {
  mTechOutCommReg(m)
  mTechOutCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
  mTechOutCommReg(m)
  mTechOutCommReg(m, regions = paste0("R", 1:7)) %>% arrange()
}


fmEmisCommReg <- function(m, mCommReg = NULL) {
  # regions = NULL - not used
  # browser()
  ii <- dapply(m@data, inherits, "commodity")
  if (sum(ii) == 0) return(data.table(comm = "", comm1 = "")[0,])

  a <- lapply(m[[ii]], function(ob) {
    if (nrow(ob@emis) == 0) return(NULL)
    data.table(
      comm = ob@name,
      comm1 = ob@emis$comm
    )
  }) %>%
    rbindlist()
  if (is.null(a)) {
    a <- data.table(comm = "", comm1 = "")[0,]
  }

  if (is.null(mCommReg)) return(a)
  a <- a %>% left_join(mCommReg, by = "comm") %>% select(-comm) %>%
    rename(comm = comm1) %>% unique()
  a
}

if (F) {
  mEmisCommReg(m)
  # mEmisCommReg(m) %>% arrange()
  mEmisCommReg(m)
  # mEmisCommReg(m, mCommReg = ) %>% arrange()
}

fmCommReg <- function(m, regions = NULL) {

  a <- fmSupCommReg(m, regions) %>% select(-sup) %>% unique()
  a <- fmImpCommReg(m, regions) %>% select(-imp) %>%
    rbind(a) %>% unique()
  a <- fmTradeCommReg(m, regions) %>% select(-trade) %>%
    rbind(a) %>% unique()
  a <- fmTechOutCommReg(m, regions) %>% select(-tech) %>%
    rbind(a) %>% unique()
  a <- fmEmisCommReg(m, mCommReg = a) %>% rbind(a) %>% unique()
  return(a)
}

if (F) {
  fmCommReg(m, regions)
}
