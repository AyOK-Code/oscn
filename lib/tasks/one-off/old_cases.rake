namespace :update do
  desc 'Update cases for data request'
  task old_cases: [:environment] do
    data = ActiveRecord::Base.connection.execute("SELECT
      case_number
    FROM
      court_cases
      JOIN case_types ON court_cases.case_type_id = case_types.id
      JOIN case_parties ON court_cases.id = case_parties.court_case_id
      JOIN parties ON case_parties.party_id = parties.id
      JOIN party_types ON parties.party_type_id = party_types.id
    WHERE
      now() - interval '5 years' > closed_on
      AND party_types.name = 'defendant'
      AND case_types.abbreviation IN('CF', 'CM')
      AND(
        SELECT
          COUNT(*)
        FROM
          docket_events
          JOIN docket_event_types ON docket_events.docket_event_type_id = docket_event_types.id
        WHERE
          docket_event_types.code IN('BWIFAP', 'BWIFP')
          AND docket_events.court_case_id = court_cases.id
          AND docket_events.party_id = parties.id
      ) > 0")

    county = County.find_by(name: 'Oklahoma')
    bar = ProgressBar.new(data.values.size)

    data.each_value do |case_number|
      bar.increment!
      court_case = ::CourtCase.find_by!(county_id: county.id, case_number: case_number)
      next unless court_case.enqueued == false

      court_case.update(enqueued: true)
      CourtCaseWorker
        .set(queue: :default)
        .perform_async(county.id, case_number, true)

      case_id = CourtCase.find_by(case_number: case_number)&.id

      CaseParty.where(court_case_id: case_id).each do |cp|
        party = ::CourtCase.find_by!(oscn_id: cp.party.oscn_id)
        next if party.enqueued

        party.update(enqueued: true)
        PartyWorker.perform_in(1.hour, cp.party.oscn_id)
      end
    end
  end
end
