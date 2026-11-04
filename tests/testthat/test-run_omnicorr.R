test_that("run_omnicorr returns a HeatmapList", {

  set.seed(123)

  samples <- paste0("S", 1:6)

  reference <- matrix(
    rnorm(30),
    nrow = 6,
    dimnames = list(samples, paste0("Gene", 1:5))
  )

  comparison <- matrix(
    rnorm(24),
    nrow = 6,
    dimnames = list(samples, paste0("Taxon", 1:4))
  )

  result <- run_omnicorr(
    reference_layer = reference,
    comparison_layers = list(Microbiome = comparison),
    cluster_reference_rows = FALSE,
    cluster_reference_columns = FALSE,
    verbose = FALSE
  )

  expect_s4_class(result, "HeatmapList")
})

test_that("run_omnicorr rejects mismatched sample order", {

  reference <- matrix(
    1:12,
    nrow = 4,
    dimnames = list(
      paste0("S", 1:4),
      paste0("Gene", 1:3)
    )
  )

  comparison <- matrix(
    1:12,
    nrow = 4,
    dimnames = list(
      c("S2", "S1", "S3", "S4"),
      paste0("Taxon", 1:3)
    )
  )

  expect_error(
    run_omnicorr(
      reference_layer = reference,
      comparison_layers = list(Microbiome = comparison),
      verbose = FALSE
    ),
    "Sample order mismatch"
  )
})

test_that("run_omnicorr requires named comparison layers", {

  reference <- matrix(
    1:12,
    nrow = 4,
    dimnames = list(
      paste0("S", 1:4),
      paste0("Gene", 1:3)
    )
  )

  expect_error(
    run_omnicorr(
      reference_layer = reference,
      comparison_layers = list(reference),
      verbose = FALSE
    ),
    "comparison_layers must have names"
  )
})

test_that("run_omnicorr supports SummarizedExperiment", {

  set.seed(123)

  samples <- paste0("S", 1:10)

  mat1 <- matrix(
    rnorm(50),
    nrow = 5,
    dimnames = list(paste0("Gene", 1:5), samples)
  )

  mat2 <- matrix(
    rnorm(40),
    nrow = 4,
    dimnames = list(paste0("Protein", 1:4), samples)
  )

  se1 <- SummarizedExperiment::SummarizedExperiment(
    assays = list(counts = mat1)
  )

  se2 <- SummarizedExperiment::SummarizedExperiment(
    assays = list(counts = mat2)
  )

  # Verify that the function accepts SummarizedExperiment inputs
  ht <- run_omnicorr(
    reference_layer = se1,
    comparison_layers = list(Proteomics = se2),
    verbose = FALSE
  )

  expect_s4_class(ht, "HeatmapList")

  # Verify that misaligned samples are rejected
  se2_wrong <- se2[, 10:1]

  expect_error(
    run_omnicorr(
      reference_layer = se1,
      comparison_layers = list(Proteomics = se2_wrong),
      verbose = FALSE
    ),
    "Sample order mismatch"
  )
})
