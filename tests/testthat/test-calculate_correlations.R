test_that("calculate_correlations returns correlation matrix", {

  df1 <- matrix(
    c(1, 2, 3, 4, 5,
      5, 4, 3, 2, 1),
    nrow = 5,
    dimnames = list(NULL, c("A", "B"))
  )

  df2 <- matrix(
    c(2, 4, 6, 8, 10,
      10, 8, 6, 4, 2),
    nrow = 5,
    dimnames = list(NULL, c("C", "D"))
  )

  result <- calculate_correlations(df1, df2)

  expect_true(is.matrix(result$correlation))
  expect_equal(dim(result$correlation), c(2, 2))
  expect_equal(result$correlation[1, 1], 1)
  expect_equal(result$correlation[1, 2], -1)
})


test_that("calculate_correlations returns p-values", {

  df1 <- matrix(
    c(1, 2, 3, 4, 5),
    nrow = 5,
    dimnames = list(NULL, "A")
  )

  df2 <- matrix(
    c(2, 4, 6, 8, 10),
    nrow = 5,
    dimnames = list(NULL, "B")
  )

  result <- calculate_correlations(
    df1,
    df2,
    show_significance = "p_value"
  )

  expect_true(is.matrix(result$p_value))
  expect_equal(dim(result$p_value), c(1, 1))
  expect_true(result$p_value[1, 1] < 0.05)
})


test_that("calculate_correlations supports Kendall correlation", {

  df1 <- matrix(
    c(1, 2, 3, 4, 5),
    nrow = 5,
    dimnames = list(NULL, "A")
  )

  df2 <- matrix(
    c(2, 4, 6, 8, 10),
    nrow = 5,
    dimnames = list(NULL, "B")
  )

  result <- calculate_correlations(
    df1,
    df2,
    method = "kendall"
  )

  expect_equal(result$correlation[1, 1], 1)
})


test_that("calculate_correlations rejects mismatched sample numbers", {

  df1 <- matrix(1:10, nrow = 5)
  df2 <- matrix(1:12, nrow = 6)

  expect_error(
    calculate_correlations(df1, df2),
    "same number of rows \\(samples\\)"
  )
})

test_that("calculate_correlations supports SummarizedExperiment", {

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

  result <- calculate_correlations(se1, se2)

  expect_equal(dim(result$correlation), c(5L, 4L))
  expect_identical(
    rownames(result$correlation),
    paste0("Gene", 1:5)
  )
  expect_identical(
    colnames(result$correlation),
    paste0("Protein", 1:4)
  )

  # Confirm that sample misalignment produces an error
  se2_wrong <- se2[, 10:1]

  expect_error(
    calculate_correlations(se1, se2_wrong),
    "Sample identifiers"
  )
})
