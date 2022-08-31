namespace :okc_blotter do
  desc 'Scape and parse'
  task scrape_and_parse: [:environment] do
    Importers::OkcBlotter::Pdf.download_all_available('2022-08-30')
  end
end