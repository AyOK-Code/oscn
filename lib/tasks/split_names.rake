require 'uri'
require 'oscn_scraper'

namespace :split do
  desc 'Scrape cases data'
  task names: [:environment] do
    parties = Party.defendant.without_birthday.joins(case_parties: :court_case).where(court_cases: { filed_on: Date.new(2020,6,30)..Date.new(2021,7,1) })
    bar = ProgressBar.new(parties.count)

    parties.each do |p|
      bar.increment!
      Matchers::PartyNameSplitter.new(p, p.full_name).perform
    end
  end
end
