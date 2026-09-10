# RTL modules

This directory contains synthesizable SystemVerilog intended to remain portable across FPGA families during the pre-hardware phase.

## Design expectations

- Keep module interfaces explicit and documented.
- Use deterministic synchronous behavior with reset semantics stated per module.
- Keep fixed-point widths, signedness, rounding, and saturation policies visible at the interface or in a package.
- Avoid vendor primitives and device-specific constraints until the target FPGA is selected.
- Pair each functional module with a Questa testbench and host-side reference vectors.

## Planned contents

- A package for shared numeric types and fixed-point conventions.
- A compact heat/mass-transfer kernel derived from the reference models.
- Supporting arithmetic blocks only when they are required by the kernel.

## Verification status

No board-level validation is claimed yet. RTL behavior will first be checked in simulation against the host-side reference model, then synthesized after the device target is known.
