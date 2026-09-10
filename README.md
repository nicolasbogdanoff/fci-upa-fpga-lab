# fci-upa-fpga-lab

Reproducible FPGA design and simulation labs for FCI-UPA, focused on HDL, Questa, Quartus Prime, fixed-point scientific computing, digital twins, and edge-AI preparation.

## Status

**Phase:** simulation-first development

The first fixed-point thermal kernel lab is now scaffolded with a Python
reference model, portable SystemVerilog RTL, a deterministic testbench, and
a Questa runner. Quartus is intentionally kept device-independent until the
development board and FPGA part are confirmed.

This repository is intentionally hardware-independent while the development board is pending. The first milestones are simulation, fixed-point modeling, verification, and reproducible documentation. Board-specific device support, pin constraints, timing closure, and JTAG programming will be added only after the target FPGA is confirmed.

## Objectives

- Build small, testable HDL modules with clear interfaces.
- Verify behavior with Questa testbenches before hardware access.
- Connect engineering reference models to fixed-point RTL implementations.
- Prepare reusable teaching material for FCI-UPA.
- Keep experiments reproducible through versioned code, tests, and reports.

## Initial project

The first applied milestone is a fixed-point heat/mass-transfer kernel related to thermal digital twins and drying-process engineering. The reference model will be developed and checked on the host before an RTL implementation is compared against it.

## Planned layout

- [rtl/](rtl/) — synthesizable HDL modules and packages.
- [sim/](sim/) — Questa testbenches and simulation scripts.
- [models/](models/) — host-side reference models and test vectors.
- [quartus/](quartus/) — device-independent project notes and later Quartus projects.
- [docs/](docs/) — lab guides, design decisions, and reproducibility notes.

## First lab

Run the host-side reference tests from `models/`:

```text
python -m unittest discover -s models -p "test_*.py"
```

Run the RTL simulation from `sim/` with the installed Questa Altera FPGA
Starter Edition:

```text
powershell -ExecutionPolicy Bypass -File .\run_questa.ps1
```

If no Questa license server is configured yet, the RTL can still be compiled
and checked syntactically with:

```text
powershell -ExecutionPolicy Bypass -File .\run_questa.ps1 -CompileOnly
```

Full simulation requires a valid `SALT_LICENSE_SERVER` or `LM_LICENSE_FILE`.
The runner also reads a per-user `SALT_LICENSE_SERVER` value from Windows if
the current PowerShell session has not inherited it yet.

Because the Starter Edition license permits one active session, close the
Questa GUI before running the console regression. The runner now reports this
condition explicitly.

The lab uses signed Q8.8 values for the state and target, and unsigned Q0.8
for the relaxation factor. The interface and arithmetic are documented in
`rtl/thermal_kernel.sv` and are deliberately independent of any FPGA device.

The extended lab also includes a physical first-order response model,
fixed-point trajectory checks, deterministic vector generation, and a
one-sample-per-cycle streaming kernel in `rtl/thermal_kernel_stream.sv`.
See [docs/first-lab.md](docs/first-lab.md) for the complete flow.

Both RTL variants now share the arithmetic contract in
`rtl/fixed_point_pkg.sv`; see [docs/rtl-interface.md](docs/rtl-interface.md)
for the cycle-level behavior.

Run the complete local verification from the repository root:

```text
powershell -ExecutionPolicy Bypass -File .\scripts\run_local_checks.ps1
```

The verification strategy is documented in [docs/verification.md](docs/verification.md),
and `.github/workflows/ci.yml` checks the Python model and reproducible vectors
when the repository is published.

## Roadmap

1. Define numerical conventions and interfaces.
2. Implement a host-side floating-point reference.
3. Add fixed-point conversion and error analysis.
4. Implement the first RTL kernel and Questa testbench.
5. Run synthesis and timing analysis after the target FPGA is known.
6. Add board constraints and hardware validation when a board becomes available.

## Related work

- [Thermal digital twin](https://github.com/nicolasbogdanoff/thermal-digital-twin)
- [Heat and mass transfer models](https://github.com/nicolasbogdanoff/heat-mass-transfer-models)
- [Scientific computing with ROCm](https://github.com/nicolasbogdanoff/scientific-computing-rocm)

## Reproducibility principles

- Do not claim board-level validation before it is measured.
- Record simulator, Quartus, and Questa versions used for each result.
- Keep test vectors and expected tolerances under version control.
- Separate educational demonstrations from validated engineering models.

## License

MIT License. See [LICENSE](LICENSE).
