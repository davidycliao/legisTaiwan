# Fetch Legislative Yuan Committee Meetings 取得立法院委員會會議資料

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

  - 15: 內政委員會 (Interior Committee)

  - 16: 外交及僑務委員會 (Foreign and Overseas Chinese Affairs
    Committee)

  - 17: 科技及資訊委員會 (Science and Technology Committee)

  - 18: 國防委員會 (Defense Committee)

  - 19: 經濟委員會 (Economics Committee)

  - 20: 財政委員會 (Finance Committee)

  - 21: 預算及決算委員會 (Budget Committee)

  - 22: 教育及文化委員會 (Education and Culture Committee)

  - 23: 交通委員會 (Transportation Committee)

  - 24: 司法委員會 (Judiciary Committee)

  - 25: 法制委員會 (Legal Affairs Committee)

  - 26: 社會福利及衛生環境委員會 (Social Welfare and Environmental
    Hygiene Committee)

  - 27: 程序委員會 (Procedure Committee)

  - 28: 紀律委員會 (Discipline Committee)

  - 29: 修憲委員會 (Constitutional Amendment Committee)

  - 30: 經費稽核委員會 (Expenditure Review Committee)

  - 35: 外交及國防委員會 (Foreign Affairs and Defense Committee)

  - 36: 司法及法制委員會 (Judiciary and Legal Affairs Committee)

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
