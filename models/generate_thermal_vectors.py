"""Generate deterministic vectors for the first thermal response lab."""

import csv
from pathlib import Path

from thermal_reference import q8_8, simulate_fixed


def main() -> None:
    output = Path(__file__).with_name("thermal_vectors.csv")
    targets = [80.0] * 12
    target_q8_8 = [q8_8(value) for value in targets]
    states = simulate_fixed(q8_8(20.0), target_q8_8, dt_s=1.0, tau_s=5.0)

    with output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(["sample", "target_q8_8", "result_q8_8"])
        for index, (target, result) in enumerate(zip(target_q8_8, states)):
            writer.writerow([index, target, result])
    print(f"Wrote {len(states)} vectors to {output}")


if __name__ == "__main__":
    main()

