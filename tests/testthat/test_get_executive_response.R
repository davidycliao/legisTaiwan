test_that("get_executive_response", {
  # checked Jan 23 2023
  expect_equal(get_executive_response(term = 10, session_period = 5, verbose = FALSE)$retrieved_number,
               320)
  expect_equal(get_executive_response(term = 10, session_period = 5, verbose = TRUE)$retrieved_number,
               320)
})
