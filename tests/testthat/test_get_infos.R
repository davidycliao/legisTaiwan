test_that("get_infos", {
  expect_equal(get_infos("get_meetings")$reference_url, "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154")
  expect_equal(get_infos("get_parlquestions")$reference_url, "https://data.ly.gov.tw/getds.action?id=6")
  expect_equal(get_infos("get_executive_response")$reference_url, "https://data.ly.gov.tw/getds.action?id=2")
  expect_equal(get_infos("get_bills")$reference_url, "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153")
  expect_equal(get_infos("get_legislators")$reference_url, "https://data.ly.gov.tw/getds.action?id=16")
})
