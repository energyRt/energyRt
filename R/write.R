setGeneric('write_model', function(scen, tmp.dir, solver, ...) standardGeneric("write_model"))

setMethod("write_model", "scenario",
# write.scenario <- 
  function(scen, tmp.dir = NULL, solver = NULL, ...) {
  if (is.null(tmp.dir)) {
    if (!is.null(scen@misc$tmp.dir)) tmp.dir <- scen@misc$tmp.dir
  } else {
    scen@misc$tmp.dir <- tmp.dir
  }
  .solver_solve(scen, tmp.dir = tmp.dir, solver = solver, ..., run = FALSE, write = TRUE)
})


