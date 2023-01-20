test_that("get_meetings", {
  expect_equal(get_meetings(start_date = 1050120, end_date = 1050210, verbose = FALSE)$data$smeeting_date,
               jsonlite::fromJSON("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1050120&to=1050210&meeting_unit=&mode=json")$smeeting_date)
  expect_equal(nrow(get_meetings(start_date = 1050120, end_date = 1050210, verbose = FALSE)$data),
               nrow(jsonlite::fromJSON("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1050120&to=1050210&meeting_unit=&mode=json")))
  expect_equal(nrow(get_meetings(start_date = 1040120, end_date = 1050310, verbose = FALSE)$data),
               nrow(jsonlite::fromJSON("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1040120&to=1050310&meeting_unit=&mode=json")))
  expect_equal(nrow(get_meetings(start_date = 1040120, end_date = 1050310, verbose = TRUE)$data),
               nrow(jsonlite::fromJSON("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1040120&to=1050310&meeting_unit=&mode=json")))
})
