plot.levcost <- function(obj, xlab = '', 
           ylab = '', main = 'Discounted cash flow', ...) {
    year <- obj$table$year
    tbl <-  t(obj$table[, c("fuel.subs", "fuel.tax", "fuel.cost", 
      "fixom", "varom", "invcost"), drop = FALSE] * obj$table[,"discount.factor"] / 
      sum(obj$table[,"discount.factor"]))
#    tbl <-  t(obj$table[, c("fuel.subs", "fuel.tax", "fuel.cost", 
#      "fixom", "varom", "invcost"), drop = FALSE])
    tbl <- rbind(-tbl['fuel.subs', ], tbl)
    colnames(tbl) <- year
    cll <- c('cornflowerblue', 'darkgray', 'aquamarine', 
       'forestgreen', 'darkslategray3', 'brown3')
    names(cll) <- c("Subsidies", "Tax", "Fuel cost",
      "Fix O&M", "Var O&M", "Investment cost")
    barplot(tbl, col = c('white', rep(cll, 2)), main = main, xlab = xlab, 
      ylab = ylab, ...)
    if (any(tbl != 0))
        cll <- cll[rowSums(tbl[-1, ]) != 0]
    legend('topright', legend = names(cll), fill = cll, bty = 'n')
}

barplot.levcost <- function(obj, xlab = '', 
           ylab = '', main = 'Levelized cost', ...) {
    year <- obj$table$year
    tbl <-  colSums(obj$table[, c("fuel.subs", "fuel.tax", "fuel.cost", 
      "fixom", "varom", "invcost"), drop = FALSE] * obj$table[,"discount.factor"] / 
      sum(obj$table[,"discount.factor"]))
    tbl <- c(-tbl[1], tbl)
    cll <- c('cornflowerblue', 'darkgray', 'aquamarine', 
       'forestgreen', 'darkslategray3', 'brown3')
    names(cll) <- c("Subsidies", "Tax", "Fuel cost",
      "Fix O&M", "Var O&M", "Investment cost")
    names(tbl) <- names(cll) 
    tbl <- cbind(tbl)
    colnames(tbl) <- NULL
    gg <- barplot(tbl, horiz  = !TRUE, col = c('white', rep(cll, 2)), main = main, xlab = xlab, 
      ylab = ylab, xlim = c(0, 2), ...)
    if (any(tbl != 0)) {
        cll <- cll[tbl[-1] != 0]
        tbl <- tbl[-1][tbl[-1]!= 0]
        text(rep(gg, length(tbl)), cumsum(tbl) - tbl / 2, format(tbl, digit = 3))

    }
    legend('topright', legend = names(cll), fill = cll, bty = 'n')
}
