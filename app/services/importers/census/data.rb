module Importers
  module Census
    class Data < ApplicationService
      STATE_OKLAHOMA_FIPS = '40'

      attr_accessor :survey, :statistics, :table_type, :county_names, :state_fips,
                    :zips

      def initialize(
        survey,
        statistics,
        table_type: nil,
        county_names: nil,
        zips: nil
      )
        raise ArgumentError, 'County names or zips list is required' unless county_names || zips

        @survey = survey
        @statistics = statistics
        @table_type = table_type
        @county_names = county_names
        @zips = zips
        @state_fips = STATE_OKLAHOMA_FIPS
        super()
      end

      def perform
        import_data
      end

      def import_data
        statistics.each_slice(49) do |statistics_for_request|
          statistics_for_request = statistics_for_request.to_h
          response = HTTParty.get(data_url(statistics_for_request.keys))
          header_row = response[0]
          data_rows = response.slice(1...)
          area_column_index = -1
          statistics_for_request.each do |variable, statistic_obj|
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

      def data_url(variable_names)
        url = "https://api.census.gov/data/#{survey.year}/acs/#{survey.name}#{table_type ? "/#{table_type}" : ''}?" \
              "get=NAME,#{variable_names.join(',')}&for="

        if county_names
          county_fips = ::County.where(name: county_names).pluck(:fips_code)
          raise ActiveRecord::RecordNotFound if county_fips.length < county_names.length

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
