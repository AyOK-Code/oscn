SELECT
  court_cases.case_number,
  parties.first_name,
  parties.last_name,
  court_cases.filed_on,
  counts."number" AS count_number,
  counts.as_filed AS count_filed_as,
  counts.offense_on,
  counts.disposition_on,
  verdicts."name",
  (
    SELECT
      COUNT(*)
    FROM
      docket_events
      JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
    WHERE
      court_case_id = court_cases.id
      AND docket_event_types.code IN(
        'WAI$',
        'BWIFAP',
        'BWIFA',
        'BWIFC',
        'BWIAR',
        'BWIAA',
        'BWICA',
        'BWIFAR',
        'BWIFAA',
        'BWIFP',
        'BWIMW',
        'BWIR8',
        'BWIS',
        'BWIS$',
        'WAI',
        'WAIMV',
        'WAIMW'
      )
  ) AS warrants_issued
FROM
  court_cases
  JOIN counties ON court_cases.county_id = counties.id
  JOIN case_types ON court_cases.case_type_id = case_types.id
  JOIN counts ON counts.court_case_id = court_cases.id
  JOIN parties ON counts.party_id = parties.id
  JOIN verdicts ON counts.verdict_id = verdicts.id
  JOIN count_codes ON counts.disposed_statute_code_id = count_codes.id
WHERE
  counties.name = 'Oklahoma'
  AND court_cases.filed_on > '2000-01-01'
  AND court_cases.id IN(
    SELECT
      DISTINCT court_case_id
    FROM
      counts
    WHERE
      charge ILIKE '%domes%'
  )