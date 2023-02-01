#' Retrieving the records of the bills 法律提案(API)
#'
#'@param start_date Requesting meeting records starting from the date. A double
#'represents a date in ROC Taiwan format. If a double is used, it should specify
#' as Taiwan calendar format, e.g. 1090110.
#'
#'@param end_date Requesting meeting records ending from the date. A double
#'represents a date in ROC Taiwan format.If a double is used, it should specify
#'as Taiwan calendar format, e.g. 1090110.
#'
#'@param proposer The default value is NULL, which means all bill records are
#'included between the starting date and the ending date.
#'
#'@param verbose The default value is TRUE, displaying the description of data
#'retrieved in number, url and computing time.
#'
#'@return A tibble contains date, term, name, sessionPeriod, sessionTimes,
#'billName, billProposer, billCosignatory, billStatus, date_ad
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## 輸入「中華民國民年」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1070310)
#'
#'
#'
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## and a specific legislator
#' ## 輸入「中華民國民年」與「指定立法委員」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
#'
#'
#'
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## and multiple legislators
#' ## 輸入「中華民國民年」與「指定多個立法委員」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
#'@seealso
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}


get_bills <- function(start_date = NULL, end_date = NULL,
                      proposer = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date =  legisTaiwan::check_date(start_date), end_date =  legisTaiwan::check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=", start_date, "&to=", end_date, "&proposer=", proposer, "&mode=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      df["date_ad"] <- do.call("c", lapply(df$date, legisTaiwan::transformed_date_bill))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved Bill Sponsor(s): ", proposer, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::check_date(start_date)), "and", as.character(legisTaiwan::check_date(end_date)) , "\n")
        cat(" Retrieved Num:", nrow(df), "\n")
      }
      list_data <- list("title" = "the records of bill sponsor and co-sponsor",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "proposer" = proposer,
                        "start_date_ad" = legisTaiwan::check_date(start_date),
                        "end_date_ad" = legisTaiwan::check_date(end_date),
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

#' Retrieving the records of legislators and the government proposals 議案提案
#'
#'
#'@param term Requesting answered questions by term. The parameter should be set in
#'a numeric format. The default value is 8. The data is only available from 8th
#'term 參數必須為數值，資料從立法院第8屆開始計算。
#'@param session_period session in the term. The session is between 1 and 8.
#' session_period 參數必須為數值。
#'@param verbose The default value is TRUE, displaying the description of data
#'retrieved in number, url and computing time.
#'@return A list object contains a tibble carrying the variables of term, sessionPeriod,
#' sessionTimes, meetingTimes, eyNumber, lyNumber, subject, content, docUrl
#' selectTerm.
#'
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載「質詢事項 (行政院答復部分)」
#'get_bills_2(term = 8, session_period = 1)
#'
#'get_bills_2(term = 8, session_period = 4)
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=1}

get_bills_2 <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID20Action.action?term=",
                       sprintf("%02d", as.numeric(term)), "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)),
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
