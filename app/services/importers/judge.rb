module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class Judge
    attr_reader :judge_name

    def initialize(judge_name, court_case, logs)
      @judge_matcher = Matchers::Judge.new(judge_name)
    end

    def self.perform(judge_name, court_case, logs)
      new(judge_name, court_case, logs).perform
    end

    def perform
      judge_matcher.judge_id
      # TODO: Fuzzy search for judge name
      # TODO: If judge does not exist, create one
      # TODO: Log if judge is not active
    end
  end
end
