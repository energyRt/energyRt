
summary.model <- function(mod) {
  
}

summary.scenario <- function(scen) {
  # ll <- list()
  # ll$solutionStatus <- scen@modOut@solutionStatus
  cat("Scenario: ", scen@name, "\n")
  cat("Model: ", scen@model@name, "\n")
  cat("Solution status: ", scen@modOut@solutionStatus, "\n")
  dum <- sum(scen@modOut@variables$vDummyCost$value)
  cat("Dummy import/export costs: ", dum, "\n")
  if (abs(dum) >= 0) {
    # Dummy import
    # Dummy export
  }
}


 