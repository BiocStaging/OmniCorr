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
