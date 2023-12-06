require 'open-uri'
module Scrapers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFireExtraction
    def initialize
      @year = 2023
      @month = 'july'
      @base_url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
      @date = '07/10/2023'
    end

    def self.perform
      new.perform
    end

    def perform
      html = URI.parse(@base_url.to_s).open
      parsed_data = Nokogiri::HTML(html)
      date_text = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].text
      date_link = parsed_data.xpath("//a[contains(text(), '#{@date}')]")[0].attribute_nodes[0].text
      pdf_link = URI.parse(date_link).open
      puts "file for #{date_text}"
      { pdf: pdf_link }
    end
  end
end
