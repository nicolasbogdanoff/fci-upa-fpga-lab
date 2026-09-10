# RTL interface contract

## `thermal_kernel`

The request/response kernel accepts a transaction when `start` is asserted
while `busy` is low. It captures the fixed-point inputs, computes one update,
and asserts `done` for one clock after the busy cycle. New requests are not
accepted while `busy` is high.

## `thermal_kernel_stream`

The streaming kernel accepts one sample on every rising edge where
`valid_in=1`. The corresponding result is presented one rising edge later
with `valid_out=1`. When `valid_in=0`, no new result is produced and the last
result remains on the output bus.

Both kernels share `rtl/fixed_point_pkg.sv`:

- state and target: signed Q8.8, 16 bits;
- alpha: unsigned Q0.8, 8 bits;
- multiplication: arithmetic shift right by 8;
- output: signed 16-bit saturation.

The streaming interface is the preferred starting point for future pipelines
because it can sustain one sample per clock after reset.

