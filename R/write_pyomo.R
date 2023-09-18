# Functions to write PYOMO model and data files
.write_model_PYOMO <- function(arg, scen) {
  AbstractModel <- any(grep("abstract", scen@settings@solver$lang, ignore.case = TRUE))
  if (AbstractModel) {
    run_code <- scen@settings@sourceCode[["PYOMOAbstract"]]
    run_codeout <- scen@settings@sourceCode[["PYOMOAbstractOutput"]]

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
        templ <- paste0("(^|[^[:alnum:]])", yy, "[[]")
        if (any(grep("^pCns", nn))) {
          for (www in seq_along(scen@modInp@gams.equation)) {
            mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
            if (any(mmm)) {
              scen@modInp@gams.equation[[www]]$equation[mmm] <-
                sapply(
                  strsplit(scen@modInp@gams.equation[[www]]$equation[mmm], yy),
                  .rem_col_sq, yy, rmm
                )
            }
          }
        } else if (any(grep("^pCosts", nn))) {
          mmm <- grep(templ, scen@modInp@costs.equation)
          if (any(mmm)) {
            scen@modInp@costs.equation[mmm] <-
              sapply(strsplit(scen@modInp@costs.equation[mmm], yy),
                     .rem_col_sq, yy, rmm)
          }
        } else {
          mmm <- grep(templ, run_code)
          if (any(mmm)) {
            run_code[mmm] <-
              sapply(strsplit(run_code[mmm], yy), .rem_col_sq, yy, rmm)
          }
        }
      }
    }
  } else {
    run_code <- scen@settings@sourceCode[["PYOMOConcrete"]]
    run_codeout <- scen@settings@sourceCode[["PYOMOConcreteOutput"]]
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
        templ <- paste0("(^|[^[:alnum:]])", yy, "[.]get[(][(]")
        if (any(grep("^pCns", nn))) {
          for (www in seq_along(scen@modInp@gams.equation)) {
            mmm <- grep(templ, scen@modInp@gams.equation[[www]]$equation)
            if (any(mmm)) {
              scen@modInp@gams.equation[[www]]$equation[mmm] <-
                sapply(
                  strsplit(
                    scen@modInp@gams.equation[[www]]$equation[mmm],
                    paste0(yy, "[.]get[(][(]")
                  ),
                  .rem_col_pyomo_concrete, yy, rmm
                )
            }
          }
        } else if (any(grep("^pCosts", nn))) {
          mmm <- grep(templ, scen@modInp@costs.equation)
          if (any(mmm)) {
            scen@modInp@costs.equation[mmm] <-
              sapply(
                strsplit(scen@modInp@costs.equation[mmm], yy),
                .rem_col, yy, rmm
              )
          }
        } else {
          mmm <- grep(templ, run_code)
          if (any(mmm)) {
            run_code[mmm] <- sapply(
              strsplit(run_code[mmm], paste0(yy, "[.]get[(][(]")),
              .rem_col_pyomo_concrete, yy, rmm
            )
          }
        }
      }
    }
  }
  dir.create(paste(arg$tmp.dir, "/input", sep = ""), showWarnings = FALSE)
  dir.create(paste(arg$tmp.dir, "/output", sep = ""), showWarnings = FALSE)
  # if (!is.null(scen@settings@solver$SQLite) && scen@settings@solver$SQLite) {
  if (is.null(scen@settings@solver$export_format)) {
    SQLite <- FALSE
  } else {
    SQLite <- tolower(scen@settings@solver$export_format) == "sqlite"
  }
  if (is.null(SQLite)) SQLite <- FALSE
  if (SQLite) {
    ### Generate SQLite file
    .write_sqlite_list(
      dat = .get_scen_data(scen),
      sqlFile = paste0(arg$tmp.dir, "input/data.db")
    )
  }
  .write_inc_solver(scen, arg, "opt = SolverFactory('cplex');", ".py", "cplex")
  # Add constraint
  zz_mod <- file(paste(arg$tmp.dir, "/energyRt.py", sep = ""), "w")
  zz_constr <- file(paste(arg$tmp.dir, "/inc_constraints.py", sep = ""), "w")
  zz_costs <- file(paste(arg$tmp.dir, "/inc_costs.py", sep = ""), "w")
  npar <- grep("^##### decl par #####", run_code)[1]
  cat(run_code[1:npar], sep = "\n", file = zz_mod)
  if (!AbstractModel) {
    cat('exec(open("data.py").read())\n', file = zz_mod)
    zz_inp_file <- file(paste0(arg$tmp.dir, "data.py"), "w")
  }
  if (AbstractModel) {
    f1 <- grep("^m(Costs|Cns)", names(scen@modInp@parameters), invert = TRUE)
    f2 <- grep("^mCns", names(scen@modInp@parameters))
    f3 <- grep("^mCosts", names(scen@modInp@parameters))
    cat(.generate.pyomo.par(scen@modInp@parameters[f1]),
      sep = "\n",
      file = zz_mod
    )
    if (length(f2) > 0) {
      cat(.generate.pyomo.par(scen@modInp@parameters[f2]),
        sep = "\n",
        file = zz_constr
      )
    }
    if (length(f3) > 0) {
      cat(.generate.pyomo.par(scen@modInp@parameters[f3]),
        sep = "\n",
        file = zz_costs
      )
    }
  }
  if (AbstractModel) {
    zz_data_pyomo <- file(paste(arg$tmp.dir, "data.dat", sep = ""), "w")
  }
  file_w <- c()
  for (j in c("set", "map", "numpar", "bounds")) {
    for (i in names(scen@modInp@parameters)) {
      if (scen@modInp@parameters[[i]]@type == j) {
        if (AbstractModel) {
          cat(.toPyomoAbstractModel(scen@modInp@parameters[[i]]),
            sep = "\n", file = zz_data_pyomo
          )
        } else {
          if (any(grep("^.Cns", i))) {
            # if (!is.null(scen@settings@solver$SQLite) && scen@settings@solver$SQLite) {
            if (SQLite) {
              cat(.toPyomSQLite(scen@modInp@parameters[[i]]),
                sep = "\n",
                file = zz_constr
              )
              ## SQLite import
            } else {
              cat(.toPyomo(scen@modInp@parameters[[i]]),
                sep = "\n",
                file = zz_constr
              )
            }
          } else if (any(grep("^.Costs", i))) {
            # if (!is.null(scen@settings@solver$SQLite) && scen@settings@solver$SQLite) {
            if (SQLite) {
              cat(.toPyomSQLite(scen@modInp@parameters[[i]]),
                sep = "\n",
                file = zz_costs
              )
              ## SQLite import
            } else {
              cat(.toPyomo(scen@modInp@parameters[[i]]),
                sep = "\n",
                file = zz_costs
              )
            }
          } else {
            if (SQLite) {
              cat(.toPyomSQLite(scen@modInp@parameters[[i]]),
                sep = "\n",
                file = zz_inp_file
              )
              ## SQLite import
            } else {
              tfl <- paste0("input/", scen@modInp@parameters[[i]]@name, ".py")
              cat(paste0('exec(open("', tfl, '").read())\n'), file = zz_inp_file)
              zz_tfl <- file(paste0(arg$tmp.dir, tfl), "w")
              cat(.toPyomo(scen@modInp@parameters[[i]]),
                sep = "\n", file = zz_tfl
              )
              close(zz_tfl)
            }
          }
        }
      }
    }
  }
  if (AbstractModel) close(zz_data_pyomo)
  if (!AbstractModel && !SQLite) close(zz_inp_file)
  npar2 <- (grep("^model[.]obj ", run_code)[1] - 1)
  cat(run_code[npar:npar2], sep = "\n", file = zz_mod)
  ## Add constraint equation
  if (length(scen@modInp@gams.equation) > 0) {
    cat("\n", file = zz_constr)
    for (i in seq_along(scen@modInp@gams.equation)) {
      eqt <- scen@modInp@gams.equation[[i]]
      if (AbstractModel) {
        cat(.equation.from.gams.to.pyomo.AbstractModel(eqt$equation),
          sep = "\n", file = zz_constr
        )
      } else {
        cat(.equation.from.gams.to.pyomo(eqt$equation),
          sep = "\n", file = zz_constr
        )
      }
    }
  }
  ## Add costs equation
  {
    cat("\n", file = zz_costs)
    if (AbstractModel) {
      cat(.equation.from.gams.to.pyomo.AbstractModel(
        scen@modInp@costs.equation
      ), sep = "\n", file = zz_costs)
    } else {
      cat(.equation.from.gams.to.pyomo(
        scen@modInp@costs.equation
      ), sep = "\n", file = zz_costs)
    }
  }
  cat(run_code[-(1:npar2)], sep = "\n", file = zz_mod)
  if (AbstractModel) {
    cat('f = open("output/raw_data_set.csv","w");\n', file = zz_mod)
    cat("f.write('set,value\\n')\n", file = zz_mod)
    for (tmp in scen@modInp@parameters[
      sapply(scen@modInp@parameters, function(x) x@type == "set")
    ]) {
      cat("for i in instance.", tmp@name, ":\n    f.write('", tmp@name,
        ",' + str(i) + '\\n')\n",
        sep = "", file = zz_mod
      )
    }
    cat("f.close()\n", file = zz_mod)
  }
  close(zz_mod)
  close(zz_constr)
  close(zz_costs)
  zz_modout <- file(paste(arg$tmp.dir, "/output.py", sep = ""), "w")
  cat(run_codeout, sep = "\n", file = zz_modout)
  close(zz_modout)
  .write_inc_files(arg, scen, ".py")
  if (is.null(scen@settings@solver$cmdline) || scen@settings@solver$cmdline == "") {
    scen@settings@solver$cmdline <- "python energyRt.py"
  }
  scen@settings@solver$code <- c(
    "energyRt.py", "output.py", "inc_constraints.py",
    "inc_costs.py", "inc_solver.py"
  )
  scen
}

