#' The Spoken Meeting Records 委員發言
#'
#' @author Yen-Chieh Liao (davidycliao@gmail.com)
#'
#' @description
#' Provides access to legislators' spoken meeting records through
#' the Legislative Yuan's V1 API interface.
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
#'@import utils
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
#' get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
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
#'
#'@encoding UTF-8
get_meetings <- function(start_date = NULL, end_date = NULL, meeting_unit = NULL,
                         verbose = TRUE) {
  check_internet()

  # 先檢查必要參數
  if(is.null(start_date) || is.null(end_date)) {
    message("\nBoth start_date and end_date must be provided.\n")
  }

  # 初始化進度顯示
  if(isTRUE(verbose)) {
    cat("\nInput Format Information:\n")
    cat("------------------------\n")
    cat("Date Format: YYYMMDD (ROC calendar)\n")
    cat("Example: 1090101 for 2020/01/01\n")
    cat("------------------------\n\n")
    cat("Downloading meeting records data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  api_check(start_date = check_date(start_date), end_date = check_date(end_date))

  # Update progress bar to 40%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 40)

  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date,
                       "&meeting_unit=", meeting_unit, "&mode=json", sep = "")

  tryCatch(
    {
      # Update progress bar to 60%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 60)

      with_options(list(timeout = max(1000, getOption("timeout"))),{
        json_df <- jsonlite::fromJSON(set_api_url)
      })

      # Update progress bar to 80%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 80)

      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "Query returned no data.")
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, transformed_date_meeting))

      # Update progress bar to 100% and show results
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" URL: \n", set_api_url, "\n")
        if(!is.null(meeting_unit)) {
          cat(" Meeting Unit: ", meeting_unit, "\n")
        }
        cat(" Date Range: ", as.character(check_date(start_date)),
            " to ", as.character(check_date(end_date)), "\n")
        cat(" Total Records: ", nrow(df), "\n")

        # Add meeting type distribution if available
        if("meeting_type" %in% colnames(df)) {
          meeting_counts <- table(df$meeting_type)
          cat("\nMeeting Type Distribution:\n")
          for(type in names(meeting_counts)) {
            cat(sprintf(" %s: %d\n", type, meeting_counts[type]))
          }
        }
        cat("===================================\n")
      }

      list_data <- list(
        "title" = "Meeting Records",
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


#' The Meeting Records of Cross-caucus Session 黨團協商資訊
#'
#' @author Yen-Chieh Liao (davidycliao@gmail.com)
#'
#' @description
#' Retrieves cross-caucus negotiation meeting records from the Legislative Yuan's
#' V1 API.
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
#'@import utils
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom withr with_options
#'
#'@export
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
#'
#'@note To retrieve the user manual and more information about variable of the data
#' frame, please use `get_variable_info("get_caucus_meetings")`
#' or visit the API manual at \url{https://data.ly.gov.tw/getds.action?id=8}.
#' 議事類:提供公報之黨團協商資訊 (自第8屆第1會期起)
#'
#'@seealso
#'`get_variable_info("get_caucus_meetings")`  Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.
#'
#'@encoding UTF-8
get_caucus_meetings <- function(start_date = NULL, end_date = NULL,
                                verbose = TRUE) {
  # 檢查日期格式
  date_format_check <- function(date) {
    if (!is.null(date) && !grepl("^\\d{3}/\\d{2}/\\d{2}$", date)) {
      stop(paste("Invalid date format:", date, "\n",
                 "Please use the format 'YYY/MM/DD' (ROC calendar),\n",
                 "For example: '106/10/20'\n",
                 "Where YYY is the ROC year (民國年)"))
    }
  }

  check_internet()
  date_format_check(start_date)
  date_format_check(end_date)

  if(isTRUE(verbose)) {
    cat("Downloading caucus meetings data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  api_check(start_date = transformed_date_meeting(start_date),
            end_date = transformed_date_meeting(end_date))

  # Update progress bar to 40%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 40)

  set_api_url <- paste("https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=",
                       start_date, "&meetingDateE=", end_date, "&fileType=json", sep = "")

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
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")

      # Update progress bar to 100% and close it
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")  # Add newlines after progress bar
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" URL: \n", set_api_url, "\n")
        cat(" Date Range: ", as.character(transformed_date_meeting(start_date)),
            " to ", as.character(transformed_date_meeting(end_date)), "\n")
        cat(" Total Meetings: ", nrow(df), "\n")
        cat("===================================\n")
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
      if(isTRUE(verbose)) {
        close(pb)
        cat("\n")
      }
      message(error_message)
    }
  )
}


