# Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and Codes 取得立法院委員會類別及職權範圍代碼

Retrieves detailed information about Legislative Yuan committees,
including their jurisdictions, responsibilities and assigned codes. This
function provides comprehensive access to committee structural data and
organizational details of Taiwan's Legislative Yuan.

## Usage

``` r
get_ly_committees_type(
  page = 1,
  per_page = 20,
  type = NULL,
  code = NULL,
  show_progress = TRUE
)
```

## Arguments

- page:

  integer. Page number for pagination (default: 1)

- per_page:

  integer. Number of items per page (default: 20)

- type:

  string. Committee type:

  - "常設委員會" (Standing Committee)

  - "特種委員會" (Special Committee)

  - "國會改革前舊委員會名稱" (Former Committee Names before Reform)

- code:

  integer. Committee code number

- show_progress:

  logical. Whether to display progress bar (default: TRUE)

## Value

A list containing:

- metadata - List of pagination info and applied filters, including:

  - total_records: Total number of committee records

  - current_page: Current page number

  - total_pages: Total number of pages

  - per_page: Number of records per page

- committees - Data frame of committee details including:

  - code: Committee identification number

  - name: Committee name in Chinese

  - type: Category of committee

  - duties: Committee responsibilities and jurisdiction

  - term_start: Starting legislative term of the committee

  - term_end: Ending legislative term of the committee (if applicable)

## Details

This function fetches comprehensive committee information from the
Legislative Yuan API, providing committee codes, names, duties,
jurisdictions and organizational structure. The committees are
categorized into three main types:

- Standing Committees (常設委員會): Permanent committees handling
  specific policy areas

- Special Committees (特種委員會): Committees formed for specific
  purposes or tasks

- Former Committee Names (國會改革前舊委員會名稱): Historical committee
  designations

Committee codes and their corresponding names:

- 15: 內政委員會 (Interior Affairs Committee)

- 16: 外交及僑務委員會 (Foreign and Overseas Chinese Affairs Committee)

- 17: 科技及資訊委員會 (Science and Technology Committee)

- 18: 國防委員會 (National Defense Committee)

- 19: 經濟委員會 (Economic Affairs Committee)

- 20: 財政委員會 (Finance Committee)

- 21: 預算及決算委員會 (Budget and Final Accounts Committee)

- 22: 教育及文化委員會 (Education and Culture Committee)

- 23: 交通委員會 (Transportation Committee)

- 24: 司法委員會 (Judiciary Committee)

- 25: 法制委員會 (Legal Affairs Committee)

- 26: 社會福利及衛生環境委員會 (Social Welfare and Environmental Hygiene
  Committee)

- 27: 程序委員會 (Procedure Committee)

- 28: 紀律委員會 (Discipline Committee)

- 29: 修憲委員會 (Constitutional Amendment Committee)

- 30: 經費稽核委員會 (Expenditure Review Committee)

- 35: 外交及國防委員會 (Foreign Affairs and National Defense Committee)

- 36: 司法及法制委員會 (Judiciary and Legal Affairs Committee)

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch all standing committees
committees <- fetch_ly_committees(type = "常設委員會")

# Get details for a specific committee by code
interior_committee <- fetch_ly_committees(code = 15)

# Fetch multiple pages of committee data
all_committees <- fetch_ly_committees(page = 1, per_page = 50)
} # }
```
