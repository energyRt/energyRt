#textemplate <- function(obj) UseMethod("textemplate")

report.scenario <- function(obj, texdir = paste(getwd(), '/reports/', sep = ''), tmp.del = TRUE, 
                            file.name = NULL) {
  obj.name <- deparse(substitute(obj))
  if (is.null(file.name)) {
    file.name <- paste('energyRtReport_Scenario_', 
                       deparse(substitute(obj)), '_',
                       format(Sys.Date(), format = '%Y-%m-%d'), '_', 
                       format(Sys.time(), format = '%H-%M-%S'), 
                       '.pdf', sep = '')
  }
  assign('setPNGLAST', FALSE, globalenv());
  png2 <- function(..., width = 640, height = 480) {assign('setPNGLAST', TRUE, globalenv()); png(..., width = width, height = height);}
  dev.off2 <- function() {assign('setPNGLAST', FALSE, globalenv()); dev.off();}
  WDD <- getwd()
  if (is.null(texdir)) {
    texdir <-  paste(getwd(), '/reports/', sep = '')
  }
  add_drr <- paste('Report_data', obj@name, paste(format(Sys.Date(), 
    format = '%Y-%m-%d'), format(Sys.time(), format = '%H-%M-%S')))
  dir.create(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
  tryCatch({
    setwd(paste(texdir, '/', add_drr, sep = ''))
    dtt <- list()
    dtt$commodity <- list()
    dtt$technology <- list()
    dtt$supply <- list()
    dtt$demand <- list()
    dtt$constrain <- list()
    dtt$import <- list()
    dtt$export <- list()
    dtt$trade <- list()
    dtt$storage <- list()
    dtt$weather <- list()
    for(i in seq(along = obj@model@data)) {
      for(j in seq(along = obj@model@data[[i]]@data)) {
        obj@model@data[[i]]@data[[j]]@name <- obj@model@data[[i]]@data[[j]]@name
        dtt[[class(obj@model@data[[i]]@data[[j]])]][[obj@model@data[[i]]@data[[j]]@name]] <-
          obj@model@data[[i]]@data[[j]]
      }
    }
    for(i in names(dtt)) if (length(dtt[[i]]) != 0) dtt[[i]] <- dtt[[i]][sort(names(dtt[[i]]))]
    set <- obj@modOut@sets
    dat <- obj@modOut@variables
    mid_year <- obj@modInp@parameters$mMidMilestone@data$year
    region <- obj@modInp@parameters$region@data$region
    for (i in seq(along = dat)) {
      if (any(colnames(dat[[i]]) == 'region')) dat[[i]][, 'region'] <- factor(dat[[i]][, 'region'], levels = region)
      if (any(colnames(dat[[i]]) == 'year')) dat[[i]][, 'year'] <- factor(dat[[i]][, 'year'], levels = mid_year)
      if (any(colnames(dat[[i]]) == 'src')) dat[[i]][, 'src'] <- factor(dat[[i]][, 'src'], levels = region)
      if (any(colnames(dat[[i]]) == 'dst')) dat[[i]][, 'dst'] <- factor(dat[[i]][, 'dst'], levels = region)
    }
    tryCatch({
      zz <- file('energyRtScenarioReport.tex', 'w')
      #cat('Auto-report for model ... \n\n', date(), '\n\n', sep = '', file = zz)
      #if (obj@name != '') cat('Name: "', obj@name, '"\n\n', sep = '', file = zz)
      cat('\\documentclass{article}\n', sep = '', file = zz)
      cat('\\usepackage[b4paper]{geometry}\n', sep = '', file = zz)
      cat('\\usepackage[utf8]{inputenc}\n', sep = '', file = zz)
      cat('\\usepackage{breqn}\n', sep = '', file = zz)
      cat('\\usepackage{longtable}\n', sep = '', file = zz)
      cat('\\usepackage{graphicx}\n', sep = '', file = zz)
      cat('\\usepackage{tabularx}\n', sep = '', file = zz)
      cat('\\usepackage{caption}\n', sep = '', file = zz)
      cat('\\usepackage{graphicx}\n', sep = '', file = zz)
      cat('\\usepackage{float}\n', sep = '', file = zz)
      cat('\\usepackage[hidelinks]{hyperref}\n', sep = '', file = zz)
      cat('\\title{A quick report for scenario "', totex(obj.name), '"}\n', sep = '', file = zz)
      cat('\\begin{document}\n', sep = '', file = zz)
      cat('\\maketitle\n', sep = '', file = zz)
      cat('\n\n', sep = '', file = zz)
      
      cat('\\section{Summary}\n\n', '\n', sep = '', file = zz)
      
      if (obj@modOut@compilationStatus != 2) {
        cat('The model run is not completed. The results are not "optimal solution".\n\n', '\n', 
          sep = '', file = zz)
      }
      if (obj@modOut@solutionStatus == 1) {
        cat('Optimal solution found, objective value ', dat$vObjective$value, 
            '.\n\n', '\n', sep = '', file = zz)
      } else {
        cat('The model run is not completed. Exit code ', obj@modOut@solutionStatus, 
            '.\n\n', '\n', sep = '', file = zz)
      }
      gg <- paste('There is ', length(obj@model@data), ' repositary, ', sep = '')
      for(i in names(dtt)) {
        if (length(dtt[[i]]) != 0)
          gg <- paste(gg, length(dtt[[i]]), ' ', i, ', ', sep = '')
      }
      gg <- sub('[,][ ]$', '.\n\n', gg)
      cat(gg, sep = '', file = zz)
      if (any(dat$vDummyImport$value != 0)) {
        dcmd <- unique(dat$vDummyImport[dat$vDummyImport$value != 0, 'comm']) 
        cat('\\section{Dummy import}\n\n', '\n', sep = '', file = zz)
        cat('There are dummy import for commodity "', 
            paste(dcmd, collapse = '", "'), '".\n\n', '\n', sep = '', file = zz)
        for(cc in dcmd) {
          cat('\\subsection{', cc, '}\n\n', '\n', sep = '', file = zz)
          png2(paste(cc, '_dummy_out.png', sep = ''))
          dd <- dat$vDummyImport[dat$vDummyImport$comm == cc,, drop = FALSE]
          if (nrow(dd) == 1) {
            plot(dd$year + c(-.5, .5), rep(dd$value, 2), main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
          } else {
            plot(dd$year, dd$value, main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
          }
          dev.off2()
          cat('\\begin{figure}[H]\n', sep = '', file = zz)
          cat('  \\centering\n', sep = '', file = zz)
          cat('  \\includegraphics[width = 7in]{', cc, 
              '_dummy_out.png}\n', sep = '', file = zz)
          cat('  \\caption{Dummy import commodity ', gsub('_', '\\\\_', cc), 
              ', summary for all region and slice.}\n', sep = '', file = zz)
          cat('\\end{figure}\n', sep = '', file = zz)
        }
      }
      if (any(dat$vDummyExport$value != 0)) {
        dcmd <- dimnames(obj@modOut@data$vDummyExport)[[1]][apply(obj@modOut@data$vDummyExport != 0, 1, any)]
        cat('\\section{Dummy import}\n\n', '\n', sep = '', file = zz)
        cat('There are dummy import for commodity "', 
            paste(dcmd, collapse = '", "'), '".\n\n', '\n', sep = '', file = zz)
        for(cc in dcmd) {
          cat('\\subsection{', cc, '}\n\n', '\n', sep = '', file = zz)
          png2(paste(cc, '_dummy_inp.png', sep = ''))
          dd <- dat$vDummyExport[dat$vDummyExport$comm == cc,, drop = FALSE]
          if (nrow(dd) == 1) {
            plot(dd$year + c(-.5, .5), rep(dd$value, 2), main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
          } else {
            plot(dd$year, dd$value, main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
          }
          dev.off2()
          cat('\\begin{figure}[H]\n', sep = '', file = zz)
          cat('  \\centering\n', sep = '', file = zz)
          cat('  \\includegraphics[width = 7in]{', cc, 
              '_dummy_inp.png}\n', sep = '', file = zz)
          cat('  \\caption{Dummy import commodity ', gsub('_', '\\\\_', cc), 
              ', summary for all region and slice.}\n', sep = '', file = zz)
          cat('\\end{figure}\n', sep = '', file = zz)
        }
      }
      cat('\\tableofcontents\n\n', '\n', sep = '', file = zz)
      
      cat('\\section{Cost analysis}\n\n', '\n', sep = '', file = zz)
      # Cost data
      cst_list <- list(Subsidy = 'vSubsCost', Trade = 'vTradeCost', Supply = 'vSupCost', Techology = c('vTechOMCost', 'vTechInv'), 
                    Tax = 'vTaxCost', Storage = 'vStorageCost', Dummy = 'vDummyCost', SalvageTechology = 'vTechSalv')
      cost <- array(0, dim = c(length(cst_list), length(mid_year)), dimnames = list(names(cst_list), mid_year))
      for (i in names(cst_list)) {
        for (j in cst_list[[i]]) {
          if (any(colnames(dat[[j]]) == 'year')) dd <- tapply(dat[[j]]$value, dat[[j]]$year  , sum) else {
            dd <- sum(dat[[j]]$value)
            names(dd) <- mid_year[length(mid_year)]
          }
          dd[is.na(dd)] <- 0
          if (length(dd) > 0) cost[i, names(dd)] <- cost[i, names(dd)] + dd
        }
      }
      if (any(cost != 0)) {
        png2(paste('undiscount_cost.png', sep = ''), width = 640)
        layout(matrix(1:2, 1), width = c(.75, .25))
        par(mar = c(5, 4, 4, 0) + .1)
        g1 <- cost; g1[g1 < 0] <- 0
        g2 <- (-cost); g2[g2 < 0] <- 0
        cll <- c('cyan4', 'gray56', 'darkorchid1', 'cornflowerblue', 'black', 'wheat3', 'red', 'yellow4')
        barplot(rbind(-colSums(g2), g2, g1), col = c('white', cll, cll), main = '', xlab = '', ylab = '')
        par(mar = c(5, 0, 4, 0) + .1)
        plot.new()
        ff <- apply(cost != 0, 1, any)
        legend('center', legend = rev(rownames(cost)[ff]), fill = rev(cll[ff]), bty = 'n')
        dev.off2()
        cat('\\begin{figure}[H]\n', sep = '', file = zz)
        cat('  \\centering\n', sep = '', file = zz)
        cat('  \\includegraphics[width = 7in]{undiscount_cost.png}\n', sep = '', file = zz)
        cat('  \\caption{Undiscount cost.}\n', sep = '', file = zz)
        cat('\\end{figure}\n', sep = '', file = zz)
        tbl <- as.data.frame(t(cost))
        tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
        energyRt:::.cat_bottomup_data_frame(tbl, 'Raw cost data', zz)
      }
      # Discount cost data
      dsc <- getParameterData(obj@modInp@parameters$pDiscountFactor)
      dsc[, 'mid'] <- NA
      mlst <- getMilestone(obj)
      for(i in seq(length.out = nrow(mlst))) {
        dsc[mlst$start[i] <= dsc$year & dsc$year <= mlst$end[i], 'mid'] <- mlst$mid[i]
      }
      dsc$year <- dsc$mid
      dsc[, 'region'] <- factor(dsc[, 'region'], levels = region)
      dsc[, 'year'] <- factor(dsc[, 'year'], levels = mid_year)
      dsc <- tapply(dsc$value, dsc[, c('region', 'year'), drop = FALSE], sum)
      # Discount for region
      dsccost <- array(0, dim = c(length(cst_list), length(mid_year)), dimnames = list(names(cst_list), mid_year))
      for (i in names(cst_list)) {
        for (j in cst_list[[i]]) {
          if (any(colnames(dat[[j]]) == 'year')) {
            dd <- tapply(dat[[j]]$value, dat[[j]][, c('region', 'year')], sum) * dsc
            dd <- colSums(dd, na.rm = TRUE)
          } else {
            dd <- sum(tapply(dat[[j]]$value, dat[[j]]$region, sum) * dsc[, ncol(dsc)], na.rm = TRUE)
            names(dd) <- mid_year[length(mid_year)]
          }
          if (length(dd) > 0) dsccost[i, names(dd)] <- dsccost[i, names(dd)] + dd
        }
      }
      if (any(dsccost != 0)) {
        png2(paste('discount_cost.png', sep = ''), width = 640)
        layout(matrix(1:2, 1), width = c(.75, .25))
        par(mar = c(5, 4, 4, 0) + .1)
        g1 <- dsccost; g1[g1 < 0] <- 0
        g2 <- (-dsccost); g2[g2 < 0] <- 0
        cll <- c('cyan4', 'gray56', 'darkorchid1', 'cornflowerblue', 'black', 'wheat3', 'red', 'yellow4')
        barplot(rbind(-colSums(g2), g2, g1), col = c('white', cll, cll), main = '', xlab = '', ylab = '')
        par(mar = c(5, 0, 4, 0) + .1)
        plot.new()
        ff <- apply(dsccost != 0, 1, any)
        legend('center', legend = rev(rownames(dsccost)[ff]), fill = rev(cll[ff]), bty = 'n')
        dev.off2()
        cat('\\begin{figure}[H]\n', sep = '', file = zz)
        cat('  \\centering\n', sep = '', file = zz)
        cat('  \\includegraphics[width = 7in]{discount_cost.png}\n', sep = '', file = zz)
        cat('  \\caption{Discount cost.}\n', sep = '', file = zz)
        cat('\\end{figure}\n', sep = '', file = zz)
      }
      if (any(dsccost != 0)) {
        tbl <- as.data.frame(t(dsccost))
        tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
        energyRt:::.cat_bottomup_data_frame(tbl, 'Raw cost data', zz)
      }       
     ## Commodity
      if (length(dtt$commodity) != 0) {
        FL <- array(NA, dim = length(dtt$commodity), dimnames = list((names(dtt$commodity))))
        cat('\\section{Commodity analysis}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$commodity)) {
          cmd <- dtt$commodity[[cc]]
          cc <- cmd@name
          cc <- (cc)
          cmd_tmp_func <- function(x, y) {
            fl <- (x$comm == y)
            tapply(x$value[fl], x$year[fl], sum)
          }
          trd <- obj@modInp@parameters$mTradeComm@data[obj@modInp@parameters$mTradeComm@data$comm == cc, ]$trade
          fl <- (dat$vTradeIr$trade %in% trd)
          trd <- tapply(dat$vTradeIr$value[fl], dat$vTradeIr$year[fl], sum);
          trd[is.na(trd)] <- 0
          cmd_use <- rbind(
            input = cmd_tmp_func(dat$vInpTot, cc) - trd, 
            output = cmd_tmp_func(dat$vOutTot, cc) - trd, 
            technologyInput = cmd_tmp_func(dat$vTechInpTot, cc), 
            technologyOutput = cmd_tmp_func(dat$vTechOutTot, cc),
            emission = cmd_tmp_func(dat$vEmsFuelTot, cc),
            aggregate = cmd_tmp_func(dat$vAggOut, cc),
            demand = cmd_tmp_func(dat$vDemInp, cc),
            dummyImport = cmd_tmp_func(dat$vDummyImport, cc),
            dummyExport = cmd_tmp_func(dat$vDummyExport, cc),
            supply = cmd_tmp_func(dat$vSupOutTot, cc),
            import = cmd_tmp_func(dat$vImport, cc) - trd,
            export = cmd_tmp_func(dat$vExport, cc) - trd
          )
          cmd_use[is.na(cmd_use)] <- 0
          fl <- any(cmd_use != 0)
          png2(paste(cmd@name, '_supply.png', sep = ''), width = 640)       
          SP <- plot(obj@model, type = 'supply', commodity = cmd@name, main = '', 
                     ylim2 = range(cmd_use['supply', ]))
          lines(colnames(cmd_use), cmd_use['supply', ], lwd = 2, col = 'cyan4')
          fl <- fl || any(SP != 0)
          dev.off2()
          png2(paste(cmd@name, '_export.png', sep = ''), width = 640)
          EXP <- plot(obj@model, type = 'export', commodity = cmd@name, main = '',
                      ylim2 = range(cmd_use['export', ]))
          lines(colnames(cmd_use), cmd_use['export', ], lwd = 2, col = 'cyan4')
          fl <- fl || any(EXP != 0)
          dev.off2()
          png2(paste(cmd@name, '_import.png', sep = ''), width = 640)
          IMP <- plot(obj@model, type = 'import', commodity = cmd@name, main = '',
                      ylim2 = range(cmd_use['import', ]))
          lines(colnames(cmd_use), cmd_use['import', ], lwd = 2, col = 'cyan4')
          fl <- fl || any(IMP != 0)
          dev.off2()
          if (fl) {
            cat('\\subsection{', gsub('_', '\\\\_', cmd@name), '}\n\n', '\n', sep = '', file = zz) 
            cmd_use2 <- cmd_use[apply(cmd_use != 0, 1, any), , drop = FALSE]
            if (nrow(cmd_use2) > 0) {
              # Balance commodity
              if (any(abs(cmd_use['output', ] - cmd_use['input', ]) > 1e-6)) {
                png2(paste(cmd@name, '_surplus.png', sep = ''), width = 640)
                plot(colnames(cmd_use), cmd_use['output', ] - cmd_use['input', ], 
                     main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
                dev.off2()
                cat('\\begin{figure}[H]\n', sep = '', file = zz)
                cat('  \\centering\n', sep = '', file = zz)
                cat('  \\includegraphics[width = 7in]{', cc, 
                    '_surplus.png}\n', sep = '', file = zz)
                cat('  \\caption{Surplus commodity ', gsub('_', '\\\\_', cc), 
                    ', summary for all region and slice.}\n', sep = '', file = zz)
                cat('\\end{figure}\n', sep = '', file = zz)
              }
              # Commodity source
              cmd_src <- cmd_use[c('technologyOutput', 'supply', 'emission', 'aggregate', 
                                   'dummyImport', 'import'),, drop = FALSE]
              if (any(cmd_src != 0)) {
                # Source
                png2(paste(cmd@name, '_source.png', sep = ''), width = 640)
                layout(matrix(1:2, 1), width = c(.75, .25))
                par(mar = c(5, 4, 4, 0) + .1)
                plot(colnames(cmd_src), colnames(cmd_src), ylim = range(c(0, range(cmd_src))),
                     main = '', xlab = '', ylab = '', type = 'n', lwd = 2)
                yy <- (1:nrow(cmd_src))[apply(cmd_src != 0, 1, any)]
                for(i in yy) {
                  lines(colnames(cmd_src), cmd_src[i, ], lwd = 2, col = i)
                }
                par(mar = c(5, 0, 4, 0) + .1)
                plot.new()
                legend('center', legend = c('Technology', 'Supply', 'Emission', 'Aggregate', 
                                            'Dummy Import', 'Import')[yy], col = yy, lwd = 2, bty = 'n')
                dev.off2()
                cat('\\begin{figure}[H]\n', sep = '', file = zz)
                cat('  \\centering\n', sep = '', file = zz)
                cat('  \\includegraphics[width = 7in]{', cc, 
                    '_source.png}\n', sep = '', file = zz)
                cat('  \\caption{Source commodity ', gsub('_', '\\\\_', cc), 
                    ', summary for all region and slice.}\n', sep = '', file = zz)
                cat('\\end{figure}\n', sep = '', file = zz)
                # Supply
                if (any(SP != 0)) {
                  cat('\\begin{figure}[H]\n', sep = '', file = zz)
                  cat('  \\centering\n', sep = '', file = zz)
                  cat('  \\includegraphics[width = 7in]{', cc, 
                      '_supply.png}\n', sep = '', file = zz)
                  cat('  \\caption{Supply commodity ', gsub('_', '\\\\_', cc), 
                      ', summary for all region and slice.}\n', sep = '', file = zz)
                  cat('\\end{figure}\n', sep = '', file = zz)
                }
                # Import
                if (any(IMP != 0)) {
                  cat('\\begin{figure}[H]\n', sep = '', file = zz)
                  cat('  \\centering\n', sep = '', file = zz)
                  cat('  \\includegraphics[width = 7in]{', cc, 
                      '_import.png}\n', sep = '', file = zz)
                  cat('  \\caption{Import commodity ', gsub('_', '\\\\_', cc), 
                      ', summary for all region and slice.}\n', sep = '', file = zz)
                  cat('\\end{figure}\n', sep = '', file = zz)
                }
                # Aggregate commodity
                if (nrow(cmd@agg) > 0) {
                  gtg <- (dat$vOutTot$comm %in% cmd@agg$comm)
                  ag <- tapply(dat$vOutTot$value[gtg], dat$vOutTot[gtg, c('comm', 'year'), drop = FALSE], sum)
                  for(i in 1:nrow(ag)) {
                    ag[i, ] <- cmd@agg$agg[i] * ag[i, ]
                  }
                  png2(paste(cmd@name, '_aggregate.png', sep = ''), width = 640)
                  layout(matrix(1:2, 1), width = c(.75, .25))
                  par(mar = c(5, 4, 4, 0) + .1)
                  plot(colnames(ag), colSums(ag), ylim = range(c(0, range(ag))),
                       main = '', xlab = '', ylab = '', type = 'n')
                  yy <- (1:nrow(ag))#[apply(ag != 0, 1, any)]
                  for(i in yy) {
                    lines(colnames(ag), ag[i, ], lwd = 2, col = 1 + i)
                  }
                  lines(colnames(ag), colSums(ag), lwd = 2, lty = 2)
                  par(mar = c(5, 0, 4, 0) + .1)
                  plot.new()
                  legend('center', legend = c(cc, rownames(ag)[yy]), 
                         col = c(1, 1 + yy), lwd = 2, bty = 'n')
                  dev.off2()
                  cat('\\begin{figure}[H]\n', sep = '', file = zz)
                  cat('  \\centering\n', sep = '', file = zz)
                  cat('  \\includegraphics[width = 7in]{', cc, 
                      '_aggregate.png}\n', sep = '', file = zz)
                  cat('  \\caption{Aggregate commodity source ', gsub('_', '\\\\_', cc), 
                      ', summary for all region and slice.}\n', sep = '', file = zz)
                  cat('\\end{figure}\n', sep = '', file = zz)
                }
              }
             # Commodity demand
              cmd_dem <- cmd_use[c('technologyInput', 'demand', 'export', 'dummyExport'),, drop = FALSE]
              if (any(cmd_dem != 0)) {
                # Demand
                png2(paste(cmd@name, '_demand.png', sep = ''), width = 640)
                layout(matrix(1:2, 1), width = c(.75, .25))
                par(mar = c(5, 4, 4, 0) + .1)
                plot(colnames(cmd_dem), colnames(cmd_dem), ylim = range(c(0, range(cmd_dem))),
                     main = '', xlab = '', ylab = '', type = 'n', lwd = 2)
                yy <- (1:nrow(cmd_dem))[apply(cmd_dem != 0, 1, any)]
                for(i in yy) {
                  lines(colnames(cmd_dem), cmd_dem[i, ], lwd = 2, col = i)
                }
                par(mar = c(5, 0, 4, 0) + .1)
                plot.new()
                legend('center', legend = c('Technology', 'Demand', 'Export', 'Dummy Export')[yy], 
                                 col = yy, lwd = 2, bty = 'n')
                dev.off2()
                cat('\\begin{figure}[H]\n', sep = '', file = zz)
                cat('  \\centering\n', sep = '', file = zz)
                cat('  \\includegraphics[width = 7in]{', cc, 
                    '_demand.png}\n', sep = '', file = zz)
                cat('  \\caption{Demand commodity ', gsub('_', '\\\\_', cc), 
                    ', summary for all region and slice.}\n', sep = '', file = zz)
                cat('\\end{figure}\n', sep = '', file = zz)
                # Export
                if (any(EXP != 0)) {
                  cat('\\begin{figure}[H]\n', sep = '', file = zz)
                  cat('  \\centering\n', sep = '', file = zz)
                  cat('  \\includegraphics[width = 7in]{', cc, 
                      '_export.png}\n', sep = '', file = zz)
                  cat('  \\caption{Export commodity ', gsub('_', '\\\\_', cc), 
                      ', summary for all region and slice.}\n', sep = '', file = zz)
                  cat('\\end{figure}\n', sep = '', file = zz)
                }
              }
              
            }
            if (any(cmd_use != 0)) {
              gg <- cmd_use
              rownames(gg)[3] <- 'input$^{technology}$'
              rownames(gg)[4] <- 'output$^{technology}$'
              gg <- as.data.frame(t(gg[,apply(gg != 0, 2, any), drop = FALSE]))
              gg$surplus <- gg$output - gg$input
              gg <- gg[, sapply(gg, function(x) any(x != 0)), drop = FALSE]
              energyRt:::.cat_bottomup_data_frame(gg, 'Raw data', zz)
            }
          }
           
          if (length(fl) != 1) stop()
          if (length(cc) != 1) stop()
          FL[cc] <- !fl
        }
        if (any(FL)) {
          cat('\\subsection{Commodity without additional information}\n\n', '\n', sep = '', file = zz)
          cat(#'Commodity without additional information:\n\n', 
            paste(gsub('_', '\\\\_', names(dtt$commodity)[FL]), collapse = ', '), 
            '.\n\n', '\n', sep = '', file = zz)
        }
      }    
      ## Technology
      if (length(dtt$technology) != 0) {
        stock <- obj@modInp@parameters$pTechStock@data
        FL <- array(NA, dim = length(dtt$technology), dimnames = list(names(dtt$technology)))
        cat('\\section{Technology analysis}\n\n', '\n', sep = '', file = zz)
        for(tt in names(dtt$technology)) {
          tec <- dtt$technology[[tt]]
          tt <- tec@name
          #tt <- toupper(tt)
          tec_tmp_func <- function(x, y, z = c('comm', 'year')) {
            fl <- (x$tech == y)
            nn <- tapply(x$value[fl], x[fl, z], sum)
            nn[is.na(nn)] <- 0
            nn
          }
          tec_input <- tec_tmp_func(rbind(dat$vTechInp, dat$vTechAInp), tt)
          tec_output <- tec_tmp_func(rbind(dat$vTechOut, dat$vTechAOut), tt)  
          tec_emission <- tec_tmp_func(dat$vTechEmsFuel, tt)
          gg <- stock[!is.na(stock$tech) & stock$tech == tt & stock$year %in% mlst$mid, ]
          gg$year <- factor(gg$year, levels = mid_year)
          yyy <- tapply(gg$value, gg$year, sum)
          yyy[is.na(yyy)] <- 0
          tec_cap <- rbind(
            'Total capacity' = tec_tmp_func(dat$vTechCap, tt, 'year'),
            'New capacity' = tec_tmp_func(dat$vTechNewCap, tt, 'year'),
            'Initial stock' = yyy,
            'Activity' = tec_tmp_func(dat$vTechAct, tt, 'year') 
          )
          
          tec_cost <- rbind(
            salvage = c(rep(0, length(mid_year) - 1), sum(dat$vTechSalv[dat$vTechSalv$tech == tt, 'value'])),
            investment = tec_tmp_func(dat$vTechInv, tt, 'year'),
            'OM cost' = tec_tmp_func(dat$vTechOMCost, tt, 'year')
          )
         # tec_cost['OM cost', ] <- tec_cost['OM cost', ] - tec_cost['investment', ]
          barcap <- rbind(new = tec_cap['New capacity', ], 
                          rest = tec_cap['Total capacity', ] - tec_cap['Initial stock', ] 
                            - tec_cap['New capacity', ], 
                          stock = tec_cap['Initial stock', ])
          
          f1 <- any(tec_input != 0) || any(tec_output != 0) || any(tec_emission != 0) 
          f2 <- any(barcap != 0)
          FL[tt] <- !(f1 || f2)
          if (!FL[tt]) {
            cat('\\subsection{', gsub('_', '\\\\_', tec@name), '}\n\n', '\n', sep = '', file = zz) 
          }
          if (f1) {
            # Input/Output/Emission
            png2(paste(tt, '_flow.png', sep = ''), width = 640)
            layout(matrix(1:2, 1), width = c(.75, .25))
            par(mar = c(5, 4, 4, 0) + .1)
            plot(colnames(tec_input), colnames(tec_input), 
                 ylim = range(c(0, tec_input, tec_output, tec_emission)),
                 main = '', xlab = '', ylab = '', type = 'n', lwd = 2)
            for(i in seq(length.out = nrow(tec_input))) {
              lines(colnames(tec_input)[tec_input[i, ] != 0], 
                    tec_input[i, tec_input[i, ] != 0], lwd = 2, col = i)
            }
            for(i in seq(length.out = nrow(tec_output))) {
              lines(colnames(tec_output)[tec_output[i, ] != 0], 
                    tec_output[i, tec_output[i, ] != 0], lwd = 2, 
                    col = nrow(tec_input) + i, lty = 2)
            }
            for(i in seq(length.out = nrow(tec_emission))) {
              lines(colnames(tec_emission)[tec_emission[i, ] != 0], 
                    tec_emission[i, tec_emission[i, ] != 0], lwd = 2, 
                    col = nrow(tec_output) + nrow(tec_input) + i, lty = 3)
            }
            par(mar = c(5, 0, 4, 0) + .1)
            plot.new()
            lg_tex <- c()
            lg_col <- c()
            lg_lty <- c()
            if (nrow(tec_input) != 0) {
              lg_tex <- c(lg_tex, 'Input', rownames(tec_input))
              lg_col <- c(lg_col, 0, max(c(0, lg_col)) + 1:nrow(tec_input))
              lg_lty <- c(lg_lty, 0, rep(1, nrow(tec_input)))
            }
            if (nrow(tec_output) != 0) {
              lg_tex <- c(lg_tex, 'Output', rownames(tec_output))
              lg_col <- c(lg_col, 0, max(c(0, lg_col)) + 1:nrow(tec_output))
              lg_lty <- c(lg_lty, 0, rep(2, nrow(tec_output)))
            }
            if (nrow(tec_emission) != 0) {
              lg_tex <- c(lg_tex, 'Emission', rownames(tec_emission))
              lg_col <- c(lg_col, 0, max(c(0, lg_col)) + 1:nrow(tec_emission))
              lg_lty <- c(lg_lty, 0, rep(3, nrow(tec_emission)))
            }
            legend('center', legend = lg_tex, col = lg_col, lwd = 2, bty = 'n', lty = lg_lty)
            dev.off2()
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 7in]{', tt, 
                '_flow.png}\n', sep = '', file = zz)
            cat('  \\caption{Commodity flow technology ', gsub('_', '\\\\_', tt), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
          }
          # Capacity data
          if (f2) {
            # Capacity data
            png2(paste(tt, '_capacity.png', sep = ''), width = 640)
            layout(matrix(1:2, 1), width = c(.75, .25))
            par(mar = c(5, 4, 4, 0) + .1)
            barplot(barcap, main = '', xlab = '', ylab = '', 
                    col = c('cyan4', 'gray56', 'darkorchid1'))
            par(mar = c(5, 0, 4, 0) + .1)
            plot.new()
            legend('center', legend = rev(rownames(barcap)), 
                   fill = rev(c('cyan4', 'gray56', 'darkorchid1')), bty = 'n')
            dev.off2()
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 7in]{', tt, 
                '_capacity.png}\n', sep = '', file = zz)
            cat('  \\caption{Capacity technology ', gsub('_', '\\\\_', tt), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)        
            # Activity check      
            png2(paste(tt, '_activity.png', sep = ''), width = 640)
            layout(matrix(1:2, 1))
            par(mar = c(5, 4, 4, 2) + .1)
            ff <- tec_cap['Total capacity', ] != 0
            plot(colnames(tec_cap)[ff], tec_cap['Activity', ff], 
                 ylim = range(c(0, tec_cap['Activity', ff])),
                 main = 'Activity', xlab = '', ylab = '', type = 'l', lwd = 2)
            plot(colnames(tec_cap)[ff], tec_cap['Activity', ff] / tec_cap['Total capacity', ff], 
                 ylim = range(c(0, tec_cap['Activity', ff] / tec_cap['Total capacity', ff])),
                 main = 'Activity/Capacity ratio ', xlab = '', ylab = '', type = 'l', lwd = 2)
            dev.off2()
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 7in]{', tt, 
                '_activity.png}\n', sep = '', file = zz)
            cat('  \\caption{Activity technology ', gsub('_', '\\\\_', tt), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
            # Cost data
            png2(paste(tt, '_cost.png', sep = ''), width = 640)
            layout(matrix(1:2, 1), width = c(.75, .25))
            par(mar = c(5, 4, 4, 0) + .1)
            gg <- rbind(dm = tec_cost['salvage', ], tec_cost)
            gg['salvage', ] <- (-gg['salvage', ])
            barplot(gg, main = '', xlab = '', ylab = '', 
                    col = c('white', 'cyan4', 'gray56', 'darkorchid1'))
            par(mar = c(5, 0, 4, 0) + .1)
            plot.new()
            legend('center', legend = rev(rownames(tec_cost)), 
                   fill = rev(c('cyan4', 'gray56', 'darkorchid1')), bty = 'n')
            dev.off2()
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 7in]{', tt, 
                '_cost.png}\n', sep = '', file = zz)
            cat('  \\caption{Cost technology ', gsub('_', '\\\\_', tt), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)        
          }
          # Raw flow data
          if (f1) {
            # Raw data
            t1 <- as.data.frame(t(tec_input))
            if (ncol(t1) > 0)
              colnames(t1) <- paste('$', colnames(t1), '^{input}$', sep = '')
            t2 <- as.data.frame(t(tec_output))
            if (ncol(t2) > 0)
              colnames(t2) <- paste('$', colnames(t2), '^{output}$', sep = '')
            t3 <- as.data.frame(t(tec_emission))
            if (ncol(t3) > 0)
              colnames(t3) <- paste('$', colnames(t3), '^{emission}$', sep = '')
            tbl <- cbind(t1, t2, t3)
            tbl <- tbl[apply(tbl != 0, 1, any),,drop = FALSE]
            # Table
            energyRt:::.cat_bottomup_data_frame(tbl, 'Raw data input/output', zz, 5)
          }
          # Raw capacity data
          if (f2) {
            tbl <- as.data.frame(t(tec_cap))
            tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
            energyRt:::.cat_bottomup_data_frame(tbl, 'Raw capacity data', zz)
            if (any(tec_cost != 0)) {
              tbl <- as.data.frame(t(tec_cost))
              tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
              energyRt:::.cat_bottomup_data_frame(tbl, 'Raw capacity data', zz)
            }
          }
        }  
        if (any(FL)) {
          cat('\\subsection{Technology without information (unused)}\n\n', '\n', sep = '', file = zz)
          cat(#'Technology without additional information:\n\n', 
            paste(gsub('_', '\\\\_', names(dtt$technology)[FL]), collapse = ', '), 
            '.\n\n', '\n', sep = '', file = zz)
        }
      }
  cat('Supply\n')
    ##########!!
      ## Supply
      if (length(dtt$supply) != 0) {
        cat('\\section{Supply}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$supply)) {
          cat('.')
          sup <- dtt$supply[[cc]]
          png2(paste('supply_wrk_', sup@name, '.png', sep = ''))
          sup_tmp_func <- function(x, y, z = NULL) {
            if (!is.null(z)) fl <- (x$sup == y & x$comm == z) else fl <- (x$sup == y)
            nn <- tapply(x$value[fl], x[fl, 'year', drop = FALSE], sum)
            nn[is.na(nn)] <- 0
            nn
          }
          sup_out <- sup_tmp_func(dat$vSupOut, cc, sup@commodity)
          sup_cst <- sup_tmp_func(dat$vSupOut, cc)
          
          SP <- plot(obj@model, type = 'supply', commodity = sup@commodity, 
            main = '', supply = cc, ylim_min = max(sup_out), year = mlst$mid)
          lines(names(sup_out), sup_out, col = 'cyan4', lwd = 2)
          dev.off2()
            bnd.on <- rep('free', nrow(SP)) 
            bnd.on[sup_out == SP[, 'lo']] <- 'lo'
            bnd.on[sup_out == SP[, 'up']] <- 'up'
            bnd.on[sup_out == SP[, 'lo'] & bnd.on == SP[, 'up']] <- 'both'
            cat('\\subsection{', gsub('_', '\\\\_', sup@name), '}\n\n', '\n', sep = '', file = zz) 
            sup_dt <- data.frame(ava.lo = SP[, 'lo'], ava.up = SP[, 'up'], out = sup_out, 
            cost = sup_cst, row.names = dimnames(SP)[[1]], boun.on = bnd.on)
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 6in]{supply_wrk_', 
                sup@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Supply ', gsub('_', '\\\\_', cc), ', for commodity ', 
                gsub('_', '\\\\_', sup@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
            energyRt:::.cat_bottomup_data_frame(sup_dt, paste('Supply ', gsub('_', '\\\\_', cc), 
            ', for commodity ', gsub('_', '\\\\_', sup@commodity), '.', sep = ''), zz)
            # Calculate resrerve for sum of regions
            get.all.sup.reserve <- function(obj, sup) {
              res_sup <- obj@modInp@parameters$pSupReserve@data[obj@modInp@parameters$pSupReserve@data$sup == sup@name, ]
              def <- obj@modInp@parameters$pSupReserve@defVal
              if (is.null(sup@region)) {
                reg_sup <- obj@model@sysInfo@region
              } else {
                reg_sup <-sup@region
              }
              res_sup.lo <- res_sup[res_sup$type == 'lo', ]
              if (nrow(res_sup.lo) != length(reg_sup)) {
                lo <- sum(c(rep(def[1], length(reg_sup) - nrow(res_sup.lo)), res_sup.lo$value))
              } else lo <- sum(res_sup.lo$value)
              res_sup.up <- res_sup[res_sup$type == 'up', ]
              if (nrow(res_sup.up) != length(reg_sup)) {
                up <- sum(c(rep(def[2], length(reg_sup) - nrow(res_sup.up)), res_sup.up$value))
              } else up <- sum(res_sup.up$value)
              c(lo = lo, up = up)
            }
            sup.lim <- get.all.sup.reserve(obj, sup)
            cat('\n\n Total reserve: (', format(sup.lim['lo'], digits = 4), ', ', format(sup.lim['up'], digits = 4), 
              '), total extract: ', sum(sup_out), '.\n\n', sep = '', file = zz)
          }  
          cat('\n\n', '\n', sep = '', file = zz) 
#        }
      }   

      ## Trade
  cat('Trade\n')
  if (length(dtt$trade) != 0) {
        #stock <- obj@modInp@parameters$pTechStock@data
        #FL <- array(NA, dim = length(dtt$technology), dimnames = list(names(dtt$technology)))
        cat('\\section{Trade analysis}\n\n', '\n', sep = '', file = zz)
        grep('Trade', names(obj@modInp@parameters), value = TRUE)
        trd_src <- getParameterData(obj@modInp@parameters$mTradeSrc)
        trd_dst <- getParameterData(obj@modInp@parameters$mTradeDst)
        for(nm in names(dtt$trade)) {
          trd <- dtt$trade[[nm]]
          cat('\\subsection{', nm, '}\n\n', '\n', sep = '', file = zz)
            cat('\n\n Commodity: "', trd@commodity, '"\n\n', sep = '', file = zz)
            src <- trd_src[trd_src$trade == nm, 'region']
            if (length(src) == 0) cat('\n\n Warning: There is not source region.\n\n', sep = '', file = zz) else
              cat('Source regions: "',paste(src, collapse = '", "') , '"\n\n', sep = '', file = zz)
            dst <- trd_dst[trd_dst$trade == nm, 'region']
            if (length(trd) == 0) cat('\n\n Warning: There is not destination region.\n\n', sep = '', file = zz) else
              cat('Destination regions: "',paste(dst, collapse = '", "') , '"\n\n', sep = '', file = zz)
            trd_tmp_func <- function(x, y, z) {
              fl <- (x$trade == y)
              nn <- tapply(x$value[fl], x[fl, z], sum)
              nn[is.na(nn)] <- 0
              nn
            }
            if (any(dat$vTradeIr$trade == nm)) { 
              # Source flow
              sflow <- trd_tmp_func(dat$vTradeIr, nm, c("src", "year"))
              sflow <- sflow[apply(sflow != 0, 1, any),, drop = FALSE]
              png2(paste('trade_src_', trd@name, '.png', sep = ''))
              layout(matrix(1:2, 1), width = c(.75, .25))
              par(mar = c(5, 4, 4, 0) + .1)
              barplot(sflow, col = 1:nrow(sflow), main = '', xlab = '', ylab = '')
              par(mar = c(5, 0, 4, 0) + .1)
              plot.new()
              legend('center', legend = rev(rownames(sflow)), fill = rev(nrow(sflow)), bty = 'n')
              dev.off2()
              sflow <- sflow <- trd_tmp_func(dat$vTradeIr, nm, c("dst", "year")) 
              sflow <- sflow[apply(sflow != 0, 1, any),, drop = FALSE]
              png2(paste('trade_dst_', trd@name, '.png', sep = ''))
              layout(matrix(1:2, 1), width = c(.75, .25))
              par(mar = c(5, 4, 4, 0) + .1)
              barplot(sflow, col = 1:nrow(sflow), main = '', xlab = '', ylab = '')
              par(mar = c(5, 0, 4, 0) + .1)
              plot.new()
              legend('center', legend = rev(rownames(sflow)), fill = rev(nrow(sflow)), bty = 'n')
              dev.off2()
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{trade_src_', 
                  nm, '.png}\n', sep = '', file = zz)
              cat('  \\caption{Trade by sources region ', gsub('_', '\\\\_', nm), 
                  ', summary for all slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{trade_dst_', 
                  nm, '.png}\n', sep = '', file = zz)
              cat('  \\caption{Trade by destination region ', gsub('_', '\\\\_', nm), 
                  ', summary for all slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
              vv <- dat$vTradeIr[dat$vTradeIr$trade == nm, -1, drop = FALSE]
              vv <- vv[vv$value != 0,, drop = FALSE]
              colnames(vv)[1] <- 'source'
              colnames(vv)[2] <- 'destination'
              colnames(vv)[5] <- 'value'
              energyRt:::.cat_bottomup_data_frame(vv, paste('Trade flow ', 
                gsub('_', '\\\\_', nm), '.', sep = ''), zz)
          }
        }
      }
      cat('\\end{document}\n', sep = '', file = zz)
    }, interrupt = function(x) stop('Was interrupt'), error = function(x) {
      close(zz)
      if (get('setPNGLAST', globalenv())) dev.off2();
      setwd(WDD)
      if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
      stop(x)
    }) 
    close(zz)
    
    if (.Platform$OS.type == "windows") {
      shell('pdflatex energyRtScenarioReport.tex')
      shell('pdflatex energyRtScenarioReport.tex')
      file.copy('energyRtScenarioReport.pdf', paste('../', file.name, sep = ''))
      shell.exec(paste('..\\', file.name, sep = ''))
    } else { 
      system('pdflatex energyRtScenarioReport.tex')
      system('pdflatex energyRtScenarioReport.tex')
      file.copy('energyRtScenarioReport.pdf', paste('../', file.name, sep = ''))
      system(paste('open ../', file.name, sep = ''))
    }
    setwd(WDD)
    if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
  }, interrupt = function(x) stop('Was interrupted'), error = function(x) {
    setwd(WDD)
    if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
    stop(x)
  }) 
  if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
  setwd(WDD)
}

