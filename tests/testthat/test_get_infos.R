# Test infos
test_that("get_variable_info", {
expect_error(get_variable_info("x"),
               "Use correct function names below in character format:
          get_bills: the records of the bills
          get_bills_2: the records of legislators and the government proposals
          get_meetings: the spoken meeting records
          get_caucus_meetings: the meeting records of cross-caucus session
          get_speech_video: the full video information of meetings and committees
          get_public_debates: the records of national public debates
          get_parlquestions: the records of parliamentary questions
          get_executive_response: the records of the questions answered by the executives")
})



# For get_variable_info function
test_that("get_variable_info works correctly", {
  result <- get_variable_info("get_bills")

  # Check if the function returns a list
  expect_true(is.list(result))

  # Check if the list contains specific elements
  expect_true("page_info" %in% names(result))
  expect_true("reference_url" %in% names(result))

  # Check if passing an invalid parameter value results in an error
  expect_error(get_variable_info("invalid_function_name"), "Use correct function names below in character format.")
})

# For review_session_info function
test_that("review_session_info works correctly", {
  result <- review_session_info(7)

  # Check if the function returns a tibble
  expect_true(is(result, "tbl_df"))

  # Check if the tibble contains specific column names (this depends on the actual column names)
  expect_true("屆期會期" %in% colnames(result)) # Replace 'ColumnName1' with actual column name

  # Check if passing an invalid term value results in an error
  expect_error(review_session_info(12), "use correct `term`.")
})
