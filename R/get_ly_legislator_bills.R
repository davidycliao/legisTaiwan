#' Get Legislator Information by Term and Name
#'
#' @title Fetch Detailed Legislator Information
#'
#' @description
#' Retrieves comprehensive information for a specific legislator from the Legislative Yuan API.
#' This includes personal details, committee assignments, educational background, and work experience.
#'
#' @param term integer. Required. The legislative term number (e.g., 9)
#' @param name string. Required. The legislator's name in Chinese (e.g., "王金平")
#' @param show_progress logical. Whether to display progress information (default: TRUE)
#'
#' @return A list containing legislator's detailed information:
#' \describe{
#'   \item{term}{Legislative term number}
#'   \item{name}{Legislator's name in Chinese}
#'   \item{ename}{Legislator's name in English romanization}
#'   \item{sex}{Gender}
#'   \item{party}{Political party affiliation}
#'   \item{partyGroup}{Legislative caucus/party group}
#'   \item{areaName}{Electoral district or constituency}
#'   \item{committee}{List of committee assignments by legislative session}
#'   \item{onboardDate}{Date when took office}
#'   \item{degree}{List of educational qualifications}
#'   \item{experience}{List of relevant work experience}
#'   \item{picUrl}{URL to legislator's official photo}
#'   \item{leaveFlag}{Indicates if legislator has left office ("是"/"否")}
#'   \item{leaveDate}{Date of leaving office (if applicable)}
#'   \item{leaveReason}{Reason for leaving office (if applicable)}
#'   \item{bioId}{Unique biography identifier}
#' }
#'
#' @section API Details:
#' The function accesses the Legislative Yuan's open data API. The API endpoint
#' format is: \code{https://ly.govapi.tw/legislator/{term}/{name}}
#'
#' @section Data Usage:
#' The returned data can be used for:
#' \itemize{
#'   \item Legislative research and analysis
#'   \item Tracking committee assignments
#'   \item Analyzing political party affiliations
#'   \item Monitoring legislative turnover
#' }
#'
#' @examples
#' \dontrun{
#' # Get details for a specific legislator
#' legislator <- get_ly_legislator_bills(
#'   term = 9,
#'   name = "王金平"
#' )
#'
#' # Display basic information
#' cat(sprintf(
#'   "Legislator: %s (%s)\nParty: %s\nDistrict: %s\nCommittees: %s\n",
#'   legislator$name,
#'   legislator$ename,
#'   legislator$party,
#'   legislator$areaName,
#'   paste(legislator$committee[1:2], collapse = "\n")
#' ))
#'
#' # Check committee assignments
#' print(legislator$committee)
#'
#' # Display educational background
#' print(legislator$degree)
#' }
#'
#' @seealso
#' \itemize{
#'   \item \url{https://ly.govapi.tw/} for API documentation
#'   \item \code{\link{get_ly_legislators_by_term}} for listing all legislators in a term
#'   \item \code{\link{get_ly_legislator_bills}} for legislator's proposed bills
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#'
#' @export
#'
#' @encoding UTF-8
get_ly_legislator_bills <- function(
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

  if (!require("httr")) install.packages("httr")
  if (!require("jsonlite")) install.packages("jsonlite")
  if (!require("utils")) install.packages("utils")

  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching bills proposed by %s (term %d)...\n", name, term))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

  # Base URL
  base_url <- sprintf("https://ly.govapi.tw/legislator/%d/%s/propose_bill", term, name)

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
    cat(sprintf("Total Bills: %d\n", metadata$total))
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
