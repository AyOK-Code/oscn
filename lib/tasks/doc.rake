require 'open-uri'

# Source downloaded from:
# https://web.archive.org/web/20220000000000*/https://oklahoma.gov/doc/communications/odoc-public-inmate-data.html
# DOC publishes data quarterly retroactively for the previous quarter.
# (So on 2022-10-31 the data on the site will be from 2022-03 to 2022-06)

# Import may benefit from scaling server and database resources

namespace :doc do
  desc 'Scrape DOC for most recent file and import'
  task scrape: [:environment] do
    dir = '2023-04'
    Scrapers::Doc::QuarterlyData.perform(dir)
    ActiveRecord::Base.transaction do
      Importers::Doc::OffenseCode.new(dir).perform
      Importers::Doc::Profile.new(dir).perform
      Importers::Doc::Sentence.new(dir).perform
      Importers::Doc::Alias.new(dir).perform
      Importers::Doc::Status.new(dir).perform
      # Importers::Doc::LinkCases.new(county).perform # uncommented once we add support for multiple counties
      # Importers::Doc::LinkOffenseCodes.new.perform # uncomment once this is confirmed to be working
    end
  end
end
