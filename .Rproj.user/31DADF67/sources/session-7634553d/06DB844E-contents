test_that("get_bills", {
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")$retrieved_number, 9)
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉", verbose = TRUE)$retrieved_number, 9)
  expect_error(get_bills(start_date = 1060120, end_date = 1060121, proposer = "孔文吉", verbose = FALSE), "The query is unavailable.")
})

test_that("get_bills_2", {
  expect_equal(get_bills_2(term = 8, session_period = 1)$retrieved_number, 1155)
  expect_error(get_bills_2(c(8,10)),
                 "The API doesn't support querying multiple terms. Consider implementing batch processing. Please refer to the tutorial for guidance.")
  expect_error(get_bills_2(term = "10"),   "use numeric format only.")
  expect_error(get_bills_2(term = "10", verbose = TRUE),   "use numeric format only.")
  expect_error(get_bills_2(term = 30, verbose = FALSE),   "The query is unavailable.")
})

test_that("Testing get_bills function", {

  # Test if the function returns a list
  result <- get_bills(start_date = 1060120, end_date = 1070310, verbose = FALSE)
  expect_type(result, "list")
  # Test if get_bills throws the expected error for incorrect date format
  expect_error(get_bills(start_date = 1070310, end_date = 1060120, verbose = FALSE),
               "The start date, 2018-03-10, should not be later than the end date, 2017-01-20.")

  # Test if the function correctly handles invalid date format
  expect_error(get_bills(start_date = "10601", end_date = 1070310, verbose = FALSE),
               "Dates should be in numeric format. E.g., 1090101.")
})
