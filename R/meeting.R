#' The Spoken Meeting Records 委員發言
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@param start_date numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090101.
#'
#'@param end_date numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090102.
#'
#'@param meeting_unit NULL The default is NULL, which includes all meeting types
#' between the starting date and the ending date.
#'
#'@param verbose logical, indicates whether `get_meetings` should print out
#'detailed output when retrieving the data.
#'
#'@return list, which contains: \describe{
#'      \item{`title`}{the spoken meeting records }
#'      \item{`query_time`}{the query time}
#'      \item{`retrieved_number`}{the number of the observation}
#'      \item{`meeting_unit`}{the meeting unit}
#'      \item{`start_date_ad`}{the start date in POSIXct}
#'      \item{`end_date_ad`}{the end date in POSIXct}
#'      \item{`start_date`}{the start date in ROC Taiwan calendar}
#'      \item{`url`}{the retrieved json url}
#'      \item{`variable_names`}{the variables of the tibble dataframe}
#'      \item{`manual_info`}{the offical manual, \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}; or use get_variable_info("get_meetings")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`smeeting_date`}{會議日期}
#'                \item{`meeting_status`}{會議狀態}
#'                \item{`meeting_name`}{會議名稱}
#'                \item{`meeting_content`}{會議事由}
#'                \item{`speechers`}{委員發言名單}
#'                \item{`meeting_unit`}{主辦單位}
#'                \item{`date_ad`}{西元年}
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
#' ## query meeting records by a period of the dates in Minguo (Taiwan) calendar
#' ## 輸入「中華民國民年」下載「委員發言」
#'get_meetings(start_date = "1050120", end_date = "1050210")
#'
#' ## query meeting records by a period of the dates in Minguo (Taiwan) calendar format
#' ## and a meeting
#' ## 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
#'get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
#'
#'@details `get_meetings` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data`.
#'
#'@note To retrieve the user manual and more information about variable of the data
#'frame, please use `get_variable_info("get_meetings")` or visit
#'the API manual at \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}.
#'資料似乎不一致，待確認。委員發言（取得最早時間不詳，待檢查。）
#'
#'@seealso
#'`get_variable_info("get_meetings")`
#'
#'@seealso
#' Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.

