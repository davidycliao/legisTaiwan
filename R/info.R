#' Check Each Function's Manual 檢查各函式說明文件
#'
#'@author Yen-Chieh Liao (davidycliao@@gmail.com)
#'
#'@description `get_variable_info` generate each API's endpoint manual returned
#'from the website of Taiwan Legislative Yuan. The avalaible options is: `get_bills`,
#'`get_bills_2`, `get_meetings`, `get_caucus_meetings`, `get_speech_video` ,
#'`get_public_debates`, `get_parlquestions`, `get_executive_response` and
#'`get_committee_record`. 僅使用舊版 API 參數。
#'
#'@param param_ characters. Must be one of options below: \describe{
#'      \item{get_bills}{get_bills: the records of the bills, see \url{https://data.ly.gov.tw/getds.action?id=6}}
#'      \item{get_bills_2}{the records of legislators and the government proposals, see \url{https://data.ly.gov.tw/getds.action?id=6}}
#'      \item{get_meetings}{the spoken meeting records, see \url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}}
#'      \item{get_caucus_meetings}{the meeting records of cross-caucus session, see \url{https://data.ly.gov.tw/getds.action?id=8}}
#'      \item{get_speech_video}{the full video information of meetings and committees, see \url{https://data.ly.gov.tw/getds.action?id=148}}
#'      \item{get_public_debates}{the records of national public debates, see \url{https://data.ly.gov.tw/getds.action?id=7}}
#'      \item{get_parlquestions}{the records of parliamentary questions, see \url{https://data.ly.gov.tw/getds.action?id=6}}
#'      \item{get_executive_response}{the records of the questions answered by the executives, see \url{https://data.ly.gov.tw/getds.action?id=2}}
#'}
#'
#'@return list \describe{
#'      \item{`page_info`}{information of the end point}
#'      \item{`reference_url`}{the url of the page}}
#'
#'@details `get_variable_info` produces a list, which contains `page_info` and `reference_url`.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom rvest html_text2 read_html
#'@importFrom tibble as_tibble
#'
#'
#' @seealso `review_session_info()`.
#'
#' @examples
#' \dontrun{
#'   # This example requires internet connection and is not run during package checks
#'   check_caucus <- get_variable_info("get_caucus_meetings")
#' }
#' @export
get_variable_info <- function(param_) {
  # Ensure internet and website availability
  check_internet()
  attempt::stop_if_not(website_availability(), msg = "the error from the API.")

  # Parameter checks
  attempt::stop_if(param_, is.numeric, msg = "use string format only.")
  attempt::stop_if(param_, is.null, msg = "use correct function names.")
  attempt::stop_if(param_, ~ length(.x) > 1, msg = "only allowed to query one function.")

  # Dictionary for URL mapping
  url_mapping <- list(
    get_parlquestions = "https://data.ly.gov.tw/getds.action?id=6",
    get_legislators = "https://data.ly.gov.tw/getds.action?id=16",
    get_committee_record = "https://data.ly.gov.tw/getds.action?id=46",
    get_executive_response = "https://data.ly.gov.tw/getds.action?id=2",
    get_caucus_meetings = "https://data.ly.gov.tw/getds.action?id=8",
    get_speech_video = "https://data.ly.gov.tw/getds.action?id=148",
    get_bills_2 = "https://data.ly.gov.tw/getds.action?id=20",
    get_public_debates = "https://data.ly.gov.tw/getds.action?id=7"
  )
  if (!(param_ %in% names(url_mapping) || param_ %in% c("get_bills", "get_meetings"))) {
    stop("Use correct function names below in character format:
          get_bills: the records of the bills
          get_bills_2: the records of legislators and the government proposals
          get_meetings: the spoken meeting records
          get_caucus_meetings: the meeting records of cross-caucus session
          get_speech_video: the full video information of meetings and committees
          get_public_debates: the records of national public debates
          get_parlquestions: the records of parliamentary questions
          get_executive_response: the records of the questions answered by the executives")
  }


  # Fetch URL from dictionary or process special cases
  if (param_ %in% names(url_mapping)) {
    url <- url_mapping[[param_]]
  } else if (param_ == "get_meetings") {
    url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
  } else if (param_ == "get_bills") {
    url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153"
  } else {
    stop("Use correct function names below in character format.")
  }

  if (param_ %in% c("get_bills", "get_meetings")) {
    html_info <- rvest::html_text2(rvest::html_nodes(rvest::html_nodes(rvest::read_html(url), "*[id='form_Query']"), "div"))
    page_info <- list(page_info = strsplit(html_info[14], split = "\n")[[1]], reference_url = url)
    return(page_info)
  }

  html <- rvest::html_nodes(rvest::read_html(url), "*[id='content']")
  title <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "h2")))

  content <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "span")))
  df <- data.frame(content[seq(1, length(content), 2)],
                   content[seq(1, length(content) + 1, 2) - 1])
  colnames(df) <- c(title[2], title[1])
  df <- tibble::as_tibble(df)
  page_info <- list(page_info = df, reference_url = url)

  return(page_info)
}


