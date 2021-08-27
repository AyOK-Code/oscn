require 'uri'
require 'oscn_scraper'

namespace :split do
  desc 'Scrape cases data'
  task names: [:environment] do
    parties = Party.defendant.where(first_name: nil)
    bar = ProgressBar.new(parties.count)

    parties.each do |p|
      bar.increment!
      Matchers::PartyNameSplitter.new(p, p.full_name).perform
    end
  end
end
