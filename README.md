# Near-Optimal Constrained Feedback Control via Approximate HJB and Control Barrier Functions

This repository contains the source code for reproducing all simulation results in:

> M.A. Shahraki and L. Lessard. "Near-optimal constrained feedback control of nonlinear systems via approximate HJB and control barrier functions", 2026 ([arXiv](https://arxiv.org/abs/2603.16114))

**Abstract:** This paper presents a two-stage framework for constrained near-optimal feedback control of input-affine nonlinear systems. An approximate value function for the unconstrained control problem is computed offline by solving the Hamilton--Jacobi--Bellman equation. Online, a quadratic program is solved that minimizes the associated approximate Hamiltonian subject to safety constraints imposed via control barrier functions. Our proposed architecture decouples performance from constraint enforcement, allowing constraints to be modified online without recomputing the value function. Validation on a linear 2-state 1D hovercraft and a nonlinear 9-state spacecraft attitude control problem demonstrates near-optimal performance relative to open-loop optimal control benchmarks and superior performance compared to control Lyapunov function-based controllers.


## Overview

We propose a two-stage framework for constrained near-optimal feedback control of input-affine nonlinear systems:

1. **Offline:** An approximate value function is computed by solving the Hamilton–Jacobi–Bellman (HJB) equation via policy iteration.
2. **Online:** A quadratic program (QP) minimizes the approximate Hamiltonian subject to safety constraints imposed via Control Barrier Functions (CBFs).

The architecture decouples performance from constraint enforcement, allowing constraints to be modified online without recomputing the value function.

## Repository Structure

```
ghjbcbf/
├── README.md
├── LICENSE
├── .gitignore
├── Example_1/                 # 1D Hovercraft (linear, 2 states)
│   ├── setup.jl               # Optional: pre-install from terminal
│   ├── Project.toml           # Auto-generated on first run
│   ├── Manifest.toml          # Auto-generated on first run
│   └── Example_1.ipynb        # Jupyter notebook
└── Example_2/                 # Spacecraft Attitude Control (nonlinear, 9 states)
    ├── setup.jl               # Optional: pre-install from terminal
    ├── Project.toml           # Auto-generated on first run
    ├── Manifest.toml          # Auto-generated on first run
    └── Example_2.ipynb        # Jupyter notebook
```

Each example uses its own Julia environment. The first notebook cell automatically detects and installs missing packages, so no manual setup is required.

## Requirements

- **Julia ≥ 1.10** (tested on 1.11 and 1.12). Download from [julialang.org](https://julialang.org/downloads/).
- **Jupyter** with the Julia kernel (`IJulia`). See [Setup Instructions](#setup-instructions) below.
- **Python + Matplotlib** (required by `PyPlot.jl` for figure generation). `PyPlot.jl` depends on a working Python installation with Matplotlib via `PyCall.jl`. If `PyPlot` fails to install or load, see the [Troubleshooting](#troubleshooting) section. Generated figures are saved as PDFs to `Example_1/Example_1_Figures/` and `Example_2/Example_2_Figures/`.
- **MOSEK** (Example 2 only): The SOS policy iteration in Example 2 uses [MOSEK](https://www.mosek.com/) via `MosekTools.jl`. MOSEK is commercial but offers [free academic licenses](https://www.mosek.com/products/academic-licenses/). Place the license file at `~/mosek/mosek.lic`. If a MOSEK license is unavailable, the SOS solver can be replaced with an open-source alternative by changing `MosekTools.Optimizer` to another SDP-capable solver, such as [SCS](https://github.com/jump-dev/SCS.jl) (`using SCS; SCS.Optimizer`), [COSMO](https://github.com/oxfordcontrol/COSMO.jl) (`using COSMO; COSMO.Optimizer`), or [CSDP](https://github.com/jump-dev/CSDP.jl) (`using CSDP; CSDP.Optimizer`). Note that these solvers may differ in numerical accuracy and convergence speed compared to MOSEK.

## Setup Instructions

### 1. Install Julia

Download and install Julia from [julialang.org/downloads](https://julialang.org/downloads/). Ensure `julia` is available on your system PATH.

### 2. Install Jupyter and IJulia

If you don't already have Jupyter, install it via Julia:

```julia
using Pkg
Pkg.add("IJulia")
using IJulia
notebook()  # This will install Jupyter if needed
```

Alternatively, if you use VS Code, install the [Jupyter extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter) and select a Julia kernel.

### 3. Install Dependencies

The first cell of each notebook automatically installs all required packages if they are not already present. Simply open a notebook and run it — no separate setup step is needed.

Alternatively, you can pre-install dependencies from a terminal:

```bash
cd Example_1
julia setup.jl
```

```bash
cd Example_2
julia setup.jl
```

The first run may take several minutes as packages are downloaded and precompiled.

> **Note:** After the first run, commit the generated `Project.toml` and `Manifest.toml` to your repository. The `Manifest.toml` pins exact package versions for full reproducibility.

### 4. Install MOSEK License (Example 2 Only)

1. Obtain a license from [mosek.com/products/academic-licenses](https://www.mosek.com/products/academic-licenses/)
2. Place the license file at `~/mosek/mosek.lic`
3. Verify: `julia -e 'using MosekTools; println("MOSEK OK")'`

### 5. Run the Notebooks

Open the notebook in Jupyter or VS Code and select the Julia kernel. The first cell activates the local environment:

```julia
using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()
```

Run all cells sequentially. Figures are saved to `Example_1_Figures/` or `Example_2_Figures/` within each example directory.

## Examples

### Example 1: 1D Hovercraft (Linear System)

A double-integrator hovercraft with position and velocity states. Demonstrates:
- Successive Galerkin Approximation (SGA) for value function computation
- GHJB-CBF-QP with velocity and input constraints (CBF, relative degree 1)
- Comparison against Constrained LQR, MPC, and Open-Loop Optimal Control

**Controllers compared:** Constrained LQR, MPC (with LQR terminal cost), Open-Loop Optimal Control (direct transcription via Ipopt), GHJB-CBF-QP.

### Example 2: Spacecraft Attitude Control (Nonlinear System)

Spacecraft attitude control with reaction wheels (9 states, 3 inputs). Demonstrates:
- Sum-of-Squares (SOS) policy iteration with MOSEK for value function computation
- **Case 1:** Reaction wheel momentum constraints (CBF, relative degree 1)
- **Case 2:** Forbidden pointing constraint (HOCBF, relative degree 2)
- Comparison against OD-CLF-CBF-QP, RES-CLF-CBF-QP, and Open-Loop Optimal Control

**Controllers compared:** RES-CLF-CBF-QP, OD-CLF-CBF-QP (both from [Alipour Shahraki & Lessard, ACC 2025](https://doi.org/10.23919/ACC63710.2025.11108025)), Open-Loop Optimal Control, GHJB-CBF-QP.

### Note on Wall Clock Times

The wall clock times reported in the paper (Tables I and II) are averaged over multiple runs, excluding the first run. In Julia, the first execution of a function incurs just-in-time (JIT) compilation overhead, which makes it significantly slower than subsequent runs. The reported times therefore reflect steady-state performance after compilation and are representative of real-time deployment scenarios.

## Key Dependencies

| Package | Example 1 | Example 2 | Purpose |
|---------|:---------:|:---------:|---------|
| JuMP | ✓ | ✓ | Optimization modeling |
| HiGHS | ✓ | ✓ | QP solver (online controllers) |
| Ipopt | ✓ | ✓ | NLP solver (open-loop optimal control) |
| DifferentialEquations | ✓ | ✓ | ODE integration (RK4) |
| Symbolics | ✓ | | Symbolic computation (SGA) |
| DynamicPolynomials | | ✓ | Polynomial manipulation (SOS) |
| SumOfSquares | | ✓ | SOS programming |
| MosekTools | | ✓ | MOSEK SDP solver interface |
| MatrixEquations | | ✓ | CARE solver (CLF controllers) |
| Rotations | | ✓ | Attitude conversions |
| PyPlot | ✓ | ✓ | Figure generation (via Matplotlib) |

## Troubleshooting

**PyPlot fails to load:** PyPlot requires a working Python installation with Matplotlib. If `using PyPlot` fails, try:
```julia
ENV["PYTHON"] = ""  # Use Julia's built-in Conda
Pkg.build("PyCall")
```
Then restart Julia and try again.

**MOSEK license not found:** Ensure `~/mosek/mosek.lic` exists and is valid. You can test with:
```julia
using MosekTools
model = Mosek.Optimizer()
```

**Package precompilation is slow:** This is normal for the first run. Subsequent runs will be fast. Consider using `PackageCompiler.jl` for frequently-used environments.

**Kernel mismatch in Jupyter:** Ensure you select the Julia kernel that matches the project environment. In VS Code, use the kernel picker to select the correct Julia installation.

**Packages not found after first cell (VS Code):** If `@__DIR__` returns an empty path, the notebook falls back to `pwd()`. Make sure your VS Code workspace is opened at the repository root, or at the example directory. You can verify by adding `println(NOTEBOOK_DIR)` after the first cell.

## Citing This Work

If you use this code in your research, please cite:

```bibtex
@misc{shahraki2026near,
      title={Near-Optimal Constrained Feedback Control of Nonlinear Systems via Approximate {HJB} and Control Barrier Functions}, 
      author={Milad Alipour Shahraki and Laurent Lessard},
      year={2026},
      eprint={2603.16114},
      archivePrefix={arXiv},
      primaryClass={eess.SY},
      url={https://arxiv.org/abs/2603.16114}, 
}
```

## Contact

- Milad Alipour Shahraki — alipourshahraki.m@northeastern.edu
- Laurent Lessard — l.lessard@northeastern.edu
- GitHub: [https://github.com/QCGroup/ghjbcbf](https://github.com/QCGroup/ghjbcbf)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
