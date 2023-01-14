### Package Utility Functions

#' @export .onAttach
.onAttach <- function(...) {
  # crearted_date <- date()
  # x <- regexpr("[0-9]{4}", crearted_date)
  # this.year <- substr(crearted_date, x[1], x[1] + attr(x, "match.length") - 1)
  packageStartupMessage("## legisTaiwan")
  packageStartupMessage("## R package for downloading spokend meeting record, bill sponsors and more from the Taiwian Legislative Yuan API.")
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


#' A function for transforming date from Taiwan ROC calendar into A.D. format
#'
#'@param rocdate Date format in Taiwan ROC calendar (e.g., "105/05/31") as a string vector
#'@return date
#'
#'@importFrom stringr str_split_1
#'@export
#'@examples
#'transformed_date("105/05/31")

transformed_date <- function(rocdate){
  rocdate <- stringr::str_split_1(rocdate, "/")
  date_ad <- as.Date(as.POSIXct(paste(as.numeric(rocdate[1])+1911,
                                      rocdate[2],
                                      rocdate[3], sep = "-"),
                                origin = "1582-10-14", tz = "GMT"))
  return(date_ad)
}


