module Importers
  module Census
    class Import < ApplicationService
      STATE_OKLAHOMA_FIPS = '40'

      attr_accessor :variables, :group, :group_variable_types, :survey_name, :year, :county_names, :state_fips,
                    :zips, :table_type, :statistics

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

        @survey_name = survey_name
        @year = year
        @variables = variables
        @group = group
        @group_variable_types = group_variable_types
        @table_type = table_type
        @county_names = county_names
        @zips = zips
        @state_fips = STATE_OKLAHOMA_FIPS
        super()
      end

      def validate_statistic_lookup_method
        raise ArgumentError, 'Variable list or group is required to look up statistics' unless variables || group
        raise ArgumentError, 'Please specify only variables or group to look up statistics' if variables && group
      end

      def validate_area_type
        raise ArgumentError, 'County names or zips list is required' unless county_names || zips
        raise ArgumentError, 'Please specify only county_names or zips' if county_names && zips
      end

      def perform
        validate_statistic_lookup_method
        validate_area_type

        import_statistics
        import_data
      end

      def import_statistics
        @statistics = if variables
                        import_variables
                      else
                        import_group
                      end
      end

      def import_group
        ::Importers::Census::StatisticsByGroup.perform(
          survey,
          group,
          **{
            group_variable_types: group_variable_types,
            table_type: table_type
          }.compact
        )
      end

      def import_variables
        ::Importers::Census::StatisticsByNames.perform(
          survey,
          variables,
          **{
            table_type: table_type
          }.compact
        )
      end

      def import_data
        ::Importers::Census::Data.perform(
          survey,
          statistics,
          **{
            table_type: table_type,
            county_names: county_names,
            zips: zips
          }.compact
        )
      end

      def survey
        @survey ||= ::Census::Survey.find_or_create_by name: survey_name, year: year
      end
    end
  end
end
