#' Get Legislative Yuan Legislator Detail
#'
#' @title Fetch Legislator Detail Information
#'
#' @description
#' Retrieves detailed information for a specific legislator by term and name from the Legislative Yuan API.
#'
#' @param term required integer. Legislative term number (e.g. 9)
#' @param name required string. Legislator name (e.g. "王金平")
#' @param show_progress logical. Whether to display progress info (default: TRUE)
#'
#' @return A list containing legislator details:
#' \describe{
#'   \item{term}{Legislative term number}
#'   \item{name}{Legislator's name in Chinese}
#'   \item{ename}{Legislator's name in English}
#'   \item{sex}{Gender}
#'   \item{party}{Political party affiliation}
#'   \item{partyGroup}{Legislative party group}
#'   \item{areaName}{Represented area}
#'   \item{committee}{Committee assignments by session}
#'   \item{onboardDate}{Date took office}
#'   \item{degree}{Education background}
#'   \item{experience}{Work experience}
#'   \item{picUrl}{URL of legislator's photo}
#'   \item{leaveFlag}{Whether has left office}
#'   \item{leaveDate}{Date left office if applicable}
#'   \item{leaveReason}{Reason for leaving if applicable}
#'   \item{bioId}{Biography ID}
#' }
#'
#' @examples
#' \dontrun{
#' # Get legislator detail
#' detail <- get_ly_legislator_detail(
#'   term = 9,
#'   name = "王金平"
#' )
#'
#' # Print basic info
#' cat(sprintf(
#'   "Name: %s (%s)\nParty: %s\nArea: %s\n",
#'   detail$name,
#'   detail$ename,
#'   detail$party,
#'   detail$areaName
#' ))
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#'
#' @export
get_ly_legislator_detail <- function(
    term,
    name,
    show_progress = TRUE
) {
  # Parameter validation
  if (missing(term)) stop("term parameter is required")
  if (missing(name)) stop("name parameter is required")
  if (!is.numeric(term)) stop("term must be numeric")
  if (!is.character(name)) stop("name must be character")

  # Base URL with path parameters
  base_url <- sprintf("https://ly.govapi.tw/legislator/%d/%s", term, name)

  if (show_progress) {
    cat(sprintf("Fetching details for legislator %s (term %d)...\n", name, term))
  }

  # Send GET request
  response <- httr::GET(base_url)

  # Check response status
  if (httr::status_code(response) != 200) {
    stop("API request failed with status code: ", httr::status_code(response))
  }

  # Parse response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)

  if (show_progress) {
    cat("Data retrieved successfully!\n")
  }

  return(data)
}
