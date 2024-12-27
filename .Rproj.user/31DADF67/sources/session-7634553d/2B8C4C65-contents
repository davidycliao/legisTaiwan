test_that("transformed_date_meeting", {
  expect_equal(transformed_date_meeting("105/05/31"), as.Date("2016-05-31"))
  expect_equal(transformed_date_meeting("105/05/21"), as.Date("2016-05-21"))
  expect_equal(transformed_date_meeting("102/05/31"), as.Date("2013-05-31"))
})

test_that("check_date", {
  expect_equal(check_date("1050531"), as.Date("2016-05-31"))
  expect_equal(check_date("1050521"), as.Date("2016-05-21"))
  expect_equal(check_date("1020521"), as.Date("2013-05-21"))
})

test_that("api_check", {
  expect_equal(api_check(check_date(1031020), check_date(1031025)),
               api_check(check_date(1031020), check_date(1031025)))
})

test_that("transformed_date_bill", {
  expect_equal(transformed_date_bill("1050531"), as.Date("2016-05-31"))
  expect_equal(transformed_date_bill("1050521"), as.Date("2016-05-21"))
  expect_equal(transformed_date_bill("1020531"), as.Date("2013-05-31"))
})

test_that("website_availability2", {
  expect_equal(website_availability2(), TRUE)
})

test_that("website_availability2", {
  expect_equal(check_date2("105/05/31"), as.Date("2016-05-31"))
})