.rem_col_pyomo_concrete <- function(x, nn, rmm) {
  for (i in 2:length(x)) {
    tt <- gsub("[)][)].*", "", x[i])
    til <- substr(x[i], nchar(tt) + 3, nchar(x[i]))
    mm <- strsplit(tt, "[,]")[[1]][-rmm]
    if (length(mm) == 0) {
      x[i] <- paste0(nn, til)
    } else {
      x[i] <- paste0(nn, ".get((", paste0(mm, collapse = ", "), "))", til)
    }
  }
  return(paste0(x, collapse = ""))
}

# Generate PYOMO code, return character vector
.toPyomo <- function(obj) {
  as_numpar <- function(data, name, name2, def) {
    if (def == Inf) def <- 0
    if (ncol(obj@data) == 1) {
      if (nrow(obj@data) == 1) def <- obj@data[[1]]
      return(paste0("# ", name, name2, "\n", name, " = toPar(set(), ",
                    def, ")\n"))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      if (nrow(data) == 0) {
        rtt <- paste0("# ", name, name2, "\n", name, " = toPar(set(), ",
                      def, ")\n")
        return(rtt)
      }
      rtt <- paste0("# ", name, name2, "\ntmp = {} \n")
      kk <- paste0("tmp[('", data[, 1])
      for (i in seq_len(ncol(data) - 2) + 1) {
        kk <- paste0(kk, "', '", data[[i]])
      }
      kk <- paste0(kk, "')] = ", data[, "value"])
      kk <- c(
        rtt, paste0(kk, collapse = "\n"), "\n\n",
        paste0(name, " = toPar(tmp, ", def, ")\n")
      )
      return(kk)
    }
  }
  if (obj@misc$nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@misc$nValues), , drop = FALSE]
  }
  if (obj@type == "set") {
    tmp <- ""
    if (nrow(obj@data) > 0) {
      tmp <- paste0("['", paste0(sort(obj@data[, 1]), collapse = "', '"), "']")
    }
    return(c(paste0("# ", obj@name), paste0("\n", obj@name, " = set(", tmp, ");")))
  } else if (obj@type == "map") {
    ret <- paste0("# ", obj@name, "(", paste0(obj@dimSets, collapse = ", "), ")")
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0("\n", obj@name, " = set();")))
    } else {
      return(c(ret, paste0(
        "\n", obj@name, " = set([",
        paste0(paste0("('", apply(
          obj@data, 1,
          function(x) paste(x, collapse = "', '")
        ), "')"), collapse = ",\n"), "]);"
      )))
    }
  } else if (obj@type == "numpar") {
    return(as_numpar(
      obj@data, obj@name, gsub(
        "[(][)]", "",
        paste0("(", paste0(obj@dimSets, collapse = ", "), ")")
      ),
      obj@defVal
    ))
  } else if (obj@type == "bounds") {
    hh <- gsub("[(][)]", "", paste0("(", paste0(obj@dimSets, collapse = ", "), ")"))
    return(c(
      as_numpar(
        obj@data[obj@data$type == "lo", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Lo", sep = ""), hh, obj@defVal[1]
      ),
      as_numpar(
        obj@data[obj@data$type == "up", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Up", sep = ""), hh, obj@defVal[2]
      )
    ))
  } else {
    stop(paste0(
      "Error: .toPyomo: unknown parameter type: ",
      obj@type, " / ", obj@name
    ))
  }
}

.toPyomoAbstractModel <- function(obj) {
  as_numpar <- function(data, name, name2, def) {
    if (ncol(obj@data) == 1) {
      if (nrow(data) != 0) def <- data$value
      return(paste0("# ", name, "\nparam ", name, " := ", def, ";\n"))
    } else {
      data <- data[data$value != Inf & data$value != def, ]
      rtt <- paste0("# ", name, name2, "\nparam ", name, " default ", def, " := ")
      if (nrow(data) == 0) {
        return(paste0("# ", name, name2, " no data except default\n"))
      }
      kk <- paste0("  ", data[, 1])
      for (i in seq_len(ncol(data) - 2) + 1) {
        kk <- paste0(kk, " ", data[[i]])
      }
      kk <- paste0(kk, " ", data[, "value"])
      kk <- c(rtt, paste0(kk, collapse = "\n"), "\n;\n")
      return(kk)
    }
  }
  if (obj@misc$nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@misc$nValues), , drop = FALSE]
  }
  if (obj@type == "set") {
    tmp <- ""
    if (nrow(obj@data) > 0) {
      tmp <- paste0("\n  ", sort(obj@data[, 1]), collapse = "")
    }
    return(c(paste0("# ", obj@name), paste0("\nset ", obj@name, " := ", tmp, ";")))
  } else if (obj@type == "map") {
    ret <- paste0("# ", obj@name, "(", paste0(obj@dimSets, collapse = ", "), ")")
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0("set ", obj@name, " := ;")))
    } else {
      return(c(ret, paste0("set ", obj@name, " := \n", paste0(paste0("  ", apply(
        obj@data, 1,
        function(x) paste(x, collapse = " ")
      ), "\n"), collapse = ""), ";")))
    }
  } else if (obj@type == "numpar") {
    return(as_numpar(
      obj@data, obj@name,
      paste0("(", paste0(obj@dimSets, collapse = ", "), ")"), obj@defVal
    ))
  } else if (obj@type == "bounds") {
    hh <- paste0("(", paste0(obj@dimSets, collapse = ", "), ")")
    return(c(
      as_numpar(
        obj@data[obj@data$type == "lo", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Lo", sep = ""), hh, obj@defVal[1]
      ),
      as_numpar(
        obj@data[obj@data$type == "up", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Up", sep = ""), hh, obj@defVal[2]
      )
    ))
  } else {
    stop(paste0(
      "Error: .toPyomoAbstractModel: unknown parameter type: ",
      obj@type, " / ", obj@name
    ))
  }
}

.toPyomSQLite <- function(obj) {
  as_numpar <- function(data, name, name2, def) {
    if (def == Inf) def <- 0
    if (ncol(obj@data) == 1) {
      browser()
      stop(".toPyomSQLite: check @data in ", obj@name)
    } else {
      data <- data[data$value != Inf & data$value != def, , drop = F]
      if (nrow(data) == 0) {
        rtt <- paste0("# ", name, name2, "\n", name, " = toPar(set(), ",
                      def, ")\n")
        return(rtt)
      }
      rtt <- paste0("# ", name, name2, "\n")
      kk <- paste0(name, ' = toPar(read_dict("', name, '"), ',
                   def, ")\n")
      return(kk)
    }
  }
  if (obj@misc$nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@misc$nValues), , drop = FALSE]
  }
  if (obj@type == "set") {
    tmp <- ""
    if (nrow(obj@data) > 0) {
      tmp <- paste0("read_set('", obj@name, "')")
    }
    return(c(paste0("# ", obj@name),
             paste0("\n", obj@name, " = set(", tmp, ")")))
  } else if (obj@type == "map") {
    ret <- paste0("# ", obj@name, "(", paste0(obj@dimSets, collapse = ", "), ")")
    if (nrow(obj@data) == 0) {
      return(c(ret, paste0("\n", obj@name, " = set();")))
    } else {
      tmp <- paste0("read_set('", obj@name, "')")
      return(c(ret, paste0("\n", obj@name, " = set(", tmp, ")")))
    }
  } else if (obj@type == "numpar") {
    return(as_numpar(
      obj@data,
      obj@name,
      paste0("(", paste0(obj@dimSets, collapse = ", "), ")"),
      obj@defVal
    ))
  } else if (obj@type == "bounds") {
    hh <- paste0("(", paste0(obj@dimSets, collapse = ", "), ")")
    return(c(
      as_numpar(
        obj@data[obj@data$type == "lo", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Lo", sep = ""), hh, obj@defVal[1]
      ),
      as_numpar(
        obj@data[obj@data$type == "up", 1 - ncol(obj@data), drop = FALSE],
        paste(obj@name, "Up", sep = ""), hh, obj@defVal[2]
      )
    ))
  } else {
    stop(paste0("Error: .toPyomo: unknown parameter type: ",
                obj@type, " / ", obj@name))
  }
}

