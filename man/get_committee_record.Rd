% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meeting.R
\encoding{UTF-8}
\name{get_committee_record}
\alias{get_committee_record}
\title{The Records of Reviewed Items in the Committees 委員會會議審查之議案項目}
\usage{
get_committee_record(term = 10, session_period = NULL, verbose = TRUE)
}
\arguments{
\item{term}{numeric or null. Data is available only from the 8th term.
The default is set to 10. 參數必須為數值。提供委員會會議審查之議案項目。(自第10屆第1會期起)}

\item{session_period}{integer, numeric or NULL.
\code{review_session_info()} provides each session period's available options based on the
Minguo (Taiwan) calendar.}

\item{verbose}{logical. This indicates whether \code{get_executive_response} should
print a detailed output during data retrieval. Default is TRUE.}
}
\value{
A list containing:
\item{\code{title}}{Records of questions answered by executives}
\item{\code{query_time}}{Time of query}
\item{\code{retrieved_number}}{Total number of observations}
\item{\code{retrieved_term}}{Queried term}
\item{\code{url}}{Retrieved JSON URL}
\item{\code{variable_names}}{Variables of the tibble dataframe}
\item{\code{manual_info}}{Official manual, \url{https://data.ly.gov.tw/getds.action?id=46}; or use get_variable_info("get_committee_record")}
\item{\code{data}}{A tibble dataframe with variables:
\describe{
\item{\code{term}}{Term number}
\item{\code{sessionPeriod}}{Session}
\item{\code{meetingNo}}{Meeting number}
\item{\code{billNo}}{Bill number}
\item{\code{selectTerm}}{Term selection filter}
}
}

A list containing:
\item{\code{title}}{Records of questions answered by executives}
\item{\code{query_time}}{Time of query}
\item{\code{retrieved_number}}{Total number of observations}
\item{\code{retrieved_term}}{Queried term}
\item{\code{url}}{Retrieved JSON URL}
\item{\code{variable_names}}{Variables of the tibble dataframe}
\item{\code{manual_info}}{Official manual, \url{https://data.ly.gov.tw/getds.action?id=46}; or use get_variable_info("get_committee_record")}
\item{\code{data}}{A tibble dataframe with variables:
\describe{
\item{\code{term}}{Term number}
\item{\code{sessionPeriod}}{Session}
\item{\code{meetingNo}}{Meeting number}
\item{\code{billNo}}{Bill number}
\item{\code{selectTerm}}{Term selection filter}
}
}
}
\description{
The Records of Reviewed Items in the Committees 委員會會議審查之議案項目
}
\details{
\code{get_committee_record} provides a list which includes \code{title},
\code{query_time}, \code{retrieved_number}, \code{retrieved_term}, \code{url}, \code{variable_names},
\code{manual_info}, and \code{data}.

\code{get_committee_record} provides a list which includes \code{title},
\code{query_time}, \code{retrieved_number}, \code{retrieved_term}, \code{url}, \code{variable_names},
\code{manual_info}, and \code{data}.
}
\note{
To access the user manual and more information about the data frame's variables,
please refer to \code{get_variable_info("get_committee_record")} or check the API manual at
\url{https://data.ly.gov.tw/getds.action?id=46}.
This provides agenda items reviewed in committee meetings (from the 10th term, 1st session onwards).

To access the user manual and more information about the data frame's variables,
please refer to \code{get_variable_info("get_committee_record")} or check the API manual at
\url{https://data.ly.gov.tw/getds.action?id=46}.
This provides agenda items reviewed in committee meetings (from the 10th term, 1st session onwards).
}
\examples{
## Query the committee record by term and session period.
## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
get_committee_record(term = 10, session_period = 1)

## Query the committee record by term and session period.
## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
get_committee_record(term = 10, session_period = 1)

}
\seealso{
\code{get_variable_info("get_committee_record")}, \code{review_session_info()}
The Records of Reviewed Items in the Committees 委員會會議審查之議案項目

\code{get_variable_info("get_committee_record")}, \code{review_session_info()}
}
\author{
David Yen-Chieh Liao
}
