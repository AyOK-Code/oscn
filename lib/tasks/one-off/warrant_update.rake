# rubocop:disable Metrics/BlockLength

namespace :warrants do
  desc 'Pull in attorneys from OK Bar site'
  task update: [:environment] do
    filepath = 'warrants.csv'
    credentials = Aws::Credentials.new(ENV['BUCKETEER_AWS_ACCESS_KEY_ID'], ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'])
    Aws.config.update(
      region: 'us-east-1',
      credentials: credentials
    )
    s3 = Aws::S3::Client.new

    resp = s3.get_object(bucket: ENV['BUCKETEER_BUCKET_NAME'], key: filepath)

    cases = CSV.parse(resp.body.read, headers: true)
    county = County.find_by(name: 'Oklahoma')
    court_cases = county.court_cases.pluck(:case_number, :id).to_h
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      bar.increment!
      case_id = court_cases[c['Case #']]
      next if case_id.nil?

      CourtCaseWorker
        .set(queue: :default)
        .perform_async(county.id, c['Case #'], true)

      CaseParty.where(court_case_id: case_id).each do |cp|
        PartyWorker.perform_in(1.hour, cp.party.oscn_id)
      end
    end
  end

  desc 'Merge data with warrants list'
  task merge: [:environment] do
    filepath = 'warrants.csv'
    credentials = Aws::Credentials.new(ENV['BUCKETEER_AWS_ACCESS_KEY_ID'], ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'])
    Aws.config.update(
      region: 'us-east-1',
      credentials: credentials
    )
    s3 = Aws::S3::Client.new

    resp = s3.get_object(bucket: ENV['BUCKETEER_BUCKET_NAME'], key: filepath)
    county = County.find_by(name: 'Oklahoma')
    temp = Tempfile.new('warrants_complete.csv')
    court_cases = county.court_cases.pluck(:case_number, :id).to_h

    current = Time.now.utc.to_date.year

    CSV.open(temp, 'w') do |temp_csv|
      warrants = CSV.parse(resp.body.read, headers: true)
      bar = ProgressBar.new(warrants.count)
      count_headers = (1..30).to_a.map do |e|
        ["count_#{e}_status", "count_#{e}_as_disposed", "count_#{e}_description"]
      end.flatten

      temp_csv << (['warrant_number', 'case_number', 'party', 'bond_amount', 'hold', 'date_issued', 'judge',
                    'warrant_type', 'party_id', 'birth_month', 'birth_year', 'age', 'zip'] + count_headers).flatten

      warrants.each do |warrant|
        bar.increment!
        case_id = court_cases[warrant['Case #']]

        if case_id.nil?
          party = nil
          address = nil
          age = nil
        else
          court_case = CourtCase.find(case_id)
          party_map = court_case.parties.pluck(:full_name, :oscn_id).to_h { |a| [a[0].squish, a[1]] }
          party = Party.find_by(oscn_id: party_map[warrant['Party']])
          address = party&.addresses&.current&.first
          age = party&.birth_year.present? ? current - party&.birth_year : nil
          counts = court_case.counts.where(party_id: party&.id)
        end

        warrant << { oscn_id: party&.oscn_id }
        warrant << { birth_month: party&.birth_month }
        warrant << { birth_year: party&.birth_year }
        warrant << { age: age }
        warrant << { zip: address&.zip }

        if counts.present?
          counts.each_with_index do |count, i|
            warrant << { "count_#{i + 1}_status": count&.verdict&.name }
            warrant << { "count_#{i + 1}_as_disposed": count.charge }
            warrant << { "count_#{i + 1}_description": count.disposition }
          end
        end

        temp_csv << warrant
      end
    end

    s3.put_object(bucket: ENV['BUCKETEER_BUCKET_NAME'],
                  key: 'warrants_complete.csv',
                  body: File.read(temp))
  end
end

# rubocop:enable Metrics/BlockLength
