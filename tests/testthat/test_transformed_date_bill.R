test_that("transformed_date_bill", {
  expect_equal(transformed_date_bill("1050531"), as.Date("2016-05-31"))
  expect_equal(transformed_date_bill("1050521"), as.Date("2016-05-21"))
  expect_equal(transformed_date_bill("1020531"), as.Date("2013-05-31"))
})
