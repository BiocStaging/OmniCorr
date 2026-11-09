
# Reproduce the packaged Transcriptomics dataset
# from the WGCNA intermediate results.

library(dplyr)

# Load intermediate WGCNA results
stage2 <- readRDS(
  "raw-data/transcriptomics/stage2results_Transcriptomics_Liver.rds"
)

# Extract module eigengenes, excluding the grey module
MEs <- stage2$modules$MEs

MEs <- MEs[
  , colnames(MEs) != "ME0",
  drop = FALSE
]

# Identify tanks by removing sample-number suffixes
tank_ids <- sub("_[0-9]{1,2}$", "", rownames(MEs))

# Average module eigengenes within each tank
aggregated <- as.data.frame(MEs) %>%
  mutate(common = tank_ids) %>%
  group_by(common) %>%
  summarise(across(everything(), mean), .groups = "drop")

# Convert to a matrix with tank identifiers as row names
Transcriptomics_reproduced <- as.matrix(
  aggregated[, -1, drop = FALSE]
)

rownames(Transcriptomics_reproduced) <- aggregated$common

# Compare with the packaged dataset
data("Transcriptomics", package = "OmniCorr")

reference <- as.matrix(Transcriptomics[
  rownames(Transcriptomics_reproduced),
  colnames(Transcriptomics_reproduced),
  drop = FALSE
])

stopifnot(
  identical(dim(reference), dim(Transcriptomics_reproduced)),
  isTRUE(all.equal(
    reference,
    Transcriptomics_reproduced,
    check.attributes = FALSE
  ))
)

message("SUCCESS: Transcriptomics dataset reproduced.")
