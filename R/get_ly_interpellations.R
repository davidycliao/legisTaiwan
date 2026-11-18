#' @title Get Legislative Yuan Interpellation Records
#'
#' @description
#' Fetches and parses interpellation records from the Legislative Yuan API.
#' Supports filtering by legislator, term, session and keyword search.
#' Returns structured data including metadata and detailed interpellation records.
#'
#' @param page An integer specifying the page number (default: 1)
#' @param limit An integer specifying the number of records per page (default: 20)
#' @param legislator A string specifying the legislator's name
#' @param term An integer specifying the legislative term number
#' @param session_period An integer specifying the session period
#' @param session_times An integer specifying the session times (meeting number).
#'   The API has no direct filter for this, so it requires \code{term} and
#'   \code{session_period} and is converted to a plenary \code{meet_id}
#' @param meet_id A string specifying the meeting ID, using the API's own
#'   meeting-type label (in Chinese) combined with term-session-times numbers
#'   (e.g., a plenary-session meeting in term 9, session 2, session-times 1)
#' @param query A string for full-text search. Wrap it in double quotes
#'   (e.g. \code{'"keyword"'}) for an exact phrase match
#' @param show_progress A logical value indicating whether to show progress bar (default: TRUE)
#'
#' @return A list with two components:
#' \describe{
#'   \item{metadata}{A list containing pagination and filter information:
#'     \describe{
#'       \item{total}{Total number of records found}
#'       \item{total_page}{Total number of pages}
#'       \item{current_page}{Current page number}
#'       \item{per_page}{Number of records per page}
#'       \item{filters_used}{List of filters applied}
#'     }
#'   }
#'   \item{interpellations}{A data frame containing interpellation records:
#'     \describe{
#'       \item{id}{Interpellation ID}
#'       \item{printed_at}{Date when printed}
#'       \item{reason}{Interpellation reason}
#'       \item{description}{Detailed content}
#'       \item{legislators}{Comma-separated list of legislators}
#'       \item{meet_id}{Meeting ID}
#'       \item{term}{Legislative term}
#'       \item{sessionPeriod}{Session period}
#'       \item{sessionTimes}{Session times}
#'       \item{ppg_url}{URL to the parliamentary record}
#'     }
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Get interpellations by legislator
#' zhao_records <- get_ly_interpellations(
#'   legislator = "Chao Tien-lin",  # a legislator's Chinese name goes here
#'   limit = 5
#' )
#'
#' # Get interpellations for specific term and session
#' session_records <- get_ly_interpellations(
#'   term = 9,
#'   session_period = 2,
#'   session_times = 1
#' )
#'
#' # Search interpellations by keyword
#' search_results <- get_ly_interpellations(
#'   query = "hydrogen energy",  # a Chinese-language keyword goes here
#'   page = 1,
#'   limit = 20
#' )
#'
#' # View results
#' print(paste("Total records:", search_results$metadata$total))
#' head(search_results$interpellations)
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#'
#' @seealso
#' \url{https://v2.ly.govapi.tw/swagger} for API documentation
#'
#' @encoding UTF-8
#' @export
get_ly_interpellations <- function(
    page = 1,
    limit = 20,
    legislator = NULL,
    term = NULL,
    session_period = NULL,
    session_times = NULL,
    meet_id = NULL,
    query = NULL,
    show_progress = TRUE
) {
  base_url <- "https://v2.ly.govapi.tw/interpellations"

  # API v2 has no session-times filter; interpellations are plenary-only,
  # so term + period + times maps to a plenary meeting code.
  if (!is.null(session_times) && is.null(meet_id)) {
    if (is.null(term) || is.null(session_period)) {
      stop("`session_times` requires both `term` and `session_period`.")
    }
    meet_id <- sprintf("\u9662\u6703-%d-%d-%d", as.integer(term),
                       as.integer(session_period), as.integer(session_times))
  }

  query_params <- list(
    page = page,
    limit = limit,
    "\u8cea\u8a62\u59d4\u54e1" = legislator,  # 質詢委員
    "\u5c46" = term,  # 屆
    "\u6703\u671f" = session_period,  # 會期
    "\u6703\u8b70\u4ee3\u78bc" = meet_id,  # 會議代碼
    q = query
  )
  query_params <- query_params[!vapply(query_params, is.null, logical(1))]

  if (show_progress) {
    cat("Fetching interpellation data...\n")
  }

  response <- httr::GET(base_url, query = query_params)
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- tryCatch(jsonlite::fromJSON(content, simplifyVector = FALSE),
                   error = function(e) NULL)

  if (httr::status_code(response) != 200 || is.null(data) || isTRUE(data$error)) {
    stop("API request failed with status code: ", httr::status_code(response),
         if (!is.null(data$message)) paste0(" (", data$message, ")"))
  }

  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  records <- data$interpellations
  field <- function(name, cast = as.character) {
    cast(vapply(records, function(r) {
      v <- r[[name]]
      if (is.null(v)) NA_character_ else as.character(v)
    }, character(1)))
  }

  interpellations_df <- data.frame(
    id = field("\u8cea\u8a62\u7de8\u865f"),
    printed_at = field("\u520a\u767b\u65e5\u671f"),
    reason = field("\u4e8b\u7531"),
    description = field("\u8aaa\u660e"),
    legislators = vapply(records, function(r)
      paste(unlist(r[["\u8cea\u8a62\u59d4\u54e1"]]), collapse = ", "), character(1)),
    meet_id = field("\u6703\u8b70\u4ee3\u78bc"),
    term = field("\u5c46", as.integer),
    sessionPeriod = field("\u6703\u671f", as.integer),
    sessionTimes = field("\u6703\u6b21", as.integer),
    ppg_url = field("source_page"),
    page_start = field("\u8cea\u8a62\u8d77\u59cb\u9801", as.integer),
    page_end = field("\u8cea\u8a62\u7d50\u675f\u9801", as.integer),
    stringsAsFactors = FALSE
  )

  if (show_progress) {
    cat("Retrieved", nrow(interpellations_df), "of", metadata$total, "records.\n")
  }

  list(
    metadata = metadata,
    interpellations = interpellations_df
  )
}