#' Check Session Periods in Each Year (Minguo Calendar) 檢查每年會期 (民國曆)
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@details `review_session_info` produces a dataframe, displaying each session
#'period in year formatted in Minguo (Taiwan) calendar.
#'
#'@param term numeric
#'
#'@return dataframe
#'
#'@importFrom attempt stop_if_all
#'@importFrom rvest html_text2 read_html
#'@importFrom tibble as_tibble
#'
#' @seealso
#' Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.
#'
#' @examples
#' # Show the session information for the 7th Legislative Yuan term periods in ROC calendar year
#' review_session_info(7)
#' @export
review_session_info <- function(term) {
  # Input validation
  if(missing(term)) {
    stop("Term parameter is required")
  }

  attempt::stop_if_not(website_availability2(),
                       msg = "API connection error. Please check your internet connection.")

  attempt::stop_if(term, is.null,
                   msg = "Term cannot be NULL. Please provide a valid term number (1-11).")

  attempt::stop_if_not(term %in% 1:11,
                       msg = paste("Invalid term:", term,
                                   "\nPlease provide a term number between 1 and 11."))

  # Construct URL
  url <- sprintf("https://npl.ly.gov.tw/do/www/appDate?status=0&expire=%02d&startYear=0",
                 as.numeric(term))
  tryCatch({
    # Parse HTML
    html_ <- rvest::html_nodes(rvest::read_html(url),
                               "*[class='section_wrapper']")

    # Extract titles
    title <- stringr::str_split_1(
      rvest::html_text2(
        rvest::html_nodes(html_, "[class='tt_titlebar2']")
      ),
      "\t\r"
    )[1:2]

    # Extract rows
    odd_rows <- rvest::html_text2(
      rvest::html_nodes(html_, "[class='tt_listrow_odd']")
    )
    even_rows <- rvest::html_text2(
      rvest::html_nodes(html_, "[class='tt_listrow_even']")
    )

    # Process data
    data <- lapply(
      lapply(c(odd_rows, even_rows),
             function(x) stringr::str_split_1(x, "\r\r")),
      function(x) gsub("[[:space:]]", "", x)
    )

    # Create dataframe
    df <- do.call(rbind, data)
    colnames(df) <- title

    return(tibble::as_tibble(df))
  },
  error = function(e) {
    stop(paste("Error retrieving session information:", e$message))
  })
}


