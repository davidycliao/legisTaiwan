### Package Utility Functions

#' @export .onAttach
.onAttach <- function(...) {
  packageStartupMessage("## legisTaiwan")
  packageStartupMessage("## An R package connecting to the Taiwan Legislative API.")

}


#' A basic check for internet connectivity
#'
#'@param x  The default value is curl::has_internet(), which activate the
#'internet check.
#'@importFrom attempt stop_if_not
#'@importFrom curl has_internet
check_internet <- function(x = curl::has_internet()) {
  attempt::stop_if_not(.x = x,
                       msg = "Please check the internet connetion")
}


#' Transforming meeting date in Taiwan ROC calendar to A.D. format
#'
#'@param roc_date Date format in Taiwan ROC calendar (e.g., "105/05/31")
#'as a string vector
#'@return date format in A.D. format
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



#' Transforming bill proposed date in Taiwan ROC calendar to A.D. format
#'
#'@param roc_date date format in Taiwan ROC calendar (e.g., "1050531") as a
#'string vector
#'@return date format in A.D. format
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
#'@param roc_date date format in Taiwan ROC calendar (e.g., "1050531") as
#'a string vector
#'@return date format in A.D. format
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
