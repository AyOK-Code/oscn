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
  disposition,
  disposition_on,
  counts.disposition_on - court_cases.filed_on AS days_to_judgement,
  COALESCE(verdicts.name, 'none') as verdict
FROM
  counts
  JOIN court_cases ON counts.court_case_id = court_cases.id
  JOIN counties ON court_cases.county_id = counties.id
  JOIN parties ON parties.id = counts.party_id
  LEFT JOIN verdicts ON counts.verdict_id = verdicts.id
WHERE
  counties.name = 'Oklahoma'
  AND(
    as_filed ILIKE '%AFJA%'
    OR as_filed % 'JUVENILE ADJUDICATION'
    OR charge ILIKE '%AFJA%'
    OR charge % 'JUVENILE ADJUDICATION'
  )