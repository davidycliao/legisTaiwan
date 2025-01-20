#' Get Legislative Yuan IVOD Records
#'
#' @title Fetch Legislative Yuan IVOD (Video) Records 取得立法院議事轉播影片資料
#'
#' @description
#' 從立法院開放資料平台擷取議事轉播系統(IVOD)的影片紀錄資料。
#' Retrieves IVOD (Internet Video on Demand) records from the Legislative Yuan API.
#' Returns video records sorted by date in descending order.
#'
#' @param page integer. Page number for pagination (default: 1)
#' @param limit integer. Number of records per page (default: 20)
#' @param term integer. Legislative term (e.g. 9)
#' @param session_period integer. Session period
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing two components:
#' \describe{
#'   \item{metadata}{A list containing pagination and filter information:
#'     \describe{
#'       \item{total}{Total number of records found}
#'       \item{total_page}{Total number of available pages}
#'       \item{current_page}{Current page number}
#'       \item{per_page}{Number of records per page}
#'       \item{filters_used}{List of filters applied to the query}
#'     }
#'   }
#'   \item{ivods}{A data frame containing:
#'     \describe{
#'       \item{id}{IVOD record ID}
#'       \item{url}{URL to view video on IVOD website}
#'       \item{video_url}{Direct streaming URL for the video}
#'       \item{meeting_time}{Original meeting date and time}
#'       \item{meeting_name}{Name of the legislative meeting}
#'       \item{type}{Type of video record}
#'       \item{date}{Meeting date in YYYY-MM-DD format}
#'       \item{start_time}{Video start timestamp}
#'       \item{end_time}{Video end timestamp}
#'       \item{duration}{Video duration in seconds}
#'       \item{video_length}{Formatted video length (HH:MM:SS)}
#'     }
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Get videos from term 9
#' videos <- get_ly_ivod(
#'   term = 9,
#'   limit = 5
#' )
#'
#' # Get videos from specific session
#' session_videos <- get_ly_ivod(
#'   term = 9,
#'   session_period = 1,
#'   page = 1,
#'   limit = 20
#' )
#'
#' # Access the results
#' print(paste("Total videos:", videos$metadata$total))
#' print("First video details:")
#' print(videos$ivods[1, c("meeting_name", "date", "video_length")])
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#'
#' @export
#' @encoding UTF-8
get_ly_ivod <- function(
    page = 1,
    limit = 20,
    term = NULL,
    session_period = NULL,
    show_progress = TRUE
) {
  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching IVOD data...\n"))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

  # Base URL
  base_url <- "https://ly.govapi.tw/ivod"

  # Query parameters
  query_params <- list(
    page = page,
    limit = limit,
    term = term,
    sessionPeriod = session_period
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
  data <- jsonlite::fromJSON(content, simplifyDataFrame = TRUE, flatten = TRUE)

  # Extract metadata
  metadata <- list(
    total = data$total$value,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  # Update progress - data processing
  if(show_progress) {
    setTxtProgressBar(pb, 80)
  }

  # Create dataframe from the flattened data
  if (length(data$ivods) > 0) {
    ivods_df <- data.frame(
      id = data$ivods[["id"]],
      url = data$ivods[["url"]],
      video_url = data$ivods[["video_url"]],
      meeting_time = data$ivods[["會議時間"]],
      meeting_name = data$ivods[["會議名稱"]],
      type = data$ivods[["type"]],
      date = data$ivods[["date"]],
      start_time = data$ivods[["start_time"]],
      end_time = data$ivods[["end_time"]],
      duration = data$ivods[["duration"]],
      video_length = data$ivods[["影片長度"]],
      meet_id = data$ivods[["meet.id"]],
      meet_type = data$ivods[["meet.type"]],
      term = data$ivods[["meet.term"]],
      session_period = data$ivods[["meet.sessionPeriod"]],
      stringsAsFactors = FALSE
    )
  } else {
    # Empty dataframe
    ivods_df <- data.frame(
      id = character(),
      url = character(),
      video_url = character(),
      meeting_time = character(),
      meeting_name = character(),
      type = character(),
      date = character(),
      start_time = character(),
      end_time = character(),
      duration = integer(),
      video_length = character(),
      meet_id = character(),
      meet_type = character(),
      term = integer(),
      session_period = integer(),
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
    cat(sprintf("Total IVOD Records: %d\n", metadata$total))
    cat(sprintf("Page: %d of %d\n", metadata$current_page, metadata$total_page))
    cat(sprintf("Records per page: %d\n", metadata$per_page))

    if(nrow(ivods_df) > 0) {
      # Add video type distribution
      type_counts <- table(ivods_df$type)
      cat("\nVideo Type Distribution:\n")
      for(type_name in names(type_counts)) {
        if(!is.na(type_name)) {
          cat(sprintf(" %s: %d\n", type_name, type_counts[type_name]))
        }
      }

      # Add meeting type distribution
      meet_type_counts <- table(ivods_df$meet_type)
      cat("\nMeeting Type Distribution:\n")
      for(type_name in names(meet_type_counts)) {
        if(!is.na(type_name)) {
          cat(sprintf(" %s: %d\n", type_name, meet_type_counts[type_name]))
        }
      }

      # Add term distribution if available
      if(any(!is.na(ivods_df$term))) {
        term_counts <- table(ivods_df$term)
        cat("\nTerm Distribution:\n")
        for(t in sort(as.numeric(names(term_counts)))) {
          cat(sprintf(" Term %d: %d\n", t, term_counts[as.character(t)]))
        }
      }

      # Add video duration statistics
      if(any(!is.na(ivods_df$duration))) {
        cat("\nVideo Duration Statistics:\n")
        cat(sprintf(" Average: %.1f minutes\n", mean(ivods_df$duration, na.rm = TRUE) / 60))
        cat(sprintf(" Min: %.1f minutes\n", min(ivods_df$duration, na.rm = TRUE) / 60))
        cat(sprintf(" Max: %.1f minutes\n", max(ivods_df$duration, na.rm = TRUE) / 60))
      }
    }
    cat("===================================\n")
  }

  return(list(
    metadata = metadata,
    ivods = ivods_df
  ))
}
