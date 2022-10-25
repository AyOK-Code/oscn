module Scrapers
    class OcsoWarrants

        def self.perform
            
            html = OcsoScraper::Crawler.request
            parsed_html = OcsoScraper::CrawlerParser.parser(html)
          #  puts parsed_html
            
            data = parsed_html.css('td font').children

            warrants = []

            data.each_slice(6) do |l,f,m,d,c,o|
                extra = c.text.split('   ')
                warrant= {
                    last:l.text,
                    first:f.text,
                    middle:m.text,
                    dob:d.text,
                    case:extra[0],
                    bond:extra[1],
                    issued:extra[2],
                    offense:o.text    
                }
                warrants << warrant
            end
            binding.pry
            
            
        end

    end


end