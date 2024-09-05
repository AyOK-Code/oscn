WITH view_data AS (
  SELECT
    court_cases.id AS court_case_id,
    court_cases.filed_on AS case_filed_on,
    court_cases.closed_on AS case_closed_on,
    (
      SELECT
        eviction_letters.eviction_file_id
      FROM
        eviction_letters
        JOIN docket_event_links ON docket_event_links.id = eviction_letters.docket_event_link_id
        JOIN docket_events ON docket_event_links.docket_event_id = docket_events.id
      WHERE
        court_case_id = court_cases.id
      LIMIT
        1
    ) as eviction_file_id,
    court_cases.case_number,
    counts.disposition_on AS judgement_date,
    counts.disposition_on - court_cases.filed_on AS days_to_judgement,
    (
      SELECT
        parties.full_name
      FROM
        parties
      where
        id = counts.party_id
    ) as defendant_name,
    verdicts."name" AS verdict,
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
    'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number=' :: text || court_cases.case_number :: text AS case_link
  FROM
    court_cases
    JOIN counties ON court_cases.county_id = counties.id
    JOIN case_types ON court_cases.case_type_id = case_types.id
    LEFT JOIN counts on counts.court_case_id = court_cases.id
    LEFT JOIN verdicts ON verdicts.id = counts.verdict_id
  WHERE
    counties.name :: text = 'Oklahoma' :: text
    AND court_cases.is_error IS FALSE
    AND (
      (
        as_filed ILIKE '%FIREARM%'
        AND as_filed ILIKE '%Juvenile%'
      )
      OR(
        as_filed ILIKE '%Minor%'
        AND as_filed ILIKE '%Firearm%'
      )
    )
)
SELECT
  view_data.court_case_id,
  view_data.case_filed_on,
  view_data.case_closed_on,
  view_data.case_number,
  view_data.judgement_date,
  view_data.days_to_judgement,
  view_data.defendant_name,
  view_data.verdict,
  view_data.defendant_count,
  view_data.defendant_represented_parties_count,
  view_data.defendant_represented_party,
  view_data.plaintiff_name,
  view_data.case_link,
  CASE
    WHEN view_data.verdict ~ 'juvenile' :: text THEN 'Juvenile' :: text
    WHEN view_data.verdict ~ 'default judgement' :: text THEN 'Default Judgement' :: text
    WHEN view_data.verdict ~ 'judgement' :: text THEN 'Judgement' :: text
    WHEN (
      view_data.verdict = ANY (
        ARRAY ['final order'::text, 'final judgment'::text]
      )
    )
    OR view_data.verdict ~ 'rights of majority' :: text THEN 'Judgement' :: text
    WHEN view_data.verdict ~ 'deferred' :: text THEN 'Deferred' :: text
    WHEN view_data.verdict ~ 'consolidated' :: text
    OR view_data.verdict ~ 'transferred' :: text THEN 'Transferred' :: text
    WHEN view_data.verdict ~ 'bankruptcy' :: text THEN 'Bankruptcy Filed' :: text
    WHEN view_data.verdict ~ 'dismissed' :: text
    AND view_data.verdict ~ 'satisfied' :: text THEN 'Dismissed - Satisfied' :: text
    WHEN view_data.verdict ~ 'settled' :: text
    OR view_data.verdict ~ 'settlement' :: text THEN 'Dismissed - Settlement' :: text
    WHEN view_data.verdict ~ 'dismissed' :: text
    OR view_data.verdict ~ 'vacated' :: text THEN 'Dismissed' :: text
    WHEN view_data.verdict = 'discharge filed' :: text THEN 'Dismissed' :: text
    WHEN view_data.case_closed_on IS NULL THEN 'Active Case' :: text
    ELSE 'Other' :: text
  END AS simple_judgement
FROM
  view_data;