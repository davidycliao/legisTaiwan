test_that("get_legislators", {
  expect_equal(nrow(get_legislators(term = 2)$data), 165)
  expect_equal(get_legislators(term = 2)$queried_term, "2")
  expect_equal(get_legislators(term = 2, verbose = FALSE)$queried_term, "2")
  expect_equal(get_legislators(term = 8)$queried_term, "8")
  expect_error(get_legislators(term = 30)$queried_term, "The query is unavailable.")
  })

test_that("get_legislators", {
  expect_message(get_legislators(c(6, 5)),
               "The API is unable to query multiple terms and the retrieved data might not be complete.")
})
