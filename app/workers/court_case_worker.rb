class CourtCaseWorker
  include Sidekiq::Worker

  def perform(case_number)
    Importers::CaseHtml.perform(case_number)
    Importers::CourtCase.perform(case_number)
  end
end
