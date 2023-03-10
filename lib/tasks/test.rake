namespace :testtest do
  desc 'do the thing'
  task testyo: [:environment] do
    case_number = 'SC-2014-5923'
    county = 55
    # Importers::CaseHtml.perform(county, case_number)
    Importers::CourtCase.perform(county, case_number)
  end
end
