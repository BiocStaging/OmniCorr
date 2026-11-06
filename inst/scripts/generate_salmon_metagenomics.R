# Reproduce the packaged Metagenomics dataset
# from the WGCNA intermediate results.

library(dplyr)

# Load intermediate WGCNA results
stage2 <- readRDS(
  "raw-data/metagenomics/stage2results_Metagenomics.rds"
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
Metagenomics_reproduced <- as.matrix(
  aggregated[, -1, drop = FALSE]
)

rownames(Metagenomics_reproduced) <- aggregated$common

# Compare with the packaged dataset
data("Metagenomics", package = "OmniCorr")

reference <- as.matrix(Metagenomics[
  rownames(Metagenomics_reproduced),
  colnames(Metagenomics_reproduced),
  drop = FALSE
])

stopifnot(
  identical(dim(reference), dim(Metagenomics_reproduced)),
  isTRUE(all.equal(
    reference,
    Metagenomics_reproduced,
    check.attributes = FALSE
  ))
)

message("SUCCESS: Metagenomics dataset reproduced.")
