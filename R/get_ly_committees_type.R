#' Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and Codes
#'
#' @description
#' Retrieves detailed information about Legislative Yuan committees,
#' including their jurisdictions, responsibilities and assigned codes.
#'
#' @details
#' This function fetches comprehensive committee information from the Legislative Yuan API,
#' providing committee codes, names, duties, jurisdictions and organizational structure.
#'
#' @param page integer. Page number for pagination (default: 1)
#' @param per_page integer. Number of items per page (default: 20)
#' @param type string. Committee type:
#'   - "常設委員會" (Standing Committee)
#'   - "特種委員會" (Special Committee)
#'   - "國會改革前舊委員會名稱" (Former Committee Names before Reform)
#' @param code integer. Committee code number, e.g.:
#'   - 15: Internal Administration Committee (內政委員會)
#'   - 19: Economics Committee (經濟委員會)
#'   - 20: Finance Committee (財政委員會)
#'   - 22: Education and Culture Committee (教育及文化委員會)
#'   - 23: Transportation Committee (交通委員會)
#'   - 26: Social Welfare and Environmental Hygiene Committee (社會福利及衛生環境委員會)
#'   - 35: Foreign and National Defense Committee (外交及國防委員會)
#'   - 36: Judiciary and Organic Laws and Statutes Committee (司法及法制委員會)
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \itemize{
#'   \item metadata - List of pagination info and applied filters
#'   \item committees - Data frame of committee details including code, name, duties and type
#' }
#'
#' @examples
#' # Get all standing committees
#' committees <- get_ly_committees(
#'   type = "常設委員會"
#' )
#'
#' # Get specific committee by code
#' committee <- get_ly_committees(
#'   code = 15  # Internal Administration Committee
#' )
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#'
#' @export
get_ly_committees_type <- function(
    page = 1,
    per_page = 20,
    type = NULL,          # Committee type
    code = NULL,          # Committee code
    show_progress = TRUE  # Show progress bar
) {
  # Check required packages
  if (!require("httr")) install.packages("httr")
  if (!require("jsonlite")) install.packages("jsonlite")
  if (!require("dplyr")) install.packages("dplyr")

  # Base URL
  base_url <- "https://v2.ly.govapi.tw/committees"

  # Construct query parameters
  query_params <- list(
    page = page,
    per_page = per_page,
    委員會類別 = type,
    委員會代號 = code
  )

  # Remove NULL values
  query_params <- query_params[!sapply(query_params, is.null)]

  # Show initial progress message
  if (show_progress) {
    cat("Fetching committee data...\n")
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
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)

  # Process metadata
  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  # Show processing message
  if (show_progress) {
    cat(sprintf("Found %d committees, processing...\n", length(data$committees)))
  }

  # Process committees if available
  if (length(data$committees) > 0) {
    # Convert committees to data frame
    committees_df <- do.call(rbind, lapply(data$committees, function(committee) {
      data.frame(
        代號 = committee$委員會代號,
        名稱 = committee$委員會名稱,
        職掌 = committee$委員會職掌,
        類別 = committee$`委員會類別:str`,
        stringsAsFactors = FALSE
      )
    }))
  } else {
    committees_df <- data.frame(
      代號 = integer(),
      名稱 = character(),
      職掌 = character(),
      類別 = character(),
      stringsAsFactors = FALSE
    )
  }

  # Show completion message
  if (show_progress) {
    cat(sprintf("Processing complete! %d committees processed.\n", nrow(committees_df)))
  }

  return(list(
    metadata = metadata,
    committees = committees_df
  ))
}
