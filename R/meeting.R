#' Retrieving the spoken meeting records 委員發言（能取得最早取得日不詳，待檢查。）
#'
#'@details `get_meetings` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data`.
#'
#'@param start_date numeric Must be formatted in ROC Taiwan calendar, e.g. 1090101.
#'
#'@param end_date numeric Must be formatted in ROC Taiwan calendar, e.g. 1090102.
#'
#'@param meeting_unit NULL The default is NULL, which includes all meeting types
#' between the starting date and the ending date.
#'
#'@param verbose logical, indicates whether `get_meetings` should print out
#'detailed output when retrieving the data.
#'
#'@return list, which contains: \describe{
#'      \item{`query_time`}{the query time}
#'      \item{`retrieved_number`}{the number url of the page}
#'      \item{`meeting_unit`}{the meeting unit}
#'      \item{`start_date_ad`}{the start date  in POSIXct}
#'      \item{`end_date_ad`}{the end date in POSIXct}
#'      \item{`start_date`}{the start date in ROC Taiwan calendar}
#'      \item{`url`}{the retrieved json url}
#'      \item{`variable_names`}{the variables of the tibble dataframe}
#'      \item{`manual_info`}{the offical manual}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      `smeeting_date`,
#'      `meeting_status`,
#'      `meeting_name`,
#'      `meeting_content`,
#'      `speechers`,
#'      `meeting_unit`,
#'      `date_ad`}
#'      }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## 輸入「中華民國民年」下載「委員發言」
#'get_meetings(start_date = "1050120", end_date = "1050210")
#'
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## and a meeting
#' ## 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
#'get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
#'
#'@seealso
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}
get_meetings <- function(start_date = NULL, end_date = NULL, meeting_unit = NULL,
                         verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::check_date(start_date), end_date = legisTaiwan::check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date, "&meeting_unit=", meeting_unit, "&mode=json", sep = "")
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
      message(error_message)
    }
  )
}



#' Retrieving the meeting records of cross-caucus session
#' 提供公報之黨團協商資訊。(自第8屆第1會期起)
#'
#'@details `get_caucus_meetings` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data.`
#'
#'@param start_date character Must be formatted in ROC Taiwan calendar with three
#'forward slashes between year, month and day, e.g. "106/10/20".
#'
#'@param end_date character Must be formatted in ROC Taiwan calendar with three
#'forward slashes between year, month and day, e.g. "109/01/10".
#'
#'@param verbose logical, indicates whether `get_caucus_meetings` should print out
#'detailed output when retrieving the data.
#'
#'@return list, which contains: \describe{
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
#'      `comYear`,
#'      `comVolume`,
#'      `comBookId`,
#'      `term`,
#'      `sessionPeriod`,
#'      `sessionTimes`,
#'      `meetingTimes`,
#'      `meetingDate`,
#'      `meetingName`,
#'      `subject`,
#'      `pageEnd`,
#'      `docUrl`,
#'      `htmlUrl`, and
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
#' ## query the meeting records of cross-caucus session using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「黨團協商」，輸入時間請依照該格式 "106/10/20"，
#' ## 需有「正斜線」做隔開。
#'get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=8}
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


#' Retrieving full video information of meetings and committees
#' 提供立法院院會及委員會之委員發言片段相關影片資訊。(自第9屆第1會期起)
#'
#'@details `get_speech_video` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data.`
#'
#'@param start_date character Must be formatted in ROC Taiwan calendar with three
#'forward slashes between year, month and day, e.g. "106/10/20".
#'
#'@param end_date character Must be formatted in ROC Taiwan calendar with three
#'forward slashes between year, month and day, e.g. "109/01/10".
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data.
#'
#'@return list, which contains: \describe{
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
#'      `meetingDate`,
#'      `meetingTime`,
#'      `meetingTypeName`,
#'      `meetingName`,
#'      `meetingContent`,
#'      `legislatorName`,
#'      `areaName`,
#'      `speechStartTime`,
#'      `speechEndTime`,
#'      `speechRecordUrl`,
#'      `videoLength`,
#'      `videoUrl`, and
#'      `selectTerm`}
#'      }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'
#'@examples
#' ## query full video information of meetings and committees using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「委員發言片段相關影片資訊」，輸入時間請依照該
#' ## 格式 "105/10/20"，需有「正斜線」做隔開。
#'get_speech_video(start_date = "105/10/20", end_date = "109/03/10")
#'
#'@seealso
#'委員發言片段相關影片資訊 \url{https://data.ly.gov.tw/getds.action?id=148}
get_speech_video <- function(start_date = NULL, end_date = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::transformed_date_meeting(start_date), end_date = legisTaiwan::transformed_date_meeting(end_date))
  # 自第9屆第1會期起 2016  民國 105
  queried_year <- format(legisTaiwan::transformed_date_meeting(start_date), format = "%Y")
  attempt::warn_if(queried_year < 2016,
            isTRUE,
            msg =  paste("The query retrieved from", queried_year,  "may not be complete.", "The data is only available from the 6th session of the 8th legislative term in 2015/104 in ROC."))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID148Action.action?term=",
                       "&sessionPeriod=",
                       "&meetingDateS=", start_date,
                       "&meetingDateE=", end_date,
                       "&meetingTime=&legislatorName=&fileType=json" , sep = "")
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


#' Retrieving the records of national public debates
#' 提供公報之國是論壇資訊，並包含書面意見。自第8屆第1會期起，但實測資料從第十屆。
#'
#'@param term numeric or NULL The default value is 10
#'參數必須為數值，資料從自第8屆第1會期起。
#'
#'@param session_period integer or NULL. Available options for the session periods
#'is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is NULL. 參數必須為數值。
#'
#'@param verbose logical, indicates whether `get_public_debates` should print out
#'detailed output when retrieving the data. The default is TRUE
#'
#'@return list, which contains: \describe{
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
#'      `dateTimeDesc`,
#'      `meetingRoom`,
#'      `chairman`,
#'      `legislatorName`,
#'      `speakType`,
#'      `content`, and
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
#' ## 輸入「立委屆期」與「會期」下載國是論壇資訊。
#'get_public_debates(term = 10, session_period = 2)
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=7}

get_public_debates <- function(term = 10, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
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
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
                       sep = "")
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
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=7",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
