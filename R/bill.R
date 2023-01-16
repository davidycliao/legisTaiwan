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
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}


get_bills <- function(start_date = NULL , end_date = NULL, proposer = NULL, verbose = TRUE){
  start_time <- Sys.time()
  check_internet()
  attempt::stop_if_all(check_date(end_date) > check_date(start_date), isFALSE, msg = paste("The start date," ,start_date, ",", "should not be later than the end date ,", end_date, "." ,sep = " "))
  attempt::stop_if_all(start_date, is.character, msg = "use numeric format only")
  attempt::stop_if_all(end_date, is.character, msg = "use numeric format only")
  attempt::stop_if_all(start_date, is.null, msg = "start_date is missing")
  attempt::stop_if_all(end_date, is.null, msg = "end_date is missing")
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=",
                       start_date, "&to=",end_date , "&proposer=", proposer,  "&mode=json",sep ="")
  tryCatch(
    # evaluate the valid date period and legislator
    {
      json.df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json.df)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = "The query unavailable during the period of the dates")
      df["date_ad"] <- do.call("c", lapply(df$date, transformed_date_bill))
      end_time <- Sys.time()
      time <- end_time - start_time
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url ,"\n")
        cat(" Retrieved Bill Sponsor(s): ", proposer ,"\n")
        cat(" Retrieved Num:", nrow(df),"\n")
      }
      return(df)
    },
    error=function(error_message) {
      message("Warning: The dates or the legislator(s) are not available in the database")
      message("INFO: The error message from the Taiwan Legislative Yuan API or R:")
      message(error_message)
      return(NA)
    }
  )
  return(df)
}


