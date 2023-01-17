#' Retrieving the records of parliamentary questions
#' via Taiwan Legislative Yuan API 質詢事項 (本院委員質詢部分)
#'
#'@param term Requesting questions from the term. The parameter should be set in
#'a numeric format. The default value is 8.
#'@param sessionPeriod session in the term. The session is between 1 and 6.
#'@param verbose The default value is TRUE, displaying the description of data
#'retrieved in number, url and computing time.
#'@return A list object contains a tibble carrying
#'
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#'get_parlquestions(term = 8, session_period = 2)
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=6}


get_parlquestions <- function(term = 8, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")

  set_api_url <- paste("https://data.ly.gov.tw/odw/ID6Action.action?term=",
                       sprintf("%02d", as.numeric(term)), "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)), "&sessionTimes=&item=&fileType=json", sep = "")
  paste("https://data.ly.gov.tw/odw/ID6Action.action?term=",
        10, "&sessionPeriod=", session_period, "&sessionTimes=&item=&fileType=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query unavailable during the period of the dates in the API")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved sessionPeriod: ", session_period, "\n")
        cat(" Retrieved sessionPeriod: ", nrow(df), "\n")
      }
      list_data <- list("title" = "the records of parliarmentary questions",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "retrieved_term" = term,
                        "url" = set_api_url,
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message("Warning: The data retrieved are not available in the database")
      message("INFO: The error message from the Taiwan Legislative Yuan API or R:")
      message(error_message)
    }
  )
}