module Importers
  # Imports Attorney information from JSON
  class Attorney
    attr_accessor :attorney_object, :court_case, :logs, :party_matcher

    def initialize(attorney_object, court_case, logs)
      @attorney_object = attorney_object
      @court_case = court_case
      @logs = logs
      @party_matcher = Matchers::Party.new(court_case)
    end

    def self.perform(attorney_data, court_case, logs)
      new(attorney_data, court_case, logs).perform
    end

    def perform
      attorney_object.each do |attorney_data|
        save_attorneys(attorney_data)
      end
    end

    # TODO: Adjust to respect the OK bar number website as the source of truth
    # TODO: Log when name does not seem to match the OK Bar name for that bar number
    # TODO: Address not working
    def save_attorneys(attorney_data)
      bar_number = attorney_data[:bar_number]&.to_i
      name = attorney_data[:name].downcase

      if bar_number.present?
        c = Counsel.find_or_initialize_by(bar_number: bar_number)
      else
        c = Counsel.find_or_initialize_by(name: name)
      end

      c.assign_attributes({
                            name: name,
                            address: attorney_data[:address],
                            bar_number: bar_number
                          })
      if c.save
        party_name = attorney_data[:represented_parties].squish
        data = {
          court_case_id: court_case.id,
          counsel_id: c.id,
          party_id: party_matcher.party_id_from_name(party_name)
        }
        CounselParty.find_or_create_by(data)
      else
        logs.create_log('counsel', "#{court_case.case_number} resulted in an error when creating the counsel", attorney_data)
      end
    end
  end
end
