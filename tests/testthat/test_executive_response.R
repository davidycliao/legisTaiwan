test_that("get_executive_response", {
  # checked Jan 23 2023
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = FALSE)$retrieved_number,
               1065)
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = TRUE)$retrieved_number,
               1065)
})




