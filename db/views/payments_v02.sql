SELECT
	court_cases.id as court_case_id,
	party_id,
	SUM(amount) AS total,
	SUM(payment) AS payment,
	SUM(adjustment) AS adjustment,
	(SUM(amount) - SUM(adjustment) - SUM(payment)) AS owed
FROM
	docket_events
	JOIN court_cases ON court_cases.id = docket_events.court_case_id
	JOIN parties ON docket_events.party_id = parties.id
	JOIN party_types ON parties.party_type_id = party_types.id
WHERE
	party_types.name = 'defendant'
GROUP BY
	party_id,
	court_cases.id
