get_ly_legislators_by_term <- function(
    term,
    page = 1,
    limit = 20,
    show_progress = TRUE
) {
  # Parameter validation
  if (missing(term)) {
    stop("term parameter is required")
  }
  if (!is.numeric(term)) {
    stop("term must be numeric")
  }

  if (!require("httr")) install.packages("httr")
  if (!require("jsonlite")) install.packages("jsonlite")
  if (!require("utils")) install.packages("utils")

  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching legislators data for term %d...\n", term))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

  # Base URL
  base_url <- sprintf("https://ly.govapi.tw/legislator/%d", term)

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

  # Process legislators data
  if (length(data$legislators) > 0) {
    legislators_df <- data.frame(
      data$legislators,
      stringsAsFactors = FALSE
    )
  } else {
    legislators_df <- data.frame(
      term = integer(),
      name = character(),
      party = character(),
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
    cat(sprintf("Total Legislators: %d\n", metadata$total))
    cat(sprintf("Page: %d of %d\n", metadata$current_page, metadata$total_page))
    cat(sprintf("Records per page: %d\n", metadata$per_page))

    if(nrow(legislators_df) > 0) {
      # Add party distribution
      party_counts <- table(legislators_df$party)
      cat("\nParty Distribution:\n")
      for(party in names(party_counts)) {
        cat(sprintf(" %s: %d\n", party, party_counts[party]))
      }

      # Add area distribution if available
      if("areaName" %in% names(legislators_df)) {
        area_counts <- table(legislators_df$areaName)
        cat("\nArea Distribution:\n")
        for(area in names(area_counts)) {
          cat(sprintf(" %s: %d\n", area, area_counts[area]))
        }
      }
    }
    cat("===================================\n")
  }

  return(list(
    metadata = metadata,
    legislators = legislators_df
  ))
}
