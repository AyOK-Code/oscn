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
      html = HTTParty.get(base_url)
      parsed_data = Nokogiri::HTML(html.body)
      data = parsed_data.css('select[name="Judge"]')
      data.css('option').each do |o|
        j = Judge.find_or_initialize_by(oscn_id: o['value'])
        j.name = o.text
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
