test_that("get_legislators", {
  skip_on_cran()
  result <- suppressWarnings(tryCatch(get_legislators(term = 2), error = function(e) NULL))
  skip_if(is.null(result), "Legislative Yuan API not reachable")

  expect_equal(nrow(result$data), 165)
  expect_equal(result$queried_term, "2")
  expect_equal(get_legislators(term = 2, verbose = FALSE)$queried_term, "2")
  expect_equal(get_legislators(term = 8)$queried_term, "8")
  expect_error(get_legislators(term = 30)$queried_term, "Query returned no data.")
  })
