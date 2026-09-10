# First laboratory: fixed-point thermal response

## Purpose

This laboratory connects a first-order thermal response model to portable
SystemVerilog. It is intentionally independent of a specific FPGA board.

The continuous-time intuition is a state approaching a target with time
constant `tau`. For a sampling interval `dt`, the exact discrete relaxation
factor is:

```text
alpha = 1 - exp(-dt / tau)
```

The RTL uses signed Q8.8 for the state and target, and unsigned Q0.8 for
`alpha`. One update is:

```text
state_next = state + ((alpha * (target - state)) >>> 8)
```

## Reproducible flow

1. Run the Python reference tests.
2. Generate `models/thermal_vectors.csv`.
3. Run the single-transaction RTL testbench.
4. Run the streaming RTL testbench, which accepts one sample per clock.
5. Review the shared arithmetic package and interface contract.
6. Record simulator and Quartus versions before comparing results.

The Python model is the numerical reference. The RTL is accepted only when
its fixed-point results agree with the documented vectors and latency.

## Current limits

The model is an educational first-order response, not a measured physical
plant. Board-specific clock, pin, ADC, sensor, and timing behavior remain out
of scope until an FPGA board and target device are selected.
