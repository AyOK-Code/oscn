
namespace :update do
  desc 'Update cases for data request'
  task missing_cases: [:environment] do
    data = Bucket.new.get_object("missing_case_numbers.csv")

    data.each do |row|
      
    end
  end
end