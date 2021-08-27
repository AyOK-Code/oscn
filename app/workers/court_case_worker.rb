require 'importers/court_case'

class CourtCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(case_number)
    ::Importers::CaseHtml.perform(case_number)
    ::Importers::CourtCase.perform(case_number)
  end
end
