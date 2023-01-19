#' Retrieving legislator' demographics via Taiwan Legislative Yuan API
#' 歷屆委員資料
#'
#'@param term Requesting answered questions from the term. The parameter should be set in
#'a numeric format. The default value is 2.
#'retrieved in number, url, and computing time.
#'@return A list object contains a tibble carrying term, name, ename,
#'sex, party, etc.
#'
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'
#'@examples
#' ## To retrieve legislator' demographic from 8th
#' ## 輸入「屆次」下載當屆立委資料
#'get_legislators(term = 8)
#'
#'
#'
#' ## To retrieve legislator' demographic from all of terms
#' ## 輸入「空白」下載所有立委資料
#'get_legislators()
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=16}


get_legislators <- function(term = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  }else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only")
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         sprintf("%02d", as.numeric(term)), "=&fileType=json", sep = "")
  }
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      term <- paste(sort(as.numeric(unique(df$term))), collapse=" ", sep = ",")
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query unavailable during the period of the dates in the API")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved term: ", term, "\n")
      }
      list_data <- list("title" = "the legislator's demographic information",
                        "query_time" = Sys.time(),
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
