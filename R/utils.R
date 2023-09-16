#' Validate Date Formats
#'
#' This function checks if the provided start and end dates are in the correct numeric format.
#'
#' @param start_date A string representing the start date. Expected format is numeric, e.g., "1090101".
#' @param end_date A string representing the end date. Expected format is numeric, e.g., "1090101".
#' @return NULL. If the dates are not in the expected format, an error is thrown.
#' @examples
#' # This should throw an error:
#' \dontrun{
#' validate_dates_format("10901", "1100101")
#' }
#' @keywords internal
validate_dates_format <- function(start_date, end_date) {
  valid_date_format <- function(date) {
    return(grepl("^\\d{7}$", date))
  }

  if (!valid_date_format(start_date) || !valid_date_format(end_date)) {
    stop("Dates should be in numeric format. E.g., 1090101.")
  }
}


#' Check for the Website Availability I
#'
#' This function checks the availability of a specified website by trying to read
#' the first line of the site's content.
#'
#' @param site A website URL to check. Default is "https://data.ly.gov.tw/index.action".
#'
#' @seealso
#' `check_internet()`
#'
#' @keywords internal
website_availability <- function(site = "https://data.ly.gov.tw/index.action") {
  tryCatch({
    readLines(site, n = 1)
    TRUE
  },
  warning = function(w) invokeRestart("muffleWarning"),
  error = function(e) FALSE)
}

#' Check for the Website Availability II
#'
#' This function checks the availability of a specified website by trying to read
#' the first line of the site's content.
#'
#' @param site A website URL to check. Default is "https://npl.ly.gov.tw/do/www/appDate?status=0&expire=02&startYear=0".
#'
#' @keywords internal
#' @seealso `check_internet()` and `website_availability()`.
website_availability2 <- function(site = "https://npl.ly.gov.tw/do/www/appDate?status=0&expire=02&startYear=0") {
  tryCatch({
    readLines(site, n = 1)
    TRUE
  },
  warning = function(w) invokeRestart("muffleWarning"),
  error = function(e) FALSE)
}



#' A Check for Internet Connectivity.
#'
#'@param x  The default value is `curl::has_internet()`, which activate the
#'internet connectivity check.
#'
#'@importFrom attempt stop_if_not
#'
#'@importFrom curl has_internet
#'
#'@keywords internal
check_internet <- function(x = curl::has_internet()) {
  attempt::stop_if_not(.x = x,
                       msg = "Please check the internet connection")
}

#' A General Check for Taiwan Legislative Yuan API
#'
#'@param start_date  start_date is inherited from global env.
#'
#'@param end_date  end_date is inherited from global env.
#'
#'@importFrom attempt stop_if_not
#'@keywords internal
# api_check <- function(start_date = start_date, end_date = end_date) {
#   attempt::stop_if_all(start_date > as.Date(Sys.time()),
#                        isTRUE, msg = "The start date should not be after the system time")
#   attempt::stop_if_all(end_date > as.Date(Sys.time()),
#                        isTRUE, msg = "The end date should not be after the system time")
#   attempt::stop_if_all(start_date, is.character, msg = "use numeric format")
#   attempt::stop_if_all(end_date, is.character, msg = "use numeric format")
#   attempt::stop_if_all(start_date, is.null, msg = "start_date is missing")
#   attempt::stop_if_all(end_date, is.null, msg = "end_date is missing")
#   attempt::stop_if_all(end_date > start_date, isFALSE,
#                        msg = paste("The start date, ", start_date, ",", " should not be later than the end date, ",
#                                    end_date, ".", sep = ""))
# }
api_check <- function(start_date = start_date, end_date = end_date) {

  attempt::stop_if_all(start_date > as.Date(Sys.time()),
                       isTRUE, msg = "The start date should not be after the current system time.")
  attempt::stop_if_all(end_date > as.Date(Sys.time()),
                       isTRUE, msg = "The end date should not be after the current system time.")
  attempt::stop_if_all(start_date, is.character,
                       msg = "Use numeric format for start_date.")
  attempt::stop_if_all(end_date, is.character,
                       msg = "Use numeric format for end_date.")
  attempt::stop_if_all(start_date, is.null,
                       msg = "The parameter 'start_date' is missing.")
  attempt::stop_if_all(end_date, is.null,
                       msg = "The parameter 'end_date' is missing.")
  attempt::stop_if_all(end_date > start_date, isFALSE,
                       msg = paste("The start date, ", start_date, ",", " should not be later than the end date, ",
                                   end_date, ".", sep = ""))
}


