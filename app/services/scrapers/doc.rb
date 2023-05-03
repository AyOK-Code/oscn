require 'zip'

module Scrapers
  # Save detailed Party information
  class Doc < ApplicationService
    def initialize(dir)
      @dir = dir
    end

    def perform
      scrape_to_s3
    end

    def scrape_to_s3
      input = HTTParty.get(download_link).body
      Zip::InputStream.open(StringIO.new(input)) do |io|
        while entry = io.get_next_entry
          content = io.read
          filename = entry.name
          Bucket.new.put_object("doc/#{@dir}/#{filename}", content)
        end
      end
    end

    def download_link
      domain = "https://oklahoma.gov"
      request = HTTParty.get("#{domain}/doc/communications/odoc-public-inmate-data.html")
      dom = Nokogiri::HTML(request.body)
      path = dom.css("a:contains('download here')").first["href"]
      "#{domain}#{path}"
    end
  end
end