#' @title The Video Information of Meetings and Committees 院會及委員會之委員發言片段相關影片資訊
#'
#' @description
#' Retrieves video records and information of legislative meetings and committee sessions,
#' including speech segments, meeting details, and video URLs. Data is available in both
#' JSON and CSV formats from the 9th legislative term onwards.
#'
#' @param term numeric or NULL. Legislative term number (e.g., 10).
#' Data is available from the 9th term onwards. Default is NULL.
#'
#' @param session_period numeric or NULL. Session period number (1-8).
#' Default is NULL.
#'
#' @param start_date character. Must be formatted in ROC calendar with forward slashes
#' between year, month and day, e.g., "110/10/01".
#'
#' @param end_date character. Must be formatted in ROC calendar with forward slashes
#' between year, month and day, e.g., "110/10/30".
#'
#' @param verbose logical. Whether to display download progress and detailed information.
#' Default is TRUE.
#'
#' @param format character. Data format to retrieve, either "json" or "csv".
#' Default is "json".
#'
#' @return A list containing:
#' \describe{
#'   \item{`title`}{speech video records}
#'   \item{`query_time`}{query timestamp}
#'   \item{`retrieved_number`}{number of videos retrieved}
#'   \item{`term`}{queried legislative term}
#'   \item{`session_period`}{queried session period}
#'   \item{`start_date`}{start date in ROC calendar}
#'   \item{`end_date`}{end date in ROC calendar}
#'   \item{`format`}{data format ("json" or "csv")}
#'   \item{`url`}{retrieved API URL}
#'   \item{`variable_names`}{variables in the tibble dataframe}
#'   \item{`manual_info`}{official manual URL}
#'   \item{`data`}{a tibble dataframe containing:
#'     \describe{
#'       \item{`term`}{屆別}
#'       \item{`sessionPeriod`}{會期}
#'       \item{`meetingDate`}{會議日期(西元年)}
#'       \item{`meetingTime`}{會議時間}
#'       \item{`meetingTypeName`}{主辦單位}
#'       \item{`meetingName`}{會議名稱}
#'       \item{`meetingContent`}{會議事由}
#'       \item{`legislatorName`}{委員姓名}
#'       \item{`areaName`}{選區名稱}
#'       \item{`speechStartTime`}{委員發言時間起}
#'       \item{`speechEndTime`}{委員發言時間迄}
#'       \item{`speechRecordUrl`}{發言紀錄網址}
#'       \item{`videoLength`}{影片長度}
#'       \item{`videoUrl`}{影片網址}
#'       \item{`selectTerm`}{屆別期別篩選條件}
#'     }
#'   }
#' }
#'
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom withr with_options
#' @importFrom readr read_csv
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Query video information in JSON format
#' videos <- get_speech_video(
#'   term = 10,
#'   session_period = 4,
#'   start_date = "110/10/01",
#'   end_date = "110/10/30"
#' )
#'
#' # Query in CSV format
#' videos_csv <- get_speech_video(
#'   term = 10,
#'   session_period = 4,
#'   start_date = "110/10/01",
#'   end_date = "110/10/30",
#'   format = "csv"
#' )
#'
#' # Query without specifying term/session
#' videos <- get_speech_video(
#'   start_date = "110/10/01",
#'   end_date = "110/10/30"
#' )
#' }
#'
#' @details
#' The function retrieves video information from legislative meetings and committee
#' sessions. Data is available from the 9th legislative term onwards (2016/民國105年).
#' The date parameters must use the ROC calendar format with forward slashes.
#' Data can be retrieved in either JSON or CSV format.
#'
#' @note
#' For more details about the data variables and API information,
#' use `get_variable_info("get_speech_video")` or visit:
#' \url{https://data.ly.gov.tw/getds.action?id=148}
#'
#' 會議類:提供立法院院會及委員會之委員發言片段相關影片資訊 (自第9屆第1會期起)。
#'
#' @seealso
#' * `get_variable_info("get_speech_video")`
#' * Example API URL: \url{https://data.ly.gov.tw/odw/ID148Action.action?term=10&sessionPeriod=4&meetingDateS=110/10/01&meetingDateE=110/10/30&meetingTime=&legislatorName=&fileType=csv}
#'
#'@encoding UTF-8
get_speech_video <- function(term = NULL,
                             session_period = NULL,
                             start_date = NULL,
                             end_date = NULL,
                             verbose = TRUE,
                             format = "json") {
  # Check internet connectivity
  check_internet()

  # Format validation
  format <- match.arg(format, c("json", "csv"))

  if(isTRUE(verbose)) {
    cat("\nInput Format Information:\n")
    cat("------------------------\n")
    cat("Term: Must be numeric (e.g., 8, 9, 10)\n")
    cat("Session Period: Must be numeric (1-8)\n")
    cat("Date Format: YYY/MM/DD (ROC calendar)\n")
    cat("Example: 110/10/01\n")
    cat("------------------------\n\n")
    cat("Downloading speech video data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Date validation
  if(is.null(start_date) || is.null(end_date)) {
    stop("Both start_date and end_date must be provided")
  }

  # Input data validation
  if(!is.null(term)) {
    term_str <- sprintf("%02d", as.numeric(term))
  } else {
    term_str <- ""
  }

  if(!is.null(session_period)) {
    session_str <- sprintf("%02d", as.numeric(session_period))
  } else {
    session_str <- ""
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  # Construct API URL
  set_api_url <- paste0("https://data.ly.gov.tw/odw/ID148Action.action?",
                        "term=", term_str,
                        "&sessionPeriod=", session_str,
                        "&meetingDateS=", start_date,
                        "&meetingDateE=", end_date,
                        "&meetingTime=&legislatorName=&fileType=", format)

  # Update progress bar to 40%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 40)

  tryCatch(
    {
      # Update progress bar to 60%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 60)

      if(format == "json") {
        response <- try({
          json_df <- jsonlite::fromJSON(set_api_url)
          if(!is.null(json_df$dataList)) {
            df <- tibble::as_tibble(json_df$dataList)
          } else {
            df <- tibble::tibble()
          }
        }, silent = TRUE)
      } else {
        response <- try({
          df <- readr::read_csv(set_api_url, show_col_types = FALSE)
        }, silent = TRUE)
      }

      # Update progress bar to 80%
      if(isTRUE(verbose)) setTxtProgressBar(pb, 80)

      # Data validation
      if(nrow(df) == 0) {
        if(isTRUE(verbose)) {
          setTxtProgressBar(pb, 100)
          close(pb)
          cat("\n\n")
          cat("====== Query Result ======\n")
          cat("-------------------------\n")
          cat("No records found. Please check:\n")
          cat("1. Date format (YYY/MM/DD)\n")
          cat("2. Term and session period\n")
          cat("3. Data availability\n")
          cat("-------------------------\n")
        }
        return(NULL)
      }

      # Update progress bar to 100%
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Term: ", term_str, "\n")
        if(!is.null(session_period)) {
          cat(" Session Period: ", session_period, "\n")
        }
        cat(" Date Range: ", start_date, " to ", end_date, "\n")
        cat(" Total Videos: ", nrow(df), "\n")
        cat(" Format: ", toupper(format), "\n")
        cat("===================================\n")
      }

      # Return data
      list_data <- list(
        "title" = "speech video records",
        "query_time" = Sys.time(),
        "retrieved_number" = nrow(df),
        "term" = term_str,
        "session_period" = session_str,
        "start_date" = start_date,
        "end_date" = end_date,
        "format" = format,
        "url" = set_api_url,
        "variable_names" = colnames(df),
        "manual_info" = "https://data.ly.gov.tw/getds.action?id=148",
        "data" = df
      )
      return(list_data)
    },
    error = function(error_message) {
      if(isTRUE(verbose)) {
        close(pb)
        cat("\nError occurred:\n")
        cat(as.character(error_message), "\n")
      }
      return(NULL)
    }
  )
}


#' The Records of National Public Debates 國是論壇
#'
#' @param term numeric or NULL. The default is set to 10. Legislative term number
#' (e.g., 10). Data is officially available from the 8th term onwards, but
#' testing shows data starts from the 10th term.
#'
#' @param session_period numeric or NULL. Session period number (1-8). Default is NULL.
#' Use `review_session_info()` to see available session periods in ROC calendar.
#'
#' @param verbose logical. Whether to display download progress and detailed information.
#' Default is TRUE.
#'
#' @return A list containing:
#' \describe{
#'   \item{`title`}{public debates records}
#'   \item{`query_time`}{query timestamp}
#'   \item{`retrieved_number`}{number of records retrieved}
#'   \item{`retrieved_term`}{queried legislative term}
#'   \item{`url`}{retrieved API URL}
#'   \item{`variable_names`}{variables in the tibble dataframe}
#'   \item{`manual_info`}{official manual URL or use get_variable_info("get_public_debates")}
#'   \item{`data`}{a tibble dataframe containing:
#'     \describe{
#'       \item{`term`}{屆別}
#'       \item{`sessionPeriod`}{會期}
#'       \item{`sessionTimes`}{會次}
#'       \item{`meetingTimes`}{臨時會會次}
#'       \item{`dateTimeDesc`}{日期時間說明}
#'       \item{`meetingRoom`}{會議地點}
#'       \item{`chairman`}{主持人}
#'       \item{`legislatorName`}{委員姓名}
#'       \item{`speakType`}{發言類型(paper:書面發言,speak:發言)}
#'       \item{`content`}{內容}
#'       \item{`selectTerm`}{屆別期別篩選條件}
#'     }
#'   }
#' }
#'
#' @import utils
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom withr with_options
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Query public debates for term 10, session period 2
#' debates <- get_public_debates(term = 10, session_period = 2)
#'
#' # Query without specifying session period
#' debates <- get_public_debates(term = 10)
#' }
#' 
#' @details
#' The function retrieves records from the National Public Debates (國是論壇),
#' including both spoken and written opinions. While officially available from
#' the 8th legislative term, testing indicates data is only available from
#' the 10th term onwards.
#'
#' @note
#' For more details about the data variables and API information,
#' use `get_variable_info("get_public_debates")` or visit the API manual at
#' \url{https://data.ly.gov.tw/getds.action?id=7}.
#' 議事類: 提供公報之國是論壇資訊，並包含書面意見。
#' 自第8屆第1會期起，但實測資料從第10屆。
#'
#' @seealso
#' * `get_variable_info("get_public_debates")`
#' * `review_session_info()`
#' * For ROC calendar information: \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}
#'
#' @encoding UTF-8
get_public_debates <- function(term = NULL, session_period = NULL, verbose = TRUE) {
  check_internet()

  if(isTRUE(verbose)) {
    cat("\nInput Format Information:\n")
    cat("------------------------\n")
    cat("Term: Must be numeric (e.g., 8, 9, 10)\n")
    cat("Session Period: Must be numeric (1-8)\n")
    cat("------------------------\n\n")
    cat("Downloading public debates data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
                         sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "\nPlease use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) {
      if(isTRUE(verbose)) close(pb)
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")
    }
  }

  # Update progress bar to 40%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 40)

  set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                       term, "&sessionPeriod=",
                       sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json",
                       sep = "")

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
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")

      # Update progress bar to 100%
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")  # Add newlines after progress bar
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Term: ", term, "\n")
        if(!is.null(session_period)) {
          cat(" Session Period: ", session_period, "\n")
        }
        cat(" Total Records: ", nrow(df), "\n")
        if("legislatorName" %in% colnames(df)) {
          unique_legislators <- length(unique(df$legislatorName))
          cat(" Unique Legislators: ", unique_legislators, "\n")
        }
        cat("===================================\n")
      }

      list_data <- list(
        "title" = "public debates records",
        "query_time" = Sys.time(),
        "retrieved_number" = nrow(df),
        "retrieved_term" = term,
        "url" = set_api_url,
        "variable_names" = colnames(df),
        "manual_info" = "https://data.ly.gov.tw/getds.action?id=7",
        "data" = df
      )
      return(list_data)
    },
    error = function(error_message) {
      if(isTRUE(verbose)) {
        close(pb)
        cat("\n")
      }
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
#'@import utils
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
#'
#' @encoding UTF-8
get_committee_record <- function(term = 10, session_period = NULL, verbose = TRUE) {
  check_internet()

  if(isTRUE(verbose)) {
    cat("\nInput Format Information:\n")
    cat("------------------------\n")
    cat("Term: Must be numeric (e.g., 8, 9, 10)\n")
    cat("Session Period: Must be numeric (1-8)\n")
    cat("------------------------\n\n")
    cat("Downloading committee records data...\n")
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
  }

  # Update progress bar to 20%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 20)

  if (is.null(term)) {
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID46Action.action?term=",
                         term, "&sessionPeriod=",
                         "&sessionTimes=01&meetingTimes=&fileType=json", sep = "")
    message(" term is not defined...\n You are now requesting full data from the API. Please make sure your connectivity is stable until its completion.\n")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) {
      if(isTRUE(verbose)) close(pb)
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")
    }
  }

  # Update progress bar to 40%
  if(isTRUE(verbose)) setTxtProgressBar(pb, 40)

  set_api_url <- paste("https://data.ly.gov.tw/odw/ID46Action.action?term=",
                       term,
                       "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=01&meetingTimes=&fileType=json", sep = "")

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
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable.")

      # Update progress bar to 100%
      if(isTRUE(verbose)) {
        setTxtProgressBar(pb, 100)
        close(pb)
        cat("\n\n")  # Add newlines after progress bar
        cat("====== Retrieved Information ======\n")
        cat("-----------------------------------\n")
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Term: ", term, "\n")
        if(!is.null(session_period)) {
          cat(" Session Period: ", session_period, "\n")
        }
        cat(" Total Records: ", nrow(df), "\n")

        if("committee" %in% colnames(df)) {
          committee_counts <- table(df$committee)
          cat("\nCommittee Distribution:\n")
          for(comm in names(committee_counts)) {
            cat(sprintf(" %s: %d\n", comm, committee_counts[comm]))
          }
        }
        cat("===================================\n")
      }

      list_data <- list(
        "title" = "the records of reviewed items in the committees",
        "query_time" = Sys.time(),
        "retrieved_number" = nrow(df),
        "retrieved_term" = term,
        "url" = set_api_url,
        "variable_names" = colnames(df),
        "manual_info" = "https://data.ly.gov.tw/getds.action?id=46",
        "data" = df
      )
      return(list_data)
    },
    error = function(error_message) {
      if(isTRUE(verbose)) {
        close(pb)
        cat("\n")
      }
      message(error_message)
    }
  )
}
