# Generate Legislative Yuan Summary Statistics Report

Generates a comprehensive summary report of Legislative Yuan statistics,
including legislator counts, gazette information, and video records
data. Presents the information in a formatted text output.

## Usage

``` r
generate_report(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  legislator

  :   A list containing legislator information:

      total

      :   Total historical number of legislators

      terms

      :   Data frame of legislator counts by term

  gazette

  :   A list containing gazette information:

      total

      :   Total number of gazettes

      agenda_total

      :   Total number of agendas

      last_meeting

      :   Date of the last meeting

  ivod

  :   A list containing video information:

      total

      :   Total number of video records

      date_range

      :   List containing start and end dates of video archives

## Value

A formatted report containing the following sections:

- Bill Statistics:

  Total Bills

  :   Total number of bills

  Last Update

  :   Most recent bill update date

- Legislator Statistics:

  Total Count

  :   Historical total of legislators

  Term Distribution

  :   Legislator counts by term

- Gazette Statistics:

  Total Counts

  :   Numbers of gazettes and agendas

  Latest Activity

  :   Most recent meeting date

- Video Statistics:

  Total Videos

  :   Number of video records

  Coverage Period

  :   Time span of video archives

## See also

- analyze_bills:

  For detailed bill analysis

- analyze_meetings:

  For meeting statistics analysis

- analyze_ivod:

  For video records analysis

## Examples

``` r
if (FALSE) { # \dontrun{
# Generate full statistics report
stats <- get_ly_stat()
generate_report(stats)

# View specific sections
stats <- get_ly_stat()
cat("\nBill Statistics:\n")
cat(sprintf("Total Bills: %d\n", stats$bill$total))

cat("\nLegislator Statistics:\n")
cat(sprintf("Total Legislators: %d\n", stats$legislator$total))
} # }
```
