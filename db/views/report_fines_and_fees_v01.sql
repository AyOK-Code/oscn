SELECT
	court_cases.id as court_case_id,
	case_types.id as case_type_id,
	docket_event_types.id as docket_event_types_id,
	event_on,
	amount,
	payment,
	adjustment,
	(CASE WHEN (SELECT COUNT(*) FROM docket_events JOIN docket_event_types on docket_events.docket_event_type_id = docket_event_types.id where docket_events.court_case_id = court_cases.id AND docket_event_types.code = 'CTRS') > 0 THEN true ELSE false END) AS is_tax_intercepted
FROM
	docket_events
	JOIN docket_event_types ON docket_event_types.id = docket_events.docket_event_type_id
	JOIN court_cases ON court_cases.id = docket_events.court_case_id
	JOIN case_types ON court_cases.case_type_id = case_types.id
WHERE
	docket_events.amount != 0
	OR docket_events.adjustment != 0
	OR docket_events.payment != 0
