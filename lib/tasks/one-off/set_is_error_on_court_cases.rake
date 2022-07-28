namespace :update do
  desc 'Set the is_error flag on court_cases'

  task set_is_error_on_court_cases: [:environment] do
    associations = [:parties, :current_judge, :counsels, :counts, :events, :docket_events]
    CourtCase.in_batches(of: 1000) do |court_cases|
      court_cases.includes(associations).each do |court_case|
        court_case.update!(is_error: true) if court_case.error?
      end
    end
  end
end
