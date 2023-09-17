test_that("get_parlquestions", {
  # expect_equal(get_parlquestions(term = 8, session_period = 1, verbose = FALSE)$title, "the records of parliarmentary questions")
  # expect_equal(get_parlquestions(term = 8, session_period = 1, verbose = TRUE)$retrieved_number, 957)
  expect_error(get_parlquestions(term = "9", verbose = FALSE),  "use numeric format only.")
  expect_equal(get_parlquestions(NULL)$url, "https://data.ly.gov.tw/odw/ID6Action.action?term=&sessionPeriod=&sessionTimes=&item=&fileType=json")
  expect_error(get_parlquestions(c(8,9)))
  expect_error(get_parlquestions(30), "The query is unavailable.")
})

test_that("get_executive_response", {
  # checked 23 Jan 2023
  # checked 16 Sep 2023
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = FALSE)$retrieved_number,
               1065)
  expect_equal(get_executive_response(term = 8, session_period = 1, verbose = TRUE)$retrieved_number,
               1065)
  expect_error(get_executive_response(term = "9"),  "use numeric format only.")
  expect_error(get_executive_response(c(8,9)),
                 "The API is unable to query multiple terms.")
  expect_error(get_executive_response(30), "The query is unavailable.")

})
