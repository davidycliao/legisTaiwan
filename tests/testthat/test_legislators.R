test_that("get_legislators", {
  expect_equal(nrow(get_legislators(term = 2)$data),
               nrow(jsonlite::fromJSON("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=02=&fileType=json")$dataList))
  expect_equal(get_legislators(term = 2)$url,
               "https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=02=&fileType=json")
  expect_equal(get_legislators()$url,
               "https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term==&fileType=json")
  expect_equal(get_legislators(term = c(8,9))$queried_term,
               "8")
})


