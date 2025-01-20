#' @title Fetch and Parse Legislative Yuan Statistics 取得並解析立法院統計資料
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
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @encoding UTF-8
#' @export
get_tly_stat <- function() {
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
      dplyr::select(.data$term, .data$count) %>%
      dplyr::arrange(dplyr::desc(.data$term))
  )

  # 2. Legislator statistics
  result$legislator <- list(
    total = data$legislator$total,
    terms = data$legislator$terms %>%
      dplyr::arrange(dplyr::desc(.data$term))
  )

  # 3. Gazette statistics
  result$gazette <- list(
    total = data$gazette$total,
    agenda_total = data$gazette$agenda_total,
    last_meeting = as.POSIXct(data$gazette$max_meeting_date/1000, origin="1970-01-01"),
    yearly_stats = data$gazette$comYears %>%
      dplyr::mutate(
        meeting_date = as.POSIXct(.data$max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      dplyr::select(.data$year, .data$count, .data$agenda_count, .data$meeting_date)
  )

  # 4. Meeting statistics
  result$meet <- list(
    total = data$meet$total,
    terms = data$meet$terms %>%
      dplyr::mutate(
        max_meeting_date = as.POSIXct(.data$max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      dplyr::select(
        .data$term,
        .data$count,
        .data$max_meeting_date,
        .data$meetdata_count,
        .data$議事錄_count
      ) %>%
      dplyr::arrange(dplyr::desc(.data$term))
  )

  # 5. IVOD (video) statistics
  result$ivod <- list(
    total = data$ivod$total,
    date_range = list(
      start = as.POSIXct(data$ivod$min_meeting_date/1000, origin="1970-01-01"),
      end = as.POSIXct(data$ivod$max_meeting_date/1000, origin="1970-01-01")
    ),
    terms = data$ivod$terms %>%
      dplyr::mutate(
        start_date = as.POSIXct(.data$min_meeting_date/1000, origin="1970-01-01"),
        end_date = as.POSIXct(.data$max_meeting_date/1000, origin="1970-01-01")
      ) %>%
      dplyr::select(
        .data$term,
        .data$count,
        .data$start_date,
        .data$end_date
      ) %>%
      dplyr::arrange(dplyr::desc(.data$term))
  )

  return(result)
}
