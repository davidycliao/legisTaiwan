#' Analyze Legislative Bills Statistics
#'
#' @description
#' Analyzes and visualizes bill statistics from the Legislative Yuan, including
#' bill counts by term, percentages, and trends. Creates a visualization and
#' provides summary statistics.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item bill
#'     \itemize{
#'       \item total - Total number of bills
#'       \item max_update_time - Last update timestamp
#'       \item terms - Data frame with columns:
#'         \itemize{
#'           \item term - Legislative term number
#'           \item count - Number of bills in that term
#'         }
#'     }
#'   }
#'
#' @return A list containing:
#'   \itemize{
#'     \item plot - A ggplot object showing bill count trends
#'     \item summary - A data frame with bill statistics including:
#'       \itemize{
#'         \item term
#'         \item count
#'         \item percentage
#'         \item cumulative
#'       }
#'   }
#'
#' @import ggplot2
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' analyze_bills(stats)
#' }
#'
#' @export
analyze_bills <- function(stats) {
  # Calculate bill counts and percentages by term
  bill_stats <- stats$bill$terms %>%
    mutate(
      percentage = round(count / sum(count) * 100, 2),
      cumulative = cumsum(count)
    )

  # Create bill count trend plot
  ggplot(bill_stats, aes(x = term, y = count)) +
    geom_line(color = "blue") +
    geom_point(color = "red") +
    labs(
      title = "Bill Count Trends by Legislative Term",
      x = "Term",
      y = "Number of Bills"
    ) +
    theme_minimal()

  # Output statistical summary
  cat("\n=== Bill Statistics Summary ===\n")
  cat(sprintf("Total Bills: %d\n", stats$bill$total))
  cat(sprintf("Last Updated: %s\n", format(stats$bill$max_update_time)))
  cat("\nFirst Five Terms Bill Count:\n")
  print(head(bill_stats, 5))
}


#' Analyze Legislative Meeting Statistics
#'
#' @description
#' Analyzes and visualizes meeting statistics from the Legislative Yuan, including
#' meeting counts by term, minutes completion rates, and produces a comparison visualization
#' between total meetings and available meeting minutes.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item meet
#'     \itemize{
#'       \item total - Total number of meetings
#'       \item terms - Data frame with columns:
#'         \itemize{
#'           \item term - Legislative term number
#'           \item count - Number of meetings in that term
#'           \item max_meeting_date - Last meeting date of the term
#'           \item meetdata_count - Number of meetings with data
#'           \item 議事錄_count - Number of meetings with minutes
#'         }
#'     }
#'   }
#'
#' @return A list containing:
#'   \itemize{
#'     \item plot - A ggplot object showing meeting statistics comparison
#'     \item summary - A data frame with meeting statistics including:
#'       \itemize{
#'         \item term
#'         \item count
#'         \item minutes_ratio - Percentage of meetings with minutes
#'         \item last_meeting_date - Formatted date of last meeting
#'       }
#'   }
#'
#' @import ggplot2
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' analyze_meetings(stats)
#' }
#'
#' @export
analyze_meetings <- function(stats) {
  # Process meeting data
  meeting_stats <- stats$meet$terms %>%
    mutate(
      minutes_ratio = round(議事錄_count / count * 100, 2),
      last_meeting_date = format(max_meeting_date, "%Y-%m-%d")
    )

  # Create meeting records completeness analysis plot
  ggplot(meeting_stats, aes(x = term)) +
    geom_bar(aes(y = count), stat = "identity", fill = "blue", alpha = 0.5) +
    geom_bar(aes(y = 議事錄_count), stat = "identity", fill = "red", alpha = 0.5) +
    labs(
      title = "Meeting Records Completeness by Term",
      x = "Term",
      y = "Count"
    ) +
    theme_minimal()

  # Output statistical summary
  cat("\n=== Meeting Statistics Summary ===\n")
  cat(sprintf("Total Meetings: %d\n", stats$meet$total))
  cat("\nMeeting Records Statistics by Term:\n")
  print(head(meeting_stats, 5))
}


