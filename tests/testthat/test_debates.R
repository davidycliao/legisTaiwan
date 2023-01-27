test_that("get_public_debates", {
  expect_equal(get_public_debates(term = 10, session_period = 1)$retrieved_number, 107)
  expect_equal(get_public_debates(term = 10, session_period = 1, verbose = FALSE)$retrieved_number, 107)
})
