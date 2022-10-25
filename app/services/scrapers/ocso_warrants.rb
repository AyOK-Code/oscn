module Scrapers
    class OcsoWarrants

        def self.perform
            html = OcsoScraper::Crawler.request
        end

    end


end