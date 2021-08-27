namespace :import do
  desc "Import Oklahoma List Statutes"
  task :statutes do
    file = File.open('lib/data/ok_statutes.csv').read
    data = CSV.parse(file, headers: true)

    # TODO: Change to pull from S3 file or directly from site with file
    data.each do |row|
      next if row[4].nil?
      os = OklahomaStatute.find_or_initialize_by(code: row[0])
      os.code = row[0]
      os.ten_digit = row[1]
      os.severity = row[2]
      os.description = row[3]
      os.update_status = row[5]
      begin
        os.effective_on = Date.strptime(row[4], '%Y/%m/%d') unless row[4].nil?
        os.save!
      rescue
        puts 'Failure'
      end
    end
  end
end
