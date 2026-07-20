#' Get Legislator's Cosigned Bills
#'
#' @title Fetch Bills Cosigned by a Legislator
#'
#' @description
#' Retrieves bills that were cosigned by a specific legislator by term and name from the Legislative Yuan API.
#'
#' @param term required integer. Legislative term number (e.g. 9)
#' @param name required string. Legislator name in Chinese (e.g. the legislator
#'   romanized as "Wang Jin-pyng")
#' @param page integer. Page number for pagination (default: 1)
#' @param limit integer. Number of records per page (default: 20)
#' @param show_progress logical. Whether to display progress info (default: TRUE)
#'
#' @return A list containing two components:
#' \describe{
#'   \item{metadata}{A list containing pagination information:
#'     \describe{
#'       \item{total}{Total number of cosigned bills}
#'       \item{total_page}{Total number of pages}
#'       \item{current_page}{Current page number}
#'       \item{per_page}{Number of records per page}
#'     }
#'   }
#'   \item{bills}{A data frame containing bill information:
#'     \describe{
#'       \item{billNo}{Bill number}
#'       \item{billName}{Bill name (raw column name is a Chinese label)}
#'       \item{billOrg}{Proposing unit/legislator (raw column name is a Chinese label)}
#'       \item{billStatus}{Bill status (raw column name is a Chinese label)}
#'       \item{billType}{Bill type (raw column name is a Chinese label)}
#'       \item{billSource}{Source (raw column name is a Chinese label)}
#'       \item{meet_id}{Meeting ID}
#'       \item{session}{Session period (raw column name is a Chinese label)}
#'       \item{caseNo}{Case number (raw column name is a Chinese label)}
#'       \item{proposalNo}{Proposal number (raw column name is a Chinese label)}
#'       \item{term}{Term (raw column name is a Chinese label)}
#'       \item{mtime}{Last modified time}
#'     }
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Get cosigned bills
#' bills <- get_ly_legislator_cosign_bills(
#'   term = 9,
#'   name = "Wang Jin-pyng",  # a legislator's Chinese name goes here
#'   limit = 5
#' )
#'
#' # Print results
#' print(paste("Total cosigned bills:", bills$metadata$total))
#' print("Latest cosigned bill:")
#' print(bills$bills[1, c("billName", "billStatus")])  # actual columns are named in Chinese
#'
#' # Get second page of results
#' bills_page2 <- get_ly_legislator_cosign_bills(
#'   term = 9,
#'   name = "Wang Jin-pyng",  # a legislator's Chinese name goes here
#'   page = 2,
#'   limit = 20
#' )
#' }
#'
#' @seealso
#' \describe{
#'   \item{get_ly_legislator_bills}{\code{\link{get_ly_legislator_bills}} for retrieving bills proposed by a legislator}
#'   \item{get_ly_legislator_detail}{\code{\link{get_ly_legislator_detail}} for legislator's detailed information}
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @encoding UTF-8
#' @export
get_ly_legislator_cosign_bills <- function(
    term,
    name,
    page = 1,
    limit = 20,
    show_progress = TRUE
) {
  # Parameter validation
  if(missing(term)) stop("term parameter is required")
  if(missing(name)) stop("name parameter is required")
  if(!is.numeric(term)) stop("term must be numeric")
  if(!is.character(name)) stop("name must be character")

  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching cosigned bills by %s (term %d)...\n", name, term))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

  # Base URL
  base_url <- sprintf("https://ly.govapi.tw/legislator/%d/%s/cosign_bill", term, name)

  # Query parameters
  query_params <- list(
    page = page,
    limit = limit
  )

  # Update progress - API call
  if(show_progress) {
    setTxtProgressBar(pb, 40)
  }

  # Send GET request
  response <- httr::GET(
    base_url,
    query = query_params
  )

  # Check response status
  if (httr::status_code(response) != 200) {
    if(show_progress) close(pb)
    stop("API request failed with status code: ", httr::status_code(response))
  }

  # Update progress - parsing
  if(show_progress) {
    setTxtProgressBar(pb, 60)
  }

  # Parse response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyDataFrame = TRUE, flatten = TRUE)

  # Extract metadata
  metadata <- list(
    total = data$total$value,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit
  )

  # Update progress - data processing
  if(show_progress) {
    setTxtProgressBar(pb, 80)
  }

  # Process bills data
  if (length(data$bills) > 0) {
    bills_df <- data.frame(
      billNo = data$bills[["billNo"]],
      "\u8b70\u6848\u540d\u7a31" = data$bills[["\u8b70\u6848\u540d\u7a31"]],
      "\u63d0\u6848\u55ae\u4f4d" = data$bills[["\u63d0\u6848\u55ae\u4f4d/\u63d0\u6848\u59d4\u54e1"]],
      "\u8b70\u6848\u72c0\u614b" = data$bills[["\u8b70\u6848\u72c0\u614b"]],
      "\u8b70\u6848\u985e\u5225" = data$bills[["\u8b70\u6848\u985e\u5225"]],
      "\u63d0\u6848\u4f86\u6e90" = data$bills[["\u63d0\u6848\u4f86\u6e90"]],
      meet_id = data$bills[["meet_id"]],
      "\u6703\u671f" = data$bills[["\u6703\u671f"]],
      "\u5b57\u865f" = data$bills[["\u5b57\u865f"]],
      "\u63d0\u6848\u7de8\u865f" = data$bills[["\u63d0\u6848\u7de8\u865f"]],
      "\u5c46\u671f" = data$bills[["\u5c46\u671f"]],
      mtime = data$bills[["mtime"]],
      stringsAsFactors = FALSE
    )
  } else {
    bills_df <- data.frame(
      billNo = character(),
      "\u8b70\u6848\u540d\u7a31" = character(),
      "\u63d0\u6848\u55ae\u4f4d" = character(),
      "\u8b70\u6848\u72c0\u614b" = character(),
      "\u8b70\u6848\u985e\u5225" = character(),
      "\u63d0\u6848\u4f86\u6e90" = character(),
      meet_id = character(),
      "\u6703\u671f" = integer(),
      "\u5b57\u865f" = character(),
      "\u63d0\u6848\u7de8\u865f" = character(),
      "\u5c46\u671f" = integer(),
      mtime = character(),
      stringsAsFactors = FALSE
    )
  }

  # Update progress - complete
  if(show_progress) {
    setTxtProgressBar(pb, 100)
    close(pb)

    # Print summary
    cat("\n\n")
    cat("====== Retrieved Information ======\n")
    cat("-----------------------------------\n")
    cat(sprintf("Total Cosigned Bills: %d\n", metadata$total))
    cat(sprintf("Page: %d of %d\n", metadata$current_page, metadata$total_page))
    cat(sprintf("Bills per page: %d\n", metadata$per_page))

    if(nrow(bills_df) > 0) {
      # Add bill type distribution
      bill_types <- table(bills_df[["\u8b70\u6848\u985e\u5225"]])
      cat("\nBill Type Distribution:\n")
      for(type in names(bill_types)) {
        cat(sprintf(" %s: %d\n", type, bill_types[type]))
      }

      # Add status distribution
      bill_status <- table(bills_df[["\u8b70\u6848\u72c0\u614b"]])
      cat("\nBill Status Distribution:\n")
      for(status in names(bill_status)) {
        cat(sprintf(" %s: %d\n", status, bill_status[status]))
      }
    }
    cat("===================================\n")
  }

  return(list(
    metadata = metadata,
    bills = bills_df
  ))
}
