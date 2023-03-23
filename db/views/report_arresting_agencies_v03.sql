SELECT
 	court_cases.id as court_case_id,
	court_cases.county_id as county_id,
 	court_cases.case_number,
 	a.parent_party_id as arresting_agency_id,
 	(CASE WHEN parent_parties_name IS NULL THEN 'NOT PROVIDED' ELSE parent_parties_name END) as arresting_agency,
 	case_types.abbreviation as case_type,
 	court_cases.filed_on,
 	COALESCE(counts.as_filed, 'No Charges Filed') as charges_as_filed,
 	COALESCE(counts.filed_statute_violation, 'No Charges Filed') as filed_statute_violation,
 	(SELECT (regexp_matches(split_part(counts.filed_statute_violation, 'O.S.', 1), '[0-9]{2}[A-Z]?'))[1] as title_code FROM counts c2 where counts.court_case_id = court_cases.id AND counts.id = c2.id) as title_code
FROM court_cases
	LEFT JOIN (
		SELECT case_parties.court_case_id as court_case_id, parent_parties.id as parent_party_id, parent_parties.name as parent_parties_name
        FROM case_parties
        JOIN parties ON case_parties.party_id = parties.id
        JOIN party_types ON parties.party_type_id = party_types.id
        JOIN parent_parties ON parties.parent_party_id = parent_parties.id
        WHERE party_types."name" = 'arresting agency'
	) as a ON court_cases.id = a.court_case_id
	LEFT OUTER JOIN case_types on court_cases.case_type_id = case_types.id
	LEFT OUTER JOIN counts on counts.court_case_id = court_cases.id
WHERE case_types.abbreviation != 'CPC'