#' Analyze Legislative Video (IVOD) Statistics
#'
#' @description
#' Analyzes and visualizes video records (IVOD - Internet Video on Demand) statistics
#' from the Legislative Yuan, including video counts by term, daily averages,
#' and time period coverage.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item ivod
#'     \itemize{
#'       \item total - Total number of video records
#'       \item date_range
#'         \itemize{
#'           \item start - Start date of video archive
#'           \item end - End date of video archive
#'         }
#'       \item terms - Data frame with columns:
#'         \itemize{
#'           \item term - Legislative term number
#'           \item count - Number of videos in that term
#'           \item start_date - Start date of term
#'           \item end_date - End date of term
#'         }
#'     }
#'   }
#'
#' @return A list containing:
#'   \itemize{
#'     \item plot - A ggplot object showing video count distribution by term
#'     \item summary - A data frame with video statistics including:
#'       \itemize{
#'         \item term
#'         \item count
#'         \item start_date_fmt
#'         \item end_date_fmt
#'         \item period_days
#'         \item avg_daily_videos
#'       }
#'   }
#'
#' @import ggplot2
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' analyze_ivod(stats)
#' }
#'
#' @export
analyze_ivod <- function(stats) {
  # Process video data
  ivod_stats <- stats$ivod$terms %>%
    mutate(
      start_date_fmt = format(start_date, "%Y-%m-%d"),
      end_date_fmt = format(end_date, "%Y-%m-%d"),
      period_days = as.numeric(difftime(end_date, start_date, units = "days")),
      avg_daily_videos = round(count / period_days, 2)
    )

  # Create video count distribution plot
  ggplot(ivod_stats, aes(x = term, y = count)) +
    geom_bar(stat = "identity", fill = "darkgreen") +
    labs(
      title = "Video Records Count by Term",
      x = "Term",
      y = "Number of Videos"
    ) +
    theme_minimal()

  # Output statistical summary
  cat("\n=== Video Statistics Summary ===\n")
  cat(sprintf("Total Videos: %d\n", stats$ivod$total))
  cat(sprintf("Data Period: %s to %s\n",
              format(stats$ivod$date_range$start, "%Y-%m-%d"),
              format(stats$ivod$date_range$end, "%Y-%m-%d")))
  cat("\nVideo Statistics by Term:\n")
  print(head(ivod_stats, 5))
}


#' Generate Legislative Yuan Summary Statistics Report
#'
#' @description
#' Generates a comprehensive summary report of Legislative Yuan statistics,
#' including legislator counts, gazette information, and video records data.
#' Presents the information in a formatted text output.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item legislator
#'     \itemize{
#'       \item total - Total historical number of legislators
#'       \item terms - Data frame of legislator counts by term
#'     }
#'     \item gazette
#'     \itemize{
#'       \item total - Total number of gazettes
#'       \item agenda_total - Total number of agendas
#'       \item last_meeting - Date of the last meeting
#'     }
#'     \item ivod
#'     \itemize{
#'       \item total - Total number of video records
#'       \item date_range - List containing start and end dates of video archives
#'     }
#'   }
#'
#' @return Prints a formatted report to the console containing:
#'   \itemize{
#'     \item Legislator statistics and historical counts
#'     \item Gazette information including total counts and latest meeting
#'     \item Video archive statistics with time period coverage
#'   }
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' generate_summary_report(stats)
#' }
#'
#' @export
generate_report <- function(stats) {
  cat("\n==========================================")
  cat("\n    Legislative Yuan Data Analysis Report")
  cat("\n==========================================\n")

  # 1. Bill statistics
  cat("\nI. Bill Statistics")
  cat("\n------------------------------------------")
  cat(sprintf("\nTotal Bills: %d", stats$bill$total))
  cat(sprintf("\nLast Bill Update: %s", format(stats$bill$max_update_time, "%Y-%m-%d")))

  # 2. Legislator statistics
  cat("\n\nII. Legislator Statistics")
  cat("\n------------------------------------------")
  cat(sprintf("\nHistorical Total Legislators: %d", stats$legislator$total))
  cat("\nLegislators by Term:")
  print(head(stats$legislator$terms, 5))

  # 3. Gazette statistics
  cat("\nIII. Gazette Statistics")
  cat("\n------------------------------------------")
  cat(sprintf("\nTotal Gazettes: %d", stats$gazette$total))
  cat(sprintf("\nTotal Agendas: %d", stats$gazette$agenda_total))
  cat(sprintf("\nLast Meeting Date: %s", format(stats$gazette$last_meeting, "%Y-%m-%d")))

  # 4. Video statistics
  cat("\n\nIV. Video Statistics")
  cat("\n------------------------------------------")
  cat(sprintf("\nTotal Videos: %d", stats$ivod$total))
  cat(sprintf("\nVideo Recording Period: %s to %s",
              format(stats$ivod$date_range$start, "%Y-%m-%d"),
              format(stats$ivod$date_range$end, "%Y-%m-%d")))

  cat("\n\n==========================================\n")
}


