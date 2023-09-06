# Functions to write Julia/JuMP model and data files
.write_model_JuMP <- function(arg, scen) {
  run_code <- scen@source[["JuMP"]]
  run_codeout <- scen@source[["JuMPOutput"]]
  # There is not prod in jump julia. Remove it, until jump will be better
  for (i in grep("^[@].*prod[(]", run_code)) {
    tx <- gsub("^[@].*prod[(]", "", run_code[i])
    k <- 1
    while (k != 0) {
      tx <- gsub("^[^)(]*", "", tx)
      if (substr(tx, 1, 1) == "(") k <- k + 1 else k <- k - 1
      tx <- gsub("^[)(]", "", tx)
    }
    run_code[i] <- paste0(gsub(
      "[*][ ]*prod[(]", "*(1 + sum(-1 + ",
      substr(run_code[i], 1, nchar(run_code[i]) - nchar(tx))
    ), ")", tx)
  }
  # Check for complicated weather
  for (pr in c(
    "mTechWeatherAfLo", "mTechWeatherAfUp", "mTechWeatherAfsLo",
    "mTechWeatherAfsUp", "mTechWeatherAfcLo", "mTechWeatherAfcUp",
    "mTechWeatherAfcLo", "mTechWeatherAfcUp", "mSupWeatherUp",
    "mSupWeatherLo", "mStorageWeatherAfLo", "mStorageWeatherAfUp",
    "mStorageWeatherCinpUp", "mStorageWeatherCinpLo",
    "mStorageWeatherCoutUp", "mStorageWeatherCoutLo"
  )) {
    tmp <- .get_data_slot(scen@modInp@parameters[[pr]])
    tmp$weather <- NULL
    if (anyDuplicated(tmp)) {
      assign("error_msg", tmp[duplicated(tmp), , drop = FALSE], globalenv())
      stop(paste0(
        "It is forbidden to determine more than one weather for Julia,",
        " since the prod is not a allowed. ",
        'List of duplicated weather for map "', pr,
        '"assign to error_msg.'
      ))
    }
  }
  # For downsize
  fdownsize <- names(scen@modInp@parameters)[
    sapply(scen@modInp@parameters, function(x) length(x@misc$rem_col) != 0)
  ]
  for (nn in fdownsize) {
    rmm <- scen@modInp@parameters[[nn]]@misc$rem_col
    if (scen@modInp@parameters[[nn]]@type == "bounds") {
      uuu <- paste0(nn, c("Lo", "Up"))
    } else {
      uuu <- nn
    }
    for (yy in uuu) {
      templ <- paste0("[(]if haskey[(]", yy, "[,]")
      if (any(grep("^pCns", nn))) {
        for (www in seq_along(scen@modInp@gams.equation)) {
          mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
          if (any(mmm)) {
            scen@modInp@gams.equation[[www]]$equation[mmm] <-
              sapply(
                strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], yy),
                .rem_jump, yy, rmm
              )
          }
        }
      } else if (any(grep("^pCosts", nn))) {
        mmm <- grep(templ, scen@modInp@costs.equation)
        if (any(mmm)) {
          scen@modInp@costs.equation[mmm] <-
            sapply(
              strsplit(scen@modInp@costs.equation[mmm], yy),
              .rem_jump, yy, rmm
            )
        }
      } else {
        mmm <- grep(templ, run_code)
        if (any(mmm)) {
          xx <- run_code[mmm]
          ww <- strsplit(xx, templ)[[1]]
          dd <- ww[2]
          gsub("; end[)].*", "", dd)
          run_code[mmm] <- sapply(
            strsplit(run_code[mmm], templ),
            .rem_jump, yy, rmm
          )
        }
      }
    }
  }
  dir.create(paste(arg$tmp.dir, "/output", sep = ""), showWarnings = FALSE)
  zz_data_julia <- file(paste(arg$tmp.dir, "/data.jl", sep = ""), "w")
  zz_data_constr <- file(paste(arg$tmp.dir, "/inc_constraints.jl", sep = ""), "w")
  zz_data_costs <- file(paste(arg$tmp.dir, "/inc_costs.jl", sep = ""), "w")

  .write_inc_solver(
    scen, arg,
    "using Cbc\nset_optimizer(model, Cbc.Optimizer)\n",
    ".jl", "Cbc"
  )
  dat <- list()
  for (i in names(scen@modInp@parameters)) {
    tmp <- .get_data_slot(scen@modInp@parameters[[i]])
    colnames(tmp) <- gsub("[.]1", "p", colnames(tmp))
    # if (!is.null(scen@modInp@parameters[[i]]@data$year)) {
    #   scen@modInp@parameters[[i]]@data$year <-
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$year))
    # }
    # if (!is.null(scen@modInp@parameters[[i]]@data$yearp)) {
    #   scen@modInp@parameters[[i]]@data$yearp <-
    #     as.character(as.integer(scen@modInp@parameters[[i]]@data$yearp))
    # }
    if (scen@modInp@parameters[[i]]@type != "bounds") {
      dat[[i]] <- tmp
    } else {
      tmp <- .get_data_slot(scen@modInp@parameters[[i]])
      dat[[paste0(i, "Up")]] <- tmp[tmp$type == "up", colnames(tmp) != "type"]
      dat[[paste0(i, "Lo")]] <- tmp[tmp$type == "lo", colnames(tmp) != "type"]
    }
  }

  save("dat", file = paste0(arg$tmp.dir, "data.RData"))

  cat('using RData\nusing DataFrames\ndt = load("data.RData")["dat"]\n',
    sep = "\n", file = zz_data_julia
  )
  for (j in c("set", "map", "single", "bounds")) {
    for (i in names(scen@modInp@parameters)) {
      if (scen@modInp@parameters[[i]]@type == j) {
        cat(energyRt:::.toJuliaHead(scen@modInp@parameters[[i]]),
          sep = "\n", file = zz_data_julia
        )
        cat(paste0('println("', i,
                   ' done ", Dates.format(now(), "HH:MM:SS"))\n'),
          file = zz_data_julia
        )
      }
    }
  }
  close(zz_data_julia)
  # Mod begin
  zz_mod <- file(paste(arg$tmp.dir, "/energyRt.jl", sep = ""), "w")
  nobj <- grep("^[@]objective", run_code)[1] - 1
  cat(run_code[1:nobj], sep = "\n", file = zz_mod)
  # Add constraint
  if (length(scen@modInp@gams.equation) > 0) {
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      cat(energyRt:::.equation.from.gams.to.julia(eqt$equation),
        sep = "\n",
        file = zz_data_constr
      )
      cat(
        paste0(
          'println("', eqt$equationDeclaration2Model,
          ' done ", Dates.format(now(), "HH:MM:SS"))\n'
        ),
        file = zz_data_constr
      )
    }
  }
  close(zz_data_constr)
  # Add costs
  {
    cat(energyRt:::.equation.from.gams.to.julia(scen@modInp@costs.equation),
      sep = "\n", file = zz_data_costs
    )
    cat(
      paste0(
        'println("Costs declaration done ", Dates.format(now(), "HH:MM:SS"))\n'),
      file = zz_data_costs
    )
  }
  close(zz_data_costs)
  cat(run_code[-(1:nobj)], sep = "\n", file = zz_mod)
  close(zz_mod)
  zz_modout <- file(paste(arg$tmp.dir, "/output.jl", sep = ""), "w")
  cat(run_codeout, sep = "\n", file = zz_modout)
  close(zz_modout)
  .write_inc_files(arg, scen, ".jl")
  if (is.null(scen@solver$cmdline) || scen@solver$cmdline == "") {
    scen@solver$cmdline <- "julia energyRt.jl"
  }
  scen@solver$code <- c(
    "energyRt.jl", "output.jl", "inc_constraints.jl",
    "inc_costs.jl", "inc_solver.jl"
  )
  scen
}

