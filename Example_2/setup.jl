# setup.jl — Run once to create the Julia environment for Example 2
#
# Usage:  cd Example_2 && julia setup.jl
#
# This generates Project.toml and Manifest.toml with correct package UUIDs.
#
# NOTE: MosekTools requires a MOSEK license. Free academic licenses are
# available at https://www.mosek.com/products/academic-licenses/
# Place the license file at ~/mosek/mosek.lic

using Pkg
Pkg.activate(@__DIR__)

Pkg.add([
    "JuMP",
    "HiGHS",
    "Ipopt",
    "DynamicPolynomials",
    "DifferentialEquations",
    "Rotations",
    "Trapz",
    "MatrixEquations",
    "SumOfSquares",
    "MosekTools",
    "LaTeXStrings",
    "PyPlot",
])

# Add compat bounds for reproducibility
for (pkg, bound) in [
    "julia"                  => "1.10",
    "JuMP"                   => "1",
    "HiGHS"                  => "1",
    "Ipopt"                  => "1",
    "DynamicPolynomials"     => "0.5, 0.6",
    "DifferentialEquations"  => "7",
    "Rotations"              => "1",
    "Trapz"                  => "2",
    "MatrixEquations"        => "2",
    "SumOfSquares"           => "0.7, 0.8",
    "MosekTools"             => "0.15",
    "LaTeXStrings"           => "1",
    "PyPlot"                 => "2",
]
    Pkg.compat(pkg, bound)
end

Pkg.resolve()
println("\n✓ Environment ready. Open Example_2.ipynb and select the Julia kernel.")