#' Calculate Legislative Bill Trends and Metrics
#'
#' @description
#' Calculates various trend metrics for legislative bills, including bills per meeting
#' and bills per day, by joining bill and meeting statistics across terms.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item bill$terms - Data frame with columns:
#'       \itemize{
#'         \item term - Legislative term number
#'         \item count - Number of bills in that term
#'       }
#'     \item meet$terms - Data frame with columns:
#'       \itemize{
#'         \item term - Legislative term number
#'         \item count - Number of meetings in that term
#'         \item max_meeting_date - Last meeting date of the term
#'       }
#'   }
#'
#' @return A data frame containing the following columns:
#'   \itemize{
#'     \item term - Legislative term number
#'     \item bills - Total number of bills in term
#'     \item meetings - Total number of meetings in term
#'     \item bills_per_meeting - Average number of bills per meeting
#'     \item bills_per_day - Average number of bills per day
#'   }
#'
#' @importFrom dplyr left_join mutate select rename lag
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' trends <- calculate_bill_trends(stats)
#' head(trends)
#' }
#'
#' @export
calculate_bill_trends <- function(stats) {
  bill_trends <- stats$bill$terms %>%
    left_join(stats$meet$terms, by = "term") %>%
    mutate(
      bills_per_meeting = round(count.x / count.y, 2),
      bills_per_day = round(count.x / as.numeric(difftime(max_meeting_date,
                                                          lag(max_meeting_date), units = "days")), 2)
    ) %>%
    select(term, count.x, count.y, bills_per_meeting, bills_per_day) %>%
    rename(
      bills = count.x,
      meetings = count.y
    )

  print(bill_trends)
  return(bill_trends)
}


#' Create Interactive Plot of Legislative Bill Trends
#'
#' @description
#' Creates an interactive plotly visualization showing the trend of bill counts
#' across different legislative terms. The plot includes hover information
#' and interactive features.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#'   \itemize{
#'     \item bill$terms - Data frame with columns:
#'       \itemize{
#'         \item term - Legislative term number
#'         \item count - Number of bills in that term
#'       }
#'   }
#'
#' @return A plotly object containing:
#'   \itemize{
#'     \item An interactive line plot with markers
#'     \item Hover text showing term number and bill count
#'     \item Formatted axes and title
#'   }
#'
#' @import plotly
#' @importFrom plotly plot_ly layout
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' p <- create_interactive_plot(stats)
#' p  # Display the plot
#' }
#'
#' @export
create_interactive_plot <- function(stats) {
  bill_data <- stats$bill$terms

  p <- plot_ly(bill_data, x = ~term, y = ~count, type = "scatter", mode = "lines+markers",
               text = ~paste("Term:", term, "<br>Bills:", count),
               hoverinfo = "text") %>%
    layout(title = "Bill Count Trends by Term",
           xaxis = list(title = "Term"),
           yaxis = list(title = "Number of Bills"))

  return(p)
}
