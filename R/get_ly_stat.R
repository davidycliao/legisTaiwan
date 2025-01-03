#' Fetch and Parse Legislative Yuan Statistics
#'
#' @description
#' Retrieves statistical data from the Legislative Yuan API and parses it into a structured format.
#' The function fetches data about bills, legislators, gazettes, meetings, and IVOD records.
#'
#' @return A list containing five main components:
#' \itemize{
#'   \item bill - Statistics about legislative bills, including total count and term-wise breakdown
#'   \item legislator - Information about legislators across different terms
#'   \item gazette - Statistics about legislative gazettes and agendas
#'   \item meet - Meeting statistics including counts and dates
#'   \item ivod - Video recording statistics with date ranges
#' }
#'
#' @examples
#' \dontrun{
#' stats <- get_tly_stat()
#' # View total number of bills
#' print(stats$bill$total)
#' # View legislator counts by term
#' print(stats$legislator$terms)
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select mutate arrange desc
#' @export
get_tly_stat <- function() {
  # Check and install required packages
  if (!require("httr")) install.packages("httr")
  if (!require("jsonlite")) install.packages("jsonlite")
  if (!require("dplyr")) install.packages("dplyr")

  # Send GET request to the API
  response <- httr::GET("https://v2.ly.govapi.tw/stat")


  # Check if the request was successful
  if (httr::status_code(response) != 200) {
    stop("API request failed with status code: ", httr::status_code(response))
  }

  # Parse JSON response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)

  # Initialize result list
  result <- list()

  # 1. Bill statistics
  result$bill <- list(
    total = data$bill$total,
    max_update_time = as.POSIXct(data$bill$max_mtime/1000, origin="1970-01-01"),
    terms = data$bill$terms %>%
      select(term, count) %>%
      arrange(desc(term))
  )

  # 2. Legislator statistics
  result$legislator <- list(
    total = data$legislator$total,
    terms = data$legislator$terms %>%
      arrange(desc(term))
  )

  # 3. Gazette statistics
  result$gazette <- list(
    total = data$gazette$total,
    agenda_total = data$gazette$agenda_total,
    last_meeting = as.POSIXct(data$gazette$max_meeting_date/1000, origin="1970-01-01"),
    yearly_stats = data$gazette$comYears %>%
      mutate(
        meeting_date = as.POSIXct(max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      select(year, count, agenda_count, meeting_date)
  )

  # 4. Meeting statistics
  result$meet <- list(
    total = data$meet$total,
    terms = data$meet$terms %>%
      mutate(
        max_meeting_date = as.POSIXct(max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      select(term, count, max_meeting_date, meetdata_count, 議事錄_count) %>%
      arrange(desc(term))
  )

  # 5. IVOD (video) statistics
  result$ivod <- list(
    total = data$ivod$total,
    date_range = list(
      start = as.POSIXct(data$ivod$min_meeting_date/1000, origin="1970-01-01"),
      end = as.POSIXct(data$ivod$max_meeting_date/1000, origin="1970-01-01")
    ),
    terms = data$ivod$terms %>%
      mutate(
        start_date = as.POSIXct(min_meeting_date/1000, origin="1970-01-01"),
        end_date = as.POSIXct(max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      select(term, count, start_date, end_date) %>%
      arrange(desc(term))
  )

  return(result)
}
