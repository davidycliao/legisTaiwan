test_that("get_ly_legislators_by_term basic functionality", {
  # Test basic retrieval
  results <- get_ly_legislators_by_term(term = 9, limit = 5)

  # Test return structure
  expect_type(results, "list")
  expect_named(results, c("metadata", "legislators"))
  expect_s3_class(results$legislators, "data.frame")
})

test_that("get_ly_legislators_by_term parameter validation", {
  # Test missing term
  expect_error(get_ly_legislators_by_term())

  # Test invalid term type
  expect_error(get_ly_legislators_by_term(term = "9"))

  # Test invalid term value
  # expect_error(get_ly_legislators_by_term(term = -1))
})

test_that("get_ly_legislators_by_term metadata structure", {
  results <- get_ly_legislators_by_term(term = 9, limit = 5)

  # Check metadata components
  expect_named(
    results$metadata,
    c("total", "total_page", "current_page", "per_page")
  )

  # Check metadata types
  expect_type(results$metadata$total, "integer")
  expect_type(results$metadata$total_page, "integer")
  expect_equal(results$metadata$per_page, 5)
})

test_that("get_ly_legislators_by_term pagination", {
  # Get two consecutive pages
  page1 <- get_ly_legislators_by_term(term = 9, page = 1, limit = 3)
  page2 <- get_ly_legislators_by_term(term = 9, page = 2, limit = 3)

  # Check pagination metadata
  expect_equal(page1$metadata$current_page, 1)
  expect_equal(page2$metadata$current_page, 2)

  # Check row counts
  expect_equal(nrow(page1$legislators), 3)
  expect_equal(nrow(page2$legislators), 3)

  # Check different content
  expect_false(identical(
    page1$legislators[1,],
    page2$legislators[1,]
  ))
})
