#' Get Legislator's Cosigned Bills 取得立法委員連署法案
#'
#' @title Fetch Bills Cosigned by a Legislator 取得立法委員連署法案
#'
#' @description
#' Retrieves bills that were cosigned by a specific legislator by term and name from the Legislative Yuan API.
#'
#' @param term required integer. Legislative term number (e.g. 9)
#' @param name required string. Legislator name (e.g. "王金平")
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
#'       \item{議案名稱}{Bill name}
#'       \item{提案單位}{Proposing unit/legislator}
#'       \item{議案狀態}{Bill status}
#'       \item{議案類別}{Bill type}
#'       \item{提案來源}{Source}
#'       \item{meet_id}{Meeting ID}
#'       \item{會期}{Session period}
#'       \item{字號}{Case number}
#'       \item{提案編號}{Proposal number}
#'       \item{屆期}{Term}
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
#'   name = "王金平",
#'   limit = 5
#' )
#'
#' # Print results
#' print(paste("Total cosigned bills:", bills$metadata$total))
#' print("Latest cosigned bill:")
#' print(bills$bills[1, c("議案名稱", "議案狀態")])
#'
#' # Get second page of results
#' bills_page2 <- get_ly_legislator_cosign_bills(
#'   term = 9,
#'   name = "王金平",
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
      議案名稱 = data$bills[["議案名稱"]],
      提案單位 = data$bills[["提案單位/提案委員"]],
      議案狀態 = data$bills[["議案狀態"]],
      議案類別 = data$bills[["議案類別"]],
      提案來源 = data$bills[["提案來源"]],
      meet_id = data$bills[["meet_id"]],
      會期 = data$bills[["會期"]],
      字號 = data$bills[["字號"]],
      提案編號 = data$bills[["提案編號"]],
      屆期 = data$bills[["屆期"]],
      mtime = data$bills[["mtime"]],
      stringsAsFactors = FALSE
    )
  } else {
    bills_df <- data.frame(
      billNo = character(),
      議案名稱 = character(),
      提案單位 = character(),
      議案狀態 = character(),
      議案類別 = character(),
      提案來源 = character(),
      meet_id = character(),
      會期 = integer(),
      字號 = character(),
      提案編號 = character(),
      屆期 = integer(),
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
      bill_types <- table(bills_df$議案類別)
      cat("\nBill Type Distribution:\n")
      for(type in names(bill_types)) {
        cat(sprintf(" %s: %d\n", type, bill_types[type]))
      }

      # Add status distribution
      bill_status <- table(bills_df$議案狀態)
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
