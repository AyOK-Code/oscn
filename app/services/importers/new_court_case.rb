module Importers
  # Create a court case when it does not exist in the database
  class NewCourtCase
    attr_reader :case_number, :uri, :params, :date
    attr_accessor :counties, :case_types

    def initialize(link, date)
      @case_number = link.text
      @case_types = CaseType.oscn_id_mapping
      @counties = County.pluck(:name, :id).to_h
      @uri = URI(link['href'])
      @params = CGI.parse(uri.query)
      @date = date
    end

    # TODO: Refactor this plz
    def perform
      puts "Pulling case #{case_number}"
      oscn_id = params['casemasterid'].first.to_i
      county = params['db'].first
      case_type = case_number.split('-').first

      c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id)
      c.assign_attributes(
        county_id: counties[county],
        case_type_id: case_types[case_type],
        case_number: case_number,
        filed_on: date
      )
      c.save!
    end
  end
end
