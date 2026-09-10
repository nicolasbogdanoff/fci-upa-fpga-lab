"""Reference models for the first fixed-point thermal kernel lab.

The state and target use signed Q8.8 values. Alpha uses unsigned Q0.8,
so 255 represents 255/256. The integer implementation is intentionally
kept identical to the arithmetic used by the SystemVerilog RTL.
The physical abstraction is a first-order thermal response. It is useful for
the lab because it has a clear continuous-time interpretation while reducing
to the same integer relaxation operation implemented by the RTL.
"""

import math

Q8_8_MIN = -(1 << 15)
Q8_8_MAX = (1 << 15) - 1


def clamp_q8_8(value: int) -> int:
    """Clamp an integer to the signed 16-bit Q8.8 range."""
    return max(Q8_8_MIN, min(Q8_8_MAX, value))


def thermal_step_q8_8(state_q8_8: int, target_q8_8: int, alpha_q0_8: int) -> int:
    """Compute one update: state + alpha * (target - state)."""
    if not 0 <= alpha_q0_8 <= 0xFF:
        raise ValueError("alpha_q0_8 must be in the range 0..255")
    delta = target_q8_8 - state_q8_8
    candidate = state_q8_8 + ((alpha_q0_8 * delta) >> 8)
    return clamp_q8_8(candidate)


def q8_8(value: float) -> int:
    """Convert a real value to Q8.8 with saturation."""
    return clamp_q8_8(round(value * 256))


def real_from_q8_8(value: int) -> float:
    """Convert a Q8.8 integer to a real value."""
    return value / 256.0


def alpha_from_time_constant(dt_s: float, tau_s: float) -> float:
    """Return the exact discrete relaxation factor for a time step."""
    if dt_s <= 0 or tau_s <= 0:
        raise ValueError("dt_s and tau_s must be positive")
    return 1.0 - math.exp(-dt_s / tau_s)


def alpha_q0_8_from_time_constant(dt_s: float, tau_s: float) -> int:
    """Quantize the physical relaxation factor to unsigned Q0.8."""
    return max(0, min(0xFF, round(alpha_from_time_constant(dt_s, tau_s) * 256)))


def simulate_real(initial: float, targets: list[float], dt_s: float, tau_s: float) -> list[float]:
    """Simulate a first-order response in real-valued units."""
    alpha = alpha_from_time_constant(dt_s, tau_s)
    state = initial
    result = []
    for target in targets:
        state += alpha * (target - state)
        result.append(state)
    return result


def simulate_fixed(
    initial_q8_8: int,
    targets_q8_8: list[int],
    dt_s: float,
    tau_s: float,
) -> list[int]:
    """Simulate the same response using the RTL's fixed-point arithmetic."""
    alpha = alpha_q0_8_from_time_constant(dt_s, tau_s)
    state = initial_q8_8
    result = []
    for target in targets_q8_8:
        state = thermal_step_q8_8(state, target, alpha)
        result.append(state)
    return result
