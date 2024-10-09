SELECT
  counts.id AS count_id,
  counts.offense_on as count_offense_on,
  counts.as_filed as count_as_filed,
  filed_code.code as count_code_as_filed,
  counts.filed_statute_violation as statute,
  counts.disposition as count_as_disposed,
  disposed_code.code as count_code_as_disposed,
  counts.disposition_on as count_disposition_on,
  pleas.name as plea,
  verdicts.name as verdict,
  court_cases.id AS court_case_id,
  court_cases.county_id AS county_id,
  court_cases.case_type_id AS case_type_id,
  court_cases.case_number AS court_case_case_number,
  court_cases.filed_on AS court_case_filed_on,
  court_cases.closed_on AS court_case_closed_on
FROM
  counts
  JOIN court_cases ON counts.court_case_id = court_cases.id
  JOIN case_types ON court_cases.case_type_id = case_types.id
  LEFT JOIN pleas ON counts.plea_id = pleas.id
  LEFT JOIN verdicts ON counts.verdict_id = verdicts.id
  LEFT JOIN count_codes filed_code ON counts.filed_statute_code_id = filed_code.id
  LEFT JOIN count_codes disposed_code ON counts.disposed_statute_code_id = disposed_code.id
WHERE
  case_types.abbreviation IN('CF', 'CM', 'MI', 'CPC')