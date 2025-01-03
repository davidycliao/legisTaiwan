#' Fetch Legislative Yuan Committee Meetings
#'
#' @description
#' Retrieves and processes committee meeting information from the Legislative Yuan API.
#'
#' @param committee_id integer. Required. The ID of the committee
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
#' @return A list containing metadata and meetings data frame
#'
#' @examples
#' result <- get_ly_committee_meets(committee_id = 15)
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
#' @importFrom utils txtProgressBar setTxtProgressBar
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

  # Required packages
  for (pkg in c("httr", "jsonlite", "dplyr")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg)
    }
  }

  # API request
  base_url <- sprintf("https://v2.ly.govapi.tw/committees/%d/meets", committee_id)

  query_params <- list(
    page = page,
    per_page = per_page,
    屆 = term,
    會期 = session,
    會議代碼 = meeting_code,
    會議種類 = meeting_type,
    "會議資料.出席委員" = attending_member,
    日期 = date,
    "會議資料.會議編號" = meeting_number,
    "議事網資料.關係文書.議案.議案編號" = bill_id
  )
  query_params <- query_params[!sapply(query_params, is.null)]

  if (show_progress) {
    cat(sprintf("Fetching meetings for committee ID %d...\n", committee_id))
  }

  # Make API request with error handling
  response <- tryCatch({
    httr::GET(base_url, query = query_params, httr::timeout(60))
  }, error = function(e) {
    stop(sprintf("API request failed: %s", e$message))
  })

  if (httr::status_code(response) != 200) {
    stop(sprintf("API request failed with status code: %d", httr::status_code(response)))
  }

  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)

  # Process meetings
  if (length(data$meets) > 0) {
    if (show_progress) {
      pb <- utils::txtProgressBar(min = 0, max = length(data$meets), style = 3)
    }

    # Process each meeting
    meetings_list <- lapply(seq_along(data$meets), function(i) {
      meet <- data$meets[[i]]

      if (show_progress) utils::setTxtProgressBar(pb, i)

      # Extract and process meeting participants
      legislators <- c()

      # From 發言紀錄
      if (!is.null(meet$發言紀錄)) {
        legislators <- c(legislators, unique(unlist(
          lapply(meet$發言紀錄, function(x) x$legislatorNameList)
        )))
      }

      # From 議事錄
      if (!is.null(meet$議事錄) && !is.null(meet$議事錄$出席委員)) {
        legislators <- c(legislators, meet$議事錄$出席委員)
      }

      legislators <- unique(legislators[!is.na(legislators)])
      attending_str <- if(length(legislators) > 0) paste(legislators, collapse = ", ") else NA_character_

      # Extract meeting content
      content <- NA_character_
      if (!is.null(meet$發言紀錄) && length(meet$發言紀錄) > 0 && !is.null(meet$發言紀錄[[1]]$meetingContent)) {
        content <- meet$發言紀錄[[1]]$meetingContent
      } else if (!is.null(meet$會議資料) && length(meet$會議資料) > 0 && !is.null(meet$會議資料[[1]]$會議事由)) {
        content <- meet$會議資料[[1]]$會議事由
      }

      # Create data frame row
      data.frame(
        會議名稱 = if (!is.null(meet$name)) meet$name else NA_character_,
        會議代碼 = if (!is.null(meet$會議代碼)) meet$會議代碼 else NA_character_,
        會議種類 = if (!is.null(meet$會議種類)) meet$會議種類 else NA_character_,
        屆期 = as.integer(if (!is.null(meet$屆)) meet$屆 else NA),
        會期 = as.integer(if (!is.null(meet$會期)) meet$會期 else NA),
        會次 = as.integer(if (!is.null(meet$會次)) meet$會次 else NA),
        地點 = if (!is.null(meet$會議資料) && length(meet$會議資料) > 0)
          meet$會議資料[[1]]$會議地點 else NA_character_,
        召委 = if (!is.null(meet$會議資料) && length(meet$會議資料) > 0)
          meet$會議資料[[1]]$委員會召集委員 else NA_character_,
        出席委員 = attending_str,
        會議日期 = if (length(meet$日期) > 0) paste(meet$日期, collapse = ", ") else NA_character_,
        會議內容 = content,
        stringsAsFactors = FALSE
      )
    })

    if (show_progress) {
      close(pb)
      cat("\nProcessing complete!\n")
    }

    meetings_df <- dplyr::bind_rows(meetings_list)

  } else {
    meetings_df <- data.frame(
      會議名稱 = character(),
      會議代碼 = character(),
      會議種類 = character(),
      屆期 = integer(),
      會期 = integer(),
      會次 = integer(),
      地點 = character(),
      召委 = character(),
      出席委員 = character(),
      會議日期 = character(),
      會議內容 = character(),
      stringsAsFactors = FALSE
    )
  }

  metadata <- list(
    total = data$total,
    total_page = data$total_page,
    current_page = data$page,
    per_page = data$limit,
    filters = data$filter,
    timestamp = Sys.time()
  )

  return(list(
    metadata = metadata,
    meetings = meetings_df
  ))
}
