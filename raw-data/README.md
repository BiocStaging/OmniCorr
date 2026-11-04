### Reproducibility and raw data processing

The example datasets included in `data/` (salmon multi-omics data) are derived from raw sequencing and count data using preprocessing workflows.

The `raw-data/` directory contains the original input files and preprocessing scripts, including normalization, filtering, and WGCNA-based feature clustering steps. These materials document the main preprocessing workflows, while additional steps required to reproduce the packaged omics datasets are being clarified.

### Salmon phenotypic metadata

The packaged `metadata` dataset (`data/metadata.rda`) was generated from `raw-data/transcriptomics/sample_info.csv`.

Individual fish measurements were grouped by sampling time (`Time`), dietary treatment (`New_Diet`), and tank (`Tank_number`). The mean of each of the 14 phenotypic variables was calculated within each group, without removing missing values (`mean(x)` with the default `na.rm = FALSE`).

The resulting dataset contains 36 groups and 14 phenotypic variables.

The generation script is available at `inst/scripts/generate_salmon_metadata.R` and can be executed from the root of the OmniCorr repository.
