SELECT
	docket_events.id,
	docket_events.court_case_id,
	case_types.name,
	case_types.abbreviation,
	docket_events.party_id,
	docket_events.event_on,
	docket_event_types.code,
	(SELECT parent_parties.name from case_parties
		JOIN parties on case_parties.party_id = parties.id
		JOIN parent_parties on parties.parent_party_id = parent_parties.id
		JOIN party_types on parties.party_type_id = party_types.id
		JOIN court_cases on court_cases.id = case_parties.court_case_id
		WHERE party_types.name = 'arresting agency' AND
		court_cases.id = docket_events.court_case_id LIMIT 1) as arresting_agency,
	CASE docket_event_types.code
	WHEN 'WAI$' THEN
		'Warrant of Arrest Issued'
	WHEN 'BWIFAP' THEN
		'Bench Warrant Issued - Failed to Appear and Pay'
	WHEN 'BWIFA' THEN
		'Bench Warrant Issued - Failed to Appear'
	WHEN 'BWIFC' THEN
		'Bench Warrant Issued - Failure to Comply'
	WHEN 'BWIAR' THEN
		'Bench Warrant Issued - Application to Revoke'
	WHEN 'BWIAA' THEN
		'Bench Warrant Issued - Application to Accelerate'
	WHEN 'BWICA' THEN
		'Bench Warrant Issued - Cause'
	WHEN 'BWIFAR' THEN
		'Bench Warrant Issued - Failure to Appear - Application to Revoke'
	WHEN 'BWIFAA' THEN
		'Bench Warrant Issued - Failure To Appear-Application to Accelerate'
	WHEN 'BWIFP' THEN
		'Bench Warrant Issued - Failed To Pay'
	WHEN 'BWIMW' THEN
		'Bench Warrant Issued - Material Witness'
	WHEN 'BWIR8' THEN
		'Bench Warrant Issued - Rule 8'
	WHEN 'BWIS' THEN
		'Bench Warrant Issued - Service By Sheriff - No Money'
	WHEN 'BWIS$' THEN
		'Bench Warrant Issued - Service By Sheriff'
	WHEN 'WAI' THEN
		'Warrant of Arrest Issued - No Money'
	WHEN 'WAIMV' THEN
		'Warrant of Arrest Issued - Material Warrant'
	WHEN 'WAIMW' THEN
		'Warrant of Arrest Issued - Material Witness'
	WHEN 'BWIFAR' THEN
		'Bench Warrrant Issued - Failure to Appear - Application to Revoke'
	END AS ShortDescription,
	CASE WHEN docket_event_types.code IN('BWIFA', 'BWIFAP', 'BWIFAA', 'BWIFAR') THEN
		TRUE
	ELSE
		FALSE
	END AS is_failure_to_appear,
	CASE WHEN docket_event_types.code IN('BWIFAP', 'BWIFP') THEN
		TRUE
	ELSE
		FALSE
	END AS is_failure_to_pay,
	CASE WHEN docket_event_types.code IN('BWIFC') THEN
		TRUE
	ELSE
		FALSE
	END AS is_failure_to_comply,
	CASE WHEN docket_event_types.code IN('BWIFAP','BWIFA','BWIFC', 'BWIAA','BWIAR','BWICA','BWIFAR', 'BWIFAA', 'BWIR8', 'BWIS', 'BWIS$', 'BWIFP', 'BWIMW') THEN
		TRUE
	ELSE
		FALSE
	END AS is_bench_warrant_issued,
	CASE WHEN docket_event_types.code IN('WAI', 'WAI$') THEN
		TRUE
	ELSE
		FALSE
	END as is_arrest_warrant_issued,
	CASE WHEN docket_event_types.code IN('BWIAA', 'BWIFAA') THEN
		TRUE
	ELSE
		FALSE
	END as is_application_to_accelerate,
	CASE WHEN docket_event_types.code IN('BWIFAR', 'BWIAR') THEN
		TRUE
	ELSE
		FALSE
	END as is_application_to_revoke,
	CASE WHEN docket_event_types.code IN('BWICA') THEN
		TRUE
	ELSE
		FALSE
	END as is_cause,
	CASE WHEN docket_event_types.code IN('BWIMW', 'WAIMW') THEN
		TRUE
	ELSE
		FALSE
	END as is_material_witness,
	CASE WHEN docket_event_types.code IN('WAIMV') THEN
		TRUE
	ELSE
		FALSE
	END as is_material_warrant,
	CASE WHEN docket_event_types.code IN('BWIR8') THEN
		TRUE
	ELSE
		FALSE
	END as is_material_rule_8,
	CASE WHEN docket_event_types.code IN('BWIS$', 'BWIS') THEN
		TRUE
	ELSE
		FALSE
	END as is_service_by_sheriff,
	CASE WHEN docket_events.description LIKE '%CLEARED%' THEN true ELSE false END as is_cleared,
	CAST(CAST((
			SELECT
				(REGEXP_MATCHES(docket_events.description, '[0-9]{1,3}(?:,?[0-9]{3})*\.[0-9]{2}')) [1]) AS money) AS decimal) AS bond_amount,
	(
		SELECT
			(REGEXP_MATCHES(((
					SELECT
						(REGEXP_MATCHES(docket_events.description, 'WARRANT RETURNED \d{1,2}/\d{1,2}/\d{4}'))) [1]), '\d{1,2}/\d{1,2}/\d{4}')) [1]) AS warrant_returned_on,
		(
			SELECT
				(REGEXP_MATCHES(((
						SELECT
							(REGEXP_MATCHES(docket_events.description, 'WARRANT ISSUED ON \d{1,2}/\d{1,2}/\d{4}'))) [1]), '\d{1,2}/\d{1,2}/\d{4}')) [1]) AS warrant_issued_on,
			(
				SELECT
					(REGEXP_MATCHES(((
							SELECT
								(REGEXP_MATCHES(docket_events.description, 'WARRANT RECALLED \d{1,2}/\d{1,2}/\d{4}'))) [1]), '\d{1,2}/\d{1,2}/\d{4}')) [1]) AS warrant_recalled_on,
				description
			FROM
				docket_events
				JOIN docket_event_types ON docket_event_types.id = docket_events.docket_event_type_id
				JOIN court_cases ON court_cases.id = docket_events.court_case_id
				JOIN case_types ON court_cases.case_type_id = case_types.id
			WHERE
				docket_event_types.code IN('WAI$', 'BWIFAP', 'BWIFA', 'BWIAR', 'BWIAA', 'BWIFC', 'BWIFAR', 'BWICA', 'BWIFAA', 'BWIFP', 'BWIMW', 'BWIR8', 'BWIS', 'BWIS$', 'WAI', 'WAIMV', 'WAIMW')
				AND docket_events.description LIKE '%WARRANT%'