get_meetings <- function(start_date = NULL, end_date = NULL, meeting_unit = NULL,
                         verbose = TRUE) {
  check_internet()
  api_check(start_date = check_date(start_date), end_date = check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date, "&meeting_unit=", meeting_unit, "&mode=json", sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, transformed_date_meeting))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved via :", meeting_unit, "\n")
        cat(" Retrieved date between:", as.character(check_date(start_date)), "and", as.character(check_date(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
        }
      list_data <- list("title" = "the spoken meeting records",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "meeting_unit" = meeting_unit,
                        "start_date_ad" = check_date(start_date),
                        "end_date_ad" = check_date(end_date),
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


#' The Meeting Records of Cross-caucus Session 黨團協商資訊
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@param start_date character Must be formatted in Minguo (ROC) calendar with three
#'forward slashes between year, month and day, e.g. "106/10/20".
#'
#'@param end_date character Must be formatted in Minguo (ROC) calendar with three
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
#'      \item{`manual_info`}{the official manual, \url{https://data.ly.gov.tw/getds.action?id=8}; or use get_variable_info("get_caucus_meetings")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`comYear`}{卷}
#'                \item{`comVolume`}{期}
#'                \item{`comBookId`}{冊別}
#'                \item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`meetingTimes`}{臨時會會次}
#'                \item{`meetingDate`}{會議日期(民國年)}
#'                \item{`meetingName`}{會議名稱}
#'                \item{`subject`}{案由}
#'                \item{`pageStart`}{起始頁}
#'                \item{`pageEnd`}{結束頁}
#'                \item{`docUrl`}{檔案下載位置}
#'                \item{`htmlUrl`}{html網址}
#'                \item{`selectTerm`}{屆別期別篩選條件}
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
#' ## query the meeting records of cross-caucus session using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「黨團協商」，輸入時間請依照該格式 "106/10/20"，
#' ## 需有「正斜線」做隔開。
#'get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")
#'
#'@details `get_caucus_meetings` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data.`
#'\\ifelse{html}{\\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\\strong{[Experimental]}}
#'
#'@note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_caucus_meetings")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=8}.
#' 議事類:提供公報之黨團協商資訊 (自第8屆第1會期起)
#'
#'@seealso
#'`get_variable_info("get_caucus_meetings")`
#'
#'@seealso
#' Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.
#
get_caucus_meetings <- function(start_date = NULL, end_date = NULL,
                                verbose = TRUE) {
  check_internet()
  api_check(start_date = transformed_date_meeting(start_date),
                         end_date = transformed_date_meeting(end_date))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=",
                       start_date, "&meetingDateE=", end_date, "&fileType=json", sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved date between:", as.character(transformed_date_meeting(start_date)), "and", as.character(transformed_date_meeting(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
      }
      list_data <- list("title" = "the meeting records of cross-caucus session",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "start_date_ad" = transformed_date_meeting(start_date),
                        "end_date_ad" = transformed_date_meeting(end_date),
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


#' The Video Information of Meetings and Committees 院會及委員會之委員發言片段相關影片資訊
#'
#'@param start_date character Must be formatted in Minguo (ROC) calendar with three
#'forward slashes between year, month and day, e.g. "106/10/20".
#'
#'@param end_date character Must be formatted in Minguo (ROC) calendar  with three
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
#'      \item{`manual_info`}{the official manual, \url{https://data.ly.gov.tw/getds.action?id=148}; or use get_variable_info("get_speech_video")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'      \describe{\item{`term`}{屆別}
#'                \item{`sessionPeriod`}{會期}
#'                \item{`meetingDate`}{會議日期(西元年)}
#'                \item{`meetingTime`}{會議時間}
#'                \item{`meetingTypeName`}{主辦單位}
#'                \item{`meetingName`}{會議名稱}
#'                \item{`meetingContent`}{會議事由}
#'                \item{`legislatorName`}{委員姓名}
#'                \item{`areaName`}{選區名稱}
#'                \item{`speechStartTime`}{委員發言時間起}
#'                \item{`speechEndTime`}{委員發言時間迄}
#'                \item{`speechRecordUrl`}{發言紀錄網址}
#'                \item{`videoLength`}{影片長度}
#'                \item{`videoUrl`}{影片網址}
#'                \item{`selectTerm`}{屆別期別篩選條件}
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
#' ## query full video information of meetings and committees using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「委員發言片段相關影片資訊」，輸入時間請依照該
#' ## 格式 "105/10/20"，需有「正斜線」做隔開。
#'get_speech_video(start_date = "105/10/20", end_date = "109/03/10")
#'
#'@details `get_speech_video` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data.` To retrieve the user
#'manual and more information about the data frame, please use `get_variable_info("get_speech_video")`.
#'
#'@note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_speech_video")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=148}.
#' 會議類:提供立法院院會及委員會之委員發言片段相關影片資訊 (自第9屆第1會期起)。
#'
#'@seealso
#'`get_variable_info("get_speech_video")`

get_speech_video <- function(start_date = NULL, end_date = NULL, verbose = TRUE) {
  check_internet()
  api_check(start_date = transformed_date_meeting(start_date), end_date = transformed_date_meeting(end_date))
  # # 自第9屆第1會期起 2016  民國 105
  # queried_year <- format(transformed_date_meeting(start_date), format = "%Y")
  # attempt::warn_if(queried_year < 2016,
  #           isTRUE,
  #           msg =  paste("The query retrieved from", queried_year,  "may not be complete.", "The data is only available from the 6th session of the 8th legislative term in 2015/104 in ROC."))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID148Action.action?term=",
                       "&sessionPeriod=",
                       "&meetingDateS=", start_date,
                       "&meetingDateE=", end_date,
                       "&meetingTime=&legislatorName=&fileType=json" , sep = "")
  tryCatch(
    {
      with_options(list(timeout = max(1000, getOption("timeout"))),{json_df <- jsonlite::fromJSON(set_api_url)})
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved date between:", as.character(transformed_date_meeting(start_date)), "and", as.character(transformed_date_meeting(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
      }
      list_data <- list("title" = "the meeting records of cross-caucus session",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "start_date_ad" = transformed_date_meeting(start_date),
                        "end_date_ad" = transformed_date_meeting(end_date),
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


#'The Records of National Public Debates 國是論壇
#'
#'
#'@param term numeric or NULL The default is set to 10. 參數必須為數值，資料從自
#'第8屆第1會期起，但實測資料從第10屆，故預設為10。
#'
#'@param session_period integer, numeric or NULL. Available
#'options for the session is: 1, 2, 3, 4, 5, 6, 7, and 8. The default is set to NULL. 參數必須為數值。
#'`review_session_info()` generates each session period  available option period
#' in Minguo (Taiwan) calendar.
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
#'      \item{`manual_info`}{the official manual, \url{https://data.ly.gov.tw/getds.action?id=7}; or use get_variable_info("get_public_debates")}
#'      \item{`data`}{a tibble dataframe, whose variables include:
#'            \describe{\item{`term`}{屆別}
#'                      \item{`sessionPeriod`}{會期}
#'                      \item{`sessionTimes`}{會次}
#'                      \item{`meetingTimes`}{臨時會會次}
#'                      \item{`dateTimeDesc`}{日期時間說明}
#'                      \item{`meetingRoom`}{會議地點}
#'                      \item{`chairman`}{主持人}
#'                      \item{`legislatorName`}{委員姓名}
#'                      \item{`speakType`}{發言類型(paper:書面發言,speak:發言)}
#'                      \item{`content`}{內容}
#'                      \item{`selectTerm`}{屆別期別篩選條件}
#'                      }
#'                  }
#'                }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom withr with_options
#'
#'@export
#'
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載國是論壇資訊。
#'get_public_debates(term = 10, session_period = 2)
#'
#'@details `get_public_debates` produces a list, which contains `title`, `query_time`,
#'`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`, `start_date`,
#'`end_date`, `url`, `variable_names`, `manual_info` and `data.`
#'
#'@note
#' To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_public_debates")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=7}.
#' 議事類: 提供公報之國是論壇資訊，並包含書面意見。自第8屆第1會期起，但實測資料從第10屆。
#'
#'@seealso
#'`get_variable_info("get_public_debates")`, `review_session_info()`
#'
#'@seealso
#' Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.

get_public_debates <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
                         sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
    } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))}
    else if (length(term) > 1) {
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")}
          }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
                       sep = "")
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
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=7",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}


#' The Records of Reviewed Items in the Committees 委員會會議審查之議案項目
#'
#'@author David Yen-Chieh Liao
#'
#'@param term numeric or null. Data is available only from the 8th term.
#'The default is set to 10. 參數必須為數值。提供委員會會議審查之議案項目。(自第10屆第1會期起)
#'
#'@param session_period integer, numeric or NULL.
#'`review_session_info()` provides each session period's available options based on the
#' Minguo (Taiwan) calendar.
#'
#'@param verbose logical. This indicates whether `get_executive_response` should
#'print a detailed output during data retrieval. Default is TRUE.
#'
#'@return A list containing:
#'    \item{`title`}{Records of questions answered by executives}
#'    \item{`query_time`}{Time of query}
#'    \item{`retrieved_number`}{Total number of observations}
#'    \item{`retrieved_term`}{Queried term}
#'    \item{`url`}{Retrieved JSON URL}
#'    \item{`variable_names`}{Variables of the tibble dataframe}
#'    \item{`manual_info`}{Official manual, \url{https://data.ly.gov.tw/getds.action?id=46}; or use get_variable_info("get_committee_record")}
#'    \item{`data`}{A tibble dataframe with variables:
#'      \describe{
#'                \item{`term`}{Term number}
#'                \item{`sessionPeriod`}{Session}
#'                \item{`meetingNo`}{Meeting number}
#'                \item{`billNo`}{Bill number}
#'                \item{`selectTerm`}{Term selection filter}
#'                }
#'              }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom withr with_options
#'
#'@export
#'
#'@examples
#' ## Query the committee record by term and session period.
#' ## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
#'get_committee_record(term = 10, session_period = 1)
#'
#'@details `get_committee_record` provides a list which includes `title`,
#'`query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info`, and `data`.
#'
#'@note
#' To access the user manual and more information about the data frame's variables,
#' please refer to `get_variable_info("get_committee_record")` or check the API manual at
#' \url{https://data.ly.gov.tw/getds.action?id=46}.
#' This provides agenda items reviewed in committee meetings (from the 10th term, 1st session onwards).
#'
#'@seealso
#'`get_variable_info("get_committee_record")`, `review_session_info()`
#' The Records of Reviewed Items in the Committees 委員會會議審查之議案項目
#'
#'@author David Yen-Chieh Liao
#'
#'@param term numeric or null. Data is available only from the 8th term.
#'The default is set to 10. 參數必須為數值。提供委員會會議審查之議案項目。(自第10屆第1會期起)
#'
#'@param session_period integer, numeric or NULL.
#'`review_session_info()` provides each session period's available options based on the
#' Minguo (Taiwan) calendar.
#'
#'@param verbose logical. This indicates whether `get_executive_response` should
#'print a detailed output during data retrieval. Default is TRUE.
#'
#'@return A list containing:
#'    \item{`title`}{Records of questions answered by executives}
#'    \item{`query_time`}{Time of query}
#'    \item{`retrieved_number`}{Total number of observations}
#'    \item{`retrieved_term`}{Queried term}
#'    \item{`url`}{Retrieved JSON URL}
#'    \item{`variable_names`}{Variables of the tibble dataframe}
#'    \item{`manual_info`}{Official manual, \url{https://data.ly.gov.tw/getds.action?id=46}; or use get_variable_info("get_committee_record")}
#'    \item{`data`}{A tibble dataframe with variables:
#'      \describe{
#'                \item{`term`}{Term number}
#'                \item{`sessionPeriod`}{Session}
#'                \item{`meetingNo`}{Meeting number}
#'                \item{`billNo`}{Bill number}
#'                \item{`selectTerm`}{Term selection filter}
#'                }
#'              }
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom withr with_options
#'
#'@export
#'
#'@examples
#' ## Query the committee record by term and session period.
#' ## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
#'get_committee_record(term = 10, session_period = 1)
#'
#'@details `get_committee_record` provides a list which includes `title`,
#'`query_time`, `retrieved_number`, `retrieved_term`, `url`, `variable_names`,
#' `manual_info`, and `data`.
#'
#'@note
#' To access the user manual and more information about the data frame's variables,
#' please refer to `get_variable_info("get_committee_record")` or check the API manual at
#' \url{https://data.ly.gov.tw/getds.action?id=46}.
#' This provides agenda items reviewed in committee meetings (from the 10th term, 1st session onwards).
#'
#'@seealso
#'`get_variable_info("get_committee_record")`, `review_session_info()`

get_committee_record <- function(term = 10, session_period = NULL, verbose = TRUE) {
  check_internet()
  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID46Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=01&meetingTimes=&fileType=json", sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))}
    else if (length(term) > 1) {
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")}
  }
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID46Action.action?term=",
                       term,
                       "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=01&meetingTimes=&fileType=json", sep = "")
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
      list_data <- list("title" = "the records of reviewed items in the committees",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "retrieved_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=46",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
