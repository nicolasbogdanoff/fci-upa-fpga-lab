# Development roadmap

This repository is being developed in a hardware-independent phase while the target FPGA board is being confirmed.

## Current phase: simulation first

The immediate goal is to establish a reproducible flow from engineering reference models to fixed-point RTL and Questa verification. No board-level claims, pin assignments, timing closure, or JTAG programming are made until the hardware target is known.

## Milestones

1. Define numerical conventions, units, interfaces, and fixed-point formats.
2. Implement a host-side floating-point reference for the first heat/mass-transfer kernel.
3. Add fixed-point conversion, quantization analysis, and deterministic test vectors.
4. Implement a small synthesizable RTL kernel with a documented handshake and reset behavior.
5. Build a Questa testbench that compares RTL outputs with the reference model within explicit tolerances.
6. Add a device-independent Quartus project configuration and run synthesis checks.
7. Select the FPGA family and board, then add device settings, constraints, timing analysis, and hardware validation.

## Reproducibility checklist

- Record the Quartus Prime, Questa, simulator, and host-language versions used.
- Keep reference inputs, expected outputs, and tolerances under version control.
- Separate exploratory notebooks and teaching examples from validated results.
- Report whether a result is simulated, synthesized, or measured on hardware.
- Avoid board-specific files until the target device is confirmed.

## Proposed first kernel

The first applied example will connect the thermal digital twin and heat/mass-transfer models to a compact fixed-point RTL implementation. The reference model remains the numerical authority while the RTL is evaluated for functional agreement, error bounds, and resource implications.

## Open decisions

- Target FPGA family and development board.
- Clock frequency and reset strategy.
- Fixed-point word lengths and rounding/saturation policy.
- Streaming versus request/response interface.
- Questa command-line flow and supported simulator version.
