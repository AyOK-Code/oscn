module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class Judge
    attr_reader :judge_name, :court_case, :logs, :judges

    def initialize(judge_name, court_case, logs)
      @judges = ::Judge.pluck(:name, :id).to_h
      @judge_name = judge_name.first[:judge]
      @court_case = court_case
      @logs = logs
    end

    def self.perform(judge_name, court_case, logs)
      new(judge_name, court_case, logs).perform
    end

    def perform
      

      return if judges[judge_name].nil?

      court_case.update(current_judge_id: judges[judge_name])

    end
  end
end
