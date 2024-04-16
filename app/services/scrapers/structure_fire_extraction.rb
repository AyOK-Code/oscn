require 'open-uri'
module Scrapers
  class StructureFireScraper
    attr_reader :year, :month, :url, :date
    
    def initialize(year, month, date)
      @year = year
      @month = month
      @url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
      @date = date
    end

    def self.perform
      new(year, month, date).perform
    end

    def perform
      filename = @date.gsub('/', '_')
      filepath = "fire_pdfs/#{filename}.pdf"
      
      pdf_file = nil
      begin
       # html = URI.parse(@base_url.to_s).open
        url = URI.parse(@base_url.to_s)
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
        }
        parsed_data = Nokogiri::HTML(html)
        date_text = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].text
        date_link = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].attribute_nodes[0].text
        binding.pry
        pdf_link = URI.parse(date_link).open
        File.open(filepath, 'wb') do |file|
          file << pdf_link.read
          pdf_file = file
        end
      rescue StandardError => e
        puts e
        puts "missed:#{filename}"
        fire_link = { pdf_date_on: @date, pdf: nil, url: filename, filepath: nil, filename: filename }
        fire_structure = {}
        json_array = [fire_link, fire_structure]
        return json_array
      end

      puts "file for #{filename}"
      binding.pry
      fire_link = { pdf_date_on: date_text, pdf: pdf_link, url: date_link, filepath: filepath, filename: filename }
      fire_structure = {}
      [fire_link, fire_structure]
    end
  end
end
