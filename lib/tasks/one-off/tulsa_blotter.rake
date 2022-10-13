namespace :import do
  desc 'Import Tulsa Bookings'
  task tulsa_import: :environment do
    file = File.read('lib/tulsa_county_jail_bookings.csv')
    data = CSV.parse(file, headers: true)
    # data[636] OK
    # data[114] 2,1
    # data[46] 2 offenses 1 case number
    # Inmates: Last Name	First Name	Middle Name	Booking ID Gender	Inmate ID	Race	Address	City/State/Zip
    # Height	Weight	Hair Color	Eye Color
    # Arrests: Booking Date Arrest Date	Arrest Time	Arresting Agency	Arresting Officer
    #	Booking Time	Release Date	Release Time
    # Offenses:(description) 	Case Numbers	Court Dates	Bond Types	Bond Amounts	Dispositions
    data.each do |row|
      # row = data[35154]

      def tulsa_blotter_date(date,time)

      end

      next if row['Inmate ID'].nil?

      arrest = TulsaBlotter::Arrest.create(dlm: row['Inmate ID'], first: row['First Name'],
                                           middle: row['Middle Name'], last: row['Last Name'],
                                           gender: row['Gender'], race: row['Race'],
                                           address: row['Address'], zip: row['City/State/Zip'],
                                           height: row['Height'], weight: row['Weight'],
                                           hair: row['Hair Color'], eyes: row['Eye Color'], mugshot: row['Mugshot'],booking_id: row['Booking ID'])

      arrest.last_scraped_at = if row['Updated'].nil? || row['Updated'].include?('N/A')
                                 nil
                               else
                                 Date.strptime(
                                   row['Updated'], '%m/%d/%Y'
                                 )
                               end
      # inmate.mugshot = row['Mugshot']

      

      arrest.arrested_by = row['Arresting Officer']
      # arrest.tulsa_blotter_inmates_id = inmate.id
      date = if row['Arrest Date'].nil? || row['Arrest Date'].include?('N/A')
               nil
             else
               Date.strptime(row['Arrest Date'],
                             '%m/%d/%Y')
             end

      time = row['Arrest Time'].nil? || row['Arrest Time'].include?('N/A') ? nil : row['Arrest Time'].to_time(:cst)
      dt = date.nil? || time.nil? ? nil : DateTime.new(date.year, date.month, date.day, time.hour, time.min)
      arrest.arrest_date = dt
      arrest.arresting_agency = row['Arresting Agency']
      bdate = if row['Booking Date'].nil? || row['Booking Date'].include?('N/A')
                nil
              else
                Date.strptime(
                  row['Booking Date'], '%m/%d/%Y'
                )
              end
      btime = row['Booking Time'].nil? || row['Booking Time'].include?('N/A') ? nil : row['Booking Time'].to_time(:cst)
      bdt = bdate.nil? || btime.nil? ? nil : DateTime.new(bdate.year, bdate.month, bdate.day, btime.hour, btime.min)
      arrest.booking_date = bdt
      rdate = if row['Release Date'].nil? || row['Release Date'].include?('N/A')
                nil
              else
                Date.strptime(
                  row['Release Date'], '%m/%d/%Y'
                )
              end
      rtime = row['Release Time'].nil? || row['Release Time'].include?('N/A') ? nil : row['Release Time'].to_time(:cst)
      rdt = rdate.nil? || rtime.nil? ? nil : DateTime.new(rdate.year, rdate.month, rdate.day, rtime.hour, rtime.min)
      arrest.release_date = rdt
      arrest.freedom_date = row['Freedom Date'].include?('N/A') ? nil : Date.strptime(row['Freedom Date'], '%m/%d/%Y')
      arrest.save!

      
      # Offenses:(description) 	Case Numbers	Court Dates	Bond Types	Bond Amounts	Dispositions
      row['Offenses'].nil? ? next : (row['Offenses'].sub! ', OK', ' OK')

      row['Offenses'].sub! ', TENNESSEE', ' TENNESSEE'
      descriptions = row['Offenses'].split(',')
      case_numbers = row['Case Numbers'].split(',')
      court_dates = row['Court Dates'].split(',')
      bond_types = row['Bond Types'].split(',')
      bond_amounts = row['Bond Amounts'].split
      dispositions = row['Dispositions'].split(',')

      descriptions.each_with_index do |desc, index|
        offense = TulsaBlotter::Offense.create(arrest: arrest,
                                               description: desc, case_number: case_numbers[index],
                                               court_date: court_dates[index], bond_type: bond_types[index],
                                               bound_amount: bond_amounts[index], disposition: dispositions[index])

        
        offense.save!
      end
    end
  end
end