.generate.pyomo.par <- function(param) {
  decl <- NULL
  # Generate set declaration
  for (tmp in param[sapply(param, function(x) x@type == "set")]) {
    decl <- c(decl, paste0("model.", tmp@name, " = Set();"))
  }
  # Generate map declaration
  for (tmp in param[sapply(param, function(x) x@type == "map")]) {
    decl <- c(decl, paste0(
      "model.", tmp@name, " = Set(within = ",
      paste0("model.", .removeEndSet(tmp@dimSets), collapse = "*"),
      ");"
    ))
  }
  value_or_zero <- function(x) {
    if (x == Inf || x == -Inf) {
      return(0)
    }
    return(x)
  }
  # Generate numpar parameter declaration
  for (tmp in param[sapply(param, function(x) x@type == "numpar")]) {
    decl <- c(
      decl,
      paste0(
        "model.", tmp@name, " = Param(",
        paste0("model.", .removeEndSet(tmp@dimSets), collapse = "*"),
        ", default = ", value_or_zero(tmp@defVal), ");"
      )
    )
  }
  # Generate bounds parameter declaration
  for (tmp in param[sapply(param, function(x) x@type == "bounds")]) {
    decl <- c(
      decl,
      paste0(
        "model.", tmp@name, "Lo = Param(",
        paste0("model.", .removeEndSet(tmp@dimSets), collapse = "*"),
        ", default = ",
        value_or_zero(tmp@defVal[1]), ");"
      ),
      paste0(
        "model.", tmp@name, "Up = Param(",
        paste0("model.", .removeEndSet(tmp@dimSets), collapse = "*"),
        ", default = ",
        value_or_zero(tmp@defVal[2]), ");"
      )
    )
  }
  decl <- gsub("[(]model.,", "(", decl)
  decl
}

