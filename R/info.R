#' Check all function information
#'
#'@param param_ characters. The parameter should be `get_parlquestions`,
#'`get_legislators`, `get_executive_response`, `get_bills`, `get_meetings`,
#'`get_caucus_meetings` or `get_public_debates`,
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom rvest html_text2 read_html
#'@importFrom tibble as_tibble
#'@importFrom stringi stri_escape_unicode
#'
#'@export
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=6}
#'\url{https://data.ly.gov.tw/getds.action?id=16}
#'\url{https://data.ly.gov.tw/getds.action?id=2}
#'\url{https://data.ly.gov.tw/getds.action?id=8}
#'\url{https://data.ly.gov.tw/getds.action?id=148}
#'\url{https://data.ly.gov.tw/getds.action?id=1}
#'\url{https://data.ly.gov.tw/getds.action?id=7}
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}

get_variabel_infos <- function(param_) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(param_, is.numeric, msg = "use string format only")
  attempt::stop_if_all(param_, is.null, msg = "use correct funtion names")
  attempt::stop_if(param_ , ~ length(.x) >1, msg = "only allowed to query one variable")
  if (param_ == "get_parlquestions") {
    # 質詢事項(本院委員質詢部分) https://data.ly.gov.tw/getds.action?id=6
    url <- "https://data.ly.gov.tw/getds.action?id=6"
  }
  else if (param_ == "get_legislators") {
    # 歷屆委員資料 https://data.ly.gov.tw/getds.action?id=16
    url <- "https://data.ly.gov.tw/getds.action?id=16"
  }
  else if (param_ == "get_executive_response") {
    # 行政院答復 https://data.ly.gov.tw/getds.action?id=2
    url <- "https://data.ly.gov.tw/getds.action?id=2"
  }
  else if (param_ == "get_caucus_meetings") {
    # 黨團協商 https://data.ly.gov.tw/getds.action?id=8
    url <- "https://data.ly.gov.tw/getds.action?id=8"
  }
  else if (param_ == "get_speech_video") {
    # 委員發言片段相關影片資訊 https://data.ly.gov.tw/getds.action?id=148
    url <- "https://data.ly.gov.tw/getds.action?id=148"
  }
  else if (param_ == "get_bills_2") {
    # 質詢事項 (行政院答復部分) https://data.ly.gov.tw/getds.action?id=1
    url <- "https://data.ly.gov.tw/getds.action?id=1"
  }
  else if (param_ == "get_public_debates") {
    # 國是論壇 https://data.ly.gov.tw/getds.action?id=7
    url <- "https://data.ly.gov.tw/getds.action?id=7"
  }
  else if (param_ %in% c("get_bills", "get_meetings")) {
    # outliers: get_bills & get_meetings
    if (param_ == "get_meetings") {
      # 委員發言(API) https://www.ly.gov.tw/Pages/List.aspx?nodeid=154
      url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
      }
    else if (param_ == "get_bills") {
      # 法律提案(API) https://www.ly.gov.tw/Pages/List.aspx?nodeid=153
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
         get_parlquestions:  the records of parliamentary questions
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
