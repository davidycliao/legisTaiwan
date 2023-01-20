test_that("check_date", {
  expect_equal(check_date("1050531"), as.Date("2016-05-31"))
  expect_equal(check_date("1050521"), as.Date("2016-05-21"))
  expect_equal(check_date("1020521"), as.Date("2013-05-21"))
})

test_that("api_check", {
  expect_equal(api_check(1031020, 1031025), api_check(1031020, 1031025))
})
