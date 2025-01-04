test_that("get_ly_ivod pagination works", {
  # Get two consecutive pages
  page1 <- get_ly_ivod(term = 9, session_period = 1, page = 1, limit = 3)
  page2 <- get_ly_ivod(term = 9, session_period = 1, page = 2, limit = 3)

  # Check page metadata
  expect_equal(page1$metadata$current_page, 1)
  expect_equal(page2$metadata$current_page, 2)

  # Check different content
  expect_false(identical(
    page1$ivods$id[1],
    page2$ivods$id[1]
  ))

  # Check consistent row count
  expect_equal(nrow(page1$ivods), 3)
  expect_equal(nrow(page2$ivods), 3)
})

test_that("get_ly_ivod data types are correct", {
  videos <- get_ly_ivod(term = 9, session_period = 1, limit = 1)

  # Check data types of key columns
  expect_type(videos$ivods$id, "character")
  expect_type(videos$ivods$url, "character")
  expect_type(videos$ivods$meeting_name, "character")
  expect_type(videos$ivods$duration, "integer")
  expect_type(videos$ivods$term, "integer")
  expect_type(videos$ivods$session_period, "integer")
})

test_that("get_ly_ivod handles empty results", {
  # Use invalid parameters to get empty results
  empty_results <- get_ly_ivod(term = 999, session_period = 999)

  # Check empty dataframe structure
  expect_s3_class(empty_results$ivods, "data.frame")
  expect_equal(nrow(empty_results$ivods), 0)
  expect_equal(empty_results$metadata$total, 0)
})

test_that("get_ly_ivod date formats are valid", {
  videos <- get_ly_ivod(term = 9, session_period = 1, limit = 5)

  # Check date format
  expect_true(all(grepl("^\\d{4}-\\d{2}-\\d{2}$", videos$ivods$date)))

  # Check time format
  expect_true(all(grepl("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\+\\d{2}:\\d{2}$",
                        videos$ivods$meeting_time)))
})

test_that("get_ly_ivod field content is valid", {
  videos <- get_ly_ivod(term = 9, session_period = 1, limit = 5)

  # Check no NULL values in critical fields
  critical_fields <- c("id", "meeting_name", "date", "term", "session_period")
  for(field in critical_fields) {
    expect_false(any(is.na(videos$ivods[[field]])))
  }

  # Check term and session values
  expect_true(all(videos$ivods$term > 0))
  expect_true(all(videos$ivods$session_period > 0))
})


test_that("get_ly_ivod metadata is consistent", {
  videos <- get_ly_ivod(term = 9, session_period = 1, limit = 5)

  # Check metadata consistency
  expect_gte(videos$metadata$total, nrow(videos$ivods))
  expect_gte(videos$metadata$total_page, 1)
  expect_equal(videos$metadata$per_page, 5)

  # Check filters used
  expect_named(videos$metadata$filters_used)
  expect_equal(videos$metadata$filters_used$term, 9)
  expect_equal(videos$metadata$filters_used$sessionPeriod, 1)
})

test_that("get_ly_ivod URL formats are valid", {
  videos <- get_ly_ivod(term = 9, session_period = 1, limit = 1)

  # Check URL format
  expect_match(videos$ivods$url, "^https://ivod\\.ly\\.gov\\.tw/Play/")
  expect_match(videos$ivods$video_url, "^https://")
})
