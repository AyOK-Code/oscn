require 'uri'
require 'oscn_scraper'

namespace :update do
  desc 'Scrape cases data'
  task cases: [:environment] do
    Scrapers::Judges.perform
    Scrapers::Case.perform
  end

  desc 'Refresh Oklahoma Evictions'
  task refresh_evictions: [:environment] do
    ReportOklahomaEviction.refresh
  end

  desc 'Refresh the materialized views for the database'
  task refresh_views: [:environment] do
    ReportJuvenileFirearms.refresh
    ReportCriminalCase.refresh
    ReportOcisCountiesEviction.refresh
    ReportWarrants.refresh
    ReportFinesAndFees.refresh
    ReportArrestingAgency.refresh
    ReportSearchableCase.refresh
    PartyStat.refresh
    CaseStat.refresh
  end

  desc 'Split out name into first, last, middle, etc.'
  task party_name: [:environment] do
    parties = Party.defendant.where(first_name: nil)
    bar = ProgressBar.new(parties.count)
    # DONE: Move to party importer task
    parties.each do |p|
      bar.increment!
      Matchers::PartyNameSplitter.new(p).perform
    end
  end

  desc 'Save party detail information'
  task party_detail: [:environment] do
    Scrapers::Party.perform
  end

  desc 'Assign parents'
  task assign_parent_parties: [:environment] do
    parties = Party.arresting_agency.without_parent
    parties.each do |p|
      party_with_parent = Party.with_parent.find_by(full_name: p.full_name)
      if party_with_parent.present?
        puts "#{p.full_name} mapped to #{party_with_parent.first.parent_party.name}"
        p.update(party_parent_id: party_with_parent.party_parent_id)
      end
    end
  end

  desc 'Create count codes from stored htmls data'
  task count_code: [:environment] do
    cases = CourtCase.where(id: Count.where(filed_statute_code_id: nil).pluck(:court_case_id))
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      bar.increment!
      next if c.case_html.nil? || c.county.name != 'Oklahoma'

      Importers::CourtCase.new('Oklahoma', c.case_number).perform
    end
  end

  desc 'Update database from stored html'
  task database: [:environment] do
    court_cases = CourtCase.joins(:case_html).where.not(case_htmls: { id: nil }).pluck('county_id', :case_number,
                                                                                       'case_htmls.id')
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      bar.increment!

      next if c[2].nil?

      DatabaseUpdateWorker.perform_in(1.minutes, { county_id: c[0], case_number: c[1] })
    end
  end

  desc 'Queue up cases missing html'
  task missing_html: [:environment] do
    court_cases = CourtCase.without_html.not_in_queue.select(:id, :county_id, :case_number)
    bar = ProgressBar.new(court_cases.length)

    court_cases.each do |c|
      bar.increment!

      CourtCaseWorker
        .set(queue: :high)
        .perform_async(c.county_id, c.case_number, true)
      court_case = CourtCase.find(c.id)
      court_case.update(enqueued: true)
    end
  end

  desc 'Set the is_error flag on court_cases'
  task is_error: [:environment] do
    associations = [:parties, :current_judge, :counsels, :counts, :events, :docket_events]
    bar = ProgressBar.new(CourtCase.all.count)
    CourtCase.in_batches(of: 1000) do |court_cases|
      court_cases.includes(associations).each do |court_case|
        court_case.update!(is_error: true) if court_case.error?
      end
      bar.increment!(1000)
    end
  end
end
