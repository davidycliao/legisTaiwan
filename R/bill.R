#' Retrieving the records of the bills 法律提案 (API)
#'
#'@details `get_bills` produces a list, which contains `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data`.
#'
#'@param start_date numeric Must be formatted in ROC Taiwan calendar, e.g. 1090101.
#'
#'@param end_date numeric Must be formatted in ROC Taiwan calendar, e.g. 1090102.
#'
#'@param proposer The default value is NULL, which means all bill proposed by all legislators
#' are included between the starting date and the ending date.
#'
#'@param verbose logical, indicates whether `get_bills` should print out
#'detailed output when retrieving the data. The default value is TRUE.
#'
#'@return list, which contains: s\describe{
#'      \item{`title`}{the meeting records of cross-caucus session}
#'      \item{`query_time`}{the query time}
#'      \item{`retrieved_number`}{the number of observation}
#'      \item{`meeting_unit`}{the meeting unit}
#'      \item{`start_date_ad`}{the start date  in POSIXct}
#'      \item{`end_date_ad`}{the end date in POSIXct}
#'      \item{`start_date`}{the start date in ROC Taiwan calendar}
#'      \item{`url`}{the retrieved json url}
#'      \item{`variable_names`}{the variables of the tibble dataframe}
#'      \item{`manual_info`}{the offical manual}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      `term`,
#'      `sessionPeriod`,
#'      `sessionTimes`,
#'      `meetingTimes`,
#'      `billName`,
#'      `billProposer`,
#'      `billCosignatory`,
#'      `billStatus`, and
#'      `date_ad`}
#'      }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## 輸入「中華民國民年」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1070310, verbose = FALSE)
#'
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## and a specific legislator
#' ## 輸入「中華民國民年」與「指定立法委員」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
#'
#' ## query bill records by a period of the dates in Taiwan ROC calender format
#' ## and multiple legislators
#' ## 輸入「中華民國民年」與「指定多個立法委員」下載立法委員提案資料
#'get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
#'@seealso
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}
get_bills <- function(start_date = NULL, end_date = NULL, proposer = NULL,
                      verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date =  legisTaiwan::check_date(start_date), end_date =  legisTaiwan::check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=",
                       start_date, "&to=", end_date,
                       "&proposer=", proposer, "&mode=json", sep = "")
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

#' Retrieving the records of legislators and the government (executives) proposals
#' 議事類:提供委員及政府之議案提案資訊。(自第8屆第1會期起)
#'
#'@details `get_bills_2` produces a list, which contains `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data`.
#'
#'@param term numeric or NULL The default value is 8
#'參數必須為數值，資料從自第8屆第1會期起。
#'
#'@param session_period numeric or NULL. Available options for the session periods
#'is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is 8 參數必須為數值。
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
#'      \item{`manual_info`}{the offical manual}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      `term`,
#'      `sessionPeriod`,
#'      `sessionTimes`,
#'      `meetingTimes`,
#'      `billNo`,
#'      `billName`,
#'      `billOrg`,
#'      `billProposer`,
#'      `billCosignatory`,
#'      `billStatus`,
#'      `pdfUrl`,
#'      `docUrl` and
#'      `selectTerm`}
#'      }
#'
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
