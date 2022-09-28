namespace :import do
    desc 'Import Tulsa Bookings'
    task tulsa_import: :environment do
      file = File.read('lib/tulsa_county_jail_bookings.csv')
      data = CSV.parse(file, headers: true)
      #data[636] OK
      #data[114] 2,1
      #data[46] 2 offenses 1 case number
      #Inmates: Last Name	First Name	Middle Name	Booking ID Gender	Inmate ID	Race	Address	City/State/Zip
      #Height	Weight	Hair Color	Eye Color
      #Arrests: Booking Date Arrest Date	Arrest Time	Arresting Agency	Arresting Officer	Booking Time	Release Date	Release Time
      #Offenses:(description) 	Case Numbers	Court Dates	Bond Types	Bond Amounts	Dispositions
      data.each  do |row| 
       
        inmate =  TulsaBlotter::Inmate.create(dlm:row["Inmate ID"])
        inmate.first = row["First Name"]
        inmate.middle = row["Middle Name"]
        inmate.last = row["Last Name"]
        inmate.booking_id = row["Booking ID"]
        inmate.gender = row["Gender"]
        inmate.race = row["Race"]
        inmate.address = row["Address"]
        inmate.zip = row["City/State/Zip"]
        inmate.height = row["Height"]
        inmate.weight = row["Weight"]
        inmate.hair = row["Hair Color"]
        inmate.eyes = row["Eye Color"]
        binding.pry

        arrest = TulsaBlotter::Arrest.create(arrested_by:row["Arresting Officer"])




        row["Offenses"].sub! ', OK', ' OK'
        row["Offenses"].sub! ', TENNESSEE', ' TENNESSEE'
        offenses= row["Offenses"].split(',')
        case_numbers = row["Case Numbers"].split(',')
        court_dates = row["Court Dates"].split(',')



        
      end

    end
end