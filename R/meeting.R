#' Retrieving the spoken meeting records
#' 下載「委員發言」
#'
#'@param start_date Requesting meeting records starting from the date.
#'A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan
#'calendar format, e.g. 1090110.
#'@param end_date Requesting meeting records ending from the date.
#' A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan
#'calendar format, e.g. 1090110.
#'@param meeting_unit The default is NULL, which include all meetings
#' between the starting date and the ending date.
#'@param verbose The default value is TRUE, displaying the description
#'of data retrieved in number, url and computing time.
#'@return A list carries a main tibble dataframe that contains the date, status,
#' name, content and speakers.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'
#'@export
#'@examples
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## 輸入「中華民國民年」下載「委員發言」
#'get_meetings(1050120, 1050210)
#'
#'get_meetings("1050120", "1050210")
#'
#'get_meetings(start_date = "1050120", end_date = "1050210")
#'
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## and a meeting
#' ## 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
#'get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
#'
#'
#'@seealso
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}


get_meetings <- function(start_date = NULL, end_date = NULL,
                         meeting_unit = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::check_date(start_date), end_date = legisTaiwan::check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date, "&meeting_unit=",meeting_unit,  "&mode=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, legisTaiwan::transformed_date_meeting))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved via :", meeting_unit, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::check_date(start_date)), "and", as.character(legisTaiwan::check_date(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
        }
      list_data <- list("title" = "the spoken meeting records",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "meeting_unit" = meeting_unit,
                        "start_date_ad" = legisTaiwan::check_date(start_date),
                        "end_date_ad" = legisTaiwan::check_date(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      # message("Warning: The dates or the meeting unit(s) are not available in the database")
      # message("INFO: The error message from the Taiwan Legislative Yuan API or R:")
      message(error_message)
    }
  )
}


#' Retrieving the meeting records of cross-caucus session
#' 下載「黨團協商」資料
#'
#'@param start_date Requesting meeting records starting from the date.
#'A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan
#'calendar format, e.g. 109/01/10.
#'@param end_date Requesting meeting records ending from the date.
#' A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan calendar format, e.g. 109/01/20.
#'@param verbose The default value is TRUE, displaying the description
#'of data retrieved in number, url and computing time.
#'@return A list carries a main tibble dataframe that contains comYear, comBookId ,
#'sessionPeriod, sessionTimes, htmlUrl, etc.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query the meeting records of cross-caucus session using a period of the dates
#' ## in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「黨團協商」，輸入時間請依照該格式 "106/10/20"，需有「正斜線」做隔開。
#'get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=8}
#
get_caucus_meetings <- function(start_date = NULL, end_date = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::transformed_date_meeting(start_date), end_date = legisTaiwan::transformed_date_meeting(end_date))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=",
                       start_date, "&meetingDateE=", end_date, "&fileType=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::transformed_date_meeting(start_date)), "and", as.character(legisTaiwan::transformed_date_meeting(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
      }
      list_data <- list("title" = "the meeting records of cross-caucus session",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "start_date_ad" = legisTaiwan::transformed_date_meeting(start_date),
                        "end_date_ad" = legisTaiwan::transformed_date_meeting(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=8",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}

