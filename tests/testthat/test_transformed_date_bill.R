
test_that("transformed_date_bill", {
  expect_equal(transformed_date_bill("1050531"), as.Date("2016-05-31"))
})
