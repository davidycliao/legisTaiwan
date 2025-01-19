#' @title Fetch and Parse Legislative Yuan Bills 取得並解析立法院議案資料
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
#' @param bill_type string. Type of bill:
#'   - "法律案" (Law Bill)
#'   - "中央政府總預算案" (Central Government Budget Bill)
#'   - "預(決) 算決議案" (Budget/Final Account Resolution)
#'   - "定期報告" (Regular Report)
#'   - "行政命令(層級)" (Administrative Order)
#'   - "院內單位來文" (Internal Document)
#' @param current_status string. Current bill status, e.g., "排入院會"
#' @param process_status string. Status in process flow, e.g., "排入院會 (交內政委員會)"
#' @param proposer string. Bill proposer name
#' @param cosigner string. Bill cosigner name
#' @param source string. Source of bill, e.g., "委員提案"
#' @param bill_id string. Bill ID number
#' @param law_id string. Related law ID number
#' @param meeting_code string. Meeting code, e.g., "院會-11-2-3"
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \itemize{
#'   \item metadata - List of pagination info and applied filters
#'   \item bills - Data frame of bill details
#' }
#'
#' @examples
#' # Get law bills
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "法律案",
#'   show_progress = TRUE
#' )
#'
#' # Get budget bills
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "中央政府總預算案",
#'   show_progress = TRUE
#' )
#'
#' # Get administrative orders
#' bills <- get_ly_bills(
#'   term = 11,
#'   bill_type = "行政命令(層級)",
#'   show_progress = TRUE
#' )
#'
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
    屆 = term,
    會期 = session,
    議案類別 = bill_type,
    議案狀態 = current_status,
    "議案流程.狀態" = process_status,
    提案人 = proposer,
    連署人 = cosigner,
    提案來源 = source,
    議案編號 = bill_id,
    法律編號 = law_id,
    會議代碼 = meeting_code
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
        議案編號 = ifelse(is.null(bill$議案編號), NA_character_, bill$議案編號),
        議案名稱 = ifelse(is.null(bill$議案名稱), NA_character_, bill$議案名稱),
        議案狀態 = ifelse(is.null(bill$議案狀態), NA_character_, bill$議案狀態),
        議案類別 = ifelse(is.null(bill$議案類別), NA_character_, bill$議案類別),
        提案來源 = ifelse(is.null(bill$提案來源), NA_character_, bill$提案來源),
        會期 = ifelse(is.null(bill$會期), NA_integer_, as.integer(bill$會期)),
        屆 = ifelse(is.null(bill$屆), NA_integer_, as.integer(bill$屆)),
        最新進度日期 = ifelse(is.null(bill$最新進度日期), NA_character_, bill$最新進度日期),
        提案人 = if (!is.null(bill$提案人)) paste(unlist(bill$提案人), collapse = ", ") else NA_character_,
        提案單位 = ifelse(is.null(bill$`提案單位/提案委員`), NA_character_, bill$`提案單位/提案委員`),
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
      議案編號 = character(),
      議案名稱 = character(),
      議案狀態 = character(),
      議案類別 = character(),
      提案來源 = character(),
      會期 = integer(),
      屆 = integer(),
      最新進度日期 = character(),
      提案人 = character(),
      提案單位 = character(),
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
