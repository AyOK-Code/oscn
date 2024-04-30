namespace :structure_fire do
  desc 'Pull structure fire pdfs'
  task historical_files: :environment do
    start_date = Date.parse('07/10/2023')
    end_date = Date.today

    # Collect all first dates from each month between start_date and end_date
    dates = (start_date..end_date).select do |date|
      date.day == 1
    end

    dates.each do |date|
      puts "Processing #{date.month}/#{date.year}"
      Importers::StructureFireLink.perform(date)
    end
  end

  desc 'Extract data from structure fire pdfs'
  task extract_data: :environment do
    StructureFireLink.pending.each do |link|
      binding.pry
      begin
        results = AzureFireExtractor.new(link.pdf.url).perform
        Importers::StructureFire.perform(results)
        link.update(status: 1)
      rescue StandardError => e
        puts "Error processing #{link.pdf_date_on}: #{e}"
        # link.update(status: 2)
      end
    end
  end
end
