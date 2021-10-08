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

    parties.each do |p|
      bar.increment!
      Matchers::PartyNameSplitter.new(p, p.full_name).perform
    end
  end

  desc 'Save party detail information'
  task party_detail: [:environment] do
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
end