#' Transforming Minguo (Taiwan) Calendar to A.D. Calendar I
#'
#' @description `transformed_date_meeting()` transforms Minguo (Taiwan) Calendar
#' to A.D. calendar in POSIXct for `get_meetings()`, `get_caucus_meetings()`,
#' and `get_speech_video()`,
#'
#' @param roc_date Date format in Minguo (Taiwan) calendar (e.g., "105/05/31") as a
#' string vector
#'
#' @return date in POSIXct
#'
#' @importFrom stringr str_split_1
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' transformed_date_meeting("105/05/31")
#' }
#'
#' @details `check_date` transforms ROC date to a date in POSIXct, e.g. "105/05/31" to "2016-05-31".
transformed_date_meeting <- function(roc_date) {
  roc_date <- stringr::str_split_1(roc_date, "/")
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(roc_date[1]) + 1911,
                                      roc_date[2],
                                      roc_date[3], sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}


#' Transforming Minguo (Taiwan) Calendar to A.D. Calendar II
#'
#' @description `transformed_date_meeting()` transforms Minguo (Taiwan) Calendar
#' to A.D. format in POSIXct for `get_bill()`, e.g. "1050531" to "2016-05-31".
#'
#' @param roc_date date format in Taiwan ROC calendar (e.g., "1050531") in a character vector
#'
#' @return date in POSIXct
#'
#' @importFrom stringr str_sub
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' transformed_date_bill("1050531")
#' }
transformed_date_bill <- function(roc_date) {
  day <- stringr::str_sub(roc_date, -2, -1)
  month <- stringr::str_sub(roc_date, -4, -3)
  roc_year <- stringr::str_sub(roc_date, 1, nchar(roc_date) - nchar(stringr::str_sub(roc_date, -4, -1)))
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(roc_year) + 1911,
                                      as.numeric(month),
                                      as.numeric(day), sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}

#' Transforming Minguo (Taiwan) Calendar to A.D. Calendar III
#'
#'@description `transformed_date_meeting()` transforms Minguo (Taiwan) Calendar
#'to A.D. format in POSIXct for `get_bill()`, e.g. "1050531" to "2016-05-31".
#'
#'@param roc_date date format in Minguo (Taiwan) Calendar (e.g., "1050531") in a
#'character vector
#'
#'@return date in POSIXct
#'
#'@importFrom stringr str_sub
#'
#'@keywords internal
check_date <- function(roc_date) {
  day <- stringr::str_sub(roc_date, -2, -1)
  month <- stringr::str_sub(roc_date, -4, -3)
  roc_year <- stringr::str_sub(roc_date, 1, nchar(roc_date) - nchar(stringr::str_sub(roc_date, -4, -1)))
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(roc_year) + 1911,
                                      as.numeric(month),
                                      as.numeric(day), sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}


#' Transforming Minguo (Taiwan) Calendar to A.D. Calendar IIII
#'
#'@description `transformed_date_meeting()` transforms Minguo (Taiwan) Calendar
#'to A.D. format in POSIXct for `get_bill()`, e.g. "1050531" to "2016-05-31".
#'
#'@param roc_date Date format in Minguo (Taiwan) calendar (e.g., "105/05/31") as a
#'string vector
#'
#'@return date in POSIXct
#'
#'@importFrom stringr str_split_1
#'
#'@keywords internal
#'
#' @examples
#' \dontrun{
#' check_date2("105/05/31")
#' }
#'
#'@details `check_date` transforms ROC date to a date in POSIXct, e.g. "105/05/31" to "2016-05-31".
check_date2 <- function(roc_date) {
  roc_date <- stringr::str_split_1(roc_date, "/")
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(roc_date[1]) + 1911,
                                      roc_date[2],
                                      roc_date[3], sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}
