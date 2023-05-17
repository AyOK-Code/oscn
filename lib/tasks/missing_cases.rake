namespace :update do
  desc 'Update cases for data request'
  task :missing_cases, [:county_name] => [:environment] do |_t, args|
    resp = Bucket.new.get_object('missing_case_numbers.csv')
    data = CSV.parse(resp.body.read, headers: true)

    data.each do |row|
      OneOffCaseWorker
        .set(queue: :high)
        .perform_async(arg.county_name, row[0])
    end
  end
end
