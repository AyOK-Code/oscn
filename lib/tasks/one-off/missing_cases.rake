
namespace :update do
  desc 'Update cases for data request'
  task missing_cases: [:environment] do
    resp = Bucket.new.get_object("missing_case_numbers.csv")
    data = CSV.parse(resp.body.read, headers: true)

    data.each do |row|
      OneOffCaseWorker
          .set(queue: :high)
          .perform_async('Oklahoma', row[0])
    end
  end
end