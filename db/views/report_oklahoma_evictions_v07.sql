WITH view_data as (
  SELECT
    court_cases.id AS court_case_id,
    court_cases.filed_on AS case_filed_on,
    court_cases.closed_on AS case_closed_on,
    court_cases.case_number,
    (
      SELECT
        CASE
          WHEN COUNT(
            CASE
              WHEN issue_parties.disposition_on IS NULL THEN 1
            END
          ) > 0 THEN NULL
          ELSE MAX(issue_parties.disposition_on)
        END
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
          WHEN COUNT(
            CASE
              WHEN issue_parties.disposition_on IS NULL THEN 1
            END
          ) > 0 THEN NULL
          ELSE MAX(issue_parties.disposition_on) - court_cases.filed_on
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
        string_agg(
          DISTINCT verdicts.name :: text,
          ', ' :: text
        ) AS string_agg
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
        string_agg(
          DISTINCT parties.full_name :: text,
          '; ' :: text
        ) AS string_agg
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
        string_agg(
          DISTINCT parties.full_name :: text,
          '; ' :: text
        ) AS string_agg
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
    'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number=' :: text || court_cases.case_number :: text AS case_link,
    (
      SELECT
        translate(
          translate(
            (
              regexp_matches(
                de.description,
                '\$\s{0,2}[0-9]{1,3}(?:,?[0-9]{3})*\.?[0-9]{0,2}' :: text
              )
            ) [1],
            ',' :: text,
            '' :: text
          ),
          '$' :: text,
          '' :: text
        ) :: numeric AS money
      FROM
        docket_events de
        JOIN docket_event_types docket_event_types_1 ON de.docket_event_type_id = docket_event_types_1.id
      WHERE
        docket_event_types_1.code :: text = 'P' :: text
        AND de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS rent_owed,
    (
      SELECT
        de.description ~~ '%POS%' :: text AS money
      FROM
        docket_events de
        JOIN docket_event_types docket_event_types_1 ON de.docket_event_type_id = docket_event_types_1.id
      WHERE
        docket_event_types_1.code :: text = 'P' :: text
        AND de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS possession,
    (
      SELECT
        ocr_plaintiff_address
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS ocr_plaintiff_address,
    (
      SELECT
        validation_usps_address
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS validated_address,
    (
      SELECT
        validation_usps_state_zip
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS valdated_state_zip,
    (
      SELECT
        validation_city
      FROM
        eviction_letters el
        JOIN docket_event_links del on el.docket_event_link_id = del.id
        JOIN docket_events de on del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS validation_city,
    (
      SELECT
        validation_zip_code
      FROM
        eviction_letters el
        JOIN docket_event_links del on el.docket_event_link_id = del.id
        JOIN docket_events de on del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS validation_zip_code,
    (
      SELECT
        validation_state
      FROM
        eviction_letters el
        JOIN docket_event_links del on el.docket_event_link_id = del.id
        JOIN docket_events de on del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS validation_state,
    (
      SELECT
        validation_latitude
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS valdated_latitude,
    (
      SELECT
        validation_longitude
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS validation_longitude,
    (
      SELECT
        status
      FROM
        eviction_letters el
        JOIN docket_event_links del ON el.docket_event_link_id = del.id
        JOIN docket_events de ON del.docket_event_id = de.id
      WHERE
        de.court_case_id = court_cases.id
      LIMIT
        1
    ) AS letter_status
  FROM
    court_cases
    JOIN counties ON court_cases.county_id = counties.id
    JOIN case_types ON court_cases.case_type_id = case_types.id
    JOIN issues ON court_cases.id = issues.court_case_id
    JOIN count_codes ON issues.count_code_id = count_codes.id
  WHERE
    (
      count_codes.code :: text = ANY (
        ARRAY ['SCFED1'::text, 'SCFED2'::text, 'FED1'::text, 'FED2'::text, 'ENTRY'::text]
      )
    )
    AND counties.name :: text = 'Oklahoma' :: text
    AND court_cases.is_error IS FALSE
)
SELECT
  *,
  (
    CASE
      WHEN verdict ~ 'juvenile' THEN 'Juvenile'
      WHEN verdict ~ 'default judgement' THEN 'Default Judgement'
      WHEN (verdict ~ 'judgement') THEN 'Judgement'
      WHEN verdict IN ('final order', 'final judgment')
      OR verdict ~ 'rights of majority' THEN 'Judgement'
      WHEN verdict ~ 'deferred' THEN 'Deferred'
      WHEN verdict ~ 'consolidated'
      OR verdict ~ 'transferred' THEN 'Transferred'
      WHEN verdict ~ 'bankruptcy' THEN 'Bankruptcy Filed'
      WHEN (
        verdict ~ 'dismissed'
        AND verdict ~ 'satisfied'
      ) THEN 'Dismissed - Satisfied'
      WHEN (
        verdict ~ 'settled'
        OR verdict ~ 'settlement'
      ) THEN 'Dismissed - Settlement'
      WHEN verdict ~ 'dismissed'
      OR verdict ~ 'vacated' THEN 'Dismissed'
      WHEN verdict = 'discharge filed' THEN 'Dismissed'
      ELSE 'Other' -- Default value if no match is found
    END
  ) :: text as simple_judgement
FROM
  view_data