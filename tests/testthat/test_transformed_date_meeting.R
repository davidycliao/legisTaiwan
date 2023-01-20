test_that("transformed_date_meeting", {
  expect_equal(transformed_date_meeting("105/05/31"), as.Date("2016-05-31"))
  expect_equal(transformed_date_meeting("105/05/21"), as.Date("2016-05-21"))
  expect_equal(transformed_date_meeting("102/05/31"), as.Date("2013-05-31"))
})
