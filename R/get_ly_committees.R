#' @encoding UTF-8
#' @title Fetch Legislative Yuan Committee Meetings
#'
#' @description
#' Retrieves and processes committee meeting information from the Legislative Yuan API.
#' This function allows you to fetch detailed information about committee meetings
#' including attendance, bills discussed, and meeting details.
#'
#' @param committee_id integer. Required. The ID of the committee. Available values:
#'   \itemize{
#'     \item 15: Interior Committee
#'     \item 16: Foreign and Overseas Chinese Affairs Committee
#'     \item 17: Science and Technology Committee
#'     \item 18: Defense Committee
#'     \item 19: Economics Committee
#'     \item 20: Finance Committee
#'     \item 21: Budget Committee
#'     \item 22: Education and Culture Committee
#'     \item 23: Transportation Committee
#'     \item 24: Judiciary Committee
#'     \item 25: Legal Affairs Committee
#'     \item 26: Social Welfare and Environmental Hygiene Committee
#'     \item 27: Procedure Committee
#'     \item 28: Discipline Committee
#'     \item 29: Constitutional Amendment Committee
#'     \item 30: Expenditure Review Committee
#'     \item 35: Foreign Affairs and Defense Committee
#'     \item 36: Judiciary and Legal Affairs Committee
#'   }
#' @param page integer. Page number for pagination (default: 1)
#' @param per_page integer. Number of items per page (default: 20)
#' @param term integer. Legislative term number
#' @param session integer. Session number
#' @param meeting_code string. Meeting code
#' @param meeting_type string. Type of meeting
#' @param attending_member string. Name of attending member
#' @param date string. Meeting date in YYYY-MM-DD format
#' @param meeting_number string. Meeting number
#' @param bill_id string. Bill ID
#' @param show_progress logical. Whether to display progress bar (default: TRUE)
#'
#' @return A list containing two elements:
#'   \itemize{
#'     \item metadata: List containing pagination information and request status
#'     \item data: Data frame containing meeting information with columns including
#'           meeting date, type, attending members, and discussed bills
#'   }
#'
#' @examples
#' \dontrun{
#' # Fetch meetings from the Interior Committee
#' meetings <- get_ly_committee_meets(committee_id = 15)
#'
#' # Fetch meetings with specific filters
#' meetings <- get_ly_committee_meets(
#'   committee_id = 16,
#'   term = 10,
#'   session = 1,
#'   date = "2024-01-01"
#' )
#' }
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @encoding UTF-8
#' @export
get_ly_committee_meets <- function(
    committee_id,
    page = 1,
    per_page = 20,
    term = NULL,
    session = NULL,
    meeting_code = NULL,
    meeting_type = NULL,
    attending_member = NULL,
    date = NULL,
    meeting_number = NULL,
    bill_id = NULL,
    show_progress = TRUE
) {
  # Input validation
  if (missing(committee_id)) stop("committee_id is required")
  if (!is.numeric(committee_id)) stop("committee_id must be numeric")

  # Initialize progress
  if(show_progress) {
    cat(sprintf("\nFetching meetings data for committee ID %d...\n", committee_id))
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    setTxtProgressBar(pb, 20)
  }

  # API request
  base_url <- sprintf("https://v2.ly.govapi.tw/committees/%d/meets", committee_id)

  query_params <- list(
    page = page,
    per_page = per_page,
    "\u5c46" = term,
    "\u6703\u671f" = session,
    "\u6703\u8b70\u4ee3\u78bc" = meeting_code,
    "\u6703\u8b70\u7a2e\u985e" = meeting_type,
    "\u6703\u8b70\u8cc7\u6599.\u51fa\u5e2d\u59d4\u54e1" = attending_member,
    "\u65e5\u671f" = date,
    "\u6703\u8b70\u8cc7\u6599.\u6703\u8b70\u7de8\u865f" = meeting_number,
    "\u8b70\u4e8b\u7db2\u8cc7\u6599.\u95dc\u4fc2\u6587\u66f8.\u8b70\u6848.\u8b70\u6848\u7de8\u865f" = bill_id
  )
  query_params <- query_params[!sapply(query_params, is.null)]

  # Update progress - API call
  if(show_progress) {
    setTxtProgressBar(pb, 40)
  }

  # Make API request with error handling
  response <- tryCatch({
    httr::GET(base_url, query = query_params, httr::timeout(60))
  }, error = function(e) {
    if(show_progress) close(pb)
    stop(sprintf("API request failed: %s", e$message))
  })

  if (httr::status_code(response) != 200) {
    if(show_progress) close(pb)
    stop(sprintf("API request failed with status code: %d", httr::status_code(response)))
  }

  # Update progress - parsing
  if(show_progress) {
    setTxtProgressBar(pb, 60)
  }

  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)

  # Process meetings
  if (length(data$meets) > 0) {
    # Update progress - data processing
    if(show_progress) {
      setTxtProgressBar(pb, 80)
    }

    meetings_list <- lapply(data$meets, function(meet) {
      # Extract and process meeting participants
      legislators <- character(0)


      # From speech records
      if (!is.null(meet[["\u767c\u8a00\u7d00\u9304"]])) {
        legislators <- c(legislators, unique(unlist(
          lapply(meet[["\u767c\u8a00\u7d00\u9304"]], function(x) x$legislatorNameList)
        )))
      }

      # From meeting minutes
      if (!is.null(meet[["\u8b70\u4e8b\u9304"]]) && !is.null(meet[["\u8b70\u4e8b\u9304"]][["\u51fa\u5e2d\u59d4\u54e1"]])) {
        legislators <- c(legislators, meet[["\u8b70\u4e8b\u9304"]][["\u51fa\u5e2d\u59d4\u54e1"]])
      }

      legislators <- unique(legislators[!is.na(legislators)])
      attending_str <- if(length(legislators) > 0) paste(legislators, collapse = ", ") else NA_character_

      # Extract meeting content
      content <- NA_character_
      if (!is.null(meet[["\u767c\u8a00\u7d00\u9304"]]) && length(meet[["\u767c\u8a00\u7d00\u9304"]]) > 0 && !is.null(meet[["\u767c\u8a00\u7d00\u9304"]][[1]]$meetingContent)) {
        content <- meet[["\u767c\u8a00\u7d00\u9304"]][[1]]$meetingContent
      } else if (!is.null(meet[["\u6703\u8b70\u8cc7\u6599"]]) && length(meet[["\u6703\u8b70\u8cc7\u6599"]]) > 0 && !is.null(meet[["\u6703\u8b70\u8cc7\u6599"]][[1]][["\u6703\u8b70\u4e8b\u7531"]])) {
        content <- meet[["\u6703\u8b70\u8cc7\u6599"]][[1]][["\u6703\u8b70\u4e8b\u7531"]]
      }

      # Create data frame row
      data.frame(
        "\u6703\u8b70\u540d\u7a31" = if (!is.null(meet$name)) meet$name else NA_character_,
        "\u6703\u8b70\u4ee3\u78bc" = if (!is.null(meet[["\u6703\u8b70\u4ee3\u78bc"]])) meet[["\u6703\u8b70\u4ee3\u78bc"]] else NA_character_,
        "\u6703\u8b70\u7a2e\u985e" = if (!is.null(meet[["\u6703\u8b70\u7a2e\u985e"]])) meet[["\u6703\u8b70\u7a2e\u985e"]] else NA_character_,
        "\u5c46\u671f" = as.integer(if (!is.null(meet[["\u5c46"]])) meet[["\u5c46"]] else NA),
        "\u6703\u671f" = as.integer(if (!is.null(meet[["\u6703\u671f"]])) meet[["\u6703\u671f"]] else NA),
        "\u6703\u6b21" = as.integer(if (!is.null(meet[["\u6703\u6b21"]])) meet[["\u6703\u6b21"]] else NA),
        "\u5730\u9ede" = if (!is.null(meet[["\u6703\u8b70\u8cc7\u6599"]]) && length(meet[["\u6703\u8b70\u8cc7\u6599"]]) > 0)
          meet[["\u6703\u8b70\u8cc7\u6599"]][[1]][["\u6703\u8b70\u5730\u9ede"]] else NA_character_,
        "\u53ec\u59d4" = if (!is.null(meet[["\u6703\u8b70\u8cc7\u6599"]]) && length(meet[["\u6703\u8b70\u8cc7\u6599"]]) > 0)
          meet[["\u6703\u8b70\u8cc7\u6599"]][[1]][["\u59d4\u54e1\u6703\u53ec\u96c6\u59d4\u54e1"]] else NA_character_,
        "\u51fa\u5e2d\u59d4\u54e1" = attending_str,
        "\u6703\u8b70\u65e5\u671f" = if (length(meet[["\u65e5\u671f"]]) > 0) paste(meet[["\u65e5\u671f"]], collapse = ", ") else NA_character_,
        "\u6703\u8b70\u5167\u5bb9" = content,
        stringsAsFactors = FALSE
      )
    })

    meetings_df <- dplyr::bind_rows(meetings_list)

  } else {
    meetings_df <- data.frame(
      "\u6703\u8b70\u540d\u7a31" = character(),
      "\u6703\u8b70\u4ee3\u78bc" = character(),
      "\u6703\u8b70\u7a2e\u985e" = character(),
      "\u5c46\u671f" = integer(),
      "\u6703\u671f" = integer(),
      "\u6703\u6b21" = integer(),
      "\u5730\u9ede" = character(),
      "\u53ec\u59d4" = character(),
      "\u51fa\u5e2d\u59d4\u54e1" = character(),
      "\u6703\u8b70\u65e5\u671f" = character(),
      "\u6703\u8b70\u5167\u5bb9" = character(),
      stringsAsFactors = FALSE
    )
  }

  # Process metadata
  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters = data$filter,
    timestamp = Sys.time()
  )

  # Update progress - complete
  if(show_progress) {
    setTxtProgressBar(pb, 100)
    close(pb)

    # Print summary
    cat("\n\n")
    cat("====== Retrieved Information ======\n")
    cat("-----------------------------------\n")
    cat(sprintf("Total Meetings: %d\n", metadata$total))
    cat(sprintf("Page: %d of %d\n", metadata$current_page, metadata$total_page))
    cat(sprintf("Records per page: %d\n", metadata$per_page))

    if(nrow(meetings_df) > 0) {
      # Add meeting type distribution
      type_counts <- table(meetings_df[["\u6703\u8b70\u7a2e\u985e"]])
      cat("\nMeeting Type Distribution:\n")
      for(type_name in names(type_counts)) {
        if(!is.na(type_name)) {
          cat(sprintf(" %s: %d\n", type_name, type_counts[type_name]))
        }
      }

      # Add session distribution
      if(any(!is.na(meetings_df[["\u6703\u671f"]]))) {
        session_counts <- table(meetings_df[["\u6703\u671f"]])
        cat("\nSession Distribution:\n")
        for(session in sort(as.numeric(names(session_counts)))) {
          cat(sprintf(" Session %d: %d\n", session, session_counts[as.character(session)]))
        }
      }

      # Add location distribution if available
      if(any(!is.na(meetings_df[["\u5730\u9ede"]]))) {
        location_counts <- table(meetings_df[["\u5730\u9ede"]])
        cat("\nLocation Distribution:\n")
        for(location in names(location_counts)) {
          if(!is.na(location)) {
            cat(sprintf(" %s: %d\n", location, location_counts[location]))
          }
        }
      }
    }
    cat("===================================\n")
  }

  return(list(
    metadata = metadata,
    meetings = meetings_df
  ))
}
