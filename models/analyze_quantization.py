"""Print a compact fixed-point quantization report for the lab scenario."""

import json

from thermal_reference import (
    alpha_from_time_constant,
    alpha_q0_8_from_time_constant,
    q8_8,
    real_from_q8_8,
    simulate_fixed,
    simulate_real,
)


def main() -> None:
    targets = [80.0] * 12
    real_values = simulate_real(20.0, targets, dt_s=1.0, tau_s=5.0)
    fixed_values = simulate_fixed(
        q8_8(20.0), [q8_8(value) for value in targets], dt_s=1.0, tau_s=5.0
    )
    errors = [
        abs(real_value - real_from_q8_8(fixed_value))
        for real_value, fixed_value in zip(real_values, fixed_values)
    ]
    report = {
        "scenario": {"initial": 20.0, "target": 80.0, "dt_s": 1.0, "tau_s": 5.0},
        "alpha_real": alpha_from_time_constant(1.0, 5.0),
        "alpha_q0_8": alpha_q0_8_from_time_constant(1.0, 5.0),
        "samples": len(errors),
        "max_abs_error": max(errors),
        "mean_abs_error": sum(errors) / len(errors),
    }
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()

