import unittest

from thermal_reference import (
    alpha_from_time_constant,
    alpha_q0_8_from_time_constant,
    clamp_q8_8,
    q8_8,
    real_from_q8_8,
    simulate_fixed,
    simulate_real,
    thermal_step_q8_8,
)


class ThermalReferenceTests(unittest.TestCase):
    def test_nominal_updates(self):
        self.assertEqual(thermal_step_q8_8(0, 256, 64), 64)
        self.assertEqual(thermal_step_q8_8(64, 256, 128), 160)
        self.assertEqual(thermal_step_q8_8(-512, 512, 64), -256)

    def test_saturation(self):
        self.assertEqual(clamp_q8_8(40000), 32767)
        self.assertEqual(clamp_q8_8(-40000), -32768)

    def test_alpha_validation(self):
        with self.assertRaises(ValueError):
            thermal_step_q8_8(0, 256, 256)

    def test_physical_relaxation_factor(self):
        alpha = alpha_from_time_constant(1.0, 5.0)
        self.assertAlmostEqual(alpha, 0.181269, places=5)
        self.assertEqual(alpha_q0_8_from_time_constant(1.0, 5.0), 46)

    def test_fixed_trajectory_matches_real_model(self):
        targets = [80.0] * 12
        real_values = simulate_real(20.0, targets, dt_s=1.0, tau_s=5.0)
        fixed_values = simulate_fixed(
            q8_8(20.0), [q8_8(target) for target in targets], dt_s=1.0, tau_s=5.0
        )
        for real_value, fixed_value in zip(real_values, fixed_values):
            self.assertLess(abs(real_value - real_from_q8_8(fixed_value)), 0.25)


if __name__ == "__main__":
    unittest.main()
