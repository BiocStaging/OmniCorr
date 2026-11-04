# Cattle case study: Original WGCNA workflow

This directory contains the original WGCNA workflow used to generate the cattle module eigengenes included in the OmniCorr package.

## Input data

The analysis requires the following files in the `data/` directory:

- `archbac.RData`: Archaeal and bacterial proteomics
- `ciliates.RData`: Ciliate proteomics
- `fungi.RData`: Fungal proteomics
- `metazoa.RData`: Metazoan proteomics
- `metL.RData`: Host liver proteomics
- `metW.RData`: Host rumen wall proteomics
- `annoD.RData`: Annotation data
- `metadata.RData`: Sample metadata

The original datasets are not distributed with the OmniCorr package. Access to these files is required to rerun the WGCNA analysis.

## Workflow

The original analysis is provided in `Rumen_OmniCorr.Rmd`.

WGCNA was performed separately for each omics layer using its available samples. The resulting module eigengenes were subsequently aligned by sample identifiers, retaining the 20 samples shared across all six proteomics layers.

The original workflow also references `Modules_rumen.RData`, a saved intermediate analysis file that is not distributed with the package.

## Reproducing the OmniCorr analysis

For users interested in reproducing the OmniCorr integration without rerunning WGCNA, the processed module eigengenes are available in the OmniCorr repository at:

`inst/extdata/cattle_module_eigengenes.rds`

The executable example is provided in the `vignettes` directory of the OmniCorr repository at:

`vignettes/cattle_workflow.Rmd`

Both paths are relative to the root directory of the OmniCorr repository.

This allows the OmniCorr analysis to be reproduced using the distributed processed data without access to the original proteomics datasets.

### Reproducing the processed cattle dataset

The processed module eigengenes distributed with OmniCorr can be regenerated from the original WGCNA results using:

`inst/scripts/generate_cattle_data.R`

Run this script from the root directory of the OmniCorr repository. It loads `Case_Study_2/Cattle_OmniCorr/Modules_rumen.RData`, extracts the module eigengenes from all six omics layers, and retains the 20 samples shared across the layers.

The resulting dataset is saved as `inst/extdata/cattle_module_eigengenes.rds`.

The regenerated dataset was verified to be identical to the distributed dataset.