.rem_jump <- function(x, nn, rmm) {
  for (i in 2:length(x)) {
    # Split for end
    hdd <- gsub("; end[)].*", "", x[i])
    tll <- gsub(paste0(".* ", nn, "Def; end[)]"), "", x[i])
    argsss <- gsub("(^[ ][(]|[)].*)", "", hdd)
    x[i] <- paste0(
      "(if haskey(", nn, ",", paste0(strsplit(hdd, argsss)[[1]],
        collapse = paste0(strsplit(argsss, ",")[[1]][-rmm], collapse = ",")
      ),
      "; end)", tll
    )
  }
  return(paste0(x, collapse = ""))
}

# Generate Julia code, return the code as a character vector
.toJulia <- function(obj) {
  as_single <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      return(c(
        paste0("# ", name),
        paste0(name, " = ", data$value)
      ))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, "\n", name, "Def = ", def, ";\n")
      if (nrow(data) == 0) {
        return(paste0(rtt, name, " = Dict()"))
      }
      val <- as.character(data[1, ncol(data)])
      if (!any(grep("[.e]", val))) val <- paste0(val, ".")
      rtt <- c(rtt,
               paste0(name, " = Dict((:",
                      paste0(data[1, -ncol(data)], collapse = ", :"),
                      ") => ", val, ");"))
      if (nrow(data) == 1) {
        return(rtt)
      }
      kk <- paste0(name, "[(:", data[-1, 1])
      for (i in seq_len(ncol(data) - 2) + 1) {
        kk <- paste0(kk, ", :", data[-1, i])
      }
      kk <- paste0(kk, ")] = ", data[-1, "value"])
      return(c(rtt, kk))
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues), , drop = FALSE]
  }
  if (obj@type == "set") {
    tmp <- ""
    if (nrow(obj@data) > 0) {
      tmp <- paste0("\n  (:", paste0(sort(obj@data[, 1]),
        collapse = "),\n  (:"
      ), ")\n")
    }
    return(c(paste0("# ", obj@name), paste0(obj@name, " = [", tmp, "]")))
  } else if (obj@type == "map") {
    ret <- paste0("# ", obj@name)
    if (ncol(obj@data) > 1) ret <-
        paste0(ret, "(", paste0(obj@dimSets, collapse = ", "), ")")
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0(obj@name, " = []")))
    } else {
      return(c(
        ret, paste0(obj@name, " = Set()"),
        paste0("push!(", obj@name, ", ", paste0("(:", apply(
          obj@data, 1,
          function(x) paste(x, collapse = ",:")
        ), "))\n"), collapse = "")
      ))
    }
  } else if (obj@type == "single") {
    return(as_single(
      obj@data, obj@name,
      paste0("(", paste0(obj@dimSets, collapse = ", "), ")"),
      obj@defVal
    ))
  } else if (obj@type == "bounds") {
    hh <- paste0("(", paste0(obj@dimSets, collapse = ", "), ")")
    return(c(
      as_single(
        obj@data[obj@data$type == "lo", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Lo", sep = ""), hh, obj@defVal[1]
      ),
      as_single(
        obj@data[obj@data$type == "up", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Up", sep = ""), hh, obj@defVal[2]
      )
    ))
  } else {
    stop("Must realise")
  }
}

.toJuliaHead <- function(obj) {
  as_single <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      return(c(
        paste0("# ", name),
        paste0(name, " = ", data$value)
      ))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, "\n", name, "Def = ", def, ";\n")
      if (nrow(data) == 0) {
        return(paste0(rtt, name, " = Dict()"))
      }
      colnames(data) <- gsub("[.]1", "p", colnames(data))
      return(c(
        rtt,
        paste0(name, " = Dict()"),
        paste0('for i in 1:nrow(dt["', name, '"])'),
        paste0(
          "    ", name, "[(",
          paste0('dt["', name, '"][i, :', colnames(data)[-ncol(data)], "]",
            collapse = ", "
          ),
          ')] = dt["', name, '"][i, :value]'
        ), "end"
      ))
    }
  }
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues), , drop = FALSE]
  }
  if (obj@type == "map" || obj@type == "set") {
    ret <- paste0("# ", obj@name)
    if (ncol(obj@data) > 1) ret <-
        paste0(ret, "(", paste0(obj@dimSets, collapse = ", "), ")")
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0(obj@name, " = []")))
    } else {
      colnames(obj@data) <- gsub("[.]1", "p", colnames(obj@data))
      return(c(
        ret, paste0(obj@name, " = Set()"),
        paste0('for i in 1:nrow(dt["', obj@name, '"])'),
        paste0(
          "    push!(", obj@name, ", (",
          paste0('dt["', obj@name, '"][i, :',
            colnames(obj@data), "]",
            collapse = ", "
          ), "))"
        ), "end"
      ))
    }
  } else if (obj@type == "single") {
    return(as_single(obj@data, obj@name,
                     paste0("(", paste0(obj@dimSets, collapse = ", "), ")"), obj@defVal))
  } else if (obj@type == "bounds") {
    hh <- paste0("(", paste0(obj@dimSets, collapse = ", "), ")")
    return(c(
      as_single(
        obj@data[obj@data$type == "lo", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Lo", sep = ""), hh, obj@defVal[1]
      ),
      as_single(
        obj@data[obj@data$type == "up", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Up", sep = ""), hh, obj@defVal[2]
      )
    ))
  } else {
    stop(paste0(
      "Error: .toJuliaHead: unknown parameter type: ",
      obj@type, " / ", obj@name
    ))
  }
}

# Translate GAMS constraints to Julia/JuMP ####
# Make vector .alias_set (from gams to alias) and set_alias

# set_alias <- .set_al0
# names(set_alias) <- .alias_set

## Function
.get_julia_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == "(") {
    set_cond <- sub("^[(]", "", sub("[)]$", "", set_cond))
  }
  set_loop <- sub("^[(]", "", sub("[)]$", "", set_loop))
  xx <- .generate_loop_julia(set_loop, set_cond)
  rs <- xx$first
  if (!is.null(xx$end) || !is.null(add_cond)) {
    rs <- paste0(rs, " ", paste0(xx$end, add_cond, collapse = " && "))
  }
  rs <- paste0(rs, "")
  rs
}
# .set_al <- c("stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
# .alias_set <- c("st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
names(.alias_set) <- .set_al
.aliasName <- function(x) {
  if (!all(x %in% .set_al)) {
    cat("Unknown .set_al\n")
    browser()
    stop("Unknown set")
  }
  .alias_set[x]
}

