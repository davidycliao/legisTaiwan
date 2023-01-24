#' Check function information on the website of Taiwan Legislative API
#'
#'@param x The parameter should be `get_parlquestions`, `get_legislators`,
#'`get_executive_response`, `get_bills`, or `get_meetings`
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'@importFrom rvest html_text2 read_html html_text2
#'@importFrom tibble as_tibble
#'
#'@export
#'@examples
#'get_infos("get_parlquestions")
#'
#'get_infos("get_legislators")
#'
#'get_infos("get_executive_response")
#'
#'get_infos("get_bills")
#'
#'get_infos("get_meetings")
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=6}
#'\url{https://data.ly.gov.tw/getds.action?id=16}
#'\url{https://data.ly.gov.tw/getds.action?id=2}
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=153}

get_infos <- function(x) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(x, is.numeric, msg = "use string format only")
  attempt::stop_if(x , ~ length(.x) >1, msg = "only allowed to query one variable")
  if (x == "get_parlquestions") {
    # 質詢事項(本院委員質詢部分) https://data.ly.gov.tw/getds.action?id=6
    url <- "https://data.ly.gov.tw/getds.action?id=6"
  }
  else if (x == "get_legislators") {
    # 歷屆委員資料 https://data.ly.gov.tw/getds.action?id=16
    url <- "https://data.ly.gov.tw/getds.action?id=16"
  }
  else if (x == "get_executive_response") {
    # 行政院答復 https://data.ly.gov.tw/getds.action?id=2
    url <- "https://data.ly.gov.tw/getds.action?id=2"
  }
  else if (x %in% c("get_bills", "get_meetings")) {
    # outliers: get_bills & get_meetings
    if (x == "get_meetings") {
      # 委員發言(API) https://www.ly.gov.tw/Pages/List.aspx?nodeid=154
      url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
      }
    else if (x == "get_bills") {
      # 法律提案(API) https://www.ly.gov.tw/Pages/List.aspx?nodeid=153
      url <- "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153"
      }
    html_info <- rvest::html_text2(rvest::html_nodes(rvest::html_nodes(rvest::read_html(url), "*[id='form_Query']"), "div") )
    page_info <- list(page_info = strsplit(html_info[14], split = "\n")[[1]], reference_url = url)
    return(page_info)
  }
  else {
    stop("Please use correct funtion names (get_bills, get_meetings, or get_executive_response, etc) or typographical error.")
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