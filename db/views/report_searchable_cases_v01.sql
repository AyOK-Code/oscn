SELECT
	court_cases.case_number,
	court_cases.filed_on,
	parties.full_name,
	parties.first_name,
	parties.last_name,
	parties.birth_month,
	parties.birth_year,
	counts.offense_on AS date_of_offense,
	counts.as_filed AS count_as_filed,
	counts.charge AS count_as_disposed,
	(
		CASE WHEN (
			SELECT
				COUNT(*)
			FROM
				docket_events
				JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
			WHERE
				court_case_id = court_cases.id
				AND docket_event_types.code IN('WAI$', 'BWIFAP', 'BWIFA', 'BWIFC', 'BWIAR', 'BWIAA', 'BWICA', 'BWIFAR', 'BWIFAA', 'BWIFP', 'BWIMW', 'BWIR8', 'BWIS', 'BWIS$', 'WAI', 'WAIMV', 'WAIMW', 'BWIFAR')) > 0 THEN
			'Yes'
		ELSE
			'No'
		END) AS warrant_on_case, pleas.name AS plea, verdicts.name AS verdict, (regexp_matches(split_part(counts.filed_statute_violation, 'O.S.', 1), '[0-9]{2}[A-Z]?')) [1] AS title_code
FROM
	counts
	JOIN court_cases ON counts.court_case_id = court_cases.id
	JOIN parties ON parties.id = counts.party_id
	JOIN pleas ON pleas.id = counts.plea_id
	JOIN verdicts ON verdicts.id = counts.verdict_id
