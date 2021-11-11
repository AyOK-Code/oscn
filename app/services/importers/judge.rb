module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class Judge
    attr_reader :judge_name, :court_case, :logs, :judges

    def initialize(judge_name, court_case, logs)
      @judges = ::Judge.pluck(:name, :id).to_h
      @judge_name = judge_name
      @court_case = court_case
      @logs = logs
    end

    def self.perform(judge_name, court_case, logs)
      new(judge_name, court_case, logs).perform
    end

    def perform
      find_or_create_judge(judge_name)
    end

    private

    def find_or_create_judge(judge_name)
      judge_id = judges[judge_name]
      return judge_id if judge_id

      new_judge = ::Judge.create(name: judge_name, county_id: court_case.county_id)
      court_case.update(current_judge_id: new_judge.id)
    end
  end
end
