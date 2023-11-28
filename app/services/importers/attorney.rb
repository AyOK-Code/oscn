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
      rescue StandardError => e
        Raygun.track_exception(e,
                               custom_data: { error_type: 'Data Error', data_content: attorney_data,
                                              case_number: court_case.case_number })
      end
    end

    # TODO: Adjust to respect the OK bar number website as the source of truth
    # TODO: Log when name does not seem to match the OK Bar name for that bar number
    # TODO: Address not working
    def save_attorneys(attorney_data)
      name = attorney_data[:name].downcase
      bar_number = attorney_data[:bar_number]&.to_i
      c = find_by_bar_or_name(bar_number, name)

      c.assign_attributes({
                            name: name,
                            address: attorney_data[:address],
                            bar_number: bar_number
                          })
      if c.save
        save_counsel_party(attorney_data, c)
      else
        logs.create_log('counsel', "#{court_case.case_number}: error when creating the counsel", attorney_data)
      end
    end

    def find_by_bar_or_name(bar_number, name)
      if bar_number.present?
        Counsel.find_or_initialize_by(bar_number: bar_number)
      else
        Counsel.find_or_initialize_by(name: name)
      end
    end

    def save_counsel_party(attorney_data, counsel)
      attorney_data[:represented_parties].each do |party|
        data = {
          court_case_id: court_case.id,
          counsel_id: counsel.id,
          party_id: party_matcher.party_id_from_name(party.squish.chomp(','))
        }
        CounselParty.find_or_create_by(data)
      end
    end
  end
end
