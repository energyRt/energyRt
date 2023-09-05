# setTimeSlices(level1= 'MON', TH', ..., level2= '1H', 2H', ...)
# setTimeSlices(level1= list(name 'WEEKDAY', 'MON' = 1/12, 'TH' = 1/13), ..., level2= '1H', 2H', ...)setTimeSlices(level1= list('MON' = list(1/12, c('1H' = 1/13)), ...)

# require(energyRt)
# mdl <- new('model')


# ! 1
# .setTimeSlices("SEASON" = c("WINTER", "SUMMER"))
# .setTimeSlices("SEASON" = c("WINTER" = .6, "SUMMER" = .4))
# .setTimeSlices("SEASON" = list("WINTER" = .6, "SUMMER" = .4))
# .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING', 'EVENING')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING'))))
# .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING')))) # have to error

# ! 2
# .setTimeSlices("SEASON" = c("WINTER", "SUMMER"), HOUR = paste('H', seq(0, 21, by = 3), sep = ''))
# .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = list('MORNING' = list(.5, tp = c('x1' = .1, 'x2' = .9)), 'EVENING' = list(.5, tp = c('x1', 'x2')))),
#                          "SUMMER" = list(.7, DAY = list('MORNING' = list(.5, tp = c('x1', 'x2')), 'EVENING' = list(.5, tp = c('x1', 'x2'))))))

# sl = .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING', 'EVENING', 'PEAK')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING', 'PEAK'))))
