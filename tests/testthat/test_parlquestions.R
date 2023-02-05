# test_that("get_parlquestions", {
#   expect_equal(get_parlquestions(term = 8, session_period = 1, verbose = FALSE)$data,
#                tibble::as_tibble(jsonlite::fromJSON("https://data.ly.gov.tw/odw/ID6Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json")$dataList))
#   expect_equal(get_parlquestions(term = 8, session_period = 1, verbose = TRUE)$data,
#                tibble::as_tibble(jsonlite::fromJSON("https://data.ly.gov.tw/odw/ID6Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json")$dataList))
#
#   })

test_that("get_executive_response", {
  # checked Jan 23 2023
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = FALSE)$retrieved_number,
               1065)
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = TRUE)$retrieved_number,
               1065)
})
