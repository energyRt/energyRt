
# summary.model <- function(mod) {
#
# }

# summary.scenario <- function(scen) {
#   # browser()
#   cat("Scenario:", scen@name, "\n")
#   cat("Model:", scen@model@name, "\n")
#   cat("Interpolated:", scen@status$interpolated, "\n")
#   if (scen@status$interpolated) {
#     if (!is.null(scen@modOut) && scen@modOut@stage == "solved") {
#       cat("Solution status: ", ifelse(scen@status$optimal, "", "NOT "), "optimal\n", sep = "")
#       vObj <- getData(scen, "vObjective", merge = T)
#       cat("vObjective: ", vObj$value, "\n")
#       dum <- sum(scen@modOut@variables$vDummyCost$value)
#       if (abs(dum) > 0) {
#         cat("Dummy import/export costs: ", dum, "\n")
#       }
#     } else if (is.null(scen@modOut)) { # not solved
#       cat("Solution status: not solved\n")
#     } else {
#       status <- try(scen@modOut@stage)
#       if (class(status) == "try-error") status <- "unknown"
#       cat("Solution status:", status,"\n")
#     }
#   }
#   cat("Size:", size(scen),"\n")
# }


# summary.levcost <- function(x) x$total

