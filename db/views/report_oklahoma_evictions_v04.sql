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
        DISTINCT CASE
          verdicts.name
          WHEN 'bankruptcy filed' THEN 'Bankruptcy Filed'
          WHEN 'closed juvenile age 18' THEN 'Juvenile'
          WHEN 'closed juvenile age 18, dismissed' THEN 'Juvenile'
          WHEN 'consolidated' THEN 'Transferred'
          WHEN 'consolidated, transferred to another jurisdiction' THEN 'Transferred'
          WHEN 'default judgement' THEN 'Default Judgment'
          WHEN 'default judgement, deferred deprived/neglected' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed - contested' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed - release and satisfied' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed - settled' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed - voluntary dismissal' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed - with prejudice' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed without prejudice' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed, judgement entered' THEN 'Default Judgment'
          WHEN 'default judgement, dismissed, judgement for plaintiff' THEN 'Default Judgment'
          WHEN 'default judgement, final judgment' THEN 'Default Judgment'
          WHEN 'default judgement, judgement entered' THEN 'Default Judgment'
          WHEN 'default judgement, judgement for defendant' THEN 'Default Judgment'
          WHEN 'default judgement, judgement for plaintiff' THEN 'Default Judgment'
          WHEN 'default judgement, other' THEN 'Default Judgment'
          WHEN 'default judgement, summary judgement entered' THEN 'Default Judgment'
          WHEN 'default judgement, vacated (order or judgment)' THEN 'Default Judgment'
          WHEN 'deferred' THEN 'Deferred'
          WHEN 'deferred deprived/neglected' THEN 'Deferred'
          WHEN 'deferred deprived/neglected, dismissed' THEN 'Deferred'
          WHEN 'deferred in need of supervision, dismissed' THEN 'Deferred'
          WHEN 'deferred in need of treatment' THEN 'Deferred'
          WHEN 'discharge filed' THEN 'Dismissed'
          WHEN 'discharge filed, dismissed' THEN 'Dismissed'
          WHEN 'discharge filed, dismissed without prejudice' THEN 'Dismissed'
          WHEN 'dismissed' THEN 'Dismissed'
          WHEN 'dismissed - contested' THEN 'Dismissed'
          WHEN 'dismissed - contested, judgement entered' THEN 'Judgment'
          WHEN 'dismissed - court order' THEN 'Dismissed'
          WHEN 'dismissed - demurrer sustained' THEN 'Dismissed'
          WHEN 'dismissed - demurrer sustained, dismissed - failure to obtain service' THEN 'Dismissed'
          WHEN 'dismissed - failure to obtain service' THEN 'Dismissed'
          WHEN 'dismissed - hold all case actions' THEN 'Dismissed'
          WHEN 'dismissed - lack of service' THEN 'Dismissed'
          WHEN 'dismissed - lack of service, dismissed - with prejudice' THEN 'Dismissed'
          WHEN 'dismissed - quash sustained' THEN 'Dismissed'
          WHEN 'dismissed - release and satisfied' THEN 'Dismissed - Satisfied'
          WHEN 'dismissed - release and satisfied, judgement for plaintiff' THEN 'Dismissed - Satisfied'
          WHEN 'dismissed - settled' THEN 'Dismissed - Settlement'
          WHEN 'dismissed - settled, dismissed - with prejudice' THEN 'Dismissed - Settlement'
          WHEN 'dismissed - voluntary dismissal' THEN 'Dismissed'
          WHEN 'dismissed - with prejudice' THEN 'Dismissed'
          WHEN 'dismissed - with prejudice, judgement entered' THEN 'Judgment'
          WHEN 'dismissed - with prejudice, judgement for plaintiff' THEN 'Judgment'
          WHEN 'dismissed - with prejudice, vacated (order or judgment)' THEN 'Dismissed'
          WHEN 'dismissed without prejudice' THEN 'Dismissed'
          WHEN 'dismissed without prejudice, dismissed - with prejudice' THEN 'Dismissed'
          WHEN 'dismissed without prejudice, judgement entered' THEN 'Judgment'
          WHEN 'dismissed without prejudice, judgement for plaintiff' THEN 'Judgment'
          WHEN 'dismissed without prejudice, order approving settlement' THEN 'Dismissed - Settlement'
          WHEN 'dismissed without prejudice, paternity established (decree or order)' THEN 'Dismissed'
          WHEN 'dismissed, dismissed - release and satisfied' THEN 'Dismissed - Satisfied'
          WHEN 'dismissed, dismissed - settled' THEN 'Dismissed - Settlement'
          WHEN 'dismissed, dismissed - with prejudice' THEN 'Dismissed'
          WHEN 'dismissed, dismissed without prejudice' THEN 'Dismissed'
          WHEN 'dismissed, final judgment' THEN 'Judgment'
          WHEN 'dismissed, judgement entered' THEN 'Judgment'
          WHEN 'dismissed, judgement for defendant' THEN 'Judgment'
          WHEN 'dismissed, judgement for plaintiff' THEN 'Judgment'
          WHEN 'dismissed, name change (order or other)' THEN 'Dismissed'
          WHEN 'dismissed, other' THEN 'Dismissed'
          WHEN 'dismissed, vacated (order or judgment)' THEN 'Dismissed'
          WHEN 'final judgment' THEN 'Judgment'
          WHEN 'final order' THEN 'Judgment'
          WHEN 'judgement entered' THEN 'Judgment'
          WHEN 'judgement entered, judgement for defendant' THEN 'Judgment'
          WHEN 'judgement entered, judgement for plaintiff' THEN 'Judgment'
          WHEN 'judgement entered, other' THEN 'Judgment'
          WHEN 'judgement entered, vacated (order or judgment)' THEN 'Judgment'
          WHEN 'judgement for defendant' THEN 'Judgment'
          WHEN 'judgement for defendant, judgement for plaintiff' THEN 'Judgment'
          WHEN 'judgement for plaintiff' THEN 'Judgment'
          WHEN 'judgement for plaintiff, judgement in rem' THEN 'Judgment'
          WHEN 'judgement for plaintiff, paternity established (decree or order)' THEN 'Judgment'
          WHEN 'judgement for plaintiff, transferred to another jurisdiction' THEN 'Judgment'
          WHEN 'judgement for plaintiff, vacated (order or judgment)' THEN 'Judgment'
          WHEN 'judgement on pleading' THEN 'Judgment'
          WHEN 'letters filed' THEN 'Other'
          WHEN 'name change (order or other)' THEN 'Other'
          WHEN 'order approving settlement' THEN 'Judgment'
          WHEN 'other' THEN 'Other'
          WHEN 'paternity established (decree or order)' THEN 'Other'
          WHEN 'protective order denied' THEN 'Other'
          WHEN 'rights of majority granted (order or other)' THEN 'Judgment'
          WHEN 'stayed pending action other jurisdiction' THEN 'Other'
          WHEN 'summary judgement entered' THEN 'Judgment'
          WHEN 'transferred to another jurisdiction' THEN 'Transferred'
          WHEN 'transferred to federal court' THEN 'Transferred'
          WHEN 'vacated (order or judgment)' THEN 'Dismissed'
          ELSE 'Unknown' -- Default value if no match is found
        END :: text,
        ', ' :: text
      ) AS string_agg
    FROM
      issue_parties
      JOIN verdicts ON verdicts.id = issue_parties.verdict_id
      JOIN parties ON issue_parties.party_id = parties.id
    WHERE
      issue_parties.issue_id = issues.id
  ) AS simple_judgement,
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
ORDER BY
  case_filed_on ASC