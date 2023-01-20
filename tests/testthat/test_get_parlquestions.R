test_that("get_parlquestions", {
  expect_equal(get_parlquestions(term = 8, session_period = 1, verbose = FALSE)$data,
               tibble::as_tibble(jsonlite::fromJSON("https://data.ly.gov.tw/odw/ID6Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json")$dataList))
  expect_equal(as.numeric(unique(get_parlquestions(term = 8, session_period = 1, verbose = FALSE)$data$term)),
               get_parlquestions(term = 8, session_period = 1, verbose = FALSE)$retrieved_term)
  expect_equal(as.numeric(unique(get_parlquestions(term = 8, session_period = 2, verbose = FALSE)$data$term)),
               get_parlquestions(term = 8, session_period = 2, verbose = FALSE)$retrieved_term)
  expect_equal(as.numeric(unique(get_parlquestions(term = 9, session_period = 1, verbose = FALSE)$data$term)),
               get_parlquestions(term = 9, session_period = 1, verbose = FALSE)$retrieved_term)
  expect_equal(as.numeric(unique(get_parlquestions(term = 8, session_period = 4, verbose = FALSE)$data$term)),
               get_parlquestions(term = 8, session_period = 4, verbose = FALSE)$retrieved_term)
  expect_equal(as.numeric(unique(get_parlquestions(term = 8, session_period = 4, verbose = FALSE)$data$term)),
               get_parlquestions(term = 8, session_period = 4, verbose = FALSE)$retrieved_term)
  })
