# Package index

## API V1 - Basic Data

Basic data retrieval functions from old Legislative Yuan API

- [`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.md)
  : The Records of the Bills: 法律提案
- [`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.md)
  : The Records of Legislation and the Executives Proposals:
  委員及政府議案提案資訊
- [`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_meetings.md)
  : The Spoken Meeting Records 委員發言
- [`get_committee_record()`](https://davidycliao.github.io/legisTaiwan/reference/get_committee_record.md)
  : The Records of Reviewed Items in the Committees
  委員會會議審查之議案項目
- [`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.md)
  : The Legislator' Demographic Information and Background
  提供委員基本資料

## API V1 - Parliamentary Activities

Functions for parliamentary activities from old API

- [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.md)
  : The Records of Parliamentary Questions 委員質詢事項資訊
- [`get_caucus_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_caucus_meetings.md)
  : The Meeting Records of Cross-caucus Session 黨團協商資訊
- [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.md)
  : The Records of Response to the Questions by the Executives
  公報質詢事項行政院答復資訊
- [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.md)
  : The Records of National Public Debates 國是論壇
- [`get_speech_video()`](https://davidycliao.github.io/legisTaiwan/reference/get_speech_video.md)
  : The Video Information of Meetings and Committees
  院會及委員會之委員發言片段相關影片資訊

## API V2 - Bills and Committees

New API functions for bills and committee information

- [`get_ly_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_bills.md)
  : Fetch and Parse Legislative Yuan Bills 取得並解析立法院議案資料
- [`get_ly_committee_meets()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_committee_meets.md)
  : Fetch Legislative Yuan Committee Meetings 取得立法院委員會會議資料
- [`get_ly_committees_type()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_committees_type.md)
  : Fetch and Parse Legislative Yuan Committee Details, Jurisdiction and
  Codes 取得立法院委員會類別及職權範圍代碼
- [`get_ly_interpellations()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_interpellations.md)
  : Get Legislative Yuan Interpellation Records 取得立法院質詢紀錄
- [`get_ly_ivod()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_ivod.md)
  : Fetch Legislative Yuan IVOD (Video) Records
  取得立法院議事轉播影片資料

## API V2 - Legislator Information

New API functions for legislator-specific data

- [`get_ly_legislator_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_bills.md)
  : Get Bill by legislator 取得立法委員提案資料
- [`get_ly_legislator_cosign_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_cosign_bills.md)
  : Fetch Bills Cosigned by a Legislator 取得立法委員連署法案
- [`get_ly_legislators_by_term()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislators_by_term.md)
  : Fetch Legislators List for a Specific Term 依屆期取得立法委員名單
- [`get_ly_legislator_detail()`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_detail.md)
  : Fetch Legislator Detail Information
- [`get_tly_stat()`](https://davidycliao.github.io/legisTaiwan/reference/get_tly_stat.md)
  : Fetch and Parse Legislative Yuan Statistics 取得並解析立法院統計資料

## Analysis Tools

Functions for data analysis and reporting

- [`analyze_bills()`](https://davidycliao.github.io/legisTaiwan/reference/analyze_bills.md)
  : Analyze Legislative Bills Statistics
- [`analyze_ivod()`](https://davidycliao.github.io/legisTaiwan/reference/analyze_ivod.md)
  : Analyze Legislative Video (IVOD) Statistics
- [`analyze_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/analyze_meetings.md)
  : Analyze Legislative Meeting Statistics
- [`generate_report()`](https://davidycliao.github.io/legisTaiwan/reference/generate_report.md)
  : Generate Legislative Yuan Summary Statistics Report
- [`calculate_bill_trends()`](https://davidycliao.github.io/legisTaiwan/reference/calculate_bill_trends.md)
  : Calculate Legislative Bill Trends and Metrics
- [`bill_to_network()`](https://davidycliao.github.io/legisTaiwan/reference/bill_to_network.md)
  : Convert Bill Data to Network Graph

## Utility and Data

Helper functions and datasets

- [`get_variable_info()`](https://davidycliao.github.io/legisTaiwan/reference/get_variable_info.md)
  : Check Each Function's Manual 檢查各函式說明文件
- [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  : Check Session Periods in Each Year (Minguo Calendar) 檢查每年會期
  (民國曆)
- [`legis_keywords`](https://davidycliao.github.io/legisTaiwan/reference/legis_keywords.md)
  : Legislative Keywords for Text Analysis
