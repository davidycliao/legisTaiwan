# Test basic functionality
test_that("get_ly_legislator_bills basic functionality", {
  # Test basic retrieval
  bills <- get_ly_legislator_bills(
    term = 9,
    name = "王金平",
    limit = 5
  )

  # Check return structure
  expect_type(bills, "list")
  expect_named(bills, c("metadata", "bills"))
  expect_s3_class(bills$bills, "data.frame")

  # Check metadata structure
  expect_type(bills$metadata, "list")
  expect_named(bills$metadata,
               c("total", "total_page", "current_page", "per_page"))
})

# Test data structure
test_that("get_ly_legislator_bills returns correct data structure", {
  bills <- get_ly_legislator_bills(
    term = 9,
    name = "王金平",
    limit = 1
  )

  # Check required columns
  expected_columns <- c(
    "billNo", "議案名稱", "提案單位", "議案狀態",
    "議案類別", "提案來源", "meet_id", "會期",
    "字號", "提案編號", "屆期", "mtime"
  )

  expect_true(all(expected_columns %in% names(bills$bills)))
})

# Test parameter validation
test_that("get_ly_legislator_bills validates parameters", {
  # Test missing parameters
  expect_error(get_ly_legislator_bills())
  expect_error(get_ly_legislator_bills(term = 9))
  expect_error(get_ly_legislator_bills(name = "王金平"))

  # Test invalid parameter types
  expect_error(get_ly_legislator_bills(term = "9", name = "王金平"))
  expect_error(get_ly_legislator_bills(term = 9, name = 123))
})

# Test pagination
test_that("get_ly_legislator_bills pagination works", {
  # Get two consecutive pages
  page1 <- get_ly_legislator_bills(
    term = 9,
    name = "王金平",
    page = 1,
    limit = 3
  )

  page2 <- get_ly_legislator_bills(
    term = 9,
    name = "王金平",
    page = 2,
    limit = 3
  )

  # Check pagination metadata
  expect_equal(page1$metadata$current_page, 1)
  expect_equal(page2$metadata$current_page, 2)
  expect_equal(nrow(page1$bills), 3)

  # Check different content
  if(nrow(page2$bills) > 0) {
    expect_false(identical(
      page1$bills$billNo[1],
      page2$bills$billNo[1]
    ))
  }
})

# Test data types
test_that("get_ly_legislator_bills returns correct data types", {
  bills <- get_ly_legislator_bills(
    term = 9,
    name = "王金平",
    limit = 1
  )

  if(nrow(bills$bills) > 0) {
    # Check column types
    expect_type(bills$bills$billNo, "character")
    expect_type(bills$bills$議案名稱, "character")
    expect_type(bills$bills$提案單位, "character")
    expect_type(bills$bills$會期, "integer")
    expect_type(bills$bills$屆期, "integer")
  }
})

# Test error handling
test_that("get_ly_legislator_bills handles errors properly", {
  # Test non-existent term/name combination
  expect_error(
    get_ly_legislator_bills(
      term = 999,
      name = "不存在的立委"
    )
  )

  # Test invalid page number
  expect_error(
    get_ly_legislator_bills(
      term = 9,
      name = "王金平",
      page = -1
    )
  )
})

# Test empty results handling
test_that("get_ly_legislator_bills handles empty results", {
  # Test with unlikely combination
  result <- get_ly_legislator_bills(
    term = 9,
    name = "不太可能存在的立委",
    limit = 5
  )

  # Check empty structure
  expect_equal(nrow(result$bills), 0)
  expect_equal(result$metadata$total, 0)
})
