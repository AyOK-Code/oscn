require 'open-uri'
module Scrapers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFireExtraction
    def initialize(year,month,date)
      @year = year
      @month = month
      @base_url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
      @date = date
    end

    def self.perform
      new(year,month,date).perform
    end

    def perform
      filename = @date.gsub("/", "_")
      filepath = "fire_pdfs/#{filename}.pdf"
      pdf_file = nil
      html = URI.parse(@base_url.to_s).open
      parsed_data = Nokogiri::HTML(html)
      date_text = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].text
      date_link = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].attribute_nodes[0].text
      pdf_link = URI.parse(date_link).open
      open(filepath, 'wb') do |file|
        file << pdf_link.read
        pdf_file = file
      end

      puts "file for #{filename}"
     fire_link =  { pdf_date_on: date_text,pdf: pdf_link,url: date_link,filepath:filepath,filename:filename }
     fire_structure= {}
     json_array = [fire_link,fire_structure]
     return json_array
    end
  end
end
