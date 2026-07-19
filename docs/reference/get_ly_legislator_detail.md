# Fetch Legislator Detail Information

Retrieves detailed information for a specific legislator by term and
name from the Legislative Yuan API.

## Usage

``` r
get_ly_legislator_detail(term, name, show_progress = TRUE)
```

## Arguments

- term:

  required integer. Legislative term number (e.g. 9)

- name:

  required string. Legislator name (e.g. "王金平")

- show_progress:

  logical. Whether to display progress info (default: TRUE)

## Value

A list containing legislator details:

- term:

  Legislative term number

- name:

  Legislator's name in Chinese

- ename:

  Legislator's name in English

- sex:

  Gender

- party:

  Political party affiliation

- partyGroup:

  Legislative party group

- areaName:

  Represented area

- committee:

  Committee assignments by session

- onboardDate:

  Date took office

- degree:

  Education background

- experience:

  Work experience

- picUrl:

  URL of legislator's photo

- leaveFlag:

  Whether has left office

- leaveDate:

  Date left office if applicable

- leaveReason:

  Reason for leaving if applicable

- bioId:

  Biography ID

## Details

Get Legislative Yuan Legislator Detail 取得立法委員完整歷史資料

## Examples

``` r
if (FALSE) { # \dontrun{
# Get legislator detail
detail <- get_ly_legislator_detail(
  term = 9,
  name = "王金平"
)

# Print basic info
cat(sprintf(
  "Name: %s (%s)\nParty: %s\nArea: %s\n",
  detail$name,
  detail$ename,
  detail$party,
  detail$areaName
))
} # }
```
