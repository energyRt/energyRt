load('data/convert_20131019o.RData')
modelCode <- list(GAMS = list(reduced = readLines('gams/model_reduced.gms'),
                              full = readLines('gams/model_full.gms')),
                  GLPK = list(reduced = readLines('glpk/glpk_reduced.mod'),
                              full = readLines('glpk/glpk_full.mod')))
save(file = 'data/modelCode.RData', list = 'modelCode')


