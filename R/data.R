#' Taiwan Legislative Keywords for Text Analysis
#'
#' @title Legislative Keywords for Text Analysis
#' @description A dataset containing common keywords used in Taiwan's legislative text analysis.
#' These keywords are carefully selected to cover major policy domains including disaster
#' management, social welfare, housing policy, and regional development.
#'
#' @format A character vector containing 10 keywords, all in Traditional Chinese
#'   (the language of the source legislative documents), grouped here by policy
#'   domain for reference:
#' \describe{
#'   \item{disaster management}{3 keywords, e.g. terms for the "823 Artillery
#'     Bombardment", the "921 earthquake", and "earthquake" in general}
#'   \item{social welfare}{3 keywords, e.g. terms for "childcare", "adult day
#'     care", and "long-term care"}
#'   \item{housing policy}{2 keywords, e.g. terms for "military dependents'
#'     village redevelopment" and "village relocation"}
#'   \item{regional development}{1 keyword, e.g. the term for "remote/rural
#'     areas"}
#'   \item{financial policy}{1 keyword, e.g. the term for "bank/ATM card"}
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
