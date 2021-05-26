require 'open-uri'

namespace :save do
  desc 'Pull judges for a county'
  task :judges, [:county_name] do |_t, args|
    county_name = args.county_name
    puts "Pulling in judges for #{county_name}"
    county_id = County.find_by(name: county_name).id
    judges_url = "https://www.oscn.net/courts/#{county_name.downcase}"
    html = URI.open(judges_url)
    data = Nokogiri::HTML(html.read)

    district_judges = data.xpath('//h3[contains(text(), "District Judges")]/following-sibling::*')
    associate_judges = data.xpath('//h3[contains(text(), "Associate District Judges")]/following-sibling::*')
    special_judges = data.xpath('//h3[contains(text(), "Special Judges")]/following-sibling::*')

    district_judges.css('.judges').first.css('.judge').each do |j|
      name = j.css('.judgeName').text.squish
      courthouse = j.css('.address').children&.first&.text
      Judge.find_or_create_by!(
        { name: name, courthouse: courthouse, judge_type: 'District', county_id: county_id }
      )
    end

    associate_judges.css('.judges').first.css('.judge').each do |j|
      name = j.css('.judgeName').text.squish
      courthouse = j.css('.address').children&.first&.text
      Judge.find_or_create_by!(
        { name: name, courthouse: courthouse, judge_type: 'Associate District', county_id: county_id }
      )
    end

    special_judges.css('.judges').first.css('.judge').each do |j|
      name = j.css('.judgeName').text.squish
      courthouse = j.css('.address').children&.first&.text
      Judge.find_or_create_by!(
        { name: name, courthouse: courthouse, judge_type: 'Special', county_id: county_id }
      )
    end
  end
end
