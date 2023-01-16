### Package Utility Functions

#' @export .onAttach
.onAttach <- function(...) {
  # crearted_date <- date()
  # x <- regexpr("[0-9]{4}", crearted_date)
  # this.year <- substr(crearted_date, x[1], x[1] + attr(x, "match.length") - 1)
  packageStartupMessage("## legisTaiwan")
  packageStartupMessage("## R package for downloading spoken meeting records, bill sponsors and more from the Taiwan Legislative Yuan API.")
}


#' A basic check for internet connectivity
#'
#'@param x  The default value is curl::has_internet(), which activate the internet check.
#'@importFrom attempt stop_if_not
#'@importFrom curl has_internet
check_internet <- function(x = curl::has_internet()){
  attempt::stop_if_not(.x = x,
                       msg = "Please check the internet connetion")
}


#' Transforming meeting date in Taiwan ROC calendar to A.D. format
#'
#'@param ROCdate Date format in Taiwan ROC calendar (e.g., "105/05/31") as a string vector
#'@return date format in A.D. format
#'
#'@importFrom stringr str_split_1
#'@export
#'@examples
#'transformed_date_meeting("105/05/31")

transformed_date_meeting <- function(ROCdate){
  ROCdate <- stringr::str_split_1(ROCdate, "/")
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(ROCdate[1])+1911,
                                      ROCdate[2],
                                      ROCdate[3], sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}



#' Transforming bill proposed date in Taiwan ROC calendar to A.D. format
#'
#'@param ROCdate date format in Taiwan ROC calendar (e.g., "1050531") as a string vector
#'@return date format in A.D. format
#'
#'@importFrom stringr str_sub
#'@export
#'@examples
#'transformed_date_bill("1050531")

transformed_date_bill <- function(ROCdate){
  day <- stringr::str_sub(ROCdate,-2,-1)
  month <- stringr::str_sub(ROCdate,-4,-3)
  ROCyear <- stringr::str_sub(ROCdate, 1, nchar(ROCdate) - nchar(stringr::str_sub(ROCdate,-4,-1)))
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(ROCyear) + 1911,
                                      as.numeric(month),
                                      as.numeric(day), sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}


#' Checking the date
#'
#'@param ROCdate date format in Taiwan ROC calendar (e.g., "1050531") as a string vector
#'@return date format in A.D. format
#'
#'@importFrom stringr str_sub
#'@export
#'@examples
#'check_date("1050531")

check_date <- function(ROCdate){
  day <- stringr::str_sub(ROCdate,-2,-1)
  month <- stringr::str_sub(ROCdate,-4,-3)
  ROCyear <- stringr::str_sub(ROCdate, 1, nchar(ROCdate) - nchar(stringr::str_sub(ROCdate,-4,-1)))
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(ROCyear) + 1911,
                                      as.numeric(month),
                                      as.numeric(day), sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}




