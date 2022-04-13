require 'uri'
require 'oscn_scraper'

namespace :update do
  desc 'Scrape cases data'
  task cases: [:environment] do
    Scrapers::Case.perform
  end

  desc 'Refresh the materialized views for the database'
  task refresh_views: [:environment] do
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
    # TODO: Move to party importer task
    parties.each do |p|
      bar.increment!
      Matchers::PartyNameSplitter.new(p, p.full_name).perform
    end
  end

  desc 'Save party detail information'
  task party_detail: [:environment] do
    # TODO: Refine party scraping so that parties
    # with missing birthdays don't get scraped every night
    parties = Party.defendant.without_birthday
    bar = ProgressBar.new(parties.count)

    parties.each do |p|
      bar.increment!
      PartyWorker.perform_async(p.oscn_id)
    end
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

  desc 'Update full database from stored html'
  task database: [:environment] do
    court_cases = CourtCase.joins(:case_html).pluck('county_id', :case_number, 'case_htmls.id')
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      bar.increment!
      next if c[2].nil?

      CourtCaseWorker.perform_in(1.minutes, { county_id: c[0], case_number: c[1], scrape_case: false })
    end
  end
end
