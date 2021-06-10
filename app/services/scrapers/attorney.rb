# Pulls accurate data from the OK Bar Association
class Attorney
  attr_accessor :base_url, :state_abreviation

  def initialize(state_abreviation = 'OK')
    @base_url = "https://www.okbar.org/oba-member-search/?"
    @state_abreviation = state_abreviation
  end

  def self.perform(state_abreviation = 'OK')
    self.new(state_abreviation).perform
  end

  def perform
    url = "pagenum=1&sort%5B5%5D=desc&filter_11=#{state_abreviation}&mode=all"

    html = URI.open("#{base_url}#{url}")
    parsed_data = Nokogiri::HTML(html.read)
    pages = (1..page_count(parsed_data)).to_a
    bar = ProgressBar.new(pages.count)
    pages.each do |page_number|
      process_data(page_number)
      bar.increment!
      sleep 3
    end
  end

  def process_data(page_number)
    html = URI.open("#{base_url}pagenum=#{page_number}&sort%5B5%5D=desc&filter_11=#{state_abreviation}&mode=all")
    parsed_data = Nokogiri::HTML(html.read)
    table_rows = parsed_data.css('tbody tr')
    table_rows.each do |row|
      save_attorney(row)
    end
  end

  def save_attorney(row)
    c = Counsel.find_or_initialize_by(bar_number: row.css('#gv-field-6-9').text.to_i)
    c.assign_attributes({
      first_name: row.css('#gv-field-6-1').text,
      middle_name: row.css('#gv-field-6-2').text,
      last_name: row.css('#gv-field-6-3').text,
      city: row.css('#gv-field-6-4').text,
      state: row.css('#gv-field-6-11').text,
      member_type: row.css('#gv-field-6-5').text,
      member_status: row.css('#gv-field-6-6').text,
      admit_date: Date.strptime(row.css('#gv-field-6-8').text, '%m/%d/%Y')
      })
      c.save
  end

  def page_count(parsed_data)
    numbers = parsed_data.css('.page-numbers')
    max = numbers.map { |t| t.text.to_i }.max
    max.blank? ? 1 : max
  end
end
