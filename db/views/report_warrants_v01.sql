SELECT
	docket_events.court_case_id,
	docket_events.party_id,
	docket_events.event_on,
	docket_event_types.code,
	CASE docket_event_types.code
	WHEN 'WICF' THEN
		'Warrant Intercept'
	WHEN 'WAI$' THEN
		'Warrant of Arrest Issued'
	WHEN 'CTDFTA' THEN
		'Defendant Failed to Appear'
	WHEN 'BWIFAP' THEN
		'Bench Warrant Issued: Failed to Appear and Pay'
	WHEN 'BWIFA' THEN
		'Bench Warrant Issued: Failed to Appear'
	WHEN 'BWIFC' THEN
		'Bench Warrant Issued: Failure to Comply'
	WHEN 'RETWA' THEN
		'Warrant Returned'
	WHEN 'RETBW' THEN
		'Warrant Returned'
	WHEN 'BWR' THEN
		'Bench Warrant Recalled'
	WHEN 'BWIAR' THEN
		'Bench Warrant Issued on Application to Revoke'
	WHEN 'O' THEN
		'Order Recalling Bench Warrant'
	WHEN 'CTBWFTA' THEN
		'Defendant Failed to Appear for Arraignment'
	WHEN 'MOD&O' THEN
		'Motion to Dismiss and Recall Warrant'
	WHEN 'BWIAA' THEN
		'Bench Warrant Issued on Application to Accelerate'
	WHEN 'OTHERNoFees' THEN
		'Cost Warrant Release on Personal Recognizance Agreement'
	-- Start here
	WHEN 'BWICA' THEN
		'Bench Warrant Issued Cause'
	WHEN 'BWIFAA' THEN
		'Bench Warrant Issued Failure To Appear-Application to Accelerate'
	WHEN 'BWIFP' THEN
		'Bench Warrant Issued Failed To Pay'
	WHEN 'BWIMW' THEN
		'Bench Warrant For Material Witness'
	WHEN 'BWIR8' THEN
		'Bench Warrant Issued-Rule 8'
	WHEN 'BWIS' THEN
		'Bench Warrant Issued-Service By Sheriff-No Money'
	WHEN 'BWIS$' THEN
		'Bench Warrant Issued-Service By Sheriff'
	WHEN 'WAI' THEN
		'Warrant of Arrest Issued-No Money'
	WHEN 'WAIMV' THEN
		'Warrant of Arrest Issued-Material Warrant'
	WHEN 'BWIFAR' THEN
		'Bench Warrrant Issued - Failure to Appear - Application to Revoke'
	END AS ShortDescription,
	CASE WHEN docket_event_types.code IN('CTBWFTA', 'BWIFA', 'BWIFAP', 'CTDFTA', 'BWIFAA', 'BWIFAR') THEN
		TRUE
	ELSE
		FALSE
	END AS is_failure_to_appear,
	CASE WHEN docket_event_types.code IN('BWIFAP', 'BWIFP') THEN
		TRUE
	ELSE
		FALSE
	END AS is_failure_to_pay,
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
			WHERE
				docket_event_types.code IN('WAI$', 'RETWA', 'RETBW', 'BWIFAP', 'CTDFTA', 'CTBWFTA', 'BWIFA', 'BWR', 'MOD&O', 'O', 'WICF', 'BWIAR', 'OTHERNoFees', 'BWIAA', 'BWIFC', 'BWIFAR', 'BWICA', 'BWIFAA', 'BWIFP', 'BWIMW', 'BWIR8', 'BWIS', 'BWIS$', 'WAI', 'WAIMV')
				AND docket_events.description LIKE '%WARRANT%'
