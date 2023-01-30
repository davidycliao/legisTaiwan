test_that("get_variabel_infos", {
  expect_equal(get_variabel_infos("get_meetings")$reference_url, "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154")
  expect_equal(get_variabel_infos("get_parlquestions")$reference_url, "https://data.ly.gov.tw/getds.action?id=6")
  expect_equal(get_variabel_infos("get_executive_response")$reference_url, "https://data.ly.gov.tw/getds.action?id=2")
  expect_equal(get_variabel_infos("get_bills")$reference_url, "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153")
  expect_equal(get_variabel_infos("get_legislators")$reference_url, "https://data.ly.gov.tw/getds.action?id=16")
  expect_equal(get_variabel_infos("get_bills_2")$reference_url, "https://data.ly.gov.tw/getds.action?id=1")
  expect_equal(get_variabel_infos("get_caucus_meetings")$reference_url, "https://data.ly.gov.tw/getds.action?id=8")
  expect_equal(get_variabel_infos("get_public_debates")$reference_url, "https://data.ly.gov.tw/getds.action?id=7")
  expect_equal(get_variabel_infos("get_speech_video")$reference_url, "https://data.ly.gov.tw/getds.action?id=148")
})

test_that("get_variabel_infos", {
expect_error(get_variabel_infos("x"),
             "Use correct funtion names below in character format:
         get_bills: the records of the bills
         get_bills_2: the records of legislators and the government proposals
         get_meetings: the spoken meeting records
         get_caucus_meetings: the meeting records of cross-caucus session
         get_speech_video: the full video information of meetings and committees
         get_public_debates: the records of national public debates
         get_parlquestions:  the records of parliamentary questions
         get_executive_response: the records of the questions answered by the executives")
})
