SELECT
  court_cases.id,
  (closed_on - filed_on) as length_of_case_in_days,
  (SELECT COUNT(*) FROM counts where court_cases.id = counts.court_case_id) as counts_count,
  (SELECT COUNT(*) FROM case_parties
    JOIN parties on case_parties.party_id = parties.id
    JOIN party_types on parties.party_type_id = party_types.id
    WHERE court_cases.id = case_parties.court_case_id
    AND party_types.name = 'defendant') as defendant_count
  FROM court_cases
