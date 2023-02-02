### Package Utility Functions

#' @export .onAttach
.onAttach <- function(...) {
  packageStartupMessage("## legisTaiwan                                            ###")
  packageStartupMessage("## An R package connecting to the Taiwan Legislative API. ###")

}

#'A check for the website availability and the connection.
#'
#'@param site https://data.ly.gov.tw/index.action
#'
#'@seealso
#'\url{https://stackoverflow.com/questions/5076593/how-to-determine-if-you-have-an-internet-connection-in-r?noredirect=1&lq=1}
website_availability <- function(site = "https://data.ly.gov.tw/index.action") {
  tryCatch({
    readLines(site, n = 1)
    TRUE
    },
  warning = function(w) invokeRestart("muffleWarning"),
  error = function(e) FALSE)
}


#' A check for IP and connectivity.
#'@seealso
#'\url{https://stackoverflow.com/questions/5076593/how-to-determine-if-you-have-an-internet-connection-in-r?noredirect=1&lq=1}
ip_availability <- function() {
  if (.Platform$OS.type == "windows") {
    ipmessage <- system("ipconfig", intern = TRUE)
  } else {
    ipmessage <- system("ifconfig", intern = TRUE)
  }
  validIP <- "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)[.]){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
  any(grep(validIP, ipmessage))
}


#' A check for internet connectivity.
#'
#'@param x  The default value is `curl::has_internet()`, which activate the
#'internet connectivity check.
#'
#'@importFrom attempt stop_if_not
#'@importFrom curl has_internet
#'@export
check_internet <- function(x = curl::has_internet()) {
  attempt::stop_if_not(.x = x,
                       msg = "Please check the internet connetion")
}


#' A general check for the API and `legisTaiwan`.
#'
#'@param start_date  start_date is inherited from global env.
#'
#'@param end_date  end_date is inherited from global env.
#'
#'@importFrom attempt stop_if_not
#'@export
api_check <- function(start_date = start_date, end_date = end_date) {
  attempt::stop_if_all(start_date > as.Date(Sys.time()),
                       isTRUE, msg = "The start date should not be after the system time")
  attempt::stop_if_all(end_date > as.Date(Sys.time()),
                       isTRUE, msg = "The end date should not be after the system time")
  attempt::stop_if_all(start_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(end_date, is.character, msg = "use numeric format")
  attempt::stop_if_all(start_date, is.null, msg = "start_date is missing")
  attempt::stop_if_all(end_date, is.null, msg = "end_date is missing")
  attempt::stop_if_all(end_date > start_date, isFALSE,
                       msg = paste("The start date,", start_date, ",", "should not be later than the end date,",
                                   end_date, ".", sep = " "))
}


#' Transforming the date in Taiwan ROC calendar to A.D. in POSIXct
#'
#'@details `check_date` transforms ROC date to a date in POSIXct, e.g. "105/05/31" to "2016-05-31".
#'
#'@param roc_date Date format in Taiwan ROC calendar (e.g., "105/05/31") as a
#'string vector
#'
#'@return date in POSIXct
#'
#'@importFrom stringr str_split_1
#'@export
#'@examples
#'transformed_date_meeting("105/05/31")
transformed_date_meeting <- function(roc_date) {
  roc_date <- stringr::str_split_1(roc_date, "/")
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(roc_date[1]) + 1911,
                                      roc_date[2],
                                      roc_date[3], sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}


#' Transforming the date in Taiwan ROC calendar to A.D. in POSIXct  for `get_bill()`.
#'
#'@details `check_date` transforms ROC date to a date in POSIXct, e.g. "1050531" to "2016-05-31".
#'
#'@param roc_date date format in Taiwan ROC calendar (e.g., "1050531") in a
#'character vector
#'
#'@return date in POSIXct
#'
#'@importFrom stringr str_sub
#'@export
#'@examples
#'transformed_date_bill("1050531")

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


#' Checking the date
#'
#'@details `check_date` transforms ROC date to a date in POSIXct, e.g. "1050531" to "2016-05-31".
#'
#'@param roc_date date format in Taiwan ROC calendar (e.g., "1050531") in a
#'character vector
#'
#'@return date in POSIXct
#'
#'@importFrom stringr str_sub
#'@export
#'@examples
#'check_date("1050531")

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
