module Scrapers
  class OcsoWarrants < ApplicationService
    def perform
      warrant_hashes = OcsoScraper::Crawler.perform
      warrant_hashes.each do |warrant_hash|
        warrant = ::Ocso::Warrant.find_or_initialize_by(
          first_name: warrant_hash[:first_name],
          last_name: warrant_hash[:last_name],
          birth_date: warrant_hash[:birth_date],
          case_number: warrant_hash[:case_number]
        )
        warrant.assign_attributes(
          middle_name: warrant_hash[:middle_name],
          case_number: warrant_hash[:case_number],
          bond_amount: warrant_hash[:bond_amount],
          issued: warrant_hash[:issued],
          counts: warrant_hash[:counts],
          updated_at: DateTime.now,
          resolved_at: nil
        )
        warrant.save!
      end
      ::Ocso::Warrant.where(resolved_at: nil).where('updated_at > ?', 7.days.ago).each do |warrant|
        warrant.update!(resolved_at: warrant.updated_at + 1.day)
      end
    end
  end
end
