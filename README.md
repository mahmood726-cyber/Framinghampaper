# Framingham exploratory model demonstrator

**Status: teaching/demonstration only — not a clinical prediction model and
not ready for scientific publication.** The repository contains one Shiny app
and **90 embedded example records** whose provenance, licensing and
representativeness are not independently established.

## What the app actually does

The app trains Random Forest or XGBoost **regression** models using selected
predictors (age, recorded gender, BMI) to estimate one of three continuous
outcomes (total cholesterol, systolic blood pressure, glucose). Although a
binary `TenYearCHD` column is present in the embedded table, the app **does
not model incident CHD risk** and must not be used to provide patient-level
cardiovascular risk predictions.

It uses internal 10-fold cross-validation on a very small source fragment. It
has **no independent validation**, trial-style missing-data strategy, subgroup
calibration, sensitivity study, decision-curve analysis, or verified outcome
ascertainment. The outputs and approximate fastshap contributions are
illustrative rather than scientifically supported effect explanations.

## Run

```bash
# Requires R plus shiny, shinyjs, shinythemes, ggplot2, dplyr,
# caret, randomForest, xgboost, fastshap, purrr and tibble.
Rscript -e "parse(file='app.R')"  # source-level syntax check
Rscript -e "shiny::runApp('.')"
python3 -m unittest discover -s tests -v
```

The syntax check does not verify installed dependencies or that the UI runs.
Do not upload individual patient records.

## Publication blockers

1. Identify, legally source and version the actual cohort. Verify that the
   90-row fragment may be distributed. Replace it with a correctly licensed,
   fully documented derivation or a fully synthetic demonstration dataset.
2. Define a single prespecified statistical question and appropriate model
   endpoint. The currently displayed regression outcomes are not ten-year CHD.
3. Replace demonstration-only validation with training/test separation,
   resampling that prevents tuning leakage and appropriately powered external
   validation of discrimination, calibration and clinical utility. Follow
   contemporary prediction-model reporting guidance, including uncertainty.
4. Resolve missingness, variable coding, treatment era, covariate shifts, data
   leakage and systematic bias before any predictive performance claim.
5. Test end-to-end Shiny and the SHAP visualization against supported package
   versions and reference examples. Current CI checks syntax and disclosure,
   **not** runtime or SHAP numerical validity.
6. Build a manuscript with reproducible data provenance, analysis plan, code
   environment lockfile and a genuine independent replication.

**Do not publish model performance or use the numerical outputs for clinical
decisions.** Model labels in the interface were deliberately changed from
patient-facing to demonstrator-only wording.
