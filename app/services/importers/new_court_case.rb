module Importers
  # Create a court case when it does not exist in the database
  class NewCourtCase
    attr_reader :case_number, :uri, :params, :date
    attr_accessor :counties, :case_types

    def initialize(link)
      @case_number = link.text
      @case_types = CaseType.oscn_id_mapping
      @counties = County.pluck(:name, :id).to_h
      @params = CGI.parse(URI(link['href']).query).to_h { |k, v| [k.downcase, v.first] }
    end

    def perform
      c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id, county_id: counties[county])
      c.assign_attributes(
        case_type_id: case_types[case_type],
        case_number: case_number
      )
      c.save!
    end

    private

    def oscn_id
      params.fetch('casemasterid')
    end

    def county
      params.fetch('db')
    end

    def case_type
      case_number.split('-').first
    end
  end
end
