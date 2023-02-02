#' Check each function's manuals
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
#'@importFrom stringi stri_escape_unicode
#'
#'@export

get_variable_info <- function(param_) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(param_, is.numeric, msg = "use string format only.")
  attempt::stop_if_all(param_, is.null, msg = "use correct funtion names.")
  attempt::stop_if(param_ , ~ length(.x) >1, msg = "only allowed to query one function.")
  if (param_ == "get_parlquestions") {
    url <- "https://data.ly.gov.tw/getds.action?id=6"
  }
  else if (param_ == "get_legislators") {
    url <- "https://data.ly.gov.tw/getds.action?id=16"
  }
  else if (param_ == "get_executive_response") {
    url <- "https://data.ly.gov.tw/getds.action?id=2"
  }
  else if (param_ == "get_caucus_meetings") {
    url <- "https://data.ly.gov.tw/getds.action?id=8"
  }
  else if (param_ == "get_speech_video") {
    url <- "https://data.ly.gov.tw/getds.action?id=148"
  }
  else if (param_ == "get_bills_2") {
    url <- "https://data.ly.gov.tw/getds.action?id=20"
  }
  else if (param_ == "get_public_debates") {
    url <- "https://data.ly.gov.tw/getds.action?id=7"
  }
  else if (param_ %in% c("get_bills", "get_meetings")) {
    # outliers: get_bills & get_meetings
    if (param_ == "get_meetings") {
      url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
      }
    else if (param_ == "get_bills") {
      url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153"
      }
    html_info <- rvest::html_text2(rvest::html_nodes(rvest::html_nodes(rvest::read_html(url), "*[id='form_Query']"), "div") )
    page_info <- list(page_info = strsplit(html_info[14], split = "\n")[[1]], reference_url = url)
    return(page_info)
  }
  else {
    stop("Use correct funtion names below in character format:
         get_bills: the records of the bills
         get_bills_2: the records of legislators and the government proposals
         get_meetings: the spoken meeting records
         get_caucus_meetings: the meeting records of cross-caucus session
         get_speech_video: the full video information of meetings and committees
         get_public_debates: the records of national public debates
         get_parlquestions: the records of parliamentary questions
         get_executive_response: the records of the questions answered by the executives")
    }
    html <- rvest::html_nodes(rvest::read_html(url), "*[id='content']")
    title <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "h2")))

    content <- gsub("[[:space:]]", "", rvest::html_text2(rvest::html_nodes(html, "span")))
    df <- data.frame(content[seq(1, length(content), 2 )],
                     content[seq(1, length(content) + 1, 2 ) -1])
    colnames(df) <- c(title[2], title[1])
    df <- tibble::as_tibble(df)
    page_info <- list(page_info = df, reference_url = url)
  return(page_info)
}
