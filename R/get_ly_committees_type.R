#' @title Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and Codes 取得立法院委員會類別及職權範圍代碼
#'
#' @description
#' Retrieves detailed information about Legislative Yuan committees,
#' including their jurisdictions, responsibilities and assigned codes.
#' This function provides comprehensive access to committee structural data
#' and organizational details of Taiwan's Legislative Yuan.
#'
#' @details
#' This function fetches comprehensive committee information from the Legislative Yuan API,
#' providing committee codes, names, duties, jurisdictions and organizational structure.
#' The committees are categorized into three main types:
#' \itemize{
#'   \item Standing Committees (常設委員會): Permanent committees handling specific policy areas
#'   \item Special Committees (特種委員會): Committees formed for specific purposes or tasks
#'   \item Former Committee Names (國會改革前舊委員會名稱): Historical committee designations
#' }
#'
#' Committee codes and their corresponding names:
#' \itemize{
#'   \item 15: 內政委員會 (Interior Affairs Committee)
#'   \item 16: 外交及僑務委員會 (Foreign and Overseas Chinese Affairs Committee)
#'   \item 17: 科技及資訊委員會 (Science and Technology Committee)
#'   \item 18: 國防委員會 (National Defense Committee)
#'   \item 19: 經濟委員會 (Economic Affairs Committee)
#'   \item 20: 財政委員會 (Finance Committee)
#'   \item 21: 預算及決算委員會 (Budget and Final Accounts Committee)
#'   \item 22: 教育及文化委員會 (Education and Culture Committee)
#'   \item 23: 交通委員會 (Transportation Committee)
#'   \item 24: 司法委員會 (Judiciary Committee)
#'   \item 25: 法制委員會 (Legal Affairs Committee)
#'   \item 26: 社會福利及衛生環境委員會 (Social Welfare and Environmental Hygiene Committee)
#'   \item 27: 程序委員會 (Procedure Committee)
#'   \item 28: 紀律委員會 (Discipline Committee)
#'   \item 29: 修憲委員會 (Constitutional Amendment Committee)
#'   \item 30: 經費稽核委員會 (Expenditure Review Committee)
#'   \item 35: 外交及國防委員會 (Foreign Affairs and National Defense Committee)
#'   \item 36: 司法及法制委員會 (Judiciary and Legal Affairs Committee)
#' }
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
#'   \item metadata - List of pagination info and applied filters, including:
#'     \itemize{
#'       \item total_records: Total number of committee records
#'       \item current_page: Current page number
#'       \item total_pages: Total number of pages
#'       \item per_page: Number of records per page
#'     }
#'   \item committees - Data frame of committee details including:
#'     \itemize{
#'       \item code: Committee identification number
#'       \item name: Committee name in Chinese
#'       \item type: Category of committee
#'       \item duties: Committee responsibilities and jurisdiction
#'       \item term_start: Starting legislative term of the committee
#'       \item term_end: Ending legislative term of the committee (if applicable)
#'     }
#' }
#'
#' @examples
#' \dontrun{
#' # Fetch all standing committees
#' committees <- fetch_ly_committees(type = "常設委員會")
#'
#' # Get details for a specific committee by code
#' interior_committee <- fetch_ly_committees(code = 15)
#'
#' # Fetch multiple pages of committee data
#' all_committees <- fetch_ly_committees(page = 1, per_page = 50)
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
