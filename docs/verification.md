# Verification strategy

The project uses three complementary verification layers.

## 1. Reference model

Python tests validate the physical first-order response, fixed-point
conversion, saturation, trajectory error, and generated CSV vectors.

## 2. RTL simulation

Questa compiles both the request/response kernel and the streaming kernel.
The testbenches check numerical outputs, fixed-point arithmetic, reset
behavior, transaction latency, and six consecutive streaming samples.

The Starter Edition license permits one active session. Close the Questa GUI
before running the console regression.

## 3. Continuous integration

The GitHub Actions workflow runs the Python reference tests and confirms that
the checked-in vectors are reproducible. Questa is intentionally not invoked
in CI because its license is local to the development machine.

## Local command

From the repository root:

```text
powershell -ExecutionPolicy Bypass -File .\scripts\run_local_checks.ps1
```

To run the host-side checks while keeping Questa open:

```text
powershell -ExecutionPolicy Bypass -File .\scripts\run_local_checks.ps1 -SkipSimulation
```

