"""Guardrails against publication claims on a small embedded demonstrator."""
import csv
import io
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class DataGuards(unittest.TestCase):
    def test_fragment_is_90_records_with_explicit_target(self):
        text = (ROOT / "app.R").read_text(encoding="utf-8")
        fragment = text.split('csv_data_string <- "', 1)[1].split('"\n\n# Use check.names', 1)[0]
        reader = csv.DictReader(io.StringIO(fragment))
        rows = list(reader)
        self.assertEqual(len(rows), 90)  # hard failure if data change without provenance review
        self.assertIn("TenYearCHD", reader.fieldnames)
        self.assertTrue(all(row["TenYearCHD"] in ("0", "1") for row in rows))
        self.assertTrue(all(None not in row for row in rows))

    def test_nonclinical_labels_and_shap_background(self):
        text = (ROOT / "app.R").read_text(encoding="utf-8")
        self.assertNotIn("Live Patient Prediction", text)
        self.assertIn("not validated for patient care", text)
        self.assertIn("X = model_info$X_background, newdata = new_patient_df", text)


if __name__ == "__main__":
    unittest.main()
