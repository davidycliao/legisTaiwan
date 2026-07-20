# Test infos
test_that("get_variable_info", {
  skip_on_cran()
  skip_if_not(website_availability(), "Legislative Yuan website not reachable")
  err <- tryCatch(get_variable_info("x"), error = function(e) e)
  skip_if(grepl("error from the API", conditionMessage(err), fixed = TRUE),
          "Legislative Yuan website not reachable")
  expect_match(conditionMessage(err), "Use correct function names below in character format")
})


# For get_variable_info function
test_that("get_variable_info works correctly", {
  skip_on_cran()
  skip_if_not(website_availability(), "Legislative Yuan website not reachable")
  result <- suppressWarnings(tryCatch(get_variable_info("get_bills"), error = function(e) NULL))
  skip_if(is.null(result), "Legislative Yuan website not reachable")

  # Check if the function returns a list
  expect_true(is.list(result))

  # Check if the list contains specific elements
  expect_true("page_info" %in% names(result))
  expect_true("reference_url" %in% names(result))

})

# For review_session_info function
test_that("review_session_info works correctly", {
  skip_on_cran()
  skip_if_not(website_availability2(), "Legislative Yuan website not reachable")
  result <- suppressWarnings(tryCatch(review_session_info(7), error = function(e) NULL))
  skip_if(is.null(result), "Legislative Yuan website not reachable")

  # Check if the function returns a tibble
  expect_true(is(result, "tbl_df"))

  # Check if the tibble contains specific column names (this depends on the actual column names)
  expect_true("屆期會期" %in% colnames(result)) # Replace 'ColumnName1' with actual column name

  # Check if passing an invalid term value results in an error
  expect_error(review_session_info(12), "Please provide a term number between 1 and 11.")
})
