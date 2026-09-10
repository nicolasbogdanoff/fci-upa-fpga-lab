# Simulation flow

This directory will contain Questa testbenches, simulator scripts, wave configurations, and regression notes.

## Intended flow

1. Compile shared packages and RTL sources.
2. Elaborate the selected testbench.
3. Run deterministic stimulus and collect pass/fail results.
4. Compare RTL outputs with reference vectors from models/.
5. Record simulator version, command-line options, tolerances, and generated artifacts.

## Reproducibility rules

- Keep source lists and scripts in version control.
- Do not commit large generated waveform databases or simulator work libraries.
- Make the default regression runnable without a board or vendor device library.
- Treat waveform inspection as a debugging aid; automated checks remain the acceptance criterion.

## Planned testbenches

The first testbench will exercise the heat/mass-transfer kernel over nominal, boundary, and saturation cases and will report numerical agreement against the host-side reference model.
