test_that("parameter validation works", {
  # 測試缺少必要參數
  expect_error(
    get_ly_legislator_detail(name = "王金平", show_progress = FALSE),
    "term parameter is required"
  )

  expect_error(
    get_ly_legislator_detail(term = 9, show_progress = FALSE),
    "name parameter is required"
  )

  # 測試參數型別錯誤
  expect_error(
    get_ly_legislator_detail(term = "9", name = "王金平", show_progress = FALSE),
    "term must be numeric"
  )

  expect_error(
    get_ly_legislator_detail(term = 9, name = 123, show_progress = FALSE),
    "name must be character"
  )
})

test_that("basic functionality works", {
  # 測試基本功能
  result <- get_ly_legislator_detail(
    term = 9,
    name = "王金平",
    show_progress = FALSE
  )

  # 檢查回傳值結構
  expect_type(result, "list")

  # 檢查必要欄位
  expected_fields <- c(
    "term", "name", "party",
    "areaName", "partyGroup"
  )

  for(field in expected_fields) {
    expect_true(
      field %in% names(result),
      info = sprintf("Field '%s' should exist in result", field)
    )
  }

  # 檢查資料內容
  expect_equal(result$term, 9)
  expect_equal(result$name, "王金平")
})

test_that("invalid term/name combination returns error", {
  expect_error(
    get_ly_legislator_detail(
      term = 999,
      name = "不存在的立委",
      show_progress = FALSE
    ),
    "API request failed with status code: "
  )
})
