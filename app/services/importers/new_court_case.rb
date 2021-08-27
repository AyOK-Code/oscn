module Importers
  # Create a court case when it does not exist in the database
  class NewCourtCase
    attr_reader :case_number, :uri, :params, :date
    attr_accessor :counties, :case_types

    def initialize(link)
      @case_number = link.text
      @case_types = CaseType.oscn_id_mapping
      @counties = County.pluck(:name, :id).to_h
      @uri = URI(link['href'])
      @params = CGI.parse(uri.query)
    end

    def perform
      c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id)
      c.assign_attributes(
        county_id: counties[county],
        case_type_id: case_types[case_type],
        case_number: case_number
      )
      c.save!
    end

    private

    def oscn_id
      params['casemasterid'].first.to_i
    end

    def county
      params['db'].first
    end

    def case_type
      case_number.split('-').first
    end
  end
end
