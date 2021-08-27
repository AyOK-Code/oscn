SELECT
  court_cases.id,
  (closed_on - filed_on) as length_of_case_in_days,
  (SELECT COUNT(*) FROM counts where court_cases.id = counts.court_case_id) as counts_count
  FROM court_cases
