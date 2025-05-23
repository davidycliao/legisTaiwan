% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meeting.R
\encoding{UTF-8}
\name{get_public_debates}
\alias{get_public_debates}
\title{The Records of National Public Debates 國是論壇}
\usage{
get_public_debates(term = NULL, session_period = NULL, verbose = TRUE)
}
\arguments{
\item{term}{numeric or NULL. The default is set to 10. Legislative term number
(e.g., 10). Data is officially available from the 8th term onwards, but
testing shows data starts from the 10th term.}

\item{session_period}{numeric or NULL. Session period number (1-8). Default is NULL.
Use \code{review_session_info()} to see available session periods in ROC calendar.}

\item{verbose}{logical. Whether to display download progress and detailed information.
Default is TRUE.}
}
\value{
A list containing:
\describe{
\item{\code{title}}{public debates records}
\item{\code{query_time}}{query timestamp}
\item{\code{retrieved_number}}{number of records retrieved}
\item{\code{retrieved_term}}{queried legislative term}
\item{\code{url}}{retrieved API URL}
\item{\code{variable_names}}{variables in the tibble dataframe}
\item{\code{manual_info}}{official manual URL or use get_variable_info("get_public_debates")}
\item{\code{data}}{a tibble dataframe containing:
\describe{
\item{\code{term}}{屆別}
\item{\code{sessionPeriod}}{會期}
\item{\code{sessionTimes}}{會次}
\item{\code{meetingTimes}}{臨時會會次}
\item{\code{dateTimeDesc}}{日期時間說明}
\item{\code{meetingRoom}}{會議地點}
\item{\code{chairman}}{主持人}
\item{\code{legislatorName}}{委員姓名}
\item{\code{speakType}}{發言類型(paper:書面發言,speak:發言)}
\item{\code{content}}{內容}
\item{\code{selectTerm}}{屆別期別篩選條件}
}
}
}
}
\description{
The Records of National Public Debates 國是論壇
}
\details{
The function retrieves records from the National Public Debates (國是論壇),
including both spoken and written opinions. While officially available from
the 8th legislative term, testing indicates data is only available from
the 10th term onwards.
}
\note{
For more details about the data variables and API information,
use \code{get_variable_info("get_public_debates")} or visit the API manual at
\url{https://data.ly.gov.tw/getds.action?id=7}.
議事類: 提供公報之國是論壇資訊，並包含書面意見。
自第8屆第1會期起，但實測資料從第10屆。
}
\examples{
\dontrun{
# Query public debates for term 10, session period 2
debates <- get_public_debates(term = 10, session_period = 2)

# Query without specifying session period
debates <- get_public_debates(term = 10)
}

}
\seealso{
\itemize{
\item \code{get_variable_info("get_public_debates")}
\item \code{review_session_info()}
\item For ROC calendar information: \url{https://en.wikipedia.org/wiki/Republic_of_China_calendar}
}
}
