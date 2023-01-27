test_that("get_meetings", {
  expect_equal(get_meetings(start_date = 1050120, end_date = 1050210, verbose = FALSE)$data$smeeting_date, "105/02/01")
  expect_equal(nrow(get_meetings(start_date = 1050120, end_date = 1050210, verbose = FALSE)$data), 1)
  expect_equal(nrow(get_meetings(start_date = 1040120, end_date = 1050310, verbose = FALSE)$data), 807)
  expect_equal(nrow(get_meetings(start_date = 1040120, end_date = 1050310, verbose = TRUE)$data), 807)
})

test_that("get_caucus_meetings", {
  expect_equal(get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")$retrieved_number, 30)
  expect_equal(get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10", verbose = FALSE)$retrieved_number ,30)

})
