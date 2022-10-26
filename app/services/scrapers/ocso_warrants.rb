module Scrapers
  class OcsoWarrants < ApplicationService
    def perform
      warrants = OcsoScraper::Crawler.perform
      warrants.each do |warrant|
        warrant = ::Osco::Warrant.find_or_initialize_by(
          first_name: warrant[:first_name],
          last_name: warrant[:last_name],
          birth_date: warrant[:birth_date],
          case_number: warrant[:case_number]
        )
        warrant.assign_attributes(
          middle_name: warrant[:middle_name],
          case_number: warrant[:case_number],
          bond_amount: warrant[:bond_amount],
          issued: warrant[:issued],
          counts: warrant[:counts]
        )
        warrant.save!
      end
    end
  end
end