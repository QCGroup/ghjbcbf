# setup.jl — Run once to create the Julia environment for Example 1
#
# Usage:  cd Example_1 && julia setup.jl
#
# This generates Project.toml and Manifest.toml with correct package UUIDs.

using Pkg
Pkg.activate(@__DIR__)

Pkg.add([
    "JuMP",
    "HiGHS",
    "Ipopt",
    "Symbolics",
    "DifferentialEquations",
    "MathOptInterface",
    "LaTeXStrings",
    "PyPlot",
    "Combinatorics",
])

# Add compat bounds for reproducibility
for (pkg, bound) in [
    "julia"                  => "1.10",
    "JuMP"                   => "1",
    "HiGHS"                  => "1",
    "Ipopt"                  => "1",
    "Symbolics"              => "5, 6",
    "DifferentialEquations"  => "7",
    "MathOptInterface"       => "1",
    "LaTeXStrings"           => "1",
    "PyPlot"                 => "2",
    "Combinatorics"          => "1",
]
    Pkg.compat(pkg, bound)
end

Pkg.resolve()
println("\n✓ Environment ready. Open Example_1.ipynb and select the Julia kernel.")
