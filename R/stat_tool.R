#' Analyze Legislative Bills Statistics
#'
#' @description
#' Analyzes and visualizes bill statistics from the Legislative Yuan, including
#' bill counts by term, percentages, and trends. Creates a visualization and
#' provides summary statistics.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#' \describe{
#'   \item{bill}{A list containing:
#'     \describe{
#'       \item{total}{Total number of bills}
#'       \item{max_update_time}{Last update timestamp}
#'       \item{terms}{Data frame with columns:
#'         \describe{
#'           \item{term}{Legislative term number}
#'           \item{count}{Number of bills in that term}
#'         }
#'       }
#'     }
#'   }
#' }
#'
#' @return A list containing:
#' \describe{
#'   \item{plot}{A ggplot object showing bill count trends}
#'   \item{summary}{A data frame with bill statistics including:
#'     \describe{
#'       \item{term}{Term number}
#'       \item{count}{Bill count}
#'       \item{percentage}{Percentage of total}
#'       \item{cumulative}{Cumulative count}
#'     }
#'   }
#' }
#'
#' @import ggplot2
#' @importFrom dplyr mutate %>%
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' stats <- get_ly_stat()
#' bill_analysis <- analyze_bills(stats)
#'
#' # View the plot
#' print(bill_analysis$plot)
#'
#' # View the summary statistics
#' print(bill_analysis$summary)
#' }
#'
#' @export
analyze_bills <- function(stats) {
  # Calculate bill counts and percentages by term
  bill_stats <- stats$bill$terms %>%
    dplyr::mutate(
      percentage = round(.data$count / sum(.data$count) * 100, 2),
      cumulative = cumsum(.data$count)
    )

  # Create bill count trend plot
  p <- ggplot2::ggplot(bill_stats, ggplot2::aes(x = .data$term, y = .data$count)) +
    ggplot2::geom_line(color = "blue") +
    ggplot2::geom_point(color = "red") +
    ggplot2::labs(
      title = "Bill Count Trends by Legislative Term",
      x = "Term",
      y = "Number of Bills"
    ) +
    ggplot2::theme_minimal()

  # Output statistical summary
  cat("\n=== Bill Statistics Summary ===\n")
  cat(sprintf("Total Bills: %d\n", stats$bill$total))
  cat(sprintf("Last Updated: %s\n", format(stats$bill$max_update_time)))
  cat("\nFirst Five Terms Bill Count:\n")
  print(head(bill_stats, 5))

  # Return both the plot and statistics
  return(list(
    plot = p,
    summary = bill_stats
  ))
}
#' Analyze Legislative Meeting Statistics
#'
#' @description
#' Analyzes and visualizes meeting statistics from the Legislative Yuan, including
#' meeting counts by term, minutes completion rates, and produces a comparison visualization
#' between total meetings and available meeting minutes.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#' \describe{
#'   \item{meet}{A list containing:
#'     \describe{
#'       \item{total}{Total number of meetings}
#'       \item{terms}{Data frame with columns:
#'         \describe{
#'           \item{term}{Legislative term number}
#'           \item{count}{Number of meetings in that term}
#'           \item{max_meeting_date}{Last meeting date of the term}
#'           \item{meetdata_count}{Number of meetings with data}
#'           \item{議事錄_count}{Number of meetings with minutes}
#'         }
#'       }
#'     }
#'   }
#' }
#'
#' @return A list containing:
#' \describe{
#'   \item{plot}{A ggplot object showing meeting statistics comparison}
#'   \item{summary}{A data frame with meeting statistics including:
#'     \describe{
#'       \item{term}{Term number}
#'       \item{count}{Total meetings}
#'       \item{minutes_ratio}{Percentage of meetings with minutes}
#'       \item{last_meeting_date}{Formatted date of last meeting}
#'     }
#'   }
#' }
#'
#' @import ggplot2
#' @importFrom dplyr mutate %>%
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' # Get statistics and analyze meetings
#' stats <- get_ly_stat()
#' meeting_analysis <- analyze_meetings(stats)
#'
#' # View the plot
#' print(meeting_analysis$plot)
#'
#' # View meeting statistics
#' print(meeting_analysis$summary)
#' }
#'
#' @export
analyze_meetings <- function(stats) {
  # Process meeting data
  meeting_stats <- stats$meet$terms %>%
    dplyr::mutate(
      minutes_ratio = round(.data$議事錄_count / .data$count * 100, 2),
      last_meeting_date = format(.data$max_meeting_date, "%Y-%m-%d")
    )

  # Create meeting records completeness analysis plot
  p <- ggplot2::ggplot(meeting_stats, ggplot2::aes(x = .data$term)) +
    ggplot2::geom_bar(
      ggplot2::aes(y = .data$count),
      stat = "identity",
      fill = "blue",
      alpha = 0.5
    ) +
    ggplot2::geom_bar(
      ggplot2::aes(y = .data$議事錄_count),
      stat = "identity",
      fill = "red",
      alpha = 0.5
    ) +
    ggplot2::labs(
      title = "Meeting Records Completeness by Term",
      x = "Term",
      y = "Count"
    ) +
    ggplot2::theme_minimal()

  # Output statistical summary
  cat("\n=== Meeting Statistics Summary ===\n")
  cat(sprintf("Total Meetings: %d\n", stats$meet$total))
  cat("\nMeeting Records Statistics by Term:\n")
  print(head(meeting_stats, 5))

  # Return both the plot and statistics
  return(list(
    plot = p,
    summary = meeting_stats
  ))
}


