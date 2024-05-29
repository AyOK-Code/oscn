module Importers
  module Census
    class Import
      SURVEY_ACS1 = 'acs1'
      SURVEY_ACS5 = 'acs5'

      COUNTIES_OKLAHOMA = 'Oklahoma'
      COUNTIES_TULSA = 'Tulsa'

      ZIPS_OKLAHOMA_COUNTY = %w[
          73003 73007 73008 73013 73020 73034 73045 73049 73054 73066 73083 73084 73097 73101 73102 73103 73104 73105
          73106 73107 73108 73109 73110 73110 73111 73112 73113 73114 73115 73115 73116 73116 73117 73118 73119 73120
          73120 73121 73122 73122 73123 73123 73124 73125 73126 73127 73128 73129 73130 73130 73131 73132 73132 73134
          73135 73135 73136 73137 73140 73140 73141 73142 73143 73144 73145 73145 73146 73147 73148 73149 73150 73151
          73152 73153 73153 73154 73155 73156 73157 73159 73162 73163 73164 73167 73169 73172 73177 73178 73179 73180
          73189 73195]

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
        import_statistic
        import_data
      end

      def import_statistic
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
