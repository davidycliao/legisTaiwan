test_that("get_ly_committees_type basic functionality", {
  # 測試基本呼叫
  result <- get_ly_committees_type(show_progress = FALSE)

  # 檢查回傳值結構
  expect_type(result, "list")

  # 檢查資料框結構
  expect_s3_class(result$committees, "data.frame")
  expect_named(result$committees, c("代號", "名稱", "職掌", "類別"))
})

test_that("get_ly_committees_type handles parameters correctly", {
  # 測試特定參數
  result <- get_ly_committees_type(
    page = 1,
    per_page = 10,
    type = "常設委員會",
    show_progress = FALSE
  )

  # 檢查分頁設定
  expect_equal(result$metadata$current_page, 1)
  expect_equal(result$metadata$per_page, 100)

  # 檢查委員會類別
  if(nrow(result$committees) > 0) {
    expect_equal(unique(result$committees$類別), "常設委員會")
  }
})

test_that("get_ly_committees_type error handling", {
  # 測試錯誤參數
  expect_error(
    get_ly_committees_type(page = "invalid", show_progress = FALSE),
    "API request failed with status code: 500"
  )
})
