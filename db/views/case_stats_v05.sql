SELECT
  court_cases.id as court_case_id,
  (closed_on - filed_on) AS length_of_case_in_days,
  (
    SELECT
      COUNT(*)
    FROM
      counts
    WHERE
      court_cases.id = counts.court_case_id
  ) AS counts_count,
  (
    SELECT
      COUNT(*)
    FROM
      case_parties
      JOIN parties ON case_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      court_cases.id = case_parties.court_case_id
      AND party_types.name = 'defendant'
  ) AS defendant_count,
  (
    CASE
      WHEN (
        SELECT
          COUNT(*)
        FROM
          docket_events
        JOIN
          docket_event_types on docket_events.docket_event_type_id = docket_event_types.id
        WHERE
          docket_events.court_case_id = court_cases.id
        AND docket_event_types.code = 'CTRS'
      ) > 0 THEN TRUE
      ELSE FALSE
    END
  ) AS is_tax_intercepted,
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
        'WAIMW',
        'BWIFAR'
      )
  ) AS warrants_count
FROM
  court_cases
