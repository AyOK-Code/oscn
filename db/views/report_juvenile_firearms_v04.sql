SELECT
  court_cases.id AS court_case_id,
  court_cases.case_number,
  court_cases.filed_on,
  court_cases.closed_on,
  'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number=' :: text || court_cases.case_number :: text AS case_link,
  parties.id AS party_id,
  parties.full_name,
  counts.offense_on,
  counts.as_filed,
  counts.charge as as_disposed,
  counts.disposition,
  counts.disposition_on,
  counts.disposition_on - court_cases.filed_on AS days_to_judgement,
  COALESCE(verdicts.name, 'none' :: character varying) AS verdict
FROM
  counts
  JOIN court_cases ON counts.court_case_id = court_cases.id
  JOIN counties ON court_cases.county_id = counties.id
  JOIN parties ON parties.id = counts.party_id
  LEFT JOIN verdicts ON counts.verdict_id = verdicts.id
WHERE
  counties.name :: text = 'Oklahoma' :: text
  AND (
    counts.as_filed :: text ~~* '%AFJA%' :: text
    OR counts.as_filed :: text % 'JUVENILE ADJUDICATION' :: text
    OR counts.charge :: text ~~* '%AFJA%' :: text
    OR counts.charge :: text % 'JUVENILE ADJUDICATION' :: text
    OR counts.as_filed % 'YOUTHFUL OFFENDER ADJUDICATION' :: text
    OR counts.charge % 'YOUTHFUL OFFENDER ADJUDICATION' :: text
    OR counts.as_filed % 'YOUTHFUL ADJUDICATION' :: text
    OR counts.charge % 'YOUTHFUL ADJUDICATION' :: text
)