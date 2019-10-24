
summary.model <- function(mod) {
  
}

summary.scenario <- function(scen) {
  # ll <- list()
  # ll$solutionStatus <- scen@modOut@solutionStatus
  cat("Scenario: ", scen@name, "\n")
  cat("Model: ", scen@model@name, "\n")
  cat("Solution status: ", scen@modOut@solutionStatus, "\n")
  vObj <- getData(scen, "vObjective")
  cat("vObjective: ", vObj$value, "\n")
  dum <- sum(scen@modOut@variables$vDummyCost$value)
  if (abs(dum) >= 0) {
    cat("Dummy import/export costs: ", dum, "\n")
    # Dummy import
    # Dummy export
  }
}


 