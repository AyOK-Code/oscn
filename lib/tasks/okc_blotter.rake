namespace :okc_blotter do
  desc 'Scape and parse'
  task scrape_and_parse: [:environment] do
    Importers::OkcBlotter::Pdf.import_since_last_run
   end
end