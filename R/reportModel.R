#textemplate <- function(obj) UseMethod("textemplate")
totex <-function(x)
  gsub('[&]', '\\\\&', gsub('_', '\\\\_', x))
  
report.model <- function(obj, texdir = paste(getwd(), '/reports/', sep = ''), tmp.del = TRUE, 
                         file.name = NULL) {
  obj.name <- deparse(substitute(obj))
  if (is.null(file.name)) {
    file.name <- paste('energyRtReport_Model_', 
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
    dtt$constraint <- list()
    dtt$import <- list()
    dtt$export <- list()
    dtt$trade <- list()
    dtt$storage <- list()
    dtt$weather <- list()
    for(i in seq(along = obj@data)) {
      for(j in seq(along = obj@data[[i]]@data)) {
        obj@data[[i]]@data[[j]]@name <- obj@data[[i]]@data[[j]]@name
        dtt[[class(obj@data[[i]]@data[[j]])]][[obj@data[[i]]@data[[j]]@name]] <-
          obj@data[[i]]@data[[j]]
      }
    }
   for(i in names(dtt)) if (length(dtt[[i]]) != 0) dtt[[i]] <- dtt[[i]][sort(names(dtt[[i]]))]
    tryCatch({
      zz <- file('energyRtReport.tex', 'w')
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
      cat('\\title{A quick report for model "', totex(obj.name), '"}\n', sep = '', file = zz)
      cat('\\begin{document}\n', sep = '', file = zz)
      cat('\\maketitle\n', sep = '', file = zz)
      cat('\n\n', sep = '', file = zz)
      
      cat('\\section{Summary}\n\n', '\n', sep = '', file = zz)
      
      gg <- paste('There are ', length(obj@data), ' repositary, ', sep = '')
      for(i in names(dtt)) {
        if (length(dtt[[i]]) != 0)
          gg <- paste(gg, length(dtt[[i]]), ' ', i, ', ', sep = '')
      }
      gg <- sub('[,][ ]$', '.\n\n', gg)
      cat(gg, sep = '', file = zz)
      
      cat('\\tableofcontents\n\n', '\n', sep = '', file = zz)
      
      ## Commodity
      if (length(dtt$commodity) != 0) {
        FL <- array(NA, dim = length(dtt$commodity), dimnames = list(names(dtt$commodity)))
        cat('\\section{Commodity}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$commodity)) {
          cmd <- dtt$commodity[[cc]]
          fl <- energyRt:::.is_additional_information(cmd)
          png2(paste(cmd@name, '_supply.png', sep = ''))
          SP <- plot(obj, type = 'supply', commodity = cmd@name, main = '')
          fl <- fl || any(SP != 0)
          dev.off2()
          png2(paste(cmd@name, '_demand.png', sep = ''))
          DM <- plot(obj, type = 'demand', commodity = cmd@name, main = '')
          fl <- fl || any(DM != 0)
          dev.off2()
          png2(paste(cmd@name, '_export.png', sep = ''))
          EXP <- plot(obj, type = 'export', commodity = cmd@name, main = '')
          fl <- fl || any(EXP != 0)
          dev.off2()
          png2(paste(cmd@name, '_import.png', sep = ''))
          IMP <- plot(obj, type = 'import', commodity = cmd@name, main = '')
          fl <- fl || any(IMP != 0)
          dev.off2()
          emm <- sapply(dtt$commodity, function(x) any(x@emis$comm == cmd@name, na.rm = TRUE))
          fl <- fl || any(emm)
          if (fl) {
            cat('\\subsection{', gsub('_', '\\\\_', cmd@name), '}\n\n', '\n', sep = '', file = zz) 
            energyRt:::.cat_bottomup(cmd, file = zz, includename = FALSE)#, print.all = TRUE)
            if (any(SP != 0)) {
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{', cmd@name, 
                  '_supply.png}\n', sep = '', file = zz)
              cat('  \\caption{Supply commodity ', gsub('_', '\\\\_', cmd@name), 
                  ', summary for all region and slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
            }
            if (any(DM != 0)) {
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{', cmd@name, 
                  '_demand.png}\n', sep = '', file = zz)
              cat('  \\caption{Demand commodity ', gsub('_', '\\\\_', cmd@name), 
                  ', summary for all region and slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
            }
            if (any(EXP != 0)) {
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{', cmd@name, 
                  '_export.png}\n', sep = '', file = zz)
              cat('  \\caption{Export commodity ', gsub('_', '\\\\_', cmd@name), 
                  ', summary for all region and slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
            }
            if (any(IMP != 0)) {
              cat('\\begin{figure}[H]\n', sep = '', file = zz)
              cat('  \\centering\n', sep = '', file = zz)
              cat('  \\includegraphics[width = 6in]{', cmd@name, 
                  '_import.png}\n', sep = '', file = zz)
              cat('  \\caption{Import commodity ', gsub('_', '\\\\_', cmd@name), 
                  ', summary for all region and slice.}\n', sep = '', file = zz)
              cat('\\end{figure}\n', sep = '', file = zz)
            }
            if (any(emm)) {
              s1 <- data.frame(Commodity = names(dtt$commodity)[emm])
              s1$Emission <- sapply(dtt$commodity[emm], function(x) 
                x@emis[!is.na(x@emis$comm) & x@emis$comm == cmd@name, 'mean'])
              energyRt:::.cat_bottomup_data_frame(s1, paste('Commodity ', cmd@name, 
                                                ' emmited by', sep = ''), zz)
            }
            cat('\n\n', '\n', sep = '', file = zz) 
          }
          FL[cc] <- !fl
        }
        cat('\\subsection{Commodity without information}\n\n', '\n', sep = '', file = zz)
        cat(#'Commodity without additional information:\n\n', 
          paste(gsub('_', '\\\\_', names(dtt$commodity)[FL]), collapse = ', '), 
          '.\n\n', '\n', sep = '', file = zz)
      }
      
      ## Supply
      if (length(dtt$supply) != 0) {
        FL <- array(NA, dim = length(dtt$supply), dimnames = list(names(dtt$supply)))
        cat('\\section{Supply}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$supply)) {
          sup <- dtt$supply[[cc]]
          png2(paste('supply_', sup@name, '.png', sep = ''))
          SP <- plot(obj, type = 'supply', commodity = sup@commodity, supply = sup@name, main = '')
          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', sup@name), '}\n\n', '\n', sep = '', file = zz) 
          energyRt:::.cat_bottomup(sup, file = zz, includename = FALSE)#, print.all = TRUE)
          if (any(SP != 0)) {
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 6in]{supply_', 
                sup@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Supply commodity ', gsub('_', '\\\\_', sup@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
          }  else cat('There is not supply commodity.\n\n', '\n', sep = '', file = zz) 
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }
     
      ## Export
      if (length(dtt$export) != 0) {
        FL <- array(NA, dim = length(dtt$export), dimnames = list(names(dtt$export)))
        cat('\\section{Export}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$export)) {
          expp <- dtt$export[[cc]]
          png2(paste('export_', expp@name, '.png', sep = ''))
          SP <- plot(obj, type = 'export', commodity = expp@commodity, export = expp@name, main = '')
          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', expp@name), '}\n\n', '\n', sep = '', file = zz) 
          energyRt:::.cat_bottomup(expp, file = zz, includename = FALSE)#, print.all = TRUE)
          if (any(SP != 0)) {
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 6in]{export_', 
                expp@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Export commodity ', gsub('_', '\\\\_', expp@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
          }  else cat('There is not export commodity.\n\n', '\n', sep = '', file = zz) 
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }
      
      ## Import
      if (length(dtt$import) != 0) {
        FL <- array(NA, dim = length(dtt$import), dimnames = list(names(dtt$import)))
        cat('\\section{Import}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$import)) {
          imp <- dtt$import[[cc]]
          png2(paste('import_', imp@name, '.png', sep = ''))
          SP <- plot(obj, type = 'import', commodity = imp@commodity, import = imp@name, main = '')
          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', imp@name), '}\n\n', '\n', sep = '', file = zz) 
          energyRt:::.cat_bottomup(imp, file = zz, includename = FALSE)#, print.all = TRUE)
          if (any(SP != 0)) {
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 6in]{import_', 
                imp@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Import commodity ', gsub('_', '\\\\_', imp@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
          }  else cat('There is not import commodity.\n\n', '\n', sep = '', file = zz) 
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }

      ## Trade
      if (length(dtt$trade) != 0) {
        FL <- array(NA, dim = length(dtt$trade), dimnames = list(names(dtt$trade)))
        cat('\\section{Trade}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$trade)) {
          trdd <- dtt$trade[[cc]]
#          png2(paste('trade_', trdd@name, '.png', sep = ''))
#          SP <- plot(obj, type = 'trade', commodity = trdd@commodity, trade = trdd@name, main = '')
#          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', trdd@name), '}\n\n', '\n', sep = '', file = zz)
          energyRt:::.cat_bottomup(trdd, file = zz, includename = FALSE)#, print.all = TRUE)
#          if (any(SP != 0)) {
#            cat('\\begin{figure}[H]\n', sep = '', file = zz)
#            cat('  \\centering\n', sep = '', file = zz)
#            cat('  \\includegraphics[width = 6in]{trade_', 
#                trdd@name, '.png}\n', sep = '', file = zz)
#            cat('  \\caption{Trade commodity ', gsub('_', '\\\\_', trdd@commodity), 
#                ', summary for all region and slice.}\n', sep = '', file = zz)
#            cat('\\end{figure}\n', sep = '', file = zz)
          #}  else cat('There is not trade commodity.\n\n', '\n', sep = '', file = zz) 
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }
      
      ## Demand
      if (length(dtt$demand) != 0) {
        FL <- array(NA, dim = length(dtt$demand), dimnames = list(names(dtt$demand)))
        cat('\\section{Demand}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$demand)) {
          dem <- dtt$demand[[cc]]
          png2(paste('demand_', dem@name, '.png', sep = ''))
          DM <- plot(obj, type = 'demand', commodity = dem@commodity, demand = dem@name, main = '')
          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', dem@name), '}\n\n', '\n', sep = '', file = zz) 
          energyRt:::.cat_bottomup(dem, file = zz, includename = FALSE)#, print.all = TRUE)
          if (any(DM != 0)) {
            cat('\\begin{figure}[H]\n', sep = '', file = zz)
            cat('  \\centering\n', sep = '', file = zz)
            cat('  \\includegraphics[width = 6in]{demand_', 
                dem@name, '.png}\n', sep = '', file = zz)
            cat('  \\caption{Demand commodity ', gsub('_', '\\\\_', dem@commodity), 
                ', summary for all region and slice.}\n', sep = '', file = zz)
            cat('\\end{figure}\n', sep = '', file = zz)
          }  else cat('There is not demand commodity.\n\n', '\n', sep = '', file = zz) 
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }

      ## Technology
      if (length(dtt$technology) != 0) {
        FL <- array(NA, dim = length(dtt$technology), dimnames = list(names(dtt$technology)))
        cat('\\section{Technology}\n\n', '\n', sep = '', file = zz)
        for(cc in names(dtt$technology)) {       
          tec <- dtt$technology[[cc]]
          png2(paste('technology_', tec@name, '.png', sep = ''), 
               width = 1.5 * 480, height = 1.5 * 480, pointsize = 16)
          draw(tec, year = obj@sysInfo@year[1], slice = 'ANNUAL')
          dev.off2()
          cat('\\subsection{', gsub('_', '\\\\_', tec@name), '}\n\n', '\n', sep = '', file = zz) 
          energyRt:::.cat_bottomup(tec, file = zz, includename = FALSE)#, print.all = TRUE)
          cat('\\begin{figure}[H]\n', sep = '', file = zz)
          cat('  \\centering\n', sep = '', file = zz)
          cat('  \\includegraphics[width = 6in]{technology_', 
              tec@name, '.png}\n', sep = '', file = zz)
          cat('  \\caption{Technology scheme ',gsub('_', '\\\\_', tec@name), 
              ' in year ', obj@sysInfo@year[1], ', slice ANNUAL', 
              '}\n', sep = '', file = zz)
          cat('\\end{figure}\n', sep = '', file = zz)
          cat('\n\n', '\n', sep = '', file = zz) 
        }
        FL[cc] <- !fl
      }
      
      cat('\\end{document}\n', sep = '', file = zz)
      close(zz)
    }, interrupt = function(x) stop('Was interrupt'), error = function(x) {
      close(zz)
      if (get('setPNGLAST', globalenv())) dev.off2();
      setwd(WDD)
      if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
      stop(x)
    }) 
    if (.Platform$OS.type == "windows") {
      shell('pdflatex energyRtReport.tex')
      shell('pdflatex energyRtReport.tex')
      file.copy('energyRtReport.pdf', paste('../', file.name, sep = ''))
      shell.exec(paste('..\\', file.name, sep = ''))
    } else { 
      system('pdflatex energyRtReport.tex')
      system('pdflatex energyRtReport.tex')
      file.copy('energyRtReport.pdf', paste('../', file.name, sep = ''))
      system(paste('open ../', file.name, sep = ''))
    }
    setwd(WDD)
    if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
  }, interrupt = function(x) stop('Was interrupt'), error = function(x) {
    setwd(WDD)
    if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
    stop(x)
  }) 
  if (tmp.del) unlink(paste(texdir, '/', add_drr, sep = ''), recursive = TRUE)
  setwd(WDD)
}

