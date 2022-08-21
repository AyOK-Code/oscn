module Scrapers
  class Judges
    attr_accessor :base_url

    def initialize
      @base_url = 'https://www.oscn.net/applications/oscn/report.asp?report=WebJudicialDocketJudgeAll'
    end

    def self.perform
      new.perform
    end

    def perform
      # rubocop:disable Layout/LineLength
      user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36'
      accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
      # rubocop:enable Layout/LineLength
      HTTParty::Basement.debug_output $stdout
      HTTParty::Basement.http_proxy('shorelinetechnicalsales.com', nil, nil, nil)
      html = HTTParty.get(base_url, headers: {
                            'User-Agent': user_agent,
                            'Accept-Encoding': 'gzip, deflate, br',
                            'Accept-Language': 'en-US,en;q=0.9,es;q=0.8',
                            Accept: accept
                          })
      parsed_data = Nokogiri::HTML(html.body)
      data = parsed_data.css('select[name="Judge"]')
      data.css('option').each do |o|
        j = Judge.find_or_initialize_by(oscn_id: o['value'])
        j.name = o.text.chomp(',')
        j.first_name = o.text.split(',')[1]&.squish
        j.last_name = o.text.split(',')[0]&.squish
        j.save!
      end
    end

    private

    def last_name(row)
      row.css('#gv-field-6-3').text
    end
  end
end
