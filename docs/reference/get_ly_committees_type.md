# Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and Codes

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

  string. Committee type. The API expects the Chinese-language category
  name, e.g.:

  - Standing Committee

  - Special Committee

  - Former Committee Names before Reform

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

- Standing Committees: Permanent committees handling specific policy
  areas

- Special Committees: Committees formed for specific purposes or tasks

- Former Committee Names: Historical committee designations (used before
  Congressional reform)

Committee codes and their corresponding names:

- 15: Interior Affairs Committee

- 16: Foreign and Overseas Chinese Affairs Committee

- 17: Science and Technology Committee

- 18: National Defense Committee

- 19: Economic Affairs Committee

- 20: Finance Committee

- 21: Budget and Final Accounts Committee

- 22: Education and Culture Committee

- 23: Transportation Committee

- 24: Judiciary Committee

- 25: Legal Affairs Committee

- 26: Social Welfare and Environmental Hygiene Committee

- 27: Procedure Committee

- 28: Discipline Committee

- 29: Constitutional Amendment Committee

- 30: Expenditure Review Committee

- 35: Foreign Affairs and National Defense Committee

- 36: Judiciary and Legal Affairs Committee

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch all standing committees
committees <- fetch_ly_committees(type = "Standing Committee")  # in Chinese

# Get details for a specific committee by code
interior_committee <- fetch_ly_committees(code = 15)

# Fetch multiple pages of committee data
all_committees <- fetch_ly_committees(page = 1, per_page = 50)
} # }
```
