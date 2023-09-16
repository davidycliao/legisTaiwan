#' Check Each Function's Manual
#'
#'@author David Liao (davidycliao@@gmail.com)
#'
#'@description `get_variable_info` generate each API's endpoint manual returned
#'from the website of Taiwan Legislative Yuan. The avalaible options is: `get_bills`,
#'`get_bills_2`, `get_meetings`, `get_caucus_meetings`, `get_speech_video` ,
#'`get_public_debates`, `get_parlquestions`, `get_executive_response` and
#'`get_committee_record`.
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
#' @export
#'
#' @seealso `review_session_info()`.
#'
#' @examples
#' \dontrun{
#' get_variable_info("get_bills")
#' }
# get_variable_info <- function(param_) {
#   check_internet()
#   attempt::stop_if_all(website_availability(), isFALSE, msg = "the error from the API.")
#   attempt::stop_if_all(param_, is.numeric, msg = "use string format only.")
#   attempt::stop_if_all(param_, is.null, msg = "use correct funtion names.")
#   attempt::stop_if(param_ , ~ length(.x) >1, msg = "only allowed to query one function.")
#   if (param_ == "get_parlquestions") {
#     url <- "https://data.ly.gov.tw/getds.action?id=6"
#   }
#   else if (param_ == "get_legislators") {
#     url <- "https://data.ly.gov.tw/getds.action?id=16"
#   }
#   else if (param_ == "get_committee_record") {
#     url <- "https://data.ly.gov.tw/getds.action?id=46"
#   }
#   else if (param_ == "get_executive_response") {
#     url <- "https://data.ly.gov.tw/getds.action?id=2"
#   }
#   else if (param_ == "get_caucus_meetings") {
#     url <- "https://data.ly.gov.tw/getds.action?id=8"
#   }
#   else if (param_ == "get_speech_video") {
#     url <- "https://data.ly.gov.tw/getds.action?id=148"
#   }
#   else if (param_ == "get_bills_2") {
#     url <- "https://data.ly.gov.tw/getds.action?id=20"
#   }
#   else if (param_ == "get_public_debates") {
#     url <- "https://data.ly.gov.tw/getds.action?id=7"
#   }
#   else if (param_ %in% c("get_bills", "get_meetings")) {
#     if (param_ == "get_meetings") {
#       url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
#       }
#     else if (param_ == "get_bills") {
#       url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153"
#       }
#     html_info <- rvest::html_text2(rvest::html_nodes(rvest::html_nodes(rvest::read_html(url), "*[id='form_Query']"), "div") )
#     page_info <- list(page_info = strsplit(html_info[14], split = "\n")[[1]], reference_url = url)
#     return(page_info)
#   }
#   else {
#     stop("Use correct funtion names below in character format:
#          get_bills: the records of the bills
#          get_bills_2: the records of legislators and the government proposals
#          get_meetings: the spoken meeting records
#          get_caucus_meetings: the meeting records of cross-caucus session
#          get_speech_video: the full video information of meetings and committees
#          get_public_debates: the records of national public debates
#          get_parlquestions: the records of parliamentary questions
#          get_executive_response: the records of the questions answered by the executives")
#     }
#     html <- rvest::html_nodes(rvest::read_html(url), "*[id='content']")
#     title <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "h2")))
#
#     content <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "span")))
#     df <- data.frame(content[seq(1, length(content), 2 )],
#                      content[seq(1, length(content) + 1, 2 ) -1])
#     colnames(df) <- c(title[2], title[1])
#     df <- tibble::as_tibble(df)
#     page_info <- list(page_info = df, reference_url = url)
#   return(page_info)
# }

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


#' Check Session Periods in Each Year (Minguo Calendar)
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
#' \dontrun{
#' review_session_info(7)
#' }

# review_session_info <- function(term){
#   attempt::stop_if_all(website_availability2(), isFALSE, msg = "the error from the API.")
#   attempt::stop_if_all(term, is.null, msg = "use correct `term`")
#   attempt::stop_if_all(term %in% 1:11, isFALSE, msg = "use correct `term`")
#   url <- paste("https://npl.ly.gov.tw/do/www/appDate?status=0&expire=",
#                sprintf("%02d", as.numeric(term)),
#                "&startYear=0", sep ="")
#   html_ <- rvest::html_nodes(rvest::read_html(url), "*[class='section_wrapper']")
#   title <- stringr::str_split_1(rvest::html_text2(rvest::html_nodes(html_, "[class='tt_titlebar2']")), "\t\r")[1:2]
#   o <- rvest::html_text2(rvest::html_nodes(html_, "[class='tt_listrow_odd']"))
#   e <- rvest::html_text2(rvest::html_nodes(html_, "[class='tt_listrow_even']"))
#   s <- lapply(lapply(c(o, e),function(.){stringr::str_split_1(., "\r\r" )}),
#                      function(.){gsub("[[:space:]]", "", .)})
#   df <- do.call(rbind, s)
#   colnames(df) <- title
#   df <- tibble::as_tibble(df)
#   return(df)
#   }
#
#



review_session_info <- function(term) {
  attempt::stop_if_not(website_availability2(), msg = "the error from the API.")
  attempt::stop_if(term, is.null, msg = "use correct `term`.")
  attempt::stop_if_not(term %in% 1:11, msg = "use correct `term`.")

  url <- paste("https://npl.ly.gov.tw/do/www/appDate?status=0&expire=",
               sprintf("%02d", as.numeric(term)),
               "&startYear=0", sep ="")

  html_ <- rvest::html_nodes(rvest::read_html(url), "*[class='section_wrapper']")
  title <- stringr::str_split_1(rvest::html_text2(rvest::html_nodes(html_, "[class='tt_titlebar2']")), "\t\r")[1:2]
  o <- rvest::html_text2(rvest::html_nodes(html_, "[class='tt_listrow_odd']"))
  e <- rvest::html_text2(rvest::html_nodes(html_, "[class='tt_listrow_even']"))
  s <- lapply(lapply(c(o, e), function(.) {stringr::str_split_1(., "\r\r")}),
              function(.) {gsub("[[:space:]]", "", .)})
  df <- do.call(rbind, s)
  colnames(df) <- title
  df <- tibble::as_tibble(df)

  return(df)
}
