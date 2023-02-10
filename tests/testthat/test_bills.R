test_that("get_bills", {
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")$retrieved_number, 9)
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉", verbose = TRUE)$retrieved_number, 9)
  expect_error(get_bills(start_date = 1060120, end_date = 1060121, proposer = "孔文吉", verbose = FALSE), "The query is unavailable.")
})

test_that("get_bills_2", {
  expect_equal(get_bills_2(term = 8, session_period = 1)$retrieved_number, 1155)
  # expect_message(get_bills_2(c(8,10)),
  #                "The API is unable to query multiple terms and the retrieved data might not be complete.")
  expect_error(get_bills_2(term = "10"),   "use numeric format only.")
  expect_error(get_bills_2(term = "10", verbose = TRUE),   "use numeric format only.")
  expect_error(get_bills_2(term = 30, verbose = FALSE),   "The query is unavailable.")
})

