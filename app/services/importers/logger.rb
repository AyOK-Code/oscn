module Importers
  # Logs issues that occurred with importing the data
  class Logger
    attr_accessor :logs, :court_case

    def initialize(court_case)
      @logs = {}
      @court_case = court_case
    end

    def update_logs
      if logs.present?
        court_case.update(logs:)
      else
        court_case.update(logs: nil)
      end
    end

    def create_log(table, message, data)
      logs[table.to_s] = { message:, data: }
    end
  end
end
