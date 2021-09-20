SELECT
	court_cases.id as court_case_id,
	parent_parties.id as arresting_agency_id,
	parent_parties.name as arresting_agency,
	case_types.abbreviation as case_type,
	court_cases.filed_on,
	counts.as_filed as charges_as_filed,
	(regexp_matches(split_part(counts.filed_statute_violation, 'O.S.', 1), '[0-9]{2}[A-Z]?'))[1] as title_code
FROM
	parties
	JOIN party_types ON parties.party_type_id = party_types.id
	LEFT OUTER JOIN case_parties ON parties.id = case_parties.party_id
	LEFT OUTER JOIN court_cases ON case_parties.court_case_id = court_cases.id
	LEFT OUTER JOIN case_types on court_cases.case_type_id = case_types.id
	LEFT OUTER JOIN counts on counts.court_case_id = court_cases.id
	LEFT OUTER JOIN parent_parties on parties.parent_party_id = parent_parties.id
WHERE
	party_types.name = 'arresting agency'
