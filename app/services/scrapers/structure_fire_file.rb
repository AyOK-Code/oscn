module Scrapers
  class StructureFireFile
    attr_reader :year, :month, :url, :date, :date_object

    def initialize(year, month, date)
      @year = year
      @month = month
      # @url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
      @url = 'https://www.okc.gov/departments/fire/daily-structure-fires/2024/january'
      @date = date
      @date_object = Date.parse(date)
    end

    def self.perform
      new(year, month, date).perform
    end

    def perform
      filename = date_object.strftime('%m_%d_%Y')
      filepath = "fire_pdfs/#{filename}.pdf"
      begin
        html = HTTParty.get(url, headers: headers)
        parsed_data = Nokogiri::HTML(html)
        date_text = parsed_data.xpath("//a[contains(text(), '#{date}')]")[0].text
        date_link = parsed_data.xpath("//a[contains(text(), '#{date}')]")[0].attribute_nodes[0].text
        pdf_data = HTTParty.get(date_link, headers: pdf_headers, follow_redirects: true)

        fire = StructureFireLink.find_or_initialize_by(pdf_date_on: date_object, url: date_link)
        fire.pdf.attach(io: StringIO.new(pdf_data), filename: "#{filename}.pdf")
        fire.save!
      rescue StandardError => e
        puts "missed:#{filename}"
        fire_link = { pdf_date_on: @date, pdf: nil, url: filename, filepath: nil, filename: filename }
        fire_structure = {}
        json_array = [fire_link, fire_structure]
        return json_array
      end
    end

    private

    def headers
      {
        'Content-Type' => 'text/html',
        'Referer' => "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}",
        'Accept-Encoding' => 'gzip, deflate, br, zstd',
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
      }
    end

    def pdf_headers
      {
        'Content-Type' => 'application/pdf',
        'Referer' => "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}",
        'Accept-Encoding' => 'gzip, deflate',
        "Accept" => "application/pdf, text/plain;q=0.5",
        'Cookie' => cookies.map { |k,v| "#{k}=#{v}" }.join('; '),
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
      }
    end


    def cookies
      {
        'ASP.NET_SessionId' => 'jo3kgcfepnyo5yjsxtok4sxo',
        'BIGipServer~AUTO-VISION~visionlive~www.okc.gov_443' => '!EXWvnRhboM/sAoaIGJNzZ/T8tG8qhNrwotO1wTKOZsgRoF3eX73307UkIshZE13bgd0/+kAZ9K+R0Bk=',
        'TS3b44c919027' => '08b9428c85ab2000c39611d52388acbc47c547392515bd85d280c2039121474f8de4e49b0a1e850d083d3f62ea11300029bf2858494124f2bf204cd529667fd7a06b2b10f4dc6446bd9d867f748bb0cedd15c3d5f7bb42db9fa31d2db604e2a8',
        'TS01af151e' => '0106cf681bd8c2c18f6a3173690b151616814a75b6ec5c0fc27ee78064ad96bc132b9480927274d98aa237b83110607d97181ddcf3096ec027fa7a76978f7a66bc0a53ddc3e60f24a08b02fcde45d10de542d0adf9'
      }
    end
  end
end
