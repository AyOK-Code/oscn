SELECT
	court_cases.case_number,
	case_types.id as case_type_id,
	case_types.abbreviation as case_type_abbreviation,
	case_types.name as case_type,
	event_on,
	docket_event_types.id as docket_event_types_id,
	docket_event_types.code,
	docket_events.description,
	amount,
	payment,
	adjustment
FROM
	docket_events
	JOIN docket_event_types ON docket_event_types.id = docket_events.docket_event_type_id
	JOIN court_cases ON court_cases.id = docket_events.court_case_id
	JOIN case_types ON court_cases.case_type_id = case_types.id
WHERE
	docket_events.amount != 0
	OR docket_events.adjustment != 0
	OR docket_events.payment != 0