# .fremset <- c("comm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "region", "region")
# names(.fremset) <- c("acomm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")

# .removeEndSet <- function(x) {
#   .fremset[x]
# }
.generate_loop_julia <- function(set_num, set_loop) {
  # browser()
  # Consdition split and divet by subset
  while (!is.null(set_loop) && substr(set_loop, 1, 1) == "(" &&
         substr(set_loop, nchar(set_loop), nchar(set_loop)) == ")") {
    set_loop <- substr(set_loop, 2, nchar(set_loop) - 1)
  }
  while (!is.null(set_num) && substr(set_num, 1, 1) == "(" &&
         substr(set_num, nchar(set_num), nchar(set_num)) == ")") {
    set_num <- substr(set_num, 2, nchar(set_num) - 1)
  }
  cnd <- gsub(" ", "", strsplit(set_loop, "and ")[[1]])
  cnd_slice <- strsplit(gsub("(.*[(]|[)]| )", "",
                             strsplit(set_loop, "and ")[[1]]), ",")
  cnd_slice <- lapply(cnd_slice, .aliasName)
  names(cnd_slice) <- gsub("[(].*", "", cnd)
  cnd0 <- gsub("[(].*", "", cnd)

  set_num1 <- strsplit(gsub("[[:blank:]]", "", set_num), ",")[[1]]
  set_num2 <- .aliasName(set_num1)
  names(set_num2) <- set_num1

  if (length(cnd_slice) != 0) {
    fl <- names(cnd_slice)[sapply(cnd_slice, length) == 1]
    if (length(fl) != 0) {
      for (i in fl) {
        names(set_num2)[names(set_num2) == names(cnd_slice[[i]])] <- i
      }
      cnd_slice <- cnd_slice[!(names(cnd_slice) %in% fl)]
    }
    hh <- NULL
    for (i in names(set_num2)) {
      if (i %in% fl) hh <- c(hh, i) else hh <- c(hh, .removeEndSet(i))
    }
    rs <- paste0("for ", set_num2, " in ", hh, collapse = " ")
  } else {
    rs <- paste0("for ", set_num2, " in ",
                 .removeEndSet(names(set_num2)), collapse = " ")
  }

  # rs <- paste0('(', paste0(set_num2, collapse =', '), ') in (', paste0(.removeEndSet(names(set_num2)), collapse = ', '), ')')

  if (length(cnd_slice) != 0) {
    rs <- paste0(rs, " if ", paste0(
      paste0("(", c(lapply(cnd_slice, paste0, collapse = ", "),
      recursive = TRUE
    ), ") in ", names(cnd_slice)), collapse = " && "))
    # rs <- paste0(rs, ' if ', paste0(paste0('(', c(lapply(cnd_slice, paste0, collapse = ', '),
    #   recursive = TRUE), ') in ', names(cnd_slice)), collapse = ' && '))
  }
  list(first = NULL, end = rs)
}

