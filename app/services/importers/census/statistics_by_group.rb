module Importers
  module Census
    class StatisticsByGroup
      attr_accessor :survey, :group, :group_variable_types, :table_type

      def initialize(
        survey,
        group,
        group_variable_types: ['PE', 'E'],
        table_type: false
      )

        @survey = survey
        @group = group
        @group_variable_types = group_variable_types
        @table_type = table_type
      end

      def self.perform(*args, **kwargs)
        new(*args, **kwargs).perform
      end

      def perform
        import_group
      end

      def import_group
        response = HTTParty.get(group_url).as_json
        statistics = {}
        response['variables'].each do |variable, details|
          next unless correct_variable_type?(variable)

          statistics[variable] = ::Census::Statistic.find_or_create_by(
            survey: survey,
            name: variable,
            label: details['label'],
            concept: details['concept'],
            group: details['group'],
            predicate_type: details['predicateType']
          )
        end

        statistics
      end

      def correct_variable_type?(variable)
        last_letters_regex = /.+[1-9](.+)/
        match = last_letters_regex.match(variable)
        return false unless match

        match.captures[0].in? group_variable_types
      end

      def group_url
        url = "https://api.census.gov/data/#{survey.year}/acs/#{survey.name}"
        url += "/#{table_type}" if table_type
        url += "/groups/#{group}.json"
        url
      end
    end
  end
end
