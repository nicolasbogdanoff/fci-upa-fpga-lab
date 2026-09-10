import random
import unittest

from thermal_reference import Q8_8_MAX, Q8_8_MIN, clamp_q8_8, thermal_step_q8_8


class DeterministicRandomizedTests(unittest.TestCase):
    def test_integer_reference_over_random_domain(self):
        generator = random.Random(20260910)
        for _ in range(1000):
            state = generator.randint(Q8_8_MIN, Q8_8_MAX)
            target = generator.randint(Q8_8_MIN, Q8_8_MAX)
            alpha = generator.randint(0, 0xFF)
            expected = clamp_q8_8(state + ((alpha * (target - state)) >> 8))
            self.assertEqual(thermal_step_q8_8(state, target, alpha), expected)


if __name__ == "__main__":
    unittest.main()

