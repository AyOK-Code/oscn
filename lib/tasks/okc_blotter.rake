namespace :okc_blotter do
  desc 'Scape and parse'
  task scrape_and_parse: [:environment] do
    Importers::OkcBlotter::Pdf.import_from_website('2022-09-01')
  end
end