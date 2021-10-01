SELECT
  parties.id AS party_id,(
    SELECT
      COUNT(*)
    FROM
      case_parties
    WHERE
      party_id = parties.id
  ) AS cases_count,
  (
    SELECT
      COUNT(*)
    FROM
      case_parties
      JOIN court_cases ON case_parties.court_case_id = court_cases.id
      JOIN case_types ON case_types.id = court_cases.case_type_id
    WHERE
      party_id = parties.id
      AND case_types.abbreviation = 'CF'
  ) AS cf_count,
  (
    SELECT
      COUNT(*)
    FROM
      case_parties
      JOIN court_cases ON case_parties.court_case_id = court_cases.id
      JOIN case_types ON case_types.id = court_cases.case_type_id
    WHERE
      party_id = parties.id
      AND case_types.abbreviation = 'CM'
  ) AS cm_count,
  (
    SELECT
      COUNT(*)
    FROM
      docket_events
      JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
    WHERE
      docket_events.party_id = parties.id
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
  ) AS warrants_count,
  (
    SELECT
      SUM(amount)
    FROM
      docket_events
    WHERE
      docket_events.party_id = parties.id
  ) AS total_fined,
  (
    SELECT
      SUM(payment)
    FROM
      docket_events
    WHERE
      docket_events.party_id = parties.id
  ) AS total_paid,
  (
    SELECT
      SUM(adjustment)
    FROM
      docket_events
    WHERE
      docket_events.party_id = parties.id
  ) AS total_adjusted,
  (
    (
      SELECT
        SUM(amount)
      FROM
        docket_events
      WHERE
        docket_events.party_id = parties.id
    ) - (
      SELECT
        SUM(payment)
      FROM
        docket_events
      WHERE
        docket_events.party_id = parties.id
    ) - (
      SELECT
        SUM(adjustment)
      FROM
        docket_events
      WHERE
        docket_events.party_id = parties.id
    )
  ) AS account_balance
FROM
  parties
  JOIN party_types on parties.party_type_id = party_types.id
WHERE
  party_types.name = 'defendant'
