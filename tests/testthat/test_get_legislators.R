test_that("get_legislators", {
  expect_equal(nrow(get_legislators(term = 2)$data),
               nrow(jsonlite::fromJSON("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=02=&fileType=json")$dataList))
})
