
#' @encoding UTF-8
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
#' @param session_times An integer specifying the session times
#' @param meet_id A string specifying the meeting ID (e.g., "院會-9-2-1")
#' @param query A string to search in interpellation reasons or content
#' @param show_progress A logical value indicating whether to show progress bar (default: TRUE)
#'
#' @return A list with two components:
#' \describe{
#'   \item{metadata}{A list containing:
#'     \itemize{
#'       \item{total}{Total number of records found}
#'       \item{total_page}{Total number of pages}
#'       \item{current_page}{Current page number}
#'       \item{per_page}{Number of records per page}
#'       \item{filters_used}{List of filters applied}
#'     }
#'   }
#'   \item{interpellations}{A data frame containing:
#'     \itemize{
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
#'   legislator = "趙天麟",
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
#'   query = "氫能",
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
#' @importFrom utils txtProgressBar setTxtProgressBar
#'
#' @seealso
#' \url{https://ly.govapi.tw/} for API documentation
#'
#' @export
#' @encoding UTF-8
# Get by legislator
#' Fetch Legislative Yuan Interpellations
#'
#' @description
#' Retrieves interpellation records from the Legislative Yuan API.
#' The function supports filtering by legislator, term, session and other attributes.
#' Returns structured data of interpellations including reason, description and metadata.
#'
#' @param page integer. Page number for pagination (default: 1)
#' @param limit integer. Number of items per page (default: 20)
#' @param legislator string. Legislator name
#' @param term integer. Legislative term, e.g., 9
#' @param session_period integer. Session period, e.g., 2
#' @param session_times integer. Session times
#' @param meet_id string. Meeting ID, e.g., "院會-9-2-1"
#' @param query string. Search query for reason or content
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \itemize{
#'   \item metadata - List of total count, total pages and pagination info
#'   \item interpellations - Data frame of interpellation records including:
#'     - id: Interpellation ID
#'     - printed_at: Print date
#'     - reason: Interpellation reason
#'     - description: Detailed content
#'     - legislators: List of legislators involved
#'     - meet_id: Meeting ID
#'     - term: Legislative term
#'     - sessionPeriod: Session period
#'     - sessionTimes: Session times
#' }
#'
#' @examples
#' # Get interpellations by legislator
#' results <- get_ly_interpellations(
#'   legislator = "趙天麟"
#' )
#'
#' # Get interpellations for specific term and session
#' results <- get_ly_interpellations(
#'   term = 9,
#'   session_period = 2,
#'   session_times = 1
#' )
#'
#' # Search interpellations by content
#' results <- get_ly_interpellations(
#'   query = "氫能"
#' )
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#'
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
  # Base URL
  base_url <- "https://ly.govapi.tw/interpellation"

  # Query parameters
  query_params <- list(
    page = page,
    limit = limit,
    term = term,
    sessionPeriod = session_period,
    sessionTimes = session_times,
    legislator = legislator,
    meet_id = meet_id,
    q = query
  )

  # Remove NULL values
  query_params <- query_params[!sapply(query_params, is.null)]

  if (show_progress) {
    cat("Fetching interpellation data...\n")
  }

  # Send GET request
  response <- httr::GET(
    base_url,
    query = query_params
  )

  # Check response status
  if (httr::status_code(response) != 200) {
    stop("API request failed with status code: ", httr::status_code(response))
  }

  # Parse response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyDataFrame = TRUE, flatten = TRUE)

  # Extract metadata
  metadata <- list(
    total = data$total$value,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  # Process interpellations
  if (length(data$interpellations) > 0) {
    if (show_progress) {
      cat("Processing", nrow(data$interpellations), "records...\n")
      pb <- txtProgressBar(min = 0, max = nrow(data$interpellations), style = 3)
    }

    # Create dataframe with progress bar
    fields <- c("id", "printed_at", "reason", "description", "meet_id",
                "term", "sessionPeriod", "sessionTimes", "ppg_url",
                "page_start", "page_end")

    interpellations_list <- vector("list", nrow(data$interpellations))

    for(i in 1:nrow(data$interpellations)) {
      if (show_progress) {
        setTxtProgressBar(pb, i)
      }

      # Extract record
      record <- data$interpellations[i,]

      # Create row data
      row_data <- c(
        sapply(fields, function(f) ifelse(is.null(record[[f]]), NA, record[[f]])),
        legislators = paste(unlist(record$legislators), collapse = ", ")
      )

      interpellations_list[[i]] <- row_data
    }

    if (show_progress) {
      close(pb)
      cat("\nProcessing complete!\n")
    }

    # Convert list to dataframe
    interpellations_df <- do.call(rbind.data.frame,
                                  lapply(interpellations_list,
                                         function(x) as.data.frame(t(x),
                                                                   stringsAsFactors = FALSE)))
    names(interpellations_df) <- c(fields, "legislators")

  } else {
    # Empty dataframe with correct structure
    interpellations_df <- data.frame(
      id = character(),
      printed_at = character(),
      reason = character(),
      description = character(),
      legislators = character(),
      meet_id = character(),
      term = integer(),
      sessionPeriod = integer(),
      sessionTimes = integer(),
      ppg_url = character(),
      page_start = integer(),
      page_end = integer(),
      stringsAsFactors = FALSE
    )
  }

  return(list(
    metadata = metadata,
    interpellations = interpellations_df
  ))
}
