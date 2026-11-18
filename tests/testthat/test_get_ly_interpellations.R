# Test basic functionality
test_that("get_ly_interpellations basic functionality", {
  # Test basic retrieval with legislator
  results <- get_ly_interpellations(
    legislator = "趙天麟",
    limit = 5
  )

  # Test return structure
  expect_type(results, "list")
  expect_named(results, c("metadata", "interpellations"))
  expect_s3_class(results$interpellations, "data.frame")
})

# Test data structure
test_that("get_ly_interpellations returns correct data structure", {
  results <- get_ly_interpellations(
    legislator = "趙天麟",
    limit = 1
  )

  # Check expected columns exist
  expected_columns <- c(
    "id", "printed_at", "reason", "description",
    "legislators", "meet_id", "term", "sessionPeriod",
    "sessionTimes", "ppg_url", "page_start", "page_end"
  )
  expect_true(all(expected_columns %in% names(results$interpellations)))
})


# Test pagination
test_that("get_ly_interpellations pagination works", {
  # Get two consecutive pages
  page1 <- get_ly_interpellations(
    legislator = "趙天麟",
    page = 1,
    limit = 3
  )

  page2 <- get_ly_interpellations(
    legislator = "趙天麟",
    page = 2,
    limit = 3
  )

  # Check pagination metadata
  expect_equal(page1$metadata$current_page, 1)
  expect_equal(page2$metadata$current_page, 2)

  # Check different content
  expect_false(identical(
    page1$interpellations$id[1],
    page2$interpellations$id[1]
  ))
})

# Test search functionality
test_that("get_ly_interpellations search works", {
  # Search with keyword
  search_results <- get_ly_interpellations(
    query = "氫能",
    limit = 5
  )

  # Check search results
  expect_true(any(
    grepl("氫能", search_results$interpellations$reason) |
      grepl("氫能", search_results$interpellations$description)
  ))
})


# Test error handling
test_that("get_ly_interpellations handles errors", {
  # Test invalid page number
  expect_error(get_ly_interpellations(page = -1))


  # Test with non-existent legislator
  empty_results <- get_ly_interpellations(legislator = "不存在的立委")
  expect_equal(nrow(empty_results$interpellations), 0)
})

# Test term/session filters (session_times maps to a plenary meet_id)
test_that("get_ly_interpellations filters by term and session", {
  results <- get_ly_interpellations(
    term = 9, session_period = 2, session_times = 1, limit = 5,
    show_progress = FALSE
  )
  expect_gt(nrow(results$interpellations), 0)
  expect_true(all(results$interpellations$term == 9))
  expect_true(all(results$interpellations$sessionPeriod == 2))
  expect_true(all(results$interpellations$sessionTimes == 1))

  expect_error(get_ly_interpellations(session_times = 1))
})
