#' Check and align sample order between two datasets
#'
#' Ensures that two data frames or matrices contain identical samples and
#' reorders the second dataset to match the first.
#'
#' @param df1 A data frame or matrix with samples in rows (reference order)
#' @param df2 A data frame or matrix with samples in rows
#'
#' @return A list with df1 and df2 reordered to have identical rownames and order
#'
#' @examples
#' df1 <- matrix(1:6, nrow = 3,
#'               dimnames = list(c("S1", "S2", "S3"), c("A", "B")))
#' df2 <- matrix(7:12, nrow = 3,
#'               dimnames = list(c("S3", "S1", "S2"), c("C", "D")))
#' result <- check_sample_order(df1, df2)
#' result$df2
#'
#' @export
check_sample_order <- function(df1, df2) {

  # Validate inputs
  if (is.null(rownames(df1)) || is.null(rownames(df2))) {
    stop("Both df1 and df2 must have row names representing samples.")
  }

  if (anyDuplicated(rownames(df1)) || anyDuplicated(rownames(df2))) {
    stop("Duplicate sample names detected. Sample names must be unique.")
  }

  # Check sample identity
  if (!setequal(rownames(df1), rownames(df2))) {
    missing_1 <- setdiff(rownames(df1), rownames(df2))
    missing_2 <- setdiff(rownames(df2), rownames(df1))

    stop(
      "Sample sets do not match between datasets.\n",
      if (length(missing_1)) paste("Missing in df2:", paste(missing_1, collapse = ", ")) else "",
      if (length(missing_2)) paste("Missing in df1:", paste(missing_2, collapse = ", ")) else ""
    )
  }

  # Reorder df2 to match df1
  df2 <- df2[match(rownames(df1), rownames(df2)), , drop = FALSE]

  message("Sample order aligned successfully.")

  list(df1 = df1, df2 = df2)
}
