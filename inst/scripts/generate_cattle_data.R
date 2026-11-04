# Generate cattle module eigengene dataset for OmniCorr
#
# Run from the root directory of the OmniCorr repository.
# Requires the original WGCNA results in:
# Case_Study_2/Cattle_OmniCorr/Modules_rumen.RData

# Load original WGCNA modules into a separate environment
module_env <- new.env(parent = baseenv())

load(
  "Case_Study_2/Cattle_OmniCorr/Modules_rumen.RData",
  envir = module_env
)

# Extract module eigengenes from each omics layer
modules <- list(
  Archbac = module_env$Archbac.modules$MEs,
  Ciliates = module_env$Ciliates.modules$MEs,
  Fungi = module_env$Fungi.modules$MEs,
  Metazoa = module_env$Metazoa.modules$MEs,
  Liver = module_env$MetL.modules$MEs,
  Wall = module_env$MetW.modules$MEs
)

# Identify samples shared across all six layers
common_samples <- Reduce(
  intersect,
  lapply(modules, rownames)
)

stopifnot(length(common_samples) == 20)

# Align samples and convert to data frames
cattle_data <- lapply(
  modules,
  function(x) {
    as.data.frame(x[common_samples, , drop = FALSE])
  }
)

# Save the processed dataset
saveRDS(
  cattle_data,
  file = "inst/extdata/cattle_module_eigengenes.rds"
)

message("Cattle dataset generated successfully.")
