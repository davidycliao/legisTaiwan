# Fetch Legislative Yuan Committee Meetings

Retrieves and processes committee meeting information from the
Legislative Yuan API. This function allows you to fetch detailed
information about committee meetings including attendance, bills
discussed, and meeting details.

## Usage

``` r
get_ly_committee_meets(
  committee_id,
  page = 1,
  per_page = 20,
  term = NULL,
  session = NULL,
  meeting_code = NULL,
  meeting_type = NULL,
  attending_member = NULL,
  date = NULL,
  meeting_number = NULL,
  bill_id = NULL,
  show_progress = TRUE
)
```

## Arguments

- committee_id:

  integer. Required. The ID of the committee. Available values:

  - 15: Interior Committee

  - 16: Foreign and Overseas Chinese Affairs Committee

  - 17: Science and Technology Committee

  - 18: Defense Committee

  - 19: Economics Committee

  - 20: Finance Committee

  - 21: Budget Committee

  - 22: Education and Culture Committee

  - 23: Transportation Committee

  - 24: Judiciary Committee

  - 25: Legal Affairs Committee

  - 26: Social Welfare and Environmental Hygiene Committee

  - 27: Procedure Committee

  - 28: Discipline Committee

  - 29: Constitutional Amendment Committee

  - 30: Expenditure Review Committee

  - 35: Foreign Affairs and Defense Committee

  - 36: Judiciary and Legal Affairs Committee

- page:

  integer. Page number for pagination (default: 1)

- per_page:

  integer. Number of items per page (default: 20)

- term:

  integer. Legislative term number

- session:

  integer. Session number

- meeting_code:

  string. Meeting code

- meeting_type:

  string. Type of meeting

- attending_member:

  string. Name of attending member

- date:

  string. Meeting date in YYYY-MM-DD format

- meeting_number:

  string. Meeting number

- bill_id:

  string. Bill ID

- show_progress:

  logical. Whether to display progress bar (default: TRUE)

## Value

A list containing two elements:

- metadata: List containing pagination information and request status

- data: Data frame containing meeting information with columns including
  meeting date, type, attending members, and discussed bills

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch meetings from the Interior Committee
meetings <- get_ly_committee_meets(committee_id = 15)

# Fetch meetings with specific filters
meetings <- get_ly_committee_meets(
  committee_id = 16,
  term = 10,
  session = 1,
  date = "2024-01-01"
)
} # }
```
