#' The Legislator' Demographic Information and Background 提供委員基本資料
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@param term numeric or NULL The data is available from the 2nd term.
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data. The default is set to TRUE.
#'
#'@return list contains: \describe{
#'      \item{`query_time`}{the queried time}
#'      \item{`queried_term`}{the queried term}
#'      \item{`url`}{the retrieved json url}
#'      \item{`variable_names`}{the variables of the tibble dataframe}
#'      \item{`manual_info`}{the official manual from \url{https://data.ly.gov.tw/getds.action?id=16}, or use legisTaiwan::get_variable_info("get_legislators")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`term`}{屆別}
#'                \item{`name`}{委員姓名}
#'                \item{`ename`}{委員姓名}
#'                \item{`sex`}{性別}
#'                \item{`party`}{黨籍}
#'                \item{`partyGroup`}{黨團}
#'                \item{`committee`}{委員會}
#'                \item{`onboardDate`}{到職日(西元年)}
#'                \item{`degree`}{學歷}
#'                \item{`experience`}{經歷}
#'                \item{`picPath`}{照片位址}
#'                \item{`leaveFlag`}{離職日期(西元年)}
#'                \item{`leaveReason`}{離職原因}
#'                }
#'              }
#'      }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom withr with_options
#'
#'@export
#'
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載「行政院答復」
#'get_executive_response(term = 8, session_period = 1)
#'
#'@details `get_legislators` produces a list, which contains  `query_time`,
#'`queried_term`, `url`, `variable_names`, `manual_info` and `data`.
#'
#'@note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_legislators")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=16}.
#' 提供委員基本資料，最早資料可追溯至第2屆。
#'
#'@seealso
#'`get_variable_info("get_legislators")`, `review_session_info()`

get_legislators <- function(term = NULL, verbose = TRUE) {
  check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) {
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")
    }
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  }
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      term <- paste(sort(as.numeric(unique(df$term))), collapse = " ", sep = ",")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved term: ", term, "\n")
      }
      list_data <- list("title" = "the legislator's demographic information",
                        "query_time" = Sys.time(),
                        "queried_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=16",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