# Translate GAMS constraints to Pyomo ####
# Make vector .alias_set (from gams to alias) and set_alias

# set_alias <- .set_al0
# names(set_alias) <- .alias_set


## Function
.get_pyomo_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == "(") {
    set_cond <- sub("^[(]", "", sub("[)]$", "", set_cond))
  }
  set_loop <- sub("^[(]", "", sub("[)]$", "", set_loop))
  xx <- .generate_loop_pyomo(set_loop, set_cond)
  rs <- xx$first
  if (!is.null(xx$end) || !is.null(add_cond)) {
    rs <- paste0(rs, " ", paste0(xx$end, add_cond, collapse = " and "))
  }
  rs <- paste0(rs, "")
  rs
}
# .set_al <- c("stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
# .alias_set <- c("st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
# names(.alias_set) <- .set_al
# .aliasName <- function(x) {
#   if (!all(x %in% .set_al)) {
#     cat("Unknown .set_al\n")
#     browser()
#     stop("Unknown set")
#   }
#   .alias_set[x]
# }

# .fremset <-   c("comm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "region", "region")
# names(.fremset) <-   c("acomm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
#
# .removeEndSet <- function(x) {
#   .fremset[x]
# }
.generate_loop_pyomo <- function(set_num, set_loop) {
  # if (any(grep('mCnsuseElc2018Coa1_3', c(set_loop, set_num)))) browser()

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
  rs <- paste0(
    "(", paste0(set_num2, collapse = ", "), ") in ",
    "itertools.product"[length(set_num2) > 1],
    "(", paste0("", .removeEndSet(names(set_num2)), collapse = ","), ")"
  )
  if (length(cnd_slice) != 0) {
    fl <- (sapply(cnd_slice, length) == 1)
    if (any(fl)) {
      ff <- c(cnd_slice[fl], recursive = TRUE)
      ff <- ff[!duplicated(ff)]
      names(ff) <- gsub("[.].*", "", names(ff))
      kk <- seq_along(set_num2)
      names(kk) <- set_num2
      names(set_num2) <- .removeEndSet(names(set_num2))
      names(set_num2)[kk[ff]] <- names(ff)
      rs <- paste0(
        "(", paste0(set_num2, collapse = ", "), ") in ",
        "itertools.product"[length(set_num2) > 1],
        "(", paste0("", names(set_num2), collapse = ","), ")"
      )
      cnd_slice <- cnd_slice[!(names(cnd_slice) %in% names(ff))]
      if (length(cnd_slice) != 0) {
        iii <- c(lapply(cnd_slice, paste0, collapse = ", "), recursive = TRUE)
        iii[grep(",", iii)] <- paste0("(", iii[grep(",", iii)], ")")
        rs <- paste0(rs, " if ", paste0(paste0(iii, " in ", names(cnd_slice)),
                                        collapse = " and "))
      }
    } else {
      iii <- c(lapply(cnd_slice, paste0, collapse = ", "), recursive = TRUE)
      iii[grep(",", iii)] <- paste0("(", iii[grep(",", iii)], ")")
      rs <- paste0(rs, " if ", paste0(paste0(iii, " in ", names(cnd_slice)),
                                      collapse = " and "))
    }
  }
  list(first = NULL, end = rs)
}

