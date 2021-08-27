module Scrapers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class Attorney
    attr_accessor :base_url, :state_abreviation

    def initialize(state_abreviation = 'OK')
      @base_url = 'https://www.okbar.org/oba-member-search/?'
      @state_abreviation = state_abreviation
    end

    def self.perform(state_abreviation = 'OK')
      new(state_abreviation).perform
    end

    def perform
      url = "pagenum=1&sort%5B5%5D=desc&filter_11=#{state_abreviation}&mode=all"

      html = URI.parse("#{base_url}#{url}").open
      parsed_data = Nokogiri::HTML(html.body)
      pages = (1..page_count(parsed_data)).to_a
      bar = ProgressBar.new(pages.count)
      pages.each do |page_number|
        process_data(page_number)
        bar.increment!
      end
    end

    def process_data(page_number)
      url = "#{base_url}pagenum=#{page_number}&sort%5B5%5D=desc&filter_11=#{state_abreviation}&mode=all"
      html = URI.parse(url).open
      parsed_data = Nokogiri::HTML(html.body)
      table_rows = parsed_data.css('tbody tr')
      table_rows.each do |row|
        save_attorney(row)
      end
    end

    def save_attorney(row)
      c = Counsel.find_or_initialize_by(bar_number: bar_number(row))
      c.assign_attributes(extract_data(row))
      c.save
    end

    def extract_data(row)
      {
        first_name: first_name(row),
        middle_name: middle_name(row),
        last_name: last_name(row),
        city: city(row),
        state: state(row),
        member_type: member_type(row),
        member_status: member_status(row),
        admit_date: admit_date(row),
        ok_bar: true
      }
    end

    def first_name(row)
      row.css('#gv-field-6-1').text
    end

    def middle_name(row)
      row.css('#gv-field-6-2').text
    end

    def last_name(row)
      row.css('#gv-field-6-3').text
    end

    def city(row)
      row.css('#gv-field-6-4').text
    end

    def state(row)
      row.css('#gv-field-6-11').text
    end

    def member_type(row)
      row.css('#gv-field-6-5').text
    end

    def member_status(row)
      row.css('#gv-field-6-6').text
    end

    def admit_date(row)
      Date.strptime(row.css('#gv-field-6-8').text, '%m/%d/%Y')
    end

    def bar_number(row)
      row.css('#gv-field-6-9').text.to_i
    end

    def page_count(parsed_data)
      numbers = parsed_data.css('.page-numbers')
      max = numbers.map { |t| t.text.to_i }.max
      max.blank? ? 1 : max
    end
  end
end
