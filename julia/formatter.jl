using Pkg
Pkg.add("JuliaFormatter")
using JuliaFormatter
format(".", remove_extra_newlines = true)
