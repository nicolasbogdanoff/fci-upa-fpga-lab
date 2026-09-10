# Quartus project notes

This directory will contain device-independent Quartus project notes and, once the target FPGA is confirmed, the corresponding project files, assignments, constraints, and reports.

## Pre-hardware policy

Do not add a device family, part number, pin map, clock constraint, or board programming setup until the development board is selected. The project should remain useful for source organization and simulation before that decision.

## Planned flow

1. Keep source lists and top-level names aligned with the portable RTL.
2. Record the Quartus Prime edition and version used for each synthesis run.
3. Add the confirmed device and board settings in a separate, reviewable change.
4. Capture synthesis, fitting, timing, and resource reports with the design revision.
5. Distinguish estimated or simulated results from measured hardware behavior.

## Expected artifacts

- Device-specific project configuration after hardware selection.
- Pin and timing constraints after the board interface is known.
- Reproducible command-line or GUI instructions for compilation.
- Reports sufficient to relate resource use and timing to a specific revision.
