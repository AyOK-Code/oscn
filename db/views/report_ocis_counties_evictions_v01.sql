SELECT
  count_codes.code,
  court_cases.id AS court_case_id,
  court_cases.county_id AS county_id,
  court_cases.filed_on AS case_filed_on,
  court_cases.closed_on AS case_closed_on,
  court_cases.case_number AS case_number,
  issues.name AS issue_name,
  (
    SELECT
      CASE
        WHEN count(
          CASE
            WHEN issue_parties.disposition_on IS NULL THEN 1
            ELSE NULL :: integer
          END
        ) > 0 THEN NULL :: date
        ELSE max(issue_parties.disposition_on)
      END AS max
    FROM
      issue_parties
    WHERE
      issue_parties.issue_id = issues.id
    GROUP BY
      court_cases.id
  ) AS max_judgement_date,
  (
    SELECT
      CASE
        WHEN count(
          CASE
            WHEN issue_parties.disposition_on IS NULL THEN 1
            ELSE NULL :: integer
          END
        ) > 0 THEN NULL :: integer
        ELSE max(issue_parties.disposition_on) - court_cases.filed_on
      END AS difference
    FROM
      issue_parties
    WHERE
      issue_parties.issue_id = issues.id
    GROUP BY
      court_cases.id
  ) AS days_to_judgement,
  (
    SELECT
      string_agg(parties.full_name :: text, '; ' :: text) AS string_agg
    FROM
      parties
      JOIN case_parties ON case_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      case_parties.court_case_id = court_cases.id
      AND party_types.name :: text = 'defendant' :: text
  ) AS defendant_name,
  (
    SELECT
      count(DISTINCT verdicts.id) AS count
    FROM
      issue_parties
      JOIN verdicts ON verdicts.id = issue_parties.verdict_id
      JOIN parties ON issue_parties.party_id = parties.id
    WHERE
      issue_parties.issue_id = issues.id
  ) AS distinct_verdicts_count,
  (
    SELECT
      string_agg(DISTINCT verdicts.name :: text, ', ' :: text) AS string_agg
    FROM
      issue_parties
      JOIN verdicts ON verdicts.id = issue_parties.verdict_id
      JOIN parties ON issue_parties.party_id = parties.id
    WHERE
      issue_parties.issue_id = issues.id
  ) AS verdict,
  (
    SELECT
      string_agg(
        DISTINCT issue_parties.verdict_details :: text,
        ', ' :: text
      ) AS string_agg
    FROM
      issue_parties
      JOIN verdicts ON verdicts.id = issue_parties.verdict_id
      JOIN parties ON issue_parties.party_id = parties.id
    WHERE
      issue_parties.issue_id = issues.id
  ) AS verdict_details,
  (
    SELECT
      count(DISTINCT parties.id) AS count
    FROM
      parties
      JOIN case_parties ON case_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      case_parties.court_case_id = court_cases.id
      AND party_types.name :: text = 'defendant' :: text
  ) AS defendant_count,
  (
    SELECT
      count(DISTINCT parties.id) AS count
    FROM
      counsels
      JOIN counsel_parties ON counsels.id = counsel_parties.counsel_id
      AND counsel_parties.court_case_id = court_cases.id
      JOIN parties ON counsel_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      party_types.name :: text = 'defendant' :: text
  ) AS defendant_represented_parties_count,
  (
    SELECT
      string_agg(DISTINCT parties.full_name :: text, '; ' :: text) AS string_agg
    FROM
      counsels
      JOIN counsel_parties ON counsels.id = counsel_parties.counsel_id
      AND counsel_parties.court_case_id = court_cases.id
      JOIN parties ON counsel_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      party_types.name :: text = 'defendant' :: text
  ) AS defendant_represented_party,
  (
    SELECT
      count(DISTINCT parties.id) AS count
    FROM
      counsels
      JOIN counsel_parties ON counsels.id = counsel_parties.counsel_id
      AND counsel_parties.court_case_id = court_cases.id
      JOIN parties ON counsel_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      party_types.name :: text = 'plaintiff' :: text
  ) AS plaintiff_represented_parties_count,
  (
    SELECT
      string_agg(DISTINCT parties.full_name :: text, '; ' :: text) AS string_agg
    FROM
      counsels
      JOIN counsel_parties ON counsels.id = counsel_parties.counsel_id
      AND counsel_parties.court_case_id = court_cases.id
      JOIN parties ON counsel_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      party_types.name :: text = 'plaintiff' :: text
  ) AS plaintiff_represented_party,
  (
    SELECT
      DISTINCT parties.full_name
    FROM
      parties
      JOIN case_parties ON case_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      case_parties.court_case_id = court_cases.id
      AND party_types.name :: text = 'plaintiff' :: text
    LIMIT
      1
  ) AS plaintiff_name,
  'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=' || counties.name || '&number=' :: text || court_cases.case_number :: text AS case_link
FROM
  court_cases
  JOIN counties ON court_cases.county_id = counties.id
  JOIN case_types ON court_cases.case_type_id = case_types.id
  JOIN issues ON court_cases.id = issues.court_case_id
  JOIN count_codes ON issues.count_code_id = count_codes.id
WHERE
  case_types.abbreviation = 'SC'
  AND issues.name ILIKE '%FORCIBLE%'