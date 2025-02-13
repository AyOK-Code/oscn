module Importers
  module NacokCrime
    class Page < ApplicationService
      def perform
        scrape_pdfs
      end

      def scrape_pdfs
        url = 'https://nacok.org/crime-reports/'
        html = HTTParty.get(url)
        parsed_data = Nokogiri::HTML(html)

        pdf_links = parsed_data.css("a[href*='NA-Crime-Report']")
        bar = ProgressBar.new(pdf_links.count)
        pdf_links.each do |pdf_link|
          bar.increment!
          Pdf.perform(pdf_link['href'])
        end
      end
    end
  end
end
