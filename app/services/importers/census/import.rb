module Importers
  module Census
    class Import
      SURVEY_ACS1 = 'acs1'
      SURVEY_ACS5 = 'acs5'

      COUNTIES_OKLAHOMA = 'Oklahoma'
      COUNTIES_TULSA = 'Tulsa'

      STATE_OKLAHOMA_FIPS = '40'

      attr_accessor :variables, :survey, :year, :county_names, :state_fips, :zips, :statistics

      def initialize(variables,
                     survey,
                     year,
                     county_names: false,
                     zips: false)
        @variables = variables
        @survey = survey
        @year = year
        @county_names = county_names
        @state_fips = STATE_OKLAHOMA_FIPS
        @zips = zips
        @statistics = {}
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
        survey = ::Census::Survey.find_or_create_by name: @survey, year: @year
        variables.each do |variable|
          statistics[variable] = ::Census::Statistic.find_or_create_by(
            survey: survey,
            name: variable,
            label: response['variables'][variable]['label'],
            concept: response['variables'][variable]['concept'],
            group: response['variables'][variable]['group'],
            predicate_type: response['variables'][variable]['predicateType']
          )
        end
      end

      def import_data
        response = HTTParty.get(data_url)
        header_row = response[0]
        data_rows = response.slice(1...)
        area_column_index = -1
        variables.each do |variable|
          variable_column_index = header_row.index(variable)
          data_rows.each do |data|
            area = if county_names
                     ::County.find_by(fips_code: data[area_column_index])
                   else
                     ::ZipCode.find_or_create_by(name: data[area_column_index])
                   end
            ::Census::Data.find_or_create_by(
              statistic: statistics[variable],
              area: area,
              amount: data[variable_column_index]
            )
          end
        end
      end

      def variable_url
        "https://api.census.gov/data/#{year}/acs/acs1/variables.json"
      end

      def data_url
        url = "https://api.census.gov/data/#{year}/acs/#{survey}?" \
              "get=NAME,#{variables.join(',')}&for="

        if county_names
          county_fips = ::County.where(name: county_names).pluck(:fips_code)
          url += "county:#{county_fips.join(',')}&in=state:#{state_fips}"
        elsif zips
          url += "zip%20code%20tabulation%20area:#{zips.join(',')}" if zips
        end

        url += "&key=#{key}"
        url
      end

      def key
        ENV.fetch('CENSUS_KEY')
      end
    end
  end
end
