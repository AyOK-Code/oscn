WITH clean_ocso as (
	SELECT
		id as ocso_id,
		first_name as ocso_first_name,
		last_name as ocso_last_name,
		middle_name as ocso_middle_name,
		birth_date as ocso_birth_date,
		bond_amount as ocso_bond_amount,
		issued as ocso_issued,
		counts as ocso_counts,
		resolved_at as ocso_resolved_at,
		case_number as ocso_case_number,
		-- CLEAN CASE TYPE
		CASE
			WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN SUBSTRING(case_number, 1, 2)
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}' THEN SUBSTRING(
				case_number
				from
					'[A-Za-z]{1,}'
			)
			ELSE NULL
		END AS case_type,
		-- CLEAN CASE YEAR
		CASE
			WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN (
				CASE
					WHEN SUBSTRING(case_number, 3, 2) :: INT <= EXTRACT(
						YEAR
						FROM
							CURRENT_DATE
					) % 100 THEN '20' || SUBSTRING(case_number, 3, 2)
					ELSE '19' || SUBSTRING(case_number, 3, 2)
				END
			) :: INT
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' THEN (
				CASE
					WHEN SPLIT_PART(case_number, '-', 2) :: INT <= EXTRACT(
						YEAR
						FROM
							CURRENT_DATE
					) % 100 THEN '20' || SPLIT_PART(case_number, '-', 2)
					ELSE '19' || SPLIT_PART(case_number, '-', 2)
				END
			) :: INT
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' THEN SPLIT_PART(case_number, '-', 2) :: INT
			ELSE NULL
		END AS full_year,
		-- CASE NUMBER ENDING CF-2020-XXXX
		CASE
			WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN REGEXP_REPLACE(SUBSTRING(case_number, 5), '^0+', '')
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}' THEN SPLIT_PART(case_number, '-', 3)
			ELSE NULL
		END AS last_case_number,
		-- FULL CLEAN CASE NUMBER
		CASE
			WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN (
				SUBSTRING(case_number, 1, 2) || '-' || (
					CASE
						WHEN SUBSTRING(case_number, 3, 2) :: INT <= EXTRACT(
							YEAR
							FROM
								CURRENT_DATE
						) % 100 THEN '20' || SUBSTRING(case_number, 3, 2)
						ELSE '19' || SUBSTRING(case_number, 3, 2)
					END
				) || '-' || REGEXP_REPLACE(SUBSTRING(case_number, 5), '^0+', '')
			)
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' THEN SUBSTRING(case_number, 1, 2) || '-' || (
				CASE
					WHEN SPLIT_PART(case_number, '-', 2) :: INT <= EXTRACT(
						YEAR
						FROM
							CURRENT_DATE
					) % 100 THEN '20' || SPLIT_PART(case_number, '-', 2)
					ELSE '19' || SPLIT_PART(case_number, '-', 2)
				END
			) || '-' || SPLIT_PART(case_number, '-', 3)
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' THEN case_number
			ELSE NULL
		END AS clean_case_number,
		CASE
			WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN 'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number=' || SUBSTRING(case_number, 1, 2) || '-' || SUBSTRING(case_number, 3, 2) || '-' || REGEXP_REPLACE(SUBSTRING(case_number, 5), '^0+', '')
			WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}' THEN 'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number=' || case_number
			ELSE NULL
		END AS link
	FROM
		ocso_warrants
),
added_defendant_counts AS (
	SELECT
		*,
		(
			SELECT
				COUNT(DISTINCT parties.id)
			FROM
				case_parties
				JOIN parties on case_parties.party_id = parties.id
				JOIN court_cases on court_cases.id = case_parties.court_case_id
				JOIN counties on court_cases.county_id = counties.id
				JOIN party_types on parties.party_type_id = party_types.id
			WHERE
				party_types."name" = 'defendant'
				AND court_cases.case_number = clean_case_number
				AND counties."name" = 'Oklahoma'
		) as defendant_count
	FROM
		clean_ocso
	WHERE
		ocso_resolved_at IS NULL
)
SELECT
	*,
	CASE
		--	warrant_count: When the case does not have a defendant
		WHEN defendant_count = 0 THEN NULL --	warrant_count: When the case only has a single defendant
		WHEN defendant_count = 1 THEN (
			SELECT
				COUNT(*)
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN (
					'BWIFP',
					'WAIMW',
					'BWIFAP',
					'BWIFC',
					'BWIR8',
					'BWIAR',
					'BWICA',
					'BWIFA',
					'BWIFAA',
					'BWIS$',
					'BWIFAR',
					'BWIAA',
					'BWIMW',
					'WAI$',
					'WAI',
					'BWIS'
				)
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					SELECT
						COUNT(distinct parties.id)
					FROM
						case_parties
						JOIN parties on case_parties.party_id = parties.id
						JOIN party_types on parties.party_type_id = party_types.id
					WHERE
						party_types."name" = 'defendant'
						AND case_parties.court_case_id = court_cases.id
				) = 1
		) --  warrant_count: When the case has multiple defendants
		WHEN defendant_count > 1 THEN (
			SELECT
				COUNT(*)
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN parties ON docket_events.party_id = parties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN (
					'BWIFP',
					'WAIMW',
					'BWIFAP',
					'BWIFC',
					'BWIR8',
					'BWIAR',
					'BWICA',
					'BWIFA',
					'BWIFAA',
					'BWIS$',
					'BWIFAR',
					'BWIAA',
					'BWIMW',
					'WAI$',
					'WAI',
					'BWIS'
				)
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					levenshtein(
						LOWER(parties.first_name),
						LOWER(ocso_first_name)
					) <= 2
					OR levenshtein(LOWER(parties.last_name), LOWER(ocso_last_name)) <= 2
				)
		)
		ELSE NULL
	END as warrant_count,
	CASE
		--	return_count: When the case does not have a defendant
		WHEN defendant_count = 0 THEN NULL --	return_count: When the case only has a single defendant
		WHEN defendant_count = 1 THEN (
			SELECT
				COUNT(*)
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN ('RETBW', 'RETWA')
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					SELECT
						COUNT(distinct parties.id)
					FROM
						case_parties
						JOIN parties on case_parties.party_id = parties.id
						JOIN party_types on parties.party_type_id = party_types.id
					WHERE
						party_types."name" = 'defendant'
						AND case_parties.court_case_id = court_cases.id
				) = 1
		) --  return_count: When the case has multiple defendants
		WHEN defendant_count > 1 THEN (
			SELECT
				COUNT(*)
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN parties ON docket_events.party_id = parties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN ('RETBW', 'RETWA')
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					levenshtein(
						LOWER(parties.first_name),
						LOWER(ocso_first_name)
					) <= 2
					OR levenshtein(LOWER(parties.last_name), LOWER(ocso_last_name)) <= 2
				)
		)
		ELSE NULL
	END as return_warrant_count,
	CASE
		--	most_recent_type: When the case does not have a defendant
		WHEN defendant_count = 0 THEN NULL --	most_recent_type: When the case only has a single defendant
		WHEN defendant_count = 1 THEN (
			SELECT
				docket_event_types.code
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN (
					'BWIFP',
					'WAIMW',
					'BWIFAP',
					'BWIFC',
					'BWIR8',
					'BWIAR',
					'BWICA',
					'BWIFA',
					'BWIFAA',
					'BWIS$',
					'BWIFAR',
					'BWIAA',
					'BWIMW',
					'WAI$',
					'WAI',
					'BWIS'
				)
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					SELECT
						COUNT(distinct parties.id)
					FROM
						case_parties
						JOIN parties on case_parties.party_id = parties.id
						JOIN party_types on parties.party_type_id = party_types.id
					WHERE
						party_types."name" = 'defendant'
						AND case_parties.court_case_id = court_cases.id
				) = 1
			ORDER BY
				docket_events.event_on desc
			LIMIT
				1
		) --  most_recent_type: When the case has multiple defendants
		WHEN defendant_count > 1 THEN (
			SELECT
				docket_event_types.code
			FROM
				docket_events
				JOIN court_cases ON docket_events.court_case_id = court_cases.id
				JOIN counties ON court_cases.county_id = counties.id
				JOIN parties ON docket_events.party_id = parties.id
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				docket_event_types.code IN (
					'BWIFP',
					'WAIMW',
					'BWIFAP',
					'BWIFC',
					'BWIR8',
					'BWIAR',
					'BWICA',
					'BWIFA',
					'BWIFAA',
					'BWIS$',
					'BWIFAR',
					'BWIAA',
					'BWIMW',
					'WAI$',
					'WAI',
					'BWIS'
				)
				AND counties.name = 'Oklahoma'
				AND court_cases.case_number = clean_case_number
				AND (
					levenshtein(
						LOWER(parties.first_name),
						LOWER(ocso_first_name)
					) <= 2
					OR levenshtein(LOWER(parties.last_name), LOWER(ocso_last_name)) <= 2
				)
			ORDER BY
				docket_events.event_on desc
			LIMIT
				1
		)
		ELSE NULL
	END as most_recent_warrant_type,
	(
		SELECT
			DISTINCT party_addresses.zip
		FROM
			court_cases
			JOIN case_parties ON court_cases.id = case_parties.court_case_id
			JOIN counties ON court_cases.county_id = counties.id
			JOIN parties ON parties.id = case_parties.party_id
			JOIN party_types on parties.party_type_id = party_types.id
			JOIN party_addresses ON parties.id = party_addresses.party_id
		WHERE
			status = 'Current'
			AND counties.name = 'Oklahoma'
			AND party_types."name" = 'defendant'
			AND court_cases.case_number = clean_case_number
			AND party_addresses.zip != 0
			AND (
				levenshtein(
					LOWER(parties.first_name),
					LOWER(ocso_first_name)
				) <= 2
				OR levenshtein(LOWER(parties.last_name), LOWER(ocso_last_name)) <= 2
			)
		LIMIT
			1
	) as defendant_zip_codes,
	(
		SELECT
			case_htmls.scraped_at
		FROM
			court_cases
			JOIN counties ON court_cases.county_id = counties.id
			JOIN case_htmls on case_htmls.court_case_id = court_cases.id
		WHERE
			court_cases.case_number = clean_case_number
			and counties.name = 'Oklahoma'
		LIMIT
			1
	) as scraped_at
FROM
	added_defendant_counts