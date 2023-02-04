#'The Records of Parliamentary Questions Asked by the Legislators 委員質詢事項資訊
#'
#' @details get_parlquestions` produces a list, which contains `title`,
#'`query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info` and `data`. To retrieve the user manual and more information
#' about the data frame, please use `legisTaiwan::get_variable_info("get_parlquestions")`. 質詢類: 提供議事日程本院委員之質詢事項資訊(自第8屆第1會期起)。
#'
#'@param term numeric or null. The data is only available from 8th term. The default value is 8.
#'參數必須為數值。資料從自第8屆起，預設值為8。
#'
#'@param session_period numeric or NULL. Available options for the session
#'is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is NULL. 參數必須為數值。
#'
#'@param verbose logical, indicates whether `get_parlquestions` should print out
#'detailed output when retrieving the data. The default is TRUE
#'
#'@return list contains: \describe{
#'\item{`title`}{the records of parliamentary questions}
#'\item{`query_time`}{the queried time}
#'\item{`retrieved_number`}{the total number of observations}
#'\item{`retrieved_term`}{the queried term}
#'\item{`url`}{the retrieved json url}
#'\item{`variable_names`}{the variables of the tibble dataframe}
#'\item{`manual_info`}{the offical manual from \url{https://data.ly.gov.tw/getds.action?id=6}, or use legisTaiwan::get_variable_info("get_parlquestions")}
#'\item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`sessionTimes`}{會次}
#'                \item{`item`}{項目}
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
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=6}
#'
get_parlquestions <- function(term = 8, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID6Action.action?term=",
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
      list_data <- list("title" = "the records of parliarmentary questions",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "retrieved_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=6",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}


#'The Records of the Questions Answered by the Executives 公報質詢事項行政院答復資訊
#'
#'@details **`get_executive_response`** produces a list, which contains `title`,
#'`query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info` and `data`. To retrieve the user manual and more information, please
#' use `legisTaiwan::get_variable_info("get_executive_response")`.
#' 質詢類: 提供公報質詢事項行政院答復資訊 (自第8屆第1會期起)。
#'
#'@param term integer, numeric or null. The default is NULL. The data is only
#'available from 8th term. 參數必須為數值。資料從自第8屆起，預設值為8。
#'
#'@param session_period integer, numeric or NULL. Available
#'options for the session is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is NULL. 參數必須為數值。
#'
#'@param verbose logical, indicates whether `get_executive_response` should
#'print out detailed output when retrieving the data. The default is TRUE
#'
#'@return list contains: \describe{
#'    \item{`title`}{the records of the questions answered by the executives}
#'    \item{`query_time`}{the queried time}
#'    \item{`retrieved_number`}{the total number of observations}
#'    \item{`retrieved_term`}{the queried term}
#'    \item{`url`}{the retrieved json url}
#'    \item{`variable_names`}{the variables of the tibble dataframe}
#'    \item{`manual_info`}{the offical manual}
#'    \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`sessionTimes`}{會次}
#'                \item{`meetingTimes`}{臨時會會次}
#'                \item{`eyNumber`}{行政院函公文編號}
#'                \item{`lyNumber`}{立法院函編號}
#'                \item{`subject`}{案由}
#'                \item{`content`}{內容}
#'                \item{`docUrl`}{案由}
#'                \item{`item`}{檔案下載位置}
#'                \item{`item`}{檔案下載位置}
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
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=2}

get_executive_response <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=&item=&fileType=json", sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else if (length(term) == 1) {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    term <- sprintf("%02d", as.numeric(term))
  } else if (length(term)  > 1) {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    message("The API is unable to query multiple terms and the request mostly falls.")
    term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
  }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&item=&fileType=json", sep = "")
  # legisTaiwan::check_internet()
  # attempt::stop_if_all(term, is.null, msg = "term is missing")
  # attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  # set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
  #                      sprintf("%02d", as.numeric(term)), "&sessionPeriod=",
  #                      sprintf("%02d", as.numeric(session_period)), "&sessionTimes=&item=&fileType=json", sep = "")
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
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=2",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
