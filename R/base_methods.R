# (interim) place for methods from base repository 
setMethod("show", "scenario", function(object) summary(object))
setMethod("show", "model", function(object) object@name)
