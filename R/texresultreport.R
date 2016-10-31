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
  png2 <- function(...) {assign('setPNGLAST', TRUE, globalenv()); png(...);}
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
    for(i in seq(along = obj@model@data)) {
      for(j in seq(along = obj@model@data[[i]]@data)) {
        obj@model@data[[i]]@data[[j]]@name <- obj@model@data[[i]]@data[[j]]@name
        dtt[[class(obj@model@data[[i]]@data[[j]])]][[obj@model@data[[i]]@data[[j]]@name]] <-
          obj@model@data[[i]]@data[[j]]
      }
    }
    for(i in names(dtt)) if (length(dtt[[i]]) != 0) dtt[[i]] <- dtt[[i]][sort(names(dtt[[i]]))]
    set <- obj@result@set
    dat <- obj@result@data
    
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
      
      if (obj@result@solution_report$finish != 2) {
        cat('The model run is not completed. The results are not "optimal solution".\n\n', '\n', 
          sep = '', file = zz)
      }
      if (obj@result@solution_report$status == 1) {
        cat('Optimal solution found, objective value ', obj@result@data$vObjective, 
            '.\n\n', '\n', sep = '', file = zz)
      } else {
        cat('The model run is not completed. Exit code ', obj@result@solution_report$status, 
            '.\n\n', '\n', sep = '', file = zz)
      }
      gg <- paste('There is ', length(obj@model@data), ' repositary, ', sep = '')
      for(i in names(dtt)) {
        if (length(dtt[[i]]) != 0)
          gg <- paste(gg, length(dtt[[i]]), ' ', i, ', ', sep = '')
      }
      gg <- sub('[,][ ]$', '.\n\n', gg)
      cat(gg, sep = '', file = zz)
      if (any(obj@result@data$vDumOut != 0)) {
        dcmd <- dimnames(obj@result@data$vDumOut)[[1]][apply(obj@result@data$vDumOut != 0, 1, any)]
        cat('\\section{Dummy import}\n\n', '\n', sep = '', file = zz)
        cat('There are dummy import for commodity "', 
            paste(dcmd, collapse = '", "'), '".\n\n', '\n', sep = '', file = zz)
        for(cc in dcmd) {
          cat('\\subsection{', cc, '}\n\n', '\n', sep = '', file = zz)
          png2(paste(cc, '_dummy.png', sep = ''))
          plot(dimnames(dat$vDumOut)$year, apply(dat$vDumOut[cc,,,, drop = FALSE], 3, sum), 
               main = '', xlab = '', ylab = '', type = 'l', lwd = 2)
          dev.off2()
          cat('\\begin{figure}[H]\n', sep = '', file = zz)
          cat('  \\centering\n', sep = '', file = zz)
          cat('  \\includegraphics[width = 7in]{', cc, 
              '_dummy.png}\n', sep = '', file = zz)
          cat('  \\caption{Dummy import commodity ', gsub('_', '\\\\_', cc), 
              ', summary for all region and slice.}\n', sep = '', file = zz)
          cat('\\end{figure}\n', sep = '', file = zz)
        }
      }
      cat('\\tableofcontents\n\n', '\n', sep = '', file = zz)
      
      cat('\\section{Cost analysis}\n\n', '\n', sep = '', file = zz)
      
      # Cost data
      cost <- rbind(
        Subsidy = apply(dat$vSubsCost, 3, sum),
        Trade = apply(dat$vTradeCost, 2, sum),
        Supply = apply(dat$vSupCost, 3, sum),
        Techology = apply(dat$vTechCost, 3, sum),
        Tax = apply(dat$vTaxCost, 3, sum),
        Storage = apply(dat$vStorageCost, 3, sum),
        Dummy = apply(dat$vDumCost, 3, sum),
        SalvageTechology = c(rep(0, dim(dat$vTechCost)[3] - 1), sum(dat$vTechSalv))
     )
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
        cat_bottomup_data_frame(tbl, 'Raw cost data', zz)
      }
      # Discount cost data
      dsc <- obj@precompiled@maptable$pDiscountFactor@data
      dsc <- tapply(dsc$Freq, dsc[, c('region', 'year'), drop = FALSE], sum)
      dsccost <- rbind(
        Subsidy = apply(apply(dat$vSubsCost, 2:3, sum) * dsc, 2, sum),
        Trade = apply(dat$vTradeCost * dsc, 2, sum),
        Supply = apply(apply(dat$vSupCost, 2:3, sum) * dsc, 2, sum),
        Techology = apply(apply(dat$vTechCost, 2:3, sum) * dsc, 2, sum),
        Tax = apply(apply(dat$vTaxCost, 2:3, sum) * dsc, 2, sum),
        Storage = apply(apply(dat$vStorageCost, 2:3, sum) * dsc, 2, sum),
        Dummy = apply(apply(dat$vDumCost, 2:3, sum) * dsc, 2, sum),
        SalvageTechology = c(rep(0, dim(dat$vTechCost)[3] - 1), sum(dat$vTechSalv)) * dsc
      )
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
        cat_bottomup_data_frame(tbl, 'Raw cost data', zz)
      }       
      ## Commodity
      if (length(dtt$commodity) != 0) {
        FL <- array(NA, dim = length(dtt$commodity), dimnames = list((names(dtt$commodity))))
        cat('\\section{Commodity analysis}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$commodity)) {
          cmd <- dtt$commodity[[cc]]
          cc <- cmd@name
          cc <- (cc)
          cmd_use <- rbind(
            input = apply(dat$vInpTot[cc,,,, drop = FALSE], 3, sum), 
            output = apply(dat$vOutTot[cc,,,, drop = FALSE], 3, sum), 
            technologyInput = apply(dat$vTechInpTot[cc,,,, drop = FALSE], 3, sum), 
            technologyOutput = apply(dat$vTechOutTot[cc,,,, drop = FALSE], 3, sum),
            emission = apply(dat$vEmsTot[cc,,,, drop = FALSE], 3, sum),
            aggregate = apply(dat$vAggOut[cc,,,, drop = FALSE], 3, sum),
            demand = apply(dat$vDemInp[cc,,,, drop = FALSE], 3, sum),
            dummy = apply(dat$vDumOut[cc,,,, drop = FALSE], 3, sum),
            supply = apply(dat$vSupOutTot[cc,,,, drop = FALSE], 3, sum),
            import = apply(dat$vImport[cc,,,, drop = FALSE], 3, sum),
            export = apply(dat$vExport[cc,,,, drop = FALSE], 3, sum)
          )
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
                                   'dummy', 'import'),, drop = FALSE]
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
                                            'Dummy', 'Import')[yy], col = yy, lwd = 2, bty = 'n')
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
                  ag <- apply(dat$vOutTot[cmd@agg$comm,,,, drop = FALSE], c(1, 3), sum)
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
              cmd_dem <- cmd_use[c('technologyInput', 'demand', 'export'),, drop = FALSE]
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
                legend('center', legend = c('Technology', 'Demand', 'Export')[yy], col = yy, lwd = 2, bty = 'n')
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
              cat_bottomup_data_frame(gg, 'Raw data', zz)
            }
          }
          
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
        stock <- obj@precompiled@maptable$pTechStock@data
        FL <- array(NA, dim = length(dtt$technology), dimnames = list(names(dtt$technology)))
        cat('\\section{Technology analysis}\n\n', '\n', sep = '', file = zz)
        for(tt in names(dtt$technology)) {
          tec <- dtt$technology[[tt]]
          tt <- tec@name
          #tt <- toupper(tt)
          tec_input <- apply(dat$vTechInp[tt,,,,, drop = FALSE] +
            dat$vTechAInp[tt,,,,, drop = FALSE], c(2, 4), sum)
          tec_input <- tec_input[apply(tec_input != 0, 1, any),, drop = FALSE]
          tec_output <- apply(dat$vTechOut[tt,,,,, drop = FALSE] +
            dat$vTechAOut[tt,,,,, drop = FALSE], c(2, 4), sum)
          tec_output <- tec_output[apply(tec_output != 0, 1, any),, drop = FALSE]
          tec_emission <- apply(dat$vTechEms[tt,,,,, drop = FALSE], c(2, 4), sum)
          tec_emission <- tec_emission[apply(tec_emission != 0, 1, any),, drop = FALSE]
          
          gg <- stock[stock$tech == tt, ]
          tec_cap <- rbind(
            'Total capacity' = apply(dat$vTechCap[tt,,, drop = FALSE], 3, sum),
            'New capacity' = apply(dat$vTechNewCap[tt,,, drop = FALSE], 3, sum),
            'Initial stock' = tapply(gg$Freq, gg$year, sum),
            'Activity' = apply(dat$vTechAct[tt,,,, drop = FALSE], 3, sum)
          )
          
          tec_cost <- rbind(
            salvage = c(rep(0, dim(dat$vTechInv)[3] - 1), sum(dat$vTechSalv[tt,])),
            investment = apply(dat$vTechInv[tt,,, drop = FALSE], 3, sum),
            'OM cost' = apply(dat$vTechCost[tt,,, drop = FALSE], 3, sum)
          )
          tec_cost['OM cost', ] <- tec_cost['OM cost', ] - tec_cost['investment', ]
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
            cat_bottomup_data_frame(tbl, 'Raw data input/output', zz, 5)
          }
          # Raw capacity data
          if (f2) {
            tbl <- as.data.frame(t(tec_cap))
            tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
            cat_bottomup_data_frame(tbl, 'Raw capacity data', zz)
            if (any(tec_cost != 0)) {
              tbl <- as.data.frame(t(tec_cost))
              tbl <- tbl[apply(tbl != 0, 1, any), apply(tbl != 0, 2, any), drop = FALSE]
              cat_bottomup_data_frame(tbl, 'Raw capacity data', zz)
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
      ## Constrain
      if (length(dtt$constrain) != 0) {
        cat('\\section{Constrain analysis}\n\n', '\n', sep = '', file = zz)
        for(cc in seq(along = dtt$constrain)) {
         cns <- dtt$constrain[[cc]]
          cat('\\subsection{', gsub('_', '\\\\_', 
             as.character(cns@name)), '}\n\n', '\n', sep = '', file = zz)
          cat_bottomup(cns, file = zz)
          rd <- obj@result@data[[paste('eqCns', cns@name, sep = '')]]
          if (!is.null(rd)) {
            gr <- apply(rd, seq(length.out = length(dim(rd)))[(names(dimnames(rd)) 
              %in% c('year', 'type'))], sum)
            if (length(dim(gr)) == 1) {
             cat('RHS (sum from all set): ', gr['rhs'], ', value: ', gr['value'], '\n\n', sep = '', file = zz)
            } else {
               cat('RHS (sum from all set): ', gr['rhs'], ', value: ', gr['value'], '\n\n', sep = '', file = zz)
              png2(paste(cns@name, '_rhs.png', sep = ''), width = 640)
              par(mar = c(5, 4, 4, 2) + .1)
              plot(dimnames(gr)$year, gr[, 'rhs'], ylim = range(gr),
                   main = 'Constrain (sum from all set, except year)', xlab = '', ylab = '', type = 'l', lwd = 2)
              lines(dimnames(gr)$year, gr[, 'value'], lty = 2, col = 'red', lwd = 2)
              dev.off2()
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 7in]{', cns@name, '_rhs.png}\n', sep = '', file = zz)
              cat('  \\caption{Constrain ', gsub('_', '\\\\_', cns@name), 
                  ', sum from all set, except year.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
            }
          }
          if (all(!(as.character(cns@type) %in% c('tax', 'subsidy'))))
            cat_bottomup_data_frame(getConstrainResults(obj, as.character(cns@name))[[1]], 'Constrain data', zz)
        }
      }
    ##########!!
      ## Supply
      if (length(dtt$supply) != 0) {
        FL <- array(NA, dim = length(dtt$supply), dimnames = list(names(dtt$supply)))
        cat('\\section{Supply}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$supply)) {
          sup <- dtt$supply[[cc]]
          png2(paste('supply_wrk_', sup@name, '.png', sep = ''))
          sup_out <- apply(dat$vSupOut[cc, sup@commodity,,,, drop = FALSE], 4, sum)
          sup_cst <- apply(dat$vSupCost[cc,,, drop = FALSE], 3, sum)
          SP <- plot(obj@model, type = 'supply', commodity = sup@commodity, 
            main = '', supply = cc, ylim_min = max(sup_out))
          lines(dimnames(dat$vSupOut)$year, sup_out, col = 'cyan4', lwd = 2)
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
            cat('  \\includegraphics[width = 5in]{supply_wrk_', 
                sup@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Supply ', gsub('_', '\\\\_', cc), ', for commodity ', 
                gsub('_', '\\\\_', sup@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
            cat_bottomup_data_frame(sup_dt, paste('Supply ', gsub('_', '\\\\_', cc), 
            ', for commodity ', gsub('_', '\\\\_', sup@commodity), '.', sep = ''), zz)
            cat('\n\n Total reserve: ', format(sup@reserve, digits = 4), 
              ', total extract: ', sum(sup_out), '.\n\n', sep = '', file = zz)
          }  
          cat('\n\n', '\n', sep = '', file = zz) 
#        }
        FL[cc] <- !fl
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

