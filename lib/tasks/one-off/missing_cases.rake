
namespace :update do
  desc 'Update cases for data request'
  task missing_cases: [:environment] do
    resp = Bucket.new.get_object("missing_case_numbers.csv")
    data = CSV.parse(resp.body.read, headers: true)

    data.each do |row|
      Scrapers::OneOffCase.new('Oklahoma', row[0]).perform   
    end
  end
end