require 'open-uri'
module Scrapers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFireExtraction
    def initialize(year, month, date)
      @year = year
      @month = month
      @base_url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
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
        uri =URI.parse(@base_url.to_s)
        req = Net::HTTP::Get.new(uri)
        req['authority'] = 'www.okc.gov'
        req['method'] = 'GET'
        req['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
        req['Accept-Encoding']='gzip, deflate, br'
        req['Accept-Language'] = 'en-US,en;q=0.9'
        req['Cache-Control'] = 'no-cache'
        req['Cookie'] = '_ga=GA1.1.1577221898.1708025693; lo-uid=1be3603f-1709052475901-e9523e20678aea54; ASP.NET_SessionId=0iodfacfsmdjk4eybhjw1p1x; BIGipServer~AUTO-VISION~visionlive~www.okc.gov_443=!r9Wf5nLzygc7pEOIGJNzZ/T8tG8qhN8wokg1tyqYmplMhVobM73b+IoFkscltpF4WYuzo5QnuCJqzX0=; __RequestVerificationToken=ZNl_Tm2eaob2oTuc2KHFlWW1LpbKjnHg2m207wWmpVOixYCbhhgTlbSEZKlAzaJ8mowFRB8tVOkleWS5qy1VSDe4XwsB9HOM7CapOCdnIuo1; TS01af151e=0106cf681b28ddaaf38fbc3d8b052b7769ffa02abefea006f8571141653e3913a92f4f9f074fa95df7545f4743cc57c9702fab4285ed987d367f3fe79b8504a417b887c3998dea4ebc0bf5585470c203cf02ed791fa791593778a247f12fd1c6dcd36729d8; lo-visits=5; _ga_QJZMQ79KHZ=GS1.1.1711138246.8.1.1711138314.0.0.0; TS3b44c919027=08b9428c85ab20000f462841719bbd0ec17b1bfc88f1e26ff3dcec71b367beb424f4bd87641912c808b4c811811130006b32bfae425a44744f37c73c8c70255fada63ab2f2fca9d01643af472735133191a7f110a1d21ffdcd775742b71f3912'
        binding.pry
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
