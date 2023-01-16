#' Retrieving the meeting records via Taiwan Legislative Yuan (The Legislature) API
#'
#'
#'@param start_date Requesting meeting records starting from the date. A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan calendar format, e.g. 1090110.
#'@param end_date Requesting meeting records ending from the date. A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan calendar format, e.g. 1090110.
#'@param meeting_unit The default is NULL, which include all meetings  between the starting date and the ending date.
#'@param verbose The default value is TRUE, displaying the discription of data retrieved in number, url and computing time.
#'@return A tibble dataframe contains the date, status, name, content and speakers.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#'get_meetings(1070120, 1070210)
#'@seealso
#' \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}


get_meetings <- function(start_date = NULL , end_date = NULL, meeting_unit = NULL, verbose = TRUE){
  start_time <- Sys.time()
  check_internet()
  attempt::stop_if_all(check_date(end_date) > check_date(start_date), isFALSE, msg = paste("start date," ,start_date, ",", "should not be later than end date ,", end_date, "." ,sep = ""))
  attempt::stop_if_all(start_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(end_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(start_date, is.null, msg = "start_date is missing")
  attempt::stop_if_all(end_date, is.null, msg = "end_date is missing")
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=",end_date , "&meeting_unit=", meeting_unit,  "&mode=json",sep ="")

  tryCatch(
    # evaluate the valid date period and meeting units are valid in the API
    {
      json.df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json.df)
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, transformed_date_meeting))
      end_time <- Sys.time()
      time <- end_time - start_time
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url ,"\n")
        cat(" Retrieved via :", meeting_unit ,"\n")
        cat(" Retrieved Date:", nrow(df),"\n")
        cat(" Retrieved Time Spent:", time[1],"\n")
        cat(" Retrieved Num:", nrow(df))
      }
      return(df)
    },
    error = function(error_message) {
      message("Warning: dates or legislators are not available")
      message("INFO: The error message from Taiwan Legislative Yuan API:")
      message(error_message)
      return(NA)
    }
  )
  return(df)
}



