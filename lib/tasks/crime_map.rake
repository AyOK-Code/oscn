namespace :crime_map do
  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import: [:environment] do
    Importers::CrimeMap.perform
  end

  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import_historic: [:environment] do
    # Scrapers::NacokCrime::Page.perform
    results = Scrapers::NacokCrime::Pdf.perform('https://nacok.org/wp-content/uploads/2024/10/NA-Crime-Report-9-1-2024-to-9-30-2024.pdf')
    crimes = Importers::CrimeMap.perform
    recent = results.flatten.compact
                    .group_by{|v| v['Case Number']}
                    .map{|k, v| v[0]}
                    .select{|v| Date.parse(v["Date"]) > Date.parse("2024-09-23")}
    missing_example = recent
                        .select{|v| v['Case Number'].in?(
                          recent.map {|v| v['Case Number']} - crimes.map{|v| v['IRNumber']}
                        )}
                        .sort_by{|v| Date.parse(v['Date'])}[-20]
  end
end

