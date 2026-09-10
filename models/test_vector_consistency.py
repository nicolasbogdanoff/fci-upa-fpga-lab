import csv
import unittest
from pathlib import Path

from thermal_reference import q8_8, thermal_step_q8_8


class GeneratedVectorConsistencyTests(unittest.TestCase):
    def test_csv_matches_reference_model(self):
        vector_file = Path(__file__).with_name("thermal_vectors.csv")
        with vector_file.open(newline="", encoding="utf-8") as handle:
            rows = list(csv.DictReader(handle))

        self.assertEqual(len(rows), 12)
        state = q8_8(20.0)
        alpha_q0_8 = 46

        for expected_sample, row in enumerate(rows):
            self.assertEqual(int(row["sample"]), expected_sample)
            target = int(row["target_q8_8"])
            expected = thermal_step_q8_8(state, target, alpha_q0_8)
            self.assertEqual(int(row["result_q8_8"]), expected)
            state = expected


if __name__ == "__main__":
    unittest.main()

