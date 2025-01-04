#' Get Legislative Yuan IVOD Records
#'
#' @title Fetch Legislative Yuan IVOD (Video) Records
#'
#' @description
#' Retrieves IVOD (Internet Video on Demand) records from the Legislative Yuan API.
#' Returns video records sorted by date in descending order.
#'
#' @param page integer. Page number for pagination (default: 1)
#' @param limit integer. Number of records per page (default: 20)
#' @param term integer. Legislative term (e.g. 9)
#' @param session_period integer. Session period
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing:
#' \describe{
#'   \item{metadata}{A list containing:
#'     \itemize{
#'       \item{total}{Total number of records found}
#'       \item{total_page}{Total number of available pages}
#'       \item{current_page}{Current page number}
#'       \item{per_page}{Number of records per page}
#'       \item{filters_used}{List of filters applied to the query}
#'     }
#'   }
#'   \item{ivods}{A data frame containing:
#'     \itemize{
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
#'       \item{meet_id}{Meeting reference ID}
#'       \item{meet_type}{Type of legislative meeting}
#'       \item{term}{Legislative term number}
#'       \item{session_period}{Session period number}
#'     }
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Get videos from term 9, session 1
#' videos <- get_ly_ivod(
#'   term = 9,
#'   session_period = 1,
#'   limit = 5
#' )
#'
#' # Get videos with pagination
#' page2_videos <- get_ly_ivod(
#'   term = 9,
#'   session_period = 1,
#'   page = 2,
#'   limit = 20
#' )
#'
#' # View results
#' print(paste("Total videos available:", videos$metadata$total))
#' print(paste("Videos per page:", videos$metadata$per_page))
#' print("Sample video details:")
#' print(videos$ivods[1, c("meeting_name", "date", "video_length")])
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom utils txtProgressBar setTxtProgressBar
#'
#' @seealso
#' \url{https://ly.govapi.tw/} for API documentation
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
  if (!require("httr")) install.packages("httr")
  if (!require("jsonlite")) install.packages("jsonlite")

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

  if (show_progress) {
    cat("Fetching IVOD data...\n")
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
  data <- jsonlite::fromJSON(content, simplifyDataFrame = TRUE, flatten = TRUE)

  # Extract metadata
  metadata <- list(
    total = data$total$value,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters_used = query_params
  )

  if (show_progress) {
    cat(sprintf("Found %d records\n", length(data$ivods)))
  }

  # Create dataframe from the flattened data directly
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

    if (show_progress) {
      cat("Data processing complete!\n")
    }
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

  return(list(
    metadata = metadata,
    ivods = ivods_df
  ))
}
