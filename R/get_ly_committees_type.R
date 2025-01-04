#' @title Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and Codes
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
#' @param code integer. Committee code number
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \itemize{
#'   \item metadata - List of pagination info and applied filters
#'   \item committees - Data frame of committee details including code, name, duties and type
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @encoding UTF-8
#' @export
get_ly_committees_type <- function(
    page = 1,
    per_page = 20,
    type = NULL,          # Committee type
    code = NULL,          # Committee code
    show_progress = TRUE  # Show progress bar
) {

  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching committee data...\n"))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

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
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)

  # Process metadata
  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  # Update progress - data processing
  if(show_progress) {
    setTxtProgressBar(pb, 80)
  }

  # Process committees if available
  if (length(data$committees) > 0) {
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

  # Update progress - complete
  if(show_progress) {
    setTxtProgressBar(pb, 100)
    close(pb)

    # Print summary
    cat("\n\n")
    cat("====== Retrieved Information ======\n")
    cat("-----------------------------------\n")
    cat(sprintf("Total Committees: %d\n", metadata$total))
    cat(sprintf("Page: %d of %d\n", metadata$current_page, metadata$total_page))
    cat(sprintf("Records per page: %d\n", metadata$per_page))

    if(nrow(committees_df) > 0) {
      # Add type distribution
      type_counts <- table(committees_df$類別)
      cat("\nCommittee Type Distribution:\n")
      for(type_name in names(type_counts)) {
        cat(sprintf(" %s: %d\n", type_name, type_counts[type_name]))
      }

      # Add code distribution
      if(nrow(committees_df) > 0) {
        code_counts <- table(committees_df$代號)
        cat("\nCommittee Code Distribution:\n")
        for(code in sort(as.numeric(names(code_counts)))) {
          committee_name <- committees_df$名稱[committees_df$代號 == code][1]
          cat(sprintf(" %d (%s): %d\n", code, committee_name, code_counts[as.character(code)]))
        }
      }
    }
    cat("===================================\n")
  }

  return(list(
    metadata = metadata,
    committees = committees_df
  ))
}
