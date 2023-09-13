#' The Records of the Bills
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
#'   \item{`manual_info`}{Official manual. See \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153} or use legisTaiwan::get_variable_info("get_bills")}
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
#' @importFrom memoise memoise
#' @importFrom tibble as_tibble
#'
#' @export
#' @examples
#' ## Query bill records by a date range in the Taiwan ROC calendar format
#' get_bills(start_date = 1060120, end_date = 1070310, verbose = FALSE)
#'
#' ## Query bill records by a date range and a specific legislator
#' get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
#'
#' ## Query bill records by a date range and multiple legislators
#' get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
#'
#' @details The `get_bills` function returns a list that contains `query_time`,
#' `retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#' `end_date`, `url`, `variable_names`, `manual_info`, and `data`.
#'
#' @note To retrieve the user manual and more details about the data frame, use `legisTaiwan::get_variable_info("get_bills")`.
#' Further checks are required as the user manual seems to be inconsistent with the actual data.
#' @seealso
#' \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}

get_bills <- memoise(function(start_date = NULL, end_date = NULL, proposer = NULL, verbose = TRUE) {

  # Parameter validation: Check if ROC format date is correct
  if (!grepl("^\\d{7}$", as.character(start_date)) || !grepl("^\\d{7}$", as.character(end_date))) {
    stop("Error: Both start_date and end_date should be in ROC format (e.g., 1090101).")
  }

  if (start_date > end_date) {
    stop("Error: start_date should be earlier than end_date.")
  }

  # Parameter validation: Validate the proposer's name
  # This is just an example; you might need to check against an actual list of proposers.
  # valid_proposers <- c("Kong Wenji", "Zheng Tiancai") # Example proposer list
  # if (!is.null(proposer) && !all(unlist(strsplit(proposer, "&")) %in% valid_proposers)) {
  #   stop("Error: Invalid proposer name.")
  # }

  api_url <- sprintf("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=%s&to=%s&proposer=%s&mode=json", start_date, end_date, proposer)
  response <- GET(api_url)

  # API response handling
  if (response$status_code != 200) {
    stop(sprintf("Error: Failed to retrieve data from the API with status code %s.", response$status_code))
  }

  json_df <- fromJSON(content(response, "text"))
  df <- as_tibble(json_df)

  if (nrow(df) == 0) {
    stop(sprintf("Error: The query is unavailable:\n%s", api_url))
  }

  df["date_ad"] <- sapply(df$date, legisTaiwan::transformed_date_bill)

  # Data handling: Handle anomalies or missing data
  if (any(is.na(df$date_ad))) {
    stop("Error: Some dates couldn't be transformed to Gregorian calendar dates.")
  }

  if (verbose) {
    cat("Retrieved URL:", api_url, "\n")
    cat("Retrieved Bill Sponsor(s):", proposer, "\n")
    cat("Retrieved date between:", as.character(legisTaiwan::check_date(start_date)), "and", as.character(legisTaiwan::check_date(end_date)), "\n")
    cat("Retrieved Num:", nrow(df), "\n")
  }

  list_data <- list(
    title = "the records of bill sponsor and co-sponsor",
    query_time = Sys.time(),
    retrieved_number = nrow(df),
    proposer = proposer,
    start_date_ad = legisTaiwan::check_date(start_date),
    end_date_ad = legisTaiwan::check_date(end_date),
    start_date = start_date,
    end_date = end_date,
    url = api_url,
    variable_names = colnames(df),
    manual_info = "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153",
    data = df
  )

  return(list_data)
})



#'The Records of Legislation and the Executives Proposals 委員及政府議案提案資訊
#'
#'
#'@param term numeric or null. The data is only available from 8th term. The default value is 8.
#'參數必須為數值。資料從自第8屆起，預設值為8。
#'
#'@param session_period numeric or NULL. Available options for the session periods
#'is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is NULL. 參數必須為數值。
#'
#'@param verbose The default value is TRUE, displaying the description of data
#'retrieved in number, url and computing time.
#'
#'@return list list, which contains: \describe{
#'      \item{`title`}{the meeting records of cross-caucus session}
#'      \item{`query_time`}{the query time}
#'      \item{`retrieved_number`}{the number of observation}
#'      \item{`meeting_unit`}{the meeting unit}
#'      \item{`start_date_ad`}{the start date  in POSIXct}
#'      \item{`end_date_ad`}{the end date in POSIXct}
#'      \item{`start_date`}{the start date in ROC Taiwan calendar}
#'      \item{`url`}{the retrieved json url}
#'      \item{`variable_names`}{the variables of the tibble dataframe}
#'      \item{`manual_info`}{the official manual, \url{https://data.ly.gov.tw/getds.action?id=20}; or use legisTaiwan::get_variable_info("get_bills_2")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`sessionTimes`}{會次}
#'                \item{`meetingTimes`}{臨時會會次}
#'                \item{`billNo`}{議案編號}
#'                \item{`billName`}{提案名稱}
#'                \item{`billOrg`}{提案單位/委員}
#'                \item{`billProposer`}{主提案人}
#'                \item{`billCosignatory`}{連署提案}
#'                \item{`billStatus`}{議案狀態}
#'                \item{`pdfUrl`}{關係文書pdf檔案下載位置}
#'                \item{`docUrl`}{關係文書doc檔案下載位置}
#'                \item{`selectTerm`}{屆別期別篩選條件}
#'                }
#'              }
#'      }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載「質詢事項 (行政院答復部分)」
#'get_bills_2(term = 8, session_period = 1)
#'
#'@details `get_bills_2` produces a list, which contains `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data`. To retrieve the user
#'manual and more information about the data frame, please use `legisTaiwan::get_variable_info("get_bills_2")`.
#'
#'@note 議事類: 提供委員及政府之議案提案資訊 (自第8屆第1會期起)。
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=20}
get_bills_2 <- function(term = 8, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID20Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json",
                         sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else if (length(term) == 1) {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    term <- sprintf("%02d", as.numeric(term))
  } else if (length(term)  > 1) {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    message("The API is unable to query multiple terms and the request mostly falls.")
    term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
  }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID20Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved Term: ", term, "\n")
        cat(" Retrieved Num: ", nrow(df), "\n")
      }
      list_data <- list("title" = "the records of the questions answered by the executives",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "retrieved_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=2",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
