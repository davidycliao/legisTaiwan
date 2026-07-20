#' @title Fetch and Parse Legislative Yuan Bills
#'
#' @description
#' Retrieves bill information from the Legislative Yuan API with comprehensive filter options.
#' Supports filtering by term, session, bill type, status, and other attributes.
#' Returns both metadata and detailed bill information.
#'
#' @param page integer. Page number for pagination (default: 1)
#' @param per_page integer. Number of items per page (default: 20)
#' @param term integer. Legislative term, e.g., 11
#' @param session integer. Legislative session period, e.g., 2
#' @param bill_type string. Type of bill. The API expects the Chinese-language
#'   category name, e.g.:
#'   - Law Bill
#'   - Central Government Budget Bill
#'   - Budget/Final Account Resolution
#'   - Regular Report
#'   - Administrative Order
#'   - Internal Document
#' @param current_status string. Current bill status, in Chinese (e.g., "scheduled
#'   for plenary session")
#' @param process_status string. Status in process flow, in Chinese (e.g.,
#'   "scheduled for plenary session, referred to the Interior Committee")
#' @param proposer string. Bill proposer name
#' @param cosigner string. Bill cosigner name
#' @param source string. Source of bill, in Chinese (e.g., "legislator proposal")
#' @param bill_id string. Bill ID number
#' @param law_id string. Related law ID number
#' @param meeting_code string. Meeting code, e.g., a plenary-session meeting in
#'   term 11, session 2, session-times 3
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \itemize{
#'   \item metadata - List of pagination info and applied filters
#'   \item bills - Data frame of bill details
#' }
#'
#' @examples
#' \dontrun{
#' # Get law bills
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "Law Bill",  # pass the Chinese-language category name here
#'   show_progress = TRUE
#' )
#'
#' # Get budget bills
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "Central Government Budget Bill",  # in Chinese
#'   show_progress = TRUE
#' )
#'
#' # Get administrative orders
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "Administrative Order",  # in Chinese
#'   show_progress = TRUE
#' )
#'}
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @encoding UTF-8
#' @export
get_ly_bills <- function(
    page = 1,
    per_page = 20,
    term = NULL,           # Legislative term
    session = NULL,        # Session period
    bill_type = NULL,      # Bill type
    current_status = NULL, # Current status
    process_status = NULL, # Process flow status
    proposer = NULL,       # Proposer name
    cosigner = NULL,       # Cosigner name
    source = NULL,         # Bill source
    bill_id = NULL,        # Bill ID
    law_id = NULL,         # Law ID
    meeting_code = NULL,   # Meeting code
    show_progress = TRUE   # Show progress bar
) {
  # Construct API base URL
  base_url <- "https://v2.ly.govapi.tw/bills"

  # Build query parameters
  query_params <- list(
    page = page,
    per_page = per_page,
    "\u5c46" = term,
    "\u6703\u671f" = session,
    "\u8b70\u6848\u985e\u5225" = bill_type,
    "\u8b70\u6848\u72c0\u614b" = current_status,
    "\u8b70\u6848\u6d41\u7a0b.\u72c0\u614b" = process_status,
    "\u63d0\u6848\u4eba" = proposer,
    "\u9023\u7f72\u4eba" = cosigner,
    "\u63d0\u6848\u4f86\u6e90" = source,
    "\u8b70\u6848\u7de8\u865f" = bill_id,
    "\u6cd5\u5f8b\u7de8\u865f" = law_id,
    "\u6703\u8b70\u4ee3\u78bc" = meeting_code
  )

  # Remove NULL parameters
  query_params <- query_params[!sapply(query_params, is.null)]

  # Show initial progress message
  if (show_progress) {
    cat("Fetching data...\n")
  }

  # Send GET request to API
  response <- httr::GET(
    base_url,
    query = query_params
  )

  # Check response status
  if (httr::status_code(response) != 200) {
    stop("API request failed with status code: ", httr::status_code(response))
  }

  # Show data received message
  if (show_progress) {
    cat("Data received successfully, processing...\n")
  }

  # Parse JSON response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)

  # Extract metadata
  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  # Show processing message with total count
  if (show_progress) {
    cat(sprintf("Found %d bills, converting...\n", length(data$bills)))
  }

  # Process bills if available
  if (length(data$bills) > 0) {
    # Initialize progress bar
    if (show_progress) {
      pb <- utils::txtProgressBar(min = 0, max = length(data$bills), style = 3)
    }

    # Convert bills to data frame
    bills_list <- lapply(seq_along(data$bills), function(i) {
      bill <- data$bills[[i]]

      # Update progress bar
      if (show_progress) {
        setTxtProgressBar(pb, i)
      }

      # Extract bill fields with NULL handling
      data.frame(
        "\u8b70\u6848\u7de8\u865f" = ifelse(is.null(bill[["\u8b70\u6848\u7de8\u865f"]]), NA_character_, bill[["\u8b70\u6848\u7de8\u865f"]]),
        "\u8b70\u6848\u540d\u7a31" = ifelse(is.null(bill[["\u8b70\u6848\u540d\u7a31"]]), NA_character_, bill[["\u8b70\u6848\u540d\u7a31"]]),
        "\u8b70\u6848\u72c0\u614b" = ifelse(is.null(bill[["\u8b70\u6848\u72c0\u614b"]]), NA_character_, bill[["\u8b70\u6848\u72c0\u614b"]]),
        "\u8b70\u6848\u985e\u5225" = ifelse(is.null(bill[["\u8b70\u6848\u985e\u5225"]]), NA_character_, bill[["\u8b70\u6848\u985e\u5225"]]),
        "\u63d0\u6848\u4f86\u6e90" = ifelse(is.null(bill[["\u63d0\u6848\u4f86\u6e90"]]), NA_character_, bill[["\u63d0\u6848\u4f86\u6e90"]]),
        "\u6703\u671f" = ifelse(is.null(bill[["\u6703\u671f"]]), NA_integer_, as.integer(bill[["\u6703\u671f"]])),
        "\u5c46" = ifelse(is.null(bill[["\u5c46"]]), NA_integer_, as.integer(bill[["\u5c46"]])),
        "\u6700\u65b0\u9032\u5ea6\u65e5\u671f" = ifelse(is.null(bill[["\u6700\u65b0\u9032\u5ea6\u65e5\u671f"]]), NA_character_, bill[["\u6700\u65b0\u9032\u5ea6\u65e5\u671f"]]),
        "\u63d0\u6848\u4eba" = if (!is.null(bill[["\u63d0\u6848\u4eba"]])) paste(unlist(bill[["\u63d0\u6848\u4eba"]]), collapse = ", ") else NA_character_,
        "\u63d0\u6848\u55ae\u4f4d" = ifelse(is.null(bill[["\u63d0\u6848\u55ae\u4f4d/\u63d0\u6848\u59d4\u54e1"]]), NA_character_, bill[["\u63d0\u6848\u55ae\u4f4d/\u63d0\u6848\u59d4\u54e1"]]),
        url = ifelse(is.null(bill$url), NA_character_, bill$url),
        stringsAsFactors = FALSE
      )
    })

    # Close progress bar
    if (show_progress) {
      close(pb)
      cat("\nConversion complete!\n")
    }

    # Combine all data frames
    bills_df <- do.call(rbind, bills_list)

  } else {
    # Create empty dataframe with correct structure if no bills found
    bills_df <- data.frame(
      "\u8b70\u6848\u7de8\u865f" = character(),
      "\u8b70\u6848\u540d\u7a31" = character(),
      "\u8b70\u6848\u72c0\u614b" = character(),
      "\u8b70\u6848\u985e\u5225" = character(),
      "\u63d0\u6848\u4f86\u6e90" = character(),
      "\u6703\u671f" = integer(),
      "\u5c46" = integer(),
      "\u6700\u65b0\u9032\u5ea6\u65e5\u671f" = character(),
      "\u63d0\u6848\u4eba" = character(),
      "\u63d0\u6848\u55ae\u4f4d" = character(),
      url = character(),
      stringsAsFactors = FALSE
    )
  }

  # Show completion message
  if (show_progress) {
    cat(sprintf("Processing complete! Total bills processed: %d\n", nrow(bills_df)))
  }

  # Return results
  return(list(
    metadata = metadata,
    bills = bills_df
  ))
}
