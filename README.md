# fci-upa-fpga-lab

Reproducible FPGA design and simulation labs for FCI-UPA, focused on HDL, Questa, Quartus Prime, fixed-point scientific computing, digital twins, and edge-AI preparation.

## Status

**Phase:** pre-hardware development

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