.get_pyomo_loop_fast2 <- function(tx) {
  if (any(grep("[$]", tx))) {
    beg <- gsub("[$].*", "", tx)
    end <- substr(tx, nchar(beg) + 2, nchar(tx))
  } else {
    beg <- tx
    end <- NULL
  }
  .get_pyomo_loop_fast(beg, end)
}

.get.bracket.pyomo <- function(tmp) {
  brk0 <- gsub("[^)(]", "", tmp)
  brk <- cumsum(c("(" = 1, ")" = -1)[strsplit(brk0, "")[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0("^", paste0(paste0("[", names(brk)[1:(k - 1)], "]"),
                                rep("[^)(]*", k - 1), collapse = ""),
                    names(brk)[k]), "", tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}

.handle.sum.pyomo <- function(tmp) {
  hh <- .get.bracket.pyomo(tmp)
  a1 <- sub("^[(]", "", sub("[)]$", "", hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ",") {
    a2 <- gsub("^([[:alnum:]]|[+]|[-]|[*]|[$])*", "", a2)
    if (substr(a2, 1, 1) == "(") {
      a2 <- .get.bracket.pyomo(a2)$end
    }
  }
  paste0(
    "(", .eqt.to.pyomo(substr(a2, 2, nchar(a2))), " for ",
    .get_pyomo_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ")",
    .eqt.to.pyomo(hh$end)
  )
}
.eqt.to.pyomo <- function(tmp) {
  rs <- ""
  while (nchar(tmp) != 0) {
    tmp <- gsub("^[ ]*", "", tmp)
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, "sum", .handle.sum.pyomo(substr(tmp, 4, nchar(tmp))))
      tmp <- ""
    } else if (any(grep("^([.[:digit:]]|[+]|[-]|[ ]|[*])", tmp))) {
      a3 <- gsub("^([.[:digit:]_]|[+]|[-]|[ ]|[*])*", "", tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c("m", "v", "p")) {
      a1 <- sub("^[[:alnum:]_]*", "", tmp)
      # if (substr(tmp, 1, 1) == 'p') {
      #   vrb <- paste0('model.', substr(tmp, 1, nchar(tmp) - nchar(a1)))
      #   browser()
      # }
      vrb <- paste0("model.", substr(tmp, 1, nchar(tmp) - nchar(a1)))
      a2 <- .get.bracket.pyomo(a1)
      arg <- paste0("", paste0(.aliasName(
        strsplit(gsub("[() ]", "", a2$beg), ",")[[1]]), collapse = ", "), "")
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == "$") {
        # There are condition
        arg2 <- arg
        if (any(grep(",", arg2))) arg2 <- paste0("(", arg2, ")")
        rs <- paste0(
          rs, "(", vrb, "[", arg, "] ", "if ", arg2, " in model.",
          gsub("([$]|[(].*)", "", a2$end),
          " else 0)", .eqt.to.pyomo(gsub("^[^)]*[)]", "", a2$end))
        )
        tmp <- ""
      } else {
        rs <- paste0(
          rs, vrb, "[", arg, "]",
          .eqt.to.pyomo(a2$end)
        )
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
.equation.from.gams.to.pyomo <- function(eqt) {
  declaration <- gsub("[.][.].*", "", eqt)
  rs <- paste0("model.", gsub("[$.(].*", "", eqt), " = Constraint(")

  if (nchar(declaration) != nchar(gsub("[($].*", "", declaration))) {
    rs <- paste0(
      rs, "", gsub("[(].*", "", gsub(".*[$]", "", declaration)),
      ", rule = lambda model, ",
      paste0(.aliasName(
        strsplit(gsub("(.*[(]|[)]|[[:blank:]]*)", "", declaration), ",")[[1]]),
        collapse = ", "
      ), " : "
    )
  } else {
    rs <- paste0(rs, "rule = lambda model : ")
  }
  rs <- paste0(rs, "model.fornontriv + ",
               .eqt.to.pyomo(gsub(".*[.][.][ ]*", "", eqt)))
  # Change parameter notation
  spl <- strsplit(rs, "model[.]p")[[1]]
  if (length(spl) > 1) {
    cnd <- grep("^[[:alnum:]_]*[[]", spl[-1]) + 1
    rst <- sub("[^]]*[]]", "", spl[cnd])
    frs <- substr(spl[cnd], 1, nchar(spl[cnd]) - nchar(rst))
    spl[cnd] <- paste0(gsub("[]]", "))", gsub("[[]", ".get((", frs)), rst)
    rs <- paste0(spl, collapse = "p")
  }
  spl <- strsplit(rs, "model[.]m")[[1]]
  if (length(spl) > 1) {
    cnd <- grep("^[[:alnum:]_]*[[]", spl[-1]) + 1
    rst <- sub("[^]]*[]]", "", spl[cnd])
    frs <- substr(spl[cnd], 1, nchar(spl[cnd]) - nchar(rst))
    spl[cnd] <- paste0(gsub("[]]", ")]", gsub("[[]", "[(", frs)), rst)
    rs <- paste0(spl, collapse = "m")
  }
  rs
}

# Translate ... to pyomo.jump ####
# Generate vector .alias_set (from gams to alias) and set_alias

# set_alias <- .set_al0
# names(set_alias) <- .alias_set

## Function
.get_pyomo.jump_loop_fast <- function(set_loop, set_cond, add_cond = NULL) {
  if (!is.null(set_cond) && substr(set_cond, 1, 1) == "(") {
    set_cond <- sub("^[(]", "", sub("[)]$", "", set_cond))
  }
  set_loop <- sub("^[(]", "", sub("[)]$", "", set_loop))
  xx <- .generate_loop_pyomo.jump(set_loop, set_cond)
  rs <- xx$first
  if (!is.null(xx$end) || !is.null(add_cond)) {
    rs <- paste0(rs, " ", paste0(xx$end, add_cond, collapse = " and "))
  }
  rs <- paste0(rs, "")
  rs
}
# .set_al <- c("stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
# .alias_set <- c("st1", "t1", "e", "i", "t", "d", "s1", "wth1", "r", "y", "s", "g", "c", "cn1", "st1p", "t1p", "ep", "ip", "tp", "dp", "s1p", "wth1p", "rp", "yp", "sp", "gp", "cp", "cn1p", "st1e", "t1e", "ee", "ie", "te", "de", "s1e", "wth1e", "re", "ye", "se", "ge", "ce", "cn1e", "st1n", "t1n", "en", "in", "tn", "dn", "s1n", "wth1n", "rn", "yn", "sn", "gn", "cn", "cn1n", "src", "dst")
# names(.alias_set) <- .set_al
# .aliasName <- function(x) {
#   if (!all(x %in% .set_al)) {
#     cat("Unknown .set_al\n")
#     browser()
#     stop("Unknown set")
#   }
#   .alias_set[x]
# }

# .fremset <- c("comm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "region", "region")
# names(.fremset) <- c("acomm", "stg", "trade", "expp", "imp", "tech", "dem", "sup", "weather", "region", "year", "slice", "group", "comm", "cns", "stgp", "tradep", "exppp", "impp", "techp", "demp", "supp", "weatherp", "regionp", "yearp", "slicep", "groupp", "commp", "cnsp", "stge", "tradee", "exppe", "impe", "teche", "deme", "supe", "weathere", "regione", "yeare", "slicee", "groupe", "comme", "cnse", "stgn", "traden", "exppn", "impn", "techn", "demn", "supn", "weathern", "regionn", "yearn", "slicen", "groupn", "commn", "cnsn", "src", "dst")
#
# .removeEndSet <- function(x) {
#   .fremset[x]
# }
.generate_loop_pyomo.jump <- function(set_num, set_loop) {
  # if (any(grep('mCnsuseElc2018Coa1_3', c(set_loop, set_num)))) browser()

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
  rs <- paste0("(",
               paste0(set_num2, collapse = ", "), ") in (",
               paste0("model.", .removeEndSet(names(set_num2)), collapse = "*"),
               ")")
  if (length(cnd_slice) != 0) {
    fl <- (sapply(cnd_slice, length) == 1)
    if (any(fl)) {
      ff <- c(cnd_slice[fl], recursive = TRUE)
      ff <- ff[!duplicated(ff)]
      names(ff) <- gsub("[.].*", "", names(ff))
      kk <- seq_along(set_num2)
      names(kk) <- set_num2
      names(set_num2) <- .removeEndSet(names(set_num2))
      names(set_num2)[kk[ff]] <- names(ff)
      rs <- paste0("(", paste0(set_num2, collapse = ", "), ") in (",
                   paste0("model.", names(set_num2), collapse = "*"), ")")
      cnd_slice <- cnd_slice[!(names(cnd_slice) %in% names(ff))]
      if (length(cnd_slice) != 0) {
        iii <- c(lapply(cnd_slice, paste0, collapse = ", "), recursive = TRUE)
        iii[grep(",", iii)] <- paste0("(", iii[grep(",", iii)], ")")
        rs <- paste0(rs, " if ",
                     paste0(paste0(iii, " in model.", names(cnd_slice)),
                            collapse = " and "))
      }
    } else {
      iii <- c(lapply(cnd_slice, paste0, collapse = ", "), recursive = TRUE)
      iii[grep(",", iii)] <- paste0("(", iii[grep(",", iii)], ")")
      rs <- paste0(rs, " if ",
                   paste0(paste0(iii, " in model.", names(cnd_slice)),
                          collapse = " and "))
    }
  }
  list(first = NULL, end = rs)
}

.get_pyomo.jump_loop_fast2 <- function(tx) {
  if (any(grep("[$]", tx))) {
    beg <- gsub("[$].*", "", tx)
    end <- substr(tx, nchar(beg) + 2, nchar(tx))
  } else {
    beg <- tx
    end <- NULL
  }
  .get_pyomo.jump_loop_fast(beg, end)
}

.get.bracket.pyomo.jump <- function(tmp) {
  brk0 <- gsub("[^)(]", "", tmp)
  brk <- cumsum(c("(" = 1, ")" = -1)[strsplit(brk0, "")[[1]]])
  k <- seq_along(brk)[brk == 0][1]
  end <- sub(paste0("^", paste0(paste0("[", names(brk)[1:(k - 1)], "]"),
                                rep("[^)(]*", k - 1), collapse = ""), names(brk)[k]), "", tmp)
  list(beg = substr(tmp, 1, nchar(tmp) - nchar(end)), end = end)
}

.handle.sum.pyomo.jump <- function(tmp) {
  hh <- .get.bracket.pyomo.jump(tmp)
  a1 <- sub("^[(]", "", sub("[)]$", "", hh$beg))
  a2 <- a1
  while (substr(a2, 1, 1) != ",") {
    a2 <- gsub("^([[:alnum:]]|[+]|[-]|[*]|[$])*", "", a2)
    if (substr(a2, 1, 1) == "(") {
      a2 <- .get.bracket.pyomo.jump(a2)$end
    }
  }
  paste0(
    "(", .eqt.to.pyomo.jump(substr(a2, 2, nchar(a2))),
    " for ",
    .get_pyomo.jump_loop_fast2(substr(a1, 1, nchar(a1) - nchar(a2))), ")",
    .eqt.to.pyomo.jump(hh$end)
  )
}

.eqt.to.pyomo.jump <- function(tmp) {
  rs <- ""
  while (nchar(tmp) != 0) {
    tmp <- gsub("^[ ]*", "", tmp)
    if (substr(tmp, 1, 4) == "sum(") {
      rs <- paste0(rs, "sum", .handle.sum.pyomo.jump(substr(tmp, 4, nchar(tmp))))
      tmp <- ""
    } else if (any(grep("^([.[:digit:]]|[+]|[-]|[ ]|[*])", tmp))) {
      a3 <- gsub("^([.[:digit:]_]|[+]|[-]|[ ]|[*])*", "", tmp)
      rs <- paste0(rs, substr(tmp, 1, nchar(tmp) - nchar(a3)))
      tmp <- a3
    } else if (substr(tmp, 1, 1) %in% c("m", "v", "p")) {
      a1 <- sub("^[[:alnum:]_]*", "", tmp)
      vrb <- paste0("model.", substr(tmp, 1, nchar(tmp) - nchar(a1)))
      a2 <- .get.bracket.pyomo.jump(a1)
      arg <- paste0("", paste0(
        .aliasName(strsplit(gsub("[() ]", "", a2$beg), ",")[[1]]),
        collapse = ", "), "")
      if (nchar(a2$end) > 1 && substr(a2$end, 1, 1) == "$") {
        # There are condition
        arg2 <- arg
        if (any(grep(",", arg2))) arg2 <- paste0("(", arg2, ")")
        rs <- paste0(
          rs, "(", vrb, "[", arg, "] ", "if ", arg2, " in model.",
          gsub("([$]|[(].*)", "", a2$end),
          " else 0)", .eqt.to.pyomo.jump(gsub("^[^)]*[)]", "", a2$end))
        )
        tmp <- ""
      } else {
        rs <- paste0(
          rs, vrb, "[", arg, "]",
          .eqt.to.pyomo.jump(a2$end)
        )
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
.equation.from.gams.to.pyomo.AbstractModel <- function(eqt) {
  declaration <- gsub("[.][.].*", "", eqt)
  rs <- paste0("model.", gsub("[$.(].*", "", eqt), " = Constraint(")

  if (nchar(declaration) != nchar(gsub("[($].*", "", declaration))) {
    rs <- paste0(
      rs, "model.", gsub("[(].*", "", gsub(".*[$]", "", declaration)),
      ", rule = lambda model, ",
      paste0(.aliasName(
        strsplit(gsub("(.*[(]|[)]|[[:blank:]]*)", "", declaration), ",")[[1]]),
        collapse = ", "
      ), " : "
    )
  } else {
    rs <- paste0(rs, "rule = lambda model : ")
  }
  rs <- paste0(rs, "model.fornontriv + ",
               gsub("[[][]]", "",
                    .eqt.to.pyomo.jump(gsub(".*[.][.][ ]*", "", eqt))))
  rs
}
