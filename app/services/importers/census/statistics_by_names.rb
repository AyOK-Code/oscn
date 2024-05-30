module Importers
  module Census
    class StatisticsByNames
      attr_accessor :survey, :variables, :table_type

      def initialize(
        survey,
        variables,
        table_type: nil
      )

        @survey = survey
        @variables = variables
        @table_type = table_type
      end

      def self.perform(*args)
        new(*args).perform
      end

      def perform
        import_statistics
      end

      def import_statistics
        response = HTTParty.get(variable_url).as_json
        statistics = {}
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
        statistics
      end

      def variable_url
        "https://api.census.gov/data/#{survey.year}/acs/#{survey.name}/variables.json"
      end
    end
  end
end
