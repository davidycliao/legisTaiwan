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

  # 先檢查 term 並顯示訊息
  if (is.null(term)) {
    message("\nTerm is not defined...\nRequesting full data from the API. Please ensure stable connectivity.\n")
  }

  # 初始化進度顯示
  if(isTRUE(verbose)) {
    cat("\nInput Format Information:\n")
    cat("------------------------\n")
    cat("Term: Must be numeric (e.g., 8, 9, 10)\n")
    cat("------------------------\n\n")
    cat("Downloading legislators data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  # 建構 API URL
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  } else {
    attempt::stop_if_all(term, is.character, msg = "Please use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) {
      if(isTRUE(verbose)) close(pb)
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("API does not support multiple terms. Data might be incomplete.")
    }

    # Update progress bar to 40%
    if(isTRUE(verbose)) setTxtProgressBar(pb, 40)
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  }

  # 取得資料
  tryCatch(
    {
      # Update progress bar to 60%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 60)

      with_options(list(timeout = max(1000, getOption("timeout"))),{
        json_df <- jsonlite::fromJSON(set_api_url)
      })

      # Update progress bar to 80%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 80)

      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "Query returned no data.")

      # 計算統計資訊
      term <- paste(sort(as.numeric(unique(df$term))), collapse = " ", sep = ",")
      party_counts <- table(df$party)

      # Update progress bar to 100% and show results
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" URL: ", set_api_url, "\n")
        cat(" Term: ", term, "\n")
        cat(" Total Legislators: ", nrow(df), "\n")
        cat("-----------------------------------\n")
        cat("Party Distribution:\n")
        for(party in names(party_counts)) {
          if(!is.na(party) && party != "") {
            cat(sprintf(" %s: %d\n", party, party_counts[party]))
          }
        }
        cat("===================================\n")
      }

      # 回傳結果
      list_data <- list(
        "title" = "Legislator's Demographic Information",
        "query_time" = Sys.time(),
        "queried_term" = term,
        "url" = set_api_url,
        "total_legislators" = nrow(df),
        "party_distribution" = party_counts,
        "variable_names" = colnames(df),
        "manual_info" = "https://data.ly.gov.tw/getds.action?id=16",
        "data" = df
      )
      return(list_data)
    },
    error = function(error_message) {
      if(isTRUE(verbose)) {
        close(pb)
        cat("\nError occurred while fetching data:\n")
        cat(sprintf("Error: %s\n", error_message))
      }
      message(error_message)
    }
  )
}
