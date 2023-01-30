test_that("get_legislators", {
  expect_equal(nrow(get_legislators(term = 2)$data), 165)
  expect_equal(get_legislators(term = 2)$url, "https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=02=&fileType=json")
  expect_equal(get_legislators(term = 2, verbose = FALSE)$url, "https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=02=&fileType=json")
  expect_equal(get_legislators(term = 8)$queried_term, "8")
})
