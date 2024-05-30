module Importers
  module Census
    class Import
      STATE_OKLAHOMA_FIPS = '40'

      attr_accessor :variables, :group, :group_variable_types, :survey, :survey_name, :year, :county_names, :state_fips,
                    :zips, :table_type

      def initialize(
        survey_name,
        year,
        variables: nil,
        group: nil,
        group_variable_types: nil,
        table_type: nil,
        county_names: nil,
        zips: nil
      )

        raise ArgumentError, 'Variable list or group is required' unless variables || group
        raise ArgumentError, 'County names or zips list is required' unless county_names || zips

        @survey_name = survey_name
        @year = year
        @variables = variables
        @group = group
        @group_variable_types = group_variable_types
        @table_type = table_type
        @county_names = county_names
        @zips = zips
        @state_fips = STATE_OKLAHOMA_FIPS
      end

      def self.perform(*args)
        new(*args).perform
      end

      def perform
        import_data
      end

      def statistics
        return import_variables if variables

        import_group
      end

      def import_group
        ::Importers::Census::Group.perform(
          survey,
          group,
          **{
            group_variable_types: group_variable_types,
            table_type: table_type
          }.compact
        )
      end

      def import_variables
        response = HTTParty.get(variable_url).as_json
        variables.each do |variable|
          variable_json = response['variables'][variable]

          statistics[variable] = ::Census::Statistic.find_or_create_by(
            survey: survey,
            name: variable,
            label: variable_json['label'],
            concept: variable_json['concept'],
            group: variable_json['group'],
            predicate_type: variable_json['predicateType']
          )
        end
      end

      def survey
        @survey ||= ::Census::Survey.find_or_create_by name: survey_name, year: year
      end

      def import_data
        statistics.each_slice(49) do |variables_set|
          variables_set = variables_set.to_h
          response = HTTParty.get(data_url(variables_set.keys))
          header_row = response[0]
          data_rows = response.slice(1...)
          area_column_index = -1
          variables_set.each do |variable, statistic_obj|
            variable_column_index = header_row.index(variable)
            data_rows.each do |data|
              area = if county_names
                       ::County.find_by(fips_code: data[area_column_index])
                     else
                       ::ZipCode.find_or_create_by(name: data[area_column_index])
                     end
              ::Census::Data.find_or_create_by(
                statistic: statistic_obj,
                area: area,
                amount: data[variable_column_index]
              )
            end
          end
        end
      end

      def correct_variable_type?(variable)
        last_letters_regex = /.+[1-9](.+)/
        match = last_letters_regex.match(variable)
        return false unless match

        match.captures[0].in? group_variable_types
      end

      def group_url
        "https://api.census.gov/data/#{year}/acs/#{survey_name}#{table_type ? "/#{table_type}" : ''}/groups/#{group}.json"
      end

      def variable_url
        "https://api.census.gov/data/#{year}/acs/#{survey_name}/variables.json"
      end

      def data_url(variables_set)
        url = "https://api.census.gov/data/#{year}/acs/#{survey_name}#{table_type ? "/#{table_type}" : ''}?" \
              "get=NAME,#{variables_set.join(',')}&for="

        if county_names
          county_fips = ::County.where(name: county_names).pluck(:fips_code)
          url += "county:#{county_fips.join(',')}&in=state:#{state_fips}"
        elsif zips
          url += "zip%20code%20tabulation%20area:#{zips.join(',')}" if zips
        end

        url += "&key=#{ENV.fetch('CENSUS_KEY')}"
        url
      end
    end
  end
end
