module Importers
  class StructureFireLink
    attr_reader :date, :year, :month, :url, :full_month

    def initialize(date, full_month: true)
      @date = date
      @year = date.year.to_s
      @month = date.strftime('%B').downcase
      @full_month = full_month
      @url = "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}"
    end

    def self.perform(date)
      new(date).perform
    end

    def perform
      start_date = date.beginning_of_month.to_date
      end_date = date.end_of_month.to_date

      dates = if full_month
                (start_date..end_date).to_a
              else
                [date]
              end
      html = HTTParty.get(url, headers: headers)
      parsed_data = Nokogiri::HTML(html)
      bar = ProgressBar.new(dates.count)

      dates.each do |d|
        sleep (1..3).to_a.sample
        bar.increment!
        filename = d.strftime('%Y-%m-%d')

        begin
          date_link = date_node(parsed_data, d)
          pdf_data = HTTParty.get(date_link, headers: pdf_headers, follow_redirects: true)
          fire_link = ::StructureFireLink.find_or_initialize_by(pdf_date_on: d, external_url: date_link)
          fire_link.pdf.attach(io: StringIO.new(pdf_data), filename: "#{filename}.pdf")
          fire_link.save!
        rescue StandardError => e
          Raygun.track_exception(e, custom_data: { date: d, url: date_link, filename: 'StructureFireLink' })
        end
      end
    end

    private

    def date_node(parsed_data, date_object)
      date_search = date_object.strftime('%-m/%-d/%Y')
      begin
        parsed_data.xpath("//a[contains(text(), '#{date_search}')]")[0].attribute_nodes[0].text
      rescue StandardError
        date_search = date_object.strftime('%m/%d/%Y')
        parsed_data.xpath("//a[contains(text(), '#{date_search}')]")[0].attribute_nodes[0].text
      end
    end

    # rubocop:disable Layout/LineLength
    def headers
      {
        'Content-Type' => 'text/html',
        'Referer' => "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}",
        'Accept-Encoding' => 'gzip, deflate, br, zstd',
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
      }
    end
    # rubocop:enable Layout/LineLength

    # rubocop:disable Layout/LineLength
    def pdf_headers
      {
        'Content-Type' => 'application/pdf',
        'Referer' => "https://www.okc.gov/departments/fire/daily-structure-fires/#{@year}/#{@month}",
        'Accept-Encoding' => 'gzip, deflate',
        'Accept' => 'application/pdf, text/plain;q=0.5',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
      }
    end
    # rubocop:enable Layout/LineLength
  end
end
