#' The Records of Parliamentary Questions 委員質詢事項資訊
#'
#' @author David Liao (davidycliao@@gmail.com)
#'
#' @param term numeric or NULL. The default is set to NULL. 參數必須為數值。
#'
#' @param session_period integer, numeric or NULL. Available
#' options for the session is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is set to 8 參數必須為數值。
#' `review_session_info()` generates each session period available option period
#' in Minguo (Taiwan) calendar.
#'
#' @param verbose logical, indicates whether `get_parlquestions` should print out
#' detailed output when retrieving the data. The default is TRUE.
#'
#' @return A list containing:
#'   \describe{
#'     \item{`title`}{the records of parliamentary questions}
#'     \item{`query_time`}{the queried time}
#'     \item{`retrieved_number`}{the total number of observations}
#'     \item{`retrieved_term`}{the queried term}
#'     \item{`url`}{the retrieved json url}
#'     \item{`variable_names`}{the variables of the tibble dataframe}
#'     \item{`manual_info`}{the offical manual from \url{https://data.ly.gov.tw/getds.action?id=6}, or use get_variable_info("get_parlquestions")}
#'     \item{`data`}{a tibble dataframe, whose variables include:
#'       \describe{
#'         \item{`term`}{屆別}
#'         \item{`sessionPeriod`}{會期}
#'         \item{`sessionTimes`}{會次}
#'         \item{`item`}{項目}
#'         \item{`selectTerm`}{屆別期別篩選條件}
#'       }
#'     }
#'   }
#'
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom withr with_options
#' @export
#'
#' @examples
#' ## Query parliamentary questions by term.
#' ## 輸入「立委會期」下載立委質詢資料
#' get_parlquestions(term = 10)
#'
#' ## Query parliamentary questions by term and session period.
#' ## 輸入「立委屆期」與「會期」下載立委質詢資料
#' get_parlquestions(term = 10, session_period = 2)
#'
#' @details `get_parlquestions` produces a list, which contains `title`,
#' `query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info`, and `data`.
#'
#' @note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_parlquestions")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=6}.
#' 質詢類: 提供議事日程本院委員之質詢事項資訊(自第8屆第1會期起)。
#'
#' @seealso `get_variable_info("get_parlquestions")`
get_parlquestions <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  check_internet()
  if (is.null(term)) {
      set_api_url <- paste("https://data.ly.gov.tw/odw/ID6Action.action?term=", term,
                           "&sessionPeriod=",
                           "&sessionTimes=&item=&fileType=json", sep = "")
      message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))}
    else if (length(term) > 1) {
        options(timeout = max(1000, getOption("timeout")))
        term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
        stop("The API is unable to query multiple terms.")
      }
  }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID6Action.action?term=", term,
                       "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&item=&fileType=json", sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
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


#'The Records of Response to the Questions by the Executives 公報質詢事項行政院答復資訊
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@param term integer, numeric or NULL. The default is NULL. The data is only
#'available from 8th term. 參數必須為數值。資料從自第8屆起，預設值為8。
#'
#'@param session_period integer, numeric or NULL. Available
#'options for the session is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is set to NULL. 參數必須為數值。
#'`review_session_info()` generates each session period  available option period
#' in Minguo (Taiwan) calendar.
#'
#'@param verbose logical, indicates whether `get_executive_response` should
#'print out detailed output when retrieving the data. The default is set to TRUE
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
#'@importFrom withr with_options
#'@export
#'
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載「行政院答復」
#'get_executive_response(term = 8, session_period = 1)
#'
#'@details **`get_executive_response`** produces a list, which contains `title`,
#'`query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info` and `data`. To retrieve the user manual and more information, please
#' use `get_variable_info("get_executive_response")`.
#'
#'
#'#'@note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_executive_response")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=2}.
#' 質詢類: 提供公報質詢事項行政院答復資訊 (自第8屆第1會期起)。
#'
#'@seealso
#'`get_variable_info("get_executive_response")`, `review_session_info()`


get_executive_response <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  check_internet()
  if (is.null(term)) {
      set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
                           term, "&sessionPeriod=",
                           "&sessionTimes=&item=&fileType=json", sep = "")
      message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))}
    else if (length(term) > 1) {
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      stop("The API is unable to query multiple terms.")
      }
  }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID2Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&item=&fileType=json", sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
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
