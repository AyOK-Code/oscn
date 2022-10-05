namespace :okc_blotter do
  desc 'Scape and parse'
  task import_new: [:environment] do
    Importers::OkcBlotter::Pdf.import_since_last_run
  end

  task import_missing: [:environment] do
    Importers::OkcBlotter::Pdf.import_missing_dates
  end
end
