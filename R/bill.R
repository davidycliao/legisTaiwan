#' Retrieving the records of billsponsor and co-sponsor via Taiwan Legislative Yuan API
#'
#'
#'@param start_date Requesting meeting records starting from the date. A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan calendar format, e.g. 1090110.
#'@param end_date Requesting meeting records ending from the date. A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan calendar format, e.g. 1090110.
#'@param proposer The default value is NULL, which means all bill records are included between the starting date and the ending date.
#'@param verbose The default value is TRUE, displaying the discription of data retrieved in number, url and computing time.
#'@return A data frame contains the date, term, name, sessionPeriod, sessionPeriod,  billProposerand, billCosignatory, billStatus (mostly in null).
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#'get_bills(1070120, 1070210)
#'@seealso
#' \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}


get_bills <- function(start_date = NULL , end_date = NULL, proposer = NULL, verbose = TRUE){
  start_time <- Sys.time()
  check_internet()
  attempt::stop_if_all(start_date, is.character, msg = "Please use numeric format")
  attempt::stop_if_all(end_date, is.character, msg = "Please use numeric format")
  attempt::stop_if_all(start_date, is.null, msg = "You need to specify start_date")
  attempt::stop_if_all(end_date, is.null, msg = "You need to specify end_date")
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=",
                       start_date, "&to=",end_date , "&proposer=", proposer,  "&mode=json",sep ="")
  json.df <- jsonlite::fromJSON(set_api_url)
  df <- as.data.frame(json.df)
  df["date"] <- do.call("c", lapply(df$smeeting_date, transformed_date))
  end_time <- Sys.time()
  time <- end_time - start_time
  return(df)
  if (isTRUE(verbose)) {
    cat(" Retrieved URL: \n", set_api_url ,"\n")
    cat(" Retrieved Bill Sponsor: \n", proposer ,"\n")
    cat(" Retrieved Date:", nrow(df))
    cat(" Retrieved Time Spent:", time[1])
    cat(" Retrieved Num:", nrow(df))
  }
}



