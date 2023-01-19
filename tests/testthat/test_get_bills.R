test_that("get_bill", {
  expect_equal(get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")$retrieved_number,
               length(jsonlite::fromJSON("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=1060120&to=1070310&proposer=孔文吉&mode=json")$date))
})
