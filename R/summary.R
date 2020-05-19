
summary.model <- function(mod) {
  
}

summary.scenario <- function(scen) {
  cat("Scenario:", scen@name, "\n")
  cat("Model:", scen@model@name, "\n")
  cat("Interpolated:", scen@status$interpolated, "\n")
  if (scen@status$interpolated) {
    if (!is.null(scen@modOut) && scen@modOut@stage == "solved") {
      cat("Solution status: ", ifelse(scen@status$optimial, "", "NOT "), "optimal\n", sep = "")
      vObj <- getData(scen, "vObjective", merge = T)
      cat("vObjective: ", vObj$value, "\n")
      dum <- sum(scen@modOut@variables$vDummyCost$value)
      if (abs(dum) > 0) {
        cat("Dummy import/export costs: ", dum, "\n")
      }
    } else { # not solved
      cat("Solution status: not solved\n")
    }
  }
  cat("Size:", size(scen),"\n")
}


 
