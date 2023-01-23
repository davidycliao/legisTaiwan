#' Retrieving the records of the questions answered by the executives
#' via Taiwan Legislative Yuan API 質詢事項 (行政院答復部分)
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
#' ## 輸入「立委屆期」與「會期」下載質詢事項 (行政院答復部分)
#'get_executive_response(term = 10, session_period = 5)
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=2}

get_executive_response <- function(term = 8, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")

  set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
                       sprintf("%02d", as.numeric(term)), "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)), "&sessionTimes=&item=&fileType=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
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
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=1",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}

