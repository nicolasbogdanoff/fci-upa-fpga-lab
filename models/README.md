# Reference models

This directory contains host-side numerical models, fixed-point conversion helpers, deterministic test vectors, and error-analysis notes.

## Role of the reference model

The floating-point implementation is the numerical reference for the first heat/mass-transfer kernel. RTL results must be compared against documented expected values and tolerances rather than judged from waveform appearance alone.

## Planned contents

- A clear floating-point baseline with units and assumptions stated.
- Fixed-point conversion utilities with explicit rounding and saturation behavior.
- Small, reviewable test-vector files shared by host-side checks and Questa simulations.
- Error summaries covering quantization, boundary cases, and accumulated deviations.

## Data conventions

Every vector should document its units, scale, signedness, word length where applicable, and expected tolerance. Generated data should be reproducible from a checked-in source or script.

## Validation boundary

These models are engineering references for simulation and teaching. They do not by themselves constitute measured validation of a physical process or FPGA board.