#' Analyze Legislative Video (IVOD) Statistics
#'
#' @description
#' Analyzes and visualizes video records (IVOD - Internet Video on Demand) statistics
#' from the Legislative Yuan, including video counts by term, daily averages,
#' and time period coverage.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#' \describe{
#'   \item{ivod}{A list containing:
#'     \describe{
#'       \item{total}{Total number of video records}
#'       \item{date_range}{A list containing:
#'         \describe{
#'           \item{start}{Start date of video archive}
#'           \item{end}{End date of video archive}
#'         }
#'       }
#'       \item{terms}{Data frame with columns:
#'         \describe{
#'           \item{term}{Legislative term number}
#'           \item{count}{Number of videos in that term}
#'           \item{start_date}{Start date of term}
#'           \item{end_date}{End date of term}
#'         }
#'       }
#'     }
#'   }
#' }
#'
#' @return A list containing:
#' \describe{
#'   \item{plot}{A ggplot object showing video count distribution by term}
#'   \item{summary}{A data frame with video statistics including:
#'     \describe{
#'       \item{term}{Term number}
#'       \item{count}{Video count}
#'       \item{start_date_fmt}{Formatted start date}
#'       \item{end_date_fmt}{Formatted end date}
#'       \item{period_days}{Duration in days}
#'       \item{avg_daily_videos}{Average videos per day}
#'     }
#'   }
#' }
#'
#' @import ggplot2
#' @importFrom dplyr mutate %>%
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' # Get statistics and analyze videos
#' stats <- get_ly_stat()
#' video_analysis <- analyze_ivod(stats)
#'
#' # View the plot
#' print(video_analysis$plot)
#'
#' # View video statistics
#' print(video_analysis$summary)
#' }
#'
#' @export
analyze_ivod <- function(stats) {
  # Process video data
  ivod_stats <- stats$ivod$terms %>%
    dplyr::mutate(
      start_date_fmt = format(.data$start_date, "%Y-%m-%d"),
      end_date_fmt = format(.data$end_date, "%Y-%m-%d"),
      period_days = as.numeric(difftime(.data$end_date, .data$start_date, units = "days")),
      avg_daily_videos = round(.data$count / .data$period_days, 2)
    )

  # Create video count distribution plot
  p <- ggplot2::ggplot(ivod_stats, ggplot2::aes(x = .data$term, y = .data$count)) +
    ggplot2::geom_bar(stat = "identity", fill = "darkgreen") +
    ggplot2::labs(
      title = "Video Records Count by Term",
      x = "Term",
      y = "Number of Videos"
    ) +
    ggplot2::theme_minimal()

  # Output statistical summary
  cat("\n=== Video Statistics Summary ===\n")
  cat(sprintf("Total Videos: %d\n", stats$ivod$total))
  cat(sprintf("Data Period: %s to %s\n",
              format(stats$ivod$date_range$start, "%Y-%m-%d"),
              format(stats$ivod$date_range$end, "%Y-%m-%d")))
  cat("\nVideo Statistics by Term:\n")
  print(head(ivod_stats, 5))

  # Return both the plot and statistics
  return(list(
    plot = p,
    summary = ivod_stats
  ))
}
#' Generate Legislative Yuan Summary Statistics Report
#'
#' @description
#' Generates a comprehensive summary report of Legislative Yuan statistics,
#' including legislator counts, gazette information, and video records data.
#' Presents the information in a formatted text output.
#'
#' @param stats A list containing Legislative Yuan statistics with the following structure:
#' \describe{
#'   \item{legislator}{A list containing legislator information:
#'     \describe{
#'       \item{total}{Total historical number of legislators}
#'       \item{terms}{Data frame of legislator counts by term}
#'     }
#'   }
#'   \item{gazette}{A list containing gazette information:
#'     \describe{
#'       \item{total}{Total number of gazettes}
#'       \item{agenda_total}{Total number of agendas}
#'       \item{last_meeting}{Date of the last meeting}
#'     }
#'   }
#'   \item{ivod}{A list containing video information:
#'     \describe{
#'       \item{total}{Total number of video records}
#'       \item{date_range}{List containing start and end dates of video archives}
#'     }
#'   }
#' }
#'
#' @return A formatted report containing the following sections:
#' \describe{
#'   \item{Bill Statistics}{
#'     \describe{
#'       \item{Total Bills}{Total number of bills}
#'       \item{Last Update}{Most recent bill update date}
#'     }
#'   }
#'   \item{Legislator Statistics}{
#'     \describe{
#'       \item{Total Count}{Historical total of legislators}
#'       \item{Term Distribution}{Legislator counts by term}
#'     }
#'   }
#'   \item{Gazette Statistics}{
#'     \describe{
#'       \item{Total Counts}{Numbers of gazettes and agendas}
#'       \item{Latest Activity}{Most recent meeting date}
#'     }
#'   }
#'   \item{Video Statistics}{
#'     \describe{
#'       \item{Total Videos}{Number of video records}
#'       \item{Coverage Period}{Time span of video archives}
#'     }
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Generate full statistics report
#' stats <- get_ly_stat()
#' generate_report(stats)
#'
#' # View specific sections
#' stats <- get_ly_stat()
#' cat("\nBill Statistics:\n")
#' cat(sprintf("Total Bills: %d\n", stats$bill$total))
#'
#' cat("\nLegislator Statistics:\n")
#' cat(sprintf("Total Legislators: %d\n", stats$legislator$total))
#' }
#'
#' @seealso
#' \describe{
#'   \item{analyze_bills}{For detailed bill analysis}
#'   \item{analyze_meetings}{For meeting statistics analysis}
#'   \item{analyze_ivod}{For video records analysis}
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
  cat(sprintf("\nLast Meeting Date: %s",
              format(stats$gazette$last_meeting, "%Y-%m-%d")))

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
#' \describe{
#'   \item{bill$terms}{Data frame containing bill information:
#'     \describe{
#'       \item{term}{Legislative term number}
#'       \item{count}{Number of bills in that term}
#'     }
#'   }
#'   \item{meet$terms}{Data frame containing meeting information:
#'     \describe{
#'       \item{term}{Legislative term number}
#'       \item{count}{Number of meetings in that term}
#'       \item{max_meeting_date}{Last meeting date of the term}
#'     }
#'   }
#' }
#'
#' @return A data frame containing the following columns:
#' \describe{
#'   \item{term}{Legislative term number}
#'   \item{bills}{Total number of bills in term}
#'   \item{meetings}{Total number of meetings in term}
#'   \item{bills_per_meeting}{Average number of bills per meeting}
#'   \item{bills_per_day}{Average number of bills per day}
#' }
#'
#' @importFrom dplyr left_join mutate select rename lag %>%
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' # Get statistics and calculate trends
#' stats <- get_ly_stat()
#' trends <- calculate_bill_trends(stats)
#'
#' # View trend analysis
#' print("Bill processing trends:")
#' print(trends)
#'
#' # Analyze specific metrics
#' print("Average bills per meeting by term:")
#' print(trends[c("term", "bills_per_meeting")])
#' }
#'
#' @export
calculate_bill_trends <- function(stats) {
  bill_trends <- stats$bill$terms %>%
    dplyr::left_join(stats$meet$terms, by = "term") %>%
    dplyr::arrange(.data$term) %>%  # 確保按 term 排序
    dplyr::mutate(
      bills_per_meeting = round(.data$count.x / .data$count.y, 2),
      bills_per_day = round(.data$count.x / as.numeric(
        difftime(.data$max_meeting_date,
                 dplyr::lag(.data$max_meeting_date, default = .data$max_meeting_date[1]),
                 units = "days")), 2)
    ) %>%
    dplyr::select(
      .data$term,
      .data$count.x,
      .data$count.y,
      .data$bills_per_meeting,
      .data$bills_per_day
    ) %>%
    dplyr::rename(
      bills = .data$count.x,
      meetings = .data$count.y
    )

  # Print results for immediate feedback
  print("Bill Processing Trends Analysis:")
  print("--------------------------------")
  print(bill_trends)

  return(bill_trends)
}