#' Check Session Periods in Each Year (Minguo Calendar)
#'
#' @title Check Session Periods in Each Year
#' @description Examines session periods in Taiwan Minguo calendar (檢查每年會期民國曆)
#'
#' @author David Liao (davidycliao@@gmail.com)
#'
#' @details
#' The review_session_info function produces a dataframe, displaying each session
#' period in year formatted in Minguo calendar. This implementation uses
#' system curl command with --insecure option to bypass SSL/TLS issues.
#'
#' @param term numeric The term number (1-11) of Legislative Yuan
#'
#' @return A dataframe containing session information
#'
#' @importFrom attempt stop_if
#' @importFrom stringr str_split_1
#' @importFrom tibble as_tibble
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text2
#'
#' @seealso
#' Regarding Minguo calendar, please see \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}.
#'
#' @examples
#' \dontrun{
#' # Show the session information for the 7th Legislative Yuan term periods in ROC calendar year
#' review_session_info(7)
#' }
#' @export
review_session_info <- function(term) {
  # Input validation
  if(missing(term)) {
    stop("Term parameter is required")
  }
  attempt::stop_if(term, is.null,
                   msg = "Term cannot be NULL. Please provide a valid term number (1-11).")
  attempt::stop_if_not(term %in% 1:11,
                       msg = paste("Invalid term:", term,
                                   "\nPlease provide a term number between 1 and 11."))

  # Check if curl is available on the system
  curl_available <- system("which curl", intern = TRUE, ignore.stderr = TRUE)
  if (length(curl_available) == 0) {
    stop("The 'curl' command is not available on your system. Please install curl or use the RSelenium method.")
  }

  # Construct URL for the specific term
  url <- sprintf("https://npl.ly.gov.tw/do/www/appDate?status=0&expire=%02d&startYear=0",
                 as.numeric(term))

  tryCatch({
    # Download page using system curl with --insecure to bypass SSL issues
    temp_file <- tempfile(fileext = ".html")
    on.exit(unlink(temp_file), add = TRUE)  # Ensure temporary file is deleted on exit

    # Build curl command with options:
    # --insecure: Skip SSL certificate verification
    # --max-time: Set maximum time allowed for transfer
    # --retry: Number of retries if transfer fails
    download_command <- sprintf('curl --insecure --max-time 30 --retry 3 "%s" -o "%s"', url, temp_file)

    # Execute system command
    message("Downloading data from Legislative Yuan website...")
    result <- suppressWarnings(system(download_command, intern = TRUE))

    # Check if download was successful
    if (!file.exists(temp_file) || file.size(temp_file) == 0) {
      stop("Failed to download the HTML content. The website might be down.")
    }

    # Read and parse the HTML content
    html_content <- xml2::read_html(temp_file)
    html_ <- rvest::html_nodes(html_content, "*[class='section_wrapper']")

    # Extract table headers
    title <- stringr::str_split_1(
      rvest::html_text2(
        rvest::html_nodes(html_, "[class='tt_titlebar2']")
      ),
      "\t\r"
    )[1:2]

    # Extract table rows (both odd and even rows)
    odd_rows <- rvest::html_text2(
      rvest::html_nodes(html_, "[class='tt_listrow_odd']")
    )
    even_rows <- rvest::html_text2(
      rvest::html_nodes(html_, "[class='tt_listrow_even']")
    )

    # Process data by removing whitespace
    data <- lapply(
      lapply(c(odd_rows, even_rows),
             function(x) stringr::str_split_1(x, "\r\r")),
      function(x) gsub("[[:space:]]", "", x)
    )

    # Create dataframe and set column names
    df <- do.call(rbind, data)
    colnames(df) <- title

    # Ensure df is a proper dataframe
    df <- as.data.frame(df, stringsAsFactors = FALSE)

    # Clean JavaScript code from date field
    # The date field often contains unwanted JavaScript that needs to be removed
    col_index <- which(colnames(df) == "會議起迄日")
    if (length(col_index) > 0) {
      df[, col_index] <- gsub("~if\\(.*\\).*", "~", df[, col_index])
    }

    # Sort by session number to ensure proper ordering
    # This section prevents "NAs introduced by coercion" warnings
    col_index <- which(colnames(df) == "屆期會期")
    if (length(col_index) > 0) {
      # More robust method to extract and sort by session numbers
      session_titles <- df[, col_index]

      # Extract session numbers using a safer approach
      session_numbers <- suppressWarnings({
        sapply(session_titles, function(title) {
          # Extract the main session number (not including special sessions)
          match <- regexpr("第([0-9]+)會期", title)
          if (match > 0) {
            start_pos <- match + 1  # Skip the "第" character
            end_pos <- start_pos + attr(match, "match.length") - 3  # Exclude "會期"
            as.numeric(substr(title, start_pos, end_pos))
          } else {
            NA_real_  # Return NA for titles that don't match the pattern
          }
        })
      })

      # Create a sorting index that handles both regular and special sessions
      # First by main session number, then by whether it's a special session
      is_special_session <- grepl("臨時會", session_titles)

      if (any(!is.na(session_numbers))) {
        sort_index <- order(is.na(session_numbers),  # NAs last
                            session_numbers,         # Sort by main session number
                            is_special_session)      # Regular sessions before special sessions
        df <- df[sort_index, ]
      }
    }

    message("Session information retrieved successfully.")
    return(tibble::as_tibble(df))
  },
  error = function(e) {
    stop(paste("Error retrieving session information:", e$message))
  })
}
