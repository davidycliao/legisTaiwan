test_that("get_bill", {
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")$retrieved_number, 9)
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉", verbose = TRUE)$retrieved_number, 9)
})

test_that("get_bills_2", {
  expect_equal(get_bills_2(term = 8, session_period = 1)$retrieved_number, 1155)
  expect_equal(get_bills_2(term = 8, session_period = 1, verbose = FALSE)$retrieved_number, 1155)
  # expect_equal(get_bills_2()$title, "the records of the questions answered by the executives")
})

# test_that("get_bills_2", {
#   expect_equal(get_bills_2()$title, "the records of the questions answered by the executives")
# })
