#' Retrieving the meeting records via
#' Taiwan Legislative Yuan (The Legislature) API
#'
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
#'@return A tibble dataframe contains the date, status,
#' name, content and speakers.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#'get_meetings(1070120, 1070210)
#'@seealso
#' \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}


get_meetings <- function(start_date = NULL, end_date = NULL,
                         meeting_unit = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(start_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(end_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(start_date, is.null, msg = "start_date is missing")
  attempt::stop_if_all(end_date, is.null, msg = "end_date is missing")
  attempt::stop_if_all(legisTaiwan::check_date(end_date) > legisTaiwan::check_date(start_date), isFALSE,
                       msg = paste("The start date,", start_date, ",",
                                   "should not be later than the end date ,",
                                   end_date, ".", sep = " "))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date, "&meeting_unit=",
                       meeting_unit,  "&mode=json", sep = "")

  tryCatch(
    # evaluate the valid date period and meeting units are valid in the API
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg =
                             "The query unavailable by the period of the dates")
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, legisTaiwan::transformed_date_meeting))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved via :", meeting_unit, "\n")
        cat(" Retrieved Num:", nrow(df), "\n")
      }
      return(df)
    },
    error = function(error_message) {
      message("Warning: The dates or the meeting unit(s) are not available in the database")
      message("INFO: The error message from the Taiwan Legislative Yuan API/R:")
      message(error_message)
      return(NA)
    }
  )
  return(df)
}
