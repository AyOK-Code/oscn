module Importers
  module Census
    class Import
      SURVEY_ACS1 = "acs1"
      SURVEY_ACS5 = "acs5"

      COUNTIES_OKC = "109"
      COUNTIES_TULSA = "143"

      STATE_OKLAHOMA = "40"

      attr_accessor :variables, :survey, :year, :counties, :state, :zips, :variables_map

      def initialize(variables,
                     survey,
                     year,
                     counties: false,
                     zips: false
      )
        @variables = variables
        @survey = survey
        @year = year
        @counties = counties
        @state = STATE_OKLAHOMA
        @zips = zips
        @variables_map = {}
      end

      def self.perform(*args)
        new(*args).perform
      end

      def perform
        import_variable
        import_data
      end

      def import_variable
        response = HTTParty.get(variable_url).as_json
        variables.each do |variable|
          variables_map[variable] = {
            name: variable,
            label: response['variables'][variable]["label"],
            concept: response['variables'][variable]["concept"],
            group: response['variables'][variable]["group"]
          }
        end
      end

      def import_data
        response = HTTParty.get(data_url)
        header_row = response[0]
        data_rows = response.slice(1...)
        area_grouping_index = 0
        variables.each do |variable|
          variable_index = header_row.index(variable)
          data_rows.each do |data|
            variables_map[variable]["data"] = {
              grouping_type: counties ? "County" : "ZipCode",
              grouping_value: counties ? data[area_grouping_index] : data[area_grouping_index].slice!("ZCTA5 "),
              value: data[variable_index]
            }
          end
        end
      end

      def variable_url
        "https://api.census.gov/data/#{year}/acs/acs1/variables.json"
      end

      def data_url
        url = "https://api.census.gov/data/#{year}/acs/#{survey}?" +
          "get=NAME,#{variables.join(',')}&for="

        if counties
          url += "county:#{counties.join(",")}"
        elsif zips
          url += "zips:#{zips.join(",")}" if zips
        end

        url += "&in=state:#{state}&key=#{key}"
        url
      end

      def key
        ENV.fetch('CENSUS_KEY')
      end
    end
  end
end