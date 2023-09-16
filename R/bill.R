#'The Records of the Bills: 法律提案
#'
#' @param start_date numeric. Must be formatted in the ROC Taiwan calendar, e.g., 1090101.
#' @param end_date numeric. Must be formatted in the ROC Taiwan calendar, e.g., 1090102.
#' @param proposer The default value is NULL, indicating that bills proposed by all legislators
#' are included between the start and end dates.
#' @param verbose logical. Specifies whether `get_bills` should print out
#' detailed output when retrieving the data. The default value is TRUE.
#'
#' @return A list, which contains:
#' \describe{
#'   \item{`title`}{Records of cross-caucus sessions}
#'   \item{`query_time`}{Query timestamp}
#'   \item{`retrieved_number`}{Number of observations retrieved}
#'   \item{`meeting_unit`}{Meeting unit}
#'   \item{`start_date_ad`}{Start date in POSIXct format}
#'   \item{`end_date_ad`}{End date in POSIXct format}
#'   \item{`start_date`}{Start date in the ROC Taiwan calendar}
#'   \item{`url`}{URL of the retrieved JSON data}
#'   \item{`variable_names`}{Variable names of the tibble dataframe}
#'   \item{`manual_info`}{Official manual. See \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153} or use get_variable_info("get_bills")}
#'   \item{`data`}{A tibble dataframe with the following variables:
#'   \describe{\item{`term`}{Session number}
#'             \item{`sessionPeriod`}{Session period}
#'             \item{`sessionTimes`}{Session count}
#'             \item{`meetingTimes`}{Proposal date}
#'             \item{`billName`}{Bill name}
#'             \item{`billProposer`}{Primary proposer}
#'             \item{`billCosignatory`}{Co-signatories of the bill}
#'             \item{`billStatus`}{Status of the bill}
#'             \item{`date_ad`}{Date in the Gregorian calendar}
#'             }
#'           }
#' }
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom withr with_options
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## Query bill records by a date range in the Taiwan ROC calendar format
#' get_bills(start_date = 1060120, end_date = 1070310, verbose = FALSE)
#'
#' ## Query bill records by a date range and a specific legislator
#' get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
#'
#' ## Query bill records by a date range and multiple legislators
#' get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
#' }
#'
#' @details The `get_bills` function returns a list that contains `query_time`,
#' `retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#' `end_date`, `url`, `variable_names`, `manual_info`, and `data`.
#'
#' @note To retrieve the user manual and more details about the data frame, use `get_variable_info("get_bills")`.
#' Further checks are required as the user manual seems to be inconsistent with the actual data.
#'
#' @seealso
#' \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}
get_bills <- function(start_date = NULL, end_date = NULL, proposer = NULL,
                      verbose = TRUE) {
  check_internet()
  api_check(start_date =  check_date(start_date), end_date = check_date(end_date))
  validate_dates_format(start_date, end_date)
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=",
                       start_date, "&to=", end_date,
                       "&proposer=", proposer, "&mode=json", sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      df["date_ad"] <- do.call("c", lapply(df$date, transformed_date_bill))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved Bill Sponsor(s): ", proposer, "\n")
        cat(" Retrieved date between:", as.character(check_date(start_date)), "and", as.character(check_date(end_date)) , "\n")
        cat(" Retrieved Num:", nrow(df), "\n")
      }
      list_data <- list("title" = "the records of bill sponsor and co-sponsor",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "proposer" = proposer,
                        "start_date_ad" = check_date(start_date),
                        "end_date_ad" = check_date(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}


#' The Records of Legislation and the Executives Proposals: 委員及政府議案提案資訊
#'
#' @author David Liao (davidycliao@@gmail.com)
#'
#' @param term A numeric or NULL value. Data is available from the 8th term onwards.
#' Default is set to 8. 參數必須為數值。資料從第8屆開始，預設值為8。
#'
#' @param session_period An integer, numeric, or NULL. Valid options for the session are:
#' 1, 2, 3, 4, 5, 6, 7, and 8. Default is set to NULL.
#' 參數必須為數值。
#' `review_session_info()` provides available session periods based on the Minguo (Taiwan) calendar.
#'
#' @param verbose Default value is TRUE. Displays details of the retrieved data, including the number, URL, and computing time.
#'
#' @return A list containing:
#'      \item{`title`}{Records of questions answered by the executives}
#'      \item{`query_time`}{Query time}
#'      \item{`retrieved_number`}{Number of observations}
#'      \item{`retrieved_term`}{Retrieved term}
#'      \item{`url`}{Retrieved JSON URL}
#'      \item{`variable_names`}{Variables of the tibble dataframe}
#'      \item{`manual_info`}{Official manual: \url{https://data.ly.gov.tw/getds.action?id=20} or use `get_variable_info("get_bills_2")`}
#'      \item{`data`}{A tibble dataframe with variables such as:
#'      \describe{
#'                \item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`sessionTimes`}{會次}
#'                \item{`meetingTimes`}{臨時會會次}
#'                \item{`billNo`}{議案編號}
#'                \item{`billName`}{提案名稱}
#'                \item{`billOrg`}{提案單位/委員}
#'                \item{`billProposer`}{主提案人}
#'                \item{`billCosignatory`}{連署提案}
#'                \item{`billStatus`}{議案狀態}
#'                \item{`pdfUrl`}{PDF download link for related documents}
#'                \item{`docUrl`}{DOC download link for related documents}
#'                \item{`selectTerm`}{Filtering criteria based on term}
#'                }
#'              }
#'
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom tibble as_tibble
#' @importFrom withr with_options
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## Query the executives' responses by term and session period.
#' ## 輸入「立委屆期」與「會期」以下載「質詢事項 (行政院答復部分)」
#' get_bills_2(term = 8, session_period = 1)
#' }
#'
#' @details The `get_bills_2` function produces a list, which includes `query_time`,
#' `retrieved_number`, `retrieved_term`, `url`, `variable_names`, `manual_info`, and `data`.
#' For the user manual and more information about the dataframe, use `get_variable_info("get_bills_2")`.
#'
#' @note For more details about the dataframe's variables, use `get_variable_info("get_bills_2")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=20}.
#' 議事類: 提供委員及政府之議案提案資訊 (從第8屆第1會期開始)。
#'
#' @seealso
#' `get_variable_info("get_bills_2")`,`review_session_info()`
# Define the function get_bills_2
get_bills_2 <- function(term = 8, session_period = NULL, verbose = TRUE) {

  # Check for internet connectivity
  check_internet()

  # If the term is not specified
  if (is.null(term)) {
    # Set the base API URL without specifying any term
    set_api_url <- "https://data.ly.gov.tw/odw/ID20Action.action?term=&sessionPeriod=&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json"
    # Display a notification message
    message("The term is not defined...\nYou are now requesting full data from the API. Please ensure a stable internet connection until completion.\n")
  } else {
    # If the term is in character format, stop execution and display an error message
    attempt::stop_if_all(term, is.character, msg = "Please use numeric format only.")

    # If term length is one, format the term to two digits
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) { # If multiple terms are provided
      stop("The API doesn't support querying multiple terms. Consider implementing batch processing. Please refer to the tutorial for guidance.")
    }

    # Convert session period to two-digit format, if it's not NULL
    session_str <- ifelse(is.null(session_period), "", sprintf("%02d", as.numeric(session_period)))

    # Construct the complete API URL
    set_api_url <- paste0("https://data.ly.gov.tw/odw/ID20Action.action?term=",
                          term, "&sessionPeriod=", session_str,
                          "&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json")
  }

  # Try to fetch the data and process it
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df$dataList)
      # If the returned data is empty, stop execution and display an error message
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      if (isTRUE(verbose)) {
        cat("Retrieved URL: ", set_api_url, "\n")
        cat("Retrieved Term: ", term, "\n")
        cat("Retrieved Number of Records: ", nrow(df), "\n")
      }
      # Construct the result list
      list_data <- list(
        "title" = "The records of the questions answered by the executives",
        "query_time" = Sys.time(),
        "retrieved_number" = nrow(df),
        "retrieved_term" = term,
        "url" = set_api_url,
        "variable_names" = colnames(df),
        "manual_info" = "https://data.ly.gov.tw/getds.action?id=2",
        "data" = df
      )
      return(list_data) # Return the result list
    },
    error = function(error_message) { # Handle any errors
      message(error_message)
    }
  )
}