.get_julia_loop_fast2 <- function(tx) {
  if (any(grep("[$]", tx))) {
    beg <- gsub("[$].*", "", tx)
    end <- substr(tx, nchar(beg) + 2, nchar(tx))
  } else {
    beg <- tx
    end <- NULL
  }
  .get_julia_loop_fast(beg, end)
}

.get.bracket.julia <- function(tmp) {
  brk0 <- gsub("[^)(]", "", tmp)
  brk <- cumsum(c("(" = 1, ")" = -1)[strsplit(brk0, "")[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0("^", paste0(paste0("[", names(brk)[1:(k - 1)], "]"),
                                rep("[^)(]*", k - 1), collapse = ""),
                    names(brk)[k]), "", tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}

.handle.sum.julia <- function(tmp) {
  hh <- .get.bracket.julia(tmp)
  a1 <- sub("^[(]", "", sub("[)]$", "", hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ",") {
    a2 <- gsub("^([[:alnum:]]|[+]|[-]|[*]|[$])*", "", a2)
    if (substr(a2, 1, 1) == "(") {
      a2 <- .get.bracket.julia(a2)$end
    }
  }
  # paste0('(', .eqt.to.julia(substr(a2, 2, nchar(a2))), ' for ', .get_julia_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ')',
  #        .eqt.to.julia(hh$end))
  paste0(
    "(", .eqt.to.julia(substr(a2, 2, nchar(a2))),
    .get_julia_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ")",
    .eqt.to.julia(hh$end)
  )
}
.eqt.to.julia <- function(tmp) {
  rs <- ""
  while (nchar(tmp) != 0) {
    tmp <- gsub("^[ ]*", "", tmp)
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, "sum", .handle.sum.julia(substr(tmp, 4, nchar(tmp))))
      tmp <- ""
    } else if (any(grep("^([.[:digit:]]|[+]|[-]|[ ]|[*])", tmp))) {
      a3 <- gsub("^([.[:digit:]_]|[+]|[-]|[ ]|[*])*", "", tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c("m", "v", "p")) {
      a1 <- sub("^[[:alnum:]_]*", "", tmp)
      vrb <- substr(tmp, 1, nchar(tmp) - nchar(a1))
      a2 <- .get.bracket.julia(a1)
      arg <- paste0("(", paste0(.aliasName(
        strsplit(gsub("[() ]", "", a2$beg), ",")[[1]]), collapse = ", "), ")")
      if (nchar(arg) == 0) {
        vrb2 <- paste0(vrb)
      } else {
        vrb2 <- paste0(vrb, "[", arg, "]")
        if (substr(tmp, 1, 1) == "p") {
          if (arg == "()") vrb2 <- vrb else vrb2 <-
              paste0("(if haskey(", vrb, ",", arg, "); ", vrb2,
                     "; else ", vrb, "Def; end)")
        }
      }
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == "$") {
        # There are condition
        rs <- paste0(
          rs, "(if ", arg, " in ", gsub("([$]|[(].*)", "", a2$end),
          "; ", vrb2, "; else 0;end)",
          .eqt.to.julia(gsub("^[^)]*[)]", "", a2$end))
        )
        tmp <- ""
      } else {
        rs <- paste0(rs, vrb2, .eqt.to.julia(a2$end))
        tmp <- ""
      }
    } else if (substr(tmp, 1, 1) == "=") {
      rs <- paste0(rs, c("g" = ">=", "e" = "==", "l" = "<=")[substr(tmp, 2, 2)])
      tmp <- substr(tmp, 4, nchar(tmp))
    } else if (substr(tmp, 1, 1) == ";") {
      rs <- paste0(rs, ");")
      tmp <- substr(tmp, 2, nchar(tmp))
    } else {
      browser()
    }
  }
  rs
}

# equation declaration
.equation.from.gams.to.julia <- function(eqt) {
  declaration <- gsub("[.][.].*", "", eqt)
  rs <- "@constraint(model, "
  if (nchar(declaration) != nchar(gsub("[($].*", "", declaration))) {
    rs <- paste0(rs, paste0(
      "[(", paste0(.aliasName(
        strsplit(gsub("(.*[(]|[)]|[[:blank:]]*)", "", declaration), ",")[[1]]),
        collapse = ", "),
      ") in ", gsub("[(].*", "", gsub(".*[$]", "", declaration)),
      "], "
    ))
  }
  rs <- paste0(rs, .eqt.to.julia(gsub(".*[.][.][ ]*", "", eqt)))
  rs
}
