#' Example Transcriptomics dataset
#'
#' A processed transcriptomics expression matrix used as an example
#' input for OmniCorr. Rows correspond to samples and columns to
#' transcript-level features.
#'
#' @format A numeric matrix with samples as rows and features as columns.
#' @source Derived from published cow rumen multi-omics analysis.
"Transcriptomics"

#' Example Metagenomics dataset
#'
#' A processed metagenomics feature-abundance matrix used as an example
#' input for OmniCorr.
#'
#' @format A numeric matrix with samples as rows and features as columns.
#' @source Derived from published cow rumen multi-omics analysis.
"Metagenomics"

#' Salmon Metatranscriptomics Dataset
#'
#' A processed metatranscriptomics dataset containing WGCNA module
#' eigengenes derived from salmon metatranscriptomic data.
#'
#' The original count data were variance-stabilized using DESeq2,
#' followed by weighted gene co-expression network analysis (WGCNA).
#' Module eigengenes were averaged at the tank level.
#'
#' @format A data.frame with 36 samples (rows) and 11 module
#'   eigengenes (columns).
#'
#' @source Salmon metatranscriptomics data provided by Shashank Gupta.
#'   The input dataset is available in
#'   \code{raw-data/metatranscriptomics/metatranscriptomics.rds}.
#'   The reproducibility script is available in
#'   \code{inst/scripts/generate_salmon_metatranscriptomics.R}.
"Metatranscriptomics"
