write2xls <- function(scen, 
                      file = paste0("Scen_", scen@name, scen@model@name, ".xls"),
                      YearsInColumns = TRUE, 
                      AdjWidth = TRUE, 
                      AutoFilter = FALSE,
                      col.names = TRUE,
                      row.names = FALSE,
                      FreezeRow = FreezeRow, 
                      FreezeCol = FreezeCol, 
                      ...) {
  # Convert arrays to data.frame.table
  lst.wide <- scen@result@data
  for (i in names(lst.wide)) {
    #message(i)
    if(is.array(lst.wide[[i]])) {
      #lst[[i]] <- array2df(rdt[[i]], label.x = i)
      lst.wide[[i]] <- as.data.frame.table(lst.wide[[i]], responseName = i)
    } else {
      #lst[[i]] <- as.data.frame(rdt[[i]], col.names = i)
      ar <- as.list(lst.wide[[i]])
      names(ar) <- i
      lst.wide[[i]] <- as.data.frame(ar)
    }
  }
  # Transform in "wide" formate == years in columns
  if(YearsInColumns) {
    for (i in names(lst.wide)) {
      #lst.wide <- lst[[i]]
      if (any(names(lst.wide[[i]]) == "year")) {
        lst.wide[[i]] <- tidyr::spread_(lst.wide[[i]], "year", i)
      }  
      #message(i)
      #xlsx::write.xlsx(head(tst), sheetName = i, file = "test2.xlsx", append = TRUE)
      # WriteXLS::WriteXLS(head(tst), 
      #                    ExcelFileName = "test3.xls", 
      #                    SheetNames = i,
      #                    AdjWidth = TRUE, 
      #                    AutoFilter = TRUE,
      #                    col.names = FALSE)
    }
    #names(lst.wide$vTechInv)
  }
  # Write to new/replace XLS file
  WriteXLS::WriteXLS(lst.wide, 
                     ExcelFileName = file, 
                     #SheetNames = i,
                     AdjWidth = AdjWidth, 
                     #AutoFilter = TRUE,
                     col.names = col.names,
                     row.names = row.names,
                     FreezeRow = 1, 
                     FreezeCol = 3, 
                     ...)
}

#write2xls(scen.BAU)