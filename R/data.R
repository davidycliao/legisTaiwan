#' Taiwan Legislative Keywords for Text Analysis 常用立法關鍵字
#'
#' @title Legislative Keywords for Text Analysis
#' @description A dataset containing common keywords used in Taiwan's legislative text analysis.
#' These keywords are carefully selected to cover major policy domains including disaster
#' management, social welfare, housing policy, and regional development.
#'
#' @format A character vector containing 10 keywords:
#' \describe{
#'   \item{災害管理}{八二三砲戰, 九二一大地震, 地震}
#'   \item{社會福利}{托育, 日間托老, 長照}
#'   \item{住宅政策}{眷村改建, 遷村}
#'   \item{區域發展}{偏鄉}
#'   \item{金融政策}{金融卡}
#' }
#'
#' @usage legis_keywords
#'
#' @details
#' These keywords can be used with quanteda or other text analysis packages to analyze
#' legislative documents. They are particularly useful for:
#' \itemize{
#'   \item Creating document-term matrices
#'   \item Analyzing policy focus in legislative texts
#'   \item Tracking policy discussions over time
#'   \item Identifying key themes in parliamentary questions or texts
#' }
#'
#' @examples
#' # Load the keywords
#' data(legis_keywords)
#'
#' @source Keywords compiled based on common policy discussions in Taiwan Legislative Yuan
#'
#' @references
#' Legislative Yuan, Taiwan. \url{https://www.ly.gov.tw/}
#'
#' @docType data
#' @usage data("legis_keywords")
#' @name legis_keywords
NULL
