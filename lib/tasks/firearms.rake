namespace :firearms do
  desc 'Queue up recent evictions cases'
  task refresh_view_cases: [:environment] do
    court_cases = ReportJuvenileFirearm.distinct.pluck(:case_number)
    county = County.find_by(name: 'Oklahoma')
    bar = ProgressBar.new(court_cases.length)

    court_cases.each do |c|
      bar.increment!

      CourtCaseWorker
        .set(queue: :critical)
        .perform_async(county.id, c, true)
      court_case = CourtCase.find_by(county_id: county.id, case_number: c)
      court_case.update(enqueued: true)
    end
  end
end
