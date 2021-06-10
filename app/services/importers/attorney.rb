module Importer
  class Attorney
    def initialize(court_case)
      @court_case = court_case
      party_matcher = PartyMatcher.new(court_case)
    end

    def self.perform(attorney_object)
      new(attorney_object).perform
    end

    def perform
      attorney_object.each do |_attorney_data|
        save_attorneys
      end
    end

    # TODO: Adjust to respect the bar as the source of truth
    # TODO: Log when name does not seem to match the OK Bar name for that bar number
    def save_attorneys(attorney_data)
      c = if attorney_data[:bar_number].present?
            Counsel.find_or_initialize_by(bar_number: attorney_data[:bar_number]&.to_i)
          else
            Counsel.find_or_initialize_by(name: attorney_data[:name].downcase)
          end

      c.assign_attributes({
                            name: attorney_data[:name].downcase,
                            address: attorney_data[:address],
                            bar_number: attorney_data[:bar_number]&.to_i
                          })
      if c.save
        name = attorney_data[:represented_parties].squish
        data = {
          court_case_id: court_case.id,
          counsel_id: c.id,
          party_id: party_matcher.party_id_from_name(name)
        }
        CounselParty.find_or_create_by(data)
      else
        create_log('counsel', "#{court_case.case_number} resulted in an error when creating the counsel", attorney_data)
      end
    end
  end
end
